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
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_56, arg1_56)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_56)
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_57)
		local var0_57 = getProxy(ChapterProxy):getActiveChapter()

		assert(var0_57)

		local var1_57 = var0_57.fleet
		local var2_57 = var0_57:getStageId(var1_57.line.row, var1_57.line.column)

		seriesAsync({
			function(arg0_58)
				local var0_58 = {}

				for iter0_58, iter1_58 in pairs(var1_57.ships) do
					table.insert(var0_58, iter1_58)
				end

				Fleet.EnergyCheck(var0_58, var1_57.name, function(arg0_59)
					if arg0_59 then
						arg0_58()
					end
				end, function(arg0_60)
					if not arg0_60 then
						getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.SHIP_ENERGY_LOW)
					end
				end)
			end,
			function(arg0_61)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0_61 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.GOLD_MAX)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0_61,
						onYes = arg0_61
					})
				else
					arg0_61()
				end
			end,
			function(arg0_62)
				arg0_1:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_SCENARIO,
					stageId = var2_57
				})
			end
		})
	end)
	arg0_1:bind(arg0_1.ON_ENTER_MAINLEVEL, function(arg0_63, arg1_63)
		arg0_1:DidEnterLevelMainUI(arg1_63)
	end)
	arg0_1:bind(arg0_1.ON_DIDENTER, function(arg0_64)
		arg0_1.viewComponent:emit(LevelMediator2.UPDATE_EVENT_LIST)
	end)
	arg0_1:bind(var0_0.ENTER_WORLD, function(arg0_65)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
	end)
	arg0_1:bind(var0_0.ON_CHAPTER_REMASTER_AWARD, function(arg0_66, arg1_66, arg2_66)
		arg0_1:sendNotification(GAME.CHAPTER_REMASTER_AWARD_RECEIVE, {
			chapterId = arg1_66,
			pos = arg2_66
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_ACT_BOSS_BATTLE, function(arg0_67)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACT_BOSS_BATTLE, {
			showAni = true
		})
	end)
	arg0_1:bind(LevelUIConst.OPEN_NORMAL_CONTINUOUS_WINDOW, function(arg0_68, arg1_68, arg2_68, arg3_68, arg4_68)
		local var0_68 = _.map(arg2_68, function(arg0_69)
			local var0_69 = getProxy(FleetProxy):getFleetById(arg0_69)

			if not var0_69 or var0_69:getFleetType() == FleetType.Submarine then
				return
			end

			return var0_69
		end)

		arg0_1:DisplayContinuousWindow(arg1_68, var0_68, arg3_68, arg4_68)
	end)
	arg0_1:bind(LevelUIConst.OPEN_ELITE_CONTINUOUS_WINDOW, function(arg0_70, arg1_70, arg2_70, arg3_70)
		local var0_70 = arg1_70:getEliteFleetList()
		local var1_70 = getProxy(BayProxy):getRawData()
		local var2_70 = _.map(var0_70, function(arg0_71)
			if #arg0_71 == 0 or _.any(arg0_71, function(arg0_72)
				local var0_72 = var1_70[arg0_72]

				return var0_72 and var0_72:getTeamType() == TeamType.Submarine
			end) then
				return
			end

			return TypedFleet.New({
				fleetType = FleetType.Normal,
				ship_list = arg0_71
			})
		end)

		arg0_1:DisplayContinuousWindow(arg1_70, var2_70, arg2_70, arg3_70)
	end)
	arg0_1:bind(var0_0.ON_UPDATE_LOWPRIORITY_TASK, function(arg0_73, arg1_73, arg2_73)
		arg0_1:sendNotification(GAME.UPDATE_LOW_PRIORITY_TASK_PROGRESS, {
			taskId = arg1_73
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

function var0_0.DidEnterLevelMainUI(arg0_74, arg1_74)
	arg0_74.viewComponent:setMap(arg1_74)

	if arg0_74.contextData.openChapterId then
		local var0_74 = arg0_74.contextData.openChapterId

		arg0_74.viewComponent.mapBuilder:ActionInvoke("TryOpenChapter", var0_74)

		arg0_74.contextData.openChapterId = nil
	end

	local var1_74 = arg0_74.contextData.chapterVO

	if var1_74 and var1_74.active then
		arg0_74.viewComponent:switchToChapter(var1_74)
	elseif arg0_74.contextData.map:isSkirmish() then
		arg0_74.viewComponent:ShowCurtains(true)
		arg0_74.viewComponent:doPlayAnim("TV01", function(arg0_75)
			go(arg0_75):SetActive(false)
			arg0_74.viewComponent:ShowCurtains(false)
		end)
	end

	if arg0_74.contextData.preparedTaskList and #arg0_74.contextData.preparedTaskList > 0 then
		for iter0_74, iter1_74 in ipairs(arg0_74.contextData.preparedTaskList) do
			arg0_74:sendNotification(GAME.SUBMIT_TASK, iter1_74)
		end

		table.clean(arg0_74.contextData.preparedTaskList)
	end

	if arg0_74.contextData.StopAutoFightFlag then
		local var2_74 = getProxy(ChapterProxy)
		local var3_74 = var2_74:getActiveChapter()

		if var3_74 then
			var2_74:SetChapterAutoFlag(var3_74.id, false)

			local var4_74 = bit.bor(ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

			arg0_74.viewComponent:updateChapterVO(var3_74, var4_74)
		end

		arg0_74.contextData.StopAutoFightFlag = nil
	end

	if arg0_74.contextData.ToTrackingData then
		arg0_74:sendNotification(arg0_74.contextData.ToTrackingData[1], arg0_74.contextData.ToTrackingData[2])

		arg0_74.contextData.ToTrackingData = nil
	end
end

function var0_0.RegisterTrackEvent(arg0_76)
	arg0_76:bind(var0_0.ON_TRACKING, function(arg0_77, arg1_77, arg2_77, arg3_77, arg4_77, arg5_77)
		local var0_77 = getProxy(ChapterProxy):getChapterById(arg1_77, true)
		local var1_77 = getProxy(ChapterProxy):GetLastFleetIndex()

		arg0_76:sendNotification(GAME.TRACKING, {
			chapterId = arg1_77,
			fleetIds = var1_77,
			loopFlag = arg2_77,
			operationItem = arg3_77,
			duties = arg4_77,
			autoFightFlag = arg5_77
		})
	end)
	arg0_76:bind(var0_0.ON_ELITE_TRACKING, function(arg0_78, arg1_78, arg2_78, arg3_78, arg4_78, arg5_78)
		arg0_76:sendNotification(GAME.TRACKING, {
			chapterId = arg1_78,
			loopFlag = arg2_78,
			operationItem = arg3_78,
			duties = arg4_78,
			autoFightFlag = arg5_78
		})
	end)
	arg0_76:bind(var0_0.ON_RETRACKING, function(arg0_79, arg1_79, arg2_79)
		local var0_79 = arg1_79.duties
		local var1_79 = arg1_79:getConfig("type") == Chapter.CustomFleet
		local var2_79 = arg1_79:GetActiveSPItemID()

		if var1_79 then
			arg0_76.viewComponent:emit(LevelMediator2.ON_ELITE_TRACKING, arg1_79.id, arg1_79.loopFlag, var2_79, var0_79, arg2_79)
		else
			arg0_76.viewComponent:emit(LevelMediator2.ON_TRACKING, arg1_79.id, arg1_79.loopFlag, var2_79, var0_79, arg2_79)
		end
	end)
end

function var0_0.NoticeVoteBook(arg0_80, arg1_80)
	arg1_80()
end

function var0_0.TryPlaySubGuide(arg0_81)
	arg0_81.viewComponent:tryPlaySubGuide()
end

function var0_0.listNotificationInterests(arg0_82)
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

function var0_0.handleNotification(arg0_83, arg1_83)
	local var0_83 = arg1_83:getName()
	local var1_83 = arg1_83:getBody()

	if var0_83 == GAME.BEGIN_STAGE_DONE then
		arg0_83:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_83)
	elseif var0_83 == VoteProxy.VOTE_ORDER_BOOK_DELETE or VoteProxy.VOTE_ORDER_BOOK_UPDATE == var0_83 then
		arg0_83.viewComponent:updateVoteBookBtn()
	elseif var0_83 == PlayerProxy.UPDATED then
		arg0_83.viewComponent:updateRes(var1_83)
	elseif var0_83 == var0_0.ON_TRACKING or var0_83 == var0_0.ON_ELITE_TRACKING or var0_83 == var0_0.ON_RETRACKING then
		arg0_83.viewComponent:emit(var0_83, unpackEx(var1_83))
	elseif var0_83 == GAME.TRACKING_DONE then
		arg0_83.waitingTracking = nil

		arg0_83.viewComponent:resetLevelGrid()

		arg0_83.viewComponent.FirstEnterChapter = var1_83.id

		arg0_83.viewComponent:switchToChapter(var1_83)
	elseif var0_83 == ChapterProxy.CHAPTER_UPDATED then
		arg0_83.viewComponent:updateChapterVO(var1_83.chapter, var1_83.dirty)
	elseif var0_83 == GAME.COMMANDER_ELIT_FORMATION_OP_DONE then
		if arg0_83.contextData.commanderOPChapter then
			local var2_83 = getProxy(ChapterProxy):getChapterById(var1_83.chapterId)

			for iter0_83, iter1_83 in pairs(var2_83:getEliteFleetCommanders()) do
				arg0_83.contextData.commanderOPChapter:setEliteFleetByIndex(iter0_83, {
					{
						TeamType.FormCommander,
						{
							pos = 1,
							id = iter1_83[1]
						}
					},
					{
						TeamType.FormCommander,
						{
							pos = 2,
							id = iter1_83[2]
						}
					}
				})
			end

			arg0_83.viewComponent:RefreshFleetSelectView(arg0_83.contextData.commanderOPChapter)
		end
	elseif var0_83 == GAME.CHAPTER_OP_DONE then
		local var3_83

		local function var4_83()
			if var3_83 and coroutine.status(var3_83) == "suspended" then
				local var0_84, var1_84 = coroutine.resume(var3_83)

				assert(var0_84, debug.traceback(var3_83, var1_84))
			end
		end

		var3_83 = coroutine.create(function()
			local var0_85 = var1_83.type
			local var1_85 = arg0_83.contextData.chapterVO
			local var2_85 = var1_85:IsAutoFight()

			if var0_85 == ChapterConst.OpRetreat and not var1_83.id then
				var1_85 = var1_83.finalChapterLevelData

				if var1_83.exittype and var1_83.exittype == ChapterConst.ExitFromMap then
					arg0_83.viewComponent:setChapter(nil)
					arg0_83.viewComponent.mapBuilder:UpdateChapterTF(var1_85.id)
					arg0_83:OnExitChapter(var1_85, var1_83.win, var1_83.extendData)

					return
				end

				if var1_85:existOni() then
					local var3_85 = var1_85:checkOniState()

					if var3_85 then
						arg0_83.viewComponent:displaySpResult(var3_85, var4_83)
						coroutine.yield()
					end
				end

				if var1_85:isPlayingWithBombEnemy() then
					arg0_83.viewComponent:displayBombResult(var4_83)
					coroutine.yield()
				end
			end

			local var4_85 = var1_83.items
			local var5_85

			if var4_85 and #var4_85 > 0 then
				if var0_85 == ChapterConst.OpBox then
					local var6_85 = var1_85.fleet.line
					local var7_85 = var1_85:getChapterCell(var6_85.row, var6_85.column)

					if pg.box_data_template[var7_85.attachmentId].type == ChapterConst.BoxDrop and ChapterConst.IsAtelierMap(arg0_83.contextData.map) then
						local var8_85 = _.filter(var4_85, function(arg0_86)
							return arg0_86.type == DROP_TYPE_RYZA_DROP
						end)

						if #var8_85 > 0 then
							var5_85 = AwardInfoLayer.TITLE.RYZA

							local var9_85 = math.random(#var8_85)
							local var10_85 = AtelierMaterial.New({
								configId = var8_85[var9_85].id
							}):GetVoices()

							if var10_85 and #var10_85 > 0 then
								local var11_85 = var10_85[math.random(#var10_85)]
								local var12_85, var13_85, var14_85 = ShipWordHelper.GetWordAndCV(var11_85[1], var11_85[2], nil, PLATFORM_CODE ~= PLATFORM_US)

								arg0_83.viewComponent:emit(LevelUIConst.ADD_TOAST_QUEUE, {
									iconScale = 0.75,
									Class = LevelStageAtelierMaterialToast,
									title = i18n("ryza_tip_toast_item_got"),
									desc = var14_85,
									voice = var13_85,
									icon = var11_85[3]
								})
							end
						end
					end
				end

				seriesAsync({
					function(arg0_87)
						getProxy(ChapterProxy):AddExtendChapterDataArray(var1_85.id, "TotalDrops", _.filter(var4_85, function(arg0_88)
							return arg0_88.type ~= DROP_TYPE_STRATEGY
						end))
						arg0_83.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
							items = var4_85,
							title = var5_85,
							closeOnCompleted = var2_85,
							removeFunc = arg0_87
						})
					end,
					function(arg0_89)
						if var0_85 == ChapterConst.OpBox and _.any(var4_85, function(arg0_90)
							if arg0_90.type ~= DROP_TYPE_VITEM then
								return false
							end

							return arg0_90:getConfig("virtual_type") == 1
						end) then
							(function()
								local var0_91 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

								if not var0_91 then
									return
								end

								local var1_91 = pg.activity_event_picturepuzzle[var0_91.id]

								if not var1_91 then
									return
								end

								if #table.mergeArray(var0_91.data1_list, var0_91.data2_list, true) < #var1_91.pickup_picturepuzzle + #var1_91.drop_picturepuzzle then
									return
								end

								local var2_91 = var0_91:getConfig("config_client").comStory

								pg.NewStoryMgr.GetInstance():Play(var2_91, arg0_89)
							end)()
						end

						if _.any(var4_85, function(arg0_92)
							if arg0_92.type ~= DROP_TYPE_STRATEGY then
								return false
							end

							return pg.strategy_data_template[arg0_92.id].type == ChapterConst.StgTypeConsume
						end) then
							arg0_83.viewComponent.levelStageView:popStageStrategy()
						end

						arg0_89()
					end
				}, var4_83)
				coroutine.yield()
			end

			assert(var1_85)

			if var0_85 == ChapterConst.OpSkipBattle or var0_85 == ChapterConst.OpPreClear then
				arg0_83.viewComponent.levelStageView:tryAutoAction(function()
					if not arg0_83.viewComponent.levelStageView then
						return
					end

					arg0_83.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_85 == ChapterConst.OpRetreat then
				local var15_85 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

				if var15_85 then
					local var16_85 = {}
					local var17_85 = var15_85:getContextByMediator(ChapterPreCombatMediator)

					if var17_85 then
						table.insert(var16_85, var17_85)
					end

					_.each(var16_85, function(arg0_94)
						arg0_83:sendNotification(GAME.REMOVE_LAYERS, {
							context = arg0_94
						})
					end)
				end

				if var1_83.id then
					return
				end

				local var18_85 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN)

				if var18_85 and not var18_85.autoActionForbidden and not var18_85.achieved and var18_85.data1 == 7 and var1_85.id == 204 and var1_85:isClear() then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						hideNo = true,
						content = "有新的签到奖励可以领取，点击确定前往",
						onYes = function()
							arg0_83:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end,
						onNo = function()
							arg0_83:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end
					})

					return
				end

				arg0_83:OnExitChapter(var1_85, var1_83.win, var1_83.extendData)
			elseif var0_85 == ChapterConst.OpMove then
				seriesAsync({
					function(arg0_97)
						var1_85 = arg0_83.contextData.chapterVO

						local var0_97 = var1_83.fullpath[#var1_83.fullpath]

						var1_85.fleet:SetLine(var0_97)
						getProxy(ChapterProxy):updateChapter(var1_85)
						arg0_83.viewComponent.grid:moveFleet(var1_83.path, var1_83.fullpath, var1_83.oldLine, arg0_97)
					end,
					function(arg0_98)
						if not var1_83.teleportPaths then
							arg0_98()

							return
						end

						local var0_98 = var1_83.teleportPaths[1]
						local var1_98 = var1_83.teleportPaths[2]

						if not var0_98 or not var1_98 then
							arg0_98()

							return
						end

						var1_85 = arg0_83.contextData.chapterVO

						local var2_98 = var1_85:getFleet(FleetType.Normal, var0_98.row, var0_98.column)

						if not var2_98 then
							arg0_98()

							return
						end

						var2_98.line = Clone(var1_83.teleportPaths[2])

						getProxy(ChapterProxy):updateChapter(var1_85)

						local var3_98 = arg0_83:getViewComponent().grid:GetCellFleet(var2_98.id)

						arg0_83:getViewComponent().grid:TeleportCellByPortalWithCameraMove(var2_98, var3_98, var1_83.teleportPaths, arg0_98)
					end,
					function(arg0_99)
						arg0_83:playAIActions(var1_83.aiActs, var1_83.extraFlag, arg0_99)
					end
				}, function()
					var1_85 = arg0_83.contextData.chapterVO

					local var0_100 = var1_85.fleet:getStrategies()

					if _.any(var0_100, function(arg0_101)
						return arg0_101.id == ChapterConst.StrategyExchange and arg0_101.count > 0
					end) then
						arg0_83.viewComponent.levelStageView:popStageStrategy()
					end

					arg0_83.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					arg0_83.viewComponent.levelStageView:updateAmbushRate(var1_85.fleet.line, true)
					arg0_83.viewComponent.levelStageView:updateStageStrategy()
					arg0_83.viewComponent.levelStageView:updateFleetBuff()
					arg0_83.viewComponent.levelStageView:updateBombPanel()
					arg0_83.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_85 == ChapterConst.OpAmbush then
				arg0_83.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_85 == ChapterConst.OpBox then
				arg0_83:playAIActions(var1_83.aiActs, var1_83.extraFlag, function()
					if not arg0_83.viewComponent.levelStageView then
						return
					end

					arg0_83.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_85 == ChapterConst.OpStory then
				arg0_83.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_85 == ChapterConst.OpSwitch then
				arg0_83.viewComponent.grid:adjustCameraFocus()
			elseif var0_85 == ChapterConst.OpEnemyRound then
				arg0_83:playAIActions(var1_83.aiActs, var1_83.extraFlag, function()
					arg0_83.viewComponent.levelStageView:updateBombPanel(true)

					local var0_103 = var1_85.fleet:getStrategies()

					if _.any(var0_103, function(arg0_104)
						return arg0_104.id == ChapterConst.StrategyExchange and arg0_104.count > 0
					end) then
						arg0_83.viewComponent.levelStageView:updateStageStrategy()
						arg0_83.viewComponent.levelStageView:popStageStrategy()
					end

					arg0_83.viewComponent.levelStageView:tryAutoTrigger()
					arg0_83.viewComponent:updatePoisonAreaTip()
				end)
			elseif var0_85 == ChapterConst.OpSubState then
				arg0_83:saveSubState(var1_85.subAutoAttack)
				arg0_83.viewComponent.grid:OnChangeSubAutoAttack()
			elseif var0_85 == ChapterConst.OpStrategy then
				if var1_83.arg1 == ChapterConst.StrategyExchange then
					local var19_85 = var1_85.fleet:findSkills(FleetSkill.TypeStrategy)

					for iter0_85, iter1_85 in ipairs(var19_85) do
						if iter1_85:GetType() == FleetSkill.TypeStrategy and iter1_85:GetArgs()[1] == ChapterConst.StrategyExchange then
							local var20_85 = var1_85.fleet:findCommanderBySkillId(iter1_85.id)

							arg0_83.viewComponent:doPlayCommander(var20_85)

							break
						end
					end
				end

				arg0_83:playAIActions(var1_83.aiActs, var1_83.extraFlag, function()
					arg0_83.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				end)
			elseif var0_85 == ChapterConst.OpSupply then
				arg0_83.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_85 == ChapterConst.OpBarrier then
				arg0_83.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_85 == ChapterConst.OpSubTeleport then
				seriesAsync({
					function(arg0_106)
						local var0_106 = _.detect(var1_85.fleets, function(arg0_107)
							return arg0_107.id == var1_83.id
						end)

						var0_106.line = {
							row = var1_83.arg1,
							column = var1_83.arg2
						}
						var0_106.startPos = {
							row = var1_83.arg1,
							column = var1_83.arg2
						}

						local var1_106 = var1_83.fullpath[1]
						local var2_106 = var1_83.fullpath[#var1_83.fullpath]
						local var3_106 = var1_85:findPath(nil, var1_106, var2_106)
						local var4_106 = pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2]
						local var5_106 = math.ceil(var4_106 * #var0_106:getShips(false) * var3_106 - 1e-05)
						local var6_106 = getProxy(PlayerProxy)
						local var7_106 = var6_106:getData()

						var7_106:consume({
							oil = var5_106
						})
						arg0_83.viewComponent:updateRes(var7_106)
						var6_106:updatePlayer(var7_106)
						arg0_83.viewComponent.grid:moveSub(table.indexof(var1_85.fleets, var0_106), var1_83.fullpath, nil, function()
							local var0_108 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1_85, var0_108)

							var1_85 = arg0_83.contextData.chapterVO

							arg0_106()
						end)
					end,
					function(arg0_109)
						if not var1_83.teleportPaths then
							arg0_109()

							return
						end

						local var0_109 = var1_83.teleportPaths[1]
						local var1_109 = var1_83.teleportPaths[2]

						if not var0_109 or not var1_109 then
							arg0_109()

							return
						end

						local var2_109 = _.detect(var1_85.fleets, function(arg0_110)
							return arg0_110.id == var1_83.id
						end)

						var2_109.startPos = Clone(var1_83.teleportPaths[2])
						var2_109.line = Clone(var1_83.teleportPaths[2])

						local var3_109 = arg0_83:getViewComponent().grid:GetCellFleet(var2_109.id)

						arg0_83:getViewComponent().grid:TeleportFleetByPortal(var3_109, var1_83.teleportPaths, function()
							local var0_111 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1_85, var0_111)

							var1_85 = arg0_83.contextData.chapterVO

							arg0_109()
						end)
					end,
					function(arg0_112)
						arg0_83.viewComponent.levelStageView:SwitchBottomStagePanel(false)
						arg0_83.viewComponent.grid:TurnOffSubTeleport()
						arg0_83.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					end
				})
			end
		end)

		var4_83()
	elseif var0_83 == ChapterProxy.CHAPTER_TIMESUP then
		arg0_83:onTimeUp()
	elseif var0_83 == GAME.EVENT_LIST_UPDATE then
		arg0_83.viewComponent:addbubbleMsgBox(function(arg0_113)
			arg0_83:OnEventUpdate(arg0_113)
		end)
	elseif var0_83 == GAME.VOTE_BOOK_BE_UPDATED_DONE then
		arg0_83.viewComponent:addbubbleMsgBox(function(arg0_114)
			arg0_83:NoticeVoteBook(arg0_114)
		end)
	elseif var0_83 == DailyLevelProxy.ELITE_QUOTA_UPDATE then
		local var5_83 = getProxy(DailyLevelProxy)

		arg0_83.viewComponent:setEliteQuota(var5_83.eliteCount, pg.gameset.elite_quota.key_value)
	elseif var0_83 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_83.viewComponent.mapBuilder:UpdateMapItems()
	elseif var0_83 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_83 and arg0_83.viewComponent.ptActivity and var1_83.id == arg0_83.viewComponent.ptActivity.id then
			arg0_83.viewComponent:updatePtActivity(var1_83)
		end
	elseif var0_83 == GAME.GET_REMASTER_TICKETS_DONE then
		arg0_83.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_83, function()
			arg0_83.viewComponent:updateRemasterTicket()
		end)
	elseif var0_83 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var6_83 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_83.viewComponent:setCommanderPrefabs(var6_83)
		arg0_83.viewComponent:updateCommanderPrefab()
	elseif var0_83 == GAME.COOMMANDER_EQUIP_TO_FLEET_DONE then
		local var7_83 = getProxy(FleetProxy):GetRegularFleets()

		arg0_83.viewComponent:updateFleet(var7_83)
		arg0_83.viewComponent:RefreshFleetSelectView()
	elseif var0_83 == GAME.SUBMIT_TASK_DONE then
		if arg0_83.contextData.map and arg0_83.contextData.map:isSkirmish() then
			arg0_83.viewComponent.mapBuilder:UpdateMapItems()
		end

		arg0_83.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_83, function()
			if arg0_83.contextData.map and arg0_83.contextData.map:isSkirmish() and arg0_83.contextData.TaskToSubmit then
				local var0_116 = arg0_83.contextData.TaskToSubmit

				arg0_83.contextData.TaskToSubmit = nil

				arg0_83:sendNotification(GAME.SUBMIT_TASK, var0_116)
			end

			arg0_83.viewComponent.mapBuilder:OnSubmitTaskDone()
		end)
	elseif var0_83 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_83.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_83.awards, function()
			arg0_83.viewComponent.mapBuilder:OnSubmitTaskDone()
		end)
	elseif var0_83 == BagProxy.ITEM_UPDATED then
		local var8_83 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)

		arg0_83.viewComponent:setSpecialOperationTickets(var8_83)
	elseif var0_83 == ChapterProxy.CHAPTER_AUTO_FIGHT_FLAG_UPDATED then
		if not arg0_83:getViewComponent().levelStageView then
			return
		end

		arg0_83:getViewComponent().levelStageView:ActionInvoke("UpdateAutoFightMark")
	elseif var0_83 == ChapterProxy.CHAPTER_SKIP_PRECOMBAT_UPDATED then
		if not arg0_83:getViewComponent().levelStageView then
			return
		end

		arg0_83:getViewComponent().levelStageView:ActionInvoke("UpdateSkipPreCombatMark")
	elseif var0_83 == ChapterProxy.CHAPTER_REMASTER_INFO_UPDATED or var0_83 == GAME.CHAPTER_REMASTER_INFO_REQUEST_DONE then
		arg0_83.viewComponent:updateRemasterInfo()
		arg0_83.viewComponent:updateRemasterBtnTip()
	elseif var0_83 == GAME.CHAPTER_REMASTER_AWARD_RECEIVE_DONE then
		arg0_83.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_83)
	elseif var0_83 == GAME.STORY_UPDATE_DONE then
		arg0_83.cachedStoryAwards = var1_83

		arg0_83.viewComponent.mapBuilder:UpdateView()
	elseif var0_83 == GAME.STORY_END then
		if arg0_83.cachedStoryAwards then
			arg0_83.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_83.cachedStoryAwards.awards)

			arg0_83.cachedStoryAwards = nil
		end
	elseif var0_83 == LevelUIConst.CONTINUOUS_OPERATION then
		arg0_83.viewComponent:emit(LevelUIConst.CONTINUOUS_OPERATION, var1_83)
	elseif var0_83 == GAME.TRACKING_ERROR then
		if arg0_83.waitingTracking then
			arg0_83:DisplayContinuousOperationResult(var1_83.chapter, getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO))
		end

		arg0_83.waitingTracking = nil
	elseif var0_83 == var0_0.ON_SPITEM_CHANGED then
		arg0_83.viewComponent:emit(var0_0.ON_SPITEM_CHANGED, var1_83)
	end
