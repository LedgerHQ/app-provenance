import { expect } from 'chai';
import { describe, it } from 'mocha';
import SpeculosTransport from '@ledgerhq/hw-transport-node-speculos';
import Axios from 'axios';
import Transport from "./common";
import { Common } from "hw-app-obsidian-common";
import * as blake2b from "blake2b";
import { instantiate, Nacl } from "js-nacl";

let ignoredScreens = [ "W e l c o m e", "Cancel", "Working...", "Exit", "Rust App 0.0.1"]

let setAcceptAutomationRules = async function() {
    await Axios.post("http://localhost:5000/automation", {
      version: 1,
      rules: [
        ... ignoredScreens.map(txt => { return { "text": txt, "actions": [] } }),
        { "y": 16, "actions": [] },
        { "text": "Confirm", "actions": [ [ "button", 1, true ], [ "button", 2, true ], [ "button", 2, false ], [ "button", 1, false ] ]},
        { "actions": [ [ "button", 2, true ], [ "button", 2, false ] ]}
      ]
    });
}

let processPrompts = function(prompts: [any]) {
  let i = prompts.filter((a : any) => !ignoredScreens.includes(a["text"])); // .values();
  let header = "";
  let prompt = "";
  let rv = [];
  for (var ii in i) {
    let value = i[ii];
    if(value["y"] == 1) {
      if(value["text"] != header) {
        if(header || prompt) rv.push({ header, prompt });
        header = value["text"];
        prompt = "";
      }
    } else if(value["y"] == 16) {
      prompt += value["text"];
    } else {
      if(header || prompt) rv.push({ header, prompt });
      rv.push(value);
      header = "";
      prompt = "";
    }
  }
  if (header || prompt) rv.push({ header, prompt });
  return rv;
}

let sendCommandAndAccept = async function(command : any, prompts : any) {
    await setAcceptAutomationRules();
    await Axios.delete("http://localhost:5000/events");

    let transport = await Transport.open("http://localhost:5000/apdu");
    let client = new Common(transport, "rust-app");
    client.sendChunks = client.sendWithBlocks; // Use Block protocol
    let err = null;

    try { await command(client); } catch(e) {
      err = e;
    }
    if(err) throw(err);

    let result_prompts = (await Axios.get("http://localhost:5000/events")).data["events"] as [any];
    expect(processPrompts(result_prompts)).to.deep.equal(prompts);
}

describe('basic tests', () => {

  afterEach( async function() {
    await Axios.post("http://localhost:5000/automation", {version: 1, rules: []});
    await Axios.delete("http://localhost:5000/events");
  });

  it('provides a public key', async () => {

    await sendCommandAndAccept(async (client : Common) => {
      let rv = await client.getPublicKey("0");
      expect(Buffer.from(rv.address, 'hex').toString()).to.equal("pb17kkv9l2uvzmjv0z2gk25rs2880pfuk85meuqzc");
      expect(rv.publicKey).to.equal("0251ec84e33a3119486461a44240e906ff94bf40cf807b025b1ca43332b80dc9db");
      return;
    }, [
      { "header": "Provide Public Key", "prompt": "For Address pb17kkv9l2uvzmjv0z2gk25rs2880pfuk85meuqzc" },
    ]);
  });
});

let nacl : Nacl =null;

instantiate(n => { nacl=n; });

function testTransaction(path: string, txn: string, prompts: any[]) {
     return async () => {
       let sig = await sendCommandAndAccept(
         async (client : Common) => {

           let pubkey = (await client.getPublicKey(path)).publicKey;

           // We don't want the prompts from getPublicKey in our result
           await Axios.delete("http://localhost:5000/events");

           let sig = await client.signTransaction(path, Buffer.from(txn, "hex").toString("hex"));
           expect(sig.signature.length).to.equal(128);
	   // Skip verifying the signature
	   /*
           let hash = blake2b(32).update(Buffer.from(txn, "utf-8")).digest();
           let pass = nacl.crypto_sign_verify_detached(Buffer.from(sig.signature, 'hex'), hash, Buffer.from(pubkey, 'hex'));
           expect(pass).to.equal(true);
	  */
         }, prompts);
     }
}

describe("Protobufs tests", function() {
	this.timeout(30000);
	it("Can sign a transaction", 
	   testTransaction("0/0",
             "0a90010a8b010a1c2f636f736d6f732e62616e6b2e763162657461312e4d736753656e64126b0a29747031673575676665676b6c35676d6e3034396e35613968676a6e3367656430656b70386632667778122974703176786c63787032766a6e796a7577366d716e39643863713632636575366c6c6c7075736879361a130a056e68617368120a313630303030303030301200126d0a500a460a1f2f636f736d6f732e63727970746f2e736563703235366b312e5075624b657912230a2102da92ecc44eef3299e00cdf8f4768d5b606bf8242ff5277e6f07aadd935257a3712040a020801184e12190a130a056e68617368120a3137303238343532313010eefa041a0d70696f2d746573746e65742d3120ae59",[])
	  )
})

// describe("Signing tests", function() {
//   before( async function() {
//     while(!nacl) await new Promise(r => setTimeout(r, 100));
//   })

//   it("can sign a transaction",
//      testTransaction(
//        "0",
//        JSON.stringify({"testapp":true}),
//        [
//          {
//            "header": "Transaction hash",
//            "prompt": "a5dQl_ZMC3Onv0ldlZ9C-Nl75FXraTHpoipEGTdNzrQ",
//          },
//          {
//            "header": "Sign for Address",
//            "prompt": "7f916b907886913c6dd7ab62681fc52140afbc84"
//          },
//          {
//            "text": "Sign Transaction?",
//            "x": 19,
//            "y": 11
//          },
//          {
//            "text": "Confirm",
//            "x": 43,
//            "y": 11,
//          }
//        ]
//      ));
// });
