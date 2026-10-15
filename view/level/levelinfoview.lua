local var0_0 = class("LevelInfoView", import("..base.BaseSubView"))

var0_0.CHAPTER_GUIDE_NAME = "CHAPTER_AUTO_GUIDE"

function var0_0.getUIName(arg0_1)
	return "LevelStageInfoView"
end

function var0_0.getResource(arg0_2)
	local var0_2 = {
		"ui/levelstageinfoview_atlas",
		"passstate"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.getLevelInfoViewResList(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = arg1_3 and arg1_3:getConfigTable()

	if var1_3 and var1_3.icon and var1_3.icon[1] then
		local var2_3 = string.format(ResPathSupport.ConstPath.SpineQIcon.Base, var1_3.icon[1], "")

		table.insert(var0_3, var2_3)
	end

	arg0_3:insertLevelInfoViewDropResList(var0_3, arg1_3)

	return var0_3
end

function var0_0.insertLevelInfoViewDropResList(arg0_4, arg1_4, arg2_4)
	if not arg2_4 then
		return
	end

	local var0_4 = var0_0.getChapterAwards(arg2_4)

	_.each(var0_4, function(arg0_5)
		local var0_5 = Drop.Create(arg0_5):getIcon()

		if noEmptyStr(var0_5) then
			table.insert(arg1_4, var0_5)
		end
	end)
end

function var0_0.downloadLevelInfoViewResList(arg0_6, arg1_6, arg2_6)
	SplitPackConst.DownloadByLuaArr(arg0_6:getLevelInfoViewResList(arg1_6), function()
		if arg0_6._state == var0_0.STATES.DESTROY then
			return
		end

		arg2_6()
	end)
end

function var0_0.OnInit(arg0_8)
	arg0_8.loader = AutoLoader.New()

	arg0_8:InitUI()
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9:isShowing() then
		arg0_9:Hide()
	end

	arg0_9.onConfirm = nil
	arg0_9.onCancel = nil

	if arg0_9.LTid then
		LeanTween.cancel(arg0_9.LTid)

		arg0_9.LTid = nil
	end

	arg0_9.loader:Clear()
end

function var0_0.Show(arg0_10)
	setActive(arg0_10._tf, true)
	arg0_10:BlurPanel(arg0_10._tf)
	arg0_10:CheckGuide()
end

function var0_0.CheckGuide(arg0_11)
	local var0_11 = ChapterAutoProxy.IsSystemOpen()
	local var1_11 = pg.chapter_auto_statistics[arg0_11.chapter.id]

	if not var0_11 or not var1_11 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_0.CHAPTER_GUIDE_NAME) then
		return
	end

	onNextTick(function()
		if arg0_11._state == var0_0.STATES.DESTROY or not arg0_11:isShowing() then
			return
		end

		if not pg.NewStoryMgr.GetInstance():IsPlayed(var0_0.CHAPTER_GUIDE_NAME) then
			pg.NewGuideMgr.GetInstance():Play(var0_0.CHAPTER_GUIDE_NAME)
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = var0_0.CHAPTER_GUIDE_NAME
			})
		end
	end)
end

function var0_0.Hide(arg0_13)
	arg0_13:clear()
	setActive(arg0_13._tf, false)
	arg0_13:UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
end

function var0_0.setCBFunc(arg0_14, arg1_14, arg2_14)
	arg0_14.onConfirm = arg1_14
	arg0_14.onCancel = arg2_14
end

