local var0_0 = class("LevelInfoView", import("..base.BaseSubView"))

var0_0.CHAPTER_GUIDE_NAME = "CHAPTER_AUTO_GUIDE"

function var0_0.getUIName(arg0_1)
	return "LevelStageInfoView"
end

function var0_0.OnInit(arg0_2)
	arg0_2.loader = AutoLoader.New()

	arg0_2:InitUI()
end

function var0_0.OnDestroy(arg0_3)
	if arg0_3:isShowing() then
		arg0_3:Hide()
	end

	arg0_3.onConfirm = nil
	arg0_3.onCancel = nil

	if arg0_3.LTid then
		LeanTween.cancel(arg0_3.LTid)

		arg0_3.LTid = nil
	end

	arg0_3.loader:Clear()
end

function var0_0.Show(arg0_4)
	setActive(arg0_4._tf, true)
	arg0_4:BlurPanel(arg0_4._tf)
	arg0_4:CheckGuide()
end

function var0_0.CheckGuide(arg0_5)
	local var0_5 = ChapterAutoProxy.IsSystemOpen()
	local var1_5 = pg.chapter_auto_statistics[arg0_5.chapter.id]

	if var0_5 and var1_5 and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_0.CHAPTER_GUIDE_NAME) then
		pg.NewGuideMgr.GetInstance():Play(var0_0.CHAPTER_GUIDE_NAME)
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = var0_0.CHAPTER_GUIDE_NAME
		})
	end
end

function var0_0.Hide(arg0_6)
	arg0_6:clear()
	setActive(arg0_6._tf, false)
	arg0_6:UnOverlayPanel(arg0_6._tf, arg0_6._parentTf)
end

function var0_0.setCBFunc(arg0_7, arg1_7, arg2_7)
	arg0_7.onConfirm = arg1_7
	arg0_7.onCancel = arg2_7
end

function var0_0.InitUI(arg0_8)
	arg0_8.titleBG = arg0_8._tf:Find("panel/title")
	arg0_8.titleBGDecoration = arg0_8._tf:Find("panel/title/Image")
	arg0_8.titleIcon = arg0_8._tf:Find("panel/title/icon")
	arg0_8.txTitle = arg0_8._tf:Find("panel/title_form")
	arg0_8.txTitleOriginPosY = arg0_8.txTitle.anchoredPosition.y
	arg0_8.txTitleHead = arg0_8._tf:Find("panel/title_head")

	setActive(arg0_8.txTitleHead, false)

	arg0_8.txIntro = arg0_8._tf:Find("panel/intro")
	arg0_8.txCost = arg0_8._tf:Find("panel/cost/text")
	arg0_8.progressBar = arg0_8._tf:Find("panel/progress")
	arg0_8.txProgress = arg0_8._tf:Find("panel/progress/Text/value")
	arg0_8.progress = arg0_8._tf:Find("panel/progress")
	arg0_8.head = arg0_8._tf:Find("panel/head/Image")
	arg0_8.trAchieveTpl = arg0_8._tf:Find("panel/achieve")
	arg0_8.trAchieves = arg0_8._tf:Find("panel/achieves")
	arg0_8.passStateMask = arg0_8._tf:Find("panel/passState")
	arg0_8.passState = arg0_8._tf:Find("panel/passState/Image")

	setActive(arg0_8.passState, true)

	arg0_8.winCondDesc = arg0_8._tf:Find("panel/win_conditions/desc")
	arg0_8.winCondAwardBtn = arg0_8._tf:Find("panel/win_conditions/icon")
	arg0_8.loseCondDesc = arg0_8._tf:Find("panel/lose_conditions/desc")
	arg0_8.achieveList = UIItemList.New(arg0_8.trAchieves, arg0_8.trAchieveTpl)

	setActive(arg0_8.trAchieveTpl, false)

	arg0_8.trDropTpl = arg0_8._tf:Find("panel/drops/frame/list/item")
	arg0_8.trDrops = arg0_8._tf:Find("panel/drops/frame/list")
	arg0_8.dropList = UIItemList.New(arg0_8.trDrops, arg0_8.trDropTpl)

	arg0_8.dropList:make(function(arg0_9, arg1_9, arg2_9)
		arg0_8:updateDrop(arg0_9, arg1_9, arg2_9)
	end)
	setActive(arg0_8.trDropTpl, false)

	arg0_8.btnAuto = arg0_8._tf:Find("panel/auto_button")
	arg0_8.btnConfirm = arg0_8._tf:Find("panel/start_button")
	arg0_8.btnConfirm_l = arg0_8._tf:Find("panel/start_button_l")
	arg0_8.btnCancel = arg0_8._tf:Find("panel/btnBack")
	arg0_8.quickPlayGroup = arg0_8._tf:Find("panel/quickPlay")
	arg0_8.descQuickPlay = arg0_8.quickPlayGroup:Find("desc")
	arg0_8.toggleQuickPlay = arg0_8.quickPlayGroup:GetComponent(typeof(Toggle))
	arg0_8.bottomExtra = arg0_8._tf:Find("panel/BottomExtra")
	arg0_8.layoutView = GetComponent(arg0_8.bottomExtra:Find("LoopGroup/view"), typeof(LayoutElement))
	arg0_8.rtViewContainer = arg0_8.bottomExtra:Find("LoopGroup/view/container")

	setText(arg0_8.bottomExtra:Find("LoopGroup/Loop/Text"), i18n("autofight_farm"))

	arg0_8.loopToggle = arg0_8.bottomExtra:Find("LoopGroup/Loop/Toggle")
	arg0_8.loopOn = arg0_8.loopToggle:Find("on")
	arg0_8.loopOff = arg0_8.loopToggle:Find("off")
	arg0_8.loopHelp = arg0_8.bottomExtra:Find("ButtonHelp")
	arg0_8.costLimitTip = arg0_8.bottomExtra:Find("LoopGroup/view/container/CostLimit")

	setActive(arg0_8.costLimitTip, false)

	arg0_8.autoFightToggle = arg0_8.bottomExtra:Find("LoopGroup/view/container/AutoFight")

	setText(arg0_8.autoFightToggle:Find("Text"), i18n("autofight"))

	arg0_8.delayTween = {}
	arg0_8.doEaseIn = true
