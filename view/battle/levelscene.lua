local var0 = class("LevelScene", import("..base.BaseUI"))
local var1 = 0.5
local var2 = 1
local var3 = 2
local var4 = 3

function var0.forceGC(arg0)
	return true
end

function var0.getUIName(arg0)
	return "LevelMainScene"
end

function var0.ResUISettings(arg0)
	return {
		showType = PlayerResUI.TYPE_ALL,
		groupName = LayerWeightConst.GROUP_LEVELUI
	}
end

function var0.getBGM(arg0)
	local function var0()
		return checkExist(arg0.contextData.chapterVO, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	local function var1()
		if not arg0.contextData.map then
			return
		end

		local var0 = arg0.contextData.map:getConfig("ani_controller")

		if var0 and #var0 > 0 then
			for iter0, iter1 in ipairs(var0) do
				local var1 = _.rest(iter1[2], 2)

				for iter2, iter3 in ipairs(var1) do
					if string.find(iter3, "^bgm_") and iter1[1] == var3 then
						local var2 = iter1[2][1]
						local var3 = getProxy(ChapterProxy):GetChapterItemById(var2)

						if var3 and not var3:isClear() then
							return string.sub(iter3, 5)
						end
					end
				end
			end
		end

		return checkExist(arg0.contextData.map, {
			"getConfig",
			{
				"bgm"
			}
		}) or ""
	end

	for iter0, iter1 in ipairs({
		var0(),
		var1()
	}) do
		if iter1 ~= "" then
			return iter1
		end
	end

	return var0.super.getBGM(arg0)
end

var0.optionsPath = {
	"top/top_chapter/option"
}

function var0.preload(arg0, arg1)
	local var0 = getProxy(ChapterProxy)

	if arg0.contextData.mapIdx and arg0.contextData.chapterId then
		local var1 = var0:getChapterById(arg0.contextData.chapterId)

		if var1:getConfig("map") == arg0.contextData.mapIdx then
			arg0.contextData.chapterVO = var1

			if var1.active then
				assert(not arg0.contextData.openChapterId or arg0.contextData.openChapterId == arg0.contextData.chapterId)

				arg0.contextData.openChapterId = nil
			end
		end
	end

	local var2, var3 = arg0:GetInitializeMap()

	if arg0.contextData.entranceStatus == nil then
		arg0.contextData.entranceStatus = not var3
	end

	if not arg0.contextData.entranceStatus then
		arg0:PreloadLevelMainUI(var2, arg1)
	else
		arg1()
	end
end

function var0.GetInitializeMap(arg0)
	local var0 = (function()
		local var0 = arg0.contextData.chapterVO

		if var0 and var0.active then
			return var0:getConfig("map")
		end

		local var1 = arg0.contextData.mapIdx

		if var1 then
			return var1
		end

		local var2

		if arg0.contextData.targetChapter and arg0.contextData.targetMap then
			arg0.contextData.openChapterId = arg0.contextData.targetChapter
			var2 = arg0.contextData.targetMap.id
			arg0.contextData.targetChapter = nil
			arg0.contextData.targetMap = nil
		elseif arg0.contextData.eliteDefault then
			local var3 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			var2 = var3 and var3.id or nil
			arg0.contextData.eliteDefault = nil
		end

		return var2
	end)()
	local var1 = var0 and getProxy(ChapterProxy):getMapById(var0)

	if var1 then
		local var2, var3 = var1:isUnlock()

		if not var2 then
			pg.TipsMgr.GetInstance():ShowTips(var3)

			var0 = getProxy(ChapterProxy):getLastUnlockMap().id
			arg0.contextData.mapIdx = var0
		end
	else
		var0 = nil
	end

	return var0 or arg0:selectMap(), tobool(var0)
end

function var0.init(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:initEvents()
	arg0:updateClouds()
end

function var0.initData(arg0)
	arg0.tweens = {}
	arg0.mapWidth = 1920
	arg0.mapHeight = 1440
	arg0.levelCamIndices = 1
	arg0.frozenCount = 0
	arg0.currentBG = nil
	arg0.mapBuilder = nil
	arg0.mbDict = {}
	arg0.mapGroup = {}

	if not arg0.contextData.huntingRangeVisibility then
		arg0.contextData.huntingRangeVisibility = 2
	end
end

function var0.initUI(arg0)
	arg0.topPanel = arg0:findTF("top")
	arg0.canvasGroup = arg0.topPanel:GetComponent("CanvasGroup")
	arg0.canvasGroup.blocksRaycasts = not arg0.canvasGroup.blocksRaycasts
	arg0.canvasGroup.blocksRaycasts = not arg0.canvasGroup.blocksRaycasts
	arg0.entranceLayer = arg0:findTF("entrance")
	arg0.ptBonus = EventPtBonus.New(arg0.entranceLayer:Find("btns/btn_task/bonusPt"))
	arg0.entranceBg = arg0:findTF("entrance_bg")
	arg0.topChapter = arg0:findTF("top_chapter", arg0.topPanel)

	setActive(arg0.topChapter:Find("title_chapter"), false)
	setActive(arg0.topChapter:Find("type_chapter"), false)
	setActive(arg0.topChapter:Find("type_escort"), false)
	setActive(arg0.topChapter:Find("type_skirmish"), false)

	arg0.chapterName = arg0:findTF("title_chapter/name", arg0.topChapter)
	arg0.chapterNoTitle = arg0:findTF("title_chapter/chapter", arg0.topChapter)
	arg0.resChapter = arg0:findTF("resources", arg0.topChapter)

	setActive(arg0.topChapter, true)

	arg0._voteBookBtn = arg0.topChapter:Find("vote_book")
	arg0.leftChapter = arg0:findTF("main/left_chapter")

	setActive(arg0.leftChapter, true)

	arg0.leftCanvasGroup = arg0.leftChapter:GetComponent(typeof(CanvasGroup))
	arg0.btnPrev = arg0:findTF("btn_prev", arg0.leftChapter)
	arg0.btnPrevCol = arg0:findTF("btn_prev/prev_image", arg0.leftChapter)
	arg0.eliteBtn = arg0:findTF("buttons/btn_elite", arg0.leftChapter)
	arg0.normalBtn = arg0:findTF("buttons/btn_normal", arg0.leftChapter)
	arg0.actNormalBtn = arg0:findTF("buttons/btn_act_normal", arg0.leftChapter)

	setActive(arg0.actNormalBtn, false)

	arg0.actEliteBtn = arg0:findTF("buttons/btn_act_elite", arg0.leftChapter)

	setActive(arg0.actEliteBtn, false)

	arg0.actExtraBtn = arg0:findTF("buttons/btn_act_extra", arg0.leftChapter)
	arg0.actExtraBtnAnim = arg0:findTF("usm", arg0.actExtraBtn)
	arg0.remasterBtn = arg0:findTF("buttons/btn_remaster", arg0.leftChapter)
	arg0.escortBar = arg0:findTF("escort_bar", arg0.leftChapter)

	setActive(arg0.escortBar, false)

	arg0.eliteQuota = arg0:findTF("elite_quota", arg0.leftChapter)

	setActive(arg0.eliteQuota, false)

	arg0.skirmishBar = arg0:findTF("left_times", arg0.leftChapter)
	arg0.mainLayer = arg0:findTF("main")

	setActive(arg0.mainLayer:Find("title_chapter_lines"), false)

	arg0.rightChapter = arg0:findTF("main/right_chapter")
	arg0.rightCanvasGroup = arg0.rightChapter:GetComponent(typeof(CanvasGroup))
	arg0.eventContainer = arg0:findTF("event_btns/event_container", arg0.rightChapter)
	arg0.btnSpecial = arg0:findTF("btn_task", arg0.eventContainer)
	arg0.challengeBtn = arg0:findTF("btn_challenge", arg0.eventContainer)
	arg0.dailyBtn = arg0:findTF("btn_daily", arg0.eventContainer)
	arg0.militaryExerciseBtn = arg0:findTF("btn_pvp", arg0.eventContainer)
	arg0.activityBtn = arg0:findTF("event_btns/activity_btn", arg0.rightChapter)
	arg0.ptTotal = arg0:findTF("event_btns/pt_text", arg0.rightChapter)
	arg0.ticketTxt = arg0:findTF("event_btns/tickets/Text", arg0.rightChapter)
	arg0.remasterAwardBtn = arg0:findTF("btn_remaster_award", arg0.rightChapter)
	arg0.btnNext = arg0:findTF("btn_next", arg0.rightChapter)
	arg0.btnNextCol = arg0:findTF("btn_next/next_image", arg0.rightChapter)
	arg0.countDown = arg0:findTF("event_btns/count_down", arg0.rightChapter)

	setActive(arg0:findTF("event_btns/BottomList", arg0.rightChapter), true)

	arg0.actExchangeShopBtn = arg0:findTF("event_btns/BottomList/btn_exchange", arg0.rightChapter)
	arg0.actAtelierBuffBtn = arg0:findTF("event_btns/BottomList/btn_control_center", arg0.rightChapter)
	arg0.actExtraRank = arg0:findTF("event_btns/BottomList/act_extra_rank", arg0.rightChapter)

	setActive(arg0.rightChapter, true)
	setActive(arg0.remasterAwardBtn, false)

	arg0.damageTextTemplate = go(arg0:findTF("damage", arg0.topPanel))

	setActive(arg0.damageTextTemplate, false)

	arg0.damageTextPool = {
		arg0.damageTextTemplate
	}
	arg0.damageTextActive = {}
	arg0.mapHelpBtn = arg0:findTF("help_button", arg0.topPanel)

	setActive(arg0.mapHelpBtn, false)

	arg0.avoidText = arg0:findTF("text_avoid", arg0.topPanel)
	arg0.commanderTinkle = arg0:findTF("neko_tinkle", arg0.topPanel)

	setActive(arg0.commanderTinkle, false)

	arg0.spResult = arg0:findTF("sp_result", arg0.topPanel)

	setActive(arg0.spResult, false)

	arg0.helpPage = arg0:findTF("help_page", arg0.topPanel)
	arg0.helpImage = arg0:findTF("icon", arg0.helpPage)

	setActive(arg0.helpPage, false)

	arg0.curtain = arg0:findTF("curtain", arg0.topPanel)

	setActive(arg0.curtain, false)

	arg0.map = arg0:findTF("maps")
	arg0.mapTFs = {
		arg0:findTF("maps/map1"),
		arg0:findTF("maps/map2")
	}

	for iter0, iter1 in ipairs(arg0.mapTFs) do
		iter1:GetComponent(typeof(Image)).enabled = false
	end

	local var0 = arg0.map:GetComponent(typeof(AspectRatioFitter))

	var0.aspectRatio, var0.aspectRatio = var0.aspectRatio, 1
	arg0.UIFXList = arg0:findTF("maps/UI_FX_list")

	local var1 = arg0.UIFXList:GetComponentsInChildren(typeof(Renderer))

	for iter2 = 0, var1.Length - 1 do
		var1[iter2].sortingOrder = -1
	end

	local var2 = pg.UIMgr.GetInstance()

	arg0.levelCam = var2.levelCamera:GetComponent(typeof(Camera))
	arg0.uiMain = var2.LevelMain

	setActive(arg0.uiMain, false)

	arg0.uiCam = var2.uiCamera:GetComponent(typeof(Camera))
	arg0.levelGrid = arg0.uiMain:Find("LevelGrid")

	setActive(arg0.levelGrid, true)

	arg0.dragLayer = arg0.levelGrid:Find("DragLayer")
	arg0.float = arg0:findTF("float")
	arg0.clouds = arg0:findTF("clouds", arg0.float)

	setActive(arg0.clouds, true)
	setActive(arg0.float:Find("levels"), false)

	arg0.resources = arg0:findTF("resources"):GetComponent("ItemList")
	arg0.arrowTarget = arg0.resources.prefabItem[0]
	arg0.destinationMarkTpl = arg0.resources.prefabItem[1]
	arg0.championTpl = arg0.resources.prefabItem[3]
	arg0.deadTpl = arg0.resources.prefabItem[4]
	arg0.enemyTpl = Instantiate(arg0.resources.prefabItem[5])
	arg0.oniTpl = arg0.resources.prefabItem[6]
	arg0.shipTpl = arg0.resources.prefabItem[8]
	arg0.subTpl = arg0.resources.prefabItem[9]
	arg0.transportTpl = arg0.resources.prefabItem[11]

	setText(arg0:findTF("fighting/Text", arg0.enemyTpl), i18n("ui_word_levelui2_inevent"))
	setAnchoredPosition(arg0.topChapter, {
		y = 0
	})
	setAnchoredPosition(arg0.leftChapter, {
		x = 0
	})
	setAnchoredPosition(arg0.rightChapter, {
		x = 0
	})

	arg0.bubbleMsgBoxes = {}
	arg0.loader = AutoLoader.New()
	arg0.levelFleetView = LevelFleetView.New(arg0.topPanel, arg0.event, arg0.contextData)
	arg0.levelInfoView = LevelInfoView.New(arg0.topPanel, arg0.event, arg0.contextData)

	arg0:buildCommanderPanel()

	arg0.levelRemasterView = LevelRemasterView.New(arg0.topPanel, arg0.event, arg0.contextData)
end

function var0.initEvents(arg0)
	arg0:bind(LevelUIConst.OPEN_COMMANDER_PANEL, function(arg0, arg1, arg2, arg3)
		arg0:openCommanderPanel(arg1, arg2, arg3)
	end)
	arg0:bind(LevelUIConst.HANDLE_SHOW_MSG_BOX, function(arg0, arg1)
		arg0:HandleShowMsgBox(arg1)
	end)
	arg0:bind(LevelUIConst.DO_AMBUSH_WARNING, function(arg0, arg1)
		arg0:doAmbushWarning(arg1)
	end)
	arg0:bind(LevelUIConst.DISPLAY_AMBUSH_INFO, function(arg0, arg1)
		arg0:displayAmbushInfo(arg1)
	end)
	arg0:bind(LevelUIConst.DISPLAY_STRATEGY_INFO, function(arg0, arg1)
		arg0:displayStrategyInfo(arg1)
	end)
	arg0:bind(LevelUIConst.FROZEN, function(arg0)
		arg0:frozen()
	end)
	arg0:bind(LevelUIConst.UN_FROZEN, function(arg0)
		arg0:unfrozen()
	end)
	arg0:bind(LevelUIConst.DO_TRACKING, function(arg0, arg1)
		arg0:doTracking(arg1)
	end)
	arg0:bind(LevelUIConst.SWITCH_TO_MAP, function()
		if arg0:isfrozen() then
			return
		end

		arg0:switchToMap()
	end)
	arg0:bind(LevelUIConst.DISPLAY_REPAIR_WINDOW, function(arg0, arg1)
		arg0:displayRepairWindow(arg1)
	end)
	arg0:bind(LevelUIConst.DO_PLAY_ANIM, function(arg0, arg1)
		arg0:doPlayAnim(arg1.name, arg1.callback, arg1.onStart)
	end)
	arg0:bind(LevelUIConst.HIDE_FLEET_SELECT, function()
		arg0:hideFleetSelect()
	end)
	arg0:bind(LevelUIConst.HIDE_FLEET_EDIT, function(arg0)
		arg0:hideFleetEdit()
	end)
	arg0:bind(LevelUIConst.ADD_MSG_QUEUE, function(arg0, arg1)
		arg0:addbubbleMsgBox(arg1)
	end)
	arg0:bind(LevelUIConst.SET_MAP, function(arg0, arg1)
		arg0:setMap(arg1)
	end)
end

function var0.addbubbleMsgBox(arg0, arg1)
	table.insert(arg0.bubbleMsgBoxes, arg1)

	if #arg0.bubbleMsgBoxes > 1 then
		return
	end

	local var0

	local function var1()
		local var0 = arg0.bubbleMsgBoxes[1]

		if var0 then
			var0(function()
				table.remove(arg0.bubbleMsgBoxes, 1)
				var1()
			end)
		end
	end

	var1()
end

function var0.CleanBubbleMsgbox(arg0)
	table.clean(arg0.bubbleMsgBoxes)
end

function var0.updatePtActivity(arg0, arg1)
	arg0.ptActivity = arg1

	arg0:updateActivityRes()
end

function var0.updateActivityRes(arg0)
	local var0 = findTF(arg0.ptTotal, "Text")
	local var1 = findTF(arg0.ptTotal, "icon/Image")

	if var0 and var1 and arg0.ptActivity then
		setText(var0, "x" .. arg0.ptActivity.data1)
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = tonumber(arg0.ptActivity:getConfig("config_id"))
		}):getIcon(), "", var1, true)
	end
