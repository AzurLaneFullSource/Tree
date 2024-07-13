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
	arg0_11.mapBuilder = nil
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

	setActive(arg0_12.actNormalBtn, false)

	arg0_12.actEliteBtn = arg0_12:findTF("buttons/btn_act_elite", arg0_12.leftChapter)

	setActive(arg0_12.actEliteBtn, false)

	arg0_12.actExtraBtn = arg0_12:findTF("buttons/btn_act_extra", arg0_12.leftChapter)
	arg0_12.actExtraBtnAnim = arg0_12:findTF("usm", arg0_12.actExtraBtn)
	arg0_12.remasterBtn = arg0_12:findTF("buttons/btn_remaster", arg0_12.leftChapter)
	arg0_12.escortBar = arg0_12:findTF("escort_bar", arg0_12.leftChapter)

	setActive(arg0_12.escortBar, false)

	arg0_12.eliteQuota = arg0_12:findTF("elite_quota", arg0_12.leftChapter)

	setActive(arg0_12.eliteQuota, false)

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
	setActive(arg0_12.remasterAwardBtn, false)

	arg0_12.damageTextTemplate = go(arg0_12:findTF("damage", arg0_12.topPanel))

	setActive(arg0_12.damageTextTemplate, false)

	arg0_12.damageTextPool = {
		arg0_12.damageTextTemplate
	}
	arg0_12.damageTextActive = {}
	arg0_12.mapHelpBtn = arg0_12:findTF("help_button", arg0_12.topPanel)

	setActive(arg0_12.mapHelpBtn, false)

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
	local var0_70 = arg1_70:getConfig("map")

	if not arg0_70.contextData.chapterVO and arg0_70.contextData.mapIdx == var0_70 and bit.band(arg2_70, ChapterConst.DirtyMapItems) > 0 then
		arg0_70:updateMapItems()
	end

	if arg0_70.contextData.chapterVO and arg0_70.contextData.chapterVO.id == arg1_70.id and arg1_70.active then
		arg0_70:setChapter(arg1_70)
	end

	if arg0_70.contextData.chapterVO and arg0_70.contextData.chapterVO.id == arg1_70.id and arg1_70.active and arg0_70.levelStageView and arg0_70.grid then
		local var1_70 = false
		local var2_70 = false
		local var3_70 = false

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyFleet) > 0 then
			arg0_70.levelStageView:updateStageFleet()
			arg0_70.levelStageView:updateAmbushRate(arg1_70.fleet.line, true)

			var3_70 = true

			if arg0_70.grid then
				arg0_70.grid:RefreshFleetCells()
				arg0_70.grid:UpdateFloor()

				var1_70 = true
			end
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyChampion) > 0 then
			var3_70 = true

			if arg0_70.grid then
				arg0_70.grid:UpdateFleets()
				arg0_70.grid:clearChampions()
				arg0_70.grid:initChampions()

				var2_70 = true
			end
		elseif bit.band(arg2_70, ChapterConst.DirtyChampionPosition) > 0 then
			var3_70 = true

			if arg0_70.grid then
				arg0_70.grid:UpdateFleets()
				arg0_70.grid:updateChampions()

				var2_70 = true
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
					var1_70 = true
				end
			end
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyStrategy) > 0 then
			arg0_70.levelStageView:updateStageStrategy()

			var3_70 = true

			arg0_70.levelStageView:updateStageBarrier()
			arg0_70.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_70 < 0 or bit.band(arg2_70, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var1_70 then
			arg0_70.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var2_70 then
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

		if var3_70 then
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
	arg0_73:SwitchMapBG(arg0_73.contextData.map, arg0_73.lastMapIdx, true)
end

function var0_0.updateCouldAnimator(arg0_74, arg1_74, arg2_74)
	if arg1_74 then
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
end

function var0_0.updateMapItems(arg0_78)
	local var0_78 = arg0_78.contextData.map
	local var1_78 = var0_78:getConfig("cloud_suffix")

	if var1_78 == "" then
		setActive(arg0_78.clouds, false)
	else
		setActive(arg0_78.clouds, true)

		for iter0_78, iter1_78 in ipairs(var0_78:getConfig("clouds_pos")) do
			local var2_78 = arg0_78.cloudRTFs[iter0_78]
			local var3_78 = var2_78:GetComponent(typeof(Image))

			var3_78.enabled = false

			GetSpriteFromAtlasAsync("clouds/cloud_" .. iter0_78 .. "_" .. var1_78, "", function(arg0_79)
				if not arg0_78.exited and not IsNil(var3_78) and var0_78 == arg0_78.contextData.map then
					var3_78.enabled = true
					var3_78.sprite = arg0_79

					var3_78:SetNativeSize()

					arg0_78.cloudRects[iter0_78] = var2_78.rect.width
				end
			end)
		end
	end

	arg0_78.mapBuilder.buffer:UpdateMapItems(var0_78)
end

function var0_0.updateDifficultyBtns(arg0_80)
	local var0_80 = arg0_80.contextData.map:getConfig("type")

	setActive(arg0_80.normalBtn, var0_80 == Map.ELITE)
	setActive(arg0_80.eliteQuota, var0_80 == Map.ELITE)
	setActive(arg0_80.eliteBtn, var0_80 == Map.SCENARIO)

	local var1_80 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_80.eliteBtn:Find("pic_activity"), var1_80 and not var1_80:isEnd())
end

function var0_0.updateActivityBtns(arg0_81)
	local var0_81, var1_81 = arg0_81.contextData.map:isActivity()
	local var2_81 = arg0_81.contextData.map:isRemaster()
	local var3_81 = arg0_81.contextData.map:isSkirmish()
	local var4_81 = arg0_81.contextData.map:isEscort()
	local var5_81 = arg0_81.contextData.map:getConfig("type")
	local var6_81 = getProxy(ActivityProxy):GetEarliestActByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)
	local var7_81 = var6_81 and not var6_81:isEnd() and not var0_81 and not var3_81 and not var4_81

	if var7_81 then
		local var8_81 = setmetatable({}, MainActMapBtn)

		var8_81.image = arg0_81.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var8_81.subImage = arg0_81.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var8_81.tipTr = arg0_81.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var8_81.tipTxt = arg0_81.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var7_81 = var8_81:InShowTime()

		if var7_81 then
			var8_81:InitTipImage()
			var8_81:InitSubImage()
			var8_81:InitImage(function()
				return
			end)
			var8_81:OnInit()
		end
	end

	setActive(arg0_81.activityBtn, var7_81)
	arg0_81:updateRemasterInfo()

	if var0_81 and var1_81 then
		local var9_81 = getProxy(ChapterProxy):getMapsByActivities()
		local var10_81 = underscore.any(var9_81, function(arg0_83)
			return arg0_83:isActExtra()
		end)

		setActive(arg0_81.actExtraBtn, var10_81 and not var2_81 and var5_81 ~= Map.ACT_EXTRA)

		if isActive(arg0_81.actExtraBtn) then
			if underscore.all(underscore.filter(var9_81, function(arg0_84)
				local var0_84 = arg0_84:getMapType()

				return var0_84 == Map.ACTIVITY_EASY or var0_84 == Map.ACTIVITY_HARD
			end), function(arg0_85)
				return arg0_85:isAllChaptersClear()
			end) then
				setActive(arg0_81.actExtraBtnAnim, true)
			else
				setActive(arg0_81.actExtraBtnAnim, false)
			end

			setActive(arg0_81.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_81 = checkExist(arg0_81.contextData.map:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_81.actEliteBtn, var11_81 and var5_81 ~= Map.ACTIVITY_HARD)
		setActive(arg0_81.actNormalBtn, var5_81 ~= Map.ACTIVITY_EASY)
		setActive(arg0_81.actExtraRank, var5_81 == Map.ACT_EXTRA)
		setActive(arg0_81.actExchangeShopBtn, not var2_81 and var1_81 and not ActivityConst.HIDE_PT_PANELS)
		setActive(arg0_81.ptTotal, not var2_81 and var1_81 and not ActivityConst.HIDE_PT_PANELS and arg0_81.ptActivity and not arg0_81.ptActivity:isEnd())
		arg0_81:updateActivityRes()
	else
		setActive(arg0_81.actExtraBtn, false)
		setActive(arg0_81.actEliteBtn, false)
		setActive(arg0_81.actNormalBtn, false)
		setActive(arg0_81.actExtraRank, false)
		setActive(arg0_81.actExchangeShopBtn, false)
		setActive(arg0_81.actAtelierBuffBtn, false)
		setActive(arg0_81.ptTotal, false)
	end

	setActive(arg0_81.eventContainer, (not var0_81 or not var1_81) and not var4_81)
	setActive(arg0_81.remasterBtn, OPEN_REMASTER and (var2_81 or not var0_81 and not var4_81 and not var3_81))
	setActive(arg0_81.ticketTxt.parent, var2_81)
	arg0_81:updateRemasterTicket()
	arg0_81:updateCountDown()
	arg0_81:registerActBtn()

	if var0_81 and var5_81 ~= Map.ACT_EXTRA then
		Map.lastMapForActivity = arg0_81.contextData.mapIdx
	end
end

function var0_0.updateRemasterTicket(arg0_86)
	setText(arg0_86.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_86:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_87)
	local var0_87 = getProxy(ChapterProxy)
	local var1_87 = var0_87:ifShowRemasterTip() or var0_87:anyRemasterAwardCanReceive()

	SetActive(arg0_87.remasterBtn:Find("tip"), var1_87)
	SetActive(arg0_87.entranceLayer:Find("btns/btn_remaster/tip"), var1_87)
end

function var0_0.updatDailyBtnTip(arg0_88)
	local var0_88 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_88.dailyBtn:Find("tip"), var0_88)
	SetActive(arg0_88.entranceLayer:Find("btns/btn_daily/tip"), var0_88)
