ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleSupportHiveUnit = class("BattleSupportHiveUnit", var0_0.Battle.BattleWeaponUnit)
var0_0.Battle.BattleSupportHiveUnit.__name = "BattleSupportHiveUnit"

local var3_0 = var0_0.Battle.BattleSupportHiveUnit

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.Update(arg0_2)
	arg0_2:UpdateReload()
	arg0_2:updateMovementInfo()

	if arg0_2._currentState == arg0_2.STATE_READY then
		if arg0_2._host:GetUnitType() ~= var1_0.UnitType.PLAYER_UNIT then
			if arg0_2._preCastInfo.time == nil then
				arg0_2._currentState = arg0_2.STATE_PRECAST_FINISH
			else
				arg0_2:PreCast()
			end
		elseif #var0_0.Battle.BattleTargetChoise.TargetAircraftGB(arg0_2._host) > 0 then
			arg0_2._currentState = arg0_2.STATE_PRECAST_FINISH
		end
	end

	if arg0_2._currentState == arg0_2.STATE_PRECAST_FINISH then
		arg0_2:updateMovementInfo()
		arg0_2:Fire()
	end
end

function var3_0.Fire(arg0_3)
	arg0_3:DispatchGCD()

	arg0_3._currentState = arg0_3.STATE_ATTACK

	arg0_3:DoAttack()

	return true
end

function var3_0.createMajorEmitter(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	local function var0_4(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
		local var0_5, var1_5 = arg0_4:SpwanAircraft(arg2_5)

		var0_5:AddCreateTimer(var1_5, 1.5)

		if arg0_4._debugRecordDEFAircraft then
			table.insert(arg0_4._debugRecordDEFAircraft, var0_5)
		end
	end

	var3_0.super.createMajorEmitter(arg0_4, arg1_4, arg2_4, nil, var0_4, nil)
end

function var3_0.SpwanAircraft(arg0_6, arg1_6)
	local var0_6 = arg0_6._dataProxy:CreateAircraft(arg0_6._host, arg0_6._tmpData.id, arg0_6:GetPotential(), arg0_6._skinID)
	local var1_6 = arg0_6:GetBaseAngle() + arg1_6
	local var2_6 = math.deg2Rad * var1_6
	local var3_6 = Vector3(math.cos(var2_6), 0, math.sin(var2_6))

	return var0_6, var3_6
end

function var3_0.GetATKAircraftList(arg0_7)
	arg0_7._debugRecordATKAircraft = arg0_7._debugRecordATKAircraft or {}

	return arg0_7._debugRecordATKAircraft
end

function var3_0.GetDEFAircraftList(arg0_8)
	arg0_8._debugRecordDEFAircraft = arg0_8._debugRecordDEFAircraft or {}

	return arg0_8._debugRecordDEFAircraft
end

function var3_0.GetDamageSUM(arg0_9)
	local var0_9 = 0
	local var1_9 = arg0_9:GetDEFAircraftList()

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = iter1_9:GetWeapon()

		for iter2_9, iter3_9 in ipairs(var2_9) do
			var0_9 = var0_9 + iter3_9:GetDamageSUM()
		end
	end

	return var0_9
end
