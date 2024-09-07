import postgres from "postgres";

const sql = postgres({
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  username: process.env.USERNAME,
  pass: process.env.PASSWORD,
});

export const db = sql;
