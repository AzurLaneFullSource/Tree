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

	return var0_8 or arg0_8:selectMap(), tobool(var0_8)
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

function var0_0.selectMap(arg0_64)
	local var0_64 = arg0_64.contextData.mapIdx

	if not var0_64 then
		local var1_64 = getProxy(ChapterProxy)
		local var2_64 = Map.lastMap and var1_64:getMapById(Map.lastMap)

		if var2_64 and var2_64:isUnlock() then
			var0_64 = Map.lastMap
		else
			var0_64 = var1_64:getLastUnlockMap().id
		end
	end

	return var0_64
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
	local var0_80, var1_80 = arg0_80.contextData.map:isActivity()
	local var2_80 = arg0_80.contextData.map:isRemaster()
	local var3_80 = arg0_80.contextData.map:isSkirmish()
	local var4_80 = arg0_80.contextData.map:isEscort()
	local var5_80 = arg0_80.contextData.map:getConfig("type")
	local var6_80 = getProxy(ActivityProxy):GetEarliestActByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)
	local var7_80 = var6_80 and not var6_80:isEnd() and not var0_80 and not var3_80 and not var4_80

	if var7_80 then
		local var8_80 = setmetatable({}, MainActMapBtn)

		var8_80.image = arg0_80.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var8_80.subImage = arg0_80.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var8_80.tipTr = arg0_80.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var8_80.tipTxt = arg0_80.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var7_80 = var8_80:InShowTime()

		if var7_80 then
			var8_80:InitTipImage()
			var8_80:InitSubImage()
			var8_80:InitImage(function()
				return
			end)
			var8_80:OnInit()
		end
	end

	setActive(arg0_80.activityBtn, var7_80)
	arg0_80:updateRemasterInfo()

	if var0_80 and var1_80 then
		local var9_80 = getProxy(ChapterProxy):getMapsByActivities()
		local var10_80 = underscore.any(var9_80, function(arg0_82)
			return arg0_82:isActExtra()
		end)

		setActive(arg0_80.actExtraBtn, var10_80 and not var2_80 and var5_80 ~= Map.ACT_EXTRA)

		if isActive(arg0_80.actExtraBtn) then
			if underscore.all(underscore.filter(var9_80, function(arg0_83)
				local var0_83 = arg0_83:getMapType()

				return var0_83 == Map.ACTIVITY_EASY or var0_83 == Map.ACTIVITY_HARD
			end), function(arg0_84)
				return arg0_84:isAllChaptersClear()
			end) then
				setActive(arg0_80.actExtraBtnAnim, true)
			else
				setActive(arg0_80.actExtraBtnAnim, false)
			end

			setActive(arg0_80.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_80 = checkExist(arg0_80.contextData.map:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_80.actEliteBtn, var11_80 and var5_80 ~= Map.ACTIVITY_HARD)
		setActive(arg0_80.actNormalBtn, var5_80 ~= Map.ACTIVITY_EASY)
		setActive(arg0_80.actExtraRank, var5_80 == Map.ACT_EXTRA)
		setActive(arg0_80.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var2_80 and var1_80 and arg0_80:IsActShopActive())
		setActive(arg0_80.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var2_80 and var1_80 and arg0_80.ptActivity and not arg0_80.ptActivity:isEnd())
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

	setActive(arg0_80.eventContainer, (not var0_80 or not var1_80) and not var4_80)
	setActive(arg0_80.remasterBtn, OPEN_REMASTER and (var2_80 or not var0_80 and not var4_80 and not var3_80))
	setActive(arg0_80.ticketTxt.parent, var2_80)
	arg0_80:updateRemasterTicket()
	arg0_80:updateCountDown()

	if var0_80 and var5_80 ~= Map.ACT_EXTRA then
		Map.lastMapForActivity = arg0_80.contextData.mapIdx
	end
end

function var0_0.updateRemasterTicket(arg0_85)
	setText(arg0_85.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_85:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_86)
	local var0_86 = getProxy(ChapterProxy)
	local var1_86 = var0_86:ifShowRemasterTip() or var0_86:anyRemasterAwardCanReceive()

	SetActive(arg0_86.remasterBtn:Find("tip"), var1_86)
	SetActive(arg0_86.entranceLayer:Find("btns/btn_remaster/tip"), var1_86)
end

function var0_0.updatDailyBtnTip(arg0_87)
	local var0_87 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_87.dailyBtn:Find("tip"), var0_87)
	SetActive(arg0_87.entranceLayer:Find("btns/btn_daily/tip"), var0_87)
end

function var0_0.updateRemasterInfo(arg0_88)
	arg0_88:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_88.contextData.map then
		return
	end

	local var0_88 = getProxy(ChapterProxy)
	local var1_88
	local var2_88 = arg0_88.contextData.map:getRemaster()

	if var2_88 and #pg.re_map_template[var2_88].drop_gain > 0 then
		for iter0_88, iter1_88 in ipairs(pg.re_map_template[var2_88].drop_gain) do
			if #iter1_88 > 0 and var0_88.remasterInfo[iter1_88[1]][iter0_88].receive == false then
				var1_88 = {
					iter0_88,
					iter1_88
				}

				break
			end
		end
	end

	setActive(arg0_88.remasterAwardBtn, var1_88)

	if var1_88 then
		local var3_88 = var1_88[1]
		local var4_88, var5_88, var6_88, var7_88 = unpack(var1_88[2])
		local var8_88 = var0_88.remasterInfo[var4_88][var3_88]

		setText(arg0_88.remasterAwardBtn:Find("Text"), var8_88.count .. "/" .. var7_88)
		updateDrop(arg0_88.remasterAwardBtn:Find("IconTpl"), {
			type = var5_88,
			id = var6_88
		})
		setActive(arg0_88.remasterAwardBtn:Find("tip"), var7_88 <= var8_88.count)
		onButton(arg0_88, arg0_88.remasterAwardBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_88,
					id = var6_88
				},
				weight = LayerWeightConst.TOP_LAYER,
				remaster = {
					word = i18n("level_remaster_tip4", pg.chapter_template[var4_88].chapter_name),
					number = var8_88.count .. "/" .. var7_88,
					btn_text = i18n(var8_88.count < var7_88 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var8_88.count < var7_88 then
							local var0_90 = pg.chapter_template[var4_88].map
							local var1_90, var2_90 = var0_88:getMapById(var0_90):isUnlock()

							if not var1_90 then
								pg.TipsMgr.GetInstance():ShowTips(var2_90)
							else
								arg0_88:ShowSelectedMap(var0_90)
							end
						else
							arg0_88:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_88, var3_88)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_91)
	local var0_91 = getProxy(ChapterProxy)

	if arg0_91.newChapterCDTimer then
		arg0_91.newChapterCDTimer:Stop()

		arg0_91.newChapterCDTimer = nil
	end

	local var1_91 = 0

	if arg0_91.contextData.map:isActivity() and not arg0_91.contextData.map:isRemaster() then
		local var2_91 = var0_91:getMapsByActivities()

		_.each(var2_91, function(arg0_92)
			local var0_92 = arg0_92:getChapterTimeLimit()

			if var1_91 == 0 then
				var1_91 = var0_92
			else
				var1_91 = math.min(var1_91, var0_92)
			end
		end)
		setActive(arg0_91.countDown, var1_91 > 0)
		setText(arg0_91.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_91.countDown, false)
	end

	if var1_91 > 0 then
		setText(arg0_91.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_91))

		arg0_91.newChapterCDTimer = Timer.New(function()
			var1_91 = var1_91 - 1

			if var1_91 <= 0 then
				arg0_91:updateCountDown()

				if not arg0_91.contextData.chapterVO then
					arg0_91:setMap(arg0_91.contextData.mapIdx)
				end
			else
				setText(arg0_91.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_91))
			end
		end, 1, -1)

		arg0_91.newChapterCDTimer:Start()
	else
		setText(arg0_91.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_94)
	onButton(arg0_94, arg0_94.actExtraRank, function()
		if arg0_94:isfrozen() then
			return
		end

		arg0_94:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_94, arg0_94.activityBtn, function()
		if arg0_94:isfrozen() then
			return
		end

		arg0_94:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_94, arg0_94.actExchangeShopBtn, function()
		if arg0_94:isfrozen() then
			return
		end

		arg0_94:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_94, arg0_94.actAtelierBuffBtn, function()
		if arg0_94:isfrozen() then
			return
		end

		arg0_94:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)

	local var0_94 = getProxy(ChapterProxy)

	local function var1_94(arg0_99, arg1_99, arg2_99)
		local var0_99

		if arg0_99:isRemaster() then
			var0_99 = var0_94:getRemasterMaps(arg0_99.remasterId)
		else
			var0_99 = var0_94:getMapsByActivities()
		end

		local var1_99 = _.select(var0_99, function(arg0_100)
			return arg0_100:getMapType() == arg1_99
		end)

		table.sort(var1_99, function(arg0_101, arg1_101)
			return arg0_101.id < arg1_101.id
		end)

		local var2_99 = table.indexof(underscore.map(var1_99, function(arg0_102)
			return arg0_102.id
		end), arg2_99) or #var1_99

		while not var1_99[var2_99]:isUnlock() do
			if var2_99 > 1 then
				var2_99 = var2_99 - 1
			else
				break
			end
		end

		return var1_99[var2_99]
	end

	local function var2_94()
		if arg0_94:isfrozen() then
			return
		end

		local var0_103 = arg0_94.contextData.map:getBindMapId()
		local var1_103 = var1_94(arg0_94.contextData.map, Map.ACTIVITY_HARD, var0_103)
		local var2_103, var3_103 = var1_103:isUnlock()

		if var2_103 then
			arg0_94:setMap(var1_103.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_103)
		end
	end

	onButton(arg0_94, arg0_94.actEliteBtn, var2_94, SFX_PANEL)
	arg0_94:bind(LevelUIConst.SWITCH_CHALLENGE_MAP, var2_94)
	onButton(arg0_94, arg0_94.actNormalBtn, function()
		if arg0_94:isfrozen() then
			return
		end

		local var0_104 = arg0_94.contextData.map:getBindMapId()
		local var1_104 = var1_94(arg0_94.contextData.map, Map.ACTIVITY_EASY, var0_104)
		local var2_104, var3_104 = var1_104:isUnlock()

		if var2_104 then
			arg0_94:setMap(var1_104.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_104)
		end
	end, SFX_PANEL)
	onButton(arg0_94, arg0_94.actExtraBtn, function()
		if arg0_94:isfrozen() then
			return
		end

		local var0_105 = PlayerPrefs.HasKey("ex_mapId") and PlayerPrefs.GetInt("ex_mapId", 0) or 0
		local var1_105 = var1_94(arg0_94.contextData.map, Map.ACT_EXTRA, var0_105)
		local var2_105, var3_105 = var1_105:isUnlock()

		if var2_105 then
			arg0_94:setMap(var1_105.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_105)
		end
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_106, arg1_106)
	arg0_106.initPositions = {}

	local var0_106 = arg1_106 or 1
	local var1_106 = pg.expedition_data_by_map[var0_106].clouds_pos

	for iter0_106, iter1_106 in ipairs(arg0_106.cloudRTFs) do
		local var2_106 = var1_106[iter0_106]

		if var2_106 then
			iter1_106.anchoredPosition = Vector2(var2_106[1], var2_106[2])

			table.insert(arg0_106.initPositions, iter1_106.anchoredPosition)
		else
			setActive(iter1_106, false)
		end
	end
