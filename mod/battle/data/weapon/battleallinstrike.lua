ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleUnitEvent
local var4 = var0.Battle.BattleDataFunction
local var5 = var0.Battle.BattleAttr

var0.Battle.BattleAllInStrike = class("BattleAllInStrike")

local var6 = var0.Battle.BattleAllInStrike

var6.__name = "BattleAllInStrike"
var6.EMITTER_NORMAL = "BattleBulletEmitter"
var6.EMITTER_SHOTGUN = "BattleShotgunEmitter"
var6.STATE_DISABLE = "DISABLE"
var6.STATE_READY = "READY"
var6.STATE_PRECAST = "PRECAST"
var6.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
var6.STATE_ATTACK = "ATTACK"
var6.STATE_OVER_HEAT = "OVER_HEAT"

function var6.Ctor(arg0, arg1)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._skill = var0.Battle.BattleSkillUnit.New(arg1)
	arg0._skillID = arg1
	arg0._reloadFacotrList = {}
	arg0._reloadBoostList = {}
	arg0._jammingTime = 0
end

function var6.Update(arg0)
	arg0:UpdateReload()
end

function var6.UpdateReload(arg0)
	if arg0._CDstartTime and not arg0._jammingStartTime then
		if arg0:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			arg0:handleCoolDown()
		else
			return
		end
	end
end

function var6.Clear(arg0)
	arg0._skill:Clear()
end

function var6.Dispose(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var6.SetHost(arg0, arg1)
	arg0._host = arg1

	local var0

	arg0._hiveList = arg1:GetHiveList()

	for iter0, iter1 in ipairs(arg0._hiveList) do
		local var1 = iter1:GetSkinID()

		if var1 then
			local var2, var3, var4, var5 = var4.GetEquipSkin(var1)

			if var5 then
				var0 = var5

				break
			end
		end
	end

	if var0 then
		local var6 = arg0._skill:GetSkillEffectList()

		for iter2, iter3 in ipairs(var6) do
			if iter3.__name == var0.Battle.BattleSkillFire.__name then
				iter3:SetWeaponSkin(var0)
			end
		end
	end

	arg0:FlushTotalReload()
	arg0:FlushReloadMax(1)
end

function var6.FlushTotalReload(arg0)
	arg0._totalReload = var2.CaclulateAirAssistReloadMax(arg0._hiveList)
end

function var6.FlushReloadMax(arg0, arg1)
	local var0 = arg0._totalReload

	arg1 = arg1 or 1
	arg0._reloadMax = var0 * arg1

	if not arg0._CDstartTime or arg0._reloadRequire == 0 then
		return true
	end

	local var1 = var5.GetCurrent(arg0._host, "loadSpeed")

	arg0._reloadRequire = var0.Battle.BattleWeaponUnit.FlushRequireByInverse(arg0, var1)

	arg0._allInWeaponVo:RefreshReloadingBar()
end

function var6.AppendReloadFactor(arg0, arg1, arg2)
	arg0._reloadFacotrList[arg1] = arg2
end

function var6.RemoveReloadFactor(arg0, arg1)
	if arg0._reloadFacotrList[arg1] then
		arg0._reloadFacotrList[arg1] = nil
	end
end

function var6.GetReloadFactorList(arg0)
	return arg0._reloadFacotrList
end

function var6.SetAllInWeaponVO(arg0, arg1)
	arg0._allInWeaponVo = arg1
	arg0._currentState = var6.STATE_READY
end

function var6.GetCurrentState(arg0)
	return arg0._currentState
end

function var6.GetHost(arg0)
	return arg0._host
end

function var6.GetType(arg0)
	return var1.EquipmentType.AIR_ASSIST
end

function var6.Fire(arg0)
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_ALL_IN_STRIKE_STEADY, {})

	for iter0, iter1 in ipairs(arg0._hiveList) do
		iter1:SingleFire()
	end

	arg0._skill:Cast(arg0._host)
	arg0._host:StrikeExpose()
	arg0._host:StateChange(var0.Battle.UnitState.STATE_ATTACK, "attack")
	arg0:DispatchEvent(var0.Event.New(var3.MANUAL_WEAPON_FIRE, {}))
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_ALL_IN_STRIKE, {})
end

function var6.TriggerBuffOnReady(arg0)
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_AIR_ASSIST_READY, {})
end

function var6.SingleFire(arg0)
	for iter0, iter1 in ipairs(arg0._hiveList) do
		iter1:SingleFire()
	end

	arg0._skill:Cast(arg0._host)
	arg0._host:StrikeExpose()
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_ALL_IN_STRIKE, {})
end

function var6.GetReloadTime(arg0)
	local var0 = var5.GetCurrent(arg0._host, "loadSpeed")

	if arg0._reloadMax ~= arg0._cacheReloadMax or var0 ~= arg0._cacheHostReload then
		arg0._cacheReloadMax = arg0._reloadMax
		arg0._cacheHostReload = var0
		arg0._cacheReloadTime = var2.CalculateReloadTime(arg0._reloadMax, var5.GetCurrent(arg0._host, "loadSpeed"))
	end

	return arg0._cacheReloadTime
