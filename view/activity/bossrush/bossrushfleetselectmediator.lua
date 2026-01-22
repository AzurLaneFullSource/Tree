local var0_0 = class("BossRushFleetSelectMediator", import("view.base.ContextMediator"))

var0_0.ON_OPEN_DECK = "BossRushFleetSelectMediator:ON_OPEN_DECK"
var0_0.ON_FLEET_SHIPINFO = "BossRushFleetSelectMediator:ON_FLEET_SHIPINFO"
var0_0.ON_TRACE = "BossRushFleetSelectMediator:ON_TRACE"
var0_0.ON_UPDATE_CUSTOM_FLEET = "BossRushFleetSelectMediator:ON_UPDATE_CUSTOM_FLEET"
var0_0.ON_PRECOMBAT = "BossRushFleetSelectMediator:ON_PRECOMBAT"
var0_0.ON_ELITE_RECOMMEND = "BossRushFleetSelectMediator:ON_ELITE_RECOMMEND"
var0_0.ON_ELITE_CLEAR = "BossRushFleetSelectMediator:ON_ELITE_CLEAR"
var0_0.OPEN_COMMANDER_PANEL = "BossRushFleetSelectMediator:OPEN_COMMANDER_PANEL"
var0_0.ON_SELECT_COMMANDER = "BossRushFleetSelectMediator:ON_SELECT_COMMANDER"
var0_0.ON_COMMANDER_SKILL = "BossRushFleetSelectMediator:ON_COMMANDER_SKILL"
var0_0.ON_SWITCH_MODE = "BossRushFleetSelectMediator:ON_SWITCH_MODE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_OPEN_DECK, function(arg0_2, arg1_2)
		local var0_2 = arg1_2.fleetIndex
		local var1_2 = arg1_2.shipVO
		local var2_2 = _.flatten(_.map(arg0_1.contextData.fleets, function(arg0_3)
			return arg0_3:GetRawShipIds()
		end))
		local var3_2 = arg1_2.teamType
		local var4_2, var5_2, var6_2 = arg0_1.getDockCallbackFuncs(var1_2, arg0_1.contextData.fleets[var0_2], var3_2, var2_2, arg0_1.contextData.actId)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1_2 ~= nil,
			teamFilter = var3_2,
			leftTopInfo = i18n("word_formation"),
			onShip = var4_2,
			confirmSelect = var5_2,
			onSelected = var6_2,
			hideTagFlags = setmetatable({
				inActivity = arg0_1.contextData.actId
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			otherSelectedIds = var2_2
		})
	end)
	arg0_1:bind(var0_0.ON_FLEET_SHIPINFO, function(arg0_4, arg1_4)
		local var0_4 = arg0_1.contextData.fleet

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_4.shipId,
			shipVOs = arg1_4.shipVOs
		})
	end)
	arg0_1:bind(var0_0.ON_UPDATE_CUSTOM_FLEET, function(arg0_5)
		_.each(arg0_1.contextData.fullFleets, function(arg0_6)
			getProxy(FleetProxy):updateActivityFleet(arg0_1.contextData.actId, arg0_6.id, arg0_6)
		end)

		local var0_5 = {}

		_.each(arg0_1.contextData.fullFleets, function(arg0_7)
			var0_5[arg0_7.id] = arg0_7
		end)
		arg0_1:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
			actID = arg0_1.contextData.actId,
			fleets = var0_5
		})
	end)
	arg0_1:bind(var0_0.ON_TRACE, function(arg0_8)
		arg0_1.viewComponent:emit(var0_0.ON_UPDATE_CUSTOM_FLEET)
		arg0_1:sendNotification(GAME.BOSSRUSH_TRACE, {
			actId = arg0_1.contextData.actId,
			seriesId = arg0_1.contextData.seriesData.id,
			mode = arg0_1.contextData.mode
		})
	end)
	arg0_1:bind(var0_0.ON_ELITE_RECOMMEND, function(arg0_9, arg1_9)
		local var0_9 = arg1_9.index
		local var1_9 = arg0_1.contextData.fleets[var0_9]
		local var2_9

		var2_9 = var0_9 == #arg0_1.contextData.fleets

		local var3_9 = table.shallowCopy(var1_9:GetRawShipIds())
		local var4_9 = underscore(arg0_1.contextData.fleets):chain():map(function(arg0_10)
			return arg0_10:GetRawShipIds()
		end):flatten():value()
		local var5_9 = getProxy(BayProxy):getRawData()

		local function var6_9(arg0_11, arg1_11)
			local var0_11 = TeamType.GetTeamShipMax(arg1_11) - #underscore.filter(var1_9:GetRawShipIds(), function(arg0_12)
				return var5_9[arg0_12]:getTeamType() == arg1_11
			end)
			local var1_11 = getProxy(BayProxy):getActivityRecommendShips(arg0_11, var4_9, var0_11, arg0_1.contextData.actId)

			for iter0_11, iter1_11 in ipairs(var1_11) do
				var1_9:insertShip(iter1_11, nil, iter1_11:getTeamType())
				table.insert(var3_9, iter1_11.id)
				table.insert(var4_9, iter1_11.id)
			end
		end

		local var7_9

		if var0_9 == #arg0_1.contextData.fleets then
			var6_9(ShipType.SubShipType, TeamType.Submarine)
		else
			var6_9(ShipType.MainShipType, TeamType.Main)
			var6_9(ShipType.VanguardShipType, TeamType.Vanguard)
		end

		arg0_1.viewComponent:updateEliteFleets()
	end)
	arg0_1:bind(var0_0.ON_ELITE_CLEAR, function(arg0_13, arg1_13)
		arg0_1.contextData.fleets[arg1_13.index]:clearFleet()
		arg0_1.viewComponent:updateEliteFleets()
	end)
	arg0_1:bind(var0_0.ON_PRECOMBAT, function(arg0_14)
		local var0_14 = table.shallowCopy(arg0_1.contextData.fleets)

		arg0_1:addSubLayers(Context.New({
			mediator = BossRushPreCombatMediator,
			viewComponent = BossRushPreCombatLayer,
			data = {
				seriesData = arg0_1.contextData.seriesData,
				actId = arg0_1.contextData.actId,
				system = arg0_1.contextData.system,
				mode = arg0_1.contextData.mode,
				stageIds = arg0_1.contextData.stageIds,
				fleets = var0_14,
				fleetIndex = arg0_1.contextData.fleetIndex
			}
		}), true)
	end)
	arg0_1:bind(var0_0.OPEN_COMMANDER_PANEL, function(arg0_15, arg1_15)
		arg0_1:openCommanderPanel(arg1_15, arg0_1.contextData.fleetIndex)
	end)
	arg0_1:bind(var0_0.ON_SELECT_COMMANDER, function(arg0_16, arg1_16, arg2_16)
		local var0_16 = arg0_1.contextData.fleets
		local var1_16 = var0_16[arg1_16]
		local var2_16 = var1_16:getCommanders()

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2_16[arg2_16],
			fleetType = CommanderCatScene.FLEET_TYPE_BOSSRUSH,
			fleets = var0_16,
			ignoredIds = {},
			onCommander = function(arg0_17)
				return true
			end,
			onSelected = function(arg0_18, arg1_18)
				local var0_18 = arg0_18[1]
				local var1_18 = getProxy(CommanderProxy):getCommanderById(var0_18)

				for iter0_18, iter1_18 in pairs(var0_16) do
					if iter0_18 == arg1_16 then
						for iter2_18, iter3_18 in pairs(var2_16) do
							if iter3_18.groupId == var1_18.groupId and iter2_18 ~= arg2_16 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

								return
							end
						end
					else
						local var2_18 = iter1_18:getCommanders()

						for iter4_18, iter5_18 in pairs(var2_18) do
							if var0_18 == iter5_18.id then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

								return
							end
						end
					end
				end

				var1_16:updateCommanderByPos(arg2_16, var1_18)
				arg1_18()
			end,
			onQuit = function(arg0_19)
				var1_16:updateCommanderByPos(arg2_16, nil)
				arg0_19()
			end
		})
	end)
	arg0_1:bind(var0_0.ON_COMMANDER_SKILL, function(arg0_20, arg1_20)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_20
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_SWITCH_MODE, function(arg0_21, arg1_21)
		arg0_1:OnSwitchMode(arg1_21)
	end)

	local var0_1 = arg0_1.contextData.seriesData

	arg0_1.contextData.stageIds = var0_1:GetExpeditionIds()
	arg0_1.contextData.fullFleets = var0_1:GetFleets()

	if not arg0_1.contextData.mode then
		local var1_1 = "series_mode_flag" .. var0_1.id
		local var2_1 = PlayerPrefs.GetInt(var1_1, -1)

		if var2_1 ~= -1 then
			arg0_1.contextData.mode = var2_1
		end
	end

	arg0_1.contextData.mode = arg0_1.contextData.mode or BossRushSeriesData.MODE.MULTIPLE

	if not var0_1:IsSingleFight() then
		arg0_1.contextData.mode = BossRushSeriesData.MODE.MULTIPLE
	end

	local var3_1 = arg0_1.contextData.fullFleets

	if arg0_1.contextData.mode == BossRushSeriesData.MODE.SINGLE then
		arg0_1.contextData.fleets = {
			var3_1[1],
			var3_1[#var3_1]
		}
	else
		arg0_1.contextData.fleets = arg0_1.contextData.fleets or underscore.rest(var3_1)
	end

	arg0_1.contextData.fleetIndex = arg0_1.contextData.fleetIndex or 1

	if arg0_1.contextData.fleetIndex > #arg0_1.contextData.fleets then
		arg0_1.contextData.fleetIndex = 1
	end

	if var0_1.__cname == "CollabrateBossRushSeriesData" then
		arg0_1.contextData.system = SYSTEM_BOSS_RUSH_COLLABRATE
	else
		local var4_1 = var0_1:GetType() == BossRushSeriesData.TYPE.EXTRA

		arg0_1.contextData.system = not var4_1 and SYSTEM_BOSS_RUSH or SYSTEM_BOSS_RUSH_EX
	end

	arg0_1.contextData.actId = var0_1.actId

	arg0_1.viewComponent:setHardShipVOs(getProxy(BayProxy):getRawData())
end

function var0_0.OnSwitchMode(arg0_22, arg1_22)
	assert(arg1_22)

	local var0_22 = arg0_22.contextData.mode

	arg0_22.contextData.mode = arg1_22

	local var1_22 = arg0_22.contextData.fullFleets

	if arg0_22.contextData.mode == BossRushSeriesData.MODE.SINGLE then
		if arg1_22 ~= var0_22 then
			if arg0_22.contextData.fleetIndex < #arg0_22.contextData.fleets then
				arg0_22.contextData.fleetIndex = 1
			else
				arg0_22.contextData.fleetIndex = 2
			end
		end

		arg0_22.contextData.fleets = {
			var1_22[1],
			var1_22[#var1_22]
		}
	else
		arg0_22.contextData.fleets = underscore.rest(var1_22)

		if arg1_22 ~= var0_22 and arg0_22.contextData.fleetIndex == 2 then
			arg0_22.contextData.fleetIndex = #arg0_22.contextData.fleets
		end
	end

	local var2_22 = "series_mode_flag" .. arg0_22.contextData.seriesData.id

	PlayerPrefs.SetInt(var2_22, arg1_22)
end

function var0_0.openCommanderPanel(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.contextData.actId

	arg0_23:addSubLayers(Context.New({
		mediator = BossRushCMDFormationMediator,
		viewComponent = BossRushCMDFormationView,
		data = {
			fleet = arg1_23,
			callback = function(arg0_24)
				if arg0_24.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
					arg0_23.viewComponent:emit(var0_0.ON_COMMANDER_SKILL, arg0_24.skill)
				elseif arg0_24.type == LevelUIConst.COMMANDER_OP_ADD then
					arg0_23:closeCommanderPanel()
					arg0_23.viewComponent:emit(var0_0.ON_SELECT_COMMANDER, arg2_23, arg0_24.pos)
				else
					arg0_23:sendNotification(GAME.COMMANDER_FORMATION_OP, {
						data = {
							FleetType = LevelUIConst.FLEET_TYPE_BOSSRUSH,
							data = arg0_24,
							fleetId = arg1_23.id,
							actId = var0_23,
							fleets = arg0_23.contextData.fleets
						}
					})
				end
			end
		}
	}))
end

function var0_0.closeCommanderPanel(arg0_25)
	local var0_25 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushCMDFormationMediator)

	if var0_25 then
		arg0_25:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_25
		})
	end
