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

	arg0_12.resources = arg0_12._tf:Find("resources"):GetComponent("ItemList")
	arg0_12.arrowTarget = arg0_12.resources.prefabItem[0]
	arg0_12.destinationMarkTpl = arg0_12.resources.prefabItem[1]
	arg0_12.championTpl = arg0_12.resources.prefabItem[3]
	arg0_12.deadTpl = arg0_12.resources.prefabItem[4]
	arg0_12.enemyTpl = Instantiate(arg0_12.resources.prefabItem[5])
	arg0_12.oniTpl = arg0_12.resources.prefabItem[6]
	arg0_12.shipTpl = arg0_12.resources.prefabItem[8]
	arg0_12.subTpl = arg0_12.resources.prefabItem[9]
	arg0_12.transportTpl = arg0_12.resources.prefabItem[11]

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

	onButton(arg0_36, arg0_36.topChapter:Find("back_button"), function()
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
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB] = function()
				arg0_36:emit(LevelMediator2.ON_COLLAB_BOSSRUSH_MAP)
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

		local var0_55, var1_55 = arg0_36:checkChallengeOpen()

		if var0_55 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1_55)
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

function var0_0.updateRightPanel(arg0_59)
	arg0_59.rightActivityBtns = defaultValue(arg0_59.rightActivityBtns, {
		LevelSecondMapBtn.New(arg0_59.actBtnTpl, arg0_59.event, false)
	})

	local var0_59 = {}
	local var1_59 = {}

	for iter0_59, iter1_59 in ipairs(arg0_59.rightActivityBtns) do
		if iter1_59:InShowTime() then
			table.insert(var0_59, iter1_59)
		else
			table.insert(var1_59, iter1_59)
		end
	end

	table.sort(var0_59, CompareFuncs({
		function(arg0_60)
			return arg0_60.config.group_id
		end
	}))

	for iter2_59, iter3_59 in ipairs(var0_59) do
		iter3_59:Init(iter2_59)
	end

	for iter4_59, iter5_59 in ipairs(var1_59) do
		iter5_59:Clear()
	end
end

function var0_0.checkChallengeOpen(arg0_61)
	local var0_61 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_61, "ChallengeMainMediator")
end

function var0_0.tryPlaySubGuide(arg0_62)
	if arg0_62.contextData.map and arg0_62.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0_62)
end

function var0_0.onBackPressed(arg0_63)
	if arg0_63:isfrozen() then
		return
	end

	if arg0_63.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_63.levelInfoView:isShowing() then
		arg0_63:hideChapterPanel()

		return
	end

	if arg0_63.levelInfoSPView and arg0_63.levelInfoSPView:isShowing() then
		arg0_63:HideLevelInfoSPPanel()

		return
	end

	if arg0_63.levelFleetView:isShowing() then
		arg0_63:hideFleetEdit()

		return
	end

	if arg0_63.levelStrategyView then
		arg0_63:hideStrategyInfo()

		return
	end

	if arg0_63.levelRepairView then
		arg0_63:hideRepairWindow()

		return
	end

	if arg0_63.levelRemasterView:isShowing() then
		arg0_63:hideRemasterPanel()

		return
	end

	if arg0_63.contextData.map and arg0_63.contextData.map:getConfig("ui_type") == MapBuilder.TYPEEXSP and arg0_63.mapBuilder.personalPage:IsActive() then
		arg0_63.mapBuilder.personalPage:Hide()

		return
	end

	if isActive(arg0_63.helpPage) then
		setActive(arg0_63.helpPage, false)

		return
	end

	local var0_63 = arg0_63.contextData.chapterVO
	local var1_63 = getProxy(ChapterProxy):getActiveChapter()

	if var0_63 and var1_63 then
		arg0_63:switchToMap()

		return
	end

	triggerButton(arg0_63.topChapter:Find("back_button"))
end

function var0_0.ShowEntranceUI(arg0_64, arg1_64)
	setActive(arg0_64.entranceLayer, arg1_64)
	setActive(arg0_64.entranceBg, arg1_64)
	setActive(arg0_64.map, not arg1_64)
	setActive(arg0_64.float, not arg1_64)
	setActive(arg0_64.mainLayer, not arg1_64)
	setActive(arg0_64.topChapter:Find("type_entrance"), arg1_64)

	arg0_64.contextData.entranceStatus = tobool(arg1_64)

	if arg1_64 then
		setActive(arg0_64.topChapter:Find("title_chapter"), false)
		setActive(arg0_64.topChapter:Find("type_chapter"), false)
		setActive(arg0_64.topChapter:Find("type_escort"), false)
		setActive(arg0_64.topChapter:Find("type_skirmish"), false)

		if arg0_64.newChapterCDTimer then
			arg0_64.newChapterCDTimer:Stop()

			arg0_64.newChapterCDTimer = nil
		end

		arg0_64:RecordLastMapOnExit()

		arg0_64.contextData.mapIdx = nil
		arg0_64.contextData.map = nil
	end

	arg0_64:PlayBGM()
end

function var0_0.PreloadLevelMainUI(arg0_65, arg1_65, arg2_65)
	if arg0_65.preloadLevelDone then
		existCall(arg2_65)

		return
	end

	local var0_65

	local function var1_65()
		if not arg0_65.exited then
			arg0_65.preloadLevelDone = true

			existCall(arg2_65)
		end
	end

	local var2_65 = getProxy(ChapterProxy):getMapById(arg1_65)
	local var3_65 = arg0_65:GetMapBG(var2_65)

	table.ParallelIpairsAsync(var3_65, function(arg0_67, arg1_67, arg2_67)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1_67.BG, "", arg2_67)
	end, var1_65)
end

function var0_0.setShips(arg0_68, arg1_68)
	arg0_68.shipVOs = arg1_68
end

function var0_0.updateRes(arg0_69, arg1_69)
	if arg0_69.levelStageView then
		arg0_69.levelStageView:ActionInvoke("SetPlayer", arg1_69)
	end

	arg0_69.player = arg1_69
end

function var0_0.setEliteQuota(arg0_70, arg1_70, arg2_70)
	local var0_70 = arg2_70 - arg1_70
	local var1_70 = arg0_70.eliteQuota:Find("bg/Text"):GetComponent(typeof(Text))

	if arg1_70 == arg2_70 then
		var1_70.color = Color.red
	else
		var1_70.color = Color.New(0.47, 0.89, 0.27)
	end

	var1_70.text = var0_70 .. "/" .. arg2_70
end

function var0_0.updateEvent(arg0_71, arg1_71)
	local var0_71 = arg1_71:hasFinishState()

	setActive(arg0_71.btnSpecial:Find("tip"), var0_71)
	setActive(arg0_71.entranceLayer:Find("btns/btn_task/tip"), var0_71)
end

function var0_0.updateFleet(arg0_72, arg1_72)
	arg0_72.fleets = arg1_72
end

function var0_0.updateChapterVO(arg0_73, arg1_73, arg2_73)
	if arg0_73.contextData.chapterVO and arg0_73.contextData.chapterVO.id == arg1_73.id and arg1_73.active then
		arg0_73:setChapter(arg1_73)
	end

	if arg0_73.contextData.chapterVO and arg0_73.contextData.chapterVO.id == arg1_73.id and arg1_73.active and arg0_73.levelStageView and arg0_73.grid then
		local var0_73 = false
		local var1_73 = false
		local var2_73 = false

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyFleet) > 0 then
			arg0_73.levelStageView:updateStageFleet()
			arg0_73.levelStageView:updateAmbushRate(arg1_73.fleet.line, true)

			var2_73 = true

			if arg0_73.grid then
				arg0_73.grid:RefreshFleetCells()
				arg0_73.grid:UpdateFloor()

				var0_73 = true
			end
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyChampion) > 0 then
			var2_73 = true

			if arg0_73.grid then
				arg0_73.grid:UpdateFleets()
				arg0_73.grid:clearChampions()
				arg0_73.grid:initChampions()

				var1_73 = true
			end
		elseif bit.band(arg2_73, ChapterConst.DirtyChampionPosition) > 0 then
			var2_73 = true

			if arg0_73.grid then
				arg0_73.grid:UpdateFleets()
				arg0_73.grid:updateChampions()

				var1_73 = true
			end
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyAchieve) > 0 then
			arg0_73.levelStageView:updateStageAchieve()
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyAttachment) > 0 then
			arg0_73.levelStageView:updateAmbushRate(arg1_73.fleet.line, true)

			if arg0_73.grid then
				if not (arg2_73 < 0) and not (bit.band(arg2_73, ChapterConst.DirtyFleet) > 0) then
					arg0_73.grid:updateFleet(arg1_73.fleets[arg1_73.findex].id)
				end

				arg0_73.grid:updateAttachments()

				if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyAutoAction) > 0 then
					arg0_73.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var0_73 = true
				end
			end
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyStrategy) > 0 then
			arg0_73.levelStageView:updateStageStrategy()

			var2_73 = true

			arg0_73.levelStageView:updateStageBarrier()
			arg0_73.levelStageView:UpdateAutoFightPanel()
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var0_73 then
			arg0_73.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var1_73 then
			arg0_73.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyCellFlag) > 0 then
			arg0_73.grid:UpdateFloor()
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyBase) > 0 then
			arg0_73.levelStageView:UpdateDefenseStatus()
		end

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyFloatItems) > 0 then
			arg0_73.grid:UpdateItemCells()
		end

		if var2_73 then
			arg0_73.levelStageView:updateFleetBuff()
		end
	end
end

function var0_0.updateClouds(arg0_74)
	arg0_74.cloudRTFs = {}
	arg0_74.cloudRects = {}
	arg0_74.cloudTimer = {}

	for iter0_74 = 1, 6 do
		local var0_74 = arg0_74.clouds:Find("cloud_" .. iter0_74)
		local var1_74 = rtf(var0_74)

		table.insert(arg0_74.cloudRTFs, var1_74)
		table.insert(arg0_74.cloudRects, var1_74.rect.width)
	end

	arg0_74:initCloudsPos()

	for iter1_74, iter2_74 in ipairs(arg0_74.cloudRTFs) do
		local var2_74 = arg0_74.cloudRects[iter1_74]
		local var3_74 = arg0_74.initPositions[iter1_74] or Vector2(0, 0)
		local var4_74 = 30 - var3_74.y / 20
		local var5_74 = (arg0_74.mapWidth + var2_74) / var4_74
		local var6_74

		var6_74 = LeanTween.moveX(iter2_74, arg0_74.mapWidth, var5_74):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2_74 = arg0_74.cloudRects[iter1_74]
			iter2_74.anchoredPosition = Vector2(-var2_74, var3_74.y)

			var6_74:setFrom(-var2_74):setTime((arg0_74.mapWidth + var2_74) / var4_74)
		end))
		var6_74.passed = math.random() * var5_74
		arg0_74.cloudTimer[iter1_74] = var6_74.uniqueId
	end
end

function var0_0.RefreshMapBG(arg0_76)
	arg0_76:PlayBGM()
	arg0_76:SwitchMapBG(arg0_76.contextData.map, nil, true)
