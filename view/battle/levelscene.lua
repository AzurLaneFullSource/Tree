local var0_0 = class("LevelScene", import("..base.BaseUI"))
local var1_0 = 0.5
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.getUIName(arg0_2)
	return "LevelMainScene"
end

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = ResList.LevelScene.GetResource(arg0_3, arg1_3)

	return table.insertto(var0_3, var0_0.super.getResource(arg0_3, arg1_3))
end

function var0_0.ResUISettings(arg0_4)
	return {
		groupDelta = 1,
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0_0.getBGM(arg0_5)
	local function var0_5()
		return checkExist(arg0_5.contextData.chapterVO, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	local function var1_5()
		if not arg0_5.contextData.map then
			return
		end

		local var0_7 = arg0_5.contextData.map:getConfig("ani_controller")
		local var1_7 = getProxy(ChapterProxy)

		if var0_7 and #var0_7 > 0 then
			for iter0_7, iter1_7 in ipairs(var0_7) do
				local var2_7 = _.rest(iter1_7[2], 2)

				for iter2_7, iter3_7 in ipairs(var2_7) do
					if string.find(iter3_7, "^bgm_") and iter1_7[1] == var3_0 then
						local var3_7 = iter1_7[2][1]
						local var4_7 = false

						for iter4_7, iter5_7 in ipairs(var3_7) do
							local var5_7 = var1_7:GetChapterItemById(iter5_7)

							if var5_7 and var5_7:isClear() then
								var4_7 = true

								break
							end
						end

						if not var4_7 then
							return string.sub(iter3_7, 5)
						end
					end
				end
			end
		end

		return checkExist(arg0_5.contextData.map, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	for iter0_5, iter1_5 in ipairs({
		var0_5(),
		var1_5()
	}) do
		if iter1_5 ~= "" then
			return iter1_5
		end
	end

	return var0_0.super.getBGM(arg0_5)
end

var0_0.optionsPath = {
	"top/top_chapter/option"
}

function var0_0.preload(arg0_8, arg1_8)
	local var0_8 = getProxy(ChapterProxy)

	if arg0_8.contextData.mapIdx and arg0_8.contextData.chapterId then
		local var1_8 = var0_8:getChapterById(arg0_8.contextData.chapterId)

		if var1_8:getConfig("map") == arg0_8.contextData.mapIdx then
			arg0_8.contextData.chapterVO = var1_8

			if var1_8.active then
				assert(not arg0_8.contextData.openChapterId or arg0_8.contextData.openChapterId == arg0_8.contextData.chapterId)

				arg0_8.contextData.openChapterId = nil
			end
		end
	end

	local var2_8, var3_8 = arg0_8:GetInitializeMap()

	if arg0_8.contextData.entranceStatus == nil then
		arg0_8.contextData.entranceStatus = not var3_8
	end

	arg1_8()
end

function var0_0.GetInitializeMap(arg0_9)
	local var0_9 = (function()
		local var0_10 = arg0_9.contextData.chapterVO

		if var0_10 and var0_10.active then
			return var0_10:getConfig("map")
		end

		local var1_10 = arg0_9.contextData.mapIdx

		if var1_10 then
			return var1_10
		end

		local var2_10

		if arg0_9.contextData.targetChapter and arg0_9.contextData.targetMap then
			arg0_9.contextData.openChapterId = arg0_9.contextData.targetChapter
			var2_10 = arg0_9.contextData.targetMap.id
			arg0_9.contextData.targetChapter = nil
			arg0_9.contextData.targetMap = nil
		elseif arg0_9.contextData.eliteDefault then
			local var3_10 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			var2_10 = var3_10 and var3_10.id or nil
			arg0_9.contextData.eliteDefault = nil
		end

		return var2_10
	end)()
	local var1_9 = var0_9 and getProxy(ChapterProxy):getMapById(var0_9)

	if var1_9 then
		local var2_9, var3_9 = var1_9:isUnlock()

		if not var2_9 then
			pg.TipsMgr.GetInstance():ShowTips(var3_9)

			var0_9 = getProxy(ChapterProxy):getLastUnlockMap().id
			arg0_9.contextData.mapIdx = var0_9
		end
	else
		var0_9 = nil
	end

	return var0_9 or getProxy(ChapterProxy):GetLastNormalMap(), tobool(var0_9)
end

function var0_0.init(arg0_11)
	arg0_11:initData()
	arg0_11:initUI()
	arg0_11:initEvents()
	arg0_11:updateClouds()
end

function var0_0.initData(arg0_12)
	arg0_12.tweens = {}

	local var0_12 = arg0_12._tf.rect.size

	arg0_12.mapWidth, arg0_12.mapHeight = var0_12.x, var0_12.y
	arg0_12.levelCamIndices = 1
	arg0_12.frozenCount = 0
	arg0_12.currentBG = nil
	arg0_12.mbDict = {}
	arg0_12.mapGroup = {}

	if not arg0_12.contextData.huntingRangeVisibility then
		arg0_12.contextData.huntingRangeVisibility = 2
	end
end

function var0_0.initUI(arg0_13)
	arg0_13.topPanel = arg0_13._tf:Find("top")
	arg0_13.canvasGroup = arg0_13.topPanel:GetComponent("CanvasGroup")
	arg0_13.canvasGroup.blocksRaycasts = not arg0_13.canvasGroup.blocksRaycasts
	arg0_13.canvasGroup.blocksRaycasts = not arg0_13.canvasGroup.blocksRaycasts
	arg0_13.entranceLayer = arg0_13._tf:Find("entrance")
	arg0_13.ptBonus = EventPtBonus.New(arg0_13.entranceLayer:Find("btns/btn_task/bonusPt"))
	arg0_13.entranceBg = arg0_13._tf:Find("entrance_bg")
	arg0_13.topChapter = arg0_13.topPanel:Find("top_chapter")

	setActive(arg0_13.topChapter:Find("title_chapter"), false)
	setActive(arg0_13.topChapter:Find("type_chapter"), false)
	setActive(arg0_13.topChapter:Find("type_escort"), false)
	setActive(arg0_13.topChapter:Find("type_skirmish"), false)

	arg0_13.chapterName = arg0_13.topChapter:Find("title_chapter/name")
	arg0_13.chapterNoTitle = arg0_13.topChapter:Find("title_chapter/chapter")
	arg0_13.resChapter = arg0_13.topChapter:Find("resources")

	setActive(arg0_13.topChapter, true)

	arg0_13._voteBookBtn = arg0_13.topChapter:Find("vote_book")
	arg0_13.leftChapter = arg0_13._tf:Find("main/left_chapter")

	setActive(arg0_13.leftChapter, true)

	arg0_13.leftCanvasGroup = arg0_13.leftChapter:GetComponent(typeof(CanvasGroup))
	arg0_13.btnPrev = arg0_13.leftChapter:Find("btn_prev")
	arg0_13.btnPrevCol = arg0_13.leftChapter:Find("btn_prev/prev_image")
	arg0_13.eliteBtn = arg0_13.leftChapter:Find("buttons/btn_elite")
	arg0_13.normalBtn = arg0_13.leftChapter:Find("buttons/btn_normal")
	arg0_13.actNormalBtn = arg0_13.leftChapter:Find("buttons/btn_act_normal")
	arg0_13.actEliteBtn = arg0_13.leftChapter:Find("buttons/btn_act_elite")
	arg0_13.actExtraBtn = arg0_13.leftChapter:Find("buttons/btn_act_extra")
	arg0_13.actExtraBtnAnim = arg0_13.actExtraBtn:Find("usm")
	arg0_13.remasterBtn = arg0_13.leftChapter:Find("buttons/btn_remaster")
	arg0_13.escortBar = arg0_13.leftChapter:Find("escort_bar")
	arg0_13.eliteQuota = arg0_13.leftChapter:Find("elite_quota")
	arg0_13.skirmishBar = arg0_13.leftChapter:Find("left_times")
	arg0_13.mainLayer = arg0_13._tf:Find("main")

	setActive(arg0_13.mainLayer:Find("title_chapter_lines"), false)

	arg0_13.rightChapter = arg0_13._tf:Find("main/right_chapter")
	arg0_13.rightCanvasGroup = arg0_13.rightChapter:GetComponent(typeof(CanvasGroup))
	arg0_13.eventContainer = arg0_13.rightChapter:Find("event_btns/event_container")
	arg0_13.btnSpecial = arg0_13.eventContainer:Find("btn_task")
	arg0_13.challengeBtn = arg0_13.eventContainer:Find("btn_challenge")
	arg0_13.dailyBtn = arg0_13.eventContainer:Find("btn_daily")
	arg0_13.militaryExerciseBtn = arg0_13.eventContainer:Find("btn_pvp")
	arg0_13.activityBtn = arg0_13.rightChapter:Find("event_btns/activity_btn")
	arg0_13.ptTotal = arg0_13.rightChapter:Find("event_btns/pt_text")
	arg0_13.ticketTxt = arg0_13.rightChapter:Find("event_btns/tickets/Text")
	arg0_13.remasterAwardBtn = arg0_13.rightChapter:Find("btn_remaster_award")
	arg0_13.btnNext = arg0_13.rightChapter:Find("btn_next")
	arg0_13.btnNextCol = arg0_13.rightChapter:Find("btn_next/next_image")
	arg0_13.countDown = arg0_13.rightChapter:Find("event_btns/count_down")

	setActive(arg0_13.rightChapter:Find("event_btns/BottomList"), true)

	arg0_13.actExchangeShopBtn = arg0_13.rightChapter:Find("event_btns/BottomList/btn_exchange")
	arg0_13.actAtelierBuffBtn = arg0_13.rightChapter:Find("event_btns/BottomList/btn_control_center")
	arg0_13.actAtelierYumiaBuffBtn = arg0_13.rightChapter:Find("event_btns/BottomList/btn_yumia_buff")
	arg0_13.actExtraRank = arg0_13.rightChapter:Find("event_btns/BottomList/act_extra_rank")

	setActive(arg0_13.rightChapter, true)

	arg0_13.damageTextTemplate = go(arg0_13.topPanel:Find("damage"))

	setActive(arg0_13.damageTextTemplate, false)

	arg0_13.damageTextPool = {
		arg0_13.damageTextTemplate
	}
	arg0_13.damageTextActive = {}
	arg0_13.mapHelpBtn = arg0_13.topPanel:Find("help_button")
	arg0_13.avoidText = arg0_13.topPanel:Find("text_avoid")
	arg0_13.commanderTinkle = arg0_13.topPanel:Find("neko_tinkle")

	setActive(arg0_13.commanderTinkle, false)

	arg0_13.spResult = arg0_13.topPanel:Find("sp_result")

	setActive(arg0_13.spResult, false)

	arg0_13.helpPage = arg0_13.topPanel:Find("help_page")
	arg0_13.helpImage = arg0_13.helpPage:Find("icon")

	setActive(arg0_13.helpPage, false)

	arg0_13.curtain = arg0_13.topPanel:Find("curtain")

	setActive(arg0_13.curtain, false)

	arg0_13.map = arg0_13._tf:Find("maps")
	arg0_13.mapTFs = {
		arg0_13._tf:Find("maps/map1"),
		arg0_13._tf:Find("maps/map2")
	}

	for iter0_13, iter1_13 in ipairs(arg0_13.mapTFs) do
		iter1_13:GetComponent(typeof(Image)).enabled = false
	end

	arg0_13.UIFXList = arg0_13._tf:Find("maps/UI_FX_list")

	local var0_13 = arg0_13.UIFXList:GetComponentsInChildren(typeof(Renderer)):ToTable()

	for iter2_13, iter3_13 in ipairs(var0_13) do
		iter3_13.sortingOrder = -1
	end

	arg0_13.rtRightPanel = arg0_13._tf:Find("entrance/enters/right_panel")
	arg0_13.actBtnTpl = arg0_13.rtRightPanel:Find("content/tpl")

	local var1_13 = pg.UIMgr.GetInstance()

	arg0_13.levelCam = var1_13.levelCamera:GetComponent(typeof(Camera))
	arg0_13.uiMain = var1_13.LevelMain

	setActive(arg0_13.uiMain, false)

	arg0_13.uiCam = var1_13.uiCamera:GetComponent(typeof(Camera))
	arg0_13.levelGrid = arg0_13.uiMain:Find("LevelGrid")

	setActive(arg0_13.levelGrid, true)

	arg0_13.dragLayer = arg0_13.levelGrid:Find("DragLayer")
	arg0_13.float = arg0_13._tf:Find("float")
	arg0_13.clouds = arg0_13.float:Find("clouds")

	setActive(arg0_13.clouds, true)
	setActive(arg0_13.float:Find("levels"), false)

	arg0_13.resources = arg0_13._tf:Find("resources")
	arg0_13.arrowTarget = arg0_13.resources:Find("Tpl_Arrow_Target")
	arg0_13.destinationMarkTpl = arg0_13.resources:Find("Tpl_Destination_Mark")
	arg0_13.championTpl = arg0_13.resources:Find("Tpl_Champion")
	arg0_13.deadTpl = arg0_13.resources:Find("Tpl_Dead")
	arg0_13.enemyTpl = arg0_13.resources:Find("Tpl_Enemy")
	arg0_13.oniTpl = arg0_13.resources:Find("Tpl_Oni")
	arg0_13.shipTpl = arg0_13.resources:Find("Tpl_Ship")
	arg0_13.subTpl = arg0_13.resources:Find("Tpl_Sub")
	arg0_13.transportTpl = arg0_13.resources:Find("Tpl_Transport")

	setText(tf(arg0_13.enemyTpl):Find("fighting/Text"), i18n("ui_word_levelui2_inevent"))
	arg0_13:HideBtns()
	setAnchoredPosition(arg0_13.topChapter, {
		y = 0
	})
	setAnchoredPosition(arg0_13.leftChapter, {
		x = 0
	})
	setAnchoredPosition(arg0_13.rightChapter, {
		x = 0
	})

	arg0_13.bubbleMsgBoxes = {}
	arg0_13.loader = AutoLoader.New()
	arg0_13.levelFleetView = LevelFleetView.New(arg0_13.topPanel, arg0_13.event, arg0_13.contextData)
	arg0_13.levelInfoView = LevelInfoView.New(arg0_13.topPanel, arg0_13.event, arg0_13.contextData)

	arg0_13.levelInfoView:RegisterView(arg0_13)
	arg0_13.levelFleetView:RegisterView(arg0_13)
	arg0_13:buildCommanderPanel()

	arg0_13.levelRemasterView = LevelRemasterView.New(arg0_13.topPanel, arg0_13.event, arg0_13.contextData)
	arg0_13.chapterAutoDetailPanel = ChapterAutoDetailPanel.New(arg0_13.topPanel, arg0_13.event, arg0_13.contextData)

	arg0_13.chapterAutoDetailPanel:RegisterView(arg0_13)
	arg0_13:SwitchMapBuilder(MapBuilder.TYPENORMAL)
end

function var0_0.initEvents(arg0_14)
	arg0_14:bind(LevelUIConst.OPEN_COMMANDER_PANEL, function(arg0_15, arg1_15, arg2_15, arg3_15)
		arg0_14:openCommanderPanel(arg1_15, arg2_15, arg3_15)
	end)
	arg0_14:bind(LevelUIConst.HANDLE_SHOW_MSG_BOX, function(arg0_16, arg1_16)
		arg0_14:HandleShowMsgBox(arg1_16)
	end)
	arg0_14:bind(LevelUIConst.DO_AMBUSH_WARNING, function(arg0_17, arg1_17)
		arg0_14:doAmbushWarning(arg1_17)
	end)
	arg0_14:bind(LevelUIConst.DISPLAY_AMBUSH_INFO, function(arg0_18, arg1_18)
		arg0_14:displayAmbushInfo(arg1_18)
	end)
	arg0_14:bind(LevelUIConst.DISPLAY_STRATEGY_INFO, function(arg0_19, arg1_19)
		arg0_14:displayStrategyInfo(arg1_19)
	end)
	arg0_14:bind(LevelUIConst.FROZEN, function(arg0_20)
		arg0_14:frozen()
	end)
	arg0_14:bind(LevelUIConst.UN_FROZEN, function(arg0_21)
		arg0_14:unfrozen()
	end)
	arg0_14:bind(LevelUIConst.DO_TRACKING, function(arg0_22, arg1_22)
		arg0_14:doTracking(arg1_22)
	end)
	arg0_14:bind(LevelUIConst.SWITCH_TO_MAP, function()
		if arg0_14:isfrozen() then
			return
		end

		arg0_14:switchToMap()
	end)
	arg0_14:bind(LevelUIConst.DISPLAY_REPAIR_WINDOW, function(arg0_24, arg1_24)
		arg0_14:displayRepairWindow(arg1_24)
	end)
	arg0_14:bind(LevelUIConst.DO_PLAY_ANIM, function(arg0_25, arg1_25)
		arg0_14:doPlayAnim(arg1_25.name, arg1_25.callback, arg1_25.onStart)
	end)
	arg0_14:bind(LevelUIConst.HIDE_FLEET_SELECT, function()
		arg0_14:hideFleetSelect()
	end)
	arg0_14:bind(LevelUIConst.HIDE_FLEET_EDIT, function(arg0_27)
		arg0_14:hideFleetEdit()
	end)
	arg0_14:bind(LevelUIConst.ADD_MSG_QUEUE, function(arg0_28, arg1_28)
		arg0_14:addbubbleMsgBox(arg1_28)
	end)
	arg0_14:bind(LevelUIConst.SET_MAP, function(arg0_29, arg1_29)
		arg0_14:setMap(arg1_29)
	end)
end

function var0_0.onZeroHourRefresh(arg0_30)
	if arg0_30.levelInfoView:isShowing() then
		arg0_30.levelInfoView:RefreshChapterAutoPanel()
	end

	if arg0_30.levelInfoSPView and arg0_30.levelInfoSPView:isShowing() then
		arg0_30.levelInfoView:RefreshChapterAutoPanel()
	end
end

function var0_0.addbubbleMsgBox(arg0_31, arg1_31)
	table.insert(arg0_31.bubbleMsgBoxes, arg1_31)

	if #arg0_31.bubbleMsgBoxes > 1 then
		return
	end

	local var0_31

	local function var1_31()
		local var0_32 = arg0_31.bubbleMsgBoxes[1]

		if var0_32 then
			var0_32(function()
				table.remove(arg0_31.bubbleMsgBoxes, 1)
				var1_31()
			end)
		end
	end

	var1_31()
end

function var0_0.CleanBubbleMsgbox(arg0_34)
	table.clean(arg0_34.bubbleMsgBoxes)
end

function var0_0.updatePtActivity(arg0_35, arg1_35)
	arg0_35.ptActivity = arg1_35

	if not arg0_35.ptActivity then
		return
	end

	arg0_35:updateActivityRes()
end

function var0_0.updateActivityRes(arg0_36)
	local var0_36 = findTF(arg0_36.ptTotal, "Text")
	local var1_36 = findTF(arg0_36.ptTotal, "icon/Image")

	if var0_36 and var1_36 and arg0_36.ptActivity then
		setText(var0_36, "x" .. arg0_36.ptActivity.data1)
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = tonumber(arg0_36.ptActivity:getConfig("config_id"))
		}):getIcon(), "", var1_36, true)
	end
