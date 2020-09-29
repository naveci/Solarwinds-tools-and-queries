SELECT Nodes.NodeID, Nodes.DisplayName, Nodes.IPAddress, Nodes.MachineType, ROUND(AvgPercentMemoryUsed,0) AS Mem, (DAYDIFF(Nodes.LastBoot, Nodes.NextPoll) ) AS DaysUptime
FROM Orion.MemoryMultiLoadCurrent AS mem
INNER JOIN Orion.Nodes AS Nodes ON mem.NodeID = Nodes.NodeID
LEFT JOIN Orion.NPM.SwitchStackMember AS ssm ON ssm.NodeID = mem.NodeID  AND  ssm.MemberID = mem.Index
WHERE AvgPercentMemoryUsed > 80
AND MachineType NOT LIKE '%UCS%'
ORDER BY AvgPercentMemoryUsed DESC, DisplayName