end

function var0_0.updateCouldAnimator(arg0_77, arg1_77, arg2_77)
	if not arg1_77 then
		return
	end

	local var0_77 = arg0_77.contextData.map:getConfig("ani_controller")

	local function var1_77(arg0_78)
		arg0_78 = tf(arg0_78)

		local var0_78 = Vector3.one

		if arg0_78.rect.width > 0 and arg0_78.rect.height > 0 then
			var0_78.x = arg0_78.parent.rect.width / arg0_78.rect.width
			var0_78.y = arg0_78.parent.rect.height / arg0_78.rect.height
		end

		arg0_78.localScale = var0_78

		if var0_77 and #var0_77 > 0 then
			local var1_78 = getProxy(ChapterProxy)

			;(function()
				for iter0_79, iter1_79 in ipairs(var0_77) do
					local var0_79 = false
					local var1_79 = iter1_79[2][1]

					for iter2_79, iter3_79 in ipairs(var1_79) do
						local var2_79 = var1_78:GetChapterItemById(iter3_79)

						if var2_79 and var2_79:isClear() then
							var0_79 = true

							break
						end
					end

					if iter1_79[1] == var2_0 then
						local var3_79 = _.rest(iter1_79[2], 2)

						for iter4_79, iter5_79 in ipairs(var3_79) do
							local var4_79 = arg0_78:Find(iter5_79)

							if not IsNil(var4_79) and not var0_79 then
								setActive(var4_79, false)
							end
						end
					elseif iter1_79[1] == var3_0 then
						local var5_79 = _.rest(iter1_79[2], 2)

						for iter6_79, iter7_79 in ipairs(var5_79) do
							local var6_79 = arg0_78:Find(iter7_79)

							if not IsNil(var6_79) and not var0_79 then
								setActive(var6_79, true)

								return
							end
						end
					elseif iter1_79[1] == var4_0 then
						local var7_79 = _.rest(iter1_79[2], 2)

						for iter8_79, iter9_79 in ipairs(var7_79) do
							local var8_79 = arg0_78:Find(iter9_79)

							if not IsNil(var8_79) and not var0_79 then
								setActive(var8_79, true)
							end
						end
					end
				end
			end)()
		end
	end

	local var2_77 = arg0_77.loader:GetPrefab("ui/" .. arg1_77, arg1_77, function(arg0_80)
		arg0_80:SetActive(true)

		local var0_80 = arg0_77.mapTFs[arg2_77]

		setParent(arg0_80, var0_80)
		pg.ViewUtils.SetSortingOrder(arg0_80, ChapterConst.LayerWeightMap + arg2_77 * 2 - 1)
		var1_77(arg0_80)
	end)

	table.insert(arg0_77.mapGroup, var2_77)
end

function var0_0.HideBtns(arg0_81)
	setActive(arg0_81.btnPrev, false)
	setActive(arg0_81.eliteQuota, false)
	setActive(arg0_81.escortBar, false)
	setActive(arg0_81.skirmishBar, false)
	setActive(arg0_81.normalBtn, false)
	setActive(arg0_81.actNormalBtn, false)
	setActive(arg0_81.eliteBtn, false)
	setActive(arg0_81.actEliteBtn, false)
	setActive(arg0_81.actExtraBtn, false)
	setActive(arg0_81.remasterBtn, false)
	setActive(arg0_81.btnNext, false)
	setActive(arg0_81.remasterAwardBtn, false)
	setActive(arg0_81.eventContainer, false)
	setActive(arg0_81.activityBtn, false)
	setActive(arg0_81.ptTotal, false)
	setActive(arg0_81.ticketTxt.parent, false)
	setActive(arg0_81.countDown, false)
	setActive(arg0_81.actAtelierBuffBtn, false)
	setActive(arg0_81.actAtelierYumiaBuffBtn, false)
	setActive(arg0_81.actExtraRank, false)
	setActive(arg0_81.actExchangeShopBtn, false)
	setActive(arg0_81.mapHelpBtn, false)
end

function var0_0.updateDifficultyBtns(arg0_82)
	local var0_82 = arg0_82.contextData.map:getConfig("type")

	setActive(arg0_82.normalBtn, var0_82 == Map.ELITE)
	setActive(arg0_82.eliteQuota, var0_82 == Map.ELITE)
	setActive(arg0_82.eliteBtn, var0_82 == Map.SCENARIO)

	local var1_82 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0_82.eliteBtn:Find("pic_activity"), var1_82 and not var1_82:isEnd())
end

function var0_0.updateActivityBtns(arg0_83)
	local var0_83 = arg0_83.contextData.map
	local var1_83, var2_83 = var0_83:isActivity()
	local var3_83 = var0_83:isRemaster()
	local var4_83 = var0_83:isSkirmish()
	local var5_83 = var0_83:isEscort()
	local var6_83 = var0_83:getConfig("type")
	local var7_83 = setmetatable({}, MainActMapBtn)
	local var8_83 = var7_83:InShowTime() and not var1_83 and not var4_83 and not var5_83

	arg0_83.activityBtnLinkAct = var7_83:GetActivity()

	if var8_83 then
		var7_83.image = arg0_83.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var7_83.subImage = arg0_83.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var7_83.tipTr = arg0_83.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var7_83.tipTxt = arg0_83.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var8_83 = var7_83:InShowTime()

		if var8_83 then
			var7_83:InitTipImage()
			var7_83:InitSubImage()
			var7_83:InitImage(function()
				return
			end)
			var7_83:OnInit()
		end
	end

	setActive(arg0_83.activityBtn, var8_83)
	arg0_83:updateRemasterInfo()

	if var1_83 and var2_83 then
		local var9_83

		if var0_83:isRemaster() then
			var9_83 = getProxy(ChapterProxy):getRemasterMaps(var0_83.remasterId)
		else
			var9_83 = getProxy(ChapterProxy):getMapsByActivities(var0_83:getConfig("on_activity"))
		end

		local var10_83 = underscore.any(var9_83, function(arg0_85)
			return arg0_85:isActExtra()
		end)

		setActive(arg0_83.actExtraBtn, var10_83 and var6_83 ~= Map.ACT_EXTRA)

		if isActive(arg0_83.actExtraBtn) then
			if underscore.all(underscore.filter(var9_83, function(arg0_86)
				local var0_86 = arg0_86:getMapType()

				return var0_86 == Map.ACTIVITY_EASY or var0_86 == Map.ACTIVITY_HARD
			end), function(arg0_87)
				return arg0_87:isAllChaptersClear()
			end) then
				setActive(arg0_83.actExtraBtnAnim, true)
			else
				setActive(arg0_83.actExtraBtnAnim, false)
			end

			setActive(arg0_83.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive(var0_83:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11_83 = checkExist(var0_83:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0_83.actEliteBtn, var11_83 and var6_83 ~= Map.ACTIVITY_HARD)
		setActive(arg0_83.actNormalBtn, var6_83 ~= Map.ACTIVITY_EASY)
		setActive(arg0_83.actExtraRank, var6_83 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_88)
			if not arg0_88 or arg0_88:isEnd() then
				return
			end

			local var0_88 = arg0_88:getConfig("config_data")[1]

			return _.any(var0_83:getChapters(), function(arg0_89)
				if not arg0_89:IsEXChapter() then
					return false
				end

				return table.contains(arg0_89:getConfig("boss_expedition_id"), var0_88)
			end)
		end))
		setActive(arg0_83.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var3_83 and var2_83 and arg0_83:IsActShopActive())

		local var12_83 = arg0_83.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_83.contextData.map:getConfig("on_activity")) or nil
		local var13_83 = var12_83 and not var12_83:isEnd() and var12_83:GetConfigClientSetting("PTID")

		arg0_83:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_90)
			return arg0_90:getConfig("config_id") == var13_83
		end))
		setActive(arg0_83.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var3_83 and var2_83 and arg0_83.ptActivity and not arg0_83.ptActivity:isEnd())
	else
		setActive(arg0_83.actExtraBtn, false)
		setActive(arg0_83.actEliteBtn, false)
		setActive(arg0_83.actNormalBtn, false)
		setActive(arg0_83.actExtraRank, false)
		setActive(arg0_83.actExchangeShopBtn, false)
		setActive(arg0_83.actAtelierBuffBtn, false)
		setActive(arg0_83.actAtelierYumiaBuffBtn, false)
		setActive(arg0_83.ptTotal, false)
	end

	setActive(arg0_83.eventContainer, (not var1_83 or not var2_83) and not var5_83)
	setActive(arg0_83.remasterBtn, OPEN_REMASTER and (var3_83 or not var1_83 and not var5_83 and not var4_83))
	setActive(arg0_83.ticketTxt.parent, var3_83)
	arg0_83:updateRemasterTicket()
	arg0_83:updateCountDown()
end

function var0_0.updateRemasterTicket(arg0_91)
	setText(arg0_91.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0_91:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0_0.updateRemasterBtnTip(arg0_92)
	local var0_92 = getProxy(ChapterProxy)
	local var1_92 = var0_92:ifShowRemasterTip() or var0_92:anyRemasterAwardCanReceive()

	SetActive(arg0_92.remasterBtn:Find("tip"), var1_92)
	SetActive(arg0_92.entranceLayer:Find("btns/btn_remaster/tip"), var1_92)
end

function var0_0.updatDailyBtnTip(arg0_93)
	local var0_93 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0_93.dailyBtn:Find("tip"), var0_93)
	SetActive(arg0_93.entranceLayer:Find("btns/btn_daily/tip"), var0_93)
end

