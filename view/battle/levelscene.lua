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

function var0_0.ResUISettings(arg0_3)
	return {
		showType = PlayerResUI.TYPE_ALL,
		groupName = LayerWeightConst.GROUP_LEVELUI
	}
end

function var0_0.getBGM(arg0_4)
	local function var0_4()
		return checkExist(arg0_4.contextData.chapterVO, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	local function var1_4()
		if not arg0_4.contextData.map then
			return
		end

		local var0_6 = arg0_4.contextData.map:getConfig("ani_controller")

		if var0_6 and #var0_6 > 0 then
			for iter0_6, iter1_6 in ipairs(var0_6) do
				local var1_6 = _.rest(iter1_6[2], 2)

				for iter2_6, iter3_6 in ipairs(var1_6) do
					if string.find(iter3_6, "^bgm_") and iter1_6[1] == var3_0 then
						local var2_6 = iter1_6[2][1]
						local var3_6 = getProxy(ChapterProxy):GetChapterItemById(var2_6)

						if var3_6 and not var3_6:isClear() then
							return string.sub(iter3_6, 5)
						end
					end
				end
			end
		end

		return checkExist(arg0_4.contextData.map, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	for iter0_4, iter1_4 in ipairs({
		var0_4(),
		var1_4()
	}) do
		if iter1_4 ~= "" then
			return iter1_4
		end
	end

	return var0_0.super.getBGM(arg0_4)
end

var0_0.optionsPath = {
	"top/top_chapter/option"
}

function var0_0.preload(arg0_7, arg1_7)
	local var0_7 = getProxy(ChapterProxy)

	if arg0_7.contextData.mapIdx and arg0_7.contextData.chapterId then
		local var1_7 = var0_7:getChapterById(arg0_7.contextData.chapterId)

		if var1_7:getConfig("map") == arg0_7.contextData.mapIdx then
			arg0_7.contextData.chapterVO = var1_7

			if var1_7.active then
				assert(not arg0_7.contextData.openChapterId or arg0_7.contextData.openChapterId == arg0_7.contextData.chapterId)

				arg0_7.contextData.openChapterId = nil
			end
		end
	end

	local var2_7, var3_7 = arg0_7:GetInitializeMap()

	if arg0_7.contextData.entranceStatus == nil then
		arg0_7.contextData.entranceStatus = not var3_7
	end

	if not arg0_7.contextData.entranceStatus then
		arg0_7:PreloadLevelMainUI(var2_7, arg1_7)
	else
		arg1_7()
	end
end

function var0_0.GetInitializeMap(arg0_8)
	local var0_8 = (function()
		local var0_9 = arg0_8.contextData.chapterVO

		if var0_9 and var0_9.active then
			return var0_9:getConfig("map")
		end

		local var1_9 = arg0_8.contextData.mapIdx

		if var1_9 then
			return var1_9
		end

		local var2_9

		if arg0_8.contextData.targetChapter and arg0_8.contextData.targetMap then
			arg0_8.contextData.openChapterId = arg0_8.contextData.targetChapter
			var2_9 = arg0_8.contextData.targetMap.id
			arg0_8.contextData.targetChapter = nil
			arg0_8.contextData.targetMap = nil
		elseif arg0_8.contextData.eliteDefault then
			local var3_9 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			var2_9 = var3_9 and var3_9.id or nil
			arg0_8.contextData.eliteDefault = nil
		end

		return var2_9
	end)()
	local var1_8 = var0_8 and getProxy(ChapterProxy):getMapById(var0_8)

	if var1_8 then
		local var2_8, var3_8 = var1_8:isUnlock()

		if not var2_8 then
			pg.TipsMgr.GetInstance():ShowTips(var3_8)

			var0_8 = getProxy(ChapterProxy):getLastUnlockMap().id
			arg0_8.contextData.mapIdx = var0_8
		end
	else
		var0_8 = nil
	end

	return var0_8 or getProxy(ChapterProxy):GetLastNormalMap(), tobool(var0_8)
end

function var0_0.init(arg0_10)
	arg0_10:initData()
	arg0_10:initUI()
	arg0_10:initEvents()
	arg0_10:updateClouds()
end

function var0_0.initData(arg0_11)
	arg0_11.tweens = {}
	arg0_11.mapWidth = 1920
	arg0_11.mapHeight = 1440
	arg0_11.levelCamIndices = 1
	arg0_11.frozenCount = 0
	arg0_11.currentBG = nil
	arg0_11.mbDict = {}
	arg0_11.mapGroup = {}

	if not arg0_11.contextData.huntingRangeVisibility then
		arg0_11.contextData.huntingRangeVisibility = 2
	end
end

function var0_0.initUI(arg0_12)
	arg0_12.topPanel = arg0_12:findTF("top")
	arg0_12.canvasGroup = arg0_12.topPanel:GetComponent("CanvasGroup")
	arg0_12.canvasGroup.blocksRaycasts = not arg0_12.canvasGroup.blocksRaycasts
	arg0_12.canvasGroup.blocksRaycasts = not arg0_12.canvasGroup.blocksRaycasts
	arg0_12.entranceLayer = arg0_12:findTF("entrance")
	arg0_12.ptBonus = EventPtBonus.New(arg0_12.entranceLayer:Find("btns/btn_task/bonusPt"))
	arg0_12.entranceBg = arg0_12:findTF("entrance_bg")
	arg0_12.topChapter = arg0_12:findTF("top_chapter", arg0_12.topPanel)

	setActive(arg0_12.topChapter:Find("title_chapter"), false)
	setActive(arg0_12.topChapter:Find("type_chapter"), false)
	setActive(arg0_12.topChapter:Find("type_escort"), false)
	setActive(arg0_12.topChapter:Find("type_skirmish"), false)

	arg0_12.chapterName = arg0_12:findTF("title_chapter/name", arg0_12.topChapter)
	arg0_12.chapterNoTitle = arg0_12:findTF("title_chapter/chapter", arg0_12.topChapter)
	arg0_12.resChapter = arg0_12:findTF("resources", arg0_12.topChapter)

	setActive(arg0_12.topChapter, true)

	arg0_12._voteBookBtn = arg0_12.topChapter:Find("vote_book")
	arg0_12.leftChapter = arg0_12:findTF("main/left_chapter")

	setActive(arg0_12.leftChapter, true)

	arg0_12.leftCanvasGroup = arg0_12.leftChapter:GetComponent(typeof(CanvasGroup))
	arg0_12.btnPrev = arg0_12:findTF("btn_prev", arg0_12.leftChapter)
	arg0_12.btnPrevCol = arg0_12:findTF("btn_prev/prev_image", arg0_12.leftChapter)
	arg0_12.eliteBtn = arg0_12:findTF("buttons/btn_elite", arg0_12.leftChapter)
	arg0_12.normalBtn = arg0_12:findTF("buttons/btn_normal", arg0_12.leftChapter)
	arg0_12.actNormalBtn = arg0_12:findTF("buttons/btn_act_normal", arg0_12.leftChapter)
	arg0_12.actEliteBtn = arg0_12:findTF("buttons/btn_act_elite", arg0_12.leftChapter)
	arg0_12.actExtraBtn = arg0_12:findTF("buttons/btn_act_extra", arg0_12.leftChapter)
	arg0_12.actExtraBtnAnim = arg0_12:findTF("usm", arg0_12.actExtraBtn)
	arg0_12.remasterBtn = arg0_12:findTF("buttons/btn_remaster", arg0_12.leftChapter)
	arg0_12.escortBar = arg0_12:findTF("escort_bar", arg0_12.leftChapter)
	arg0_12.eliteQuota = arg0_12:findTF("elite_quota", arg0_12.leftChapter)
	arg0_12.skirmishBar = arg0_12:findTF("left_times", arg0_12.leftChapter)
	arg0_12.mainLayer = arg0_12:findTF("main")

	setActive(arg0_12.mainLayer:Find("title_chapter_lines"), false)

	arg0_12.rightChapter = arg0_12:findTF("main/right_chapter")
	arg0_12.rightCanvasGroup = arg0_12.rightChapter:GetComponent(typeof(CanvasGroup))
	arg0_12.eventContainer = arg0_12:findTF("event_btns/event_container", arg0_12.rightChapter)
	arg0_12.btnSpecial = arg0_12:findTF("btn_task", arg0_12.eventContainer)
	arg0_12.challengeBtn = arg0_12:findTF("btn_challenge", arg0_12.eventContainer)
	arg0_12.dailyBtn = arg0_12:findTF("btn_daily", arg0_12.eventContainer)
	arg0_12.militaryExerciseBtn = arg0_12:findTF("btn_pvp", arg0_12.eventContainer)
	arg0_12.activityBtn = arg0_12:findTF("event_btns/activity_btn", arg0_12.rightChapter)
	arg0_12.ptTotal = arg0_12:findTF("event_btns/pt_text", arg0_12.rightChapter)
	arg0_12.ticketTxt = arg0_12:findTF("event_btns/tickets/Text", arg0_12.rightChapter)
	arg0_12.remasterAwardBtn = arg0_12:findTF("btn_remaster_award", arg0_12.rightChapter)
	arg0_12.btnNext = arg0_12:findTF("btn_next", arg0_12.rightChapter)
	arg0_12.btnNextCol = arg0_12:findTF("btn_next/next_image", arg0_12.rightChapter)
	arg0_12.countDown = arg0_12:findTF("event_btns/count_down", arg0_12.rightChapter)

	setActive(arg0_12:findTF("event_btns/BottomList", arg0_12.rightChapter), true)

	arg0_12.actExchangeShopBtn = arg0_12:findTF("event_btns/BottomList/btn_exchange", arg0_12.rightChapter)
	arg0_12.actAtelierBuffBtn = arg0_12:findTF("event_btns/BottomList/btn_control_center", arg0_12.rightChapter)
	arg0_12.actExtraRank = arg0_12:findTF("event_btns/BottomList/act_extra_rank", arg0_12.rightChapter)

	setActive(arg0_12.rightChapter, true)

	arg0_12.damageTextTemplate = go(arg0_12:findTF("damage", arg0_12.topPanel))

	setActive(arg0_12.damageTextTemplate, false)

	arg0_12.damageTextPool = {
		arg0_12.damageTextTemplate
	}
	arg0_12.damageTextActive = {}
	arg0_12.mapHelpBtn = arg0_12:findTF("help_button", arg0_12.topPanel)
	arg0_12.avoidText = arg0_12:findTF("text_avoid", arg0_12.topPanel)
	arg0_12.commanderTinkle = arg0_12:findTF("neko_tinkle", arg0_12.topPanel)

	setActive(arg0_12.commanderTinkle, false)

	arg0_12.spResult = arg0_12:findTF("sp_result", arg0_12.topPanel)

	setActive(arg0_12.spResult, false)

	arg0_12.helpPage = arg0_12:findTF("help_page", arg0_12.topPanel)
	arg0_12.helpImage = arg0_12:findTF("icon", arg0_12.helpPage)

	setActive(arg0_12.helpPage, false)

	arg0_12.curtain = arg0_12:findTF("curtain", arg0_12.topPanel)

	setActive(arg0_12.curtain, false)

	arg0_12.map = arg0_12:findTF("maps")
	arg0_12.mapTFs = {
		arg0_12:findTF("maps/map1"),
		arg0_12:findTF("maps/map2")
	}

	for iter0_12, iter1_12 in ipairs(arg0_12.mapTFs) do
		iter1_12:GetComponent(typeof(Image)).enabled = false
	end

	local var0_12 = arg0_12.map:GetComponent(typeof(AspectRatioFitter))

	var0_12.aspectRatio, var0_12.aspectRatio = var0_12.aspectRatio, 1
	arg0_12.UIFXList = arg0_12:findTF("maps/UI_FX_list")

	local var1_12 = arg0_12.UIFXList:GetComponentsInChildren(typeof(Renderer)):ToTable()

	for iter2_12, iter3_12 in ipairs(var1_12) do
		iter3_12.sortingOrder = -1
	end

	local var2_12 = pg.UIMgr.GetInstance()

	arg0_12.levelCam = var2_12.levelCamera:GetComponent(typeof(Camera))
	arg0_12.uiMain = var2_12.LevelMain

	setActive(arg0_12.uiMain, false)

	arg0_12.uiCam = var2_12.uiCamera:GetComponent(typeof(Camera))
	arg0_12.levelGrid = arg0_12.uiMain:Find("LevelGrid")

	setActive(arg0_12.levelGrid, true)

	arg0_12.dragLayer = arg0_12.levelGrid:Find("DragLayer")
	arg0_12.float = arg0_12:findTF("float")
	arg0_12.clouds = arg0_12:findTF("clouds", arg0_12.float)

	setActive(arg0_12.clouds, true)
	setActive(arg0_12.float:Find("levels"), false)

	arg0_12.resources = arg0_12:findTF("resources"):GetComponent("ItemList")
	arg0_12.arrowTarget = arg0_12.resources.prefabItem[0]
	arg0_12.destinationMarkTpl = arg0_12.resources.prefabItem[1]
	arg0_12.championTpl = arg0_12.resources.prefabItem[3]
	arg0_12.deadTpl = arg0_12.resources.prefabItem[4]
	arg0_12.enemyTpl = Instantiate(arg0_12.resources.prefabItem[5])
	arg0_12.oniTpl = arg0_12.resources.prefabItem[6]
	arg0_12.shipTpl = arg0_12.resources.prefabItem[8]
	arg0_12.subTpl = arg0_12.resources.prefabItem[9]
	arg0_12.transportTpl = arg0_12.resources.prefabItem[11]

	setText(arg0_12:findTF("fighting/Text", arg0_12.enemyTpl), i18n("ui_word_levelui2_inevent"))
	arg0_12:HideBtns()
	setAnchoredPosition(arg0_12.topChapter, {
		y = 0
	})
	setAnchoredPosition(arg0_12.leftChapter, {
		x = 0
	})
	setAnchoredPosition(arg0_12.rightChapter, {
		x = 0
	})

	arg0_12.bubbleMsgBoxes = {}
	arg0_12.loader = AutoLoader.New()
	arg0_12.levelFleetView = LevelFleetView.New(arg0_12.topPanel, arg0_12.event, arg0_12.contextData)
	arg0_12.levelInfoView = LevelInfoView.New(arg0_12.topPanel, arg0_12.event, arg0_12.contextData)

	arg0_12:buildCommanderPanel()

	arg0_12.levelRemasterView = LevelRemasterView.New(arg0_12.topPanel, arg0_12.event, arg0_12.contextData)

	arg0_12:SwitchMapBuilder(MapBuilder.TYPENORMAL)
end

function var0_0.initEvents(arg0_13)
	arg0_13:bind(LevelUIConst.OPEN_COMMANDER_PANEL, function(arg0_14, arg1_14, arg2_14, arg3_14)
		arg0_13:openCommanderPanel(arg1_14, arg2_14, arg3_14)
	end)
	arg0_13:bind(LevelUIConst.HANDLE_SHOW_MSG_BOX, function(arg0_15, arg1_15)
		arg0_13:HandleShowMsgBox(arg1_15)
	end)
	arg0_13:bind(LevelUIConst.DO_AMBUSH_WARNING, function(arg0_16, arg1_16)
		arg0_13:doAmbushWarning(arg1_16)
	end)
	arg0_13:bind(LevelUIConst.DISPLAY_AMBUSH_INFO, function(arg0_17, arg1_17)
		arg0_13:displayAmbushInfo(arg1_17)
	end)
	arg0_13:bind(LevelUIConst.DISPLAY_STRATEGY_INFO, function(arg0_18, arg1_18)
		arg0_13:displayStrategyInfo(arg1_18)
	end)
	arg0_13:bind(LevelUIConst.FROZEN, function(arg0_19)
		arg0_13:frozen()
	end)
	arg0_13:bind(LevelUIConst.UN_FROZEN, function(arg0_20)
		arg0_13:unfrozen()
	end)
	arg0_13:bind(LevelUIConst.DO_TRACKING, function(arg0_21, arg1_21)
		arg0_13:doTracking(arg1_21)
	end)
	arg0_13:bind(LevelUIConst.SWITCH_TO_MAP, function()
		if arg0_13:isfrozen() then
			return
		end

		arg0_13:switchToMap()
	end)
	arg0_13:bind(LevelUIConst.DISPLAY_REPAIR_WINDOW, function(arg0_23, arg1_23)
		arg0_13:displayRepairWindow(arg1_23)
	end)
	arg0_13:bind(LevelUIConst.DO_PLAY_ANIM, function(arg0_24, arg1_24)
		arg0_13:doPlayAnim(arg1_24.name, arg1_24.callback, arg1_24.onStart)
	end)
	arg0_13:bind(LevelUIConst.HIDE_FLEET_SELECT, function()
		arg0_13:hideFleetSelect()
	end)
	arg0_13:bind(LevelUIConst.HIDE_FLEET_EDIT, function(arg0_26)
		arg0_13:hideFleetEdit()
	end)
	arg0_13:bind(LevelUIConst.ADD_MSG_QUEUE, function(arg0_27, arg1_27)
		arg0_13:addbubbleMsgBox(arg1_27)
	end)
	arg0_13:bind(LevelUIConst.SET_MAP, function(arg0_28, arg1_28)
		arg0_13:setMap(arg1_28)
	end)
end

function var0_0.addbubbleMsgBox(arg0_29, arg1_29)
	table.insert(arg0_29.bubbleMsgBoxes, arg1_29)

	if #arg0_29.bubbleMsgBoxes > 1 then
		return
	end

	local var0_29

	local function var1_29()
		local var0_30 = arg0_29.bubbleMsgBoxes[1]

		if var0_30 then
			var0_30(function()
				table.remove(arg0_29.bubbleMsgBoxes, 1)
				var1_29()
			end)
		end
	end

	var1_29()
end

function var0_0.CleanBubbleMsgbox(arg0_32)
	table.clean(arg0_32.bubbleMsgBoxes)
end

function var0_0.updatePtActivity(arg0_33, arg1_33)
	arg0_33.ptActivity = arg1_33

	arg0_33:updateActivityRes()
end

function var0_0.updateActivityRes(arg0_34)
	local var0_34 = findTF(arg0_34.ptTotal, "Text")
	local var1_34 = findTF(arg0_34.ptTotal, "icon/Image")

	if var0_34 and var1_34 and arg0_34.ptActivity then
		setText(var0_34, "x" .. arg0_34.ptActivity.data1)
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = tonumber(arg0_34.ptActivity:getConfig("config_id"))
		}):getIcon(), "", var1_34, true)
	end
