SELECT  NodeID, MemberID, Role, MacAddress, COUNT(*) FROM [dbo].[NPM_SwitchStackMember]
GROUP BY NodeID, MemberID, Role, MacAddress
HAVING COUNT(*)>1
