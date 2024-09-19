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
		arg0_113.mapBuilder.buffer:Hide()
	end

	local var0_113 = arg0_113:GetMapBuilderInBuffer(arg1_113)

	arg0_113.mapBuilder = var0_113

	var0_113.buffer:Show()
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
	seriesAsync({
		function(arg0_116)
			arg0_115.mapBuilder:CallbackInvoke(arg0_116)
		end,
		function(arg0_117)
			arg0_115.mapBuilder:UpdateMapVO(var0_115)
			arg0_115.mapBuilder:UpdateView()
			arg0_115.mapBuilder:UpdateMapItems()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_118)
	local var0_118 = arg0_118.contextData.map
	local var1_118 = getProxy(ChapterProxy)
	local var2_118 = var1_118:getMapById(var0_118.id - 1)
	local var3_118 = var1_118:getMapById(var0_118.id + 1)

	setActive(arg0_118.btnPrev, tobool(var2_118))
	setActive(arg0_118.btnNext, tobool(var3_118))

	local var4_118 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_118.btnPrevCol, var2_118 and Color.white or var4_118)
	setImageColor(arg0_118.btnNextCol, var3_118 and var3_118:isUnlock() and Color.white or var4_118)
end

function var0_0.tryPlayMapStory(arg0_119)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_120)
			local var0_120 = arg0_119.contextData.map:getConfig("enter_story")

			if var0_120 and var0_120 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_120) and not arg0_119.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_120 = tonumber(var0_120)

				if var1_120 and var1_120 > 0 then
					arg0_119:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_120)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_120, arg0_120)
				end

				return
			end

			arg0_120()
		end,
		function(arg0_121)
			local var0_121 = arg0_119.contextData.map:getConfig("guide_id")

			if var0_121 and var0_121 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_121, nil, arg0_121)

				return
			end

			arg0_121()
		end,
		function(arg0_122)
			if isActive(arg0_119.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_122 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_122

				if var0_122 then
					var1_122 = {
						1,
						2
					}
				else
					var1_122 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_122)
			else
				arg0_122()
			end
		end,
		function(arg0_123)
			if arg0_119.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_119.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_124, arg1_124, arg2_124, arg3_124)
	arg0_124.uiAnims = arg0_124.uiAnims or {}

	local var0_124 = arg0_124.uiAnims[arg1_124]

	local function var1_124()
		arg0_124.playing = true

		arg0_124:frozen()
		var0_124:SetActive(true)

		local var0_125 = tf(var0_124)

		pg.UIMgr.GetInstance():OverlayPanel(var0_125, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_124 then
			arg3_124(var0_124)
		end

		var0_125:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_126)
			arg0_124.playing = false

			if arg2_124 then
				arg2_124(var0_124)
			end

			arg0_124:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_124 then
		PoolMgr.GetInstance():GetUI(arg1_124, true, function(arg0_127)
			arg0_127:SetActive(true)

			arg0_124.uiAnims[arg1_124] = arg0_127
			var0_124 = arg0_124.uiAnims[arg1_124]

			var1_124()
		end)
	else
		var1_124()
	end
end

function var0_0.displaySpResult(arg0_128, arg1_128, arg2_128)
	setActive(arg0_128.spResult, true)
	arg0_128:DisplaySPAnim(arg1_128 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_129)
		onButton(arg0_128, arg0_129, function()
			removeOnButton(arg0_129)
			setActive(arg0_129, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_129, arg0_128._tf)
			arg0_128:hideSpResult()
			arg2_128()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_131)
	setActive(arg0_131.spResult, false)
end

function var0_0.displayBombResult(arg0_132, arg1_132)
	setActive(arg0_132.spResult, true)
	arg0_132:DisplaySPAnim("SpBombRet", function(arg0_133)
		onButton(arg0_132, arg0_133, function()
			removeOnButton(arg0_133)
			setActive(arg0_133, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_133, arg0_132._tf)
			arg0_132:hideSpResult()
			arg1_132()
		end, SFX_PANEL)
	end, function(arg0_135)
		setText(arg0_135.transform:Find("right/name_bg/en"), arg0_132.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_136, arg1_136, arg2_136)
	arg0_136.contextData.chapterLoopFlag = arg2_136

	local var0_136 = getProxy(ChapterProxy):getChapterById(arg1_136, true)

	if var0_136:getConfig("type") == Chapter.CustomFleet then
		arg0_136:displayFleetEdit(var0_136)

		return
	end

	if #var0_136:getNpcShipByType(1) > 0 then
		arg0_136:emit(LevelMediator2.ON_TRACKING, arg1_136)

		return
	end

	arg0_136:displayFleetSelect(var0_136)
end

function var0_0.DisplayLevelInfoPanel(arg0_137, arg1_137, arg2_137)
	seriesAsync({
		function(arg0_138)
			if not arg0_137.levelInfoView:GetLoaded() then
				arg0_137:frozen()
				arg0_137.levelInfoView:Load()
				arg0_137.levelInfoView:CallbackInvoke(function()
					arg0_137:unfrozen()
					arg0_138()
				end)

				return
			end

			arg0_138()
		end,
		function(arg0_140)
			local function var0_140(arg0_141, arg1_141)
				arg0_137:hideChapterPanel()
				arg0_137:OnLevelInfoPanelConfirm(arg0_141, arg1_141)
			end

			local function var1_140()
				arg0_137:hideChapterPanel()
			end

			local var2_140 = getProxy(ChapterProxy):getChapterById(arg1_137, true)

			if getProxy(ChapterProxy):getMapById(var2_140:getConfig("map")):isSkirmish() and #var2_140:getNpcShipByType(1) > 0 then
				var0_140(false)

				return
			end

			arg0_137.levelInfoView:set(arg1_137, arg2_137)
			arg0_137.levelInfoView:setCBFunc(var0_140, var1_140)
			arg0_137.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_143)
	if arg0_143.levelInfoView:isShowing() then
		arg0_143.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_144)
	arg0_144.levelInfoView:Destroy()

	arg0_144.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_145, arg1_145, arg2_145, arg3_145)
	seriesAsync({
		function(arg0_146)
			if not arg0_145.levelInfoSPView then
				arg0_145.levelInfoSPView = LevelInfoSPView.New(arg0_145.topPanel, arg0_145.event, arg0_145.contextData)

				arg0_145:frozen()
				arg0_145.levelInfoSPView:Load()
				arg0_145.levelInfoSPView:CallbackInvoke(function()
					arg0_145:unfrozen()
					arg0_146()
				end)

				return
			end

			arg0_146()
		end,
		function(arg0_148)
			local function var0_148(arg0_149, arg1_149)
				arg0_145:HideLevelInfoSPPanel()
				arg0_145:OnLevelInfoPanelConfirm(arg0_149, arg1_149)
			end

			local function var1_148()
				arg0_145:HideLevelInfoSPPanel()
			end

			arg0_145.levelInfoSPView:SetChapterGroupInfo(arg2_145)
			arg0_145.levelInfoSPView:set(arg1_145, arg3_145)
			arg0_145.levelInfoSPView:setCBFunc(var0_148, var1_148)
			arg0_145.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_151)
	if arg0_151.levelInfoSPView and arg0_151.levelInfoSPView:isShowing() then
		arg0_151.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_152)
	if not arg0_152.levelInfoSPView then
		return
	end

	arg0_152.levelInfoSPView:Destroy()

	arg0_152.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_153, arg1_153)
	local var0_153 = arg0_153.contextData.selectedFleetIDs or arg1_153:GetDefaultFleetIndex()

	arg1_153 = Clone(arg1_153)
	arg1_153.loopFlag = arg0_153.contextData.chapterLoopFlag

	arg0_153.levelFleetView:updateSpecialOperationTickets(arg0_153.spTickets)
	arg0_153.levelFleetView:Load()
	arg0_153.levelFleetView:ActionInvoke("setHardShipVOs", arg0_153.shipVOs)
	arg0_153.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_153.openedCommanerSystem)
	arg0_153.levelFleetView:ActionInvoke("set", arg1_153, arg0_153.fleets, var0_153)
	arg0_153.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_154)
	if arg0_154.levelCMDFormationView:isShowing() then
		arg0_154.levelCMDFormationView:Hide()
	end

	if arg0_154.levelFleetView then
		arg0_154.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_155)
	arg0_155.levelCMDFormationView = LevelCMDFormationView.New(arg0_155.topPanel, arg0_155.event, arg0_155.contextData)
