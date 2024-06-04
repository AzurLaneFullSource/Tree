local var0 = class("ChallengeMainMediator", import("..base.ContextMediator"))

var0.ON_COMMIT_FLEET = "ChallengeMainMediator:ON_COMMIT_FLEET"
var0.ON_FLEET_SHIPINFO = "ChallengeMainMediator:ON_FLEET_SHIPINFO"
var0.ON_PRECOMBAT = "ChallengeMainMediator:ON_PRECOMBAT"
var0.ON_SELECT_ELITE_COMMANDER = "ChallengeMainMediator:ON_SELECT_ELITE_COMMANDER"
var0.ON_OPEN_RANK = "ChallengeMainMediator:ON_OPEN_RANK"
var0.COMMANDER_FORMATION_OP = "ChallengeMainMediator:COMMANDER_FORMATION_OP"
var0.ON_COMMANDER_SKILL = "ChallengeMainMediator:ON_COMMANDER_SKILL"

function var0.register(arg0)
	local var0 = getProxy(FleetProxy)
	local var1 = getProxy(ActivityProxy)
	local var2 = getProxy(ChallengeProxy)
	local var3 = var1:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	arg0:bind(var0.ON_OPEN_RANK, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_CHALLENGE
		})
	end)
	arg0:bind(ChallengeConst.CLICK_GET_AWARD_BTN, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0:bind(ChallengeConst.RESET_DATA_EVENT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.CHALLENGE2_RESET, {
			mode = arg1,
			isInfiniteSeasonClear = arg2
		})
	end)
	arg0:bind(ActivityFleetPanel.ON_OPEN_DOCK, function(arg0, arg1)
		local var0 = arg1.shipType
		local var1 = arg1.fleetIndex
		local var2 = arg1.shipVO
		local var3 = arg1.fleet
		local var4 = arg1.teamType
		local var5 = getProxy(BayProxy):getRawData()

		arg0.contextData.editFleet = true

		local var6, var7, var8 = arg0:getDockCallbackFuncs(var3, var2, var1, var4)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var2 ~= nil,
			teamFilter = var4,
			leftTopInfo = i18n("word_formation"),
			onShip = var6,
			confirmSelect = var7,
			onSelected = var8,
			hideTagFlags = setmetatable({
				inActivity = var3.id
			}, {
				__index = ShipStatus.TAG_HIDE_CHALLENGE
			}),
			otherSelectedIds = var3,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0:bind(var0.ON_COMMIT_FLEET, function()
		var0:commitActivityFleet(var3.id)
	end)
	arg0:bind(var0.ON_FLEET_SHIPINFO, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.shipId,
			shipVOs = arg1.shipVOs
		})

		arg0.contextData.editFleet = true
	end)
	arg0:bind(ActivityFleetPanel.ON_FLEET_RECOMMEND, function(arg0, arg1)
		var0:recommendActivityFleet(var3.id, arg1)

		local var0 = var0:getActivityFleets()[var3.id]

		arg0.viewComponent:setFleet(var0)
		arg0.viewComponent:updateEditPanel()
	end)
	arg0:bind(ActivityFleetPanel.ON_FLEET_CLEAR, function(arg0, arg1)
		local var0 = var0:getActivityFleets()[var3.id]
		local var1 = var0[arg1]

		var1:clearFleet()
		var0:updateActivityFleet(var3.id, arg1, var1)
		arg0.viewComponent:setFleet(var0)
		arg0.viewComponent:updateEditPanel()
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
	arg0:bind(var0.ON_SELECT_ELITE_COMMANDER, function(arg0, arg1, arg2)
		local var0 = var0:getActivityFleets()[var3.id]
		local var1 = var0[arg1]
		local var2 = var1:getCommanders()

		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2[arg2],
			ignoredIds = {},
			fleetType = CommanderCatScene.FLEET_TYPE_CHALLENGE,
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
				var0:updateActivityFleet(var3.id, arg1, var1)
				arg1()
			end,
			onQuit = function(arg0)
				var1:updateCommanderByPos(arg2, nil)
				var0:updateActivityFleet(var3.id, arg1, var1)
				arg0()
			end
		})

		arg0.contextData.editFleet = true
	end)
	arg0:bind(var0.ON_PRECOMBAT, function(arg0, arg1)
		if var0:checkActivityFleet(var3.id) ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		local var0 = var0:getActivityFleets()[var3.id][arg1 + 1]:isLegalToFight()

		if var0 == TeamType.Vanguard then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_vanguardFleet_must_hasShip"))

			return
		elseif var0 == TeamType.Main then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_mainFleet_must_hasShip"))

			return
		end

		arg0.viewComponent:hideFleetEdit()

		if not var2:getUserChallengeInfo(arg1) then
			arg0:sendNotification(GAME.CHALLENGE2_INITIAL, {
				mode = arg1
			})

			return
		end

		arg0:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {
				system = SYSTEM_CHALLENGE,
				actId = var3.id,
				mode = arg1,
				func = function()
					arg0:tryBattle()
				end
			}
		}))
	end)

	local var4 = var0:getActivityFleets()[var3.id]

	arg0.viewComponent:setFleet(var4)

	local var5 = getProxy(CommanderProxy):getPrefabFleet()

	arg0.viewComponent:setCommanderPrefabs(var5)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CHALLENGE2_INITIAL_DONE,
		GAME.CHALLENGE2_RESET_DONE,
		GAME.CHALLENGE2_INFO_DONE,
		GAME.SUBMIT_TASK_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = getProxy(ChallengeProxy)
	local var3 = getProxy(ActivityProxy)
	local var4 = getProxy(FleetProxy)

	if var0 == GAME.CHALLENGE2_INITIAL_DONE then
		local var5 = var1.mode
		local var6 = var2:getUserChallengeInfo(var5)
		local var7 = var3:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

		arg0:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {
				system = SYSTEM_CHALLENGE,
				actId = var7.id,
				mode = var5,
				func = function()
					arg0:tryBattle()
				end
			}
		}))
		arg0.viewComponent:updateData()
		arg0.viewComponent:updatePaintingList()
		arg0.viewComponent:updateRoundText()
		arg0.viewComponent:updateSlider()
		arg0.viewComponent:updateFuncBtns()
	elseif var0 == GAME.CHALLENGE2_RESET_DONE then
		if arg0.viewComponent.curMode == ChallengeProxy.MODE_INFINITE and not arg0.viewComponent:isFinishedCasualMode() then
			var2:setCurMode(ChallengeProxy.MODE_CASUAL)
		end

		arg0.viewComponent:updateData()
		arg0.viewComponent:updateGrade(var2:getChallengeInfo():getGradeList())
		arg0.viewComponent:updateSwitchModBtn()
		arg0.viewComponent:updatePaintingList()
		arg0.viewComponent:updateRoundText()
		arg0.viewComponent:updateSlider()
		arg0.viewComponent:updateFuncBtns()
	elseif var0 == GAME.CHALLENGE2_INFO_DONE then
		if arg0.viewComponent.curMode == ChallengeProxy.MODE_INFINITE and not arg0.viewComponent:isFinishedCasualMode() then
			var2:setCurMode(ChallengeProxy.MODE_CASUAL)
		end

		arg0.viewComponent:updateData()
		arg0.viewComponent:updateGrade(var2:getChallengeInfo():getGradeList())
		arg0.viewComponent:updateTimePanel()
		arg0.viewComponent:updateSwitchModBtn()
		arg0.viewComponent:updatePaintingList()
		arg0.viewComponent:updateRoundText()
		arg0.viewComponent:updateSlider()
		arg0.viewComponent:updateFuncBtns()
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:updateAwardPanel()
		end)
	elseif var0 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var8 = getProxy(CommanderProxy):getPrefabFleet()

		arg0.viewComponent:setCommanderPrefabs(var8)
		arg0.viewComponent:updateCommanderPrefab()
	elseif var0 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		local var9 = var4:getActivityFleets()[var1.actId]

		arg0.viewComponent:setFleet(var9)
		arg0.viewComponent:updateEditPanel()
		arg0.viewComponent:updateCommanderFleet(var9[var1.fleetId])
	end
end

function var0.getDockCallbackFuncs(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(BayProxy)
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(ActivityProxy)
	local var3 = var2:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	local function var4(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inActivity", arg0, arg1, {
			inActivity = var3.id
		})

		if not var0 then
			return var0, var1
		end

		for iter0, iter1 in ipairs(arg1) do
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
		local var0 = var2:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
		local var1 = var1:getActivityFleets()[var0.id][arg3]

		if arg2 then
			var1:removeShip(arg2)
		end

		if #arg0 > 0 then
			var1:insertShip(var0:getShipById(arg0[1]), nil, arg4)
		end

		var1:updateActivityFleet(var0.id, arg3, var1)
	end

	return var4, var5, var6
end

return var0
