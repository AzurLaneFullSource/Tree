ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleUnitEvent
local var4_0 = var0_0.Battle.BattleDataFunction
local var5_0 = var0_0.Battle.BattleAttr

var0_0.Battle.BattleAllInStrike = class("BattleAllInStrike")

local var6_0 = var0_0.Battle.BattleAllInStrike

var6_0.__name = "BattleAllInStrike"
var6_0.EMITTER_NORMAL = "BattleBulletEmitter"
var6_0.EMITTER_SHOTGUN = "BattleShotgunEmitter"
var6_0.STATE_DISABLE = "DISABLE"
var6_0.STATE_READY = "READY"
var6_0.STATE_PRECAST = "PRECAST"
var6_0.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var6_0.STATE_ATTACK = "ATTACK"
var6_0.STATE_OVER_HEAT = "OVER_HEAT"

function var6_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._skill = var0_0.Battle.BattleSkillUnit.New(arg1_1)
	arg0_1._skillID = arg1_1
	arg0_1._reloadFacotrList = {}
	arg0_1._reloadBoostList = {}
	arg0_1._jammingTime = 0
end

function var6_0.Update(arg0_2)
	arg0_2:UpdateReload()
end

function var6_0.UpdateReload(arg0_3)
	if arg0_3._CDstartTime and not arg0_3._jammingStartTime then
		if arg0_3:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			arg0_3:handleCoolDown()
		else
			return
		end
	end
end

function var6_0.Clear(arg0_4)
	arg0_4._skill:Clear()
end

function var6_0.Dispose(arg0_5)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_5)
end

function var6_0.SetHost(arg0_6, arg1_6)
	arg0_6._host = arg1_6

	local var0_6

	arg0_6._hiveList = arg1_6:GetHiveList()

	for iter0_6, iter1_6 in ipairs(arg0_6._hiveList) do
		local var1_6 = iter1_6:GetSkinID()

		if var1_6 then
			local var2_6, var3_6, var4_6, var5_6 = var4_0.GetEquipSkin(var1_6)

			if var5_6 then
				var0_6 = var5_6

				break
			end
		end
	end

	if var0_6 then
		local var6_6 = arg0_6._skill:GetSkillEffectList()

		for iter2_6, iter3_6 in ipairs(var6_6) do
			if iter3_6.__name == var0_0.Battle.BattleSkillFire.__name then
				iter3_6:SetWeaponSkin(var0_6)
			end
		end
	end

	arg0_6:FlushTotalReload()
	arg0_6:FlushReloadMax(1)
end

function var6_0.FlushTotalReload(arg0_7)
	arg0_7._totalReload = var2_0.CaclulateAirAssistReloadMax(arg0_7._hiveList)
end

function var6_0.FlushReloadMax(arg0_8, arg1_8)
	local var0_8 = arg0_8._totalReload

	arg1_8 = arg1_8 or 1
	arg0_8._reloadMax = var0_8 * arg1_8

	if not arg0_8._CDstartTime or arg0_8._reloadRequire == 0 then
		return true
	end

	local var1_8 = var5_0.GetCurrent(arg0_8._host, "loadSpeed")

	arg0_8._reloadRequire = var0_0.Battle.BattleWeaponUnit.FlushRequireByInverse(arg0_8, var1_8)

	arg0_8._allInWeaponVo:RefreshReloadingBar()
end

function var6_0.AppendReloadFactor(arg0_9, arg1_9, arg2_9)
	arg0_9._reloadFacotrList[arg1_9] = arg2_9
end

function var6_0.RemoveReloadFactor(arg0_10, arg1_10)
	if arg0_10._reloadFacotrList[arg1_10] then
		arg0_10._reloadFacotrList[arg1_10] = nil
	end
end

function var6_0.GetReloadFactorList(arg0_11)
	return arg0_11._reloadFacotrList
end

function var6_0.SetAllInWeaponVO(arg0_12, arg1_12)
	arg0_12._allInWeaponVo = arg1_12
	arg0_12._currentState = var6_0.STATE_READY
end

function var6_0.GetCurrentState(arg0_13)
	return arg0_13._currentState
end

function var6_0.GetHost(arg0_14)
	return arg0_14._host
