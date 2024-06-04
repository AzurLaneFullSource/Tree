local var0 = class("LevelMediator2", import("..base.ContextMediator"))

var0.ON_TRACKING = "LevelMediator2:ON_TRACKING"
var0.ON_ELITE_TRACKING = "LevelMediator2:ON_ELITE_TRACKING"
var0.ON_RETRACKING = "LevelMediator2:ON_RETRACKING"
var0.ON_UPDATE_CUSTOM_FLEET = "LevelMediator2:ON_UPDATE_CUSTOM_FLEET"
var0.ON_OP = "LevelMediator2:ON_OP"
var0.ON_RESUME_SUBSTATE = "LevelMediator2:ON_RESUME_SUBSTATE"
var0.ON_STAGE = "LevelMediator2:ON_STAGE"
var0.ON_GO_TO_TASK_SCENE = "LevelMediator2:ON_GO_TO_TASK_SCENE"
var0.ON_OPEN_EVENT_SCENE = "LevelMediator2:ON_OPEN_EVENT_SCENE"
var0.ON_DAILY_LEVEL = "LevelMediator2:ON_DAILY_LEVEL"
var0.ON_OPEN_MILITARYEXERCISE = "LevelMediator2:ON_OPEN_MILLITARYEXERCISE"
var0.ON_OVERRIDE_CHAPTER = "LevelMediator2:ON_OVERRIDE_CHAPTER"
var0.ON_TIME_UP = "LevelMediator2:ON_TIME_UP"
var0.UPDATE_EVENT_LIST = "LevelMediator2:UPDATE_EVENT_LIST"
var0.ON_START = "ON_START"
var0.ON_ENTER_MAINLEVEL = "LevelMediator2:ON_ENTER_MAINLEVEL"
var0.ON_DIDENTER = "LevelMediator2:ON_DIDENTER"
var0.ON_PERFORM_COMBAT = "LevelMediator2.ON_PERFORM_COMBAT"
var0.ON_ELITE_OEPN_DECK = "LevelMediator2:ON_ELITE_OEPN_DECK"
var0.ON_ELITE_CLEAR = "LevelMediator2:ON_ELITE_CLEAR"
var0.ON_ELITE_RECOMMEND = "LevelMediator2:ON_ELITE_RECOMMEND"
var0.ON_ELITE_ADJUSTMENT = "LevelMediator2:ON_ELITE_ADJUSTMENT"
var0.ON_SUPPORT_OPEN_DECK = "LevelMediator2:ON_SUPPORT_OPEN_DECK"
var0.ON_SUPPORT_CLEAR = "LevelMediator2:ON_SUPPORT_CLEAR"
var0.ON_SUPPORT_RECOMMEND = "LevelMediator2:ON_SUPPORT_RECOMMEND"
var0.ON_ACTIVITY_MAP = "LevelMediator2:ON_ACTIVITY_MAP"
var0.GO_ACT_SHOP = "LevelMediator2:GO_ACT_SHOP"
var0.ON_SWITCH_NORMAL_MAP = "LevelMediator2:ON_SWITCH_NORMAL_MAP"
var0.NOTICE_AUTOBOT_ENABLED = "LevelMediator2:NOTICE_AUTOBOT_ENABLED"
var0.ON_EXTRA_RANK = "LevelMediator2:ON_EXTRA_RANK"
var0.ON_STRATEGYING_CHAPTER = "LevelMediator2:ON_STRATEGYING_CHAPTER"
var0.ON_SELECT_COMMANDER = "LevelMediator2:ON_SELECT_COMMANDER"
var0.ON_SELECT_ELITE_COMMANDER = "LevelMediator2:ON_SELECT_ELITE_COMMANDER"
var0.ON_COMMANDER_SKILL = "LevelMediator2:ON_COMMANDER_SKILL"
var0.ON_SHIP_DETAIL = "LevelMediator2:ON_SHIP_DETAIL"
var0.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN = "LevelMediator2:ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN"
var0.GET_REMASTER_TICKETS_DONE = "LevelMediator2:GET_REMASTER_TICKETS_DONE"
var0.ON_FLEET_SHIPINFO = "LevelMediator2:ON_FLEET_SHIPINFO"
var0.ON_STAGE_SHIPINFO = "LevelMediator2:ON_STAGE_SHIPINFO"
var0.ON_SUPPORT_SHIPINFO = "LevelMediator2:ON_SUPPORT_SHIPINFO"
var0.ON_COMMANDER_OP = "LevelMediator2:ON_COMMANDER_OP"
var0.CLICK_CHALLENGE_BTN = "LevelMediator2:CLICK_CHALLENGE_BTN"
var0.ON_SUBMIT_TASK = "LevelMediator2:ON_SUBMIT_TASK"
var0.ON_VOTE_BOOK = "LevelMediator2:ON_VOTE_BOOK"
var0.GET_CHAPTER_DROP_SHIP_LIST = "LevelMediator2:GET_CHAPTER_DROP_SHIP_LIST"
var0.ON_CHAPTER_REMASTER_AWARD = "LevelMediator2:ON_CHAPTER_REMASTER_AWARD"
var0.ENTER_WORLD = "LevelMediator2:ENTER_WORLD"
var0.ON_OPEN_ACT_BOSS_BATTLE = "LevelMediator2:ON_OPEN_ACT_BOSS_BATTLE"
var0.ON_BOSSRUSH_MAP = "LevelMediator2:ON_BOSSRUSH_MAP"
var0.SHOW_ATELIER_BUFF = "LevelMediator2:SHOW_ATELIER_BUFF"
var0.ON_SPITEM_CHANGED = "LevelMediator2:ON_SPITEM_CHANGED"
var0.ON_BOSSSINGLE_MAP = "LevelMediator2:ON_BOSSSINGLE_MAP"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy)

	arg0:bind(var0.GET_CHAPTER_DROP_SHIP_LIST, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_VOTE_BOOK, function(arg0, arg1)
		return
	end)
	arg0:bind(var0.ON_COMMANDER_OP, function(arg0, arg1, arg2)
		arg0.contextData.commanderOPChapter = arg2

		arg0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1
		})
	end)
	arg0:bind(var0.ON_SELECT_COMMANDER, function(arg0, arg1, arg2, arg3)
		FormationMediator.onSelectCommander(arg1, arg2)

		arg0.contextData.selectedChapterVO = arg3
	end)
	arg0:bind(var0.ON_SELECT_ELITE_COMMANDER, function(arg0, arg1, arg2, arg3)
		local var0 = getProxy(ChapterProxy)
		local var1 = arg3.id

		arg0.contextData.editEliteChapter = var1

		local var2 = arg3:getEliteFleetCommanders()[arg1] or {}
		local var3

		if var2[arg2] then
			local var4 = getProxy(CommanderProxy):getCommanderById(var2[arg2])
		end

		local var5

		if var2[arg2] then
			var5 = getProxy(CommanderProxy):getCommanderById(var2[arg2])
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			activeCommander = var5,
			ignoredIds = {},
			fleetType = CommanderCatScene.FLEET_TYPE_HARD_CHAPTER,
			chapterId = var1,
			onCommander = function(arg0)
				return true
			end,
			onSelected = function(arg0, arg1)
				local var0 = arg0[1]

				arg0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = var1,
					index = arg1,
					pos = arg2,
					commanderId = var0,
					callback = function()
						arg1()
					end
				})
			end,
			onQuit = function(arg0)
				arg0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = var1,
					index = arg1,
					pos = arg2,
					callback = function()
						arg0()
					end
				})
			end
		})
	end)
	arg0:RegisterTrackEvent()
	arg0:bind(var0.ON_UPDATE_CUSTOM_FLEET, function(arg0, arg1)
		arg0:sendNotification(GAME.UPDATE_CUSTOM_FLEET, {
			chapterId = arg1.id
		})
	end)
	arg0:bind(var0.ON_OP, function(arg0, arg1)
		arg0:sendNotification(GAME.CHAPTER_OP, arg1)
	end)
	arg0:bind(var0.ON_SWITCH_NORMAL_MAP, function(arg0)
		local var0 = getProxy(ChapterProxy)
		local var1
		local var2 = Map.lastMap and var0:getMapById(Map.lastMap)

		if var2 and var2:isUnlock() and var2:getMapType() == Map.SCENARIO then
			var1 = Map.lastMap
		else
			var1 = var0:getLastUnlockMap().id
		end

		if var1 then
			arg0.viewComponent:setMap(var1)
		end
	end)
	arg0:bind(var0.ON_RESUME_SUBSTATE, function(arg0, arg1)
		arg0:loadSubState(arg1)
	end)
	arg0:bind(var0.ON_STAGE, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = ChapterPreCombatMediator,
			viewComponent = ChapterPreCombatLayer
		}), false)
	end)
	arg0:bind(var0.ON_OPEN_MILITARYEXERCISE, function()
		if getProxy(ActivityProxy):getMilitaryExerciseActivity() then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.MILITARYEXERCISE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
		end
	end)
	arg0:bind(var0.CLICK_CHALLENGE_BTN, function(arg0)
		if LOCK_LIMIT_CHALLENGE then
			arg0:sendNotification(GAME.GO_SCENE, SCENE.CHALLENGE_MAIN_SCENE)
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LIMIT_CHALLENGE)
		end
	end)
	arg0:bind(var0.ON_DAILY_LEVEL, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
	end)
	arg0:bind(var0.ON_GO_TO_TASK_SCENE, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.TASK, arg1)
	end)
	arg0:bind(var0.ON_OPEN_EVENT_SCENE, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	arg0:bind(var0.ON_OVERRIDE_CHAPTER, function()
		local var0 = arg0.contextData.chapterVO

		getProxy(ChapterProxy):updateChapter(var0)
	end)
	arg0:bind(var0.ON_TIME_UP, function()
		arg0:onTimeUp()
	end)
	arg0:bind(var0.UPDATE_EVENT_LIST, function()
		arg0.viewComponent:addbubbleMsgBox(function(arg0)
			arg0:OnEventUpdate(arg0)
		end)

		local var0 = getProxy(ChapterProxy):getActiveChapter(true)

		if var0 and var0:IsAutoFight() then
			local var1 = pg.GuildMsgBoxMgr.GetInstance()

			if var1:GetShouldShowBattleTip() then
				local var2 = getProxy(GuildProxy):getRawData()
				local var3 = var2 and var2:getWeeklyTask()

				if var3 and var3.id ~= 0 then
					getProxy(ChapterProxy):AddExtendChapterDataTable(var0.id, "ListGuildEventNotify", var3:GetPresonTaskId(), var3:GetPrivateTaskName())
					pg.GuildMsgBoxMgr.GetInstance():CancelShouldShowBattleTip()
				end

				var1:SubmitTask(function(arg0, arg1, arg2)
					if arg0 then
						local var0 = pg.task_data_template[arg2].desc

						getProxy(ChapterProxy):AddExtendChapterDataTable(var0.id, "ListGuildEventAutoReceiveNotify", arg2, var0)
					end
				end)
			end
		else
			arg0.viewComponent:addbubbleMsgBox(function(arg0)
				pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(arg0)
			end)
		end
	end)
	arg0:bind(var0.ON_ELITE_CLEAR, function(arg0, arg1)
		local var0 = arg1.index
		local var1 = arg1.chapterVO

		var1:clearEliterFleetByIndex(var0)

		local var2 = getProxy(ChapterProxy)

		var2:updateChapter(var1)
		var2:duplicateEliteFleet(var1)
		arg0.viewComponent:RefreshFleetSelectView(var1)
	end)
	arg0:bind(var0.NOTICE_AUTOBOT_ENABLED, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMON_FLAG, {
			flagID = BATTLE_AUTO_ENABLED
		})
	end)
	arg0:bind(var0.ON_ELITE_RECOMMEND, function(arg0, arg1)
		local var0 = arg1.index
		local var1 = arg1.chapterVO
		local var2 = getProxy(ChapterProxy)

		var2:eliteFleetRecommend(var1, var0)
		var2:updateChapter(var1)
		var2:duplicateEliteFleet(var1)
		arg0.viewComponent:RefreshFleetSelectView(var1)
	end)
	arg0:bind(var0.ON_ELITE_ADJUSTMENT, function(arg0, arg1)
		local var0 = getProxy(ChapterProxy)

		var0:updateChapter(arg1)
		var0:duplicateEliteFleet(arg1)
	end)
	arg0:bind(var0.ON_ELITE_OEPN_DECK, function(arg0, arg1)
		local var0 = arg1.shipType
		local var1 = arg1.fleetIndex
		local var2 = arg1.shipVO
		local var3 = arg1.fleet
		local var4 = arg1.chapter
		local var5 = arg1.teamType
		local var6 = getProxy(BayProxy):getRawData()
		local var7 = {}

		for iter0, iter1 in pairs(var6) do
			if not ShipType.ContainInLimitBundle(var0, iter1:getShipType()) then
				table.insert(var7, iter0)
			end
		end

		arg0.contextData.editEliteChapter = var4.id

		local var8 = {}

		for iter2, iter3 in pairs(var3) do
			table.insert(var8, iter2.id)
		end

		local var9, var10, var11 = arg0:getDockCallbackFuncs(var3, var2, var4, var1)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			ignoredIds = var7,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var2 ~= nil,
			teamFilter = var5,
			leftTopInfo = i18n("word_formation"),
			onShip = var9,
			confirmSelect = var10,
			onSelected = var11,
			hideTagFlags = setmetatable({
				inElite = var4:getConfig("formation")
			}, {
				__index = ShipStatus.TAG_HIDE_LEVEL
			}),
			otherSelectedIds = var8
		})
	end)
	arg0:bind(var0.ON_SUPPORT_OPEN_DECK, function(arg0, arg1)
		local var0 = arg1.shipType
		local var1 = arg1.shipVO
		local var2 = arg1.fleet
		local var3 = arg1.chapter
		local var4 = arg1.teamType
		local var5 = getProxy(BayProxy):getRawData()
		local var6 = {}

		for iter0, iter1 in pairs(var5) do
			if not ShipType.ContainInLimitBundle(var0, iter1:getShipType()) then
				table.insert(var6, iter0)
			end
		end

		local var7 = {}

		for iter2, iter3 in pairs(var2) do
			table.insert(var7, iter2.id)
		end

		local var8, var9, var10 = arg0:getSupportDockCallbackFuncs(var2, var1, var3)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			ignoredIds = var6,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var1 ~= nil,
			teamFilter = var4,
			leftTopInfo = i18n("word_formation"),
			onShip = var8,
			confirmSelect = var9,
			onSelected = var10,
			hideTagFlags = setmetatable({
				inSupport = var3:getConfig("formation")
			}, {
				__index = ShipStatus.TAG_HIDE_SUPPORT
			}),
			otherSelectedIds = var7
		})

		arg0.contextData.selectedChapterVO = var3
	end)
	arg0:bind(var0.ON_SUPPORT_CLEAR, function(arg0, arg1)
		local var0 = arg1.index
		local var1 = arg1.chapterVO

		var1:ClearSupportFleetList(var0)

		local var2 = getProxy(ChapterProxy)

		var2:updateChapter(var1)
		var2:duplicateSupportFleet(var1)
		arg0.viewComponent:RefreshFleetSelectView(var1)
	end)
	arg0:bind(var0.ON_SUPPORT_RECOMMEND, function(arg0, arg1)
		local var0 = arg1.index
		local var1 = arg1.chapterVO
		local var2 = getProxy(ChapterProxy)

		var2:SupportFleetRecommend(var1, var0)
		var2:updateChapter(var1)
		var2:duplicateSupportFleet(var1)
		arg0.viewComponent:RefreshFleetSelectView(var1)
	end)
	arg0:bind(var0.ON_ACTIVITY_MAP, function()
		local var0 = getProxy(ChapterProxy)
		local var1, var2 = var0:getLastMapForActivity()

		if not var1 or not var0:getMapById(var1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end

		arg0.viewComponent:ShowSelectedMap(var1, function()
			if var2 then
				local var0 = var0:getChapterById(var2)

				arg0.viewComponent:switchToChapter(var0)
			end
		end)
	end)
	arg0:bind(var0.ON_BOSSRUSH_MAP, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
	end)
	arg0:bind(var0.ON_BOSSSINGLE_MAP, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP, arg1)
	end)
	arg0:bind(var0.GO_ACT_SHOP, function()
		local var0 = pg.gameset.activity_res_id.key_value
		local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		if var1 and var1:getConfig("config_client").resId == var0 and not var1:isEnd() then
			arg0:addSubLayers(Context.New({
				mediator = LotteryMediator,
				viewComponent = LotteryLayer,
				data = {
					activityId = var1.id
				}
			}), false)
		else
			local var2 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0)
				return arg0:getConfig("config_client").pt_id == var0
			end)
			local var3 = var2 and var2.id

			arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = var3
			})
		end
	end)
	arg0:bind(var0.SHOW_ATELIER_BUFF, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = AtelierBuffMediator,
			viewComponent = AtelierBuffLayer
		}))
	end)
	arg0:bind(var0.ON_SHIP_DETAIL, function(arg0, arg1)
		arg0.contextData.selectedChapterVO = arg1.chapter

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.id
		})
	end)
	arg0:bind(var0.ON_FLEET_SHIPINFO, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.shipId,
			shipVOs = arg1.shipVOs
		})

		arg0.contextData.editEliteChapter = arg1.chapter.id
	end)
	arg0:bind(var0.ON_SUPPORT_SHIPINFO, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.shipId,
			shipVOs = arg1.shipVOs
		})

		arg0.contextData.selectedChapterVO = arg1.chapter
	end)
	arg0:bind(var0.ON_STAGE_SHIPINFO, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.shipId,
			shipVOs = arg1.shipVOs
		})
	end)
	arg0:bind(var0.ON_EXTRA_RANK, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_EXTRA_CHAPTER
		})
	end)
	arg0:bind(var0.ON_STRATEGYING_CHAPTER, function(arg0)
		local var0 = getProxy(ChapterProxy)
		local var1 = var0:getActiveChapter()

		assert(var1)

		local var2 = var0:getMapById(var1:getConfig("map"))

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_forward",
			content = i18n("levelScene_chapter_is_activation", string.split(var2:getConfig("name"), "|")[1] .. ":" .. var1:getConfig("chapter_name")),
			onYes = function()
				arg0.viewComponent:switchToChapter(var1)
			end,
			onNo = function()
				arg0.contextData.chapterVO = var1

				arg0.viewComponent:emit(LevelMediator2.ON_OP, {
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
	arg0:bind(var0.ON_COMMANDER_SKILL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_PERFORM_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1,
			exitCallback = arg2
		})
	end)
	arg0:bind(var0.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN, function(arg0)
		arg0:sendNotification(GAME.GET_REMASTER_TICKETS)
	end)
	arg0:bind(var0.ON_SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0:bind(var0.ON_START, function(arg0)
		local var0 = getProxy(ChapterProxy):getActiveChapter()

		assert(var0)

		local var1 = var0.fleet
		local var2 = var0:getStageId(var1.line.row, var1.line.column)

		seriesAsync({
			function(arg0)
				local var0 = {}

				for iter0, iter1 in pairs(var1.ships) do
					table.insert(var0, iter1)
				end

				Fleet.EnergyCheck(var0, var1.name, function(arg0)
					if arg0 then
						arg0()
					end
				end, function(arg0)
					if not arg0 then
						getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.SHIP_ENERGY_LOW)
					end
				end)
			end,
			function(arg0)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.GOLD_MAX)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0,
						onYes = arg0,
						weight = LayerWeightConst.SECOND_LAYER
					})
				else
					arg0()
				end
			end,
			function(arg0)
				arg0:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_SCENARIO,
					stageId = var2
				})
			end
		})
	end)
	arg0:bind(arg0.ON_ENTER_MAINLEVEL, function(arg0, arg1)
		arg0:DidEnterLevelMainUI(arg1)
	end)
	arg0:bind(arg0.ON_DIDENTER, function(arg0)
		arg0.viewComponent:emit(LevelMediator2.UPDATE_EVENT_LIST)
	end)
	arg0:bind(var0.ENTER_WORLD, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
	end)
	arg0:bind(var0.ON_CHAPTER_REMASTER_AWARD, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.CHAPTER_REMASTER_AWARD_RECEIVE, {
			chapterId = arg1,
			pos = arg2
		})
	end)
	arg0:bind(var0.ON_OPEN_ACT_BOSS_BATTLE, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ACT_BOSS_BATTLE, {
			showAni = true
		})
	end)
	arg0:bind(LevelUIConst.OPEN_NORMAL_CONTINUOUS_WINDOW, function(arg0, arg1, arg2, arg3, arg4)
		local var0 = _.map(arg2, function(arg0)
			local var0 = getProxy(FleetProxy):getFleetById(arg0)

			if not var0 or var0:getFleetType() == FleetType.Submarine then
				return
			end

			return var0
		end)

		arg0:DisplayContinuousWindow(arg1, var0, arg3, arg4)
	end)
	arg0:bind(LevelUIConst.OPEN_ELITE_CONTINUOUS_WINDOW, function(arg0, arg1, arg2, arg3)
		local var0 = arg1:getEliteFleetList()
		local var1 = getProxy(BayProxy):getRawData()
		local var2 = _.map(var0, function(arg0)
			if #arg0 == 0 or _.any(arg0, function(arg0)
				local var0 = var1[arg0]

				return var0 and var0:getTeamType() == TeamType.Submarine
			end) then
				return
			end

			return TypedFleet.New({
				fleetType = FleetType.Normal,
				ship_list = arg0
			})
		end)

		arg0:DisplayContinuousWindow(arg1, var2, arg2, arg3)
	end)

	arg0.player = var0:getData()

	arg0.viewComponent:updateRes(arg0.player)

	local var1 = getProxy(EventProxy)

	arg0.viewComponent:updateEvent(var1)

	local var2 = getProxy(FleetProxy):GetRegularFleets()

	arg0.viewComponent:updateFleet(var2)

	local var3 = getProxy(BayProxy)

	arg0.viewComponent:setShips(var3:getRawData())

	local var4 = getProxy(ActivityProxy)

	arg0.viewComponent:updateVoteBookBtn()

	local var5 = getProxy(CommanderProxy):getPrefabFleet()

	arg0.viewComponent:setCommanderPrefabs(var5)

	local var6 = var4:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK)

	for iter0, iter1 in ipairs(var6) do
		if iter1:getConfig("config_id") == pg.gameset.activity_res_id.key_value then
			arg0.viewComponent:updatePtActivity(iter1)

			break
		end
	end

	local var7 = getProxy(DailyLevelProxy)

	arg0.viewComponent:setEliteQuota(var7.eliteCount, pg.gameset.elite_quota.key_value)
	getProxy(ChapterProxy):updateActiveChapterShips()

	local var8 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)

	arg0.viewComponent:setSpecialOperationTickets(var8)