end

function var0.setCommanderPrefabs(arg0, arg1)
	arg0.commanderPrefabs = arg1
end

function var0.didEnter(arg0)
	arg0.openedCommanerSystem = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "CommanderCatMediator")

	onButton(arg0, arg0:findTF("back_button", arg0.topChapter), function()
		if arg0:isfrozen() then
			return
		end

		local var0 = arg0.contextData.map

		if var0 and (var0:isActivity() or var0:isEscort()) then
			arg0:emit(LevelMediator2.ON_SWITCH_NORMAL_MAP)

			return
		elseif var0 and var0:isSkirmish() then
			arg0:emit(var0.ON_BACK)
		elseif not arg0.contextData.entranceStatus then
			arg0:ShowEntranceUI(true)
		else
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnSpecial, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	onButton(arg0, arg0.dailyBtn, function()
		if arg0:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0:updatDailyBtnTip()
		arg0:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0, arg0.challengeBtn, function()
		if arg0:isfrozen() then
			return
		end

		local var0, var1 = arg0:checkChallengeOpen()

		if var0 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1)
		else
			arg0:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.militaryExerciseBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0, arg0.normalBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:setMap(arg0.contextData.map:getBindMapId())
	end, SFX_PANEL)
	onButton(arg0, arg0.eliteBtn, function()
		if arg0:isfrozen() then
			return
		end

		if arg0.contextData.map:getBindMapId() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

			local var0 = getProxy(ChapterProxy):getUseableMaxEliteMap()

			if var0 then
				arg0:setMap(var0.configId)
				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_warp_to_latest_map"))
			end
		elseif arg0.contextData.map:isEliteEnabled() then
			arg0:setMap(arg0.contextData.map:getBindMapId())
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unsatisfied"))
		end
	end, SFX_UI_WEIGHANCHOR_HARD)
	onButton(arg0, arg0.remasterBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0:updateRemasterBtnTip()
	end, SFX_PANEL)
	onButton(arg0, arg0.entranceLayer:Find("enters/enter_main"), function()
		if arg0:isfrozen() then
			return
		end

		arg0:ShowSelectedMap(arg0:GetInitializeMap())
	end, SFX_PANEL)
	setText(arg0.entranceLayer:Find("enters/enter_main/Text"), getProxy(ChapterProxy):getLastUnlockMap():getLastUnlockChapterName())
	onButton(arg0, arg0.entranceLayer:Find("enters/enter_world/enter"), function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ENTER_WORLD)
	end, SFX_PANEL)
	onButton(arg0, arg0.entranceLayer:Find("enters/enter_ready/activity"), function()
		if arg0:isfrozen() then
			return
		end

		local var0 = getProxy(ActivityProxy):getEnterReadyActivity()

		switch(var0:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0:emit(LevelMediator2.ON_ACTIVITY_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
				arg0:emit(LevelMediator2.ON_OPEN_ACT_BOSS_BATTLE)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
				arg0:emit(LevelMediator2.ON_BOSSRUSH_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
				arg0:emit(LevelMediator2.ON_BOSSSINGLE_MAP, {
					mode = OtherworldMapScene.MODE_BATTLE
				})
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.entranceLayer:Find("btns/btn_remaster"), function()
		if arg0:isfrozen() then
			return
		end

		arg0:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		arg0:updateRemasterBtnTip()
	end, SFX_PANEL)
	setActive(arg0.entranceLayer:Find("btns/btn_remaster"), OPEN_REMASTER)
	onButton(arg0, arg0.entranceLayer:Find("btns/btn_challenge"), function()
		if arg0:isfrozen() then
			return
		end

		local var0, var1 = arg0:checkChallengeOpen()

		if var0 == false then
			pg.TipsMgr.GetInstance():ShowTips(var1)
		else
			arg0:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.entranceLayer:Find("btns/btn_pvp"), function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(arg0, arg0.entranceLayer:Find("btns/btn_daily"), function()
		if arg0:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		arg0:updatDailyBtnTip()
		arg0:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(arg0, arg0.entranceLayer:Find("btns/btn_task"), function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	setActive(arg0.entranceLayer:Find("enters/enter_world/enter"), not WORLD_ENTER_LOCK)
	setActive(arg0.entranceLayer:Find("enters/enter_world/nothing"), WORLD_ENTER_LOCK)

	local var0 = getProxy(ActivityProxy):getEnterReadyActivity()

	setActive(arg0.entranceLayer:Find("enters/enter_ready/nothing"), not tobool(var0))
	setActive(arg0.entranceLayer:Find("enters/enter_ready/activity"), tobool(var0))

	if tobool(var0) then
		local var1 = var0:getConfig("config_client").entrance_bg

		if var1 then
			GetImageSpriteFromAtlasAsync(var1, "", arg0.entranceLayer:Find("enters/enter_ready/activity"), true)
		end
	end

	local var2 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "EventMediator")

	setActive(arg0.btnSpecial:Find("lock"), not var2)
	setActive(arg0.entranceLayer:Find("btns/btn_task/lock"), not var2)

	local var3 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "DailyLevelMediator")

	setActive(arg0.dailyBtn:Find("lock"), not var3)
	setActive(arg0.entranceLayer:Find("btns/btn_daily/lock"), not var3)

	local var4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "MilitaryExerciseMediator")

	setActive(arg0.militaryExerciseBtn:Find("lock"), not var4)
	setActive(arg0.entranceLayer:Find("btns/btn_pvp/lock"), not var4)

	local var5 = LimitChallengeConst.IsOpen()

	setActive(arg0.challengeBtn:Find("lock"), not var5)
	setActive(arg0.entranceLayer:Find("btns/btn_challenge/lock"), not var5)

	local var6 = LimitChallengeConst.IsInAct()

	setActive(arg0.challengeBtn, var6)
	setActive(arg0.entranceLayer:Find("btns/btn_challenge"), var6)

	local var7 = LimitChallengeConst.IsShowRedPoint()

	setActive(arg0.entranceLayer:Find("btns/btn_challenge/tip"), var7)
	arg0:initMapBtn(arg0.btnPrev, -1)
	arg0:initMapBtn(arg0.btnNext, 1)

	if arg0.contextData.editEliteChapter then
		local var8 = getProxy(ChapterProxy):getChapterById(arg0.contextData.editEliteChapter)

		arg0:displayFleetEdit(var8)

		arg0.contextData.editEliteChapter = nil
	elseif arg0.contextData.selectedChapterVO then
		arg0:displayFleetSelect(arg0.contextData.selectedChapterVO)

		arg0.contextData.selectedChapterVO = nil
	end

	local var9 = arg0.contextData.chapterVO

	if not var9 or not var9.active then
		arg0:tryPlaySubGuide()
	end

	arg0:updateRemasterBtnTip()
	arg0:updatDailyBtnTip()

	if arg0.contextData.open_remaster then
		arg0:displayRemasterPanel(arg0.contextData.isSP)

		arg0.contextData.open_remaster = nil
	end

	arg0:ShowEntranceUI(arg0.contextData.entranceStatus)

	if not arg0.contextData.entranceStatus then
		arg0:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg0:GetInitializeMap())
	end

	arg0:emit(LevelMediator2.ON_DIDENTER)
end

function var0.checkChallengeOpen(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().level

	return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0, "ChallengeMainMediator")
end

function var0.tryPlaySubGuide(arg0)
	if arg0.contextData.map and arg0.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(arg0)
end

function var0.onBackPressed(arg0)
	if arg0:isfrozen() then
		return
	end

	if arg0.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0.levelInfoView:isShowing() then
		arg0:hideChapterPanel()

		return
	end

	if arg0.levelFleetView:isShowing() then
		arg0:hideFleetEdit()

		return
	end

	if arg0.levelStrategyView then
		arg0:hideStrategyInfo()

		return
	end

	if arg0.levelRepairView then
		arg0:hideRepairWindow()

		return
	end

	if arg0.levelRemasterView:isShowing() then
		arg0:hideRemasterPanel()

		return
	end

	if isActive(arg0.helpPage) then
		setActive(arg0.helpPage, false)

		return
	end

	local var0 = arg0.contextData.chapterVO
	local var1 = getProxy(ChapterProxy):getActiveChapter()

	if var0 and var1 then
		arg0:switchToMap()

		return
	end

	triggerButton(arg0:findTF("back_button", arg0.topChapter))
end

function var0.ShowEntranceUI(arg0, arg1)
	setActive(arg0.entranceLayer, arg1)
	setActive(arg0.entranceBg, arg1)
	setActive(arg0.map, not arg1)
	setActive(arg0.float, not arg1)
	setActive(arg0.mainLayer, not arg1)
	setActive(arg0.topChapter:Find("type_entrance"), arg1)

	arg0.contextData.entranceStatus = tobool(arg1)

	if arg1 then
		setActive(arg0.topChapter:Find("title_chapter"), false)
		setActive(arg0.topChapter:Find("type_chapter"), false)
		setActive(arg0.topChapter:Find("type_escort"), false)
		setActive(arg0.topChapter:Find("type_skirmish"), false)

		if arg0.newChapterCDTimer then
			arg0.newChapterCDTimer:Stop()

			arg0.newChapterCDTimer = nil
		end

		arg0:RecordLastMapOnExit()

		arg0.contextData.mapIdx = nil
		arg0.contextData.map = nil
	end

	arg0:PlayBGM()
end

function var0.PreloadLevelMainUI(arg0, arg1, arg2)
	if arg0.preloadLevelDone then
		existCall(arg2)

		return
	end

	local var0

	local function var1()
		if not arg0.exited then
			arg0.preloadLevelDone = true

			existCall(arg2)
		end
	end

	local var2 = getProxy(ChapterProxy):getMapById(arg1)
	local var3 = arg0:GetMapBG(var2)

	table.ParallelIpairsAsync(var3, function(arg0, arg1, arg2)
		GetSpriteFromAtlasAsync("levelmap/" .. arg1.BG, "", arg2)
	end, var1)
end

function var0.selectMap(arg0)
	local var0 = arg0.contextData.mapIdx

	if not var0 then
		local var1 = getProxy(ChapterProxy)
		local var2 = Map.lastMap and var1:getMapById(Map.lastMap)

		if var2 and var2:isUnlock() then
			var0 = Map.lastMap
		else
			var0 = var1:getLastUnlockMap().id
		end
	end

	return var0
end

function var0.setShips(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.updateRes(arg0, arg1)
	if arg0.levelStageView then
		arg0.levelStageView:ActionInvoke("SetPlayer", arg1)
	end

	arg0.player = arg1
end

function var0.setEliteQuota(arg0, arg1, arg2)
	local var0 = arg2 - arg1
	local var1 = arg0:findTF("bg/Text", arg0.eliteQuota):GetComponent(typeof(Text))

	if arg1 == arg2 then
		var1.color = Color.red
	else
		var1.color = Color.New(0.47, 0.89, 0.27)
	end

	var1.text = var0 .. "/" .. arg2
end

function var0.updateEvent(arg0, arg1)
	local var0 = arg1:hasFinishState()

	setActive(arg0.btnSpecial:Find("tip"), var0)
	setActive(arg0.entranceLayer:Find("btns/btn_task/tip"), var0)
end

function var0.updateFleet(arg0, arg1)
	arg0.fleets = arg1
end

function var0.updateChapterVO(arg0, arg1, arg2)
	local var0 = arg1:getConfig("map")

	if not arg0.contextData.chapterVO and arg0.contextData.mapIdx == var0 and bit.band(arg2, ChapterConst.DirtyMapItems) > 0 then
		arg0:updateMapItems()
	end

	if arg0.contextData.chapterVO and arg0.contextData.chapterVO.id == arg1.id and arg1.active then
		arg0:setChapter(arg1)
	end

	if arg0.contextData.chapterVO and arg0.contextData.chapterVO.id == arg1.id and arg1.active and arg0.levelStageView and arg0.grid then
		local var1 = false
		local var2 = false
		local var3 = false

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyFleet) > 0 then
			arg0.levelStageView:updateStageFleet()
			arg0.levelStageView:updateAmbushRate(arg1.fleet.line, true)

			var3 = true

			if arg0.grid then
				arg0.grid:RefreshFleetCells()
				arg0.grid:UpdateFloor()

				var1 = true
			end
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyChampion) > 0 then
			var3 = true

			if arg0.grid then
				arg0.grid:UpdateFleets()
				arg0.grid:clearChampions()
				arg0.grid:initChampions()

				var2 = true
			end
		elseif bit.band(arg2, ChapterConst.DirtyChampionPosition) > 0 then
			var3 = true

			if arg0.grid then
				arg0.grid:UpdateFleets()
				arg0.grid:updateChampions()

				var2 = true
			end
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyAchieve) > 0 then
			arg0.levelStageView:updateStageAchieve()
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyAttachment) > 0 then
			arg0.levelStageView:updateAmbushRate(arg1.fleet.line, true)

			if arg0.grid then
				if not (arg2 < 0) and not (bit.band(arg2, ChapterConst.DirtyFleet) > 0) then
					arg0.grid:updateFleet(arg1.fleets[arg1.findex].id)
				end

				arg0.grid:updateAttachments()

				if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyAutoAction) > 0 then
					arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					var1 = true
				end
			end
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyStrategy) > 0 then
			arg0.levelStageView:updateStageStrategy()

			var3 = true

			arg0.levelStageView:updateStageBarrier()
			arg0.levelStageView:UpdateAutoFightPanel()
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyAutoAction) > 0 then
			-- block empty
		elseif var1 then
			arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		elseif var2 then
			arg0.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyCellFlag) > 0 then
			arg0.grid:UpdateFloor()
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyBase) > 0 then
			arg0.levelStageView:UpdateDefenseStatus()
		end

		if arg2 < 0 or bit.band(arg2, ChapterConst.DirtyFloatItems) > 0 then
			arg0.grid:UpdateItemCells()
		end

		if var3 then
			arg0.levelStageView:updateFleetBuff()
		end
	end
