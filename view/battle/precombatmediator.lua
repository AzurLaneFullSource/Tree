local var0 = class("PreCombatMediator", import("..base.ContextMediator"))

var0.ON_START = "PreCombatMediator:ON_START"
var0.ON_CHANGE_FLEET = "PreCombatMediator:ON_CHANGE_FLEET"
var0.ON_COMMIT_EDIT = "PreCombatMediator:ON_COMMIT_EDIT"
var0.ON_ABORT_EDIT = "PreCombatMediator:ON_ABORT_EDIT"
var0.OPEN_SHIP_INFO = "PreCombatMediator:OPEN_SHIP_INFO"
var0.REMOVE_SHIP = "PreCombatMediator:REMOVE_SHIP"
var0.CHANGE_FLEET_SHIPS_ORDER = "PreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0.CHANGE_FLEET_SHIP = "PreCombatMediator:CHANGE_FLEET_SHIP"
var0.BEGIN_STAGE_PROXY = "PreCombatMediator:BEGIN_STAGE_PROXY"
var0.SHOW_CONTINUOUS_OPERATION_WINDOW = "PreCombatMediator:SHOW_CONTINUOUS_OPERATION_WINDOW"
var0.CONTINUOUS_OPERATION = "PreCombatMediator:CONTINUOUS_OPERATION"
var0.ON_AUTO = "PreCombatMediator:ON_AUTO"
var0.ON_SUB_AUTO = "PreCombatMediator:ON_SUB_AUTO"

function var0.register(arg0)
	arg0:bindEvent()

	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:SetShips(arg0.ships)

	local var0 = arg0.contextData.system
	local var1 = getProxy(FleetProxy)
	local var2 = var1:getData()

	if var1.EdittingFleet ~= nil then
		var2[var1.EdittingFleet.id] = var1.EdittingFleet
	end

	arg0.fleets = var2

	arg0.viewComponent:SetFleets(var2)

	local var3 = getProxy(PlayerProxy)
	local var4 = var3:getData()

	arg0.viewComponent:SetPlayerInfo(var4)

	if var0 == SYSTEM_DUEL then
		arg0.viewComponent:SetCurrentFleet(FleetProxy.PVP_FLEET_ID)
	elseif var0 == SYSTEM_SUB_ROUTINE then
		arg0.viewComponent:SetStageID(arg0.contextData.stageId)
		arg0.viewComponent:SetCurrentFleet(arg0.contextData.subFleetId)
	else
		arg0.viewComponent:SetStageID(arg0.contextData.stageId)
		arg0.viewComponent:SetCurrentFleet(var3.combatFleetId)
	end
end

