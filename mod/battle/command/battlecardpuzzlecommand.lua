ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleCardPuzzleCommand", var0_0.MVC.Command)

var0_0.Battle.BattleCardPuzzleCommand = var3_0
var3_0.__name = "BattleCardPuzzleCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.Initialize(arg0_2)
	arg0_2:Init()
	var3_0.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	arg0_2._uiMediator = arg0_2._state:GetMediatorByName(var0_0.Battle.BattleUIMediator.__name)

	arg0_2:AddEvent()
end

function var3_0.DoPrologue(arg0_3)
	pg.UIMgr.GetInstance():Marching()

	local function var0_3()
		arg0_3._uiMediator:OpeningEffect(function()
			arg0_3._dataProxy:SetupCalculateDamage(var0_0.Battle.BattleCardPuzzleFormulas.CreateContextCalculateDamage)
			arg0_3._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_3._waveUpdater:Start()
		end, SYSTEM_CARDPUZZLE)
		arg0_3._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_3._dataProxy:TirggerBattleStartBuffs()
		arg0_3._dataProxy:StartCardPuzzle()

		local var0_4 = arg0_3._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)

		arg0_3._joystickBot = var0_0.Battle.CardPuzzleJoyStickAutoBot.New(arg0_3._dataProxy, var0_4)

		arg0_3._joystickBot:SetActive(true)
		arg0_3._state:EnableJoystick(false)
	end

	arg0_3._uiMediator:SeaSurfaceShift(45, 0, nil, var0_3)
end

function var3_0.Init(arg0_6)
	arg0_6._unitDataList = {}

	arg0_6:initWaveModule()
end

function var3_0.initWaveModule(arg0_7)
	local function var0_7(arg0_8, arg1_8, arg2_8)
		arg0_7._dataProxy:SpawnMonster(arg0_8, arg1_8, arg2_8, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_7(arg0_9)
		arg0_7._dataProxy:SpawnAirFighter(arg0_9)
	end

	local function var2_7()
		if arg0_7._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_7._vertifyFail
			})

			return
		end

		arg0_7:CalcStatistic()
		arg0_7._state:BattleEnd()
	end

	local function var3_7(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
		arg0_7._dataProxy:SpawnCubeArea(var0_0.Battle.BattleConst.AOEField.SURFACE, -1, arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	end

	arg0_7._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_7, var1_7, var2_7, var3_7)
end

function var3_0.Clear(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12._unitDataList) do
		arg0_12:UnregisterUnitEvent(iter1_12)

		arg0_12._unitDataList[iter0_12] = nil
	end

	arg0_12._waveUpdater:Clear()
end

function var3_0.Reinitialize(arg0_13)
	arg0_13._state:Deactive()
	arg0_13:Clear()
	arg0_13:Init()
end

function var3_0.Dispose(arg0_14)
	var0_0.Battle.BattleDataProxy.Update = var0_0.Battle.BattleDebugConsole.ProxyUpdateNormal
	var0_0.Battle.BattleDataProxy.UpdateAutoComponent = var0_0.Battle.BattleDebugConsole.ProxyUpdateAutoComponentNormal

	arg0_14._joystickBot:Dispose()
	arg0_14:Clear()
	arg0_14:RemoveEvent()
	var3_0.super.Dispose(arg0_14)
end

function var3_0.AddEvent(arg0_15)
	arg0_15._dataProxy:RegisterEventListener(arg0_15, var2_0.STAGE_DATA_INIT_FINISH, arg0_15.onInitBattle)
	arg0_15._dataProxy:RegisterEventListener(arg0_15, var2_0.ADD_UNIT, arg0_15.onAddUnit)
	arg0_15._dataProxy:RegisterEventListener(arg0_15, var2_0.REMOVE_UNIT, arg0_15.onRemoveUnit)
	arg0_15._dataProxy:RegisterEventListener(arg0_15, var2_0.SHUT_DOWN_PLAYER, arg0_15.onPlayerShutDown)
end

function var3_0.RemoveEvent(arg0_16)
	arg0_16._dataProxy:UnregisterEventListener(arg0_16, var2_0.STAGE_DATA_INIT_FINISH)
	arg0_16._dataProxy:UnregisterEventListener(arg0_16, var2_0.ADD_UNIT)
	arg0_16._dataProxy:UnregisterEventListener(arg0_16, var2_0.REMOVE_UNIT)
	arg0_16._dataProxy:UnregisterEventListener(arg0_16, var2_0.SHUT_DOWN_PLAYER)
end

function var3_0.onInitBattle(arg0_17)
	arg0_17._userFleet = arg0_17._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)

	arg0_17._waveUpdater:SetWavesData(arg0_17._dataProxy:GetStageInfo())
