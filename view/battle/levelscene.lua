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

	local var0_11 = arg0_11._tf.rect.size

	arg0_11.mapWidth, arg0_11.mapHeight = var0_11.x, var0_11.y
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
	arg0_12.actAtelierYumiaBuffBtn = arg0_12.rightChapter:Find("event_btns/BottomList/btn_yumia_buff")
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

	arg0_12.UIFXList = arg0_12:findTF("maps/UI_FX_list")

	local var0_12 = arg0_12.UIFXList:GetComponentsInChildren(typeof(Renderer)):ToTable()

	for iter2_12, iter3_12 in ipairs(var0_12) do
		iter3_12.sortingOrder = -1
	end

	arg0_12.rtRightPanel = arg0_12._tf:Find("entrance/enters/right_panel")
	arg0_12.actBtnTpl = arg0_12.rtRightPanel:Find("content/tpl")

	local var1_12 = pg.UIMgr.GetInstance()

	arg0_12.levelCam = var1_12.levelCamera:GetComponent(typeof(Camera))
	arg0_12.uiMain = var1_12.LevelMain

	setActive(arg0_12.uiMain, false)

	arg0_12.uiCam = var1_12.uiCamera:GetComponent(typeof(Camera))
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

	if not arg0_33.ptActivity then
		return
	end

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

		switch(arg0_36.entranceActivity:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0_36:emit(LevelMediator2.ON_ACTIVITY_MAP, arg0_36.entranceActivity.id)
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

	arg0_36.entranceActivity = getProxy(ActivityProxy):getEnterReadyActivity()[1]

	setActive(arg0_36.entranceLayer:Find("enters/enter_ready/nothing"), not tobool(arg0_36.entranceActivity))
	setActive(arg0_36.entranceLayer:Find("enters/enter_ready/activity"), tobool(arg0_36.entranceActivity))

	if tobool(arg0_36.entranceActivity) then
		local var0_36 = arg0_36.entranceActivity:getConfig("config_client").entrance_bg

		if var0_36 then
			GetImageSpriteFromAtlasAsync(var0_36, "", arg0_36.entranceLayer:Find("enters/enter_ready/activity"), true)
		end
	end

	arg0_36:updateRightPanel()

	local var1_36 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "EventMediator")

	setActive(arg0_36.btnSpecial:Find("lock"), not var1_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_task/lock"), not var1_36)

	local var2_36 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "DailyLevelMediator")

	setActive(arg0_36.dailyBtn:Find("lock"), not var2_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_daily/lock"), not var2_36)

	local var3_36 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "MilitaryExerciseMediator")

	setActive(arg0_36.militaryExerciseBtn:Find("lock"), not var3_36)
	setActive(arg0_36.entranceLayer:Find("btns/btn_pvp/lock"), not var3_36)

	local var4_36 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_36.player.level, "WorldMediator")

	setActive(arg0_36.entranceLayer:Find("enters/enter_world/enter/lock"), not var4_36)

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

function var0_0.updateRightPanel(arg0_58)
	arg0_58.rightActivityBtns = defaultValue(arg0_58.rightActivityBtns, {
		LevelSecondMapBtn.New(arg0_58.actBtnTpl, arg0_58.event, false)
	})

	local var0_58 = {}
	local var1_58 = {}

	for iter0_58, iter1_58 in ipairs(arg0_58.rightActivityBtns) do
		if iter1_58:InShowTime() then
			table.insert(var0_58, iter1_58)
		else
			table.insert(var1_58, iter1_58)
		end
	end

	table.sort(var0_58, CompareFuncs({
		function(arg0_59)
			return arg0_59.config.group_id
		end
	}))

	for iter2_58, iter3_58 in ipairs(var0_58) do
		iter3_58:Init(iter2_58)
	end

	for iter4_58, iter5_58 in ipairs(var1_58) do
		iter5_58:Clear()
	end
end

function var0_0.checkChallengeOpen(arg0_60)
	local var0_60 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_60, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_61)
	if arg0_61.contextData.map and arg0_61.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_61)
end

function var0_0.onBackPressed(arg0_62)
	if arg0_62:isfrozen() then
		return
	end

	if arg0_62.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_62.levelInfoView:isShowing() then
		arg0_62:hideChapterPanel()

		return
	end

	if arg0_62.levelInfoSPView and arg0_62.levelInfoSPView:isShowing() then
		arg0_62:HideLevelInfoSPPanel()

		return
	end

	if arg0_62.levelFleetView:isShowing() then
		arg0_62:hideFleetEdit()

		return
	end

	if arg0_62.levelStrategyView then
		arg0_62:hideStrategyInfo()

		return
	end

	if arg0_62.levelRepairView then
		arg0_62:hideRepairWindow()

		return
	end

	if arg0_62.levelRemasterView:isShowing() then
		arg0_62:hideRemasterPanel()

		return
	end

	if isActive(arg0_62.helpPage) then
		setActive(arg0_62.helpPage, false)

		return
	end

	local var0_62 = arg0_62.contextData.chapterVO
	local var1_62 = getProxy(ChapterProxy):getActiveChapter()

	if var0_62 and var1_62 then
		arg0_62:switchToMap()

		return
	end

	triggerButton(arg0_62:findTF("back_button", arg0_62.topChapter))
end

function var0_0.ShowEntranceUI(arg0_63, arg1_63)
	setActive(arg0_63.entranceLayer, arg1_63)
	setActive(arg0_63.entranceBg, arg1_63)
	setActive(arg0_63.map, not arg1_63)
	setActive(arg0_63.float, not arg1_63)
	setActive(arg0_63.mainLayer, not arg1_63)
	setActive(arg0_63.topChapter:Find("type_entrance"), arg1_63)

	arg0_63.contextData.entranceStatus = tobool(arg1_63)

	if arg1_63 then
		setActive(arg0_63.topChapter:Find("title_chapter"), false)
		setActive(arg0_63.topChapter:Find("type_chapter"), false)
		setActive(arg0_63.topChapter:Find("type_escort"), false)
		setActive(arg0_63.topChapter:Find("type_skirmish"), false)

		if arg0_63.newChapterCDTimer then
			arg0_63.newChapterCDTimer:Stop()

			arg0_63.newChapterCDTimer = nil
		end

		arg0_63:RecordLastMapOnExit()

		arg0_63.contextData.mapIdx = nil
		arg0_63.contextData.map = nil
	end

	arg0_63:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_64, arg1_64, arg2_64)
	if arg0_64.preloadLevelDone then
		existCall(arg2_64)

		return
	end

	local var0_64

	local function var1_64()
		if not arg0_64.exited then
			arg0_64.preloadLevelDone = true

			existCall(arg2_64)
		end
	end

	local var2_64 = getProxy(ChapterProxy):getMapById(arg1_64)
	local var3_64 = arg0_64:GetMapBG(var2_64)

	table.ParallelIpairsAsync(var3_64, function(arg0_66, arg1_66, arg2_66)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_66.BG, "", arg2_66)
	end, var1_64)
end

function var0_0.setShips(arg0_67, arg1_67)
	arg0_67.shipVOs = arg1_67
end

function var0_0.updateRes(arg0_68, arg1_68)
	if arg0_68.levelStageView then
		arg0_68.levelStageView:ActionInvoke("SetPlayer", arg1_68)
	end

	arg0_68.player = arg1_68
end

function var0_0.setEliteQuota(arg0_69, arg1_69, arg2_69)
	local var0_69 = arg2_69 - arg1_69
	local var1_69 = arg0_69:findTF("bg/Text", arg0_69.eliteQuota):GetComponent(typeof(Text))

	if arg1_69 == arg2_69 then
		var1_69.color = Color.red
	else
		var1_69.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_69.text = var0_69 .. "/" .. arg2_69
end

function var0_0.updateEvent(arg0_70, arg1_70)
	local var0_70 = arg1_70:hasFinishState()

	setActive(arg0_70.btnSpecial:Find("tip"), var0_70)
	setActive(arg0_70.entranceLayer:Find("btns/btn_task/tip"), var0_70)
end

function var0_0.updateFleet(arg0_71, arg1_71)
	arg0_71.fleets = arg1_71
end

