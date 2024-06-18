local var0_0 = class("PreCombatMediator", import("..base.ContextMediator"))

var0_0.ON_START = "PreCombatMediator:ON_START"
var0_0.ON_CHANGE_FLEET = "PreCombatMediator:ON_CHANGE_FLEET"
var0_0.ON_COMMIT_EDIT = "PreCombatMediator:ON_COMMIT_EDIT"
var0_0.ON_ABORT_EDIT = "PreCombatMediator:ON_ABORT_EDIT"
var0_0.OPEN_SHIP_INFO = "PreCombatMediator:OPEN_SHIP_INFO"
var0_0.REMOVE_SHIP = "PreCombatMediator:REMOVE_SHIP"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "PreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.CHANGE_FLEET_SHIP = "PreCombatMediator:CHANGE_FLEET_SHIP"
var0_0.BEGIN_STAGE_PROXY = "PreCombatMediator:BEGIN_STAGE_PROXY"
var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW = "PreCombatMediator:SHOW_CONTINUOUS_OPERATION_WINDOW"
var0_0.CONTINUOUS_OPERATION = "PreCombatMediator:CONTINUOUS_OPERATION"
var0_0.ON_AUTO = "PreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "PreCombatMediator:ON_SUB_AUTO"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()

	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:SetShips(arg0_1.ships)

	local var0_1 = arg0_1.contextData.system
	local var1_1 = getProxy(FleetProxy)
	local var2_1 = var1_1:getData()

	if var1_1.EdittingFleet ~= nil then
		var2_1[var1_1.EdittingFleet.id] = var1_1.EdittingFleet
	end

	arg0_1.fleets = var2_1

	arg0_1.viewComponent:SetFleets(var2_1)

	local var3_1 = getProxy(PlayerProxy)
	local var4_1 = var3_1:getData()

	arg0_1.viewComponent:SetPlayerInfo(var4_1)

	if var0_1 == SYSTEM_DUEL then
		arg0_1.viewComponent:SetCurrentFleet(FleetProxy.PVP_FLEET_ID)
	elseif var0_1 == SYSTEM_SUB_ROUTINE then
		arg0_1.viewComponent:SetStageID(arg0_1.contextData.stageId)
		arg0_1.viewComponent:SetCurrentFleet(arg0_1.contextData.subFleetId)
	else
		arg0_1.viewComponent:SetStageID(arg0_1.contextData.stageId)
		arg0_1.viewComponent:SetCurrentFleet(var3_1.combatFleetId)
	end
end