end

function var0_0.setCommanderPrefabs(arg0_35, arg1_35)
	arg0_35.commanderPrefabs = arg1_35
end

function var0_0.didEnter(arg0_36)
	arg0_36.openedCommanerSystem = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "CommanderCatMediator")

	onButton(arg0_36, arg0_36:findTF("back_button", arg0_36.topChapter), function()
		if arg0_36:isfrozen() then
			return
		end

		local var0_37 = arg0_36.contextData.map

		if var0_37 and (var0_37:isActivity() or var0_37:isEscort()) then
			arg0_36:emit(LevelMediator2.ON_SWITCH_NORMAL_MAP)

			return
		elseif var0_37 and var0_37:isSkirmish() then
			arg0_36:emit(var0_0.ON_BACK)
		elseif not arg0_36.contextData.entranceStatus then
			arg0_36:ShowEntranceUI(true)
		else
			arg0_36:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_36, arg0_36.btnSpecial, function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.dailyBtn, function()
		if arg0_36:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_36:updatDailyBtnTip()
		arg0_36:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.challengeBtn, function()
		if arg0_36:isfrozen() then
			return
		end

		local var0_40, var1_40 = arg0_36:checkChallengeOpen()

		if var0_40 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_40)
		else
			arg0_36:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.militaryExerciseBtn, function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.normalBtn, function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:setMap(arg0_36.contextData.map:getBindMapId())
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.eliteBtn, function()
		if arg0_36:isfrozen() then
			return
		end

		if arg0_36.contextData.map:getBindMapId() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

			local var0_43 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			if var0_43 then
				arg0_36:setMap(var0_43.configId)
				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_warp_to_latest_map"))
			end
		elseif arg0_36.contextData.map:isEliteEnabled() then
			arg0_36:setMap(arg0_36.contextData.map:getBindMapId())
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unsatisfied"))
		end
	end, SFX_UI_WEIGHANCHOR_HARD)
	onButton(arg0_36, arg0_36.remasterBtn, function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_36:updateRemasterBtnTip()
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.entranceLayer:Find("enters/enter_main"), function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:ShowSelectedMap(arg0_36:GetInitializeMap())
	end, SFX_PANEL)
	setText(arg0_36.entranceLayer:Find("enters/enter_main/Text"), getProxy(ChapterProxy):getLastUnlockMap():getLastUnlockChapterName())
	onButton(arg0_36, arg0_36.entranceLayer:Find("enters/enter_world/enter"), function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:emit(LevelMediator2.ENTER_WORLD)
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.entranceLayer:Find("enters/enter_ready/activity"), function()
		if arg0_36:isfrozen() then
			return
		end

		local var0_47 = getProxy(ActivityProxy):getEnterReadyActivity()

		switch(var0_47:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0_36:emit(LevelMediator2.ON_ACTIVITY_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
				arg0_36:emit(LevelMediator2.ON_OPEN_ACT_BOSS_BATTLE)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
				arg0_36:emit(LevelMediator2.ON_BOSSRUSH_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
				arg0_36:emit(LevelMediator2.ON_BOSSSINGLE_MAP, {
					mode = OtherworldMapScene.MODE_BATTLE
				})
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
				arg0_36:emit(LevelMediator2.ON_CLUE_MAP)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.entranceLayer:Find("btns/btn_remaster"), function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_36:updateRemasterBtnTip()
	end, SFX_PANEL)
	setActive(arg0_36.entranceLayer:Find("btns/btn_remaster"), OPEN_REMASTER)
	onButton(arg0_36, arg0_36.entranceLayer:Find("btns/btn_challenge"), function()
		if arg0_36:isfrozen() then
			return
		end

		local var0_54, var1_54 = arg0_36:checkChallengeOpen()

		if var0_54 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_54)
		else
			arg0_36:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.entranceLayer:Find("btns/btn_pvp"), function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.entranceLayer:Find("btns/btn_daily"), function()
		if arg0_36:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_36:updatDailyBtnTip()
		arg0_36:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.entranceLayer:Find("btns/btn_task"), function()
		if arg0_36:isfrozen() then
			return
		end

		arg0_36:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	setActive(arg0_36.entranceLayer:Find("enters/enter_world/enter"), not WORLD_ENTER_LOCK)
	setActive(arg0_36.entranceLayer:Find("enters/enter_world/nothing"), WORLD_ENTER_LOCK)

	local var0_36 = getProxy(ActivityProxy):getEnterReadyActivity()

	setActive(arg0_36.entranceLayer:Find("enters/enter_ready/nothing"), not tobool(var0_36))
	setActive(arg0_36.entranceLayer:Find("enters/enter_ready/activity"), tobool(var0_36))

	if tobool(var0_36) then
		local var1_36 = var0_36:getConfig("config_client").entrance_bg

		if var1_36 then
			GetImageSpriteFromAtlasAsync(var1_36, "", arg0_36.entranceLayer:Find("enters/enter_ready/activity"), true)
		end
	end

	local var2_36 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "EventMediator")

	setActive(arg0_36.btnSpecial:Find("lock"), not var2_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_task/lock"), not var2_36)

	local var3_36 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "DailyLevelMediator")

	setActive(arg0_36.dailyBtn:Find("lock"), not var3_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_daily/lock"), not var3_36)

	local var4_36 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "MilitaryExerciseMediator")

	setActive(arg0_36.militaryExerciseBtn:Find("lock"), not var4_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_pvp/lock"), not var4_36)

	local var5_36 = LimitChallengeConst.IsOpen()

	setActive(arg0_36.challengeBtn:Find("lock"), not var5_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_challenge/lock"), not var5_36)

	local var6_36 = LimitChallengeConst.IsInAct()

	setActive(arg0_36.challengeBtn, var6_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_challenge"), var6_36)

	local var7_36 = LimitChallengeConst.IsShowRedPoint()

	setActive(arg0_36.entranceLayer:Find("btns/btn_challenge/tip"), var7_36)
	arg0_36:initMapBtn(arg0_36.btnPrev, -1)
	arg0_36:initMapBtn(arg0_36.btnNext, 1)
	arg0_36:registerActBtn()

	if arg0_36.contextData.editEliteChapter then
		local var8_36 = getProxy(ChapterProxy):getChapterById(arg0_36.contextData.editEliteChapter)

		arg0_36:displayFleetEdit(var8_36)

		arg0_36.contextData.editEliteChapter = nil
	elseif arg0_36.contextData.selectedChapterVO then
		arg0_36:displayFleetSelect(arg0_36.contextData.selectedChapterVO)

		arg0_36.contextData.selectedChapterVO = nil
	end

	local var9_36 = arg0_36.contextData.chapterVO

	if not var9_36 or not var9_36.active then
		arg0_36:tryPlaySubGuide()
	end

	arg0_36:updateRemasterBtnTip()
	arg0_36:updatDailyBtnTip()

	if arg0_36.contextData.open_remaster then
		arg0_36:displayRemasterPanel(arg0_36.contextData.isSP)

		arg0_36.contextData.open_remaster = nil
	end

	arg0_36:ShowEntranceUI(arg0_36.contextData.entranceStatus)

	if not arg0_36.contextData.entranceStatus then
		arg0_36:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg0_36:GetInitializeMap())
	end

	arg0_36:emit(LevelMediator2.ON_DIDENTER)
end

function var0_0.checkChallengeOpen(arg0_58)
	local var0_58 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_58, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_59)
	if arg0_59.contextData.map and arg0_59.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_59)
end

function var0_0.onBackPressed(arg0_60)
	if arg0_60:isfrozen() then
		return
	end

	if arg0_60.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_60.levelInfoView:isShowing() then
		arg0_60:hideChapterPanel()

		return
	end

	if arg0_60.levelInfoSPView and arg0_60.levelInfoSPView:isShowing() then
		arg0_60:HideLevelInfoSPPanel()

		return
	end

	if arg0_60.levelFleetView:isShowing() then
		arg0_60:hideFleetEdit()

		return
	end

	if arg0_60.levelStrategyView then
		arg0_60:hideStrategyInfo()

		return
	end

	if arg0_60.levelRepairView then
		arg0_60:hideRepairWindow()

		return
	end

	if arg0_60.levelRemasterView:isShowing() then
		arg0_60:hideRemasterPanel()

		return
	end

	if isActive(arg0_60.helpPage) then
		setActive(arg0_60.helpPage, false)

		return
	end

	local var0_60 = arg0_60.contextData.chapterVO
	local var1_60 = getProxy(ChapterProxy):getActiveChapter()

	if var0_60 and var1_60 then
		arg0_60:switchToMap()

		return
	end

	triggerButton(arg0_60:findTF("back_button", arg0_60.topChapter))
end

function var0_0.ShowEntranceUI(arg0_61, arg1_61)
	setActive(arg0_61.entranceLayer, arg1_61)
	setActive(arg0_61.entranceBg, arg1_61)
	setActive(arg0_61.map, not arg1_61)
	setActive(arg0_61.float, not arg1_61)
	setActive(arg0_61.mainLayer, not arg1_61)
	setActive(arg0_61.topChapter:Find("type_entrance"), arg1_61)

	arg0_61.contextData.entranceStatus = tobool(arg1_61)

	if arg1_61 then
		setActive(arg0_61.topChapter:Find("title_chapter"), false)
		setActive(arg0_61.topChapter:Find("type_chapter"), false)
		setActive(arg0_61.topChapter:Find("type_escort"), false)
		setActive(arg0_61.topChapter:Find("type_skirmish"), false)

		if arg0_61.newChapterCDTimer then
			arg0_61.newChapterCDTimer:Stop()

			arg0_61.newChapterCDTimer = nil
		end

		arg0_61:RecordLastMapOnExit()

		arg0_61.contextData.mapIdx = nil
		arg0_61.contextData.map = nil
	end

	arg0_61:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_62, arg1_62, arg2_62)
	if arg0_62.preloadLevelDone then
		existCall(arg2_62)

		return
	end

	local var0_62

	local function var1_62()
		if not arg0_62.exited then
			arg0_62.preloadLevelDone = true

			existCall(arg2_62)
		end
	end

	local var2_62 = getProxy(ChapterProxy):getMapById(arg1_62)
	local var3_62 = arg0_62:GetMapBG(var2_62)

	table.ParallelIpairsAsync(var3_62, function(arg0_64, arg1_64, arg2_64)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_64.BG, "", arg2_64)
	end, var1_62)
