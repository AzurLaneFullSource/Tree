local var0_0 = class("BossSinglePreCombatLiteMediator", import(".BossSinglePreCombatMediator"))

var0_0.ON_START = "PreCombatMediator:ON_START"
var0_0.ON_COMMIT_EDIT = "PreCombatMediator:ON_COMMIT_EDIT"
var0_0.ON_ABORT_EDIT = "PreCombatMediator:ON_ABORT_EDIT"
var0_0.OPEN_SHIP_INFO = "PreCombatMediator:OPEN_SHIP_INFO"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "PreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.BEGIN_STAGE_PROXY = "PreCombatMediator:BEGIN_STAGE_PROXY"
var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW = "PreCombatMediator:SHOW_CONTINUOUS_OPERATION_WINDOW"
var0_0.CONTINUOUS_OPERATION = "PreCombatMediator:CONTINUOUS_OPERATION"
var0_0.ON_AUTO = "BossSinglePreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "BossSinglePreCombatMediator:ON_SUB_AUTO"

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
end

function var0_0.bindEvent(arg0_2)
	local var0_2 = arg0_2.contextData.system

	local function var1_2()
		local var0_3 = 0

		for iter0_3, iter1_3 in ipairs(arg0_2.contextData.fleets) do
			local var1_3 = iter1_3:GetCostSum().oil
			local var2_3 = iter0_3 == 1
			local var3_3 = arg0_2.contextData.costLimit[var2_3 and 1 or 2]

			if var3_3 > 0 then
				var1_3 = math.min(var1_3, var3_3)
			end

			var0_3 = var0_3 + var1_3
		end

		return var0_3
	end

	arg0_2:bind(var0_0.ON_ABORT_EDIT, function(arg0_4)
		return
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
	arg0_2:bind(var0_0.OPEN_SHIP_INFO, function(arg0_8, arg1_8, arg2_8)
		arg0_2.contextData.form = PreCombatLayer.FORM_EDIT

		local var0_8 = {}

		for iter0_8, iter1_8 in ipairs(arg2_8:getShipIds()) do
			table.insert(var0_8, arg0_2.ships[iter1_8])
		end

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_8,
			shipVOs = var0_8
		})
	end)
	arg0_2:bind(var0_0.ON_COMMIT_EDIT, function(arg0_9, arg1_9)
		arg0_2:commitEdit(arg1_9)
	end)
	arg0_2:bind(var0_0.ON_START, function(arg0_10, arg1_10, arg2_10)
		arg0_2.viewComponent:emit(var0_0.BEGIN_STAGE_PROXY, {
			curFleetId = arg1_10,
			continuousBattleTimes = arg2_10
		})
	end)
	arg0_2:bind(var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW, function(arg0_11, arg1_11)
		arg0_2:addSubLayers(Context.New({
			mediator = BossSingleContinuousOperationWindowMediator,
			viewComponent = BossSingleContinuousOperationWindow,
			data = {
				mainFleetId = arg1_11,
				stageId = arg0_2.contextData.stageId,
				system = arg0_2.contextData.system,
				oilCost = var1_2()
			}
		}))
	end)
	arg0_2:bind(var0_0.BEGIN_STAGE_PROXY, function(arg0_12, arg1_12)
		local var0_12 = arg0_2.contextData.useTicket and 1 or 0

		arg0_2:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0_2.contextData.stageId,
			mainFleetId = arg1_12.curFleetId,
			system = arg0_2.contextData.system,
			actId = arg0_2.contextData.actId,
			variableBuffList = arg0_2.contextData.buffList,
			continuousBattleTimes = arg1_12.continuousBattleTimes,
			totalBattleTimes = arg1_12.continuousBattleTimes,
			useVariableTicket = var0_12
		})
	end)
end

function var0_0.refreshEdit(arg0_13, arg1_13)
	local var0_13 = getProxy(FleetProxy)
	local var1_13 = arg0_13.contextData.actId

	var0_13:updateActivityFleet(var1_13, arg1_13.id, arg1_13)

	local var2_13 = var0_13:getActivityFleets()[var1_13]

	arg0_13.viewComponent:SetFleets(var2_13)
	arg0_13.viewComponent:UpdateFleetView(false)
end

function var0_0.commitEdit(arg0_14, arg1_14)
	getProxy(FleetProxy):commitActivityFleet(arg0_14.contextData.actId)
	arg1_14()
end

function var0_0.onAutoBtn(arg0_15, arg1_15)
	local var0_15 = arg1_15.isOn
	local var1_15 = arg1_15.toggle

	arg0_15:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_15,
		toggle = var1_15
	})
end

function var0_0.onAutoSubBtn(arg0_16, arg1_16)
	local var0_16 = arg1_16.isOn
	local var1_16 = arg1_16.toggle

	arg0_16:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_16,
		toggle = var1_16
	})
end

function var0_0.removeShipFromFleet(arg0_17, arg1_17, arg2_17)
	arg1_17:removeShip(arg2_17)

	return true
end

function var0_0.listNotificationInterests(arg0_18)
	return {
		GAME.BEGIN_STAGE_DONE,
		GAME.BEGIN_STAGE_ERRO,
		PreCombatMediator.BEGIN_STAGE_PROXY,
		var0_0.CONTINUOUS_OPERATION
	}
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()

	if var0_19 == GAME.BEGIN_STAGE_DONE then
		arg0_19:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_19)
	elseif var0_19 == GAME.BEGIN_STAGE_ERRO then
		if var1_19 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0_19.viewComponent:closeView()
				end
			})
		end
	elseif var0_19 == PreCombatMediator.BEGIN_STAGE_PROXY then
		arg0_19.viewComponent:emit(PreCombatMediator.BEGIN_STAGE_PROXY, var1_19)
	elseif var0_19 == var0_0.CONTINUOUS_OPERATION then
		arg0_19.viewComponent:emit(PreCombatMediator.ON_START, var1_19.mainFleetId, var1_19.battleTimes)
	end
end

return var0_0
