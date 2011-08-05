-- phpMyAdmin SQL Dump
-- version 3.2.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 05, 2011 at 12:05 PM
-- Server version: 5.0.51
-- PHP Version: 5.2.6-1+lenny10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `usr_web12_1`
--

--
-- Dumping data for table `ocpn_nga_status`
--

INSERT INTO `ocpn_nga_status` (`status_id`, `description`, `status_usage`) VALUES
(1, 'Rectangular, doable in Phase 1', 'CHART'),
(2, 'Rectangular, partly doable in Phase 1 - With rectangular insets', 'CHART'),
(3, 'Rectangular, partly doable in Phase 1 - With non-rectangular insets', 'CHART'),
(4, 'Rectangular, not doable in Phase 1 because of the 90 degrees skew', 'CHART'),
(5, 'Rectangular, not doable in Phase 1 because of the scan skew', 'CHART'),
(6, 'Rectangular, not doable in Phase 1 because of the warp or bevel', 'CHART'),
(7, 'Rectangular, not doable in Phase 1 because the corners are not visible on cutouts', 'CHART'),
(8, 'Rectangular, not doable in Phase 1 because of special PLYs needed', 'CHART'),
(9, 'Not-doable in phase 1 - Composed of rectangular charts', 'CHART'),
(10, 'Not-doable in phase 1 - Composed of non-rectangular charts', 'CHART'),
(11, 'Non-rectangular', 'CHART'),
(12, 'Broken in other way', 'CHART');