end

function var0_0.updateRemasterInfo(arg0_89)
	arg0_89:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_89.contextData.map then
		return
	end

	local var0_89 = getProxy(ChapterProxy)
	local var1_89
	local var2_89 = arg0_89.contextData.map:getRemaster()

	if var2_89 and #pg.re_map_template[var2_89].drop_gain > 0 then
		for iter0_89, iter1_89 in ipairs(pg.re_map_template[var2_89].drop_gain) do
			if #iter1_89 > 0 and var0_89.remasterInfo[iter1_89[1]][iter0_89].receive == false then
				var1_89 = {
					iter0_89,
					iter1_89
				}

				break
			end
		end
	end

	setActive(arg0_89.remasterAwardBtn, var1_89)

	if var1_89 then
		local var3_89 = var1_89[1]
		local var4_89, var5_89, var6_89, var7_89 = unpack(var1_89[2])
		local var8_89 = var0_89.remasterInfo[var4_89][var3_89]

		setText(arg0_89.remasterAwardBtn:Find("Text"), var8_89.count .. "/" .. var7_89)
		updateDrop(arg0_89.remasterAwardBtn:Find("IconTpl"), {
			type = var5_89,
			id = var6_89
		})
		setActive(arg0_89.remasterAwardBtn:Find("tip"), var7_89 <= var8_89.count)
		onButton(arg0_89, arg0_89.remasterAwardBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_89,
					id = var6_89
				},
				weight = LayerWeightConst.TOP_LAYER,
				remaster = {
					word = i18n("level_remaster_tip4", pg.chapter_template[var4_89].chapter_name),
					number = var8_89.count .. "/" .. var7_89,
					btn_text = i18n(var8_89.count < var7_89 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var8_89.count < var7_89 then
							local var0_91 = pg.chapter_template[var4_89].map
							local var1_91, var2_91 = var0_89:getMapById(var0_91):isUnlock()

							if not var1_91 then
								pg.TipsMgr.GetInstance():ShowTips(var2_91)
							else
								arg0_89:ShowSelectedMap(var0_91)
							end
						else
							arg0_89:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_89, var3_89)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_92)
	local var0_92 = getProxy(ChapterProxy)

	if arg0_92.newChapterCDTimer then
		arg0_92.newChapterCDTimer:Stop()

		arg0_92.newChapterCDTimer = nil
	end

	local var1_92 = 0

	if arg0_92.contextData.map:isActivity() and not arg0_92.contextData.map:isRemaster() then
		local var2_92 = var0_92:getMapsByActivities()

		_.each(var2_92, function(arg0_93)
			local var0_93 = arg0_93:getChapterTimeLimit()

			if var1_92 == 0 then
				var1_92 = var0_93
			else
				var1_92 = math.min(var1_92, var0_93)
			end
		end)
		setActive(arg0_92.countDown, var1_92 > 0)
		setText(arg0_92.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_92.countDown, false)
	end

	if var1_92 > 0 then
		setText(arg0_92.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_92))

		arg0_92.newChapterCDTimer = Timer.New(function()
			var1_92 = var1_92 - 1

			if var1_92 <= 0 then
				arg0_92:updateCountDown()

				if not arg0_92.contextData.chapterVO then
					arg0_92:setMap(arg0_92.contextData.mapIdx)
				end
			else
				setText(arg0_92.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_92))
			end
		end, 1, -1)

		arg0_92.newChapterCDTimer:Start()
	else
		setText(arg0_92.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_95)
	if arg0_95.isRegisterBtn then
		return
	end

	arg0_95.isRegisterBtn = true

	onButton(arg0_95, arg0_95.actExtraRank, function()
		if arg0_95:isfrozen() then
			return
		end

		arg0_95:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_95, arg0_95.activityBtn, function()
		if arg0_95:isfrozen() then
			return
		end

		arg0_95:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_95, arg0_95.actExchangeShopBtn, function()
		if arg0_95:isfrozen() then
			return
		end

		arg0_95:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_95, arg0_95.actAtelierBuffBtn, function()
		if arg0_95:isfrozen() then
			return
		end

		arg0_95:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)

	local var0_95 = getProxy(ChapterProxy)

	local function var1_95(arg0_100, arg1_100, arg2_100)
		local var0_100

		if arg0_100:isRemaster() then
			var0_100 = var0_95:getRemasterMaps(arg0_100.remasterId)
		else
			var0_100 = var0_95:getMapsByActivities()
		end

		local var1_100 = _.select(var0_100, function(arg0_101)
			return arg0_101:getMapType() == arg1_100
		end)

		table.sort(var1_100, function(arg0_102, arg1_102)
			return arg0_102.id < arg1_102.id
		end)

		local var2_100 = table.indexof(underscore.map(var1_100, function(arg0_103)
			return arg0_103.id
		end), arg2_100) or #var1_100

		while not var1_100[var2_100]:isUnlock() do
			if var2_100 > 1 then
				var2_100 = var2_100 - 1
			else
				break
			end
		end

		return var1_100[var2_100]
	end

	local function var2_95()
		if arg0_95:isfrozen() then
			return
		end

		local var0_104 = arg0_95.contextData.map:getBindMapId()
		local var1_104 = var1_95(arg0_95.contextData.map, Map.ACTIVITY_HARD, var0_104)
		local var2_104, var3_104 = var1_104:isUnlock()

		if var2_104 then
			arg0_95:setMap(var1_104.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_104)
		end
	end

	onButton(arg0_95, arg0_95.actEliteBtn, var2_95, SFX_PANEL)
	arg0_95:bind(LevelUIConst.SWITCH_CHALLENGE_MAP, var2_95)
	onButton(arg0_95, arg0_95.actNormalBtn, function()
		if arg0_95:isfrozen() then
			return
		end

		local var0_105 = arg0_95.contextData.map:getBindMapId()
		local var1_105 = var1_95(arg0_95.contextData.map, Map.ACTIVITY_EASY, var0_105)
		local var2_105, var3_105 = var1_105:isUnlock()

		if var2_105 then
			arg0_95:setMap(var1_105.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_105)
		end
	end, SFX_PANEL)
	onButton(arg0_95, arg0_95.actExtraBtn, function()
		if arg0_95:isfrozen() then
			return
		end

		local var0_106 = PlayerPrefs.HasKey("ex_mapId") and PlayerPrefs.GetInt("ex_mapId", 0) or 0
		local var1_106 = var1_95(arg0_95.contextData.map, Map.ACT_EXTRA, var0_106)
		local var2_106, var3_106 = var1_106:isUnlock()

		if var2_106 then
			arg0_95:setMap(var1_106.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3_106)
		end
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_107, arg1_107)
	arg0_107.initPositions = {}

	local var0_107 = arg1_107 or 1
	local var1_107 = pg.expedition_data_by_map[var0_107].clouds_pos

	for iter0_107, iter1_107 in ipairs(arg0_107.cloudRTFs) do
		local var2_107 = var1_107[iter0_107]

		if var2_107 then
			iter1_107.anchoredPosition = Vector2(var2_107[1], var2_107[2])

			table.insert(arg0_107.initPositions, iter1_107.anchoredPosition)
		else
			setActive(iter1_107, false)
		end
	end
end

function var0_0.initMapBtn(arg0_108, arg1_108, arg2_108)
	onButton(arg0_108, arg1_108, function()
		if arg0_108:isfrozen() then
			return
		end

		local var0_109 = arg0_108.contextData.mapIdx + arg2_108
		local var1_109 = getProxy(ChapterProxy):getMapById(var0_109)

		if not var1_109 then
			return
		end

		if var1_109:getMapType() == Map.ELITE and not var1_109:isEliteEnabled() then
			var1_109 = var1_109:getBindMap()
			var0_109 = var1_109.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_109, var3_109 = var1_109:isUnlock()

		if arg2_108 > 0 and not var2_109 then
			pg.TipsMgr.GetInstance():ShowTips(var3_109)

			return
		end

		arg0_108:setMap(var0_109)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_110, arg1_110, arg2_110)
	seriesAsync({
		function(arg0_111)
			if arg0_110.contextData.entranceStatus then
				arg0_110:frozen()

				arg0_110.nextPreloadMap = arg1_110

				arg0_110:PreloadLevelMainUI(arg1_110, function()
					arg0_110:unfrozen()

					if arg0_110.nextPreloadMap ~= arg1_110 then
						return
					end

					arg0_110:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_110)
					arg0_110:ShowEntranceUI(false)
					arg0_111()
				end)
			else
				arg0_110:setMap(arg1_110)
				arg0_111()
			end
		end
	}, arg2_110)
end

function var0_0.setMap(arg0_113, arg1_113)
	arg0_113.lastMapIdx = arg0_113.contextData.mapIdx
	arg0_113.contextData.mapIdx = arg1_113
	arg0_113.contextData.map = getProxy(ChapterProxy):getMapById(arg1_113)

	assert(arg0_113.contextData.map, "map cannot be nil " .. arg1_113)

	if arg0_113.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_113.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_113.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_113.contextData.map.remasterId, arg1_113)
		PlayerPrefs.Save()
	end

	arg0_113:updateMap()
	arg0_113:tryPlayMapStory()
