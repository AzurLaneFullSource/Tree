local var0 = class("BossRushFleetSelectMediator", import("view.base.ContextMediator"))

var0.ON_OPEN_DECK = "BossRushFleetSelectMediator:ON_OPEN_DECK"
var0.ON_FLEET_SHIPINFO = "BossRushFleetSelectMediator:ON_FLEET_SHIPINFO"
var0.ON_TRACE = "BossRushFleetSelectMediator:ON_TRACE"
var0.ON_UPDATE_CUSTOM_FLEET = "BossRushFleetSelectMediator:ON_UPDATE_CUSTOM_FLEET"
var0.ON_PRECOMBAT = "BossRushFleetSelectMediator:ON_PRECOMBAT"
var0.ON_ELITE_RECOMMEND = "BossRushFleetSelectMediator:ON_ELITE_RECOMMEND"
var0.ON_ELITE_CLEAR = "BossRushFleetSelectMediator:ON_ELITE_CLEAR"
var0.OPEN_COMMANDER_PANEL = "BossRushFleetSelectMediator:OPEN_COMMANDER_PANEL"
var0.ON_SELECT_COMMANDER = "BossRushFleetSelectMediator:ON_SELECT_COMMANDER"
var0.ON_COMMANDER_SKILL = "BossRushFleetSelectMediator:ON_COMMANDER_SKILL"
var0.ON_SWITCH_MODE = "BossRushFleetSelectMediator:ON_SWITCH_MODE"

