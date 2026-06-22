package com.example.fileHandling.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.Arrays;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@CrossOrigin(origins = "http://localhost:5173", maxAge = 3600)
public class FileController {

  @RequestMapping(value = "/upload", method = RequestMethod.POST)
  public String uplaodFile(@RequestParam("fileToUpload") MultipartFile file) {
    String fileUploadStatus = "";
    String filePath = System.getProperty("user.dir") + "/Uploads" + File.separator + file.getOriginalFilename();
    try {
      FileOutputStream fout = new FileOutputStream(filePath);
      fout.write(file.getBytes());
      fout.close();
      fileUploadStatus = "File Uploaded Successfully";
    } catch (Exception e) {
      e.printStackTrace();
      fileUploadStatus = "Error in uploading file: " + e;
    }
    return fileUploadStatus;
  }

  @RequestMapping(value = "/getFiles", method = RequestMethod.GET)
  public String[] getFiles() {
    String folderPath = System.getProperty("user.dir") + "/Uploads";
    File directory = new File(folderPath);
    String[] filenames = directory.list();
    return filenames;
  }

  @RequestMapping(value = "/download/{path:.+}", method = RequestMethod.GET)
  public ResponseEntity<InputStreamResource> downloadFile(@PathVariable("path") String filename)
      throws FileNotFoundException {
    String fileUploadpath = System.getProperty("user.dir") + "/Uploads";
    String[] filenames = this.getFiles();
    boolean contains = Arrays.asList(filenames).contains(filename);

    if (!contains) {
      return new ResponseEntity("File Not Found", HttpStatus.NOT_FOUND);
    }

    String filePath = fileUploadpath + File.separator + filename;
    File file = new File(filePath);

    System.out.println("Downloading file from: " + filePath);
    System.out.println("File exists: " + file.exists());
    System.out.println("File size: " + file.length());
    System.out.println("Filename being sent: " + filename);

    InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

    return ResponseEntity.ok()
        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
        .contentType(MediaType.APPLICATION_OCTET_STREAM)
        .contentLength(file.length())
        .body(resource);
  }
}