function var0_0.updateRemasterInfo(arg0_94)
	arg0_94:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0_94.contextData.map then
		return
	end

	local var0_94 = getProxy(ChapterProxy)
	local var1_94
	local var2_94 = arg0_94.contextData.map:getRemaster()

	if var2_94 and #pg.re_map_template[var2_94].drop_gain > 0 then
		for iter0_94, iter1_94 in ipairs(pg.re_map_template[var2_94].drop_gain) do
			if #iter1_94 > 0 and var0_94.remasterInfo[iter1_94[1]][iter0_94].receive == false then
				var1_94 = {
					iter0_94,
					iter1_94
				}

				break
			end
		end
	end

	setActive(arg0_94.remasterAwardBtn, var1_94)

	if var1_94 then
		local var3_94 = var1_94[1]
		local var4_94, var5_94, var6_94, var7_94 = unpack(var1_94[2])
		local var8_94 = var0_94.remasterInfo[var4_94][var3_94]

		setText(arg0_94.remasterAwardBtn:Find("Text"), var8_94.count .. "/" .. var7_94)
		updateDrop(arg0_94.remasterAwardBtn:Find("IconTpl"), {
			type = var5_94,
			id = var6_94
		})
		setActive(arg0_94.remasterAwardBtn:Find("tip"), var7_94 <= var8_94.count)
		onButton(arg0_94, arg0_94.remasterAwardBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_94,
					id = var6_94
				},
				remaster = {
					word = i18n("level_remaster_tip4", pg.chapter_template[var4_94].chapter_name),
					number = var8_94.count .. "/" .. var7_94,
					btn_text = i18n(var8_94.count < var7_94 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var8_94.count < var7_94 then
							local var0_96 = pg.chapter_template[var4_94].map
							local var1_96, var2_96 = var0_94:getMapById(var0_96):isUnlock()

							if not var1_96 then
								pg.TipsMgr.GetInstance():ShowTips(var2_96)
							else
								arg0_94:ShowSelectedMap(var0_96)
							end
						else
							arg0_94:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_94, var3_94)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateCountDown(arg0_97)
	local var0_97 = getProxy(ChapterProxy)

	if arg0_97.newChapterCDTimer then
		arg0_97.newChapterCDTimer:Stop()

		arg0_97.newChapterCDTimer = nil
	end

	local var1_97 = 0

	if arg0_97.contextData.map:isActivity() and not arg0_97.contextData.map:isRemaster() then
		local var2_97 = var0_97:getMapsByActivities(arg0_97.contextData.map:getConfig("on_activity"))

		_.each(var2_97, function(arg0_98)
			local var0_98 = arg0_98:getChapterTimeLimit()

			if var1_97 == 0 then
				var1_97 = var0_98
			else
				var1_97 = math.min(var1_97, var0_98)
			end
		end)
		setActive(arg0_97.countDown, var1_97 > 0)
		setText(arg0_97.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0_97.countDown, false)
	end

	if var1_97 > 0 then
		setText(arg0_97.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_97))

		arg0_97.newChapterCDTimer = Timer.New(function()
			var1_97 = var1_97 - 1

			if var1_97 <= 0 then
				arg0_97:updateCountDown()

				if not arg0_97.contextData.chapterVO then
					arg0_97:setMap(arg0_97.contextData.mapIdx)
				end
			else
				setText(arg0_97.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1_97))
			end
		end, 1, -1)

		arg0_97.newChapterCDTimer:Start()
	else
		setText(arg0_97.countDown:Find("time"), "")
	end
end

function var0_0.registerActBtn(arg0_100)
	onButton(arg0_100, arg0_100.actExtraRank, function()
		if arg0_100:isfrozen() then
			return
		end

		arg0_100:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_100, arg0_100.activityBtn, function()
		if arg0_100:isfrozen() then
			return
		end

		if arg0_100.activityBtnLinkAct then
			local var0_102 = arg0_100.activityBtnLinkAct:getConfig("type")

			if var0_102 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)

				return
			elseif var0_102 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)

				return
			end
		end

		arg0_100:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0_100, arg0_100.actExchangeShopBtn, function()
		if arg0_100:isfrozen() then
			return
		end

		arg0_100:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0_100, arg0_100.actAtelierBuffBtn, function()
		if arg0_100:isfrozen() then
			return
		end

		arg0_100:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)
	onButton(arg0_100, arg0_100.actAtelierYumiaBuffBtn, function()
		if arg0_100:isfrozen() then
			return
		end

		arg0_100:emit(LevelMediator2.SHOW_ATELIER_BUFF, true)
	end, SFX_UI_CLICK)

	local var0_100 = getProxy(ChapterProxy)

	local function var1_100(arg0_106, arg1_106, arg2_106)
		local var0_106

		if arg0_106:isRemaster() then
			var0_106 = var0_100:getRemasterMaps(arg0_106.remasterId)
		else
			var0_106 = var0_100:getMapsByActivities(arg0_106:getConfig("on_activity"))
		end

		local var1_106 = _.select(var0_106, function(arg0_107)
			return arg0_107:getMapType() == arg1_106
		end)

		table.sort(var1_106, function(arg0_108, arg1_108)
			return arg0_108.id < arg1_108.id
		end)

		local var2_106 = table.indexof(underscore.map(var1_106, function(arg0_109)
			return arg0_109.id
		end), arg2_106) or #var1_106

		while not var1_106[var2_106]:isUnlock() do
			if var2_106 > 1 then
				var2_106 = var2_106 - 1
			else
				break
			end
		end

		return var1_106[var2_106]
	end

	arg0_100:bind(LevelUIConst.SWITCH_ACT_MAP, function(arg0_110, arg1_110, arg2_110)
		arg2_110 = arg2_110 or switch(arg1_110, {
			[Map.ACTIVITY_EASY] = function()
				return arg0_100.contextData.map:getBindMapId()
			end,
			[Map.ACTIVITY_HARD] = function()
				return arg0_100.contextData.map:getBindMapId()
			end,
			[Map.ACT_EXTRA] = function()
				return PlayerPrefs.GetInt("ex_mapId", 0)
			end
		})

		local var0_110 = var1_100(arg0_100.contextData.map, arg1_110, arg2_110)
		local var1_110, var2_110 = var0_110:isUnlock()

		if var1_110 then
			arg0_100:setMap(var0_110.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var2_110)
		end
	end)
	onButton(arg0_100, arg0_100.actNormalBtn, function()
		if arg0_100:isfrozen() then
			return
		end

		arg0_100:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_EASY)
	end, SFX_PANEL)
	onButton(arg0_100, arg0_100.actEliteBtn, function()
		if arg0_100:isfrozen() then
			return
		end

		arg0_100:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_100, arg0_100.actExtraBtn, function()
		if arg0_100:isfrozen() then
			return
		end

		arg0_100:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACT_EXTRA)
	end, SFX_PANEL)
end

function var0_0.initCloudsPos(arg0_117, arg1_117)
	arg0_117.initPositions = {}

	local var0_117 = arg1_117 or 1
	local var1_117 = pg.expedition_data_by_map[var0_117].clouds_pos

	for iter0_117, iter1_117 in ipairs(arg0_117.cloudRTFs) do
		local var2_117 = var1_117[iter0_117]

		if var2_117 then
			iter1_117.anchoredPosition = Vector2(var2_117[1], var2_117[2])

			table.insert(arg0_117.initPositions, iter1_117.anchoredPosition)
		else
			setActive(iter1_117, false)
		end
	end
end

function var0_0.initMapBtn(arg0_118, arg1_118, arg2_118)
	onButton(arg0_118, arg1_118, function()
		if arg0_118:isfrozen() then
			return
		end

		local var0_119 = arg0_118.contextData.mapIdx + arg2_118
		local var1_119 = getProxy(ChapterProxy):getMapById(var0_119)

		if not var1_119 then
			return
		end

		if var1_119:getMapType() == Map.ELITE and not var1_119:isEliteEnabled() then
			var1_119 = var1_119:getBindMap()
			var0_119 = var1_119.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2_119, var3_119 = var1_119:isUnlock()

		if arg2_118 > 0 and not var2_119 then
			pg.TipsMgr.GetInstance():ShowTips(var3_119)

			return
		end

		arg0_118:setMap(var0_119)
	end, SFX_PANEL)
end

function var0_0.ShowSelectedMap(arg0_120, arg1_120, arg2_120)
	seriesAsync({
		function(arg0_121)
			if arg0_120.contextData.entranceStatus then
				arg0_120:frozen()

				arg0_120.nextPreloadMap = arg1_120

				arg0_120:PreloadLevelMainUI(arg1_120, function()
					arg0_120:unfrozen()

					if arg0_120.nextPreloadMap ~= arg1_120 then
						return
					end

					arg0_120:ShowEntranceUI(false)
					arg0_120:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1_120)
					arg0_121()
				end)
			else
				arg0_120:setMap(arg1_120)
				arg0_121()
			end
		end
	}, arg2_120)
end

function var0_0.setMap(arg0_123, arg1_123)
	local var0_123 = arg0_123.contextData.mapIdx

	arg0_123.contextData.mapIdx = arg1_123
	arg0_123.contextData.map = getProxy(ChapterProxy):getMapById(arg1_123)

	assert(arg0_123.contextData.map, "map cannot be nil " .. arg1_123)

	if arg0_123.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0_123.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0_123.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0_123.contextData.map.remasterId, arg1_123)
		PlayerPrefs.Save()
	end

	arg0_123:RecordLastMapOnExit()
	arg0_123:updateMap(var0_123)
	arg0_123:tryPlayMapStory()
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
	[var5_0.TYPEEXSP] = "MapBuilderEXSP"
}

function var0_0.SwitchMapBuilder(arg0_124, arg1_124)
	if arg0_124.mapBuilder and arg0_124.mapBuilder:GetType() ~= arg1_124 then
		arg0_124.mapBuilder.buffer:Hide()
	end

	local var0_124 = arg0_124:GetMapBuilderInBuffer(arg1_124)

	arg0_124.mapBuilder = var0_124

	var0_124.buffer:Show()
end

function var0_0.GetMapBuilderInBuffer(arg0_125, arg1_125)
	if not arg0_125.mbDict[arg1_125] then
		local var0_125 = _G[var6_0[arg1_125]]

		assert(var0_125, "Missing MapBuilder of type " .. (arg1_125 or "NIL"))

		arg0_125.mbDict[arg1_125] = var0_125.New(arg0_125._tf, arg0_125)
		arg0_125.mbDict[arg1_125].isFrozen = arg0_125:isfrozen()

		arg0_125.mbDict[arg1_125]:Load()
	end

	return arg0_125.mbDict[arg1_125]
end

function var0_0.updateMap(arg0_126, arg1_126)
	local var0_126 = arg0_126.contextData.map
	local var1_126 = var0_126:getConfig("anchor")
	local var2_126

	if var1_126 == "" then
		var2_126 = Vector2(0.5, 0.5)
	else
		var2_126 = Vector2(unpack(var1_126))
	end

	arg0_126.map.pivot = var2_126

	local var3_126 = var0_126:getConfig("uifx")

	for iter0_126 = 1, arg0_126.UIFXList.childCount do
		local var4_126 = arg0_126.UIFXList:GetChild(iter0_126 - 1)

		setActive(var4_126, var4_126.name == var3_126)
	end

	arg0_126:SwitchMapBG(var0_126, arg1_126)
	arg0_126:PlayBGM()

	local var5_126 = arg0_126.contextData.map:getConfig("ui_type")

	arg0_126:SwitchMapBuilder(var5_126)
	seriesAsync({
		function(arg0_127)
			arg0_126.mapBuilder:CallbackInvoke(arg0_127)
		end,
		function(arg0_128)
			arg0_126.mapBuilder:UpdateMapVO(var0_126)
			arg0_126.mapBuilder:UpdateView()
			arg0_126.mapBuilder:UpdateMapItems()
			arg0_126.mapBuilder:PlayEnterAnim()
		end
	})
end

function var0_0.UpdateSwitchMapButton(arg0_129)
	local var0_129 = arg0_129.contextData.map
	local var1_129 = getProxy(ChapterProxy)
	local var2_129 = var1_129:getMapById(var0_129.id - 1)
	local var3_129 = var1_129:getMapById(var0_129.id + 1)

	setActive(arg0_129.btnPrev, tobool(var2_129))
	setActive(arg0_129.btnNext, tobool(var3_129))

	local var4_129 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0_129.btnPrevCol, var2_129 and Color.white or var4_129)
	setImageColor(arg0_129.btnNextCol, var3_129 and var3_129:isUnlock() and Color.white or var4_129)
end