function var0_0.updateChapterVO(arg0_72, arg1_72, arg2_72)
	if arg0_72.contextData.chapterVO and arg0_72.contextData.chapterVO.id == arg1_72.id and arg1_72.active then
		arg0_72:setChapter(arg1_72)
	end

	if arg0_72.contextData.chapterVO and arg0_72.contextData.chapterVO.id == arg1_72.id and arg1_72.active and arg0_72.levelStageView and arg0_72.grid then
		local var0_72 = false
		local var1_72 = false
		local var2_72 = false

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyFleet) > 0 then
			arg0_72.levelStageView:updateStageFleet()
			arg0_72.levelStageView:updateAmbushRate(arg1_72.fleet.line, true)

			var2_72 = true

			if arg0_72.grid then
				arg0_72.grid:RefreshFleetCells()
				arg0_72.grid:UpdateFloor()

				var0_72 = true
			end
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyChampion) > 0 then
			var2_72 = true

			if arg0_72.grid then
				arg0_72.grid:UpdateFleets()
				arg0_72.grid:clearChampions()
				arg0_72.grid:initChampions()

				var1_72 = true
			end
		elseif bit.band(arg2_72, ChapterConst.DirtyChampionPosition) > 0 then
			var2_72 = true

			if arg0_72.grid then
				arg0_72.grid:UpdateFleets()
				arg0_72.grid:updateChampions()

				var1_72 = true
			end
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyAchieve) > 0 then
			arg0_72.levelStageView:updateStageAchieve()
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyAttachment) > 0 then
			arg0_72.levelStageView:updateAmbushRate(arg1_72.fleet.line, true)

			if arg0_72.grid then
				if not (arg2_72 < 0) and not (bit.band(arg2_72, ChapterConst.DirtyFleet) > 0) then
					arg0_72.grid:updateFleet(arg1_72.fleets[arg1_72.findex].id)
				end

				arg0_72.grid:updateAttachments()

				if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyAutoAction) > 0 then
					arg0_72.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_72 = true
				end
			end
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyStrategy) > 0 then
			arg0_72.levelStageView:updateStageStrategy()

			var2_72 = true

			arg0_72.levelStageView:updateStageBarrier()
			arg0_72.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_72 then
			arg0_72.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_72 then
			arg0_72.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyCellFlag) > 0 then
			arg0_72.grid:UpdateFloor()
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyBase) > 0 then
			arg0_72.levelStageView:UpdateDefenseStatus()
		end

		if arg2_72 < 0 or bit.band(arg2_72, ChapterConst.DirtyFloatItems) > 0 then
			arg0_72.grid:UpdateItemCells()
		end

		if var2_72 then
			arg0_72.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_73)
	arg0_73.cloudRTFs = {}
	arg0_73.cloudRects = {}
	arg0_73.cloudTimer = {}

	for iter0_73 = 1, 6 do
		local var0_73 = arg0_73:findTF("cloud_" .. iter0_73, arg0_73.clouds)
		local var1_73 = rtf(var0_73)

		table.insert(arg0_73.cloudRTFs, var1_73)
		table.insert(arg0_73.cloudRects, var1_73.rect.width)
	end

	arg0_73:initCloudsPos()

	for iter1_73, iter2_73 in ipairs(arg0_73.cloudRTFs) do
		local var2_73 = arg0_73.cloudRects[iter1_73]
		local var3_73 = arg0_73.initPositions[iter1_73] or Vector2(0, 0)
		local var4_73 = 30 - var3_73.y / 20
		local var5_73 = (arg0_73.mapWidth + var2_73) / var4_73
		local var6_73

		var6_73 = LeanTween.moveX(iter2_73, arg0_73.mapWidth, var5_73):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_73 = arg0_73.cloudRects[iter1_73]
			iter2_73.anchoredPosition = Vector2(-var2_73, var3_73.y)

			var6_73:setFrom(-var2_73):setTime((arg0_73.mapWidth + var2_73) / var4_73)
		end))
		var6_73.passed = math.random() * var5_73
		arg0_73.cloudTimer[iter1_73] = var6_73.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_75)
	arg0_75:PlayBGM()
	arg0_75:SwitchMapBG(arg0_75.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_76, arg1_76, arg2_76)
	if not arg1_76 then
		return
	end

	local var0_76 = arg0_76.contextData.map:getConfig("ani_controller")

	local function var1_76(arg0_77)
		arg0_77 = tf(arg0_77)

		local var0_77 = Vector3.one

		if arg0_77.rect.width > 0 and arg0_77.rect.height > 0 then
			var0_77.x = arg0_77.parent.rect.width / arg0_77.rect.width
			var0_77.y = arg0_77.parent.rect.height / arg0_77.rect.height
		end

		arg0_77.localScale = var0_77

		if var0_76 and #var0_76 > 0 then
			(function()
				for iter0_78, iter1_78 in ipairs(var0_76) do
					if iter1_78[1] == var2_0 then
						local var0_78 = iter1_78[2][1]
						local var1_78 = _.rest(iter1_78[2], 2)

						for iter2_78, iter3_78 in ipairs(var1_78) do
							local var2_78 = arg0_77:Find(iter3_78)

							if not IsNil(var2_78) then
								local var3_78 = getProxy(ChapterProxy):GetChapterItemById(var0_78)

								if var3_78 and not var3_78:isClear() then
									setActive(var2_78, false)
								end
							end
						end
					elseif iter1_78[1] == var3_0 then
						local var4_78 = iter1_78[2][1]
						local var5_78 = _.rest(iter1_78[2], 2)

						for iter4_78, iter5_78 in ipairs(var5_78) do
							local var6_78 = arg0_77:Find(iter5_78)

							if not IsNil(var6_78) then
								local var7_78 = getProxy(ChapterProxy):GetChapterItemById(var4_78)

								if var7_78 and not var7_78:isClear() then
									setActive(var6_78, true)

									return
								end
							end
						end
					elseif iter1_78[1] == var4_0 then
						local var8_78 = iter1_78[2][1]
						local var9_78 = _.rest(iter1_78[2], 2)

						for iter6_78, iter7_78 in ipairs(var9_78) do
							local var10_78 = arg0_77:Find(iter7_78)

							if not IsNil(var10_78) then
								local var11_78 = getProxy(ChapterProxy):GetChapterItemById(var8_78)

								if var11_78 and not var11_78:isClear() then
									setActive(var10_78, true)
								end
							end
						end
					end
				end
			end)()
		end
	end

	local var2_76 = arg0_76.loader:GetPrefab("ui/" .. arg1_76, arg1_76, function(arg0_79)
		arg0_79:SetActive(true)

		local var0_79 = arg0_76.mapTFs[arg2_76]

		setParent(arg0_79, var0_79)
		pg.ViewUtils.SetSortingOrder(arg0_79, ChapterConst.LayerWeightMap + arg2_76 * 2 - 1)
		var1_76(arg0_79)
	end)

	table.insert(arg0_76.mapGroup, var2_76)
end

function var0_0.HideBtns(arg0_80)
	setActive(arg0_80.btnPrev, false)
	setActive(arg0_80.eliteQuota, false)
	setActive(arg0_80.escortBar, false)
	setActive(arg0_80.skirmishBar, false)
	setActive(arg0_80.normalBtn, false)
	setActive(arg0_80.actNormalBtn, false)
	setActive(arg0_80.eliteBtn, false)
	setActive(arg0_80.actEliteBtn, false)
	setActive(arg0_80.actExtraBtn, false)
	setActive(arg0_80.remasterBtn, false)
	setActive(arg0_80.btnNext, false)
	setActive(arg0_80.remasterAwardBtn, false)
	setActive(arg0_80.eventContainer, false)
	setActive(arg0_80.activityBtn, false)
	setActive(arg0_80.ptTotal, false)
	setActive(arg0_80.ticketTxt.parent, false)
	setActive(arg0_80.countDown, false)
	setActive(arg0_80.actAtelierBuffBtn, false)
	setActive(arg0_80.actAtelierYumiaBuffBtn, false)
	setActive(arg0_80.actExtraRank, false)
	setActive(arg0_80.actExchangeShopBtn, false)
	setActive(arg0_80.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_81)
	local var0_81 = arg0_81.contextData.map:getConfig("type")

	setActive(arg0_81.normalBtn, var0_81 == Map.ELITE)
	setActive(arg0_81.eliteQuota, var0_81 == Map.ELITE)
	setActive(arg0_81.eliteBtn, var0_81 == Map.SCENARIO)

	local var1_81 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_81.eliteBtn:Find("pic_activity"), var1_81 and not var1_81:isEnd())
end

function var0_0.updateActivityBtns(arg0_82)
	local var0_82 = arg0_82.contextData.map
	local var1_82, var2_82 = var0_82:isActivity()
	local var3_82 = var0_82:isRemaster()
	local var4_82 = var0_82:isSkirmish()
	local var5_82 = var0_82:isEscort()
	local var6_82 = var0_82:getConfig("type")
	local var7_82 = setmetatable({}, MainActMapBtn)
	local var8_82 = var7_82:InShowTime() and not var1_82 and not var4_82 and not var5_82

	if var8_82 then
		var7_82.image = arg0_82.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var7_82.subImage = arg0_82.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var7_82.tipTr = arg0_82.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var7_82.tipTxt = arg0_82.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_82 = var7_82:InShowTime()

		if var8_82 then
			var7_82:InitTipImage()
			var7_82:InitSubImage()
			var7_82:InitImage(function()
				return
			end)
			var7_82:OnInit()
		end
	end

	setActive(arg0_82.activityBtn, var8_82)
	arg0_82:updateRemasterInfo()

	if var1_82 and var2_82 then
		local var9_82

		if var0_82:isRemaster() then
			var9_82 = getProxy(ChapterProxy):getRemasterMaps(var0_82.remasterId)
		else
			var9_82 = getProxy(ChapterProxy):getMapsByActivities(var0_82:getConfig("on_activity"))
		end

		local var10_82 = underscore.any(var9_82, function(arg0_84)
			return arg0_84:isActExtra()
		end)

		setActive(arg0_82.actExtraBtn, var10_82 and var6_82 ~= Map.ACT_EXTRA)

		if isActive(arg0_82.actExtraBtn) then
			if underscore.all(underscore.filter(var9_82, function(arg0_85)
				local var0_85 = arg0_85:getMapType()

				return var0_85 == Map.ACTIVITY_EASY or var0_85 == Map.ACTIVITY_HARD
			end), function(arg0_86)
				return arg0_86:isAllChaptersClear()
			end) then
				setActive(arg0_82.actExtraBtnAnim, true)
			else
				setActive(arg0_82.actExtraBtnAnim, false)
			end

			setActive(arg0_82.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive(var0_82:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_82 = checkExist(var0_82:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_82.actEliteBtn, var11_82 and var6_82 ~= Map.ACTIVITY_HARD)
		setActive(arg0_82.actNormalBtn, var6_82 ~= Map.ACTIVITY_EASY)
		setActive(arg0_82.actExtraRank, var6_82 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_87)
			if not arg0_87 or arg0_87:isEnd() then
				return
			end

			local var0_87 = arg0_87:getConfig("config_data")[1]

			return _.any(var0_82:getChapters(), function(arg0_88)
				if not arg0_88:IsEXChapter() then
					return false
				end

				return table.contains(arg0_88:getConfig("boss_expedition_id"), var0_87)
			end)
		end))
		setActive(arg0_82.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_82 and var2_82 and arg0_82:IsActShopActive())

		local var12_82 = arg0_82.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_82.contextData.map:getConfig("on_activity")) or nil
		local var13_82 = var12_82 and not var12_82:isEnd() and var12_82:GetConfigClientSetting("PTID")

		arg0_82:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_89)
			return arg0_89:getConfig("config_id") == var13_82
		end))
		setActive(arg0_82.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_82 and var2_82 and arg0_82.ptActivity and not arg0_82.ptActivity:isEnd())
	else
		setActive(arg0_82.actExtraBtn, false)
		setActive(arg0_82.actEliteBtn, false)
		setActive(arg0_82.actNormalBtn, false)
		setActive(arg0_82.actExtraRank, false)
		setActive(arg0_82.actExchangeShopBtn, false)
		setActive(arg0_82.actAtelierBuffBtn, false)
		setActive(arg0_82.actAtelierYumiaBuffBtn, false)
		setActive(arg0_82.ptTotal, false)
	end

	setActive(arg0_82.eventContainer, (not var1_82 or not var2_82) and not var5_82)
	setActive(arg0_82.remasterBtn, OPEN_REMASTER and (var3_82 or not var1_82 and not var5_82 and not var4_82))
	setActive(arg0_82.ticketTxt.parent, var3_82)
	arg0_82:updateRemasterTicket()
	arg0_82:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_90)
	setText(arg0_90.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_90:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_91)
	local var0_91 = getProxy(ChapterProxy)
	local var1_91 = var0_91:ifShowRemasterTip() or var0_91:anyRemasterAwardCanReceive()

	SetActive(arg0_91.remasterBtn:Find("tip"), var1_91)
	SetActive(arg0_91.entranceLayer:Find("btns/btn_remaster/tip"), var1_91)
end

function var0_0.updatDailyBtnTip(arg0_92)
	local var0_92 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_92.dailyBtn:Find("tip"), var0_92)
	SetActive(arg0_92.entranceLayer:Find("btns/btn_daily/tip"), var0_92)
end

