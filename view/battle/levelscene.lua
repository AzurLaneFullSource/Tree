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

	local var1_12 = arg0_12.UIFXList:GetComponentsInChildren(typeof(Renderer))

	for iter2_12 = 0, var1_12.Length - 1 do
		var1_12[iter2_12].sortingOrder = -1
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

		local var0_53, var1_53 = arg0_36:checkChallengeOpen()

		if var0_53 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_53)
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

function var0_0.checkChallengeOpen(arg0_57)
	local var0_57 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_57, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_58)
	if arg0_58.contextData.map and arg0_58.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_58)
end

function var0_0.onBackPressed(arg0_59)
	if arg0_59:isfrozen() then
		return
	end

	if arg0_59.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_59.levelInfoView:isShowing() then
		arg0_59:hideChapterPanel()

		return
	end

	if arg0_59.levelInfoSPView and arg0_59.levelInfoSPView:isShowing() then
		arg0_59:HideLevelInfoSPPanel()

		return
	end

	if arg0_59.levelFleetView:isShowing() then
		arg0_59:hideFleetEdit()

		return
	end

	if arg0_59.levelStrategyView then
		arg0_59:hideStrategyInfo()

		return
	end

	if arg0_59.levelRepairView then
		arg0_59:hideRepairWindow()

		return
	end

	if arg0_59.levelRemasterView:isShowing() then
		arg0_59:hideRemasterPanel()

		return
	end

	if isActive(arg0_59.helpPage) then
		setActive(arg0_59.helpPage, false)

		return
	end

	local var0_59 = arg0_59.contextData.chapterVO
	local var1_59 = getProxy(ChapterProxy):getActiveChapter()

	if var0_59 and var1_59 then
		arg0_59:switchToMap()

		return
	end

	triggerButton(arg0_59:findTF("back_button", arg0_59.topChapter))
end

function var0_0.ShowEntranceUI(arg0_60, arg1_60)
	setActive(arg0_60.entranceLayer, arg1_60)
	setActive(arg0_60.entranceBg, arg1_60)
	setActive(arg0_60.map, not arg1_60)
	setActive(arg0_60.float, not arg1_60)
	setActive(arg0_60.mainLayer, not arg1_60)
	setActive(arg0_60.topChapter:Find("type_entrance"), arg1_60)

	arg0_60.contextData.entranceStatus = tobool(arg1_60)

	if arg1_60 then
		setActive(arg0_60.topChapter:Find("title_chapter"), false)
		setActive(arg0_60.topChapter:Find("type_chapter"), false)
		setActive(arg0_60.topChapter:Find("type_escort"), false)
		setActive(arg0_60.topChapter:Find("type_skirmish"), false)

		if arg0_60.newChapterCDTimer then
			arg0_60.newChapterCDTimer:Stop()

			arg0_60.newChapterCDTimer = nil
		end

		arg0_60:RecordLastMapOnExit()

		arg0_60.contextData.mapIdx = nil
		arg0_60.contextData.map = nil
	end

	arg0_60:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_61, arg1_61, arg2_61)
	if arg0_61.preloadLevelDone then
		existCall(arg2_61)

		return
	end

	local var0_61

	local function var1_61()
		if not arg0_61.exited then
			arg0_61.preloadLevelDone = true

			existCall(arg2_61)
		end
	end

	local var2_61 = getProxy(ChapterProxy):getMapById(arg1_61)
	local var3_61 = arg0_61:GetMapBG(var2_61)

	table.ParallelIpairsAsync(var3_61, function(arg0_63, arg1_63, arg2_63)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_63.BG, "", arg2_63)
	end, var1_61)
end

function var0_0.setShips(arg0_64, arg1_64)
	arg0_64.shipVOs = arg1_64
end

function var0_0.updateRes(arg0_65, arg1_65)
	if arg0_65.levelStageView then
		arg0_65.levelStageView:ActionInvoke("SetPlayer", arg1_65)
	end

	arg0_65.player = arg1_65
end

function var0_0.setEliteQuota(arg0_66, arg1_66, arg2_66)
	local var0_66 = arg2_66 - arg1_66
	local var1_66 = arg0_66:findTF("bg/Text", arg0_66.eliteQuota):GetComponent(typeof(Text))

	if arg1_66 == arg2_66 then
		var1_66.color = Color.red
	else
		var1_66.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_66.text = var0_66 .. "/" .. arg2_66
end

function var0_0.updateEvent(arg0_67, arg1_67)
	local var0_67 = arg1_67:hasFinishState()

	setActive(arg0_67.btnSpecial:Find("tip"), var0_67)
	setActive(arg0_67.entranceLayer:Find("btns/btn_task/tip"), var0_67)
end

function var0_0.updateFleet(arg0_68, arg1_68)
	arg0_68.fleets = arg1_68
end

function var0_0.updateChapterVO(arg0_69, arg1_69, arg2_69)
	if arg0_69.contextData.chapterVO and arg0_69.contextData.chapterVO.id == arg1_69.id and arg1_69.active then
		arg0_69:setChapter(arg1_69)
	end

	if arg0_69.contextData.chapterVO and arg0_69.contextData.chapterVO.id == arg1_69.id and arg1_69.active and arg0_69.levelStageView and arg0_69.grid then
		local var0_69 = false
		local var1_69 = false
		local var2_69 = false

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyFleet) > 0 then
			arg0_69.levelStageView:updateStageFleet()
			arg0_69.levelStageView:updateAmbushRate(arg1_69.fleet.line, true)

			var2_69 = true

			if arg0_69.grid then
				arg0_69.grid:RefreshFleetCells()
				arg0_69.grid:UpdateFloor()

				var0_69 = true
			end
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyChampion) > 0 then
			var2_69 = true

			if arg0_69.grid then
				arg0_69.grid:UpdateFleets()
				arg0_69.grid:clearChampions()
				arg0_69.grid:initChampions()

				var1_69 = true
			end
		elseif bit.band(arg2_69, ChapterConst.DirtyChampionPosition) > 0 then
			var2_69 = true

			if arg0_69.grid then
				arg0_69.grid:UpdateFleets()
				arg0_69.grid:updateChampions()

				var1_69 = true
			end
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyAchieve) > 0 then
			arg0_69.levelStageView:updateStageAchieve()
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyAttachment) > 0 then
			arg0_69.levelStageView:updateAmbushRate(arg1_69.fleet.line, true)

			if arg0_69.grid then
				if not (arg2_69 < 0) and not (bit.band(arg2_69, ChapterConst.DirtyFleet) > 0) then
					arg0_69.grid:updateFleet(arg1_69.fleets[arg1_69.findex].id)
				end

				arg0_69.grid:updateAttachments()

				if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyAutoAction) > 0 then
					arg0_69.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_69 = true
				end
			end
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyStrategy) > 0 then
			arg0_69.levelStageView:updateStageStrategy()

			var2_69 = true

			arg0_69.levelStageView:updateStageBarrier()
			arg0_69.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_69 then
			arg0_69.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_69 then
			arg0_69.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyCellFlag) > 0 then
			arg0_69.grid:UpdateFloor()
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyBase) > 0 then
			arg0_69.levelStageView:UpdateDefenseStatus()
		end

		if arg2_69 < 0 or bit.band(arg2_69, ChapterConst.DirtyFloatItems) > 0 then
			arg0_69.grid:UpdateItemCells()
		end

		if var2_69 then
			arg0_69.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_70)
	arg0_70.cloudRTFs = {}
	arg0_70.cloudRects = {}
	arg0_70.cloudTimer = {}

	for iter0_70 = 1, 6 do
		local var0_70 = arg0_70:findTF("cloud_" .. iter0_70, arg0_70.clouds)
		local var1_70 = rtf(var0_70)

		table.insert(arg0_70.cloudRTFs, var1_70)
		table.insert(arg0_70.cloudRects, var1_70.rect.width)
	end

	arg0_70:initCloudsPos()

	for iter1_70, iter2_70 in ipairs(arg0_70.cloudRTFs) do
		local var2_70 = arg0_70.cloudRects[iter1_70]
		local var3_70 = arg0_70.initPositions[iter1_70] or Vector2(0, 0)
		local var4_70 = 30 - var3_70.y / 20
		local var5_70 = (arg0_70.mapWidth + var2_70) / var4_70
		local var6_70

		var6_70 = LeanTween.moveX(iter2_70, arg0_70.mapWidth, var5_70):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_70 = arg0_70.cloudRects[iter1_70]
			iter2_70.anchoredPosition = Vector2(-var2_70, var3_70.y)

			var6_70:setFrom(-var2_70):setTime((arg0_70.mapWidth + var2_70) / var4_70)
		end))
		var6_70.passed = math.random() * var5_70
		arg0_70.cloudTimer[iter1_70] = var6_70.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_72)
	arg0_72:PlayBGM()
	arg0_72:SwitchMapBG(arg0_72.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_73, arg1_73, arg2_73)
	if not arg1_73 then
		return
	end

	local var0_73 = arg0_73.contextData.map:getConfig("ani_controller")

	local function var1_73(arg0_74)
		arg0_74 = tf(arg0_74)

		local var0_74 = Vector3.one

		if arg0_74.rect.width > 0 and arg0_74.rect.height > 0 then
			var0_74.x = arg0_74.parent.rect.width / arg0_74.rect.width
			var0_74.y = arg0_74.parent.rect.height / arg0_74.rect.height
		end

		arg0_74.localScale = var0_74

		if var0_73 and #var0_73 > 0 then
			(function()
				for iter0_75, iter1_75 in ipairs(var0_73) do
					if iter1_75[1] == var2_0 then
						local var0_75 = iter1_75[2][1]
						local var1_75 = _.rest(iter1_75[2], 2)

						for iter2_75, iter3_75 in ipairs(var1_75) do
							local var2_75 = arg0_74:Find(iter3_75)

							if not IsNil(var2_75) then
								local var3_75 = getProxy(ChapterProxy):GetChapterItemById(var0_75)

								if var3_75 and not var3_75:isClear() then
									setActive(var2_75, false)
								end
							end
						end
					elseif iter1_75[1] == var3_0 then
						local var4_75 = iter1_75[2][1]
						local var5_75 = _.rest(iter1_75[2], 2)

						for iter4_75, iter5_75 in ipairs(var5_75) do
							local var6_75 = arg0_74:Find(iter5_75)

							if not IsNil(var6_75) then
								local var7_75 = getProxy(ChapterProxy):GetChapterItemById(var4_75)

								if var7_75 and not var7_75:isClear() then
									setActive(var6_75, true)

									return
								end
							end
						end
					elseif iter1_75[1] == var4_0 then
						local var8_75 = iter1_75[2][1]
						local var9_75 = _.rest(iter1_75[2], 2)

						for iter6_75, iter7_75 in ipairs(var9_75) do
							local var10_75 = arg0_74:Find(iter7_75)

							if not IsNil(var10_75) then
								local var11_75 = getProxy(ChapterProxy):GetChapterItemById(var8_75)

								if var11_75 and not var11_75:isClear() then
									setActive(var10_75, true)
								end
							end
						end
					end
				end
			end)()
		end
	end

	local var2_73 = arg0_73.loader:GetPrefab("ui/" .. arg1_73, arg1_73, function(arg0_76)
		arg0_76:SetActive(true)

		local var0_76 = arg0_73.mapTFs[arg2_73]

		setParent(arg0_76, var0_76)
		pg.ViewUtils.SetSortingOrder(arg0_76, ChapterConst.LayerWeightMap + arg2_73 * 2 - 1)
		var1_73(arg0_76)
	end)

	table.insert(arg0_73.mapGroup, var2_73)
