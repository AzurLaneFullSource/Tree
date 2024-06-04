local var0 = class("MapBuilderBismarck", import(".MapBuilderShinano"))

function var0.GetType(arg0)
	return MapBuilder.TYPEBISMARCK
end

function var0.getUIName(arg0)
	return "Bismarck_levels"
end

function var0.GetAtlasPath(arg0)
	return "ui/" .. arg0:getUIName() .. "_atlas"
end

local var1 = {
	[1720012] = "red",
	[1720025] = "blue",
	[1720001] = "green",
	[1720026] = "red",
	[1720002] = "yellow",
	[1720011] = "blue"
}

function var0.OnInit(arg0)
	arg0.tpl = arg0._tf:Find("level_tpl")

	setActive(arg0.tpl, false)

	arg0.itemHolder = arg0._tf:Find("items")
	arg0.buttonUp = arg0._tf:Find("up")
	arg0.effectUp = arg0._tf:Find("upEffect")
	arg0.buttonDown = arg0._tf:Find("down")
	arg0.effectDown = arg0._tf:Find("downEffect")

	pg.ViewUtils.SetSortingOrder(arg0.effectUp:Find("zhongzhijiguang_jiasu"), ChapterConst.LayerWeightMap + 1)
	pg.ViewUtils.SetSortingOrder(arg0.effectDown:Find("zhongzhijiguang_jiasu"), ChapterConst.LayerWeightMap + 1)
	arg0:InitTransformMapBtn(arg0.buttonDown, 1, arg0.effectDown)
	arg0:InitTransformMapBtn(arg0.buttonUp, -1, arg0.effectUp)

	arg0.loader = AutoLoader.New()
end

function var0.InitTransformMapBtn(arg0, arg1, arg2, arg3)
	onButton(arg0.sceneParent, arg1, function()
		if arg0.sceneParent:isfrozen() then
			return
		end

		seriesAsync({
			function(arg0)
				if not arg0:TrySwitchNextMap(arg2) then
					return
				end

				pg.CriMgr.GetInstance():StopBGM()
				pg.CriMgr.GetInstance():PlaySE_V3("battle-ship-move")
				setActive(arg3, true)
				arg0.sceneParent:frozen()
				LeanTween.delayedCall(go(arg1), 1.8, System.Action(arg0))
			end,
			function(arg0)
				arg0.sceneParent:setMap(arg0.contextData.mapIdx + arg2)
				LeanTween.delayedCall(go(arg1), 0.5, System.Action(arg0))
			end,
			function(arg0)
				arg0.sceneParent:unfrozen()
			end
		})
	end)
end

function var0.PostUpdateMap(arg0, arg1)
	local var0 = arg0.contextData.map:getConfig("type") == Map.ACT_EXTRA

	setActive(arg0.buttonUp, false)
	setActive(arg0.effectUp, false)
	setActive(arg0.buttonDown, false)
	setActive(arg0.effectDown, false)

	if not var0 then
		setActive(arg0.sceneParent.btnPrev, false)
		setActive(arg0.sceneParent.btnNext, false)

		local var1 = getProxy(ChapterProxy):getMapsByActivities()
		local var2 = _.detect(var1, function(arg0)
			return arg0.id == arg1.id + 1
		end)
		local var3 = _.detect(var1, function(arg0)
			return arg0.id == arg1.id - 1
		end)

		setActive(arg0.buttonDown, var2)
		setActive(arg0.buttonUp, var3)
		LeanTween.cancel(go(arg0.buttonUp), true)
		LeanTween.cancel(go(arg0.buttonDown), true)
	end
end

