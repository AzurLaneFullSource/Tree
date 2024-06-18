ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleSimulationCommand", var0_0.MVC.Command)

var0_0.Battle.BattleSimulationCommand = var3_0
var3_0.__name = "BattleSimulationCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.ConfigBattleData(arg0_2, arg1_2)
	arg0_2._battleInitData = arg1_2
end

function var3_0.Initialize(arg0_3)
	arg0_3:Init()
	var3_0.super.Initialize(arg0_3)

	arg0_3._dataProxy = arg0_3._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	arg0_3._uiMediator = arg0_3._state:GetMediatorByName(var0_0.Battle.BattleUIMediator.__name)

	arg0_3:InitProtocol()
	arg0_3:AddEvent()
end

function var3_0.DoPrologue(arg0_4)
	arg0_4._dataProxy:InitUserShipsData(arg0_4._battleInitData.RivalMainUnitList, arg0_4._battleInitData.RivalVanguardUnitList, var0_0.Battle.BattleConfig.FOE_CODE, {})
	arg0_4._userFleet:SnapShot()
	arg0_4._rivalFleet:SnapShot()

	arg0_4._rivalWeaponBot = var0_0.Battle.BattleManualWeaponAutoBot.New(arg0_4._rivalFleet)
	arg0_4._rivalJoyStickBot = var0_0.Battle.BattleJoyStickAutoBot.New(arg0_4._dataProxy, arg0_4._rivalFleet)
	arg0_4._buffView = arg0_4._uiMediator:InitSimulationBuffCounting()

	arg0_4._uiMediator:OpeningEffect(function()
		arg0_4._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
		arg0_4._uiMediator:ShowAutoBtn()
		arg0_4._rivalWeaponBot:SetActive(true, false)
		arg0_4._rivalJoyStickBot:SetActive(true)
		arg0_4._uiMediator:ShowTimer()
		arg0_4._uiMediator:ShowSimulationView()
	end)
	arg0_4._userFleet:FleetWarcry()
	arg0_4._dataProxy:InitAllFleetUnitsWeaponCD()
	arg0_4._dataProxy:TirggerBattleStartBuffs()

	local var0_4 = arg0_4._userFleet:GetUnitList()

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var1_4 = var0_0.Battle.BattleBuffUnit.New(var0_0.Battle.BattleConfig.SIMULATION_BALANCE_BUFF)

		iter1_4:AddBuff(var1_4)
	end

	local var2_4 = #arg0_4._rivalFleet:GetScoutList()
	local var3_4 = arg0_4._rivalFleet:GetMainList()
	local var4_4

	if var2_4 == 0 then
		arg0_4:rivalMainUnitPhase()
	elseif var2_4 > 0 then
		local var5_4 = var0_0.Battle.BattleConfig.SIMULATION_ADVANTAGE_BUFF

		arg0_4._rivalDisadvatage = false

		for iter2_4, iter3_4 in ipairs(var3_4) do
			local var6_4 = var0_0.Battle.BattleBuffUnit.New(var5_4)

			iter3_4:AddBuff(var6_4)
		end
	end

	arg0_4:startBuffCount()
	arg0_4._dataProxy:RivalInit(arg0_4._rivalFleet:GetUnitList())
end

function var3_0.Update(arg0_6)
	arg0_6._rivalWeaponBot:Update()
end

function var3_0.Init(arg0_7)
	arg0_7._unitDataList = {}
end

function var3_0.Clear(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8._unitDataList) do
		arg0_8:UnregisterUnitEvent(iter1_8)

		arg0_8._unitDataList[iter0_8] = nil
	end
end

function var3_0.Reinitialize(arg0_9)
	arg0_9._state:Deactive()
	arg0_9:Clear()
	arg0_9:Init()
end

function var3_0.Dispose(arg0_10)
	arg0_10:Clear()
	arg0_10:RemoveEvent()
	var3_0.super.Dispose(arg0_10)
