local var0_0 = class("TeamType")

var0_0.Vanguard = "vanguard"
var0_0.Main = "main"
var0_0.Submarine = "submarine"
var0_0.FormShips = "ships"
var0_0.FormCommander = "commander"
var0_0.TeamTypeIndex = {
	var0_0.Vanguard,
	var0_0.Main,
	var0_0.Submarine
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

return var0_0