end

function var0_0.initMapBtn(arg0_107, arg1_107, arg2_107)
	onButton(arg0_107, arg1_107, function()
		if arg0_107:isfrozen() then
			return
		end

		local var0_108 = arg0_107.contextData.mapIdx + arg2_107
		local var1_108 = getProxy(ChapterProxy):getMapById(var0_108)

		if not var1_108 then
			return
		end

		if var1_108:getMapType() == Map.ELITE and not var1_108:isEliteEnabled() then
			var1_108 = var1_108:getBindMap()
			var0_108 = var1_108.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_108, var3_108 = var1_108:isUnlock()

		if arg2_107 > 0 and not var2_108 then
			pg.TipsMgr.GetInstance():ShowTips(var3_108)

			return
		end

		arg0_107:setMap(var0_108)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_109, arg1_109, arg2_109)
	seriesAsync({
		function(arg0_110)
			if arg0_109.contextData.entranceStatus then
				arg0_109:frozen()

				arg0_109.nextPreloadMap = arg1_109

				arg0_109:PreloadLevelMainUI(arg1_109, function()
					arg0_109:unfrozen()

					if arg0_109.nextPreloadMap ~= arg1_109 then
						return
					end

					arg0_109:ShowEntranceUI(false)
					arg0_109:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_109)
					arg0_110()
				end)
			else
				arg0_109:setMap(arg1_109)
				arg0_110()
			end
		end
	}, arg2_109)
end

function var0_0.setMap(arg0_112, arg1_112)
	local var0_112 = arg0_112.contextData.mapIdx

	arg0_112.contextData.mapIdx = arg1_112
	arg0_112.contextData.map = getProxy(ChapterProxy):getMapById(arg1_112)

	assert(arg0_112.contextData.map, "map cannot be nil " .. arg1_112)

	if arg0_112.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_112.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_112.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_112.contextData.map.remasterId, arg1_112)
		PlayerPrefs.Save()
	end

	arg0_112:updateMap(var0_112)
	arg0_112:tryPlayMapStory()
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

function var0_0.SwitchMapBuilder(arg0_113, arg1_113)
	if arg0_113.mapBuilder and arg0_113.mapBuilder:GetType() ~= arg1_113 then
		arg0_113.mapBuilder:Hide()
	end

	local var0_113 = arg0_113:GetMapBuilderInBuffer(arg1_113)

	arg0_113.mapBuilder = var0_113

	var0_113:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_114, arg1_114)
	if not arg0_114.mbDict[arg1_114] then
		local var0_114 = _G[var6_0[arg1_114]]

		assert(var0_114, "Missing MapBuilder of type " .. (arg1_114 or "NIL"))

		arg0_114.mbDict[arg1_114] = var0_114.New(arg0_114._tf, arg0_114)
		arg0_114.mbDict[arg1_114].isFrozen = arg0_114:isfrozen()

		arg0_114.mbDict[arg1_114]:Load()
	end

	return arg0_114.mbDict[arg1_114]
end

function var0_0.updateMap(arg0_115, arg1_115)
	local var0_115 = arg0_115.contextData.map
	local var1_115 = var0_115:getConfig("anchor")
	local var2_115

	if var1_115 == "" then
		var2_115 = Vector2.zero
	else
		var2_115 = Vector2(unpack(var1_115))
	end

	arg0_115.map.pivot = var2_115

	local var3_115 = var0_115:getConfig("uifx")

	for iter0_115 = 1, arg0_115.UIFXList.childCount do
		local var4_115 = arg0_115.UIFXList:GetChild(iter0_115 - 1)

		setActive(var4_115, var4_115.name == var3_115)
	end

	arg0_115:SwitchMapBG(var0_115, arg1_115)
	arg0_115:PlayBGM()

	local var5_115 = arg0_115.contextData.map:getConfig("ui_type")

	arg0_115:SwitchMapBuilder(var5_115)
	arg0_115.mapBuilder:UpdateMapVO(var0_115)
	arg0_115.mapBuilder:UpdateView()
	arg0_115.mapBuilder:UpdateMapItems()
end

function var0_0.UpdateSwitchMapButton(arg0_116)
	local var0_116 = arg0_116.contextData.map
	local var1_116 = getProxy(ChapterProxy)
	local var2_116 = var1_116:getMapById(var0_116.id - 1)
	local var3_116 = var1_116:getMapById(var0_116.id + 1)

	setActive(arg0_116.btnPrev, tobool(var2_116))
	setActive(arg0_116.btnNext, tobool(var3_116))

	local var4_116 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_116.btnPrevCol, var2_116 and Color.white or var4_116)
	setImageColor(arg0_116.btnNextCol, var3_116 and var3_116:isUnlock() and Color.white or var4_116)
end

function var0_0.tryPlayMapStory(arg0_117)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_118)
			local var0_118 = arg0_117.contextData.map:getConfig("enter_story")

			if var0_118 and var0_118 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_118) and not arg0_117.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_118 = tonumber(var0_118)

				if var1_118 and var1_118 > 0 then
					arg0_117:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_118)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_118, arg0_118)
				end

				return
			end

			arg0_118()
		end,
		function(arg0_119)
			local var0_119 = arg0_117.contextData.map:getConfig("guide_id")

			if var0_119 and var0_119 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_119, nil, arg0_119)

				return
			end

			arg0_119()
		end,
		function(arg0_120)
			if isActive(arg0_117.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_120 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_120

				if var0_120 then
					var1_120 = {
						1,
						2
					}
				else
					var1_120 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_120)
			else
				arg0_120()
			end
		end,
		function(arg0_121)
			if arg0_117.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_117.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_122, arg1_122, arg2_122, arg3_122)
	arg0_122.uiAnims = arg0_122.uiAnims or {}

	local var0_122 = arg0_122.uiAnims[arg1_122]

	local function var1_122()
		arg0_122.playing = true

		arg0_122:frozen()
		var0_122:SetActive(true)

		local var0_123 = tf(var0_122)

		pg.UIMgr.GetInstance():OverlayPanel(var0_123, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_122 then
			arg3_122(var0_122)
		end

		var0_123:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_124)
			arg0_122.playing = false

			if arg2_122 then
				arg2_122(var0_122)
			end

			arg0_122:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_122 then
		PoolMgr.GetInstance():GetUI(arg1_122, true, function(arg0_125)
			arg0_125:SetActive(true)

			arg0_122.uiAnims[arg1_122] = arg0_125
			var0_122 = arg0_122.uiAnims[arg1_122]

			var1_122()
		end)
	else
		var1_122()
	end