end

function var0_0.OnExitChapter(arg0_118, arg1_118, arg2_118, arg3_118)
	assert(arg1_118)
	seriesAsync({
		function(arg0_119)
			if not arg0_118.contextData.chapterVO then
				return arg0_119()
			end

			arg0_118.viewComponent:switchToMap(arg0_119)
		end,
		function(arg0_120)
			arg0_118.viewComponent:addbubbleMsgBox(function()
				arg0_118.viewComponent:CleanBubbleMsgbox()
				arg0_120()
			end)
		end,
		function(arg0_122)
			if not arg2_118 then
				return arg0_122()
			end

			local var0_122 = getProxy(PlayerProxy):getData()

			if arg1_118.id == 103 and not var0_122:GetCommonFlag(BATTLE_AUTO_ENABLED) then
				arg0_118.viewComponent:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("battle_autobot_unlock"),
					onYes = arg0_122,
					onNo = arg0_122
				})
				arg0_118.viewComponent:emit(LevelMediator2.NOTICE_AUTOBOT_ENABLED, {})

				return
			end

			arg0_122()
		end,
		function(arg0_123)
			if not arg2_118 then
				return arg0_123()
			end

			if getProxy(ChapterProxy):getMapById(arg1_118:getConfig("map")):isSkirmish() then
				local var0_123 = arg1_118.id
				local var1_123 = getProxy(SkirmishProxy):getRawData()
				local var2_123 = _.detect(var1_123, function(arg0_124)
					return tonumber(arg0_124:getConfig("event")) == var0_123
				end)

				if not var2_123 then
					arg0_123()

					return
				end

				local var3_123 = getProxy(TaskProxy)
				local var4_123 = var2_123:getConfig("task_id")
				local var5_123 = var3_123:getTaskVO(var4_123)

				if var5_123 and var5_123:getTaskStatus() == 1 then
					arg0_118:sendNotification(GAME.SUBMIT_TASK, var4_123)

					if var2_123 == var1_123[#var1_123] then
						local var6_123 = getProxy(ActivityProxy)
						local var7_123 = ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE
						local var8_123 = var6_123:getActivityById(var7_123)

						assert(var8_123, "Missing Skirmish Activity " .. (var7_123 or "NIL"))

						local var9_123 = var8_123:getConfig("config_data")
						local var10_123 = var9_123[#var9_123][2]
						local var11_123 = var3_123:getTaskVO(var10_123)

						if var11_123 and var11_123:getTaskStatus() < 2 then
							arg0_118.contextData.TaskToSubmit = var10_123
						end
					end
				end
			end

			arg0_123()
		end,
		function(arg0_125)
			if not arg2_118 then
				return arg0_125()
			end

			local var0_125 = getProxy(ChapterProxy):getMapById(arg1_118:getConfig("map"))

			if var0_125:isRemaster() then
				local var1_125 = var0_125:getRemaster()
				local var2_125 = pg.re_map_template[var1_125]
				local var3_125 = Map.GetRearChaptersOfRemaster(var1_125)

				assert(var3_125)

				if _.any(var3_125, function(arg0_126)
					return arg0_126 == arg1_118.id
				end) then
					local var4_125 = var2_125.memory_group
					local var5_125 = pg.memory_group[var4_125].memories
					local var6_125 = underscore.filter(var5_125, function(arg0_127)
						return not pg.NewStoryMgr.GetInstance():IsPlayed(pg.memory_template[arg0_127].unlock_pre, true)
					end)

					underscore.each(var6_125, function(arg0_128)
						for iter0_128, iter1_128 in ipairs(pg.memory_template[arg0_128].unlock_pre) do
							local var0_128, var1_128 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_128)

							pg.NewStoryMgr.GetInstance():SetPlayedFlag(var0_128)
						end
					end)

					if #var6_125 > 0 then
						_.each(var5_125, function(arg0_129)
							local var0_129 = pg.memory_template[arg0_129].unlock_pre
							local var1_129, var2_129 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0_129)

							pg.NewStoryMgr.GetInstance():SetPlayedFlag(var1_129)
						end)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							yesText = "text_go",
							content = i18n("levelScene_remaster_story_tip", pg.memory_group[var4_125].title),
							onYes = function()
								arg0_118:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
									page = WorldMediaCollectionScene.PAGE_MEMORTY,
									memoryGroup = var4_125
								})
							end,
							onNo = function()
								local var0_131 = getProxy(PlayerProxy):getRawData().id

								PlayerPrefs.SetInt("MEMORY_GROUP_NOTIFICATION" .. var0_131 .. " " .. var4_125, 1)
								PlayerPrefs.Save()
								arg0_125()
							end
						})

						return
					end
				end
			end

			arg0_125()
		end,
		function(arg0_132)
			if arg0_118.contextData.map and not arg0_118.contextData.map:isUnlock() then
				arg0_118.viewComponent:emit(var0_0.ON_SWITCH_NORMAL_MAP)

				return
			end

			if not arg3_118 then
				return arg0_132()
			end

			local var0_132 = arg3_118 and arg3_118.AutoFightFlag
			local var1_132 = {}

			if arg3_118 and arg3_118.ResultDrops then
				for iter0_132, iter1_132 in ipairs(arg3_118.ResultDrops) do
					var1_132 = table.mergeArray(var1_132, iter1_132)
				end
			end

			local var2_132 = {}

			if arg3_118 and arg3_118.TotalDrops then
				for iter2_132, iter3_132 in ipairs(arg3_118.TotalDrops) do
					var2_132 = table.mergeArray(var2_132, iter3_132)
				end
			end

			DropResultIntegration(var2_132)

			local var3_132 = getProxy(ChapterProxy):GetContinuousData(SYSTEM_SCENARIO)

			if var3_132 then
				var3_132:MergeDrops(var2_132, var1_132)
				var3_132:MergeEvents(arg3_118.ListEventNotify, arg3_118.ListGuildEventNotify, arg3_118.ListGuildEventAutoReceiveNotify)

				if arg2_118 then
					var3_132:ConsumeBattleTime()
				end

				if var3_132:IsActive() and var3_132:GetRestBattleTime() > 0 then
					arg0_118.waitingTracking = true

					arg0_118.viewComponent:emit(var0_0.ON_RETRACKING, arg1_118, var0_132)

					return
				end

				getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO)
				arg0_118:DisplayContinuousOperationResult(arg1_118, var3_132)
				arg0_132()

				return
			end

			local var4_132 = var0_132 ~= nil

			if not var4_132 and not arg3_118.ResultDrops then
				return arg0_132()
			end

			local var5_132
			local var6_132

			if var4_132 then
				var5_132 = i18n("autofight_rewards")
				var6_132 = i18n("total_rewards_subtitle")
			else
				var5_132 = i18n("settle_rewards_title")
				var6_132 = i18n("settle_rewards_subtitle")
			end

			arg0_118:addSubLayers(Context.New({
				viewComponent = LevelStageTotalRewardPanel,
				mediator = LevelStageTotalRewardPanelMediator,
				data = {
					title = var5_132,
					subTitle = var6_132,
					chapter = arg1_118,
					onClose = arg0_132,
					rewards = var2_132,
					resultRewards = var1_132,
					events = arg3_118.ListEventNotify,
					guildTasks = arg3_118.ListGuildEventNotify,
					guildAutoReceives = arg3_118.ListGuildEventAutoReceiveNotify,
					isAutoFight = var0_132
				}
			}), true)
		end,
		function(arg0_133)
			if Map.autoNextPage then
				Map.autoNextPage = nil

				triggerButton(arg0_118.viewComponent.btnNext)
			end

			if arg2_118 then
				arg0_118.viewComponent:RefreshMapBG()
			end

			arg0_118:TryPlaySubGuide()
		end
	})
