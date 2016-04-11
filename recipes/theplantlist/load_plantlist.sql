CREATE TABLE IF NOT EXISTS `plantlist` (
  `kewid` varchar(20) NOT NULL,
  `hgroup` varchar(1) NOT NULL,
  `family` varchar(100) NOT NULL,
  `genhyb` varchar(1) DEFAULT NULL,
  `genus` varchar(100) DEFAULT NULL,
  `sphyb` varchar(1) DEFAULT NULL,
  `species` varchar(100) DEFAULT NULL,
  `ssptype` varchar(5) DEFAULT NULL,
  `ssp` varchar(100) DEFAULT NULL,
  `author` varchar(200) DEFAULT NULL,
  `status` enum('Accepted','Synonym','Unresolved') DEFAULT NULL,
  `synOf` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE `plantlist` ADD PRIMARY KEY (`kewid`), ADD KEY `family` (`family`), ADD KEY `genus` (`genus`), ADD KEY `species` (`species`), ADD KEY `ssp` (`ssp`);

LOAD DATA LOCAL INFILE 'tpl.csv' INTO TABLE `plantlist` FIELDS TERMINATED BY '|';