end

function var0_0.HideBtns(arg0_77)
	setActive(arg0_77.btnPrev, false)
	setActive(arg0_77.eliteQuota, false)
	setActive(arg0_77.escortBar, false)
	setActive(arg0_77.skirmishBar, false)
	setActive(arg0_77.normalBtn, false)
	setActive(arg0_77.actNormalBtn, false)
	setActive(arg0_77.eliteBtn, false)
	setActive(arg0_77.actEliteBtn, false)
	setActive(arg0_77.actExtraBtn, false)
	setActive(arg0_77.remasterBtn, false)
	setActive(arg0_77.btnNext, false)
	setActive(arg0_77.remasterAwardBtn, false)
	setActive(arg0_77.eventContainer, false)
	setActive(arg0_77.activityBtn, false)
	setActive(arg0_77.ptTotal, false)
	setActive(arg0_77.ticketTxt.parent, false)
	setActive(arg0_77.countDown, false)
	setActive(arg0_77.actAtelierBuffBtn, false)
	setActive(arg0_77.actExtraRank, false)
	setActive(arg0_77.actExchangeShopBtn, false)
	setActive(arg0_77.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_78)
	local var0_78 = arg0_78.contextData.map:getConfig("type")

	setActive(arg0_78.normalBtn, var0_78 == Map.ELITE)
	setActive(arg0_78.eliteQuota, var0_78 == Map.ELITE)
	setActive(arg0_78.eliteBtn, var0_78 == Map.SCENARIO)

	local var1_78 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_78.eliteBtn:Find("pic_activity"), var1_78 and not var1_78:isEnd())
end

function var0_0.updateActivityBtns(arg0_79)
	local var0_79 = arg0_79.contextData.map
	local var1_79, var2_79 = var0_79:isActivity()
	local var3_79 = var0_79:isRemaster()
	local var4_79 = var0_79:isSkirmish()
	local var5_79 = var0_79:isEscort()
	local var6_79 = var0_79:getConfig("type")
	local var7_79 = getProxy(ActivityProxy)
	local var8_79 = underscore(var7_79:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)):chain():select(function(arg0_80)
		return not arg0_80:isEnd()
	end):sort(function(arg0_81, arg1_81)
		return arg0_81.id < arg1_81.id
	end):value()[1] and not var1_79 and not var4_79 and not var5_79

	if var8_79 then
		local var9_79 = setmetatable({}, MainActMapBtn)

		var9_79.image = arg0_79.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var9_79.subImage = arg0_79.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var9_79.tipTr = arg0_79.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var9_79.tipTxt = arg0_79.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_79 = var9_79:InShowTime()

		if var8_79 then
			var9_79:InitTipImage()
			var9_79:InitSubImage()
			var9_79:InitImage(function()
				return
			end)
			var9_79:OnInit()
		end
	end

	setActive(arg0_79.activityBtn, var8_79)
	arg0_79:updateRemasterInfo()

	if var1_79 and var2_79 then
		local var10_79

		if var0_79:isRemaster() then
			var10_79 = getProxy(ChapterProxy):getRemasterMaps(var0_79.remasterId)
		else
			var10_79 = getProxy(ChapterProxy):getMapsByActivities()
		end

		local var11_79 = underscore.any(var10_79, function(arg0_83)
			return arg0_83:isActExtra()
		end)

		setActive(arg0_79.actExtraBtn, var11_79 and var6_79 ~= Map.ACT_EXTRA)

		if isActive(arg0_79.actExtraBtn) then
			if underscore.all(underscore.filter(var10_79, function(arg0_84)
				local var0_84 = arg0_84:getMapType()

				return var0_84 == Map.ACTIVITY_EASY or var0_84 == Map.ACTIVITY_HARD
			end), function(arg0_85)
				return arg0_85:isAllChaptersClear()
			end) then
				setActive(arg0_79.actExtraBtnAnim, true)
			else
				setActive(arg0_79.actExtraBtnAnim, false)
			end

			setActive(arg0_79.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var12_79 = checkExist(var0_79:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_79.actEliteBtn, var12_79 and var6_79 ~= Map.ACTIVITY_HARD)
		setActive(arg0_79.actNormalBtn, var6_79 ~= Map.ACTIVITY_EASY)
		setActive(arg0_79.actExtraRank, var6_79 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_86)
			if not arg0_86 or arg0_86:isEnd() then
				return
			end

			local var0_86 = arg0_86:getConfig("config_data")[1]

			return _.any(var0_79:getChapters(), function(arg0_87)
				return arg0_87:IsEXChapter() and arg0_87:getConfig("boss_expedition_id") == var0_86
			end)
		end))
		setActive(arg0_79.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_79 and var2_79 and arg0_79:IsActShopActive())
		setActive(arg0_79.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_79 and var2_79 and arg0_79.ptActivity and not arg0_79.ptActivity:isEnd())
		arg0_79:updateActivityRes()
	else
		setActive(arg0_79.actExtraBtn, false)
		setActive(arg0_79.actEliteBtn, false)
		setActive(arg0_79.actNormalBtn, false)
		setActive(arg0_79.actExtraRank, false)
		setActive(arg0_79.actExchangeShopBtn, false)
		setActive(arg0_79.actAtelierBuffBtn, false)
		setActive(arg0_79.ptTotal, false)
	end

	setActive(arg0_79.eventContainer, (not var1_79 or not var2_79) and not var5_79)
	setActive(arg0_79.remasterBtn, OPEN_REMASTER and (var3_79 or not var1_79 and not var5_79 and not var4_79))
	setActive(arg0_79.ticketTxt.parent, var3_79)
	arg0_79:updateRemasterTicket()
	arg0_79:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_88)
	setText(arg0_88.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_88:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_89)
	local var0_89 = getProxy(ChapterProxy)
	local var1_89 = var0_89:ifShowRemasterTip() or var0_89:anyRemasterAwardCanReceive()

	SetActive(arg0_89.remasterBtn:Find("tip"), var1_89)
	SetActive(arg0_89.entranceLayer:Find("btns/btn_remaster/tip"), var1_89)
end

function var0_0.updatDailyBtnTip(arg0_90)
	local var0_90 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_90.dailyBtn:Find("tip"), var0_90)
	SetActive(arg0_90.entranceLayer:Find("btns/btn_daily/tip"), var0_90)
end