end

function var0.updateClouds(arg0)
	arg0.cloudRTFs = {}
	arg0.cloudRects = {}
	arg0.cloudTimer = {}

	for iter0 = 1, 6 do
		local var0 = arg0:findTF("cloud_" .. iter0, arg0.clouds)
		local var1 = rtf(var0)

		table.insert(arg0.cloudRTFs, var1)
		table.insert(arg0.cloudRects, var1.rect.width)
	end

	arg0:initCloudsPos()

	for iter1, iter2 in ipairs(arg0.cloudRTFs) do
		local var2 = arg0.cloudRects[iter1]
		local var3 = arg0.initPositions[iter1] or Vector2(0, 0)
		local var4 = 30 - var3.y / 20
		local var5 = (arg0.mapWidth + var2) / var4
		local var6

		var6 = LeanTween.moveX(iter2, arg0.mapWidth, var5):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function()
			var2 = arg0.cloudRects[iter1]
			iter2.anchoredPosition = Vector2(-var2, var3.y)

			var6:setFrom(-var2):setTime((arg0.mapWidth + var2) / var4)
		end))
		var6.passed = math.random() * var5
		arg0.cloudTimer[iter1] = var6.uniqueId
	end
end

function var0.RefreshMapBG(arg0)
	arg0:PlayBGM()
	arg0:SwitchMapBG(arg0.contextData.map, arg0.lastMapIdx, true)
end

function var0.updateCouldAnimator(arg0, arg1, arg2)
	if arg1 then
		local var0 = arg0.contextData.map:getConfig("ani_controller")

		local function var1(arg0)
			arg0 = tf(arg0)

			local var0 = Vector3.one

			if arg0.rect.width > 0 and arg0.rect.height > 0 then
				var0.x = arg0.parent.rect.width / arg0.rect.width
				var0.y = arg0.parent.rect.height / arg0.rect.height
			end

			arg0.localScale = var0

			if var0 and #var0 > 0 then
				(function()
					for iter0, iter1 in ipairs(var0) do
						if iter1[1] == var2 then
							local var0 = iter1[2][1]
							local var1 = _.rest(iter1[2], 2)

							for iter2, iter3 in ipairs(var1) do
								local var2 = arg0:Find(iter3)

								if not IsNil(var2) then
									local var3 = getProxy(ChapterProxy):GetChapterItemById(var0)

									if var3 and not var3:isClear() then
										setActive(var2, false)
									end
								end
							end
						elseif iter1[1] == var3 then
							local var4 = iter1[2][1]
							local var5 = _.rest(iter1[2], 2)

							for iter4, iter5 in ipairs(var5) do
								local var6 = arg0:Find(iter5)

								if not IsNil(var6) then
									local var7 = getProxy(ChapterProxy):GetChapterItemById(var4)

									if var7 and not var7:isClear() then
										setActive(var6, true)

										return
									end
								end
							end
						elseif iter1[1] == var4 then
							local var8 = iter1[2][1]
							local var9 = _.rest(iter1[2], 2)

							for iter6, iter7 in ipairs(var9) do
								local var10 = arg0:Find(iter7)

								if not IsNil(var10) then
									local var11 = getProxy(ChapterProxy):GetChapterItemById(var8)

									if var11 and not var11:isClear() then
										setActive(var10, true)
									end
								end
							end
						end
					end
				end)()
			end
		end

		local var2 = arg0.loader:GetPrefab("ui/" .. arg1, arg1, function(arg0)
			arg0:SetActive(true)

			local var0 = arg0.mapTFs[arg2]

			setParent(arg0, var0)
			pg.ViewUtils.SetSortingOrder(arg0, ChapterConst.LayerWeightMap + arg2 * 2 - 1)
			var1(arg0)
		end)

		table.insert(arg0.mapGroup, var2)
	end
end

function var0.updateMapItems(arg0)
	local var0 = arg0.contextData.map
	local var1 = var0:getConfig("cloud_suffix")

	if var1 == "" then
		setActive(arg0.clouds, false)
	else
		setActive(arg0.clouds, true)

		for iter0, iter1 in ipairs(var0:getConfig("clouds_pos")) do
			local var2 = arg0.cloudRTFs[iter0]
			local var3 = var2:GetComponent(typeof(Image))

			var3.enabled = false

			GetSpriteFromAtlasAsync("clouds/cloud_" .. iter0 .. "_" .. var1, "", function(arg0)
				if not arg0.exited and not IsNil(var3) and var0 == arg0.contextData.map then
					var3.enabled = true
					var3.sprite = arg0

					var3:SetNativeSize()

					arg0.cloudRects[iter0] = var2.rect.width
				end
			end)
		end
	end

	arg0.mapBuilder.buffer:UpdateMapItems(var0)
end

function var0.updateDifficultyBtns(arg0)
	local var0 = arg0.contextData.map:getConfig("type")

	setActive(arg0.normalBtn, var0 == Map.ELITE)
	setActive(arg0.eliteQuota, var0 == Map.ELITE)
	setActive(arg0.eliteBtn, var0 == Map.SCENARIO)

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.ELITE_AWARD_ACTIVITY_ID)

	setActive(arg0.eliteBtn:Find("pic_activity"), var1 and not var1:isEnd())
end

function var0.updateActivityBtns(arg0)
	local var0, var1 = arg0.contextData.map:isActivity()
	local var2 = arg0.contextData.map:isRemaster()
	local var3 = arg0.contextData.map:isSkirmish()
	local var4 = arg0.contextData.map:isEscort()
	local var5 = arg0.contextData.map:getConfig("type")
	local var6 = getProxy(ActivityProxy):GetEarliestActByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)
	local var7 = var6 and not var6:isEnd() and not var0 and not var3 and not var4

	if var7 then
		local var8 = setmetatable({}, MainActMapBtn)

		var8.image = arg0.activityBtn:Find("Image"):GetComponent(typeof(Image))
		var8.subImage = arg0.activityBtn:Find("sub_Image"):GetComponent(typeof(Image))
		var8.tipTr = arg0.activityBtn:Find("Tip"):GetComponent(typeof(Image))
		var8.tipTxt = arg0.activityBtn:Find("Tip/Text"):GetComponent(typeof(Text))
		var7 = var8:InShowTime()

		if var7 then
			var8:InitTipImage()
			var8:InitSubImage()
			var8:InitImage(function()
				return
			end)
			var8:OnInit()
		end
	end

	setActive(arg0.activityBtn, var7)
	arg0:updateRemasterInfo()

	if var0 and var1 then
		local var9 = getProxy(ChapterProxy):getMapsByActivities()
		local var10 = underscore.any(var9, function(arg0)
			return arg0:isActExtra()
		end)

		setActive(arg0.actExtraBtn, var10 and not var2 and var5 ~= Map.ACT_EXTRA)

		if isActive(arg0.actExtraBtn) then
			if underscore.all(underscore.filter(var9, function(arg0)
				local var0 = arg0:getMapType()

				return var0 == Map.ACTIVITY_EASY or var0 == Map.ACTIVITY_HARD
			end), function(arg0)
				return arg0:isAllChaptersClear()
			end) then
				setActive(arg0.actExtraBtnAnim, true)
			else
				setActive(arg0.actExtraBtnAnim, false)
			end

			setActive(arg0.actExtraBtn:Find("Tip"), getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip())
		end

		local var11 = checkExist(arg0.contextData.map:getBindMap(), {
			"isHardMap"
		})

		setActive(arg0.actEliteBtn, var11 and var5 ~= Map.ACTIVITY_HARD)
		setActive(arg0.actNormalBtn, var5 ~= Map.ACTIVITY_EASY)
		setActive(arg0.actExtraRank, var5 == Map.ACT_EXTRA)
		setActive(arg0.actExchangeShopBtn, not var2 and var1 and not ActivityConst.HIDE_PT_PANELS)
		setActive(arg0.ptTotal, not var2 and var1 and not ActivityConst.HIDE_PT_PANELS and arg0.ptActivity and not arg0.ptActivity:isEnd())
		arg0:updateActivityRes()
	else
		setActive(arg0.actExtraBtn, false)
		setActive(arg0.actEliteBtn, false)
		setActive(arg0.actNormalBtn, false)
		setActive(arg0.actExtraRank, false)
		setActive(arg0.actExchangeShopBtn, false)
		setActive(arg0.actAtelierBuffBtn, false)
		setActive(arg0.ptTotal, false)
	end

	setActive(arg0.eventContainer, (not var0 or not var1) and not var4)
	setActive(arg0.remasterBtn, OPEN_REMASTER and (var2 or not var0 and not var4 and not var3))
	setActive(arg0.ticketTxt.parent, var2)
	arg0:updateRemasterTicket()
	arg0:updateCountDown()
	arg0:registerActBtn()

	if var0 and var5 ~= Map.ACT_EXTRA then
		Map.lastMapForActivity = arg0.contextData.mapIdx
	end
