local var0_0 = class("TeamType")

var0_0.Vanguard = "vanguard"
var0_0.Main = "main"
var0_0.Submarine = "submarine"
var0_0.Support = "support"
var0_0.TeamTypeIndex = {
	var0_0.Vanguard,
	var0_0.Main,
	var0_0.Submarine
}
var0_0.VanguardShipType = {
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
var0_0.MainShipType = {
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
var0_0.SubShipType = {
	ShipType.QianTing,
	ShipType.QianMu,
	ShipType.FengFanS
}
var0_0.VanguardMax = 3
var0_0.MainMax = 3
var0_0.SubmarineMax = 3

function var0_0.GetTeamShipMax(arg0_1)
	if arg0_1 == var0_0.Vanguard then
		return var0_0.VanguardMax
	elseif arg0_1 == var0_0.Main then
		return var0_0.MainMax
	elseif arg0_1 == var0_0.Submarine then
		return var0_0.SubmarineMax
	end
end

var0_0.TeamPos = {}
var0_0.TeamPos.FLAG_SHIP = "FlagShip"
var0_0.TeamPos.LEADER = "Leader"
var0_0.TeamPos.CENTER = "Center"
var0_0.TeamPos.REAR = "Rear"
var0_0.TeamPos.CONSORT = "Consort"
var0_0.TeamPos.SUB_LEADER = "SubLeader"
var0_0.TeamPos.SUB_CONSORT = "SubConsort"
var0_0.TeamPos.UPPER_CONSORT = "UpperConsort"
var0_0.TeamPos.LOWER_CONSORT = "LowerConsort"

local var1_0 = {
	[var0_0.Vanguard] = var0_0.VanguardShipType,
	[var0_0.Main] = var0_0.MainShipType,
	[var0_0.Submarine] = var0_0.SubShipType
}

function var0_0.GetShipTypeListFromTeam(arg0_2)
	return var1_0[arg0_2]
end

local var2_0 = {}

for iter0_0, iter1_0 in pairs(var1_0) do
	for iter2_0, iter3_0 in ipairs(iter1_0) do
		var2_0[iter3_0] = iter0_0
	end
end

function var0_0.GetTeamFromShipType(arg0_3)
	return var2_0[arg0_3]
end

return var0_0
