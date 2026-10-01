local var0_0 = class("LevelInfoView", import("..base.BaseSubView"))

var0_0.CHAPTER_GUIDE_NAME = "CHAPTER_AUTO_GUIDE"

function var0_0.getUIName(arg0_1)
	return "LevelStageInfoView"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/levelstageinfoview_atlas",
		"passstate"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
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

	if var0_11 and var1_11 and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_0.CHAPTER_GUIDE_NAME) then
		pg.NewGuideMgr.GetInstance():Play(var0_0.CHAPTER_GUIDE_NAME)
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = var0_0.CHAPTER_GUIDE_NAME
		})
	end
end

function var0_0.Hide(arg0_12)
	arg0_12:clear()
	setActive(arg0_12._tf, false)
	arg0_12:UnOverlayPanel(arg0_12._tf, arg0_12._parentTf)
end

function var0_0.setCBFunc(arg0_13, arg1_13, arg2_13)
	arg0_13.onConfirm = arg1_13
	arg0_13.onCancel = arg2_13
end

function var0_0.InitUI(arg0_14)
	arg0_14.titleBG = arg0_14._tf:Find("panel/title")
	arg0_14.titleBGDecoration = arg0_14._tf:Find("panel/title/Image")
	arg0_14.titleIcon = arg0_14._tf:Find("panel/title/icon")
	arg0_14.txTitle = arg0_14._tf:Find("panel/title_form")
	arg0_14.txTitleOriginPosY = arg0_14.txTitle.anchoredPosition.y
	arg0_14.txTitleHead = arg0_14._tf:Find("panel/title_head")

	setActive(arg0_14.txTitleHead, false)

	arg0_14.txIntro = arg0_14._tf:Find("panel/intro")
	arg0_14.txCost = arg0_14._tf:Find("panel/cost/text")
	arg0_14.progressBar = arg0_14._tf:Find("panel/progress")
	arg0_14.txProgress = arg0_14._tf:Find("panel/progress/Text/value")
	arg0_14.progress = arg0_14._tf:Find("panel/progress")
	arg0_14.head = arg0_14._tf:Find("panel/head/Image")
	arg0_14.trAchieveTpl = arg0_14._tf:Find("panel/achieve")
	arg0_14.trAchieves = arg0_14._tf:Find("panel/achieves")
	arg0_14.passStateMask = arg0_14._tf:Find("panel/passState")
	arg0_14.passState = arg0_14._tf:Find("panel/passState/Image")

	setActive(arg0_14.passState, true)

	arg0_14.winCondDesc = arg0_14._tf:Find("panel/win_conditions/desc")
	arg0_14.winCondAwardBtn = arg0_14._tf:Find("panel/win_conditions/icon")
	arg0_14.loseCondDesc = arg0_14._tf:Find("panel/lose_conditions/desc")
	arg0_14.achieveList = UIItemList.New(arg0_14.trAchieves, arg0_14.trAchieveTpl)

	setActive(arg0_14.trAchieveTpl, false)

	arg0_14.trDropTpl = arg0_14._tf:Find("panel/drops/frame/list/item")
	arg0_14.trDrops = arg0_14._tf:Find("panel/drops/frame/list")
	arg0_14.dropList = UIItemList.New(arg0_14.trDrops, arg0_14.trDropTpl)

	arg0_14.dropList:make(function(arg0_15, arg1_15, arg2_15)
		arg0_14:updateDrop(arg0_15, arg1_15, arg2_15)
	end)
	setActive(arg0_14.trDropTpl, false)

	arg0_14.btnAuto = arg0_14._tf:Find("panel/auto_button")
	arg0_14.btnConfirm = arg0_14._tf:Find("panel/start_button")
	arg0_14.btnConfirm_l = arg0_14._tf:Find("panel/start_button_l")
	arg0_14.btnCancel = arg0_14._tf:Find("panel/btnBack")
	arg0_14.quickPlayGroup = arg0_14._tf:Find("panel/quickPlay")
	arg0_14.descQuickPlay = arg0_14.quickPlayGroup:Find("desc")
	arg0_14.toggleQuickPlay = arg0_14.quickPlayGroup:GetComponent(typeof(Toggle))
	arg0_14.bottomExtra = arg0_14._tf:Find("panel/BottomExtra")
	arg0_14.layoutView = GetComponent(arg0_14.bottomExtra:Find("LoopGroup/view"), typeof(LayoutElement))
	arg0_14.rtViewContainer = arg0_14.bottomExtra:Find("LoopGroup/view/container")

	setText(arg0_14.bottomExtra:Find("LoopGroup/Loop/Text"), i18n("autofight_farm"))

	arg0_14.loopToggle = arg0_14.bottomExtra:Find("LoopGroup/Loop/Toggle")
	arg0_14.loopOn = arg0_14.loopToggle:Find("on")
	arg0_14.loopOff = arg0_14.loopToggle:Find("off")
	arg0_14.loopHelp = arg0_14.bottomExtra:Find("ButtonHelp")
	arg0_14.costLimitTip = arg0_14.bottomExtra:Find("LoopGroup/view/container/CostLimit")

	setActive(arg0_14.costLimitTip, false)

	arg0_14.autoFightToggle = arg0_14.bottomExtra:Find("LoopGroup/view/container/AutoFight")

	setText(arg0_14.autoFightToggle:Find("Text"), i18n("autofight"))

	arg0_14.delayTween = {}
	arg0_14.doEaseIn = true
