SELECT Nodes.Caption AS [Device], Nodes.DetailsURL AS [_LinkFor_Device]
        ,'/Orion/images/StatusIcons/Small-' + StatusIcon AS [_IconFor_Device]
        , Nodes.IP_Address as [IP], Nodes.DetailsURL as [_LinkFor_IP]
        , ssm.MacAddress
        , ssm.Role
        , ssm.SwitchNumber
        , ssm.SwPriority
        , Nodes.MachineType
        , ssm.SerialNumber
        , Cpu.AvgLoad AS CPU
        , CONCAT(HOURDIFF(tolocal(Nodes.LastBoot),getdate())/24,' Day(s) ',
        HOURDIFF(tolocal(Nodes.LastBoot),getdate())-(HOURDIFF(tolocal(Nodes.LastBoot),getdate())/24)*24,'h ',
        MINUTEDIFF(tolocal(Nodes.LastBoot),getdate())-(MINUTEDIFF(tolocal(Nodes.LastBoot),getdate())/60)*60,'m') AS Uptime

FROM Orion.CPUMultiLoadCurrent AS cpu
INNER JOIN Orion.Nodes AS Nodes ON cpu.NodeID = Nodes.NodeID
INNER JOIN Orion.NPM.SwitchStackMember AS ssm ON ssm.NodeID = cpu.NodeID  AND  ssm.MemberID = cpu.CPUIndex

WHERE Cpu.AvgLoad >= 80

ORDER BY Cpu.AvgLoad DESC
