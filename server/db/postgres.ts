import postgres from "postgres";

const sql = postgres({
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  username: process.env.POSTGRES_USERNAME,
  pass: process.env.POSTGRES_PASSWORD,
});

export const db = sql;
