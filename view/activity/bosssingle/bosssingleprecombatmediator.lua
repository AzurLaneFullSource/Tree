local var0 = class("BossSinglePreCombatMediator", import("view.base.ContextMediator"))

var0.ON_START = "PreCombatMediator:ON_START"
var0.ON_COMMIT_EDIT = "PreCombatMediator:ON_COMMIT_EDIT"
var0.ON_ABORT_EDIT = "PreCombatMediator:ON_ABORT_EDIT"
var0.OPEN_SHIP_INFO = "PreCombatMediator:OPEN_SHIP_INFO"
var0.CHANGE_FLEET_SHIPS_ORDER = "PreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0.BEGIN_STAGE_PROXY = "PreCombatMediator:BEGIN_STAGE_PROXY"
var0.SHOW_CONTINUOUS_OPERATION_WINDOW = "PreCombatMediator:SHOW_CONTINUOUS_OPERATION_WINDOW"
var0.CONTINUOUS_OPERATION = "PreCombatMediator:CONTINUOUS_OPERATION"
var0.ON_AUTO = "BossSinglePreCombatMediator:ON_AUTO"
var0.ON_SUB_AUTO = "BossSinglePreCombatMediator:ON_SUB_AUTO"

function var0.register(arg0)
	arg0:bindEvent()

	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:SetShips(arg0.ships)

	local var0 = arg0.contextData.fleets

	arg0.fleets = var0

	arg0.viewComponent:SetFleets(var0)

	local var1 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:SetPlayerInfo(var1)

	local var2 = var0[1]

	arg0.viewComponent:SetCurrentFleet(var2.id)

	for iter0, iter1 in ipairs(var0) do
		if iter1:isSubmarineFleet() and iter1:isLegalToFight() == true then
			arg0.viewComponent:SetSubFlag(true)

			break
		end
	end
end

function var0.bindEvent(arg0)
	local var0 = arg0.contextData.system

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

	arg0:bind(var0.ON_ABORT_EDIT, function(arg0)
		return
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
	arg0:bind(var0.ON_COMMIT_EDIT, function(arg0, arg1)
		arg0:commitEdit(arg1)
	end)
	arg0:bind(var0.ON_START, function(arg0, arg1, arg2)
		if var1() > getProxy(PlayerProxy):getRawData().oil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

			return
		end

		seriesAsync({
			function(arg0)
				if pg.battle_cost_template[var0].enter_energy_cost == 0 then
					arg0()

					return
				end

				local var0
				local var1
				local var2 = arg0.fleets[1]
				local var3 = "ship_energy_low_warn_no_exp"
				local var4 = {}

				for iter0, iter1 in ipairs(var2.ships) do
					table.insert(var4, getProxy(BayProxy):getShipById(iter1))
				end

				local var5 = var2:GetName()

				Fleet.EnergyCheck(var4, var5, function(arg0)
					if arg0 then
						arg0()
					end
				end, nil, var3)
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
	arg0:bind(var0.SHOW_CONTINUOUS_OPERATION_WINDOW, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = BossSingleContinuousOperationWindowMediator,
			viewComponent = BossSingleContinuousOperationWindow,
			data = {
				mainFleetId = arg1,
				stageId = arg0.contextData.stageId,
				system = arg0.contextData.system,
				oilCost = var1()
			}
		}))
	end)
	arg0:bind(var0.BEGIN_STAGE_PROXY, function(arg0, arg1)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0.contextData.stageId,
			mainFleetId = arg1.curFleetId,
			system = arg0.contextData.system,
			actId = arg0.contextData.actId,
			continuousBattleTimes = arg1.continuousBattleTimes,
			totalBattleTimes = arg1.continuousBattleTimes
		})
	end)
end

function var0.refreshEdit(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = arg0.contextData.actId

	var0:updateActivityFleet(var1, arg1.id, arg1)

	local var2 = var0:getActivityFleets()[var1]

	arg0.viewComponent:SetFleets(var2)
	arg0.viewComponent:UpdateFleetView(false)
end

function var0.commitEdit(arg0, arg1)
	getProxy(FleetProxy):commitActivityFleet(arg0.contextData.actId)
	arg1()
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

function var0.removeShipFromFleet(arg0, arg1, arg2)
	arg1:removeShip(arg2)

	return true
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BEGIN_STAGE_DONE,
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
