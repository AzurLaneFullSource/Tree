local var0_0 = class("WorldMediaCollectionStoryLineView")

var0_0.START_GAP = 800
var0_0.END_GAP = 1000
var0_0.HRZ_GAP = 467
var0_0.CHAPTER_PROGRESS_MIN_WIDTH = 120
var0_0.NATION_LIST = {
	{
		key = -1,
		name = "word_shipNation_all"
	},
	{
		key = 1,
		name = "word_shipNation_baiYing"
	},
	{
		key = 2,
		name = "word_shipNation_huangJia"
	},
	{
		key = 3,
		name = "word_shipNation_chongYing"
	},
	{
		key = 4,
		name = "word_shipNation_tieXue"
	},
	{
		key = 5,
		name = "word_shipNation_dongHuang"
	},
	{
		key = 6,
		name = "word_shipNation_saDing"
	},
	{
		key = 7,
		name = "word_shipNation_beiLian"
	},
	{
		key = 10,
		name = "word_shipNation_yuanwei"
	},
	{
		key = 11,
		name = "word_shipNation_yujinwangguo"
	},
	{
		key = 12,
		name = "word_shipNation_jinghuanlianmeng"
	},
	{
		key = 97,
		name = "word_shipNation_meta_index"
	}
}

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.tf = arg1_1

	arg0_1:init()
	arg0_1:ConfigData()
	arg0_1:UpdateView()
end

function var0_0.init(arg0_2)
	arg0_2.contentHeight = 0
	arg0_2.nodeTpl = arg0_2.tf:Find("Story/NodeTemplate")
	arg0_2.nodeContainer = arg0_2.tf:Find("Story/Nodes/Viewport/Content")
	arg0_2.scroll = arg0_2.tf:Find("Story/Nodes")

	arg0_2.scroll:GetComponent(typeof(ScrollRect)).onValueChanged:AddListener(function()
		arg0_2:onScroll()
	end)

	arg0_2.progressMark = arg0_2.tf:Find("ChapterProgress/bg/progressMark")
	arg0_2.progressCurrentMark = arg0_2.tf:Find("ChapterProgress/bg/currentMark")
	arg0_2.linkHrzTpl = arg0_2.tf:Find("Story/Horizon")
	arg0_2.linkVrtTpl = arg0_2.tf:Find("Story/Vertical")

	arg0_2:initFilter()

	arg0_2.detailView = arg0_2.tf:Find("NodeDetail")
	arg0_2.gotoBtn = arg0_2.detailView:Find("goto_btn")

	setText(arg0_2.detailView:Find("camp/label/text"), i18n("storyline_camp"))
	setText(arg0_2.gotoBtn:Find("text"), i18n("storyline_goto"))

	arg0_2.filterBtn = arg0_2.tf:Find("Filter")

	onButton(arg0_2, arg0_2.filterBtn, function()
		arg0_2:showFilter()
	end)
	onButton(arg0_2, arg0_2.gotoBtn, function()
		arg0_2:gotoStory()
	end)
	onButton(arg0_2, arg0_2.scroll, function()
		arg0_2:HideNodeDetail()
	end)
end

function var0_0.initFilter(arg0_7)
	arg0_7.filterDict = {}
	arg0_7.filter = arg0_7.tf:Find("NodeFilter")
	arg0_7.filterCancel = arg0_7.tf:Find("NodeFilter/cancel")
	arg0_7.filterConfirm = arg0_7.tf:Find("NodeFilter/confirm")

	onButton(arg0_7, arg0_7.filterCancel, function()
		arg0_7:cancelFilter()
	end)
	onButton(arg0_7, arg0_7.filterConfirm, function()
		arg0_7:confirmFilter()
	end)
	setText(arg0_7.tf:Find("NodeFilter/label/cn"), i18n("indexsort_camp"))
	setText(arg0_7.tf:Find("NodeFilter/label/en"), i18n("indexsort_campeng"))

	arg0_7.filterTFDict = {}

	local var0_7 = arg0_7.tf:Find("NodeFilter/content")
	local var1_7 = arg0_7.tf:Find("NodeFilter/content/camp")

	for iter0_7, iter1_7 in ipairs(var0_0.NATION_LIST) do
		local var2_7 = cloneTplTo(var1_7, var0_7)

		arg0_7.filterTFDict[iter1_7.key] = var2_7

		setActive(var2_7, true)
		onButton(arg0_7, var2_7, function()
			arg0_7:updateFilterList(iter1_7.key)
		end)
		setText(var2_7:Find("Text"), i18n(iter1_7.name))
	end

	arg0_7:updateFilterList(-1)
