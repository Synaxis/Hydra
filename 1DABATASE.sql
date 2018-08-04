-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 18-Fev-2018 às 09:54
-- Versão do servidor: 10.1.30-MariaDB
-- PHP Version: 7.2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `naomi`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `audits`
--

CREATE TABLE `audits` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `permission` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `log` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `authentication_tokens`
--

CREATE TABLE `authentication_tokens` (
  `id` int(10) UNSIGNED NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `additional` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `comments`
--

CREATE TABLE `comments` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `topic_id` int(10) UNSIGNED NOT NULL,
  `comment` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `downloads`
--

CREATE TABLE `downloads` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `forums`
--

CREATE TABLE `forums` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `friend_requests`
--

CREATE TABLE `friend_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `sender` int(10) UNSIGNED NOT NULL,
  `receiver` int(10) UNSIGNED NOT NULL,
  `status` enum('pending','accepted','declined') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `games`
--

CREATE TABLE `games` (
  `gid` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `game_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `game_port` int(11) NOT NULL,
  `game_version` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_join` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_mapname` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `players_connected` int(11) NOT NULL,
  `players_joining` int(11) NOT NULL,
  `players_max` int(11) NOT NULL DEFAULT '32',
  `team_1` int(11) NOT NULL DEFAULT '0',
  `team_2` int(11) NOT NULL DEFAULT '0',
  `team_distribution` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `games`
--

INSERT INTO `games` (`gid`, `game_ip`, `game_port`, `game_version`, `status_join`, `status_mapname`, `players_connected`, `players_joining`, `players_max`, `team_1`, `team_2`, `team_distribution`, `created_at`, `updated_at`) VALUES
('102', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-17 08:27:49', '2018-02-17'),
('104', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-17 08:59:06', '2018-02-17'),
('106', '127.0.0.1', 16567, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-18 02:44:58', '2018-02-17'),
('107', '127.0.0.1', 16567, '1.46.222034.0', 'O', 'no_vehicles', 1, 0, 16, 1, 0, '', '2018-02-18 02:54:14', '2018-02-17'),
('108', '127.0.0.1', 16567, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-18 03:02:48', '2018-02-18'),
('109', '127.0.0.1', 16567, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-18 03:37:35', '2018-02-18'),
('110', '127.0.0.1', 16567, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-18 03:53:04', '2018-02-18'),
('112', '127.0.0.1', 16567, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-18 07:51:40', '2018-02-18'),
('12', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-13 05:42:52', '2018-02-13'),
('13', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-13 06:09:01', '2018-02-13'),
('20', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 1, 0, 16, 1, 0, '', '2018-02-14 02:39:47', '2018-02-14'),
('21', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 1, 0, 16, 0, 1, '', '2018-02-14 02:57:01', '2018-02-14'),
('25', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-14 09:36:13', '2018-02-14'),
('27', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-14 09:45:21', '2018-02-14'),
('28', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-14 09:49:30', '2018-02-14'),
('29', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-14 10:31:01', '2018-02-14'),
('30', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-14 10:37:00', '2018-02-14'),
('31', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-14 10:41:31', '2018-02-14'),
('38', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-15 03:34:37', '2018-02-15'),
('41', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-15 04:17:10', '2018-02-15'),
('44', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-15 04:40:47', '2018-02-15'),
('48', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 1, 0, 16, 1, 0, '', '2018-02-15 05:19:48', '2018-02-15'),
('49', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 1, 0, 16, 1, 0, '', '2018-02-16 02:43:20', '2018-02-16'),
('53', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-16 04:26:33', '2018-02-16'),
('66', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-16 07:20:16', '2018-02-16'),
('68', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-16 07:31:22', '2018-02-16'),
('72', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-16 07:57:56', '2018-02-16'),
('89', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-16 23:20:20', '2018-02-16'),
('91', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-17 01:39:36', '2018-02-16'),
('95', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-17 02:27:59', '2018-02-17'),
('96', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-17 02:38:09', '2018-02-17'),
('97', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-17 02:44:32', '2018-02-17'),
('98', '127.0.0.1', 18569, '1.46.222034.0', 'O', 'no_vehicles', 0, 0, 16, 0, 0, '', '2018-02-17 02:49:45', '2018-02-17');

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_heroes`
--

CREATE TABLE `game_heroes` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `heroName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `online` tinyint(1) NOT NULL DEFAULT '0',
  `ip_address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `game_heroes`
--

INSERT INTO `game_heroes` (`id`, `user_id`, `heroName`, `online`, `ip_address`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Test-Server', 0, '127.0.0.1', '2017-12-10 02:40:10', '2017-12-10 02:40:10', NULL),
(2, 2, '|ccc|xSyn', 0, '127.0.0.1', '2017-12-10 02:41:47', '2017-12-10 02:41:47', NULL),
(3, 2, 'sos', 0, '127.0.0.1', '2017-12-10 02:42:01', '2017-12-10 02:42:01', NULL),
(4, 2, 'sus', 0, '127.0.0.1', '2017-12-10 02:42:13', '2017-12-10 02:42:13', NULL),
(5, 3, 'asdfasdf', 0, '127.0.0.1', '2017-12-10 02:59:33', '2017-12-10 02:59:33', NULL),
(6, 5, 'ghhh', 0, '127.0.0.1', '2018-01-30 03:36:43', '2018-01-30 03:36:43', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_player_regions`
--

CREATE TABLE `game_player_regions` (
  `userid` int(11) NOT NULL,
  `region` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_player_server_preferences`
--

CREATE TABLE `game_player_server_preferences` (
  `userid` int(11) NOT NULL,
  `gid` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_servers`
--

CREATE TABLE `game_servers` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `servername` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secretKey` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `game_servers`
--

INSERT INTO `game_servers` (`id`, `user_id`, `servername`, `secretKey`, `created_at`, `updated_at`) VALUES
(1, 1, 'Test-Server', 'Test-Server', NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_server_client`
--

CREATE TABLE `game_server_client` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `community_name` varchar(255) DEFAULT NULL,
  `ip_address` varchar(50) NOT NULL,
  `client_version` varchar(50) NOT NULL,
  `port` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `game_server_client`
--

INSERT INTO `game_server_client` (`id`, `name`, `community_name`, `ip_address`, `client_version`, `port`) VALUES
(1, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(2, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(3, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(4, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(5, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(6, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(7, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(8, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(9, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(10, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(11, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(12, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(13, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(14, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(15, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(16, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(17, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(18, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:50210)\"', 'dice', '192.168.0.10', '1.46.222034.0', 50210),
(19, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(20, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(21, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(22, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(23, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(24, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(25, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(26, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(27, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(28, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(29, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(30, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(31, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(32, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(33, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(34, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(35, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(36, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(37, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(38, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(39, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(40, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(41, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(42, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(43, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(44, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(45, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(46, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(47, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(48, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(49, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(50, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(51, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(52, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(53, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(54, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(55, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(56, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(57, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(58, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(59, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(60, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(61, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(62, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(63, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(64, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(65, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(66, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(67, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(68, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(69, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(70, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(71, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(72, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(73, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(74, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(75, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(76, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(77, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(78, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(79, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(80, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(81, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(82, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(83, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(84, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(85, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(86, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(87, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(88, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(89, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(90, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(91, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(92, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(93, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(94, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(95, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(96, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(97, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(98, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(99, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(100, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(101, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(102, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(103, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(104, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(105, '\"[iad]EA Battlefield Heroes Server(192.168.56.1:18569)\"', 'dice', '192.168.0.10', '1.46.222034.0', 18569),
(106, '\"[iad]Default Server Name(192.168.56.1:16567)\"', '', '192.168.0.10', '1.46.222034.0', 16567),
(107, '\"[iad]Default Server Name(192.168.56.1:16567)\"', '', '192.168.0.10', '1.46.222034.0', 16567),
(108, '\"[iad]Default Server Name(192.168.56.1:16567)\"', '', '192.168.0.10', '1.46.222034.0', 16567),
(109, '\"[iad]Default Server Name(192.168.56.1:16567)\"', '', '192.168.0.10', '1.46.222034.0', 16567),
(110, '\"[iad]Default Server Name(192.168.56.1:16567)\"', '', '192.168.0.10', '1.46.222034.0', 16567),
(111, '\"[iad]Default Server Name(192.168.56.1:16567)\"', '', '192.168.0.10', '1.46.222034.0', 16567),
(112, '\"[iad]Default Server Name(192.168.56.1:16567)\"', '', '192.168.0.10', '1.46.222034.0', 16567);

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_server_player_stats`
--

CREATE TABLE `game_server_player_stats` (
  `id` int(10) UNSIGNED NOT NULL,
  `gid` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pid` int(10) UNSIGNED NOT NULL,
  `statsKey` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `statsValue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `game_server_player_stats`
--

INSERT INTO `game_server_player_stats` (`id`, `gid`, `pid`, `statsKey`, `statsValue`, `created_at`, `updated_at`) VALUES
(748, '4', 5, 'HMO', '5', '2018-02-12 23:22:15', '2018-02-12 23:36:27'),
(749, '4', 5, 'P-cid', '0', '2018-02-12 23:22:15', '2018-02-12 23:24:27'),
(750, '4', 5, 'P-dc', 'iad', '2018-02-12 23:22:15', '2018-02-12 23:24:27'),
(751, '4', 5, 'P-ip', '127.0.0.1', '2018-02-12 23:22:15', '2018-02-12 23:24:27'),
(752, '4', 5, 'LID', '1', '2018-02-12 23:22:15', '2018-02-12 23:36:27'),
(753, '4', 5, 'P-level', '1', '2018-02-12 23:22:47', '2018-02-12 23:25:27'),
(754, '4', 5, 'P-team', '2', '2018-02-12 23:22:47', '2018-02-12 23:25:27'),
(755, '4', 5, 'P-time', '11 min 48 sec ', '2018-02-12 23:22:47', '2018-02-12 23:36:27'),
(756, '4', 5, 'P-kit', '1', '2018-02-12 23:22:47', '2018-02-12 23:25:27'),
(757, '4', 5, 'P-kills', '0', '2018-02-12 23:22:47', '2018-02-12 23:25:27'),
(758, '4', 5, 'P-ping', '18', '2018-02-12 23:22:47', '2018-02-12 23:36:27'),
(759, '4', 5, 'P-score', '0', '2018-02-12 23:22:47', '2018-02-12 23:25:27'),
(760, '4', 5, 'P-elo', '1000', '2018-02-12 23:22:47', '2018-02-12 23:25:27'),
(761, '6', 5, 'P-cid', '0', '2018-02-12 23:51:38', NULL),
(762, '6', 5, 'P-dc', 'iad', '2018-02-12 23:51:38', NULL),
(763, '6', 5, 'P-ip', '127.0.0.1', '2018-02-12 23:51:38', NULL),
(764, '6', 5, 'LID', '1', '2018-02-12 23:51:38', '2018-02-12 23:52:06'),
(765, '6', 5, 'HMO', '5', '2018-02-12 23:51:38', '2018-02-12 23:52:06'),
(766, '6', 5, 'P-elo', '1000', '2018-02-12 23:52:06', NULL),
(767, '6', 5, 'P-score', '0', '2018-02-12 23:52:06', NULL),
(768, '6', 5, 'P-team', '2', '2018-02-12 23:52:06', NULL),
(769, '6', 5, 'P-time', '10 sec ', '2018-02-12 23:52:06', NULL),
(770, '6', 5, 'P-kills', '0', '2018-02-12 23:52:06', NULL),
(771, '6', 5, 'P-kit', '1', '2018-02-12 23:52:06', NULL),
(772, '6', 5, 'P-level', '1', '2018-02-12 23:52:06', NULL),
(773, '6', 5, 'P-ping', '14', '2018-02-12 23:52:06', NULL),
(774, '7', 2, 'HMO', '2', '2018-02-13 03:50:14', '2018-02-13 03:50:45'),
(775, '7', 2, 'P-cid', '0', '2018-02-13 03:50:14', NULL),
(776, '7', 2, 'P-dc', 'iad', '2018-02-13 03:50:14', NULL),
(777, '7', 2, 'P-ip', '127.0.0.1', '2018-02-13 03:50:14', NULL),
(778, '7', 2, 'LID', '1', '2018-02-13 03:50:14', '2018-02-13 03:50:45'),
(779, '7', 2, 'P-kills', '0', '2018-02-13 03:50:45', NULL),
(780, '7', 2, 'P-level', '1', '2018-02-13 03:50:45', NULL),
(781, '7', 2, 'P-score', '0', '2018-02-13 03:50:45', NULL),
(782, '7', 2, 'P-elo', '1000', '2018-02-13 03:50:45', NULL),
(783, '7', 2, 'P-kit', '2', '2018-02-13 03:50:45', NULL),
(784, '7', 2, 'P-ping', '20', '2018-02-13 03:50:45', NULL),
(785, '7', 2, 'P-team', '1', '2018-02-13 03:50:45', NULL),
(786, '7', 2, 'P-time', '10 sec ', '2018-02-13 03:50:45', NULL),
(787, '8', 3, 'LID', '1', '2018-02-13 03:53:09', '2018-02-13 03:53:41'),
(788, '8', 3, 'HMO', '3', '2018-02-13 03:53:09', '2018-02-13 03:53:41'),
(789, '8', 3, 'P-cid', '0', '2018-02-13 03:53:09', '2018-02-13 03:53:41'),
(790, '8', 3, 'P-dc', 'iad', '2018-02-13 03:53:09', '2018-02-13 03:53:41'),
(791, '8', 3, 'P-ip', '127.0.0.1', '2018-02-13 03:53:09', '2018-02-13 03:53:41'),
(792, '9', 2, 'P-cid', '0', '2018-02-13 04:53:23', '2018-02-13 04:57:14'),
(793, '9', 2, 'P-dc', 'iad', '2018-02-13 04:53:23', '2018-02-13 04:57:14'),
(794, '9', 2, 'P-ip', '127.0.0.1', '2018-02-13 04:53:23', '2018-02-13 04:57:14'),
(795, '9', 2, 'LID', '1', '2018-02-13 04:53:23', '2018-02-13 04:58:41'),
(796, '9', 2, 'HMO', '2', '2018-02-13 04:53:23', '2018-02-13 04:58:41'),
(797, '9', 2, 'P-kit', '2', '2018-02-13 04:57:41', NULL),
(798, '9', 2, 'P-ping', '14', '2018-02-13 04:57:41', '2018-02-13 04:58:41'),
(799, '9', 2, 'P-time', '1 min 10 sec ', '2018-02-13 04:57:41', '2018-02-13 04:58:41'),
(800, '9', 2, 'P-elo', '1000', '2018-02-13 04:57:41', NULL),
(801, '9', 2, 'P-kills', '0', '2018-02-13 04:57:41', NULL),
(802, '9', 2, 'P-level', '1', '2018-02-13 04:57:41', NULL),
(803, '9', 2, 'P-score', '0', '2018-02-13 04:57:41', NULL),
(804, '9', 2, 'P-team', '1', '2018-02-13 04:57:41', NULL),
(805, '12', 3, 'HMO', '3', '2018-02-13 05:42:57', NULL),
(806, '12', 3, 'P-cid', '0', '2018-02-13 05:42:57', NULL),
(807, '12', 3, 'P-dc', 'iad', '2018-02-13 05:42:57', NULL),
(808, '12', 3, 'P-ip', '127.0.0.1', '2018-02-13 05:42:57', NULL),
(809, '12', 3, 'LID', '1', '2018-02-13 05:42:57', NULL),
(810, '13', 2, 'P-ip', '127.0.0.1', '2018-02-13 06:09:26', '2018-02-13 06:11:39'),
(811, '13', 2, 'LID', '1', '2018-02-13 06:09:26', '2018-02-13 06:11:39'),
(812, '13', 2, 'HMO', '2', '2018-02-13 06:09:26', '2018-02-13 06:11:39'),
(813, '13', 2, 'P-cid', '0', '2018-02-13 06:09:26', '2018-02-13 06:11:39'),
(814, '13', 2, 'P-dc', 'iad', '2018-02-13 06:09:26', '2018-02-13 06:11:39'),
(815, '13', 2, 'P-score', '0', '2018-02-13 06:09:57', NULL),
(816, '13', 2, 'P-team', '1', '2018-02-13 06:09:57', NULL),
(817, '13', 2, 'P-elo', '1000', '2018-02-13 06:09:57', NULL),
(818, '13', 2, 'P-kit', '2', '2018-02-13 06:09:57', NULL),
(819, '13', 2, 'P-ping', '8', '2018-02-13 06:09:57', NULL),
(820, '13', 2, 'P-level', '1', '2018-02-13 06:09:57', NULL),
(821, '13', 2, 'P-time', '10 sec ', '2018-02-13 06:09:57', NULL),
(822, '13', 2, 'P-kills', '0', '2018-02-13 06:09:57', NULL),
(823, '14', 2, 'HMO', '2', '2018-02-13 08:26:12', NULL),
(824, '14', 2, 'P-cid', '0', '2018-02-13 08:26:12', NULL),
(825, '14', 2, 'P-dc', 'iad', '2018-02-13 08:26:12', NULL),
(826, '14', 2, 'P-ip', '127.0.0.1', '2018-02-13 08:26:12', NULL),
(827, '14', 2, 'LID', '1', '2018-02-13 08:26:12', NULL),
(828, '15', 2, 'HMO', '2', '2018-02-13 08:34:32', NULL),
(829, '15', 2, 'P-cid', '0', '2018-02-13 08:34:32', NULL),
(830, '15', 2, 'P-dc', 'iad', '2018-02-13 08:34:32', NULL),
(831, '15', 2, 'P-ip', '127.0.0.1', '2018-02-13 08:34:32', NULL),
(832, '15', 2, 'LID', '1', '2018-02-13 08:34:32', NULL),
(833, '16', 2, 'HMO', '2', '2018-02-13 08:47:12', NULL),
(834, '16', 2, 'P-cid', '0', '2018-02-13 08:47:12', NULL),
(835, '16', 2, 'P-dc', 'iad', '2018-02-13 08:47:12', NULL),
(836, '16', 2, 'P-ip', '127.0.0.1', '2018-02-13 08:47:12', NULL),
(837, '16', 2, 'LID', '1', '2018-02-13 08:47:12', NULL),
(838, '19', 3, 'LID', '1', '2018-02-14 02:37:55', NULL),
(839, '19', 3, 'HMO', '3', '2018-02-14 02:37:55', NULL),
(840, '19', 3, 'P-cid', '0', '2018-02-14 02:37:55', NULL),
(841, '19', 3, 'P-dc', 'iad', '2018-02-14 02:37:55', NULL),
(842, '19', 3, 'P-ip', '127.0.0.1', '2018-02-14 02:37:55', NULL),
(843, '20', 2, 'HMO', '2', '2018-02-14 02:39:52', '2018-02-14 02:55:40'),
(844, '20', 2, 'P-cid', '0', '2018-02-14 02:39:52', '2018-02-14 02:44:40'),
(845, '20', 2, 'P-dc', 'iad', '2018-02-14 02:39:52', '2018-02-14 02:44:40'),
(846, '20', 2, 'P-ip', '127.0.0.1', '2018-02-14 02:39:52', '2018-02-14 02:44:40'),
(847, '20', 2, 'LID', '1', '2018-02-14 02:39:52', '2018-02-14 02:55:40'),
(848, '20', 2, 'P-team', '1', '2018-02-14 02:40:21', '2018-02-14 02:45:40'),
(849, '20', 2, 'P-elo', '1000', '2018-02-14 02:40:21', '2018-02-14 02:45:40'),
(850, '20', 2, 'P-kills', '0', '2018-02-14 02:40:21', '2018-02-14 02:45:40'),
(851, '20', 2, 'P-level', '1', '2018-02-14 02:40:21', '2018-02-14 02:45:40'),
(852, '20', 2, 'P-ping', '17', '2018-02-14 02:40:21', '2018-02-14 02:55:40'),
(853, '20', 2, 'P-score', '0', '2018-02-14 02:40:21', '2018-02-14 02:45:40'),
(854, '20', 2, 'P-time', '10 min 48 sec ', '2018-02-14 02:40:21', '2018-02-14 02:55:40'),
(855, '20', 2, 'P-kit', '2', '2018-02-14 02:40:21', '2018-02-14 02:45:40'),
(856, '21', 2, 'LID', '1', '2018-02-14 02:57:06', '2018-02-14 02:57:35'),
(857, '21', 2, 'HMO', '2', '2018-02-14 02:57:06', '2018-02-14 02:57:35'),
(858, '21', 2, 'P-cid', '0', '2018-02-14 02:57:06', NULL),
(859, '21', 2, 'P-dc', 'iad', '2018-02-14 02:57:06', NULL),
(860, '21', 2, 'P-ip', '127.0.0.1', '2018-02-14 02:57:06', NULL),
(861, '21', 2, 'P-ping', '21', '2018-02-14 02:57:35', NULL),
(862, '21', 2, 'P-elo', '1000', '2018-02-14 02:57:35', NULL),
(863, '21', 2, 'P-level', '1', '2018-02-14 02:57:35', NULL),
(864, '21', 2, 'P-score', '0', '2018-02-14 02:57:35', NULL),
(865, '21', 2, 'P-team', '1', '2018-02-14 02:57:35', NULL),
(866, '21', 2, 'P-time', '10 sec ', '2018-02-14 02:57:35', NULL),
(867, '21', 2, 'P-kills', '0', '2018-02-14 02:57:35', NULL),
(868, '21', 2, 'P-kit', '2', '2018-02-14 02:57:35', NULL),
(869, '21', 3, 'LID', '1', '2018-02-14 02:58:41', '2018-02-14 03:33:15'),
(870, '21', 3, 'HMO', '3', '2018-02-14 02:58:41', '2018-02-14 03:33:15'),
(871, '21', 3, 'P-cid', '0', '2018-02-14 02:58:41', '2018-02-14 03:15:15'),
(872, '21', 3, 'P-dc', 'iad', '2018-02-14 02:58:41', '2018-02-14 03:15:15'),
(873, '21', 3, 'P-ip', '127.0.0.1', '2018-02-14 02:58:41', '2018-02-14 03:15:15'),
(874, '21', 3, 'P-kills', '0', '2018-02-14 02:59:41', '2018-02-14 03:16:15'),
(875, '21', 3, 'P-kit', '2', '2018-02-14 02:59:41', '2018-02-14 03:16:15'),
(876, '21', 3, 'P-level', '1', '2018-02-14 02:59:41', '2018-02-14 03:16:15'),
(877, '21', 3, 'P-ping', '10', '2018-02-14 02:59:41', '2018-02-14 03:33:15'),
(878, '21', 3, 'P-score', '0', '2018-02-14 02:59:41', '2018-02-14 03:16:15'),
(879, '21', 3, 'P-elo', '1000', '2018-02-14 02:59:41', '2018-02-14 03:16:15'),
(880, '21', 3, 'P-team', '2', '2018-02-14 02:59:41', '2018-02-14 03:16:15'),
(881, '21', 3, 'P-time', '17 min 49 sec ', '2018-02-14 02:59:41', '2018-02-14 03:33:15'),
(882, '22', 2, 'LID', '1', '2018-02-14 04:30:13', '2018-02-14 04:30:53'),
(883, '22', 2, 'HMO', '2', '2018-02-14 04:30:13', '2018-02-14 04:30:53'),
(884, '22', 2, 'P-cid', '0', '2018-02-14 04:30:13', NULL),
(885, '22', 2, 'P-dc', 'iad', '2018-02-14 04:30:13', NULL),
(886, '22', 2, 'P-ip', '127.0.0.1', '2018-02-14 04:30:13', NULL),
(887, '22', 2, 'P-kit', '2', '2018-02-14 04:30:53', NULL),
(888, '22', 2, 'P-score', '0', '2018-02-14 04:30:53', NULL),
(889, '22', 2, 'P-time', '10 sec ', '2018-02-14 04:30:53', NULL),
(890, '22', 2, 'P-ping', '20', '2018-02-14 04:30:53', NULL),
(891, '22', 2, 'P-elo', '1000', '2018-02-14 04:30:53', NULL),
(892, '22', 2, 'P-kills', '0', '2018-02-14 04:30:53', NULL),
(893, '22', 2, 'P-level', '1', '2018-02-14 04:30:53', NULL),
(894, '22', 2, 'P-team', '1', '2018-02-14 04:30:53', NULL),
(895, '23', 2, 'P-ip', '127.0.0.1', '2018-02-14 09:11:01', NULL),
(896, '23', 2, 'LID', '1', '2018-02-14 09:11:01', NULL),
(897, '23', 2, 'HMO', '2', '2018-02-14 09:11:01', NULL),
(898, '23', 2, 'P-cid', '0', '2018-02-14 09:11:01', NULL),
(899, '23', 2, 'P-dc', 'iad', '2018-02-14 09:11:01', NULL),
(900, '23', 3, 'HMO', '3', '2018-02-14 09:13:32', '2018-02-14 09:15:42'),
(901, '23', 3, 'P-cid', '0', '2018-02-14 09:13:32', '2018-02-14 09:15:42'),
(902, '23', 3, 'P-dc', 'iad', '2018-02-14 09:13:32', '2018-02-14 09:15:42'),
(903, '23', 3, 'P-ip', '127.0.0.1', '2018-02-14 09:13:32', '2018-02-14 09:15:42'),
(904, '23', 3, 'LID', '1', '2018-02-14 09:13:32', '2018-02-14 09:15:42'),
(905, '25', 2, 'LID', '1', '2018-02-14 09:36:17', NULL),
(906, '25', 2, 'HMO', '2', '2018-02-14 09:36:17', NULL),
(907, '25', 2, 'P-cid', '0', '2018-02-14 09:36:17', NULL),
(908, '25', 2, 'P-dc', 'iad', '2018-02-14 09:36:17', NULL),
(909, '25', 2, 'P-ip', '127.0.0.1', '2018-02-14 09:36:17', NULL),
(910, '27', 2, 'HMO', '2', '2018-02-14 09:45:34', NULL),
(911, '27', 2, 'P-cid', '0', '2018-02-14 09:45:34', NULL),
(912, '27', 2, 'P-dc', 'iad', '2018-02-14 09:45:34', NULL),
(913, '27', 2, 'P-ip', '127.0.0.1', '2018-02-14 09:45:34', NULL),
(914, '27', 2, 'LID', '1', '2018-02-14 09:45:34', NULL),
(915, '28', 3, 'P-dc', 'iad', '2018-02-14 09:49:40', NULL),
(916, '28', 3, 'P-ip', '127.0.0.1', '2018-02-14 09:49:40', NULL),
(917, '28', 3, 'LID', '1', '2018-02-14 09:49:40', NULL),
(918, '28', 3, 'HMO', '3', '2018-02-14 09:49:40', NULL),
(919, '28', 3, 'P-cid', '0', '2018-02-14 09:49:40', NULL),
(920, '32', 2, 'P-cid', '0', '2018-02-14 19:01:43', NULL),
(921, '32', 2, 'P-dc', 'iad', '2018-02-14 19:01:43', NULL),
(922, '32', 2, 'P-ip', '127.0.0.1', '2018-02-14 19:01:43', NULL),
(923, '32', 2, 'LID', '1', '2018-02-14 19:01:43', NULL),
(924, '32', 2, 'HMO', '2', '2018-02-14 19:01:43', NULL),
(925, '33', 2, 'LID', '1', '2018-02-15 02:32:14', '2018-02-15 02:35:51'),
(926, '33', 2, 'HMO', '2', '2018-02-15 02:32:14', '2018-02-15 02:35:51'),
(927, '33', 2, 'P-cid', '0', '2018-02-15 02:32:14', '2018-02-15 02:35:51'),
(928, '33', 2, 'P-dc', 'iad', '2018-02-15 02:32:14', '2018-02-15 02:35:51'),
(929, '33', 2, 'P-ip', '127.0.0.1', '2018-02-15 02:32:14', '2018-02-15 02:35:51'),
(930, '33', 2, 'P-kit', '2', '2018-02-15 02:32:45', NULL),
(931, '33', 2, 'P-team', '1', '2018-02-15 02:32:45', NULL),
(932, '33', 2, 'P-elo', '1000', '2018-02-15 02:32:45', NULL),
(933, '33', 2, 'P-kills', '0', '2018-02-15 02:32:45', NULL),
(934, '33', 2, 'P-level', '1', '2018-02-15 02:32:45', NULL),
(935, '33', 2, 'P-ping', '21', '2018-02-15 02:32:45', '2018-02-15 02:33:45'),
(936, '33', 2, 'P-score', '13', '2018-02-15 02:32:45', '2018-02-15 02:33:45'),
(937, '33', 2, 'P-time', '1 min 10 sec ', '2018-02-15 02:32:45', '2018-02-15 02:33:45'),
(938, '34', 2, 'LID', '1', '2018-02-15 02:47:11', NULL),
(939, '34', 2, 'HMO', '2', '2018-02-15 02:47:11', NULL),
(940, '34', 2, 'P-cid', '0', '2018-02-15 02:47:11', NULL),
(941, '34', 2, 'P-dc', 'iad', '2018-02-15 02:47:11', NULL),
(942, '34', 2, 'P-ip', '127.0.0.1', '2018-02-15 02:47:11', NULL),
(943, '35', 2, 'HMO', '2', '2018-02-15 03:02:15', NULL),
(944, '35', 2, 'P-cid', '0', '2018-02-15 03:02:15', NULL),
(945, '35', 2, 'P-dc', 'iad', '2018-02-15 03:02:15', NULL),
(946, '35', 2, 'P-ip', '127.0.0.1', '2018-02-15 03:02:15', NULL),
(947, '35', 2, 'LID', '1', '2018-02-15 03:02:15', NULL),
(948, '46', 2, 'P-ip', '127.0.0.1', '2018-02-15 05:07:03', NULL),
(949, '46', 2, 'LID', '1', '2018-02-15 05:07:03', NULL),
(950, '46', 2, 'HMO', '2', '2018-02-15 05:07:03', NULL),
(951, '46', 2, 'P-cid', '0', '2018-02-15 05:07:03', NULL),
(952, '46', 2, 'P-dc', 'iad', '2018-02-15 05:07:03', NULL),
(953, '48', 2, 'P-dc', 'iad', '2018-02-15 05:20:15', NULL),
(954, '48', 2, 'P-ip', '127.0.0.1', '2018-02-15 05:20:15', NULL),
(955, '48', 2, 'LID', '1', '2018-02-15 05:20:15', '2018-02-15 05:20:42'),
(956, '48', 2, 'HMO', '2', '2018-02-15 05:20:15', '2018-02-15 05:20:42'),
(957, '48', 2, 'P-cid', '0', '2018-02-15 05:20:15', NULL),
(958, '48', 2, 'P-kills', '0', '2018-02-15 05:20:42', NULL),
(959, '48', 2, 'P-kit', '2', '2018-02-15 05:20:42', NULL),
(960, '48', 2, 'P-level', '1', '2018-02-15 05:20:42', NULL),
(961, '48', 2, 'P-ping', '15', '2018-02-15 05:20:42', NULL),
(962, '48', 2, 'P-score', '0', '2018-02-15 05:20:42', NULL),
(963, '48', 2, 'P-team', '1', '2018-02-15 05:20:42', NULL),
(964, '48', 2, 'P-time', '10 sec ', '2018-02-15 05:20:42', NULL),
(965, '48', 2, 'P-elo', '1000', '2018-02-15 05:20:42', NULL),
(966, '49', 2, 'LID', '1', '2018-02-16 02:43:41', '2018-02-16 02:44:28'),
(967, '49', 2, 'HMO', '2', '2018-02-16 02:43:41', '2018-02-16 02:44:28'),
(968, '49', 2, 'P-cid', '0', '2018-02-16 02:43:41', '2018-02-16 02:44:00'),
(969, '49', 2, 'P-dc', 'iad', '2018-02-16 02:43:41', '2018-02-16 02:44:00'),
(970, '49', 2, 'P-ip', '127.0.0.1', '2018-02-16 02:43:41', '2018-02-16 02:44:00'),
(971, '49', 2, 'P-kit', '2', '2018-02-16 02:44:28', NULL),
(972, '49', 2, 'P-kills', '0', '2018-02-16 02:44:28', NULL),
(973, '49', 2, 'P-level', '1', '2018-02-16 02:44:28', NULL),
(974, '49', 2, 'P-ping', '26', '2018-02-16 02:44:28', NULL),
(975, '49', 2, 'P-score', '0', '2018-02-16 02:44:28', NULL),
(976, '49', 2, 'P-team', '1', '2018-02-16 02:44:28', NULL),
(977, '49', 2, 'P-time', '10 sec ', '2018-02-16 02:44:28', NULL),
(978, '49', 2, 'P-elo', '1000', '2018-02-16 02:44:28', NULL),
(979, '50', 2, 'LID', '1', '2018-02-16 02:57:20', NULL),
(980, '50', 2, 'HMO', '2', '2018-02-16 02:57:20', NULL),
(981, '50', 2, 'P-cid', '0', '2018-02-16 02:57:20', NULL),
(982, '50', 2, 'P-dc', 'iad', '2018-02-16 02:57:20', NULL),
(983, '50', 2, 'P-ip', '127.0.0.1', '2018-02-16 02:57:20', NULL),
(984, '51', 2, 'P-cid', '0', '2018-02-16 03:32:21', NULL),
(985, '51', 2, 'P-dc', 'iad', '2018-02-16 03:32:21', NULL),
(986, '51', 2, 'P-ip', '127.0.0.1', '2018-02-16 03:32:21', NULL),
(987, '51', 2, 'LID', '1', '2018-02-16 03:32:21', '2018-02-16 03:32:51'),
(988, '51', 2, 'HMO', '2', '2018-02-16 03:32:21', '2018-02-16 03:32:51'),
(989, '51', 2, 'P-ping', '16', '2018-02-16 03:32:51', NULL),
(990, '51', 2, 'P-team', '1', '2018-02-16 03:32:51', NULL),
(991, '51', 2, 'P-elo', '1000', '2018-02-16 03:32:51', NULL),
(992, '51', 2, 'P-level', '1', '2018-02-16 03:32:51', NULL),
(993, '51', 2, 'P-kills', '0', '2018-02-16 03:32:51', NULL),
(994, '51', 2, 'P-kit', '2', '2018-02-16 03:32:51', NULL),
(995, '51', 2, 'P-score', '0', '2018-02-16 03:32:51', NULL),
(996, '51', 2, 'P-time', '10 sec ', '2018-02-16 03:32:51', NULL),
(997, '54', 2, 'LID', '1', '2018-02-16 04:29:23', NULL),
(998, '54', 2, 'HMO', '2', '2018-02-16 04:29:23', NULL),
(999, '54', 2, 'P-cid', '0', '2018-02-16 04:29:23', NULL),
(1000, '54', 2, 'P-dc', 'iad', '2018-02-16 04:29:23', NULL),
(1001, '54', 2, 'P-ip', '127.0.0.1', '2018-02-16 04:29:23', NULL),
(1002, '55', 2, 'LID', '1', '2018-02-16 04:34:25', '2018-02-16 04:34:53'),
(1003, '55', 2, 'HMO', '2', '2018-02-16 04:34:25', '2018-02-16 04:34:53'),
(1004, '55', 2, 'P-cid', '0', '2018-02-16 04:34:25', NULL),
(1005, '55', 2, 'P-dc', 'iad', '2018-02-16 04:34:25', NULL),
(1006, '55', 2, 'P-ip', '127.0.0.1', '2018-02-16 04:34:25', NULL),
(1007, '55', 2, 'P-elo', '1000', '2018-02-16 04:34:53', NULL),
(1008, '55', 2, 'P-kills', '0', '2018-02-16 04:34:53', NULL),
(1009, '55', 2, 'P-ping', '25', '2018-02-16 04:34:53', NULL),
(1010, '55', 2, 'P-team', '1', '2018-02-16 04:34:53', NULL),
(1011, '55', 2, 'P-time', '10 sec ', '2018-02-16 04:34:53', NULL),
(1012, '55', 2, 'P-kit', '2', '2018-02-16 04:34:53', NULL),
(1013, '55', 2, 'P-level', '1', '2018-02-16 04:34:53', NULL),
(1014, '55', 2, 'P-score', '0', '2018-02-16 04:34:53', NULL),
(1015, '65', 2, 'LID', '1', '2018-02-16 07:02:50', NULL),
(1016, '65', 2, 'HMO', '2', '2018-02-16 07:02:50', NULL),
(1017, '65', 2, 'P-cid', '0', '2018-02-16 07:02:50', NULL),
(1018, '65', 2, 'P-dc', 'iad', '2018-02-16 07:02:50', NULL),
(1019, '65', 2, 'P-ip', '127.0.0.1', '2018-02-16 07:02:50', NULL),
(1020, '66', 2, 'P-ip', '127.0.0.1', '2018-02-16 07:20:36', NULL),
(1021, '66', 2, 'LID', '1', '2018-02-16 07:20:36', NULL),
(1022, '66', 2, 'HMO', '2', '2018-02-16 07:20:36', NULL),
(1023, '66', 2, 'P-cid', '0', '2018-02-16 07:20:36', NULL),
(1024, '66', 2, 'P-dc', 'iad', '2018-02-16 07:20:36', NULL),
(1025, '72', 2, 'HMO', '2', '2018-02-16 08:01:56', NULL),
(1026, '72', 2, 'P-cid', '0', '2018-02-16 08:01:56', NULL),
(1027, '72', 2, 'P-dc', 'iad', '2018-02-16 08:01:56', NULL),
(1028, '72', 2, 'P-ip', '127.0.0.1', '2018-02-16 08:01:56', NULL),
(1029, '72', 2, 'LID', '1', '2018-02-16 08:01:56', NULL),
(1030, '92', 2, 'P-cid', '0', '2018-02-17 02:15:00', NULL),
(1031, '92', 2, 'P-dc', 'iad', '2018-02-17 02:15:00', NULL),
(1032, '92', 2, 'P-ip', '127.0.0.1', '2018-02-17 02:15:00', NULL),
(1033, '92', 2, 'LID', '1', '2018-02-17 02:15:00', NULL),
(1034, '92', 2, 'HMO', '2', '2018-02-17 02:15:00', NULL),
(1035, '93', 2, 'LID', '1', '2018-02-17 02:21:02', NULL),
(1036, '93', 2, 'HMO', '2', '2018-02-17 02:21:02', NULL),
(1037, '93', 2, 'P-cid', '0', '2018-02-17 02:21:02', NULL),
(1038, '93', 2, 'P-dc', 'iad', '2018-02-17 02:21:02', NULL),
(1039, '93', 2, 'P-ip', '127.0.0.1', '2018-02-17 02:21:02', NULL),
(1040, '94', 2, 'P-cid', '0', '2018-02-17 02:24:00', '2018-02-17 02:26:13'),
(1041, '94', 2, 'P-dc', 'iad', '2018-02-17 02:24:00', '2018-02-17 02:26:13'),
(1042, '94', 2, 'P-ip', '127.0.0.1', '2018-02-17 02:24:00', '2018-02-17 02:26:13'),
(1043, '94', 2, 'LID', '1', '2018-02-17 02:24:00', '2018-02-17 02:26:13'),
(1044, '94', 2, 'HMO', '2', '2018-02-17 02:24:00', '2018-02-17 02:26:13'),
(1045, '94', 2, 'P-kit', '2', '2018-02-17 02:24:30', NULL),
(1046, '94', 2, 'P-score', '0', '2018-02-17 02:24:30', NULL),
(1047, '94', 2, 'P-time', '10 sec ', '2018-02-17 02:24:30', NULL),
(1048, '94', 2, 'P-elo', '1000', '2018-02-17 02:24:30', NULL),
(1049, '94', 2, 'P-kills', '0', '2018-02-17 02:24:30', NULL),
(1050, '94', 2, 'P-level', '1', '2018-02-17 02:24:30', NULL),
(1051, '94', 2, 'P-ping', '23', '2018-02-17 02:24:30', NULL),
(1052, '94', 2, 'P-team', '1', '2018-02-17 02:24:30', NULL),
(1053, '95', 2, 'HMO', '2', '2018-02-17 02:35:17', NULL),
(1054, '95', 2, 'P-cid', '0', '2018-02-17 02:35:17', NULL),
(1055, '95', 2, 'P-dc', 'iad', '2018-02-17 02:35:17', NULL),
(1056, '95', 2, 'P-ip', '127.0.0.1', '2018-02-17 02:35:17', NULL),
(1057, '95', 2, 'LID', '1', '2018-02-17 02:35:17', NULL),
(1058, '99', 2, 'HMO', '2', '2018-02-17 03:28:52', NULL),
(1059, '99', 2, 'P-cid', '0', '2018-02-17 03:28:52', NULL),
(1060, '99', 2, 'P-dc', 'iad', '2018-02-17 03:28:52', NULL),
(1061, '99', 2, 'P-ip', '127.0.0.1', '2018-02-17 03:28:52', NULL),
(1062, '99', 2, 'LID', '1', '2018-02-17 03:28:52', NULL),
(1063, '100', 2, 'HMO', '2', '2018-02-17 03:34:05', NULL),
(1064, '100', 2, 'P-cid', '0', '2018-02-17 03:34:05', NULL),
(1065, '100', 2, 'P-dc', 'iad', '2018-02-17 03:34:05', NULL),
(1066, '100', 2, 'P-ip', '127.0.0.1', '2018-02-17 03:34:05', NULL),
(1067, '100', 2, 'LID', '1', '2018-02-17 03:34:05', NULL),
(1068, '101', 2, 'HMO', '2', '2018-02-17 03:47:37', NULL),
(1069, '101', 2, 'P-cid', '0', '2018-02-17 03:47:37', NULL),
(1070, '101', 2, 'P-dc', 'iad', '2018-02-17 03:47:37', NULL),
(1071, '101', 2, 'P-ip', '127.0.0.1', '2018-02-17 03:47:37', NULL),
(1072, '101', 2, 'LID', '1', '2018-02-17 03:47:37', NULL),
(1073, '102', 3, 'P-cid', '0', '2018-02-17 08:28:08', NULL),
(1074, '102', 3, 'P-dc', 'iad', '2018-02-17 08:28:08', NULL),
(1075, '102', 3, 'P-ip', '127.0.0.1', '2018-02-17 08:28:08', NULL),
(1076, '102', 3, 'LID', '1', '2018-02-17 08:28:08', NULL),
(1077, '102', 3, 'HMO', '3', '2018-02-17 08:28:08', NULL),
(1078, '107', 2, 'P-ip', '127.0.0.1', '2018-02-18 02:54:24', NULL),
(1079, '107', 2, 'LID', '1', '2018-02-18 02:54:24', '2018-02-18 02:55:54'),
(1080, '107', 2, 'HMO', '2', '2018-02-18 02:54:24', '2018-02-18 02:55:54'),
(1081, '107', 2, 'P-cid', '0', '2018-02-18 02:54:24', NULL),
(1082, '107', 2, 'P-dc', 'iad', '2018-02-18 02:54:24', NULL),
(1083, '107', 2, 'P-elo', '1000', '2018-02-18 02:54:54', NULL),
(1084, '107', 2, 'P-kills', '0', '2018-02-18 02:54:54', NULL),
(1085, '107', 2, 'P-kit', '2', '2018-02-18 02:54:54', NULL),
(1086, '107', 2, 'P-level', '1', '2018-02-18 02:54:54', NULL),
(1087, '107', 2, 'P-ping', '18', '2018-02-18 02:54:54', '2018-02-18 02:55:54'),
(1088, '107', 2, 'P-score', '12', '2018-02-18 02:54:54', '2018-02-18 02:55:54'),
(1089, '107', 2, 'P-team', '1', '2018-02-18 02:54:54', NULL),
(1090, '107', 2, 'P-time', '1 min 10 sec ', '2018-02-18 02:54:54', '2018-02-18 02:55:54'),
(1091, '111', 3, 'P-dc', 'iad', '2018-02-18 04:20:37', NULL),
(1092, '111', 3, 'P-ip', '127.0.0.1', '2018-02-18 04:20:37', NULL),
(1093, '111', 3, 'LID', '1', '2018-02-18 04:20:37', '2018-02-18 04:26:13'),
(1094, '111', 3, 'HMO', '3', '2018-02-18 04:20:37', '2018-02-18 04:26:13'),
(1095, '111', 3, 'P-cid', '0', '2018-02-18 04:20:37', NULL),
(1096, '111', 3, 'P-kills', '0', '2018-02-18 04:21:13', NULL),
(1097, '111', 3, 'P-kit', '2', '2018-02-18 04:21:13', NULL),
(1098, '111', 3, 'P-score', '0', '2018-02-18 04:21:13', NULL),
(1099, '111', 3, 'P-team', '2', '2018-02-18 04:21:13', NULL),
(1100, '111', 3, 'P-elo', '1000', '2018-02-18 04:21:13', NULL),
(1101, '111', 3, 'P-level', '1', '2018-02-18 04:21:13', NULL),
(1102, '111', 3, 'P-ping', '14', '2018-02-18 04:21:13', '2018-02-18 04:26:13'),
(1103, '111', 3, 'P-time', '5 min 10 sec ', '2018-02-18 04:21:13', '2018-02-18 04:26:13'),
(1104, '112', 2, 'HMO', '2', '2018-02-18 07:52:52', '2018-02-18 07:54:23'),
(1105, '112', 2, 'P-cid', '0', '2018-02-18 07:52:52', NULL),
(1106, '112', 2, 'P-dc', 'iad', '2018-02-18 07:52:52', NULL),
(1107, '112', 2, 'P-ip', '127.0.0.1', '2018-02-18 07:52:52', NULL),
(1108, '112', 2, 'LID', '1', '2018-02-18 07:52:52', '2018-02-18 07:54:23'),
(1109, '112', 2, 'P-elo', '1000', '2018-02-18 07:53:23', NULL),
(1110, '112', 2, 'P-kills', '0', '2018-02-18 07:53:23', NULL),
(1111, '112', 2, 'P-kit', '2', '2018-02-18 07:53:23', NULL),
(1112, '112', 2, 'P-ping', '15', '2018-02-18 07:53:23', '2018-02-18 07:54:23'),
(1113, '112', 2, 'P-team', '1', '2018-02-18 07:53:23', NULL),
(1114, '112', 2, 'P-time', '1 min 10 sec ', '2018-02-18 07:53:23', '2018-02-18 07:54:23'),
(1115, '112', 2, 'P-level', '1', '2018-02-18 07:53:23', NULL),
(1116, '112', 2, 'P-score', '0', '2018-02-18 07:53:23', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_server_regions`
--

CREATE TABLE `game_server_regions` (
  `game_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_server_stats`
--

CREATE TABLE `game_server_stats` (
  `id` int(10) UNSIGNED NOT NULL,
  `gid` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `statsKey` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `statsValue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `game_server_stats`
--

INSERT INTO `game_server_stats` (`id`, `gid`, `statsKey`, `statsValue`, `created_at`, `updated_at`) VALUES
(8763, '112', 'B-U-map', 'no_vehicles', '2018-02-18 07:51:40', NULL),
(8764, '112', 'HTTYPE', 'A', '2018-02-18 07:51:40', NULL),
(8765, '112', 'MAX-PLAYERS', '16', '2018-02-18 07:51:40', '2018-02-18 07:54:55'),
(8766, '112', 'B-U-army_distribution', '0,0,0,0,0,0,0,0,0,0,0', '2018-02-18 07:51:40', '2018-02-18 07:55:55'),
(8767, '112', 'B-U-avg_ally_rank', '1000', '2018-02-18 07:51:40', '2018-02-18 07:51:41'),
(8768, '112', 'B-U-avg_axis_rank', '1000', '2018-02-18 07:51:40', '2018-02-18 07:51:41'),
(8769, '112', 'B-U-server_state', 'empty', '2018-02-18 07:51:40', '2018-02-18 07:55:55'),
(8770, '112', 'NAME', '[iad]Default Server Name(192.168.56.1:16567)', '2018-02-18 07:51:40', '2018-02-18 07:55:55'),
(8771, '112', 'QLEN', '16', '2018-02-18 07:51:40', NULL),
(8772, '112', 'B-maxObservers', '0', '2018-02-18 07:51:40', '2018-02-18 07:54:55'),
(8773, '112', 'B-numObservers', '0', '2018-02-18 07:51:40', '2018-02-18 07:54:55'),
(8774, '112', 'RT', '', '2018-02-18 07:51:40', NULL),
(8775, '112', 'PORT', '16567', '2018-02-18 07:51:40', NULL),
(8776, '112', 'DISABLE-AUTO-DEQUEUE', '1', '2018-02-18 07:51:40', NULL),
(8777, '112', 'B-U-elo_rank', '1000', '2018-02-18 07:51:40', '2018-02-18 07:51:41'),
(8778, '112', 'B-U-server_ip', '192.168.56.1', '2018-02-18 07:51:40', NULL),
(8779, '112', 'B-U-server_port', '16567', '2018-02-18 07:51:40', NULL),
(8780, '112', 'LID', '1', '2018-02-18 07:51:40', '2018-02-18 07:55:55'),
(8781, '112', 'RESERVE-HOST', '0', '2018-02-18 07:51:40', NULL),
(8782, '112', 'UGID', 'Test-Server', '2018-02-18 07:51:40', NULL),
(8783, '112', 'B-U-army_balance', 'Balanced', '2018-02-18 07:51:40', '2018-02-18 07:55:55'),
(8784, '112', 'INT-IP', '192.168.0.10', '2018-02-18 07:51:40', NULL),
(8785, '112', 'SECRET', '2587913', '2018-02-18 07:51:40', NULL),
(8786, '112', 'B-U-data_center', 'iad', '2018-02-18 07:51:40', NULL),
(8787, '112', 'JOIN', 'O', '2018-02-18 07:51:40', '2018-02-18 07:55:55'),
(8788, '112', 'INT-PORT', '16567', '2018-02-18 07:51:40', NULL),
(8789, '112', 'B-U-avail_slots_national', 'yes', '2018-02-18 07:51:40', NULL),
(8790, '112', 'B-U-percent_full', '0', '2018-02-18 07:51:40', '2018-02-18 07:55:55'),
(8791, '112', 'B-version', '1.46.222034.0', '2018-02-18 07:51:40', NULL),
(8792, '112', 'TYPE', 'G', '2018-02-18 07:51:40', NULL),
(8793, '112', 'B-U-alwaysQueue', '1', '2018-02-18 07:51:40', NULL),
(8794, '112', 'HXFR', '0', '2018-02-18 07:51:40', NULL),
(8795, '112', 'B-U-avail_slots_royal', 'yes', '2018-02-18 07:51:40', NULL),
(8796, '112', 'B-U-community_name', '', '2018-02-18 07:51:40', NULL),
(8797, '112', 'GID', '112', '2018-02-18 07:51:41', '2018-02-18 07:55:55'),
(8798, '112', 'B-U-avail_vips_national', '4', '2018-02-18 07:51:41', NULL),
(8799, '112', 'B-U-lvl_avg', '0.000000', '2018-02-18 07:51:41', '2018-02-18 07:55:55'),
(8800, '112', 'B-U-lvl_sdv', '0.000000', '2018-02-18 07:51:41', NULL),
(8801, '112', 'B-U-avail_vips_royal', '4', '2018-02-18 07:51:41', NULL),
(8802, '112', 'B-U-map_name', 'Village', '2018-02-18 07:51:41', NULL),
(8803, '112', 'B-U-servertype', 'public', '2018-02-18 07:51:41', NULL),
(8804, '112', 'B-U-punkb', '0', '2018-02-18 07:51:41', NULL),
(8805, '112', 'B-U-ranked', 'yes', '2018-02-18 07:51:41', NULL),
(8806, '112', 'B-U-easyzone', 'no', '2018-02-18 07:51:41', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `game_stats`
--

CREATE TABLE `game_stats` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `heroID` int(10) UNSIGNED NOT NULL,
  `statsKey` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `statsValue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `game_stats`
--

INSERT INTO `game_stats` (`id`, `user_id`, `heroID`, `statsKey`, `statsValue`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'level', '7', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(2, 2, 1, 'elo', '1000', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(3, 2, 1, 'c_team', '2', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(4, 2, 1, 'c_kit', '0', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(5, 2, 1, 'c_skc', '9', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(6, 2, 1, 'c_hrc', '4', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(7, 2, 1, 'c_hrs', '87', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(8, 2, 1, 'c_ft', '109', '2017-12-10 02:40:10', '2017-12-10 02:40:10'),
(9, 2, 2, 'level', '1', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(10, 2, 2, 'elo', '1000', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(11, 2, 2, 'c_team', '1', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(12, 2, 2, 'c_kit', '2', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(13, 2, 2, 'c_skc', '4', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(14, 2, 2, 'c_hrc', '2', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(15, 2, 2, 'c_hrs', '121', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(16, 2, 2, 'c_ft', '0', '2017-12-10 02:41:47', '2017-12-10 02:41:47'),
(17, 2, 3, 'level', '1', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(18, 2, 3, 'elo', '1000', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(19, 2, 3, 'c_team', '2', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(20, 2, 3, 'c_kit', '2', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(21, 2, 3, 'c_skc', '3', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(22, 2, 3, 'c_hrc', '3', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(23, 2, 3, 'c_hrs', '83', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(24, 2, 3, 'c_ft', '109', '2017-12-10 02:42:01', '2017-12-10 02:42:01'),
(25, 2, 4, 'level', '1', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(26, 2, 4, 'elo', '1000', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(27, 2, 4, 'c_team', '1', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(28, 2, 4, 'c_kit', '0', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(29, 2, 4, 'c_skc', '2', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(30, 2, 4, 'c_hrc', '2', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(31, 2, 4, 'c_hrs', '121', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(32, 2, 4, 'c_ft', '132', '2017-12-10 02:42:13', '2017-12-10 02:42:13'),
(33, 3, 5, 'level', '1', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(34, 3, 5, 'elo', '1000', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(35, 3, 5, 'c_team', '2', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(36, 3, 5, 'c_kit', '1', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(37, 3, 5, 'c_skc', '4', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(38, 3, 5, 'c_hrc', '2', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(39, 3, 5, 'c_hrs', '82', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(40, 3, 5, 'c_ft', '108', '2017-12-10 02:59:33', '2017-12-10 02:59:33'),
(41, 3, 5, 'c_apr', '4;935;936', NULL, NULL),
(42, 3, 5, 'c_emo', '5000;5007;5016;0;0;0;0;0;0', NULL, NULL),
(43, 3, 5, 'c_eqp', '3011;3009;2075;3156;2001;0;0;0;0;0', NULL, NULL),
(44, 3, 5, 'c_ltp', '9292.0000', NULL, NULL),
(45, 3, 5, 'c_wmid0', '0.0000', NULL, NULL),
(46, 3, 3, 'c_ltm', '9292.0000', NULL, NULL),
(47, 3, 3, 'c_slm', '0.0000', NULL, NULL),
(48, 3, 3, 'c_tut', '1.0000', NULL, NULL),
(49, 2, 1, 'c_apr', '4;5;201', NULL, NULL),
(50, 2, 1, 'c_emo', '5000;5001;5002;5003;5004;5005;5006;5007;5008', NULL, NULL),
(51, 2, 1, 'c_eqp', '0;0;0;0;2136;0;0;3001;0;0', NULL, NULL),
(52, 2, 1, 'c_ltp', '9289.0000', NULL, NULL),
(53, 2, 1, 'c_wmid0', '6000.0000', NULL, NULL),
(54, 2, 2, 'c_ltm', '9298.0000', NULL, NULL),
(55, 2, 2, 'c_slm', '0.0000', NULL, NULL),
(56, 2, 2, 'c_tut', '2.0000', NULL, NULL),
(57, 2, 3, 'c_apr', '4;36;1024;1177;1355', NULL, NULL),
(58, 2, 4, 'c_apr', '979;981', NULL, NULL),
(59, 2, 2, 'c_apr', '9;73;415', NULL, NULL),
(60, 2, 2, 'c_emo', '5000;5001;5002;5003;5077;5005;5006;5007;5008', NULL, NULL),
(61, 2, 2, 'c_eqp', '3182;3147;2026;3171;0;0;0;0;0;0', NULL, NULL),
(62, 2, 2, 'c_ltp', '9298.0000', NULL, NULL),
(63, 2, 2, 'c_wmid0', '0.0000', NULL, NULL),
(64, 2, 2, 'mid0', '6000.0000', NULL, NULL),
(65, 2, 1, 'ds', '0.0000', NULL, NULL),
(66, 2, 1, 'ks', '0.0000', NULL, NULL),
(67, 2, 1, 'm_ct0', '0.7901', NULL, NULL),
(68, 2, 1, 'fc_los0', '1.0000', NULL, NULL),
(69, 2, 1, 'ft_los2', '1.0000', NULL, NULL),
(70, 2, 1, 'los', '1.0000', NULL, NULL),
(71, 2, 1, 'm_los0', '1.0000', NULL, NULL),
(72, 2, 2, 'ct', '8.0492', NULL, NULL),
(73, 2, 2, 'ds', '0.0000', NULL, NULL),
(74, 2, 2, 'fc_los2', '2.0000', NULL, NULL),
(75, 2, 2, 'fi', '4.0000', NULL, NULL),
(76, 2, 2, 'ft_los1', '2.0000', NULL, NULL),
(77, 2, 2, 'ks', '0.0000', NULL, NULL),
(78, 2, 2, 'los', '2.0000', NULL, NULL),
(79, 2, 2, 'm_ct0', '30.6764', NULL, NULL),
(80, 2, 2, 'm_los0', '2.0000', NULL, NULL),
(81, 2, 2, 'sw3191', '4.0000', NULL, NULL),
(82, 2, 2, 'tv5', '8.0000', NULL, NULL),
(83, 2, 2, 'tw3191', '3.0000', NULL, NULL),
(84, 2, 2, 'tw3200', '4.0000', NULL, NULL),
(85, 2, 4, 'c_emo', '5000;5007;5016;0;0;0;0;0;0', NULL, NULL),
(86, 2, 4, 'c_eqp', '3153;3137;0;2141;0;0;0;0;0;0', NULL, NULL),
(87, 2, 4, 'c_ltp', '9297.0000', NULL, NULL),
(88, 2, 4, 'c_wmid0', '0.0000', NULL, NULL),
(89, 2, 4, 'mid0', '6000.0000', NULL, NULL),
(90, 2, 3, 'c_emo', '5000;5007;5016;0;5078;0;0;0;0', NULL, NULL),
(91, 2, 3, 'c_eqp', '3197;3161;3160;2026;0;0;0;0;0;0', NULL, NULL),
(92, 2, 3, 'c_ltp', '9298.0000', NULL, NULL),
(93, 2, 3, 'c_wmid0', '0.0000', NULL, NULL),
(94, 2, 3, 'ds', '0.0000', NULL, NULL),
(95, 2, 3, 'ks', '0.0000', NULL, NULL),
(96, 2, 3, 'mid0', '6000.0000', NULL, NULL),
(97, 2, 1, 'c_slm', '25284892.0000', NULL, NULL),
(98, 0, 2, 'c_slm', '6.0000', NULL, NULL),
(99, 0, 1, 'c_ltp', '9277.0000', NULL, NULL),
(100, 5, 6, 'level', '1', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(101, 5, 6, 'elo', '1000', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(102, 5, 6, 'c_team', '2', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(103, 5, 6, 'c_kit', '0', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(104, 5, 6, 'c_skc', '6', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(105, 5, 6, 'c_hrc', '5', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(106, 5, 6, 'c_hrs', '86', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(107, 5, 6, 'c_ft', '103', '2018-01-30 03:36:43', '2018-01-30 03:36:43'),
(108, 2, 4, 'ds', '0.0000', NULL, NULL),
(109, 2, 4, 'ks', '0.0000', NULL, NULL),
(110, 2, 4, 'm_ct0', '11.4642', NULL, NULL),
(111, 2, 3, 'm_ct0', '19.6652', NULL, NULL),
(112, 0, 2, 'c_ltm', '9283.0000', NULL, NULL),
(113, 3, 5, 'mid0', '-6000', NULL, NULL),
(114, 2, 2, 'c_wmid1', '0.0000', NULL, NULL),
(115, 2, 2, 'mid1', '6041.0000', NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2017_06_30_231158_create_forums_table', 1),
(4, '2017_06_30_231224_create_topics_table', 1),
(5, '2017_06_30_231302_create_comments_table', 1),
(6, '2017_07_01_114721_create_user_signatures_table', 1),
(7, '2017_07_03_090226_create_authentication_tokens_table', 1),
(8, '2017_07_04_003106_create_downloads_table', 1),
(9, '2017_07_08_212121_create_user_friends_table', 1),
(10, '2017_07_08_214941_create_friend_requests_table', 1),
(11, '2017_07_11_221348_create_roles_table', 1),
(12, '2017_07_11_221359_create_permissions_table', 1),
(13, '2017_07_11_221409_create_permission_role_table', 1),
(14, '2017_07_11_221425_create_role_user_table', 1),
(15, '2017_07_14_145823_create_news_table', 1),
(16, '2017_07_18_000000_update_users_table', 1),
(17, '2017_07_18_161536_create_jobs_table', 1),
(18, '2017_07_18_161634_create_failed_jobs_table', 1),
(19, '2017_07_20_003702_create_user_discord_table', 1),
(20, '2017_07_21_000000_update_comments_table', 1),
(21, '2017_07_21_000000_update_topics_table', 1),
(22, '2017_07_21_220901_create_audits_table', 1),
(23, '2017_07_22_172358_update_user_table', 1),
(24, '2017_07_22_174548_update_user_table_for_game', 1),
(25, '2017_07_22_181120_create_game_server_table', 1),
(26, '2017_07_22_190026_create_game_heroes_table', 1),
(27, '2017_07_22_194145_create_game_stats_table', 1),
(28, '2017_07_28_042224_create_user_revive_table', 1),
(29, '2017_07_28_061915_update_user_discords_table', 1),
(30, '2017_07_29_202605_create_game_server_stats', 1),
(31, '2017_07_29_224036_create_game_server_player_stats', 1),
(32, '2017_07_31_010137_update_game_server_player_stats', 2),
(33, '2017_08_01_030034_create_games', 2),
(34, '2017_08_02_062636_create_game_server_regions', 2),
(35, '2017_08_03_052656_update_game_server_regions', 2),
(36, '2017_08_04_022239_create_game_player_regions', 2),
(37, '2017_08_09_160449_create_game_player_server_preferences', 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `news`
--

CREATE TABLE `news` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `password_resets`
--

INSERT INTO `password_resets` (`email`, `token`, `created_at`) VALUES
('thecaiotor@gmail.com', '$2y$10$STTxd6g2mVuqVxLXOyHGQOj97pF7w7LT.9/F.lP3qgd37AKL6PnJy', '2017-12-10 02:56:49');

-- --------------------------------------------------------

--
-- Estrutura da tabela `permissions`
--

CREATE TABLE `permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `permissions`
--

INSERT INTO `permissions` (`id`, `slug`, `description`) VALUES
(1, 'user.update', 'Update information about other users'),
(2, 'user.add', 'Create new users'),
(3, 'user.delete', 'Delete a specified user'),
(4, 'user.roles', 'Ability to create and assign roles to people.'),
(5, 'user.ban', 'Ban or give penalties to a specified user'),
(6, 'forum.topic', 'Ability to create new topics.'),
(7, 'forum.post', 'Ability to create posts.'),
(8, 'forum.comment', 'Ability to comment on posts.'),
(9, 'forum.delete', 'Ability to delete forum related stuff.'),
(10, 'forum.manage', 'Ability to manage forum related stuff.'),
(11, 'news.manage', 'Access to news admin panel.'),
(12, 'news.add', 'Ability to add new news.'),
(13, 'audit.manage', 'Access to audit panel.'),
(14, 'game.matchmake', 'Ability to use matchmaking ingame.'),
(15, 'game.login', 'Ability to log into the game.'),
(16, 'game.createHero', 'Ability to create a hero for the game.');

-- --------------------------------------------------------

--
-- Estrutura da tabela `permission_role`
--

CREATE TABLE `permission_role` (
  `permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `permission_role`
--

INSERT INTO `permission_role` (`permission_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `roles`
--

INSERT INTO `roles` (`id`, `title`, `slug`) VALUES
(1, 'Normal User', 'normalUser'),
(2, 'Administrator', 'administrator'),
(3, 'Staff', 'staff'),
(4, 'Moderator', 'moderator'),
(5, 'Awoken Lead', 'awokenlead'),
(6, 'Awoken Dev', 'awokendev');

-- --------------------------------------------------------

--
-- Estrutura da tabela `role_user`
--

CREATE TABLE `role_user` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `expire_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `role_user`
--

INSERT INTO `role_user` (`user_id`, `role_id`, `expire_at`) VALUES
(2, 1, NULL),
(3, 1, NULL),
(5, 1, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `topics`
--

CREATE TABLE `topics` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `forum_id` int(10) UNSIGNED NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_comment` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birthday` date NOT NULL,
  `language` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'enUS',
  `country` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `notifications` mediumtext COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `game_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `birthday`, `language`, `country`, `password`, `remember_token`, `created_at`, `updated_at`, `notifications`, `ip_address`, `game_token`) VALUES
(1, 'game-server', 'game-server@gmail.com', '2017-12-06', 'enUS', 'Brazil', 'game-server', NULL, NULL, NULL, NULL, NULL, 'game-server'),
(2, 'lok', 'thecaiotor@gmail.com', '1996-07-31', 'enUS', '', 'Kiop09!qas', NULL, '2017-12-10 02:37:43', '2017-12-10 02:37:43', NULL, NULL, '1234'),
(3, 'Kiop', 'lypolise@gmail.com', '1997-07-31', 'enUS', '', '$2y$10$yqc94mokmEtovgK1oXjoOeAN2/14iacs9BKDu.qokd8NWN4GoeGM2', NULL, '2017-12-10 02:59:21', '2017-12-10 02:59:21', NULL, NULL, '123'),
(4, 'syn', 'syn@gmail.com', '2018-01-27', 'fr', 'FR', '$2y$10$ba9AYKTutmdxQgxVRbX5iOPkogUJTpaspu93COBZG.PiCtOULMfYy', NULL, '2018-01-27 07:19:31', '2018-01-27 07:19:31', NULL, NULL, 'iRzD8EvSJF9fboG'),
(5, 'caio', 'thecaiotor32@gmail.com', '1997-07-31', 'enUS', '', '$2y$10$M9RiC3XlhebivlXRPXeccupEZ2aajmfS4UMwiPICLeNkhsCYdI5Qe', NULL, '2018-01-30 03:11:10', '2018-01-30 04:52:54', '{\"news\":false}', '127.0.0.1', '6CUMvXUu6HNBajzR3wEtLwzfF4EgIrCJ');

-- --------------------------------------------------------

--
-- Estrutura da tabela `user_discords`
--

CREATE TABLE `user_discords` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `discord_id` bigint(20) UNSIGNED NOT NULL,
  `discord_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discord_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discord_discriminator` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `user_friends`
--

CREATE TABLE `user_friends` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `friend_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `user_revive`
--

CREATE TABLE `user_revive` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `revive_id` int(10) UNSIGNED NOT NULL,
  `revive_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revive_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revive_role` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `user_signatures`
--

CREATE TABLE `user_signatures` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `user_signatures`
--

INSERT INTO `user_signatures` (`id`, `user_id`, `image`, `created_at`, `updated_at`) VALUES
(1, 5, '/images/signatures/PBR1iVHjCSbiDEzvnFXJshOErarNq9bJ2SDXLLmm4n7yedtE.jpg', '2018-01-30 04:56:23', '2018-01-30 04:56:23');

-- Индексы таблицы `audits`
--
ALTER TABLE `audits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audits_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `authentication_tokens`
--
ALTER TABLE `authentication_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `authentication_tokens_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_user_id_foreign` (`user_id`),
  ADD KEY `comments_topic_id_foreign` (`topic_id`);

--
-- Индексы таблицы `downloads`
--
ALTER TABLE `downloads`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `forums`
--
ALTER TABLE `forums`
  ADD PRIMARY KEY (`id`),
  ADD KEY `forums_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `friend_requests_sender_foreign` (`sender`),
  ADD KEY `friend_requests_receiver_foreign` (`receiver`);

--
-- Индексы таблицы `game_heroes`
--
ALTER TABLE `game_heroes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_heroes_heroname_unique` (`heroName`),
  ADD KEY `game_heroes_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `game_player_regions`
--
ALTER TABLE `game_player_regions`
  ADD PRIMARY KEY (`userid`);

--
-- Индексы таблицы `game_player_server_preferences`
--
ALTER TABLE `game_player_server_preferences`
  ADD PRIMARY KEY (`userid`,`gid`);

--
-- Индексы таблицы `game_server_player_stats`
--
ALTER TABLE `game_server_player_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_server_player_stats_gid_pid_statskey_unique` (`gid`,`pid`,`statsKey`),
  ADD KEY `game_server_player_stats_pid_foreign` (`pid`);

--
-- Индексы таблицы `game_server_regions`
--
ALTER TABLE `game_server_regions`
  ADD PRIMARY KEY (`game_ip`);

--
-- Индексы таблицы `game_server_stats`
--
ALTER TABLE `game_server_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_server_stats_gid_statskey_unique` (`gid`,`statsKey`);

--
-- Индексы таблицы `game_servers`
--
ALTER TABLE `game_servers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_servers_servername_unique` (`servername`),
  ADD UNIQUE KEY `game_servers_secretkey_unique` (`secretKey`),
  ADD KEY `game_servers_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `game_stats`
--
ALTER TABLE `game_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_stats_user_id_heroid_statskey_unique` (`user_id`,`heroID`,`statsKey`);

--
-- Индексы таблицы `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`gid`);

--
-- Индексы таблицы `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_reserved_at_index` (`queue`,`reserved_at`);

--
-- Индексы таблицы `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD KEY `news_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Индексы таблицы `permission_role`
--
ALTER TABLE `permission_role`
  ADD KEY `permission_role_permission_id_foreign` (`permission_id`),
  ADD KEY `permission_role_role_id_foreign` (`role_id`);

--
-- Индексы таблицы `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `role_user`
--
ALTER TABLE `role_user`
  ADD KEY `role_user_user_id_foreign` (`user_id`),
  ADD KEY `role_user_role_id_foreign` (`role_id`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `topics_user_id_foreign` (`user_id`),
  ADD KEY `topics_forum_id_foreign` (`forum_id`);

--
-- Индексы таблицы `user_discords`
--
ALTER TABLE `user_discords`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_discords_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `user_friends`
--
ALTER TABLE `user_friends`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_friends_user_id_foreign` (`user_id`),
  ADD KEY `user_friends_friend_id_foreign` (`friend_id`);

--
-- Индексы таблицы `user_revive`
--
ALTER TABLE `user_revive`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_revive_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `user_signatures`
--
ALTER TABLE `user_signatures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_signatures_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_game_token_unique` (`game_token`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `audits`
--
ALTER TABLE `audits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
--
-- AUTO_INCREMENT для таблицы `authentication_tokens`
--
ALTER TABLE `authentication_tokens`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `downloads`
--
ALTER TABLE `downloads`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1093;
--
-- AUTO_INCREMENT для таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `forums`
--
ALTER TABLE `forums`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `friend_requests`
--
ALTER TABLE `friend_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `game_heroes`
--
ALTER TABLE `game_heroes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1627;
--
-- AUTO_INCREMENT для таблицы `game_server_player_stats`
--
ALTER TABLE `game_server_player_stats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165824;
--
-- AUTO_INCREMENT для таблицы `game_server_stats`
--
ALTER TABLE `game_server_stats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32804;
--
-- AUTO_INCREMENT для таблицы `game_servers`
--
ALTER TABLE `game_servers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT для таблицы `game_stats`
--
ALTER TABLE `game_stats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=321608;
--
-- AUTO_INCREMENT для таблицы `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;
--
-- AUTO_INCREMENT для таблицы `news`
--
ALTER TABLE `news`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT для таблицы `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT для таблицы `topics`
--
ALTER TABLE `topics`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `user_discords`
--
ALTER TABLE `user_discords`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `user_friends`
--
ALTER TABLE `user_friends`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `user_revive`
--
ALTER TABLE `user_revive`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `user_signatures`
--
ALTER TABLE `user_signatures`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=924;
--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `audits`
--
ALTER TABLE `audits`
  ADD CONSTRAINT `audits_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `authentication_tokens`
--
ALTER TABLE `authentication_tokens`
  ADD CONSTRAINT `authentication_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_topic_id_foreign` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`),
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `forums`
--
ALTER TABLE `forums`
  ADD CONSTRAINT `forums_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD CONSTRAINT `friend_requests_receiver_foreign` FOREIGN KEY (`receiver`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `friend_requests_sender_foreign` FOREIGN KEY (`sender`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `game_heroes`
--
ALTER TABLE `game_heroes`
  ADD CONSTRAINT `game_heroes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `game_server_player_stats`
--
ALTER TABLE `game_server_player_stats`
  ADD CONSTRAINT `game_server_player_stats_gid_foreign` FOREIGN KEY (`gid`) REFERENCES `game_server_stats` (`gid`) ON DELETE CASCADE,
  ADD CONSTRAINT `game_server_player_stats_pid_foreign` FOREIGN KEY (`pid`) REFERENCES `game_heroes` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `game_servers`
--
ALTER TABLE `game_servers`
  ADD CONSTRAINT `game_servers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `game_stats`
--
ALTER TABLE `game_stats`
  ADD CONSTRAINT `game_stats_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Ограничения внешнего ключа таблицы `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `topics`
--
ALTER TABLE `topics`
  ADD CONSTRAINT `topics_forum_id_foreign` FOREIGN KEY (`forum_id`) REFERENCES `forums` (`id`),
  ADD CONSTRAINT `topics_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `user_discords`
--
ALTER TABLE `user_discords`
  ADD CONSTRAINT `user_discords_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `user_friends`
--
ALTER TABLE `user_friends`
  ADD CONSTRAINT `user_friends_friend_id_foreign` FOREIGN KEY (`friend_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_friends_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `user_signatures`
--
ALTER TABLE `user_signatures`
  ADD CONSTRAINT `user_signatures_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
