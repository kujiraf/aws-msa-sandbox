package com.example.eksirsademo.app.web;

import com.amazonaws.SdkClientException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/v1")
public class S3RestController {

  private static final Logger LOGGER = LoggerFactory.getLogger(S3RestController.class);

  @Autowired
  S3DownloadHelper s3DownloadHelper;

  @GetMapping("/getUrl/{filename}")
  public ResponseEntity<String> getUrl(@PathVariable String filename) throws SdkClientException {
    LOGGER.info("called getUrl. filename=" + filename);
    return ResponseEntity.ok().body(s3DownloadHelper.getPresignedUrl(filename).toString());
  }

  @GetMapping("/getText/{filename}")
  @ResponseBody
  public ResponseEntity<String> getText(@PathVariable String filename) throws SdkClientException {
    LOGGER.info("called getText. filename=" + filename);
    return ResponseEntity.ok().body(s3DownloadHelper.getTextFileBody(filename));
  }


  @GetMapping("/debug")
  public ResponseEntity<String> getDebug() {
    return ResponseEntity.ok().body(s3DownloadHelper.getProperties());
  }

}
