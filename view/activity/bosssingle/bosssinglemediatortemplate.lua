local var0_0 = class("BossSingleMediatorTemplate", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "BossSingleMediatorTemplate.GO_SCENE"
var0_0.GO_SUBLAYER = "BossSingleMediatorTemplate.GO_SUBLAYER"
var0_0.ON_PRECOMBAT = "BossSingleMediatorTemplate:ON_PRECOMBAT"
var0_0.ON_COMMIT_FLEET = "BossSingleMediatorTemplate:ON_COMMIT_FLEET"
var0_0.ON_FLEET_RECOMMEND = "BossSingleMediatorTemplate:ON_FLEET_RECOMMEND"
var0_0.ON_FLEET_CLEAR = "BossSingleMediatorTemplate:ON_FLEET_CLEAR"
var0_0.ON_OPEN_DOCK = "BossSingleMediatorTemplate:ON_OPEN_DOCK"
var0_0.ON_FLEET_SHIPINFO = "BossSingleMediatorTemplate:ON_FLEET_SHIPINFO"
var0_0.ON_SELECT_COMMANDER = "BossSingleMediatorTemplate:ON_SELECT_COMMANDER"
var0_0.COMMANDER_FORMATION_OP = "BossSingleMediatorTemplate:COMMANDER_FORMATION_OP"
var0_0.ON_COMMANDER_SKILL = "BossSingleMediatorTemplate:ON_COMMANDER_SKILL"
var0_0.ON_PERFORM_COMBAT = "BossSingleMediatorTemplate:ON_PERFORM_COMBAT"

function var0_0.GetPairedFleetIndex(arg0_1)
	if arg0_1 < Fleet.SUBMARINE_FLEET_ID then
		return arg0_1 + 10
	else
		return arg0_1 - 10
	end
end

function var0_0.BindBattleEvents(arg0_2)
	arg0_2.contextData.mediatorClass = arg0_2.class

	local var0_2 = getProxy(FleetProxy)
	local var1_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

	if not var1_2 then
		return
	end

	arg0_2.contextData.bossActivity = var1_2
	arg0_2.contextData.activityID = var1_2.id
	arg0_2.contextData.stageIDs = var1_2:GetStageIDs()
	arg0_2.contextData.useOilLimit = var1_2:GetOilLimits()

	local var2_2 = getProxy(FleetProxy):getActivityFleets()[arg0_2.contextData.activityID]

	arg0_2.contextData.actFleets = var2_2

	local var3_2 = getProxy(CommanderProxy):getPrefabFleet()

	arg0_2.viewComponent:setCommanderPrefabs(var3_2)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle()
	arg0_2:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_2:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_2:bind(var0_0.GO_SUBLAYER, function(arg0_4, arg1_4, arg2_4)
		arg0_2:addSubLayers(arg1_4, nil, arg2_4)
	end)
	arg0_2:bind(ActivityMediator.EVENT_PT_OPERATION, function(arg0_5, arg1_5)
		arg0_2:sendNotification(GAME.ACT_NEW_PT, arg1_5)
	end)
	arg0_2:bind(var0_0.ON_PRECOMBAT, function(arg0_6, arg1_6)
		local var0_6 = var0_2:getActivityFleets()[arg0_2.contextData.activityID]

		if not var0_6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		var0_6[arg1_6]:RemoveUnusedItems()

		if var0_6[arg1_6]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		var0_6[arg1_6 + 10]:RemoveUnusedItems()

		local var1_6 = {
			var0_6[arg1_6],
			var0_6[arg1_6 + 10]
		}
		local var2_6 = arg0_2.contextData.activityID

		if _.any(var1_6, function(arg0_7)
			local var0_7, var1_7 = arg0_7:HaveShipsInEvent()

			if var0_7 then
				pg.TipsMgr.GetInstance():ShowTips(var1_7)

				return true
			end

			return _.any(arg0_7:getShipIds(), function(arg0_8)
				local var0_8 = getProxy(BayProxy):RawGetShipById(arg0_8)

				if not var0_8 then
					return
				end

				local var1_8, var2_8 = ShipStatus.ShipStatusCheck("inActivity", var0_8, nil, {
					inActivity = var2_6
				})

				if not var1_8 then
					pg.TipsMgr.GetInstance():ShowTips(var2_8)

					return true
				end
			end)
		end) then
			return
		end

		local var3_6
		local var4_6
		local var5_6 = SYSTEM_BOSS_SINGLE
		local var6_6 = arg0_2.contextData.stageIDs[arg1_6]
		local var7_6 = arg0_2.contextData.useOilLimit[arg1_6]

		arg0_2:addSubLayers(Context.New({
			mediator = BossSinglePreCombatMediator,
			viewComponent = BossSinglePreCombatLayer,
			data = {
				system = var5_6,
				stageId = var6_6,
				actId = arg0_2.contextData.activityID,
				fleets = var1_6,
				costLimit = var7_6
			},
			onRemoved = function()
				arg0_2.viewComponent:updateEditPanel()
			end
		}))
	end)
	arg0_2:bind(var0_0.ON_COMMIT_FLEET, function()
		var0_2:commitActivityFleet(arg0_2.contextData.activityID)
	end)
	arg0_2:bind(var0_0.ON_FLEET_RECOMMEND, function(arg0_11, arg1_11)
		var0_2:recommendActivityFleet(arg0_2.contextData.activityID, arg1_11)

		local var0_11 = var0_2:getActivityFleets()[arg0_2.contextData.activityID]

		arg0_2.contextData.actFleets = var0_11

		arg0_2.viewComponent:updateEditPanel()
	end)
	arg0_2:bind(var0_0.ON_FLEET_CLEAR, function(arg0_12, arg1_12)
		local var0_12 = var0_2:getActivityFleets()[arg0_2.contextData.activityID]
		local var1_12 = var0_12[arg1_12]

		var1_12:clearFleet()
		var0_2:updateActivityFleet(arg0_2.contextData.activityID, arg1_12, var1_12)

		arg0_2.contextData.actFleets = var0_12

		arg0_2.viewComponent:updateEditPanel()
	end)
	arg0_2:bind(var0_0.ON_OPEN_DOCK, function(arg0_13, arg1_13)
		local var0_13 = arg1_13.fleetIndex
		local var1_13 = arg1_13.shipVO
		local var2_13 = arg1_13.fleet
		local var3_13 = arg1_13.teamType
		local var4_13 = arg0_2.contextData.activityID or 5620
		local var5_13, var6_13, var7_13 = arg0_2.getDockCallbackFuncs4ActicityFleet(var1_13, var0_13, var3_13)

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1_13 ~= nil,
			teamFilter = var3_13,
			leftTopInfo = i18n("word_formation"),
			onShip = var5_13,
			confirmSelect = var6_13,
			onSelected = var7_13,
			hideTagFlags = setmetatable({
				inActivity = var4_13
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			otherSelectedIds = var2_13,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0_2:bind(var0_0.ON_FLEET_SHIPINFO, function(arg0_14, arg1_14)
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_14.shipId,
			shipVOs = arg1_14.shipVOs
		})
	end)
	arg0_2:bind(var0_0.COMMANDER_FORMATION_OP, function(arg0_15, arg1_15)
		arg0_2:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1_15
		})
	end)
	arg0_2:bind(var0_0.ON_COMMANDER_SKILL, function(arg0_16, arg1_16)
		arg0_2:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_16
			}
		}))
	end)
	arg0_2:bind(var0_0.ON_SELECT_COMMANDER, function(arg0_17, arg1_17, arg2_17)
		local var0_17 = var0_2:getActivityFleets()[arg0_2.contextData.activityID]
		local var1_17 = var0_17[arg1_17]
		local var2_17 = var1_17:getCommanders()

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2_17[arg2_17],
			fleetType = CommanderCatScene.FLEET_TYPE_BOSSSINGLE,
			ignoredIds = {},
			onCommander = function(arg0_18)
				return true
			end,
			onSelected = function(arg0_19, arg1_19)
				local var0_19 = arg0_19[1]
				local var1_19 = getProxy(CommanderProxy):getCommanderById(var0_19)

				for iter0_19, iter1_19 in pairs(var0_17) do
					if iter0_19 == arg1_17 then
						for iter2_19, iter3_19 in pairs(var2_17) do
							if iter3_19.groupId == var1_19.groupId and iter2_19 ~= arg2_17 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

								return
							end
						end
					elseif iter0_19 == var0_0.GetPairedFleetIndex(arg1_17) then
						local var2_19 = iter1_19:getCommanders()

						for iter4_19, iter5_19 in pairs(var2_19) do
							if var0_19 == iter5_19.id then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

								return
							end
						end
					end
				end

				var1_17:updateCommanderByPos(arg2_17, var1_19)
				var0_2:updateActivityFleet(arg0_2.contextData.activityID, arg1_17, var1_17)
				arg1_19()
			end,
			onQuit = function(arg0_20)
				var1_17:updateCommanderByPos(arg2_17, nil)
				var0_2:updateActivityFleet(arg0_2.contextData.activityID, arg1_17, var1_17)
				arg0_20()
			end
		})
	end)
	arg0_2:bind(PreCombatMediator.BEGIN_STAGE_PROXY, function(arg0_21, arg1_21)
		arg0_2:sendNotification(PreCombatMediator.BEGIN_STAGE_PROXY, {
			curFleetId = arg1_21
		})
	end)
	arg0_2:bind(var0_0.ON_PERFORM_COMBAT, function(arg0_22, arg1_22, arg2_22)
		arg0_2:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_22,
			exitCallback = arg2_22
		})
	end)