function var0_0.bindEvent(arg0_2)
	local var0_2 = arg0_2.contextData.system

	arg0_2:bind(var0_0.ON_ABORT_EDIT, function(arg0_3)
		local var0_3 = getProxy(FleetProxy)

		var0_3:abortEditting()
		var0_3:syncFleet()
	end)
	arg0_2:bind(var0_0.ON_CHANGE_FLEET, function(arg0_4, arg1_4)
		arg0_2:changeFleet(arg1_4)
	end)
	arg0_2:bind(var0_0.ON_AUTO, function(arg0_5, arg1_5)
		arg0_2:onAutoBtn(arg1_5)
	end)
	arg0_2:bind(var0_0.ON_SUB_AUTO, function(arg0_6, arg1_6)
		arg0_2:onAutoSubBtn(arg1_6)
	end)
	arg0_2:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_7, arg1_7)
		arg0_2:refreshEdit(arg1_7)
	end)
	arg0_2:bind(var0_0.REMOVE_SHIP, function(arg0_8, arg1_8, arg2_8)
		FormationMediator.removeShipFromFleet(arg2_8, arg1_8)
		arg0_2:refreshEdit(arg2_8)
	end)
	arg0_2:bind(var0_0.OPEN_SHIP_INFO, function(arg0_9, arg1_9, arg2_9)
		arg0_2.contextData.form = PreCombatLayer.FORM_EDIT

		local var0_9 = {}

		for iter0_9, iter1_9 in ipairs(arg2_9:getShipIds()) do
			table.insert(var0_9, arg0_2.ships[iter1_9])
		end

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_9,
			shipVOs = var0_9
		})
	end)
	arg0_2:bind(var0_0.CHANGE_FLEET_SHIP, function(arg0_10, arg1_10, arg2_10, arg3_10)
		assert(arg2_10.id ~= FleetProxy.PVP_FLEET_ID, "fleet type error")

		arg0_2.contextData.form = PreCombatLayer.FORM_EDIT

		FormationMediator.saveEdit()

		local var0_10 = var0_2 == SYSTEM_DUEL
		local var1_10 = var0_10 and ShipStatus.TAG_HIDE_PVP or ShipStatus.TAG_HIDE_NORMAL
		local var2_10 = var0_10 and ShipStatus.TAG_BLOCK_PVP or nil
		local var3_10, var4_10, var5_10 = FormationMediator.getDockCallbackFuncs(arg0_2, arg1_10, arg2_10, arg3_10)
		local var6_10 = {}

		for iter0_10, iter1_10 in ipairs(arg2_10.ships) do
			if not arg1_10 or iter1_10 ~= arg1_10.id then
				table.insert(var6_10, iter1_10)
			end
		end

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = arg1_10 ~= nil,
			teamFilter = arg3_10,
			onShip = var3_10,
			confirmSelect = var4_10,
			onSelected = var5_10,
			hideTagFlags = var1_10,
			blockTagFlags = var2_10,
			otherSelectedIds = var6_10
		})
	end)
	arg0_2:bind(var0_0.ON_COMMIT_EDIT, function(arg0_11, arg1_11)
		arg0_2:commitEdit(arg1_11)
	end)
	arg0_2:bind(var0_0.ON_START, function(arg0_12, arg1_12, arg2_12)
		seriesAsync({
			function(arg0_13)
				if pg.battle_cost_template[var0_2].enter_energy_cost == 0 then
					arg0_13()

					return
				end

				local var0_13
				local var1_13
				local var2_13 = getProxy(FleetProxy):getFleetById(arg1_12)
				local var3_13 = {}

				for iter0_13, iter1_13 in ipairs(var2_13.ships) do
					table.insert(var3_13, getProxy(BayProxy):getShipById(iter1_13))
				end

				local var4_13 = var2_13:GetName()

				Fleet.EnergyCheck(var3_13, var4_13, function(arg0_14)
					if arg0_14 then
						arg0_13()
					end
				end, nil, var1_13)
			end,
			function(arg0_15)
				if arg0_2.contextData.OnConfirm then
					arg0_2.contextData.OnConfirm(arg0_15)
				else
					arg0_15()
				end
			end,
			function()
				arg0_2.viewComponent:emit(var0_0.BEGIN_STAGE_PROXY, {
					curFleetId = arg1_12,
					continuousBattleTimes = arg2_12
				})
			end
		})
	end)

	local function var1_2()
		local var0_17 = 0

		for iter0_17, iter1_17 in ipairs(arg0_2.contextData.fleets) do
			local var1_17 = iter1_17:GetCostSum().oil
			local var2_17 = iter0_17 == 1
			local var3_17 = arg0_2.contextData.costLimit[var2_17 and 1 or 2]

			if var3_17 > 0 then
				var1_17 = math.min(var1_17, var3_17)
			end

			var0_17 = var0_17 + var1_17
		end

		return var0_17
	end

	arg0_2:bind(var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW, function(arg0_18, arg1_18)
		arg0_2:addSubLayers(Context.New({
			mediator = ContinuousOperationWindowMediator,
			viewComponent = ContinuousOperationWindow,
			data = {
				mainFleetId = arg1_18,
				stageId = arg0_2.contextData.stageId,
				system = arg0_2.contextData.system,
				oilCost = var1_2()
			}
		}))
	end)
	arg0_2:bind(var0_0.BEGIN_STAGE_PROXY, function(arg0_19, arg1_19)
		local var0_19

		if arg0_2.contextData.rivalId then
			var0_19 = arg0_2.contextData.rivalId
		else
			var0_19 = arg0_2.contextData.stageId
		end

		arg0_2:sendNotification(GAME.BEGIN_STAGE, {
			stageId = var0_19,
			mainFleetId = arg1_19.curFleetId,
			system = arg0_2.contextData.system,
			actId = arg0_2.contextData.actId,
			rivalId = arg0_2.contextData.rivalId,
			continuousBattleTimes = arg1_19.continuousBattleTimes,
			totalBattleTimes = arg1_19.continuousBattleTimes
		})
	end)
