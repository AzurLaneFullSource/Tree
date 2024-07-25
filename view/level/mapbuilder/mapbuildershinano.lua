local var0_0 = class("MapBuilderShinano", import(".MapBuilderPermanent"))

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.chapterTFsById = {}
	arg0_1.chaptersInBackAnimating = {}
end

function var0_0.GetType(arg0_2)
	return MapBuilder.TYPESHINANO
end

function var0_0.getUIName(arg0_3)
	return "Shinano_levels"
end

function var0_0.OnInit(arg0_4)
	arg0_4.tpl = arg0_4._tf:Find("level_tpl")

	setActive(arg0_4.tpl, false)

	arg0_4.itemHolder = arg0_4._tf:Find("items")

	local var0_4 = arg0_4._tf:Find("preloadResources"):GetComponent(typeof(ItemList))
	local var1_4 = Instantiate(var0_4.prefabItem[0])

	setAnchoredPosition(arg0_4._tf:Find("rumeng"), tf(var1_4).anchoredPosition)
	setParent(var1_4, arg0_4._tf:Find("rumeng"))
	setAnchoredPosition(var1_4, Vector2.zero)
	arg0_4:InitTransformMapBtn(arg0_4._tf:Find("rumeng"), 1, var0_4.prefabItem[1])

	local var2_4 = Instantiate(var0_4.prefabItem[2])

	setAnchoredPosition(arg0_4._tf:Find("huigui"), tf(var2_4).anchoredPosition)
	setParent(var2_4, arg0_4._tf:Find("huigui"))
	setAnchoredPosition(var2_4, Vector2.zero)
	arg0_4:InitTransformMapBtn(arg0_4._tf:Find("huigui"), -1, var0_4.prefabItem[3])
end

function var0_0.OnShow(arg0_5)
	var0_0.super.OnShow(arg0_5)
	setActive(arg0_5.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0_5.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0_5.sceneParent.topChapter:Find("type_skirmish"), true)
end

function var0_0.OnHide(arg0_6)
	setActive(arg0_6.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_6.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_6.sceneParent.topChapter:Find("type_skirmish"), false)
	table.clear(arg0_6.chaptersInBackAnimating)

	for iter0_6, iter1_6 in pairs(arg0_6.chapterTFsById) do
		local var0_6 = findTF(iter1_6, "main/info/bk")

		LeanTween.cancel(rtf(var0_6))
	end

	var0_0.super.OnHide(arg0_6)
end

function var0_0.TrySwitchNextMap(arg0_7, arg1_7)
	local var0_7 = arg0_7.contextData.mapIdx + arg1_7
	local var1_7 = getProxy(ChapterProxy):getMapById(var0_7)

	if not var1_7 then
		return
	end

	if var1_7:getMapType() == Map.ELITE and not var1_7:isEliteEnabled() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

		return
	end

	local var2_7, var3_7 = var1_7:isUnlock()

	if not var2_7 then
		pg.TipsMgr.GetInstance():ShowTips(var3_7)

		return
	end

	return true
end

function var0_0.InitTransformMapBtn(arg0_8, arg1_8, arg2_8, arg3_8)
	onButton(arg0_8, arg1_8, function()
		if arg0_8:isfrozen() then
			return
		end

		local var0_9

		seriesAsync({
			function(arg0_10)
				if not arg0_8:TrySwitchNextMap(arg2_8) then
					return
				end

				pg.CriMgr.GetInstance():StopBGM()
				pg.CriMgr.GetInstance():PlaySE_V3("ui-qiehuan")

				var0_9 = arg0_8._tf:Find(arg3_8.name .. "(Clone)") or Instantiate(arg3_8)

				setParent(var0_9, arg0_8._tf)
				setAnchoredPosition(var0_9, rtf(arg1_8).anchoredPosition)

				local var0_10 = arg0_8.contextData.mapIdx + arg2_8
				local var1_10 = Map.bindConfigTable(Map)[var0_10]

				if var1_10 and #var1_10.bg > 0 then
					GetSpriteFromAtlasAsync("levelmap/" .. var1_10.bg, "", function(arg0_11)
						return
					end)
				end

				arg0_8.sceneParent:frozen()
				LeanTween.delayedCall(go(arg1_8), 2.3, System.Action(arg0_10))
			end,
			function(arg0_12)
				arg0_8.sceneParent:setMap(arg0_8.contextData.mapIdx + arg2_8)
				LeanTween.delayedCall(go(arg1_8), 0.5, System.Action(arg0_12))
			end,
			function(arg0_13)
				if not IsNil(var0_9) then
					Destroy(var0_9)
				end

				arg0_8.sceneParent:unfrozen()
			end
		})
	end)
