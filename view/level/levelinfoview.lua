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

	arg0_7.achieveList:make(function(arg0_8, arg1_8, arg2_8)
		arg0_7:updateAchieve(arg0_8, arg1_8, arg2_8)
	end)
	setActive(arg0_7.trAchieveTpl, false)

	arg0_7.trDropTpl = arg0_7:findTF("panel/drops/frame/list/item")
	arg0_7.trDrops = arg0_7:findTF("panel/drops/frame/list")
	arg0_7.dropList = UIItemList.New(arg0_7.trDrops, arg0_7.trDropTpl)

	arg0_7.dropList:make(function(arg0_9, arg1_9, arg2_9)
		arg0_7:updateDrop(arg0_9, arg1_9, arg2_9)
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

function var0_0.set(arg0_10, arg1_10, arg2_10)
	arg0_10:cancelTween()

	arg0_10.chapter = arg1_10
	arg0_10.posStart = arg2_10 or Vector3(0, 0, 0)

	local var0_10 = getProxy(ChapterProxy):getMapById(arg1_10:getConfig("map"))
	local var1_10 = arg0_10.chapter:getConfigTable()
	local var2_10 = string.split(var1_10.name, "|")
	local var3_10 = arg1_10:getPlayType() == ChapterConst.TypeDefence

	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3_10 and "title_print_defense" or "title_print", function(arg0_11)
		if not IsNil(arg0_10.titleBGDecoration) then
			arg0_10.titleBGDecoration:GetComponent(typeof(Image)).sprite = arg0_11
		end
	end)
	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3_10 and "titlebar_bg_defense" or "titlebar_bg", function(arg0_12)
		if not IsNil(arg0_10.titleBG) then
			arg0_10.titleBG:GetComponent(typeof(Image)).sprite = arg0_12
		end
	end)
	setActive(arg0_10.titleIcon, var3_10)

	local var4_10 = arg0_10.progressBar.sizeDelta

	var4_10.x = var3_10 and var2_0 or var1_0
	arg0_10.progressBar.sizeDelta = var4_10

	setText(arg0_10:findTF("title_index", arg0_10.txTitle), var1_10.chapter_name .. "  ")
	setText(arg0_10:findTF("title", arg0_10.txTitle), var2_10[1])
	setText(arg0_10:findTF("title_en", arg0_10.txTitle), var2_10[2] or "")
	setActive(arg0_10.txTitleHead, var2_10[3] and #var2_10[3] > 0)

	local var5_10 = var2_10[3] and #var2_10[3] > 0 and arg0_10.txTitleOriginPosY or arg0_10.txTitleOriginPosY + 8

	setAnchoredPosition(arg0_10.txTitle, {
		y = var5_10
	})
	setText(arg0_10.txTitleHead, var2_10[3] or "")
	setText(arg0_10.winCondDesc, i18n("text_win_condition") .. "：" .. i18n(arg1_10:getConfig("win_condition_display")))
	setText(arg0_10.loseCondDesc, i18n("text_lose_condition") .. "：" .. i18n(arg1_10:getConfig("lose_condition_display")))
	setActive(arg0_10.winCondAwardBtn, arg1_10:getPlayType() == ChapterConst.TypeDefence)

	if not arg1_10:existAchieve() then
		setActive(arg0_10.passState, false)
		setActive(arg0_10.progress, false)
		setActive(arg0_10.trAchieves, false)
	else
		setActive(arg0_10.passState, true)
		setActive(arg0_10.progress, true)
		setActive(arg0_10.trAchieves, true)

		arg0_10.passState.localPosition = Vector3(-arg0_10.passState.rect.width, 0, 0)

		local var6_10 = arg1_10:hasMitigation()

		setActive(arg0_10.passState, var6_10)

		if var6_10 then
			local var7_10 = arg1_10:getRiskLevel()

			setImageSprite(arg0_10.passState, GetSpriteFromAtlas("passstate", var7_10), true)
		end

		setWidgetText(arg0_10.progress, i18n("levelScene_threat_to_rule_out", ": "))
		table.insert(arg0_10.delayTween, LeanTween.value(go(arg0_10.progress), 0, arg0_10.chapter.progress, 0.5):setDelay(0.15):setOnUpdate(System.Action_float(function(arg0_13)
			setSlider(arg0_10.progress, 0, 100, arg0_13)
			setText(arg0_10.txProgress, math.floor(arg0_13) .. "%")
		end)).uniqueId)
		arg0_10.achieveList:align(#arg0_10.chapter.achieves)
		arg0_10.achieveList:each(function(arg0_14, arg1_14)
			local var0_14 = arg0_10.chapter.achieves[arg0_14 + 1]
			local var1_14 = ChapterConst.IsAchieved(var0_14)

			table.insert(arg0_10.delayTween, LeanTween.delayedCall(0.15 + (arg0_14 + 1) * 0.15, System.Action(function()
				if not IsNil(arg1_14) then
					local var0_15 = findTF(arg1_14, "desc")

					setTextColor(var0_15, var1_14 and Color.yellow or Color.white)
					setActive(findTF(arg1_14, "star"), var1_14)
					setActive(findTF(arg1_14, "star_empty"), not var1_14)
				end
			end)).uniqueId)
		end)
	end

	setText(arg0_10.txIntro, var1_10.profiles)
	setText(arg0_10.txCost, var1_10.oil)

	if var1_10.icon and var1_10.icon[1] then
		setActive(arg0_10.head.parent, true)
		setImageSprite(arg0_10.head, LoadSprite("qicon/" .. var1_10.icon[1]))
	else
		setActive(arg0_10.head.parent, false)
	end

	arg0_10.awards = arg0_10:getChapterAwards()

	arg0_10.dropList:align(#arg0_10.awards)

	local var8_10 = arg1_10:existLoop()

	setActive(arg0_10.bottomExtra, var8_10)

	if var8_10 then
		local var9_10 = arg1_10:canActivateLoop()
		local var10_10 = "chapter_loop_flag_" .. arg1_10.id
		local var11_10 = PlayerPrefs.GetInt(var10_10, -1)
		local var12_10 = (var11_10 == 1 or var11_10 == -1) and var9_10
		local var13_10 = #arg1_10:getConfig("use_oil_limit") > 0

		setActive(arg0_10.loopOn, var12_10)
		setActive(arg0_10.loopOff, not var12_10)
		setActive(arg0_10.costLimitTip, var13_10)
		onNextTick(function()
			Canvas.ForceUpdateCanvases()

			arg0_10.layoutView.preferredWidth = var12_10 and arg0_10.rtViewContainer.rect.width or 0
		end)
		onButton(arg0_10, arg0_10.loopToggle, function()
			if not var9_10 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_activate_loop_mode_failed"))

				return
			end

			local var0_17 = not arg0_10.loopOn.gameObject.activeSelf

			PlayerPrefs.SetInt(var10_10, var0_17 and 1 or 0)
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

		local var14_10 = AutoBotCommand.autoBotSatisfied()
		local var15_10 = "chapter_autofight_flag_" .. arg1_10.id
		local var16_10 = var14_10 and PlayerPrefs.GetInt(var15_10, 1) == 1

		onToggle(arg0_10, arg0_10.autoFightToggle, function(arg0_21)
			if arg0_21 ~= var16_10 then
				var16_10 = arg0_21

				PlayerPrefs.SetInt(var15_10, var16_10 and 1 or 0)
				PlayerPrefs.Save()
			end
		end, SFX_UI_TAG)
		triggerToggle(arg0_10.autoFightToggle, var16_10)
		setActive(arg0_10.autoFightToggle, var14_10)
	end

	onButton(arg0_10, arg0_10.btnConfirm, function()
		if arg0_10.onConfirm then
			local var0_22 = var8_10 and arg0_10.loopOn.gameObject.activeSelf and 1 or 0

			arg0_10.onConfirm(var0_22)
		end
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

	if not arg1_10:getConfig("risk_levels") then
		local var17_10 = {}
	end

	onButton(arg0_10, arg0_10.passState, function()
		if not arg1_10:hasMitigation() then
			return
		end

		local var0_25 = i18n("level_risk_level_desc", arg1_10:getChapterState()) .. i18n("level_risk_level_mitigation_rate", arg1_10:getRemainPassCount(), arg1_10:getMitigationRate())

		if var0_10:getMapType() == Map.ELITE then
			var0_25 = var0_25 .. "\n" .. i18n("level_diffcult_chapter_state_safety")
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = var0_25
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.head, function()
		triggerButton(arg0_10.passState)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.winCondAwardBtn, function()
		arg0_10:ShowChapterRewardPanel()
	end)
	setText(arg0_10.descQuickPlay, i18n("desc_quick_play"))

	local var18_10 = arg1_10:CanQuickPlay()

	setActive(arg0_10.quickPlayGroup, var18_10)

	if var18_10 then
		local var19_10 = "chapter_quickPlay_flag_" .. arg1_10.id
		local var20_10 = PlayerPrefs.GetInt(var19_10, 1)

		onToggle(arg0_10, arg0_10.toggleQuickPlay, function(arg0_28)
			PlayerPrefs.SetInt(var19_10, arg0_28 and 1 or 0)
			PlayerPrefs.Save()
		end, SFX_PANEL)
		triggerToggle(arg0_10.toggleQuickPlay, var20_10 == 1)
	end

	local var21_10 = arg0_10:findTF("panel")

	var21_10.transform.localPosition = arg0_10.posStart

	table.insert(arg0_10.delayTween, LeanTween.move(var21_10, Vector3.zero, 0.2).uniqueId)

	var21_10.localScale = Vector3.zero

	table.insert(arg0_10.delayTween, LeanTween.scale(var21_10, Vector3(1, 1, 1), 0.2).uniqueId)
	table.insert(arg0_10.delayTween, LeanTween.moveX(arg0_10.passState, 0, 0.35):setEase(LeanTweenType.easeInOutSine):setDelay(0.3).uniqueId)
end

function var0_0.cancelTween(arg0_29)
	_.each(arg0_29.delayTween, function(arg0_30)
		LeanTween.cancel(arg0_30)
	end)

	arg0_29.delayTween = {}
end

function var0_0.updateAchieve(arg0_31, arg1_31, arg2_31, arg3_31)
	if arg1_31 == UIItemList.EventUpdate then
		local var0_31 = arg0_31.chapter.achieves[arg2_31 + 1]
		local var1_31 = findTF(arg3_31, "desc")

		setText(var1_31, ChapterConst.GetAchieveDesc(var0_31.type, arg0_31.chapter))
		setTextColor(var1_31, Color.white)
		setActive(findTF(arg3_31, "star"), false)
		setActive(findTF(arg3_31, "star_empty"), true)
	end
end

function var0_0.updateDrop(arg0_32, arg1_32, arg2_32, arg3_32)
	if arg1_32 == UIItemList.EventUpdate then
		local var0_32 = arg0_32.awards[arg2_32 + 1]
		local var1_32 = Drop.Create(var0_32)

		updateDrop(arg3_32, var1_32)
		onButton(arg0_32, arg3_32, function()
			if ({
				[99] = true
			})[var1_32:getConfig("type")] then
				local function var0_33(arg0_34)
					local var0_34 = var1_32:getConfig("display_icon")
					local var1_34 = {}

					for iter0_34, iter1_34 in ipairs(var0_34) do
						local var2_34 = iter1_34[1]
						local var3_34 = iter1_34[2]
						local var4_34 = var2_34 == DROP_TYPE_SHIP and not table.contains(arg0_34, var3_34)

						var1_34[#var1_34 + 1] = {
							type = var2_34,
							id = var3_34,
							anonymous = var4_34
						}
					end

					arg0_32:emit(BaseUI.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1_34,
						content = var1_32:getConfig("display")
					})
					arg0_32:initTestShowDrop(var1_32, Clone(var1_34))
				end

				arg0_32:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0_32.chapter.id, var0_33)
			else
				arg0_32:emit(BaseUI.ON_DROP, var1_32)
			end
		end, SFX_PANEL)
	end
end

function var0_0.getChapterAwards(arg0_35)
	local var0_35 = arg0_35.chapter
	local var1_35 = Clone(var0_35:getConfig("awards"))
	local var2_35 = var0_35:getStageExtraAwards()

	if var2_35 then
		for iter0_35 = #var2_35, 1, -1 do
			table.insert(var1_35, 1, var2_35[iter0_35])
		end
	end

	local var3_35 = {
		var0_35:getConfig("boss_expedition_id"),
		var0_35:getConfig("ai_expedition_list")
	}

	if var0_35:getPlayType() == ChapterConst.TypeMultiStageBoss then
		table.insert(var3_35, pg.chapter_model_multistageboss[var0_35.id].boss_expedition_id)
	end

	local var4_35 = _.flatten(var3_35)
	local var5_35 = {}
	local var6_35 = {}

	local function var7_35(arg0_36)
		for iter0_36, iter1_36 in ipairs(var5_35) do
			if iter1_36 == arg0_36 then
				return false
			end
		end

		return true
	end

	for iter1_35, iter2_35 in ipairs(var4_35) do
		local var8_35 = checkExist(pg.expedition_activity_template[iter2_35], {
			"pt_drop_display"
		})

		if var8_35 and type(var8_35) == "table" then
			for iter3_35, iter4_35 in ipairs(var8_35) do
				if var7_35(iter4_35[2]) then
					table.insert(var5_35, iter4_35[2])

					var6_35[iter4_35[2]] = {}
				end

				var6_35[iter4_35[2]][iter4_35[1]] = true
			end
		end
	end

	local var9_35 = getProxy(ActivityProxy)

	for iter5_35 = #var5_35, 1, -1 do
		for iter6_35, iter7_35 in pairs(var6_35[var5_35[iter5_35]]) do
			local var10_35 = var9_35:getActivityById(iter6_35)

			if var10_35 and not var10_35:isEnd() then
				table.insert(var1_35, 1, {
					2,
					id2ItemId(var5_35[iter5_35])
				})

				break
			end
		end
	end

	return var1_35
end

function var0_0.initTestShowDrop(arg0_37, arg1_37, arg2_37)
	if IsUnityEditor then
		local var0_37 = pg.MsgboxMgr.GetInstance()._go
		local var1_37 = var0_37.transform:Find("button_test_show_drop")

		if IsNil(var1_37) then
			var1_37 = GameObject.New("button_test_show_drop")

			var1_37:AddComponent(typeof(Button))
			var1_37:AddComponent(typeof(RectTransform))
			var1_37:AddComponent(typeof(Image))
		end

		local var2_37 = var1_37:GetComponent(typeof(RectTransform))

		var2_37:SetParent(var0_37.transform, false)

		var2_37.anchoredPosition = Vector3(-239, 173, 0)
		var2_37.sizeDelta = Vector2(40, 40)

		onButton(arg0_37, var2_37, function()
			_.each(arg2_37, function(arg0_39)
				arg0_39.anonymous = false
			end)
			arg0_37:emit(BaseUI.ON_DROP_LIST, {
				item2Row = true,
				itemList = arg2_37,
				content = arg1_37:getConfig("display")
			})
		end)
	end
end

function var0_0.clearTestShowDrop(arg0_40)
	if IsUnityEditor then
		local var0_40 = pg.MsgboxMgr.GetInstance()._go.transform:Find("button_test_show_drop")

		if not IsNil(var0_40) then
			Destroy(var0_40)
		end
	end
end

function var0_0.ShowChapterRewardPanel(arg0_41)
	if arg0_41.rewardPanel == nil then
		arg0_41.rewardPanel = ChapterRewardPanel.New(arg0_41._tf.parent, arg0_41.event, arg0_41.contextData)

		arg0_41.rewardPanel:Load()
	end

	arg0_41.rewardPanel:ActionInvoke("Enter", arg0_41.chapter)
end

function var0_0.ClearChapterRewardPanel(arg0_42)
	if arg0_42.rewardPanel ~= nil then
		arg0_42.rewardPanel:Destroy()

		arg0_42.rewardPanel = nil
	end
end

function var0_0.clear(arg0_43)
	arg0_43:cancelTween()
	arg0_43.dropList:each(function(arg0_44, arg1_44)
		clearDrop(arg1_44)
	end)
	arg0_43:clearTestShowDrop()
	arg0_43:ClearChapterRewardPanel()
end

return var0_0
