ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleUnitEvent
local var3_0 = var0_0.Battle.BattleAttr
local var4_0 = class("BattlePointAirStrikeUnit", var0_0.Battle.BattlePointHitWeaponUnit)

var0_0.Battle.BattlePointAirStrikeUnit = var4_0
var4_0.__name = "BattlePointAirStrikeUnit"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)

	var4_0._strikePoint = nil
	var4_0._strikeMode = false
end

function var4_0.RemoveAllLock(arg0_2)
	arg0_2._lockList = {}
end

function var4_0.Charge(arg0_3)
	arg0_3._currentState = arg0_3.STATE_PRECAST
	arg0_3._lockList = {}

	local var0_3 = {}
	local var1_3 = var0_0.Event.New(var2_0.POINT_HIT_CHARGE, var0_3)

	arg0_3:DispatchEvent(var1_3)

	arg0_3._strikeMode = true
end

function var4_0.CancelCharge(arg0_4)
	if arg0_4._currentState ~= arg0_4.STATE_PRECAST then
		return
	end

	arg0_4:RemoveAllLock()

	arg0_4._currentState = arg0_4.STATE_READY

	local var0_4 = {}
	local var1_4 = var0_0.Event.New(var2_0.POINT_HIT_CANCEL, var0_4)

	arg0_4:DispatchEvent(var1_4)

	arg0_4._strikeMode = nil
end

function var4_0.SetAirUnit(arg0_5, arg1_5)
	arg0_5._hiveList = {}

	for iter0_5, iter1_5 in ipairs(arg1_5) do
		local var0_5 = var0_0.Battle.BattleDataFunction.CreateWeaponUnit(iter1_5, arg0_5._host, nil, -1)
		local var1_5 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, {
			weapon = var0_5
		})

		arg0_5._host:DispatchEvent(var1_5)
		table.insert(arg0_5._hiveList, var0_5)
	end
end

function var4_0.DoAttack(arg0_6, arg1_6)
	var0_0.Battle.PlayBattleSFX(arg0_6._tmpData.fire_sfx)

	local var0_6 = var0_0.Event.New(var2_0.CHARGE_WEAPON_FIRE, {
		weapon = arg0_6
	})

	arg0_6:DispatchEvent(var0_6)
	arg0_6._host:TriggerBuff(var1_0.BuffEffectType.ON_POINT_STRIKE_STEADY, {})

	for iter0_6, iter1_6 in ipairs(arg0_6._hiveList) do
		local var1_6 = arg0_6._strikePoint or arg0_6._lockList[1]:GetPosition()

		iter1_6:SetStrikePoint(var1_6)
		iter1_6:updateMovementInfo()
		iter1_6:SingleFire()
	end

	arg0_6:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_WEAPON_FIRE, {}))
	arg0_6:TriggerBuffOnFire()

	arg0_6._strikePoint = nil

	arg0_6:RemoveAllLock()
end

function var4_0.SetReloadTime(arg0_7, arg1_7)
	arg0_7._reloadMax = arg1_7
end

function var4_0.AddCDTimer(arg0_8, arg1_8)
	arg0_8._currentState = arg0_8.STATE_OVER_HEAT
	arg0_8._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_8._reloadRequire = arg1_8
end

function var4_0.TriggerBuffOnReady(arg0_9)
	arg0_9._host:TriggerBuff(var1_0.BuffEffectType.ON_POINT_STRIKE_READY, {})
end

function var4_0.TriggerBuffOnFire(arg0_10)
	arg0_10._host:TriggerBuff(var1_0.BuffEffectType.ON_POINT_STRIKE, {})
end

function var4_0.GetReloadFinishTimeStamp(arg0_11)
	local var0_11 = 0

	for iter0_11, iter1_11 in ipairs(arg0_11._reloadBoostList) do
		var0_11 = var0_11 + iter1_11
	end

	return arg0_11._reloadRequire + arg0_11._CDstartTime + arg0_11._jammingTime + var0_11
end

function var4_0.GetLockList(arg0_12)
	return arg0_12._lockList
end

function var4_0.GetFilteredList(arg0_13)
	local var0_13 = var4_0.super.GetFilteredList(arg0_13)

	return (arg0_13:filterEnemyUnitType(var0_13))
end

function var4_0.filterEnemyUnitType(arg0_14, arg1_14)
	local var0_14 = {}
	local var1_14 = {}
	local var2_14 = -9999

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		local var3_14 = iter1_14:GetTargetedPriority()

		if var3_14 == nil then
			var1_14[#var1_14 + 1] = iter1_14
		elseif var2_14 < var3_14 then
			var2_14 = var3_14
			var0_14 = {}
			var0_14[#var0_14 + 1] = iter1_14
		elseif var2_14 == var3_14 then
			var0_14[#var0_14 + 1] = iter1_14
		end
	end

	for iter2_14, iter3_14 in ipairs(var1_14) do
		var0_14[#var0_14 + 1] = iter3_14
	end

	return var0_14
end

function var4_0.handleCoolDown(arg0_15)
	arg0_15._currentState = arg0_15.STATE_READY

	arg0_15._playerChargeWeaponVo:Plus(arg0_15)
	arg0_15:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_WEAPON_READY, {}))
	arg0_15:TriggerBuffOnReady()

	arg0_15._CDstartTime = nil
	arg0_15._reloadBoostList = {}
end

function var4_0.FlushReloadMax(arg0_16, arg1_16)
	if var4_0.super.FlushReloadMax(arg0_16, arg1_16) then
		return true
	end

	arg0_16._playerChargeWeaponVo:RefreshReloadingBar()
end

function var4_0.FlushReloadRequire(arg0_17)
	if var4_0.super.FlushReloadRequire(arg0_17) then
		return true
	end

	arg0_17._playerChargeWeaponVo:RefreshReloadingBar()
end

function var4_0.QuickCoolDown(arg0_18)
	if arg0_18._currentState == arg0_18.STATE_OVER_HEAT then
		arg0_18._currentState = arg0_18.STATE_READY

		arg0_18._playerChargeWeaponVo:InstantCoolDown(arg0_18)
		arg0_18:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_WEAPON_INSTANT_READY, {}))

		arg0_18._CDstartTime = nil
		arg0_18._reloadBoostList = {}
	end
end

function var4_0.IsStrikeMode(arg0_19)
	return arg0_19._strikeMode
end