end

function var0_0.UpdateView(arg0_14)
	local var0_14 = string.split(arg0_14.contextData.map:getConfig("name"), "||")

	setText(arg0_14.sceneParent.chapterName, var0_14[1])

	local var1_14 = arg0_14.contextData.map:getMapTitleNumber()

	arg0_14.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_14, arg0_14.sceneParent.chapterNoTitle, true)
	var0_0.super.UpdateView(arg0_14)
end

function var0_0.UpdateButtons(arg0_15)
	var0_0.super.UpdateButtons(arg0_15)

	local var0_15 = arg0_15.contextData.map
	local var1_15 = var0_15:getConfig("type") == Map.ACT_EXTRA
	local var2_15 = arg0_15._tf:Find("rumeng")
	local var3_15 = arg0_15._tf:Find("huigui")

	setActive(var2_15, false)
	setActive(var3_15, false)

	if not var1_15 then
		setActive(arg0_15.sceneParent.btnPrev, false)
		setActive(arg0_15.sceneParent.btnNext, false)

		local var4_15 = getProxy(ChapterProxy):getMapById(var0_15.id + 1)
		local var5_15 = getProxy(ChapterProxy):getMapById(var0_15.id - 1)

		setActive(var2_15, var4_15)
		setActive(var3_15, var5_15)
		LeanTween.cancel(go(var2_15), true)
		LeanTween.cancel(go(var3_15), true)

		if var4_15 then
			local var6_15 = tf(var2_15).localScale
			local var7_15 = tf(var2_15):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var8_15 = var7_15:GetColor("_MainColor")
			local var9_15 = Clone(var8_15)
			local var10_15 = LeanTween.value(go(var2_15), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_16)
				var9_15.a = var8_15.a * arg0_16

				var7_15:SetColor("_MainColor", var9_15)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var7_15:SetColor("_MainColor", var8_15)
			end))

			arg0_15:RecordTween("rumengAlphaTween", var10_15.id)
		elseif var5_15 then
			local var11_15 = tf(var3_15).localScale
			local var12_15 = tf(var3_15):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var13_15 = var12_15:GetColor("_MainColor")
			local var14_15 = Clone(var13_15)
			local var15_15 = LeanTween.value(go(var3_15), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_18)
				var14_15.a = var13_15.a * arg0_18

				var12_15:SetColor("_MainColor", var14_15)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var12_15:SetColor("_MainColor", var13_15)
			end))

			arg0_15:RecordTween("huiguiAlphaTween", var15_15.id)
		end
	end
end