end

function var0_0.updateFilterList(arg0_11, arg1_11)
	if arg1_11 == -1 then
		if arg0_11.filterDict[-1] then
			return
		else
			arg0_11.filterDict = {
				[-1] = true
			}
		end
	elseif arg0_11.filterDict[arg1_11] then
		arg0_11.filterDict[arg1_11] = nil
	else
		arg0_11.filterDict[arg1_11] = true
	end

	local var0_11 = true

	for iter0_11, iter1_11 in pairs(arg0_11.filterDict) do
		if iter0_11 ~= -1 then
			var0_11 = false

			break
		end
	end

	arg0_11.filterDict[-1] = var0_11 and true or nil

	for iter2_11, iter3_11 in ipairs(var0_0.NATION_LIST) do
		setActive(arg0_11.filterTFDict[iter3_11.key]:Find("on"), arg0_11.filterDict[iter3_11.key])
		setActive(arg0_11.filterTFDict[iter3_11.key]:Find("off"), not arg0_11.filterDict[iter3_11.key])
	end
end

function var0_0.ConfigCallback(arg0_12, arg1_12, arg2_12)
	arg0_12.storyJumpCallback = arg1_12
	arg0_12.recordJumpCallback = arg2_12
end

function var0_0.ConfigData(arg0_13)
	arg0_13.memoryNodeDict = {}
	arg0_13.chapterHead = {}

	local var0_13 = pg.memory_storyline

	for iter0_13, iter1_13 in ipairs(var0_13.all) do
		local var1_13 = MemoryStoryLineNode.New({
			configId = iter1_13
		})
		local var2_13 = var1_13:GetColumn()

		arg0_13.memoryNodeDict[var2_13] = arg0_13.memoryNodeDict[var2_13] or {}

		table.insert(arg0_13.memoryNodeDict[var2_13], var1_13)

		local var3_13 = var1_13:GetChapter()

		if arg0_13.chapterHead[var3_13] == nil or var1_13:GetColumn() < arg0_13.chapterHead[var3_13]:GetColumn() then
			arg0_13.chapterHead[var3_13] = var1_13
		end
	end
end

function var0_0.UpdateView(arg0_14)
	arg0_14:updateNodeTree()
	arg0_14:updateNodeLine()
	arg0_14:updateChapterProgress()
	arg0_14:onScroll()
end

