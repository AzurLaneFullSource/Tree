ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleUnitEvent
local var3_0 = var0_0.Battle.BattleAttr
local var4_0 = class("BattlePointHitWeaponUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattlePointHitWeaponUnit = var4_0
var4_0.__name = "BattlePointHitWeaponUnit"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)

	var4_0._strikePoint = nil
	var4_0._strikeRequire = 1
	var4_0._strikeMode = false
end

function var4_0.DispatchBlink(arg0_2, arg1_2)
	local var0_2 = {
		callbackFunc = arg1_2,
		timeScale = var0_0.Battle.BattleConfig.FOCUS_MAP_RATE
	}
	local var1_2 = var0_0.Event.New(var2_0.CHARGE_WEAPON_FINISH, var0_2)

	arg0_2:DispatchEvent(var1_2)
end

function var4_0.RemoveAllLock(arg0_3)
	arg0_3._lockList = {}
end

function var4_0.createMajorEmitter(arg0_4, arg1_4, arg2_4)
	local function var0_4(arg0_5, arg1_5, arg2_5, arg3_5)
		local var0_5
		local var1_5
		local var2_5 = arg0_4._emitBulletIDList[arg2_4]

		if arg0_4._strikePoint then
			var1_5 = arg0_4._strikePoint
			var0_5 = arg0_4:SpawnPointBullet(var2_5, arg0_4._strikePoint)
		else
			local var3_5 = arg0_4._lockList[1]

			var0_5 = arg0_4:Spawn(var2_5, var3_5, arg0_4.INTERNAL)
			var1_5 = var3_5:GetBeenAimedPosition() or var3_5:GetPosition()
		end

		var0_5:SetOffsetPriority(arg3_5)
		var0_5:SetShiftInfo(arg0_5, arg1_5)
		var0_5:SetRotateInfo(var1_5, 0, 0)
		var0_0.Battle.BattleVariable.AddExempt(var0_5:GetSpeedExemptKey(), var0_5:GetIFF(), var0_0.Battle.BattleConfig.SPEED_FACTOR_FOCUS_CHARACTER)
		arg0_4:DispatchBulletEvent(var0_5)
	end

	local function var1_4()
		arg0_4._strikePoint = nil

		arg0_4:RemoveAllLock()
	end

	var4_0.super.createMajorEmitter(arg0_4, arg1_4, arg2_4, var4_0.EMITTER_NORMAL, var0_4, var1_4)
end

function var4_0.SetPlayerChargeWeaponVO(arg0_7, arg1_7)
	arg0_7._playerChargeWeaponVo = arg1_7
end

function var4_0.Charge(arg0_8)
	arg0_8._currentState = arg0_8.STATE_PRECAST
	arg0_8._lockList = {}

	local var0_8 = {}
	local var1_8 = var0_0.Event.New(var2_0.POINT_HIT_CHARGE, var0_8)

	arg0_8:DispatchEvent(var1_8)

	arg0_8._strikeMode = true
end

function var4_0.CancelCharge(arg0_9)
	if arg0_9._currentState ~= arg0_9.STATE_PRECAST then
		return
	end

	arg0_9:RemoveAllLock()

	arg0_9._currentState = arg0_9.STATE_READY

	local var0_9 = {}
	local var1_9 = var0_0.Event.New(var2_0.POINT_HIT_CANCEL, var0_9)

	arg0_9:DispatchEvent(var1_9)

	arg0_9._strikeMode = nil
end

