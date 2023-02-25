package com.example.eksirsademo.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/v1")
public class S3RestController {

  private static final Logger LOGGER = LoggerFactory.getLogger(S3RestController.class);

  @Autowired
  S3DownloadHelper s3DownloadHelper;

  @GetMapping("/getText/{filename}")
  public ResponseEntity<String> getTextFileBody(String filename) {
    LOGGER.info("called getTextFileBody. filename=" + filename);
    return ResponseEntity.ok().body(s3DownloadHelper.getPresignedUrl(filename).toString());
  }

}
