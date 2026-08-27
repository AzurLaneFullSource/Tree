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
		groupDelta = 1,
		showType = PlayerResUI.TYPE_ALL
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
		local var1_6 = getProxy(ChapterProxy)

		if var0_6 and #var0_6 > 0 then
			for iter0_6, iter1_6 in ipairs(var0_6) do
				local var2_6 = _.rest(iter1_6[2], 2)

				for iter2_6, iter3_6 in ipairs(var2_6) do
					if string.find(iter3_6, "^bgm_") and iter1_6[1] == var3_0 then
						local var3_6 = iter1_6[2][1]
						local var4_6 = false

						for iter4_6, iter5_6 in ipairs(var3_6) do
							local var5_6 = var1_6:GetChapterItemById(iter5_6)

							if var5_6 and var5_6:isClear() then
								var4_6 = true

								break
							end
						end

						if not var4_6 then
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
	arg0_12.topPanel = arg0_12._tf:Find("top")
	arg0_12.canvasGroup = arg0_12.topPanel:GetComponent("CanvasGroup")
	arg0_12.canvasGroup.blocksRaycasts = not arg0_12.canvasGroup.blocksRaycasts
	arg0_12.canvasGroup.blocksRaycasts = not arg0_12.canvasGroup.blocksRaycasts
	arg0_12.entranceLayer = arg0_12._tf:Find("entrance")
	arg0_12.ptBonus = EventPtBonus.New(arg0_12.entranceLayer:Find("btns/btn_task/bonusPt"))
	arg0_12.entranceBg = arg0_12._tf:Find("entrance_bg")
	arg0_12.topChapter = arg0_12.topPanel:Find("top_chapter")

	setActive(arg0_12.topChapter:Find("title_chapter"), false)
	setActive(arg0_12.topChapter:Find("type_chapter"), false)
	setActive(arg0_12.topChapter:Find("type_escort"), false)
	setActive(arg0_12.topChapter:Find("type_skirmish"), false)

	arg0_12.chapterName = arg0_12.topChapter:Find("title_chapter/name")
	arg0_12.chapterNoTitle = arg0_12.topChapter:Find("title_chapter/chapter")
	arg0_12.resChapter = arg0_12.topChapter:Find("resources")

	setActive(arg0_12.topChapter, true)

	arg0_12._voteBookBtn = arg0_12.topChapter:Find("vote_book")
	arg0_12.leftChapter = arg0_12._tf:Find("main/left_chapter")

	setActive(arg0_12.leftChapter, true)

	arg0_12.leftCanvasGroup = arg0_12.leftChapter:GetComponent(typeof(CanvasGroup))
	arg0_12.btnPrev = arg0_12.leftChapter:Find("btn_prev")
	arg0_12.btnPrevCol = arg0_12.leftChapter:Find("btn_prev/prev_image")
	arg0_12.eliteBtn = arg0_12.leftChapter:Find("buttons/btn_elite")
	arg0_12.normalBtn = arg0_12.leftChapter:Find("buttons/btn_normal")
	arg0_12.actNormalBtn = arg0_12.leftChapter:Find("buttons/btn_act_normal")
	arg0_12.actEliteBtn = arg0_12.leftChapter:Find("buttons/btn_act_elite")
	arg0_12.actExtraBtn = arg0_12.leftChapter:Find("buttons/btn_act_extra")
	arg0_12.actExtraBtnAnim = arg0_12.actExtraBtn:Find("usm")
	arg0_12.remasterBtn = arg0_12.leftChapter:Find("buttons/btn_remaster")
	arg0_12.escortBar = arg0_12.leftChapter:Find("escort_bar")
	arg0_12.eliteQuota = arg0_12.leftChapter:Find("elite_quota")
	arg0_12.skirmishBar = arg0_12.leftChapter:Find("left_times")
	arg0_12.mainLayer = arg0_12._tf:Find("main")

	setActive(arg0_12.mainLayer:Find("title_chapter_lines"), false)

	arg0_12.rightChapter = arg0_12._tf:Find("main/right_chapter")
	arg0_12.rightCanvasGroup = arg0_12.rightChapter:GetComponent(typeof(CanvasGroup))
	arg0_12.eventContainer = arg0_12.rightChapter:Find("event_btns/event_container")
	arg0_12.btnSpecial = arg0_12.eventContainer:Find("btn_task")
	arg0_12.challengeBtn = arg0_12.eventContainer:Find("btn_challenge")
	arg0_12.dailyBtn = arg0_12.eventContainer:Find("btn_daily")
	arg0_12.militaryExerciseBtn = arg0_12.eventContainer:Find("btn_pvp")
	arg0_12.activityBtn = arg0_12.rightChapter:Find("event_btns/activity_btn")
	arg0_12.ptTotal = arg0_12.rightChapter:Find("event_btns/pt_text")
	arg0_12.ticketTxt = arg0_12.rightChapter:Find("event_btns/tickets/Text")
	arg0_12.remasterAwardBtn = arg0_12.rightChapter:Find("btn_remaster_award")
	arg0_12.btnNext = arg0_12.rightChapter:Find("btn_next")
	arg0_12.btnNextCol = arg0_12.rightChapter:Find("btn_next/next_image")
	arg0_12.countDown = arg0_12.rightChapter:Find("event_btns/count_down")

	setActive(arg0_12.rightChapter:Find("event_btns/BottomList"), true)

	arg0_12.actExchangeShopBtn = arg0_12.rightChapter:Find("event_btns/BottomList/btn_exchange")
	arg0_12.actAtelierBuffBtn = arg0_12.rightChapter:Find("event_btns/BottomList/btn_control_center")
	arg0_12.actAtelierYumiaBuffBtn = arg0_12.rightChapter:Find("event_btns/BottomList/btn_yumia_buff")
	arg0_12.actExtraRank = arg0_12.rightChapter:Find("event_btns/BottomList/act_extra_rank")

	setActive(arg0_12.rightChapter, true)

	arg0_12.damageTextTemplate = go(arg0_12.topPanel:Find("damage"))

	setActive(arg0_12.damageTextTemplate, false)

	arg0_12.damageTextPool = {
		arg0_12.damageTextTemplate
	}
	arg0_12.damageTextActive = {}
	arg0_12.mapHelpBtn = arg0_12.topPanel:Find("help_button")
	arg0_12.avoidText = arg0_12.topPanel:Find("text_avoid")
	arg0_12.commanderTinkle = arg0_12.topPanel:Find("neko_tinkle")

	setActive(arg0_12.commanderTinkle, false)

	arg0_12.spResult = arg0_12.topPanel:Find("sp_result")

	setActive(arg0_12.spResult, false)

	arg0_12.helpPage = arg0_12.topPanel:Find("help_page")
	arg0_12.helpImage = arg0_12.helpPage:Find("icon")

	setActive(arg0_12.helpPage, false)

	arg0_12.curtain = arg0_12.topPanel:Find("curtain")

	setActive(arg0_12.curtain, false)

	arg0_12.map = arg0_12._tf:Find("maps")
	arg0_12.mapTFs = {
		arg0_12._tf:Find("maps/map1"),
		arg0_12._tf:Find("maps/map2")
	}

	for iter0_12, iter1_12 in ipairs(arg0_12.mapTFs) do
		iter1_12:GetComponent(typeof(Image)).enabled = false
	end

	arg0_12.UIFXList = arg0_12._tf:Find("maps/UI_FX_list")

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
	arg0_12.float = arg0_12._tf:Find("float")
	arg0_12.clouds = arg0_12.float:Find("clouds")

	setActive(arg0_12.clouds, true)
	setActive(arg0_12.float:Find("levels"), false)

	arg0_12.resources = arg0_12._tf:Find("resources")
	arg0_12.arrowTarget = arg0_12.resources:Find("Tpl_Arrow_Target")
	arg0_12.destinationMarkTpl = arg0_12.resources:Find("Tpl_Destination_Mark")
	arg0_12.championTpl = arg0_12.resources:Find("Tpl_Champion")
	arg0_12.deadTpl = arg0_12.resources:Find("Tpl_Dead")
	arg0_12.enemyTpl = arg0_12.resources:Find("Tpl_Enemy")
	arg0_12.oniTpl = arg0_12.resources:Find("Tpl_Oni")
	arg0_12.shipTpl = arg0_12.resources:Find("Tpl_Ship")
	arg0_12.subTpl = arg0_12.resources:Find("Tpl_Sub")
	arg0_12.transportTpl = arg0_12.resources:Find("Tpl_Transport")

	setText(tf(arg0_12.enemyTpl):Find("fighting/Text"), i18n("ui_word_levelui2_inevent"))
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

	arg0_12.levelInfoView:RegisterView(arg0_12)
	arg0_12.levelFleetView:RegisterView(arg0_12)
	arg0_12:buildCommanderPanel()

	arg0_12.levelRemasterView = LevelRemasterView.New(arg0_12.topPanel, arg0_12.event, arg0_12.contextData)
	arg0_12.chapterAutoDetailPanel = ChapterAutoDetailPanel.New(arg0_12.topPanel, arg0_12.event, arg0_12.contextData)

	arg0_12.chapterAutoDetailPanel:RegisterView(arg0_12)
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

function var0_0.onZeroHourRefresh(arg0_29)
	if arg0_29.levelInfoView:isShowing() then
		arg0_29.levelInfoView:RefreshChapterAutoPanel()
	end

	if arg0_29.levelInfoSPView and arg0_29.levelInfoSPView:isShowing() then
		arg0_29.levelInfoView:RefreshChapterAutoPanel()
	end
end

function var0_0.addbubbleMsgBox(arg0_30, arg1_30)
	table.insert(arg0_30.bubbleMsgBoxes, arg1_30)

	if #arg0_30.bubbleMsgBoxes > 1 then
		return
	end

	local var0_30

	local function var1_30()
		local var0_31 = arg0_30.bubbleMsgBoxes[1]

		if var0_31 then
			var0_31(function()
				table.remove(arg0_30.bubbleMsgBoxes, 1)
				var1_30()
			end)
		end
	end

	var1_30()
end

function var0_0.CleanBubbleMsgbox(arg0_33)
	table.clean(arg0_33.bubbleMsgBoxes)
end

function var0_0.updatePtActivity(arg0_34, arg1_34)
	arg0_34.ptActivity = arg1_34

	if not arg0_34.ptActivity then
		return
	end

	arg0_34:updateActivityRes()
end

function var0_0.updateActivityRes(arg0_35)
	local var0_35 = findTF(arg0_35.ptTotal, "Text")
	local var1_35 = findTF(arg0_35.ptTotal, "icon/Image")

	if var0_35 and var1_35 and arg0_35.ptActivity then
		setText(var0_35, "x" .. arg0_35.ptActivity.data1)
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = tonumber(arg0_35.ptActivity:getConfig("config_id"))
		}):getIcon(), "", var1_35, true)
	end
end

function var0_0.setCommanderPrefabs(arg0_36, arg1_36)
	arg0_36.commanderPrefabs = arg1_36
end

