import puppeteer from "puppeteer";
import { db } from "../../db/postgres";

interface MantleMessage {
  user: string;
  content: string;
  upvotes: number;
}

class Scrapper {
  async scrapeMantleLikeThread(url: string): Promise<MantleMessage[]> {
    const browser = await puppeteer.launch({
      headless: true,
      defaultViewport: null,
    });

    const page = await browser.newPage();
    await page.goto(url, {
      waitUntil: "domcontentloaded",
    });

    // Get page data
    const messages = await page.evaluate(() => {
      const quoteList = document.querySelectorAll(".topic-post");

      return Array.from(quoteList).map((quote) => {
        const name = quote.querySelector(".names").textContent;
        const content = quote.querySelector(".cooked").textContent;
        const upvotes = quote.querySelector(".widget-button").textContent;

        return {
          user: name,
          content,
          upvotes: upvotes === "" ? 0 : parseInt(upvotes),
        };
      });
    });

    for (let i = 0; i < messages.length; i++) {
      await db`
      insert into threads (thread, data, upvotes, username) 
      values (${url}, ${messages[i].content}, ${messages[i].upvotes}, ${messages[i].user})

      returning *
      `;
    }

    return messages;
  }
}

export const scrapper = new Scrapper();