end

function var0_0.DisplayContinuousWindow(arg0_134, arg1_134, arg2_134, arg3_134, arg4_134)
	local var0_134 = arg1_134:getConfig("oil")
	local var1_134 = arg1_134:getPlayType()
	local var2_134 = 0
	local var3_134 = 0

	if var1_134 == ChapterConst.TypeMultiStageBoss then
		local var4_134 = pg.chapter_model_multistageboss[arg1_134.id]

		var2_134 = _.reduce(var4_134.boss_refresh, 0, function(arg0_135, arg1_135)
			return arg0_135 + arg1_135
		end)
		var3_134 = #var4_134.boss_refresh
	else
		var2_134, var3_134 = arg1_134:getConfig("boss_refresh"), 1
	end

	local var5_134 = arg1_134:getConfig("use_oil_limit")

	table.Foreach(arg2_134, function(arg0_136, arg1_136)
		local var0_136 = arg4_134[arg0_136]

		if var0_136 == ChapterFleet.DUTY_IDLE then
			return
		end

		local var1_136 = arg1_136:GetCostSum().oil

		if var0_136 == ChapterFleet.DUTY_KILLALL then
			local var2_136 = var5_134[1] or 0
			local var3_136 = var1_136

			if var2_136 > 0 then
				var3_136 = math.min(var3_136, var2_136)
			end

			local var4_136 = var5_134[2] or 0
			local var5_136 = var1_136

			if var4_136 > 0 then
				var5_136 = math.min(var5_136, var4_136)
			end

			var0_134 = var0_134 + var3_136 * var2_134 + var5_136 * var3_134
		elseif var0_136 == ChapterFleet.DUTY_CLEANPATH then
			local var6_136 = var5_134[1] or 0
			local var7_136 = var1_136

			if var6_136 > 0 then
				var7_136 = math.min(var7_136, var6_136)
			end

			var0_134 = var0_134 + var7_136 * var2_134
		elseif var0_136 == ChapterFleet.DUTY_KILLBOSS then
			local var8_136 = var5_134[2] or 0
			local var9_136 = var1_136

			if var8_136 > 0 then
				var9_136 = math.min(var9_136, var8_136)
			end

			var0_134 = var0_134 + var9_136 * var3_134
		end
	end)

	local var6_134 = arg1_134:GetMaxBattleCount()
	local var7_134 = arg3_134 and arg3_134 > 0
	local var8_134 = arg1_134:GetSpItems()
	local var9_134 = var8_134[1] and var8_134[1].count or 0
	local var10_134 = var8_134[1] and var8_134[1].id or 0
	local var11_134 = arg1_134:GetRestDailyBonus()

	arg0_134:addSubLayers(Context.New({
		mediator = LevelContinuousOperationWindowMediator,
		viewComponent = LevelContinuousOperationWindow,
		data = {
			maxCount = var6_134,
			oilCost = var0_134,
			chapter = arg1_134,
			extraRate = {
				rate = 2,
				enabled = var7_134,
				extraCount = var9_134,
				spItemId = var10_134,
				freeBonus = var11_134
			}
		}
	}))
