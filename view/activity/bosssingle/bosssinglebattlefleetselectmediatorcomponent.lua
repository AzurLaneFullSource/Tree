local var0_0 = class("BossSingleBattleFleetSelectMediatorComponent")

function var0_0.AttachFleetSelect(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.New(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var0_0.DetachFleetSelect(arg0_2)
	if arg0_2._IFleetSelect == nil then
		return
	end

	arg0_2._IFleetSelect:_Destory_()

	arg0_2._IFleetSelect = nil
end

function var0_0.Ctor(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3._target_ = arg1_3
	arg0_3._actType = arg2_3
	arg0_3._systemType = arg3_3
	arg0_3._subFleetOffset = arg4_3 or 10

	arg0_3:_Init_()
end

function var0_0._Init_(arg0_4)
	arg0_4._target_.class.GO_SCENE = arg0_4._target_.__cname .. ":GO_SCENE"
	arg0_4._target_.class.GO_SUBLAYER = arg0_4._target_.__cname .. ":GO_SUBLAYER"
	arg0_4._target_.class.ON_PRECOMBAT = arg0_4._target_.__cname .. ":ON_PRECOMBAT"
	arg0_4._target_.class.ON_COMMIT_FLEET = arg0_4._target_.__cname .. ":ON_COMMIT_FLEET"
	arg0_4._target_.class.ON_FLEET_RECOMMEND = arg0_4._target_.__cname .. ":ON_FLEET_RECOMMEND"
	arg0_4._target_.class.ON_FLEET_CLEAR = arg0_4._target_.__cname .. ":ON_FLEET_CLEAR"
	arg0_4._target_.class.ON_OPEN_DOCK = arg0_4._target_.__cname .. ":ON_OPEN_DOCK"
	arg0_4._target_.class.ON_FLEET_SHIPINFO = arg0_4._target_.__cname .. ":ON_FLEET_SHIPINFO"
	arg0_4._target_.class.ON_SELECT_COMMANDER = arg0_4._target_.__cname .. ":ON_SELECT_COMMANDER"
	arg0_4._target_.class.COMMANDER_FORMATION_OP = arg0_4._target_.__cname .. ":COMMANDER_FORMATION_OP"
	arg0_4._target_.class.ON_COMMANDER_SKILL = arg0_4._target_.__cname .. ":ON_COMMANDER_SKILL"
	arg0_4._target_.class.ON_PERFORM_COMBAT = arg0_4._target_.__cname .. ":ON_PERFORM_COMBAT"

	arg0_4:bindBattleEvents()

	arg0_4._target_._IFleetSelect = arg0_4
end

function var0_0._Destory_(arg0_5)
	arg0_5._target_ = nil
end

function var0_0.bindBattleEvents(arg0_6)
	arg0_6._target_.contextData.mediatorClass = arg0_6._target_.class

	local var0_6 = getProxy(FleetProxy)
	local var1_6 = getProxy(ActivityProxy):getActivityByType(arg0_6._actType)

	if not var1_6 then
		return
	end

	arg0_6._target_.contextData.bossActivity = var1_6
	arg0_6._target_.contextData.activityID = var1_6.id
	arg0_6._target_.contextData.stageIDs = var1_6:GetStageIDs()
	arg0_6._target_.contextData.useOilLimit = var1_6:GetOilLimits()

	local var2_6 = getProxy(FleetProxy):getActivityFleets()[arg0_6._target_.contextData.activityID]

	arg0_6._target_.contextData.actFleets = var2_6

	local var3_6 = getProxy(CommanderProxy):getPrefabFleet()

	arg0_6._target_.viewComponent:setCommanderPrefabs(var3_6)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle()
	arg0_6._target_:bind(arg0_6._target_.GO_SCENE, function(arg0_7, arg1_7, ...)
		arg0_6._target_:sendNotification(GAME.GO_SCENE, arg1_7, ...)
	end)
	arg0_6._target_:bind(arg0_6._target_.GO_SUBLAYER, function(arg0_8, arg1_8, arg2_8)
		arg0_6._target_:addSubLayers(arg1_8, nil, arg2_8)
	end)
	arg0_6._target_:bind(ActivityMediator.EVENT_PT_OPERATION, function(arg0_9, arg1_9)
		arg0_6._target_:sendNotification(GAME.ACT_NEW_PT, arg1_9)
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_PRECOMBAT, function(arg0_10, arg1_10)
		local var0_10 = var0_6:getActivityFleets()[arg0_6._target_.contextData.activityID]

		if not var0_10 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		var0_10[arg1_10]:RemoveUnusedItems()

		if var0_10[arg1_10]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		var0_10[arg1_10 + arg0_6._subFleetOffset]:RemoveUnusedItems()

		local var1_10 = {
			var0_10[arg1_10],
			var0_10[arg1_10 + arg0_6._subFleetOffset]
		}
		local var2_10 = arg0_6._target_.contextData.activityID

		if _.any(var1_10, function(arg0_11)
			local var0_11, var1_11 = arg0_11:HaveShipsInEvent()

			if var0_11 then
				pg.TipsMgr.GetInstance():ShowTips(var1_11)

				return true
			end

			return _.any(arg0_11:getShipIds(), function(arg0_12)
				local var0_12 = getProxy(BayProxy):RawGetShipById(arg0_12)

				if not var0_12 then
					return
				end

				local var1_12, var2_12 = ShipStatus.ShipStatusCheck("inActivity", var0_12, nil, {
					inActivity = var2_10
				})

				if not var1_12 then
					pg.TipsMgr.GetInstance():ShowTips(var2_12)

					return true
				end
			end)
		end) then
			return
		end

		local var3_10
		local var4_10
		local var5_10 = arg0_6._systemType
		local var6_10 = arg0_6._target_.contextData.stageIDs[arg1_10]
		local var7_10 = arg0_6._target_.contextData.useOilLimit[arg1_10]

		arg0_6._target_:sendNotification(GAME.GO_SCENE, SCENE.BOSS_SINGLE_PRECONBAT, {
			system = var5_10,
			stageId = var6_10,
			actId = arg0_6._target_.contextData.activityID,
			fleets = var1_10,
			costLimit = var7_10,
			buffList = arg0_6._target_.contextData.selectedBuffList,
			useTicket = arg0_6._target_.contextData.useTicket
		})
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_COMMIT_FLEET, function()
		var0_6:commitActivityFleet(arg0_6._target_.contextData.activityID)
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_FLEET_RECOMMEND, function(arg0_14, arg1_14)
		var0_6:recommendActivityFleet(arg0_6._target_.contextData.activityID, arg1_14)

		local var0_14 = var0_6:getActivityFleets()[arg0_6._target_.contextData.activityID]

		arg0_6._target_.contextData.actFleets = var0_14

		arg0_6._target_.viewComponent:updateEditPanel()
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_FLEET_CLEAR, function(arg0_15, arg1_15)
		local var0_15 = var0_6:getActivityFleets()[arg0_6._target_.contextData.activityID]
		local var1_15 = var0_15[arg1_15]

		var1_15:clearFleet()
		var0_6:updateActivityFleet(arg0_6._target_.contextData.activityID, arg1_15, var1_15)

		arg0_6._target_.contextData.actFleets = var0_15

		arg0_6._target_.viewComponent:updateEditPanel()
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_OPEN_DOCK, function(arg0_16, arg1_16)
		local var0_16 = arg1_16.fleetIndex
		local var1_16 = arg1_16.shipVO
		local var2_16 = arg1_16.fleet
		local var3_16 = arg1_16.teamType
		local var4_16 = arg0_6._target_.contextData.activityID
		local var5_16, var6_16, var7_16 = var0_0.getDockCallbackFuncs4ActicityFleet(arg0_6._actType, var1_16, var0_16, var3_16)

		arg0_6._target_:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1_16 ~= nil,
			teamFilter = var3_16,
			leftTopInfo = i18n("word_formation"),
			onShip = var5_16,
			confirmSelect = var6_16,
			onSelected = var7_16,
			hideTagFlags = setmetatable({
				inActivity = var4_16
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			otherSelectedIds = var2_16,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_FLEET_SHIPINFO, function(arg0_17, arg1_17)
		arg0_6._target_:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_17.shipId,
			shipVOs = arg1_17.shipVOs
		})
	end)
	arg0_6._target_:bind(arg0_6._target_.COMMANDER_FORMATION_OP, function(arg0_18, arg1_18)
		arg0_6._target_:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1_18
		})
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_COMMANDER_SKILL, function(arg0_19, arg1_19)
		arg0_6._target_:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_19
			}
		}))
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_SELECT_COMMANDER, function(arg0_20, arg1_20, arg2_20)
		local var0_20 = var0_6:getActivityFleets()[arg0_6._target_.contextData.activityID]
		local var1_20 = var0_20[arg1_20]
		local var2_20 = var1_20:getCommanders()

		arg0_6._target_:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2_20[arg2_20],
			fleetType = CommanderCatScene.FLEET_TYPE_BOSSSINGLE_VARIABLE,
			ignoredIds = {},
			onCommander = function(arg0_21)
				return true
			end,
			onSelected = function(arg0_22, arg1_22)
				local var0_22 = arg0_22[1]
				local var1_22 = getProxy(CommanderProxy):getCommanderById(var0_22)

				for iter0_22, iter1_22 in pairs(var0_20) do
					if iter0_22 == arg1_20 then
						for iter2_22, iter3_22 in pairs(var2_20) do
							if iter3_22.groupId == var1_22.groupId and iter2_22 ~= arg2_20 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

								return
							end
						end
					elseif iter0_22 == var0_0.GetPairedFleetIndex(arg1_20, arg0_6._subFleetOffset) then
						local var2_22 = iter1_22:getCommanders()

						for iter4_22, iter5_22 in pairs(var2_22) do
							if var0_22 == iter5_22.id then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

								return
							end
						end
					end
				end

				var1_20:updateCommanderByPos(arg2_20, var1_22)
				var0_6:updateActivityFleet(arg0_6._target_.contextData.activityID, arg1_20, var1_20)
				arg1_22()
			end,
			onQuit = function(arg0_23)
				var1_20:updateCommanderByPos(arg2_20, nil)
				var0_6:updateActivityFleet(arg0_6._target_.contextData.activityID, arg1_20, var1_20)
				arg0_23()
			end
		})
	end)
	arg0_6._target_:bind(PreCombatMediator.BEGIN_STAGE_PROXY, function(arg0_24, arg1_24)
		arg0_6._target_:sendNotification(PreCombatMediator.BEGIN_STAGE_PROXY, {
			curFleetId = arg1_24
		})
	end)
	arg0_6._target_:bind(arg0_6._target_.ON_PERFORM_COMBAT, function(arg0_25, arg1_25, arg2_25)
		arg0_6._target_:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_25,
			exitCallback = arg2_25
		})
	end)