end

function var6_0.GetType(arg0_15)
	return var1_0.EquipmentType.AIR_ASSIST
end

function var6_0.Fire(arg0_16)
	if arg0_16._host:IsCease() then
		return false
	else
		arg0_16._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_ALL_IN_STRIKE_STEADY, {})

		for iter0_16, iter1_16 in ipairs(arg0_16._hiveList) do
			iter1_16:SingleFire()
		end

		arg0_16._skill:Cast(arg0_16._host)
		arg0_16._host:StrikeExpose()
		arg0_16._host:StateChange(var0_0.Battle.UnitState.STATE_ATTACK, "attack")
		arg0_16:DispatchEvent(var0_0.Event.New(var3_0.MANUAL_WEAPON_FIRE, {}))
		arg0_16._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_ALL_IN_STRIKE, {})
	end

	return true
end

function var6_0.TriggerBuffOnReady(arg0_17)
	arg0_17._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_AIR_ASSIST_READY, {})
end

function var6_0.SingleFire(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18._hiveList) do
		iter1_18:SingleFire()
	end

	arg0_18._skill:Cast(arg0_18._host)
	arg0_18._host:StrikeExpose()
	arg0_18._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_ALL_IN_STRIKE, {})
end

function var6_0.GetReloadTime(arg0_19)
	local var0_19 = var5_0.GetCurrent(arg0_19._host, "loadSpeed")

	if arg0_19._reloadMax ~= arg0_19._cacheReloadMax or var0_19 ~= arg0_19._cacheHostReload then
		arg0_19._cacheReloadMax = arg0_19._reloadMax
		arg0_19._cacheHostReload = var0_19
		arg0_19._cacheReloadTime = var2_0.CalculateReloadTime(arg0_19._reloadMax, var5_0.GetCurrent(arg0_19._host, "loadSpeed"))
	end

	return arg0_19._cacheReloadTime
end

function var6_0.GetReloadTimeByRate(arg0_20, arg1_20)
	local var0_20 = var5_0.GetCurrent(arg0_20._host, "loadSpeed")
	local var1_20 = arg0_20._cacheReloadMax * arg1_20

	return (var2_0.CalculateReloadTime(var1_20, var0_20))
end

function var6_0.SetModifyInitialCD(arg0_21)
	arg0_21._modInitCD = true
end

function var6_0.GetModifyInitialCD(arg0_22)
	return arg0_22._modInitCD
end

function var6_0.InitialCD(arg0_23)
	arg0_23:AddCDTimer(arg0_23:GetReloadTime())
	arg0_23._allInWeaponVo:InitialDeduct(arg0_23)
	arg0_23._allInWeaponVo:Charge(arg0_23)
end

function var6_0.EnterCoolDown(arg0_24)
	arg0_24:AddCDTimer(arg0_24:GetReloadTime())
	arg0_24._allInWeaponVo:Charge(arg0_24)
end

function var6_0.OverHeat(arg0_25)
	arg0_25._currentState = arg0_25.STATE_OVER_HEAT

	arg0_25._allInWeaponVo:Deduct(arg0_25)
end

function var6_0.AddCDTimer(arg0_26, arg1_26)
	arg0_26._currentState = var6_0.STATE_OVER_HEAT
	arg0_26._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_26._reloadRequire = arg1_26
end

function var6_0.GetCDStartTimeStamp(arg0_27)
	return arg0_27._CDstartTime
end

function var6_0.handleCoolDown(arg0_28)
	arg0_28._currentState = var6_0.STATE_READY

	arg0_28._allInWeaponVo:Plus(arg0_28)
	arg0_28:DispatchEvent(var0_0.Event.New(var3_0.MANUAL_WEAPON_READY, {}))
	arg0_28:TriggerBuffOnReady()

	arg0_28._CDstartTime = nil
	arg0_28._jammingTime = 0
	arg0_28._reloadBoostList = {}
end

function var6_0.FlushReloadRequire(arg0_29)
	if not arg0_29._CDstartTime or arg0_29._reloadRequire == 0 then
		return true
	end

	local var0_29 = var2_0.CaclulateReloadAttr(arg0_29._reloadMax, arg0_29._reloadRequire)

	arg0_29._reloadRequire = var0_0.Battle.BattleWeaponUnit.FlushRequireByInverse(arg0_29, var0_29)

	arg0_29._allInWeaponVo:RefreshReloadingBar()