function var0_0.InitUI(arg0_15)
	arg0_15.titleBG = arg0_15._tf:Find("panel/title")
	arg0_15.titleBGDecoration = arg0_15._tf:Find("panel/title/Image")
	arg0_15.titleIcon = arg0_15._tf:Find("panel/title/icon")
	arg0_15.txTitle = arg0_15._tf:Find("panel/title_form")
	arg0_15.txTitleOriginPosY = arg0_15.txTitle.anchoredPosition.y
	arg0_15.txTitleHead = arg0_15._tf:Find("panel/title_head")

	setActive(arg0_15.txTitleHead, false)

	arg0_15.txIntro = arg0_15._tf:Find("panel/intro")
	arg0_15.txCost = arg0_15._tf:Find("panel/cost/text")
	arg0_15.progressBar = arg0_15._tf:Find("panel/progress")
	arg0_15.txProgress = arg0_15._tf:Find("panel/progress/Text/value")
	arg0_15.progress = arg0_15._tf:Find("panel/progress")
	arg0_15.head = arg0_15._tf:Find("panel/head/Image")
	arg0_15.trAchieveTpl = arg0_15._tf:Find("panel/achieve")
	arg0_15.trAchieves = arg0_15._tf:Find("panel/achieves")
	arg0_15.passStateMask = arg0_15._tf:Find("panel/passState")
	arg0_15.passState = arg0_15._tf:Find("panel/passState/Image")

	setActive(arg0_15.passState, true)

	arg0_15.winCondDesc = arg0_15._tf:Find("panel/win_conditions/desc")
	arg0_15.winCondAwardBtn = arg0_15._tf:Find("panel/win_conditions/icon")
	arg0_15.loseCondDesc = arg0_15._tf:Find("panel/lose_conditions/desc")
	arg0_15.achieveList = UIItemList.New(arg0_15.trAchieves, arg0_15.trAchieveTpl)

	setActive(arg0_15.trAchieveTpl, false)

	arg0_15.trDropTpl = arg0_15._tf:Find("panel/drops/frame/list/item")
	arg0_15.trDrops = arg0_15._tf:Find("panel/drops/frame/list")
	arg0_15.dropList = UIItemList.New(arg0_15.trDrops, arg0_15.trDropTpl)

	arg0_15.dropList:make(function(arg0_16, arg1_16, arg2_16)
		arg0_15:updateDrop(arg0_16, arg1_16, arg2_16)
	end)
	setActive(arg0_15.trDropTpl, false)

	arg0_15.btnAuto = arg0_15._tf:Find("panel/auto_button")
	arg0_15.btnConfirm = arg0_15._tf:Find("panel/start_button")
	arg0_15.btnConfirm_l = arg0_15._tf:Find("panel/start_button_l")
	arg0_15.btnCancel = arg0_15._tf:Find("panel/btnBack")
	arg0_15.quickPlayGroup = arg0_15._tf:Find("panel/quickPlay")
	arg0_15.descQuickPlay = arg0_15.quickPlayGroup:Find("desc")
	arg0_15.toggleQuickPlay = arg0_15.quickPlayGroup:GetComponent(typeof(Toggle))
	arg0_15.bottomExtra = arg0_15._tf:Find("panel/BottomExtra")
	arg0_15.layoutView = GetComponent(arg0_15.bottomExtra:Find("LoopGroup/view"), typeof(LayoutElement))
	arg0_15.rtViewContainer = arg0_15.bottomExtra:Find("LoopGroup/view/container")

	setText(arg0_15.bottomExtra:Find("LoopGroup/Loop/Text"), i18n("autofight_farm"))

	arg0_15.loopToggle = arg0_15.bottomExtra:Find("LoopGroup/Loop/Toggle")
	arg0_15.loopOn = arg0_15.loopToggle:Find("on")
	arg0_15.loopOff = arg0_15.loopToggle:Find("off")
	arg0_15.loopHelp = arg0_15.bottomExtra:Find("ButtonHelp")
	arg0_15.costLimitTip = arg0_15.bottomExtra:Find("LoopGroup/view/container/CostLimit")

	setActive(arg0_15.costLimitTip, false)

	arg0_15.autoFightToggle = arg0_15.bottomExtra:Find("LoopGroup/view/container/AutoFight")

	setText(arg0_15.autoFightToggle:Find("Text"), i18n("autofight"))

	arg0_15.delayTween = {}
	arg0_15.doEaseIn = true
end

local var1_0 = 525
local var2_0 = 373

function var0_0.set(arg0_17, arg1_17, arg2_17)
	local var0_17 = getProxy(ChapterProxy):getChapterById(arg1_17, true)

	arg0_17:downloadLevelInfoViewResList(var0_17, function()
		arg0_17:setAfterResDownload(arg1_17, arg2_17, var0_17)
	end)
