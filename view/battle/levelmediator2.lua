local var0_0 = class("LevelMediator2", import("..base.ContextMediator"))

var0_0.ON_TRACKING = "LevelMediator2:ON_TRACKING"
var0_0.ON_ELITE_TRACKING = "LevelMediator2:ON_ELITE_TRACKING"
var0_0.ON_RETRACKING = "LevelMediator2:ON_RETRACKING"
var0_0.ON_UPDATE_CUSTOM_FLEET = "LevelMediator2:ON_UPDATE_CUSTOM_FLEET"
var0_0.ON_OP = "LevelMediator2:ON_OP"
var0_0.ON_RESUME_SUBSTATE = "LevelMediator2:ON_RESUME_SUBSTATE"
var0_0.ON_STAGE = "LevelMediator2:ON_STAGE"
var0_0.ON_GO_TO_TASK_SCENE = "LevelMediator2:ON_GO_TO_TASK_SCENE"
var0_0.ON_OPEN_EVENT_SCENE = "LevelMediator2:ON_OPEN_EVENT_SCENE"
var0_0.ON_DAILY_LEVEL = "LevelMediator2:ON_DAILY_LEVEL"
var0_0.ON_OPEN_MILITARYEXERCISE = "LevelMediator2:ON_OPEN_MILLITARYEXERCISE"
var0_0.ON_OVERRIDE_CHAPTER = "LevelMediator2:ON_OVERRIDE_CHAPTER"
var0_0.ON_TIME_UP = "LevelMediator2:ON_TIME_UP"
var0_0.UPDATE_EVENT_LIST = "LevelMediator2:UPDATE_EVENT_LIST"
var0_0.ON_START = "ON_START"
var0_0.ON_ENTER_MAINLEVEL = "LevelMediator2:ON_ENTER_MAINLEVEL"
var0_0.ON_DIDENTER = "LevelMediator2:ON_DIDENTER"
var0_0.ON_PERFORM_COMBAT = "LevelMediator2.ON_PERFORM_COMBAT"
var0_0.ON_SUPPORT_SUBMARINE = "LevelMediator2.ON_SUPPORT_SUBMARINE"
var0_0.ON_ELITE_OEPN_DECK = "LevelMediator2:ON_ELITE_OEPN_DECK"
var0_0.ON_ELITE_CLEAR = "LevelMediator2:ON_ELITE_CLEAR"
var0_0.ON_ELITE_RECOMMEND = "LevelMediator2:ON_ELITE_RECOMMEND"
var0_0.ON_ELITE_ADJUSTMENT = "LevelMediator2:ON_ELITE_ADJUSTMENT"
var0_0.ON_SUPPORT_OPEN_DECK = "LevelMediator2:ON_SUPPORT_OPEN_DECK"
var0_0.ON_ACTIVITY_MAP = "LevelMediator2:ON_ACTIVITY_MAP"
var0_0.GO_ACT_SHOP = "LevelMediator2:GO_ACT_SHOP"
var0_0.ON_SWITCH_NORMAL_MAP = "LevelMediator2:ON_SWITCH_NORMAL_MAP"
var0_0.NOTICE_AUTOBOT_ENABLED = "LevelMediator2:NOTICE_AUTOBOT_ENABLED"
var0_0.ON_EXTRA_RANK = "LevelMediator2:ON_EXTRA_RANK"
var0_0.ON_STRATEGYING_CHAPTER = "LevelMediator2:ON_STRATEGYING_CHAPTER"
var0_0.ON_SELECT_COMMANDER = "LevelMediator2:ON_SELECT_COMMANDER"
var0_0.ON_SELECT_ELITE_COMMANDER = "LevelMediator2:ON_SELECT_ELITE_COMMANDER"
var0_0.ON_COMMANDER_SKILL = "LevelMediator2:ON_COMMANDER_SKILL"
var0_0.ON_SHIP_DETAIL = "LevelMediator2:ON_SHIP_DETAIL"
var0_0.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN = "LevelMediator2:ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN"
var0_0.GET_REMASTER_TICKETS_DONE = "LevelMediator2:GET_REMASTER_TICKETS_DONE"
var0_0.ON_FLEET_SHIPINFO = "LevelMediator2:ON_FLEET_SHIPINFO"
var0_0.ON_STAGE_SHIPINFO = "LevelMediator2:ON_STAGE_SHIPINFO"
var0_0.ON_SUPPORT_SHIPINFO = "LevelMediator2:ON_SUPPORT_SHIPINFO"
var0_0.ON_COMMANDER_OP = "LevelMediator2:ON_COMMANDER_OP"
var0_0.CLICK_CHALLENGE_BTN = "LevelMediator2:CLICK_CHALLENGE_BTN"
var0_0.ON_SUBMIT_TASK = "LevelMediator2:ON_SUBMIT_TASK"
var0_0.ON_VOTE_BOOK = "LevelMediator2:ON_VOTE_BOOK"
var0_0.GET_CHAPTER_DROP_SHIP_LIST = "LevelMediator2:GET_CHAPTER_DROP_SHIP_LIST"
var0_0.ON_CHAPTER_REMASTER_AWARD = "LevelMediator2:ON_CHAPTER_REMASTER_AWARD"
var0_0.ON_BOSSRUSH_REMASTER_ACTIVITY = "LevelMediator2:ON_BOSSRUSH_REMASTER_ACTIVITY"
var0_0.ENTER_WORLD = "LevelMediator2:ENTER_WORLD"
var0_0.ON_OPEN_ACT_BOSS_BATTLE = "LevelMediator2:ON_OPEN_ACT_BOSS_BATTLE"
var0_0.ON_BOSSRUSH_MAP = "LevelMediator2:ON_BOSSRUSH_MAP"
var0_0.SHOW_ATELIER_BUFF = "LevelMediator2:SHOW_ATELIER_BUFF"
var0_0.ON_SPITEM_CHANGED = "LevelMediator2:ON_SPITEM_CHANGED"
var0_0.ON_BOSSSINGLE_MAP = "LevelMediator2:ON_BOSSSINGLE_MAP"
var0_0.ON_CLUE_MAP = "LevelMediator2:ON_CLUE_MAP"
var0_0.ON_COLLAB_BOSSRUSH_MAP = "LevelMediator2:ON_COLLAB_BOSSRUSH_MAP"
var0_0.ON_UPDATE_LOWPRIORITY_TASK = "LevelMediator2:ON_UPDATE_LOWPRIORITY_TASK"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy)

	arg0_1:bind(var0_0.GET_CHAPTER_DROP_SHIP_LIST, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = arg1_2,
			callback = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_VOTE_BOOK, function(arg0_3, arg1_3)
		return
	end)
	arg0_1:bind(var0_0.ON_COMMANDER_OP, function(arg0_4, arg1_4, arg2_4)
		arg0_1.contextData.commanderOPChapter = arg2_4

		arg0_1:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_COMMANDER, function(arg0_5, arg1_5, arg2_5, arg3_5)
		FormationMediator.onSelectCommander(arg1_5, arg2_5)

		arg0_1.contextData.selectedChapterVO = arg3_5
	end)
	arg0_1:bind(var0_0.ON_SELECT_ELITE_COMMANDER, function(arg0_6, arg1_6, arg2_6, arg3_6)
		local var0_6 = getProxy(ChapterProxy)
		local var1_6 = arg3_6.id

		arg0_1.contextData.editEliteChapter = var1_6

		local var2_6 = arg3_6:getEliteFleetCommanders()[arg1_6] or {}
		local var3_6

		if var2_6[arg2_6] then
			local var4_6 = getProxy(CommanderProxy):getCommanderById(var2_6[arg2_6])
		end

		local var5_6

		if var2_6[arg2_6] then
			var5_6 = getProxy(CommanderProxy):getCommanderById(var2_6[arg2_6])
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var5_6,
			ignoredIds = {},
			fleetType = CommanderCatScene.FLEET_TYPE_HARD_CHAPTER,
			chapterId = var1_6,
			onCommander = function(arg0_7)
				return true
			end,
			onSelected = function(arg0_8, arg1_8)
				local var0_8 = arg0_8[1]

				arg0_1:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = var1_6,
					index = arg1_6,
					pos = arg2_6,
					commanderId = var0_8,
					callback = function()
						arg1_8()
					end
				})
			end,
			onQuit = function(arg0_10)
				arg0_1:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					commanderId = 0,
					chapterId = var1_6,
					index = arg1_6,
					pos = arg2_6,
					callback = function()
						arg0_10()
					end
				})
			end
		})
	end)
	arg0_1:RegisterTrackEvent()
	arg0_1:bind(var0_0.ON_UPDATE_CUSTOM_FLEET, function(arg0_12, arg1_12)
		arg0_1:sendNotification(GAME.UPDATE_CUSTOM_FLEET, {
			chapterId = arg1_12.id
		})
	end)
	arg0_1:bind(var0_0.ON_OP, function(arg0_13, arg1_13)
		arg0_1:sendNotification(GAME.CHAPTER_OP, arg1_13)
	end)
	arg0_1:bind(var0_0.ON_SWITCH_NORMAL_MAP, function(arg0_14)
		local var0_14 = getProxy(ChapterProxy):GetLastNormalMap()

		if var0_14 then
			arg0_1.viewComponent:setMap(var0_14)
		end
	end)
	arg0_1:bind(var0_0.ON_RESUME_SUBSTATE, function(arg0_15, arg1_15)
		arg0_1:loadSubState(arg1_15)
	end)
	arg0_1:bind(var0_0.ON_STAGE, function(arg0_16)
		arg0_1:addSubLayers(Context.New({
			mediator = ChapterPreCombatMediator,
			viewComponent = ChapterPreCombatLayer
		}), false)
	end)
	arg0_1:bind(var0_0.ON_OPEN_MILITARYEXERCISE, function()
		if getProxy(ActivityProxy):getMilitaryExerciseActivity() then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.MILITARYEXERCISE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
		end
	end)
	arg0_1:bind(var0_0.CLICK_CHALLENGE_BTN, function(arg0_18)
		if LOCK_LIMIT_CHALLENGE then
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CHALLENGE_MAIN_SCENE)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LIMIT_CHALLENGE)
		end
	end)
	arg0_1:bind(var0_0.ON_DAILY_LEVEL, function(arg0_19)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
	end)
	arg0_1:bind(var0_0.ON_GO_TO_TASK_SCENE, function(arg0_20, arg1_20)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TASK, arg1_20)
	end)
	arg0_1:bind(var0_0.ON_OPEN_EVENT_SCENE, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	arg0_1:bind(var0_0.ON_OVERRIDE_CHAPTER, function()
		local var0_22 = arg0_1.contextData.chapterVO

		getProxy(ChapterProxy):updateChapter(var0_22)
	end)
	arg0_1:bind(var0_0.ON_TIME_UP, function()
		arg0_1:onTimeUp()
	end)
	arg0_1:bind(var0_0.UPDATE_EVENT_LIST, function()
		arg0_1.viewComponent:addbubbleMsgBox(function(arg0_25)
			arg0_1:OnEventUpdate(arg0_25)
		end)

		local var0_24 = getProxy(ChapterProxy):getActiveChapter(true)

		if var0_24 and var0_24:IsAutoFight() then
			local var1_24 = pg.GuildMsgBoxMgr.GetInstance()

			if var1_24:GetShouldShowBattleTip() then
				local var2_24 = getProxy(GuildProxy):getRawData()
				local var3_24 = var2_24 and var2_24:getWeeklyTask()

				if var3_24 and var3_24.id ~= 0 then
					getProxy(ChapterProxy):AddExtendChapterDataTable(var0_24.id, "ListGuildEventNotify", var3_24:GetPresonTaskId(), var3_24:GetPrivateTaskName())
					pg.GuildMsgBoxMgr.GetInstance():CancelShouldShowBattleTip()
				end

				var1_24:SubmitTask(function(arg0_26, arg1_26, arg2_26)
					if arg0_26 then
						local var0_26 = pg.task_data_template[arg2_26].desc

						getProxy(ChapterProxy):AddExtendChapterDataTable(var0_24.id, "ListGuildEventAutoReceiveNotify", arg2_26, var0_26)
					end
				end)
			end
		else
			arg0_1.viewComponent:addbubbleMsgBox(function(arg0_27)
				pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0_27)
			end)
		end
	end)
	arg0_1:bind(var0_0.ON_ELITE_CLEAR, function(arg0_28, arg1_28)
		local var0_28 = arg1_28.index
		local var1_28 = arg1_28.chapterVO

		var1_28:clearEliterFleetByIndex(var0_28)

		local var2_28 = getProxy(ChapterProxy)

		var2_28:updateChapter(var1_28)
		var2_28:duplicateEliteFleet(var1_28)
		arg0_1.viewComponent:RefreshFleetSelectView(var1_28)
	end)
	arg0_1:bind(var0_0.NOTICE_AUTOBOT_ENABLED, function(arg0_29, arg1_29)
		arg0_1:sendNotification(GAME.COMMON_FLAG, {
			flagID = BATTLE_AUTO_ENABLED
		})
	end)
	arg0_1:bind(var0_0.ON_ELITE_RECOMMEND, function(arg0_30, arg1_30)
		local var0_30 = arg1_30.index
		local var1_30 = arg1_30.chapterVO
		local var2_30 = getProxy(ChapterProxy)

		var2_30:eliteFleetRecommend(var1_30, var0_30)
		var2_30:updateChapter(var1_30)
		var2_30:duplicateEliteFleet(var1_30)
		arg0_1.viewComponent:RefreshFleetSelectView(var1_30)
	end)
	arg0_1:bind(var0_0.ON_ELITE_ADJUSTMENT, function(arg0_31, arg1_31)
		local var0_31 = getProxy(ChapterProxy)

		var0_31:updateChapter(arg1_31)
		var0_31:duplicateEliteFleet(arg1_31)
	end)
	arg0_1:bind(var0_0.ON_ELITE_OEPN_DECK, function(arg0_32, arg1_32)
		local var0_32 = arg1_32.shipType
		local var1_32 = arg1_32.fleetIndex
		local var2_32 = arg1_32.shipVO
		local var3_32 = arg1_32.fleet
		local var4_32 = arg1_32.chapter
		local var5_32 = arg1_32.teamType
		local var6_32 = getProxy(BayProxy):getRawData()
		local var7_32 = {}

		for iter0_32, iter1_32 in pairs(var6_32) do
			if not ShipType.ContainInLimitBundle(var0_32, iter1_32:getShipType()) then
				table.insert(var7_32, iter0_32)
			end
		end

		arg0_1.contextData.editEliteChapter = var4_32.id

		local var8_32 = {}

		for iter2_32, iter3_32 in pairs(var3_32) do
			table.insert(var8_32, iter2_32.id)
		end

		local var9_32, var10_32, var11_32 = arg0_1:getDockCallbackFuncs(var3_32, var2_32, var4_32, var1_32)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			ignoredIds = var7_32,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var2_32 ~= nil,
			teamFilter = var5_32,
			leftTopInfo = i18n("word_formation"),
			onShip = var9_32,
			confirmSelect = var10_32,
			onSelected = var11_32,
			hideTagFlags = setmetatable({
				inElite = var4_32:getConfig("formation")
			}, {
				__index = ShipStatus.TAG_HIDE_LEVEL
			}),
			otherSelectedIds = var8_32
		})
	end)
	arg0_1:bind(var0_0.ON_SUPPORT_OPEN_DECK, function(arg0_33, arg1_33)
		local var0_33 = arg1_33.shipType
		local var1_33 = arg1_33.shipVO
		local var2_33 = arg1_33.fleet
		local var3_33 = arg1_33.chapter
		local var4_33 = arg1_33.teamType
		local var5_33 = getProxy(BayProxy):getRawData()
		local var6_33 = {}

		for iter0_33, iter1_33 in pairs(var5_33) do
			if not ShipType.ContainInLimitBundle(var0_33, iter1_33:getShipType()) then
				table.insert(var6_33, iter0_33)
			end
		end

		local var7_33 = {}

		for iter2_33, iter3_33 in pairs(var2_33) do
			table.insert(var7_33, iter2_33.id)
		end

		local var8_33, var9_33, var10_33 = arg0_1:getSupportDockCallbackFuncs(var2_33, var1_33, var3_33)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			ignoredIds = var6_33,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1_33 ~= nil,
			teamFilter = var4_33,
			leftTopInfo = i18n("word_formation"),
			onShip = var8_33,
			confirmSelect = var9_33,
			onSelected = var10_33,
			hideTagFlags = setmetatable({
				inSupport = var3_33:getConfig("formation")
			}, {
				__index = ShipStatus.TAG_HIDE_SUPPORT
			}),
			otherSelectedIds = var7_33
		})

		arg0_1.contextData.selectedChapterVO = var3_33
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_MAP, function(arg0_34, arg1_34)
		local var0_34 = getProxy(ChapterProxy)
		local var1_34, var2_34 = var0_34:getLastMapForActivity(arg1_34)

		if not var1_34 or not var0_34:getMapById(var1_34):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1.viewComponent:ShowSelectedMap(var1_34, function()
			if var2_34 then
				local var0_35 = var0_34:getChapterById(var2_34)

				arg0_1.viewComponent:switchToChapter(var0_35)
			end
		end)
	end)
	arg0_1:bind(var0_0.ON_BOSSRUSH_MAP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
	end)
	arg0_1:bind(var0_0.ON_BOSSSINGLE_MAP, function(arg0_37, arg1_37)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP, arg1_37)
	end)
	arg0_1:bind(var0_0.ON_CLUE_MAP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CLUE_MAP)
	end)
	arg0_1:bind(var0_0.ON_COLLAB_BOSSRUSH_MAP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)
	end)
	arg0_1:bind(var0_0.GO_ACT_SHOP, function()
		local var0_40 = arg0_1.contextData.map and arg0_1.contextData.map:getConfig("on_activity") or nil
		local var1_40 = var0_40 and var0_40 ~= 0 and getProxy(ActivityProxy):getActivityById(var0_40)
		local var2_40 = var1_40 and not var1_40:isEnd() and var1_40:GetConfigClientSetting("PTID")
		local var3_40 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		if var3_40 and var3_40:getConfig("config_client").resId == var2_40 and not var3_40:isEnd() then
			arg0_1:addSubLayers(Context.New({
				mediator = LotteryMediator,
				viewComponent = LotteryLayer,
				data = {
					activityId = var3_40.id
				}
			}), false)
		else
			local var4_40 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_41)
				return arg0_41:getConfig("config_client").pt_id == var2_40
			end)
			local var5_40 = var4_40 and var4_40.id

			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = var5_40
			})
		end
	end)
	arg0_1:bind(var0_0.SHOW_ATELIER_BUFF, function(arg0_42, arg1_42)
		if arg1_42 then
			arg0_1:addSubLayers(Context.New({
				mediator = AterialYumiaCoreBuffMediator,
				viewComponent = AterialYumiaCoreBuffLayer
			}))
		else
			arg0_1:addSubLayers(Context.New({
				mediator = AtelierBuffMediator,
				viewComponent = AtelierBuffLayer
			}))
		end
	end)
	arg0_1:bind(var0_0.ON_SHIP_DETAIL, function(arg0_43, arg1_43)
		arg0_1.contextData.selectedChapterVO = arg1_43.chapter

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_43.id
		})
	end)
	arg0_1:bind(var0_0.ON_FLEET_SHIPINFO, function(arg0_44, arg1_44)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_44.shipId,
			shipVOs = arg1_44.shipVOs
		})

		arg0_1.contextData.editEliteChapter = arg1_44.chapter.id
	end)
	arg0_1:bind(var0_0.ON_SUPPORT_SHIPINFO, function(arg0_45, arg1_45)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_45.shipId,
			shipVOs = arg1_45.shipVOs
		})

		arg0_1.contextData.selectedChapterVO = arg1_45.chapter
	end)
	arg0_1:bind(var0_0.ON_STAGE_SHIPINFO, function(arg0_46, arg1_46)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_46.shipId,
			shipVOs = arg1_46.shipVOs
		})
	end)
	arg0_1:bind(var0_0.ON_EXTRA_RANK, function(arg0_47)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_EXTRA_CHAPTER
		})
	end)
	arg0_1:bind(var0_0.ON_STRATEGYING_CHAPTER, function(arg0_48)
		local var0_48 = getProxy(ChapterProxy)
		local var1_48 = var0_48:getActiveChapter()

		assert(var1_48)

		local var2_48 = var0_48:getMapById(var1_48:getConfig("map"))

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_forward",
			content = i18n("levelScene_chapter_is_activation", string.split(var2_48:getConfig("name"), "|")[1] .. ":" .. var1_48:getConfig("chapter_name")),
			onYes = function()
				arg0_1.viewComponent:switchToChapter(var1_48)
			end,
			onNo = function()
				arg0_1.contextData.chapterVO = var1_48

				arg0_1.viewComponent:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpRetreat,
					exittype = ChapterConst.ExitFromMap
				})
			end,
			onClose = function()
				return
			end,
			noBtnType = pg.MsgboxMgr.BUTTON_RETREAT
		})
	end)
	arg0_1:bind(var0_0.ON_COMMANDER_SKILL, function(arg0_52, arg1_52)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_52
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_PERFORM_COMBAT, function(arg0_53, arg1_53, arg2_53, arg3_53)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_53,
			exitCallback = arg2_53,
			memory = arg3_53
		})
	end)
	arg0_1:bind(var0_0.ON_SUPPORT_SUBMARINE, function(arg0_54)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SCENARIO_SUB_STRIKE
		})
	end)
	arg0_1:bind(var0_0.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN, function(arg0_55)
		arg0_1:sendNotification(GAME.GET_REMASTER_TICKETS)
	end)
	arg0_1:bind(var0_0.ON_BOSSRUSH_REMASTER_ACTIVITY, function(arg0_56, arg1_56)
		arg0_1.bossRushRemasterActivityId = arg1_56

		arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_START, {
			activity_id = arg1_56
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_57, arg1_57)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_57)
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_58)
		local var0_58 = getProxy(ChapterProxy):getActiveChapter()

		assert(var0_58)

		local var1_58 = var0_58.fleet
		local var2_58 = var0_58:getStageId(var1_58.line.row, var1_58.line.column)

		seriesAsync({
			function(arg0_59)
				local var0_59 = {}

				for iter0_59, iter1_59 in pairs(var1_58.ships) do
					table.insert(var0_59, iter1_59)
				end

				Fleet.EnergyCheck(var0_59, var1_58.name, function(arg0_60)
					if arg0_60 then
						arg0_59()
					end
				end, function(arg0_61)
					if not arg0_61 then
						getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.SHIP_ENERGY_LOW)
					end
				end)
			end,
			function(arg0_62)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0_62 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.GOLD_MAX)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0_62,
						onYes = arg0_62
					})
				else
					arg0_62()
				end
			end,
			function(arg0_63)
				arg0_1:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_SCENARIO,
					stageId = var2_58
				})
			end
		})
	end)
	arg0_1:bind(arg0_1.ON_ENTER_MAINLEVEL, function(arg0_64, arg1_64)
		arg0_1:DidEnterLevelMainUI(arg1_64)
	end)
	arg0_1:bind(arg0_1.ON_DIDENTER, function(arg0_65)
		arg0_1.viewComponent:emit(LevelMediator2.UPDATE_EVENT_LIST)
	end)
	arg0_1:bind(var0_0.ENTER_WORLD, function(arg0_66)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
	end)
	arg0_1:bind(var0_0.ON_CHAPTER_REMASTER_AWARD, function(arg0_67, arg1_67, arg2_67, arg3_67)
		arg0_1:sendNotification(GAME.CHAPTER_REMASTER_AWARD_RECEIVE, {
			chapterId = arg1_67,
			pos = arg2_67,
			actId = arg3_67
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_ACT_BOSS_BATTLE, function(arg0_68)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACT_BOSS_BATTLE, {
			showAni = true
		})
	end)
	arg0_1:bind(LevelUIConst.OPEN_NORMAL_CONTINUOUS_WINDOW, function(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
		local var0_69 = _.map(arg2_69, function(arg0_70)
			local var0_70 = getProxy(FleetProxy):getFleetById(arg0_70)

			if not var0_70 or var0_70:getFleetType() == FleetType.Submarine then
				return
			end

			return var0_70
		end)

		arg0_1:DisplayContinuousWindow(arg1_69, var0_69, arg3_69, arg4_69)
	end)
	arg0_1:bind(LevelUIConst.OPEN_ELITE_CONTINUOUS_WINDOW, function(arg0_71, arg1_71, arg2_71, arg3_71)
		local var0_71 = arg1_71:getEliteFleetList()
		local var1_71 = getProxy(BayProxy):getRawData()
		local var2_71 = _.map(var0_71, function(arg0_72)
			if #arg0_72 == 0 or _.any(arg0_72, function(arg0_73)
				local var0_73 = var1_71[arg0_73]

				return var0_73 and var0_73:getTeamType() == TeamType.Submarine
			end) then
				return
			end

			return TypedFleet.New({
				fleetType = FleetType.Normal,
				ship_list = arg0_72
			})
		end)

		arg0_1:DisplayContinuousWindow(arg1_71, var2_71, arg2_71, arg3_71)
	end)
	arg0_1:bind(var0_0.ON_UPDATE_LOWPRIORITY_TASK, function(arg0_74, arg1_74, arg2_74)
		arg0_1:sendNotification(GAME.UPDATE_LOW_PRIORITY_TASK_PROGRESS, {
			taskId = arg1_74
		})
	end)

	arg0_1.player = var0_1:getData()

	arg0_1.viewComponent:updateRes(arg0_1.player)

	local var1_1 = getProxy(EventProxy)

	arg0_1.viewComponent:updateEvent(var1_1)

	local var2_1 = getProxy(FleetProxy):GetRegularFleets()

	arg0_1.viewComponent:updateFleet(var2_1)

	local var3_1 = getProxy(BayProxy)

	arg0_1.viewComponent:setShips(var3_1:getRawData())

	local var4_1 = getProxy(ActivityProxy)

	arg0_1.viewComponent:updateVoteBookBtn()

	local var5_1 = getProxy(CommanderProxy):getPrefabFleet()

	arg0_1.viewComponent:setCommanderPrefabs(var5_1)

	local var6_1 = getProxy(DailyLevelProxy)

	arg0_1.viewComponent:setEliteQuota(var6_1.eliteCount, pg.gameset.elite_quota.key_value)
	getProxy(ChapterProxy):updateActiveChapterShips()

	local var7_1 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)

	arg0_1.viewComponent:setSpecialOperationTickets(var7_1)