function var0_0.didEnter(arg0_37)
	arg0_37.openedCommanerSystem = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_37.player.level, "CommanderCatMediator")

	onButton(arg0_37, arg0_37.topChapter:Find("back_button"), function()
		if arg0_37:isfrozen() then
			return
		end

		local var0_38 = arg0_37.contextData.map

		if var0_38 and (var0_38:isActivity() or var0_38:isEscort()) then
			arg0_37:emit(LevelMediator2.ON_SWITCH_NORMAL_MAP)

			return
		elseif var0_38 and var0_38:isSkirmish() then
			arg0_37:emit(var0_0.ON_BACK)
		elseif not arg0_37.contextData.entranceStatus then
			arg0_37:ShowEntranceUI(true)
		else
			arg0_37:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_37, arg0_37.btnSpecial, function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.dailyBtn, function()
		if arg0_37:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_37:updatDailyBtnTip()
		arg0_37:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.challengeBtn, function()
		if arg0_37:isfrozen() then
			return
		end

		local var0_41, var1_41 = arg0_37:checkChallengeOpen()

		if var0_41 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_41)
		else
			arg0_37:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.militaryExerciseBtn, function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.normalBtn, function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:setMap(arg0_37.contextData.map:getBindMapId())
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.eliteBtn, function()
		if arg0_37:isfrozen() then
			return
		end

		if arg0_37.contextData.map:getBindMapId() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

			local var0_44 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			if var0_44 then
				arg0_37:setMap(var0_44.configId)
				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_warp_to_latest_map"))
			end
		elseif arg0_37.contextData.map:isEliteEnabled() then
			arg0_37:setMap(arg0_37.contextData.map:getBindMapId())
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unsatisfied"))
		end
	end, SFX_UI_WEIGHANCHOR_HARD)
	onButton(arg0_37, arg0_37.remasterBtn, function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_37:updateRemasterBtnTip()
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.entranceLayer:Find("enters/enter_main"), function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:ShowSelectedMap(arg0_37:GetInitializeMap())
	end, SFX_PANEL)
	setText(arg0_37.entranceLayer:Find("enters/enter_main/Text"), getProxy(ChapterProxy):getLastUnlockMap():getLastUnlockChapterName())
	onButton(arg0_37, arg0_37.entranceLayer:Find("enters/enter_world/enter"), function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:emit(LevelMediator2.ENTER_WORLD)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.entranceLayer:Find("enters/enter_ready/activity"), function()
		if arg0_37:isfrozen() then
			return
		end

		switch(arg0_37.entranceActivity:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0_37:emit(LevelMediator2.ON_ACTIVITY_MAP, arg0_37.entranceActivity.id)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
				arg0_37:emit(LevelMediator2.ON_OPEN_ACT_BOSS_BATTLE)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
				arg0_37:emit(LevelMediator2.ON_BOSSRUSH_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
				arg0_37:emit(LevelMediator2.ON_BOSSSINGLE_MAP, {
					mode = OtherworldMapScene.MODE_BATTLE
				})
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
				arg0_37:emit(LevelMediator2.ON_CLUE_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function()
				arg0_37:emit(LevelMediator2.ON_COLLAB_BOSSRUSH_MAP)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.entranceLayer:Find("btns/btn_remaster"), function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0_37:updateRemasterBtnTip()
	end, SFX_PANEL)
	setActive(arg0_37.entranceLayer:Find("btns/btn_remaster"), OPEN_REMASTER)
	onButton(arg0_37, arg0_37.entranceLayer:Find("btns/btn_challenge"), function()
		if arg0_37:isfrozen() then
			return
		end

		local var0_56, var1_56 = arg0_37:checkChallengeOpen()

		if var0_56 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_56)
		else
			arg0_37:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.entranceLayer:Find("btns/btn_pvp"), function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.entranceLayer:Find("btns/btn_daily"), function()
		if arg0_37:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0_37:updatDailyBtnTip()
		arg0_37:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.entranceLayer:Find("btns/btn_task"), function()
		if arg0_37:isfrozen() then
			return
		end

		arg0_37:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	setActive(arg0_37.entranceLayer:Find("enters/enter_world/enter"), not WORLD_ENTER_LOCK)
	setActive(arg0_37.entranceLayer:Find("enters/enter_world/nothing"), WORLD_ENTER_LOCK)

	arg0_37.entranceActivity = getProxy(ActivityProxy):getEnterReadyActivity()[1]

	setActive(arg0_37.entranceLayer:Find("enters/enter_ready/nothing"), not tobool(arg0_37.entranceActivity))
	setActive(arg0_37.entranceLayer:Find("enters/enter_ready/activity"), tobool(arg0_37.entranceActivity))

	if tobool(arg0_37.entranceActivity) then
		local var0_37 = arg0_37.entranceActivity:getConfig("config_client").entrance_bg

		if var0_37 then
			GetImageSpriteFromAtlasAsync(var0_37, "", arg0_37.entranceLayer:Find("enters/enter_ready/activity"), true)
		end
	end

	arg0_37:updateRightPanel()

	local var1_37 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_37.player.level, "EventMediator")

	setActive(arg0_37.btnSpecial:Find("lock"), not var1_37)
	setActive(arg0_37.entranceLayer:Find("btns/btn_task/lock"), not var1_37)

	local var2_37 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_37.player.level, "DailyLevelMediator")

	setActive(arg0_37.dailyBtn:Find("lock"), not var2_37)
	setActive(arg0_37.entranceLayer:Find("btns/btn_daily/lock"), not var2_37)

	local var3_37 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_37.player.level, "MilitaryExerciseMediator")

	setActive(arg0_37.militaryExerciseBtn:Find("lock"), not var3_37)
	setActive(arg0_37.entranceLayer:Find("btns/btn_pvp/lock"), not var3_37)

	local var4_37 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_37.player.level, "WorldMediator")

	setActive(arg0_37.entranceLayer:Find("enters/enter_world/enter/lock"), not var4_37)

	local var5_37 = LimitChallengeConst.IsOpen()

	setActive(arg0_37.challengeBtn:Find("lock"), not var5_37)
	setActive(arg0_37.entranceLayer:Find("btns/btn_challenge/lock"), not var5_37)

	local var6_37 = LimitChallengeConst.IsInAct()

	setActive(arg0_37.challengeBtn, var6_37)
	setActive(arg0_37.entranceLayer:Find("btns/btn_challenge"), var6_37)

	local var7_37 = LimitChallengeConst.IsShowRedPoint()

	setActive(arg0_37.entranceLayer:Find("btns/btn_challenge/tip"), var7_37)
	arg0_37:initMapBtn(arg0_37.btnPrev, -1)
	arg0_37:initMapBtn(arg0_37.btnNext, 1)
	arg0_37:registerActBtn()

	if arg0_37.contextData.editEliteChapter then
		local var8_37 = getProxy(ChapterProxy):getChapterById(arg0_37.contextData.editEliteChapter)

		arg0_37:displayFleetEdit(var8_37)

		arg0_37.contextData.editEliteChapter = nil
	elseif arg0_37.contextData.selectedChapterVO then
		arg0_37:displayFleetSelect(arg0_37.contextData.selectedChapterVO)

		arg0_37.contextData.selectedChapterVO = nil
	end

	local var9_37 = arg0_37.contextData.chapterVO

	if not var9_37 or not var9_37.active then
		arg0_37:tryPlaySubGuide()
	end

	arg0_37:updateRemasterBtnTip()
	arg0_37:updatDailyBtnTip()

	if arg0_37.contextData.open_remaster then
		arg0_37:displayRemasterPanel(arg0_37.contextData.isSP)

		arg0_37.contextData.open_remaster = nil
	end

	arg0_37:ShowEntranceUI(arg0_37.contextData.entranceStatus)

	if not arg0_37.contextData.entranceStatus then
		arg0_37:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg0_37:GetInitializeMap())
	end

	arg0_37:emit(LevelMediator2.ON_DIDENTER)
end

function var0_0.updateRightPanel(arg0_60)
	arg0_60.rightActivityBtns = defaultValue(arg0_60.rightActivityBtns, {
		LevelSecondMapBtn.New(arg0_60.actBtnTpl, arg0_60.event, false)
	})

	local var0_60 = {}
	local var1_60 = {}

	for iter0_60, iter1_60 in ipairs(arg0_60.rightActivityBtns) do
		if iter1_60:InShowTime() then
			table.insert(var0_60, iter1_60)
		else
			table.insert(var1_60, iter1_60)
		end
	end

	table.sort(var0_60, CompareFuncs({
		function(arg0_61)
			return arg0_61.config.group_id
		end
	}))

	for iter2_60, iter3_60 in ipairs(var0_60) do
		iter3_60:Init(iter2_60)
	end

	for iter4_60, iter5_60 in ipairs(var1_60) do
		iter5_60:Clear()
	end
end

function var0_0.checkChallengeOpen(arg0_62)
	local var0_62 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_62, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_63)
	if arg0_63.contextData.map and arg0_63.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_63)
end

function var0_0.onBackPressed(arg0_64)
	if arg0_64:isfrozen() then
		return
	end

	if arg0_64.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_64.chapterAutoDetailPanel:isShowing() then
		arg0_64:HideChapterAutoDetailPanel()
	end

	if arg0_64.levelInfoView:isShowing() then
		arg0_64:hideChapterPanel()

		return
	end

	if arg0_64.levelInfoSPView and arg0_64.levelInfoSPView:isShowing() then
		arg0_64:HideLevelInfoSPPanel()

		return
	end

	if arg0_64.levelFleetView:isShowing() then
		arg0_64:hideFleetEdit()

		return
	end

	if arg0_64.levelStrategyView then
		arg0_64:hideStrategyInfo()

		return
	end

	if arg0_64.levelRepairView then
		arg0_64:hideRepairWindow()

		return
	end

	if arg0_64.levelRemasterView:isShowing() then
		arg0_64:hideRemasterPanel()

		return
	end

	if arg0_64.contextData.map and arg0_64.contextData.map:getConfig("ui_type") == MapBuilder.TYPEEXSP and arg0_64.mapBuilder.personalPage:IsActive() then
		arg0_64.mapBuilder.personalPage:Hide()

		return
	end

	if isActive(arg0_64.helpPage) then
		setActive(arg0_64.helpPage, false)

		return
	end

	local var0_64 = arg0_64.contextData.chapterVO
	local var1_64 = getProxy(ChapterProxy):getActiveChapter()

	if var0_64 and var1_64 then
		arg0_64:switchToMap()

		return
	end

	triggerButton(arg0_64.topChapter:Find("back_button"))
end

function var0_0.ShowEntranceUI(arg0_65, arg1_65)
	setActive(arg0_65.entranceLayer, arg1_65)
	setActive(arg0_65.entranceBg, arg1_65)
	setActive(arg0_65.map, not arg1_65)
	setActive(arg0_65.float, not arg1_65)
	setActive(arg0_65.mainLayer, not arg1_65)
	setActive(arg0_65.topChapter:Find("type_entrance"), arg1_65)

	arg0_65.contextData.entranceStatus = tobool(arg1_65)

	if arg1_65 then
		setActive(arg0_65.topChapter:Find("title_chapter"), false)
		setActive(arg0_65.topChapter:Find("type_chapter"), false)
		setActive(arg0_65.topChapter:Find("type_escort"), false)
		setActive(arg0_65.topChapter:Find("type_skirmish"), false)

		if arg0_65.newChapterCDTimer then
			arg0_65.newChapterCDTimer:Stop()

			arg0_65.newChapterCDTimer = nil
		end

		arg0_65:RecordLastMapOnExit()

		arg0_65.contextData.mapIdx = nil
		arg0_65.contextData.map = nil
	end

	arg0_65:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_66, arg1_66, arg2_66)
	if arg0_66.preloadLevelDone then
		existCall(arg2_66)

		return
	end

	local var0_66

	local function var1_66()
		if not arg0_66.exited then
			arg0_66.preloadLevelDone = true

			existCall(arg2_66)
		end
	end

	local var2_66 = getProxy(ChapterProxy):getMapById(arg1_66)
	local var3_66 = arg0_66:GetMapBG(var2_66)

	table.ParallelIpairsAsync(var3_66, function(arg0_68, arg1_68, arg2_68)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_68.BG, "", arg2_68)
	end, var1_66)
end

function var0_0.setShips(arg0_69, arg1_69)
	arg0_69.shipVOs = arg1_69
end

function var0_0.updateRes(arg0_70, arg1_70)
	if arg0_70.levelStageView then
		arg0_70.levelStageView:ActionInvoke("SetPlayer", arg1_70)
	end

	arg0_70.player = arg1_70
end

