local var0 = class("FormationMediator", import("..base.ContextMediator"))

var0.OPEN_SHIP_INFO = "FormationMediator:OPEN_SHIP_INFO"
var0.ON_CHANGE_FLEET = "FormationMediator:ON_CHANGE_FLEET"
var0.CHANGE_FLEET_NAME = "FormationMediator:CHANGE_FLEET_NAME"
var0.CHANGE_FLEET_SHIP = "FormationMediator:CHANGE_FLEET_SHIP"
var0.REMOVE_SHIP = "FormationMediator:REMOVE_SHIP"
var0.CHANGE_FLEET_FORMATION = "FormationMediator:CHANGE_FLEET_FORMATION"
var0.CHANGE_FLEET_SHIPS_ORDER = "FormationMediator:CHANGE_FLEET_SHIPS_ORDER"
var0.COMMIT_FLEET = "FormationMediator:COMMIT_FLEET"
var0.ON_SELECT_COMMANDER = "FormationMediator:ON_SELECT_COMMANDER"
var0.ON_CMD_SKILL = "FormationMediator:ON_CMD_SKILL"
var0.COMMANDER_FORMATION_OP = "FormationMediator:COMMANDER_FORMATION_OP"

function var0.register(arg0)
	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:setShips(arg0.ships)

	local var0 = getProxy(FleetProxy)
	local var1 = var0:GetRegularFleets()

	if var0.EdittingFleet ~= nil then
		var1[var0.EdittingFleet.id] = var0.EdittingFleet
	end

	arg0.viewComponent:SetFleets(var1)

	local var2 = getProxy(CommanderProxy)

	arg0.viewComponent:setCommanderPrefabFleet(var2:getPrefabFleet())
	arg0:bind(var0.ON_CMD_SKILL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1
			}
		}))
	end)
	arg0:bind(var0.COMMIT_FLEET, function(arg0, arg1)
		arg0.commitEdit(arg1)
	end)
	arg0:bind(var0.CHANGE_FLEET_NAME, function(arg0, arg1, arg2)
		arg0.commitEdit(function()
			arg0:sendNotification(GAME.RENAME_FLEET, {
				id = arg1,
				name = arg2
			})
		end)
	end)
	arg0:bind(var0.OPEN_SHIP_INFO, function(arg0, arg1, arg2, arg3)
		local function var0()
			arg0.contextData.number = arg2.id
			arg0.contextData.toggle = arg3

			local var0 = {}

			for iter0, iter1 in ipairs(arg2:getShipIds()) do
				table.insert(var0, arg0.ships[iter1])
			end

			arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				shipId = arg1,
				shipVOs = var0
			})
		end

		arg0.commitEdit(var0)
	end)
	arg0:bind(var0.ON_CHANGE_FLEET, function(arg0, arg1)
		arg0.commitEdit(function()
			arg0.viewComponent:SetFleets(var0:GetRegularFleets())
			arg0.viewComponent:SetCurrentFleetID(arg1)
			arg0.viewComponent:UpdateFleetView(true)
		end)
	end)
	arg0:bind(var0.CHANGE_FLEET_FORMATION, function(arg0, arg1, arg2)
		arg2.formation = arg1

		arg0:refreshEdit(arg2)
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIPS_ORDER, function(arg0, arg1)
		arg0:refreshEdit(arg1)
	end)
	arg0:bind(var0.REMOVE_SHIP, function(arg0, arg1, arg2)
		var0.removeShipFromFleet(arg2, arg1)
		arg0:refreshEdit(arg2)
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIP, function(arg0, arg1, arg2, arg3, arg4)
		arg0.contextData.number = arg2.id
		arg0.contextData.toggle = arg3

		arg0.saveEdit()

		local var0 = 0

		if arg2.id == 1 and #arg2.ships <= 1 and arg1 ~= nil then
			var0 = 1
		end

		local var1 = {}

		for iter0, iter1 in ipairs(arg2.ships) do
			if not arg1 or iter1 ~= arg1.id then
				table.insert(var1, iter1)
			end
		end

		local var2, var3, var4 = var0.getDockCallbackFuncs(arg0, arg1, arg2, arg4)
		local var5 = arg0.commitEdit

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			energyDisplay = true,
			useBlackBlock = true,
			selectedMin = var0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = arg1 ~= nil,
			teamFilter = arg4,
			leftTopInfo = i18n("word_formation"),
			onShip = var2,
			confirmSelect = var3,
			onSelected = var4,
			onQuickHome = var5,
			hideTagFlags = ShipStatus.TAG_HIDE_FORMATION,
			otherSelectedIds = var1,
			preView = arg0.viewComponent.__cname
		})
	end)
	arg0:bind(var0.ON_SELECT_COMMANDER, function(arg0, arg1, arg2)
		arg0.contextData.toggle = FormationUI.TOGGLE_FORMATION
		arg0.contextData.number = arg2

		var0.onSelectCommander(arg1, arg2)
	end)
	arg0:bind(var0.COMMANDER_FORMATION_OP, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1
		})
	end)

	local var3 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var3)
