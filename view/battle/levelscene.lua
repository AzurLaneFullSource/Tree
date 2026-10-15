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

function var0_0.getResource(arg0_3)
	local var0_3 = ResList.LevelSceneResConst.GetResource(arg0_3)

	return table.insertto(var0_3, var0_0.super.getResource(arg0_3))
end

function var0_0.downloadChapterRes(arg0_4, arg1_4, arg2_4)
	if arg0_4.exited or not ResList.ChapterResConst.IsActive(arg1_4) then
		return
	end

	local var0_4 = ResList.ChapterResConst.GetResList(arg1_4)

	SplitPackConst.DownloadByLuaArr(var0_4, function()
		local var0_5 = arg0_4.contextData.chapterVO

		if arg0_4.exited or not ResList.ChapterResConst.IsActive(var0_5) or var0_5.id ~= arg1_4.id then
			return
		end

		if var0_5 ~= arg1_4 then
			arg0_4:downloadChapterRes(var0_5, arg2_4)

			return
		end

		arg2_4()
	end, {
		showMask = true
	})
end

function var0_0.ResUISettings(arg0_6)
	return {
		groupDelta = 1,
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0_0.getBGM(arg0_7)
	local function var0_7()
		return checkExist(arg0_7.contextData.chapterVO, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	local function var1_7()
		if not arg0_7.contextData.map then
			return
		end

		local var0_9 = arg0_7.contextData.map:getConfig("ani_controller")
		local var1_9 = getProxy(ChapterProxy)

		if var0_9 and #var0_9 > 0 then
			for iter0_9, iter1_9 in ipairs(var0_9) do
				local var2_9 = _.rest(iter1_9[2], 2)

				for iter2_9, iter3_9 in ipairs(var2_9) do
					if string.find(iter3_9, "^bgm_") and iter1_9[1] == var3_0 then
						local var3_9 = iter1_9[2][1]
						local var4_9 = false

						for iter4_9, iter5_9 in ipairs(var3_9) do
							local var5_9 = var1_9:GetChapterItemById(iter5_9)

							if var5_9 and var5_9:isClear() then
								var4_9 = true

								break
							end
						end

						if not var4_9 then
							return string.sub(iter3_9, 5)
						end
					end
				end
			end
		end

		return checkExist(arg0_7.contextData.map, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	for iter0_7, iter1_7 in ipairs({
		var0_7(),
		var1_7()
	}) do
		if iter1_7 ~= "" then
			return iter1_7
		end
	end

	return var0_0.super.getBGM(arg0_7)
end

var0_0.optionsPath = {
	"top/top_chapter/option"
}

function var0_0.preload(arg0_10, arg1_10)
	local var0_10 = getProxy(ChapterProxy)

	if arg0_10.contextData.mapIdx and arg0_10.contextData.chapterId then
		local var1_10 = var0_10:getChapterById(arg0_10.contextData.chapterId)

		if var1_10:getConfig("map") == arg0_10.contextData.mapIdx then
			arg0_10.contextData.chapterVO = var1_10

			if var1_10.active then
				assert(not arg0_10.contextData.openChapterId or arg0_10.contextData.openChapterId == arg0_10.contextData.chapterId)

				arg0_10.contextData.openChapterId = nil
			end
		end
	end

	local var2_10, var3_10 = arg0_10:GetInitializeMap()

	if arg0_10.contextData.entranceStatus == nil then
		arg0_10.contextData.entranceStatus = not var3_10
	end

	arg1_10()
end

function var0_0.GetInitializeMap(arg0_11)
	local var0_11 = (function()
		local var0_12 = arg0_11.contextData.chapterVO

		if var0_12 and var0_12.active then
			return var0_12:getConfig("map")
		end

		local var1_12 = arg0_11.contextData.mapIdx

		if var1_12 then
			return var1_12
		end

		local var2_12

		if arg0_11.contextData.targetChapter and arg0_11.contextData.targetMap then
			arg0_11.contextData.openChapterId = arg0_11.contextData.targetChapter
			var2_12 = arg0_11.contextData.targetMap.id
			arg0_11.contextData.targetChapter = nil
			arg0_11.contextData.targetMap = nil
		elseif arg0_11.contextData.eliteDefault then
			local var3_12 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			var2_12 = var3_12 and var3_12.id or nil
			arg0_11.contextData.eliteDefault = nil
		end

		return var2_12
	end)()
	local var1_11 = var0_11 and getProxy(ChapterProxy):getMapById(var0_11)

	if var1_11 then
		local var2_11, var3_11 = var1_11:isUnlock()

		if not var2_11 then
			pg.TipsMgr.GetInstance():ShowTips(var3_11)

			var0_11 = getProxy(ChapterProxy):getLastUnlockMap().id
			arg0_11.contextData.mapIdx = var0_11
		end
	else
		var0_11 = nil
	end

	return var0_11 or getProxy(ChapterProxy):GetLastNormalMap(), tobool(var0_11)
end

function var0_0.init(arg0_13)
	arg0_13:initData()
	arg0_13:initUI()
	arg0_13:initEvents()
	arg0_13:updateClouds()
end

function var0_0.initData(arg0_14)
	arg0_14.tweens = {}

	local var0_14 = arg0_14._tf.rect.size

	arg0_14.mapWidth, arg0_14.mapHeight = var0_14.x, var0_14.y
	arg0_14.levelCamIndices = 1
	arg0_14.frozenCount = 0
	arg0_14.currentBG = nil
	arg0_14.mbDict = {}
	arg0_14.mapGroup = {}

	if not arg0_14.contextData.huntingRangeVisibility then
		arg0_14.contextData.huntingRangeVisibility = 2
	end
end

function var0_0.initUI(arg0_15)
	arg0_15.topPanel = arg0_15._tf:Find("top")
	arg0_15.canvasGroup = arg0_15.topPanel:GetComponent("CanvasGroup")
	arg0_15.canvasGroup.blocksRaycasts = not arg0_15.canvasGroup.blocksRaycasts
	arg0_15.canvasGroup.blocksRaycasts = not arg0_15.canvasGroup.blocksRaycasts
	arg0_15.entranceLayer = arg0_15._tf:Find("entrance")
	arg0_15.ptBonus = EventPtBonus.New(arg0_15.entranceLayer:Find("btns/btn_task/bonusPt"))
	arg0_15.entranceBg = arg0_15._tf:Find("entrance_bg")
	arg0_15.topChapter = arg0_15.topPanel:Find("top_chapter")

	setActive(arg0_15.topChapter:Find("title_chapter"), false)
	setActive(arg0_15.topChapter:Find("type_chapter"), false)
	setActive(arg0_15.topChapter:Find("type_escort"), false)
	setActive(arg0_15.topChapter:Find("type_skirmish"), false)

	arg0_15.chapterName = arg0_15.topChapter:Find("title_chapter/name")
	arg0_15.chapterNoTitle = arg0_15.topChapter:Find("title_chapter/chapter")
	arg0_15.resChapter = arg0_15.topChapter:Find("resources")

	setActive(arg0_15.topChapter, true)

	arg0_15._voteBookBtn = arg0_15.topChapter:Find("vote_book")
	arg0_15.leftChapter = arg0_15._tf:Find("main/left_chapter")

	setActive(arg0_15.leftChapter, true)

	arg0_15.leftCanvasGroup = arg0_15.leftChapter:GetComponent(typeof(CanvasGroup))
	arg0_15.btnPrev = arg0_15.leftChapter:Find("btn_prev")
	arg0_15.btnPrevCol = arg0_15.leftChapter:Find("btn_prev/prev_image")
	arg0_15.eliteBtn = arg0_15.leftChapter:Find("buttons/btn_elite")
	arg0_15.normalBtn = arg0_15.leftChapter:Find("buttons/btn_normal")
	arg0_15.actNormalBtn = arg0_15.leftChapter:Find("buttons/btn_act_normal")
	arg0_15.actEliteBtn = arg0_15.leftChapter:Find("buttons/btn_act_elite")
	arg0_15.actExtraBtn = arg0_15.leftChapter:Find("buttons/btn_act_extra")
	arg0_15.actExtraBtnAnim = arg0_15.actExtraBtn:Find("usm")
	arg0_15.remasterBtn = arg0_15.leftChapter:Find("buttons/btn_remaster")
	arg0_15.escortBar = arg0_15.leftChapter:Find("escort_bar")
	arg0_15.eliteQuota = arg0_15.leftChapter:Find("elite_quota")
	arg0_15.skirmishBar = arg0_15.leftChapter:Find("left_times")
	arg0_15.suggestionBtn = arg0_15.leftChapter:Find("suggestionBtn")

	setText(arg0_15.leftChapter:Find("suggestionBtn/Text"), i18n("formation_suggestion"))

	arg0_15.mainLayer = arg0_15._tf:Find("main")

	setActive(arg0_15.mainLayer:Find("title_chapter_lines"), false)

	arg0_15.rightChapter = arg0_15._tf:Find("main/right_chapter")
	arg0_15.rightCanvasGroup = arg0_15.rightChapter:GetComponent(typeof(CanvasGroup))
	arg0_15.eventContainer = arg0_15.rightChapter:Find("event_btns/event_container")
	arg0_15.btnSpecial = arg0_15.eventContainer:Find("btn_task")
	arg0_15.challengeBtn = arg0_15.eventContainer:Find("btn_challenge")
	arg0_15.dailyBtn = arg0_15.eventContainer:Find("btn_daily")
	arg0_15.militaryExerciseBtn = arg0_15.eventContainer:Find("btn_pvp")
	arg0_15.activityBtn = arg0_15.rightChapter:Find("event_btns/activity_btn")
	arg0_15.ptTotal = arg0_15.rightChapter:Find("event_btns/pt_text")
	arg0_15.ticketTxt = arg0_15.rightChapter:Find("event_btns/tickets/Text")
	arg0_15.remasterAwardBtn = arg0_15.rightChapter:Find("btn_remaster_award")
	arg0_15.btnNext = arg0_15.rightChapter:Find("btn_next")
	arg0_15.btnNextCol = arg0_15.rightChapter:Find("btn_next/next_image")
	arg0_15.countDown = arg0_15.rightChapter:Find("event_btns/count_down")

	setActive(arg0_15.rightChapter:Find("event_btns/BottomList"), true)

	arg0_15.actExchangeShopBtn = arg0_15.rightChapter:Find("event_btns/BottomList/btn_exchange")
	arg0_15.actAtelierBuffBtn = arg0_15.rightChapter:Find("event_btns/BottomList/btn_control_center")
	arg0_15.actAtelierYumiaBuffBtn = arg0_15.rightChapter:Find("event_btns/BottomList/btn_yumia_buff")
	arg0_15.actExtraRank = arg0_15.rightChapter:Find("event_btns/BottomList/act_extra_rank")

	setActive(arg0_15.rightChapter, true)

	arg0_15.damageTextTemplate = go(arg0_15.topPanel:Find("damage"))

	setActive(arg0_15.damageTextTemplate, false)

	arg0_15.damageTextPool = {
		arg0_15.damageTextTemplate
	}
	arg0_15.damageTextActive = {}
	arg0_15.mapHelpBtn = arg0_15.topPanel:Find("help_button")
	arg0_15.avoidText = arg0_15.topPanel:Find("text_avoid")
	arg0_15.commanderTinkle = arg0_15.topPanel:Find("neko_tinkle")

	setActive(arg0_15.commanderTinkle, false)

	arg0_15.spResult = arg0_15.topPanel:Find("sp_result")

	setActive(arg0_15.spResult, false)

	arg0_15.helpPage = arg0_15.topPanel:Find("help_page")
	arg0_15.helpImage = arg0_15.helpPage:Find("icon")

	setActive(arg0_15.helpPage, false)

	arg0_15.curtain = arg0_15.topPanel:Find("curtain")

	setActive(arg0_15.curtain, false)

	arg0_15.map = arg0_15._tf:Find("maps")
	arg0_15.mapTFs = {
		arg0_15._tf:Find("maps/map1"),
		arg0_15._tf:Find("maps/map2")
	}

	for iter0_15, iter1_15 in ipairs(arg0_15.mapTFs) do
		iter1_15:GetComponent(typeof(Image)).enabled = false
	end

	arg0_15.UIFXList = arg0_15._tf:Find("maps/UI_FX_list")

	local var0_15 = arg0_15.UIFXList:GetComponentsInChildren(typeof(Renderer)):ToTable()

	for iter2_15, iter3_15 in ipairs(var0_15) do
		iter3_15.sortingOrder = -1
	end

	arg0_15.rtRightPanel = arg0_15._tf:Find("entrance/enters/right_panel")
	arg0_15.actBtnTpl = arg0_15.rtRightPanel:Find("content/tpl")

	local var1_15 = pg.UIMgr.GetInstance()

	arg0_15.levelCam = var1_15.levelCamera:GetComponent(typeof(Camera))
	arg0_15.uiMain = var1_15.LevelMain

	setActive(arg0_15.uiMain, false)

	arg0_15.uiCam = var1_15.uiCamera:GetComponent(typeof(Camera))
	arg0_15.levelGrid = arg0_15.uiMain:Find("LevelGrid")

	setActive(arg0_15.levelGrid, true)

	arg0_15.dragLayer = arg0_15.levelGrid:Find("DragLayer")
	arg0_15.float = arg0_15._tf:Find("float")
	arg0_15.clouds = arg0_15.float:Find("clouds")

	setActive(arg0_15.clouds, true)
	setActive(arg0_15.float:Find("levels"), false)

	arg0_15.resources = arg0_15._tf:Find("resources")
	arg0_15.arrowTarget = arg0_15.resources:Find("Tpl_Arrow_Target")
	arg0_15.destinationMarkTpl = arg0_15.resources:Find("Tpl_Destination_Mark")
	arg0_15.championTpl = arg0_15.resources:Find("Tpl_Champion")
	arg0_15.deadTpl = arg0_15.resources:Find("Tpl_Dead")
	arg0_15.enemyTpl = arg0_15.resources:Find("Tpl_Enemy")
	arg0_15.oniTpl = arg0_15.resources:Find("Tpl_Oni")
	arg0_15.shipTpl = arg0_15.resources:Find("Tpl_Ship")
	arg0_15.subTpl = arg0_15.resources:Find("Tpl_Sub")
	arg0_15.transportTpl = arg0_15.resources:Find("Tpl_Transport")

	setText(tf(arg0_15.enemyTpl):Find("fighting/Text"), i18n("ui_word_levelui2_inevent"))
	arg0_15:HideBtns()
	setAnchoredPosition(arg0_15.topChapter, {
		y = 0
	})
	setAnchoredPosition(arg0_15.leftChapter, {
		x = 0
	})
	setAnchoredPosition(arg0_15.rightChapter, {
		x = 0
	})

	arg0_15.bubbleMsgBoxes = {}
	arg0_15.loader = AutoLoader.New()
	arg0_15.levelFleetView = LevelFleetView.New(arg0_15.topPanel, arg0_15.event, arg0_15.contextData)
	arg0_15.levelInfoView = LevelInfoView.New(arg0_15.topPanel, arg0_15.event, arg0_15.contextData)

	arg0_15.levelInfoView:RegisterView(arg0_15)
	arg0_15.levelFleetView:RegisterView(arg0_15)
	arg0_15:buildCommanderPanel()

	arg0_15.levelRemasterView = LevelRemasterView.New(arg0_15.topPanel, arg0_15.event, arg0_15.contextData)
	arg0_15.chapterAutoDetailPanel = ChapterAutoDetailPanel.New(arg0_15.topPanel, arg0_15.event, arg0_15.contextData)

	arg0_15.chapterAutoDetailPanel:RegisterView(arg0_15)
	arg0_15:SwitchMapBuilder(MapBuilder.TYPENORMAL)
end

function var0_0.LoadEntranceActivityBg(arg0_16)
	local var0_16 = arg0_16.entranceActivity:getConfig("config_client").entrance_bg

	if not var0_16 then
		return
	end

	local var1_16 = "activitybanner"

	if string.sub(var0_16, 1, #var1_16) == var1_16 then
		var0_16 = "MainUIBanner" .. string.sub(var0_16, #var1_16 + 1)
	end

	arg0_16.entranceActivityBgPath = var0_16

	pg.PoolMgr.GetInstance():GetPrefab(var0_16, "", true, function(arg0_17)
		if arg0_16.exited then
			pg.PoolMgr.GetInstance():ReturnPrefab(var0_16, "", arg0_17)

			return
		end

		arg0_16.entranceActivityBg = arg0_17

		setParent(arg0_17.transform, arg0_16.entranceLayer:Find("enters/enter_ready/activity"))
		setText(arg0_17.transform:Find("Text"), arg0_16.entranceActivity:GetActivityTimeStr(true))

		arg0_17.transform.anchorMin = Vector2.zero
		arg0_17.transform.anchorMax = Vector2.one
		arg0_17.transform.offsetMin = Vector2.zero
		arg0_17.transform.offsetMax = Vector2.zero
	end)
end

function var0_0.initEvents(arg0_18)
	arg0_18:bind(LevelUIConst.OPEN_COMMANDER_PANEL, function(arg0_19, arg1_19, arg2_19, arg3_19)
		arg0_18:openCommanderPanel(arg1_19, arg2_19, arg3_19)
	end)
	arg0_18:bind(LevelUIConst.HANDLE_SHOW_MSG_BOX, function(arg0_20, arg1_20)
		arg0_18:HandleShowMsgBox(arg1_20)
	end)
	arg0_18:bind(LevelUIConst.DO_AMBUSH_WARNING, function(arg0_21, arg1_21)
		arg0_18:doAmbushWarning(arg1_21)
	end)
	arg0_18:bind(LevelUIConst.DISPLAY_AMBUSH_INFO, function(arg0_22, arg1_22)
		arg0_18:displayAmbushInfo(arg1_22)
	end)
	arg0_18:bind(LevelUIConst.DISPLAY_STRATEGY_INFO, function(arg0_23, arg1_23)
		arg0_18:displayStrategyInfo(arg1_23)
	end)
	arg0_18:bind(LevelUIConst.FROZEN, function(arg0_24)
		arg0_18:frozen()
	end)
	arg0_18:bind(LevelUIConst.UN_FROZEN, function(arg0_25)
		arg0_18:unfrozen()
	end)
	arg0_18:bind(LevelUIConst.DO_TRACKING, function(arg0_26, arg1_26)
		arg0_18:doTracking(arg1_26)
	end)
	arg0_18:bind(LevelUIConst.SWITCH_TO_MAP, function()
		if arg0_18:isfrozen() then
			return
		end

		arg0_18:switchToMap()
	end)
	arg0_18:bind(LevelUIConst.DISPLAY_REPAIR_WINDOW, function(arg0_28, arg1_28)
		arg0_18:displayRepairWindow(arg1_28)
	end)
	arg0_18:bind(LevelUIConst.DO_PLAY_ANIM, function(arg0_29, arg1_29)
		arg0_18:doPlayAnim(arg1_29.name, arg1_29.callback, arg1_29.onStart)
	end)
	arg0_18:bind(LevelUIConst.HIDE_FLEET_SELECT, function()
		arg0_18:hideFleetSelect()
	end)
	arg0_18:bind(LevelUIConst.HIDE_FLEET_EDIT, function(arg0_31)
		arg0_18:hideFleetEdit()
	end)
	arg0_18:bind(LevelUIConst.ADD_MSG_QUEUE, function(arg0_32, arg1_32)
		arg0_18:addbubbleMsgBox(arg1_32)
	end)
	arg0_18:bind(LevelUIConst.SET_MAP, function(arg0_33, arg1_33)
		arg0_18:setMap(arg1_33)
	end)
end

function var0_0.onZeroHourRefresh(arg0_34)
	if arg0_34.levelInfoView:isShowing() then
		arg0_34.levelInfoView:RefreshChapterAutoPanel()
	end

	if arg0_34.levelInfoSPView and arg0_34.levelInfoSPView:isShowing() then
		arg0_34.levelInfoView:RefreshChapterAutoPanel()
	end
end

function var0_0.addbubbleMsgBox(arg0_35, arg1_35)
	table.insert(arg0_35.bubbleMsgBoxes, arg1_35)

	if #arg0_35.bubbleMsgBoxes > 1 then
		return
	end

	local var0_35

	local function var1_35()
		local var0_36 = arg0_35.bubbleMsgBoxes[1]

		if var0_36 then
			var0_36(function()
				table.remove(arg0_35.bubbleMsgBoxes, 1)
				var1_35()
			end)
		end
	end

	var1_35()
end

function var0_0.CleanBubbleMsgbox(arg0_38)
	table.clean(arg0_38.bubbleMsgBoxes)
end

function var0_0.updatePtActivity(arg0_39, arg1_39)
	arg0_39.ptActivity = arg1_39

	if not arg0_39.ptActivity then
		return
	end

	arg0_39:updateActivityRes()
end

function var0_0.updateActivityRes(arg0_40)
	local var0_40 = findTF(arg0_40.ptTotal, "Text")
	local var1_40 = findTF(arg0_40.ptTotal, "icon/Image")

	if var0_40 and var1_40 and arg0_40.ptActivity then
		setText(var0_40, "x" .. arg0_40.ptActivity:GetTotalPtCount())

		local var2_40 = arg0_40.ptActivity:GetPTDrop():getIcon()

		GetImageSpriteFromAtlasAsync(var2_40, "", var1_40, true)
		GetImageSpriteFromAtlasAsync(var2_40, "", arg0_40.actExchangeShopBtn:Find("icon"), true)
	end
end

function var0_0.setCommanderPrefabs(arg0_41, arg1_41)
	arg0_41.commanderPrefabs = arg1_41
end

function var0_0.didEnter(arg0_42)
	arg0_42.openedCommanerSystem = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_42.player.level, "CommanderCatMediator")

	onButton(arg0_42, arg0_42.topChapter:Find("back_button"), function()
		if arg0_42:isfrozen() then
			return
		end

		local var0_43 = arg0_42.contextData.map

		if var0_43 and (var0_43:isActivity() or var0_43:isEscort()) then
			arg0_42:emit(LevelMediator2.ON_SWITCH_NORMAL_MAP)

			return
		elseif var0_43 and var0_43:isSkirmish() then
			arg0_42:emit(var0_0.ON_BACK)
		elseif not arg0_42.contextData.entranceStatus then
			arg0_42:ShowEntranceUI(true)
		else
			arg0_42:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_42, arg0_42.btnSpecial, function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.dailyBtn, function()
		if arg0_42:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_42:updatDailyBtnTip()
		arg0_42:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.challengeBtn, function()
		if arg0_42:isfrozen() then
			return
		end

		local var0_46, var1_46 = arg0_42:checkChallengeOpen()

		if var0_46 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_46)
		else
			arg0_42:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.militaryExerciseBtn, function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.normalBtn, function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:setMap(arg0_42.contextData.map:getBindMapId())
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.eliteBtn, function()
		if arg0_42:isfrozen() then
			return
		end

		if arg0_42.contextData.map:getBindMapId() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

			local var0_49 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			if var0_49 then
				arg0_42:setMap(var0_49.configId)
				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_warp_to_latest_map"))
			end
		elseif arg0_42.contextData.map:isEliteEnabled() then
			arg0_42:setMap(arg0_42.contextData.map:getBindMapId())
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unsatisfied"))
		end
	end, SFX_UI_WEIGHANCHOR_HARD)
	onButton(arg0_42, arg0_42.remasterBtn, function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_42:updateRemasterBtnTip()
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.entranceLayer:Find("enters/enter_main"), function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:ShowSelectedMap(arg0_42:GetInitializeMap())
	end, SFX_PANEL)
	setText(arg0_42.entranceLayer:Find("enters/enter_main/Text"), getProxy(ChapterProxy):getLastUnlockMap():getLastUnlockChapterName())
	onButton(arg0_42, arg0_42.entranceLayer:Find("enters/enter_world/enter"), function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:emit(LevelMediator2.ENTER_WORLD)
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.entranceLayer:Find("enters/enter_ready/activity"), function()
		if arg0_42:isfrozen() then
			return
		end

		switch(arg0_42.entranceActivity:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0_42:emit(LevelMediator2.ON_ACTIVITY_MAP, arg0_42.entranceActivity.id)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
				arg0_42:emit(LevelMediator2.ON_OPEN_ACT_BOSS_BATTLE)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
				arg0_42:emit(LevelMediator2.ON_BOSSRUSH_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
				arg0_42:emit(LevelMediator2.ON_BOSSSINGLE_MAP, {
					mode = OtherworldMapScene.MODE_BATTLE
				})
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
				arg0_42:emit(LevelMediator2.ON_CLUE_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function()
				arg0_42:emit(LevelMediator2.ON_COLLAB_BOSSRUSH_MAP)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.entranceLayer:Find("btns/btn_remaster"), function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_42:updateRemasterBtnTip()
	end, SFX_PANEL)
	setActive(arg0_42.entranceLayer:Find("btns/btn_remaster"), OPEN_REMASTER)
	onButton(arg0_42, arg0_42.entranceLayer:Find("btns/btn_challenge"), function()
		if arg0_42:isfrozen() then
			return
		end

		local var0_61, var1_61 = arg0_42:checkChallengeOpen()

		if var0_61 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_61)
		else
			arg0_42:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.entranceLayer:Find("btns/btn_pvp"), function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.entranceLayer:Find("btns/btn_daily"), function()
		if arg0_42:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_42:updatDailyBtnTip()
		arg0_42:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.entranceLayer:Find("btns/btn_task"), function()
		if arg0_42:isfrozen() then
			return
		end

		arg0_42:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	setActive(arg0_42.entranceLayer:Find("enters/enter_world/enter"), not WORLD_ENTER_LOCK)
	setActive(arg0_42.entranceLayer:Find("enters/enter_world/nothing"), WORLD_ENTER_LOCK)
	setActive(arg0_42.entranceLayer:Find("enters/enter_world/enter/tip"), getProxy(ChapterAutoProxy):IsAllCommissionFinish(ChapterAutoProxy.TYPE.WORLD))

	arg0_42.entranceActivity = getProxy(ActivityProxy):getEnterReadyActivity()[1]

	setActive(arg0_42.entranceLayer:Find("enters/enter_ready/nothing"), not tobool(arg0_42.entranceActivity))
	setActive(arg0_42.entranceLayer:Find("enters/enter_ready/activity"), tobool(arg0_42.entranceActivity))

	if tobool(arg0_42.entranceActivity) then
		arg0_42:LoadEntranceActivityBg()
	end

	arg0_42:updateRightPanel()

	local var0_42 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_42.player.level, "EventMediator")

	setActive(arg0_42.btnSpecial:Find("lock"), not var0_42)
	setActive(arg0_42.entranceLayer:Find("btns/btn_task/lock"), not var0_42)

	local var1_42 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_42.player.level, "DailyLevelMediator")

	setActive(arg0_42.dailyBtn:Find("lock"), not var1_42)
	setActive(arg0_42.entranceLayer:Find("btns/btn_daily/lock"), not var1_42)

	local var2_42 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_42.player.level, "MilitaryExerciseMediator")

	setActive(arg0_42.militaryExerciseBtn:Find("lock"), not var2_42)
	setActive(arg0_42.entranceLayer:Find("btns/btn_pvp/lock"), not var2_42)

	local var3_42 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_42.player.level, "WorldMediator")

	setActive(arg0_42.entranceLayer:Find("enters/enter_world/enter/lock"), not var3_42)

	local var4_42 = LimitChallengeConst.IsOpen()

	setActive(arg0_42.challengeBtn:Find("lock"), not var4_42)
	setActive(arg0_42.entranceLayer:Find("btns/btn_challenge/lock"), not var4_42)

	local var5_42 = LimitChallengeConst.IsInAct()

	setActive(arg0_42.challengeBtn, var5_42)
	setActive(arg0_42.entranceLayer:Find("btns/btn_challenge"), var5_42)

	local var6_42 = LimitChallengeConst.IsShowRedPoint()

	setActive(arg0_42.entranceLayer:Find("btns/btn_challenge/tip"), var6_42)
	arg0_42:initMapBtn(arg0_42.btnPrev, -1)
	arg0_42:initMapBtn(arg0_42.btnNext, 1)
	onButton(arg0_42, arg0_42.suggestionBtn, function()
		local var0_65 = arg0_42.contextData.mapIdx
		local var1_65 = table.keyof(LevelTools.GetSuggestionMapIDList(var0_65), var0_65)

		arg0_42:emit(BaseUI.ON_GO_SCENE, SCENE.FORMATION_SUGGESTION, {
			selectedIndex = var1_65,
			mapID = var0_65
		})
	end)
	arg0_42:registerActBtn()

	if arg0_42.contextData.editEliteChapter then
		local var7_42 = getProxy(ChapterProxy):getChapterById(arg0_42.contextData.editEliteChapter)

		arg0_42:displayFleetEdit(var7_42)

		arg0_42.contextData.editEliteChapter = nil
	elseif arg0_42.contextData.selectedChapterVO then
		arg0_42:displayFleetSelect(arg0_42.contextData.selectedChapterVO)

		arg0_42.contextData.selectedChapterVO = nil
	end

	local var8_42 = arg0_42.contextData.chapterVO

	if not var8_42 or not var8_42.active then
		arg0_42:tryPlaySubGuide()
	end

	arg0_42:updateRemasterBtnTip()
	arg0_42:updatDailyBtnTip()

	if arg0_42.contextData.open_remaster then
		arg0_42:displayRemasterPanel(arg0_42.contextData.isSP)

		arg0_42.contextData.open_remaster = nil
	end

	arg0_42:ShowEntranceUI(arg0_42.contextData.entranceStatus)

	if not arg0_42.contextData.entranceStatus then
		arg0_42:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg0_42:GetInitializeMap())
	end

	arg0_42:emit(LevelMediator2.ON_DIDENTER)
end

function var0_0.updateRightPanel(arg0_66)
	arg0_66.rightActivityBtns = defaultValue(arg0_66.rightActivityBtns, {
		LevelSecondMapBtn.New(arg0_66.actBtnTpl, arg0_66.event, false)
	})

	local var0_66 = {}
	local var1_66 = {}

	for iter0_66, iter1_66 in ipairs(arg0_66.rightActivityBtns) do
		if iter1_66:InShowTime() then
			table.insert(var0_66, iter1_66)
		else
			table.insert(var1_66, iter1_66)
		end
	end

	table.sort(var0_66, CompareFuncs({
		function(arg0_67)
			return arg0_67.config.group_id
		end
	}))

	for iter2_66, iter3_66 in ipairs(var0_66) do
		iter3_66:Init(iter2_66)
	end

	for iter4_66, iter5_66 in ipairs(var1_66) do
		iter5_66:Clear()
	end
end

function var0_0.checkChallengeOpen(arg0_68)
	local var0_68 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_68, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_69)
	if arg0_69.contextData.map and arg0_69.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_69)
