ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleSingleDungeonCommand", var0_0.MVC.Command)

var0_0.Battle.BattleSingleDungeonCommand = var3_0
var3_0.__name = "BattleSingleDungeonCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.Initialize(arg0_2)
	var3_0.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	arg0_2._uiMediator = arg0_2._state:GetUIMediator()

	arg0_2:Init()
	arg0_2:InitProtocol()
	arg0_2:AddEvent()

	arg0_2._count = 0
end

function var3_0.DoPrologue(arg0_3)
	pg.UIMgr.GetInstance():Marching()

	local function var0_3()
		arg0_3._uiMediator:OpeningEffect(function()
			arg0_3._uiMediator:ShowAutoBtn()
			arg0_3._uiMediator:ShowTimer()
			arg0_3._state:GetCommandByName(var0_0.Battle.BattleControllerWeaponCommand.__name):TryAutoSub()
			arg0_3._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_3._waveUpdater:Start()

			if arg0_3._dataProxy:GetInitData().hideAllButtons then
				arg0_3._dataProxy:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
					isActive = false
				}))
			end
		end)
		arg0_3._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
		arg0_3._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_3._dataProxy:TirggerBattleStartBuffs()
	end

	arg0_3._uiMediator:SeaSurfaceShift(45, 0, nil, var0_3)
end

function var3_0.Init(arg0_6)
	arg0_6._unitDataList = {}

	arg0_6:initWaveModule()
end

function var3_0.Clear(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7._unitDataList) do
		arg0_7:UnregisterUnitEvent(iter1_7)

		arg0_7._unitDataList[iter0_7] = nil
	end

	arg0_7._waveUpdater:Clear()
end

function var3_0.Reinitialize(arg0_8)
	arg0_8._state:Deactive()
	arg0_8:Clear()
	arg0_8:Init()
end

function var3_0.Dispose(arg0_9)
	arg0_9:Clear()
	arg0_9:RemoveEvent()
	var3_0.super.Dispose(arg0_9)
end

function var3_0.SetVertifyFail(arg0_10, arg1_10)
	if not arg0_10._vertifyFail then
		arg0_10._vertifyFail = arg1_10
	end
end

function var3_0.onInitBattle(arg0_11)
	arg0_11._userFleet = arg0_11._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)

	arg0_11._waveUpdater:SetWavesData(arg0_11._dataProxy:GetStageInfo())
end