end

function var0_0.setAfterResDownload(arg0_19, arg1_19, arg2_19, arg3_19)
	arg0_19:cancelTween()

	arg0_19.chapter = arg3_19
	arg0_19.posStart = arg2_19 or Vector3(0, 0, 0)

	local var0_19 = getProxy(ChapterProxy):getMapById(arg3_19:getConfig("map"))
	local var1_19 = arg3_19:getConfigTable()
	local var2_19 = string.split(var1_19.name, "|")
	local var3_19 = arg3_19:getPlayType() == ChapterConst.TypeDefence

	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3_19 and "title_print_defense" or "title_print", function(arg0_20)
		if not IsNil(arg0_19.titleBGDecoration) then
			arg0_19.titleBGDecoration:GetComponent(typeof(Image)).sprite = arg0_20
		end
	end)
	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3_19 and "titlebar_bg_defense" or "titlebar_bg", function(arg0_21)
		if not IsNil(arg0_19.titleBG) then
			arg0_19.titleBG:GetComponent(typeof(Image)).sprite = arg0_21
		end
	end)
	setActive(arg0_19.titleIcon, var3_19)

	local var4_19 = arg0_19.progressBar.sizeDelta

	var4_19.x = var3_19 and var2_0 or var1_0
	arg0_19.progressBar.sizeDelta = var4_19

	setText(arg0_19.txTitle:Find("title_index"), var1_19.chapter_name .. "  ")
	setText(arg0_19.txTitle:Find("title"), var2_19[1])
	setText(arg0_19.txTitle:Find("title_en"), var2_19[2] or "")
	setActive(arg0_19.txTitleHead, var2_19[3] and #var2_19[3] > 0)

	local var5_19 = var2_19[3] and #var2_19[3] > 0 and arg0_19.txTitleOriginPosY or arg0_19.txTitleOriginPosY + 8

	setAnchoredPosition(arg0_19.txTitle, {
		y = var5_19
	})
	setText(arg0_19.txTitleHead, var2_19[3] or "")
	setText(arg0_19.winCondDesc, i18n("text_win_condition") .. "：" .. i18n(arg3_19:getConfig("win_condition_display")))
	setText(arg0_19.loseCondDesc, i18n("text_lose_condition") .. "：" .. i18n(arg3_19:getConfig("lose_condition_display")))
	setActive(arg0_19.winCondAwardBtn, arg3_19:getPlayType() == ChapterConst.TypeDefence)

	if not arg3_19:existAchieve() then
		setActive(arg0_19.passState, false)
		setActive(arg0_19.progress, false)
		setActive(arg0_19.trAchieves, false)
	else
		setActive(arg0_19.passState, true)
		setActive(arg0_19.progress, true)
		setActive(arg0_19.trAchieves, true)

		arg0_19.passState.localPosition = Vector3(-arg0_19.passState.rect.width, 0, 0)

		local var6_19 = arg3_19:hasMitigation()

		setActive(arg0_19.passState, var6_19)

		if var6_19 then
			local var7_19 = arg3_19:getRiskLevel()

			setImageSprite(arg0_19.passState, GetSpriteFromAtlas("passstate", var7_19), true)
		end

		setWidgetText(arg0_19.progress, i18n("levelScene_threat_to_rule_out", ": "))
		table.insert(arg0_19.delayTween, LeanTween.value(go(arg0_19.progress), 0, arg3_19.progress, 0.5):setDelay(0.15):setOnUpdate(System.Action_float(function(arg0_22)
			setSlider(arg0_19.progress, 0, 100, arg0_22)
			setText(arg0_19.txProgress, math.floor(arg0_22) .. "%")
		end)).uniqueId)
		arg0_19.achieveList:align(#arg3_19.achieves)
		arg0_19.achieveList:each(function(arg0_23, arg1_23)
			local var0_23 = arg3_19.achieves[arg0_23 + 1]
			local var1_23 = findTF(arg1_23, "desc")

			setText(var1_23, ChapterConst.GetAchieveDesc(var0_23.type, arg3_19))
			setTextColor(var1_23, Color.white)
			setActive(findTF(arg1_23, "star"), false)
			setActive(findTF(arg1_23, "star_empty"), true)

			local var2_23 = ChapterConst.IsAchieved(var0_23)

			table.insert(arg0_19.delayTween, LeanTween.delayedCall(0.15 + (arg0_23 + 1) * 0.15, System.Action(function()
				if not IsNil(arg1_23) then
					local var0_24 = findTF(arg1_23, "desc")

					setTextColor(var0_24, var2_23 and Color.yellow or Color.white)
					setActive(findTF(arg1_23, "star"), var2_23)
					setActive(findTF(arg1_23, "star_empty"), not var2_23)
				end
			end)).uniqueId)
		end)
	end

	setText(arg0_19.txIntro, var1_19.profiles)
	setText(arg0_19.txCost, var1_19.oil)

	if var1_19.icon and var1_19.icon[1] then
		setActive(arg0_19.head.parent, true)
		setImageSprite(arg0_19.head, LoadSprite("qicon/" .. var1_19.icon[1]))
	else
		setActive(arg0_19.head.parent, false)
	end

	arg0_19.awards = var0_0.getChapterAwards(arg0_19.chapter)

	arg0_19.dropList:align(#arg0_19.awards)

	local var8_19 = arg3_19:existLoop()

	setActive(arg0_19.bottomExtra, var8_19)

	if var8_19 then
		local var9_19 = arg3_19:canActivateLoop()
		local var10_19 = "chapter_loop_flag_" .. arg3_19.id
		local var11_19 = PlayerPrefs.GetInt(var10_19, -1)
		local var12_19 = (var11_19 == 1 or var11_19 == -1) and var9_19
		local var13_19 = #arg3_19:getConfig("use_oil_limit") > 0

		setActive(arg0_19.loopOn, var12_19)
		setActive(arg0_19.loopOff, not var12_19)
		setActive(arg0_19.costLimitTip, var13_19)
		onNextTick(function()
			Canvas.ForceUpdateCanvases()

			arg0_19.layoutView.preferredWidth = var12_19 and arg0_19.rtViewContainer.rect.width or 0
		end)
		onButton(arg0_19, arg0_19.loopToggle, function()
			if not var9_19 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_activate_loop_mode_failed"))

				return
			end

			local var0_26 = not arg0_19.loopOn.gameObject.activeSelf

			PlayerPrefs.SetInt(var10_19, var0_26 and 1 or 0)
			PlayerPrefs.Save()
			setActive(arg0_19.loopOn, var0_26)
			setActive(arg0_19.loopOff, not var0_26)

			local var1_26 = 0
			local var2_26 = 0

			if var0_26 then
				var2_26 = arg0_19.rtViewContainer.rect.width
			else
				var1_26 = arg0_19.rtViewContainer.rect.width
			end

			if arg0_19.LTid then
				LeanTween.cancel(arg0_19.LTid)

				arg0_19.LTid = nil
			end

			arg0_19.LTid = LeanTween.value(var1_26, var2_26, 0.3):setOnUpdate(System.Action_float(function(arg0_27)
				arg0_19.layoutView.preferredWidth = arg0_27
			end)):setOnComplete(System.Action(function()
				arg0_19.LTid = nil
			end)).uniqueId
		end, SFX_PANEL)
		onButton(arg0_19, arg0_19.loopHelp, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("levelScene_loop_help_tip")
			})
		end)

		local var14_19 = AutoBotCommand.autoBotSatisfied()
		local var15_19 = "chapter_autofight_flag_" .. arg3_19.id
		local var16_19 = var14_19 and PlayerPrefs.GetInt(var15_19, 1) == 1

		onToggle(arg0_19, arg0_19.autoFightToggle, function(arg0_30)
			if arg0_30 ~= var16_19 then
				var16_19 = arg0_30

				PlayerPrefs.SetInt(var15_19, var16_19 and 1 or 0)
				PlayerPrefs.Save()
			end
		end, SFX_UI_TAG)
		triggerToggle(arg0_19.autoFightToggle, var16_19)
		setActive(arg0_19.autoFightToggle, var14_19)
	end

	onButton(arg0_19, arg0_19.btnConfirm, function()
		if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

			return
		end

		if not arg0_19.onConfirm then
			return
		end

		local var0_31 = var8_19 and arg0_19.loopOn.gameObject.activeSelf and 1 or 0

		arg0_19.onConfirm(arg1_19, var0_31)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_19, arg0_19.btnConfirm_l, function()
		triggerButton(arg0_19.btnConfirm)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_19, arg0_19.btnCancel, function()
		if arg0_19.onCancel then
			arg0_19.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19._tf:Find("bg"), function()
		if arg0_19.onCancel then
			arg0_19.onCancel()
		end
	end, SFX_CANCEL)

	if not arg3_19:getConfig("risk_levels") then
		local var17_19 = {}
	end

	onButton(arg0_19, arg0_19.passState, function()
		if not arg3_19:hasMitigation() then
			return
		end

		local var0_35 = i18n("level_risk_level_desc", arg3_19:getChapterState()) .. i18n("level_risk_level_mitigation_rate", arg3_19:getRemainPassCount(), arg3_19:getMitigationRate())

		if var0_19:getMapType() == Map.ELITE then
			var0_35 = var0_35 .. "\n" .. i18n("level_diffcult_chapter_state_safety")
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = var0_35
		})
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.head, function()
		triggerButton(arg0_19.passState)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.winCondAwardBtn, function()
		arg0_19:ShowChapterRewardPanel()
	end)
	setText(arg0_19.descQuickPlay, i18n("desc_quick_play"))

	local var18_19 = arg3_19:CanQuickPlay()

	setActive(arg0_19.quickPlayGroup, var18_19)

	if var18_19 then
		local var19_19 = "chapter_quickPlay_flag_" .. arg3_19.id
		local var20_19 = PlayerPrefs.GetInt(var19_19, 1)

		onToggle(arg0_19, arg0_19.toggleQuickPlay, function(arg0_38)
			PlayerPrefs.SetInt(var19_19, arg0_38 and 1 or 0)
			PlayerPrefs.Save()
		end, SFX_PANEL)
		triggerToggle(arg0_19.toggleQuickPlay, var20_19 == 1)
	end

	if arg0_19.doEaseIn then
		local var21_19 = arg0_19._tf:Find("panel")

		var21_19.transform.localPosition = arg0_19.posStart

		table.insert(arg0_19.delayTween, LeanTween.move(var21_19, Vector3.zero, 0.2).uniqueId)

		var21_19.localScale = Vector3.zero

		table.insert(arg0_19.delayTween, LeanTween.scale(var21_19, Vector3(1, 1, 1), 0.2).uniqueId)
		table.insert(arg0_19.delayTween, LeanTween.moveX(arg0_19.passState, 0, 0.35):setEase(LeanTweenType.easeInOutSine):setDelay(0.3).uniqueId)
	end

	arg0_19:UpdateChapterAutoBtn()