end

function var0_0.DidEnterLevelMainUI(arg0_75, arg1_75)
	arg0_75.viewComponent:setMap(arg1_75)

	if arg0_75.contextData.openChapterId then
		local var0_75 = arg0_75.contextData.openChapterId

		arg0_75.viewComponent.mapBuilder:ActionInvoke("TryOpenChapter", var0_75)

		arg0_75.contextData.openChapterId = nil
	end

	local var1_75 = arg0_75.contextData.chapterVO

	if var1_75 and var1_75.active then
		arg0_75.viewComponent:switchToChapter(var1_75)
	elseif arg0_75.contextData.map:isSkirmish() then
		arg0_75.viewComponent:ShowCurtains(true)
		arg0_75.viewComponent:doPlayAnim("TV01", function(arg0_76)
			go(arg0_76):SetActive(false)
			arg0_75.viewComponent:ShowCurtains(false)
		end)
	end

	if arg0_75.contextData.preparedTaskList and #arg0_75.contextData.preparedTaskList > 0 then
		for iter0_75, iter1_75 in ipairs(arg0_75.contextData.preparedTaskList) do
			arg0_75:sendNotification(GAME.SUBMIT_TASK, iter1_75)
		end

		table.clean(arg0_75.contextData.preparedTaskList)
	end

	if arg0_75.contextData.StopAutoFightFlag then
		local var2_75 = getProxy(ChapterProxy)
		local var3_75 = var2_75:getActiveChapter()

		if var3_75 then
			var2_75:SetChapterAutoFlag(var3_75.id, false)

			local var4_75 = bit.bor(ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

			arg0_75.viewComponent:updateChapterVO(var3_75, var4_75)
		end

		arg0_75.contextData.StopAutoFightFlag = nil
	end

	arg0_75:TryEnterPendingChapter()
end

function var0_0.TryEnterPendingChapter(arg0_77)
	local var0_77 = arg0_77.contextData.pendingEnterChapterId

	if not var0_77 then
		return
	end

	if not arg0_77.contextData.map or not arg0_77.viewComponent.mapBuilder then
		return
	end

	if arg0_77.contextData.chapterVO and arg0_77.contextData.chapterVO.id == var0_77 then
		arg0_77.contextData.pendingEnterChapterId = nil

		return
	end

	local var1_77 = getProxy(ChapterProxy):getChapterById(var0_77)

	if not var1_77 or not var1_77.active then
		return
	end

	arg0_77.contextData.pendingEnterChapterId = nil
	arg0_77.waitingTracking = nil

	arg0_77.viewComponent:resetLevelGrid()

	arg0_77.viewComponent.FirstEnterChapter = var1_77.id

	arg0_77.viewComponent:switchToChapter(var1_77)
end

function var0_0.RegisterTrackEvent(arg0_78)
	arg0_78:bind(var0_0.ON_TRACKING, function(arg0_79, arg1_79, arg2_79, arg3_79, arg4_79, arg5_79)
		local var0_79 = getProxy(ChapterProxy):getChapterById(arg1_79, true)
		local var1_79 = getProxy(ChapterProxy):GetLastFleetIndex()

		arg0_78:sendNotification(GAME.TRACKING, {
			chapterId = arg1_79,
			fleetIds = var1_79,
			loopFlag = arg2_79,
			operationItem = arg3_79,
			duties = arg4_79,
			autoFightFlag = arg5_79
		})
	end)
	arg0_78:bind(var0_0.ON_ELITE_TRACKING, function(arg0_80, arg1_80, arg2_80, arg3_80, arg4_80, arg5_80)
		arg0_78:sendNotification(GAME.TRACKING, {
			chapterId = arg1_80,
			loopFlag = arg2_80,
			operationItem = arg3_80,
			duties = arg4_80,
			autoFightFlag = arg5_80
		})
	end)
	arg0_78:bind(var0_0.ON_RETRACKING, function(arg0_81, arg1_81, arg2_81)
		local var0_81 = arg1_81.duties
		local var1_81 = arg1_81:getConfig("type") == Chapter.CustomFleet
		local var2_81 = arg1_81:GetActiveSPItemID()

		if var1_81 then
			arg0_78.viewComponent:emit(LevelMediator2.ON_ELITE_TRACKING, arg1_81.id, arg1_81.loopFlag, var2_81, var0_81, arg2_81)
		else
			arg0_78.viewComponent:emit(LevelMediator2.ON_TRACKING, arg1_81.id, arg1_81.loopFlag, var2_81, var0_81, arg2_81)
		end
	end)
end

function var0_0.NoticeVoteBook(arg0_82, arg1_82)
	arg1_82()
end

function var0_0.TryPlaySubGuide(arg0_83)
	arg0_83.viewComponent:tryPlaySubGuide()
end

function var0_0.listNotificationInterests(arg0_84)
	return {
		ChapterProxy.CHAPTER_UPDATED,
		ChapterProxy.CHAPTER_TIMESUP,
		PlayerProxy.UPDATED,
		DailyLevelProxy.ELITE_QUOTA_UPDATE,
		var0_0.ON_TRACKING,
		var0_0.ON_ELITE_TRACKING,
		var0_0.ON_RETRACKING,
		GAME.TRACKING_DONE,
		GAME.TRACKING_ERROR,
		GAME.CHAPTER_OP_DONE,
		GAME.EVENT_LIST_UPDATE,
		GAME.BEGIN_STAGE_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUB_CHAPTER_REFRESH_DONE,
		GAME.SUB_CHAPTER_FETCH_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COOMMANDER_EQUIP_TO_FLEET_DONE,
		GAME.COMMANDER_ELIT_FORMATION_OP_DONE,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		LevelUIConst.CONTINUOUS_OPERATION,
		var0_0.ON_SPITEM_CHANGED,
		GAME.GET_REMASTER_TICKETS_DONE,
		GAME.ACTIVITY_PERMANENT_START_DONE,
		VoteProxy.VOTE_ORDER_BOOK_DELETE,
		VoteProxy.VOTE_ORDER_BOOK_UPDATE,
		GAME.VOTE_BOOK_BE_UPDATED_DONE,
		BagProxy.ITEM_UPDATED,
		ChapterProxy.CHAPTER_AUTO_FIGHT_FLAG_UPDATED,
		ChapterProxy.CHAPTER_SKIP_PRECOMBAT_UPDATED,
		ChapterProxy.CHAPTER_REMASTER_INFO_UPDATED,
		GAME.CHAPTER_REMASTER_INFO_REQUEST_DONE,
		GAME.CHAPTER_REMASTER_AWARD_RECEIVE_DONE,
		GAME.STORY_UPDATE_DONE,
		GAME.STORY_END
	}
end

function var0_0.handleNotification(arg0_85, arg1_85)
	local var0_85 = arg1_85:getName()
	local var1_85 = arg1_85:getBody()

	if var0_85 == GAME.BEGIN_STAGE_DONE then
		arg0_85:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_85)
	elseif var0_85 == VoteProxy.VOTE_ORDER_BOOK_DELETE or VoteProxy.VOTE_ORDER_BOOK_UPDATE == var0_85 then
		arg0_85.viewComponent:updateVoteBookBtn()
	elseif var0_85 == PlayerProxy.UPDATED then
		arg0_85.viewComponent:updateRes(var1_85)
	elseif var0_85 == var0_0.ON_TRACKING or var0_85 == var0_0.ON_ELITE_TRACKING or var0_85 == var0_0.ON_RETRACKING then
		arg0_85.viewComponent:emit(var0_85, unpackEx(var1_85))
	elseif var0_85 == GAME.TRACKING_DONE then
		arg0_85.waitingTracking = nil

		if arg0_85.contextData.pendingEnterChapterId == var1_85.id then
			arg0_85.contextData.pendingEnterChapterId = nil
		end

		arg0_85.viewComponent:resetLevelGrid()

		arg0_85.viewComponent.FirstEnterChapter = var1_85.id

		arg0_85.viewComponent:switchToChapter(var1_85)
	elseif var0_85 == ChapterProxy.CHAPTER_UPDATED then
		arg0_85.viewComponent:updateChapterVO(var1_85.chapter, var1_85.dirty)
	elseif var0_85 == GAME.COMMANDER_ELIT_FORMATION_OP_DONE then
		if arg0_85.contextData.commanderOPChapter then
			local var2_85 = getProxy(ChapterProxy):getChapterById(var1_85.chapterId)

			for iter0_85, iter1_85 in pairs(var2_85:getEliteFleetCommanders()) do
				arg0_85.contextData.commanderOPChapter:setEliteFleetByIndex(iter0_85, {
					{
						TeamType.FormCommander,
						{
							pos = 1,
							id = iter1_85[1]
						}
					},
					{
						TeamType.FormCommander,
						{
							pos = 2,
							id = iter1_85[2]
						}
					}
				})
			end

			arg0_85.viewComponent:RefreshFleetSelectView(arg0_85.contextData.commanderOPChapter)
		end
	elseif var0_85 == GAME.CHAPTER_OP_DONE then
		local var3_85

		local function var4_85()
			if var3_85 and coroutine.status(var3_85) == "suspended" then
				local var0_86, var1_86 = coroutine.resume(var3_85)

				assert(var0_86, debug.traceback(var3_85, var1_86))
			end
		end

		var3_85 = coroutine.create(function()
			local var0_87 = var1_85.type
			local var1_87 = arg0_85.contextData.chapterVO
			local var2_87 = var1_87:IsAutoFight()

			if var0_87 == ChapterConst.OpRetreat and not var1_85.id then
				var1_87 = var1_85.finalChapterLevelData

				if var1_85.exittype and var1_85.exittype == ChapterConst.ExitFromMap then
					arg0_85.viewComponent:setChapter(nil)
					arg0_85.viewComponent.mapBuilder:UpdateChapterTF(var1_87.id)
					arg0_85:OnExitChapter(var1_87, var1_85.win, var1_85.extendData)

					return
				end

				if var1_87:existOni() then
					local var3_87 = var1_87:checkOniState()

					if var3_87 then
						arg0_85.viewComponent:displaySpResult(var3_87, var4_85)
						coroutine.yield()
					end
				end

				if var1_87:isPlayingWithBombEnemy() then
					arg0_85.viewComponent:displayBombResult(var4_85)
					coroutine.yield()
				end
			end

			local var4_87 = var1_85.items
			local var5_87

			if var4_87 and #var4_87 > 0 then
				if var0_87 == ChapterConst.OpBox then
					local var6_87 = var1_87.fleet.line
					local var7_87 = var1_87:getChapterCell(var6_87.row, var6_87.column)

					if pg.box_data_template[var7_87.attachmentId].type == ChapterConst.BoxDrop and ChapterConst.IsAtelierMap(arg0_85.contextData.map) then
						local var8_87 = _.filter(var4_87, function(arg0_88)
							return arg0_88.type == DROP_TYPE_RYZA_DROP
						end)

						if #var8_87 > 0 then
							var5_87 = AwardInfoLayer.TITLE.RYZA

							local var9_87 = math.random(#var8_87)
							local var10_87 = AtelierMaterial.New({
								configId = var8_87[var9_87].id
							}):GetVoices()

							if var10_87 and #var10_87 > 0 then
								local var11_87 = var10_87[math.random(#var10_87)]
								local var12_87, var13_87, var14_87 = ShipWordHelper.GetWordAndCV(var11_87[1], var11_87[2], nil, PLATFORM_CODE ~= PLATFORM_US)

								arg0_85.viewComponent:emit(LevelUIConst.ADD_TOAST_QUEUE, {
									iconScale = 0.75,
									Class = LevelStageAtelierMaterialToast,
									title = i18n("ryza_tip_toast_item_got"),
									desc = var14_87,
									voice = var13_87,
									icon = var11_87[3]
								})
							end
						end
					end
				end

				seriesAsync({
					function(arg0_89)
						getProxy(ChapterProxy):AddExtendChapterDataArray(var1_87.id, "TotalDrops", _.filter(var4_87, function(arg0_90)
							return arg0_90.type ~= DROP_TYPE_STRATEGY
						end))
						arg0_85.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
							items = var4_87,
							title = var5_87,
							closeOnCompleted = var2_87,
							removeFunc = arg0_89
						})
					end,
					function(arg0_91)
						if var0_87 == ChapterConst.OpBox and _.any(var4_87, function(arg0_92)
							if arg0_92.type ~= DROP_TYPE_VITEM then
								return false
							end

							return arg0_92:getConfig("virtual_type") == 1
						end) then
							(function()
								local var0_93 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

								if not var0_93 then
									return
								end

								local var1_93 = pg.activity_event_picturepuzzle[var0_93.id]

								if not var1_93 then
									return
								end

								if #table.mergeArray(var0_93.data1_list, var0_93.data2_list, true) < #var1_93.pickup_picturepuzzle + #var1_93.drop_picturepuzzle then
									return
								end

								local var2_93 = var0_93:getConfig("config_client").comStory

								pg.NewStoryMgr.GetInstance():Play(var2_93, arg0_91)
							end)()
						end

						if _.any(var4_87, function(arg0_94)
							if arg0_94.type ~= DROP_TYPE_STRATEGY then
								return false
							end

							return pg.strategy_data_template[arg0_94.id].type == ChapterConst.StgTypeConsume
						end) then
							arg0_85.viewComponent.levelStageView:popStageStrategy()
						end

						arg0_91()
					end
				}, var4_85)
				coroutine.yield()
			end

			assert(var1_87)

			if var0_87 == ChapterConst.OpSkipBattle or var0_87 == ChapterConst.OpPreClear then
				arg0_85.viewComponent.levelStageView:tryAutoAction(function()
					if not arg0_85.viewComponent.levelStageView then
						return
					end

					arg0_85.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_87 == ChapterConst.OpRetreat then
				local var15_87 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

				if var15_87 then
					local var16_87 = {}
					local var17_87 = var15_87:getContextByMediator(ChapterPreCombatMediator)

					if var17_87 then
						table.insert(var16_87, var17_87)
					end

					_.each(var16_87, function(arg0_96)
						arg0_85:sendNotification(GAME.REMOVE_LAYERS, {
							context = arg0_96
						})
					end)
				end

				if var1_85.id then
					return
				end

				local var18_87 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN)

				if var18_87 and not var18_87.autoActionForbidden and not var18_87.achieved and var18_87.data1 == 7 and var1_87.id == 204 and var1_87:isClear() then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						hideNo = true,
						content = "有新的签到奖励可以领取，点击确定前往",
						onYes = function()
							arg0_85:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end,
						onNo = function()
							arg0_85:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end
					})

					return
				end

				arg0_85:OnExitChapter(var1_87, var1_85.win, var1_85.extendData)
			elseif var0_87 == ChapterConst.OpMove then
				seriesAsync({
					function(arg0_99)
						var1_87 = arg0_85.contextData.chapterVO

						local var0_99 = var1_85.fullpath[#var1_85.fullpath]

						var1_87.fleet:SetLine(var0_99)
						getProxy(ChapterProxy):updateChapter(var1_87)
						arg0_85.viewComponent.grid:moveFleet(var1_85.path, var1_85.fullpath, var1_85.oldLine, arg0_99)
					end,
					function(arg0_100)
						if not var1_85.teleportPaths then
							arg0_100()

							return
						end

						local var0_100 = var1_85.teleportPaths[1]
						local var1_100 = var1_85.teleportPaths[2]

						if not var0_100 or not var1_100 then
							arg0_100()

							return
						end

						var1_87 = arg0_85.contextData.chapterVO

						local var2_100 = var1_87:getFleet(FleetType.Normal, var0_100.row, var0_100.column)

						if not var2_100 then
							arg0_100()

							return
						end

						var2_100.line = Clone(var1_85.teleportPaths[2])

						getProxy(ChapterProxy):updateChapter(var1_87)

						local var3_100 = arg0_85:getViewComponent().grid:GetCellFleet(var2_100.id)

						arg0_85:getViewComponent().grid:TeleportCellByPortalWithCameraMove(var2_100, var3_100, var1_85.teleportPaths, arg0_100)
					end,
					function(arg0_101)
						arg0_85:playAIActions(var1_85.aiActs, var1_85.extraFlag, arg0_101)
					end
				}, function()
					var1_87 = arg0_85.contextData.chapterVO

					local var0_102 = var1_87.fleet:getStrategies()

					if _.any(var0_102, function(arg0_103)
						return arg0_103.id == ChapterConst.StrategyExchange and arg0_103.count > 0
					end) then
						arg0_85.viewComponent.levelStageView:popStageStrategy()
					end

					arg0_85.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					arg0_85.viewComponent.levelStageView:updateAmbushRate(var1_87.fleet.line, true)
					arg0_85.viewComponent.levelStageView:updateStageStrategy()
					arg0_85.viewComponent.levelStageView:updateFleetBuff()
					arg0_85.viewComponent.levelStageView:updateBombPanel()
					arg0_85.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_87 == ChapterConst.OpAmbush then
				arg0_85.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_87 == ChapterConst.OpBox then
				arg0_85:playAIActions(var1_85.aiActs, var1_85.extraFlag, function()
					if not arg0_85.viewComponent.levelStageView then
						return
					end

					arg0_85.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_87 == ChapterConst.OpStory then
				arg0_85.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_87 == ChapterConst.OpSwitch then
				arg0_85.viewComponent.grid:adjustCameraFocus()
			elseif var0_87 == ChapterConst.OpEnemyRound then
				arg0_85:playAIActions(var1_85.aiActs, var1_85.extraFlag, function()
					arg0_85.viewComponent.levelStageView:updateBombPanel(true)

					local var0_105 = var1_87.fleet:getStrategies()

					if _.any(var0_105, function(arg0_106)
						return arg0_106.id == ChapterConst.StrategyExchange and arg0_106.count > 0
					end) then
						arg0_85.viewComponent.levelStageView:updateStageStrategy()
						arg0_85.viewComponent.levelStageView:popStageStrategy()
					end

					arg0_85.viewComponent.levelStageView:tryAutoTrigger()
					arg0_85.viewComponent:updatePoisonAreaTip()
				end)
			elseif var0_87 == ChapterConst.OpSubState then
				arg0_85:saveSubState(var1_87.subAutoAttack)
				arg0_85.viewComponent.grid:OnChangeSubAutoAttack()
			elseif var0_87 == ChapterConst.OpStrategy then
				if var1_85.arg1 == ChapterConst.StrategyExchange then
					local var19_87 = var1_87.fleet:findSkills(FleetSkill.TypeStrategy)

					for iter0_87, iter1_87 in ipairs(var19_87) do
						if iter1_87:GetType() == FleetSkill.TypeStrategy and iter1_87:GetArgs()[1] == ChapterConst.StrategyExchange then
							local var20_87 = var1_87.fleet:findCommanderBySkillId(iter1_87.id)

							arg0_85.viewComponent:doPlayCommander(var20_87)

							break
						end
					end
				end

				arg0_85:playAIActions(var1_85.aiActs, var1_85.extraFlag, function()
					arg0_85.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				end)
			elseif var0_87 == ChapterConst.OpSupply then
				arg0_85.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_87 == ChapterConst.OpBarrier then
				arg0_85.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_87 == ChapterConst.OpSubTeleport then
				seriesAsync({
					function(arg0_108)
						local var0_108 = _.detect(var1_87.fleets, function(arg0_109)
							return arg0_109.id == var1_85.id
						end)

						var0_108.line = {
							row = var1_85.arg1,
							column = var1_85.arg2
						}
						var0_108.startPos = {
							row = var1_85.arg1,
							column = var1_85.arg2
						}

						local var1_108 = var1_85.fullpath[1]
						local var2_108 = var1_85.fullpath[#var1_85.fullpath]
						local var3_108 = var1_87:findPath(nil, var1_108, var2_108)
						local var4_108 = pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2]
						local var5_108 = math.ceil(var4_108 * #var0_108:getShips(false) * var3_108 - 1e-05)
						local var6_108 = getProxy(PlayerProxy)
						local var7_108 = var6_108:getData()

						var7_108:consume({
							oil = var5_108
						})
						arg0_85.viewComponent:updateRes(var7_108)
						var6_108:updatePlayer(var7_108)
						arg0_85.viewComponent.grid:moveSub(table.indexof(var1_87.fleets, var0_108), var1_85.fullpath, nil, function()
							local var0_110 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1_87, var0_110)

							var1_87 = arg0_85.contextData.chapterVO

							arg0_108()
						end)
					end,
					function(arg0_111)
						if not var1_85.teleportPaths then
							arg0_111()

							return
						end

						local var0_111 = var1_85.teleportPaths[1]
						local var1_111 = var1_85.teleportPaths[2]

						if not var0_111 or not var1_111 then
							arg0_111()

							return
						end

						local var2_111 = _.detect(var1_87.fleets, function(arg0_112)
							return arg0_112.id == var1_85.id
						end)

						var2_111.startPos = Clone(var1_85.teleportPaths[2])
						var2_111.line = Clone(var1_85.teleportPaths[2])

						local var3_111 = arg0_85:getViewComponent().grid:GetCellFleet(var2_111.id)

						arg0_85:getViewComponent().grid:TeleportFleetByPortal(var3_111, var1_85.teleportPaths, function()
							local var0_113 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1_87, var0_113)

							var1_87 = arg0_85.contextData.chapterVO

							arg0_111()
						end)
					end,
					function(arg0_114)
						arg0_85.viewComponent.levelStageView:SwitchBottomStagePanel(false)
						arg0_85.viewComponent.grid:TurnOffSubTeleport()
						arg0_85.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					end
				})
			end
		end)

		var4_85()
	elseif var0_85 == ChapterProxy.CHAPTER_TIMESUP then
		arg0_85:onTimeUp()
	elseif var0_85 == GAME.EVENT_LIST_UPDATE then
		arg0_85.viewComponent:addbubbleMsgBox(function(arg0_115)
			arg0_85:OnEventUpdate(arg0_115)
		end)
	elseif var0_85 == GAME.VOTE_BOOK_BE_UPDATED_DONE then
		arg0_85.viewComponent:addbubbleMsgBox(function(arg0_116)
			arg0_85:NoticeVoteBook(arg0_116)
		end)
	elseif var0_85 == DailyLevelProxy.ELITE_QUOTA_UPDATE then
		local var5_85 = getProxy(DailyLevelProxy)

		arg0_85.viewComponent:setEliteQuota(var5_85.eliteCount, pg.gameset.elite_quota.key_value)
	elseif var0_85 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_85.viewComponent.mapBuilder:UpdateMapItems()
	elseif var0_85 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_85 and arg0_85.viewComponent.ptActivity and var1_85.id == arg0_85.viewComponent.ptActivity.id then
			arg0_85.viewComponent:updatePtActivity(var1_85)
		end
	elseif var0_85 == GAME.GET_REMASTER_TICKETS_DONE then
		arg0_85.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_85, function()
			arg0_85.viewComponent:updateRemasterTicket()
		end)
	elseif var0_85 == GAME.ACTIVITY_PERMANENT_START_DONE then
		local var6_85 = var1_85 and var1_85.id

		if var6_85 ~= arg0_85.bossRushRemasterActivityId then
			return
		end

		if not getProxy(ActivityPermanentProxy):IsActivityIdByType(var6_85, ActivityPermanentProxy.TYPE_REMASTER_ACTIVITY) then
			return
		end

		arg0_85.bossRushRemasterActivityId = nil

		arg0_85:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_REMASTER, {
			id = var6_85
		})
	elseif var0_85 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var7_85 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_85.viewComponent:setCommanderPrefabs(var7_85)
		arg0_85.viewComponent:updateCommanderPrefab()
	elseif var0_85 == GAME.COOMMANDER_EQUIP_TO_FLEET_DONE then
		local var8_85 = getProxy(FleetProxy):GetRegularFleets()

		arg0_85.viewComponent:updateFleet(var8_85)
		arg0_85.viewComponent:RefreshFleetSelectView()
	elseif var0_85 == GAME.SUBMIT_TASK_DONE then
		if arg0_85.contextData.map and arg0_85.contextData.map:isSkirmish() then
			arg0_85.viewComponent.mapBuilder:UpdateMapItems()
		end

		arg0_85.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_85, function()
			if arg0_85.contextData.map and arg0_85.contextData.map:isSkirmish() and arg0_85.contextData.TaskToSubmit then
				local var0_118 = arg0_85.contextData.TaskToSubmit

				arg0_85.contextData.TaskToSubmit = nil

				arg0_85:sendNotification(GAME.SUBMIT_TASK, var0_118)
			end

			arg0_85.viewComponent.mapBuilder:OnSubmitTaskDone()
		end)
	elseif var0_85 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_85.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_85.awards, function()
			arg0_85.viewComponent.mapBuilder:OnSubmitTaskDone()
		end)
	elseif var0_85 == BagProxy.ITEM_UPDATED then
		local var9_85 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)

		arg0_85.viewComponent:setSpecialOperationTickets(var9_85)
	elseif var0_85 == ChapterProxy.CHAPTER_AUTO_FIGHT_FLAG_UPDATED then
		if not arg0_85:getViewComponent().levelStageView then
			return
		end

		arg0_85:getViewComponent().levelStageView:ActionInvoke("UpdateAutoFightMark")
	elseif var0_85 == ChapterProxy.CHAPTER_SKIP_PRECOMBAT_UPDATED then
		if not arg0_85:getViewComponent().levelStageView then
			return
		end

		arg0_85:getViewComponent().levelStageView:ActionInvoke("UpdateSkipPreCombatMark")
	elseif var0_85 == ChapterProxy.CHAPTER_REMASTER_INFO_UPDATED or var0_85 == GAME.CHAPTER_REMASTER_INFO_REQUEST_DONE then
		arg0_85.viewComponent:updateRemasterInfo()
		arg0_85.viewComponent:updateRemasterBtnTip()
	elseif var0_85 == GAME.CHAPTER_REMASTER_AWARD_RECEIVE_DONE then
		arg0_85.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_85)
	elseif var0_85 == GAME.STORY_UPDATE_DONE then
		arg0_85.cachedStoryAwards = var1_85

		arg0_85.viewComponent.mapBuilder:UpdateView()
	elseif var0_85 == GAME.STORY_END then
		if arg0_85.cachedStoryAwards then
			arg0_85.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_85.cachedStoryAwards.awards)

			arg0_85.cachedStoryAwards = nil
		end
	elseif var0_85 == LevelUIConst.CONTINUOUS_OPERATION then
		arg0_85.viewComponent:emit(LevelUIConst.CONTINUOUS_OPERATION, var1_85)
	elseif var0_85 == GAME.TRACKING_ERROR then
		if arg0_85.waitingTracking then
			arg0_85:DisplayContinuousOperationResult(var1_85.chapter, getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO))
		end

		arg0_85.waitingTracking = nil
	elseif var0_85 == var0_0.ON_SPITEM_CHANGED then
		arg0_85.viewComponent:emit(var0_0.ON_SPITEM_CHANGED, var1_85)
	end
