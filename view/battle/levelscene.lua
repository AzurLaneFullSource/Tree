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

function var0_0.LoadEntranceActivityBg(arg0_14)
	local var0_14 = arg0_14.entranceActivity:getConfig("config_client").entrance_bg

	if not var0_14 then
		return
	end

	local var1_14 = "activitybanner"

	if string.sub(var0_14, 1, #var1_14) == var1_14 then
		var0_14 = "MainUIBanner" .. string.sub(var0_14, #var1_14 + 1)
	end

	arg0_14.entranceActivityBgPath = var0_14

	pg.PoolMgr.GetInstance():GetPrefab(var0_14, "", true, function(arg0_15)
		if arg0_14.exited then
			pg.PoolMgr.GetInstance():ReturnPrefab(var0_14, "", arg0_15)

			return
		end

		arg0_14.entranceActivityBg = arg0_15

		setParent(arg0_15.transform, arg0_14.entranceLayer:Find("enters/enter_ready/activity"))
		setText(arg0_15.transform:Find("Text"), arg0_14.entranceActivity:GetActivityTimeStr(true))

		arg0_15.transform.anchorMin = Vector2.zero
		arg0_15.transform.anchorMax = Vector2.one
		arg0_15.transform.offsetMin = Vector2.zero
		arg0_15.transform.offsetMax = Vector2.zero
	end)
end

function var0_0.initEvents(arg0_16)
	arg0_16:bind(LevelUIConst.OPEN_COMMANDER_PANEL, function(arg0_17, arg1_17, arg2_17, arg3_17)
		arg0_16:openCommanderPanel(arg1_17, arg2_17, arg3_17)
	end)
	arg0_16:bind(LevelUIConst.HANDLE_SHOW_MSG_BOX, function(arg0_18, arg1_18)
		arg0_16:HandleShowMsgBox(arg1_18)
	end)
	arg0_16:bind(LevelUIConst.DO_AMBUSH_WARNING, function(arg0_19, arg1_19)
		arg0_16:doAmbushWarning(arg1_19)
	end)
	arg0_16:bind(LevelUIConst.DISPLAY_AMBUSH_INFO, function(arg0_20, arg1_20)
		arg0_16:displayAmbushInfo(arg1_20)
	end)
	arg0_16:bind(LevelUIConst.DISPLAY_STRATEGY_INFO, function(arg0_21, arg1_21)
		arg0_16:displayStrategyInfo(arg1_21)
	end)
	arg0_16:bind(LevelUIConst.FROZEN, function(arg0_22)
		arg0_16:frozen()
	end)
	arg0_16:bind(LevelUIConst.UN_FROZEN, function(arg0_23)
		arg0_16:unfrozen()
	end)
	arg0_16:bind(LevelUIConst.DO_TRACKING, function(arg0_24, arg1_24)
		arg0_16:doTracking(arg1_24)
	end)
	arg0_16:bind(LevelUIConst.SWITCH_TO_MAP, function()
		if arg0_16:isfrozen() then
			return
		end

		arg0_16:switchToMap()
	end)
	arg0_16:bind(LevelUIConst.DISPLAY_REPAIR_WINDOW, function(arg0_26, arg1_26)
		arg0_16:displayRepairWindow(arg1_26)
	end)
	arg0_16:bind(LevelUIConst.DO_PLAY_ANIM, function(arg0_27, arg1_27)
		arg0_16:doPlayAnim(arg1_27.name, arg1_27.callback, arg1_27.onStart)
	end)
	arg0_16:bind(LevelUIConst.HIDE_FLEET_SELECT, function()
		arg0_16:hideFleetSelect()
	end)
	arg0_16:bind(LevelUIConst.HIDE_FLEET_EDIT, function(arg0_29)
		arg0_16:hideFleetEdit()
	end)
	arg0_16:bind(LevelUIConst.ADD_MSG_QUEUE, function(arg0_30, arg1_30)
		arg0_16:addbubbleMsgBox(arg1_30)
	end)
	arg0_16:bind(LevelUIConst.SET_MAP, function(arg0_31, arg1_31)
		arg0_16:setMap(arg1_31)
	end)
end

function var0_0.onZeroHourRefresh(arg0_32)
	if arg0_32.levelInfoView:isShowing() then
		arg0_32.levelInfoView:RefreshChapterAutoPanel()
	end

	if arg0_32.levelInfoSPView and arg0_32.levelInfoSPView:isShowing() then
		arg0_32.levelInfoView:RefreshChapterAutoPanel()
	end
end

function var0_0.addbubbleMsgBox(arg0_33, arg1_33)
	table.insert(arg0_33.bubbleMsgBoxes, arg1_33)

	if #arg0_33.bubbleMsgBoxes > 1 then
		return
	end

	local var0_33

	local function var1_33()
		local var0_34 = arg0_33.bubbleMsgBoxes[1]

		if var0_34 then
			var0_34(function()
				table.remove(arg0_33.bubbleMsgBoxes, 1)
				var1_33()
			end)
		end
	end

	var1_33()
end

function var0_0.CleanBubbleMsgbox(arg0_36)
	table.clean(arg0_36.bubbleMsgBoxes)
end

function var0_0.updatePtActivity(arg0_37, arg1_37)
	arg0_37.ptActivity = arg1_37

	if not arg0_37.ptActivity then
		return
	end

	arg0_37:updateActivityRes()
end

function var0_0.updateActivityRes(arg0_38)
	local var0_38 = findTF(arg0_38.ptTotal, "Text")
	local var1_38 = findTF(arg0_38.ptTotal, "icon/Image")

	if var0_38 and var1_38 and arg0_38.ptActivity then
		setText(var0_38, "x" .. arg0_38.ptActivity:GetTotalPtCount())

		local var2_38 = arg0_38.ptActivity:GetPTDrop():getIcon()

		GetImageSpriteFromAtlasAsync(var2_38, "", var1_38, true)
		GetImageSpriteFromAtlasAsync(var2_38, "", arg0_38.actExchangeShopBtn:Find("icon"), true)
	end
end

function var0_0.setCommanderPrefabs(arg0_39, arg1_39)
	arg0_39.commanderPrefabs = arg1_39
end

function var0_0.didEnter(arg0_40)
	arg0_40.openedCommanerSystem = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_40.player.level, "CommanderCatMediator")

	onButton(arg0_40, arg0_40.topChapter:Find("back_button"), function()
		if arg0_40:isfrozen() then
			return
		end

		local var0_41 = arg0_40.contextData.map

		if var0_41 and (var0_41:isActivity() or var0_41:isEscort()) then
			arg0_40:emit(LevelMediator2.ON_SWITCH_NORMAL_MAP)

			return
		elseif var0_41 and var0_41:isSkirmish() then
			arg0_40:emit(var0_0.ON_BACK)
		elseif not arg0_40.contextData.entranceStatus then
			arg0_40:ShowEntranceUI(true)
		else
			arg0_40:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_40, arg0_40.btnSpecial, function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.dailyBtn, function()
		if arg0_40:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_40:updatDailyBtnTip()
		arg0_40:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.challengeBtn, function()
		if arg0_40:isfrozen() then
			return
		end

		local var0_44, var1_44 = arg0_40:checkChallengeOpen()

		if var0_44 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_44)
		else
			arg0_40:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.militaryExerciseBtn, function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.normalBtn, function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:setMap(arg0_40.contextData.map:getBindMapId())
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.eliteBtn, function()
		if arg0_40:isfrozen() then
			return
		end

		if arg0_40.contextData.map:getBindMapId() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

			local var0_47 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			if var0_47 then
				arg0_40:setMap(var0_47.configId)
				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_warp_to_latest_map"))
			end
		elseif arg0_40.contextData.map:isEliteEnabled() then
			arg0_40:setMap(arg0_40.contextData.map:getBindMapId())
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unsatisfied"))
		end
	end, SFX_UI_WEIGHANCHOR_HARD)
	onButton(arg0_40, arg0_40.remasterBtn, function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_40:updateRemasterBtnTip()
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.entranceLayer:Find("enters/enter_main"), function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:ShowSelectedMap(arg0_40:GetInitializeMap())
	end, SFX_PANEL)
	setText(arg0_40.entranceLayer:Find("enters/enter_main/Text"), getProxy(ChapterProxy):getLastUnlockMap():getLastUnlockChapterName())
	onButton(arg0_40, arg0_40.entranceLayer:Find("enters/enter_world/enter"), function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:emit(LevelMediator2.ENTER_WORLD)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.entranceLayer:Find("enters/enter_ready/activity"), function()
		if arg0_40:isfrozen() then
			return
		end

		switch(arg0_40.entranceActivity:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0_40:emit(LevelMediator2.ON_ACTIVITY_MAP, arg0_40.entranceActivity.id)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
				arg0_40:emit(LevelMediator2.ON_OPEN_ACT_BOSS_BATTLE)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
				arg0_40:emit(LevelMediator2.ON_BOSSRUSH_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
				arg0_40:emit(LevelMediator2.ON_BOSSSINGLE_MAP, {
					mode = OtherworldMapScene.MODE_BATTLE
				})
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
				arg0_40:emit(LevelMediator2.ON_CLUE_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function()
				arg0_40:emit(LevelMediator2.ON_COLLAB_BOSSRUSH_MAP)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.entranceLayer:Find("btns/btn_remaster"), function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_40:updateRemasterBtnTip()
	end, SFX_PANEL)
	setActive(arg0_40.entranceLayer:Find("btns/btn_remaster"), OPEN_REMASTER)
	onButton(arg0_40, arg0_40.entranceLayer:Find("btns/btn_challenge"), function()
		if arg0_40:isfrozen() then
			return
		end

		local var0_59, var1_59 = arg0_40:checkChallengeOpen()

		if var0_59 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_59)
		else
			arg0_40:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.entranceLayer:Find("btns/btn_pvp"), function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.entranceLayer:Find("btns/btn_daily"), function()
		if arg0_40:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_40:updatDailyBtnTip()
		arg0_40:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.entranceLayer:Find("btns/btn_task"), function()
		if arg0_40:isfrozen() then
			return
		end

		arg0_40:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	setActive(arg0_40.entranceLayer:Find("enters/enter_world/enter"), not WORLD_ENTER_LOCK)
	setActive(arg0_40.entranceLayer:Find("enters/enter_world/nothing"), WORLD_ENTER_LOCK)
	setActive(arg0_40.entranceLayer:Find("enters/enter_world/enter/tip"), getProxy(ChapterAutoProxy):IsAllCommissionFinish(ChapterAutoProxy.TYPE.WORLD))

	arg0_40.entranceActivity = getProxy(ActivityProxy):getEnterReadyActivity()[1]

	setActive(arg0_40.entranceLayer:Find("enters/enter_ready/nothing"), not tobool(arg0_40.entranceActivity))
	setActive(arg0_40.entranceLayer:Find("enters/enter_ready/activity"), tobool(arg0_40.entranceActivity))

	if tobool(arg0_40.entranceActivity) then
		arg0_40:LoadEntranceActivityBg()
	end

	arg0_40:updateRightPanel()

	local var0_40 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_40.player.level, "EventMediator")

	setActive(arg0_40.btnSpecial:Find("lock"), not var0_40)
	setActive(arg0_40.entranceLayer:Find("btns/btn_task/lock"), not var0_40)

	local var1_40 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_40.player.level, "DailyLevelMediator")

	setActive(arg0_40.dailyBtn:Find("lock"), not var1_40)
	setActive(arg0_40.entranceLayer:Find("btns/btn_daily/lock"), not var1_40)

	local var2_40 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_40.player.level, "MilitaryExerciseMediator")

	setActive(arg0_40.militaryExerciseBtn:Find("lock"), not var2_40)
	setActive(arg0_40.entranceLayer:Find("btns/btn_pvp/lock"), not var2_40)

	local var3_40 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_40.player.level, "WorldMediator")

	setActive(arg0_40.entranceLayer:Find("enters/enter_world/enter/lock"), not var3_40)

	local var4_40 = LimitChallengeConst.IsOpen()

	setActive(arg0_40.challengeBtn:Find("lock"), not var4_40)
	setActive(arg0_40.entranceLayer:Find("btns/btn_challenge/lock"), not var4_40)

	local var5_40 = LimitChallengeConst.IsInAct()

	setActive(arg0_40.challengeBtn, var5_40)
	setActive(arg0_40.entranceLayer:Find("btns/btn_challenge"), var5_40)

	local var6_40 = LimitChallengeConst.IsShowRedPoint()

	setActive(arg0_40.entranceLayer:Find("btns/btn_challenge/tip"), var6_40)
	arg0_40:initMapBtn(arg0_40.btnPrev, -1)
	arg0_40:initMapBtn(arg0_40.btnNext, 1)
	arg0_40:registerActBtn()

	if arg0_40.contextData.editEliteChapter then
		local var7_40 = getProxy(ChapterProxy):getChapterById(arg0_40.contextData.editEliteChapter)

		arg0_40:displayFleetEdit(var7_40)

		arg0_40.contextData.editEliteChapter = nil
	elseif arg0_40.contextData.selectedChapterVO then
		arg0_40:displayFleetSelect(arg0_40.contextData.selectedChapterVO)

		arg0_40.contextData.selectedChapterVO = nil
	end

	local var8_40 = arg0_40.contextData.chapterVO

	if not var8_40 or not var8_40.active then
		arg0_40:tryPlaySubGuide()
	end

	arg0_40:updateRemasterBtnTip()
	arg0_40:updatDailyBtnTip()

	if arg0_40.contextData.open_remaster then
		arg0_40:displayRemasterPanel(arg0_40.contextData.isSP)

		arg0_40.contextData.open_remaster = nil
	end

	arg0_40:ShowEntranceUI(arg0_40.contextData.entranceStatus)

	if not arg0_40.contextData.entranceStatus then
		arg0_40:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg0_40:GetInitializeMap())
	end

	arg0_40:emit(LevelMediator2.ON_DIDENTER)