end

function var0_0.UpdateChapterAutoBtn(arg0_39)
	local var0_39 = pg.chapter_auto_statistics[arg0_39.chapter.id]
	local var1_39 = ChapterAutoProxy.IsSystemOpen()

	setActive(arg0_39.btnAuto, var0_39)
	setActive(arg0_39.btnConfirm, var0_39)
	setActive(arg0_39.btnConfirm_l, not var0_39)

	if not var0_39 then
		return
	end

	local var2_39 = arg0_39.chapter:isClear()
	local var3_39 = getProxy(ChapterAutoProxy):GetRecord(ChapterAutoProxy.TYPE.SLG, arg0_39.chapter.id)
	local var4_39 = var1_39 and var2_39 and var3_39 > 0

	setGray(arg0_39.btnAuto, not var4_39, true)
	onButton(arg0_39, arg0_39.btnAuto, function()
		if var4_39 then
			local var0_40 = getProxy(ChapterAutoProxy):GetCommissionDoingType()

			if not var0_40 then
				arg0_39:ShowChapterAutoPanel()
			else
				arg0_39:CheckChapterAutoOccupied(var0_40)
			end
		elseif var1_39 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_chapter_unlock_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_unlock_tip"))
		end
	end, SFX_PANEL)
end

function var0_0.CheckChapterAutoOccupied(arg0_41, arg1_41)
	switch(arg1_41, {
		[ChapterAutoProxy.TYPE.WORLD] = function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("auto_battle_in_world"),
				onYes = function()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
				end,
				yesText = i18n("auto_drop_is_activation_go"),
				noText = i18n("auto_drop_is_activation_cancle")
			})
		end
	})
