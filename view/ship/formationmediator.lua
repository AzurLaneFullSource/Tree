local var0_0 = class("FormationMediator", import("..base.ContextMediator"))

var0_0.OPEN_SHIP_INFO = "FormationMediator:OPEN_SHIP_INFO"
var0_0.ON_CHANGE_FLEET = "FormationMediator:ON_CHANGE_FLEET"
var0_0.CHANGE_FLEET_NAME = "FormationMediator:CHANGE_FLEET_NAME"
var0_0.CHANGE_FLEET_SHIP = "FormationMediator:CHANGE_FLEET_SHIP"
var0_0.REMOVE_SHIP = "FormationMediator:REMOVE_SHIP"
var0_0.CHANGE_FLEET_FORMATION = "FormationMediator:CHANGE_FLEET_FORMATION"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "FormationMediator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.COMMIT_FLEET = "FormationMediator:COMMIT_FLEET"
var0_0.ON_SELECT_COMMANDER = "FormationMediator:ON_SELECT_COMMANDER"
var0_0.ON_CMD_SKILL = "FormationMediator:ON_CMD_SKILL"
var0_0.COMMANDER_FORMATION_OP = "FormationMediator:COMMANDER_FORMATION_OP"

function var0_0.register(arg0_1)
	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:setShips(arg0_1.ships)

	local var0_1 = getProxy(FleetProxy)
	local var1_1 = var0_1:GetRegularFleets()

	if var0_1.EdittingFleet ~= nil then
		var1_1[var0_1.EdittingFleet.id] = var0_1.EdittingFleet
	end

	arg0_1.viewComponent:SetFleets(var1_1)

	local var2_1 = getProxy(CommanderProxy)

	arg0_1.viewComponent:setCommanderPrefabFleet(var2_1:getPrefabFleet())
	arg0_1:bind(var0_0.ON_CMD_SKILL, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_2
			}
		}))
	end)
	arg0_1:bind(var0_0.COMMIT_FLEET, function(arg0_3, arg1_3)
		arg0_1.commitEdit(arg1_3)
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_NAME, function(arg0_4, arg1_4, arg2_4)
		arg0_1.commitEdit(function()
			arg0_1:sendNotification(GAME.RENAME_FLEET, {
				id = arg1_4,
				name = arg2_4
			})
		end)
	end)
	arg0_1:bind(var0_0.OPEN_SHIP_INFO, function(arg0_6, arg1_6, arg2_6, arg3_6)
		local function var0_6()
			arg0_1.contextData.number = arg2_6.id
			arg0_1.contextData.toggle = arg3_6

			local var0_7 = {}

			for iter0_7, iter1_7 in ipairs(arg2_6:getShipIds()) do
				table.insert(var0_7, arg0_1.ships[iter1_7])
			end

			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				shipId = arg1_6,
				shipVOs = var0_7
			})
		end

		arg0_1.commitEdit(var0_6)
	end)
	arg0_1:bind(var0_0.ON_CHANGE_FLEET, function(arg0_8, arg1_8)
		arg0_1.commitEdit(function()
			arg0_1.viewComponent:SetFleets(var0_1:GetRegularFleets())
			arg0_1.viewComponent:SetCurrentFleetID(arg1_8)
			arg0_1.viewComponent:UpdateFleetView(true)
		end)
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_FORMATION, function(arg0_10, arg1_10, arg2_10)
		arg2_10.formation = arg1_10

		arg0_1:refreshEdit(arg2_10)
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_11, arg1_11)
		arg0_1:refreshEdit(arg1_11)
	end)
	arg0_1:bind(var0_0.REMOVE_SHIP, function(arg0_12, arg1_12, arg2_12)
		var0_0.removeShipFromFleet(arg2_12, arg1_12)
		arg0_1:refreshEdit(arg2_12)
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIP, function(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
		arg0_1.contextData.number = arg2_13.id
		arg0_1.contextData.toggle = arg3_13

		arg0_1.saveEdit()

		local var0_13 = 0

		if arg2_13.id == 1 and #arg2_13.ships <= 1 and arg1_13 ~= nil then
			var0_13 = 1
		end

		local var1_13 = {}

		for iter0_13, iter1_13 in ipairs(arg2_13.ships) do
			if not arg1_13 or iter1_13 ~= arg1_13.id then
				table.insert(var1_13, iter1_13)
			end
		end

		local var2_13, var3_13, var4_13 = var0_0.getDockCallbackFuncs(arg0_1, arg1_13, arg2_13, arg4_13)
		local var5_13 = arg0_1.commitEdit

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			energyDisplay = true,
			useBlackBlock = true,
			selectedMin = var0_13,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = arg1_13 ~= nil,
			teamFilter = arg4_13,
			leftTopInfo = i18n("word_formation"),
			onShip = var2_13,
			confirmSelect = var3_13,
			onSelected = var4_13,
			onQuickHome = var5_13,
			hideTagFlags = ShipStatus.TAG_HIDE_FORMATION,
			otherSelectedIds = var1_13,
			preView = arg0_1.viewComponent.__cname
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_COMMANDER, function(arg0_14, arg1_14, arg2_14)
		arg0_1.contextData.toggle = FormationUI.TOGGLE_FORMATION
		arg0_1.contextData.number = arg2_14

		var0_0.onSelectCommander(arg1_14, arg2_14)
	end)
	arg0_1:bind(var0_0.COMMANDER_FORMATION_OP, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1_15
		})
	end)

	local var3_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var3_1)