end

function var0_0.displaySpResult(arg0_126, arg1_126, arg2_126)
	setActive(arg0_126.spResult, true)
	arg0_126:DisplaySPAnim(arg1_126 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_127)
		onButton(arg0_126, arg0_127, function()
			removeOnButton(arg0_127)
			setActive(arg0_127, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_127, arg0_126._tf)
			arg0_126:hideSpResult()
			arg2_126()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_129)
	setActive(arg0_129.spResult, false)
end

function var0_0.displayBombResult(arg0_130, arg1_130)
	setActive(arg0_130.spResult, true)
	arg0_130:DisplaySPAnim("SpBombRet", function(arg0_131)
		onButton(arg0_130, arg0_131, function()
			removeOnButton(arg0_131)
			setActive(arg0_131, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_131, arg0_130._tf)
			arg0_130:hideSpResult()
			arg1_130()
		end, SFX_PANEL)
	end, function(arg0_133)
		setText(arg0_133.transform:Find("right/name_bg/en"), arg0_130.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_134, arg1_134, arg2_134)
	arg0_134.contextData.chapterLoopFlag = arg2_134

	local var0_134 = getProxy(ChapterProxy):getChapterById(arg1_134, true)

	if var0_134:getConfig("type") == Chapter.CustomFleet then
		arg0_134:displayFleetEdit(var0_134)

		return
	end

	if #var0_134:getNpcShipByType(1) > 0 then
		arg0_134:emit(LevelMediator2.ON_TRACKING, arg1_134)

		return
	end

	arg0_134:displayFleetSelect(var0_134)
end

function var0_0.DisplayLevelInfoPanel(arg0_135, arg1_135, arg2_135)
	seriesAsync({
		function(arg0_136)
			if not arg0_135.levelInfoView:GetLoaded() then
				arg0_135:frozen()
				arg0_135.levelInfoView:Load()
				arg0_135.levelInfoView:CallbackInvoke(function()
					arg0_135:unfrozen()
					arg0_136()
				end)

				return
			end

			arg0_136()
		end,
		function(arg0_138)
			local function var0_138(arg0_139, arg1_139)
				arg0_135:hideChapterPanel()
				arg0_135:OnLevelInfoPanelConfirm(arg0_139, arg1_139)
			end

			local function var1_138()
				arg0_135:hideChapterPanel()
			end

			local var2_138 = getProxy(ChapterProxy):getChapterById(arg1_135, true)

			if getProxy(ChapterProxy):getMapById(var2_138:getConfig("map")):isSkirmish() and #var2_138:getNpcShipByType(1) > 0 then
				var0_138(false)

				return
			end

			arg0_135.levelInfoView:set(arg1_135, arg2_135)
			arg0_135.levelInfoView:setCBFunc(var0_138, var1_138)
			arg0_135.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_141)
	if arg0_141.levelInfoView:isShowing() then
		arg0_141.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_142)
	arg0_142.levelInfoView:Destroy()

	arg0_142.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_143, arg1_143, arg2_143, arg3_143)
	seriesAsync({
		function(arg0_144)
			if not arg0_143.levelInfoSPView then
				arg0_143.levelInfoSPView = LevelInfoSPView.New(arg0_143.topPanel, arg0_143.event, arg0_143.contextData)

				arg0_143:frozen()
				arg0_143.levelInfoSPView:Load()
				arg0_143.levelInfoSPView:CallbackInvoke(function()
					arg0_143:unfrozen()
					arg0_144()
				end)

				return
			end

			arg0_144()
		end,
		function(arg0_146)
			local function var0_146(arg0_147, arg1_147)
				arg0_143:HideLevelInfoSPPanel()
				arg0_143:OnLevelInfoPanelConfirm(arg0_147, arg1_147)
			end

			local function var1_146()
				arg0_143:HideLevelInfoSPPanel()
			end

			arg0_143.levelInfoSPView:SetChapterGroupInfo(arg2_143)
			arg0_143.levelInfoSPView:set(arg1_143, arg3_143)
			arg0_143.levelInfoSPView:setCBFunc(var0_146, var1_146)
			arg0_143.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_149)
	if arg0_149.levelInfoSPView and arg0_149.levelInfoSPView:isShowing() then
		arg0_149.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_150)
	if not arg0_150.levelInfoSPView then
		return
	end

	arg0_150.levelInfoSPView:Destroy()

	arg0_150.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_151, arg1_151)
	local var0_151 = arg0_151.contextData.selectedFleetIDs or arg1_151:GetDefaultFleetIndex()

	arg1_151 = Clone(arg1_151)
	arg1_151.loopFlag = arg0_151.contextData.chapterLoopFlag

	arg0_151.levelFleetView:updateSpecialOperationTickets(arg0_151.spTickets)
	arg0_151.levelFleetView:Load()
	arg0_151.levelFleetView:ActionInvoke("setHardShipVOs", arg0_151.shipVOs)
	arg0_151.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_151.openedCommanerSystem)
	arg0_151.levelFleetView:ActionInvoke("set", arg1_151, arg0_151.fleets, var0_151)
	arg0_151.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_152)
	if arg0_152.levelCMDFormationView:isShowing() then
		arg0_152.levelCMDFormationView:Hide()
	end

	if arg0_152.levelFleetView then
		arg0_152.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_153)
	arg0_153.levelCMDFormationView = LevelCMDFormationView.New(arg0_153.topPanel, arg0_153.event, arg0_153.contextData)
end

function var0_0.destroyFleetSelect(arg0_154)
	if not arg0_154.levelFleetView then
		return
	end

	arg0_154.levelFleetView:Destroy()

	arg0_154.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_155, arg1_155)
	arg1_155 = Clone(arg1_155)
	arg1_155.loopFlag = arg0_155.contextData.chapterLoopFlag

	arg0_155.levelFleetView:updateSpecialOperationTickets(arg0_155.spTickets)
	arg0_155.levelFleetView:Load()
	arg0_155.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_155.openedCommanerSystem)
	arg0_155.levelFleetView:ActionInvoke("setHardShipVOs", arg0_155.shipVOs)
	arg0_155.levelFleetView:ActionInvoke("setOnHard", arg1_155)
	arg0_155.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_156)
	arg0_156:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_157)
	arg0_157:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_158, arg1_158)
	if not arg0_158.levelFleetView then
		return
	end

	assert(arg0_158.levelFleetView:GetLoaded())

	local var0_158 = arg0_158.levelFleetView:IsSelectMode()
	local var1_158

	if var0_158 then
		arg0_158.levelFleetView:ActionInvoke("set", arg1_158 or arg0_158.levelFleetView.chapter, arg0_158.fleets, arg0_158.levelFleetView:getSelectIds())

		if arg0_158.levelCMDFormationView:isShowing() then
			local var2_158 = arg0_158.levelCMDFormationView.fleet.id

			var1_158 = arg0_158.fleets[var2_158]
		end
	else
		arg0_158.levelFleetView:ActionInvoke("setOnHard", arg1_158 or arg0_158.levelFleetView.chapter)

		if arg0_158.levelCMDFormationView:isShowing() then
			local var3_158 = arg0_158.levelCMDFormationView.fleet.id

			var1_158 = arg1_158:wrapEliteFleet(var3_158)
		end
	end

	if var1_158 then
		arg0_158.levelCMDFormationView:ActionInvoke("updateFleet", var1_158)
	end
end

function var0_0.setChapter(arg0_159, arg1_159)
	local var0_159

	if arg1_159 then
		var0_159 = arg1_159.id
	end

	arg0_159.contextData.chapterId = var0_159
	arg0_159.contextData.chapterVO = arg1_159
end

