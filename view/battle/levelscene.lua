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
				arg0_73.grid:UpdateWeatherCells()

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

		if arg2_73 < 0 or bit.band(arg2_73, ChapterConst.DirtyWeather) > 0 then
			arg0_73.grid:UpdateWeatherCells()
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
	local var1_94 = arg0_94.contextData.map:getRemaster()
	local var2_94 = BossRushChapterRemasterHelper.ChapterAwardInfo(var1_94)

	setActive(arg0_94.remasterAwardBtn, var2_94)

	if var2_94 then
		local var3_94 = var2_94[1]
		local var4_94, var5_94, var6_94, var7_94, var8_94 = unpack(var2_94[2])
		local var9_94 = var2_94[3]
		local var10_94 = var0_94:getRemasterInfo(var9_94, var4_94, var3_94)

		setText(arg0_94.remasterAwardBtn:Find("Text"), var10_94.count .. "/" .. var7_94)
		updateDrop(arg0_94.remasterAwardBtn:Find("IconTpl"), {
			type = var5_94,
			id = var6_94
		})
		setActive(arg0_94.remasterAwardBtn:Find("tip"), var7_94 <= var10_94.count)
		onButton(arg0_94, arg0_94.remasterAwardBtn, function()
			local var0_95 = BossRushChapterRemasterHelper.GetAwardName(var9_94, var4_94)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5_94,
					id = var6_94
				},
				remaster = {
					word = i18n("level_remaster_tip4", var0_95),
					number = var10_94.count .. "/" .. var7_94,
					btn_text = i18n(var10_94.count < var7_94 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var10_94.count < var7_94 then
							if var9_94 and var9_94 > 0 then
								arg0_94:emit(LevelMediator2.ON_BOSSRUSH_REMASTER_ACTIVITY, var9_94)

								return
							end

							local var0_96 = pg.chapter_template[var4_94].map
							local var1_96, var2_96 = var0_94:getMapById(var0_96):isUnlock()

							if not var1_96 then
								pg.TipsMgr.GetInstance():ShowTips(var2_96)
							else
								arg0_94:ShowSelectedMap(var0_96)
							end
						else
							arg0_94:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4_94, var3_94, var9_94)
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
			local var1_102 = arg0_100.activityBtnLinkAct.id

			if var0_102 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)

				return
			elseif var0_102 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)

				return
			elseif var1_102 == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)

				return
			elseif var0_102 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ZHANG_WU_BOSS)

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
	[var5_0.TYPEEXSP] = "MapBuilderEXSP",
	[var5_0.TYPESPSERIESRECREW] = "MapBuilderSPSeriesRecrew"
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

				arg0_190()
			end,
			function(arg0_191)
				if arg1_173:NeedSupportSubmarineStage() then
					arg0_173.levelStageView:TryEnterChapterSupportSubmarineStage(arg0_191)
				else
					arg0_191()
				end
			end
		}, function()
			arg0_173.levelStageView:tryAutoTrigger(true)
		end)
	end

	arg0_173.levelStageView:ActionInvoke("SetSeriesOperation", var0_173)
	arg0_173.levelStageView:ActionInvoke("SetPlayer", arg0_173.player)
	arg0_173.levelStageView:ActionInvoke("SwitchToChapter", arg1_173)
end