end

function var0_0.updateRightPanel(arg0_63)
	arg0_63.rightActivityBtns = defaultValue(arg0_63.rightActivityBtns, {
		LevelSecondMapBtn.New(arg0_63.actBtnTpl, arg0_63.event, false)
	})

	local var0_63 = {}
	local var1_63 = {}

	for iter0_63, iter1_63 in ipairs(arg0_63.rightActivityBtns) do
		if iter1_63:InShowTime() then
			table.insert(var0_63, iter1_63)
		else
			table.insert(var1_63, iter1_63)
		end
	end

	table.sort(var0_63, CompareFuncs({
		function(arg0_64)
			return arg0_64.config.group_id
		end
	}))

	for iter2_63, iter3_63 in ipairs(var0_63) do
		iter3_63:Init(iter2_63)
	end

	for iter4_63, iter5_63 in ipairs(var1_63) do
		iter5_63:Clear()
	end
end

function var0_0.checkChallengeOpen(arg0_65)
	local var0_65 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_65, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_66)
	if arg0_66.contextData.map and arg0_66.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_66)
end

function var0_0.onBackPressed(arg0_67)
	if arg0_67:isfrozen() then
		return
	end

	if arg0_67.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_67.chapterAutoDetailPanel:isShowing() then
		arg0_67:HideChapterAutoDetailPanel()
	end

	if arg0_67.levelInfoView:isShowing() then
		arg0_67:hideChapterPanel()

		return
	end

	if arg0_67.levelInfoSPView and arg0_67.levelInfoSPView:isShowing() then
		arg0_67:HideLevelInfoSPPanel()

		return
	end

	if arg0_67.levelFleetView:isShowing() then
		arg0_67:hideFleetEdit()

		return
	end

	if arg0_67.levelStrategyView then
		arg0_67:hideStrategyInfo()

		return
	end

	if arg0_67.levelRepairView then
		arg0_67:hideRepairWindow()

		return
	end

	if arg0_67.levelRemasterView:isShowing() then
		arg0_67:hideRemasterPanel()

		return
	end

	if arg0_67.contextData.map and arg0_67.contextData.map:getConfig("ui_type") == MapBuilder.TYPEEXSP and arg0_67.mapBuilder.personalPage:IsActive() then
		arg0_67.mapBuilder.personalPage:Hide()

		return
	end

	if isActive(arg0_67.helpPage) then
		setActive(arg0_67.helpPage, false)

		return
	end

	local var0_67 = arg0_67.contextData.chapterVO
	local var1_67 = getProxy(ChapterProxy):getActiveChapter()

	if var0_67 and var1_67 then
		arg0_67:switchToMap()

		return
	end

	triggerButton(arg0_67.topChapter:Find("back_button"))
end

function var0_0.ShowEntranceUI(arg0_68, arg1_68)
	setActive(arg0_68.entranceLayer, arg1_68)
	setActive(arg0_68.entranceBg, arg1_68)
	setActive(arg0_68.map, not arg1_68)
	setActive(arg0_68.float, not arg1_68)
	setActive(arg0_68.mainLayer, not arg1_68)
	setActive(arg0_68.topChapter:Find("type_entrance"), arg1_68)

	arg0_68.contextData.entranceStatus = tobool(arg1_68)

	if arg1_68 then
		setActive(arg0_68.topChapter:Find("title_chapter"), false)
		setActive(arg0_68.topChapter:Find("type_chapter"), false)
		setActive(arg0_68.topChapter:Find("type_escort"), false)
		setActive(arg0_68.topChapter:Find("type_skirmish"), false)

		if arg0_68.newChapterCDTimer then
			arg0_68.newChapterCDTimer:Stop()

			arg0_68.newChapterCDTimer = nil
		end

		arg0_68:RecordLastMapOnExit()

		arg0_68.contextData.mapIdx = nil
		arg0_68.contextData.map = nil
	end

	arg0_68:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_69, arg1_69, arg2_69)
	if arg0_69.preloadLevelDone then
		existCall(arg2_69)

		return
	end

	local var0_69

	local function var1_69()
		if not arg0_69.exited then
			arg0_69.preloadLevelDone = true

			existCall(arg2_69)
		end
	end

	local var2_69 = getProxy(ChapterProxy):getMapById(arg1_69)
	local var3_69 = arg0_69:GetMapBG(var2_69)

	table.ParallelIpairsAsync(var3_69, function(arg0_71, arg1_71, arg2_71)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_71.BG, "", arg2_71)
	end, var1_69)
end

function var0_0.setShips(arg0_72, arg1_72)
	arg0_72.shipVOs = arg1_72
end

function var0_0.updateRes(arg0_73, arg1_73)
	if arg0_73.levelStageView then
		arg0_73.levelStageView:ActionInvoke("SetPlayer", arg1_73)
	end

	arg0_73.player = arg1_73
end

function var0_0.setEliteQuota(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg2_74 - arg1_74
	local var1_74 = arg0_74.eliteQuota:Find("bg/Text"):GetComponent(typeof(Text))

	if arg1_74 == arg2_74 then
		var1_74.color = Color.red
	else
		var1_74.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_74.text = var0_74 .. "/" .. arg2_74
end

function var0_0.updateEvent(arg0_75, arg1_75)
	local var0_75 = arg1_75:hasFinishState()

	setActive(arg0_75.btnSpecial:Find("tip"), var0_75)
	setActive(arg0_75.entranceLayer:Find("btns/btn_task/tip"), var0_75)
end

function var0_0.updateFleet(arg0_76, arg1_76)
	arg0_76.fleets = arg1_76
end

function var0_0.updateChapterVO(arg0_77, arg1_77, arg2_77)
	if arg0_77.contextData.chapterVO and arg0_77.contextData.chapterVO.id == arg1_77.id and arg1_77.active then
		arg0_77:setChapter(arg1_77)
	end

	if arg0_77.contextData.chapterVO and arg0_77.contextData.chapterVO.id == arg1_77.id and arg1_77.active and arg0_77.levelStageView and arg0_77.grid then
		local var0_77 = false
		local var1_77 = false
		local var2_77 = false

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyFleet) > 0 then
			arg0_77.levelStageView:updateStageFleet()
			arg0_77.levelStageView:updateAmbushRate(arg1_77.fleet.line, true)

			var2_77 = true

			if arg0_77.grid then
				arg0_77.grid:RefreshFleetCells()
				arg0_77.grid:UpdateFloor()
				arg0_77.grid:UpdateWeatherCells()

				var0_77 = true
			end
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyChampion) > 0 then
			var2_77 = true

			if arg0_77.grid then
				arg0_77.grid:UpdateFleets()
				arg0_77.grid:clearChampions()
				arg0_77.grid:initChampions()

				var1_77 = true
			end
		elseif bit.band(arg2_77, ChapterConst.DirtyChampionPosition) > 0 then
			var2_77 = true

			if arg0_77.grid then
				arg0_77.grid:UpdateFleets()
				arg0_77.grid:updateChampions()

				var1_77 = true
			end
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyAchieve) > 0 then
			arg0_77.levelStageView:updateStageAchieve()
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyAttachment) > 0 then
			arg0_77.levelStageView:updateAmbushRate(arg1_77.fleet.line, true)

			if arg0_77.grid then
				if not (arg2_77 < 0) and not (bit.band(arg2_77, ChapterConst.DirtyFleet) > 0) then
					arg0_77.grid:updateFleet(arg1_77.fleets[arg1_77.findex].id)
				end

				arg0_77.grid:updateAttachments()

				if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyAutoAction) > 0 then
					arg0_77.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_77 = true
				end
			end
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyStrategy) > 0 then
			arg0_77.levelStageView:updateStageStrategy()

			var2_77 = true

			arg0_77.levelStageView:updateStageBarrier()
			arg0_77.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_77 then
			arg0_77.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_77 then
			arg0_77.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyCellFlag) > 0 then
			arg0_77.grid:UpdateFloor()
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyBase) > 0 then
			arg0_77.levelStageView:UpdateDefenseStatus()
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyFloatItems) > 0 then
			arg0_77.grid:UpdateItemCells()
		end

		if arg2_77 < 0 or bit.band(arg2_77, ChapterConst.DirtyWeather) > 0 then
			arg0_77.grid:UpdateWeatherCells()
		end

		if var2_77 then
			arg0_77.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_78)
	arg0_78.cloudRTFs = {}
	arg0_78.cloudRects = {}
	arg0_78.cloudTimer = {}

	for iter0_78 = 1, 6 do
		local var0_78 = arg0_78.clouds:Find("cloud_" .. iter0_78)
		local var1_78 = rtf(var0_78)

		table.insert(arg0_78.cloudRTFs, var1_78)
		table.insert(arg0_78.cloudRects, var1_78.rect.width)
	end

	arg0_78:initCloudsPos()

	for iter1_78, iter2_78 in ipairs(arg0_78.cloudRTFs) do
		local var2_78 = arg0_78.cloudRects[iter1_78]
		local var3_78 = arg0_78.initPositions[iter1_78] or Vector2(0, 0)
		local var4_78 = 30 - var3_78.y / 20
		local var5_78 = (arg0_78.mapWidth + var2_78) / var4_78
		local var6_78

		var6_78 = LeanTween.moveX(iter2_78, arg0_78.mapWidth, var5_78):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_78 = arg0_78.cloudRects[iter1_78]
			iter2_78.anchoredPosition = Vector2(-var2_78, var3_78.y)

			var6_78:setFrom(-var2_78):setTime((arg0_78.mapWidth + var2_78) / var4_78)
		end))
		var6_78.passed = math.random() * var5_78
		arg0_78.cloudTimer[iter1_78] = var6_78.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_80)
	arg0_80:PlayBGM()
	arg0_80:SwitchMapBG(arg0_80.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_81, arg1_81, arg2_81)
	if not arg1_81 then
		return
	end

	local var0_81 = arg0_81.contextData.map:getConfig("ani_controller")

	local function var1_81(arg0_82)
		arg0_82 = tf(arg0_82)

		local var0_82 = Vector3.one

		if arg0_82.rect.width > 0 and arg0_82.rect.height > 0 then
			var0_82.x = arg0_82.parent.rect.width / arg0_82.rect.width
			var0_82.y = arg0_82.parent.rect.height / arg0_82.rect.height
		end

		arg0_82.localScale = var0_82

		if var0_81 and #var0_81 > 0 then
			local var1_82 = getProxy(ChapterProxy)

			;(function()
				for iter0_83, iter1_83 in ipairs(var0_81) do
					local var0_83 = false
					local var1_83 = iter1_83[2][1]

					for iter2_83, iter3_83 in ipairs(var1_83) do
						local var2_83 = var1_82:GetChapterItemById(iter3_83)

						if var2_83 and var2_83:isClear() then
							var0_83 = true

							break
						end
					end

					if iter1_83[1] == var2_0 then
						local var3_83 = _.rest(iter1_83[2], 2)

						for iter4_83, iter5_83 in ipairs(var3_83) do
							local var4_83 = arg0_82:Find(iter5_83)

							if not IsNil(var4_83) and not var0_83 then
								setActive(var4_83, false)
							end
						end
					elseif iter1_83[1] == var3_0 then
						local var5_83 = _.rest(iter1_83[2], 2)

						for iter6_83, iter7_83 in ipairs(var5_83) do
							local var6_83 = arg0_82:Find(iter7_83)

							if not IsNil(var6_83) and not var0_83 then
								setActive(var6_83, true)

								return
							end
						end
					elseif iter1_83[1] == var4_0 then
						local var7_83 = _.rest(iter1_83[2], 2)

						for iter8_83, iter9_83 in ipairs(var7_83) do
							local var8_83 = arg0_82:Find(iter9_83)

							if not IsNil(var8_83) and not var0_83 then
								setActive(var8_83, true)
							end
						end
					end
				end
			end)()
		end
	end

	local var2_81 = arg0_81.loader:GetPrefab("ui/" .. arg1_81, arg1_81, function(arg0_84)
		arg0_84:SetActive(true)

		local var0_84 = arg0_81.mapTFs[arg2_81]

		setParent(arg0_84, var0_84)
		pg.ViewUtils.SetSortingOrder(arg0_84, ChapterConst.LayerWeightMap + arg2_81 * 2 - 1)
		var1_81(arg0_84)
	end)

	table.insert(arg0_81.mapGroup, var2_81)
