import { CronJob } from "cron";

import { scrapper } from "../scrapper/scrapper";
import { FORUM_URLS } from "../scrapper/forums";
import { interactor } from "../interactor/interactor";
import { oracle } from "../oracles/oracle";

const jobs = {
  pushForumData: () => {},
};

class Scheduler {
  jobs: CronJob[] = [];

  start = () => {
    console.log("Scheduler: scheduler started");

    this.jobs = [
      new CronJob(
        "0 0 * * *",
        async () => {
          const threadId = FORUM_URLS.mantle.sampleThread;

          await scrapper.scrapeMantleLikeThread(threadId);
          await oracle.pushDataToOracle(threadId);
        },
        null,
        true
      ),
    ];
  };
}

export const scheduler = new Scheduler();
