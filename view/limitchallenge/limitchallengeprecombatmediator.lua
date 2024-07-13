local var0_0 = class("LimitChallengePreCombatMediator", import("view.base.ContextMediator"))

var0_0.ON_UPDATE_CUSTOM_FLEET = "LimitChallengePreCombatMediator:ON_UPDATE_CUSTOM_FLEET"
var0_0.ON_START = "LimitChallengePreCombatMediator:ON_START"
var0_0.BEGIN_STAGE = "LimitChallengePreCombatMediator:BEGIN_STAGE"
var0_0.OPEN_SHIP_INFO = "LimitChallengePreCombatMediator:OPEN_SHIP_INFO"
var0_0.CHANGE_FLEET_SHIP = "LimitChallengePreCombatMediator:CHANGE_FLEET_SHIP"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "LimitChallengePreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.REMOVE_SHIP = "LimitChallengePreCombatMediator:REMOVE_SHIP"
var0_0.ON_AUTO = "LimitChallengePreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "LimitChallengePreCombatMediator:ON_SUB_AUTO"
var0_0.ON_CHANGE_FLEET = "LimitChallengePreCombatMediator:ON_CHANGE_FLEET"
var0_0.ON_CMD_SKILL = "LimitChallengePreCombatMediator:ON_CMD_SKILL"
var0_0.ON_SELECT_COMMANDER = "LimitChallengePreCombatMediator:ON_SELECT_COMMANDER"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()

	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:SetShips(arg0_1.ships)

	local var0_1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "CommanderCatMediator") and not LOCK_COMMANDER

	arg0_1.viewComponent:SetOpenCommander(var0_1)

	local var1_1 = _.map({
		FleetProxy.CHALLENGE_FLEET_ID,
		FleetProxy.CHALLENGE_SUB_FLEET_ID
	}, function(arg0_2)
		return getProxy(FleetProxy):getFleetById(arg0_2)
	end)

	arg0_1.fleets = var1_1
	arg0_1.contextData.fleets = var1_1

	arg0_1.viewComponent:SetFleets(var1_1)

	arg0_1.contextData.fleetIndex = arg0_1.contextData.fleetIndex or 1

	local var2_1 = var1_1[arg0_1.contextData.fleetIndex]

	arg0_1.viewComponent:SetCurrentFleet(var2_1.id)
	arg0_1.viewComponent:SetSubFlag(var1_1[#var1_1]:isLegalToFight() == true)
	arg0_1.viewComponent:SetStageID(arg0_1.contextData.stageId)
end

function var0_0.bindEvent(arg0_3)
	arg0_3:bind(var0_0.ON_CHANGE_FLEET, function(arg0_4, arg1_4)
		arg0_3:changeFleet(arg1_4)
	end)
	arg0_3:bind(var0_0.ON_AUTO, function(arg0_5, arg1_5)
		arg0_3:onAutoBtn(arg1_5)
	end)
	arg0_3:bind(var0_0.ON_SUB_AUTO, function(arg0_6, arg1_6)
		arg0_3:onAutoSubBtn(arg1_6)
	end)
	arg0_3:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_7, arg1_7)
		arg0_3:refreshEdit(arg1_7)
	end)
	arg0_3:bind(var0_0.REMOVE_SHIP, function(arg0_8, arg1_8, arg2_8)
		arg0_3:removeShipFromFleet(arg2_8, arg1_8)
		arg0_3:refreshEdit(arg2_8)
	end)
	arg0_3:bind(var0_0.OPEN_SHIP_INFO, function(arg0_9, arg1_9, arg2_9)
		local var0_9 = {}

		for iter0_9, iter1_9 in ipairs(arg2_9:getShipIds()) do
			table.insert(var0_9, arg0_3.ships[iter1_9])
		end

		arg0_3:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_9,
			shipVOs = var0_9
		})
	end)
	arg0_3:bind(var0_0.CHANGE_FLEET_SHIP, function(arg0_10, arg1_10, arg2_10, arg3_10)
		local var0_10 = _.flatten(_.map(arg0_3.contextData.fleets, function(arg0_11)
			return arg0_11:GetRawShipIds()
		end))
		local var1_10, var2_10, var3_10 = var0_0.getDockCallbackFuncs(arg1_10, arg2_10, arg3_10, var0_10, arg0_3.contextData.actId)

		arg0_3:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			useBlackBlock = true,
			selectedMin = 0,
			skipSelect = true,
			selectedMax = 1,
			energyDisplay = false,
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = arg1_10 ~= nil,
			teamFilter = arg3_10,
			onShip = var1_10,
			confirmSelect = var2_10,
			onSelected = var3_10,
			hideTagFlags = ShipStatus.TAG_HIDE_CHALLENGE,
			blockTagFlags = {
				inEvent = true
			},
			otherSelectedIds = var0_10,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0_3:bind(var0_0.ON_UPDATE_CUSTOM_FLEET, function(arg0_12)
		_.each(arg0_3.contextData.fleets, function(arg0_13)
			arg0_3:sendNotification(GAME.UPDATE_FLEET, {
				fleet = arg0_13
			})

			local var0_13 = arg0_13:GetRawCommanderIds()

			_.each({
				1,
				2
			}, function(arg0_14)
				arg0_3:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
					fleetId = arg0_13.id,
					pos = arg0_14,
					commanderId = var0_13[arg0_14] or 0
				})
			end)
		end)
	end)
	arg0_3:bind(var0_0.ON_START, function(arg0_15)
		arg0_3.viewComponent:emit(var0_0.ON_UPDATE_CUSTOM_FLEET)
		seriesAsync({
			function(arg0_16)
				for iter0_16 = 1, #arg0_3.contextData.fleets - 1 do
					if arg0_3.contextData.fleets[iter0_16]:isLegalToFight() ~= true then
						pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

						return
					end
				end

				local var0_16 = {}

				if _.any(arg0_3.contextData.fleets, function(arg0_17)
					return _.any(arg0_17:GetRawShipIds(), function(arg0_18)
						local var0_18 = getProxy(BayProxy):RawGetShipById(arg0_18)

						if var0_16[var0_18:getGroupId()] then
							return true
						end

						var0_16[var0_18:getGroupId()] = true
					end)
				end) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_exist_same_kind_ship"))

					return
				end

				arg0_16()
			end,
			function(arg0_19)
				table.SerialIpairsAsync(arg0_3.contextData.fleets, function(arg0_20, arg1_20, arg2_20)
					local var0_20, var1_20 = arg1_20:HaveShipsInEvent()

					if var0_20 then
						pg.TipsMgr.GetInstance():ShowTips(var1_20)

						return
					end

					local var2_20 = arg0_3.contextData.actId

					if _.any(arg1_20:getShipIds(), function(arg0_21)
						local var0_21 = getProxy(BayProxy):RawGetShipById(arg0_21)

						if not var0_21 then
							return
						end

						local var1_21, var2_21 = ShipStatus.ShipStatusCheck("inChallenge", var0_21)

						if not var1_21 then
							pg.TipsMgr.GetInstance():ShowTips(var2_21)

							return true
						end
					end) then
						return
					end

					arg2_20()
				end, arg0_19)
			end,
			function(arg0_22)
				arg0_3.viewComponent:emit(var0_0.BEGIN_STAGE)
			end
		})
	end)
	arg0_3:bind(var0_0.BEGIN_STAGE, function(arg0_23)
		arg0_3:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0_3.contextData.stageId,
			system = arg0_3.contextData.system,
			actId = arg0_3.contextData.actId
		})
	end)
	arg0_3:bind(var0_0.ON_CMD_SKILL, function(arg0_24, arg1_24)
		arg0_3:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_24
			}
		}))
	end)
	arg0_3:bind(var0_0.ON_SELECT_COMMANDER, function(arg0_25, arg1_25, arg2_25)
		local var0_25 = _.map({
			FleetProxy.CHALLENGE_FLEET_ID,
			FleetProxy.CHALLENGE_SUB_FLEET_ID
		}, function(arg0_26)
			return getProxy(FleetProxy):getFleetById(arg0_26)
		end)

		var0_0.onSelectCommander(var0_25, arg1_25, arg2_25)
	end)