function var4_0.QuickTag(arg0_10)
	arg0_10._currentState = arg0_10.STATE_PRECAST
	arg0_10._lockList = {}

	arg0_10:updateMovementInfo()

	local var0_10 = arg0_10:Tracking()

	arg0_10._lockList[#arg0_10._lockList + 1] = var0_10
end

function var4_0.CancelQuickTag(arg0_11)
	arg0_11._currentState = arg0_11.STATE_READY
	arg0_11._lockList = {}
end

function var4_0.Update(arg0_12, arg1_12)
	arg0_12:UpdateReload()
end

function var4_0.Fire(arg0_13, arg1_13)
	if arg0_13._currentState ~= arg0_13.STATE_PRECAST then
		return
	end

	arg0_13._strikePoint = arg1_13

	arg0_13._host:CloakExpose(var0_0.Battle.BattleConfig.CLOAK_BOMBARD_BASE_EXPOSE)
	arg0_13._host:BombardExpose()

	arg0_13._strikeMode = false

	return var4_0.super.Fire(arg0_13)
end

function var4_0.DoAttack(arg0_14, arg1_14)
	var0_0.Battle.PlayBattleSFX(arg0_14._tmpData.fire_sfx)

	local var0_14 = var0_0.Event.New(var2_0.CHARGE_WEAPON_FIRE, {
		weapon = arg0_14
	})

	arg0_14:DispatchEvent(var0_14)
	arg0_14:cacheBulletID()
	arg0_14:TriggerBuffOnSteday()

	for iter0_14, iter1_14 in ipairs(arg0_14._majorEmitterList) do
		iter1_14:Ready()
	end

	for iter2_14, iter3_14 in ipairs(arg0_14._majorEmitterList) do
		iter3_14:Fire(arg1_14, arg0_14:GetDirection(), arg0_14:GetAttackAngle())
		iter3_14:SetTimeScale(false)
	end

	arg0_14:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_WEAPON_FIRE, {}))
	arg0_14:TriggerBuffOnFire()
	var0_0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var1_0.ShakeType.FIRE])
end

function var4_0.TriggerBuffOnReady(arg0_15)
	if arg0_15._tmpData.type == var1_0.EquipmentType.MANUAL_MISSILE then
		arg0_15._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_MANUAL_MISSILE_READY, {})
	else
		arg0_15._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_CHARGE_READY, {})
	end
end

function var4_0.Spawn(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16

	if arg2_16 == nil then
		arg0_16:updateMovementInfo()

		arg2_16 = arg0_16:TrackingRandom(arg0_16:GetFilteredList())

		if arg2_16 == nil then
			var0_16 = Vector3.zero
		else
			var0_16 = arg2_16:GetBeenAimedPosition() or arg2_16:GetPosition()
		end
	else
		var0_16 = arg2_16:GetBeenAimedPosition() or arg2_16:GetPosition()
	end

	local var1_16 = arg0_16._dataProxy:CreateBulletUnit(arg1_16, arg0_16._host, arg0_16, var0_16)

	arg0_16:setBulletSkin(var1_16, arg1_16)
	arg0_16:TriggerBuffWhenSpawn(var1_16)

	if arg3_16 == arg0_16.INTERNAL then
		local var2_16 = arg0_16._host:GetAttrByName("initialEnhancement")

		var1_16:SetDamageEnhance(1 + var2_16)
		arg0_16:TriggerBuffWhenSpawn(var1_16, var1_0.BuffEffectType.ON_INTERNAL_BULLET_CREATE)
	end

	return var1_16
end

function var4_0.SpawnPointBullet(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17._dataProxy:CreateBulletUnit(arg1_17, arg0_17._host, arg0_17, arg2_17)

	arg0_17:TriggerBuffWhenSpawn(var0_17, var1_0.BuffEffectType.ON_MANUAL_BULLET_CREATE)
	arg0_17:setBulletSkin(var0_17, arg1_17)

	local var1_17 = arg0_17._host:GetAttrByName("initialEnhancement") + arg0_17._host:GetAttrByName("manualEnhancement")

	var0_17:SetDamageEnhance(var0_0.Battle.BattleConfig.ChargeWeaponConfig.Enhance + var1_17)
	arg0_17:TriggerBuffWhenSpawn(var0_17)
	arg0_17:TriggerBuffWhenSpawn(var0_17, var1_0.BuffEffectType.ON_INTERNAL_BULLET_CREATE)

	return var0_17
end

function var4_0.TriggerBuffOnFire(arg0_18)
	if arg0_18._tmpData.type == var1_0.EquipmentType.MANUAL_MISSILE then
		arg0_18._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_MANUAL_MISSILE_FIRE, {})
	else
		arg0_18._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_CHARGE_FIRE, {})
	end
end