end

local var5_0 = import("view.level.MapBuilder.MapBuilder")
local var6_0 = {
	default = "MapBuilderNormal",
	[var5_0.TYPENORMAL] = "MapBuilderNormal",
	[var5_0.TYPEESCORT] = "MapBuilderEscort",
	[var5_0.TYPESHINANO] = "MapBuilderShinano",
	[var5_0.TYPESKIRMISH] = "MapBuilderSkirmish",
	[var5_0.TYPEBISMARCK] = "MapBuilderBismarck",
	[var5_0.TYPESSSS] = "MapBuilderSSSS",
	[var5_0.TYPEATELIER] = "MapBuilderAtelier",
	[var5_0.TYPESENRANKAGURA] = "MapBuilderSenrankagura"
}

function var0_0.SwitchMapBuilder(arg0_114, arg1_114)
	if arg0_114.mapBuilder and arg0_114.mapBuilder:GetType() ~= arg1_114 then
		arg0_114.mapBuilder.buffer:Hide()
	end

	local var0_114 = arg0_114:GetMapBuilderInBuffer(arg1_114)

	arg0_114.mapBuilder = var0_114

	var0_114.buffer:Show()
	var0_114.buffer:ShowButtons()
end

function var0_0.GetMapBuilderInBuffer(arg0_115, arg1_115)
	if not arg0_115.mbDict[arg1_115] then
		local var0_115 = _G[var6_0[arg1_115] or var6_0.default]

		arg0_115.mbDict[arg1_115] = var0_115.New(arg0_115._tf, arg0_115)
		arg0_115.mbDict[arg1_115].isFrozen = arg0_115:isfrozen()

		arg0_115.mbDict[arg1_115]:Load()
	end

	return arg0_115.mbDict[arg1_115]
end

function var0_0.JudgeMapBuilderType(arg0_116)
	return (arg0_116.contextData.map:getConfig("ui_type"))
end

function var0_0.updateMap(arg0_117)
	local var0_117 = arg0_117.contextData.map

	arg0_117:SwitchMapBG(var0_117, arg0_117.lastMapIdx)

	arg0_117.lastMapIdx = nil

	local var1_117 = var0_117:getConfig("anchor")
	local var2_117

	if var1_117 == "" then
		var2_117 = Vector2.zero
	else
		var2_117 = Vector2(unpack(var1_117))
	end

	arg0_117.map.pivot = var2_117

	local var3_117 = var0_117:getConfig("uifx")

	for iter0_117 = 1, arg0_117.UIFXList.childCount do
		local var4_117 = arg0_117.UIFXList:GetChild(iter0_117 - 1)

		setActive(var4_117, var4_117.name == var3_117)
	end

	arg0_117:PlayBGM()

	local var5_117 = arg0_117:JudgeMapBuilderType()

	arg0_117:SwitchMapBuilder(var5_117)
	arg0_117.mapBuilder.buffer:Update(var0_117)
	arg0_117:UpdateSwitchMapButton()
	arg0_117:updateMapItems()
	arg0_117.mapBuilder.buffer:UpdateButtons()
	arg0_117.mapBuilder.buffer:PostUpdateMap(var0_117)

	if arg0_117.contextData.openChapterId then
		arg0_117.mapBuilder.buffer:TryOpenChapter(arg0_117.contextData.openChapterId)

		arg0_117.contextData.openChapterId = nil
	end
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

function var0_0.TrySwitchChapter(arg0_119, arg1_119)
	local var0_119 = getProxy(ChapterProxy):getActiveChapter()

	if var0_119 then
		if var0_119.id == arg1_119.id then
			arg0_119:switchToChapter(var0_119)
		else
			local var1_119 = i18n("levelScene_chapter_strategying", var0_119:getConfig("chapter_name"))

			pg.TipsMgr.GetInstance():ShowTips(var1_119)
		end
	else
		arg0_119:displayChapterPanel(arg1_119)
	end
end

function var0_0.updateChapterTF(arg0_120, arg1_120)
	if not arg0_120.mapBuilder.UpdateChapterTF then
		return
	end

	arg0_120.mapBuilder.buffer:UpdateChapterTF(arg1_120)
end

function var0_0.tryPlayMapStory(arg0_121)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_122)
			local var0_122 = arg0_121.contextData.map:getConfig("enter_story")

			if var0_122 and var0_122 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_122) and not arg0_121.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_122 = tonumber(var0_122)

				if var1_122 and var1_122 > 0 then
					arg0_121:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_122)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_122, arg0_122)
				end

				return
			end

			arg0_122()
		end,
		function(arg0_123)
			local var0_123 = arg0_121.contextData.map:getConfig("guide_id")

			if var0_123 and var0_123 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_123, nil, arg0_123)

				return
			end

			arg0_123()
		end,
		function(arg0_124)
			if isActive(arg0_121.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_124 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_124

				if var0_124 then
					var1_124 = {
						1,
						2
					}
				else
					var1_124 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_124)
			else
				arg0_124()
			end
		end,
		function(arg0_125)
			if arg0_121.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_121.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_126, arg1_126, arg2_126, arg3_126)
	arg0_126.uiAnims = arg0_126.uiAnims or {}

	local var0_126 = arg0_126.uiAnims[arg1_126]

	local function var1_126()
		arg0_126.playing = true

		arg0_126:frozen()
		var0_126:SetActive(true)

		local var0_127 = tf(var0_126)

		pg.UIMgr.GetInstance():OverlayPanel(var0_127, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_126 then
			arg3_126(var0_126)
		end

		var0_127:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_128)
			arg0_126.playing = false

			if arg2_126 then
				arg2_126(var0_126)
			end

			arg0_126:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_126 then
		PoolMgr.GetInstance():GetUI(arg1_126, true, function(arg0_129)
			arg0_129:SetActive(true)

			arg0_126.uiAnims[arg1_126] = arg0_129
			var0_126 = arg0_126.uiAnims[arg1_126]

			var1_126()
		end)
	else
		var1_126()
	end
end

function var0_0.displaySpResult(arg0_130, arg1_130, arg2_130)
	setActive(arg0_130.spResult, true)
	arg0_130:DisplaySPAnim(arg1_130 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_131)
		onButton(arg0_130, arg0_131, function()
			removeOnButton(arg0_131)
			setActive(arg0_131, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_131, arg0_130._tf)
			arg0_130:hideSpResult()
			arg2_130()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_133)
	setActive(arg0_133.spResult, false)
end

function var0_0.displayBombResult(arg0_134, arg1_134)
	setActive(arg0_134.spResult, true)
	arg0_134:DisplaySPAnim("SpBombRet", function(arg0_135)
		onButton(arg0_134, arg0_135, function()
			removeOnButton(arg0_135)
			setActive(arg0_135, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_135, arg0_134._tf)
			arg0_134:hideSpResult()
			arg1_134()
		end, SFX_PANEL)
	end, function(arg0_137)
		setText(arg0_137.transform:Find("right/name_bg/en"), arg0_134.contextData.chapterVO.modelCount)
	end)
end

function var0_0.displayChapterPanel(arg0_138, arg1_138, arg2_138)
	local function var0_138(arg0_139)
		if getProxy(BayProxy):getShipCount() >= arg0_138.player:getMaxShipBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

			return
		end

		arg0_138:hideChapterPanel()

		local var0_139 = arg1_138:getConfig("type")

		arg0_138.contextData.chapterLoopFlag = arg0_139

		if var0_139 == Chapter.CustomFleet then
			arg0_138:displayFleetEdit(arg1_138)
		elseif #arg1_138:getNpcShipByType(1) > 0 then
			arg0_138:emit(LevelMediator2.ON_TRACKING, arg1_138.id)

			return
		else
			arg0_138:displayFleetSelect(arg1_138)
		end
	end

	local function var1_138()
		arg0_138:hideChapterPanel()
	end

	if getProxy(ChapterProxy):getMapById(arg1_138:getConfig("map")):isSkirmish() and #arg1_138:getNpcShipByType(1) > 0 then
		var0_138(false)

		return
	end

	arg0_138.levelInfoView:Load()
	arg0_138.levelInfoView:ActionInvoke("set", arg1_138, arg2_138)
	arg0_138.levelInfoView:ActionInvoke("setCBFunc", var0_138, var1_138)
	arg0_138.levelInfoView:ActionInvoke("Show")
end

function var0_0.hideChapterPanel(arg0_141)
	if arg0_141.levelInfoView:isShowing() then
		arg0_141.levelInfoView:ActionInvoke("Hide")
	end
end

function var0_0.destroyChapterPanel(arg0_142)
	arg0_142.levelInfoView:Destroy()

	arg0_142.levelInfoView = nil
end

function var0_0.displayFleetSelect(arg0_143, arg1_143)
	local var0_143 = arg0_143.contextData.selectedFleetIDs or arg1_143:GetDefaultFleetIndex()

	arg1_143 = Clone(arg1_143)
	arg1_143.loopFlag = arg0_143.contextData.chapterLoopFlag

	arg0_143.levelFleetView:updateSpecialOperationTickets(arg0_143.spTickets)
	arg0_143.levelFleetView:Load()
	arg0_143.levelFleetView:ActionInvoke("setHardShipVOs", arg0_143.shipVOs)
	arg0_143.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_143.openedCommanerSystem)
	arg0_143.levelFleetView:ActionInvoke("set", arg1_143, arg0_143.fleets, var0_143)
	arg0_143.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_144)
	if arg0_144.levelCMDFormationView:isShowing() then
		arg0_144.levelCMDFormationView:Hide()
	end

	if arg0_144.levelFleetView then
		arg0_144.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_145)
	arg0_145.levelCMDFormationView = LevelCMDFormationView.New(arg0_145.topPanel, arg0_145.event, arg0_145.contextData)