end

local var1_0 = 525
local var2_0 = 373

function var0_0.set(arg0_10, arg1_10, arg2_10)
	arg0_10:cancelTween()

	local var0_10 = getProxy(ChapterProxy):getChapterById(arg1_10, true)

	arg0_10.chapter = var0_10
	arg0_10.posStart = arg2_10 or Vector3(0, 0, 0)

	local var1_10 = getProxy(ChapterProxy):getMapById(var0_10:getConfig("map"))
	local var2_10 = var0_10:getConfigTable()
	local var3_10 = string.split(var2_10.name, "|")
	local var4_10 = var0_10:getPlayType() == ChapterConst.TypeDefence

	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var4_10 and "title_print_defense" or "title_print", function(arg0_11)
		if not IsNil(arg0_10.titleBGDecoration) then
			arg0_10.titleBGDecoration:GetComponent(typeof(Image)).sprite = arg0_11
		end
	end)
	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var4_10 and "titlebar_bg_defense" or "titlebar_bg", function(arg0_12)
		if not IsNil(arg0_10.titleBG) then
			arg0_10.titleBG:GetComponent(typeof(Image)).sprite = arg0_12
		end
	end)
	setActive(arg0_10.titleIcon, var4_10)

	local var5_10 = arg0_10.progressBar.sizeDelta

	var5_10.x = var4_10 and var2_0 or var1_0
	arg0_10.progressBar.sizeDelta = var5_10

	setText(arg0_10.txTitle:Find("title_index"), var2_10.chapter_name .. "  ")
	setText(arg0_10.txTitle:Find("title"), var3_10[1])
	setText(arg0_10.txTitle:Find("title_en"), var3_10[2] or "")
	setActive(arg0_10.txTitleHead, var3_10[3] and #var3_10[3] > 0)

	local var6_10 = var3_10[3] and #var3_10[3] > 0 and arg0_10.txTitleOriginPosY or arg0_10.txTitleOriginPosY + 8

	setAnchoredPosition(arg0_10.txTitle, {
		y = var6_10
	})
	setText(arg0_10.txTitleHead, var3_10[3] or "")
	setText(arg0_10.winCondDesc, i18n("text_win_condition") .. "：" .. i18n(var0_10:getConfig("win_condition_display")))
	setText(arg0_10.loseCondDesc, i18n("text_lose_condition") .. "：" .. i18n(var0_10:getConfig("lose_condition_display")))
	setActive(arg0_10.winCondAwardBtn, var0_10:getPlayType() == ChapterConst.TypeDefence)

	if not var0_10:existAchieve() then
		setActive(arg0_10.passState, false)
		setActive(arg0_10.progress, false)
		setActive(arg0_10.trAchieves, false)
	else
		setActive(arg0_10.passState, true)
		setActive(arg0_10.progress, true)
		setActive(arg0_10.trAchieves, true)

		arg0_10.passState.localPosition = Vector3(-arg0_10.passState.rect.width, 0, 0)

		local var7_10 = var0_10:hasMitigation()

		setActive(arg0_10.passState, var7_10)

		if var7_10 then
			local var8_10 = var0_10:getRiskLevel()

			setImageSprite(arg0_10.passState, GetSpriteFromAtlas("passstate", var8_10), true)
		end

		setWidgetText(arg0_10.progress, i18n("levelScene_threat_to_rule_out", ": "))
		table.insert(arg0_10.delayTween, LeanTween.value(go(arg0_10.progress), 0, var0_10.progress, 0.5):setDelay(0.15):setOnUpdate(System.Action_float(function(arg0_13)
			setSlider(arg0_10.progress, 0, 100, arg0_13)
			setText(arg0_10.txProgress, math.floor(arg0_13) .. "%")
		end)).uniqueId)
		arg0_10.achieveList:align(#var0_10.achieves)
		arg0_10.achieveList:each(function(arg0_14, arg1_14)
			local var0_14 = var0_10.achieves[arg0_14 + 1]
			local var1_14 = findTF(arg1_14, "desc")

			setText(var1_14, ChapterConst.GetAchieveDesc(var0_14.type, var0_10))
			setTextColor(var1_14, Color.white)
			setActive(findTF(arg1_14, "star"), false)
			setActive(findTF(arg1_14, "star_empty"), true)

			local var2_14 = ChapterConst.IsAchieved(var0_14)

			table.insert(arg0_10.delayTween, LeanTween.delayedCall(0.15 + (arg0_14 + 1) * 0.15, System.Action(function()
				if not IsNil(arg1_14) then
					local var0_15 = findTF(arg1_14, "desc")

					setTextColor(var0_15, var2_14 and Color.yellow or Color.white)
					setActive(findTF(arg1_14, "star"), var2_14)
					setActive(findTF(arg1_14, "star_empty"), not var2_14)
				end
			end)).uniqueId)
		end)
	end

	setText(arg0_10.txIntro, var2_10.profiles)
	setText(arg0_10.txCost, var2_10.oil)

	if var2_10.icon and var2_10.icon[1] then
		setActive(arg0_10.head.parent, true)
		setImageSprite(arg0_10.head, LoadSprite("qicon/" .. var2_10.icon[1]))
	else
		setActive(arg0_10.head.parent, false)
	end

	arg0_10.awards = var0_0.getChapterAwards(arg0_10.chapter)

	arg0_10.dropList:align(#arg0_10.awards)

	local var9_10 = var0_10:existLoop()

	setActive(arg0_10.bottomExtra, var9_10)

	if var9_10 then
		local var10_10 = var0_10:canActivateLoop()
		local var11_10 = "chapter_loop_flag_" .. var0_10.id
		local var12_10 = PlayerPrefs.GetInt(var11_10, -1)
		local var13_10 = (var12_10 == 1 or var12_10 == -1) and var10_10
		local var14_10 = #var0_10:getConfig("use_oil_limit") > 0

		setActive(arg0_10.loopOn, var13_10)
		setActive(arg0_10.loopOff, not var13_10)
		setActive(arg0_10.costLimitTip, var14_10)
		onNextTick(function()
			Canvas.ForceUpdateCanvases()

			arg0_10.layoutView.preferredWidth = var13_10 and arg0_10.rtViewContainer.rect.width or 0
		end)
		onButton(arg0_10, arg0_10.loopToggle, function()
			if not var10_10 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_activate_loop_mode_failed"))

				return
			end

			local var0_17 = not arg0_10.loopOn.gameObject.activeSelf

			PlayerPrefs.SetInt(var11_10, var0_17 and 1 or 0)
			PlayerPrefs.Save()
			setActive(arg0_10.loopOn, var0_17)
			setActive(arg0_10.loopOff, not var0_17)

			local var1_17 = 0
			local var2_17 = 0

			if var0_17 then
				var2_17 = arg0_10.rtViewContainer.rect.width
			else
				var1_17 = arg0_10.rtViewContainer.rect.width
			end

			if arg0_10.LTid then
				LeanTween.cancel(arg0_10.LTid)

				arg0_10.LTid = nil
			end

			arg0_10.LTid = LeanTween.value(var1_17, var2_17, 0.3):setOnUpdate(System.Action_float(function(arg0_18)
				arg0_10.layoutView.preferredWidth = arg0_18
			end)):setOnComplete(System.Action(function()
				arg0_10.LTid = nil
			end)).uniqueId
		end, SFX_PANEL)
		onButton(arg0_10, arg0_10.loopHelp, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("levelScene_loop_help_tip")
			})
		end)

		local var15_10 = AutoBotCommand.autoBotSatisfied()
		local var16_10 = "chapter_autofight_flag_" .. var0_10.id
		local var17_10 = var15_10 and PlayerPrefs.GetInt(var16_10, 1) == 1

		onToggle(arg0_10, arg0_10.autoFightToggle, function(arg0_21)
			if arg0_21 ~= var17_10 then
				var17_10 = arg0_21

				PlayerPrefs.SetInt(var16_10, var17_10 and 1 or 0)
				PlayerPrefs.Save()
			end
		end, SFX_UI_TAG)
		triggerToggle(arg0_10.autoFightToggle, var17_10)
		setActive(arg0_10.autoFightToggle, var15_10)
	end

	onButton(arg0_10, arg0_10.btnConfirm, function()
		if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

			return
		end

		if not arg0_10.onConfirm then
			return
		end

		local var0_22 = var9_10 and arg0_10.loopOn.gameObject.activeSelf and 1 or 0

		arg0_10.onConfirm(arg1_10, var0_22)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_10, arg0_10.btnConfirm_l, function()
		triggerButton(arg0_10.btnConfirm)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_10, arg0_10.btnCancel, function()
		if arg0_10.onCancel then
			arg0_10.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10._tf:Find("bg"), function()
		if arg0_10.onCancel then
			arg0_10.onCancel()
		end
	end, SFX_CANCEL)

	if not var0_10:getConfig("risk_levels") then
		local var18_10 = {}
	end

	onButton(arg0_10, arg0_10.passState, function()
		if not var0_10:hasMitigation() then
			return
		end

		local var0_26 = i18n("level_risk_level_desc", var0_10:getChapterState()) .. i18n("level_risk_level_mitigation_rate", var0_10:getRemainPassCount(), var0_10:getMitigationRate())

		if var1_10:getMapType() == Map.ELITE then
			var0_26 = var0_26 .. "\n" .. i18n("level_diffcult_chapter_state_safety")
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = var0_26
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.head, function()
		triggerButton(arg0_10.passState)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.winCondAwardBtn, function()
		arg0_10:ShowChapterRewardPanel()
	end)
	setText(arg0_10.descQuickPlay, i18n("desc_quick_play"))

	local var19_10 = var0_10:CanQuickPlay()

	setActive(arg0_10.quickPlayGroup, var19_10)

	if var19_10 then
		local var20_10 = "chapter_quickPlay_flag_" .. var0_10.id
		local var21_10 = PlayerPrefs.GetInt(var20_10, 1)

		onToggle(arg0_10, arg0_10.toggleQuickPlay, function(arg0_29)
			PlayerPrefs.SetInt(var20_10, arg0_29 and 1 or 0)
			PlayerPrefs.Save()
		end, SFX_PANEL)
		triggerToggle(arg0_10.toggleQuickPlay, var21_10 == 1)
	end

	if arg0_10.doEaseIn then
		local var22_10 = arg0_10._tf:Find("panel")

		var22_10.transform.localPosition = arg0_10.posStart

		table.insert(arg0_10.delayTween, LeanTween.move(var22_10, Vector3.zero, 0.2).uniqueId)

		var22_10.localScale = Vector3.zero

		table.insert(arg0_10.delayTween, LeanTween.scale(var22_10, Vector3(1, 1, 1), 0.2).uniqueId)
		table.insert(arg0_10.delayTween, LeanTween.moveX(arg0_10.passState, 0, 0.35):setEase(LeanTweenType.easeInOutSine):setDelay(0.3).uniqueId)
	end

	arg0_10:UpdateChapterAutoBtn()
end

function var0_0.UpdateChapterAutoBtn(arg0_30)
	local var0_30 = pg.chapter_auto_statistics[arg0_30.chapter.id]
	local var1_30 = ChapterAutoProxy.IsSystemOpen()

	setActive(arg0_30.btnAuto, var0_30)
	setActive(arg0_30.btnConfirm, var0_30)
	setActive(arg0_30.btnConfirm_l, not var0_30)

	if not var0_30 then
		return
	end

	local var2_30 = arg0_30.chapter:isClear()
	local var3_30 = getProxy(ChapterAutoProxy):GetRecord(ChapterAutoProxy.TYPE.SLG, arg0_30.chapter.id)
	local var4_30 = var1_30 and var2_30 and var3_30 > 0

	setGray(arg0_30.btnAuto, not var4_30, true)
	onButton(arg0_30, arg0_30.btnAuto, function()
		if var4_30 then
			arg0_30:ShowChapterAutoPanel()
		elseif var1_30 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_chapter_unlock_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_unlock_tip"))
		end
	end, SFX_PANEL)
end

function var0_0.cancelTween(arg0_32)
	_.each(arg0_32.delayTween, function(arg0_33)
		LeanTween.cancel(arg0_33)
	end)

	arg0_32.delayTween = {}
end

function var0_0.updateDrop(arg0_34, arg1_34, arg2_34, arg3_34)
	if arg1_34 == UIItemList.EventUpdate then
		local var0_34 = arg0_34.awards[arg2_34 + 1]
		local var1_34 = Drop.Create(var0_34)

		updateDrop(arg3_34, var1_34)
		onButton(arg0_34, arg3_34, function()
			if ({
				[99] = true
			})[var1_34:getConfig("type")] then
				local function var0_35(arg0_36)
					local var0_36 = var1_34:getConfig("display_icon")
					local var1_36 = {}

					for iter0_36, iter1_36 in ipairs(var0_36) do
						local var2_36 = iter1_36[1]
						local var3_36 = iter1_36[2]
						local var4_36 = var2_36 == DROP_TYPE_SHIP and not table.contains(arg0_36, var3_36)

						var1_36[#var1_36 + 1] = {
							type = var2_36,
							id = var3_36,
							anonymous = var4_36
						}
					end

					arg0_34:emit(BaseUI.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1_36,
						content = var1_34:getConfig("display")
					})
					arg0_34:initTestShowDrop(var1_34, Clone(var1_36))
				end

				arg0_34:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0_34.chapter.id, var0_35)
			else
				arg0_34:emit(BaseUI.ON_DROP, var1_34)
			end
		end, SFX_PANEL)
	end
