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

	local var0_17 = {}

	_.each(arg0_17.spStoryIDs, function(arg0_18)
		arg0_17.spStoryNodeDict[arg0_18] = ActivitySpStoryNode.New({
			configId = arg0_18
		})

		local var0_18 = arg0_17.spStoryNodeDict[arg0_18]

		var0_17[var0_18:GetPreEvent()] = arg0_18
	end)

	local var1_17 = 0

	local function var2_17()
		if not var0_17[var1_17] then
			return
		end

		var1_17 = var0_17[var1_17]

		table.insert(arg0_17.spStoryNodes, arg0_17.spStoryNodeDict[var1_17])

		return true
	end

	while var2_17() do
		-- block empty
	end

	local var3_17 = {}
	local var4_17

	_.each(arg0_17.spStoryNodes, function(arg0_20)
		local var0_20 = arg0_20:GetPreNodes()

		if #var0_20 == 0 then
			var4_17 = arg0_20

			return
		end

		_.each(var0_20, function(arg0_21)
			var3_17[arg0_21] = var3_17[arg0_21] or {}

			table.insert(var3_17[arg0_21], arg0_20)
		end)
	end)

	arg0_17.storyTree = {
		root = var4_17,
		childDict = var3_17
	}
end

function var0_0.SetDisplayMode(arg0_22, arg1_22)
	if arg1_22 == arg0_22.contextData.displayMode then
		return
	end

	arg0_22.contextData.displayMode = arg1_22

	arg0_22:UpdateView()
end

function var0_0.UpdateView(arg0_23)
	local var0_23 = string.split(arg0_23.contextData.map:getConfig("name"), "||")

	setText(arg0_23.sceneParent.chapterName, var0_23[1])

	local var1_23 = arg0_23.contextData.map:getMapTitleNumber()

	arg0_23.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_23, arg0_23.sceneParent.chapterNoTitle, true)

	arg0_23.contextData.displayMode = arg0_23.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_23)

	local var2_23 = arg0_23.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_23._tf:Find("Battle"), var2_23)
	setActive(arg0_23._tf:Find("Story"), not var2_23)

	local var3_23 = getProxy(ChapterProxy):IsActivitySPChapterActive(arg0_23.contextData.map:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_23.battleLayer:Find("Story/BattleTip"), false)
	setActive(arg0_23.storyLayer:Find("Battle/BattleTip"), var3_23)
	arg0_23:UpdateStoryTask()

	if var2_23 then
		arg0_23:UpdateBattle()
		arg0_23.sceneParent:SwitchMapBG(arg0_23.contextData.map)
		arg0_23.sceneParent:PlayBGM()
	else
		arg0_23:UpdateStoryNodeStatus()
		arg0_23:UpdateStory()
		arg0_23:Move2UnlockStory()
		arg0_23:SwitchStoryMapAndBGM()
	end

	arg0_23:TrySubmitTask()
end

function var0_0.UpdateBattle(arg0_24)
	local var0_24 = getProxy(ChapterProxy)
	local var1_24 = arg0_24.displayChapterIDs
	local var2_24 = {}

	for iter0_24, iter1_24 in ipairs(var1_24) do
		local var3_24 = var0_24:getChapterById(iter1_24)

		table.insert(var2_24, var3_24)
	end

	table.clear(arg0_24.chapterTFsById)
	UIItemList.StaticAlign(arg0_24.itemHolder, arg0_24.chapterTpl, #var2_24, function(arg0_25, arg1_25, arg2_25)
		if arg0_25 ~= UIItemList.EventUpdate then
			return
		end

		local var0_25 = var2_24[arg1_25 + 1]

		arg0_24:UpdateMapItem(arg2_25, var0_25)

		arg2_25.name = "Chapter_" .. var0_25.id
		arg0_24.chapterTFsById[var0_25.id] = arg2_25
	end)
end

function var0_0.HideFloat(arg0_26)
	var0_0.super.HideFloat(arg0_26)
	setActive(arg0_26.itemHolder, false)
end

function var0_0.ShowFloat(arg0_27)
	var0_0.super.ShowFloat(arg0_27)
	setActive(arg0_27.itemHolder, true)
end