end

function var0_0.destroyFleetSelect(arg0_156)
	if not arg0_156.levelFleetView then
		return
	end

	arg0_156.levelFleetView:Destroy()

	arg0_156.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_157, arg1_157)
	arg1_157 = Clone(arg1_157)
	arg1_157.loopFlag = arg0_157.contextData.chapterLoopFlag

	arg0_157.levelFleetView:updateSpecialOperationTickets(arg0_157.spTickets)
	arg0_157.levelFleetView:Load()
	arg0_157.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_157.openedCommanerSystem)
	arg0_157.levelFleetView:ActionInvoke("setHardShipVOs", arg0_157.shipVOs)
	arg0_157.levelFleetView:ActionInvoke("setOnHard", arg1_157)
	arg0_157.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_158)
	arg0_158:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_159)
	arg0_159:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_160, arg1_160)
	if not arg0_160.levelFleetView then
		return
	end

	assert(arg0_160.levelFleetView:GetLoaded())

	local var0_160 = arg0_160.levelFleetView:IsSelectMode()
	local var1_160

	if var0_160 then
		arg0_160.levelFleetView:ActionInvoke("set", arg1_160 or arg0_160.levelFleetView.chapter, arg0_160.fleets, arg0_160.levelFleetView:getSelectIds())

		if arg0_160.levelCMDFormationView:isShowing() then
			local var2_160 = arg0_160.levelCMDFormationView.fleet.id

			var1_160 = arg0_160.fleets[var2_160]
		end
	else
		arg0_160.levelFleetView:ActionInvoke("setOnHard", arg1_160 or arg0_160.levelFleetView.chapter)

		if arg0_160.levelCMDFormationView:isShowing() then
			local var3_160 = arg0_160.levelCMDFormationView.fleet.id

			var1_160 = arg1_160:wrapEliteFleet(var3_160)
		end
	end

	if var1_160 then
		arg0_160.levelCMDFormationView:ActionInvoke("updateFleet", var1_160)
	end
end

function var0_0.setChapter(arg0_161, arg1_161)
	local var0_161

	if arg1_161 then
		var0_161 = arg1_161.id
	end

	arg0_161.contextData.chapterId = var0_161
	arg0_161.contextData.chapterVO = arg1_161
end