function var0_0.updateRemasterInfo(arg0_91)
	arg0_91:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_91.contextData.map then
		return
	end

	local var0_91 = getProxy(ChapterProxy)
	local var1_91
	local var2_91 = arg0_91.contextData.map:getRemaster()

	if var2_91 and #pg.re_map_template[var2_91].drop_gain > 0 then
		for iter0_91, iter1_91 in ipairs(pg.re_map_template[var2_91].drop_gain) do
			if #iter1_91 > 0 and var0_91.remasterInfo[iter1_91[1]][iter0_91].receive == false then
				var1_91 = {
					iter0_91,
					iter1_91
				}

				break
			end
		end
	end

	setActive(arg0_91.remasterAwardBtn, var1_91)

	if var1_91 then
		local var3_91 = var1_91[1]
		local var4_91, var5_91, var6_91, var7_91 = unpack(var1_91[2])
		local var8_91 = var0_91.remasterInfo[var4_91][var3_91]

		setText(arg0_91.remasterAwardBtn:Find("Text"), var8_91.count .. "/" .. var7_91)
		updateDrop(arg0_91.remasterAwardBtn:Find("IconTpl"), {
			type = var5_91,
			id = var6_91
		})
		setActive(arg0_91.remasterAwardBtn:Find("tip"), var7_91 <= var8_91.count)
		onButton(arg0_91, arg0_91.remasterAwardBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_91,
					id = var6_91
				},
				weight = LayerWeightConst.TOP_LAYER,
				remaster = {
					word = i18n("level_remaster_tip4", pg.chapter_template[var4_91].chapter_name),
					number = var8_91.count .. "/" .. var7_91,
					btn_text = i18n(var8_91.count < var7_91 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var8_91.count < var7_91 then
							local var0_93 = pg.chapter_template[var4_91].map
							local var1_93, var2_93 = var0_91:getMapById(var0_93):isUnlock()

							if not var1_93 then
								pg.TipsMgr.GetInstance():ShowTips(var2_93)
							else
								arg0_91:ShowSelectedMap(var0_93)
							end
						else
							arg0_91:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_91, var3_91)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_94)
	local var0_94 = getProxy(ChapterProxy)

	if arg0_94.newChapterCDTimer then
		arg0_94.newChapterCDTimer:Stop()

		arg0_94.newChapterCDTimer = nil
	end

	local var1_94 = 0

	if arg0_94.contextData.map:isActivity() and not arg0_94.contextData.map:isRemaster() then
		local var2_94 = var0_94:getMapsByActivities()

		_.each(var2_94, function(arg0_95)
			local var0_95 = arg0_95:getChapterTimeLimit()

			if var1_94 == 0 then
				var1_94 = var0_95
			else
				var1_94 = math.min(var1_94, var0_95)
			end
		end)
		setActive(arg0_94.countDown, var1_94 > 0)
		setText(arg0_94.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_94.countDown, false)
	end

	if var1_94 > 0 then
		setText(arg0_94.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_94))

		arg0_94.newChapterCDTimer = Timer.New(function()
			var1_94 = var1_94 - 1

			if var1_94 <= 0 then
				arg0_94:updateCountDown()

				if not arg0_94.contextData.chapterVO then
					arg0_94:setMap(arg0_94.contextData.mapIdx)
				end
			else
				setText(arg0_94.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_94))
			end
		end, 1, -1)

		arg0_94.newChapterCDTimer:Start()
	else
		setText(arg0_94.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_97)
	onButton(arg0_97, arg0_97.actExtraRank, function()
		if arg0_97:isfrozen() then
			return
		end

		arg0_97:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_97, arg0_97.activityBtn, function()
		if arg0_97:isfrozen() then
			return
		end

		arg0_97:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_97, arg0_97.actExchangeShopBtn, function()
		if arg0_97:isfrozen() then
			return
		end

		arg0_97:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_97, arg0_97.actAtelierBuffBtn, function()
		if arg0_97:isfrozen() then
			return
		end

		arg0_97:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)

	local var0_97 = getProxy(ChapterProxy)

	local function var1_97(arg0_102, arg1_102, arg2_102)
		local var0_102

		if arg0_102:isRemaster() then
			var0_102 = var0_97:getRemasterMaps(arg0_102.remasterId)
		else
			var0_102 = var0_97:getMapsByActivities()
		end

		local var1_102 = _.select(var0_102, function(arg0_103)
			return arg0_103:getMapType() == arg1_102
		end)

		table.sort(var1_102, function(arg0_104, arg1_104)
			return arg0_104.id < arg1_104.id
		end)

		local var2_102 = table.indexof(underscore.map(var1_102, function(arg0_105)
			return arg0_105.id
		end), arg2_102) or #var1_102

		while not var1_102[var2_102]:isUnlock() do
			if var2_102 > 1 then
				var2_102 = var2_102 - 1
			else
				break
			end
		end

		return var1_102[var2_102]
	end

	arg0_97:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_106, arg1_106, arg2_106)
		arg2_106 = arg2_106 or switch(arg1_106, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_97.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_97.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_106 = var1_97(arg0_97.contextData.map, arg1_106, arg2_106)
		local var1_106, var2_106 = var0_106:isUnlock()

		if var1_106 then
			arg0_97:setMap(var0_106.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_106)
		end
	end)
	onButton(arg0_97, arg0_97.actNormalBtn, function()
		if arg0_97:isfrozen() then
			return
		end

		arg0_97:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_97, arg0_97.actEliteBtn, function()
		if arg0_97:isfrozen() then
			return
		end

		arg0_97:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_97, arg0_97.actExtraBtn, function()
		if arg0_97:isfrozen() then
			return
		end

		arg0_97:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_113, arg1_113)
	arg0_113.initPositions = {}

	local var0_113 = arg1_113 or 1
	local var1_113 = pg.expedition_data_by_map[var0_113].clouds_pos

	for iter0_113, iter1_113 in ipairs(arg0_113.cloudRTFs) do
		local var2_113 = var1_113[iter0_113]

		if var2_113 then
			iter1_113.anchoredPosition = Vector2(var2_113[1], var2_113[2])

			table.insert(arg0_113.initPositions, iter1_113.anchoredPosition)
		else
			setActive(iter1_113, false)
		end
	end
end

function var0_0.initMapBtn(arg0_114, arg1_114, arg2_114)
	onButton(arg0_114, arg1_114, function()
		if arg0_114:isfrozen() then
			return
		end

		local var0_115 = arg0_114.contextData.mapIdx + arg2_114
		local var1_115 = getProxy(ChapterProxy):getMapById(var0_115)

		if not var1_115 then
			return
		end

		if var1_115:getMapType() == Map.ELITE and not var1_115:isEliteEnabled() then
			var1_115 = var1_115:getBindMap()
			var0_115 = var1_115.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_115, var3_115 = var1_115:isUnlock()

		if arg2_114 > 0 and not var2_115 then
			pg.TipsMgr.GetInstance():ShowTips(var3_115)

			return
		end

		arg0_114:setMap(var0_115)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_116, arg1_116, arg2_116)
	seriesAsync({
		function(arg0_117)
			if arg0_116.contextData.entranceStatus then
				arg0_116:frozen()

				arg0_116.nextPreloadMap = arg1_116

				arg0_116:PreloadLevelMainUI(arg1_116, function()
					arg0_116:unfrozen()

					if arg0_116.nextPreloadMap ~= arg1_116 then
						return
					end

					arg0_116:ShowEntranceUI(false)
					arg0_116:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_116)
					arg0_117()
				end)
			else
				arg0_116:setMap(arg1_116)
				arg0_117()
			end
		end
	}, arg2_116)
end

function var0_0.setMap(arg0_119, arg1_119)
	local var0_119 = arg0_119.contextData.mapIdx

	arg0_119.contextData.mapIdx = arg1_119
	arg0_119.contextData.map = getProxy(ChapterProxy):getMapById(arg1_119)

	assert(arg0_119.contextData.map, "map cannot be nil " .. arg1_119)

	if arg0_119.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_119.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_119.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_119.contextData.map.remasterId, arg1_119)
		PlayerPrefs.Save()
	end

	arg0_119:RecordLastMapOnExit()
	arg0_119:updateMap(var0_119)
	arg0_119:tryPlayMapStory()
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

function var0_0.SwitchMapBuilder(arg0_120, arg1_120)
	if arg0_120.mapBuilder and arg0_120.mapBuilder:GetType() ~= arg1_120 then
		arg0_120.mapBuilder.buffer:Hide()
	end

	local var0_120 = arg0_120:GetMapBuilderInBuffer(arg1_120)

	arg0_120.mapBuilder = var0_120

	var0_120.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_121, arg1_121)
	if not arg0_121.mbDict[arg1_121] then
		local var0_121 = _G[var6_0[arg1_121]]

		assert(var0_121, "Missing MapBuilder of type " .. (arg1_121 or "NIL"))

		arg0_121.mbDict[arg1_121] = var0_121.New(arg0_121._tf, arg0_121)
		arg0_121.mbDict[arg1_121].isFrozen = arg0_121:isfrozen()

		arg0_121.mbDict[arg1_121]:Load()
	end

	return arg0_121.mbDict[arg1_121]
end

function var0_0.updateMap(arg0_122, arg1_122)
	local var0_122 = arg0_122.contextData.map
	local var1_122 = var0_122:getConfig("anchor")
	local var2_122

	if var1_122 == "" then
		var2_122 = Vector2.zero
	else
		var2_122 = Vector2(unpack(var1_122))
	end

	arg0_122.map.pivot = var2_122

	local var3_122 = var0_122:getConfig("uifx")

	for iter0_122 = 1, arg0_122.UIFXList.childCount do
		local var4_122 = arg0_122.UIFXList:GetChild(iter0_122 - 1)

		setActive(var4_122, var4_122.name == var3_122)
	end

	arg0_122:SwitchMapBG(var0_122, arg1_122)
	arg0_122:PlayBGM()

	local var5_122 = arg0_122.contextData.map:getConfig("ui_type")

	arg0_122:SwitchMapBuilder(var5_122)
	seriesAsync({
		function(arg0_123)
			arg0_122.mapBuilder:CallbackInvoke(arg0_123)
		end,
		function(arg0_124)
			arg0_122.mapBuilder:UpdateMapVO(var0_122)
			arg0_122.mapBuilder:UpdateView()
			arg0_122.mapBuilder:UpdateMapItems()
			arg0_122.mapBuilder:PlayEnterAnim()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_125)
	local var0_125 = arg0_125.contextData.map
	local var1_125 = getProxy(ChapterProxy)
	local var2_125 = var1_125:getMapById(var0_125.id - 1)
	local var3_125 = var1_125:getMapById(var0_125.id + 1)

	setActive(arg0_125.btnPrev, tobool(var2_125))
	setActive(arg0_125.btnNext, tobool(var3_125))

	local var4_125 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_125.btnPrevCol, var2_125 and Color.white or var4_125)
	setImageColor(arg0_125.btnNextCol, var3_125 and var3_125:isUnlock() and Color.white or var4_125)
end

function var0_0.tryPlayMapStory(arg0_126)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_127)
			local var0_127 = arg0_126.contextData.map:getConfig("enter_story")

			if var0_127 and var0_127 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_127) and not arg0_126.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_127 = tonumber(var0_127)

				if var1_127 and var1_127 > 0 then
					arg0_126:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_127)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_127, arg0_127)
				end

				return
			end

			arg0_127()
		end,
		function(arg0_128)
			local var0_128 = arg0_126.contextData.map:getConfig("guide_id")

			if var0_128 and var0_128 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_128, nil, arg0_128)

				return
			end

			arg0_128()
		end,
		function(arg0_129)
			if isActive(arg0_126.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_129 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_129

				if var0_129 then
					var1_129 = {
						1,
						2
					}
				else
					var1_129 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_129)
			else
				arg0_129()
			end
		end,
		function(arg0_130)
			if arg0_126.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_126.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_131, arg1_131, arg2_131, arg3_131)
	arg0_131.uiAnims = arg0_131.uiAnims or {}

	local var0_131 = arg0_131.uiAnims[arg1_131]

	local function var1_131()
		arg0_131.playing = true

		arg0_131:frozen()
		var0_131:SetActive(true)

		local var0_132 = tf(var0_131)

		pg.UIMgr.GetInstance():OverlayPanel(var0_132, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_131 then
			arg3_131(var0_131)
		end

		var0_132:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_133)
			arg0_131.playing = false

			if arg2_131 then
				arg2_131(var0_131)
			end

			arg0_131:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_131 then
		PoolMgr.GetInstance():GetUI(arg1_131, true, function(arg0_134)
			arg0_134:SetActive(true)

			arg0_131.uiAnims[arg1_131] = arg0_134
			var0_131 = arg0_131.uiAnims[arg1_131]

			var1_131()
		end)
	else
		var1_131()
	end
end

