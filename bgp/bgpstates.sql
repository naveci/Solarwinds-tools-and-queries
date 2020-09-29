--- BGP changes in the last 72 hours

SELECT Nodes.Caption AS [Device], Nodes.DetailsURL AS [_LinkFor_Device]
        ,'/Orion/images/StatusIcons/Small-' + StatusIcon AS [_IconFor_Device]
        , Nodes.IP_Address as [IP], Nodes.DetailsURL as [_LinkFor_IP]
        , RN.ProtocolName AS Protocol
        , (SELECT TOP 1 InterfaceIndex FROM Orion.Routing.RoutingTable AS rt WHERE rt.NodeID = RN.NodeID AND rt.RouteNextHop = RN.NeighborIP) AS InterfaceDescription
        , RN.NeighborIP, RN.Ip_Address_Type AS IPversion, RN.IsDeleted
        , CONCAT(HOURDIFF(tolocal(RN.LastChange),getdate())/24,' Day(s) ',
                HOURDIFF(tolocal(RN.LastChange),getdate())-(HOURDIFF(tolocal(RN.LastChange),getdate())/24)*24,'h ',
                MINUTEDIFF(tolocal(RN.LastChange),getdate())-(MINUTEDIFF(tolocal(RN.LastChange),getdate())/60)*60,'m') AS Uptime
        , RN.AutonomousSystem AS BGP_AS, RN.ProtocolStatusDescription AS Status
FROM Orion.Routing.Neighbors AS RN
LEFT JOIN Orion.Nodes AS Nodes ON RN.NodeID = Nodes.NodeID
WHERE ProtocolName LIKE '%BGP%'
AND HOURDIFF(tolocal(RN.LastChange),getdate()) < 72
ORDER BY RN.LastChange DESC
