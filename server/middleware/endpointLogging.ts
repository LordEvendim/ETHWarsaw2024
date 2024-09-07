import { NextFunction, Request, Response } from "express";

export const endpointLogging = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  console.log(
    `[${new Date().toLocaleDateString()}]: ${req.baseUrl + req.path}`
  );

  next();
};