end

function var0_0.onBackPressed(arg0_70)
	if arg0_70:isfrozen() then
		return
	end

	if arg0_70.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_70.chapterAutoDetailPanel:isShowing() then
		arg0_70:HideChapterAutoDetailPanel()
	end

	if arg0_70.levelInfoView:isShowing() then
		arg0_70:hideChapterPanel()

		return
	end

	if arg0_70.levelInfoSPView and arg0_70.levelInfoSPView:isShowing() then
		arg0_70:HideLevelInfoSPPanel()

		return
	end

	if arg0_70.levelFleetView:isShowing() then
		arg0_70:hideFleetEdit()

		return
	end

	if arg0_70.levelStrategyView then
		arg0_70:hideStrategyInfo()

		return
	end

	if arg0_70.levelRepairView then
		arg0_70:hideRepairWindow()

		return
	end

	if arg0_70.levelRemasterView:isShowing() then
		arg0_70:hideRemasterPanel()

		return
	end

	if arg0_70.contextData.map and arg0_70.contextData.map:getConfig("ui_type") == MapBuilder.TYPEEXSP and arg0_70.mapBuilder.personalPage:IsActive() then
		arg0_70.mapBuilder.personalPage:Hide()

		return
	end

	if isActive(arg0_70.helpPage) then
		setActive(arg0_70.helpPage, false)

		return
	end

	local var0_70 = arg0_70.contextData.chapterVO
	local var1_70 = getProxy(ChapterProxy):getActiveChapter()

	if var0_70 and var1_70 then
		arg0_70:switchToMap()

		return
	end

	triggerButton(arg0_70.topChapter:Find("back_button"))
