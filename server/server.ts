import express, { Application } from "express";

import { experimentingRouter } from "./router/experimentingRouter";
import { endpointLogging } from "./middleware/endpointLogging";
import { scheduler } from "./modules/scheduler/scheduler";
import cors from "./config/cors";

const app: Application = express();

export const createServer = () => {
  app.set("trust proxy", 1);

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(cors);
  app.use(endpointLogging);

  scheduler.start();

  // Healthcheck
  app.get("/", (req, res) => {
    res.status(200).send({ status: "ok" });
  });

  app.use("/exp", experimentingRouter);

  return app;
};
