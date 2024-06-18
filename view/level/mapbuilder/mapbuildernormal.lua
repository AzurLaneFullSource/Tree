local var0_0 = import(".MapBuilder")
local var1_0 = class("MapBuilderNormal", var0_0)

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)

	arg0_1.mapItemTimer = {}
	arg0_1.chapterTFsById = {}
	arg0_1.chaptersInBackAnimating = {}
end

function var1_0.GetType(arg0_2)
	return var0_0.TYPENORMAL
end

function var1_0.getUIName(arg0_3)
	return "levels"
end

function var1_0.Load(arg0_4)
	if arg0_4._state ~= var1_0.STATES.NONE then
		return
	end

	arg0_4._state = var1_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync({
		function(arg0_5)
			arg0_4:preload(arg0_5)
		end,
		function(arg0_6)
			local var0_6 = arg0_4.float:Find("levels").gameObject

			arg0_4:Loaded(var0_6)
			arg0_4:Init()
		end
	})
end

function var1_0.Destroy(arg0_7)
	if arg0_7._state == var1_0.STATES.DESTROY then
		return
	end

	if not arg0_7:GetLoaded() then
		arg0_7._state = var1_0.STATES.DESTROY

		return
	end

	arg0_7:Hide()
	arg0_7:OnDestroy()
	pg.DelegateInfo.Dispose(arg0_7)

	arg0_7._go = nil

	arg0_7:disposeEvent()
	arg0_7:cleanManagedTween()

	arg0_7._state = var1_0.STATES.DESTROY
end

function var1_0.OnInit(arg0_8)
	arg0_8.chapterTpl = arg0_8._tf:Find("level_tpl")

	setActive(arg0_8.chapterTpl, false)

	arg0_8.storyTpl = arg0_8._tf:Find("story_tpl")

	setActive(arg0_8.storyTpl, false)

	arg0_8.itemHolder = arg0_8._tf:Find("items")
	arg0_8.storyHolder = arg0_8._tf:Find("stories")
end

function var1_0.OnShow(arg0_9)
	setActive(arg0_9.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0_9.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0_9.sceneParent.topChapter:Find("type_chapter"), true)
end

function var1_0.OnHide(arg0_10)
	setActive(arg0_10.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_10.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_10.sceneParent.topChapter:Find("type_chapter"), false)
	table.clear(arg0_10.chaptersInBackAnimating)
	arg0_10:StopMapItemTimers()

	for iter0_10, iter1_10 in pairs(arg0_10.chapterTFsById) do
		local var0_10 = findTF(iter1_10, "main/info/bk")

		LeanTween.cancel(rtf(var0_10))
	end

	var1_0.super.OnHide(arg0_10)
end

function var1_0.OnDestroy(arg0_11)
	arg0_11.mapItemTimer = nil

	var1_0.super.OnDestroy(arg0_11)
end

function var1_0.StartTimer(arg0_12, arg1_12, arg2_12, arg3_12)
	if not arg0_12.mapItemTimer[arg1_12] then
		arg0_12.mapItemTimer[arg1_12] = Timer.New(arg2_12, arg3_12)
	else
		arg0_12.mapItemTimer[arg1_12]:Reset(arg2_12, arg3_12)
	end

	arg0_12.mapItemTimer[arg1_12]:Start()
end

function var1_0.StopMapItemTimers(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.mapItemTimer) do
		iter1_13:Stop()
	end

	table.clear(arg0_13.mapItemTimer)
end

function var1_0.Update(arg0_14, arg1_14)
	arg0_14.float.pivot = Vector2(0.5, 0.5)
	arg0_14.float.anchoredPosition = Vector2(0, 0)

	local var0_14 = string.split(arg1_14:getConfig("name"), "||")

	setText(arg0_14.sceneParent.chapterName, var0_14[1])

	local var1_14 = arg1_14:getMapTitleNumber()

	arg0_14.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_14, arg0_14.sceneParent.chapterNoTitle, true)
	var1_0.super.Update(arg0_14, arg1_14)
end

function var1_0.UpdateButtons(arg0_15)
	arg0_15.sceneParent:updateDifficultyBtns()
	arg0_15.sceneParent:updateActivityBtns()
end

