local var0 = class("TypedFleet", import(".Fleet"))

function var0.Ctor(arg0, arg1)
	assert(arg1.fleetType)

	arg0.fleetType = arg1.fleetType or FleetType.Unknowns

	var0.super.Ctor(arg0, arg1)

	arg0.saveLastShipFlag = arg1.saveLastShipFlag
end

function var0.SetFleetType(arg0, arg1)
	arg0.fleetType = arg1 or FleetType.Normal
end

function var0.isSubmarineFleet(arg0)
	return tobool(arg0:getFleetType() == FleetType.Submarine)
end

function var0.SetSaveLastShip(arg0, arg1)
	arg0.saveLastShipFlag = arg1
end

function var0.canRemove(arg0, arg1)
	if not arg0.saveLastShipFlag then
		return true
	end

	local var0, var1 = arg0:getShipPos(arg1)

	if var0 > 0 and #(arg0:getTeamByName(var1) or {}) == 1 then
		return false
	end

	return true
end

function var0.getFleetType(arg0)
	assert(arg0.fleetType and arg0.fleetType ~= FleetType.Unknown, "not set fleet type on init")

	if arg0.fleetType == FleetType.Unknown then
		return FleetType.Normal
	end

	return arg0.fleetType
end

function var0.IsTeamMatch(arg0, arg1)
	local var0 = arg0:getFleetType()

	if var0 == FleetType.Submarine then
		return arg1 == TeamType.Submarine
	elseif var0 == FleetType.Normal then
		return arg1 == TeamType.Vanguard or arg1 == TeamType.Main
	end

	assert(false)

	return true
end

function var0.CanInsertShip(arg0, arg1, arg2)
	if not var0.super.CanInsertShip(arg0, arg1, arg2) then
		return false
	end

	return arg0:IsTeamMatch(arg2)
end

return var0
