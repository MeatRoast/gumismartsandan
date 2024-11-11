SELECT b.base, a.current 
FROM 
    (
        SELECT 1 AS cc, IFNULL(COUNT(*), 0) AS current
        FROM tb_alarm_result_agg
        WHERE from_unixtime(occurTime/1000) > DATE_ADD(NOW(), INTERVAL -7 DAY)
        AND alarmDefinitionId IN (1541, 1540, 1539, 1538, 1537, 1536, 1535, 1534, 1533, 1532, 1531, 1551, 1553, 1549, 1552, 1550, 1584, 1583, 1582, 1581, 1580, 1554)
    ) a,
    (
        SELECT 1 AS cc, IFNULL(COUNT(*), 0) AS base
        FROM tb_alarm_result_agg
        WHERE from_unixtime(occurTime/1000) > DATE_ADD(NOW(), INTERVAL -14 DAY)
        AND from_unixtime(occurTime/1000) <= DATE_ADD(NOW(), INTERVAL -7 DAY)
        AND alarmDefinitionId IN (1541, 1540, 1539, 1538, 1537, 1536, 1535, 1534, 1533, 1532, 1531, 1551, 1553, 1549, 1552, 1550, 1584, 1583, 1582, 1581, 1580, 1554)
    ) b 
WHERE a.cc = b.cc;