function var0_0.updateRemasterInfo(arg0_93)
	arg0_93:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_93.contextData.map then
		return
	end

	local var0_93 = getProxy(ChapterProxy)
	local var1_93
	local var2_93 = arg0_93.contextData.map:getRemaster()

	if var2_93 and #pg.re_map_template[var2_93].drop_gain > 0 then
		for iter0_93, iter1_93 in ipairs(pg.re_map_template[var2_93].drop_gain) do
			if #iter1_93 > 0 and var0_93.remasterInfo[iter1_93[1]][iter0_93].receive == false then
				var1_93 = {
					iter0_93,
					iter1_93
				}

				break
			end
		end
	end

	setActive(arg0_93.remasterAwardBtn, var1_93)

	if var1_93 then
		local var3_93 = var1_93[1]
		local var4_93, var5_93, var6_93, var7_93 = unpack(var1_93[2])
		local var8_93 = var0_93.remasterInfo[var4_93][var3_93]

		setText(arg0_93.remasterAwardBtn:Find("Text"), var8_93.count .. "/" .. var7_93)
		updateDrop(arg0_93.remasterAwardBtn:Find("IconTpl"), {
			type = var5_93,
			id = var6_93
		})
		setActive(arg0_93.remasterAwardBtn:Find("tip"), var7_93 <= var8_93.count)
		onButton(arg0_93, arg0_93.remasterAwardBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_93,
					id = var6_93
				},
				weight = LayerWeightConst.TOP_LAYER,
				remaster = {
					word = i18n("level_remaster_tip4", pg.chapter_template[var4_93].chapter_name),
					number = var8_93.count .. "/" .. var7_93,
					btn_text = i18n(var8_93.count < var7_93 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var8_93.count < var7_93 then
							local var0_95 = pg.chapter_template[var4_93].map
							local var1_95, var2_95 = var0_93:getMapById(var0_95):isUnlock()

							if not var1_95 then
								pg.TipsMgr.GetInstance():ShowTips(var2_95)
							else
								arg0_93:ShowSelectedMap(var0_95)
							end
						else
							arg0_93:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_93, var3_93)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_96)
	local var0_96 = getProxy(ChapterProxy)

	if arg0_96.newChapterCDTimer then
		arg0_96.newChapterCDTimer:Stop()

		arg0_96.newChapterCDTimer = nil
	end

	local var1_96 = 0

	if arg0_96.contextData.map:isActivity() and not arg0_96.contextData.map:isRemaster() then
		local var2_96 = var0_96:getMapsByActivities(arg0_96.contextData.map:getConfig("on_activity"))

		_.each(var2_96, function(arg0_97)
			local var0_97 = arg0_97:getChapterTimeLimit()

			if var1_96 == 0 then
				var1_96 = var0_97
			else
				var1_96 = math.min(var1_96, var0_97)
			end
		end)
		setActive(arg0_96.countDown, var1_96 > 0)
		setText(arg0_96.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_96.countDown, false)
	end

	if var1_96 > 0 then
		setText(arg0_96.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_96))

		arg0_96.newChapterCDTimer = Timer.New(function()
			var1_96 = var1_96 - 1

			if var1_96 <= 0 then
				arg0_96:updateCountDown()

				if not arg0_96.contextData.chapterVO then
					arg0_96:setMap(arg0_96.contextData.mapIdx)
				end
			else
				setText(arg0_96.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_96))
			end
		end, 1, -1)

		arg0_96.newChapterCDTimer:Start()
	else
		setText(arg0_96.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_99)
	onButton(arg0_99, arg0_99.actExtraRank, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_99, arg0_99.activityBtn, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_99, arg0_99.actExchangeShopBtn, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_99, arg0_99.actAtelierBuffBtn, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)
	onButton(arg0_99, arg0_99.actAtelierYumiaBuffBtn, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelMediator2.SHOW_ATELIER_BUFF, true)
	end, SFX_UI_CLICK)

	local var0_99 = getProxy(ChapterProxy)

	local function var1_99(arg0_105, arg1_105, arg2_105)
		local var0_105

		if arg0_105:isRemaster() then
			var0_105 = var0_99:getRemasterMaps(arg0_105.remasterId)
		else
			var0_105 = var0_99:getMapsByActivities(arg0_105:getConfig("on_activity"))
		end

		local var1_105 = _.select(var0_105, function(arg0_106)
			return arg0_106:getMapType() == arg1_105
		end)

		table.sort(var1_105, function(arg0_107, arg1_107)
			return arg0_107.id < arg1_107.id
		end)

		local var2_105 = table.indexof(underscore.map(var1_105, function(arg0_108)
			return arg0_108.id
		end), arg2_105) or #var1_105

		while not var1_105[var2_105]:isUnlock() do
			if var2_105 > 1 then
				var2_105 = var2_105 - 1
			else
				break
			end
		end

		return var1_105[var2_105]
	end

	arg0_99:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_109, arg1_109, arg2_109)
		arg2_109 = arg2_109 or switch(arg1_109, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_99.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_99.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_109 = var1_99(arg0_99.contextData.map, arg1_109, arg2_109)
		local var1_109, var2_109 = var0_109:isUnlock()

		if var1_109 then
			arg0_99:setMap(var0_109.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_109)
		end
	end)
	onButton(arg0_99, arg0_99.actNormalBtn, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_99, arg0_99.actEliteBtn, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_99, arg0_99.actExtraBtn, function()
		if arg0_99:isfrozen() then
			return
		end

		arg0_99:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_116, arg1_116)
	arg0_116.initPositions = {}

	local var0_116 = arg1_116 or 1
	local var1_116 = pg.expedition_data_by_map[var0_116].clouds_pos

	for iter0_116, iter1_116 in ipairs(arg0_116.cloudRTFs) do
		local var2_116 = var1_116[iter0_116]

		if var2_116 then
			iter1_116.anchoredPosition = Vector2(var2_116[1], var2_116[2])

			table.insert(arg0_116.initPositions, iter1_116.anchoredPosition)
		else
			setActive(iter1_116, false)
		end
	end
end

function var0_0.initMapBtn(arg0_117, arg1_117, arg2_117)
	onButton(arg0_117, arg1_117, function()
		if arg0_117:isfrozen() then
			return
		end

		local var0_118 = arg0_117.contextData.mapIdx + arg2_117
		local var1_118 = getProxy(ChapterProxy):getMapById(var0_118)

		if not var1_118 then
			return
		end

		if var1_118:getMapType() == Map.ELITE and not var1_118:isEliteEnabled() then
			var1_118 = var1_118:getBindMap()
			var0_118 = var1_118.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_118, var3_118 = var1_118:isUnlock()

		if arg2_117 > 0 and not var2_118 then
			pg.TipsMgr.GetInstance():ShowTips(var3_118)

			return
		end

		arg0_117:setMap(var0_118)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_119, arg1_119, arg2_119)
	seriesAsync({
		function(arg0_120)
			if arg0_119.contextData.entranceStatus then
				arg0_119:frozen()

				arg0_119.nextPreloadMap = arg1_119

				arg0_119:PreloadLevelMainUI(arg1_119, function()
					arg0_119:unfrozen()

					if arg0_119.nextPreloadMap ~= arg1_119 then
						return
					end

					arg0_119:ShowEntranceUI(false)
					arg0_119:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_119)
					arg0_120()
				end)
			else
				arg0_119:setMap(arg1_119)
				arg0_120()
			end
		end
	}, arg2_119)
end

function var0_0.setMap(arg0_122, arg1_122)
	local var0_122 = arg0_122.contextData.mapIdx

	arg0_122.contextData.mapIdx = arg1_122
	arg0_122.contextData.map = getProxy(ChapterProxy):getMapById(arg1_122)

	assert(arg0_122.contextData.map, "map cannot be nil " .. arg1_122)

	if arg0_122.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_122.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_122.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_122.contextData.map.remasterId, arg1_122)
		PlayerPrefs.Save()
	end

	arg0_122:RecordLastMapOnExit()
	arg0_122:updateMap(var0_122)
	arg0_122:tryPlayMapStory()
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
	[var5_0.TYPEATELIERYUMIA] = "MapBuilderAtelierYumia"
}

function var0_0.SwitchMapBuilder(arg0_123, arg1_123)
	if arg0_123.mapBuilder and arg0_123.mapBuilder:GetType() ~= arg1_123 then
		arg0_123.mapBuilder.buffer:Hide()
	end

	local var0_123 = arg0_123:GetMapBuilderInBuffer(arg1_123)

	arg0_123.mapBuilder = var0_123

	var0_123.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_124, arg1_124)
	if not arg0_124.mbDict[arg1_124] then
		local var0_124 = _G[var6_0[arg1_124]]

		assert(var0_124, "Missing MapBuilder of type " .. (arg1_124 or "NIL"))

		arg0_124.mbDict[arg1_124] = var0_124.New(arg0_124._tf, arg0_124)
		arg0_124.mbDict[arg1_124].isFrozen = arg0_124:isfrozen()

		arg0_124.mbDict[arg1_124]:Load()
	end

	return arg0_124.mbDict[arg1_124]
end

function var0_0.updateMap(arg0_125, arg1_125)
	local var0_125 = arg0_125.contextData.map
	local var1_125 = var0_125:getConfig("anchor")
	local var2_125

	if var1_125 == "" then
		var2_125 = Vector2(0.5, 0.5)
	else
		var2_125 = Vector2(unpack(var1_125))
	end

	arg0_125.map.pivot = var2_125

	local var3_125 = var0_125:getConfig("uifx")

	for iter0_125 = 1, arg0_125.UIFXList.childCount do
		local var4_125 = arg0_125.UIFXList:GetChild(iter0_125 - 1)

		setActive(var4_125, var4_125.name == var3_125)
	end

	arg0_125:SwitchMapBG(var0_125, arg1_125)
	arg0_125:PlayBGM()

	local var5_125 = arg0_125.contextData.map:getConfig("ui_type")

	arg0_125:SwitchMapBuilder(var5_125)
	seriesAsync({
		function(arg0_126)
			arg0_125.mapBuilder:CallbackInvoke(arg0_126)
		end,
		function(arg0_127)
			arg0_125.mapBuilder:UpdateMapVO(var0_125)
			arg0_125.mapBuilder:UpdateView()
			arg0_125.mapBuilder:UpdateMapItems()
			arg0_125.mapBuilder:PlayEnterAnim()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_128)
	local var0_128 = arg0_128.contextData.map
	local var1_128 = getProxy(ChapterProxy)
	local var2_128 = var1_128:getMapById(var0_128.id - 1)
	local var3_128 = var1_128:getMapById(var0_128.id + 1)

	setActive(arg0_128.btnPrev, tobool(var2_128))
	setActive(arg0_128.btnNext, tobool(var3_128))

	local var4_128 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_128.btnPrevCol, var2_128 and Color.white or var4_128)
	setImageColor(arg0_128.btnNextCol, var3_128 and var3_128:isUnlock() and Color.white or var4_128)