function var4_0.InitialCD(arg0_19)
	var4_0.super.InitialCD(arg0_19)
	arg0_19._playerChargeWeaponVo:InitialDeduct(arg0_19)
	arg0_19._playerChargeWeaponVo:Charge(arg0_19)
end

function var4_0.EnterCoolDown(arg0_20)
	var4_0.super.EnterCoolDown(arg0_20)
	arg0_20._playerChargeWeaponVo:Charge(arg0_20)
end

function var4_0.OverHeat(arg0_21)
	var4_0.super.OverHeat(arg0_21)
	arg0_21._playerChargeWeaponVo:Deduct(arg0_21)
end

function var4_0.GetMinAngle(arg0_22)
	return arg0_22:GetAttackAngle()
end

function var4_0.GetLockList(arg0_23)
	return arg0_23._lockList
end

function var4_0.GetFilteredList(arg0_24)
	local var0_24 = var4_0.super.GetFilteredList(arg0_24)

	return (arg0_24:filterEnemyUnitType(var0_24))
end

function var4_0.filterEnemyUnitType(arg0_25, arg1_25)
	local var0_25 = {}
	local var1_25 = {}
	local var2_25 = -9999

	for iter0_25, iter1_25 in ipairs(arg1_25) do
		local var3_25 = iter1_25:GetTargetedPriority()

		if var3_25 == nil then
			var1_25[#var1_25 + 1] = iter1_25
		elseif var2_25 < var3_25 then
			var2_25 = var3_25
			var0_25 = {}
			var0_25[#var0_25 + 1] = iter1_25
		elseif var2_25 == var3_25 then
			var0_25[#var0_25 + 1] = iter1_25
		end
	end

	for iter2_25, iter3_25 in ipairs(var1_25) do
		var0_25[#var0_25 + 1] = iter3_25
	end

	return var0_25
end

function var4_0.handleCoolDown(arg0_26)
	arg0_26._currentState = arg0_26.STATE_READY

	arg0_26._playerChargeWeaponVo:Plus(arg0_26)
	arg0_26:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_WEAPON_READY, {}))
	arg0_26:TriggerBuffOnReady()

	arg0_26._CDstartTime = nil
	arg0_26._reloadBoostList = {}
end

function var4_0.FlushReloadMax(arg0_27, arg1_27)
	if var4_0.super.FlushReloadMax(arg0_27, arg1_27) then
		return true
	end

	arg0_27._playerChargeWeaponVo:RefreshReloadingBar()
end

function var4_0.FlushReloadRequire(arg0_28)
	if var4_0.super.FlushReloadRequire(arg0_28) then
		return true
	end

	arg0_28._playerChargeWeaponVo:RefreshReloadingBar()
end

function var4_0.QuickCoolDown(arg0_29)
	if arg0_29._currentState == arg0_29.STATE_OVER_HEAT then
		arg0_29._currentState = arg0_29.STATE_READY

		arg0_29._playerChargeWeaponVo:InstantCoolDown(arg0_29)
		arg0_29:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_WEAPON_INSTANT_READY, {}))

		arg0_29._CDstartTime = nil
		arg0_29._reloadBoostList = {}
	end
end

function var4_0.ReloadBoost(arg0_30, arg1_30)
	local var0_30 = 0

	for iter0_30, iter1_30 in ipairs(arg0_30._reloadBoostList) do
		var0_30 = var0_30 + iter1_30
	end

	local var1_30 = var0_30 + arg1_30
	local var2_30 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_30._jammingTime - arg0_30._CDstartTime
	local var3_30

	if var1_30 < 0 then
		var3_30 = math.max(var1_30, (arg0_30._reloadRequire - var2_30) * -1)
	else
		var3_30 = math.min(var1_30, var2_30)
	end

	fixValue = var3_30 - var1_30 + arg1_30

	table.insert(arg0_30._reloadBoostList, fixValue)
end

function var4_0.AppendReloadBoost(arg0_31, arg1_31)
	if arg0_31._currentState == arg0_31.STATE_OVER_HEAT then
		arg0_31._playerChargeWeaponVo:ReloadBoost(arg0_31, arg1_31)
	end
end

function var4_0.IsStrikeMode(arg0_32)
	return arg0_32._strikeMode
end