end

function var0.DidEnterLevelMainUI(arg0, arg1)
	arg0.viewComponent:setMap(arg1)

	local var0 = arg0.contextData.chapterVO

	if var0 and var0.active then
		arg0.viewComponent:switchToChapter(var0)
	elseif arg0.contextData.map:isSkirmish() then
		arg0.viewComponent:ShowCurtains(true)
		arg0.viewComponent:doPlayAnim("TV01", function(arg0)
			go(arg0):SetActive(false)
			arg0.viewComponent:ShowCurtains(false)
		end)
	end

	if arg0.contextData.preparedTaskList and #arg0.contextData.preparedTaskList > 0 then
		for iter0, iter1 in ipairs(arg0.contextData.preparedTaskList) do
			arg0:sendNotification(GAME.SUBMIT_TASK, iter1)
		end

		table.clean(arg0.contextData.preparedTaskList)
	end

	if arg0.contextData.StopAutoFightFlag then
		local var1 = getProxy(ChapterProxy)
		local var2 = var1:getActiveChapter()

		if var2 then
			var1:SetChapterAutoFlag(var2.id, false)

			local var3 = bit.bor(ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

			arg0.viewComponent:updateChapterVO(var2, var3)
		end

		arg0.contextData.StopAutoFightFlag = nil
	end

	if arg0.contextData.ToTrackingData then
		arg0:sendNotification(arg0.contextData.ToTrackingData[1], arg0.contextData.ToTrackingData[2])

		arg0.contextData.ToTrackingData = nil
	end
end

function var0.RegisterTrackEvent(arg0)
	arg0:bind(var0.ON_TRACKING, function(arg0, arg1, arg2, arg3, arg4, arg5)
		local var0 = getProxy(ChapterProxy):getChapterById(arg1, true)
		local var1 = getProxy(ChapterProxy):GetLastFleetIndex()

		arg0:sendNotification(GAME.TRACKING, {
			chapterId = arg1,
			fleetIds = var1,
			loopFlag = arg2,
			operationItem = arg3,
			duties = arg4,
			autoFightFlag = arg5
		})
	end)
	arg0:bind(var0.ON_ELITE_TRACKING, function(arg0, arg1, arg2, arg3, arg4, arg5)
		arg0:sendNotification(GAME.TRACKING, {
			chapterId = arg1,
			loopFlag = arg2,
			operationItem = arg3,
			duties = arg4,
			autoFightFlag = arg5
		})
	end)
	arg0:bind(var0.ON_RETRACKING, function(arg0, arg1, arg2)
		local var0 = arg1.duties
		local var1 = arg1:getConfig("type") == Chapter.CustomFleet
		local var2 = arg1:GetActiveSPItemID()

		if var1 then
			arg0.viewComponent:emit(LevelMediator2.ON_ELITE_TRACKING, arg1.id, arg1.loopFlag, var2, var0, arg2)
		else
			arg0.viewComponent:emit(LevelMediator2.ON_TRACKING, arg1.id, arg1.loopFlag, var2, var0, arg2)
		end
	end)
end

function var0.NoticeVoteBook(arg0, arg1)
	arg1()
end

function var0.TryPlaySubGuide(arg0)
	arg0.viewComponent:tryPlaySubGuide()
end

function var0.listNotificationInterests(arg0)
	return {
		ChapterProxy.CHAPTER_UPDATED,
		ChapterProxy.CHAPTER_TIMESUP,
		PlayerProxy.UPDATED,
		DailyLevelProxy.ELITE_QUOTA_UPDATE,
		var0.ON_TRACKING,
		var0.ON_ELITE_TRACKING,
		var0.ON_RETRACKING,
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
		var0.ON_SPITEM_CHANGED,
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == VoteProxy.VOTE_ORDER_BOOK_DELETE or VoteProxy.VOTE_ORDER_BOOK_UPDATE == var0 then
		arg0.viewComponent:updateVoteBookBtn()
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:updateRes(var1)
	elseif var0 == var0.ON_TRACKING or var0 == var0.ON_ELITE_TRACKING or var0 == var0.ON_RETRACKING then
		arg0.viewComponent:emit(var0, unpackEx(var1))
	elseif var0 == GAME.TRACKING_DONE then
		arg0.waitingTracking = nil

		arg0.viewComponent:resetLevelGrid()

		arg0.viewComponent.FirstEnterChapter = var1.id

		arg0.viewComponent:switchToChapter(var1)
	elseif var0 == ChapterProxy.CHAPTER_UPDATED then
		arg0.viewComponent:updateChapterVO(var1.chapter, var1.dirty)
	elseif var0 == GAME.COMMANDER_ELIT_FORMATION_OP_DONE then
		if arg0.contextData.commanderOPChapter then
			local var2 = getProxy(ChapterProxy):getChapterById(var1.chapterId)

			arg0.contextData.commanderOPChapter.eliteCommanderList = var2.eliteCommanderList

			arg0.viewComponent:RefreshFleetSelectView(arg0.contextData.commanderOPChapter)
		end
	elseif var0 == GAME.CHAPTER_OP_DONE then
		local var3

		local function var4()
			if var3 and coroutine.status(var3) == "suspended" then
				local var0, var1 = coroutine.resume(var3)

				assert(var0, debug.traceback(var3, var1))
			end
		end

		var3 = coroutine.create(function()
			local var0 = var1.type
			local var1 = arg0.contextData.chapterVO
			local var2 = var1:IsAutoFight()

			if var0 == ChapterConst.OpRetreat and not var1.id then
				var1 = var1.finalChapterLevelData

				if var1.exittype and var1.exittype == ChapterConst.ExitFromMap then
					arg0.viewComponent:setChapter(nil)
					arg0.viewComponent:updateChapterTF(var1.id)
					arg0:OnExitChapter(var1, var1.win, var1.extendData)

					return
				end

				if var1:existOni() then
					local var3 = var1:checkOniState()

					if var3 then
						arg0.viewComponent:displaySpResult(var3, var4)
						coroutine.yield()
					end
				end

				if var1:isPlayingWithBombEnemy() then
					arg0.viewComponent:displayBombResult(var4)
					coroutine.yield()
				end
			end

			local var4 = var1.items
			local var5

			if var4 and #var4 > 0 then
				if var0 == ChapterConst.OpBox then
					local var6 = var1.fleet.line
					local var7 = var1:getChapterCell(var6.row, var6.column)

					if pg.box_data_template[var7.attachmentId].type == ChapterConst.BoxDrop and ChapterConst.IsAtelierMap(arg0.contextData.map) then
						local var8 = _.filter(var4, function(arg0)
							return arg0.type == DROP_TYPE_RYZA_DROP
						end)

						if #var8 > 0 then
							var5 = AwardInfoLayer.TITLE.RYZA

							local var9 = math.random(#var8)
							local var10 = AtelierMaterial.New({
								configId = var8[var9].id
							}):GetVoices()

							if var10 and #var10 > 0 then
								local var11 = var10[math.random(#var10)]
								local var12, var13, var14 = ShipWordHelper.GetWordAndCV(var11[1], var11[2], nil, PLATFORM_CODE ~= PLATFORM_US)

								arg0.viewComponent:emit(LevelUIConst.ADD_TOAST_QUEUE, {
									iconScale = 0.75,
									Class = LevelStageAtelierMaterialToast,
									title = i18n("ryza_tip_toast_item_got"),
									desc = var14,
									voice = var13,
									icon = var11[3]
								})
							end
						end
					end
				end

				seriesAsync({
					function(arg0)
						getProxy(ChapterProxy):AddExtendChapterDataArray(var1.id, "TotalDrops", _.filter(var4, function(arg0)
							return arg0.type ~= DROP_TYPE_STRATEGY
						end))
						arg0.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
							items = var4,
							title = var5,
							closeOnCompleted = var2,
							removeFunc = arg0
						})
					end,
					function(arg0)
						if var0 == ChapterConst.OpBox and _.any(var4, function(arg0)
							if arg0.type ~= DROP_TYPE_VITEM then
								return false
							end

							return arg0:getConfig("virtual_type") == 1
						end) then
							(function()
								local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

								if not var0 then
									return
								end

								local var1 = pg.activity_event_picturepuzzle[var0.id]

								if not var1 then
									return
								end

								if #table.mergeArray(var0.data1_list, var0.data2_list, true) < #var1.pickup_picturepuzzle + #var1.drop_picturepuzzle then
									return
								end

								local var2 = var0:getConfig("config_client").comStory

								pg.NewStoryMgr.GetInstance():Play(var2, arg0)
							end)()
						end

						if _.any(var4, function(arg0)
							if arg0.type ~= DROP_TYPE_STRATEGY then
								return false
							end

							return pg.strategy_data_template[arg0.id].type == ChapterConst.StgTypeConsume
						end) then
							arg0.viewComponent.levelStageView:popStageStrategy()
						end

						arg0()
					end
				}, var4)
				coroutine.yield()
			end

			assert(var1)

			if var0 == ChapterConst.OpSkipBattle or var0 == ChapterConst.OpPreClear then
				arg0.viewComponent.levelStageView:tryAutoAction(function()
					if not arg0.viewComponent.levelStageView then
						return
					end

					arg0.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0 == ChapterConst.OpRetreat then
				local var15 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

				if var15 then
					local var16 = {}
					local var17 = var15:getContextByMediator(ChapterPreCombatMediator)

					if var17 then
						table.insert(var16, var17)
					end

					_.each(var16, function(arg0)
						arg0:sendNotification(GAME.REMOVE_LAYERS, {
							context = arg0
						})
					end)
				end

				if var1.id then
					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)

					return
				end

				local var18 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN)

				if var18 and not var18.autoActionForbidden and not var18.achieved and var18.data1 == 7 and var1.id == 204 and var1:isClear() then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						hideNo = true,
						content = "有新的签到奖励可以领取，点击确定前往",
						onYes = function()
							arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end,
						onNo = function()
							arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
						end
					})

					return
				end

				arg0:OnExitChapter(var1, var1.win, var1.extendData)
			elseif var0 == ChapterConst.OpMove then
				seriesAsync({
					function(arg0)
						var1 = arg0.contextData.chapterVO

						local var0 = var1.fullpath[#var1.fullpath]

						var1.fleet.line = Clone(var0)

						getProxy(ChapterProxy):updateChapter(var1)
						arg0.viewComponent.grid:moveFleet(var1.path, var1.fullpath, var1.oldLine, arg0)
					end,
					function(arg0)
						if not var1.teleportPaths then
							arg0()

							return
						end

						local var0 = var1.teleportPaths[1]
						local var1 = var1.teleportPaths[2]

						if not var0 or not var1 then
							arg0()

							return
						end

						var1 = arg0.contextData.chapterVO

						local var2 = var1:getFleet(FleetType.Normal, var0.row, var0.column)

						if not var2 then
							arg0()

							return
						end

						var2.line = Clone(var1.teleportPaths[2])

						getProxy(ChapterProxy):updateChapter(var1)

						local var3 = arg0:getViewComponent().grid:GetCellFleet(var2.id)

						arg0:getViewComponent().grid:TeleportCellByPortalWithCameraMove(var2, var3, var1.teleportPaths, arg0)
					end,
					function(arg0)
						arg0:playAIActions(var1.aiActs, var1.extraFlag, arg0)
					end
				}, function()
					var1 = arg0.contextData.chapterVO

					local var0 = var1.fleet:getStrategies()

					if _.any(var0, function(arg0)
						return arg0.id == ChapterConst.StrategyExchange and arg0.count > 0
					end) then
						arg0.viewComponent.levelStageView:popStageStrategy()
					end

					arg0.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					arg0.viewComponent.levelStageView:updateAmbushRate(var1.fleet.line, true)
					arg0.viewComponent.levelStageView:updateStageStrategy()
					arg0.viewComponent.levelStageView:updateFleetBuff()
					arg0.viewComponent.levelStageView:updateBombPanel()
					arg0.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0 == ChapterConst.OpAmbush then
				arg0.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0 == ChapterConst.OpBox then
				arg0:playAIActions(var1.aiActs, var1.extraFlag, function()
					if not arg0.viewComponent.levelStageView then
						return
					end

					arg0.viewComponent.levelStageView:tryAutoTrigger()
				end)
			elseif var0 == ChapterConst.OpStory then
				arg0.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0 == ChapterConst.OpSwitch then
				arg0.viewComponent.grid:adjustCameraFocus()
			elseif var0 == ChapterConst.OpEnemyRound then
				arg0:playAIActions(var1.aiActs, var1.extraFlag, function()
					arg0.viewComponent.levelStageView:updateBombPanel(true)

					local var0 = var1.fleet:getStrategies()

					if _.any(var0, function(arg0)
						return arg0.id == ChapterConst.StrategyExchange and arg0.count > 0
					end) then
						arg0.viewComponent.levelStageView:updateStageStrategy()
						arg0.viewComponent.levelStageView:popStageStrategy()
					end

					arg0.viewComponent.levelStageView:tryAutoTrigger()
					arg0.viewComponent:updatePoisonAreaTip()
				end)
			elseif var0 == ChapterConst.OpSubState then
				arg0:saveSubState(var1.subAutoAttack)
				arg0.viewComponent.grid:OnChangeSubAutoAttack()
			elseif var0 == ChapterConst.OpStrategy then
				if var1.arg1 == ChapterConst.StrategyExchange then
					local var19 = var1.fleet:findSkills(FleetSkill.TypeStrategy)

					for iter0, iter1 in ipairs(var19) do
						if iter1:GetType() == FleetSkill.TypeStrategy and iter1:GetArgs()[1] == ChapterConst.StrategyExchange then
							local var20 = var1.fleet:findCommanderBySkillId(iter1.id)

							arg0.viewComponent:doPlayCommander(var20)

							break
						end
					end
				end

				arg0:playAIActions(var1.aiActs, var1.extraFlag, function()
					arg0.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				end)
			elseif var0 == ChapterConst.OpSupply then
				arg0.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0 == ChapterConst.OpBarrier then
				arg0.viewComponent.levelStageView:tryAutoTrigger()
			elseif var0 == ChapterConst.OpSubTeleport then
				seriesAsync({
					function(arg0)
						local var0 = _.detect(var1.fleets, function(arg0)
							return arg0.id == var1.id
						end)

						var0.line = {
							row = var1.arg1,
							column = var1.arg2
						}
						var0.startPos = {
							row = var1.arg1,
							column = var1.arg2
						}

						local var1 = var1.fullpath[1]
						local var2 = var1.fullpath[#var1.fullpath]
						local var3 = var1:findPath(nil, var1, var2)
						local var4 = pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2]
						local var5 = math.ceil(var4 * #var0:getShips(false) * var3 - 1e-05)
						local var6 = getProxy(PlayerProxy)
						local var7 = var6:getData()

						var7:consume({
							oil = var5
						})
						arg0.viewComponent:updateRes(var7)
						var6:updatePlayer(var7)
						arg0.viewComponent.grid:moveSub(table.indexof(var1.fleets, var0), var1.fullpath, nil, function()
							local var0 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1, var0)

							var1 = arg0.contextData.chapterVO

							arg0()
						end)
					end,
					function(arg0)
						if not var1.teleportPaths then
							arg0()

							return
						end

						local var0 = var1.teleportPaths[1]
						local var1 = var1.teleportPaths[2]

						if not var0 or not var1 then
							arg0()

							return
						end

						local var2 = _.detect(var1.fleets, function(arg0)
							return arg0.id == var1.id
						end)

						var2.startPos = Clone(var1.teleportPaths[2])
						var2.line = Clone(var1.teleportPaths[2])

						local var3 = arg0:getViewComponent().grid:GetCellFleet(var2.id)

						arg0:getViewComponent().grid:TeleportFleetByPortal(var3, var1.teleportPaths, function()
							local var0 = bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)

							getProxy(ChapterProxy):updateChapter(var1, var0)

							var1 = arg0.contextData.chapterVO

							arg0()
						end)
					end,
					function(arg0)
						arg0.viewComponent.levelStageView:SwitchBottomStagePanel(false)
						arg0.viewComponent.grid:TurnOffSubTeleport()
						arg0.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
					end
				})
			end
		end)

		var4()
	elseif var0 == ChapterProxy.CHAPTER_TIMESUP then
		arg0:onTimeUp()
	elseif var0 == GAME.EVENT_LIST_UPDATE then
		arg0.viewComponent:addbubbleMsgBox(function(arg0)
			arg0:OnEventUpdate(arg0)
		end)
	elseif var0 == GAME.VOTE_BOOK_BE_UPDATED_DONE then
		arg0.viewComponent:addbubbleMsgBox(function(arg0)
			arg0:NoticeVoteBook(arg0)
		end)
	elseif var0 == DailyLevelProxy.ELITE_QUOTA_UPDATE then
		local var5 = getProxy(DailyLevelProxy)

		arg0.viewComponent:setEliteQuota(var5.eliteCount, pg.gameset.elite_quota.key_value)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0.viewComponent:updateMapItems()
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1 and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_RANK then
			arg0.viewComponent:updatePtActivity(var1)
		end
	elseif var0 == GAME.GET_REMASTER_TICKETS_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:updateRemasterTicket()
		end)
	elseif var0 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var6 = getProxy(CommanderProxy):getPrefabFleet()

		arg0.viewComponent:setCommanderPrefabs(var6)
		arg0.viewComponent:updateCommanderPrefab()
	elseif var0 == GAME.COOMMANDER_EQUIP_TO_FLEET_DONE then
		local var7 = getProxy(FleetProxy):GetRegularFleets()

		arg0.viewComponent:updateFleet(var7)
		arg0.viewComponent:RefreshFleetSelectView()
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		if arg0.contextData.map and arg0.contextData.map:isSkirmish() then
			arg0.viewComponent:updateMapItems()
		end

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			if arg0.contextData.map and arg0.contextData.map:isSkirmish() and arg0.contextData.TaskToSubmit then
				local var0 = arg0.contextData.TaskToSubmit

				arg0.contextData.TaskToSubmit = nil

				arg0:sendNotification(GAME.SUBMIT_TASK, var0)
			end
		end)
	elseif var0 == BagProxy.ITEM_UPDATED then
		local var8 = getProxy(BagProxy):getItemsByType(Item.SPECIAL_OPERATION_TICKET)

		arg0.viewComponent:setSpecialOperationTickets(var8)
	elseif var0 == ChapterProxy.CHAPTER_AUTO_FIGHT_FLAG_UPDATED then
		if not arg0:getViewComponent().levelStageView then
			return
		end

		arg0:getViewComponent().levelStageView:ActionInvoke("UpdateAutoFightMark")
	elseif var0 == ChapterProxy.CHAPTER_SKIP_PRECOMBAT_UPDATED then
		if not arg0:getViewComponent().levelStageView then
			return
		end

		arg0:getViewComponent().levelStageView:ActionInvoke("UpdateSkipPreCombatMark")
	elseif var0 == ChapterProxy.CHAPTER_REMASTER_INFO_UPDATED or var0 == GAME.CHAPTER_REMASTER_INFO_REQUEST_DONE then
		arg0.viewComponent:updateRemasterInfo()
		arg0.viewComponent:updateRemasterBtnTip()
	elseif var0 == GAME.CHAPTER_REMASTER_AWARD_RECEIVE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1)
	elseif var0 == GAME.STORY_UPDATE_DONE then
		arg0.cachedStoryAwards = var1
	elseif var0 == GAME.STORY_END then
		if arg0.cachedStoryAwards then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0.cachedStoryAwards.awards)

			arg0.cachedStoryAwards = nil
		end
	elseif var0 == LevelUIConst.CONTINUOUS_OPERATION then
		arg0.viewComponent:emit(LevelUIConst.CONTINUOUS_OPERATION, var1)
	elseif var0 == GAME.TRACKING_ERROR then
		if arg0.waitingTracking then
			arg0:DisplayContinuousOperationResult(var1.chapter, getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO))
		end

		arg0.waitingTracking = nil
	elseif var0 == var0.ON_SPITEM_CHANGED then
		arg0.viewComponent:emit(var0.ON_SPITEM_CHANGED, var1)
	end
