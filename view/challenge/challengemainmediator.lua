local var0_0 = class("ChallengeMainMediator", import("..base.ContextMediator"))

var0_0.ON_COMMIT_FLEET = "ChallengeMainMediator:ON_COMMIT_FLEET"
var0_0.ON_FLEET_SHIPINFO = "ChallengeMainMediator:ON_FLEET_SHIPINFO"
var0_0.ON_PRECOMBAT = "ChallengeMainMediator:ON_PRECOMBAT"
var0_0.ON_SELECT_ELITE_COMMANDER = "ChallengeMainMediator:ON_SELECT_ELITE_COMMANDER"
var0_0.ON_OPEN_RANK = "ChallengeMainMediator:ON_OPEN_RANK"
var0_0.COMMANDER_FORMATION_OP = "ChallengeMainMediator:COMMANDER_FORMATION_OP"
var0_0.ON_COMMANDER_SKILL = "ChallengeMainMediator:ON_COMMANDER_SKILL"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(FleetProxy)
	local var1_1 = getProxy(ActivityProxy)
	local var2_1 = getProxy(ChallengeProxy)
	local var3_1 = var1_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	arg0_1:bind(var0_0.ON_OPEN_RANK, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_CHALLENGE
		})
	end)
	arg0_1:bind(ChallengeConst.CLICK_GET_AWARD_BTN, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3)
	end)
	arg0_1:bind(ChallengeConst.RESET_DATA_EVENT, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.CHALLENGE2_RESET, {
			mode = arg1_4,
			isInfiniteSeasonClear = arg2_4
		})
	end)
	arg0_1:bind(ActivityFleetPanel.ON_OPEN_DOCK, function(arg0_5, arg1_5)
		local var0_5 = arg1_5.shipType
		local var1_5 = arg1_5.fleetIndex
		local var2_5 = arg1_5.shipVO
		local var3_5 = arg1_5.fleet
		local var4_5 = arg1_5.teamType
		local var5_5 = getProxy(BayProxy):getRawData()

		arg0_1.contextData.editFleet = true

		local var6_5, var7_5, var8_5 = arg0_1:getDockCallbackFuncs(var3_5, var2_5, var1_5, var4_5)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var2_5 ~= nil,
			teamFilter = var4_5,
			leftTopInfo = i18n("word_formation"),
			onShip = var6_5,
			confirmSelect = var7_5,
			onSelected = var8_5,
			hideTagFlags = setmetatable({
				inActivity = var3_1.id
			}, {
				__index = ShipStatus.TAG_HIDE_CHALLENGE
			}),
			otherSelectedIds = var3_5,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0_1:bind(var0_0.ON_COMMIT_FLEET, function()
		var0_1:commitActivityFleet(var3_1.id)
	end)
	arg0_1:bind(var0_0.ON_FLEET_SHIPINFO, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_7.shipId,
			shipVOs = arg1_7.shipVOs
		})

		arg0_1.contextData.editFleet = true
	end)
	arg0_1:bind(ActivityFleetPanel.ON_FLEET_RECOMMEND, function(arg0_8, arg1_8)
		var0_1:recommendActivityFleet(var3_1.id, arg1_8)

		local var0_8 = var0_1:getActivityFleets()[var3_1.id]

		arg0_1.viewComponent:setFleet(var0_8)
		arg0_1.viewComponent:updateEditPanel()
	end)
	arg0_1:bind(ActivityFleetPanel.ON_FLEET_CLEAR, function(arg0_9, arg1_9)
		local var0_9 = var0_1:getActivityFleets()[var3_1.id]
		local var1_9 = var0_9[arg1_9]

		var1_9:clearFleet()
		var0_1:updateActivityFleet(var3_1.id, arg1_9, var1_9)
		arg0_1.viewComponent:setFleet(var0_9)
		arg0_1.viewComponent:updateEditPanel()
	end)
	arg0_1:bind(var0_0.COMMANDER_FORMATION_OP, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1_10
		})
	end)
	arg0_1:bind(var0_0.ON_COMMANDER_SKILL, function(arg0_11, arg1_11)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_11
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_SELECT_ELITE_COMMANDER, function(arg0_12, arg1_12, arg2_12)
		local var0_12 = var0_1:getActivityFleets()[var3_1.id]
		local var1_12 = var0_12[arg1_12]
		local var2_12 = var1_12:getCommanders()

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2_12[arg2_12],
			ignoredIds = {},
			fleetType = CommanderCatScene.FLEET_TYPE_CHALLENGE,
			onCommander = function(arg0_13)
				return true
			end,
			onSelected = function(arg0_14, arg1_14)
				local var0_14 = arg0_14[1]
				local var1_14 = getProxy(CommanderProxy):getCommanderById(var0_14)

				for iter0_14, iter1_14 in pairs(var0_12) do
					if iter0_14 == arg1_12 then
						for iter2_14, iter3_14 in pairs(var2_12) do
							if iter3_14.groupId == var1_14.groupId and iter2_14 ~= arg2_12 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

								return
							end
						end
					else
						local var2_14 = iter1_14:getCommanders()

						for iter4_14, iter5_14 in pairs(var2_14) do
							if var0_14 == iter5_14.id then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

								return
							end
						end
					end
				end

				var1_12:updateCommanderByPos(arg2_12, var1_14)
				var0_1:updateActivityFleet(var3_1.id, arg1_12, var1_12)
				arg1_14()
			end,
			onQuit = function(arg0_15)
				var1_12:updateCommanderByPos(arg2_12, nil)
				var0_1:updateActivityFleet(var3_1.id, arg1_12, var1_12)
				arg0_15()
			end
		})

		arg0_1.contextData.editFleet = true
	end)
	arg0_1:bind(var0_0.ON_PRECOMBAT, function(arg0_16, arg1_16)
		if var0_1:checkActivityFleet(var3_1.id) ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		local var0_16 = var0_1:getActivityFleets()[var3_1.id][arg1_16 + 1]:isLegalToFight()

		if var0_16 == TeamType.Vanguard then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_vanguardFleet_must_hasShip"))

			return
		elseif var0_16 == TeamType.Main then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_mainFleet_must_hasShip"))

			return
		end

		arg0_1.viewComponent:hideFleetEdit()

		if not var2_1:getUserChallengeInfo(arg1_16) then
			arg0_1:sendNotification(GAME.CHALLENGE2_INITIAL, {
				mode = arg1_16
			})

			return
		end

		arg0_1:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {
				system = SYSTEM_CHALLENGE,
				actId = var3_1.id,
				mode = arg1_16,
				func = function()
					arg0_1:tryBattle()
				end
			}
		}))
	end)

	local var4_1 = var0_1:getActivityFleets()[var3_1.id]

	arg0_1.viewComponent:setFleet(var4_1)

	local var5_1 = getProxy(CommanderProxy):getPrefabFleet()

	arg0_1.viewComponent:setCommanderPrefabs(var5_1)