function var0_0.switchToChapter(arg0_160, arg1_160)
	if arg0_160.contextData.mapIdx ~= arg1_160:getConfig("map") then
		arg0_160:setMap(arg1_160:getConfig("map"))
	end

	arg0_160:setChapter(arg1_160)
	setActive(arg0_160.clouds, false)
	arg0_160.mapBuilder:HideFloat()

	arg0_160.leftCanvasGroup.blocksRaycasts = false
	arg0_160.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_160.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_160:DestroyLevelStageView()

	if not arg0_160.levelStageView then
		arg0_160.levelStageView = LevelStageView.New(arg0_160.topPanel, arg0_160.event, arg0_160.contextData)

		arg0_160.levelStageView:Load()

		arg0_160.levelStageView.isFrozen = arg0_160:isfrozen()
	end

	arg0_160:frozen()

	local function var0_160()
		seriesAsync({
			function(arg0_162)
				pg.UIMgr.GetInstance():BlurPanel(arg0_160.topPanel, false, {
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
				arg0_160.levelStageView:updateStageInfo()
				arg0_160.levelStageView:updateAmbushRate(arg1_160.fleet.line, true)
				arg0_160.levelStageView:updateStageAchieve()
				arg0_160.levelStageView:updateStageBarrier()
				arg0_160.levelStageView:updateBombPanel()
				arg0_160.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_162)
			end,
			function(arg0_163)
				if arg0_160.exited then
					return
				end

				arg0_160.levelStageView:updateStageStrategy()

				arg0_160.canvasGroup.blocksRaycasts = arg0_160.frozenCount == 0

				onNextTick(arg0_163)
			end,
			function(arg0_164)
				if arg0_160.exited then
					return
				end

				arg0_160.levelStageView:updateStageFleet()
				arg0_160.levelStageView:updateSupportFleet()
				arg0_160.levelStageView:updateFleetBuff()
				onNextTick(arg0_164)
			end,
			function(arg0_165)
				if arg0_160.exited then
					return
				end

				parallelAsync({
					function(arg0_166)
						local var0_166 = arg1_160:getConfig("scale")
						local var1_166 = LeanTween.value(go(arg0_160.map), arg0_160.map.localScale, Vector3.New(var0_166[3], var0_166[3], 1), var1_0):setOnUpdateVector3(function(arg0_167)
							arg0_160.map.localScale = arg0_167
							arg0_160.float.localScale = arg0_167
						end):setOnComplete(System.Action(function()
							arg0_160.mapBuilder:ShowFloat()
							arg0_160.mapBuilder:Hide()
							arg0_166()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_160:RecordTween("mapScale", var1_166.uniqueId)

						local var2_166 = LeanTween.value(go(arg0_160.map), arg0_160.map.pivot, Vector2.New(math.clamp(var0_166[1] - 0.5, 0, 1), math.clamp(var0_166[2] - 0.5, 0, 1)), var1_0)

						var2_166:setOnUpdateVector2(function(arg0_169)
							arg0_160.map.pivot = arg0_169
							arg0_160.float.pivot = arg0_169
						end):setEase(LeanTweenType.easeOutSine)
						arg0_160:RecordTween("mapPivot", var2_166.uniqueId)
						shiftPanel(arg0_160.leftChapter, -arg0_160.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_160.rightChapter, arg0_160.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_160.topChapter, 0, arg0_160.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_160.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_170)
						arg0_160:PlayBGM()

						local var0_170 = {}
						local var1_170 = arg1_160:getConfig("bg")

						if var1_170 and #var1_170 > 0 then
							var0_170[1] = {
								BG = var1_170
							}
						end

						arg0_160:SwitchBG(var0_170, arg0_170)
					end
				}, function()
					onNextTick(arg0_165)
				end)
			end,
			function(arg0_172)
				if arg0_160.exited then
					return
				end

				setActive(arg0_160.topChapter, false)
				setActive(arg0_160.leftChapter, false)
				setActive(arg0_160.rightChapter, false)

				arg0_160.leftCanvasGroup.blocksRaycasts = true
				arg0_160.rightCanvasGroup.blocksRaycasts = true

				arg0_160:initGrid(arg0_172)
			end,
			function(arg0_173)
				if arg0_160.exited then
					return
				end

				arg0_160.levelStageView:SetGrid(arg0_160.grid)

				arg0_160.contextData.huntingRangeVisibility = arg0_160.contextData.huntingRangeVisibility - 1

				arg0_160.grid:toggleHuntingRange()

				local var0_173 = arg1_160:getConfig("pop_pic")

				if var0_173 and #var0_173 > 0 and arg0_160.FirstEnterChapter == arg1_160.id then
					arg0_160:doPlayAnim(var0_173, function(arg0_174)
						setActive(arg0_174, false)

						if arg0_160.exited then
							return
						end

						arg0_173()
					end)
				else
					arg0_173()
				end
			end,
			function(arg0_175)
				arg0_160.levelStageView:tryAutoAction(arg0_175)
			end,
			function(arg0_176)
				if arg0_160.exited then
					return
				end

				arg0_160:unfrozen()

				if arg0_160.FirstEnterChapter then
					arg0_160:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_160.subAutoAttack)
				end

				arg0_160.FirstEnterChapter = nil

				arg0_160.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0_160.levelStageView:ActionInvoke("SetSeriesOperation", var0_160)
	arg0_160.levelStageView:ActionInvoke("SetPlayer", arg0_160.player)
	arg0_160.levelStageView:ActionInvoke("SwitchToChapter", arg1_160)
end

function var0_0.switchToMap(arg0_177, arg1_177)
	arg0_177:frozen()
	arg0_177:destroyGrid()
	arg0_177:setChapter(nil)
	LeanTween.cancel(go(arg0_177.map))

	local var0_177 = LeanTween.value(go(arg0_177.map), arg0_177.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_178)
		arg0_177.map.localScale = arg0_178
		arg0_177.float.localScale = arg0_178
	end):setOnComplete(System.Action(function()
		arg0_177:unfrozen()
		existCall(arg1_177)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_177:RecordTween("mapScale", var0_177.uniqueId)

	local var1_177 = arg0_177.contextData.map:getConfig("anchor")
	local var2_177

	if var1_177 == "" then
		var2_177 = Vector2.zero
	else
		var2_177 = Vector2(unpack(var1_177))
	end

	local var3_177 = LeanTween.value(go(arg0_177.map), arg0_177.map.pivot, var2_177, var1_0)

	var3_177:setOnUpdateVector2(function(arg0_180)
		arg0_177.map.pivot = arg0_180
		arg0_177.float.pivot = arg0_180
	end):setEase(LeanTweenType.easeOutSine)
	arg0_177:RecordTween("mapPivot", var3_177.uniqueId)
	setActive(arg0_177.topChapter, true)
	setActive(arg0_177.leftChapter, true)
	setActive(arg0_177.rightChapter, true)
	shiftPanel(arg0_177.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_177.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_177.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_177.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_177.levelStageView then
		arg0_177.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_177:DestroyLevelStageView()
		end)
		arg0_177.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_177:SwitchMapBG(arg0_177.contextData.map)
	arg0_177:PlayBGM()
	arg0_177.mapBuilder:Show()
	arg0_177.mapBuilder:UpdateView()
	arg0_177.mapBuilder:UpdateMapItems()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_177.topPanel, arg0_177._tf)
	pg.playerResUI:SetActive({
		active = false
	})

	arg0_177.canvasGroup.blocksRaycasts = arg0_177.frozenCount == 0
	arg0_177.canvasGroup.interactable = true

	if arg0_177.ambushWarning and arg0_177.ambushWarning.activeSelf then
		arg0_177.ambushWarning:SetActive(false)
		arg0_177:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_182, arg1_182, arg2_182, arg3_182)
	if not arg1_182 or #arg1_182 <= 0 then
		existCall(arg2_182)

		return
	elseif arg3_182 then
		-- block empty
	elseif table.equal(arg0_182.currentBG, arg1_182) then
		return
	end

	arg0_182.currentBG = arg1_182

	for iter0_182, iter1_182 in ipairs(arg0_182.mapGroup) do
		arg0_182.loader:ClearRequest(iter1_182)
	end

	table.clear(arg0_182.mapGroup)

	local var0_182 = {}

	table.ParallelIpairsAsync(arg1_182, function(arg0_183, arg1_183, arg2_183)
		local var0_183 = arg0_182.mapTFs[arg0_183]
		local var1_183 = arg1_183.bgPrefix and arg1_183.bgPrefix .. "/" or "levelmap/"
		local var2_183 = arg0_182.loader:GetSpriteDirect(var1_183 .. arg1_183.BG, "", function(arg0_184)
			var0_182[arg0_183] = arg0_184

			arg2_183()
		end, var0_183)

		table.insert(arg0_182.mapGroup, var2_183)
		arg0_182:updateCouldAnimator(arg1_183.Animator, arg0_183)
	end, function()
		for iter0_185, iter1_185 in ipairs(arg0_182.mapTFs) do
			setImageSprite(iter1_185, var0_182[iter0_185])
			setActive(iter1_185, arg1_182[iter0_185])
			SetCompomentEnabled(iter1_185, typeof(Image), true)
		end

		existCall(arg2_182)
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

function var0_0.ClearMapTransitions(arg0_186)
	if not arg0_186.mapTransitions then
		return
	end

	for iter0_186, iter1_186 in pairs(arg0_186.mapTransitions) do
		if iter1_186 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_186, iter0_186, iter1_186, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_186, iter0_186)
		end
	end

	arg0_186.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_187, arg1_187, arg2_187, arg3_187)
	local var0_187, var1_187, var2_187 = arg0_187:GetMapBG(arg1_187, arg2_187)

	if not var1_187 then
		arg0_187:SwitchBG(var0_187, nil, arg3_187)

		return
	end

	arg0_187:PlayMapTransition("LevelMapTransition_" .. var1_187, var2_187, function()
		arg0_187:SwitchBG(var0_187, nil, arg3_187)
	end)
end

function var0_0.GetMapBG(arg0_189, arg1_189, arg2_189)
	if not table.contains(var7_0, arg1_189.id) then
		return {
			arg0_189:GetMapElement(arg1_189)
		}
	end

	local var0_189 = arg1_189.id
	local var1_189 = table.indexof(var7_0, var0_189) - 1
	local var2_189 = bit.lshift(bit.rshift(var1_189, 1), 1) + 1
	local var3_189 = {
		var7_0[var2_189],
		var7_0[var2_189 + 1]
	}
	local var4_189 = _.map(var3_189, function(arg0_190)
		return getProxy(ChapterProxy):getMapById(arg0_190)
	end)

	if _.all(var4_189, function(arg0_191)
		return arg0_191:isAllChaptersClear()
	end) then
		local var5_189 = {
			arg0_189:GetMapElement(arg1_189)
		}

		if not arg2_189 or math.abs(var0_189 - arg2_189) ~= 1 then
			return var5_189
		end

		local var6_189 = var9_0[bit.rshift(var2_189 - 1, 1) + 1]
		local var7_189 = bit.band(var1_189, 1) == 1

		return var5_189, var6_189, var7_189
	else
		local var8_189 = 0

		;(function()
			local var0_192 = var4_189[1]:getChapters()

			for iter0_192, iter1_192 in ipairs(var0_192) do
				if not iter1_192:isClear() then
					return
				end

				var8_189 = var8_189 + 1
			end

			if not var4_189[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_189 = var8_189 + 1

			local var1_192 = var4_189[2]:getChapters()

			for iter2_192, iter3_192 in ipairs(var1_192) do
				if not iter3_192:isClear() then
					return
				end

				var8_189 = var8_189 + 1
			end
		end)()

		local var9_189

		if var8_189 > 0 then
			local var10_189 = var8_0[bit.rshift(var2_189 - 1, 1) + 1]

			var9_189 = {
				{
					BG = "map_" .. var10_189[1],
					Animator = var10_189[2]
				},
				{
					BG = "map_" .. var10_189[3] + var8_189,
					Animator = var10_189[4]
				}
			}
		else
			var9_189 = {
				arg0_189:GetMapElement(arg1_189)
			}
		end

		return var9_189
	end
end

function var0_0.GetMapElement(arg0_193, arg1_193)
	local var0_193 = arg1_193:getConfig("bg")
	local var1_193 = arg1_193:getConfig("ani_controller")

	if var1_193 and #var1_193 > 0 then
		(function()
			for iter0_194, iter1_194 in ipairs(var1_193) do
				local var0_194 = _.rest(iter1_194[2], 2)

				for iter2_194, iter3_194 in ipairs(var0_194) do
					if string.find(iter3_194, "^map_") and iter1_194[1] == var3_0 then
						local var1_194 = iter1_194[2][1]
						local var2_194 = getProxy(ChapterProxy):GetChapterItemById(var1_194)

						if var2_194 and not var2_194:isClear() then
							var0_193 = iter3_194

							return
						end
					end
				end
			end
		end)()
	end

	local var2_193 = {
		BG = var0_193
	}

	var2_193.Animator, var2_193.AnimatorController = arg0_193:GetMapAnimator(arg1_193)

	return var2_193
end

function var0_0.GetMapAnimator(arg0_195, arg1_195)
	local var0_195 = arg1_195:getConfig("ani_name")

	if arg1_195:getConfig("animtor") == 1 and var0_195 and #var0_195 > 0 then
		local var1_195 = arg1_195:getConfig("ani_controller")

		if var1_195 and #var1_195 > 0 then
			(function()
				for iter0_196, iter1_196 in ipairs(var1_195) do
					local var0_196 = _.rest(iter1_196[2], 2)

					for iter2_196, iter3_196 in ipairs(var0_196) do
						if string.find(iter3_196, "^effect_") and iter1_196[1] == var3_0 then
							local var1_196 = iter1_196[2][1]
							local var2_196 = getProxy(ChapterProxy):GetChapterItemById(var1_196)

							if var2_196 and not var2_196:isClear() then
								var0_195 = "map_" .. string.sub(iter3_196, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_195, var1_195
	end
end

function var0_0.PlayMapTransition(arg0_197, arg1_197, arg2_197, arg3_197, arg4_197)
	arg0_197.mapTransitions = arg0_197.mapTransitions or {}

	local var0_197

	local function var1_197()
		arg0_197:frozen()
		existCall(arg3_197, var0_197)
		var0_197:SetActive(true)

		local var0_198 = tf(var0_197)

		pg.UIMgr.GetInstance():OverlayPanel(var0_198, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		var0_197:GetComponent(typeof(Animator)):Play(arg2_197 and "Sequence" or "Inverted", -1, 0)
		var0_198:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_199)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_198, arg0_197._tf)
			existCall(arg4_197, var0_197)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_197, arg1_197, var0_197)

			arg0_197.mapTransitions[arg1_197] = false

			arg0_197:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_197, arg1_197, true, function(arg0_200)
		var0_197 = arg0_200
		arg0_197.mapTransitions[arg1_197] = arg0_200

		var1_197()
	end)
end

function var0_0.DestroyLevelStageView(arg0_201)
	if arg0_201.levelStageView then
		arg0_201.levelStageView:Destroy()

		arg0_201.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_202, arg1_202)
	arg0_202.levelAmbushView = LevelAmbushView.New(arg0_202.topPanel, arg0_202.event, arg0_202.contextData)

	arg0_202.levelAmbushView:Load()
	arg0_202.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_202)