end

function var0_0.setCommanderPrefabs(arg0_37, arg1_37)
	arg0_37.commanderPrefabs = arg1_37
end

function var0_0.didEnter(arg0_38)
	arg0_38.openedCommanerSystem = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_38.player.level, "CommanderCatMediator")

	onButton(arg0_38, arg0_38.topChapter:Find("back_button"), function()
		if arg0_38:isfrozen() then
			return
		end

		local var0_39 = arg0_38.contextData.map

		if var0_39 and (var0_39:isActivity() or var0_39:isEscort()) then
			arg0_38:emit(LevelMediator2.ON_SWITCH_NORMAL_MAP)

			return
		elseif var0_39 and var0_39:isSkirmish() then
			arg0_38:emit(var0_0.ON_BACK)
		elseif not arg0_38.contextData.entranceStatus then
			arg0_38:ShowEntranceUI(true)
		else
			arg0_38:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_38, arg0_38.btnSpecial, function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.dailyBtn, function()
		if arg0_38:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_38:updatDailyBtnTip()
		arg0_38:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.challengeBtn, function()
		if arg0_38:isfrozen() then
			return
		end

		local var0_42, var1_42 = arg0_38:checkChallengeOpen()

		if var0_42 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_42)
		else
			arg0_38:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.militaryExerciseBtn, function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.normalBtn, function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:setMap(arg0_38.contextData.map:getBindMapId())
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.eliteBtn, function()
		if arg0_38:isfrozen() then
			return
		end

		if arg0_38.contextData.map:getBindMapId() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

			local var0_45 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			if var0_45 then
				arg0_38:setMap(var0_45.configId)
				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_warp_to_latest_map"))
			end
		elseif arg0_38.contextData.map:isEliteEnabled() then
			arg0_38:setMap(arg0_38.contextData.map:getBindMapId())
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unsatisfied"))
		end
	end, SFX_UI_WEIGHANCHOR_HARD)
	onButton(arg0_38, arg0_38.remasterBtn, function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_38:updateRemasterBtnTip()
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.entranceLayer:Find("enters/enter_main"), function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:ShowSelectedMap(arg0_38:GetInitializeMap())
	end, SFX_PANEL)
	setText(arg0_38.entranceLayer:Find("enters/enter_main/Text"), getProxy(ChapterProxy):getLastUnlockMap():getLastUnlockChapterName())
	onButton(arg0_38, arg0_38.entranceLayer:Find("enters/enter_world/enter"), function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:emit(LevelMediator2.ENTER_WORLD)
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.entranceLayer:Find("enters/enter_ready/activity"), function()
		if arg0_38:isfrozen() then
			return
		end

		switch(arg0_38.entranceActivity:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0_38:emit(LevelMediator2.ON_ACTIVITY_MAP, arg0_38.entranceActivity.id)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
				arg0_38:emit(LevelMediator2.ON_OPEN_ACT_BOSS_BATTLE)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
				arg0_38:emit(LevelMediator2.ON_BOSSRUSH_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
				arg0_38:emit(LevelMediator2.ON_BOSSSINGLE_MAP, {
					mode = OtherworldMapScene.MODE_BATTLE
				})
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
				arg0_38:emit(LevelMediator2.ON_CLUE_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function()
				arg0_38:emit(LevelMediator2.ON_COLLAB_BOSSRUSH_MAP)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.entranceLayer:Find("btns/btn_remaster"), function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_38:updateRemasterBtnTip()
	end, SFX_PANEL)
	setActive(arg0_38.entranceLayer:Find("btns/btn_remaster"), OPEN_REMASTER)
	onButton(arg0_38, arg0_38.entranceLayer:Find("btns/btn_challenge"), function()
		if arg0_38:isfrozen() then
			return
		end

		local var0_57, var1_57 = arg0_38:checkChallengeOpen()

		if var0_57 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_57)
		else
			arg0_38:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.entranceLayer:Find("btns/btn_pvp"), function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.entranceLayer:Find("btns/btn_daily"), function()
		if arg0_38:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_38:updatDailyBtnTip()
		arg0_38:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.entranceLayer:Find("btns/btn_task"), function()
		if arg0_38:isfrozen() then
			return
		end

		arg0_38:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	setActive(arg0_38.entranceLayer:Find("enters/enter_world/enter"), not WORLD_ENTER_LOCK)
	setActive(arg0_38.entranceLayer:Find("enters/enter_world/nothing"), WORLD_ENTER_LOCK)
	setActive(arg0_38.entranceLayer:Find("enters/enter_world/enter/tip"), getProxy(ChapterAutoProxy):IsAllCommissionFinish(ChapterAutoProxy.TYPE.WORLD))

	arg0_38.entranceActivity = getProxy(ActivityProxy):getEnterReadyActivity()[1]

	setActive(arg0_38.entranceLayer:Find("enters/enter_ready/nothing"), not tobool(arg0_38.entranceActivity))
	setActive(arg0_38.entranceLayer:Find("enters/enter_ready/activity"), tobool(arg0_38.entranceActivity))

	if tobool(arg0_38.entranceActivity) then
		local var0_38 = arg0_38.entranceActivity:getConfig("config_client").entrance_bg

		if var0_38 then
			GetImageSpriteFromAtlasAsync(var0_38, "", arg0_38.entranceLayer:Find("enters/enter_ready/activity"), true)
		end
	end

	arg0_38:updateRightPanel()

	local var1_38 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_38.player.level, "EventMediator")

	setActive(arg0_38.btnSpecial:Find("lock"), not var1_38)
	setActive(arg0_38.entranceLayer:Find("btns/btn_task/lock"), not var1_38)

	local var2_38 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_38.player.level, "DailyLevelMediator")

	setActive(arg0_38.dailyBtn:Find("lock"), not var2_38)
	setActive(arg0_38.entranceLayer:Find("btns/btn_daily/lock"), not var2_38)

	local var3_38 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_38.player.level, "MilitaryExerciseMediator")

	setActive(arg0_38.militaryExerciseBtn:Find("lock"), not var3_38)
	setActive(arg0_38.entranceLayer:Find("btns/btn_pvp/lock"), not var3_38)

	local var4_38 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_38.player.level, "WorldMediator")

	setActive(arg0_38.entranceLayer:Find("enters/enter_world/enter/lock"), not var4_38)

	local var5_38 = LimitChallengeConst.IsOpen()

	setActive(arg0_38.challengeBtn:Find("lock"), not var5_38)
	setActive(arg0_38.entranceLayer:Find("btns/btn_challenge/lock"), not var5_38)

	local var6_38 = LimitChallengeConst.IsInAct()

	setActive(arg0_38.challengeBtn, var6_38)
	setActive(arg0_38.entranceLayer:Find("btns/btn_challenge"), var6_38)

	local var7_38 = LimitChallengeConst.IsShowRedPoint()

	setActive(arg0_38.entranceLayer:Find("btns/btn_challenge/tip"), var7_38)
	arg0_38:initMapBtn(arg0_38.btnPrev, -1)
	arg0_38:initMapBtn(arg0_38.btnNext, 1)
	arg0_38:registerActBtn()

	if arg0_38.contextData.editEliteChapter then
		local var8_38 = getProxy(ChapterProxy):getChapterById(arg0_38.contextData.editEliteChapter)

		arg0_38:displayFleetEdit(var8_38)

		arg0_38.contextData.editEliteChapter = nil
	elseif arg0_38.contextData.selectedChapterVO then
		arg0_38:displayFleetSelect(arg0_38.contextData.selectedChapterVO)

		arg0_38.contextData.selectedChapterVO = nil
	end

	local var9_38 = arg0_38.contextData.chapterVO

	if not var9_38 or not var9_38.active then
		arg0_38:tryPlaySubGuide()
	end

	arg0_38:updateRemasterBtnTip()
	arg0_38:updatDailyBtnTip()

	if arg0_38.contextData.open_remaster then
		arg0_38:displayRemasterPanel(arg0_38.contextData.isSP)

		arg0_38.contextData.open_remaster = nil
	end

	arg0_38:ShowEntranceUI(arg0_38.contextData.entranceStatus)

	if not arg0_38.contextData.entranceStatus then
		arg0_38:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg0_38:GetInitializeMap())
	end

	arg0_38:emit(LevelMediator2.ON_DIDENTER)
end

function var0_0.updateRightPanel(arg0_61)
	arg0_61.rightActivityBtns = defaultValue(arg0_61.rightActivityBtns, {
		LevelSecondMapBtn.New(arg0_61.actBtnTpl, arg0_61.event, false)
	})

	local var0_61 = {}
	local var1_61 = {}

	for iter0_61, iter1_61 in ipairs(arg0_61.rightActivityBtns) do
		if iter1_61:InShowTime() then
			table.insert(var0_61, iter1_61)
		else
			table.insert(var1_61, iter1_61)
		end
	end

	table.sort(var0_61, CompareFuncs({
		function(arg0_62)
			return arg0_62.config.group_id
		end
	}))

	for iter2_61, iter3_61 in ipairs(var0_61) do
		iter3_61:Init(iter2_61)
	end

	for iter4_61, iter5_61 in ipairs(var1_61) do
		iter5_61:Clear()
	end
end

function var0_0.checkChallengeOpen(arg0_63)
	local var0_63 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_63, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_64)
	if arg0_64.contextData.map and arg0_64.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_64)
end

