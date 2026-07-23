local var0_0 = class("MapBuilderSPSeries", import(".MapBuilder"))

var0_0.DISPLAY = {
	STORY = 2,
	BATTLE = 1
}
var0_0.DIFFICULITY = {
	EASY = 1,
	HARD = 2
}

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPESPSERIES
end

function var0_0.getUIName(arg0_2)
	return "LevelSelectSPSeriesUI"
end

function var0_0.OnLoaded(arg0_3)
	setParent(arg0_3._tf, arg0_3._parentTf)
	arg0_3._tf:SetSiblingIndex(4)
end

function var0_0.OnInit(arg0_4)
	arg0_4.battleLayer = arg0_4._tf:Find("Battle")
	arg0_4.storyLayer = arg0_4._tf:Find("Story")
	arg0_4.top = arg0_4._tf:Find("Top")
	arg0_4.itemHolder = arg0_4._tf:Find("Battle/Nodes")
	arg0_4.chapterTpl = arg0_4.itemHolder:Find("LevelTpl")
	arg0_4.storyHolder = arg0_4._tf:Find("Story/Nodes")
	arg0_4.storyNodeTpl = arg0_4.storyHolder:Find("tpl")

	setActive(arg0_4.storyNodeTpl, false)

	arg0_4.progressText = arg0_4._tf:Find("Story/Desc/Text")
	arg0_4.storyAward = arg0_4._tf:Find("Story/Award")
	arg0_4.activeItems = {}
	arg0_4.displayChapterIDs = {}
	arg0_4.chapterTFsById = {}
	arg0_4.storyNodeTFsById = {}

	arg0_4:bind(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, function(arg0_5, arg1_5)
		arg0_4:SwitchChapter(arg1_5)
	end)
	onButton(arg0_4, arg0_4.battleLayer:Find("Story/Switch"), function()
		arg0_4:SetDisplayMode(var0_0.DISPLAY.STORY)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.storyLayer:Find("Battle/Switch"), function()
		arg0_4:SetDisplayMode(var0_0.DISPLAY.BATTLE)
	end, SFX_PANEL)
	setText(arg0_4.storyLayer:Find("Desc/Desc"), i18n("series_enemy_storyreward"))
end

function var0_0.OnShow(arg0_8)
	var0_0.super.OnShow(arg0_8)
	setActive(arg0_8.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0_8.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0_8.sceneParent.topChapter:Find("type_chapter"), true)

	arg0_8.needFocusStory = true
end

function var0_0.UpdateButtons(arg0_9)
	var0_0.super.UpdateButtons(arg0_9)

	local var0_9, var1_9 = arg0_9.contextData.map:isActivity()
	local var2_9 = arg0_9.contextData.map:isRemaster()
	local var3_9 = arg0_9.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_9.sceneParent.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and var3_9 and not var2_9 and var1_9 and arg0_9.sceneParent:IsActShopActive())

	local var4_9 = arg0_9.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_9.contextData.map:getConfig("on_activity")) or nil
	local var5_9 = var4_9 and not var4_9:isEnd() and var4_9:GetConfigClientSetting("PTID")

	arg0_9.sceneParent:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_10)
		return arg0_10:getConfig("config_id") == var5_9
	end))
	setActive(arg0_9.sceneParent.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var2_9 and var1_9 and arg0_9.sceneParent.ptActivity and not arg0_9.sceneParent.ptActivity:isEnd() and var3_9)
end

function var0_0.OnHide(arg0_11)
	setActive(arg0_11.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_11.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_11.sceneParent.topChapter:Find("type_chapter"), false)
	setActive(arg0_11.sceneParent.ptTotal, false)
	setActive(arg0_11.sceneParent.actExchangeShopBtn, false)
	var0_0.super.OnHide(arg0_11)
end