end

function var0_0.DisplayContinuousOperationResult(arg0_137, arg1_137, arg2_137)
	local var0_137 = i18n("autofight_rewards")
	local var1_137 = i18n("total_rewards_subtitle")

	arg0_137:addSubLayers(Context.New({
		viewComponent = LevelContinuousOperationTotalRewardPanel,
		mediator = LevelStageTotalRewardPanelMediator,
		data = {
			title = var0_137,
			subTitle = var1_137,
			chapter = arg1_137,
			rewards = arg2_137:GetDrops(),
			resultRewards = arg2_137:GetSettlementDrops(),
			continuousData = arg2_137,
			events = arg2_137:GetEvents(1),
			guildTasks = arg2_137:GetEvents(2),
			guildAutoReceives = arg2_137:GetEvents(3)
		}
	}), true)
end

function var0_0.OnEventUpdate(arg0_138, arg1_138)
	local var0_138 = getProxy(EventProxy)

	arg0_138.viewComponent:updateEvent(var0_138)

	if pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_138.player.level, "EventMediator") and var0_138.eventForMsg then
		local var1_138 = var0_138.eventForMsg.id or 0
		local var2_138 = getProxy(ChapterProxy):getActiveChapter(true)

		if var2_138 and var2_138:IsAutoFight() then
			getProxy(ChapterProxy):AddExtendChapterDataArray(var2_138.id, "ListEventNotify", var1_138)
			existCall(arg1_138)
		else
			local var3_138 = pg.collection_template[var1_138] and pg.collection_template[var1_138].title or ""

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = false,
				hideNo = true,
				content = i18n("event_special_update", var3_138),
				onYes = arg1_138,
				onNo = arg1_138
			})
		end

		var0_138.eventForMsg = nil
	else
		existCall(arg1_138)
	end
