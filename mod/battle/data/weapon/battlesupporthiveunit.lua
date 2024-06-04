ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig

var0.Battle.BattleSupportHiveUnit = class("BattleSupportHiveUnit", var0.Battle.BattleWeaponUnit)
var0.Battle.BattleSupportHiveUnit.__name = "BattleSupportHiveUnit"

local var3 = var0.Battle.BattleSupportHiveUnit

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.Update(arg0)
	arg0:UpdateReload()
	arg0:updateMovementInfo()

	if arg0._currentState == arg0.STATE_READY then
		if arg0._host:GetUnitType() ~= var1.UnitType.PLAYER_UNIT then
			if arg0._preCastInfo.time == nil then
				arg0._currentState = arg0.STATE_PRECAST_FINISH
			else
				arg0:PreCast()
			end
		elseif #var0.Battle.BattleTargetChoise.TargetAircraftGB(arg0._host) > 0 then
			arg0._currentState = arg0.STATE_PRECAST_FINISH
		end
	end

	if arg0._currentState == arg0.STATE_PRECAST_FINISH then
		arg0:updateMovementInfo()
		arg0:Fire()
	end
end

function var3.Fire(arg0)
	arg0:DispatchGCD()

	arg0._currentState = arg0.STATE_ATTACK

	arg0:DoAttack()

	return true
end

function var3.createMajorEmitter(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0(arg0, arg1, arg2, arg3, arg4)
		local var0, var1 = arg0:SpwanAircraft(arg2)

		var0:AddCreateTimer(var1, 1.5)

		if arg0._debugRecordDEFAircraft then
			table.insert(arg0._debugRecordDEFAircraft, var0)
		end
	end

	var3.super.createMajorEmitter(arg0, arg1, arg2, nil, var0, nil)
end

function var3.SpwanAircraft(arg0, arg1)
	local var0 = arg0._dataProxy:CreateAircraft(arg0._host, arg0._tmpData.id, arg0:GetPotential(), arg0._skinID)
	local var1 = arg0:GetBaseAngle() + arg1
	local var2 = math.deg2Rad * var1
	local var3 = Vector3(math.cos(var2), 0, math.sin(var2))

	return var0, var3
end

function var3.GetATKAircraftList(arg0)
	arg0._debugRecordATKAircraft = arg0._debugRecordATKAircraft or {}

	return arg0._debugRecordATKAircraft
end

function var3.GetDEFAircraftList(arg0)
	arg0._debugRecordDEFAircraft = arg0._debugRecordDEFAircraft or {}

	return arg0._debugRecordDEFAircraft
end

function var3.GetDamageSUM(arg0)
	local var0 = 0
	local var1 = arg0:GetDEFAircraftList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1:GetWeapon()

		for iter2, iter3 in ipairs(var2) do
			var0 = var0 + iter3:GetDamageSUM()
		end
	end

	return var0
end