function var0_0.UpdateMapVO(arg0_12, arg1_12)
	var0_0.super.UpdateMapVO(arg0_12, arg1_12)

	arg0_12.activity = getProxy(ActivityProxy):getActivityById(arg1_12:getConfig("on_activity"))

	local var0_12 = getProxy(PlayerProxy):getRawData().id
	local var1_12 = arg1_12:getConfig("chapterGroups")

	arg0_12.chapterGroups = _.map(var1_12, function(arg0_13)
		local var0_13 = arg0_13[1]
		local var1_13 = PlayerPrefs.GetInt("spchapter_selected_" .. var0_12 .. "_" .. var0_13, var0_0.DIFFICULITY.EASY)

		return {
			list = arg0_13,
			index = var1_13
		}
	end)
	arg0_12.chapterGroupDict = {}

	_.each(arg0_12.chapterGroups, function(arg0_14)
		_.each(arg0_14.list, function(arg0_15)
			arg0_12.chapterGroupDict[arg0_15] = arg0_14
		end)
	end)

	arg0_12.displayChapterIDs = _.map(arg0_12.chapterGroups, function(arg0_16)
		return arg0_16.list[arg0_16.index]
	end)
	arg0_12.storyNodesDict = {}

	for iter0_12, iter1_12 in ipairs(arg0_12.activity:getConfig("config_client").storys) do
		arg0_12.storyNodesDict[iter1_12] = BossRushStoryNode.New({
			id = iter1_12
		})

		local var2_12 = arg0_12.storyHolder:Find(tostring(iter1_12)) or cloneTplTo(arg0_12.storyNodeTpl, arg0_12.storyHolder, iter1_12)
		local var3_12 = arg0_12.storyNodesDict[iter1_12]:getConfigTable()

		setLocalPosition(var2_12, {
			x = 1920 * tonumber(var3_12.pos_x),
			y = 1080 * tonumber(var3_12.pos_y)
		})
	end
end

function var0_0.UpdateBonusPtIconPath(arg0_17)
	arg0_17.bonusPtIconPath = nil

	local var0_17 = arg0_17.data or arg0_17.contextData.map

	if not var0_17 then
		return
	end

	local var1_17 = var0_17:getConfig("on_activity")

	if not var1_17 or var1_17 == 0 then
		return
	end

	local var2_17 = getProxy(ActivityProxy)
	local var3_17 = var2_17:getActivityById(var1_17)

	if not var3_17 or var3_17:isEnd() then
		return
	end

	local var4_17 = var3_17:GetConfigClientSetting("PTID")

	if not var4_17 then
		return
	end

	local var5_17 = underscore.detect(var2_17:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_18)
		return arg0_18 and not arg0_18:isEnd() and arg0_18:getConfig("config_id") == var4_17
	end)

	if not var5_17 then
		return
	end

	local var6_17 = tonumber(var5_17:getConfig("config_id"))

	if not var6_17 then
		return
	end

	arg0_17.bonusPtIconPath = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var6_17
	}):getIcon()
end

function var0_0.SetDisplayMode(arg0_19, arg1_19)
	if arg1_19 == arg0_19.contextData.displayMode then
		return
	end

	arg0_19.contextData.displayMode = arg1_19

	arg0_19:UpdateView()
end

