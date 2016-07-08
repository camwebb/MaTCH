CREATE TABLE IF NOT EXISTS `fmsyns` (
  `id` int(11) NOT NULL,
  `genus` varchar(100) DEFAULT NULL,
  `species` varchar(100) DEFAULT NULL,
  `ssptype` varchar(5) DEFAULT NULL,
  `ssp` varchar(100) DEFAULT NULL,
  `author` varchar(200) DEFAULT NULL,
  `reference` varchar(300) DEFAULT NULL,
  `status` enum('A','S') DEFAULT NULL,
  `synOf` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE `fmsyns` ADD PRIMARY KEY (`id`), ADD KEY `genus` (`genus`), ADD KEY `species` (`species`), ADD KEY `ssp` (`ssp`);

LOAD DATA LOCAL INFILE 'fm_syns.csv' INTO TABLE `fmsyns` FIELDS TERMINATED BY '|';