function var0_0.switchToMap(arg0_193, arg1_193)
	arg0_193:frozen()
	arg0_193:destroyGrid()
	arg0_193:setChapter(nil)
	LeanTween.cancel(go(arg0_193.map))

	local var0_193 = LeanTween.value(go(arg0_193.map), arg0_193.map.localScale, Vector3.one, var1_0):setOnUpdateVector3(function(arg0_194)
		arg0_193.map.localScale = arg0_194
		arg0_193.float.localScale = arg0_194
	end):setOnComplete(System.Action(function()
		arg0_193:unfrozen()
		arg0_193.mapBuilder:PlayEnterAnim()
		existCall(arg1_193)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0_193:RecordTween("mapScale", var0_193.uniqueId)

	local var1_193 = arg0_193.contextData.map:getConfig("anchor")
	local var2_193

	if var1_193 == "" then
		var2_193 = Vector2(0.5, 0.5)
	else
		var2_193 = Vector2(unpack(var1_193))
	end

	local var3_193 = LeanTween.value(go(arg0_193.map), arg0_193.map.pivot, var2_193, var1_0)

	var3_193:setOnUpdateVector2(function(arg0_196)
		arg0_193.map.pivot = arg0_196
		arg0_193.float.pivot = arg0_196
	end):setEase(LeanTweenType.easeOutSine)
	arg0_193:RecordTween("mapPivot", var3_193.uniqueId)
	setActive(arg0_193.topChapter, true)
	setActive(arg0_193.leftChapter, true)
	setActive(arg0_193.rightChapter, true)
	shiftPanel(arg0_193.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_193.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_193.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0_193.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0_193.levelStageView then
		arg0_193.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0_193:DestroyLevelStageView()
		end)
		arg0_193.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0_193:SwitchMapBG(arg0_193.contextData.map)
	arg0_193:PlayBGM()
	seriesAsync({
		function(arg0_198)
			arg0_193.mapBuilder:CallbackInvoke(arg0_198)
		end,
		function(arg0_199)
			arg0_193.mapBuilder:Show()
			arg0_193.mapBuilder:UpdateView()
			arg0_193.mapBuilder:UpdateMapItems()
		end
	})
	arg0_193:UnOverlayPanel(arg0_193.topPanel, arg0_193._tf)

	arg0_193.canvasGroup.blocksRaycasts = arg0_193.frozenCount == 0
	arg0_193.canvasGroup.interactable = true

	if arg0_193.ambushWarning and arg0_193.ambushWarning.activeSelf then
		arg0_193.ambushWarning:SetActive(false)
		arg0_193:unfrozen()
	end
end

function var0_0.SwitchBG(arg0_200, arg1_200, arg2_200, arg3_200)
	if not arg1_200 or #arg1_200 <= 0 then
		existCall(arg2_200)

		return
	elseif arg3_200 then
		-- block empty
	elseif table.equal(arg0_200.currentBG, arg1_200) then
		return
	end

	arg0_200.currentBG = arg1_200

	for iter0_200, iter1_200 in ipairs(arg0_200.mapGroup) do
		arg0_200.loader:ClearRequest(iter1_200)
	end

	table.clear(arg0_200.mapGroup)

	local var0_200 = {}

	table.ParallelIpairsAsync(arg1_200, function(arg0_201, arg1_201, arg2_201)
		local var0_201 = arg0_200.mapTFs[arg0_201]
		local var1_201 = arg1_201.bgPrefix and arg1_201.bgPrefix .. "/" or "levelmap/"
		local var2_201 = arg0_200.loader:GetSpriteDirect(var1_201 .. arg1_201.BG, "", function(arg0_202)
			var0_200[arg0_201] = arg0_202

			arg2_201()
		end, var0_201)

		table.insert(arg0_200.mapGroup, var2_201)
		arg0_200:updateCouldAnimator(arg1_201.Animator, arg0_201)
	end, function()
		for iter0_203, iter1_203 in ipairs(arg0_200.mapTFs) do
			setImageSprite(iter1_203, var0_200[iter0_203])
			setActive(iter1_203, arg1_200[iter0_203])
			SetCompomentEnabled(iter1_203, typeof(Image), true)
		end

		existCall(arg2_200)
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

function var0_0.ClearMapTransitions(arg0_204)
	if not arg0_204.mapTransitions then
		return
	end

	for iter0_204, iter1_204 in pairs(arg0_204.mapTransitions) do
		if iter1_204 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_204, iter0_204, iter1_204, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0_204, iter0_204)
		end
	end

	arg0_204.mapTransitions = nil
end

function var0_0.SwitchMapBG(arg0_205, arg1_205, arg2_205, arg3_205)
	local var0_205, var1_205, var2_205 = arg0_205:GetMapBG(arg1_205, arg2_205)
	local var3_205 = {}

	if var1_205 then
		table.insert(var3_205, function(arg0_206)
			arg0_205:PlayMapTransition("LevelMapTransition_" .. var1_205, var2_205, arg0_206)
		end)
	end

	seriesAsync(var3_205, function()
		arg0_205:SwitchBGMapType(arg1_205:getConfig("pos_type"))
		arg0_205:SwitchBG(var0_205, nil, arg3_205)
	end)
end

function var0_0.SwitchBGMapType(arg0_208, arg1_208)
	if arg0_208.posType == arg1_208 then
		return
	end

	for iter0_208, iter1_208 in ipairs({
		arg0_208.map,
		arg0_208.float
	}) do
		local var0_208 = GetOrAddComponent(iter1_208, typeof(AspectRatioFitter))

		var0_208.aspectRatio = 1.77777777777778
		var0_208.enabled = arg1_208 == 0

		if arg1_208 == 1 then
			iter1_208.anchorMin = Vector2(0.5, 0.5)
			iter1_208.anchorMax = Vector2(0.5, 0.5)

			setSizeDelta(var0_208, {
				x = 2520,
				y = 1440
			})
		end
	end
end

function var0_0.GetMapBG(arg0_209, arg1_209, arg2_209)
	if not table.contains(var7_0, arg1_209.id) then
		return {
			arg0_209:GetMapElement(arg1_209)
		}
	end

	local var0_209 = arg1_209.id
	local var1_209 = table.indexof(var7_0, var0_209) - 1
	local var2_209 = bit.lshift(bit.rshift(var1_209, 1), 1) + 1
	local var3_209 = {
		var7_0[var2_209],
		var7_0[var2_209 + 1]
	}
	local var4_209 = _.map(var3_209, function(arg0_210)
		return getProxy(ChapterProxy):getMapById(arg0_210)
	end)

	if _.all(var4_209, function(arg0_211)
		return arg0_211:isAllChaptersClear()
	end) then
		local var5_209 = {
			arg0_209:GetMapElement(arg1_209)
		}

		if not arg2_209 or math.abs(var0_209 - arg2_209) ~= 1 then
			return var5_209
		end

		local var6_209 = var9_0[bit.rshift(var2_209 - 1, 1) + 1]
		local var7_209 = bit.band(var1_209, 1) == 1

		return var5_209, var6_209, var7_209
	else
		local var8_209 = 0

		;(function()
			local var0_212 = var4_209[1]:getChapters()

			for iter0_212, iter1_212 in ipairs(var0_212) do
				if not iter1_212:isClear() then
					return
				end

				var8_209 = var8_209 + 1
			end

			if not var4_209[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8_209 = var8_209 + 1

			local var1_212 = var4_209[2]:getChapters()

			for iter2_212, iter3_212 in ipairs(var1_212) do
				if not iter3_212:isClear() then
					return
				end

				var8_209 = var8_209 + 1
			end
		end)()

		local var9_209

		if var8_209 > 0 then
			local var10_209 = var8_0[bit.rshift(var2_209 - 1, 1) + 1]

			var9_209 = {
				{
					BG = "map_" .. var10_209[1],
					Animator = var10_209[2]
				},
				{
					BG = "map_" .. var10_209[3] + var8_209,
					Animator = var10_209[4]
				}
			}
		else
			var9_209 = {
				arg0_209:GetMapElement(arg1_209)
			}
		end

		return var9_209
	end
end

function var0_0.GetMapElement(arg0_213, arg1_213)
	local var0_213 = arg1_213:getConfig("bg")
	local var1_213 = arg1_213:getConfig("ani_controller")

	if var1_213 and #var1_213 > 0 then
		(function()
			local var0_214 = getProxy(ChapterProxy)

			for iter0_214, iter1_214 in ipairs(var1_213) do
				local var1_214 = _.rest(iter1_214[2], 2)

				for iter2_214, iter3_214 in ipairs(var1_214) do
					if string.find(iter3_214, "^map_") and iter1_214[1] == var3_0 then
						local var2_214 = iter1_214[2][1]
						local var3_214 = false

						for iter4_214, iter5_214 in ipairs(var2_214) do
							local var4_214 = var0_214:GetChapterItemById(iter5_214)

							if var4_214 and var4_214:isClear() then
								var3_214 = true

								break
							end
						end

						if not var3_214 then
							var0_213 = iter3_214

							return
						end
					end
				end
			end
		end)()
	end

	local var2_213 = {
		BG = var0_213
	}

	var2_213.Animator, var2_213.AnimatorController = arg0_213:GetMapAnimator(arg1_213)

	return var2_213
end

function var0_0.GetMapAnimator(arg0_215, arg1_215)
	local var0_215 = arg1_215:getConfig("ani_name")

	if arg1_215:getConfig("animtor") == 1 and var0_215 and #var0_215 > 0 then
		local var1_215 = arg1_215:getConfig("ani_controller")

		if var1_215 and #var1_215 > 0 then
			(function()
				local var0_216 = getProxy(ChapterProxy)

				for iter0_216, iter1_216 in ipairs(var1_215) do
					local var1_216 = _.rest(iter1_216[2], 2)

					for iter2_216, iter3_216 in ipairs(var1_216) do
						if string.find(iter3_216, "^effect_") and iter1_216[1] == var3_0 then
							local var2_216 = iter1_216[2][1]
							local var3_216 = false

							for iter4_216, iter5_216 in ipairs(var2_216) do
								local var4_216 = var0_216:GetChapterItemById(iter5_216)

								if var4_216 and var4_216:isClear() then
									var3_216 = true

									break
								end
							end

							if not var3_216 then
								var0_215 = "map_" .. string.sub(iter3_216, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0_215, var1_215
	end
end

function var0_0.PlayMapTransition(arg0_217, arg1_217, arg2_217, arg3_217, arg4_217)
	arg0_217.mapTransitions = arg0_217.mapTransitions or {}

	local var0_217

	local function var1_217()
		arg0_217:frozen()
		existCall(arg3_217, var0_217)
		var0_217:SetActive(true)

		local var0_218 = tf(var0_217)

		pg.UIMgr.GetInstance():OverlayPanel(var0_218)
		var0_217:GetComponent(typeof(Animator)):Play(arg2_217 and "Sequence" or "Inverted", -1, 0)
		var0_218:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_219)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_218, arg0_217._tf)
			existCall(arg4_217, var0_217)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_217, arg1_217, var0_217)

			arg0_217.mapTransitions[arg1_217] = false

			arg0_217:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_217, arg1_217, true, function(arg0_220)
		var0_217 = arg0_220
		arg0_217.mapTransitions[arg1_217] = arg0_220

		var1_217()
	end)
end

function var0_0.DestroyLevelStageView(arg0_221)
	if arg0_221.levelStageView then
		arg0_221.levelStageView:Destroy()

		arg0_221.levelStageView = nil
	end
end

function var0_0.displayAmbushInfo(arg0_222, arg1_222)
	arg0_222.levelAmbushView = LevelAmbushView.New(arg0_222.topPanel, arg0_222.event, arg0_222.contextData)

	arg0_222.levelAmbushView:Load()
	arg0_222.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1_222)