function var0_0.tryPlayMapStory(arg0_130)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0_131)
			local var0_131 = arg0_130.contextData.map:getConfig("enter_story")

			if var0_131 and var0_131 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_131) and not arg0_130.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1_131 = tonumber(var0_131)

				if var1_131 and var1_131 > 0 then
					arg0_130:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_131)
				else
					pg.NewStoryMgr.GetInstance():Play(var0_131, arg0_131)
				end

				return
			end

			arg0_131()
		end,
		function(arg0_132)
			local var0_132 = arg0_130.contextData.map:getConfig("guide_id")

			if var0_132 and var0_132 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_132, nil, arg0_132)

				return
			end

			arg0_132()
		end,
		function(arg0_133)
			if isActive(arg0_130.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0_133 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1_133

				if var0_133 then
					var1_133 = {
						1,
						2
					}
				else
					var1_133 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1_133)
			else
				arg0_133()
			end
		end,
		function(arg0_134)
			if arg0_130.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0_130.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0_0.DisplaySPAnim(arg0_135, arg1_135, arg2_135, arg3_135)
	arg0_135.uiAnims = arg0_135.uiAnims or {}

	local var0_135 = arg0_135.uiAnims[arg1_135]

	local function var1_135()
		arg0_135.playing = true

		arg0_135:frozen()
		var0_135:SetActive(true)

		local var0_136 = tf(var0_135)

		pg.UIMgr.GetInstance():OverlayPanel(var0_136)

		if arg3_135 then
			arg3_135(var0_135)
		end

		var0_136:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_137)
			arg0_135.playing = false

			if arg2_135 then
				arg2_135(var0_135)
			end

			arg0_135:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_135 then
		PoolMgr.GetInstance():GetUI(arg1_135, true, function(arg0_138)
			arg0_138:SetActive(true)

			arg0_135.uiAnims[arg1_135] = arg0_138
			var0_135 = arg0_135.uiAnims[arg1_135]

			var1_135()
		end)
	else
		var1_135()
	end
end

function var0_0.displaySpResult(arg0_139, arg1_139, arg2_139)
	setActive(arg0_139.spResult, true)
	arg0_139:DisplaySPAnim(arg1_139 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0_140)
		onButton(arg0_139, arg0_140, function()
			removeOnButton(arg0_140)
			setActive(arg0_140, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_140, arg0_139._tf)
			arg0_139:hideSpResult()
			arg2_139()
		end, SFX_PANEL)
	end)
end

function var0_0.hideSpResult(arg0_142)
	setActive(arg0_142.spResult, false)
end

function var0_0.displayBombResult(arg0_143, arg1_143)
	setActive(arg0_143.spResult, true)
	arg0_143:DisplaySPAnim("SpBombRet", function(arg0_144)
		onButton(arg0_143, arg0_144, function()
			removeOnButton(arg0_144)
			setActive(arg0_144, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_144, arg0_143._tf)
			arg0_143:hideSpResult()
			arg1_143()
		end, SFX_PANEL)
	end, function(arg0_146)
		setText(arg0_146.transform:Find("right/name_bg/en"), arg0_143.contextData.chapterVO.modelCount)
	end)
end

function var0_0.OnLevelInfoPanelConfirm(arg0_147, arg1_147, arg2_147)
	arg0_147.contextData.chapterLoopFlag = arg2_147

	local var0_147 = getProxy(ChapterProxy):getChapterById(arg1_147, true)

	if var0_147:getConfig("type") == Chapter.CustomFleet then
		arg0_147:displayFleetEdit(var0_147)

		return
	end

	if #var0_147:getNpcShipByType(1) > 0 then
		arg0_147:emit(LevelMediator2.ON_TRACKING, arg1_147)

		return
	end

	arg0_147:displayFleetSelect(var0_147)
end

function var0_0.DisplayLevelInfoPanel(arg0_148, arg1_148, arg2_148)
	seriesAsync({
		function(arg0_149)
			if not arg0_148.levelInfoView:GetLoaded() then
				arg0_148:frozen()
				arg0_148.levelInfoView:Load()
				arg0_148.levelInfoView:CallbackInvoke(function()
					arg0_148:unfrozen()
					arg0_149()
				end)

				return
			end

			arg0_149()
		end,
		function(arg0_151)
			local function var0_151(arg0_152, arg1_152)
				arg0_148:hideChapterPanel()
				arg0_148:OnLevelInfoPanelConfirm(arg0_152, arg1_152)
			end

			local function var1_151()
				arg0_148:hideChapterPanel()
			end

			local var2_151 = getProxy(ChapterProxy):getChapterById(arg1_148, true)

			if getProxy(ChapterProxy):getMapById(var2_151:getConfig("map")):isSkirmish() and #var2_151:getNpcShipByType(1) > 0 then
				var0_151(false)

				return
			end

			arg0_148.levelInfoView:set(arg1_148, arg2_148)
			arg0_148.levelInfoView:setCBFunc(var0_151, var1_151)
			arg0_148.levelInfoView:Show()
		end
	})
end

function var0_0.hideChapterPanel(arg0_154)
	if arg0_154.levelInfoView:isShowing() then
		arg0_154.levelInfoView:Hide()
	end
end

function var0_0.destroyChapterPanel(arg0_155)
	arg0_155.levelInfoView:Destroy()

	arg0_155.levelInfoView = nil
end

function var0_0.DisplayLevelInfoSPPanel(arg0_156, arg1_156, arg2_156, arg3_156)
	seriesAsync({
		function(arg0_157)
			if not arg0_156.levelInfoSPView then
				arg0_156.levelInfoSPView = LevelInfoSPView.New(arg0_156.topPanel, arg0_156.event, arg0_156.contextData)

				arg0_156.levelInfoSPView:RegisterView(arg0_156)
				arg0_156:frozen()
				arg0_156.levelInfoSPView:Load()
				arg0_156.levelInfoSPView:CallbackInvoke(function()
					arg0_156:unfrozen()
					arg0_157()
				end)

				return
			end

			arg0_157()
		end,
		function(arg0_159)
			local function var0_159(arg0_160, arg1_160)
				arg0_156:HideLevelInfoSPPanel()
				arg0_156:OnLevelInfoPanelConfirm(arg0_160, arg1_160)
			end

			local function var1_159()
				arg0_156:HideLevelInfoSPPanel()
			end

			arg0_156.levelInfoSPView:SetChapterGroupInfo(arg2_156)
			arg0_156.levelInfoSPView:set(arg1_156, arg3_156)
			arg0_156.levelInfoSPView:setCBFunc(var0_159, var1_159)
			arg0_156.levelInfoSPView:Show()
		end
	})
end

function var0_0.HideLevelInfoSPPanel(arg0_162)
	if arg0_162.levelInfoSPView and arg0_162.levelInfoSPView:isShowing() then
		arg0_162.levelInfoSPView:Hide()
	end
end

function var0_0.DestroyLevelInfoSPPanel(arg0_163)
	if not arg0_163.levelInfoSPView then
		return
	end

	arg0_163.levelInfoSPView:Destroy()

	arg0_163.levelInfoSPView = nil
end

function var0_0.displayFleetSelect(arg0_164, arg1_164)
	local var0_164 = arg0_164.contextData.selectedFleetIDs or arg1_164:GetDefaultFleetIndex()

	arg1_164 = Clone(arg1_164)
	arg1_164.loopFlag = arg0_164.contextData.chapterLoopFlag

	arg0_164.levelFleetView:updateSpecialOperationTickets(arg0_164.spTickets)
	arg0_164.levelFleetView:Load()
	arg0_164.levelFleetView:ActionInvoke("setHardShipVOs", arg0_164.shipVOs)
	arg0_164.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_164.openedCommanerSystem)
	arg0_164.levelFleetView:ActionInvoke("set", arg1_164, arg0_164.fleets, var0_164)
	arg0_164.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetSelect(arg0_165)
	if arg0_165.levelCMDFormationView:isShowing() then
		arg0_165.levelCMDFormationView:Hide()
	end

	if arg0_165.levelFleetView then
		arg0_165.levelFleetView:Hide()
	end
end

function var0_0.buildCommanderPanel(arg0_166)
	arg0_166.levelCMDFormationView = LevelCMDFormationView.New(arg0_166.topPanel, arg0_166.event, arg0_166.contextData)
end

function var0_0.destroyFleetSelect(arg0_167)
	if not arg0_167.levelFleetView then
		return
	end

	arg0_167.levelFleetView:Destroy()

	arg0_167.levelFleetView = nil
end

function var0_0.displayFleetEdit(arg0_168, arg1_168)
	arg1_168 = Clone(arg1_168)
	arg1_168.loopFlag = arg0_168.contextData.chapterLoopFlag

	arg0_168.levelFleetView:updateSpecialOperationTickets(arg0_168.spTickets)
	arg0_168.levelFleetView:Load()
	arg0_168.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0_168.openedCommanerSystem)
	arg0_168.levelFleetView:ActionInvoke("setHardShipVOs", arg0_168.shipVOs)
	arg0_168.levelFleetView:ActionInvoke("setOnHard", arg1_168)
	arg0_168.levelFleetView:ActionInvoke("Show")
end

function var0_0.hideFleetEdit(arg0_169)
	arg0_169:hideFleetSelect()
end

function var0_0.destroyFleetEdit(arg0_170)
	arg0_170:destroyFleetSelect()
end

function var0_0.RefreshFleetSelectView(arg0_171, arg1_171)
	if not arg0_171.levelFleetView then
		return
	end

	assert(arg0_171.levelFleetView:GetLoaded())

	local var0_171 = arg0_171.levelFleetView:IsSelectMode()
	local var1_171

	if var0_171 then
		arg0_171.levelFleetView:ActionInvoke("set", arg1_171 or arg0_171.levelFleetView.chapter, arg0_171.fleets, arg0_171.levelFleetView:getSelectIds())

		if arg0_171.levelCMDFormationView:isShowing() then
			local var2_171 = arg0_171.levelCMDFormationView.fleet.id

			var1_171 = arg0_171.fleets[var2_171]
		end
	else
		arg0_171.levelFleetView:ActionInvoke("setOnHard", arg1_171 or arg0_171.levelFleetView.chapter)

		if arg0_171.levelCMDFormationView:isShowing() then
			local var3_171 = arg0_171.levelCMDFormationView.fleet.id

			var1_171 = arg1_171:wrapEliteFleet(var3_171)
		end
	end

	if var1_171 then
		arg0_171.levelCMDFormationView:ActionInvoke("updateFleet", var1_171)
	end
end

function var0_0.setChapter(arg0_172, arg1_172)
	local var0_172

	if arg1_172 then
		var0_172 = arg1_172.id
	end

	arg0_172.contextData.chapterId = var0_172
	arg0_172.contextData.chapterVO = arg1_172
end

