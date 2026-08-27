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
	onButton(arg0_4, arg0_4.battleLayer:Find("Mask/Story/Switch"), function()
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

	if var2_9 then
		arg0_9.sceneParent:updateRemasterInfo()
	end

	local var3_9 = arg0_9.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_9.sceneParent.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and var3_9 and not var2_9 and var1_9 and arg0_9.sceneParent:IsActShopActive())

	local var4_9 = arg0_9.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_9.contextData.map:getConfig("on_activity")) or nil
	local var5_9 = var4_9 and not var4_9:isEnd() and var4_9:GetConfigClientSetting("PTID")

	arg0_9.sceneParent:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_10)
		return arg0_10:getConfig("config_id") == var5_9
	end))
	setActive(arg0_9.sceneParent.rightChapter:Find("event_btns/tickets"), var2_9)
	arg0_9.sceneParent:updateRemasterTicket()
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

function var0_0.BuildStoryTree(arg0_19)
	arg0_19.spStoryIDs = arg0_19.data:getConfig("story_id")
	arg0_19.spStoryNodeDict = {}
	arg0_19.spStoryNodes = {}
	arg0_19.spStoryUnreleasedNode = nil

	local var0_19 = {}

	_.each(arg0_19.spStoryIDs, function(arg0_20)
		local var0_20 = ActivitySpStoryNode.New({
			configId = arg0_20
		})

		if var0_20:GetType() ~= ActivitySpStoryNode.NODE_TYPE.UNRELEASED then
			arg0_19.spStoryNodeDict[arg0_20] = var0_20

			local var1_20 = arg0_19.spStoryNodeDict[arg0_20]
			local var2_20 = var0_19[var1_20:GetPreEvent()] or {}

			table.insert(var2_20, arg0_20)

			var0_19[var1_20:GetPreEvent()] = var2_20
		else
			arg0_19.spStoryUnreleasedNode = var0_20
		end
	end)

	local var1_19 = 0

	local function var2_19()
		if not var0_19[var1_19] then
			return
		end

		tailList = var0_19[var1_19]

		local var0_21

		_.each(tailList, function(arg0_22)
			table.insert(arg0_19.spStoryNodes, arg0_19.spStoryNodeDict[arg0_22])

			if var0_19[arg0_22] then
				var0_21 = true
				var1_19 = arg0_22
			end
		end)

		return var0_21
	end

	while var2_19() do
		-- block empty
	end

	local var3_19 = {}
	local var4_19

	_.each(arg0_19.spStoryNodes, function(arg0_23)
		local var0_23 = arg0_23:GetPreNodes()

		if #var0_23 == 0 then
			var4_19 = arg0_23

			return
		end

		_.each(var0_23, function(arg0_24)
			var3_19[arg0_24] = var3_19[arg0_24] or {}

			table.insert(var3_19[arg0_24], arg0_23)
		end)
	end)

	arg0_19.storyTree = {
		root = var4_19,
		childDict = var3_19
	}
end

function var0_0.SetDisplayMode(arg0_25, arg1_25)
	if arg1_25 == arg0_25.contextData.displayMode then
		return
	end

	arg0_25.contextData.displayMode = arg1_25

	arg0_25:UpdateView()
end

function var0_0.UpdateView(arg0_26)
	local var0_26 = arg0_26.contextData.map
	local var1_26 = string.split(var0_26:getConfig("name"), "||")

	if arg0_26.contextData.displayMode == var0_0.DISPLAY.STORY then
		var1_26 = string.split(var1_26[1], "·")

		setText(arg0_26.sceneParent.chapterName, var1_26[1] .. i18n("levelscene_title_story"))
	else
		setText(arg0_26.sceneParent.chapterName, var1_26[1])
	end

	local var2_26 = var0_26:getMapTitleNumber()

	arg0_26.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var2_26, arg0_26.sceneParent.chapterNoTitle, true)

	arg0_26.contextData.displayMode = arg0_26.contextData.displayMode or var0_0.DISPLAY.BATTLE

	var0_0.super.UpdateView(arg0_26)

	local var3_26 = arg0_26.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_26._tf:Find("Battle"), var3_26)
	setActive(arg0_26._tf:Find("Story"), not var3_26)

	local var4_26 = getProxy(ChapterProxy):IsActivitySPChapterActive(var0_26:getConfig("on_activity")) and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_26.battleLayer:Find("Mask/Story/BattleTip"), false)
	setActive(arg0_26.storyLayer:Find("Battle/BattleTip"), var4_26)

	local var5_26 = arg0_26.battleLayer:Find("Mask"):GetComponent(typeof(RectMask2D))

	if type(arg0_26.spStoryIDs) ~= "table" or #arg0_26.spStoryIDs == 0 then
		local var6_26 = var0_26:isRemaster()

		if var6_26 then
			setActive(arg0_26.battleLayer:Find("Mask"), false)

			local var7_26, var8_26 = var0_26:isActivity()
			local var9_26 = var0_26:isSkirmish()
			local var10_26 = var0_26:isEscort()

			setActive(arg0_26.sceneParent.remasterBtn, OPEN_REMASTER and (var6_26 or not var7_26 and not var10_26 and not var9_26))
		else
			var5_26.enabled = true
		end
	end

	arg0_26:UpdateStoryTask()

	if var3_26 then
		arg0_26:UpdateBonusPtIconPath()
		arg0_26:UpdateBattle()
		arg0_26.sceneParent:SwitchMapBG(arg0_26.contextData.map)
		pg.BgmMgr.GetInstance():Pop(arg0_26.__cname)
		arg0_26.sceneParent:PlayBGM()
	else
		arg0_26:UpdateStoryNodeStatus()
		arg0_26:UpdateStory()
		arg0_26:Move2UnlockStory()
		arg0_26:SwitchStoryMapAndBGM()
	end

	arg0_26:TrySubmitTask()