end

function var0_0.hideAmbushInfo(arg0_223)
	if arg0_223.levelAmbushView then
		arg0_223.levelAmbushView:Destroy()

		arg0_223.levelAmbushView = nil
	end
end

function var0_0.doAmbushWarning(arg0_224, arg1_224)
	arg0_224:frozen()

	local function var0_224()
		arg0_224.ambushWarning:SetActive(true)

		local var0_225 = tf(arg0_224.ambushWarning)

		var0_225:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_225:SetSiblingIndex(1)

		local var1_225 = var0_225:GetComponent("DftAniEvent")

		var1_225:SetTriggerEvent(function(arg0_226)
			arg1_224()
		end)
		var1_225:SetEndEvent(function(arg0_227)
			arg0_224.ambushWarning:SetActive(false)
			arg0_224:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0_224.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0_229)
			arg0_229:SetActive(true)

			arg0_224.ambushWarning = arg0_229

			var0_224()
		end)
	else
		var0_224()
	end
end

function var0_0.destroyAmbushWarn(arg0_230)
	if arg0_230.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0_230.ambushWarning)

		arg0_230.ambushWarning = nil
	end
end

function var0_0.displayStrategyInfo(arg0_231, arg1_231)
	arg0_231.levelStrategyView = LevelStrategyView.New(arg0_231.topPanel, arg0_231.event, arg0_231.contextData)

	arg0_231.levelStrategyView:Load()
	arg0_231.levelStrategyView:ActionInvoke("set", arg1_231)

	local function var0_231()
		local var0_232 = arg0_231.contextData.chapterVO.fleet
		local var1_232 = pg.strategy_data_template[arg1_231.id]

		if not var0_232:canUseStrategy(arg1_231) then
			return
		end

		local var2_232 = var0_232:getNextStgUser(arg1_231.id)

		if var1_232.type == ChapterConst.StgTypeForm then
			arg0_231:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_232,
				arg1 = arg1_231.id
			})
		elseif var1_232.type == ChapterConst.StgTypeConsume then
			arg0_231:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2_232,
				arg1 = arg1_231.id
			})
		end

		arg0_231:hideStrategyInfo()
	end

	local function var1_231()
		arg0_231:hideStrategyInfo()
	end

	arg0_231.levelStrategyView:ActionInvoke("setCBFunc", var0_231, var1_231)