end

function var0_0.cancelTween(arg0_44)
	_.each(arg0_44.delayTween, function(arg0_45)
		LeanTween.cancel(arg0_45)
	end)

	arg0_44.delayTween = {}
end

function var0_0.updateDrop(arg0_46, arg1_46, arg2_46, arg3_46)
	if arg1_46 == UIItemList.EventUpdate then
		local var0_46 = arg0_46.awards[arg2_46 + 1]
		local var1_46 = Drop.Create(var0_46)

		updateDrop(arg3_46, var1_46)
		onButton(arg0_46, arg3_46, function()
			if ({
				[99] = true
			})[var1_46:getConfig("type")] then
				local function var0_47(arg0_48)
					local var0_48 = var1_46:getConfig("display_icon")
					local var1_48 = {}

					for iter0_48, iter1_48 in ipairs(var0_48) do
						local var2_48 = iter1_48[1]
						local var3_48 = iter1_48[2]
						local var4_48 = var2_48 == DROP_TYPE_SHIP and not table.contains(arg0_48, var3_48)

						var1_48[#var1_48 + 1] = {
							type = var2_48,
							id = var3_48,
							anonymous = var4_48
						}
					end

					arg0_46:emit(BaseUI.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1_48,
						content = var1_46:getConfig("display")
					})
					arg0_46:initTestShowDrop(var1_46, Clone(var1_48))
				end

				arg0_46:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0_46.chapter.id, var0_47)
			else
				arg0_46:emit(BaseUI.ON_DROP, var1_46)
			end
		end, SFX_PANEL)
	end
