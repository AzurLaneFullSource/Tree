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
var0_0.ON_ELITE_OEPN_DECK = "LevelMediator2:ON_ELITE_OEPN_DECK"
var0_0.ON_ELITE_CLEAR = "LevelMediator2:ON_ELITE_CLEAR"
var0_0.ON_ELITE_RECOMMEND = "LevelMediator2:ON_ELITE_RECOMMEND"
var0_0.ON_ELITE_ADJUSTMENT = "LevelMediator2:ON_ELITE_ADJUSTMENT"
var0_0.ON_SUPPORT_OPEN_DECK = "LevelMediator2:ON_SUPPORT_OPEN_DECK"
var0_0.ON_SUPPORT_CLEAR = "LevelMediator2:ON_SUPPORT_CLEAR"
var0_0.ON_SUPPORT_RECOMMEND = "LevelMediator2:ON_SUPPORT_RECOMMEND"
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
		local var0_14 = getProxy(ChapterProxy)
		local var1_14
		local var2_14 = Map.lastMap and var0_14:getMapById(Map.lastMap)

		if var2_14 and var2_14:isUnlock() and var2_14:getMapType() == Map.SCENARIO then
			var1_14 = Map.lastMap
		else
			var1_14 = var0_14:getLastUnlockMap().id
		end

		if var1_14 then
			arg0_1.viewComponent:setMap(var1_14)
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
	arg0_1:bind(var0_0.ON_SUPPORT_CLEAR, function(arg0_34, arg1_34)
		local var0_34 = arg1_34.index
		local var1_34 = arg1_34.chapterVO

		var1_34:ClearSupportFleetList(var0_34)

		local var2_34 = getProxy(ChapterProxy)

		var2_34:updateChapter(var1_34)
		var2_34:duplicateSupportFleet(var1_34)
		arg0_1.viewComponent:RefreshFleetSelectView(var1_34)
	end)
	arg0_1:bind(var0_0.ON_SUPPORT_RECOMMEND, function(arg0_35, arg1_35)
		local var0_35 = arg1_35.index
		local var1_35 = arg1_35.chapterVO
		local var2_35 = getProxy(ChapterProxy)

		var2_35:SupportFleetRecommend(var1_35, var0_35)
		var2_35:updateChapter(var1_35)
		var2_35:duplicateSupportFleet(var1_35)
		arg0_1.viewComponent:RefreshFleetSelectView(var1_35)
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_MAP, function()
		local var0_36 = getProxy(ChapterProxy)
		local var1_36, var2_36 = var0_36:getLastMapForActivity()

		if not var1_36 or not var0_36:getMapById(var1_36):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end

		arg0_1.viewComponent:ShowSelectedMap(var1_36, function()
			if var2_36 then
				local var0_37 = var0_36:getChapterById(var2_36)

				arg0_1.viewComponent:switchToChapter(var0_37)
			end
		end)
	end)
	arg0_1:bind(var0_0.ON_BOSSRUSH_MAP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
	end)
	arg0_1:bind(var0_0.ON_BOSSSINGLE_MAP, function(arg0_39, arg1_39)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP, arg1_39)
	end)
	arg0_1:bind(var0_0.GO_ACT_SHOP, function()
		local var0_40 = pg.gameset.activity_res_id.key_value
		local var1_40 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		if var1_40 and var1_40:getConfig("config_client").resId == var0_40 and not var1_40:isEnd() then
			arg0_1:addSubLayers(Context.New({
				mediator = LotteryMediator,
				viewComponent = LotteryLayer,
				data = {
					activityId = var1_40.id
				}
			}), false)
		else
			local var2_40 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_41)
				return arg0_41:getConfig("config_client").pt_id == var0_40
			end)
			local var3_40 = var2_40 and var2_40.id

			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = var3_40
			})
		end
	end)
	arg0_1:bind(var0_0.SHOW_ATELIER_BUFF, function(arg0_42)
		arg0_1:addSubLayers(Context.New({
			mediator = AtelierBuffMediator,
			viewComponent = AtelierBuffLayer
		}))
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
	arg0_1:bind(var0_0.ON_PERFORM_COMBAT, function(arg0_53, arg1_53, arg2_53)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_53,
			exitCallback = arg2_53
		})
	end)
	arg0_1:bind(var0_0.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN, function(arg0_54)
		arg0_1:sendNotification(GAME.GET_REMASTER_TICKETS)
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_55, arg1_55)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_55)
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_56)
		local var0_56 = getProxy(ChapterProxy):getActiveChapter()

		assert(var0_56)

		local var1_56 = var0_56.fleet
		local var2_56 = var0_56:getStageId(var1_56.line.row, var1_56.line.column)

		seriesAsync({
			function(arg0_57)
				local var0_57 = {}

				for iter0_57, iter1_57 in pairs(var1_56.ships) do
					table.insert(var0_57, iter1_57)
				end

				Fleet.EnergyCheck(var0_57, var1_56.name, function(arg0_58)
					if arg0_58 then
						arg0_57()
					end
				end, function(arg0_59)
					if not arg0_59 then
						getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.SHIP_ENERGY_LOW)
					end
				end)
			end,
			function(arg0_60)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0_60 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.GOLD_MAX)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0_60,
						onYes = arg0_60,
						weight = LayerWeightConst.SECOND_LAYER
					})
				else
					arg0_60()
				end
			end,
			function(arg0_61)
				arg0_1:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_SCENARIO,
					stageId = var2_56
				})
			end
		})
	end)
	arg0_1:bind(arg0_1.ON_ENTER_MAINLEVEL, function(arg0_62, arg1_62)
		arg0_1:DidEnterLevelMainUI(arg1_62)
	end)
	arg0_1:bind(arg0_1.ON_DIDENTER, function(arg0_63)
		arg0_1.viewComponent:emit(LevelMediator2.UPDATE_EVENT_LIST)
	end)
	arg0_1:bind(var0_0.ENTER_WORLD, function(arg0_64)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
	end)
	arg0_1:bind(var0_0.ON_CHAPTER_REMASTER_AWARD, function(arg0_65, arg1_65, arg2_65)
		arg0_1:sendNotification(GAME.CHAPTER_REMASTER_AWARD_RECEIVE, {
			chapterId = arg1_65,
			pos = arg2_65
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_ACT_BOSS_BATTLE, function(arg0_66)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACT_BOSS_BATTLE, {
			showAni = true
		})
	end)
	arg0_1:bind(LevelUIConst.OPEN_NORMAL_CONTINUOUS_WINDOW, function(arg0_67, arg1_67, arg2_67, arg3_67, arg4_67)
		local var0_67 = _.map(arg2_67, function(arg0_68)
			local var0_68 = getProxy(FleetProxy):getFleetById(arg0_68)

			if not var0_68 or var0_68:getFleetType() == FleetType.Submarine then
				return
			end

			return var0_68
		end)

		arg0_1:DisplayContinuousWindow(arg1_67, var0_67, arg3_67, arg4_67)
	end)
	arg0_1:bind(LevelUIConst.OPEN_ELITE_CONTINUOUS_WINDOW, function(arg0_69, arg1_69, arg2_69, arg3_69)
		local var0_69 = arg1_69:getEliteFleetList()
		local var1_69 = getProxy(BayProxy):getRawData()
		local var2_69 = _.map(var0_69, function(arg0_70)
			if #arg0_70 == 0 or _.any(arg0_70, function(arg0_71)
				local var0_71 = var1_69[arg0_71]

				return var0_71 and var0_71:getTeamType() == TeamType.Submarine
			end) then
				return
			end

			return TypedFleet.New({
				fleetType = FleetType.Normal,
				ship_list = arg0_70
			})
		end)

		arg0_1:DisplayContinuousWindow(arg1_69, var2_69, arg2_69, arg3_69)
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

	local var6_1 = var4_1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK)

	for iter0_1, iter1_1 in ipairs(var6_1) do
		if iter1_1:getConfig("config_id") == pg.gameset.activity_res_id.key_value then
			arg0_1.viewComponent:updatePtActivity(iter1_1)

			break
		end
	end

	local var7_1 = getProxy(DailyLevelProxy)

	arg0_1.viewComponent:setEliteQuota(var7_1.eliteCount, pg.gameset.elite_quota.key_value)
	getProxy(ChapterProxy):updateActiveChapterShips()

	local var8_1 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)

	arg0_1.viewComponent:setSpecialOperationTickets(var8_1)