function var0_0.setEliteQuota(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg2_71 - arg1_71
	local var1_71 = arg0_71.eliteQuota:Find("bg/Text"):GetComponent(typeof(Text))

	if arg1_71 == arg2_71 then
		var1_71.color = Color.red
	else
		var1_71.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_71.text = var0_71 .. "/" .. arg2_71
end

function var0_0.updateEvent(arg0_72, arg1_72)
	local var0_72 = arg1_72:hasFinishState()

	setActive(arg0_72.btnSpecial:Find("tip"), var0_72)
	setActive(arg0_72.entranceLayer:Find("btns/btn_task/tip"), var0_72)
end

function var0_0.updateFleet(arg0_73, arg1_73)
	arg0_73.fleets = arg1_73
end

function var0_0.updateChapterVO(arg0_74, arg1_74, arg2_74)
	if arg0_74.contextData.chapterVO and arg0_74.contextData.chapterVO.id == arg1_74.id and arg1_74.active then
		arg0_74:setChapter(arg1_74)
	end

	if arg0_74.contextData.chapterVO and arg0_74.contextData.chapterVO.id == arg1_74.id and arg1_74.active and arg0_74.levelStageView and arg0_74.grid then
		local var0_74 = false
		local var1_74 = false
		local var2_74 = false

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyFleet) > 0 then
			arg0_74.levelStageView:updateStageFleet()
			arg0_74.levelStageView:updateAmbushRate(arg1_74.fleet.line, true)

			var2_74 = true

			if arg0_74.grid then
				arg0_74.grid:RefreshFleetCells()
				arg0_74.grid:UpdateFloor()
				arg0_74.grid:UpdateWeatherCells()

				var0_74 = true
			end
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyChampion) > 0 then
			var2_74 = true

			if arg0_74.grid then
				arg0_74.grid:UpdateFleets()
				arg0_74.grid:clearChampions()
				arg0_74.grid:initChampions()

				var1_74 = true
			end
		elseif bit.band(arg2_74, ChapterConst.DirtyChampionPosition) > 0 then
			var2_74 = true

			if arg0_74.grid then
				arg0_74.grid:UpdateFleets()
				arg0_74.grid:updateChampions()

				var1_74 = true
			end
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyAchieve) > 0 then
			arg0_74.levelStageView:updateStageAchieve()
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyAttachment) > 0 then
			arg0_74.levelStageView:updateAmbushRate(arg1_74.fleet.line, true)

			if arg0_74.grid then
				if not (arg2_74 < 0) and not (bit.band(arg2_74, ChapterConst.DirtyFleet) > 0) then
					arg0_74.grid:updateFleet(arg1_74.fleets[arg1_74.findex].id)
				end

				arg0_74.grid:updateAttachments()

				if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyAutoAction) > 0 then
					arg0_74.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_74 = true
				end
			end
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyStrategy) > 0 then
			arg0_74.levelStageView:updateStageStrategy()

			var2_74 = true

			arg0_74.levelStageView:updateStageBarrier()
			arg0_74.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_74 then
			arg0_74.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_74 then
			arg0_74.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyCellFlag) > 0 then
			arg0_74.grid:UpdateFloor()
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyBase) > 0 then
			arg0_74.levelStageView:UpdateDefenseStatus()
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyFloatItems) > 0 then
			arg0_74.grid:UpdateItemCells()
		end

		if arg2_74 < 0 or bit.band(arg2_74, ChapterConst.DirtyWeather) > 0 then
			arg0_74.grid:UpdateWeatherCells()
		end

		if var2_74 then
			arg0_74.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_75)
	arg0_75.cloudRTFs = {}
	arg0_75.cloudRects = {}
	arg0_75.cloudTimer = {}

	for iter0_75 = 1, 6 do
		local var0_75 = arg0_75.clouds:Find("cloud_" .. iter0_75)
		local var1_75 = rtf(var0_75)

		table.insert(arg0_75.cloudRTFs, var1_75)
		table.insert(arg0_75.cloudRects, var1_75.rect.width)
	end

	arg0_75:initCloudsPos()

	for iter1_75, iter2_75 in ipairs(arg0_75.cloudRTFs) do
		local var2_75 = arg0_75.cloudRects[iter1_75]
		local var3_75 = arg0_75.initPositions[iter1_75] or Vector2(0, 0)
		local var4_75 = 30 - var3_75.y / 20
		local var5_75 = (arg0_75.mapWidth + var2_75) / var4_75
		local var6_75

		var6_75 = LeanTween.moveX(iter2_75, arg0_75.mapWidth, var5_75):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_75 = arg0_75.cloudRects[iter1_75]
			iter2_75.anchoredPosition = Vector2(-var2_75, var3_75.y)

			var6_75:setFrom(-var2_75):setTime((arg0_75.mapWidth + var2_75) / var4_75)
		end))
		var6_75.passed = math.random() * var5_75
		arg0_75.cloudTimer[iter1_75] = var6_75.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_77)
	arg0_77:PlayBGM()
	arg0_77:SwitchMapBG(arg0_77.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_78, arg1_78, arg2_78)
	if not arg1_78 then
		return
	end

	local var0_78 = arg0_78.contextData.map:getConfig("ani_controller")

	local function var1_78(arg0_79)
		arg0_79 = tf(arg0_79)

		local var0_79 = Vector3.one

		if arg0_79.rect.width > 0 and arg0_79.rect.height > 0 then
			var0_79.x = arg0_79.parent.rect.width / arg0_79.rect.width
			var0_79.y = arg0_79.parent.rect.height / arg0_79.rect.height
		end

		arg0_79.localScale = var0_79

		if var0_78 and #var0_78 > 0 then
			local var1_79 = getProxy(ChapterProxy)

			;(function()
				for iter0_80, iter1_80 in ipairs(var0_78) do
					local var0_80 = false
					local var1_80 = iter1_80[2][1]

					for iter2_80, iter3_80 in ipairs(var1_80) do
						local var2_80 = var1_79:GetChapterItemById(iter3_80)

						if var2_80 and var2_80:isClear() then
							var0_80 = true

							break
						end
					end

					if iter1_80[1] == var2_0 then
						local var3_80 = _.rest(iter1_80[2], 2)

						for iter4_80, iter5_80 in ipairs(var3_80) do
							local var4_80 = arg0_79:Find(iter5_80)

							if not IsNil(var4_80) and not var0_80 then
								setActive(var4_80, false)
							end
						end
					elseif iter1_80[1] == var3_0 then
						local var5_80 = _.rest(iter1_80[2], 2)

						for iter6_80, iter7_80 in ipairs(var5_80) do
							local var6_80 = arg0_79:Find(iter7_80)

							if not IsNil(var6_80) and not var0_80 then
								setActive(var6_80, true)

								return
							end
						end
					elseif iter1_80[1] == var4_0 then
						local var7_80 = _.rest(iter1_80[2], 2)

						for iter8_80, iter9_80 in ipairs(var7_80) do
							local var8_80 = arg0_79:Find(iter9_80)

							if not IsNil(var8_80) and not var0_80 then
								setActive(var8_80, true)
							end
						end
					end
				end
			end)()
		end
	end

	local var2_78 = arg0_78.loader:GetPrefab("ui/" .. arg1_78, arg1_78, function(arg0_81)
		arg0_81:SetActive(true)

		local var0_81 = arg0_78.mapTFs[arg2_78]

		setParent(arg0_81, var0_81)
		pg.ViewUtils.SetSortingOrder(arg0_81, ChapterConst.LayerWeightMap + arg2_78 * 2 - 1)
		var1_78(arg0_81)
	end)

	table.insert(arg0_78.mapGroup, var2_78)
end

function var0_0.HideBtns(arg0_82)
	setActive(arg0_82.btnPrev, false)
	setActive(arg0_82.eliteQuota, false)
	setActive(arg0_82.escortBar, false)
	setActive(arg0_82.skirmishBar, false)
	setActive(arg0_82.normalBtn, false)
	setActive(arg0_82.actNormalBtn, false)
	setActive(arg0_82.eliteBtn, false)
	setActive(arg0_82.actEliteBtn, false)
	setActive(arg0_82.actExtraBtn, false)
	setActive(arg0_82.remasterBtn, false)
	setActive(arg0_82.btnNext, false)
	setActive(arg0_82.remasterAwardBtn, false)
	setActive(arg0_82.eventContainer, false)
	setActive(arg0_82.activityBtn, false)
	setActive(arg0_82.ptTotal, false)
	setActive(arg0_82.ticketTxt.parent, false)
	setActive(arg0_82.countDown, false)
	setActive(arg0_82.actAtelierBuffBtn, false)
	setActive(arg0_82.actAtelierYumiaBuffBtn, false)
	setActive(arg0_82.actExtraRank, false)
	setActive(arg0_82.actExchangeShopBtn, false)
	setActive(arg0_82.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_83)
	local var0_83 = arg0_83.contextData.map:getConfig("type")

	setActive(arg0_83.normalBtn, var0_83 == Map.ELITE)
	setActive(arg0_83.eliteQuota, var0_83 == Map.ELITE)
	setActive(arg0_83.eliteBtn, var0_83 == Map.SCENARIO)

	local var1_83 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_83.eliteBtn:Find("pic_activity"), var1_83 and not var1_83:isEnd())
end

function var0_0.updateActivityBtns(arg0_84)
	local var0_84 = arg0_84.contextData.map
	local var1_84, var2_84 = var0_84:isActivity()
	local var3_84 = var0_84:isRemaster()
	local var4_84 = var0_84:isSkirmish()
	local var5_84 = var0_84:isEscort()
	local var6_84 = var0_84:getConfig("type")
	local var7_84 = setmetatable({}, MainActMapBtn)
	local var8_84 = var7_84:InShowTime() and not var1_84 and not var4_84 and not var5_84

	arg0_84.activityBtnLinkAct = var7_84:GetActivity()

	if var8_84 then
		var7_84.image = arg0_84.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var7_84.subImage = arg0_84.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var7_84.tipTr = arg0_84.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var7_84.tipTxt = arg0_84.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_84 = var7_84:InShowTime()

		if var8_84 then
			var7_84:InitTipImage()
			var7_84:InitSubImage()
			var7_84:InitImage(function()
				return
			end)
			var7_84:OnInit()
		end
	end

	setActive(arg0_84.activityBtn, var8_84)
	arg0_84:updateRemasterInfo()

	if var1_84 and var2_84 then
		local var9_84

		if var0_84:isRemaster() then
			var9_84 = getProxy(ChapterProxy):getRemasterMaps(var0_84.remasterId)
		else
			var9_84 = getProxy(ChapterProxy):getMapsByActivities(var0_84:getConfig("on_activity"))
		end

		local var10_84 = underscore.any(var9_84, function(arg0_86)
			return arg0_86:isActExtra()
		end)

		setActive(arg0_84.actExtraBtn, var10_84 and var6_84 ~= Map.ACT_EXTRA)

		if isActive(arg0_84.actExtraBtn) then
			if underscore.all(underscore.filter(var9_84, function(arg0_87)
				local var0_87 = arg0_87:getMapType()

				return var0_87 == Map.ACTIVITY_EASY or var0_87 == Map.ACTIVITY_HARD
			end), function(arg0_88)
				return arg0_88:isAllChaptersClear()
			end) then
				setActive(arg0_84.actExtraBtnAnim, true)
			else
				setActive(arg0_84.actExtraBtnAnim, false)
			end

			setActive(arg0_84.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive(var0_84:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_84 = checkExist(var0_84:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_84.actEliteBtn, var11_84 and var6_84 ~= Map.ACTIVITY_HARD)
		setActive(arg0_84.actNormalBtn, var6_84 ~= Map.ACTIVITY_EASY)
		setActive(arg0_84.actExtraRank, var6_84 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_89)
			if not arg0_89 or arg0_89:isEnd() then
				return
			end

			local var0_89 = arg0_89:getConfig("config_data")[1]

			return _.any(var0_84:getChapters(), function(arg0_90)
				if not arg0_90:IsEXChapter() then
					return false
				end

				return table.contains(arg0_90:getConfig("boss_expedition_id"), var0_89)
			end)
		end))
		setActive(arg0_84.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_84 and var2_84 and arg0_84:IsActShopActive())

		local var12_84 = arg0_84.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_84.contextData.map:getConfig("on_activity")) or nil
		local var13_84 = var12_84 and not var12_84:isEnd() and var12_84:GetConfigClientSetting("PTID")

		arg0_84:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_91)
			return arg0_91:getConfig("config_id") == var13_84
		end))
		setActive(arg0_84.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_84 and var2_84 and arg0_84.ptActivity and not arg0_84.ptActivity:isEnd())
	else
		setActive(arg0_84.actExtraBtn, false)
		setActive(arg0_84.actEliteBtn, false)
		setActive(arg0_84.actNormalBtn, false)
		setActive(arg0_84.actExtraRank, false)
		setActive(arg0_84.actExchangeShopBtn, false)
		setActive(arg0_84.actAtelierBuffBtn, false)
		setActive(arg0_84.actAtelierYumiaBuffBtn, false)
		setActive(arg0_84.ptTotal, false)
	end

	setActive(arg0_84.eventContainer, (not var1_84 or not var2_84) and not var5_84)
	setActive(arg0_84.remasterBtn, OPEN_REMASTER and (var3_84 or not var1_84 and not var5_84 and not var4_84))
	setActive(arg0_84.ticketTxt.parent, var3_84)
	arg0_84:updateRemasterTicket()
	arg0_84:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_92)
	setText(arg0_92.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_92:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_93)
	local var0_93 = getProxy(ChapterProxy)
	local var1_93 = var0_93:ifShowRemasterTip() or var0_93:anyRemasterAwardCanReceive()

	SetActive(arg0_93.remasterBtn:Find("tip"), var1_93)
	SetActive(arg0_93.entranceLayer:Find("btns/btn_remaster/tip"), var1_93)
end

function var0_0.updatDailyBtnTip(arg0_94)
	local var0_94 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_94.dailyBtn:Find("tip"), var0_94)
	SetActive(arg0_94.entranceLayer:Find("btns/btn_daily/tip"), var0_94)
end