end

function var0_0.onAutoBtn(arg0_27, arg1_27)
	local var0_27 = arg1_27.isOn
	local var1_27 = arg1_27.toggle

	arg0_27:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_27,
		toggle = var1_27,
		system = arg0_27.contextData.system
	})
end

function var0_0.onAutoSubBtn(arg0_28, arg1_28)
	local var0_28 = arg1_28.isOn
	local var1_28 = arg1_28.toggle

	arg0_28:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_28,
		toggle = var1_28,
		system = arg0_28.contextData.system
	})
end

function var0_0.changeFleet(arg0_29, arg1_29)
	arg0_29.contextData.fleetIndex = table.indexof(arg0_29.contextData.fleets, _.detect(arg0_29.contextData.fleets, function(arg0_30)
		return arg0_30.id == arg1_29
	end))

	arg0_29.viewComponent:SetCurrentFleet(arg1_29)
	arg0_29.viewComponent:UpdateFleetView(true)
	arg0_29.viewComponent:SetFleetStepper()
end

function var0_0.refreshEdit(arg0_31, arg1_31)
	arg0_31.viewComponent:UpdateFleetView(false)

	local var0_31 = arg0_31.contextData.fleets

	arg0_31.viewComponent:SetSubFlag(var0_31[#var0_31]:isLegalToFight() == true)
	getProxy(FleetProxy):updateFleet(arg1_31)
end

function var0_0.removeShipFromFleet(arg0_32, arg1_32, arg2_32)
	if not arg1_32:canRemove(arg2_32) then
		local var0_32, var1_32 = arg1_32:getShipPos(arg2_32)

		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2_32:getConfigTable().name, arg1_32.name, Fleet.C_TEAM_NAME[var1_32]))

		return false
	end

	arg1_32:removeShip(arg2_32)

	return true
