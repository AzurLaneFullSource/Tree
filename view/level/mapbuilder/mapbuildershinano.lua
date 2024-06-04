local var0 = import(".MapBuilder")
local var1 = class("MapBuilderShinano", var0)

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)

	arg0.chapterTFsById = {}
	arg0.chaptersInBackAnimating = {}
end

function var1.GetType(arg0)
	return var0.TYPESHINANO
end

function var1.getUIName(arg0)
	return "Shinano_levels"
end

function var1.OnInit(arg0)
	arg0.tpl = arg0._tf:Find("level_tpl")

	setActive(arg0.tpl, false)

	arg0.itemHolder = arg0._tf:Find("items")

	local var0 = arg0._tf:Find("preloadResources"):GetComponent(typeof(ItemList))
	local var1 = Instantiate(var0.prefabItem[0])

	setAnchoredPosition(arg0._tf:Find("rumeng"), tf(var1).anchoredPosition)
	setParent(var1, arg0._tf:Find("rumeng"))
	setAnchoredPosition(var1, Vector2.zero)
	arg0:InitTransformMapBtn(arg0._tf:Find("rumeng"), 1, var0.prefabItem[1])

	local var2 = Instantiate(var0.prefabItem[2])

	setAnchoredPosition(arg0._tf:Find("huigui"), tf(var2).anchoredPosition)
	setParent(var2, arg0._tf:Find("huigui"))
	setAnchoredPosition(var2, Vector2.zero)
	arg0:InitTransformMapBtn(arg0._tf:Find("huigui"), -1, var0.prefabItem[3])
end

function var1.OnShow(arg0)
	setActive(arg0.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0.sceneParent.topChapter:Find("type_skirmish"), true)
end

function var1.OnHide(arg0)
	setActive(arg0.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0.sceneParent.topChapter:Find("type_skirmish"), false)
	table.clear(arg0.chaptersInBackAnimating)

	for iter0, iter1 in pairs(arg0.chapterTFsById) do
		local var0 = findTF(iter1, "main/info/bk")

		LeanTween.cancel(rtf(var0))
	end

	var1.super.OnHide(arg0)
end

function var1.TrySwitchNextMap(arg0, arg1)
	local var0 = arg0.sceneParent.contextData.mapIdx + arg1
	local var1 = getProxy(ChapterProxy):getMapById(var0)

	if not var1 then
		return
	end

	if var1:getMapType() == Map.ELITE and not var1:isEliteEnabled() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

		return
	end

	local var2, var3 = var1:isUnlock()

	if not var2 then
		pg.TipsMgr.GetInstance():ShowTips(var3)

		return
	end

	return true
end

function var1.InitTransformMapBtn(arg0, arg1, arg2, arg3)
	onButton(arg0.sceneParent, arg1, function()
		if arg0.sceneParent:isfrozen() then
			return
		end

		local var0

		seriesAsync({
			function(arg0)
				if not arg0:TrySwitchNextMap(arg2) then
					return
				end

				pg.CriMgr.GetInstance():StopBGM()
				pg.CriMgr.GetInstance():PlaySE_V3("ui-qiehuan")

				var0 = arg0._tf:Find(arg3.name .. "(Clone)") or Instantiate(arg3)

				setParent(var0, arg0._tf)
				setAnchoredPosition(var0, rtf(arg1).anchoredPosition)

				local var0 = arg0.contextData.mapIdx + arg2
				local var1 = Map.bindConfigTable(Map)[var0]

				if var1 and #var1.bg > 0 then
					GetSpriteFromAtlasAsync("levelmap/" .. var1.bg, "", function(arg0)
						return
					end)
				end

				arg0.sceneParent:frozen()
				LeanTween.delayedCall(go(arg1), 2.3, System.Action(arg0))
			end,
			function(arg0)
				arg0.sceneParent:setMap(arg0.contextData.mapIdx + arg2)
				LeanTween.delayedCall(go(arg1), 0.5, System.Action(arg0))
			end,
			function(arg0)
				if not IsNil(var0) then
					Destroy(var0)
				end

				arg0.sceneParent:unfrozen()
			end
		})
	end)