end

function var0_0.setShips(arg0_65, arg1_65)
	arg0_65.shipVOs = arg1_65
end

function var0_0.updateRes(arg0_66, arg1_66)
	if arg0_66.levelStageView then
		arg0_66.levelStageView:ActionInvoke("SetPlayer", arg1_66)
	end

	arg0_66.player = arg1_66
end

function var0_0.setEliteQuota(arg0_67, arg1_67, arg2_67)
	local var0_67 = arg2_67 - arg1_67
	local var1_67 = arg0_67:findTF("bg/Text", arg0_67.eliteQuota):GetComponent(typeof(Text))

	if arg1_67 == arg2_67 then
		var1_67.color = Color.red
	else
		var1_67.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_67.text = var0_67 .. "/" .. arg2_67
end

function var0_0.updateEvent(arg0_68, arg1_68)
	local var0_68 = arg1_68:hasFinishState()

	setActive(arg0_68.btnSpecial:Find("tip"), var0_68)
	setActive(arg0_68.entranceLayer:Find("btns/btn_task/tip"), var0_68)
end

function var0_0.updateFleet(arg0_69, arg1_69)
	arg0_69.fleets = arg1_69
end

function var0_0.updateChapterVO(arg0_70, arg1_70, arg2_70)
	if arg0_70.contextData.chapterVO and arg0_70.contextData.chapterVO.id == arg1_70.id and arg1_70.active then
		arg0_70:setChapter(arg1_70)
	end

	if arg0_70.contextData.chapterVO and arg0_70.contextData.chapterVO.id == arg1_70.id and arg1_70.active and arg0_70.levelStageView and arg0_70.grid then
		local var0_70 = false
		local var1_70 = false
		local var2_70 = false

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyFleet) > 0 then
			arg0_70.levelStageView:updateStageFleet()
			arg0_70.levelStageView:updateAmbushRate(arg1_70.fleet.line, true)

			var2_70 = true

			if arg0_70.grid then
				arg0_70.grid:RefreshFleetCells()
				arg0_70.grid:UpdateFloor()

				var0_70 = true
			end
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyChampion) > 0 then
			var2_70 = true

			if arg0_70.grid then
				arg0_70.grid:UpdateFleets()
				arg0_70.grid:clearChampions()
				arg0_70.grid:initChampions()

				var1_70 = true
			end
		elseif bit.band(arg2_70, ChapterConst.DirtyChampionPosition) > 0 then
			var2_70 = true

			if arg0_70.grid then
				arg0_70.grid:UpdateFleets()
				arg0_70.grid:updateChampions()

				var1_70 = true
			end
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyAchieve) > 0 then
			arg0_70.levelStageView:updateStageAchieve()
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyAttachment) > 0 then
			arg0_70.levelStageView:updateAmbushRate(arg1_70.fleet.line, true)

			if arg0_70.grid then
				if not (arg2_70 < 0) and not (bit.band(arg2_70, ChapterConst.DirtyFleet) > 0) then
					arg0_70.grid:updateFleet(arg1_70.fleets[arg1_70.findex].id)
				end

				arg0_70.grid:updateAttachments()

				if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyAutoAction) > 0 then
					arg0_70.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_70 = true
				end
			end
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyStrategy) > 0 then
			arg0_70.levelStageView:updateStageStrategy()

			var2_70 = true

			arg0_70.levelStageView:updateStageBarrier()
			arg0_70.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_70 then
			arg0_70.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_70 then
			arg0_70.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyCellFlag) > 0 then
			arg0_70.grid:UpdateFloor()
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyBase) > 0 then
			arg0_70.levelStageView:UpdateDefenseStatus()
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyFloatItems) > 0 then
			arg0_70.grid:UpdateItemCells()
		end

		if var2_70 then
			arg0_70.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_71)
	arg0_71.cloudRTFs = {}
	arg0_71.cloudRects = {}
	arg0_71.cloudTimer = {}

	for iter0_71 = 1, 6 do
		local var0_71 = arg0_71:findTF("cloud_" .. iter0_71, arg0_71.clouds)
		local var1_71 = rtf(var0_71)

		table.insert(arg0_71.cloudRTFs, var1_71)
		table.insert(arg0_71.cloudRects, var1_71.rect.width)
	end

	arg0_71:initCloudsPos()

	for iter1_71, iter2_71 in ipairs(arg0_71.cloudRTFs) do
		local var2_71 = arg0_71.cloudRects[iter1_71]
		local var3_71 = arg0_71.initPositions[iter1_71] or Vector2(0, 0)
		local var4_71 = 30 - var3_71.y / 20
		local var5_71 = (arg0_71.mapWidth + var2_71) / var4_71
		local var6_71

		var6_71 = LeanTween.moveX(iter2_71, arg0_71.mapWidth, var5_71):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_71 = arg0_71.cloudRects[iter1_71]
			iter2_71.anchoredPosition = Vector2(-var2_71, var3_71.y)

			var6_71:setFrom(-var2_71):setTime((arg0_71.mapWidth + var2_71) / var4_71)
		end))
		var6_71.passed = math.random() * var5_71
		arg0_71.cloudTimer[iter1_71] = var6_71.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_73)
	arg0_73:PlayBGM()
	arg0_73:SwitchMapBG(arg0_73.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_74, arg1_74, arg2_74)
	if not arg1_74 then
		return
	end

	local var0_74 = arg0_74.contextData.map:getConfig("ani_controller")

	local function var1_74(arg0_75)
		arg0_75 = tf(arg0_75)

		local var0_75 = Vector3.one

		if arg0_75.rect.width > 0 and arg0_75.rect.height > 0 then
			var0_75.x = arg0_75.parent.rect.width / arg0_75.rect.width
			var0_75.y = arg0_75.parent.rect.height / arg0_75.rect.height
		end

		arg0_75.localScale = var0_75

		if var0_74 and #var0_74 > 0 then
			(function()
				for iter0_76, iter1_76 in ipairs(var0_74) do
					if iter1_76[1] == var2_0 then
						local var0_76 = iter1_76[2][1]
						local var1_76 = _.rest(iter1_76[2], 2)

						for iter2_76, iter3_76 in ipairs(var1_76) do
							local var2_76 = arg0_75:Find(iter3_76)

							if not IsNil(var2_76) then
								local var3_76 = getProxy(ChapterProxy):GetChapterItemById(var0_76)

								if var3_76 and not var3_76:isClear() then
									setActive(var2_76, false)
								end
							end
						end
					elseif iter1_76[1] == var3_0 then
						local var4_76 = iter1_76[2][1]
						local var5_76 = _.rest(iter1_76[2], 2)

						for iter4_76, iter5_76 in ipairs(var5_76) do
							local var6_76 = arg0_75:Find(iter5_76)

							if not IsNil(var6_76) then
								local var7_76 = getProxy(ChapterProxy):GetChapterItemById(var4_76)

								if var7_76 and not var7_76:isClear() then
									setActive(var6_76, true)

									return
								end
							end
						end
					elseif iter1_76[1] == var4_0 then
						local var8_76 = iter1_76[2][1]
						local var9_76 = _.rest(iter1_76[2], 2)

						for iter6_76, iter7_76 in ipairs(var9_76) do
							local var10_76 = arg0_75:Find(iter7_76)

							if not IsNil(var10_76) then
								local var11_76 = getProxy(ChapterProxy):GetChapterItemById(var8_76)

								if var11_76 and not var11_76:isClear() then
									setActive(var10_76, true)
								end
							end
						end
					end
				end
			end)()
		end
	end

	local var2_74 = arg0_74.loader:GetPrefab("ui/" .. arg1_74, arg1_74, function(arg0_77)
		arg0_77:SetActive(true)

		local var0_77 = arg0_74.mapTFs[arg2_74]

		setParent(arg0_77, var0_77)
		pg.ViewUtils.SetSortingOrder(arg0_77, ChapterConst.LayerWeightMap + arg2_74 * 2 - 1)
		var1_74(arg0_77)
	end)

	table.insert(arg0_74.mapGroup, var2_74)
end

function var0_0.HideBtns(arg0_78)
	setActive(arg0_78.btnPrev, false)
	setActive(arg0_78.eliteQuota, false)
	setActive(arg0_78.escortBar, false)
	setActive(arg0_78.skirmishBar, false)
	setActive(arg0_78.normalBtn, false)
	setActive(arg0_78.actNormalBtn, false)
	setActive(arg0_78.eliteBtn, false)
	setActive(arg0_78.actEliteBtn, false)
	setActive(arg0_78.actExtraBtn, false)
	setActive(arg0_78.remasterBtn, false)
	setActive(arg0_78.btnNext, false)
	setActive(arg0_78.remasterAwardBtn, false)
	setActive(arg0_78.eventContainer, false)
	setActive(arg0_78.activityBtn, false)
	setActive(arg0_78.ptTotal, false)
	setActive(arg0_78.ticketTxt.parent, false)
	setActive(arg0_78.countDown, false)
	setActive(arg0_78.actAtelierBuffBtn, false)
	setActive(arg0_78.actExtraRank, false)
	setActive(arg0_78.actExchangeShopBtn, false)
	setActive(arg0_78.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_79)
	local var0_79 = arg0_79.contextData.map:getConfig("type")

	setActive(arg0_79.normalBtn, var0_79 == Map.ELITE)
	setActive(arg0_79.eliteQuota, var0_79 == Map.ELITE)
	setActive(arg0_79.eliteBtn, var0_79 == Map.SCENARIO)

	local var1_79 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_79.eliteBtn:Find("pic_activity"), var1_79 and not var1_79:isEnd())
end

