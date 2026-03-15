import { use, Suspense } from "react";
import getAll from "./Getter";
import "./home.css"

export function Comments({ data }) {
  const dat = use(data)
  const links = [];
  dat.data.forEach((item, index) => (links[index] = `http://localhost:8080/download/${item}`))
  return (
    <ol>
      {dat.data.map((item, index) => (
        <li key={index}>
          <a
            href={`http://localhost:8080/download/${item}`}
            download={item}
          >
            {item}
          </a>
        </li>
      ))
      }
    </ol >
  )
}

async function getVal() {
  const val = await getAll();
  return val
}

export default function Download() {
  return (
    <div className="wrapper">
      <div className="container">
        <h1>Download Videos</h1>
        <Suspense fallback={<p>Loading videos...</p>}>
          <div>
            <Comments data={getVal()} />
          </div>
        </Suspense>
      </div>
    </div>
  )
}