end

function var1.Update(arg0, arg1)
	arg0.float.pivot = Vector2(0.5, 0.5)
	arg0.float.anchoredPosition = Vector2(0, 0)

	local var0 = string.split(arg1:getConfig("name"), "||")

	setText(arg0.sceneParent.chapterName, var0[1])

	local var1 = arg1:getMapTitleNumber()

	arg0.sceneParent.loader:GetSpriteQuiet("chapterno", "chapter" .. var1, arg0.sceneParent.chapterNoTitle, true)
	var1.super.Update(arg0, arg1)
end

function var1.UpdateButtons(arg0)
	arg0.sceneParent:updateDifficultyBtns()
	arg0.sceneParent:updateActivityBtns()
end

function var1.PostUpdateMap(arg0, arg1)
	local var0 = arg0.contextData.map:getConfig("type") == Map.ACT_EXTRA
	local var1 = arg0._tf:Find("rumeng")
	local var2 = arg0._tf:Find("huigui")

	setActive(var1, false)
	setActive(var2, false)

	if not var0 then
		setActive(arg0.sceneParent.btnPrev, false)
		setActive(arg0.sceneParent.btnNext, false)

		local var3 = getProxy(ChapterProxy):getMapById(arg1.id + 1)
		local var4 = getProxy(ChapterProxy):getMapById(arg1.id - 1)

		setActive(var1, var3)
		setActive(var2, var4)
		LeanTween.cancel(go(var1), true)
		LeanTween.cancel(go(var2), true)

		if var3 then
			local var5 = tf(var1).localScale
			local var6 = tf(var1):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var7 = var6:GetColor("_MainColor")
			local var8 = Clone(var7)
			local var9 = LeanTween.value(go(var1), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0)
				var8.a = var7.a * arg0

				var6:SetColor("_MainColor", var8)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var6:SetColor("_MainColor", var7)
			end))

			arg0:RecordTween("rumengAlphaTween", var9.id)
		elseif var4 then
			local var10 = tf(var2).localScale
			local var11 = tf(var2):GetChild(0):Find("Quad"):GetComponent(typeof(MeshRenderer)).sharedMaterial
			local var12 = var11:GetColor("_MainColor")
			local var13 = Clone(var12)
			local var14 = LeanTween.value(go(var2), 0, 1, 0.8):setOnUpdate(System.Action_float(function(arg0)
				var13.a = var12.a * arg0

				var11:SetColor("_MainColor", var13)
			end)):setEase(LeanTweenType.easeInCubic):setOnComplete(System.Action(function()
				var11:SetColor("_MainColor", var12)
			end))

			arg0:RecordTween("huiguiAlphaTween", var14.id)
		end
	end
end

function var1.UpdateMapItems(arg0)
	if not arg0:isShowing() then
		return
	end

	var1.super.UpdateMapItems(arg0)

	local var0 = arg0.data
	local var1 = getProxy(ChapterProxy)

	table.clear(arg0.chapterTFsById)

	local var2 = {}

	for iter0, iter1 in pairs(var0:getChapters()) do
		if (iter1:isUnlock() or iter1:activeAlways()) and (not iter1:ifNeedHide() or var1:GetJustClearChapters(iter1.id)) then
			table.insert(var2, iter1)
		end
	end

	UIItemList.StaticAlign(arg0.itemHolder, arg0.tpl, #var2, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]

			arg0:UpdateMapItem(arg2, var0)

			arg2.name = "Chapter_" .. var0.id
			arg0.chapterTFsById[var0.id] = arg2
		end
	end)

	local var3 = {}

	for iter2, iter3 in pairs(var2) do
		local var4 = iter3:getConfigTable()

		var3[var4.pos_x] = var3[var4.pos_x] or {}

		local var5 = var3[var4.pos_x]

		var5[var4.pos_y] = var5[var4.pos_y] or {}

		local var6 = var5[var4.pos_y]

		table.insert(var6, iter3)
	end

	for iter4, iter5 in pairs(var3) do
		for iter6, iter7 in pairs(iter5) do
			local var7 = {}

			seriesAsync({
				function(arg0)
					local var0 = 0

					for iter0, iter1 in pairs(iter7) do
						if iter1:ifNeedHide() and var1:GetJustClearChapters(iter1.id) and arg0.chapterTFsById[iter1.id] then
							var0 = var0 + 1

							local var1 = arg0.chapterTFsById[iter1.id]

							setActive(var1, true)
							arg0:PlayChapterItemAnimationBackward(var1, iter1, function()
								var0 = var0 - 1

								setActive(var1, false)
								var1:RecordJustClearChapters(iter1.id, nil)

								if var0 <= 0 then
									arg0()
								end
							end)

							var7[iter1.id] = true
						elseif arg0.chapterTFsById[iter1.id] then
							setActive(arg0.chapterTFsById[iter1.id], false)
						end
					end

					if var0 <= 0 then
						arg0()
					end
				end,
				function(arg0)
					local var0 = 0

					for iter0, iter1 in pairs(iter7) do
						if not var7[iter1.id] then
							var0 = var0 + 1

							setActive(arg0.chapterTFsById[iter1.id], true)
							arg0:PlayChapterItemAnimation(arg0.chapterTFsById[iter1.id], iter1, function()
								var0 = var0 - 1

								if var0 <= 0 then
									arg0()
								end
							end)
						end
					end
				end
			})
		end
	end