end

local var1_0 = 525
local var2_0 = 373

function var0_0.set(arg0_16, arg1_16, arg2_16)
	local var0_16 = getProxy(ChapterProxy):getChapterById(arg1_16, true)

	arg0_16:downloadLevelInfoViewResList(var0_16, function()
		arg0_16:setAfterResDownload(arg1_16, arg2_16, var0_16)
	end)
end

function var0_0.setAfterResDownload(arg0_18, arg1_18, arg2_18, arg3_18)
	arg0_18:cancelTween()

	arg0_18.chapter = arg3_18
	arg0_18.posStart = arg2_18 or Vector3(0, 0, 0)

	local var0_18 = getProxy(ChapterProxy):getMapById(arg3_18:getConfig("map"))
	local var1_18 = arg3_18:getConfigTable()
	local var2_18 = string.split(var1_18.name, "|")
	local var3_18 = arg3_18:getPlayType() == ChapterConst.TypeDefence

	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3_18 and "title_print_defense" or "title_print", function(arg0_19)
		if not IsNil(arg0_18.titleBGDecoration) then
			arg0_18.titleBGDecoration:GetComponent(typeof(Image)).sprite = arg0_19
		end
	end)
	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3_18 and "titlebar_bg_defense" or "titlebar_bg", function(arg0_20)
		if not IsNil(arg0_18.titleBG) then
			arg0_18.titleBG:GetComponent(typeof(Image)).sprite = arg0_20
		end
	end)
	setActive(arg0_18.titleIcon, var3_18)

	local var4_18 = arg0_18.progressBar.sizeDelta

	var4_18.x = var3_18 and var2_0 or var1_0
	arg0_18.progressBar.sizeDelta = var4_18

	setText(arg0_18.txTitle:Find("title_index"), var1_18.chapter_name .. "  ")
	setText(arg0_18.txTitle:Find("title"), var2_18[1])
	setText(arg0_18.txTitle:Find("title_en"), var2_18[2] or "")
	setActive(arg0_18.txTitleHead, var2_18[3] and #var2_18[3] > 0)

	local var5_18 = var2_18[3] and #var2_18[3] > 0 and arg0_18.txTitleOriginPosY or arg0_18.txTitleOriginPosY + 8

	setAnchoredPosition(arg0_18.txTitle, {
		y = var5_18
	})
	setText(arg0_18.txTitleHead, var2_18[3] or "")
	setText(arg0_18.winCondDesc, i18n("text_win_condition") .. "：" .. i18n(arg3_18:getConfig("win_condition_display")))
	setText(arg0_18.loseCondDesc, i18n("text_lose_condition") .. "：" .. i18n(arg3_18:getConfig("lose_condition_display")))
	setActive(arg0_18.winCondAwardBtn, arg3_18:getPlayType() == ChapterConst.TypeDefence)

	if not arg3_18:existAchieve() then
		setActive(arg0_18.passState, false)
		setActive(arg0_18.progress, false)
		setActive(arg0_18.trAchieves, false)
	else
		setActive(arg0_18.passState, true)
		setActive(arg0_18.progress, true)
		setActive(arg0_18.trAchieves, true)

		arg0_18.passState.localPosition = Vector3(-arg0_18.passState.rect.width, 0, 0)

		local var6_18 = arg3_18:hasMitigation()

		setActive(arg0_18.passState, var6_18)

		if var6_18 then
			local var7_18 = arg3_18:getRiskLevel()

			setImageSprite(arg0_18.passState, GetSpriteFromAtlas("passstate", var7_18), true)
		end

		setWidgetText(arg0_18.progress, i18n("levelScene_threat_to_rule_out", ": "))
		table.insert(arg0_18.delayTween, LeanTween.value(go(arg0_18.progress), 0, arg3_18.progress, 0.5):setDelay(0.15):setOnUpdate(System.Action_float(function(arg0_21)
			setSlider(arg0_18.progress, 0, 100, arg0_21)
			setText(arg0_18.txProgress, math.floor(arg0_21) .. "%")
		end)).uniqueId)
		arg0_18.achieveList:align(#arg3_18.achieves)
		arg0_18.achieveList:each(function(arg0_22, arg1_22)
			local var0_22 = arg3_18.achieves[arg0_22 + 1]
			local var1_22 = findTF(arg1_22, "desc")

			setText(var1_22, ChapterConst.GetAchieveDesc(var0_22.type, arg3_18))
			setTextColor(var1_22, Color.white)
			setActive(findTF(arg1_22, "star"), false)
			setActive(findTF(arg1_22, "star_empty"), true)

			local var2_22 = ChapterConst.IsAchieved(var0_22)

			table.insert(arg0_18.delayTween, LeanTween.delayedCall(0.15 + (arg0_22 + 1) * 0.15, System.Action(function()
				if not IsNil(arg1_22) then
					local var0_23 = findTF(arg1_22, "desc")

					setTextColor(var0_23, var2_22 and Color.yellow or Color.white)
					setActive(findTF(arg1_22, "star"), var2_22)
					setActive(findTF(arg1_22, "star_empty"), not var2_22)
				end
			end)).uniqueId)
		end)
	end

	setText(arg0_18.txIntro, var1_18.profiles)
	setText(arg0_18.txCost, var1_18.oil)

	if var1_18.icon and var1_18.icon[1] then
		setActive(arg0_18.head.parent, true)
		setImageSprite(arg0_18.head, LoadSprite("qicon/" .. var1_18.icon[1]))
	else
		setActive(arg0_18.head.parent, false)
	end

	arg0_18.awards = var0_0.getChapterAwards(arg0_18.chapter)

	arg0_18.dropList:align(#arg0_18.awards)

	local var8_18 = arg3_18:existLoop()

	setActive(arg0_18.bottomExtra, var8_18)

	if var8_18 then
		local var9_18 = arg3_18:canActivateLoop()
		local var10_18 = "chapter_loop_flag_" .. arg3_18.id
		local var11_18 = PlayerPrefs.GetInt(var10_18, -1)
		local var12_18 = (var11_18 == 1 or var11_18 == -1) and var9_18
		local var13_18 = #arg3_18:getConfig("use_oil_limit") > 0

		setActive(arg0_18.loopOn, var12_18)
		setActive(arg0_18.loopOff, not var12_18)
		setActive(arg0_18.costLimitTip, var13_18)
		onNextTick(function()
			Canvas.ForceUpdateCanvases()

			arg0_18.layoutView.preferredWidth = var12_18 and arg0_18.rtViewContainer.rect.width or 0
		end)
		onButton(arg0_18, arg0_18.loopToggle, function()
			if not var9_18 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_activate_loop_mode_failed"))

				return
			end

			local var0_25 = not arg0_18.loopOn.gameObject.activeSelf

			PlayerPrefs.SetInt(var10_18, var0_25 and 1 or 0)
			PlayerPrefs.Save()
			setActive(arg0_18.loopOn, var0_25)
			setActive(arg0_18.loopOff, not var0_25)

			local var1_25 = 0
			local var2_25 = 0

			if var0_25 then
				var2_25 = arg0_18.rtViewContainer.rect.width
			else
				var1_25 = arg0_18.rtViewContainer.rect.width
			end

			if arg0_18.LTid then
				LeanTween.cancel(arg0_18.LTid)

				arg0_18.LTid = nil
			end

			arg0_18.LTid = LeanTween.value(var1_25, var2_25, 0.3):setOnUpdate(System.Action_float(function(arg0_26)
				arg0_18.layoutView.preferredWidth = arg0_26
			end)):setOnComplete(System.Action(function()
				arg0_18.LTid = nil
			end)).uniqueId
		end, SFX_PANEL)
		onButton(arg0_18, arg0_18.loopHelp, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("levelScene_loop_help_tip")
			})
		end)

		local var14_18 = AutoBotCommand.autoBotSatisfied()
		local var15_18 = "chapter_autofight_flag_" .. arg3_18.id
		local var16_18 = var14_18 and PlayerPrefs.GetInt(var15_18, 1) == 1

		onToggle(arg0_18, arg0_18.autoFightToggle, function(arg0_29)
			if arg0_29 ~= var16_18 then
				var16_18 = arg0_29

				PlayerPrefs.SetInt(var15_18, var16_18 and 1 or 0)
				PlayerPrefs.Save()
			end
		end, SFX_UI_TAG)
		triggerToggle(arg0_18.autoFightToggle, var16_18)
		setActive(arg0_18.autoFightToggle, var14_18)
	end

	onButton(arg0_18, arg0_18.btnConfirm, function()
		if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

			return
		end

		if not arg0_18.onConfirm then
			return
		end

		local var0_30 = var8_18 and arg0_18.loopOn.gameObject.activeSelf and 1 or 0

		arg0_18.onConfirm(arg1_18, var0_30)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_18, arg0_18.btnConfirm_l, function()
		triggerButton(arg0_18.btnConfirm)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_18, arg0_18.btnCancel, function()
		if arg0_18.onCancel then
			arg0_18.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18._tf:Find("bg"), function()
		if arg0_18.onCancel then
			arg0_18.onCancel()
		end
	end, SFX_CANCEL)

	if not arg3_18:getConfig("risk_levels") then
		local var17_18 = {}
	end

	onButton(arg0_18, arg0_18.passState, function()
		if not arg3_18:hasMitigation() then
			return
		end

		local var0_34 = i18n("level_risk_level_desc", arg3_18:getChapterState()) .. i18n("level_risk_level_mitigation_rate", arg3_18:getRemainPassCount(), arg3_18:getMitigationRate())

		if var0_18:getMapType() == Map.ELITE then
			var0_34 = var0_34 .. "\n" .. i18n("level_diffcult_chapter_state_safety")
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = var0_34
		})
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.head, function()
		triggerButton(arg0_18.passState)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.winCondAwardBtn, function()
		arg0_18:ShowChapterRewardPanel()
	end)
	setText(arg0_18.descQuickPlay, i18n("desc_quick_play"))

	local var18_18 = arg3_18:CanQuickPlay()

	setActive(arg0_18.quickPlayGroup, var18_18)

	if var18_18 then
		local var19_18 = "chapter_quickPlay_flag_" .. arg3_18.id
		local var20_18 = PlayerPrefs.GetInt(var19_18, 1)

		onToggle(arg0_18, arg0_18.toggleQuickPlay, function(arg0_37)
			PlayerPrefs.SetInt(var19_18, arg0_37 and 1 or 0)
			PlayerPrefs.Save()
		end, SFX_PANEL)
		triggerToggle(arg0_18.toggleQuickPlay, var20_18 == 1)
	end

	if arg0_18.doEaseIn then
		local var21_18 = arg0_18._tf:Find("panel")

		var21_18.transform.localPosition = arg0_18.posStart

		table.insert(arg0_18.delayTween, LeanTween.move(var21_18, Vector3.zero, 0.2).uniqueId)

		var21_18.localScale = Vector3.zero

		table.insert(arg0_18.delayTween, LeanTween.scale(var21_18, Vector3(1, 1, 1), 0.2).uniqueId)
		table.insert(arg0_18.delayTween, LeanTween.moveX(arg0_18.passState, 0, 0.35):setEase(LeanTweenType.easeInOutSine):setDelay(0.3).uniqueId)
	end

	arg0_18:UpdateChapterAutoBtn()