end

function var0_0.destroyFleetSelect(arg0_146)
	if not arg0_146.levelFleetView then
		return
	end

	arg0_146.levelFleetView:Destroy()

	arg0_146.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_147, arg1_147)
	arg1_147 = Clone(arg1_147)
	arg1_147.loopFlag = arg0_147.contextData.chapterLoopFlag

	arg0_147.levelFleetView:updateSpecialOperationTickets(arg0_147.spTickets)
	arg0_147.levelFleetView:Load()
	arg0_147.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_147.openedCommanerSystem)
	arg0_147.levelFleetView:ActionInvoke("setHardShipVOs", arg0_147.shipVOs)
	arg0_147.levelFleetView:ActionInvoke("setOnHard", arg1_147)
	arg0_147.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_148)
	arg0_148:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_149)
	arg0_149:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_150, arg1_150)
	if not arg0_150.levelFleetView then
		return
	end

	assert(arg0_150.levelFleetView:GetLoaded())

	local var0_150 = arg0_150.levelFleetView:IsSelectMode()
	local var1_150

	if var0_150 then
		arg0_150.levelFleetView:ActionInvoke("set", arg1_150 or arg0_150.levelFleetView.chapter, arg0_150.fleets, arg0_150.levelFleetView:getSelectIds())

		if arg0_150.levelCMDFormationView:isShowing() then
			local var2_150 = arg0_150.levelCMDFormationView.fleet.id

			var1_150 = arg0_150.fleets[var2_150]
		end
	else
		arg0_150.levelFleetView:ActionInvoke("setOnHard", arg1_150 or arg0_150.levelFleetView.chapter)

		if arg0_150.levelCMDFormationView:isShowing() then
			local var3_150 = arg0_150.levelCMDFormationView.fleet.id

			var1_150 = arg1_150:wrapEliteFleet(var3_150)
		end
	end

	if var1_150 then
		arg0_150.levelCMDFormationView:ActionInvoke("updateFleet", var1_150)
	end
end

function var0_0.setChapter(arg0_151, arg1_151)
	local var0_151

	if arg1_151 then
		var0_151 = arg1_151.id
	end

	arg0_151.contextData.chapterId = var0_151
	arg0_151.contextData.chapterVO = arg1_151
end

function var0_0.switchToChapter(arg0_152, arg1_152)
	if arg0_152.contextData.mapIdx ~= arg1_152:getConfig("map") then
		arg0_152:setMap(arg1_152:getConfig("map"))
	end

	arg0_152:setChapter(arg1_152)
	setActive(arg0_152.clouds, false)
	arg0_152.mapBuilder.buffer:Hide()

	arg0_152.leftCanvasGroup.blocksRaycasts = false
	arg0_152.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_152.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_152:DestroyLevelStageView()

	if not arg0_152.levelStageView then
		arg0_152.levelStageView = LevelStageView.New(arg0_152.topPanel, arg0_152.event, arg0_152.contextData)

		arg0_152.levelStageView:Load()

		arg0_152.levelStageView.isFrozen = arg0_152:isfrozen()
	end

	arg0_152:frozen()

	local function var0_152()
		seriesAsync({
			function(arg0_154)
				pg.UIMgr.GetInstance():BlurPanel(arg0_152.topPanel, false, {
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
				arg0_152.levelStageView:updateStageInfo()
				arg0_152.levelStageView:updateAmbushRate(arg1_152.fleet.line, true)
				arg0_152.levelStageView:updateStageAchieve()
				arg0_152.levelStageView:updateStageBarrier()
				arg0_152.levelStageView:updateBombPanel()
				arg0_152.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_154)
			end,
			function(arg0_155)
				if arg0_152.exited then
					return
				end

				arg0_152.levelStageView:updateStageStrategy()

				arg0_152.canvasGroup.blocksRaycasts = arg0_152.frozenCount == 0

				onNextTick(arg0_155)
			end,
			function(arg0_156)
				if arg0_152.exited then
					return
				end

				arg0_152.levelStageView:updateStageFleet()
				arg0_152.levelStageView:updateSupportFleet()
				arg0_152.levelStageView:updateFleetBuff()
				onNextTick(arg0_156)
			end,
			function(arg0_157)
				if arg0_152.exited then
					return
				end

				parallelAsync({
					function(arg0_158)
						local var0_158 = arg1_152:getConfig("scale")
						local var1_158 = LeanTween.value(go(arg0_152.map), arg0_152.map.localScale, Vector3.New(var0_158[3], var0_158[3], 1), var1_0):setOnUpdateVector3(function(arg0_159)
							arg0_152.map.localScale = arg0_159
							arg0_152.float.localScale = arg0_159
						end):setOnComplete(System.Action(arg0_158)):setEase(LeanTweenType.easeOutSine)

						arg0_152:RecordTween("mapScale", var1_158.uniqueId)

						local var2_158 = LeanTween.value(go(arg0_152.map), arg0_152.map.pivot, Vector2.New(math.clamp(var0_158[1] - 0.5, 0, 1), math.clamp(var0_158[2] - 0.5, 0, 1)), var1_0)

						var2_158:setOnUpdateVector2(function(arg0_160)
							arg0_152.map.pivot = arg0_160
							arg0_152.float.pivot = arg0_160
						end):setEase(LeanTweenType.easeOutSine)
						arg0_152:RecordTween("mapPivot", var2_158.uniqueId)
						shiftPanel(arg0_152.leftChapter, -arg0_152.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_152.rightChapter, arg0_152.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_152.topChapter, 0, arg0_152.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_152.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_161)
						arg0_152:PlayBGM()

						local var0_161 = {}
						local var1_161 = arg1_152:getConfig("bg")

						if var1_161 and #var1_161 > 0 then
							var0_161[1] = {
								BG = var1_161
							}
						end

						arg0_152:SwitchBG(var0_161, arg0_161)
					end
				}, function()
					onNextTick(arg0_157)
					arg0_152.mapBuilder.buffer:HideButtons()
				end)
			end,
			function(arg0_163)
				if arg0_152.exited then
					return
				end

				setActive(arg0_152.topChapter, false)
				setActive(arg0_152.leftChapter, false)
				setActive(arg0_152.rightChapter, false)

				arg0_152.leftCanvasGroup.blocksRaycasts = true
				arg0_152.rightCanvasGroup.blocksRaycasts = true

				arg0_152:initGrid(arg0_163)
			end,
			function(arg0_164)
				if arg0_152.exited then
					return
				end

				arg0_152.levelStageView:SetGrid(arg0_152.grid)

				arg0_152.contextData.huntingRangeVisibility = arg0_152.contextData.huntingRangeVisibility - 1

				arg0_152.grid:toggleHuntingRange()

				local var0_164 = arg1_152:getConfig("pop_pic")

				if var0_164 and #var0_164 > 0 and arg0_152.FirstEnterChapter == arg1_152.id then
					arg0_152:doPlayAnim(var0_164, function(arg0_165)
						setActive(arg0_165, false)

						if arg0_152.exited then
							return
						end

						arg0_164()
					end)
				else
					arg0_164()
				end
			end,
			function(arg0_166)
				arg0_152.levelStageView:tryAutoAction(arg0_166)
			end,
			function(arg0_167)
				if arg0_152.exited then
					return
				end

				arg0_152:unfrozen()

				if arg0_152.FirstEnterChapter then
					arg0_152:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_152.subAutoAttack)
				end

				arg0_152.FirstEnterChapter = nil

				arg0_152.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0_152.levelStageView:ActionInvoke("SetSeriesOperation", var0_152)
	arg0_152.levelStageView:ActionInvoke("SetPlayer", arg0_152.player)
	arg0_152.levelStageView:ActionInvoke("SwitchToChapter", arg1_152)
end

function var0_0.switchToMap(arg0_168, arg1_168)
	arg0_168:frozen()
	arg0_168:destroyGrid()
	LeanTween.cancel(go(arg0_168.map))

	local var0_168 = LeanTween.value(go(arg0_168.map), arg0_168.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_169)
		arg0_168.map.localScale = arg0_169
		arg0_168.float.localScale = arg0_169
	end):setOnComplete(System.Action(function()
		arg0_168.mapBuilder.buffer:Show()
		arg0_168.mapBuilder.buffer:Update(arg0_168.contextData.map)
		arg0_168:UpdateSwitchMapButton()
		arg0_168:updateMapItems()
		arg0_168.mapBuilder.buffer:UpdateButtons()
		arg0_168.mapBuilder.buffer:PostUpdateMap(arg0_168.contextData.map)
		arg0_168:unfrozen()
		existCall(arg1_168)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_168:RecordTween("mapScale", var0_168.uniqueId)

	local var1_168 = arg0_168.contextData.map:getConfig("anchor")
	local var2_168

	if var1_168 == "" then
		var2_168 = Vector2.zero
	else
		var2_168 = Vector2(unpack(var1_168))
	end

	local var3_168 = LeanTween.value(go(arg0_168.map), arg0_168.map.pivot, var2_168, var1_0)

	var3_168:setOnUpdateVector2(function(arg0_171)
		arg0_168.map.pivot = arg0_171
		arg0_168.float.pivot = arg0_171
	end):setEase(LeanTweenType.easeOutSine)
	arg0_168:RecordTween("mapPivot", var3_168.uniqueId)
	setActive(arg0_168.topChapter, true)
	setActive(arg0_168.leftChapter, true)
	setActive(arg0_168.rightChapter, true)
	shiftPanel(arg0_168.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_168.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_168.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_168.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_168.levelStageView then
		arg0_168.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_168:DestroyLevelStageView()
		end)
		arg0_168.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_168:SwitchMapBG(arg0_168.contextData.map)
	arg0_168.mapBuilder.buffer:ShowButtons()
	arg0_168:setChapter(nil)
	arg0_168:PlayBGM()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_168.topPanel, arg0_168._tf)
	pg.playerResUI:SetActive({
		active = false
	})

	arg0_168.canvasGroup.blocksRaycasts = arg0_168.frozenCount == 0
	arg0_168.canvasGroup.interactable = true

	if arg0_168.ambushWarning and arg0_168.ambushWarning.activeSelf then
		arg0_168.ambushWarning:SetActive(false)
		arg0_168:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_173, arg1_173, arg2_173, arg3_173)
	if not arg1_173 or #arg1_173 <= 0 then
		existCall(arg2_173)

		return
	elseif arg3_173 then
		-- block empty
	elseif table.equal(arg0_173.currentBG, arg1_173) then
		return
	end

	arg0_173.currentBG = arg1_173

	for iter0_173, iter1_173 in ipairs(arg0_173.mapGroup) do
		arg0_173.loader:ClearRequest(iter1_173)
	end

	table.clear(arg0_173.mapGroup)

	local var0_173 = {}

	table.ParallelIpairsAsync(arg1_173, function(arg0_174, arg1_174, arg2_174)
		local var0_174 = arg0_173.mapTFs[arg0_174]
		local var1_174 = arg0_173.loader:GetSpriteDirect("levelmap/" .. arg1_174.BG, "", function(arg0_175)
			var0_173[arg0_174] = arg0_175

			arg2_174()
		end, var0_174)

		table.insert(arg0_173.mapGroup, var1_174)
		arg0_173:updateCouldAnimator(arg1_174.Animator, arg0_174)
	end, function()
		for iter0_176, iter1_176 in ipairs(arg0_173.mapTFs) do
			setImageSprite(iter1_176, var0_173[iter0_176])
			setActive(iter1_176, arg1_173[iter0_176])
			SetCompomentEnabled(iter1_176, typeof(Image), true)
		end

		existCall(arg2_173)
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

function var0_0.ClearMapTransitions(arg0_177)
	if not arg0_177.mapTransitions then
		return
	end

	for iter0_177, iter1_177 in pairs(arg0_177.mapTransitions) do
		if iter1_177 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_177, iter0_177, iter1_177, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_177, iter0_177)
		end
	end

	arg0_177.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_178, arg1_178, arg2_178, arg3_178)
	local var0_178, var1_178, var2_178 = arg0_178:GetMapBG(arg1_178, arg2_178)

	if not var1_178 then
		arg0_178:SwitchBG(var0_178, arg3_178)

		return
	end

	arg0_178:PlayMapTransition("LevelMapTransition_" .. var1_178, var2_178, function()
		arg0_178:SwitchBG(var0_178, arg3_178)
	end)