end

function var0_0.DidEnterLevelMainUI(arg0_72, arg1_72)
	arg0_72.viewComponent:setMap(arg1_72)

	local var0_72 = arg0_72.contextData.chapterVO

	if var0_72 and var0_72.active then
		arg0_72.viewComponent:switchToChapter(var0_72)
	elseif arg0_72.contextData.map:isSkirmish() then
		arg0_72.viewComponent:ShowCurtains(true)
		arg0_72.viewComponent:doPlayAnim("TV01", function(arg0_73)
			go(arg0_73):SetActive(false)
			arg0_72.viewComponent:ShowCurtains(false)
		end)
	end

	if arg0_72.contextData.preparedTaskList and #arg0_72.contextData.preparedTaskList > 0 then
		for iter0_72, iter1_72 in ipairs(arg0_72.contextData.preparedTaskList) do
			arg0_72:sendNotification(GAME.SUBMIT_TASK, iter1_72)
		end

		table.clean(arg0_72.contextData.preparedTaskList)
	end

	if arg0_72.contextData.StopAutoFightFlag then
		local var1_72 = getProxy(ChapterProxy)
		local var2_72 = var1_72:getActiveChapter()

		if var2_72 then
			var1_72:SetChapterAutoFlag(var2_72.id, false)

			local var3_72 = bit.bor(ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

			arg0_72.viewComponent:updateChapterVO(var2_72, var3_72)
		end

		arg0_72.contextData.StopAutoFightFlag = nil
	end

	if arg0_72.contextData.ToTrackingData then
		arg0_72:sendNotification(arg0_72.contextData.ToTrackingData[1], arg0_72.contextData.ToTrackingData[2])

		arg0_72.contextData.ToTrackingData = nil
	end
end

function var0_0.RegisterTrackEvent(arg0_74)
	arg0_74:bind(var0_0.ON_TRACKING, function(arg0_75, arg1_75, arg2_75, arg3_75, arg4_75, arg5_75)
		local var0_75 = getProxy(ChapterProxy):getChapterById(arg1_75, true)
		local var1_75 = getProxy(ChapterProxy):GetLastFleetIndex()

		arg0_74:sendNotification(GAME.TRACKING, {
			chapterId = arg1_75,
			fleetIds = var1_75,
			loopFlag = arg2_75,
			operationItem = arg3_75,
			duties = arg4_75,
			autoFightFlag = arg5_75
		})
	end)
	arg0_74:bind(var0_0.ON_ELITE_TRACKING, function(arg0_76, arg1_76, arg2_76, arg3_76, arg4_76, arg5_76)
		arg0_74:sendNotification(GAME.TRACKING, {
			chapterId = arg1_76,
			loopFlag = arg2_76,
			operationItem = arg3_76,
			duties = arg4_76,
			autoFightFlag = arg5_76
		})
	end)
	arg0_74:bind(var0_0.ON_RETRACKING, function(arg0_77, arg1_77, arg2_77)
		local var0_77 = arg1_77.duties
		local var1_77 = arg1_77:getConfig("type") == Chapter.CustomFleet
		local var2_77 = arg1_77:GetActiveSPItemID()

		if var1_77 then
			arg0_74.viewComponent:emit(LevelMediator2.ON_ELITE_TRACKING, arg1_77.id, arg1_77.loopFlag, var2_77, var0_77, arg2_77)
		else
			arg0_74.viewComponent:emit(LevelMediator2.ON_TRACKING, arg1_77.id, arg1_77.loopFlag, var2_77, var0_77, arg2_77)
		end
	end)
end

function var0_0.NoticeVoteBook(arg0_78, arg1_78)
	arg1_78()
end

function var0_0.TryPlaySubGuide(arg0_79)
	arg0_79.viewComponent:tryPlaySubGuide()
end

function var0_0.listNotificationInterests(arg0_80)
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

function var0_0.handleNotification(arg0_81, arg1_81)
	local var0_81 = arg1_81:getName()
	local var1_81 = arg1_81:getBody()

	if var0_81 == GAME.BEGIN_STAGE_DONE then
		arg0_81:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_81)
	elseif var0_81 == VoteProxy.VOTE_ORDER_BOOK_DELETE or VoteProxy.VOTE_ORDER_BOOK_UPDATE == var0_81 then
		arg0_81.viewComponent:updateVoteBookBtn()
	elseif var0_81 == PlayerProxy.UPDATED then
		arg0_81.viewComponent:updateRes(var1_81)
	elseif var0_81 == var0_0.ON_TRACKING or var0_81 == var0_0.ON_ELITE_TRACKING or var0_81 == var0_0.ON_RETRACKING then
		arg0_81.viewComponent:emit(var0_81, unpackEx(var1_81))
	elseif var0_81 == GAME.TRACKING_DONE then
		arg0_81.waitingTracking = nil

		arg0_81.viewComponent:resetLevelGrid()

		arg0_81.viewComponent.FirstEnterChapter = var1_81.id

		arg0_81.viewComponent:switchToChapter(var1_81)
	elseif var0_81 == ChapterProxy.CHAPTER_UPDATED then
		arg0_81.viewComponent:updateChapterVO(var1_81.chapter, var1_81.dirty)
	elseif var0_81 == GAME.COMMANDER_ELIT_FORMATION_OP_DONE then
		if arg0_81.contextData.commanderOPChapter then
			local var2_81 = getProxy(ChapterProxy):getChapterById(var1_81.chapterId)

			arg0_81.contextData.commanderOPChapter.eliteCommanderList = var2_81.eliteCommanderList

			arg0_81.viewComponent:RefreshFleetSelectView(arg0_81.contextData.commanderOPChapter)
		end
	elseif var0_81 == GAME.CHAPTER_OP_DONE then
		local var3_81

		local function var4_81()
			if var3_81 and coroutine.status(var3_81) == "suspended" then
				local var0_82, var1_82 = coroutine.resume(var3_81)

				assert(var0_82, debug.traceback(var3_81, var1_82))
			end
		end

		var3_81 = coroutine.create(function()
			local var0_83 = var1_81.type
			local var1_83 = arg0_81.contextData.chapterVO
			local var2_83 = var1_83:IsAutoFight()

			if var0_83 == ChapterConst.OpRetreat and not var1_81.id then
				var1_83 = var1_81.finalChapterLevelData

				if var1_81.exittype and var1_81.exittype == ChapterConst.ExitFromMap then
					arg0_81.viewComponent:setChapter(nil)
					arg0_81.viewComponent:updateChapterTF(var1_83.id)
					arg0_81:OnExitChapter(var1_83, var1_81.win, var1_81.extendData)

					return
				end

				if var1_83:existOni() then
					local var3_83 = var1_83:checkOniState()

					if var3_83 then
						arg0_81.viewComponent:displaySpResult(var3_83, var4_81)
						coroutine.yield()
					end
				end

				if var1_83:isPlayingWithBombEnemy() then
					arg0_81.viewComponent:displayBombResult(var4_81)
					coroutine.yield()
				end
			end

			local var4_83 = var1_81.items
			local var5_83

			if var4_83 and #var4_83 > 0 then
				if var0_83 == ChapterConst.OpBox then
					local var6_83 = var1_83.fleet.line
					local var7_83 = var1_83:getChapterCell(var6_83.row, var6_83.column)

					if pg.box_data_template[var7_83.attachmentId].type == ChapterConst.BoxDrop and ChapterConst.IsAtelierMap(arg0_81.contextData.map) then
						local var8_83 = _.filter(var4_83, function(arg0_84)
							return arg0_84.type == DROP_TYPE_RYZA_DROP
						end)

						if #var8_83 > 0 then
							var5_83 = AwardInfoLayer.TITLE.RYZA

							local var9_83 = math.random(#var8_83)
							local var10_83 = AtelierMaterial.New({
								configId = var8_83[var9_83].id
							}):GetVoices()

							if var10_83 and #var10_83 > 0 then
								local var11_83 = var10_83[math.random(#var10_83)]
								local var12_83, var13_83, var14_83 = ShipWordHelper.GetWordAndCV(var11_83[1], var11_83[2], nil, PLATFORM_CODE ~= PLATFORM_US)

								arg0_81.viewComponent:emit(LevelUIConst.ADD_TOAST_QUEUE, {
									iconScale = 0.75,
									Class = LevelStageAtelierMaterialToast,
									title = i18n("ryza_tip_toast_item_got"),
									desc = var14_83,
									voice = var13_83,
									icon = var11_83[3]
								})
							end
						end
					end
				end

				seriesAsync({
					function(arg0_85)
						getProxy(ChapterProxy):AddExtendChapterDataArray(var1_83.id, "TotalDrops", _.filter(var4_83, function(arg0_86)
							return arg0_86.type ~= DROP_TYPE_STRATEGY
						end))
						arg0_81.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
							items = var4_83,
							title = var5_83,
							closeOnCompleted = var2_83,
							removeFunc = arg0_85
						})
					end,
					function(arg0_87)
						if var0_83 == ChapterConst.OpBox and _.any(var4_83, function(arg0_88)
							if arg0_88.type ~= DROP_TYPE_VITEM then
								return false
							end

							return arg0_88:getConfig("virtual_type") == 1
						end) then
							(function()
								local var0_89 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

								if not var0_89 then
									return
								end

								local var1_89 = pg.activity_event_picturepuzzle[var0_89.id]

								if not var1_89 then
									return
								end

								if #table.mergeArray(var0_89.data1_list, var0_89.data2_list, true) < #var1_89.pickup_picturepuzzle + #var1_89.drop_picturepuzzle then
									return
								end

								local var2_89 = var0_89:getConfig("config_client").comStory

								pg.NewStoryMgr.GetInstance():Play(var2_89, arg0_87)
							end)()
						end

						if _.any(var4_83, function(arg0_90)
							if arg0_90.type ~= DROP_TYPE_STRATEGY then
								return false
							end

							return pg.strategy_data_template[arg0_90.id].type == ChapterConst.StgTypeConsume
						end) then
							arg0_81.viewComponent.levelStageView:popStageStrategy()
						end

						arg0_87()
					end
				}, var4_81)
				coroutine.yield()
			end

			assert(var1_83)

			if var0_83 == ChapterConst.OpSkipBattle or var0_83 == ChapterConst.OpPreClear then
				arg0_81.viewComponent.levelStageView:tryAutoAction(function()
					if not arg0_81.viewComponent.levelStageView then
						return
					end

					arg0_81.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_83 == ChapterConst.OpRetreat then
				local var15_83 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

				if var15_83 then
					local var16_83 = {}
					local var17_83 = var15_83:getContextByMediator(ChapterPreCombatMediator)

					if var17_83 then
						table.insert(var16_83, var17_83)
					end

					_.each(var16_83, function(arg0_92)
						arg0_81:sendNotification(GAME.REMOVE_LAYERS, {
							context = arg0_92
						})
					end)
				end

				if var1_81.id then
					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)

					return
				end

				local var18_83 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN)

				if var18_83 and not var18_83.autoActionForbidden and not var18_83.achieved and var18_83.data1 == 7 and var1_83.id == 204 and var1_83:isClear() then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						hideNo = true,
						content = "有新的签到奖励可以领取，点击确定前往",
						onYes = function()
							arg0_81:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end,
						onNo = function()
							arg0_81:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end
					})

					return
				end

				arg0_81:OnExitChapter(var1_83, var1_81.win, var1_81.extendData)
			elseif var0_83 == ChapterConst.OpMove then
				seriesAsync({
					function(arg0_95)
						var1_83 = arg0_81.contextData.chapterVO

						local var0_95 = var1_81.fullpath[#var1_81.fullpath]

						var1_83.fleet.line = Clone(var0_95)

						getProxy(ChapterProxy):updateChapter(var1_83)
						arg0_81.viewComponent.grid:moveFleet(var1_81.path, var1_81.fullpath, var1_81.oldLine, arg0_95)
					end,
					function(arg0_96)
						if not var1_81.teleportPaths then
							arg0_96()

							return
						end

						local var0_96 = var1_81.teleportPaths[1]
						local var1_96 = var1_81.teleportPaths[2]

						if not var0_96 or not var1_96 then
							arg0_96()

							return
						end

						var1_83 = arg0_81.contextData.chapterVO

						local var2_96 = var1_83:getFleet(FleetType.Normal, var0_96.row, var0_96.column)

						if not var2_96 then
							arg0_96()

							return
						end

						var2_96.line = Clone(var1_81.teleportPaths[2])

						getProxy(ChapterProxy):updateChapter(var1_83)

						local var3_96 = arg0_81:getViewComponent().grid:GetCellFleet(var2_96.id)

						arg0_81:getViewComponent().grid:TeleportCellByPortalWithCameraMove(var2_96, var3_96, var1_81.teleportPaths, arg0_96)
					end,
					function(arg0_97)
						arg0_81:playAIActions(var1_81.aiActs, var1_81.extraFlag, arg0_97)
					end
				}, function()
					var1_83 = arg0_81.contextData.chapterVO

					local var0_98 = var1_83.fleet:getStrategies()

					if _.any(var0_98, function(arg0_99)
						return arg0_99.id == ChapterConst.StrategyExchange and arg0_99.count > 0
					end) then
						arg0_81.viewComponent.levelStageView:popStageStrategy()
					end

					arg0_81.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					arg0_81.viewComponent.levelStageView:updateAmbushRate(var1_83.fleet.line, true)
					arg0_81.viewComponent.levelStageView:updateStageStrategy()
					arg0_81.viewComponent.levelStageView:updateFleetBuff()
					arg0_81.viewComponent.levelStageView:updateBombPanel()
					arg0_81.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_83 == ChapterConst.OpAmbush then
				arg0_81.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_83 == ChapterConst.OpBox then
				arg0_81:playAIActions(var1_81.aiActs, var1_81.extraFlag, function()
					if not arg0_81.viewComponent.levelStageView then
						return
					end

					arg0_81.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0_83 == ChapterConst.OpStory then
				arg0_81.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_83 == ChapterConst.OpSwitch then
				arg0_81.viewComponent.grid:adjustCameraFocus()
			elseif var0_83 == ChapterConst.OpEnemyRound then
				arg0_81:playAIActions(var1_81.aiActs, var1_81.extraFlag, function()
					arg0_81.viewComponent.levelStageView:updateBombPanel(true)

					local var0_101 = var1_83.fleet:getStrategies()

					if _.any(var0_101, function(arg0_102)
						return arg0_102.id == ChapterConst.StrategyExchange and arg0_102.count > 0
					end) then
						arg0_81.viewComponent.levelStageView:updateStageStrategy()
						arg0_81.viewComponent.levelStageView:popStageStrategy()
					end

					arg0_81.viewComponent.levelStageView:tryAutoTrigger()
					arg0_81.viewComponent:updatePoisonAreaTip()
				end)
			elseif var0_83 == ChapterConst.OpSubState then
				arg0_81:saveSubState(var1_83.subAutoAttack)
				arg0_81.viewComponent.grid:OnChangeSubAutoAttack()
			elseif var0_83 == ChapterConst.OpStrategy then
				if var1_81.arg1 == ChapterConst.StrategyExchange then
					local var19_83 = var1_83.fleet:findSkills(FleetSkill.TypeStrategy)

					for iter0_83, iter1_83 in ipairs(var19_83) do
						if iter1_83:GetType() == FleetSkill.TypeStrategy and iter1_83:GetArgs()[1] == ChapterConst.StrategyExchange then
							local var20_83 = var1_83.fleet:findCommanderBySkillId(iter1_83.id)

							arg0_81.viewComponent:doPlayCommander(var20_83)

							break
						end
					end
				end

				arg0_81:playAIActions(var1_81.aiActs, var1_81.extraFlag, function()
					arg0_81.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				end)
			elseif var0_83 == ChapterConst.OpSupply then
				arg0_81.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_83 == ChapterConst.OpBarrier then
				arg0_81.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0_83 == ChapterConst.OpSubTeleport then
				seriesAsync({
					function(arg0_104)
						local var0_104 = _.detect(var1_83.fleets, function(arg0_105)
							return arg0_105.id == var1_81.id
						end)

						var0_104.line = {
							row = var1_81.arg1,
							column = var1_81.arg2
						}
						var0_104.startPos = {
							row = var1_81.arg1,
							column = var1_81.arg2
						}

						local var1_104 = var1_81.fullpath[1]
						local var2_104 = var1_81.fullpath[#var1_81.fullpath]
						local var3_104 = var1_83:findPath(nil, var1_104, var2_104)
						local var4_104 = pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2]
						local var5_104 = math.ceil(var4_104 * #var0_104:getShips(false) * var3_104 - 1e-05)
						local var6_104 = getProxy(PlayerProxy)
						local var7_104 = var6_104:getData()

						var7_104:consume({
							oil = var5_104
						})
						arg0_81.viewComponent:updateRes(var7_104)
						var6_104:updatePlayer(var7_104)
						arg0_81.viewComponent.grid:moveSub(table.indexof(var1_83.fleets, var0_104), var1_81.fullpath, nil, function()
							local var0_106 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1_83, var0_106)

							var1_83 = arg0_81.contextData.chapterVO

							arg0_104()
						end)
					end,
					function(arg0_107)
						if not var1_81.teleportPaths then
							arg0_107()

							return
						end

						local var0_107 = var1_81.teleportPaths[1]
						local var1_107 = var1_81.teleportPaths[2]

						if not var0_107 or not var1_107 then
							arg0_107()

							return
						end

						local var2_107 = _.detect(var1_83.fleets, function(arg0_108)
							return arg0_108.id == var1_81.id
						end)

						var2_107.startPos = Clone(var1_81.teleportPaths[2])
						var2_107.line = Clone(var1_81.teleportPaths[2])

						local var3_107 = arg0_81:getViewComponent().grid:GetCellFleet(var2_107.id)

						arg0_81:getViewComponent().grid:TeleportFleetByPortal(var3_107, var1_81.teleportPaths, function()
							local var0_109 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1_83, var0_109)

							var1_83 = arg0_81.contextData.chapterVO

							arg0_107()
						end)
					end,
					function(arg0_110)
						arg0_81.viewComponent.levelStageView:SwitchBottomStagePanel(false)
						arg0_81.viewComponent.grid:TurnOffSubTeleport()
						arg0_81.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					end
				})
			end
		end)

		var4_81()
	elseif var0_81 == ChapterProxy.CHAPTER_TIMESUP then
		arg0_81:onTimeUp()
	elseif var0_81 == GAME.EVENT_LIST_UPDATE then
		arg0_81.viewComponent:addbubbleMsgBox(function(arg0_111)
			arg0_81:OnEventUpdate(arg0_111)
		end)
	elseif var0_81 == GAME.VOTE_BOOK_BE_UPDATED_DONE then
		arg0_81.viewComponent:addbubbleMsgBox(function(arg0_112)
			arg0_81:NoticeVoteBook(arg0_112)
		end)
	elseif var0_81 == DailyLevelProxy.ELITE_QUOTA_UPDATE then
		local var5_81 = getProxy(DailyLevelProxy)

		arg0_81.viewComponent:setEliteQuota(var5_81.eliteCount, pg.gameset.elite_quota.key_value)
	elseif var0_81 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_81.viewComponent:updateMapItems()
	elseif var0_81 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_81 and var1_81:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_RANK then
			arg0_81.viewComponent:updatePtActivity(var1_81)
		end
	elseif var0_81 == GAME.GET_REMASTER_TICKETS_DONE then
		arg0_81.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_81, function()
			arg0_81.viewComponent:updateRemasterTicket()
		end)
	elseif var0_81 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var6_81 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_81.viewComponent:setCommanderPrefabs(var6_81)
		arg0_81.viewComponent:updateCommanderPrefab()
	elseif var0_81 == GAME.COOMMANDER_EQUIP_TO_FLEET_DONE then
		local var7_81 = getProxy(FleetProxy):GetRegularFleets()

		arg0_81.viewComponent:updateFleet(var7_81)
		arg0_81.viewComponent:RefreshFleetSelectView()
	elseif var0_81 == GAME.SUBMIT_TASK_DONE then
		if arg0_81.contextData.map and arg0_81.contextData.map:isSkirmish() then
			arg0_81.viewComponent:updateMapItems()
		end

		arg0_81.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_81, function()
			if arg0_81.contextData.map and arg0_81.contextData.map:isSkirmish() and arg0_81.contextData.TaskToSubmit then
				local var0_114 = arg0_81.contextData.TaskToSubmit

				arg0_81.contextData.TaskToSubmit = nil

				arg0_81:sendNotification(GAME.SUBMIT_TASK, var0_114)
			end
		end)
	elseif var0_81 == BagProxy.ITEM_UPDATED then
		local var8_81 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)

		arg0_81.viewComponent:setSpecialOperationTickets(var8_81)
	elseif var0_81 == ChapterProxy.CHAPTER_AUTO_FIGHT_FLAG_UPDATED then
		if not arg0_81:getViewComponent().levelStageView then
			return
		end

		arg0_81:getViewComponent().levelStageView:ActionInvoke("UpdateAutoFightMark")
	elseif var0_81 == ChapterProxy.CHAPTER_SKIP_PRECOMBAT_UPDATED then
		if not arg0_81:getViewComponent().levelStageView then
			return
		end

		arg0_81:getViewComponent().levelStageView:ActionInvoke("UpdateSkipPreCombatMark")
	elseif var0_81 == ChapterProxy.CHAPTER_REMASTER_INFO_UPDATED or var0_81 == GAME.CHAPTER_REMASTER_INFO_REQUEST_DONE then
		arg0_81.viewComponent:updateRemasterInfo()
		arg0_81.viewComponent:updateRemasterBtnTip()
	elseif var0_81 == GAME.CHAPTER_REMASTER_AWARD_RECEIVE_DONE then
		arg0_81.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_81)
	elseif var0_81 == GAME.STORY_UPDATE_DONE then
		arg0_81.cachedStoryAwards = var1_81
	elseif var0_81 == GAME.STORY_END then
		if arg0_81.cachedStoryAwards then
			arg0_81.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_81.cachedStoryAwards.awards)

			arg0_81.cachedStoryAwards = nil
		end
	elseif var0_81 == LevelUIConst.CONTINUOUS_OPERATION then
		arg0_81.viewComponent:emit(LevelUIConst.CONTINUOUS_OPERATION, var1_81)
	elseif var0_81 == GAME.TRACKING_ERROR then
		if arg0_81.waitingTracking then
			arg0_81:DisplayContinuousOperationResult(var1_81.chapter, getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO))
		end

		arg0_81.waitingTracking = nil
	elseif var0_81 == var0_0.ON_SPITEM_CHANGED then
		arg0_81.viewComponent:emit(var0_0.ON_SPITEM_CHANGED, var1_81)
	end
