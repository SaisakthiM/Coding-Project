export default function Upload() {
  return (
    <div className="wrapper">
      <div className="container">

        <form action="/upload-page" method="post" enctype="multipart/form-data">
          <label>Select image to upload:</label>
          <input type="file" name="fileToUpload" id="image-upload" accept="image/*"></input>
          <input type="submit" value="Upload Image" name="submit"></input>
        </form>
      </div>
    </div >
  )
}