function var0_0.UpdateView(arg0_20)
	local var0_20 = string.split(arg0_20.contextData.map:getConfig("name"), "||")

	if arg0_20.contextData.displayMode == var0_0.DISPLAY.STORY then
		var0_20 = string.split(var0_20[1], "·")

		setText(arg0_20.sceneParent.chapterName, var0_20[1] .. i18n("levelscene_title_story"))
	else
		setText(arg0_20.sceneParent.chapterName, var0_20[1])
	end

	local var1_20 = arg0_20.contextData.map:getMapTitleNumber()

	arg0_20.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_20, arg0_20.sceneParent.chapterNoTitle, true)

	arg0_20.contextData.displayMode = arg0_20.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_20)

	local var2_20 = arg0_20.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_20._tf:Find("Battle"), var2_20)
	setActive(arg0_20._tf:Find("Story"), not var2_20)

	local var3_20 = getProxy(ChapterProxy):IsActivitySPChapterActive(arg0_20.contextData.map:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_20.battleLayer:Find("Story/BattleTip"), false)
	setActive(arg0_20.storyLayer:Find("Battle/BattleTip"), var3_20)
	arg0_20:UpdateStoryTask()

	if var2_20 then
		arg0_20:UpdateBonusPtIconPath()
		arg0_20:UpdateBattle()
		arg0_20.sceneParent:SwitchMapBG(arg0_20.contextData.map)
		arg0_20.sceneParent:PlayBGM()
	else
		arg0_20:UpdateStory()
		arg0_20:SwitchStoryMapAndBGM()
	end

	arg0_20:TrySubmitTask()
end

function var0_0.UpdateBattle(arg0_21)
	local var0_21 = getProxy(ChapterProxy)
	local var1_21 = arg0_21.displayChapterIDs
	local var2_21 = {}

	for iter0_21, iter1_21 in ipairs(var1_21) do
		local var3_21 = var0_21:getChapterById(iter1_21)

		table.insert(var2_21, var3_21)
	end

	table.clear(arg0_21.chapterTFsById)
	UIItemList.StaticAlign(arg0_21.itemHolder, arg0_21.chapterTpl, #var2_21, function(arg0_22, arg1_22, arg2_22)
		if arg0_22 ~= UIItemList.EventUpdate then
			return
		end

		local var0_22 = var2_21[arg1_22 + 1]

		arg0_21:UpdateMapItem(arg2_22, var0_22)

		arg2_22.name = "Chapter_" .. var0_22.id
		arg0_21.chapterTFsById[var0_22.id] = arg2_22
	end)
end

function var0_0.HideFloat(arg0_23)
	var0_0.super.HideFloat(arg0_23)
	setActive(arg0_23.itemHolder, false)
end

function var0_0.ShowFloat(arg0_24)
	var0_0.super.ShowFloat(arg0_24)
	setActive(arg0_24.itemHolder, true)
end

