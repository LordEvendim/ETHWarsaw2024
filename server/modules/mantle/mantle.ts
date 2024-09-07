import { generateRandomAddress } from "../../utils/address";

const userAddresses = new Map();

class Mantle {
  getAddressFromUsername(username: string) {
    if (userAddresses.has(username)) return userAddresses.get(username);

    const address = generateRandomAddress();

    userAddresses.set(username, address);

    return address;
  }
}

export const mantle = new Mantle();