function var0_0.updateActivityBtns(arg0_80)
	local var0_80 = arg0_80.contextData.map
	local var1_80, var2_80 = var0_80:isActivity()
	local var3_80 = var0_80:isRemaster()
	local var4_80 = var0_80:isSkirmish()
	local var5_80 = var0_80:isEscort()
	local var6_80 = var0_80:getConfig("type")
	local var7_80 = getProxy(ActivityProxy)
	local var8_80 = underscore(var7_80:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)):chain():select(function(arg0_81)
		return not arg0_81:isEnd()
	end):sort(function(arg0_82, arg1_82)
		return arg0_82.id < arg1_82.id
	end):value()[1] and not var1_80 and not var4_80 and not var5_80

	if var8_80 then
		local var9_80 = setmetatable({}, MainActMapBtn)

		var9_80.image = arg0_80.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var9_80.subImage = arg0_80.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var9_80.tipTr = arg0_80.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var9_80.tipTxt = arg0_80.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_80 = var9_80:InShowTime()

		if var8_80 then
			var9_80:InitTipImage()
			var9_80:InitSubImage()
			var9_80:InitImage(function()
				return
			end)
			var9_80:OnInit()
		end
	end

	setActive(arg0_80.activityBtn, var8_80)
	arg0_80:updateRemasterInfo()

	if var1_80 and var2_80 then
		local var10_80

		if var0_80:isRemaster() then
			var10_80 = getProxy(ChapterProxy):getRemasterMaps(var0_80.remasterId)
		else
			var10_80 = getProxy(ChapterProxy):getMapsByActivities()
		end

		local var11_80 = underscore.any(var10_80, function(arg0_84)
			return arg0_84:isActExtra()
		end)

		setActive(arg0_80.actExtraBtn, var11_80 and var6_80 ~= Map.ACT_EXTRA)

		if isActive(arg0_80.actExtraBtn) then
			if underscore.all(underscore.filter(var10_80, function(arg0_85)
				local var0_85 = arg0_85:getMapType()

				return var0_85 == Map.ACTIVITY_EASY or var0_85 == Map.ACTIVITY_HARD
			end), function(arg0_86)
				return arg0_86:isAllChaptersClear()
			end) then
				setActive(arg0_80.actExtraBtnAnim, true)
			else
				setActive(arg0_80.actExtraBtnAnim, false)
			end

			setActive(arg0_80.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var12_80 = checkExist(var0_80:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_80.actEliteBtn, var12_80 and var6_80 ~= Map.ACTIVITY_HARD)
		setActive(arg0_80.actNormalBtn, var6_80 ~= Map.ACTIVITY_EASY)
		setActive(arg0_80.actExtraRank, var6_80 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_87)
			if not arg0_87 or arg0_87:isEnd() then
				return
			end

			local var0_87 = arg0_87:getConfig("config_data")[1]

			return _.any(var0_80:getChapters(), function(arg0_88)
				if not arg0_88:IsEXChapter() then
					return false
				end

				return table.contains(arg0_88:getConfig("boss_expedition_id"), var0_87)
			end)
		end))
		setActive(arg0_80.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_80 and var2_80 and arg0_80:IsActShopActive())
		setActive(arg0_80.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_80 and var2_80 and arg0_80.ptActivity and not arg0_80.ptActivity:isEnd())
		arg0_80:updateActivityRes()
	else
		setActive(arg0_80.actExtraBtn, false)
		setActive(arg0_80.actEliteBtn, false)
		setActive(arg0_80.actNormalBtn, false)
		setActive(arg0_80.actExtraRank, false)
		setActive(arg0_80.actExchangeShopBtn, false)
		setActive(arg0_80.actAtelierBuffBtn, false)
		setActive(arg0_80.ptTotal, false)
	end

	setActive(arg0_80.eventContainer, (not var1_80 or not var2_80) and not var5_80)
	setActive(arg0_80.remasterBtn, OPEN_REMASTER and (var3_80 or not var1_80 and not var5_80 and not var4_80))
	setActive(arg0_80.ticketTxt.parent, var3_80)
	arg0_80:updateRemasterTicket()
	arg0_80:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_89)
	setText(arg0_89.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_89:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_90)
	local var0_90 = getProxy(ChapterProxy)
	local var1_90 = var0_90:ifShowRemasterTip() or var0_90:anyRemasterAwardCanReceive()

	SetActive(arg0_90.remasterBtn:Find("tip"), var1_90)
	SetActive(arg0_90.entranceLayer:Find("btns/btn_remaster/tip"), var1_90)
end

function var0_0.updatDailyBtnTip(arg0_91)
	local var0_91 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_91.dailyBtn:Find("tip"), var0_91)
	SetActive(arg0_91.entranceLayer:Find("btns/btn_daily/tip"), var0_91)
end

function var0_0.updateRemasterInfo(arg0_92)
	arg0_92:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_92.contextData.map then
		return
	end

	local var0_92 = getProxy(ChapterProxy)
	local var1_92
	local var2_92 = arg0_92.contextData.map:getRemaster()

	if var2_92 and #pg.re_map_template[var2_92].drop_gain > 0 then
		for iter0_92, iter1_92 in ipairs(pg.re_map_template[var2_92].drop_gain) do
			if #iter1_92 > 0 and var0_92.remasterInfo[iter1_92[1]][iter0_92].receive == false then
				var1_92 = {
					iter0_92,
					iter1_92
				}

				break
			end
		end
	end

	setActive(arg0_92.remasterAwardBtn, var1_92)

	if var1_92 then
		local var3_92 = var1_92[1]
		local var4_92, var5_92, var6_92, var7_92 = unpack(var1_92[2])
		local var8_92 = var0_92.remasterInfo[var4_92][var3_92]

		setText(arg0_92.remasterAwardBtn:Find("Text"), var8_92.count .. "/" .. var7_92)
		updateDrop(arg0_92.remasterAwardBtn:Find("IconTpl"), {
			type = var5_92,
			id = var6_92
		})
		setActive(arg0_92.remasterAwardBtn:Find("tip"), var7_92 <= var8_92.count)
		onButton(arg0_92, arg0_92.remasterAwardBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_92,
					id = var6_92
				},
				weight = LayerWeightConst.TOP_LAYER,
				remaster = {
					word = i18n("level_remaster_tip4", pg.chapter_template[var4_92].chapter_name),
					number = var8_92.count .. "/" .. var7_92,
					btn_text = i18n(var8_92.count < var7_92 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var8_92.count < var7_92 then
							local var0_94 = pg.chapter_template[var4_92].map
							local var1_94, var2_94 = var0_92:getMapById(var0_94):isUnlock()

							if not var1_94 then
								pg.TipsMgr.GetInstance():ShowTips(var2_94)
							else
								arg0_92:ShowSelectedMap(var0_94)
							end
						else
							arg0_92:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_92, var3_92)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_95)
	local var0_95 = getProxy(ChapterProxy)

	if arg0_95.newChapterCDTimer then
		arg0_95.newChapterCDTimer:Stop()

		arg0_95.newChapterCDTimer = nil
	end

	local var1_95 = 0

	if arg0_95.contextData.map:isActivity() and not arg0_95.contextData.map:isRemaster() then
		local var2_95 = var0_95:getMapsByActivities()

		_.each(var2_95, function(arg0_96)
			local var0_96 = arg0_96:getChapterTimeLimit()

			if var1_95 == 0 then
				var1_95 = var0_96
			else
				var1_95 = math.min(var1_95, var0_96)
			end
		end)
		setActive(arg0_95.countDown, var1_95 > 0)
		setText(arg0_95.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_95.countDown, false)
	end

	if var1_95 > 0 then
		setText(arg0_95.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_95))

		arg0_95.newChapterCDTimer = Timer.New(function()
			var1_95 = var1_95 - 1

			if var1_95 <= 0 then
				arg0_95:updateCountDown()

				if not arg0_95.contextData.chapterVO then
					arg0_95:setMap(arg0_95.contextData.mapIdx)
				end
			else
				setText(arg0_95.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_95))
			end
		end, 1, -1)

		arg0_95.newChapterCDTimer:Start()
	else
		setText(arg0_95.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_98)
	onButton(arg0_98, arg0_98.actExtraRank, function()
		if arg0_98:isfrozen() then
			return
		end

		arg0_98:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_98, arg0_98.activityBtn, function()
		if arg0_98:isfrozen() then
			return
		end

		arg0_98:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_98, arg0_98.actExchangeShopBtn, function()
		if arg0_98:isfrozen() then
			return
		end

		arg0_98:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_98, arg0_98.actAtelierBuffBtn, function()
		if arg0_98:isfrozen() then
			return
		end

		arg0_98:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)

	local var0_98 = getProxy(ChapterProxy)

	local function var1_98(arg0_103, arg1_103, arg2_103)
		local var0_103

		if arg0_103:isRemaster() then
			var0_103 = var0_98:getRemasterMaps(arg0_103.remasterId)
		else
			var0_103 = var0_98:getMapsByActivities()
		end

		local var1_103 = _.select(var0_103, function(arg0_104)
			return arg0_104:getMapType() == arg1_103
		end)

		table.sort(var1_103, function(arg0_105, arg1_105)
			return arg0_105.id < arg1_105.id
		end)

		local var2_103 = table.indexof(underscore.map(var1_103, function(arg0_106)
			return arg0_106.id
		end), arg2_103) or #var1_103

		while not var1_103[var2_103]:isUnlock() do
			if var2_103 > 1 then
				var2_103 = var2_103 - 1
			else
				break
			end
		end

		return var1_103[var2_103]
	end

	arg0_98:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_107, arg1_107, arg2_107)
		arg2_107 = arg2_107 or switch(arg1_107, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_98.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_98.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_107 = var1_98(arg0_98.contextData.map, arg1_107, arg2_107)
		local var1_107, var2_107 = var0_107:isUnlock()

		if var1_107 then
			arg0_98:setMap(var0_107.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_107)
		end
	end)
	onButton(arg0_98, arg0_98.actNormalBtn, function()
		if arg0_98:isfrozen() then
			return
		end

		arg0_98:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_98, arg0_98.actEliteBtn, function()
		if arg0_98:isfrozen() then
			return
		end

		arg0_98:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_98, arg0_98.actExtraBtn, function()
		if arg0_98:isfrozen() then
			return
		end

		arg0_98:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_114, arg1_114)
	arg0_114.initPositions = {}

	local var0_114 = arg1_114 or 1
	local var1_114 = pg.expedition_data_by_map[var0_114].clouds_pos

	for iter0_114, iter1_114 in ipairs(arg0_114.cloudRTFs) do
		local var2_114 = var1_114[iter0_114]

		if var2_114 then
			iter1_114.anchoredPosition = Vector2(var2_114[1], var2_114[2])

			table.insert(arg0_114.initPositions, iter1_114.anchoredPosition)
		else
			setActive(iter1_114, false)
		end
	end
end

function var0_0.initMapBtn(arg0_115, arg1_115, arg2_115)
	onButton(arg0_115, arg1_115, function()
		if arg0_115:isfrozen() then
			return
		end

		local var0_116 = arg0_115.contextData.mapIdx + arg2_115
		local var1_116 = getProxy(ChapterProxy):getMapById(var0_116)

		if not var1_116 then
			return
		end

		if var1_116:getMapType() == Map.ELITE and not var1_116:isEliteEnabled() then
			var1_116 = var1_116:getBindMap()
			var0_116 = var1_116.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_116, var3_116 = var1_116:isUnlock()

		if arg2_115 > 0 and not var2_116 then
			pg.TipsMgr.GetInstance():ShowTips(var3_116)

			return
		end

		arg0_115:setMap(var0_116)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_117, arg1_117, arg2_117)
	seriesAsync({
		function(arg0_118)
			if arg0_117.contextData.entranceStatus then
				arg0_117:frozen()

				arg0_117.nextPreloadMap = arg1_117

				arg0_117:PreloadLevelMainUI(arg1_117, function()
					arg0_117:unfrozen()

					if arg0_117.nextPreloadMap ~= arg1_117 then
						return
					end

					arg0_117:ShowEntranceUI(false)
					arg0_117:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_117)
					arg0_118()
				end)
			else
				arg0_117:setMap(arg1_117)
				arg0_118()
			end
		end
	}, arg2_117)
end

function var0_0.setMap(arg0_120, arg1_120)
	local var0_120 = arg0_120.contextData.mapIdx

	arg0_120.contextData.mapIdx = arg1_120
	arg0_120.contextData.map = getProxy(ChapterProxy):getMapById(arg1_120)

	assert(arg0_120.contextData.map, "map cannot be nil " .. arg1_120)

	if arg0_120.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_120.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_120.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_120.contextData.map.remasterId, arg1_120)
		PlayerPrefs.Save()
	end

	arg0_120:RecordLastMapOnExit()
	arg0_120:updateMap(var0_120)
	arg0_120:tryPlayMapStory()
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
	[var5_0.TYPESPFULL] = "MapBuilderSPFull"
}

function var0_0.SwitchMapBuilder(arg0_121, arg1_121)
	if arg0_121.mapBuilder and arg0_121.mapBuilder:GetType() ~= arg1_121 then
		arg0_121.mapBuilder.buffer:Hide()
	end

	local var0_121 = arg0_121:GetMapBuilderInBuffer(arg1_121)

	arg0_121.mapBuilder = var0_121

	var0_121.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_122, arg1_122)
	if not arg0_122.mbDict[arg1_122] then
		local var0_122 = _G[var6_0[arg1_122]]

		assert(var0_122, "Missing MapBuilder of type " .. (arg1_122 or "NIL"))

		arg0_122.mbDict[arg1_122] = var0_122.New(arg0_122._tf, arg0_122)
		arg0_122.mbDict[arg1_122].isFrozen = arg0_122:isfrozen()

		arg0_122.mbDict[arg1_122]:Load()
	end

	return arg0_122.mbDict[arg1_122]
end

function var0_0.updateMap(arg0_123, arg1_123)
	local var0_123 = arg0_123.contextData.map
	local var1_123 = var0_123:getConfig("anchor")
	local var2_123

	if var1_123 == "" then
		var2_123 = Vector2.zero
	else
		var2_123 = Vector2(unpack(var1_123))
	end

	arg0_123.map.pivot = var2_123

	local var3_123 = var0_123:getConfig("uifx")

	for iter0_123 = 1, arg0_123.UIFXList.childCount do
		local var4_123 = arg0_123.UIFXList:GetChild(iter0_123 - 1)

		setActive(var4_123, var4_123.name == var3_123)
	end

	arg0_123:SwitchMapBG(var0_123, arg1_123)
	arg0_123:PlayBGM()

	local var5_123 = arg0_123.contextData.map:getConfig("ui_type")

	arg0_123:SwitchMapBuilder(var5_123)
	seriesAsync({
		function(arg0_124)
			arg0_123.mapBuilder:CallbackInvoke(arg0_124)
		end,
		function(arg0_125)
			arg0_123.mapBuilder:UpdateMapVO(var0_123)
			arg0_123.mapBuilder:UpdateView()
			arg0_123.mapBuilder:UpdateMapItems()
			arg0_123.mapBuilder:PlayEnterAnim()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_126)
	local var0_126 = arg0_126.contextData.map
	local var1_126 = getProxy(ChapterProxy)
	local var2_126 = var1_126:getMapById(var0_126.id - 1)
	local var3_126 = var1_126:getMapById(var0_126.id + 1)

	setActive(arg0_126.btnPrev, tobool(var2_126))
	setActive(arg0_126.btnNext, tobool(var3_126))

	local var4_126 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_126.btnPrevCol, var2_126 and Color.white or var4_126)
	setImageColor(arg0_126.btnNextCol, var3_126 and var3_126:isUnlock() and Color.white or var4_126)