end

function var0.OnExitChapter(arg0, arg1, arg2, arg3)
	assert(arg1)
	seriesAsync({
		function(arg0)
			if not arg0.contextData.chapterVO then
				return arg0()
			end

			arg0.viewComponent:switchToMap(arg0)
		end,
		function(arg0)
			arg0.viewComponent:addbubbleMsgBox(function()
				arg0.viewComponent:CleanBubbleMsgbox()
				arg0()
			end)
		end,
		function(arg0)
			if not arg2 then
				return arg0()
			end

			local var0 = getProxy(PlayerProxy):getData()

			if arg1.id == 103 and not var0:GetCommonFlag(BATTLE_AUTO_ENABLED) then
				arg0.viewComponent:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("battle_autobot_unlock"),
					onYes = arg0,
					onNo = arg0
				})
				arg0.viewComponent:emit(LevelMediator2.NOTICE_AUTOBOT_ENABLED, {})

				return
			end

			arg0()
		end,
		function(arg0)
			if not arg2 then
				return arg0()
			end

			if getProxy(ChapterProxy):getMapById(arg1:getConfig("map")):isSkirmish() then
				local var0 = arg1.id
				local var1 = getProxy(SkirmishProxy):getRawData()
				local var2 = _.detect(var1, function(arg0)
					return tonumber(arg0:getConfig("event")) == var0
				end)

				if not var2 then
					arg0()

					return
				end

				local var3 = getProxy(TaskProxy)
				local var4 = var2:getConfig("task_id")
				local var5 = var3:getTaskVO(var4)

				if var5 and var5:getTaskStatus() == 1 then
					arg0:sendNotification(GAME.SUBMIT_TASK, var4)

					if var2 == var1[#var1] then
						local var6 = getProxy(ActivityProxy)
						local var7 = ActivityConst.ACTIVITY_ID_US_SKIRMISH_RE
						local var8 = var6:getActivityById(var7)

						assert(var8, "Missing Skirmish Activity " .. (var7 or "NIL"))

						local var9 = var8:getConfig("config_data")
						local var10 = var9[#var9][2]
						local var11 = var3:getTaskVO(var10)

						if var11 and var11:getTaskStatus() < 2 then
							arg0.contextData.TaskToSubmit = var10
						end
					end
				end
			end

			arg0()
		end,
		function(arg0)
			if not arg2 then
				return arg0()
			end

			local var0 = getProxy(ChapterProxy):getMapById(arg1:getConfig("map"))

			if var0:isRemaster() then
				local var1 = var0:getRemaster()
				local var2 = pg.re_map_template[var1]
				local var3 = Map.GetRearChaptersOfRemaster(var1)

				assert(var3)

				if _.any(var3, function(arg0)
					return arg0 == arg1.id
				end) then
					local var4 = var2.memory_group
					local var5 = pg.memory_group[var4].memories

					if _.any(var5, function(arg0)
						return not pg.NewStoryMgr.GetInstance():IsPlayed(pg.memory_template[arg0].story, true)
					end) then
						_.each(var5, function(arg0)
							local var0 = pg.memory_template[arg0].story
							local var1, var2 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0)

							pg.NewStoryMgr.GetInstance():SetPlayedFlag(var1)
						end)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							yesText = "text_go",
							content = i18n("levelScene_remaster_story_tip", pg.memory_group[var4].title),
							weight = LayerWeightConst.SECOND_LAYER,
							onYes = function()
								arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
									page = WorldMediaCollectionScene.PAGE_MEMORTY,
									memoryGroup = var4
								})
							end,
							onNo = function()
								local var0 = getProxy(PlayerProxy):getRawData().id

								PlayerPrefs.SetInt("MEMORY_GROUP_NOTIFICATION" .. var0 .. " " .. var4, 1)
								PlayerPrefs.Save()
								arg0()
							end
						})

						return
					end
				end
			end

			arg0()
		end,
		function(arg0)
			if arg0.contextData.map and not arg0.contextData.map:isUnlock() then
				arg0.viewComponent:emit(var0.ON_SWITCH_NORMAL_MAP)

				return
			end

			if not arg3 then
				return arg0()
			end

			local var0 = arg3 and arg3.AutoFightFlag
			local var1 = {}

			if arg3 and arg3.ResultDrops then
				for iter0, iter1 in ipairs(arg3.ResultDrops) do
					var1 = table.mergeArray(var1, iter1)
				end
			end

			local var2 = {}

			if arg3 and arg3.TotalDrops then
				for iter2, iter3 in ipairs(arg3.TotalDrops) do
					var2 = table.mergeArray(var2, iter3)
				end
			end

			DropResultIntegration(var2)

			local var3 = getProxy(ChapterProxy):GetContinuousData(SYSTEM_SCENARIO)

			if var3 then
				var3:MergeDrops(var2, var1)
				var3:MergeEvents(arg3.ListEventNotify, arg3.ListGuildEventNotify, arg3.ListGuildEventAutoReceiveNotify)

				if arg2 then
					var3:ConsumeBattleTime()
				end

				if var3:IsActive() and var3:GetRestBattleTime() > 0 then
					arg0.waitingTracking = true

					arg0.viewComponent:emit(var0.ON_RETRACKING, arg1, var0)

					return
				end

				getProxy(ChapterProxy):PopContinuousData(SYSTEM_SCENARIO)
				arg0:DisplayContinuousOperationResult(arg1, var3)
				arg0()

				return
			end

			local var4 = var0 ~= nil

			if not var4 and not arg3.ResultDrops then
				return arg0()
			end

			local var5
			local var6

			if var4 then
				var5 = i18n("autofight_rewards")
				var6 = i18n("total_rewards_subtitle")
			else
				var5 = i18n("settle_rewards_title")
				var6 = i18n("settle_rewards_subtitle")
			end

			arg0:addSubLayers(Context.New({
				viewComponent = LevelStageTotalRewardPanel,
				mediator = LevelStageTotalRewardPanelMediator,
				data = {
					title = var5,
					subTitle = var6,
					chapter = arg1,
					onClose = arg0,
					rewards = var2,
					resultRewards = var1,
					events = arg3.ListEventNotify,
					guildTasks = arg3.ListGuildEventNotify,
					guildAutoReceives = arg3.ListGuildEventAutoReceiveNotify,
					isAutoFight = var0
				}
			}), true)
		end,
		function(arg0)
			if Map.autoNextPage then
				Map.autoNextPage = nil

				triggerButton(arg0.viewComponent.btnNext)
			end

			if arg2 then
				arg0.viewComponent:RefreshMapBG()
			end

			arg0:TryPlaySubGuide()
		end
	})