end

function var0_0.onSelectCommander(arg0_16, arg1_16)
	local var0_16 = getProxy(FleetProxy)
	local var1_16 = getProxy(FleetProxy):getFleetById(arg1_16):getCommanderByPos(arg0_16)
	local var2_16 = {}

	for iter0_16, iter1_16 in ipairs(var2_16) do
		if var1_16 and iter1_16 == var1_16.id then
			table.remove(var2_16, iter0_16)

			break
		end
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
		maxCount = 1,
		mode = CommanderCatScene.MODE_SELECT,
		fleetType = CommanderCatScene.FLEET_TYPE_COMMON,
		activeCommander = var1_16,
		ignoredIds = var2_16,
		onCommander = function(arg0_17)
			return true
		end,
		onSelected = function(arg0_18, arg1_18)
			local var0_18 = arg0_18[1]

			pg.m02:sendNotification(GAME.SELECT_FLEET_COMMANDER, {
				fleetId = arg1_16,
				pos = arg0_16,
				commanderId = var0_18,
				callback = function()
					if var0_16.EdittingFleet then
						local var0_19 = getProxy(FleetProxy):getFleetById(var0_16.EdittingFleet.id)

						var0_16.EdittingFleet.commanderIds = var0_19.commanderIds
					end

					arg1_18()
				end
			})
		end,
		onQuit = function(arg0_20)
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = arg1_16,
				pos = arg0_16,
				callback = function(arg0_21)
					if var0_16.EdittingFleet then
						var0_16.EdittingFleet.commanderIds = arg0_21.commanderIds
					end

					arg0_20()
				end
			})
		end
	})
end

function var0_0.refreshEdit(arg0_22, arg1_22)
	local var0_22 = getProxy(FleetProxy)

	var0_22.EdittingFleet = arg1_22

	local var1_22 = var0_22:GetRegularFleets()

	var1_22[arg1_22.id] = arg1_22

	arg0_22.viewComponent:SetFleets(var1_22)
	arg0_22.viewComponent:UpdateFleetView(false)
end

function var0_0.commitEdit(arg0_23)
	local var0_23 = getProxy(FleetProxy)
	local var1_23 = var0_23.EdittingFleet

	if var1_23 == nil or var1_23:isFirstFleet() or var1_23:isLegalToFight() == true or #var1_23.ships == 0 then
		var0_23:commitEdittingFleet(arg0_23)
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_formationMediaror_trash_warning", var1_23.defaultName),
			onYes = function()
				local var0_24 = getProxy(BayProxy):getRawData()
				local var1_24 = var1_23.ships
				local var2_24 = #var1_24

				for iter0_24 = #var1_24, 1, -1 do
					var1_23:removeShip(var0_24[var1_24[iter0_24]])
				end

				var0_23:commitEdittingFleet(arg0_23)

				getProxy(PlayerProxy).combatFleetId = 1
			end,
			onNo = function()
				return
			end
		})
	end
