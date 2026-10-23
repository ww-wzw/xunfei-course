package com.iflytek.interview.file.controller;

import com.iflytek.interview.common.exception.BusinessException;
import com.iflytek.interview.common.response.Result;
import com.iflytek.interview.common.security.SecurityUtil;
import com.iflytek.interview.file.entity.FileRecord;
import com.iflytek.interview.file.service.FileRecordService;
import com.iflytek.interview.file.util.FileValidator;
import com.iflytek.interview.file.util.MinioUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/files")
public class FileController {

    @Autowired
    private MinioUtil minioUtil;

    @Autowired
    private FileRecordService fileRecordService;

    @Autowired
    private FileValidator fileValidator;

    @PostMapping("/upload")
    public Result<Map<String, Object>> upload(
            @RequestParam String module,
            @RequestPart("file") MultipartFile file) throws IOException {

        // 1. 业务层校验（类型 + 大小）
        fileValidator.validate(file);

        // 2. module 参数校验：该值直接参与对象路径拼接，只允许小写字母、数字、下划线和短横线
        if (module == null || !module.matches("[a-z0-9][a-z0-9_-]{0,31}")) {
            throw new BusinessException(400, "module 参数不合法");
        }

        // 3. 登录用户
        Long userId = SecurityUtil.getCurrentUserId();

        // 4. 唯一对象路径：文件名先去掉路径部分，防止伪造子路径；数据库记录仍保存原始名
        String originalName = file.getOriginalFilename();
        String safeName = originalName == null ? "file"
                : originalName.replace("\\", "/").replaceAll(".*/", "")
                        .replaceAll("[\\x00-\\x1f\\x7f]", "");
        String objectName = module + "/" + userId + "/"
                + UUID.randomUUID().toString().replace("-", "").substring(0, 8)
                + "_" + safeName;

        // 5. 上传到 MinIO
        minioUtil.upload(objectName, file.getInputStream(), file.getContentType());

        // 6. 记录元数据
        String url = minioUtil.getUrl(objectName);
        FileRecord record = new FileRecord();
        record.setUserId(userId);
        record.setOriginalName(originalName);
        record.setObjectName(objectName);
        record.setUrl(url);
        record.setFileSize(file.getSize());
        record.setContentType(file.getContentType());
        record.setModule(module);
        fileRecordService.save(record);

        return Result.success(Map.of("url", url, "originalName", originalName));
    }
}