end

function var0_0.listNotificationInterests(arg0_18)
	return {
		GAME.CHALLENGE2_INITIAL_DONE,
		GAME.CHALLENGE2_RESET_DONE,
		GAME.CHALLENGE2_INFO_DONE,
		GAME.SUBMIT_TASK_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE
	}
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()
	local var2_19 = getProxy(ChallengeProxy)
	local var3_19 = getProxy(ActivityProxy)
	local var4_19 = getProxy(FleetProxy)

	if var0_19 == GAME.CHALLENGE2_INITIAL_DONE then
		local var5_19 = var1_19.mode
		local var6_19 = var2_19:getUserChallengeInfo(var5_19)
		local var7_19 = var3_19:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

		arg0_19:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {
				system = SYSTEM_CHALLENGE,
				actId = var7_19.id,
				mode = var5_19,
				func = function()
					arg0_19:tryBattle()
				end
			}
		}))
		arg0_19.viewComponent:updateData()
		arg0_19.viewComponent:updatePaintingList()
		arg0_19.viewComponent:updateRoundText()
		arg0_19.viewComponent:updateSlider()
		arg0_19.viewComponent:updateFuncBtns()
	elseif var0_19 == GAME.CHALLENGE2_RESET_DONE then
		if arg0_19.viewComponent.curMode == ChallengeProxy.MODE_INFINITE and not arg0_19.viewComponent:isFinishedCasualMode() then
			var2_19:setCurMode(ChallengeProxy.MODE_CASUAL)
		end

		arg0_19.viewComponent:updateData()
		arg0_19.viewComponent:updateGrade(var2_19:getChallengeInfo():getGradeList())
		arg0_19.viewComponent:updateSwitchModBtn()
		arg0_19.viewComponent:updatePaintingList()
		arg0_19.viewComponent:updateRoundText()
		arg0_19.viewComponent:updateSlider()
		arg0_19.viewComponent:updateFuncBtns()
	elseif var0_19 == GAME.CHALLENGE2_INFO_DONE then
		if arg0_19.viewComponent.curMode == ChallengeProxy.MODE_INFINITE and not arg0_19.viewComponent:isFinishedCasualMode() then
			var2_19:setCurMode(ChallengeProxy.MODE_CASUAL)
		end

		arg0_19.viewComponent:updateData()
		arg0_19.viewComponent:updateGrade(var2_19:getChallengeInfo():getGradeList())
		arg0_19.viewComponent:updateTimePanel()
		arg0_19.viewComponent:updateSwitchModBtn()
		arg0_19.viewComponent:updatePaintingList()
		arg0_19.viewComponent:updateRoundText()
		arg0_19.viewComponent:updateSlider()
		arg0_19.viewComponent:updateFuncBtns()
	elseif var0_19 == GAME.SUBMIT_TASK_DONE then
		arg0_19.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_19, function()
			arg0_19.viewComponent:updateAwardPanel()
		end)
	elseif var0_19 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var8_19 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_19.viewComponent:setCommanderPrefabs(var8_19)
		arg0_19.viewComponent:updateCommanderPrefab()
	elseif var0_19 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		local var9_19 = var4_19:getActivityFleets()[var1_19.actId]

		arg0_19.viewComponent:setFleet(var9_19)
		arg0_19.viewComponent:updateEditPanel()
		arg0_19.viewComponent:updateCommanderFleet(var9_19[var1_19.fleetId])
	end