end

function var0_0.hideStrategyInfo(arg0_234)
	if arg0_234.levelStrategyView then
		arg0_234.levelStrategyView:Destroy()

		arg0_234.levelStrategyView = nil
	end
end

function var0_0.displayRepairWindow(arg0_235, arg1_235)
	local var0_235 = arg0_235.contextData.chapterVO
	local var1_235 = getProxy(ChapterProxy)
	local var2_235
	local var3_235
	local var4_235
	local var5_235
	local var6_235 = var1_235.repairTimes
	local var7_235, var8_235, var9_235 = ChapterConst.GetRepairParams()

	arg0_235.levelRepairView = LevelRepairView.New(arg0_235.topPanel, arg0_235.event, arg0_235.contextData)

	arg0_235.levelRepairView:Load()
	arg0_235.levelRepairView:ActionInvoke("set", var6_235, var7_235, var8_235, var9_235)

	local function var10_235()
		if var7_235 - math.min(var6_235, var7_235) == 0 and arg0_235.player:getTotalGem() < var9_235 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0_235:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0_235.fleet.id,
			arg1 = arg1_235.id
		})
		arg0_235:hideRepairWindow()
	end

	local function var11_235()
		arg0_235:hideRepairWindow()
	end

	arg0_235.levelRepairView:ActionInvoke("setCBFunc", var10_235, var11_235)
end

function var0_0.hideRepairWindow(arg0_238)
	if arg0_238.levelRepairView then
		arg0_238.levelRepairView:Destroy()

		arg0_238.levelRepairView = nil
	end
end

function var0_0.displayRemasterPanel(arg0_239, arg1_239)
	arg0_239.levelRemasterView:Load()

	local function var0_239(arg0_240)
		arg0_239:ShowSelectedMap(arg0_240)
	end

	arg0_239.levelRemasterView:ActionInvoke("Show")
	arg0_239.levelRemasterView:ActionInvoke("set", var0_239, arg1_239)
end

function var0_0.hideRemasterPanel(arg0_241)
	if arg0_241.levelRemasterView:isShowing() then
		arg0_241.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0_0.initGrid(arg0_242, arg1_242)
	local var0_242 = arg0_242.contextData.chapterVO

	if not var0_242 then
		return
	end

	arg0_242:enableLevelCamera()
	setActive(arg0_242.uiMain, true)

	arg0_242.levelGrid.localEulerAngles = Vector3(var0_242.theme.angle, 0, 0)
	arg0_242.grid = LevelGrid.New(arg0_242.dragLayer)

	arg0_242.grid:attach(arg0_242)
	arg0_242.grid:ExtendItem("shipTpl", arg0_242.shipTpl)
	arg0_242.grid:ExtendItem("subTpl", arg0_242.subTpl)
	arg0_242.grid:ExtendItem("transportTpl", arg0_242.transportTpl)
	arg0_242.grid:ExtendItem("enemyTpl", arg0_242.enemyTpl)
	arg0_242.grid:ExtendItem("championTpl", arg0_242.championTpl)
	arg0_242.grid:ExtendItem("oniTpl", arg0_242.oniTpl)
	arg0_242.grid:ExtendItem("arrowTpl", arg0_242.arrowTarget)
	arg0_242.grid:ExtendItem("destinationMarkTpl", arg0_242.destinationMarkTpl)

	function arg0_242.grid.onShipStepChange(arg0_243)
		arg0_242.levelStageView:updateAmbushRate(arg0_243)
	end

	arg0_242.grid:initAll(arg1_242)
end

function var0_0.destroyGrid(arg0_244)
	if arg0_244.grid then
		arg0_244.grid:detach()

		arg0_244.grid = nil

		arg0_244:disableLevelCamera()
		setActive(arg0_244.dragLayer, true)
		setActive(arg0_244.uiMain, false)
	end
end

function var0_0.doTracking(arg0_245, arg1_245)
	arg0_245:frozen()

	local function var0_245()
		arg0_245.radar:SetActive(true)

		local var0_246 = tf(arg0_245.radar)

		var0_246:SetParent(arg0_245.topPanel, false)
		var0_246:SetSiblingIndex(1)
		var0_246:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_247)
			arg0_245.radar:SetActive(false)
			arg0_245:unfrozen()
			arg1_245()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0_245.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0_248)
			arg0_248:SetActive(true)

			arg0_245.radar = arg0_248

			var0_245()
		end)
	else
		var0_245()
	end
end

function var0_0.destroyTracking(arg0_249)
	if arg0_249.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0_249.radar)

		arg0_249.radar = nil
	end
end

function var0_0.doPlayAirStrike(arg0_250, arg1_250, arg2_250, arg3_250)
	local function var0_250()
		arg0_250.playing = true

		arg0_250:frozen()
		arg0_250.airStrike:SetActive(true)

		local var0_251 = tf(arg0_250.airStrike)

		var0_251:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0_251:SetAsLastSibling()
		setActive(var0_251:Find("words/be_striked"), arg1_250 == ChapterConst.SubjectChampion)
		setActive(var0_251:Find("words/strike_enemy"), arg1_250 == ChapterConst.SubjectPlayer)

		local function var1_251()
			arg0_250.playing = false

			SetActive(arg0_250.airStrike, false)

			if arg3_250 then
				arg3_250()
			end

			arg0_250:unfrozen()
		end

		var0_251:GetComponent("DftAniEvent"):SetEndEvent(var1_251)

		if arg2_250 then
			onButton(arg0_250, var0_251, var1_251, SFX_PANEL)
		else
			removeOnButton(var0_251)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_250.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0_253)
			arg0_253:SetActive(true)

			arg0_250.airStrike = arg0_253

			var0_250()
		end)
	else
		var0_250()
	end