function var0_0.UpdateMapItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28:getConfigTable()

	setAnchoredPosition(arg1_28, {
		x = arg0_28.mapWidth * var0_28.pos_x,
		y = arg0_28.mapHeight * var0_28.pos_y
	})

	local var1_28 = findTF(arg1_28, "main")

	setActive(var1_28, true)

	local var2_28 = findTF(var1_28, "circle/fordark")
	local var3_28 = findTF(var1_28, "info/bk/fordark")

	setActive(var2_28, var0_28.icon_outline == 1)
	setActive(var3_28, var0_28.icon_outline == 1)

	local var4_28 = arg0_28.chapterGroupDict[arg2_28.id]

	assert(var4_28)

	local var5_28 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_28 = 1

	if arg2_28:isUnlock() then
		var6_28 = 2

		if #var4_28.list > 1 then
			var6_28 = table.indexof(var4_28.list, arg2_28.id) + 1
		elseif arg2_28:IsSpChapter() or arg2_28:IsEXChapter() then
			var6_28 = 3
		elseif arg0_28.contextData.map:isHardMap() then
			var6_28 = 3
		end
	end

	local var7_28 = findTF(var1_28, "circle/bk")

	for iter0_28, iter1_28 in ipairs(var5_28) do
		setActive(var7_28:Find(iter1_28), iter0_28 == var6_28)
	end

	local var8_28 = findTF(var1_28, "circle/clear_flag")
	local var9_28 = findTF(var1_28, "circle/lock")
	local var10_28 = findTF(var1_28, "circle/progress")
	local var11_28 = findTF(var1_28, "circle/progress_text")
	local var12_28 = findTF(var1_28, "circle/stars")
	local var13_28 = string.split(var0_28.name, "|")

	setText(findTF(var1_28, "info/bk/title_form/title_index"), var0_28.chapter_name .. "  ")
	setText(findTF(var1_28, "info/bk/title_form/title"), var13_28[1])
	setText(findTF(var1_28, "info/bk/title_form/title_en"), var13_28[2] or "")
	setFillAmount(var10_28, arg2_28.progress / 100)
	setText(var11_28, string.format("%d%%", arg2_28.progress))
	setActive(var12_28, arg2_28:existAchieve())

	if arg2_28:existAchieve() then
		for iter2_28, iter3_28 in ipairs(arg2_28.achieves) do
			local var14_28 = ChapterConst.IsAchieved(iter3_28)
			local var15_28 = var12_28:GetChild(iter2_28 - 1):Find("light")

			setActive(var15_28, var14_28)

			for iter4_28, iter5_28 in ipairs(var5_28) do
				if iter5_28 ~= "Lock" then
					setActive(var15_28:Find(iter5_28), iter4_28 == var6_28)
				end
			end
		end
	end

	local var16_28 = findTF(var1_28, "info/bk/BG")

	for iter6_28, iter7_28 in ipairs(var5_28) do
		setActive(var16_28:Find(iter7_28), iter6_28 == var6_28)
	end

	setActive(findTF(var1_28, "HardEffect"), var6_28 == 3)

	local var17_28 = not arg2_28.active and arg2_28:isClear()
	local var18_28 = not arg2_28.active and not arg2_28:isUnlock()

	setActive(var8_28, var17_28)
	setActive(var9_28, var18_28)
	setActive(var11_28, not var17_28 and not var18_28)
	arg0_28:DeleteTween("fighting" .. arg2_28.id)

	local var19_28 = findTF(var1_28, "circle/fighting")

	setText(findTF(var19_28, "Text"), i18n("tag_level_fighting"))

	local var20_28 = findTF(var1_28, "circle/oni")

	setText(findTF(var20_28, "Text"), i18n("tag_level_oni"))

	local var21_28 = findTF(var1_28, "circle/narrative")

	setText(findTF(var21_28, "Text"), i18n("tag_level_narrative"))
	setActive(var19_28, false)
	setActive(var20_28, false)
	setActive(var21_28, false)

	local var22_28
	local var23_28

	if arg2_28:getConfig("chapter_tag") == 1 then
		var22_28 = var21_28
	end

	if arg2_28.active then
		var22_28 = arg2_28:existOni() and var20_28 or var19_28
	end

	if var22_28 then
		setActive(var22_28, true)

		local var24_28 = GetOrAddComponent(var22_28, "CanvasGroup")

		var24_28.alpha = 1

		arg0_28:RecordTween("fighting" .. arg2_28.id, LeanTween.alphaCanvas(var24_28, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_28 = findTF(var1_28, "triesLimit")
	local var26_28 = arg2_28:isTriesLimit()

	setActive(var25_28, var26_28)

	if var26_28 then
		local var27_28 = arg2_28:getConfig("count")
		local var28_28 = var27_28 - arg2_28:getTodayDefeatCount() .. "/" .. var27_28

		setText(var25_28:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_28:Find("Text"), setColorStr(var28_28, var27_28 <= arg2_28:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_28 = pg.expedition_data_by_map[arg2_28:getConfig("map")].on_activity
		local var30_28 = getProxy(ChapterProxy):IsActivitySPChapterActive(var29_28) and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_28:Find("TipRect"), var30_28)
	end

	local var31_28 = arg2_28:GetDailyBonusQuota()
	local var32_28 = findTF(var1_28, "mark")

	setActive(var32_28:Find("bonus"), var31_28)
	setActive(var32_28, var31_28)

	if var31_28 then
		local var33_28 = var32_28:GetComponent(typeof(CanvasGroup))
		local var34_28 = arg0_28.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_28.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var34_28, var32_28:Find("bonus"))
		LeanTween.cancel(go(var32_28), true)

		local var35_28 = var32_28.anchoredPosition.y

		var33_28.alpha = 0

		LeanTween.value(go(var32_28), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_29)
			var33_28.alpha = arg0_29

			local var0_29 = var32_28.anchoredPosition

			var0_29.y = var35_28 * arg0_29
			var32_28.anchoredPosition = var0_29
		end)):setOnComplete(System.Action(function()
			var33_28.alpha = 1

			local var0_30 = var32_28.anchoredPosition

			var0_30.y = var35_28
			var32_28.anchoredPosition = var0_30
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var36_28 = arg2_28.id

	onButton(arg0_28, var1_28, function()
		arg0_28:TryOpenChapterInfo(var36_28, nil, var4_28.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.SwitchChapter(arg0_32, arg1_32)
	local var0_32 = arg0_32.chapterGroupDict[arg1_32]

	if not var0_32 then
		return
	end

	local var1_32 = var0_32.list[var0_32.index]

	if var1_32 == arg1_32 then
		return
	end

	local var2_32 = table.indexof(var0_32.list, arg1_32)

	var0_32.index = var2_32

	local var3_32 = var0_32.list[1]
	local var4_32 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("spchapter_selected_" .. var4_32 .. "_" .. var3_32, var2_32)

	local var5_32 = arg0_32.chapterTFsById[var1_32]

	arg0_32.chapterTFsById[var1_32] = nil
	arg0_32.chapterTFsById[arg1_32] = var5_32

	arg0_32:UpdateChapterTF(arg1_32)
end

function var0_0.UpdateChapterTF(arg0_33, arg1_33)
	if not arg0_33.chapterGroupDict[arg1_33] then
		return
	end

	local var0_33 = arg0_33.chapterTFsById[arg1_33]

	if var0_33 then
		local var1_33 = getProxy(ChapterProxy):getChapterById(arg1_33)

		arg0_33:UpdateMapItem(var0_33, var1_33)
	end
end

function var0_0.RecyclePools(arg0_34)
	for iter0_34 = #arg0_34.activeItems, 1, -1 do
		local var0_34 = arg0_34.activeItems[iter0_34]
		local var1_34 = arg0_34.pools[var0_34.template]

		if var0_34.template == arg0_34.oneLineTpl then
			setSizeDelta(var0_34.active, {
				x = arg0_34.oneLineWidth,
				y = arg0_34.oneLineHeight
			})
		end

		var1_34:Enqueue(var0_34.active)
	end

	table.clean(arg0_34.activeItems)

	arg0_34.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_35)
	local var0_35 = 0
	local var1_35 = 0
	local var2_35 = pg.NewStoryMgr.GetInstance()
	local var3_35 = {}

	table.Foreach(arg0_35.spStoryIDs, function(arg0_36, arg1_36)
		var3_35[arg1_36] = {}
	end)

	local var4_35 = arg0_35.spStoryNodes

	for iter0_35 = 1, #var4_35 do
		local var5_35 = var4_35[iter0_35]
		local var6_35 = var5_35:GetConfigID()
		local var7_35 = var5_35:GetPreEvent()
		local var8_35 = false
		local var9_35 = var7_35 == 0 and true or var3_35[var7_35].status == var4_0
		local var10_35 = var2_0
		local var11_35 = var5_35:GetStoryName()
		local var12_35 = false

		if var11_35 and var11_35 ~= "" then
			var12_35 = var2_35:IsPlayed(var11_35)
			var0_35 = var0_35 + (var12_35 and 1 or 0)
			var1_35 = var1_35 + 1
		end

		if not var12_35 and var9_35 then
			_.each(var5_35:GetUnlockConditions(), function(arg0_37)
				if arg0_37[1] == ActivitySpStoryNode.CONDITION.TIME then
					local var0_37 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_37[2])
					local var1_37 = pg.TimeMgr.GetInstance():GetServerTime()

					var9_35 = var9_35 and var0_37 <= var1_37
				elseif arg0_37[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var2_37 = arg0_37[2]

					var9_35 = var9_35 and _.all(var2_37, function(arg0_38)
						return getProxy(ChapterProxy):getChapterById(arg0_38, true):isClear()
					end)
				elseif arg0_37[1] == ActivitySpStoryNode.CONDITION.PT then
					local var3_37 = arg0_37[2][1]
					local var4_37 = arg0_37[2][2]
					local var5_37 = arg0_37[2][3]
					local var6_37 = 0

					if var3_37 == DROP_TYPE_RESOURCE then
						var6_37 = getProxy(PlayerProxy):getRawData():getResource(arg0_37[2])
					elseif var3_37 == DROP_TYPE_ITEM then
						var6_37 = getProxy(BagProxy):getItemCountById(var4_37)
					end

					var9_35 = var9_35 and var5_37 <= var6_37
				end
			end)
		end

		if var12_35 then
			var10_35 = var4_0
		elseif var9_35 then
			var10_35 = var3_0
		end

		var3_35[var6_35].status = var10_35
	end

	arg0_35.storyNodeStatus = var3_35
	arg0_35.storyReadCount, arg0_35.storyReadMax = var0_35, var1_35
end

function var0_0.UpdateStory(arg0_39)
	arg0_39:RecyclePools()

	local var0_39 = {
		"162443",
		"ffffff",
		"ffcb5a"
	}
	local var1_39 = arg0_39.data:getConfig("story_inactive_color")

	if var1_39 and #var1_39 > 0 then
		var0_39[1] = var1_39
	end

	local var2_39 = 0
	local var3_39 = 150
	local var4_39 = 150
	local var5_39 = {
		{
			node = arg0_39.storyTree.root,
			nodePos = Vector2.New(var3_39, 0)
		}
	}
	local var6_39 = arg0_39.nodeTplWidth
	local var7_39 = arg0_39.oneLineWidth
	local var8_39 = arg0_39.branchHeadWidth
	local var9_39 = arg0_39.branchUpWidth
	local var10_39 = arg0_39.branchUpHeight
	local var11_39 = arg0_39.UnionTailWidth
	local var12_39 = 75
	local var13_39 = 82
	local var14_39 = 32

	local function var15_39()
		local var0_40 = table.remove(var5_39, 1)
		local var1_40 = var0_40.node:GetConfigID()

		;(function()
			local var0_41 = arg0_39:DequeItem(arg0_39.storyNodeTpl)

			var0_41.name = var1_40

			setAnchoredPosition(var0_41, var0_40.nodePos)

			arg0_39.storyNodeTFsById[var1_40] = {
				nodeTF = tf(var0_41)
			}
		end)()

		local var2_40 = arg0_39.storyTree.childDict[var1_40] or {}

		if #var2_40 == 0 then
			var2_39 = var0_40.nodePos.x + var6_39 + var4_39
		elseif #var2_40 == 1 then
			local var3_40 = var2_40[1]
			local var4_40 = var3_40:GetConfigID()
			local var5_40 = arg0_39:DequeItem(arg0_39.oneLineTpl)

			var5_40.name = string.format("Line%s_%s", var1_40, var4_40)

			setAnchoredPosition(var5_40, var0_40.nodePos + Vector2.New(var6_39 + var14_39, 0))

			nextPos = tf(var5_40).anchoredPosition + Vector2.New(var7_39 + var12_39, 0)

			local var6_40 = arg0_39.storyNodeStatus[var4_40].status

			eachChild(var5_40, function(arg0_42)
				setImageColor(arg0_42, Color.NewHex(var0_39[var6_40]))
			end)
			table.insert(var5_39, {
				node = var3_40,
				nodePos = nextPos
			})
		elseif #var2_40 > 1 then
			local var7_40 = {}
			local var8_40

			table.Ipairs(var2_40, function(arg0_43, arg1_43)
				local var0_43 = 0
				local var1_43 = arg1_43

				local function var2_43()
					var0_43 = var0_43 + 1

					local var0_44 = arg0_39.storyTree.childDict[var1_43:GetConfigID()]

					assert(#var0_44 <= 1)

					local var1_44 = var0_44[1]

					if var1_44 and #var1_44:GetPreNodes() == 1 then
						var1_43 = var1_44

						return true
					else
						var8_40 = var1_44
					end
				end

				while var2_43() do
					-- block empty
				end

				var7_40[arg0_43] = var0_43
			end)

			local var9_40 = _.max(var7_40)
			local var10_40 = var9_40 * (var6_39 + var12_39 + var14_39) + (var9_40 - 1) * var7_39
			local var11_40 = var0_40.nodePos + Vector2.New(var6_39 + var14_39, 0)

			;(function()
				local var0_45 = arg0_39:DequeItem(arg0_39.branchHeadTpl)

				setAnchoredPosition(var0_45, var11_40)

				var11_40 = var11_40 + Vector2.New(var8_39, 0)

				local var1_45 = arg0_39.storyNodeStatus[var2_40[1]:GetConfigID()].status

				eachChild(var0_45, function(arg0_46)
					setImageColor(arg0_46, Color.NewHex(var0_39[var1_45]))
				end)
			end)()
			table.Ipairs(var2_40, function(arg0_47, arg1_47)
				local var0_47 = var7_39

				if var7_40[arg0_47] < var9_40 then
					local var1_47 = var7_40[arg0_47]

					var0_47 = (var10_40 - var1_47 * (var6_39 + var12_39 + var14_39)) / (var1_47 + 1)
				end

				local var2_47 = arg1_47:GetConfigID()
				local var3_47 = var11_40

				;(function()
					local var0_48

					if arg0_47 == 1 then
						var0_48 = arg0_39:DequeItem(arg0_39.branchUpTpl)

						setAnchoredPosition(var0_48, var3_47)

						var3_47 = var3_47 + Vector2.New(var9_39, var10_39)

						if var7_40[arg0_47] < var9_40 then
							setSizeDelta(var0_48, {
								x = var9_39 + var0_47,
								y = var10_39
							})

							local var1_48 = tf(var0_48):Find("Line_1").sizeDelta

							var1_48.x = var1_48.x + var0_47

							setSizeDelta(tf(var0_48):Find("Line_1"), var1_48)

							var3_47 = var3_47 + Vector2.New(var0_47, 0)
						end
					elseif arg0_47 == 3 or arg0_47 == 2 and #var2_40 == 2 then
						var0_48 = arg0_39:DequeItem(arg0_39.branchDownTpl)

						setAnchoredPosition(var0_48, var3_47)

						var3_47 = var3_47 + Vector2.New(var9_39, -var10_39)

						if var7_40[arg0_47] < var9_40 then
							setSizeDelta(var0_48, {
								x = var9_39 + var0_47,
								y = var10_39
							})

							local var2_48 = tf(var0_48):Find("Line_1").sizeDelta

							var2_48.x = var2_48.x + var0_47

							setSizeDelta(tf(var0_48):Find("Line_1"), var2_48)

							var3_47 = var3_47 + Vector2.New(var0_47, 0)
						end
					else
						var0_48 = arg0_39:DequeItem(arg0_39.branchCenterTpl)

						setAnchoredPosition(var0_48, var3_47)

						var3_47 = var3_47 + Vector2.New(var9_39, 0)

						if var7_40[arg0_47] < var9_40 then
							local var3_48 = tf(var0_48).sizeDelta

							var3_48.x = var3_48.x + var0_47

							setSizeDelta(var0_48, var3_48)

							var3_47 = var3_47 + Vector2.New(var0_47, 0)
						end
					end

					var0_48.name = string.format("Branch%s_%s", var1_40, var2_47)

					local var4_48 = arg0_39.storyNodeStatus[var2_47].status

					eachChild(var0_48, function(arg0_49)
						setImageColor(arg0_49, Color.NewHex(var0_39[var4_48]))
					end)
				end)()

				var3_47 = var3_47 + Vector2.New(var12_39, 0)

				local var4_47 = arg0_39:DequeItem(arg0_39.storyNodeTpl)

				var4_47.name = var2_47

				setAnchoredPosition(var4_47, var3_47)

				arg0_39.storyNodeTFsById[var2_47] = {
					nodeTF = tf(var4_47)
				}
				var3_47 = var3_47 + Vector2.New(var6_39 + var14_39, 0)

				local var5_47 = arg0_39.storyTree.childDict[var2_47][1]
				local var6_47 = arg1_47

				local function var7_47()
					if not var5_47 or var5_47 == var8_40 then
						return
					end

					local var0_50 = arg0_39:DequeItem(arg0_39.oneLineTpl)

					var0_50.name = string.format("Line%s_%s", var6_47:GetConfigID(), var5_47:GetConfigID())

					setAnchoredPosition(var0_50, var3_47)

					var3_47 = var3_47 + Vector2.New(var0_47 + var12_39, 0)

					setSizeDelta(var0_50, {
						x = var0_47,
						y = arg0_39.oneLineHeight
					})

					local var1_50 = arg0_39.storyNodeStatus[var5_47:GetConfigID()].status

					eachChild(var0_50, function(arg0_51)
						setImageColor(arg0_51, Color.NewHex(var0_39[var1_50]))
					end)

					local var2_50 = arg0_39:DequeItem(arg0_39.storyNodeTpl)

					var2_50.name = var5_47:GetConfigID()

					setAnchoredPosition(var2_50, var3_47)

					arg0_39.storyNodeTFsById[var5_47:GetConfigID()] = {
						nodeTF = tf(var2_50)
					}
					var3_47 = var3_47 + Vector2.New(var6_39 + var14_39, 0)
					var5_47, var6_47 = arg0_39.storyTree.childDict[var5_47:GetConfigID()][1], var5_47

					return true
				end

				while var7_47() do
					-- block empty
				end

				if var8_40 then
					local var8_47

					if arg0_47 == 1 then
						var8_47 = arg0_39:DequeItem(arg0_39.unionUpTpl)

						setAnchoredPosition(var8_47, var3_47)

						if var7_40[arg0_47] < var9_40 then
							setSizeDelta(var8_47, {
								x = var9_39 + var0_47,
								y = var10_39
							})

							local var9_47 = tf(var8_47):Find("Line_1").sizeDelta

							var9_47.x = var9_47.x + var0_47

							setSizeDelta(tf(var8_47):Find("Line_1"), var9_47)

							var3_47 = var3_47 + Vector2.New(var0_47, 0)
						end
					elseif arg0_47 == 3 or arg0_47 == 2 and #var2_40 == 2 then
						var8_47 = arg0_39:DequeItem(arg0_39.unionDownTpl)

						setAnchoredPosition(var8_47, var3_47)

						if var7_40[arg0_47] < var9_40 then
							setSizeDelta(var8_47, {
								x = var9_39 + var0_47,
								y = var10_39
							})

							local var10_47 = tf(var8_47):Find("Line_1").sizeDelta

							var10_47.x = var10_47.x + var0_47

							setSizeDelta(tf(var8_47):Find("Line_1"), var10_47)

							var3_47 = var3_47 + Vector2.New(var0_47, 0)
						end
					else
						var8_47 = arg0_39:DequeItem(arg0_39.unionCenterTpl)

						setAnchoredPosition(var8_47, var3_47)

						if var7_40[arg0_47] < var9_40 then
							local var11_47 = tf(var8_47).sizeDelta

							var11_47.x = var11_47.x + var0_47

							setSizeDelta(var8_47, var11_47)

							var3_47 = var3_47 + Vector2.New(var0_47, 0)
						end
					end

					var8_47.name = string.format("Union%s_%s", var6_47:GetConfigID(), var8_40:GetConfigID())

					local var12_47 = arg0_39.storyNodeStatus[var8_40:GetConfigID()].status

					eachChild(var8_47, function(arg0_52)
						setImageColor(arg0_52, Color.NewHex(var0_39[var12_47]))
					end)
				end
			end)

			var11_40 = var11_40 + Vector2.New(var10_40 + var9_39, 0)

			if var8_40 then
				(function()
					var11_40 = var11_40 + Vector2.New(var9_39, 0)

					local var0_53 = arg0_39:DequeItem(arg0_39.unionTailTpl)

					setAnchoredPosition(var0_53, var11_40)

					var11_40 = var11_40 + Vector2.New(var11_39 + var13_39, 0)

					local var1_53 = arg0_39.storyNodeStatus[var8_40:GetConfigID()].status

					eachChild(var0_53, function(arg0_54)
						setImageColor(arg0_54, Color.NewHex(var0_39[var1_53]))
					end)
				end)()
				table.insert(var5_39, {
					node = var8_40,
					nodePos = var11_40
				})
			else
				var2_39 = var11_40 + var4_39
			end
		end

		return next(var5_39)
	end

	while var15_39() do
		-- block empty
	end

	setSizeDelta(arg0_39.storyContainer, {
		x = var2_39
	})

	local var16_39 = arg0_39.spStoryNodes

	for iter0_39 = 1, #var16_39 do
		local var17_39 = var16_39[iter0_39]
		local var18_39 = var17_39:GetConfigID()
		local var19_39 = arg0_39.storyNodeStatus[var18_39].status
		local var20_39 = arg0_39.storyNodeTFsById[var18_39].nodeTF
		local var21_39 = var20_39:Find("info/bk/title_form/title")

		if var19_39 == var2_0 then
			setScrollText(var21_39, HXSet.hxLan(var17_39:GetUnlockDesc()))
			setTextAlpha(var21_39, 0.5)
		else
			setScrollText(var21_39, HXSet.hxLan(var17_39:GetDisplayName()))
			setTextAlpha(var21_39, 1)
		end

		local var22_39 = var17_39:GetType()

		setActive(var20_39:Find("circle/lock"), var19_39 == var2_0)

		if var19_39 == var2_0 then
			setActive(var20_39:Find("circle/Story"), false)
			setActive(var20_39:Find("circle/Battle"), false)
			setText(var20_39:Find(""))
		elseif var22_39 == ActivitySpStoryNode.NODE_TYPE.STORY then
			setActive(var20_39:Find("circle/Story"), var22_39 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var20_39:Find("circle/Battle"), var22_39 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var20_39:Find("circle/Story/Done"), var19_39 == var4_0)
		elseif var22_39 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
			setActive(var20_39:Find("circle/Story"), var22_39 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var20_39:Find("circle/Battle"), var22_39 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var20_39:Find("circle/Battle/Done"), var19_39 == var4_0)
		end

		local var23_39 = var19_39 == var4_0

		setActive(var20_39:Find("circle/progress"), var23_39)
		onButton(arg0_39, var20_39, function()
			if var19_39 == var2_0 then
				return
			end

			local var0_55 = var17_39:GetStoryName()

			arg0_39:PlayStory(var0_55, function()
				arg0_39:UpdateView()

				arg0_39.needFocusStory = true

				arg0_39:Move2UnlockStory()
			end, true)
		end)
	end

	local var24_39 = arg0_39.storyReadCount
	local var25_39 = arg0_39.storyReadMax

	setText(arg0_39.progressText, var24_39 .. "/" .. var25_39)
	setActive(arg0_39.storyAward, tobool(arg0_39.storyTask))

	if arg0_39.storyTask then
		local var26_39 = arg0_39.storyTask:getConfig("award_display")
		local var27_39 = Drop.New({
			type = var26_39[1][1],
			id = var26_39[1][2],
			count = var26_39[1][3]
		})

		updateDrop(arg0_39.storyAward:GetChild(0), var27_39)

		local var28_39 = arg0_39.storyTask:getTaskStatus()

		setActive(arg0_39.storyAward:Find("get"), var28_39 == 1)
		setActive(arg0_39.storyAward:Find("got"), var28_39 == 2)
		onButton(arg0_39, arg0_39.storyAward, function()
			arg0_39:emit(BaseUI.ON_DROP, var27_39)
		end)
	end
end

function var0_0.DequeItem(arg0_58, arg1_58)
	local var0_58 = arg0_58.pools[arg1_58]:Dequeue()

	table.insert(arg0_58.activeItems, {
		template = arg1_58,
		active = var0_58
	})
	setActive(var0_58, true)
	setParent(var0_58, arg0_58.storyContainer)

	return var0_58
end

function var0_0.Move2UnlockStory(arg0_59)
	if not arg0_59.needFocusStory then
		return
	end

	arg0_59.needFocusStory = nil

	local var0_59 = arg0_59.spStoryNodes
	local var1_59

	for iter0_59 = #var0_59, 1, -1 do
		local var2_59 = var0_59[iter0_59]:GetConfigID()

		if arg0_59.storyNodeStatus[var2_59].status > var2_0 then
			var1_59 = var2_59

			break
		end
	end

	local var3_59 = arg0_59.storyNodeTFsById[var1_59].nodeTF
	local var4_59 = arg0_59.storyNodeTpl.rect.width
	local var5_59 = var3_59.anchoredPosition.x + var4_59 * 0.5 - arg0_59.storyContainer.parent.rect.width * 0.5
	local var6_59 = math.clamp(var5_59, 0, math.max(0, arg0_59.storyContainer.rect.width - arg0_59.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_59.storyContainer, {
		x = -var6_59
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_60)
	local var0_60 = arg0_60.data:getConfig("default_background")
	local var1_60 = arg0_60.data:getConfig("default_bgm")
	local var2_60
	local var3_60 = arg0_60.spStoryNodes

	for iter0_60 = 1, #var3_60 do
		local var4_60 = var3_60[iter0_60]
		local var5_60 = var4_60:GetConfigID()

		if arg0_60.storyNodeStatus[var5_60].status == var4_0 then
			var0_60, var1_60 = var4_60:GetCleanBG(), var4_60:GetCleanBGM()
			var2_60 = var4_60:GetCleanAnimator()
		else
			break
		end
	end

	arg0_60.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_60,
			Animator = var2_60
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_60.__cname, var1_60)
end

function var0_0.TrySubmitTask(arg0_61)
	local var0_61 = true

	for iter0_61, iter1_61 in ipairs(arg0_61.spStoryNodes) do
		local var1_61 = iter1_61:GetStoryName()

		if var1_61 and var1_61 ~= "" then
			var0_61 = var0_61 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_61)
		end

		if not var0_61 then
			break
		end
	end

	if var0_61 and arg0_61.storyTask and arg0_61.storyTask:getTaskStatus() == 1 then
		arg0_61:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_61.storyTask.id)

		return
	end
end

function var0_0.PlayStory(arg0_62, arg1_62, arg2_62, arg3_62)
	if not arg1_62 then
		return existCall(arg2_62)
	end

	local var0_62 = pg.NewStoryMgr.GetInstance()
	local var1_62 = var0_62:IsPlayed(arg1_62)

	seriesAsync({
		function(arg0_63)
			if var1_62 and not arg3_62 then
				return arg0_63()
			end

			local var0_63 = tonumber(arg1_62)

			if var0_63 and var0_63 > 0 then
				arg0_62:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_63, nil, var1_62)
			else
				var0_62:Play(arg1_62, arg0_63, arg3_62)
			end
		end,
		function(arg0_64, ...)
			existCall(arg2_62, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_65)
	local var0_65 = arg0_65.activity:getConfig("config_client").task_id
	local var1_65 = getProxy(TaskProxy):getTaskVO(var0_65)

	if not var1_65 then
		errorMsg("Missing Activity Task ID : " .. var0_65)
	end

	arg0_65.storyTask = var1_65 or Task.New({
		id = var0_65
	})
end

function var0_0.OnSubmitTaskDone(arg0_66)
	arg0_66:UpdateView()
end

function var0_0.OnDestroy(arg0_67)
	arg0_67:RecyclePools()

	for iter0_67, iter1_67 in pairs(arg0_67.pools) do
		iter1_67:Clear()
	end
end

return var0_0
