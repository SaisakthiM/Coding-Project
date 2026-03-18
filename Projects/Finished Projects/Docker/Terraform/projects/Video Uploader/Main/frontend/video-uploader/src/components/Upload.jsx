import { useState } from "react"

export default function Upload() {
  const [status, setStatus] = useState("")
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e) {
    e.preventDefault()
    const formData = new FormData(e.target)
    setLoading(true)
    setStatus("")
    try {
      const res = await fetch("/video/api/upload", {
        method: "POST",
        body: formData,
      })
      const text = await res.text()
      setStatus(text)
    } catch (err) {
      setStatus("Upload failed: " + err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="wrapper">
      <div className="container">
        <form onSubmit={handleSubmit} id="form" encType="multipart/form-data">
          <label>Select image to upload:</label>
          <input type="file" name="fileToUpload" id="image-upload" accept="image/*" />
          <input type="submit" value="Upload Image" name="submit" disabled={loading} />
        </form>
        {loading && <p>Uploading...</p>}
        {status && <p>{status}</p>}
      </div>
    </div>
  )
}