end

function var0_0.HideBtns(arg0_85)
	setActive(arg0_85.btnPrev, false)
	setActive(arg0_85.eliteQuota, false)
	setActive(arg0_85.escortBar, false)
	setActive(arg0_85.skirmishBar, false)
	setActive(arg0_85.normalBtn, false)
	setActive(arg0_85.actNormalBtn, false)
	setActive(arg0_85.eliteBtn, false)
	setActive(arg0_85.actEliteBtn, false)
	setActive(arg0_85.actExtraBtn, false)
	setActive(arg0_85.remasterBtn, false)
	setActive(arg0_85.btnNext, false)
	setActive(arg0_85.remasterAwardBtn, false)
	setActive(arg0_85.eventContainer, false)
	setActive(arg0_85.activityBtn, false)
	setActive(arg0_85.ptTotal, false)
	setActive(arg0_85.ticketTxt.parent, false)
	setActive(arg0_85.countDown, false)
	setActive(arg0_85.actAtelierBuffBtn, false)
	setActive(arg0_85.actAtelierYumiaBuffBtn, false)
	setActive(arg0_85.actExtraRank, false)
	setActive(arg0_85.actExchangeShopBtn, false)
	setActive(arg0_85.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_86)
	local var0_86 = arg0_86.contextData.map:getConfig("type")

	setActive(arg0_86.normalBtn, var0_86 == Map.ELITE)
	setActive(arg0_86.eliteQuota, var0_86 == Map.ELITE)
	setActive(arg0_86.eliteBtn, var0_86 == Map.SCENARIO)

	local var1_86 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_86.eliteBtn:Find("pic_activity"), var1_86 and not var1_86:isEnd())
end

function var0_0.updateActivityBtns(arg0_87)
	local var0_87 = arg0_87.contextData.map
	local var1_87, var2_87 = var0_87:isActivity()
	local var3_87 = var0_87:isRemaster()
	local var4_87 = var0_87:isSkirmish()
	local var5_87 = var0_87:isEscort()
	local var6_87 = var0_87:getConfig("type")
	local var7_87 = setmetatable({}, MainActMapBtn)
	local var8_87 = var7_87:InShowTime() and not var1_87 and not var4_87 and not var5_87

	arg0_87.activityBtnLinkAct = var7_87:GetActivity()

	if var8_87 then
		var7_87.image = arg0_87.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var7_87.subImage = arg0_87.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var7_87.tipTr = arg0_87.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var7_87.tipTxt = arg0_87.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_87 = var7_87:InShowTime()

		if var8_87 then
			var7_87:InitTipImage()
			var7_87:InitSubImage()
			var7_87:InitImage(function()
				return
			end)
			var7_87:OnInit()
		end
	end

	setActive(arg0_87.activityBtn, var8_87)
	arg0_87:updateRemasterInfo()

	if var1_87 and var2_87 then
		local var9_87

		if var0_87:isRemaster() then
			var9_87 = getProxy(ChapterProxy):getRemasterMaps(var0_87.remasterId)
		else
			var9_87 = getProxy(ChapterProxy):getMapsByActivities(var0_87:getConfig("on_activity"))
		end

		local var10_87 = underscore.any(var9_87, function(arg0_89)
			return arg0_89:isActExtra()
		end)

		setActive(arg0_87.actExtraBtn, var10_87 and var6_87 ~= Map.ACT_EXTRA)

		if isActive(arg0_87.actExtraBtn) then
			if underscore.all(underscore.filter(var9_87, function(arg0_90)
				local var0_90 = arg0_90:getMapType()

				return var0_90 == Map.ACTIVITY_EASY or var0_90 == Map.ACTIVITY_HARD
			end), function(arg0_91)
				return arg0_91:isAllChaptersClear()
			end) then
				setActive(arg0_87.actExtraBtnAnim, true)
			else
				setActive(arg0_87.actExtraBtnAnim, false)
			end

			setActive(arg0_87.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive(var0_87:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_87 = checkExist(var0_87:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_87.actEliteBtn, var11_87 and var6_87 ~= Map.ACTIVITY_HARD)
		setActive(arg0_87.actNormalBtn, var6_87 ~= Map.ACTIVITY_EASY)
		setActive(arg0_87.actExtraRank, var6_87 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_92)
			if not arg0_92 or arg0_92:isEnd() then
				return
			end

			local var0_92 = arg0_92:getConfig("config_data")[1]

			return _.any(var0_87:getChapters(), function(arg0_93)
				if not arg0_93:IsEXChapter() then
					return false
				end

				return table.contains(arg0_93:getConfig("boss_expedition_id"), var0_92)
			end)
		end))
		setActive(arg0_87.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_87 and var2_87 and arg0_87:IsActShopActive())

		local var12_87 = arg0_87.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_87.contextData.map:getConfig("on_activity")) or nil
		local var13_87 = var12_87 and var12_87:GetConfigClientPTActivity() or nil

		arg0_87:updatePtActivity(var13_87)
		setActive(arg0_87.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_87 and var2_87 and arg0_87.ptActivity and not arg0_87.ptActivity:isEnd())
	else
		setActive(arg0_87.actExtraBtn, false)
		setActive(arg0_87.actEliteBtn, false)
		setActive(arg0_87.actNormalBtn, false)
		setActive(arg0_87.actExtraRank, false)
		setActive(arg0_87.actExchangeShopBtn, false)
		setActive(arg0_87.actAtelierBuffBtn, false)
		setActive(arg0_87.actAtelierYumiaBuffBtn, false)
		setActive(arg0_87.ptTotal, false)
	end

	setActive(arg0_87.eventContainer, (not var1_87 or not var2_87) and not var5_87)
	setActive(arg0_87.remasterBtn, OPEN_REMASTER and (var3_87 or not var1_87 and not var5_87 and not var4_87))
	setActive(arg0_87.ticketTxt.parent, var3_87)
	arg0_87:updateRemasterTicket()
	arg0_87:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_94)
	setText(arg0_94.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_94:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_95)
	local var0_95 = getProxy(ChapterProxy)
	local var1_95 = var0_95:ifShowRemasterTip() or var0_95:anyRemasterAwardCanReceive()

	SetActive(arg0_95.remasterBtn:Find("tip"), var1_95)
	SetActive(arg0_95.entranceLayer:Find("btns/btn_remaster/tip"), var1_95)
end

function var0_0.updatDailyBtnTip(arg0_96)
	local var0_96 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_96.dailyBtn:Find("tip"), var0_96)
	SetActive(arg0_96.entranceLayer:Find("btns/btn_daily/tip"), var0_96)
end

function var0_0.updateRemasterInfo(arg0_97)
	arg0_97:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_97.contextData.map then
		return
	end

	local var0_97 = getProxy(ChapterProxy)
	local var1_97 = arg0_97.contextData.map:getRemaster()
	local var2_97 = BossRushChapterRemasterHelper.ChapterAwardInfo(var1_97)

	setActive(arg0_97.remasterAwardBtn, var2_97)

	if var2_97 then
		local var3_97 = var2_97[1]
		local var4_97, var5_97, var6_97, var7_97, var8_97 = unpack(var2_97[2])
		local var9_97 = var2_97[3]
		local var10_97 = var0_97:getRemasterInfo(var9_97, var4_97, var3_97)

		setText(arg0_97.remasterAwardBtn:Find("Text"), var10_97.count .. "/" .. var7_97)
		updateDrop(arg0_97.remasterAwardBtn:Find("IconTpl"), {
			type = var5_97,
			id = var6_97
		})
		setActive(arg0_97.remasterAwardBtn:Find("tip"), var7_97 <= var10_97.count)
		onButton(arg0_97, arg0_97.remasterAwardBtn, function()
			local var0_98 = BossRushChapterRemasterHelper.GetAwardName(var9_97, var4_97)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_97,
					id = var6_97
				},
				remaster = {
					word = i18n("level_remaster_tip4", var0_98),
					number = var10_97.count .. "/" .. var7_97,
					btn_text = i18n(var10_97.count < var7_97 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var10_97.count < var7_97 then
							if var9_97 and var9_97 > 0 then
								arg0_97:emit(LevelMediator2.ON_BOSSRUSH_REMASTER_ACTIVITY, var9_97)

								return
							end

							local var0_99 = pg.chapter_template[var4_97].map
							local var1_99, var2_99 = var0_97:getMapById(var0_99):isUnlock()

							if not var1_99 then
								pg.TipsMgr.GetInstance():ShowTips(var2_99)
							else
								arg0_97:ShowSelectedMap(var0_99)
							end
						else
							arg0_97:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_97, var3_97, var9_97)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_100)
	local var0_100 = getProxy(ChapterProxy)

	if arg0_100.newChapterCDTimer then
		arg0_100.newChapterCDTimer:Stop()

		arg0_100.newChapterCDTimer = nil
	end

	local var1_100 = 0

	if arg0_100.contextData.map:isActivity() and not arg0_100.contextData.map:isRemaster() then
		local var2_100 = var0_100:getMapsByActivities(arg0_100.contextData.map:getConfig("on_activity"))

		_.each(var2_100, function(arg0_101)
			local var0_101 = arg0_101:getChapterTimeLimit()

			if var1_100 == 0 then
				var1_100 = var0_101
			else
				var1_100 = math.min(var1_100, var0_101)
			end
		end)
		setActive(arg0_100.countDown, var1_100 > 0)
		setText(arg0_100.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_100.countDown, false)
	end

	if var1_100 > 0 then
		setText(arg0_100.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_100))

		arg0_100.newChapterCDTimer = Timer.New(function()
			var1_100 = var1_100 - 1

			if var1_100 <= 0 then
				arg0_100:updateCountDown()

				if not arg0_100.contextData.chapterVO then
					arg0_100:setMap(arg0_100.contextData.mapIdx)
				end
			else
				setText(arg0_100.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_100))
			end
		end, 1, -1)

		arg0_100.newChapterCDTimer:Start()
	else
		setText(arg0_100.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_103)
	onButton(arg0_103, arg0_103.actExtraRank, function()
		if arg0_103:isfrozen() then
			return
		end

		arg0_103:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_103, arg0_103.activityBtn, function()
		if arg0_103:isfrozen() then
			return
		end

		if arg0_103.activityBtnLinkAct then
			local var0_105 = arg0_103.activityBtnLinkAct:getConfig("type")
			local var1_105 = arg0_103.activityBtnLinkAct.id

			if var0_105 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)

				return
			elseif var0_105 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)

				return
			elseif var1_105 == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)

				return
			elseif var0_105 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ZHANG_WU_BOSS)

				return
			end
		end

		arg0_103:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_103, arg0_103.actExchangeShopBtn, function()
		if arg0_103:isfrozen() then
			return
		end

		arg0_103:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_103, arg0_103.actAtelierBuffBtn, function()
		if arg0_103:isfrozen() then
			return
		end

		arg0_103:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)
	onButton(arg0_103, arg0_103.actAtelierYumiaBuffBtn, function()
		if arg0_103:isfrozen() then
			return
		end

		arg0_103:emit(LevelMediator2.SHOW_ATELIER_BUFF, true)
	end, SFX_UI_CLICK)

	local var0_103 = getProxy(ChapterProxy)

	local function var1_103(arg0_109, arg1_109, arg2_109)
		local var0_109

		if arg0_109:isRemaster() then
			var0_109 = var0_103:getRemasterMaps(arg0_109.remasterId)
		else
			var0_109 = var0_103:getMapsByActivities(arg0_109:getConfig("on_activity"))
		end

		local var1_109 = _.select(var0_109, function(arg0_110)
			return arg0_110:getMapType() == arg1_109
		end)

		table.sort(var1_109, function(arg0_111, arg1_111)
			return arg0_111.id < arg1_111.id
		end)

		local var2_109 = table.indexof(underscore.map(var1_109, function(arg0_112)
			return arg0_112.id
		end), arg2_109) or #var1_109

		while not var1_109[var2_109]:isUnlock() do
			if var2_109 > 1 then
				var2_109 = var2_109 - 1
			else
				break
			end
		end

		return var1_109[var2_109]
	end

	arg0_103:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_113, arg1_113, arg2_113)
		arg2_113 = arg2_113 or switch(arg1_113, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_103.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_103.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_113 = var1_103(arg0_103.contextData.map, arg1_113, arg2_113)
		local var1_113, var2_113 = var0_113:isUnlock()

		if var1_113 then
			arg0_103:setMap(var0_113.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_113)
		end
	end)
	onButton(arg0_103, arg0_103.actNormalBtn, function()
		if arg0_103:isfrozen() then
			return
		end

		arg0_103:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_103, arg0_103.actEliteBtn, function()
		if arg0_103:isfrozen() then
			return
		end

		arg0_103:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_103, arg0_103.actExtraBtn, function()
		if arg0_103:isfrozen() then
			return
		end

		arg0_103:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_120, arg1_120)
	arg0_120.initPositions = {}

	local var0_120 = arg1_120 or 1
	local var1_120 = pg.expedition_data_by_map[var0_120].clouds_pos

	for iter0_120, iter1_120 in ipairs(arg0_120.cloudRTFs) do
		local var2_120 = var1_120[iter0_120]

		if var2_120 then
			iter1_120.anchoredPosition = Vector2(var2_120[1], var2_120[2])

			table.insert(arg0_120.initPositions, iter1_120.anchoredPosition)
		else
			setActive(iter1_120, false)
		end
	end