end

function var0_0.ShowEntranceUI(arg0_71, arg1_71)
	setActive(arg0_71.entranceLayer, arg1_71)
	setActive(arg0_71.entranceBg, arg1_71)
	setActive(arg0_71.map, not arg1_71)
	setActive(arg0_71.float, not arg1_71)
	setActive(arg0_71.mainLayer, not arg1_71)
	setActive(arg0_71.topChapter:Find("type_entrance"), arg1_71)

	arg0_71.contextData.entranceStatus = tobool(arg1_71)

	if arg1_71 then
		setActive(arg0_71.topChapter:Find("title_chapter"), false)
		setActive(arg0_71.topChapter:Find("type_chapter"), false)
		setActive(arg0_71.topChapter:Find("type_escort"), false)
		setActive(arg0_71.topChapter:Find("type_skirmish"), false)

		if arg0_71.newChapterCDTimer then
			arg0_71.newChapterCDTimer:Stop()

			arg0_71.newChapterCDTimer = nil
		end

		arg0_71:RecordLastMapOnExit()

		arg0_71.contextData.mapIdx = nil
		arg0_71.contextData.map = nil
	end

	arg0_71:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_72, arg1_72, arg2_72)
	if arg0_72.preloadLevelDone then
		existCall(arg2_72)

		return
	end

	local var0_72

	local function var1_72()
		if not arg0_72.exited then
			arg0_72.preloadLevelDone = true

			existCall(arg2_72)
		end
	end

	local var2_72 = getProxy(ChapterProxy):getMapById(arg1_72)
	local var3_72 = arg0_72:GetMapBG(var2_72)

	table.ParallelIpairsAsync(var3_72, function(arg0_74, arg1_74, arg2_74)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_74.BG, "", arg2_74)
	end, var1_72)
end

function var0_0.setShips(arg0_75, arg1_75)
	arg0_75.shipVOs = arg1_75
end

function var0_0.updateRes(arg0_76, arg1_76)
	if arg0_76.levelStageView then
		arg0_76.levelStageView:ActionInvoke("SetPlayer", arg1_76)
	end

	arg0_76.player = arg1_76
end

function var0_0.setEliteQuota(arg0_77, arg1_77, arg2_77)
	local var0_77 = arg2_77 - arg1_77
	local var1_77 = arg0_77.eliteQuota:Find("bg/Text"):GetComponent(typeof(Text))

	if arg1_77 == arg2_77 then
		var1_77.color = Color.red
	else
		var1_77.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_77.text = var0_77 .. "/" .. arg2_77
end

function var0_0.updateEvent(arg0_78, arg1_78)
	local var0_78 = arg1_78:hasFinishState()

	setActive(arg0_78.btnSpecial:Find("tip"), var0_78)
	setActive(arg0_78.entranceLayer:Find("btns/btn_task/tip"), var0_78)
end

function var0_0.updateFleet(arg0_79, arg1_79)
	arg0_79.fleets = arg1_79
end

function var0_0.updateChapterVO(arg0_80, arg1_80, arg2_80)
	if arg0_80.contextData.chapterVO and arg0_80.contextData.chapterVO.id == arg1_80.id and arg1_80.active then
		arg0_80:setChapter(arg1_80)
	end

	if arg0_80.contextData.chapterVO and arg0_80.contextData.chapterVO.id == arg1_80.id and arg1_80.active and arg0_80.levelStageView and arg0_80.grid then
		local var0_80 = false
		local var1_80 = false
		local var2_80 = false

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyFleet) > 0 then
			arg0_80.levelStageView:updateStageFleet()
			arg0_80.levelStageView:updateAmbushRate(arg1_80.fleet.line, true)

			var2_80 = true

			if arg0_80.grid then
				arg0_80.grid:RefreshFleetCells()
				arg0_80.grid:UpdateFloor()
				arg0_80.grid:UpdateWeatherCells()

				var0_80 = true
			end
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyChampion) > 0 then
			var2_80 = true

			if arg0_80.grid then
				arg0_80.grid:UpdateFleets()
				arg0_80.grid:clearChampions()
				arg0_80.grid:initChampions()

				var1_80 = true
			end
		elseif bit.band(arg2_80, ChapterConst.DirtyChampionPosition) > 0 then
			var2_80 = true

			if arg0_80.grid then
				arg0_80.grid:UpdateFleets()
				arg0_80.grid:updateChampions()

				var1_80 = true
			end
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyAchieve) > 0 then
			arg0_80.levelStageView:updateStageAchieve()
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyAttachment) > 0 then
			arg0_80.levelStageView:updateAmbushRate(arg1_80.fleet.line, true)

			if arg0_80.grid then
				if not (arg2_80 < 0) and not (bit.band(arg2_80, ChapterConst.DirtyFleet) > 0) then
					arg0_80.grid:updateFleet(arg1_80.fleets[arg1_80.findex].id)
				end

				arg0_80.grid:updateAttachments()

				if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyAutoAction) > 0 then
					arg0_80.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_80 = true
				end
			end
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyStrategy) > 0 then
			arg0_80.levelStageView:updateStageStrategy()

			var2_80 = true

			arg0_80.levelStageView:updateStageBarrier()
			arg0_80.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_80 then
			arg0_80.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_80 then
			arg0_80.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyCellFlag) > 0 then
			arg0_80.grid:UpdateFloor()
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyBase) > 0 then
			arg0_80.levelStageView:UpdateDefenseStatus()
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyFloatItems) > 0 then
			arg0_80.grid:UpdateItemCells()
		end

		if arg2_80 < 0 or bit.band(arg2_80, ChapterConst.DirtyWeather) > 0 then
			arg0_80.grid:UpdateWeatherCells()
		end

		if var2_80 then
			arg0_80.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_81)
	arg0_81.cloudRTFs = {}
	arg0_81.cloudRects = {}
	arg0_81.cloudTimer = {}

	for iter0_81 = 1, 6 do
		local var0_81 = arg0_81.clouds:Find("cloud_" .. iter0_81)
		local var1_81 = rtf(var0_81)

		table.insert(arg0_81.cloudRTFs, var1_81)
		table.insert(arg0_81.cloudRects, var1_81.rect.width)
	end

	arg0_81:initCloudsPos()

	for iter1_81, iter2_81 in ipairs(arg0_81.cloudRTFs) do
		local var2_81 = arg0_81.cloudRects[iter1_81]
		local var3_81 = arg0_81.initPositions[iter1_81] or Vector2(0, 0)
		local var4_81 = 30 - var3_81.y / 20
		local var5_81 = (arg0_81.mapWidth + var2_81) / var4_81
		local var6_81

		var6_81 = LeanTween.moveX(iter2_81, arg0_81.mapWidth, var5_81):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_81 = arg0_81.cloudRects[iter1_81]
			iter2_81.anchoredPosition = Vector2(-var2_81, var3_81.y)

			var6_81:setFrom(-var2_81):setTime((arg0_81.mapWidth + var2_81) / var4_81)
		end))
		var6_81.passed = math.random() * var5_81
		arg0_81.cloudTimer[iter1_81] = var6_81.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_83)
	arg0_83:PlayBGM()
	arg0_83:SwitchMapBG(arg0_83.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_84, arg1_84, arg2_84)
	if not arg1_84 then
		return
	end

	local var0_84 = arg0_84.contextData.map:getConfig("ani_controller")

	local function var1_84(arg0_85)
		arg0_85 = tf(arg0_85)

		local var0_85 = Vector3.one

		if arg0_85.rect.width > 0 and arg0_85.rect.height > 0 then
			var0_85.x = arg0_85.parent.rect.width / arg0_85.rect.width
			var0_85.y = arg0_85.parent.rect.height / arg0_85.rect.height
		end

		arg0_85.localScale = var0_85

		if var0_84 and #var0_84 > 0 then
			local var1_85 = getProxy(ChapterProxy)

			;(function()
				for iter0_86, iter1_86 in ipairs(var0_84) do
					local var0_86 = false
					local var1_86 = iter1_86[2][1]

					for iter2_86, iter3_86 in ipairs(var1_86) do
						local var2_86 = var1_85:GetChapterItemById(iter3_86)

						if var2_86 and var2_86:isClear() then
							var0_86 = true

							break
						end
					end

					if iter1_86[1] == var2_0 then
						local var3_86 = _.rest(iter1_86[2], 2)

						for iter4_86, iter5_86 in ipairs(var3_86) do
							local var4_86 = arg0_85:Find(iter5_86)

							if not IsNil(var4_86) and not var0_86 then
								setActive(var4_86, false)
							end
						end
					elseif iter1_86[1] == var3_0 then
						local var5_86 = _.rest(iter1_86[2], 2)

						for iter6_86, iter7_86 in ipairs(var5_86) do
							local var6_86 = arg0_85:Find(iter7_86)

							if not IsNil(var6_86) and not var0_86 then
								setActive(var6_86, true)

								return
							end
						end
					elseif iter1_86[1] == var4_0 then
						local var7_86 = _.rest(iter1_86[2], 2)

						for iter8_86, iter9_86 in ipairs(var7_86) do
							local var8_86 = arg0_85:Find(iter9_86)

							if not IsNil(var8_86) and not var0_86 then
								setActive(var8_86, true)
							end
						end
					end
				end
			end)()
		end
	end

	local var2_84 = arg0_84.loader:GetPrefab("ui/" .. arg1_84, arg1_84, function(arg0_87)
		arg0_87:SetActive(true)

		local var0_87 = arg0_84.mapTFs[arg2_84]

		setParent(arg0_87, var0_87)
		pg.ViewUtils.SetSortingOrder(arg0_87, ChapterConst.LayerWeightMap + arg2_84 * 2 - 1)
		var1_84(arg0_87)
	end)

	table.insert(arg0_84.mapGroup, var2_84)
end

function var0_0.HideBtns(arg0_88)
	setActive(arg0_88.btnPrev, false)
	setActive(arg0_88.eliteQuota, false)
	setActive(arg0_88.escortBar, false)
	setActive(arg0_88.skirmishBar, false)
	setActive(arg0_88.normalBtn, false)
	setActive(arg0_88.actNormalBtn, false)
	setActive(arg0_88.eliteBtn, false)
	setActive(arg0_88.actEliteBtn, false)
	setActive(arg0_88.actExtraBtn, false)
	setActive(arg0_88.remasterBtn, false)
	setActive(arg0_88.btnNext, false)
	setActive(arg0_88.remasterAwardBtn, false)
	setActive(arg0_88.eventContainer, false)
	setActive(arg0_88.activityBtn, false)
	setActive(arg0_88.ptTotal, false)
	setActive(arg0_88.ticketTxt.parent, false)
	setActive(arg0_88.countDown, false)
	setActive(arg0_88.actAtelierBuffBtn, false)
	setActive(arg0_88.actAtelierYumiaBuffBtn, false)
	setActive(arg0_88.actExtraRank, false)
	setActive(arg0_88.actExchangeShopBtn, false)
	setActive(arg0_88.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_89)
	local var0_89 = arg0_89.contextData.map:getConfig("type")

	setActive(arg0_89.normalBtn, var0_89 == Map.ELITE)
	setActive(arg0_89.eliteQuota, var0_89 == Map.ELITE)
	setActive(arg0_89.eliteBtn, var0_89 == Map.SCENARIO)

	local var1_89 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_89.eliteBtn:Find("pic_activity"), var1_89 and not var1_89:isEnd())
end

