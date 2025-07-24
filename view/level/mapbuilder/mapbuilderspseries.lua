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

		setAnchoredPosition(var2_12, {
			x = arg0_12.mapWidth * tonumber(var3_12.pos_x),
			y = arg0_12.mapHeight * tonumber(var3_12.pos_y)
		})
	end
end

function var0_0.SetDisplayMode(arg0_17, arg1_17)
	if arg1_17 == arg0_17.contextData.displayMode then
		return
	end

	arg0_17.contextData.displayMode = arg1_17

	arg0_17:UpdateView()
end

function var0_0.UpdateView(arg0_18)
	local var0_18 = string.split(arg0_18.contextData.map:getConfig("name"), "||")

	if arg0_18.contextData.displayMode == var0_0.DISPLAY.STORY then
		var0_18 = string.split(var0_18[1], "·")

		setText(arg0_18.sceneParent.chapterName, var0_18[1] .. i18n("levelscene_title_story"))
	else
		setText(arg0_18.sceneParent.chapterName, var0_18[1])
	end

	local var1_18 = arg0_18.contextData.map:getMapTitleNumber()

	arg0_18.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_18, arg0_18.sceneParent.chapterNoTitle, true)

	arg0_18.contextData.displayMode = arg0_18.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_18)

	local var2_18 = arg0_18.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_18._tf:Find("Battle"), var2_18)
	setActive(arg0_18._tf:Find("Story"), not var2_18)

	local var3_18 = getProxy(ChapterProxy):IsActivitySPChapterActive(arg0_18.contextData.map:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_18.battleLayer:Find("Story/BattleTip"), false)
	setActive(arg0_18.storyLayer:Find("Battle/BattleTip"), var3_18)
	arg0_18:UpdateStoryTask()

	if var2_18 then
		arg0_18:UpdateBattle()
		arg0_18.sceneParent:SwitchMapBG(arg0_18.contextData.map)
		arg0_18.sceneParent:PlayBGM()
	else
		arg0_18:UpdateStory()
		arg0_18:SwitchStoryMapAndBGM()
	end

	arg0_18:TrySubmitTask()
end

function var0_0.UpdateBattle(arg0_19)
	local var0_19 = getProxy(ChapterProxy)
	local var1_19 = arg0_19.displayChapterIDs
	local var2_19 = {}

	for iter0_19, iter1_19 in ipairs(var1_19) do
		local var3_19 = var0_19:getChapterById(iter1_19)

		table.insert(var2_19, var3_19)
	end

	table.clear(arg0_19.chapterTFsById)
	UIItemList.StaticAlign(arg0_19.itemHolder, arg0_19.chapterTpl, #var2_19, function(arg0_20, arg1_20, arg2_20)
		if arg0_20 ~= UIItemList.EventUpdate then
			return
		end

		local var0_20 = var2_19[arg1_20 + 1]

		arg0_19:UpdateMapItem(arg2_20, var0_20)

		arg2_20.name = "Chapter_" .. var0_20.id
		arg0_19.chapterTFsById[var0_20.id] = arg2_20
	end)
end

function var0_0.HideFloat(arg0_21)
	var0_0.super.HideFloat(arg0_21)
	setActive(arg0_21.itemHolder, false)
end

function var0_0.ShowFloat(arg0_22)
	var0_0.super.ShowFloat(arg0_22)
	setActive(arg0_22.itemHolder, true)
end