end

function var0_0.destroyAirStrike(arg0_254)
	if arg0_254.airStrike then
		arg0_254.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0_254.airStrike)

		arg0_254.airStrike = nil
	end
end

function var0_0.doPlayAnim(arg0_255, arg1_255, arg2_255, arg3_255)
	arg0_255.uiAnims = arg0_255.uiAnims or {}

	local var0_255 = arg0_255.uiAnims[arg1_255]

	local function var1_255()
		arg0_255.playing = true

		arg0_255:frozen()
		var0_255:SetActive(true)

		local var0_256 = tf(var0_255)

		pg.UIMgr.GetInstance():OverlayPanel(var0_256)

		if arg3_255 then
			arg3_255(var0_255)
		end

		var0_256:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_257)
			arg0_255.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0_256, arg0_255._tf)

			if arg2_255 then
				arg2_255(var0_255)
			end

			arg0_255:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0_255 then
		PoolMgr.GetInstance():GetUI(arg1_255, true, function(arg0_258)
			arg0_258:SetActive(true)

			arg0_255.uiAnims[arg1_255] = arg0_258
			var0_255 = arg0_255.uiAnims[arg1_255]

			var1_255()
		end)
	else
		var1_255()
	end
end

function var0_0.destroyUIAnims(arg0_259)
	if arg0_259.uiAnims then
		for iter0_259, iter1_259 in pairs(arg0_259.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1_259), arg0_259._tf)
			iter1_259:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_259, iter1_259)
		end

		arg0_259.uiAnims = nil
	end
end

function var0_0.doPlayTorpedo(arg0_260, arg1_260)
	local function var0_260()
		arg0_260.playing = true

		arg0_260:frozen()
		arg0_260.torpetoAni:SetActive(true)

		local var0_261 = tf(arg0_260.torpetoAni)

		var0_261:SetParent(arg0_260.topPanel, false)
		var0_261:SetAsLastSibling()
		var0_261:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_262)
			arg0_260.playing = false

			SetActive(arg0_260.torpetoAni, false)

			if arg1_260 then
				arg1_260()
			end

			arg0_260:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0_260.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0_263)
			arg0_263:SetActive(true)

			arg0_260.torpetoAni = arg0_263

			var0_260()
		end)
	else
		var0_260()
	end
end

function var0_0.destroyTorpedo(arg0_264)
	if arg0_264.torpetoAni then
		arg0_264.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0_264.torpetoAni)

		arg0_264.torpetoAni = nil
	end
end

function var0_0.doPlayStrikeAnim(arg0_265, arg1_265, arg2_265, arg3_265)
	arg0_265.strikeAnims = arg0_265.strikeAnims or {}

	local var0_265
	local var1_265
	local var2_265

	local function var3_265()
		if coroutine.status(var2_265) == "suspended" then
			local var0_266, var1_266 = coroutine.resume(var2_265)

			assert(var0_266, debug.traceback(var2_265, var1_266))
		end
	end

	var2_265 = coroutine.create(function()
		arg0_265.playing = true

		arg0_265:frozen()

		local var0_267 = arg0_265.strikeAnims[arg2_265]

		setActive(var0_267, true)

		local var1_267 = tf(var0_267)
		local var2_267 = findTF(var1_267, "torpedo")
		local var3_267 = findTF(var1_267, "mask/painting")
		local var4_267 = findTF(var1_267, "ship")

		setParent(var0_265, var3_267:Find("fitter"), false)
		var1_265:SetParent(var4_267)
		setActive(var4_267, false)
		setActive(var2_267, false)
		var1_267:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_267:SetAsLastSibling()

		local var5_267 = var1_267:GetComponent("DftAniEvent")
		local var6_267 = var1_265:GetSkeletonGraphic()

		var5_267:SetStartEvent(function(arg0_268)
			var1_265:SetAction("attack", 0)

			var6_267.freeze = true
		end)
		var5_267:SetTriggerEvent(function(arg0_269)
			var6_267.freeze = false

			var1_265:SetActionCallBack(function(arg0_270)
				if arg0_270 == "action" then
					-- block empty
				elseif arg0_270 == "finish" then
					var6_267.freeze = true
				end
			end)
		end)
		var5_267:SetEndEvent(function(arg0_271)
			var6_267.freeze = false

			var3_265()
		end)
		onButton(arg0_265, var1_267, var3_265, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3_267, arg1_265:getPainting())
		var1_265:SetActionCallBack(nil)

		var6_267.freeze = false

		var1_265:Dispose()
		setActive(var0_267, false)

		arg0_265.playing = false

		arg0_265:unfrozen()

		if arg3_265 then
			arg3_265()
		end
	end)

	local function var4_265()
		if arg0_265.strikeAnims[arg2_265] and var0_265 and var1_265 then
			var3_265()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1_265:getPainting(), true, function(arg0_273)
		var0_265 = arg0_273

		ShipExpressionHelper.SetExpression(var0_265, arg1_265:getPainting())
		var4_265()
	end)

	var1_265 = SpineAnimChar.New()

	var1_265:SetPaint(arg1_265:getPrefab())
	var1_265:Load(true, function(arg0_274)
		var1_265:SetLocalScale(Vector3.one)
		var4_265()
	end)

	if not arg0_265.strikeAnims[arg2_265] then
		PoolMgr.GetInstance():GetUI(arg2_265, true, function(arg0_275)
			arg0_265.strikeAnims[arg2_265] = arg0_275

			var4_265()
		end)
	end