function var0_0.displaySpResult(arg0_135, arg1_135, arg2_135)
	setActive(arg0_135.spResult, true)
	arg0_135:DisplaySPAnim(arg1_135 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_136)
		onButton(arg0_135, arg0_136, function()
			removeOnButton(arg0_136)
			setActive(arg0_136, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_136, arg0_135._tf)
			arg0_135:hideSpResult()
			arg2_135()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_138)
	setActive(arg0_138.spResult, false)
end

function var0_0.displayBombResult(arg0_139, arg1_139)
	setActive(arg0_139.spResult, true)
	arg0_139:DisplaySPAnim("SpBombRet", function(arg0_140)
		onButton(arg0_139, arg0_140, function()
			removeOnButton(arg0_140)
			setActive(arg0_140, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_140, arg0_139._tf)
			arg0_139:hideSpResult()
			arg1_139()
		end, SFX_PANEL)
	end, function(arg0_142)
		setText(arg0_142.transform:Find("right/name_bg/en"), arg0_139.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_143, arg1_143, arg2_143)
	arg0_143.contextData.chapterLoopFlag = arg2_143

	local var0_143 = getProxy(ChapterProxy):getChapterById(arg1_143, true)

	if var0_143:getConfig("type") == Chapter.CustomFleet then
		arg0_143:displayFleetEdit(var0_143)

		return
	end

	if #var0_143:getNpcShipByType(1) > 0 then
		arg0_143:emit(LevelMediator2.ON_TRACKING, arg1_143)

		return
	end

	arg0_143:displayFleetSelect(var0_143)
end

function var0_0.DisplayLevelInfoPanel(arg0_144, arg1_144, arg2_144)
	seriesAsync({
		function(arg0_145)
			if not arg0_144.levelInfoView:GetLoaded() then
				arg0_144:frozen()
				arg0_144.levelInfoView:Load()
				arg0_144.levelInfoView:CallbackInvoke(function()
					arg0_144:unfrozen()
					arg0_145()
				end)

				return
			end

			arg0_145()
		end,
		function(arg0_147)
			local function var0_147(arg0_148, arg1_148)
				arg0_144:hideChapterPanel()
				arg0_144:OnLevelInfoPanelConfirm(arg0_148, arg1_148)
			end

			local function var1_147()
				arg0_144:hideChapterPanel()
			end

			local var2_147 = getProxy(ChapterProxy):getChapterById(arg1_144, true)

			if getProxy(ChapterProxy):getMapById(var2_147:getConfig("map")):isSkirmish() and #var2_147:getNpcShipByType(1) > 0 then
				var0_147(false)

				return
			end

			arg0_144.levelInfoView:set(arg1_144, arg2_144)
			arg0_144.levelInfoView:setCBFunc(var0_147, var1_147)
			arg0_144.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_150)
	if arg0_150.levelInfoView:isShowing() then
		arg0_150.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_151)
	arg0_151.levelInfoView:Destroy()

	arg0_151.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_152, arg1_152, arg2_152, arg3_152)
	seriesAsync({
		function(arg0_153)
			if not arg0_152.levelInfoSPView then
				arg0_152.levelInfoSPView = LevelInfoSPView.New(arg0_152.topPanel, arg0_152.event, arg0_152.contextData)

				arg0_152:frozen()
				arg0_152.levelInfoSPView:Load()
				arg0_152.levelInfoSPView:CallbackInvoke(function()
					arg0_152:unfrozen()
					arg0_153()
				end)

				return
			end

			arg0_153()
		end,
		function(arg0_155)
			local function var0_155(arg0_156, arg1_156)
				arg0_152:HideLevelInfoSPPanel()
				arg0_152:OnLevelInfoPanelConfirm(arg0_156, arg1_156)
			end

			local function var1_155()
				arg0_152:HideLevelInfoSPPanel()
			end

			arg0_152.levelInfoSPView:SetChapterGroupInfo(arg2_152)
			arg0_152.levelInfoSPView:set(arg1_152, arg3_152)
			arg0_152.levelInfoSPView:setCBFunc(var0_155, var1_155)
			arg0_152.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_158)
	if arg0_158.levelInfoSPView and arg0_158.levelInfoSPView:isShowing() then
		arg0_158.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_159)
	if not arg0_159.levelInfoSPView then
		return
	end

	arg0_159.levelInfoSPView:Destroy()

	arg0_159.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_160, arg1_160)
	local var0_160 = arg0_160.contextData.selectedFleetIDs or arg1_160:GetDefaultFleetIndex()

	arg1_160 = Clone(arg1_160)
	arg1_160.loopFlag = arg0_160.contextData.chapterLoopFlag

	arg0_160.levelFleetView:updateSpecialOperationTickets(arg0_160.spTickets)
	arg0_160.levelFleetView:Load()
	arg0_160.levelFleetView:ActionInvoke("setHardShipVOs", arg0_160.shipVOs)
	arg0_160.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_160.openedCommanerSystem)
	arg0_160.levelFleetView:ActionInvoke("set", arg1_160, arg0_160.fleets, var0_160)
	arg0_160.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_161)
	if arg0_161.levelCMDFormationView:isShowing() then
		arg0_161.levelCMDFormationView:Hide()
	end

	if arg0_161.levelFleetView then
		arg0_161.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_162)
	arg0_162.levelCMDFormationView = LevelCMDFormationView.New(arg0_162.topPanel, arg0_162.event, arg0_162.contextData)
end

function var0_0.destroyFleetSelect(arg0_163)
	if not arg0_163.levelFleetView then
		return
	end

	arg0_163.levelFleetView:Destroy()

	arg0_163.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_164, arg1_164)
	arg1_164 = Clone(arg1_164)
	arg1_164.loopFlag = arg0_164.contextData.chapterLoopFlag

	arg0_164.levelFleetView:updateSpecialOperationTickets(arg0_164.spTickets)
	arg0_164.levelFleetView:Load()
	arg0_164.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_164.openedCommanerSystem)
	arg0_164.levelFleetView:ActionInvoke("setHardShipVOs", arg0_164.shipVOs)
	arg0_164.levelFleetView:ActionInvoke("setOnHard", arg1_164)
	arg0_164.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_165)
	arg0_165:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_166)
	arg0_166:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_167, arg1_167)
	if not arg0_167.levelFleetView then
		return
	end

	assert(arg0_167.levelFleetView:GetLoaded())

	local var0_167 = arg0_167.levelFleetView:IsSelectMode()
	local var1_167

	if var0_167 then
		arg0_167.levelFleetView:ActionInvoke("set", arg1_167 or arg0_167.levelFleetView.chapter, arg0_167.fleets, arg0_167.levelFleetView:getSelectIds())

		if arg0_167.levelCMDFormationView:isShowing() then
			local var2_167 = arg0_167.levelCMDFormationView.fleet.id

			var1_167 = arg0_167.fleets[var2_167]
		end
	else
		arg0_167.levelFleetView:ActionInvoke("setOnHard", arg1_167 or arg0_167.levelFleetView.chapter)

		if arg0_167.levelCMDFormationView:isShowing() then
			local var3_167 = arg0_167.levelCMDFormationView.fleet.id

			var1_167 = arg1_167:wrapEliteFleet(var3_167)
		end
	end

	if var1_167 then
		arg0_167.levelCMDFormationView:ActionInvoke("updateFleet", var1_167)
	end
end

function var0_0.setChapter(arg0_168, arg1_168)
	local var0_168

	if arg1_168 then
		var0_168 = arg1_168.id
	end

	arg0_168.contextData.chapterId = var0_168
	arg0_168.contextData.chapterVO = arg1_168
end