function var0_0.updateActivityBtns(arg0_90)
	local var0_90 = arg0_90.contextData.map
	local var1_90, var2_90 = var0_90:isActivity()
	local var3_90 = var0_90:isRemaster()
	local var4_90 = var0_90:isSkirmish()
	local var5_90 = var0_90:isEscort()
	local var6_90 = var0_90:getConfig("type")
	local var7_90 = setmetatable({}, MainActMapBtn)
	local var8_90 = var7_90:InShowTime() and not var1_90 and not var4_90 and not var5_90

	arg0_90.activityBtnLinkAct = var7_90:GetActivity()

	if var8_90 then
		var7_90.image = arg0_90.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var7_90.subImage = arg0_90.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var7_90.tipTr = arg0_90.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var7_90.tipTxt = arg0_90.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_90 = var7_90:InShowTime()

		if var8_90 then
			var7_90:InitTipImage()
			var7_90:InitSubImage()
			var7_90:InitImage(function()
				return
			end)
			var7_90:OnInit()
		end
	end

	setActive(arg0_90.activityBtn, var8_90)
	arg0_90:updateRemasterInfo()

	if var1_90 and var2_90 then
		local var9_90

		if var0_90:isRemaster() then
			var9_90 = getProxy(ChapterProxy):getRemasterMaps(var0_90.remasterId)
		else
			var9_90 = getProxy(ChapterProxy):getMapsByActivities(var0_90:getConfig("on_activity"))
		end

		local var10_90 = underscore.any(var9_90, function(arg0_92)
			return arg0_92:isActExtra()
		end)

		setActive(arg0_90.actExtraBtn, var10_90 and var6_90 ~= Map.ACT_EXTRA)

		if isActive(arg0_90.actExtraBtn) then
			if underscore.all(underscore.filter(var9_90, function(arg0_93)
				local var0_93 = arg0_93:getMapType()

				return var0_93 == Map.ACTIVITY_EASY or var0_93 == Map.ACTIVITY_HARD
			end), function(arg0_94)
				return arg0_94:isAllChaptersClear()
			end) then
				setActive(arg0_90.actExtraBtnAnim, true)
			else
				setActive(arg0_90.actExtraBtnAnim, false)
			end

			setActive(arg0_90.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive(var0_90:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_90 = checkExist(var0_90:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_90.actEliteBtn, var11_90 and var6_90 ~= Map.ACTIVITY_HARD)
		setActive(arg0_90.actNormalBtn, var6_90 ~= Map.ACTIVITY_EASY)
		setActive(arg0_90.actExtraRank, var6_90 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_95)
			if not arg0_95 or arg0_95:isEnd() then
				return
			end

			local var0_95 = arg0_95:getConfig("config_data")[1]

			return _.any(var0_90:getChapters(), function(arg0_96)
				if not arg0_96:IsEXChapter() then
					return false
				end

				return table.contains(arg0_96:getConfig("boss_expedition_id"), var0_95)
			end)
		end))
		setActive(arg0_90.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_90 and var2_90 and arg0_90:IsActShopActive())

		local var12_90 = arg0_90.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_90.contextData.map:getConfig("on_activity")) or nil
		local var13_90 = var12_90 and var12_90:GetConfigClientPTActivity() or nil

		arg0_90:updatePtActivity(var13_90)
		setActive(arg0_90.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_90 and var2_90 and arg0_90.ptActivity and not arg0_90.ptActivity:isEnd())
	else
		setActive(arg0_90.actExtraBtn, false)
		setActive(arg0_90.actEliteBtn, false)
		setActive(arg0_90.actNormalBtn, false)
		setActive(arg0_90.actExtraRank, false)
		setActive(arg0_90.actExchangeShopBtn, false)
		setActive(arg0_90.actAtelierBuffBtn, false)
		setActive(arg0_90.actAtelierYumiaBuffBtn, false)
		setActive(arg0_90.ptTotal, false)
	end

	setActive(arg0_90.eventContainer, (not var1_90 or not var2_90) and not var5_90)
	setActive(arg0_90.remasterBtn, OPEN_REMASTER and (var3_90 or not var1_90 and not var5_90 and not var4_90))
	setActive(arg0_90.ticketTxt.parent, var3_90)
	arg0_90:updateRemasterTicket()
	arg0_90:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_97)
	setText(arg0_97.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_97:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_98)
	local var0_98 = getProxy(ChapterProxy)
	local var1_98 = var0_98:ifShowRemasterTip() or var0_98:anyRemasterAwardCanReceive()

	SetActive(arg0_98.remasterBtn:Find("tip"), var1_98)
	SetActive(arg0_98.entranceLayer:Find("btns/btn_remaster/tip"), var1_98)
end

function var0_0.updatDailyBtnTip(arg0_99)
	local var0_99 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_99.dailyBtn:Find("tip"), var0_99)
	SetActive(arg0_99.entranceLayer:Find("btns/btn_daily/tip"), var0_99)
end

function var0_0.updateRemasterInfo(arg0_100)
	arg0_100:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_100.contextData.map then
		return
	end

	local var0_100 = getProxy(ChapterProxy)
	local var1_100 = arg0_100.contextData.map:getRemaster()
	local var2_100 = BossRushChapterRemasterHelper.ChapterAwardInfo(var1_100)

	setActive(arg0_100.remasterAwardBtn, var2_100)

	if var2_100 then
		local var3_100 = var2_100[1]
		local var4_100, var5_100, var6_100, var7_100, var8_100 = unpack(var2_100[2])
		local var9_100 = var2_100[3]
		local var10_100 = var0_100:getRemasterInfo(var9_100, var4_100, var3_100)

		setText(arg0_100.remasterAwardBtn:Find("Text"), var10_100.count .. "/" .. var7_100)
		updateDrop(arg0_100.remasterAwardBtn:Find("IconTpl"), {
			type = var5_100,
			id = var6_100
		})
		setActive(arg0_100.remasterAwardBtn:Find("tip"), var7_100 <= var10_100.count)
		onButton(arg0_100, arg0_100.remasterAwardBtn, function()
			local var0_101 = BossRushChapterRemasterHelper.GetAwardName(var9_100, var4_100)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_100,
					id = var6_100
				},
				remaster = {
					word = i18n("level_remaster_tip4", var0_101),
					number = var10_100.count .. "/" .. var7_100,
					btn_text = i18n(var10_100.count < var7_100 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var10_100.count < var7_100 then
							if var9_100 and var9_100 > 0 then
								arg0_100:emit(LevelMediator2.ON_BOSSRUSH_REMASTER_ACTIVITY, var9_100)

								return
							end

							local var0_102 = pg.chapter_template[var4_100].map
							local var1_102, var2_102 = var0_100:getMapById(var0_102):isUnlock()

							if not var1_102 then
								pg.TipsMgr.GetInstance():ShowTips(var2_102)
							else
								arg0_100:ShowSelectedMap(var0_102)
							end
						else
							arg0_100:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_100, var3_100, var9_100)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_103)
	local var0_103 = getProxy(ChapterProxy)

	if arg0_103.newChapterCDTimer then
		arg0_103.newChapterCDTimer:Stop()

		arg0_103.newChapterCDTimer = nil
	end

	local var1_103 = 0

	if arg0_103.contextData.map:isActivity() and not arg0_103.contextData.map:isRemaster() then
		local var2_103 = var0_103:getMapsByActivities(arg0_103.contextData.map:getConfig("on_activity"))

		_.each(var2_103, function(arg0_104)
			local var0_104 = arg0_104:getChapterTimeLimit()

			if var1_103 == 0 then
				var1_103 = var0_104
			else
				var1_103 = math.min(var1_103, var0_104)
			end
		end)
		setActive(arg0_103.countDown, var1_103 > 0)
		setText(arg0_103.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_103.countDown, false)
	end

	if var1_103 > 0 then
		setText(arg0_103.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_103))

		arg0_103.newChapterCDTimer = Timer.New(function()
			var1_103 = var1_103 - 1

			if var1_103 <= 0 then
				arg0_103:updateCountDown()

				if not arg0_103.contextData.chapterVO then
					arg0_103:setMap(arg0_103.contextData.mapIdx)
				end
			else
				setText(arg0_103.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_103))
			end
		end, 1, -1)

		arg0_103.newChapterCDTimer:Start()
	else
		setText(arg0_103.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_106)
	onButton(arg0_106, arg0_106.actExtraRank, function()
		if arg0_106:isfrozen() then
			return
		end

		arg0_106:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_106, arg0_106.activityBtn, function()
		if arg0_106:isfrozen() then
			return
		end

		if arg0_106.activityBtnLinkAct then
			local var0_108 = arg0_106.activityBtnLinkAct:getConfig("type")
			local var1_108 = arg0_106.activityBtnLinkAct.id

			if var0_108 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)

				return
			elseif var0_108 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)

				return
			elseif var1_108 == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)

				return
			elseif var0_108 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ZHANG_WU_BOSS)

				return
			end
		end

		arg0_106:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_106, arg0_106.actExchangeShopBtn, function()
		if arg0_106:isfrozen() then
			return
		end

		arg0_106:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_106, arg0_106.actAtelierBuffBtn, function()
		if arg0_106:isfrozen() then
			return
		end

		arg0_106:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)
	onButton(arg0_106, arg0_106.actAtelierYumiaBuffBtn, function()
		if arg0_106:isfrozen() then
			return
		end

		arg0_106:emit(LevelMediator2.SHOW_ATELIER_BUFF, true)
	end, SFX_UI_CLICK)

	local var0_106 = getProxy(ChapterProxy)

	local function var1_106(arg0_112, arg1_112, arg2_112)
		local var0_112

		if arg0_112:isRemaster() then
			var0_112 = var0_106:getRemasterMaps(arg0_112.remasterId)
		else
			var0_112 = var0_106:getMapsByActivities(arg0_112:getConfig("on_activity"))
		end

		local var1_112 = _.select(var0_112, function(arg0_113)
			return arg0_113:getMapType() == arg1_112
		end)

		table.sort(var1_112, function(arg0_114, arg1_114)
			return arg0_114.id < arg1_114.id
		end)

		local var2_112 = table.indexof(underscore.map(var1_112, function(arg0_115)
			return arg0_115.id
		end), arg2_112) or #var1_112

		while not var1_112[var2_112]:isUnlock() do
			if var2_112 > 1 then
				var2_112 = var2_112 - 1
			else
				break
			end
		end

		return var1_112[var2_112]
	end

	arg0_106:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_116, arg1_116, arg2_116)
		arg2_116 = arg2_116 or switch(arg1_116, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_106.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_106.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_116 = var1_106(arg0_106.contextData.map, arg1_116, arg2_116)
		local var1_116, var2_116 = var0_116:isUnlock()

		if var1_116 then
			arg0_106:setMap(var0_116.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_116)
		end
	end)
	onButton(arg0_106, arg0_106.actNormalBtn, function()
		if arg0_106:isfrozen() then
			return
		end

		arg0_106:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_106, arg0_106.actEliteBtn, function()
		if arg0_106:isfrozen() then
			return
		end

		arg0_106:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_106, arg0_106.actExtraBtn, function()
		if arg0_106:isfrozen() then
			return
		end

		arg0_106:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_123, arg1_123)
	arg0_123.initPositions = {}

	local var0_123 = arg1_123 or 1
	local var1_123 = pg.expedition_data_by_map[var0_123].clouds_pos

	for iter0_123, iter1_123 in ipairs(arg0_123.cloudRTFs) do
		local var2_123 = var1_123[iter0_123]

		if var2_123 then
			iter1_123.anchoredPosition = Vector2(var2_123[1], var2_123[2])

			table.insert(arg0_123.initPositions, iter1_123.anchoredPosition)
		else
			setActive(iter1_123, false)
		end
	end
end

function var0_0.initMapBtn(arg0_124, arg1_124, arg2_124)
	onButton(arg0_124, arg1_124, function()
		if arg0_124:isfrozen() then
			return
		end

		local var0_125 = arg0_124.contextData.mapIdx + arg2_124
		local var1_125 = getProxy(ChapterProxy):getMapById(var0_125)

		if not var1_125 then
			return
		end

		if var1_125:getMapType() == Map.ELITE and not var1_125:isEliteEnabled() then
			var1_125 = var1_125:getBindMap()
			var0_125 = var1_125.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_125, var3_125 = var1_125:isUnlock()

		if arg2_124 > 0 and not var2_125 then
			pg.TipsMgr.GetInstance():ShowTips(var3_125)

			return
		end

		arg0_124:setMap(var0_125)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_126, arg1_126, arg2_126)
	seriesAsync({
		function(arg0_127)
			if arg0_126.contextData.entranceStatus then
				arg0_126:frozen()

				arg0_126.nextPreloadMap = arg1_126

				arg0_126:PreloadLevelMainUI(arg1_126, function()
					arg0_126:unfrozen()

					if arg0_126.nextPreloadMap ~= arg1_126 then
						return
					end

					arg0_126:ShowEntranceUI(false)
					arg0_126:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_126)
					arg0_127()
				end)
			else
				arg0_126:setMap(arg1_126)
				arg0_127()
			end
		end
	}, arg2_126)
end

function var0_0.setMap(arg0_129, arg1_129)
	local var0_129 = arg0_129.contextData.mapIdx

	arg0_129.contextData.mapIdx = arg1_129
	arg0_129.contextData.map = getProxy(ChapterProxy):getMapById(arg1_129)

	assert(arg0_129.contextData.map, "map cannot be nil " .. arg1_129)

	if arg0_129.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_129.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_129.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_129.contextData.map.remasterId, arg1_129)
		PlayerPrefs.Save()
	end

	arg0_129:RecordLastMapOnExit()
	arg0_129:updateMap(var0_129)
	arg0_129:tryPlayMapStory()
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

function var0_0.SwitchMapBuilder(arg0_130, arg1_130)
	if arg0_130.mapBuilder and arg0_130.mapBuilder:GetType() ~= arg1_130 then
		arg0_130.mapBuilder.buffer:Hide()
	end

	local var0_130 = arg0_130:GetMapBuilderInBuffer(arg1_130)

	arg0_130.mapBuilder = var0_130

	var0_130.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_131, arg1_131)
	if not arg0_131.mbDict[arg1_131] then
		local var0_131 = _G[var6_0[arg1_131]]

		assert(var0_131, "Missing MapBuilder of type " .. (arg1_131 or "NIL"))

		arg0_131.mbDict[arg1_131] = var0_131.New(arg0_131._tf, arg0_131)
		arg0_131.mbDict[arg1_131].isFrozen = arg0_131:isfrozen()

		arg0_131.mbDict[arg1_131]:Load()
	end

	return arg0_131.mbDict[arg1_131]
end

