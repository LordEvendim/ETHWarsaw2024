import cors, { CorsOptions } from "cors";

const corsProduction: CorsOptions = {
  optionsSuccessStatus: 200,
  credentials: true,
  origin: "*",
};

export default cors(corsProduction);
