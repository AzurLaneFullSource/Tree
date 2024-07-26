ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = class("BattleSubmarineRunCommand", var0_0.Battle.BattleSingleDungeonCommand)

var0_0.Battle.BattleSubmarineRunCommand = var4_0
var4_0.__name = "BattleSubmarineRunCommand"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.Initialize(arg0_2)
	var4_0.super.Initialize(arg0_2)
	arg0_2._dataProxy:SubmarineRunInit()
end

function var4_0.DoPrologue(arg0_3)
	pg.UIMgr.GetInstance():Marching()

	local function var0_3()
		arg0_3._uiMediator:OpeningEffect(function()
			arg0_3._uiMediator:ShowTimer()
			arg0_3._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_3._waveUpdater:Start()
		end, SYSTEM_SUBMARINE_RUN)

		local var0_4 = arg0_3._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)

		var0_4:FleetWarcry()
		var0_4:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_DIVE)
		var0_4:GetSubBoostVO():ResetCurrent()
		arg0_3._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_3._dataProxy:TirggerBattleStartBuffs()
	end

	arg0_3._dataProxy:AutoStatistics(0)

	local var1_3 = arg0_3._userFleet:GetUnitList()

	for iter0_3, iter1_3 in ipairs(var1_3) do
		iter1_3:RemoveBuff(8520)
	end

	arg0_3._uiMediator:SeaSurfaceShift(45, 0, nil, var0_3)
end

function var4_0.onInitBattle(arg0_6)
	var4_0.super.onInitBattle(arg0_6)
	arg0_6._userFleet:RegisterEventListener(arg0_6, var2_0.MANUAL_SUBMARINE_SHIFT, arg0_6.onSubmarineShift)
end

function var4_0.initWaveModule(arg0_7)
	local function var0_7(arg0_8, arg1_8, arg2_8)
		arg0_7._dataProxy:SpawnMonster(arg0_8, arg1_8, arg2_8, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_7()
		if arg0_7._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_7._vertifyFail
			})

			return
		end

		arg0_7._dataProxy:CalcSubRunScore()
		arg0_7._state:BattleEnd()
	end

	arg0_7._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_7, nil, var1_7, nil)
end

function var4_0.onUpdateCountDown(arg0_10, arg1_10)
	if arg0_10._dataProxy:GetCountDown() <= 0 then
		arg0_10._dataProxy:EnemyEscape()
		arg0_10._dataProxy:CalcSubRunTimeUp()
		arg0_10._state:BattleTimeUp()
	end
end

function var4_0.RemoveEvent(arg0_11)
	arg0_11._userFleet:UnregisterEventListener(arg0_11, var2_0.MANUAL_SUBMARINE_SHIFT)
	var4_0.super.RemoveEvent(arg0_11)
end

function var4_0.UnregisterUnitEvent(arg0_12, arg1_12)
	var4_0.super.UnregisterUnitEvent(arg0_12, arg1_12)
	arg1_12:UnregisterEventListener(arg0_12, var1_0.ANTI_SUB_VIGILANCE_HATE_CHAIN)
end

function var4_0.onAddUnit(arg0_13, arg1_13)
	var4_0.super.onAddUnit(arg0_13, arg1_13)

	local var0_13 = arg1_13.Data.type
	local var1_13 = arg1_13.Data.unit

	if var0_13 ~= var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		var1_13:RegisterEventListener(arg0_13, var1_0.ANTI_SUB_VIGILANCE_HATE_CHAIN, arg0_13.onHateChain)
	end
end

function var4_0.onHateChain(arg0_14, arg1_14)
	for iter0_14, iter1_14 in pairs(arg0_14._unitDataList) do
		iter1_14:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_ANTI_SUB_HATE_CHAIN)
	end
end

function var4_0.onWillDie(arg0_15, arg1_15)
	local var0_15 = arg1_15.Dispatcher
	local var1_15 = var0_15:GetDeathReason()

	if var0_15:GetIFF() == var0_0.Battle.BattleConfig.FRIENDLY_CODE then
		arg0_15._dataProxy:DelScoreWhenPlayerDead(var0_15)
	end

	if var1_15 == var0_0.Battle.BattleConst.UnitDeathReason.KILLED or var1_15 == var0_0.Battle.BattleConst.UnitDeathReason.DESTRUCT then
		for iter0_15, iter1_15 in pairs(arg0_15._unitDataList) do
			iter1_15:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_FRIENDLY_SHIP_DYING, {
				unit = iter1_15
			})
		end
	end

	if var0_15:GetTemplate().type == ShipType.JinBi and var1_15 == var0_0.Battle.BattleConst.UnitDeathReason.KILLED then
		arg0_15._dataProxy:CalcKillingSupplyShip()
	end

	local var2_15 = arg0_15._dataProxy:IsThereBoss()

	if var0_15:IsBoss() and not var2_15 then
		if var1_15 == var0_0.Battle.BattleConst.UnitDeathReason.DESTRUCT then
			arg0_15._dataProxy:AddScoreWhenBossDestruct()
		end

		arg0_15._dataProxy:KillAllEnemy()
	end
end

function var4_0.onSubmarineShift(arg0_16, arg1_16)
	local var0_16 = arg1_16.Data.state
	local var1_16

	if var0_16 == var0_0.Battle.OxyState.STATE_FREE_DIVE then
		var1_16 = var0_0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_DIVE
	elseif var0_16 == var0_0.Battle.OxyState.STATE_FREE_FLOAT then
		var1_16 = var0_0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_FLOAT
	end

	for iter0_16, iter1_16 in pairs(arg0_16._unitDataList) do
		iter1_16:TriggerBuff(var1_16)
	end
end

function var4_0.onShutDownPlayer(arg0_17)
	arg0_17._dataProxy:CalcSubRunDead()
	arg0_17._state:BattleEnd()
end