function var0_0.onBackPressed(arg0_65)
	if arg0_65:isfrozen() then
		return
	end

	if arg0_65.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_65.chapterAutoDetailPanel:isShowing() then
		arg0_65:HideChapterAutoDetailPanel()
	end

	if arg0_65.levelInfoView:isShowing() then
		arg0_65:hideChapterPanel()

		return
	end

	if arg0_65.levelInfoSPView and arg0_65.levelInfoSPView:isShowing() then
		arg0_65:HideLevelInfoSPPanel()

		return
	end

	if arg0_65.levelFleetView:isShowing() then
		arg0_65:hideFleetEdit()

		return
	end

	if arg0_65.levelStrategyView then
		arg0_65:hideStrategyInfo()

		return
	end

	if arg0_65.levelRepairView then
		arg0_65:hideRepairWindow()

		return
	end

	if arg0_65.levelRemasterView:isShowing() then
		arg0_65:hideRemasterPanel()

		return
	end

	if arg0_65.contextData.map and arg0_65.contextData.map:getConfig("ui_type") == MapBuilder.TYPEEXSP and arg0_65.mapBuilder.personalPage:IsActive() then
		arg0_65.mapBuilder.personalPage:Hide()

		return
	end

	if isActive(arg0_65.helpPage) then
		setActive(arg0_65.helpPage, false)

		return
	end

	local var0_65 = arg0_65.contextData.chapterVO
	local var1_65 = getProxy(ChapterProxy):getActiveChapter()

	if var0_65 and var1_65 then
		arg0_65:switchToMap()

		return
	end

	triggerButton(arg0_65.topChapter:Find("back_button"))
end

function var0_0.ShowEntranceUI(arg0_66, arg1_66)
	setActive(arg0_66.entranceLayer, arg1_66)
	setActive(arg0_66.entranceBg, arg1_66)
	setActive(arg0_66.map, not arg1_66)
	setActive(arg0_66.float, not arg1_66)
	setActive(arg0_66.mainLayer, not arg1_66)
	setActive(arg0_66.topChapter:Find("type_entrance"), arg1_66)

	arg0_66.contextData.entranceStatus = tobool(arg1_66)

	if arg1_66 then
		setActive(arg0_66.topChapter:Find("title_chapter"), false)
		setActive(arg0_66.topChapter:Find("type_chapter"), false)
		setActive(arg0_66.topChapter:Find("type_escort"), false)
		setActive(arg0_66.topChapter:Find("type_skirmish"), false)

		if arg0_66.newChapterCDTimer then
			arg0_66.newChapterCDTimer:Stop()

			arg0_66.newChapterCDTimer = nil
		end

		arg0_66:RecordLastMapOnExit()

		arg0_66.contextData.mapIdx = nil
		arg0_66.contextData.map = nil
	end

	arg0_66:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_67, arg1_67, arg2_67)
	if arg0_67.preloadLevelDone then
		existCall(arg2_67)

		return
	end

	local var0_67

	local function var1_67()
		if not arg0_67.exited then
			arg0_67.preloadLevelDone = true

			existCall(arg2_67)
		end
	end

	local var2_67 = getProxy(ChapterProxy):getMapById(arg1_67)
	local var3_67 = arg0_67:GetMapBG(var2_67)

	table.ParallelIpairsAsync(var3_67, function(arg0_69, arg1_69, arg2_69)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_69.BG, "", arg2_69)
	end, var1_67)
end

function var0_0.setShips(arg0_70, arg1_70)
	arg0_70.shipVOs = arg1_70
end

function var0_0.updateRes(arg0_71, arg1_71)
	if arg0_71.levelStageView then
		arg0_71.levelStageView:ActionInvoke("SetPlayer", arg1_71)
	end

	arg0_71.player = arg1_71
end

function var0_0.setEliteQuota(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg2_72 - arg1_72
	local var1_72 = arg0_72.eliteQuota:Find("bg/Text"):GetComponent(typeof(Text))

	if arg1_72 == arg2_72 then
		var1_72.color = Color.red
	else
		var1_72.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_72.text = var0_72 .. "/" .. arg2_72
end

function var0_0.updateEvent(arg0_73, arg1_73)
	local var0_73 = arg1_73:hasFinishState()

	setActive(arg0_73.btnSpecial:Find("tip"), var0_73)
	setActive(arg0_73.entranceLayer:Find("btns/btn_task/tip"), var0_73)
end

function var0_0.updateFleet(arg0_74, arg1_74)
	arg0_74.fleets = arg1_74
end

function var0_0.updateChapterVO(arg0_75, arg1_75, arg2_75)
	if arg0_75.contextData.chapterVO and arg0_75.contextData.chapterVO.id == arg1_75.id and arg1_75.active then
		arg0_75:setChapter(arg1_75)
	end

	if arg0_75.contextData.chapterVO and arg0_75.contextData.chapterVO.id == arg1_75.id and arg1_75.active and arg0_75.levelStageView and arg0_75.grid then
		local var0_75 = false
		local var1_75 = false
		local var2_75 = false

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyFleet) > 0 then
			arg0_75.levelStageView:updateStageFleet()
			arg0_75.levelStageView:updateAmbushRate(arg1_75.fleet.line, true)

			var2_75 = true

			if arg0_75.grid then
				arg0_75.grid:RefreshFleetCells()
				arg0_75.grid:UpdateFloor()
				arg0_75.grid:UpdateWeatherCells()

				var0_75 = true
			end
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyChampion) > 0 then
			var2_75 = true

			if arg0_75.grid then
				arg0_75.grid:UpdateFleets()
				arg0_75.grid:clearChampions()
				arg0_75.grid:initChampions()

				var1_75 = true
			end
		elseif bit.band(arg2_75, ChapterConst.DirtyChampionPosition) > 0 then
			var2_75 = true

			if arg0_75.grid then
				arg0_75.grid:UpdateFleets()
				arg0_75.grid:updateChampions()

				var1_75 = true
			end
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyAchieve) > 0 then
			arg0_75.levelStageView:updateStageAchieve()
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyAttachment) > 0 then
			arg0_75.levelStageView:updateAmbushRate(arg1_75.fleet.line, true)

			if arg0_75.grid then
				if not (arg2_75 < 0) and not (bit.band(arg2_75, ChapterConst.DirtyFleet) > 0) then
					arg0_75.grid:updateFleet(arg1_75.fleets[arg1_75.findex].id)
				end

				arg0_75.grid:updateAttachments()

				if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyAutoAction) > 0 then
					arg0_75.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_75 = true
				end
			end
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyStrategy) > 0 then
			arg0_75.levelStageView:updateStageStrategy()

			var2_75 = true

			arg0_75.levelStageView:updateStageBarrier()
			arg0_75.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_75 then
			arg0_75.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_75 then
			arg0_75.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyCellFlag) > 0 then
			arg0_75.grid:UpdateFloor()
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyBase) > 0 then
			arg0_75.levelStageView:UpdateDefenseStatus()
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyFloatItems) > 0 then
			arg0_75.grid:UpdateItemCells()
		end

		if arg2_75 < 0 or bit.band(arg2_75, ChapterConst.DirtyWeather) > 0 then
			arg0_75.grid:UpdateWeatherCells()
		end

		if var2_75 then
			arg0_75.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_76)
	arg0_76.cloudRTFs = {}
	arg0_76.cloudRects = {}
	arg0_76.cloudTimer = {}

	for iter0_76 = 1, 6 do
		local var0_76 = arg0_76.clouds:Find("cloud_" .. iter0_76)
		local var1_76 = rtf(var0_76)

		table.insert(arg0_76.cloudRTFs, var1_76)
		table.insert(arg0_76.cloudRects, var1_76.rect.width)
	end

	arg0_76:initCloudsPos()

	for iter1_76, iter2_76 in ipairs(arg0_76.cloudRTFs) do
		local var2_76 = arg0_76.cloudRects[iter1_76]
		local var3_76 = arg0_76.initPositions[iter1_76] or Vector2(0, 0)
		local var4_76 = 30 - var3_76.y / 20
		local var5_76 = (arg0_76.mapWidth + var2_76) / var4_76
		local var6_76

		var6_76 = LeanTween.moveX(iter2_76, arg0_76.mapWidth, var5_76):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_76 = arg0_76.cloudRects[iter1_76]
			iter2_76.anchoredPosition = Vector2(-var2_76, var3_76.y)

			var6_76:setFrom(-var2_76):setTime((arg0_76.mapWidth + var2_76) / var4_76)
		end))
		var6_76.passed = math.random() * var5_76
		arg0_76.cloudTimer[iter1_76] = var6_76.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_78)
	arg0_78:PlayBGM()
	arg0_78:SwitchMapBG(arg0_78.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_79, arg1_79, arg2_79)
	if not arg1_79 then
		return
	end

	local var0_79 = arg0_79.contextData.map:getConfig("ani_controller")

	local function var1_79(arg0_80)
		arg0_80 = tf(arg0_80)

		local var0_80 = Vector3.one

		if arg0_80.rect.width > 0 and arg0_80.rect.height > 0 then
			var0_80.x = arg0_80.parent.rect.width / arg0_80.rect.width
			var0_80.y = arg0_80.parent.rect.height / arg0_80.rect.height
		end

		arg0_80.localScale = var0_80

		if var0_79 and #var0_79 > 0 then
			local var1_80 = getProxy(ChapterProxy)

			;(function()
				for iter0_81, iter1_81 in ipairs(var0_79) do
					local var0_81 = false
					local var1_81 = iter1_81[2][1]

					for iter2_81, iter3_81 in ipairs(var1_81) do
						local var2_81 = var1_80:GetChapterItemById(iter3_81)

						if var2_81 and var2_81:isClear() then
							var0_81 = true

							break
						end
					end

					if iter1_81[1] == var2_0 then
						local var3_81 = _.rest(iter1_81[2], 2)

						for iter4_81, iter5_81 in ipairs(var3_81) do
							local var4_81 = arg0_80:Find(iter5_81)

							if not IsNil(var4_81) and not var0_81 then
								setActive(var4_81, false)
							end
						end
					elseif iter1_81[1] == var3_0 then
						local var5_81 = _.rest(iter1_81[2], 2)

						for iter6_81, iter7_81 in ipairs(var5_81) do
							local var6_81 = arg0_80:Find(iter7_81)

							if not IsNil(var6_81) and not var0_81 then
								setActive(var6_81, true)

								return
							end
						end
					elseif iter1_81[1] == var4_0 then
						local var7_81 = _.rest(iter1_81[2], 2)

						for iter8_81, iter9_81 in ipairs(var7_81) do
							local var8_81 = arg0_80:Find(iter9_81)

							if not IsNil(var8_81) and not var0_81 then
								setActive(var8_81, true)
							end
						end
					end
				end
			end)()
		end
	end

	local var2_79 = arg0_79.loader:GetPrefab("ui/" .. arg1_79, arg1_79, function(arg0_82)
		arg0_82:SetActive(true)

		local var0_82 = arg0_79.mapTFs[arg2_79]

		setParent(arg0_82, var0_82)
		pg.ViewUtils.SetSortingOrder(arg0_82, ChapterConst.LayerWeightMap + arg2_79 * 2 - 1)
		var1_79(arg0_82)
	end)

	table.insert(arg0_79.mapGroup, var2_79)
end

function var0_0.HideBtns(arg0_83)
	setActive(arg0_83.btnPrev, false)
	setActive(arg0_83.eliteQuota, false)
	setActive(arg0_83.escortBar, false)
	setActive(arg0_83.skirmishBar, false)
	setActive(arg0_83.normalBtn, false)
	setActive(arg0_83.actNormalBtn, false)
	setActive(arg0_83.eliteBtn, false)
	setActive(arg0_83.actEliteBtn, false)
	setActive(arg0_83.actExtraBtn, false)
	setActive(arg0_83.remasterBtn, false)
	setActive(arg0_83.btnNext, false)
	setActive(arg0_83.remasterAwardBtn, false)
	setActive(arg0_83.eventContainer, false)
	setActive(arg0_83.activityBtn, false)
	setActive(arg0_83.ptTotal, false)
	setActive(arg0_83.ticketTxt.parent, false)
	setActive(arg0_83.countDown, false)
	setActive(arg0_83.actAtelierBuffBtn, false)
	setActive(arg0_83.actAtelierYumiaBuffBtn, false)
	setActive(arg0_83.actExtraRank, false)
	setActive(arg0_83.actExchangeShopBtn, false)
	setActive(arg0_83.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_84)
	local var0_84 = arg0_84.contextData.map:getConfig("type")

	setActive(arg0_84.normalBtn, var0_84 == Map.ELITE)
	setActive(arg0_84.eliteQuota, var0_84 == Map.ELITE)
	setActive(arg0_84.eliteBtn, var0_84 == Map.SCENARIO)

	local var1_84 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_84.eliteBtn:Find("pic_activity"), var1_84 and not var1_84:isEnd())
end

