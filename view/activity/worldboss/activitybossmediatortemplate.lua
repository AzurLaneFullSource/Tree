local var0_0 = class("ActivityBossMediatorTemplate", import("view.base.ContextMediator"))

var0_0.ON_SUBMIT_TASK = "ActivityBossMediatorTemplate ON_SUBMIT_TASK"
var0_0.ON_RANK = "ActivityBossMediatorTemplate ON_RANK"
var0_0.ON_PRECOMBAT = "ActivityBossMediatorTemplate ON_PRECOMBAT"
var0_0.ON_EX_PRECOMBAT = "ActivityBossMediatorTemplate ON_EX_PRECOMBAT"
var0_0.ON_SP_PRECOMBAT = "ActivityBossMediatorTemplate ON_SP_PRECOMBAT"
var0_0.ON_COMMIT_FLEET = "ActivityBossMediatorTemplate ON_COMMIT_FLEET"
var0_0.ON_FLEET_RECOMMEND = "ActivityBossMediatorTemplate ON_FLEET_RECOMMEND"
var0_0.ON_FLEET_CLEAR = "ActivityBossMediatorTemplate ON_FLEET_CLEAR"
var0_0.ON_OPEN_DOCK = "ActivityBossMediatorTemplate ON_OPEN_DOCK"
var0_0.ON_FLEET_SHIPINFO = "ActivityBossMediatorTemplate ON_FLEET_SHIPINFO"
var0_0.ON_SELECT_COMMANDER = "ActivityBossMediatorTemplate ON_SELECT_COMMANDER"
var0_0.ON_PERFORM_COMBAT = "ActivityBossMediatorTemplate ON_PERFORM_COMBAT"
var0_0.ONEN_BUFF_SELECT = "ActivityBossMediatorTemplate ONEN_BUFF_SELECT"
var0_0.COMMANDER_FORMATION_OP = "ActivityBossMediatorTemplate COMMANDER_FORMATION_OP"
var0_0.ON_COMMANDER_SKILL = "ActivityBossMediatorTemplate ON_COMMANDER_SKILL"

local var1_0 = {
	"word_easy",
	"word_normal_junhe",
	"word_hard"
}

function var0_0.GetPairedFleetIndex(arg0_1)
	if arg0_1 < Fleet.SUBMARINE_FLEET_ID then
		return arg0_1 + 10
	else
		return arg0_1 - 10
	end
end

function var0_0.register(arg0_2)
	arg0_2.contextData.mediatorClass = arg0_2.class
	arg0_2.activityProxy = getProxy(ActivityProxy)
	arg0_2.timeMgr = pg.TimeMgr.GetInstance()

	local var0_2 = arg0_2.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var0_2 then
		return
	end

	arg0_2:BindEvent()

	local var1_2 = getProxy(FleetProxy)

	arg0_2:UpdateActivityData(var0_2)

	arg0_2.contextData.activityID = var0_2 and var0_2.id

	local var2_2 = var0_2:GetBossConfig()

	arg0_2.contextData.TicketID = var2_2:GetTicketID()
	arg0_2.contextData.exStageID = var2_2:GetEXStageID()
	arg0_2.contextData.normalStageIDs = var2_2:GetNormalStageIDs()
	arg0_2.contextData.ticketInitPools = var2_2:GetInitTicketPools()
	arg0_2.contextData.useOilLimit = var2_2:GetOilLimits()
	arg0_2.contextData.DisplayItems = var2_2:GetMilestoneRewards()
	arg0_2.contextData.spStageID = var2_2:GetSPStageID()

	arg0_2:RequestAndUpdateView()

	local var3_2 = var1_2:getActivityFleets()[var0_2.id]

	arg0_2.contextData.actFleets = var3_2

	local var4_2 = var0_2:GetBindPtActID()

	arg0_2.contextData.ptActId = var4_2

	local var5_2 = arg0_2.activityProxy:getActivityById(var4_2)

	if var5_2 then
		arg0_2.contextData.ptData = ActivityBossPtData.New(var5_2)
	else
		errorMsg("没有找到当期BossPT活动 activity_event_pt link_id 未找到id: " .. var0_2.id)
	end

	local var6_2 = arg0_2.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RANK)

	if var6_2 and not var6_2:isEnd() then
		local var7_2 = getProxy(BillboardProxy)
		local var8_2 = PowerRank.TYPE_ACT_BOSS_BATTLE
		local var9_2 = var6_2.id

		if var7_2:canFetch(var8_2, var9_2) then
			arg0_2:sendNotification(GAME.GET_POWERRANK, {
				type = var8_2,
				activityId = var9_2
			})
		else
			local var10_2 = var7_2:getRankList(var8_2, var9_2)

			arg0_2:UpdateRankData(var10_2)
		end
	end

	local var11_2 = getProxy(CommanderProxy):getPrefabFleet()

	arg0_2.viewComponent:setCommanderPrefabs(var11_2)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle()