end

function var0_0.GetMapBG(arg0_180, arg1_180, arg2_180)
	if not table.contains(var7_0, arg1_180.id) then
		return {
			arg0_180:GetMapElement(arg1_180)
		}
	end

	local var0_180 = arg1_180.id
	local var1_180 = table.indexof(var7_0, var0_180) - 1
	local var2_180 = bit.lshift(bit.rshift(var1_180, 1), 1) + 1
	local var3_180 = {
		var7_0[var2_180],
		var7_0[var2_180 + 1]
	}
	local var4_180 = _.map(var3_180, function(arg0_181)
		return getProxy(ChapterProxy):getMapById(arg0_181)
	end)

	if _.all(var4_180, function(arg0_182)
		return arg0_182:isAllChaptersClear()
	end) then
		local var5_180 = {
			arg0_180:GetMapElement(arg1_180)
		}

		if not arg2_180 or math.abs(var0_180 - arg2_180) ~= 1 then
			return var5_180
		end

		local var6_180 = var9_0[bit.rshift(var2_180 - 1, 1) + 1]
		local var7_180 = bit.band(var1_180, 1) == 1

		return var5_180, var6_180, var7_180
	else
		local var8_180 = 0

		;(function()
			local var0_183 = var4_180[1]:getChapters()

			for iter0_183, iter1_183 in ipairs(var0_183) do
				if not iter1_183:isClear() then
					return
				end

				var8_180 = var8_180 + 1
			end

			if not var4_180[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_180 = var8_180 + 1

			local var1_183 = var4_180[2]:getChapters()

			for iter2_183, iter3_183 in ipairs(var1_183) do
				if not iter3_183:isClear() then
					return
				end

				var8_180 = var8_180 + 1
			end
		end)()

		local var9_180

		if var8_180 > 0 then
			local var10_180 = var8_0[bit.rshift(var2_180 - 1, 1) + 1]

			var9_180 = {
				{
					BG = "map_" .. var10_180[1],
					Animator = var10_180[2]
				},
				{
					BG = "map_" .. var10_180[3] + var8_180,
					Animator = var10_180[4]
				}
			}
		else
			var9_180 = {
				arg0_180:GetMapElement(arg1_180)
			}
		end

		return var9_180
	end
end

function var0_0.GetMapElement(arg0_184, arg1_184)
	local var0_184 = arg1_184:getConfig("bg")
	local var1_184 = arg1_184:getConfig("ani_controller")

	if var1_184 and #var1_184 > 0 then
		(function()
			for iter0_185, iter1_185 in ipairs(var1_184) do
				local var0_185 = _.rest(iter1_185[2], 2)

				for iter2_185, iter3_185 in ipairs(var0_185) do
					if string.find(iter3_185, "^map_") and iter1_185[1] == var3_0 then
						local var1_185 = iter1_185[2][1]
						local var2_185 = getProxy(ChapterProxy):GetChapterItemById(var1_185)

						if var2_185 and not var2_185:isClear() then
							var0_184 = iter3_185

							return
						end
					end
				end
			end
		end)()
	end

	local var2_184 = {
		BG = var0_184
	}

	var2_184.Animator, var2_184.AnimatorController = arg0_184:GetMapAnimator(arg1_184)

	return var2_184
end

function var0_0.GetMapAnimator(arg0_186, arg1_186)
	local var0_186 = arg1_186:getConfig("ani_name")

	if arg1_186:getConfig("animtor") == 1 and var0_186 and #var0_186 > 0 then
		local var1_186 = arg1_186:getConfig("ani_controller")

		if var1_186 and #var1_186 > 0 then
			(function()
				for iter0_187, iter1_187 in ipairs(var1_186) do
					local var0_187 = _.rest(iter1_187[2], 2)

					for iter2_187, iter3_187 in ipairs(var0_187) do
						if string.find(iter3_187, "^effect_") and iter1_187[1] == var3_0 then
							local var1_187 = iter1_187[2][1]
							local var2_187 = getProxy(ChapterProxy):GetChapterItemById(var1_187)

							if var2_187 and not var2_187:isClear() then
								var0_186 = "map_" .. string.sub(iter3_187, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_186, var1_186
	end
end

function var0_0.PlayMapTransition(arg0_188, arg1_188, arg2_188, arg3_188, arg4_188)
	arg0_188.mapTransitions = arg0_188.mapTransitions or {}

	local var0_188

	local function var1_188()
		arg0_188:frozen()
		existCall(arg3_188, var0_188)
		var0_188:SetActive(true)

		local var0_189 = tf(var0_188)

		pg.UIMgr.GetInstance():OverlayPanel(var0_189, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		var0_188:GetComponent(typeof(Animator)):Play(arg2_188 and "Sequence" or "Inverted", -1, 0)
		var0_189:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_190)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_189, arg0_188._tf)
			existCall(arg4_188, var0_188)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_188, arg1_188, var0_188)

			arg0_188.mapTransitions[arg1_188] = false

			arg0_188:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_188, arg1_188, true, function(arg0_191)
		var0_188 = arg0_191
		arg0_188.mapTransitions[arg1_188] = arg0_191

		var1_188()
	end)
end

function var0_0.DestroyLevelStageView(arg0_192)
	if arg0_192.levelStageView then
		arg0_192.levelStageView:Destroy()

		arg0_192.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_193, arg1_193)
	arg0_193.levelAmbushView = LevelAmbushView.New(arg0_193.topPanel, arg0_193.event, arg0_193.contextData)

	arg0_193.levelAmbushView:Load()
	arg0_193.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_193)
end

function var0_0.hideAmbushInfo(arg0_194)
	if arg0_194.levelAmbushView then
		arg0_194.levelAmbushView:Destroy()

		arg0_194.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_195, arg1_195)
	arg0_195:frozen()

	local function var0_195()
		arg0_195.ambushWarning:SetActive(true)

		local var0_196 = tf(arg0_195.ambushWarning)

		var0_196:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_196:SetSiblingIndex(1)

		local var1_196 = var0_196:GetComponent("DftAniEvent")

		var1_196:SetTriggerEvent(function(arg0_197)
			arg1_195()
		end)
		var1_196:SetEndEvent(function(arg0_198)
			arg0_195.ambushWarning:SetActive(false)
			arg0_195:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_195.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_200)
			arg0_200:SetActive(true)

			arg0_195.ambushWarning = arg0_200

			var0_195()
		end)
	else
		var0_195()
	end
