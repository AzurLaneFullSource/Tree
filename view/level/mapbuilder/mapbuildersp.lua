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
	setActive(arg0_9.sceneParent.ptTotal, not ActivityConst.HIDE_PT_PANELS and var3_9 and not var2_9 and var1_9 and arg0_9.sceneParent.ptActivity and not arg0_9.sceneParent.ptActivity:isEnd())
end

function var0_0.OnHide(arg0_10)
	setActive(arg0_10.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_10.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_10.sceneParent.topChapter:Find("type_chapter"), false)
	setActive(arg0_10.sceneParent.ptTotal, false)
	setActive(arg0_10.sceneParent.actExchangeShopBtn, false)
	var0_0.super.OnHide(arg0_10)
end

function var0_0.UpdateMapVO(arg0_11, arg1_11)
	var0_0.super.UpdateMapVO(arg0_11, arg1_11)

	arg0_11.activity = getProxy(ActivityProxy):getActivityById(arg1_11:getConfig("on_activity"))

	local var0_11 = getProxy(PlayerProxy):getRawData().id
	local var1_11 = arg1_11:getConfig("chapterGroups")

	arg0_11.chapterGroups = _.map(var1_11, function(arg0_12)
		local var0_12 = arg0_12[1]
		local var1_12 = PlayerPrefs.GetInt("spchapter_selected_" .. var0_11 .. "_" .. var0_12, var0_0.DIFFICULITY.EASY)

		return {
			list = arg0_12,
			index = var1_12
		}
	end)
	arg0_11.chapterGroupDict = {}

	_.each(arg0_11.chapterGroups, function(arg0_13)
		_.each(arg0_13.list, function(arg0_14)
			arg0_11.chapterGroupDict[arg0_14] = arg0_13
		end)
	end)

	arg0_11.displayChapterIDs = _.map(arg0_11.chapterGroups, function(arg0_15)
		return arg0_15.list[arg0_15.index]
	end)

	arg0_11:BuildStoryTree()
end

function var0_0.BuildStoryTree(arg0_16)
	arg0_16.spStoryIDs = arg0_16.data:getConfig("story_id")
	arg0_16.spStoryNodeDict = {}
	arg0_16.spStoryNodes = {}

	local var0_16 = {}

	_.each(arg0_16.spStoryIDs, function(arg0_17)
		arg0_16.spStoryNodeDict[arg0_17] = ActivitySpStoryNode.New({
			configId = arg0_17
		})

		local var0_17 = arg0_16.spStoryNodeDict[arg0_17]

		var0_16[var0_17:GetPreEvent()] = arg0_17
	end)

	local var1_16 = 0

	local function var2_16()
		if not var0_16[var1_16] then
			return
		end

		var1_16 = var0_16[var1_16]

		table.insert(arg0_16.spStoryNodes, arg0_16.spStoryNodeDict[var1_16])

		return true
	end

	while var2_16() do
		-- block empty
	end

	local var3_16 = {}
	local var4_16

	_.each(arg0_16.spStoryNodes, function(arg0_19)
		local var0_19 = arg0_19:GetPreNodes()

		if #var0_19 == 0 then
			var4_16 = arg0_19

			return
		end

		_.each(var0_19, function(arg0_20)
			var3_16[arg0_20] = var3_16[arg0_20] or {}

			table.insert(var3_16[arg0_20], arg0_19)
		end)
	end)

	arg0_16.storyTree = {
		root = var4_16,
		childDict = var3_16
	}
end

function var0_0.SetDisplayMode(arg0_21, arg1_21)
	if arg1_21 == arg0_21.contextData.displayMode then
		return
	end

	arg0_21.contextData.displayMode = arg1_21

	arg0_21:UpdateView()
end

function var0_0.UpdateView(arg0_22)
	local var0_22 = string.split(arg0_22.contextData.map:getConfig("name"), "||")

	setText(arg0_22.sceneParent.chapterName, var0_22[1])

	local var1_22 = arg0_22.contextData.map:getMapTitleNumber()

	arg0_22.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_22, arg0_22.sceneParent.chapterNoTitle, true)

	arg0_22.contextData.displayMode = arg0_22.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_22)

	local var2_22 = arg0_22.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_22._tf:Find("Battle"), var2_22)
	setActive(arg0_22._tf:Find("Story"), not var2_22)

	local var3_22 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_22.battleLayer:Find("Story/BattleTip"), false)
	setActive(arg0_22.storyLayer:Find("Battle/BattleTip"), var3_22)
	arg0_22:UpdateStoryTask()

	if var2_22 then
		arg0_22:UpdateBattle()
		arg0_22.sceneParent:SwitchMapBG(arg0_22.contextData.map)
		arg0_22.sceneParent:PlayBGM()
	else
		arg0_22:UpdateStoryNodeStatus()
		arg0_22:UpdateStory()
		arg0_22:Move2UnlockStory()
		arg0_22:SwitchStoryMapAndBGM()
	end

	arg0_22:TrySubmitTask()
