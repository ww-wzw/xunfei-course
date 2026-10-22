package com.iflytek.interview;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.iflytek.interview.**.mapper")
// @EnableCaching  // 暂时禁用缓存，避免 Redis 连接问题
@EnableAsync
@EnableScheduling
public class InterviewAiApplication {
    public static void main(String[] args) {
        SpringApplication.run(InterviewAiApplication.class, args);
    }
}
