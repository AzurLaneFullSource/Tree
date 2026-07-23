local var0_0 = class("MapBuilderBismarck", import(".MapBuilderShinano"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPEBISMARCK
end

function var0_0.getUIName(arg0_2)
	return "Bismarck_levels"
end

function var0_0.GetAtlasPath(arg0_3)
	return "ui/" .. arg0_3:getUIName() .. "_atlas"
end

local var1_0 = {
	[1720001] = "green",
	[1720002] = "yellow",
	[2100592] = "red",
	[2100591] = "blue",
	[1720011] = "blue",
	[1720012] = "red",
	[1720025] = "blue",
	[1720026] = "red",
	[2100582] = "yellow",
	[2100581] = "green"
}

function var0_0.OnInit(arg0_4)
	arg0_4.tpl = arg0_4._tf:Find("level_tpl")

	setActive(arg0_4.tpl, false)

	arg0_4.itemHolder = arg0_4._tf:Find("items")
	arg0_4.buttonUp = arg0_4._tf:Find("up")
	arg0_4.effectUp = arg0_4._tf:Find("upEffect")
	arg0_4.buttonDown = arg0_4._tf:Find("down")
	arg0_4.effectDown = arg0_4._tf:Find("downEffect")

	pg.ViewUtils.SetSortingOrder(arg0_4.effectUp:Find("zhongzhijiguang_jiasu"), ChapterConst.LayerWeightMap + 1)
	pg.ViewUtils.SetSortingOrder(arg0_4.effectDown:Find("zhongzhijiguang_jiasu"), ChapterConst.LayerWeightMap + 1)
	arg0_4:InitTransformMapBtn(arg0_4.buttonDown, 1, arg0_4.effectDown)
	arg0_4:InitTransformMapBtn(arg0_4.buttonUp, -1, arg0_4.effectUp)

	arg0_4.loader = AutoLoader.New()
end

function var0_0.InitTransformMapBtn(arg0_5, arg1_5, arg2_5, arg3_5)
	onButton(arg0_5, arg1_5, function()
		if arg0_5:isfrozen() then
			return
		end

		seriesAsync({
			function(arg0_7)
				if not arg0_5:TrySwitchNextMap(arg2_5) then
					return
				end

				pg.CriMgr.GetInstance():StopBGM()
				pg.CriMgr.GetInstance():PlaySE_V3("battle-ship-move")
				setActive(arg3_5, true)
				arg0_5.sceneParent:frozen()
				LeanTween.delayedCall(go(arg1_5), 1.8, System.Action(arg0_7))
			end,
			function(arg0_8)
				arg0_5.sceneParent:setMap(arg0_5.contextData.mapIdx + arg2_5)
				LeanTween.delayedCall(go(arg1_5), 0.5, System.Action(arg0_8))
			end,
			function(arg0_9)
				arg0_5.sceneParent:unfrozen()
			end
		})
	end)
end

function var0_0.UpdateCustomButtons(arg0_10)
	local var0_10 = arg0_10.contextData.map
	local var1_10 = var0_10:getConfig("type") == Map.ACT_EXTRA

	setActive(arg0_10.buttonUp, false)
	setActive(arg0_10.effectUp, false)
	setActive(arg0_10.buttonDown, false)
	setActive(arg0_10.effectDown, false)

	if not var1_10 then
		setActive(arg0_10.sceneParent.btnPrev, false)
		setActive(arg0_10.sceneParent.btnNext, false)

		local var2_10 = getProxy(ChapterProxy)
		local var3_10 = tobool(var2_10:getMapById(var0_10.id - 1))
		local var4_10 = tobool(var2_10:getMapById(var0_10.id + 1))

		setActive(arg0_10.buttonDown, var4_10)
		setActive(arg0_10.buttonUp, var3_10)
		LeanTween.cancel(go(arg0_10.buttonUp), true)
		LeanTween.cancel(go(arg0_10.buttonDown), true)
	end
end

function var0_0.UpdateMapItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg2_11:getConfigTable()

	setLocalPosition(arg1_11, {
		x = 1920 * var0_11.pos_x,
		y = 1080 * var0_11.pos_y
	})

	local var1_11 = findTF(arg1_11, "main")

	setActive(var1_11, true)

	local var2_11 = findTF(var1_11, "info/bk/fordark")

	setActive(var2_11, var0_11.icon_outline == 1)

	local var3_11 = findTF(var1_11, "circle/clear_flag")
	local var4_11 = findTF(var1_11, "circle/lock")
	local var5_11 = not arg2_11.active and not arg2_11:isUnlock()
	local var6_11 = findTF(var1_11, "circle/progress")
	local var7_11 = findTF(var1_11, "circle/progress_text")
	local var8_11 = findTF(var1_11, "circle/stars")
	local var9_11 = string.split(var0_11.name, "|")
	local var10_11 = var1_0[arg0_11.data:GetConfigID()]

	arg0_11.loader:GetSpriteQuiet(arg0_11:GetAtlasPath(), "stage_bar_" .. var10_11, var1_11:Find("info/bk"))
	arg0_11.loader:GetSpriteQuiet(arg0_11:GetAtlasPath(), "chapter_progress_bg_" .. var10_11, var1_11:Find("circle/bk"))
	arg0_11.loader:GetSpriteQuiet(arg0_11:GetAtlasPath(), "chapter_progress_circle_" .. var10_11, var1_11:Find("circle/progress/Fill/progress"))
	arg0_11.loader:GetSpriteQuiet(arg0_11:GetAtlasPath(), "chapter_progress_wave_" .. var10_11, var1_11:Find("circle/progress/Mask/Handler/Wave"))
	arg0_11.loader:GetSpriteQuiet(arg0_11:GetAtlasPath(), "clear_text_" .. var10_11, var1_11:Find("circle/clear_flag"))
	setSlider(var1_11:Find("circle/progress"), 0, 1, arg2_11.progress / 100)

	local var11_11 = var5_11 and "#737373" or "#FFFFFF"

	setText(findTF(var1_11, "info/bk/title_form/title_index"), setColorStr(var0_11.chapter_name .. "  ", var11_11))
	setText(findTF(var1_11, "info/bk/title_form/title"), setColorStr(var9_11[1], var11_11))
	setText(findTF(var1_11, "info/bk/title_form/title_en"), setColorStr(var9_11[2] or "", var11_11))
	setText(var7_11, string.format("%d%%", arg2_11.progress))
	setActive(var8_11, arg2_11:existAchieve())

	if arg2_11:existAchieve() then
		for iter0_11, iter1_11 in ipairs(arg2_11.achieves) do
			local var12_11 = ChapterConst.IsAchieved(iter1_11)
			local var13_11 = var8_11:Find("star" .. iter0_11 .. "/light")

			setActive(var13_11, var12_11)
		end
	end

	local var14_11 = not arg2_11.active and arg2_11:isClear()

	setActive(var3_11, var14_11)
	setActive(var4_11, var5_11)
	setActive(var7_11, not var14_11 and not var5_11)
	arg0_11:DeleteTween("fighting" .. arg2_11.id)

	local var15_11 = findTF(var1_11, "circle/fighting")

	setText(findTF(var15_11, "Text"), i18n("tag_level_fighting"))

	local var16_11 = findTF(var1_11, "circle/oni")

	setText(findTF(var16_11, "Text"), i18n("tag_level_oni"))

	local var17_11 = findTF(var1_11, "circle/narrative")

	setText(findTF(var17_11, "Text"), i18n("tag_level_narrative"))
	setActive(var15_11, false)
	setActive(var16_11, false)
	setActive(var17_11, false)

	local var18_11
	local var19_11

	if arg2_11:getConfig("chapter_tag") == 1 then
		var18_11 = var17_11
	end

	if arg2_11.active then
		var18_11 = arg2_11:existOni() and var16_11 or var15_11
	end

	if var18_11 then
		setActive(var18_11, true)

		local var20_11 = GetOrAddComponent(var18_11, "CanvasGroup")

		var20_11.alpha = 1

		arg0_11:RecordTween("fighting" .. arg2_11.id, LeanTween.alphaCanvas(var20_11, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var21_11 = findTF(var1_11, "triesLimit")
	local var22_11 = arg2_11:isTriesLimit()

	setActive(var21_11, var22_11)

	if var22_11 then
		local var23_11 = arg2_11:getConfig("count")
		local var24_11 = var23_11 - arg2_11:getTodayDefeatCount() .. "/" .. var23_11

		setText(var21_11:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var21_11:Find("Text"), setColorStr(var24_11, var23_11 <= arg2_11:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var25_11 = arg2_11:GetDailyBonusQuota()
	local var26_11 = findTF(var1_11, "mark")
	local var27_11 = var26_11:Find("bonus")
	local var28_11 = var27_11:Find("icon")
	local var29_11 = findTF(var27_11, "icon/Image")

	setActive(var27_11, var25_11)
	setActive(var26_11, var25_11)

	if var28_11 then
		setActive(var28_11, var25_11 and arg0_11.bonusPtIconPath)
	end

	if var25_11 then
		local var30_11 = var26_11:GetComponent(typeof(CanvasGroup))
		local var31_11 = arg2_11:GetDailyBonusIconName()

		arg0_11.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var31_11, var27_11)

		if var28_11 and arg0_11.bonusPtIconPath then
			if var29_11 then
				GetImageSpriteFromAtlasAsync(arg0_11.bonusPtIconPath, "", var29_11, true)
			else
				GetImageSpriteFromAtlasAsync(arg0_11.bonusPtIconPath, "", var28_11, true)
			end
		end

		LeanTween.cancel(go(var26_11), true)

		local var32_11 = var26_11.anchoredPosition.y

		var30_11.alpha = 0

		LeanTween.value(go(var26_11), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_12)
			var30_11.alpha = arg0_12

			local var0_12 = var26_11.anchoredPosition

			var0_12.y = var32_11 * arg0_12
			var26_11.anchoredPosition = var0_12
		end)):setOnComplete(System.Action(function()
			var30_11.alpha = 1

			local var0_13 = var26_11.anchoredPosition

			var0_13.y = var32_11
			var26_11.anchoredPosition = var0_13
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var33_11 = arg2_11.id

	onButton(arg0_11, var1_11, function()
		if arg0_11.chaptersInBackAnimating[var33_11] then
			return
		end

		local var0_14 = arg1_11.localPosition

		arg0_11:TryOpenChapterInfo(var33_11, Vector3(var0_14.x - 10, var0_14.y + 150))
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.OnDestroy(arg0_15)
	arg0_15.loader:Clear()
	var0_0.super.OnDestroy(arg0_15)
end

return var0_0