function var1_0.UpdateMapItems(arg0_16)
	if not arg0_16:isShowing() then
		return
	end

	var1_0.super.UpdateMapItems(arg0_16)
	arg0_16:StopMapItemTimers()

	local var0_16 = arg0_16.data
	local var1_16 = var0_16:GetChapterInProgress()

	if var1_16 and isa(var1_16, ChapterStoryGroup) then
		setActive(arg0_16.itemHolder, false)
		setActive(arg0_16.storyHolder, true)
		arg0_16:UpdateStoryGroup()

		return
	end

	setActive(arg0_16.itemHolder, true)
	setActive(arg0_16.storyHolder, false)

	local var2_16 = getProxy(ChapterProxy)
	local var3_16 = {}

	for iter0_16, iter1_16 in pairs(var0_16:getChapters()) do
		if (iter1_16:isUnlock() or iter1_16:activeAlways()) and (not iter1_16:ifNeedHide() or var2_16:GetJustClearChapters(iter1_16.id)) then
			table.insert(var3_16, iter1_16)
		end
	end

	table.clear(arg0_16.chapterTFsById)
	UIItemList.StaticAlign(arg0_16.itemHolder, arg0_16.chapterTpl, #var3_16, function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = var3_16[arg1_17 + 1]

			arg0_16:UpdateMapItem(arg2_17, var0_17)

			arg2_17.name = "Chapter_" .. var0_17.id
			arg0_16.chapterTFsById[var0_17.id] = arg2_17
		end
	end)

	local var4_16 = {}

	for iter2_16, iter3_16 in pairs(var3_16) do
		local var5_16 = iter3_16:getConfigTable()

		var4_16[var5_16.pos_x] = var4_16[var5_16.pos_x] or {}

		local var6_16 = var4_16[var5_16.pos_x]

		var6_16[var5_16.pos_y] = var6_16[var5_16.pos_y] or {}

		local var7_16 = var6_16[var5_16.pos_y]

		table.insert(var7_16, iter3_16)
	end

	for iter4_16, iter5_16 in pairs(var4_16) do
		for iter6_16, iter7_16 in pairs(iter5_16) do
			local var8_16 = {}

			seriesAsync({
				function(arg0_18)
					local var0_18 = 0

					for iter0_18, iter1_18 in pairs(iter7_16) do
						if iter1_18:ifNeedHide() and var2_16:GetJustClearChapters(iter1_18.id) and arg0_16.chapterTFsById[iter1_18.id] then
							var0_18 = var0_18 + 1

							local var1_18 = arg0_16.chapterTFsById[iter1_18.id]

							setActive(var1_18, true)
							arg0_16:PlayChapterItemAnimationBackward(var1_18, iter1_18, function()
								var0_18 = var0_18 - 1

								setActive(var1_18, false)
								var2_16:RecordJustClearChapters(iter1_18.id, nil)

								if var0_18 <= 0 then
									arg0_18()
								end
							end)

							var8_16[iter1_18.id] = true
						elseif arg0_16.chapterTFsById[iter1_18.id] then
							setActive(arg0_16.chapterTFsById[iter1_18.id], false)
						end
					end

					if var0_18 <= 0 then
						arg0_18()
					end
				end,
				function(arg0_20)
					local var0_20 = 0

					for iter0_20, iter1_20 in pairs(iter7_16) do
						if not var8_16[iter1_20.id] then
							var0_20 = var0_20 + 1

							setActive(arg0_16.chapterTFsById[iter1_20.id], true)
							arg0_16:PlayChapterItemAnimation(arg0_16.chapterTFsById[iter1_20.id], iter1_20, function()
								var0_20 = var0_20 - 1

								if var0_20 <= 0 then
									arg0_20()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var1_0.UpdateMapItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg2_22:getConfigTable()

	setAnchoredPosition(arg1_22, {
		x = arg0_22.mapWidth * var0_22.pos_x,
		y = arg0_22.mapHeight * var0_22.pos_y
	})

	local var1_22 = findTF(arg1_22, "main")

	setActive(var1_22, true)

	local var2_22 = findTF(var1_22, "circle/fordark")
	local var3_22 = findTF(var1_22, "info/bk/fordark")

	setActive(var2_22, var0_22.icon_outline == 1)
	setActive(var3_22, var0_22.icon_outline == 1)

	local var4_22 = findTF(var1_22, "circle/clear_flag")
	local var5_22 = findTF(var1_22, "circle/progress")
	local var6_22 = findTF(var1_22, "circle/progress_text")
	local var7_22 = findTF(var1_22, "circle/stars")
	local var8_22 = string.split(var0_22.name, "|")

	setText(findTF(var1_22, "info/bk/title_form/title_index"), var0_22.chapter_name .. "  ")
	setText(findTF(var1_22, "info/bk/title_form/title"), var8_22[1])
	setText(findTF(var1_22, "info/bk/title_form/title_en"), var8_22[2] or "")
	setFillAmount(var5_22, arg2_22.progress / 100)
	setText(var6_22, string.format("%d%%", arg2_22.progress))
	setActive(var7_22, arg2_22:existAchieve())

	if arg2_22:existAchieve() then
		for iter0_22, iter1_22 in ipairs(arg2_22.achieves) do
			local var9_22 = ChapterConst.IsAchieved(iter1_22)
			local var10_22 = var7_22:Find("star" .. iter0_22 .. "/light")

			setActive(var10_22, var9_22)
		end
	end

	local var11_22 = not arg2_22.active and arg2_22:isClear()

	setActive(var4_22, var11_22)
	setActive(var6_22, not var11_22)
	arg0_22:DeleteTween("fighting" .. arg2_22.id)

	local var12_22 = findTF(var1_22, "circle/fighting")

	setText(findTF(var12_22, "Text"), i18n("tag_level_fighting"))

	local var13_22 = findTF(var1_22, "circle/oni")

	setText(findTF(var13_22, "Text"), i18n("tag_level_oni"))

	local var14_22 = findTF(var1_22, "circle/narrative")

	setText(findTF(var14_22, "Text"), i18n("tag_level_narrative"))
	setActive(var12_22, false)
	setActive(var13_22, false)
	setActive(var14_22, false)

	local var15_22
	local var16_22

	if arg2_22:getConfig("chapter_tag") == 1 then
		var15_22 = var14_22
	end

	if arg2_22.active then
		var15_22 = arg2_22:existOni() and var13_22 or var12_22
	end

	if var15_22 then
		setActive(var15_22, true)

		local var17_22 = GetOrAddComponent(var15_22, "CanvasGroup")

		var17_22.alpha = 1

		arg0_22:RecordTween("fighting" .. arg2_22.id, LeanTween.alphaCanvas(var17_22, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var18_22 = findTF(var1_22, "triesLimit")

	setActive(var18_22, false)

	if arg2_22:isTriesLimit() then
		local var19_22 = arg2_22:getConfig("count")
		local var20_22 = var19_22 - arg2_22:getTodayDefeatCount() .. "/" .. var19_22

		setText(var18_22:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var18_22:Find("Text"), setColorStr(var20_22, var19_22 <= arg2_22:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var21_22 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var18_22:Find("TipRect"), var21_22)
	end

	local var22_22 = arg2_22:GetDailyBonusQuota()
	local var23_22 = findTF(var1_22, "mark")

	setActive(var23_22:Find("bonus"), var22_22)
	setActive(var23_22, var22_22)

	if var22_22 then
		local var24_22 = var23_22:GetComponent(typeof(CanvasGroup))
		local var25_22 = arg0_22.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_22.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var25_22, var23_22:Find("bonus"))
		LeanTween.cancel(go(var23_22), true)

		local var26_22 = var23_22.anchoredPosition.y

		var24_22.alpha = 0

		LeanTween.value(go(var23_22), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_23)
			var24_22.alpha = arg0_23

			local var0_23 = var23_22.anchoredPosition

			var0_23.y = var26_22 * arg0_23
			var23_22.anchoredPosition = var0_23
		end)):setOnComplete(System.Action(function()
			var24_22.alpha = 1

			local var0_24 = var23_22.anchoredPosition

			var0_24.y = var26_22
			var23_22.anchoredPosition = var0_24
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var27_22 = arg2_22.id

	onButton(arg0_22.sceneParent, var1_22, function()
		if arg0_22:InvokeParent("isfrozen") then
			return
		end

		if arg0_22.chaptersInBackAnimating[var27_22] then
			return
		end

		local var0_25 = getProxy(ChapterProxy):getChapterById(var27_22)

		if not var0_25:isUnlock() then
			local var1_25 = var0_25:getPrevChapterName()

			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre", var1_25))

			return
		end

		local var2_25 = var0_25:getConfig("unlocklevel")

		if var2_25 > arg0_22.sceneParent.player.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", var2_25))

			return
		end

		local var3_25 = getProxy(ChapterProxy):getActiveChapter(true)

		if var3_25 and var3_25.id ~= var27_22 then
			arg0_22:InvokeParent("emit", LevelMediator2.ON_STRATEGYING_CHAPTER)

			return
		end

		if var0_25.active then
			arg0_22:InvokeParent("switchToChapter", var0_25)
		else
			if arg0_22.sceneParent.contextData.map:getConfig("type") == Map.ACT_EXTRA and var0_25:getPlayType() == ChapterConst.TypeRange then
				SettingsProxy.SetActivityMapSPTip()
				arg0_22:UpdateChapterTF(var27_22)
			end

			local var4_25 = arg1_22.localPosition

			arg0_22:InvokeParent("displayChapterPanel", var0_25, Vector3(var4_25.x - 10, var4_25.y + 150))
		end
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var1_0.PlayChapterItemAnimation(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = findTF(arg1_26, "main")
	local var1_26 = var0_26:Find("info")
	local var2_26 = findTF(var0_26, "circle")
	local var3_26 = findTF(var0_26, "info/bk")

	LeanTween.cancel(go(var2_26))

	var2_26.localScale = Vector3.zero

	local var4_26 = LeanTween.scale(var2_26, Vector3.one, 0.3):setDelay(0.3)

	arg0_26:RecordTween(var4_26.uniqueId)
	LeanTween.cancel(go(var3_26))
	setAnchoredPosition(var3_26, {
		x = -1 * var1_26.rect.width
	})
	shiftPanel(var3_26, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_26:isTriesLimit() then
			setActive(findTF(var0_26, "triesLimit"), true)
		end

		if arg3_26 then
			arg3_26()
		end
	end)
end

function var1_0.PlayChapterItemAnimationBackward(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = findTF(arg1_28, "main")
	local var1_28 = var0_28:Find("info")
	local var2_28 = findTF(var0_28, "circle")
	local var3_28 = findTF(var0_28, "info/bk")

	LeanTween.cancel(go(var2_28))

	var2_28.localScale = Vector3.one

	local var4_28 = LeanTween.scale(go(var2_28), Vector3.zero, 0.3):setDelay(0.3)

	arg0_28:RecordTween(var4_28.uniqueId)

	arg0_28.chaptersInBackAnimating[arg2_28.id] = true

	LeanTween.cancel(go(var3_28))
	setAnchoredPosition(var3_28, {
		x = 0
	})
	shiftPanel(var3_28, -1 * var1_28.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_28.chaptersInBackAnimating[arg2_28.id] = nil

		if arg3_28 then
			arg3_28()
		end
	end)

	if arg2_28:isTriesLimit() then
		setActive(findTF(var0_28, "triesLimit"), false)
	end
end

function var1_0.UpdateChapterTF(arg0_30, arg1_30)
	local var0_30 = arg0_30.chapterTFsById[arg1_30]

	if var0_30 then
		local var1_30 = getProxy(ChapterProxy):getChapterById(arg1_30)

		arg0_30:UpdateMapItem(var0_30, var1_30)
		arg0_30:PlayChapterItemAnimation(var0_30, var1_30)
	end
end

function var1_0.AddChapterTF(arg0_31, arg1_31)
	local var0_31 = arg0_31.data

	if arg0_31.chapterTFsById[arg1_31] then
		arg0_31:UpdateChapterTF(arg1_31)
	elseif _.contains(var0_31:GetChapterList(), function(arg0_32)
		if arg0_32 ~= arg1_31 then
			return false
		end

		local var0_32 = getProxy(ChapterProxy):getChapterById(arg1_31, true)

		return (var0_32:isUnlock() or var0_32:activeAlways()) and not var0_32:ifNeedHide()
	end) then
		local var1_31 = getProxy(ChapterProxy):getChapterById(arg1_31, true)
		local var2_31 = cloneTplTo(arg0_31.chapterTpl, arg0_31.itemHolder, "Chapter_" .. var1_31.id)

		arg0_31:UpdateMapItem(var2_31, var1_31)

		arg0_31.chapterTFsById[var1_31.id] = var2_31

		arg0_31:PlayChapterItemAnimation(var2_31)
	end
end

function var1_0.TryOpenChapter(arg0_33, arg1_33)
	local var0_33 = arg0_33.chapterTFsById[arg1_33]

	if var0_33 then
		local var1_33 = var0_33:Find("main")

		triggerButton(var1_33)
	end
end

function var1_0.UpdateStoryGroup(arg0_34)
	local var0_34 = arg0_34.data:GetChapterInProgress():GetChapterStories()

	UIItemList.StaticAlign(arg0_34.storyHolder, arg0_34.storyTpl, #var0_34, function(arg0_35, arg1_35, arg2_35)
		if arg0_35 ~= UIItemList.EventUpdate then
			return
		end

		local var0_35 = var0_34[arg1_35 + 1]

		arg0_34:UpdateMapStory(arg2_35, var0_35)

		arg2_35.name = "Chapter_" .. var0_35:GetName()
	end)
end

function var1_0.UpdateMapStory(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg2_36:GetPosition()

	setAnchoredPosition(arg1_36, {
		x = arg0_36.mapWidth * var0_36[1],
		y = arg0_36.mapHeight * var0_36[2]
	})
	setText(arg1_36:Find("Name"), arg2_36:GetName())

	local var1_36, var2_36 = arg2_36:GetIcon()

	arg0_36.sceneParent.loader:GetSpriteQuiet(var1_36, var2_36, arg1_36:Find("Icon"), true)

	local var3_36 = arg2_36:GetStoryName()

	onButton(arg0_36, arg1_36, function()
		pg.NewStoryMgr.GetInstance():Play(var3_36, function()
			arg0_36.sceneParent:RefreshMapBG()
			arg0_36:UpdateMapItems()
		end)
	end, SFX_PANEL)
	setActive(arg1_36, not pg.NewStoryMgr.GetInstance():IsPlayed(var3_36))
end

return var1_0