end

function var0_0.initMapBtn(arg0_121, arg1_121, arg2_121)
	onButton(arg0_121, arg1_121, function()
		if arg0_121:isfrozen() then
			return
		end

		local var0_122 = arg0_121.contextData.mapIdx + arg2_121
		local var1_122 = getProxy(ChapterProxy):getMapById(var0_122)

		if not var1_122 then
			return
		end

		if var1_122:getMapType() == Map.ELITE and not var1_122:isEliteEnabled() then
			var1_122 = var1_122:getBindMap()
			var0_122 = var1_122.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_122, var3_122 = var1_122:isUnlock()

		if arg2_121 > 0 and not var2_122 then
			pg.TipsMgr.GetInstance():ShowTips(var3_122)

			return
		end

		arg0_121:setMap(var0_122)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_123, arg1_123, arg2_123)
	seriesAsync({
		function(arg0_124)
			if arg0_123.contextData.entranceStatus then
				arg0_123:frozen()

				arg0_123.nextPreloadMap = arg1_123

				arg0_123:PreloadLevelMainUI(arg1_123, function()
					arg0_123:unfrozen()

					if arg0_123.nextPreloadMap ~= arg1_123 then
						return
					end

					arg0_123:ShowEntranceUI(false)
					arg0_123:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_123)
					arg0_124()
				end)
			else
				arg0_123:setMap(arg1_123)
				arg0_124()
			end
		end
	}, arg2_123)
end

function var0_0.setMap(arg0_126, arg1_126)
	local var0_126 = arg0_126.contextData.mapIdx

	arg0_126.contextData.mapIdx = arg1_126
	arg0_126.contextData.map = getProxy(ChapterProxy):getMapById(arg1_126)

	assert(arg0_126.contextData.map, "map cannot be nil " .. arg1_126)

	if arg0_126.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_126.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_126.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_126.contextData.map.remasterId, arg1_126)
		PlayerPrefs.Save()
	end

	arg0_126:RecordLastMapOnExit()
	arg0_126:updateMap(var0_126)
	arg0_126:tryPlayMapStory()
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

function var0_0.SwitchMapBuilder(arg0_127, arg1_127)
	if arg0_127.mapBuilder and arg0_127.mapBuilder:GetType() ~= arg1_127 then
		arg0_127.mapBuilder.buffer:Hide()
	end

	local var0_127 = arg0_127:GetMapBuilderInBuffer(arg1_127)

	arg0_127.mapBuilder = var0_127

	var0_127.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_128, arg1_128)
	if not arg0_128.mbDict[arg1_128] then
		local var0_128 = _G[var6_0[arg1_128]]

		assert(var0_128, "Missing MapBuilder of type " .. (arg1_128 or "NIL"))

		arg0_128.mbDict[arg1_128] = var0_128.New(arg0_128._tf, arg0_128)
		arg0_128.mbDict[arg1_128].isFrozen = arg0_128:isfrozen()

		arg0_128.mbDict[arg1_128]:Load()
	end

	return arg0_128.mbDict[arg1_128]
end

function var0_0.updateMap(arg0_129, arg1_129)
	local var0_129 = arg0_129.contextData.map
	local var1_129 = var0_129:getConfig("anchor")
	local var2_129

	if var1_129 == "" then
		var2_129 = Vector2(0.5, 0.5)
	else
		var2_129 = Vector2(unpack(var1_129))
	end

	arg0_129.map.pivot = var2_129

	local var3_129 = var0_129:getConfig("uifx")

	for iter0_129 = 1, arg0_129.UIFXList.childCount do
		local var4_129 = arg0_129.UIFXList:GetChild(iter0_129 - 1)

		setActive(var4_129, var4_129.name == var3_129)
	end

	arg0_129:SwitchMapBG(var0_129, arg1_129)
	arg0_129:PlayBGM()

	local var5_129 = arg0_129.contextData.map:getConfig("ui_type")

	arg0_129:SwitchMapBuilder(var5_129)
	seriesAsync({
		function(arg0_130)
			arg0_129.mapBuilder:CallbackInvoke(arg0_130)
		end,
		function(arg0_131)
			arg0_129.mapBuilder:UpdateMapVO(var0_129)
			arg0_129.mapBuilder:UpdateView()
			arg0_129.mapBuilder:UpdateMapItems()
			arg0_129.mapBuilder:PlayEnterAnim()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_132)
	local var0_132 = arg0_132.contextData.map
	local var1_132 = getProxy(ChapterProxy)
	local var2_132 = var1_132:getMapById(var0_132.id - 1)
	local var3_132 = var1_132:getMapById(var0_132.id + 1)

	setActive(arg0_132.btnPrev, tobool(var2_132))
	setActive(arg0_132.btnNext, tobool(var3_132))

	local var4_132 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_132.btnPrevCol, var2_132 and Color.white or var4_132)
	setImageColor(arg0_132.btnNextCol, var3_132 and var3_132:isUnlock() and Color.white or var4_132)
end

function var0_0.tryPlayMapStory(arg0_133)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_134)
			local var0_134 = arg0_133.contextData.map:getConfig("enter_story")

			if var0_134 and var0_134 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_134) and not arg0_133.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_134 = tonumber(var0_134)

				if var1_134 and var1_134 > 0 then
					arg0_133:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_134)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_134, arg0_134)
				end

				return
			end

			arg0_134()
		end,
		function(arg0_135)
			local var0_135 = arg0_133.contextData.map:getConfig("guide_id")

			if var0_135 and var0_135 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_135, nil, arg0_135)

				return
			end

			arg0_135()
		end,
		function(arg0_136)
			if isActive(arg0_133.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_136 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_136

				if var0_136 then
					var1_136 = {
						1,
						2
					}
				else
					var1_136 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_136)
			else
				arg0_136()
			end
		end,
		function(arg0_137)
			if arg0_133.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_133.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_138, arg1_138, arg2_138, arg3_138)
	arg0_138.uiAnims = arg0_138.uiAnims or {}

	local var0_138 = arg0_138.uiAnims[arg1_138]

	local function var1_138()
		arg0_138.playing = true

		arg0_138:frozen()
		var0_138:SetActive(true)

		local var0_139 = tf(var0_138)

		pg.UIMgr.GetInstance():OverlayPanel(var0_139)

		if arg3_138 then
			arg3_138(var0_138)
		end

		var0_139:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_140)
			arg0_138.playing = false

			if arg2_138 then
				arg2_138(var0_138)
			end

			arg0_138:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_138 then
		PoolMgr.GetInstance():GetUI(arg1_138, true, function(arg0_141)
			arg0_141:SetActive(true)

			arg0_138.uiAnims[arg1_138] = arg0_141
			var0_138 = arg0_138.uiAnims[arg1_138]

			var1_138()
		end)
	else
		var1_138()
	end
end

function var0_0.displaySpResult(arg0_142, arg1_142, arg2_142)
	setActive(arg0_142.spResult, true)
	arg0_142:DisplaySPAnim(arg1_142 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_143)
		onButton(arg0_142, arg0_143, function()
			removeOnButton(arg0_143)
			setActive(arg0_143, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_143, arg0_142._tf)
			arg0_142:hideSpResult()
			arg2_142()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_145)
	setActive(arg0_145.spResult, false)
end