end

function var0_0.tryPlayMapStory(arg0_129)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_130)
			local var0_130 = arg0_129.contextData.map:getConfig("enter_story")

			if var0_130 and var0_130 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_130) and not arg0_129.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_130 = tonumber(var0_130)

				if var1_130 and var1_130 > 0 then
					arg0_129:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_130)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_130, arg0_130)
				end

				return
			end

			arg0_130()
		end,
		function(arg0_131)
			local var0_131 = arg0_129.contextData.map:getConfig("guide_id")

			if var0_131 and var0_131 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_131, nil, arg0_131)

				return
			end

			arg0_131()
		end,
		function(arg0_132)
			if isActive(arg0_129.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_132 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_132

				if var0_132 then
					var1_132 = {
						1,
						2
					}
				else
					var1_132 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_132)
			else
				arg0_132()
			end
		end,
		function(arg0_133)
			if arg0_129.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_129.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_134, arg1_134, arg2_134, arg3_134)
	arg0_134.uiAnims = arg0_134.uiAnims or {}

	local var0_134 = arg0_134.uiAnims[arg1_134]

	local function var1_134()
		arg0_134.playing = true

		arg0_134:frozen()
		var0_134:SetActive(true)

		local var0_135 = tf(var0_134)

		pg.UIMgr.GetInstance():OverlayPanel(var0_135, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_134 then
			arg3_134(var0_134)
		end

		var0_135:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_136)
			arg0_134.playing = false

			if arg2_134 then
				arg2_134(var0_134)
			end

			arg0_134:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_134 then
		PoolMgr.GetInstance():GetUI(arg1_134, true, function(arg0_137)
			arg0_137:SetActive(true)

			arg0_134.uiAnims[arg1_134] = arg0_137
			var0_134 = arg0_134.uiAnims[arg1_134]

			var1_134()
		end)
	else
		var1_134()
	end
end

function var0_0.displaySpResult(arg0_138, arg1_138, arg2_138)
	setActive(arg0_138.spResult, true)
	arg0_138:DisplaySPAnim(arg1_138 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_139)
		onButton(arg0_138, arg0_139, function()
			removeOnButton(arg0_139)
			setActive(arg0_139, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_139, arg0_138._tf)
			arg0_138:hideSpResult()
			arg2_138()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_141)
	setActive(arg0_141.spResult, false)
end

function var0_0.displayBombResult(arg0_142, arg1_142)
	setActive(arg0_142.spResult, true)
	arg0_142:DisplaySPAnim("SpBombRet", function(arg0_143)
		onButton(arg0_142, arg0_143, function()
			removeOnButton(arg0_143)
			setActive(arg0_143, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_143, arg0_142._tf)
			arg0_142:hideSpResult()
			arg1_142()
		end, SFX_PANEL)
	end, function(arg0_145)
		setText(arg0_145.transform:Find("right/name_bg/en"), arg0_142.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_146, arg1_146, arg2_146)
	arg0_146.contextData.chapterLoopFlag = arg2_146

	local var0_146 = getProxy(ChapterProxy):getChapterById(arg1_146, true)

	if var0_146:getConfig("type") == Chapter.CustomFleet then
		arg0_146:displayFleetEdit(var0_146)

		return
	end

	if #var0_146:getNpcShipByType(1) > 0 then
		arg0_146:emit(LevelMediator2.ON_TRACKING, arg1_146)

		return
	end

	arg0_146:displayFleetSelect(var0_146)
end

function var0_0.DisplayLevelInfoPanel(arg0_147, arg1_147, arg2_147)
	seriesAsync({
		function(arg0_148)
			if not arg0_147.levelInfoView:GetLoaded() then
				arg0_147:frozen()
				arg0_147.levelInfoView:Load()
				arg0_147.levelInfoView:CallbackInvoke(function()
					arg0_147:unfrozen()
					arg0_148()
				end)

				return
			end

			arg0_148()
		end,
		function(arg0_150)
			local function var0_150(arg0_151, arg1_151)
				arg0_147:hideChapterPanel()
				arg0_147:OnLevelInfoPanelConfirm(arg0_151, arg1_151)
			end

			local function var1_150()
				arg0_147:hideChapterPanel()
			end

			local var2_150 = getProxy(ChapterProxy):getChapterById(arg1_147, true)

			if getProxy(ChapterProxy):getMapById(var2_150:getConfig("map")):isSkirmish() and #var2_150:getNpcShipByType(1) > 0 then
				var0_150(false)

				return
			end

			arg0_147.levelInfoView:set(arg1_147, arg2_147)
			arg0_147.levelInfoView:setCBFunc(var0_150, var1_150)
			arg0_147.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_153)
	if arg0_153.levelInfoView:isShowing() then
		arg0_153.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_154)
	arg0_154.levelInfoView:Destroy()

	arg0_154.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_155, arg1_155, arg2_155, arg3_155)
	seriesAsync({
		function(arg0_156)
			if not arg0_155.levelInfoSPView then
				arg0_155.levelInfoSPView = LevelInfoSPView.New(arg0_155.topPanel, arg0_155.event, arg0_155.contextData)

				arg0_155:frozen()
				arg0_155.levelInfoSPView:Load()
				arg0_155.levelInfoSPView:CallbackInvoke(function()
					arg0_155:unfrozen()
					arg0_156()
				end)

				return
			end

			arg0_156()
		end,
		function(arg0_158)
			local function var0_158(arg0_159, arg1_159)
				arg0_155:HideLevelInfoSPPanel()
				arg0_155:OnLevelInfoPanelConfirm(arg0_159, arg1_159)
			end

			local function var1_158()
				arg0_155:HideLevelInfoSPPanel()
			end

			arg0_155.levelInfoSPView:SetChapterGroupInfo(arg2_155)
			arg0_155.levelInfoSPView:set(arg1_155, arg3_155)
			arg0_155.levelInfoSPView:setCBFunc(var0_158, var1_158)
			arg0_155.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_161)
	if arg0_161.levelInfoSPView and arg0_161.levelInfoSPView:isShowing() then
		arg0_161.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_162)
	if not arg0_162.levelInfoSPView then
		return
	end

	arg0_162.levelInfoSPView:Destroy()

	arg0_162.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_163, arg1_163)
	local var0_163 = arg0_163.contextData.selectedFleetIDs or arg1_163:GetDefaultFleetIndex()

	arg1_163 = Clone(arg1_163)
	arg1_163.loopFlag = arg0_163.contextData.chapterLoopFlag

	arg0_163.levelFleetView:updateSpecialOperationTickets(arg0_163.spTickets)
	arg0_163.levelFleetView:Load()
	arg0_163.levelFleetView:ActionInvoke("setHardShipVOs", arg0_163.shipVOs)
	arg0_163.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_163.openedCommanerSystem)
	arg0_163.levelFleetView:ActionInvoke("set", arg1_163, arg0_163.fleets, var0_163)
	arg0_163.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_164)
	if arg0_164.levelCMDFormationView:isShowing() then
		arg0_164.levelCMDFormationView:Hide()
	end

	if arg0_164.levelFleetView then
		arg0_164.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_165)
	arg0_165.levelCMDFormationView = LevelCMDFormationView.New(arg0_165.topPanel, arg0_165.event, arg0_165.contextData)
end

function var0_0.destroyFleetSelect(arg0_166)
	if not arg0_166.levelFleetView then
		return
	end

	arg0_166.levelFleetView:Destroy()

	arg0_166.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_167, arg1_167)
	arg1_167 = Clone(arg1_167)
	arg1_167.loopFlag = arg0_167.contextData.chapterLoopFlag

	arg0_167.levelFleetView:updateSpecialOperationTickets(arg0_167.spTickets)
	arg0_167.levelFleetView:Load()
	arg0_167.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_167.openedCommanerSystem)
	arg0_167.levelFleetView:ActionInvoke("setHardShipVOs", arg0_167.shipVOs)
	arg0_167.levelFleetView:ActionInvoke("setOnHard", arg1_167)
	arg0_167.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_168)
	arg0_168:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_169)
	arg0_169:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_170, arg1_170)
	if not arg0_170.levelFleetView then
		return
	end

	assert(arg0_170.levelFleetView:GetLoaded())

	local var0_170 = arg0_170.levelFleetView:IsSelectMode()
	local var1_170

	if var0_170 then
		arg0_170.levelFleetView:ActionInvoke("set", arg1_170 or arg0_170.levelFleetView.chapter, arg0_170.fleets, arg0_170.levelFleetView:getSelectIds())

		if arg0_170.levelCMDFormationView:isShowing() then
			local var2_170 = arg0_170.levelCMDFormationView.fleet.id

			var1_170 = arg0_170.fleets[var2_170]
		end
	else
		arg0_170.levelFleetView:ActionInvoke("setOnHard", arg1_170 or arg0_170.levelFleetView.chapter)

		if arg0_170.levelCMDFormationView:isShowing() then
			local var3_170 = arg0_170.levelCMDFormationView.fleet.id

			var1_170 = arg1_170:wrapEliteFleet(var3_170)
		end
	end

	if var1_170 then
		arg0_170.levelCMDFormationView:ActionInvoke("updateFleet", var1_170)
	end
end

function var0_0.setChapter(arg0_171, arg1_171)
	local var0_171

	if arg1_171 then
		var0_171 = arg1_171.id
	end

	arg0_171.contextData.chapterId = var0_171
	arg0_171.contextData.chapterVO = arg1_171
end