function var0_0.updateChapterProgress(arg0_15)
	arg0_15.progressDict = {}
	arg0_15.chapterProgress = arg0_15.tf:Find("ChapterProgress")
	arg0_15.chapterProgressContainer = arg0_15.chapterProgress:Find("bg")
	arg0_15.chapterProgressSplit = arg0_15.chapterProgress:Find("bg/splitTpl")
	arg0_15.chapterProgressLabel = arg0_15.chapterProgress:Find("bg/chapterLabelTpl")
	arg0_15.chapterProgressTotalWidth = rtf(arg0_15.chapterProgressContainer).rect.width

	local var0_15 = {}
	local var1_15 = 0

	for iter0_15, iter1_15 in pairs(arg0_15.nodeDataDict) do
		var1_15 = var1_15 + 1

		local var2_15 = iter1_15.VO:GetChapter()

		var0_15[var2_15] = var0_15[var2_15] and var0_15[var2_15] + 1 or 1
	end

	local var3_15 = {}

	for iter2_15, iter3_15 in pairs(var0_15) do
		table.insert(var3_15, iter2_15)
	end

	table.sort(var3_15)

	local var4_15 = #var3_15

	if var4_15 == 0 then
		return
	end

	local var5_15 = math.min(var0_0.CHAPTER_PROGRESS_MIN_WIDTH, arg0_15.chapterProgressTotalWidth / var4_15)
	local var6_15 = {}
	local var7_15 = {}
	local var8_15 = arg0_15.chapterProgressTotalWidth
	local var9_15 = var1_15
	local var10_15 = true

	while var10_15 and var9_15 > 0 do
		var10_15 = false

		for iter4_15, iter5_15 in ipairs(var3_15) do
			if not var7_15[iter5_15] then
				local var11_15 = var0_15[iter5_15]

				if var5_15 > var8_15 * (var11_15 / var9_15) then
					var6_15[iter5_15] = var5_15
					var7_15[iter5_15] = true
					var8_15 = var8_15 - var5_15
					var9_15 = var9_15 - var11_15
					var10_15 = true
				end
			end
		end
	end

	for iter6_15, iter7_15 in ipairs(var3_15) do
		if not var7_15[iter7_15] then
			var6_15[iter7_15] = var9_15 > 0 and var8_15 * (var0_15[iter7_15] / var9_15) or 0
		end
	end

	local var12_15 = 0

	for iter8_15, iter9_15 in ipairs(var3_15) do
		local var13_15 = {
			w = var6_15[iter9_15],
			x = var12_15
		}

		if iter8_15 > 1 then
			local var14_15 = cloneTplTo(arg0_15.chapterProgressSplit, arg0_15.chapterProgressContainer)

			setActive(var14_15, true)

			var14_15.anchoredPosition = Vector2(var13_15.x, 2.86)
		end

		var13_15.leftBound = var13_15.x
		var13_15.rightBound = var13_15.x + var13_15.w

		local var15_15 = cloneTplTo(arg0_15.chapterProgressLabel, arg0_15.chapterProgressContainer)

		var15_15.anchoredPosition = Vector2(var13_15.x, 12)
		rtf(var15_15).sizeDelta = Vector2(var13_15.w, 32)

		setText(var15_15, i18n("storyline_chapter" .. iter9_15))
		setActive(var15_15, true)

		local var16_15 = var15_15:Find("chapterWarpBtn")

		onButton(arg0_15, var16_15, function()
			local var0_16 = arg0_15.chapterHead[iter9_15]:GetConfigID()
			local var1_16 = (arg0_15.nodeDataDict[var0_16].nodeTF.anchoredPosition.x - var0_0.START_GAP) / arg0_15.contentWidth

			scrollTo(arg0_15.scroll, var1_16)
		end)

		arg0_15.progressDict[iter9_15] = var13_15
		var12_15 = var12_15 + var13_15.w
	end
end

function var0_0.showFilter(arg0_17)
	pg.UIMgr.GetInstance():BlurPanel(arg0_17.filter)

	for iter0_17, iter1_17 in ipairs(var0_0.NATION_LIST) do
		setActive(arg0_17.filterTFDict[iter1_17.key]:Find("on"), arg0_17.filterDict[iter1_17.key])
		setActive(arg0_17.filterTFDict[iter1_17.key]:Find("off"), not arg0_17.filterDict[iter1_17.key])
	end

	setActive(arg0_17.filter, true)

	arg0_17.filterSnapShot = Clone(arg0_17.filterDict)
end

function var0_0.cancelFilter(arg0_18)
	arg0_18.filterDict = arg0_18.filterSnapShot

	arg0_18:closeFilter()
end

function var0_0.confirmFilter(arg0_19)
	arg0_19:updateNodes()
	arg0_19:closeFilter()
end

function var0_0.closeFilter(arg0_20)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20.filter, arg0_20.tf)

	arg0_20.filterSnapShot = nil

	setActive(arg0_20.filter, false)
end

