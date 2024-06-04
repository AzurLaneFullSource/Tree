local var0 = class("LimitChallengePreCombatMediator", import("view.base.ContextMediator"))

var0.ON_UPDATE_CUSTOM_FLEET = "LimitChallengePreCombatMediator:ON_UPDATE_CUSTOM_FLEET"
var0.ON_START = "LimitChallengePreCombatMediator:ON_START"
var0.BEGIN_STAGE = "LimitChallengePreCombatMediator:BEGIN_STAGE"
var0.OPEN_SHIP_INFO = "LimitChallengePreCombatMediator:OPEN_SHIP_INFO"
var0.CHANGE_FLEET_SHIP = "LimitChallengePreCombatMediator:CHANGE_FLEET_SHIP"
var0.CHANGE_FLEET_SHIPS_ORDER = "LimitChallengePreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0.REMOVE_SHIP = "LimitChallengePreCombatMediator:REMOVE_SHIP"
var0.ON_AUTO = "LimitChallengePreCombatMediator:ON_AUTO"
var0.ON_SUB_AUTO = "LimitChallengePreCombatMediator:ON_SUB_AUTO"
var0.ON_CHANGE_FLEET = "LimitChallengePreCombatMediator:ON_CHANGE_FLEET"
var0.ON_CMD_SKILL = "LimitChallengePreCombatMediator:ON_CMD_SKILL"
var0.ON_SELECT_COMMANDER = "LimitChallengePreCombatMediator:ON_SELECT_COMMANDER"

function var0.register(arg0)
	arg0:bindEvent()

	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:SetShips(arg0.ships)

	local var0 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "CommanderCatMediator") and not LOCK_COMMANDER

	arg0.viewComponent:SetOpenCommander(var0)

	local var1 = _.map({
		FleetProxy.CHALLENGE_FLEET_ID,
		FleetProxy.CHALLENGE_SUB_FLEET_ID
	}, function(arg0)
		return getProxy(FleetProxy):getFleetById(arg0)
	end)

	arg0.fleets = var1
	arg0.contextData.fleets = var1

	arg0.viewComponent:SetFleets(var1)

	arg0.contextData.fleetIndex = arg0.contextData.fleetIndex or 1

	local var2 = var1[arg0.contextData.fleetIndex]

	arg0.viewComponent:SetCurrentFleet(var2.id)
	arg0.viewComponent:SetSubFlag(var1[#var1]:isLegalToFight() == true)
	arg0.viewComponent:SetStageID(arg0.contextData.stageId)
end

function var0.bindEvent(arg0)
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
		arg0:removeShipFromFleet(arg2, arg1)
		arg0:refreshEdit(arg2)
	end)
	arg0:bind(var0.OPEN_SHIP_INFO, function(arg0, arg1, arg2)
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
		local var0 = _.flatten(_.map(arg0.contextData.fleets, function(arg0)
			return arg0:GetRawShipIds()
		end))
		local var1, var2, var3 = var0.getDockCallbackFuncs(arg1, arg2, arg3, var0, arg0.contextData.actId)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			useBlackBlock = true,
			selectedMin = 0,
			skipSelect = true,
			selectedMax = 1,
			energyDisplay = false,
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = arg1 ~= nil,
			teamFilter = arg3,
			onShip = var1,
			confirmSelect = var2,
			onSelected = var3,
			hideTagFlags = ShipStatus.TAG_HIDE_CHALLENGE,
			blockTagFlags = {
				inEvent = true
			},
			otherSelectedIds = var0,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0:bind(var0.ON_UPDATE_CUSTOM_FLEET, function(arg0)
		_.each(arg0.contextData.fleets, function(arg0)
			arg0:sendNotification(GAME.UPDATE_FLEET, {
				fleet = arg0
			})

			local var0 = arg0:GetRawCommanderIds()

			_.each({
				1,
				2
			}, function(arg0)
				arg0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
					fleetId = arg0.id,
					pos = arg0,
					commanderId = var0[arg0] or 0
				})
			end)
		end)
	end)
	arg0:bind(var0.ON_START, function(arg0)
		arg0.viewComponent:emit(var0.ON_UPDATE_CUSTOM_FLEET)
		seriesAsync({
			function(arg0)
				for iter0 = 1, #arg0.contextData.fleets - 1 do
					if arg0.contextData.fleets[iter0]:isLegalToFight() ~= true then
						pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

						return
					end
				end

				local var0 = {}

				if _.any(arg0.contextData.fleets, function(arg0)
					return _.any(arg0:GetRawShipIds(), function(arg0)
						local var0 = getProxy(BayProxy):RawGetShipById(arg0)

						if var0[var0:getGroupId()] then
							return true
						end

						var0[var0:getGroupId()] = true
					end)
				end) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_exist_same_kind_ship"))

					return
				end

				arg0()
			end,
			function(arg0)
				table.SerialIpairsAsync(arg0.contextData.fleets, function(arg0, arg1, arg2)
					local var0, var1 = arg1:HaveShipsInEvent()

					if var0 then
						pg.TipsMgr.GetInstance():ShowTips(var1)

						return
					end

					local var2 = arg0.contextData.actId

					if _.any(arg1:getShipIds(), function(arg0)
						local var0 = getProxy(BayProxy):RawGetShipById(arg0)

						if not var0 then
							return
						end

						local var1, var2 = ShipStatus.ShipStatusCheck("inChallenge", var0)

						if not var1 then
							pg.TipsMgr.GetInstance():ShowTips(var2)

							return true
						end
					end) then
						return
					end

					arg2()
				end, arg0)
			end,
			function(arg0)
				arg0.viewComponent:emit(var0.BEGIN_STAGE)
			end
		})
	end)
	arg0:bind(var0.BEGIN_STAGE, function(arg0)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0.contextData.stageId,
			system = arg0.contextData.system,
			actId = arg0.contextData.actId
		})
	end)
	arg0:bind(var0.ON_CMD_SKILL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_SELECT_COMMANDER, function(arg0, arg1, arg2)
		local var0 = _.map({
			FleetProxy.CHALLENGE_FLEET_ID,
			FleetProxy.CHALLENGE_SUB_FLEET_ID
		}, function(arg0)
			return getProxy(FleetProxy):getFleetById(arg0)
		end)

		var0.onSelectCommander(var0, arg1, arg2)
	end)
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1,
		system = arg0.contextData.system
	})