function var0_0.updateMap(arg0_132, arg1_132)
	local var0_132 = arg0_132.contextData.map
	local var1_132 = var0_132:getConfig("anchor")
	local var2_132

	if var1_132 == "" then
		var2_132 = Vector2(0.5, 0.5)
	else
		var2_132 = Vector2(unpack(var1_132))
	end

	arg0_132.map.pivot = var2_132

	local var3_132 = var0_132:getConfig("uifx")

	for iter0_132 = 1, arg0_132.UIFXList.childCount do
		local var4_132 = arg0_132.UIFXList:GetChild(iter0_132 - 1)

		setActive(var4_132, var4_132.name == var3_132)
	end

	arg0_132:SwitchMapBG(var0_132, arg1_132)
	arg0_132:PlayBGM()

	local var5_132 = arg0_132.contextData.map:getConfig("ui_type")

	arg0_132:SwitchMapBuilder(var5_132)
	seriesAsync({
		function(arg0_133)
			arg0_132.mapBuilder:CallbackInvoke(arg0_133)
		end,
		function(arg0_134)
			arg0_132.mapBuilder:UpdateMapVO(var0_132)
			arg0_132.mapBuilder:UpdateView()
			arg0_132.mapBuilder:UpdateMapItems()
			arg0_132.mapBuilder:PlayEnterAnim()
		end
	})

	local var6_132 = table.keyof(LevelTools.GetSuggestionMapIDList(var0_132.id), var0_132.id)

	setActive(arg0_132.suggestionBtn, var6_132 ~= nil)
end

function var0_0.UpdateSwitchMapButton(arg0_135)
	local var0_135 = arg0_135.contextData.map
	local var1_135 = getProxy(ChapterProxy)
	local var2_135 = var1_135:getMapById(var0_135.id - 1)
	local var3_135 = var1_135:getMapById(var0_135.id + 1)

	setActive(arg0_135.btnPrev, tobool(var2_135))
	setActive(arg0_135.btnNext, tobool(var3_135))

	local var4_135 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_135.btnPrevCol, var2_135 and Color.white or var4_135)
	setImageColor(arg0_135.btnNextCol, var3_135 and var3_135:isUnlock() and Color.white or var4_135)
end

function var0_0.tryPlayMapStory(arg0_136)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_137)
			local var0_137 = arg0_136.contextData.map:getConfig("enter_story")

			if var0_137 and var0_137 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_137) and not arg0_136.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_137 = tonumber(var0_137)

				if var1_137 and var1_137 > 0 then
					arg0_136:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_137)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_137, arg0_137)
				end

				return
			end

			arg0_137()
		end,
		function(arg0_138)
			local var0_138 = arg0_136.contextData.map:getConfig("guide_id")

			if var0_138 and var0_138 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_138, nil, arg0_138)

				return
			end

			arg0_138()
		end,
		function(arg0_139)
			if arg0_136.actAtelierBuffBtn ~= nil and isActive(arg0_136.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_139 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_139

				if var0_139 then
					var1_139 = {
						1,
						2
					}
				else
					var1_139 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_139)
			else
				arg0_139()
			end
		end,
		function(arg0_140)
			if arg0_136.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_136.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_141, arg1_141, arg2_141, arg3_141)
	arg0_141.uiAnims = arg0_141.uiAnims or {}

	local var0_141 = arg0_141.uiAnims[arg1_141]

	local function var1_141()
		arg0_141.playing = true

		arg0_141:frozen()
		var0_141:SetActive(true)

		local var0_142 = tf(var0_141)

		pg.UIMgr.GetInstance():OverlayPanel(var0_142)

		if arg3_141 then
			arg3_141(var0_141)
		end

		var0_142:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_143)
			arg0_141.playing = false

			if arg2_141 then
				arg2_141(var0_141)
			end

			arg0_141:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_141 then
		PoolMgr.GetInstance():GetUI(arg1_141, true, function(arg0_144)
			arg0_144:SetActive(true)

			arg0_141.uiAnims[arg1_141] = arg0_144
			var0_141 = arg0_141.uiAnims[arg1_141]

			var1_141()
		end)
	else
		var1_141()
	end
end

function var0_0.displaySpResult(arg0_145, arg1_145, arg2_145)
	setActive(arg0_145.spResult, true)
	arg0_145:DisplaySPAnim(arg1_145 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_146)
		onButton(arg0_145, arg0_146, function()
			removeOnButton(arg0_146)
			setActive(arg0_146, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_146, arg0_145._tf)
			arg0_145:hideSpResult()
			arg2_145()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_148)
	setActive(arg0_148.spResult, false)
end

function var0_0.displayBombResult(arg0_149, arg1_149)
	setActive(arg0_149.spResult, true)
	arg0_149:DisplaySPAnim("SpBombRet", function(arg0_150)
		onButton(arg0_149, arg0_150, function()
			removeOnButton(arg0_150)
			setActive(arg0_150, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_150, arg0_149._tf)
			arg0_149:hideSpResult()
			arg1_149()
		end, SFX_PANEL)
	end, function(arg0_152)
		setText(arg0_152.transform:Find("right/name_bg/en"), arg0_149.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_153, arg1_153, arg2_153)
	arg0_153.contextData.chapterLoopFlag = arg2_153

	local var0_153 = getProxy(ChapterProxy):getChapterById(arg1_153, true)

	if var0_153:getConfig("type") == Chapter.CustomFleet then
		arg0_153:displayFleetEdit(var0_153)

		return
	end

	if #var0_153:getNpcShipByType(1) > 0 then
		arg0_153:emit(LevelMediator2.ON_TRACKING, arg1_153)

		return
	end

	arg0_153:displayFleetSelect(var0_153)
end

function var0_0.DisplayLevelInfoPanel(arg0_154, arg1_154, arg2_154)
	seriesAsync({
		function(arg0_155)
			if not arg0_154.levelInfoView:GetLoaded() then
				arg0_154:frozen()
				arg0_154.levelInfoView:Load()
				arg0_154.levelInfoView:CallbackInvoke(function()
					arg0_154:unfrozen()
					arg0_155()
				end)

				return
			end

			arg0_155()
		end,
		function(arg0_157)
			local function var0_157(arg0_158, arg1_158)
				arg0_154:hideChapterPanel()
				arg0_154:OnLevelInfoPanelConfirm(arg0_158, arg1_158)
			end

			local function var1_157()
				arg0_154:hideChapterPanel()
			end

			local var2_157 = getProxy(ChapterProxy):getChapterById(arg1_154, true)

			if getProxy(ChapterProxy):getMapById(var2_157:getConfig("map")):isSkirmish() and #var2_157:getNpcShipByType(1) > 0 then
				var0_157(false)

				return
			end

			arg0_154.levelInfoView:set(arg1_154, arg2_154)
			arg0_154.levelInfoView:setCBFunc(var0_157, var1_157)
			arg0_154.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_160)
	if arg0_160.levelInfoView:isShowing() then
		arg0_160.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_161)
	arg0_161.levelInfoView:Destroy()

	arg0_161.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_162, arg1_162, arg2_162, arg3_162)
	seriesAsync({
		function(arg0_163)
			if not arg0_162.levelInfoSPView then
				arg0_162.levelInfoSPView = LevelInfoSPView.New(arg0_162.topPanel, arg0_162.event, arg0_162.contextData)

				arg0_162.levelInfoSPView:RegisterView(arg0_162)
				arg0_162:frozen()
				arg0_162.levelInfoSPView:Load()
				arg0_162.levelInfoSPView:CallbackInvoke(function()
					arg0_162:unfrozen()
					arg0_163()
				end)

				return
			end

			arg0_163()
		end,
		function(arg0_165)
			local function var0_165(arg0_166, arg1_166)
				arg0_162:HideLevelInfoSPPanel()
				arg0_162:OnLevelInfoPanelConfirm(arg0_166, arg1_166)
			end

			local function var1_165()
				arg0_162:HideLevelInfoSPPanel()
			end

			arg0_162.levelInfoSPView:SetChapterGroupInfo(arg2_162)
			arg0_162.levelInfoSPView:set(arg1_162, arg3_162)
			arg0_162.levelInfoSPView:setCBFunc(var0_165, var1_165)
			arg0_162.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_168)
	if arg0_168.levelInfoSPView and arg0_168.levelInfoSPView:isShowing() then
		arg0_168.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_169)
	if not arg0_169.levelInfoSPView then
		return
	end

	arg0_169.levelInfoSPView:Destroy()

	arg0_169.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_170, arg1_170)
	local var0_170 = arg0_170.contextData.selectedFleetIDs or arg1_170:GetDefaultFleetIndex()

	arg1_170 = Clone(arg1_170)
	arg1_170.loopFlag = arg0_170.contextData.chapterLoopFlag

	arg0_170.levelFleetView:updateSpecialOperationTickets(arg0_170.spTickets)
	arg0_170.levelFleetView:Load()
	arg0_170.levelFleetView:ActionInvoke("setHardShipVOs", arg0_170.shipVOs)
	arg0_170.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_170.openedCommanerSystem)
	arg0_170.levelFleetView:ActionInvoke("set", arg1_170, arg0_170.fleets, var0_170)
	arg0_170.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_171)
	if arg0_171.levelCMDFormationView:isShowing() then
		arg0_171.levelCMDFormationView:Hide()
	end

	if arg0_171.levelFleetView then
		arg0_171.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_172)
	arg0_172.levelCMDFormationView = LevelCMDFormationView.New(arg0_172.topPanel, arg0_172.event, arg0_172.contextData)
end

function var0_0.destroyFleetSelect(arg0_173)
	if not arg0_173.levelFleetView then
		return
	end

	arg0_173.levelFleetView:Destroy()

	arg0_173.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_174, arg1_174)
	arg1_174 = Clone(arg1_174)
	arg1_174.loopFlag = arg0_174.contextData.chapterLoopFlag

	arg0_174.levelFleetView:updateSpecialOperationTickets(arg0_174.spTickets)
	arg0_174.levelFleetView:Load()
	arg0_174.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_174.openedCommanerSystem)
	arg0_174.levelFleetView:ActionInvoke("setHardShipVOs", arg0_174.shipVOs)
	arg0_174.levelFleetView:ActionInvoke("setOnHard", arg1_174)
	arg0_174.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_175)
	arg0_175:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_176)
	arg0_176:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_177, arg1_177)
	if not arg0_177.levelFleetView then
		return
	end

	assert(arg0_177.levelFleetView:GetLoaded())

	local var0_177 = arg0_177.levelFleetView:IsSelectMode()
	local var1_177

	if var0_177 then
		arg0_177.levelFleetView:ActionInvoke("set", arg1_177 or arg0_177.levelFleetView.chapter, arg0_177.fleets, arg0_177.levelFleetView:getSelectIds())

		if arg0_177.levelCMDFormationView:isShowing() then
			local var2_177 = arg0_177.levelCMDFormationView.fleet.id

			var1_177 = arg0_177.fleets[var2_177]
		end
	else
		arg0_177.levelFleetView:ActionInvoke("setOnHard", arg1_177 or arg0_177.levelFleetView.chapter)

		if arg0_177.levelCMDFormationView:isShowing() then
			local var3_177 = arg0_177.levelCMDFormationView.fleet.id

			var1_177 = arg1_177:wrapEliteFleet(var3_177)
		end
	end

	if var1_177 then
		arg0_177.levelCMDFormationView:ActionInvoke("updateFleet", var1_177)
	end
end

function var0_0.setChapter(arg0_178, arg1_178)
	local var0_178

	if arg1_178 then
		var0_178 = arg1_178.id
	end

	arg0_178.contextData.chapterId = var0_178
	arg0_178.contextData.chapterVO = arg1_178
end

function var0_0.switchToChapter(arg0_179, arg1_179)
	if not ResList.ChapterResConst.IsActive(arg1_179) then
		return
	end

	if arg0_179.contextData.mapIdx ~= arg1_179:getConfig("map") then
		arg0_179:setMap(arg1_179:getConfig("map"))
	end

	arg0_179:setChapter(arg1_179)

	arg0_179.leftCanvasGroup.blocksRaycasts = false
	arg0_179.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_179.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_179:DestroyLevelStageView()

	if not arg0_179.levelStageView then
		arg0_179.levelStageView = LevelStageView.New(arg0_179.topPanel, arg0_179.event, arg0_179.contextData)

		arg0_179.levelStageView:Load()

		arg0_179.levelStageView.isFrozen = arg0_179:isfrozen()
	end

	arg0_179:frozen()

	local function var0_179()
		seriesAsync({
			function(arg0_181)
				arg0_179:downloadChapterRes(arg1_179, arg0_181)
			end,
			function(arg0_182)
				arg0_179.mapBuilder:CallbackInvoke(arg0_182)
			end,
			function(arg0_183)
				setActive(arg0_179.clouds, false)
				arg0_179.mapBuilder:HideFloat()
				arg0_179:BlurPanel(arg0_179.topPanel, {
					blurCamList = {
						pg.UIMgr.CameraUI
					}
				})
				arg0_179.levelStageView:updateStageInfo()
				arg0_179.levelStageView:updateAmbushRate(arg1_179.fleet.line, true)
				arg0_179.levelStageView:updateStageAchieve()
				arg0_179.levelStageView:updateStageBarrier()
				arg0_179.levelStageView:updateBombPanel()
				arg0_179.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_183)
			end,
			function(arg0_184)
				if arg0_179.exited then
					return
				end

				arg0_179.levelStageView:updateStageStrategy()

				arg0_179.canvasGroup.blocksRaycasts = arg0_179.frozenCount == 0

				onNextTick(arg0_184)
			end,
			function(arg0_185)
				if arg0_179.exited then
					return
				end

				arg0_179.levelStageView:updateStageFleet()
				arg0_179.levelStageView:updateSupportFleet()
				arg0_179.levelStageView:updateFleetBuff()
				onNextTick(arg0_185)
			end,
			function(arg0_186)
				if arg0_179.exited then
					return
				end

				parallelAsync({
					function(arg0_187)
						local var0_187 = arg1_179:getConfig("scale")
						local var1_187 = LeanTween.value(go(arg0_179.map), arg0_179.map.localScale, Vector3.New(var0_187[3], var0_187[3], 1), var1_0):setOnUpdateVector3(function(arg0_188)
							arg0_179.map.localScale = arg0_188
							arg0_179.float.localScale = arg0_188
						end):setOnComplete(System.Action(function()
							arg0_179.mapBuilder:ShowFloat()
							arg0_179.mapBuilder:Hide()
							arg0_187()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_179:RecordTween("mapScale", var1_187.uniqueId)

						local var2_187 = LeanTween.value(go(arg0_179.map), arg0_179.map.pivot, Vector2.New(math.clamp(var0_187[1] - 0.5, 0, 1), math.clamp(var0_187[2] - 0.5, 0, 1)), var1_0)

						var2_187:setOnUpdateVector2(function(arg0_190)
							arg0_179.map.pivot = arg0_190
							arg0_179.float.pivot = arg0_190
						end):setEase(LeanTweenType.easeOutSine)
						arg0_179:RecordTween("mapPivot", var2_187.uniqueId)
						shiftPanel(arg0_179.leftChapter, -arg0_179.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_179.rightChapter, arg0_179.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_179.topChapter, 0, arg0_179.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_179.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_191)
						arg0_179:PlayBGM()

						local var0_191 = {}
						local var1_191 = arg1_179:getConfig("bg")

						if var1_191 and #var1_191 > 0 then
							var0_191[1] = {
								BG = var1_191
							}
						end

						arg0_179:SwitchBG(var0_191, arg0_191)
					end
				}, function()
					onNextTick(arg0_186)
				end)
			end,
			function(arg0_193)
				if arg0_179.exited then
					return
				end

				setActive(arg0_179.topChapter, false)
				setActive(arg0_179.leftChapter, false)
				setActive(arg0_179.rightChapter, false)

				arg0_179.leftCanvasGroup.blocksRaycasts = true
				arg0_179.rightCanvasGroup.blocksRaycasts = true

				arg0_179:initGrid(arg0_193)
			end,
			function(arg0_194)
				if arg0_179.exited then
					return
				end

				arg0_179.levelStageView:SetGrid(arg0_179.grid)

				arg0_179.contextData.huntingRangeVisibility = arg0_179.contextData.huntingRangeVisibility - 1

				arg0_179.grid:toggleHuntingRange()

				local var0_194 = arg1_179:getConfig("pop_pic")

				if var0_194 and #var0_194 > 0 and arg0_179.FirstEnterChapter == arg1_179.id then
					arg0_179:doPlayAnim(var0_194, function(arg0_195)
						setActive(arg0_195, false)

						if arg0_179.exited then
							return
						end

						arg0_194()
					end)
				else
					arg0_194()
				end
			end,
			function(arg0_196)
				arg0_179.levelStageView:tryAutoAction(arg0_196)
			end,
			function(arg0_197)
				if arg0_179.exited then
					return
				end

				arg0_179:unfrozen()

				if arg0_179.FirstEnterChapter then
					arg0_179:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_179.subAutoAttack)
				end

				arg0_179.FirstEnterChapter = nil

				arg0_197()
			end,
			function(arg0_198)
				if arg1_179:NeedSupportSubmarineStage() then
					arg0_179.levelStageView:TryEnterChapterSupportSubmarineStage(arg0_198)
				else
					arg0_198()
				end
			end
		}, function()
			arg0_179.levelStageView:tryAutoTrigger(true)
		end)
	end

	arg0_179.levelStageView:ActionInvoke("SetSeriesOperation", var0_179)
	arg0_179.levelStageView:ActionInvoke("SetPlayer", arg0_179.player)
	arg0_179.levelStageView:ActionInvoke("SwitchToChapter", arg1_179)