function var0_0.switchToChapter(arg0_169, arg1_169)
	if arg0_169.contextData.mapIdx ~= arg1_169:getConfig("map") then
		arg0_169:setMap(arg1_169:getConfig("map"))
	end

	arg0_169:setChapter(arg1_169)

	arg0_169.leftCanvasGroup.blocksRaycasts = false
	arg0_169.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_169.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_169:DestroyLevelStageView()

	if not arg0_169.levelStageView then
		arg0_169.levelStageView = LevelStageView.New(arg0_169.topPanel, arg0_169.event, arg0_169.contextData)

		arg0_169.levelStageView:Load()

		arg0_169.levelStageView.isFrozen = arg0_169:isfrozen()
	end

	arg0_169:frozen()

	local function var0_169()
		seriesAsync({
			function(arg0_171)
				arg0_169.mapBuilder:CallbackInvoke(arg0_171)
			end,
			function(arg0_172)
				setActive(arg0_169.clouds, false)
				arg0_169.mapBuilder:HideFloat()
				pg.UIMgr.GetInstance():BlurPanel(arg0_169.topPanel, false, {
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
				arg0_169.levelStageView:updateStageInfo()
				arg0_169.levelStageView:updateAmbushRate(arg1_169.fleet.line, true)
				arg0_169.levelStageView:updateStageAchieve()
				arg0_169.levelStageView:updateStageBarrier()
				arg0_169.levelStageView:updateBombPanel()
				arg0_169.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_172)
			end,
			function(arg0_173)
				if arg0_169.exited then
					return
				end

				arg0_169.levelStageView:updateStageStrategy()

				arg0_169.canvasGroup.blocksRaycasts = arg0_169.frozenCount == 0

				onNextTick(arg0_173)
			end,
			function(arg0_174)
				if arg0_169.exited then
					return
				end

				arg0_169.levelStageView:updateStageFleet()
				arg0_169.levelStageView:updateSupportFleet()
				arg0_169.levelStageView:updateFleetBuff()
				onNextTick(arg0_174)
			end,
			function(arg0_175)
				if arg0_169.exited then
					return
				end

				parallelAsync({
					function(arg0_176)
						local var0_176 = arg1_169:getConfig("scale")
						local var1_176 = LeanTween.value(go(arg0_169.map), arg0_169.map.localScale, Vector3.New(var0_176[3], var0_176[3], 1), var1_0):setOnUpdateVector3(function(arg0_177)
							arg0_169.map.localScale = arg0_177
							arg0_169.float.localScale = arg0_177
						end):setOnComplete(System.Action(function()
							arg0_169.mapBuilder:ShowFloat()
							arg0_169.mapBuilder:Hide()
							arg0_176()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_169:RecordTween("mapScale", var1_176.uniqueId)

						local var2_176 = LeanTween.value(go(arg0_169.map), arg0_169.map.pivot, Vector2.New(math.clamp(var0_176[1] - 0.5, 0, 1), math.clamp(var0_176[2] - 0.5, 0, 1)), var1_0)

						var2_176:setOnUpdateVector2(function(arg0_179)
							arg0_169.map.pivot = arg0_179
							arg0_169.float.pivot = arg0_179
						end):setEase(LeanTweenType.easeOutSine)
						arg0_169:RecordTween("mapPivot", var2_176.uniqueId)
						shiftPanel(arg0_169.leftChapter, -arg0_169.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_169.rightChapter, arg0_169.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_169.topChapter, 0, arg0_169.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_169.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_180)
						arg0_169:PlayBGM()

						local var0_180 = {}
						local var1_180 = arg1_169:getConfig("bg")

						if var1_180 and #var1_180 > 0 then
							var0_180[1] = {
								BG = var1_180
							}
						end

						arg0_169:SwitchBG(var0_180, arg0_180)
					end
				}, function()
					onNextTick(arg0_175)
				end)
			end,
			function(arg0_182)
				if arg0_169.exited then
					return
				end

				setActive(arg0_169.topChapter, false)
				setActive(arg0_169.leftChapter, false)
				setActive(arg0_169.rightChapter, false)

				arg0_169.leftCanvasGroup.blocksRaycasts = true
				arg0_169.rightCanvasGroup.blocksRaycasts = true

				arg0_169:initGrid(arg0_182)
			end,
			function(arg0_183)
				if arg0_169.exited then
					return
				end

				arg0_169.levelStageView:SetGrid(arg0_169.grid)

				arg0_169.contextData.huntingRangeVisibility = arg0_169.contextData.huntingRangeVisibility - 1

				arg0_169.grid:toggleHuntingRange()

				local var0_183 = arg1_169:getConfig("pop_pic")

				if var0_183 and #var0_183 > 0 and arg0_169.FirstEnterChapter == arg1_169.id then
					arg0_169:doPlayAnim(var0_183, function(arg0_184)
						setActive(arg0_184, false)

						if arg0_169.exited then
							return
						end

						arg0_183()
					end)
				else
					arg0_183()
				end
			end,
			function(arg0_185)
				arg0_169.levelStageView:tryAutoAction(arg0_185)
			end,
			function(arg0_186)
				if arg0_169.exited then
					return
				end

				arg0_169:unfrozen()

				if arg0_169.FirstEnterChapter then
					arg0_169:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_169.subAutoAttack)
				end

				arg0_169.FirstEnterChapter = nil

				arg0_169.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0_169.levelStageView:ActionInvoke("SetSeriesOperation", var0_169)
	arg0_169.levelStageView:ActionInvoke("SetPlayer", arg0_169.player)
	arg0_169.levelStageView:ActionInvoke("SwitchToChapter", arg1_169)
end

function var0_0.switchToMap(arg0_187, arg1_187)
	arg0_187:frozen()
	arg0_187:destroyGrid()
	arg0_187:setChapter(nil)
	LeanTween.cancel(go(arg0_187.map))

	local var0_187 = LeanTween.value(go(arg0_187.map), arg0_187.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_188)
		arg0_187.map.localScale = arg0_188
		arg0_187.float.localScale = arg0_188
	end):setOnComplete(System.Action(function()
		arg0_187:unfrozen()
		arg0_187.mapBuilder:PlayEnterAnim()
		existCall(arg1_187)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_187:RecordTween("mapScale", var0_187.uniqueId)

	local var1_187 = arg0_187.contextData.map:getConfig("anchor")
	local var2_187

	if var1_187 == "" then
		var2_187 = Vector2.zero
	else
		var2_187 = Vector2(unpack(var1_187))
	end

	local var3_187 = LeanTween.value(go(arg0_187.map), arg0_187.map.pivot, var2_187, var1_0)

	var3_187:setOnUpdateVector2(function(arg0_190)
		arg0_187.map.pivot = arg0_190
		arg0_187.float.pivot = arg0_190
	end):setEase(LeanTweenType.easeOutSine)
	arg0_187:RecordTween("mapPivot", var3_187.uniqueId)
	setActive(arg0_187.topChapter, true)
	setActive(arg0_187.leftChapter, true)
	setActive(arg0_187.rightChapter, true)
	shiftPanel(arg0_187.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_187.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_187.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_187.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_187.levelStageView then
		arg0_187.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_187:DestroyLevelStageView()
		end)
		arg0_187.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_187:SwitchMapBG(arg0_187.contextData.map)
	arg0_187:PlayBGM()
	seriesAsync({
		function(arg0_192)
			arg0_187.mapBuilder:CallbackInvoke(arg0_192)
		end,
		function(arg0_193)
			arg0_187.mapBuilder:Show()
			arg0_187.mapBuilder:UpdateView()
			arg0_187.mapBuilder:UpdateMapItems()
		end
	})
	pg.UIMgr.GetInstance():UnblurPanel(arg0_187.topPanel, arg0_187._tf)
	pg.playerResUI:SetActive({
		active = false
	})

	arg0_187.canvasGroup.blocksRaycasts = arg0_187.frozenCount == 0
	arg0_187.canvasGroup.interactable = true

	if arg0_187.ambushWarning and arg0_187.ambushWarning.activeSelf then
		arg0_187.ambushWarning:SetActive(false)
		arg0_187:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_194, arg1_194, arg2_194, arg3_194)
	if not arg1_194 or #arg1_194 <= 0 then
		existCall(arg2_194)

		return
	elseif arg3_194 then
		-- block empty
	elseif table.equal(arg0_194.currentBG, arg1_194) then
		return
	end

	arg0_194.currentBG = arg1_194

	for iter0_194, iter1_194 in ipairs(arg0_194.mapGroup) do
		arg0_194.loader:ClearRequest(iter1_194)
	end

	table.clear(arg0_194.mapGroup)

	local var0_194 = {}

	table.ParallelIpairsAsync(arg1_194, function(arg0_195, arg1_195, arg2_195)
		local var0_195 = arg0_194.mapTFs[arg0_195]
		local var1_195 = arg1_195.bgPrefix and arg1_195.bgPrefix .. "/" or "levelmap/"
		local var2_195 = arg0_194.loader:GetSpriteDirect(var1_195 .. arg1_195.BG, "", function(arg0_196)
			var0_194[arg0_195] = arg0_196

			arg2_195()
		end, var0_195)

		table.insert(arg0_194.mapGroup, var2_195)
		arg0_194:updateCouldAnimator(arg1_195.Animator, arg0_195)
	end, function()
		for iter0_197, iter1_197 in ipairs(arg0_194.mapTFs) do
			setImageSprite(iter1_197, var0_194[iter0_197])
			setActive(iter1_197, arg1_194[iter0_197])
			SetCompomentEnabled(iter1_197, typeof(Image), true)
		end

		existCall(arg2_194)
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

function var0_0.ClearMapTransitions(arg0_198)
	if not arg0_198.mapTransitions then
		return
	end

	for iter0_198, iter1_198 in pairs(arg0_198.mapTransitions) do
		if iter1_198 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_198, iter0_198, iter1_198, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_198, iter0_198)
		end
	end

	arg0_198.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_199, arg1_199, arg2_199, arg3_199)
	local var0_199, var1_199, var2_199 = arg0_199:GetMapBG(arg1_199, arg2_199)

	if not var1_199 then
		arg0_199:SwitchBG(var0_199, nil, arg3_199)

		return
	end

	arg0_199:PlayMapTransition("LevelMapTransition_" .. var1_199, var2_199, function()
		arg0_199:SwitchBG(var0_199, nil, arg3_199)
	end)
end

function var0_0.GetMapBG(arg0_201, arg1_201, arg2_201)
	if not table.contains(var7_0, arg1_201.id) then
		return {
			arg0_201:GetMapElement(arg1_201)
		}
	end

	local var0_201 = arg1_201.id
	local var1_201 = table.indexof(var7_0, var0_201) - 1
	local var2_201 = bit.lshift(bit.rshift(var1_201, 1), 1) + 1
	local var3_201 = {
		var7_0[var2_201],
		var7_0[var2_201 + 1]
	}
	local var4_201 = _.map(var3_201, function(arg0_202)
		return getProxy(ChapterProxy):getMapById(arg0_202)
	end)

	if _.all(var4_201, function(arg0_203)
		return arg0_203:isAllChaptersClear()
	end) then
		local var5_201 = {
			arg0_201:GetMapElement(arg1_201)
		}

		if not arg2_201 or math.abs(var0_201 - arg2_201) ~= 1 then
			return var5_201
		end

		local var6_201 = var9_0[bit.rshift(var2_201 - 1, 1) + 1]
		local var7_201 = bit.band(var1_201, 1) == 1

		return var5_201, var6_201, var7_201
	else
		local var8_201 = 0

		;(function()
			local var0_204 = var4_201[1]:getChapters()

			for iter0_204, iter1_204 in ipairs(var0_204) do
				if not iter1_204:isClear() then
					return
				end

				var8_201 = var8_201 + 1
			end

			if not var4_201[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_201 = var8_201 + 1

			local var1_204 = var4_201[2]:getChapters()

			for iter2_204, iter3_204 in ipairs(var1_204) do
				if not iter3_204:isClear() then
					return
				end

				var8_201 = var8_201 + 1
			end
		end)()

		local var9_201

		if var8_201 > 0 then
			local var10_201 = var8_0[bit.rshift(var2_201 - 1, 1) + 1]

			var9_201 = {
				{
					BG = "map_" .. var10_201[1],
					Animator = var10_201[2]
				},
				{
					BG = "map_" .. var10_201[3] + var8_201,
					Animator = var10_201[4]
				}
			}
		else
			var9_201 = {
				arg0_201:GetMapElement(arg1_201)
			}
		end

		return var9_201
	end
end

function var0_0.GetMapElement(arg0_205, arg1_205)
	local var0_205 = arg1_205:getConfig("bg")
	local var1_205 = arg1_205:getConfig("ani_controller")

	if var1_205 and #var1_205 > 0 then
		(function()
			for iter0_206, iter1_206 in ipairs(var1_205) do
				local var0_206 = _.rest(iter1_206[2], 2)

				for iter2_206, iter3_206 in ipairs(var0_206) do
					if string.find(iter3_206, "^map_") and iter1_206[1] == var3_0 then
						local var1_206 = iter1_206[2][1]
						local var2_206 = getProxy(ChapterProxy):GetChapterItemById(var1_206)

						if var2_206 and not var2_206:isClear() then
							var0_205 = iter3_206

							return
						end
					end
				end
			end
		end)()
	end

	local var2_205 = {
		BG = var0_205
	}

	var2_205.Animator, var2_205.AnimatorController = arg0_205:GetMapAnimator(arg1_205)

	return var2_205
end

function var0_0.GetMapAnimator(arg0_207, arg1_207)
	local var0_207 = arg1_207:getConfig("ani_name")

	if arg1_207:getConfig("animtor") == 1 and var0_207 and #var0_207 > 0 then
		local var1_207 = arg1_207:getConfig("ani_controller")

		if var1_207 and #var1_207 > 0 then
			(function()
				for iter0_208, iter1_208 in ipairs(var1_207) do
					local var0_208 = _.rest(iter1_208[2], 2)

					for iter2_208, iter3_208 in ipairs(var0_208) do
						if string.find(iter3_208, "^effect_") and iter1_208[1] == var3_0 then
							local var1_208 = iter1_208[2][1]
							local var2_208 = getProxy(ChapterProxy):GetChapterItemById(var1_208)

							if var2_208 and not var2_208:isClear() then
								var0_207 = "map_" .. string.sub(iter3_208, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_207, var1_207
	end
end

function var0_0.PlayMapTransition(arg0_209, arg1_209, arg2_209, arg3_209, arg4_209)
	arg0_209.mapTransitions = arg0_209.mapTransitions or {}

	local var0_209

	local function var1_209()
		arg0_209:frozen()
		existCall(arg3_209, var0_209)
		var0_209:SetActive(true)

		local var0_210 = tf(var0_209)

		pg.UIMgr.GetInstance():OverlayPanel(var0_210, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		var0_209:GetComponent(typeof(Animator)):Play(arg2_209 and "Sequence" or "Inverted", -1, 0)
		var0_210:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_211)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_210, arg0_209._tf)
			existCall(arg4_209, var0_209)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_209, arg1_209, var0_209)

			arg0_209.mapTransitions[arg1_209] = false

			arg0_209:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_209, arg1_209, true, function(arg0_212)
		var0_209 = arg0_212
		arg0_209.mapTransitions[arg1_209] = arg0_212

		var1_209()
	end)
end

function var0_0.DestroyLevelStageView(arg0_213)
	if arg0_213.levelStageView then
		arg0_213.levelStageView:Destroy()

		arg0_213.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_214, arg1_214)
	arg0_214.levelAmbushView = LevelAmbushView.New(arg0_214.topPanel, arg0_214.event, arg0_214.contextData)

	arg0_214.levelAmbushView:Load()
	arg0_214.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_214)
end

function var0_0.hideAmbushInfo(arg0_215)
	if arg0_215.levelAmbushView then
		arg0_215.levelAmbushView:Destroy()

		arg0_215.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_216, arg1_216)
	arg0_216:frozen()

	local function var0_216()
		arg0_216.ambushWarning:SetActive(true)

		local var0_217 = tf(arg0_216.ambushWarning)

		var0_217:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_217:SetSiblingIndex(1)

		local var1_217 = var0_217:GetComponent("DftAniEvent")

		var1_217:SetTriggerEvent(function(arg0_218)
			arg1_216()
		end)
		var1_217:SetEndEvent(function(arg0_219)
			arg0_216.ambushWarning:SetActive(false)
			arg0_216:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_216.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_221)
			arg0_221:SetActive(true)

			arg0_216.ambushWarning = arg0_221

			var0_216()
		end)
	else
		var0_216()
	end