end

function var0_0.listNotificationInterests(arg0_26)
	return {
		FleetProxy.FLEET_UPDATED,
		FleetProxy.FLEET_RENAMED,
		GAME.UPDATE_FLEET_DONE,
		PlayerProxy.UPDATED,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COOMMANDER_EQUIP_TO_FLEET_DONE
	}
end

function var0_0.handleNotification(arg0_27, arg1_27)
	local var0_27 = arg1_27:getName()
	local var1_27 = arg1_27:getBody()

	if var0_27 == FleetProxy.FLEET_UPDATED then
		local var2_27 = getProxy(FleetProxy):GetRegularFleets()

		arg0_27.viewComponent:SetFleets(var2_27)
	elseif var0_27 == FleetProxy.FLEET_RENAMED then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationMediator_changeNameSuccess"))

		local var3_27 = getProxy(FleetProxy):GetRegularFleets()

		arg0_27.viewComponent:SetFleets(var3_27)
		arg0_27.viewComponent:UpdateFleetView(true)
		arg0_27.viewComponent:DisplayRenamePanel(false)
	elseif var0_27 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var4_27 = getProxy(CommanderProxy)

		arg0_27.viewComponent:setCommanderPrefabFleet(var4_27:getPrefabFleet())
		arg0_27.viewComponent:updateCommanderFormation()
	elseif var0_27 == GAME.COOMMANDER_EQUIP_TO_FLEET_DONE then
		arg0_27.viewComponent:updateCommanderFormation()
	end
end

function var0_0.checkChangeShip(arg0_28, arg1_28, arg2_28)
	local var0_28 = getProxy(BayProxy)
	local var1_28 = getProxy(FleetProxy)
	local var2_28 = var0_28:getRawData()
	local var3_28 = arg2_28.configId
	local var4_28 = var1_28:GetRegularFleetByShip(arg2_28)

	if not (var4_28 and var4_28.id == arg0_28.id) and (not arg1_28 or not arg1_28:isSameKind(arg2_28)) then
		for iter0_28, iter1_28 in ipairs(arg0_28.ships) do
			if var2_28[iter1_28]:isSameKind(arg2_28) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end
	end

	return true
end

function var0_0.removeShipFromFleet(arg0_29, arg1_29)
	if not arg0_29:canRemove(arg1_29) then
		local var0_29, var1_29 = arg0_29:getShipPos(arg1_29)

		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg1_29:getConfigTable().name, arg0_29.name, Fleet.C_TEAM_NAME[var1_29]))

		return false
	end

	arg0_29:removeShip(arg1_29)

	getProxy(FleetProxy).EdittingFleet = arg0_29

	return true
end

function var0_0.saveEdit()
	getProxy(FleetProxy):saveEdittingFleet()
end

