import express, { Request, Response, Router } from "express";
import { scrapper } from "../modules/scrapper/scrapper";
import { FORUM_URLS } from "../modules/scrapper/forums";

const router: Router = express.Router();

router.get("/", async (req: Request, res: Response) => {
  try {
    const data = await scrapper.scrapeMantleLikeThread(
      FORUM_URLS.mantle.sampleThread
    );

    res.send(data);
  } catch (error: unknown) {
    console.error(error);
  }
});

export { router as experimentingRouter };