end

function var0_0.destroyAmbushWarn(arg0_222)
	if arg0_222.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_222.ambushWarning)

		arg0_222.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_223, arg1_223)
	arg0_223.levelStrategyView = LevelStrategyView.New(arg0_223.topPanel, arg0_223.event, arg0_223.contextData)

	arg0_223.levelStrategyView:Load()
	arg0_223.levelStrategyView:ActionInvoke("set", arg1_223)

	local function var0_223()
		local var0_224 = arg0_223.contextData.chapterVO.fleet
		local var1_224 = pg.strategy_data_template[arg1_223.id]

		if not var0_224:canUseStrategy(arg1_223) then
			return
		end

		local var2_224 = var0_224:getNextStgUser(arg1_223.id)

		if var1_224.type == ChapterConst.StgTypeForm then
			arg0_223:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_224,
				arg1 = arg1_223.id
			})
		elseif var1_224.type == ChapterConst.StgTypeConsume then
			arg0_223:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_224,
				arg1 = arg1_223.id
			})
		end

		arg0_223:hideStrategyInfo()
	end

	local function var1_223()
		arg0_223:hideStrategyInfo()
	end

	arg0_223.levelStrategyView:ActionInvoke("setCBFunc", var0_223, var1_223)
end

function var0_0.hideStrategyInfo(arg0_226)
	if arg0_226.levelStrategyView then
		arg0_226.levelStrategyView:Destroy()

		arg0_226.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_227, arg1_227)
	local var0_227 = arg0_227.contextData.chapterVO
	local var1_227 = getProxy(ChapterProxy)
	local var2_227
	local var3_227
	local var4_227
	local var5_227
	local var6_227 = var1_227.repairTimes
	local var7_227, var8_227, var9_227 = ChapterConst.GetRepairParams()

	arg0_227.levelRepairView = LevelRepairView.New(arg0_227.topPanel, arg0_227.event, arg0_227.contextData)

	arg0_227.levelRepairView:Load()
	arg0_227.levelRepairView:ActionInvoke("set", var6_227, var7_227, var8_227, var9_227)

	local function var10_227()
		if var7_227 - math.min(var6_227, var7_227) == 0 and arg0_227.player:getTotalGem() < var9_227 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_227:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_227.fleet.id,
			arg1 = arg1_227.id
		})
		arg0_227:hideRepairWindow()
	end

	local function var11_227()
		arg0_227:hideRepairWindow()
	end

	arg0_227.levelRepairView:ActionInvoke("setCBFunc", var10_227, var11_227)
end

function var0_0.hideRepairWindow(arg0_230)
	if arg0_230.levelRepairView then
		arg0_230.levelRepairView:Destroy()

		arg0_230.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_231, arg1_231)
	arg0_231.levelRemasterView:Load()

	local function var0_231(arg0_232)
		arg0_231:ShowSelectedMap(arg0_232)
	end

	arg0_231.levelRemasterView:ActionInvoke("Show")
	arg0_231.levelRemasterView:ActionInvoke("set", var0_231, arg1_231)
end

function var0_0.hideRemasterPanel(arg0_233)
	if arg0_233.levelRemasterView:isShowing() then
		arg0_233.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_234, arg1_234)
	local var0_234 = arg0_234.contextData.chapterVO

	if not var0_234 then
		return
	end

	arg0_234:enableLevelCamera()
	setActive(arg0_234.uiMain, true)

	arg0_234.levelGrid.localEulerAngles = Vector3(var0_234.theme.angle, 0, 0)
	arg0_234.grid = LevelGrid.New(arg0_234.dragLayer)

	arg0_234.grid:attach(arg0_234)
	arg0_234.grid:ExtendItem("shipTpl", arg0_234.shipTpl)
	arg0_234.grid:ExtendItem("subTpl", arg0_234.subTpl)
	arg0_234.grid:ExtendItem("transportTpl", arg0_234.transportTpl)
	arg0_234.grid:ExtendItem("enemyTpl", arg0_234.enemyTpl)
	arg0_234.grid:ExtendItem("championTpl", arg0_234.championTpl)
	arg0_234.grid:ExtendItem("oniTpl", arg0_234.oniTpl)
	arg0_234.grid:ExtendItem("arrowTpl", arg0_234.arrowTarget)
	arg0_234.grid:ExtendItem("destinationMarkTpl", arg0_234.destinationMarkTpl)

	function arg0_234.grid.onShipStepChange(arg0_235)
		arg0_234.levelStageView:updateAmbushRate(arg0_235)
	end

	arg0_234.grid:initAll(arg1_234)
end

function var0_0.destroyGrid(arg0_236)
	if arg0_236.grid then
		arg0_236.grid:detach()

		arg0_236.grid = nil

		arg0_236:disableLevelCamera()
		setActive(arg0_236.dragLayer, true)
		setActive(arg0_236.uiMain, false)
	end
end

function var0_0.doTracking(arg0_237, arg1_237)
	arg0_237:frozen()

	local function var0_237()
		arg0_237.radar:SetActive(true)

		local var0_238 = tf(arg0_237.radar)

		var0_238:SetParent(arg0_237.topPanel, false)
		var0_238:SetSiblingIndex(1)
		var0_238:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_239)
			arg0_237.radar:SetActive(false)
			arg0_237:unfrozen()
			arg1_237()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_237.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_240)
			arg0_240:SetActive(true)

			arg0_237.radar = arg0_240

			var0_237()
		end)
	else
		var0_237()
	end
end

function var0_0.destroyTracking(arg0_241)
	if arg0_241.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_241.radar)

		arg0_241.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_242, arg1_242, arg2_242, arg3_242)
	local function var0_242()
		arg0_242.playing = true

		arg0_242:frozen()
		arg0_242.airStrike:SetActive(true)

		local var0_243 = tf(arg0_242.airStrike)

		var0_243:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_243:SetAsLastSibling()
		setActive(var0_243:Find("words/be_striked"), arg1_242 == ChapterConst.SubjectChampion)
		setActive(var0_243:Find("words/strike_enemy"), arg1_242 == ChapterConst.SubjectPlayer)

		local function var1_243()
			arg0_242.playing = false

			SetActive(arg0_242.airStrike, false)

			if arg3_242 then
				arg3_242()
			end

			arg0_242:unfrozen()
		end

		var0_243:GetComponent("DftAniEvent"):SetEndEvent(var1_243)

		if arg2_242 then
			onButton(arg0_242, var0_243, var1_243, SFX_PANEL)
		else
			removeOnButton(var0_243)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_242.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_245)
			arg0_245:SetActive(true)

			arg0_242.airStrike = arg0_245

			var0_242()
		end)
	else
		var0_242()
	end
end

