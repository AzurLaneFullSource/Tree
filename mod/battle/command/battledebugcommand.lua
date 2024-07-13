ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleDebugCommand", var0_0.MVC.Command)

var0_0.Battle.BattleDebugCommand = var3_0
var3_0.__name = "BattleDebugCommand"

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
	(function()
		arg0_3._uiMediator:OpeningEffect(function()
			arg0_3._uiMediator:ShowAutoBtn()
			arg0_3._uiMediator:ShowTimer()
			arg0_3._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
		end, SYSTEM_DEBUG)
		arg0_3._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_3._dataProxy:TirggerBattleStartBuffs()
	end)()
end

function var3_0.Init(arg0_6)
	arg0_6._unitDataList = {}
end

function var3_0.Clear(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7._unitDataList) do
		arg0_7:UnregisterUnitEvent(iter1_7)

		arg0_7._unitDataList[iter0_7] = nil
	end
end

function var3_0.Reinitialize(arg0_8)
	arg0_8._state:Deactive()
	arg0_8:Clear()
	arg0_8:Init()
end

function var3_0.Dispose(arg0_9)
	var0_0.Battle.BattleDataProxy.Update = var0_0.Battle.BattleDebugConsole.ProxyUpdateNormal
	var0_0.Battle.BattleDataProxy.UpdateAutoComponent = var0_0.Battle.BattleDebugConsole.ProxyUpdateAutoComponentNormal

	arg0_9:Clear()
	arg0_9:RemoveEvent()
	var3_0.super.Dispose(arg0_9)
end

function var3_0.AddEvent(arg0_10)
	arg0_10._dataProxy:RegisterEventListener(arg0_10, var2_0.STAGE_DATA_INIT_FINISH, arg0_10.onInitBattle)
	arg0_10._dataProxy:RegisterEventListener(arg0_10, var2_0.ADD_UNIT, arg0_10.onAddUnit)
	arg0_10._dataProxy:RegisterEventListener(arg0_10, var2_0.REMOVE_UNIT, arg0_10.onRemoveUnit)
	arg0_10._dataProxy:RegisterEventListener(arg0_10, var2_0.SHUT_DOWN_PLAYER, arg0_10.onPlayerShutDown)
end

function var3_0.RemoveEvent(arg0_11)
	arg0_11._dataProxy:UnregisterEventListener(arg0_11, var2_0.STAGE_DATA_INIT_FINISH)
	arg0_11._dataProxy:UnregisterEventListener(arg0_11, var2_0.ADD_UNIT)
	arg0_11._dataProxy:UnregisterEventListener(arg0_11, var2_0.REMOVE_UNIT)
	arg0_11._dataProxy:UnregisterEventListener(arg0_11, var2_0.SHUT_DOWN_PLAYER)
end

function var3_0.onInitBattle(arg0_12)
	arg0_12._userFleet = arg0_12._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
end

function var3_0.onAddUnit(arg0_13, arg1_13)
	local var0_13 = arg1_13.Data.type
	local var1_13 = arg1_13.Data.unit

	arg0_13:RegisterUnitEvent(var1_13)

	arg0_13._unitDataList[var1_13:GetUniqueID()] = var1_13

	if var0_13 ~= var0_0.Battle.BattleConst.UnitType.ENEMY_UNIT and var0_13 ~= var0_0.Battle.BattleConst.UnitType.BOSS_UNIT and var0_13 ~= var0_0.Battle.BattleConst.UnitType.MINION_UNIT and var0_13 ~= var0_0.Battle.BattleConst.UnitType.NPC_UNIT and var0_13 == var0_0.Battle.BattleConst.UnitType.BOSS_UNIT then
		-- block empty
	end
end

function var3_0.RegisterUnitEvent(arg0_14, arg1_14)
	arg1_14:RegisterEventListener(arg0_14, var1_0.WILL_DIE, arg0_14.onWillDie)
	arg1_14:RegisterEventListener(arg0_14, var1_0.DYING, arg0_14.onUnitDying)

	if arg1_14:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_14:RegisterEventListener(arg0_14, var1_0.SHUT_DOWN_PLAYER, arg0_14.onShutDownPlayer)
	end
end

function var3_0.UnregisterUnitEvent(arg0_15, arg1_15)
	arg1_15:UnregisterEventListener(arg0_15, var1_0.WILL_DIE)
	arg1_15:UnregisterEventListener(arg0_15, var1_0.DYING)

	if arg1_15:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_15:UnregisterEventListener(arg0_15, var1_0.SHUT_DOWN_PLAYER)
	end
end

function var3_0.onRemoveUnit(arg0_16, arg1_16)
	local var0_16 = arg1_16.Data.UID
	local var1_16 = arg0_16._unitDataList[var0_16]

	if var1_16 == nil then
		return
	end

	arg0_16:UnregisterUnitEvent(var1_16)

	arg0_16._unitDataList[var0_16] = nil
end

function var3_0.onPlayerShutDown(arg0_17, arg1_17)
	if arg1_17.Data.unit == arg0_17._userFleet:GetMainList() == 0 then
		arg0_17._dataProxy:KillAllAirStrike()
		arg0_17._dataProxy:KillAllEnemy()
		arg0_17._dataProxy:CLSBullet(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
		arg0_17._dataProxy:CLSBullet(var0_0.Battle.BattleConfig.FOE_CODE)

		local var0_17 = arg0_17._dataProxy:GetInitData().MainUnitList

		for iter0_17, iter1_17 in ipairs(var0_17) do
			arg0_17._dataProxy:SpawnMain(iter1_17, var0_0.Battle.BattleConfig.FRIENDLY_CODE)
		end
	end

	if #arg0_17._userFleet:GetScoutList() == 0 then
		arg0_17._dataProxy:KillAllAirStrike()
		arg0_17._dataProxy:KillAllEnemy()
		arg0_17._dataProxy:CLSBullet(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
		arg0_17._dataProxy:CLSBullet(var0_0.Battle.BattleConfig.FOE_CODE)

		local var1_17 = arg0_17._dataProxy:GetInitData().VanguardUnitList

		for iter2_17, iter3_17 in ipairs(var1_17) do
			arg0_17._dataProxy:SpawnVanguard(iter3_17, var0_0.Battle.BattleConfig.FRIENDLY_CODE)
		end
	end
end

function var3_0.onUnitDying(arg0_18, arg1_18)
	local var0_18 = arg1_18.Dispatcher:GetUniqueID()

	arg0_18._dataProxy:KillUnit(var0_18)
end

function var3_0.onWillDie(arg0_19, arg1_19)
	local var0_19 = arg1_19.Dispatcher

	arg0_19._dataProxy:CalcBattleScoreWhenDead(var0_19)

	local var1_19 = arg0_19._dataProxy:IsThereBoss()

	if var0_19:IsBoss() and not var1_19 then
		arg0_19._dataProxy:KillAllEnemy()
	end
end

function var3_0.onShutDownPlayer(arg0_20, arg1_20)
	local var0_20 = arg1_20.Dispatcher:GetUniqueID()

	arg0_20._dataProxy:ShutdownPlayerUnit(var0_20)
end