function var0_0.switchToChapter(arg0_172, arg1_172)
	if arg0_172.contextData.mapIdx ~= arg1_172:getConfig("map") then
		arg0_172:setMap(arg1_172:getConfig("map"))
	end

	arg0_172:setChapter(arg1_172)

	arg0_172.leftCanvasGroup.blocksRaycasts = false
	arg0_172.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_172.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_172:DestroyLevelStageView()

	if not arg0_172.levelStageView then
		arg0_172.levelStageView = LevelStageView.New(arg0_172.topPanel, arg0_172.event, arg0_172.contextData)

		arg0_172.levelStageView:Load()

		arg0_172.levelStageView.isFrozen = arg0_172:isfrozen()
	end

	arg0_172:frozen()

	local function var0_172()
		seriesAsync({
			function(arg0_174)
				arg0_172.mapBuilder:CallbackInvoke(arg0_174)
			end,
			function(arg0_175)
				setActive(arg0_172.clouds, false)
				arg0_172.mapBuilder:HideFloat()
				pg.UIMgr.GetInstance():BlurPanel(arg0_172.topPanel, false, {
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
				arg0_172.levelStageView:updateStageInfo()
				arg0_172.levelStageView:updateAmbushRate(arg1_172.fleet.line, true)
				arg0_172.levelStageView:updateStageAchieve()
				arg0_172.levelStageView:updateStageBarrier()
				arg0_172.levelStageView:updateBombPanel()
				arg0_172.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_175)
			end,
			function(arg0_176)
				if arg0_172.exited then
					return
				end

				arg0_172.levelStageView:updateStageStrategy()

				arg0_172.canvasGroup.blocksRaycasts = arg0_172.frozenCount == 0

				onNextTick(arg0_176)
			end,
			function(arg0_177)
				if arg0_172.exited then
					return
				end

				arg0_172.levelStageView:updateStageFleet()
				arg0_172.levelStageView:updateSupportFleet()
				arg0_172.levelStageView:updateFleetBuff()
				onNextTick(arg0_177)
			end,
			function(arg0_178)
				if arg0_172.exited then
					return
				end

				parallelAsync({
					function(arg0_179)
						local var0_179 = arg1_172:getConfig("scale")
						local var1_179 = LeanTween.value(go(arg0_172.map), arg0_172.map.localScale, Vector3.New(var0_179[3], var0_179[3], 1), var1_0):setOnUpdateVector3(function(arg0_180)
							arg0_172.map.localScale = arg0_180
							arg0_172.float.localScale = arg0_180
						end):setOnComplete(System.Action(function()
							arg0_172.mapBuilder:ShowFloat()
							arg0_172.mapBuilder:Hide()
							arg0_179()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_172:RecordTween("mapScale", var1_179.uniqueId)

						local var2_179 = LeanTween.value(go(arg0_172.map), arg0_172.map.pivot, Vector2.New(math.clamp(var0_179[1] - 0.5, 0, 1), math.clamp(var0_179[2] - 0.5, 0, 1)), var1_0)

						var2_179:setOnUpdateVector2(function(arg0_182)
							arg0_172.map.pivot = arg0_182
							arg0_172.float.pivot = arg0_182
						end):setEase(LeanTweenType.easeOutSine)
						arg0_172:RecordTween("mapPivot", var2_179.uniqueId)
						shiftPanel(arg0_172.leftChapter, -arg0_172.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_172.rightChapter, arg0_172.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_172.topChapter, 0, arg0_172.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_172.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_183)
						arg0_172:PlayBGM()

						local var0_183 = {}
						local var1_183 = arg1_172:getConfig("bg")

						if var1_183 and #var1_183 > 0 then
							var0_183[1] = {
								BG = var1_183
							}
						end

						arg0_172:SwitchBG(var0_183, arg0_183)
					end
				}, function()
					onNextTick(arg0_178)
				end)
			end,
			function(arg0_185)
				if arg0_172.exited then
					return
				end

				setActive(arg0_172.topChapter, false)
				setActive(arg0_172.leftChapter, false)
				setActive(arg0_172.rightChapter, false)

				arg0_172.leftCanvasGroup.blocksRaycasts = true
				arg0_172.rightCanvasGroup.blocksRaycasts = true

				arg0_172:initGrid(arg0_185)
			end,
			function(arg0_186)
				if arg0_172.exited then
					return
				end

				arg0_172.levelStageView:SetGrid(arg0_172.grid)

				arg0_172.contextData.huntingRangeVisibility = arg0_172.contextData.huntingRangeVisibility - 1

				arg0_172.grid:toggleHuntingRange()

				local var0_186 = arg1_172:getConfig("pop_pic")

				if var0_186 and #var0_186 > 0 and arg0_172.FirstEnterChapter == arg1_172.id then
					arg0_172:doPlayAnim(var0_186, function(arg0_187)
						setActive(arg0_187, false)

						if arg0_172.exited then
							return
						end

						arg0_186()
					end)
				else
					arg0_186()
				end
			end,
			function(arg0_188)
				arg0_172.levelStageView:tryAutoAction(arg0_188)
			end,
			function(arg0_189)
				if arg0_172.exited then
					return
				end

				arg0_172:unfrozen()

				if arg0_172.FirstEnterChapter then
					arg0_172:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_172.subAutoAttack)
				end

				arg0_172.FirstEnterChapter = nil

				arg0_172.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0_172.levelStageView:ActionInvoke("SetSeriesOperation", var0_172)
	arg0_172.levelStageView:ActionInvoke("SetPlayer", arg0_172.player)
	arg0_172.levelStageView:ActionInvoke("SwitchToChapter", arg1_172)
end

function var0_0.switchToMap(arg0_190, arg1_190)
	arg0_190:frozen()
	arg0_190:destroyGrid()
	arg0_190:setChapter(nil)
	LeanTween.cancel(go(arg0_190.map))

	local var0_190 = LeanTween.value(go(arg0_190.map), arg0_190.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_191)
		arg0_190.map.localScale = arg0_191
		arg0_190.float.localScale = arg0_191
	end):setOnComplete(System.Action(function()
		arg0_190:unfrozen()
		arg0_190.mapBuilder:PlayEnterAnim()
		existCall(arg1_190)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_190:RecordTween("mapScale", var0_190.uniqueId)

	local var1_190 = arg0_190.contextData.map:getConfig("anchor")
	local var2_190

	if var1_190 == "" then
		var2_190 = Vector2.zero
	else
		var2_190 = Vector2(unpack(var1_190))
	end

	local var3_190 = LeanTween.value(go(arg0_190.map), arg0_190.map.pivot, var2_190, var1_0)

	var3_190:setOnUpdateVector2(function(arg0_193)
		arg0_190.map.pivot = arg0_193
		arg0_190.float.pivot = arg0_193
	end):setEase(LeanTweenType.easeOutSine)
	arg0_190:RecordTween("mapPivot", var3_190.uniqueId)
	setActive(arg0_190.topChapter, true)
	setActive(arg0_190.leftChapter, true)
	setActive(arg0_190.rightChapter, true)
	shiftPanel(arg0_190.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_190.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_190.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_190.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_190.levelStageView then
		arg0_190.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_190:DestroyLevelStageView()
		end)
		arg0_190.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_190:SwitchMapBG(arg0_190.contextData.map)
	arg0_190:PlayBGM()
	seriesAsync({
		function(arg0_195)
			arg0_190.mapBuilder:CallbackInvoke(arg0_195)
		end,
		function(arg0_196)
			arg0_190.mapBuilder:Show()
			arg0_190.mapBuilder:UpdateView()
			arg0_190.mapBuilder:UpdateMapItems()
		end
	})
	pg.UIMgr.GetInstance():UnblurPanel(arg0_190.topPanel, arg0_190._tf)
	pg.playerResUI:SetActive({
		active = false
	})

	arg0_190.canvasGroup.blocksRaycasts = arg0_190.frozenCount == 0
	arg0_190.canvasGroup.interactable = true

	if arg0_190.ambushWarning and arg0_190.ambushWarning.activeSelf then
		arg0_190.ambushWarning:SetActive(false)
		arg0_190:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_197, arg1_197, arg2_197, arg3_197)
	if not arg1_197 or #arg1_197 <= 0 then
		existCall(arg2_197)

		return
	elseif arg3_197 then
		-- block empty
	elseif table.equal(arg0_197.currentBG, arg1_197) then
		return
	end

	arg0_197.currentBG = arg1_197

	for iter0_197, iter1_197 in ipairs(arg0_197.mapGroup) do
		arg0_197.loader:ClearRequest(iter1_197)
	end

	table.clear(arg0_197.mapGroup)

	local var0_197 = {}

	table.ParallelIpairsAsync(arg1_197, function(arg0_198, arg1_198, arg2_198)
		local var0_198 = arg0_197.mapTFs[arg0_198]
		local var1_198 = arg1_198.bgPrefix and arg1_198.bgPrefix .. "/" or "levelmap/"
		local var2_198 = arg0_197.loader:GetSpriteDirect(var1_198 .. arg1_198.BG, "", function(arg0_199)
			var0_197[arg0_198] = arg0_199

			arg2_198()
		end, var0_198)

		table.insert(arg0_197.mapGroup, var2_198)
		arg0_197:updateCouldAnimator(arg1_198.Animator, arg0_198)
	end, function()
		for iter0_200, iter1_200 in ipairs(arg0_197.mapTFs) do
			setImageSprite(iter1_200, var0_197[iter0_200])
			setActive(iter1_200, arg1_197[iter0_200])
			SetCompomentEnabled(iter1_200, typeof(Image), true)
		end

		existCall(arg2_197)
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

function var0_0.ClearMapTransitions(arg0_201)
	if not arg0_201.mapTransitions then
		return
	end

	for iter0_201, iter1_201 in pairs(arg0_201.mapTransitions) do
		if iter1_201 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_201, iter0_201, iter1_201, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_201, iter0_201)
		end
	end

	arg0_201.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_202, arg1_202, arg2_202, arg3_202)
	local var0_202, var1_202, var2_202 = arg0_202:GetMapBG(arg1_202, arg2_202)

	if not var1_202 then
		arg0_202:SwitchBG(var0_202, nil, arg3_202)

		return
	end

	arg0_202:PlayMapTransition("LevelMapTransition_" .. var1_202, var2_202, function()
		arg0_202:SwitchBG(var0_202, nil, arg3_202)
	end)
end

function var0_0.GetMapBG(arg0_204, arg1_204, arg2_204)
	if not table.contains(var7_0, arg1_204.id) then
		return {
			arg0_204:GetMapElement(arg1_204)
		}
	end

	local var0_204 = arg1_204.id
	local var1_204 = table.indexof(var7_0, var0_204) - 1
	local var2_204 = bit.lshift(bit.rshift(var1_204, 1), 1) + 1
	local var3_204 = {
		var7_0[var2_204],
		var7_0[var2_204 + 1]
	}
	local var4_204 = _.map(var3_204, function(arg0_205)
		return getProxy(ChapterProxy):getMapById(arg0_205)
	end)

	if _.all(var4_204, function(arg0_206)
		return arg0_206:isAllChaptersClear()
	end) then
		local var5_204 = {
			arg0_204:GetMapElement(arg1_204)
		}

		if not arg2_204 or math.abs(var0_204 - arg2_204) ~= 1 then
			return var5_204
		end

		local var6_204 = var9_0[bit.rshift(var2_204 - 1, 1) + 1]
		local var7_204 = bit.band(var1_204, 1) == 1

		return var5_204, var6_204, var7_204
	else
		local var8_204 = 0

		;(function()
			local var0_207 = var4_204[1]:getChapters()

			for iter0_207, iter1_207 in ipairs(var0_207) do
				if not iter1_207:isClear() then
					return
				end

				var8_204 = var8_204 + 1
			end

			if not var4_204[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_204 = var8_204 + 1

			local var1_207 = var4_204[2]:getChapters()

			for iter2_207, iter3_207 in ipairs(var1_207) do
				if not iter3_207:isClear() then
					return
				end

				var8_204 = var8_204 + 1
			end
		end)()

		local var9_204

		if var8_204 > 0 then
			local var10_204 = var8_0[bit.rshift(var2_204 - 1, 1) + 1]

			var9_204 = {
				{
					BG = "map_" .. var10_204[1],
					Animator = var10_204[2]
				},
				{
					BG = "map_" .. var10_204[3] + var8_204,
					Animator = var10_204[4]
				}
			}
		else
			var9_204 = {
				arg0_204:GetMapElement(arg1_204)
			}
		end

		return var9_204
	end
end

function var0_0.GetMapElement(arg0_208, arg1_208)
	local var0_208 = arg1_208:getConfig("bg")
	local var1_208 = arg1_208:getConfig("ani_controller")

	if var1_208 and #var1_208 > 0 then
		(function()
			for iter0_209, iter1_209 in ipairs(var1_208) do
				local var0_209 = _.rest(iter1_209[2], 2)

				for iter2_209, iter3_209 in ipairs(var0_209) do
					if string.find(iter3_209, "^map_") and iter1_209[1] == var3_0 then
						local var1_209 = iter1_209[2][1]
						local var2_209 = getProxy(ChapterProxy):GetChapterItemById(var1_209)

						if var2_209 and not var2_209:isClear() then
							var0_208 = iter3_209

							return
						end
					end
				end
			end
		end)()
	end

	local var2_208 = {
		BG = var0_208
	}

	var2_208.Animator, var2_208.AnimatorController = arg0_208:GetMapAnimator(arg1_208)

	return var2_208
end

function var0_0.GetMapAnimator(arg0_210, arg1_210)
	local var0_210 = arg1_210:getConfig("ani_name")

	if arg1_210:getConfig("animtor") == 1 and var0_210 and #var0_210 > 0 then
		local var1_210 = arg1_210:getConfig("ani_controller")

		if var1_210 and #var1_210 > 0 then
			(function()
				for iter0_211, iter1_211 in ipairs(var1_210) do
					local var0_211 = _.rest(iter1_211[2], 2)

					for iter2_211, iter3_211 in ipairs(var0_211) do
						if string.find(iter3_211, "^effect_") and iter1_211[1] == var3_0 then
							local var1_211 = iter1_211[2][1]
							local var2_211 = getProxy(ChapterProxy):GetChapterItemById(var1_211)

							if var2_211 and not var2_211:isClear() then
								var0_210 = "map_" .. string.sub(iter3_211, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_210, var1_210
	end
end

function var0_0.PlayMapTransition(arg0_212, arg1_212, arg2_212, arg3_212, arg4_212)
	arg0_212.mapTransitions = arg0_212.mapTransitions or {}

	local var0_212

	local function var1_212()
		arg0_212:frozen()
		existCall(arg3_212, var0_212)
		var0_212:SetActive(true)

		local var0_213 = tf(var0_212)

		pg.UIMgr.GetInstance():OverlayPanel(var0_213, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		var0_212:GetComponent(typeof(Animator)):Play(arg2_212 and "Sequence" or "Inverted", -1, 0)
		var0_213:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_214)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_213, arg0_212._tf)
			existCall(arg4_212, var0_212)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_212, arg1_212, var0_212)

			arg0_212.mapTransitions[arg1_212] = false

			arg0_212:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_212, arg1_212, true, function(arg0_215)
		var0_212 = arg0_215
		arg0_212.mapTransitions[arg1_212] = arg0_215

		var1_212()
	end)
end

function var0_0.DestroyLevelStageView(arg0_216)
	if arg0_216.levelStageView then
		arg0_216.levelStageView:Destroy()

		arg0_216.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_217, arg1_217)
	arg0_217.levelAmbushView = LevelAmbushView.New(arg0_217.topPanel, arg0_217.event, arg0_217.contextData)

	arg0_217.levelAmbushView:Load()
	arg0_217.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_217)
end

function var0_0.hideAmbushInfo(arg0_218)
	if arg0_218.levelAmbushView then
		arg0_218.levelAmbushView:Destroy()

		arg0_218.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_219, arg1_219)
	arg0_219:frozen()

	local function var0_219()
		arg0_219.ambushWarning:SetActive(true)

		local var0_220 = tf(arg0_219.ambushWarning)

		var0_220:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_220:SetSiblingIndex(1)

		local var1_220 = var0_220:GetComponent("DftAniEvent")

		var1_220:SetTriggerEvent(function(arg0_221)
			arg1_219()
		end)
		var1_220:SetEndEvent(function(arg0_222)
			arg0_219.ambushWarning:SetActive(false)
			arg0_219:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_219.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_224)
			arg0_224:SetActive(true)

			arg0_219.ambushWarning = arg0_224

			var0_219()
		end)
	else
		var0_219()
	end