function var3_0.initWaveModule(arg0_12)
	local function var0_12(arg0_13, arg1_13, arg2_13)
		arg0_12._dataProxy:SpawnMonster(arg0_13, arg1_13, arg2_13, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_12(arg0_14)
		arg0_12._dataProxy:SpawnAirFighter(arg0_14)
	end

	local function var2_12()
		if arg0_12._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_12._vertifyFail
			})

			return
		end

		arg0_12:CalcStatistic()
		arg0_12._state:BattleEnd()
	end

	local function var3_12(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
		arg0_12._dataProxy:SpawnCubeArea(var0_0.Battle.BattleConst.AOEField.SURFACE, -1, arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	end

	arg0_12._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_12, var1_12, var2_12, var3_12)
end

function var3_0.InitProtocol(arg0_17)
	return
end

function var3_0.AddEvent(arg0_18)
	arg0_18._dataProxy:RegisterEventListener(arg0_18, var2_0.ADD_UNIT, arg0_18.onAddUnit)
	arg0_18._dataProxy:RegisterEventListener(arg0_18, var2_0.REMOVE_UNIT, arg0_18.onRemoveUnit)
	arg0_18._dataProxy:RegisterEventListener(arg0_18, var2_0.STAGE_DATA_INIT_FINISH, arg0_18.onInitBattle)
	arg0_18._dataProxy:RegisterEventListener(arg0_18, var2_0.SHUT_DOWN_PLAYER, arg0_18.onPlayerShutDown)
	arg0_18._dataProxy:RegisterEventListener(arg0_18, var2_0.UPDATE_COUNT_DOWN, arg0_18.onUpdateCountDown)
end

function var3_0.RemoveEvent(arg0_19)
	arg0_19._dataProxy:UnregisterEventListener(arg0_19, var2_0.ADD_UNIT)
	arg0_19._dataProxy:UnregisterEventListener(arg0_19, var2_0.REMOVE_UNIT)
	arg0_19._dataProxy:UnregisterEventListener(arg0_19, var2_0.STAGE_DATA_INIT_FINISH)
	arg0_19._dataProxy:UnregisterEventListener(arg0_19, var2_0.SHUT_DOWN_PLAYER)
	arg0_19._dataProxy:UnregisterEventListener(arg0_19, var2_0.UPDATE_COUNT_DOWN)
end

function var3_0.onAddUnit(arg0_20, arg1_20)
	local var0_20 = arg1_20.Data.type
	local var1_20 = arg1_20.Data.unit

	arg0_20:RegisterUnitEvent(var1_20)

	arg0_20._unitDataList[var1_20:GetUniqueID()] = var1_20

	if var0_20 == var0_0.Battle.BattleConst.UnitType.ENEMY_UNIT or var0_20 == var0_0.Battle.BattleConst.UnitType.BOSS_UNIT then
		arg0_20._waveUpdater:AddMonster(var1_20)
	end
end

function var3_0.RegisterUnitEvent(arg0_21, arg1_21)
	local var0_21 = arg1_21:GetUnitType()

	if var0_21 ~= var0_0.Battle.BattleConst.UnitType.MINION_UNIT then
		arg1_21:RegisterEventListener(arg0_21, var1_0.WILL_DIE, arg0_21.onWillDie)
	end

	arg1_21:RegisterEventListener(arg0_21, var1_0.DYING, arg0_21.onUnitDying)

	if var0_21 == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_21:RegisterEventListener(arg0_21, var1_0.SHUT_DOWN_PLAYER, arg0_21.onShutDownPlayer)
	end
end

function var3_0.UnregisterUnitEvent(arg0_22, arg1_22)
	arg1_22:UnregisterEventListener(arg0_22, var1_0.WILL_DIE)
	arg1_22:UnregisterEventListener(arg0_22, var1_0.DYING)

	if arg1_22:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_22:UnregisterEventListener(arg0_22, var1_0.SHUT_DOWN_PLAYER)
	end
end

function var3_0.onRemoveUnit(arg0_23, arg1_23)
	local var0_23 = arg1_23.Data.UID

	arg0_23._waveUpdater:RemoveMonster(var0_23)

	local var1_23 = arg0_23._unitDataList[var0_23]

	if var1_23 == nil then
		return
	end

	arg0_23:UnregisterUnitEvent(var1_23)

	arg0_23._unitDataList[var0_23] = nil
end

function var3_0.onPlayerShutDown(arg0_24, arg1_24)
	if arg0_24._state:GetState() ~= arg0_24._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg1_24.Data.unit == arg0_24._userFleet:GetFlagShip() and arg0_24._dataProxy:GetInitData().battleType ~= SYSTEM_PROLOGUE and arg0_24._dataProxy:GetInitData().battleType ~= SYSTEM_PERFORM then
		arg0_24:CalcStatistic()
		arg0_24._state:BattleEnd()

		return
	end

	if #arg0_24._userFleet:GetScoutList() == 0 then
		arg0_24:CalcStatistic()
		arg0_24._state:BattleEnd()
	end
end

function var3_0.onUpdateCountDown(arg0_25, arg1_25)
	if arg0_25._dataProxy:GetCountDown() <= 0 then
		arg0_25._dataProxy:EnemyEscape()
		arg0_25:CalcStatistic()
		arg0_25._state:BattleTimeUp()
	end
end

function var3_0.onUnitDying(arg0_26, arg1_26)
	local var0_26 = arg1_26.Dispatcher:GetUniqueID()

	arg0_26._dataProxy:KillUnit(var0_26)
end

function var3_0.onWillDie(arg0_27, arg1_27)
	local var0_27 = arg1_27.Dispatcher
	local var1_27 = var0_0.Battle.BattleConst.UnitDeathReason
	local var2_27 = var0_27:GetDeathReason()

	if var2_27 == var1_27.LEAVE then
		if var0_27:GetIFF() == var0_0.Battle.BattleConfig.FRIENDLY_CODE then
			arg0_27._dataProxy:CalcBPWhenPlayerLeave(var0_27)
		end
	elseif var2_27 == var1_27.DESTRUCT then
		arg0_27._dataProxy:CalcBattleScoreWhenDead(var0_27)

		if var0_27:IsBoss() then
			arg0_27._dataProxy:AddScoreWhenBossDestruct()
		end
	else
		arg0_27._dataProxy:CalcBattleScoreWhenDead(var0_27)
	end

	local var3_27 = arg0_27._dataProxy:IsThereBoss()

	if var0_27:IsBoss() and not var3_27 then
		arg0_27._dataProxy:KillAllEnemy()
	end
end

function var3_0.onShutDownPlayer(arg0_28, arg1_28)
	local var0_28 = arg1_28.Dispatcher:GetUniqueID()

	arg0_28._dataProxy:ShutdownPlayerUnit(var0_28)
end

function var3_0.GetMaxRestHPRateBossRate(arg0_29)
	local var0_29 = arg0_29._waveUpdater:GetAllBossWave()

	for iter0_29, iter1_29 in ipairs(var0_29) do
		if iter1_29:GetState() == iter1_29.STATE_DEACTIVE then
			return 10000
		end
	end

	local var1_29 = 0

	for iter2_29, iter3_29 in pairs(arg0_29._dataProxy:GetUnitList()) do
		if iter3_29:IsBoss() and iter3_29:IsAlive() then
			var1_29 = math.max(var1_29, iter3_29:GetHPRate())
		end
	end

	return var1_29 * 10000
end

function var3_0.CalcStatistic(arg0_30)
	arg0_30._dataProxy:CalcSingleDungeonScoreAtEnd(arg0_30._userFleet)

	local var0_30 = arg0_30:GetMaxRestHPRateBossRate()

	arg0_30._dataProxy:CalcMaxRestHPRateBossRate(var0_30)
end