end

function var0_0.UpdateBattle(arg0_23)
	local var0_23 = getProxy(ChapterProxy)
	local var1_23 = arg0_23.displayChapterIDs
	local var2_23 = {}

	for iter0_23, iter1_23 in ipairs(var1_23) do
		local var3_23 = var0_23:getChapterById(iter1_23)

		table.insert(var2_23, var3_23)
	end

	table.clear(arg0_23.chapterTFsById)
	UIItemList.StaticAlign(arg0_23.itemHolder, arg0_23.chapterTpl, #var2_23, function(arg0_24, arg1_24, arg2_24)
		if arg0_24 ~= UIItemList.EventUpdate then
			return
		end

		local var0_24 = var2_23[arg1_24 + 1]

		arg0_23:UpdateMapItem(arg2_24, var0_24)

		arg2_24.name = "Chapter_" .. var0_24.id
		arg0_23.chapterTFsById[var0_24.id] = arg2_24
	end)
end

function var0_0.HideFloat(arg0_25)
	var0_0.super.HideFloat(arg0_25)
	setActive(arg0_25.itemHolder, false)
end

function var0_0.ShowFloat(arg0_26)
	var0_0.super.ShowFloat(arg0_26)
	setActive(arg0_26.itemHolder, true)
end

function var0_0.UpdateMapItem(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg2_27:getConfigTable()

	setAnchoredPosition(arg1_27, {
		x = arg0_27.mapWidth * var0_27.pos_x,
		y = arg0_27.mapHeight * var0_27.pos_y
	})

	local var1_27 = findTF(arg1_27, "main")

	setActive(var1_27, true)

	local var2_27 = findTF(var1_27, "circle/fordark")
	local var3_27 = findTF(var1_27, "info/bk/fordark")

	setActive(var2_27, var0_27.icon_outline == 1)
	setActive(var3_27, var0_27.icon_outline == 1)

	local var4_27 = arg0_27.chapterGroupDict[arg2_27.id]

	assert(var4_27)

	local var5_27 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_27 = 1

	if arg2_27:isUnlock() then
		var6_27 = 2

		if #var4_27.list > 1 then
			var6_27 = table.indexof(var4_27.list, arg2_27.id) + 1
		elseif arg2_27:IsSpChapter() or arg2_27:IsEXChapter() then
			var6_27 = 3
		elseif arg0_27.contextData.map:isHardMap() then
			var6_27 = 3
		end
	end

	local var7_27 = findTF(var1_27, "circle/bk")

	for iter0_27, iter1_27 in ipairs(var5_27) do
		setActive(var7_27:Find(iter1_27), iter0_27 == var6_27)
	end

	local var8_27 = findTF(var1_27, "circle/clear_flag")
	local var9_27 = findTF(var1_27, "circle/lock")
	local var10_27 = findTF(var1_27, "circle/progress")
	local var11_27 = findTF(var1_27, "circle/progress_text")
	local var12_27 = findTF(var1_27, "circle/stars")
	local var13_27 = string.split(var0_27.name, "|")

	setText(findTF(var1_27, "info/bk/title_form/title_index"), var0_27.chapter_name .. "  ")
	setText(findTF(var1_27, "info/bk/title_form/title"), var13_27[1])
	setText(findTF(var1_27, "info/bk/title_form/title_en"), var13_27[2] or "")
	setFillAmount(var10_27, arg2_27.progress / 100)
	setText(var11_27, string.format("%d%%", arg2_27.progress))
	setActive(var12_27, arg2_27:existAchieve())

	if arg2_27:existAchieve() then
		for iter2_27, iter3_27 in ipairs(arg2_27.achieves) do
			local var14_27 = ChapterConst.IsAchieved(iter3_27)
			local var15_27 = var12_27:GetChild(iter2_27 - 1):Find("light")

			setActive(var15_27, var14_27)

			for iter4_27, iter5_27 in ipairs(var5_27) do
				if iter5_27 ~= "Lock" then
					setActive(var15_27:Find(iter5_27), iter4_27 == var6_27)
				end
			end
		end
	end

	local var16_27 = findTF(var1_27, "info/bk/BG")

	for iter6_27, iter7_27 in ipairs(var5_27) do
		setActive(var16_27:Find(iter7_27), iter6_27 == var6_27)
	end

	setActive(findTF(var1_27, "HardEffect"), var6_27 == 3)

	local var17_27 = not arg2_27.active and arg2_27:isClear()
	local var18_27 = not arg2_27.active and not arg2_27:isUnlock()

	setActive(var8_27, var17_27)
	setActive(var9_27, var18_27)
	setActive(var11_27, not var17_27 and not var18_27)
	arg0_27:DeleteTween("fighting" .. arg2_27.id)

	local var19_27 = findTF(var1_27, "circle/fighting")

	setText(findTF(var19_27, "Text"), i18n("tag_level_fighting"))

	local var20_27 = findTF(var1_27, "circle/oni")

	setText(findTF(var20_27, "Text"), i18n("tag_level_oni"))

	local var21_27 = findTF(var1_27, "circle/narrative")

	setText(findTF(var21_27, "Text"), i18n("tag_level_narrative"))
	setActive(var19_27, false)
	setActive(var20_27, false)
	setActive(var21_27, false)

	local var22_27
	local var23_27

	if arg2_27:getConfig("chapter_tag") == 1 then
		var22_27 = var21_27
	end

	if arg2_27.active then
		var22_27 = arg2_27:existOni() and var20_27 or var19_27
	end

	if var22_27 then
		setActive(var22_27, true)

		local var24_27 = GetOrAddComponent(var22_27, "CanvasGroup")

		var24_27.alpha = 1

		arg0_27:RecordTween("fighting" .. arg2_27.id, LeanTween.alphaCanvas(var24_27, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_27 = findTF(var1_27, "triesLimit")
	local var26_27 = arg2_27:isTriesLimit()

	setActive(var25_27, var26_27)

	if var26_27 then
		local var27_27 = arg2_27:getConfig("count")
		local var28_27 = var27_27 - arg2_27:getTodayDefeatCount() .. "/" .. var27_27

		setText(var25_27:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_27:Find("Text"), setColorStr(var28_27, var27_27 <= arg2_27:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_27 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_27:Find("TipRect"), var29_27)
	end

	local var30_27 = arg2_27:GetDailyBonusQuota()
	local var31_27 = findTF(var1_27, "mark")

	setActive(var31_27:Find("bonus"), var30_27)
	setActive(var31_27, var30_27)

	if var30_27 then
		local var32_27 = var31_27:GetComponent(typeof(CanvasGroup))
		local var33_27 = arg0_27.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_27.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var33_27, var31_27:Find("bonus"))
		LeanTween.cancel(go(var31_27), true)

		local var34_27 = var31_27.anchoredPosition.y

		var32_27.alpha = 0

		LeanTween.value(go(var31_27), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_28)
			var32_27.alpha = arg0_28

			local var0_28 = var31_27.anchoredPosition

			var0_28.y = var34_27 * arg0_28
			var31_27.anchoredPosition = var0_28
		end)):setOnComplete(System.Action(function()
			var32_27.alpha = 1

			local var0_29 = var31_27.anchoredPosition

			var0_29.y = var34_27
			var31_27.anchoredPosition = var0_29
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var35_27 = arg2_27.id

	onButton(arg0_27, var1_27, function()
		arg0_27:TryOpenChapterInfo(var35_27, nil, var4_27.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.SwitchChapter(arg0_31, arg1_31)
	local var0_31 = arg0_31.chapterGroupDict[arg1_31]

	if not var0_31 then
		return
	end

	local var1_31 = var0_31.list[var0_31.index]

	if var1_31 == arg1_31 then
		return
	end

	local var2_31 = table.indexof(var0_31.list, arg1_31)

	var0_31.index = var2_31

	local var3_31 = var0_31.list[1]
	local var4_31 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("spchapter_selected_" .. var4_31 .. "_" .. var3_31, var2_31)

	local var5_31 = arg0_31.chapterTFsById[var1_31]

	arg0_31.chapterTFsById[var1_31] = nil
	arg0_31.chapterTFsById[arg1_31] = var5_31

	arg0_31:UpdateChapterTF(arg1_31)
end

function var0_0.UpdateChapterTF(arg0_32, arg1_32)
	if not arg0_32.chapterGroupDict[arg1_32] then
		return
	end

	local var0_32 = arg0_32.chapterTFsById[arg1_32]

	if var0_32 then
		local var1_32 = getProxy(ChapterProxy):getChapterById(arg1_32)

		arg0_32:UpdateMapItem(var0_32, var1_32)
	end
end

function var0_0.RecyclePools(arg0_33)
	for iter0_33 = #arg0_33.activeItems, 1, -1 do
		local var0_33 = arg0_33.activeItems[iter0_33]
		local var1_33 = arg0_33.pools[var0_33.template]

		if var0_33.template == arg0_33.oneLineTpl then
			setSizeDelta(var0_33.active, {
				x = arg0_33.oneLineWidth,
				y = arg0_33.oneLineHeight
			})
		end

		var1_33:Enqueue(var0_33.active)
	end

	table.clean(arg0_33.activeItems)

	arg0_33.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_34)
	local var0_34 = 0
	local var1_34 = 0
	local var2_34 = pg.NewStoryMgr.GetInstance()
	local var3_34 = {}

	table.Foreach(arg0_34.spStoryIDs, function(arg0_35, arg1_35)
		var3_34[arg1_35] = {}
	end)

	local var4_34 = arg0_34.spStoryNodes

	for iter0_34 = 1, #var4_34 do
		local var5_34 = var4_34[iter0_34]
		local var6_34 = var5_34:GetConfigID()
		local var7_34 = var5_34:GetPreEvent()
		local var8_34 = false
		local var9_34 = var7_34 == 0 and true or var3_34[var7_34].status == var4_0
		local var10_34 = var2_0
		local var11_34 = var5_34:GetStoryName()
		local var12_34 = false

		if var11_34 and var11_34 ~= "" then
			var12_34 = var2_34:IsPlayed(var11_34)
			var0_34 = var0_34 + (var12_34 and 1 or 0)
			var1_34 = var1_34 + 1
		end

		if not var12_34 and var9_34 then
			_.each(var5_34:GetUnlockConditions(), function(arg0_36)
				if arg0_36[1] == ActivitySpStoryNode.CONDITION.TIME then
					local var0_36 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_36[2])
					local var1_36 = pg.TimeMgr.GetInstance():GetServerTime()

					var9_34 = var9_34 and var0_36 <= var1_36
				elseif arg0_36[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var2_36 = arg0_36[2]

					var9_34 = var9_34 and _.all(var2_36, function(arg0_37)
						return getProxy(ChapterProxy):getChapterById(arg0_37, true):isClear()
					end)
				elseif arg0_36[1] == ActivitySpStoryNode.CONDITION.PT then
					local var3_36 = arg0_36[2][1]
					local var4_36 = arg0_36[2][2]
					local var5_36 = arg0_36[2][3]
					local var6_36 = 0

					if var3_36 == DROP_TYPE_RESOURCE then
						var6_36 = getProxy(PlayerProxy):getRawData():getResource(arg0_36[2])
					elseif var3_36 == DROP_TYPE_ITEM then
						var6_36 = getProxy(BagProxy):getItemCountById(var4_36)
					end

					var9_34 = var9_34 and var5_36 <= var6_36
				end
			end)
		end

		if var12_34 then
			var10_34 = var4_0
		elseif var9_34 then
			var10_34 = var3_0
		end

		var3_34[var6_34].status = var10_34
	end

	arg0_34.storyNodeStatus = var3_34
	arg0_34.storyReadCount, arg0_34.storyReadMax = var0_34, var1_34
end

function var0_0.UpdateStory(arg0_38)
	arg0_38:RecyclePools()

	local var0_38 = {
		"162443",
		"ffffff",
		"ffcb5a"
	}
	local var1_38 = arg0_38.data:getConfig("story_inactive_color")

	if var1_38 and #var1_38 > 0 then
		var0_38[1] = var1_38
	end

	local var2_38 = 0
	local var3_38 = 150
	local var4_38 = 150
	local var5_38 = {
		{
			node = arg0_38.storyTree.root,
			nodePos = Vector2.New(var3_38, 0)
		}
	}
	local var6_38 = arg0_38.nodeTplWidth
	local var7_38 = arg0_38.oneLineWidth
	local var8_38 = arg0_38.branchHeadWidth
	local var9_38 = arg0_38.branchUpWidth
	local var10_38 = arg0_38.branchUpHeight
	local var11_38 = arg0_38.UnionTailWidth
	local var12_38 = 75
	local var13_38 = 82
	local var14_38 = 32

	local function var15_38()
		local var0_39 = table.remove(var5_38, 1)
		local var1_39 = var0_39.node:GetConfigID()

		;(function()
			local var0_40 = arg0_38:DequeItem(arg0_38.storyNodeTpl)

			var0_40.name = var1_39

			setAnchoredPosition(var0_40, var0_39.nodePos)

			arg0_38.storyNodeTFsById[var1_39] = {
				nodeTF = tf(var0_40)
			}
		end)()

		local var2_39 = arg0_38.storyTree.childDict[var1_39] or {}

		if #var2_39 == 0 then
			var2_38 = var0_39.nodePos.x + var6_38 + var4_38
		elseif #var2_39 == 1 then
			local var3_39 = var2_39[1]
			local var4_39 = var3_39:GetConfigID()
			local var5_39 = arg0_38:DequeItem(arg0_38.oneLineTpl)

			var5_39.name = string.format("Line%s_%s", var1_39, var4_39)

			setAnchoredPosition(var5_39, var0_39.nodePos + Vector2.New(var6_38 + var14_38, 0))

			nextPos = tf(var5_39).anchoredPosition + Vector2.New(var7_38 + var12_38, 0)

			local var6_39 = arg0_38.storyNodeStatus[var4_39].status

			eachChild(var5_39, function(arg0_41)
				setImageColor(arg0_41, Color.NewHex(var0_38[var6_39]))
			end)
			table.insert(var5_38, {
				node = var3_39,
				nodePos = nextPos
			})
		elseif #var2_39 > 1 then
			local var7_39 = {}
			local var8_39

			table.Ipairs(var2_39, function(arg0_42, arg1_42)
				local var0_42 = 0
				local var1_42 = arg1_42

				local function var2_42()
					var0_42 = var0_42 + 1

					local var0_43 = arg0_38.storyTree.childDict[var1_42:GetConfigID()]

					assert(#var0_43 <= 1)

					local var1_43 = var0_43[1]

					if var1_43 and #var1_43:GetPreNodes() == 1 then
						var1_42 = var1_43

						return true
					else
						var8_39 = var1_43
					end
				end

				while var2_42() do
					-- block empty
				end

				var7_39[arg0_42] = var0_42
			end)

			local var9_39 = _.max(var7_39)
			local var10_39 = var9_39 * (var6_38 + var12_38 + var14_38) + (var9_39 - 1) * var7_38
			local var11_39 = var0_39.nodePos + Vector2.New(var6_38 + var14_38, 0)

			;(function()
				local var0_44 = arg0_38:DequeItem(arg0_38.branchHeadTpl)

				setAnchoredPosition(var0_44, var11_39)

				var11_39 = var11_39 + Vector2.New(var8_38, 0)

				local var1_44 = arg0_38.storyNodeStatus[var2_39[1]:GetConfigID()].status

				eachChild(var0_44, function(arg0_45)
					setImageColor(arg0_45, Color.NewHex(var0_38[var1_44]))
				end)
			end)()
			table.Ipairs(var2_39, function(arg0_46, arg1_46)
				local var0_46 = var7_38

				if var7_39[arg0_46] < var9_39 then
					local var1_46 = var7_39[arg0_46]

					var0_46 = (var10_39 - var1_46 * (var6_38 + var12_38 + var14_38)) / (var1_46 + 1)
				end

				local var2_46 = arg1_46:GetConfigID()
				local var3_46 = var11_39

				;(function()
					local var0_47

					if arg0_46 == 1 then
						var0_47 = arg0_38:DequeItem(arg0_38.branchUpTpl)

						setAnchoredPosition(var0_47, var3_46)

						var3_46 = var3_46 + Vector2.New(var9_38, var10_38)

						if var7_39[arg0_46] < var9_39 then
							setSizeDelta(var0_47, {
								x = var9_38 + var0_46,
								y = var10_38
							})

							local var1_47 = tf(var0_47):Find("Line_1").sizeDelta

							var1_47.x = var1_47.x + var0_46

							setSizeDelta(tf(var0_47):Find("Line_1"), var1_47)

							var3_46 = var3_46 + Vector2.New(var0_46, 0)
						end
					elseif arg0_46 == 3 or arg0_46 == 2 and #var2_39 == 2 then
						var0_47 = arg0_38:DequeItem(arg0_38.branchDownTpl)

						setAnchoredPosition(var0_47, var3_46)

						var3_46 = var3_46 + Vector2.New(var9_38, -var10_38)

						if var7_39[arg0_46] < var9_39 then
							setSizeDelta(var0_47, {
								x = var9_38 + var0_46,
								y = var10_38
							})

							local var2_47 = tf(var0_47):Find("Line_1").sizeDelta

							var2_47.x = var2_47.x + var0_46

							setSizeDelta(tf(var0_47):Find("Line_1"), var2_47)

							var3_46 = var3_46 + Vector2.New(var0_46, 0)
						end
					else
						var0_47 = arg0_38:DequeItem(arg0_38.branchCenterTpl)

						setAnchoredPosition(var0_47, var3_46)

						var3_46 = var3_46 + Vector2.New(var9_38, 0)

						if var7_39[arg0_46] < var9_39 then
							local var3_47 = tf(var0_47).sizeDelta

							var3_47.x = var3_47.x + var0_46

							setSizeDelta(var0_47, var3_47)

							var3_46 = var3_46 + Vector2.New(var0_46, 0)
						end
					end

					var0_47.name = string.format("Branch%s_%s", var1_39, var2_46)

					local var4_47 = arg0_38.storyNodeStatus[var2_46].status

					eachChild(var0_47, function(arg0_48)
						setImageColor(arg0_48, Color.NewHex(var0_38[var4_47]))
					end)
				end)()

				var3_46 = var3_46 + Vector2.New(var12_38, 0)

				local var4_46 = arg0_38:DequeItem(arg0_38.storyNodeTpl)

				var4_46.name = var2_46

				setAnchoredPosition(var4_46, var3_46)

				arg0_38.storyNodeTFsById[var2_46] = {
					nodeTF = tf(var4_46)
				}
				var3_46 = var3_46 + Vector2.New(var6_38 + var14_38, 0)

				local var5_46 = arg0_38.storyTree.childDict[var2_46][1]
				local var6_46 = arg1_46

				local function var7_46()
					if not var5_46 or var5_46 == var8_39 then
						return
					end

					local var0_49 = arg0_38:DequeItem(arg0_38.oneLineTpl)

					var0_49.name = string.format("Line%s_%s", var6_46:GetConfigID(), var5_46:GetConfigID())

					setAnchoredPosition(var0_49, var3_46)

					var3_46 = var3_46 + Vector2.New(var0_46 + var12_38, 0)

					setSizeDelta(var0_49, {
						x = var0_46,
						y = arg0_38.oneLineHeight
					})

					local var1_49 = arg0_38.storyNodeStatus[var5_46:GetConfigID()].status

					eachChild(var0_49, function(arg0_50)
						setImageColor(arg0_50, Color.NewHex(var0_38[var1_49]))
					end)

					local var2_49 = arg0_38:DequeItem(arg0_38.storyNodeTpl)

					var2_49.name = var5_46:GetConfigID()

					setAnchoredPosition(var2_49, var3_46)

					arg0_38.storyNodeTFsById[var5_46:GetConfigID()] = {
						nodeTF = tf(var2_49)
					}
					var3_46 = var3_46 + Vector2.New(var6_38 + var14_38, 0)
					var5_46, var6_46 = arg0_38.storyTree.childDict[var5_46:GetConfigID()][1], var5_46

					return true
				end

				while var7_46() do
					-- block empty
				end

				if var8_39 then
					local var8_46

					if arg0_46 == 1 then
						var8_46 = arg0_38:DequeItem(arg0_38.unionUpTpl)

						setAnchoredPosition(var8_46, var3_46)

						if var7_39[arg0_46] < var9_39 then
							setSizeDelta(var8_46, {
								x = var9_38 + var0_46,
								y = var10_38
							})

							local var9_46 = tf(var8_46):Find("Line_1").sizeDelta

							var9_46.x = var9_46.x + var0_46

							setSizeDelta(tf(var8_46):Find("Line_1"), var9_46)

							var3_46 = var3_46 + Vector2.New(var0_46, 0)
						end
					elseif arg0_46 == 3 or arg0_46 == 2 and #var2_39 == 2 then
						var8_46 = arg0_38:DequeItem(arg0_38.unionDownTpl)

						setAnchoredPosition(var8_46, var3_46)

						if var7_39[arg0_46] < var9_39 then
							setSizeDelta(var8_46, {
								x = var9_38 + var0_46,
								y = var10_38
							})

							local var10_46 = tf(var8_46):Find("Line_1").sizeDelta

							var10_46.x = var10_46.x + var0_46

							setSizeDelta(tf(var8_46):Find("Line_1"), var10_46)

							var3_46 = var3_46 + Vector2.New(var0_46, 0)
						end
					else
						var8_46 = arg0_38:DequeItem(arg0_38.unionCenterTpl)

						setAnchoredPosition(var8_46, var3_46)

						if var7_39[arg0_46] < var9_39 then
							local var11_46 = tf(var8_46).sizeDelta

							var11_46.x = var11_46.x + var0_46

							setSizeDelta(var8_46, var11_46)

							var3_46 = var3_46 + Vector2.New(var0_46, 0)
						end
					end

					var8_46.name = string.format("Union%s_%s", var6_46:GetConfigID(), var8_39:GetConfigID())

					local var12_46 = arg0_38.storyNodeStatus[var8_39:GetConfigID()].status

					eachChild(var8_46, function(arg0_51)
						setImageColor(arg0_51, Color.NewHex(var0_38[var12_46]))
					end)
				end
			end)

			var11_39 = var11_39 + Vector2.New(var10_39 + var9_38, 0)

			if var8_39 then
				(function()
					var11_39 = var11_39 + Vector2.New(var9_38, 0)

					local var0_52 = arg0_38:DequeItem(arg0_38.unionTailTpl)

					setAnchoredPosition(var0_52, var11_39)

					var11_39 = var11_39 + Vector2.New(var11_38 + var13_38, 0)

					local var1_52 = arg0_38.storyNodeStatus[var8_39:GetConfigID()].status

					eachChild(var0_52, function(arg0_53)
						setImageColor(arg0_53, Color.NewHex(var0_38[var1_52]))
					end)
				end)()
				table.insert(var5_38, {
					node = var8_39,
					nodePos = var11_39
				})
			else
				var2_38 = var11_39 + var4_38
			end
		end

		return next(var5_38)
	end

	while var15_38() do
		-- block empty
	end

	setSizeDelta(arg0_38.storyContainer, {
		x = var2_38
	})

	local var16_38 = arg0_38.spStoryNodes

	for iter0_38 = 1, #var16_38 do
		local var17_38 = var16_38[iter0_38]
		local var18_38 = var17_38:GetConfigID()
		local var19_38 = arg0_38.storyNodeStatus[var18_38].status
		local var20_38 = arg0_38.storyNodeTFsById[var18_38].nodeTF
		local var21_38 = var20_38:Find("info/bk/title_form/title")

		if var19_38 == var2_0 then
			setScrollText(var21_38, HXSet.hxLan(var17_38:GetUnlockDesc()))
			setTextAlpha(var21_38, 0.5)
		else
			setScrollText(var21_38, HXSet.hxLan(var17_38:GetDisplayName()))
			setTextAlpha(var21_38, 1)
		end

		local var22_38 = var17_38:GetType()

		setActive(var20_38:Find("circle/lock"), var19_38 == var2_0)

		if var19_38 == var2_0 then
			setActive(var20_38:Find("circle/Story"), false)
			setActive(var20_38:Find("circle/Battle"), false)
			setText(var20_38:Find(""))
		elseif var22_38 == ActivitySpStoryNode.NODE_TYPE.STORY then
			setActive(var20_38:Find("circle/Story"), var22_38 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var20_38:Find("circle/Battle"), var22_38 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var20_38:Find("circle/Story/Done"), var19_38 == var4_0)
		elseif var22_38 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
			setActive(var20_38:Find("circle/Story"), var22_38 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var20_38:Find("circle/Battle"), var22_38 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var20_38:Find("circle/Battle/Done"), var19_38 == var4_0)
		end

		local var23_38 = var19_38 == var4_0

		setActive(var20_38:Find("circle/progress"), var23_38)
		onButton(arg0_38, var20_38, function()
			if var19_38 == var2_0 then
				return
			end

			local var0_54 = var17_38:GetStoryName()

			arg0_38:PlayStory(var0_54, function()
				arg0_38:UpdateView()

				arg0_38.needFocusStory = true

				arg0_38:Move2UnlockStory()
			end, true)
		end)
	end

	local var24_38 = arg0_38.storyReadCount
	local var25_38 = arg0_38.storyReadMax

	setText(arg0_38.progressText, var24_38 .. "/" .. var25_38)
	setActive(arg0_38.storyAward, tobool(arg0_38.storyTask))

	if arg0_38.storyTask then
		local var26_38 = arg0_38.storyTask:getConfig("award_display")
		local var27_38 = Drop.New({
			type = var26_38[1][1],
			id = var26_38[1][2],
			count = var26_38[1][3]
		})

		updateDrop(arg0_38.storyAward:GetChild(0), var27_38)

		local var28_38 = arg0_38.storyTask:getTaskStatus()

		setActive(arg0_38.storyAward:Find("get"), var28_38 == 1)
		setActive(arg0_38.storyAward:Find("got"), var28_38 == 2)
		onButton(arg0_38, arg0_38.storyAward, function()
			arg0_38:emit(BaseUI.ON_DROP, var27_38)
		end)
	end
end

function var0_0.DequeItem(arg0_57, arg1_57)
	local var0_57 = arg0_57.pools[arg1_57]:Dequeue()

	table.insert(arg0_57.activeItems, {
		template = arg1_57,
		active = var0_57
	})
	setActive(var0_57, true)
	setParent(var0_57, arg0_57.storyContainer)

	return var0_57
end

function var0_0.Move2UnlockStory(arg0_58)
	if not arg0_58.needFocusStory then
		return
	end

	arg0_58.needFocusStory = nil

	local var0_58 = arg0_58.spStoryNodes
	local var1_58

	for iter0_58 = #var0_58, 1, -1 do
		local var2_58 = var0_58[iter0_58]:GetConfigID()

		if arg0_58.storyNodeStatus[var2_58].status > var2_0 then
			var1_58 = var2_58

			break
		end
	end

	local var3_58 = arg0_58.storyNodeTFsById[var1_58].nodeTF
	local var4_58 = arg0_58.storyNodeTpl.rect.width
	local var5_58 = var3_58.anchoredPosition.x + var4_58 * 0.5 - arg0_58.storyContainer.parent.rect.width * 0.5
	local var6_58 = math.clamp(var5_58, 0, math.max(0, arg0_58.storyContainer.rect.width - arg0_58.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_58.storyContainer, {
		x = -var6_58
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_59)
	local var0_59 = arg0_59.data:getConfig("default_background")
	local var1_59 = arg0_59.data:getConfig("default_bgm")
	local var2_59
	local var3_59 = arg0_59.spStoryNodes

	for iter0_59 = 1, #var3_59 do
		local var4_59 = var3_59[iter0_59]
		local var5_59 = var4_59:GetConfigID()

		if arg0_59.storyNodeStatus[var5_59].status == var4_0 then
			var0_59, var1_59 = var4_59:GetCleanBG(), var4_59:GetCleanBGM()
			var2_59 = var4_59:GetCleanAnimator()
		else
			break
		end
	end

	arg0_59.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_59,
			Animator = var2_59
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_59.__cname, var1_59)
end

function var0_0.TrySubmitTask(arg0_60)
	local var0_60 = true

	for iter0_60, iter1_60 in ipairs(arg0_60.spStoryNodes) do
		local var1_60 = iter1_60:GetStoryName()

		if var1_60 and var1_60 ~= "" then
			var0_60 = var0_60 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_60)
		end

		if not var0_60 then
			break
		end
	end

	if var0_60 and arg0_60.storyTask and arg0_60.storyTask:getTaskStatus() == 1 then
		arg0_60:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_60.storyTask.id)

		return
	end
end

function var0_0.PlayStory(arg0_61, arg1_61, arg2_61, arg3_61)
	if not arg1_61 then
		return existCall(arg2_61)
	end

	local var0_61 = pg.NewStoryMgr.GetInstance()
	local var1_61 = var0_61:IsPlayed(arg1_61)

	seriesAsync({
		function(arg0_62)
			if var1_61 and not arg3_61 then
				return arg0_62()
			end

			local var0_62 = tonumber(arg1_61)

			if var0_62 and var0_62 > 0 then
				arg0_61:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_62, nil, var1_61)
			else
				var0_61:Play(arg1_61, arg0_62, arg3_61)
			end
		end,
		function(arg0_63, ...)
			existCall(arg2_61, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_64)
	local var0_64 = arg0_64.activity:getConfig("config_client").task_id
	local var1_64 = getProxy(TaskProxy):getTaskVO(var0_64)

	if not var1_64 then
		errorMsg("Missing Activity Task ID : " .. var0_64)
	end

	arg0_64.storyTask = var1_64 or Task.New({
		id = var0_64
	})
end

function var0_0.OnSubmitTaskDone(arg0_65)
	arg0_65:UpdateView()
end

function var0_0.OnDestroy(arg0_66)
	arg0_66:RecyclePools()

	for iter0_66, iter1_66 in pairs(arg0_66.pools) do
		iter1_66:Clear()
	end
end

return var0_0
