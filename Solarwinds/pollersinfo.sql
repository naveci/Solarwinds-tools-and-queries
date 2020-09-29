SELECT        --CASE
              --   WHEN [N].Caption IS NULL THEN [E].ServerName
              --   ELSE CONCAT('<a href="', [N].DetailsUrl, '">', [N].[Caption], '</a>')
              --  END AS [Caption]
              [N].Caption
              , [E].ServerType
              , [N].DetailsUrl AS [_LinkFor_Caption]
              , CONCAT('/NetPerfMon/images/Small-', [N].StatusLED) AS [_IconFor_Caption]
              , ROUND([N].SystemUpTime / 60 / 60 / 24, 2 ) AS [Uptime (Days)]
              , MinuteDiff([E].KeepAlive, GETUTCDATE()) AS [Last Checkin (Minutes)]
              , [E].Elements AS [Monitored Elements]
              , [E].Nodes AS [Monitored Nodes]
              , [E].Interfaces AS [Monitored Interfaces]
              , [E].Volumes AS [Monitored Volumes]
              , [E].Pollers AS [Monitored UnDP]
              -- Comment out the following line if you don't own SAM
              , [SAM].ComponentCount AS [Monitored Components]
              , [E].EngineVersion
              , CONCAT([E].WindowsVersion, '/', [E].ServicePack ) AS [OS/SP]
              , [N].CPULoad AS [CPU %]
              , [N].PercentMemoryUsed AS [Mem %]
              , [E].PollingCompletion AS [Polling Completion %]
              , [EP].PropertyValue AS [Total Job Weight]

FROM Orion.Engines AS [E]
INNER JOIN Orion.EngineProperties AS [EP]
  ON [E].EngineID = [EP].EngineID
 AND [EP].PropertyName = 'Total Job Weight'
-- Use of LEFT JOIN so that we can show Engines even if we aren't monitoring them... but we should be monitoring them
LEFT JOIN Orion.Nodes AS [N]
  ON [E].IP = [N].IP_Address
-- Comment out the follow block if you don't own SAM
-- [BEGIN] SAM Information...
INNER JOIN ( SELECT COUNT([AA].ComponentID) AS ComponentCount
                  , [N].EngineID
FROM Orion.APM.Component AS [AA]
INNER JOIN Orion.APM.Application AS [A]
   ON [AA].ApplicationID = [A].ApplicationID
INNER JOIN Orion.Nodes AS [N]
   ON [A].NodeID = [N].NodeID
WHERE [AA].Disabled = 'False'
GROUP BY [N].EngineID ) AS [SAM]
   ON [SAM].EngineID = [E].EngineID
-- [END] SAM Information
ORDER BY [E].ServerType DESC, [N].Caption 
