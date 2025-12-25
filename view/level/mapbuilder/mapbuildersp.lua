local var0_0 = class("MapBuilderSP", import(".MapBuilder"))
local var1_0 = import("Mgr/Pool/PoolPlural")

var0_0.DISPLAY = {
	STORY = 2,
	BATTLE = 1
}
var0_0.DIFFICULITY = {
	EASY = 1,
	HARD = 2
}

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPESP
end

function var0_0.getUIName(arg0_2)
	return "LevelSelectSPUI"
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
	arg0_4.storyContainer = arg0_4.storyHolder:Find("Viewport/Content")
	arg0_4.nodes = {}
	arg0_4.progressText = arg0_4._tf:Find("Story/Desc/Text")
	arg0_4.storyAward = arg0_4._tf:Find("Story/Award")
	arg0_4.storyNodeTpl = arg0_4._tf:Find("Story/NodeTemplate")
	arg0_4.oneLineTpl = arg0_4._tf:Find("Story/OneLine")
	arg0_4.branchHeadTpl = arg0_4._tf:Find("Story/BranchHead")
	arg0_4.branchCenterTpl = arg0_4._tf:Find("Story/BranchCenter")
	arg0_4.branchUpTpl = arg0_4._tf:Find("Story/BranchUp")
	arg0_4.branchDownTpl = arg0_4._tf:Find("Story/BranchDown")
	arg0_4.unionTailTpl = arg0_4._tf:Find("Story/UnionTail")
	arg0_4.unionCenterTpl = arg0_4._tf:Find("Story/UnionCenter")
	arg0_4.unionUpTpl = arg0_4._tf:Find("Story/UnionUp")
	arg0_4.unionDownTpl = arg0_4._tf:Find("Story/UnionDown")
	arg0_4.unreleasedNodeTpl = arg0_4._tf:Find("Story/UnreleasedNode")

	setActive(arg0_4.storyNodeTpl, false)
	setActive(arg0_4.oneLineTpl, false)
	setActive(arg0_4.branchHeadTpl, false)
	setActive(arg0_4.branchCenterTpl, false)
	setActive(arg0_4.branchUpTpl, false)
	setActive(arg0_4.branchDownTpl, false)
	setActive(arg0_4.unionTailTpl, false)
	setActive(arg0_4.unionCenterTpl, false)
	setActive(arg0_4.unionUpTpl, false)
	setActive(arg0_4.unionDownTpl, false)
	setActive(arg0_4.unreleasedNodeTpl, false)

	arg0_4.pools = {
		[arg0_4.storyNodeTpl] = var1_0.New(go(arg0_4.storyNodeTpl), 0),
		[arg0_4.oneLineTpl] = var1_0.New(go(arg0_4.oneLineTpl), 0),
		[arg0_4.branchHeadTpl] = var1_0.New(go(arg0_4.branchHeadTpl), 0),
		[arg0_4.branchCenterTpl] = var1_0.New(go(arg0_4.branchCenterTpl), 0),
		[arg0_4.branchUpTpl] = var1_0.New(go(arg0_4.branchUpTpl), 0),
		[arg0_4.branchDownTpl] = var1_0.New(go(arg0_4.branchDownTpl), 0),
		[arg0_4.unionTailTpl] = var1_0.New(go(arg0_4.unionTailTpl), 0),
		[arg0_4.unionCenterTpl] = var1_0.New(go(arg0_4.unionCenterTpl), 0),
		[arg0_4.unionUpTpl] = var1_0.New(go(arg0_4.unionUpTpl), 0),
		[arg0_4.unionDownTpl] = var1_0.New(go(arg0_4.unionDownTpl), 0)
	}
	arg0_4.nodeTplWidth = arg0_4.storyNodeTpl.rect.width
	arg0_4.oneLineWidth = arg0_4.oneLineTpl.rect.width
	arg0_4.oneLineHeight = arg0_4.oneLineTpl.rect.height
	arg0_4.branchHeadWidth = arg0_4.branchHeadTpl.rect.width
	arg0_4.branchUpWidth = arg0_4.branchUpTpl.rect.width
	arg0_4.branchUpHeight = arg0_4.branchUpTpl.rect.height
	arg0_4.UnionTailWidth = arg0_4.unionTailTpl.rect.width
	arg0_4.activeItems = {}
	arg0_4.displayChapterIDs = {}
	arg0_4.chapterTFsById = {}
	arg0_4.storyNodeTFsById = {}

	arg0_4:bind(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, function(arg0_5, arg1_5)
		arg0_4:SwitchChapter(arg1_5)
	end)
	onButton(arg0_4, arg0_4.battleLayer:Find("Story/Switch"), function()
		arg0_4:SetDisplayMode(var0_0.DISPLAY.STORY)

		arg0_4.needFocusStory = true

		arg0_4:Move2UnlockStory()
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

	arg0_12:BuildStoryTree()
end

function var0_0.BuildStoryTree(arg0_17)
	arg0_17.spStoryIDs = arg0_17.data:getConfig("story_id")
	arg0_17.spStoryNodeDict = {}
	arg0_17.spStoryNodes = {}
	arg0_17.spStoryUnreleasedNode = nil

	local var0_17 = {}

	_.each(arg0_17.spStoryIDs, function(arg0_18)
		local var0_18 = ActivitySpStoryNode.New({
			configId = arg0_18
		})

		if var0_18:GetType() ~= ActivitySpStoryNode.NODE_TYPE.UNRELEASED then
			arg0_17.spStoryNodeDict[arg0_18] = var0_18

			local var1_18 = arg0_17.spStoryNodeDict[arg0_18]
			local var2_18 = var0_17[var1_18:GetPreEvent()] or {}

			table.insert(var2_18, arg0_18)

			var0_17[var1_18:GetPreEvent()] = var2_18
		else
			arg0_17.spStoryUnreleasedNode = var0_18
		end
	end)

	local var1_17 = 0

	local function var2_17()
		if not var0_17[var1_17] then
			return
		end

		tailList = var0_17[var1_17]

		local var0_19

		_.each(tailList, function(arg0_20)
			table.insert(arg0_17.spStoryNodes, arg0_17.spStoryNodeDict[arg0_20])

			if var0_17[arg0_20] then
				var0_19 = true
				var1_17 = arg0_20
			end
		end)

		return var0_19
	end

	while var2_17() do
		-- block empty
	end

	local var3_17 = {}
	local var4_17

	_.each(arg0_17.spStoryNodes, function(arg0_21)
		local var0_21 = arg0_21:GetPreNodes()

		if #var0_21 == 0 then
			var4_17 = arg0_21

			return
		end

		_.each(var0_21, function(arg0_22)
			var3_17[arg0_22] = var3_17[arg0_22] or {}

			table.insert(var3_17[arg0_22], arg0_21)
		end)
	end)

	arg0_17.storyTree = {
		root = var4_17,
		childDict = var3_17
	}
end

function var0_0.SetDisplayMode(arg0_23, arg1_23)
	if arg1_23 == arg0_23.contextData.displayMode then
		return
	end

	arg0_23.contextData.displayMode = arg1_23

	arg0_23:UpdateView()
end

function var0_0.UpdateView(arg0_24)
	local var0_24 = string.split(arg0_24.contextData.map:getConfig("name"), "||")

	if arg0_24.contextData.displayMode == var0_0.DISPLAY.STORY then
		var0_24 = string.split(var0_24[1], "·")

		setText(arg0_24.sceneParent.chapterName, var0_24[1] .. i18n("levelscene_title_story"))
	else
		setText(arg0_24.sceneParent.chapterName, var0_24[1])
	end

	local var1_24 = arg0_24.contextData.map:getMapTitleNumber()

	arg0_24.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_24, arg0_24.sceneParent.chapterNoTitle, true)

	arg0_24.contextData.displayMode = arg0_24.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_24)

	local var2_24 = arg0_24.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_24._tf:Find("Battle"), var2_24)
	setActive(arg0_24._tf:Find("Story"), not var2_24)

	local var3_24 = getProxy(ChapterProxy):IsActivitySPChapterActive(arg0_24.contextData.map:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_24.battleLayer:Find("Story/BattleTip"), false)
	setActive(arg0_24.storyLayer:Find("Battle/BattleTip"), var3_24)
	arg0_24:UpdateStoryTask()

	if var2_24 then
		arg0_24:UpdateBattle()
		arg0_24.sceneParent:SwitchMapBG(arg0_24.contextData.map)
		arg0_24.sceneParent:PlayBGM()
	else
		arg0_24:UpdateStoryNodeStatus()
		arg0_24:UpdateStory()
		arg0_24:Move2UnlockStory()
		arg0_24:SwitchStoryMapAndBGM()
	end

	arg0_24:TrySubmitTask()
