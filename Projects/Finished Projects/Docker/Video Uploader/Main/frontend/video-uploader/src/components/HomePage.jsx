import "./home.css"
export default function HomePage() {
  return (
    <div className="wrapper">
      <div className="container">
        <h1 className="header">File Uploader</h1>
        <h2>Here you can, </h2>
        <ol>
          <li><a href="/upload">Upload a File</a></li>
          <li><a href="/download">Download or retrieve a File</a></li>
          <li><a href="/remove">Remove a File</a></li>
        </ol>
        <h2>These files uploaded are stored in a server and in local for redudency</h2>
      </div>
      <div className="container2">
      </div>
    </div>
  )
}