end

function var0_0.getDockCallbackFuncs(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	local var0_22 = getProxy(BayProxy)
	local var1_22 = getProxy(FleetProxy)
	local var2_22 = getProxy(ActivityProxy)
	local var3_22 = var2_22:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	local function var4_22(arg0_23, arg1_23)
		local var0_23, var1_23 = ShipStatus.ShipStatusCheck("inActivity", arg0_23, arg1_23, {
			inActivity = var3_22.id
		})

		if not var0_23 then
			return var0_23, var1_23
		end

		for iter0_23, iter1_23 in ipairs(arg1_22) do
			if arg0_23:isSameKind(var0_22:getShipById(iter1_23)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var5_22(arg0_24, arg1_24, arg2_24)
		arg1_24()
	end

	local function var6_22(arg0_25)
		local var0_25 = var2_22:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
		local var1_25 = var1_22:getActivityFleets()[var0_25.id][arg3_22]

		if arg2_22 then
			var1_25:removeShip(arg2_22)
		end

		if #arg0_25 > 0 then
			var1_25:insertShip(var0_22:getShipById(arg0_25[1]), nil, arg4_22)
		end

		var1_22:updateActivityFleet(var0_25.id, arg3_22, var1_25)
	end

	return var4_22, var5_22, var6_22
end

return var0_0