function var0_0.updateActivityBtns(arg0_85)
	local var0_85 = arg0_85.contextData.map
	local var1_85, var2_85 = var0_85:isActivity()
	local var3_85 = var0_85:isRemaster()
	local var4_85 = var0_85:isSkirmish()
	local var5_85 = var0_85:isEscort()
	local var6_85 = var0_85:getConfig("type")
	local var7_85 = setmetatable({}, MainActMapBtn)
	local var8_85 = var7_85:InShowTime() and not var1_85 and not var4_85 and not var5_85

	arg0_85.activityBtnLinkAct = var7_85:GetActivity()

	if var8_85 then
		var7_85.image = arg0_85.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var7_85.subImage = arg0_85.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var7_85.tipTr = arg0_85.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var7_85.tipTxt = arg0_85.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_85 = var7_85:InShowTime()

		if var8_85 then
			var7_85:InitTipImage()
			var7_85:InitSubImage()
			var7_85:InitImage(function()
				return
			end)
			var7_85:OnInit()
		end
	end

	setActive(arg0_85.activityBtn, var8_85)
	arg0_85:updateRemasterInfo()

	if var1_85 and var2_85 then
		local var9_85

		if var0_85:isRemaster() then
			var9_85 = getProxy(ChapterProxy):getRemasterMaps(var0_85.remasterId)
		else
			var9_85 = getProxy(ChapterProxy):getMapsByActivities(var0_85:getConfig("on_activity"))
		end

		local var10_85 = underscore.any(var9_85, function(arg0_87)
			return arg0_87:isActExtra()
		end)

		setActive(arg0_85.actExtraBtn, var10_85 and var6_85 ~= Map.ACT_EXTRA)

		if isActive(arg0_85.actExtraBtn) then
			if underscore.all(underscore.filter(var9_85, function(arg0_88)
				local var0_88 = arg0_88:getMapType()

				return var0_88 == Map.ACTIVITY_EASY or var0_88 == Map.ACTIVITY_HARD
			end), function(arg0_89)
				return arg0_89:isAllChaptersClear()
			end) then
				setActive(arg0_85.actExtraBtnAnim, true)
			else
				setActive(arg0_85.actExtraBtnAnim, false)
			end

			setActive(arg0_85.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive(var0_85:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_85 = checkExist(var0_85:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_85.actEliteBtn, var11_85 and var6_85 ~= Map.ACTIVITY_HARD)
		setActive(arg0_85.actNormalBtn, var6_85 ~= Map.ACTIVITY_EASY)
		setActive(arg0_85.actExtraRank, var6_85 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_90)
			if not arg0_90 or arg0_90:isEnd() then
				return
			end

			local var0_90 = arg0_90:getConfig("config_data")[1]

			return _.any(var0_85:getChapters(), function(arg0_91)
				if not arg0_91:IsEXChapter() then
					return false
				end

				return table.contains(arg0_91:getConfig("boss_expedition_id"), var0_90)
			end)
		end))
		setActive(arg0_85.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_85 and var2_85 and arg0_85:IsActShopActive())

		local var12_85 = arg0_85.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_85.contextData.map:getConfig("on_activity")) or nil
		local var13_85 = var12_85 and not var12_85:isEnd() and var12_85:GetConfigClientSetting("PTID")

		arg0_85:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_92)
			return arg0_92:getConfig("config_id") == var13_85
		end))
		setActive(arg0_85.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_85 and var2_85 and arg0_85.ptActivity and not arg0_85.ptActivity:isEnd())
	else
		setActive(arg0_85.actExtraBtn, false)
		setActive(arg0_85.actEliteBtn, false)
		setActive(arg0_85.actNormalBtn, false)
		setActive(arg0_85.actExtraRank, false)
		setActive(arg0_85.actExchangeShopBtn, false)
		setActive(arg0_85.actAtelierBuffBtn, false)
		setActive(arg0_85.actAtelierYumiaBuffBtn, false)
		setActive(arg0_85.ptTotal, false)
	end

	setActive(arg0_85.eventContainer, (not var1_85 or not var2_85) and not var5_85)
	setActive(arg0_85.remasterBtn, OPEN_REMASTER and (var3_85 or not var1_85 and not var5_85 and not var4_85))
	setActive(arg0_85.ticketTxt.parent, var3_85)
	arg0_85:updateRemasterTicket()
	arg0_85:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_93)
	setText(arg0_93.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_93:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_94)
	local var0_94 = getProxy(ChapterProxy)
	local var1_94 = var0_94:ifShowRemasterTip() or var0_94:anyRemasterAwardCanReceive()

	SetActive(arg0_94.remasterBtn:Find("tip"), var1_94)
	SetActive(arg0_94.entranceLayer:Find("btns/btn_remaster/tip"), var1_94)
end

function var0_0.updatDailyBtnTip(arg0_95)
	local var0_95 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_95.dailyBtn:Find("tip"), var0_95)
	SetActive(arg0_95.entranceLayer:Find("btns/btn_daily/tip"), var0_95)
end

function var0_0.updateRemasterInfo(arg0_96)
	arg0_96:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_96.contextData.map then
		return
	end

	local var0_96 = getProxy(ChapterProxy)
	local var1_96 = arg0_96.contextData.map:getRemaster()
	local var2_96 = BossRushChapterRemasterHelper.ChapterAwardInfo(var1_96)

	setActive(arg0_96.remasterAwardBtn, var2_96)

	if var2_96 then
		local var3_96 = var2_96[1]
		local var4_96, var5_96, var6_96, var7_96, var8_96 = unpack(var2_96[2])
		local var9_96 = var2_96[3]
		local var10_96 = var0_96:getRemasterInfo(var9_96, var4_96, var3_96)

		setText(arg0_96.remasterAwardBtn:Find("Text"), var10_96.count .. "/" .. var7_96)
		updateDrop(arg0_96.remasterAwardBtn:Find("IconTpl"), {
			type = var5_96,
			id = var6_96
		})
		setActive(arg0_96.remasterAwardBtn:Find("tip"), var7_96 <= var10_96.count)
		onButton(arg0_96, arg0_96.remasterAwardBtn, function()
			local var0_97 = BossRushChapterRemasterHelper.GetAwardName(var9_96, var4_96)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_96,
					id = var6_96
				},
				remaster = {
					word = i18n("level_remaster_tip4", var0_97),
					number = var10_96.count .. "/" .. var7_96,
					btn_text = i18n(var10_96.count < var7_96 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var10_96.count < var7_96 then
							if var9_96 and var9_96 > 0 then
								arg0_96:emit(LevelMediator2.ON_BOSSRUSH_REMASTER_ACTIVITY, var9_96)

								return
							end

							local var0_98 = pg.chapter_template[var4_96].map
							local var1_98, var2_98 = var0_96:getMapById(var0_98):isUnlock()

							if not var1_98 then
								pg.TipsMgr.GetInstance():ShowTips(var2_98)
							else
								arg0_96:ShowSelectedMap(var0_98)
							end
						else
							arg0_96:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_96, var3_96, var9_96)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_99)
	local var0_99 = getProxy(ChapterProxy)

	if arg0_99.newChapterCDTimer then
		arg0_99.newChapterCDTimer:Stop()

		arg0_99.newChapterCDTimer = nil
	end

	local var1_99 = 0

	if arg0_99.contextData.map:isActivity() and not arg0_99.contextData.map:isRemaster() then
		local var2_99 = var0_99:getMapsByActivities(arg0_99.contextData.map:getConfig("on_activity"))

		_.each(var2_99, function(arg0_100)
			local var0_100 = arg0_100:getChapterTimeLimit()

			if var1_99 == 0 then
				var1_99 = var0_100
			else
				var1_99 = math.min(var1_99, var0_100)
			end
		end)
		setActive(arg0_99.countDown, var1_99 > 0)
		setText(arg0_99.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_99.countDown, false)
	end

	if var1_99 > 0 then
		setText(arg0_99.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_99))

		arg0_99.newChapterCDTimer = Timer.New(function()
			var1_99 = var1_99 - 1

			if var1_99 <= 0 then
				arg0_99:updateCountDown()

				if not arg0_99.contextData.chapterVO then
					arg0_99:setMap(arg0_99.contextData.mapIdx)
				end
			else
				setText(arg0_99.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_99))
			end
		end, 1, -1)

		arg0_99.newChapterCDTimer:Start()
	else
		setText(arg0_99.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_102)
	onButton(arg0_102, arg0_102.actExtraRank, function()
		if arg0_102:isfrozen() then
			return
		end

		arg0_102:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_102, arg0_102.activityBtn, function()
		if arg0_102:isfrozen() then
			return
		end

		if arg0_102.activityBtnLinkAct then
			local var0_104 = arg0_102.activityBtnLinkAct:getConfig("type")
			local var1_104 = arg0_102.activityBtnLinkAct.id

			if var0_104 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)

				return
			elseif var0_104 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)

				return
			elseif var1_104 == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)

				return
			elseif var0_104 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ZHANG_WU_BOSS)

				return
			end
		end

		arg0_102:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_102, arg0_102.actExchangeShopBtn, function()
		if arg0_102:isfrozen() then
			return
		end

		arg0_102:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_102, arg0_102.actAtelierBuffBtn, function()
		if arg0_102:isfrozen() then
			return
		end

		arg0_102:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)
	onButton(arg0_102, arg0_102.actAtelierYumiaBuffBtn, function()
		if arg0_102:isfrozen() then
			return
		end

		arg0_102:emit(LevelMediator2.SHOW_ATELIER_BUFF, true)
	end, SFX_UI_CLICK)

	local var0_102 = getProxy(ChapterProxy)

	local function var1_102(arg0_108, arg1_108, arg2_108)
		local var0_108

		if arg0_108:isRemaster() then
			var0_108 = var0_102:getRemasterMaps(arg0_108.remasterId)
		else
			var0_108 = var0_102:getMapsByActivities(arg0_108:getConfig("on_activity"))
		end

		local var1_108 = _.select(var0_108, function(arg0_109)
			return arg0_109:getMapType() == arg1_108
		end)

		table.sort(var1_108, function(arg0_110, arg1_110)
			return arg0_110.id < arg1_110.id
		end)

		local var2_108 = table.indexof(underscore.map(var1_108, function(arg0_111)
			return arg0_111.id
		end), arg2_108) or #var1_108

		while not var1_108[var2_108]:isUnlock() do
			if var2_108 > 1 then
				var2_108 = var2_108 - 1
			else
				break
			end
		end

		return var1_108[var2_108]
	end

	arg0_102:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_112, arg1_112, arg2_112)
		arg2_112 = arg2_112 or switch(arg1_112, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_102.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_102.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_112 = var1_102(arg0_102.contextData.map, arg1_112, arg2_112)
		local var1_112, var2_112 = var0_112:isUnlock()

		if var1_112 then
			arg0_102:setMap(var0_112.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_112)
		end
	end)
	onButton(arg0_102, arg0_102.actNormalBtn, function()
		if arg0_102:isfrozen() then
			return
		end

		arg0_102:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_102, arg0_102.actEliteBtn, function()
		if arg0_102:isfrozen() then
			return
		end

		arg0_102:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_102, arg0_102.actExtraBtn, function()
		if arg0_102:isfrozen() then
			return
		end

		arg0_102:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_119, arg1_119)
	arg0_119.initPositions = {}

	local var0_119 = arg1_119 or 1
	local var1_119 = pg.expedition_data_by_map[var0_119].clouds_pos

	for iter0_119, iter1_119 in ipairs(arg0_119.cloudRTFs) do
		local var2_119 = var1_119[iter0_119]

		if var2_119 then
			iter1_119.anchoredPosition = Vector2(var2_119[1], var2_119[2])

			table.insert(arg0_119.initPositions, iter1_119.anchoredPosition)
		else
			setActive(iter1_119, false)
		end
	end
end

function var0_0.initMapBtn(arg0_120, arg1_120, arg2_120)
	onButton(arg0_120, arg1_120, function()
		if arg0_120:isfrozen() then
			return
		end

		local var0_121 = arg0_120.contextData.mapIdx + arg2_120
		local var1_121 = getProxy(ChapterProxy):getMapById(var0_121)

		if not var1_121 then
			return
		end

		if var1_121:getMapType() == Map.ELITE and not var1_121:isEliteEnabled() then
			var1_121 = var1_121:getBindMap()
			var0_121 = var1_121.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_121, var3_121 = var1_121:isUnlock()

		if arg2_120 > 0 and not var2_121 then
			pg.TipsMgr.GetInstance():ShowTips(var3_121)

			return
		end

		arg0_120:setMap(var0_121)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_122, arg1_122, arg2_122)
	seriesAsync({
		function(arg0_123)
			if arg0_122.contextData.entranceStatus then
				arg0_122:frozen()

				arg0_122.nextPreloadMap = arg1_122

				arg0_122:PreloadLevelMainUI(arg1_122, function()
					arg0_122:unfrozen()

					if arg0_122.nextPreloadMap ~= arg1_122 then
						return
					end

					arg0_122:ShowEntranceUI(false)
					arg0_122:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_122)
					arg0_123()
				end)
			else
				arg0_122:setMap(arg1_122)
				arg0_123()
			end
		end
	}, arg2_122)
end

function var0_0.setMap(arg0_125, arg1_125)
	local var0_125 = arg0_125.contextData.mapIdx

	arg0_125.contextData.mapIdx = arg1_125
	arg0_125.contextData.map = getProxy(ChapterProxy):getMapById(arg1_125)

	assert(arg0_125.contextData.map, "map cannot be nil " .. arg1_125)

	if arg0_125.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_125.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_125.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_125.contextData.map.remasterId, arg1_125)
		PlayerPrefs.Save()
	end

	arg0_125:RecordLastMapOnExit()
	arg0_125:updateMap(var0_125)
	arg0_125:tryPlayMapStory()
end

local var5_0 = import("view.level.MapBuilder.MapBuilder")
local var6_0 = {
	[var5_0.TYPENORMAL] = "MapBuilderNormal",
	[var5_0.TYPEESCORT] = "MapBuilderEscort",
	[var5_0.TYPESHINANO] = "MapBuilderShinano",
	[var5_0.TYPESKIRMISH] = "MapBuilderSkirmish",
	[var5_0.TYPEBISMARCK] = "MapBuilderBismarck",
	[var5_0.TYPESSSS] = "MapBuilderSSSS",
	[var5_0.TYPEATELIER] = "MapBuilderAtelier",
	[var5_0.TYPESENRANKAGURA] = "MapBuilderSenrankagura",
	[var5_0.TYPESP] = "MapBuilderSP",
	[var5_0.TYPESPFULL] = "MapBuilderSPFull",
	[var5_0.TYPESPSERIES] = "MapBuilderSPSeries",
	[var5_0.TYPESPSERIESFULL] = "MapBuilderSPSeriesFull",
	[var5_0.TYPEATELIERYUMIA] = "MapBuilderAtelierYumia",
	[var5_0.TYPEEXSP] = "MapBuilderEXSP",
	[var5_0.TYPESPSERIESRECREW] = "MapBuilderSPSeriesRecrew"
}

function var0_0.SwitchMapBuilder(arg0_126, arg1_126)
	if arg0_126.mapBuilder and arg0_126.mapBuilder:GetType() ~= arg1_126 then
		arg0_126.mapBuilder.buffer:Hide()
	end

	local var0_126 = arg0_126:GetMapBuilderInBuffer(arg1_126)

	arg0_126.mapBuilder = var0_126

	var0_126.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_127, arg1_127)
	if not arg0_127.mbDict[arg1_127] then
		local var0_127 = _G[var6_0[arg1_127]]

		assert(var0_127, "Missing MapBuilder of type " .. (arg1_127 or "NIL"))

		arg0_127.mbDict[arg1_127] = var0_127.New(arg0_127._tf, arg0_127)
		arg0_127.mbDict[arg1_127].isFrozen = arg0_127:isfrozen()

		arg0_127.mbDict[arg1_127]:Load()
	end

	return arg0_127.mbDict[arg1_127]
end