function var0_0.refresh(arg0_21)
	arg0_21.selectedID = nil

	arg0_21:closeFilter()
	arg0_21:HideNodeDetail()
	setActive(arg0_21.detailView, false)
	scrollTo(arg0_21.scroll, 0)
end

function var0_0.ShowNodeDetail(arg0_22, arg1_22)
	if arg0_22.selectedID then
		local var0_22 = arg0_22.nodeDataDict[arg0_22.selectedID].nodeTF

		setActive(var0_22:Find("info/selected"), false)
		setActive(var0_22:Find("info/selected_multi"), false)
	end

	arg0_22.selectedID = arg1_22

	local var1_22 = arg0_22.nodeDataDict[arg1_22].VO

	setActive(arg0_22.detailView, true)
	quickPlayAnimation(arg0_22.detailView, "anim_WorldMediaCollectionMemoryGroupUI_NodeDetail_enter")
	setText(arg0_22.detailView:Find("info/title"), var1_22:GetName())
	setText(arg0_22.detailView:Find("info/desc/content"), var1_22:GetDesc())
	LoadImageSpriteAsync("memorystoryline/" .. var1_22:GetIcon(), arg0_22.detailView:Find("info/icon"), true)
	LoadImageSpriteAtlasAsync("ui/worldmediacollectionmemoryui_atlas", var1_22:GetMark(), arg0_22.detailView:Find("info/icon/mark"), true)

	local var2_22 = arg0_22.detailView:Find("camp/nations")
	local var3_22 = var1_22:GetNations()

	eachChild(var2_22, function(arg0_23)
		local var0_23 = tonumber(arg0_23.name)

		setActive(arg0_23, table.contains(var3_22, var0_23))
		setActive(arg0_23:Find("filter"), arg0_22.filterDict[var0_23])
	end)

	local var4_22 = arg0_22.nodeDataDict[arg1_22].nodeTF
	local var5_22 = false

	for iter0_22, iter1_22 in pairs(arg0_22.filterDict) do
		if table.contains(var3_22, iter0_22) then
			var5_22 = true

			break
		end
	end

	if var5_22 then
		setActive(var4_22:Find("info/selected_multi"), true)
	else
		setActive(var4_22:Find("info/selected"), true)
	end

	local var6_22 = (var4_22.anchoredPosition.x - var0_0.START_GAP) / arg0_22.contentWidth

	scrollTo(arg0_22.scroll, var6_22)
	arg0_22:TryPlayBGM()
end

function var0_0.TryPlayBGM(arg0_24)
	if arg0_24.selectedID then
		local var0_24 = arg0_24.nodeDataDict[arg0_24.selectedID].VO

		pg.BgmMgr.GetInstance():TempPlay(var0_24:GetBGM())
	end
end

function var0_0.HideNodeDetail(arg0_25)
	if arg0_25.selectedID then
		local var0_25 = arg0_25.nodeDataDict[arg0_25.selectedID].nodeTF

		setActive(var0_25:Find("info/selected"), false)
		setActive(var0_25:Find("info/selected_multi"), false)
		quickPlayAnimation(arg0_25.detailView, "anim_WorldMediaCollectionMemoryGroupUI_NodeDetail_quit")

		arg0_25.selectedID = false

		pg.BgmMgr.GetInstance():ContinuePlay()
	end
end