end

function var0.updateRemasterTicket(arg0)
	setText(arg0.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
	arg0:emit(LevelUIConst.FLUSH_REMASTER_TICKET)
end

function var0.updateRemasterBtnTip(arg0)
	local var0 = getProxy(ChapterProxy)
	local var1 = var0:ifShowRemasterTip() or var0:anyRemasterAwardCanReceive()

	SetActive(arg0.remasterBtn:Find("tip"), var1)
	SetActive(arg0.entranceLayer:Find("btns/btn_remaster/tip"), var1)
end

function var0.updatDailyBtnTip(arg0)
	local var0 = getProxy(DailyLevelProxy):ifShowDailyTip()

	SetActive(arg0.dailyBtn:Find("tip"), var0)
	SetActive(arg0.entranceLayer:Find("btns/btn_daily/tip"), var0)
end

function var0.updateRemasterInfo(arg0)
	arg0:emit(LevelUIConst.FLUSH_REMASTER_INFO)

	if not arg0.contextData.map then
		return
	end

	local var0 = getProxy(ChapterProxy)
	local var1
	local var2 = arg0.contextData.map:getRemaster()

	if var2 and #pg.re_map_template[var2].drop_gain > 0 then
		for iter0, iter1 in ipairs(pg.re_map_template[var2].drop_gain) do
			if #iter1 > 0 and var0.remasterInfo[iter1[1]][iter0].receive == false then
				var1 = {
					iter0,
					iter1
				}

				break
			end
		end
	end

	setActive(arg0.remasterAwardBtn, var1)

	if var1 then
		local var3 = var1[1]
		local var4, var5, var6, var7 = unpack(var1[2])
		local var8 = var0.remasterInfo[var4][var3]

		setText(arg0.remasterAwardBtn:Find("Text"), var8.count .. "/" .. var7)
		updateDrop(arg0.remasterAwardBtn:Find("IconTpl"), {
			type = var5,
			id = var6
		})
		setActive(arg0.remasterAwardBtn:Find("tip"), var7 <= var8.count)
		onButton(arg0, arg0.remasterAwardBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = var5,
					id = var6
				},
				weight = LayerWeightConst.TOP_LAYER,
				remaster = {
					word = i18n("level_remaster_tip4", pg.chapter_template[var4].chapter_name),
					number = var8.count .. "/" .. var7,
					btn_text = i18n(var8.count < var7 and "level_remaster_tip2" or "level_remaster_tip3"),
					btn_call = function()
						if var8.count < var7 then
							local var0 = pg.chapter_template[var4].map
							local var1, var2 = var0:getMapById(var0):isUnlock()

							if not var1 then
								pg.TipsMgr.GetInstance():ShowTips(var2)
							else
								arg0:ShowSelectedMap(var0)
							end
						else
							arg0:emit(LevelMediator2.ON_CHAPTER_REMASTER_AWARD, var4, var3)
						end
					end
				}
			})
		end, SFX_PANEL)
	end
end

function var0.updateCountDown(arg0)
	local var0 = getProxy(ChapterProxy)

	if arg0.newChapterCDTimer then
		arg0.newChapterCDTimer:Stop()

		arg0.newChapterCDTimer = nil
	end

	local var1 = 0

	if arg0.contextData.map:isActivity() and not arg0.contextData.map:isRemaster() then
		local var2 = var0:getMapsByActivities()

		_.each(var2, function(arg0)
			local var0 = arg0:getChapterTimeLimit()

			if var1 == 0 then
				var1 = var0
			else
				var1 = math.min(var1, var0)
			end
		end)
		setActive(arg0.countDown, var1 > 0)
		setText(arg0.countDown:Find("title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(arg0.countDown, false)
	end

	if var1 > 0 then
		setText(arg0.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1))

		arg0.newChapterCDTimer = Timer.New(function()
			var1 = var1 - 1

			if var1 <= 0 then
				arg0:updateCountDown()

				if not arg0.contextData.chapterVO then
					arg0:setMap(arg0.contextData.mapIdx)
				end
			else
				setText(arg0.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(var1))
			end
		end, 1, -1)

		arg0.newChapterCDTimer:Start()
	else
		setText(arg0.countDown:Find("time"), "")
	end
end

function var0.registerActBtn(arg0)
	if arg0.isRegisterBtn then
		return
	end

	arg0.isRegisterBtn = true

	onButton(arg0, arg0.actExtraRank, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0, arg0.activityBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.actExchangeShopBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.actAtelierBuffBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.SHOW_ATELIER_BUFF)
	end, SFX_UI_CLICK)

	local var0 = getProxy(ChapterProxy)

	local function var1(arg0, arg1, arg2)
		local var0

		if arg0:isRemaster() then
			var0 = var0:getRemasterMaps(arg0.remasterId)
		else
			var0 = var0:getMapsByActivities()
		end

		local var1 = _.select(var0, function(arg0)
			return arg0:getMapType() == arg1
		end)

		table.sort(var1, function(arg0, arg1)
			return arg0.id < arg1.id
		end)

		local var2 = table.indexof(underscore.map(var1, function(arg0)
			return arg0.id
		end), arg2) or #var1

		while not var1[var2]:isUnlock() do
			if var2 > 1 then
				var2 = var2 - 1
			else
				break
			end
		end

		return var1[var2]
	end

	local function var2()
		if arg0:isfrozen() then
			return
		end

		local var0 = arg0.contextData.map:getBindMapId()
		local var1 = var1(arg0.contextData.map, Map.ACTIVITY_HARD, var0)
		local var2, var3 = var1:isUnlock()

		if var2 then
			arg0:setMap(var1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3)
		end
	end

	onButton(arg0, arg0.actEliteBtn, var2, SFX_PANEL)
	arg0:bind(LevelUIConst.SWITCH_CHALLENGE_MAP, var2)
	onButton(arg0, arg0.actNormalBtn, function()
		if arg0:isfrozen() then
			return
		end

		local var0 = arg0.contextData.map:getBindMapId()
		local var1 = var1(arg0.contextData.map, Map.ACTIVITY_EASY, var0)
		local var2, var3 = var1:isUnlock()

		if var2 then
			arg0:setMap(var1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.actExtraBtn, function()
		if arg0:isfrozen() then
			return
		end

		local var0 = PlayerPrefs.HasKey("ex_mapId") and PlayerPrefs.GetInt("ex_mapId", 0) or 0
		local var1 = var1(arg0.contextData.map, Map.ACT_EXTRA, var0)
		local var2, var3 = var1:isUnlock()

		if var2 then
			arg0:setMap(var1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(var3)
		end
	end, SFX_PANEL)
end

function var0.initCloudsPos(arg0, arg1)
	arg0.initPositions = {}

	local var0 = arg1 or 1
	local var1 = pg.expedition_data_by_map[var0].clouds_pos

	for iter0, iter1 in ipairs(arg0.cloudRTFs) do
		local var2 = var1[iter0]

		if var2 then
			iter1.anchoredPosition = Vector2(var2[1], var2[2])

			table.insert(arg0.initPositions, iter1.anchoredPosition)
		else
			setActive(iter1, false)
		end
	end
end

function var0.initMapBtn(arg0, arg1, arg2)
	onButton(arg0, arg1, function()
		if arg0:isfrozen() then
			return
		end

		local var0 = arg0.contextData.mapIdx + arg2
		local var1 = getProxy(ChapterProxy):getMapById(var0)

		if not var1 then
			return
		end

		if var1:getMapType() == Map.ELITE and not var1:isEliteEnabled() then
			var1 = var1:getBindMap()
			var0 = var1.id

			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
		end

		local var2, var3 = var1:isUnlock()

		if arg2 > 0 and not var2 then
			pg.TipsMgr.GetInstance():ShowTips(var3)

			return
		end

		arg0:setMap(var0)
	end, SFX_PANEL)
end

function var0.ShowSelectedMap(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			if arg0.contextData.entranceStatus then
				arg0:frozen()

				arg0.nextPreloadMap = arg1

				arg0:PreloadLevelMainUI(arg1, function()
					arg0:unfrozen()

					if arg0.nextPreloadMap ~= arg1 then
						return
					end

					arg0:emit(LevelMediator2.ON_ENTER_MAINLEVEL, arg1)
					arg0:ShowEntranceUI(false)
					arg0()
				end)
			else
				arg0:setMap(arg1)
				arg0()
			end
		end
	}, arg2)
end

function var0.setMap(arg0, arg1)
	arg0.lastMapIdx = arg0.contextData.mapIdx
	arg0.contextData.mapIdx = arg1
	arg0.contextData.map = getProxy(ChapterProxy):getMapById(arg1)

	assert(arg0.contextData.map, "map cannot be nil " .. arg1)

	if arg0.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", arg0.contextData.map.id)
		PlayerPrefs.Save()
	elseif arg0.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. arg0.contextData.map.remasterId, arg1)
		PlayerPrefs.Save()
	end

	arg0:updateMap()
	arg0:tryPlayMapStory()
end

local var5 = import("view.level.MapBuilder.MapBuilder")
local var6 = {
	default = "MapBuilderNormal",
	[var5.TYPENORMAL] = "MapBuilderNormal",
	[var5.TYPEESCORT] = "MapBuilderEscort",
	[var5.TYPESHINANO] = "MapBuilderShinano",
	[var5.TYPESKIRMISH] = "MapBuilderSkirmish",
	[var5.TYPEBISMARCK] = "MapBuilderBismarck",
	[var5.TYPESSSS] = "MapBuilderSSSS",
	[var5.TYPEATELIER] = "MapBuilderAtelier",
	[var5.TYPESENRANKAGURA] = "MapBuilderSenrankagura"
}

function var0.SwitchMapBuilder(arg0, arg1)
	if arg0.mapBuilder and arg0.mapBuilder:GetType() ~= arg1 then
		arg0.mapBuilder.buffer:Hide()
	end

	local var0 = arg0:GetMapBuilderInBuffer(arg1)

	arg0.mapBuilder = var0

	var0.buffer:Show()
	var0.buffer:ShowButtons()
end

function var0.GetMapBuilderInBuffer(arg0, arg1)
	if not arg0.mbDict[arg1] then
		local var0 = _G[var6[arg1] or var6.default]

		arg0.mbDict[arg1] = var0.New(arg0._tf, arg0)
		arg0.mbDict[arg1].isFrozen = arg0:isfrozen()

		arg0.mbDict[arg1]:Load()
	end

	return arg0.mbDict[arg1]
end

function var0.JudgeMapBuilderType(arg0)
	return (arg0.contextData.map:getConfig("ui_type"))
end

function var0.updateMap(arg0)
	local var0 = arg0.contextData.map

	arg0:SwitchMapBG(var0, arg0.lastMapIdx)

	arg0.lastMapIdx = nil

	local var1 = var0:getConfig("anchor")
	local var2

	if var1 == "" then
		var2 = Vector2.zero
	else
		var2 = Vector2(unpack(var1))
	end

	arg0.map.pivot = var2

	local var3 = var0:getConfig("uifx")

	for iter0 = 1, arg0.UIFXList.childCount do
		local var4 = arg0.UIFXList:GetChild(iter0 - 1)

		setActive(var4, var4.name == var3)
	end

	arg0:PlayBGM()

	local var5 = arg0:JudgeMapBuilderType()

	arg0:SwitchMapBuilder(var5)
	arg0.mapBuilder.buffer:Update(var0)
	arg0:UpdateSwitchMapButton()
	arg0:updateMapItems()
	arg0.mapBuilder.buffer:UpdateButtons()
	arg0.mapBuilder.buffer:PostUpdateMap(var0)

	if arg0.contextData.openChapterId then
		arg0.mapBuilder.buffer:TryOpenChapter(arg0.contextData.openChapterId)

		arg0.contextData.openChapterId = nil
	end