end

function var0_0.OnExitChapter(arg0_120, arg1_120, arg2_120, arg3_120)
	assert(arg1_120)
	seriesAsync({
		function(arg0_121)
			if not arg0_120.contextData.chapterVO then
				return arg0_121()
			end

			arg0_120.viewComponent:switchToMap(arg0_121)
		end,
		function(arg0_122)
			arg0_120.viewComponent:addbubbleMsgBox(function()
				arg0_120.viewComponent:CleanBubbleMsgbox()
				arg0_122()
			end)
		end,
		function(arg0_124)
			if not arg2_120 then
				return arg0_124()
			end

			local var0_124 = getProxy(PlayerProxy):getData()

			if arg1_120.id == 103 and not var0_124:GetCommonFlag(BATTLE_AUTO_ENABLED) then
				arg0_120.viewComponent:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("battle_autobot_unlock"),
					onYes = arg0_124,
					onNo = arg0_124
				})
				arg0_120.viewComponent:emit(LevelMediator2.NOTICE_AUTOBOT_ENABLED, {})

				return
			end

			arg0_124()
		end,
		function(arg0_125)
			if not arg2_120 then
				return arg0_125()
			end

			if getProxy(ChapterProxy):getMapById(arg1_120:getConfig("map")):isSkirmish() then
				local var0_125 = arg1_120.id
				local var1_125 = getProxy(SkirmishProxy):getRawData()
				local var2_125 = _.detect(var1_125, function(arg0_126)
					return tonumber(arg0_126:getConfig("event")) == var0_125
				end)

				if not var2_125 then
					arg0_125()

					return
				end

				local var3_125 = getProxy(TaskProxy)
				local var4_125 = var2_125:getConfig("task_id")
				local var5_125 = var3_125:getTaskVO(var4_125)

				if var5_125 and var5_125:getTaskStatus() == 1 then
					arg0_120:sendNotification(GAME.SUBMIT_TASK, var4_125)

					if var2_125 == var1_125[#var1_125] then
						local var6_125 = getProxy(ActivityProxy)
						local var7_125 = ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE
						local var8_125 = var6_125:getActivityById(var7_125)

						assert(var8_125, "Missing Skirmish Activity " .. (var7_125 or "NIL"))

						local var9_125 = var8_125:getConfig("config_data")
						local var10_125 = var9_125[#var9_125][2]
						local var11_125 = var3_125:getTaskVO(var10_125)

						if var11_125 and var11_125:getTaskStatus() < 2 then
							arg0_120.contextData.TaskToSubmit = var10_125
						end
					end
				end
			end

			arg0_125()
		end,
		function(arg0_127)
			if not arg2_120 then
				return arg0_127()
			end

			local var0_127 = getProxy(ChapterProxy):getMapById(arg1_120:getConfig("map"))

			if var0_127:isRemaster() then
				local var1_127 = var0_127:getRemaster()
				local var2_127 = pg.re_map_template[var1_127]
				local var3_127 = Map.GetRearChaptersOfRemaster(var1_127)

				assert(var3_127)

				if _.any(var3_127, function(arg0_128)
					return arg0_128 == arg1_120.id
				end) then
					local var4_127 = var2_127.memory_group

					if BossRushChapterRemasterHelper.UnlockMemoryGroupStoriesAndShowMsgBox(var4_127, arg0_127) then
						return
					end
				end
			end

			arg0_127()
		end,
		function(arg0_129)
			if arg0_120.contextData.map and not arg0_120.contextData.map:isUnlock() then
				arg0_120.viewComponent:emit(var0_0.ON_SWITCH_NORMAL_MAP)

				return
			end

			if not arg3_120 then
				return arg0_129()
			end

			local var0_129 = arg3_120 and arg3_120.AutoFightFlag
			local var1_129 = {}

			if arg3_120 and arg3_120.ResultDrops then
				for iter0_129, iter1_129 in ipairs(arg3_120.ResultDrops) do
					var1_129 = table.mergeArray(var1_129, iter1_129)
				end
			end

			local var2_129 = {}

			if arg3_120 and arg3_120.TotalDrops then
				for iter2_129, iter3_129 in ipairs(arg3_120.TotalDrops) do
					var2_129 = table.mergeArray(var2_129, iter3_129)
				end
			end

			DropResultIntegration(var2_129)

			local var3_129 = getProxy(ChapterProxy):GetContinuousData(SYSTEM_SCENARIO)

			if var3_129 then
				var3_129:MergeDrops(var2_129, var1_129)
				var3_129:MergeEvents(arg3_120.ListEventNotify, arg3_120.ListGuildEventNotify, arg3_120.ListGuildEventAutoReceiveNotify)

				if arg2_120 then
					var3_129:ConsumeBattleTime()
				end

				if var3_129:IsActive() and var3_129:GetRestBattleTime() > 0 then
					arg0_120.waitingTracking = true

					arg0_120.viewComponent:emit(var0_0.ON_RETRACKING, arg1_120, var0_129)

					return
				end

				getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO)
				arg0_120:DisplayContinuousOperationResult(arg1_120, var3_129)
				arg0_129()

				return
			end

			local var4_129 = var0_129 ~= nil

			if not var4_129 and not arg3_120.ResultDrops then
				return arg0_129()
			end

			local var5_129
			local var6_129

			if var4_129 then
				var5_129 = i18n("autofight_rewards")
				var6_129 = i18n("total_rewards_subtitle")
			else
				var5_129 = i18n("settle_rewards_title")
				var6_129 = i18n("settle_rewards_subtitle")
			end

			arg0_120:addSubLayers(Context.New({
				viewComponent = LevelStageTotalRewardPanel,
				mediator = LevelStageTotalRewardPanelMediator,
				data = {
					title = var5_129,
					subTitle = var6_129,
					chapter = arg1_120,
					onClose = arg0_129,
					rewards = var2_129,
					resultRewards = var1_129,
					events = arg3_120.ListEventNotify,
					guildTasks = arg3_120.ListGuildEventNotify,
					guildAutoReceives = arg3_120.ListGuildEventAutoReceiveNotify,
					isAutoFight = var0_129
				}
			}), true)
		end,
		function(arg0_130)
			if Map.autoNextPage then
				Map.autoNextPage = nil

				triggerButton(arg0_120.viewComponent.btnNext)
			end

			if arg2_120 then
				arg0_120.viewComponent:RefreshMapBG()
			end

			arg0_120:TryPlaySubGuide()
		end
	})