function var0_0.switchToChapter(arg0_162, arg1_162)
	if arg0_162.contextData.mapIdx ~= arg1_162:getConfig("map") then
		arg0_162:setMap(arg1_162:getConfig("map"))
	end

	arg0_162:setChapter(arg1_162)

	arg0_162.leftCanvasGroup.blocksRaycasts = false
	arg0_162.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_162.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_162:DestroyLevelStageView()

	if not arg0_162.levelStageView then
		arg0_162.levelStageView = LevelStageView.New(arg0_162.topPanel, arg0_162.event, arg0_162.contextData)

		arg0_162.levelStageView:Load()

		arg0_162.levelStageView.isFrozen = arg0_162:isfrozen()
	end

	arg0_162:frozen()

	local function var0_162()
		seriesAsync({
			function(arg0_164)
				arg0_162.mapBuilder:CallbackInvoke(arg0_164)
			end,
			function(arg0_165)
				setActive(arg0_162.clouds, false)
				arg0_162.mapBuilder:HideFloat()
				pg.UIMgr.GetInstance():BlurPanel(arg0_162.topPanel, false, {
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
				arg0_162.levelStageView:updateStageInfo()
				arg0_162.levelStageView:updateAmbushRate(arg1_162.fleet.line, true)
				arg0_162.levelStageView:updateStageAchieve()
				arg0_162.levelStageView:updateStageBarrier()
				arg0_162.levelStageView:updateBombPanel()
				arg0_162.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_165)
			end,
			function(arg0_166)
				if arg0_162.exited then
					return
				end

				arg0_162.levelStageView:updateStageStrategy()

				arg0_162.canvasGroup.blocksRaycasts = arg0_162.frozenCount == 0

				onNextTick(arg0_166)
			end,
			function(arg0_167)
				if arg0_162.exited then
					return
				end

				arg0_162.levelStageView:updateStageFleet()
				arg0_162.levelStageView:updateSupportFleet()
				arg0_162.levelStageView:updateFleetBuff()
				onNextTick(arg0_167)
			end,
			function(arg0_168)
				if arg0_162.exited then
					return
				end

				parallelAsync({
					function(arg0_169)
						local var0_169 = arg1_162:getConfig("scale")
						local var1_169 = LeanTween.value(go(arg0_162.map), arg0_162.map.localScale, Vector3.New(var0_169[3], var0_169[3], 1), var1_0):setOnUpdateVector3(function(arg0_170)
							arg0_162.map.localScale = arg0_170
							arg0_162.float.localScale = arg0_170
						end):setOnComplete(System.Action(function()
							arg0_162.mapBuilder:ShowFloat()
							arg0_162.mapBuilder:Hide()
							arg0_169()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_162:RecordTween("mapScale", var1_169.uniqueId)

						local var2_169 = LeanTween.value(go(arg0_162.map), arg0_162.map.pivot, Vector2.New(math.clamp(var0_169[1] - 0.5, 0, 1), math.clamp(var0_169[2] - 0.5, 0, 1)), var1_0)

						var2_169:setOnUpdateVector2(function(arg0_172)
							arg0_162.map.pivot = arg0_172
							arg0_162.float.pivot = arg0_172
						end):setEase(LeanTweenType.easeOutSine)
						arg0_162:RecordTween("mapPivot", var2_169.uniqueId)
						shiftPanel(arg0_162.leftChapter, -arg0_162.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_162.rightChapter, arg0_162.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_162.topChapter, 0, arg0_162.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_162.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_173)
						arg0_162:PlayBGM()

						local var0_173 = {}
						local var1_173 = arg1_162:getConfig("bg")

						if var1_173 and #var1_173 > 0 then
							var0_173[1] = {
								BG = var1_173
							}
						end

						arg0_162:SwitchBG(var0_173, arg0_173)
					end
				}, function()
					onNextTick(arg0_168)
				end)
			end,
			function(arg0_175)
				if arg0_162.exited then
					return
				end

				setActive(arg0_162.topChapter, false)
				setActive(arg0_162.leftChapter, false)
				setActive(arg0_162.rightChapter, false)

				arg0_162.leftCanvasGroup.blocksRaycasts = true
				arg0_162.rightCanvasGroup.blocksRaycasts = true

				arg0_162:initGrid(arg0_175)
			end,
			function(arg0_176)
				if arg0_162.exited then
					return
				end

				arg0_162.levelStageView:SetGrid(arg0_162.grid)

				arg0_162.contextData.huntingRangeVisibility = arg0_162.contextData.huntingRangeVisibility - 1

				arg0_162.grid:toggleHuntingRange()

				local var0_176 = arg1_162:getConfig("pop_pic")

				if var0_176 and #var0_176 > 0 and arg0_162.FirstEnterChapter == arg1_162.id then
					arg0_162:doPlayAnim(var0_176, function(arg0_177)
						setActive(arg0_177, false)

						if arg0_162.exited then
							return
						end

						arg0_176()
					end)
				else
					arg0_176()
				end
			end,
			function(arg0_178)
				arg0_162.levelStageView:tryAutoAction(arg0_178)
			end,
			function(arg0_179)
				if arg0_162.exited then
					return
				end

				arg0_162:unfrozen()

				if arg0_162.FirstEnterChapter then
					arg0_162:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_162.subAutoAttack)
				end

				arg0_162.FirstEnterChapter = nil

				arg0_162.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0_162.levelStageView:ActionInvoke("SetSeriesOperation", var0_162)
	arg0_162.levelStageView:ActionInvoke("SetPlayer", arg0_162.player)
	arg0_162.levelStageView:ActionInvoke("SwitchToChapter", arg1_162)
end

function var0_0.switchToMap(arg0_180, arg1_180)
	arg0_180:frozen()
	arg0_180:destroyGrid()
	arg0_180:setChapter(nil)
	LeanTween.cancel(go(arg0_180.map))

	local var0_180 = LeanTween.value(go(arg0_180.map), arg0_180.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_181)
		arg0_180.map.localScale = arg0_181
		arg0_180.float.localScale = arg0_181
	end):setOnComplete(System.Action(function()
		arg0_180:unfrozen()
		existCall(arg1_180)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_180:RecordTween("mapScale", var0_180.uniqueId)

	local var1_180 = arg0_180.contextData.map:getConfig("anchor")
	local var2_180

	if var1_180 == "" then
		var2_180 = Vector2.zero
	else
		var2_180 = Vector2(unpack(var1_180))
	end

	local var3_180 = LeanTween.value(go(arg0_180.map), arg0_180.map.pivot, var2_180, var1_0)

	var3_180:setOnUpdateVector2(function(arg0_183)
		arg0_180.map.pivot = arg0_183
		arg0_180.float.pivot = arg0_183
	end):setEase(LeanTweenType.easeOutSine)
	arg0_180:RecordTween("mapPivot", var3_180.uniqueId)
	setActive(arg0_180.topChapter, true)
	setActive(arg0_180.leftChapter, true)
	setActive(arg0_180.rightChapter, true)
	shiftPanel(arg0_180.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_180.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_180.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_180.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_180.levelStageView then
		arg0_180.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_180:DestroyLevelStageView()
		end)
		arg0_180.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_180:SwitchMapBG(arg0_180.contextData.map)
	arg0_180:PlayBGM()
	seriesAsync({
		function(arg0_185)
			arg0_180.mapBuilder:CallbackInvoke(arg0_185)
		end,
		function(arg0_186)
			arg0_180.mapBuilder:Show()
			arg0_180.mapBuilder:UpdateView()
			arg0_180.mapBuilder:UpdateMapItems()
		end
	})
	pg.UIMgr.GetInstance():UnblurPanel(arg0_180.topPanel, arg0_180._tf)
	pg.playerResUI:SetActive({
		active = false
	})

	arg0_180.canvasGroup.blocksRaycasts = arg0_180.frozenCount == 0
	arg0_180.canvasGroup.interactable = true

	if arg0_180.ambushWarning and arg0_180.ambushWarning.activeSelf then
		arg0_180.ambushWarning:SetActive(false)
		arg0_180:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_187, arg1_187, arg2_187, arg3_187)
	if not arg1_187 or #arg1_187 <= 0 then
		existCall(arg2_187)

		return
	elseif arg3_187 then
		-- block empty
	elseif table.equal(arg0_187.currentBG, arg1_187) then
		return
	end

	arg0_187.currentBG = arg1_187

	for iter0_187, iter1_187 in ipairs(arg0_187.mapGroup) do
		arg0_187.loader:ClearRequest(iter1_187)
	end

	table.clear(arg0_187.mapGroup)

	local var0_187 = {}

	table.ParallelIpairsAsync(arg1_187, function(arg0_188, arg1_188, arg2_188)
		local var0_188 = arg0_187.mapTFs[arg0_188]
		local var1_188 = arg1_188.bgPrefix and arg1_188.bgPrefix .. "/" or "levelmap/"
		local var2_188 = arg0_187.loader:GetSpriteDirect(var1_188 .. arg1_188.BG, "", function(arg0_189)
			var0_187[arg0_188] = arg0_189

			arg2_188()
		end, var0_188)

		table.insert(arg0_187.mapGroup, var2_188)
		arg0_187:updateCouldAnimator(arg1_188.Animator, arg0_188)
	end, function()
		for iter0_190, iter1_190 in ipairs(arg0_187.mapTFs) do
			setImageSprite(iter1_190, var0_187[iter0_190])
			setActive(iter1_190, arg1_187[iter0_190])
			SetCompomentEnabled(iter1_190, typeof(Image), true)
		end

		existCall(arg2_187)
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

function var0_0.ClearMapTransitions(arg0_191)
	if not arg0_191.mapTransitions then
		return
	end

	for iter0_191, iter1_191 in pairs(arg0_191.mapTransitions) do
		if iter1_191 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_191, iter0_191, iter1_191, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_191, iter0_191)
		end
	end

	arg0_191.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_192, arg1_192, arg2_192, arg3_192)
	local var0_192, var1_192, var2_192 = arg0_192:GetMapBG(arg1_192, arg2_192)

	if not var1_192 then
		arg0_192:SwitchBG(var0_192, nil, arg3_192)

		return
	end

	arg0_192:PlayMapTransition("LevelMapTransition_" .. var1_192, var2_192, function()
		arg0_192:SwitchBG(var0_192, nil, arg3_192)
	end)
end

function var0_0.GetMapBG(arg0_194, arg1_194, arg2_194)
	if not table.contains(var7_0, arg1_194.id) then
		return {
			arg0_194:GetMapElement(arg1_194)
		}
	end

	local var0_194 = arg1_194.id
	local var1_194 = table.indexof(var7_0, var0_194) - 1
	local var2_194 = bit.lshift(bit.rshift(var1_194, 1), 1) + 1
	local var3_194 = {
		var7_0[var2_194],
		var7_0[var2_194 + 1]
	}
	local var4_194 = _.map(var3_194, function(arg0_195)
		return getProxy(ChapterProxy):getMapById(arg0_195)
	end)

	if _.all(var4_194, function(arg0_196)
		return arg0_196:isAllChaptersClear()
	end) then
		local var5_194 = {
			arg0_194:GetMapElement(arg1_194)
		}

		if not arg2_194 or math.abs(var0_194 - arg2_194) ~= 1 then
			return var5_194
		end

		local var6_194 = var9_0[bit.rshift(var2_194 - 1, 1) + 1]
		local var7_194 = bit.band(var1_194, 1) == 1

		return var5_194, var6_194, var7_194
	else
		local var8_194 = 0

		;(function()
			local var0_197 = var4_194[1]:getChapters()

			for iter0_197, iter1_197 in ipairs(var0_197) do
				if not iter1_197:isClear() then
					return
				end

				var8_194 = var8_194 + 1
			end

			if not var4_194[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_194 = var8_194 + 1

			local var1_197 = var4_194[2]:getChapters()

			for iter2_197, iter3_197 in ipairs(var1_197) do
				if not iter3_197:isClear() then
					return
				end

				var8_194 = var8_194 + 1
			end
		end)()

		local var9_194

		if var8_194 > 0 then
			local var10_194 = var8_0[bit.rshift(var2_194 - 1, 1) + 1]

			var9_194 = {
				{
					BG = "map_" .. var10_194[1],
					Animator = var10_194[2]
				},
				{
					BG = "map_" .. var10_194[3] + var8_194,
					Animator = var10_194[4]
				}
			}
		else
			var9_194 = {
				arg0_194:GetMapElement(arg1_194)
			}
		end

		return var9_194
	end
end

function var0_0.GetMapElement(arg0_198, arg1_198)
	local var0_198 = arg1_198:getConfig("bg")
	local var1_198 = arg1_198:getConfig("ani_controller")

	if var1_198 and #var1_198 > 0 then
		(function()
			for iter0_199, iter1_199 in ipairs(var1_198) do
				local var0_199 = _.rest(iter1_199[2], 2)

				for iter2_199, iter3_199 in ipairs(var0_199) do
					if string.find(iter3_199, "^map_") and iter1_199[1] == var3_0 then
						local var1_199 = iter1_199[2][1]
						local var2_199 = getProxy(ChapterProxy):GetChapterItemById(var1_199)

						if var2_199 and not var2_199:isClear() then
							var0_198 = iter3_199

							return
						end
					end
				end
			end
		end)()
	end

	local var2_198 = {
		BG = var0_198
	}

	var2_198.Animator, var2_198.AnimatorController = arg0_198:GetMapAnimator(arg1_198)

	return var2_198
end

function var0_0.GetMapAnimator(arg0_200, arg1_200)
	local var0_200 = arg1_200:getConfig("ani_name")

	if arg1_200:getConfig("animtor") == 1 and var0_200 and #var0_200 > 0 then
		local var1_200 = arg1_200:getConfig("ani_controller")

		if var1_200 and #var1_200 > 0 then
			(function()
				for iter0_201, iter1_201 in ipairs(var1_200) do
					local var0_201 = _.rest(iter1_201[2], 2)

					for iter2_201, iter3_201 in ipairs(var0_201) do
						if string.find(iter3_201, "^effect_") and iter1_201[1] == var3_0 then
							local var1_201 = iter1_201[2][1]
							local var2_201 = getProxy(ChapterProxy):GetChapterItemById(var1_201)

							if var2_201 and not var2_201:isClear() then
								var0_200 = "map_" .. string.sub(iter3_201, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_200, var1_200
	end
end

function var0_0.PlayMapTransition(arg0_202, arg1_202, arg2_202, arg3_202, arg4_202)
	arg0_202.mapTransitions = arg0_202.mapTransitions or {}

	local var0_202

	local function var1_202()
		arg0_202:frozen()
		existCall(arg3_202, var0_202)
		var0_202:SetActive(true)

		local var0_203 = tf(var0_202)

		pg.UIMgr.GetInstance():OverlayPanel(var0_203, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		var0_202:GetComponent(typeof(Animator)):Play(arg2_202 and "Sequence" or "Inverted", -1, 0)
		var0_203:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_204)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_203, arg0_202._tf)
			existCall(arg4_202, var0_202)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_202, arg1_202, var0_202)

			arg0_202.mapTransitions[arg1_202] = false

			arg0_202:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_202, arg1_202, true, function(arg0_205)
		var0_202 = arg0_205
		arg0_202.mapTransitions[arg1_202] = arg0_205

		var1_202()
	end)
end

function var0_0.DestroyLevelStageView(arg0_206)
	if arg0_206.levelStageView then
		arg0_206.levelStageView:Destroy()

		arg0_206.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_207, arg1_207)
	arg0_207.levelAmbushView = LevelAmbushView.New(arg0_207.topPanel, arg0_207.event, arg0_207.contextData)

	arg0_207.levelAmbushView:Load()
	arg0_207.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_207)
end

function var0_0.hideAmbushInfo(arg0_208)
	if arg0_208.levelAmbushView then
		arg0_208.levelAmbushView:Destroy()

		arg0_208.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_209, arg1_209)
	arg0_209:frozen()

	local function var0_209()
		arg0_209.ambushWarning:SetActive(true)

		local var0_210 = tf(arg0_209.ambushWarning)

		var0_210:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_210:SetSiblingIndex(1)

		local var1_210 = var0_210:GetComponent("DftAniEvent")

		var1_210:SetTriggerEvent(function(arg0_211)
			arg1_209()
		end)
		var1_210:SetEndEvent(function(arg0_212)
			arg0_209.ambushWarning:SetActive(false)
			arg0_209:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_209.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_214)
			arg0_214:SetActive(true)

			arg0_209.ambushWarning = arg0_214

			var0_209()
		end)
	else
		var0_209()
	end
