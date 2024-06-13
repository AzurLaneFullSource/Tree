ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleUnitEvent
local var3 = var0.Battle.BattleAttr
local var4 = class("BattlePointHitWeaponUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattlePointHitWeaponUnit = var4
var4.__name = "BattlePointHitWeaponUnit"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)

	var4._strikePoint = nil
	var4._strikeRequire = 1
	var4._strikeMode = false
end

function var4.DispatchBlink(arg0, arg1)
	local var0 = {
		callbackFunc = arg1,
		timeScale = var0.Battle.BattleConfig.FOCUS_MAP_RATE
	}
	local var1 = var0.Event.New(var2.CHARGE_WEAPON_FINISH, var0)

	arg0:DispatchEvent(var1)
end

function var4.RemoveAllLock(arg0)
	arg0._lockList = {}
end

function var4.createMajorEmitter(arg0, arg1, arg2)
	local var0 = function(arg0, arg1, arg2, arg3)
		local var0
		local var1
		local var2 = arg0._emitBulletIDList[arg2]

		if arg0._strikePoint then
			var1 = arg0._strikePoint
			var0 = arg0:SpawnPointBullet(var2, arg0._strikePoint)
		else
			local var3 = arg0._lockList[1]

			var0 = arg0:Spawn(var2, var3, arg0.INTERNAL)
			var1 = var3:GetBeenAimedPosition() or var3:GetPosition()
		end

		var0:SetOffsetPriority(arg3)
		var0:SetShiftInfo(arg0, arg1)
		var0:SetRotateInfo(var1, 0, 0)
		var0.Battle.BattleVariable.AddExempt(var0:GetSpeedExemptKey(), var0:GetIFF(), var0.Battle.BattleConfig.SPEED_FACTOR_FOCUS_CHARACTER)
		arg0:DispatchBulletEvent(var0)
	end

	local function var1()
		arg0._strikePoint = nil

		arg0:RemoveAllLock()
	end

	var4.super.createMajorEmitter(arg0, arg1, arg2, var4.EMITTER_NORMAL, var0, var1)
end

function var4.SetPlayerChargeWeaponVO(arg0, arg1)
	arg0._playerChargeWeaponVo = arg1
end

function var4.Charge(arg0)
	arg0._currentState = arg0.STATE_PRECAST
	arg0._lockList = {}

	local var0 = {}
	local var1 = var0.Event.New(var2.POINT_HIT_CHARGE, var0)

	arg0:DispatchEvent(var1)

	arg0._strikeMode = true
end

function var4.CancelCharge(arg0)
	if arg0._currentState ~= arg0.STATE_PRECAST then
		return
	end

	arg0:RemoveAllLock()

	arg0._currentState = arg0.STATE_READY

	local var0 = {}
	local var1 = var0.Event.New(var2.POINT_HIT_CANCEL, var0)

	arg0:DispatchEvent(var1)

	arg0._strikeMode = nil
end

function var4.QuickTag(arg0)
	arg0._currentState = arg0.STATE_PRECAST
	arg0._lockList = {}

	arg0:updateMovementInfo()

	local var0 = arg0:Tracking()

	arg0._lockList[#arg0._lockList + 1] = var0
end

function var4.CancelQuickTag(arg0)
	arg0._currentState = arg0.STATE_READY
	arg0._lockList = {}
end

function var4.Update(arg0, arg1)
	arg0:UpdateReload()
end

function var4.Fire(arg0, arg1)
	if arg0._currentState ~= arg0.STATE_PRECAST then
		return
	end

	arg0._strikePoint = arg1

	arg0._host:CloakExpose(var0.Battle.BattleConfig.CLOAK_BOMBARD_BASE_EXPOSE)
	arg0._host:BombardExpose()

	arg0._strikeMode = false

	return var4.super.Fire(arg0)
end

function var4.DoAttack(arg0, arg1)
	var0.Battle.PlayBattleSFX(arg0._tmpData.fire_sfx)

	local var0 = var0.Event.New(var2.CHARGE_WEAPON_FIRE, {
		weapon = arg0
	})

	arg0:DispatchEvent(var0)
	arg0:cacheBulletID()
	arg0:TriggerBuffOnSteday()

	for iter0, iter1 in ipairs(arg0._majorEmitterList) do
		iter1:Ready()
	end

	for iter2, iter3 in ipairs(arg0._majorEmitterList) do
		iter3:Fire(arg1, arg0:GetDirection(), arg0:GetAttackAngle())
		iter3:SetTimeScale(false)
	end

	arg0:DispatchEvent(var0.Event.New(var2.MANUAL_WEAPON_FIRE, {}))
	arg0:TriggerBuffOnFire()
	var0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var1.ShakeType.FIRE])
end

function var4.TriggerBuffOnReady(arg0)
	if arg0._tmpData.type == var1.EquipmentType.MANUAL_MISSILE then
		arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_MANUAL_MISSILE_READY, {})
	else
		arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_CHARGE_READY, {})
	end
end