end

function var0.onAutoSubBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0,
		toggle = var1,
		system = arg0.contextData.system
	})
end

function var0.changeFleet(arg0, arg1)
	arg0.contextData.fleetIndex = table.indexof(arg0.contextData.fleets, _.detect(arg0.contextData.fleets, function(arg0)
		return arg0.id == arg1
	end))

	arg0.viewComponent:SetCurrentFleet(arg1)
	arg0.viewComponent:UpdateFleetView(true)
	arg0.viewComponent:SetFleetStepper()
end

function var0.refreshEdit(arg0, arg1)
	arg0.viewComponent:UpdateFleetView(false)

	local var0 = arg0.contextData.fleets

	arg0.viewComponent:SetSubFlag(var0[#var0]:isLegalToFight() == true)
	getProxy(FleetProxy):updateFleet(arg1)
end

function var0.removeShipFromFleet(arg0, arg1, arg2)
	if not arg1:canRemove(arg2) then
		local var0, var1 = arg1:getShipPos(arg2)

		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2:getConfigTable().name, arg1.name, Fleet.C_TEAM_NAME[var1]))

		return false
	end

	arg1:removeShip(arg2)

	return true
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BEGIN_STAGE_DONE,
		GAME.BEGIN_STAGE_ERRO
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
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

function var0.remove(arg0)
	var0.super.remove(arg0)
end

function var0.getDockCallbackFuncs(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(BayProxy)

	local function var1(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inChallenge", arg0, arg1)

		if not var0 then
			return var0, var1
		end

		if arg0 and arg0:isSameKind(arg0) then
			return true
		end

		for iter0, iter1 in ipairs(arg3) do
			if arg0:isSameKind(var0:getShipById(iter1)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2(arg0, arg1, arg2)
		arg1()
	end

	local function var3(arg0)
		if #arg0 == 0 then
			if arg0 then
				arg1:removeShip(arg0)
			end
		elseif #arg0 > 0 then
			local var0 = arg1:getShipPos(arg0)
			local var1 = var0:getShipById(arg0[1])

			if var0 then
				arg1:removeShip(arg0)

				if var1.id == arg0.id then
					var0 = nil
				end
			end

			arg1:insertShip(var1, var0, arg2)
			arg1:RemoveUnusedItems()
		end

		getProxy(FleetProxy):updateFleet(arg1)
	end

	return var1, var2, var3
end

function var0.onSelectCommander(arg0, arg1, arg2)
	local var0 = _.detect(arg0, function(arg0)
		return arg0.id == arg2
	end)

	assert(var0)

	local var1 = var0:getCommanderByPos(arg1)

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
		maxCount = 1,
		mode = CommanderCatScene.MODE_SELECT,
		fleetType = CommanderCatScene.FLEET_TYPE_LIMIT_CHALLENGE,
		activeCommander = var1,
		ignoredIds = {},
		onCommander = function(arg0)
			return true
		end,
		onSelected = function(arg0, arg1)
			local var0 = arg0[1]
			local var1 = getProxy(CommanderProxy):getCommanderById(var0)

			for iter0, iter1 in pairs(arg0) do
				if iter1.id == arg2 then
					local var2 = iter1:getCommanders()

					for iter2, iter3 in pairs(var2) do
						if iter3.groupId == var1.groupId and iter2 ~= arg1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

							return
						end
					end
				else
					local var3 = iter1:getCommanders()

					for iter4, iter5 in pairs(var3) do
						if var0 == iter5.id then
							pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

							return
						end
					end
				end
			end

			var0:updateCommanderByPos(arg1, var1)
			getProxy(FleetProxy):updateFleet(var0)
			arg1()
		end,
		onQuit = function(arg0)
			var0:updateCommanderByPos(arg1, nil)
			getProxy(FleetProxy):updateFleet(var0)
			arg0()
		end
	})
end

return var0
