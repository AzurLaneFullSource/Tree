local var0_0 = class("TypedFleet", import(".Fleet"))

function var0_0.Ctor(arg0_1, arg1_1)
	assert(arg1_1.fleetType)

	arg0_1.fleetType = arg1_1.fleetType or FleetType.Unknowns

	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.saveLastShipFlag = arg1_1.saveLastShipFlag
end

function var0_0.SeparateOut(arg0_2)
	local var0_2 = var0_0.super.SeparateOut(arg0_2)

	var0_2.fleetType = arg0_2.fleetType
	var0_2.saveLastShipFlag = arg0_2.saveLastShipFlag

	return var0_2
end

function var0_0.SetFleetType(arg0_3, arg1_3)
	arg0_3.fleetType = arg1_3 or FleetType.Normal
end

function var0_0.isSubmarineFleet(arg0_4)
	return tobool(arg0_4:getFleetType() == FleetType.Submarine)
end

function var0_0.SetSaveLastShip(arg0_5, arg1_5)
	arg0_5.saveLastShipFlag = arg1_5
end

function var0_0.canRemove(arg0_6, arg1_6)
	if not arg0_6.saveLastShipFlag then
		return true
	end

	local var0_6, var1_6 = arg0_6:getShipPos(arg1_6)

	if var0_6 > 0 and #(arg0_6:getTeamByName(var1_6) or {}) == 1 then
		return false
	end

	return true
end

function var0_0.getFleetType(arg0_7)
	assert(arg0_7.fleetType and arg0_7.fleetType ~= FleetType.Unknown, "not set fleet type on init")

	if arg0_7.fleetType == FleetType.Unknown then
		return FleetType.Normal
	end

	return arg0_7.fleetType
end

function var0_0.IsTeamMatch(arg0_8, arg1_8)
	local var0_8 = arg0_8:getFleetType()

	if var0_8 == FleetType.Submarine then
		return arg1_8 == TeamType.Submarine
	elseif var0_8 == FleetType.Normal then
		return arg1_8 == TeamType.Vanguard or arg1_8 == TeamType.Main
	end

	assert(false)

	return true
end

function var0_0.CanInsertShip(arg0_9, arg1_9, arg2_9)
	if not var0_0.super.CanInsertShip(arg0_9, arg1_9, arg2_9) then
		return false
	end

	return arg0_9:IsTeamMatch(arg2_9)
end

return var0_0