function var0_0.UpdateMapItem(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg2_25:getConfigTable()

	warning(1920 * var0_25.pos_x, 1080 * var0_25.pos_y)
	setLocalPosition(arg1_25, {
		x = 1920 * var0_25.pos_x,
		y = 1080 * var0_25.pos_y
	})

	local var1_25 = findTF(arg1_25, "main")

	setActive(var1_25, true)

	local var2_25 = findTF(var1_25, "circle/fordark")
	local var3_25 = findTF(var1_25, "info/bk/fordark")

	setActive(var2_25, var0_25.icon_outline == 1)
	setActive(var3_25, var0_25.icon_outline == 1)

	local var4_25 = arg0_25.chapterGroupDict[arg2_25.id]

	assert(var4_25)

	local var5_25 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_25 = 1

	if arg2_25:isUnlock() then
		var6_25 = 2

		if #var4_25.list > 1 then
			var6_25 = table.indexof(var4_25.list, arg2_25.id) + 1
		elseif arg2_25:IsSpChapter() or arg2_25:IsEXChapter() then
			var6_25 = 3
		elseif arg0_25.contextData.map:isHardMap() then
			var6_25 = 3
		end
	end

	local var7_25 = findTF(var1_25, "circle/bk")

	for iter0_25, iter1_25 in ipairs(var5_25) do
		setActive(var7_25:Find(iter1_25), iter0_25 == var6_25)
	end

	local var8_25 = findTF(var1_25, "circle/clear_flag")
	local var9_25 = findTF(var1_25, "circle/lock")
	local var10_25 = findTF(var1_25, "circle/progress")
	local var11_25 = findTF(var1_25, "circle/progress_text")
	local var12_25 = findTF(var1_25, "circle/stars")
	local var13_25 = string.split(var0_25.name, "|")

	setText(findTF(var1_25, "info/bk/title_form/title_index"), var0_25.chapter_name .. "  ")
	setText(findTF(var1_25, "info/bk/title_form/title"), var13_25[1])
	setText(findTF(var1_25, "info/bk/title_form/title_en"), var13_25[2] or "")
	setFillAmount(var10_25, arg2_25.progress / 100)
	setText(var11_25, string.format("%d%%", arg2_25.progress))
	setActive(var12_25, arg2_25:existAchieve())

	if arg2_25:existAchieve() then
		for iter2_25, iter3_25 in ipairs(arg2_25.achieves) do
			local var14_25 = ChapterConst.IsAchieved(iter3_25)
			local var15_25 = var12_25:GetChild(iter2_25 - 1):Find("light")

			setActive(var15_25, var14_25)

			for iter4_25, iter5_25 in ipairs(var5_25) do
				if iter5_25 ~= "Lock" then
					setActive(var15_25:Find(iter5_25), iter4_25 == var6_25)
				end
			end
		end
	end

	local var16_25 = findTF(var1_25, "info/bk/BG")

	for iter6_25, iter7_25 in ipairs(var5_25) do
		setActive(var16_25:Find(iter7_25), iter6_25 == var6_25)
	end

	setActive(findTF(var1_25, "HardEffect"), var6_25 == 3)

	local var17_25 = not arg2_25.active and arg2_25:isClear()
	local var18_25 = not arg2_25.active and not arg2_25:isUnlock()

	setActive(var8_25, var17_25)
	setActive(var9_25, var18_25)
	setActive(var11_25, not var17_25 and not var18_25)
	arg0_25:DeleteTween("fighting" .. arg2_25.id)

	local var19_25 = findTF(var1_25, "circle/fighting")

	setText(findTF(var19_25, "Text"), i18n("tag_level_fighting"))

	local var20_25 = findTF(var1_25, "circle/oni")

	setText(findTF(var20_25, "Text"), i18n("tag_level_oni"))

	local var21_25 = findTF(var1_25, "circle/narrative")

	setText(findTF(var21_25, "Text"), i18n("tag_level_narrative"))
	setActive(var19_25, false)
	setActive(var20_25, false)
	setActive(var21_25, false)

	local var22_25
	local var23_25

	if arg2_25:getConfig("chapter_tag") == 1 then
		var22_25 = var21_25
	end

	if arg2_25.active then
		var22_25 = arg2_25:existOni() and var20_25 or var19_25
	end

	if var22_25 then
		setActive(var22_25, true)

		local var24_25 = GetOrAddComponent(var22_25, "CanvasGroup")

		var24_25.alpha = 1

		arg0_25:RecordTween("fighting" .. arg2_25.id, LeanTween.alphaCanvas(var24_25, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_25 = findTF(var1_25, "triesLimit")
	local var26_25 = arg2_25:isTriesLimit()

	setActive(var25_25, var26_25)

	if var26_25 then
		local var27_25 = arg2_25:getConfig("count")
		local var28_25 = var27_25 - arg2_25:getTodayDefeatCount() .. "/" .. var27_25

		setText(var25_25:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_25:Find("Text"), setColorStr(var28_25, var27_25 <= arg2_25:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_25 = pg.expedition_data_by_map[arg2_25:getConfig("map")].on_activity
		local var30_25 = getProxy(ChapterProxy):IsActivitySPChapterActive(var29_25) and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_25:Find("TipRect"), var30_25)
	end

	local var31_25 = arg2_25:GetDailyBonusQuota()
	local var32_25 = findTF(var1_25, "mark")
	local var33_25 = var32_25:Find("bonus")
	local var34_25 = var33_25:Find("icon")
	local var35_25 = findTF(var33_25, "icon/Image")

	setActive(var33_25, var31_25)
	setActive(var32_25, var31_25)

	if var34_25 then
		setActive(var34_25, var31_25 and arg0_25.bonusPtIconPath)
	end

	if var31_25 then
		local var36_25 = var32_25:GetComponent(typeof(CanvasGroup))
		local var37_25 = arg2_25:GetDailyBonusIconName()

		arg0_25.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var37_25, var33_25)

		if var34_25 and arg0_25.bonusPtIconPath then
			if var35_25 then
				GetImageSpriteFromAtlasAsync(arg0_25.bonusPtIconPath, "", var35_25, true)
			else
				GetImageSpriteFromAtlasAsync(arg0_25.bonusPtIconPath, "", var34_25, true)
			end
		end

		LeanTween.cancel(go(var32_25), true)

		local var38_25 = var32_25.anchoredPosition.y

		var36_25.alpha = 0

		LeanTween.value(go(var32_25), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_26)
			var36_25.alpha = arg0_26

			local var0_26 = var32_25.anchoredPosition

			var0_26.y = var38_25 * arg0_26
			var32_25.anchoredPosition = var0_26
		end)):setOnComplete(System.Action(function()
			var36_25.alpha = 1

			local var0_27 = var32_25.anchoredPosition

			var0_27.y = var38_25
			var32_25.anchoredPosition = var0_27
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var39_25 = arg2_25.id

	onButton(arg0_25, var1_25, function()
		arg0_25:TryOpenChapterInfo(var39_25, nil, var4_25.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
	arg0_25:PlayerLevelTplAnimation(arg1_25, {
		status = var5_25[var6_25],
		chapterVO = arg2_25
	})
end

function var0_0.PlayerLevelTplAnimation(arg0_29, arg1_29, arg2_29)
	return
end

function var0_0.SwitchChapter(arg0_30, arg1_30)
	local var0_30 = arg0_30.chapterGroupDict[arg1_30]

	if not var0_30 then
		return
	end

	local var1_30 = var0_30.list[var0_30.index]

	if var1_30 == arg1_30 then
		return
	end

	local var2_30 = table.indexof(var0_30.list, arg1_30)

	var0_30.index = var2_30

	local var3_30 = var0_30.list[1]
	local var4_30 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("spchapter_selected_" .. var4_30 .. "_" .. var3_30, var2_30)

	local var5_30 = arg0_30.chapterTFsById[var1_30]

	arg0_30.chapterTFsById[var1_30] = nil
	arg0_30.chapterTFsById[arg1_30] = var5_30

	arg0_30:UpdateChapterTF(arg1_30)
end

function var0_0.UpdateChapterTF(arg0_31, arg1_31)
	if not arg0_31.chapterGroupDict[arg1_31] then
		return
	end

	local var0_31 = arg0_31.chapterTFsById[arg1_31]

	if var0_31 then
		local var1_31 = getProxy(ChapterProxy):getChapterById(arg1_31)

		arg0_31:UpdateMapItem(var0_31, var1_31)
	end
end

function var0_0.UpdateStory(arg0_32)
	local var0_32 = {}
	local var1_32 = pg.NewStoryMgr.GetInstance()
	local var2_32 = 0
	local var3_32 = 0

	for iter0_32, iter1_32 in pairs(arg0_32.storyNodesDict) do
		local var4_32 = arg0_32.storyHolder:Find(tostring(iter1_32.id))
		local var5_32 = iter1_32:IsActive(arg0_32.activity, arg0_32.sceneParent.ptActivity)

		setActive(var4_32, var5_32)
		setText(var4_32:Find("main/char/bg/Text"), iter1_32:GetName())

		local var6_32 = iter1_32:IsReaded()

		setActive(var4_32:Find("main/char"), not var6_32)
		setActive(var4_32:Find("main/talk"), var6_32)
		onButton(arg0_32, var4_32, function()
			if var6_32 then
				return
			end

			local var0_33 = iter1_32:GetStory()

			arg0_32:PlayStory(var0_33, function()
				arg0_32:UpdateView()
			end)
		end)

		var2_32 = var2_32 + (var6_32 and 1 or 0)
		var3_32 = var3_32 + 1
	end

	setText(arg0_32.progressText, var2_32 .. "/" .. var3_32)
	setActive(arg0_32.storyAward, tobool(arg0_32.storyTask))

	if arg0_32.storyTask then
		local var7_32 = arg0_32.storyTask:getConfig("award_display")
		local var8_32 = Drop.Create(var7_32[1])

		updateDrop(arg0_32.storyAward:GetChild(0), var8_32)

		local var9_32 = arg0_32.storyTask:getTaskStatus()

		setActive(arg0_32.storyAward:Find("get"), var9_32 == 1)
		setActive(arg0_32.storyAward:Find("got"), var9_32 == 2)
		onButton(arg0_32, arg0_32.storyAward, function()
			arg0_32:emit(BaseUI.ON_DROP, var8_32)
		end)
	end
end

function var0_0.SwitchStoryMapAndBGM(arg0_36)
	local var0_36 = arg0_36.data:getConfig("default_background")
	local var1_36 = arg0_36.data:getConfig("default_bgm")
	local var2_36
	local var3_36 = underscore.keys(arg0_36.storyNodesDict)

	table.sort(var3_36)

	for iter0_36 = 1, #var3_36 do
		local var4_36 = arg0_36.storyNodesDict[var3_36[iter0_36]]

		if var4_36:IsReaded() then
			var0_36 = defaultValue(var4_36:GetCleanBG(), var0_36)
			var1_36 = defaultValue(var4_36:GetCleanBGM(), var1_36)
			var2_36 = defaultValue(var4_36:GetCleanAnimator(), var2_36)
		else
			break
		end
	end

	arg0_36.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_36,
			Animator = var2_36
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_36.__cname, var1_36)
end

function var0_0.TrySubmitTask(arg0_37)
	if underscore.all(underscore.values(arg0_37.storyNodesDict), function(arg0_38)
		return arg0_38:IsReaded()
	end) and arg0_37.storyTask and arg0_37.storyTask:getTaskStatus() == 1 then
		arg0_37:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_37.storyTask.id)

		return
	end
end

function var0_0.TryOpenChapter(arg0_39, arg1_39)
	local var0_39 = arg0_39.chapterTFsById[arg1_39]

	if var0_39 then
		local var1_39 = var0_39:Find("main")

		triggerButton(var1_39)
	end
end

function var0_0.PlayStory(arg0_40, arg1_40, arg2_40, arg3_40)
	if not arg1_40 then
		return existCall(arg2_40)
	end

	local var0_40 = pg.NewStoryMgr.GetInstance()
	local var1_40 = var0_40:IsPlayed(arg1_40)

	seriesAsync({
		function(arg0_41)
			if var1_40 and not arg3_40 then
				return arg0_41()
			end

			local var0_41 = tonumber(arg1_40)

			if var0_41 and var0_41 > 0 then
				arg0_40:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_41, nil, var1_40)
			else
				var0_40:Play(arg1_40, arg0_41, arg3_40)
			end
		end,
		function(arg0_42, ...)
			existCall(arg2_40, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_43)
	local var0_43 = arg0_43.activity:getConfig("config_client").task_id
	local var1_43 = getProxy(TaskProxy):getTaskVO(var0_43)

	if not var1_43 then
		errorMsg("Missing Activity Task ID : " .. var0_43)
	end

	print(var0_43)

	arg0_43.storyTask = var1_43 or Task.New({
		id = var0_43
	})
end

function var0_0.OnSubmitTaskDone(arg0_44)
	arg0_44:UpdateView()
end

function var0_0.OnDestroy(arg0_45)
	return
end

return var0_0