end

function var6_0.QuickCoolDown(arg0_30)
	if arg0_30._currentState == arg0_30.STATE_OVER_HEAT then
		arg0_30._currentState = var6_0.STATE_READY

		arg0_30._allInWeaponVo:InstantCoolDown(arg0_30)
		arg0_30:DispatchEvent(var0_0.Event.New(var3_0.MANUAL_WEAPON_INSTANT_READY, {}))

		arg0_30._CDstartTime = nil
		arg0_30._reloadBoostList = {}
	end
end

function var6_0.ReloadBoost(arg0_31, arg1_31)
	local var0_31 = 0

	for iter0_31, iter1_31 in ipairs(arg0_31._reloadBoostList) do
		var0_31 = var0_31 + iter1_31
	end

	local var1_31 = var0_31 + arg1_31
	local var2_31 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_31._jammingTime - arg0_31._CDstartTime
	local var3_31

	if var1_31 < 0 then
		var3_31 = math.max(var1_31, (arg0_31._reloadRequire - var2_31) * -1)
	else
		var3_31 = math.min(var1_31, var2_31)
	end

	fixValue = var3_31 - var1_31 + arg1_31

	table.insert(arg0_31._reloadBoostList, fixValue)
end

function var6_0.AppendReloadBoost(arg0_32, arg1_32)
	if arg0_32._currentState == arg0_32.STATE_OVER_HEAT then
		arg0_32._allInWeaponVo:ReloadBoost(arg0_32, arg1_32)
	end
end

function var6_0.GetReloadFinishTimeStamp(arg0_33)
	local var0_33 = 0

	for iter0_33, iter1_33 in ipairs(arg0_33._reloadBoostList) do
		var0_33 = var0_33 + iter1_33
	end

	return arg0_33._reloadRequire + arg0_33._CDstartTime + arg0_33._jammingTime + var0_33
end

function var6_0.StartJamming(arg0_34)
	arg0_34._jammingStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var6_0.JammingEliminate(arg0_35)
	if not arg0_35._jammingStartTime then
		return
	end

	arg0_35._jammingTime = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_35._jammingStartTime
	arg0_35._jammingStartTime = nil
end

function var6_0.CLSBullet(arg0_36)
	local var0_36 = arg0_36._host:GetIFF() * -1

	var0_0.Battle.BattleDataProxy.GetInstance():CLSBullet(var0_36, true)
end

function var6_0.DispatchBlink(arg0_37, arg1_37)
	local var0_37 = {
		callbackFunc = arg1_37,
		timeScale = var0_0.Battle.BattleConfig.FOCUS_MAP_RATE
	}
	local var1_37 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CHARGE_WEAPON_FINISH, var0_37)

	arg0_37:DispatchEvent(var1_37)
end

function var6_0.GetReloadRate(arg0_38)
	if arg0_38._currentState == arg0_38.STATE_READY then
		return 0
	elseif arg0_38._CDstartTime then
		return (arg0_38:GetReloadFinishTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()) / arg0_38._reloadRequire
	else
		return 1
	end
end

function var6_0.GetDamageSUM(arg0_39)
	local var0_39 = 0
	local var1_39 = 0

	for iter0_39, iter1_39 in ipairs(arg0_39._hiveList) do
		for iter2_39, iter3_39 in ipairs(iter1_39:GetATKAircraftList()) do
			local var2_39 = iter3_39:GetWeapon()

			for iter4_39, iter5_39 in ipairs(var2_39) do
				var0_39 = var0_39 + iter5_39:GetDamageSUM()
			end
		end
	end

	local var3_39 = arg0_39._skill:GetSkillEffectList()

	for iter6_39, iter7_39 in ipairs(var3_39) do
		local var4_39 = iter7_39:GetDamageSum()

		if var4_39 then
			var1_39 = var1_39 + var4_39
		end
	end

	return var0_39, var1_39
end

function var6_0.GetStrikeSkillID(arg0_40)
	return arg0_40._skillID
end