function var0_0.updateRemasterInfo(arg0_95)
	arg0_95:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_95.contextData.map then
		return
	end

	local var0_95 = getProxy(ChapterProxy)
	local var1_95 = arg0_95.contextData.map:getRemaster()
	local var2_95 = BossRushChapterRemasterHelper.ChapterAwardInfo(var1_95)

	setActive(arg0_95.remasterAwardBtn, var2_95)

	if var2_95 then
		local var3_95 = var2_95[1]
		local var4_95, var5_95, var6_95, var7_95, var8_95 = unpack(var2_95[2])
		local var9_95 = var2_95[3]
		local var10_95 = var0_95:getRemasterInfo(var9_95, var4_95, var3_95)

		setText(arg0_95.remasterAwardBtn:Find("Text"), var10_95.count .. "/" .. var7_95)
		updateDrop(arg0_95.remasterAwardBtn:Find("IconTpl"), {
			type = var5_95,
			id = var6_95
		})
		setActive(arg0_95.remasterAwardBtn:Find("tip"), var7_95 <= var10_95.count)
		onButton(arg0_95, arg0_95.remasterAwardBtn, function()
			local var0_96 = BossRushChapterRemasterHelper.GetAwardName(var9_95, var4_95)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_95,
					id = var6_95
				},
				remaster = {
					word = i18n("level_remaster_tip4", var0_96),
					number = var10_95.count .. "/" .. var7_95,
					btn_text = i18n(var10_95.count < var7_95 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var10_95.count < var7_95 then
							if var9_95 and var9_95 > 0 then
								arg0_95:emit(LevelMediator2.ON_BOSSRUSH_REMASTER_ACTIVITY, var9_95)

								return
							end

							local var0_97 = pg.chapter_template[var4_95].map
							local var1_97, var2_97 = var0_95:getMapById(var0_97):isUnlock()

							if not var1_97 then
								pg.TipsMgr.GetInstance():ShowTips(var2_97)
							else
								arg0_95:ShowSelectedMap(var0_97)
							end
						else
							arg0_95:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_95, var3_95, var9_95)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_98)
	local var0_98 = getProxy(ChapterProxy)

	if arg0_98.newChapterCDTimer then
		arg0_98.newChapterCDTimer:Stop()

		arg0_98.newChapterCDTimer = nil
	end

	local var1_98 = 0

	if arg0_98.contextData.map:isActivity() and not arg0_98.contextData.map:isRemaster() then
		local var2_98 = var0_98:getMapsByActivities(arg0_98.contextData.map:getConfig("on_activity"))

		_.each(var2_98, function(arg0_99)
			local var0_99 = arg0_99:getChapterTimeLimit()

			if var1_98 == 0 then
				var1_98 = var0_99
			else
				var1_98 = math.min(var1_98, var0_99)
			end
		end)
		setActive(arg0_98.countDown, var1_98 > 0)
		setText(arg0_98.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_98.countDown, false)
	end

	if var1_98 > 0 then
		setText(arg0_98.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_98))

		arg0_98.newChapterCDTimer = Timer.New(function()
			var1_98 = var1_98 - 1

			if var1_98 <= 0 then
				arg0_98:updateCountDown()

				if not arg0_98.contextData.chapterVO then
					arg0_98:setMap(arg0_98.contextData.mapIdx)
				end
			else
				setText(arg0_98.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_98))
			end
		end, 1, -1)

		arg0_98.newChapterCDTimer:Start()
	else
		setText(arg0_98.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_101)
	onButton(arg0_101, arg0_101.actExtraRank, function()
		if arg0_101:isfrozen() then
			return
		end

		arg0_101:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_101, arg0_101.activityBtn, function()
		if arg0_101:isfrozen() then
			return
		end

		if arg0_101.activityBtnLinkAct then
			local var0_103 = arg0_101.activityBtnLinkAct:getConfig("type")
			local var1_103 = arg0_101.activityBtnLinkAct.id

			if var0_103 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)

				return
			elseif var0_103 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)

				return
			elseif var1_103 == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)

				return
			elseif var0_103 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ZHANG_WU_BOSS)

				return
			end
		end

		arg0_101:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_101, arg0_101.actExchangeShopBtn, function()
		if arg0_101:isfrozen() then
			return
		end

		arg0_101:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_101, arg0_101.actAtelierBuffBtn, function()
		if arg0_101:isfrozen() then
			return
		end

		arg0_101:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)
	onButton(arg0_101, arg0_101.actAtelierYumiaBuffBtn, function()
		if arg0_101:isfrozen() then
			return
		end

		arg0_101:emit(LevelMediator2.SHOW_ATELIER_BUFF, true)
	end, SFX_UI_CLICK)

	local var0_101 = getProxy(ChapterProxy)

	local function var1_101(arg0_107, arg1_107, arg2_107)
		local var0_107

		if arg0_107:isRemaster() then
			var0_107 = var0_101:getRemasterMaps(arg0_107.remasterId)
		else
			var0_107 = var0_101:getMapsByActivities(arg0_107:getConfig("on_activity"))
		end

		local var1_107 = _.select(var0_107, function(arg0_108)
			return arg0_108:getMapType() == arg1_107
		end)

		table.sort(var1_107, function(arg0_109, arg1_109)
			return arg0_109.id < arg1_109.id
		end)

		local var2_107 = table.indexof(underscore.map(var1_107, function(arg0_110)
			return arg0_110.id
		end), arg2_107) or #var1_107

		while not var1_107[var2_107]:isUnlock() do
			if var2_107 > 1 then
				var2_107 = var2_107 - 1
			else
				break
			end
		end

		return var1_107[var2_107]
	end

	arg0_101:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_111, arg1_111, arg2_111)
		arg2_111 = arg2_111 or switch(arg1_111, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_101.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_101.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_111 = var1_101(arg0_101.contextData.map, arg1_111, arg2_111)
		local var1_111, var2_111 = var0_111:isUnlock()

		if var1_111 then
			arg0_101:setMap(var0_111.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_111)
		end
	end)
	onButton(arg0_101, arg0_101.actNormalBtn, function()
		if arg0_101:isfrozen() then
			return
		end

		arg0_101:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_101, arg0_101.actEliteBtn, function()
		if arg0_101:isfrozen() then
			return
		end

		arg0_101:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_101, arg0_101.actExtraBtn, function()
		if arg0_101:isfrozen() then
			return
		end

		arg0_101:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_118, arg1_118)
	arg0_118.initPositions = {}

	local var0_118 = arg1_118 or 1
	local var1_118 = pg.expedition_data_by_map[var0_118].clouds_pos

	for iter0_118, iter1_118 in ipairs(arg0_118.cloudRTFs) do
		local var2_118 = var1_118[iter0_118]

		if var2_118 then
			iter1_118.anchoredPosition = Vector2(var2_118[1], var2_118[2])

			table.insert(arg0_118.initPositions, iter1_118.anchoredPosition)
		else
			setActive(iter1_118, false)
		end
	end
end

function var0_0.initMapBtn(arg0_119, arg1_119, arg2_119)
	onButton(arg0_119, arg1_119, function()
		if arg0_119:isfrozen() then
			return
		end

		local var0_120 = arg0_119.contextData.mapIdx + arg2_119
		local var1_120 = getProxy(ChapterProxy):getMapById(var0_120)

		if not var1_120 then
			return
		end

		if var1_120:getMapType() == Map.ELITE and not var1_120:isEliteEnabled() then
			var1_120 = var1_120:getBindMap()
			var0_120 = var1_120.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_120, var3_120 = var1_120:isUnlock()

		if arg2_119 > 0 and not var2_120 then
			pg.TipsMgr.GetInstance():ShowTips(var3_120)

			return
		end

		arg0_119:setMap(var0_120)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_121, arg1_121, arg2_121)
	seriesAsync({
		function(arg0_122)
			if arg0_121.contextData.entranceStatus then
				arg0_121:frozen()

				arg0_121.nextPreloadMap = arg1_121

				arg0_121:PreloadLevelMainUI(arg1_121, function()
					arg0_121:unfrozen()

					if arg0_121.nextPreloadMap ~= arg1_121 then
						return
					end

					arg0_121:ShowEntranceUI(false)
					arg0_121:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_121)
					arg0_122()
				end)
			else
				arg0_121:setMap(arg1_121)
				arg0_122()
			end
		end
	}, arg2_121)
end

function var0_0.setMap(arg0_124, arg1_124)
	local var0_124 = arg0_124.contextData.mapIdx

	arg0_124.contextData.mapIdx = arg1_124
	arg0_124.contextData.map = getProxy(ChapterProxy):getMapById(arg1_124)

	assert(arg0_124.contextData.map, "map cannot be nil " .. arg1_124)

	if arg0_124.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_124.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_124.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_124.contextData.map.remasterId, arg1_124)
		PlayerPrefs.Save()
	end

	arg0_124:RecordLastMapOnExit()
	arg0_124:updateMap(var0_124)
	arg0_124:tryPlayMapStory()
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

function var0_0.SwitchMapBuilder(arg0_125, arg1_125)
	if arg0_125.mapBuilder and arg0_125.mapBuilder:GetType() ~= arg1_125 then
		arg0_125.mapBuilder.buffer:Hide()
	end

	local var0_125 = arg0_125:GetMapBuilderInBuffer(arg1_125)

	arg0_125.mapBuilder = var0_125

	var0_125.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_126, arg1_126)
	if not arg0_126.mbDict[arg1_126] then
		local var0_126 = _G[var6_0[arg1_126]]

		assert(var0_126, "Missing MapBuilder of type " .. (arg1_126 or "NIL"))

		arg0_126.mbDict[arg1_126] = var0_126.New(arg0_126._tf, arg0_126)
		arg0_126.mbDict[arg1_126].isFrozen = arg0_126:isfrozen()

		arg0_126.mbDict[arg1_126]:Load()
	end

	return arg0_126.mbDict[arg1_126]
end

function var0_0.updateMap(arg0_127, arg1_127)
	local var0_127 = arg0_127.contextData.map
	local var1_127 = var0_127:getConfig("anchor")
	local var2_127

	if var1_127 == "" then
		var2_127 = Vector2(0.5, 0.5)
	else
		var2_127 = Vector2(unpack(var1_127))
	end

	arg0_127.map.pivot = var2_127

	local var3_127 = var0_127:getConfig("uifx")

	for iter0_127 = 1, arg0_127.UIFXList.childCount do
		local var4_127 = arg0_127.UIFXList:GetChild(iter0_127 - 1)

		setActive(var4_127, var4_127.name == var3_127)
	end

	arg0_127:SwitchMapBG(var0_127, arg1_127)
	arg0_127:PlayBGM()

	local var5_127 = arg0_127.contextData.map:getConfig("ui_type")

	arg0_127:SwitchMapBuilder(var5_127)
	seriesAsync({
		function(arg0_128)
			arg0_127.mapBuilder:CallbackInvoke(arg0_128)
		end,
		function(arg0_129)
			arg0_127.mapBuilder:UpdateMapVO(var0_127)
			arg0_127.mapBuilder:UpdateView()
			arg0_127.mapBuilder:UpdateMapItems()
			arg0_127.mapBuilder:PlayEnterAnim()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_130)
	local var0_130 = arg0_130.contextData.map
	local var1_130 = getProxy(ChapterProxy)
	local var2_130 = var1_130:getMapById(var0_130.id - 1)
	local var3_130 = var1_130:getMapById(var0_130.id + 1)

	setActive(arg0_130.btnPrev, tobool(var2_130))
	setActive(arg0_130.btnNext, tobool(var3_130))

	local var4_130 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_130.btnPrevCol, var2_130 and Color.white or var4_130)
	setImageColor(arg0_130.btnNextCol, var3_130 and var3_130:isUnlock() and Color.white or var4_130)
end

function var0_0.tryPlayMapStory(arg0_131)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_132)
			local var0_132 = arg0_131.contextData.map:getConfig("enter_story")

			if var0_132 and var0_132 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_132) and not arg0_131.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_132 = tonumber(var0_132)

				if var1_132 and var1_132 > 0 then
					arg0_131:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_132)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_132, arg0_132)
				end

				return
			end

			arg0_132()
		end,
		function(arg0_133)
			local var0_133 = arg0_131.contextData.map:getConfig("guide_id")

			if var0_133 and var0_133 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_133, nil, arg0_133)

				return
			end

			arg0_133()
		end,
		function(arg0_134)
			if isActive(arg0_131.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_134 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_134

				if var0_134 then
					var1_134 = {
						1,
						2
					}
				else
					var1_134 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_134)
			else
				arg0_134()
			end
		end,
		function(arg0_135)
			if arg0_131.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_131.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_136, arg1_136, arg2_136, arg3_136)
	arg0_136.uiAnims = arg0_136.uiAnims or {}

	local var0_136 = arg0_136.uiAnims[arg1_136]

	local function var1_136()
		arg0_136.playing = true

		arg0_136:frozen()
		var0_136:SetActive(true)

		local var0_137 = tf(var0_136)

		pg.UIMgr.GetInstance():OverlayPanel(var0_137)

		if arg3_136 then
			arg3_136(var0_136)
		end

		var0_137:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_138)
			arg0_136.playing = false

			if arg2_136 then
				arg2_136(var0_136)
			end

			arg0_136:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_136 then
		PoolMgr.GetInstance():GetUI(arg1_136, true, function(arg0_139)
			arg0_139:SetActive(true)

			arg0_136.uiAnims[arg1_136] = arg0_139
			var0_136 = arg0_136.uiAnims[arg1_136]

			var1_136()
		end)
	else
		var1_136()
	end
end

function var0_0.displaySpResult(arg0_140, arg1_140, arg2_140)
	setActive(arg0_140.spResult, true)
	arg0_140:DisplaySPAnim(arg1_140 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_141)
		onButton(arg0_140, arg0_141, function()
			removeOnButton(arg0_141)
			setActive(arg0_141, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_141, arg0_140._tf)
			arg0_140:hideSpResult()
			arg2_140()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_143)
	setActive(arg0_143.spResult, false)
end