end

function var1.UpdateMapItem(arg0, arg1, arg2)
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
	local var10 = var5 and "#737373" or "#FFFFFF"

	setText(findTF(var1, "info/bk/title_form/title_index"), setColorStr(var0.chapter_name .. "  ", var10))
	setText(findTF(var1, "info/bk/title_form/title"), setColorStr(var9[1], var10))
	setText(findTF(var1, "info/bk/title_form/title_en"), setColorStr(var9[2] or "", var10))
	setFillAmount(var6, arg2.progress / 100)
	setText(var7, string.format("%d%%", arg2.progress))
	setActive(var8, arg2:existAchieve())

	if arg2:existAchieve() then
		for iter0, iter1 in ipairs(arg2.achieves) do
			local var11 = ChapterConst.IsAchieved(iter1)
			local var12 = var8:Find("star" .. iter0 .. "/light")

			setActive(var12, var11)
		end
	end

	local var13 = not arg2.active and arg2:isClear()

	setActive(var3, var13)
	setActive(var4, var5)
	setActive(var7, not var13 and not var5)
	arg0:DeleteTween("fighting" .. arg2.id)

	local var14 = findTF(var1, "circle/fighting")

	setText(findTF(var14, "Text"), i18n("tag_level_fighting"))

	local var15 = findTF(var1, "circle/oni")

	setText(findTF(var15, "Text"), i18n("tag_level_oni"))

	local var16 = findTF(var1, "circle/narrative")

	setText(findTF(var16, "Text"), i18n("tag_level_narrative"))
	setActive(var14, false)
	setActive(var15, false)
	setActive(var16, false)

	local var17
	local var18

	if arg2:getConfig("chapter_tag") == 1 then
		var17 = var16
	end

	if arg2.active then
		var17 = arg2:existOni() and var15 or var14
	end

	if var17 then
		setActive(var17, true)

		local var19 = GetOrAddComponent(var17, "CanvasGroup")

		var19.alpha = 1

		arg0:RecordTween("fighting" .. arg2.id, LeanTween.alphaCanvas(var19, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var20 = findTF(var1, "triesLimit")

	setActive(var20, false)

	if arg2:isTriesLimit() then
		local var21 = arg2:getConfig("count")
		local var22 = var21 - arg2:getTodayDefeatCount() .. "/" .. var21

		setText(var20:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var20:Find("Text"), setColorStr(var22, var21 <= arg2:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))
	end

	local var23 = arg2:GetDailyBonusQuota()
	local var24 = findTF(var1, "mark")

	setActive(var24:Find("bonus"), var23)
	setActive(var24, var23)

	if var23 then
		local var25 = var24:GetComponent(typeof(CanvasGroup))
		local var26 = arg0.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var26, var24:Find("bonus"))
		LeanTween.cancel(go(var24), true)

		local var27 = var24.anchoredPosition.y

		var25.alpha = 0

		LeanTween.value(go(var24), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
			var25.alpha = arg0

			local var0 = var24.anchoredPosition

			var0.y = var27 * arg0
			var24.anchoredPosition = var0
		end)):setOnComplete(System.Action(function()
			var25.alpha = 1

			local var0 = var24.anchoredPosition

			var0.y = var27
			var24.anchoredPosition = var0
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var28 = arg2.id

	onButton(arg0.sceneParent, var1, function()
		if arg0:InvokeParent("isfrozen") then
			return
		end

		if arg0.chaptersInBackAnimating[var28] then
			return
		end

		local var0 = getProxy(ChapterProxy):getChapterById(var28)

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

		if var3 and var3.id ~= var28 then
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

function var1.PlayChapterItemAnimation(arg0, arg1, arg2, arg3)
	local var0 = findTF(arg1, "main")
	local var1 = var0:Find("info")
	local var2 = findTF(var0, "circle")
	local var3 = findTF(var0, "info/bk")

	LeanTween.cancel(go(var2))

	var2.localScale = Vector3.zero

	local var4 = LeanTween.scale(var2, Vector3.one, 0.3):setDelay(0.3)

	arg0:RecordTween(var4.uniqueId)
	LeanTween.cancel(go(var3))
	setAnchoredPosition(var3, {
		x = -1 * var1.rect.width
	})
	shiftPanel(var3, 0, nil, 0.4, 0.4, true, true, nil, function()
		if arg2:isTriesLimit() then
			setActive(findTF(var0, "triesLimit"), true)
		end

		if arg3 then
			arg3()
		end
	end)
end

function var1.PlayChapterItemAnimationBackward(arg0, arg1, arg2, arg3)
	local var0 = findTF(arg1, "main")
	local var1 = var0:Find("info")
	local var2 = findTF(var0, "circle")
	local var3 = findTF(var0, "info/bk")

	LeanTween.cancel(go(var2))

	var2.localScale = Vector3.one

	local var4 = LeanTween.scale(go(var2), Vector3.zero, 0.3):setDelay(0.3)

	arg0:RecordTween(var4.uniqueId)

	arg0.chaptersInBackAnimating[arg2.id] = true

	LeanTween.cancel(go(var3))
	setAnchoredPosition(var3, {
		x = 0
	})
	shiftPanel(var3, -1 * var1.rect.width, nil, 0.4, 0.4, true, true, nil, function()
		arg0.chaptersInBackAnimating[arg2.id] = nil

		if arg3 then
			arg3()
		end
	end)

	if arg2:isTriesLimit() then
		setActive(findTF(var0, "triesLimit"), false)
	end
end

function var1.UpdateChapterTF(arg0, arg1)
	local var0 = arg0.chapterTFsById[arg1]

	if var0 then
		local var1 = getProxy(ChapterProxy):getChapterById(arg1)

		arg0:UpdateMapItem(var0, var1)
		arg0:PlayChapterItemAnimation(var0, var1)
	end
end

function var1.AddChapterTF(arg0, arg1)
	local var0 = arg0.data

	if arg0.chapterTFsById[arg1] then
		arg0:UpdateChapterTF(arg1)
	elseif _.contains(var0:GetChapterList(), function(arg0)
		if arg0 ~= arg1 then
			return false
		end

		local var0 = getProxy(ChapterProxy):getChapterById(arg1, true)

		return (var0:isUnlock() or var0:activeAlways()) and not var0:ifNeedHide()
	end) then
		local var1 = getProxy(ChapterProxy):getChapterById(arg1, true)
		local var2 = cloneTplTo(arg0.tpl, arg0.itemHolder, "Chapter_" .. var1.id)

		arg0:UpdateMapItem(var2, var1)

		arg0.chapterTFsById[var1.id] = var2

		arg0:PlayChapterItemAnimation(var2)
	end
end

function var1.TryOpenChapter(arg0, arg1)
	local var0 = arg0.chapterTFsById[arg1]

	if var0 then
		local var1 = var0:Find("main")

		triggerButton(var1)
	end
end

return var1
