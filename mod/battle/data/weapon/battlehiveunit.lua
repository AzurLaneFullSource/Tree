ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleHiveUnit = class("BattleHiveUnit", var0_0.Battle.BattleWeaponUnit)
var0_0.Battle.BattleHiveUnit.__name = "BattleHiveUnit"

local var3_0 = var0_0.Battle.BattleHiveUnit

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
		else
			local var0_2

			if arg0_2._antiSub then
				var0_2 = var0_0.Battle.BattleTargetChoise.LegalTarget(arg0_2._host)
				var0_2 = var0_0.Battle.BattleTargetChoise.TargetDiveState(nil, nil, var0_2)
				var0_2 = var0_0.Battle.BattleTargetChoise.TargetDetectedUnit(nil, nil, var0_2)
			else
				var0_2 = var0_0.Battle.BattleTargetChoise.TargetAircraftHarm(arg0_2._host)
			end

			if #var0_2 > 0 then
				arg0_2._currentState = arg0_2.STATE_PRECAST_FINISH
			end
		end
	end

	if arg0_2._currentState == arg0_2.STATE_PRECAST_FINISH then
		arg0_2:updateMovementInfo()
		arg0_2:Fire()
	end
end

function var3_0.SetTemplateData(arg0_3, arg1_3)
	var3_0.super.SetTemplateData(arg0_3, arg1_3)

	arg0_3._antiSub = table.contains(arg1_3.search_condition, var1_0.OXY_STATE.DIVE)
end

function var3_0.Fire(arg0_4)
	arg0_4:DispatchGCD()

	arg0_4._currentState = arg0_4.STATE_ATTACK

	if arg0_4._tmpData.action_index == "" then
		arg0_4:DoAttack()
	else
		arg0_4:DispatchFireEvent(nil, arg0_4._tmpData.action_index)
	end

	arg0_4._host:CloakExpose(arg0_4._tmpData.expose)

	return true
end

function var3_0.createMajorEmitter(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	local function var0_5(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
		local var0_6, var1_6 = arg0_5:SpwanAircraft(arg2_6)

		var0_6:AddCreateTimer(var1_6, 1.5)

		if arg0_5._debugRecordDEFAircraft then
			table.insert(arg0_5._debugRecordDEFAircraft, var0_6)
		end
	end

	var3_0.super.createMajorEmitter(arg0_5, arg1_5, arg2_5, nil, var0_5, nil)
end

function var3_0.SingleFire(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7._tempEmitterList = {}

	local function var0_7(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
		local var0_8, var1_8 = arg0_7:SpwanAircraft(arg2_8)

		var0_0.Battle.BattleVariable.AddExempt(var0_8:GetSpeedExemptKey(), var0_8:GetIFF(), var2_0.SPEED_FACTOR_FOCUS_CHARACTER)
		var0_8:AddCreateTimer(var1_8, 1)

		if arg0_7._debugRecordATKAircraft then
			table.insert(arg0_7._debugRecordATKAircraft, var0_8)
		end
	end

	local function var1_7()
		for iter0_9, iter1_9 in ipairs(arg0_7._tempEmitterList) do
			if iter1_9:GetState() ~= iter1_9.STATE_STOP then
				return
			end
		end

		for iter2_9, iter3_9 in ipairs(arg0_7._tempEmitterList) do
			iter3_9:Destroy()
		end

		arg0_7._tempEmitterList = nil

		if arg3_7 then
			arg3_7()
		end
	end

	arg2_7 = arg2_7 or var3_0.EMITTER_SHOTGUN

	for iter0_7, iter1_7 in ipairs(arg0_7._tmpData.barrage_ID) do
		local var2_7 = var0_0.Battle[arg2_7].New(var0_7, var1_7, iter1_7)

		arg0_7._tempEmitterList[#arg0_7._tempEmitterList + 1] = var2_7
	end

	for iter2_7, iter3_7 in ipairs(arg0_7._tempEmitterList) do
		iter3_7:Ready()
		iter3_7:Fire(arg1_7, arg0_7:GetDirection(), arg0_7:GetAttackAngle())
		iter3_7:SetTimeScale(false)
	end

	arg0_7._host:CloakExpose(arg0_7._tmpData.expose)
end

function var3_0.SpwanAircraft(arg0_10, arg1_10)
	local var0_10 = arg0_10._dataProxy:CreateAircraft(arg0_10._host, arg0_10._tmpData.id, arg0_10:GetPotential(), arg0_10._skinID)

	if arg0_10:GetStandHost() then
		var0_10:SetAttr(arg0_10:GetStandHost())
	end

	local var1_10 = arg0_10:GetBaseAngle() + arg1_10
	local var2_10 = math.deg2Rad * var1_10
	local var3_10 = Vector3(math.cos(var2_10), 0, math.sin(var2_10))

	arg0_10:TriggerBuffWhenSpawnAircraft(var0_10)

	return var0_10, var3_10
end

function var3_0.TriggerBuffWhenSpawnAircraft(arg0_11, arg1_11)
	local var0_11 = var1_0.BuffEffectType.ON_AIRCRAFT_CREATE
	local var1_11 = {
		aircraft = arg1_11,
		equipIndex = arg0_11._equipmentIndex
	}

	arg0_11._host:TriggerBuff(var0_11, var1_11)
end

function var3_0.GetATKAircraftList(arg0_12)
	arg0_12._debugRecordATKAircraft = arg0_12._debugRecordATKAircraft or {}

	return arg0_12._debugRecordATKAircraft
end

function var3_0.GetDEFAircraftList(arg0_13)
	arg0_13._debugRecordDEFAircraft = arg0_13._debugRecordDEFAircraft or {}

	return arg0_13._debugRecordDEFAircraft
end

function var3_0.GetDamageSUM(arg0_14)
	local var0_14 = 0
	local var1_14 = arg0_14:GetDEFAircraftList()

	for iter0_14, iter1_14 in ipairs(var1_14) do
		local var2_14 = iter1_14:GetWeapon()

		for iter2_14, iter3_14 in ipairs(var2_14) do
			var0_14 = var0_14 + iter3_14:GetDamageSUM()
		end
	end

	return var0_14
end
