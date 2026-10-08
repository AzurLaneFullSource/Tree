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

	local var0_4 = arg0_4._tf:Find("preloadResources")
	local var1_4 = var0_4:Find("mengjing_rumeng")

	setAnchoredPosition(arg0_4._tf:Find("rumeng"), tf(var1_4).anchoredPosition)
	setParent(var1_4, arg0_4._tf:Find("rumeng"))
	setAnchoredPosition(var1_4, Vector2.zero)
	arg0_4:InitTransformMapBtn(arg0_4._tf:Find("rumeng"), 1, var0_4:Find("mengjing_rumeng_zhuangchang"))

	local var2_4 = var0_4:Find("mengjing_huigui")

	setAnchoredPosition(arg0_4._tf:Find("huigui"), tf(var2_4).anchoredPosition)
	setParent(var2_4, arg0_4._tf:Find("huigui"))
	setAnchoredPosition(var2_4, Vector2.zero)
	arg0_4:InitTransformMapBtn(arg0_4._tf:Find("huigui"), -1, var0_4:Find("mengjing_huigui_zhuangchang"))
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
	arg0_15:UpdateCustomButtons()
end

function var0_0.UpdateBonusPtIconPath(arg0_16)
	arg0_16.bonusPtIconPath = nil

	local var0_16 = arg0_16.data or arg0_16.contextData.map

	if not var0_16 then
		return
	end

	local var1_16 = var0_16:getConfig("on_activity")

	if not var1_16 or var1_16 == 0 then
		return
	end

	local var2_16 = getProxy(ActivityProxy):getActivityById(var1_16)

	if not var2_16 or var2_16:isEnd() then
		return
	end

	local var3_16 = var2_16:GetConfigClientPTActivity()

	if not var3_16 then
		return
	end

	arg0_16.bonusPtIconPath = var3_16:GetPTDrop():getIcon()
end

function var0_0.UpdateCustomButtons(arg0_17)
	local var0_17 = arg0_17.contextData.map
	local var1_17 = var0_17:getConfig("type") == Map.ACT_EXTRA
	local var2_17 = arg0_17._tf:Find("rumeng")
	local var3_17 = arg0_17._tf:Find("huigui")

	setActive(var2_17, false)
	setActive(var3_17, false)

	if not var1_17 then
		setActive(arg0_17.sceneParent.btnPrev, false)
		setActive(arg0_17.sceneParent.btnNext, false)

		local var4_17 = getProxy(ChapterProxy):getMapById(var0_17.id + 1)
		local var5_17 = getProxy(ChapterProxy):getMapById(var0_17.id - 1)

		setActive(var2_17, var4_17)
		setActive(var3_17, var5_17)
		LeanTween.cancel(go(var2_17), true)
		LeanTween.cancel(go(var3_17), true)

		if var4_17 then
			local var6_17 = tf(var2_17).localScale
			local var7_17 = tf(var2_17):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var8_17 = var7_17:GetColor("_MainColor")
			local var9_17 = Clone(var8_17)
			local var10_17 = LeanTween.value(go(var2_17), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_18)
				var9_17.a = var8_17.a * arg0_18

				var7_17:SetColor("_MainColor", var9_17)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var7_17:SetColor("_MainColor", var8_17)
			end))

			arg0_17:RecordTween("rumengAlphaTween", var10_17.id)
		elseif var5_17 then
			local var11_17 = tf(var3_17).localScale
			local var12_17 = tf(var3_17):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var13_17 = var12_17:GetColor("_MainColor")
			local var14_17 = Clone(var13_17)
			local var15_17 = LeanTween.value(go(var3_17), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_20)
				var14_17.a = var13_17.a * arg0_20

				var12_17:SetColor("_MainColor", var14_17)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var12_17:SetColor("_MainColor", var13_17)
			end))

			arg0_17:RecordTween("huiguiAlphaTween", var15_17.id)
		end
	end