end

function var0_0.UpdateBattle(arg0_27)
	local var0_27 = getProxy(ChapterProxy)
	local var1_27 = arg0_27.displayChapterIDs
	local var2_27 = {}

	for iter0_27, iter1_27 in ipairs(var1_27) do
		local var3_27 = var0_27:getChapterById(iter1_27)

		table.insert(var2_27, var3_27)
	end

	table.clear(arg0_27.chapterTFsById)
	UIItemList.StaticAlign(arg0_27.itemHolder, arg0_27.chapterTpl, #var2_27, function(arg0_28, arg1_28, arg2_28)
		if arg0_28 ~= UIItemList.EventUpdate then
			return
		end

		local var0_28 = var2_27[arg1_28 + 1]

		arg0_27:UpdateMapItem(arg2_28, var0_28)

		arg2_28.name = "Chapter_" .. var0_28.id
		arg0_27.chapterTFsById[var0_28.id] = arg2_28
	end)
end

function var0_0.HideFloat(arg0_29)
	var0_0.super.HideFloat(arg0_29)
	setActive(arg0_29.itemHolder, false)
end

function var0_0.ShowFloat(arg0_30)
	var0_0.super.ShowFloat(arg0_30)
	setActive(arg0_30.itemHolder, true)
end

function var0_0.UpdateMapItem(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg2_31:getConfigTable()

	setLocalPosition(arg1_31, {
		x = 1920 * var0_31.pos_x,
		y = 1080 * var0_31.pos_y
	})

	local var1_31 = findTF(arg1_31, "main")

	setActive(var1_31, true)

	local var2_31 = findTF(var1_31, "circle/fordark")
	local var3_31 = findTF(var1_31, "info/bk/fordark")

	setActive(var2_31, var0_31.icon_outline == 1)
	setActive(var3_31, var0_31.icon_outline == 1)

	local var4_31 = arg0_31.chapterGroupDict[arg2_31.id]

	assert(var4_31)

	local var5_31 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_31 = 1

	if arg2_31:isUnlock() then
		var6_31 = 2

		if #var4_31.list > 1 then
			var6_31 = table.indexof(var4_31.list, arg2_31.id) + 1
		elseif arg2_31:IsSpChapter() or arg2_31:IsEXChapter() then
			var6_31 = 3
		elseif arg0_31.contextData.map:isHardMap() then
			var6_31 = 3
		end
	end

	local var7_31 = findTF(var1_31, "circle/bk")

	for iter0_31, iter1_31 in ipairs(var5_31) do
		setActive(var7_31:Find(iter1_31), iter0_31 == var6_31)
	end

	local var8_31 = findTF(var1_31, "circle/clear_flag")
	local var9_31 = findTF(var1_31, "circle/lock")
	local var10_31 = findTF(var1_31, "circle/progress")
	local var11_31 = findTF(var1_31, "circle/progress_text")
	local var12_31 = findTF(var1_31, "circle/stars")
	local var13_31 = string.split(var0_31.name, "|")

	setText(findTF(var1_31, "info/bk/title_form/title_index"), var0_31.chapter_name .. "  ")
	setText(findTF(var1_31, "info/bk/title_form/title"), var13_31[1])
	setText(findTF(var1_31, "info/bk/title_form/title_en"), var13_31[2] or "")
	setFillAmount(var10_31, arg2_31.progress / 100)
	setText(var11_31, string.format("%d%%", arg2_31.progress))
	setActive(var12_31, arg2_31:existAchieve())

	if arg2_31:existAchieve() then
		for iter2_31, iter3_31 in ipairs(arg2_31.achieves) do
			local var14_31 = ChapterConst.IsAchieved(iter3_31)
			local var15_31 = var12_31:GetChild(iter2_31 - 1):Find("light")

			setActive(var15_31, var14_31)

			for iter4_31, iter5_31 in ipairs(var5_31) do
				if iter5_31 ~= "Lock" then
					setActive(var15_31:Find(iter5_31), iter4_31 == var6_31)
				end
			end
		end
	end

	local var16_31 = findTF(var1_31, "info/bk/BG")

	for iter6_31, iter7_31 in ipairs(var5_31) do
		setActive(var16_31:Find(iter7_31), iter6_31 == var6_31)
	end

	setActive(findTF(var1_31, "HardEffect"), var6_31 == 3)

	local var17_31 = not arg2_31.active and arg2_31:isClear()
	local var18_31 = not arg2_31.active and not arg2_31:isUnlock()

	setActive(var8_31, var17_31)
	setActive(var9_31, var18_31)
	setActive(var11_31, not var17_31 and not var18_31)
	arg0_31:DeleteTween("fighting" .. arg2_31.id)

	local var19_31 = findTF(var1_31, "circle/fighting")

	setText(findTF(var19_31, "Text"), i18n("tag_level_fighting"))

	local var20_31 = findTF(var1_31, "circle/oni")

	setText(findTF(var20_31, "Text"), i18n("tag_level_oni"))

	local var21_31 = findTF(var1_31, "circle/narrative")

	setText(findTF(var21_31, "Text"), i18n("tag_level_narrative"))
	setActive(var19_31, false)
	setActive(var20_31, false)
	setActive(var21_31, false)

	local var22_31
	local var23_31

	if arg2_31:getConfig("chapter_tag") == 1 then
		var22_31 = var21_31
	end

	if arg2_31.active then
		var22_31 = arg2_31:existOni() and var20_31 or var19_31
	end

	if var22_31 then
		setActive(var22_31, true)

		local var24_31 = GetOrAddComponent(var22_31, "CanvasGroup")

		var24_31.alpha = 1

		arg0_31:RecordTween("fighting" .. arg2_31.id, LeanTween.alphaCanvas(var24_31, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_31 = findTF(var1_31, "triesLimit")
	local var26_31 = arg2_31:isTriesLimit()

	setActive(var25_31, var26_31)

	if var26_31 then
		local var27_31 = arg2_31:getConfig("count")
		local var28_31 = var27_31 - arg2_31:getTodayDefeatCount() .. "/" .. var27_31

		setText(var25_31:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_31:Find("Text"), setColorStr(var28_31, var27_31 <= arg2_31:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_31 = pg.expedition_data_by_map[arg2_31:getConfig("map")].on_activity
		local var30_31 = getProxy(ChapterProxy):IsActivitySPChapterActive(var29_31) and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_31:Find("TipRect"), var30_31)
	end

	local var31_31 = arg2_31:GetDailyBonusQuota()
	local var32_31 = findTF(var1_31, "mark")
	local var33_31 = var32_31:Find("bonus")
	local var34_31 = var33_31:Find("icon")
	local var35_31 = findTF(var33_31, "icon/Image")

	setActive(var33_31, var31_31)
	setActive(var32_31, var31_31)

	if var34_31 then
		setActive(var34_31, var31_31 and arg0_31.bonusPtIconPath)
	end

	if var31_31 then
		local var36_31 = var32_31:GetComponent(typeof(CanvasGroup))
		local var37_31 = arg2_31:GetDailyBonusIconName()

		arg0_31.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var37_31, var33_31)

		if var34_31 and arg0_31.bonusPtIconPath then
			if var35_31 then
				GetImageSpriteFromAtlasAsync(arg0_31.bonusPtIconPath, "", var35_31, true)
			else
				GetImageSpriteFromAtlasAsync(arg0_31.bonusPtIconPath, "", var34_31, true)
			end
		end

		LeanTween.cancel(go(var32_31), true)

		local var38_31 = var32_31.anchoredPosition.y

		var36_31.alpha = 0

		LeanTween.value(go(var32_31), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_32)
			var36_31.alpha = arg0_32

			local var0_32 = var32_31.anchoredPosition

			var0_32.y = var38_31 * arg0_32
			var32_31.anchoredPosition = var0_32
		end)):setOnComplete(System.Action(function()
			var36_31.alpha = 1

			local var0_33 = var32_31.anchoredPosition

			var0_33.y = var38_31
			var32_31.anchoredPosition = var0_33
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var39_31 = arg2_31.id

	onButton(arg0_31, var1_31, function()
		arg0_31:TryOpenChapterInfo(var39_31, nil, var4_31.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.SwitchChapter(arg0_35, arg1_35)
	local var0_35 = arg0_35.chapterGroupDict[arg1_35]

	if not var0_35 then
		return
	end

	local var1_35 = var0_35.list[var0_35.index]

	if var1_35 == arg1_35 then
		return
	end

	local var2_35 = table.indexof(var0_35.list, arg1_35)

	var0_35.index = var2_35

	local var3_35 = var0_35.list[1]
	local var4_35 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("spchapter_selected_" .. var4_35 .. "_" .. var3_35, var2_35)

	local var5_35 = arg0_35.chapterTFsById[var1_35]

	arg0_35.chapterTFsById[var1_35] = nil
	arg0_35.chapterTFsById[arg1_35] = var5_35

	arg0_35:UpdateChapterTF(arg1_35)
end

function var0_0.UpdateChapterTF(arg0_36, arg1_36)
	if not arg0_36.chapterGroupDict[arg1_36] then
		return
	end

	local var0_36 = arg0_36.chapterTFsById[arg1_36]

	if var0_36 then
		local var1_36 = getProxy(ChapterProxy):getChapterById(arg1_36)

		arg0_36:UpdateMapItem(var0_36, var1_36)
	end
end

function var0_0.RecyclePools(arg0_37)
	for iter0_37 = #arg0_37.activeItems, 1, -1 do
		local var0_37 = arg0_37.activeItems[iter0_37]
		local var1_37 = arg0_37.pools[var0_37.template]

		if var0_37.template == arg0_37.oneLineTpl then
			setSizeDelta(var0_37.active, {
				x = arg0_37.oneLineWidth,
				y = arg0_37.oneLineHeight
			})
		end

		var1_37:Enqueue(var0_37.active)
	end

	table.clean(arg0_37.activeItems)

	arg0_37.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_38)
	local var0_38 = 0
	local var1_38 = 0
	local var2_38 = pg.NewStoryMgr.GetInstance()
	local var3_38 = {}

	table.Foreach(arg0_38.spStoryIDs, function(arg0_39, arg1_39)
		var3_38[arg1_39] = {}
	end)

	local var4_38 = arg0_38.spStoryNodes

	for iter0_38 = 1, #var4_38 do
		local var5_38 = var4_38[iter0_38]
		local var6_38 = var5_38:GetConfigID()
		local var7_38 = var5_38:GetPreEvent()
		local var8_38 = false
		local var9_38 = var7_38 == 0 and true or var3_38[var7_38].status == var4_0
		local var10_38 = var2_0
		local var11_38 = var5_38:GetStoryName()
		local var12_38 = false

		if var11_38 and var11_38 ~= "" then
			var12_38 = var2_38:IsPlayed(var11_38)
			var0_38 = var0_38 + (var12_38 and 1 or 0)
			var1_38 = var1_38 + 1
		end

		if not var12_38 and var9_38 then
			local var13_38 = {}

			_.each(var5_38:GetUnlockConditions(), function(arg0_40)
				local var0_40 = true

				if arg0_40[1] == ActivitySpStoryNode.CONDITION.TIME then
					var0_40 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_40[2]) <= pg.TimeMgr.GetInstance():GetServerTime()
				elseif arg0_40[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var1_40 = arg0_40[2]

					var0_40 = _.all(var1_40, function(arg0_41)
						return getProxy(ChapterProxy):getChapterById(arg0_41, true):isClear()
					end)
				elseif arg0_40[1] == ActivitySpStoryNode.CONDITION.PT then
					local var2_40 = arg0_40[2][1]
					local var3_40 = arg0_40[2][2]
					local var4_40 = arg0_40[2][3]
					local var5_40 = 0

					if var2_40 == DROP_TYPE_RESOURCE then
						var5_40 = getProxy(PlayerProxy):getRawData():getResource(arg0_40[2])
					elseif var2_40 == DROP_TYPE_ITEM then
						var5_40 = getProxy(BagProxy):getItemCountById(var3_40)
					end

					var0_40 = var4_40 <= var5_40
				end

				table.insert(var13_38, var0_40)

				var9_38 = var9_38 and var0_40
			end)

			var3_38[var6_38].conditionFinishedList = var13_38
		end

		if var12_38 then
			var10_38 = var4_0
		elseif var9_38 then
			var10_38 = var3_0
		end

		var3_38[var6_38].status = var10_38
	end

	arg0_38.storyNodeStatus = var3_38
	arg0_38.storyReadCount, arg0_38.storyReadMax = var0_38, var1_38
end

function var0_0.UpdateStory(arg0_42)
	arg0_42:RecyclePools()

	local var0_42 = {
		"162443",
		"ffffff",
		"ffcb5a"
	}
	local var1_42 = arg0_42.data:getConfig("story_inactive_color")

	if var1_42 and #var1_42 > 0 then
		var0_42[1] = var1_42
	end

	local var2_42 = 0
	local var3_42 = 150
	local var4_42 = 150
	local var5_42 = {
		{
			node = arg0_42.storyTree.root,
			nodePos = Vector2.New(var3_42, 0)
		}
	}
	local var6_42 = arg0_42.nodeTplWidth
	local var7_42 = arg0_42.oneLineWidth
	local var8_42 = arg0_42.branchHeadWidth
	local var9_42 = arg0_42.branchUpWidth
	local var10_42 = arg0_42.branchUpHeight
	local var11_42 = arg0_42.UnionTailWidth
	local var12_42 = 75
	local var13_42 = 82
	local var14_42 = 32

	local function var15_42()
		local var0_43 = table.remove(var5_42, 1)
		local var1_43 = var0_43.node:GetConfigID()

		;(function()
			local var0_44 = arg0_42:DequeItem(arg0_42.storyNodeTpl)

			var0_44.name = var1_43

			setAnchoredPosition(var0_44, var0_43.nodePos)

			arg0_42.storyNodeTFsById[var1_43] = {
				nodeTF = tf(var0_44)
			}
		end)()

		local var2_43 = arg0_42.storyTree.childDict[var1_43] or {}

		if #var2_43 == 0 then
			var2_42 = var0_43.nodePos.x + var6_42 + var4_42
		elseif #var2_43 == 1 then
			local var3_43 = var2_43[1]
			local var4_43 = var3_43:GetConfigID()
			local var5_43 = arg0_42:DequeItem(arg0_42.oneLineTpl)

			var5_43.name = string.format("Line%s_%s", var1_43, var4_43)

			setAnchoredPosition(var5_43, var0_43.nodePos + Vector2.New(var6_42 + var14_42, 0))

			nextPos = tf(var5_43).anchoredPosition + Vector2.New(var7_42 + var12_42, 0)

			local var6_43 = arg0_42.storyNodeStatus[var4_43].status

			eachChild(var5_43, function(arg0_45)
				setImageColor(arg0_45, Color.NewHex(var0_42[var6_43]))
			end)
			table.insert(var5_42, {
				node = var3_43,
				nodePos = nextPos
			})
		elseif #var2_43 > 1 then
			local var7_43 = {}
			local var8_43

			table.Ipairs(var2_43, function(arg0_46, arg1_46)
				local var0_46 = 0
				local var1_46 = arg1_46

				local function var2_46()
					var0_46 = var0_46 + 1

					local var0_47 = arg0_42.storyTree.childDict[var1_46:GetConfigID()]

					if not var0_47 then
						return false
					end

					assert(#var0_47 <= 1)

					local var1_47 = var0_47[1]

					if var1_47 and #var1_47:GetPreNodes() == 1 then
						var1_46 = var1_47

						return true
					else
						var8_43 = var1_47
					end
				end

				while var2_46() do
					-- block empty
				end

				var7_43[arg0_46] = var0_46
			end)

			local var9_43 = _.max(var7_43)
			local var10_43 = var9_43 * (var6_42 + var12_42 + var14_42) + (var9_43 - 1) * var7_42
			local var11_43 = var0_43.nodePos + Vector2.New(var6_42 + var14_42, 0)

			;(function()
				local var0_48 = arg0_42:DequeItem(arg0_42.branchHeadTpl)

				setAnchoredPosition(var0_48, var11_43)

				var11_43 = var11_43 + Vector2.New(var8_42, 0)

				local var1_48 = arg0_42.storyNodeStatus[var2_43[1]:GetConfigID()].status

				eachChild(var0_48, function(arg0_49)
					setImageColor(arg0_49, Color.NewHex(var0_42[var1_48]))
				end)
			end)()
			table.Ipairs(var2_43, function(arg0_50, arg1_50)
				local var0_50 = var7_42

				if var7_43[arg0_50] < var9_43 then
					local var1_50 = var7_43[arg0_50]

					var0_50 = (var10_43 - var1_50 * (var6_42 + var12_42 + var14_42)) / (var1_50 + 1)
				end

				local var2_50 = arg1_50:GetConfigID()
				local var3_50 = var11_43

				;(function()
					local var0_51

					if arg0_50 == 1 then
						var0_51 = arg0_42:DequeItem(arg0_42.branchUpTpl)

						setAnchoredPosition(var0_51, var3_50)

						var3_50 = var3_50 + Vector2.New(var9_42, var10_42)

						if var7_43[arg0_50] < var9_43 then
							setSizeDelta(var0_51, {
								x = var9_42 + var0_50,
								y = var10_42
							})

							local var1_51 = tf(var0_51):Find("Line_1").sizeDelta

							var1_51.x = var1_51.x + var0_50

							setSizeDelta(tf(var0_51):Find("Line_1"), var1_51)

							var3_50 = var3_50 + Vector2.New(var0_50, 0)
						end
					elseif (arg0_50 == 3 or arg0_50 == 2 and #var2_43 == 2) and arg0_42.storyTree.childDict[var2_43[1]:GetConfigID()] then
						var0_51 = arg0_42:DequeItem(arg0_42.branchDownTpl)

						setAnchoredPosition(var0_51, var3_50)

						var3_50 = var3_50 + Vector2.New(var9_42, -var10_42)

						if var7_43[arg0_50] < var9_43 then
							setSizeDelta(var0_51, {
								x = var9_42 + var0_50,
								y = var10_42
							})

							local var2_51 = tf(var0_51):Find("Line_1").sizeDelta

							var2_51.x = var2_51.x + var0_50

							setSizeDelta(tf(var0_51):Find("Line_1"), var2_51)

							var3_50 = var3_50 + Vector2.New(var0_50, 0)
						end
					else
						var0_51 = arg0_42:DequeItem(arg0_42.branchCenterTpl)

						setAnchoredPosition(var0_51, var3_50)

						var3_50 = var3_50 + Vector2.New(var9_42, 0)

						if var7_43[arg0_50] < var9_43 then
							local var3_51 = tf(var0_51).sizeDelta

							var3_51.x = var3_51.x + var0_50

							setSizeDelta(var0_51, var3_51)

							var3_50 = var3_50 + Vector2.New(var0_50, 0)
						end
					end

					var0_51.name = string.format("Branch%s_%s", var1_43, var2_50)

					local var4_51 = arg0_42.storyNodeStatus[var2_50].status

					eachChild(var0_51, function(arg0_52)
						setImageColor(arg0_52, Color.NewHex(var0_42[var4_51]))
					end)
				end)()

				var3_50 = var3_50 + Vector2.New(var12_42, 0)

				local var4_50 = arg0_42:DequeItem(arg0_42.storyNodeTpl)

				var4_50.name = var2_50

				setAnchoredPosition(var4_50, var3_50)

				arg0_42.storyNodeTFsById[var2_50] = {
					nodeTF = tf(var4_50)
				}
				var3_50 = var3_50 + Vector2.New(var6_42 + var14_42, 0)

				local var5_50 = arg1_50

				if arg0_42.storyTree.childDict[var2_50] then
					local var6_50 = arg0_42.storyTree.childDict[var2_50][1]

					local function var7_50()
						if not var6_50 or var6_50 == var8_43 then
							return
						end

						local var0_53 = arg0_42:DequeItem(arg0_42.oneLineTpl)

						var0_53.name = string.format("Line%s_%s", var5_50:GetConfigID(), var6_50:GetConfigID())

						setAnchoredPosition(var0_53, var3_50)

						var3_50 = var3_50 + Vector2.New(var0_50 + var12_42, 0)

						setSizeDelta(var0_53, {
							x = var0_50,
							y = arg0_42.oneLineHeight
						})

						local var1_53 = arg0_42.storyNodeStatus[var6_50:GetConfigID()].status

						eachChild(var0_53, function(arg0_54)
							setImageColor(arg0_54, Color.NewHex(var0_42[var1_53]))
						end)

						local var2_53 = arg0_42:DequeItem(arg0_42.storyNodeTpl)

						var2_53.name = var6_50:GetConfigID()

						setAnchoredPosition(var2_53, var3_50)

						arg0_42.storyNodeTFsById[var6_50:GetConfigID()] = {
							nodeTF = tf(var2_53)
						}
						var3_50 = var3_50 + Vector2.New(var6_42 + var14_42, 0)

						local var3_53 = arg0_42.storyTree.childDict[var6_50:GetConfigID()]

						if not var3_53 then
							return false
						end

						var6_50, var5_50 = var3_53[1], var6_50

						return true
					end

					while var7_50() do
						-- block empty
					end
				end

				if var8_43 then
					local var8_50

					if arg0_50 == 1 then
						var8_50 = arg0_42:DequeItem(arg0_42.unionUpTpl)

						setAnchoredPosition(var8_50, var3_50)

						if var7_43[arg0_50] < var9_43 then
							setSizeDelta(var8_50, {
								x = var9_42 + var0_50,
								y = var10_42
							})

							local var9_50 = tf(var8_50):Find("Line_1").sizeDelta

							var9_50.x = var9_50.x + var0_50

							setSizeDelta(tf(var8_50):Find("Line_1"), var9_50)

							var3_50 = var3_50 + Vector2.New(var0_50, 0)
						end
					elseif arg0_50 == 3 or arg0_50 == 2 and #var2_43 == 2 then
						var8_50 = arg0_42:DequeItem(arg0_42.unionDownTpl)

						setAnchoredPosition(var8_50, var3_50)

						if var7_43[arg0_50] < var9_43 then
							setSizeDelta(var8_50, {
								x = var9_42 + var0_50,
								y = var10_42
							})

							local var10_50 = tf(var8_50):Find("Line_1").sizeDelta

							var10_50.x = var10_50.x + var0_50

							setSizeDelta(tf(var8_50):Find("Line_1"), var10_50)

							var3_50 = var3_50 + Vector2.New(var0_50, 0)
						end
					else
						var8_50 = arg0_42:DequeItem(arg0_42.unionCenterTpl)

						setAnchoredPosition(var8_50, var3_50)

						if var7_43[arg0_50] < var9_43 then
							local var11_50 = tf(var8_50).sizeDelta

							var11_50.x = var11_50.x + var0_50

							setSizeDelta(var8_50, var11_50)

							var3_50 = var3_50 + Vector2.New(var0_50, 0)
						end
					end

					var8_50.name = string.format("Union%s_%s", var5_50:GetConfigID(), var8_43:GetConfigID())

					local var12_50 = arg0_42.storyNodeStatus[var8_43:GetConfigID()].status

					eachChild(var8_50, function(arg0_55)
						setImageColor(arg0_55, Color.NewHex(var0_42[var12_50]))
					end)
				end
			end)

			var11_43 = var11_43 + Vector2.New(var10_43 + var9_42, 0)

			if var8_43 then
				(function()
					var11_43 = var11_43 + Vector2.New(var9_42, 0)

					local var0_56 = arg0_42:DequeItem(arg0_42.unionTailTpl)

					setAnchoredPosition(var0_56, var11_43)

					var11_43 = var11_43 + Vector2.New(var11_42 + var13_42, 0)

					local var1_56 = arg0_42.storyNodeStatus[var8_43:GetConfigID()].status

					eachChild(var0_56, function(arg0_57)
						setImageColor(arg0_57, Color.NewHex(var0_42[var1_56]))
					end)
				end)()
				table.insert(var5_42, {
					node = var8_43,
					nodePos = var11_43
				})
			else
				var2_42 = var11_43.x + var4_42
			end
		end

		return next(var5_42)
	end

	while var15_42() do
		-- block empty
	end

	setSizeDelta(arg0_42.storyContainer, {
		x = var2_42
	})

	if arg0_42.spStoryUnreleasedNode then
		local var16_42 = cloneTplTo(arg0_42.unreleasedNodeTpl, arg0_42.storyContainer)

		setAnchoredPosition(var16_42, {
			y = 0,
			x = var2_42
		})
		setText(var16_42:Find("text"), arg0_42.spStoryUnreleasedNode:GetDisplayName())
		ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_42.spStoryUnreleasedNode:GetCleanAnimator(), "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_58)
			local var0_58 = Instantiate(arg0_58)
			local var1_58 = Vector3.New(-525, 0, 380)

			tf(var0_58).localPosition = var1_58

			setParent(var0_58, var16_42)
		end), true, true)
	end

	local var17_42 = arg0_42.spStoryNodes

	for iter0_42 = 1, #var17_42 do
		local var18_42 = var17_42[iter0_42]
		local var19_42 = var18_42:GetConfigID()
		local var20_42 = arg0_42.storyNodeStatus[var19_42].status
		local var21_42 = arg0_42.storyNodeTFsById[var19_42].nodeTF
		local var22_42 = var21_42:Find("info/bk/title_form/title")

		if var20_42 == var2_0 then
			local var23_42 = var18_42:GetUnlockDesc()
			local var24_42 = ""

			if type(var23_42) == "table" then
				local var25_42 = arg0_42.storyNodeStatus[var19_42].conditionFinishedList or {}

				var24_42 = var23_42[1] or ""

				for iter1_42, iter2_42 in ipairs(var23_42) do
					if not var25_42[iter1_42] then
						var24_42 = iter2_42 or ""

						break
					end
				end
			else
				var24_42 = var23_42 or ""
			end

			setScrollText(var22_42, HXSet.hxLan(var24_42))
			setTextAlpha(var22_42, 0.5)
		else
			setScrollText(var22_42, HXSet.hxLan(var18_42:GetDisplayName()))
			setTextAlpha(var22_42, 1)
		end

		local var26_42 = var18_42:GetType()

		setActive(var21_42:Find("circle/lock"), var20_42 == var2_0)

		if var20_42 == var2_0 then
			setActive(var21_42:Find("circle/Story"), false)
			setActive(var21_42:Find("circle/Battle"), false)
			setActive(var21_42:Find("circle/Option"), false)
			setText(var21_42:Find(""))
		elseif var26_42 == ActivitySpStoryNode.NODE_TYPE.STORY then
			setActive(var21_42:Find("circle/Option"), false)
			setActive(var21_42:Find("circle/Story"), true)
			setActive(var21_42:Find("circle/Battle"), false)
			setActive(var21_42:Find("circle/Story/Done"), var20_42 == var4_0)
		elseif var26_42 == ActivitySpStoryNode.NODE_TYPE.OPTION_BRANCH then
			setActive(var21_42:Find("circle/Option"), true)
			setActive(var21_42:Find("circle/Story"), false)
			setActive(var21_42:Find("circle/Battle"), false)
			setActive(var21_42:Find("circle/Option/Done"), var20_42 == var4_0)
		elseif var26_42 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
			setActive(var21_42:Find("circle/Story"), false)
			setActive(var21_42:Find("circle/Option"), false)
			setActive(var21_42:Find("circle/Battle"), var26_42 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var21_42:Find("circle/Battle/Done"), var20_42 == var4_0)
		end

		local var27_42 = var20_42 == var4_0

		setActive(var21_42:Find("circle/progress"), var27_42)

		local var28_42 = var18_42:IsRecrew()

		if var28_42 == nil then
			setActive(var21_42:Find("recrew"), false)
		else
			setActive(var21_42:Find("recrew"), true)
			setActive(var21_42:Find("recrew/recrewed"), var28_42)
			setActive(var21_42:Find("recrew/not_recrew"), not var28_42)
			setText(var21_42:Find("recrew/recrewed/label"), i18n("story_recrewed"))
			setText(var21_42:Find("recrew/not_recrew/label"), i18n("story_not_recrew"))
		end

		onButton(arg0_42, var21_42, function()
			if var20_42 == var2_0 then
				return
			end

			local var0_59 = var18_42:GetStoryName()

			arg0_42:PlayStory(var0_59, function()
				arg0_42.needFocusStory = true

				arg0_42:Move2UnlockStory()
			end, true)
		end)
	end

	local var29_42 = arg0_42.storyReadCount
	local var30_42 = arg0_42.storyReadMax

	setText(arg0_42.progressText, var29_42 .. "/" .. var30_42)
	setActive(arg0_42.storyAward, tobool(arg0_42.storyTask))

	if arg0_42.storyTask then
		local var31_42 = arg0_42.storyTask:getConfig("award_display")
		local var32_42 = Drop.New({
			type = var31_42[1][1],
			id = var31_42[1][2],
			count = var31_42[1][3]
		})

		updateDrop(arg0_42.storyAward:GetChild(0), var32_42)

		local var33_42 = arg0_42.storyTask:getTaskStatus()

		setActive(arg0_42.storyAward:Find("get"), var33_42 == 1)
		setActive(arg0_42.storyAward:Find("got"), var33_42 == 2)
		onButton(arg0_42, arg0_42.storyAward, function()
			arg0_42:emit(BaseUI.ON_DROP, var32_42)
		end)
	end
end

function var0_0.DequeItem(arg0_62, arg1_62)
	local var0_62 = arg0_62.pools[arg1_62]:Dequeue()

	table.insert(arg0_62.activeItems, {
		template = arg1_62,
		active = var0_62
	})
	setActive(var0_62, true)
	setParent(var0_62, arg0_62.storyContainer)

	return var0_62
end

function var0_0.Move2UnlockStory(arg0_63)
	if not arg0_63.needFocusStory then
		return
	end

	arg0_63.needFocusStory = nil

	local var0_63 = arg0_63.spStoryNodes
	local var1_63

	for iter0_63 = #var0_63, 1, -1 do
		local var2_63 = var0_63[iter0_63]:GetConfigID()

		if arg0_63.storyNodeStatus[var2_63].status > var2_0 then
			var1_63 = var2_63

			break
		end
	end

	local var3_63 = arg0_63.storyNodeTFsById[var1_63].nodeTF
	local var4_63 = arg0_63.storyNodeTpl.rect.width
	local var5_63 = var3_63.anchoredPosition.x + var4_63 * 0.5 - arg0_63.storyContainer.parent.rect.width * 0.5
	local var6_63 = math.clamp(var5_63, 0, math.max(0, arg0_63.storyContainer.rect.width - arg0_63.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_63.storyContainer, {
		x = -var6_63
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_64)
	local var0_64 = arg0_64.data:getConfig("default_background")
	local var1_64 = arg0_64.data:getConfig("default_bgm")
	local var2_64
	local var3_64 = arg0_64.spStoryNodes

	for iter0_64 = 1, #var3_64 do
		local var4_64 = var3_64[iter0_64]
		local var5_64 = var4_64:GetConfigID()

		if arg0_64.storyNodeStatus[var5_64].status == var4_0 then
			var0_64, var1_64 = var4_64:GetCleanBG(), var4_64:GetCleanBGM()
			var2_64 = var4_64:GetCleanAnimator()
		else
			break
		end
	end

	arg0_64.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_64,
			Animator = var2_64
		}
	})
	pg.BgmMgr.GetInstance():Pop(arg0_64.__cname)
	pg.BgmMgr.GetInstance():Push(arg0_64.__cname, var1_64)
end

function var0_0.TrySubmitTask(arg0_65)
	local var0_65 = true

	for iter0_65, iter1_65 in ipairs(arg0_65.spStoryNodes) do
		local var1_65 = iter1_65:GetStoryName()

		if var1_65 and var1_65 ~= "" then
			var0_65 = var0_65 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_65)
		end

		if not var0_65 then
			break
		end
	end

	if var0_65 and arg0_65.storyTask and arg0_65.storyTask:getTaskStatus() == 1 then
		arg0_65:emit(LevelMediator2.ON_SUBMIT_TASK, arg0_65.storyTask.id)

		return
	end
end

function var0_0.PlayStory(arg0_66, arg1_66, arg2_66, arg3_66)
	if not arg1_66 then
		return existCall(arg2_66)
	end

	local var0_66 = pg.NewStoryMgr.GetInstance()
	local var1_66 = var0_66:IsPlayed(arg1_66)

	seriesAsync({
		function(arg0_67)
			if var1_66 and not arg3_66 then
				return arg0_67()
			end

			local var0_67 = tonumber(arg1_66)

			if var0_67 and var0_67 > 0 then
				arg0_66:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_67, nil, var1_66)
			else
				var0_66:PlayForAcivitySpStory(arg1_66, arg0_67, arg3_66)
			end
		end,
		function(arg0_68, ...)
			existCall(arg2_66, ...)
			arg0_66:UpdateView()
		end
	})
end

function var0_0.UpdateStoryTask(arg0_69)
	local var0_69 = arg0_69.activity and arg0_69.activity:getConfig("config_client").task_id

	if not var0_69 then
		return
	end

	arg0_69.storyTask = getProxy(TaskProxy):getTaskVO(var0_69) or Task.New({
		submit_time = 1,
		id = var0_69
	})
end

function var0_0.OnSubmitTaskDone(arg0_70)
	arg0_70:UpdateView()
end

function var0_0.OnDestroy(arg0_71)
	arg0_71:RecyclePools()

	for iter0_71, iter1_71 in pairs(arg0_71.pools) do
		iter1_71:Clear()
	end
end

return var0_0