function var0_0.updateMap(arg0_128, arg1_128)
	local var0_128 = arg0_128.contextData.map
	local var1_128 = var0_128:getConfig("anchor")
	local var2_128

	if var1_128 == "" then
		var2_128 = Vector2(0.5, 0.5)
	else
		var2_128 = Vector2(unpack(var1_128))
	end

	arg0_128.map.pivot = var2_128

	local var3_128 = var0_128:getConfig("uifx")

	for iter0_128 = 1, arg0_128.UIFXList.childCount do
		local var4_128 = arg0_128.UIFXList:GetChild(iter0_128 - 1)

		setActive(var4_128, var4_128.name == var3_128)
	end

	arg0_128:SwitchMapBG(var0_128, arg1_128)
	arg0_128:PlayBGM()

	local var5_128 = arg0_128.contextData.map:getConfig("ui_type")

	arg0_128:SwitchMapBuilder(var5_128)
	seriesAsync({
		function(arg0_129)
			arg0_128.mapBuilder:CallbackInvoke(arg0_129)
		end,
		function(arg0_130)
			arg0_128.mapBuilder:UpdateMapVO(var0_128)
			arg0_128.mapBuilder:UpdateView()
			arg0_128.mapBuilder:UpdateMapItems()
			arg0_128.mapBuilder:PlayEnterAnim()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_131)
	local var0_131 = arg0_131.contextData.map
	local var1_131 = getProxy(ChapterProxy)
	local var2_131 = var1_131:getMapById(var0_131.id - 1)
	local var3_131 = var1_131:getMapById(var0_131.id + 1)

	setActive(arg0_131.btnPrev, tobool(var2_131))
	setActive(arg0_131.btnNext, tobool(var3_131))

	local var4_131 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_131.btnPrevCol, var2_131 and Color.white or var4_131)
	setImageColor(arg0_131.btnNextCol, var3_131 and var3_131:isUnlock() and Color.white or var4_131)
end

function var0_0.tryPlayMapStory(arg0_132)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_133)
			local var0_133 = arg0_132.contextData.map:getConfig("enter_story")

			if var0_133 and var0_133 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_133) and not arg0_132.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_133 = tonumber(var0_133)

				if var1_133 and var1_133 > 0 then
					arg0_132:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_133)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_133, arg0_133)
				end

				return
			end

			arg0_133()
		end,
		function(arg0_134)
			local var0_134 = arg0_132.contextData.map:getConfig("guide_id")

			if var0_134 and var0_134 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_134, nil, arg0_134)

				return
			end

			arg0_134()
		end,
		function(arg0_135)
			if isActive(arg0_132.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_135 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_135

				if var0_135 then
					var1_135 = {
						1,
						2
					}
				else
					var1_135 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_135)
			else
				arg0_135()
			end
		end,
		function(arg0_136)
			if arg0_132.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_132.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_137, arg1_137, arg2_137, arg3_137)
	arg0_137.uiAnims = arg0_137.uiAnims or {}

	local var0_137 = arg0_137.uiAnims[arg1_137]

	local function var1_137()
		arg0_137.playing = true

		arg0_137:frozen()
		var0_137:SetActive(true)

		local var0_138 = tf(var0_137)

		pg.UIMgr.GetInstance():OverlayPanel(var0_138)

		if arg3_137 then
			arg3_137(var0_137)
		end

		var0_138:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_139)
			arg0_137.playing = false

			if arg2_137 then
				arg2_137(var0_137)
			end

			arg0_137:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_137 then
		PoolMgr.GetInstance():GetUI(arg1_137, true, function(arg0_140)
			arg0_140:SetActive(true)

			arg0_137.uiAnims[arg1_137] = arg0_140
			var0_137 = arg0_137.uiAnims[arg1_137]

			var1_137()
		end)
	else
		var1_137()
	end
end

function var0_0.displaySpResult(arg0_141, arg1_141, arg2_141)
	setActive(arg0_141.spResult, true)
	arg0_141:DisplaySPAnim(arg1_141 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_142)
		onButton(arg0_141, arg0_142, function()
			removeOnButton(arg0_142)
			setActive(arg0_142, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_142, arg0_141._tf)
			arg0_141:hideSpResult()
			arg2_141()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_144)
	setActive(arg0_144.spResult, false)
end

function var0_0.displayBombResult(arg0_145, arg1_145)
	setActive(arg0_145.spResult, true)
	arg0_145:DisplaySPAnim("SpBombRet", function(arg0_146)
		onButton(arg0_145, arg0_146, function()
			removeOnButton(arg0_146)
			setActive(arg0_146, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_146, arg0_145._tf)
			arg0_145:hideSpResult()
			arg1_145()
		end, SFX_PANEL)
	end, function(arg0_148)
		setText(arg0_148.transform:Find("right/name_bg/en"), arg0_145.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_149, arg1_149, arg2_149)
	arg0_149.contextData.chapterLoopFlag = arg2_149

	local var0_149 = getProxy(ChapterProxy):getChapterById(arg1_149, true)

	if var0_149:getConfig("type") == Chapter.CustomFleet then
		arg0_149:displayFleetEdit(var0_149)

		return
	end

	if #var0_149:getNpcShipByType(1) > 0 then
		arg0_149:emit(LevelMediator2.ON_TRACKING, arg1_149)

		return
	end

	arg0_149:displayFleetSelect(var0_149)
end

function var0_0.DisplayLevelInfoPanel(arg0_150, arg1_150, arg2_150)
	seriesAsync({
		function(arg0_151)
			if not arg0_150.levelInfoView:GetLoaded() then
				arg0_150:frozen()
				arg0_150.levelInfoView:Load()
				arg0_150.levelInfoView:CallbackInvoke(function()
					arg0_150:unfrozen()
					arg0_151()
				end)

				return
			end

			arg0_151()
		end,
		function(arg0_153)
			local function var0_153(arg0_154, arg1_154)
				arg0_150:hideChapterPanel()
				arg0_150:OnLevelInfoPanelConfirm(arg0_154, arg1_154)
			end

			local function var1_153()
				arg0_150:hideChapterPanel()
			end

			local var2_153 = getProxy(ChapterProxy):getChapterById(arg1_150, true)

			if getProxy(ChapterProxy):getMapById(var2_153:getConfig("map")):isSkirmish() and #var2_153:getNpcShipByType(1) > 0 then
				var0_153(false)

				return
			end

			arg0_150.levelInfoView:set(arg1_150, arg2_150)
			arg0_150.levelInfoView:setCBFunc(var0_153, var1_153)
			arg0_150.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_156)
	if arg0_156.levelInfoView:isShowing() then
		arg0_156.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_157)
	arg0_157.levelInfoView:Destroy()

	arg0_157.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_158, arg1_158, arg2_158, arg3_158)
	seriesAsync({
		function(arg0_159)
			if not arg0_158.levelInfoSPView then
				arg0_158.levelInfoSPView = LevelInfoSPView.New(arg0_158.topPanel, arg0_158.event, arg0_158.contextData)

				arg0_158.levelInfoSPView:RegisterView(arg0_158)
				arg0_158:frozen()
				arg0_158.levelInfoSPView:Load()
				arg0_158.levelInfoSPView:CallbackInvoke(function()
					arg0_158:unfrozen()
					arg0_159()
				end)

				return
			end

			arg0_159()
		end,
		function(arg0_161)
			local function var0_161(arg0_162, arg1_162)
				arg0_158:HideLevelInfoSPPanel()
				arg0_158:OnLevelInfoPanelConfirm(arg0_162, arg1_162)
			end

			local function var1_161()
				arg0_158:HideLevelInfoSPPanel()
			end

			arg0_158.levelInfoSPView:SetChapterGroupInfo(arg2_158)
			arg0_158.levelInfoSPView:set(arg1_158, arg3_158)
			arg0_158.levelInfoSPView:setCBFunc(var0_161, var1_161)
			arg0_158.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_164)
	if arg0_164.levelInfoSPView and arg0_164.levelInfoSPView:isShowing() then
		arg0_164.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_165)
	if not arg0_165.levelInfoSPView then
		return
	end

	arg0_165.levelInfoSPView:Destroy()

	arg0_165.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_166, arg1_166)
	local var0_166 = arg0_166.contextData.selectedFleetIDs or arg1_166:GetDefaultFleetIndex()

	arg1_166 = Clone(arg1_166)
	arg1_166.loopFlag = arg0_166.contextData.chapterLoopFlag

	arg0_166.levelFleetView:updateSpecialOperationTickets(arg0_166.spTickets)
	arg0_166.levelFleetView:Load()
	arg0_166.levelFleetView:ActionInvoke("setHardShipVOs", arg0_166.shipVOs)
	arg0_166.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_166.openedCommanerSystem)
	arg0_166.levelFleetView:ActionInvoke("set", arg1_166, arg0_166.fleets, var0_166)
	arg0_166.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_167)
	if arg0_167.levelCMDFormationView:isShowing() then
		arg0_167.levelCMDFormationView:Hide()
	end

	if arg0_167.levelFleetView then
		arg0_167.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_168)
	arg0_168.levelCMDFormationView = LevelCMDFormationView.New(arg0_168.topPanel, arg0_168.event, arg0_168.contextData)
end

function var0_0.destroyFleetSelect(arg0_169)
	if not arg0_169.levelFleetView then
		return
	end

	arg0_169.levelFleetView:Destroy()

	arg0_169.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_170, arg1_170)
	arg1_170 = Clone(arg1_170)
	arg1_170.loopFlag = arg0_170.contextData.chapterLoopFlag

	arg0_170.levelFleetView:updateSpecialOperationTickets(arg0_170.spTickets)
	arg0_170.levelFleetView:Load()
	arg0_170.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_170.openedCommanerSystem)
	arg0_170.levelFleetView:ActionInvoke("setHardShipVOs", arg0_170.shipVOs)
	arg0_170.levelFleetView:ActionInvoke("setOnHard", arg1_170)
	arg0_170.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_171)
	arg0_171:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_172)
	arg0_172:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_173, arg1_173)
	if not arg0_173.levelFleetView then
		return
	end

	assert(arg0_173.levelFleetView:GetLoaded())

	local var0_173 = arg0_173.levelFleetView:IsSelectMode()
	local var1_173

	if var0_173 then
		arg0_173.levelFleetView:ActionInvoke("set", arg1_173 or arg0_173.levelFleetView.chapter, arg0_173.fleets, arg0_173.levelFleetView:getSelectIds())

		if arg0_173.levelCMDFormationView:isShowing() then
			local var2_173 = arg0_173.levelCMDFormationView.fleet.id

			var1_173 = arg0_173.fleets[var2_173]
		end
	else
		arg0_173.levelFleetView:ActionInvoke("setOnHard", arg1_173 or arg0_173.levelFleetView.chapter)

		if arg0_173.levelCMDFormationView:isShowing() then
			local var3_173 = arg0_173.levelCMDFormationView.fleet.id

			var1_173 = arg1_173:wrapEliteFleet(var3_173)
		end
	end

	if var1_173 then
		arg0_173.levelCMDFormationView:ActionInvoke("updateFleet", var1_173)
	end
end

function var0_0.setChapter(arg0_174, arg1_174)
	local var0_174

	if arg1_174 then
		var0_174 = arg1_174.id
	end

	arg0_174.contextData.chapterId = var0_174
	arg0_174.contextData.chapterVO = arg1_174
end

function var0_0.switchToChapter(arg0_175, arg1_175)
	if arg0_175.contextData.mapIdx ~= arg1_175:getConfig("map") then
		arg0_175:setMap(arg1_175:getConfig("map"))
	end

	arg0_175:setChapter(arg1_175)

	arg0_175.leftCanvasGroup.blocksRaycasts = false
	arg0_175.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_175.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_175:DestroyLevelStageView()

	if not arg0_175.levelStageView then
		arg0_175.levelStageView = LevelStageView.New(arg0_175.topPanel, arg0_175.event, arg0_175.contextData)

		arg0_175.levelStageView:Load()

		arg0_175.levelStageView.isFrozen = arg0_175:isfrozen()
	end

	arg0_175:frozen()

	local function var0_175()
		seriesAsync({
			function(arg0_177)
				arg0_175.mapBuilder:CallbackInvoke(arg0_177)
			end,
			function(arg0_178)
				setActive(arg0_175.clouds, false)
				arg0_175.mapBuilder:HideFloat()
				arg0_175:BlurPanel(arg0_175.topPanel, {
					blurCamList = {
						pg.UIMgr.CameraUI
					}
				})
				arg0_175.levelStageView:updateStageInfo()
				arg0_175.levelStageView:updateAmbushRate(arg1_175.fleet.line, true)
				arg0_175.levelStageView:updateStageAchieve()
				arg0_175.levelStageView:updateStageBarrier()
				arg0_175.levelStageView:updateBombPanel()
				arg0_175.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_178)
			end,
			function(arg0_179)
				if arg0_175.exited then
					return
				end

				arg0_175.levelStageView:updateStageStrategy()

				arg0_175.canvasGroup.blocksRaycasts = arg0_175.frozenCount == 0

				onNextTick(arg0_179)
			end,
			function(arg0_180)
				if arg0_175.exited then
					return
				end

				arg0_175.levelStageView:updateStageFleet()
				arg0_175.levelStageView:updateSupportFleet()
				arg0_175.levelStageView:updateFleetBuff()
				onNextTick(arg0_180)
			end,
			function(arg0_181)
				if arg0_175.exited then
					return
				end

				parallelAsync({
					function(arg0_182)
						local var0_182 = arg1_175:getConfig("scale")
						local var1_182 = LeanTween.value(go(arg0_175.map), arg0_175.map.localScale, Vector3.New(var0_182[3], var0_182[3], 1), var1_0):setOnUpdateVector3(function(arg0_183)
							arg0_175.map.localScale = arg0_183
							arg0_175.float.localScale = arg0_183
						end):setOnComplete(System.Action(function()
							arg0_175.mapBuilder:ShowFloat()
							arg0_175.mapBuilder:Hide()
							arg0_182()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_175:RecordTween("mapScale", var1_182.uniqueId)

						local var2_182 = LeanTween.value(go(arg0_175.map), arg0_175.map.pivot, Vector2.New(math.clamp(var0_182[1] - 0.5, 0, 1), math.clamp(var0_182[2] - 0.5, 0, 1)), var1_0)

						var2_182:setOnUpdateVector2(function(arg0_185)
							arg0_175.map.pivot = arg0_185
							arg0_175.float.pivot = arg0_185
						end):setEase(LeanTweenType.easeOutSine)
						arg0_175:RecordTween("mapPivot", var2_182.uniqueId)
						shiftPanel(arg0_175.leftChapter, -arg0_175.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_175.rightChapter, arg0_175.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_175.topChapter, 0, arg0_175.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_175.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_186)
						arg0_175:PlayBGM()

						local var0_186 = {}
						local var1_186 = arg1_175:getConfig("bg")

						if var1_186 and #var1_186 > 0 then
							var0_186[1] = {
								BG = var1_186
							}
						end

						arg0_175:SwitchBG(var0_186, arg0_186)
					end
				}, function()
					onNextTick(arg0_181)
				end)
			end,
			function(arg0_188)
				if arg0_175.exited then
					return
				end

				setActive(arg0_175.topChapter, false)
				setActive(arg0_175.leftChapter, false)
				setActive(arg0_175.rightChapter, false)

				arg0_175.leftCanvasGroup.blocksRaycasts = true
				arg0_175.rightCanvasGroup.blocksRaycasts = true

				arg0_175:initGrid(arg0_188)
			end,
			function(arg0_189)
				if arg0_175.exited then
					return
				end

				arg0_175.levelStageView:SetGrid(arg0_175.grid)

				arg0_175.contextData.huntingRangeVisibility = arg0_175.contextData.huntingRangeVisibility - 1

				arg0_175.grid:toggleHuntingRange()

				local var0_189 = arg1_175:getConfig("pop_pic")

				if var0_189 and #var0_189 > 0 and arg0_175.FirstEnterChapter == arg1_175.id then
					arg0_175:doPlayAnim(var0_189, function(arg0_190)
						setActive(arg0_190, false)

						if arg0_175.exited then
							return
						end

						arg0_189()
					end)
				else
					arg0_189()
				end
			end,
			function(arg0_191)
				arg0_175.levelStageView:tryAutoAction(arg0_191)
			end,
			function(arg0_192)
				if arg0_175.exited then
					return
				end

				arg0_175:unfrozen()

				if arg0_175.FirstEnterChapter then
					arg0_175:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_175.subAutoAttack)
				end

				arg0_175.FirstEnterChapter = nil

				arg0_192()
			end,
			function(arg0_193)
				if arg1_175:NeedSupportSubmarineStage() then
					arg0_175.levelStageView:TryEnterChapterSupportSubmarineStage(arg0_193)
				else
					arg0_193()
				end
			end
		}, function()
			arg0_175.levelStageView:tryAutoTrigger(true)
		end)
	end

	arg0_175.levelStageView:ActionInvoke("SetSeriesOperation", var0_175)
	arg0_175.levelStageView:ActionInvoke("SetPlayer", arg0_175.player)
	arg0_175.levelStageView:ActionInvoke("SwitchToChapter", arg1_175)