end

function var0_0.tryPlayMapStory(arg0_127)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_128)
			local var0_128 = arg0_127.contextData.map:getConfig("enter_story")

			if var0_128 and var0_128 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_128) and not arg0_127.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_128 = tonumber(var0_128)

				if var1_128 and var1_128 > 0 then
					arg0_127:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_128)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_128, arg0_128)
				end

				return
			end

			arg0_128()
		end,
		function(arg0_129)
			local var0_129 = arg0_127.contextData.map:getConfig("guide_id")

			if var0_129 and var0_129 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_129, nil, arg0_129)

				return
			end

			arg0_129()
		end,
		function(arg0_130)
			if isActive(arg0_127.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_130 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_130

				if var0_130 then
					var1_130 = {
						1,
						2
					}
				else
					var1_130 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_130)
			else
				arg0_130()
			end
		end,
		function(arg0_131)
			if arg0_127.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_127.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_132, arg1_132, arg2_132, arg3_132)
	arg0_132.uiAnims = arg0_132.uiAnims or {}

	local var0_132 = arg0_132.uiAnims[arg1_132]

	local function var1_132()
		arg0_132.playing = true

		arg0_132:frozen()
		var0_132:SetActive(true)

		local var0_133 = tf(var0_132)

		pg.UIMgr.GetInstance():OverlayPanel(var0_133, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_132 then
			arg3_132(var0_132)
		end

		var0_133:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_134)
			arg0_132.playing = false

			if arg2_132 then
				arg2_132(var0_132)
			end

			arg0_132:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_132 then
		PoolMgr.GetInstance():GetUI(arg1_132, true, function(arg0_135)
			arg0_135:SetActive(true)

			arg0_132.uiAnims[arg1_132] = arg0_135
			var0_132 = arg0_132.uiAnims[arg1_132]

			var1_132()
		end)
	else
		var1_132()
	end
end

function var0_0.displaySpResult(arg0_136, arg1_136, arg2_136)
	setActive(arg0_136.spResult, true)
	arg0_136:DisplaySPAnim(arg1_136 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_137)
		onButton(arg0_136, arg0_137, function()
			removeOnButton(arg0_137)
			setActive(arg0_137, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_137, arg0_136._tf)
			arg0_136:hideSpResult()
			arg2_136()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_139)
	setActive(arg0_139.spResult, false)
end

function var0_0.displayBombResult(arg0_140, arg1_140)
	setActive(arg0_140.spResult, true)
	arg0_140:DisplaySPAnim("SpBombRet", function(arg0_141)
		onButton(arg0_140, arg0_141, function()
			removeOnButton(arg0_141)
			setActive(arg0_141, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_141, arg0_140._tf)
			arg0_140:hideSpResult()
			arg1_140()
		end, SFX_PANEL)
	end, function(arg0_143)
		setText(arg0_143.transform:Find("right/name_bg/en"), arg0_140.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_144, arg1_144, arg2_144)
	arg0_144.contextData.chapterLoopFlag = arg2_144

	local var0_144 = getProxy(ChapterProxy):getChapterById(arg1_144, true)

	if var0_144:getConfig("type") == Chapter.CustomFleet then
		arg0_144:displayFleetEdit(var0_144)

		return
	end

	if #var0_144:getNpcShipByType(1) > 0 then
		arg0_144:emit(LevelMediator2.ON_TRACKING, arg1_144)

		return
	end

	arg0_144:displayFleetSelect(var0_144)
end

function var0_0.DisplayLevelInfoPanel(arg0_145, arg1_145, arg2_145)
	seriesAsync({
		function(arg0_146)
			if not arg0_145.levelInfoView:GetLoaded() then
				arg0_145:frozen()
				arg0_145.levelInfoView:Load()
				arg0_145.levelInfoView:CallbackInvoke(function()
					arg0_145:unfrozen()
					arg0_146()
				end)

				return
			end

			arg0_146()
		end,
		function(arg0_148)
			local function var0_148(arg0_149, arg1_149)
				arg0_145:hideChapterPanel()
				arg0_145:OnLevelInfoPanelConfirm(arg0_149, arg1_149)
			end

			local function var1_148()
				arg0_145:hideChapterPanel()
			end

			local var2_148 = getProxy(ChapterProxy):getChapterById(arg1_145, true)

			if getProxy(ChapterProxy):getMapById(var2_148:getConfig("map")):isSkirmish() and #var2_148:getNpcShipByType(1) > 0 then
				var0_148(false)

				return
			end

			arg0_145.levelInfoView:set(arg1_145, arg2_145)
			arg0_145.levelInfoView:setCBFunc(var0_148, var1_148)
			arg0_145.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_151)
	if arg0_151.levelInfoView:isShowing() then
		arg0_151.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_152)
	arg0_152.levelInfoView:Destroy()

	arg0_152.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_153, arg1_153, arg2_153, arg3_153)
	seriesAsync({
		function(arg0_154)
			if not arg0_153.levelInfoSPView then
				arg0_153.levelInfoSPView = LevelInfoSPView.New(arg0_153.topPanel, arg0_153.event, arg0_153.contextData)

				arg0_153:frozen()
				arg0_153.levelInfoSPView:Load()
				arg0_153.levelInfoSPView:CallbackInvoke(function()
					arg0_153:unfrozen()
					arg0_154()
				end)

				return
			end

			arg0_154()
		end,
		function(arg0_156)
			local function var0_156(arg0_157, arg1_157)
				arg0_153:HideLevelInfoSPPanel()
				arg0_153:OnLevelInfoPanelConfirm(arg0_157, arg1_157)
			end

			local function var1_156()
				arg0_153:HideLevelInfoSPPanel()
			end

			arg0_153.levelInfoSPView:SetChapterGroupInfo(arg2_153)
			arg0_153.levelInfoSPView:set(arg1_153, arg3_153)
			arg0_153.levelInfoSPView:setCBFunc(var0_156, var1_156)
			arg0_153.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_159)
	if arg0_159.levelInfoSPView and arg0_159.levelInfoSPView:isShowing() then
		arg0_159.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_160)
	if not arg0_160.levelInfoSPView then
		return
	end

	arg0_160.levelInfoSPView:Destroy()

	arg0_160.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_161, arg1_161)
	local var0_161 = arg0_161.contextData.selectedFleetIDs or arg1_161:GetDefaultFleetIndex()

	arg1_161 = Clone(arg1_161)
	arg1_161.loopFlag = arg0_161.contextData.chapterLoopFlag

	arg0_161.levelFleetView:updateSpecialOperationTickets(arg0_161.spTickets)
	arg0_161.levelFleetView:Load()
	arg0_161.levelFleetView:ActionInvoke("setHardShipVOs", arg0_161.shipVOs)
	arg0_161.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_161.openedCommanerSystem)
	arg0_161.levelFleetView:ActionInvoke("set", arg1_161, arg0_161.fleets, var0_161)
	arg0_161.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_162)
	if arg0_162.levelCMDFormationView:isShowing() then
		arg0_162.levelCMDFormationView:Hide()
	end

	if arg0_162.levelFleetView then
		arg0_162.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_163)
	arg0_163.levelCMDFormationView = LevelCMDFormationView.New(arg0_163.topPanel, arg0_163.event, arg0_163.contextData)
end

function var0_0.destroyFleetSelect(arg0_164)
	if not arg0_164.levelFleetView then
		return
	end

	arg0_164.levelFleetView:Destroy()

	arg0_164.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_165, arg1_165)
	arg1_165 = Clone(arg1_165)
	arg1_165.loopFlag = arg0_165.contextData.chapterLoopFlag

	arg0_165.levelFleetView:updateSpecialOperationTickets(arg0_165.spTickets)
	arg0_165.levelFleetView:Load()
	arg0_165.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_165.openedCommanerSystem)
	arg0_165.levelFleetView:ActionInvoke("setHardShipVOs", arg0_165.shipVOs)
	arg0_165.levelFleetView:ActionInvoke("setOnHard", arg1_165)
	arg0_165.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_166)
	arg0_166:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_167)
	arg0_167:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_168, arg1_168)
	if not arg0_168.levelFleetView then
		return
	end

	assert(arg0_168.levelFleetView:GetLoaded())

	local var0_168 = arg0_168.levelFleetView:IsSelectMode()
	local var1_168

	if var0_168 then
		arg0_168.levelFleetView:ActionInvoke("set", arg1_168 or arg0_168.levelFleetView.chapter, arg0_168.fleets, arg0_168.levelFleetView:getSelectIds())

		if arg0_168.levelCMDFormationView:isShowing() then
			local var2_168 = arg0_168.levelCMDFormationView.fleet.id

			var1_168 = arg0_168.fleets[var2_168]
		end
	else
		arg0_168.levelFleetView:ActionInvoke("setOnHard", arg1_168 or arg0_168.levelFleetView.chapter)

		if arg0_168.levelCMDFormationView:isShowing() then
			local var3_168 = arg0_168.levelCMDFormationView.fleet.id

			var1_168 = arg1_168:wrapEliteFleet(var3_168)
		end
	end

	if var1_168 then
		arg0_168.levelCMDFormationView:ActionInvoke("updateFleet", var1_168)
	end
end

function var0_0.setChapter(arg0_169, arg1_169)
	local var0_169

	if arg1_169 then
		var0_169 = arg1_169.id
	end

	arg0_169.contextData.chapterId = var0_169
	arg0_169.contextData.chapterVO = arg1_169
end

