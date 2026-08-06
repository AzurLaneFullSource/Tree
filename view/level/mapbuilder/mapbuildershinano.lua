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

	local var2_16 = getProxy(ActivityProxy)
	local var3_16 = var2_16:getActivityById(var1_16)

	if not var3_16 or var3_16:isEnd() then
		return
	end

	local var4_16 = var3_16:GetConfigClientSetting("PTID")

	if not var4_16 then
		return
	end

	local var5_16 = underscore.detect(var2_16:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_17)
		return arg0_17 and not arg0_17:isEnd() and arg0_17:getConfig("config_id") == var4_16
	end)

	if not var5_16 then
		return
	end

	local var6_16 = tonumber(var5_16:getConfig("config_id"))

	if not var6_16 then
		return
	end

	arg0_16.bonusPtIconPath = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var6_16
	}):getIcon()
end

function var0_0.UpdateCustomButtons(arg0_18)
	local var0_18 = arg0_18.contextData.map
	local var1_18 = var0_18:getConfig("type") == Map.ACT_EXTRA
	local var2_18 = arg0_18._tf:Find("rumeng")
	local var3_18 = arg0_18._tf:Find("huigui")

	setActive(var2_18, false)
	setActive(var3_18, false)

	if not var1_18 then
		setActive(arg0_18.sceneParent.btnPrev, false)
		setActive(arg0_18.sceneParent.btnNext, false)

		local var4_18 = getProxy(ChapterProxy):getMapById(var0_18.id + 1)
		local var5_18 = getProxy(ChapterProxy):getMapById(var0_18.id - 1)

		setActive(var2_18, var4_18)
		setActive(var3_18, var5_18)
		LeanTween.cancel(go(var2_18), true)
		LeanTween.cancel(go(var3_18), true)

		if var4_18 then
			local var6_18 = tf(var2_18).localScale
			local var7_18 = tf(var2_18):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var8_18 = var7_18:GetColor("_MainColor")
			local var9_18 = Clone(var8_18)
			local var10_18 = LeanTween.value(go(var2_18), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_19)
				var9_18.a = var8_18.a * arg0_19

				var7_18:SetColor("_MainColor", var9_18)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var7_18:SetColor("_MainColor", var8_18)
			end))

			arg0_18:RecordTween("rumengAlphaTween", var10_18.id)
		elseif var5_18 then
			local var11_18 = tf(var3_18).localScale
			local var12_18 = tf(var3_18):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var13_18 = var12_18:GetColor("_MainColor")
			local var14_18 = Clone(var13_18)
			local var15_18 = LeanTween.value(go(var3_18), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_21)
				var14_18.a = var13_18.a * arg0_21

				var12_18:SetColor("_MainColor", var14_18)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var12_18:SetColor("_MainColor", var13_18)
			end))

			arg0_18:RecordTween("huiguiAlphaTween", var15_18.id)
		end
	end
end