end

function var0_0.switchToMap(arg0_195, arg1_195)
	arg0_195:frozen()
	arg0_195:destroyGrid()
	arg0_195:setChapter(nil)
	LeanTween.cancel(go(arg0_195.map))

	local var0_195 = LeanTween.value(go(arg0_195.map), arg0_195.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_196)
		arg0_195.map.localScale = arg0_196
		arg0_195.float.localScale = arg0_196
	end):setOnComplete(System.Action(function()
		arg0_195:unfrozen()
		arg0_195.mapBuilder:PlayEnterAnim()
		existCall(arg1_195)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_195:RecordTween("mapScale", var0_195.uniqueId)

	local var1_195 = arg0_195.contextData.map:getConfig("anchor")
	local var2_195

	if var1_195 == "" then
		var2_195 = Vector2(0.5, 0.5)
	else
		var2_195 = Vector2(unpack(var1_195))
	end

	local var3_195 = LeanTween.value(go(arg0_195.map), arg0_195.map.pivot, var2_195, var1_0)

	var3_195:setOnUpdateVector2(function(arg0_198)
		arg0_195.map.pivot = arg0_198
		arg0_195.float.pivot = arg0_198
	end):setEase(LeanTweenType.easeOutSine)
	arg0_195:RecordTween("mapPivot", var3_195.uniqueId)
	setActive(arg0_195.topChapter, true)
	setActive(arg0_195.leftChapter, true)
	setActive(arg0_195.rightChapter, true)
	shiftPanel(arg0_195.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_195.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_195.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_195.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_195.levelStageView then
		arg0_195.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_195:DestroyLevelStageView()
		end)
		arg0_195.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_195:SwitchMapBG(arg0_195.contextData.map)
	arg0_195:PlayBGM()
	seriesAsync({
		function(arg0_200)
			arg0_195.mapBuilder:CallbackInvoke(arg0_200)
		end,
		function(arg0_201)
			arg0_195.mapBuilder:Show()
			arg0_195.mapBuilder:UpdateView()
			arg0_195.mapBuilder:UpdateMapItems()
		end
	})
	arg0_195:UnOverlayPanel(arg0_195.topPanel, arg0_195._tf)

	arg0_195.canvasGroup.blocksRaycasts = arg0_195.frozenCount == 0
	arg0_195.canvasGroup.interactable = true

	if arg0_195.ambushWarning and arg0_195.ambushWarning.activeSelf then
		arg0_195.ambushWarning:SetActive(false)
		arg0_195:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_202, arg1_202, arg2_202, arg3_202)
	if not arg1_202 or #arg1_202 <= 0 then
		existCall(arg2_202)

		return
	elseif arg3_202 then
		-- block empty
	elseif table.equal(arg0_202.currentBG, arg1_202) then
		return
	end

	arg0_202.currentBG = arg1_202

	for iter0_202, iter1_202 in ipairs(arg0_202.mapGroup) do
		arg0_202.loader:ClearRequest(iter1_202)
	end

	table.clear(arg0_202.mapGroup)

	local var0_202 = {}

	table.ParallelIpairsAsync(arg1_202, function(arg0_203, arg1_203, arg2_203)
		local var0_203 = arg0_202.mapTFs[arg0_203]
		local var1_203 = arg1_203.bgPrefix and arg1_203.bgPrefix .. "/" or "levelmap/"
		local var2_203 = arg0_202.loader:GetSpriteDirect(var1_203 .. arg1_203.BG, "", function(arg0_204)
			var0_202[arg0_203] = arg0_204

			arg2_203()
		end, var0_203)

		table.insert(arg0_202.mapGroup, var2_203)
		arg0_202:updateCouldAnimator(arg1_203.Animator, arg0_203)
	end, function()
		for iter0_205, iter1_205 in ipairs(arg0_202.mapTFs) do
			setImageSprite(iter1_205, var0_202[iter0_205])
			setActive(iter1_205, arg1_202[iter0_205])
			SetCompomentEnabled(iter1_205, typeof(Image), true)
		end

		existCall(arg2_202)
	end)
end

local var7_0 = {
	1520001,
	1520002,
	1520011,
	1520012
}
local var8_0 = {
	{
		1420008,
		"map_1420008",
		1420021,
		"map_1420001"
	},
	{
		1420018,
		"map_1420018",
		1420031,
		"map_1420011"
	}
}
local var9_0 = {
	1420001,
	1420011
}

function var0_0.ClearMapTransitions(arg0_206)
	if not arg0_206.mapTransitions then
		return
	end

	for iter0_206, iter1_206 in pairs(arg0_206.mapTransitions) do
		if iter1_206 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_206, iter0_206, iter1_206, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_206, iter0_206)
		end
	end

	arg0_206.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_207, arg1_207, arg2_207, arg3_207)
	local var0_207, var1_207, var2_207 = arg0_207:GetMapBG(arg1_207, arg2_207)
	local var3_207 = {}

	if var1_207 then
		table.insert(var3_207, function(arg0_208)
			arg0_207:PlayMapTransition("LevelMapTransition_" .. var1_207, var2_207, arg0_208)
		end)
	end

	seriesAsync(var3_207, function()
		arg0_207:SwitchBGMapType(arg1_207:getConfig("pos_type"))
		arg0_207:SwitchBG(var0_207, nil, arg3_207)
	end)
end

function var0_0.SwitchBGMapType(arg0_210, arg1_210)
	if arg0_210.posType == arg1_210 then
		return
	end

	for iter0_210, iter1_210 in ipairs({
		arg0_210.map,
		arg0_210.float
	}) do
		local var0_210 = GetOrAddComponent(iter1_210, typeof(AspectRatioFitter))

		var0_210.aspectRatio = 1.77777777777778
		var0_210.enabled = arg1_210 == 0

		if arg1_210 == 1 then
			iter1_210.anchorMin = Vector2(0.5, 0.5)
			iter1_210.anchorMax = Vector2(0.5, 0.5)

			setSizeDelta(var0_210, {
				x = 2520,
				y = 1440
			})
		end
	end
end

function var0_0.GetMapBG(arg0_211, arg1_211, arg2_211)
	if not table.contains(var7_0, arg1_211.id) then
		return {
			arg0_211:GetMapElement(arg1_211)
		}
	end

	local var0_211 = arg1_211.id
	local var1_211 = table.indexof(var7_0, var0_211) - 1
	local var2_211 = bit.lshift(bit.rshift(var1_211, 1), 1) + 1
	local var3_211 = {
		var7_0[var2_211],
		var7_0[var2_211 + 1]
	}
	local var4_211 = _.map(var3_211, function(arg0_212)
		return getProxy(ChapterProxy):getMapById(arg0_212)
	end)

	if _.all(var4_211, function(arg0_213)
		return arg0_213:isAllChaptersClear()
	end) then
		local var5_211 = {
			arg0_211:GetMapElement(arg1_211)
		}

		if not arg2_211 or math.abs(var0_211 - arg2_211) ~= 1 then
			return var5_211
		end

		local var6_211 = var9_0[bit.rshift(var2_211 - 1, 1) + 1]
		local var7_211 = bit.band(var1_211, 1) == 1

		return var5_211, var6_211, var7_211
	else
		local var8_211 = 0

		;(function()
			local var0_214 = var4_211[1]:getChapters()

			for iter0_214, iter1_214 in ipairs(var0_214) do
				if not iter1_214:isClear() then
					return
				end

				var8_211 = var8_211 + 1
			end

			if not var4_211[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_211 = var8_211 + 1

			local var1_214 = var4_211[2]:getChapters()

			for iter2_214, iter3_214 in ipairs(var1_214) do
				if not iter3_214:isClear() then
					return
				end

				var8_211 = var8_211 + 1
			end
		end)()

		local var9_211

		if var8_211 > 0 then
			local var10_211 = var8_0[bit.rshift(var2_211 - 1, 1) + 1]

			var9_211 = {
				{
					BG = "map_" .. var10_211[1],
					Animator = var10_211[2]
				},
				{
					BG = "map_" .. var10_211[3] + var8_211,
					Animator = var10_211[4]
				}
			}
		else
			var9_211 = {
				arg0_211:GetMapElement(arg1_211)
			}
		end

		return var9_211
	end
end

function var0_0.GetMapElement(arg0_215, arg1_215)
	local var0_215 = arg1_215:getConfig("bg")
	local var1_215 = arg1_215:getConfig("ani_controller")

	if var1_215 and #var1_215 > 0 then
		(function()
			local var0_216 = getProxy(ChapterProxy)

			for iter0_216, iter1_216 in ipairs(var1_215) do
				local var1_216 = _.rest(iter1_216[2], 2)

				for iter2_216, iter3_216 in ipairs(var1_216) do
					if string.find(iter3_216, "^map_") and iter1_216[1] == var3_0 then
						local var2_216 = iter1_216[2][1]
						local var3_216 = false

						for iter4_216, iter5_216 in ipairs(var2_216) do
							local var4_216 = var0_216:GetChapterItemById(iter5_216)

							if var4_216 and var4_216:isClear() then
								var3_216 = true

								break
							end
						end

						if not var3_216 then
							var0_215 = iter3_216

							return
						end
					end
				end
			end
		end)()
	end

	local var2_215 = {
		BG = var0_215
	}

	var2_215.Animator, var2_215.AnimatorController = arg0_215:GetMapAnimator(arg1_215)

	return var2_215
end

function var0_0.GetMapAnimator(arg0_217, arg1_217)
	local var0_217 = arg1_217:getConfig("ani_name")

	if arg1_217:getConfig("animtor") == 1 and var0_217 and #var0_217 > 0 then
		local var1_217 = arg1_217:getConfig("ani_controller")

		if var1_217 and #var1_217 > 0 then
			(function()
				local var0_218 = getProxy(ChapterProxy)

				for iter0_218, iter1_218 in ipairs(var1_217) do
					local var1_218 = _.rest(iter1_218[2], 2)

					for iter2_218, iter3_218 in ipairs(var1_218) do
						if string.find(iter3_218, "^effect_") and iter1_218[1] == var3_0 then
							local var2_218 = iter1_218[2][1]
							local var3_218 = false

							for iter4_218, iter5_218 in ipairs(var2_218) do
								local var4_218 = var0_218:GetChapterItemById(iter5_218)

								if var4_218 and var4_218:isClear() then
									var3_218 = true

									break
								end
							end

							if not var3_218 then
								var0_217 = "map_" .. string.sub(iter3_218, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_217, var1_217
	end
end

function var0_0.PlayMapTransition(arg0_219, arg1_219, arg2_219, arg3_219, arg4_219)
	arg0_219.mapTransitions = arg0_219.mapTransitions or {}

	local var0_219

	local function var1_219()
		arg0_219:frozen()
		existCall(arg3_219, var0_219)
		var0_219:SetActive(true)

		local var0_220 = tf(var0_219)

		pg.UIMgr.GetInstance():OverlayPanel(var0_220)
		var0_219:GetComponent(typeof(Animator)):Play(arg2_219 and "Sequence" or "Inverted", -1, 0)
		var0_220:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_221)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_220, arg0_219._tf)
			existCall(arg4_219, var0_219)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_219, arg1_219, var0_219)

			arg0_219.mapTransitions[arg1_219] = false

			arg0_219:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_219, arg1_219, true, function(arg0_222)
		var0_219 = arg0_222
		arg0_219.mapTransitions[arg1_219] = arg0_222

		var1_219()
	end)
end

function var0_0.DestroyLevelStageView(arg0_223)
	if arg0_223.levelStageView then
		arg0_223.levelStageView:Destroy()

		arg0_223.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_224, arg1_224)
	arg0_224.levelAmbushView = LevelAmbushView.New(arg0_224.topPanel, arg0_224.event, arg0_224.contextData)

	arg0_224.levelAmbushView:Load()
	arg0_224.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_224)
end

function var0_0.hideAmbushInfo(arg0_225)
	if arg0_225.levelAmbushView then
		arg0_225.levelAmbushView:Destroy()

		arg0_225.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_226, arg1_226)
	arg0_226:frozen()

	local function var0_226()
		arg0_226.ambushWarning:SetActive(true)

		local var0_227 = tf(arg0_226.ambushWarning)

		var0_227:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_227:SetSiblingIndex(1)

		local var1_227 = var0_227:GetComponent("DftAniEvent")

		var1_227:SetTriggerEvent(function(arg0_228)
			arg1_226()
		end)
		var1_227:SetEndEvent(function(arg0_229)
			arg0_226.ambushWarning:SetActive(false)
			arg0_226:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_226.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_231)
			arg0_231:SetActive(true)

			arg0_226.ambushWarning = arg0_231

			var0_226()
		end)
	else
		var0_226()
	end
