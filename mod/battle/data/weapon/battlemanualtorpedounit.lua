ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = class("BattleManualTorpedoUnit", var0_0.Battle.BattleTorpedoUnit)

var0_0.Battle.BattleManualTorpedoUnit = var2_0
var2_0.__name = "BattleManualTorpedoUnit"

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.createMajorEmitter(arg0_2, arg1_2, arg2_2)
	local function var0_2(arg0_3, arg1_3, arg2_3, arg3_3)
		local var0_3 = arg0_2._emitBulletIDList[arg2_2]
		local var1_3 = arg0_2:Spawn(var0_3, nil, var2_0.INTERNAL)

		var1_3:SetOffsetPriority(arg3_3)
		var1_3:SetShiftInfo(arg0_3, arg1_3)
		var1_3:SetRotateInfo(nil, arg0_2._botAutoAimAngle, arg2_3)
		arg0_2:DispatchBulletEvent(var1_3)

		return var1_3
	end

	local function var1_2()
		return
	end

	var2_0.super.createMajorEmitter(arg0_2, arg1_2, arg2_2, nil, var0_2, var1_2)
end

function var2_0.Update(arg0_5)
	arg0_5:UpdateReload()
end

function var2_0.SetPlayerTorpedoWeaponVO(arg0_6, arg1_6)
	arg0_6._playerTorpedoVO = arg1_6
end

function var2_0.TriggerBuffOnReady(arg0_7)
	arg0_7._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_MANUAL_TORPEDO_READY, {})
end

function var2_0.Fire(arg0_8, arg1_8)
	if arg1_8 then
		arg0_8:updateMovementInfo()

		local var0_8 = var0_0.Battle.BattleTargetChoise.TargetHarmRandomByWeight(arg0_8._host, nil, arg0_8:GetFilteredList())[1]

		if var0_8 then
			local var1_8 = var0_8:GetPosition()
			local var2_8 = arg0_8._host:GetPosition()

			arg0_8._botAutoAimAngle = math.rad2Deg * math.atan2(var1_8.z - var2_8.z, var1_8.x - var2_8.x)
		else
			arg0_8._botAutoAimAngle = arg0_8:GetBaseAngle()
		end
	else
		arg0_8._botAutoAimAngle = arg0_8:GetBaseAngle()
	end

	return var2_0.super.Fire(arg0_8)
end

function var2_0.DoAttack(arg0_9)
	arg0_9:DispatchEvent(var0_0.Event.New(var1_0.TORPEDO_WEAPON_FIRE, {}))
	var2_0.super.DoAttack(arg0_9)
	arg0_9:DispatchEvent(var0_0.Event.New(var1_0.MANUAL_WEAPON_FIRE, {}))
end

function var2_0.InitialCD(arg0_10)
	var2_0.super.InitialCD(arg0_10)
	arg0_10._playerTorpedoVO:InitialDeduct(arg0_10)
	arg0_10._playerTorpedoVO:Charge(arg0_10)
end

function var2_0.EnterCoolDown(arg0_11)
	var2_0.super.EnterCoolDown(arg0_11)
	arg0_11._playerTorpedoVO:Charge(arg0_11)
end

function var2_0.OverHeat(arg0_12)
	var2_0.super.OverHeat(arg0_12)
	arg0_12._playerTorpedoVO:Deduct(arg0_12)
end

function var2_0.Cease(arg0_13)
	if arg0_13._currentState == var2_0.STATE_OVER_HEAT then
		arg0_13:interruptAllEmitter()
	end
end

function var2_0.handleCoolDown(arg0_14)
	arg0_14._currentState = arg0_14.STATE_READY

	arg0_14._playerTorpedoVO:Plus(arg0_14)
	arg0_14:DispatchEvent(var0_0.Event.New(var1_0.TORPEDO_WEAPON_READY, {}))
	arg0_14:DispatchEvent(var0_0.Event.New(var1_0.MANUAL_WEAPON_READY, {}))
	arg0_14:TriggerBuffOnReady()

	arg0_14._CDstartTime = nil
	arg0_14._reloadBoostList = {}
end

function var2_0.FlushReloadMax(arg0_15, arg1_15)
	if var2_0.super.FlushReloadMax(arg0_15, arg1_15) then
		return true
	end

	arg0_15._playerTorpedoVO:RefreshReloadingBar()
end

function var2_0.FlushReloadRequire(arg0_16)
	if var2_0.super.FlushReloadRequire(arg0_16) then
		return true
	end

	arg0_16._playerTorpedoVO:RefreshReloadingBar()
end

function var2_0.QuickCoolDown(arg0_17)
	if arg0_17._currentState == arg0_17.STATE_OVER_HEAT then
		arg0_17._currentState = arg0_17.STATE_READY

		arg0_17._playerTorpedoVO:InstantCoolDown(arg0_17)
		arg0_17:DispatchEvent(var0_0.Event.New(var1_0.MANUAL_WEAPON_INSTANT_READY, {}))

		arg0_17._CDstartTime = nil
		arg0_17._reloadBoostList = {}
	end
end

function var2_0.Prepar(arg0_18)
	if arg0_18._host:IsCease() then
		return false
	else
		arg0_18._currentState = arg0_18.STATE_PRECAST

		local var0_18 = {}
		local var1_18 = var0_0.Event.New(var1_0.TORPEDO_WEAPON_PREPAR, var0_18)

		arg0_18:DispatchEvent(var1_18)

		return true
	end
end

function var2_0.Cancel(arg0_19)
	arg0_19._currentState = arg0_19.STATE_READY

	local var0_19 = var0_0.Event.New(var1_0.TORPEDO_WEAPON_CANCEL, {})

	arg0_19:DispatchEvent(var0_19)
end

function var2_0.ReloadBoost(arg0_20, arg1_20)
	local var0_20 = 0

	for iter0_20, iter1_20 in ipairs(arg0_20._reloadBoostList) do
		var0_20 = var0_20 + iter1_20
	end

	local var1_20 = var0_20 + arg1_20
	local var2_20 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_20._jammingTime - arg0_20._CDstartTime
	local var3_20

	if var1_20 < 0 then
		var3_20 = math.max(var1_20, (arg0_20._reloadRequire - var2_20) * -1)
	else
		var3_20 = math.min(var1_20, var2_20)
	end

	fixValue = var3_20 - var1_20 + arg1_20

	table.insert(arg0_20._reloadBoostList, fixValue)
end

function var2_0.AppendReloadBoost(arg0_21, arg1_21)
	if arg0_21._currentState == arg0_21.STATE_OVER_HEAT then
		arg0_21._playerTorpedoVO:ReloadBoost(arg0_21, arg1_21)
	end
end