end

function var0_0.OnExitChapter(arg0_115, arg1_115, arg2_115, arg3_115)
	assert(arg1_115)
	seriesAsync({
		function(arg0_116)
			if not arg0_115.contextData.chapterVO then
				return arg0_116()
			end

			arg0_115.viewComponent:switchToMap(arg0_116)
		end,
		function(arg0_117)
			arg0_115.viewComponent:addbubbleMsgBox(function()
				arg0_115.viewComponent:CleanBubbleMsgbox()
				arg0_117()
			end)
		end,
		function(arg0_119)
			if not arg2_115 then
				return arg0_119()
			end

			local var0_119 = getProxy(PlayerProxy):getData()

			if arg1_115.id == 103 and not var0_119:GetCommonFlag(BATTLE_AUTO_ENABLED) then
				arg0_115.viewComponent:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("battle_autobot_unlock"),
					onYes = arg0_119,
					onNo = arg0_119
				})
				arg0_115.viewComponent:emit(LevelMediator2.NOTICE_AUTOBOT_ENABLED, {})

				return
			end

			arg0_119()
		end,
		function(arg0_120)
			if not arg2_115 then
				return arg0_120()
			end

			if getProxy(ChapterProxy):getMapById(arg1_115:getConfig("map")):isSkirmish() then
				local var0_120 = arg1_115.id
				local var1_120 = getProxy(SkirmishProxy):getRawData()
				local var2_120 = _.detect(var1_120, function(arg0_121)
					return tonumber(arg0_121:getConfig("event")) == var0_120
				end)

				if not var2_120 then
					arg0_120()

					return
				end

				local var3_120 = getProxy(TaskProxy)
				local var4_120 = var2_120:getConfig("task_id")
				local var5_120 = var3_120:getTaskVO(var4_120)

				if var5_120 and var5_120:getTaskStatus() == 1 then
					arg0_115:sendNotification(GAME.SUBMIT_TASK, var4_120)

					if var2_120 == var1_120[#var1_120] then
						local var6_120 = getProxy(ActivityProxy)
						local var7_120 = ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE
						local var8_120 = var6_120:getActivityById(var7_120)

						assert(var8_120, "Missing Skirmish Activity " .. (var7_120 or "NIL"))

						local var9_120 = var8_120:getConfig("config_data")
						local var10_120 = var9_120[#var9_120][2]
						local var11_120 = var3_120:getTaskVO(var10_120)

						if var11_120 and var11_120:getTaskStatus() < 2 then
							arg0_115.contextData.TaskToSubmit = var10_120
						end
					end
				end
			end

			arg0_120()
		end,
		function(arg0_122)
			if not arg2_115 then
				return arg0_122()
			end

			local var0_122 = getProxy(ChapterProxy):getMapById(arg1_115:getConfig("map"))

			if var0_122:isRemaster() then
				local var1_122 = var0_122:getRemaster()
				local var2_122 = pg.re_map_template[var1_122]
				local var3_122 = Map.GetRearChaptersOfRemaster(var1_122)

				assert(var3_122)

				if _.any(var3_122, function(arg0_123)
					return arg0_123 == arg1_115.id
				end) then
					local var4_122 = var2_122.memory_group
					local var5_122 = pg.memory_group[var4_122].memories

					if _.any(var5_122, function(arg0_124)
						return not pg.NewStoryMgr.GetInstance():IsPlayed(pg.memory_template[arg0_124].story, true)
					end) then
						_.each(var5_122, function(arg0_125)
							local var0_125 = pg.memory_template[arg0_125].story
							local var1_125, var2_125 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0_125)

							pg.NewStoryMgr.GetInstance():SetPlayedFlag(var1_125)
						end)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							yesText = "text_go",
							content = i18n("levelScene_remaster_story_tip", pg.memory_group[var4_122].title),
							weight = LayerWeightConst.SECOND_LAYER,
							onYes = function()
								arg0_115:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
									page = WorldMediaCollectionScene.PAGE_MEMORTY,
									memoryGroup = var4_122
								})
							end,
							onNo = function()
								local var0_127 = getProxy(PlayerProxy):getRawData().id

								PlayerPrefs.SetInt("MEMORY_GROUP_NOTIFICATION" .. var0_127 .. " " .. var4_122, 1)
								PlayerPrefs.Save()
								arg0_122()
							end
						})

						return
					end
				end
			end

			arg0_122()
		end,
		function(arg0_128)
			if arg0_115.contextData.map and not arg0_115.contextData.map:isUnlock() then
				arg0_115.viewComponent:emit(var0_0.ON_SWITCH_NORMAL_MAP)

				return
			end

			if not arg3_115 then
				return arg0_128()
			end

			local var0_128 = arg3_115 and arg3_115.AutoFightFlag
			local var1_128 = {}

			if arg3_115 and arg3_115.ResultDrops then
				for iter0_128, iter1_128 in ipairs(arg3_115.ResultDrops) do
					var1_128 = table.mergeArray(var1_128, iter1_128)
				end
			end

			local var2_128 = {}

			if arg3_115 and arg3_115.TotalDrops then
				for iter2_128, iter3_128 in ipairs(arg3_115.TotalDrops) do
					var2_128 = table.mergeArray(var2_128, iter3_128)
				end
			end

			DropResultIntegration(var2_128)

			local var3_128 = getProxy(ChapterProxy):GetContinuousData(SYSTEM_SCENARIO)

			if var3_128 then
				var3_128:MergeDrops(var2_128, var1_128)
				var3_128:MergeEvents(arg3_115.ListEventNotify, arg3_115.ListGuildEventNotify, arg3_115.ListGuildEventAutoReceiveNotify)

				if arg2_115 then
					var3_128:ConsumeBattleTime()
				end

				if var3_128:IsActive() and var3_128:GetRestBattleTime() > 0 then
					arg0_115.waitingTracking = true

					arg0_115.viewComponent:emit(var0_0.ON_RETRACKING, arg1_115, var0_128)

					return
				end

				getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO)
				arg0_115:DisplayContinuousOperationResult(arg1_115, var3_128)
				arg0_128()

				return
			end

			local var4_128 = var0_128 ~= nil

			if not var4_128 and not arg3_115.ResultDrops then
				return arg0_128()
			end

			local var5_128
			local var6_128

			if var4_128 then
				var5_128 = i18n("autofight_rewards")
				var6_128 = i18n("total_rewards_subtitle")
			else
				var5_128 = i18n("settle_rewards_title")
				var6_128 = i18n("settle_rewards_subtitle")
			end

			arg0_115:addSubLayers(Context.New({
				viewComponent = LevelStageTotalRewardPanel,
				mediator = LevelStageTotalRewardPanelMediator,
				data = {
					title = var5_128,
					subTitle = var6_128,
					chapter = arg1_115,
					onClose = arg0_128,
					rewards = var2_128,
					resultRewards = var1_128,
					events = arg3_115.ListEventNotify,
					guildTasks = arg3_115.ListGuildEventNotify,
					guildAutoReceives = arg3_115.ListGuildEventAutoReceiveNotify,
					isAutoFight = var0_128
				}
			}), true)
		end,
		function(arg0_129)
			if Map.autoNextPage then
				Map.autoNextPage = nil

				triggerButton(arg0_115.viewComponent.btnNext)
			end

			if arg2_115 then
				arg0_115.viewComponent:RefreshMapBG()
			end

			arg0_115:TryPlaySubGuide()
		end
	})