function var4.Spawn(arg0, arg1, arg2, arg3)
	local var0

	if arg2 == nil then
		arg0:updateMovementInfo()

		arg2 = arg0:TrackingRandom(arg0:GetFilteredList())

		if arg2 == nil then
			var0 = Vector3.zero
		else
			var0 = arg2:GetBeenAimedPosition() or arg2:GetPosition()
		end
	else
		var0 = arg2:GetBeenAimedPosition() or arg2:GetPosition()
	end

	local var1 = arg0._dataProxy:CreateBulletUnit(arg1, arg0._host, arg0, var0)

	arg0:setBulletSkin(var1, arg1)
	arg0:TriggerBuffWhenSpawn(var1)

	if arg3 == arg0.INTERNAL then
		local var2 = arg0._host:GetAttrByName("initialEnhancement")

		var1:SetDamageEnhance(1 + var2)
		arg0:TriggerBuffWhenSpawn(var1, var1.BuffEffectType.ON_INTERNAL_BULLET_CREATE)
	end

	return var1
end

function var4.SpawnPointBullet(arg0, arg1, arg2)
	local var0 = arg0._dataProxy:CreateBulletUnit(arg1, arg0._host, arg0, arg2)

	arg0:TriggerBuffWhenSpawn(var0, var1.BuffEffectType.ON_MANUAL_BULLET_CREATE)
	arg0:setBulletSkin(var0, arg1)

	local var1 = arg0._host:GetAttrByName("initialEnhancement") + arg0._host:GetAttrByName("manualEnhancement")

	var0:SetDamageEnhance(var0.Battle.BattleConfig.ChargeWeaponConfig.Enhance + var1)
	arg0:TriggerBuffWhenSpawn(var0)
	arg0:TriggerBuffWhenSpawn(var0, var1.BuffEffectType.ON_INTERNAL_BULLET_CREATE)

	return var0
end

function var4.TriggerBuffOnFire(arg0)
	if arg0._tmpData.type == var1.EquipmentType.MANUAL_MISSILE then
		arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_MANUAL_MISSILE_FIRE, {})
	else
		arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_CHARGE_FIRE, {})
	end
end

function var4.InitialCD(arg0)
	var4.super.InitialCD(arg0)
	arg0._playerChargeWeaponVo:InitialDeduct(arg0)
	arg0._playerChargeWeaponVo:Charge(arg0)
end

function var4.EnterCoolDown(arg0)
	var4.super.EnterCoolDown(arg0)
	arg0._playerChargeWeaponVo:Charge(arg0)
end

function var4.OverHeat(arg0)
	var4.super.OverHeat(arg0)
	arg0._playerChargeWeaponVo:Deduct(arg0)
end

function var4.GetMinAngle(arg0)
	return arg0:GetAttackAngle()
end

function var4.GetLockList(arg0)
	return arg0._lockList
end

function var4.GetFilteredList(arg0)
	local var0 = var4.super.GetFilteredList(arg0)

	return (arg0:filterEnemyUnitType(var0))
end

function var4.filterEnemyUnitType(arg0, arg1)
	local var0 = {}
	local var1 = {}
	local var2 = -9999

	for iter0, iter1 in ipairs(arg1) do
		local var3 = iter1:GetTargetedPriority()

		if var3 == nil then
			var1[#var1 + 1] = iter1
		elseif var2 < var3 then
			var2 = var3
			var0 = {}
			var0[#var0 + 1] = iter1
		elseif var2 == var3 then
			var0[#var0 + 1] = iter1
		end
	end

	for iter2, iter3 in ipairs(var1) do
		var0[#var0 + 1] = iter3
	end

	return var0
end

function var4.handleCoolDown(arg0)
	arg0._currentState = arg0.STATE_READY

	arg0._playerChargeWeaponVo:Plus(arg0)
	arg0:DispatchEvent(var0.Event.New(var2.MANUAL_WEAPON_READY, {}))
	arg0:TriggerBuffOnReady()

	arg0._CDstartTime = nil
	arg0._reloadBoostList = {}
end

function var4.FlushReloadMax(arg0, arg1)
	if var4.super.FlushReloadMax(arg0, arg1) then
		return true
	end

	arg0._playerChargeWeaponVo:RefreshReloadingBar()
end

function var4.FlushReloadRequire(arg0)
	if var4.super.FlushReloadRequire(arg0) then
		return true
	end

	arg0._playerChargeWeaponVo:RefreshReloadingBar()
end

function var4.QuickCoolDown(arg0)
	if arg0._currentState == arg0.STATE_OVER_HEAT then
		arg0._currentState = arg0.STATE_READY

		arg0._playerChargeWeaponVo:InstantCoolDown(arg0)
		arg0:DispatchEvent(var0.Event.New(var2.MANUAL_WEAPON_INSTANT_READY, {}))

		arg0._CDstartTime = nil
		arg0._reloadBoostList = {}
	end
end

function var4.ReloadBoost(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0._reloadBoostList) do
		var0 = var0 + iter1
	end

	local var1 = var0 + arg1
	local var2 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._jammingTime - arg0._CDstartTime
	local var3

	if var1 < 0 then
		var3 = math.max(var1, (arg0._reloadRequire - var2) * -1)
	else
		var3 = math.min(var1, var2)
	end

	fixValue = var3 - var1 + arg1

	table.insert(arg0._reloadBoostList, fixValue)
end

function var4.AppendReloadBoost(arg0, arg1)
	if arg0._currentState == arg0.STATE_OVER_HEAT then
		arg0._playerChargeWeaponVo:ReloadBoost(arg0, arg1)
	end
end

function var4.IsStrikeMode(arg0)
	return arg0._strikeMode
end