end

function var0_0.switchToMap(arg0_200, arg1_200)
	arg0_200:frozen()
	arg0_200:destroyGrid()
	arg0_200:setChapter(nil)
	LeanTween.cancel(go(arg0_200.map))

	local var0_200 = LeanTween.value(go(arg0_200.map), arg0_200.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_201)
		arg0_200.map.localScale = arg0_201
		arg0_200.float.localScale = arg0_201
	end):setOnComplete(System.Action(function()
		arg0_200:unfrozen()
		arg0_200.mapBuilder:PlayEnterAnim()
		existCall(arg1_200)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_200:RecordTween("mapScale", var0_200.uniqueId)

	local var1_200 = arg0_200.contextData.map:getConfig("anchor")
	local var2_200

	if var1_200 == "" then
		var2_200 = Vector2(0.5, 0.5)
	else
		var2_200 = Vector2(unpack(var1_200))
	end

	local var3_200 = LeanTween.value(go(arg0_200.map), arg0_200.map.pivot, var2_200, var1_0)

	var3_200:setOnUpdateVector2(function(arg0_203)
		arg0_200.map.pivot = arg0_203
		arg0_200.float.pivot = arg0_203
	end):setEase(LeanTweenType.easeOutSine)
	arg0_200:RecordTween("mapPivot", var3_200.uniqueId)
	setActive(arg0_200.topChapter, true)
	setActive(arg0_200.leftChapter, true)
	setActive(arg0_200.rightChapter, true)
	shiftPanel(arg0_200.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_200.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_200.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_200.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_200.levelStageView then
		arg0_200.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_200:DestroyLevelStageView()
		end)
		arg0_200.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_200:SwitchMapBG(arg0_200.contextData.map)
	arg0_200:PlayBGM()
	seriesAsync({
		function(arg0_205)
			arg0_200.mapBuilder:CallbackInvoke(arg0_205)
		end,
		function(arg0_206)
			arg0_200.mapBuilder:Show()
			arg0_200.mapBuilder:UpdateView()
			arg0_200.mapBuilder:UpdateMapItems()
		end
	})
	arg0_200:UnOverlayPanel(arg0_200.topPanel, arg0_200._tf)

	arg0_200.canvasGroup.blocksRaycasts = arg0_200.frozenCount == 0
	arg0_200.canvasGroup.interactable = true

	if arg0_200.ambushWarning and arg0_200.ambushWarning.activeSelf then
		arg0_200.ambushWarning:SetActive(false)
		arg0_200:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_207, arg1_207, arg2_207, arg3_207)
	if not arg1_207 or #arg1_207 <= 0 then
		existCall(arg2_207)

		return
	elseif arg3_207 then
		-- block empty
	elseif table.equal(arg0_207.currentBG, arg1_207) then
		return
	end

	arg0_207.currentBG = arg1_207

	for iter0_207, iter1_207 in ipairs(arg0_207.mapGroup) do
		arg0_207.loader:ClearRequest(iter1_207)
	end

	table.clear(arg0_207.mapGroup)

	local var0_207 = {}

	table.ParallelIpairsAsync(arg1_207, function(arg0_208, arg1_208, arg2_208)
		local var0_208 = arg0_207.mapTFs[arg0_208]
		local var1_208 = arg1_208.bgPrefix and arg1_208.bgPrefix .. "/" or "levelmap/"
		local var2_208 = arg0_207.loader:GetSpriteDirect(var1_208 .. arg1_208.BG, "", function(arg0_209)
			var0_207[arg0_208] = arg0_209

			arg2_208()
		end, var0_208)

		table.insert(arg0_207.mapGroup, var2_208)
		arg0_207:updateCouldAnimator(arg1_208.Animator, arg0_208)
	end, function()
		for iter0_210, iter1_210 in ipairs(arg0_207.mapTFs) do
			setImageSprite(iter1_210, var0_207[iter0_210])
			setActive(iter1_210, arg1_207[iter0_210])
			SetCompomentEnabled(iter1_210, typeof(Image), true)
		end

		existCall(arg2_207)
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

function var0_0.ClearMapTransitions(arg0_211)
	if not arg0_211.mapTransitions then
		return
	end

	for iter0_211, iter1_211 in pairs(arg0_211.mapTransitions) do
		if iter1_211 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_211, iter0_211, iter1_211, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_211, iter0_211)
		end
	end

	arg0_211.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_212, arg1_212, arg2_212, arg3_212)
	local var0_212, var1_212, var2_212 = arg0_212:GetMapBG(arg1_212, arg2_212)
	local var3_212 = {}

	if var1_212 then
		table.insert(var3_212, function(arg0_213)
			arg0_212:PlayMapTransition("LevelMapTransition_" .. var1_212, var2_212, arg0_213)
		end)
	end

	seriesAsync(var3_212, function()
		arg0_212:SwitchBGMapType(arg1_212:getConfig("pos_type"))
		arg0_212:SwitchBG(var0_212, nil, arg3_212)
	end)
end

function var0_0.SwitchBGMapType(arg0_215, arg1_215)
	if arg0_215.posType == arg1_215 then
		return
	end

	for iter0_215, iter1_215 in ipairs({
		arg0_215.map,
		arg0_215.float
	}) do
		local var0_215 = GetOrAddComponent(iter1_215, typeof(AspectRatioFitter))

		var0_215.aspectRatio = 1.77777777777778
		var0_215.enabled = arg1_215 == 0

		if arg1_215 == 1 then
			iter1_215.anchorMin = Vector2(0.5, 0.5)
			iter1_215.anchorMax = Vector2(0.5, 0.5)

			setSizeDelta(var0_215, {
				x = 2520,
				y = 1440
			})
		end
	end
end

function var0_0.GetMapBG(arg0_216, arg1_216, arg2_216)
	if not table.contains(var7_0, arg1_216.id) then
		return {
			arg0_216:GetMapElement(arg1_216)
		}
	end

	local var0_216 = arg1_216.id
	local var1_216 = table.indexof(var7_0, var0_216) - 1
	local var2_216 = bit.lshift(bit.rshift(var1_216, 1), 1) + 1
	local var3_216 = {
		var7_0[var2_216],
		var7_0[var2_216 + 1]
	}
	local var4_216 = _.map(var3_216, function(arg0_217)
		return getProxy(ChapterProxy):getMapById(arg0_217)
	end)

	if _.all(var4_216, function(arg0_218)
		return arg0_218:isAllChaptersClear()
	end) then
		local var5_216 = {
			arg0_216:GetMapElement(arg1_216)
		}

		if not arg2_216 or math.abs(var0_216 - arg2_216) ~= 1 then
			return var5_216
		end

		local var6_216 = var9_0[bit.rshift(var2_216 - 1, 1) + 1]
		local var7_216 = bit.band(var1_216, 1) == 1

		return var5_216, var6_216, var7_216
	else
		local var8_216 = 0

		;(function()
			local var0_219 = var4_216[1]:getChapters()

			for iter0_219, iter1_219 in ipairs(var0_219) do
				if not iter1_219:isClear() then
					return
				end

				var8_216 = var8_216 + 1
			end

			if not var4_216[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_216 = var8_216 + 1

			local var1_219 = var4_216[2]:getChapters()

			for iter2_219, iter3_219 in ipairs(var1_219) do
				if not iter3_219:isClear() then
					return
				end

				var8_216 = var8_216 + 1
			end
		end)()

		local var9_216

		if var8_216 > 0 then
			local var10_216 = var8_0[bit.rshift(var2_216 - 1, 1) + 1]

			var9_216 = {
				{
					BG = "map_" .. var10_216[1],
					Animator = var10_216[2]
				},
				{
					BG = "map_" .. var10_216[3] + var8_216,
					Animator = var10_216[4]
				}
			}
		else
			var9_216 = {
				arg0_216:GetMapElement(arg1_216)
			}
		end

		return var9_216
	end
end

function var0_0.GetMapElement(arg0_220, arg1_220)
	local var0_220 = arg1_220:getConfig("bg")
	local var1_220 = arg1_220:getConfig("ani_controller")

	if var1_220 and #var1_220 > 0 then
		(function()
			local var0_221 = getProxy(ChapterProxy)

			for iter0_221, iter1_221 in ipairs(var1_220) do
				local var1_221 = _.rest(iter1_221[2], 2)

				for iter2_221, iter3_221 in ipairs(var1_221) do
					if string.find(iter3_221, "^map_") and iter1_221[1] == var3_0 then
						local var2_221 = iter1_221[2][1]
						local var3_221 = false

						for iter4_221, iter5_221 in ipairs(var2_221) do
							local var4_221 = var0_221:GetChapterItemById(iter5_221)

							if var4_221 and var4_221:isClear() then
								var3_221 = true

								break
							end
						end

						if not var3_221 then
							var0_220 = iter3_221

							return
						end
					end
				end
			end
		end)()
	end

	local var2_220 = {
		BG = var0_220
	}

	var2_220.Animator, var2_220.AnimatorController = arg0_220:GetMapAnimator(arg1_220)

	return var2_220
end

function var0_0.GetMapAnimator(arg0_222, arg1_222)
	local var0_222 = arg1_222:getConfig("ani_name")

	if arg1_222:getConfig("animtor") == 1 and var0_222 and #var0_222 > 0 then
		local var1_222 = arg1_222:getConfig("ani_controller")

		if var1_222 and #var1_222 > 0 then
			(function()
				local var0_223 = getProxy(ChapterProxy)

				for iter0_223, iter1_223 in ipairs(var1_222) do
					local var1_223 = _.rest(iter1_223[2], 2)

					for iter2_223, iter3_223 in ipairs(var1_223) do
						if string.find(iter3_223, "^effect_") and iter1_223[1] == var3_0 then
							local var2_223 = iter1_223[2][1]
							local var3_223 = false

							for iter4_223, iter5_223 in ipairs(var2_223) do
								local var4_223 = var0_223:GetChapterItemById(iter5_223)

								if var4_223 and var4_223:isClear() then
									var3_223 = true

									break
								end
							end

							if not var3_223 then
								var0_222 = "map_" .. string.sub(iter3_223, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_222, var1_222
	end
end

function var0_0.PlayMapTransition(arg0_224, arg1_224, arg2_224, arg3_224, arg4_224)
	arg0_224.mapTransitions = arg0_224.mapTransitions or {}

	local var0_224

	local function var1_224()
		arg0_224:frozen()
		existCall(arg3_224, var0_224)
		var0_224:SetActive(true)

		local var0_225 = tf(var0_224)

		pg.UIMgr.GetInstance():OverlayPanel(var0_225)
		var0_224:GetComponent(typeof(Animator)):Play(arg2_224 and "Sequence" or "Inverted", -1, 0)
		var0_225:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_226)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_225, arg0_224._tf)
			existCall(arg4_224, var0_224)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_224, arg1_224, var0_224)

			arg0_224.mapTransitions[arg1_224] = false

			arg0_224:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_224, arg1_224, true, function(arg0_227)
		var0_224 = arg0_227
		arg0_224.mapTransitions[arg1_224] = arg0_227

		var1_224()
	end)
end

function var0_0.DestroyLevelStageView(arg0_228)
	if arg0_228.levelStageView then
		arg0_228.levelStageView:Destroy()

		arg0_228.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_229, arg1_229)
	arg0_229.levelAmbushView = LevelAmbushView.New(arg0_229.topPanel, arg0_229.event, arg0_229.contextData)

	arg0_229.levelAmbushView:Load()
	arg0_229.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_229)
end

function var0_0.hideAmbushInfo(arg0_230)
	if arg0_230.levelAmbushView then
		arg0_230.levelAmbushView:Destroy()

		arg0_230.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_231, arg1_231)
	arg0_231:frozen()

	local function var0_231()
		arg0_231.ambushWarning:SetActive(true)

		local var0_232 = tf(arg0_231.ambushWarning)

		var0_232:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_232:SetSiblingIndex(1)

		local var1_232 = var0_232:GetComponent("DftAniEvent")

		var1_232:SetTriggerEvent(function(arg0_233)
			arg1_231()
		end)
		var1_232:SetEndEvent(function(arg0_234)
			arg0_231.ambushWarning:SetActive(false)
			arg0_231:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_231.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_236)
			arg0_236:SetActive(true)

			arg0_231.ambushWarning = arg0_236

			var0_231()
		end)
	else
		var0_231()
	end
