local var0 = class("BossSingleMediatorTemplate", import("view.base.ContextMediator"))

var0.GO_SCENE = "BossSingleMediatorTemplate.GO_SCENE"
var0.GO_SUBLAYER = "BossSingleMediatorTemplate.GO_SUBLAYER"
var0.ON_PRECOMBAT = "BossSingleMediatorTemplate:ON_PRECOMBAT"
var0.ON_COMMIT_FLEET = "BossSingleMediatorTemplate:ON_COMMIT_FLEET"
var0.ON_FLEET_RECOMMEND = "BossSingleMediatorTemplate:ON_FLEET_RECOMMEND"
var0.ON_FLEET_CLEAR = "BossSingleMediatorTemplate:ON_FLEET_CLEAR"
var0.ON_OPEN_DOCK = "BossSingleMediatorTemplate:ON_OPEN_DOCK"
var0.ON_FLEET_SHIPINFO = "BossSingleMediatorTemplate:ON_FLEET_SHIPINFO"
var0.ON_SELECT_COMMANDER = "BossSingleMediatorTemplate:ON_SELECT_COMMANDER"
var0.COMMANDER_FORMATION_OP = "BossSingleMediatorTemplate:COMMANDER_FORMATION_OP"
var0.ON_COMMANDER_SKILL = "BossSingleMediatorTemplate:ON_COMMANDER_SKILL"
var0.ON_PERFORM_COMBAT = "BossSingleMediatorTemplate:ON_PERFORM_COMBAT"

function var0.GetPairedFleetIndex(arg0)
	if arg0 < Fleet.SUBMARINE_FLEET_ID then
		return arg0 + 10
	else
		return arg0 - 10
	end
end

function var0.BindBattleEvents(arg0)
	arg0.contextData.mediatorClass = arg0.class

	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

	if not var1 then
		return
	end

	arg0.contextData.bossActivity = var1
	arg0.contextData.activityID = var1.id
	arg0.contextData.stageIDs = var1:GetStageIDs()
	arg0.contextData.useOilLimit = var1:GetOilLimits()

	local var2 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.activityID]

	arg0.contextData.actFleets = var2

	local var3 = getProxy(CommanderProxy):getPrefabFleet()

	arg0.viewComponent:setCommanderPrefabs(var3)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle()
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
	arg0:bind(var0.GO_SUBLAYER, function(arg0, arg1, arg2)
		arg0:addSubLayers(arg1, nil, arg2)
	end)
	arg0:bind(ActivityMediator.EVENT_PT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_NEW_PT, arg1)
	end)
	arg0:bind(var0.ON_PRECOMBAT, function(arg0, arg1)
		local var0 = var0:getActivityFleets()[arg0.contextData.activityID]

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		var0[arg1]:RemoveUnusedItems()

		if var0[arg1]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		var0[arg1 + 10]:RemoveUnusedItems()

		local var1 = {
			var0[arg1],
			var0[arg1 + 10]
		}
		local var2 = arg0.contextData.activityID

		if _.any(var1, function(arg0)
			local var0, var1 = arg0:HaveShipsInEvent()

			if var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)

				return true
			end

			return _.any(arg0:getShipIds(), function(arg0)
				local var0 = getProxy(BayProxy):RawGetShipById(arg0)

				if not var0 then
					return
				end

				local var1, var2 = ShipStatus.ShipStatusCheck("inActivity", var0, nil, {
					inActivity = var2
				})

				if not var1 then
					pg.TipsMgr.GetInstance():ShowTips(var2)

					return true
				end
			end)
		end) then
			return
		end

		local var3
		local var4
		local var5 = SYSTEM_BOSS_SINGLE
		local var6 = arg0.contextData.stageIDs[arg1]
		local var7 = arg0.contextData.useOilLimit[arg1]

		arg0:addSubLayers(Context.New({
			mediator = BossSinglePreCombatMediator,
			viewComponent = BossSinglePreCombatLayer,
			data = {
				system = var5,
				stageId = var6,
				actId = arg0.contextData.activityID,
				fleets = var1,
				costLimit = var7
			},
			onRemoved = function()
				arg0.viewComponent:updateEditPanel()
			end
		}))
	end)
	arg0:bind(var0.ON_COMMIT_FLEET, function()
		var0:commitActivityFleet(arg0.contextData.activityID)
	end)
	arg0:bind(var0.ON_FLEET_RECOMMEND, function(arg0, arg1)
		var0:recommendActivityFleet(arg0.contextData.activityID, arg1)

		local var0 = var0:getActivityFleets()[arg0.contextData.activityID]

		arg0.contextData.actFleets = var0

		arg0.viewComponent:updateEditPanel()
	end)
	arg0:bind(var0.ON_FLEET_CLEAR, function(arg0, arg1)
		local var0 = var0:getActivityFleets()[arg0.contextData.activityID]
		local var1 = var0[arg1]

		var1:clearFleet()
		var0:updateActivityFleet(arg0.contextData.activityID, arg1, var1)

		arg0.contextData.actFleets = var0

		arg0.viewComponent:updateEditPanel()
	end)
	arg0:bind(var0.ON_OPEN_DOCK, function(arg0, arg1)
		local var0 = arg1.fleetIndex
		local var1 = arg1.shipVO
		local var2 = arg1.fleet
		local var3 = arg1.teamType
		local var4 = arg0.contextData.activityID or 5620
		local var5, var6, var7 = arg0.getDockCallbackFuncs4ActicityFleet(var1, var0, var3)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1 ~= nil,
			teamFilter = var3,
			leftTopInfo = i18n("word_formation"),
			onShip = var5,
			confirmSelect = var6,
			onSelected = var7,
			hideTagFlags = setmetatable({
				inActivity = var4
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
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.shipId,
			shipVOs = arg1.shipVOs
		})
	end)
	arg0:bind(var0.COMMANDER_FORMATION_OP, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1
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
	arg0:bind(var0.ON_SELECT_COMMANDER, function(arg0, arg1, arg2)
		local var0 = var0:getActivityFleets()[arg0.contextData.activityID]
		local var1 = var0[arg1]
		local var2 = var1:getCommanders()

		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2[arg2],
			fleetType = CommanderCatScene.FLEET_TYPE_BOSSSINGLE,
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
					elseif iter0 == var0.GetPairedFleetIndex(arg1) then
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
				var0:updateActivityFleet(arg0.contextData.activityID, arg1, var1)
				arg1()
			end,
			onQuit = function(arg0)
				var1:updateCommanderByPos(arg2, nil)
				var0:updateActivityFleet(arg0.contextData.activityID, arg1, var1)
				arg0()
			end
		})
	end)
	arg0:bind(PreCombatMediator.BEGIN_STAGE_PROXY, function(arg0, arg1)
		arg0:sendNotification(PreCombatMediator.BEGIN_STAGE_PROXY, {
			curFleetId = arg1
		})
	end)
	arg0:bind(var0.ON_PERFORM_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1,
			exitCallback = arg2
		})
	end)