function var0.UpdateMapItem(arg0, arg1, arg2)
	local var0 = arg2:getConfigTable()

	setAnchoredPosition(arg1, {
		x = arg0.mapWidth * var0.pos_x,
		y = arg0.mapHeight * var0.pos_y
	})

	local var1 = findTF(arg1, "main")

	setActive(var1, true)

	local var2 = findTF(var1, "info/bk/fordark")

	setActive(var2, var0.icon_outline == 1)

	local var3 = findTF(var1, "circle/clear_flag")
	local var4 = findTF(var1, "circle/lock")
	local var5 = not arg2.active and not arg2:isUnlock()
	local var6 = findTF(var1, "circle/progress")
	local var7 = findTF(var1, "circle/progress_text")
	local var8 = findTF(var1, "circle/stars")
	local var9 = string.split(var0.name, "|")
	local var10 = var1[arg0.data:GetConfigID()]

	arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), "stage_bar_" .. var10, var1:Find("info/bk"))
	arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), "chapter_progress_bg_" .. var10, var1:Find("circle/bk"))
	arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), "chapter_progress_circle_" .. var10, var1:Find("circle/progress/Fill/progress"))
	arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), "chapter_progress_wave_" .. var10, var1:Find("circle/progress/Mask/Handler/Wave"))
	arg0.loader:GetSpriteQuiet(arg0:GetAtlasPath(), "clear_text_" .. var10, var1:Find("circle/clear_flag"))
	setSlider(var1:Find("circle/progress"), 0, 1, arg2.progress / 100)

	local var11 = var5 and "#737373" or "#FFFFFF"

	setText(findTF(var1, "info/bk/title_form/title_index"), setColorStr(var0.chapter_name .. "  ", var11))
	setText(findTF(var1, "info/bk/title_form/title"), setColorStr(var9[1], var11))
	setText(findTF(var1, "info/bk/title_form/title_en"), setColorStr(var9[2] or "", var11))
	setText(var7, string.format("%d%%", arg2.progress))
	setActive(var8, arg2:existAchieve())

	if arg2:existAchieve() then
		for iter0, iter1 in ipairs(arg2.achieves) do
			local var12 = ChapterConst.IsAchieved(iter1)
			local var13 = var8:Find("star" .. iter0 .. "/light")

			setActive(var13, var12)
		end
	end

	local var14 = not arg2.active and arg2:isClear()

	setActive(var3, var14)
	setActive(var4, var5)
	setActive(var7, not var14 and not var5)
	arg0:DeleteTween("fighting" .. arg2.id)

	local var15 = findTF(var1, "circle/fighting")

	setText(findTF(var15, "Text"), i18n("tag_level_fighting"))

	local var16 = findTF(var1, "circle/oni")

	setText(findTF(var16, "Text"), i18n("tag_level_oni"))

	local var17 = findTF(var1, "circle/narrative")

	setText(findTF(var17, "Text"), i18n("tag_level_narrative"))
	setActive(var15, false)
	setActive(var16, false)
	setActive(var17, false)

	local var18
	local var19

	if arg2:getConfig("chapter_tag") == 1 then
		var18 = var17
	end

	if arg2.active then
		var18 = arg2:existOni() and var16 or var15
	end

	if var18 then
		setActive(var18, true)

		local var20 = GetOrAddComponent(var18, "CanvasGroup")

		var20.alpha = 1

		arg0:RecordTween("fighting" .. arg2.id, LeanTween.alphaCanvas(var20, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var21 = findTF(var1, "triesLimit")

	setActive(var21, false)

	if arg2:isTriesLimit() then
		local var22 = arg2:getConfig("count")
		local var23 = var22 - arg2:getTodayDefeatCount() .. "/" .. var22

		setText(var21:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var21:Find("Text"), setColorStr(var23, var22 <= arg2:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var24 = arg2:GetDailyBonusQuota()
	local var25 = findTF(var1, "mark")

	setActive(var25:Find("bonus"), var24)
	setActive(var25, var24)

	if var24 then
		local var26 = var25:GetComponent(typeof(CanvasGroup))
		local var27 = arg0.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var27, var25:Find("bonus"))
		LeanTween.cancel(go(var25), true)

		local var28 = var25.anchoredPosition.y

		var26.alpha = 0

		LeanTween.value(go(var25), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
			var26.alpha = arg0

			local var0 = var25.anchoredPosition

			var0.y = var28 * arg0
			var25.anchoredPosition = var0
		end)):setOnComplete(System.Action(function()
			var26.alpha = 1

			local var0 = var25.anchoredPosition

			var0.y = var28
			var25.anchoredPosition = var0
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var29 = arg2.id

	onButton(arg0.sceneParent, var1, function()
		if arg0:InvokeParent("isfrozen") then
			return
		end

		if arg0.chaptersInBackAnimating[var29] then
			return
		end

		local var0 = getProxy(ChapterProxy):getChapterById(var29)

		if not var0:isUnlock() then
			local var1 = var0:getPrevChapterName()

			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre", var1))

			return
		end

		if not getProxy(ChapterProxy):getMapById(var0:getConfig("map")):isRemaster() and not var0:inActTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_close"))

			return
		end

		local var2 = var0:getConfig("unlocklevel")

		if var2 > arg0.sceneParent.player.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", var2))

			return
		end

		local var3 = getProxy(ChapterProxy):getActiveChapter(true)

		if var3 and var3.id ~= var29 then
			arg0:InvokeParent("emit", LevelMediator2.ON_STRATEGYING_CHAPTER)

			return
		end

		if var0.active then
			arg0:InvokeParent("switchToChapter", var0)
		else
			local var4 = arg1.localPosition

			arg0:InvokeParent("displayChapterPanel", var0, Vector3(var4.x - 10, var4.y + 150))
		end
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0.OnDestroy(arg0)
	arg0.loader:Clear()
	var0.super.OnDestroy(arg0)
end

return var0