end

function var0_0.hideAmbushInfo(arg0_203)
	if arg0_203.levelAmbushView then
		arg0_203.levelAmbushView:Destroy()

		arg0_203.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_204, arg1_204)
	arg0_204:frozen()

	local function var0_204()
		arg0_204.ambushWarning:SetActive(true)

		local var0_205 = tf(arg0_204.ambushWarning)

		var0_205:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_205:SetSiblingIndex(1)

		local var1_205 = var0_205:GetComponent("DftAniEvent")

		var1_205:SetTriggerEvent(function(arg0_206)
			arg1_204()
		end)
		var1_205:SetEndEvent(function(arg0_207)
			arg0_204.ambushWarning:SetActive(false)
			arg0_204:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_204.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_209)
			arg0_209:SetActive(true)

			arg0_204.ambushWarning = arg0_209

			var0_204()
		end)
	else
		var0_204()
	end
end

function var0_0.destroyAmbushWarn(arg0_210)
	if arg0_210.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_210.ambushWarning)

		arg0_210.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_211, arg1_211)
	arg0_211.levelStrategyView = LevelStrategyView.New(arg0_211.topPanel, arg0_211.event, arg0_211.contextData)

	arg0_211.levelStrategyView:Load()
	arg0_211.levelStrategyView:ActionInvoke("set", arg1_211)

	local function var0_211()
		local var0_212 = arg0_211.contextData.chapterVO.fleet
		local var1_212 = pg.strategy_data_template[arg1_211.id]

		if not var0_212:canUseStrategy(arg1_211) then
			return
		end

		local var2_212 = var0_212:getNextStgUser(arg1_211.id)

		if var1_212.type == ChapterConst.StgTypeForm then
			arg0_211:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_212,
				arg1 = arg1_211.id
			})
		elseif var1_212.type == ChapterConst.StgTypeConsume then
			arg0_211:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_212,
				arg1 = arg1_211.id
			})
		end

		arg0_211:hideStrategyInfo()
	end

	local function var1_211()
		arg0_211:hideStrategyInfo()
	end

	arg0_211.levelStrategyView:ActionInvoke("setCBFunc", var0_211, var1_211)
end

