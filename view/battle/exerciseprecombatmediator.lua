local var0_0 = class("ExercisePreCombatMediator", import("..base.ContextMediator"))

var0_0.ON_START = "ExercisePreCombatMediator:ON_START"
var0_0.ON_CHANGE_FLEET = "ExercisePreCombatMediator:ON_CHANGE_FLEET"
var0_0.ON_COMMIT_EDIT = "ExercisePreCombatMediator:ON_COMMIT_EDIT"
var0_0.OPEN_SHIP_INFO = "ExercisePreCombatMediator:OPEN_SHIP_INFO"
var0_0.REMOVE_SHIP = "ExercisePreCombatMediator:REMOVE_SHIP"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "ExercisePreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.CHANGE_FLEET_SHIP = "ExercisePreCombatMediator:CHANGE_FLEET_SHIP"
var0_0.ON_AUTO = "ExercisePreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "ExercisePreCombatMediator:ON_SUB_AUTO"

function var0_0.register(arg0_1)
	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:SetShips(arg0_1.ships)

	local var0_1 = arg0_1.contextData.system
	local var1_1 = getProxy(FleetProxy)
	local var2_1
	local var3_1 = var1_1:getData()

	if arg0_1.contextData.EdittingFleet then
		var1_1.EdittingFleet = arg0_1.contextData.EdittingFleet
		arg0_1.contextData.EdittingFleet = nil
	end

	if var1_1.EdittingFleet ~= nil then
		var3_1[var1_1.EdittingFleet.id] = var1_1.EdittingFleet
	end

	arg0_1.viewComponent:SetFleets(var3_1)

	local var4_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:SetPlayerInfo(var4_1)
	arg0_1.viewComponent:SetCurrentFleet(FleetProxy.PVP_FLEET_ID)
	arg0_1:bind(var0_0.ON_CHANGE_FLEET, function(arg0_2, arg1_2)
		arg0_1:changeFleet(arg1_2)
	end)
	arg0_1:bind(var0_0.ON_AUTO, function(arg0_3, arg1_3)
		arg0_1:onAutoBtn(arg1_3)
	end)
	arg0_1:bind(var0_0.ON_SUB_AUTO, function(arg0_4, arg1_4)
		arg0_1:onAutoSubBtn(arg1_4)
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_5, arg1_5)
		arg0_1:refreshEdit(arg1_5)
	end)
	arg0_1:bind(var0_0.REMOVE_SHIP, function(arg0_6, arg1_6, arg2_6)
		arg2_6:removeShip(arg1_6)

		getProxy(FleetProxy).EdittingFleet = arg2_6

		arg0_1:refreshEdit(arg2_6)
	end)
	arg0_1:bind(var0_0.OPEN_SHIP_INFO, function(arg0_7, arg1_7, arg2_7)
		arg0_1.contextData.form = ExercisePreCombatLayer.FORM_EDIT

		local var0_7 = {}

		for iter0_7, iter1_7 in ipairs(arg2_7:getShipIds()) do
			table.insert(var0_7, arg0_1.ships[iter1_7])
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_7,
			shipVOs = var0_7
		})
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIP, function(arg0_8, arg1_8, arg2_8, arg3_8)
		assert(arg2_8.id == FleetProxy.PVP_FLEET_ID, "fleet type error")

		arg0_1.contextData.form = ExercisePreCombatLayer.FORM_EDIT

		FormationMediator.saveEdit()

		local var0_8 = var0_1 == SYSTEM_DUEL
		local var1_8 = var0_8 and ShipStatus.TAG_HIDE_PVP or ShipStatus.TAG_HIDE_NORMAL
		local var2_8 = var0_8 and ShipStatus.TAG_BLOCK_PVP or nil
		local var3_8, var4_8, var5_8 = arg0_1:getDockCallbackFuncsForExercise(arg1_8, arg2_8, arg3_8)
		local var6_8 = {}

		for iter0_8, iter1_8 in ipairs(arg2_8.ships) do
			if not arg1_8 or iter1_8 ~= arg1_8.id then
				table.insert(var6_8, iter1_8)
			end
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = arg1_8 ~= nil,
			teamFilter = arg3_8,
			onShip = var3_8,
			confirmSelect = var4_8,
			onSelected = var5_8,
			hideTagFlags = var1_8,
			blockTagFlags = var2_8,
			otherSelectedIds = var6_8
		})
	end)
	arg0_1:bind(var0_0.ON_COMMIT_EDIT, function(arg0_9, arg1_9)
		arg0_1:commitEdit(arg1_9)
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_10, arg1_10)
		local var0_10

		if arg0_1.contextData.rivalId then
			var0_10 = arg0_1.contextData.rivalId
		else
			var0_10 = arg0_1.contextData.stageId
		end

		seriesAsync({
			function(arg0_11)
				if arg0_1.contextData.OnConfirm then
					arg0_1.contextData.OnConfirm(arg0_11)
				else
					arg0_11()
				end
			end,
			function()
				arg0_1:sendNotification(GAME.BEGIN_STAGE, {
					stageId = var0_10,
					mainFleetId = arg1_10,
					system = arg0_1.contextData.system,
					actId = arg0_1.contextData.actId,
					rivalId = arg0_1.contextData.rivalId
				})
			end
		})
	end)