function var0_0.displayBombResult(arg0_146, arg1_146)
	setActive(arg0_146.spResult, true)
	arg0_146:DisplaySPAnim("SpBombRet", function(arg0_147)
		onButton(arg0_146, arg0_147, function()
			removeOnButton(arg0_147)
			setActive(arg0_147, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_147, arg0_146._tf)
			arg0_146:hideSpResult()
			arg1_146()
		end, SFX_PANEL)
	end, function(arg0_149)
		setText(arg0_149.transform:Find("right/name_bg/en"), arg0_146.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_150, arg1_150, arg2_150)
	arg0_150.contextData.chapterLoopFlag = arg2_150

	local var0_150 = getProxy(ChapterProxy):getChapterById(arg1_150, true)

	if var0_150:getConfig("type") == Chapter.CustomFleet then
		arg0_150:displayFleetEdit(var0_150)

		return
	end

	if #var0_150:getNpcShipByType(1) > 0 then
		arg0_150:emit(LevelMediator2.ON_TRACKING, arg1_150)

		return
	end

	arg0_150:displayFleetSelect(var0_150)
end

function var0_0.DisplayLevelInfoPanel(arg0_151, arg1_151, arg2_151)
	seriesAsync({
		function(arg0_152)
			if not arg0_151.levelInfoView:GetLoaded() then
				arg0_151:frozen()
				arg0_151.levelInfoView:Load()
				arg0_151.levelInfoView:CallbackInvoke(function()
					arg0_151:unfrozen()
					arg0_152()
				end)

				return
			end

			arg0_152()
		end,
		function(arg0_154)
			local function var0_154(arg0_155, arg1_155)
				arg0_151:hideChapterPanel()
				arg0_151:OnLevelInfoPanelConfirm(arg0_155, arg1_155)
			end

			local function var1_154()
				arg0_151:hideChapterPanel()
			end

			local var2_154 = getProxy(ChapterProxy):getChapterById(arg1_151, true)

			if getProxy(ChapterProxy):getMapById(var2_154:getConfig("map")):isSkirmish() and #var2_154:getNpcShipByType(1) > 0 then
				var0_154(false)

				return
			end

			arg0_151.levelInfoView:set(arg1_151, arg2_151)
			arg0_151.levelInfoView:setCBFunc(var0_154, var1_154)
			arg0_151.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_157)
	if arg0_157.levelInfoView:isShowing() then
		arg0_157.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_158)
	arg0_158.levelInfoView:Destroy()

	arg0_158.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_159, arg1_159, arg2_159, arg3_159)
	seriesAsync({
		function(arg0_160)
			if not arg0_159.levelInfoSPView then
				arg0_159.levelInfoSPView = LevelInfoSPView.New(arg0_159.topPanel, arg0_159.event, arg0_159.contextData)

				arg0_159.levelInfoSPView:RegisterView(arg0_159)
				arg0_159:frozen()
				arg0_159.levelInfoSPView:Load()
				arg0_159.levelInfoSPView:CallbackInvoke(function()
					arg0_159:unfrozen()
					arg0_160()
				end)

				return
			end

			arg0_160()
		end,
		function(arg0_162)
			local function var0_162(arg0_163, arg1_163)
				arg0_159:HideLevelInfoSPPanel()
				arg0_159:OnLevelInfoPanelConfirm(arg0_163, arg1_163)
			end

			local function var1_162()
				arg0_159:HideLevelInfoSPPanel()
			end

			arg0_159.levelInfoSPView:SetChapterGroupInfo(arg2_159)
			arg0_159.levelInfoSPView:set(arg1_159, arg3_159)
			arg0_159.levelInfoSPView:setCBFunc(var0_162, var1_162)
			arg0_159.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_165)
	if arg0_165.levelInfoSPView and arg0_165.levelInfoSPView:isShowing() then
		arg0_165.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_166)
	if not arg0_166.levelInfoSPView then
		return
	end

	arg0_166.levelInfoSPView:Destroy()

	arg0_166.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_167, arg1_167)
	local var0_167 = arg0_167.contextData.selectedFleetIDs or arg1_167:GetDefaultFleetIndex()

	arg1_167 = Clone(arg1_167)
	arg1_167.loopFlag = arg0_167.contextData.chapterLoopFlag

	arg0_167.levelFleetView:updateSpecialOperationTickets(arg0_167.spTickets)
	arg0_167.levelFleetView:Load()
	arg0_167.levelFleetView:ActionInvoke("setHardShipVOs", arg0_167.shipVOs)
	arg0_167.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_167.openedCommanerSystem)
	arg0_167.levelFleetView:ActionInvoke("set", arg1_167, arg0_167.fleets, var0_167)
	arg0_167.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_168)
	if arg0_168.levelCMDFormationView:isShowing() then
		arg0_168.levelCMDFormationView:Hide()
	end

	if arg0_168.levelFleetView then
		arg0_168.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_169)
	arg0_169.levelCMDFormationView = LevelCMDFormationView.New(arg0_169.topPanel, arg0_169.event, arg0_169.contextData)
end

function var0_0.destroyFleetSelect(arg0_170)
	if not arg0_170.levelFleetView then
		return
	end

	arg0_170.levelFleetView:Destroy()

	arg0_170.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_171, arg1_171)
	arg1_171 = Clone(arg1_171)
	arg1_171.loopFlag = arg0_171.contextData.chapterLoopFlag

	arg0_171.levelFleetView:updateSpecialOperationTickets(arg0_171.spTickets)
	arg0_171.levelFleetView:Load()
	arg0_171.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_171.openedCommanerSystem)
	arg0_171.levelFleetView:ActionInvoke("setHardShipVOs", arg0_171.shipVOs)
	arg0_171.levelFleetView:ActionInvoke("setOnHard", arg1_171)
	arg0_171.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_172)
	arg0_172:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_173)
	arg0_173:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_174, arg1_174)
	if not arg0_174.levelFleetView then
		return
	end

	assert(arg0_174.levelFleetView:GetLoaded())

	local var0_174 = arg0_174.levelFleetView:IsSelectMode()
	local var1_174

	if var0_174 then
		arg0_174.levelFleetView:ActionInvoke("set", arg1_174 or arg0_174.levelFleetView.chapter, arg0_174.fleets, arg0_174.levelFleetView:getSelectIds())

		if arg0_174.levelCMDFormationView:isShowing() then
			local var2_174 = arg0_174.levelCMDFormationView.fleet.id

			var1_174 = arg0_174.fleets[var2_174]
		end
	else
		arg0_174.levelFleetView:ActionInvoke("setOnHard", arg1_174 or arg0_174.levelFleetView.chapter)

		if arg0_174.levelCMDFormationView:isShowing() then
			local var3_174 = arg0_174.levelCMDFormationView.fleet.id

			var1_174 = arg1_174:wrapEliteFleet(var3_174)
		end
	end

	if var1_174 then
		arg0_174.levelCMDFormationView:ActionInvoke("updateFleet", var1_174)
	end
end

function var0_0.setChapter(arg0_175, arg1_175)
	local var0_175

	if arg1_175 then
		var0_175 = arg1_175.id
	end

	arg0_175.contextData.chapterId = var0_175
	arg0_175.contextData.chapterVO = arg1_175
end

function var0_0.switchToChapter(arg0_176, arg1_176)
	if arg0_176.contextData.mapIdx ~= arg1_176:getConfig("map") then
		arg0_176:setMap(arg1_176:getConfig("map"))
	end

	arg0_176:setChapter(arg1_176)

	arg0_176.leftCanvasGroup.blocksRaycasts = false
	arg0_176.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_176.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_176:DestroyLevelStageView()

	if not arg0_176.levelStageView then
		arg0_176.levelStageView = LevelStageView.New(arg0_176.topPanel, arg0_176.event, arg0_176.contextData)

		arg0_176.levelStageView:Load()

		arg0_176.levelStageView.isFrozen = arg0_176:isfrozen()
	end

	arg0_176:frozen()

	local function var0_176()
		seriesAsync({
			function(arg0_178)
				arg0_176.mapBuilder:CallbackInvoke(arg0_178)
			end,
			function(arg0_179)
				setActive(arg0_176.clouds, false)
				arg0_176.mapBuilder:HideFloat()
				arg0_176:BlurPanel(arg0_176.topPanel, {
					blurCamList = {
						pg.UIMgr.CameraUI
					}
				})
				arg0_176.levelStageView:updateStageInfo()
				arg0_176.levelStageView:updateAmbushRate(arg1_176.fleet.line, true)
				arg0_176.levelStageView:updateStageAchieve()
				arg0_176.levelStageView:updateStageBarrier()
				arg0_176.levelStageView:updateBombPanel()
				arg0_176.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_179)
			end,
			function(arg0_180)
				if arg0_176.exited then
					return
				end

				arg0_176.levelStageView:updateStageStrategy()

				arg0_176.canvasGroup.blocksRaycasts = arg0_176.frozenCount == 0

				onNextTick(arg0_180)
			end,
			function(arg0_181)
				if arg0_176.exited then
					return
				end

				arg0_176.levelStageView:updateStageFleet()
				arg0_176.levelStageView:updateSupportFleet()
				arg0_176.levelStageView:updateFleetBuff()
				onNextTick(arg0_181)
			end,
			function(arg0_182)
				if arg0_176.exited then
					return
				end

				parallelAsync({
					function(arg0_183)
						local var0_183 = arg1_176:getConfig("scale")
						local var1_183 = LeanTween.value(go(arg0_176.map), arg0_176.map.localScale, Vector3.New(var0_183[3], var0_183[3], 1), var1_0):setOnUpdateVector3(function(arg0_184)
							arg0_176.map.localScale = arg0_184
							arg0_176.float.localScale = arg0_184
						end):setOnComplete(System.Action(function()
							arg0_176.mapBuilder:ShowFloat()
							arg0_176.mapBuilder:Hide()
							arg0_183()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_176:RecordTween("mapScale", var1_183.uniqueId)

						local var2_183 = LeanTween.value(go(arg0_176.map), arg0_176.map.pivot, Vector2.New(math.clamp(var0_183[1] - 0.5, 0, 1), math.clamp(var0_183[2] - 0.5, 0, 1)), var1_0)

						var2_183:setOnUpdateVector2(function(arg0_186)
							arg0_176.map.pivot = arg0_186
							arg0_176.float.pivot = arg0_186
						end):setEase(LeanTweenType.easeOutSine)
						arg0_176:RecordTween("mapPivot", var2_183.uniqueId)
						shiftPanel(arg0_176.leftChapter, -arg0_176.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_176.rightChapter, arg0_176.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_176.topChapter, 0, arg0_176.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_176.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_187)
						arg0_176:PlayBGM()

						local var0_187 = {}
						local var1_187 = arg1_176:getConfig("bg")

						if var1_187 and #var1_187 > 0 then
							var0_187[1] = {
								BG = var1_187
							}
						end

						arg0_176:SwitchBG(var0_187, arg0_187)
					end
				}, function()
					onNextTick(arg0_182)
				end)
			end,
			function(arg0_189)
				if arg0_176.exited then
					return
				end

				setActive(arg0_176.topChapter, false)
				setActive(arg0_176.leftChapter, false)
				setActive(arg0_176.rightChapter, false)

				arg0_176.leftCanvasGroup.blocksRaycasts = true
				arg0_176.rightCanvasGroup.blocksRaycasts = true

				arg0_176:initGrid(arg0_189)
			end,
			function(arg0_190)
				if arg0_176.exited then
					return
				end

				arg0_176.levelStageView:SetGrid(arg0_176.grid)

				arg0_176.contextData.huntingRangeVisibility = arg0_176.contextData.huntingRangeVisibility - 1

				arg0_176.grid:toggleHuntingRange()

				local var0_190 = arg1_176:getConfig("pop_pic")

				if var0_190 and #var0_190 > 0 and arg0_176.FirstEnterChapter == arg1_176.id then
					arg0_176:doPlayAnim(var0_190, function(arg0_191)
						setActive(arg0_191, false)

						if arg0_176.exited then
							return
						end

						arg0_190()
					end)
				else
					arg0_190()
				end
			end,
			function(arg0_192)
				arg0_176.levelStageView:tryAutoAction(arg0_192)
			end,
			function(arg0_193)
				if arg0_176.exited then
					return
				end

				arg0_176:unfrozen()

				if arg0_176.FirstEnterChapter then
					arg0_176:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_176.subAutoAttack)
				end

				arg0_176.FirstEnterChapter = nil

				arg0_193()
			end,
			function(arg0_194)
				if arg1_176:NeedSupportSubmarineStage() then
					arg0_176.levelStageView:TryEnterChapterSupportSubmarineStage(arg0_194)
				else
					arg0_194()
				end
			end
		}, function()
			arg0_176.levelStageView:tryAutoTrigger(true)
		end)
	end

	arg0_176.levelStageView:ActionInvoke("SetSeriesOperation", var0_176)
	arg0_176.levelStageView:ActionInvoke("SetPlayer", arg0_176.player)
	arg0_176.levelStageView:ActionInvoke("SwitchToChapter", arg1_176)
end