function var0_0.UpdateMapItems(arg0_23)
	var0_0.super.UpdateMapItems(arg0_23)

	local var0_23 = arg0_23.data
	local var1_23 = getProxy(ChapterProxy)

	arg0_23:UpdateBonusPtIconPath()
	table.clear(arg0_23.chapterTFsById)

	local var2_23 = {}

	for iter0_23, iter1_23 in pairs(var0_23:getChapters()) do
		if (iter1_23:isUnlock() or iter1_23:activeAlways()) and (not iter1_23:ifNeedHide() or var1_23:GetJustClearChapters(iter1_23.id)) then
			table.insert(var2_23, iter1_23)
		end
	end

	UIItemList.StaticAlign(arg0_23.itemHolder, arg0_23.tpl, #var2_23, function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = var2_23[arg1_24 + 1]

			arg0_23:UpdateMapItem(arg2_24, var0_24)

			arg2_24.name = "Chapter_" .. var0_24.id
			arg0_23.chapterTFsById[var0_24.id] = arg2_24
		end
	end)

	local var3_23 = {}

	for iter2_23, iter3_23 in pairs(var2_23) do
		local var4_23 = iter3_23:getConfigTable()

		var3_23[var4_23.pos_x] = var3_23[var4_23.pos_x] or {}

		local var5_23 = var3_23[var4_23.pos_x]

		var5_23[var4_23.pos_y] = var5_23[var4_23.pos_y] or {}

		local var6_23 = var5_23[var4_23.pos_y]

		table.insert(var6_23, iter3_23)
	end

	for iter4_23, iter5_23 in pairs(var3_23) do
		for iter6_23, iter7_23 in pairs(iter5_23) do
			local var7_23 = {}

			seriesAsync({
				function(arg0_25)
					local var0_25 = 0

					for iter0_25, iter1_25 in pairs(iter7_23) do
						if iter1_25:ifNeedHide() and var1_23:GetJustClearChapters(iter1_25.id) and arg0_23.chapterTFsById[iter1_25.id] then
							var0_25 = var0_25 + 1

							local var1_25 = arg0_23.chapterTFsById[iter1_25.id]

							setActive(var1_25, true)
							arg0_23:PlayChapterItemAnimationBackward(var1_25, iter1_25, function()
								var0_25 = var0_25 - 1

								setActive(var1_25, false)
								var1_23:RecordJustClearChapters(iter1_25.id, nil)

								if var0_25 <= 0 then
									arg0_25()
								end
							end)

							var7_23[iter1_25.id] = true
						elseif arg0_23.chapterTFsById[iter1_25.id] then
							setActive(arg0_23.chapterTFsById[iter1_25.id], false)
						end
					end

					if var0_25 <= 0 then
						arg0_25()
					end
				end,
				function(arg0_27)
					local var0_27 = 0

					for iter0_27, iter1_27 in pairs(iter7_23) do
						if not var7_23[iter1_27.id] then
							var0_27 = var0_27 + 1

							setActive(arg0_23.chapterTFsById[iter1_27.id], true)
							arg0_23:PlayChapterItemAnimation(arg0_23.chapterTFsById[iter1_27.id], iter1_27, function()
								var0_27 = var0_27 - 1

								if var0_27 <= 0 then
									arg0_27()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var0_0.UpdateMapItem(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg2_29:getConfigTable()

	setLocalPosition(arg1_29, {
		x = 1920 * var0_29.pos_x,
		y = 1080 * var0_29.pos_y
	})

	local var1_29 = findTF(arg1_29, "main")

	setActive(var1_29, true)

	local var2_29 = findTF(var1_29, "info/bk/fordark")

	setActive(var2_29, var0_29.icon_outline == 1)

	local var3_29 = findTF(var1_29, "circle/clear_flag")
	local var4_29 = findTF(var1_29, "circle/lock")
	local var5_29 = not arg2_29.active and not arg2_29:isUnlock()
	local var6_29 = findTF(var1_29, "circle/progress")
	local var7_29 = findTF(var1_29, "circle/progress_text")
	local var8_29 = findTF(var1_29, "circle/stars")
	local var9_29 = string.split(var0_29.name, "|")
	local var10_29 = var5_29 and "#737373" or "#FFFFFF"

	setText(findTF(var1_29, "info/bk/title_form/title_index"), setColorStr(var0_29.chapter_name .. "  ", var10_29))
	setText(findTF(var1_29, "info/bk/title_form/title"), setColorStr(var9_29[1], var10_29))
	setText(findTF(var1_29, "info/bk/title_form/title_en"), setColorStr(var9_29[2] or "", var10_29))
	setFillAmount(var6_29, arg2_29.progress / 100)
	setText(var7_29, string.format("%d%%", arg2_29.progress))
	setActive(var8_29, arg2_29:existAchieve())

	if arg2_29:existAchieve() then
		for iter0_29, iter1_29 in ipairs(arg2_29.achieves) do
			local var11_29 = ChapterConst.IsAchieved(iter1_29)
			local var12_29 = var8_29:Find("star" .. iter0_29 .. "/light")

			setActive(var12_29, var11_29)
		end
	end

	local var13_29 = not arg2_29.active and arg2_29:isClear()

	setActive(var3_29, var13_29)
	setActive(var4_29, var5_29)
	setActive(var7_29, not var13_29 and not var5_29)
	arg0_29:DeleteTween("fighting" .. arg2_29.id)

	local var14_29 = findTF(var1_29, "circle/fighting")

	setText(findTF(var14_29, "Text"), i18n("tag_level_fighting"))

	local var15_29 = findTF(var1_29, "circle/oni")

	setText(findTF(var15_29, "Text"), i18n("tag_level_oni"))

	local var16_29 = findTF(var1_29, "circle/narrative")

	setText(findTF(var16_29, "Text"), i18n("tag_level_narrative"))
	setActive(var14_29, false)
	setActive(var15_29, false)
	setActive(var16_29, false)

	local var17_29
	local var18_29

	if arg2_29:getConfig("chapter_tag") == 1 then
		var17_29 = var16_29
	end

	if arg2_29.active then
		var17_29 = arg2_29:existOni() and var15_29 or var14_29
	end

	if var17_29 then
		setActive(var17_29, true)

		local var19_29 = GetOrAddComponent(var17_29, "CanvasGroup")

		var19_29.alpha = 1

		arg0_29:RecordTween("fighting" .. arg2_29.id, LeanTween.alphaCanvas(var19_29, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var20_29 = findTF(var1_29, "triesLimit")

	setActive(var20_29, false)

	if arg2_29:isTriesLimit() then
		local var21_29 = arg2_29:getConfig("count")
		local var22_29 = var21_29 - arg2_29:getTodayDefeatCount() .. "/" .. var21_29

		setText(var20_29:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var20_29:Find("Text"), setColorStr(var22_29, var21_29 <= arg2_29:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var23_29 = arg2_29:GetDailyBonusQuota()
	local var24_29 = findTF(var1_29, "mark")
	local var25_29 = var24_29:Find("bonus")
	local var26_29 = var25_29:Find("icon")
	local var27_29 = findTF(var25_29, "icon/Image")

	setActive(var25_29, var23_29)
	setActive(var24_29, var23_29)

	if var26_29 then
		setActive(var26_29, var23_29 and arg0_29.bonusPtIconPath)
	end

	if var23_29 then
		local var28_29 = var24_29:GetComponent(typeof(CanvasGroup))
		local var29_29 = arg2_29:GetDailyBonusIconName()

		arg0_29.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var29_29, var25_29)

		if var26_29 and arg0_29.bonusPtIconPath then
			if var27_29 then
				GetImageSpriteFromAtlasAsync(arg0_29.bonusPtIconPath, "", var27_29, true)
			else
				GetImageSpriteFromAtlasAsync(arg0_29.bonusPtIconPath, "", var26_29, true)
			end
		end

		LeanTween.cancel(go(var24_29), true)

		local var30_29 = var24_29.anchoredPosition.y

		var28_29.alpha = 0

		LeanTween.value(go(var24_29), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_30)
			var28_29.alpha = arg0_30

			local var0_30 = var24_29.anchoredPosition

			var0_30.y = var30_29 * arg0_30
			var24_29.anchoredPosition = var0_30
		end)):setOnComplete(System.Action(function()
			var28_29.alpha = 1

			local var0_31 = var24_29.anchoredPosition

			var0_31.y = var30_29
			var24_29.anchoredPosition = var0_31
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var31_29 = arg2_29.id

	onButton(arg0_29, var1_29, function()
		if arg0_29.chaptersInBackAnimating[var31_29] then
			return
		end

		local var0_32 = arg1_29.localPosition

		arg0_29:TryOpenChapterInfo(var31_29, Vector3(var0_32.x - 10, var0_32.y + 150))
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var0_0.PlayChapterItemAnimation(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = findTF(arg1_33, "main")
	local var1_33 = var0_33:Find("info")
	local var2_33 = findTF(var0_33, "circle")
	local var3_33 = findTF(var0_33, "info/bk")

	LeanTween.cancel(go(var2_33))

	var2_33.localScale = Vector3.zero

	local var4_33 = LeanTween.scale(var2_33, Vector3.one, 0.3):setDelay(0.3)

	arg0_33:RecordTween(var4_33.uniqueId)
	LeanTween.cancel(go(var3_33))
	setAnchoredPosition(var3_33, {
		x = -1 * var1_33.rect.width
	})
	shiftPanel(var3_33, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_33:isTriesLimit() then
			setActive(findTF(var0_33, "triesLimit"), true)
		end

		if arg3_33 then
			arg3_33()
		end
	end)
end

function var0_0.PlayChapterItemAnimationBackward(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = findTF(arg1_35, "main")
	local var1_35 = var0_35:Find("info")
	local var2_35 = findTF(var0_35, "circle")
	local var3_35 = findTF(var0_35, "info/bk")

	LeanTween.cancel(go(var2_35))

	var2_35.localScale = Vector3.one

	local var4_35 = LeanTween.scale(go(var2_35), Vector3.zero, 0.3):setDelay(0.3)

	arg0_35:RecordTween(var4_35.uniqueId)

	arg0_35.chaptersInBackAnimating[arg2_35.id] = true

	LeanTween.cancel(go(var3_35))
	setAnchoredPosition(var3_35, {
		x = 0
	})
	shiftPanel(var3_35, -1 * var1_35.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_35.chaptersInBackAnimating[arg2_35.id] = nil

		if arg3_35 then
			arg3_35()
		end
	end)

	if arg2_35:isTriesLimit() then
		setActive(findTF(var0_35, "triesLimit"), false)
	end
end

function var0_0.UpdateChapterTF(arg0_37, arg1_37)
	local var0_37 = arg0_37.chapterTFsById[arg1_37]

	if var0_37 then
		local var1_37 = getProxy(ChapterProxy):getChapterById(arg1_37)

		arg0_37:UpdateMapItem(var0_37, var1_37)
		arg0_37:PlayChapterItemAnimation(var0_37, var1_37)
	end
end

function var0_0.TryOpenChapter(arg0_38, arg1_38)
	local var0_38 = arg0_38.chapterTFsById[arg1_38]

	if var0_38 then
		local var1_38 = var0_38:Find("main")

		triggerButton(var1_38)
	end
end

function var0_0.HideFloat(arg0_39)
	setActive(arg0_39.itemHolder, false)
end

function var0_0.ShowFloat(arg0_40)
	setActive(arg0_40.itemHolder, true)
end

return var0_0