end

function var0.UpdateSwitchMapButton(arg0)
	local var0 = arg0.contextData.map
	local var1 = getProxy(ChapterProxy)
	local var2 = var1:getMapById(var0.id - 1)
	local var3 = var1:getMapById(var0.id + 1)

	setActive(arg0.btnPrev, tobool(var2))
	setActive(arg0.btnNext, tobool(var3))

	local var4 = Color.New(0.5, 0.5, 0.5, 1)

	setImageColor(arg0.btnPrevCol, var2 and Color.white or var4)
	setImageColor(arg0.btnNextCol, var3 and var3:isUnlock() and Color.white or var4)
end

function var0.TrySwitchChapter(arg0, arg1)
	local var0 = getProxy(ChapterProxy):getActiveChapter()

	if var0 then
		if var0.id == arg1.id then
			arg0:switchToChapter(var0)
		else
			local var1 = i18n("levelScene_chapter_strategying", var0:getConfig("chapter_name"))

			pg.TipsMgr.GetInstance():ShowTips(var1)
		end
	else
		arg0:displayChapterPanel(arg1)
	end
end

function var0.updateChapterTF(arg0, arg1)
	if not arg0.mapBuilder.UpdateChapterTF then
		return
	end

	arg0.mapBuilder.buffer:UpdateChapterTF(arg1)
end