function var0.bindEvent(arg0)
	local var0 = arg0.contextData.system

	arg0:bind(var0.ON_ABORT_EDIT, function(arg0)
		local var0 = getProxy(FleetProxy)

		var0:abortEditting()
		var0:syncFleet()
	end)
	arg0:bind(var0.ON_CHANGE_FLEET, function(arg0, arg1)
		arg0:changeFleet(arg1)
	end)
	arg0:bind(var0.ON_AUTO, function(arg0, arg1)
		arg0:onAutoBtn(arg1)
	end)
	arg0:bind(var0.ON_SUB_AUTO, function(arg0, arg1)
		arg0:onAutoSubBtn(arg1)
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIPS_ORDER, function(arg0, arg1)
		arg0:refreshEdit(arg1)
	end)
	arg0:bind(var0.REMOVE_SHIP, function(arg0, arg1, arg2)
		FormationMediator.removeShipFromFleet(arg2, arg1)
		arg0:refreshEdit(arg2)
	end)
	arg0:bind(var0.OPEN_SHIP_INFO, function(arg0, arg1, arg2)
		arg0.contextData.form = PreCombatLayer.FORM_EDIT

		local var0 = {}

		for iter0, iter1 in ipairs(arg2:getShipIds()) do
			table.insert(var0, arg0.ships[iter1])
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1,
			shipVOs = var0
		})
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIP, function(arg0, arg1, arg2, arg3)
		assert(arg2.id ~= FleetProxy.PVP_FLEET_ID, "fleet type error")

		arg0.contextData.form = PreCombatLayer.FORM_EDIT

		FormationMediator.saveEdit()

		local var0 = var0 == SYSTEM_DUEL
		local var1 = var0 and ShipStatus.TAG_HIDE_PVP or ShipStatus.TAG_HIDE_NORMAL
		local var2 = var0 and ShipStatus.TAG_BLOCK_PVP or nil
		local var3, var4, var5 = FormationMediator.getDockCallbackFuncs(arg0, arg1, arg2, arg3)
		local var6 = {}

		for iter0, iter1 in ipairs(arg2.ships) do
			if not arg1 or iter1 ~= arg1.id then
				table.insert(var6, iter1)
			end
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = arg1 ~= nil,
			teamFilter = arg3,
			onShip = var3,
			confirmSelect = var4,
			onSelected = var5,
			hideTagFlags = var1,
			blockTagFlags = var2,
			otherSelectedIds = var6
		})
	end)
	arg0:bind(var0.ON_COMMIT_EDIT, function(arg0, arg1)
		arg0:commitEdit(arg1)
	end)
	arg0:bind(var0.ON_START, function(arg0, arg1, arg2)
		seriesAsync({
			function(arg0)
				if pg.battle_cost_template[var0].enter_energy_cost == 0 then
					arg0()

					return
				end

				local var0
				local var1
				local var2 = getProxy(FleetProxy):getFleetById(arg1)
				local var3 = {}

				for iter0, iter1 in ipairs(var2.ships) do
					table.insert(var3, getProxy(BayProxy):getShipById(iter1))
				end

				local var4 = var2:GetName()

				Fleet.EnergyCheck(var3, var4, function(arg0)
					if arg0 then
						arg0()
					end
				end, nil, var1)
			end,
			function(arg0)
				if arg0.contextData.OnConfirm then
					arg0.contextData.OnConfirm(arg0)
				else
					arg0()
				end
			end,
			function()
				arg0.viewComponent:emit(var0.BEGIN_STAGE_PROXY, {
					curFleetId = arg1,
					continuousBattleTimes = arg2
				})
			end
		})
	end)

	local function var1()
		local var0 = 0

		for iter0, iter1 in ipairs(arg0.contextData.fleets) do
			local var1 = iter1:GetCostSum().oil
			local var2 = iter0 == 1
			local var3 = arg0.contextData.costLimit[var2 and 1 or 2]

			if var3 > 0 then
				var1 = math.min(var1, var3)
			end

			var0 = var0 + var1
		end

		return var0
	end

	arg0:bind(var0.SHOW_CONTINUOUS_OPERATION_WINDOW, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ContinuousOperationWindowMediator,
			viewComponent = ContinuousOperationWindow,
			data = {
				mainFleetId = arg1,
				stageId = arg0.contextData.stageId,
				system = arg0.contextData.system,
				oilCost = var1()
			}
		}))
	end)
	arg0:bind(var0.BEGIN_STAGE_PROXY, function(arg0, arg1)
		local var0

		if arg0.contextData.rivalId then
			var0 = arg0.contextData.rivalId
		else
			var0 = arg0.contextData.stageId
		end

		arg0:sendNotification(GAME.BEGIN_STAGE, {
			stageId = var0,
			mainFleetId = arg1.curFleetId,
			system = arg0.contextData.system,
			actId = arg0.contextData.actId,
			rivalId = arg0.contextData.rivalId,
			continuousBattleTimes = arg1.continuousBattleTimes,
			totalBattleTimes = arg1.continuousBattleTimes
		})
	end)
end

function var0.changeFleet(arg0, arg1)
	if arg0.contextData.system == SYSTEM_SUB_ROUTINE then
		arg0.contextData.subFleetId = arg1
	else
		getProxy(PlayerProxy).combatFleetId = arg1
	end

	arg0.viewComponent:SetCurrentFleet(arg1)
	arg0.viewComponent:UpdateFleetView(true)
	arg0.viewComponent:SetFleetStepper()
end

function var0.refreshEdit(arg0, arg1)
	local var0 = getProxy(FleetProxy)

	var0.EdittingFleet = arg1

	if arg0.contextData.system ~= SYSTEM_SUB_ROUTINE then
		local var1 = var0:getData()

		var1[arg1.id] = arg1

		arg0.viewComponent:SetFleets(var1)
	end

	arg0.viewComponent:UpdateFleetView(false)
end

function var0.commitEdit(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = var0.EdittingFleet

	if var1 == nil or var1:isFirstFleet() or var1:isLegalToFight() == true then
		var0:commitEdittingFleet(arg1)
	elseif #var1.ships == 0 then
		var0:commitEdittingFleet(arg1)

		if arg0.contextData.system == SYSTEM_SUB_ROUTINE then
			-- block empty
		else
			arg0:changeFleet(1)
		end
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_formationMediaror_trash_warning", var1.defaultName),
			onYes = function()
				local var0 = getProxy(BayProxy):getRawData()
				local var1 = var1.ships

				for iter0 = #var1, 1, -1 do
					var1:removeShip(var0[var1[iter0]])
				end

				if var1.id == FleetProxy.PVP_FLEET_ID then
					var0:commitEdittingFleet()
					arg0:changeFleet(FleetProxy.PVP_FLEET_ID)
				else
					var0:commitEdittingFleet(arg1)
					arg0:changeFleet(1)
				end
			end
		})
	end
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1
	})
end

function var0.onAutoSubBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0,
		toggle = var1
	})
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BEGIN_STAGE_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		PreCombatMediator.BEGIN_STAGE_PROXY,
		var0.CONTINUOUS_OPERATION
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0 == GAME.BEGIN_STAGE_ERRO then
		if var1 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0 == PreCombatMediator.BEGIN_STAGE_PROXY then
		arg0.viewComponent:emit(PreCombatMediator.BEGIN_STAGE_PROXY, var1)
	elseif var0 == var0.CONTINUOUS_OPERATION then
		arg0.viewComponent:emit(PreCombatMediator.ON_START, var1.mainFleetId, var1.battleTimes)
	end
end

return var0
