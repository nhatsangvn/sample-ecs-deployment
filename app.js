const express = require("express");
const app = express();
const port = 3000;

const basicAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (authHeader) {
    const encodedCredentials = authHeader.split(" ")[1]; // 'Basic xxxxxx'
    const credentials = Buffer.from(encodedCredentials, "base64").toString(
      "utf8"
    ); // 'user:password'
    const [username, password] = credentials.split(":");

    const basicAuthUser = process.env.BASIC_AUTH_USER;
    const basicAuthPassword = process.env.BASIC_AUTH_PASSWORD;

    if (username === basicAuthUser && password === basicAuthPassword) {
      next();
    } else {
      res.status(403);
      res.send("Invalid Credentials");
    }
  } else {
    res.status(401);
    res.setHeader("WWW-Authenticate", "Basic");
    res.send("Authorization required");
  }
};

app.get("/", basicAuth, (_req, res) =>
  res.send("Welcome! This is a secret password protected page.")
);

app.listen(port, () => console.log(`Server ready on port ${port}`));