end

function var0_0.destroyAmbushWarn(arg0_215)
	if arg0_215.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_215.ambushWarning)

		arg0_215.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_216, arg1_216)
	arg0_216.levelStrategyView = LevelStrategyView.New(arg0_216.topPanel, arg0_216.event, arg0_216.contextData)

	arg0_216.levelStrategyView:Load()
	arg0_216.levelStrategyView:ActionInvoke("set", arg1_216)

	local function var0_216()
		local var0_217 = arg0_216.contextData.chapterVO.fleet
		local var1_217 = pg.strategy_data_template[arg1_216.id]

		if not var0_217:canUseStrategy(arg1_216) then
			return
		end

		local var2_217 = var0_217:getNextStgUser(arg1_216.id)

		if var1_217.type == ChapterConst.StgTypeForm then
			arg0_216:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_217,
				arg1 = arg1_216.id
			})
		elseif var1_217.type == ChapterConst.StgTypeConsume then
			arg0_216:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_217,
				arg1 = arg1_216.id
			})
		end

		arg0_216:hideStrategyInfo()
	end

	local function var1_216()
		arg0_216:hideStrategyInfo()
	end

	arg0_216.levelStrategyView:ActionInvoke("setCBFunc", var0_216, var1_216)
end

function var0_0.hideStrategyInfo(arg0_219)
	if arg0_219.levelStrategyView then
		arg0_219.levelStrategyView:Destroy()

		arg0_219.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_220, arg1_220)
	local var0_220 = arg0_220.contextData.chapterVO
	local var1_220 = getProxy(ChapterProxy)
	local var2_220
	local var3_220
	local var4_220
	local var5_220
	local var6_220 = var1_220.repairTimes
	local var7_220, var8_220, var9_220 = ChapterConst.GetRepairParams()

	arg0_220.levelRepairView = LevelRepairView.New(arg0_220.topPanel, arg0_220.event, arg0_220.contextData)

	arg0_220.levelRepairView:Load()
	arg0_220.levelRepairView:ActionInvoke("set", var6_220, var7_220, var8_220, var9_220)

	local function var10_220()
		if var7_220 - math.min(var6_220, var7_220) == 0 and arg0_220.player:getTotalGem() < var9_220 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_220:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_220.fleet.id,
			arg1 = arg1_220.id
		})
		arg0_220:hideRepairWindow()
	end

	local function var11_220()
		arg0_220:hideRepairWindow()
	end

	arg0_220.levelRepairView:ActionInvoke("setCBFunc", var10_220, var11_220)