function var0_0.onScroll(arg0_26)
	local var0_26 = Mathf.Clamp(-arg0_26.nodeContainer.anchoredPosition.x / arg0_26.contentWidth, 0, 1)
	local var1_26 = arg0_26.progressMark.anchoredPosition

	var1_26.x = var0_26 * arg0_26.chapterProgressTotalWidth
	arg0_26.progressMark.anchoredPosition = var1_26

	local var2_26 = 0

	for iter0_26, iter1_26 in pairs(arg0_26.progressDict) do
		if var1_26.x >= iter1_26.leftBound and var1_26.x <= iter1_26.rightBound then
			var2_26 = iter0_26
		end
	end

	arg0_26:updateCurrentChapterMark(var2_26)

	local var3_26 = -math.modf(arg0_26.nodeContainer.anchoredPosition.x / var0_0.HRZ_GAP) + 1
	local var4_26
	local var5_26

	for iter2_26 = var3_26 - 2, var3_26 + 2 do
		for iter3_26, iter4_26 in ipairs(arg0_26.nodeDataDict) do
			if iter2_26 == iter4_26.col then
				if iter4_26.row == 2 then
					var4_26 = true
				elseif iter4_26.row == -1 then
					var5_26 = true
				end
			end
		end
	end

	local var6_26

	if var4_26 and not var5_26 then
		var6_26 = 254
	elseif not var4_26 then
		var6_26 = 0
	elseif var4_26 and var5_26 then
		var6_26 = 115
	end

	if var6_26 ~= arg0_26.contentHeight then
		arg0_26.contentHeight = var6_26

		if LeanTween.isTweening(arg0_26.nodeContainer.gameObject) then
			LeanTween.cancel(arg0_26.nodeContainer.gameObject)
		end

		LeanTween.moveY(rtf(arg0_26.nodeContainer), var6_26, 0.5)
	end
end

function var0_0.updateCurrentChapterMark(arg0_27, arg1_27)
	if arg0_27.currentChapter ~= arg1_27 then
		local var0_27 = arg0_27.progressDict[arg1_27]
		local var1_27 = rtf(arg0_27.progressCurrentMark).rect

		arg0_27.progressCurrentMark.sizeDelta = Vector2(var0_27.w, var1_27.height)

		local var2_27 = arg0_27.progressCurrentMark.anchoredPosition

		var2_27.x = var0_27.x
		arg0_27.progressCurrentMark.anchoredPosition = var2_27
	end

	arg0_27.currentChapter = arg1_27
end

function var0_0.gotoStory(arg0_28)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_28 = arg0_28.nodeDataDict[arg0_28.selectedID].VO
	local var1_28 = var0_28:GetMemoryID()
	local var2_28 = var0_28:GetWorldID()

	if var1_28 ~= "" then
		local var3_28
		local var4_28

		if var1_28[1] == 1 then
			var3_28 = var1_28[2]
		elseif var1_28[1] == 2 then
			var4_28 = var1_28[2][1]

			for iter0_28, iter1_28 in ipairs(pg.memory_group.all) do
				local var5_28 = pg.memory_group[iter1_28]

				if table.contains(var5_28.memories, var4_28) then
					var3_28 = iter1_28

					break
				end
			end
		end

		arg0_28.storyJumpCallback(pg.memory_group[var3_28], var4_28)
	elseif var2_28 ~= "" then
		local var6_28
		local var7_28

		if var2_28[1] == 1 then
			var6_28 = var2_28[2]
		elseif var2_28[1] == 2 then
			var7_28 = var2_28[2][1]

			for iter2_28, iter3_28 in ipairs(pg.world_collection_record_group.all) do
				local var8_28 = pg.world_collection_record_group[iter3_28]

				if table.contains(var8_28.child, var7_28) then
					var6_28 = iter3_28

					break
				end
			end
		end

		arg0_28.recordJumpCallback(var6_28, var7_28, arg0_28.selectedID)
	end
end