end

function var0.GetBattleHanldDic(arg0)
	return {
		[GAME.BEGIN_STAGE_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.contextData.editFleet = nil

			if not getProxy(ContextProxy):getContextByMediator(PreCombatMediator) then
				arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0)
			end
		end,
		[GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = getProxy(FleetProxy):getActivityFleets()[var0.actId]

			arg0.contextData.actFleets = var1

			arg0.viewComponent:updateEditPanel()
			arg0.viewComponent:updateCommanderFleet(var1[var0.fleetId])
		end,
		[CommanderProxy.PREFAB_FLEET_UPDATE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = getProxy(CommanderProxy):getPrefabFleet()

			arg0.viewComponent:setCommanderPrefabs(var1)
			arg0.viewComponent:updateCommanderPrefab()
		end
	}
end

function var0.getDockCallbackFuncs4ActicityFleet(arg0, arg1, arg2)
	local var0 = getProxy(BayProxy)
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)
	local var3 = var1:getActivityFleets()[var2.id][arg1]

	local function var4(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inActivity", arg0, arg1, {
			inActivity = var2.id
		})

		if not var0 then
			return var0, var1
		end

		if arg0 and arg0:isSameKind(arg0) then
			return true
		end

		for iter0, iter1 in ipairs(var3.ships or {}) do
			if arg0:isSameKind(var0:getShipById(iter1)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var5(arg0, arg1, arg2)
		arg1()
	end

	local function var6(arg0)
		if arg0 then
			var3:removeShip(arg0)
		end

		if #arg0 > 0 then
			local var0 = var0:getShipById(arg0[1])

			if not var3:containShip(var0) then
				var3:insertShip(var0, nil, arg2)
			elseif arg0 then
				var3:insertShip(arg0, nil, arg2)
			end

			var3:RemoveUnusedItems()
		end

		var1:updateActivityFleet(var2.id, arg1, var3)
	end

	return var4, var5, var6
end

return var0
