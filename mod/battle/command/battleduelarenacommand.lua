ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleDuelArenaCommand", var0_0.MVC.Command)

var0_0.Battle.BattleDuelArenaCommand = var3_0
var3_0.__name = "BattleDuelArenaCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.Initialize(arg0_2)
	arg0_2:Init()
	var3_0.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	arg0_2._uiMediator = arg0_2._state:GetMediatorByName(var0_0.Battle.BattleUIMediator.__name)

	arg0_2:InitProtocol()
	arg0_2:AddEvent()
end

function var3_0.DoPrologue(arg0_3)
	local var0_3 = arg0_3._dataProxy:GetInitData()

	arg0_3._dataProxy:InitUserShipsData(var0_3.RivalMainUnitList, var0_3.RivalVanguardUnitList, var0_0.Battle.BattleConfig.FOE_CODE, {})
	arg0_3._userFleet:SnapShot()
	arg0_3._rivalFleet:SnapShot()

	arg0_3._rivalWeaponBot = var0_0.Battle.BattleManualWeaponAutoBot.New(arg0_3._rivalFleet)
	arg0_3._rivalJoyStickBot = var0_0.Battle.BattleJoyStickAutoBot.New(arg0_3._dataProxy, arg0_3._rivalFleet)

	arg0_3._rivalJoyStickBot:SwitchStrategy(arg0_3._rivalJoyStickBot.RANDOM)

	local var1_3 = arg0_3._uiMediator:InitDuelRateBar()
	local var2_3 = getProxy(PlayerProxy):getData()

	var1_3:SetFleetVO(arg0_3._userFleet, {
		name = var2_3.name,
		level = var2_3.level
	})

	local var3_3 = arg0_3._dataProxy:GetInitData().RivalVO

	var1_3:SetFleetVO(arg0_3._rivalFleet, {
		name = var3_3.name,
		level = var3_3.level
	})
	arg0_3._dataProxy:AutoStatistics(1)
	arg0_3._uiMediator:OpeningEffect(function()
		arg0_3._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
		arg0_3._weaponCommand:ActiveBot(true, false)
		arg0_3._rivalWeaponBot:SetActive(true, false)
		arg0_3._rivalJoyStickBot:SetActive(true)
		arg0_3._uiMediator:InitCameraGestureSlider()
		arg0_3._uiMediator:ShowTimer()
		arg0_3._uiMediator:ShowDuelBar()
		arg0_3._uiMediator:EnableJoystick(false)
		arg0_3._uiMediator:EnableWeaponButton(false)
	end)

	local var4_3 = arg0_3._dataProxy:GetFleetList()

	for iter0_3, iter1_3 in pairs(var4_3) do
		iter1_3:FleetWarcry()

		local var5_3 = iter1_3:GetUnitList()

		for iter2_3, iter3_3 in ipairs(var5_3) do
			local var6_3 = iter3_3:GetTemplate().type
			local var7_3 = var0_0.Battle.BattleDataFunction.GetArenaBuffByShipType(var6_3)

			for iter4_3, iter5_3 in ipairs(var7_3) do
				local var8_3 = var0_0.Battle.BattleBuffUnit.New(iter5_3)

				iter3_3:AddBuff(var8_3)
			end
		end
	end

	arg0_3._uiMediator:EnableWeaponButton(false)
	arg0_3._dataProxy:InitAllFleetUnitsWeaponCD()
	arg0_3._dataProxy:TirggerBattleStartBuffs()

	local var9_3 = arg0_3._userFleet:GetUnitList()

	for iter6_3, iter7_3 in ipairs(var9_3) do
		local var10_3 = var0_0.Battle.BattleBuffUnit.New(var0_0.Battle.BattleConfig.DULE_BALANCE_BUFF)

		iter7_3:AddBuff(var10_3)
	end
end

function var3_0.Update(arg0_5)
	arg0_5._rivalWeaponBot:Update()
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
	arg0_9:Clear()
	arg0_9:RemoveEvent()
	var3_0.super.Dispose(arg0_9)
end

