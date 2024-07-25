local var0_0 = class("LevelInfoView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelStageInfoView"
end

function var0_0.OnInit(arg0_2)
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
end

function var0_0.Show(arg0_4)
	setActive(arg0_4._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.Hide(arg0_5)
	arg0_5:clear()
	setActive(arg0_5._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_5._tf, arg0_5._parentTf)
end

function var0_0.setCBFunc(arg0_6, arg1_6, arg2_6)
	arg0_6.onConfirm = arg1_6
	arg0_6.onCancel = arg2_6
end

function var0_0.InitUI(arg0_7)
	arg0_7.titleBG = arg0_7:findTF("panel/title")
	arg0_7.titleBGDecoration = arg0_7:findTF("panel/title/Image")
	arg0_7.titleIcon = arg0_7:findTF("panel/title/icon")
	arg0_7.txTitle = arg0_7:findTF("panel/title_form")
	arg0_7.txTitleOriginPosY = arg0_7.txTitle.anchoredPosition.y
	arg0_7.txTitleHead = arg0_7:findTF("panel/title_head")

	setActive(arg0_7.txTitleHead, false)

	arg0_7.txIntro = arg0_7:findTF("panel/intro")
	arg0_7.txCost = arg0_7:findTF("panel/cost/text")
	arg0_7.progressBar = arg0_7:findTF("panel/progress")
	arg0_7.txProgress = arg0_7:findTF("panel/progress/Text/value")
	arg0_7.progress = arg0_7:findTF("panel/progress")
	arg0_7.head = arg0_7:findTF("panel/head/Image")
	arg0_7.trAchieveTpl = arg0_7:findTF("panel/achieve")
	arg0_7.trAchieves = arg0_7:findTF("panel/achieves")
	arg0_7.passStateMask = arg0_7:findTF("panel/passState")
	arg0_7.passState = arg0_7:findTF("panel/passState/Image")

	setActive(arg0_7.passState, true)

	arg0_7.winCondDesc = arg0_7:findTF("panel/win_conditions/desc")
	arg0_7.winCondAwardBtn = arg0_7:findTF("panel/win_conditions/icon")
	arg0_7.loseCondDesc = arg0_7:findTF("panel/lose_conditions/desc")
	arg0_7.achieveList = UIItemList.New(arg0_7.trAchieves, arg0_7.trAchieveTpl)

	setActive(arg0_7.trAchieveTpl, false)

	arg0_7.trDropTpl = arg0_7:findTF("panel/drops/frame/list/item")
	arg0_7.trDrops = arg0_7:findTF("panel/drops/frame/list")
	arg0_7.dropList = UIItemList.New(arg0_7.trDrops, arg0_7.trDropTpl)

	arg0_7.dropList:make(function(arg0_8, arg1_8, arg2_8)
		arg0_7:updateDrop(arg0_8, arg1_8, arg2_8)
	end)
	setActive(arg0_7.trDropTpl, false)

	arg0_7.btnConfirm = arg0_7:findTF("panel/start_button")
	arg0_7.btnCancel = arg0_7:findTF("panel/btnBack")
	arg0_7.quickPlayGroup = arg0_7:findTF("panel/quickPlay")
	arg0_7.descQuickPlay = arg0_7:findTF("desc", arg0_7.quickPlayGroup)
	arg0_7.toggleQuickPlay = arg0_7.quickPlayGroup:GetComponent(typeof(Toggle))
	arg0_7.bottomExtra = arg0_7:findTF("panel/BottomExtra")
	arg0_7.layoutView = GetComponent(arg0_7.bottomExtra:Find("LoopGroup/view"), typeof(LayoutElement))
	arg0_7.rtViewContainer = arg0_7.bottomExtra:Find("LoopGroup/view/container")

	setText(arg0_7.bottomExtra:Find("LoopGroup/Loop/Text"), i18n("autofight_farm"))

	arg0_7.loopToggle = arg0_7.bottomExtra:Find("LoopGroup/Loop/Toggle")
	arg0_7.loopOn = arg0_7.loopToggle:Find("on")
	arg0_7.loopOff = arg0_7.loopToggle:Find("off")
	arg0_7.loopHelp = arg0_7.bottomExtra:Find("ButtonHelp")
	arg0_7.costLimitTip = arg0_7.bottomExtra:Find("LoopGroup/view/container/CostLimit")

	setActive(arg0_7.costLimitTip, false)

	arg0_7.autoFightToggle = arg0_7.bottomExtra:Find("LoopGroup/view/container/AutoFight")

	setText(arg0_7.autoFightToggle:Find("Text"), i18n("autofight"))

	arg0_7.delayTween = {}
end

local var1_0 = 525
local var2_0 = 373

function var0_0.set(arg0_9, arg1_9, arg2_9)
	arg0_9:cancelTween()

	local var0_9 = getProxy(ChapterProxy):getChapterById(arg1_9, true)

	arg0_9.chapter = var0_9
	arg0_9.posStart = arg2_9 or Vector3(0, 0, 0)

	local var1_9 = getProxy(ChapterProxy):getMapById(var0_9:getConfig("map"))
	local var2_9 = var0_9:getConfigTable()
	local var3_9 = string.split(var2_9.name, "|")
	local var4_9 = var0_9:getPlayType() == ChapterConst.TypeDefence

	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var4_9 and "title_print_defense" or "title_print", function(arg0_10)
		if not IsNil(arg0_9.titleBGDecoration) then
			arg0_9.titleBGDecoration:GetComponent(typeof(Image)).sprite = arg0_10
		end
	end)
	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var4_9 and "titlebar_bg_defense" or "titlebar_bg", function(arg0_11)
		if not IsNil(arg0_9.titleBG) then
			arg0_9.titleBG:GetComponent(typeof(Image)).sprite = arg0_11
		end
	end)
	setActive(arg0_9.titleIcon, var4_9)

	local var5_9 = arg0_9.progressBar.sizeDelta

	var5_9.x = var4_9 and var2_0 or var1_0
	arg0_9.progressBar.sizeDelta = var5_9

	setText(arg0_9:findTF("title_index", arg0_9.txTitle), var2_9.chapter_name .. "  ")
	setText(arg0_9:findTF("title", arg0_9.txTitle), var3_9[1])
	setText(arg0_9:findTF("title_en", arg0_9.txTitle), var3_9[2] or "")
	setActive(arg0_9.txTitleHead, var3_9[3] and #var3_9[3] > 0)

	local var6_9 = var3_9[3] and #var3_9[3] > 0 and arg0_9.txTitleOriginPosY or arg0_9.txTitleOriginPosY + 8

	setAnchoredPosition(arg0_9.txTitle, {
		y = var6_9
	})
	setText(arg0_9.txTitleHead, var3_9[3] or "")
	setText(arg0_9.winCondDesc, i18n("text_win_condition") .. "：" .. i18n(var0_9:getConfig("win_condition_display")))
	setText(arg0_9.loseCondDesc, i18n("text_lose_condition") .. "：" .. i18n(var0_9:getConfig("lose_condition_display")))
	setActive(arg0_9.winCondAwardBtn, var0_9:getPlayType() == ChapterConst.TypeDefence)

	if not var0_9:existAchieve() then
		setActive(arg0_9.passState, false)
		setActive(arg0_9.progress, false)
		setActive(arg0_9.trAchieves, false)
	else
		setActive(arg0_9.passState, true)
		setActive(arg0_9.progress, true)
		setActive(arg0_9.trAchieves, true)

		arg0_9.passState.localPosition = Vector3(-arg0_9.passState.rect.width, 0, 0)

		local var7_9 = var0_9:hasMitigation()

		setActive(arg0_9.passState, var7_9)

		if var7_9 then
			local var8_9 = var0_9:getRiskLevel()

			setImageSprite(arg0_9.passState, GetSpriteFromAtlas("passstate", var8_9), true)
		end

		setWidgetText(arg0_9.progress, i18n("levelScene_threat_to_rule_out", ": "))
		table.insert(arg0_9.delayTween, LeanTween.value(go(arg0_9.progress), 0, var0_9.progress, 0.5):setDelay(0.15):setOnUpdate(System.Action_float(function(arg0_12)
			setSlider(arg0_9.progress, 0, 100, arg0_12)
			setText(arg0_9.txProgress, math.floor(arg0_12) .. "%")
		end)).uniqueId)
		arg0_9.achieveList:align(#var0_9.achieves)
		arg0_9.achieveList:each(function(arg0_13, arg1_13)
			local var0_13 = var0_9.achieves[arg0_13 + 1]
			local var1_13 = findTF(arg1_13, "desc")

			setText(var1_13, ChapterConst.GetAchieveDesc(var0_13.type, var0_9))
			setTextColor(var1_13, Color.white)
			setActive(findTF(arg1_13, "star"), false)
			setActive(findTF(arg1_13, "star_empty"), true)

			local var2_13 = ChapterConst.IsAchieved(var0_13)

			table.insert(arg0_9.delayTween, LeanTween.delayedCall(0.15 + (arg0_13 + 1) * 0.15, System.Action(function()
				if not IsNil(arg1_13) then
					local var0_14 = findTF(arg1_13, "desc")

					setTextColor(var0_14, var2_13 and Color.yellow or Color.white)
					setActive(findTF(arg1_13, "star"), var2_13)
					setActive(findTF(arg1_13, "star_empty"), not var2_13)
				end
			end)).uniqueId)
		end)
	end

	setText(arg0_9.txIntro, var2_9.profiles)
	setText(arg0_9.txCost, var2_9.oil)

	if var2_9.icon and var2_9.icon[1] then
		setActive(arg0_9.head.parent, true)
		setImageSprite(arg0_9.head, LoadSprite("qicon/" .. var2_9.icon[1]))
	else
		setActive(arg0_9.head.parent, false)
	end

	arg0_9.awards = arg0_9:getChapterAwards()

	arg0_9.dropList:align(#arg0_9.awards)

	local var9_9 = var0_9:existLoop()

	setActive(arg0_9.bottomExtra, var9_9)

	if var9_9 then
		local var10_9 = var0_9:canActivateLoop()
		local var11_9 = "chapter_loop_flag_" .. var0_9.id
		local var12_9 = PlayerPrefs.GetInt(var11_9, -1)
		local var13_9 = (var12_9 == 1 or var12_9 == -1) and var10_9
		local var14_9 = #var0_9:getConfig("use_oil_limit") > 0

		setActive(arg0_9.loopOn, var13_9)
		setActive(arg0_9.loopOff, not var13_9)
		setActive(arg0_9.costLimitTip, var14_9)
		onNextTick(function()
			Canvas.ForceUpdateCanvases()

			arg0_9.layoutView.preferredWidth = var13_9 and arg0_9.rtViewContainer.rect.width or 0
		end)
		onButton(arg0_9, arg0_9.loopToggle, function()
			if not var10_9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_activate_loop_mode_failed"))

				return
			end

			local var0_16 = not arg0_9.loopOn.gameObject.activeSelf

			PlayerPrefs.SetInt(var11_9, var0_16 and 1 or 0)
			PlayerPrefs.Save()
			setActive(arg0_9.loopOn, var0_16)
			setActive(arg0_9.loopOff, not var0_16)

			local var1_16 = 0
			local var2_16 = 0

			if var0_16 then
				var2_16 = arg0_9.rtViewContainer.rect.width
			else
				var1_16 = arg0_9.rtViewContainer.rect.width
			end

			if arg0_9.LTid then
				LeanTween.cancel(arg0_9.LTid)

				arg0_9.LTid = nil
			end

			arg0_9.LTid = LeanTween.value(var1_16, var2_16, 0.3):setOnUpdate(System.Action_float(function(arg0_17)
				arg0_9.layoutView.preferredWidth = arg0_17
			end)):setOnComplete(System.Action(function()
				arg0_9.LTid = nil
			end)).uniqueId
		end, SFX_PANEL)
		onButton(arg0_9, arg0_9.loopHelp, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("levelScene_loop_help_tip")
			})
		end)

		local var15_9 = AutoBotCommand.autoBotSatisfied()
		local var16_9 = "chapter_autofight_flag_" .. var0_9.id
		local var17_9 = var15_9 and PlayerPrefs.GetInt(var16_9, 1) == 1

		onToggle(arg0_9, arg0_9.autoFightToggle, function(arg0_20)
			if arg0_20 ~= var17_9 then
				var17_9 = arg0_20

				PlayerPrefs.SetInt(var16_9, var17_9 and 1 or 0)
				PlayerPrefs.Save()
			end
		end, SFX_UI_TAG)
		triggerToggle(arg0_9.autoFightToggle, var17_9)
		setActive(arg0_9.autoFightToggle, var15_9)
	end

	onButton(arg0_9, arg0_9.btnConfirm, function()
		if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

			return
		end

		if not arg0_9.onConfirm then
			return
		end

		local var0_21 = var9_9 and arg0_9.loopOn.gameObject.activeSelf and 1 or 0

		arg0_9.onConfirm(arg1_9, var0_21)
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_9, arg0_9.btnCancel, function()
		if arg0_9.onCancel then
			arg0_9.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9._tf:Find("bg"), function()
		if arg0_9.onCancel then
			arg0_9.onCancel()
		end
	end, SFX_CANCEL)

	if not var0_9:getConfig("risk_levels") then
		local var18_9 = {}
	end

	onButton(arg0_9, arg0_9.passState, function()
		if not var0_9:hasMitigation() then
			return
		end

		local var0_24 = i18n("level_risk_level_desc", var0_9:getChapterState()) .. i18n("level_risk_level_mitigation_rate", var0_9:getRemainPassCount(), var0_9:getMitigationRate())

		if var1_9:getMapType() == Map.ELITE then
			var0_24 = var0_24 .. "\n" .. i18n("level_diffcult_chapter_state_safety")
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = var0_24
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.head, function()
		triggerButton(arg0_9.passState)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.winCondAwardBtn, function()
		arg0_9:ShowChapterRewardPanel()
	end)
	setText(arg0_9.descQuickPlay, i18n("desc_quick_play"))

	local var19_9 = var0_9:CanQuickPlay()

	setActive(arg0_9.quickPlayGroup, var19_9)

	if var19_9 then
		local var20_9 = "chapter_quickPlay_flag_" .. var0_9.id
		local var21_9 = PlayerPrefs.GetInt(var20_9, 1)

		onToggle(arg0_9, arg0_9.toggleQuickPlay, function(arg0_27)
			PlayerPrefs.SetInt(var20_9, arg0_27 and 1 or 0)
			PlayerPrefs.Save()
		end, SFX_PANEL)
		triggerToggle(arg0_9.toggleQuickPlay, var21_9 == 1)
	end

	local var22_9 = arg0_9:findTF("panel")

	var22_9.transform.localPosition = arg0_9.posStart

	table.insert(arg0_9.delayTween, LeanTween.move(var22_9, Vector3.zero, 0.2).uniqueId)

	var22_9.localScale = Vector3.zero

	table.insert(arg0_9.delayTween, LeanTween.scale(var22_9, Vector3(1, 1, 1), 0.2).uniqueId)
	table.insert(arg0_9.delayTween, LeanTween.moveX(arg0_9.passState, 0, 0.35):setEase(LeanTweenType.easeInOutSine):setDelay(0.3).uniqueId)
end

function var0_0.cancelTween(arg0_28)
	_.each(arg0_28.delayTween, function(arg0_29)
		LeanTween.cancel(arg0_29)
	end)

	arg0_28.delayTween = {}
end

function var0_0.updateDrop(arg0_30, arg1_30, arg2_30, arg3_30)
	if arg1_30 == UIItemList.EventUpdate then
		local var0_30 = arg0_30.awards[arg2_30 + 1]
		local var1_30 = Drop.Create(var0_30)

		updateDrop(arg3_30, var1_30)
		onButton(arg0_30, arg3_30, function()
			if ({
				[99] = true
			})[var1_30:getConfig("type")] then
				local function var0_31(arg0_32)
					local var0_32 = var1_30:getConfig("display_icon")
					local var1_32 = {}

					for iter0_32, iter1_32 in ipairs(var0_32) do
						local var2_32 = iter1_32[1]
						local var3_32 = iter1_32[2]
						local var4_32 = var2_32 == DROP_TYPE_SHIP and not table.contains(arg0_32, var3_32)

						var1_32[#var1_32 + 1] = {
							type = var2_32,
							id = var3_32,
							anonymous = var4_32
						}
					end

					arg0_30:emit(BaseUI.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1_32,
						content = var1_30:getConfig("display")
					})
					arg0_30:initTestShowDrop(var1_30, Clone(var1_32))
				end

				arg0_30:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0_30.chapter.id, var0_31)
			else
				arg0_30:emit(BaseUI.ON_DROP, var1_30)
			end
		end, SFX_PANEL)
	end
