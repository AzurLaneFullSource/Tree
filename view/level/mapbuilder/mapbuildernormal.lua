local var0 = import(".MapBuilder")
local var1 = class("MapBuilderNormal", var0)

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)

	arg0.mapItemTimer = {}
	arg0.chapterTFsById = {}
	arg0.chaptersInBackAnimating = {}
end

function var1.GetType(arg0)
	return var0.TYPENORMAL
end

function var1.getUIName(arg0)
	return "levels"
end

function var1.Load(arg0)
	if arg0._state ~= var1.STATES.NONE then
		return
	end

	arg0._state = var1.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync({
		function(arg0)
			arg0:preload(arg0)
		end,
		function(arg0)
			local var0 = arg0.float:Find("levels").gameObject

			arg0:Loaded(var0)
			arg0:Init()
		end
	})
end

function var1.Destroy(arg0)
	if arg0._state == var1.STATES.DESTROY then
		return
	end

	if not arg0:GetLoaded() then
		arg0._state = var1.STATES.DESTROY

		return
	end

	arg0:Hide()
	arg0:OnDestroy()
	pg.DelegateInfo.Dispose(arg0)

	arg0._go = nil

	arg0:disposeEvent()
	arg0:cleanManagedTween()

	arg0._state = var1.STATES.DESTROY
end

function var1.OnInit(arg0)
	arg0.chapterTpl = arg0._tf:Find("level_tpl")

	setActive(arg0.chapterTpl, false)

	arg0.storyTpl = arg0._tf:Find("story_tpl")

	setActive(arg0.storyTpl, false)

	arg0.itemHolder = arg0._tf:Find("items")
	arg0.storyHolder = arg0._tf:Find("stories")
end

function var1.OnShow(arg0)
	setActive(arg0.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0.sceneParent.topChapter:Find("type_chapter"), true)
end

function var1.OnHide(arg0)
	setActive(arg0.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0.sceneParent.topChapter:Find("type_chapter"), false)
	table.clear(arg0.chaptersInBackAnimating)
	arg0:StopMapItemTimers()

	for iter0, iter1 in pairs(arg0.chapterTFsById) do
		local var0 = findTF(iter1, "main/info/bk")

		LeanTween.cancel(rtf(var0))
	end

	var1.super.OnHide(arg0)
end

function var1.OnDestroy(arg0)
	arg0.mapItemTimer = nil

	var1.super.OnDestroy(arg0)
end

function var1.StartTimer(arg0, arg1, arg2, arg3)
	if not arg0.mapItemTimer[arg1] then
		arg0.mapItemTimer[arg1] = Timer.New(arg2, arg3)
	else
		arg0.mapItemTimer[arg1]:Reset(arg2, arg3)
	end

	arg0.mapItemTimer[arg1]:Start()
end

function var1.StopMapItemTimers(arg0)
	for iter0, iter1 in pairs(arg0.mapItemTimer) do
		iter1:Stop()
	end

	table.clear(arg0.mapItemTimer)
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

