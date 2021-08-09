/* 14001 cy_doctor cydoctor cydoctorhlx!#1..4 服务器需要设置utf-8编码，否则中文插入会乱码 */

CREATE TABLE tb_resource (
  resource_id bigint(11) NOT NULL AUTO_INCREMENT,
  parent_id bigint(11) DEFAULT NULL,
  type int(2) DEFAULT NULL,
  name varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  source_key varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  source_url varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  sort int(4) DEFAULT NULL,
  icon varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  description varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  is_hide int(2) DEFAULT NULL,
  create_at datetime DEFAULT NULL,
  update_at datetime DEFAULT NULL,
  PRIMARY KEY (resource_id) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE tb_role (
  role_id bigint(11) NOT NULL AUTO_INCREMENT,
  name varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  role_key varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  description varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  status int(2) DEFAULT NULL,
  create_at datetime DEFAULT NULL,
  update_at datetime DEFAULT NULL,
  PRIMARY KEY (role_id) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE tb_role_resource (
  role_id bigint(11) NOT NULL,
  resource_id bigint(11) NOT NULL,
  PRIMARY KEY (role_id,resource_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE tb_user (
  user_id bigint(11) NOT NULL AUTO_INCREMENT,
  account varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  pwd varchar(80) COLLATE utf8mb4_bin DEFAULT NULL,
  name varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  department varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  is_admin int(2) DEFAULT NULL,
  is_lock int(2) DEFAULT NULL,
  create_at datetime DEFAULT NULL,
  update_at datetime DEFAULT NULL,
  PRIMARY KEY (user_id) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=80330 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE tb_user_role (
  user_id bigint(11) NOT NULL,
  role_id bigint(11) NOT NULL,
  PRIMARY KEY (user_id,role_id) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE tb_operate_log (
  operate_log_id bigint(11) NOT NULL AUTO_INCREMENT,
  module varchar(50) DEFAULT NULL,
  update_target varchar(100) DEFAULT NULL,
  update_content varchar(1500) DEFAULT NULL,
  create_at datetime DEFAULT NULL,
  create_by varchar(50) DEFAULT NULL,
  PRIMARY KEY (operate_log_id)
) ENGINE=InnoDB AUTO_INCREMENT=735 DEFAULT CHARSET=utf8mb4;

/* ***************** 初始化数据 cy_admin:123456 ***************** */

insert into tb_user(user_id,account,pwd,name,department,is_admin,is_lock,create_at,update_at)
values (1,'cy_admin','UUKHSDDI5KPA43A8VL06V0TU2','系统管理员','广州 - 研发中心',1,0,NOW(),NOW());

insert into tb_resource(resource_id,parent_id,type,name,source_key,source_url,sort,icon,description,is_hide,create_at,update_at)
 values (1,0,0,'系统管理','system','',2,'layui-icon-username','系统管理',0,NOW(),NOW())
 ,(2,1,1,'用户管理','system:user:index','/admin/user/index',1,'layui-icon-username','数据来至员工账号系统',0,NOW(),NOW())
 ,(3,2,2,'用户添加','system:user:add','/admin/user/add',2,'layui-icon-circle-dot','选择新增员工账号',0,NOW(),NOW())
 ,(4,2,2,'用户锁定','system:user:locked','/admin/user/locked',3,NULL,NULL,0,NOW(),NOW())
 ,(5,2,2,'角色配置','system:user:userRole','/admin/user/userRole/**',40,'','角色分配',0,NOW(),NOW())
 ,(6,1,1,'角色管理','system:role:index','/admin/role/index',2,'layui-icon-rate','角色管理',0,NOW(),NOW())
 ,(7,6,2,'角色编辑','system:role:edit','/admin/role/edit/**',1,'','角色编辑',0,NOW(),NOW())
 ,(8,6,2,'角色添加','system:role:add','/admin/role/add',2,'','角色添加',0,NOW(),NOW())
 ,(9,6,2,'角色审核','system:role:updateStatus','/admin/role/updateStatus',4,'','正常|禁用',0,NOW(),NOW())
 ,(10,6,2,'角色资源配置','system:role:roleSource','/admin/role/roleSource',3,'','资源分配',0,NOW(),NOW())
 ,(11,1,1,'资源管理','system:resource:index','/admin/resource/index',3,NULL,'资源管理',0,NOW(),NOW())
 ,(12,11,2,'资源保存','system:resource:save','/admin/resource/form/**',2,'','资源添加或修改',0,NOW(),NOW())
 ,(13,11,2,'资源删除','system:resource:delete','/admin/resource/delete/**',3,NULL,'资源删除',0,NOW(),NOW())
 ,(14,11,2,'资源隐藏','system:resource:updateIsHide','/admin/resource/updateIsHide',4,'','修改资源的显示/隐藏状态',0,NOW(),NOW())
 ,(15,11,2,'资源批量删除','system:resource:deleteBatch','/admin/resource/deleteBatch',5,'','批量删除',0,NOW(),NOW())
 ,(16,0,0,'数据管理','data','',1,'layui-icon-username','数据管理',0,NOW(),NOW())
 ,(17,16,1,'用户报告','data:report','/admin/report/index',1,null,'报告数据',0,NOW(),NOW())
 ,(18,16,1,'用户授权','data:open','/admin/open/index',2,null,'授权账号',0,NOW(),NOW());

CREATE TABLE cy_user_report (
  id bigint(11) NOT NULL AUTO_INCREMENT,
  name varchar(30) DEFAULT NULL,
  sex int(1) DEFAULT NULL,
  page_size int(4) DEFAULT NULL,
  mobile varchar(20) DEFAULT NULL,
  test_date varchar(10) DEFAULT NULL,
  report_file varchar(100) DEFAULT NULL,
  score int(4) DEFAULT NULL,
  title varchar(50) DEFAULT NULL,
  intro varchar(100) DEFAULT NULL,
  status int(1) DEFAULT NULL,
  create_at datetime DEFAULT NULL,
  create_by varchar(30) DEFAULT NULL,
  update_at datetime DEFAULT NULL,
  update_by varchar(30) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cy_user_open (
  id bigint(11) NOT NULL AUTO_INCREMENT,
  openid varchar(100) NOT NULL,
  name varchar(30) NOT NULL,
  mobile varchar(20) DEFAULT NULL,
  status int(2) DEFAULT '1',
  create_at datetime DEFAULT NULL,
  update_at datetime DEFAULT NULL,
  mini_openid varchar(100) DEFAULT NULL,
  unionid varchar(100) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

CREATE TABLE cy_activity (
  activity_id bigint(20) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  name varchar(200) NOT NULL COMMENT '活动名称',
  start_time datetime DEFAULT NULL COMMENT '开始时间',
  end_time datetime DEFAULT NULL COMMENT '结束时间',
  status tinyint(4) NOT NULL COMMENT '活动状态 0：关闭 1：开启 -1：删除',
  contact_number varchar(20) NOT NULL COMMENT '联系电话',
  apply_url varchar(500) NOT NULL COMMENT '报名链接',
  apply_title varchar(255) NOT NULL COMMENT '报名文案',
  apply_button_url varchar(255) NOT NULL COMMENT '报名按钮图片链接',
  apply_logo_url varchar(255) NOT NULL COMMENT '报名logo链接',
  funds int(11) NOT NULL DEFAULT '0' COMMENT '活动经费（单位：分）',
  packet_num int(11) NOT NULL DEFAULT '0' COMMENT '红包数量',
  packet_type tinyint(4) NOT NULL COMMENT '红包类型 1：固定金额 2：随机金额 3：指定红包金额及数量',
  packet_amount int(11) DEFAULT '0' COMMENT '红包金额（单位：分）',
  min_packet_amount int(11) DEFAULT '0' COMMENT '最小红包金额（单位：分）',
  max_packet_amount int(11) DEFAULT '0' COMMENT '最大红包金额（单位：分）',
  remain_funds int(11) DEFAULT '0' COMMENT '剩余经费（单位：分）',
  remain_funds_alloc_type tinyint(4) DEFAULT '0' COMMENT '剩余经费分配类型 1：平均分配 2：随机分配',
  remain_packet_num int(11) DEFAULT NULL COMMENT '剩余红包数量',
  is_set_stay_time tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否设置停留时间 1：是 0：否',
  stay_time int(11) NOT NULL DEFAULT '0' COMMENT '停留时间（秒）',
  is_set_join_area tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否设置参与地区 1：是 0：否',
  join_area varchar(255) NOT NULL COMMENT '参与地区',
  is_need_follow tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否需要关注 1：是 0：否',
  create_at datetime DEFAULT NULL COMMENT '创建时间',
  create_by varchar(30) NOT NULL COMMENT '创建人',
  update_at datetime DEFAULT NULL COMMENT '更新时间',
  update_by varchar(30) NOT NULL COMMENT '更新人',
  PRIMARY KEY (activity_id)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='活动表';

CREATE TABLE cy_activity_detail (
  activity_id bigint(20) NOT NULL COMMENT '活动ID',
  share_title varchar(255) NOT NULL DEFAULT '' COMMENT '分享标题',
  share_desc varchar(255) NOT NULL DEFAULT '' COMMENT '分享摘要',
  share_pic_url varchar(255) NOT NULL DEFAULT '' COMMENT '分享图片链接',
  source tinyint(4) NOT NULL DEFAULT '0' COMMENT '内容来源 1：原创 2：转载',
  source_info varchar(255) NOT NULL DEFAULT '' COMMENT '内容来源信息',
  content text NOT NULL COMMENT '活动内容',
  PRIMARY KEY (activity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动详情表';

CREATE TABLE cy_activity_openid (
  activity_id int(11) NOT NULL COMMENT '活动ID',
  openid char(28) NOT NULL COMMENT '微信openid',
  PRIMARY KEY (activity_id,openid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动已授权微信用户';

CREATE TABLE cy_activity_packet (
  activity_packet_id bigint(20) NOT NULL AUTO_INCREMENT COMMENT '活动红包ID',
  activity_id bigint(20) NOT NULL COMMENT '活动ID',
  packet_amount int(11) NOT NULL DEFAULT '0' COMMENT '红包金额（单位：分）',
  status tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态 0：待领取 1：已领取',
  openid char(28) DEFAULT NULL COMMENT '微信openid',
  draw_at datetime DEFAULT NULL COMMENT '领取时间',
  PRIMARY KEY (activity_packet_id)
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8mb4 COMMENT='活动红包表';

CREATE TABLE cy_activity_packet_config (
  activity_packet_config_id bigint(20) NOT NULL AUTO_INCREMENT COMMENT '活动红包配置ID',
  activity_id bigint(20) NOT NULL COMMENT '活动ID',
  packet_amount int(11) NOT NULL COMMENT '红包金额',
  packet_num int(11) NOT NULL COMMENT '红包数量',
  PRIMARY KEY (activity_packet_config_id) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='活动红包配置表';