end

function var0_0.onTimeUp(arg0_139)
	local var0_139 = getProxy(ChapterProxy):getActiveChapter()

	if var0_139 and not var0_139:inWartime() then
		local function var1_139()
			arg0_139:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		end

		if arg0_139.contextData.chapterVO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = var1_139,
				onNo = var1_139
			})
		else
			var1_139()
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_timeout"))
		end
	end
end

function var0_0.getDockCallbackFuncs(arg0_141, arg1_141, arg2_141, arg3_141, arg4_141)
	local var0_141 = getProxy(ChapterProxy)

	local function var1_141(arg0_142, arg1_142)
		local var0_142, var1_142 = ShipStatus.ShipStatusCheck("inElite", arg0_142, arg1_142, {
			inElite = arg3_141:getConfig("formation")
		})

		if not var0_142 then
			return var0_142, var1_142
		end

		for iter0_142, iter1_142 in pairs(arg1_141) do
			if arg0_142:isSameKind(iter0_142) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_141(arg0_143, arg1_143, arg2_143)
		arg1_143()
	end

	local function var3_141(arg0_144)
		local var0_144 = arg3_141:getEliteFleetList()[arg4_141]

		if arg2_141 then
			local var1_144 = table.indexof(var0_144, arg2_141.id)

			assert(var1_144)

			if arg0_144[1] then
				var0_144[var1_144] = arg0_144[1]
			else
				table.remove(var0_144, var1_144)
			end
		else
			table.insert(var0_144, arg0_144[1])
		end

		arg3_141:setEliteFleetByIndex(arg4_141, {
			{
				TeamType.FormShips,
				var0_144
			}
		})
		var0_141:updateChapter(arg3_141)
		var0_141:duplicateEliteFleet(arg3_141)
	end

	return var1_141, var2_141, var3_141