end

function var3_0.onInitBattle(arg0_11)
	arg0_11._weaponCommand = arg0_11._state:GetCommandByName(var0_0.Battle.BattleControllerWeaponCommand.__name)
	arg0_11._userFleet = arg0_11._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
	arg0_11._rivalFleet = arg0_11._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FOE_CODE)
end

function var3_0.InitProtocol(arg0_12)
	return
end

function var3_0.AddEvent(arg0_13)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var2_0.ADD_UNIT, arg0_13.onAddUnit)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var2_0.REMOVE_UNIT, arg0_13.onRemoveUnit)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var2_0.STAGE_DATA_INIT_FINISH, arg0_13.onInitBattle)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var2_0.SHUT_DOWN_PLAYER, arg0_13.onPlayerShutDown)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var2_0.UPDATE_COUNT_DOWN, arg0_13.onUpdateCountDown)
end

function var3_0.RemoveEvent(arg0_14)
	arg0_14._dataProxy:UnregisterEventListener(arg0_14, var2_0.ADD_UNIT)
	arg0_14._dataProxy:UnregisterEventListener(arg0_14, var2_0.REMOVE_UNIT)
	arg0_14._dataProxy:UnregisterEventListener(arg0_14, var2_0.STAGE_DATA_INIT_FINISH)
	arg0_14._dataProxy:UnregisterEventListener(arg0_14, var2_0.SHUT_DOWN_PLAYER)
	arg0_14._dataProxy:UnregisterEventListener(arg0_14, var2_0.UPDATE_COUNT_DOWN)
end

function var3_0.onAddUnit(arg0_15, arg1_15)
	local var0_15 = arg1_15.Data.type
	local var1_15 = arg1_15.Data.unit

	arg0_15:RegisterUnitEvent(var1_15)

	arg0_15._unitDataList[var1_15:GetUniqueID()] = var1_15
end

function var3_0.RegisterUnitEvent(arg0_16, arg1_16)
	arg1_16:RegisterEventListener(arg0_16, var1_0.DYING, arg0_16.onUnitDying)
	arg1_16:RegisterEventListener(arg0_16, var1_0.UPDATE_HP, arg0_16.onUpdateUnitHP)

	if arg1_16:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_16:RegisterEventListener(arg0_16, var1_0.SHUT_DOWN_PLAYER, arg0_16.onShutDownPlayer)
	end
end

function var3_0.UnregisterUnitEvent(arg0_17, arg1_17)
	arg1_17:UnregisterEventListener(arg0_17, var1_0.DYING)
	arg1_17:UnregisterEventListener(arg0_17, var1_0.UPDATE_HP)

	if arg1_17:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_17:UnregisterEventListener(arg0_17, var1_0.SHUT_DOWN_PLAYER)
	end
end

function var3_0.onRemoveUnit(arg0_18, arg1_18)
	local var0_18 = arg1_18.Data.UID
	local var1_18 = arg0_18._unitDataList[var0_18]

	if var1_18 == nil then
		return
	end

	arg0_18:UnregisterUnitEvent(var1_18)

	arg0_18._unitDataList[var0_18] = nil
end