function var0_0.UpdateMapItems(arg0_20)
	var0_0.super.UpdateMapItems(arg0_20)

	local var0_20 = arg0_20.data
	local var1_20 = getProxy(ChapterProxy)

	table.clear(arg0_20.chapterTFsById)

	local var2_20 = {}

	for iter0_20, iter1_20 in pairs(var0_20:getChapters()) do
		if (iter1_20:isUnlock() or iter1_20:activeAlways()) and (not iter1_20:ifNeedHide() or var1_20:GetJustClearChapters(iter1_20.id)) then
			table.insert(var2_20, iter1_20)
		end
	end

	UIItemList.StaticAlign(arg0_20.itemHolder, arg0_20.tpl, #var2_20, function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var2_20[arg1_21 + 1]

			arg0_20:UpdateMapItem(arg2_21, var0_21)

			arg2_21.name = "Chapter_" .. var0_21.id
			arg0_20.chapterTFsById[var0_21.id] = arg2_21
		end
	end)

	local var3_20 = {}

	for iter2_20, iter3_20 in pairs(var2_20) do
		local var4_20 = iter3_20:getConfigTable()

		var3_20[var4_20.pos_x] = var3_20[var4_20.pos_x] or {}

		local var5_20 = var3_20[var4_20.pos_x]

		var5_20[var4_20.pos_y] = var5_20[var4_20.pos_y] or {}

		local var6_20 = var5_20[var4_20.pos_y]

		table.insert(var6_20, iter3_20)
	end

	for iter4_20, iter5_20 in pairs(var3_20) do
		for iter6_20, iter7_20 in pairs(iter5_20) do
			local var7_20 = {}

			seriesAsync({
				function(arg0_22)
					local var0_22 = 0

					for iter0_22, iter1_22 in pairs(iter7_20) do
						if iter1_22:ifNeedHide() and var1_20:GetJustClearChapters(iter1_22.id) and arg0_20.chapterTFsById[iter1_22.id] then
							var0_22 = var0_22 + 1

							local var1_22 = arg0_20.chapterTFsById[iter1_22.id]

							setActive(var1_22, true)
							arg0_20:PlayChapterItemAnimationBackward(var1_22, iter1_22, function()
								var0_22 = var0_22 - 1

								setActive(var1_22, false)
								var1_20:RecordJustClearChapters(iter1_22.id, nil)

								if var0_22 <= 0 then
									arg0_22()
								end
							end)

							var7_20[iter1_22.id] = true
						elseif arg0_20.chapterTFsById[iter1_22.id] then
							setActive(arg0_20.chapterTFsById[iter1_22.id], false)
						end
					end

					if var0_22 <= 0 then
						arg0_22()
					end
				end,
				function(arg0_24)
					local var0_24 = 0

					for iter0_24, iter1_24 in pairs(iter7_20) do
						if not var7_20[iter1_24.id] then
							var0_24 = var0_24 + 1

							setActive(arg0_20.chapterTFsById[iter1_24.id], true)
							arg0_20:PlayChapterItemAnimation(arg0_20.chapterTFsById[iter1_24.id], iter1_24, function()
								var0_24 = var0_24 - 1

								if var0_24 <= 0 then
									arg0_24()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var0_0.UpdateMapItem(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26:getConfigTable()

	setAnchoredPosition(arg1_26, {
		x = arg0_26.mapWidth * var0_26.pos_x,
		y = arg0_26.mapHeight * var0_26.pos_y
	})

	local var1_26 = findTF(arg1_26, "main")

	setActive(var1_26, true)

	local var2_26 = findTF(var1_26, "info/bk/fordark")

	setActive(var2_26, var0_26.icon_outline == 1)

	local var3_26 = findTF(var1_26, "circle/clear_flag")
	local var4_26 = findTF(var1_26, "circle/lock")
	local var5_26 = not arg2_26.active and not arg2_26:isUnlock()
	local var6_26 = findTF(var1_26, "circle/progress")
	local var7_26 = findTF(var1_26, "circle/progress_text")
	local var8_26 = findTF(var1_26, "circle/stars")
	local var9_26 = string.split(var0_26.name, "|")
	local var10_26 = var5_26 and "#737373" or "#FFFFFF"

	setText(findTF(var1_26, "info/bk/title_form/title_index"), setColorStr(var0_26.chapter_name .. "  ", var10_26))
	setText(findTF(var1_26, "info/bk/title_form/title"), setColorStr(var9_26[1], var10_26))
	setText(findTF(var1_26, "info/bk/title_form/title_en"), setColorStr(var9_26[2] or "", var10_26))
	setFillAmount(var6_26, arg2_26.progress / 100)
	setText(var7_26, string.format("%d%%", arg2_26.progress))
	setActive(var8_26, arg2_26:existAchieve())

	if arg2_26:existAchieve() then
		for iter0_26, iter1_26 in ipairs(arg2_26.achieves) do
			local var11_26 = ChapterConst.IsAchieved(iter1_26)
			local var12_26 = var8_26:Find("star" .. iter0_26 .. "/light")

			setActive(var12_26, var11_26)
		end
	end

	local var13_26 = not arg2_26.active and arg2_26:isClear()

	setActive(var3_26, var13_26)
	setActive(var4_26, var5_26)
	setActive(var7_26, not var13_26 and not var5_26)
	arg0_26:DeleteTween("fighting" .. arg2_26.id)

	local var14_26 = findTF(var1_26, "circle/fighting")

	setText(findTF(var14_26, "Text"), i18n("tag_level_fighting"))

	local var15_26 = findTF(var1_26, "circle/oni")

	setText(findTF(var15_26, "Text"), i18n("tag_level_oni"))

	local var16_26 = findTF(var1_26, "circle/narrative")

	setText(findTF(var16_26, "Text"), i18n("tag_level_narrative"))
	setActive(var14_26, false)
	setActive(var15_26, false)
	setActive(var16_26, false)

	local var17_26
	local var18_26

	if arg2_26:getConfig("chapter_tag") == 1 then
		var17_26 = var16_26
	end

	if arg2_26.active then
		var17_26 = arg2_26:existOni() and var15_26 or var14_26
	end

	if var17_26 then
		setActive(var17_26, true)

		local var19_26 = GetOrAddComponent(var17_26, "CanvasGroup")

		var19_26.alpha = 1

		arg0_26:RecordTween("fighting" .. arg2_26.id, LeanTween.alphaCanvas(var19_26, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var20_26 = findTF(var1_26, "triesLimit")

	setActive(var20_26, false)

	if arg2_26:isTriesLimit() then
		local var21_26 = arg2_26:getConfig("count")
		local var22_26 = var21_26 - arg2_26:getTodayDefeatCount() .. "/" .. var21_26

		setText(var20_26:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var20_26:Find("Text"), setColorStr(var22_26, var21_26 <= arg2_26:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var23_26 = arg2_26:GetDailyBonusQuota()
	local var24_26 = findTF(var1_26, "mark")

	setActive(var24_26:Find("bonus"), var23_26)
	setActive(var24_26, var23_26)

	if var23_26 then
		local var25_26 = var24_26:GetComponent(typeof(CanvasGroup))
		local var26_26 = arg0_26.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_26.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var26_26, var24_26:Find("bonus"))
		LeanTween.cancel(go(var24_26), true)

		local var27_26 = var24_26.anchoredPosition.y

		var25_26.alpha = 0

		LeanTween.value(go(var24_26), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_27)
			var25_26.alpha = arg0_27

			local var0_27 = var24_26.anchoredPosition

			var0_27.y = var27_26 * arg0_27
			var24_26.anchoredPosition = var0_27
		end)):setOnComplete(System.Action(function()
			var25_26.alpha = 1

			local var0_28 = var24_26.anchoredPosition

			var0_28.y = var27_26
			var24_26.anchoredPosition = var0_28
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var28_26 = arg2_26.id

	onButton(arg0_26, var1_26, function()
		if arg0_26.chaptersInBackAnimating[var28_26] then
			return
		end

		local var0_29 = arg1_26.localPosition

		arg0_26:TryOpenChapterInfo(var28_26, Vector3(var0_29.x - 10, var0_29.y + 150))
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.PlayChapterItemAnimation(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = findTF(arg1_30, "main")
	local var1_30 = var0_30:Find("info")
	local var2_30 = findTF(var0_30, "circle")
	local var3_30 = findTF(var0_30, "info/bk")

	LeanTween.cancel(go(var2_30))

	var2_30.localScale = Vector3.zero

	local var4_30 = LeanTween.scale(var2_30, Vector3.one, 0.3):setDelay(0.3)

	arg0_30:RecordTween(var4_30.uniqueId)
	LeanTween.cancel(go(var3_30))
	setAnchoredPosition(var3_30, {
		x = -1 * var1_30.rect.width
	})
	shiftPanel(var3_30, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_30:isTriesLimit() then
			setActive(findTF(var0_30, "triesLimit"), true)
		end

		if arg3_30 then
			arg3_30()
		end
	end)
end

function var0_0.PlayChapterItemAnimationBackward(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = findTF(arg1_32, "main")
	local var1_32 = var0_32:Find("info")
	local var2_32 = findTF(var0_32, "circle")
	local var3_32 = findTF(var0_32, "info/bk")

	LeanTween.cancel(go(var2_32))

	var2_32.localScale = Vector3.one

	local var4_32 = LeanTween.scale(go(var2_32), Vector3.zero, 0.3):setDelay(0.3)

	arg0_32:RecordTween(var4_32.uniqueId)

	arg0_32.chaptersInBackAnimating[arg2_32.id] = true

	LeanTween.cancel(go(var3_32))
	setAnchoredPosition(var3_32, {
		x = 0
	})
	shiftPanel(var3_32, -1 * var1_32.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_32.chaptersInBackAnimating[arg2_32.id] = nil

		if arg3_32 then
			arg3_32()
		end
	end)

	if arg2_32:isTriesLimit() then
		setActive(findTF(var0_32, "triesLimit"), false)
	end
end

function var0_0.UpdateChapterTF(arg0_34, arg1_34)
	local var0_34 = arg0_34.chapterTFsById[arg1_34]

	if var0_34 then
		local var1_34 = getProxy(ChapterProxy):getChapterById(arg1_34)

		arg0_34:UpdateMapItem(var0_34, var1_34)
		arg0_34:PlayChapterItemAnimation(var0_34, var1_34)
	end
end

function var0_0.TryOpenChapter(arg0_35, arg1_35)
	local var0_35 = arg0_35.chapterTFsById[arg1_35]

	if var0_35 then
		local var1_35 = var0_35:Find("main")

		triggerButton(var1_35)
	end
end

function var0_0.HideFloat(arg0_36)
	setActive(arg0_36.itemHolder, false)
end

function var0_0.ShowFloat(arg0_37)
	setActive(arg0_37.itemHolder, true)
end

return var0_0
