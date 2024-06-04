ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleConst
local var4 = class("BattleSubmarineRunCommand", var0.Battle.BattleSingleDungeonCommand)

var0.Battle.BattleSubmarineRunCommand = var4
var4.__name = "BattleSubmarineRunCommand"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.Initialize(arg0)
	var4.super.Initialize(arg0)
	arg0._dataProxy:SubmarineRunInit()
end

function var4.DoPrologue(arg0)
	pg.UIMgr.GetInstance():Marching()

	local var0 = function()
		arg0._uiMediator:OpeningEffect(function()
			arg0._uiMediator:ShowTimer()
			arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0._waveUpdater:Start()
		end, SYSTEM_SUBMARINE_RUN)

		local var0 = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)

		var0:FleetWarcry()
		var0:ChangeSubmarineState(var0.Battle.OxyState.STATE_FREE_DIVE)
		var0:GetSubBoostVO():ResetCurrent()
		arg0._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0._dataProxy:TirggerBattleStartBuffs()
	end
	local var1 = arg0._userFleet:GetUnitList()

	for iter0, iter1 in ipairs(var1) do
		iter1:RemoveBuff(8520)
	end

	arg0._uiMediator:SeaSurfaceShift(45, 0, nil, var0)
end

function var4.onInitBattle(arg0)
	var4.super.onInitBattle(arg0)
	arg0._userFleet:RegisterEventListener(arg0, var2.MANUAL_SUBMARINE_SHIFT, arg0.onSubmarineShift)
end

function var4.initWaveModule(arg0)
	local var0 = function(arg0, arg1, arg2)
		arg0._dataProxy:SpawnMonster(arg0, arg1, arg2, var0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1()
		if arg0._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0._vertifyFail
			})

			return
		end

		arg0._dataProxy:CalcSubRunScore()
		arg0._state:BattleEnd()
	end

	arg0._waveUpdater = var0.Battle.BattleWaveUpdater.New(var0, nil, var1, nil)
end

function var4.onUpdateCountDown(arg0, arg1)
	if arg0._dataProxy:GetCountDown() <= 0 then
		arg0._dataProxy:EnemyEscape()
		arg0._dataProxy:CalcSubRunTimeUp()
		arg0._state:BattleTimeUp()
	end
end

function var4.RemoveEvent(arg0)
	arg0._userFleet:UnregisterEventListener(arg0, var2.MANUAL_SUBMARINE_SHIFT)
	var4.super.RemoveEvent(arg0)
end

function var4.UnregisterUnitEvent(arg0, arg1)
	var4.super.UnregisterUnitEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var1.ANTI_SUB_VIGILANCE_HATE_CHAIN)
end

function var4.onAddUnit(arg0, arg1)
	var4.super.onAddUnit(arg0, arg1)

	local var0 = arg1.Data.type
	local var1 = arg1.Data.unit

	if var0 ~= var0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		var1:RegisterEventListener(arg0, var1.ANTI_SUB_VIGILANCE_HATE_CHAIN, arg0.onHateChain)
	end
end

function var4.onHateChain(arg0, arg1)
	for iter0, iter1 in pairs(arg0._unitDataList) do
		iter1:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_ANTI_SUB_HATE_CHAIN)
	end
end

function var4.onWillDie(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = var0:GetDeathReason()

	if var0:GetIFF() == var0.Battle.BattleConfig.FRIENDLY_CODE then
		arg0._dataProxy:DelScoreWhenPlayerDead(var0)
	end

	if var1 == var0.Battle.BattleConst.UnitDeathReason.KILLED or var1 == var0.Battle.BattleConst.UnitDeathReason.DESTRUCT then
		for iter0, iter1 in pairs(arg0._unitDataList) do
			iter1:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_FRIENDLY_SHIP_DYING, {
				unit = iter1
			})
		end
	end

	if var0:GetTemplate().type == ShipType.JinBi and var1 == var0.Battle.BattleConst.UnitDeathReason.KILLED then
		arg0._dataProxy:CalcKillingSupplyShip()
	end

	local var2 = arg0._dataProxy:IsThereBoss()

	if var0:IsBoss() and not var2 then
		if var1 == var0.Battle.BattleConst.UnitDeathReason.DESTRUCT then
			arg0._dataProxy:AddScoreWhenBossDestruct()
		end

		arg0._dataProxy:KillAllEnemy()
	end
end

function var4.onSubmarineShift(arg0, arg1)
	local var0 = arg1.Data.state
	local var1

	if var0 == var0.Battle.OxyState.STATE_FREE_DIVE then
		var1 = var0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_DIVE
	elseif var0 == var0.Battle.OxyState.STATE_FREE_FLOAT then
		var1 = var0.Battle.BattleConst.BuffEffectType.ON_SUBMARINE_FREE_FLOAT
	end

	for iter0, iter1 in pairs(arg0._unitDataList) do
		iter1:TriggerBuff(var1)
	end
end

function var4.onShutDownPlayer(arg0)
	arg0._dataProxy:CalcSubRunDead()
	arg0._state:BattleEnd()
end