end

function var0_0.destroyStrikeAnim(arg0_276)
	if arg0_276.strikeAnims then
		for iter0_276, iter1_276 in pairs(arg0_276.strikeAnims) do
			iter1_276:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0_276, iter1_276)
		end

		arg0_276.strikeAnims = nil
	end
end

function var0_0.doPlayEnemyAnim(arg0_277, arg1_277, arg2_277, arg3_277)
	arg0_277.strikeAnims = arg0_277.strikeAnims or {}

	local var0_277
	local var1_277

	local function var2_277()
		if coroutine.status(var1_277) == "suspended" then
			local var0_278, var1_278 = coroutine.resume(var1_277)

			assert(var0_278, debug.traceback(var1_277, var1_278))
		end
	end

	var1_277 = coroutine.create(function()
		arg0_277.playing = true

		arg0_277:frozen()

		local var0_279 = arg0_277.strikeAnims[arg2_277]

		setActive(var0_279, true)

		local var1_279 = tf(var0_279)
		local var2_279 = findTF(var1_279, "torpedo")
		local var3_279 = findTF(var1_279, "ship")

		var0_277:SetParent(var3_279)
		setActive(var3_279, false)
		setActive(var2_279, false)
		var1_279:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1_279:SetAsLastSibling()

		local var4_279 = var1_279:GetComponent("DftAniEvent")
		local var5_279 = var0_277:GetSkeletonGraphic()

		var4_279:SetStartEvent(function(arg0_280)
			var0_277:SetAction("attack", 0)

			var5_279.freeze = true
		end)
		var4_279:SetTriggerEvent(function(arg0_281)
			var5_279.freeze = false

			var0_277:SetActionCallBack(function(arg0_282)
				if arg0_282 == "action" then
					-- block empty
				elseif arg0_282 == "finish" then
					var5_279.freeze = true
				end
			end)
		end)
		var4_279:SetEndEvent(function(arg0_283)
			var5_279.freeze = false

			var2_277()
		end)
		onButton(arg0_277, var1_279, var2_277, SFX_CANCEL)
		coroutine.yield()
		var0_277:SetActionCallBack(nil)

		var5_279.freeze = false

		var0_277:Dispose()
		setActive(var0_279, false)

		arg0_277.playing = false

		arg0_277:unfrozen()

		if arg3_277 then
			arg3_277()
		end
	end)

	local function var3_277()
		if arg0_277.strikeAnims[arg2_277] and var0_277 then
			var2_277()
		end
	end

	var0_277 = SpineAnimChar.New()

	var0_277:SetPaint(arg1_277:getPrefab())
	var0_277:Load(true, function(arg0_285)
		arg0_285:SetLocalScale(Vector3.one)
		var3_277()
	end)

	if not arg0_277.strikeAnims[arg2_277] then
		PoolMgr.GetInstance():GetUI(arg2_277, true, function(arg0_286)
			arg0_277.strikeAnims[arg2_277] = arg0_286

			var3_277()
		end)
	end
end

function var0_0.doPlayCommander(arg0_287, arg1_287, arg2_287)
	arg0_287:frozen()
	setActive(arg0_287.commanderTinkle, true)

	local var0_287 = arg1_287:getSkills()

	setText(arg0_287.commanderTinkle:Find("name"), #var0_287 > 0 and var0_287[1]:getConfig("name") or "")
	setImageSprite(arg0_287.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1_287:getConfig("painting"), ""))

	local var1_287 = arg0_287.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1_287.alpha = 0

	local var2_287 = Vector2(248, 237)

	LeanTween.value(go(arg0_287.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_288)
		local var0_288 = arg0_287.commanderTinkle.localPosition

		var0_288.x = var2_287.x + -100 * (1 - arg0_288)
		arg0_287.commanderTinkle.localPosition = var0_288
		var1_287.alpha = arg0_288
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0_287.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0_289)
		local var0_289 = arg0_287.commanderTinkle.localPosition

		var0_289.x = var2_287.x + 100 * arg0_289
		arg0_287.commanderTinkle.localPosition = var0_289
		var1_287.alpha = 1 - arg0_289
	end)):setOnComplete(System.Action(function()
		if arg2_287 then
			arg2_287()
		end

		arg0_287:unfrozen()
	end))
end

function var0_0.strikeEnemy(arg0_291, arg1_291, arg2_291, arg3_291)
	local var0_291 = arg0_291.grid:shakeCell(arg1_291)

	if not var0_291 then
		arg3_291()

		return
	end

	arg0_291:easeDamage(var0_291, arg2_291, function()
		arg3_291()
	end)
end

function var0_0.easeDamage(arg0_293, arg1_293, arg2_293, arg3_293)
	arg0_293:frozen()

	local var0_293 = arg0_293.levelCam:WorldToScreenPoint(arg1_293.position)
	local var1_293 = tf(arg0_293:GetDamageText())

	var1_293.position = arg0_293.uiCam:ScreenToWorldPoint(var0_293)

	local var2_293 = var1_293.localPosition

	var2_293.y = var2_293.y + 40
	var2_293.z = 0

	setText(var1_293, arg2_293)

	var1_293.localPosition = var2_293

	LeanTween.value(go(var1_293), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_294)
		local var0_294 = var1_293.localPosition

		var0_294.y = var2_293.y + 60 * arg0_294
		var1_293.localPosition = var0_294

		setTextAlpha(var1_293, 1 - arg0_294)
	end)):setOnComplete(System.Action(function()
		arg0_293:ReturnDamageText(var1_293)
		arg0_293:unfrozen()

		if arg3_293 then
			arg3_293()
		end
	end))
