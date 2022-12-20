import axios from "axios";

const nickname = { nickname: "Masanao" };
const url = "http://challenge.z2o.cloud/challenges";

const startChallenge = () => {
  const challengeResponse = axios.post(url, nickname);
  console.log(challengeResponse);
};


startChallenge();