end

function var0_0.destroyAmbushWarn(arg0_225)
	if arg0_225.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_225.ambushWarning)

		arg0_225.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_226, arg1_226)
	arg0_226.levelStrategyView = LevelStrategyView.New(arg0_226.topPanel, arg0_226.event, arg0_226.contextData)

	arg0_226.levelStrategyView:Load()
	arg0_226.levelStrategyView:ActionInvoke("set", arg1_226)

	local function var0_226()
		local var0_227 = arg0_226.contextData.chapterVO.fleet
		local var1_227 = pg.strategy_data_template[arg1_226.id]

		if not var0_227:canUseStrategy(arg1_226) then
			return
		end

		local var2_227 = var0_227:getNextStgUser(arg1_226.id)

		if var1_227.type == ChapterConst.StgTypeForm then
			arg0_226:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_227,
				arg1 = arg1_226.id
			})
		elseif var1_227.type == ChapterConst.StgTypeConsume then
			arg0_226:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_227,
				arg1 = arg1_226.id
			})
		end

		arg0_226:hideStrategyInfo()
	end

	local function var1_226()
		arg0_226:hideStrategyInfo()
	end

	arg0_226.levelStrategyView:ActionInvoke("setCBFunc", var0_226, var1_226)
end

function var0_0.hideStrategyInfo(arg0_229)
	if arg0_229.levelStrategyView then
		arg0_229.levelStrategyView:Destroy()

		arg0_229.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_230, arg1_230)
	local var0_230 = arg0_230.contextData.chapterVO
	local var1_230 = getProxy(ChapterProxy)
	local var2_230
	local var3_230
	local var4_230
	local var5_230
	local var6_230 = var1_230.repairTimes
	local var7_230, var8_230, var9_230 = ChapterConst.GetRepairParams()

	arg0_230.levelRepairView = LevelRepairView.New(arg0_230.topPanel, arg0_230.event, arg0_230.contextData)

	arg0_230.levelRepairView:Load()
	arg0_230.levelRepairView:ActionInvoke("set", var6_230, var7_230, var8_230, var9_230)

	local function var10_230()
		if var7_230 - math.min(var6_230, var7_230) == 0 and arg0_230.player:getTotalGem() < var9_230 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_230:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_230.fleet.id,
			arg1 = arg1_230.id
		})
		arg0_230:hideRepairWindow()
	end

	local function var11_230()
		arg0_230:hideRepairWindow()
	end

	arg0_230.levelRepairView:ActionInvoke("setCBFunc", var10_230, var11_230)
end

function var0_0.hideRepairWindow(arg0_233)
	if arg0_233.levelRepairView then
		arg0_233.levelRepairView:Destroy()

		arg0_233.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_234, arg1_234)
	arg0_234.levelRemasterView:Load()

	local function var0_234(arg0_235)
		arg0_234:ShowSelectedMap(arg0_235)
	end

	arg0_234.levelRemasterView:ActionInvoke("Show")
	arg0_234.levelRemasterView:ActionInvoke("set", var0_234, arg1_234)
end

function var0_0.hideRemasterPanel(arg0_236)
	if arg0_236.levelRemasterView:isShowing() then
		arg0_236.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_237, arg1_237)
	local var0_237 = arg0_237.contextData.chapterVO

	if not var0_237 then
		return
	end

	arg0_237:enableLevelCamera()
	setActive(arg0_237.uiMain, true)

	arg0_237.levelGrid.localEulerAngles = Vector3(var0_237.theme.angle, 0, 0)
	arg0_237.grid = LevelGrid.New(arg0_237.dragLayer)

	arg0_237.grid:attach(arg0_237)
	arg0_237.grid:ExtendItem("shipTpl", arg0_237.shipTpl)
	arg0_237.grid:ExtendItem("subTpl", arg0_237.subTpl)
	arg0_237.grid:ExtendItem("transportTpl", arg0_237.transportTpl)
	arg0_237.grid:ExtendItem("enemyTpl", arg0_237.enemyTpl)
	arg0_237.grid:ExtendItem("championTpl", arg0_237.championTpl)
	arg0_237.grid:ExtendItem("oniTpl", arg0_237.oniTpl)
	arg0_237.grid:ExtendItem("arrowTpl", arg0_237.arrowTarget)
	arg0_237.grid:ExtendItem("destinationMarkTpl", arg0_237.destinationMarkTpl)

	function arg0_237.grid.onShipStepChange(arg0_238)
		arg0_237.levelStageView:updateAmbushRate(arg0_238)
	end

	arg0_237.grid:initAll(arg1_237)
end

function var0_0.destroyGrid(arg0_239)
	if arg0_239.grid then
		arg0_239.grid:detach()

		arg0_239.grid = nil

		arg0_239:disableLevelCamera()
		setActive(arg0_239.dragLayer, true)
		setActive(arg0_239.uiMain, false)
	end
end

function var0_0.doTracking(arg0_240, arg1_240)
	arg0_240:frozen()

	local function var0_240()
		arg0_240.radar:SetActive(true)

		local var0_241 = tf(arg0_240.radar)

		var0_241:SetParent(arg0_240.topPanel, false)
		var0_241:SetSiblingIndex(1)
		var0_241:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_242)
			arg0_240.radar:SetActive(false)
			arg0_240:unfrozen()
			arg1_240()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_240.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_243)
			arg0_243:SetActive(true)

			arg0_240.radar = arg0_243

			var0_240()
		end)
	else
		var0_240()
	end
end