end

function var0.DisplayContinuousWindow(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:getConfig("oil")
	local var1 = arg1:getPlayType()
	local var2 = 0
	local var3 = 0

	if var1 == ChapterConst.TypeMultiStageBoss then
		local var4 = pg.chapter_model_multistageboss[arg1.id]

		var2 = _.reduce(var4.boss_refresh, 0, function(arg0, arg1)
			return arg0 + arg1
		end)
		var3 = #var4.boss_refresh
	else
		var2, var3 = arg1:getConfig("boss_refresh"), 1
	end

	local var5 = arg1:getConfig("use_oil_limit")

	table.Foreach(arg2, function(arg0, arg1)
		local var0 = arg4[arg0]

		if var0 == ChapterFleet.DUTY_IDLE then
			return
		end

		local var1 = arg1:GetCostSum().oil

		if var0 == ChapterFleet.DUTY_KILLALL then
			local var2 = var5[1] or 0
			local var3 = var1

			if var2 > 0 then
				var3 = math.min(var3, var2)
			end

			local var4 = var5[2] or 0
			local var5 = var1

			if var4 > 0 then
				var5 = math.min(var5, var4)
			end

			var0 = var0 + var3 * var2 + var5 * var3
		elseif var0 == ChapterFleet.DUTY_CLEANPATH then
			local var6 = var5[1] or 0
			local var7 = var1

			if var6 > 0 then
				var7 = math.min(var7, var6)
			end

			var0 = var0 + var7 * var2
		elseif var0 == ChapterFleet.DUTY_KILLBOSS then
			local var8 = var5[2] or 0
			local var9 = var1

			if var8 > 0 then
				var9 = math.min(var9, var8)
			end

			var0 = var0 + var9 * var3
		end
	end)

	local var6 = arg1:GetMaxBattleCount()
	local var7 = arg3 and arg3 > 0
	local var8 = arg1:GetSpItems()
	local var9 = var8[1] and var8[1].count or 0
	local var10 = var8[1] and var8[1].id or 0
	local var11 = arg1:GetRestDailyBonus()

	arg0:addSubLayers(Context.New({
		mediator = LevelContinuousOperationWindowMediator,
		viewComponent = LevelContinuousOperationWindow,
		data = {
			maxCount = var6,
			oilCost = var0,
			chapter = arg1,
			extraRate = {
				rate = 2,
				enabled = var7,
				extraCount = var9,
				spItemId = var10,
				freeBonus = var11
			}
		}
	}))
end

function var0.DisplayContinuousOperationResult(arg0, arg1, arg2)
	local var0 = i18n("autofight_rewards")
	local var1 = i18n("total_rewards_subtitle")

	arg0:addSubLayers(Context.New({
		viewComponent = LevelContinuousOperationTotalRewardPanel,
		mediator = LevelStageTotalRewardPanelMediator,
		data = {
			title = var0,
			subTitle = var1,
			chapter = arg1,
			rewards = arg2:GetDrops(),
			resultRewards = arg2:GetSettlementDrops(),
			continuousData = arg2,
			events = arg2:GetEvents(1),
			guildTasks = arg2:GetEvents(2),
			guildAutoReceives = arg2:GetEvents(3)
		}
	}), true)
end

function var0.OnEventUpdate(arg0, arg1)
	local var0 = getProxy(EventProxy)

	arg0.viewComponent:updateEvent(var0)

	if pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "EventMediator") and var0.eventForMsg then
		local var1 = var0.eventForMsg.id or 0
		local var2 = getProxy(ChapterProxy):getActiveChapter(true)

		if var2 and var2:IsAutoFight() then
			getProxy(ChapterProxy):AddExtendChapterDataArray(var2.id, "ListEventNotify", var1)
			existCall(arg1)
		else
			local var3 = pg.collection_template[var1] and pg.collection_template[var1].title or ""

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = false,
				hideNo = true,
				content = i18n("event_special_update", var3),
				weight = LayerWeightConst.SECOND_LAYER,
				onYes = arg1,
				onNo = arg1
			})
		end

		var0.eventForMsg = nil
	else
		existCall(arg1)
	end