end

function var0_0.destroyAmbushWarn(arg0_232)
	if arg0_232.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_232.ambushWarning)

		arg0_232.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_233, arg1_233)
	arg0_233.levelStrategyView = LevelStrategyView.New(arg0_233.topPanel, arg0_233.event, arg0_233.contextData)

	arg0_233.levelStrategyView:Load()
	arg0_233.levelStrategyView:ActionInvoke("set", arg1_233)

	local function var0_233()
		local var0_234 = arg0_233.contextData.chapterVO.fleet
		local var1_234 = pg.strategy_data_template[arg1_233.id]

		if not var0_234:canUseStrategy(arg1_233) then
			return
		end

		local var2_234 = var0_234:getNextStgUser(arg1_233.id)

		if var1_234.type == ChapterConst.StgTypeForm then
			arg0_233:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_234,
				arg1 = arg1_233.id
			})
		elseif var1_234.type == ChapterConst.StgTypeConsume then
			arg0_233:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_234,
				arg1 = arg1_233.id
			})
		end

		arg0_233:hideStrategyInfo()
	end

	local function var1_233()
		arg0_233:hideStrategyInfo()
	end

	arg0_233.levelStrategyView:ActionInvoke("setCBFunc", var0_233, var1_233)
end

function var0_0.hideStrategyInfo(arg0_236)
	if arg0_236.levelStrategyView then
		arg0_236.levelStrategyView:Destroy()

		arg0_236.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_237, arg1_237)
	local var0_237 = arg0_237.contextData.chapterVO
	local var1_237 = getProxy(ChapterProxy)
	local var2_237
	local var3_237
	local var4_237
	local var5_237
	local var6_237 = var1_237.repairTimes
	local var7_237, var8_237, var9_237 = ChapterConst.GetRepairParams()

	arg0_237.levelRepairView = LevelRepairView.New(arg0_237.topPanel, arg0_237.event, arg0_237.contextData)

	arg0_237.levelRepairView:Load()
	arg0_237.levelRepairView:ActionInvoke("set", var6_237, var7_237, var8_237, var9_237)

	local function var10_237()
		if var7_237 - math.min(var6_237, var7_237) == 0 and arg0_237.player:getTotalGem() < var9_237 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_237:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_237.fleet.id,
			arg1 = arg1_237.id
		})
		arg0_237:hideRepairWindow()
	end

	local function var11_237()
		arg0_237:hideRepairWindow()
	end

	arg0_237.levelRepairView:ActionInvoke("setCBFunc", var10_237, var11_237)
end

function var0_0.hideRepairWindow(arg0_240)
	if arg0_240.levelRepairView then
		arg0_240.levelRepairView:Destroy()

		arg0_240.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_241, arg1_241)
	arg0_241.levelRemasterView:Load()

	local function var0_241(arg0_242)
		arg0_241:ShowSelectedMap(arg0_242)
	end

	arg0_241.levelRemasterView:ActionInvoke("Show")
	arg0_241.levelRemasterView:ActionInvoke("set", var0_241, arg1_241)
end

function var0_0.hideRemasterPanel(arg0_243)
	if arg0_243.levelRemasterView:isShowing() then
		arg0_243.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_244, arg1_244)
	local var0_244 = arg0_244.contextData.chapterVO

	if not var0_244 then
		return
	end

	arg0_244:enableLevelCamera()
	setActive(arg0_244.uiMain, true)

	arg0_244.levelGrid.localEulerAngles = Vector3(var0_244.theme.angle, 0, 0)
	arg0_244.grid = LevelGrid.New(arg0_244.dragLayer)

	arg0_244.grid:attach(arg0_244)
	arg0_244.grid:ExtendItem("shipTpl", arg0_244.shipTpl)
	arg0_244.grid:ExtendItem("subTpl", arg0_244.subTpl)
	arg0_244.grid:ExtendItem("transportTpl", arg0_244.transportTpl)
	arg0_244.grid:ExtendItem("enemyTpl", arg0_244.enemyTpl)
	arg0_244.grid:ExtendItem("championTpl", arg0_244.championTpl)
	arg0_244.grid:ExtendItem("oniTpl", arg0_244.oniTpl)
	arg0_244.grid:ExtendItem("arrowTpl", arg0_244.arrowTarget)
	arg0_244.grid:ExtendItem("destinationMarkTpl", arg0_244.destinationMarkTpl)

	function arg0_244.grid.onShipStepChange(arg0_245)
		arg0_244.levelStageView:updateAmbushRate(arg0_245)
	end

	arg0_244.grid:initAll(arg1_244)
end

function var0_0.destroyGrid(arg0_246)
	if arg0_246.grid then
		arg0_246.grid:detach()

		arg0_246.grid = nil

		arg0_246:disableLevelCamera()
		setActive(arg0_246.dragLayer, true)
		setActive(arg0_246.uiMain, false)
	end
end

function var0_0.doTracking(arg0_247, arg1_247)
	arg0_247:frozen()

	local function var0_247()
		arg0_247.radar:SetActive(true)

		local var0_248 = tf(arg0_247.radar)

		var0_248:SetParent(arg0_247.topPanel, false)
		var0_248:SetSiblingIndex(1)
		var0_248:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_249)
			arg0_247.radar:SetActive(false)
			arg0_247:unfrozen()
			arg1_247()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_247.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_250)
			arg0_250:SetActive(true)

			arg0_247.radar = arg0_250

			var0_247()
		end)
	else
		var0_247()
	end
end

function var0_0.destroyTracking(arg0_251)
	if arg0_251.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_251.radar)

		arg0_251.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_252, arg1_252, arg2_252, arg3_252)
	local function var0_252()
		arg0_252.playing = true

		arg0_252:frozen()
		arg0_252.airStrike:SetActive(true)

		local var0_253 = tf(arg0_252.airStrike)

		var0_253:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_253:SetAsLastSibling()
		setActive(var0_253:Find("words/be_striked"), arg1_252 == ChapterConst.SubjectChampion)
		setActive(var0_253:Find("words/strike_enemy"), arg1_252 == ChapterConst.SubjectPlayer)

		local function var1_253()
			arg0_252.playing = false

			SetActive(arg0_252.airStrike, false)

			if arg3_252 then
				arg3_252()
			end

			arg0_252:unfrozen()
		end

		var0_253:GetComponent("DftAniEvent"):SetEndEvent(var1_253)

		if arg2_252 then
			onButton(arg0_252, var0_253, var1_253, SFX_PANEL)
		else
			removeOnButton(var0_253)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_252.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_255)
			arg0_255:SetActive(true)

			arg0_252.airStrike = arg0_255

			var0_252()
		end)
	else
		var0_252()
	end
end

function var0_0.destroyAirStrike(arg0_256)
	if arg0_256.airStrike then
		arg0_256.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_256.airStrike)

		arg0_256.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_257, arg1_257, arg2_257, arg3_257)
	arg0_257.uiAnims = arg0_257.uiAnims or {}

	local var0_257 = arg0_257.uiAnims[arg1_257]

	local function var1_257()
		arg0_257.playing = true

		arg0_257:frozen()
		var0_257:SetActive(true)

		local var0_258 = tf(var0_257)

		pg.UIMgr.GetInstance():OverlayPanel(var0_258)

		if arg3_257 then
			arg3_257(var0_257)
		end

		var0_258:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_259)
			arg0_257.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_258, arg0_257._tf)

			if arg2_257 then
				arg2_257(var0_257)
			end

			arg0_257:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_257 then
		PoolMgr.GetInstance():GetUI(arg1_257, true, function(arg0_260)
			arg0_260:SetActive(true)

			arg0_257.uiAnims[arg1_257] = arg0_260
			var0_257 = arg0_257.uiAnims[arg1_257]

			var1_257()
		end)
	else
		var1_257()
	end
end

function var0_0.destroyUIAnims(arg0_261)
	if arg0_261.uiAnims then
		for iter0_261, iter1_261 in pairs(arg0_261.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_261), arg0_261._tf)
			iter1_261:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_261, iter1_261)
		end

		arg0_261.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_262, arg1_262)
	local function var0_262()
		arg0_262.playing = true

		arg0_262:frozen()
		arg0_262.torpetoAni:SetActive(true)

		local var0_263 = tf(arg0_262.torpetoAni)

		var0_263:SetParent(arg0_262.topPanel, false)
		var0_263:SetAsLastSibling()
		var0_263:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_264)
			arg0_262.playing = false

			SetActive(arg0_262.torpetoAni, false)

			if arg1_262 then
				arg1_262()
			end

			arg0_262:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_262.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_265)
			arg0_265:SetActive(true)

			arg0_262.torpetoAni = arg0_265

			var0_262()
		end)
	else
		var0_262()
	end
end

function var0_0.destroyTorpedo(arg0_266)
	if arg0_266.torpetoAni then
		arg0_266.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_266.torpetoAni)

		arg0_266.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_267, arg1_267, arg2_267, arg3_267)
	arg0_267.strikeAnims = arg0_267.strikeAnims or {}

	local var0_267
	local var1_267
	local var2_267

	local function var3_267()
		if coroutine.status(var2_267) == "suspended" then
			local var0_268, var1_268 = coroutine.resume(var2_267)

			assert(var0_268, debug.traceback(var2_267, var1_268))
		end
	end

	var2_267 = coroutine.create(function()
		arg0_267.playing = true

		arg0_267:frozen()

		local var0_269 = arg0_267.strikeAnims[arg2_267]

		setActive(var0_269, true)

		local var1_269 = tf(var0_269)
		local var2_269 = findTF(var1_269, "torpedo")
		local var3_269 = findTF(var1_269, "mask/painting")
		local var4_269 = findTF(var1_269, "ship")

		setParent(var0_267, var3_269:Find("fitter"), false)
		var1_267:SetParent(var4_269)
		setActive(var4_269, false)
		setActive(var2_269, false)
		var1_269:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_269:SetAsLastSibling()

		local var5_269 = var1_269:GetComponent("DftAniEvent")
		local var6_269 = var1_267:GetSkeletonGraphic()

		var5_269:SetStartEvent(function(arg0_270)
			var1_267:SetAction("attack", 0)

			var6_269.freeze = true
		end)
		var5_269:SetTriggerEvent(function(arg0_271)
			var6_269.freeze = false

			var1_267:SetActionCallBack(function(arg0_272)
				if arg0_272 == "action" then
					-- block empty
				elseif arg0_272 == "finish" then
					var6_269.freeze = true
				end
			end)
		end)
		var5_269:SetEndEvent(function(arg0_273)
			var6_269.freeze = false

			var3_267()
		end)
		onButton(arg0_267, var1_269, var3_267, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_269, arg1_267:getPainting())
		var1_267:SetActionCallBack(nil)

		var6_269.freeze = false

		var1_267:Dispose()
		setActive(var0_269, false)

		arg0_267.playing = false

		arg0_267:unfrozen()

		if arg3_267 then
			arg3_267()
		end
	end)

	local function var4_267()
		if arg0_267.strikeAnims[arg2_267] and var0_267 and var1_267 then
			var3_267()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_267:getPainting(), true, function(arg0_275)
		var0_267 = arg0_275

		ShipExpressionHelper.SetExpression(var0_267, arg1_267:getPainting())
		var4_267()
	end)

	var1_267 = SpineAnimChar.New()

	var1_267:SetPaint(arg1_267:getPrefab())
	var1_267:Load(true, function(arg0_276)
		var1_267:SetLocalScale(Vector3.one)
		var4_267()
	end)

	if not arg0_267.strikeAnims[arg2_267] then
		PoolMgr.GetInstance():GetUI(arg2_267, true, function(arg0_277)
			arg0_267.strikeAnims[arg2_267] = arg0_277

			var4_267()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_278)
	if arg0_278.strikeAnims then
		for iter0_278, iter1_278 in pairs(arg0_278.strikeAnims) do
			iter1_278:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_278, iter1_278)
		end

		arg0_278.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_279, arg1_279, arg2_279, arg3_279)
	arg0_279.strikeAnims = arg0_279.strikeAnims or {}

	local var0_279
	local var1_279

	local function var2_279()
		if coroutine.status(var1_279) == "suspended" then
			local var0_280, var1_280 = coroutine.resume(var1_279)

			assert(var0_280, debug.traceback(var1_279, var1_280))
		end
	end

	var1_279 = coroutine.create(function()
		arg0_279.playing = true

		arg0_279:frozen()

		local var0_281 = arg0_279.strikeAnims[arg2_279]

		setActive(var0_281, true)

		local var1_281 = tf(var0_281)
		local var2_281 = findTF(var1_281, "torpedo")
		local var3_281 = findTF(var1_281, "ship")

		var0_279:SetParent(var3_281)
		setActive(var3_281, false)
		setActive(var2_281, false)
		var1_281:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_281:SetAsLastSibling()

		local var4_281 = var1_281:GetComponent("DftAniEvent")
		local var5_281 = var0_279:GetSkeletonGraphic()

		var4_281:SetStartEvent(function(arg0_282)
			var0_279:SetAction("attack", 0)

			var5_281.freeze = true
		end)
		var4_281:SetTriggerEvent(function(arg0_283)
			var5_281.freeze = false

			var0_279:SetActionCallBack(function(arg0_284)
				if arg0_284 == "action" then
					-- block empty
				elseif arg0_284 == "finish" then
					var5_281.freeze = true
				end
			end)
		end)
		var4_281:SetEndEvent(function(arg0_285)
			var5_281.freeze = false

			var2_279()
		end)
		onButton(arg0_279, var1_281, var2_279, SFX_CANCEL)
		coroutine.yield()
		var0_279:SetActionCallBack(nil)

		var5_281.freeze = false

		var0_279:Dispose()
		setActive(var0_281, false)

		arg0_279.playing = false

		arg0_279:unfrozen()

		if arg3_279 then
			arg3_279()
		end
	end)

	local function var3_279()
		if arg0_279.strikeAnims[arg2_279] and var0_279 then
			var2_279()
		end
	end

	var0_279 = SpineAnimChar.New()

	var0_279:SetPaint(arg1_279:getPrefab())
	var0_279:Load(true, function(arg0_287)
		arg0_287:SetLocalScale(Vector3.one)
		var3_279()
	end)

	if not arg0_279.strikeAnims[arg2_279] then
		PoolMgr.GetInstance():GetUI(arg2_279, true, function(arg0_288)
			arg0_279.strikeAnims[arg2_279] = arg0_288

			var3_279()
		end)
	end
