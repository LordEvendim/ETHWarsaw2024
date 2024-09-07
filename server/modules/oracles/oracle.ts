import { Contract, keccak256, toUtf8Bytes } from "ethers";
import { FORUM_ORACLE_ADDRESS } from "../contracts/addresses";
import ForumOracle from "../contracts/ForumOracle.json";
import { interactor } from "../interactor/interactor";
import { db } from "../../db/postgres";

class Oracle {
  async pushDataToOracle(threadId: string) {
    const forumOracle = new Contract(
      FORUM_ORACLE_ADDRESS,
      ForumOracle.abi,
      interactor.signer
    );

    const threadData = (await db`
    select 
    * 
    from threads
    where thread = ${threadId}
    `) as {
      usernmae: string;
      content: string;
      votes: string;
    }[];

    await forumOracle.pushThreadData(
      keccak256(toUtf8Bytes(threadId)),
      JSON.stringify(threadData)
    );
  }
}

export const oracle = new Oracle();