end

function var0_0.destroyAmbushWarn(arg0_201)
	if arg0_201.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_201.ambushWarning)

		arg0_201.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_202, arg1_202)
	arg0_202.levelStrategyView = LevelStrategyView.New(arg0_202.topPanel, arg0_202.event, arg0_202.contextData)

	arg0_202.levelStrategyView:Load()
	arg0_202.levelStrategyView:ActionInvoke("set", arg1_202)

	local function var0_202()
		local var0_203 = arg0_202.contextData.chapterVO.fleet
		local var1_203 = pg.strategy_data_template[arg1_202.id]

		if not var0_203:canUseStrategy(arg1_202) then
			return
		end

		local var2_203 = var0_203:getNextStgUser(arg1_202.id)

		if var1_203.type == ChapterConst.StgTypeForm then
			arg0_202:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_203,
				arg1 = arg1_202.id
			})
		elseif var1_203.type == ChapterConst.StgTypeConsume then
			arg0_202:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_203,
				arg1 = arg1_202.id
			})
		end

		arg0_202:hideStrategyInfo()
	end

	local function var1_202()
		arg0_202:hideStrategyInfo()
	end

	arg0_202.levelStrategyView:ActionInvoke("setCBFunc", var0_202, var1_202)
end

function var0_0.hideStrategyInfo(arg0_205)
	if arg0_205.levelStrategyView then
		arg0_205.levelStrategyView:Destroy()

		arg0_205.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_206, arg1_206)
	local var0_206 = arg0_206.contextData.chapterVO
	local var1_206 = getProxy(ChapterProxy)
	local var2_206
	local var3_206
	local var4_206
	local var5_206
	local var6_206 = var1_206.repairTimes
	local var7_206, var8_206, var9_206 = ChapterConst.GetRepairParams()

	arg0_206.levelRepairView = LevelRepairView.New(arg0_206.topPanel, arg0_206.event, arg0_206.contextData)

	arg0_206.levelRepairView:Load()
	arg0_206.levelRepairView:ActionInvoke("set", var6_206, var7_206, var8_206, var9_206)

	local function var10_206()
		if var7_206 - math.min(var6_206, var7_206) == 0 and arg0_206.player:getTotalGem() < var9_206 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_206:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_206.fleet.id,
			arg1 = arg1_206.id
		})
		arg0_206:hideRepairWindow()
	end

	local function var11_206()
		arg0_206:hideRepairWindow()
	end

	arg0_206.levelRepairView:ActionInvoke("setCBFunc", var10_206, var11_206)
end

function var0_0.hideRepairWindow(arg0_209)
	if arg0_209.levelRepairView then
		arg0_209.levelRepairView:Destroy()

		arg0_209.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_210, arg1_210)
	arg0_210.levelRemasterView:Load()

	local function var0_210(arg0_211)
		arg0_210:ShowSelectedMap(arg0_211)
	end

	arg0_210.levelRemasterView:ActionInvoke("Show")
	arg0_210.levelRemasterView:ActionInvoke("set", var0_210, arg1_210)
end

function var0_0.hideRemasterPanel(arg0_212)
	if arg0_212.levelRemasterView:isShowing() then
		arg0_212.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_213, arg1_213)
	local var0_213 = arg0_213.contextData.chapterVO

	if not var0_213 then
		return
	end

	arg0_213:enableLevelCamera()
	setActive(arg0_213.uiMain, true)

	arg0_213.levelGrid.localEulerAngles = Vector3(var0_213.theme.angle, 0, 0)
	arg0_213.grid = LevelGrid.New(arg0_213.dragLayer)

	arg0_213.grid:attach(arg0_213)
	arg0_213.grid:ExtendItem("shipTpl", arg0_213.shipTpl)
	arg0_213.grid:ExtendItem("subTpl", arg0_213.subTpl)
	arg0_213.grid:ExtendItem("transportTpl", arg0_213.transportTpl)
	arg0_213.grid:ExtendItem("enemyTpl", arg0_213.enemyTpl)
	arg0_213.grid:ExtendItem("championTpl", arg0_213.championTpl)
	arg0_213.grid:ExtendItem("oniTpl", arg0_213.oniTpl)
	arg0_213.grid:ExtendItem("arrowTpl", arg0_213.arrowTarget)
	arg0_213.grid:ExtendItem("destinationMarkTpl", arg0_213.destinationMarkTpl)

	function arg0_213.grid.onShipStepChange(arg0_214)
		arg0_213.levelStageView:updateAmbushRate(arg0_214)
	end

	arg0_213.grid:initAll(arg1_213)
end

function var0_0.destroyGrid(arg0_215)
	if arg0_215.grid then
		arg0_215.grid:detach()

		arg0_215.grid = nil

		arg0_215:disableLevelCamera()
		setActive(arg0_215.dragLayer, true)
		setActive(arg0_215.uiMain, false)
	end
end

function var0_0.doTracking(arg0_216, arg1_216)
	arg0_216:frozen()

	local function var0_216()
		arg0_216.radar:SetActive(true)

		local var0_217 = tf(arg0_216.radar)

		var0_217:SetParent(arg0_216.topPanel, false)
		var0_217:SetSiblingIndex(1)
		var0_217:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_218)
			arg0_216.radar:SetActive(false)
			arg0_216:unfrozen()
			arg1_216()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_216.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_219)
			arg0_219:SetActive(true)

			arg0_216.radar = arg0_219

			var0_216()
		end)
	else
		var0_216()
	end
end

function var0_0.destroyTracking(arg0_220)
	if arg0_220.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_220.radar)

		arg0_220.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_221, arg1_221, arg2_221, arg3_221)
	local function var0_221()
		arg0_221.playing = true

		arg0_221:frozen()
		arg0_221.airStrike:SetActive(true)

		local var0_222 = tf(arg0_221.airStrike)

		var0_222:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_222:SetAsLastSibling()
		setActive(var0_222:Find("words/be_striked"), arg1_221 == ChapterConst.SubjectChampion)
		setActive(var0_222:Find("words/strike_enemy"), arg1_221 == ChapterConst.SubjectPlayer)

		local function var1_222()
			arg0_221.playing = false

			SetActive(arg0_221.airStrike, false)

			if arg3_221 then
				arg3_221()
			end

			arg0_221:unfrozen()
		end

		var0_222:GetComponent("DftAniEvent"):SetEndEvent(var1_222)

		if arg2_221 then
			onButton(arg0_221, var0_222, var1_222, SFX_PANEL)
		else
			removeOnButton(var0_222)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_221.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_224)
			arg0_224:SetActive(true)

			arg0_221.airStrike = arg0_224

			var0_221()
		end)
	else
		var0_221()
	end
end

function var0_0.destroyAirStrike(arg0_225)
	if arg0_225.airStrike then
		arg0_225.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_225.airStrike)

		arg0_225.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_226, arg1_226, arg2_226, arg3_226)
	arg0_226.uiAnims = arg0_226.uiAnims or {}

	local var0_226 = arg0_226.uiAnims[arg1_226]

	local function var1_226()
		arg0_226.playing = true

		arg0_226:frozen()
		var0_226:SetActive(true)

		local var0_227 = tf(var0_226)

		pg.UIMgr.GetInstance():OverlayPanel(var0_227, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_226 then
			arg3_226(var0_226)
		end

		var0_227:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_228)
			arg0_226.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_227, arg0_226._tf)

			if arg2_226 then
				arg2_226(var0_226)
			end

			arg0_226:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_226 then
		PoolMgr.GetInstance():GetUI(arg1_226, true, function(arg0_229)
			arg0_229:SetActive(true)

			arg0_226.uiAnims[arg1_226] = arg0_229
			var0_226 = arg0_226.uiAnims[arg1_226]

			var1_226()
		end)
	else
		var1_226()
	end
end

function var0_0.destroyUIAnims(arg0_230)
	if arg0_230.uiAnims then
		for iter0_230, iter1_230 in pairs(arg0_230.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_230), arg0_230._tf)
			iter1_230:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_230, iter1_230)
		end

		arg0_230.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_231, arg1_231)
	local function var0_231()
		arg0_231.playing = true

		arg0_231:frozen()
		arg0_231.torpetoAni:SetActive(true)

		local var0_232 = tf(arg0_231.torpetoAni)

		var0_232:SetParent(arg0_231.topPanel, false)
		var0_232:SetAsLastSibling()
		var0_232:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_233)
			arg0_231.playing = false

			SetActive(arg0_231.torpetoAni, false)

			if arg1_231 then
				arg1_231()
			end

			arg0_231:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_231.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_234)
			arg0_234:SetActive(true)

			arg0_231.torpetoAni = arg0_234

			var0_231()
		end)
	else
		var0_231()
	end
end