end

function var0_0.listNotificationInterests(arg0_33)
	return {
		GAME.BEGIN_STAGE_DONE,
		GAME.BEGIN_STAGE_ERRO
	}
end

function var0_0.handleNotification(arg0_34, arg1_34)
	local var0_34 = arg1_34:getName()
	local var1_34 = arg1_34:getBody()

	if var0_34 == GAME.BEGIN_STAGE_DONE then
		arg0_34:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_34)
	elseif var0_34 == GAME.BEGIN_STAGE_ERRO and var1_34 == 3 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("battle_preCombatMediator_timeout"),
			onYes = function()
				arg0_34.viewComponent:emit(BaseUI.ON_CLOSE)
			end
		})
	end
end

function var0_0.remove(arg0_36)
	var0_0.super.remove(arg0_36)
end

function var0_0.getDockCallbackFuncs(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	local var0_37 = getProxy(BayProxy)

	local function var1_37(arg0_38, arg1_38)
		local var0_38, var1_38 = ShipStatus.ShipStatusCheck("inChallenge", arg0_38, arg1_38)

		if not var0_38 then
			return var0_38, var1_38
		end

		if arg0_37 and arg0_37:isSameKind(arg0_38) then
			return true
		end

		for iter0_38, iter1_38 in ipairs(arg3_37) do
			if arg0_38:isSameKind(var0_37:getShipById(iter1_38)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_37(arg0_39, arg1_39, arg2_39)
		arg1_39()
	end

	local function var3_37(arg0_40)
		if #arg0_40 == 0 then
			if arg0_37 then
				arg1_37:removeShip(arg0_37)
			end
		elseif #arg0_40 > 0 then
			local var0_40 = arg1_37:getShipPos(arg0_37)
			local var1_40 = var0_37:getShipById(arg0_40[1])

			if var0_40 then
				arg1_37:removeShip(arg0_37)

				if var1_40.id == arg0_37.id then
					var0_40 = nil
				end
			end

			arg1_37:insertShip(var1_40, var0_40, arg2_37)
			arg1_37:RemoveUnusedItems()
		end

		getProxy(FleetProxy):updateFleet(arg1_37)
	end

	return var1_37, var2_37, var3_37
end

function var0_0.onSelectCommander(arg0_41, arg1_41, arg2_41)
	local var0_41 = _.detect(arg0_41, function(arg0_42)
		return arg0_42.id == arg2_41
	end)

	assert(var0_41)

	local var1_41 = var0_41:getCommanderByPos(arg1_41)

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
		maxCount = 1,
		mode = CommanderCatScene.MODE_SELECT,
		fleetType = CommanderCatScene.FLEET_TYPE_LIMIT_CHALLENGE,
		activeCommander = var1_41,
		ignoredIds = {},
		onCommander = function(arg0_43)
			return true
		end,
		onSelected = function(arg0_44, arg1_44)
			local var0_44 = arg0_44[1]
			local var1_44 = getProxy(CommanderProxy):getCommanderById(var0_44)

			for iter0_44, iter1_44 in pairs(arg0_41) do
				if iter1_44.id == arg2_41 then
					local var2_44 = iter1_44:getCommanders()

					for iter2_44, iter3_44 in pairs(var2_44) do
						if iter3_44.groupId == var1_44.groupId and iter2_44 ~= arg1_41 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

							return
						end
					end
				else
					local var3_44 = iter1_44:getCommanders()

					for iter4_44, iter5_44 in pairs(var3_44) do
						if var0_44 == iter5_44.id then
							pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

							return
						end
					end
				end
			end

			var0_41:updateCommanderByPos(arg1_41, var1_44)
			getProxy(FleetProxy):updateFleet(var0_41)
			arg1_44()
		end,
		onQuit = function(arg0_45)
			var0_41:updateCommanderByPos(arg1_41, nil)
			getProxy(FleetProxy):updateFleet(var0_41)
			arg0_45()
		end
	})
end

return var0_0