function var0_0.hideStrategyInfo(arg0_214)
	if arg0_214.levelStrategyView then
		arg0_214.levelStrategyView:Destroy()

		arg0_214.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_215, arg1_215)
	local var0_215 = arg0_215.contextData.chapterVO
	local var1_215 = getProxy(ChapterProxy)
	local var2_215
	local var3_215
	local var4_215
	local var5_215
	local var6_215 = var1_215.repairTimes
	local var7_215, var8_215, var9_215 = ChapterConst.GetRepairParams()

	arg0_215.levelRepairView = LevelRepairView.New(arg0_215.topPanel, arg0_215.event, arg0_215.contextData)

	arg0_215.levelRepairView:Load()
	arg0_215.levelRepairView:ActionInvoke("set", var6_215, var7_215, var8_215, var9_215)

	local function var10_215()
		if var7_215 - math.min(var6_215, var7_215) == 0 and arg0_215.player:getTotalGem() < var9_215 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_215:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_215.fleet.id,
			arg1 = arg1_215.id
		})
		arg0_215:hideRepairWindow()
	end

	local function var11_215()
		arg0_215:hideRepairWindow()
	end

	arg0_215.levelRepairView:ActionInvoke("setCBFunc", var10_215, var11_215)
end

function var0_0.hideRepairWindow(arg0_218)
	if arg0_218.levelRepairView then
		arg0_218.levelRepairView:Destroy()

		arg0_218.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_219, arg1_219)
	arg0_219.levelRemasterView:Load()

	local function var0_219(arg0_220)
		arg0_219:ShowSelectedMap(arg0_220)
	end

	arg0_219.levelRemasterView:ActionInvoke("Show")
	arg0_219.levelRemasterView:ActionInvoke("set", var0_219, arg1_219)
end

function var0_0.hideRemasterPanel(arg0_221)
	if arg0_221.levelRemasterView:isShowing() then
		arg0_221.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_222, arg1_222)
	local var0_222 = arg0_222.contextData.chapterVO

	if not var0_222 then
		return
	end

	arg0_222:enableLevelCamera()
	setActive(arg0_222.uiMain, true)

	arg0_222.levelGrid.localEulerAngles = Vector3(var0_222.theme.angle, 0, 0)
	arg0_222.grid = LevelGrid.New(arg0_222.dragLayer)

	arg0_222.grid:attach(arg0_222)
	arg0_222.grid:ExtendItem("shipTpl", arg0_222.shipTpl)
	arg0_222.grid:ExtendItem("subTpl", arg0_222.subTpl)
	arg0_222.grid:ExtendItem("transportTpl", arg0_222.transportTpl)
	arg0_222.grid:ExtendItem("enemyTpl", arg0_222.enemyTpl)
	arg0_222.grid:ExtendItem("championTpl", arg0_222.championTpl)
	arg0_222.grid:ExtendItem("oniTpl", arg0_222.oniTpl)
	arg0_222.grid:ExtendItem("arrowTpl", arg0_222.arrowTarget)
	arg0_222.grid:ExtendItem("destinationMarkTpl", arg0_222.destinationMarkTpl)

	function arg0_222.grid.onShipStepChange(arg0_223)
		arg0_222.levelStageView:updateAmbushRate(arg0_223)
	end

	arg0_222.grid:initAll(arg1_222)
end

function var0_0.destroyGrid(arg0_224)
	if arg0_224.grid then
		arg0_224.grid:detach()

		arg0_224.grid = nil

		arg0_224:disableLevelCamera()
		setActive(arg0_224.dragLayer, true)
		setActive(arg0_224.uiMain, false)
	end
end

function var0_0.doTracking(arg0_225, arg1_225)
	arg0_225:frozen()

	local function var0_225()
		arg0_225.radar:SetActive(true)

		local var0_226 = tf(arg0_225.radar)

		var0_226:SetParent(arg0_225.topPanel, false)
		var0_226:SetSiblingIndex(1)
		var0_226:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_227)
			arg0_225.radar:SetActive(false)
			arg0_225:unfrozen()
			arg1_225()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_225.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_228)
			arg0_228:SetActive(true)

			arg0_225.radar = arg0_228

			var0_225()
		end)
	else
		var0_225()
	end
end

function var0_0.destroyTracking(arg0_229)
	if arg0_229.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_229.radar)

		arg0_229.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_230, arg1_230, arg2_230, arg3_230)
	local function var0_230()
		arg0_230.playing = true

		arg0_230:frozen()
		arg0_230.airStrike:SetActive(true)

		local var0_231 = tf(arg0_230.airStrike)

		var0_231:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_231:SetAsLastSibling()
		setActive(var0_231:Find("words/be_striked"), arg1_230 == ChapterConst.SubjectChampion)
		setActive(var0_231:Find("words/strike_enemy"), arg1_230 == ChapterConst.SubjectPlayer)

		local function var1_231()
			arg0_230.playing = false

			SetActive(arg0_230.airStrike, false)

			if arg3_230 then
				arg3_230()
			end

			arg0_230:unfrozen()
		end

		var0_231:GetComponent("DftAniEvent"):SetEndEvent(var1_231)

		if arg2_230 then
			onButton(arg0_230, var0_231, var1_231, SFX_PANEL)
		else
			removeOnButton(var0_231)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_230.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_233)
			arg0_233:SetActive(true)

			arg0_230.airStrike = arg0_233

			var0_230()
		end)
	else
		var0_230()
	end
end

function var0_0.destroyAirStrike(arg0_234)
	if arg0_234.airStrike then
		arg0_234.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_234.airStrike)

		arg0_234.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_235, arg1_235, arg2_235, arg3_235)
	arg0_235.uiAnims = arg0_235.uiAnims or {}

	local var0_235 = arg0_235.uiAnims[arg1_235]

	local function var1_235()
		arg0_235.playing = true

		arg0_235:frozen()
		var0_235:SetActive(true)

		local var0_236 = tf(var0_235)

		pg.UIMgr.GetInstance():OverlayPanel(var0_236, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_235 then
			arg3_235(var0_235)
		end

		var0_236:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_237)
			arg0_235.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_236, arg0_235._tf)

			if arg2_235 then
				arg2_235(var0_235)
			end

			arg0_235:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_235 then
		PoolMgr.GetInstance():GetUI(arg1_235, true, function(arg0_238)
			arg0_238:SetActive(true)

			arg0_235.uiAnims[arg1_235] = arg0_238
			var0_235 = arg0_235.uiAnims[arg1_235]

			var1_235()
		end)
	else
		var1_235()
	end
end

function var0_0.destroyUIAnims(arg0_239)
	if arg0_239.uiAnims then
		for iter0_239, iter1_239 in pairs(arg0_239.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_239), arg0_239._tf)
			iter1_239:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_239, iter1_239)
		end

		arg0_239.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_240, arg1_240)
	local function var0_240()
		arg0_240.playing = true

		arg0_240:frozen()
		arg0_240.torpetoAni:SetActive(true)

		local var0_241 = tf(arg0_240.torpetoAni)

		var0_241:SetParent(arg0_240.topPanel, false)
		var0_241:SetAsLastSibling()
		var0_241:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_242)
			arg0_240.playing = false

			SetActive(arg0_240.torpetoAni, false)

			if arg1_240 then
				arg1_240()
			end

			arg0_240:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_240.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_243)
			arg0_243:SetActive(true)

			arg0_240.torpetoAni = arg0_243

			var0_240()
		end)
	else
		var0_240()
	end
end