function var0_0.UpdateMapItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg2_23:getConfigTable()

	setAnchoredPosition(arg1_23, {
		x = arg0_23.mapWidth * var0_23.pos_x,
		y = arg0_23.mapHeight * var0_23.pos_y
	})

	local var1_23 = findTF(arg1_23, "main")

	setActive(var1_23, true)

	local var2_23 = findTF(var1_23, "circle/fordark")
	local var3_23 = findTF(var1_23, "info/bk/fordark")

	setActive(var2_23, var0_23.icon_outline == 1)
	setActive(var3_23, var0_23.icon_outline == 1)

	local var4_23 = arg0_23.chapterGroupDict[arg2_23.id]

	assert(var4_23)

	local var5_23 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_23 = 1

	if arg2_23:isUnlock() then
		var6_23 = 2

		if #var4_23.list > 1 then
			var6_23 = table.indexof(var4_23.list, arg2_23.id) + 1
		elseif arg2_23:IsSpChapter() or arg2_23:IsEXChapter() then
			var6_23 = 3
		elseif arg0_23.contextData.map:isHardMap() then
			var6_23 = 3
		end
	end

	local var7_23 = findTF(var1_23, "circle/bk")

	for iter0_23, iter1_23 in ipairs(var5_23) do
		setActive(var7_23:Find(iter1_23), iter0_23 == var6_23)
	end

	local var8_23 = findTF(var1_23, "circle/clear_flag")
	local var9_23 = findTF(var1_23, "circle/lock")
	local var10_23 = findTF(var1_23, "circle/progress")
	local var11_23 = findTF(var1_23, "circle/progress_text")
	local var12_23 = findTF(var1_23, "circle/stars")
	local var13_23 = string.split(var0_23.name, "|")

	setText(findTF(var1_23, "info/bk/title_form/title_index"), var0_23.chapter_name .. "  ")
	setText(findTF(var1_23, "info/bk/title_form/title"), var13_23[1])
	setText(findTF(var1_23, "info/bk/title_form/title_en"), var13_23[2] or "")
	setFillAmount(var10_23, arg2_23.progress / 100)
	setText(var11_23, string.format("%d%%", arg2_23.progress))
	setActive(var12_23, arg2_23:existAchieve())

	if arg2_23:existAchieve() then
		for iter2_23, iter3_23 in ipairs(arg2_23.achieves) do
			local var14_23 = ChapterConst.IsAchieved(iter3_23)
			local var15_23 = var12_23:GetChild(iter2_23 - 1):Find("light")

			setActive(var15_23, var14_23)

			for iter4_23, iter5_23 in ipairs(var5_23) do
				if iter5_23 ~= "Lock" then
					setActive(var15_23:Find(iter5_23), iter4_23 == var6_23)
				end
			end
		end
	end

	local var16_23 = findTF(var1_23, "info/bk/BG")

	for iter6_23, iter7_23 in ipairs(var5_23) do
		setActive(var16_23:Find(iter7_23), iter6_23 == var6_23)
	end

	setActive(findTF(var1_23, "HardEffect"), var6_23 == 3)

	local var17_23 = not arg2_23.active and arg2_23:isClear()
	local var18_23 = not arg2_23.active and not arg2_23:isUnlock()

	setActive(var8_23, var17_23)
	setActive(var9_23, var18_23)
	setActive(var11_23, not var17_23 and not var18_23)
	arg0_23:DeleteTween("fighting" .. arg2_23.id)

	local var19_23 = findTF(var1_23, "circle/fighting")

	setText(findTF(var19_23, "Text"), i18n("tag_level_fighting"))

	local var20_23 = findTF(var1_23, "circle/oni")

	setText(findTF(var20_23, "Text"), i18n("tag_level_oni"))

	local var21_23 = findTF(var1_23, "circle/narrative")

	setText(findTF(var21_23, "Text"), i18n("tag_level_narrative"))
	setActive(var19_23, false)
	setActive(var20_23, false)
	setActive(var21_23, false)

	local var22_23
	local var23_23

	if arg2_23:getConfig("chapter_tag") == 1 then
		var22_23 = var21_23
	end

	if arg2_23.active then
		var22_23 = arg2_23:existOni() and var20_23 or var19_23
	end

	if var22_23 then
		setActive(var22_23, true)

		local var24_23 = GetOrAddComponent(var22_23, "CanvasGroup")

		var24_23.alpha = 1

		arg0_23:RecordTween("fighting" .. arg2_23.id, LeanTween.alphaCanvas(var24_23, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_23 = findTF(var1_23, "triesLimit")
	local var26_23 = arg2_23:isTriesLimit()

	setActive(var25_23, var26_23)

	if var26_23 then
		local var27_23 = arg2_23:getConfig("count")
		local var28_23 = var27_23 - arg2_23:getTodayDefeatCount() .. "/" .. var27_23

		setText(var25_23:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_23:Find("Text"), setColorStr(var28_23, var27_23 <= arg2_23:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_23 = pg.expedition_data_by_map[arg2_23:getConfig("map")].on_activity
		local var30_23 = getProxy(ChapterProxy):IsActivitySPChapterActive(var29_23) and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_23:Find("TipRect"), var30_23)
	end

	local var31_23 = arg2_23:GetDailyBonusQuota()
	local var32_23 = findTF(var1_23, "mark")

	setActive(var32_23:Find("bonus"), var31_23)
	setActive(var32_23, var31_23)

	if var31_23 then
		local var33_23 = var32_23:GetComponent(typeof(CanvasGroup))
		local var34_23 = arg0_23.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_23.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var34_23, var32_23:Find("bonus"))
		LeanTween.cancel(go(var32_23), true)

		local var35_23 = var32_23.anchoredPosition.y

		var33_23.alpha = 0

		LeanTween.value(go(var32_23), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_24)
			var33_23.alpha = arg0_24

			local var0_24 = var32_23.anchoredPosition

			var0_24.y = var35_23 * arg0_24
			var32_23.anchoredPosition = var0_24
		end)):setOnComplete(System.Action(function()
			var33_23.alpha = 1

			local var0_25 = var32_23.anchoredPosition

			var0_25.y = var35_23
			var32_23.anchoredPosition = var0_25
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var36_23 = arg2_23.id

	onButton(arg0_23, var1_23, function()
		arg0_23:TryOpenChapterInfo(var36_23, nil, var4_23.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
	arg0_23:PlayerLevelTplAnimation(arg1_23, {
		status = var5_23[var6_23],
		chapterVO = arg2_23
	})
end

function var0_0.PlayerLevelTplAnimation(arg0_27, arg1_27, arg2_27)
	return
end

function var0_0.SwitchChapter(arg0_28, arg1_28)
	local var0_28 = arg0_28.chapterGroupDict[arg1_28]

	if not var0_28 then
		return
	end

	local var1_28 = var0_28.list[var0_28.index]

	if var1_28 == arg1_28 then
		return
	end

	local var2_28 = table.indexof(var0_28.list, arg1_28)

	var0_28.index = var2_28

	local var3_28 = var0_28.list[1]
	local var4_28 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("spchapter_selected_" .. var4_28 .. "_" .. var3_28, var2_28)

	local var5_28 = arg0_28.chapterTFsById[var1_28]

	arg0_28.chapterTFsById[var1_28] = nil
	arg0_28.chapterTFsById[arg1_28] = var5_28

	arg0_28:UpdateChapterTF(arg1_28)
end

function var0_0.UpdateChapterTF(arg0_29, arg1_29)
	if not arg0_29.chapterGroupDict[arg1_29] then
		return
	end

	local var0_29 = arg0_29.chapterTFsById[arg1_29]

	if var0_29 then
		local var1_29 = getProxy(ChapterProxy):getChapterById(arg1_29)

		arg0_29:UpdateMapItem(var0_29, var1_29)
	end
end

function var0_0.UpdateStory(arg0_30)
	local var0_30 = {}
	local var1_30 = pg.NewStoryMgr.GetInstance()
	local var2_30 = 0
	local var3_30 = 0

	for iter0_30, iter1_30 in pairs(arg0_30.storyNodesDict) do
		local var4_30 = arg0_30.storyHolder:Find(tostring(iter1_30.id))
		local var5_30 = iter1_30:IsActive(arg0_30.activity, arg0_30.ptActivity)

		setActive(var4_30, var5_30)
		setText(var4_30:Find("main/char/bg/Text"), iter1_30:GetName())

		local var6_30 = iter1_30:IsReaded()

		setActive(var4_30:Find("main/char"), not var6_30)
		setActive(var4_30:Find("main/talk"), var6_30)
		onButton(arg0_30, var4_30, function()
			if var6_30 then
				return
			end

			local var0_31 = iter1_30:GetStory()

			arg0_30:PlayStory(var0_31, function()
				arg0_30:UpdateView()
			end)
		end)

		var2_30 = var2_30 + (var6_30 and 1 or 0)
		var3_30 = var3_30 + 1
	end

	setText(arg0_30.progressText, var2_30 .. "/" .. var3_30)
	setActive(arg0_30.storyAward, tobool(arg0_30.storyTask))

	if arg0_30.storyTask then
		local var7_30 = arg0_30.storyTask:getConfig("award_display")
		local var8_30 = Drop.Create(var7_30[1])

		updateDrop(arg0_30.storyAward:GetChild(0), var8_30)

		local var9_30 = arg0_30.storyTask:getTaskStatus()

		setActive(arg0_30.storyAward:Find("get"), var9_30 == 1)
		setActive(arg0_30.storyAward:Find("got"), var9_30 == 2)
		onButton(arg0_30, arg0_30.storyAward, function()
			arg0_30:emit(BaseUI.ON_DROP, var8_30)
		end)
	end
end

function var0_0.SwitchStoryMapAndBGM(arg0_34)
	local var0_34 = arg0_34.data:getConfig("default_background")
	local var1_34 = arg0_34.data:getConfig("default_bgm")
	local var2_34
	local var3_34 = underscore.keys(arg0_34.storyNodesDict)

	table.sort(var3_34)

	for iter0_34 = 1, #var3_34 do
		local var4_34 = arg0_34.storyNodesDict[var3_34[iter0_34]]

		if var4_34:IsReaded() then
			var0_34 = defaultValue(var4_34:GetCleanBG(), var0_34)
			var1_34 = defaultValue(var4_34:GetCleanBGM(), var1_34)
			var2_34 = defaultValue(var4_34:GetCleanAnimator(), var2_34)
		else
			break
		end
	end

	arg0_34.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_34,
			Animator = var2_34
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_34.__cname, var1_34)
end

function var0_0.TrySubmitTask(arg0_35)
	if underscore.all(underscore.values(arg0_35.storyNodesDict), function(arg0_36)
		return arg0_36:IsReaded()
	end) and arg0_35.storyTask and arg0_35.storyTask:getTaskStatus() == 1 then
		arg0_35:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_35.storyTask.id)

		return
	end
end

function var0_0.TryOpenChapter(arg0_37, arg1_37)
	local var0_37 = arg0_37.chapterTFsById[arg1_37]

	if var0_37 then
		local var1_37 = var0_37:Find("main")

		triggerButton(var1_37)
	end
end

function var0_0.PlayStory(arg0_38, arg1_38, arg2_38, arg3_38)
	if not arg1_38 then
		return existCall(arg2_38)
	end

	local var0_38 = pg.NewStoryMgr.GetInstance()
	local var1_38 = var0_38:IsPlayed(arg1_38)

	seriesAsync({
		function(arg0_39)
			if var1_38 and not arg3_38 then
				return arg0_39()
			end

			local var0_39 = tonumber(arg1_38)

			if var0_39 and var0_39 > 0 then
				arg0_38:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_39, nil, var1_38)
			else
				var0_38:Play(arg1_38, arg0_39, arg3_38)
			end
		end,
		function(arg0_40, ...)
			existCall(arg2_38, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_41)
	local var0_41 = arg0_41.activity:getConfig("config_client").task_id
	local var1_41 = getProxy(TaskProxy):getTaskVO(var0_41)

	if not var1_41 then
		errorMsg("Missing Activity Task ID : " .. var0_41)
	end

	arg0_41.storyTask = var1_41 or Task.New({
		id = var0_41
	})
end

function var0_0.OnSubmitTaskDone(arg0_42)
	arg0_42:UpdateView()
end

function var0_0.OnDestroy(arg0_43)
	return
end

return var0_0