function var0_0.getDockCallbackFuncs(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = getProxy(FleetProxy)
	local var1_31 = getProxy(BayProxy)
	local var2_31 = getProxy(ChapterProxy)

	local function var3_31(arg0_32, arg1_32)
		local var0_32, var1_32 = ShipStatus.ShipStatusCheck("inFleet", arg0_32, arg1_32)

		if not var0_32 then
			return var0_32, var1_32
		end

		local var2_32, var3_32 = var0_0.checkChangeShip(arg2_31, arg1_31, arg0_32)

		if not var2_32 then
			return false, var3_32
		end

		local var4_32 = var0_31:GetRegularFleetByShip(arg0_32)

		if var4_32 ~= nil and var4_32.id ~= arg2_31.id then
			if arg1_31 == nil and not var4_32:canRemove(arg0_32) then
				local var5_32, var6_32 = var4_32:getShipPos(arg0_32)

				return false, i18n("ship_formationMediator_replaceError_onlyShip", var4_32.defaultName, Fleet.C_TEAM_NAME[var6_32])
			end

			if arg1_31 == nil then
				return true
			else
				local var7_32, var8_32 = var0_0.checkChangeShip(var4_32, arg0_32, arg1_31)
				local var9_32 = var8_32

				if not var7_32 then
					return false, var9_32
				end
			end
		end

		return true
	end

	local function var4_31(arg0_33, arg1_33, arg2_33)
		local var0_33 = var1_31:getShipById(arg0_33[1])

		if not var0_33 then
			arg1_33()

			return
		end

		local var1_33 = var0_31:GetRegularFleetByShip(var0_33)

		if var1_33 and var1_33.id ~= arg2_31.id then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n("ship_formationMediator_quest_replace", var1_33.defaultName),
				onYes = arg1_33
			})
		elseif var2_31:CheckUnitInSupportFleet(var0_33) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n("ship_formationMediator_request_replace_support"),
				onYes = arg1_33
			})
		else
			arg1_33()

			return
		end
	end

	local function var5_31(arg0_34)
		local var0_34 = var1_31:getShipById(arg0_34[1])

		if not var0_34 then
			if arg1_31 == nil then
				return
			end

			var0_0.removeShipFromFleet(arg2_31, arg1_31)

			return
		end

		local function var1_34()
			local var0_35 = var0_31:GetRegularFleetByShip(var0_34)
			local var1_35 = arg2_31:getShipPos(arg1_31)

			if var0_35 == nil then
				if arg1_31 == nil then
					arg2_31:insertShip(var0_34, nil, arg3_31)
				else
					arg2_31:removeShip(arg1_31)
					arg2_31:insertShip(var0_34, var1_35, arg3_31)
				end

				var0_31.EdittingFleet = arg2_31

				return
			end

			local var2_35 = var0_35:getShipPos(var0_34)

			if var0_35.id == arg2_31.id then
				if arg1_31 == nil then
					arg2_31:removeShip(var0_34)
					arg2_31:insertShip(var0_34, nil, arg3_31)

					var0_31.EdittingFleet = arg2_31

					return
				end

				if arg1_31.id == var0_34.id then
					return
				end

				arg2_31:removeShip(arg1_31)
				arg2_31:removeShip(var0_34)

				if var2_35 < var1_35 then
					arg2_31:insertShip(arg1_31, var2_35, arg3_31)
					arg2_31:insertShip(var0_34, var1_35, arg3_31)
				else
					arg2_31:insertShip(var0_34, var1_35, arg3_31)
					arg2_31:insertShip(arg1_31, var2_35, arg3_31)
				end

				var0_31.EdittingFleet = arg2_31

				return
			end

			if not var0_35:canRemove(var0_34) and arg1_31 == nil then
				local var3_35, var4_35 = var0_35:getShipPos(var0_34)

				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationMediator_replaceError_onlyShip", var0_35.defaultName, Fleet.C_TEAM_NAME[var4_35]))
			else
				var0_35:removeShip(var0_34)

				if arg1_31 then
					var0_35:insertShip(arg1_31, var2_35, arg3_31)
					arg0_31:sendNotification(GAME.UPDATE_FLEET, {
						fleet = var0_35
					})
					arg2_31:removeShip(arg1_31)
					arg2_31:insertShip(var0_34, var1_35, arg3_31)

					var0_31.EdittingFleet = arg2_31

					var0_0.saveEdit()
					arg0_31:sendNotification(GAME.UPDATE_FLEET, {
						fleet = arg2_31
					})
				else
					arg0_31:sendNotification(GAME.UPDATE_FLEET, {
						fleet = var0_35
					})
					arg2_31:insertShip(var0_34, nil, arg3_31)

					var0_31.EdittingFleet = arg2_31

					var0_0.saveEdit()
					arg0_31:sendNotification(GAME.UPDATE_FLEET, {
						fleet = arg2_31
					})
				end
			end
		end

		if var2_31:CheckUnitInSupportFleet(var0_34) then
			arg0_31:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
				shipId = var0_34.id,
				callback = var1_34
			})
		else
			var1_34()
		end
	end

	return var3_31, var4_31, var5_31
end

return var0_0