function var0_0.destroyTracking(arg0_244)
	if arg0_244.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_244.radar)

		arg0_244.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_245, arg1_245, arg2_245, arg3_245)
	local function var0_245()
		arg0_245.playing = true

		arg0_245:frozen()
		arg0_245.airStrike:SetActive(true)

		local var0_246 = tf(arg0_245.airStrike)

		var0_246:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_246:SetAsLastSibling()
		setActive(var0_246:Find("words/be_striked"), arg1_245 == ChapterConst.SubjectChampion)
		setActive(var0_246:Find("words/strike_enemy"), arg1_245 == ChapterConst.SubjectPlayer)

		local function var1_246()
			arg0_245.playing = false

			SetActive(arg0_245.airStrike, false)

			if arg3_245 then
				arg3_245()
			end

			arg0_245:unfrozen()
		end

		var0_246:GetComponent("DftAniEvent"):SetEndEvent(var1_246)

		if arg2_245 then
			onButton(arg0_245, var0_246, var1_246, SFX_PANEL)
		else
			removeOnButton(var0_246)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_245.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_248)
			arg0_248:SetActive(true)

			arg0_245.airStrike = arg0_248

			var0_245()
		end)
	else
		var0_245()
	end
end

function var0_0.destroyAirStrike(arg0_249)
	if arg0_249.airStrike then
		arg0_249.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_249.airStrike)

		arg0_249.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_250, arg1_250, arg2_250, arg3_250)
	arg0_250.uiAnims = arg0_250.uiAnims or {}

	local var0_250 = arg0_250.uiAnims[arg1_250]

	local function var1_250()
		arg0_250.playing = true

		arg0_250:frozen()
		var0_250:SetActive(true)

		local var0_251 = tf(var0_250)

		pg.UIMgr.GetInstance():OverlayPanel(var0_251, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3_250 then
			arg3_250(var0_250)
		end

		var0_251:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_252)
			arg0_250.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_251, arg0_250._tf)

			if arg2_250 then
				arg2_250(var0_250)
			end

			arg0_250:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_250 then
		PoolMgr.GetInstance():GetUI(arg1_250, true, function(arg0_253)
			arg0_253:SetActive(true)

			arg0_250.uiAnims[arg1_250] = arg0_253
			var0_250 = arg0_250.uiAnims[arg1_250]

			var1_250()
		end)
	else
		var1_250()
	end
end

function var0_0.destroyUIAnims(arg0_254)
	if arg0_254.uiAnims then
		for iter0_254, iter1_254 in pairs(arg0_254.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_254), arg0_254._tf)
			iter1_254:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_254, iter1_254)
		end

		arg0_254.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_255, arg1_255)
	local function var0_255()
		arg0_255.playing = true

		arg0_255:frozen()
		arg0_255.torpetoAni:SetActive(true)

		local var0_256 = tf(arg0_255.torpetoAni)

		var0_256:SetParent(arg0_255.topPanel, false)
		var0_256:SetAsLastSibling()
		var0_256:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_257)
			arg0_255.playing = false

			SetActive(arg0_255.torpetoAni, false)

			if arg1_255 then
				arg1_255()
			end

			arg0_255:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_255.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_258)
			arg0_258:SetActive(true)

			arg0_255.torpetoAni = arg0_258

			var0_255()
		end)
	else
		var0_255()
	end
end

function var0_0.destroyTorpedo(arg0_259)
	if arg0_259.torpetoAni then
		arg0_259.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_259.torpetoAni)

		arg0_259.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_260, arg1_260, arg2_260, arg3_260)
	arg0_260.strikeAnims = arg0_260.strikeAnims or {}

	local var0_260
	local var1_260
	local var2_260

	local function var3_260()
		if coroutine.status(var2_260) == "suspended" then
			local var0_261, var1_261 = coroutine.resume(var2_260)

			assert(var0_261, debug.traceback(var2_260, var1_261))
		end
	end

	var2_260 = coroutine.create(function()
		arg0_260.playing = true

		arg0_260:frozen()

		local var0_262 = arg0_260.strikeAnims[arg2_260]

		setActive(var0_262, true)

		local var1_262 = tf(var0_262)
		local var2_262 = findTF(var1_262, "torpedo")
		local var3_262 = findTF(var1_262, "mask/painting")
		local var4_262 = findTF(var1_262, "ship")

		setParent(var0_260, var3_262:Find("fitter"), false)
		setParent(var1_260, var4_262, false)
		setActive(var4_262, false)
		setActive(var2_262, false)
		var1_262:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_262:SetAsLastSibling()

		local var5_262 = var1_262:GetComponent("DftAniEvent")
		local var6_262 = var1_260:GetComponent("SpineAnimUI")
		local var7_262 = var6_262:GetComponent("SkeletonGraphic")

		var5_262:SetStartEvent(function(arg0_263)
			var6_262:SetAction("attack", 0)

			var7_262.freeze = true
		end)
		var5_262:SetTriggerEvent(function(arg0_264)
			var7_262.freeze = false

			var6_262:SetActionCallBack(function(arg0_265)
				if arg0_265 == "action" then
					-- block empty
				elseif arg0_265 == "finish" then
					var7_262.freeze = true
				end
			end)
		end)
		var5_262:SetEndEvent(function(arg0_266)
			var7_262.freeze = false

			var3_260()
		end)
		onButton(arg0_260, var1_262, var3_260, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_262, arg1_260:getPainting())
		var6_262:SetActionCallBack(nil)

		var7_262.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_260:getPrefab(), var1_260)
		setActive(var0_262, false)

		arg0_260.playing = false

		arg0_260:unfrozen()

		if arg3_260 then
			arg3_260()
		end
	end)

	local function var4_260()
		if arg0_260.strikeAnims[arg2_260] and var0_260 and var1_260 then
			var3_260()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_260:getPainting(), true, function(arg0_268)
		var0_260 = arg0_268

		ShipExpressionHelper.SetExpression(var0_260, arg1_260:getPainting())
		var4_260()
	end)
	PoolMgr.GetInstance():GetSpineChar(arg1_260:getPrefab(), true, function(arg0_269)
		var1_260 = arg0_269
		var1_260.transform.localScale = Vector3.one

		var4_260()
	end)

	if not arg0_260.strikeAnims[arg2_260] then
		PoolMgr.GetInstance():GetUI(arg2_260, true, function(arg0_270)
			arg0_260.strikeAnims[arg2_260] = arg0_270

			var4_260()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_271)
	if arg0_271.strikeAnims then
		for iter0_271, iter1_271 in pairs(arg0_271.strikeAnims) do
			iter1_271:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_271, iter1_271)
		end

		arg0_271.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_272, arg1_272, arg2_272, arg3_272)
	arg0_272.strikeAnims = arg0_272.strikeAnims or {}

	local var0_272
	local var1_272

	local function var2_272()
		if coroutine.status(var1_272) == "suspended" then
			local var0_273, var1_273 = coroutine.resume(var1_272)

			assert(var0_273, debug.traceback(var1_272, var1_273))
		end
	end

	var1_272 = coroutine.create(function()
		arg0_272.playing = true

		arg0_272:frozen()

		local var0_274 = arg0_272.strikeAnims[arg2_272]

		setActive(var0_274, true)

		local var1_274 = tf(var0_274)
		local var2_274 = findTF(var1_274, "torpedo")
		local var3_274 = findTF(var1_274, "ship")

		setParent(var0_272, var3_274, false)
		setActive(var3_274, false)
		setActive(var2_274, false)
		var1_274:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_274:SetAsLastSibling()

		local var4_274 = var1_274:GetComponent("DftAniEvent")
		local var5_274 = var0_272:GetComponent("SpineAnimUI")
		local var6_274 = var5_274:GetComponent("SkeletonGraphic")

		var4_274:SetStartEvent(function(arg0_275)
			var5_274:SetAction("attack", 0)

			var6_274.freeze = true
		end)
		var4_274:SetTriggerEvent(function(arg0_276)
			var6_274.freeze = false

			var5_274:SetActionCallBack(function(arg0_277)
				if arg0_277 == "action" then
					-- block empty
				elseif arg0_277 == "finish" then
					var6_274.freeze = true
				end
			end)
		end)
		var4_274:SetEndEvent(function(arg0_278)
			var6_274.freeze = false

			var2_272()
		end)
		onButton(arg0_272, var1_274, var2_272, SFX_CANCEL)
		coroutine.yield()
		var5_274:SetActionCallBack(nil)

		var6_274.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1_272:getPrefab(), var0_272)
		setActive(var0_274, false)

		arg0_272.playing = false

		arg0_272:unfrozen()

		if arg3_272 then
			arg3_272()
		end
	end)

	local function var3_272()
		if arg0_272.strikeAnims[arg2_272] and var0_272 then
			var2_272()
		end
	end

	PoolMgr.GetInstance():GetSpineChar(arg1_272:getPrefab(), true, function(arg0_280)
		var0_272 = arg0_280
		var0_272.transform.localScale = Vector3.one

		var3_272()
	end)

	if not arg0_272.strikeAnims[arg2_272] then
		PoolMgr.GetInstance():GetUI(arg2_272, true, function(arg0_281)
			arg0_272.strikeAnims[arg2_272] = arg0_281

			var3_272()
		end)
	end
end

function var0_0.doPlayCommander(arg0_282, arg1_282, arg2_282)
	arg0_282:frozen()
	setActive(arg0_282.commanderTinkle, true)

	local var0_282 = arg1_282:getSkills()

	setText(arg0_282.commanderTinkle:Find("name"), #var0_282 > 0 and var0_282[1]:getConfig("name") or "")
	setImageSprite(arg0_282.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_282:getConfig("painting"), ""))

	local var1_282 = arg0_282.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_282.alpha = 0

	local var2_282 = Vector2(248, 237)

	LeanTween.value(go(arg0_282.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_283)
		local var0_283 = arg0_282.commanderTinkle.localPosition

		var0_283.x = var2_282.x + -100 * (1 - arg0_283)
		arg0_282.commanderTinkle.localPosition = var0_283
		var1_282.alpha = arg0_283
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_282.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_284)
		local var0_284 = arg0_282.commanderTinkle.localPosition

		var0_284.x = var2_282.x + 100 * arg0_284
		arg0_282.commanderTinkle.localPosition = var0_284
		var1_282.alpha = 1 - arg0_284
	end)):setOnComplete(System.Action(function()
		if arg2_282 then
			arg2_282()
		end

		arg0_282:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_286, arg1_286, arg2_286, arg3_286)
	local var0_286 = arg0_286.grid:shakeCell(arg1_286)

	if not var0_286 then
		arg3_286()

		return
	end

	arg0_286:easeDamage(var0_286, arg2_286, function()
		arg3_286()
	end)
end

function var0_0.easeDamage(arg0_288, arg1_288, arg2_288, arg3_288)
	arg0_288:frozen()

	local var0_288 = arg0_288.levelCam:WorldToScreenPoint(arg1_288.position)
	local var1_288 = tf(arg0_288:GetDamageText())

	var1_288.position = arg0_288.uiCam:ScreenToWorldPoint(var0_288)

	local var2_288 = var1_288.localPosition

	var2_288.y = var2_288.y + 40
	var2_288.z = 0

	setText(var1_288, arg2_288)

	var1_288.localPosition = var2_288

	LeanTween.value(go(var1_288), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_289)
		local var0_289 = var1_288.localPosition

		var0_289.y = var2_288.y + 60 * arg0_289
		var1_288.localPosition = var0_289

		setTextAlpha(var1_288, 1 - arg0_289)
	end)):setOnComplete(System.Action(function()
		arg0_288:ReturnDamageText(var1_288)
		arg0_288:unfrozen()

		if arg3_288 then
			arg3_288()
		end
	end))
