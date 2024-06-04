local var0 = class("ActivityBossMediatorTemplate", import("view.base.ContextMediator"))

var0.ON_SUBMIT_TASK = "ActivityBossMediatorTemplate ON_SUBMIT_TASK"
var0.ON_RANK = "ActivityBossMediatorTemplate ON_RANK"
var0.ON_PRECOMBAT = "ActivityBossMediatorTemplate ON_PRECOMBAT"
var0.ON_EX_PRECOMBAT = "ActivityBossMediatorTemplate ON_EX_PRECOMBAT"
var0.ON_SP_PRECOMBAT = "ActivityBossMediatorTemplate ON_SP_PRECOMBAT"
var0.ON_COMMIT_FLEET = "ActivityBossMediatorTemplate ON_COMMIT_FLEET"
var0.ON_FLEET_RECOMMEND = "ActivityBossMediatorTemplate ON_FLEET_RECOMMEND"
var0.ON_FLEET_CLEAR = "ActivityBossMediatorTemplate ON_FLEET_CLEAR"
var0.ON_OPEN_DOCK = "ActivityBossMediatorTemplate ON_OPEN_DOCK"
var0.ON_FLEET_SHIPINFO = "ActivityBossMediatorTemplate ON_FLEET_SHIPINFO"
var0.ON_SELECT_COMMANDER = "ActivityBossMediatorTemplate ON_SELECT_COMMANDER"
var0.ON_PERFORM_COMBAT = "ActivityBossMediatorTemplate ON_PERFORM_COMBAT"
var0.ONEN_BUFF_SELECT = "ActivityBossMediatorTemplate ONEN_BUFF_SELECT"
var0.COMMANDER_FORMATION_OP = "ActivityBossMediatorTemplate COMMANDER_FORMATION_OP"
var0.ON_COMMANDER_SKILL = "ActivityBossMediatorTemplate ON_COMMANDER_SKILL"

local var1 = {
	"word_easy",
	"word_normal_junhe",
	"word_hard"
}

function var0.GetPairedFleetIndex(arg0)
	if arg0 < Fleet.SUBMARINE_FLEET_ID then
		return arg0 + 10
	else
		return arg0 - 10
	end
end

function var0.register(arg0)
	arg0.contextData.mediatorClass = arg0.class
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.timeMgr = pg.TimeMgr.GetInstance()

	local var0 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var0 then
		return
	end

	arg0:BindEvent()

	local var1 = getProxy(FleetProxy)

	arg0:UpdateActivityData(var0)

	arg0.contextData.activityID = var0 and var0.id

	local var2 = var0:GetBossConfig()

	arg0.contextData.TicketID = var2:GetTicketID()
	arg0.contextData.exStageID = var2:GetEXStageID()
	arg0.contextData.normalStageIDs = var2:GetNormalStageIDs()
	arg0.contextData.ticketInitPools = var2:GetInitTicketPools()
	arg0.contextData.useOilLimit = var2:GetOilLimits()
	arg0.contextData.DisplayItems = var2:GetMilestoneRewards()
	arg0.contextData.spStageID = var2:GetSPStageID()

	arg0:RequestAndUpdateView()

	local var3 = var1:getActivityFleets()[var0.id]

	arg0.contextData.actFleets = var3

	local var4 = var0:GetBindPtActID()

	arg0.contextData.ptActId = var4

	local var5 = arg0.activityProxy:getActivityById(var4)

	if var5 then
		arg0.contextData.ptData = ActivityBossPtData.New(var5)
	else
		errorMsg("没有找到当期BossPT活动 activity_event_pt link_id 未找到id: " .. var0.id)
	end

	local var6 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RANK)

	if var6 and not var6:isEnd() then
		local var7 = getProxy(BillboardProxy)
		local var8 = PowerRank.TYPE_ACT_BOSS_BATTLE
		local var9 = var6.id

		if var7:canFetch(var8, var9) then
			arg0:sendNotification(GAME.GET_POWERRANK, {
				type = var8,
				activityId = var9
			})
		else
			local var10 = var7:getRankList(var8, var9)

			arg0:UpdateRankData(var10)
		end
	end

	local var11 = getProxy(CommanderProxy):getPrefabFleet()

	arg0.viewComponent:setCommanderPrefabs(var11)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle()