end

function var3_0.onAddUnit(arg0_18, arg1_18)
	local var0_18 = arg1_18.Data.type
	local var1_18 = arg1_18.Data.unit

	arg0_18:RegisterUnitEvent(var1_18)

	arg0_18._unitDataList[var1_18:GetUniqueID()] = var1_18

	if var0_18 == var0_0.Battle.BattleConst.UnitType.ENEMY_UNIT or var0_18 == var0_0.Battle.BattleConst.UnitType.BOSS_UNIT then
		arg0_18._waveUpdater:AddMonster(var1_18)
	end
end

function var3_0.RegisterUnitEvent(arg0_19, arg1_19)
	arg1_19:RegisterEventListener(arg0_19, var1_0.WILL_DIE, arg0_19.onWillDie)
	arg1_19:RegisterEventListener(arg0_19, var1_0.DYING, arg0_19.onUnitDying)

	if arg1_19:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_19:RegisterEventListener(arg0_19, var1_0.SHUT_DOWN_PLAYER, arg0_19.onShutDownPlayer)
	end
end

function var3_0.UnregisterUnitEvent(arg0_20, arg1_20)
	arg1_20:UnregisterEventListener(arg0_20, var1_0.WILL_DIE)
	arg1_20:UnregisterEventListener(arg0_20, var1_0.DYING)

	if arg1_20:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_20:UnregisterEventListener(arg0_20, var1_0.SHUT_DOWN_PLAYER)
	end
end

function var3_0.onRemoveUnit(arg0_21, arg1_21)
	local var0_21 = arg1_21.Data.UID

	arg0_21._waveUpdater:RemoveMonster(var0_21)

	local var1_21 = arg0_21._unitDataList[var0_21]

	if var1_21 == nil then
		return
	end

	arg0_21:UnregisterUnitEvent(var1_21)

	arg0_21._unitDataList[var0_21] = nil
end

function var3_0.onPlayerShutDown(arg0_22, arg1_22)
	arg0_22:CalcStatistic()
	arg0_22._state:BattleEnd()
end

function var3_0.onUnitDying(arg0_23, arg1_23)
	local var0_23 = arg1_23.Dispatcher:GetUniqueID()

	arg0_23._dataProxy:KillUnit(var0_23)
end

function var3_0.onWillDie(arg0_24, arg1_24)
	local var0_24 = arg1_24.Dispatcher

	arg0_24._dataProxy:CalcBattleScoreWhenDead(var0_24)

	local var1_24 = arg0_24._dataProxy:IsThereBoss()

	if var0_24:IsBoss() and not var1_24 then
		arg0_24._dataProxy:KillAllEnemy()
	end
end

function var3_0.onShutDownPlayer(arg0_25, arg1_25)
	local var0_25 = arg1_25.Dispatcher:GetUniqueID()

	arg0_25._dataProxy:ShutdownPlayerUnit(var0_25)
end

function var3_0.CalcStatistic(arg0_26)
	arg0_26._dataProxy:CalcCardPuzzleScoreAtEnd(arg0_26._userFleet)
end