function var3_0.onInitBattle(arg0_10)
	arg0_10._weaponCommand = arg0_10._state:GetCommandByName(var0_0.Battle.BattleControllerWeaponCommand.__name)
	arg0_10._userFleet = arg0_10._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
	arg0_10._rivalFleet = arg0_10._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FOE_CODE)
end

function var3_0.InitProtocol(arg0_11)
	return
end

function var3_0.AddEvent(arg0_12)
	arg0_12._dataProxy:RegisterEventListener(arg0_12, var2_0.ADD_UNIT, arg0_12.onAddUnit)
	arg0_12._dataProxy:RegisterEventListener(arg0_12, var2_0.REMOVE_UNIT, arg0_12.onRemoveUnit)
	arg0_12._dataProxy:RegisterEventListener(arg0_12, var2_0.STAGE_DATA_INIT_FINISH, arg0_12.onInitBattle)
	arg0_12._dataProxy:RegisterEventListener(arg0_12, var2_0.SHUT_DOWN_PLAYER, arg0_12.onPlayerShutDown)
	arg0_12._dataProxy:RegisterEventListener(arg0_12, var2_0.UPDATE_COUNT_DOWN, arg0_12.onUpdateCountDown)
end

function var3_0.RemoveEvent(arg0_13)
	arg0_13._dataProxy:UnregisterEventListener(arg0_13, var2_0.ADD_UNIT)
	arg0_13._dataProxy:UnregisterEventListener(arg0_13, var2_0.REMOVE_UNIT)
	arg0_13._dataProxy:UnregisterEventListener(arg0_13, var2_0.STAGE_DATA_INIT_FINISH)
	arg0_13._dataProxy:UnregisterEventListener(arg0_13, var2_0.SHUT_DOWN_PLAYER)
	arg0_13._dataProxy:UnregisterEventListener(arg0_13, var2_0.UPDATE_COUNT_DOWN)
end

function var3_0.onAddUnit(arg0_14, arg1_14)
	local var0_14 = arg1_14.Data.type
	local var1_14 = arg1_14.Data.unit

	arg0_14:RegisterUnitEvent(var1_14)

	arg0_14._unitDataList[var1_14:GetUniqueID()] = var1_14
end

function var3_0.RegisterUnitEvent(arg0_15, arg1_15)
	arg1_15:RegisterEventListener(arg0_15, var1_0.DYING, arg0_15.onUnitDying)
	arg1_15:RegisterEventListener(arg0_15, var1_0.UPDATE_HP, arg0_15.onUpdateUnitHP)

	if arg1_15:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_15:RegisterEventListener(arg0_15, var1_0.SHUT_DOWN_PLAYER, arg0_15.onShutDownPlayer)
	end
end

function var3_0.UnregisterUnitEvent(arg0_16, arg1_16)
	arg1_16:UnregisterEventListener(arg0_16, var1_0.DYING)
	arg1_16:UnregisterEventListener(arg0_16, var1_0.UPDATE_HP)

	if arg1_16:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_16:UnregisterEventListener(arg0_16, var1_0.SHUT_DOWN_PLAYER)
	end
end

function var3_0.onRemoveUnit(arg0_17, arg1_17)
	local var0_17 = arg1_17.Data.UID
	local var1_17 = arg0_17._unitDataList[var0_17]

	if var1_17 == nil then
		return
	end

	arg0_17:UnregisterUnitEvent(var1_17)

	arg0_17._unitDataList[var0_17] = nil
end

