local var0 = class("TeamType")

var0.Vanguard = "vanguard"
var0.Main = "main"
var0.Submarine = "submarine"
var0.Support = "support"
var0.TeamTypeIndex = {
	var0.Vanguard,
	var0.Main,
	var0.Submarine
}
var0.VanguardShipType = {
	ShipType.QuZhu,
	ShipType.QingXun,
	ShipType.ZhongXun,
	ShipType.HangXun,
	ShipType.LeiXun,
	ShipType.ChaoXun,
	ShipType.Yunshu,
	ShipType.DaoQuV,
	ShipType.FengFanV
}
var0.MainShipType = {
	ShipType.ZhanXun,
	ShipType.ZhanLie,
	ShipType.QingHang,
	ShipType.ZhengHang,
	ShipType.HangZhan,
	ShipType.WeiXiu,
	ShipType.ZhongPao,
	ShipType.DaoQuM,
	ShipType.FengFanM
}
var0.SubShipType = {
	ShipType.QianTing,
	ShipType.QianMu,
	ShipType.FengFanS
}
var0.VanguardMax = 3
var0.MainMax = 3
var0.SubmarineMax = 3

function var0.GetTeamShipMax(arg0)
	if arg0 == var0.Vanguard then
		return var0.VanguardMax
	elseif arg0 == var0.Main then
		return var0.MainMax
	elseif arg0 == var0.Submarine then
		return var0.SubmarineMax
	end
end

var0.TeamPos = {}
var0.TeamPos.FLAG_SHIP = "FlagShip"
var0.TeamPos.LEADER = "Leader"
var0.TeamPos.CENTER = "Center"
var0.TeamPos.REAR = "Rear"
var0.TeamPos.CONSORT = "Consort"
var0.TeamPos.SUB_LEADER = "SubLeader"
var0.TeamPos.SUB_CONSORT = "SubConsort"
var0.TeamPos.UPPER_CONSORT = "UpperConsort"
var0.TeamPos.LOWER_CONSORT = "LowerConsort"

local var1 = {
	[var0.Vanguard] = var0.VanguardShipType,
	[var0.Main] = var0.MainShipType,
	[var0.Submarine] = var0.SubShipType
}

function var0.GetShipTypeListFromTeam(arg0)
	return var1[arg0]
end

local var2 = {}

for iter0, iter1 in pairs(var1) do
	for iter2, iter3 in ipairs(iter1) do
		var2[iter3] = iter0
	end
end

function var0.GetTeamFromShipType(arg0)
	return var2[arg0]
end

return var0
