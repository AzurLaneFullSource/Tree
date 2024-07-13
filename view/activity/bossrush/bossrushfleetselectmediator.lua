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
			otherSelectedIds = var2_2,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
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
		_.each(arg0_1.contextData.fleets, function(arg0_6)
			getProxy(FleetProxy):updateActivityFleet(arg0_1.contextData.actId, arg0_6.id, arg0_6)
		end)

		local var0_5 = {}

		_.each(arg0_1.contextData.fleets, function(arg0_7)
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

		local var3_9 = {
			0,
			0,
			0
		}
		local var4_9 = {
			0,
			0,
			0
		}
		local var5_9 = {
			0,
			0,
			0
		}
		local var6_9 = table.shallowCopy(var1_9:GetRawShipIds())
		local var7_9 = _.flatten(_.map(arg0_1.contextData.fleets, function(arg0_10)
			return arg0_10:GetRawShipIds()
		end))
		local var8_9 = {
			[TeamType.Main] = var3_9,
			[TeamType.Vanguard] = var4_9,
			[TeamType.Submarine] = var5_9
		}
		local var9_9 = getProxy(BayProxy):getRawData()

		for iter0_9, iter1_9 in ipairs(var1_9:GetRawShipIds()) do
			local var10_9 = var9_9[iter1_9]:getShipType()
			local var11_9 = TeamType.GetTeamFromShipType(var10_9)
			local var12_9 = 0
			local var13_9 = var8_9[var11_9]

			for iter2_9, iter3_9 in ipairs(var13_9) do
				if ShipType.ContainInLimitBundle(iter3_9, var10_9) then
					var12_9 = iter3_9

					break
				end
			end

			for iter4_9, iter5_9 in ipairs(var13_9) do
				if iter5_9 == var12_9 then
					table.remove(var13_9, iter4_9)

					break
				end
			end
		end

		local function var14_9(arg0_11, arg1_11)
			local var0_11 = underscore.filter(TeamType.GetShipTypeListFromTeam(arg1_11), function(arg0_12)
				return ShipType.ContainInLimitBundle(arg0_11, arg0_12)
			end)
			local var1_11 = arg0_1:getRecommendShip(var0_11, var7_9)

			if var1_11 then
				var1_9:insertShip(var1_11, nil, var1_11:getTeamType())
				table.insert(var6_9, var1_11.id)
				table.insert(var7_9, var1_11.id)
			end
		end

		local var15_9

		if var0_9 == #arg0_1.contextData.fleets then
			var15_9 = {
				[TeamType.Submarine] = var5_9
			}
		else
			var15_9 = {
				[TeamType.Main] = var3_9,
				[TeamType.Vanguard] = var4_9
			}
		end

		for iter6_9, iter7_9 in pairs(var15_9) do
			for iter8_9, iter9_9 in ipairs(iter7_9) do
				var14_9(iter9_9, iter6_9)
			end
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
		arg0_1.contextData.fleets = arg0_1.contextData.fleets or table.shallowCopy(arg0_1.contextData.fullFleets)
	end

	arg0_1.contextData.fleetIndex = arg0_1.contextData.fleetIndex or 1

	if arg0_1.contextData.fleetIndex > #arg0_1.contextData.fleets then
		arg0_1.contextData.fleetIndex = 1
	end

	local var4_1 = var0_1:GetType() == BossRushSeriesData.TYPE.EXTRA

	arg0_1.contextData.system = not var4_1 and SYSTEM_BOSS_RUSH or SYSTEM_BOSS_RUSH_EX
	arg0_1.contextData.actId = var0_1.actId

	arg0_1.viewComponent:setHardShipVOs(getProxy(BayProxy):getRawData())
end

function var0_0.OnSwitchMode(arg0_22, arg1_22)
	assert(arg1_22)

	local var0_22 = arg0_22.contextData.mode

	arg0_22.contextData.mode = arg1_22

	local var1_22 = arg0_22.contextData.fullFleets

	if arg0_22.contextData.mode == BossRushSeriesData.MODE.SINGLE then
		arg0_22.contextData.fleets = {
			var1_22[1],
			var1_22[#var1_22]
		}

		if arg1_22 ~= var0_22 then
			if arg0_22.contextData.fleetIndex < #var1_22 then
				arg0_22.contextData.fleetIndex = 1
			else
				arg0_22.contextData.fleetIndex = 2
			end
		end
	else
		arg0_22.contextData.fleets = table.shallowCopy(var1_22)

		if arg1_22 ~= var0_22 then
			if arg0_22.contextData.fleetIndex == 2 then
				arg0_22.contextData.fleetIndex = #var1_22
			end

			local var2_22 = arg0_22.contextData.fleets[1]:GetRawShipIds()

			_.each(_.slice(arg0_22.contextData.fleets, 2, #arg0_22.contextData.fleets - 2), function(arg0_23)
				_.each(var2_22, function(arg0_24)
					arg0_23:removeShipById(arg0_24)
				end)
			end)
		end
	end

	local var3_22 = "series_mode_flag" .. arg0_22.contextData.seriesData.id

	PlayerPrefs.SetInt(var3_22, arg1_22)
end

function var0_0.getRecommendShip(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.contextData.actId
	local var1_25 = getProxy(BayProxy)
	local var2_25 = var1_25:getShipsByTypes(arg1_25)
	local var3_25 = {}

	for iter0_25, iter1_25 in ipairs(var2_25) do
		var3_25[iter1_25] = iter1_25:getShipCombatPower()
	end

	table.sort(var2_25, function(arg0_26, arg1_26)
		return var3_25[arg0_26] < var3_25[arg1_26]
	end)

	local var4_25 = {}
	local var5_25 = var1_25:getRawData()

	for iter2_25, iter3_25 in ipairs(arg2_25) do
		local var6_25 = var5_25[iter3_25]

		var4_25[#var4_25 + 1] = var6_25:getGroupId()
	end

	local var7_25 = #var2_25
	local var8_25

	while var7_25 > 0 do
		local var9_25 = var2_25[var7_25]
		local var10_25 = var9_25.id
		local var11_25 = var9_25:getGroupId()

		if not table.contains(arg2_25, var10_25) and not table.contains(var4_25, var11_25) and ShipStatus.ShipStatusCheck("inActivity", var9_25, nil, {
			inActivity = var0_25
		}) then
			var8_25 = var9_25

			break
		else
			var7_25 = var7_25 - 1
		end
	end

	return var8_25
end

function var0_0.openCommanderPanel(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.contextData.actId

	arg0_27:addSubLayers(Context.New({
		mediator = BossRushCMDFormationMediator,
		viewComponent = BossRushCMDFormationView,
		data = {
			fleet = arg1_27,
			callback = function(arg0_28)
				if arg0_28.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
					arg0_27.viewComponent:emit(var0_0.ON_COMMANDER_SKILL, arg0_28.skill)
				elseif arg0_28.type == LevelUIConst.COMMANDER_OP_ADD then
					arg0_27:closeCommanderPanel()
					arg0_27.viewComponent:emit(var0_0.ON_SELECT_COMMANDER, arg2_27, arg0_28.pos)
				else
					arg0_27:sendNotification(GAME.COMMANDER_FORMATION_OP, {
						data = {
							FleetType = LevelUIConst.FLEET_TYPE_BOSSRUSH,
							data = arg0_28,
							fleetId = arg1_27.id,
							actId = var0_27,
							fleets = arg0_27.contextData.fleets
						}
					})
				end
			end
		}
	}))
end

function var0_0.closeCommanderPanel(arg0_29)
	local var0_29 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushCMDFormationMediator)

	if var0_29 then
		arg0_29:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_29
		})
	end
end

function var0_0.listNotificationInterests(arg0_30)
	return {
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE,
		BossRushPreCombatMediator.ON_FLEET_REFRESHED
	}
end

function var0_0.handleNotification(arg0_31, arg1_31)
	local var0_31 = arg1_31:getName()
	local var1_31 = arg1_31:getBody()

	if var0_31 == nil then
		-- block empty
	elseif var0_31 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		arg0_31.viewComponent:updateEliteFleets()
	elseif var0_31 == BossRushPreCombatMediator.ON_FLEET_REFRESHED then
		arg0_31.viewComponent:updateEliteFleets()
	end
end

function var0_0.remove(arg0_32)
	return
end

function var0_0.getDockCallbackFuncs(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	local var0_33 = getProxy(BayProxy)

	local function var1_33(arg0_34, arg1_34)
		local var0_34, var1_34 = ShipStatus.ShipStatusCheck("inActivity", arg0_34, arg1_34, {
			inActivity = arg4_33
		})

		if not var0_34 then
			return var0_34, var1_34
		end

		if arg0_33 and arg0_33:isSameKind(arg0_34) then
			return true
		end

		for iter0_34, iter1_34 in ipairs(arg3_33) do
			if arg0_34:isSameKind(var0_33:getShipById(iter1_34)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_33(arg0_35, arg1_35, arg2_35)
		arg1_35()
	end

	local function var3_33(arg0_36)
		if arg0_33 then
			arg1_33:removeShip(arg0_33)
		end

		if #arg0_36 > 0 then
			local var0_36 = var0_33:getShipById(arg0_36[1])

			if not arg1_33:containShip(var0_36) then
				arg1_33:insertShip(var0_36, nil, arg2_33)
			elseif arg0_33 then
				arg1_33:insertShip(arg0_33, nil, arg2_33)
			end

			arg1_33:RemoveUnusedItems()
		end

		getProxy(FleetProxy):updateActivityFleet(arg4_33, arg1_33.id, arg1_33)
	end

	return var1_33, var2_33, var3_33
end

return var0_0