function var0_0.updateNodes(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29.nodeDataDict) do
		local var0_29 = iter1_29.nodeTF
		local var1_29 = iter1_29.VO:GetNations()

		if not iter1_29.VO:IsMemoryBlock() then
			local var2_29 = false

			for iter2_29, iter3_29 in pairs(arg0_29.filterDict) do
				if table.contains(var1_29, iter2_29) then
					var2_29 = true

					break
				end
			end

			setActive(var0_29:Find("info/selected_filter"), var2_29)
		end
	end

	if arg0_29.selectedID then
		local var3_29 = arg0_29.nodeDataDict[arg0_29.selectedID]
		local var4_29 = var3_29.nodeTF
		local var5_29 = var3_29.VO:GetNations()
		local var6_29 = false

		for iter4_29, iter5_29 in pairs(arg0_29.filterDict) do
			if table.contains(var5_29, iter4_29) then
				var6_29 = true

				break
			end
		end

		if var6_29 then
			setActive(var4_29:Find("info/selected_multi"), true)
			setActive(var4_29:Find("info/selected"), false)
		else
			setActive(var4_29:Find("info/selected_multi"), false)
			setActive(var4_29:Find("info/selected"), true)
		end

		local var7_29 = arg0_29.detailView:Find("camp/nations")

		eachChild(var7_29, function(arg0_30)
			local var0_30 = tonumber(arg0_30.name)

			setActive(arg0_30, table.contains(var5_29, var0_30))
			setActive(arg0_30:Find("filter"), arg0_29.filterDict[var0_30])
		end)
	end
end

function var0_0.updateNodeTree(arg0_31)
	arg0_31.nodeDataDict = {}
	arg0_31.nodeMap = {}

	local var0_31
	local var1_31
	local var2_31

	for iter0_31, iter1_31 in pairs(arg0_31.memoryNodeDict) do
		for iter2_31, iter3_31 in ipairs(iter1_31) do
			local var3_31 = {}
			local var4_31 = cloneTplTo(arg0_31.nodeTpl, arg0_31.nodeContainer)

			setActive(var4_31, true)

			if iter3_31:IsMemoryBlock() then
				LoadImageSpriteAtlasAsync("ui/worldmediacollectionmemoryui_atlas", "node_tail", var4_31:Find("info/icon"))
				setText(var4_31:Find("info/name"), iter3_31:GetName())
				setActive(var4_31:Find("info/name"), false)
				setActive(var4_31:Find("info/mark"), false)
			else
				LoadImageSpriteAsync("memorystoryline/" .. iter3_31:GetIcon(), var4_31:Find("info/icon"), true)
				setText(var4_31:Find("info/name"), iter3_31:GetName())
				LoadImageSpriteAtlasAsync("ui/worldmediacollectionmemoryui_atlas", iter3_31:GetMark(), var4_31:Find("info/mark"))
				onButton(arg0_31, var4_31, function()
					arg0_31:ShowNodeDetail(iter3_31:GetConfigID())
				end)
			end

			local var5_31 = var0_0.START_GAP + (iter0_31 - 1) * var0_0.HRZ_GAP
			local var6_31 = iter3_31:GetRow()
			local var7_31 = -var6_31 * 254

			var4_31.anchoredPosition = Vector2(var5_31, var7_31)
			var0_31 = var5_31 + var0_0.END_GAP
			var3_31.nodeTF = var4_31
			var3_31.row = var6_31
			var3_31.col = iter0_31
			var3_31.linkData = {}
			var3_31.VO = iter3_31
			arg0_31.nodeMap[iter0_31] = arg0_31.nodeMap[iter0_31] or {}
			arg0_31.nodeMap[iter0_31][var6_31] = true
			arg0_31.nodeDataDict[iter3_31:GetConfigID()] = var3_31
		end
	end

	arg0_31.nodeTail = arg0_31.tf:Find("Story/NodeTail")

	setActive(arg0_31.nodeTail, false)
	arg0_31:sortLinkData()

	local var8_31 = arg0_31.nodeContainer.sizeDelta

	var8_31.x = var0_31
	arg0_31.nodeContainer.sizeDelta = var8_31
	arg0_31.contentWidth = rtf(arg0_31.nodeContainer).rect.width - rtf(arg0_31.scroll).rect.width
end

function var0_0.sortLinkData(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.nodeDataDict) do
		if type(iter1_33.VO:GetLinkEvent()) == "table" then
			for iter2_33, iter3_33 in ipairs(iter1_33.VO:GetLinkEvent()) do
				local var0_33 = arg0_33.nodeDataDict[iter3_33].linkData

				if arg0_33.nodeDataDict[iter3_33].col < iter1_33.col then
					if not table.contains(var0_33, iter0_33) then
						table.insert(var0_33, iter0_33)
					end
				else
					table.insert(iter1_33.linkData, iter3_33)
				end
			end
		end
	end