function var0.tryPlayMapStory(arg0)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function(arg0)
			local var0 = arg0.contextData.map:getConfig("enter_story")

			if var0 and var0 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0) and not arg0.contextData.map:isRemaster() and not pg.SystemOpenMgr.GetInstance().active then
				local var1 = tonumber(var0)

				if var1 and var1 > 0 then
					arg0:emit(LevelMediator2.ON_PERFORM_COMBAT, var1)
				else
					pg.NewStoryMgr.GetInstance():Play(var0, arg0)
				end

				return
			end

			arg0()
		end,
		function(arg0)
			local var0 = arg0.contextData.map:getConfig("guide_id")

			if var0 and var0 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0, nil, arg0)

				return
			end

			arg0()
		end,
		function(arg0)
			if isActive(arg0.actAtelierBuffBtn) and getProxy(ActivityProxy):AtelierActivityAllSlotIsEmpty() and getProxy(ActivityProxy):OwnAtelierActivityItemCnt(34, 1) then
				local var0 = PlayerPrefs.GetInt("first_enter_ryza_buff_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0
				local var1

				if var0 then
					var1 = {
						1,
						2
					}
				else
					var1 = {
						1
					}
				end

				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0034", var1)
			else
				arg0()
			end
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(arg0.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

function var0.DisplaySPAnim(arg0, arg1, arg2, arg3)
	arg0.uiAnims = arg0.uiAnims or {}

	local var0 = arg0.uiAnims[arg1]

	local function var1()
		arg0.playing = true

		arg0:frozen()
		var0:SetActive(true)

		local var0 = tf(var0)

		pg.UIMgr.GetInstance():OverlayPanel(var0, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3 then
			arg3(var0)
		end

		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			arg0.playing = false

			if arg2 then
				arg2(var0)
			end

			arg0:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0 then
		PoolMgr.GetInstance():GetUI(arg1, true, function(arg0)
			arg0:SetActive(true)

			arg0.uiAnims[arg1] = arg0
			var0 = arg0.uiAnims[arg1]

			var1()
		end)
	else
		var1()
	end
end

function var0.displaySpResult(arg0, arg1, arg2)
	setActive(arg0.spResult, true)
	arg0:DisplaySPAnim(arg1 == 1 and "SpUnitWin" or "SpUnitLose", function(arg0)
		onButton(arg0, arg0, function()
			removeOnButton(arg0)
			setActive(arg0, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0, arg0._tf)
			arg0:hideSpResult()
			arg2()
		end, SFX_PANEL)
	end)
end

function var0.hideSpResult(arg0)
	setActive(arg0.spResult, false)
end

function var0.displayBombResult(arg0, arg1)
	setActive(arg0.spResult, true)
	arg0:DisplaySPAnim("SpBombRet", function(arg0)
		onButton(arg0, arg0, function()
			removeOnButton(arg0)
			setActive(arg0, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0, arg0._tf)
			arg0:hideSpResult()
			arg1()
		end, SFX_PANEL)
	end, function(arg0)
		setText(arg0.transform:Find("right/name_bg/en"), arg0.contextData.chapterVO.modelCount)
	end)
end

function var0.displayChapterPanel(arg0, arg1, arg2)
	local function var0(arg0)
		if getProxy(BayProxy):getShipCount() >= arg0.player:getMaxShipBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

			return
		end

		arg0:hideChapterPanel()

		local var0 = arg1:getConfig("type")

		arg0.contextData.chapterLoopFlag = arg0

		if var0 == Chapter.CustomFleet then
			arg0:displayFleetEdit(arg1)
		elseif #arg1:getNpcShipByType(1) > 0 then
			arg0:emit(LevelMediator2.ON_TRACKING, arg1.id)

			return
		else
			arg0:displayFleetSelect(arg1)
		end
	end

	local function var1()
		arg0:hideChapterPanel()
	end

	if getProxy(ChapterProxy):getMapById(arg1:getConfig("map")):isSkirmish() and #arg1:getNpcShipByType(1) > 0 then
		var0(false)

		return
	end

	arg0.levelInfoView:Load()
	arg0.levelInfoView:ActionInvoke("set", arg1, arg2)
	arg0.levelInfoView:ActionInvoke("setCBFunc", var0, var1)
	arg0.levelInfoView:ActionInvoke("Show")
end

function var0.hideChapterPanel(arg0)
	if arg0.levelInfoView:isShowing() then
		arg0.levelInfoView:ActionInvoke("Hide")
	end
end

function var0.destroyChapterPanel(arg0)
	arg0.levelInfoView:Destroy()

	arg0.levelInfoView = nil
end

function var0.displayFleetSelect(arg0, arg1)
	local var0 = arg0.contextData.selectedFleetIDs or arg1:GetDefaultFleetIndex()

	arg1 = Clone(arg1)
	arg1.loopFlag = arg0.contextData.chapterLoopFlag

	arg0.levelFleetView:updateSpecialOperationTickets(arg0.spTickets)
	arg0.levelFleetView:Load()
	arg0.levelFleetView:ActionInvoke("setHardShipVOs", arg0.shipVOs)
	arg0.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0.openedCommanerSystem)
	arg0.levelFleetView:ActionInvoke("set", arg1, arg0.fleets, var0)
	arg0.levelFleetView:ActionInvoke("Show")
end

function var0.hideFleetSelect(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:Hide()
	end

	if arg0.levelFleetView then
		arg0.levelFleetView:Hide()
	end
end

function var0.buildCommanderPanel(arg0)
	arg0.levelCMDFormationView = LevelCMDFormationView.New(arg0.topPanel, arg0.event, arg0.contextData)
end

function var0.destroyFleetSelect(arg0)
	if not arg0.levelFleetView then
		return
	end

	arg0.levelFleetView:Destroy()

	arg0.levelFleetView = nil
end

function var0.displayFleetEdit(arg0, arg1)
	arg1 = Clone(arg1)
	arg1.loopFlag = arg0.contextData.chapterLoopFlag

	arg0.levelFleetView:updateSpecialOperationTickets(arg0.spTickets)
	arg0.levelFleetView:Load()
	arg0.levelFleetView:ActionInvoke("setOpenCommanderTag", arg0.openedCommanerSystem)
	arg0.levelFleetView:ActionInvoke("setHardShipVOs", arg0.shipVOs)
	arg0.levelFleetView:ActionInvoke("setOnHard", arg1)
	arg0.levelFleetView:ActionInvoke("Show")
end

function var0.hideFleetEdit(arg0)
	arg0:hideFleetSelect()
end

function var0.destroyFleetEdit(arg0)
	arg0:destroyFleetSelect()
end

function var0.RefreshFleetSelectView(arg0, arg1)
	if not arg0.levelFleetView then
		return
	end

	assert(arg0.levelFleetView:GetLoaded())

	local var0 = arg0.levelFleetView:IsSelectMode()
	local var1

	if var0 then
		arg0.levelFleetView:ActionInvoke("set", arg1 or arg0.levelFleetView.chapter, arg0.fleets, arg0.levelFleetView:getSelectIds())

		if arg0.levelCMDFormationView:isShowing() then
			local var2 = arg0.levelCMDFormationView.fleet.id

			var1 = arg0.fleets[var2]
		end
	else
		arg0.levelFleetView:ActionInvoke("setOnHard", arg1 or arg0.levelFleetView.chapter)

		if arg0.levelCMDFormationView:isShowing() then
			local var3 = arg0.levelCMDFormationView.fleet.id

			var1 = arg1:wrapEliteFleet(var3)
		end
	end

	if var1 then
		arg0.levelCMDFormationView:ActionInvoke("updateFleet", var1)
	end
end

function var0.setChapter(arg0, arg1)
	local var0

	if arg1 then
		var0 = arg1.id
	end

	arg0.contextData.chapterId = var0
	arg0.contextData.chapterVO = arg1
end

function var0.switchToChapter(arg0, arg1)
	if arg0.contextData.mapIdx ~= arg1:getConfig("map") then
		arg0:setMap(arg1:getConfig("map"))
	end

	arg0:setChapter(arg1)
	setActive(arg0.clouds, false)
	arg0.mapBuilder.buffer:Hide()

	arg0.leftCanvasGroup.blocksRaycasts = false
	arg0.rightCanvasGroup.blocksRaycasts = false

	assert(not arg0.levelStageView, "LevelStageView Exists On SwitchToChapter")
	arg0:DestroyLevelStageView()

	if not arg0.levelStageView then
		arg0.levelStageView = LevelStageView.New(arg0.topPanel, arg0.event, arg0.contextData)

		arg0.levelStageView:Load()

		arg0.levelStageView.isFrozen = arg0:isfrozen()
	end

	arg0:frozen()

	local function var0()
		seriesAsync({
			function(arg0)
				pg.UIMgr.GetInstance():BlurPanel(arg0.topPanel, false, {
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
				arg0.levelStageView:updateStageInfo()
				arg0.levelStageView:updateAmbushRate(arg1.fleet.line, true)
				arg0.levelStageView:updateStageAchieve()
				arg0.levelStageView:updateStageBarrier()
				arg0.levelStageView:updateBombPanel()
				arg0.levelStageView:UpdateDefenseStatus()
				onNextTick(arg0)
			end,
			function(arg0)
				if arg0.exited then
					return
				end

				arg0.levelStageView:updateStageStrategy()

				arg0.canvasGroup.blocksRaycasts = arg0.frozenCount == 0

				onNextTick(arg0)
			end,
			function(arg0)
				if arg0.exited then
					return
				end

				arg0.levelStageView:updateStageFleet()
				arg0.levelStageView:updateSupportFleet()
				arg0.levelStageView:updateFleetBuff()
				onNextTick(arg0)
			end,
			function(arg0)
				if arg0.exited then
					return
				end

				parallelAsync({
					function(arg0)
						local var0 = arg1:getConfig("scale")
						local var1 = LeanTween.value(go(arg0.map), arg0.map.localScale, Vector3.New(var0[3], var0[3], 1), var1):setOnUpdateVector3(function(arg0)
							arg0.map.localScale = arg0
							arg0.float.localScale = arg0
						end):setOnComplete(System.Action(arg0)):setEase(LeanTweenType.easeOutSine)

						arg0:RecordTween("mapScale", var1.uniqueId)

						local var2 = LeanTween.value(go(arg0.map), arg0.map.pivot, Vector2.New(math.clamp(var0[1] - 0.5, 0, 1), math.clamp(var0[2] - 0.5, 0, 1)), var1)

						var2:setOnUpdateVector2(function(arg0)
							arg0.map.pivot = arg0
							arg0.float.pivot = arg0
						end):setEase(LeanTweenType.easeOutSine)
						arg0:RecordTween("mapPivot", var2.uniqueId)
						shiftPanel(arg0.leftChapter, -arg0.leftChapter.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0.rightChapter, arg0.rightChapter.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						shiftPanel(arg0.topChapter, 0, arg0.topChapter.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
						arg0.levelStageView:ShiftStagePanelIn()
					end,
					function(arg0)
						arg0:PlayBGM()

						local var0 = {}
						local var1 = arg1:getConfig("bg")

						if var1 and #var1 > 0 then
							var0[1] = {
								BG = var1
							}
						end

						arg0:SwitchBG(var0, arg0)
					end
				}, function()
					onNextTick(arg0)
					arg0.mapBuilder.buffer:HideButtons()
				end)
			end,
			function(arg0)
				if arg0.exited then
					return
				end

				setActive(arg0.topChapter, false)
				setActive(arg0.leftChapter, false)
				setActive(arg0.rightChapter, false)

				arg0.leftCanvasGroup.blocksRaycasts = true
				arg0.rightCanvasGroup.blocksRaycasts = true

				arg0:initGrid(arg0)
			end,
			function(arg0)
				if arg0.exited then
					return
				end

				arg0.levelStageView:SetGrid(arg0.grid)

				arg0.contextData.huntingRangeVisibility = arg0.contextData.huntingRangeVisibility - 1

				arg0.grid:toggleHuntingRange()

				local var0 = arg1:getConfig("pop_pic")

				if var0 and #var0 > 0 and arg0.FirstEnterChapter == arg1.id then
					arg0:doPlayAnim(var0, function(arg0)
						setActive(arg0, false)

						if arg0.exited then
							return
						end

						arg0()
					end)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0.levelStageView:tryAutoAction(arg0)
			end,
			function(arg0)
				if arg0.exited then
					return
				end

				arg0:unfrozen()

				if arg0.FirstEnterChapter then
					arg0:emit(LevelMediator2.ON_RESUME_SUBSTATE, arg1.subAutoAttack)
				end

				arg0.FirstEnterChapter = nil

				arg0.levelStageView:tryAutoTrigger(true)
			end
		})
	end

	arg0.levelStageView:ActionInvoke("SetSeriesOperation", var0)
	arg0.levelStageView:ActionInvoke("SetPlayer", arg0.player)
	arg0.levelStageView:ActionInvoke("SwitchToChapter", arg1)
end

function var0.switchToMap(arg0, arg1)
	arg0:frozen()
	arg0:destroyGrid()
	LeanTween.cancel(go(arg0.map))

	local var0 = LeanTween.value(go(arg0.map), arg0.map.localScale, Vector3.one, var1):setOnUpdateVector3(function(arg0)
		arg0.map.localScale = arg0
		arg0.float.localScale = arg0
	end):setOnComplete(System.Action(function()
		arg0.mapBuilder.buffer:Show()
		arg0.mapBuilder.buffer:Update(arg0.contextData.map)
		arg0:UpdateSwitchMapButton()
		arg0:updateMapItems()
		arg0.mapBuilder.buffer:UpdateButtons()
		arg0.mapBuilder.buffer:PostUpdateMap(arg0.contextData.map)
		arg0:unfrozen()
		existCall(arg1)
	end)):setEase(LeanTweenType.easeOutSine)

	arg0:RecordTween("mapScale", var0.uniqueId)

	local var1 = arg0.contextData.map:getConfig("anchor")
	local var2

	if var1 == "" then
		var2 = Vector2.zero
	else
		var2 = Vector2(unpack(var1))
	end

	local var3 = LeanTween.value(go(arg0.map), arg0.map.pivot, var2, var1)

	var3:setOnUpdateVector2(function(arg0)
		arg0.map.pivot = arg0
		arg0.float.pivot = arg0
	end):setEase(LeanTweenType.easeOutSine)
	arg0:RecordTween("mapPivot", var3.uniqueId)
	setActive(arg0.topChapter, true)
	setActive(arg0.leftChapter, true)
	setActive(arg0.rightChapter, true)
	shiftPanel(arg0.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	assert(arg0.levelStageView, "LevelStageView Doesnt Exist On SwitchToMap")

	if arg0.levelStageView then
		arg0.levelStageView:ActionInvoke("ShiftStagePanelOut", function()
			arg0:DestroyLevelStageView()
		end)
		arg0.levelStageView:ActionInvoke("SwitchToMap")
	end

	arg0:SwitchMapBG(arg0.contextData.map)
	arg0.mapBuilder.buffer:ShowButtons()
	arg0:setChapter(nil)
	arg0:PlayBGM()
	pg.UIMgr.GetInstance():UnblurPanel(arg0.topPanel, arg0._tf)
	pg.playerResUI:SetActive({
		active = false
	})

	arg0.canvasGroup.blocksRaycasts = arg0.frozenCount == 0
	arg0.canvasGroup.interactable = true

	if arg0.ambushWarning and arg0.ambushWarning.activeSelf then
		arg0.ambushWarning:SetActive(false)
		arg0:unfrozen()
	end
end

function var0.SwitchBG(arg0, arg1, arg2, arg3)
	if not arg1 or #arg1 <= 0 then
		existCall(arg2)

		return
	elseif arg3 then
		-- block empty
	elseif table.equal(arg0.currentBG, arg1) then
		return
	end

	arg0.currentBG = arg1

	for iter0, iter1 in ipairs(arg0.mapGroup) do
		arg0.loader:ClearRequest(iter1)
	end

	table.clear(arg0.mapGroup)

	local var0 = {}

	table.ParallelIpairsAsync(arg1, function(arg0, arg1, arg2)
		local var0 = arg0.mapTFs[arg0]
		local var1 = arg0.loader:GetSpriteDirect("levelmap/" .. arg1.BG, "", function(arg0)
			var0[arg0] = arg0

			arg2()
		end, var0)

		table.insert(arg0.mapGroup, var1)
		arg0:updateCouldAnimator(arg1.Animator, arg0)
	end, function()
		for iter0, iter1 in ipairs(arg0.mapTFs) do
			setImageSprite(iter1, var0[iter0])
			setActive(iter1, arg1[iter0])
			SetCompomentEnabled(iter1, typeof(Image), true)
		end

		existCall(arg2)
	end)
end

local var7 = {
	1520001,
	1520002,
	1520011,
	1520012
}
local var8 = {
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
local var9 = {
	1420001,
	1420011
}

function var0.ClearMapTransitions(arg0)
	if not arg0.mapTransitions then
		return
	end

	for iter0, iter1 in pairs(arg0.mapTransitions) do
		if iter1 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0, iter0, iter1, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. iter0, iter0)
		end
	end

	arg0.mapTransitions = nil
end

function var0.SwitchMapBG(arg0, arg1, arg2, arg3)
	local var0, var1, var2 = arg0:GetMapBG(arg1, arg2)

	if not var1 then
		arg0:SwitchBG(var0, arg3)

		return
	end

	arg0:PlayMapTransition("LevelMapTransition_" .. var1, var2, function()
		arg0:SwitchBG(var0, arg3)
	end)
end

function var0.GetMapBG(arg0, arg1, arg2)
	if not table.contains(var7, arg1.id) then
		return {
			arg0:GetMapElement(arg1)
		}
	end

	local var0 = arg1.id
	local var1 = table.indexof(var7, var0) - 1
	local var2 = bit.lshift(bit.rshift(var1, 1), 1) + 1
	local var3 = {
		var7[var2],
		var7[var2 + 1]
	}
	local var4 = _.map(var3, function(arg0)
		return getProxy(ChapterProxy):getMapById(arg0)
	end)

	if _.all(var4, function(arg0)
		return arg0:isAllChaptersClear()
	end) then
		local var5 = {
			arg0:GetMapElement(arg1)
		}

		if not arg2 or math.abs(var0 - arg2) ~= 1 then
			return var5
		end

		local var6 = var9[bit.rshift(var2 - 1, 1) + 1]
		local var7 = bit.band(var1, 1) == 1

		return var5, var6, var7
	else
		local var8 = 0

		;(function()
			local var0 = var4[1]:getChapters()

			for iter0, iter1 in ipairs(var0) do
				if not iter1:isClear() then
					return
				end

				var8 = var8 + 1
			end

			if not var4[2]:isAnyChapterUnlocked(true) then
				return
			end

			var8 = var8 + 1

			local var1 = var4[2]:getChapters()

			for iter2, iter3 in ipairs(var1) do
				if not iter3:isClear() then
					return
				end

				var8 = var8 + 1
			end
		end)()

		local var9

		if var8 > 0 then
			local var10 = var8[bit.rshift(var2 - 1, 1) + 1]

			var9 = {
				{
					BG = "map_" .. var10[1],
					Animator = var10[2]
				},
				{
					BG = "map_" .. var10[3] + var8,
					Animator = var10[4]
				}
			}
		else
			var9 = {
				arg0:GetMapElement(arg1)
			}
		end

		return var9
	end
end

function var0.GetMapElement(arg0, arg1)
	local var0 = arg1:getConfig("bg")
	local var1 = arg1:getConfig("ani_controller")

	if var1 and #var1 > 0 then
		(function()
			for iter0, iter1 in ipairs(var1) do
				local var0 = _.rest(iter1[2], 2)

				for iter2, iter3 in ipairs(var0) do
					if string.find(iter3, "^map_") and iter1[1] == var3 then
						local var1 = iter1[2][1]
						local var2 = getProxy(ChapterProxy):GetChapterItemById(var1)

						if var2 and not var2:isClear() then
							var0 = iter3

							return
						end
					end
				end
			end
		end)()
	end

	local var2 = {
		BG = var0
	}

	var2.Animator, var2.AnimatorController = arg0:GetMapAnimator(arg1)

	return var2
end

function var0.GetMapAnimator(arg0, arg1)
	local var0 = arg1:getConfig("ani_name")

	if arg1:getConfig("animtor") == 1 and var0 and #var0 > 0 then
		local var1 = arg1:getConfig("ani_controller")

		if var1 and #var1 > 0 then
			(function()
				for iter0, iter1 in ipairs(var1) do
					local var0 = _.rest(iter1[2], 2)

					for iter2, iter3 in ipairs(var0) do
						if string.find(iter3, "^effect_") and iter1[1] == var3 then
							local var1 = iter1[2][1]
							local var2 = getProxy(ChapterProxy):GetChapterItemById(var1)

							if var2 and not var2:isClear() then
								var0 = "map_" .. string.sub(iter3, 8)

								return
							end
						end
					end
				end
			end)()
		end

		return var0, var1
	end
end

function var0.PlayMapTransition(arg0, arg1, arg2, arg3, arg4)
	arg0.mapTransitions = arg0.mapTransitions or {}

	local var0

	local function var1()
		arg0:frozen()
		existCall(arg3, var0)
		var0:SetActive(true)

		local var0 = tf(var0)

		pg.UIMgr.GetInstance():OverlayPanel(var0, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		var0:GetComponent(typeof(Animator)):Play(arg2 and "Sequence" or "Inverted", -1, 0)
		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			pg.UIMgr.GetInstance():UnOverlayPanel(var0, arg0._tf)
			existCall(arg4, var0)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1, arg1, var0)

			arg0.mapTransitions[arg1] = false

			arg0:unfrozen()
		end)
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1, arg1, true, function(arg0)
		var0 = arg0
		arg0.mapTransitions[arg1] = arg0

		var1()
	end)
end

function var0.DestroyLevelStageView(arg0)
	if arg0.levelStageView then
		arg0.levelStageView:Destroy()

		arg0.levelStageView = nil
	end
end

function var0.displayAmbushInfo(arg0, arg1)
	arg0.levelAmbushView = LevelAmbushView.New(arg0.topPanel, arg0.event, arg0.contextData)

	arg0.levelAmbushView:Load()
	arg0.levelAmbushView:ActionInvoke("SetFuncOnComplete", arg1)
end

function var0.hideAmbushInfo(arg0)
	if arg0.levelAmbushView then
		arg0.levelAmbushView:Destroy()

		arg0.levelAmbushView = nil
	end
end

function var0.doAmbushWarning(arg0, arg1)
	arg0:frozen()

	local function var0()
		arg0.ambushWarning:SetActive(true)

		local var0 = tf(arg0.ambushWarning)

		var0:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0:SetSiblingIndex(1)

		local var1 = var0:GetComponent("DftAniEvent")

		var1:SetTriggerEvent(function(arg0)
			arg1()
		end)
		var1:SetEndEvent(function(arg0)
			arg0.ambushWarning:SetActive(false)
			arg0:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		Timer.New(function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1):Start()
	end

	if not arg0.ambushWarning then
		PoolMgr.GetInstance():GetUI("ambushwarnui", true, function(arg0)
			arg0:SetActive(true)

			arg0.ambushWarning = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.destroyAmbushWarn(arg0)
	if arg0.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", arg0.ambushWarning)

		arg0.ambushWarning = nil
	end
end

function var0.displayStrategyInfo(arg0, arg1)
	arg0.levelStrategyView = LevelStrategyView.New(arg0.topPanel, arg0.event, arg0.contextData)

	arg0.levelStrategyView:Load()
	arg0.levelStrategyView:ActionInvoke("set", arg1)

	local function var0()
		local var0 = arg0.contextData.chapterVO.fleet
		local var1 = pg.strategy_data_template[arg1.id]

		if not var0:canUseStrategy(arg1) then
			return
		end

		local var2 = var0:getNextStgUser(arg1.id)

		if var1.type == ChapterConst.StgTypeForm then
			arg0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2,
				arg1 = arg1.id
			})
		elseif var1.type == ChapterConst.StgTypeConsume then
			arg0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var2,
				arg1 = arg1.id
			})
		end

		arg0:hideStrategyInfo()
	end

	local function var1()
		arg0:hideStrategyInfo()
	end

	arg0.levelStrategyView:ActionInvoke("setCBFunc", var0, var1)
end

function var0.hideStrategyInfo(arg0)
	if arg0.levelStrategyView then
		arg0.levelStrategyView:Destroy()

		arg0.levelStrategyView = nil
	end
end

function var0.displayRepairWindow(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = getProxy(ChapterProxy)
	local var2
	local var3
	local var4
	local var5
	local var6 = var1.repairTimes
	local var7, var8, var9 = ChapterConst.GetRepairParams()

	arg0.levelRepairView = LevelRepairView.New(arg0.topPanel, arg0.event, arg0.contextData)

	arg0.levelRepairView:Load()
	arg0.levelRepairView:ActionInvoke("set", var6, var7, var8, var9)

	local function var10()
		if var7 - math.min(var6, var7) == 0 and arg0.player:getTotalGem() < var9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		arg0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = var0.fleet.id,
			arg1 = arg1.id
		})
		arg0:hideRepairWindow()
	end

	local function var11()
		arg0:hideRepairWindow()
	end

	arg0.levelRepairView:ActionInvoke("setCBFunc", var10, var11)
end

function var0.hideRepairWindow(arg0)
	if arg0.levelRepairView then
		arg0.levelRepairView:Destroy()

		arg0.levelRepairView = nil
	end
end

function var0.displayRemasterPanel(arg0, arg1)
	arg0.levelRemasterView:Load()

	local function var0(arg0)
		arg0:ShowSelectedMap(arg0)
	end

	arg0.levelRemasterView:ActionInvoke("Show")
	arg0.levelRemasterView:ActionInvoke("set", var0, arg1)
end

function var0.hideRemasterPanel(arg0)
	if arg0.levelRemasterView:isShowing() then
		arg0.levelRemasterView:ActionInvoke("Hide")
	end
end

function var0.initGrid(arg0, arg1)
	local var0 = arg0.contextData.chapterVO

	if not var0 then
		return
	end

	arg0:enableLevelCamera()
	setActive(arg0.uiMain, true)

	arg0.levelGrid.localEulerAngles = Vector3(var0.theme.angle, 0, 0)
	arg0.grid = LevelGrid.New(arg0.dragLayer)

	arg0.grid:attach(arg0)
	arg0.grid:ExtendItem("shipTpl", arg0.shipTpl)
	arg0.grid:ExtendItem("subTpl", arg0.subTpl)
	arg0.grid:ExtendItem("transportTpl", arg0.transportTpl)
	arg0.grid:ExtendItem("enemyTpl", arg0.enemyTpl)
	arg0.grid:ExtendItem("championTpl", arg0.championTpl)
	arg0.grid:ExtendItem("oniTpl", arg0.oniTpl)
	arg0.grid:ExtendItem("arrowTpl", arg0.arrowTarget)
	arg0.grid:ExtendItem("destinationMarkTpl", arg0.destinationMarkTpl)

	function arg0.grid.onShipStepChange(arg0)
		arg0.levelStageView:updateAmbushRate(arg0)
	end

	arg0.grid:initAll(arg1)
end

function var0.destroyGrid(arg0)
	if arg0.grid then
		arg0.grid:detach()

		arg0.grid = nil

		arg0:disableLevelCamera()
		setActive(arg0.dragLayer, true)
		setActive(arg0.uiMain, false)
	end
end

function var0.doTracking(arg0, arg1)
	arg0:frozen()

	local function var0()
		arg0.radar:SetActive(true)

		local var0 = tf(arg0.radar)

		var0:SetParent(arg0.topPanel, false)
		var0:SetSiblingIndex(1)
		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			arg0.radar:SetActive(false)
			arg0:unfrozen()
			arg1()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not arg0.radar then
		PoolMgr.GetInstance():GetUI("RadarEffectUI", true, function(arg0)
			arg0:SetActive(true)

			arg0.radar = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.destroyTracking(arg0)
	if arg0.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", arg0.radar)

		arg0.radar = nil
	end
end

function var0.doPlayAirStrike(arg0, arg1, arg2, arg3)
	local function var0()
		arg0.playing = true

		arg0:frozen()
		arg0.airStrike:SetActive(true)

		local var0 = tf(arg0.airStrike)

		var0:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var0:SetAsLastSibling()
		setActive(var0:Find("words/be_striked"), arg1 == ChapterConst.SubjectChampion)
		setActive(var0:Find("words/strike_enemy"), arg1 == ChapterConst.SubjectPlayer)

		local function var1()
			arg0.playing = false

			SetActive(arg0.airStrike, false)

			if arg3 then
				arg3()
			end

			arg0:unfrozen()
		end

		var0:GetComponent("DftAniEvent"):SetEndEvent(var1)

		if arg2 then
			onButton(arg0, var0, var1, SFX_PANEL)
		else
			removeOnButton(var0)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0.airStrike then
		PoolMgr.GetInstance():GetUI("AirStrike", true, function(arg0)
			arg0:SetActive(true)

			arg0.airStrike = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.destroyAirStrike(arg0)
	if arg0.airStrike then
		arg0.airStrike:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", arg0.airStrike)

		arg0.airStrike = nil
	end
end

function var0.doPlayAnim(arg0, arg1, arg2, arg3)
	arg0.uiAnims = arg0.uiAnims or {}

	local var0 = arg0.uiAnims[arg1]

	local function var1()
		arg0.playing = true

		arg0:frozen()
		var0:SetActive(true)

		local var0 = tf(var0)

		pg.UIMgr.GetInstance():OverlayPanel(var0, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if arg3 then
			arg3(var0)
		end

		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			arg0.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(var0, arg0._tf)

			if arg2 then
				arg2(var0)
			end

			arg0:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not var0 then
		PoolMgr.GetInstance():GetUI(arg1, true, function(arg0)
			arg0:SetActive(true)

			arg0.uiAnims[arg1] = arg0
			var0 = arg0.uiAnims[arg1]

			var1()
		end)
	else
		var1()
	end
end

function var0.destroyUIAnims(arg0)
	if arg0.uiAnims then
		for iter0, iter1 in pairs(arg0.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(iter1), arg0._tf)
			iter1:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0, iter1)
		end

		arg0.uiAnims = nil
	end
end

function var0.doPlayTorpedo(arg0, arg1)
	local function var0()
		arg0.playing = true

		arg0:frozen()
		arg0.torpetoAni:SetActive(true)

		local var0 = tf(arg0.torpetoAni)

		var0:SetParent(arg0.topPanel, false)
		var0:SetAsLastSibling()
		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			arg0.playing = false

			SetActive(arg0.torpetoAni, false)

			if arg1 then
				arg1()
			end

			arg0:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0.torpetoAni then
		PoolMgr.GetInstance():GetUI("Torpeto", true, function(arg0)
			arg0:SetActive(true)

			arg0.torpetoAni = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.destroyTorpedo(arg0)
	if arg0.torpetoAni then
		arg0.torpetoAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", arg0.torpetoAni)

		arg0.torpetoAni = nil
	end
end

function var0.doPlayStrikeAnim(arg0, arg1, arg2, arg3)
	arg0.strikeAnims = arg0.strikeAnims or {}

	local var0
	local var1
	local var2

	local function var3()
		if coroutine.status(var2) == "suspended" then
			local var0, var1 = coroutine.resume(var2)

			assert(var0, debug.traceback(var2, var1))
		end
	end

	var2 = coroutine.create(function()
		arg0.playing = true

		arg0:frozen()

		local var0 = arg0.strikeAnims[arg2]

		setActive(var0, true)

		local var1 = tf(var0)
		local var2 = findTF(var1, "torpedo")
		local var3 = findTF(var1, "mask/painting")
		local var4 = findTF(var1, "ship")

		setParent(var0, var3:Find("fitter"), false)
		setParent(var1, var4, false)
		setActive(var4, false)
		setActive(var2, false)
		var1:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1:SetAsLastSibling()

		local var5 = var1:GetComponent("DftAniEvent")
		local var6 = var1:GetComponent("SpineAnimUI")
		local var7 = var6:GetComponent("SkeletonGraphic")

		var5:SetStartEvent(function(arg0)
			var6:SetAction("attack", 0)

			var7.freeze = true
		end)
		var5:SetTriggerEvent(function(arg0)
			var7.freeze = false

			var6:SetActionCallBack(function(arg0)
				if arg0 == "action" then
					-- block empty
				elseif arg0 == "finish" then
					var7.freeze = true
				end
			end)
		end)
		var5:SetEndEvent(function(arg0)
			var7.freeze = false

			var3()
		end)
		onButton(arg0, var1, var3, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(var3, arg1:getPainting())
		var6:SetActionCallBack(nil)

		var7.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1:getPrefab(), var1)
		setActive(var0, false)

		arg0.playing = false

		arg0:unfrozen()

		if arg3 then
			arg3()
		end
	end)

	local function var4()
		if arg0.strikeAnims[arg2] and var0 and var1 then
			var3()
		end
	end

	PoolMgr.GetInstance():GetPainting(arg1:getPainting(), true, function(arg0)
		var0 = arg0

		ShipExpressionHelper.SetExpression(var0, arg1:getPainting())
		var4()
	end)
	PoolMgr.GetInstance():GetSpineChar(arg1:getPrefab(), true, function(arg0)
		var1 = arg0
		var1.transform.localScale = Vector3.one

		var4()
	end)

	if not arg0.strikeAnims[arg2] then
		PoolMgr.GetInstance():GetUI(arg2, true, function(arg0)
			arg0.strikeAnims[arg2] = arg0

			var4()
		end)
	end
end

function var0.destroyStrikeAnim(arg0)
	if arg0.strikeAnims then
		for iter0, iter1 in pairs(arg0.strikeAnims) do
			iter1:GetComponent("DftAniEvent"):SetEndEvent(nil)
			PoolMgr.GetInstance():ReturnUI(iter0, iter1)
		end

		arg0.strikeAnims = nil
	end
end

function var0.doPlayEnemyAnim(arg0, arg1, arg2, arg3)
	arg0.strikeAnims = arg0.strikeAnims or {}

	local var0
	local var1

	local function var2()
		if coroutine.status(var1) == "suspended" then
			local var0, var1 = coroutine.resume(var1)

			assert(var0, debug.traceback(var1, var1))
		end
	end

	var1 = coroutine.create(function()
		arg0.playing = true

		arg0:frozen()

		local var0 = arg0.strikeAnims[arg2]

		setActive(var0, true)

		local var1 = tf(var0)
		local var2 = findTF(var1, "torpedo")
		local var3 = findTF(var1, "ship")

		setParent(var0, var3, false)
		setActive(var3, false)
		setActive(var2, false)
		var1:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		var1:SetAsLastSibling()

		local var4 = var1:GetComponent("DftAniEvent")
		local var5 = var0:GetComponent("SpineAnimUI")
		local var6 = var5:GetComponent("SkeletonGraphic")

		var4:SetStartEvent(function(arg0)
			var5:SetAction("attack", 0)

			var6.freeze = true
		end)
		var4:SetTriggerEvent(function(arg0)
			var6.freeze = false

			var5:SetActionCallBack(function(arg0)
				if arg0 == "action" then
					-- block empty
				elseif arg0 == "finish" then
					var6.freeze = true
				end
			end)
		end)
		var4:SetEndEvent(function(arg0)
			var6.freeze = false

			var2()
		end)
		onButton(arg0, var1, var2, SFX_CANCEL)
		coroutine.yield()
		var5:SetActionCallBack(nil)

		var6.freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(arg1:getPrefab(), var0)
		setActive(var0, false)

		arg0.playing = false

		arg0:unfrozen()

		if arg3 then
			arg3()
		end
	end)

	local function var3()
		if arg0.strikeAnims[arg2] and var0 then
			var2()
		end
	end

	PoolMgr.GetInstance():GetSpineChar(arg1:getPrefab(), true, function(arg0)
		var0 = arg0
		var0.transform.localScale = Vector3.one

		var3()
	end)

	if not arg0.strikeAnims[arg2] then
		PoolMgr.GetInstance():GetUI(arg2, true, function(arg0)
			arg0.strikeAnims[arg2] = arg0

			var3()
		end)
	end
end

function var0.doSignalSearch(arg0, arg1)
	arg0:frozen()

	local function var0()
		arg0.playing = true

		arg0.signalAni:SetActive(true)

		local var0 = tf(arg0.signalAni)

		var0:SetParent(arg0.topPanel, false)
		var0:SetAsLastSibling()
		var0:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			arg0.playing = false

			SetActive(arg0.signalAni, false)

			if arg1 then
				arg1()
			end

			arg0:unfrozen()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not arg0.signalAni then
		PoolMgr.GetInstance():GetUI("SignalUI", true, function(arg0)
			arg0:SetActive(true)

			arg0.signalAni = arg0

			var0()
		end)
	else
		var0()
	end
end

function var0.destroySignalSearch(arg0)
	if arg0.signalAni then
		arg0.signalAni:GetComponent("DftAniEvent"):SetEndEvent(nil)
		PoolMgr.GetInstance():ReturnUI("SignalUI", arg0.signalAni)

		arg0.signalAni = nil
	end
end

function var0.doPlayCommander(arg0, arg1, arg2)
	arg0:frozen()
	setActive(arg0.commanderTinkle, true)

	local var0 = arg1:getSkills()

	setText(arg0.commanderTinkle:Find("name"), #var0 > 0 and var0[1]:getConfig("name") or "")
	setImageSprite(arg0.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. arg1:getConfig("painting"), ""))

	local var1 = arg0.commanderTinkle:GetComponent(typeof(CanvasGroup))

	var1.alpha = 0

	local var2 = Vector2(248, 237)

	LeanTween.value(go(arg0.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0)
		local var0 = arg0.commanderTinkle.localPosition

		var0.x = var2.x + -100 * (1 - arg0)
		arg0.commanderTinkle.localPosition = var0
		var1.alpha = arg0
	end)):setEase(LeanTweenType.easeOutSine)
	LeanTween.value(go(arg0.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function(arg0)
		local var0 = arg0.commanderTinkle.localPosition

		var0.x = var2.x + 100 * arg0
		arg0.commanderTinkle.localPosition = var0
		var1.alpha = 1 - arg0
	end)):setOnComplete(System.Action(function()
		if arg2 then
			arg2()
		end

		arg0:unfrozen()
	end))
end

function var0.strikeEnemy(arg0, arg1, arg2, arg3)
	local var0 = arg0.grid:shakeCell(arg1)

	if not var0 then
		arg3()

		return
	end

	arg0:easeDamage(var0, arg2, function()
		arg3()
	end)
end

function var0.easeDamage(arg0, arg1, arg2, arg3)
	arg0:frozen()

	local var0 = arg0.levelCam:WorldToScreenPoint(arg1.position)
	local var1 = tf(arg0:GetDamageText())

	var1.position = arg0.uiCam:ScreenToWorldPoint(var0)

	local var2 = var1.localPosition

	var2.y = var2.y + 40
	var2.z = 0

	setText(var1, arg2)

	var1.localPosition = var2

	LeanTween.value(go(var1), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
		local var0 = var1.localPosition

		var0.y = var2.y + 60 * arg0
		var1.localPosition = var0

		setTextAlpha(var1, 1 - arg0)
	end)):setOnComplete(System.Action(function()
		arg0:ReturnDamageText(var1)
		arg0:unfrozen()

		if arg3 then
			arg3()
		end
	end))
end

function var0.easeAvoid(arg0, arg1, arg2)
	arg0:frozen()

	local var0 = arg0.levelCam:WorldToScreenPoint(arg1)

	arg0.avoidText.position = arg0.uiCam:ScreenToWorldPoint(var0)

	local var1 = arg0.avoidText.localPosition

	var1.z = 0
	arg0.avoidText.localPosition = var1

	setActive(arg0.avoidText, true)

	local var2 = arg0.avoidText:Find("avoid")

	LeanTween.value(go(arg0.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
		local var0 = arg0.avoidText.localPosition

		var0.y = var1.y + 100 * arg0
		arg0.avoidText.localPosition = var0

		setImageAlpha(arg0.avoidText, 1 - arg0)
		setImageAlpha(var2, 1 - arg0)
	end)):setOnComplete(System.Action(function()
		setActive(arg0.avoidText, false)
		arg0:unfrozen()

		if arg2 then
			arg2()
		end
	end))
end

function var0.GetDamageText(arg0)
	local var0 = table.remove(arg0.damageTextPool)

	if not var0 then
		var0 = Instantiate(arg0.damageTextTemplate)

		local var1 = tf(arg0.damageTextTemplate):GetSiblingIndex()

		setParent(var0, tf(arg0.damageTextTemplate).parent)
		tf(var0):SetSiblingIndex(var1 + 1)
	end

	table.insert(arg0.damageTextActive, var0)
	setActive(var0, true)

	return var0
end

function var0.ReturnDamageText(arg0, arg1)
	assert(arg1)

	if not arg1 then
		return
	end

	arg1 = go(arg1)

	table.removebyvalue(arg0.damageTextActive, arg1)
	table.insert(arg0.damageTextPool, arg1)
	setActive(arg1, false)
end

function var0.resetLevelGrid(arg0)
	arg0.dragLayer.localPosition = Vector3.zero
end

function var0.ShowCurtains(arg0, arg1)
	setActive(arg0.curtain, arg1)
end

function var0.frozen(arg0)
	local var0 = arg0.frozenCount

	arg0.frozenCount = arg0.frozenCount + 1
	arg0.canvasGroup.blocksRaycasts = arg0.frozenCount == 0

	if var0 == 0 and arg0.frozenCount ~= 0 then
		arg0:emit(LevelUIConst.ON_FROZEN)
	end
end

function var0.unfrozen(arg0, arg1)
	if arg0.exited then
		return
	end

	local var0 = arg0.frozenCount
	local var1 = arg1 == -1 and arg0.frozenCount or arg1 or 1

	arg0.frozenCount = arg0.frozenCount - var1
	arg0.canvasGroup.blocksRaycasts = arg0.frozenCount == 0

	if var0 ~= 0 and arg0.frozenCount == 0 then
		arg0:emit(LevelUIConst.ON_UNFROZEN)
	end
end

function var0.isfrozen(arg0)
	return arg0.frozenCount > 0
end

function var0.enableLevelCamera(arg0)
	arg0.levelCamIndices = math.max(arg0.levelCamIndices - 1, 0)

	if arg0.levelCamIndices == 0 then
		arg0.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0.disableLevelCamera(arg0)
	arg0.levelCamIndices = arg0.levelCamIndices + 1

	if arg0.levelCamIndices > 0 then
		arg0.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

function var0.RecordTween(arg0, arg1, arg2)
	arg0.tweens[arg1] = arg2
end

function var0.DeleteTween(arg0, arg1)
	local var0 = arg0.tweens[arg1]

	if var0 then
		LeanTween.cancel(var0)

		arg0.tweens[arg1] = nil
	end
end

function var0.openCommanderPanel(arg0, arg1, arg2, arg3)
	local var0 = arg2.id

	arg0.levelCMDFormationView:setCallback(function(arg0)
		if not arg3 then
			if arg0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				arg0:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0.skill)
			elseif arg0.type == LevelUIConst.COMMANDER_OP_ADD then
				arg0.contextData.commanderSelected = {
					chapterId = var0,
					fleetId = arg1.id
				}

				arg0:emit(LevelMediator2.ON_SELECT_COMMANDER, arg0.pos, arg1.id, arg2)
				arg0:closeCommanderPanel()
			else
				arg0:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = arg0,
					fleetId = arg1.id,
					chapterId = var0
				}, arg2)
			end
		elseif arg0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0:emit(LevelMediator2.ON_COMMANDER_SKILL, arg0.skill)
		elseif arg0.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0.contextData.eliteCommanderSelected = {
				index = arg3,
				pos = arg0.pos,
				chapterId = var0
			}

			arg0:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, arg3, arg0.pos, arg2)
			arg0:closeCommanderPanel()
		else
			arg0:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = arg0,
				index = arg3,
				chapterId = var0
			}, arg2)
		end
	end)
	arg0.levelCMDFormationView:Load()
	arg0.levelCMDFormationView:ActionInvoke("update", arg1, arg0.commanderPrefabs)
	arg0.levelCMDFormationView:ActionInvoke("Show")
