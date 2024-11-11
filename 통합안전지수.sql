
SELECT 
    100 - (유해물질 + 자연재해 + 화재발생 + 범죄사고) AS 통합안전지수
FROM 
(
    SELECT 
        COALESCE(GREATEST(0, (최근.유해물질 - 이전.유해물질) / NULLIF(이전.유해물질, 0) * 100), 0) * 0.4 AS 유해물질,
        COALESCE(GREATEST(0, (최근.자연재해 - 이전.자연재해) / NULLIF(이전.자연재해, 0) * 100), 0) * 0.1 AS 자연재해,
        COALESCE(GREATEST(0, (최근.화재발생 - 이전.화재발생) / NULLIF(이전.화재발생, 0) * 100), 0) * 0.4 AS 화재발생,
        COALESCE(GREATEST(0, (최근.범죄사고 - 이전.범죄사고) / NULLIF(이전.범죄사고, 0) * 100), 0) * 0.1 AS 범죄사고
    FROM 
        (
            SELECT 
                SUM(CASE WHEN alarmDefinitionId IN (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531) THEN 1 ELSE 0 END) AS 유해물질,
                SUM(CASE WHEN alarmDefinitionId IN (1551,1553,1549) THEN 1 ELSE 0 END) AS 자연재해,
                SUM(CASE WHEN alarmDefinitionId IN (1552, 1550) THEN 1 ELSE 0 END) AS 화재발생,
                SUM(CASE WHEN alarmDefinitionId IN (1584,1583,1582,1581,1580,1554) THEN 1 ELSE 0 END) AS 범죄사고
            FROM tb_alarm_result_agg
            WHERE from_unixtime(occurTime/1000) > DATE_ADD(NOW(), INTERVAL -7 DAY)
        ) 최근,
        
        (
            SELECT 
                SUM(CASE WHEN alarmDefinitionId IN (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531) THEN 1 ELSE 0 END) AS 유해물질,
                SUM(CASE WHEN alarmDefinitionId IN (1551,1553,1549) THEN 1 ELSE 0 END) AS 자연재해,
                SUM(CASE WHEN alarmDefinitionId IN (1552, 1550) THEN 1 ELSE 0 END) AS 화재발생,
                SUM(CASE WHEN alarmDefinitionId IN (1584,1583,1582,1581,1580,1554) THEN 1 ELSE 0 END) AS 범죄사고
            FROM tb_alarm_result_agg
            WHERE from_unixtime(occurTime/1000) > DATE_ADD(NOW(), INTERVAL -14 DAY) 
            AND from_unixtime(occurTime/1000) <= DATE_ADD(NOW(), INTERVAL -7 DAY)
        ) 이전
) AS 안전지수;
