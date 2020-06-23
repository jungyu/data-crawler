CREATE TABLE `crawler_source` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(90) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` tinytext COLLATE utf8mb4_unicode_ci,
  `topics` text COLLATE utf8mb4_unicode_ci,
  `source_domain` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `crawler_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `crawler_schema` text COLLATE utf8mb4_unicode_ci,
  `created` int(10) DEFAULT NULL,
  `modified` int(10) DEFAULT NULL,
  `schedule_sync` int(10) DEFAULT NULL,
  `last_sync` int(10) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `crawler_list` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `source_id` bigint(20) DEFAULT NULL,
  `topic` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `article_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `article_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `modified` int(10) DEFAULT NULL,
  `last_sync` int(10) DEFAULT NULL,
  `available` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `crawler_article` (
  `id` bigint(40) NOT NULL AUTO_INCREMENT,
  `list_id` bigint(30) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_available` tinyint(1) DEFAULT NULL,
  `source_content` text COLLATE utf8mb4_unicode_ci,
  `source_media` text COLLATE utf8mb4_unicode_ci,
  `source_modified` int(10) DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `media` text COLLATE utf8mb4_unicode_ci,
  `target_table` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_id` bigint(40) DEFAULT NULL,
  `created` int(10) DEFAULT NULL,
  `modified` int(10) DEFAULT NULL,
  `last_source_sync` int(10) DEFAULT NULL,
  `last_target_sync` int(10) DEFAULT NULL,
  `available` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `crawler_articlemeta` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(40) DEFAULT NULL,
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_value` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `crawler_fields` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `source_id` bigint(20) DEFAULT NULL,
  `source_fields` text COLLATE utf8mb4_unicode_ci,
  `target_fields` text COLLATE utf8mb4_unicode_ci,
  `created` int(10) DEFAULT NULL,
  `available` tinyint(1) DEFAULT NULL,
  `version` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `crawler_media` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(40) DEFAULT NULL,
  `articlemeta_id` bigint(50) DEFAULT NULL,
  `media_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `media_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `media_content` longblob,
  `created` int(10) DEFAULT NULL,
  `modified` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