function var0_0.switchToChapter(arg0_170, arg1_170)
	if arg0_170.contextData.mapIdx ~= arg1_170:getConfig("map") then
		arg0_170:setMap(arg1_170:getConfig("map"))
	end

	arg0_170:setChapter(arg1_170)

	arg0_170.leftCanvasGroup.blocksRaycasts = false
	arg0_170.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_170.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_170:DestroyLevelStageView()

	if not arg0_170.levelStageView then
		arg0_170.levelStageView = LevelStageView.New(arg0_170.topPanel, arg0_170.event, arg0_170.contextData)

		arg0_170.levelStageView:Load()

		arg0_170.levelStageView.isFrozen = arg0_170:isfrozen()
	end

	arg0_170:frozen()

	local function var0_170()
		seriesAsync({
			function(arg0_172)
				arg0_170.mapBuilder:CallbackInvoke(arg0_172)
			end,
			function(arg0_173)
				setActive(arg0_170.clouds, false)
				arg0_170.mapBuilder:HideFloat()
				pg.UIMgr.GetInstance():BlurPanel(arg0_170.topPanel, false, {
					blurCamList = {
						pg.UIMgr.CameraUI
					},
					groupName = LayerWeightConst.GROUP_LEVELUI
				})
				pg.playerResUI:SetActive({
					active = true,
					groupName = LayerWeightConst.GROUP_LEVELUI,
					showType = PlayerResUI.TYPE_ALL
				})
				arg0_170.levelStageView:updateStageInfo()
				arg0_170.levelStageView:updateAmbushRate(arg1_170.fleet.line, true)
				arg0_170.levelStageView:updateStageAchieve()
				arg0_170.levelStageView:updateStageBarrier()
				arg0_170.levelStageView:updateBombPanel()
				arg0_170.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_173)
			end,
			function(arg0_174)
				if arg0_170.exited then
					return
				end

				arg0_170.levelStageView:updateStageStrategy()

				arg0_170.canvasGroup.blocksRaycasts = arg0_170.frozenCount == 0

				onNextTick(arg0_174)
			end,
			function(arg0_175)
				if arg0_170.exited then
					return
				end

				arg0_170.levelStageView:updateStageFleet()
				arg0_170.levelStageView:updateSupportFleet()
				arg0_170.levelStageView:updateFleetBuff()
				onNextTick(arg0_175)
			end,
			function(arg0_176)
				if arg0_170.exited then
					return
				end

				parallelAsync({
					function(arg0_177)
						local var0_177 = arg1_170:getConfig("scale")
						local var1_177 = LeanTween.value(go(arg0_170.map), arg0_170.map.localScale, Vector3.New(var0_177[3], var0_177[3], 1), var1_0):setOnUpdateVector3(function(arg0_178)
							arg0_170.map.localScale = arg0_178
							arg0_170.float.localScale = arg0_178
						end):setOnComplete(System.Action(function()
							arg0_170.mapBuilder:ShowFloat()
							arg0_170.mapBuilder:Hide()
							arg0_177()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_170:RecordTween("mapScale", var1_177.uniqueId)

						local var2_177 = LeanTween.value(go(arg0_170.map), arg0_170.map.pivot, Vector2.New(math.clamp(var0_177[1] - 0.5, 0, 1), math.clamp(var0_177[2] - 0.5, 0, 1)), var1_0)

						var2_177:setOnUpdateVector2(function(arg0_180)
							arg0_170.map.pivot = arg0_180
							arg0_170.float.pivot = arg0_180
						end):setEase(LeanTweenType.easeOutSine)
						arg0_170:RecordTween("mapPivot", var2_177.uniqueId)
						shiftPanel(arg0_170.leftChapter, -arg0_170.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_170.rightChapter, arg0_170.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_170.topChapter, 0, arg0_170.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_170.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_181)
						arg0_170:PlayBGM()

						local var0_181 = {}
						local var1_181 = arg1_170:getConfig("bg")

						if var1_181 and #var1_181 > 0 then
							var0_181[1] = {
								BG = var1_181
							}
						end

						arg0_170:SwitchBG(var0_181, arg0_181)
					end
				}, function()
					onNextTick(arg0_176)
				end)
			end,
			function(arg0_183)
				if arg0_170.exited then
					return
				end

				setActive(arg0_170.topChapter, false)
				setActive(arg0_170.leftChapter, false)
				setActive(arg0_170.rightChapter, false)

				arg0_170.leftCanvasGroup.blocksRaycasts = true
				arg0_170.rightCanvasGroup.blocksRaycasts = true

				arg0_170:initGrid(arg0_183)
			end,
			function(arg0_184)
				if arg0_170.exited then
					return
				end

				arg0_170.levelStageView:SetGrid(arg0_170.grid)

				arg0_170.contextData.huntingRangeVisibility = arg0_170.contextData.huntingRangeVisibility - 1

				arg0_170.grid:toggleHuntingRange()

				local var0_184 = arg1_170:getConfig("pop_pic")

				if var0_184 and #var0_184 > 0 and arg0_170.FirstEnterChapter == arg1_170.id then
					arg0_170:doPlayAnim(var0_184, function(arg0_185)
						setActive(arg0_185, false)

						if arg0_170.exited then
							return
						end

						arg0_184()
					end)
				else
					arg0_184()
				end
			end,
			function(arg0_186)
				arg0_170.levelStageView:tryAutoAction(arg0_186)
			end,
			function(arg0_187)
				if arg0_170.exited then
					return
				end

				arg0_170:unfrozen()

				if arg0_170.FirstEnterChapter then
					arg0_170:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_170.subAutoAttack)
				end

				arg0_170.FirstEnterChapter = nil

				arg0_170.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0_170.levelStageView:ActionInvoke("SetSeriesOperation", var0_170)
	arg0_170.levelStageView:ActionInvoke("SetPlayer", arg0_170.player)
	arg0_170.levelStageView:ActionInvoke("SwitchToChapter", arg1_170)
end

function var0_0.switchToMap(arg0_188, arg1_188)
	arg0_188:frozen()
	arg0_188:destroyGrid()
	arg0_188:setChapter(nil)
	LeanTween.cancel(go(arg0_188.map))

	local var0_188 = LeanTween.value(go(arg0_188.map), arg0_188.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_189)
		arg0_188.map.localScale = arg0_189
		arg0_188.float.localScale = arg0_189
	end):setOnComplete(System.Action(function()
		arg0_188:unfrozen()
		arg0_188.mapBuilder:PlayEnterAnim()
		existCall(arg1_188)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_188:RecordTween("mapScale", var0_188.uniqueId)

	local var1_188 = arg0_188.contextData.map:getConfig("anchor")
	local var2_188

	if var1_188 == "" then
		var2_188 = Vector2.zero
	else
		var2_188 = Vector2(unpack(var1_188))
	end

	local var3_188 = LeanTween.value(go(arg0_188.map), arg0_188.map.pivot, var2_188, var1_0)

	var3_188:setOnUpdateVector2(function(arg0_191)
		arg0_188.map.pivot = arg0_191
		arg0_188.float.pivot = arg0_191
	end):setEase(LeanTweenType.easeOutSine)
	arg0_188:RecordTween("mapPivot", var3_188.uniqueId)
	setActive(arg0_188.topChapter, true)
	setActive(arg0_188.leftChapter, true)
	setActive(arg0_188.rightChapter, true)
	shiftPanel(arg0_188.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_188.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_188.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_188.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_188.levelStageView then
		arg0_188.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_188:DestroyLevelStageView()
		end)
		arg0_188.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_188:SwitchMapBG(arg0_188.contextData.map)
	arg0_188:PlayBGM()
	seriesAsync({
		function(arg0_193)
			arg0_188.mapBuilder:CallbackInvoke(arg0_193)
		end,
		function(arg0_194)
			arg0_188.mapBuilder:Show()
			arg0_188.mapBuilder:UpdateView()
			arg0_188.mapBuilder:UpdateMapItems()
		end
	})
	pg.UIMgr.GetInstance():UnblurPanel(arg0_188.topPanel, arg0_188._tf)
	pg.playerResUI:SetActive({
		active = false
	})

	arg0_188.canvasGroup.blocksRaycasts = arg0_188.frozenCount == 0
	arg0_188.canvasGroup.interactable = true

	if arg0_188.ambushWarning and arg0_188.ambushWarning.activeSelf then
		arg0_188.ambushWarning:SetActive(false)
		arg0_188:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_195, arg1_195, arg2_195, arg3_195)
	if not arg1_195 or #arg1_195 <= 0 then
		existCall(arg2_195)

		return
	elseif arg3_195 then
		-- block empty
	elseif table.equal(arg0_195.currentBG, arg1_195) then
		return
	end

	arg0_195.currentBG = arg1_195

	for iter0_195, iter1_195 in ipairs(arg0_195.mapGroup) do
		arg0_195.loader:ClearRequest(iter1_195)
	end

	table.clear(arg0_195.mapGroup)

	local var0_195 = {}

	table.ParallelIpairsAsync(arg1_195, function(arg0_196, arg1_196, arg2_196)
		local var0_196 = arg0_195.mapTFs[arg0_196]
		local var1_196 = arg1_196.bgPrefix and arg1_196.bgPrefix .. "/" or "levelmap/"
		local var2_196 = arg0_195.loader:GetSpriteDirect(var1_196 .. arg1_196.BG, "", function(arg0_197)
			var0_195[arg0_196] = arg0_197

			arg2_196()
		end, var0_196)

		table.insert(arg0_195.mapGroup, var2_196)
		arg0_195:updateCouldAnimator(arg1_196.Animator, arg0_196)
	end, function()
		for iter0_198, iter1_198 in ipairs(arg0_195.mapTFs) do
			setImageSprite(iter1_198, var0_195[iter0_198])
			setActive(iter1_198, arg1_195[iter0_198])
			SetCompomentEnabled(iter1_198, typeof(Image), true)
		end

		existCall(arg2_195)
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

function var0_0.ClearMapTransitions(arg0_199)
	if not arg0_199.mapTransitions then
		return
	end

	for iter0_199, iter1_199 in pairs(arg0_199.mapTransitions) do
		if iter1_199 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_199, iter0_199, iter1_199, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_199, iter0_199)
		end
	end

	arg0_199.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_200, arg1_200, arg2_200, arg3_200)
	local var0_200, var1_200, var2_200 = arg0_200:GetMapBG(arg1_200, arg2_200)

	if not var1_200 then
		arg0_200:SwitchBG(var0_200, nil, arg3_200)

		return
	end

	arg0_200:PlayMapTransition("LevelMapTransition_" .. var1_200, var2_200, function()
		arg0_200:SwitchBG(var0_200, nil, arg3_200)
	end)
end

function var0_0.GetMapBG(arg0_202, arg1_202, arg2_202)
	if not table.contains(var7_0, arg1_202.id) then
		return {
			arg0_202:GetMapElement(arg1_202)
		}
	end

	local var0_202 = arg1_202.id
	local var1_202 = table.indexof(var7_0, var0_202) - 1
	local var2_202 = bit.lshift(bit.rshift(var1_202, 1), 1) + 1
	local var3_202 = {
		var7_0[var2_202],
		var7_0[var2_202 + 1]
	}
	local var4_202 = _.map(var3_202, function(arg0_203)
		return getProxy(ChapterProxy):getMapById(arg0_203)
	end)

	if _.all(var4_202, function(arg0_204)
		return arg0_204:isAllChaptersClear()
	end) then
		local var5_202 = {
			arg0_202:GetMapElement(arg1_202)
		}

		if not arg2_202 or math.abs(var0_202 - arg2_202) ~= 1 then
			return var5_202
		end

		local var6_202 = var9_0[bit.rshift(var2_202 - 1, 1) + 1]
		local var7_202 = bit.band(var1_202, 1) == 1

		return var5_202, var6_202, var7_202
	else
		local var8_202 = 0

		;(function()
			local var0_205 = var4_202[1]:getChapters()

			for iter0_205, iter1_205 in ipairs(var0_205) do
				if not iter1_205:isClear() then
					return
				end

				var8_202 = var8_202 + 1
			end

			if not var4_202[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_202 = var8_202 + 1

			local var1_205 = var4_202[2]:getChapters()

			for iter2_205, iter3_205 in ipairs(var1_205) do
				if not iter3_205:isClear() then
					return
				end

				var8_202 = var8_202 + 1
			end
		end)()

		local var9_202

		if var8_202 > 0 then
			local var10_202 = var8_0[bit.rshift(var2_202 - 1, 1) + 1]

			var9_202 = {
				{
					BG = "map_" .. var10_202[1],
					Animator = var10_202[2]
				},
				{
					BG = "map_" .. var10_202[3] + var8_202,
					Animator = var10_202[4]
				}
			}
		else
			var9_202 = {
				arg0_202:GetMapElement(arg1_202)
			}
		end

		return var9_202
	end
end

function var0_0.GetMapElement(arg0_206, arg1_206)
	local var0_206 = arg1_206:getConfig("bg")
	local var1_206 = arg1_206:getConfig("ani_controller")

	if var1_206 and #var1_206 > 0 then
		(function()
			for iter0_207, iter1_207 in ipairs(var1_206) do
				local var0_207 = _.rest(iter1_207[2], 2)

				for iter2_207, iter3_207 in ipairs(var0_207) do
					if string.find(iter3_207, "^map_") and iter1_207[1] == var3_0 then
						local var1_207 = iter1_207[2][1]
						local var2_207 = getProxy(ChapterProxy):GetChapterItemById(var1_207)

						if var2_207 and not var2_207:isClear() then
							var0_206 = iter3_207

							return
						end
					end
				end
			end
		end)()
	end

	local var2_206 = {
		BG = var0_206
	}

	var2_206.Animator, var2_206.AnimatorController = arg0_206:GetMapAnimator(arg1_206)

	return var2_206
end

function var0_0.GetMapAnimator(arg0_208, arg1_208)
	local var0_208 = arg1_208:getConfig("ani_name")

	if arg1_208:getConfig("animtor") == 1 and var0_208 and #var0_208 > 0 then
		local var1_208 = arg1_208:getConfig("ani_controller")

		if var1_208 and #var1_208 > 0 then
			(function()
				for iter0_209, iter1_209 in ipairs(var1_208) do
					local var0_209 = _.rest(iter1_209[2], 2)

					for iter2_209, iter3_209 in ipairs(var0_209) do
						if string.find(iter3_209, "^effect_") and iter1_209[1] == var3_0 then
							local var1_209 = iter1_209[2][1]
							local var2_209 = getProxy(ChapterProxy):GetChapterItemById(var1_209)

							if var2_209 and not var2_209:isClear() then
								var0_208 = "map_" .. string.sub(iter3_209, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_208, var1_208
	end
end

function var0_0.PlayMapTransition(arg0_210, arg1_210, arg2_210, arg3_210, arg4_210)
	arg0_210.mapTransitions = arg0_210.mapTransitions or {}

	local var0_210

	local function var1_210()
		arg0_210:frozen()
		existCall(arg3_210, var0_210)
		var0_210:SetActive(true)

		local var0_211 = tf(var0_210)

		pg.UIMgr.GetInstance():OverlayPanel(var0_211, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		var0_210:GetComponent(typeof(Animator)):Play(arg2_210 and "Sequence" or "Inverted", -1, 0)
		var0_211:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_212)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_211, arg0_210._tf)
			existCall(arg4_210, var0_210)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_210, arg1_210, var0_210)

			arg0_210.mapTransitions[arg1_210] = false

			arg0_210:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_210, arg1_210, true, function(arg0_213)
		var0_210 = arg0_213
		arg0_210.mapTransitions[arg1_210] = arg0_213

		var1_210()
	end)
end

function var0_0.DestroyLevelStageView(arg0_214)
	if arg0_214.levelStageView then
		arg0_214.levelStageView:Destroy()

		arg0_214.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_215, arg1_215)
	arg0_215.levelAmbushView = LevelAmbushView.New(arg0_215.topPanel, arg0_215.event, arg0_215.contextData)

	arg0_215.levelAmbushView:Load()
	arg0_215.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_215)
end

function var0_0.hideAmbushInfo(arg0_216)
	if arg0_216.levelAmbushView then
		arg0_216.levelAmbushView:Destroy()

		arg0_216.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_217, arg1_217)
	arg0_217:frozen()

	local function var0_217()
		arg0_217.ambushWarning:SetActive(true)

		local var0_218 = tf(arg0_217.ambushWarning)

		var0_218:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_218:SetSiblingIndex(1)

		local var1_218 = var0_218:GetComponent("DftAniEvent")

		var1_218:SetTriggerEvent(function(arg0_219)
			arg1_217()
		end)
		var1_218:SetEndEvent(function(arg0_220)
			arg0_217.ambushWarning:SetActive(false)
			arg0_217:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_217.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_222)
			arg0_222:SetActive(true)

			arg0_217.ambushWarning = arg0_222

			var0_217()
		end)
	else
		var0_217()
	end
end

