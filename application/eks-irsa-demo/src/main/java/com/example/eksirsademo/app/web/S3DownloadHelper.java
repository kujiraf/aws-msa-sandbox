package com.example.eksirsademo.app.web;

import com.amazonaws.auth.STSAssumeRoleWithWebIdentitySessionCredentialsProvider;
import com.amazonaws.auth.STSAssumeRoleWithWebIdentitySessionCredentialsProvider.Builder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.PresignedUrlDownloadRequest;
import com.amazonaws.services.s3.model.PresignedUrlDownloadResult;
import com.amazonaws.util.IOUtils;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.time.ZonedDateTime;
import java.util.Date;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class S3DownloadHelper {

  private static final Logger LOGGER = LoggerFactory.getLogger(S3DownloadHelper.class);

  @Value("${bucket.name}")
  private String bucketName;
  @Value("${s3.fullaccess.role.arn}")
  private String roleArn;
  @Value("${s3.fullaccess.session.name}")
  private String roleSessionName;
  @Value("${s3.fullaccess.token.path}")
  private String webIdentityTokenFile;

  @Autowired
  private ResourceLoader resourceLoader;

  public URL getPresignedUrl(String filePath) {
    AmazonS3 amazonS3 = getS3Client();
    Date expiration = Date.from(ZonedDateTime.now().plusSeconds(1000).toInstant());
    return amazonS3.generatePresignedUrl(bucketName, filePath, expiration);
  }

  public String getTextFileBody(String filePath) {
    AmazonS3 amazonS3 = getS3Client();
    PresignedUrlDownloadResult result = amazonS3.download(
        new PresignedUrlDownloadRequest(getPresignedUrl(filePath)));

    String textBody = null;
    try (InputStream is = result.getS3Object().getObjectContent()) {
      textBody = IOUtils.toString(is);
    } catch (IOException e) {
      LOGGER.error(e.getMessage());
    }
    return textBody;
  }

  public String getProperties() {
    return "BucketName:" + bucketName + ",RoleArn:" + roleArn + ",RoleSessionName:"
        + roleSessionName + ",WebIdentityTokenFile:" + webIdentityTokenFile;
  }

  private AmazonS3 getS3Client() {

    AmazonS3ClientBuilder provider = AmazonS3ClientBuilder.standard()
        .withCredentials(
            // Returns AWSCredentials which the caller can use to authorize an AWS request.
            new Builder(
                // Required roleArn parameter used when starting a session
                roleArn,
                // Required roleSessionName parameter used when starting a session
                roleSessionName,
                // Required webIdentityTokenFile path issued by k8s oidc provider
                webIdentityTokenFile).build());

    return provider.build();
  }

}
