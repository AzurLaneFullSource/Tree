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
	[1720012] = "red",
	[1720025] = "blue",
	[1720001] = "green",
	[1720026] = "red",
	[1720002] = "yellow",
	[1720011] = "blue"
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
	onButton(arg0_5.sceneParent, arg1_5, function()
		if arg0_5.sceneParent:isfrozen() then
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

function var0_0.PostUpdateMap(arg0_10, arg1_10)
	local var0_10 = arg0_10.contextData.map:getConfig("type") == Map.ACT_EXTRA

	setActive(arg0_10.buttonUp, false)
	setActive(arg0_10.effectUp, false)
	setActive(arg0_10.buttonDown, false)
	setActive(arg0_10.effectDown, false)

	if not var0_10 then
		setActive(arg0_10.sceneParent.btnPrev, false)
		setActive(arg0_10.sceneParent.btnNext, false)

		local var1_10 = getProxy(ChapterProxy):getMapsByActivities()
		local var2_10 = _.detect(var1_10, function(arg0_11)
			return arg0_11.id == arg1_10.id + 1
		end)
		local var3_10 = _.detect(var1_10, function(arg0_12)
			return arg0_12.id == arg1_10.id - 1
		end)

		setActive(arg0_10.buttonDown, var2_10)
		setActive(arg0_10.buttonUp, var3_10)
		LeanTween.cancel(go(arg0_10.buttonUp), true)
		LeanTween.cancel(go(arg0_10.buttonDown), true)
	end
end

function var0_0.UpdateMapItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg2_13:getConfigTable()

	setAnchoredPosition(arg1_13, {
		x = arg0_13.mapWidth * var0_13.pos_x,
		y = arg0_13.mapHeight * var0_13.pos_y
	})

	local var1_13 = findTF(arg1_13, "main")

	setActive(var1_13, true)

	local var2_13 = findTF(var1_13, "info/bk/fordark")

	setActive(var2_13, var0_13.icon_outline == 1)

	local var3_13 = findTF(var1_13, "circle/clear_flag")
	local var4_13 = findTF(var1_13, "circle/lock")
	local var5_13 = not arg2_13.active and not arg2_13:isUnlock()
	local var6_13 = findTF(var1_13, "circle/progress")
	local var7_13 = findTF(var1_13, "circle/progress_text")
	local var8_13 = findTF(var1_13, "circle/stars")
	local var9_13 = string.split(var0_13.name, "|")
	local var10_13 = var1_0[arg0_13.data:GetConfigID()]

	arg0_13.loader:GetSpriteQuiet(arg0_13:GetAtlasPath(), "stage_bar_" .. var10_13, var1_13:Find("info/bk"))
	arg0_13.loader:GetSpriteQuiet(arg0_13:GetAtlasPath(), "chapter_progress_bg_" .. var10_13, var1_13:Find("circle/bk"))
	arg0_13.loader:GetSpriteQuiet(arg0_13:GetAtlasPath(), "chapter_progress_circle_" .. var10_13, var1_13:Find("circle/progress/Fill/progress"))
	arg0_13.loader:GetSpriteQuiet(arg0_13:GetAtlasPath(), "chapter_progress_wave_" .. var10_13, var1_13:Find("circle/progress/Mask/Handler/Wave"))
	arg0_13.loader:GetSpriteQuiet(arg0_13:GetAtlasPath(), "clear_text_" .. var10_13, var1_13:Find("circle/clear_flag"))
	setSlider(var1_13:Find("circle/progress"), 0, 1, arg2_13.progress / 100)

	local var11_13 = var5_13 and "#737373" or "#FFFFFF"

	setText(findTF(var1_13, "info/bk/title_form/title_index"), setColorStr(var0_13.chapter_name .. "  ", var11_13))
	setText(findTF(var1_13, "info/bk/title_form/title"), setColorStr(var9_13[1], var11_13))
	setText(findTF(var1_13, "info/bk/title_form/title_en"), setColorStr(var9_13[2] or "", var11_13))
	setText(var7_13, string.format("%d%%", arg2_13.progress))
	setActive(var8_13, arg2_13:existAchieve())

	if arg2_13:existAchieve() then
		for iter0_13, iter1_13 in ipairs(arg2_13.achieves) do
			local var12_13 = ChapterConst.IsAchieved(iter1_13)
			local var13_13 = var8_13:Find("star" .. iter0_13 .. "/light")

			setActive(var13_13, var12_13)
		end
	end

	local var14_13 = not arg2_13.active and arg2_13:isClear()

	setActive(var3_13, var14_13)
	setActive(var4_13, var5_13)
	setActive(var7_13, not var14_13 and not var5_13)
	arg0_13:DeleteTween("fighting" .. arg2_13.id)

	local var15_13 = findTF(var1_13, "circle/fighting")

	setText(findTF(var15_13, "Text"), i18n("tag_level_fighting"))

	local var16_13 = findTF(var1_13, "circle/oni")

	setText(findTF(var16_13, "Text"), i18n("tag_level_oni"))

	local var17_13 = findTF(var1_13, "circle/narrative")

	setText(findTF(var17_13, "Text"), i18n("tag_level_narrative"))
	setActive(var15_13, false)
	setActive(var16_13, false)
	setActive(var17_13, false)

	local var18_13
	local var19_13

	if arg2_13:getConfig("chapter_tag") == 1 then
		var18_13 = var17_13
	end

	if arg2_13.active then
		var18_13 = arg2_13:existOni() and var16_13 or var15_13
	end

	if var18_13 then
		setActive(var18_13, true)

		local var20_13 = GetOrAddComponent(var18_13, "CanvasGroup")

		var20_13.alpha = 1

		arg0_13:RecordTween("fighting" .. arg2_13.id, LeanTween.alphaCanvas(var20_13, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var21_13 = findTF(var1_13, "triesLimit")

	setActive(var21_13, false)

	if arg2_13:isTriesLimit() then
		local var22_13 = arg2_13:getConfig("count")
		local var23_13 = var22_13 - arg2_13:getTodayDefeatCount() .. "/" .. var22_13

		setText(var21_13:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var21_13:Find("Text"), setColorStr(var23_13, var22_13 <= arg2_13:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var24_13 = arg2_13:GetDailyBonusQuota()
	local var25_13 = findTF(var1_13, "mark")

	setActive(var25_13:Find("bonus"), var24_13)
	setActive(var25_13, var24_13)

	if var24_13 then
		local var26_13 = var25_13:GetComponent(typeof(CanvasGroup))
		local var27_13 = arg0_13.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_13.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var27_13, var25_13:Find("bonus"))
		LeanTween.cancel(go(var25_13), true)

		local var28_13 = var25_13.anchoredPosition.y

		var26_13.alpha = 0

		LeanTween.value(go(var25_13), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_14)
			var26_13.alpha = arg0_14

			local var0_14 = var25_13.anchoredPosition

			var0_14.y = var28_13 * arg0_14
			var25_13.anchoredPosition = var0_14
		end)):setOnComplete(System.Action(function()
			var26_13.alpha = 1

			local var0_15 = var25_13.anchoredPosition

			var0_15.y = var28_13
			var25_13.anchoredPosition = var0_15
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var29_13 = arg2_13.id

	onButton(arg0_13.sceneParent, var1_13, function()
		if arg0_13:InvokeParent("isfrozen") then
			return
		end

		if arg0_13.chaptersInBackAnimating[var29_13] then
			return
		end

		local var0_16 = getProxy(ChapterProxy):getChapterById(var29_13)

		if not var0_16:isUnlock() then
			local var1_16 = var0_16:getPrevChapterName()

			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre", var1_16))

			return
		end

		if not getProxy(ChapterProxy):getMapById(var0_16:getConfig("map")):isRemaster() and not var0_16:inActTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_close"))

			return
		end

		local var2_16 = var0_16:getConfig("unlocklevel")

		if var2_16 > arg0_13.sceneParent.player.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", var2_16))

			return
		end

		local var3_16 = getProxy(ChapterProxy):getActiveChapter(true)

		if var3_16 and var3_16.id ~= var29_13 then
			arg0_13:InvokeParent("emit", LevelMediator2.ON_STRATEGYING_CHAPTER)

			return
		end

		if var0_16.active then
			arg0_13:InvokeParent("switchToChapter", var0_16)
		else
			local var4_16 = arg1_13.localPosition

			arg0_13:InvokeParent("displayChapterPanel", var0_16, Vector3(var4_16.x - 10, var4_16.y + 150))
		end
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.OnDestroy(arg0_17)
	arg0_17.loader:Clear()
	var0_0.super.OnDestroy(arg0_17)
end

return var0_0