end

function var0_0.UpdateChapterAutoBtn(arg0_38)
	local var0_38 = pg.chapter_auto_statistics[arg0_38.chapter.id]
	local var1_38 = ChapterAutoProxy.IsSystemOpen()

	setActive(arg0_38.btnAuto, var0_38)
	setActive(arg0_38.btnConfirm, var0_38)
	setActive(arg0_38.btnConfirm_l, not var0_38)

	if not var0_38 then
		return
	end

	local var2_38 = arg0_38.chapter:isClear()
	local var3_38 = getProxy(ChapterAutoProxy):GetRecord(ChapterAutoProxy.TYPE.SLG, arg0_38.chapter.id)
	local var4_38 = var1_38 and var2_38 and var3_38 > 0

	setGray(arg0_38.btnAuto, not var4_38, true)
	onButton(arg0_38, arg0_38.btnAuto, function()
		if var4_38 then
			local var0_39 = getProxy(ChapterAutoProxy):GetCommissionDoingType()

			if not var0_39 then
				arg0_38:ShowChapterAutoPanel()
			else
				arg0_38:CheckChapterAutoOccupied(var0_39)
			end
		elseif var1_38 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_chapter_unlock_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_unlock_tip"))
		end
	end, SFX_PANEL)
end

function var0_0.CheckChapterAutoOccupied(arg0_40, arg1_40)
	switch(arg1_40, {
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

function var0_0.cancelTween(arg0_43)
	_.each(arg0_43.delayTween, function(arg0_44)
		LeanTween.cancel(arg0_44)
	end)

	arg0_43.delayTween = {}
end

function var0_0.updateDrop(arg0_45, arg1_45, arg2_45, arg3_45)
	if arg1_45 == UIItemList.EventUpdate then
		local var0_45 = arg0_45.awards[arg2_45 + 1]
		local var1_45 = Drop.Create(var0_45)

		updateDrop(arg3_45, var1_45)
		onButton(arg0_45, arg3_45, function()
			if ({
				[99] = true
			})[var1_45:getConfig("type")] then
				local function var0_46(arg0_47)
					local var0_47 = var1_45:getConfig("display_icon")
					local var1_47 = {}

					for iter0_47, iter1_47 in ipairs(var0_47) do
						local var2_47 = iter1_47[1]
						local var3_47 = iter1_47[2]
						local var4_47 = var2_47 == DROP_TYPE_SHIP and not table.contains(arg0_47, var3_47)

						var1_47[#var1_47 + 1] = {
							type = var2_47,
							id = var3_47,
							anonymous = var4_47
						}
					end

					arg0_45:emit(BaseUI.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1_47,
						content = var1_45:getConfig("display")
					})
					arg0_45:initTestShowDrop(var1_45, Clone(var1_47))
				end

				arg0_45:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0_45.chapter.id, var0_46)
			else
				arg0_45:emit(BaseUI.ON_DROP, var1_45)
			end
		end, SFX_PANEL)
	end
