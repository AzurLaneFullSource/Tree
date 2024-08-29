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
	arg0_3._tf:SetSiblingIndex(5)
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
		[arg0_4.storyNodeTpl] = var1_0.New(go(arg0_4.storyNodeTpl), 16),
		[arg0_4.oneLineTpl] = var1_0.New(go(arg0_4.oneLineTpl), 16),
		[arg0_4.branchHeadTpl] = var1_0.New(go(arg0_4.branchHeadTpl), 16),
		[arg0_4.branchCenterTpl] = var1_0.New(go(arg0_4.branchCenterTpl), 16),
		[arg0_4.branchUpTpl] = var1_0.New(go(arg0_4.branchUpTpl), 16),
		[arg0_4.branchDownTpl] = var1_0.New(go(arg0_4.branchDownTpl), 16),
		[arg0_4.unionTailTpl] = var1_0.New(go(arg0_4.unionTailTpl), 16),
		[arg0_4.unionCenterTpl] = var1_0.New(go(arg0_4.unionCenterTpl), 16),
		[arg0_4.unionUpTpl] = var1_0.New(go(arg0_4.unionUpTpl), 16),
		[arg0_4.unionDownTpl] = var1_0.New(go(arg0_4.unionDownTpl), 16)
	}
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

	_.each(arg0_16.spStoryIDs, function(arg0_17)
		arg0_16.spStoryNodeDict[arg0_17] = ActivitySpStoryNode.New({
			configId = arg0_17
		})

		table.insert(arg0_16.spStoryNodes, arg0_16.spStoryNodeDict[arg0_17])
	end)

	local var0_16 = {}
	local var1_16

	_.each(arg0_16.spStoryNodes, function(arg0_18)
		local var0_18 = arg0_18:GetPreNodes()

		if #var0_18 == 0 then
			var1_16 = arg0_18

			return
		end

		_.each(var0_18, function(arg0_19)
			var0_16[arg0_19] = var0_16[arg0_19] or {}

			table.insert(var0_16[arg0_19], arg0_18)
		end)
	end)

	arg0_16.storyTree = {
		root = var1_16,
		childDict = var0_16
	}
end

function var0_0.SetDisplayMode(arg0_20, arg1_20)
	if arg1_20 == arg0_20.contextData.displayMode then
		return
	end

	arg0_20.contextData.displayMode = arg1_20

	arg0_20:UpdateView()
end

function var0_0.UpdateView(arg0_21)
	local var0_21 = string.split(arg0_21.contextData.map:getConfig("name"), "||")

	setText(arg0_21.sceneParent.chapterName, var0_21[1])

	local var1_21 = arg0_21.contextData.map:getMapTitleNumber()

	arg0_21.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_21, arg0_21.sceneParent.chapterNoTitle, true)

	arg0_21.contextData.displayMode = arg0_21.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_21)

	local var2_21 = arg0_21.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_21._tf:Find("Battle"), var2_21)
	setActive(arg0_21._tf:Find("Story"), not var2_21)

	local var3_21 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_21.battleLayer:Find("Story/BattleTip"), var3_21)
	setActive(arg0_21.storyLayer:Find("Battle/BattleTip"), var3_21)
	arg0_21:UpdateStoryTask()

	if var2_21 then
		arg0_21:UpdateBattle()
		arg0_21.sceneParent:SwitchMapBG(arg0_21.contextData.map)
		arg0_21.sceneParent:PlayBGM()
	else
		arg0_21:UpdateStoryNodeStatus()
		arg0_21:UpdateStory()
		arg0_21:Move2UnlockStory()
		arg0_21:SwitchStoryMapAndBGM()
	end

	arg0_21:TrySubmitTask()
end