function var0_0.destroyAirStrike(arg0_246)
	if arg0_246.airStrike then
		arg0_246.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_246.airStrike)

		arg0_246.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_247, arg1_247, arg2_247, arg3_247)
	arg0_247.uiAnims = arg0_247.uiAnims or {}

	local var0_247 = arg0_247.uiAnims[arg1_247]

	local function var1_247()
		arg0_247.playing = true

		arg0_247:frozen()
		var0_247:SetActive(true)

		local var0_248 = tf(var0_247)

		pg.UIMgr.GetInstance():OverlayPanel(var0_248, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_247 then
			arg3_247(var0_247)
		end

		var0_248:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_249)
			arg0_247.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_248, arg0_247._tf)

			if arg2_247 then
				arg2_247(var0_247)
			end

			arg0_247:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_247 then
		PoolMgr.GetInstance():GetUI(arg1_247, true, function(arg0_250)
			arg0_250:SetActive(true)

			arg0_247.uiAnims[arg1_247] = arg0_250
			var0_247 = arg0_247.uiAnims[arg1_247]

			var1_247()
		end)
	else
		var1_247()
	end
end

function var0_0.destroyUIAnims(arg0_251)
	if arg0_251.uiAnims then
		for iter0_251, iter1_251 in pairs(arg0_251.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_251), arg0_251._tf)
			iter1_251:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_251, iter1_251)
		end

		arg0_251.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_252, arg1_252)
	local function var0_252()
		arg0_252.playing = true

		arg0_252:frozen()
		arg0_252.torpetoAni:SetActive(true)

		local var0_253 = tf(arg0_252.torpetoAni)

		var0_253:SetParent(arg0_252.topPanel, false)
		var0_253:SetAsLastSibling()
		var0_253:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_254)
			arg0_252.playing = false

			SetActive(arg0_252.torpetoAni, false)

			if arg1_252 then
				arg1_252()
			end

			arg0_252:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_252.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_255)
			arg0_255:SetActive(true)

			arg0_252.torpetoAni = arg0_255

			var0_252()
		end)
	else
		var0_252()
	end
end

function var0_0.destroyTorpedo(arg0_256)
	if arg0_256.torpetoAni then
		arg0_256.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_256.torpetoAni)

		arg0_256.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_257, arg1_257, arg2_257, arg3_257)
	arg0_257.strikeAnims = arg0_257.strikeAnims or {}

	local var0_257
	local var1_257
	local var2_257

	local function var3_257()
		if coroutine.status(var2_257) == "suspended" then
			local var0_258, var1_258 = coroutine.resume(var2_257)

			assert(var0_258, debug.traceback(var2_257, var1_258))
		end
	end

	var2_257 = coroutine.create(function()
		arg0_257.playing = true

		arg0_257:frozen()

		local var0_259 = arg0_257.strikeAnims[arg2_257]

		setActive(var0_259, true)

		local var1_259 = tf(var0_259)
		local var2_259 = findTF(var1_259, "torpedo")
		local var3_259 = findTF(var1_259, "mask/painting")
		local var4_259 = findTF(var1_259, "ship")

		setParent(var0_257, var3_259:Find("fitter"), false)
		setParent(var1_257, var4_259, false)
		setActive(var4_259, false)
		setActive(var2_259, false)
		var1_259:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_259:SetAsLastSibling()

		local var5_259 = var1_259:GetComponent("DftAniEvent")
		local var6_259 = var1_257:GetComponent("SpineAnimUI")
		local var7_259 = var6_259:GetComponent("SkeletonGraphic")

		var5_259:SetStartEvent(function(arg0_260)
			var6_259:SetAction("attack", 0)

			var7_259.freeze = true
		end)
		var5_259:SetTriggerEvent(function(arg0_261)
			var7_259.freeze = false

			var6_259:SetActionCallBack(function(arg0_262)
				if arg0_262 == "action" then
					-- block empty
				elseif arg0_262 == "finish" then
					var7_259.freeze = true
				end
			end)
		end)
		var5_259:SetEndEvent(function(arg0_263)
			var7_259.freeze = false

			var3_257()
		end)
		onButton(arg0_257, var1_259, var3_257, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_259, arg1_257:getPainting())
		var6_259:SetActionCallBack(nil)

		var7_259.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_257:getPrefab(), var1_257)
		setActive(var0_259, false)

		arg0_257.playing = false

		arg0_257:unfrozen()

		if arg3_257 then
			arg3_257()
		end
	end)

	local function var4_257()
		if arg0_257.strikeAnims[arg2_257] and var0_257 and var1_257 then
			var3_257()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_257:getPainting(), true, function(arg0_265)
		var0_257 = arg0_265

		ShipExpressionHelper.SetExpression(var0_257, arg1_257:getPainting())
		var4_257()
	end)
	PoolMgr.GetInstance():GetSpineChar(arg1_257:getPrefab(), true, function(arg0_266)
		var1_257 = arg0_266
		var1_257.transform.localScale = Vector3.one

		var4_257()
	end)

	if not arg0_257.strikeAnims[arg2_257] then
		PoolMgr.GetInstance():GetUI(arg2_257, true, function(arg0_267)
			arg0_257.strikeAnims[arg2_257] = arg0_267

			var4_257()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_268)
	if arg0_268.strikeAnims then
		for iter0_268, iter1_268 in pairs(arg0_268.strikeAnims) do
			iter1_268:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_268, iter1_268)
		end

		arg0_268.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_269, arg1_269, arg2_269, arg3_269)
	arg0_269.strikeAnims = arg0_269.strikeAnims or {}

	local var0_269
	local var1_269

	local function var2_269()
		if coroutine.status(var1_269) == "suspended" then
			local var0_270, var1_270 = coroutine.resume(var1_269)

			assert(var0_270, debug.traceback(var1_269, var1_270))
		end
	end

	var1_269 = coroutine.create(function()
		arg0_269.playing = true

		arg0_269:frozen()

		local var0_271 = arg0_269.strikeAnims[arg2_269]

		setActive(var0_271, true)

		local var1_271 = tf(var0_271)
		local var2_271 = findTF(var1_271, "torpedo")
		local var3_271 = findTF(var1_271, "ship")

		setParent(var0_269, var3_271, false)
		setActive(var3_271, false)
		setActive(var2_271, false)
		var1_271:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_271:SetAsLastSibling()

		local var4_271 = var1_271:GetComponent("DftAniEvent")
		local var5_271 = var0_269:GetComponent("SpineAnimUI")
		local var6_271 = var5_271:GetComponent("SkeletonGraphic")

		var4_271:SetStartEvent(function(arg0_272)
			var5_271:SetAction("attack", 0)

			var6_271.freeze = true
		end)
		var4_271:SetTriggerEvent(function(arg0_273)
			var6_271.freeze = false

			var5_271:SetActionCallBack(function(arg0_274)
				if arg0_274 == "action" then
					-- block empty
				elseif arg0_274 == "finish" then
					var6_271.freeze = true
				end
			end)
		end)
		var4_271:SetEndEvent(function(arg0_275)
			var6_271.freeze = false

			var2_269()
		end)
		onButton(arg0_269, var1_271, var2_269, SFX_CANCEL)
		coroutine.yield()
		var5_271:SetActionCallBack(nil)

		var6_271.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_269:getPrefab(), var0_269)
		setActive(var0_271, false)

		arg0_269.playing = false

		arg0_269:unfrozen()

		if arg3_269 then
			arg3_269()
		end
	end)

	local function var3_269()
		if arg0_269.strikeAnims[arg2_269] and var0_269 then
			var2_269()
		end
	end

	PoolMgr.GetInstance():GetSpineChar(arg1_269:getPrefab(), true, function(arg0_277)
		var0_269 = arg0_277
		var0_269.transform.localScale = Vector3.one

		var3_269()
	end)

	if not arg0_269.strikeAnims[arg2_269] then
		PoolMgr.GetInstance():GetUI(arg2_269, true, function(arg0_278)
			arg0_269.strikeAnims[arg2_269] = arg0_278

			var3_269()
		end)
	end
end

function var0_0.doPlayCommander(arg0_279, arg1_279, arg2_279)
	arg0_279:frozen()
	setActive(arg0_279.commanderTinkle, true)

	local var0_279 = arg1_279:getSkills()

	setText(arg0_279.commanderTinkle:Find("name"), #var0_279 > 0 and var0_279[1]:getConfig("name") or "")
	setImageSprite(arg0_279.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_279:getConfig("painting"), ""))

	local var1_279 = arg0_279.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_279.alpha = 0

	local var2_279 = Vector2(248, 237)

	LeanTween.value(go(arg0_279.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_280)
		local var0_280 = arg0_279.commanderTinkle.localPosition

		var0_280.x = var2_279.x + -100 * (1 - arg0_280)
		arg0_279.commanderTinkle.localPosition = var0_280
		var1_279.alpha = arg0_280
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_279.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_281)
		local var0_281 = arg0_279.commanderTinkle.localPosition

		var0_281.x = var2_279.x + 100 * arg0_281
		arg0_279.commanderTinkle.localPosition = var0_281
		var1_279.alpha = 1 - arg0_281
	end)):setOnComplete(System.Action(function()
		if arg2_279 then
			arg2_279()
		end

		arg0_279:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_283, arg1_283, arg2_283, arg3_283)
	local var0_283 = arg0_283.grid:shakeCell(arg1_283)

	if not var0_283 then
		arg3_283()

		return
	end

	arg0_283:easeDamage(var0_283, arg2_283, function()
		arg3_283()
	end)
end

function var0_0.easeDamage(arg0_285, arg1_285, arg2_285, arg3_285)
	arg0_285:frozen()

	local var0_285 = arg0_285.levelCam:WorldToScreenPoint(arg1_285.position)
	local var1_285 = tf(arg0_285:GetDamageText())

	var1_285.position = arg0_285.uiCam:ScreenToWorldPoint(var0_285)

	local var2_285 = var1_285.localPosition

	var2_285.y = var2_285.y + 40
	var2_285.z = 0

	setText(var1_285, arg2_285)

	var1_285.localPosition = var2_285

	LeanTween.value(go(var1_285), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_286)
		local var0_286 = var1_285.localPosition

		var0_286.y = var2_285.y + 60 * arg0_286
		var1_285.localPosition = var0_286

		setTextAlpha(var1_285, 1 - arg0_286)
	end)):setOnComplete(System.Action(function()
		arg0_285:ReturnDamageText(var1_285)
		arg0_285:unfrozen()

		if arg3_285 then
			arg3_285()
		end
	end))