function var0_0.switchToChapter(arg0_173, arg1_173)
	if arg0_173.contextData.mapIdx ~= arg1_173:getConfig("map") then
		arg0_173:setMap(arg1_173:getConfig("map"))
	end

	arg0_173:setChapter(arg1_173)

	arg0_173.leftCanvasGroup.blocksRaycasts = false
	arg0_173.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0_173.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0_173:DestroyLevelStageView()

	if not arg0_173.levelStageView then
		arg0_173.levelStageView = LevelStageView.New(arg0_173.topPanel, arg0_173.event, arg0_173.contextData)

		arg0_173.levelStageView:Load()

		arg0_173.levelStageView.isFrozen = arg0_173:isfrozen()
	end

	arg0_173:frozen()

	local function var0_173()
		seriesAsync({
			function(arg0_175)
				arg0_173.mapBuilder:CallbackInvoke(arg0_175)
			end,
			function(arg0_176)
				setActive(arg0_173.clouds, false)
				arg0_173.mapBuilder:HideFloat()
				arg0_173:BlurPanel(arg0_173.topPanel, {
					blurCamList = {
						pg.UIMgr.CameraUI
					}
				})
				arg0_173.levelStageView:updateStageInfo()
				arg0_173.levelStageView:updateAmbushRate(arg1_173.fleet.line, true)
				arg0_173.levelStageView:updateStageAchieve()
				arg0_173.levelStageView:updateStageBarrier()
				arg0_173.levelStageView:updateBombPanel()
				arg0_173.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0_176)
			end,
			function(arg0_177)
				if arg0_173.exited then
					return
				end

				arg0_173.levelStageView:updateStageStrategy()

				arg0_173.canvasGroup.blocksRaycasts = arg0_173.frozenCount == 0

				onNextTick(arg0_177)
			end,
			function(arg0_178)
				if arg0_173.exited then
					return
				end

				arg0_173.levelStageView:updateStageFleet()
				arg0_173.levelStageView:updateSupportFleet()
				arg0_173.levelStageView:updateFleetBuff()
				onNextTick(arg0_178)
			end,
			function(arg0_179)
				if arg0_173.exited then
					return
				end

				parallelAsync({
					function(arg0_180)
						local var0_180 = arg1_173:getConfig("scale")
						local var1_180 = LeanTween.value(go(arg0_173.map), arg0_173.map.localScale, Vector3.New(var0_180[3], var0_180[3], 1), var1_0):setOnUpdateVector3(function(arg0_181)
							arg0_173.map.localScale = arg0_181
							arg0_173.float.localScale = arg0_181
						end):setOnComplete(System.Action(function()
							arg0_173.mapBuilder:ShowFloat()
							arg0_173.mapBuilder:Hide()
							arg0_180()
						end)):setEase(LeanTweenType.easeOutSine)

						arg0_173:RecordTween("mapScale", var1_180.uniqueId)

						local var2_180 = LeanTween.value(go(arg0_173.map), arg0_173.map.pivot, Vector2.New(math.clamp(var0_180[1] - 0.5, 0, 1), math.clamp(var0_180[2] - 0.5, 0, 1)), var1_0)

						var2_180:setOnUpdateVector2(function(arg0_183)
							arg0_173.map.pivot = arg0_183
							arg0_173.float.pivot = arg0_183
						end):setEase(LeanTweenType.easeOutSine)
						arg0_173:RecordTween("mapPivot", var2_180.uniqueId)
						shiftPanel(arg0_173.leftChapter, -arg0_173.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_173.rightChapter, arg0_173.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0_173.topChapter, 0, arg0_173.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0_173.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0_184)
						arg0_173:PlayBGM()

						local var0_184 = {}
						local var1_184 = arg1_173:getConfig("bg")

						if var1_184 and #var1_184 > 0 then
							var0_184[1] = {
								BG = var1_184
							}
						end

						arg0_173:SwitchBG(var0_184, arg0_184)
					end
				}, function()
					onNextTick(arg0_179)
				end)
			end,
			function(arg0_186)
				if arg0_173.exited then
					return
				end

				setActive(arg0_173.topChapter, false)
				setActive(arg0_173.leftChapter, false)
				setActive(arg0_173.rightChapter, false)

				arg0_173.leftCanvasGroup.blocksRaycasts = true
				arg0_173.rightCanvasGroup.blocksRaycasts = true

				arg0_173:initGrid(arg0_186)
			end,
			function(arg0_187)
				if arg0_173.exited then
					return
				end

				arg0_173.levelStageView:SetGrid(arg0_173.grid)

				arg0_173.contextData.huntingRangeVisibility = arg0_173.contextData.huntingRangeVisibility - 1

				arg0_173.grid:toggleHuntingRange()

				local var0_187 = arg1_173:getConfig("pop_pic")

				if var0_187 and #var0_187 > 0 and arg0_173.FirstEnterChapter == arg1_173.id then
					arg0_173:doPlayAnim(var0_187, function(arg0_188)
						setActive(arg0_188, false)

						if arg0_173.exited then
							return
						end

						arg0_187()
					end)
				else
					arg0_187()
				end
			end,
			function(arg0_189)
				arg0_173.levelStageView:tryAutoAction(arg0_189)
			end,
			function(arg0_190)
				if arg0_173.exited then
					return
				end

				arg0_173:unfrozen()

				if arg0_173.FirstEnterChapter then
					arg0_173:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1_173.subAutoAttack)
				end

				arg0_173.FirstEnterChapter = nil

				arg0_173.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0_173.levelStageView:ActionInvoke("SetSeriesOperation", var0_173)
	arg0_173.levelStageView:ActionInvoke("SetPlayer", arg0_173.player)
	arg0_173.levelStageView:ActionInvoke("SwitchToChapter", arg1_173)
end

function var0_0.switchToMap(arg0_191, arg1_191)
	arg0_191:frozen()
	arg0_191:destroyGrid()
	arg0_191:setChapter(nil)
	LeanTween.cancel(go(arg0_191.map))

	local var0_191 = LeanTween.value(go(arg0_191.map), arg0_191.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_192)
		arg0_191.map.localScale = arg0_192
		arg0_191.float.localScale = arg0_192
	end):setOnComplete(System.Action(function()
		arg0_191:unfrozen()
		arg0_191.mapBuilder:PlayEnterAnim()
		existCall(arg1_191)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_191:RecordTween("mapScale", var0_191.uniqueId)

	local var1_191 = arg0_191.contextData.map:getConfig("anchor")
	local var2_191

	if var1_191 == "" then
		var2_191 = Vector2.zero
	else
		var2_191 = Vector2(unpack(var1_191))
	end

	local var3_191 = LeanTween.value(go(arg0_191.map), arg0_191.map.pivot, var2_191, var1_0)

	var3_191:setOnUpdateVector2(function(arg0_194)
		arg0_191.map.pivot = arg0_194
		arg0_191.float.pivot = arg0_194
	end):setEase(LeanTweenType.easeOutSine)
	arg0_191:RecordTween("mapPivot", var3_191.uniqueId)
	setActive(arg0_191.topChapter, true)
	setActive(arg0_191.leftChapter, true)
	setActive(arg0_191.rightChapter, true)
	shiftPanel(arg0_191.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_191.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_191.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_191.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_191.levelStageView then
		arg0_191.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_191:DestroyLevelStageView()
		end)
		arg0_191.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_191:SwitchMapBG(arg0_191.contextData.map)
	arg0_191:PlayBGM()
	seriesAsync({
		function(arg0_196)
			arg0_191.mapBuilder:CallbackInvoke(arg0_196)
		end,
		function(arg0_197)
			arg0_191.mapBuilder:Show()
			arg0_191.mapBuilder:UpdateView()
			arg0_191.mapBuilder:UpdateMapItems()
		end
	})
	arg0_191:UnOverlayPanel(arg0_191.topPanel, arg0_191._tf)

	arg0_191.canvasGroup.blocksRaycasts = arg0_191.frozenCount == 0
	arg0_191.canvasGroup.interactable = true

	if arg0_191.ambushWarning and arg0_191.ambushWarning.activeSelf then
		arg0_191.ambushWarning:SetActive(false)
		arg0_191:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_198, arg1_198, arg2_198, arg3_198)
	if not arg1_198 or #arg1_198 <= 0 then
		existCall(arg2_198)

		return
	elseif arg3_198 then
		-- block empty
	elseif table.equal(arg0_198.currentBG, arg1_198) then
		return
	end

	arg0_198.currentBG = arg1_198

	for iter0_198, iter1_198 in ipairs(arg0_198.mapGroup) do
		arg0_198.loader:ClearRequest(iter1_198)
	end

	table.clear(arg0_198.mapGroup)

	local var0_198 = {}

	table.ParallelIpairsAsync(arg1_198, function(arg0_199, arg1_199, arg2_199)
		local var0_199 = arg0_198.mapTFs[arg0_199]
		local var1_199 = arg1_199.bgPrefix and arg1_199.bgPrefix .. "/" or "levelmap/"
		local var2_199 = arg0_198.loader:GetSpriteDirect(var1_199 .. arg1_199.BG, "", function(arg0_200)
			var0_198[arg0_199] = arg0_200

			arg2_199()
		end, var0_199)

		table.insert(arg0_198.mapGroup, var2_199)
		arg0_198:updateCouldAnimator(arg1_199.Animator, arg0_199)
	end, function()
		for iter0_201, iter1_201 in ipairs(arg0_198.mapTFs) do
			setImageSprite(iter1_201, var0_198[iter0_201])
			setActive(iter1_201, arg1_198[iter0_201])
			SetCompomentEnabled(iter1_201, typeof(Image), true)
		end

		existCall(arg2_198)
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

function var0_0.ClearMapTransitions(arg0_202)
	if not arg0_202.mapTransitions then
		return
	end

	for iter0_202, iter1_202 in pairs(arg0_202.mapTransitions) do
		if iter1_202 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_202, iter0_202, iter1_202, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_202, iter0_202)
		end
	end

	arg0_202.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_203, arg1_203, arg2_203, arg3_203)
	local var0_203, var1_203, var2_203 = arg0_203:GetMapBG(arg1_203, arg2_203)

	if not var1_203 then
		arg0_203:SwitchBG(var0_203, nil, arg3_203)

		return
	end

	arg0_203:PlayMapTransition("LevelMapTransition_" .. var1_203, var2_203, function()
		arg0_203:SwitchBG(var0_203, nil, arg3_203)
	end)
end