end

function var0.BindEvent(arg0)
	local var0 = getProxy(FleetProxy)
	local var1 = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	assert(var1)
	arg0:bind(var0.ON_RANK, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			index = PowerRank.TYPE_ACT_BOSS_BATTLE
		})
	end)
	arg0:bind(ActivityMediator.EVENT_PT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_NEW_PT, arg1)
	end)
	arg0:bind(var0.ON_SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0:bind(var0.ON_PRECOMBAT, function(arg0, arg1)
		local var0 = var0:getActivityFleets()[var1.id]

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
		local var2 = var1.id

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
		local var5 = SYSTEM_ACT_BOSS
		local var6 = arg0.contextData.normalStageIDs[arg1]
		local var7 = arg0.contextData.useOilLimit[arg1]

		if not arg0.contextData.activity:IsOilLimit(var6) then
			var7 = {
				0,
				0
			}
		end

		arg0:addSubLayers(Context.New({
			mediator = ActivityBossPreCombatMediator,
			viewComponent = ActivityBossPreCombatLayer,
			data = {
				system = var5,
				stageId = var6,
				actId = var1.id,
				fleets = var1,
				costLimit = var7,
				OnConfirm = function(arg0)
					if not arg0.contextData.activity:checkBattleTimeInBossAct() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

						return
					end

					local var0 = getProxy(SettingsProxy):isTipActBossExchangeTicket()
					local var1 = getProxy(PlayerProxy):getRawData():getResource(arg0.contextData.TicketID) > 0 and (arg0.contextData.stageTickets[var6] or 0) <= 0

					if var0 == nil and var1 then
						local var2 = Drop.New({
							type = DROP_TYPE_RESOURCE,
							id = arg0.contextData.TicketID or 1
						}):getIcon()

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							hideYes = true,
							noText = "text_inconsume",
							content = i18n("tip_exchange_ticket", i18n(var1[arg1])),
							custom = {
								{
									text = "text_consume",
									sound = SFX_CONFIRM,
									onCallback = function()
										getProxy(SettingsProxy):setActBossExchangeTicketTip(1)

										arg0.contextData.ready2battleCb = arg0

										arg0:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
											stageId = var6
										})
									end,
									btnType = pg.MsgboxMgr.BUTTON_BLUE_WITH_ICON,
									iconName = {
										var2
									}
								}
							},
							onNo = function()
								getProxy(SettingsProxy):setActBossExchangeTicketTip(0)
								arg0()
							end,
							onClose = function()
								return
							end
						})
					else
						local var3 = var0 == 1

						if var1 and var3 then
							arg0.contextData.ready2battleCb = arg0

							arg0:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
								stageId = var6
							})
						else
							arg0()
						end
					end
				end
			},
			onRemoved = function()
				arg0.viewComponent:updateEditPanel()
			end
		}))
	end)
	arg0:bind(var0.ON_EX_PRECOMBAT, function(arg0, arg1, arg2)
		local var0 = var0:getActivityFleets()[var1.id]

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
		local var2 = var1.id

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

		seriesAsync({
			function(arg0)
				local var0 = "NG0017"

				if not arg2 and not pg.NewStoryMgr.GetInstance():IsPlayed(var0) then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						hideNo = false,
						showStopRemind = true,
						hideYes = false,
						helps = pg.gametip.worldbossex_help.tip,
						type = MSGBOX_TYPE_HELP,
						stopRamindContent = i18n("dont_remind"),
						onYes = function()
							if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
								pg.m02:sendNotification(GAME.STORY_UPDATE, {
									storyId = var0
								})
							end

							arg0()
						end,
						onNo = function()
							if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
								pg.m02:sendNotification(GAME.STORY_UPDATE, {
									storyId = var0
								})
							end
						end
					})
				else
					arg0()
				end
			end,
			function(arg0)
				local var0
				local var1
				local var2 = arg2 and SYSTEM_BOSS_EXPERIMENT or SYSTEM_HP_SHARE_ACT_BOSS
				local var3 = arg0.contextData.exStageID
				local var4 = arg0.contextData.useOilLimit[4]

				if not arg0.contextData.activity:IsOilLimit(var3) then
					var4 = {
						0,
						0
					}
				end

				arg0:addSubLayers(Context.New({
					mediator = ActivityBossPreCombatMediator,
					viewComponent = ActivityBossPreCombatLayer,
					data = {
						system = var2,
						stageId = var3,
						actId = var1.id,
						fleets = var1,
						costLimit = var4,
						OnConfirm = function(arg0)
							if not arg0.contextData.activity:checkBattleTimeInBossAct() then
								pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

								return
							end

							arg0()
						end
					}
				}))
			end
		})
	end)
	arg0:bind(var0.ON_SP_PRECOMBAT, function(arg0, arg1)
		local var0 = var0:getActivityFleets()[var1.id]

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
		local var2 = var1.id

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

		seriesAsync({
			function(arg0)
				local var0
				local var1
				local var2 = SYSTEM_ACT_BOSS_SP
				local var3 = arg0.contextData.spStageID
				local var4 = {
					0,
					0
				}

				arg0:addSubLayers(Context.New({
					mediator = ActivityBossPreCombatMediator,
					viewComponent = ActivityBossPreCombatLayer,
					data = {
						system = var2,
						stageId = var3,
						actId = var1.id,
						fleets = var1,
						costLimit = var4,
						OnConfirm = function(arg0)
							if not arg0.contextData.activity:checkBattleTimeInBossAct() then
								pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

								return
							end

							arg0()
						end
					}
				}))
			end
		})
	end)
	arg0:bind(var0.ON_COMMIT_FLEET, function()
		var0:commitActivityFleet(var1.id)
	end)
	arg0:bind(var0.ON_FLEET_RECOMMEND, function(arg0, arg1)
		var0:recommendActivityFleet(var1.id, arg1)

		local var0 = var0:getActivityFleets()[var1.id]

		arg0.contextData.actFleets = var0

		arg0.viewComponent:updateEditPanel()
	end)
	arg0:bind(var0.ON_FLEET_CLEAR, function(arg0, arg1)
		local var0 = var0:getActivityFleets()[var1.id]
		local var1 = var0[arg1]

		var1:clearFleet()
		var0:updateActivityFleet(var1.id, arg1, var1)

		arg0.contextData.actFleets = var0

		arg0.viewComponent:updateEditPanel()
	end)
	arg0:bind(var0.ON_OPEN_DOCK, function(arg0, arg1)
		local var0 = arg1.fleetIndex
		local var1 = arg1.shipVO
		local var2 = arg1.fleet
		local var3 = arg1.teamType
		local var4, var5, var6 = arg0.getDockCallbackFuncs4ActicityFleet(var1, var0, var3)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1 ~= nil,
			teamFilter = var3,
			leftTopInfo = i18n("word_formation"),
			onShip = var4,
			confirmSelect = var5,
			onSelected = var6,
			hideTagFlags = setmetatable({
				inActivity = var1.id
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
		local var0 = var0:getActivityFleets()[var1.id]
		local var1 = var0[arg1]
		local var2 = var1:getCommanders()

		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2[arg2],
			fleetType = CommanderCatScene.FLEET_TYPE_ACTBOSS,
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
				var0:updateActivityFleet(var1.id, arg1, var1)
				arg1()
			end,
			onQuit = function(arg0)
				var1:updateCommanderByPos(arg2, nil)
				var0:updateActivityFleet(var1.id, arg1, var1)
				arg0()
			end
		})
	end)
	arg0:bind(var0.ON_PERFORM_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			mainFleetId = 1,
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = arg1,
			exitCallback = arg2
		})
	end)
	arg0:bind(PreCombatMediator.BEGIN_STAGE_PROXY, function(arg0, arg1)
		arg0:sendNotification(PreCombatMediator.BEGIN_STAGE_PROXY, {
			curFleetId = arg1
		})
	end)
	arg0:bind(var0.ONEN_BUFF_SELECT, function(arg0)
		local var0 = ActivityBossBuffSelectLayer
		local var1 = ActivityBossBuffSelectMediator

		;(function(arg0)
			if not arg0 or arg0:isEnd() then
				return
			end

			local var0 = arg0:getConfig("config_client").buff_scene

			if not var0 then
				return
			end

			var0 = _G[var0]
		end)(arg0.contextData.activity)
		arg0:addSubLayers(Context.New({
			mediator = var1,
			viewComponent = var0,
			data = {
				spEnemyInfo = arg0.contextData.activity:GetBossConfig():GetSPEnemy(),
				score = arg0.contextData.activity:GetHighestScore()
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_ADDED,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE,
		GAME.ACT_NEW_PT_DONE,
		GAME.ACT_BOSS_EXCHANGE_TICKET_DONE,
		GAME.GET_POWERRANK_DONE,
		ActivityBossBuffSelectMediator.ON_START,
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_ADDED or var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1.id == arg0.contextData.ptActId then
			if arg0.contextData.ptData then
				arg0.contextData.ptData:Update(var1)
			else
				arg0.contextData.ptData = ActivityBossPtData.New(var1)
			end

			arg0:UpdateView()
		elseif var1.id == arg0.contextData.activityID then
			arg0:UpdateActivityData(var1)
			arg0:UpdateView()
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0:RequestAndUpdateView()
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0.contextData.editFleet = nil

		if not getProxy(ContextProxy):getContextByMediator(PreCombatMediator) then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
		end
	elseif var0 == GAME.ACT_BOSS_EXCHANGE_TICKET_DONE then
		if arg0.contextData.ready2battleCb then
			arg0.contextData.ready2battleCb()

			arg0.contextData.ready2battleCb = nil
		end
	elseif var0 == GAME.GET_POWERRANK_DONE then
		if var1.type == PowerRank.TYPE_ACT_BOSS_BATTLE then
			arg0:UpdateRankData(var1.list)
		end
	elseif var0 == GAME.ACT_NEW_PT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		local var2 = getProxy(FleetProxy):getActivityFleets()[var1.actId]

		arg0.contextData.actFleets = var2

		arg0.viewComponent:updateEditPanel()
		arg0.viewComponent:updateCommanderFleet(var2[var1.fleetId])
	elseif var0 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var3 = getProxy(CommanderProxy):getPrefabFleet()

		arg0.viewComponent:setCommanderPrefabs(var3)
		arg0.viewComponent:updateCommanderPrefab()
	elseif var0 == ActivityBossBuffSelectMediator.ON_START then
		arg0.viewComponent:ShowSPFleet()
	end
end

function var0.RequestAndUpdateView(arg0)
	arg0:sendNotification(GAME.ACTIVITY_BOSS_PAGE_UPDATE, {
		activity_id = arg0.contextData.activityID
	})
end

function var0.UpdateView(arg0)
	arg0.viewComponent:UpdateView()
end

function var0.UpdateRankData(arg0, arg1)
	arg0.viewComponent:UpdateRank(arg1)
end

function var0.UpdateActivityData(arg0, arg1)
	arg0.contextData.activity = arg1
	arg0.contextData.bossHP = arg1:GetBossHP()
	arg0.contextData.mileStones = arg1:GetMileStones()
	arg0.contextData.stageTickets = arg1:GetTickets()
end

function var0.getDockCallbackFuncs4ActicityFleet(arg0, arg1, arg2)
	local var0 = getProxy(BayProxy)
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)
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

		for iter0, iter1 in ipairs(var3.ships) do
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