end

function var0_0.getChapterAwards(arg0_49)
	local var0_49 = Clone(arg0_49:getConfig("awards"))
	local var1_49 = arg0_49:getStageExtraAwards()

	if var1_49 then
		for iter0_49 = #var1_49, 1, -1 do
			table.insert(var0_49, 1, var1_49[iter0_49])
		end
	end

	local function var2_49(arg0_50)
		return _.all(arg0_50, function(arg0_51)
			return #arg0_51 >= 3
		end)
	end

	local var3_49 = {
		arg0_49:getConfig("boss_expedition_id"),
		arg0_49:getConfig("ai_expedition_list")
	}

	if arg0_49:getPlayType() == ChapterConst.TypeMultiStageBoss then
		table.insert(var3_49, pg.chapter_model_multistageboss[arg0_49.id].boss_expedition_id)
	end

	local var4_49 = _.flatten(var3_49)
	local var5_49 = {}
	local var6_49 = {}

	for iter1_49, iter2_49 in ipairs(var4_49) do
		local var7_49 = checkExist(pg.expedition_activity_template[iter2_49], {
			"pt_drop_display"
		})

		if var7_49 and type(var7_49) == "table" and var2_49(var7_49) then
			for iter3_49, iter4_49 in ipairs(var7_49) do
				local var8_49, var9_49, var10_49, var11_49 = unpack(iter4_49)
				local var12_49 = var9_49 .. "_" .. var10_49

				if not var6_49[var12_49] then
					var6_49[var12_49] = {}

					table.insert(var5_49, var12_49)
				end

				var6_49[var12_49][var8_49] = var11_49
			end
		end
	end

	local var13_49 = getProxy(ActivityProxy)

	for iter5_49 = #var5_49, 1, -1 do
		local var14_49, var15_49 = unpack(underscore.map(string.split(var5_49[iter5_49], "_"), function(arg0_52)
			return tonumber(arg0_52)
		end))

		for iter6_49, iter7_49 in pairs(var6_49[var5_49[iter5_49]]) do
			local var16_49 = var13_49:getActivityById(iter6_49)

			if var16_49 and not var16_49:isEnd() then
				if var14_49 == DROP_TYPE_RESOURCE then
					table.insert(var0_49, 1, {
						DROP_TYPE_ITEM,
						id2ItemId(var15_49),
						iter7_49
					})

					break
				end

				table.insert(var0_49, 1, {
					var14_49,
					var15_49,
					iter7_49
				})

				break
			end
		end
	end

	return var0_49