end

function var0.updateCommanderPrefab(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0.commanderPrefabs)
	end
end

function var0.closeCommanderPanel(arg0)
	arg0.levelCMDFormationView:ActionInvoke("Hide")
end

function var0.destroyCommanderPanel(arg0)
	arg0.levelCMDFormationView:Destroy()

	arg0.levelCMDFormationView = nil
end

function var0.setSpecialOperationTickets(arg0, arg1)
	arg0.spTickets = arg1
end

function var0.HandleShowMsgBox(arg0, arg1)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1)
end

function var0.updatePoisonAreaTip(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = (function(arg0)
		local var0 = {}
		local var1 = pg.map_event_list[var0.id] or {}
		local var2

		if var0:isLoop() then
			var2 = var1.event_list_loop or {}
		else
			var2 = var1.event_list or {}
		end

		for iter0, iter1 in ipairs(var2) do
			local var3 = pg.map_event_template[iter1]

			if var3.c_type == arg0 then
				table.insert(var0, var3)
			end
		end

		return var0
	end)(ChapterConst.EvtType_Poison)

	if var1 then
		for iter0, iter1 in ipairs(var1) do
			local var2 = iter1.round_gametip

			if var2 ~= nil and var2 ~= "" and var0:getRoundNum() == var2[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2[2]))
			end
		end
	end
