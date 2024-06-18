local var0_0 = import(".MapBuilder")
local var1_0 = class("MapBuilderShinano", var0_0)

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)

	arg0_1.chapterTFsById = {}
	arg0_1.chaptersInBackAnimating = {}
end

function var1_0.GetType(arg0_2)
	return var0_0.TYPESHINANO
end

function var1_0.getUIName(arg0_3)
	return "Shinano_levels"
end

function var1_0.OnInit(arg0_4)
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

function var1_0.OnShow(arg0_5)
	setActive(arg0_5.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0_5.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0_5.sceneParent.topChapter:Find("type_skirmish"), true)
end

function var1_0.OnHide(arg0_6)
	setActive(arg0_6.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_6.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_6.sceneParent.topChapter:Find("type_skirmish"), false)
	table.clear(arg0_6.chaptersInBackAnimating)

	for iter0_6, iter1_6 in pairs(arg0_6.chapterTFsById) do
		local var0_6 = findTF(iter1_6, "main/info/bk")

		LeanTween.cancel(rtf(var0_6))
	end

	var1_0.super.OnHide(arg0_6)
end

function var1_0.TrySwitchNextMap(arg0_7, arg1_7)
	local var0_7 = arg0_7.sceneParent.contextData.mapIdx + arg1_7
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

function var1_0.InitTransformMapBtn(arg0_8, arg1_8, arg2_8, arg3_8)
	onButton(arg0_8.sceneParent, arg1_8, function()
		if arg0_8.sceneParent:isfrozen() then
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

function var1_0.Update(arg0_14, arg1_14)
	arg0_14.float.pivot = Vector2(0.5, 0.5)
	arg0_14.float.anchoredPosition = Vector2(0, 0)

	local var0_14 = string.split(arg1_14:getConfig("name"), "||")

	setText(arg0_14.sceneParent.chapterName, var0_14[1])

	local var1_14 = arg1_14:getMapTitleNumber()

	arg0_14.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1_14, arg0_14.sceneParent.chapterNoTitle, true)
	var1_0.super.Update(arg0_14, arg1_14)
end

function var1_0.UpdateButtons(arg0_15)
	arg0_15.sceneParent:updateDifficultyBtns()
	arg0_15.sceneParent:updateActivityBtns()
end

function var1_0.PostUpdateMap(arg0_16, arg1_16)
	local var0_16 = arg0_16.contextData.map:getConfig("type") == Map.ACT_EXTRA
	local var1_16 = arg0_16._tf:Find("rumeng")
	local var2_16 = arg0_16._tf:Find("huigui")

	setActive(var1_16, false)
	setActive(var2_16, false)

	if not var0_16 then
		setActive(arg0_16.sceneParent.btnPrev, false)
		setActive(arg0_16.sceneParent.btnNext, false)

		local var3_16 = getProxy(ChapterProxy):getMapById(arg1_16.id + 1)
		local var4_16 = getProxy(ChapterProxy):getMapById(arg1_16.id - 1)

		setActive(var1_16, var3_16)
		setActive(var2_16, var4_16)
		LeanTween.cancel(go(var1_16), true)
		LeanTween.cancel(go(var2_16), true)

		if var3_16 then
			local var5_16 = tf(var1_16).localScale
			local var6_16 = tf(var1_16):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var7_16 = var6_16:GetColor("_MainColor")
			local var8_16 = Clone(var7_16)
			local var9_16 = LeanTween.value(go(var1_16), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_17)
				var8_16.a = var7_16.a * arg0_17

				var6_16:SetColor("_MainColor", var8_16)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var6_16:SetColor("_MainColor", var7_16)
			end))

			arg0_16:RecordTween("rumengAlphaTween", var9_16.id)
		elseif var4_16 then
			local var10_16 = tf(var2_16).localScale
			local var11_16 = tf(var2_16):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var12_16 = var11_16:GetColor("_MainColor")
			local var13_16 = Clone(var12_16)
			local var14_16 = LeanTween.value(go(var2_16), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0_19)
				var13_16.a = var12_16.a * arg0_19

				var11_16:SetColor("_MainColor", var13_16)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var11_16:SetColor("_MainColor", var12_16)
			end))

			arg0_16:RecordTween("huiguiAlphaTween", var14_16.id)
		end
	end
end

