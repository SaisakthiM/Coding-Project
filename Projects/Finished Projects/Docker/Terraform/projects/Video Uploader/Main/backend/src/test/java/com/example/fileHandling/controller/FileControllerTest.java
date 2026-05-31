package com.example.fileHandling.controller;

import com.example.fileHandling.service.OmvSftpService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.context.TestPropertySource;

import java.nio.file.Path;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(controllers = FileController.class, excludeAutoConfiguration = {
    org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class
})
@TestPropertySource(properties = {
    "spring.main.allow-bean-definition-overriding=true",
    "UPLOADS_DIR=/tmp/test-uploads"
})
class FileControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private OmvSftpService omvSftpService;

    @TempDir
    Path tempDir;

    @BeforeEach
    void setUp() {
        System.setProperty("user.dir", tempDir.toString());
        System.setProperty("UPLOADS_DIR", tempDir.toString());
    }

    // ── /upload ───────────────────────────────────────────────

    @Test
    void upload_validFile_returnsSuccess() throws Exception {
        doNothing().when(omvSftpService).uploadToOmv(anyString(), anyString());

        MockMultipartFile file = new MockMultipartFile(
            "fileToUpload",
            "test.jpg",
            "image/jpeg",
            "fake image content".getBytes()
        );

        mockMvc.perform(multipart("/upload").file(file))
            .andExpect(status().isOk())
            .andExpect(content().string("File Uploaded Successfully!"));
    }

    @Test
    void upload_omvFails_stillReturnsSuccess() throws Exception {
        // OMV backup is non-critical — failure should not affect response
        doThrow(new RuntimeException("SFTP connection refused"))
            .when(omvSftpService).uploadToOmv(anyString(), anyString());

        MockMultipartFile file = new MockMultipartFile(
            "fileToUpload",
            "test.mp4",
            "video/mp4",
            "fake video content".getBytes()
        );

        mockMvc.perform(multipart("/upload").file(file))
            .andExpect(status().isOk())
            .andExpect(content().string("File Uploaded Successfully!"));
    }

    @Test
    void upload_emptyFile_returnsSuccess() throws Exception {
        MockMultipartFile file = new MockMultipartFile(
            "fileToUpload",
            "empty.txt",
            "text/plain",
            new byte[0]
        );

        mockMvc.perform(multipart("/upload").file(file))
            .andExpect(status().isOk())
            .andExpect(content().string("File Uploaded Successfully!"));
    }

    // ── /getFiles ─────────────────────────────────────────────

    @Test
    void getFiles_emptyDirectory_returnsEmptyArray() throws Exception {
        mockMvc.perform(get("/getFiles"))
            .andExpect(status().isOk())
            .andExpect(content().json("[]"));
    }

    @Test
    void getFiles_afterUpload_returnsFileName() throws Exception {
        // Upload a file first
        MockMultipartFile file = new MockMultipartFile(
            "fileToUpload",
            "myfile.txt",
            "text/plain",
            "hello".getBytes()
        );
        mockMvc.perform(multipart("/upload").file(file));

        // Now check it appears in list
        mockMvc.perform(get("/getFiles"))
            .andExpect(status().isOk())
            .andExpect(content().json("[\"myfile.txt\"]"));
    }

    @Test
    void getFiles_multipleFiles_returnsAll() throws Exception {
        String[] filenames = {"video1.mp4", "image1.jpg", "doc.pdf"};

        for (String name : filenames) {
            MockMultipartFile file = new MockMultipartFile(
                "fileToUpload", name, "application/octet-stream", "data".getBytes()
            );
            mockMvc.perform(multipart("/upload").file(file));
        }

        mockMvc.perform(get("/getFiles"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(3));
    }

    // ── /download/{filename} ──────────────────────────────────

    @Test
    void download_existingFile_returnsFile() throws Exception {
        // Upload first
        MockMultipartFile file = new MockMultipartFile(
            "fileToUpload",
            "download-me.txt",
            "text/plain",
            "file content here".getBytes()
        );
        mockMvc.perform(multipart("/upload").file(file));

        // Now download
        mockMvc.perform(get("/download/download-me.txt"))
            .andExpect(status().isOk())
            .andExpect(header().string("Content-Disposition",
                "attachment; filename=\"download-me.txt\""))
            .andExpect(content().bytes("file content here".getBytes()));
    }

    @Test
    void download_nonExistentFile_returns404() throws Exception {
        mockMvc.perform(get("/download/doesnotexist.mp4"))
            .andExpect(status().isNotFound());
    }

    @Test
    void download_fileWithSpacesInName_returnsFile() throws Exception {
        MockMultipartFile file = new MockMultipartFile(
            "fileToUpload",
            "my video.mp4",
            "video/mp4",
            "video data".getBytes()
        );
        mockMvc.perform(multipart("/upload").file(file));

        mockMvc.perform(get("/download/my video.mp4"))
            .andExpect(status().isOk())
            .andExpect(header().string("Content-Disposition",
                "attachment; filename=\"my video.mp4\""));
    }

    @Test
    void download_setsCorrectContentType() throws Exception {
        MockMultipartFile file = new MockMultipartFile(
            "fileToUpload",
            "data.bin",
            "application/octet-stream",
            "binary".getBytes()
        );
        mockMvc.perform(multipart("/upload").file(file));

        mockMvc.perform(get("/download/data.bin"))
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/octet-stream"));
    }
}