function var0_0.GetMapBG(arg0_205, arg1_205, arg2_205)
	if not table.contains(var7_0, arg1_205.id) then
		return {
			arg0_205:GetMapElement(arg1_205)
		}
	end

	local var0_205 = arg1_205.id
	local var1_205 = table.indexof(var7_0, var0_205) - 1
	local var2_205 = bit.lshift(bit.rshift(var1_205, 1), 1) + 1
	local var3_205 = {
		var7_0[var2_205],
		var7_0[var2_205 + 1]
	}
	local var4_205 = _.map(var3_205, function(arg0_206)
		return getProxy(ChapterProxy):getMapById(arg0_206)
	end)

	if _.all(var4_205, function(arg0_207)
		return arg0_207:isAllChaptersClear()
	end) then
		local var5_205 = {
			arg0_205:GetMapElement(arg1_205)
		}

		if not arg2_205 or math.abs(var0_205 - arg2_205) ~= 1 then
			return var5_205
		end

		local var6_205 = var9_0[bit.rshift(var2_205 - 1, 1) + 1]
		local var7_205 = bit.band(var1_205, 1) == 1

		return var5_205, var6_205, var7_205
	else
		local var8_205 = 0

		;(function()
			local var0_208 = var4_205[1]:getChapters()

			for iter0_208, iter1_208 in ipairs(var0_208) do
				if not iter1_208:isClear() then
					return
				end

				var8_205 = var8_205 + 1
			end

			if not var4_205[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_205 = var8_205 + 1

			local var1_208 = var4_205[2]:getChapters()

			for iter2_208, iter3_208 in ipairs(var1_208) do
				if not iter3_208:isClear() then
					return
				end

				var8_205 = var8_205 + 1
			end
		end)()

		local var9_205

		if var8_205 > 0 then
			local var10_205 = var8_0[bit.rshift(var2_205 - 1, 1) + 1]

			var9_205 = {
				{
					BG = "map_" .. var10_205[1],
					Animator = var10_205[2]
				},
				{
					BG = "map_" .. var10_205[3] + var8_205,
					Animator = var10_205[4]
				}
			}
		else
			var9_205 = {
				arg0_205:GetMapElement(arg1_205)
			}
		end

		return var9_205
	end
end

function var0_0.GetMapElement(arg0_209, arg1_209)
	local var0_209 = arg1_209:getConfig("bg")
	local var1_209 = arg1_209:getConfig("ani_controller")

	if var1_209 and #var1_209 > 0 then
		(function()
			local var0_210 = getProxy(ChapterProxy)

			for iter0_210, iter1_210 in ipairs(var1_209) do
				local var1_210 = _.rest(iter1_210[2], 2)

				for iter2_210, iter3_210 in ipairs(var1_210) do
					if string.find(iter3_210, "^map_") and iter1_210[1] == var3_0 then
						local var2_210 = iter1_210[2][1]
						local var3_210 = false

						for iter4_210, iter5_210 in ipairs(var2_210) do
							local var4_210 = var0_210:GetChapterItemById(iter5_210)

							if var4_210 and var4_210:isClear() then
								var3_210 = true

								break
							end
						end

						if not var3_210 then
							var0_209 = iter3_210

							return
						end
					end
				end
			end
		end)()
	end

	local var2_209 = {
		BG = var0_209
	}

	var2_209.Animator, var2_209.AnimatorController = arg0_209:GetMapAnimator(arg1_209)

	return var2_209
end

function var0_0.GetMapAnimator(arg0_211, arg1_211)
	local var0_211 = arg1_211:getConfig("ani_name")

	if arg1_211:getConfig("animtor") == 1 and var0_211 and #var0_211 > 0 then
		local var1_211 = arg1_211:getConfig("ani_controller")

		if var1_211 and #var1_211 > 0 then
			(function()
				local var0_212 = getProxy(ChapterProxy)

				for iter0_212, iter1_212 in ipairs(var1_211) do
					local var1_212 = _.rest(iter1_212[2], 2)

					for iter2_212, iter3_212 in ipairs(var1_212) do
						if string.find(iter3_212, "^effect_") and iter1_212[1] == var3_0 then
							local var2_212 = iter1_212[2][1]
							local var3_212 = false

							for iter4_212, iter5_212 in ipairs(var2_212) do
								local var4_212 = var0_212:GetChapterItemById(iter5_212)

								if var4_212 and var4_212:isClear() then
									var3_212 = true

									break
								end
							end

							if not var3_212 then
								var0_211 = "map_" .. string.sub(iter3_212, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_211, var1_211
	end
end

function var0_0.PlayMapTransition(arg0_213, arg1_213, arg2_213, arg3_213, arg4_213)
	arg0_213.mapTransitions = arg0_213.mapTransitions or {}

	local var0_213

	local function var1_213()
		arg0_213:frozen()
		existCall(arg3_213, var0_213)
		var0_213:SetActive(true)

		local var0_214 = tf(var0_213)

		pg.UIMgr.GetInstance():OverlayPanel(var0_214)
		var0_213:GetComponent(typeof(Animator)):Play(arg2_213 and "Sequence" or "Inverted", -1, 0)
		var0_214:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_215)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_214, arg0_213._tf)
			existCall(arg4_213, var0_213)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_213, arg1_213, var0_213)

			arg0_213.mapTransitions[arg1_213] = false

			arg0_213:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_213, arg1_213, true, function(arg0_216)
		var0_213 = arg0_216
		arg0_213.mapTransitions[arg1_213] = arg0_216

		var1_213()
	end)
end

function var0_0.DestroyLevelStageView(arg0_217)
	if arg0_217.levelStageView then
		arg0_217.levelStageView:Destroy()

		arg0_217.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_218, arg1_218)
	arg0_218.levelAmbushView = LevelAmbushView.New(arg0_218.topPanel, arg0_218.event, arg0_218.contextData)

	arg0_218.levelAmbushView:Load()
	arg0_218.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_218)
end

function var0_0.hideAmbushInfo(arg0_219)
	if arg0_219.levelAmbushView then
		arg0_219.levelAmbushView:Destroy()

		arg0_219.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_220, arg1_220)
	arg0_220:frozen()

	local function var0_220()
		arg0_220.ambushWarning:SetActive(true)

		local var0_221 = tf(arg0_220.ambushWarning)

		var0_221:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_221:SetSiblingIndex(1)

		local var1_221 = var0_221:GetComponent("DftAniEvent")

		var1_221:SetTriggerEvent(function(arg0_222)
			arg1_220()
		end)
		var1_221:SetEndEvent(function(arg0_223)
			arg0_220.ambushWarning:SetActive(false)
			arg0_220:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_220.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_225)
			arg0_225:SetActive(true)

			arg0_220.ambushWarning = arg0_225

			var0_220()
		end)
	else
		var0_220()
	end
end

function var0_0.destroyAmbushWarn(arg0_226)
	if arg0_226.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_226.ambushWarning)

		arg0_226.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_227, arg1_227)
	arg0_227.levelStrategyView = LevelStrategyView.New(arg0_227.topPanel, arg0_227.event, arg0_227.contextData)

	arg0_227.levelStrategyView:Load()
	arg0_227.levelStrategyView:ActionInvoke("set", arg1_227)

	local function var0_227()
		local var0_228 = arg0_227.contextData.chapterVO.fleet
		local var1_228 = pg.strategy_data_template[arg1_227.id]

		if not var0_228:canUseStrategy(arg1_227) then
			return
		end

		local var2_228 = var0_228:getNextStgUser(arg1_227.id)

		if var1_228.type == ChapterConst.StgTypeForm then
			arg0_227:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_228,
				arg1 = arg1_227.id
			})
		elseif var1_228.type == ChapterConst.StgTypeConsume then
			arg0_227:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_228,
				arg1 = arg1_227.id
			})
		end

		arg0_227:hideStrategyInfo()
	end

	local function var1_227()
		arg0_227:hideStrategyInfo()
	end

	arg0_227.levelStrategyView:ActionInvoke("setCBFunc", var0_227, var1_227)
end

function var0_0.hideStrategyInfo(arg0_230)
	if arg0_230.levelStrategyView then
		arg0_230.levelStrategyView:Destroy()

		arg0_230.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_231, arg1_231)
	local var0_231 = arg0_231.contextData.chapterVO
	local var1_231 = getProxy(ChapterProxy)
	local var2_231
	local var3_231
	local var4_231
	local var5_231
	local var6_231 = var1_231.repairTimes
	local var7_231, var8_231, var9_231 = ChapterConst.GetRepairParams()

	arg0_231.levelRepairView = LevelRepairView.New(arg0_231.topPanel, arg0_231.event, arg0_231.contextData)

	arg0_231.levelRepairView:Load()
	arg0_231.levelRepairView:ActionInvoke("set", var6_231, var7_231, var8_231, var9_231)

	local function var10_231()
		if var7_231 - math.min(var6_231, var7_231) == 0 and arg0_231.player:getTotalGem() < var9_231 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_231:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_231.fleet.id,
			arg1 = arg1_231.id
		})
		arg0_231:hideRepairWindow()
	end

	local function var11_231()
		arg0_231:hideRepairWindow()
	end

	arg0_231.levelRepairView:ActionInvoke("setCBFunc", var10_231, var11_231)
end

function var0_0.hideRepairWindow(arg0_234)
	if arg0_234.levelRepairView then
		arg0_234.levelRepairView:Destroy()

		arg0_234.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_235, arg1_235)
	arg0_235.levelRemasterView:Load()

	local function var0_235(arg0_236)
		arg0_235:ShowSelectedMap(arg0_236)
	end

	arg0_235.levelRemasterView:ActionInvoke("Show")
	arg0_235.levelRemasterView:ActionInvoke("set", var0_235, arg1_235)
end

function var0_0.hideRemasterPanel(arg0_237)
	if arg0_237.levelRemasterView:isShowing() then
		arg0_237.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_238, arg1_238)
	local var0_238 = arg0_238.contextData.chapterVO

	if not var0_238 then
		return
	end

	arg0_238:enableLevelCamera()
	setActive(arg0_238.uiMain, true)

	arg0_238.levelGrid.localEulerAngles = Vector3(var0_238.theme.angle, 0, 0)
	arg0_238.grid = LevelGrid.New(arg0_238.dragLayer)

	arg0_238.grid:attach(arg0_238)
	arg0_238.grid:ExtendItem("shipTpl", arg0_238.shipTpl)
	arg0_238.grid:ExtendItem("subTpl", arg0_238.subTpl)
	arg0_238.grid:ExtendItem("transportTpl", arg0_238.transportTpl)
	arg0_238.grid:ExtendItem("enemyTpl", arg0_238.enemyTpl)
	arg0_238.grid:ExtendItem("championTpl", arg0_238.championTpl)
	arg0_238.grid:ExtendItem("oniTpl", arg0_238.oniTpl)
	arg0_238.grid:ExtendItem("arrowTpl", arg0_238.arrowTarget)
	arg0_238.grid:ExtendItem("destinationMarkTpl", arg0_238.destinationMarkTpl)

	function arg0_238.grid.onShipStepChange(arg0_239)
		arg0_238.levelStageView:updateAmbushRate(arg0_239)
	end

	arg0_238.grid:initAll(arg1_238)
end

function var0_0.destroyGrid(arg0_240)
	if arg0_240.grid then
		arg0_240.grid:detach()

		arg0_240.grid = nil

		arg0_240:disableLevelCamera()
		setActive(arg0_240.dragLayer, true)
		setActive(arg0_240.uiMain, false)
	end
end

function var0_0.doTracking(arg0_241, arg1_241)
	arg0_241:frozen()

	local function var0_241()
		arg0_241.radar:SetActive(true)

		local var0_242 = tf(arg0_241.radar)

		var0_242:SetParent(arg0_241.topPanel, false)
		var0_242:SetSiblingIndex(1)
		var0_242:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_243)
			arg0_241.radar:SetActive(false)
			arg0_241:unfrozen()
			arg1_241()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_241.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_244)
			arg0_244:SetActive(true)

			arg0_241.radar = arg0_244

			var0_241()
		end)
	else
		var0_241()
	end