function var3_0.onPlayerShutDown(arg0_18, arg1_18)
	if arg0_18._state:GetState() ~= arg0_18._state.BATTLE_STATE_FIGHT then
		return
	end

	if arg0_18._failReason == nil then
		var0_0.Battle.BattleState.GenerateVertifyData(1)

		local var0_18, var1_18 = var0_0.Battle.BattleState.Vertify()

		if not var0_18 then
			arg0_18._failReason = 900 + var1_18
		end
	end

	if #arg0_18._userFleet:GetUnitList() == 0 or #arg0_18._rivalFleet:GetUnitList() == 0 then
		arg0_18._dataProxy:CalcDuelScoreAtEnd(arg0_18._userFleet, arg0_18._rivalFleet)

		if arg0_18._failReason then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_18._failReason
			})

			return
		end

		arg0_18._failReason = nil

		arg0_18._dataProxy:TriggerFinishBattle()
		arg0_18._state:BattleEnd()
	end

	local var2_18 = #arg0_18._userFleet:GetScoutList()
	local var3_18 = #arg0_18._rivalFleet:GetScoutList()

	if var2_18 == 0 and var3_18 ~= 0 then
		arg0_18._dataProxy:ShiftFleetBound(arg0_18._rivalFleet, var0_0.Battle.BattleConfig.FRIENDLY_CODE)
		arg0_18._rivalJoyStickBot:UpdateFleetArea()
		arg0_18._rivalJoyStickBot:SwitchStrategy(var0_0.Battle.BattleJoyStickAutoBot.COUNTER_MAIN)
	end

	if var3_18 == 0 and var2_18 ~= 0 then
		arg0_18._dataProxy:ShiftFleetBound(arg0_18._userFleet, var0_0.Battle.BattleConfig.FOE_CODE)
		arg0_18._weaponCommand:GetStickBot():UpdateFleetArea()
		arg0_18._weaponCommand:GetStickBot():SwitchStrategy(var0_0.Battle.BattleJoyStickAutoBot.COUNTER_MAIN)
	end

	if not arg1_18.Data.unit:IsMainFleetUnit() and var2_18 == 0 and var3_18 == 0 then
		local var4_18 = arg0_18._userFleet:GetMainList()
		local var5_18 = arg0_18._rivalFleet:GetMainList()

		for iter0_18, iter1_18 in ipairs(var4_18) do
			local var6_18 = var0_0.Battle.BattleBuffUnit.New(var0_0.Battle.BattleConfig.DUEL_MAIN_RAGE_BUFF)

			iter1_18:AddBuff(var6_18)
		end

		for iter2_18, iter3_18 in ipairs(var5_18) do
			local var7_18 = var0_0.Battle.BattleBuffUnit.New(var0_0.Battle.BattleConfig.DUEL_MAIN_RAGE_BUFF)

			iter3_18:AddBuff(var7_18)
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_duel_main_rage"))
	end
end

function var3_0.onUpdateCountDown(arg0_19, arg1_19)
	if arg0_19._dataProxy:GetCountDown() <= 0 then
		local var0_19, var1_19 = arg0_19._userFleet:GetDamageRatioResult()
		local var2_19, var3_19 = arg0_19._rivalFleet:GetDamageRatioResult()

		arg0_19._dataProxy:TriggerFinishBattle()
		arg0_19._dataProxy:CalcDuelScoreAtTimesUp(var0_19, var2_19, var1_19, var3_19)
		arg0_19._state:BattleEnd()
	end
end

function var3_0.onUpdateUnitHP(arg0_20, arg1_20)
	local var0_20 = arg1_20.Dispatcher:GetFleetVO()

	if var0_20 then
		local var1_20 = arg1_20.Data.validDHP

		var0_20:UpdateFleetDamage(var1_20)
	end
end

function var3_0.onUnitDying(arg0_21, arg1_21)
	local var0_21 = arg1_21.Dispatcher
	local var1_21 = var0_21:GetUniqueID()

	if var0_21:GetUnitType() ~= var0_0.Battle.BattleConst.UnitType.MINION_UNIT then
		arg0_21._dataProxy:CalcBattleScoreWhenDead(var0_21)
	end

	arg0_21._dataProxy:KillUnit(var1_21)
end

function var3_0.onShutDownPlayer(arg0_22, arg1_22)
	local var0_22 = arg1_22.Dispatcher
	local var1_22 = var0_22:GetUniqueID()

	var0_22:GetFleetVO():UpdateFleetOverDamage(var0_22)
	arg0_22._dataProxy:ShutdownPlayerUnit(var1_22)
end
