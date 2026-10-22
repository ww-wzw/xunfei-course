package com.iflytek.interview.interview.service;

import com.iflytek.interview.interview.entity.InterviewRecord;
import com.iflytek.interview.interview.mapper.InterviewRecordMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Map;

/**
 * 异步评测报告生成器。
 * 视觉维度使用 Python 返回的 video_summary，覆盖率达到可用条件后参与综合评分。
 */
@Slf4j
@Component
public class ReportGenerator {

    private static final BigDecimal BASELINE_SCORE = new BigDecimal("82.50");
    private static final BigDecimal BASELINE_WEIGHT = new BigDecimal("0.85");
    private static final BigDecimal VISUAL_WEIGHT = new BigDecimal("0.15");

    @Autowired
    private InterviewRecordMapper recordMapper;

    public void generateReport(Long recordId) {
        generateReport(recordId, Map.of("video_available", false));
    }

    @Async("reportExecutor")
    public void generateReport(Long recordId, Map<String, Object> videoSummary) {
        log.info("[异步] 开始生成评测报告 recordId={}", recordId);

        InterviewRecord record = recordMapper.selectById(recordId);
        if (record == null) {
            log.warn("[异步] 找不到面试记录 recordId={}", recordId);
            return;
        }

        BigDecimal expressionScore = asDecimal(videoSummary, "expression_score");
        BigDecimal attentionScore = asDecimal(videoSummary, "attention_score");
        boolean videoAvailable = asBoolean(videoSummary, "video_available", "available");

        BigDecimal score = BASELINE_SCORE;
        String feedback = "有效人脸帧达到可用条件后，视觉维度可参与综合评分。";
        if (videoAvailable && expressionScore != null && attentionScore != null) {
            BigDecimal visualScore = expressionScore.add(attentionScore)
                    .divide(BigDecimal.valueOf(2), 2, RoundingMode.HALF_UP);
            score = BASELINE_SCORE.multiply(BASELINE_WEIGHT)
                    .add(visualScore.multiply(VISUAL_WEIGHT))
                    .setScale(2, RoundingMode.HALF_UP);
            feedback = "视觉维度已参与综合评分，建议持续保持稳定的目光与自然表情。";
        }

        InterviewRecord reportUpdate = new InterviewRecord();
        reportUpdate.setId(recordId);
        reportUpdate.setScore(score);
        reportUpdate.setAiFeedback(feedback);
        recordMapper.updateById(reportUpdate);

        log.info("[异步] 评测报告生成完成 recordId={}, videoAvailable={}", recordId, videoAvailable);
    }

    private BigDecimal asDecimal(Map<String, Object> source, String key) {
        Object value = source == null ? null : source.get(key);
        if (value == null) {
            return null;
        }
        try {
            return new BigDecimal(String.valueOf(value));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private boolean asBoolean(Map<String, Object> source, String... keys) {
        if (source == null) {
            return false;
        }
        for (String key : keys) {
            Object value = source.get(key);
            if (value != null) {
                return Boolean.parseBoolean(String.valueOf(value))
                        || "1".equals(String.valueOf(value));
            }
        }
        return false;
    }
}

