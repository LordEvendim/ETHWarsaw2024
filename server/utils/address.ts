import crypto from "crypto";
import { ethers } from "ethers";

export const generateRandomAddress = () => {
  return new ethers.Wallet("0x" + crypto.randomBytes(32).toString("hex"))
    .address;
};
