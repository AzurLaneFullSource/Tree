local var0_0 = class("MapBuilderSPFull", import(".MapBuilderSP"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPESPFULL
end

function var0_0.getUIName(arg0_2)
	return "LevelSelectSPFullUI"
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)

	arg0_3.progressText = arg0_3._tf:Find("Story/Desc/Digit")
end

function var0_0.UpdateButtons(arg0_4)
	var0_0.super.UpdateButtons(arg0_4)

	if arg0_4.contextData.displayMode == var0_0.DISPLAY.BATTLE then
		arg0_4.sceneParent:updateDifficultyBtns()
		arg0_4.sceneParent:updateActivityBtns()
		arg0_4.sceneParent:UpdateSwitchMapButton()
	else
		arg0_4.sceneParent:HideBtns()
	end
end

function var0_0.OnHide(arg0_5)
	arg0_5.sceneParent:HideBtns()
	var0_0.super.OnHide(arg0_5)
end

function var0_0.UpdateBattle(arg0_6)
	local var0_6 = getProxy(ChapterProxy)
	local var1_6 = arg0_6.displayChapterIDs
	local var2_6 = {}

	for iter0_6, iter1_6 in ipairs(var1_6) do
		local var3_6 = var0_6:getChapterById(iter1_6)

		if var3_6:isUnlock() or var3_6:activeAlways() then
			table.insert(var2_6, var3_6)
		end
	end

	table.clear(arg0_6.chapterTFsById)
	UIItemList.StaticAlign(arg0_6.itemHolder, arg0_6.chapterTpl, #var2_6, function(arg0_7, arg1_7, arg2_7)
		if arg0_7 ~= UIItemList.EventUpdate then
			return
		end

		local var0_7 = var2_6[arg1_7 + 1]

		arg0_6:UpdateMapItem(arg2_7, var0_7)

		arg2_7.name = "Chapter_" .. var0_7.id
		arg0_6.chapterTFsById[var0_7.id] = arg2_7
	end)
end

function var0_0.UpdateMapItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg2_8:getConfigTable()

	setAnchoredPosition(arg1_8, {
		x = arg0_8.mapWidth * var0_8.pos_x,
		y = arg0_8.mapHeight * var0_8.pos_y
	})

	local var1_8 = findTF(arg1_8, "main")

	setActive(var1_8, true)

	local var2_8 = findTF(var1_8, "circle/fordark")
	local var3_8 = findTF(var1_8, "info/bk/fordark")

	setActive(var2_8, var0_8.icon_outline == 1)
	setActive(var3_8, var0_8.icon_outline == 1)

	local var4_8 = arg0_8.chapterGroupDict[arg2_8.id]

	assert(var4_8)

	local var5_8 = {
		"Lock",
		"Normal",
		"Hard"
	}
	local var6_8 = 1

	if arg2_8:isUnlock() then
		var6_8 = 2

		if #var4_8.list > 1 then
			var6_8 = table.indexof(var4_8.list, arg2_8.id) + 1
		elseif arg2_8:IsSpChapter() or arg2_8:IsEXChapter() then
			var6_8 = 3
		elseif arg0_8.contextData.map:isHardMap() then
			var6_8 = 3
		end
	end

	local var7_8 = findTF(var1_8, "circle/bk")

	for iter0_8, iter1_8 in ipairs(var5_8) do
		setActive(var7_8:Find(iter1_8), iter0_8 == var6_8)
	end

	local var8_8 = findTF(var1_8, "circle/clear_flag")
	local var9_8 = findTF(var1_8, "circle/lock")
	local var10_8 = findTF(var1_8, "circle/progress")
	local var11_8 = findTF(var1_8, "circle/progress_text")
	local var12_8 = findTF(var1_8, "circle/stars")
	local var13_8 = string.split(var0_8.name, "|")

	setText(findTF(var1_8, "info/bk/title_form/title_index"), var0_8.chapter_name .. "  ")
	setText(findTF(var1_8, "info/bk/title_form/title"), var13_8[1])
	setText(findTF(var1_8, "info/bk/title_form/title_en"), var13_8[2] or "")
	setFillAmount(var10_8, arg2_8.progress / 100)
	setText(var11_8, string.format("%d%%", arg2_8.progress))
	setActive(var12_8, arg2_8:existAchieve())

	if arg2_8:existAchieve() then
		for iter2_8, iter3_8 in ipairs(arg2_8.achieves) do
			local var14_8 = ChapterConst.IsAchieved(iter3_8)
			local var15_8 = var12_8:GetChild(iter2_8 - 1):Find("light")

			setActive(var15_8, var14_8)

			for iter4_8, iter5_8 in ipairs(var5_8) do
				if iter5_8 ~= "Lock" then
					setActive(var15_8:Find(iter5_8), iter4_8 == var6_8)
				end
			end
		end
	end

	local var16_8 = findTF(var1_8, "info/bk/BG")

	for iter6_8, iter7_8 in ipairs(var5_8) do
		setActive(var16_8:Find(iter7_8), iter6_8 == var6_8)
	end

	setActive(findTF(var1_8, "HardEffect"), var6_8 == 3)

	local var17_8 = not arg2_8.active and arg2_8:isClear()
	local var18_8 = not arg2_8.active and not arg2_8:isUnlock()

	setActive(var8_8, var17_8)
	setActive(var9_8, var18_8)
	setActive(var11_8, not var17_8 and not var18_8)
	arg0_8:DeleteTween("fighting" .. arg2_8.id)

	local var19_8 = findTF(var1_8, "circle/fighting")

	setText(findTF(var19_8, "Text"), i18n("tag_level_fighting"))

	local var20_8 = findTF(var1_8, "circle/oni")

	setText(findTF(var20_8, "Text"), i18n("tag_level_oni"))

	local var21_8 = findTF(var1_8, "circle/narrative")

	setText(findTF(var21_8, "Text"), i18n("tag_level_narrative"))
	setActive(var19_8, false)
	setActive(var20_8, false)
	setActive(var21_8, false)

	local var22_8
	local var23_8

	if arg2_8:getConfig("chapter_tag") == 1 then
		var22_8 = var21_8
	end

	if arg2_8.active then
		var22_8 = arg2_8:existOni() and var20_8 or var19_8
	end

	if var22_8 then
		setActive(var22_8, true)

		local var24_8 = GetOrAddComponent(var22_8, "CanvasGroup")

		var24_8.alpha = 1

		arg0_8:RecordTween("fighting" .. arg2_8.id, LeanTween.alphaCanvas(var24_8, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var25_8 = findTF(var1_8, "triesLimit")
	local var26_8 = arg2_8:isTriesLimit()

	setActive(var25_8, var26_8)

	if var26_8 then
		local var27_8 = arg2_8:getConfig("count")
		local var28_8 = var27_8 - arg2_8:getTodayDefeatCount() .. "/" .. var27_8

		setText(var25_8:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var25_8:Find("Text"), setColorStr(var28_8, var27_8 <= arg2_8:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var29_8 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var25_8:Find("TipRect"), var29_8)
	end

	local var30_8 = arg2_8:GetDailyBonusQuota()
	local var31_8 = findTF(var1_8, "mark")

	setActive(var31_8:Find("bonus"), var30_8)
	setActive(var31_8, var30_8)

	if var30_8 then
		local var32_8 = var31_8:GetComponent(typeof(CanvasGroup))
		local var33_8 = arg0_8.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_8.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var33_8, var31_8:Find("bonus"))
		LeanTween.cancel(go(var31_8), true)

		local var34_8 = var31_8.anchoredPosition.y

		var32_8.alpha = 0

		LeanTween.value(go(var31_8), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_9)
			var32_8.alpha = arg0_9

			local var0_9 = var31_8.anchoredPosition

			var0_9.y = var34_8 * arg0_9
			var31_8.anchoredPosition = var0_9
		end)):setOnComplete(System.Action(function()
			var32_8.alpha = 1

			local var0_10 = var31_8.anchoredPosition

			var0_10.y = var34_8
			var31_8.anchoredPosition = var0_10
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var35_8 = arg2_8.id

	onButton(arg0_8, var1_8, function()
		arg0_8:TryOpenChapterInfo(var35_8, nil, var4_8.list)
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

return var0_0