end

function var0_0.destroyTracking(arg0_245)
	if arg0_245.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_245.radar)

		arg0_245.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_246, arg1_246, arg2_246, arg3_246)
	local function var0_246()
		arg0_246.playing = true

		arg0_246:frozen()
		arg0_246.airStrike:SetActive(true)

		local var0_247 = tf(arg0_246.airStrike)

		var0_247:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_247:SetAsLastSibling()
		setActive(var0_247:Find("words/be_striked"), arg1_246 == ChapterConst.SubjectChampion)
		setActive(var0_247:Find("words/strike_enemy"), arg1_246 == ChapterConst.SubjectPlayer)

		local function var1_247()
			arg0_246.playing = false

			SetActive(arg0_246.airStrike, false)

			if arg3_246 then
				arg3_246()
			end

			arg0_246:unfrozen()
		end

		var0_247:GetComponent("DftAniEvent"):SetEndEvent(var1_247)

		if arg2_246 then
			onButton(arg0_246, var0_247, var1_247, SFX_PANEL)
		else
			removeOnButton(var0_247)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_246.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_249)
			arg0_249:SetActive(true)

			arg0_246.airStrike = arg0_249

			var0_246()
		end)
	else
		var0_246()
	end
end

function var0_0.destroyAirStrike(arg0_250)
	if arg0_250.airStrike then
		arg0_250.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_250.airStrike)

		arg0_250.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_251, arg1_251, arg2_251, arg3_251)
	arg0_251.uiAnims = arg0_251.uiAnims or {}

	local var0_251 = arg0_251.uiAnims[arg1_251]

	local function var1_251()
		arg0_251.playing = true

		arg0_251:frozen()
		var0_251:SetActive(true)

		local var0_252 = tf(var0_251)

		pg.UIMgr.GetInstance():OverlayPanel(var0_252)

		if arg3_251 then
			arg3_251(var0_251)
		end

		var0_252:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_253)
			arg0_251.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_252, arg0_251._tf)

			if arg2_251 then
				arg2_251(var0_251)
			end

			arg0_251:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_251 then
		PoolMgr.GetInstance():GetUI(arg1_251, true, function(arg0_254)
			arg0_254:SetActive(true)

			arg0_251.uiAnims[arg1_251] = arg0_254
			var0_251 = arg0_251.uiAnims[arg1_251]

			var1_251()
		end)
	else
		var1_251()
	end
end

function var0_0.destroyUIAnims(arg0_255)
	if arg0_255.uiAnims then
		for iter0_255, iter1_255 in pairs(arg0_255.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_255), arg0_255._tf)
			iter1_255:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_255, iter1_255)
		end

		arg0_255.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_256, arg1_256)
	local function var0_256()
		arg0_256.playing = true

		arg0_256:frozen()
		arg0_256.torpetoAni:SetActive(true)

		local var0_257 = tf(arg0_256.torpetoAni)

		var0_257:SetParent(arg0_256.topPanel, false)
		var0_257:SetAsLastSibling()
		var0_257:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_258)
			arg0_256.playing = false

			SetActive(arg0_256.torpetoAni, false)

			if arg1_256 then
				arg1_256()
			end

			arg0_256:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_256.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_259)
			arg0_259:SetActive(true)

			arg0_256.torpetoAni = arg0_259

			var0_256()
		end)
	else
		var0_256()
	end
end

function var0_0.destroyTorpedo(arg0_260)
	if arg0_260.torpetoAni then
		arg0_260.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_260.torpetoAni)

		arg0_260.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_261, arg1_261, arg2_261, arg3_261)
	arg0_261.strikeAnims = arg0_261.strikeAnims or {}

	local var0_261
	local var1_261
	local var2_261

	local function var3_261()
		if coroutine.status(var2_261) == "suspended" then
			local var0_262, var1_262 = coroutine.resume(var2_261)

			assert(var0_262, debug.traceback(var2_261, var1_262))
		end
	end

	var2_261 = coroutine.create(function()
		arg0_261.playing = true

		arg0_261:frozen()

		local var0_263 = arg0_261.strikeAnims[arg2_261]

		setActive(var0_263, true)

		local var1_263 = tf(var0_263)
		local var2_263 = findTF(var1_263, "torpedo")
		local var3_263 = findTF(var1_263, "mask/painting")
		local var4_263 = findTF(var1_263, "ship")

		setParent(var0_261, var3_263:Find("fitter"), false)
		var1_261:SetParent(var4_263)
		setActive(var4_263, false)
		setActive(var2_263, false)
		var1_263:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_263:SetAsLastSibling()

		local var5_263 = var1_263:GetComponent("DftAniEvent")
		local var6_263 = var1_261:GetSkeletonGraphic()

		var5_263:SetStartEvent(function(arg0_264)
			var1_261:SetAction("attack", 0)

			var6_263.freeze = true
		end)
		var5_263:SetTriggerEvent(function(arg0_265)
			var6_263.freeze = false

			var1_261:SetActionCallBack(function(arg0_266)
				if arg0_266 == "action" then
					-- block empty
				elseif arg0_266 == "finish" then
					var6_263.freeze = true
				end
			end)
		end)
		var5_263:SetEndEvent(function(arg0_267)
			var6_263.freeze = false

			var3_261()
		end)
		onButton(arg0_261, var1_263, var3_261, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_263, arg1_261:getPainting())
		var1_261:SetActionCallBack(nil)

		var6_263.freeze = false

		var1_261:Dispose()
		setActive(var0_263, false)

		arg0_261.playing = false

		arg0_261:unfrozen()

		if arg3_261 then
			arg3_261()
		end
	end)

	local function var4_261()
		if arg0_261.strikeAnims[arg2_261] and var0_261 and var1_261 then
			var3_261()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_261:getPainting(), true, function(arg0_269)
		var0_261 = arg0_269

		ShipExpressionHelper.SetExpression(var0_261, arg1_261:getPainting())
		var4_261()
	end)

	var1_261 = SpineAnimChar.New()

	var1_261:SetPaint(arg1_261:getPrefab())
	var1_261:Load(true, function(arg0_270)
		var1_261:SetLocalScale(Vector3.one)
		var4_261()
	end)

	if not arg0_261.strikeAnims[arg2_261] then
		PoolMgr.GetInstance():GetUI(arg2_261, true, function(arg0_271)
			arg0_261.strikeAnims[arg2_261] = arg0_271

			var4_261()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_272)
	if arg0_272.strikeAnims then
		for iter0_272, iter1_272 in pairs(arg0_272.strikeAnims) do
			iter1_272:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_272, iter1_272)
		end

		arg0_272.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_273, arg1_273, arg2_273, arg3_273)
	arg0_273.strikeAnims = arg0_273.strikeAnims or {}

	local var0_273
	local var1_273

	local function var2_273()
		if coroutine.status(var1_273) == "suspended" then
			local var0_274, var1_274 = coroutine.resume(var1_273)

			assert(var0_274, debug.traceback(var1_273, var1_274))
		end
	end

	var1_273 = coroutine.create(function()
		arg0_273.playing = true

		arg0_273:frozen()

		local var0_275 = arg0_273.strikeAnims[arg2_273]

		setActive(var0_275, true)

		local var1_275 = tf(var0_275)
		local var2_275 = findTF(var1_275, "torpedo")
		local var3_275 = findTF(var1_275, "ship")

		var0_273:SetParent(var3_275)
		setActive(var3_275, false)
		setActive(var2_275, false)
		var1_275:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_275:SetAsLastSibling()

		local var4_275 = var1_275:GetComponent("DftAniEvent")
		local var5_275 = var0_273:GetSkeletonGraphic()

		var4_275:SetStartEvent(function(arg0_276)
			var0_273:SetAction("attack", 0)

			var5_275.freeze = true
		end)
		var4_275:SetTriggerEvent(function(arg0_277)
			var5_275.freeze = false

			var0_273:SetActionCallBack(function(arg0_278)
				if arg0_278 == "action" then
					-- block empty
				elseif arg0_278 == "finish" then
					var5_275.freeze = true
				end
			end)
		end)
		var4_275:SetEndEvent(function(arg0_279)
			var5_275.freeze = false

			var2_273()
		end)
		onButton(arg0_273, var1_275, var2_273, SFX_CANCEL)
		coroutine.yield()
		var0_273:SetActionCallBack(nil)

		var5_275.freeze = false

		var0_273:Dispose()
		setActive(var0_275, false)

		arg0_273.playing = false

		arg0_273:unfrozen()

		if arg3_273 then
			arg3_273()
		end
	end)

	local function var3_273()
		if arg0_273.strikeAnims[arg2_273] and var0_273 then
			var2_273()
		end
	end

	var0_273 = SpineAnimChar.New()

	var0_273:SetPaint(arg1_273:getPrefab())
	var0_273:Load(true, function(arg0_281)
		arg0_281:SetLocalScale(Vector3.one)
		var3_273()
	end)

	if not arg0_273.strikeAnims[arg2_273] then
		PoolMgr.GetInstance():GetUI(arg2_273, true, function(arg0_282)
			arg0_273.strikeAnims[arg2_273] = arg0_282

			var3_273()
		end)
	end
end

function var0_0.doPlayCommander(arg0_283, arg1_283, arg2_283)
	arg0_283:frozen()
	setActive(arg0_283.commanderTinkle, true)

	local var0_283 = arg1_283:getSkills()

	setText(arg0_283.commanderTinkle:Find("name"), #var0_283 > 0 and var0_283[1]:getConfig("name") or "")
	setImageSprite(arg0_283.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_283:getConfig("painting"), ""))

	local var1_283 = arg0_283.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_283.alpha = 0

	local var2_283 = Vector2(248, 237)

	LeanTween.value(go(arg0_283.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_284)
		local var0_284 = arg0_283.commanderTinkle.localPosition

		var0_284.x = var2_283.x + -100 * (1 - arg0_284)
		arg0_283.commanderTinkle.localPosition = var0_284
		var1_283.alpha = arg0_284
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_283.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_285)
		local var0_285 = arg0_283.commanderTinkle.localPosition

		var0_285.x = var2_283.x + 100 * arg0_285
		arg0_283.commanderTinkle.localPosition = var0_285
		var1_283.alpha = 1 - arg0_285
	end)):setOnComplete(System.Action(function()
		if arg2_283 then
			arg2_283()
		end

		arg0_283:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_287, arg1_287, arg2_287, arg3_287)
	local var0_287 = arg0_287.grid:shakeCell(arg1_287)

	if not var0_287 then
		arg3_287()

		return
	end

	arg0_287:easeDamage(var0_287, arg2_287, function()
		arg3_287()
	end)
end

function var0_0.easeDamage(arg0_289, arg1_289, arg2_289, arg3_289)
	arg0_289:frozen()

	local var0_289 = arg0_289.levelCam:WorldToScreenPoint(arg1_289.position)
	local var1_289 = tf(arg0_289:GetDamageText())

	var1_289.position = arg0_289.uiCam:ScreenToWorldPoint(var0_289)

	local var2_289 = var1_289.localPosition

	var2_289.y = var2_289.y + 40
	var2_289.z = 0

	setText(var1_289, arg2_289)

	var1_289.localPosition = var2_289

	LeanTween.value(go(var1_289), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_290)
		local var0_290 = var1_289.localPosition

		var0_290.y = var2_289.y + 60 * arg0_290
		var1_289.localPosition = var0_290

		setTextAlpha(var1_289, 1 - arg0_290)
	end)):setOnComplete(System.Action(function()
		arg0_289:ReturnDamageText(var1_289)
		arg0_289:unfrozen()

		if arg3_289 then
			arg3_289()
		end
	end))