function var0_0.switchToMap(arg0_196, arg1_196)
	arg0_196:frozen()
	arg0_196:destroyGrid()
	arg0_196:setChapter(nil)
	LeanTween.cancel(go(arg0_196.map))

	local var0_196 = LeanTween.value(go(arg0_196.map), arg0_196.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_197)
		arg0_196.map.localScale = arg0_197
		arg0_196.float.localScale = arg0_197
	end):setOnComplete(System.Action(function()
		arg0_196:unfrozen()
		arg0_196.mapBuilder:PlayEnterAnim()
		existCall(arg1_196)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_196:RecordTween("mapScale", var0_196.uniqueId)

	local var1_196 = arg0_196.contextData.map:getConfig("anchor")
	local var2_196

	if var1_196 == "" then
		var2_196 = Vector2(0.5, 0.5)
	else
		var2_196 = Vector2(unpack(var1_196))
	end

	local var3_196 = LeanTween.value(go(arg0_196.map), arg0_196.map.pivot, var2_196, var1_0)

	var3_196:setOnUpdateVector2(function(arg0_199)
		arg0_196.map.pivot = arg0_199
		arg0_196.float.pivot = arg0_199
	end):setEase(LeanTweenType.easeOutSine)
	arg0_196:RecordTween("mapPivot", var3_196.uniqueId)
	setActive(arg0_196.topChapter, true)
	setActive(arg0_196.leftChapter, true)
	setActive(arg0_196.rightChapter, true)
	shiftPanel(arg0_196.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_196.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_196.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_196.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_196.levelStageView then
		arg0_196.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_196:DestroyLevelStageView()
		end)
		arg0_196.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_196:SwitchMapBG(arg0_196.contextData.map)
	arg0_196:PlayBGM()
	seriesAsync({
		function(arg0_201)
			arg0_196.mapBuilder:CallbackInvoke(arg0_201)
		end,
		function(arg0_202)
			arg0_196.mapBuilder:Show()
			arg0_196.mapBuilder:UpdateView()
			arg0_196.mapBuilder:UpdateMapItems()
		end
	})
	arg0_196:UnOverlayPanel(arg0_196.topPanel, arg0_196._tf)

	arg0_196.canvasGroup.blocksRaycasts = arg0_196.frozenCount == 0
	arg0_196.canvasGroup.interactable = true

	if arg0_196.ambushWarning and arg0_196.ambushWarning.activeSelf then
		arg0_196.ambushWarning:SetActive(false)
		arg0_196:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_203, arg1_203, arg2_203, arg3_203)
	if not arg1_203 or #arg1_203 <= 0 then
		existCall(arg2_203)

		return
	elseif arg3_203 then
		-- block empty
	elseif table.equal(arg0_203.currentBG, arg1_203) then
		return
	end

	arg0_203.currentBG = arg1_203

	for iter0_203, iter1_203 in ipairs(arg0_203.mapGroup) do
		arg0_203.loader:ClearRequest(iter1_203)
	end

	table.clear(arg0_203.mapGroup)

	local var0_203 = {}

	table.ParallelIpairsAsync(arg1_203, function(arg0_204, arg1_204, arg2_204)
		local var0_204 = arg0_203.mapTFs[arg0_204]
		local var1_204 = arg1_204.bgPrefix and arg1_204.bgPrefix .. "/" or "levelmap/"
		local var2_204 = arg0_203.loader:GetSpriteDirect(var1_204 .. arg1_204.BG, "", function(arg0_205)
			var0_203[arg0_204] = arg0_205

			arg2_204()
		end, var0_204)

		table.insert(arg0_203.mapGroup, var2_204)
		arg0_203:updateCouldAnimator(arg1_204.Animator, arg0_204)
	end, function()
		for iter0_206, iter1_206 in ipairs(arg0_203.mapTFs) do
			setImageSprite(iter1_206, var0_203[iter0_206])
			setActive(iter1_206, arg1_203[iter0_206])
			SetCompomentEnabled(iter1_206, typeof(Image), true)
		end

		existCall(arg2_203)
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

function var0_0.ClearMapTransitions(arg0_207)
	if not arg0_207.mapTransitions then
		return
	end

	for iter0_207, iter1_207 in pairs(arg0_207.mapTransitions) do
		if iter1_207 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_207, iter0_207, iter1_207, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_207, iter0_207)
		end
	end

	arg0_207.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_208, arg1_208, arg2_208, arg3_208)
	local var0_208, var1_208, var2_208 = arg0_208:GetMapBG(arg1_208, arg2_208)
	local var3_208 = {}

	if var1_208 then
		table.insert(var3_208, function(arg0_209)
			arg0_208:PlayMapTransition("LevelMapTransition_" .. var1_208, var2_208, arg0_209)
		end)
	end

	seriesAsync(var3_208, function()
		arg0_208:SwitchBGMapType(arg1_208:getConfig("pos_type"))
		arg0_208:SwitchBG(var0_208, nil, arg3_208)
	end)
end

function var0_0.SwitchBGMapType(arg0_211, arg1_211)
	if arg0_211.posType == arg1_211 then
		return
	end

	for iter0_211, iter1_211 in ipairs({
		arg0_211.map,
		arg0_211.float
	}) do
		local var0_211 = GetOrAddComponent(iter1_211, typeof(AspectRatioFitter))

		var0_211.aspectRatio = 1.77777777777778
		var0_211.enabled = arg1_211 == 0

		if arg1_211 == 1 then
			iter1_211.anchorMin = Vector2(0.5, 0.5)
			iter1_211.anchorMax = Vector2(0.5, 0.5)

			setSizeDelta(var0_211, {
				x = 2520,
				y = 1440
			})
		end
	end
end

function var0_0.GetMapBG(arg0_212, arg1_212, arg2_212)
	if not table.contains(var7_0, arg1_212.id) then
		return {
			arg0_212:GetMapElement(arg1_212)
		}
	end

	local var0_212 = arg1_212.id
	local var1_212 = table.indexof(var7_0, var0_212) - 1
	local var2_212 = bit.lshift(bit.rshift(var1_212, 1), 1) + 1
	local var3_212 = {
		var7_0[var2_212],
		var7_0[var2_212 + 1]
	}
	local var4_212 = _.map(var3_212, function(arg0_213)
		return getProxy(ChapterProxy):getMapById(arg0_213)
	end)

	if _.all(var4_212, function(arg0_214)
		return arg0_214:isAllChaptersClear()
	end) then
		local var5_212 = {
			arg0_212:GetMapElement(arg1_212)
		}

		if not arg2_212 or math.abs(var0_212 - arg2_212) ~= 1 then
			return var5_212
		end

		local var6_212 = var9_0[bit.rshift(var2_212 - 1, 1) + 1]
		local var7_212 = bit.band(var1_212, 1) == 1

		return var5_212, var6_212, var7_212
	else
		local var8_212 = 0

		;(function()
			local var0_215 = var4_212[1]:getChapters()

			for iter0_215, iter1_215 in ipairs(var0_215) do
				if not iter1_215:isClear() then
					return
				end

				var8_212 = var8_212 + 1
			end

			if not var4_212[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_212 = var8_212 + 1

			local var1_215 = var4_212[2]:getChapters()

			for iter2_215, iter3_215 in ipairs(var1_215) do
				if not iter3_215:isClear() then
					return
				end

				var8_212 = var8_212 + 1
			end
		end)()

		local var9_212

		if var8_212 > 0 then
			local var10_212 = var8_0[bit.rshift(var2_212 - 1, 1) + 1]

			var9_212 = {
				{
					BG = "map_" .. var10_212[1],
					Animator = var10_212[2]
				},
				{
					BG = "map_" .. var10_212[3] + var8_212,
					Animator = var10_212[4]
				}
			}
		else
			var9_212 = {
				arg0_212:GetMapElement(arg1_212)
			}
		end

		return var9_212
	end
end

function var0_0.GetMapElement(arg0_216, arg1_216)
	local var0_216 = arg1_216:getConfig("bg")
	local var1_216 = arg1_216:getConfig("ani_controller")

	if var1_216 and #var1_216 > 0 then
		(function()
			local var0_217 = getProxy(ChapterProxy)

			for iter0_217, iter1_217 in ipairs(var1_216) do
				local var1_217 = _.rest(iter1_217[2], 2)

				for iter2_217, iter3_217 in ipairs(var1_217) do
					if string.find(iter3_217, "^map_") and iter1_217[1] == var3_0 then
						local var2_217 = iter1_217[2][1]
						local var3_217 = false

						for iter4_217, iter5_217 in ipairs(var2_217) do
							local var4_217 = var0_217:GetChapterItemById(iter5_217)

							if var4_217 and var4_217:isClear() then
								var3_217 = true

								break
							end
						end

						if not var3_217 then
							var0_216 = iter3_217

							return
						end
					end
				end
			end
		end)()
	end

	local var2_216 = {
		BG = var0_216
	}

	var2_216.Animator, var2_216.AnimatorController = arg0_216:GetMapAnimator(arg1_216)

	return var2_216
end

function var0_0.GetMapAnimator(arg0_218, arg1_218)
	local var0_218 = arg1_218:getConfig("ani_name")

	if arg1_218:getConfig("animtor") == 1 and var0_218 and #var0_218 > 0 then
		local var1_218 = arg1_218:getConfig("ani_controller")

		if var1_218 and #var1_218 > 0 then
			(function()
				local var0_219 = getProxy(ChapterProxy)

				for iter0_219, iter1_219 in ipairs(var1_218) do
					local var1_219 = _.rest(iter1_219[2], 2)

					for iter2_219, iter3_219 in ipairs(var1_219) do
						if string.find(iter3_219, "^effect_") and iter1_219[1] == var3_0 then
							local var2_219 = iter1_219[2][1]
							local var3_219 = false

							for iter4_219, iter5_219 in ipairs(var2_219) do
								local var4_219 = var0_219:GetChapterItemById(iter5_219)

								if var4_219 and var4_219:isClear() then
									var3_219 = true

									break
								end
							end

							if not var3_219 then
								var0_218 = "map_" .. string.sub(iter3_219, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_218, var1_218
	end
end

function var0_0.PlayMapTransition(arg0_220, arg1_220, arg2_220, arg3_220, arg4_220)
	arg0_220.mapTransitions = arg0_220.mapTransitions or {}

	local var0_220

	local function var1_220()
		arg0_220:frozen()
		existCall(arg3_220, var0_220)
		var0_220:SetActive(true)

		local var0_221 = tf(var0_220)

		pg.UIMgr.GetInstance():OverlayPanel(var0_221)
		var0_220:GetComponent(typeof(Animator)):Play(arg2_220 and "Sequence" or "Inverted", -1, 0)
		var0_221:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_222)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_221, arg0_220._tf)
			existCall(arg4_220, var0_220)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_220, arg1_220, var0_220)

			arg0_220.mapTransitions[arg1_220] = false

			arg0_220:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_220, arg1_220, true, function(arg0_223)
		var0_220 = arg0_223
		arg0_220.mapTransitions[arg1_220] = arg0_223

		var1_220()
	end)
end

function var0_0.DestroyLevelStageView(arg0_224)
	if arg0_224.levelStageView then
		arg0_224.levelStageView:Destroy()

		arg0_224.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_225, arg1_225)
	arg0_225.levelAmbushView = LevelAmbushView.New(arg0_225.topPanel, arg0_225.event, arg0_225.contextData)

	arg0_225.levelAmbushView:Load()
	arg0_225.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_225)
end

function var0_0.hideAmbushInfo(arg0_226)
	if arg0_226.levelAmbushView then
		arg0_226.levelAmbushView:Destroy()

		arg0_226.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_227, arg1_227)
	arg0_227:frozen()

	local function var0_227()
		arg0_227.ambushWarning:SetActive(true)

		local var0_228 = tf(arg0_227.ambushWarning)

		var0_228:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_228:SetSiblingIndex(1)

		local var1_228 = var0_228:GetComponent("DftAniEvent")

		var1_228:SetTriggerEvent(function(arg0_229)
			arg1_227()
		end)
		var1_228:SetEndEvent(function(arg0_230)
			arg0_227.ambushWarning:SetActive(false)
			arg0_227:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_227.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_232)
			arg0_232:SetActive(true)

			arg0_227.ambushWarning = arg0_232

			var0_227()
		end)
	else
		var0_227()
	end
end

