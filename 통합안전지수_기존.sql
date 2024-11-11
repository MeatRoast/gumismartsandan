select (유해물질 + 자연재해 + 화재발생 + 범죄사고) * 100 통합안전지수
from 
(
select 
case when ifnull((a.유해물질-b.유해물질)/b.유해물질*100,1) > 0 then ifnull((a.유해물질-b.유해물질)/b.유해물질*100,1) else 1 end * 0.4 as 유해물질,
case when ifnull((a.자연재해-b.자연재해)/b.자연재해*100,1) > 0 then ifnull((a.자연재해-b.자연재해)/b.자연재해*100,1) else 1 end * 0.1 as 자연재해,
case when ifnull((a.화재발생-b.화재발생)/b.화재발생*100,1) > 0 then ifnull((a.화재발생-b.화재발생)/b.화재발생*100,1) else 1 end * 0.4 as 화재발생,
case when ifnull((a.범죄사고-b.범죄사고)/b.범죄사고*100,1) > 0 then ifnull((a.범죄사고-b.범죄사고)/b.범죄사고*100,1) else 1 end * 0.1 as 범죄사고
 from 
    (
  select 1 as cc, 
  sum(case when alarmDefinitionId in (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531) then 1 else 0 end) as 유해물질,
  sum(case when alarmDefinitionId in (1551,1553,1549) then 1 else 0 end) as 자연재해,
  sum(case when alarmDefinitionId in (1552, 1550) then 1 else 0 end) as 화재발생,
  sum(case when alarmDefinitionId in (1584,1583,1582,1581,1580,1554) then 1 else 0 end) as 범죄사고,
  count(*) as 전체
  from tb_alarm_result_agg
  where from_unixtime(occurTime/1000) > date_add(now(),interval -7 day)
  -- and alarmDefinitionId in (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531, 1551,1553,1549, 1552, 1550, 1584,1583,1582,1581,1580,1554)
    ) a,
    (
  select 1 as cc, 
  sum(case when alarmDefinitionId in (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531) then 1 else 0 end) as 유해물질,
  sum(case when alarmDefinitionId in (1551,1553,1549) then 1 else 0 end) as 자연재해,
  sum(case when alarmDefinitionId in (1552, 1550) then 1 else 0 end) as 화재발생,
  sum(case when alarmDefinitionId in (1584,1583,1582,1581,1580,1554) then 1 else 0 end) as 범죄사고,
  count(*) as 전체
  from tb_alarm_result_agg
  where from_unixtime(occurTime/1000) > date_add(from_unixtime(occurTime/1000), interval -14 day) 
  and from_unixtime(occurTime/1000) <= date_add(now(),interval -7 day)
  -- and alarmDefinitionId in (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531, 1551,1553,1549, 1552, 1550, 1584,1583,1582,1581,1580,1554)
    ) b 
where a.cc = b.cc
) a