end

function var0_0.easeAvoid(arg0_291, arg1_291, arg2_291)
	arg0_291:frozen()

	local var0_291 = arg0_291.levelCam:WorldToScreenPoint(arg1_291)

	arg0_291.avoidText.position = arg0_291.uiCam:ScreenToWorldPoint(var0_291)

	local var1_291 = arg0_291.avoidText.localPosition

	var1_291.z = 0
	arg0_291.avoidText.localPosition = var1_291

	setActive(arg0_291.avoidText, true)

	local var2_291 = arg0_291.avoidText:Find("avoid")

	LeanTween.value(go(arg0_291.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_292)
		local var0_292 = arg0_291.avoidText.localPosition

		var0_292.y = var1_291.y + 100 * arg0_292
		arg0_291.avoidText.localPosition = var0_292

		setImageAlpha(arg0_291.avoidText, 1 - arg0_292)
		setImageAlpha(var2_291, 1 - arg0_292)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_291.avoidText, false)
		arg0_291:unfrozen()

		if arg2_291 then
			arg2_291()
		end
	end))
end

function var0_0.GetDamageText(arg0_294)
	local var0_294 = table.remove(arg0_294.damageTextPool)

	if not var0_294 then
		var0_294 = Instantiate(arg0_294.damageTextTemplate)

		local var1_294 = tf(arg0_294.damageTextTemplate):GetSiblingIndex()

		setParent(var0_294, tf(arg0_294.damageTextTemplate).parent)
		tf(var0_294):SetSiblingIndex(var1_294 + 1)
	end

	table.insert(arg0_294.damageTextActive, var0_294)
	setActive(var0_294, true)

	return var0_294
end

function var0_0.ReturnDamageText(arg0_295, arg1_295)
	assert(arg1_295)

	if not arg1_295 then
		return
	end

	arg1_295 = go(arg1_295)

	table.removebyvalue(arg0_295.damageTextActive, arg1_295)
	table.insert(arg0_295.damageTextPool, arg1_295)
	setActive(arg1_295, false)
end

function var0_0.resetLevelGrid(arg0_296)
	arg0_296.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_297, arg1_297)
	setActive(arg0_297.curtain, arg1_297)
end

function var0_0.frozen(arg0_298)
	local var0_298 = arg0_298.frozenCount

	arg0_298.frozenCount = arg0_298.frozenCount + 1
	arg0_298.canvasGroup.blocksRaycasts = arg0_298.frozenCount == 0

	if var0_298 == 0 and arg0_298.frozenCount ~= 0 then
		arg0_298:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_299, arg1_299)
	if arg0_299.exited then
		return
	end

	local var0_299 = arg0_299.frozenCount
	local var1_299 = arg1_299 == -1 and arg0_299.frozenCount or arg1_299 or 1

	arg0_299.frozenCount = arg0_299.frozenCount - var1_299
	arg0_299.canvasGroup.blocksRaycasts = arg0_299.frozenCount == 0

	if var0_299 ~= 0 and arg0_299.frozenCount == 0 then
		arg0_299:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_300)
	return arg0_300.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_301)
	arg0_301.levelCamIndices = math.max(arg0_301.levelCamIndices - 1, 0)

	if arg0_301.levelCamIndices == 0 then
		arg0_301.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.disableLevelCamera(arg0_302)
	arg0_302.levelCamIndices = arg0_302.levelCamIndices + 1

	if arg0_302.levelCamIndices > 0 then
		arg0_302.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0_0.RecordTween(arg0_303, arg1_303, arg2_303)
	arg0_303.tweens[arg1_303] = arg2_303
end

function var0_0.DeleteTween(arg0_304, arg1_304)
	local var0_304 = arg0_304.tweens[arg1_304]

	if var0_304 then
		LeanTween.cancel(var0_304)

		arg0_304.tweens[arg1_304] = nil
	end
end

function var0_0.openCommanderPanel(arg0_305, arg1_305, arg2_305, arg3_305)
	local var0_305 = arg2_305.id

	arg0_305.levelCMDFormationView:setCallback(function(arg0_306)
		if not arg3_305 then
			if arg0_306.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_305:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_306.skill)
			elseif arg0_306.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_305.contextData.commanderSelected = {
					chapterId = var0_305,
					fleetId = arg1_305.id
				}

				arg0_305:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_306.pos, arg1_305.id, arg2_305)
				arg0_305:closeCommanderPanel()
			else
				arg0_305:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_306,
					fleetId = arg1_305.id,
					chapterId = var0_305
				}, arg2_305)
			end
		elseif arg0_306.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_305:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_306.skill)
		elseif arg0_306.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_305.contextData.eliteCommanderSelected = {
				index = arg3_305,
				pos = arg0_306.pos,
				chapterId = var0_305
			}

			arg0_305:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_305, arg0_306.pos, arg2_305)
			arg0_305:closeCommanderPanel()
		else
			arg0_305:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_306,
				index = arg3_305,
				chapterId = var0_305
			}, arg2_305)
		end
	end)
	arg0_305.levelCMDFormationView:Load()
	arg0_305.levelCMDFormationView:ActionInvoke("update", arg1_305, arg0_305.commanderPrefabs)
	arg0_305.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_307)
	if arg0_307.levelCMDFormationView:isShowing() then
		arg0_307.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_307.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_308)
	arg0_308.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_309)
	arg0_309.levelCMDFormationView:Destroy()

	arg0_309.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_310, arg1_310)
	arg0_310.spTickets = arg1_310
end

function var0_0.HandleShowMsgBox(arg0_311, arg1_311)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_311)
end

function var0_0.updatePoisonAreaTip(arg0_312)
	local var0_312 = arg0_312.contextData.chapterVO
	local var1_312 = (function(arg0_313)
		local var0_313 = {}
		local var1_313 = pg.map_event_list[var0_312.id] or {}
		local var2_313

		if var0_312:isLoop() then
			var2_313 = var1_313.event_list_loop or {}
		else
			var2_313 = var1_313.event_list or {}
		end

		for iter0_313, iter1_313 in ipairs(var2_313) do
			local var3_313 = pg.map_event_template[iter1_313]

			if var3_313.c_type == arg0_313 then
				table.insert(var0_313, var3_313)
			end
		end

		return var0_313
	end)(ChapterConst.EvtType_Poison)

	if var1_312 then
		for iter0_312, iter1_312 in ipairs(var1_312) do
			local var2_312 = iter1_312.round_gametip

			if var2_312 ~= nil and var2_312 ~= "" and var0_312:getRoundNum() == var2_312[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_312[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_314)
	setActive(arg0_314._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_315)
	local var0_315 = getProxy(ChapterProxy)

	if var0_315 and not arg0_315.contextData.noRecord then
		local var1_315 = arg0_315.contextData.map

		if not var1_315 then
			return
		end

		if var1_315:NeedRecordMap() then
			var0_315:recordLastMap(ChapterProxy.LAST_MAP, var1_315.id)
		end

		if var1_315:isActivity() and not var1_315:isActExtra() then
			var0_315:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_315.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_316)
	local var0_316 = arg0_316.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_316.contextData.map:getConfig("on_activity")) or nil
	local var1_316 = var0_316 and not var0_316:isEnd() and var0_316:GetConfigClientSetting("PTID")
	local var2_316 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var2_316 and not var2_316:isEnd() and var2_316:getConfig("config_client").resId == var1_316 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_317)
		return not arg0_317:isEnd() and arg0_317:getConfig("config_client").pt_id == var1_316
	end) then
		return true
	end
end

function var0_0.willExit(arg0_318)
	arg0_318:ClearMapTransitions()
	arg0_318.loader:Clear()

	if arg0_318.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_318.topPanel, arg0_318._tf)
		pg.playerResUI:SetActive({
			active = false
		})
	end

	if arg0_318.levelFleetView and arg0_318.levelFleetView.selectIds then
		arg0_318.contextData.selectedFleetIDs = {}

		for iter0_318, iter1_318 in pairs(arg0_318.levelFleetView.selectIds) do
			for iter2_318, iter3_318 in pairs(iter1_318) do
				arg0_318.contextData.selectedFleetIDs[#arg0_318.contextData.selectedFleetIDs + 1] = iter3_318
			end
		end
	end

	arg0_318:destroyChapterPanel()
	arg0_318:DestroyLevelInfoSPPanel()
	arg0_318:destroyFleetEdit()
	arg0_318:destroyCommanderPanel()
	arg0_318:DestroyLevelStageView()
	arg0_318:hideRepairWindow()
	arg0_318:hideStrategyInfo()
	arg0_318:hideRemasterPanel()
	arg0_318:hideSpResult()
	arg0_318:destroyGrid()
	arg0_318:destroyAmbushWarn()
	arg0_318:destroyAirStrike()
	arg0_318:destroyTorpedo()
	arg0_318:destroyStrikeAnim()
	arg0_318:destroyTracking()
	arg0_318:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_318, iter5_318 in pairs(arg0_318.mbDict) do
		iter5_318:Destroy()
	end

	arg0_318.mbDict = nil

	for iter6_318, iter7_318 in pairs(arg0_318.tweens) do
		LeanTween.cancel(iter7_318)
	end

	arg0_318.tweens = nil

	if arg0_318.cloudTimer then
		_.each(arg0_318.cloudTimer, function(arg0_319)
			LeanTween.cancel(arg0_319)
		end)

		arg0_318.cloudTimer = nil
	end

	if arg0_318.newChapterCDTimer then
		arg0_318.newChapterCDTimer:Stop()

		arg0_318.newChapterCDTimer = nil
	end

	for iter8_318, iter9_318 in ipairs(arg0_318.damageTextActive) do
		LeanTween.cancel(iter9_318)
	end

	LeanTween.cancel(go(arg0_318.avoidText))

	arg0_318.map.localScale = Vector3.one
	arg0_318.map.pivot = Vector2(0.5, 0.5)
	arg0_318.float.localScale = Vector3.one
	arg0_318.float.pivot = Vector2(0.5, 0.5)

	for iter10_318, iter11_318 in ipairs(arg0_318.mapTFs) do
		clearImageSprite(iter11_318)
	end

	_.each(arg0_318.cloudRTFs, function(arg0_320)
		clearImageSprite(arg0_320)
	end)
	Destroy(arg0_318.enemyTpl)
	arg0_318:RecordLastMapOnExit()
	arg0_318.levelRemasterView:Destroy()
end

return var0_0