function var0_0.destroyAmbushWarn(arg0_223)
	if arg0_223.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_223.ambushWarning)

		arg0_223.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_224, arg1_224)
	arg0_224.levelStrategyView = LevelStrategyView.New(arg0_224.topPanel, arg0_224.event, arg0_224.contextData)

	arg0_224.levelStrategyView:Load()
	arg0_224.levelStrategyView:ActionInvoke("set", arg1_224)

	local function var0_224()
		local var0_225 = arg0_224.contextData.chapterVO.fleet
		local var1_225 = pg.strategy_data_template[arg1_224.id]

		if not var0_225:canUseStrategy(arg1_224) then
			return
		end

		local var2_225 = var0_225:getNextStgUser(arg1_224.id)

		if var1_225.type == ChapterConst.StgTypeForm then
			arg0_224:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_225,
				arg1 = arg1_224.id
			})
		elseif var1_225.type == ChapterConst.StgTypeConsume then
			arg0_224:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_225,
				arg1 = arg1_224.id
			})
		end

		arg0_224:hideStrategyInfo()
	end

	local function var1_224()
		arg0_224:hideStrategyInfo()
	end

	arg0_224.levelStrategyView:ActionInvoke("setCBFunc", var0_224, var1_224)
end

function var0_0.hideStrategyInfo(arg0_227)
	if arg0_227.levelStrategyView then
		arg0_227.levelStrategyView:Destroy()

		arg0_227.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_228, arg1_228)
	local var0_228 = arg0_228.contextData.chapterVO
	local var1_228 = getProxy(ChapterProxy)
	local var2_228
	local var3_228
	local var4_228
	local var5_228
	local var6_228 = var1_228.repairTimes
	local var7_228, var8_228, var9_228 = ChapterConst.GetRepairParams()

	arg0_228.levelRepairView = LevelRepairView.New(arg0_228.topPanel, arg0_228.event, arg0_228.contextData)

	arg0_228.levelRepairView:Load()
	arg0_228.levelRepairView:ActionInvoke("set", var6_228, var7_228, var8_228, var9_228)

	local function var10_228()
		if var7_228 - math.min(var6_228, var7_228) == 0 and arg0_228.player:getTotalGem() < var9_228 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_228:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_228.fleet.id,
			arg1 = arg1_228.id
		})
		arg0_228:hideRepairWindow()
	end

	local function var11_228()
		arg0_228:hideRepairWindow()
	end

	arg0_228.levelRepairView:ActionInvoke("setCBFunc", var10_228, var11_228)
end

function var0_0.hideRepairWindow(arg0_231)
	if arg0_231.levelRepairView then
		arg0_231.levelRepairView:Destroy()

		arg0_231.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_232, arg1_232)
	arg0_232.levelRemasterView:Load()

	local function var0_232(arg0_233)
		arg0_232:ShowSelectedMap(arg0_233)
	end

	arg0_232.levelRemasterView:ActionInvoke("Show")
	arg0_232.levelRemasterView:ActionInvoke("set", var0_232, arg1_232)
end

function var0_0.hideRemasterPanel(arg0_234)
	if arg0_234.levelRemasterView:isShowing() then
		arg0_234.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_235, arg1_235)
	local var0_235 = arg0_235.contextData.chapterVO

	if not var0_235 then
		return
	end

	arg0_235:enableLevelCamera()
	setActive(arg0_235.uiMain, true)

	arg0_235.levelGrid.localEulerAngles = Vector3(var0_235.theme.angle, 0, 0)
	arg0_235.grid = LevelGrid.New(arg0_235.dragLayer)

	arg0_235.grid:attach(arg0_235)
	arg0_235.grid:ExtendItem("shipTpl", arg0_235.shipTpl)
	arg0_235.grid:ExtendItem("subTpl", arg0_235.subTpl)
	arg0_235.grid:ExtendItem("transportTpl", arg0_235.transportTpl)
	arg0_235.grid:ExtendItem("enemyTpl", arg0_235.enemyTpl)
	arg0_235.grid:ExtendItem("championTpl", arg0_235.championTpl)
	arg0_235.grid:ExtendItem("oniTpl", arg0_235.oniTpl)
	arg0_235.grid:ExtendItem("arrowTpl", arg0_235.arrowTarget)
	arg0_235.grid:ExtendItem("destinationMarkTpl", arg0_235.destinationMarkTpl)

	function arg0_235.grid.onShipStepChange(arg0_236)
		arg0_235.levelStageView:updateAmbushRate(arg0_236)
	end

	arg0_235.grid:initAll(arg1_235)
end

function var0_0.destroyGrid(arg0_237)
	if arg0_237.grid then
		arg0_237.grid:detach()

		arg0_237.grid = nil

		arg0_237:disableLevelCamera()
		setActive(arg0_237.dragLayer, true)
		setActive(arg0_237.uiMain, false)
	end
end

function var0_0.doTracking(arg0_238, arg1_238)
	arg0_238:frozen()

	local function var0_238()
		arg0_238.radar:SetActive(true)

		local var0_239 = tf(arg0_238.radar)

		var0_239:SetParent(arg0_238.topPanel, false)
		var0_239:SetSiblingIndex(1)
		var0_239:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_240)
			arg0_238.radar:SetActive(false)
			arg0_238:unfrozen()
			arg1_238()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_238.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_241)
			arg0_241:SetActive(true)

			arg0_238.radar = arg0_241

			var0_238()
		end)
	else
		var0_238()
	end
end

function var0_0.destroyTracking(arg0_242)
	if arg0_242.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_242.radar)

		arg0_242.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_243, arg1_243, arg2_243, arg3_243)
	local function var0_243()
		arg0_243.playing = true

		arg0_243:frozen()
		arg0_243.airStrike:SetActive(true)

		local var0_244 = tf(arg0_243.airStrike)

		var0_244:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_244:SetAsLastSibling()
		setActive(var0_244:Find("words/be_striked"), arg1_243 == ChapterConst.SubjectChampion)
		setActive(var0_244:Find("words/strike_enemy"), arg1_243 == ChapterConst.SubjectPlayer)

		local function var1_244()
			arg0_243.playing = false

			SetActive(arg0_243.airStrike, false)

			if arg3_243 then
				arg3_243()
			end

			arg0_243:unfrozen()
		end

		var0_244:GetComponent("DftAniEvent"):SetEndEvent(var1_244)

		if arg2_243 then
			onButton(arg0_243, var0_244, var1_244, SFX_PANEL)
		else
			removeOnButton(var0_244)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_243.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_246)
			arg0_246:SetActive(true)

			arg0_243.airStrike = arg0_246

			var0_243()
		end)
	else
		var0_243()
	end
end

function var0_0.destroyAirStrike(arg0_247)
	if arg0_247.airStrike then
		arg0_247.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_247.airStrike)

		arg0_247.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_248, arg1_248, arg2_248, arg3_248)
	arg0_248.uiAnims = arg0_248.uiAnims or {}

	local var0_248 = arg0_248.uiAnims[arg1_248]

	local function var1_248()
		arg0_248.playing = true

		arg0_248:frozen()
		var0_248:SetActive(true)

		local var0_249 = tf(var0_248)

		pg.UIMgr.GetInstance():OverlayPanel(var0_249, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_248 then
			arg3_248(var0_248)
		end

		var0_249:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_250)
			arg0_248.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_249, arg0_248._tf)

			if arg2_248 then
				arg2_248(var0_248)
			end

			arg0_248:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_248 then
		PoolMgr.GetInstance():GetUI(arg1_248, true, function(arg0_251)
			arg0_251:SetActive(true)

			arg0_248.uiAnims[arg1_248] = arg0_251
			var0_248 = arg0_248.uiAnims[arg1_248]

			var1_248()
		end)
	else
		var1_248()
	end
end

function var0_0.destroyUIAnims(arg0_252)
	if arg0_252.uiAnims then
		for iter0_252, iter1_252 in pairs(arg0_252.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_252), arg0_252._tf)
			iter1_252:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_252, iter1_252)
		end

		arg0_252.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_253, arg1_253)
	local function var0_253()
		arg0_253.playing = true

		arg0_253:frozen()
		arg0_253.torpetoAni:SetActive(true)

		local var0_254 = tf(arg0_253.torpetoAni)

		var0_254:SetParent(arg0_253.topPanel, false)
		var0_254:SetAsLastSibling()
		var0_254:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_255)
			arg0_253.playing = false

			SetActive(arg0_253.torpetoAni, false)

			if arg1_253 then
				arg1_253()
			end

			arg0_253:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_253.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_256)
			arg0_256:SetActive(true)

			arg0_253.torpetoAni = arg0_256

			var0_253()
		end)
	else
		var0_253()
	end
end

function var0_0.destroyTorpedo(arg0_257)
	if arg0_257.torpetoAni then
		arg0_257.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_257.torpetoAni)

		arg0_257.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_258, arg1_258, arg2_258, arg3_258)
	arg0_258.strikeAnims = arg0_258.strikeAnims or {}

	local var0_258
	local var1_258
	local var2_258

	local function var3_258()
		if coroutine.status(var2_258) == "suspended" then
			local var0_259, var1_259 = coroutine.resume(var2_258)

			assert(var0_259, debug.traceback(var2_258, var1_259))
		end
	end

	var2_258 = coroutine.create(function()
		arg0_258.playing = true

		arg0_258:frozen()

		local var0_260 = arg0_258.strikeAnims[arg2_258]

		setActive(var0_260, true)

		local var1_260 = tf(var0_260)
		local var2_260 = findTF(var1_260, "torpedo")
		local var3_260 = findTF(var1_260, "mask/painting")
		local var4_260 = findTF(var1_260, "ship")

		setParent(var0_258, var3_260:Find("fitter"), false)
		setParent(var1_258, var4_260, false)
		setActive(var4_260, false)
		setActive(var2_260, false)
		var1_260:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_260:SetAsLastSibling()

		local var5_260 = var1_260:GetComponent("DftAniEvent")
		local var6_260 = var1_258:GetComponent("SpineAnimUI")
		local var7_260 = var6_260:GetComponent("SkeletonGraphic")

		var5_260:SetStartEvent(function(arg0_261)
			var6_260:SetAction("attack", 0)

			var7_260.freeze = true
		end)
		var5_260:SetTriggerEvent(function(arg0_262)
			var7_260.freeze = false

			var6_260:SetActionCallBack(function(arg0_263)
				if arg0_263 == "action" then
					-- block empty
				elseif arg0_263 == "finish" then
					var7_260.freeze = true
				end
			end)
		end)
		var5_260:SetEndEvent(function(arg0_264)
			var7_260.freeze = false

			var3_258()
		end)
		onButton(arg0_258, var1_260, var3_258, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_260, arg1_258:getPainting())
		var6_260:SetActionCallBack(nil)

		var7_260.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_258:getPrefab(), var1_258)
		setActive(var0_260, false)

		arg0_258.playing = false

		arg0_258:unfrozen()

		if arg3_258 then
			arg3_258()
		end
	end)

	local function var4_258()
		if arg0_258.strikeAnims[arg2_258] and var0_258 and var1_258 then
			var3_258()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_258:getPainting(), true, function(arg0_266)
		var0_258 = arg0_266

		ShipExpressionHelper.SetExpression(var0_258, arg1_258:getPainting())
		var4_258()
	end)
	PoolMgr.GetInstance():GetSpineChar(arg1_258:getPrefab(), true, function(arg0_267)
		var1_258 = arg0_267
		var1_258.transform.localScale = Vector3.one

		var4_258()
	end)

	if not arg0_258.strikeAnims[arg2_258] then
		PoolMgr.GetInstance():GetUI(arg2_258, true, function(arg0_268)
			arg0_258.strikeAnims[arg2_258] = arg0_268

			var4_258()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_269)
	if arg0_269.strikeAnims then
		for iter0_269, iter1_269 in pairs(arg0_269.strikeAnims) do
			iter1_269:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_269, iter1_269)
		end

		arg0_269.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_270, arg1_270, arg2_270, arg3_270)
	arg0_270.strikeAnims = arg0_270.strikeAnims or {}

	local var0_270
	local var1_270

	local function var2_270()
		if coroutine.status(var1_270) == "suspended" then
			local var0_271, var1_271 = coroutine.resume(var1_270)

			assert(var0_271, debug.traceback(var1_270, var1_271))
		end
	end

	var1_270 = coroutine.create(function()
		arg0_270.playing = true

		arg0_270:frozen()

		local var0_272 = arg0_270.strikeAnims[arg2_270]

		setActive(var0_272, true)

		local var1_272 = tf(var0_272)
		local var2_272 = findTF(var1_272, "torpedo")
		local var3_272 = findTF(var1_272, "ship")

		setParent(var0_270, var3_272, false)
		setActive(var3_272, false)
		setActive(var2_272, false)
		var1_272:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_272:SetAsLastSibling()

		local var4_272 = var1_272:GetComponent("DftAniEvent")
		local var5_272 = var0_270:GetComponent("SpineAnimUI")
		local var6_272 = var5_272:GetComponent("SkeletonGraphic")

		var4_272:SetStartEvent(function(arg0_273)
			var5_272:SetAction("attack", 0)

			var6_272.freeze = true
		end)
		var4_272:SetTriggerEvent(function(arg0_274)
			var6_272.freeze = false

			var5_272:SetActionCallBack(function(arg0_275)
				if arg0_275 == "action" then
					-- block empty
				elseif arg0_275 == "finish" then
					var6_272.freeze = true
				end
			end)
		end)
		var4_272:SetEndEvent(function(arg0_276)
			var6_272.freeze = false

			var2_270()
		end)
		onButton(arg0_270, var1_272, var2_270, SFX_CANCEL)
		coroutine.yield()
		var5_272:SetActionCallBack(nil)

		var6_272.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_270:getPrefab(), var0_270)
		setActive(var0_272, false)

		arg0_270.playing = false

		arg0_270:unfrozen()

		if arg3_270 then
			arg3_270()
		end
	end)

	local function var3_270()
		if arg0_270.strikeAnims[arg2_270] and var0_270 then
			var2_270()
		end
	end

	PoolMgr.GetInstance():GetSpineChar(arg1_270:getPrefab(), true, function(arg0_278)
		var0_270 = arg0_278
		var0_270.transform.localScale = Vector3.one

		var3_270()
	end)

	if not arg0_270.strikeAnims[arg2_270] then
		PoolMgr.GetInstance():GetUI(arg2_270, true, function(arg0_279)
			arg0_270.strikeAnims[arg2_270] = arg0_279

			var3_270()
		end)
	end