function var0_0.destroyAmbushWarn(arg0_233)
	if arg0_233.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_233.ambushWarning)

		arg0_233.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_234, arg1_234)
	arg0_234.levelStrategyView = LevelStrategyView.New(arg0_234.topPanel, arg0_234.event, arg0_234.contextData)

	arg0_234.levelStrategyView:Load()
	arg0_234.levelStrategyView:ActionInvoke("set", arg1_234)

	local function var0_234()
		local var0_235 = arg0_234.contextData.chapterVO.fleet
		local var1_235 = pg.strategy_data_template[arg1_234.id]

		if not var0_235:canUseStrategy(arg1_234) then
			return
		end

		local var2_235 = var0_235:getNextStgUser(arg1_234.id)

		if var1_235.type == ChapterConst.StgTypeForm then
			arg0_234:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_235,
				arg1 = arg1_234.id
			})
		elseif var1_235.type == ChapterConst.StgTypeConsume then
			arg0_234:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_235,
				arg1 = arg1_234.id
			})
		end

		arg0_234:hideStrategyInfo()
	end

	local function var1_234()
		arg0_234:hideStrategyInfo()
	end

	arg0_234.levelStrategyView:ActionInvoke("setCBFunc", var0_234, var1_234)
end

function var0_0.hideStrategyInfo(arg0_237)
	if arg0_237.levelStrategyView then
		arg0_237.levelStrategyView:Destroy()

		arg0_237.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_238, arg1_238)
	local var0_238 = arg0_238.contextData.chapterVO
	local var1_238 = getProxy(ChapterProxy)
	local var2_238
	local var3_238
	local var4_238
	local var5_238
	local var6_238 = var1_238.repairTimes
	local var7_238, var8_238, var9_238 = ChapterConst.GetRepairParams()

	arg0_238.levelRepairView = LevelRepairView.New(arg0_238.topPanel, arg0_238.event, arg0_238.contextData)

	arg0_238.levelRepairView:Load()
	arg0_238.levelRepairView:ActionInvoke("set", var6_238, var7_238, var8_238, var9_238)

	local function var10_238()
		if var7_238 - math.min(var6_238, var7_238) == 0 and arg0_238.player:getTotalGem() < var9_238 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_238:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_238.fleet.id,
			arg1 = arg1_238.id
		})
		arg0_238:hideRepairWindow()
	end

	local function var11_238()
		arg0_238:hideRepairWindow()
	end

	arg0_238.levelRepairView:ActionInvoke("setCBFunc", var10_238, var11_238)
end

function var0_0.hideRepairWindow(arg0_241)
	if arg0_241.levelRepairView then
		arg0_241.levelRepairView:Destroy()

		arg0_241.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_242, arg1_242)
	arg0_242.levelRemasterView:Load()

	local function var0_242(arg0_243)
		arg0_242:ShowSelectedMap(arg0_243)
	end

	arg0_242.levelRemasterView:ActionInvoke("Show")
	arg0_242.levelRemasterView:ActionInvoke("set", var0_242, arg1_242)
end

function var0_0.hideRemasterPanel(arg0_244)
	if arg0_244.levelRemasterView:isShowing() then
		arg0_244.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_245, arg1_245)
	local var0_245 = arg0_245.contextData.chapterVO

	if not var0_245 then
		return
	end

	arg0_245:enableLevelCamera()
	setActive(arg0_245.uiMain, true)

	arg0_245.levelGrid.localEulerAngles = Vector3(var0_245.theme.angle, 0, 0)
	arg0_245.grid = LevelGrid.New(arg0_245.dragLayer)

	arg0_245.grid:attach(arg0_245)
	arg0_245.grid:ExtendItem("shipTpl", arg0_245.shipTpl)
	arg0_245.grid:ExtendItem("subTpl", arg0_245.subTpl)
	arg0_245.grid:ExtendItem("transportTpl", arg0_245.transportTpl)
	arg0_245.grid:ExtendItem("enemyTpl", arg0_245.enemyTpl)
	arg0_245.grid:ExtendItem("championTpl", arg0_245.championTpl)
	arg0_245.grid:ExtendItem("oniTpl", arg0_245.oniTpl)
	arg0_245.grid:ExtendItem("arrowTpl", arg0_245.arrowTarget)
	arg0_245.grid:ExtendItem("destinationMarkTpl", arg0_245.destinationMarkTpl)

	function arg0_245.grid.onShipStepChange(arg0_246)
		arg0_245.levelStageView:updateAmbushRate(arg0_246)
	end

	arg0_245.grid:initAll(arg1_245)
end

function var0_0.destroyGrid(arg0_247)
	if arg0_247.grid then
		arg0_247.grid:detach()

		arg0_247.grid = nil

		arg0_247:disableLevelCamera()
		setActive(arg0_247.dragLayer, true)
		setActive(arg0_247.uiMain, false)
	end
end

function var0_0.doTracking(arg0_248, arg1_248)
	arg0_248:frozen()

	local function var0_248()
		arg0_248.radar:SetActive(true)

		local var0_249 = tf(arg0_248.radar)

		var0_249:SetParent(arg0_248.topPanel, false)
		var0_249:SetSiblingIndex(1)
		var0_249:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_250)
			arg0_248.radar:SetActive(false)
			arg0_248:unfrozen()
			arg1_248()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_248.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_251)
			arg0_251:SetActive(true)

			arg0_248.radar = arg0_251

			var0_248()
		end)
	else
		var0_248()
	end
end

function var0_0.destroyTracking(arg0_252)
	if arg0_252.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_252.radar)

		arg0_252.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_253, arg1_253, arg2_253, arg3_253)
	local function var0_253()
		arg0_253.playing = true

		arg0_253:frozen()
		arg0_253.airStrike:SetActive(true)

		local var0_254 = tf(arg0_253.airStrike)

		var0_254:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_254:SetAsLastSibling()
		setActive(var0_254:Find("words/be_striked"), arg1_253 == ChapterConst.SubjectChampion)
		setActive(var0_254:Find("words/strike_enemy"), arg1_253 == ChapterConst.SubjectPlayer)

		local function var1_254()
			arg0_253.playing = false

			SetActive(arg0_253.airStrike, false)

			if arg3_253 then
				arg3_253()
			end

			arg0_253:unfrozen()
		end

		var0_254:GetComponent("DftAniEvent"):SetEndEvent(var1_254)

		if arg2_253 then
			onButton(arg0_253, var0_254, var1_254, SFX_PANEL)
		else
			removeOnButton(var0_254)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_253.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_256)
			arg0_256:SetActive(true)

			arg0_253.airStrike = arg0_256

			var0_253()
		end)
	else
		var0_253()
	end
end

function var0_0.destroyAirStrike(arg0_257)
	if arg0_257.airStrike then
		arg0_257.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_257.airStrike)

		arg0_257.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_258, arg1_258, arg2_258, arg3_258)
	arg0_258.uiAnims = arg0_258.uiAnims or {}

	local var0_258 = arg0_258.uiAnims[arg1_258]

	local function var1_258()
		arg0_258.playing = true

		arg0_258:frozen()
		var0_258:SetActive(true)

		local var0_259 = tf(var0_258)

		pg.UIMgr.GetInstance():OverlayPanel(var0_259)

		if arg3_258 then
			arg3_258(var0_258)
		end

		var0_259:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_260)
			arg0_258.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_259, arg0_258._tf)

			if arg2_258 then
				arg2_258(var0_258)
			end

			arg0_258:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_258 then
		PoolMgr.GetInstance():GetUI(arg1_258, true, function(arg0_261)
			arg0_261:SetActive(true)

			arg0_258.uiAnims[arg1_258] = arg0_261
			var0_258 = arg0_258.uiAnims[arg1_258]

			var1_258()
		end)
	else
		var1_258()
	end
end

function var0_0.destroyUIAnims(arg0_262)
	if arg0_262.uiAnims then
		for iter0_262, iter1_262 in pairs(arg0_262.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_262), arg0_262._tf)
			iter1_262:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_262, iter1_262)
		end

		arg0_262.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_263, arg1_263)
	local function var0_263()
		arg0_263.playing = true

		arg0_263:frozen()
		arg0_263.torpetoAni:SetActive(true)

		local var0_264 = tf(arg0_263.torpetoAni)

		var0_264:SetParent(arg0_263.topPanel, false)
		var0_264:SetAsLastSibling()
		var0_264:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_265)
			arg0_263.playing = false

			SetActive(arg0_263.torpetoAni, false)

			if arg1_263 then
				arg1_263()
			end

			arg0_263:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_263.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_266)
			arg0_266:SetActive(true)

			arg0_263.torpetoAni = arg0_266

			var0_263()
		end)
	else
		var0_263()
	end
end

function var0_0.destroyTorpedo(arg0_267)
	if arg0_267.torpetoAni then
		arg0_267.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_267.torpetoAni)

		arg0_267.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_268, arg1_268, arg2_268, arg3_268)
	arg0_268.strikeAnims = arg0_268.strikeAnims or {}

	local var0_268
	local var1_268
	local var2_268

	local function var3_268()
		if coroutine.status(var2_268) == "suspended" then
			local var0_269, var1_269 = coroutine.resume(var2_268)

			assert(var0_269, debug.traceback(var2_268, var1_269))
		end
	end

	var2_268 = coroutine.create(function()
		arg0_268.playing = true

		arg0_268:frozen()

		local var0_270 = arg0_268.strikeAnims[arg2_268]

		setActive(var0_270, true)

		local var1_270 = tf(var0_270)
		local var2_270 = findTF(var1_270, "torpedo")
		local var3_270 = findTF(var1_270, "mask/painting")
		local var4_270 = findTF(var1_270, "ship")

		setParent(var0_268, var3_270:Find("fitter"), false)
		var1_268:SetParent(var4_270)
		setActive(var4_270, false)
		setActive(var2_270, false)
		var1_270:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_270:SetAsLastSibling()

		local var5_270 = var1_270:GetComponent("DftAniEvent")
		local var6_270 = var1_268:GetSkeletonGraphic()

		var5_270:SetStartEvent(function(arg0_271)
			var1_268:SetAction("attack", 0)

			var6_270.freeze = true
		end)
		var5_270:SetTriggerEvent(function(arg0_272)
			var6_270.freeze = false

			var1_268:SetActionCallBack(function(arg0_273)
				if arg0_273 == "action" then
					-- block empty
				elseif arg0_273 == "finish" then
					var6_270.freeze = true
				end
			end)
		end)
		var5_270:SetEndEvent(function(arg0_274)
			var6_270.freeze = false

			var3_268()
		end)
		onButton(arg0_268, var1_270, var3_268, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_270, arg1_268:getPainting())
		var1_268:SetActionCallBack(nil)

		var6_270.freeze = false

		var1_268:Dispose()
		setActive(var0_270, false)

		arg0_268.playing = false

		arg0_268:unfrozen()

		if arg3_268 then
			arg3_268()
		end
	end)

	local function var4_268()
		if arg0_268.strikeAnims[arg2_268] and var0_268 and var1_268 then
			var3_268()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_268:getPainting(), true, function(arg0_276)
		var0_268 = arg0_276

		ShipExpressionHelper.SetExpression(var0_268, arg1_268:getPainting())
		var4_268()
	end)

	var1_268 = SpineAnimChar.New()

	var1_268:SetPaint(arg1_268:getPrefab())
	var1_268:Load(true, function(arg0_277)
		var1_268:SetLocalScale(Vector3.one)
		var4_268()
	end)

	if not arg0_268.strikeAnims[arg2_268] then
		PoolMgr.GetInstance():GetUI(arg2_268, true, function(arg0_278)
			arg0_268.strikeAnims[arg2_268] = arg0_278

			var4_268()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_279)
	if arg0_279.strikeAnims then
		for iter0_279, iter1_279 in pairs(arg0_279.strikeAnims) do
			iter1_279:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_279, iter1_279)
		end

		arg0_279.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_280, arg1_280, arg2_280, arg3_280)
	arg0_280.strikeAnims = arg0_280.strikeAnims or {}

	local var0_280
	local var1_280

	local function var2_280()
		if coroutine.status(var1_280) == "suspended" then
			local var0_281, var1_281 = coroutine.resume(var1_280)

			assert(var0_281, debug.traceback(var1_280, var1_281))
		end
	end

	var1_280 = coroutine.create(function()
		arg0_280.playing = true

		arg0_280:frozen()

		local var0_282 = arg0_280.strikeAnims[arg2_280]

		setActive(var0_282, true)

		local var1_282 = tf(var0_282)
		local var2_282 = findTF(var1_282, "torpedo")
		local var3_282 = findTF(var1_282, "ship")

		var0_280:SetParent(var3_282)
		setActive(var3_282, false)
		setActive(var2_282, false)
		var1_282:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_282:SetAsLastSibling()

		local var4_282 = var1_282:GetComponent("DftAniEvent")
		local var5_282 = var0_280:GetSkeletonGraphic()

		var4_282:SetStartEvent(function(arg0_283)
			var0_280:SetAction("attack", 0)

			var5_282.freeze = true
		end)
		var4_282:SetTriggerEvent(function(arg0_284)
			var5_282.freeze = false

			var0_280:SetActionCallBack(function(arg0_285)
				if arg0_285 == "action" then
					-- block empty
				elseif arg0_285 == "finish" then
					var5_282.freeze = true
				end
			end)
		end)
		var4_282:SetEndEvent(function(arg0_286)
			var5_282.freeze = false

			var2_280()
		end)
		onButton(arg0_280, var1_282, var2_280, SFX_CANCEL)
		coroutine.yield()
		var0_280:SetActionCallBack(nil)

		var5_282.freeze = false

		var0_280:Dispose()
		setActive(var0_282, false)

		arg0_280.playing = false

		arg0_280:unfrozen()

		if arg3_280 then
			arg3_280()
		end
	end)

	local function var3_280()
		if arg0_280.strikeAnims[arg2_280] and var0_280 then
			var2_280()
		end
	end

	var0_280 = SpineAnimChar.New()

	var0_280:SetPaint(arg1_280:getPrefab())
	var0_280:Load(true, function(arg0_288)
		arg0_288:SetLocalScale(Vector3.one)
		var3_280()
	end)

	if not arg0_280.strikeAnims[arg2_280] then
		PoolMgr.GetInstance():GetUI(arg2_280, true, function(arg0_289)
			arg0_280.strikeAnims[arg2_280] = arg0_289

			var3_280()
		end)
	end
