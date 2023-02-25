package com.example.eksirsademo.web;

import com.amazonaws.auth.STSAssumeRoleWithWebIdentitySessionCredentialsProvider;
import com.amazonaws.auth.policy.Policy;
import com.amazonaws.auth.policy.Resource;
import com.amazonaws.auth.policy.Statement;
import com.amazonaws.auth.policy.Statement.Effect;
import com.amazonaws.auth.policy.actions.S3Actions;
import com.amazonaws.services.identitymanagement.model.GetRoleRequest;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.securitytoken.AWSSecurityTokenServiceClient;
import com.example.eksirsademo.config.PropertiesLogger;
import java.net.URL;
import java.time.ZonedDateTime;
import java.util.Date;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class S3DownloadHelper {

  private static final Logger LOGGER = LoggerFactory.getLogger(S3DownloadHelper.class);

  private static final String RESOURCE_ARN_PREFIX = "arn:aws:s3::";
  private static final String DIRECTORY_DELIMITER = "/";

  @Value("${bucket.name}")
  private String bucketName;

  @Value("${s3.fullaccess.role.arn}")
  private String roleArn;
  @Value("${s3.fullaccess.session.name}")
  private String roleSessionName;
  @Value("${s3.fullaccess.token.path}")
  private String webIdentityTokenFile;

  public URL getPresignedUrl(String filePath) {
    AmazonS3 amazonS3 = getS3Client(filePath);
    Date expiration = Date.from(ZonedDateTime.now().plusSeconds(1000).toInstant());
    return amazonS3.generatePresignedUrl(bucketName, filePath, expiration);
  }

  private AmazonS3 getS3Client(String objectKey) {
    LOGGER.info("roleArn:" + roleArn);
    LOGGER.info("roleSessionName:" + roleSessionName);
    LOGGER.info("webIdTokenFile:" + webIdentityTokenFile);

    String resourceArn = RESOURCE_ARN_PREFIX + bucketName + DIRECTORY_DELIMITER + objectKey;

    Statement statement = new Statement(Effect.Allow).withActions(S3Actions.GetObject)
        .withResources(new Resource(resourceArn));
    String iamPolicy = new Policy().withStatements(statement).toJson();

    return AmazonS3ClientBuilder.standard().withCredentials(
        new STSAssumeRoleWithWebIdentitySessionCredentialsProvider.Builder(roleArn, roleSessionName,
            webIdentityTokenFile).withStsClient(AWSSecurityTokenServiceClient.builder().build())
            .build()).build();
  }

}
