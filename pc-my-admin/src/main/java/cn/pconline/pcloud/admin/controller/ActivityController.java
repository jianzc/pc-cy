package cn.pconline.pcloud.admin.controller;

import cn.pconline.framework.enums.XAdminCodeEnum;
import cn.pconline.framework.util.XAdmindResult;
import cn.pconline.pcloud.admin.form.ActivityPageForm;
import cn.pconline.pcloud.admin.form.ActivitySaveDetailForm;
import cn.pconline.pcloud.admin.form.ActivitySaveForm;
import cn.pconline.pcloud.admin.service.ActivityDetailService;
import cn.pconline.pcloud.admin.service.ActivityService;
import cn.pconline.pcloud.base.config.BaseProperties;
import cn.pconline.pcloud.base.dao.ActivityPacketConfigMapper;
import cn.pconline.pcloud.base.entity.Activity;
import cn.pconline.pcloud.base.entity.ActivityDetail;
import cn.pconline.pcloud.base.entity.ActivityPacketConfig;
import cn.pconline.pcloud.base.entity.ActivityPacketConfigExample;
import cn.pconline.pcloud.base.util.DateUtil;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/admin/activity")
public class ActivityController {

    @Autowired
    private ActivityService activityService;
    @Autowired
    private BaseProperties baseProperties;
    @Autowired
    private ActivityPacketConfigMapper activityPacketConfigMapper;
    @Autowired
    private ActivityDetailService activityDetailService;

    @RequestMapping(value = "/index")
    public String index() {
        return "admin/activity/index";
    }

    @RequestMapping(value = {"/list"})
    @ResponseBody
    public XAdmindResult list(ActivityPageForm pageForm) {
        PageInfo<Activity> pageInfo = activityService.pager(pageForm);
        return XAdmindResult.build(XAdminCodeEnum.SUCCESS, pageInfo.getList(), pageInfo.getTotal());
    }

    @GetMapping("/form")
    public String add(Long activityId, Model model) {
        if (activityId != null && activityId > 0) {
            Activity activity = activityService.find(activityId);
            model.addAttribute("entity", activity);
            // ????????????????????????
            if (activity != null && activity.getPacketType() == 3) {
                ActivityPacketConfigExample example = new ActivityPacketConfigExample();
                ActivityPacketConfigExample.Criteria criteria = example.createCriteria();
                criteria.andActivityIdEqualTo(activityId);
                List<ActivityPacketConfig> packetConfigs = activityPacketConfigMapper.selectByExample(example);
                model.addAttribute("packetConfigs", packetConfigs);
            }
        }
        return "admin/activity/form";
    }

    @GetMapping("/detail")
    public String detail(Long activityId, Model model) {
        if (activityId != null && activityId > 0) {
            ActivityDetail activityDetail = activityDetailService.find(activityId);
            model.addAttribute("activityId", activityId);
            model.addAttribute("entity", activityDetail);
        }
        return "admin/activity/detail";
    }

    @PostMapping("/save")
    @ResponseBody
    public XAdmindResult save(ActivitySaveForm form) {
        activityService.save(form);
        return XAdmindResult.build(XAdminCodeEnum.SUCCESS);
    }

    @PostMapping("/saveDetail")
    @ResponseBody
    public XAdmindResult saveDetail(ActivitySaveDetailForm form) {
        activityService.saveDetail(form);
        return XAdmindResult.build(XAdminCodeEnum.SUCCESS);
    }

    /**
     * ????????????
     *
     * @param file
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    public XAdmindResult doUpload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return XAdmindResult.build(XAdminCodeEnum.ERROR, "File is empty.");
        }

        String filename = file.getOriginalFilename();
        if (StringUtils.isBlank(filename)) {
            return XAdmindResult.build(XAdminCodeEnum.ERROR, "Filename is empty.");
        }

        int index = filename.lastIndexOf(".");
        if (index == -1) {
            return XAdmindResult.build(XAdminCodeEnum.ERROR, "Filename is error.");
        }

        String suffix = filename.substring(index);
        String newFilename = DateUtil.format(new Date(), "yyMMddHHmmssSSS") + suffix;

        String path = baseProperties.getFilePath().replace("/pdf/", "/" + suffix.replace(".", "") + "/") + newFilename;

        File dest = new File(path); // ????????????
        // ????????????????????????
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }

        try {
            file.transferTo(dest); // ????????????
        } catch (IllegalStateException | IOException e) {
            e.printStackTrace();
            return XAdmindResult.build(XAdminCodeEnum.ERROR, "File writer exception!");
        }

        String picUrl = "/data/" + suffix.replace(".", "") + "/" + newFilename;

        return XAdmindResult.build(XAdminCodeEnum.SUCCESS, picUrl); // ???????????????
    }

    // ??????????????????????????????
    private static final long maxSize = 10240000;

    /**
     * ??????????????????????????????
     *
     * @param multipartFile
     * @return
     */
    @PostMapping("/uploadEditorPic")
    @ResponseBody
    public String uploadPic(@RequestParam(name = "upload") MultipartFile multipartFile, @RequestParam(required = false, defaultValue = "") String command) {
        JSONObject result = new JSONObject();
        if (multipartFile == null) {
            result.put("uploaded", 0);
            JSONObject error = new JSONObject();
            error.put("message", "???????????????");
            result.put("error", error);

            return result.toJSONString();
        }

        if (multipartFile.getSize() > maxSize) {
            result.put("uploaded", 0);
            JSONObject error = new JSONObject();
            error.put("message", "??????????????????????????????????????????");
            result.put("error", error);
        }
        String filename = multipartFile.getOriginalFilename();
        String ext = filename.substring(filename.lastIndexOf(".") + 1);
        // ??????????????????????????????????????????
        boolean isAllow = "jpg".equalsIgnoreCase(ext) || "gif".equalsIgnoreCase(ext) || "png".equalsIgnoreCase(ext)
                || "bmp".equalsIgnoreCase(ext) || "jpeg".equalsIgnoreCase(ext);

        if (!isAllow) {
            result.put("uploaded", 0);
            JSONObject error = new JSONObject();
            error.put("message", "??????????????????jpg,gif,png,bmp,jpeg??????");
            result.put("error", error);

            return result.toJSONString();
        }

        int index = filename.lastIndexOf(".");
        if (index == -1) {
            JSONObject error = new JSONObject();
            error.put("message", "Filename is error.");
            result.put("error", error);

            return result.toJSONString();
        }

        String suffix = filename.substring(index);
        String newFilename = DateUtil.format(new Date(), "yyMMddHHmmssSSS") + suffix;

        String path = baseProperties.getFilePath().replace("/pdf/", "/" + suffix.replace(".", "") + "/") + newFilename;

        File dest = new File(path);
        // ????????????????????????
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }

        try {
            multipartFile.transferTo(dest); // ????????????
        } catch (IllegalStateException | IOException e) {
            e.printStackTrace();
            result.put("uploaded", 0);
            JSONObject error = new JSONObject();
            error.put("message", "File writer exception!");
            result.put("error", error);

            return result.toJSONString();
        }

        String picUrl = "/data/" + suffix.replace(".", "") + "/" + newFilename;

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("uploaded", 1);
        jsonObject.put("url", picUrl);

        return jsonObject.toJSONString();
    }

}