end

function var0_0.hideRepairWindow(arg0_223)
	if arg0_223.levelRepairView then
		arg0_223.levelRepairView:Destroy()

		arg0_223.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_224, arg1_224)
	arg0_224.levelRemasterView:Load()

	local function var0_224(arg0_225)
		arg0_224:ShowSelectedMap(arg0_225)
	end

	arg0_224.levelRemasterView:ActionInvoke("Show")
	arg0_224.levelRemasterView:ActionInvoke("set", var0_224, arg1_224)
end

function var0_0.hideRemasterPanel(arg0_226)
	if arg0_226.levelRemasterView:isShowing() then
		arg0_226.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_227, arg1_227)
	local var0_227 = arg0_227.contextData.chapterVO

	if not var0_227 then
		return
	end

	arg0_227:enableLevelCamera()
	setActive(arg0_227.uiMain, true)

	arg0_227.levelGrid.localEulerAngles = Vector3(var0_227.theme.angle, 0, 0)
	arg0_227.grid = LevelGrid.New(arg0_227.dragLayer)

	arg0_227.grid:attach(arg0_227)
	arg0_227.grid:ExtendItem("shipTpl", arg0_227.shipTpl)
	arg0_227.grid:ExtendItem("subTpl", arg0_227.subTpl)
	arg0_227.grid:ExtendItem("transportTpl", arg0_227.transportTpl)
	arg0_227.grid:ExtendItem("enemyTpl", arg0_227.enemyTpl)
	arg0_227.grid:ExtendItem("championTpl", arg0_227.championTpl)
	arg0_227.grid:ExtendItem("oniTpl", arg0_227.oniTpl)
	arg0_227.grid:ExtendItem("arrowTpl", arg0_227.arrowTarget)
	arg0_227.grid:ExtendItem("destinationMarkTpl", arg0_227.destinationMarkTpl)

	function arg0_227.grid.onShipStepChange(arg0_228)
		arg0_227.levelStageView:updateAmbushRate(arg0_228)
	end

	arg0_227.grid:initAll(arg1_227)
end

function var0_0.destroyGrid(arg0_229)
	if arg0_229.grid then
		arg0_229.grid:detach()

		arg0_229.grid = nil

		arg0_229:disableLevelCamera()
		setActive(arg0_229.dragLayer, true)
		setActive(arg0_229.uiMain, false)
	end
end

function var0_0.doTracking(arg0_230, arg1_230)
	arg0_230:frozen()

	local function var0_230()
		arg0_230.radar:SetActive(true)

		local var0_231 = tf(arg0_230.radar)

		var0_231:SetParent(arg0_230.topPanel, false)
		var0_231:SetSiblingIndex(1)
		var0_231:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_232)
			arg0_230.radar:SetActive(false)
			arg0_230:unfrozen()
			arg1_230()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_230.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_233)
			arg0_233:SetActive(true)

			arg0_230.radar = arg0_233

			var0_230()
		end)
	else
		var0_230()
	end
end

function var0_0.destroyTracking(arg0_234)
	if arg0_234.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_234.radar)

		arg0_234.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_235, arg1_235, arg2_235, arg3_235)
	local function var0_235()
		arg0_235.playing = true

		arg0_235:frozen()
		arg0_235.airStrike:SetActive(true)

		local var0_236 = tf(arg0_235.airStrike)

		var0_236:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_236:SetAsLastSibling()
		setActive(var0_236:Find("words/be_striked"), arg1_235 == ChapterConst.SubjectChampion)
		setActive(var0_236:Find("words/strike_enemy"), arg1_235 == ChapterConst.SubjectPlayer)

		local function var1_236()
			arg0_235.playing = false

			SetActive(arg0_235.airStrike, false)

			if arg3_235 then
				arg3_235()
			end

			arg0_235:unfrozen()
		end

		var0_236:GetComponent("DftAniEvent"):SetEndEvent(var1_236)

		if arg2_235 then
			onButton(arg0_235, var0_236, var1_236, SFX_PANEL)
		else
			removeOnButton(var0_236)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_235.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_238)
			arg0_238:SetActive(true)

			arg0_235.airStrike = arg0_238

			var0_235()
		end)
	else
		var0_235()
	end
end

