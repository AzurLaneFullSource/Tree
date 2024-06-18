local var0_0 = class("TypedFleet", import(".Fleet"))

function var0_0.Ctor(arg0_1, arg1_1)
	assert(arg1_1.fleetType)

	arg0_1.fleetType = arg1_1.fleetType or FleetType.Unknowns

	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.saveLastShipFlag = arg1_1.saveLastShipFlag
end

function var0_0.SetFleetType(arg0_2, arg1_2)
	arg0_2.fleetType = arg1_2 or FleetType.Normal
end

function var0_0.isSubmarineFleet(arg0_3)
	return tobool(arg0_3:getFleetType() == FleetType.Submarine)
end

function var0_0.SetSaveLastShip(arg0_4, arg1_4)
	arg0_4.saveLastShipFlag = arg1_4
end

function var0_0.canRemove(arg0_5, arg1_5)
	if not arg0_5.saveLastShipFlag then
		return true
	end

	local var0_5, var1_5 = arg0_5:getShipPos(arg1_5)

	if var0_5 > 0 and #(arg0_5:getTeamByName(var1_5) or {}) == 1 then
		return false
	end

	return true
end

function var0_0.getFleetType(arg0_6)
	assert(arg0_6.fleetType and arg0_6.fleetType ~= FleetType.Unknown, "not set fleet type on init")

	if arg0_6.fleetType == FleetType.Unknown then
		return FleetType.Normal
	end

	return arg0_6.fleetType
end

function var0_0.IsTeamMatch(arg0_7, arg1_7)
	local var0_7 = arg0_7:getFleetType()

	if var0_7 == FleetType.Submarine then
		return arg1_7 == TeamType.Submarine
	elseif var0_7 == FleetType.Normal then
		return arg1_7 == TeamType.Vanguard or arg1_7 == TeamType.Main
	end

	assert(false)

	return true
end

function var0_0.CanInsertShip(arg0_8, arg1_8, arg2_8)
	if not var0_0.super.CanInsertShip(arg0_8, arg1_8, arg2_8) then
		return false
	end

	return arg0_8:IsTeamMatch(arg2_8)
end

return var0_0