end

function var0_0.getChapterAwards(arg0_48)
	local var0_48 = Clone(arg0_48:getConfig("awards"))
	local var1_48 = arg0_48:getStageExtraAwards()

	if var1_48 then
		for iter0_48 = #var1_48, 1, -1 do
			table.insert(var0_48, 1, var1_48[iter0_48])
		end
	end

	local var2_48 = {
		arg0_48:getConfig("boss_expedition_id"),
		arg0_48:getConfig("ai_expedition_list")
	}

	if arg0_48:getPlayType() == ChapterConst.TypeMultiStageBoss then
		table.insert(var2_48, pg.chapter_model_multistageboss[arg0_48.id].boss_expedition_id)
	end

	local var3_48 = _.flatten(var2_48)
	local var4_48 = {}
	local var5_48 = {}

	local function var6_48(arg0_49)
		for iter0_49, iter1_49 in ipairs(var4_48) do
			if iter1_49 == arg0_49 then
				return false
			end
		end

		return true
	end

	local var7_48 = {}

	for iter1_48, iter2_48 in ipairs(var3_48) do
		local var8_48 = checkExist(pg.expedition_activity_template[iter2_48], {
			"pt_drop_display"
		})

		if var8_48 and type(var8_48) == "table" then
			for iter3_48, iter4_48 in ipairs(var8_48) do
				local var9_48 = iter4_48[1]
				local var10_48 = iter4_48[2]
				local var11_48 = iter4_48[3]

				if var6_48(var10_48) then
					table.insert(var4_48, var10_48)

					var5_48[var10_48] = {}
				end

				var5_48[var10_48][var9_48] = true
				var7_48[var10_48] = var7_48[var10_48] or {}
				var7_48[var10_48][var9_48] = var11_48
			end
		end
	end

	local var12_48 = getProxy(ActivityProxy)

	for iter5_48 = #var4_48, 1, -1 do
		for iter6_48, iter7_48 in pairs(var5_48[var4_48[iter5_48]]) do
			local var13_48 = var12_48:getActivityById(iter6_48)

			if var13_48 and not var13_48:isEnd() then
				table.insert(var0_48, 1, {
					DROP_TYPE_ITEM,
					id2ItemId(var4_48[iter5_48]),
					var7_48[var4_48[iter5_48]][iter6_48]
				})

				break
			end
		end
	end

	return var0_48