end

function var0_0.DisplayContinuousWindow(arg0_131, arg1_131, arg2_131, arg3_131, arg4_131)
	local var0_131 = arg1_131:getConfig("oil")

	if arg1_131:IsSupportSubmarineStage() and #arg1_131:getSupportFleet() > 0 then
		var0_131 = var0_131 + getGameset("submarine_support_oil_consume")[1]
	end

	local var1_131 = arg1_131:getPlayType()
	local var2_131 = 0
	local var3_131 = 0

	if var1_131 == ChapterConst.TypeMultiStageBoss then
		local var4_131 = pg.chapter_model_multistageboss[arg1_131.id]

		var2_131 = _.reduce(var4_131.boss_refresh, 0, function(arg0_132, arg1_132)
			return arg0_132 + arg1_132
		end)
		var3_131 = #var4_131.boss_refresh
	else
		var2_131, var3_131 = arg1_131:getConfig("boss_refresh"), 1
	end

	local var5_131 = arg1_131:getConfig("use_oil_limit")

	table.Foreach(arg2_131, function(arg0_133, arg1_133)
		local var0_133 = arg4_131[arg0_133]

		if var0_133 == ChapterFleet.DUTY_IDLE then
			return
		end

		local var1_133 = arg1_133:GetCostSum().oil

		if var0_133 == ChapterFleet.DUTY_KILLALL then
			local var2_133 = var5_131[1] or 0
			local var3_133 = var1_133

			if var2_133 > 0 then
				var3_133 = math.min(var3_133, var2_133)
			end

			local var4_133 = var5_131[2] or 0
			local var5_133 = var1_133

			if var4_133 > 0 then
				var5_133 = math.min(var5_133, var4_133)
			end

			var0_131 = var0_131 + var3_133 * var2_131 + var5_133 * var3_131
		elseif var0_133 == ChapterFleet.DUTY_CLEANPATH then
			local var6_133 = var5_131[1] or 0
			local var7_133 = var1_133

			if var6_133 > 0 then
				var7_133 = math.min(var7_133, var6_133)
			end

			var0_131 = var0_131 + var7_133 * var2_131
		elseif var0_133 == ChapterFleet.DUTY_KILLBOSS then
			local var8_133 = var5_131[2] or 0
			local var9_133 = var1_133

			if var8_133 > 0 then
				var9_133 = math.min(var9_133, var8_133)
			end

			var0_131 = var0_131 + var9_133 * var3_131
		end
	end)

	local var6_131 = arg1_131:GetMaxBattleCount()
	local var7_131 = arg3_131 and arg3_131 > 0
	local var8_131 = arg1_131:GetSpItems()
	local var9_131 = var8_131[1] and var8_131[1].count or 0
	local var10_131 = var8_131[1] and var8_131[1].id or 0
	local var11_131 = arg1_131:GetRestDailyBonus()

	arg0_131:addSubLayers(Context.New({
		mediator = LevelContinuousOperationWindowMediator,
		viewComponent = LevelContinuousOperationWindow,
		data = {
			maxCount = var6_131,
			oilCost = var0_131,
			chapter = arg1_131,
			extraRate = {
				rate = 2,
				enabled = var7_131,
				extraCount = var9_131,
				spItemId = var10_131,
				freeBonus = var11_131
			}
		}
	}))