end

function var0_0.UpdateMapItems(arg0_22)
	var0_0.super.UpdateMapItems(arg0_22)

	local var0_22 = arg0_22.data
	local var1_22 = getProxy(ChapterProxy)

	arg0_22:UpdateBonusPtIconPath()
	table.clear(arg0_22.chapterTFsById)

	local var2_22 = {}

	for iter0_22, iter1_22 in pairs(var0_22:getChapters()) do
		if (iter1_22:isUnlock() or iter1_22:activeAlways()) and (not iter1_22:ifNeedHide() or var1_22:GetJustClearChapters(iter1_22.id)) then
			table.insert(var2_22, iter1_22)
		end
	end

	UIItemList.StaticAlign(arg0_22.itemHolder, arg0_22.tpl, #var2_22, function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = var2_22[arg1_23 + 1]

			arg0_22:UpdateMapItem(arg2_23, var0_23)

			arg2_23.name = "Chapter_" .. var0_23.id
			arg0_22.chapterTFsById[var0_23.id] = arg2_23
		end
	end)

	local var3_22 = {}

	for iter2_22, iter3_22 in pairs(var2_22) do
		local var4_22 = iter3_22:getConfigTable()

		var3_22[var4_22.pos_x] = var3_22[var4_22.pos_x] or {}

		local var5_22 = var3_22[var4_22.pos_x]

		var5_22[var4_22.pos_y] = var5_22[var4_22.pos_y] or {}

		local var6_22 = var5_22[var4_22.pos_y]

		table.insert(var6_22, iter3_22)
	end

	for iter4_22, iter5_22 in pairs(var3_22) do
		for iter6_22, iter7_22 in pairs(iter5_22) do
			local var7_22 = {}

			seriesAsync({
				function(arg0_24)
					local var0_24 = 0

					for iter0_24, iter1_24 in pairs(iter7_22) do
						if iter1_24:ifNeedHide() and var1_22:GetJustClearChapters(iter1_24.id) and arg0_22.chapterTFsById[iter1_24.id] then
							var0_24 = var0_24 + 1

							local var1_24 = arg0_22.chapterTFsById[iter1_24.id]

							setActive(var1_24, true)
							arg0_22:PlayChapterItemAnimationBackward(var1_24, iter1_24, function()
								var0_24 = var0_24 - 1

								setActive(var1_24, false)
								var1_22:RecordJustClearChapters(iter1_24.id, nil)

								if var0_24 <= 0 then
									arg0_24()
								end
							end)

							var7_22[iter1_24.id] = true
						elseif arg0_22.chapterTFsById[iter1_24.id] then
							setActive(arg0_22.chapterTFsById[iter1_24.id], false)
						end
					end

					if var0_24 <= 0 then
						arg0_24()
					end
				end,
				function(arg0_26)
					local var0_26 = 0

					for iter0_26, iter1_26 in pairs(iter7_22) do
						if not var7_22[iter1_26.id] then
							var0_26 = var0_26 + 1

							setActive(arg0_22.chapterTFsById[iter1_26.id], true)
							arg0_22:PlayChapterItemAnimation(arg0_22.chapterTFsById[iter1_26.id], iter1_26, function()
								var0_26 = var0_26 - 1

								if var0_26 <= 0 then
									arg0_26()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var0_0.UpdateMapItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28:getConfigTable()

	setLocalPosition(arg1_28, {
		x = 1920 * var0_28.pos_x,
		y = 1080 * var0_28.pos_y
	})

	local var1_28 = findTF(arg1_28, "main")

	setActive(var1_28, true)

	local var2_28 = findTF(var1_28, "info/bk/fordark")

	setActive(var2_28, var0_28.icon_outline == 1)

	local var3_28 = findTF(var1_28, "circle/clear_flag")
	local var4_28 = findTF(var1_28, "circle/lock")
	local var5_28 = not arg2_28.active and not arg2_28:isUnlock()
	local var6_28 = findTF(var1_28, "circle/progress")
	local var7_28 = findTF(var1_28, "circle/progress_text")
	local var8_28 = findTF(var1_28, "circle/stars")
	local var9_28 = string.split(var0_28.name, "|")
	local var10_28 = var5_28 and "#737373" or "#FFFFFF"

	setText(findTF(var1_28, "info/bk/title_form/title_index"), setColorStr(var0_28.chapter_name .. "  ", var10_28))
	setText(findTF(var1_28, "info/bk/title_form/title"), setColorStr(var9_28[1], var10_28))
	setText(findTF(var1_28, "info/bk/title_form/title_en"), setColorStr(var9_28[2] or "", var10_28))
	setFillAmount(var6_28, arg2_28.progress / 100)
	setText(var7_28, string.format("%d%%", arg2_28.progress))
	setActive(var8_28, arg2_28:existAchieve())

	if arg2_28:existAchieve() then
		for iter0_28, iter1_28 in ipairs(arg2_28.achieves) do
			local var11_28 = ChapterConst.IsAchieved(iter1_28)
			local var12_28 = var8_28:Find("star" .. iter0_28 .. "/light")

			setActive(var12_28, var11_28)
		end
	end

	local var13_28 = not arg2_28.active and arg2_28:isClear()

	setActive(var3_28, var13_28)
	setActive(var4_28, var5_28)
	setActive(var7_28, not var13_28 and not var5_28)
	arg0_28:DeleteTween("fighting" .. arg2_28.id)

	local var14_28 = findTF(var1_28, "circle/fighting")

	setText(findTF(var14_28, "Text"), i18n("tag_level_fighting"))

	local var15_28 = findTF(var1_28, "circle/oni")

	setText(findTF(var15_28, "Text"), i18n("tag_level_oni"))

	local var16_28 = findTF(var1_28, "circle/narrative")

	setText(findTF(var16_28, "Text"), i18n("tag_level_narrative"))
	setActive(var14_28, false)
	setActive(var15_28, false)
	setActive(var16_28, false)

	local var17_28
	local var18_28

	if arg2_28:getConfig("chapter_tag") == 1 then
		var17_28 = var16_28
	end

	if arg2_28.active then
		var17_28 = arg2_28:existOni() and var15_28 or var14_28
	end

	if var17_28 then
		setActive(var17_28, true)

		local var19_28 = GetOrAddComponent(var17_28, "CanvasGroup")

		var19_28.alpha = 1

		arg0_28:RecordTween("fighting" .. arg2_28.id, LeanTween.alphaCanvas(var19_28, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var20_28 = findTF(var1_28, "triesLimit")

	setActive(var20_28, false)

	if arg2_28:isTriesLimit() then
		local var21_28 = arg2_28:getConfig("count")
		local var22_28 = var21_28 - arg2_28:getTodayDefeatCount() .. "/" .. var21_28

		setText(var20_28:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var20_28:Find("Text"), setColorStr(var22_28, var21_28 <= arg2_28:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var23_28 = arg2_28:GetDailyBonusQuota()
	local var24_28 = findTF(var1_28, "mark")
	local var25_28 = var24_28:Find("bonus")
	local var26_28 = var25_28:Find("icon")
	local var27_28 = findTF(var25_28, "icon/Image")

	setActive(var25_28, var23_28)
	setActive(var24_28, var23_28)

	if var26_28 then
		setActive(var26_28, var23_28 and arg0_28.bonusPtIconPath)
	end

	if var23_28 then
		local var28_28 = var24_28:GetComponent(typeof(CanvasGroup))
		local var29_28 = arg2_28:GetDailyBonusIconName()

		arg0_28.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var29_28, var25_28)

		if var26_28 and arg0_28.bonusPtIconPath then
			if var27_28 then
				GetImageSpriteFromAtlasAsync(arg0_28.bonusPtIconPath, "", var27_28, true)
			else
				GetImageSpriteFromAtlasAsync(arg0_28.bonusPtIconPath, "", var26_28, true)
			end
		end

		LeanTween.cancel(go(var24_28), true)

		local var30_28 = var24_28.anchoredPosition.y

		var28_28.alpha = 0

		LeanTween.value(go(var24_28), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_29)
			var28_28.alpha = arg0_29

			local var0_29 = var24_28.anchoredPosition

			var0_29.y = var30_28 * arg0_29
			var24_28.anchoredPosition = var0_29
		end)):setOnComplete(System.Action(function()
			var28_28.alpha = 1

			local var0_30 = var24_28.anchoredPosition

			var0_30.y = var30_28
			var24_28.anchoredPosition = var0_30
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var31_28 = arg2_28.id

	onButton(arg0_28, var1_28, function()
		if arg0_28.chaptersInBackAnimating[var31_28] then
			return
		end

		local var0_31 = arg1_28.localPosition

		arg0_28:TryOpenChapterInfo(var31_28, Vector3(var0_31.x - 10, var0_31.y + 150))
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.PlayChapterItemAnimation(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = findTF(arg1_32, "main")
	local var1_32 = var0_32:Find("info")
	local var2_32 = findTF(var0_32, "circle")
	local var3_32 = findTF(var0_32, "info/bk")

	LeanTween.cancel(go(var2_32))

	var2_32.localScale = Vector3.zero

	local var4_32 = LeanTween.scale(var2_32, Vector3.one, 0.3):setDelay(0.3)

	arg0_32:RecordTween(var4_32.uniqueId)
	LeanTween.cancel(go(var3_32))
	setAnchoredPosition(var3_32, {
		x = -1 * var1_32.rect.width
	})
	shiftPanel(var3_32, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_32:isTriesLimit() then
			setActive(findTF(var0_32, "triesLimit"), true)
		end

		if arg3_32 then
			arg3_32()
		end
	end)
end

function var0_0.PlayChapterItemAnimationBackward(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = findTF(arg1_34, "main")
	local var1_34 = var0_34:Find("info")
	local var2_34 = findTF(var0_34, "circle")
	local var3_34 = findTF(var0_34, "info/bk")

	LeanTween.cancel(go(var2_34))

	var2_34.localScale = Vector3.one

	local var4_34 = LeanTween.scale(go(var2_34), Vector3.zero, 0.3):setDelay(0.3)

	arg0_34:RecordTween(var4_34.uniqueId)

	arg0_34.chaptersInBackAnimating[arg2_34.id] = true

	LeanTween.cancel(go(var3_34))
	setAnchoredPosition(var3_34, {
		x = 0
	})
	shiftPanel(var3_34, -1 * var1_34.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_34.chaptersInBackAnimating[arg2_34.id] = nil

		if arg3_34 then
			arg3_34()
		end
	end)

	if arg2_34:isTriesLimit() then
		setActive(findTF(var0_34, "triesLimit"), false)
	end
end

function var0_0.UpdateChapterTF(arg0_36, arg1_36)
	local var0_36 = arg0_36.chapterTFsById[arg1_36]

	if var0_36 then
		local var1_36 = getProxy(ChapterProxy):getChapterById(arg1_36)

		arg0_36:UpdateMapItem(var0_36, var1_36)
		arg0_36:PlayChapterItemAnimation(var0_36, var1_36)
	end
end

function var0_0.TryOpenChapter(arg0_37, arg1_37)
	local var0_37 = arg0_37.chapterTFsById[arg1_37]

	if var0_37 then
		local var1_37 = var0_37:Find("main")

		triggerButton(var1_37)
	end
end

function var0_0.HideFloat(arg0_38)
	setActive(arg0_38.itemHolder, false)
end

function var0_0.ShowFloat(arg0_39)
	setActive(arg0_39.itemHolder, true)
end

return var0_0