function var0_0.destroyTorpedo(arg0_244)
	if arg0_244.torpetoAni then
		arg0_244.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_244.torpetoAni)

		arg0_244.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_245, arg1_245, arg2_245, arg3_245)
	arg0_245.strikeAnims = arg0_245.strikeAnims or {}

	local var0_245
	local var1_245
	local var2_245

	local function var3_245()
		if coroutine.status(var2_245) == "suspended" then
			local var0_246, var1_246 = coroutine.resume(var2_245)

			assert(var0_246, debug.traceback(var2_245, var1_246))
		end
	end

	var2_245 = coroutine.create(function()
		arg0_245.playing = true

		arg0_245:frozen()

		local var0_247 = arg0_245.strikeAnims[arg2_245]

		setActive(var0_247, true)

		local var1_247 = tf(var0_247)
		local var2_247 = findTF(var1_247, "torpedo")
		local var3_247 = findTF(var1_247, "mask/painting")
		local var4_247 = findTF(var1_247, "ship")

		setParent(var0_245, var3_247:Find("fitter"), false)
		setParent(var1_245, var4_247, false)
		setActive(var4_247, false)
		setActive(var2_247, false)
		var1_247:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_247:SetAsLastSibling()

		local var5_247 = var1_247:GetComponent("DftAniEvent")
		local var6_247 = var1_245:GetComponent("SpineAnimUI")
		local var7_247 = var6_247:GetComponent("SkeletonGraphic")

		var5_247:SetStartEvent(function(arg0_248)
			var6_247:SetAction("attack", 0)

			var7_247.freeze = true
		end)
		var5_247:SetTriggerEvent(function(arg0_249)
			var7_247.freeze = false

			var6_247:SetActionCallBack(function(arg0_250)
				if arg0_250 == "action" then
					-- block empty
				elseif arg0_250 == "finish" then
					var7_247.freeze = true
				end
			end)
		end)
		var5_247:SetEndEvent(function(arg0_251)
			var7_247.freeze = false

			var3_245()
		end)
		onButton(arg0_245, var1_247, var3_245, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_247, arg1_245:getPainting())
		var6_247:SetActionCallBack(nil)

		var7_247.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_245:getPrefab(), var1_245)
		setActive(var0_247, false)

		arg0_245.playing = false

		arg0_245:unfrozen()

		if arg3_245 then
			arg3_245()
		end
	end)

	local function var4_245()
		if arg0_245.strikeAnims[arg2_245] and var0_245 and var1_245 then
			var3_245()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_245:getPainting(), true, function(arg0_253)
		var0_245 = arg0_253

		ShipExpressionHelper.SetExpression(var0_245, arg1_245:getPainting())
		var4_245()
	end)
	PoolMgr.GetInstance():GetSpineChar(arg1_245:getPrefab(), true, function(arg0_254)
		var1_245 = arg0_254
		var1_245.transform.localScale = Vector3.one

		var4_245()
	end)

	if not arg0_245.strikeAnims[arg2_245] then
		PoolMgr.GetInstance():GetUI(arg2_245, true, function(arg0_255)
			arg0_245.strikeAnims[arg2_245] = arg0_255

			var4_245()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_256)
	if arg0_256.strikeAnims then
		for iter0_256, iter1_256 in pairs(arg0_256.strikeAnims) do
			iter1_256:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_256, iter1_256)
		end

		arg0_256.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_257, arg1_257, arg2_257, arg3_257)
	arg0_257.strikeAnims = arg0_257.strikeAnims or {}

	local var0_257
	local var1_257

	local function var2_257()
		if coroutine.status(var1_257) == "suspended" then
			local var0_258, var1_258 = coroutine.resume(var1_257)

			assert(var0_258, debug.traceback(var1_257, var1_258))
		end
	end

	var1_257 = coroutine.create(function()
		arg0_257.playing = true

		arg0_257:frozen()

		local var0_259 = arg0_257.strikeAnims[arg2_257]

		setActive(var0_259, true)

		local var1_259 = tf(var0_259)
		local var2_259 = findTF(var1_259, "torpedo")
		local var3_259 = findTF(var1_259, "ship")

		setParent(var0_257, var3_259, false)
		setActive(var3_259, false)
		setActive(var2_259, false)
		var1_259:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_259:SetAsLastSibling()

		local var4_259 = var1_259:GetComponent("DftAniEvent")
		local var5_259 = var0_257:GetComponent("SpineAnimUI")
		local var6_259 = var5_259:GetComponent("SkeletonGraphic")

		var4_259:SetStartEvent(function(arg0_260)
			var5_259:SetAction("attack", 0)

			var6_259.freeze = true
		end)
		var4_259:SetTriggerEvent(function(arg0_261)
			var6_259.freeze = false

			var5_259:SetActionCallBack(function(arg0_262)
				if arg0_262 == "action" then
					-- block empty
				elseif arg0_262 == "finish" then
					var6_259.freeze = true
				end
			end)
		end)
		var4_259:SetEndEvent(function(arg0_263)
			var6_259.freeze = false

			var2_257()
		end)
		onButton(arg0_257, var1_259, var2_257, SFX_CANCEL)
		coroutine.yield()
		var5_259:SetActionCallBack(nil)

		var6_259.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_257:getPrefab(), var0_257)
		setActive(var0_259, false)

		arg0_257.playing = false

		arg0_257:unfrozen()

		if arg3_257 then
			arg3_257()
		end
	end)

	local function var3_257()
		if arg0_257.strikeAnims[arg2_257] and var0_257 then
			var2_257()
		end
	end

	PoolMgr.GetInstance():GetSpineChar(arg1_257:getPrefab(), true, function(arg0_265)
		var0_257 = arg0_265
		var0_257.transform.localScale = Vector3.one

		var3_257()
	end)

	if not arg0_257.strikeAnims[arg2_257] then
		PoolMgr.GetInstance():GetUI(arg2_257, true, function(arg0_266)
			arg0_257.strikeAnims[arg2_257] = arg0_266

			var3_257()
		end)
	end
end

function var0_0.doPlayCommander(arg0_267, arg1_267, arg2_267)
	arg0_267:frozen()
	setActive(arg0_267.commanderTinkle, true)

	local var0_267 = arg1_267:getSkills()

	setText(arg0_267.commanderTinkle:Find("name"), #var0_267 > 0 and var0_267[1]:getConfig("name") or "")
	setImageSprite(arg0_267.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_267:getConfig("painting"), ""))

	local var1_267 = arg0_267.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_267.alpha = 0

	local var2_267 = Vector2(248, 237)

	LeanTween.value(go(arg0_267.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_268)
		local var0_268 = arg0_267.commanderTinkle.localPosition

		var0_268.x = var2_267.x + -100 * (1 - arg0_268)
		arg0_267.commanderTinkle.localPosition = var0_268
		var1_267.alpha = arg0_268
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_267.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_269)
		local var0_269 = arg0_267.commanderTinkle.localPosition

		var0_269.x = var2_267.x + 100 * arg0_269
		arg0_267.commanderTinkle.localPosition = var0_269
		var1_267.alpha = 1 - arg0_269
	end)):setOnComplete(System.Action(function()
		if arg2_267 then
			arg2_267()
		end

		arg0_267:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_271, arg1_271, arg2_271, arg3_271)
	local var0_271 = arg0_271.grid:shakeCell(arg1_271)

	if not var0_271 then
		arg3_271()

		return
	end

	arg0_271:easeDamage(var0_271, arg2_271, function()
		arg3_271()
	end)
end

function var0_0.easeDamage(arg0_273, arg1_273, arg2_273, arg3_273)
	arg0_273:frozen()

	local var0_273 = arg0_273.levelCam:WorldToScreenPoint(arg1_273.position)
	local var1_273 = tf(arg0_273:GetDamageText())

	var1_273.position = arg0_273.uiCam:ScreenToWorldPoint(var0_273)

	local var2_273 = var1_273.localPosition

	var2_273.y = var2_273.y + 40
	var2_273.z = 0

	setText(var1_273, arg2_273)

	var1_273.localPosition = var2_273

	LeanTween.value(go(var1_273), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_274)
		local var0_274 = var1_273.localPosition

		var0_274.y = var2_273.y + 60 * arg0_274
		var1_273.localPosition = var0_274

		setTextAlpha(var1_273, 1 - arg0_274)
	end)):setOnComplete(System.Action(function()
		arg0_273:ReturnDamageText(var1_273)
		arg0_273:unfrozen()

		if arg3_273 then
			arg3_273()
		end
	end))
end

function var0_0.easeAvoid(arg0_276, arg1_276, arg2_276)
	arg0_276:frozen()

	local var0_276 = arg0_276.levelCam:WorldToScreenPoint(arg1_276)

	arg0_276.avoidText.position = arg0_276.uiCam:ScreenToWorldPoint(var0_276)

	local var1_276 = arg0_276.avoidText.localPosition

	var1_276.z = 0
	arg0_276.avoidText.localPosition = var1_276

	setActive(arg0_276.avoidText, true)

	local var2_276 = arg0_276.avoidText:Find("avoid")

	LeanTween.value(go(arg0_276.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_277)
		local var0_277 = arg0_276.avoidText.localPosition

		var0_277.y = var1_276.y + 100 * arg0_277
		arg0_276.avoidText.localPosition = var0_277

		setImageAlpha(arg0_276.avoidText, 1 - arg0_277)
		setImageAlpha(var2_276, 1 - arg0_277)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_276.avoidText, false)
		arg0_276:unfrozen()

		if arg2_276 then
			arg2_276()
		end
	end))
end

function var0_0.GetDamageText(arg0_279)
	local var0_279 = table.remove(arg0_279.damageTextPool)

	if not var0_279 then
		var0_279 = Instantiate(arg0_279.damageTextTemplate)

		local var1_279 = tf(arg0_279.damageTextTemplate):GetSiblingIndex()

		setParent(var0_279, tf(arg0_279.damageTextTemplate).parent)
		tf(var0_279):SetSiblingIndex(var1_279 + 1)
	end

	table.insert(arg0_279.damageTextActive, var0_279)
	setActive(var0_279, true)

	return var0_279
end