end

function var0_0.getChapterAwards(arg0_33)
	local var0_33 = arg0_33.chapter
	local var1_33 = Clone(var0_33:getConfig("awards"))
	local var2_33 = var0_33:getStageExtraAwards()

	if var2_33 then
		for iter0_33 = #var2_33, 1, -1 do
			table.insert(var1_33, 1, var2_33[iter0_33])
		end
	end

	local var3_33 = {
		var0_33:getConfig("boss_expedition_id"),
		var0_33:getConfig("ai_expedition_list")
	}

	if var0_33:getPlayType() == ChapterConst.TypeMultiStageBoss then
		table.insert(var3_33, pg.chapter_model_multistageboss[var0_33.id].boss_expedition_id)
	end

	local var4_33 = _.flatten(var3_33)
	local var5_33 = {}
	local var6_33 = {}

	local function var7_33(arg0_34)
		for iter0_34, iter1_34 in ipairs(var5_33) do
			if iter1_34 == arg0_34 then
				return false
			end
		end

		return true
	end

	local var8_33 = {}

	for iter1_33, iter2_33 in ipairs(var4_33) do
		local var9_33 = checkExist(pg.expedition_activity_template[iter2_33], {
			"pt_drop_display"
		})

		if var9_33 and type(var9_33) == "table" then
			for iter3_33, iter4_33 in ipairs(var9_33) do
				local var10_33 = iter4_33[1]
				local var11_33 = iter4_33[2]
				local var12_33 = iter4_33[3]

				if var7_33(var11_33) then
					table.insert(var5_33, var11_33)

					var6_33[var11_33] = {}
				end

				var6_33[var11_33][var10_33] = true
				var8_33[var11_33] = var8_33[var11_33] or {}
				var8_33[var11_33][var10_33] = var12_33
			end
		end
	end

	local var13_33 = getProxy(ActivityProxy)

	for iter5_33 = #var5_33, 1, -1 do
		for iter6_33, iter7_33 in pairs(var6_33[var5_33[iter5_33]]) do
			local var14_33 = var13_33:getActivityById(iter6_33)

			if var14_33 and not var14_33:isEnd() then
				table.insert(var1_33, 1, {
					DROP_TYPE_ITEM,
					id2ItemId(var5_33[iter5_33]),
					var8_33[var5_33[iter5_33]][iter6_33]
				})

				break
			end
		end
	end

	return var1_33
