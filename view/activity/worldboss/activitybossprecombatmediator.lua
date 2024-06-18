local var0_0 = class("ActivityBossPreCombatMediator", import("view.base.ContextMediator"))

var0_0.ON_START = "PreCombatMediator:ON_START"
var0_0.ON_COMMIT_EDIT = "PreCombatMediator:ON_COMMIT_EDIT"
var0_0.ON_ABORT_EDIT = "PreCombatMediator:ON_ABORT_EDIT"
var0_0.OPEN_SHIP_INFO = "PreCombatMediator:OPEN_SHIP_INFO"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "PreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.BEGIN_STAGE_PROXY = "PreCombatMediator:BEGIN_STAGE_PROXY"
var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW = "PreCombatMediator:SHOW_CONTINUOUS_OPERATION_WINDOW"
var0_0.CONTINUOUS_OPERATION = "PreCombatMediator:CONTINUOUS_OPERATION"
var0_0.ON_AUTO = "PreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "PreCombatMediator:ON_SUB_AUTO"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()

	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:SetShips(arg0_1.ships)

	local var0_1 = arg0_1.contextData.fleets

	arg0_1.fleets = var0_1

	arg0_1.viewComponent:SetFleets(var0_1)

	local var1_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:SetPlayerInfo(var1_1)

	local var2_1 = var0_1[1]

	arg0_1.viewComponent:SetCurrentFleet(var2_1.id)

	for iter0_1, iter1_1 in ipairs(var0_1) do
		if iter1_1:isSubmarineFleet() and iter1_1:isLegalToFight() == true then
			arg0_1.viewComponent:SetSubFlag(true)

			break
		end
	end

	local var3_1 = getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId):GetBossConfig():GetTicketID()

	arg0_1.viewComponent:SetTicketItemID(var3_1)
end

function var0_0.bindEvent(arg0_2)
	local var0_2 = arg0_2.contextData.system

	arg0_2:bind(var0_0.ON_ABORT_EDIT, function(arg0_3)
		return
	end)
	arg0_2:bind(var0_0.ON_AUTO, function(arg0_4, arg1_4)
		arg0_2:onAutoBtn(arg1_4)
	end)
	arg0_2:bind(var0_0.ON_SUB_AUTO, function(arg0_5, arg1_5)
		arg0_2:onAutoSubBtn(arg1_5)
	end)
	arg0_2:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_6, arg1_6)
		arg0_2:refreshEdit(arg1_6)
	end)
	arg0_2:bind(var0_0.OPEN_SHIP_INFO, function(arg0_7, arg1_7, arg2_7)
		arg0_2.contextData.form = PreCombatLayer.FORM_EDIT

		local var0_7 = {}

		for iter0_7, iter1_7 in ipairs(arg2_7:getShipIds()) do
			table.insert(var0_7, arg0_2.ships[iter1_7])
		end

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_7,
			shipVOs = var0_7
		})
	end)
	arg0_2:bind(var0_0.ON_COMMIT_EDIT, function(arg0_8, arg1_8)
		arg0_2:commitEdit(arg1_8)
	end)
	arg0_2:bind(var0_0.ON_START, function(arg0_9, arg1_9, arg2_9)
		seriesAsync({
			function(arg0_10)
				if pg.battle_cost_template[var0_2].enter_energy_cost == 0 then
					arg0_10()

					return
				end

				local var0_10
				local var1_10
				local var2_10 = arg0_2.fleets[1]
				local var3_10 = "ship_energy_low_warn_no_exp"
				local var4_10 = {}

				for iter0_10, iter1_10 in ipairs(var2_10.ships) do
					table.insert(var4_10, getProxy(BayProxy):getShipById(iter1_10))
				end

				local var5_10 = var2_10:GetName()

				Fleet.EnergyCheck(var4_10, var5_10, function(arg0_11)
					if arg0_11 then
						arg0_10()
					end
				end, nil, var3_10)
			end,
			function(arg0_12)
				if arg0_2.contextData.OnConfirm then
					arg0_2.contextData.OnConfirm(arg0_12)
				else
					arg0_12()
				end
			end,
			function()
				arg0_2.viewComponent:emit(var0_0.BEGIN_STAGE_PROXY, {
					curFleetId = arg1_9,
					continuousBattleTimes = arg2_9
				})
			end
		})
	end)

	local function var1_2()
		local var0_14 = 0

		for iter0_14, iter1_14 in ipairs(arg0_2.contextData.fleets) do
			local var1_14 = iter1_14:GetCostSum().oil
			local var2_14 = iter0_14 == 1
			local var3_14 = arg0_2.contextData.costLimit[var2_14 and 1 or 2]

			if var3_14 > 0 then
				var1_14 = math.min(var1_14, var3_14)
			end

			var0_14 = var0_14 + var1_14
		end

		return var0_14
	end

	arg0_2:bind(var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW, function(arg0_15, arg1_15)
		arg0_2:addSubLayers(Context.New({
			mediator = ContinuousOperationWindowMediator,
			viewComponent = ContinuousOperationWindow,
			data = {
				mainFleetId = arg1_15,
				stageId = arg0_2.contextData.stageId,
				system = arg0_2.contextData.system,
				oilCost = var1_2()
			}
		}))
	end)
	arg0_2:bind(var0_0.BEGIN_STAGE_PROXY, function(arg0_16, arg1_16)
		local var0_16

		if arg0_2.contextData.rivalId then
			var0_16 = arg0_2.contextData.rivalId
		else
			var0_16 = arg0_2.contextData.stageId
		end

		arg0_2:sendNotification(GAME.BEGIN_STAGE, {
			stageId = var0_16,
			mainFleetId = arg1_16.curFleetId,
			system = arg0_2.contextData.system,
			actId = arg0_2.contextData.actId,
			rivalId = arg0_2.contextData.rivalId,
			continuousBattleTimes = arg1_16.continuousBattleTimes,
			totalBattleTimes = arg1_16.continuousBattleTimes
		})
	end)
