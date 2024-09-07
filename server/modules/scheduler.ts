import { CronJob } from "cron";

import { scrapper } from "./scrapper/scrapper";
import { FORUM_URLS } from "./scrapper/forums";

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
          await scrapper.scrapeMantleLikeThread(FORUM_URLS.mantle.sampleThread);
        },
        null,
        true
      ),
    ];
  };
}

export const scheduler = new Scheduler();