end

function var0_0.GetBattleHanldDic(arg0_23)
	return {
		[GAME.BEGIN_STAGE_DONE] = function(arg0_24, arg1_24)
			local var0_24 = arg1_24:getBody()

			arg0_24.contextData.editFleet = nil

			if not getProxy(ContextProxy):getContextByMediator(PreCombatMediator) then
				arg0_24:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0_24)
			end
		end,
		[GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE] = function(arg0_25, arg1_25)
			local var0_25 = arg1_25:getBody()
			local var1_25 = getProxy(FleetProxy):getActivityFleets()[var0_25.actId]

			arg0_25.contextData.actFleets = var1_25

			arg0_25.viewComponent:updateEditPanel()
			arg0_25.viewComponent:updateCommanderFleet(var1_25[var0_25.fleetId])
		end,
		[CommanderProxy.PREFAB_FLEET_UPDATE] = function(arg0_26, arg1_26)
			local var0_26 = arg1_26:getBody()
			local var1_26 = getProxy(CommanderProxy):getPrefabFleet()

			arg0_26.viewComponent:setCommanderPrefabs(var1_26)
			arg0_26.viewComponent:updateCommanderPrefab()
		end
	}
end

function var0_0.getDockCallbackFuncs4ActicityFleet(arg0_27, arg1_27, arg2_27)
	local var0_27 = getProxy(BayProxy)
	local var1_27 = getProxy(FleetProxy)
	local var2_27 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)
	local var3_27 = var1_27:getActivityFleets()[var2_27.id][arg1_27]

	local function var4_27(arg0_28, arg1_28)
		local var0_28, var1_28 = ShipStatus.ShipStatusCheck("inActivity", arg0_28, arg1_28, {
			inActivity = var2_27.id
		})

		if not var0_28 then
			return var0_28, var1_28
		end

		if arg0_27 and arg0_27:isSameKind(arg0_28) then
			return true
		end

		for iter0_28, iter1_28 in ipairs(var3_27.ships or {}) do
			if arg0_28:isSameKind(var0_27:getShipById(iter1_28)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var5_27(arg0_29, arg1_29, arg2_29)
		arg1_29()
	end

	local function var6_27(arg0_30)
		if arg0_27 then
			var3_27:removeShip(arg0_27)
		end

		if #arg0_30 > 0 then
			local var0_30 = var0_27:getShipById(arg0_30[1])

			if not var3_27:containShip(var0_30) then
				var3_27:insertShip(var0_30, nil, arg2_27)
			elseif arg0_27 then
				var3_27:insertShip(arg0_27, nil, arg2_27)
			end

			var3_27:RemoveUnusedItems()
		end

		var1_27:updateActivityFleet(var2_27.id, arg1_27, var3_27)
	end

	return var4_27, var5_27, var6_27
end

return var0_0