function var0_0.UpdateBattle(arg0_22)
	local var0_22 = getProxy(ChapterProxy)
	local var1_22 = arg0_22.displayChapterIDs
	local var2_22 = {}

	for iter0_22, iter1_22 in ipairs(var1_22) do
		local var3_22 = var0_22:getChapterById(iter1_22)

		table.insert(var2_22, var3_22)
	end

	table.clear(arg0_22.chapterTFsById)
	UIItemList.StaticAlign(arg0_22.itemHolder, arg0_22.chapterTpl, #var2_22, function(arg0_23, arg1_23, arg2_23)
		if arg0_23 ~= UIItemList.EventUpdate then
			return
		end

		local var0_23 = var2_22[arg1_23 + 1]

		arg0_22:UpdateMapItem(arg2_23, var0_23)

		arg2_23.name = "Chapter_" .. var0_23.id
		arg0_22.chapterTFsById[var0_23.id] = arg2_23
	end)
end

function var0_0.HideFloat(arg0_24)
	var0_0.super.HideFloat(arg0_24)
	setActive(arg0_24.itemHolder, false)
end

function var0_0.ShowFloat(arg0_25)
	var0_0.super.ShowFloat(arg0_25)
	setActive(arg0_25.itemHolder, true)
end

function var0_0.UpdateMapItem(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26:getConfigTable()

	setAnchoredPosition(arg1_26, {
		x = arg0_26.mapWidth * var0_26.pos_x,
		y = arg0_26.mapHeight * var0_26.pos_y
	})

	local var1_26 = findTF(arg1_26, "main")

	setActive(var1_26, true)

	local var2_26 = findTF(var1_26, "circle/fordark")
	local var3_26 = findTF(var1_26, "info/bk/fordark")

	setActive(var2_26, var0_26.icon_outline == 1)
	setActive(var3_26, var0_26.icon_outline == 1)

	local var4_26 = arg0_26.chapterGroupDict[arg2_26.id]

	assert(var4_26)

	local var5_26 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_26 = 1

	if arg2_26:isUnlock() then
		var6_26 = 2

		if #var4_26.list > 1 then
			var6_26 = table.indexof(var4_26.list, arg2_26.id) + 1
		elseif arg2_26:IsSpChapter() or arg2_26:IsEXChapter() then
			var6_26 = 3
		end
	end

	local var7_26 = findTF(var1_26, "circle/bk")

	for iter0_26, iter1_26 in ipairs(var5_26) do
		setActive(var7_26:Find(iter1_26), iter0_26 == var6_26)
	end

	local var8_26 = findTF(var1_26, "circle/clear_flag")
	local var9_26 = findTF(var1_26, "circle/lock")
	local var10_26 = findTF(var1_26, "circle/progress")
	local var11_26 = findTF(var1_26, "circle/progress_text")
	local var12_26 = findTF(var1_26, "circle/stars")
	local var13_26 = string.split(var0_26.name, "|")

	setText(findTF(var1_26, "info/bk/title_form/title_index"), var0_26.chapter_name .. "  ")
	setText(findTF(var1_26, "info/bk/title_form/title"), var13_26[1])
	setText(findTF(var1_26, "info/bk/title_form/title_en"), var13_26[2] or "")
	setFillAmount(var10_26, arg2_26.progress / 100)
	setText(var11_26, string.format("%d%%", arg2_26.progress))
	setActive(var12_26, arg2_26:existAchieve())

	if arg2_26:existAchieve() then
		for iter2_26, iter3_26 in ipairs(arg2_26.achieves) do
			local var14_26 = ChapterConst.IsAchieved(iter3_26)
			local var15_26 = var12_26:GetChild(iter2_26 - 1):Find("light")

			setActive(var15_26, var14_26)

			for iter4_26, iter5_26 in ipairs(var5_26) do
				if iter5_26 ~= "Lock" then
					setActive(var15_26:Find(iter5_26), iter4_26 == var6_26)
				end
			end
		end
	end

	local var16_26 = findTF(var1_26, "info/bk/BG")

	for iter6_26, iter7_26 in ipairs(var5_26) do
		setActive(var16_26:Find(iter7_26), iter6_26 == var6_26)
	end

	setActive(findTF(var1_26, "HardEffect"), var6_26 == 3)

	local var17_26 = not arg2_26.active and arg2_26:isClear()
	local var18_26 = not arg2_26.active and not arg2_26:isUnlock()

	setActive(var8_26, var17_26)
	setActive(var9_26, var18_26)
	setActive(var11_26, not var17_26 and not var18_26)
	arg0_26:DeleteTween("fighting" .. arg2_26.id)

	local var19_26 = findTF(var1_26, "circle/fighting")

	setText(findTF(var19_26, "Text"), i18n("tag_level_fighting"))

	local var20_26 = findTF(var1_26, "circle/oni")

	setText(findTF(var20_26, "Text"), i18n("tag_level_oni"))

	local var21_26 = findTF(var1_26, "circle/narrative")

	setText(findTF(var21_26, "Text"), i18n("tag_level_narrative"))
	setActive(var19_26, false)
	setActive(var20_26, false)
	setActive(var21_26, false)

	local var22_26
	local var23_26

	if arg2_26:getConfig("chapter_tag") == 1 then
		var22_26 = var21_26
	end

	if arg2_26.active then
		var22_26 = arg2_26:existOni() and var20_26 or var19_26
	end

	if var22_26 then
		setActive(var22_26, true)

		local var24_26 = GetOrAddComponent(var22_26, "CanvasGroup")

		var24_26.alpha = 1

		arg0_26:RecordTween("fighting" .. arg2_26.id, LeanTween.alphaCanvas(var24_26, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_26 = findTF(var1_26, "triesLimit")
	local var26_26 = arg2_26:isTriesLimit()

	setActive(var25_26, var26_26)

	if var26_26 then
		local var27_26 = arg2_26:getConfig("count")
		local var28_26 = var27_26 - arg2_26:getTodayDefeatCount() .. "/" .. var27_26

		setText(var25_26:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_26:Find("Text"), setColorStr(var28_26, var27_26 <= arg2_26:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_26 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_26:Find("TipRect"), var29_26)
	end

	local var30_26 = arg2_26:GetDailyBonusQuota()
	local var31_26 = findTF(var1_26, "mark")

	setActive(var31_26:Find("bonus"), var30_26)
	setActive(var31_26, var30_26)

	if var30_26 then
		local var32_26 = var31_26:GetComponent(typeof(CanvasGroup))
		local var33_26 = arg0_26.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_26.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var33_26, var31_26:Find("bonus"))
		LeanTween.cancel(go(var31_26), true)

		local var34_26 = var31_26.anchoredPosition.y

		var32_26.alpha = 0

		LeanTween.value(go(var31_26), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_27)
			var32_26.alpha = arg0_27

			local var0_27 = var31_26.anchoredPosition

			var0_27.y = var34_26 * arg0_27
			var31_26.anchoredPosition = var0_27
		end)):setOnComplete(System.Action(function()
			var32_26.alpha = 1

			local var0_28 = var31_26.anchoredPosition

			var0_28.y = var34_26
			var31_26.anchoredPosition = var0_28
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var35_26 = arg2_26.id

	onButton(arg0_26, var1_26, function()
		arg0_26:TryOpenChapterInfo(var35_26, nil, var4_26.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
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

function var0_0.RecyclePools(arg0_32)
	for iter0_32 = #arg0_32.activeItems, 1, -1 do
		local var0_32 = arg0_32.activeItems[iter0_32]

		arg0_32.pools[var0_32.template]:Enqueue(var0_32.active)
	end

	table.clean(arg0_32.activeItems)

	arg0_32.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_33)
	local var0_33 = 0
	local var1_33 = 0
	local var2_33 = pg.NewStoryMgr.GetInstance()
	local var3_33 = {}

	table.Foreach(arg0_33.spStoryIDs, function(arg0_34, arg1_34)
		var3_33[arg1_34] = {}
	end)

	local var4_33 = arg0_33.spStoryNodes

	for iter0_33 = 1, #var4_33 do
		local var5_33 = var4_33[iter0_33]
		local var6_33 = var5_33:GetConfigID()
		local var7_33 = var5_33:GetPreEvent()
		local var8_33 = false
		local var9_33 = var7_33 == 0 and true or var3_33[var7_33].status == var4_0
		local var10_33 = var2_0
		local var11_33 = var5_33:GetStoryName()
		local var12_33 = false

		if var11_33 and var11_33 ~= "" then
			var12_33 = var2_33:IsPlayed(var11_33)
			var0_33 = var0_33 + (var12_33 and 1 or 0)
			var1_33 = var1_33 + 1
		end

		if not var12_33 and var9_33 then
			_.each(var5_33:GetUnlockConditions(), function(arg0_35)
				if arg0_35[1] == ActivitySpStoryNode.CONDITION.TIME then
					local var0_35 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_35[2])
					local var1_35 = pg.TimeMgr.GetInstance():GetServerTime()

					var9_33 = var9_33 and var0_35 <= var1_35
				elseif arg0_35[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var2_35 = arg0_35[2]

					var9_33 = var9_33 and _.all(var2_35, function(arg0_36)
						return getProxy(ChapterProxy):getChapterById(arg0_36, true):isClear()
					end)
				elseif arg0_35[1] == ActivitySpStoryNode.CONDITION.PT then
					local var3_35 = arg0_35[2][1]
					local var4_35 = arg0_35[2][2]
					local var5_35 = arg0_35[2][3]
					local var6_35 = 0

					if var3_35 == DROP_TYPE_RESOURCE then
						var6_35 = getProxy(PlayerProxy):getRawData():getResource(arg0_35[2])
					elseif var3_35 == DROP_TYPE_ITEM then
						var6_35 = getProxy(BagProxy):getItemCountById(var4_35)
					end

					var9_33 = var9_33 and var5_35 <= var6_35
				end
			end)
		end

		if var12_33 then
			var10_33 = var4_0
		elseif var9_33 then
			var10_33 = var3_0
		end

		var3_33[var6_33].status = var10_33
	end

	arg0_33.storyNodeStatus = var3_33
	arg0_33.storyReadCount, arg0_33.storyReadMax = var0_33, var1_33
end

function var0_0.UpdateStory(arg0_37)
	arg0_37:RecyclePools()

	local var0_37 = {
		"162443",
		"ffffff",
		"ffcb5a"
	}
	local var1_37 = arg0_37.data:getConfig("story_inactive_color")

	if var1_37 and #var1_37 > 0 then
		var0_37[1] = var1_37
	end

	local var2_37 = arg0_37.storyReadCount
	local var3_37 = arg0_37.storyReadMax
	local var4_37 = 0
	local var5_37 = 150
	local var6_37 = 150
	local var7_37 = {
		{
			layer = 0,
			node = arg0_37.storyTree.root,
			nodePos = Vector2.New(var5_37, 0)
		}
	}
	local var8_37 = arg0_37.storyNodeTpl.rect.width
	local var9_37 = arg0_37.oneLineTpl.rect.width
	local var10_37 = arg0_37.branchHeadTpl.rect.width
	local var11_37 = arg0_37.branchUpTpl.rect.width
	local var12_37 = arg0_37.branchUpTpl.rect.height
	local var13_37 = arg0_37.unionTailTpl.rect.width
	local var14_37 = 75
	local var15_37 = 82
	local var16_37 = 32

	while true do
		if not next(var7_37) then
			break
		end

		local var17_37 = table.remove(var7_37, 1)
		local var18_37 = var17_37.node
		local var19_37 = var18_37:GetConfigID()
		local var20_37 = arg0_37.storyNodeStatus[var19_37].status
		local var21_37 = arg0_37:DequeItem(arg0_37.storyNodeTpl)

		setAnchoredPosition(var21_37, var17_37.nodePos)

		arg0_37.storyNodeTFsById[var19_37] = {
			nodeTF = tf(var21_37)
		}

		local var22_37 = arg0_37.storyTree.childDict[var19_37] or {}

		table.Ipairs(var22_37, function(arg0_38, arg1_38)
			local var0_38
			local var1_38
			local var2_38 = var17_37.layer

			if #arg1_38:GetPreNodes() > 1 then
				local var3_38 = arg1_38:GetPreNodes()

				if var19_37 == var3_38[1] then
					local var4_38 = var8_37 + var16_37
					local var5_38 = arg0_37:DequeItem(arg0_37.unionUpTpl)

					setAnchoredPosition(var5_38, var17_37.nodePos + Vector2.New(var4_38, 0))

					var2_38 = var2_38 - 1

					local var6_38 = arg0_37.storyNodeStatus[arg1_38:GetConfigID()].status

					eachChild(var5_38, function(arg0_39)
						setImageColor(arg0_39, Color.NewHex(var0_37[var6_38]))
					end)

					return
				elseif #var3_38 == 2 or var19_37 == var3_38[3] then
					local var7_38 = var8_37 + var16_37
					local var8_38 = arg0_37:DequeItem(arg0_37.unionDownTpl)

					setAnchoredPosition(var8_38, var17_37.nodePos + Vector2.New(var7_38, 0))

					local var9_38 = var7_38 + var11_37
					local var10_38 = arg0_37:DequeItem(arg0_37.unionTailTpl)

					setAnchoredPosition(var10_38, var17_37.nodePos + Vector2.New(var9_38, var12_37))

					var1_38 = var17_37.nodePos + Vector2.New(var9_38 + var13_37 + var15_37, var12_37)
					var2_38 = var2_38 + 1

					local var11_38 = arg0_37.storyNodeStatus[arg1_38:GetConfigID()].status

					eachChild(var8_38, function(arg0_40)
						setImageColor(arg0_40, Color.NewHex(var0_37[var11_38]))
					end)
					eachChild(var10_38, function(arg0_41)
						setImageColor(arg0_41, Color.NewHex(var0_37[var11_38]))
					end)
				else
					local var12_38 = var8_37 + var16_37
					local var13_38 = arg0_37:DequeItem(arg0_37.unionCenterTpl)

					setAnchoredPosition(var13_38, var17_37.nodePos + Vector2.New(var12_38, 0))

					local var14_38 = arg0_37.storyNodeStatus[arg1_38:GetConfigID()].status

					eachChild(var13_38, function(arg0_42)
						setImageColor(arg0_42, Color.NewHex(var0_37[var14_38]))
					end)

					return
				end
			elseif #var22_37 == 1 then
				local var15_38 = arg0_37:DequeItem(arg0_37.oneLineTpl)

				setAnchoredPosition(var15_38, var17_37.nodePos + Vector2.New(var8_37 + var16_37, 0))

				var1_38 = tf(var15_38).anchoredPosition + Vector2.New(var9_37 + var14_37, 0)

				local var16_38 = arg0_37.storyNodeStatus[arg1_38:GetConfigID()].status

				eachChild(var15_38, function(arg0_43)
					setImageColor(arg0_43, Color.NewHex(var0_37[var16_38]))
				end)

				arg0_37.storyNodeTFsById[var19_37].lineTF = tf(var15_38)
			elseif arg0_38 == 1 then
				local var17_38 = var8_37 + var16_37
				local var18_38 = arg0_37:DequeItem(arg0_37.branchHeadTpl)

				setAnchoredPosition(var18_38, var17_37.nodePos + Vector2.New(var17_38, 0))

				local var19_38 = var17_38 + var10_37
				local var20_38 = arg0_37:DequeItem(arg0_37.branchUpTpl)

				setAnchoredPosition(var20_38, var17_37.nodePos + Vector2.New(var19_38, 0))

				var1_38 = var17_37.nodePos + Vector2.New(var19_38 + var11_37 + var14_37, var12_37)
				var2_38 = var2_38 + 1

				local var21_38 = arg0_37.storyNodeStatus[arg1_38:GetConfigID()].status

				eachChild(var20_38, function(arg0_44)
					setImageColor(arg0_44, Color.NewHex(var0_37[var21_38]))
				end)
				eachChild(var18_38, function(arg0_45)
					setImageColor(arg0_45, Color.NewHex(var0_37[var21_38]))
				end)
			elseif arg0_38 == 3 or arg0_38 == 2 and #var22_37 == 2 then
				local var22_38 = var8_37 + var16_37 + var10_37
				local var23_38 = arg0_37:DequeItem(arg0_37.branchDownTpl)

				setAnchoredPosition(var23_38, var17_37.nodePos + Vector2.New(var22_38, 0))

				var1_38 = var17_37.nodePos + Vector2.New(var22_38 + var11_37 + var14_37, -var12_37)
				var2_38 = var2_38 - 1

				local var24_38 = arg0_37.storyNodeStatus[arg1_38:GetConfigID()].status

				eachChild(var23_38, function(arg0_46)
					setImageColor(arg0_46, Color.NewHex(var0_37[var24_38]))
				end)
			else
				local var25_38 = var8_37 + var16_37 + var10_37
				local var26_38 = arg0_37:DequeItem(arg0_37.branchCenterTpl)

				setAnchoredPosition(var26_38, var17_37.nodePos + Vector2.New(var25_38, 0))

				var1_38 = var17_37.nodePos + Vector2.New(var25_38 + var11_37 + var14_37, 0)

				local var27_38 = arg0_37.storyNodeStatus[arg1_38:GetConfigID()].status

				eachChild(var26_38, function(arg0_47)
					setImageColor(arg0_47, Color.NewHex(var0_37[var27_38]))
				end)
			end

			table.insert(var7_37, {
				node = arg1_38,
				nodePos = var1_38,
				layer = var2_38
			})
		end)

		if #var22_37 == 0 then
			var4_37 = var17_37.nodePos.x + var8_37 + var6_37
		end

		local var23_37 = tf(var21_37)
		local var24_37 = var23_37:Find("info/bk/title_form/title")

		if var20_37 == var2_0 then
			setScrollText(var24_37, var18_37:GetUnlockDesc())
			setTextAlpha(var24_37, 0.5)
		else
			setScrollText(var24_37, var18_37:GetDisplayName())
			setTextAlpha(var24_37, 1)
		end

		local var25_37 = var18_37:GetType()

		setActive(var23_37:Find("circle/lock"), var20_37 == var2_0)

		if var20_37 == var2_0 then
			setActive(var23_37:Find("circle/Story"), false)
			setActive(var23_37:Find("circle/Battle"), false)
			setText(var23_37:Find(""))
		elseif var25_37 == ActivitySpStoryNode.NODE_TYPE.STORY then
			setActive(var23_37:Find("circle/Story"), var25_37 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var23_37:Find("circle/Battle"), var25_37 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var23_37:Find("circle/Story/Done"), var20_37 == var4_0)
		elseif var25_37 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
			setActive(var23_37:Find("circle/Story"), var25_37 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var23_37:Find("circle/Battle"), var25_37 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var23_37:Find("circle/Battle/Done"), var20_37 == var4_0)
		end

		local var26_37 = var20_37 == var4_0

		setActive(var23_37:Find("circle/progress"), var26_37)
		onButton(arg0_37, var23_37, function()
			if var20_37 == var2_0 then
				return
			end

			local var0_48 = var18_37:GetStoryName()

			arg0_37:PlayStory(var0_48, function()
				arg0_37:UpdateView()

				arg0_37.needFocusStory = true

				arg0_37:Move2UnlockStory()
			end, true)
		end)
	end

	setSizeDelta(arg0_37.storyContainer, {
		x = var4_37
	})
	setText(arg0_37.progressText, var2_37 .. "/" .. var3_37)
	setActive(arg0_37.storyAward, tobool(arg0_37.storyTask))

	if arg0_37.storyTask then
		local var27_37 = arg0_37.storyTask:getConfig("award_display")
		local var28_37 = Drop.New({
			type = var27_37[1][1],
			id = var27_37[1][2],
			count = var27_37[1][3]
		})

		updateDrop(arg0_37.storyAward:GetChild(0), var28_37)

		local var29_37 = arg0_37.storyTask:getTaskStatus()

		setActive(arg0_37.storyAward:Find("get"), var29_37 == 1)
		setActive(arg0_37.storyAward:Find("got"), var29_37 == 2)
		onButton(arg0_37, arg0_37.storyAward, function()
			arg0_37:emit(BaseUI.ON_DROP, var28_37)
		end)
	end
end

function var0_0.DequeItem(arg0_51, arg1_51)
	local var0_51 = arg0_51.pools[arg1_51]:Dequeue()

	table.insert(arg0_51.activeItems, {
		template = arg1_51,
		active = var0_51
	})
	setActive(var0_51, true)
	setParent(var0_51, arg0_51.storyContainer)

	return var0_51
end

function var0_0.Move2UnlockStory(arg0_52)
	if not arg0_52.needFocusStory then
		return
	end

	arg0_52.needFocusStory = nil

	local var0_52 = arg0_52.spStoryNodes
	local var1_52

	for iter0_52 = #var0_52, 1, -1 do
		local var2_52 = var0_52[iter0_52]:GetConfigID()

		if arg0_52.storyNodeStatus[var2_52].status > var2_0 then
			var1_52 = var2_52

			break
		end
	end

	local var3_52 = arg0_52.storyNodeTFsById[var1_52].nodeTF
	local var4_52 = arg0_52.storyNodeTpl.rect.width
	local var5_52 = var3_52.anchoredPosition.x + var4_52 * 0.5 - arg0_52.storyContainer.parent.rect.width * 0.5
	local var6_52 = math.clamp(var5_52, 0, math.max(0, arg0_52.storyContainer.rect.width - arg0_52.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_52.storyContainer, {
		x = -var6_52
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_53)
	local var0_53 = arg0_53.data:getConfig("default_background")
	local var1_53 = arg0_53.data:getConfig("default_bgm")
	local var2_53
	local var3_53 = arg0_53.spStoryNodes

	for iter0_53 = 1, #var3_53 do
		local var4_53 = var3_53[iter0_53]
		local var5_53 = var4_53:GetConfigID()

		if arg0_53.storyNodeStatus[var5_53].status == var4_0 then
			var0_53, var1_53 = var4_53:GetCleanBG(), var4_53:GetCleanBGM()
			var2_53 = var4_53:GetCleanAnimator()
		else
			break
		end
	end

	arg0_53.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_53,
			Animator = var2_53
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_53.__cname, var1_53)
end

function var0_0.TrySubmitTask(arg0_54)
	local var0_54 = true

	for iter0_54, iter1_54 in ipairs(arg0_54.spStoryNodes) do
		local var1_54 = iter1_54:GetStoryName()

		if var1_54 and var1_54 ~= "" then
			var0_54 = var0_54 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_54)
		end

		if not var0_54 then
			break
		end
	end

	if var0_54 and arg0_54.storyTask and arg0_54.storyTask:getTaskStatus() == 1 then
		arg0_54:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_54.storyTask.id)

		return
	end
end

function var0_0.PlayStory(arg0_55, arg1_55, arg2_55, arg3_55)
	if not arg1_55 then
		return existCall(arg2_55)
	end

	local var0_55 = pg.NewStoryMgr.GetInstance()
	local var1_55 = var0_55:IsPlayed(arg1_55)

	seriesAsync({
		function(arg0_56)
			if var1_55 and not arg3_55 then
				return arg0_56()
			end

			local var0_56 = tonumber(arg1_55)

			if var0_56 and var0_56 > 0 then
				arg0_55:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_56)
			else
				var0_55:Play(arg1_55, arg0_56, arg3_55)
			end
		end,
		function(arg0_57, ...)
			existCall(arg2_55, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_58)
	local var0_58 = arg0_58.activity:getConfig("config_client").task_id
	local var1_58 = getProxy(TaskProxy):getTaskVO(var0_58)

	if not var1_58 then
		errorMsg("Missing Activity Task ID : " .. var0_58)
	end

	arg0_58.storyTask = var1_58 or Task.New({
		id = var0_58
	})
end

function var0_0.OnSubmitTaskDone(arg0_59)
	arg0_59:UpdateView()
end

function var0_0.OnDestroy(arg0_60)
	arg0_60:RecyclePools()

	for iter0_60, iter1_60 in pairs(arg0_60.pools) do
		iter1_60:Clear()
	end
end

return var0_0
