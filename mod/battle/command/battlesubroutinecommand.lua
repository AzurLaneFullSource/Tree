ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleConst
local var4 = class("BattleSubRoutineCommand", var0.Battle.BattleSubmarineRunCommand)

var0.Battle.BattleSubRoutineCommand = var4
var4.__name = "BattleSubRoutineCommand"

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
		end, SYSTEM_SUB_ROUTINE)

		local var0 = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)

		var0:FleetWarcry()
		var0:ChangeSubmarineState(var0.Battle.OxyState.STATE_FREE_DIVE)
		var0:GetSubBoostVO():ResetCurrent()
		arg0._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0._dataProxy:TirggerBattleStartBuffs()
	end
	local var1 = arg0._userFleet:GetUnitList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = var0.Battle.BattleBuffUnit.New(9040)

		iter1:AddBuff(var2)
		iter1:RemoveBuff(8520)
	end

	arg0._uiMediator:SeaSurfaceShift(45, 0, nil, var0)
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

		arg0._dataProxy:CalcSubRoutineScore()
		arg0._state:BattleEnd()
	end

	arg0._waveUpdater = var0.Battle.BattleWaveUpdater.New(var0, nil, var1, nil)
end

function var4.onUpdateCountDown(arg0, arg1)
	if arg0._dataProxy:GetCountDown() <= 0 then
		arg0._dataProxy:EnemyEscape()
		arg0._dataProxy:CalcSubRountineTimeUp()
		arg0._state:BattleTimeUp()
	end
end

function var4.onShutDownPlayer(arg0, arg1)
	local var0 = arg1.Dispatcher:GetUniqueID()

	arg0._dataProxy:ShutdownPlayerUnit(var0)
end

function var4.onPlayerShutDown(arg0, arg1)
	if arg0._state:GetState() ~= arg0._state.BATTLE_STATE_FIGHT then
		return
	end

	local var0 = arg1.Data.unit

	if #arg0._userFleet:GetSubBench() > 0 then
		arg0._userFleet:ShiftManualSub()
	else
		arg0._dataProxy:CalcSubRountineElimate()
		arg0._state:BattleEnd()
	end
end