end

function var0.onSelectCommander(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(FleetProxy):getFleetById(arg1):getCommanderByPos(arg0)
	local var2 = {}

	for iter0, iter1 in ipairs(var2) do
		if var1 and iter1 == var1.id then
			table.remove(var2, iter0)

			break
		end
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
		maxCount = 1,
		mode = CommanderCatScene.MODE_SELECT,
		fleetType = CommanderCatScene.FLEET_TYPE_COMMON,
		activeCommander = var1,
		ignoredIds = var2,
		onCommander = function(arg0)
			return true
		end,
		onSelected = function(arg0, arg1)
			local var0 = arg0[1]

			pg.m02:sendNotification(GAME.SELECT_FLEET_COMMANDER, {
				fleetId = arg1,
				pos = arg0,
				commanderId = var0,
				callback = function()
					if var0.EdittingFleet then
						local var0 = getProxy(FleetProxy):getFleetById(var0.EdittingFleet.id)

						var0.EdittingFleet.commanderIds = var0.commanderIds
					end

					arg1()
				end
			})
		end,
		onQuit = function(arg0)
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = arg1,
				pos = arg0,
				callback = function(arg0)
					if var0.EdittingFleet then
						var0.EdittingFleet.commanderIds = arg0.commanderIds
					end

					arg0()
				end
			})
		end
	})
end

function var0.refreshEdit(arg0, arg1)
	local var0 = getProxy(FleetProxy)

	var0.EdittingFleet = arg1

	local var1 = var0:GetRegularFleets()

	var1[arg1.id] = arg1

	arg0.viewComponent:SetFleets(var1)
	arg0.viewComponent:UpdateFleetView(false)
end

function var0.commitEdit(arg0)
	local var0 = getProxy(FleetProxy)
	local var1 = var0.EdittingFleet

	if var1 == nil or var1:isFirstFleet() or var1:isLegalToFight() == true or #var1.ships == 0 then
		var0:commitEdittingFleet(arg0)
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_formationMediaror_trash_warning", var1.defaultName),
			onYes = function()
				local var0 = getProxy(BayProxy):getRawData()
				local var1 = var1.ships
				local var2 = #var1

				for iter0 = #var1, 1, -1 do
					var1:removeShip(var0[var1[iter0]])
				end

				var0:commitEdittingFleet(arg0)

				getProxy(PlayerProxy).combatFleetId = 1
			end,
			onNo = function()
				return
			end
		})
	end
end

function var0.listNotificationInterests(arg0)
	return {
		FleetProxy.FLEET_UPDATED,
		FleetProxy.FLEET_RENAMED,
		GAME.UPDATE_FLEET_DONE,
		PlayerProxy.UPDATED,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COOMMANDER_EQUIP_TO_FLEET_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == FleetProxy.FLEET_UPDATED then
		local var2 = getProxy(FleetProxy):GetRegularFleets()

		arg0.viewComponent:SetFleets(var2)
	elseif var0 == FleetProxy.FLEET_RENAMED then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationMediator_changeNameSuccess"))

		local var3 = getProxy(FleetProxy):GetRegularFleets()

		arg0.viewComponent:SetFleets(var3)
		arg0.viewComponent:UpdateFleetView(true)
		arg0.viewComponent:DisplayRenamePanel(false)
	elseif var0 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var4 = getProxy(CommanderProxy)

		arg0.viewComponent:setCommanderPrefabFleet(var4:getPrefabFleet())
		arg0.viewComponent:updateCommanderFormation()
	elseif var0 == GAME.COOMMANDER_EQUIP_TO_FLEET_DONE then
		arg0.viewComponent:updateCommanderFormation()
	end
end

function var0.checkChangeShip(arg0, arg1, arg2)
	local var0 = getProxy(BayProxy)
	local var1 = getProxy(FleetProxy)
	local var2 = var0:getRawData()
	local var3 = arg2.configId
	local var4 = var1:GetRegularFleetByShip(arg2)

	if not (var4 and var4.id == arg0.id) and (not arg1 or not arg1:isSameKind(arg2)) then
		for iter0, iter1 in ipairs(arg0.ships) do
			if var2[iter1]:isSameKind(arg2) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end
	end

	return true
end

function var0.removeShipFromFleet(arg0, arg1)
	if not arg0:canRemove(arg1) then
		local var0, var1 = arg0:getShipPos(arg1)

		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg1:getConfigTable().name, arg0.name, Fleet.C_TEAM_NAME[var1]))

		return false
	end

	arg0:removeShip(arg1)

	getProxy(FleetProxy).EdittingFleet = arg0

	return true