function var0_0.destroyTorpedo(arg0_235)
	if arg0_235.torpetoAni then
		arg0_235.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_235.torpetoAni)

		arg0_235.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_236, arg1_236, arg2_236, arg3_236)
	arg0_236.strikeAnims = arg0_236.strikeAnims or {}

	local var0_236
	local var1_236
	local var2_236

	local function var3_236()
		if coroutine.status(var2_236) == "suspended" then
			local var0_237, var1_237 = coroutine.resume(var2_236)

			assert(var0_237, debug.traceback(var2_236, var1_237))
		end
	end

	var2_236 = coroutine.create(function()
		arg0_236.playing = true

		arg0_236:frozen()

		local var0_238 = arg0_236.strikeAnims[arg2_236]

		setActive(var0_238, true)

		local var1_238 = tf(var0_238)
		local var2_238 = findTF(var1_238, "torpedo")
		local var3_238 = findTF(var1_238, "mask/painting")
		local var4_238 = findTF(var1_238, "ship")

		setParent(var0_236, var3_238:Find("fitter"), false)
		setParent(var1_236, var4_238, false)
		setActive(var4_238, false)
		setActive(var2_238, false)
		var1_238:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_238:SetAsLastSibling()

		local var5_238 = var1_238:GetComponent("DftAniEvent")
		local var6_238 = var1_236:GetComponent("SpineAnimUI")
		local var7_238 = var6_238:GetComponent("SkeletonGraphic")

		var5_238:SetStartEvent(function(arg0_239)
			var6_238:SetAction("attack", 0)

			var7_238.freeze = true
		end)
		var5_238:SetTriggerEvent(function(arg0_240)
			var7_238.freeze = false

			var6_238:SetActionCallBack(function(arg0_241)
				if arg0_241 == "action" then
					-- block empty
				elseif arg0_241 == "finish" then
					var7_238.freeze = true
				end
			end)
		end)
		var5_238:SetEndEvent(function(arg0_242)
			var7_238.freeze = false

			var3_236()
		end)
		onButton(arg0_236, var1_238, var3_236, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_238, arg1_236:getPainting())
		var6_238:SetActionCallBack(nil)

		var7_238.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_236:getPrefab(), var1_236)
		setActive(var0_238, false)

		arg0_236.playing = false

		arg0_236:unfrozen()

		if arg3_236 then
			arg3_236()
		end
	end)

	local function var4_236()
		if arg0_236.strikeAnims[arg2_236] and var0_236 and var1_236 then
			var3_236()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_236:getPainting(), true, function(arg0_244)
		var0_236 = arg0_244

		ShipExpressionHelper.SetExpression(var0_236, arg1_236:getPainting())
		var4_236()
	end)
	PoolMgr.GetInstance():GetSpineChar(arg1_236:getPrefab(), true, function(arg0_245)
		var1_236 = arg0_245
		var1_236.transform.localScale = Vector3.one

		var4_236()
	end)

	if not arg0_236.strikeAnims[arg2_236] then
		PoolMgr.GetInstance():GetUI(arg2_236, true, function(arg0_246)
			arg0_236.strikeAnims[arg2_236] = arg0_246

			var4_236()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_247)
	if arg0_247.strikeAnims then
		for iter0_247, iter1_247 in pairs(arg0_247.strikeAnims) do
			iter1_247:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_247, iter1_247)
		end

		arg0_247.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_248, arg1_248, arg2_248, arg3_248)
	arg0_248.strikeAnims = arg0_248.strikeAnims or {}

	local var0_248
	local var1_248

	local function var2_248()
		if coroutine.status(var1_248) == "suspended" then
			local var0_249, var1_249 = coroutine.resume(var1_248)

			assert(var0_249, debug.traceback(var1_248, var1_249))
		end
	end

	var1_248 = coroutine.create(function()
		arg0_248.playing = true

		arg0_248:frozen()

		local var0_250 = arg0_248.strikeAnims[arg2_248]

		setActive(var0_250, true)

		local var1_250 = tf(var0_250)
		local var2_250 = findTF(var1_250, "torpedo")
		local var3_250 = findTF(var1_250, "ship")

		setParent(var0_248, var3_250, false)
		setActive(var3_250, false)
		setActive(var2_250, false)
		var1_250:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_250:SetAsLastSibling()

		local var4_250 = var1_250:GetComponent("DftAniEvent")
		local var5_250 = var0_248:GetComponent("SpineAnimUI")
		local var6_250 = var5_250:GetComponent("SkeletonGraphic")

		var4_250:SetStartEvent(function(arg0_251)
			var5_250:SetAction("attack", 0)

			var6_250.freeze = true
		end)
		var4_250:SetTriggerEvent(function(arg0_252)
			var6_250.freeze = false

			var5_250:SetActionCallBack(function(arg0_253)
				if arg0_253 == "action" then
					-- block empty
				elseif arg0_253 == "finish" then
					var6_250.freeze = true
				end
			end)
		end)
		var4_250:SetEndEvent(function(arg0_254)
			var6_250.freeze = false

			var2_248()
		end)
		onButton(arg0_248, var1_250, var2_248, SFX_CANCEL)
		coroutine.yield()
		var5_250:SetActionCallBack(nil)

		var6_250.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_248:getPrefab(), var0_248)
		setActive(var0_250, false)

		arg0_248.playing = false

		arg0_248:unfrozen()

		if arg3_248 then
			arg3_248()
		end
	end)

	local function var3_248()
		if arg0_248.strikeAnims[arg2_248] and var0_248 then
			var2_248()
		end
	end

	PoolMgr.GetInstance():GetSpineChar(arg1_248:getPrefab(), true, function(arg0_256)
		var0_248 = arg0_256
		var0_248.transform.localScale = Vector3.one

		var3_248()
	end)

	if not arg0_248.strikeAnims[arg2_248] then
		PoolMgr.GetInstance():GetUI(arg2_248, true, function(arg0_257)
			arg0_248.strikeAnims[arg2_248] = arg0_257

			var3_248()
		end)
	end
end

function var0_0.doSignalSearch(arg0_258, arg1_258)
	arg0_258:frozen()

	local function var0_258()
		arg0_258.playing = true

		arg0_258.signalAni:SetActive(true)

		local var0_259 = tf(arg0_258.signalAni)

		var0_259:SetParent(arg0_258.topPanel, false)
		var0_259:SetAsLastSibling()
		var0_259:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_260)
			arg0_258.playing = false

			SetActive(arg0_258.signalAni, false)

			if arg1_258 then
				arg1_258()
			end

			arg0_258:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_258.signalAni then
		PoolMgr.GetInstance():GetUI("SignalUI", true, function(arg0_261)
			arg0_261:SetActive(true)

			arg0_258.signalAni = arg0_261

			var0_258()
		end)
	else
		var0_258()
	end
end

function var0_0.destroySignalSearch(arg0_262)
	if arg0_262.signalAni then
		arg0_262.signalAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("SignalUI", arg0_262.signalAni)

		arg0_262.signalAni = nil
	end
end

function var0_0.doPlayCommander(arg0_263, arg1_263, arg2_263)
	arg0_263:frozen()
	setActive(arg0_263.commanderTinkle, true)

	local var0_263 = arg1_263:getSkills()

	setText(arg0_263.commanderTinkle:Find("name"), #var0_263 > 0 and var0_263[1]:getConfig("name") or "")
	setImageSprite(arg0_263.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_263:getConfig("painting"), ""))

	local var1_263 = arg0_263.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_263.alpha = 0

	local var2_263 = Vector2(248, 237)

	LeanTween.value(go(arg0_263.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_264)
		local var0_264 = arg0_263.commanderTinkle.localPosition

		var0_264.x = var2_263.x + -100 * (1 - arg0_264)
		arg0_263.commanderTinkle.localPosition = var0_264
		var1_263.alpha = arg0_264
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_263.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_265)
		local var0_265 = arg0_263.commanderTinkle.localPosition

		var0_265.x = var2_263.x + 100 * arg0_265
		arg0_263.commanderTinkle.localPosition = var0_265
		var1_263.alpha = 1 - arg0_265
	end)):setOnComplete(System.Action(function()
		if arg2_263 then
			arg2_263()
		end

		arg0_263:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_267, arg1_267, arg2_267, arg3_267)
	local var0_267 = arg0_267.grid:shakeCell(arg1_267)

	if not var0_267 then
		arg3_267()

		return
	end

	arg0_267:easeDamage(var0_267, arg2_267, function()
		arg3_267()
	end)
end

function var0_0.easeDamage(arg0_269, arg1_269, arg2_269, arg3_269)
	arg0_269:frozen()

	local var0_269 = arg0_269.levelCam:WorldToScreenPoint(arg1_269.position)
	local var1_269 = tf(arg0_269:GetDamageText())

	var1_269.position = arg0_269.uiCam:ScreenToWorldPoint(var0_269)

	local var2_269 = var1_269.localPosition

	var2_269.y = var2_269.y + 40
	var2_269.z = 0

	setText(var1_269, arg2_269)

	var1_269.localPosition = var2_269

	LeanTween.value(go(var1_269), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_270)
		local var0_270 = var1_269.localPosition

		var0_270.y = var2_269.y + 60 * arg0_270
		var1_269.localPosition = var0_270

		setTextAlpha(var1_269, 1 - arg0_270)
	end)):setOnComplete(System.Action(function()
		arg0_269:ReturnDamageText(var1_269)
		arg0_269:unfrozen()

		if arg3_269 then
			arg3_269()
		end
	end))
end