end

function var0_0.doPlayCommander(arg0_290, arg1_290, arg2_290)
	arg0_290:frozen()
	setActive(arg0_290.commanderTinkle, true)

	local var0_290 = arg1_290:getSkills()

	setText(arg0_290.commanderTinkle:Find("name"), #var0_290 > 0 and var0_290[1]:getConfig("name") or "")
	setImageSprite(arg0_290.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_290:getConfig("painting"), ""))

	local var1_290 = arg0_290.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_290.alpha = 0

	local var2_290 = Vector2(248, 237)

	LeanTween.value(go(arg0_290.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_291)
		local var0_291 = arg0_290.commanderTinkle.localPosition

		var0_291.x = var2_290.x + -100 * (1 - arg0_291)
		arg0_290.commanderTinkle.localPosition = var0_291
		var1_290.alpha = arg0_291
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_290.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_292)
		local var0_292 = arg0_290.commanderTinkle.localPosition

		var0_292.x = var2_290.x + 100 * arg0_292
		arg0_290.commanderTinkle.localPosition = var0_292
		var1_290.alpha = 1 - arg0_292
	end)):setOnComplete(System.Action(function()
		if arg2_290 then
			arg2_290()
		end

		arg0_290:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_294, arg1_294, arg2_294, arg3_294)
	local var0_294 = arg0_294.grid:shakeCell(arg1_294)

	if not var0_294 then
		arg3_294()

		return
	end

	arg0_294:easeDamage(var0_294, arg2_294, function()
		arg3_294()
	end)
end

function var0_0.easeDamage(arg0_296, arg1_296, arg2_296, arg3_296)
	arg0_296:frozen()

	local var0_296 = arg0_296.levelCam:WorldToScreenPoint(arg1_296.position)
	local var1_296 = tf(arg0_296:GetDamageText())

	var1_296.position = arg0_296.uiCam:ScreenToWorldPoint(var0_296)

	local var2_296 = var1_296.localPosition

	var2_296.y = var2_296.y + 40
	var2_296.z = 0

	setText(var1_296, arg2_296)

	var1_296.localPosition = var2_296

	LeanTween.value(go(var1_296), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_297)
		local var0_297 = var1_296.localPosition

		var0_297.y = var2_296.y + 60 * arg0_297
		var1_296.localPosition = var0_297

		setTextAlpha(var1_296, 1 - arg0_297)
	end)):setOnComplete(System.Action(function()
		arg0_296:ReturnDamageText(var1_296)
		arg0_296:unfrozen()

		if arg3_296 then
			arg3_296()
		end
	end))
end

function var0_0.easeAvoid(arg0_299, arg1_299, arg2_299)
	arg0_299:frozen()

	local var0_299 = arg0_299.levelCam:WorldToScreenPoint(arg1_299)

	arg0_299.avoidText.position = arg0_299.uiCam:ScreenToWorldPoint(var0_299)

	local var1_299 = arg0_299.avoidText.localPosition

	var1_299.z = 0
	arg0_299.avoidText.localPosition = var1_299

	setActive(arg0_299.avoidText, true)

	local var2_299 = arg0_299.avoidText:Find("avoid")

	LeanTween.value(go(arg0_299.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_300)
		local var0_300 = arg0_299.avoidText.localPosition

		var0_300.y = var1_299.y + 100 * arg0_300
		arg0_299.avoidText.localPosition = var0_300

		setImageAlpha(arg0_299.avoidText, 1 - arg0_300)
		setImageAlpha(var2_299, 1 - arg0_300)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_299.avoidText, false)
		arg0_299:unfrozen()

		if arg2_299 then
			arg2_299()
		end
	end))
end

function var0_0.GetDamageText(arg0_302)
	local var0_302 = table.remove(arg0_302.damageTextPool)

	if not var0_302 then
		var0_302 = Instantiate(arg0_302.damageTextTemplate)

		local var1_302 = tf(arg0_302.damageTextTemplate):GetSiblingIndex()

		setParent(var0_302, tf(arg0_302.damageTextTemplate).parent)
		tf(var0_302):SetSiblingIndex(var1_302 + 1)
	end

	table.insert(arg0_302.damageTextActive, var0_302)
	setActive(var0_302, true)

	return var0_302
end

function var0_0.ReturnDamageText(arg0_303, arg1_303)
	assert(arg1_303)

	if not arg1_303 then
		return
	end

	arg1_303 = go(arg1_303)

	table.removebyvalue(arg0_303.damageTextActive, arg1_303)
	table.insert(arg0_303.damageTextPool, arg1_303)
	setActive(arg1_303, false)
end

function var0_0.resetLevelGrid(arg0_304)
	arg0_304.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_305, arg1_305)
	setActive(arg0_305.curtain, arg1_305)
end

function var0_0.frozen(arg0_306)
	local var0_306 = arg0_306.frozenCount

	arg0_306.frozenCount = arg0_306.frozenCount + 1
	arg0_306.canvasGroup.blocksRaycasts = arg0_306.frozenCount == 0

	if var0_306 == 0 and arg0_306.frozenCount ~= 0 then
		arg0_306:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_307, arg1_307)
	if arg0_307.exited then
		return
	end

	local var0_307 = arg0_307.frozenCount
	local var1_307 = arg1_307 == -1 and arg0_307.frozenCount or arg1_307 or 1

	arg0_307.frozenCount = arg0_307.frozenCount - var1_307
	arg0_307.canvasGroup.blocksRaycasts = arg0_307.frozenCount == 0

	if var0_307 ~= 0 and arg0_307.frozenCount == 0 then
		arg0_307:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_308)
	return arg0_308.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_309)
	arg0_309.levelCamIndices = math.max(arg0_309.levelCamIndices - 1, 0)

	if arg0_309.levelCamIndices == 0 then
		arg0_309.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.disableLevelCamera(arg0_310)
	arg0_310.levelCamIndices = arg0_310.levelCamIndices + 1

	if arg0_310.levelCamIndices > 0 then
		arg0_310.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.RecordTween(arg0_311, arg1_311, arg2_311)
	arg0_311.tweens[arg1_311] = arg2_311
end

function var0_0.DeleteTween(arg0_312, arg1_312)
	local var0_312 = arg0_312.tweens[arg1_312]

	if var0_312 then
		LeanTween.cancel(var0_312)

		arg0_312.tweens[arg1_312] = nil
	end
end

function var0_0.openCommanderPanel(arg0_313, arg1_313, arg2_313, arg3_313)
	local var0_313 = arg2_313.id

	arg0_313.levelCMDFormationView:setCallback(function(arg0_314)
		if not arg3_313 then
			if arg0_314.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_313:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_314.skill)
			elseif arg0_314.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_313.contextData.commanderSelected = {
					chapterId = var0_313,
					fleetId = arg1_313.id
				}

				arg0_313:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_314.pos, arg1_313.id, arg2_313)
				arg0_313:closeCommanderPanel()
			else
				arg0_313:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_314,
					fleetId = arg1_313.id,
					chapterId = var0_313
				}, arg2_313)
			end
		elseif arg0_314.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_313:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_314.skill)
		elseif arg0_314.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_313.contextData.eliteCommanderSelected = {
				index = arg3_313,
				pos = arg0_314.pos,
				chapterId = var0_313
			}

			arg0_313:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_313, arg0_314.pos, arg2_313)
			arg0_313:closeCommanderPanel()
		else
			arg0_313:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_314,
				index = arg3_313,
				chapterId = var0_313
			}, arg2_313)
		end
	end)
	arg0_313.levelCMDFormationView:Load()
	arg0_313.levelCMDFormationView:ActionInvoke("update", arg1_313, arg0_313.commanderPrefabs)
	arg0_313.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_315)
	if arg0_315.levelCMDFormationView:isShowing() then
		arg0_315.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_315.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_316)
	arg0_316.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_317)
	arg0_317.levelCMDFormationView:Destroy()

	arg0_317.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_318, arg1_318)
	arg0_318.spTickets = arg1_318
end

function var0_0.HandleShowMsgBox(arg0_319, arg1_319)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_319)
end

function var0_0.updatePoisonAreaTip(arg0_320)
	local var0_320 = arg0_320.contextData.chapterVO
	local var1_320 = (function(arg0_321)
		local var0_321 = {}
		local var1_321 = pg.map_event_list[var0_320.id] or {}
		local var2_321

		if var0_320:isLoop() then
			var2_321 = var1_321.event_list_loop or {}
		else
			var2_321 = var1_321.event_list or {}
		end

		for iter0_321, iter1_321 in ipairs(var2_321) do
			local var3_321 = pg.map_event_template[iter1_321]

			if var3_321.c_type == arg0_321 then
				table.insert(var0_321, var3_321)
			end
		end

		return var0_321
	end)(ChapterConst.EvtType_Poison)

	if var1_320 then
		for iter0_320, iter1_320 in ipairs(var1_320) do
			local var2_320 = iter1_320.round_gametip

			if var2_320 ~= nil and var2_320 ~= "" and var0_320:getRoundNum() == var2_320[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_320[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_322)
	setActive(arg0_322._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_323)
	local var0_323 = getProxy(ChapterProxy)

	if var0_323 and not arg0_323.contextData.noRecord then
		local var1_323 = arg0_323.contextData.map

		if not var1_323 then
			return
		end

		if var1_323:NeedRecordMap() then
			var0_323:recordLastMap(ChapterProxy.LAST_MAP, var1_323.id)
		end

		if var1_323:isActivity() and not var1_323:isActExtra() then
			var0_323:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_323.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_324)
	local var0_324 = arg0_324.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_324.contextData.map:getConfig("on_activity")) or nil
	local var1_324 = var0_324 and not var0_324:isEnd() and var0_324:GetConfigClientSetting("PTID")
	local var2_324 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var2_324 and not var2_324:isEnd() and var2_324:getConfig("config_client").resId == var1_324 then
		return true
	end

	local var3_324 = var0_324 and var0_324:GetConfigClientPTActivity() or nil

	if var3_324 and getProxy(ActivityProxy):GetShopActivityByRes(var3_324:GetPTDrop()) or nil then
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

	if arg0_331.entranceActivityBg then
		pg.PoolMgr.GetInstance():ReturnPrefab(arg0_331.entranceActivityBgPath, "", arg0_331.entranceActivityBg)

		arg0_331.entranceActivityBg = nil
		arg0_331.entranceActivityBgPath = nil
	end

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
