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

	local var2_9 = getProxy(ActivityProxy)
	local var3_9 = var2_9:getActivityById(var1_9)

	if not var3_9 or var3_9:isEnd() then
		return
	end

	local var4_9 = var3_9:GetConfigClientSetting("PTID")

	if not var4_9 then
		return
	end

	local var5_9 = underscore.detect(var2_9:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_10)
		return arg0_10 and not arg0_10:isEnd() and arg0_10:getConfig("config_id") == var4_9
	end)

	if not var5_9 then
		return
	end

	local var6_9 = tonumber(var5_9:getConfig("config_id"))

	if not var6_9 then
		return
	end

	arg0_9.bonusPtIconPath = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var6_9
	}):getIcon()
end

function var0_0.UpdateMapItems(arg0_11)
	var0_0.super.UpdateMapItems(arg0_11)

	local var0_11 = arg0_11.data
	local var1_11 = var0_11:GetChapterInProgress()

	if var1_11 and isa(var1_11, ChapterStoryGroup) then
		setActive(arg0_11.itemHolder, false)
		setActive(arg0_11.storyHolder, true)
		arg0_11:UpdateStoryGroup()

		return
	end

	setActive(arg0_11.itemHolder, true)
	setActive(arg0_11.storyHolder, false)
	arg0_11:UpdateBonusPtIconPath()

	local var2_11 = getProxy(ChapterProxy)
	local var3_11 = {}

	for iter0_11, iter1_11 in pairs(var0_11:getChapters()) do
		if (iter1_11:isUnlock() or iter1_11:activeAlways()) and (not iter1_11:ifNeedHide() or var2_11:GetJustClearChapters(iter1_11.id)) then
			table.insert(var3_11, iter1_11)
		end
	end

	table.clear(arg0_11.chapterTFsById)
	UIItemList.StaticAlign(arg0_11.itemHolder, arg0_11.chapterTpl, #var3_11, function(arg0_12, arg1_12, arg2_12)
		if arg0_12 ~= UIItemList.EventUpdate then
			return
		end

		local var0_12 = var3_11[arg1_12 + 1]

		arg0_11:UpdateMapItem(arg2_12, var0_12)

		arg2_12.name = "Chapter_" .. var0_12.id
		arg0_11.chapterTFsById[var0_12.id] = arg2_12
	end)

	local var4_11 = {}

	for iter2_11, iter3_11 in pairs(var3_11) do
		local var5_11 = iter3_11:getConfigTable()

		var4_11[var5_11.pos_x] = var4_11[var5_11.pos_x] or {}

		local var6_11 = var4_11[var5_11.pos_x]

		var6_11[var5_11.pos_y] = var6_11[var5_11.pos_y] or {}

		local var7_11 = var6_11[var5_11.pos_y]

		table.insert(var7_11, iter3_11)
	end

	for iter4_11, iter5_11 in pairs(var4_11) do
		for iter6_11, iter7_11 in pairs(iter5_11) do
			local var8_11 = {}

			seriesAsync({
				function(arg0_13)
					local var0_13 = 0

					for iter0_13, iter1_13 in pairs(iter7_11) do
						if iter1_13:ifNeedHide() and var2_11:GetJustClearChapters(iter1_13.id) and arg0_11.chapterTFsById[iter1_13.id] then
							var0_13 = var0_13 + 1

							local var1_13 = arg0_11.chapterTFsById[iter1_13.id]

							setActive(var1_13, true)
							arg0_11:PlayChapterItemAnimationBackward(var1_13, iter1_13, function()
								var0_13 = var0_13 - 1

								setActive(var1_13, false)
								var2_11:RecordJustClearChapters(iter1_13.id, nil)

								if var0_13 <= 0 then
									arg0_13()
								end
							end)

							var8_11[iter1_13.id] = true
						elseif arg0_11.chapterTFsById[iter1_13.id] then
							setActive(arg0_11.chapterTFsById[iter1_13.id], false)
						end
					end

					if var0_13 <= 0 then
						arg0_13()
					end
				end,
				function(arg0_15)
					local var0_15 = 0

					for iter0_15, iter1_15 in pairs(iter7_11) do
						if not var8_11[iter1_15.id] then
							var0_15 = var0_15 + 1

							setActive(arg0_11.chapterTFsById[iter1_15.id], true)
							arg0_11:PlayChapterItemAnimation(arg0_11.chapterTFsById[iter1_15.id], iter1_15, function()
								var0_15 = var0_15 - 1

								if var0_15 <= 0 then
									arg0_15()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var0_0.UpdateMapItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg2_17:getConfigTable()

	warning(1920 * var0_17.pos_x, 1080 * var0_17.pos_y)
	setLocalPosition(arg1_17, {
		x = 1920 * var0_17.pos_x,
		y = 1080 * var0_17.pos_y
	})

	local var1_17 = findTF(arg1_17, "main")

	setActive(var1_17, true)

	local var2_17 = findTF(var1_17, "circle/fordark")
	local var3_17 = findTF(var1_17, "info/bk/fordark")

	setActive(var2_17, var0_17.icon_outline == 1)
	setActive(var3_17, var0_17.icon_outline == 1)

	local var4_17 = findTF(var1_17, "circle/clear_flag")
	local var5_17 = findTF(var1_17, "circle/progress")
	local var6_17 = findTF(var1_17, "circle/progress_text")
	local var7_17 = findTF(var1_17, "circle/stars")
	local var8_17 = string.split(var0_17.name, "|")

	setText(findTF(var1_17, "info/bk/title_form/title_index"), var0_17.chapter_name .. "  ")
	setText(findTF(var1_17, "info/bk/title_form/title"), var8_17[1])
	setText(findTF(var1_17, "info/bk/title_form/title_en"), var8_17[2] or "")
	setFillAmount(var5_17, arg2_17.progress / 100)
	setText(var6_17, string.format("%d%%", arg2_17.progress))
	setActive(var7_17, arg2_17:existAchieve())

	if arg2_17:existAchieve() then
		for iter0_17, iter1_17 in ipairs(arg2_17.achieves) do
			local var9_17 = ChapterConst.IsAchieved(iter1_17)
			local var10_17 = var7_17:Find("star" .. iter0_17 .. "/light")

			setActive(var10_17, var9_17)
		end
	end

	local var11_17 = not arg2_17.active and arg2_17:isClear()

	setActive(var4_17, var11_17)
	setActive(var6_17, not var11_17)
	arg0_17:DeleteTween("fighting" .. arg2_17.id)

	local var12_17 = findTF(var1_17, "circle/fighting")

	setText(findTF(var12_17, "Text"), i18n("tag_level_fighting"))

	local var13_17 = findTF(var1_17, "circle/oni")

	setText(findTF(var13_17, "Text"), i18n("tag_level_oni"))

	local var14_17 = findTF(var1_17, "circle/narrative")

	setText(findTF(var14_17, "Text"), i18n("tag_level_narrative"))

	local var15_17 = findTF(var1_17, "circle/auto")

	setText(findTF(var15_17, "Text"), i18n("tag_level_autoing"))
	setActive(var12_17, false)
	setActive(var13_17, false)
	setActive(var14_17, false)
	setActive(var15_17, false)

	local var16_17
	local var17_17

	if arg2_17:getConfig("chapter_tag") == 1 then
		var16_17 = var14_17
	end

	if arg2_17.active then
		var16_17 = arg2_17:existOni() and var13_17 or var12_17
	end

	local var18_17 = getProxy(ChapterProxy):GetAutoChapterId()

	if var18_17 and var18_17 == arg2_17.id then
		var16_17 = var15_17

		local var19_17, var20_17 = getProxy(ChapterAutoProxy):GetCntInfo()

		setText(findTF(var15_17, "Text"), var19_17 < var20_17 and i18n("tag_level_autoing") or i18n("tag_level_auto_finish"))
	end

	if var16_17 then
		setActive(var16_17, true)

		local var21_17 = GetOrAddComponent(var16_17, "CanvasGroup")

		var21_17.alpha = 1

		arg0_17:RecordTween("fighting" .. arg2_17.id, LeanTween.alphaCanvas(var21_17, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var22_17 = findTF(var1_17, "triesLimit")

	setActive(var22_17, false)

	if arg2_17:isTriesLimit() then
		local var23_17 = arg2_17:getConfig("count")
		local var24_17 = var23_17 - arg2_17:getTodayDefeatCount() .. "/" .. var23_17

		setText(var22_17:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var22_17:Find("Text"), setColorStr(var24_17, var23_17 <= arg2_17:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var25_17 = pg.expedition_data_by_map[arg2_17:getConfig("map")].on_activity
		local var26_17 = getProxy(ChapterProxy):IsActivitySPChapterActive(var25_17) and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var22_17:Find("TipRect"), var26_17)
	end

	local var27_17 = arg2_17:GetDailyBonusQuota()
	local var28_17 = findTF(var1_17, "mark")
	local var29_17 = var28_17:Find("bonus")
	local var30_17 = var29_17:Find("icon")
	local var31_17 = findTF(var29_17, "icon/Image")

	setActive(var29_17, var27_17)
	setActive(var28_17, var27_17)

	if var30_17 then
		setActive(var30_17, var27_17 and arg0_17.bonusPtIconPath)
	end

	if var27_17 then
		local var32_17 = var28_17:GetComponent(typeof(CanvasGroup))
		local var33_17 = arg2_17:GetDailyBonusIconName()

		arg0_17.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var33_17, var29_17)

		if var30_17 and arg0_17.bonusPtIconPath then
			if var31_17 then
				GetImageSpriteFromAtlasAsync(arg0_17.bonusPtIconPath, "", var31_17, true)
			else
				GetImageSpriteFromAtlasAsync(arg0_17.bonusPtIconPath, "", var30_17, true)
			end
		end

		LeanTween.cancel(go(var28_17), true)

		local var34_17 = var28_17.anchoredPosition.y

		var32_17.alpha = 0

		LeanTween.value(go(var28_17), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_18)
			var32_17.alpha = arg0_18

			local var0_18 = var28_17.anchoredPosition

			var0_18.y = var34_17 * arg0_18
			var28_17.anchoredPosition = var0_18
		end)):setOnComplete(System.Action(function()
			var32_17.alpha = 1

			local var0_19 = var28_17.anchoredPosition

			var0_19.y = var34_17
			var28_17.anchoredPosition = var0_19
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var35_17 = arg2_17.id

	onButton(arg0_17, var1_17, function()
		if arg0_17.chaptersInBackAnimating[var35_17] then
			return
		end

		local var0_20 = arg1_17.localPosition

		arg0_17:TryOpenChapterInfo(var35_17, Vector3(var0_20.x - 10, var0_20.y + 150))
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.PlayChapterItemAnimation(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = findTF(arg1_21, "main")
	local var1_21 = var0_21:Find("info")
	local var2_21 = findTF(var0_21, "circle")
	local var3_21 = findTF(var0_21, "info/bk")

	LeanTween.cancel(go(var2_21))

	var2_21.localScale = Vector3.zero

	local var4_21 = LeanTween.scale(var2_21, Vector3.one, 0.3):setDelay(0.3)

	arg0_21:RecordTween(var4_21.uniqueId)
	LeanTween.cancel(go(var3_21))
	setAnchoredPosition(var3_21, {
		x = -1 * var1_21.rect.width
	})
	shiftPanel(var3_21, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_21:isTriesLimit() then
			setActive(findTF(var0_21, "triesLimit"), true)
		end

		if arg3_21 then
			arg3_21()
		end
	end)
end

function var0_0.PlayChapterItemAnimationBackward(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = findTF(arg1_23, "main")
	local var1_23 = var0_23:Find("info")
	local var2_23 = findTF(var0_23, "circle")
	local var3_23 = findTF(var0_23, "info/bk")

	LeanTween.cancel(go(var2_23))

	var2_23.localScale = Vector3.one

	local var4_23 = LeanTween.scale(go(var2_23), Vector3.zero, 0.3):setDelay(0.3)

	arg0_23:RecordTween(var4_23.uniqueId)

	arg0_23.chaptersInBackAnimating[arg2_23.id] = true

	LeanTween.cancel(go(var3_23))
	setAnchoredPosition(var3_23, {
		x = 0
	})
	shiftPanel(var3_23, -1 * var1_23.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_23.chaptersInBackAnimating[arg2_23.id] = nil

		if arg3_23 then
			arg3_23()
		end
	end)

	if arg2_23:isTriesLimit() then
		setActive(findTF(var0_23, "triesLimit"), false)
	end
end

function var0_0.UpdateChapterTF(arg0_25, arg1_25)
	local var0_25 = arg0_25.chapterTFsById[arg1_25]

	if var0_25 then
		local var1_25 = getProxy(ChapterProxy):getChapterById(arg1_25)

		arg0_25:UpdateMapItem(var0_25, var1_25)
		arg0_25:PlayChapterItemAnimation(var0_25, var1_25)
	end
end

function var0_0.TryOpenChapter(arg0_26, arg1_26)
	local var0_26 = arg0_26.chapterTFsById[arg1_26]

	if var0_26 then
		local var1_26 = var0_26:Find("main")

		triggerButton(var1_26)
	end
end

function var0_0.UpdateStoryGroup(arg0_27)
	local var0_27 = arg0_27.data:GetChapterInProgress():GetChapterStories()

	UIItemList.StaticAlign(arg0_27.storyHolder, arg0_27.storyTpl, #var0_27, function(arg0_28, arg1_28, arg2_28)
		if arg0_28 ~= UIItemList.EventUpdate then
			return
		end

		local var0_28 = var0_27[arg1_28 + 1]

		arg0_27:UpdateMapStory(arg2_28, var0_28)

		arg2_28.name = "Chapter_" .. var0_28:GetName()
	end)
end

function var0_0.UpdateMapStory(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg2_29:GetPosition()

	setAnchoredPosition(arg1_29, {
		x = arg0_29.mapWidth * var0_29[1],
		y = arg0_29.mapHeight * var0_29[2]
	})
	setText(arg1_29:Find("Name"), arg2_29:GetName())

	local var1_29, var2_29 = arg2_29:GetIcon()

	arg0_29.sceneParent.loader:GetSpriteQuiet(var1_29, var2_29, arg1_29:Find("Icon"), true)

	local var3_29 = arg2_29:GetStoryName()

	onButton(arg0_29, arg1_29, function()
		pg.NewStoryMgr.GetInstance():Play(var3_29, function()
			arg0_29.sceneParent:RefreshMapBG()
			arg0_29:UpdateMapItems()
		end)
	end, SFX_PANEL)
	setActive(arg1_29, not pg.NewStoryMgr.GetInstance():IsPlayed(var3_29))
end

function var0_0.HideFloat(arg0_32)
	setActive(arg0_32.itemHolder, false)
	setActive(arg0_32.storyHolder, false)
end

function var0_0.ShowFloat(arg0_33)
	setActive(arg0_33.itemHolder, true)
	setActive(arg0_33.storyHolder, true)
end

return var0_0