end

function var0.updateVoteBookBtn(arg0)
	setActive(arg0._voteBookBtn, false)
end

function var0.RecordLastMapOnExit(arg0)
	local var0 = getProxy(ChapterProxy)

	if var0 and not arg0.contextData.noRecord then
		local var1 = arg0.contextData.map

		if not var1 then
			return
		end

		if var1 and var1:NeedRecordMap() then
			var0:recordLastMap(ChapterProxy.LAST_MAP, var1.id)
		end

		if Map.lastMapForActivity then
			var0:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, Map.lastMapForActivity)
		end
	end
end

function var0.willExit(arg0)
	arg0:ClearMapTransitions()
	arg0.loader:Clear()

	if arg0.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.topPanel, arg0._tf)
		pg.playerResUI:SetActive({
			active = false
		})
	end

	if arg0.levelFleetView and arg0.levelFleetView.selectIds then
		arg0.contextData.selectedFleetIDs = {}

		for iter0, iter1 in pairs(arg0.levelFleetView.selectIds) do
			for iter2, iter3 in pairs(iter1) do
				arg0.contextData.selectedFleetIDs[#arg0.contextData.selectedFleetIDs + 1] = iter3
			end
		end
	end

	arg0:destroyChapterPanel()
	arg0:destroyFleetEdit()
	arg0:destroyCommanderPanel()
	arg0:DestroyLevelStageView()
	arg0:hideRepairWindow()
	arg0:hideStrategyInfo()
	arg0:hideRemasterPanel()
	arg0:hideSpResult()
	arg0:destroyGrid()
	arg0:destroyAmbushWarn()
	arg0:destroyAirStrike()
	arg0:destroyTorpedo()
	arg0:destroyStrikeAnim()
	arg0:destroyTracking()
	arg0:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for iter4, iter5 in pairs(arg0.mbDict) do
		iter5:Destroy()
	end

	arg0.mbDict = nil

	for iter6, iter7 in pairs(arg0.tweens) do
		LeanTween.cancel(iter7)
	end

	arg0.tweens = nil

	if arg0.cloudTimer then
		_.each(arg0.cloudTimer, function(arg0)
			LeanTween.cancel(arg0)
		end)

		arg0.cloudTimer = nil
	end

	if arg0.newChapterCDTimer then
		arg0.newChapterCDTimer:Stop()

		arg0.newChapterCDTimer = nil
	end

	for iter8, iter9 in ipairs(arg0.damageTextActive) do
		LeanTween.cancel(iter9)
	end

	LeanTween.cancel(go(arg0.avoidText))

	arg0.map.localScale = Vector3.one
	arg0.map.pivot = Vector2(0.5, 0.5)
	arg0.float.localScale = Vector3.one
	arg0.float.pivot = Vector2(0.5, 0.5)

	for iter10, iter11 in ipairs(arg0.mapTFs) do
		clearImageSprite(iter11)
	end

	_.each(arg0.cloudRTFs, function(arg0)
		clearImageSprite(arg0)
	end)
	PoolMgr.GetInstance():DestroyAllSprite()
	Destroy(arg0.enemyTpl)
	arg0:RecordLastMapOnExit()
	arg0.levelRemasterView:Destroy()
end

return var0
