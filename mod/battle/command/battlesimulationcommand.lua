ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleSimulationCommand", var0.MVC.Command)

var0.Battle.BattleSimulationCommand = var3
var3.__name = "BattleSimulationCommand"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.ConfigBattleData(arg0, arg1)
	arg0._battleInitData = arg1
end

function var3.Initialize(arg0)
	arg0:Init()
	var3.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)
	arg0._uiMediator = arg0._state:GetMediatorByName(var0.Battle.BattleUIMediator.__name)

	arg0:InitProtocol()
	arg0:AddEvent()
end

function var3.DoPrologue(arg0)
	arg0._dataProxy:InitUserShipsData(arg0._battleInitData.RivalMainUnitList, arg0._battleInitData.RivalVanguardUnitList, var0.Battle.BattleConfig.FOE_CODE, {})
	arg0._userFleet:SnapShot()
	arg0._rivalFleet:SnapShot()

	arg0._rivalWeaponBot = var0.Battle.BattleManualWeaponAutoBot.New(arg0._rivalFleet)
	arg0._rivalJoyStickBot = var0.Battle.BattleJoyStickAutoBot.New(arg0._dataProxy, arg0._rivalFleet)
	arg0._buffView = arg0._uiMediator:InitSimulationBuffCounting()

	arg0._uiMediator:OpeningEffect(function()
		arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
		arg0._uiMediator:ShowAutoBtn()
		arg0._rivalWeaponBot:SetActive(true, false)
		arg0._rivalJoyStickBot:SetActive(true)
		arg0._uiMediator:ShowTimer()
		arg0._uiMediator:ShowSimulationView()
	end)
	arg0._userFleet:FleetWarcry()
	arg0._dataProxy:InitAllFleetUnitsWeaponCD()
	arg0._dataProxy:TirggerBattleStartBuffs()

	local var0 = arg0._userFleet:GetUnitList()

	for iter0, iter1 in ipairs(var0) do
		local var1 = var0.Battle.BattleBuffUnit.New(var0.Battle.BattleConfig.SIMULATION_BALANCE_BUFF)

		iter1:AddBuff(var1)
	end

	local var2 = #arg0._rivalFleet:GetScoutList()
	local var3 = arg0._rivalFleet:GetMainList()
	local var4

	if var2 == 0 then
		arg0:rivalMainUnitPhase()
	elseif var2 > 0 then
		local var5 = var0.Battle.BattleConfig.SIMULATION_ADVANTAGE_BUFF

		arg0._rivalDisadvatage = false

		for iter2, iter3 in ipairs(var3) do
			local var6 = var0.Battle.BattleBuffUnit.New(var5)

			iter3:AddBuff(var6)
		end
	end

	arg0:startBuffCount()
	arg0._dataProxy:RivalInit(arg0._rivalFleet:GetUnitList())
end

function var3.Update(arg0)
	arg0._rivalWeaponBot:Update()
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
	arg0:Clear()
	arg0:RemoveEvent()
	var3.super.Dispose(arg0)
end

function var3.onInitBattle(arg0)
	arg0._weaponCommand = arg0._state:GetCommandByName(var0.Battle.BattleControllerWeaponCommand.__name)
	arg0._userFleet = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)
	arg0._rivalFleet = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FOE_CODE)
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
end

function var3.RegisterUnitEvent(arg0, arg1)
	arg1:RegisterEventListener(arg0, var1.DYING, arg0.onUnitDying)
	arg1:RegisterEventListener(arg0, var1.UPDATE_HP, arg0.onUpdateUnitHP)

	if arg1:GetUnitType() == var0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1:RegisterEventListener(arg0, var1.SHUT_DOWN_PLAYER, arg0.onShutDownPlayer)
	end
end

function var3.UnregisterUnitEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var1.DYING)
	arg1:UnregisterEventListener(arg0, var1.UPDATE_HP)

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
	if arg0._state:GetState() ~= arg0._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg0._failReason == nil then
		var0.Battle.BattleState.GenerateVertifyData(1)

		local var0, var1 = var0.Battle.BattleState.Vertify()

		if not var0 then
			arg0._failReason = 900 + var1
		end
	end

	if #arg0._rivalFleet:GetUnitList() == 0 then
		arg0._dataProxy:CalcSimulationScoreAtEnd(arg0._userFleet, arg0._rivalFleet)

		if arg0._failReason then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0._failReason
			})

			return
		end

		arg0._failReason = nil

		arg0._state:BattleEnd()
	end

	if arg1.Data.unit == arg0._userFleet:GetFlagShip() then
		arg0._dataProxy:CalcSimulationScoreAtEnd(arg0._userFleet, arg0._rivalFleet)
		arg0._state:BattleEnd()

		return
	end

	if #arg0._userFleet:GetScoutList() == 0 then
		arg0._dataProxy:CalcSimulationScoreAtEnd(arg0._userFleet, arg0._rivalFleet)
		arg0._state:BattleEnd()
	end

	if #arg0._rivalFleet:GetScoutList() == 0 and not arg0._rivalDisadvatage then
		arg0:rivalMainUnitPhase()
	end
end

function var3.rivalMainUnitPhase(arg0)
	arg0:startBuffCount()

	arg0._rivalDisadvatage = true

	arg0._rivalJoyStickBot:SetActive(false)
	arg0._rivalFleet:FreeMainUnit(var0.Battle.BattleConfig.SIMULATION_FREE_BUFF)

	local var0 = arg0._rivalFleet:GetMainList()

	for iter0, iter1 in ipairs(var0) do
		for iter2, iter3 in ipairs(var0.Battle.BattleConfig.SIMULATION_ADVANTAGE_CANCEL_LIST) do
			iter1:RemoveBuff(iter3)
		end

		local var1 = var0.Battle.BattleBuffUnit.New(var0.Battle.BattleConfig.SIMULATION_DISADVANTAGE_BUFF)

		iter1:AddBuff(var1)
	end
end

function var3.onUpdateCountDown(arg0, arg1)
	local var0 = arg0._dataProxy:GetCountDown()

	if arg0._buffStartTime then
		local var1 = var0.Battle.BattleConfig.SIMULATION_RIVAL_RAGE_TOTAL_COUNT - (arg0._buffStartTime - var0)

		if var1 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("simulation_enhancing"))

			arg0._buffStartTime = nil

			arg0._buffView:SetEnhancedText()
		else
			arg0._buffView:SetCountDownText(var1)
		end
	end

	if var0 <= 0 then
		local var2, var3 = arg0._userFleet:GetDamageRatioResult()
		local var4, var5 = arg0._rivalFleet:GetDamageRatioResult()

		arg0._dataProxy:CalcSimulationScoreAtTimesUp(var2, var4, var3, var5, arg0._rivalFleet)
		arg0._state:BattleEnd()
	end
end

function var3.onUpdateUnitHP(arg0, arg1)
	local var0 = arg1.Dispatcher:GetFleetVO()

	if var0 then
		local var1 = arg1.Data.validDHP

		var0:UpdateFleetDamage(var1)
	end
end

function var3.onUnitDying(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = var0:GetUniqueID()

	arg0._dataProxy:CalcBattleScoreWhenDead(var0)
	arg0._dataProxy:KillUnit(var1)
end

function var3.onShutDownPlayer(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = var0:GetUniqueID()

	var0:GetFleetVO():UpdateFleetOverDamage(var0)
	arg0._dataProxy:ShutdownPlayerUnit(var1)
end

function var3.startBuffCount(arg0)
	arg0._buffStartTime = arg0._dataProxy:GetCountDown()
end