function var0_0.destroyAirStrike(arg0_239)
	if arg0_239.airStrike then
		arg0_239.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_239.airStrike)

		arg0_239.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_240, arg1_240, arg2_240, arg3_240)
	arg0_240.uiAnims = arg0_240.uiAnims or {}

	local var0_240 = arg0_240.uiAnims[arg1_240]

	local function var1_240()
		arg0_240.playing = true

		arg0_240:frozen()
		var0_240:SetActive(true)

		local var0_241 = tf(var0_240)

		pg.UIMgr.GetInstance():OverlayPanel(var0_241, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_240 then
			arg3_240(var0_240)
		end

		var0_241:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_242)
			arg0_240.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_241, arg0_240._tf)

			if arg2_240 then
				arg2_240(var0_240)
			end

			arg0_240:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_240 then
		PoolMgr.GetInstance():GetUI(arg1_240, true, function(arg0_243)
			arg0_243:SetActive(true)

			arg0_240.uiAnims[arg1_240] = arg0_243
			var0_240 = arg0_240.uiAnims[arg1_240]

			var1_240()
		end)
	else
		var1_240()
	end
end

function var0_0.destroyUIAnims(arg0_244)
	if arg0_244.uiAnims then
		for iter0_244, iter1_244 in pairs(arg0_244.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_244), arg0_244._tf)
			iter1_244:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_244, iter1_244)
		end

		arg0_244.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_245, arg1_245)
	local function var0_245()
		arg0_245.playing = true

		arg0_245:frozen()
		arg0_245.torpetoAni:SetActive(true)

		local var0_246 = tf(arg0_245.torpetoAni)

		var0_246:SetParent(arg0_245.topPanel, false)
		var0_246:SetAsLastSibling()
		var0_246:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_247)
			arg0_245.playing = false

			SetActive(arg0_245.torpetoAni, false)

			if arg1_245 then
				arg1_245()
			end

			arg0_245:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_245.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_248)
			arg0_248:SetActive(true)

			arg0_245.torpetoAni = arg0_248

			var0_245()
		end)
	else
		var0_245()
	end
end

function var0_0.destroyTorpedo(arg0_249)
	if arg0_249.torpetoAni then
		arg0_249.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_249.torpetoAni)

		arg0_249.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_250, arg1_250, arg2_250, arg3_250)
	arg0_250.strikeAnims = arg0_250.strikeAnims or {}

	local var0_250
	local var1_250
	local var2_250

	local function var3_250()
		if coroutine.status(var2_250) == "suspended" then
			local var0_251, var1_251 = coroutine.resume(var2_250)

			assert(var0_251, debug.traceback(var2_250, var1_251))
		end
	end

	var2_250 = coroutine.create(function()
		arg0_250.playing = true

		arg0_250:frozen()

		local var0_252 = arg0_250.strikeAnims[arg2_250]

		setActive(var0_252, true)

		local var1_252 = tf(var0_252)
		local var2_252 = findTF(var1_252, "torpedo")
		local var3_252 = findTF(var1_252, "mask/painting")
		local var4_252 = findTF(var1_252, "ship")

		setParent(var0_250, var3_252:Find("fitter"), false)
		setParent(var1_250, var4_252, false)
		setActive(var4_252, false)
		setActive(var2_252, false)
		var1_252:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_252:SetAsLastSibling()

		local var5_252 = var1_252:GetComponent("DftAniEvent")
		local var6_252 = var1_250:GetComponent("SpineAnimUI")
		local var7_252 = var6_252:GetComponent("SkeletonGraphic")

		var5_252:SetStartEvent(function(arg0_253)
			var6_252:SetAction("attack", 0)

			var7_252.freeze = true
		end)
		var5_252:SetTriggerEvent(function(arg0_254)
			var7_252.freeze = false

			var6_252:SetActionCallBack(function(arg0_255)
				if arg0_255 == "action" then
					-- block empty
				elseif arg0_255 == "finish" then
					var7_252.freeze = true
				end
			end)
		end)
		var5_252:SetEndEvent(function(arg0_256)
			var7_252.freeze = false

			var3_250()
		end)
		onButton(arg0_250, var1_252, var3_250, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_252, arg1_250:getPainting())
		var6_252:SetActionCallBack(nil)

		var7_252.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_250:getPrefab(), var1_250)
		setActive(var0_252, false)

		arg0_250.playing = false

		arg0_250:unfrozen()

		if arg3_250 then
			arg3_250()
		end
	end)

	local function var4_250()
		if arg0_250.strikeAnims[arg2_250] and var0_250 and var1_250 then
			var3_250()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_250:getPainting(), true, function(arg0_258)
		var0_250 = arg0_258

		ShipExpressionHelper.SetExpression(var0_250, arg1_250:getPainting())
		var4_250()
	end)
	PoolMgr.GetInstance():GetSpineChar(arg1_250:getPrefab(), true, function(arg0_259)
		var1_250 = arg0_259
		var1_250.transform.localScale = Vector3.one

		var4_250()
	end)

	if not arg0_250.strikeAnims[arg2_250] then
		PoolMgr.GetInstance():GetUI(arg2_250, true, function(arg0_260)
			arg0_250.strikeAnims[arg2_250] = arg0_260

			var4_250()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_261)
	if arg0_261.strikeAnims then
		for iter0_261, iter1_261 in pairs(arg0_261.strikeAnims) do
			iter1_261:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_261, iter1_261)
		end

		arg0_261.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_262, arg1_262, arg2_262, arg3_262)
	arg0_262.strikeAnims = arg0_262.strikeAnims or {}

	local var0_262
	local var1_262

	local function var2_262()
		if coroutine.status(var1_262) == "suspended" then
			local var0_263, var1_263 = coroutine.resume(var1_262)

			assert(var0_263, debug.traceback(var1_262, var1_263))
		end
	end

	var1_262 = coroutine.create(function()
		arg0_262.playing = true

		arg0_262:frozen()

		local var0_264 = arg0_262.strikeAnims[arg2_262]

		setActive(var0_264, true)

		local var1_264 = tf(var0_264)
		local var2_264 = findTF(var1_264, "torpedo")
		local var3_264 = findTF(var1_264, "ship")

		setParent(var0_262, var3_264, false)
		setActive(var3_264, false)
		setActive(var2_264, false)
		var1_264:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_264:SetAsLastSibling()

		local var4_264 = var1_264:GetComponent("DftAniEvent")
		local var5_264 = var0_262:GetComponent("SpineAnimUI")
		local var6_264 = var5_264:GetComponent("SkeletonGraphic")

		var4_264:SetStartEvent(function(arg0_265)
			var5_264:SetAction("attack", 0)

			var6_264.freeze = true
		end)
		var4_264:SetTriggerEvent(function(arg0_266)
			var6_264.freeze = false

			var5_264:SetActionCallBack(function(arg0_267)
				if arg0_267 == "action" then
					-- block empty
				elseif arg0_267 == "finish" then
					var6_264.freeze = true
				end
			end)
		end)
		var4_264:SetEndEvent(function(arg0_268)
			var6_264.freeze = false

			var2_262()
		end)
		onButton(arg0_262, var1_264, var2_262, SFX_CANCEL)
		coroutine.yield()
		var5_264:SetActionCallBack(nil)

		var6_264.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_262:getPrefab(), var0_262)
		setActive(var0_264, false)

		arg0_262.playing = false

		arg0_262:unfrozen()

		if arg3_262 then
			arg3_262()
		end
	end)

	local function var3_262()
		if arg0_262.strikeAnims[arg2_262] and var0_262 then
			var2_262()
		end
	end

	PoolMgr.GetInstance():GetSpineChar(arg1_262:getPrefab(), true, function(arg0_270)
		var0_262 = arg0_270
		var0_262.transform.localScale = Vector3.one

		var3_262()
	end)

	if not arg0_262.strikeAnims[arg2_262] then
		PoolMgr.GetInstance():GetUI(arg2_262, true, function(arg0_271)
			arg0_262.strikeAnims[arg2_262] = arg0_271

			var3_262()
		end)
	end