function var0_0.displayBombResult(arg0_144, arg1_144)
	setActive(arg0_144.spResult, true)
	arg0_144:DisplaySPAnim("SpBombRet", function(arg0_145)
		onButton(arg0_144, arg0_145, function()
			removeOnButton(arg0_145)
			setActive(arg0_145, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_145, arg0_144._tf)
			arg0_144:hideSpResult()
			arg1_144()
		end, SFX_PANEL)
	end, function(arg0_147)
		setText(arg0_147.transform:Find("right/name_bg/en"), arg0_144.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_148, arg1_148, arg2_148)
	arg0_148.contextData.chapterLoopFlag = arg2_148

	local var0_148 = getProxy(ChapterProxy):getChapterById(arg1_148, true)

	if var0_148:getConfig("type") == Chapter.CustomFleet then
		arg0_148:displayFleetEdit(var0_148)

		return
	end

	if #var0_148:getNpcShipByType(1) > 0 then
		arg0_148:emit(LevelMediator2.ON_TRACKING, arg1_148)

		return
	end

	arg0_148:displayFleetSelect(var0_148)
end

function var0_0.DisplayLevelInfoPanel(arg0_149, arg1_149, arg2_149)
	seriesAsync({
		function(arg0_150)
			if not arg0_149.levelInfoView:GetLoaded() then
				arg0_149:frozen()
				arg0_149.levelInfoView:Load()
				arg0_149.levelInfoView:CallbackInvoke(function()
					arg0_149:unfrozen()
					arg0_150()
				end)

				return
			end

			arg0_150()
		end,
		function(arg0_152)
			local function var0_152(arg0_153, arg1_153)
				arg0_149:hideChapterPanel()
				arg0_149:OnLevelInfoPanelConfirm(arg0_153, arg1_153)
			end

			local function var1_152()
				arg0_149:hideChapterPanel()
			end

			local var2_152 = getProxy(ChapterProxy):getChapterById(arg1_149, true)

			if getProxy(ChapterProxy):getMapById(var2_152:getConfig("map")):isSkirmish() and #var2_152:getNpcShipByType(1) > 0 then
				var0_152(false)

				return
			end

			arg0_149.levelInfoView:set(arg1_149, arg2_149)
			arg0_149.levelInfoView:setCBFunc(var0_152, var1_152)
			arg0_149.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_155)
	if arg0_155.levelInfoView:isShowing() then
		arg0_155.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_156)
	arg0_156.levelInfoView:Destroy()

	arg0_156.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_157, arg1_157, arg2_157, arg3_157)
	seriesAsync({
		function(arg0_158)
			if not arg0_157.levelInfoSPView then
				arg0_157.levelInfoSPView = LevelInfoSPView.New(arg0_157.topPanel, arg0_157.event, arg0_157.contextData)

				arg0_157.levelInfoSPView:RegisterView(arg0_157)
				arg0_157:frozen()
				arg0_157.levelInfoSPView:Load()
				arg0_157.levelInfoSPView:CallbackInvoke(function()
					arg0_157:unfrozen()
					arg0_158()
				end)

				return
			end

			arg0_158()
		end,
		function(arg0_160)
			local function var0_160(arg0_161, arg1_161)
				arg0_157:HideLevelInfoSPPanel()
				arg0_157:OnLevelInfoPanelConfirm(arg0_161, arg1_161)
			end

			local function var1_160()
				arg0_157:HideLevelInfoSPPanel()
			end

			arg0_157.levelInfoSPView:SetChapterGroupInfo(arg2_157)
			arg0_157.levelInfoSPView:set(arg1_157, arg3_157)
			arg0_157.levelInfoSPView:setCBFunc(var0_160, var1_160)
			arg0_157.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_163)
	if arg0_163.levelInfoSPView and arg0_163.levelInfoSPView:isShowing() then
		arg0_163.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_164)
	if not arg0_164.levelInfoSPView then
		return
	end

	arg0_164.levelInfoSPView:Destroy()

	arg0_164.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_165, arg1_165)
	local var0_165 = arg0_165.contextData.selectedFleetIDs or arg1_165:GetDefaultFleetIndex()

	arg1_165 = Clone(arg1_165)
	arg1_165.loopFlag = arg0_165.contextData.chapterLoopFlag

	arg0_165.levelFleetView:updateSpecialOperationTickets(arg0_165.spTickets)
	arg0_165.levelFleetView:Load()
	arg0_165.levelFleetView:ActionInvoke("setHardShipVOs", arg0_165.shipVOs)
	arg0_165.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_165.openedCommanerSystem)
	arg0_165.levelFleetView:ActionInvoke("set", arg1_165, arg0_165.fleets, var0_165)
	arg0_165.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_166)
	if arg0_166.levelCMDFormationView:isShowing() then
		arg0_166.levelCMDFormationView:Hide()
	end

	if arg0_166.levelFleetView then
		arg0_166.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_167)
	arg0_167.levelCMDFormationView = LevelCMDFormationView.New(arg0_167.topPanel, arg0_167.event, arg0_167.contextData)
end

function var0_0.destroyFleetSelect(arg0_168)
	if not arg0_168.levelFleetView then
		return
	end

	arg0_168.levelFleetView:Destroy()

	arg0_168.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_169, arg1_169)
	arg1_169 = Clone(arg1_169)
	arg1_169.loopFlag = arg0_169.contextData.chapterLoopFlag

	arg0_169.levelFleetView:updateSpecialOperationTickets(arg0_169.spTickets)
	arg0_169.levelFleetView:Load()
	arg0_169.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_169.openedCommanerSystem)
	arg0_169.levelFleetView:ActionInvoke("setHardShipVOs", arg0_169.shipVOs)
	arg0_169.levelFleetView:ActionInvoke("setOnHard", arg1_169)
	arg0_169.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_170)
	arg0_170:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_171)
	arg0_171:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_172, arg1_172)
	if not arg0_172.levelFleetView then
		return
	end

	assert(arg0_172.levelFleetView:GetLoaded())

	local var0_172 = arg0_172.levelFleetView:IsSelectMode()
	local var1_172

	if var0_172 then
		arg0_172.levelFleetView:ActionInvoke("set", arg1_172 or arg0_172.levelFleetView.chapter, arg0_172.fleets, arg0_172.levelFleetView:getSelectIds())

		if arg0_172.levelCMDFormationView:isShowing() then
			local var2_172 = arg0_172.levelCMDFormationView.fleet.id

			var1_172 = arg0_172.fleets[var2_172]
		end
	else
		arg0_172.levelFleetView:ActionInvoke("setOnHard", arg1_172 or arg0_172.levelFleetView.chapter)

		if arg0_172.levelCMDFormationView:isShowing() then
			local var3_172 = arg0_172.levelCMDFormationView.fleet.id

			var1_172 = arg1_172:wrapEliteFleet(var3_172)
		end
	end

	if var1_172 then
		arg0_172.levelCMDFormationView:ActionInvoke("updateFleet", var1_172)
	end
end

function var0_0.setChapter(arg0_173, arg1_173)
	local var0_173

	if arg1_173 then
		var0_173 = arg1_173.id
	end

	arg0_173.contextData.chapterId = var0_173
	arg0_173.contextData.chapterVO = arg1_173
end

function var0_0.switchToChapter(arg0_174, arg1_174)
	if arg0_174.contextData.mapIdx ~= arg1_174:getConfig("map") then
		arg0_174:setMap(arg1_174:getConfig("map"))
	end

	arg0_174:setChapter(arg1_174)

	arg0_174.leftCanvasGroup.blocksRaycasts = false
	arg0_174.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_174.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_174:DestroyLevelStageView()

	if not arg0_174.levelStageView then
		arg0_174.levelStageView = LevelStageView.New(arg0_174.topPanel, arg0_174.event, arg0_174.contextData)

		arg0_174.levelStageView:Load()

		arg0_174.levelStageView.isFrozen = arg0_174:isfrozen()
	end

	arg0_174:frozen()

	local function var0_174()
		seriesAsync({
			function(arg0_176)
				arg0_174.mapBuilder:CallbackInvoke(arg0_176)
			end,
			function(arg0_177)
				setActive(arg0_174.clouds, false)
				arg0_174.mapBuilder:HideFloat()
				arg0_174:BlurPanel(arg0_174.topPanel, {
					blurCamList = {
						pg.UIMgr.CameraUI
					}
				})
				arg0_174.levelStageView:updateStageInfo()
				arg0_174.levelStageView:updateAmbushRate(arg1_174.fleet.line, true)
				arg0_174.levelStageView:updateStageAchieve()
				arg0_174.levelStageView:updateStageBarrier()
				arg0_174.levelStageView:updateBombPanel()
				arg0_174.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_177)
			end,
			function(arg0_178)
				if arg0_174.exited then
					return
				end

				arg0_174.levelStageView:updateStageStrategy()

				arg0_174.canvasGroup.blocksRaycasts = arg0_174.frozenCount == 0

				onNextTick(arg0_178)
			end,
			function(arg0_179)
				if arg0_174.exited then
					return
				end

				arg0_174.levelStageView:updateStageFleet()
				arg0_174.levelStageView:updateSupportFleet()
				arg0_174.levelStageView:updateFleetBuff()
				onNextTick(arg0_179)
			end,
			function(arg0_180)
				if arg0_174.exited then
					return
				end

				parallelAsync({
					function(arg0_181)
						local var0_181 = arg1_174:getConfig("scale")
						local var1_181 = LeanTween.value(go(arg0_174.map), arg0_174.map.localScale, Vector3.New(var0_181[3], var0_181[3], 1), var1_0):setOnUpdateVector3(function(arg0_182)
							arg0_174.map.localScale = arg0_182
							arg0_174.float.localScale = arg0_182
						end):setOnComplete(System.Action(function()
							arg0_174.mapBuilder:ShowFloat()
							arg0_174.mapBuilder:Hide()
							arg0_181()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_174:RecordTween("mapScale", var1_181.uniqueId)

						local var2_181 = LeanTween.value(go(arg0_174.map), arg0_174.map.pivot, Vector2.New(math.clamp(var0_181[1] - 0.5, 0, 1), math.clamp(var0_181[2] - 0.5, 0, 1)), var1_0)

						var2_181:setOnUpdateVector2(function(arg0_184)
							arg0_174.map.pivot = arg0_184
							arg0_174.float.pivot = arg0_184
						end):setEase(LeanTweenType.easeOutSine)
						arg0_174:RecordTween("mapPivot", var2_181.uniqueId)
						shiftPanel(arg0_174.leftChapter, -arg0_174.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_174.rightChapter, arg0_174.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_174.topChapter, 0, arg0_174.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_174.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_185)
						arg0_174:PlayBGM()

						local var0_185 = {}
						local var1_185 = arg1_174:getConfig("bg")

						if var1_185 and #var1_185 > 0 then
							var0_185[1] = {
								BG = var1_185
							}
						end

						arg0_174:SwitchBG(var0_185, arg0_185)
					end
				}, function()
					onNextTick(arg0_180)
				end)
			end,
			function(arg0_187)
				if arg0_174.exited then
					return
				end

				setActive(arg0_174.topChapter, false)
				setActive(arg0_174.leftChapter, false)
				setActive(arg0_174.rightChapter, false)

				arg0_174.leftCanvasGroup.blocksRaycasts = true
				arg0_174.rightCanvasGroup.blocksRaycasts = true

				arg0_174:initGrid(arg0_187)
			end,
			function(arg0_188)
				if arg0_174.exited then
					return
				end

				arg0_174.levelStageView:SetGrid(arg0_174.grid)

				arg0_174.contextData.huntingRangeVisibility = arg0_174.contextData.huntingRangeVisibility - 1

				arg0_174.grid:toggleHuntingRange()

				local var0_188 = arg1_174:getConfig("pop_pic")

				if var0_188 and #var0_188 > 0 and arg0_174.FirstEnterChapter == arg1_174.id then
					arg0_174:doPlayAnim(var0_188, function(arg0_189)
						setActive(arg0_189, false)

						if arg0_174.exited then
							return
						end

						arg0_188()
					end)
				else
					arg0_188()
				end
			end,
			function(arg0_190)
				arg0_174.levelStageView:tryAutoAction(arg0_190)
			end,
			function(arg0_191)
				if arg0_174.exited then
					return
				end

				arg0_174:unfrozen()

				if arg0_174.FirstEnterChapter then
					arg0_174:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_174.subAutoAttack)
				end

				arg0_174.FirstEnterChapter = nil

				arg0_191()
			end,
			function(arg0_192)
				if arg1_174:NeedSupportSubmarineStage() then
					arg0_174.levelStageView:TryEnterChapterSupportSubmarineStage(arg0_192)
				else
					arg0_192()
				end
			end
		}, function()
			arg0_174.levelStageView:tryAutoTrigger(true)
		end)
	end

	arg0_174.levelStageView:ActionInvoke("SetSeriesOperation", var0_174)
	arg0_174.levelStageView:ActionInvoke("SetPlayer", arg0_174.player)
	arg0_174.levelStageView:ActionInvoke("SwitchToChapter", arg1_174)
end