end

function var0_0.easeAvoid(arg0_296, arg1_296, arg2_296)
	arg0_296:frozen()

	local var0_296 = arg0_296.levelCam:WorldToScreenPoint(arg1_296)

	arg0_296.avoidText.position = arg0_296.uiCam:ScreenToWorldPoint(var0_296)

	local var1_296 = arg0_296.avoidText.localPosition

	var1_296.z = 0
	arg0_296.avoidText.localPosition = var1_296

	setActive(arg0_296.avoidText, true)

	local var2_296 = arg0_296.avoidText:Find("avoid")

	LeanTween.value(go(arg0_296.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_297)
		local var0_297 = arg0_296.avoidText.localPosition

		var0_297.y = var1_296.y + 100 * arg0_297
		arg0_296.avoidText.localPosition = var0_297

		setImageAlpha(arg0_296.avoidText, 1 - arg0_297)
		setImageAlpha(var2_296, 1 - arg0_297)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_296.avoidText, false)
		arg0_296:unfrozen()

		if arg2_296 then
			arg2_296()
		end
	end))
end

function var0_0.GetDamageText(arg0_299)
	local var0_299 = table.remove(arg0_299.damageTextPool)

	if not var0_299 then
		var0_299 = Instantiate(arg0_299.damageTextTemplate)

		local var1_299 = tf(arg0_299.damageTextTemplate):GetSiblingIndex()

		setParent(var0_299, tf(arg0_299.damageTextTemplate).parent)
		tf(var0_299):SetSiblingIndex(var1_299 + 1)
	end

	table.insert(arg0_299.damageTextActive, var0_299)
	setActive(var0_299, true)

	return var0_299
end

function var0_0.ReturnDamageText(arg0_300, arg1_300)
	assert(arg1_300)

	if not arg1_300 then
		return
	end

	arg1_300 = go(arg1_300)

	table.removebyvalue(arg0_300.damageTextActive, arg1_300)
	table.insert(arg0_300.damageTextPool, arg1_300)
	setActive(arg1_300, false)
end

function var0_0.resetLevelGrid(arg0_301)
	arg0_301.dragLayer.localPosition = Vector3.zero
end

function var0_0.ShowCurtains(arg0_302, arg1_302)
	setActive(arg0_302.curtain, arg1_302)
end

function var0_0.frozen(arg0_303)
	local var0_303 = arg0_303.frozenCount

	arg0_303.frozenCount = arg0_303.frozenCount + 1
	arg0_303.canvasGroup.blocksRaycasts = arg0_303.frozenCount == 0

	if var0_303 == 0 and arg0_303.frozenCount ~= 0 then
		arg0_303:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0_0.unfrozen(arg0_304, arg1_304)
	if arg0_304.exited then
		return
	end

	local var0_304 = arg0_304.frozenCount
	local var1_304 = arg1_304 == -1 and arg0_304.frozenCount or arg1_304 or 1

	arg0_304.frozenCount = arg0_304.frozenCount - var1_304
	arg0_304.canvasGroup.blocksRaycasts = arg0_304.frozenCount == 0

	if var0_304 ~= 0 and arg0_304.frozenCount == 0 then
		arg0_304:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0_0.isfrozen(arg0_305)
	return arg0_305.frozenCount > 0
end

function var0_0.enableLevelCamera(arg0_306)
	arg0_306.levelCamIndices = math.max(arg0_306.levelCamIndices - 1, 0)

	if arg0_306.levelCamIndices == 0 then
		arg0_306.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.disableLevelCamera(arg0_307)
	arg0_307.levelCamIndices = arg0_307.levelCamIndices + 1

	if arg0_307.levelCamIndices > 0 then
		arg0_307.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():CreateRefreshHandler()
	end
end

function var0_0.RecordTween(arg0_308, arg1_308, arg2_308)
	arg0_308.tweens[arg1_308] = arg2_308
end

function var0_0.DeleteTween(arg0_309, arg1_309)
	local var0_309 = arg0_309.tweens[arg1_309]

	if var0_309 then
		LeanTween.cancel(var0_309)

		arg0_309.tweens[arg1_309] = nil
	end
end

function var0_0.openCommanderPanel(arg0_310, arg1_310, arg2_310, arg3_310)
	local var0_310 = arg2_310.id

	arg0_310.levelCMDFormationView:setCallback(function(arg0_311)
		if not arg3_310 then
			if arg0_311.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0_310:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_311.skill)
			elseif arg0_311.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0_310.contextData.commanderSelected = {
					chapterId = var0_310,
					fleetId = arg1_310.id
				}

				arg0_310:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0_311.pos, arg1_310.id, arg2_310)
				arg0_310:closeCommanderPanel()
			else
				arg0_310:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0_311,
					fleetId = arg1_310.id,
					chapterId = var0_310
				}, arg2_310)
			end
		elseif arg0_311.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_310:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0_311.skill)
		elseif arg0_311.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_310.contextData.eliteCommanderSelected = {
				index = arg3_310,
				pos = arg0_311.pos,
				chapterId = var0_310
			}

			arg0_310:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3_310, arg0_311.pos, arg2_310)
			arg0_310:closeCommanderPanel()
		else
			arg0_310:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0_311,
				index = arg3_310,
				chapterId = var0_310
			}, arg2_310)
		end
	end)
	arg0_310.levelCMDFormationView:Load()
	arg0_310.levelCMDFormationView:ActionInvoke("update", arg1_310, arg0_310.commanderPrefabs)
	arg0_310.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderPrefab(arg0_312)
	if arg0_312.levelCMDFormationView:isShowing() then
		arg0_312.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_312.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_313)
	arg0_313.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.destroyCommanderPanel(arg0_314)
	arg0_314.levelCMDFormationView:Destroy()

	arg0_314.levelCMDFormationView = nil