end

function var0_0.DisplayContinuousWindow(arg0_130, arg1_130, arg2_130, arg3_130, arg4_130)
	local var0_130 = arg1_130:getConfig("oil")
	local var1_130 = arg1_130:getPlayType()
	local var2_130 = 0
	local var3_130 = 0

	if var1_130 == ChapterConst.TypeMultiStageBoss then
		local var4_130 = pg.chapter_model_multistageboss[arg1_130.id]

		var2_130 = _.reduce(var4_130.boss_refresh, 0, function(arg0_131, arg1_131)
			return arg0_131 + arg1_131
		end)
		var3_130 = #var4_130.boss_refresh
	else
		var2_130, var3_130 = arg1_130:getConfig("boss_refresh"), 1
	end

	local var5_130 = arg1_130:getConfig("use_oil_limit")

	table.Foreach(arg2_130, function(arg0_132, arg1_132)
		local var0_132 = arg4_130[arg0_132]

		if var0_132 == ChapterFleet.DUTY_IDLE then
			return
		end

		local var1_132 = arg1_132:GetCostSum().oil

		if var0_132 == ChapterFleet.DUTY_KILLALL then
			local var2_132 = var5_130[1] or 0
			local var3_132 = var1_132

			if var2_132 > 0 then
				var3_132 = math.min(var3_132, var2_132)
			end

			local var4_132 = var5_130[2] or 0
			local var5_132 = var1_132

			if var4_132 > 0 then
				var5_132 = math.min(var5_132, var4_132)
			end

			var0_130 = var0_130 + var3_132 * var2_130 + var5_132 * var3_130
		elseif var0_132 == ChapterFleet.DUTY_CLEANPATH then
			local var6_132 = var5_130[1] or 0
			local var7_132 = var1_132

			if var6_132 > 0 then
				var7_132 = math.min(var7_132, var6_132)
			end

			var0_130 = var0_130 + var7_132 * var2_130
		elseif var0_132 == ChapterFleet.DUTY_KILLBOSS then
			local var8_132 = var5_130[2] or 0
			local var9_132 = var1_132

			if var8_132 > 0 then
				var9_132 = math.min(var9_132, var8_132)
			end

			var0_130 = var0_130 + var9_132 * var3_130
		end
	end)

	local var6_130 = arg1_130:GetMaxBattleCount()
	local var7_130 = arg3_130 and arg3_130 > 0
	local var8_130 = arg1_130:GetSpItems()
	local var9_130 = var8_130[1] and var8_130[1].count or 0
	local var10_130 = var8_130[1] and var8_130[1].id or 0
	local var11_130 = arg1_130:GetRestDailyBonus()

	arg0_130:addSubLayers(Context.New({
		mediator = LevelContinuousOperationWindowMediator,
		viewComponent = LevelContinuousOperationWindow,
		data = {
			maxCount = var6_130,
			oilCost = var0_130,
			chapter = arg1_130,
			extraRate = {
				rate = 2,
				enabled = var7_130,
				extraCount = var9_130,
				spItemId = var10_130,
				freeBonus = var11_130
			}
		}
	}))