function var0.register(arg0)
	arg0:bind(var0.ON_OPEN_DECK, function(arg0, arg1)
		local var0 = arg1.fleetIndex
		local var1 = arg1.shipVO
		local var2 = _.flatten(_.map(arg0.contextData.fleets, function(arg0)
			return arg0:GetRawShipIds()
		end))
		local var3 = arg1.teamType
		local var4, var5, var6 = arg0.getDockCallbackFuncs(var1, arg0.contextData.fleets[var0], var3, var2, arg0.contextData.actId)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1 ~= nil,
			teamFilter = var3,
			leftTopInfo = i18n("word_formation"),
			onShip = var4,
			confirmSelect = var5,
			onSelected = var6,
			hideTagFlags = setmetatable({
				inActivity = arg0.contextData.actId
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			otherSelectedIds = var2,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0:bind(var0.ON_FLEET_SHIPINFO, function(arg0, arg1)
		local var0 = arg0.contextData.fleet

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.shipId,
			shipVOs = arg1.shipVOs
		})
	end)
	arg0:bind(var0.ON_UPDATE_CUSTOM_FLEET, function(arg0)
		_.each(arg0.contextData.fleets, function(arg0)
			getProxy(FleetProxy):updateActivityFleet(arg0.contextData.actId, arg0.id, arg0)
		end)

		local var0 = {}

		_.each(arg0.contextData.fleets, function(arg0)
			var0[arg0.id] = arg0
		end)
		arg0:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
			actID = arg0.contextData.actId,
			fleets = var0
		})
	end)
	arg0:bind(var0.ON_TRACE, function(arg0)
		arg0.viewComponent:emit(var0.ON_UPDATE_CUSTOM_FLEET)
		arg0:sendNotification(GAME.BOSSRUSH_TRACE, {
			actId = arg0.contextData.actId,
			seriesId = arg0.contextData.seriesData.id,
			mode = arg0.contextData.mode
		})
	end)
	arg0:bind(var0.ON_ELITE_RECOMMEND, function(arg0, arg1)
		local var0 = arg1.index
		local var1 = arg0.contextData.fleets[var0]
		local var2

		var2 = var0 == #arg0.contextData.fleets

		local var3 = {
			0,
			0,
			0
		}
		local var4 = {
			0,
			0,
			0
		}
		local var5 = {
			0,
			0,
			0
		}
		local var6 = table.shallowCopy(var1:GetRawShipIds())
		local var7 = _.flatten(_.map(arg0.contextData.fleets, function(arg0)
			return arg0:GetRawShipIds()
		end))
		local var8 = {
			[TeamType.Main] = var3,
			[TeamType.Vanguard] = var4,
			[TeamType.Submarine] = var5
		}
		local var9 = getProxy(BayProxy):getRawData()

		for iter0, iter1 in ipairs(var1:GetRawShipIds()) do
			local var10 = var9[iter1]:getShipType()
			local var11 = TeamType.GetTeamFromShipType(var10)
			local var12 = 0
			local var13 = var8[var11]

			for iter2, iter3 in ipairs(var13) do
				if ShipType.ContainInLimitBundle(iter3, var10) then
					var12 = iter3

					break
				end
			end

			for iter4, iter5 in ipairs(var13) do
				if iter5 == var12 then
					table.remove(var13, iter4)

					break
				end
			end
		end

		local function var14(arg0, arg1)
			local var0 = underscore.filter(TeamType.GetShipTypeListFromTeam(arg1), function(arg0)
				return ShipType.ContainInLimitBundle(arg0, arg0)
			end)
			local var1 = arg0:getRecommendShip(var0, var7)

			if var1 then
				var1:insertShip(var1, nil, var1:getTeamType())
				table.insert(var6, var1.id)
				table.insert(var7, var1.id)
			end
		end

		local var15

		if var0 == #arg0.contextData.fleets then
			var15 = {
				[TeamType.Submarine] = var5
			}
		else
			var15 = {
				[TeamType.Main] = var3,
				[TeamType.Vanguard] = var4
			}
		end

		for iter6, iter7 in pairs(var15) do
			for iter8, iter9 in ipairs(iter7) do
				var14(iter9, iter6)
			end
		end

		arg0.viewComponent:updateEliteFleets()
	end)
	arg0:bind(var0.ON_ELITE_CLEAR, function(arg0, arg1)
		arg0.contextData.fleets[arg1.index]:clearFleet()
		arg0.viewComponent:updateEliteFleets()
	end)
	arg0:bind(var0.ON_PRECOMBAT, function(arg0)
		local var0 = table.shallowCopy(arg0.contextData.fleets)

		arg0:addSubLayers(Context.New({
			mediator = BossRushPreCombatMediator,
			viewComponent = BossRushPreCombatLayer,
			data = {
				seriesData = arg0.contextData.seriesData,
				actId = arg0.contextData.actId,
				system = arg0.contextData.system,
				mode = arg0.contextData.mode,
				stageIds = arg0.contextData.stageIds,
				fleets = var0,
				fleetIndex = arg0.contextData.fleetIndex
			}
		}), true)
	end)
	arg0:bind(var0.OPEN_COMMANDER_PANEL, function(arg0, arg1)
		arg0:openCommanderPanel(arg1, arg0.contextData.fleetIndex)
	end)
	arg0:bind(var0.ON_SELECT_COMMANDER, function(arg0, arg1, arg2)
		local var0 = arg0.contextData.fleets
		local var1 = var0[arg1]
		local var2 = var1:getCommanders()

		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2[arg2],
			fleetType = CommanderCatScene.FLEET_TYPE_BOSSRUSH,
			fleets = var0,
			ignoredIds = {},
			onCommander = function(arg0)
				return true
			end,
			onSelected = function(arg0, arg1)
				local var0 = arg0[1]
				local var1 = getProxy(CommanderProxy):getCommanderById(var0)

				for iter0, iter1 in pairs(var0) do
					if iter0 == arg1 then
						for iter2, iter3 in pairs(var2) do
							if iter3.groupId == var1.groupId and iter2 ~= arg2 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

								return
							end
						end
					else
						local var2 = iter1:getCommanders()

						for iter4, iter5 in pairs(var2) do
							if var0 == iter5.id then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

								return
							end
						end
					end
				end

				var1:updateCommanderByPos(arg2, var1)
				arg1()
			end,
			onQuit = function(arg0)
				var1:updateCommanderByPos(arg2, nil)
				arg0()
			end
		})
	end)
	arg0:bind(var0.ON_COMMANDER_SKILL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_SWITCH_MODE, function(arg0, arg1)
		arg0:OnSwitchMode(arg1)
	end)

	local var0 = arg0.contextData.seriesData

	arg0.contextData.stageIds = var0:GetExpeditionIds()
	arg0.contextData.fullFleets = var0:GetFleets()

	if not arg0.contextData.mode then
		local var1 = "series_mode_flag" .. var0.id
		local var2 = PlayerPrefs.GetInt(var1, -1)

		if var2 ~= -1 then
			arg0.contextData.mode = var2
		end
	end

	arg0.contextData.mode = arg0.contextData.mode or BossRushSeriesData.MODE.MULTIPLE

	if not var0:IsSingleFight() then
		arg0.contextData.mode = BossRushSeriesData.MODE.MULTIPLE
	end

	local var3 = arg0.contextData.fullFleets

	if arg0.contextData.mode == BossRushSeriesData.MODE.SINGLE then
		arg0.contextData.fleets = {
			var3[1],
			var3[#var3]
		}
	else
		arg0.contextData.fleets = arg0.contextData.fleets or table.shallowCopy(arg0.contextData.fullFleets)
	end

	arg0.contextData.fleetIndex = arg0.contextData.fleetIndex or 1

	if arg0.contextData.fleetIndex > #arg0.contextData.fleets then
		arg0.contextData.fleetIndex = 1
	end

	local var4 = var0:GetType() == BossRushSeriesData.TYPE.EXTRA

	arg0.contextData.system = not var4 and SYSTEM_BOSS_RUSH or SYSTEM_BOSS_RUSH_EX
	arg0.contextData.actId = var0.actId

	arg0.viewComponent:setHardShipVOs(getProxy(BayProxy):getRawData())
end

function var0.OnSwitchMode(arg0, arg1)
	assert(arg1)

	local var0 = arg0.contextData.mode

	arg0.contextData.mode = arg1

	local var1 = arg0.contextData.fullFleets

	if arg0.contextData.mode == BossRushSeriesData.MODE.SINGLE then
		arg0.contextData.fleets = {
			var1[1],
			var1[#var1]
		}

		if arg1 ~= var0 then
			if arg0.contextData.fleetIndex < #var1 then
				arg0.contextData.fleetIndex = 1
			else
				arg0.contextData.fleetIndex = 2
			end
		end
	else
		arg0.contextData.fleets = table.shallowCopy(var1)

		if arg1 ~= var0 then
			if arg0.contextData.fleetIndex == 2 then
				arg0.contextData.fleetIndex = #var1
			end

			local var2 = arg0.contextData.fleets[1]:GetRawShipIds()

			_.each(_.slice(arg0.contextData.fleets, 2, #arg0.contextData.fleets - 2), function(arg0)
				_.each(var2, function(arg0)
					arg0:removeShipById(arg0)
				end)
			end)
		end
	end

	local var3 = "series_mode_flag" .. arg0.contextData.seriesData.id

	PlayerPrefs.SetInt(var3, arg1)
end

function var0.getRecommendShip(arg0, arg1, arg2)
	local var0 = arg0.contextData.actId
	local var1 = getProxy(BayProxy)
	local var2 = var1:getShipsByTypes(arg1)
	local var3 = {}

	for iter0, iter1 in ipairs(var2) do
		var3[iter1] = iter1:getShipCombatPower()
	end

	table.sort(var2, function(arg0, arg1)
		return var3[arg0] < var3[arg1]
	end)

	local var4 = {}
	local var5 = var1:getRawData()

	for iter2, iter3 in ipairs(arg2) do
		local var6 = var5[iter3]

		var4[#var4 + 1] = var6:getGroupId()
	end

	local var7 = #var2
	local var8

	while var7 > 0 do
		local var9 = var2[var7]
		local var10 = var9.id
		local var11 = var9:getGroupId()

		if not table.contains(arg2, var10) and not table.contains(var4, var11) and ShipStatus.ShipStatusCheck("inActivity", var9, nil, {
			inActivity = var0
		}) then
			var8 = var9

			break
		else
			var7 = var7 - 1
		end
	end

	return var8
end

function var0.openCommanderPanel(arg0, arg1, arg2)
	local var0 = arg0.contextData.actId

	arg0:addSubLayers(Context.New({
		mediator = BossRushCMDFormationMediator,
		viewComponent = BossRushCMDFormationView,
		data = {
			fleet = arg1,
			callback = function(arg0)
				if arg0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
					arg0.viewComponent:emit(var0.ON_COMMANDER_SKILL, arg0.skill)
				elseif arg0.type == LevelUIConst.COMMANDER_OP_ADD then
					arg0:closeCommanderPanel()
					arg0.viewComponent:emit(var0.ON_SELECT_COMMANDER, arg2, arg0.pos)
				else
					arg0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
						data = {
							FleetType = LevelUIConst.FLEET_TYPE_BOSSRUSH,
							data = arg0,
							fleetId = arg1.id,
							actId = var0,
							fleets = arg0.contextData.fleets
						}
					})
				end
			end
		}
	}))
end

function var0.closeCommanderPanel(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossRushCMDFormationMediator)

	if var0 then
		arg0:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0
		})
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE,
		BossRushPreCombatMediator.ON_FLEET_REFRESHED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	elseif var0 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		arg0.viewComponent:updateEliteFleets()
	elseif var0 == BossRushPreCombatMediator.ON_FLEET_REFRESHED then
		arg0.viewComponent:updateEliteFleets()
	end
end

function var0.remove(arg0)
	return
end

function var0.getDockCallbackFuncs(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(BayProxy)

	local function var1(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inActivity", arg0, arg1, {
			inActivity = arg4
		})

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
		if arg0 then
			arg1:removeShip(arg0)
		end

		if #arg0 > 0 then
			local var0 = var0:getShipById(arg0[1])

			if not arg1:containShip(var0) then
				arg1:insertShip(var0, nil, arg2)
			elseif arg0 then
				arg1:insertShip(arg0, nil, arg2)
			end

			arg1:RemoveUnusedItems()
		end

		getProxy(FleetProxy):updateActivityFleet(arg4, arg1.id, arg1)
	end

	return var1, var2, var3
end

return var0