function var3_0.onPlayerShutDown(arg0_19, arg1_19)
	if arg0_19._state:GetState() ~= arg0_19._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg0_19._failReason == nil then
		var0_0.Battle.BattleState.GenerateVertifyData(1)

		local var0_19, var1_19 = var0_0.Battle.BattleState.Vertify()

		if not var0_19 then
			arg0_19._failReason = 900 + var1_19
		end
	end

	if #arg0_19._rivalFleet:GetUnitList() == 0 then
		arg0_19._dataProxy:CalcSimulationScoreAtEnd(arg0_19._userFleet, arg0_19._rivalFleet)

		if arg0_19._failReason then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_19._failReason
			})

			return
		end

		arg0_19._failReason = nil

		arg0_19._state:BattleEnd()
	end

	if arg1_19.Data.unit == arg0_19._userFleet:GetFlagShip() then
		arg0_19._dataProxy:CalcSimulationScoreAtEnd(arg0_19._userFleet, arg0_19._rivalFleet)
		arg0_19._state:BattleEnd()

		return
	end

	if #arg0_19._userFleet:GetScoutList() == 0 then
		arg0_19._dataProxy:CalcSimulationScoreAtEnd(arg0_19._userFleet, arg0_19._rivalFleet)
		arg0_19._state:BattleEnd()
	end

	if #arg0_19._rivalFleet:GetScoutList() == 0 and not arg0_19._rivalDisadvatage then
		arg0_19:rivalMainUnitPhase()
	end
end

function var3_0.rivalMainUnitPhase(arg0_20)
	arg0_20:startBuffCount()

	arg0_20._rivalDisadvatage = true

	arg0_20._rivalJoyStickBot:SetActive(false)
	arg0_20._rivalFleet:FreeMainUnit(var0_0.Battle.BattleConfig.SIMULATION_FREE_BUFF)

	local var0_20 = arg0_20._rivalFleet:GetMainList()

	for iter0_20, iter1_20 in ipairs(var0_20) do
		for iter2_20, iter3_20 in ipairs(var0_0.Battle.BattleConfig.SIMULATION_ADVANTAGE_CANCEL_LIST) do
			iter1_20:RemoveBuff(iter3_20)
		end

		local var1_20 = var0_0.Battle.BattleBuffUnit.New(var0_0.Battle.BattleConfig.SIMULATION_DISADVANTAGE_BUFF)

		iter1_20:AddBuff(var1_20)
	end
end

function var3_0.onUpdateCountDown(arg0_21, arg1_21)
	local var0_21 = arg0_21._dataProxy:GetCountDown()

	if arg0_21._buffStartTime then
		local var1_21 = var0_0.Battle.BattleConfig.SIMULATION_RIVAL_RAGE_TOTAL_COUNT - (arg0_21._buffStartTime - var0_21)

		if var1_21 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("simulation_enhancing"))

			arg0_21._buffStartTime = nil

			arg0_21._buffView:SetEnhancedText()
		else
			arg0_21._buffView:SetCountDownText(var1_21)
		end
	end

	if var0_21 <= 0 then
		local var2_21, var3_21 = arg0_21._userFleet:GetDamageRatioResult()
		local var4_21, var5_21 = arg0_21._rivalFleet:GetDamageRatioResult()

		arg0_21._dataProxy:CalcSimulationScoreAtTimesUp(var2_21, var4_21, var3_21, var5_21, arg0_21._rivalFleet)
		arg0_21._state:BattleEnd()
	end
end

function var3_0.onUpdateUnitHP(arg0_22, arg1_22)
	local var0_22 = arg1_22.Dispatcher:GetFleetVO()

	if var0_22 then
		local var1_22 = arg1_22.Data.validDHP

		var0_22:UpdateFleetDamage(var1_22)
	end
end

function var3_0.onUnitDying(arg0_23, arg1_23)
	local var0_23 = arg1_23.Dispatcher
	local var1_23 = var0_23:GetUniqueID()

	arg0_23._dataProxy:CalcBattleScoreWhenDead(var0_23)
	arg0_23._dataProxy:KillUnit(var1_23)
end

function var3_0.onShutDownPlayer(arg0_24, arg1_24)
	local var0_24 = arg1_24.Dispatcher
	local var1_24 = var0_24:GetUniqueID()

	var0_24:GetFleetVO():UpdateFleetOverDamage(var0_24)
	arg0_24._dataProxy:ShutdownPlayerUnit(var1_24)
end

function var3_0.startBuffCount(arg0_25)
	arg0_25._buffStartTime = arg0_25._dataProxy:GetCountDown()
end