end

function var0.saveEdit()
	getProxy(FleetProxy):saveEdittingFleet()
end

function var0.getDockCallbackFuncs(arg0, arg1, arg2, arg3)
	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(BayProxy)
	local var2 = getProxy(ChapterProxy)

	local function var3(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inFleet", arg0, arg1)

		if not var0 then
			return var0, var1
		end

		local var2, var3 = var0.checkChangeShip(arg2, arg1, arg0)

		if not var2 then
			return false, var3
		end

		local var4 = var0:GetRegularFleetByShip(arg0)

		if var4 ~= nil and var4.id ~= arg2.id then
			if arg1 == nil and not var4:canRemove(arg0) then
				local var5, var6 = var4:getShipPos(arg0)

				return false, i18n("ship_formationMediator_replaceError_onlyShip", var4.defaultName, Fleet.C_TEAM_NAME[var6])
			end

			if arg1 == nil then
				return true
			else
				local var7, var8 = var0.checkChangeShip(var4, arg0, arg1)
				local var9 = var8

				if not var7 then
					return false, var9
				end
			end
		end

		return true
	end

	local function var4(arg0, arg1, arg2)
		local var0 = var1:getShipById(arg0[1])

		if not var0 then
			arg1()

			return
		end

		local var1 = var0:GetRegularFleetByShip(var0)

		if var1 and var1.id ~= arg2.id then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n("ship_formationMediator_quest_replace", var1.defaultName),
				onYes = arg1
			})
		elseif var2:CheckUnitInSupportFleet(var0) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n("ship_formationMediator_request_replace_support"),
				onYes = arg1
			})
		else
			arg1()

			return
		end
	end

	local function var5(arg0)
		local var0 = var1:getShipById(arg0[1])

		if not var0 then
			if arg1 == nil then
				return
			end

			var0.removeShipFromFleet(arg2, arg1)

			return
		end

		local function var1()
			local var0 = var0:GetRegularFleetByShip(var0)
			local var1 = arg2:getShipPos(arg1)

			if var0 == nil then
				if arg1 == nil then
					arg2:insertShip(var0, nil, arg3)
				else
					arg2:removeShip(arg1)
					arg2:insertShip(var0, var1, arg3)
				end

				var0.EdittingFleet = arg2

				return
			end

			local var2 = var0:getShipPos(var0)

			if var0.id == arg2.id then
				if arg1 == nil then
					arg2:removeShip(var0)
					arg2:insertShip(var0, nil, arg3)

					var0.EdittingFleet = arg2

					return
				end

				if arg1.id == var0.id then
					return
				end

				arg2:removeShip(arg1)
				arg2:removeShip(var0)

				if var2 < var1 then
					arg2:insertShip(arg1, var2, arg3)
					arg2:insertShip(var0, var1, arg3)
				else
					arg2:insertShip(var0, var1, arg3)
					arg2:insertShip(arg1, var2, arg3)
				end

				var0.EdittingFleet = arg2

				return
			end

			if not var0:canRemove(var0) and arg1 == nil then
				local var3, var4 = var0:getShipPos(var0)

				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationMediator_replaceError_onlyShip", var0.defaultName, Fleet.C_TEAM_NAME[var4]))
			else
				var0:removeShip(var0)

				if arg1 then
					var0:insertShip(arg1, var2, arg3)
					arg0:sendNotification(GAME.UPDATE_FLEET, {
						fleet = var0
					})
					arg2:removeShip(arg1)
					arg2:insertShip(var0, var1, arg3)

					var0.EdittingFleet = arg2

					var0.saveEdit()
					arg0:sendNotification(GAME.UPDATE_FLEET, {
						fleet = arg2
					})
				else
					arg0:sendNotification(GAME.UPDATE_FLEET, {
						fleet = var0
					})
					arg2:insertShip(var0, nil, arg3)

					var0.EdittingFleet = arg2

					var0.saveEdit()
					arg0:sendNotification(GAME.UPDATE_FLEET, {
						fleet = arg2
					})
				end
			end
		end

		if var2:CheckUnitInSupportFleet(var0) then
			arg0:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
				shipId = var0.id,
				callback = var1
			})
		else
			var1()
		end
	end

	return var3, var4, var5
end

return var0
