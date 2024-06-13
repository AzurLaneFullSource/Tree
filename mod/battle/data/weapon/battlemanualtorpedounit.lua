ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = class("BattleManualTorpedoUnit", var0.Battle.BattleTorpedoUnit)

var0.Battle.BattleManualTorpedoUnit = var2
var2.__name = "BattleManualTorpedoUnit"

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.createMajorEmitter(arg0, arg1, arg2)
	local function var0(arg0, arg1, arg2, arg3)
		local var0 = arg0._emitBulletIDList[arg2]
		local var1 = arg0:Spawn(var0, nil, var2.INTERNAL)

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)
		var1:SetRotateInfo(nil, arg0._botAutoAimAngle, arg2)
		arg0:DispatchBulletEvent(var1)

		return var1
	end

	local function var1()
		return
	end

	var2.super.createMajorEmitter(arg0, arg1, arg2, nil, var0, var1)
end

function var2.Update(arg0)
	arg0:UpdateReload()
end

function var2.SetPlayerTorpedoWeaponVO(arg0, arg1)
	arg0._playerTorpedoVO = arg1
end

function var2.TriggerBuffOnReady(arg0)
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_MANUAL_TORPEDO_READY, {})
end

function var2.Fire(arg0, arg1)
	if arg1 then
		arg0:updateMovementInfo()

		local var0 = var0.Battle.BattleTargetChoise.TargetHarmRandomByWeight(arg0._host, nil, arg0:GetFilteredList())[1]

		if var0 then
			local var1 = var0:GetPosition()
			local var2 = arg0._host:GetPosition()

			arg0._botAutoAimAngle = math.rad2Deg * math.atan2(var1.z - var2.z, var1.x - var2.x)
		else
			arg0._botAutoAimAngle = arg0:GetBaseAngle()
		end
	else
		arg0._botAutoAimAngle = arg0:GetBaseAngle()
	end

	return var2.super.Fire(arg0)
end

function var2.DoAttack(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.TORPEDO_WEAPON_FIRE, {}))
	var2.super.DoAttack(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.MANUAL_WEAPON_FIRE, {}))
end

function var2.InitialCD(arg0)
	var2.super.InitialCD(arg0)
	arg0._playerTorpedoVO:InitialDeduct(arg0)
	arg0._playerTorpedoVO:Charge(arg0)
end

function var2.EnterCoolDown(arg0)
	var2.super.EnterCoolDown(arg0)
	arg0._playerTorpedoVO:Charge(arg0)
end

function var2.OverHeat(arg0)
	var2.super.OverHeat(arg0)
	arg0._playerTorpedoVO:Deduct(arg0)
end

function var2.Cease(arg0)
	if arg0._currentState == var2.STATE_OVER_HEAT then
		arg0:interruptAllEmitter()
	end
end

function var2.handleCoolDown(arg0)
	arg0._currentState = arg0.STATE_READY

	arg0._playerTorpedoVO:Plus(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.TORPEDO_WEAPON_READY, {}))
	arg0:DispatchEvent(var0.Event.New(var1.MANUAL_WEAPON_READY, {}))
	arg0:TriggerBuffOnReady()

	arg0._CDstartTime = nil
	arg0._reloadBoostList = {}
end

function var2.FlushReloadMax(arg0, arg1)
	if var2.super.FlushReloadMax(arg0, arg1) then
		return true
	end

	arg0._playerTorpedoVO:RefreshReloadingBar()
end

function var2.FlushReloadRequire(arg0)
	if var2.super.FlushReloadRequire(arg0) then
		return true
	end

	arg0._playerTorpedoVO:RefreshReloadingBar()
end

function var2.QuickCoolDown(arg0)
	if arg0._currentState == arg0.STATE_OVER_HEAT then
		arg0._currentState = arg0.STATE_READY

		arg0._playerTorpedoVO:InstantCoolDown(arg0)
		arg0:DispatchEvent(var0.Event.New(var1.MANUAL_WEAPON_INSTANT_READY, {}))

		arg0._CDstartTime = nil
		arg0._reloadBoostList = {}
	end
end

function var2.Prepar(arg0)
	if arg0._host:IsCease() then
		return false
	else
		arg0._currentState = arg0.STATE_PRECAST

		local var0 = {}
		local var1 = var0.Event.New(var1.TORPEDO_WEAPON_PREPAR, var0)

		arg0:DispatchEvent(var1)

		return true
	end
end

function var2.Cancel(arg0)
	arg0._currentState = arg0.STATE_READY

	local var0 = var0.Event.New(var1.TORPEDO_WEAPON_CANCEL, {})

	arg0:DispatchEvent(var0)
end

function var2.ReloadBoost(arg0, arg1)
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

function var2.AppendReloadBoost(arg0, arg1)
	if arg0._currentState == arg0.STATE_OVER_HEAT then
		arg0._playerTorpedoVO:ReloadBoost(arg0, arg1)
	end
end
