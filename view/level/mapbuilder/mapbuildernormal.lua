local var0_0 = class("MapBuilderNormal", import(".MapBuilderPermanent"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPENORMAL
end

function var0_0.getUIName(arg0_2)
	return "levels"
end

function var0_0.Load(arg0_3)
	if arg0_3._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_3._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_3 = arg0_3.float:Find("levels").gameObject

	arg0_3:Loaded(var0_3)
	arg0_3:Init()
end

function var0_0.Destroy(arg0_4)
	if arg0_4._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_4:GetLoaded() then
		arg0_4._state = var0_0.STATES.DESTROY

		return
	end

	arg0_4:Hide()
	arg0_4:OnDestroy()
	pg.DelegateInfo.Dispose(arg0_4)

	arg0_4._go = nil

	arg0_4:disposeEvent()
	arg0_4:cleanManagedTween()

	arg0_4._state = var0_0.STATES.DESTROY
end

function var0_0.OnInit(arg0_5)
	arg0_5.chapterTpl = arg0_5._tf:Find("level_tpl")

	setActive(arg0_5.chapterTpl, false)

	arg0_5.storyTpl = arg0_5._tf:Find("story_tpl")

	setActive(arg0_5.storyTpl, false)

	arg0_5.itemHolder = arg0_5._tf:Find("items")
	arg0_5.storyHolder = arg0_5._tf:Find("stories")
	arg0_5.chapterTFsById = {}
	arg0_5.chaptersInBackAnimating = {}
end

function var0_0.OnShow(arg0_6)
	var0_0.super.OnShow(arg0_6)
	setActive(arg0_6.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0_6.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0_6.sceneParent.topChapter:Find("type_chapter"), true)
end

function var0_0.OnHide(arg0_7)
	setActive(arg0_7.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_7.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_7.sceneParent.topChapter:Find("type_chapter"), false)
	table.clear(arg0_7.chaptersInBackAnimating)

	for iter0_7, iter1_7 in pairs(arg0_7.chapterTFsById) do
		local var0_7 = findTF(iter1_7, "main/info/bk")

		LeanTween.cancel(rtf(var0_7))
	end

	var0_0.super.OnHide(arg0_7)
end

function var0_0.UpdateView(arg0_8)
	local var0_8 = string.split(arg0_8.contextData.map:getConfig("name"), "||")

	setText(arg0_8.sceneParent.chapterName, var0_8[1])

	local var1_8 = arg0_8.contextData.map:getMapTitleNumber()

	arg0_8.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_8, arg0_8.sceneParent.chapterNoTitle, true)
	var0_0.super.UpdateView(arg0_8)
end

function var0_0.UpdateMapItems(arg0_9)
	var0_0.super.UpdateMapItems(arg0_9)

	local var0_9 = arg0_9.data
	local var1_9 = var0_9:GetChapterInProgress()

	if var1_9 and isa(var1_9, ChapterStoryGroup) then
		setActive(arg0_9.itemHolder, false)
		setActive(arg0_9.storyHolder, true)
		arg0_9:UpdateStoryGroup()

		return
	end

	setActive(arg0_9.itemHolder, true)
	setActive(arg0_9.storyHolder, false)

	local var2_9 = getProxy(ChapterProxy)
	local var3_9 = {}

	for iter0_9, iter1_9 in pairs(var0_9:getChapters()) do
		if (iter1_9:isUnlock() or iter1_9:activeAlways()) and (not iter1_9:ifNeedHide() or var2_9:GetJustClearChapters(iter1_9.id)) then
			table.insert(var3_9, iter1_9)
		end
	end

	table.clear(arg0_9.chapterTFsById)
	UIItemList.StaticAlign(arg0_9.itemHolder, arg0_9.chapterTpl, #var3_9, function(arg0_10, arg1_10, arg2_10)
		if arg0_10 ~= UIItemList.EventUpdate then
			return
		end

		local var0_10 = var3_9[arg1_10 + 1]

		arg0_9:UpdateMapItem(arg2_10, var0_10)

		arg2_10.name = "Chapter_" .. var0_10.id
		arg0_9.chapterTFsById[var0_10.id] = arg2_10
	end)

	local var4_9 = {}

	for iter2_9, iter3_9 in pairs(var3_9) do
		local var5_9 = iter3_9:getConfigTable()

		var4_9[var5_9.pos_x] = var4_9[var5_9.pos_x] or {}

		local var6_9 = var4_9[var5_9.pos_x]

		var6_9[var5_9.pos_y] = var6_9[var5_9.pos_y] or {}

		local var7_9 = var6_9[var5_9.pos_y]

		table.insert(var7_9, iter3_9)
	end

	for iter4_9, iter5_9 in pairs(var4_9) do
		for iter6_9, iter7_9 in pairs(iter5_9) do
			local var8_9 = {}

			seriesAsync({
				function(arg0_11)
					local var0_11 = 0

					for iter0_11, iter1_11 in pairs(iter7_9) do
						if iter1_11:ifNeedHide() and var2_9:GetJustClearChapters(iter1_11.id) and arg0_9.chapterTFsById[iter1_11.id] then
							var0_11 = var0_11 + 1

							local var1_11 = arg0_9.chapterTFsById[iter1_11.id]

							setActive(var1_11, true)
							arg0_9:PlayChapterItemAnimationBackward(var1_11, iter1_11, function()
								var0_11 = var0_11 - 1

								setActive(var1_11, false)
								var2_9:RecordJustClearChapters(iter1_11.id, nil)

								if var0_11 <= 0 then
									arg0_11()
								end
							end)

							var8_9[iter1_11.id] = true
						elseif arg0_9.chapterTFsById[iter1_11.id] then
							setActive(arg0_9.chapterTFsById[iter1_11.id], false)
						end
					end

					if var0_11 <= 0 then
						arg0_11()
					end
				end,
				function(arg0_13)
					local var0_13 = 0

					for iter0_13, iter1_13 in pairs(iter7_9) do
						if not var8_9[iter1_13.id] then
							var0_13 = var0_13 + 1

							setActive(arg0_9.chapterTFsById[iter1_13.id], true)
							arg0_9:PlayChapterItemAnimation(arg0_9.chapterTFsById[iter1_13.id], iter1_13, function()
								var0_13 = var0_13 - 1

								if var0_13 <= 0 then
									arg0_13()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var0_0.UpdateMapItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg2_15:getConfigTable()

	setAnchoredPosition(arg1_15, {
		x = arg0_15.mapWidth * var0_15.pos_x,
		y = arg0_15.mapHeight * var0_15.pos_y
	})

	local var1_15 = findTF(arg1_15, "main")

	setActive(var1_15, true)

	local var2_15 = findTF(var1_15, "circle/fordark")
	local var3_15 = findTF(var1_15, "info/bk/fordark")

	setActive(var2_15, var0_15.icon_outline == 1)
	setActive(var3_15, var0_15.icon_outline == 1)

	local var4_15 = findTF(var1_15, "circle/clear_flag")
	local var5_15 = findTF(var1_15, "circle/progress")
	local var6_15 = findTF(var1_15, "circle/progress_text")
	local var7_15 = findTF(var1_15, "circle/stars")
	local var8_15 = string.split(var0_15.name, "|")

	setText(findTF(var1_15, "info/bk/title_form/title_index"), var0_15.chapter_name .. "  ")
	setText(findTF(var1_15, "info/bk/title_form/title"), var8_15[1])
	setText(findTF(var1_15, "info/bk/title_form/title_en"), var8_15[2] or "")
	setFillAmount(var5_15, arg2_15.progress / 100)
	setText(var6_15, string.format("%d%%", arg2_15.progress))
	setActive(var7_15, arg2_15:existAchieve())

	if arg2_15:existAchieve() then
		for iter0_15, iter1_15 in ipairs(arg2_15.achieves) do
			local var9_15 = ChapterConst.IsAchieved(iter1_15)
			local var10_15 = var7_15:Find("star" .. iter0_15 .. "/light")

			setActive(var10_15, var9_15)
		end
	end

	local var11_15 = not arg2_15.active and arg2_15:isClear()

	setActive(var4_15, var11_15)
	setActive(var6_15, not var11_15)
	arg0_15:DeleteTween("fighting" .. arg2_15.id)

	local var12_15 = findTF(var1_15, "circle/fighting")

	setText(findTF(var12_15, "Text"), i18n("tag_level_fighting"))

	local var13_15 = findTF(var1_15, "circle/oni")

	setText(findTF(var13_15, "Text"), i18n("tag_level_oni"))

	local var14_15 = findTF(var1_15, "circle/narrative")

	setText(findTF(var14_15, "Text"), i18n("tag_level_narrative"))
	setActive(var12_15, false)
	setActive(var13_15, false)
	setActive(var14_15, false)

	local var15_15
	local var16_15

	if arg2_15:getConfig("chapter_tag") == 1 then
		var15_15 = var14_15
	end

	if arg2_15.active then
		var15_15 = arg2_15:existOni() and var13_15 or var12_15
	end

	if var15_15 then
		setActive(var15_15, true)

		local var17_15 = GetOrAddComponent(var15_15, "CanvasGroup")

		var17_15.alpha = 1

		arg0_15:RecordTween("fighting" .. arg2_15.id, LeanTween.alphaCanvas(var17_15, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var18_15 = findTF(var1_15, "triesLimit")

	setActive(var18_15, false)

	if arg2_15:isTriesLimit() then
		local var19_15 = arg2_15:getConfig("count")
		local var20_15 = var19_15 - arg2_15:getTodayDefeatCount() .. "/" .. var19_15

		setText(var18_15:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var18_15:Find("Text"), setColorStr(var20_15, var19_15 <= arg2_15:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var21_15 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var18_15:Find("TipRect"), var21_15)
	end

	local var22_15 = arg2_15:GetDailyBonusQuota()
	local var23_15 = findTF(var1_15, "mark")

	setActive(var23_15:Find("bonus"), var22_15)
	setActive(var23_15, var22_15)

	if var22_15 then
		local var24_15 = var23_15:GetComponent(typeof(CanvasGroup))
		local var25_15 = arg0_15.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_15.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var25_15, var23_15:Find("bonus"))
		LeanTween.cancel(go(var23_15), true)

		local var26_15 = var23_15.anchoredPosition.y

		var24_15.alpha = 0

		LeanTween.value(go(var23_15), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_16)
			var24_15.alpha = arg0_16

			local var0_16 = var23_15.anchoredPosition

			var0_16.y = var26_15 * arg0_16
			var23_15.anchoredPosition = var0_16
		end)):setOnComplete(System.Action(function()
			var24_15.alpha = 1

			local var0_17 = var23_15.anchoredPosition

			var0_17.y = var26_15
			var23_15.anchoredPosition = var0_17
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var27_15 = arg2_15.id

	onButton(arg0_15, var1_15, function()
		if arg0_15.chaptersInBackAnimating[var27_15] then
			return
		end

		local var0_18 = arg1_15.localPosition

		arg0_15:TryOpenChapterInfo(var27_15, Vector3(var0_18.x - 10, var0_18.y + 150))
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.PlayChapterItemAnimation(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = findTF(arg1_19, "main")
	local var1_19 = var0_19:Find("info")
	local var2_19 = findTF(var0_19, "circle")
	local var3_19 = findTF(var0_19, "info/bk")

	LeanTween.cancel(go(var2_19))

	var2_19.localScale = Vector3.zero

	local var4_19 = LeanTween.scale(var2_19, Vector3.one, 0.3):setDelay(0.3)

	arg0_19:RecordTween(var4_19.uniqueId)
	LeanTween.cancel(go(var3_19))
	setAnchoredPosition(var3_19, {
		x = -1 * var1_19.rect.width
	})
	shiftPanel(var3_19, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_19:isTriesLimit() then
			setActive(findTF(var0_19, "triesLimit"), true)
		end

		if arg3_19 then
			arg3_19()
		end
	end)
end

function var0_0.PlayChapterItemAnimationBackward(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = findTF(arg1_21, "main")
	local var1_21 = var0_21:Find("info")
	local var2_21 = findTF(var0_21, "circle")
	local var3_21 = findTF(var0_21, "info/bk")

	LeanTween.cancel(go(var2_21))

	var2_21.localScale = Vector3.one

	local var4_21 = LeanTween.scale(go(var2_21), Vector3.zero, 0.3):setDelay(0.3)

	arg0_21:RecordTween(var4_21.uniqueId)

	arg0_21.chaptersInBackAnimating[arg2_21.id] = true

	LeanTween.cancel(go(var3_21))
	setAnchoredPosition(var3_21, {
		x = 0
	})
	shiftPanel(var3_21, -1 * var1_21.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_21.chaptersInBackAnimating[arg2_21.id] = nil

		if arg3_21 then
			arg3_21()
		end
	end)

	if arg2_21:isTriesLimit() then
		setActive(findTF(var0_21, "triesLimit"), false)
	end
end

function var0_0.UpdateChapterTF(arg0_23, arg1_23)
	local var0_23 = arg0_23.chapterTFsById[arg1_23]

	if var0_23 then
		local var1_23 = getProxy(ChapterProxy):getChapterById(arg1_23)

		arg0_23:UpdateMapItem(var0_23, var1_23)
		arg0_23:PlayChapterItemAnimation(var0_23, var1_23)
	end
end

function var0_0.TryOpenChapter(arg0_24, arg1_24)
	local var0_24 = arg0_24.chapterTFsById[arg1_24]

	if var0_24 then
		local var1_24 = var0_24:Find("main")

		triggerButton(var1_24)
	end
end

function var0_0.UpdateStoryGroup(arg0_25)
	local var0_25 = arg0_25.data:GetChapterInProgress():GetChapterStories()

	UIItemList.StaticAlign(arg0_25.storyHolder, arg0_25.storyTpl, #var0_25, function(arg0_26, arg1_26, arg2_26)
		if arg0_26 ~= UIItemList.EventUpdate then
			return
		end

		local var0_26 = var0_25[arg1_26 + 1]

		arg0_25:UpdateMapStory(arg2_26, var0_26)

		arg2_26.name = "Chapter_" .. var0_26:GetName()
	end)
end

function var0_0.UpdateMapStory(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg2_27:GetPosition()

	setAnchoredPosition(arg1_27, {
		x = arg0_27.mapWidth * var0_27[1],
		y = arg0_27.mapHeight * var0_27[2]
	})
	setText(arg1_27:Find("Name"), arg2_27:GetName())

	local var1_27, var2_27 = arg2_27:GetIcon()

	arg0_27.sceneParent.loader:GetSpriteQuiet(var1_27, var2_27, arg1_27:Find("Icon"), true)

	local var3_27 = arg2_27:GetStoryName()

	onButton(arg0_27, arg1_27, function()
		pg.NewStoryMgr.GetInstance():Play(var3_27, function()
			arg0_27.sceneParent:RefreshMapBG()
			arg0_27:UpdateMapItems()
		end)
	end, SFX_PANEL)
	setActive(arg1_27, not pg.NewStoryMgr.GetInstance():IsPlayed(var3_27))
end

function var0_0.HideFloat(arg0_30)
	setActive(arg0_30.itemHolder, false)
	setActive(arg0_30.storyHolder, false)
end

function var0_0.ShowFloat(arg0_31)
	setActive(arg0_31.itemHolder, true)
	setActive(arg0_31.storyHolder, true)
end

return var0_0
