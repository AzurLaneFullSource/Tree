ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleSingleDungeonCommand", var0.MVC.Command)

var0.Battle.BattleSingleDungeonCommand = var3
var3.__name = "BattleSingleDungeonCommand"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.Initialize(arg0)
	var3.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)
	arg0._uiMediator = arg0._state:GetUIMediator()

	arg0:Init()
	arg0:InitProtocol()
	arg0:AddEvent()

	arg0._count = 0
end

function var3.DoPrologue(arg0)
	pg.UIMgr.GetInstance():Marching()

	local var0 = function()
		arg0._uiMediator:OpeningEffect(function()
			arg0._uiMediator:ShowAutoBtn()
			arg0._uiMediator:ShowTimer()
			arg0._state:GetCommandByName(var0.Battle.BattleControllerWeaponCommand.__name):TryAutoSub()
			arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0._waveUpdater:Start()

			if arg0._dataProxy:GetInitData().hideAllButtons then
				arg0._dataProxy:DispatchEvent(var0.Event.New(var0.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
					isActive = false
				}))
			end
		end)
		arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
		arg0._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0._dataProxy:TirggerBattleStartBuffs()
	end

	arg0._uiMediator:SeaSurfaceShift(45, 0, nil, var0)
end

function var3.Init(arg0)
	arg0._unitDataList = {}

	arg0:initWaveModule()
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
	arg0:Clear()
	arg0:RemoveEvent()
	var3.super.Dispose(arg0)
end

function var3.SetVertifyFail(arg0, arg1)
	if not arg0._vertifyFail then
		arg0._vertifyFail = arg1
	end
end

function var3.onInitBattle(arg0)
	arg0._userFleet = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)

	arg0._waveUpdater:SetWavesData(arg0._dataProxy:GetStageInfo())
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

function var3.InitProtocol(arg0)
	return
end

function var3.AddEvent(arg0)
	arg0._dataProxy:RegisterEventListener(arg0, var2.ADD_UNIT, arg0.onAddUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var2.REMOVE_UNIT, arg0.onRemoveUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var2.STAGE_DATA_INIT_FINISH, arg0.onInitBattle)
	arg0._dataProxy:RegisterEventListener(arg0, var2.SHUT_DOWN_PLAYER, arg0.onPlayerShutDown)
	arg0._dataProxy:RegisterEventListener(arg0, var2.UPDATE_COUNT_DOWN, arg0.onUpdateCountDown)
end

function var3.RemoveEvent(arg0)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.ADD_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.REMOVE_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.STAGE_DATA_INIT_FINISH)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.SHUT_DOWN_PLAYER)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.UPDATE_COUNT_DOWN)
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
	local var0 = arg1:GetUnitType()

	if var0 ~= var0.Battle.BattleConst.UnitType.MINION_UNIT then
		arg1:RegisterEventListener(arg0, var1.WILL_DIE, arg0.onWillDie)
	end

	arg1:RegisterEventListener(arg0, var1.DYING, arg0.onUnitDying)

	if var0 == var0.Battle.BattleConst.UnitType.PLAYER_UNIT then
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
	if arg0._state:GetState() ~= arg0._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg1.Data.unit == arg0._userFleet:GetFlagShip() and arg0._dataProxy:GetInitData().battleType ~= SYSTEM_PROLOGUE and arg0._dataProxy:GetInitData().battleType ~= SYSTEM_PERFORM then
		arg0:CalcStatistic()
		arg0._state:BattleEnd()

		return
	end

	if #arg0._userFleet:GetScoutList() == 0 then
		arg0:CalcStatistic()
		arg0._state:BattleEnd()
	end
end

function var3.onUpdateCountDown(arg0, arg1)
	if arg0._dataProxy:GetCountDown() <= 0 then
		arg0._dataProxy:EnemyEscape()
		arg0:CalcStatistic()
		arg0._state:BattleTimeUp()
	end
end

function var3.onUnitDying(arg0, arg1)
	local var0 = arg1.Dispatcher:GetUniqueID()

	arg0._dataProxy:KillUnit(var0)
end

function var3.onWillDie(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = var0.Battle.BattleConst.UnitDeathReason
	local var2 = var0:GetDeathReason()

	if var2 == var1.LEAVE then
		if var0:GetIFF() == var0.Battle.BattleConfig.FRIENDLY_CODE then
			arg0._dataProxy:CalcBPWhenPlayerLeave(var0)
		end
	elseif var2 == var1.DESTRUCT then
		arg0._dataProxy:CalcBattleScoreWhenDead(var0)

		if var0:IsBoss() then
			arg0._dataProxy:AddScoreWhenBossDestruct()
		end
	else
		arg0._dataProxy:CalcBattleScoreWhenDead(var0)
	end

	local var3 = arg0._dataProxy:IsThereBoss()

	if var0:IsBoss() and not var3 then
		arg0._dataProxy:KillAllEnemy()
	end
end

function var3.onShutDownPlayer(arg0, arg1)
	local var0 = arg1.Dispatcher:GetUniqueID()

	arg0._dataProxy:ShutdownPlayerUnit(var0)
end

function var3.GetMaxRestHPRateBossRate(arg0)
	local var0 = arg0._waveUpdater:GetAllBossWave()

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetState() == iter1.STATE_DEACTIVE then
			return 10000
		end
	end

	local var1 = 0

	for iter2, iter3 in pairs(arg0._dataProxy:GetUnitList()) do
		if iter3:IsBoss() and iter3:IsAlive() then
			var1 = math.max(var1, iter3:GetHPRate())
		end
	end

	return var1 * 10000
end

function var3.CalcStatistic(arg0)
	arg0._dataProxy:CalcSingleDungeonScoreAtEnd(arg0._userFleet)

	local var0 = arg0:GetMaxRestHPRateBossRate()

	arg0._dataProxy:CalcMaxRestHPRateBossRate(var0)
end