end

function var0_0.DisplayContinuousOperationResult(arg0_134, arg1_134, arg2_134)
	local var0_134 = i18n("autofight_rewards")
	local var1_134 = i18n("total_rewards_subtitle")

	arg0_134:addSubLayers(Context.New({
		viewComponent = LevelContinuousOperationTotalRewardPanel,
		mediator = LevelStageTotalRewardPanelMediator,
		data = {
			title = var0_134,
			subTitle = var1_134,
			chapter = arg1_134,
			rewards = arg2_134:GetDrops(),
			resultRewards = arg2_134:GetSettlementDrops(),
			continuousData = arg2_134,
			events = arg2_134:GetEvents(1),
			guildTasks = arg2_134:GetEvents(2),
			guildAutoReceives = arg2_134:GetEvents(3)
		}
	}), true)
end

function var0_0.OnEventUpdate(arg0_135, arg1_135)
	local var0_135 = getProxy(EventProxy)

	arg0_135.viewComponent:updateEvent(var0_135)

	if pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_135.player.level, "EventMediator") and var0_135.eventForMsg then
		local var1_135 = var0_135.eventForMsg.id or 0
		local var2_135 = getProxy(ChapterProxy):getActiveChapter(true)

		if var2_135 and var2_135:IsAutoFight() then
			getProxy(ChapterProxy):AddExtendChapterDataArray(var2_135.id, "ListEventNotify", var1_135)
			existCall(arg1_135)
		else
			local var3_135 = pg.collection_template[var1_135] and pg.collection_template[var1_135].title or ""

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = false,
				hideNo = true,
				content = i18n("event_special_update", var3_135),
				onYes = arg1_135,
				onNo = arg1_135
			})
		end

		var0_135.eventForMsg = nil
	else
		existCall(arg1_135)
	end
