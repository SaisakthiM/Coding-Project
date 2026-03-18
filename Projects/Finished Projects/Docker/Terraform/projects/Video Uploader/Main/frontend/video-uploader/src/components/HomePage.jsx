import "./home.css"
import { Link } from 'react-router-dom'
export default function HomePage() {
  return (
    <div className="wrapper">
      <div className="container">
        <h1 className="header">File Uploader</h1>
        <h2>Here you can, </h2>
        <ol>
          <li><Link to="/upload">Upload a File</Link></li>
          <li><Link to="/download">Download or retrieve a File</Link></li>
          <li><Link to="/remove">Remove a File</Link></li>
        </ol>
        <h2>These files uploaded are stored in a server and in local for redudency</h2>
      </div>
      <div className="container2">
      </div>
    </div>
  )
}