end

function var0_0.doPlayCommander(arg0_272, arg1_272, arg2_272)
	arg0_272:frozen()
	setActive(arg0_272.commanderTinkle, true)

	local var0_272 = arg1_272:getSkills()

	setText(arg0_272.commanderTinkle:Find("name"), #var0_272 > 0 and var0_272[1]:getConfig("name") or "")
	setImageSprite(arg0_272.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_272:getConfig("painting"), ""))

	local var1_272 = arg0_272.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_272.alpha = 0

	local var2_272 = Vector2(248, 237)

	LeanTween.value(go(arg0_272.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_273)
		local var0_273 = arg0_272.commanderTinkle.localPosition

		var0_273.x = var2_272.x + -100 * (1 - arg0_273)
		arg0_272.commanderTinkle.localPosition = var0_273
		var1_272.alpha = arg0_273
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_272.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_274)
		local var0_274 = arg0_272.commanderTinkle.localPosition

		var0_274.x = var2_272.x + 100 * arg0_274
		arg0_272.commanderTinkle.localPosition = var0_274
		var1_272.alpha = 1 - arg0_274
	end)):setOnComplete(System.Action(function()
		if arg2_272 then
			arg2_272()
		end

		arg0_272:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_276, arg1_276, arg2_276, arg3_276)
	local var0_276 = arg0_276.grid:shakeCell(arg1_276)

	if not var0_276 then
		arg3_276()

		return
	end

	arg0_276:easeDamage(var0_276, arg2_276, function()
		arg3_276()
	end)
end

function var0_0.easeDamage(arg0_278, arg1_278, arg2_278, arg3_278)
	arg0_278:frozen()

	local var0_278 = arg0_278.levelCam:WorldToScreenPoint(arg1_278.position)
	local var1_278 = tf(arg0_278:GetDamageText())

	var1_278.position = arg0_278.uiCam:ScreenToWorldPoint(var0_278)

	local var2_278 = var1_278.localPosition

	var2_278.y = var2_278.y + 40
	var2_278.z = 0

	setText(var1_278, arg2_278)

	var1_278.localPosition = var2_278

	LeanTween.value(go(var1_278), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_279)
		local var0_279 = var1_278.localPosition

		var0_279.y = var2_278.y + 60 * arg0_279
		var1_278.localPosition = var0_279

		setTextAlpha(var1_278, 1 - arg0_279)
	end)):setOnComplete(System.Action(function()
		arg0_278:ReturnDamageText(var1_278)
		arg0_278:unfrozen()

		if arg3_278 then
			arg3_278()
		end
	end))
end

function var0_0.easeAvoid(arg0_281, arg1_281, arg2_281)
	arg0_281:frozen()

	local var0_281 = arg0_281.levelCam:WorldToScreenPoint(arg1_281)

	arg0_281.avoidText.position = arg0_281.uiCam:ScreenToWorldPoint(var0_281)

	local var1_281 = arg0_281.avoidText.localPosition

	var1_281.z = 0
	arg0_281.avoidText.localPosition = var1_281

	setActive(arg0_281.avoidText, true)

	local var2_281 = arg0_281.avoidText:Find("avoid")

	LeanTween.value(go(arg0_281.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_282)
		local var0_282 = arg0_281.avoidText.localPosition

		var0_282.y = var1_281.y + 100 * arg0_282
		arg0_281.avoidText.localPosition = var0_282

		setImageAlpha(arg0_281.avoidText, 1 - arg0_282)
		setImageAlpha(var2_281, 1 - arg0_282)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_281.avoidText, false)
		arg0_281:unfrozen()

		if arg2_281 then
			arg2_281()
		end
	end))
end

function var0_0.GetDamageText(arg0_284)
	local var0_284 = table.remove(arg0_284.damageTextPool)

	if not var0_284 then
		var0_284 = Instantiate(arg0_284.damageTextTemplate)

		local var1_284 = tf(arg0_284.damageTextTemplate):GetSiblingIndex()

		setParent(var0_284, tf(arg0_284.damageTextTemplate).parent)
		tf(var0_284):SetSiblingIndex(var1_284 + 1)
	end

	table.insert(arg0_284.damageTextActive, var0_284)
	setActive(var0_284, true)

	return var0_284
end

function var0_0.ReturnDamageText(arg0_285, arg1_285)
	assert(arg1_285)

	if not arg1_285 then
		return
	end

	arg1_285 = go(arg1_285)

	table.removebyvalue(arg0_285.damageTextActive, arg1_285)
	table.insert(arg0_285.damageTextPool, arg1_285)
	setActive(arg1_285, false)
end

function var0_0.resetLevelGrid(arg0_286)
	arg0_286.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_287, arg1_287)
	setActive(arg0_287.curtain, arg1_287)
end

function var0_0.frozen(arg0_288)
	local var0_288 = arg0_288.frozenCount

	arg0_288.frozenCount = arg0_288.frozenCount + 1
	arg0_288.canvasGroup.blocksRaycasts = arg0_288.frozenCount == 0

	if var0_288 == 0 and arg0_288.frozenCount ~= 0 then
		arg0_288:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_289, arg1_289)
	if arg0_289.exited then
		return
	end

	local var0_289 = arg0_289.frozenCount
	local var1_289 = arg1_289 == -1 and arg0_289.frozenCount or arg1_289 or 1

	arg0_289.frozenCount = arg0_289.frozenCount - var1_289
	arg0_289.canvasGroup.blocksRaycasts = arg0_289.frozenCount == 0

	if var0_289 ~= 0 and arg0_289.frozenCount == 0 then
		arg0_289:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_290)
	return arg0_290.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_291)
	arg0_291.levelCamIndices = math.max(arg0_291.levelCamIndices - 1, 0)

	if arg0_291.levelCamIndices == 0 then
		arg0_291.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.disableLevelCamera(arg0_292)
	arg0_292.levelCamIndices = arg0_292.levelCamIndices + 1

	if arg0_292.levelCamIndices > 0 then
		arg0_292.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.RecordTween(arg0_293, arg1_293, arg2_293)
	arg0_293.tweens[arg1_293] = arg2_293