end

function var0_0.onTimeUp(arg0_136)
	local var0_136 = getProxy(ChapterProxy):getActiveChapter()

	if var0_136 and not var0_136:inWartime() then
		local function var1_136()
			arg0_136:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		end

		if arg0_136.contextData.chapterVO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = var1_136,
				onNo = var1_136
			})
		else
			var1_136()
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_timeout"))
		end
	end
end

function var0_0.getDockCallbackFuncs(arg0_138, arg1_138, arg2_138, arg3_138, arg4_138)
	local var0_138 = getProxy(ChapterProxy)

	local function var1_138(arg0_139, arg1_139)
		local var0_139, var1_139 = ShipStatus.ShipStatusCheck("inElite", arg0_139, arg1_139, {
			inElite = arg3_138:getConfig("formation")
		})

		if not var0_139 then
			return var0_139, var1_139
		end

		for iter0_139, iter1_139 in pairs(arg1_138) do
			if arg0_139:isSameKind(iter0_139) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_138(arg0_140, arg1_140, arg2_140)
		arg1_140()
	end

	local function var3_138(arg0_141)
		local var0_141 = arg3_138:getEliteFleetList()[arg4_138]

		if arg2_138 then
			local var1_141 = table.indexof(var0_141, arg2_138.id)

			assert(var1_141)

			if arg0_141[1] then
				var0_141[var1_141] = arg0_141[1]
			else
				table.remove(var0_141, var1_141)
			end
		else
			table.insert(var0_141, arg0_141[1])
		end

		arg3_138:setEliteFleetByIndex(arg4_138, {
			{
				TeamType.FormShips,
				var0_141
			}
		})
		var0_138:updateChapter(arg3_138)
		var0_138:duplicateEliteFleet(arg3_138)
	end

	return var1_138, var2_138, var3_138
