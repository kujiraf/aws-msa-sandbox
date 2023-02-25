package com.example.eksirsademo.config;

import java.util.Arrays;
import java.util.stream.StreamSupport;
import org.apache.logging.slf4j.SLF4JLogger;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.core.env.AbstractEnvironment;
import org.springframework.core.env.EnumerablePropertySource;
import org.springframework.core.env.Environment;
import org.springframework.core.env.MutablePropertySources;

@Configuration
public class PropertiesLogger {

  private static final Logger LOGGER = LoggerFactory.getLogger(PropertiesLogger.class);

  @EventListener
  public void handleContextRefresh(ContextRefreshedEvent event) {
    final Environment env = event.getApplicationContext().getEnvironment();
    LOGGER.info("==== Environment and configuration ====");
    final MutablePropertySources sources = ((AbstractEnvironment) env).getPropertySources();
    StreamSupport.stream(sources.spliterator(), false)
        .filter(ps -> ps instanceof EnumerablePropertySource<?>)
        .map(ps -> ((EnumerablePropertySource<?>) ps).getPropertyNames())
        .flatMap(Arrays::stream)
        .distinct()
        .filter(prop -> !(prop.contains("credentials") || prop.contains("password")))
        .forEach(prop -> LOGGER.info("{}: {}", prop, env.getProperty(prop)));
    LOGGER.info("=======================================");
  }

}
