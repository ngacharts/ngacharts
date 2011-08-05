-- phpMyAdmin SQL Dump
-- version 3.2.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 05, 2011 at 12:03 PM
-- Server version: 5.0.51
-- PHP Version: 5.2.6-1+lenny10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `usr_web12_1`
--

-- --------------------------------------------------------

--
-- Table structure for table `ocpn_nga_charts`
--

CREATE TABLE IF NOT EXISTS `ocpn_nga_charts` (
  `number` mediumint(8) unsigned NOT NULL,
  `scale` mediumint(8) unsigned NOT NULL,
  `title` text NOT NULL,
  `edition` smallint(5) unsigned NOT NULL,
  `date` date NOT NULL,
  `correction` varchar(8) NOT NULL,
  `width` mediumint(8) unsigned NOT NULL,
  `height` mediumint(8) unsigned NOT NULL,
  `tiles` smallint(5) unsigned NOT NULL,
  `xtiles` tinyint(3) unsigned NOT NULL,
  `ytiles` tinyint(3) unsigned NOT NULL,
  `tilesize` smallint(5) unsigned NOT NULL,
  `zoomlevel` tinyint(3) unsigned NOT NULL,
  `has_addition` set('1') default NULL,
  `status_id` tinyint(4) default NULL,
  PRIMARY KEY  (`number`),
  UNIQUE KEY `number` (`number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ocpn_nga_charts_links`
--

CREATE TABLE IF NOT EXISTS `ocpn_nga_charts_links` (
  `number` mediumint(8) NOT NULL,
  `status` tinyint(3) default NULL,
  `maptiles` varchar(2083) default NULL,
  `image_fullsize` varchar(2083) default NULL,
  `image_fullsize_filesize` int(10) default NULL,
  `image_fullsize_md5` varchar(32) default NULL,
  UNIQUE KEY `number` (`number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ocpn_nga_charts_status`
--

CREATE TABLE IF NOT EXISTS `ocpn_nga_charts_status` (
  `number` mediumint(8) unsigned NOT NULL,
  `status` tinyint(3) unsigned default NULL,
  `maptiles` text,
  `mapimage` text,
  `mapheader` text,
  `map` text,
  `verified` tinytext,
  `comment` mediumtext,
  UNIQUE KEY `number` (`number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `ocpn_nga_charts_with_params`
--
CREATE TABLE IF NOT EXISTS `ocpn_nga_charts_with_params` (
`number` mediumint(8) unsigned
,`scale` mediumint(8) unsigned
,`title` text
,`edition` smallint(5) unsigned
,`date` date
,`correction` varchar(8)
,`width` mediumint(8) unsigned
,`height` mediumint(8) unsigned
,`tiles` smallint(5) unsigned
,`xtiles` tinyint(3) unsigned
,`ytiles` tinyint(3) unsigned
,`tilesize` smallint(5) unsigned
,`zoomlevel` tinyint(3) unsigned
,`has_additions` set('1')
,`GD` varchar(20)
,`PR` varchar(50)
,`PP` double
,`UN` varchar(10)
,`SD` varchar(10)
,`DTMx` double
,`DTMy` double
,`changed` timestamp
,`changed_by` bigint(20)
,`South` double
,`West` double
,`North` double
,`East` double
,`Sdeg` double(17,0)
,`Smin` double(17,0)
,`Ssec` double(23,0)
,`Ndeg` double(17,0)
,`Nmin` double(17,0)
,`Nsec` double(23,0)
,`Edeg` double(17,0)
,`Emin` double(17,0)
,`Esec` double(17,0)
,`Wdeg` double(17,0)
,`Wmin` double(17,0)
,`Wsec` double(17,0)
,`Xsw` int(11)
,`Ysw` int(11)
,`Xnw` int(11)
,`Ynw` int(11)
,`Xne` int(11)
,`Yne` int(11)
,`Xse` int(11)
,`Yse` int(11)
);
-- --------------------------------------------------------

--
-- Table structure for table `ocpn_nga_kap`
--

CREATE TABLE IF NOT EXISTS `ocpn_nga_kap` (
  `kap_id` int(11) NOT NULL auto_increment,
  `number` mediumint(9) NOT NULL,
  `is_main` bit(1) NOT NULL default '',
  `status_id` tinyint(4) NOT NULL default '0',
  `locked` bit(1) NOT NULL default '\0',
  `scale` mediumint(9) NOT NULL,
  `title` text character set utf8 collate utf8_unicode_ci NOT NULL,
  `NU` varchar(7) character set utf8 collate utf8_unicode_ci default NULL,
  `GD` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `PR` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `PP` double default NULL,
  `UN` varchar(10) character set utf8 collate utf8_unicode_ci default NULL,
  `SD` varchar(10) character set utf8 collate utf8_unicode_ci default NULL,
  `DTMx` double default NULL,
  `DTMy` double default NULL,
  `changed` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `changed_by` bigint(20) NOT NULL,
  `active` bit(1) NOT NULL default '',
  PRIMARY KEY  (`kap_id`),
  KEY `number` (`number`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5462 ;

-- --------------------------------------------------------

--
-- Table structure for table `ocpn_nga_kap_point`
--

CREATE TABLE IF NOT EXISTS `ocpn_nga_kap_point` (
  `point_id` int(11) NOT NULL auto_increment,
  `kap_id` int(11) NOT NULL,
  `latitude` double default NULL,
  `longitude` double default NULL,
  `x` int(11) default NULL,
  `y` int(11) default NULL,
  `point_type` set('PLY','REF','CROP') character set utf8 collate utf8_unicode_ci default NULL,
  `created_by` bigint(20) NOT NULL,
  `created` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `sequence` tinyint(4) NOT NULL,
  `active` bit(1) NOT NULL default '',
  PRIMARY KEY  (`point_id`),
  KEY `kap_id` (`kap_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

-- --------------------------------------------------------

--
-- Table structure for table `ocpn_nga_status`
--

CREATE TABLE IF NOT EXISTS `ocpn_nga_status` (
  `status_id` tinyint(3) unsigned NOT NULL auto_increment,
  `description` varchar(255) NOT NULL,
  `status_usage` set('CHART','KAP','POINT') character set utf8 collate utf8_unicode_ci NOT NULL default 'CHART',
  PRIMARY KEY  (`status_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

-- --------------------------------------------------------
