ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleCardPuzzleCommand", var0.MVC.Command)

var0.Battle.BattleCardPuzzleCommand = var3
var3.__name = "BattleCardPuzzleCommand"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.Initialize(arg0)
	arg0:Init()
	var3.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)
	arg0._uiMediator = arg0._state:GetMediatorByName(var0.Battle.BattleUIMediator.__name)

	arg0:AddEvent()
end

function var3.DoPrologue(arg0)
	pg.UIMgr.GetInstance():Marching()

	local var0 = function()
		arg0._uiMediator:OpeningEffect(function()
			arg0._dataProxy:SetupCalculateDamage(var0.Battle.BattleCardPuzzleFormulas.CreateContextCalculateDamage)
			arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0._waveUpdater:Start()
		end, SYSTEM_CARDPUZZLE)
		arg0._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0._dataProxy:TirggerBattleStartBuffs()
		arg0._dataProxy:StartCardPuzzle()

		local var0 = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)

		arg0._joystickBot = var0.Battle.CardPuzzleJoyStickAutoBot.New(arg0._dataProxy, var0)

		arg0._joystickBot:SetActive(true)
		arg0._state:EnableJoystick(false)
	end

	arg0._uiMediator:SeaSurfaceShift(45, 0, nil, var0)
end

function var3.Init(arg0)
	arg0._unitDataList = {}

	arg0:initWaveModule()
end

function var3.initWaveModule(arg0)
	local var0 = function(arg0, arg1, arg2)
		arg0._dataProxy:SpawnMonster(arg0, arg1, arg2, var0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1(arg0)
		arg0._dataProxy:SpawnAirFighter(arg0)
	end

	local function var2()
		if arg0._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0._vertifyFail
			})

			return
		end

		arg0:CalcStatistic()
		arg0._state:BattleEnd()
	end

	local function var3(arg0, arg1, arg2, arg3, arg4)
		arg0._dataProxy:SpawnCubeArea(var0.Battle.BattleConst.AOEField.SURFACE, -1, arg0, arg1, arg2, arg3, arg4)
	end

	arg0._waveUpdater = var0.Battle.BattleWaveUpdater.New(var0, var1, var2, var3)
end

function var3.Clear(arg0)
	for iter0, iter1 in pairs(arg0._unitDataList) do
		arg0:UnregisterUnitEvent(iter1)

		arg0._unitDataList[iter0] = nil
	end

	arg0._waveUpdater:Clear()
end

function var3.Reinitialize(arg0)
	arg0._state:Deactive()
	arg0:Clear()
	arg0:Init()
end

function var3.Dispose(arg0)
	var0.Battle.BattleDataProxy.Update = var0.Battle.BattleDebugConsole.ProxyUpdateNormal
	var0.Battle.BattleDataProxy.UpdateAutoComponent = var0.Battle.BattleDebugConsole.ProxyUpdateAutoComponentNormal

	arg0._joystickBot:Dispose()
	arg0:Clear()
	arg0:RemoveEvent()
	var3.super.Dispose(arg0)
end

function var3.AddEvent(arg0)
	arg0._dataProxy:RegisterEventListener(arg0, var2.STAGE_DATA_INIT_FINISH, arg0.onInitBattle)
	arg0._dataProxy:RegisterEventListener(arg0, var2.ADD_UNIT, arg0.onAddUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var2.REMOVE_UNIT, arg0.onRemoveUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var2.SHUT_DOWN_PLAYER, arg0.onPlayerShutDown)
end

function var3.RemoveEvent(arg0)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.STAGE_DATA_INIT_FINISH)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.ADD_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.REMOVE_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.SHUT_DOWN_PLAYER)
end

function var3.onInitBattle(arg0)
	arg0._userFleet = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)

	arg0._waveUpdater:SetWavesData(arg0._dataProxy:GetStageInfo())
end

function var3.onAddUnit(arg0, arg1)
	local var0 = arg1.Data.type
	local var1 = arg1.Data.unit

	arg0:RegisterUnitEvent(var1)

	arg0._unitDataList[var1:GetUniqueID()] = var1

	if var0 == var0.Battle.BattleConst.UnitType.ENEMY_UNIT or var0 == var0.Battle.BattleConst.UnitType.BOSS_UNIT then
		arg0._waveUpdater:AddMonster(var1)
	end
end

function var3.RegisterUnitEvent(arg0, arg1)
	arg1:RegisterEventListener(arg0, var1.WILL_DIE, arg0.onWillDie)
	arg1:RegisterEventListener(arg0, var1.DYING, arg0.onUnitDying)

	if arg1:GetUnitType() == var0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1:RegisterEventListener(arg0, var1.SHUT_DOWN_PLAYER, arg0.onShutDownPlayer)
	end
end

function var3.UnregisterUnitEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var1.WILL_DIE)
	arg1:UnregisterEventListener(arg0, var1.DYING)

	if arg1:GetUnitType() == var0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1:UnregisterEventListener(arg0, var1.SHUT_DOWN_PLAYER)
	end
end

function var3.onRemoveUnit(arg0, arg1)
	local var0 = arg1.Data.UID

	arg0._waveUpdater:RemoveMonster(var0)

	local var1 = arg0._unitDataList[var0]

	if var1 == nil then
		return
	end

	arg0:UnregisterUnitEvent(var1)

	arg0._unitDataList[var0] = nil
end

function var3.onPlayerShutDown(arg0, arg1)
	arg0:CalcStatistic()
	arg0._state:BattleEnd()
end

function var3.onUnitDying(arg0, arg1)
	local var0 = arg1.Dispatcher:GetUniqueID()

	arg0._dataProxy:KillUnit(var0)
end

function var3.onWillDie(arg0, arg1)
	local var0 = arg1.Dispatcher

	arg0._dataProxy:CalcBattleScoreWhenDead(var0)

	local var1 = arg0._dataProxy:IsThereBoss()

	if var0:IsBoss() and not var1 then
		arg0._dataProxy:KillAllEnemy()
	end
end

function var3.onShutDownPlayer(arg0, arg1)
	local var0 = arg1.Dispatcher:GetUniqueID()

	arg0._dataProxy:ShutdownPlayerUnit(var0)
end

function var3.CalcStatistic(arg0)
	arg0._dataProxy:CalcCardPuzzleScoreAtEnd(arg0._userFleet)
end
