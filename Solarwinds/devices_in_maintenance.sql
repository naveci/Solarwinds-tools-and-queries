SELECT n.caption AS [Device], n.DetailsURL AS [_LinkFor_Device]
,'/Orion/images/StatusIcons/Small-' + StatusIcon AS [_IconFor_Device]
, ae.accountid AS [By]
, Alerts.SuppressFrom AS [Mute from], Alerts.SuppressUntil AS [Mute Until]


FROM Orion.AlertSuppression AlertS
JOIN Orion.nodes n ON n.uri = AlertS.EntityURI
LEFT OUTER JOIN Orion.AuditingEvents AS ae
   ON ae.uri = alerts.uri 