end

function var0_0.refreshEdit(arg0_17, arg1_17)
	local var0_17 = getProxy(FleetProxy)
	local var1_17 = arg0_17.contextData.actId

	var0_17:updateActivityFleet(var1_17, arg1_17.id, arg1_17)

	local var2_17 = var0_17:getActivityFleets()[var1_17]

	arg0_17.viewComponent:SetFleets(var2_17)
	arg0_17.viewComponent:UpdateFleetView(false)
end

function var0_0.commitEdit(arg0_18, arg1_18)
	getProxy(FleetProxy):commitActivityFleet(arg0_18.contextData.actId)
	arg1_18()
end

function var0_0.onAutoBtn(arg0_19, arg1_19)
	local var0_19 = arg1_19.isOn
	local var1_19 = arg1_19.toggle

	arg0_19:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_19,
		toggle = var1_19
	})
end

function var0_0.onAutoSubBtn(arg0_20, arg1_20)
	local var0_20 = arg1_20.isOn
	local var1_20 = arg1_20.toggle

	arg0_20:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_20,
		toggle = var1_20
	})
end

function var0_0.removeShipFromFleet(arg0_21, arg1_21, arg2_21)
	arg1_21:removeShip(arg2_21)

	return true
end

function var0_0.listNotificationInterests(arg0_22)
	return {
		GAME.BEGIN_STAGE_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		PreCombatMediator.BEGIN_STAGE_PROXY,
		var0_0.CONTINUOUS_OPERATION
	}
end

function var0_0.handleNotification(arg0_23, arg1_23)
	local var0_23 = arg1_23:getName()
	local var1_23 = arg1_23:getBody()

	if var0_23 == GAME.BEGIN_STAGE_DONE then
		arg0_23:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_23)
	elseif var0_23 == PlayerProxy.UPDATED then
		arg0_23.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0_23 == GAME.BEGIN_STAGE_ERRO then
		if var1_23 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0_23.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0_23 == PreCombatMediator.BEGIN_STAGE_PROXY then
		arg0_23.viewComponent:emit(PreCombatMediator.BEGIN_STAGE_PROXY, var1_23)
	elseif var0_23 == var0_0.CONTINUOUS_OPERATION then
		arg0_23.viewComponent:emit(PreCombatMediator.ON_START, var1_23.mainFleetId, var1_23.battleTimes)
	end
end

return var0_0