end

function var0_0.setSpecialOperationTickets(arg0_315, arg1_315)
	arg0_315.spTickets = arg1_315
end

function var0_0.HandleShowMsgBox(arg0_316, arg1_316)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_316)
end

function var0_0.updatePoisonAreaTip(arg0_317)
	local var0_317 = arg0_317.contextData.chapterVO
	local var1_317 = (function(arg0_318)
		local var0_318 = {}
		local var1_318 = pg.map_event_list[var0_317.id] or {}
		local var2_318

		if var0_317:isLoop() then
			var2_318 = var1_318.event_list_loop or {}
		else
			var2_318 = var1_318.event_list or {}
		end

		for iter0_318, iter1_318 in ipairs(var2_318) do
			local var3_318 = pg.map_event_template[iter1_318]

			if var3_318.c_type == arg0_318 then
				table.insert(var0_318, var3_318)
			end
		end

		return var0_318
	end)(ChapterConst.EvtType_Poison)

	if var1_317 then
		for iter0_317, iter1_317 in ipairs(var1_317) do
			local var2_317 = iter1_317.round_gametip

			if var2_317 ~= nil and var2_317 ~= "" and var0_317:getRoundNum() == var2_317[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_317[2]))
			end
		end
	end
end

function var0_0.updateVoteBookBtn(arg0_319)
	setActive(arg0_319._voteBookBtn, false)
end

function var0_0.RecordLastMapOnExit(arg0_320)
	local var0_320 = getProxy(ChapterProxy)

	if var0_320 and not arg0_320.contextData.noRecord then
		local var1_320 = arg0_320.contextData.map

		if not var1_320 then
			return
		end

		if var1_320:NeedRecordMap() then
			var0_320:recordLastMap(ChapterProxy.LAST_MAP, var1_320.id)
		end

		if var1_320:isActivity() and not var1_320:isActExtra() then
			var0_320:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, var1_320.id)
		end
	end
end

function var0_0.IsActShopActive(arg0_321)
	local var0_321 = arg0_321.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_321.contextData.map:getConfig("on_activity")) or nil
	local var1_321 = var0_321 and not var0_321:isEnd() and var0_321:GetConfigClientSetting("PTID")
	local var2_321 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var2_321 and not var2_321:isEnd() and var2_321:getConfig("config_client").resId == var1_321 then
		return true
	end

	if _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_322)
		return not arg0_322:isEnd() and arg0_322:getConfig("config_client").pt_id == var1_321
	end) then
		return true
	end
end

function var0_0.willExit(arg0_323)
	arg0_323:ClearMapTransitions()
	arg0_323.loader:Clear()

	if arg0_323.contextData.chapterVO then
		arg0_323:UnOverlayPanel(arg0_323.topPanel, arg0_323._tf)
	end

	if arg0_323.levelFleetView and arg0_323.levelFleetView.selectIds then
		arg0_323.contextData.selectedFleetIDs = {}

		for iter0_323, iter1_323 in pairs(arg0_323.levelFleetView.selectIds) do
			for iter2_323, iter3_323 in pairs(iter1_323) do
				arg0_323.contextData.selectedFleetIDs[#arg0_323.contextData.selectedFleetIDs + 1] = iter3_323
			end
		end
	end

	arg0_323:destroyChapterPanel()
	arg0_323:DestroyLevelInfoSPPanel()
	arg0_323:destroyFleetEdit()
	arg0_323:destroyCommanderPanel()
	arg0_323:DestroyLevelStageView()
	arg0_323:hideRepairWindow()
	arg0_323:hideStrategyInfo()
	arg0_323:hideRemasterPanel()
	arg0_323:hideSpResult()
	arg0_323:destroyGrid()
	arg0_323:destroyAmbushWarn()
	arg0_323:destroyAirStrike()
	arg0_323:destroyTorpedo()
	arg0_323:destroyStrikeAnim()
	arg0_323:destroyTracking()
	arg0_323:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4_323, iter5_323 in pairs(arg0_323.mbDict) do
		iter5_323:Destroy()
	end

	arg0_323.mbDict = nil

	for iter6_323, iter7_323 in pairs(arg0_323.tweens) do
		LeanTween.cancel(iter7_323)
	end

	arg0_323.tweens = nil

	if arg0_323.cloudTimer then
		_.each(arg0_323.cloudTimer, function(arg0_324)
			LeanTween.cancel(arg0_324)
		end)

		arg0_323.cloudTimer = nil
	end

	if arg0_323.newChapterCDTimer then
		arg0_323.newChapterCDTimer:Stop()

		arg0_323.newChapterCDTimer = nil
	end

	for iter8_323, iter9_323 in ipairs(arg0_323.damageTextActive) do
		LeanTween.cancel(iter9_323)
	end

	LeanTween.cancel(go(arg0_323.avoidText))

	arg0_323.map.localScale = Vector3.one
	arg0_323.map.pivot = Vector2(0.5, 0.5)
	arg0_323.float.localScale = Vector3.one
	arg0_323.float.pivot = Vector2(0.5, 0.5)

	for iter10_323, iter11_323 in ipairs(arg0_323.mapTFs) do
		clearImageSprite(iter11_323)
	end

	_.each(arg0_323.cloudRTFs, function(arg0_325)
		clearImageSprite(arg0_325)
	end)
	Destroy(arg0_323.enemyTpl)
	arg0_323:RecordLastMapOnExit()
	arg0_323.levelRemasterView:Destroy()
end

return var0_0
