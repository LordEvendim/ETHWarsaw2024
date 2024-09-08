import { JsonRpcProvider, Signer, Wallet, ethers } from "ethers";

class Interactor {
  privateKey: string;
  provider: JsonRpcProvider;
  signer: Wallet;

  constructor() {
    this.privateKey = process.env.INTERACTOR_PRIVATE_KEY;
    this.provider = new ethers.JsonRpcProvider(process.env.JSON_PROVIDER_KEY);
    this.signer = new ethers.Wallet(this.privateKey, this.provider);
  }
}

export const interactor = new Interactor();
