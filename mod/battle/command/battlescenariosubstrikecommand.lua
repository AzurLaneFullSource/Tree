ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleScenarioSubStrikeCommand", var0_0.Battle.BattleSingleDungeonCommand)

var0_0.Battle.BattleScenarioSubStrikeCommand = var3_0
var3_0.__name = "BattleScenarioSubStrikeCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.DoPrologue(arg0_2)
	pg.UIMgr.GetInstance():Marching()

	local function var0_2()
		arg0_2._uiMediator:OpeningEffect(function()
			arg0_2._uiMediator:ShowTimer()
			arg0_2._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_2._waveUpdater:Start()

			if arg0_2._dataProxy:GetInitData().hideAllButtons then
				arg0_2._dataProxy:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
					isActive = false
				}))
			end

			arg0_2._uiMediator:InitCameraGestureSlider()
			arg0_2._uiMediator:EnableJoystick(false)
			arg0_2._uiMediator:EnableWeaponButton(false)
		end)
		arg0_2._dataProxy:SubmarineStrike(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
	end

	arg0_2._uiMediator:SeaSurfaceShift(45, 0, nil, var0_2)
end

function var3_0.initWaveModule(arg0_5)
	local function var0_5(arg0_6, arg1_6, arg2_6)
		arg0_5._dataProxy:SpawnMonster(arg0_6, arg1_6, arg2_6, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_5(arg0_7)
		arg0_5._dataProxy:SpawnAirFighter(arg0_7)
	end

	local function var2_5()
		if arg0_5._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_5._vertifyFail
			})

			return
		end

		arg0_5._dataProxy:TriggerFinishBattle()
		arg0_5:CalcStatistic()
		arg0_5._state:BattleEnd()
	end

	local function var3_5(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
		arg0_5._dataProxy:SpawnCubeArea(var0_0.Battle.BattleConst.AOEField.SURFACE, -1, arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	end

	arg0_5._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_5, var1_5, var2_5, var3_5)
end

function var3_0.onAddUnit(arg0_10, arg1_10)
	var3_0.super.onAddUnit(arg0_10, arg1_10)

	if arg1_10.Data.type == var0_0.Battle.BattleConst.UnitType.BOSS_UNIT then
		local var0_10 = arg1_10.Data.unit

		arg0_10._dataProxy:AddScenarioSubStrikeBoss(var0_10)
	end
end

function var3_0.onPlayerShutDown(arg0_11, arg1_11)
	if arg0_11._state:GetState() ~= arg0_11._state.BATTLE_STATE_FIGHT then
		return
	end

	if #arg0_11._userFleet:GetSubList() == 0 then
		arg0_11._dataProxy:TriggerFinishBattle()
		arg0_11:CalcStatistic()
		arg0_11._state:BattleEnd()
	end
end

function var3_0.onUpdateCountDown(arg0_12, arg1_12)
	if arg0_12._dataProxy:GetCountDown() <= 0 then
		arg0_12._dataProxy:EnemyEscape()
		arg0_12:CalcStatistic()
		arg0_12._state:BattleTimeUp()
	end
end

function var3_0.onWillDie(arg0_13, arg1_13)
	local var0_13 = arg1_13.Dispatcher
	local var1_13 = var0_0.Battle.BattleConst.UnitDeathReason

	if var0_13:GetDeathReason() == var1_13.LEAVE then
		if var0_13:GetIFF() == var0_0.Battle.BattleConfig.FRIENDLY_CODE then
			arg0_13._dataProxy:CalcBPWhenPlayerLeave(var0_13)
		end
	else
		arg0_13._dataProxy:CalcBattleScoreWhenDead(var0_13)
	end

	local var2_13 = arg0_13._dataProxy:IsThereBoss()

	if var0_13:IsBoss() and not var2_13 then
		arg0_13._dataProxy:KillAllEnemy()
	end
end

function var3_0.CalcBattleEnd(arg0_14)
	arg0_14._dataProxy:TriggerFinishBattle()
	arg0_14:CalcStatistic()
	arg0_14._state:BattleEnd()
end

function var3_0.CalcStatistic(arg0_15)
	arg0_15._dataProxy:CalcScenarioSubStrikeScoreAtEnd()
end