end

function var0.onTimeUp(arg0)
	local var0 = getProxy(ChapterProxy):getActiveChapter()

	if var0 and not var0:inWartime() then
		local function var1()
			arg0:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		end

		if arg0.contextData.chapterVO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = var1,
				onNo = var1
			})
		else
			var1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_timeout"))
		end
	end
end

function var0.getDockCallbackFuncs(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(ChapterProxy)

	local function var1(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inElite", arg0, arg1, {
			inElite = arg3:getConfig("formation")
		})

		if not var0 then
			return var0, var1
		end

		for iter0, iter1 in pairs(arg1) do
			if arg0:isSameKind(iter0) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2(arg0, arg1, arg2)
		arg1()
	end

	local function var3(arg0)
		local var0 = arg3:getEliteFleetList()[arg4]

		if arg2 then
			local var1 = table.indexof(var0, arg2.id)

			assert(var1)

			if arg0[1] then
				var0[var1] = arg0[1]
			else
				table.remove(var0, var1)
			end
		else
			table.insert(var0, arg0[1])
		end

		var0:updateChapter(arg3)
		var0:duplicateEliteFleet(arg3)
	end

	return var1, var2, var3
end

function var0.getSupportDockCallbackFuncs(arg0, arg1, arg2, arg3)
	local var0 = getProxy(ChapterProxy)

	local function var1(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inSupport", arg0, arg1)

		if not var0 then
			return var0, var1
		end

		for iter0, iter1 in pairs(arg1) do
			if arg0:isSameKind(iter0) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var2(arg0, arg1, arg2)
		arg1()
	end

	local function var3(arg0)
		local var0 = arg3:getSupportFleet()

		if arg2 then
			local var1 = table.indexof(var0, arg2.id)

			assert(var1)

			if arg0[1] then
				var0[var1] = arg0[1]
			else
				table.remove(var0, var1)
			end
		else
			table.insert(var0, arg0[1])
		end

		var0:updateChapter(arg3)
		var0:duplicateSupportFleet(arg3)
	end

	return var1, var2, var3
end

function var0.playAIActions(arg0, arg1, arg2, arg3)
	if not arg0.viewComponent.grid then
		arg3()

		return
	end

	local var0 = getProxy(ChapterProxy)
	local var1

	local function var2()
		if var1 and coroutine.status(var1) == "suspended" then
			local var0, var1 = coroutine.resume(var1)

			assert(var0, debug.traceback(var1, var1))

			if not var0 then
				arg0.viewComponent:unfrozen(-1)
				arg0:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest
				})
			end
		end
	end

	var1 = coroutine.create(function()
		arg0.viewComponent:frozen()

		local var0 = {}
		local var1 = arg2 or 0

		for iter0, iter1 in ipairs(arg1) do
			local var2 = arg0.contextData.chapterVO
			local var3, var4 = iter1:applyTo(var2, true)

			assert(var3, var4)
			iter1:PlayAIAction(arg0.contextData.chapterVO, arg0, function()
				local var0, var1, var2 = iter1:applyTo(var2, false)

				if var0 then
					var0:updateChapter(var2, var1)

					var1 = bit.bor(var1, var2 or 0)
				end

				onNextTick(var2)
			end)
			coroutine.yield()

			if isa(iter1, FleetAIAction) and iter1.actType == ChapterConst.ActType_Poison and var2:existFleet(FleetType.Normal, iter1.line.row, iter1.line.column) then
				local var5 = var2:getFleetIndex(FleetType.Normal, iter1.line.row, iter1.line.column)

				table.insert(var0, var5)
			end
		end

		local var6 = bit.band(var1, ChapterConst.DirtyAutoAction)

		var1 = bit.band(var1, bit.bnot(ChapterConst.DirtyAutoAction))

		if var1 ~= 0 then
			local var7 = arg0.contextData.chapterVO

			var0:updateChapter(var7, var1)
		end

		seriesAsync({
			function(arg0)
				if var6 ~= 0 then
					arg0.viewComponent.levelStageView:tryAutoAction(arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				table.ParallelIpairsAsync(var0, function(arg0, arg1, arg2)
					arg0.viewComponent.grid:showFleetPoisonDamage(arg1, arg2)
				end, arg0)
			end,
			function(arg0)
				arg3()
				arg0.viewComponent:unfrozen()
			end
		})
	end)

	var2()
end

function var0.saveSubState(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("chapter_submarine_ai_type_" .. var0, arg1 + 1)
	PlayerPrefs.Save()
end

function var0.loadSubState(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = PlayerPrefs.GetInt("chapter_submarine_ai_type_" .. var0, 1) - 1
	local var2 = math.clamp(var1, 0, 1)

	if var2 ~= arg1 then
		arg0.viewComponent:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSubState,
			arg1 = var2
		})
	end
end

function var0.remove(arg0)
	arg0:removeSubLayers(LevelContinuousOperationWindowMediator)
	var0.super.remove(arg0)
end

return var0