function var0_0.switchToMap(arg0_194, arg1_194)
	arg0_194:frozen()
	arg0_194:destroyGrid()
	arg0_194:setChapter(nil)
	LeanTween.cancel(go(arg0_194.map))

	local var0_194 = LeanTween.value(go(arg0_194.map), arg0_194.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_195)
		arg0_194.map.localScale = arg0_195
		arg0_194.float.localScale = arg0_195
	end):setOnComplete(System.Action(function()
		arg0_194:unfrozen()
		arg0_194.mapBuilder:PlayEnterAnim()
		existCall(arg1_194)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_194:RecordTween("mapScale", var0_194.uniqueId)

	local var1_194 = arg0_194.contextData.map:getConfig("anchor")
	local var2_194

	if var1_194 == "" then
		var2_194 = Vector2(0.5, 0.5)
	else
		var2_194 = Vector2(unpack(var1_194))
	end

	local var3_194 = LeanTween.value(go(arg0_194.map), arg0_194.map.pivot, var2_194, var1_0)

	var3_194:setOnUpdateVector2(function(arg0_197)
		arg0_194.map.pivot = arg0_197
		arg0_194.float.pivot = arg0_197
	end):setEase(LeanTweenType.easeOutSine)
	arg0_194:RecordTween("mapPivot", var3_194.uniqueId)
	setActive(arg0_194.topChapter, true)
	setActive(arg0_194.leftChapter, true)
	setActive(arg0_194.rightChapter, true)
	shiftPanel(arg0_194.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_194.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_194.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_194.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_194.levelStageView then
		arg0_194.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_194:DestroyLevelStageView()
		end)
		arg0_194.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_194:SwitchMapBG(arg0_194.contextData.map)
	arg0_194:PlayBGM()
	seriesAsync({
		function(arg0_199)
			arg0_194.mapBuilder:CallbackInvoke(arg0_199)
		end,
		function(arg0_200)
			arg0_194.mapBuilder:Show()
			arg0_194.mapBuilder:UpdateView()
			arg0_194.mapBuilder:UpdateMapItems()
		end
	})
	arg0_194:UnOverlayPanel(arg0_194.topPanel, arg0_194._tf)

	arg0_194.canvasGroup.blocksRaycasts = arg0_194.frozenCount == 0
	arg0_194.canvasGroup.interactable = true

	if arg0_194.ambushWarning and arg0_194.ambushWarning.activeSelf then
		arg0_194.ambushWarning:SetActive(false)
		arg0_194:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_201, arg1_201, arg2_201, arg3_201)
	if not arg1_201 or #arg1_201 <= 0 then
		existCall(arg2_201)

		return
	elseif arg3_201 then
		-- block empty
	elseif table.equal(arg0_201.currentBG, arg1_201) then
		return
	end

	arg0_201.currentBG = arg1_201

	for iter0_201, iter1_201 in ipairs(arg0_201.mapGroup) do
		arg0_201.loader:ClearRequest(iter1_201)
	end

	table.clear(arg0_201.mapGroup)

	local var0_201 = {}

	table.ParallelIpairsAsync(arg1_201, function(arg0_202, arg1_202, arg2_202)
		local var0_202 = arg0_201.mapTFs[arg0_202]
		local var1_202 = arg1_202.bgPrefix and arg1_202.bgPrefix .. "/" or "levelmap/"
		local var2_202 = arg0_201.loader:GetSpriteDirect(var1_202 .. arg1_202.BG, "", function(arg0_203)
			var0_201[arg0_202] = arg0_203

			arg2_202()
		end, var0_202)

		table.insert(arg0_201.mapGroup, var2_202)
		arg0_201:updateCouldAnimator(arg1_202.Animator, arg0_202)
	end, function()
		for iter0_204, iter1_204 in ipairs(arg0_201.mapTFs) do
			setImageSprite(iter1_204, var0_201[iter0_204])
			setActive(iter1_204, arg1_201[iter0_204])
			SetCompomentEnabled(iter1_204, typeof(Image), true)
		end

		existCall(arg2_201)
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

function var0_0.ClearMapTransitions(arg0_205)
	if not arg0_205.mapTransitions then
		return
	end

	for iter0_205, iter1_205 in pairs(arg0_205.mapTransitions) do
		if iter1_205 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_205, iter0_205, iter1_205, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_205, iter0_205)
		end
	end

	arg0_205.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_206, arg1_206, arg2_206, arg3_206)
	local var0_206, var1_206, var2_206 = arg0_206:GetMapBG(arg1_206, arg2_206)
	local var3_206 = {}

	if var1_206 then
		table.insert(var3_206, function(arg0_207)
			arg0_206:PlayMapTransition("LevelMapTransition_" .. var1_206, var2_206, arg0_207)
		end)
	end

	seriesAsync(var3_206, function()
		arg0_206:SwitchBGMapType(arg1_206:getConfig("pos_type"))
		arg0_206:SwitchBG(var0_206, nil, arg3_206)
	end)
end

function var0_0.SwitchBGMapType(arg0_209, arg1_209)
	if arg0_209.posType == arg1_209 then
		return
	end

	for iter0_209, iter1_209 in ipairs({
		arg0_209.map,
		arg0_209.float
	}) do
		local var0_209 = GetOrAddComponent(iter1_209, typeof(AspectRatioFitter))

		var0_209.aspectRatio = 1.77777777777778
		var0_209.enabled = arg1_209 == 0

		if arg1_209 == 1 then
			iter1_209.anchorMin = Vector2(0.5, 0.5)
			iter1_209.anchorMax = Vector2(0.5, 0.5)

			setSizeDelta(var0_209, {
				x = 2520,
				y = 1440
			})
		end
	end
end

function var0_0.GetMapBG(arg0_210, arg1_210, arg2_210)
	if not table.contains(var7_0, arg1_210.id) then
		return {
			arg0_210:GetMapElement(arg1_210)
		}
	end

	local var0_210 = arg1_210.id
	local var1_210 = table.indexof(var7_0, var0_210) - 1
	local var2_210 = bit.lshift(bit.rshift(var1_210, 1), 1) + 1
	local var3_210 = {
		var7_0[var2_210],
		var7_0[var2_210 + 1]
	}
	local var4_210 = _.map(var3_210, function(arg0_211)
		return getProxy(ChapterProxy):getMapById(arg0_211)
	end)

	if _.all(var4_210, function(arg0_212)
		return arg0_212:isAllChaptersClear()
	end) then
		local var5_210 = {
			arg0_210:GetMapElement(arg1_210)
		}

		if not arg2_210 or math.abs(var0_210 - arg2_210) ~= 1 then
			return var5_210
		end

		local var6_210 = var9_0[bit.rshift(var2_210 - 1, 1) + 1]
		local var7_210 = bit.band(var1_210, 1) == 1

		return var5_210, var6_210, var7_210
	else
		local var8_210 = 0

		;(function()
			local var0_213 = var4_210[1]:getChapters()

			for iter0_213, iter1_213 in ipairs(var0_213) do
				if not iter1_213:isClear() then
					return
				end

				var8_210 = var8_210 + 1
			end

			if not var4_210[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_210 = var8_210 + 1

			local var1_213 = var4_210[2]:getChapters()

			for iter2_213, iter3_213 in ipairs(var1_213) do
				if not iter3_213:isClear() then
					return
				end

				var8_210 = var8_210 + 1
			end
		end)()

		local var9_210

		if var8_210 > 0 then
			local var10_210 = var8_0[bit.rshift(var2_210 - 1, 1) + 1]

			var9_210 = {
				{
					BG = "map_" .. var10_210[1],
					Animator = var10_210[2]
				},
				{
					BG = "map_" .. var10_210[3] + var8_210,
					Animator = var10_210[4]
				}
			}
		else
			var9_210 = {
				arg0_210:GetMapElement(arg1_210)
			}
		end

		return var9_210
	end
end

function var0_0.GetMapElement(arg0_214, arg1_214)
	local var0_214 = arg1_214:getConfig("bg")
	local var1_214 = arg1_214:getConfig("ani_controller")

	if var1_214 and #var1_214 > 0 then
		(function()
			local var0_215 = getProxy(ChapterProxy)

			for iter0_215, iter1_215 in ipairs(var1_214) do
				local var1_215 = _.rest(iter1_215[2], 2)

				for iter2_215, iter3_215 in ipairs(var1_215) do
					if string.find(iter3_215, "^map_") and iter1_215[1] == var3_0 then
						local var2_215 = iter1_215[2][1]
						local var3_215 = false

						for iter4_215, iter5_215 in ipairs(var2_215) do
							local var4_215 = var0_215:GetChapterItemById(iter5_215)

							if var4_215 and var4_215:isClear() then
								var3_215 = true

								break
							end
						end

						if not var3_215 then
							var0_214 = iter3_215

							return
						end
					end
				end
			end
		end)()
	end

	local var2_214 = {
		BG = var0_214
	}

	var2_214.Animator, var2_214.AnimatorController = arg0_214:GetMapAnimator(arg1_214)

	return var2_214
end

function var0_0.GetMapAnimator(arg0_216, arg1_216)
	local var0_216 = arg1_216:getConfig("ani_name")

	if arg1_216:getConfig("animtor") == 1 and var0_216 and #var0_216 > 0 then
		local var1_216 = arg1_216:getConfig("ani_controller")

		if var1_216 and #var1_216 > 0 then
			(function()
				local var0_217 = getProxy(ChapterProxy)

				for iter0_217, iter1_217 in ipairs(var1_216) do
					local var1_217 = _.rest(iter1_217[2], 2)

					for iter2_217, iter3_217 in ipairs(var1_217) do
						if string.find(iter3_217, "^effect_") and iter1_217[1] == var3_0 then
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
								var0_216 = "map_" .. string.sub(iter3_217, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_216, var1_216
	end
end

function var0_0.PlayMapTransition(arg0_218, arg1_218, arg2_218, arg3_218, arg4_218)
	arg0_218.mapTransitions = arg0_218.mapTransitions or {}

	local var0_218

	local function var1_218()
		arg0_218:frozen()
		existCall(arg3_218, var0_218)
		var0_218:SetActive(true)

		local var0_219 = tf(var0_218)

		pg.UIMgr.GetInstance():OverlayPanel(var0_219)
		var0_218:GetComponent(typeof(Animator)):Play(arg2_218 and "Sequence" or "Inverted", -1, 0)
		var0_219:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_220)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_219, arg0_218._tf)
			existCall(arg4_218, var0_218)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_218, arg1_218, var0_218)

			arg0_218.mapTransitions[arg1_218] = false

			arg0_218:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_218, arg1_218, true, function(arg0_221)
		var0_218 = arg0_221
		arg0_218.mapTransitions[arg1_218] = arg0_221

		var1_218()
	end)
end

function var0_0.DestroyLevelStageView(arg0_222)
	if arg0_222.levelStageView then
		arg0_222.levelStageView:Destroy()

		arg0_222.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_223, arg1_223)
	arg0_223.levelAmbushView = LevelAmbushView.New(arg0_223.topPanel, arg0_223.event, arg0_223.contextData)

	arg0_223.levelAmbushView:Load()
	arg0_223.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_223)
end

function var0_0.hideAmbushInfo(arg0_224)
	if arg0_224.levelAmbushView then
		arg0_224.levelAmbushView:Destroy()

		arg0_224.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_225, arg1_225)
	arg0_225:frozen()

	local function var0_225()
		arg0_225.ambushWarning:SetActive(true)

		local var0_226 = tf(arg0_225.ambushWarning)

		var0_226:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_226:SetSiblingIndex(1)

		local var1_226 = var0_226:GetComponent("DftAniEvent")

		var1_226:SetTriggerEvent(function(arg0_227)
			arg1_225()
		end)
		var1_226:SetEndEvent(function(arg0_228)
			arg0_225.ambushWarning:SetActive(false)
			arg0_225:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_225.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_230)
			arg0_230:SetActive(true)

			arg0_225.ambushWarning = arg0_230

			var0_225()
		end)
	else
		var0_225()
	end
end

function var0_0.destroyAmbushWarn(arg0_231)
	if arg0_231.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_231.ambushWarning)

		arg0_231.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_232, arg1_232)
	arg0_232.levelStrategyView = LevelStrategyView.New(arg0_232.topPanel, arg0_232.event, arg0_232.contextData)

	arg0_232.levelStrategyView:Load()
	arg0_232.levelStrategyView:ActionInvoke("set", arg1_232)

	local function var0_232()
		local var0_233 = arg0_232.contextData.chapterVO.fleet
		local var1_233 = pg.strategy_data_template[arg1_232.id]

		if not var0_233:canUseStrategy(arg1_232) then
			return
		end

		local var2_233 = var0_233:getNextStgUser(arg1_232.id)

		if var1_233.type == ChapterConst.StgTypeForm then
			arg0_232:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_233,
				arg1 = arg1_232.id
			})
		elseif var1_233.type == ChapterConst.StgTypeConsume then
			arg0_232:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_233,
				arg1 = arg1_232.id
			})
		end

		arg0_232:hideStrategyInfo()
	end

	local function var1_232()
		arg0_232:hideStrategyInfo()
	end

	arg0_232.levelStrategyView:ActionInvoke("setCBFunc", var0_232, var1_232)
end

function var0_0.hideStrategyInfo(arg0_235)
	if arg0_235.levelStrategyView then
		arg0_235.levelStrategyView:Destroy()

		arg0_235.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_236, arg1_236)
	local var0_236 = arg0_236.contextData.chapterVO
	local var1_236 = getProxy(ChapterProxy)
	local var2_236
	local var3_236
	local var4_236
	local var5_236
	local var6_236 = var1_236.repairTimes
	local var7_236, var8_236, var9_236 = ChapterConst.GetRepairParams()

	arg0_236.levelRepairView = LevelRepairView.New(arg0_236.topPanel, arg0_236.event, arg0_236.contextData)

	arg0_236.levelRepairView:Load()
	arg0_236.levelRepairView:ActionInvoke("set", var6_236, var7_236, var8_236, var9_236)

	local function var10_236()
		if var7_236 - math.min(var6_236, var7_236) == 0 and arg0_236.player:getTotalGem() < var9_236 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_236:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_236.fleet.id,
			arg1 = arg1_236.id
		})
		arg0_236:hideRepairWindow()
	end

	local function var11_236()
		arg0_236:hideRepairWindow()
	end

	arg0_236.levelRepairView:ActionInvoke("setCBFunc", var10_236, var11_236)
end

