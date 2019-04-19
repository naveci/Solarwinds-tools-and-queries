--- This query is designed for usage in a widget.
--- It uses a custom property for device identification under ncp.DeviceCategory = 'network'
--- Please adjust the query according to your environment


SELECT Nodes.Caption AS [Device], Nodes.DetailsURL AS [_LinkFor_Device]
,'/Orion/images/StatusIcons/Small-' + StatusIcon AS [_IconFor_Device]
, Nodes.IP_Address as [IP], Nodes.DetailsURL as [_LinkFor_IP]
, NCMCisco.WhyReload AS ReloadReason, tostring(tolocal(Nodes.LastBoot)) as LastBoot,
CONCAT(HOURDIFF(tolocal(Nodes.LastBoot),getdate())/24,' Day(s) ',
        HOURDIFF(tolocal(Nodes.LastBoot),getdate())-(HOURDIFF(tolocal(Nodes.LastBoot),getdate())/24)*24,'h ',
        MINUTEDIFF(tolocal(Nodes.LastBoot),getdate())-(MINUTEDIFF(tolocal(Nodes.LastBoot),getdate())/60)*60,'m') AS Uptime

FROM Orion.Nodes AS Nodes
LEFT JOIN NCM.Nodes AS NCMNodes ON Nodes.Caption = NCMNodes.NodeCaption AND Nodes.IPAddress = NCMNodes.AgentIP
LEFT JOIN NCM.CiscoChassis AS NCMCisco ON NCMNodes.NodeID = NCMCisco.NodeID

WHERE HOURDIFF(tolocal(Nodes.LastBoot),getdate()) < 72
AND Nodes.LastBoot IS NOT NULL
AND Nodes.NodeID IN (SELECT ncp.NodeID FROM Orion.NodesCustomProperties AS ncp WHERE ncp.DeviceCategory = 'Network')
AND Nodes.Caption NOT LIKE 'fw-%'

ORDER BY MINUTEDIFF(tolocal(Nodes.LastBoot),getdate())  ASC
