ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleDuelArenaCommand", var0.MVC.Command)

var0.Battle.BattleDuelArenaCommand = var3
var3.__name = "BattleDuelArenaCommand"

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

	local var0 = arg0._uiMediator:InitDuelRateBar()
	local var1 = getProxy(PlayerProxy):getData()

	var0:SetFleetVO(arg0._userFleet, {
		name = var1.name,
		level = var1.level
	})

	local var2 = arg0._dataProxy:GetInitData().RivalVO

	var0:SetFleetVO(arg0._rivalFleet, {
		name = var2.name,
		level = var2.level
	})
	arg0._uiMediator:OpeningEffect(function()
		arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
		arg0._weaponCommand:ActiveBot(true, false)
		arg0._rivalWeaponBot:SetActive(true, false)
		arg0._rivalJoyStickBot:SetActive(true)
		arg0._uiMediator:InitCameraGestureSlider()
		arg0._uiMediator:ShowTimer()
		arg0._uiMediator:ShowDuelBar()
		arg0._uiMediator:EnableJoystick(false)
		arg0._uiMediator:EnableWeaponButton(false)
	end)

	local var3 = arg0._dataProxy:GetFleetList()

	for iter0, iter1 in pairs(var3) do
		iter1:FleetWarcry()

		local var4 = iter1:GetUnitList()

		for iter2, iter3 in ipairs(var4) do
			local var5 = iter3:GetTemplate().type
			local var6 = var0.Battle.BattleDataFunction.GetArenaBuffByShipType(var5)

			for iter4, iter5 in ipairs(var6) do
				local var7 = var0.Battle.BattleBuffUnit.New(iter5)

				iter3:AddBuff(var7)
			end
		end
	end

	arg0._uiMediator:EnableWeaponButton(false)
	arg0._dataProxy:InitAllFleetUnitsWeaponCD()
	arg0._dataProxy:TirggerBattleStartBuffs()

	local var8 = arg0._userFleet:GetUnitList()

	for iter6, iter7 in ipairs(var8) do
		local var9 = var0.Battle.BattleBuffUnit.New(var0.Battle.BattleConfig.DULE_BALANCE_BUFF)

		iter7:AddBuff(var9)
	end
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

	if #arg0._userFleet:GetUnitList() == 0 or #arg0._rivalFleet:GetUnitList() == 0 then
		arg0._dataProxy:CalcDuelScoreAtEnd(arg0._userFleet, arg0._rivalFleet)

		if arg0._failReason then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0._failReason
			})

			return
		end

		arg0._failReason = nil

		arg0._state:BattleEnd()
	end

	local var2 = #arg0._userFleet:GetScoutList()
	local var3 = #arg0._rivalFleet:GetScoutList()

	if var2 == 0 and var3 ~= 0 then
		arg0._dataProxy:ShiftFleetBound(arg0._rivalFleet, var0.Battle.BattleConfig.FRIENDLY_CODE)
		arg0._rivalJoyStickBot:UpdateFleetArea()
		arg0._rivalJoyStickBot:SwitchStrategy(var0.Battle.BattleJoyStickAutoBot.COUNTER_MAIN)
	end

	if var3 == 0 and var2 ~= 0 then
		arg0._dataProxy:ShiftFleetBound(arg0._userFleet, var0.Battle.BattleConfig.FOE_CODE)
		arg0._weaponCommand:GetStickBot():UpdateFleetArea()
		arg0._weaponCommand:GetStickBot():SwitchStrategy(var0.Battle.BattleJoyStickAutoBot.COUNTER_MAIN)
	end

	if not arg1.Data.unit:IsMainFleetUnit() and var2 == 0 and var3 == 0 then
		local var4 = arg0._userFleet:GetMainList()
		local var5 = arg0._rivalFleet:GetMainList()

		for iter0, iter1 in ipairs(var4) do
			local var6 = var0.Battle.BattleBuffUnit.New(var0.Battle.BattleConfig.DUEL_MAIN_RAGE_BUFF)

			iter1:AddBuff(var6)
		end

		for iter2, iter3 in ipairs(var5) do
			local var7 = var0.Battle.BattleBuffUnit.New(var0.Battle.BattleConfig.DUEL_MAIN_RAGE_BUFF)

			iter3:AddBuff(var7)
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_duel_main_rage"))
	end
end

function var3.onUpdateCountDown(arg0, arg1)
	if arg0._dataProxy:GetCountDown() <= 0 then
		local var0, var1 = arg0._userFleet:GetDamageRatioResult()
		local var2, var3 = arg0._rivalFleet:GetDamageRatioResult()

		arg0._dataProxy:CalcDuelScoreAtTimesUp(var0, var2, var1, var3)
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

	if var0:GetUnitType() ~= var0.Battle.BattleConst.UnitType.MINION_UNIT then
		arg0._dataProxy:CalcBattleScoreWhenDead(var0)
	end

	arg0._dataProxy:KillUnit(var1)
end

function var3.onShutDownPlayer(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = var0:GetUniqueID()

	var0:GetFleetVO():UpdateFleetOverDamage(var0)
	arg0._dataProxy:ShutdownPlayerUnit(var1)
end