function var0_0.hideRepairWindow(arg0_239)
	if arg0_239.levelRepairView then
		arg0_239.levelRepairView:Destroy()

		arg0_239.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_240, arg1_240)
	arg0_240.levelRemasterView:Load()

	local function var0_240(arg0_241)
		arg0_240:ShowSelectedMap(arg0_241)
	end

	arg0_240.levelRemasterView:ActionInvoke("Show")
	arg0_240.levelRemasterView:ActionInvoke("set", var0_240, arg1_240)
end

function var0_0.hideRemasterPanel(arg0_242)
	if arg0_242.levelRemasterView:isShowing() then
		arg0_242.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_243, arg1_243)
	local var0_243 = arg0_243.contextData.chapterVO

	if not var0_243 then
		return
	end

	arg0_243:enableLevelCamera()
	setActive(arg0_243.uiMain, true)

	arg0_243.levelGrid.localEulerAngles = Vector3(var0_243.theme.angle, 0, 0)
	arg0_243.grid = LevelGrid.New(arg0_243.dragLayer)

	arg0_243.grid:attach(arg0_243)
	arg0_243.grid:ExtendItem("shipTpl", arg0_243.shipTpl)
	arg0_243.grid:ExtendItem("subTpl", arg0_243.subTpl)
	arg0_243.grid:ExtendItem("transportTpl", arg0_243.transportTpl)
	arg0_243.grid:ExtendItem("enemyTpl", arg0_243.enemyTpl)
	arg0_243.grid:ExtendItem("championTpl", arg0_243.championTpl)
	arg0_243.grid:ExtendItem("oniTpl", arg0_243.oniTpl)
	arg0_243.grid:ExtendItem("arrowTpl", arg0_243.arrowTarget)
	arg0_243.grid:ExtendItem("destinationMarkTpl", arg0_243.destinationMarkTpl)

	function arg0_243.grid.onShipStepChange(arg0_244)
		arg0_243.levelStageView:updateAmbushRate(arg0_244)
	end

	arg0_243.grid:initAll(arg1_243)
end

function var0_0.destroyGrid(arg0_245)
	if arg0_245.grid then
		arg0_245.grid:detach()

		arg0_245.grid = nil

		arg0_245:disableLevelCamera()
		setActive(arg0_245.dragLayer, true)
		setActive(arg0_245.uiMain, false)
	end
end

function var0_0.doTracking(arg0_246, arg1_246)
	arg0_246:frozen()

	local function var0_246()
		arg0_246.radar:SetActive(true)

		local var0_247 = tf(arg0_246.radar)

		var0_247:SetParent(arg0_246.topPanel, false)
		var0_247:SetSiblingIndex(1)
		var0_247:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_248)
			arg0_246.radar:SetActive(false)
			arg0_246:unfrozen()
			arg1_246()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_246.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_249)
			arg0_249:SetActive(true)

			arg0_246.radar = arg0_249

			var0_246()
		end)
	else
		var0_246()
	end
end

function var0_0.destroyTracking(arg0_250)
	if arg0_250.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_250.radar)

		arg0_250.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_251, arg1_251, arg2_251, arg3_251)
	local function var0_251()
		arg0_251.playing = true

		arg0_251:frozen()
		arg0_251.airStrike:SetActive(true)

		local var0_252 = tf(arg0_251.airStrike)

		var0_252:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_252:SetAsLastSibling()
		setActive(var0_252:Find("words/be_striked"), arg1_251 == ChapterConst.SubjectChampion)
		setActive(var0_252:Find("words/strike_enemy"), arg1_251 == ChapterConst.SubjectPlayer)

		local function var1_252()
			arg0_251.playing = false

			SetActive(arg0_251.airStrike, false)

			if arg3_251 then
				arg3_251()
			end

			arg0_251:unfrozen()
		end

		var0_252:GetComponent("DftAniEvent"):SetEndEvent(var1_252)

		if arg2_251 then
			onButton(arg0_251, var0_252, var1_252, SFX_PANEL)
		else
			removeOnButton(var0_252)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_251.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_254)
			arg0_254:SetActive(true)

			arg0_251.airStrike = arg0_254

			var0_251()
		end)
	else
		var0_251()
	end
end

function var0_0.destroyAirStrike(arg0_255)
	if arg0_255.airStrike then
		arg0_255.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_255.airStrike)

		arg0_255.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_256, arg1_256, arg2_256, arg3_256)
	arg0_256.uiAnims = arg0_256.uiAnims or {}

	local var0_256 = arg0_256.uiAnims[arg1_256]

	local function var1_256()
		arg0_256.playing = true

		arg0_256:frozen()
		var0_256:SetActive(true)

		local var0_257 = tf(var0_256)

		pg.UIMgr.GetInstance():OverlayPanel(var0_257)

		if arg3_256 then
			arg3_256(var0_256)
		end

		var0_257:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_258)
			arg0_256.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_257, arg0_256._tf)

			if arg2_256 then
				arg2_256(var0_256)
			end

			arg0_256:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_256 then
		PoolMgr.GetInstance():GetUI(arg1_256, true, function(arg0_259)
			arg0_259:SetActive(true)

			arg0_256.uiAnims[arg1_256] = arg0_259
			var0_256 = arg0_256.uiAnims[arg1_256]

			var1_256()
		end)
	else
		var1_256()
	end
end

function var0_0.destroyUIAnims(arg0_260)
	if arg0_260.uiAnims then
		for iter0_260, iter1_260 in pairs(arg0_260.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_260), arg0_260._tf)
			iter1_260:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_260, iter1_260)
		end

		arg0_260.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_261, arg1_261)
	local function var0_261()
		arg0_261.playing = true

		arg0_261:frozen()
		arg0_261.torpetoAni:SetActive(true)

		local var0_262 = tf(arg0_261.torpetoAni)

		var0_262:SetParent(arg0_261.topPanel, false)
		var0_262:SetAsLastSibling()
		var0_262:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_263)
			arg0_261.playing = false

			SetActive(arg0_261.torpetoAni, false)

			if arg1_261 then
				arg1_261()
			end

			arg0_261:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_261.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_264)
			arg0_264:SetActive(true)

			arg0_261.torpetoAni = arg0_264

			var0_261()
		end)
	else
		var0_261()
	end
end

function var0_0.destroyTorpedo(arg0_265)
	if arg0_265.torpetoAni then
		arg0_265.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_265.torpetoAni)

		arg0_265.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_266, arg1_266, arg2_266, arg3_266)
	arg0_266.strikeAnims = arg0_266.strikeAnims or {}

	local var0_266
	local var1_266
	local var2_266

	local function var3_266()
		if coroutine.status(var2_266) == "suspended" then
			local var0_267, var1_267 = coroutine.resume(var2_266)

			assert(var0_267, debug.traceback(var2_266, var1_267))
		end
	end

	var2_266 = coroutine.create(function()
		arg0_266.playing = true

		arg0_266:frozen()

		local var0_268 = arg0_266.strikeAnims[arg2_266]

		setActive(var0_268, true)

		local var1_268 = tf(var0_268)
		local var2_268 = findTF(var1_268, "torpedo")
		local var3_268 = findTF(var1_268, "mask/painting")
		local var4_268 = findTF(var1_268, "ship")

		setParent(var0_266, var3_268:Find("fitter"), false)
		var1_266:SetParent(var4_268)
		setActive(var4_268, false)
		setActive(var2_268, false)
		var1_268:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_268:SetAsLastSibling()

		local var5_268 = var1_268:GetComponent("DftAniEvent")
		local var6_268 = var1_266:GetSkeletonGraphic()

		var5_268:SetStartEvent(function(arg0_269)
			var1_266:SetAction("attack", 0)

			var6_268.freeze = true
		end)
		var5_268:SetTriggerEvent(function(arg0_270)
			var6_268.freeze = false

			var1_266:SetActionCallBack(function(arg0_271)
				if arg0_271 == "action" then
					-- block empty
				elseif arg0_271 == "finish" then
					var6_268.freeze = true
				end
			end)
		end)
		var5_268:SetEndEvent(function(arg0_272)
			var6_268.freeze = false

			var3_266()
		end)
		onButton(arg0_266, var1_268, var3_266, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_268, arg1_266:getPainting())
		var1_266:SetActionCallBack(nil)

		var6_268.freeze = false

		var1_266:Dispose()
		setActive(var0_268, false)

		arg0_266.playing = false

		arg0_266:unfrozen()

		if arg3_266 then
			arg3_266()
		end
	end)

	local function var4_266()
		if arg0_266.strikeAnims[arg2_266] and var0_266 and var1_266 then
			var3_266()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_266:getPainting(), true, function(arg0_274)
		var0_266 = arg0_274

		ShipExpressionHelper.SetExpression(var0_266, arg1_266:getPainting())
		var4_266()
	end)

	var1_266 = SpineAnimChar.New()

	var1_266:SetPaint(arg1_266:getPrefab())
	var1_266:Load(true, function(arg0_275)
		var1_266:SetLocalScale(Vector3.one)
		var4_266()
	end)

	if not arg0_266.strikeAnims[arg2_266] then
		PoolMgr.GetInstance():GetUI(arg2_266, true, function(arg0_276)
			arg0_266.strikeAnims[arg2_266] = arg0_276

			var4_266()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_277)
	if arg0_277.strikeAnims then
		for iter0_277, iter1_277 in pairs(arg0_277.strikeAnims) do
			iter1_277:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_277, iter1_277)
		end

		arg0_277.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_278, arg1_278, arg2_278, arg3_278)
	arg0_278.strikeAnims = arg0_278.strikeAnims or {}

	local var0_278
	local var1_278

	local function var2_278()
		if coroutine.status(var1_278) == "suspended" then
			local var0_279, var1_279 = coroutine.resume(var1_278)

			assert(var0_279, debug.traceback(var1_278, var1_279))
		end
	end

	var1_278 = coroutine.create(function()
		arg0_278.playing = true

		arg0_278:frozen()

		local var0_280 = arg0_278.strikeAnims[arg2_278]

		setActive(var0_280, true)

		local var1_280 = tf(var0_280)
		local var2_280 = findTF(var1_280, "torpedo")
		local var3_280 = findTF(var1_280, "ship")

		var0_278:SetParent(var3_280)
		setActive(var3_280, false)
		setActive(var2_280, false)
		var1_280:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_280:SetAsLastSibling()

		local var4_280 = var1_280:GetComponent("DftAniEvent")
		local var5_280 = var0_278:GetSkeletonGraphic()

		var4_280:SetStartEvent(function(arg0_281)
			var0_278:SetAction("attack", 0)

			var5_280.freeze = true
		end)
		var4_280:SetTriggerEvent(function(arg0_282)
			var5_280.freeze = false

			var0_278:SetActionCallBack(function(arg0_283)
				if arg0_283 == "action" then
					-- block empty
				elseif arg0_283 == "finish" then
					var5_280.freeze = true
				end
			end)
		end)
		var4_280:SetEndEvent(function(arg0_284)
			var5_280.freeze = false

			var2_278()
		end)
		onButton(arg0_278, var1_280, var2_278, SFX_CANCEL)
		coroutine.yield()
		var0_278:SetActionCallBack(nil)

		var5_280.freeze = false

		var0_278:Dispose()
		setActive(var0_280, false)

		arg0_278.playing = false

		arg0_278:unfrozen()

		if arg3_278 then
			arg3_278()
		end
	end)

	local function var3_278()
		if arg0_278.strikeAnims[arg2_278] and var0_278 then
			var2_278()
		end
	end

	var0_278 = SpineAnimChar.New()

	var0_278:SetPaint(arg1_278:getPrefab())
	var0_278:Load(true, function(arg0_286)
		arg0_286:SetLocalScale(Vector3.one)
		var3_278()
	end)

	if not arg0_278.strikeAnims[arg2_278] then
		PoolMgr.GetInstance():GetUI(arg2_278, true, function(arg0_287)
			arg0_278.strikeAnims[arg2_278] = arg0_287

			var3_278()
		end)
	end
end