function var1.UpdateMapItems(arg0)
	if not arg0:isShowing() then
		return
	end

	var1.super.UpdateMapItems(arg0)
	arg0:StopMapItemTimers()

	local var0 = arg0.data
	local var1 = var0:GetChapterInProgress()

	if var1 and isa(var1, ChapterStoryGroup) then
		setActive(arg0.itemHolder, false)
		setActive(arg0.storyHolder, true)
		arg0:UpdateStoryGroup()

		return
	end

	setActive(arg0.itemHolder, true)
	setActive(arg0.storyHolder, false)

	local var2 = getProxy(ChapterProxy)
	local var3 = {}

	for iter0, iter1 in pairs(var0:getChapters()) do
		if (iter1:isUnlock() or iter1:activeAlways()) and (not iter1:ifNeedHide() or var2:GetJustClearChapters(iter1.id)) then
			table.insert(var3, iter1)
		end
	end

	table.clear(arg0.chapterTFsById)
	UIItemList.StaticAlign(arg0.itemHolder, arg0.chapterTpl, #var3, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var3[arg1 + 1]

			arg0:UpdateMapItem(arg2, var0)

			arg2.name = "Chapter_" .. var0.id
			arg0.chapterTFsById[var0.id] = arg2
		end
	end)

	local var4 = {}

	for iter2, iter3 in pairs(var3) do
		local var5 = iter3:getConfigTable()

		var4[var5.pos_x] = var4[var5.pos_x] or {}

		local var6 = var4[var5.pos_x]

		var6[var5.pos_y] = var6[var5.pos_y] or {}

		local var7 = var6[var5.pos_y]

		table.insert(var7, iter3)
	end

	for iter4, iter5 in pairs(var4) do
		for iter6, iter7 in pairs(iter5) do
			local var8 = {}

			seriesAsync({
				function(arg0)
					local var0 = 0

					for iter0, iter1 in pairs(iter7) do
						if iter1:ifNeedHide() and var2:GetJustClearChapters(iter1.id) and arg0.chapterTFsById[iter1.id] then
							var0 = var0 + 1

							local var1 = arg0.chapterTFsById[iter1.id]

							setActive(var1, true)
							arg0:PlayChapterItemAnimationBackward(var1, iter1, function()
								var0 = var0 - 1

								setActive(var1, false)
								var2:RecordJustClearChapters(iter1.id, nil)

								if var0 <= 0 then
									arg0()
								end
							end)

							var8[iter1.id] = true
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
						if not var8[iter1.id] then
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

	local var2 = findTF(var1, "circle/fordark")
	local var3 = findTF(var1, "info/bk/fordark")

	setActive(var2, var0.icon_outline == 1)
	setActive(var3, var0.icon_outline == 1)

	local var4 = findTF(var1, "circle/clear_flag")
	local var5 = findTF(var1, "circle/progress")
	local var6 = findTF(var1, "circle/progress_text")
	local var7 = findTF(var1, "circle/stars")
	local var8 = string.split(var0.name, "|")

	setText(findTF(var1, "info/bk/title_form/title_index"), var0.chapter_name .. "  ")
	setText(findTF(var1, "info/bk/title_form/title"), var8[1])
	setText(findTF(var1, "info/bk/title_form/title_en"), var8[2] or "")
	setFillAmount(var5, arg2.progress / 100)
	setText(var6, string.format("%d%%", arg2.progress))
	setActive(var7, arg2:existAchieve())

	if arg2:existAchieve() then
		for iter0, iter1 in ipairs(arg2.achieves) do
			local var9 = ChapterConst.IsAchieved(iter1)
			local var10 = var7:Find("star" .. iter0 .. "/light")

			setActive(var10, var9)
		end
	end

	local var11 = not arg2.active and arg2:isClear()

	setActive(var4, var11)
	setActive(var6, not var11)
	arg0:DeleteTween("fighting" .. arg2.id)

	local var12 = findTF(var1, "circle/fighting")

	setText(findTF(var12, "Text"), i18n("tag_level_fighting"))

	local var13 = findTF(var1, "circle/oni")

	setText(findTF(var13, "Text"), i18n("tag_level_oni"))

	local var14 = findTF(var1, "circle/narrative")

	setText(findTF(var14, "Text"), i18n("tag_level_narrative"))
	setActive(var12, false)
	setActive(var13, false)
	setActive(var14, false)

	local var15
	local var16

	if arg2:getConfig("chapter_tag") == 1 then
		var15 = var14
	end

	if arg2.active then
		var15 = arg2:existOni() and var13 or var12
	end

	if var15 then
		setActive(var15, true)

		local var17 = GetOrAddComponent(var15, "CanvasGroup")

		var17.alpha = 1

		arg0:RecordTween("fighting" .. arg2.id, LeanTween.alphaCanvas(var17, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	local var18 = findTF(var1, "triesLimit")

	setActive(var18, false)

	if arg2:isTriesLimit() then
		local var19 = arg2:getConfig("count")
		local var20 = var19 - arg2:getTodayDefeatCount() .. "/" .. var19

		setText(var18:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(var18:Find("Text"), setColorStr(var20, var19 <= arg2:getTodayDefeatCount() and COLOR_RED or COLOR_GREEN))

		local var21 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

		setActive(var18:Find("TipRect"), var21)
	end

	local var22 = arg2:GetDailyBonusQuota()
	local var23 = findTF(var1, "mark")

	setActive(var23:Find("bonus"), var22)
	setActive(var23, var22)

	if var22 then
		local var24 = var23:GetComponent(typeof(CanvasGroup))
		local var25 = arg0.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

		arg0.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", var25, var23:Find("bonus"))
		LeanTween.cancel(go(var23), true)

		local var26 = var23.anchoredPosition.y

		var24.alpha = 0

		LeanTween.value(go(var23), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
			var24.alpha = arg0

			local var0 = var23.anchoredPosition

			var0.y = var26 * arg0
			var23.anchoredPosition = var0
		end)):setOnComplete(System.Action(function()
			var24.alpha = 1

			local var0 = var23.anchoredPosition

			var0.y = var26
			var23.anchoredPosition = var0
		end)):setEase(LeanTweenType.easeOutSine):setDelay(0.7)
	end

	local var27 = arg2.id

	onButton(arg0.sceneParent, var1, function()
		if arg0:InvokeParent("isfrozen") then
			return
		end

		if arg0.chaptersInBackAnimating[var27] then
			return
		end

		local var0 = getProxy(ChapterProxy):getChapterById(var27)

		if not var0:isUnlock() then
			local var1 = var0:getPrevChapterName()

			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre", var1))

			return
		end

		local var2 = var0:getConfig("unlocklevel")

		if var2 > arg0.sceneParent.player.level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", var2))

			return
		end

		local var3 = getProxy(ChapterProxy):getActiveChapter(true)

		if var3 and var3.id ~= var27 then
			arg0:InvokeParent("emit", LevelMediator2.ON_STRATEGYING_CHAPTER)

			return
		end

		if var0.active then
			arg0:InvokeParent("switchToChapter", var0)
		else
			if arg0.sceneParent.contextData.map:getConfig("type") == Map.ACT_EXTRA and var0:getPlayType() == ChapterConst.TypeRange then
				SettingsProxy.SetActivityMapSPTip()
				arg0:UpdateChapterTF(var27)
			end

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
		local var2 = cloneTplTo(arg0.chapterTpl, arg0.itemHolder, "Chapter_" .. var1.id)

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

function var1.UpdateStoryGroup(arg0)
	local var0 = arg0.data:GetChapterInProgress():GetChapterStories()

	UIItemList.StaticAlign(arg0.storyHolder, arg0.storyTpl, #var0, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var0[arg1 + 1]

		arg0:UpdateMapStory(arg2, var0)

		arg2.name = "Chapter_" .. var0:GetName()
	end)
end

function var1.UpdateMapStory(arg0, arg1, arg2)
	local var0 = arg2:GetPosition()

	setAnchoredPosition(arg1, {
		x = arg0.mapWidth * var0[1],
		y = arg0.mapHeight * var0[2]
	})
	setText(arg1:Find("Name"), arg2:GetName())

	local var1, var2 = arg2:GetIcon()

	arg0.sceneParent.loader:GetSpriteQuiet(var1, var2, arg1:Find("Icon"), true)

	local var3 = arg2:GetStoryName()

	onButton(arg0, arg1, function()
		pg.NewStoryMgr.GetInstance():Play(var3, function()
			arg0.sceneParent:RefreshMapBG()
			arg0:UpdateMapItems()
		end)
	end, SFX_PANEL)
	setActive(arg1, not pg.NewStoryMgr.GetInstance():IsPlayed(var3))
end

return var1