end

function var0_0.getSupportDockCallbackFuncs(arg0_145, arg1_145, arg2_145, arg3_145)
	local var0_145 = getProxy(ChapterProxy)

	local function var1_145(arg0_146, arg1_146)
		local var0_146, var1_146 = ShipStatus.ShipStatusCheck("inSupport", arg0_146, arg1_146)

		if not var0_146 then
			return var0_146, var1_146
		end

		for iter0_146, iter1_146 in pairs(arg1_145) do
			if arg0_146:isSameKind(iter0_146) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_145(arg0_147, arg1_147, arg2_147)
		arg1_147()
	end

	local function var3_145(arg0_148)
		local var0_148 = arg3_145:getSupportFleet()

		if arg2_145 then
			local var1_148 = table.indexof(var0_148, arg2_145.id)

			assert(var1_148)

			if arg0_148[1] then
				var0_148[var1_148] = arg0_148[1]
			else
				table.remove(var0_148, var1_148)
			end
		else
			table.insert(var0_148, arg0_148[1])
		end

		arg3_145:setEliteFleetByIndex(4, {
			{
				TeamType.FormShips,
				var0_148
			}
		})
		var0_145:updateChapter(arg3_145)
		var0_145:duplicateEliteFleet(arg3_145)
	end

	return var1_145, var2_145, var3_145
