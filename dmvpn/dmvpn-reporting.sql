SELECT DISTINCT Nodes.Caption, NodeIP.IPAddress, InterfacesCustom.WAN_Interface_Type, Interfaces.Name, Interfaces.Speed AS Mbit, Nodes.Location, Routing.RouteDestination, Routing.RouteMaskLen, Nodes.MachineType, Nodes.IOSVersion
FROM Orion.Routing.RoutingTable AS Routing
FULL JOIN Orion.NodeIPAddresses AS NodeIP ON Routing.RouteNextHop = NodeIP.IPAddress
LEFT JOIN Orion.Nodes AS Nodes ON NodeIP.NodeID = Nodes.NodeID
LEFT JOIN Orion.NPM.Interfaces AS Interfaces ON NodeIP.NodeID = Interfaces.NodeID AND NodeIP.InterfaceIndex = Interfaces.Index
INNER JOIN Orion.NPM.InterfacesCustomProperties AS InterfacesCustom ON Interfaces.InterfaceID = InterfacesCustom.InterfaceID
WHERE Nodes.Caption NOT LIKE 'p%'
AND (InterfacesCustom.WAN_Interface_Type = 'WAN-Local ISP Interface' OR InterfacesCustom.WAN_Interface_Type = 'WAN-DMVPN Tunnel Interface')