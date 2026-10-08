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

function var0_0.UpdateBonusPtIconPath(arg0_9)
	arg0_9.bonusPtIconPath = nil

	local var0_9 = arg0_9.data or arg0_9.contextData.map

	if not var0_9 then
		return
	end

	local var1_9 = var0_9:getConfig("on_activity")

	if not var1_9 or var1_9 == 0 then
		return
	end

	local var2_9 = getProxy(ActivityProxy):getActivityById(var1_9)

	if not var2_9 or var2_9:isEnd() then
		return
	end

	local var3_9 = var2_9:GetConfigClientPTActivity()

	if not var3_9 then
		return
	end

	arg0_9.bonusPtIconPath = var3_9:GetPTDrop():getIcon()
end

function var0_0.UpdateMapItems(arg0_10)
	var0_0.super.UpdateMapItems(arg0_10)

	local var0_10 = arg0_10.data
	local var1_10 = var0_10:GetChapterInProgress()

	if var1_10 and isa(var1_10, ChapterStoryGroup) then
		setActive(arg0_10.itemHolder, false)
		setActive(arg0_10.storyHolder, true)
		arg0_10:UpdateStoryGroup()

		return
	end

	setActive(arg0_10.itemHolder, true)
	setActive(arg0_10.storyHolder, false)
	arg0_10:UpdateBonusPtIconPath()

	local var2_10 = getProxy(ChapterProxy)
	local var3_10 = {}

	for iter0_10, iter1_10 in pairs(var0_10:getChapters()) do
		if (iter1_10:isUnlock() or iter1_10:activeAlways()) and (not iter1_10:ifNeedHide() or var2_10:GetJustClearChapters(iter1_10.id)) then
			table.insert(var3_10, iter1_10)
		end
	end

	table.clear(arg0_10.chapterTFsById)
	UIItemList.StaticAlign(arg0_10.itemHolder, arg0_10.chapterTpl, #var3_10, function(arg0_11, arg1_11, arg2_11)
		if arg0_11 ~= UIItemList.EventUpdate then
			return
		end

		local var0_11 = var3_10[arg1_11 + 1]

		arg0_10:UpdateMapItem(arg2_11, var0_11)

		arg2_11.name = "Chapter_" .. var0_11.id
		arg0_10.chapterTFsById[var0_11.id] = arg2_11
	end)

	local var4_10 = {}

	for iter2_10, iter3_10 in pairs(var3_10) do
		local var5_10 = iter3_10:getConfigTable()

		var4_10[var5_10.pos_x] = var4_10[var5_10.pos_x] or {}

		local var6_10 = var4_10[var5_10.pos_x]

		var6_10[var5_10.pos_y] = var6_10[var5_10.pos_y] or {}

		local var7_10 = var6_10[var5_10.pos_y]

		table.insert(var7_10, iter3_10)
	end

	for iter4_10, iter5_10 in pairs(var4_10) do
		for iter6_10, iter7_10 in pairs(iter5_10) do
			local var8_10 = {}

			seriesAsync({
				function(arg0_12)
					local var0_12 = 0

					for iter0_12, iter1_12 in pairs(iter7_10) do
						if iter1_12:ifNeedHide() and var2_10:GetJustClearChapters(iter1_12.id) and arg0_10.chapterTFsById[iter1_12.id] then
							var0_12 = var0_12 + 1

							local var1_12 = arg0_10.chapterTFsById[iter1_12.id]

							setActive(var1_12, true)
							arg0_10:PlayChapterItemAnimationBackward(var1_12, iter1_12, function()
								var0_12 = var0_12 - 1

								setActive(var1_12, false)
								var2_10:RecordJustClearChapters(iter1_12.id, nil)

								if var0_12 <= 0 then
									arg0_12()
								end
							end)

							var8_10[iter1_12.id] = true
						elseif arg0_10.chapterTFsById[iter1_12.id] then
							setActive(arg0_10.chapterTFsById[iter1_12.id], false)
						end
					end

					if var0_12 <= 0 then
						arg0_12()
					end
				end,
				function(arg0_14)
					local var0_14 = 0

					for iter0_14, iter1_14 in pairs(iter7_10) do
						if not var8_10[iter1_14.id] then
							var0_14 = var0_14 + 1

							setActive(arg0_10.chapterTFsById[iter1_14.id], true)
							arg0_10:PlayChapterItemAnimation(arg0_10.chapterTFsById[iter1_14.id], iter1_14, function()
								var0_14 = var0_14 - 1

								if var0_14 <= 0 then
									arg0_14()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var0_0.UpdateMapItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg2_16:getConfigTable()

	setLocalPosition(arg1_16, {
		x = 1920 * var0_16.pos_x,
		y = 1080 * var0_16.pos_y
	})

	local var1_16 = findTF(arg1_16, "main")

	setActive(var1_16, true)

	local var2_16 = findTF(var1_16, "circle/fordark")
	local var3_16 = findTF(var1_16, "info/bk/fordark")

	setActive(var2_16, var0_16.icon_outline == 1)
	setActive(var3_16, var0_16.icon_outline == 1)

	local var4_16 = findTF(var1_16, "circle/clear_flag")
	local var5_16 = findTF(var1_16, "circle/progress")
	local var6_16 = findTF(var1_16, "circle/progress_text")
	local var7_16 = findTF(var1_16, "circle/stars")
	local var8_16 = string.split(var0_16.name, "|")

	setText(findTF(var1_16, "info/bk/title_form/title_index"), var0_16.chapter_name .. "  ")
	setText(findTF(var1_16, "info/bk/title_form/title"), var8_16[1])
	setText(findTF(var1_16, "info/bk/title_form/title_en"), var8_16[2] or "")
	setFillAmount(var5_16, arg2_16.progress / 100)
	setText(var6_16, string.format("%d%%", arg2_16.progress))
	setActive(var7_16, arg2_16:existAchieve())

	if arg2_16:existAchieve() then
		for iter0_16, iter1_16 in ipairs(arg2_16.achieves) do
			local var9_16 = ChapterConst.IsAchieved(iter1_16)
			local var10_16 = var7_16:Find("star" .. iter0_16 .. "/light")

			setActive(var10_16, var9_16)
		end
	end

	local var11_16 = not arg2_16.active and arg2_16:isClear()

	setActive(var4_16, var11_16)
	setActive(var6_16, not var11_16)
	arg0_16:DeleteTween("fighting" .. arg2_16.id)

	local var12_16 = findTF(var1_16, "circle/fighting")

	setText(findTF(var12_16, "Text"), i18n("tag_level_fighting"))

	local var13_16 = findTF(var1_16, "circle/oni")

	setText(findTF(var13_16, "Text"), i18n("tag_level_oni"))

	local var14_16 = findTF(var1_16, "circle/narrative")

	setText(findTF(var14_16, "Text"), i18n("tag_level_narrative"))

	local var15_16 = findTF(var1_16, "circle/auto")

	setText(findTF(var15_16, "Text"), i18n("tag_level_autoing"))
	setActive(var12_16, false)
	setActive(var13_16, false)
	setActive(var14_16, false)
	setActive(var15_16, false)

	local var16_16
	local var17_16

	if arg2_16:getConfig("chapter_tag") == 1 then
		var16_16 = var14_16
	end

	if arg2_16.active then
		var16_16 = arg2_16:existOni() and var13_16 or var12_16
	end

	local var18_16 = getProxy(ChapterProxy):GetAutoChapterId()

	if var18_16 and var18_16 == arg2_16.id then
		var16_16 = var15_16

		local var19_16, var20_16 = getProxy(ChapterAutoProxy):GetCntInfo()

		setText(findTF(var15_16, "Text"), var19_16 < var20_16 and i18n("tag_level_autoing") or i18n("tag_level_auto_finish"))
	end

	if var16_16 then
		setActive(var16_16, true)

		local var21_16 = GetOrAddComponent(var16_16, "CanvasGroup")

		var21_16.alpha = 1

		arg0_16:RecordTween("fighting" .. arg2_16.id, LeanTween.alphaCanvas(var21_16, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var22_16 = findTF(var1_16, "triesLimit")

	setActive(var22_16, false)

	if arg2_16:isTriesLimit() then
		local var23_16 = arg2_16:getConfig("count")
		local var24_16 = var23_16 - arg2_16:getTodayDefeatCount() .. "/" .. var23_16

		setText(var22_16:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var22_16:Find("Text"), setColorStr(var24_16, var23_16 <= arg2_16:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var25_16 = pg.expedition_data_by_map[arg2_16:getConfig("map")].on_activity
		local var26_16 = getProxy(ChapterProxy):IsActivitySPChapterActive(var25_16) and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var22_16:Find("TipRect"), var26_16)
	end

	local var27_16 = arg2_16:GetDailyBonusQuota()
	local var28_16 = findTF(var1_16, "mark")
	local var29_16 = var28_16:Find("bonus")
	local var30_16 = var29_16:Find("icon")
	local var31_16 = findTF(var29_16, "icon/Image")

	setActive(var29_16, var27_16)
	setActive(var28_16, var27_16)

	if var30_16 then
		setActive(var30_16, var27_16 and arg0_16.bonusPtIconPath)
	end

	if var27_16 then
		local var32_16 = var28_16:GetComponent(typeof(CanvasGroup))
		local var33_16 = arg2_16:GetDailyBonusIconName()

		arg0_16.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var33_16, var29_16)

		if var30_16 and arg0_16.bonusPtIconPath then
			if var31_16 then
				GetImageSpriteFromAtlasAsync(arg0_16.bonusPtIconPath, "", var31_16, true)
			else
				GetImageSpriteFromAtlasAsync(arg0_16.bonusPtIconPath, "", var30_16, true)
			end
		end

		LeanTween.cancel(go(var28_16), true)

		local var34_16 = var28_16.anchoredPosition.y

		var32_16.alpha = 0

		LeanTween.value(go(var28_16), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_17)
			var32_16.alpha = arg0_17

			local var0_17 = var28_16.anchoredPosition

			var0_17.y = var34_16 * arg0_17
			var28_16.anchoredPosition = var0_17
		end)):setOnComplete(System.Action(function()
			var32_16.alpha = 1

			local var0_18 = var28_16.anchoredPosition

			var0_18.y = var34_16
			var28_16.anchoredPosition = var0_18
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var35_16 = arg2_16.id

	onButton(arg0_16, var1_16, function()
		if arg0_16.chaptersInBackAnimating[var35_16] then
			return
		end

		local var0_19 = arg1_16.localPosition

		arg0_16:TryOpenChapterInfo(var35_16, Vector3(var0_19.x - 10, var0_19.y + 150))
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.PlayChapterItemAnimation(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = findTF(arg1_20, "main")
	local var1_20 = var0_20:Find("info")
	local var2_20 = findTF(var0_20, "circle")
	local var3_20 = findTF(var0_20, "info/bk")

	LeanTween.cancel(go(var2_20))

	var2_20.localScale = Vector3.zero

	local var4_20 = LeanTween.scale(var2_20, Vector3.one, 0.3):setDelay(0.3)

	arg0_20:RecordTween(var4_20.uniqueId)
	LeanTween.cancel(go(var3_20))
	setAnchoredPosition(var3_20, {
		x = -1 * var1_20.rect.width
	})
	shiftPanel(var3_20, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_20:isTriesLimit() then
			setActive(findTF(var0_20, "triesLimit"), true)
		end

		if arg3_20 then
			arg3_20()
		end
	end)
end

function var0_0.PlayChapterItemAnimationBackward(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = findTF(arg1_22, "main")
	local var1_22 = var0_22:Find("info")
	local var2_22 = findTF(var0_22, "circle")
	local var3_22 = findTF(var0_22, "info/bk")

	LeanTween.cancel(go(var2_22))

	var2_22.localScale = Vector3.one

	local var4_22 = LeanTween.scale(go(var2_22), Vector3.zero, 0.3):setDelay(0.3)

	arg0_22:RecordTween(var4_22.uniqueId)

	arg0_22.chaptersInBackAnimating[arg2_22.id] = true

	LeanTween.cancel(go(var3_22))
	setAnchoredPosition(var3_22, {
		x = 0
	})
	shiftPanel(var3_22, -1 * var1_22.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_22.chaptersInBackAnimating[arg2_22.id] = nil

		if arg3_22 then
			arg3_22()
		end
	end)

	if arg2_22:isTriesLimit() then
		setActive(findTF(var0_22, "triesLimit"), false)
	end
end

function var0_0.UpdateChapterTF(arg0_24, arg1_24)
	local var0_24 = arg0_24.chapterTFsById[arg1_24]

	if var0_24 then
		local var1_24 = getProxy(ChapterProxy):getChapterById(arg1_24)

		arg0_24:UpdateMapItem(var0_24, var1_24)
		arg0_24:PlayChapterItemAnimation(var0_24, var1_24)
	end
end

function var0_0.TryOpenChapter(arg0_25, arg1_25)
	local var0_25 = arg0_25.chapterTFsById[arg1_25]

	if var0_25 then
		local var1_25 = var0_25:Find("main")

		triggerButton(var1_25)
	end
end

function var0_0.UpdateStoryGroup(arg0_26)
	local var0_26 = arg0_26.data:GetChapterInProgress():GetChapterStories()

	UIItemList.StaticAlign(arg0_26.storyHolder, arg0_26.storyTpl, #var0_26, function(arg0_27, arg1_27, arg2_27)
		if arg0_27 ~= UIItemList.EventUpdate then
			return
		end

		local var0_27 = var0_26[arg1_27 + 1]

		arg0_26:UpdateMapStory(arg2_27, var0_27)

		arg2_27.name = "Chapter_" .. var0_27:GetName()
	end)
end

function var0_0.UpdateMapStory(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28:GetPosition()

	setAnchoredPosition(arg1_28, {
		x = arg0_28.mapWidth * var0_28[1],
		y = arg0_28.mapHeight * var0_28[2]
	})
	setText(arg1_28:Find("Name"), arg2_28:GetName())

	local var1_28, var2_28 = arg2_28:GetIcon()

	arg0_28.sceneParent.loader:GetSpriteQuiet(var1_28, var2_28, arg1_28:Find("Icon"), true)

	local var3_28 = arg2_28:GetStoryName()

	onButton(arg0_28, arg1_28, function()
		pg.NewStoryMgr.GetInstance():Play(var3_28, function()
			arg0_28.sceneParent:RefreshMapBG()
			arg0_28:UpdateMapItems()
		end)
	end, SFX_PANEL)
	setActive(arg1_28, not pg.NewStoryMgr.GetInstance():IsPlayed(var3_28))
end

function var0_0.HideFloat(arg0_31)
	setActive(arg0_31.itemHolder, false)
	setActive(arg0_31.storyHolder, false)
end

function var0_0.ShowFloat(arg0_32)
	setActive(arg0_32.itemHolder, true)
	setActive(arg0_32.storyHolder, true)
end

return var0_0