end

function var0_0.DisplayContinuousOperationResult(arg0_133, arg1_133, arg2_133)
	local var0_133 = i18n("autofight_rewards")
	local var1_133 = i18n("total_rewards_subtitle")

	arg0_133:addSubLayers(Context.New({
		viewComponent = LevelContinuousOperationTotalRewardPanel,
		mediator = LevelStageTotalRewardPanelMediator,
		data = {
			title = var0_133,
			subTitle = var1_133,
			chapter = arg1_133,
			rewards = arg2_133:GetDrops(),
			resultRewards = arg2_133:GetSettlementDrops(),
			continuousData = arg2_133,
			events = arg2_133:GetEvents(1),
			guildTasks = arg2_133:GetEvents(2),
			guildAutoReceives = arg2_133:GetEvents(3)
		}
	}), true)
end

function var0_0.OnEventUpdate(arg0_134, arg1_134)
	local var0_134 = getProxy(EventProxy)

	arg0_134.viewComponent:updateEvent(var0_134)

	if pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_134.player.level, "EventMediator") and var0_134.eventForMsg then
		local var1_134 = var0_134.eventForMsg.id or 0
		local var2_134 = getProxy(ChapterProxy):getActiveChapter(true)

		if var2_134 and var2_134:IsAutoFight() then
			getProxy(ChapterProxy):AddExtendChapterDataArray(var2_134.id, "ListEventNotify", var1_134)
			existCall(arg1_134)
		else
			local var3_134 = pg.collection_template[var1_134] and pg.collection_template[var1_134].title or ""

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = false,
				hideNo = true,
				content = i18n("event_special_update", var3_134),
				weight = LayerWeightConst.SECOND_LAYER,
				onYes = arg1_134,
				onNo = arg1_134
			})
		end

		var0_134.eventForMsg = nil
	else
		existCall(arg1_134)
	end