end

function var0_0.doPlayCommander(arg0_280, arg1_280, arg2_280)
	arg0_280:frozen()
	setActive(arg0_280.commanderTinkle, true)

	local var0_280 = arg1_280:getSkills()

	setText(arg0_280.commanderTinkle:Find("name"), #var0_280 > 0 and var0_280[1]:getConfig("name") or "")
	setImageSprite(arg0_280.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_280:getConfig("painting"), ""))

	local var1_280 = arg0_280.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_280.alpha = 0

	local var2_280 = Vector2(248, 237)

	LeanTween.value(go(arg0_280.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_281)
		local var0_281 = arg0_280.commanderTinkle.localPosition

		var0_281.x = var2_280.x + -100 * (1 - arg0_281)
		arg0_280.commanderTinkle.localPosition = var0_281
		var1_280.alpha = arg0_281
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_280.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_282)
		local var0_282 = arg0_280.commanderTinkle.localPosition

		var0_282.x = var2_280.x + 100 * arg0_282
		arg0_280.commanderTinkle.localPosition = var0_282
		var1_280.alpha = 1 - arg0_282
	end)):setOnComplete(System.Action(function()
		if arg2_280 then
			arg2_280()
		end

		arg0_280:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_284, arg1_284, arg2_284, arg3_284)
	local var0_284 = arg0_284.grid:shakeCell(arg1_284)

	if not var0_284 then
		arg3_284()

		return
	end

	arg0_284:easeDamage(var0_284, arg2_284, function()
		arg3_284()
	end)
end

function var0_0.easeDamage(arg0_286, arg1_286, arg2_286, arg3_286)
	arg0_286:frozen()

	local var0_286 = arg0_286.levelCam:WorldToScreenPoint(arg1_286.position)
	local var1_286 = tf(arg0_286:GetDamageText())

	var1_286.position = arg0_286.uiCam:ScreenToWorldPoint(var0_286)

	local var2_286 = var1_286.localPosition

	var2_286.y = var2_286.y + 40
	var2_286.z = 0

	setText(var1_286, arg2_286)

	var1_286.localPosition = var2_286

	LeanTween.value(go(var1_286), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_287)
		local var0_287 = var1_286.localPosition

		var0_287.y = var2_286.y + 60 * arg0_287
		var1_286.localPosition = var0_287

		setTextAlpha(var1_286, 1 - arg0_287)
	end)):setOnComplete(System.Action(function()
		arg0_286:ReturnDamageText(var1_286)
		arg0_286:unfrozen()

		if arg3_286 then
			arg3_286()
		end
	end))
end

function var0_0.easeAvoid(arg0_289, arg1_289, arg2_289)
	arg0_289:frozen()

	local var0_289 = arg0_289.levelCam:WorldToScreenPoint(arg1_289)

	arg0_289.avoidText.position = arg0_289.uiCam:ScreenToWorldPoint(var0_289)

	local var1_289 = arg0_289.avoidText.localPosition

	var1_289.z = 0
	arg0_289.avoidText.localPosition = var1_289

	setActive(arg0_289.avoidText, true)

	local var2_289 = arg0_289.avoidText:Find("avoid")

	LeanTween.value(go(arg0_289.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_290)
		local var0_290 = arg0_289.avoidText.localPosition

		var0_290.y = var1_289.y + 100 * arg0_290
		arg0_289.avoidText.localPosition = var0_290

		setImageAlpha(arg0_289.avoidText, 1 - arg0_290)
		setImageAlpha(var2_289, 1 - arg0_290)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_289.avoidText, false)
		arg0_289:unfrozen()

		if arg2_289 then
			arg2_289()
		end
	end))
end

function var0_0.GetDamageText(arg0_292)
	local var0_292 = table.remove(arg0_292.damageTextPool)

	if not var0_292 then
		var0_292 = Instantiate(arg0_292.damageTextTemplate)

		local var1_292 = tf(arg0_292.damageTextTemplate):GetSiblingIndex()

		setParent(var0_292, tf(arg0_292.damageTextTemplate).parent)
		tf(var0_292):SetSiblingIndex(var1_292 + 1)
	end

	table.insert(arg0_292.damageTextActive, var0_292)
	setActive(var0_292, true)

	return var0_292
end

function var0_0.ReturnDamageText(arg0_293, arg1_293)
	assert(arg1_293)

	if not arg1_293 then
		return
	end

	arg1_293 = go(arg1_293)

	table.removebyvalue(arg0_293.damageTextActive, arg1_293)
	table.insert(arg0_293.damageTextPool, arg1_293)
	setActive(arg1_293, false)
end

function var0_0.resetLevelGrid(arg0_294)
	arg0_294.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_295, arg1_295)
	setActive(arg0_295.curtain, arg1_295)
end

function var0_0.frozen(arg0_296)
	local var0_296 = arg0_296.frozenCount

	arg0_296.frozenCount = arg0_296.frozenCount + 1
	arg0_296.canvasGroup.blocksRaycasts = arg0_296.frozenCount == 0

	if var0_296 == 0 and arg0_296.frozenCount ~= 0 then
		arg0_296:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_297, arg1_297)
	if arg0_297.exited then
		return
	end

	local var0_297 = arg0_297.frozenCount
	local var1_297 = arg1_297 == -1 and arg0_297.frozenCount or arg1_297 or 1

	arg0_297.frozenCount = arg0_297.frozenCount - var1_297
	arg0_297.canvasGroup.blocksRaycasts = arg0_297.frozenCount == 0

	if var0_297 ~= 0 and arg0_297.frozenCount == 0 then
		arg0_297:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_298)
	return arg0_298.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_299)
	arg0_299.levelCamIndices = math.max(arg0_299.levelCamIndices - 1, 0)

	if arg0_299.levelCamIndices == 0 then
		arg0_299.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.disableLevelCamera(arg0_300)
	arg0_300.levelCamIndices = arg0_300.levelCamIndices + 1

	if arg0_300.levelCamIndices > 0 then
		arg0_300.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.RecordTween(arg0_301, arg1_301, arg2_301)
	arg0_301.tweens[arg1_301] = arg2_301
end

function var0_0.DeleteTween(arg0_302, arg1_302)
	local var0_302 = arg0_302.tweens[arg1_302]

	if var0_302 then
		LeanTween.cancel(var0_302)

		arg0_302.tweens[arg1_302] = nil
	end
end

function var0_0.openCommanderPanel(arg0_303, arg1_303, arg2_303, arg3_303)
	local var0_303 = arg2_303.id

	arg0_303.levelCMDFormationView:setCallback(function(arg0_304)
		if not arg3_303 then
			if arg0_304.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_303:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_304.skill)
			elseif arg0_304.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_303.contextData.commanderSelected = {
					chapterId = var0_303,
					fleetId = arg1_303.id
				}

				arg0_303:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_304.pos, arg1_303.id, arg2_303)
				arg0_303:closeCommanderPanel()
			else
				arg0_303:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_304,
					fleetId = arg1_303.id,
					chapterId = var0_303
				}, arg2_303)
			end
		elseif arg0_304.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_303:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_304.skill)
		elseif arg0_304.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_303.contextData.eliteCommanderSelected = {
				index = arg3_303,
				pos = arg0_304.pos,
				chapterId = var0_303
			}

			arg0_303:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_303, arg0_304.pos, arg2_303)
			arg0_303:closeCommanderPanel()
		else
			arg0_303:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_304,
				index = arg3_303,
				chapterId = var0_303
			}, arg2_303)
		end
	end)
	arg0_303.levelCMDFormationView:Load()
	arg0_303.levelCMDFormationView:ActionInvoke("update", arg1_303, arg0_303.commanderPrefabs)
	arg0_303.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_305)
	if arg0_305.levelCMDFormationView:isShowing() then
		arg0_305.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_305.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_306)
	arg0_306.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_307)
	arg0_307.levelCMDFormationView:Destroy()

	arg0_307.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_308, arg1_308)
	arg0_308.spTickets = arg1_308
end

function var0_0.HandleShowMsgBox(arg0_309, arg1_309)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_309)
end

function var0_0.updatePoisonAreaTip(arg0_310)
	local var0_310 = arg0_310.contextData.chapterVO
	local var1_310 = (function(arg0_311)
		local var0_311 = {}
		local var1_311 = pg.map_event_list[var0_310.id] or {}
		local var2_311

		if var0_310:isLoop() then
			var2_311 = var1_311.event_list_loop or {}
		else
			var2_311 = var1_311.event_list or {}
		end

		for iter0_311, iter1_311 in ipairs(var2_311) do
			local var3_311 = pg.map_event_template[iter1_311]

			if var3_311.c_type == arg0_311 then
				table.insert(var0_311, var3_311)
			end
		end

		return var0_311
	end)(ChapterConst.EvtType_Poison)

	if var1_310 then
		for iter0_310, iter1_310 in ipairs(var1_310) do
			local var2_310 = iter1_310.round_gametip

			if var2_310 ~= nil and var2_310 ~= "" and var0_310:getRoundNum() == var2_310[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_310[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_312)
	setActive(arg0_312._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_313)
	local var0_313 = getProxy(ChapterProxy)

	if var0_313 and not arg0_313.contextData.noRecord then
		local var1_313 = arg0_313.contextData.map

		if not var1_313 then
			return
		end

		if var1_313:NeedRecordMap() then
			var0_313:recordLastMap(ChapterProxy.LAST_MAP, var1_313.id)
		end

		if var1_313:isActivity() and not var1_313:isActExtra() then
			var0_313:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_313.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_314)
	local var0_314 = pg.gameset.activity_res_id.key_value
	local var1_314 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var1_314 and not var1_314:isEnd() and var1_314:getConfig("config_client").resId == var0_314 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_315)
		return not arg0_315:isEnd() and arg0_315:getConfig("config_client").pt_id == var0_314
	end) then
		return true
	end
end

function var0_0.willExit(arg0_316)
	arg0_316:ClearMapTransitions()
	arg0_316.loader:Clear()

	if arg0_316.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_316.topPanel, arg0_316._tf)
		pg.playerResUI:SetActive({
			active = false
		})
	end

	if arg0_316.levelFleetView and arg0_316.levelFleetView.selectIds then
		arg0_316.contextData.selectedFleetIDs = {}

		for iter0_316, iter1_316 in pairs(arg0_316.levelFleetView.selectIds) do
			for iter2_316, iter3_316 in pairs(iter1_316) do
				arg0_316.contextData.selectedFleetIDs[#arg0_316.contextData.selectedFleetIDs + 1] = iter3_316
			end
		end
	end

	arg0_316:destroyChapterPanel()
	arg0_316:DestroyLevelInfoSPPanel()
	arg0_316:destroyFleetEdit()
	arg0_316:destroyCommanderPanel()
	arg0_316:DestroyLevelStageView()
	arg0_316:hideRepairWindow()
	arg0_316:hideStrategyInfo()
	arg0_316:hideRemasterPanel()
	arg0_316:hideSpResult()
	arg0_316:destroyGrid()
	arg0_316:destroyAmbushWarn()
	arg0_316:destroyAirStrike()
	arg0_316:destroyTorpedo()
	arg0_316:destroyStrikeAnim()
	arg0_316:destroyTracking()
	arg0_316:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_316, iter5_316 in pairs(arg0_316.mbDict) do
		iter5_316:Destroy()
	end

	arg0_316.mbDict = nil

	for iter6_316, iter7_316 in pairs(arg0_316.tweens) do
		LeanTween.cancel(iter7_316)
	end

	arg0_316.tweens = nil

	if arg0_316.cloudTimer then
		_.each(arg0_316.cloudTimer, function(arg0_317)
			LeanTween.cancel(arg0_317)
		end)

		arg0_316.cloudTimer = nil
	end

	if arg0_316.newChapterCDTimer then
		arg0_316.newChapterCDTimer:Stop()

		arg0_316.newChapterCDTimer = nil
	end

	for iter8_316, iter9_316 in ipairs(arg0_316.damageTextActive) do
		LeanTween.cancel(iter9_316)
	end

	LeanTween.cancel(go(arg0_316.avoidText))

	arg0_316.map.localScale = Vector3.one
	arg0_316.map.pivot = Vector2(0.5, 0.5)
	arg0_316.float.localScale = Vector3.one
	arg0_316.float.pivot = Vector2(0.5, 0.5)

	for iter10_316, iter11_316 in ipairs(arg0_316.mapTFs) do
		clearImageSprite(iter11_316)
	end

	_.each(arg0_316.cloudRTFs, function(arg0_318)
		clearImageSprite(arg0_318)
	end)
	Destroy(arg0_316.enemyTpl)
	arg0_316:RecordLastMapOnExit()
	arg0_316.levelRemasterView:Destroy()
end

return var0_0