end

function var0_0.initTestShowDrop(arg0_50, arg1_50, arg2_50)
	if IsUnityEditor then
		local var0_50 = pg.MsgboxMgr.GetInstance()._go
		local var1_50 = var0_50.transform:Find("button_test_show_drop")

		if IsNil(var1_50) then
			var1_50 = GameObject.New("button_test_show_drop")

			var1_50:AddComponent(typeof(Button))
			var1_50:AddComponent(typeof(RectTransform))
			var1_50:AddComponent(typeof(Image))
		end

		local var2_50 = var1_50:GetComponent(typeof(RectTransform))

		var2_50:SetParent(var0_50.transform, false)

		var2_50.anchoredPosition = Vector3(-239, 173, 0)
		var2_50.sizeDelta = Vector2(40, 40)

		onButton(arg0_50, var2_50, function()
			_.each(arg2_50, function(arg0_52)
				arg0_52.anonymous = false
			end)
			arg0_50:emit(BaseUI.ON_DROP_LIST, {
				item2Row = true,
				itemList = arg2_50,
				content = arg1_50:getConfig("display")
			})
		end)
	end
end

function var0_0.clearTestShowDrop(arg0_53)
	if IsUnityEditor then
		local var0_53 = pg.MsgboxMgr.GetInstance()._go.transform:Find("button_test_show_drop")

		if not IsNil(var0_53) then
			Destroy(var0_53)
		end
	end