end

function var0_0.onTimeUp(arg0_135)
	local var0_135 = getProxy(ChapterProxy):getActiveChapter()

	if var0_135 and not var0_135:inWartime() then
		local function var1_135()
			arg0_135:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		end

		if arg0_135.contextData.chapterVO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = var1_135,
				onNo = var1_135
			})
		else
			var1_135()
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_timeout"))
		end
	end
end

function var0_0.getDockCallbackFuncs(arg0_137, arg1_137, arg2_137, arg3_137, arg4_137)
	local var0_137 = getProxy(ChapterProxy)

	local function var1_137(arg0_138, arg1_138)
		local var0_138, var1_138 = ShipStatus.ShipStatusCheck("inElite", arg0_138, arg1_138, {
			inElite = arg3_137:getConfig("formation")
		})

		if not var0_138 then
			return var0_138, var1_138
		end

		for iter0_138, iter1_138 in pairs(arg1_137) do
			if arg0_138:isSameKind(iter0_138) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2_137(arg0_139, arg1_139, arg2_139)
		arg1_139()
	end

	local function var3_137(arg0_140)
		local var0_140 = arg3_137:getEliteFleetList()[arg4_137]

		if arg2_137 then
			local var1_140 = table.indexof(var0_140, arg2_137.id)

			assert(var1_140)

			if arg0_140[1] then
				var0_140[var1_140] = arg0_140[1]
			else
				table.remove(var0_140, var1_140)
			end
		else
			table.insert(var0_140, arg0_140[1])
		end

		var0_137:updateChapter(arg3_137)
		var0_137:duplicateEliteFleet(arg3_137)
	end

	return var1_137, var2_137, var3_137