end

function var0_0.easeAvoid(arg0_292, arg1_292, arg2_292)
	arg0_292:frozen()

	local var0_292 = arg0_292.levelCam:WorldToScreenPoint(arg1_292)

	arg0_292.avoidText.position = arg0_292.uiCam:ScreenToWorldPoint(var0_292)

	local var1_292 = arg0_292.avoidText.localPosition

	var1_292.z = 0
	arg0_292.avoidText.localPosition = var1_292

	setActive(arg0_292.avoidText, true)

	local var2_292 = arg0_292.avoidText:Find("avoid")

	LeanTween.value(go(arg0_292.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_293)
		local var0_293 = arg0_292.avoidText.localPosition

		var0_293.y = var1_292.y + 100 * arg0_293
		arg0_292.avoidText.localPosition = var0_293

		setImageAlpha(arg0_292.avoidText, 1 - arg0_293)
		setImageAlpha(var2_292, 1 - arg0_293)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_292.avoidText, false)
		arg0_292:unfrozen()

		if arg2_292 then
			arg2_292()
		end
	end))
end

function var0_0.GetDamageText(arg0_295)
	local var0_295 = table.remove(arg0_295.damageTextPool)

	if not var0_295 then
		var0_295 = Instantiate(arg0_295.damageTextTemplate)

		local var1_295 = tf(arg0_295.damageTextTemplate):GetSiblingIndex()

		setParent(var0_295, tf(arg0_295.damageTextTemplate).parent)
		tf(var0_295):SetSiblingIndex(var1_295 + 1)
	end

	table.insert(arg0_295.damageTextActive, var0_295)
	setActive(var0_295, true)

	return var0_295
end

function var0_0.ReturnDamageText(arg0_296, arg1_296)
	assert(arg1_296)

	if not arg1_296 then
		return
	end

	arg1_296 = go(arg1_296)

	table.removebyvalue(arg0_296.damageTextActive, arg1_296)
	table.insert(arg0_296.damageTextPool, arg1_296)
	setActive(arg1_296, false)
end

function var0_0.resetLevelGrid(arg0_297)
	arg0_297.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_298, arg1_298)
	setActive(arg0_298.curtain, arg1_298)
end

function var0_0.frozen(arg0_299)
	local var0_299 = arg0_299.frozenCount

	arg0_299.frozenCount = arg0_299.frozenCount + 1
	arg0_299.canvasGroup.blocksRaycasts = arg0_299.frozenCount == 0

	if var0_299 == 0 and arg0_299.frozenCount ~= 0 then
		arg0_299:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_300, arg1_300)
	if arg0_300.exited then
		return
	end

	local var0_300 = arg0_300.frozenCount
	local var1_300 = arg1_300 == -1 and arg0_300.frozenCount or arg1_300 or 1

	arg0_300.frozenCount = arg0_300.frozenCount - var1_300
	arg0_300.canvasGroup.blocksRaycasts = arg0_300.frozenCount == 0

	if var0_300 ~= 0 and arg0_300.frozenCount == 0 then
		arg0_300:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_301)
	return arg0_301.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_302)
	arg0_302.levelCamIndices = math.max(arg0_302.levelCamIndices - 1, 0)

	if arg0_302.levelCamIndices == 0 then
		arg0_302.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.disableLevelCamera(arg0_303)
	arg0_303.levelCamIndices = arg0_303.levelCamIndices + 1

	if arg0_303.levelCamIndices > 0 then
		arg0_303.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.RecordTween(arg0_304, arg1_304, arg2_304)
	arg0_304.tweens[arg1_304] = arg2_304
end

function var0_0.DeleteTween(arg0_305, arg1_305)
	local var0_305 = arg0_305.tweens[arg1_305]

	if var0_305 then
		LeanTween.cancel(var0_305)

		arg0_305.tweens[arg1_305] = nil
	end
end

function var0_0.openCommanderPanel(arg0_306, arg1_306, arg2_306, arg3_306)
	local var0_306 = arg2_306.id

	arg0_306.levelCMDFormationView:setCallback(function(arg0_307)
		if not arg3_306 then
			if arg0_307.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_306:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_307.skill)
			elseif arg0_307.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_306.contextData.commanderSelected = {
					chapterId = var0_306,
					fleetId = arg1_306.id
				}

				arg0_306:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_307.pos, arg1_306.id, arg2_306)
				arg0_306:closeCommanderPanel()
			else
				arg0_306:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_307,
					fleetId = arg1_306.id,
					chapterId = var0_306
				}, arg2_306)
			end
		elseif arg0_307.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_306:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_307.skill)
		elseif arg0_307.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_306.contextData.eliteCommanderSelected = {
				index = arg3_306,
				pos = arg0_307.pos,
				chapterId = var0_306
			}

			arg0_306:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_306, arg0_307.pos, arg2_306)
			arg0_306:closeCommanderPanel()
		else
			arg0_306:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_307,
				index = arg3_306,
				chapterId = var0_306
			}, arg2_306)
		end
	end)
	arg0_306.levelCMDFormationView:Load()
	arg0_306.levelCMDFormationView:ActionInvoke("update", arg1_306, arg0_306.commanderPrefabs)
	arg0_306.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_308)
	if arg0_308.levelCMDFormationView:isShowing() then
		arg0_308.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_308.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_309)
	arg0_309.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_310)
	arg0_310.levelCMDFormationView:Destroy()

	arg0_310.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_311, arg1_311)
	arg0_311.spTickets = arg1_311
end

function var0_0.HandleShowMsgBox(arg0_312, arg1_312)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_312)
end

function var0_0.updatePoisonAreaTip(arg0_313)
	local var0_313 = arg0_313.contextData.chapterVO
	local var1_313 = (function(arg0_314)
		local var0_314 = {}
		local var1_314 = pg.map_event_list[var0_313.id] or {}
		local var2_314

		if var0_313:isLoop() then
			var2_314 = var1_314.event_list_loop or {}
		else
			var2_314 = var1_314.event_list or {}
		end

		for iter0_314, iter1_314 in ipairs(var2_314) do
			local var3_314 = pg.map_event_template[iter1_314]

			if var3_314.c_type == arg0_314 then
				table.insert(var0_314, var3_314)
			end
		end

		return var0_314
	end)(ChapterConst.EvtType_Poison)

	if var1_313 then
		for iter0_313, iter1_313 in ipairs(var1_313) do
			local var2_313 = iter1_313.round_gametip

			if var2_313 ~= nil and var2_313 ~= "" and var0_313:getRoundNum() == var2_313[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_313[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_315)
	setActive(arg0_315._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_316)
	local var0_316 = getProxy(ChapterProxy)

	if var0_316 and not arg0_316.contextData.noRecord then
		local var1_316 = arg0_316.contextData.map

		if not var1_316 then
			return
		end

		if var1_316:NeedRecordMap() then
			var0_316:recordLastMap(ChapterProxy.LAST_MAP, var1_316.id)
		end

		if var1_316:isActivity() and not var1_316:isActExtra() then
			var0_316:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_316.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_317)
	local var0_317 = arg0_317.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_317.contextData.map:getConfig("on_activity")) or nil
	local var1_317 = var0_317 and not var0_317:isEnd() and var0_317:GetConfigClientSetting("PTID")
	local var2_317 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var2_317 and not var2_317:isEnd() and var2_317:getConfig("config_client").resId == var1_317 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_318)
		return not arg0_318:isEnd() and arg0_318:getConfig("config_client").pt_id == var1_317
	end) then
		return true
	end
end

function var0_0.willExit(arg0_319)
	arg0_319:ClearMapTransitions()
	arg0_319.loader:Clear()

	if arg0_319.contextData.chapterVO then
		arg0_319:UnOverlayPanel(arg0_319.topPanel, arg0_319._tf)
	end

	if arg0_319.levelFleetView and arg0_319.levelFleetView.selectIds then
		arg0_319.contextData.selectedFleetIDs = {}

		for iter0_319, iter1_319 in pairs(arg0_319.levelFleetView.selectIds) do
			for iter2_319, iter3_319 in pairs(iter1_319) do
				arg0_319.contextData.selectedFleetIDs[#arg0_319.contextData.selectedFleetIDs + 1] = iter3_319
			end
		end
	end

	arg0_319:destroyChapterPanel()
	arg0_319:DestroyLevelInfoSPPanel()
	arg0_319:destroyFleetEdit()
	arg0_319:destroyCommanderPanel()
	arg0_319:DestroyLevelStageView()
	arg0_319:hideRepairWindow()
	arg0_319:hideStrategyInfo()
	arg0_319:hideRemasterPanel()
	arg0_319:hideSpResult()
	arg0_319:destroyGrid()
	arg0_319:destroyAmbushWarn()
	arg0_319:destroyAirStrike()
	arg0_319:destroyTorpedo()
	arg0_319:destroyStrikeAnim()
	arg0_319:destroyTracking()
	arg0_319:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_319, iter5_319 in pairs(arg0_319.mbDict) do
		iter5_319:Destroy()
	end

	arg0_319.mbDict = nil

	for iter6_319, iter7_319 in pairs(arg0_319.tweens) do
		LeanTween.cancel(iter7_319)
	end

	arg0_319.tweens = nil

	if arg0_319.cloudTimer then
		_.each(arg0_319.cloudTimer, function(arg0_320)
			LeanTween.cancel(arg0_320)
		end)

		arg0_319.cloudTimer = nil
	end

	if arg0_319.newChapterCDTimer then
		arg0_319.newChapterCDTimer:Stop()

		arg0_319.newChapterCDTimer = nil
	end

	for iter8_319, iter9_319 in ipairs(arg0_319.damageTextActive) do
		LeanTween.cancel(iter9_319)
	end

	LeanTween.cancel(go(arg0_319.avoidText))

	arg0_319.map.localScale = Vector3.one
	arg0_319.map.pivot = Vector2(0.5, 0.5)
	arg0_319.float.localScale = Vector3.one
	arg0_319.float.pivot = Vector2(0.5, 0.5)

	for iter10_319, iter11_319 in ipairs(arg0_319.mapTFs) do
		clearImageSprite(iter11_319)
	end

	_.each(arg0_319.cloudRTFs, function(arg0_321)
		clearImageSprite(arg0_321)
	end)
	Destroy(arg0_319.enemyTpl)
	arg0_319:RecordLastMapOnExit()
	arg0_319.levelRemasterView:Destroy()
end

return var0_0