end

function var6.GetReloadTimeByRate(arg0, arg1)
	local var0 = var5.GetCurrent(arg0._host, "loadSpeed")
	local var1 = arg0._cacheReloadMax * arg1

	return (var2.CalculateReloadTime(var1, var0))
end

function var6.SetModifyInitialCD(arg0)
	arg0._modInitCD = true
end

function var6.GetModifyInitialCD(arg0)
	return arg0._modInitCD
end

function var6.InitialCD(arg0)
	arg0:AddCDTimer(arg0:GetReloadTime())
	arg0._allInWeaponVo:InitialDeduct(arg0)
	arg0._allInWeaponVo:Charge(arg0)
end

function var6.EnterCoolDown(arg0)
	arg0:AddCDTimer(arg0:GetReloadTime())
	arg0._allInWeaponVo:Charge(arg0)
end

function var6.OverHeat(arg0)
	arg0._currentState = arg0.STATE_OVER_HEAT

	arg0._allInWeaponVo:Deduct(arg0)
end

function var6.AddCDTimer(arg0, arg1)
	arg0._currentState = var6.STATE_OVER_HEAT
	arg0._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0._reloadRequire = arg1
end

function var6.GetCDStartTimeStamp(arg0)
	return arg0._CDstartTime
end

function var6.handleCoolDown(arg0)
	arg0._currentState = var6.STATE_READY

	arg0._allInWeaponVo:Plus(arg0)
	arg0:DispatchEvent(var0.Event.New(var3.MANUAL_WEAPON_READY, {}))
	arg0:TriggerBuffOnReady()

	arg0._CDstartTime = nil
	arg0._jammingTime = 0
	arg0._reloadBoostList = {}
end

function var6.FlushReloadRequire(arg0)
	if not arg0._CDstartTime or arg0._reloadRequire == 0 then
		return true
	end

	local var0 = var2.CaclulateReloadAttr(arg0._reloadMax, arg0._reloadRequire)

	arg0._reloadRequire = var0.Battle.BattleWeaponUnit.FlushRequireByInverse(arg0, var0)

	arg0._allInWeaponVo:RefreshReloadingBar()
end

function var6.QuickCoolDown(arg0)
	if arg0._currentState == arg0.STATE_OVER_HEAT then
		arg0._currentState = var6.STATE_READY

		arg0._allInWeaponVo:InstantCoolDown(arg0)
		arg0:DispatchEvent(var0.Event.New(var3.MANUAL_WEAPON_INSTANT_READY, {}))

		arg0._CDstartTime = nil
		arg0._reloadBoostList = {}
	end
end

function var6.ReloadBoost(arg0, arg1)
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

function var6.AppendReloadBoost(arg0, arg1)
	if arg0._currentState == arg0.STATE_OVER_HEAT then
		arg0._allInWeaponVo:ReloadBoost(arg0, arg1)
	end
end

function var6.GetReloadFinishTimeStamp(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0._reloadBoostList) do
		var0 = var0 + iter1
	end

	return arg0._reloadRequire + arg0._CDstartTime + arg0._jammingTime + var0
end

function var6.StartJamming(arg0)
	arg0._jammingStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var6.JammingEliminate(arg0)
	if not arg0._jammingStartTime then
		return
	end

	arg0._jammingTime = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._jammingStartTime
	arg0._jammingStartTime = nil
end

function var6.CLSBullet(arg0)
	local var0 = arg0._host:GetIFF() * -1

	var0.Battle.BattleDataProxy.GetInstance():CLSBullet(var0, true)
end

function var6.DispatchBlink(arg0, arg1)
	local var0 = {
		callbackFunc = arg1,
		timeScale = var0.Battle.BattleConfig.FOCUS_MAP_RATE
	}
	local var1 = var0.Event.New(var0.Battle.BattleUnitEvent.CHARGE_WEAPON_FINISH, var0)

	arg0:DispatchEvent(var1)
end

function var6.GetReloadRate(arg0)
	if arg0._currentState == arg0.STATE_READY then
		return 0
	elseif arg0._CDstartTime then
		return (arg0:GetReloadFinishTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()) / arg0._reloadRequire
	else
		return 1
	end
end

function var6.GetDamageSUM(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in ipairs(arg0._hiveList) do
		for iter2, iter3 in ipairs(iter1:GetATKAircraftList()) do
			local var2 = iter3:GetWeapon()

			for iter4, iter5 in ipairs(var2) do
				var0 = var0 + iter5:GetDamageSUM()
			end
		end
	end

	local var3 = arg0._skill:GetSkillEffectList()

	for iter6, iter7 in ipairs(var3) do
		local var4 = iter7:GetDamageSum()

		if var4 then
			var1 = var1 + var4
		end
	end

	return var0, var1
end

function var6.GetStrikeSkillID(arg0)
	return arg0._skillID
end