end

function var0_0.changeFleet(arg0_13, arg1_13)
	if arg0_13.contextData.system == SYSTEM_SUB_ROUTINE then
		arg0_13.contextData.subFleetId = arg1_13
	else
		getProxy(PlayerProxy).combatFleetId = arg1_13
	end

	arg0_13.viewComponent:SetCurrentFleet(arg1_13)
	arg0_13.viewComponent:UpdateFleetView(true)
end

function var0_0.refreshEdit(arg0_14, arg1_14)
	local var0_14 = getProxy(FleetProxy)

	var0_14.EdittingFleet = arg1_14

	if arg0_14.contextData.system ~= SYSTEM_SUB_ROUTINE then
		local var1_14 = var0_14:getData()

		var1_14[arg1_14.id] = arg1_14

		arg0_14.viewComponent:SetFleets(var1_14)
	end

	arg0_14.viewComponent:UpdateFleetView(false)
end

function var0_0.commitEdit(arg0_15, arg1_15)
	local var0_15 = getProxy(FleetProxy)
	local var1_15 = var0_15.EdittingFleet

	if var1_15 == nil or var1_15:isFirstFleet() or var1_15:isLegalToFight() == true then
		var0_15:commitEdittingFleet(arg1_15)
	elseif #var1_15.ships == 0 then
		var0_15:commitEdittingFleet(arg1_15)

		if arg0_15.contextData.system == SYSTEM_SUB_ROUTINE then
			-- block empty
		end
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_formationMediaror_trash_warning", var1_15.defaultName),
			onYes = function()
				local var0_16 = getProxy(BayProxy):getRawData()
				local var1_16 = var1_15.ships

				for iter0_16 = #var1_16, 1, -1 do
					var1_15:removeShip(var0_16[var1_16[iter0_16]])
				end

				if var1_15.id == FleetProxy.PVP_FLEET_ID then
					var0_15:commitEdittingFleet()
					arg0_15:changeFleet(FleetProxy.PVP_FLEET_ID)
				else
					var0_15:commitEdittingFleet(arg1_15)
				end
			end
		})
	end
end

function var0_0.onAutoBtn(arg0_17, arg1_17)
	local var0_17 = arg1_17.isOn
	local var1_17 = arg1_17.toggle

	arg0_17:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_17,
		toggle = var1_17
	})
end

function var0_0.onAutoSubBtn(arg0_18, arg1_18)
	local var0_18 = arg1_18.isOn
	local var1_18 = arg1_18.toggle

	arg0_18:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_18,
		toggle = var1_18
	})
end

function var0_0.listNotificationInterests(arg0_19)
	return {
		GAME.BEGIN_STAGE_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO
	}
end

function var0_0.handleNotification(arg0_20, arg1_20)
	local var0_20 = arg1_20:getName()
	local var1_20 = arg1_20:getBody()

	if var0_20 == GAME.BEGIN_STAGE_DONE then
		arg0_20:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_20)
	elseif var0_20 == PlayerProxy.UPDATED then
		arg0_20.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0_20 == GAME.BEGIN_STAGE_ERRO and var1_20 == 3 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("battle_preCombatMediator_timeout"),
			onYes = function()
				arg0_20.viewComponent:emit(BaseUI.ON_CLOSE)
			end
		})
	end
end

function var0_0.getDockCallbackFuncsForExercise(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = getProxy(FleetProxy)
	local var1_22 = getProxy(BayProxy)

	local function var2_22(arg0_23, arg1_23)
		local var0_23, var1_23 = ShipStatus.ShipStatusCheck("inFleet", arg0_23, arg1_23)

		if not var0_23 then
			return var0_23, var1_23
		end

		local var2_23, var3_23 = FormationMediator.checkChangeShip(arg2_22, arg1_22, arg0_23)

		if not var2_23 then
			return false, var3_23
		end

		return true
	end

	local function var3_22(arg0_24, arg1_24, arg2_24)
		arg1_24()
	end

	local function var4_22(arg0_25)
		local var0_25 = var1_22:getShipById(arg0_25[1])
		local var1_25 = arg2_22:getShipPos(arg1_22) or -1

		if var1_25 > 0 then
			arg2_22:removeShip(arg1_22)
		end

		local var2_25 = arg2_22:getShipPos(var0_25) or -1

		if var2_25 > 0 then
			arg2_22:removeShip(var0_25)
		end

		local var3_25 = {}

		if arg1_22 and var2_25 > 0 then
			table.insert(var3_25, {
				var2_25,
				arg1_22
			})
		end

		if var0_25 then
			table.insert(var3_25, {
				var1_25,
				var0_25
			})
		end

		table.sort(var3_25, function(arg0_26, arg1_26)
			return arg0_26[1] < arg1_26[1]
		end)

		for iter0_25, iter1_25 in ipairs(var3_25) do
			local var4_25 = iter1_25[1] > 0 and iter1_25[1] or nil
			local var5_25 = iter1_25[2]

			arg2_22:insertShip(var5_25, var4_25, arg3_22)
		end

		var0_22.EdittingFleet = arg2_22
	end

	return var2_22, var3_22, var4_22
end

return var0_0