end

function var0_0.ShowChapterRewardPanel(arg0_54)
	if arg0_54.rewardPanel == nil then
		arg0_54.rewardPanel = ChapterRewardPanel.New(arg0_54._tf.parent, arg0_54.event, arg0_54.contextData)

		arg0_54.rewardPanel:Load()
	end

	arg0_54.rewardPanel:ActionInvoke("Enter", arg0_54.chapter)
end

function var0_0.ClearChapterRewardPanel(arg0_55)
	if arg0_55.rewardPanel ~= nil then
		arg0_55.rewardPanel:Destroy()

		arg0_55.rewardPanel = nil
	end
end

function var0_0.ShowChapterAutoPanel(arg0_56)
	if arg0_56.autoPanel == nil then
		arg0_56.autoPanel = ChapterAutoPanel.New(arg0_56._tf, arg0_56.event, arg0_56.contextData)

		arg0_56.autoPanel:Load()
	end

	arg0_56.autoPanel:ActionInvoke("Enter", arg0_56.chapter)
end

function var0_0.RefreshChapterAutoPanel(arg0_57)
	if arg0_57.autoPanel and arg0_57.autoPanel:isShowing() then
		arg0_57.autoPanel:ActionInvoke("RefreshView")
	end
end

function var0_0.ClearChapterAutoPanel(arg0_58)
	if arg0_58.autoPanel ~= nil then
		arg0_58.autoPanel:Destroy()

		arg0_58.autoPanel = nil
	end
end

function var0_0.clear(arg0_59)
	arg0_59:cancelTween()
	arg0_59.dropList:each(function(arg0_60, arg1_60)
		clearDrop(arg1_60)
	end)
	arg0_59:clearTestShowDrop()
	arg0_59:ClearChapterRewardPanel()
	arg0_59:ClearChapterAutoPanel()
end

return var0_0