function var0_0.ReturnDamageText(arg0_280, arg1_280)
	assert(arg1_280)

	if not arg1_280 then
		return
	end

	arg1_280 = go(arg1_280)

	table.removebyvalue(arg0_280.damageTextActive, arg1_280)
	table.insert(arg0_280.damageTextPool, arg1_280)
	setActive(arg1_280, false)
end

function var0_0.resetLevelGrid(arg0_281)
	arg0_281.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_282, arg1_282)
	setActive(arg0_282.curtain, arg1_282)
end

function var0_0.frozen(arg0_283)
	local var0_283 = arg0_283.frozenCount

	arg0_283.frozenCount = arg0_283.frozenCount + 1
	arg0_283.canvasGroup.blocksRaycasts = arg0_283.frozenCount == 0

	if var0_283 == 0 and arg0_283.frozenCount ~= 0 then
		arg0_283:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_284, arg1_284)
	if arg0_284.exited then
		return
	end

	local var0_284 = arg0_284.frozenCount
	local var1_284 = arg1_284 == -1 and arg0_284.frozenCount or arg1_284 or 1

	arg0_284.frozenCount = arg0_284.frozenCount - var1_284
	arg0_284.canvasGroup.blocksRaycasts = arg0_284.frozenCount == 0

	if var0_284 ~= 0 and arg0_284.frozenCount == 0 then
		arg0_284:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_285)
	return arg0_285.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_286)
	arg0_286.levelCamIndices = math.max(arg0_286.levelCamIndices - 1, 0)

	if arg0_286.levelCamIndices == 0 then
		arg0_286.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.disableLevelCamera(arg0_287)
	arg0_287.levelCamIndices = arg0_287.levelCamIndices + 1

	if arg0_287.levelCamIndices > 0 then
		arg0_287.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.RecordTween(arg0_288, arg1_288, arg2_288)
	arg0_288.tweens[arg1_288] = arg2_288
end

function var0_0.DeleteTween(arg0_289, arg1_289)
	local var0_289 = arg0_289.tweens[arg1_289]

	if var0_289 then
		LeanTween.cancel(var0_289)

		arg0_289.tweens[arg1_289] = nil
	end
end

function var0_0.openCommanderPanel(arg0_290, arg1_290, arg2_290, arg3_290)
	local var0_290 = arg2_290.id

	arg0_290.levelCMDFormationView:setCallback(function(arg0_291)
		if not arg3_290 then
			if arg0_291.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_290:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_291.skill)
			elseif arg0_291.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_290.contextData.commanderSelected = {
					chapterId = var0_290,
					fleetId = arg1_290.id
				}

				arg0_290:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_291.pos, arg1_290.id, arg2_290)
				arg0_290:closeCommanderPanel()
			else
				arg0_290:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_291,
					fleetId = arg1_290.id,
					chapterId = var0_290
				}, arg2_290)
			end
		elseif arg0_291.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_290:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_291.skill)
		elseif arg0_291.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_290.contextData.eliteCommanderSelected = {
				index = arg3_290,
				pos = arg0_291.pos,
				chapterId = var0_290
			}

			arg0_290:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_290, arg0_291.pos, arg2_290)
			arg0_290:closeCommanderPanel()
		else
			arg0_290:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_291,
				index = arg3_290,
				chapterId = var0_290
			}, arg2_290)
		end
	end)
	arg0_290.levelCMDFormationView:Load()
	arg0_290.levelCMDFormationView:ActionInvoke("update", arg1_290, arg0_290.commanderPrefabs)
	arg0_290.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_292)
	if arg0_292.levelCMDFormationView:isShowing() then
		arg0_292.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_292.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_293)
	arg0_293.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_294)
	arg0_294.levelCMDFormationView:Destroy()

	arg0_294.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_295, arg1_295)
	arg0_295.spTickets = arg1_295
end

function var0_0.HandleShowMsgBox(arg0_296, arg1_296)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_296)
end

function var0_0.updatePoisonAreaTip(arg0_297)
	local var0_297 = arg0_297.contextData.chapterVO
	local var1_297 = (function(arg0_298)
		local var0_298 = {}
		local var1_298 = pg.map_event_list[var0_297.id] or {}
		local var2_298

		if var0_297:isLoop() then
			var2_298 = var1_298.event_list_loop or {}
		else
			var2_298 = var1_298.event_list or {}
		end

		for iter0_298, iter1_298 in ipairs(var2_298) do
			local var3_298 = pg.map_event_template[iter1_298]

			if var3_298.c_type == arg0_298 then
				table.insert(var0_298, var3_298)
			end
		end

		return var0_298
	end)(ChapterConst.EvtType_Poison)

	if var1_297 then
		for iter0_297, iter1_297 in ipairs(var1_297) do
			local var2_297 = iter1_297.round_gametip

			if var2_297 ~= nil and var2_297 ~= "" and var0_297:getRoundNum() == var2_297[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_297[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_299)
	setActive(arg0_299._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_300)
	local var0_300 = getProxy(ChapterProxy)

	if var0_300 and not arg0_300.contextData.noRecord then
		local var1_300 = arg0_300.contextData.map

		if not var1_300 then
			return
		end

		if var1_300 and var1_300:NeedRecordMap() then
			var0_300:recordLastMap(ChapterProxy.LAST_MAP, var1_300.id)
		end

		if Map.lastMapForActivity then
			var0_300:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, Map.lastMapForActivity)
		end
	end
end

function var0_0.IsActShopActive(arg0_301)
	local var0_301 = pg.gameset.activity_res_id.key_value
	local var1_301 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var1_301 and not var1_301:isEnd() and var1_301:getConfig("config_client").resId == var0_301 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_302)
		return not arg0_302:isEnd() and arg0_302:getConfig("config_client").pt_id == var0_301
	end) then
		return true
	end
end

function var0_0.willExit(arg0_303)
	arg0_303:ClearMapTransitions()
	arg0_303.loader:Clear()

	if arg0_303.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_303.topPanel, arg0_303._tf)
		pg.playerResUI:SetActive({
			active = false
		})
	end

	if arg0_303.levelFleetView and arg0_303.levelFleetView.selectIds then
		arg0_303.contextData.selectedFleetIDs = {}

		for iter0_303, iter1_303 in pairs(arg0_303.levelFleetView.selectIds) do
			for iter2_303, iter3_303 in pairs(iter1_303) do
				arg0_303.contextData.selectedFleetIDs[#arg0_303.contextData.selectedFleetIDs + 1] = iter3_303
			end
		end
	end

	arg0_303:destroyChapterPanel()
	arg0_303:DestroyLevelInfoSPPanel()
	arg0_303:destroyFleetEdit()
	arg0_303:destroyCommanderPanel()
	arg0_303:DestroyLevelStageView()
	arg0_303:hideRepairWindow()
	arg0_303:hideStrategyInfo()
	arg0_303:hideRemasterPanel()
	arg0_303:hideSpResult()
	arg0_303:destroyGrid()
	arg0_303:destroyAmbushWarn()
	arg0_303:destroyAirStrike()
	arg0_303:destroyTorpedo()
	arg0_303:destroyStrikeAnim()
	arg0_303:destroyTracking()
	arg0_303:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_303, iter5_303 in pairs(arg0_303.mbDict) do
		iter5_303:Destroy()
	end

	arg0_303.mbDict = nil

	for iter6_303, iter7_303 in pairs(arg0_303.tweens) do
		LeanTween.cancel(iter7_303)
	end

	arg0_303.tweens = nil

	if arg0_303.cloudTimer then
		_.each(arg0_303.cloudTimer, function(arg0_304)
			LeanTween.cancel(arg0_304)
		end)

		arg0_303.cloudTimer = nil
	end

	if arg0_303.newChapterCDTimer then
		arg0_303.newChapterCDTimer:Stop()

		arg0_303.newChapterCDTimer = nil
	end

	for iter8_303, iter9_303 in ipairs(arg0_303.damageTextActive) do
		LeanTween.cancel(iter9_303)
	end

	LeanTween.cancel(go(arg0_303.avoidText))

	arg0_303.map.localScale = Vector3.one
	arg0_303.map.pivot = Vector2(0.5, 0.5)
	arg0_303.float.localScale = Vector3.one
	arg0_303.float.pivot = Vector2(0.5, 0.5)

	for iter10_303, iter11_303 in ipairs(arg0_303.mapTFs) do
		clearImageSprite(iter11_303)
	end

	_.each(arg0_303.cloudRTFs, function(arg0_305)
		clearImageSprite(arg0_305)
	end)
	PoolMgr.GetInstance():DestroyAllSprite()
	Destroy(arg0_303.enemyTpl)
	arg0_303:RecordLastMapOnExit()
	arg0_303.levelRemasterView:Destroy()
end

return var0_0
