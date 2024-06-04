ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig

var0.Battle.BattleHiveUnit = class("BattleHiveUnit", var0.Battle.BattleWeaponUnit)
var0.Battle.BattleHiveUnit.__name = "BattleHiveUnit"

local var3 = var0.Battle.BattleHiveUnit

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
		else
			local var0

			if arg0._antiSub then
				var0 = var0.Battle.BattleTargetChoise.LegalTarget(arg0._host)
				var0 = var0.Battle.BattleTargetChoise.TargetDiveState(nil, nil, var0)
				var0 = var0.Battle.BattleTargetChoise.TargetDetectedUnit(nil, nil, var0)
			else
				var0 = var0.Battle.BattleTargetChoise.TargetAircraftHarm(arg0._host)
			end

			if #var0 > 0 then
				arg0._currentState = arg0.STATE_PRECAST_FINISH
			end
		end
	end

	if arg0._currentState == arg0.STATE_PRECAST_FINISH then
		arg0:updateMovementInfo()
		arg0:Fire()
	end
end

function var3.SetTemplateData(arg0, arg1)
	var3.super.SetTemplateData(arg0, arg1)

	arg0._antiSub = table.contains(arg1.search_condition, var1.OXY_STATE.DIVE)
end

function var3.Fire(arg0)
	arg0:DispatchGCD()

	arg0._currentState = arg0.STATE_ATTACK

	if arg0._tmpData.action_index == "" then
		arg0:DoAttack()
	else
		arg0:DispatchFireEvent(nil, arg0._tmpData.action_index)
	end

	arg0._host:CloakExpose(arg0._tmpData.expose)

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

function var3.SingleFire(arg0, arg1, arg2, arg3)
	arg0._tempEmitterList = {}

	local var0 = function(arg0, arg1, arg2, arg3, arg4)
		local var0, var1 = arg0:SpwanAircraft(arg2)

		var0.Battle.BattleVariable.AddExempt(var0:GetSpeedExemptKey(), var0:GetIFF(), var2.SPEED_FACTOR_FOCUS_CHARACTER)
		var0:AddCreateTimer(var1, 1)

		if arg0._debugRecordATKAircraft then
			table.insert(arg0._debugRecordATKAircraft, var0)
		end
	end

	local function var1()
		for iter0, iter1 in ipairs(arg0._tempEmitterList) do
			if iter1:GetState() ~= iter1.STATE_STOP then
				return
			end
		end

		for iter2, iter3 in ipairs(arg0._tempEmitterList) do
			iter3:Destroy()
		end

		arg0._tempEmitterList = nil

		if arg3 then
			arg3()
		end
	end

	arg2 = arg2 or var3.EMITTER_SHOTGUN

	for iter0, iter1 in ipairs(arg0._tmpData.barrage_ID) do
		local var2 = var0.Battle[arg2].New(var0, var1, iter1)

		arg0._tempEmitterList[#arg0._tempEmitterList + 1] = var2
	end

	for iter2, iter3 in ipairs(arg0._tempEmitterList) do
		iter3:Ready()
		iter3:Fire(arg1, arg0:GetDirection(), arg0:GetAttackAngle())
		iter3:SetTimeScale(false)
	end

	arg0._host:CloakExpose(arg0._tmpData.expose)
end

function var3.SpwanAircraft(arg0, arg1)
	local var0 = arg0._dataProxy:CreateAircraft(arg0._host, arg0._tmpData.id, arg0:GetPotential(), arg0._skinID)
	local var1 = arg0:GetBaseAngle() + arg1
	local var2 = math.deg2Rad * var1
	local var3 = Vector3(math.cos(var2), 0, math.sin(var2))

	arg0:TriggerBuffWhenSpawnAircraft(var0)

	return var0, var3
end

function var3.TriggerBuffWhenSpawnAircraft(arg0, arg1)
	local var0 = var1.BuffEffectType.ON_AIRCRAFT_CREATE
	local var1 = {
		aircraft = arg1,
		equipIndex = arg0._equipmentIndex
	}

	arg0._host:TriggerBuff(var0, var1)
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