end

function var0_0.UpdateBattle(arg0_25)
	local var0_25 = getProxy(ChapterProxy)
	local var1_25 = arg0_25.displayChapterIDs
	local var2_25 = {}

	for iter0_25, iter1_25 in ipairs(var1_25) do
		local var3_25 = var0_25:getChapterById(iter1_25)

		table.insert(var2_25, var3_25)
	end

	table.clear(arg0_25.chapterTFsById)
	UIItemList.StaticAlign(arg0_25.itemHolder, arg0_25.chapterTpl, #var2_25, function(arg0_26, arg1_26, arg2_26)
		if arg0_26 ~= UIItemList.EventUpdate then
			return
		end

		local var0_26 = var2_25[arg1_26 + 1]

		arg0_25:UpdateMapItem(arg2_26, var0_26)

		arg2_26.name = "Chapter_" .. var0_26.id
		arg0_25.chapterTFsById[var0_26.id] = arg2_26
	end)
end

function var0_0.HideFloat(arg0_27)
	var0_0.super.HideFloat(arg0_27)
	setActive(arg0_27.itemHolder, false)
end

function var0_0.ShowFloat(arg0_28)
	var0_0.super.ShowFloat(arg0_28)
	setActive(arg0_28.itemHolder, true)
end

function var0_0.UpdateMapItem(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg2_29:getConfigTable()

	setAnchoredPosition(arg1_29, {
		x = arg0_29.mapWidth * var0_29.pos_x,
		y = arg0_29.mapHeight * var0_29.pos_y
	})

	local var1_29 = findTF(arg1_29, "main")

	setActive(var1_29, true)

	local var2_29 = findTF(var1_29, "circle/fordark")
	local var3_29 = findTF(var1_29, "info/bk/fordark")

	setActive(var2_29, var0_29.icon_outline == 1)
	setActive(var3_29, var0_29.icon_outline == 1)

	local var4_29 = arg0_29.chapterGroupDict[arg2_29.id]

	assert(var4_29)

	local var5_29 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_29 = 1

	if arg2_29:isUnlock() then
		var6_29 = 2

		if #var4_29.list > 1 then
			var6_29 = table.indexof(var4_29.list, arg2_29.id) + 1
		elseif arg2_29:IsSpChapter() or arg2_29:IsEXChapter() then
			var6_29 = 3
		elseif arg0_29.contextData.map:isHardMap() then
			var6_29 = 3
		end
	end

	local var7_29 = findTF(var1_29, "circle/bk")

	for iter0_29, iter1_29 in ipairs(var5_29) do
		setActive(var7_29:Find(iter1_29), iter0_29 == var6_29)
	end

	local var8_29 = findTF(var1_29, "circle/clear_flag")
	local var9_29 = findTF(var1_29, "circle/lock")
	local var10_29 = findTF(var1_29, "circle/progress")
	local var11_29 = findTF(var1_29, "circle/progress_text")
	local var12_29 = findTF(var1_29, "circle/stars")
	local var13_29 = string.split(var0_29.name, "|")

	setText(findTF(var1_29, "info/bk/title_form/title_index"), var0_29.chapter_name .. "  ")
	setText(findTF(var1_29, "info/bk/title_form/title"), var13_29[1])
	setText(findTF(var1_29, "info/bk/title_form/title_en"), var13_29[2] or "")
	setFillAmount(var10_29, arg2_29.progress / 100)
	setText(var11_29, string.format("%d%%", arg2_29.progress))
	setActive(var12_29, arg2_29:existAchieve())

	if arg2_29:existAchieve() then
		for iter2_29, iter3_29 in ipairs(arg2_29.achieves) do
			local var14_29 = ChapterConst.IsAchieved(iter3_29)
			local var15_29 = var12_29:GetChild(iter2_29 - 1):Find("light")

			setActive(var15_29, var14_29)

			for iter4_29, iter5_29 in ipairs(var5_29) do
				if iter5_29 ~= "Lock" then
					setActive(var15_29:Find(iter5_29), iter4_29 == var6_29)
				end
			end
		end
	end

	local var16_29 = findTF(var1_29, "info/bk/BG")

	for iter6_29, iter7_29 in ipairs(var5_29) do
		setActive(var16_29:Find(iter7_29), iter6_29 == var6_29)
	end

	setActive(findTF(var1_29, "HardEffect"), var6_29 == 3)

	local var17_29 = not arg2_29.active and arg2_29:isClear()
	local var18_29 = not arg2_29.active and not arg2_29:isUnlock()

	setActive(var8_29, var17_29)
	setActive(var9_29, var18_29)
	setActive(var11_29, not var17_29 and not var18_29)
	arg0_29:DeleteTween("fighting" .. arg2_29.id)

	local var19_29 = findTF(var1_29, "circle/fighting")

	setText(findTF(var19_29, "Text"), i18n("tag_level_fighting"))

	local var20_29 = findTF(var1_29, "circle/oni")

	setText(findTF(var20_29, "Text"), i18n("tag_level_oni"))

	local var21_29 = findTF(var1_29, "circle/narrative")

	setText(findTF(var21_29, "Text"), i18n("tag_level_narrative"))
	setActive(var19_29, false)
	setActive(var20_29, false)
	setActive(var21_29, false)

	local var22_29
	local var23_29

	if arg2_29:getConfig("chapter_tag") == 1 then
		var22_29 = var21_29
	end

	if arg2_29.active then
		var22_29 = arg2_29:existOni() and var20_29 or var19_29
	end

	if var22_29 then
		setActive(var22_29, true)

		local var24_29 = GetOrAddComponent(var22_29, "CanvasGroup")

		var24_29.alpha = 1

		arg0_29:RecordTween("fighting" .. arg2_29.id, LeanTween.alphaCanvas(var24_29, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_29 = findTF(var1_29, "triesLimit")
	local var26_29 = arg2_29:isTriesLimit()

	setActive(var25_29, var26_29)

	if var26_29 then
		local var27_29 = arg2_29:getConfig("count")
		local var28_29 = var27_29 - arg2_29:getTodayDefeatCount() .. "/" .. var27_29

		setText(var25_29:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_29:Find("Text"), setColorStr(var28_29, var27_29 <= arg2_29:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_29 = pg.expedition_data_by_map[arg2_29:getConfig("map")].on_activity
		local var30_29 = getProxy(ChapterProxy):IsActivitySPChapterActive(var29_29) and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_29:Find("TipRect"), var30_29)
	end

	local var31_29 = arg2_29:GetDailyBonusQuota()
	local var32_29 = findTF(var1_29, "mark")

	setActive(var32_29:Find("bonus"), var31_29)
	setActive(var32_29, var31_29)

	if var31_29 then
		local var33_29 = var32_29:GetComponent(typeof(CanvasGroup))
		local var34_29 = var6_29 == 3 and "bonus_us_hard" or "bonus_us"

		arg0_29.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var34_29, var32_29:Find("bonus"))
		LeanTween.cancel(go(var32_29), true)

		local var35_29 = var32_29.anchoredPosition.y

		var33_29.alpha = 0

		LeanTween.value(go(var32_29), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_30)
			var33_29.alpha = arg0_30

			local var0_30 = var32_29.anchoredPosition

			var0_30.y = var35_29 * arg0_30
			var32_29.anchoredPosition = var0_30
		end)):setOnComplete(System.Action(function()
			var33_29.alpha = 1

			local var0_31 = var32_29.anchoredPosition

			var0_31.y = var35_29
			var32_29.anchoredPosition = var0_31
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var36_29 = arg2_29.id

	onButton(arg0_29, var1_29, function()
		arg0_29:TryOpenChapterInfo(var36_29, nil, var4_29.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.SwitchChapter(arg0_33, arg1_33)
	local var0_33 = arg0_33.chapterGroupDict[arg1_33]

	if not var0_33 then
		return
	end

	local var1_33 = var0_33.list[var0_33.index]

	if var1_33 == arg1_33 then
		return
	end

	local var2_33 = table.indexof(var0_33.list, arg1_33)

	var0_33.index = var2_33

	local var3_33 = var0_33.list[1]
	local var4_33 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("spchapter_selected_" .. var4_33 .. "_" .. var3_33, var2_33)

	local var5_33 = arg0_33.chapterTFsById[var1_33]

	arg0_33.chapterTFsById[var1_33] = nil
	arg0_33.chapterTFsById[arg1_33] = var5_33

	arg0_33:UpdateChapterTF(arg1_33)
end

function var0_0.UpdateChapterTF(arg0_34, arg1_34)
	if not arg0_34.chapterGroupDict[arg1_34] then
		return
	end

	local var0_34 = arg0_34.chapterTFsById[arg1_34]

	if var0_34 then
		local var1_34 = getProxy(ChapterProxy):getChapterById(arg1_34)

		arg0_34:UpdateMapItem(var0_34, var1_34)
	end
end

function var0_0.RecyclePools(arg0_35)
	for iter0_35 = #arg0_35.activeItems, 1, -1 do
		local var0_35 = arg0_35.activeItems[iter0_35]
		local var1_35 = arg0_35.pools[var0_35.template]

		if var0_35.template == arg0_35.oneLineTpl then
			setSizeDelta(var0_35.active, {
				x = arg0_35.oneLineWidth,
				y = arg0_35.oneLineHeight
			})
		end

		var1_35:Enqueue(var0_35.active)
	end

	table.clean(arg0_35.activeItems)

	arg0_35.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_36)
	local var0_36 = 0
	local var1_36 = 0
	local var2_36 = pg.NewStoryMgr.GetInstance()
	local var3_36 = {}

	table.Foreach(arg0_36.spStoryIDs, function(arg0_37, arg1_37)
		var3_36[arg1_37] = {}
	end)

	local var4_36 = arg0_36.spStoryNodes

	for iter0_36 = 1, #var4_36 do
		local var5_36 = var4_36[iter0_36]
		local var6_36 = var5_36:GetConfigID()
		local var7_36 = var5_36:GetPreEvent()
		local var8_36 = false
		local var9_36 = var7_36 == 0 and true or var3_36[var7_36].status == var4_0
		local var10_36 = var2_0
		local var11_36 = var5_36:GetStoryName()
		local var12_36 = false

		if var11_36 and var11_36 ~= "" then
			var12_36 = var2_36:IsPlayed(var11_36)
			var0_36 = var0_36 + (var12_36 and 1 or 0)
			var1_36 = var1_36 + 1
		end

		if not var12_36 and var9_36 then
			_.each(var5_36:GetUnlockConditions(), function(arg0_38)
				if arg0_38[1] == ActivitySpStoryNode.CONDITION.TIME then
					local var0_38 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_38[2])
					local var1_38 = pg.TimeMgr.GetInstance():GetServerTime()

					var9_36 = var9_36 and var0_38 <= var1_38
				elseif arg0_38[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var2_38 = arg0_38[2]

					var9_36 = var9_36 and _.all(var2_38, function(arg0_39)
						return getProxy(ChapterProxy):getChapterById(arg0_39, true):isClear()
					end)
				elseif arg0_38[1] == ActivitySpStoryNode.CONDITION.PT then
					local var3_38 = arg0_38[2][1]
					local var4_38 = arg0_38[2][2]
					local var5_38 = arg0_38[2][3]
					local var6_38 = 0

					if var3_38 == DROP_TYPE_RESOURCE then
						var6_38 = getProxy(PlayerProxy):getRawData():getResource(arg0_38[2])
					elseif var3_38 == DROP_TYPE_ITEM then
						var6_38 = getProxy(BagProxy):getItemCountById(var4_38)
					end

					var9_36 = var9_36 and var5_38 <= var6_38
				end
			end)
		end

		if var12_36 then
			var10_36 = var4_0
		elseif var9_36 then
			var10_36 = var3_0
		end

		var3_36[var6_36].status = var10_36
	end

	arg0_36.storyNodeStatus = var3_36
	arg0_36.storyReadCount, arg0_36.storyReadMax = var0_36, var1_36
end

function var0_0.UpdateStory(arg0_40)
	arg0_40:RecyclePools()

	local var0_40 = {
		"162443",
		"ffffff",
		"ffcb5a"
	}
	local var1_40 = arg0_40.data:getConfig("story_inactive_color")

	if var1_40 and #var1_40 > 0 then
		var0_40[1] = var1_40
	end

	local var2_40 = 0
	local var3_40 = 150
	local var4_40 = 150
	local var5_40 = {
		{
			node = arg0_40.storyTree.root,
			nodePos = Vector2.New(var3_40, 0)
		}
	}
	local var6_40 = arg0_40.nodeTplWidth
	local var7_40 = arg0_40.oneLineWidth
	local var8_40 = arg0_40.branchHeadWidth
	local var9_40 = arg0_40.branchUpWidth
	local var10_40 = arg0_40.branchUpHeight
	local var11_40 = arg0_40.UnionTailWidth
	local var12_40 = 75
	local var13_40 = 82
	local var14_40 = 32

	local function var15_40()
		local var0_41 = table.remove(var5_40, 1)
		local var1_41 = var0_41.node:GetConfigID()

		;(function()
			local var0_42 = arg0_40:DequeItem(arg0_40.storyNodeTpl)

			var0_42.name = var1_41

			setAnchoredPosition(var0_42, var0_41.nodePos)

			arg0_40.storyNodeTFsById[var1_41] = {
				nodeTF = tf(var0_42)
			}
		end)()

		local var2_41 = arg0_40.storyTree.childDict[var1_41] or {}

		if #var2_41 == 0 then
			var2_40 = var0_41.nodePos.x + var6_40 + var4_40
		elseif #var2_41 == 1 then
			local var3_41 = var2_41[1]
			local var4_41 = var3_41:GetConfigID()
			local var5_41 = arg0_40:DequeItem(arg0_40.oneLineTpl)

			var5_41.name = string.format("Line%s_%s", var1_41, var4_41)

			setAnchoredPosition(var5_41, var0_41.nodePos + Vector2.New(var6_40 + var14_40, 0))

			nextPos = tf(var5_41).anchoredPosition + Vector2.New(var7_40 + var12_40, 0)

			local var6_41 = arg0_40.storyNodeStatus[var4_41].status

			eachChild(var5_41, function(arg0_43)
				setImageColor(arg0_43, Color.NewHex(var0_40[var6_41]))
			end)
			table.insert(var5_40, {
				node = var3_41,
				nodePos = nextPos
			})
		elseif #var2_41 > 1 then
			local var7_41 = {}
			local var8_41

			table.Ipairs(var2_41, function(arg0_44, arg1_44)
				local var0_44 = 0
				local var1_44 = arg1_44

				local function var2_44()
					var0_44 = var0_44 + 1

					local var0_45 = arg0_40.storyTree.childDict[var1_44:GetConfigID()]

					if not var0_45 then
						return false
					end

					assert(#var0_45 <= 1)

					local var1_45 = var0_45[1]

					if var1_45 and #var1_45:GetPreNodes() == 1 then
						var1_44 = var1_45

						return true
					else
						var8_41 = var1_45
					end
				end

				while var2_44() do
					-- block empty
				end

				var7_41[arg0_44] = var0_44
			end)

			local var9_41 = _.max(var7_41)
			local var10_41 = var9_41 * (var6_40 + var12_40 + var14_40) + (var9_41 - 1) * var7_40
			local var11_41 = var0_41.nodePos + Vector2.New(var6_40 + var14_40, 0)

			;(function()
				local var0_46 = arg0_40:DequeItem(arg0_40.branchHeadTpl)

				setAnchoredPosition(var0_46, var11_41)

				var11_41 = var11_41 + Vector2.New(var8_40, 0)

				local var1_46 = arg0_40.storyNodeStatus[var2_41[1]:GetConfigID()].status

				eachChild(var0_46, function(arg0_47)
					setImageColor(arg0_47, Color.NewHex(var0_40[var1_46]))
				end)
			end)()
			table.Ipairs(var2_41, function(arg0_48, arg1_48)
				local var0_48 = var7_40

				if var7_41[arg0_48] < var9_41 then
					local var1_48 = var7_41[arg0_48]

					var0_48 = (var10_41 - var1_48 * (var6_40 + var12_40 + var14_40)) / (var1_48 + 1)
				end

				local var2_48 = arg1_48:GetConfigID()
				local var3_48 = var11_41

				;(function()
					local var0_49

					if arg0_48 == 1 then
						var0_49 = arg0_40:DequeItem(arg0_40.branchUpTpl)

						setAnchoredPosition(var0_49, var3_48)

						var3_48 = var3_48 + Vector2.New(var9_40, var10_40)

						if var7_41[arg0_48] < var9_41 then
							setSizeDelta(var0_49, {
								x = var9_40 + var0_48,
								y = var10_40
							})

							local var1_49 = tf(var0_49):Find("Line_1").sizeDelta

							var1_49.x = var1_49.x + var0_48

							setSizeDelta(tf(var0_49):Find("Line_1"), var1_49)

							var3_48 = var3_48 + Vector2.New(var0_48, 0)
						end
					elseif (arg0_48 == 3 or arg0_48 == 2 and #var2_41 == 2) and arg0_40.storyTree.childDict[var2_41[1]:GetConfigID()] then
						var0_49 = arg0_40:DequeItem(arg0_40.branchDownTpl)

						setAnchoredPosition(var0_49, var3_48)

						var3_48 = var3_48 + Vector2.New(var9_40, -var10_40)

						if var7_41[arg0_48] < var9_41 then
							setSizeDelta(var0_49, {
								x = var9_40 + var0_48,
								y = var10_40
							})

							local var2_49 = tf(var0_49):Find("Line_1").sizeDelta

							var2_49.x = var2_49.x + var0_48

							setSizeDelta(tf(var0_49):Find("Line_1"), var2_49)

							var3_48 = var3_48 + Vector2.New(var0_48, 0)
						end
					else
						var0_49 = arg0_40:DequeItem(arg0_40.branchCenterTpl)

						setAnchoredPosition(var0_49, var3_48)

						var3_48 = var3_48 + Vector2.New(var9_40, 0)

						if var7_41[arg0_48] < var9_41 then
							local var3_49 = tf(var0_49).sizeDelta

							var3_49.x = var3_49.x + var0_48

							setSizeDelta(var0_49, var3_49)

							var3_48 = var3_48 + Vector2.New(var0_48, 0)
						end
					end

					var0_49.name = string.format("Branch%s_%s", var1_41, var2_48)

					local var4_49 = arg0_40.storyNodeStatus[var2_48].status

					eachChild(var0_49, function(arg0_50)
						setImageColor(arg0_50, Color.NewHex(var0_40[var4_49]))
					end)
				end)()

				var3_48 = var3_48 + Vector2.New(var12_40, 0)

				local var4_48 = arg0_40:DequeItem(arg0_40.storyNodeTpl)

				var4_48.name = var2_48

				setAnchoredPosition(var4_48, var3_48)

				arg0_40.storyNodeTFsById[var2_48] = {
					nodeTF = tf(var4_48)
				}
				var3_48 = var3_48 + Vector2.New(var6_40 + var14_40, 0)

				local var5_48 = arg1_48

				if arg0_40.storyTree.childDict[var2_48] then
					local var6_48 = arg0_40.storyTree.childDict[var2_48][1]

					local function var7_48()
						if not var6_48 or var6_48 == var8_41 then
							return
						end

						local var0_51 = arg0_40:DequeItem(arg0_40.oneLineTpl)

						var0_51.name = string.format("Line%s_%s", var5_48:GetConfigID(), var6_48:GetConfigID())

						setAnchoredPosition(var0_51, var3_48)

						var3_48 = var3_48 + Vector2.New(var0_48 + var12_40, 0)

						setSizeDelta(var0_51, {
							x = var0_48,
							y = arg0_40.oneLineHeight
						})

						local var1_51 = arg0_40.storyNodeStatus[var6_48:GetConfigID()].status

						eachChild(var0_51, function(arg0_52)
							setImageColor(arg0_52, Color.NewHex(var0_40[var1_51]))
						end)

						local var2_51 = arg0_40:DequeItem(arg0_40.storyNodeTpl)

						var2_51.name = var6_48:GetConfigID()

						setAnchoredPosition(var2_51, var3_48)

						arg0_40.storyNodeTFsById[var6_48:GetConfigID()] = {
							nodeTF = tf(var2_51)
						}
						var3_48 = var3_48 + Vector2.New(var6_40 + var14_40, 0)

						local var3_51 = arg0_40.storyTree.childDict[var6_48:GetConfigID()]

						if not var3_51 then
							return false
						end

						var6_48, var5_48 = var3_51[1], var6_48

						return true
					end

					while var7_48() do
						-- block empty
					end
				end

				if var8_41 then
					local var8_48

					if arg0_48 == 1 then
						var8_48 = arg0_40:DequeItem(arg0_40.unionUpTpl)

						setAnchoredPosition(var8_48, var3_48)

						if var7_41[arg0_48] < var9_41 then
							setSizeDelta(var8_48, {
								x = var9_40 + var0_48,
								y = var10_40
							})

							local var9_48 = tf(var8_48):Find("Line_1").sizeDelta

							var9_48.x = var9_48.x + var0_48

							setSizeDelta(tf(var8_48):Find("Line_1"), var9_48)

							var3_48 = var3_48 + Vector2.New(var0_48, 0)
						end
					elseif arg0_48 == 3 or arg0_48 == 2 and #var2_41 == 2 then
						var8_48 = arg0_40:DequeItem(arg0_40.unionDownTpl)

						setAnchoredPosition(var8_48, var3_48)

						if var7_41[arg0_48] < var9_41 then
							setSizeDelta(var8_48, {
								x = var9_40 + var0_48,
								y = var10_40
							})

							local var10_48 = tf(var8_48):Find("Line_1").sizeDelta

							var10_48.x = var10_48.x + var0_48

							setSizeDelta(tf(var8_48):Find("Line_1"), var10_48)

							var3_48 = var3_48 + Vector2.New(var0_48, 0)
						end
					else
						var8_48 = arg0_40:DequeItem(arg0_40.unionCenterTpl)

						setAnchoredPosition(var8_48, var3_48)

						if var7_41[arg0_48] < var9_41 then
							local var11_48 = tf(var8_48).sizeDelta

							var11_48.x = var11_48.x + var0_48

							setSizeDelta(var8_48, var11_48)

							var3_48 = var3_48 + Vector2.New(var0_48, 0)
						end
					end

					var8_48.name = string.format("Union%s_%s", var5_48:GetConfigID(), var8_41:GetConfigID())

					local var12_48 = arg0_40.storyNodeStatus[var8_41:GetConfigID()].status

					eachChild(var8_48, function(arg0_53)
						setImageColor(arg0_53, Color.NewHex(var0_40[var12_48]))
					end)
				end
			end)

			var11_41 = var11_41 + Vector2.New(var10_41 + var9_40, 0)

			if var8_41 then
				(function()
					var11_41 = var11_41 + Vector2.New(var9_40, 0)

					local var0_54 = arg0_40:DequeItem(arg0_40.unionTailTpl)

					setAnchoredPosition(var0_54, var11_41)

					var11_41 = var11_41 + Vector2.New(var11_40 + var13_40, 0)

					local var1_54 = arg0_40.storyNodeStatus[var8_41:GetConfigID()].status

					eachChild(var0_54, function(arg0_55)
						setImageColor(arg0_55, Color.NewHex(var0_40[var1_54]))
					end)
				end)()
				table.insert(var5_40, {
					node = var8_41,
					nodePos = var11_41
				})
			else
				var2_40 = var11_41.x + var4_40
			end
		end

		return next(var5_40)
	end

	while var15_40() do
		-- block empty
	end

	setSizeDelta(arg0_40.storyContainer, {
		x = var2_40
	})

	if arg0_40.spStoryUnreleasedNode then
		local var16_40 = cloneTplTo(arg0_40.unreleasedNodeTpl, arg0_40.storyContainer)

		setAnchoredPosition(var16_40, {
			y = 0,
			x = var2_40
		})
		setText(var16_40:Find("text"), arg0_40.spStoryUnreleasedNode:GetDisplayName())
		ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_40.spStoryUnreleasedNode:GetCleanAnimator(), "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_56)
			local var0_56 = Instantiate(arg0_56)
			local var1_56 = Vector3.New(-525, 0, 380)

			tf(var0_56).localPosition = var1_56

			setParent(var0_56, var16_40)
		end), true, true)
	end

	local var17_40 = arg0_40.spStoryNodes

	for iter0_40 = 1, #var17_40 do
		local var18_40 = var17_40[iter0_40]
		local var19_40 = var18_40:GetConfigID()
		local var20_40 = arg0_40.storyNodeStatus[var19_40].status
		local var21_40 = arg0_40.storyNodeTFsById[var19_40].nodeTF
		local var22_40 = var21_40:Find("info/bk/title_form/title")

		if var20_40 == var2_0 then
			setScrollText(var22_40, HXSet.hxLan(var18_40:GetUnlockDesc()))
			setTextAlpha(var22_40, 0.5)
		else
			setScrollText(var22_40, HXSet.hxLan(var18_40:GetDisplayName()))
			setTextAlpha(var22_40, 1)
		end

		local var23_40 = var18_40:GetType()

		setActive(var21_40:Find("circle/lock"), var20_40 == var2_0)

		if var20_40 == var2_0 then
			setActive(var21_40:Find("circle/Story"), false)
			setActive(var21_40:Find("circle/Battle"), false)
			setActive(var21_40:Find("circle/Option"), false)
			setText(var21_40:Find(""))
		elseif var23_40 == ActivitySpStoryNode.NODE_TYPE.STORY then
			setActive(var21_40:Find("circle/Option"), false)
			setActive(var21_40:Find("circle/Story"), true)
			setActive(var21_40:Find("circle/Battle"), false)
			setActive(var21_40:Find("circle/Story/Done"), var20_40 == var4_0)
		elseif var23_40 == ActivitySpStoryNode.NODE_TYPE.OPTION_BRANCH then
			setActive(var21_40:Find("circle/Option"), true)
			setActive(var21_40:Find("circle/Story"), false)
			setActive(var21_40:Find("circle/Battle"), false)
			setActive(var21_40:Find("circle/Option/Done"), var20_40 == var4_0)
		elseif var23_40 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
			setActive(var21_40:Find("circle/Story"), false)
			setActive(var21_40:Find("circle/Option"), false)
			setActive(var21_40:Find("circle/Battle"), var23_40 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var21_40:Find("circle/Battle/Done"), var20_40 == var4_0)
		end

		local var24_40 = var20_40 == var4_0

		setActive(var21_40:Find("circle/progress"), var24_40)
		onButton(arg0_40, var21_40, function()
			if var20_40 == var2_0 then
				return
			end

			local var0_57 = var18_40:GetStoryName()

			arg0_40:PlayStory(var0_57, function()
				arg0_40:UpdateView()

				arg0_40.needFocusStory = true

				arg0_40:Move2UnlockStory()
			end, true)
		end)
	end

	local var25_40 = arg0_40.storyReadCount
	local var26_40 = arg0_40.storyReadMax

	setText(arg0_40.progressText, var25_40 .. "/" .. var26_40)
	setActive(arg0_40.storyAward, tobool(arg0_40.storyTask))

	if arg0_40.storyTask then
		local var27_40 = arg0_40.storyTask:getConfig("award_display")
		local var28_40 = Drop.New({
			type = var27_40[1][1],
			id = var27_40[1][2],
			count = var27_40[1][3]
		})

		updateDrop(arg0_40.storyAward:GetChild(0), var28_40)

		local var29_40 = arg0_40.storyTask:getTaskStatus()

		setActive(arg0_40.storyAward:Find("get"), var29_40 == 1)
		setActive(arg0_40.storyAward:Find("got"), var29_40 == 2)
		onButton(arg0_40, arg0_40.storyAward, function()
			arg0_40:emit(BaseUI.ON_DROP, var28_40)
		end)
	end
end

function var0_0.DequeItem(arg0_60, arg1_60)
	local var0_60 = arg0_60.pools[arg1_60]:Dequeue()

	table.insert(arg0_60.activeItems, {
		template = arg1_60,
		active = var0_60
	})
	setActive(var0_60, true)
	setParent(var0_60, arg0_60.storyContainer)

	return var0_60
end

function var0_0.Move2UnlockStory(arg0_61)
	if not arg0_61.needFocusStory then
		return
	end

	arg0_61.needFocusStory = nil

	local var0_61 = arg0_61.spStoryNodes
	local var1_61

	for iter0_61 = #var0_61, 1, -1 do
		local var2_61 = var0_61[iter0_61]:GetConfigID()

		if arg0_61.storyNodeStatus[var2_61].status > var2_0 then
			var1_61 = var2_61

			break
		end
	end

	local var3_61 = arg0_61.storyNodeTFsById[var1_61].nodeTF
	local var4_61 = arg0_61.storyNodeTpl.rect.width
	local var5_61 = var3_61.anchoredPosition.x + var4_61 * 0.5 - arg0_61.storyContainer.parent.rect.width * 0.5
	local var6_61 = math.clamp(var5_61, 0, math.max(0, arg0_61.storyContainer.rect.width - arg0_61.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_61.storyContainer, {
		x = -var6_61
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_62)
	local var0_62 = arg0_62.data:getConfig("default_background")
	local var1_62 = arg0_62.data:getConfig("default_bgm")
	local var2_62
	local var3_62 = arg0_62.spStoryNodes

	for iter0_62 = 1, #var3_62 do
		local var4_62 = var3_62[iter0_62]
		local var5_62 = var4_62:GetConfigID()

		if arg0_62.storyNodeStatus[var5_62].status == var4_0 then
			var0_62, var1_62 = var4_62:GetCleanBG(), var4_62:GetCleanBGM()
			var2_62 = var4_62:GetCleanAnimator()
		else
			break
		end
	end

	arg0_62.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_62,
			Animator = var2_62
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_62.__cname, var1_62)
end

function var0_0.TrySubmitTask(arg0_63)
	local var0_63 = true

	for iter0_63, iter1_63 in ipairs(arg0_63.spStoryNodes) do
		local var1_63 = iter1_63:GetStoryName()

		if var1_63 and var1_63 ~= "" then
			var0_63 = var0_63 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_63)
		end

		if not var0_63 then
			break
		end
	end

	if var0_63 and arg0_63.storyTask and arg0_63.storyTask:getTaskStatus() == 1 then
		arg0_63:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_63.storyTask.id)

		return
	end
end

function var0_0.PlayStory(arg0_64, arg1_64, arg2_64, arg3_64)
	if not arg1_64 then
		return existCall(arg2_64)
	end

	local var0_64 = pg.NewStoryMgr.GetInstance()
	local var1_64 = var0_64:IsPlayed(arg1_64)

	seriesAsync({
		function(arg0_65)
			if var1_64 and not arg3_64 then
				return arg0_65()
			end

			local var0_65 = tonumber(arg1_64)

			if var0_65 and var0_65 > 0 then
				arg0_64:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_65, nil, var1_64)
			else
				var0_64:PlayForAcivitySpStory(arg1_64, arg0_65, arg3_64)
			end
		end,
		function(arg0_66, ...)
			existCall(arg2_64, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_67)
	local var0_67 = arg0_67.activity:getConfig("config_client").task_id
	local var1_67 = getProxy(TaskProxy):getTaskVO(var0_67)

	if not var1_67 then
		errorMsg("Missing Activity Task ID : " .. var0_67)
	end

	arg0_67.storyTask = var1_67 or Task.New({
		id = var0_67
	})
end

function var0_0.OnSubmitTaskDone(arg0_68)
	arg0_68:UpdateView()
end

function var0_0.OnDestroy(arg0_69)
	arg0_69:RecyclePools()

	for iter0_69, iter1_69 in pairs(arg0_69.pools) do
		iter1_69:Clear()
	end
end

return var0_0