end

function var0_0.easeAvoid(arg0_288, arg1_288, arg2_288)
	arg0_288:frozen()

	local var0_288 = arg0_288.levelCam:WorldToScreenPoint(arg1_288)

	arg0_288.avoidText.position = arg0_288.uiCam:ScreenToWorldPoint(var0_288)

	local var1_288 = arg0_288.avoidText.localPosition

	var1_288.z = 0
	arg0_288.avoidText.localPosition = var1_288

	setActive(arg0_288.avoidText, true)

	local var2_288 = arg0_288.avoidText:Find("avoid")

	LeanTween.value(go(arg0_288.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_289)
		local var0_289 = arg0_288.avoidText.localPosition

		var0_289.y = var1_288.y + 100 * arg0_289
		arg0_288.avoidText.localPosition = var0_289

		setImageAlpha(arg0_288.avoidText, 1 - arg0_289)
		setImageAlpha(var2_288, 1 - arg0_289)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_288.avoidText, false)
		arg0_288:unfrozen()

		if arg2_288 then
			arg2_288()
		end
	end))
end

function var0_0.GetDamageText(arg0_291)
	local var0_291 = table.remove(arg0_291.damageTextPool)

	if not var0_291 then
		var0_291 = Instantiate(arg0_291.damageTextTemplate)

		local var1_291 = tf(arg0_291.damageTextTemplate):GetSiblingIndex()

		setParent(var0_291, tf(arg0_291.damageTextTemplate).parent)
		tf(var0_291):SetSiblingIndex(var1_291 + 1)
	end

	table.insert(arg0_291.damageTextActive, var0_291)
	setActive(var0_291, true)

	return var0_291
end

function var0_0.ReturnDamageText(arg0_292, arg1_292)
	assert(arg1_292)

	if not arg1_292 then
		return
	end

	arg1_292 = go(arg1_292)

	table.removebyvalue(arg0_292.damageTextActive, arg1_292)
	table.insert(arg0_292.damageTextPool, arg1_292)
	setActive(arg1_292, false)
end

function var0_0.resetLevelGrid(arg0_293)
	arg0_293.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_294, arg1_294)
	setActive(arg0_294.curtain, arg1_294)
end

function var0_0.frozen(arg0_295)
	local var0_295 = arg0_295.frozenCount

	arg0_295.frozenCount = arg0_295.frozenCount + 1
	arg0_295.canvasGroup.blocksRaycasts = arg0_295.frozenCount == 0

	if var0_295 == 0 and arg0_295.frozenCount ~= 0 then
		arg0_295:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_296, arg1_296)
	if arg0_296.exited then
		return
	end

	local var0_296 = arg0_296.frozenCount
	local var1_296 = arg1_296 == -1 and arg0_296.frozenCount or arg1_296 or 1

	arg0_296.frozenCount = arg0_296.frozenCount - var1_296
	arg0_296.canvasGroup.blocksRaycasts = arg0_296.frozenCount == 0

	if var0_296 ~= 0 and arg0_296.frozenCount == 0 then
		arg0_296:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_297)
	return arg0_297.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_298)
	arg0_298.levelCamIndices = math.max(arg0_298.levelCamIndices - 1, 0)

	if arg0_298.levelCamIndices == 0 then
		arg0_298.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.disableLevelCamera(arg0_299)
	arg0_299.levelCamIndices = arg0_299.levelCamIndices + 1

	if arg0_299.levelCamIndices > 0 then
		arg0_299.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.RecordTween(arg0_300, arg1_300, arg2_300)
	arg0_300.tweens[arg1_300] = arg2_300
end

function var0_0.DeleteTween(arg0_301, arg1_301)
	local var0_301 = arg0_301.tweens[arg1_301]

	if var0_301 then
		LeanTween.cancel(var0_301)

		arg0_301.tweens[arg1_301] = nil
	end
end

function var0_0.openCommanderPanel(arg0_302, arg1_302, arg2_302, arg3_302)
	local var0_302 = arg2_302.id

	arg0_302.levelCMDFormationView:setCallback(function(arg0_303)
		if not arg3_302 then
			if arg0_303.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_302:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_303.skill)
			elseif arg0_303.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_302.contextData.commanderSelected = {
					chapterId = var0_302,
					fleetId = arg1_302.id
				}

				arg0_302:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_303.pos, arg1_302.id, arg2_302)
				arg0_302:closeCommanderPanel()
			else
				arg0_302:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_303,
					fleetId = arg1_302.id,
					chapterId = var0_302
				}, arg2_302)
			end
		elseif arg0_303.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_302:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_303.skill)
		elseif arg0_303.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_302.contextData.eliteCommanderSelected = {
				index = arg3_302,
				pos = arg0_303.pos,
				chapterId = var0_302
			}

			arg0_302:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_302, arg0_303.pos, arg2_302)
			arg0_302:closeCommanderPanel()
		else
			arg0_302:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_303,
				index = arg3_302,
				chapterId = var0_302
			}, arg2_302)
		end
	end)
	arg0_302.levelCMDFormationView:Load()
	arg0_302.levelCMDFormationView:ActionInvoke("update", arg1_302, arg0_302.commanderPrefabs)
	arg0_302.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_304)
	if arg0_304.levelCMDFormationView:isShowing() then
		arg0_304.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_304.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_305)
	arg0_305.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_306)
	arg0_306.levelCMDFormationView:Destroy()

	arg0_306.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_307, arg1_307)
	arg0_307.spTickets = arg1_307
end

function var0_0.HandleShowMsgBox(arg0_308, arg1_308)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_308)
end

function var0_0.updatePoisonAreaTip(arg0_309)
	local var0_309 = arg0_309.contextData.chapterVO
	local var1_309 = (function(arg0_310)
		local var0_310 = {}
		local var1_310 = pg.map_event_list[var0_309.id] or {}
		local var2_310

		if var0_309:isLoop() then
			var2_310 = var1_310.event_list_loop or {}
		else
			var2_310 = var1_310.event_list or {}
		end

		for iter0_310, iter1_310 in ipairs(var2_310) do
			local var3_310 = pg.map_event_template[iter1_310]

			if var3_310.c_type == arg0_310 then
				table.insert(var0_310, var3_310)
			end
		end

		return var0_310
	end)(ChapterConst.EvtType_Poison)

	if var1_309 then
		for iter0_309, iter1_309 in ipairs(var1_309) do
			local var2_309 = iter1_309.round_gametip

			if var2_309 ~= nil and var2_309 ~= "" and var0_309:getRoundNum() == var2_309[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_309[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_311)
	setActive(arg0_311._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_312)
	local var0_312 = getProxy(ChapterProxy)

	if var0_312 and not arg0_312.contextData.noRecord then
		local var1_312 = arg0_312.contextData.map

		if not var1_312 then
			return
		end

		if var1_312:NeedRecordMap() then
			var0_312:recordLastMap(ChapterProxy.LAST_MAP, var1_312.id)
		end

		if var1_312:isActivity() and not var1_312:isActExtra() then
			var0_312:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_312.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_313)
	local var0_313 = pg.gameset.activity_res_id.key_value
	local var1_313 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var1_313 and not var1_313:isEnd() and var1_313:getConfig("config_client").resId == var0_313 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_314)
		return not arg0_314:isEnd() and arg0_314:getConfig("config_client").pt_id == var0_313
	end) then
		return true
	end
end

function var0_0.willExit(arg0_315)
	arg0_315:ClearMapTransitions()
	arg0_315.loader:Clear()

	if arg0_315.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_315.topPanel, arg0_315._tf)
		pg.playerResUI:SetActive({
			active = false
		})
	end

	if arg0_315.levelFleetView and arg0_315.levelFleetView.selectIds then
		arg0_315.contextData.selectedFleetIDs = {}

		for iter0_315, iter1_315 in pairs(arg0_315.levelFleetView.selectIds) do
			for iter2_315, iter3_315 in pairs(iter1_315) do
				arg0_315.contextData.selectedFleetIDs[#arg0_315.contextData.selectedFleetIDs + 1] = iter3_315
			end
		end
	end

	arg0_315:destroyChapterPanel()
	arg0_315:DestroyLevelInfoSPPanel()
	arg0_315:destroyFleetEdit()
	arg0_315:destroyCommanderPanel()
	arg0_315:DestroyLevelStageView()
	arg0_315:hideRepairWindow()
	arg0_315:hideStrategyInfo()
	arg0_315:hideRemasterPanel()
	arg0_315:hideSpResult()
	arg0_315:destroyGrid()
	arg0_315:destroyAmbushWarn()
	arg0_315:destroyAirStrike()
	arg0_315:destroyTorpedo()
	arg0_315:destroyStrikeAnim()
	arg0_315:destroyTracking()
	arg0_315:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_315, iter5_315 in pairs(arg0_315.mbDict) do
		iter5_315:Destroy()
	end

	arg0_315.mbDict = nil

	for iter6_315, iter7_315 in pairs(arg0_315.tweens) do
		LeanTween.cancel(iter7_315)
	end

	arg0_315.tweens = nil

	if arg0_315.cloudTimer then
		_.each(arg0_315.cloudTimer, function(arg0_316)
			LeanTween.cancel(arg0_316)
		end)

		arg0_315.cloudTimer = nil
	end

	if arg0_315.newChapterCDTimer then
		arg0_315.newChapterCDTimer:Stop()

		arg0_315.newChapterCDTimer = nil
	end

	for iter8_315, iter9_315 in ipairs(arg0_315.damageTextActive) do
		LeanTween.cancel(iter9_315)
	end

	LeanTween.cancel(go(arg0_315.avoidText))

	arg0_315.map.localScale = Vector3.one
	arg0_315.map.pivot = Vector2(0.5, 0.5)
	arg0_315.float.localScale = Vector3.one
	arg0_315.float.pivot = Vector2(0.5, 0.5)

	for iter10_315, iter11_315 in ipairs(arg0_315.mapTFs) do
		clearImageSprite(iter11_315)
	end

	_.each(arg0_315.cloudRTFs, function(arg0_317)
		clearImageSprite(arg0_317)
	end)
	PoolMgr.GetInstance():DestroyAllSprite()
	Destroy(arg0_315.enemyTpl)
	arg0_315:RecordLastMapOnExit()
	arg0_315.levelRemasterView:Destroy()
end

return var0_0
