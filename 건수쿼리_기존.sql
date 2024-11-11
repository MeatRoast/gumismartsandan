select b.base, a.current from 
    (
  select 1 as cc, ifnull(count(*),0) as current
  from tb_alarm_result_agg
  where from_unixtime(occurTime/1000) > date_add(now(),interval -7 day)
  and alarmDefinitionId in (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531, 1551,1553,1549, 1552, 1550, 1584,1583,1582,1581,1580,1554)
    ) a,
    (
  select 1 as cc, ifnull(count(*),0) as base
  from tb_alarm_result_agg
  where from_unixtime(occurTime/1000) > date_add(from_unixtime(occurTime/1000), interval -14 day) 
  and from_unixtime(occurTime/1000) <= date_add(now(),interval -7 day)
  and alarmDefinitionId in (1541,1540,1539,1538,1537,1536,1535,1534,1533,1532,1531, 1551,1553,1549, 1552, 1550, 1584,1583,1582,1581,1580,1554)
    ) b 
where a.cc = b.cc