end

function var0_0.playAIActions(arg0_149, arg1_149, arg2_149, arg3_149)
	if not arg0_149.viewComponent.grid then
		arg3_149()

		return
	end

	local var0_149 = getProxy(ChapterProxy)
	local var1_149

	local function var2_149()
		if var1_149 and coroutine.status(var1_149) == "suspended" then
			local var0_150, var1_150 = coroutine.resume(var1_149)

			assert(var0_150, debug.traceback(var1_149, var1_150))

			if not var0_150 then
				arg0_149.viewComponent:unfrozen(-1)
				arg0_149:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest
				})
			end
		end
	end

	var1_149 = coroutine.create(function()
		arg0_149.viewComponent:frozen()

		local var0_151 = {}
		local var1_151 = arg2_149 or 0

		for iter0_151, iter1_151 in ipairs(arg1_149) do
			local var2_151 = arg0_149.contextData.chapterVO
			local var3_151, var4_151 = iter1_151:applyTo(var2_151, true)

			assert(var3_151, var4_151)
			iter1_151:PlayAIAction(arg0_149.contextData.chapterVO, arg0_149, function()
				local var0_152, var1_152, var2_152 = iter1_151:applyTo(var2_151, false)

				if var0_152 then
					var0_149:updateChapter(var2_151, var1_152)

					var1_151 = bit.bor(var1_151, var2_152 or 0)
				end

				onNextTick(var2_149)
			end)
			coroutine.yield()

			if isa(iter1_151, FleetAIAction) and iter1_151.actType == ChapterConst.ActType_Poison and var2_151:existFleet(FleetType.Normal, iter1_151.line.row, iter1_151.line.column) then
				local var5_151 = var2_151:getFleetIndex(FleetType.Normal, iter1_151.line.row, iter1_151.line.column)

				table.insert(var0_151, var5_151)
			end
		end

		local var6_151 = bit.band(var1_151, ChapterConst.DirtyAutoAction)

		var1_151 = bit.band(var1_151, bit.bnot(ChapterConst.DirtyAutoAction))

		if var1_151 ~= 0 then
			local var7_151 = arg0_149.contextData.chapterVO

			var0_149:updateChapter(var7_151, var1_151)
		end

		seriesAsync({
			function(arg0_153)
				if var6_151 ~= 0 then
					arg0_149.viewComponent.levelStageView:tryAutoAction(arg0_153)
				else
					arg0_153()
				end
			end,
			function(arg0_154)
				table.ParallelIpairsAsync(var0_151, function(arg0_155, arg1_155, arg2_155)
					arg0_149.viewComponent.grid:showFleetPoisonDamage(arg1_155, arg2_155)
				end, arg0_154)
			end,
			function(arg0_156)
				arg3_149()
				arg0_149.viewComponent:unfrozen()
			end
		})
	end)

	var2_149()
end

function var0_0.saveSubState(arg0_157, arg1_157)
	local var0_157 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("chapter_submarine_ai_type_" .. var0_157, arg1_157 + 1)
	PlayerPrefs.Save()
end

function var0_0.loadSubState(arg0_158, arg1_158)
	local var0_158 = getProxy(PlayerProxy):getRawData().id
	local var1_158 = PlayerPrefs.GetInt("chapter_submarine_ai_type_" .. var0_158, 1) - 1
	local var2_158 = math.clamp(var1_158, 0, 1)

	if var2_158 ~= arg1_158 then
		arg0_158.viewComponent:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSubState,
			arg1 = var2_158
		})
	end
end

function var0_0.remove(arg0_159)
	arg0_159:removeSubLayers(LevelContinuousOperationWindowMediator)
	var0_0.super.remove(arg0_159)
end

return var0_0