end

function var0_0.getChapterAwards(arg0_37)
	local var0_37 = Clone(arg0_37:getConfig("awards"))
	local var1_37 = arg0_37:getStageExtraAwards()

	if var1_37 then
		for iter0_37 = #var1_37, 1, -1 do
			table.insert(var0_37, 1, var1_37[iter0_37])
		end
	end

	local var2_37 = {
		arg0_37:getConfig("boss_expedition_id"),
		arg0_37:getConfig("ai_expedition_list")
	}

	if arg0_37:getPlayType() == ChapterConst.TypeMultiStageBoss then
		table.insert(var2_37, pg.chapter_model_multistageboss[arg0_37.id].boss_expedition_id)
	end

	local var3_37 = _.flatten(var2_37)
	local var4_37 = {}
	local var5_37 = {}

	local function var6_37(arg0_38)
		for iter0_38, iter1_38 in ipairs(var4_37) do
			if iter1_38 == arg0_38 then
				return false
			end
		end

		return true
	end

	local var7_37 = {}

	for iter1_37, iter2_37 in ipairs(var3_37) do
		local var8_37 = checkExist(pg.expedition_activity_template[iter2_37], {
			"pt_drop_display"
		})

		if var8_37 and type(var8_37) == "table" then
			for iter3_37, iter4_37 in ipairs(var8_37) do
				local var9_37 = iter4_37[1]
				local var10_37 = iter4_37[2]
				local var11_37 = iter4_37[3]

				if var6_37(var10_37) then
					table.insert(var4_37, var10_37)

					var5_37[var10_37] = {}
				end

				var5_37[var10_37][var9_37] = true
				var7_37[var10_37] = var7_37[var10_37] or {}
				var7_37[var10_37][var9_37] = var11_37
			end
		end
	end

	local var12_37 = getProxy(ActivityProxy)

	for iter5_37 = #var4_37, 1, -1 do
		for iter6_37, iter7_37 in pairs(var5_37[var4_37[iter5_37]]) do
			local var13_37 = var12_37:getActivityById(iter6_37)

			if var13_37 and not var13_37:isEnd() then
				table.insert(var0_37, 1, {
					DROP_TYPE_ITEM,
					id2ItemId(var4_37[iter5_37]),
					var7_37[var4_37[iter5_37]][iter6_37]
				})

				break
			end
		end
	end

	return var0_37