function var0_0.easeAvoid(arg0_272, arg1_272, arg2_272)
	arg0_272:frozen()

	local var0_272 = arg0_272.levelCam:WorldToScreenPoint(arg1_272)

	arg0_272.avoidText.position = arg0_272.uiCam:ScreenToWorldPoint(var0_272)

	local var1_272 = arg0_272.avoidText.localPosition

	var1_272.z = 0
	arg0_272.avoidText.localPosition = var1_272

	setActive(arg0_272.avoidText, true)

	local var2_272 = arg0_272.avoidText:Find("avoid")

	LeanTween.value(go(arg0_272.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_273)
		local var0_273 = arg0_272.avoidText.localPosition

		var0_273.y = var1_272.y + 100 * arg0_273
		arg0_272.avoidText.localPosition = var0_273

		setImageAlpha(arg0_272.avoidText, 1 - arg0_273)
		setImageAlpha(var2_272, 1 - arg0_273)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_272.avoidText, false)
		arg0_272:unfrozen()

		if arg2_272 then
			arg2_272()
		end
	end))
end

function var0_0.GetDamageText(arg0_275)
	local var0_275 = table.remove(arg0_275.damageTextPool)

	if not var0_275 then
		var0_275 = Instantiate(arg0_275.damageTextTemplate)

		local var1_275 = tf(arg0_275.damageTextTemplate):GetSiblingIndex()

		setParent(var0_275, tf(arg0_275.damageTextTemplate).parent)
		tf(var0_275):SetSiblingIndex(var1_275 + 1)
	end

	table.insert(arg0_275.damageTextActive, var0_275)
	setActive(var0_275, true)

	return var0_275
end

function var0_0.ReturnDamageText(arg0_276, arg1_276)
	assert(arg1_276)

	if not arg1_276 then
		return
	end

	arg1_276 = go(arg1_276)

	table.removebyvalue(arg0_276.damageTextActive, arg1_276)
	table.insert(arg0_276.damageTextPool, arg1_276)
	setActive(arg1_276, false)
end

function var0_0.resetLevelGrid(arg0_277)
	arg0_277.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_278, arg1_278)
	setActive(arg0_278.curtain, arg1_278)
end

function var0_0.frozen(arg0_279)
	local var0_279 = arg0_279.frozenCount

	arg0_279.frozenCount = arg0_279.frozenCount + 1
	arg0_279.canvasGroup.blocksRaycasts = arg0_279.frozenCount == 0

	if var0_279 == 0 and arg0_279.frozenCount ~= 0 then
		arg0_279:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_280, arg1_280)
	if arg0_280.exited then
		return
	end

	local var0_280 = arg0_280.frozenCount
	local var1_280 = arg1_280 == -1 and arg0_280.frozenCount or arg1_280 or 1

	arg0_280.frozenCount = arg0_280.frozenCount - var1_280
	arg0_280.canvasGroup.blocksRaycasts = arg0_280.frozenCount == 0

	if var0_280 ~= 0 and arg0_280.frozenCount == 0 then
		arg0_280:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_281)
	return arg0_281.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_282)
	arg0_282.levelCamIndices = math.max(arg0_282.levelCamIndices - 1, 0)

	if arg0_282.levelCamIndices == 0 then
		arg0_282.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.disableLevelCamera(arg0_283)
	arg0_283.levelCamIndices = arg0_283.levelCamIndices + 1

	if arg0_283.levelCamIndices > 0 then
		arg0_283.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.RecordTween(arg0_284, arg1_284, arg2_284)
	arg0_284.tweens[arg1_284] = arg2_284
end

function var0_0.DeleteTween(arg0_285, arg1_285)
	local var0_285 = arg0_285.tweens[arg1_285]

	if var0_285 then
		LeanTween.cancel(var0_285)

		arg0_285.tweens[arg1_285] = nil
	end
end

function var0_0.openCommanderPanel(arg0_286, arg1_286, arg2_286, arg3_286)
	local var0_286 = arg2_286.id

	arg0_286.levelCMDFormationView:setCallback(function(arg0_287)
		if not arg3_286 then
			if arg0_287.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_286:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_287.skill)
			elseif arg0_287.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_286.contextData.commanderSelected = {
					chapterId = var0_286,
					fleetId = arg1_286.id
				}

				arg0_286:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_287.pos, arg1_286.id, arg2_286)
				arg0_286:closeCommanderPanel()
			else
				arg0_286:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_287,
					fleetId = arg1_286.id,
					chapterId = var0_286
				}, arg2_286)
			end
		elseif arg0_287.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_286:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_287.skill)
		elseif arg0_287.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_286.contextData.eliteCommanderSelected = {
				index = arg3_286,
				pos = arg0_287.pos,
				chapterId = var0_286
			}

			arg0_286:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_286, arg0_287.pos, arg2_286)
			arg0_286:closeCommanderPanel()
		else
			arg0_286:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_287,
				index = arg3_286,
				chapterId = var0_286
			}, arg2_286)
		end
	end)
	arg0_286.levelCMDFormationView:Load()
	arg0_286.levelCMDFormationView:ActionInvoke("update", arg1_286, arg0_286.commanderPrefabs)
	arg0_286.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_288)
	if arg0_288.levelCMDFormationView:isShowing() then
		arg0_288.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_288.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_289)
	arg0_289.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_290)
	arg0_290.levelCMDFormationView:Destroy()

	arg0_290.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_291, arg1_291)
	arg0_291.spTickets = arg1_291
end

function var0_0.HandleShowMsgBox(arg0_292, arg1_292)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_292)
end

function var0_0.updatePoisonAreaTip(arg0_293)
	local var0_293 = arg0_293.contextData.chapterVO
	local var1_293 = (function(arg0_294)
		local var0_294 = {}
		local var1_294 = pg.map_event_list[var0_293.id] or {}
		local var2_294

		if var0_293:isLoop() then
			var2_294 = var1_294.event_list_loop or {}
		else
			var2_294 = var1_294.event_list or {}
		end

		for iter0_294, iter1_294 in ipairs(var2_294) do
			local var3_294 = pg.map_event_template[iter1_294]

			if var3_294.c_type == arg0_294 then
				table.insert(var0_294, var3_294)
			end
		end

		return var0_294
	end)(ChapterConst.EvtType_Poison)

	if var1_293 then
		for iter0_293, iter1_293 in ipairs(var1_293) do
			local var2_293 = iter1_293.round_gametip

			if var2_293 ~= nil and var2_293 ~= "" and var0_293:getRoundNum() == var2_293[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_293[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_295)
	setActive(arg0_295._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_296)
	local var0_296 = getProxy(ChapterProxy)

	if var0_296 and not arg0_296.contextData.noRecord then
		local var1_296 = arg0_296.contextData.map

		if not var1_296 then
			return
		end

		if var1_296 and var1_296:NeedRecordMap() then
			var0_296:recordLastMap(ChapterProxy.LAST_MAP, var1_296.id)
		end

		if Map.lastMapForActivity then
			var0_296:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, Map.lastMapForActivity)
		end
	end
end

function var0_0.willExit(arg0_297)
	arg0_297:ClearMapTransitions()
	arg0_297.loader:Clear()

	if arg0_297.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_297.topPanel, arg0_297._tf)
		pg.playerResUI:SetActive({
			active = false
		})
	end

	if arg0_297.levelFleetView and arg0_297.levelFleetView.selectIds then
		arg0_297.contextData.selectedFleetIDs = {}

		for iter0_297, iter1_297 in pairs(arg0_297.levelFleetView.selectIds) do
			for iter2_297, iter3_297 in pairs(iter1_297) do
				arg0_297.contextData.selectedFleetIDs[#arg0_297.contextData.selectedFleetIDs + 1] = iter3_297
			end
		end
	end

	arg0_297:destroyChapterPanel()
	arg0_297:destroyFleetEdit()
	arg0_297:destroyCommanderPanel()
	arg0_297:DestroyLevelStageView()
	arg0_297:hideRepairWindow()
	arg0_297:hideStrategyInfo()
	arg0_297:hideRemasterPanel()
	arg0_297:hideSpResult()
	arg0_297:destroyGrid()
	arg0_297:destroyAmbushWarn()
	arg0_297:destroyAirStrike()
	arg0_297:destroyTorpedo()
	arg0_297:destroyStrikeAnim()
	arg0_297:destroyTracking()
	arg0_297:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_297, iter5_297 in pairs(arg0_297.mbDict) do
		iter5_297:Destroy()
	end

	arg0_297.mbDict = nil

	for iter6_297, iter7_297 in pairs(arg0_297.tweens) do
		LeanTween.cancel(iter7_297)
	end

	arg0_297.tweens = nil

	if arg0_297.cloudTimer then
		_.each(arg0_297.cloudTimer, function(arg0_298)
			LeanTween.cancel(arg0_298)
		end)

		arg0_297.cloudTimer = nil
	end

	if arg0_297.newChapterCDTimer then
		arg0_297.newChapterCDTimer:Stop()

		arg0_297.newChapterCDTimer = nil
	end

	for iter8_297, iter9_297 in ipairs(arg0_297.damageTextActive) do
		LeanTween.cancel(iter9_297)
	end

	LeanTween.cancel(go(arg0_297.avoidText))

	arg0_297.map.localScale = Vector3.one
	arg0_297.map.pivot = Vector2(0.5, 0.5)
	arg0_297.float.localScale = Vector3.one
	arg0_297.float.pivot = Vector2(0.5, 0.5)

	for iter10_297, iter11_297 in ipairs(arg0_297.mapTFs) do
		clearImageSprite(iter11_297)
	end

	_.each(arg0_297.cloudRTFs, function(arg0_299)
		clearImageSprite(arg0_299)
	end)
	PoolMgr.GetInstance():DestroyAllSprite()
	Destroy(arg0_297.enemyTpl)
	arg0_297:RecordLastMapOnExit()
	arg0_297.levelRemasterView:Destroy()
end

return var0_0