end

function var0_0.DeleteTween(arg0_294, arg1_294)
	local var0_294 = arg0_294.tweens[arg1_294]

	if var0_294 then
		LeanTween.cancel(var0_294)

		arg0_294.tweens[arg1_294] = nil
	end
end

function var0_0.openCommanderPanel(arg0_295, arg1_295, arg2_295, arg3_295)
	local var0_295 = arg2_295.id

	arg0_295.levelCMDFormationView:setCallback(function(arg0_296)
		if not arg3_295 then
			if arg0_296.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_295:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_296.skill)
			elseif arg0_296.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_295.contextData.commanderSelected = {
					chapterId = var0_295,
					fleetId = arg1_295.id
				}

				arg0_295:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_296.pos, arg1_295.id, arg2_295)
				arg0_295:closeCommanderPanel()
			else
				arg0_295:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_296,
					fleetId = arg1_295.id,
					chapterId = var0_295
				}, arg2_295)
			end
		elseif arg0_296.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_295:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_296.skill)
		elseif arg0_296.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_295.contextData.eliteCommanderSelected = {
				index = arg3_295,
				pos = arg0_296.pos,
				chapterId = var0_295
			}

			arg0_295:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_295, arg0_296.pos, arg2_295)
			arg0_295:closeCommanderPanel()
		else
			arg0_295:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_296,
				index = arg3_295,
				chapterId = var0_295
			}, arg2_295)
		end
	end)
	arg0_295.levelCMDFormationView:Load()
	arg0_295.levelCMDFormationView:ActionInvoke("update", arg1_295, arg0_295.commanderPrefabs)
	arg0_295.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_297)
	if arg0_297.levelCMDFormationView:isShowing() then
		arg0_297.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_297.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_298)
	arg0_298.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_299)
	arg0_299.levelCMDFormationView:Destroy()

	arg0_299.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_300, arg1_300)
	arg0_300.spTickets = arg1_300
end

function var0_0.HandleShowMsgBox(arg0_301, arg1_301)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_301)
end

function var0_0.updatePoisonAreaTip(arg0_302)
	local var0_302 = arg0_302.contextData.chapterVO
	local var1_302 = (function(arg0_303)
		local var0_303 = {}
		local var1_303 = pg.map_event_list[var0_302.id] or {}
		local var2_303

		if var0_302:isLoop() then
			var2_303 = var1_303.event_list_loop or {}
		else
			var2_303 = var1_303.event_list or {}
		end

		for iter0_303, iter1_303 in ipairs(var2_303) do
			local var3_303 = pg.map_event_template[iter1_303]

			if var3_303.c_type == arg0_303 then
				table.insert(var0_303, var3_303)
			end
		end

		return var0_303
	end)(ChapterConst.EvtType_Poison)

	if var1_302 then
		for iter0_302, iter1_302 in ipairs(var1_302) do
			local var2_302 = iter1_302.round_gametip

			if var2_302 ~= nil and var2_302 ~= "" and var0_302:getRoundNum() == var2_302[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_302[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_304)
	setActive(arg0_304._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_305)
	local var0_305 = getProxy(ChapterProxy)

	if var0_305 and not arg0_305.contextData.noRecord then
		local var1_305 = arg0_305.contextData.map

		if not var1_305 then
			return
		end

		if var1_305 and var1_305:NeedRecordMap() then
			var0_305:recordLastMap(ChapterProxy.LAST_MAP, var1_305.id)
		end

		if Map.lastMapForActivity then
			var0_305:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, Map.lastMapForActivity)
		end
	end
end

function var0_0.IsActShopActive(arg0_306)
	local var0_306 = pg.gameset.activity_res_id.key_value
	local var1_306 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var1_306 and not var1_306:isEnd() and var1_306:getConfig("config_client").resId == var0_306 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_307)
		return not arg0_307:isEnd() and arg0_307:getConfig("config_client").pt_id == var0_306
	end) then
		return true
	end
end

function var0_0.willExit(arg0_308)
	arg0_308:ClearMapTransitions()
	arg0_308.loader:Clear()

	if arg0_308.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_308.topPanel, arg0_308._tf)
		pg.playerResUI:SetActive({
			active = false
		})
	end

	if arg0_308.levelFleetView and arg0_308.levelFleetView.selectIds then
		arg0_308.contextData.selectedFleetIDs = {}

		for iter0_308, iter1_308 in pairs(arg0_308.levelFleetView.selectIds) do
			for iter2_308, iter3_308 in pairs(iter1_308) do
				arg0_308.contextData.selectedFleetIDs[#arg0_308.contextData.selectedFleetIDs + 1] = iter3_308
			end
		end
	end

	arg0_308:destroyChapterPanel()
	arg0_308:DestroyLevelInfoSPPanel()
	arg0_308:destroyFleetEdit()
	arg0_308:destroyCommanderPanel()
	arg0_308:DestroyLevelStageView()
	arg0_308:hideRepairWindow()
	arg0_308:hideStrategyInfo()
	arg0_308:hideRemasterPanel()
	arg0_308:hideSpResult()
	arg0_308:destroyGrid()
	arg0_308:destroyAmbushWarn()
	arg0_308:destroyAirStrike()
	arg0_308:destroyTorpedo()
	arg0_308:destroyStrikeAnim()
	arg0_308:destroyTracking()
	arg0_308:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_308, iter5_308 in pairs(arg0_308.mbDict) do
		iter5_308:Destroy()
	end

	arg0_308.mbDict = nil

	for iter6_308, iter7_308 in pairs(arg0_308.tweens) do
		LeanTween.cancel(iter7_308)
	end

	arg0_308.tweens = nil

	if arg0_308.cloudTimer then
		_.each(arg0_308.cloudTimer, function(arg0_309)
			LeanTween.cancel(arg0_309)
		end)

		arg0_308.cloudTimer = nil
	end

	if arg0_308.newChapterCDTimer then
		arg0_308.newChapterCDTimer:Stop()

		arg0_308.newChapterCDTimer = nil
	end

	for iter8_308, iter9_308 in ipairs(arg0_308.damageTextActive) do
		LeanTween.cancel(iter9_308)
	end

	LeanTween.cancel(go(arg0_308.avoidText))

	arg0_308.map.localScale = Vector3.one
	arg0_308.map.pivot = Vector2(0.5, 0.5)
	arg0_308.float.localScale = Vector3.one
	arg0_308.float.pivot = Vector2(0.5, 0.5)

	for iter10_308, iter11_308 in ipairs(arg0_308.mapTFs) do
		clearImageSprite(iter11_308)
	end

	_.each(arg0_308.cloudRTFs, function(arg0_310)
		clearImageSprite(arg0_310)
	end)
	PoolMgr.GetInstance():DestroyAllSprite()
	Destroy(arg0_308.enemyTpl)
	arg0_308:RecordLastMapOnExit()
	arg0_308.levelRemasterView:Destroy()
end

return var0_0