end

function var0_0.BindEvent(arg0_3)
	local var0_3 = getProxy(FleetProxy)
	local var1_3 = arg0_3.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	assert(var1_3)
	arg0_3:bind(var0_0.ON_RANK, function(arg0_4)
		arg0_3:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			index = PowerRank.TYPE_ACT_BOSS_BATTLE
		})
	end)
	arg0_3:bind(ActivityMediator.EVENT_PT_OPERATION, function(arg0_5, arg1_5)
		arg0_3:sendNotification(GAME.ACT_NEW_PT, arg1_5)
	end)
	arg0_3:bind(var0_0.ON_SUBMIT_TASK, function(arg0_6, arg1_6)
		arg0_3:sendNotification(GAME.SUBMIT_TASK, arg1_6)
	end)
	arg0_3:bind(var0_0.ON_PRECOMBAT, function(arg0_7, arg1_7)
		local var0_7 = var0_3:getActivityFleets()[var1_3.id]

		if not var0_7 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		var0_7[arg1_7]:RemoveUnusedItems()

		if var0_7[arg1_7]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		var0_7[arg1_7 + 10]:RemoveUnusedItems()

		local var1_7 = {
			var0_7[arg1_7],
			var0_7[arg1_7 + 10]
		}
		local var2_7 = var1_3.id

		if _.any(var1_7, function(arg0_8)
			local var0_8, var1_8 = arg0_8:HaveShipsInEvent()

			if var0_8 then
				pg.TipsMgr.GetInstance():ShowTips(var1_8)

				return true
			end

			return _.any(arg0_8:getShipIds(), function(arg0_9)
				local var0_9 = getProxy(BayProxy):RawGetShipById(arg0_9)

				if not var0_9 then
					return
				end

				local var1_9, var2_9 = ShipStatus.ShipStatusCheck("inActivity", var0_9, nil, {
					inActivity = var2_7
				})

				if not var1_9 then
					pg.TipsMgr.GetInstance():ShowTips(var2_9)

					return true
				end
			end)
		end) then
			return
		end

		local var3_7
		local var4_7
		local var5_7 = SYSTEM_ACT_BOSS
		local var6_7 = arg0_3.contextData.normalStageIDs[arg1_7]
		local var7_7 = arg0_3.contextData.useOilLimit[arg1_7]

		if not arg0_3.contextData.activity:IsOilLimit(var6_7) then
			var7_7 = {
				0,
				0
			}
		end

		arg0_3:addSubLayers(Context.New({
			mediator = ActivityBossPreCombatMediator,
			viewComponent = ActivityBossPreCombatLayer,
			data = {
				system = var5_7,
				stageId = var6_7,
				actId = var1_3.id,
				fleets = var1_7,
				costLimit = var7_7,
				OnConfirm = function(arg0_10)
					if not arg0_3.contextData.activity:checkBattleTimeInBossAct() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

						return
					end

					local var0_10 = getProxy(SettingsProxy):isTipActBossExchangeTicket()
					local var1_10 = getProxy(PlayerProxy):getRawData():getResource(arg0_3.contextData.TicketID) > 0 and (arg0_3.contextData.stageTickets[var6_7] or 0) <= 0

					if var0_10 == nil and var1_10 then
						local var2_10 = Drop.New({
							type = DROP_TYPE_RESOURCE,
							id = arg0_3.contextData.TicketID or 1
						}):getIcon()

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							hideYes = true,
							noText = "text_inconsume",
							content = i18n("tip_exchange_ticket", i18n(var1_0[arg1_7])),
							custom = {
								{
									text = "text_consume",
									sound = SFX_CONFIRM,
									onCallback = function()
										getProxy(SettingsProxy):setActBossExchangeTicketTip(1)

										arg0_3.contextData.ready2battleCb = arg0_10

										arg0_3:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
											stageId = var6_7
										})
									end,
									btnType = pg.MsgboxMgr.BUTTON_BLUE_WITH_ICON,
									iconName = {
										var2_10
									}
								}
							},
							onNo = function()
								getProxy(SettingsProxy):setActBossExchangeTicketTip(0)
								arg0_10()
							end,
							onClose = function()
								return
							end
						})
					else
						local var3_10 = var0_10 == 1

						if var1_10 and var3_10 then
							arg0_3.contextData.ready2battleCb = arg0_10

							arg0_3:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
								stageId = var6_7
							})
						else
							arg0_10()
						end
					end
				end
			},
			onRemoved = function()
				arg0_3.viewComponent:updateEditPanel()
			end
		}))
	end)
	arg0_3:bind(var0_0.ON_EX_PRECOMBAT, function(arg0_15, arg1_15, arg2_15)
		local var0_15 = var0_3:getActivityFleets()[var1_3.id]

		if not var0_15 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		var0_15[arg1_15]:RemoveUnusedItems()

		if var0_15[arg1_15]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		var0_15[arg1_15 + 10]:RemoveUnusedItems()

		local var1_15 = {
			var0_15[arg1_15],
			var0_15[arg1_15 + 10]
		}
		local var2_15 = var1_3.id

		if _.any(var1_15, function(arg0_16)
			local var0_16, var1_16 = arg0_16:HaveShipsInEvent()

			if var0_16 then
				pg.TipsMgr.GetInstance():ShowTips(var1_16)

				return true
			end

			return _.any(arg0_16:getShipIds(), function(arg0_17)
				local var0_17 = getProxy(BayProxy):RawGetShipById(arg0_17)

				if not var0_17 then
					return
				end

				local var1_17, var2_17 = ShipStatus.ShipStatusCheck("inActivity", var0_17, nil, {
					inActivity = var2_15
				})

				if not var1_17 then
					pg.TipsMgr.GetInstance():ShowTips(var2_17)

					return true
				end
			end)
		end) then
			return
		end

		seriesAsync({
			function(arg0_18)
				local var0_18 = "NG0017"

				if not arg2_15 and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_18) then
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
									storyId = var0_18
								})
							end

							arg0_18()
						end,
						onNo = function()
							if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
								pg.m02:sendNotification(GAME.STORY_UPDATE, {
									storyId = var0_18
								})
							end
						end
					})
				else
					arg0_18()
				end
			end,
			function(arg0_21)
				local var0_21
				local var1_21
				local var2_21 = arg2_15 and SYSTEM_BOSS_EXPERIMENT or SYSTEM_HP_SHARE_ACT_BOSS
				local var3_21 = arg0_3.contextData.exStageID
				local var4_21 = arg0_3.contextData.useOilLimit[4]

				if not arg0_3.contextData.activity:IsOilLimit(var3_21) then
					var4_21 = {
						0,
						0
					}
				end

				arg0_3:addSubLayers(Context.New({
					mediator = ActivityBossPreCombatMediator,
					viewComponent = ActivityBossPreCombatLayer,
					data = {
						system = var2_21,
						stageId = var3_21,
						actId = var1_3.id,
						fleets = var1_15,
						costLimit = var4_21,
						OnConfirm = function(arg0_22)
							if not arg0_3.contextData.activity:checkBattleTimeInBossAct() then
								pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

								return
							end

							arg0_22()
						end
					}
				}))
			end
		})
	end)
	arg0_3:bind(var0_0.ON_SP_PRECOMBAT, function(arg0_23, arg1_23)
		local var0_23 = var0_3:getActivityFleets()[var1_3.id]

		if not var0_23 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		var0_23[arg1_23]:RemoveUnusedItems()

		if var0_23[arg1_23]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		var0_23[arg1_23 + 10]:RemoveUnusedItems()

		local var1_23 = {
			var0_23[arg1_23],
			var0_23[arg1_23 + 10]
		}
		local var2_23 = var1_3.id

		if _.any(var1_23, function(arg0_24)
			local var0_24, var1_24 = arg0_24:HaveShipsInEvent()

			if var0_24 then
				pg.TipsMgr.GetInstance():ShowTips(var1_24)

				return true
			end

			return _.any(arg0_24:getShipIds(), function(arg0_25)
				local var0_25 = getProxy(BayProxy):RawGetShipById(arg0_25)

				if not var0_25 then
					return
				end

				local var1_25, var2_25 = ShipStatus.ShipStatusCheck("inActivity", var0_25, nil, {
					inActivity = var2_23
				})

				if not var1_25 then
					pg.TipsMgr.GetInstance():ShowTips(var2_25)

					return true
				end
			end)
		end) then
			return
		end

		seriesAsync({
			function(arg0_26)
				local var0_26
				local var1_26
				local var2_26 = SYSTEM_ACT_BOSS_SP
				local var3_26 = arg0_3.contextData.spStageID
				local var4_26 = {
					0,
					0
				}

				arg0_3:addSubLayers(Context.New({
					mediator = ActivityBossPreCombatMediator,
					viewComponent = ActivityBossPreCombatLayer,
					data = {
						system = var2_26,
						stageId = var3_26,
						actId = var1_3.id,
						fleets = var1_23,
						costLimit = var4_26,
						OnConfirm = function(arg0_27)
							if not arg0_3.contextData.activity:checkBattleTimeInBossAct() then
								pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

								return
							end

							arg0_27()
						end
					}
				}))
			end
		})
	end)
	arg0_3:bind(var0_0.ON_COMMIT_FLEET, function()
		var0_3:commitActivityFleet(var1_3.id)
	end)
	arg0_3:bind(var0_0.ON_FLEET_RECOMMEND, function(arg0_29, arg1_29)
		var0_3:recommendActivityFleet(var1_3.id, arg1_29)

		local var0_29 = var0_3:getActivityFleets()[var1_3.id]

		arg0_3.contextData.actFleets = var0_29

		arg0_3.viewComponent:updateEditPanel()
	end)
	arg0_3:bind(var0_0.ON_FLEET_CLEAR, function(arg0_30, arg1_30)
		local var0_30 = var0_3:getActivityFleets()[var1_3.id]
		local var1_30 = var0_30[arg1_30]

		var1_30:clearFleet()
		var0_3:updateActivityFleet(var1_3.id, arg1_30, var1_30)

		arg0_3.contextData.actFleets = var0_30

		arg0_3.viewComponent:updateEditPanel()
	end)
	arg0_3:bind(var0_0.ON_OPEN_DOCK, function(arg0_31, arg1_31)
		local var0_31 = arg1_31.fleetIndex
		local var1_31 = arg1_31.shipVO
		local var2_31 = arg1_31.fleet
		local var3_31 = arg1_31.teamType
		local var4_31, var5_31, var6_31 = arg0_3.getDockCallbackFuncs4ActicityFleet(var1_31, var0_31, var3_31)

		arg0_3:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1_31 ~= nil,
			teamFilter = var3_31,
			leftTopInfo = i18n("word_formation"),
			onShip = var4_31,
			confirmSelect = var5_31,
			onSelected = var6_31,
			hideTagFlags = setmetatable({
				inActivity = var1_3.id
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			otherSelectedIds = var2_31,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0_3:bind(var0_0.ON_FLEET_SHIPINFO, function(arg0_32, arg1_32)
		arg0_3:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_32.shipId,
			shipVOs = arg1_32.shipVOs
		})
	end)
	arg0_3:bind(var0_0.COMMANDER_FORMATION_OP, function(arg0_33, arg1_33)
		arg0_3:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1_33
		})
	end)
	arg0_3:bind(var0_0.ON_COMMANDER_SKILL, function(arg0_34, arg1_34)
		arg0_3:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_34
			}
		}))
	end)
	arg0_3:bind(var0_0.ON_SELECT_COMMANDER, function(arg0_35, arg1_35, arg2_35)
		local var0_35 = var0_3:getActivityFleets()[var1_3.id]
		local var1_35 = var0_35[arg1_35]
		local var2_35 = var1_35:getCommanders()

		arg0_3:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var2_35[arg2_35],
			fleetType = CommanderCatScene.FLEET_TYPE_ACTBOSS,
			ignoredIds = {},
			onCommander = function(arg0_36)
				return true
			end,
			onSelected = function(arg0_37, arg1_37)
				local var0_37 = arg0_37[1]
				local var1_37 = getProxy(CommanderProxy):getCommanderById(var0_37)

				for iter0_37, iter1_37 in pairs(var0_35) do
					if iter0_37 == arg1_35 then
						for iter2_37, iter3_37 in pairs(var2_35) do
							if iter3_37.groupId == var1_37.groupId and iter2_37 ~= arg2_35 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

								return
							end
						end
					elseif iter0_37 == var0_0.GetPairedFleetIndex(arg1_35) then
						local var2_37 = iter1_37:getCommanders()

						for iter4_37, iter5_37 in pairs(var2_37) do
							if var0_37 == iter5_37.id then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

								return
							end
						end
					end
				end

				var1_35:updateCommanderByPos(arg2_35, var1_37)
				var0_3:updateActivityFleet(var1_3.id, arg1_35, var1_35)
				arg1_37()
			end,
			onQuit = function(arg0_38)
				var1_35:updateCommanderByPos(arg2_35, nil)
				var0_3:updateActivityFleet(var1_3.id, arg1_35, var1_35)
				arg0_38()
			end
		})
	end)
	arg0_3:bind(var0_0.ON_PERFORM_COMBAT, function(arg0_39, arg1_39, arg2_39)
		arg0_3:sendNotification(GAME.BEGIN_STAGE, {
			mainFleetId = 1,
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = arg1_39,
			exitCallback = arg2_39
		})
	end)
	arg0_3:bind(PreCombatMediator.BEGIN_STAGE_PROXY, function(arg0_40, arg1_40)
		arg0_3:sendNotification(PreCombatMediator.BEGIN_STAGE_PROXY, {
			curFleetId = arg1_40
		})
	end)
	arg0_3:bind(var0_0.ONEN_BUFF_SELECT, function(arg0_41)
		local var0_41 = ActivityBossBuffSelectLayer
		local var1_41 = ActivityBossBuffSelectMediator

		;(function(arg0_42)
			if not arg0_42 or arg0_42:isEnd() then
				return
			end

			local var0_42 = arg0_42:getConfig("config_client").buff_scene

			if not var0_42 then
				return
			end

			var0_41 = _G[var0_42]
		end)(arg0_3.contextData.activity)
		arg0_3:addSubLayers(Context.New({
			mediator = var1_41,
			viewComponent = var0_41,
			data = {
				spEnemyInfo = arg0_3.contextData.activity:GetBossConfig():GetSPEnemy(),
				score = arg0_3.contextData.activity:GetHighestScore()
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_43)
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

function var0_0.handleNotification(arg0_44, arg1_44)
	local var0_44 = arg1_44:getName()
	local var1_44 = arg1_44:getBody()

	if var0_44 == ActivityProxy.ACTIVITY_ADDED or var0_44 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_44.id == arg0_44.contextData.ptActId then
			if arg0_44.contextData.ptData then
				arg0_44.contextData.ptData:Update(var1_44)
			else
				arg0_44.contextData.ptData = ActivityBossPtData.New(var1_44)
			end

			arg0_44:UpdateView()
		elseif var1_44.id == arg0_44.contextData.activityID then
			arg0_44:UpdateActivityData(var1_44)
			arg0_44:UpdateView()
		end
	elseif var0_44 == PlayerProxy.UPDATED then
		arg0_44:RequestAndUpdateView()
	elseif var0_44 == GAME.BEGIN_STAGE_DONE then
		arg0_44.contextData.editFleet = nil

		if not getProxy(ContextProxy):getContextByMediator(PreCombatMediator) then
			arg0_44:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_44)
		end
	elseif var0_44 == GAME.ACT_BOSS_EXCHANGE_TICKET_DONE then
		if arg0_44.contextData.ready2battleCb then
			arg0_44.contextData.ready2battleCb()

			arg0_44.contextData.ready2battleCb = nil
		end
	elseif var0_44 == GAME.GET_POWERRANK_DONE then
		if var1_44.type == PowerRank.TYPE_ACT_BOSS_BATTLE then
			arg0_44:UpdateRankData(var1_44.list)
		end
	elseif var0_44 == GAME.ACT_NEW_PT_DONE then
		arg0_44.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_44.awards)
	elseif var0_44 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		local var2_44 = getProxy(FleetProxy):getActivityFleets()[var1_44.actId]

		arg0_44.contextData.actFleets = var2_44

		arg0_44.viewComponent:updateEditPanel()
		arg0_44.viewComponent:updateCommanderFleet(var2_44[var1_44.fleetId])
	elseif var0_44 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var3_44 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_44.viewComponent:setCommanderPrefabs(var3_44)
		arg0_44.viewComponent:updateCommanderPrefab()
	elseif var0_44 == ActivityBossBuffSelectMediator.ON_START then
		arg0_44.viewComponent:ShowSPFleet()
	end
end

function var0_0.RequestAndUpdateView(arg0_45)
	arg0_45:sendNotification(GAME.ACTIVITY_BOSS_PAGE_UPDATE, {
		activity_id = arg0_45.contextData.activityID
	})
end

function var0_0.UpdateView(arg0_46)
	arg0_46.viewComponent:UpdateView()
end

function var0_0.UpdateRankData(arg0_47, arg1_47)
	arg0_47.viewComponent:UpdateRank(arg1_47)
end

function var0_0.UpdateActivityData(arg0_48, arg1_48)
	arg0_48.contextData.activity = arg1_48
	arg0_48.contextData.bossHP = arg1_48:GetBossHP()
	arg0_48.contextData.mileStones = arg1_48:GetMileStones()
	arg0_48.contextData.stageTickets = arg1_48:GetTickets()
end

function var0_0.getDockCallbackFuncs4ActicityFleet(arg0_49, arg1_49, arg2_49)
	local var0_49 = getProxy(BayProxy)
	local var1_49 = getProxy(FleetProxy)
	local var2_49 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)
	local var3_49 = var1_49:getActivityFleets()[var2_49.id][arg1_49]

	local function var4_49(arg0_50, arg1_50)
		local var0_50, var1_50 = ShipStatus.ShipStatusCheck("inActivity", arg0_50, arg1_50, {
			inActivity = var2_49.id
		})

		if not var0_50 then
			return var0_50, var1_50
		end

		if arg0_49 and arg0_49:isSameKind(arg0_50) then
			return true
		end

		for iter0_50, iter1_50 in ipairs(var3_49.ships) do
			if arg0_50:isSameKind(var0_49:getShipById(iter1_50)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var5_49(arg0_51, arg1_51, arg2_51)
		arg1_51()
	end

	local function var6_49(arg0_52)
		if arg0_49 then
			var3_49:removeShip(arg0_49)
		end

		if #arg0_52 > 0 then
			local var0_52 = var0_49:getShipById(arg0_52[1])

			if not var3_49:containShip(var0_52) then
				var3_49:insertShip(var0_52, nil, arg2_49)
			elseif arg0_49 then
				var3_49:insertShip(arg0_49, nil, arg2_49)
			end

			var3_49:RemoveUnusedItems()
		end

		var1_49:updateActivityFleet(var2_49.id, arg1_49, var3_49)
	end

	return var4_49, var5_49, var6_49
end

return var0_0