end

function var0_0.GetPairedFleetIndex(arg0_26, arg1_26)
	if arg0_26 < Fleet.SUBMARINE_FLEET_ID then
		return arg0_26 + arg1_26
	else
		return arg0_26 - arg1_26
	end
end

function var0_0.getDockCallbackFuncs4ActicityFleet(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = getProxy(BayProxy)
	local var1_27 = getProxy(FleetProxy)
	local var2_27 = getProxy(ActivityProxy):getActivityByType(arg0_27)
	local var3_27 = var1_27:getActivityFleets()[var2_27.id][arg2_27]

	local function var4_27(arg0_28, arg1_28)
		local var0_28, var1_28 = ShipStatus.ShipStatusCheck("inActivity", arg0_28, arg1_28, {
			inActivity = var2_27.id
		})

		if not var0_28 then
			return var0_28, var1_28
		end

		if arg1_27 and arg1_27:isSameKind(arg0_28) then
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
		if arg1_27 then
			var3_27:removeShip(arg1_27)
		end

		if #arg0_30 > 0 then
			local var0_30 = var0_27:getShipById(arg0_30[1])

			if not var3_27:containShip(var0_30) then
				var3_27:insertShip(var0_30, nil, arg3_27)
			elseif arg1_27 then
				var3_27:insertShip(arg1_27, nil, arg3_27)
			end

			var3_27:RemoveUnusedItems()
		end

		var1_27:updateActivityFleet(var2_27.id, arg2_27, var3_27)
	end

	return var4_27, var5_27, var6_27
end

return var0_0
