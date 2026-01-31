import axios from "axios";

export default async function getAll() {
  const val = axios.get("http://localhost:8080/getFiles")
  return val
}
;