end

function var0_0.getSupportDockCallbackFuncs(arg0_141, arg1_141, arg2_141, arg3_141)
	local var0_141 = getProxy(ChapterProxy)

	local function var1_141(arg0_142, arg1_142)
		local var0_142, var1_142 = ShipStatus.ShipStatusCheck("inSupport", arg0_142, arg1_142)

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
		local var0_144 = arg3_141:getSupportFleet()

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

		var0_141:updateChapter(arg3_141)
		var0_141:duplicateSupportFleet(arg3_141)
	end

	return var1_141, var2_141, var3_141
end

function var0_0.playAIActions(arg0_145, arg1_145, arg2_145, arg3_145)
	if not arg0_145.viewComponent.grid then
		arg3_145()

		return
	end

	local var0_145 = getProxy(ChapterProxy)
	local var1_145

	local function var2_145()
		if var1_145 and coroutine.status(var1_145) == "suspended" then
			local var0_146, var1_146 = coroutine.resume(var1_145)

			assert(var0_146, debug.traceback(var1_145, var1_146))

			if not var0_146 then
				arg0_145.viewComponent:unfrozen(-1)
				arg0_145:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest
				})
			end
		end
	end

	var1_145 = coroutine.create(function()
		arg0_145.viewComponent:frozen()

		local var0_147 = {}
		local var1_147 = arg2_145 or 0

		for iter0_147, iter1_147 in ipairs(arg1_145) do
			local var2_147 = arg0_145.contextData.chapterVO
			local var3_147, var4_147 = iter1_147:applyTo(var2_147, true)

			assert(var3_147, var4_147)
			iter1_147:PlayAIAction(arg0_145.contextData.chapterVO, arg0_145, function()
				local var0_148, var1_148, var2_148 = iter1_147:applyTo(var2_147, false)

				if var0_148 then
					var0_145:updateChapter(var2_147, var1_148)

					var1_147 = bit.bor(var1_147, var2_148 or 0)
				end

				onNextTick(var2_145)
			end)
			coroutine.yield()

			if isa(iter1_147, FleetAIAction) and iter1_147.actType == ChapterConst.ActType_Poison and var2_147:existFleet(FleetType.Normal, iter1_147.line.row, iter1_147.line.column) then
				local var5_147 = var2_147:getFleetIndex(FleetType.Normal, iter1_147.line.row, iter1_147.line.column)

				table.insert(var0_147, var5_147)
			end
		end

		local var6_147 = bit.band(var1_147, ChapterConst.DirtyAutoAction)

		var1_147 = bit.band(var1_147, bit.bnot(ChapterConst.DirtyAutoAction))

		if var1_147 ~= 0 then
			local var7_147 = arg0_145.contextData.chapterVO

			var0_145:updateChapter(var7_147, var1_147)
		end

		seriesAsync({
			function(arg0_149)
				if var6_147 ~= 0 then
					arg0_145.viewComponent.levelStageView:tryAutoAction(arg0_149)
				else
					arg0_149()
				end
			end,
			function(arg0_150)
				table.ParallelIpairsAsync(var0_147, function(arg0_151, arg1_151, arg2_151)
					arg0_145.viewComponent.grid:showFleetPoisonDamage(arg1_151, arg2_151)
				end, arg0_150)
			end,
			function(arg0_152)
				arg3_145()
				arg0_145.viewComponent:unfrozen()
			end
		})
	end)

	var2_145()
end

function var0_0.saveSubState(arg0_153, arg1_153)
	local var0_153 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("chapter_submarine_ai_type_" .. var0_153, arg1_153 + 1)
	PlayerPrefs.Save()
end

function var0_0.loadSubState(arg0_154, arg1_154)
	local var0_154 = getProxy(PlayerProxy):getRawData().id
	local var1_154 = PlayerPrefs.GetInt("chapter_submarine_ai_type_" .. var0_154, 1) - 1
	local var2_154 = math.clamp(var1_154, 0, 1)

	if var2_154 ~= arg1_154 then
		arg0_154.viewComponent:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSubState,
			arg1 = var2_154
		})
	end
end

function var0_0.remove(arg0_155)
	arg0_155:removeSubLayers(LevelContinuousOperationWindowMediator)
	var0_0.super.remove(arg0_155)
end

return var0_0
