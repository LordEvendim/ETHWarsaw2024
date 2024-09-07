import "./config/dotenv";

import { createServer } from "./server";

const server = createServer();

const port = process.env.PORT || 3001;

try {
  server.listen(port, () => {
    console.log(`Server: started on port: ${port}`);
  });
} catch (error) {
  console.error("Server crashed");
  console.error(error);
}