end

function var0_0.getSupportDockCallbackFuncs(arg0_142, arg1_142, arg2_142, arg3_142)
	local var0_142 = getProxy(ChapterProxy)

	local function var1_142(arg0_143, arg1_143)
		local var0_143, var1_143 = ShipStatus.ShipStatusCheck("inSupport", arg0_143, arg1_143)

		if not var0_143 then
			return var0_143, var1_143
		end

		for iter0_143, iter1_143 in pairs(arg1_142) do
			if arg0_143:isSameKind(iter0_143) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_142(arg0_144, arg1_144, arg2_144)
		arg1_144()
	end

	local function var3_142(arg0_145)
		local var0_145 = arg3_142:getSupportFleet()

		if arg2_142 then
			local var1_145 = table.indexof(var0_145, arg2_142.id)

			assert(var1_145)

			if arg0_145[1] then
				var0_145[var1_145] = arg0_145[1]
			else
				table.remove(var0_145, var1_145)
			end
		else
			table.insert(var0_145, arg0_145[1])
		end

		arg3_142:setEliteFleetByIndex(4, {
			{
				TeamType.FormShips,
				var0_145
			}
		})
		var0_142:updateChapter(arg3_142)
		var0_142:duplicateEliteFleet(arg3_142)
	end

	return var1_142, var2_142, var3_142