end

function var0_0.initTestShowDrop(arg0_39, arg1_39, arg2_39)
	if IsUnityEditor then
		local var0_39 = pg.MsgboxMgr.GetInstance()._go
		local var1_39 = var0_39.transform:Find("button_test_show_drop")

		if IsNil(var1_39) then
			var1_39 = GameObject.New("button_test_show_drop")

			var1_39:AddComponent(typeof(Button))
			var1_39:AddComponent(typeof(RectTransform))
			var1_39:AddComponent(typeof(Image))
		end

		local var2_39 = var1_39:GetComponent(typeof(RectTransform))

		var2_39:SetParent(var0_39.transform, false)

		var2_39.anchoredPosition = Vector3(-239, 173, 0)
		var2_39.sizeDelta = Vector2(40, 40)

		onButton(arg0_39, var2_39, function()
			_.each(arg2_39, function(arg0_41)
				arg0_41.anonymous = false
			end)
			arg0_39:emit(BaseUI.ON_DROP_LIST, {
				item2Row = true,
				itemList = arg2_39,
				content = arg1_39:getConfig("display")
			})
		end)
	end
end

function var0_0.clearTestShowDrop(arg0_42)
	if IsUnityEditor then
		local var0_42 = pg.MsgboxMgr.GetInstance()._go.transform:Find("button_test_show_drop")

		if not IsNil(var0_42) then
			Destroy(var0_42)
		end
	end