end

function var0_0.changeFleet(arg0_20, arg1_20)
	if arg0_20.contextData.system == SYSTEM_SUB_ROUTINE then
		arg0_20.contextData.subFleetId = arg1_20
	else
		getProxy(PlayerProxy).combatFleetId = arg1_20
	end

	arg0_20.viewComponent:SetCurrentFleet(arg1_20)
	arg0_20.viewComponent:UpdateFleetView(true)
	arg0_20.viewComponent:SetFleetStepper()
end

function var0_0.refreshEdit(arg0_21, arg1_21)
	local var0_21 = getProxy(FleetProxy)

	var0_21.EdittingFleet = arg1_21

	if arg0_21.contextData.system ~= SYSTEM_SUB_ROUTINE then
		local var1_21 = var0_21:getData()

		var1_21[arg1_21.id] = arg1_21

		arg0_21.viewComponent:SetFleets(var1_21)
	end

	arg0_21.viewComponent:UpdateFleetView(false)
end

function var0_0.commitEdit(arg0_22, arg1_22)
	local var0_22 = getProxy(FleetProxy)
	local var1_22 = var0_22.EdittingFleet

	if var1_22 == nil or var1_22:isFirstFleet() or var1_22:isLegalToFight() == true then
		var0_22:commitEdittingFleet(arg1_22)
	elseif #var1_22.ships == 0 then
		var0_22:commitEdittingFleet(arg1_22)

		if arg0_22.contextData.system == SYSTEM_SUB_ROUTINE then
			-- block empty
		else
			arg0_22:changeFleet(1)
		end
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_formationMediaror_trash_warning", var1_22.defaultName),
			onYes = function()
				local var0_23 = getProxy(BayProxy):getRawData()
				local var1_23 = var1_22.ships

				for iter0_23 = #var1_23, 1, -1 do
					var1_22:removeShip(var0_23[var1_23[iter0_23]])
				end

				if var1_22.id == FleetProxy.PVP_FLEET_ID then
					var0_22:commitEdittingFleet()
					arg0_22:changeFleet(FleetProxy.PVP_FLEET_ID)
				else
					var0_22:commitEdittingFleet(arg1_22)
					arg0_22:changeFleet(1)
				end
			end
		})
	end
end

function var0_0.onAutoBtn(arg0_24, arg1_24)
	local var0_24 = arg1_24.isOn
	local var1_24 = arg1_24.toggle

	arg0_24:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_24,
		toggle = var1_24
	})
end

function var0_0.onAutoSubBtn(arg0_25, arg1_25)
	local var0_25 = arg1_25.isOn
	local var1_25 = arg1_25.toggle

	arg0_25:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_25,
		toggle = var1_25
	})
end

function var0_0.listNotificationInterests(arg0_26)
	return {
		GAME.BEGIN_STAGE_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		PreCombatMediator.BEGIN_STAGE_PROXY,
		var0_0.CONTINUOUS_OPERATION
	}
end

function var0_0.handleNotification(arg0_27, arg1_27)
	local var0_27 = arg1_27:getName()
	local var1_27 = arg1_27:getBody()

	if var0_27 == GAME.BEGIN_STAGE_DONE then
		arg0_27:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_27)
	elseif var0_27 == PlayerProxy.UPDATED then
		arg0_27.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0_27 == GAME.BEGIN_STAGE_ERRO then
		if var1_27 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0_27.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0_27 == PreCombatMediator.BEGIN_STAGE_PROXY then
		arg0_27.viewComponent:emit(PreCombatMediator.BEGIN_STAGE_PROXY, var1_27)
	elseif var0_27 == var0_0.CONTINUOUS_OPERATION then
		arg0_27.viewComponent:emit(PreCombatMediator.ON_START, var1_27.mainFleetId, var1_27.battleTimes)
	end
end

return var0_0