end

function var0_0.updateNodeLine(arg0_34)
	for iter0_34, iter1_34 in pairs(arg0_34.nodeDataDict) do
		local var0_34 = iter1_34.VO:GetColumn()

		for iter2_34, iter3_34 in ipairs(iter1_34.linkData) do
			local var1_34 = arg0_34.nodeDataDict[iter3_34]

			if var1_34.VO:GetColumn() == var0_34 then
				arg0_34:linkVRTLine(iter1_34, var1_34)
			elseif iter1_34.row == var1_34.row then
				arg0_34:linkHRZLine(iter1_34, var1_34)
			else
				arg0_34:linkBranchLine(iter1_34, var1_34)
			end
		end
	end
end

var0_0.VRT_LINE_POS = Vector2(0, -150)

function var0_0.linkVRTLine(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg1_35.row < arg2_35.row and arg1_35 or arg2_35
	local var1_35

	var1_35 = var0_35 == arg1_35 and arg2_35 or arg1_35

	local var2_35 = tf(Instantiate(arg0_35.linkVrtTpl))

	setActive(var2_35, true)
	var2_35:SetParent(var0_35.nodeTF, false)

	var2_35.anchoredPosition = var0_0.VRT_LINE_POS
end

var0_0.HRZ_LINE_POS = Vector2(185, 0)

function var0_0.linkHRZLine(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg1_36.VO:GetColumn() < arg2_36.VO:GetColumn() and arg1_36 or arg2_36
	local var1_36

	var1_36 = var0_36 == arg1_36 and arg2_36 or arg1_36

	local var2_36 = tf(Instantiate(arg0_36.linkHrzTpl))

	setActive(var2_36, true)
	var2_36:SetParent(var0_36.nodeTF, false)

	var2_36.anchoredPosition = var0_0.HRZ_LINE_POS
end

var0_0.UP_POS = Vector2(-3.5, 100)
var0_0.DOWN_POS = Vector2(0, -105)
var0_0.RIGHT_POS = Vector2(185, 0)

function var0_0.linkBranchLine(arg0_37, arg1_37, arg2_37)
	local var0_37
	local var1_37
	local var2_37
	local var3_37 = arg1_37.VO:GetColumn()
	local var4_37 = arg2_37.VO:GetColumn()
	local var5_37 = arg1_37.row
	local var6_37 = arg2_37.row
	local var7_37 = "Right"
	local var8_37 = var6_37 < var5_37 and "Up" or "Down"

	if not arg0_37.nodeMap[var3_37 + 1][var5_37] then
		var2_37 = var7_37 .. var8_37
		var1_37 = var0_0.RIGHT_POS
	elseif var6_37 < var5_37 and not arg0_37.nodeMap[var3_37][var5_37 - 1] or var5_37 < var6_37 and not arg0_37.nodeMap[var3_37][var5_37 + 1] then
		var2_37 = var8_37 .. var7_37
		var1_37 = var6_37 < var5_37 and var0_0.UP_POS or var0_0.DOWN_POS
	else
		var2_37 = var7_37 .. var8_37 .. "Lite"
		var1_37 = var0_0.RIGHT_POS
	end

	var2_37 = math.abs(var5_37 - var6_37) == 2 and var2_37 .. "Extend" or var2_37

	local var9_37 = Instantiate(arg0_37.tf:Find("Story/" .. var2_37))
	local var10_37 = tf(var9_37)

	setActive(var10_37, true)
	var10_37:SetParent(arg1_37.nodeTF, false)

	var10_37.anchoredPosition = var1_37
end

function var0_0.Dispose(arg0_38)
	pg.DelegateInfo.Dispose(arg0_38)

	if LeanTween.isTweening(arg0_38.nodeContainer.gameObject) then
		LeanTween.cancel(arg0_38.nodeContainer.gameObject)
	end
end

return var0_0
