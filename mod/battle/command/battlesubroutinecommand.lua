ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = class("BattleSubRoutineCommand", var0_0.Battle.BattleSubmarineRunCommand)

var0_0.Battle.BattleSubRoutineCommand = var4_0
var4_0.__name = "BattleSubRoutineCommand"

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
		end, SYSTEM_SUB_ROUTINE)

		local var0_4 = arg0_3._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)

		var0_4:FleetWarcry()
		var0_4:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_DIVE)
		var0_4:GetSubBoostVO():ResetCurrent()
		arg0_3._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_3._dataProxy:TirggerBattleStartBuffs()
	end

	local var1_3 = arg0_3._userFleet:GetUnitList()

	for iter0_3, iter1_3 in ipairs(var1_3) do
		local var2_3 = var0_0.Battle.BattleBuffUnit.New(9040)

		iter1_3:AddBuff(var2_3)
		iter1_3:RemoveBuff(8520)
	end

	arg0_3._uiMediator:SeaSurfaceShift(45, 0, nil, var0_3)
end

function var4_0.initWaveModule(arg0_6)
	local function var0_6(arg0_7, arg1_7, arg2_7)
		arg0_6._dataProxy:SpawnMonster(arg0_7, arg1_7, arg2_7, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_6()
		if arg0_6._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_6._vertifyFail
			})

			return
		end

		arg0_6._dataProxy:CalcSubRoutineScore()
		arg0_6._state:BattleEnd()
	end

	arg0_6._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_6, nil, var1_6, nil)
end

function var4_0.onUpdateCountDown(arg0_9, arg1_9)
	if arg0_9._dataProxy:GetCountDown() <= 0 then
		arg0_9._dataProxy:EnemyEscape()
		arg0_9._dataProxy:CalcSubRountineTimeUp()
		arg0_9._state:BattleTimeUp()
	end
end

function var4_0.onShutDownPlayer(arg0_10, arg1_10)
	local var0_10 = arg1_10.Dispatcher:GetUniqueID()

	arg0_10._dataProxy:ShutdownPlayerUnit(var0_10)
end

function var4_0.onPlayerShutDown(arg0_11, arg1_11)
	if arg0_11._state:GetState() ~= arg0_11._state.BATTLE_STATE_FIGHT then
		return
	end

	local var0_11 = arg1_11.Data.unit

	if #arg0_11._userFleet:GetSubBench() > 0 then
		arg0_11._userFleet:ShiftManualSub()
	else
		arg0_11._dataProxy:CalcSubRountineElimate()
		arg0_11._state:BattleEnd()
	end
end
