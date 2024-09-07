import express, { Request, Response, Router } from "express";
import { scrapper } from "../modules/scrapper/scrapper";
import { FORUM_URLS } from "../modules/scrapper/forums";
import { oracle } from "../modules/oracles/oracle";
import { keccak256, toUtf8Bytes } from "ethers";

const router: Router = express.Router();

router.get("/", async (req: Request, res: Response) => {
  try {
    // const data = await scrapper.scrapeMantleLikeThread(
    //   FORUM_URLS.mantle.sampleThread
    // );

    const data = await oracle.pushDataToOracle(
      "https://forum.mantle.xyz/t/feedback-digital-space-in-the-maia-model/8888"
    );

    res.send(data);
  } catch (error: unknown) {
    console.error(error);
  }
});

export { router as experimentingRouter };