end

function var0_0.listNotificationInterests(arg0_26)
	return {
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE,
		BossRushPreCombatMediator.ON_FLEET_REFRESHED
	}
end

function var0_0.handleNotification(arg0_27, arg1_27)
	local var0_27 = arg1_27:getName()
	local var1_27 = arg1_27:getBody()

	if var0_27 == nil then
		-- block empty
	elseif var0_27 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		arg0_27.viewComponent:updateEliteFleets()
	elseif var0_27 == BossRushPreCombatMediator.ON_FLEET_REFRESHED then
		arg0_27.viewComponent:updateEliteFleets()
	end
end

function var0_0.remove(arg0_28)
	return
end

function var0_0.getDockCallbackFuncs(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29)
	local var0_29 = getProxy(BayProxy)

	local function var1_29(arg0_30, arg1_30)
		local var0_30, var1_30 = ShipStatus.ShipStatusCheck("inActivity", arg0_30, arg1_30, {
			inActivity = arg4_29
		})

		if not var0_30 then
			return var0_30, var1_30
		end

		if arg0_29 and arg0_29:isSameKind(arg0_30) then
			return true
		end

		for iter0_30, iter1_30 in ipairs(arg3_29) do
			if arg0_30:isSameKind(var0_29:getShipById(iter1_30)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_29(arg0_31, arg1_31, arg2_31)
		arg1_31()
	end

	local function var3_29(arg0_32)
		if arg0_29 then
			arg1_29:removeShip(arg0_29)
		end

		if #arg0_32 > 0 then
			local var0_32 = var0_29:getShipById(arg0_32[1])

			if not arg1_29:containShip(var0_32) then
				arg1_29:insertShip(var0_32, nil, arg2_29)
			elseif arg0_29 then
				arg1_29:insertShip(arg0_29, nil, arg2_29)
			end

			arg1_29:RemoveUnusedItems()
		end

		getProxy(FleetProxy):updateActivityFleet(arg4_29, arg1_29.id, arg1_29)
	end

	return var1_29, var2_29, var3_29
end

return var0_0
