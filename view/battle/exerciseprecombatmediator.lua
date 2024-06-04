local var0 = class("ExercisePreCombatMediator", import("..base.ContextMediator"))

var0.ON_START = "ExercisePreCombatMediator:ON_START"
var0.ON_CHANGE_FLEET = "ExercisePreCombatMediator:ON_CHANGE_FLEET"
var0.ON_COMMIT_EDIT = "ExercisePreCombatMediator:ON_COMMIT_EDIT"
var0.OPEN_SHIP_INFO = "ExercisePreCombatMediator:OPEN_SHIP_INFO"
var0.REMOVE_SHIP = "ExercisePreCombatMediator:REMOVE_SHIP"
var0.CHANGE_FLEET_SHIPS_ORDER = "ExercisePreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0.CHANGE_FLEET_SHIP = "ExercisePreCombatMediator:CHANGE_FLEET_SHIP"
var0.ON_AUTO = "ExercisePreCombatMediator:ON_AUTO"
var0.ON_SUB_AUTO = "ExercisePreCombatMediator:ON_SUB_AUTO"

function var0.register(arg0)
	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:SetShips(arg0.ships)

	local var0 = arg0.contextData.system
	local var1 = getProxy(FleetProxy)
	local var2
	local var3 = var1:getData()

	if arg0.contextData.EdittingFleet then
		var1.EdittingFleet = arg0.contextData.EdittingFleet
		arg0.contextData.EdittingFleet = nil
	end

	if var1.EdittingFleet ~= nil then
		var3[var1.EdittingFleet.id] = var1.EdittingFleet
	end

	arg0.viewComponent:SetFleets(var3)

	local var4 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:SetPlayerInfo(var4)
	arg0.viewComponent:SetCurrentFleet(FleetProxy.PVP_FLEET_ID)
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
		arg2:removeShip(arg1)

		getProxy(FleetProxy).EdittingFleet = arg2

		arg0:refreshEdit(arg2)
	end)
	arg0:bind(var0.OPEN_SHIP_INFO, function(arg0, arg1, arg2)
		arg0.contextData.form = ExercisePreCombatLayer.FORM_EDIT

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
		assert(arg2.id == FleetProxy.PVP_FLEET_ID, "fleet type error")

		arg0.contextData.form = ExercisePreCombatLayer.FORM_EDIT

		FormationMediator.saveEdit()

		local var0 = var0 == SYSTEM_DUEL
		local var1 = var0 and ShipStatus.TAG_HIDE_PVP or ShipStatus.TAG_HIDE_NORMAL
		local var2 = var0 and ShipStatus.TAG_BLOCK_PVP or nil
		local var3, var4, var5 = arg0:getDockCallbackFuncsForExercise(arg1, arg2, arg3)
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
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
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
	arg0:bind(var0.ON_START, function(arg0, arg1)
		local var0

		if arg0.contextData.rivalId then
			var0 = arg0.contextData.rivalId
		else
			var0 = arg0.contextData.stageId
		end

		seriesAsync({
			function(arg0)
				if arg0.contextData.OnConfirm then
					arg0.contextData.OnConfirm(arg0)
				else
					arg0()
				end
			end,
			function()
				arg0:sendNotification(GAME.BEGIN_STAGE, {
					stageId = var0,
					mainFleetId = arg1,
					system = arg0.contextData.system,
					actId = arg0.contextData.actId,
					rivalId = arg0.contextData.rivalId
				})
			end
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
		GAME.BEGIN_STAGE_ERRO
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0 == GAME.BEGIN_STAGE_ERRO and var1 == 3 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("battle_preCombatMediator_timeout"),
			onYes = function()
				arg0.viewComponent:emit(BaseUI.ON_CLOSE)
			end
		})
	end
end

function var0.getDockCallbackFuncsForExercise(arg0, arg1, arg2, arg3)
	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(BayProxy)

	local function var2(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inFleet", arg0, arg1)

		if not var0 then
			return var0, var1
		end

		local var2, var3 = FormationMediator.checkChangeShip(arg2, arg1, arg0)

		if not var2 then
			return false, var3
		end

		return true
	end

	local function var3(arg0, arg1, arg2)
		arg1()
	end

	local function var4(arg0)
		local var0 = var1:getShipById(arg0[1])
		local var1 = arg2:getShipPos(arg1) or -1

		if var1 > 0 then
			arg2:removeShip(arg1)
		end

		local var2 = arg2:getShipPos(var0) or -1

		if var2 > 0 then
			arg2:removeShip(var0)
		end

		local var3 = {}

		if arg1 and var2 > 0 then
			table.insert(var3, {
				var2,
				arg1
			})
		end

		if var0 then
			table.insert(var3, {
				var1,
				var0
			})
		end

		table.sort(var3, function(arg0, arg1)
			return arg0[1] < arg1[1]
		end)

		for iter0, iter1 in ipairs(var3) do
			local var4 = iter1[1] > 0 and iter1[1] or nil
			local var5 = iter1[2]

			arg2:insertShip(var5, var4, arg3)
		end

		var0.EdittingFleet = arg2
	end

	return var2, var3, var4
end

return var0