end

function var0_0.initTestShowDrop(arg0_53, arg1_53, arg2_53)
	if IsUnityEditor then
		local var0_53 = pg.MsgboxMgr.GetInstance()._go
		local var1_53 = var0_53.transform:Find("button_test_show_drop")

		if IsNil(var1_53) then
			var1_53 = GameObject.New("button_test_show_drop")

			var1_53:AddComponent(typeof(Button))
			var1_53:AddComponent(typeof(RectTransform))
			var1_53:AddComponent(typeof(Image))
		end

		local var2_53 = var1_53:GetComponent(typeof(RectTransform))

		var2_53:SetParent(var0_53.transform, false)

		var2_53.anchoredPosition = Vector3(-239, 173, 0)
		var2_53.sizeDelta = Vector2(40, 40)

		onButton(arg0_53, var2_53, function()
			_.each(arg2_53, function(arg0_55)
				arg0_55.anonymous = false
			end)
			arg0_53:emit(BaseUI.ON_DROP_LIST, {
				item2Row = true,
				itemList = arg2_53,
				content = arg1_53:getConfig("display")
			})
		end)
	end
end

function var0_0.clearTestShowDrop(arg0_56)
	if IsUnityEditor then
		local var0_56 = pg.MsgboxMgr.GetInstance()._go.transform:Find("button_test_show_drop")

		if not IsNil(var0_56) then
			Destroy(var0_56)
		end
	end
end

function var0_0.ShowChapterRewardPanel(arg0_57)
	if arg0_57.rewardPanel == nil then
		arg0_57.rewardPanel = ChapterRewardPanel.New(arg0_57._tf.parent, arg0_57.event, arg0_57.contextData)

		arg0_57.rewardPanel:Load()
	end

	arg0_57.rewardPanel:ActionInvoke("Enter", arg0_57.chapter)
end

function var0_0.ClearChapterRewardPanel(arg0_58)
	if arg0_58.rewardPanel ~= nil then
		arg0_58.rewardPanel:Destroy()

		arg0_58.rewardPanel = nil
	end
end

function var0_0.ShowChapterAutoPanel(arg0_59)
	if arg0_59.autoPanel == nil then
		arg0_59.autoPanel = ChapterAutoPanel.New(arg0_59._tf, arg0_59.event, arg0_59.contextData)

		arg0_59.autoPanel:Load()
	end

	arg0_59.autoPanel:ActionInvoke("Enter", arg0_59.chapter)
end

function var0_0.RefreshChapterAutoPanel(arg0_60)
	if arg0_60.autoPanel and arg0_60.autoPanel:isShowing() then
		arg0_60.autoPanel:ActionInvoke("RefreshView")
	end
end

function var0_0.ClearChapterAutoPanel(arg0_61)
	if arg0_61.autoPanel ~= nil then
		arg0_61.autoPanel:Destroy()

		arg0_61.autoPanel = nil
	end
end

function var0_0.clear(arg0_62)
	arg0_62:cancelTween()
	arg0_62.dropList:each(function(arg0_63, arg1_63)
		clearDrop(arg1_63)
	end)
	arg0_62:clearTestShowDrop()
	arg0_62:ClearChapterRewardPanel()
	arg0_62:ClearChapterAutoPanel()
end

return var0_0