end

function var0_0.destroyAmbushWarn(arg0_237)
	if arg0_237.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_237.ambushWarning)

		arg0_237.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_238, arg1_238)
	arg0_238.levelStrategyView = LevelStrategyView.New(arg0_238.topPanel, arg0_238.event, arg0_238.contextData)

	arg0_238.levelStrategyView:Load()
	arg0_238.levelStrategyView:ActionInvoke("set", arg1_238)

	local function var0_238()
		local var0_239 = arg0_238.contextData.chapterVO.fleet
		local var1_239 = pg.strategy_data_template[arg1_238.id]

		if not var0_239:canUseStrategy(arg1_238) then
			return
		end

		local var2_239 = var0_239:getNextStgUser(arg1_238.id)

		if var1_239.type == ChapterConst.StgTypeForm then
			arg0_238:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_239,
				arg1 = arg1_238.id
			})
		elseif var1_239.type == ChapterConst.StgTypeConsume then
			arg0_238:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_239,
				arg1 = arg1_238.id
			})
		end

		arg0_238:hideStrategyInfo()
	end

	local function var1_238()
		arg0_238:hideStrategyInfo()
	end

	arg0_238.levelStrategyView:ActionInvoke("setCBFunc", var0_238, var1_238)
end

function var0_0.hideStrategyInfo(arg0_241)
	if arg0_241.levelStrategyView then
		arg0_241.levelStrategyView:Destroy()

		arg0_241.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_242, arg1_242)
	local var0_242 = arg0_242.contextData.chapterVO
	local var1_242 = getProxy(ChapterProxy)
	local var2_242
	local var3_242
	local var4_242
	local var5_242
	local var6_242 = var1_242.repairTimes
	local var7_242, var8_242, var9_242 = ChapterConst.GetRepairParams()

	arg0_242.levelRepairView = LevelRepairView.New(arg0_242.topPanel, arg0_242.event, arg0_242.contextData)

	arg0_242.levelRepairView:Load()
	arg0_242.levelRepairView:ActionInvoke("set", var6_242, var7_242, var8_242, var9_242)

	local function var10_242()
		if var7_242 - math.min(var6_242, var7_242) == 0 and arg0_242.player:getTotalGem() < var9_242 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_242:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_242.fleet.id,
			arg1 = arg1_242.id
		})
		arg0_242:hideRepairWindow()
	end

	local function var11_242()
		arg0_242:hideRepairWindow()
	end

	arg0_242.levelRepairView:ActionInvoke("setCBFunc", var10_242, var11_242)
end

function var0_0.hideRepairWindow(arg0_245)
	if arg0_245.levelRepairView then
		arg0_245.levelRepairView:Destroy()

		arg0_245.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_246, arg1_246)
	arg0_246.levelRemasterView:Load()

	local function var0_246(arg0_247)
		arg0_246:ShowSelectedMap(arg0_247)
	end

	arg0_246.levelRemasterView:ActionInvoke("Show")
	arg0_246.levelRemasterView:ActionInvoke("set", var0_246, arg1_246)
end

function var0_0.hideRemasterPanel(arg0_248)
	if arg0_248.levelRemasterView:isShowing() then
		arg0_248.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_249, arg1_249)
	local var0_249 = arg0_249.contextData.chapterVO

	if not var0_249 then
		return
	end

	arg0_249:enableLevelCamera()
	setActive(arg0_249.uiMain, true)

	arg0_249.levelGrid.localEulerAngles = Vector3(var0_249.theme.angle, 0, 0)
	arg0_249.grid = LevelGrid.New(arg0_249.dragLayer)

	arg0_249.grid:attach(arg0_249)
	arg0_249.grid:ExtendItem("shipTpl", arg0_249.shipTpl)
	arg0_249.grid:ExtendItem("subTpl", arg0_249.subTpl)
	arg0_249.grid:ExtendItem("transportTpl", arg0_249.transportTpl)
	arg0_249.grid:ExtendItem("enemyTpl", arg0_249.enemyTpl)
	arg0_249.grid:ExtendItem("championTpl", arg0_249.championTpl)
	arg0_249.grid:ExtendItem("oniTpl", arg0_249.oniTpl)
	arg0_249.grid:ExtendItem("arrowTpl", arg0_249.arrowTarget)
	arg0_249.grid:ExtendItem("destinationMarkTpl", arg0_249.destinationMarkTpl)

	function arg0_249.grid.onShipStepChange(arg0_250)
		arg0_249.levelStageView:updateAmbushRate(arg0_250)
	end

	arg0_249.grid:initAll(arg1_249)
end

function var0_0.destroyGrid(arg0_251)
	if arg0_251.grid then
		arg0_251.grid:detach()

		arg0_251.grid = nil

		arg0_251:disableLevelCamera()
		setActive(arg0_251.dragLayer, true)
		setActive(arg0_251.uiMain, false)
	end
end

function var0_0.doTracking(arg0_252, arg1_252)
	arg0_252:frozen()

	local function var0_252()
		arg0_252.radar:SetActive(true)

		local var0_253 = tf(arg0_252.radar)

		var0_253:SetParent(arg0_252.topPanel, false)
		var0_253:SetSiblingIndex(1)
		var0_253:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_254)
			arg0_252.radar:SetActive(false)
			arg0_252:unfrozen()
			arg1_252()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_252.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_255)
			arg0_255:SetActive(true)

			arg0_252.radar = arg0_255

			var0_252()
		end)
	else
		var0_252()
	end
end

function var0_0.destroyTracking(arg0_256)
	if arg0_256.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_256.radar)

		arg0_256.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_257, arg1_257, arg2_257, arg3_257)
	local function var0_257()
		arg0_257.playing = true

		arg0_257:frozen()
		arg0_257.airStrike:SetActive(true)

		local var0_258 = tf(arg0_257.airStrike)

		var0_258:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_258:SetAsLastSibling()
		setActive(var0_258:Find("words/be_striked"), arg1_257 == ChapterConst.SubjectChampion)
		setActive(var0_258:Find("words/strike_enemy"), arg1_257 == ChapterConst.SubjectPlayer)

		local function var1_258()
			arg0_257.playing = false

			SetActive(arg0_257.airStrike, false)

			if arg3_257 then
				arg3_257()
			end

			arg0_257:unfrozen()
		end

		var0_258:GetComponent("DftAniEvent"):SetEndEvent(var1_258)

		if arg2_257 then
			onButton(arg0_257, var0_258, var1_258, SFX_PANEL)
		else
			removeOnButton(var0_258)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_257.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_260)
			arg0_260:SetActive(true)

			arg0_257.airStrike = arg0_260

			var0_257()
		end)
	else
		var0_257()
	end
end

function var0_0.destroyAirStrike(arg0_261)
	if arg0_261.airStrike then
		arg0_261.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_261.airStrike)

		arg0_261.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_262, arg1_262, arg2_262, arg3_262)
	arg0_262.uiAnims = arg0_262.uiAnims or {}

	local var0_262 = arg0_262.uiAnims[arg1_262]

	local function var1_262()
		arg0_262.playing = true

		arg0_262:frozen()
		var0_262:SetActive(true)

		local var0_263 = tf(var0_262)

		pg.UIMgr.GetInstance():OverlayPanel(var0_263)

		if arg3_262 then
			arg3_262(var0_262)
		end

		var0_263:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_264)
			arg0_262.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_263, arg0_262._tf)

			if arg2_262 then
				arg2_262(var0_262)
			end

			arg0_262:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_262 then
		PoolMgr.GetInstance():GetUI(arg1_262, true, function(arg0_265)
			arg0_265:SetActive(true)

			arg0_262.uiAnims[arg1_262] = arg0_265
			var0_262 = arg0_262.uiAnims[arg1_262]

			var1_262()
		end)
	else
		var1_262()
	end
end

function var0_0.destroyUIAnims(arg0_266)
	if arg0_266.uiAnims then
		for iter0_266, iter1_266 in pairs(arg0_266.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_266), arg0_266._tf)
			iter1_266:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_266, iter1_266)
		end

		arg0_266.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_267, arg1_267)
	local function var0_267()
		arg0_267.playing = true

		arg0_267:frozen()
		arg0_267.torpetoAni:SetActive(true)

		local var0_268 = tf(arg0_267.torpetoAni)

		var0_268:SetParent(arg0_267.topPanel, false)
		var0_268:SetAsLastSibling()
		var0_268:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_269)
			arg0_267.playing = false

			SetActive(arg0_267.torpetoAni, false)

			if arg1_267 then
				arg1_267()
			end

			arg0_267:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_267.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_270)
			arg0_270:SetActive(true)

			arg0_267.torpetoAni = arg0_270

			var0_267()
		end)
	else
		var0_267()
	end
end

function var0_0.destroyTorpedo(arg0_271)
	if arg0_271.torpetoAni then
		arg0_271.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_271.torpetoAni)

		arg0_271.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_272, arg1_272, arg2_272, arg3_272)
	arg0_272.strikeAnims = arg0_272.strikeAnims or {}

	local var0_272
	local var1_272
	local var2_272

	local function var3_272()
		if coroutine.status(var2_272) == "suspended" then
			local var0_273, var1_273 = coroutine.resume(var2_272)

			assert(var0_273, debug.traceback(var2_272, var1_273))
		end
	end

	var2_272 = coroutine.create(function()
		arg0_272.playing = true

		arg0_272:frozen()

		local var0_274 = arg0_272.strikeAnims[arg2_272]

		setActive(var0_274, true)

		local var1_274 = tf(var0_274)
		local var2_274 = findTF(var1_274, "torpedo")
		local var3_274 = findTF(var1_274, "mask/painting")
		local var4_274 = findTF(var1_274, "ship")

		setParent(var0_272, var3_274:Find("fitter"), false)
		var1_272:SetParent(var4_274)
		setActive(var4_274, false)
		setActive(var2_274, false)
		var1_274:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_274:SetAsLastSibling()

		local var5_274 = var1_274:GetComponent("DftAniEvent")
		local var6_274 = var1_272:GetSkeletonGraphic()

		var5_274:SetStartEvent(function(arg0_275)
			var1_272:SetAction("attack", 0)

			var6_274.freeze = true
		end)
		var5_274:SetTriggerEvent(function(arg0_276)
			var6_274.freeze = false

			var1_272:SetActionCallBack(function(arg0_277)
				if arg0_277 == "action" then
					-- block empty
				elseif arg0_277 == "finish" then
					var6_274.freeze = true
				end
			end)
		end)
		var5_274:SetEndEvent(function(arg0_278)
			var6_274.freeze = false

			var3_272()
		end)
		onButton(arg0_272, var1_274, var3_272, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_274, arg1_272:getPainting())
		var1_272:SetActionCallBack(nil)

		var6_274.freeze = false

		var1_272:Dispose()
		setActive(var0_274, false)

		arg0_272.playing = false

		arg0_272:unfrozen()

		if arg3_272 then
			arg3_272()
		end
	end)

	local function var4_272()
		if arg0_272.strikeAnims[arg2_272] and var0_272 and var1_272 then
			var3_272()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_272:getPainting(), true, function(arg0_280)
		var0_272 = arg0_280

		ShipExpressionHelper.SetExpression(var0_272, arg1_272:getPainting())
		var4_272()
	end)

	var1_272 = SpineAnimChar.New()

	var1_272:SetPaint(arg1_272:getPrefab())
	var1_272:Load(true, function(arg0_281)
		var1_272:SetLocalScale(Vector3.one)
		var4_272()
	end)

	if not arg0_272.strikeAnims[arg2_272] then
		PoolMgr.GetInstance():GetUI(arg2_272, true, function(arg0_282)
			arg0_272.strikeAnims[arg2_272] = arg0_282

			var4_272()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_283)
	if arg0_283.strikeAnims then
		for iter0_283, iter1_283 in pairs(arg0_283.strikeAnims) do
			iter1_283:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_283, iter1_283)
		end

		arg0_283.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_284, arg1_284, arg2_284, arg3_284)
	arg0_284.strikeAnims = arg0_284.strikeAnims or {}

	local var0_284
	local var1_284

	local function var2_284()
		if coroutine.status(var1_284) == "suspended" then
			local var0_285, var1_285 = coroutine.resume(var1_284)

			assert(var0_285, debug.traceback(var1_284, var1_285))
		end
	end

	var1_284 = coroutine.create(function()
		arg0_284.playing = true

		arg0_284:frozen()

		local var0_286 = arg0_284.strikeAnims[arg2_284]

		setActive(var0_286, true)

		local var1_286 = tf(var0_286)
		local var2_286 = findTF(var1_286, "torpedo")
		local var3_286 = findTF(var1_286, "ship")

		var0_284:SetParent(var3_286)
		setActive(var3_286, false)
		setActive(var2_286, false)
		var1_286:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_286:SetAsLastSibling()

		local var4_286 = var1_286:GetComponent("DftAniEvent")
		local var5_286 = var0_284:GetSkeletonGraphic()

		var4_286:SetStartEvent(function(arg0_287)
			var0_284:SetAction("attack", 0)

			var5_286.freeze = true
		end)
		var4_286:SetTriggerEvent(function(arg0_288)
			var5_286.freeze = false

			var0_284:SetActionCallBack(function(arg0_289)
				if arg0_289 == "action" then
					-- block empty
				elseif arg0_289 == "finish" then
					var5_286.freeze = true
				end
			end)
		end)
		var4_286:SetEndEvent(function(arg0_290)
			var5_286.freeze = false

			var2_284()
		end)
		onButton(arg0_284, var1_286, var2_284, SFX_CANCEL)
		coroutine.yield()
		var0_284:SetActionCallBack(nil)

		var5_286.freeze = false

		var0_284:Dispose()
		setActive(var0_286, false)

		arg0_284.playing = false

		arg0_284:unfrozen()

		if arg3_284 then
			arg3_284()
		end
	end)

	local function var3_284()
		if arg0_284.strikeAnims[arg2_284] and var0_284 then
			var2_284()
		end
	end

	var0_284 = SpineAnimChar.New()

	var0_284:SetPaint(arg1_284:getPrefab())
	var0_284:Load(true, function(arg0_292)
		arg0_292:SetLocalScale(Vector3.one)
		var3_284()
	end)

	if not arg0_284.strikeAnims[arg2_284] then
		PoolMgr.GetInstance():GetUI(arg2_284, true, function(arg0_293)
			arg0_284.strikeAnims[arg2_284] = arg0_293

			var3_284()
		end)
	end
end