function var0_0.doPlayCommander(arg0_288, arg1_288, arg2_288)
	arg0_288:frozen()
	setActive(arg0_288.commanderTinkle, true)

	local var0_288 = arg1_288:getSkills()

	setText(arg0_288.commanderTinkle:Find("name"), #var0_288 > 0 and var0_288[1]:getConfig("name") or "")
	setImageSprite(arg0_288.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_288:getConfig("painting"), ""))

	local var1_288 = arg0_288.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_288.alpha = 0

	local var2_288 = Vector2(248, 237)

	LeanTween.value(go(arg0_288.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_289)
		local var0_289 = arg0_288.commanderTinkle.localPosition

		var0_289.x = var2_288.x + -100 * (1 - arg0_289)
		arg0_288.commanderTinkle.localPosition = var0_289
		var1_288.alpha = arg0_289
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_288.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_290)
		local var0_290 = arg0_288.commanderTinkle.localPosition

		var0_290.x = var2_288.x + 100 * arg0_290
		arg0_288.commanderTinkle.localPosition = var0_290
		var1_288.alpha = 1 - arg0_290
	end)):setOnComplete(System.Action(function()
		if arg2_288 then
			arg2_288()
		end

		arg0_288:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_292, arg1_292, arg2_292, arg3_292)
	local var0_292 = arg0_292.grid:shakeCell(arg1_292)

	if not var0_292 then
		arg3_292()

		return
	end

	arg0_292:easeDamage(var0_292, arg2_292, function()
		arg3_292()
	end)
end

function var0_0.easeDamage(arg0_294, arg1_294, arg2_294, arg3_294)
	arg0_294:frozen()

	local var0_294 = arg0_294.levelCam:WorldToScreenPoint(arg1_294.position)
	local var1_294 = tf(arg0_294:GetDamageText())

	var1_294.position = arg0_294.uiCam:ScreenToWorldPoint(var0_294)

	local var2_294 = var1_294.localPosition

	var2_294.y = var2_294.y + 40
	var2_294.z = 0

	setText(var1_294, arg2_294)

	var1_294.localPosition = var2_294

	LeanTween.value(go(var1_294), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_295)
		local var0_295 = var1_294.localPosition

		var0_295.y = var2_294.y + 60 * arg0_295
		var1_294.localPosition = var0_295

		setTextAlpha(var1_294, 1 - arg0_295)
	end)):setOnComplete(System.Action(function()
		arg0_294:ReturnDamageText(var1_294)
		arg0_294:unfrozen()

		if arg3_294 then
			arg3_294()
		end
	end))
end

function var0_0.easeAvoid(arg0_297, arg1_297, arg2_297)
	arg0_297:frozen()

	local var0_297 = arg0_297.levelCam:WorldToScreenPoint(arg1_297)

	arg0_297.avoidText.position = arg0_297.uiCam:ScreenToWorldPoint(var0_297)

	local var1_297 = arg0_297.avoidText.localPosition

	var1_297.z = 0
	arg0_297.avoidText.localPosition = var1_297

	setActive(arg0_297.avoidText, true)

	local var2_297 = arg0_297.avoidText:Find("avoid")

	LeanTween.value(go(arg0_297.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_298)
		local var0_298 = arg0_297.avoidText.localPosition

		var0_298.y = var1_297.y + 100 * arg0_298
		arg0_297.avoidText.localPosition = var0_298

		setImageAlpha(arg0_297.avoidText, 1 - arg0_298)
		setImageAlpha(var2_297, 1 - arg0_298)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_297.avoidText, false)
		arg0_297:unfrozen()

		if arg2_297 then
			arg2_297()
		end
	end))
end

function var0_0.GetDamageText(arg0_300)
	local var0_300 = table.remove(arg0_300.damageTextPool)

	if not var0_300 then
		var0_300 = Instantiate(arg0_300.damageTextTemplate)

		local var1_300 = tf(arg0_300.damageTextTemplate):GetSiblingIndex()

		setParent(var0_300, tf(arg0_300.damageTextTemplate).parent)
		tf(var0_300):SetSiblingIndex(var1_300 + 1)
	end

	table.insert(arg0_300.damageTextActive, var0_300)
	setActive(var0_300, true)

	return var0_300
end

function var0_0.ReturnDamageText(arg0_301, arg1_301)
	assert(arg1_301)

	if not arg1_301 then
		return
	end

	arg1_301 = go(arg1_301)

	table.removebyvalue(arg0_301.damageTextActive, arg1_301)
	table.insert(arg0_301.damageTextPool, arg1_301)
	setActive(arg1_301, false)
end

function var0_0.resetLevelGrid(arg0_302)
	arg0_302.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_303, arg1_303)
	setActive(arg0_303.curtain, arg1_303)
end

function var0_0.frozen(arg0_304)
	local var0_304 = arg0_304.frozenCount

	arg0_304.frozenCount = arg0_304.frozenCount + 1
	arg0_304.canvasGroup.blocksRaycasts = arg0_304.frozenCount == 0

	if var0_304 == 0 and arg0_304.frozenCount ~= 0 then
		arg0_304:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_305, arg1_305)
	if arg0_305.exited then
		return
	end

	local var0_305 = arg0_305.frozenCount
	local var1_305 = arg1_305 == -1 and arg0_305.frozenCount or arg1_305 or 1

	arg0_305.frozenCount = arg0_305.frozenCount - var1_305
	arg0_305.canvasGroup.blocksRaycasts = arg0_305.frozenCount == 0

	if var0_305 ~= 0 and arg0_305.frozenCount == 0 then
		arg0_305:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_306)
	return arg0_306.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_307)
	arg0_307.levelCamIndices = math.max(arg0_307.levelCamIndices - 1, 0)

	if arg0_307.levelCamIndices == 0 then
		arg0_307.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.disableLevelCamera(arg0_308)
	arg0_308.levelCamIndices = arg0_308.levelCamIndices + 1

	if arg0_308.levelCamIndices > 0 then
		arg0_308.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.RecordTween(arg0_309, arg1_309, arg2_309)
	arg0_309.tweens[arg1_309] = arg2_309
end

function var0_0.DeleteTween(arg0_310, arg1_310)
	local var0_310 = arg0_310.tweens[arg1_310]

	if var0_310 then
		LeanTween.cancel(var0_310)

		arg0_310.tweens[arg1_310] = nil
	end
end

function var0_0.openCommanderPanel(arg0_311, arg1_311, arg2_311, arg3_311)
	local var0_311 = arg2_311.id

	arg0_311.levelCMDFormationView:setCallback(function(arg0_312)
		if not arg3_311 then
			if arg0_312.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_311:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_312.skill)
			elseif arg0_312.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_311.contextData.commanderSelected = {
					chapterId = var0_311,
					fleetId = arg1_311.id
				}

				arg0_311:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_312.pos, arg1_311.id, arg2_311)
				arg0_311:closeCommanderPanel()
			else
				arg0_311:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_312,
					fleetId = arg1_311.id,
					chapterId = var0_311
				}, arg2_311)
			end
		elseif arg0_312.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_311:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_312.skill)
		elseif arg0_312.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_311.contextData.eliteCommanderSelected = {
				index = arg3_311,
				pos = arg0_312.pos,
				chapterId = var0_311
			}

			arg0_311:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_311, arg0_312.pos, arg2_311)
			arg0_311:closeCommanderPanel()
		else
			arg0_311:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_312,
				index = arg3_311,
				chapterId = var0_311
			}, arg2_311)
		end
	end)
	arg0_311.levelCMDFormationView:Load()
	arg0_311.levelCMDFormationView:ActionInvoke("update", arg1_311, arg0_311.commanderPrefabs)
	arg0_311.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_313)
	if arg0_313.levelCMDFormationView:isShowing() then
		arg0_313.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_313.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_314)
	arg0_314.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_315)
	arg0_315.levelCMDFormationView:Destroy()

	arg0_315.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_316, arg1_316)
	arg0_316.spTickets = arg1_316
end

function var0_0.HandleShowMsgBox(arg0_317, arg1_317)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_317)
end

function var0_0.updatePoisonAreaTip(arg0_318)
	local var0_318 = arg0_318.contextData.chapterVO
	local var1_318 = (function(arg0_319)
		local var0_319 = {}
		local var1_319 = pg.map_event_list[var0_318.id] or {}
		local var2_319

		if var0_318:isLoop() then
			var2_319 = var1_319.event_list_loop or {}
		else
			var2_319 = var1_319.event_list or {}
		end

		for iter0_319, iter1_319 in ipairs(var2_319) do
			local var3_319 = pg.map_event_template[iter1_319]

			if var3_319.c_type == arg0_319 then
				table.insert(var0_319, var3_319)
			end
		end

		return var0_319
	end)(ChapterConst.EvtType_Poison)

	if var1_318 then
		for iter0_318, iter1_318 in ipairs(var1_318) do
			local var2_318 = iter1_318.round_gametip

			if var2_318 ~= nil and var2_318 ~= "" and var0_318:getRoundNum() == var2_318[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_318[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_320)
	setActive(arg0_320._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_321)
	local var0_321 = getProxy(ChapterProxy)

	if var0_321 and not arg0_321.contextData.noRecord then
		local var1_321 = arg0_321.contextData.map

		if not var1_321 then
			return
		end

		if var1_321:NeedRecordMap() then
			var0_321:recordLastMap(ChapterProxy.LAST_MAP, var1_321.id)
		end

		if var1_321:isActivity() and not var1_321:isActExtra() then
			var0_321:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_321.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_322)
	local var0_322 = arg0_322.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_322.contextData.map:getConfig("on_activity")) or nil
	local var1_322 = var0_322 and not var0_322:isEnd() and var0_322:GetConfigClientSetting("PTID")
	local var2_322 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var2_322 and not var2_322:isEnd() and var2_322:getConfig("config_client").resId == var1_322 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_323)
		return not arg0_323:isEnd() and arg0_323:getConfig("config_client").pt_id == var1_322
	end) then
		return true
	end
end

function var0_0.OnStartChapterAuto(arg0_324, arg1_324)
	if arg0_324.levelInfoView:isShowing() then
		arg0_324:hideChapterPanel()
	end

	if arg0_324.levelInfoSPView and arg0_324.levelInfoSPView:isShowing() then
		arg0_324:HideLevelInfoSPPanel()
	end
end

function var0_0.OnEndChapterAuto(arg0_325, arg1_325)
	return
end

function var0_0.OnAddChapterAutoTimeDone(arg0_326)
	if arg0_326.levelInfoView:isShowing() then
		arg0_326.levelInfoView:RefreshChapterAutoPanel()
	end

	if arg0_326.levelInfoSPView and arg0_326.levelInfoSPView:isShowing() then
		arg0_326.levelInfoView:RefreshChapterAutoPanel()
	end
end

function var0_0.ShowChapterAutoDetailPanel(arg0_327, arg1_327)
	arg0_327.chapterAutoDetailPanel:Load()
	arg0_327.chapterAutoDetailPanel:ActionInvoke("Enter", arg1_327)
end

function var0_0.HideChapterAutoDetailPanel(arg0_328)
	if arg0_328.chapterAutoDetailPanel:isShowing() then
		arg0_328.chapterAutoDetailPanel:Hide()
	end
end

function var0_0.DestroyChapterAutoDetailPanel(arg0_329)
	if arg0_329.chapterAutoDetailPanel then
		arg0_329.chapterAutoDetailPanel:Destroy()

		arg0_329.chapterAutoDetailPanel = nil
	end
end

function var0_0.willExit(arg0_330)
	arg0_330:ClearMapTransitions()
	arg0_330.loader:Clear()

	if arg0_330.contextData.chapterVO then
		arg0_330:UnOverlayPanel(arg0_330.topPanel, arg0_330._tf)
	end

	if arg0_330.levelFleetView and arg0_330.levelFleetView.selectIds then
		arg0_330.contextData.selectedFleetIDs = {}

		for iter0_330, iter1_330 in pairs(arg0_330.levelFleetView.selectIds) do
			for iter2_330, iter3_330 in pairs(iter1_330) do
				arg0_330.contextData.selectedFleetIDs[#arg0_330.contextData.selectedFleetIDs + 1] = iter3_330
			end
		end
	end

	arg0_330:destroyChapterPanel()
	arg0_330:DestroyLevelInfoSPPanel()
	arg0_330:destroyFleetEdit()
	arg0_330:destroyCommanderPanel()
	arg0_330:DestroyLevelStageView()
	arg0_330:hideRepairWindow()
	arg0_330:hideStrategyInfo()
	arg0_330:hideRemasterPanel()
	arg0_330:hideSpResult()
	arg0_330:destroyGrid()
	arg0_330:destroyAmbushWarn()
	arg0_330:destroyAirStrike()
	arg0_330:destroyTorpedo()
	arg0_330:destroyStrikeAnim()
	arg0_330:destroyTracking()
	arg0_330:destroyUIAnims()
	arg0_330:DestroyChapterAutoDetailPanel()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_330, iter5_330 in pairs(arg0_330.mbDict) do
		iter5_330:Destroy()
	end

	arg0_330.mbDict = nil

	for iter6_330, iter7_330 in pairs(arg0_330.tweens) do
		LeanTween.cancel(iter7_330)
	end

	arg0_330.tweens = nil

	if arg0_330.cloudTimer then
		_.each(arg0_330.cloudTimer, function(arg0_331)
			LeanTween.cancel(arg0_331)
		end)

		arg0_330.cloudTimer = nil
	end

	if arg0_330.newChapterCDTimer then
		arg0_330.newChapterCDTimer:Stop()

		arg0_330.newChapterCDTimer = nil
	end

	for iter8_330, iter9_330 in ipairs(arg0_330.damageTextActive) do
		LeanTween.cancel(iter9_330)
	end

	LeanTween.cancel(go(arg0_330.avoidText))

	arg0_330.map.localScale = Vector3.one
	arg0_330.map.pivot = Vector2(0.5, 0.5)
	arg0_330.float.localScale = Vector3.one
	arg0_330.float.pivot = Vector2(0.5, 0.5)

	for iter10_330, iter11_330 in ipairs(arg0_330.mapTFs) do
		clearImageSprite(iter11_330)
	end

	_.each(arg0_330.cloudRTFs, function(arg0_332)
		clearImageSprite(arg0_332)
	end)
	Destroy(arg0_330.enemyTpl)
	arg0_330:RecordLastMapOnExit()
	arg0_330.levelRemasterView:Destroy()
end

return var0_0