end

function var0_0.initTestShowDrop(arg0_35, arg1_35, arg2_35)
	if IsUnityEditor then
		local var0_35 = pg.MsgboxMgr.GetInstance()._go
		local var1_35 = var0_35.transform:Find("button_test_show_drop")

		if IsNil(var1_35) then
			var1_35 = GameObject.New("button_test_show_drop")

			var1_35:AddComponent(typeof(Button))
			var1_35:AddComponent(typeof(RectTransform))
			var1_35:AddComponent(typeof(Image))
		end

		local var2_35 = var1_35:GetComponent(typeof(RectTransform))

		var2_35:SetParent(var0_35.transform, false)

		var2_35.anchoredPosition = Vector3(-239, 173, 0)
		var2_35.sizeDelta = Vector2(40, 40)

		onButton(arg0_35, var2_35, function()
			_.each(arg2_35, function(arg0_37)
				arg0_37.anonymous = false
			end)
			arg0_35:emit(BaseUI.ON_DROP_LIST, {
				item2Row = true,
				itemList = arg2_35,
				content = arg1_35:getConfig("display")
			})
		end)
	end
end

function var0_0.clearTestShowDrop(arg0_38)
	if IsUnityEditor then
		local var0_38 = pg.MsgboxMgr.GetInstance()._go.transform:Find("button_test_show_drop")

		if not IsNil(var0_38) then
			Destroy(var0_38)
		end
	end
end

function var0_0.ShowChapterRewardPanel(arg0_39)
	if arg0_39.rewardPanel == nil then
		arg0_39.rewardPanel = ChapterRewardPanel.New(arg0_39._tf.parent, arg0_39.event, arg0_39.contextData)

		arg0_39.rewardPanel:Load()
	end

	arg0_39.rewardPanel:ActionInvoke("Enter", arg0_39.chapter)
end

function var0_0.ClearChapterRewardPanel(arg0_40)
	if arg0_40.rewardPanel ~= nil then
		arg0_40.rewardPanel:Destroy()

		arg0_40.rewardPanel = nil
	end
end

function var0_0.clear(arg0_41)
	arg0_41:cancelTween()
	arg0_41.dropList:each(function(arg0_42, arg1_42)
		clearDrop(arg1_42)
	end)
	arg0_41:clearTestShowDrop()
	arg0_41:ClearChapterRewardPanel()
end

return var0_0