end

function var0_0.ShowChapterRewardPanel(arg0_43)
	if arg0_43.rewardPanel == nil then
		arg0_43.rewardPanel = ChapterRewardPanel.New(arg0_43._tf.parent, arg0_43.event, arg0_43.contextData)

		arg0_43.rewardPanel:Load()
	end

	arg0_43.rewardPanel:ActionInvoke("Enter", arg0_43.chapter)
end

function var0_0.ClearChapterRewardPanel(arg0_44)
	if arg0_44.rewardPanel ~= nil then
		arg0_44.rewardPanel:Destroy()

		arg0_44.rewardPanel = nil
	end
end

function var0_0.ShowChapterAutoPanel(arg0_45)
	if arg0_45.autoPanel == nil then
		arg0_45.autoPanel = ChapterAutoPanel.New(arg0_45._tf, arg0_45.event, arg0_45.contextData)

		arg0_45.autoPanel:Load()
	end

	arg0_45.autoPanel:ActionInvoke("Enter", arg0_45.chapter)
end

function var0_0.RefreshChapterAutoPanel(arg0_46)
	if arg0_46.autoPanel and arg0_46.autoPanel:isShowing() then
		arg0_46.autoPanel:ActionInvoke("RefreshView")
	end
end

function var0_0.ClearChapterAutoPanel(arg0_47)
	if arg0_47.autoPanel ~= nil then
		arg0_47.autoPanel:Destroy()

		arg0_47.autoPanel = nil
	end
end

function var0_0.clear(arg0_48)
	arg0_48:cancelTween()
	arg0_48.dropList:each(function(arg0_49, arg1_49)
		clearDrop(arg1_49)
	end)
	arg0_48:clearTestShowDrop()
	arg0_48:ClearChapterRewardPanel()
	arg0_48:ClearChapterAutoPanel()
end

return var0_0
