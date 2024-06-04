ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleDebugCommand", var0.MVC.Command)

var0.Battle.BattleDebugCommand = var3
var3.__name = "BattleDebugCommand"

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
	(function()
		arg0._uiMediator:OpeningEffect(function()
			arg0._uiMediator:ShowAutoBtn()
			arg0._uiMediator:ShowTimer()
			arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
		end, SYSTEM_DEBUG)
		arg0._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0._dataProxy:TirggerBattleStartBuffs()
	end)()
end

function var3.Init(arg0)
	arg0._unitDataList = {}
end

function var3.Clear(arg0)
	for iter0, iter1 in pairs(arg0._unitDataList) do
		arg0:UnregisterUnitEvent(iter1)

		arg0._unitDataList[iter0] = nil
	end
end

function var3.Reinitialize(arg0)
	arg0._state:Deactive()
	arg0:Clear()
	arg0:Init()
end

function var3.Dispose(arg0)
	var0.Battle.BattleDataProxy.Update = var0.Battle.BattleDebugConsole.ProxyUpdateNormal
	var0.Battle.BattleDataProxy.UpdateAutoComponent = var0.Battle.BattleDebugConsole.ProxyUpdateAutoComponentNormal

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
end

function var3.onAddUnit(arg0, arg1)
	local var0 = arg1.Data.type
	local var1 = arg1.Data.unit

	arg0:RegisterUnitEvent(var1)

	arg0._unitDataList[var1:GetUniqueID()] = var1

	if var0 ~= var0.Battle.BattleConst.UnitType.ENEMY_UNIT and var0 ~= var0.Battle.BattleConst.UnitType.BOSS_UNIT and var0 ~= var0.Battle.BattleConst.UnitType.MINION_UNIT and var0 ~= var0.Battle.BattleConst.UnitType.NPC_UNIT and var0 == var0.Battle.BattleConst.UnitType.BOSS_UNIT then
		-- block empty
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
	local var1 = arg0._unitDataList[var0]

	if var1 == nil then
		return
	end

	arg0:UnregisterUnitEvent(var1)

	arg0._unitDataList[var0] = nil
end

function var3.onPlayerShutDown(arg0, arg1)
	if arg1.Data.unit == arg0._userFleet:GetMainList() == 0 then
		arg0._dataProxy:KillAllAirStrike()
		arg0._dataProxy:KillAllEnemy()
		arg0._dataProxy:CLSBullet(var0.Battle.BattleConfig.FRIENDLY_CODE)
		arg0._dataProxy:CLSBullet(var0.Battle.BattleConfig.FOE_CODE)

		local var0 = arg0._dataProxy:GetInitData().MainUnitList

		for iter0, iter1 in ipairs(var0) do
			arg0._dataProxy:SpawnMain(iter1, var0.Battle.BattleConfig.FRIENDLY_CODE)
		end
	end

	if #arg0._userFleet:GetScoutList() == 0 then
		arg0._dataProxy:KillAllAirStrike()
		arg0._dataProxy:KillAllEnemy()
		arg0._dataProxy:CLSBullet(var0.Battle.BattleConfig.FRIENDLY_CODE)
		arg0._dataProxy:CLSBullet(var0.Battle.BattleConfig.FOE_CODE)

		local var1 = arg0._dataProxy:GetInitData().VanguardUnitList

		for iter2, iter3 in ipairs(var1) do
			arg0._dataProxy:SpawnVanguard(iter3, var0.Battle.BattleConfig.FRIENDLY_CODE)
		end
	end
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
