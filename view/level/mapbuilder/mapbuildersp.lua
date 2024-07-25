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

	setActive(arg0_4.storyNodeTpl, false)
	setActive(arg0_4.oneLineTpl, false)
	setActive(arg0_4.branchHeadTpl, false)
	setActive(arg0_4.branchCenterTpl, false)
	setActive(arg0_4.branchUpTpl, false)
	setActive(arg0_4.branchDownTpl, false)

	arg0_4.pools = {
		[arg0_4.storyNodeTpl] = var1_0.New(go(arg0_4.storyNodeTpl), 16),
		[arg0_4.oneLineTpl] = var1_0.New(go(arg0_4.oneLineTpl), 16),
		[arg0_4.branchHeadTpl] = var1_0.New(go(arg0_4.branchHeadTpl), 16),
		[arg0_4.branchCenterTpl] = var1_0.New(go(arg0_4.branchCenterTpl), 16),
		[arg0_4.branchUpTpl] = var1_0.New(go(arg0_4.branchUpTpl), 16),
		[arg0_4.branchDownTpl] = var1_0.New(go(arg0_4.branchDownTpl), 16)
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

	setActive(arg0_9.sceneParent.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and var3_9 and not var2_9 and var1_9)
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
	local var1_11 = arg0_11.activity:getConfig("config_client").chapterGroups

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
	arg0_16.spStoryIDs = arg0_16.activity:getConfig("config_client").story_id
	arg0_16.spStoryNodes = _.map(arg0_16.spStoryIDs, function(arg0_17)
		return ActivitySpStoryNode.New({
			configId = arg0_17
		})
	end)

	local var0_16 = {}
	local var1_16

	_.each(arg0_16.spStoryNodes, function(arg0_18)
		local var0_18 = arg0_18:GetPreEvent()

		if var0_18 == 0 then
			var1_16 = arg0_18

			return
		end

		var0_16[var0_18] = var0_16[var0_18] or {}

		table.insert(var0_16[var0_18], arg0_18)
	end)

	arg0_16.storyTree = {
		root = var1_16,
		childDict = var0_16
	}
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

	setText(arg0_20.sceneParent.chapterName, var0_20[1])

	local var1_20 = arg0_20.contextData.map:getMapTitleNumber()

	arg0_20.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_20, arg0_20.sceneParent.chapterNoTitle, true)

	arg0_20.contextData.displayMode = arg0_20.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_20)

	local var2_20 = arg0_20.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_20._tf:Find("Battle"), var2_20)
	setActive(arg0_20._tf:Find("Story"), not var2_20)

	local var3_20 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_20.battleLayer:Find("Story/BattleTip"), var3_20)
	setActive(arg0_20.storyLayer:Find("Battle/BattleTip"), var3_20)
	arg0_20:UpdateStoryTask()

	if var2_20 then
		arg0_20:UpdateBattle()
		arg0_20.sceneParent:SwitchMapBG(arg0_20.contextData.map)
		arg0_20.sceneParent:PlayBGM()
	else
		arg0_20:UpdateStoryNodeStatus()
		arg0_20:UpdateStory()
		arg0_20:Move2UnlockStory()
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

	setAnchoredPosition(arg1_25, {
		x = arg0_25.mapWidth * var0_25.pos_x,
		y = arg0_25.mapHeight * var0_25.pos_y
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

		local var29_25 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_25:Find("TipRect"), var29_25)
	end

	local var30_25 = arg2_25:GetDailyBonusQuota()
	local var31_25 = findTF(var1_25, "mark")

	setActive(var31_25:Find("bonus"), var30_25)
	setActive(var31_25, var30_25)

	if var30_25 then
		local var32_25 = var31_25:GetComponent(typeof(CanvasGroup))
		local var33_25 = arg0_25.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_25.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var33_25, var31_25:Find("bonus"))
		LeanTween.cancel(go(var31_25), true)

		local var34_25 = var31_25.anchoredPosition.y

		var32_25.alpha = 0

		LeanTween.value(go(var31_25), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_26)
			var32_25.alpha = arg0_26

			local var0_26 = var31_25.anchoredPosition

			var0_26.y = var34_25 * arg0_26
			var31_25.anchoredPosition = var0_26
		end)):setOnComplete(System.Action(function()
			var32_25.alpha = 1

			local var0_27 = var31_25.anchoredPosition

			var0_27.y = var34_25
			var31_25.anchoredPosition = var0_27
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var35_25 = arg2_25.id

	onButton(arg0_25, var1_25, function()
		arg0_25:TryOpenChapterInfo(var35_25, nil, var4_25.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.SwitchChapter(arg0_29, arg1_29)
	local var0_29 = arg0_29.chapterGroupDict[arg1_29]

	if not var0_29 then
		return
	end

	local var1_29 = var0_29.list[var0_29.index]

	if var1_29 == arg1_29 then
		return
	end

	local var2_29 = table.indexof(var0_29.list, arg1_29)

	var0_29.index = var2_29

	local var3_29 = var0_29.list[1]
	local var4_29 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("spchapter_selected_" .. var4_29 .. "_" .. var3_29, var2_29)

	local var5_29 = arg0_29.chapterTFsById[var1_29]

	arg0_29.chapterTFsById[var1_29] = nil
	arg0_29.chapterTFsById[arg1_29] = var5_29

	arg0_29:UpdateChapterTF(arg1_29)
end

function var0_0.UpdateChapterTF(arg0_30, arg1_30)
	if not arg0_30.chapterGroupDict[arg1_30] then
		return
	end

	local var0_30 = arg0_30.chapterTFsById[arg1_30]

	if var0_30 then
		local var1_30 = getProxy(ChapterProxy):getChapterById(arg1_30)

		arg0_30:UpdateMapItem(var0_30, var1_30)
	end
end

function var0_0.RecyclePools(arg0_31)
	for iter0_31 = #arg0_31.activeItems, 1, -1 do
		local var0_31 = arg0_31.activeItems[iter0_31]

		arg0_31.pools[var0_31.template]:Enqueue(var0_31.active)
	end

	table.clean(arg0_31.activeItems)

	arg0_31.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_32)
	local var0_32 = 0
	local var1_32 = 0
	local var2_32 = pg.NewStoryMgr.GetInstance()
	local var3_32 = {}

	table.Foreach(arg0_32.spStoryIDs, function(arg0_33)
		var3_32[arg0_33] = {}
	end)

	local var4_32 = {
		arg0_32.storyTree.root
	}

	while true do
		if not next(var4_32) then
			break
		end

		local var5_32 = table.remove(var4_32, 1)
		local var6_32 = var5_32:GetConfigID()
		local var7_32 = var5_32:GetPreEvent()
		local var8_32 = false
		local var9_32 = var7_32 == 0 and true or var3_32[var7_32].status == var4_0
		local var10_32 = var2_0
		local var11_32 = var5_32:GetStoryName()
		local var12_32 = false

		if var11_32 and var11_32 ~= "" then
			var12_32 = var2_32:IsPlayed(var11_32)
			var0_32 = var0_32 + (var12_32 and 1 or 0)
			var1_32 = var1_32 + 1
		end

		if not var12_32 and var9_32 then
			local var13_32 = var5_32:GetUnlockConditions()

			if var13_32 then
				if var13_32[1] == ActivitySpStoryNode.CONDITION.TIME then
					var9_32 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var13_32[2]) <= pg.TimeMgr.GetInstance():GetServerTime()
				elseif var13_32[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var14_32 = var13_32[2]

					var9_32 = _.all(var14_32, function(arg0_34)
						return getProxy(ChapterProxy):getChapterById(arg0_34, true):isClear()
					end)
				elseif var13_32[1] == ActivitySpStoryNode.CONDITION.PT then
					local var15_32 = var13_32[2][1]
					local var16_32 = var13_32[2][2]
					local var17_32 = var13_32[2][3]
					local var18_32 = 0

					if var15_32 == DROP_TYPE_RESOURCE then
						var18_32 = getProxy(PlayerProxy):getRawData():getResource(var13_32[2])
					elseif var15_32 == DROP_TYPE_ITEM then
						var18_32 = getProxy(BagProxy):getItemCountById(var16_32)
					end

					var9_32 = var17_32 <= var18_32
				end
			end
		end

		if var12_32 then
			var10_32 = var4_0
		elseif var9_32 then
			var10_32 = var3_0
		end

		var3_32[var6_32].status = var10_32

		local var19_32 = arg0_32.storyTree.childDict[var6_32] or {}

		_.each(var19_32, function(arg0_35)
			table.insert(var4_32, arg0_35)
		end)
	end

	arg0_32.storyNodeStatus = var3_32
	arg0_32.storyReadCount, arg0_32.storyReadMax = var0_32, var1_32
end

function var0_0.UpdateStory(arg0_36)
	arg0_36:RecyclePools()

	local var0_36 = {
		"162443",
		"ffffff",
		"ffcb5a"
	}
	local var1_36 = arg0_36.storyReadCount
	local var2_36 = arg0_36.storyReadMax
	local var3_36 = 0
	local var4_36 = 150
	local var5_36 = 150
	local var6_36 = {
		{
			node = arg0_36.storyTree.root,
			nodePos = Vector2.New(var4_36, 0)
		}
	}
	local var7_36 = arg0_36.storyNodeTpl.rect.width
	local var8_36 = arg0_36.oneLineTpl.rect.width
	local var9_36 = 75
	local var10_36 = 32

	while true do
		if not next(var6_36) then
			break
		end

		local var11_36 = table.remove(var6_36, 1)
		local var12_36 = var11_36.node
		local var13_36 = var12_36:GetConfigID()
		local var14_36 = arg0_36.storyNodeStatus[var13_36].status
		local var15_36 = arg0_36.pools[arg0_36.storyNodeTpl]:Dequeue()

		table.insert(arg0_36.activeItems, {
			template = arg0_36.storyNodeTpl,
			active = var15_36
		})
		setActive(var15_36, true)
		setParent(var15_36, arg0_36.storyContainer)
		setAnchoredPosition(var15_36, var11_36.nodePos)

		arg0_36.storyNodeTFsById[var13_36] = {
			nodeTF = tf(var15_36)
		}

		local var16_36 = arg0_36.storyTree.childDict[var13_36] or {}

		table.Ipairs(var16_36, function(arg0_37, arg1_37)
			local var0_37
			local var1_37

			if #var16_36 == 1 then
				local var2_37 = arg0_36.pools[arg0_36.oneLineTpl]:Dequeue()

				table.insert(arg0_36.activeItems, {
					template = arg0_36.oneLineTpl,
					active = var2_37
				})
				setActive(var2_37, true)
				setParent(var2_37, arg0_36.storyContainer)
				setAnchoredPosition(var2_37, var11_36.nodePos + Vector2.New(var7_36 + var10_36, 0))

				var1_37 = tf(var2_37).anchoredPosition + Vector2.New(var8_36 + var9_36, 0)

				local var3_37 = arg0_36.storyNodeStatus[arg1_37:GetConfigID()].status

				eachChild(var2_37, function(arg0_38)
					setImageColor(arg0_38, Color.NewHex(var0_36[var3_37]))
				end)

				arg0_36.storyNodeTFsById[var13_36].lineTF = tf(var2_37)
			else
				assert(false)
			end

			table.insert(var6_36, {
				node = arg1_37,
				nodePos = var1_37
			})
		end)

		if #var16_36 == 0 then
			var3_36 = var11_36.nodePos.x + var7_36 + var5_36
		end

		local var17_36 = tf(var15_36)
		local var18_36 = var17_36:Find("info/bk/title_form/title")

		if var14_36 == var2_0 then
			setScrollText(var18_36, var12_36:GetUnlockDesc())
			setTextAlpha(var18_36, 0.5)
		else
			setScrollText(var18_36, var12_36:GetDisplayName())
			setTextAlpha(var18_36, 1)
		end

		local var19_36 = var12_36:GetType()

		setActive(var17_36:Find("circle/lock"), var14_36 == var2_0)

		if var14_36 == var2_0 then
			setActive(var17_36:Find("circle/Story"), false)
			setActive(var17_36:Find("circle/Battle"), false)
			setText(var17_36:Find(""))
		elseif var19_36 == ActivitySpStoryNode.NODE_TYPE.STORY then
			setActive(var17_36:Find("circle/Story"), var19_36 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var17_36:Find("circle/Battle"), var19_36 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var17_36:Find("circle/Story/Done"), var14_36 == var4_0)
		elseif var19_36 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
			setActive(var17_36:Find("circle/Story"), var19_36 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var17_36:Find("circle/Battle"), var19_36 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var17_36:Find("circle/Battle/Done"), var14_36 == var4_0)
		end

		local var20_36 = var14_36 == var4_0

		setActive(var17_36:Find("circle/progress"), var20_36)
		onButton(arg0_36, var17_36, function()
			if var14_36 == var2_0 then
				return
			end

			local var0_39 = var12_36:GetStoryName()

			arg0_36:PlayStory(var0_39, function()
				arg0_36:UpdateView()

				arg0_36.needFocusStory = true

				arg0_36:Move2UnlockStory()
			end, true)
		end)
	end

	setSizeDelta(arg0_36.storyContainer, {
		x = var3_36
	})
	setText(arg0_36.progressText, var1_36 .. "/" .. var2_36)
	setActive(arg0_36.storyAward, tobool(arg0_36.storyTask))

	if arg0_36.storyTask then
		local var21_36 = arg0_36.storyTask:getConfig("award_display")
		local var22_36 = Drop.New({
			type = var21_36[1][1],
			id = var21_36[1][2],
			count = var21_36[1][3]
		})

		updateDrop(arg0_36.storyAward:GetChild(0), var22_36)

		local var23_36 = arg0_36.storyTask:getTaskStatus()

		setActive(arg0_36.storyAward:Find("get"), var23_36 == 1)
		setActive(arg0_36.storyAward:Find("got"), var23_36 == 2)
		onButton(arg0_36, arg0_36.storyAward, function()
			arg0_36:emit(BaseUI.ON_DROP, var22_36)
		end)
	end
end

function var0_0.Move2UnlockStory(arg0_42)
	if not arg0_42.needFocusStory then
		return
	end

	arg0_42.needFocusStory = nil

	local var0_42 = {
		arg0_42.storyTree.root
	}
	local var1_42

	while true do
		if not next(var0_42) then
			break
		end

		local var2_42 = table.remove(var0_42, 1):GetConfigID()

		if arg0_42.storyNodeStatus[var2_42].status > var2_0 then
			var1_42 = var2_42

			local var3_42 = arg0_42.storyTree.childDict[var2_42] or {}

			_.each(var3_42, function(arg0_43)
				table.insert(var0_42, arg0_43)
			end)
		end
	end

	local var4_42 = arg0_42.storyNodeTFsById[var1_42].nodeTF
	local var5_42 = arg0_42.storyNodeTpl.rect.width
	local var6_42 = var4_42.anchoredPosition.x + var5_42 * 0.5 - arg0_42.storyContainer.parent.rect.width * 0.5
	local var7_42 = math.clamp(var6_42, 0, math.max(0, arg0_42.storyContainer.rect.width - arg0_42.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_42.storyContainer, {
		x = -var7_42
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_44)
	local var0_44 = {
		arg0_44.storyTree.root
	}
	local var1_44 = arg0_44.activity:getConfig("config_client").default_background
	local var2_44 = arg0_44.activity:getConfig("config_client").default_bgm

	while true do
		if not next(var0_44) then
			break
		end

		local var3_44 = table.remove(var0_44, 1)
		local var4_44 = var3_44:GetConfigID()

		if arg0_44.storyNodeStatus[var4_44].status == var4_0 then
			var1_44, var2_44 = var3_44:GetCleanBG(), var3_44:GetCleanBGM()

			local var5_44 = arg0_44.storyTree.childDict[var4_44] or {}

			_.each(var5_44, function(arg0_45)
				table.insert(var0_44, arg0_45)
			end)
		end
	end

	arg0_44.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var1_44
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_44.__cname, var2_44)
end

function var0_0.TrySubmitTask(arg0_46)
	local var0_46 = true

	for iter0_46, iter1_46 in ipairs(arg0_46.spStoryNodes) do
		local var1_46 = iter1_46:GetStoryName()

		if var1_46 and var1_46 ~= "" then
			var0_46 = var0_46 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_46)
		end

		if not var0_46 then
			break
		end
	end

	if var0_46 and arg0_46.storyTask and arg0_46.storyTask:getTaskStatus() == 1 then
		arg0_46:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_46.storyTask.id)

		return
	end
end

function var0_0.PlayStory(arg0_47, arg1_47, arg2_47, arg3_47)
	if not arg1_47 then
		return existCall(arg2_47)
	end

	local var0_47 = pg.NewStoryMgr.GetInstance()
	local var1_47 = var0_47:IsPlayed(arg1_47)

	seriesAsync({
		function(arg0_48)
			if var1_47 and not arg3_47 then
				return arg0_48()
			end

			local var0_48 = tonumber(arg1_47)

			if var0_48 and var0_48 > 0 then
				arg0_47:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_48)
			else
				var0_47:Play(arg1_47, arg0_48, arg3_47)
			end
		end,
		function(arg0_49, ...)
			existCall(arg2_47, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_50)
	local var0_50 = arg0_50.activity:getConfig("config_client").task_id

	arg0_50.storyTask = getProxy(TaskProxy):getTaskVO(var0_50) or Task.New({
		submit_time = 1,
		id = var0_50
	})
end

function var0_0.OnSubmitTaskDone(arg0_51)
	arg0_51:UpdateView()
end

function var0_0.OnDestroy(arg0_52)
	arg0_52:RecyclePools()

	for iter0_52, iter1_52 in pairs(arg0_52.pools) do
		iter1_52:Clear()
	end
end

return var0_0