function var1_0.UpdateMapItems(arg0_21)
	if not arg0_21:isShowing() then
		return
	end

	var1_0.super.UpdateMapItems(arg0_21)

	local var0_21 = arg0_21.data
	local var1_21 = getProxy(ChapterProxy)

	table.clear(arg0_21.chapterTFsById)

	local var2_21 = {}

	for iter0_21, iter1_21 in pairs(var0_21:getChapters()) do
		if (iter1_21:isUnlock() or iter1_21:activeAlways()) and (not iter1_21:ifNeedHide() or var1_21:GetJustClearChapters(iter1_21.id)) then
			table.insert(var2_21, iter1_21)
		end
	end

	UIItemList.StaticAlign(arg0_21.itemHolder, arg0_21.tpl, #var2_21, function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var2_21[arg1_22 + 1]

			arg0_21:UpdateMapItem(arg2_22, var0_22)

			arg2_22.name = "Chapter_" .. var0_22.id
			arg0_21.chapterTFsById[var0_22.id] = arg2_22
		end
	end)

	local var3_21 = {}

	for iter2_21, iter3_21 in pairs(var2_21) do
		local var4_21 = iter3_21:getConfigTable()

		var3_21[var4_21.pos_x] = var3_21[var4_21.pos_x] or {}

		local var5_21 = var3_21[var4_21.pos_x]

		var5_21[var4_21.pos_y] = var5_21[var4_21.pos_y] or {}

		local var6_21 = var5_21[var4_21.pos_y]

		table.insert(var6_21, iter3_21)
	end

	for iter4_21, iter5_21 in pairs(var3_21) do
		for iter6_21, iter7_21 in pairs(iter5_21) do
			local var7_21 = {}

			seriesAsync({
				function(arg0_23)
					local var0_23 = 0

					for iter0_23, iter1_23 in pairs(iter7_21) do
						if iter1_23:ifNeedHide() and var1_21:GetJustClearChapters(iter1_23.id) and arg0_21.chapterTFsById[iter1_23.id] then
							var0_23 = var0_23 + 1

							local var1_23 = arg0_21.chapterTFsById[iter1_23.id]

							setActive(var1_23, true)
							arg0_21:PlayChapterItemAnimationBackward(var1_23, iter1_23, function()
								var0_23 = var0_23 - 1

								setActive(var1_23, false)
								var1_21:RecordJustClearChapters(iter1_23.id, nil)

								if var0_23 <= 0 then
									arg0_23()
								end
							end)

							var7_21[iter1_23.id] = true
						elseif arg0_21.chapterTFsById[iter1_23.id] then
							setActive(arg0_21.chapterTFsById[iter1_23.id], false)
						end
					end

					if var0_23 <= 0 then
						arg0_23()
					end
				end,
				function(arg0_25)
					local var0_25 = 0

					for iter0_25, iter1_25 in pairs(iter7_21) do
						if not var7_21[iter1_25.id] then
							var0_25 = var0_25 + 1

							setActive(arg0_21.chapterTFsById[iter1_25.id], true)
							arg0_21:PlayChapterItemAnimation(arg0_21.chapterTFsById[iter1_25.id], iter1_25, function()
								var0_25 = var0_25 - 1

								if var0_25 <= 0 then
									arg0_25()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var1_0.UpdateMapItem(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg2_27:getConfigTable()

	setAnchoredPosition(arg1_27, {
		x = arg0_27.mapWidth * var0_27.pos_x,
		y = arg0_27.mapHeight * var0_27.pos_y
	})

	local var1_27 = findTF(arg1_27, "main")

	setActive(var1_27, true)

	local var2_27 = findTF(var1_27, "info/bk/fordark")

	setActive(var2_27, var0_27.icon_outline == 1)

	local var3_27 = findTF(var1_27, "circle/clear_flag")
	local var4_27 = findTF(var1_27, "circle/lock")
	local var5_27 = not arg2_27.active and not arg2_27:isUnlock()
	local var6_27 = findTF(var1_27, "circle/progress")
	local var7_27 = findTF(var1_27, "circle/progress_text")
	local var8_27 = findTF(var1_27, "circle/stars")
	local var9_27 = string.split(var0_27.name, "|")
	local var10_27 = var5_27 and "#737373" or "#FFFFFF"

	setText(findTF(var1_27, "info/bk/title_form/title_index"), setColorStr(var0_27.chapter_name .. "  ", var10_27))
	setText(findTF(var1_27, "info/bk/title_form/title"), setColorStr(var9_27[1], var10_27))
	setText(findTF(var1_27, "info/bk/title_form/title_en"), setColorStr(var9_27[2] or "", var10_27))
	setFillAmount(var6_27, arg2_27.progress / 100)
	setText(var7_27, string.format("%d%%", arg2_27.progress))
	setActive(var8_27, arg2_27:existAchieve())

	if arg2_27:existAchieve() then
		for iter0_27, iter1_27 in ipairs(arg2_27.achieves) do
			local var11_27 = ChapterConst.IsAchieved(iter1_27)
			local var12_27 = var8_27:Find("star" .. iter0_27 .. "/light")

			setActive(var12_27, var11_27)
		end
	end

	local var13_27 = not arg2_27.active and arg2_27:isClear()

	setActive(var3_27, var13_27)
	setActive(var4_27, var5_27)
	setActive(var7_27, not var13_27 and not var5_27)
	arg0_27:DeleteTween("fighting" .. arg2_27.id)

	local var14_27 = findTF(var1_27, "circle/fighting")

	setText(findTF(var14_27, "Text"), i18n("tag_level_fighting"))

	local var15_27 = findTF(var1_27, "circle/oni")

	setText(findTF(var15_27, "Text"), i18n("tag_level_oni"))

	local var16_27 = findTF(var1_27, "circle/narrative")

	setText(findTF(var16_27, "Text"), i18n("tag_level_narrative"))
	setActive(var14_27, false)
	setActive(var15_27, false)
	setActive(var16_27, false)

	local var17_27
	local var18_27

	if arg2_27:getConfig("chapter_tag") == 1 then
		var17_27 = var16_27
	end

	if arg2_27.active then
		var17_27 = arg2_27:existOni() and var15_27 or var14_27
	end

	if var17_27 then
		setActive(var17_27, true)

		local var19_27 = GetOrAddComponent(var17_27, "CanvasGroup")

		var19_27.alpha = 1

		arg0_27:RecordTween("fighting" .. arg2_27.id, LeanTween.alphaCanvas(var19_27, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var20_27 = findTF(var1_27, "triesLimit")

	setActive(var20_27, false)

	if arg2_27:isTriesLimit() then
		local var21_27 = arg2_27:getConfig("count")
		local var22_27 = var21_27 - arg2_27:getTodayDefeatCount() .. "/" .. var21_27

		setText(var20_27:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var20_27:Find("Text"), setColorStr(var22_27, var21_27 <= arg2_27:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var23_27 = arg2_27:GetDailyBonusQuota()
	local var24_27 = findTF(var1_27, "mark")

	setActive(var24_27:Find("bonus"), var23_27)
	setActive(var24_27, var23_27)

	if var23_27 then
		local var25_27 = var24_27:GetComponent(typeof(CanvasGroup))
		local var26_27 = arg0_27.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0_27.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var26_27, var24_27:Find("bonus"))
		LeanTween.cancel(go(var24_27), true)

		local var27_27 = var24_27.anchoredPosition.y

		var25_27.alpha = 0

		LeanTween.value(go(var24_27), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_28)
			var25_27.alpha = arg0_28

			local var0_28 = var24_27.anchoredPosition

			var0_28.y = var27_27 * arg0_28
			var24_27.anchoredPosition = var0_28
		end)):setOnComplete(System.Action(function()
			var25_27.alpha = 1

			local var0_29 = var24_27.anchoredPosition

			var0_29.y = var27_27
			var24_27.anchoredPosition = var0_29
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var28_27 = arg2_27.id

	onButton(arg0_27.sceneParent, var1_27, function()
		if arg0_27:InvokeParent("isfrozen") then
			return
		end

		if arg0_27.chaptersInBackAnimating[var28_27] then
			return
		end

		local var0_30 = getProxy(ChapterProxy):getChapterById(var28_27)

		if not var0_30:isUnlock() then
			local var1_30 = var0_30:getPrevChapterName()

			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre", var1_30))

			return
		end

		if not getProxy(ChapterProxy):getMapById(var0_30:getConfig("map")):isRemaster() and not var0_30:inActTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_close"))

			return
		end

		local var2_30 = var0_30:getConfig("unlocklevel")

		if var2_30 > arg0_27.sceneParent.player.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", var2_30))

			return
		end

		local var3_30 = getProxy(ChapterProxy):getActiveChapter(true)

		if var3_30 and var3_30.id ~= var28_27 then
			arg0_27:InvokeParent("emit", LevelMediator2.ON_STRATEGYING_CHAPTER)

			return
		end

		if var0_30.active then
			arg0_27:InvokeParent("switchToChapter", var0_30)
		else
			local var4_30 = arg1_27.localPosition

			arg0_27:InvokeParent("displayChapterPanel", var0_30, Vector3(var4_30.x - 10, var4_30.y + 150))
		end
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

function var1_0.PlayChapterItemAnimation(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = findTF(arg1_31, "main")
	local var1_31 = var0_31:Find("info")
	local var2_31 = findTF(var0_31, "circle")
	local var3_31 = findTF(var0_31, "info/bk")

	LeanTween.cancel(go(var2_31))

	var2_31.localScale = Vector3.zero

	local var4_31 = LeanTween.scale(var2_31, Vector3.one, 0.3):setDelay(0.3)

	arg0_31:RecordTween(var4_31.uniqueId)
	LeanTween.cancel(go(var3_31))
	setAnchoredPosition(var3_31, {
		x = -1 * var1_31.rect.width
	})
	shiftPanel(var3_31, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2_31:isTriesLimit() then
			setActive(findTF(var0_31, "triesLimit"), true)
		end

		if arg3_31 then
			arg3_31()
		end
	end)
end

function var1_0.PlayChapterItemAnimationBackward(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = findTF(arg1_33, "main")
	local var1_33 = var0_33:Find("info")
	local var2_33 = findTF(var0_33, "circle")
	local var3_33 = findTF(var0_33, "info/bk")

	LeanTween.cancel(go(var2_33))

	var2_33.localScale = Vector3.one

	local var4_33 = LeanTween.scale(go(var2_33), Vector3.zero, 0.3):setDelay(0.3)

	arg0_33:RecordTween(var4_33.uniqueId)

	arg0_33.chaptersInBackAnimating[arg2_33.id] = true

	LeanTween.cancel(go(var3_33))
	setAnchoredPosition(var3_33, {
		x = 0
	})
	shiftPanel(var3_33, -1 * var1_33.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0_33.chaptersInBackAnimating[arg2_33.id] = nil

		if arg3_33 then
			arg3_33()
		end
	end)

	if arg2_33:isTriesLimit() then
		setActive(findTF(var0_33, "triesLimit"), false)
	end
end

function var1_0.UpdateChapterTF(arg0_35, arg1_35)
	local var0_35 = arg0_35.chapterTFsById[arg1_35]

	if var0_35 then
		local var1_35 = getProxy(ChapterProxy):getChapterById(arg1_35)

		arg0_35:UpdateMapItem(var0_35, var1_35)
		arg0_35:PlayChapterItemAnimation(var0_35, var1_35)
	end
end

function var1_0.AddChapterTF(arg0_36, arg1_36)
	local var0_36 = arg0_36.data

	if arg0_36.chapterTFsById[arg1_36] then
		arg0_36:UpdateChapterTF(arg1_36)
	elseif _.contains(var0_36:GetChapterList(), function(arg0_37)
		if arg0_37 ~= arg1_36 then
			return false
		end

		local var0_37 = getProxy(ChapterProxy):getChapterById(arg1_36, true)

		return (var0_37:isUnlock() or var0_37:activeAlways()) and not var0_37:ifNeedHide()
	end) then
		local var1_36 = getProxy(ChapterProxy):getChapterById(arg1_36, true)
		local var2_36 = cloneTplTo(arg0_36.tpl, arg0_36.itemHolder, "Chapter_" .. var1_36.id)

		arg0_36:UpdateMapItem(var2_36, var1_36)

		arg0_36.chapterTFsById[var1_36.id] = var2_36

		arg0_36:PlayChapterItemAnimation(var2_36)
	end
end

function var1_0.TryOpenChapter(arg0_38, arg1_38)
	local var0_38 = arg0_38.chapterTFsById[arg1_38]

	if var0_38 then
		local var1_38 = var0_38:Find("main")

		triggerButton(var1_38)
	end
end

return var1_0