end

function var0_0.doPlayCommander(arg0_289, arg1_289, arg2_289)
	arg0_289:frozen()
	setActive(arg0_289.commanderTinkle, true)

	local var0_289 = arg1_289:getSkills()

	setText(arg0_289.commanderTinkle:Find("name"), #var0_289 > 0 and var0_289[1]:getConfig("name") or "")
	setImageSprite(arg0_289.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_289:getConfig("painting"), ""))

	local var1_289 = arg0_289.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_289.alpha = 0

	local var2_289 = Vector2(248, 237)

	LeanTween.value(go(arg0_289.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_290)
		local var0_290 = arg0_289.commanderTinkle.localPosition

		var0_290.x = var2_289.x + -100 * (1 - arg0_290)
		arg0_289.commanderTinkle.localPosition = var0_290
		var1_289.alpha = arg0_290
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_289.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_291)
		local var0_291 = arg0_289.commanderTinkle.localPosition

		var0_291.x = var2_289.x + 100 * arg0_291
		arg0_289.commanderTinkle.localPosition = var0_291
		var1_289.alpha = 1 - arg0_291
	end)):setOnComplete(System.Action(function()
		if arg2_289 then
			arg2_289()
		end

		arg0_289:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_293, arg1_293, arg2_293, arg3_293)
	local var0_293 = arg0_293.grid:shakeCell(arg1_293)

	if not var0_293 then
		arg3_293()

		return
	end

	arg0_293:easeDamage(var0_293, arg2_293, function()
		arg3_293()
	end)
end

function var0_0.easeDamage(arg0_295, arg1_295, arg2_295, arg3_295)
	arg0_295:frozen()

	local var0_295 = arg0_295.levelCam:WorldToScreenPoint(arg1_295.position)
	local var1_295 = tf(arg0_295:GetDamageText())

	var1_295.position = arg0_295.uiCam:ScreenToWorldPoint(var0_295)

	local var2_295 = var1_295.localPosition

	var2_295.y = var2_295.y + 40
	var2_295.z = 0

	setText(var1_295, arg2_295)

	var1_295.localPosition = var2_295

	LeanTween.value(go(var1_295), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_296)
		local var0_296 = var1_295.localPosition

		var0_296.y = var2_295.y + 60 * arg0_296
		var1_295.localPosition = var0_296

		setTextAlpha(var1_295, 1 - arg0_296)
	end)):setOnComplete(System.Action(function()
		arg0_295:ReturnDamageText(var1_295)
		arg0_295:unfrozen()

		if arg3_295 then
			arg3_295()
		end
	end))
end

function var0_0.easeAvoid(arg0_298, arg1_298, arg2_298)
	arg0_298:frozen()

	local var0_298 = arg0_298.levelCam:WorldToScreenPoint(arg1_298)

	arg0_298.avoidText.position = arg0_298.uiCam:ScreenToWorldPoint(var0_298)

	local var1_298 = arg0_298.avoidText.localPosition

	var1_298.z = 0
	arg0_298.avoidText.localPosition = var1_298

	setActive(arg0_298.avoidText, true)

	local var2_298 = arg0_298.avoidText:Find("avoid")

	LeanTween.value(go(arg0_298.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_299)
		local var0_299 = arg0_298.avoidText.localPosition

		var0_299.y = var1_298.y + 100 * arg0_299
		arg0_298.avoidText.localPosition = var0_299

		setImageAlpha(arg0_298.avoidText, 1 - arg0_299)
		setImageAlpha(var2_298, 1 - arg0_299)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_298.avoidText, false)
		arg0_298:unfrozen()

		if arg2_298 then
			arg2_298()
		end
	end))
end

function var0_0.GetDamageText(arg0_301)
	local var0_301 = table.remove(arg0_301.damageTextPool)

	if not var0_301 then
		var0_301 = Instantiate(arg0_301.damageTextTemplate)

		local var1_301 = tf(arg0_301.damageTextTemplate):GetSiblingIndex()

		setParent(var0_301, tf(arg0_301.damageTextTemplate).parent)
		tf(var0_301):SetSiblingIndex(var1_301 + 1)
	end

	table.insert(arg0_301.damageTextActive, var0_301)
	setActive(var0_301, true)

	return var0_301
end

function var0_0.ReturnDamageText(arg0_302, arg1_302)
	assert(arg1_302)

	if not arg1_302 then
		return
	end

	arg1_302 = go(arg1_302)

	table.removebyvalue(arg0_302.damageTextActive, arg1_302)
	table.insert(arg0_302.damageTextPool, arg1_302)
	setActive(arg1_302, false)
end

function var0_0.resetLevelGrid(arg0_303)
	arg0_303.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_304, arg1_304)
	setActive(arg0_304.curtain, arg1_304)
end

function var0_0.frozen(arg0_305)
	local var0_305 = arg0_305.frozenCount

	arg0_305.frozenCount = arg0_305.frozenCount + 1
	arg0_305.canvasGroup.blocksRaycasts = arg0_305.frozenCount == 0

	if var0_305 == 0 and arg0_305.frozenCount ~= 0 then
		arg0_305:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_306, arg1_306)
	if arg0_306.exited then
		return
	end

	local var0_306 = arg0_306.frozenCount
	local var1_306 = arg1_306 == -1 and arg0_306.frozenCount or arg1_306 or 1

	arg0_306.frozenCount = arg0_306.frozenCount - var1_306
	arg0_306.canvasGroup.blocksRaycasts = arg0_306.frozenCount == 0

	if var0_306 ~= 0 and arg0_306.frozenCount == 0 then
		arg0_306:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_307)
	return arg0_307.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_308)
	arg0_308.levelCamIndices = math.max(arg0_308.levelCamIndices - 1, 0)

	if arg0_308.levelCamIndices == 0 then
		arg0_308.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.disableLevelCamera(arg0_309)
	arg0_309.levelCamIndices = arg0_309.levelCamIndices + 1

	if arg0_309.levelCamIndices > 0 then
		arg0_309.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.RecordTween(arg0_310, arg1_310, arg2_310)
	arg0_310.tweens[arg1_310] = arg2_310
end

function var0_0.DeleteTween(arg0_311, arg1_311)
	local var0_311 = arg0_311.tweens[arg1_311]

	if var0_311 then
		LeanTween.cancel(var0_311)

		arg0_311.tweens[arg1_311] = nil
	end
end

function var0_0.openCommanderPanel(arg0_312, arg1_312, arg2_312, arg3_312)
	local var0_312 = arg2_312.id

	arg0_312.levelCMDFormationView:setCallback(function(arg0_313)
		if not arg3_312 then
			if arg0_313.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_312:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_313.skill)
			elseif arg0_313.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_312.contextData.commanderSelected = {
					chapterId = var0_312,
					fleetId = arg1_312.id
				}

				arg0_312:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_313.pos, arg1_312.id, arg2_312)
				arg0_312:closeCommanderPanel()
			else
				arg0_312:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_313,
					fleetId = arg1_312.id,
					chapterId = var0_312
				}, arg2_312)
			end
		elseif arg0_313.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_312:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_313.skill)
		elseif arg0_313.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_312.contextData.eliteCommanderSelected = {
				index = arg3_312,
				pos = arg0_313.pos,
				chapterId = var0_312
			}

			arg0_312:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_312, arg0_313.pos, arg2_312)
			arg0_312:closeCommanderPanel()
		else
			arg0_312:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_313,
				index = arg3_312,
				chapterId = var0_312
			}, arg2_312)
		end
	end)
	arg0_312.levelCMDFormationView:Load()
	arg0_312.levelCMDFormationView:ActionInvoke("update", arg1_312, arg0_312.commanderPrefabs)
	arg0_312.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_314)
	if arg0_314.levelCMDFormationView:isShowing() then
		arg0_314.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_314.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_315)
	arg0_315.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_316)
	arg0_316.levelCMDFormationView:Destroy()

	arg0_316.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_317, arg1_317)
	arg0_317.spTickets = arg1_317
end

function var0_0.HandleShowMsgBox(arg0_318, arg1_318)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_318)
end

function var0_0.updatePoisonAreaTip(arg0_319)
	local var0_319 = arg0_319.contextData.chapterVO
	local var1_319 = (function(arg0_320)
		local var0_320 = {}
		local var1_320 = pg.map_event_list[var0_319.id] or {}
		local var2_320

		if var0_319:isLoop() then
			var2_320 = var1_320.event_list_loop or {}
		else
			var2_320 = var1_320.event_list or {}
		end

		for iter0_320, iter1_320 in ipairs(var2_320) do
			local var3_320 = pg.map_event_template[iter1_320]

			if var3_320.c_type == arg0_320 then
				table.insert(var0_320, var3_320)
			end
		end

		return var0_320
	end)(ChapterConst.EvtType_Poison)

	if var1_319 then
		for iter0_319, iter1_319 in ipairs(var1_319) do
			local var2_319 = iter1_319.round_gametip

			if var2_319 ~= nil and var2_319 ~= "" and var0_319:getRoundNum() == var2_319[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_319[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_321)
	setActive(arg0_321._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_322)
	local var0_322 = getProxy(ChapterProxy)

	if var0_322 and not arg0_322.contextData.noRecord then
		local var1_322 = arg0_322.contextData.map

		if not var1_322 then
			return
		end

		if var1_322:NeedRecordMap() then
			var0_322:recordLastMap(ChapterProxy.LAST_MAP, var1_322.id)
		end

		if var1_322:isActivity() and not var1_322:isActExtra() then
			var0_322:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_322.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_323)
	local var0_323 = arg0_323.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_323.contextData.map:getConfig("on_activity")) or nil
	local var1_323 = var0_323 and not var0_323:isEnd() and var0_323:GetConfigClientSetting("PTID")
	local var2_323 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var2_323 and not var2_323:isEnd() and var2_323:getConfig("config_client").resId == var1_323 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_324)
		return not arg0_324:isEnd() and arg0_324:getConfig("config_client").pt_id == var1_323
	end) then
		return true
	end
end

function var0_0.OnStartChapterAuto(arg0_325, arg1_325)
	if arg0_325.levelInfoView:isShowing() then
		arg0_325:hideChapterPanel()
	end

	if arg0_325.levelInfoSPView and arg0_325.levelInfoSPView:isShowing() then
		arg0_325:HideLevelInfoSPPanel()
	end
end

function var0_0.OnEndChapterAuto(arg0_326, arg1_326)
	return
end

function var0_0.OnAddChapterAutoTimeDone(arg0_327)
	if arg0_327.levelInfoView:isShowing() then
		arg0_327.levelInfoView:RefreshChapterAutoPanel()
	end

	if arg0_327.levelInfoSPView and arg0_327.levelInfoSPView:isShowing() then
		arg0_327.levelInfoView:RefreshChapterAutoPanel()
	end
end

function var0_0.ShowChapterAutoDetailPanel(arg0_328, arg1_328)
	arg0_328.chapterAutoDetailPanel:Load()
	arg0_328.chapterAutoDetailPanel:ActionInvoke("Enter", arg1_328)
end

function var0_0.HideChapterAutoDetailPanel(arg0_329)
	if arg0_329.chapterAutoDetailPanel:isShowing() then
		arg0_329.chapterAutoDetailPanel:Hide()
	end
end

function var0_0.DestroyChapterAutoDetailPanel(arg0_330)
	if arg0_330.chapterAutoDetailPanel then
		arg0_330.chapterAutoDetailPanel:Destroy()

		arg0_330.chapterAutoDetailPanel = nil
	end
end

function var0_0.willExit(arg0_331)
	arg0_331:ClearMapTransitions()
	arg0_331.loader:Clear()

	if arg0_331.contextData.chapterVO then
		arg0_331:UnOverlayPanel(arg0_331.topPanel, arg0_331._tf)
	end

	if arg0_331.levelFleetView and arg0_331.levelFleetView.selectIds then
		arg0_331.contextData.selectedFleetIDs = {}

		for iter0_331, iter1_331 in pairs(arg0_331.levelFleetView.selectIds) do
			for iter2_331, iter3_331 in pairs(iter1_331) do
				arg0_331.contextData.selectedFleetIDs[#arg0_331.contextData.selectedFleetIDs + 1] = iter3_331
			end
		end
	end

	arg0_331:destroyChapterPanel()
	arg0_331:DestroyLevelInfoSPPanel()
	arg0_331:destroyFleetEdit()
	arg0_331:destroyCommanderPanel()
	arg0_331:DestroyLevelStageView()
	arg0_331:hideRepairWindow()
	arg0_331:hideStrategyInfo()
	arg0_331:hideRemasterPanel()
	arg0_331:hideSpResult()
	arg0_331:destroyGrid()
	arg0_331:destroyAmbushWarn()
	arg0_331:destroyAirStrike()
	arg0_331:destroyTorpedo()
	arg0_331:destroyStrikeAnim()
	arg0_331:destroyTracking()
	arg0_331:destroyUIAnims()
	arg0_331:DestroyChapterAutoDetailPanel()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_331, iter5_331 in pairs(arg0_331.mbDict) do
		iter5_331:Destroy()
	end

	arg0_331.mbDict = nil

	for iter6_331, iter7_331 in pairs(arg0_331.tweens) do
		LeanTween.cancel(iter7_331)
	end

	arg0_331.tweens = nil

	if arg0_331.cloudTimer then
		_.each(arg0_331.cloudTimer, function(arg0_332)
			LeanTween.cancel(arg0_332)
		end)

		arg0_331.cloudTimer = nil
	end

	if arg0_331.newChapterCDTimer then
		arg0_331.newChapterCDTimer:Stop()

		arg0_331.newChapterCDTimer = nil
	end

	for iter8_331, iter9_331 in ipairs(arg0_331.damageTextActive) do
		LeanTween.cancel(iter9_331)
	end

	LeanTween.cancel(go(arg0_331.avoidText))

	arg0_331.map.localScale = Vector3.one
	arg0_331.map.pivot = Vector2(0.5, 0.5)
	arg0_331.float.localScale = Vector3.one
	arg0_331.float.pivot = Vector2(0.5, 0.5)

	for iter10_331, iter11_331 in ipairs(arg0_331.mapTFs) do
		clearImageSprite(iter11_331)
	end

	_.each(arg0_331.cloudRTFs, function(arg0_333)
		clearImageSprite(arg0_333)
	end)
	Destroy(arg0_331.enemyTpl)
	arg0_331:RecordLastMapOnExit()
	arg0_331.levelRemasterView:Destroy()
end

return var0_0
