export default function Upload() {
  return (
    <div className="wrapper">
      <div className="container">
        <form method="post" action="http://localhost:8080/upload" id="form" encType="multipart/form-data" target="file">
          <label>Select image to upload:</label>
          <input type="file" name="fileToUpload" id="image-upload" accept="image/*"></input>
          <input type="submit" value="Upload Image" name="submit"></input>
        </form>
      </div>
      <script src="./Getter.js"></script>
    </div >
  )
}