function var0_0.doPlayCommander(arg0_294, arg1_294, arg2_294)
	arg0_294:frozen()
	setActive(arg0_294.commanderTinkle, true)

	local var0_294 = arg1_294:getSkills()

	setText(arg0_294.commanderTinkle:Find("name"), #var0_294 > 0 and var0_294[1]:getConfig("name") or "")
	setImageSprite(arg0_294.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_294:getConfig("painting"), ""))

	local var1_294 = arg0_294.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_294.alpha = 0

	local var2_294 = Vector2(248, 237)

	LeanTween.value(go(arg0_294.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_295)
		local var0_295 = arg0_294.commanderTinkle.localPosition

		var0_295.x = var2_294.x + -100 * (1 - arg0_295)
		arg0_294.commanderTinkle.localPosition = var0_295
		var1_294.alpha = arg0_295
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_294.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_296)
		local var0_296 = arg0_294.commanderTinkle.localPosition

		var0_296.x = var2_294.x + 100 * arg0_296
		arg0_294.commanderTinkle.localPosition = var0_296
		var1_294.alpha = 1 - arg0_296
	end)):setOnComplete(System.Action(function()
		if arg2_294 then
			arg2_294()
		end

		arg0_294:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_298, arg1_298, arg2_298, arg3_298)
	local var0_298 = arg0_298.grid:shakeCell(arg1_298)

	if not var0_298 then
		arg3_298()

		return
	end

	arg0_298:easeDamage(var0_298, arg2_298, function()
		arg3_298()
	end)
end

function var0_0.easeDamage(arg0_300, arg1_300, arg2_300, arg3_300)
	arg0_300:frozen()

	local var0_300 = arg0_300.levelCam:WorldToScreenPoint(arg1_300.position)
	local var1_300 = tf(arg0_300:GetDamageText())

	var1_300.position = arg0_300.uiCam:ScreenToWorldPoint(var0_300)

	local var2_300 = var1_300.localPosition

	var2_300.y = var2_300.y + 40
	var2_300.z = 0

	setText(var1_300, arg2_300)

	var1_300.localPosition = var2_300

	LeanTween.value(go(var1_300), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_301)
		local var0_301 = var1_300.localPosition

		var0_301.y = var2_300.y + 60 * arg0_301
		var1_300.localPosition = var0_301

		setTextAlpha(var1_300, 1 - arg0_301)
	end)):setOnComplete(System.Action(function()
		arg0_300:ReturnDamageText(var1_300)
		arg0_300:unfrozen()

		if arg3_300 then
			arg3_300()
		end
	end))
end

function var0_0.easeAvoid(arg0_303, arg1_303, arg2_303)
	arg0_303:frozen()

	local var0_303 = arg0_303.levelCam:WorldToScreenPoint(arg1_303)

	arg0_303.avoidText.position = arg0_303.uiCam:ScreenToWorldPoint(var0_303)

	local var1_303 = arg0_303.avoidText.localPosition

	var1_303.z = 0
	arg0_303.avoidText.localPosition = var1_303

	setActive(arg0_303.avoidText, true)

	local var2_303 = arg0_303.avoidText:Find("avoid")

	LeanTween.value(go(arg0_303.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_304)
		local var0_304 = arg0_303.avoidText.localPosition

		var0_304.y = var1_303.y + 100 * arg0_304
		arg0_303.avoidText.localPosition = var0_304

		setImageAlpha(arg0_303.avoidText, 1 - arg0_304)
		setImageAlpha(var2_303, 1 - arg0_304)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_303.avoidText, false)
		arg0_303:unfrozen()

		if arg2_303 then
			arg2_303()
		end
	end))
end

function var0_0.GetDamageText(arg0_306)
	local var0_306 = table.remove(arg0_306.damageTextPool)

	if not var0_306 then
		var0_306 = Instantiate(arg0_306.damageTextTemplate)

		local var1_306 = tf(arg0_306.damageTextTemplate):GetSiblingIndex()

		setParent(var0_306, tf(arg0_306.damageTextTemplate).parent)
		tf(var0_306):SetSiblingIndex(var1_306 + 1)
	end

	table.insert(arg0_306.damageTextActive, var0_306)
	setActive(var0_306, true)

	return var0_306
end

function var0_0.ReturnDamageText(arg0_307, arg1_307)
	assert(arg1_307)

	if not arg1_307 then
		return
	end

	arg1_307 = go(arg1_307)

	table.removebyvalue(arg0_307.damageTextActive, arg1_307)
	table.insert(arg0_307.damageTextPool, arg1_307)
	setActive(arg1_307, false)
end

function var0_0.resetLevelGrid(arg0_308)
	arg0_308.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_309, arg1_309)
	setActive(arg0_309.curtain, arg1_309)
end

function var0_0.frozen(arg0_310)
	local var0_310 = arg0_310.frozenCount

	arg0_310.frozenCount = arg0_310.frozenCount + 1
	arg0_310.canvasGroup.blocksRaycasts = arg0_310.frozenCount == 0

	if var0_310 == 0 and arg0_310.frozenCount ~= 0 then
		arg0_310:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_311, arg1_311)
	if arg0_311.exited then
		return
	end

	local var0_311 = arg0_311.frozenCount
	local var1_311 = arg1_311 == -1 and arg0_311.frozenCount or arg1_311 or 1

	arg0_311.frozenCount = arg0_311.frozenCount - var1_311
	arg0_311.canvasGroup.blocksRaycasts = arg0_311.frozenCount == 0

	if var0_311 ~= 0 and arg0_311.frozenCount == 0 then
		arg0_311:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_312)
	return arg0_312.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_313)
	arg0_313.levelCamIndices = math.max(arg0_313.levelCamIndices - 1, 0)

	if arg0_313.levelCamIndices == 0 then
		arg0_313.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.disableLevelCamera(arg0_314)
	arg0_314.levelCamIndices = arg0_314.levelCamIndices + 1

	if arg0_314.levelCamIndices > 0 then
		arg0_314.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.RecordTween(arg0_315, arg1_315, arg2_315)
	arg0_315.tweens[arg1_315] = arg2_315
end

function var0_0.DeleteTween(arg0_316, arg1_316)
	local var0_316 = arg0_316.tweens[arg1_316]

	if var0_316 then
		LeanTween.cancel(var0_316)

		arg0_316.tweens[arg1_316] = nil
	end
end

function var0_0.openCommanderPanel(arg0_317, arg1_317, arg2_317, arg3_317)
	local var0_317 = arg2_317.id

	arg0_317.levelCMDFormationView:setCallback(function(arg0_318)
		if not arg3_317 then
			if arg0_318.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_317:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_318.skill)
			elseif arg0_318.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_317.contextData.commanderSelected = {
					chapterId = var0_317,
					fleetId = arg1_317.id
				}

				arg0_317:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_318.pos, arg1_317.id, arg2_317)
				arg0_317:closeCommanderPanel()
			else
				arg0_317:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_318,
					fleetId = arg1_317.id,
					chapterId = var0_317
				}, arg2_317)
			end
		elseif arg0_318.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_317:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_318.skill)
		elseif arg0_318.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_317.contextData.eliteCommanderSelected = {
				index = arg3_317,
				pos = arg0_318.pos,
				chapterId = var0_317
			}

			arg0_317:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_317, arg0_318.pos, arg2_317)
			arg0_317:closeCommanderPanel()
		else
			arg0_317:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_318,
				index = arg3_317,
				chapterId = var0_317
			}, arg2_317)
		end
	end)
	arg0_317.levelCMDFormationView:Load()
	arg0_317.levelCMDFormationView:ActionInvoke("update", arg1_317, arg0_317.commanderPrefabs)
	arg0_317.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_319)
	if arg0_319.levelCMDFormationView:isShowing() then
		arg0_319.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_319.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_320)
	arg0_320.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_321)
	arg0_321.levelCMDFormationView:Destroy()

	arg0_321.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_322, arg1_322)
	arg0_322.spTickets = arg1_322
end

function var0_0.HandleShowMsgBox(arg0_323, arg1_323)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_323)
end

function var0_0.updatePoisonAreaTip(arg0_324)
	local var0_324 = arg0_324.contextData.chapterVO
	local var1_324 = (function(arg0_325)
		local var0_325 = {}
		local var1_325 = pg.map_event_list[var0_324.id] or {}
		local var2_325

		if var0_324:isLoop() then
			var2_325 = var1_325.event_list_loop or {}
		else
			var2_325 = var1_325.event_list or {}
		end

		for iter0_325, iter1_325 in ipairs(var2_325) do
			local var3_325 = pg.map_event_template[iter1_325]

			if var3_325.c_type == arg0_325 then
				table.insert(var0_325, var3_325)
			end
		end

		return var0_325
	end)(ChapterConst.EvtType_Poison)

	if var1_324 then
		for iter0_324, iter1_324 in ipairs(var1_324) do
			local var2_324 = iter1_324.round_gametip

			if var2_324 ~= nil and var2_324 ~= "" and var0_324:getRoundNum() == var2_324[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_324[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_326)
	setActive(arg0_326._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_327)
	local var0_327 = getProxy(ChapterProxy)

	if var0_327 and not arg0_327.contextData.noRecord then
		local var1_327 = arg0_327.contextData.map

		if not var1_327 then
			return
		end

		if var1_327:NeedRecordMap() then
			var0_327:recordLastMap(ChapterProxy.LAST_MAP, var1_327.id)
		end

		if var1_327:isActivity() and not var1_327:isActExtra() then
			var0_327:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_327.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_328)
	local var0_328 = arg0_328.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_328.contextData.map:getConfig("on_activity")) or nil
	local var1_328 = var0_328 and not var0_328:isEnd() and var0_328:GetConfigClientSetting("PTID")
	local var2_328 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var2_328 and not var2_328:isEnd() and var2_328:getConfig("config_client").resId == var1_328 then
		return true
	end

	local var3_328 = var0_328 and var0_328:GetConfigClientPTActivity() or nil

	if var3_328 and getProxy(ActivityProxy):GetShopActivityByRes(var3_328:GetPTDrop()) or nil then
		return true
	end
end

function var0_0.OnStartChapterAuto(arg0_329, arg1_329)
	if arg0_329.levelInfoView:isShowing() then
		arg0_329:hideChapterPanel()
	end

	if arg0_329.levelInfoSPView and arg0_329.levelInfoSPView:isShowing() then
		arg0_329:HideLevelInfoSPPanel()
	end
end

function var0_0.OnEndChapterAuto(arg0_330, arg1_330)
	return
end

function var0_0.OnAddChapterAutoTimeDone(arg0_331)
	if arg0_331.levelInfoView:isShowing() then
		arg0_331.levelInfoView:RefreshChapterAutoPanel()
	end

	if arg0_331.levelInfoSPView and arg0_331.levelInfoSPView:isShowing() then
		arg0_331.levelInfoView:RefreshChapterAutoPanel()
	end
end

function var0_0.ShowChapterAutoDetailPanel(arg0_332, arg1_332)
	arg0_332.chapterAutoDetailPanel:Load()
	arg0_332.chapterAutoDetailPanel:ActionInvoke("Enter", arg1_332)
end

function var0_0.HideChapterAutoDetailPanel(arg0_333)
	if arg0_333.chapterAutoDetailPanel:isShowing() then
		arg0_333.chapterAutoDetailPanel:Hide()
	end
end

function var0_0.DestroyChapterAutoDetailPanel(arg0_334)
	if arg0_334.chapterAutoDetailPanel then
		arg0_334.chapterAutoDetailPanel:Destroy()

		arg0_334.chapterAutoDetailPanel = nil
	end
end

function var0_0.willExit(arg0_335)
	arg0_335:ClearMapTransitions()
	arg0_335.loader:Clear()

	if arg0_335.entranceActivityBg then
		pg.PoolMgr.GetInstance():ReturnPrefab(arg0_335.entranceActivityBgPath, "", arg0_335.entranceActivityBg)

		arg0_335.entranceActivityBg = nil
		arg0_335.entranceActivityBgPath = nil
	end

	if arg0_335.contextData.chapterVO then
		arg0_335:UnOverlayPanel(arg0_335.topPanel, arg0_335._tf)
	end

	if arg0_335.levelFleetView and arg0_335.levelFleetView.selectIds then
		arg0_335.contextData.selectedFleetIDs = {}

		for iter0_335, iter1_335 in pairs(arg0_335.levelFleetView.selectIds) do
			for iter2_335, iter3_335 in pairs(iter1_335) do
				arg0_335.contextData.selectedFleetIDs[#arg0_335.contextData.selectedFleetIDs + 1] = iter3_335
			end
		end
	end

	arg0_335:destroyChapterPanel()
	arg0_335:DestroyLevelInfoSPPanel()
	arg0_335:destroyFleetEdit()
	arg0_335:destroyCommanderPanel()
	arg0_335:DestroyLevelStageView()
	arg0_335:hideRepairWindow()
	arg0_335:hideStrategyInfo()
	arg0_335:hideRemasterPanel()
	arg0_335:hideSpResult()
	arg0_335:destroyGrid()
	arg0_335:destroyAmbushWarn()
	arg0_335:destroyAirStrike()
	arg0_335:destroyTorpedo()
	arg0_335:destroyStrikeAnim()
	arg0_335:destroyTracking()
	arg0_335:destroyUIAnims()
	arg0_335:DestroyChapterAutoDetailPanel()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_335, iter5_335 in pairs(arg0_335.mbDict) do
		iter5_335:Destroy()
	end

	arg0_335.mbDict = nil

	for iter6_335, iter7_335 in pairs(arg0_335.tweens) do
		LeanTween.cancel(iter7_335)
	end

	arg0_335.tweens = nil

	if arg0_335.cloudTimer then
		_.each(arg0_335.cloudTimer, function(arg0_336)
			LeanTween.cancel(arg0_336)
		end)

		arg0_335.cloudTimer = nil
	end

	if arg0_335.newChapterCDTimer then
		arg0_335.newChapterCDTimer:Stop()

		arg0_335.newChapterCDTimer = nil
	end

	for iter8_335, iter9_335 in ipairs(arg0_335.damageTextActive) do
		LeanTween.cancel(iter9_335)
	end

	LeanTween.cancel(go(arg0_335.avoidText))

	arg0_335.map.localScale = Vector3.one
	arg0_335.map.pivot = Vector2(0.5, 0.5)
	arg0_335.float.localScale = Vector3.one
	arg0_335.float.pivot = Vector2(0.5, 0.5)

	for iter10_335, iter11_335 in ipairs(arg0_335.mapTFs) do
		clearImageSprite(iter11_335)
	end

	_.each(arg0_335.cloudRTFs, function(arg0_337)
		clearImageSprite(arg0_337)
	end)
	Destroy(arg0_335.enemyTpl)
	arg0_335:RecordLastMapOnExit()
	arg0_335.levelRemasterView:Destroy()
end

return var0_0