end

function var0_0.playAIActions(arg0_146, arg1_146, arg2_146, arg3_146)
	if not arg0_146.viewComponent.grid then
		arg3_146()

		return
	end

	local var0_146 = getProxy(ChapterProxy)
	local var1_146

	local function var2_146()
		if var1_146 and coroutine.status(var1_146) == "suspended" then
			local var0_147, var1_147 = coroutine.resume(var1_146)

			assert(var0_147, debug.traceback(var1_146, var1_147))

			if not var0_147 then
				arg0_146.viewComponent:unfrozen(-1)
				arg0_146:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest
				})
			end
		end
	end

	var1_146 = coroutine.create(function()
		arg0_146.viewComponent:frozen()

		local var0_148 = {}
		local var1_148 = arg2_146 or 0

		for iter0_148, iter1_148 in ipairs(arg1_146) do
			local var2_148 = arg0_146.contextData.chapterVO
			local var3_148, var4_148 = iter1_148:applyTo(var2_148, true)

			assert(var3_148, var4_148)
			iter1_148:PlayAIAction(arg0_146.contextData.chapterVO, arg0_146, function()
				local var0_149, var1_149, var2_149 = iter1_148:applyTo(var2_148, false)

				if var0_149 then
					var0_146:updateChapter(var2_148, var1_149)

					var1_148 = bit.bor(var1_148, var2_149 or 0)
				end

				onNextTick(var2_146)
			end)
			coroutine.yield()

			if isa(iter1_148, FleetAIAction) and iter1_148.actType == ChapterConst.ActType_Poison and var2_148:existFleet(FleetType.Normal, iter1_148.line.row, iter1_148.line.column) then
				local var5_148 = var2_148:getFleetIndex(FleetType.Normal, iter1_148.line.row, iter1_148.line.column)

				table.insert(var0_148, var5_148)
			end
		end

		local var6_148 = bit.band(var1_148, ChapterConst.DirtyAutoAction)

		var1_148 = bit.band(var1_148, bit.bnot(ChapterConst.DirtyAutoAction))

		if var1_148 ~= 0 then
			local var7_148 = arg0_146.contextData.chapterVO

			var0_146:updateChapter(var7_148, var1_148)
		end

		seriesAsync({
			function(arg0_150)
				if var6_148 ~= 0 then
					arg0_146.viewComponent.levelStageView:tryAutoAction(arg0_150)
				else
					arg0_150()
				end
			end,
			function(arg0_151)
				table.ParallelIpairsAsync(var0_148, function(arg0_152, arg1_152, arg2_152)
					arg0_146.viewComponent.grid:showFleetPoisonDamage(arg1_152, arg2_152)
				end, arg0_151)
			end,
			function(arg0_153)
				arg3_146()
				arg0_146.viewComponent:unfrozen()
			end
		})
	end)

	var2_146()
end

function var0_0.saveSubState(arg0_154, arg1_154)
	local var0_154 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("chapter_submarine_ai_type_" .. var0_154, arg1_154 + 1)
	PlayerPrefs.Save()
end

function var0_0.loadSubState(arg0_155, arg1_155)
	local var0_155 = getProxy(PlayerProxy):getRawData().id
	local var1_155 = PlayerPrefs.GetInt("chapter_submarine_ai_type_" .. var0_155, 1) - 1
	local var2_155 = math.clamp(var1_155, 0, 1)

	if var2_155 ~= arg1_155 then
		arg0_155.viewComponent:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSubState,
			arg1 = var2_155
		})
	end
end

function var0_0.remove(arg0_156)
	arg0_156:removeSubLayers(LevelContinuousOperationWindowMediator)
	var0_0.super.remove(arg0_156)
end

return var0_0
