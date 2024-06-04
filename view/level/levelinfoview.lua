local var0 = class("LevelInfoView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "LevelStageInfoView"
end

function var0.OnInit(arg0)
	arg0:InitUI()
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	arg0.onConfirm = nil
	arg0.onCancel = nil

	if arg0.LTid then
		LeanTween.cancel(arg0.LTid)

		arg0.LTid = nil
	end
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	arg0:clear()
	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.setCBFunc(arg0, arg1, arg2)
	arg0.onConfirm = arg1
	arg0.onCancel = arg2
end

function var0.InitUI(arg0)
	arg0.titleBG = arg0:findTF("panel/title")
	arg0.titleBGDecoration = arg0:findTF("panel/title/Image")
	arg0.titleIcon = arg0:findTF("panel/title/icon")
	arg0.txTitle = arg0:findTF("panel/title_form")
	arg0.txTitleOriginPosY = arg0.txTitle.anchoredPosition.y
	arg0.txTitleHead = arg0:findTF("panel/title_head")

	setActive(arg0.txTitleHead, false)

	arg0.txIntro = arg0:findTF("panel/intro")
	arg0.txCost = arg0:findTF("panel/cost/text")
	arg0.progressBar = arg0:findTF("panel/progress")
	arg0.txProgress = arg0:findTF("panel/progress/Text/value")
	arg0.progress = arg0:findTF("panel/progress")
	arg0.head = arg0:findTF("panel/head/Image")
	arg0.trAchieveTpl = arg0:findTF("panel/achieve")
	arg0.trAchieves = arg0:findTF("panel/achieves")
	arg0.passStateMask = arg0:findTF("panel/passState")
	arg0.passState = arg0:findTF("panel/passState/Image")

	setActive(arg0.passState, true)

	arg0.winCondDesc = arg0:findTF("panel/win_conditions/desc")
	arg0.winCondAwardBtn = arg0:findTF("panel/win_conditions/icon")
	arg0.loseCondDesc = arg0:findTF("panel/lose_conditions/desc")
	arg0.achieveList = UIItemList.New(arg0.trAchieves, arg0.trAchieveTpl)

	arg0.achieveList:make(function(arg0, arg1, arg2)
		arg0:updateAchieve(arg0, arg1, arg2)
	end)
	setActive(arg0.trAchieveTpl, false)

	arg0.trDropTpl = arg0:findTF("panel/drops/frame/list/item")
	arg0.trDrops = arg0:findTF("panel/drops/frame/list")
	arg0.dropList = UIItemList.New(arg0.trDrops, arg0.trDropTpl)

	arg0.dropList:make(function(arg0, arg1, arg2)
		arg0:updateDrop(arg0, arg1, arg2)
	end)
	setActive(arg0.trDropTpl, false)

	arg0.btnConfirm = arg0:findTF("panel/start_button")
	arg0.btnCancel = arg0:findTF("panel/btnBack")
	arg0.quickPlayGroup = arg0:findTF("panel/quickPlay")
	arg0.descQuickPlay = arg0:findTF("desc", arg0.quickPlayGroup)
	arg0.toggleQuickPlay = arg0.quickPlayGroup:GetComponent(typeof(Toggle))
	arg0.bottomExtra = arg0:findTF("panel/BottomExtra")
	arg0.layoutView = GetComponent(arg0.bottomExtra:Find("LoopGroup/view"), typeof(LayoutElement))
	arg0.rtViewContainer = arg0.bottomExtra:Find("LoopGroup/view/container")

	setText(arg0.bottomExtra:Find("LoopGroup/Loop/Text"), i18n("autofight_farm"))

	arg0.loopToggle = arg0.bottomExtra:Find("LoopGroup/Loop/Toggle")
	arg0.loopOn = arg0.loopToggle:Find("on")
	arg0.loopOff = arg0.loopToggle:Find("off")
	arg0.loopHelp = arg0.bottomExtra:Find("ButtonHelp")
	arg0.costLimitTip = arg0.bottomExtra:Find("LoopGroup/view/container/CostLimit")

	setActive(arg0.costLimitTip, false)

	arg0.autoFightToggle = arg0.bottomExtra:Find("LoopGroup/view/container/AutoFight")

	setText(arg0.autoFightToggle:Find("Text"), i18n("autofight"))

	arg0.delayTween = {}
end

local var1 = 525
local var2 = 373

function var0.set(arg0, arg1, arg2)
	arg0:cancelTween()

	arg0.chapter = arg1
	arg0.posStart = arg2 or Vector3(0, 0, 0)

	local var0 = getProxy(ChapterProxy):getMapById(arg1:getConfig("map"))
	local var1 = arg0.chapter:getConfigTable()
	local var2 = string.split(var1.name, "|")
	local var3 = arg1:getPlayType() == ChapterConst.TypeDefence

	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3 and "title_print_defense" or "title_print", function(arg0)
		if not IsNil(arg0.titleBGDecoration) then
			arg0.titleBGDecoration:GetComponent(typeof(Image)).sprite = arg0
		end
	end)
	GetSpriteFromAtlasAsync("ui/levelstageinfoview_atlas", var3 and "titlebar_bg_defense" or "titlebar_bg", function(arg0)
		if not IsNil(arg0.titleBG) then
			arg0.titleBG:GetComponent(typeof(Image)).sprite = arg0
		end
	end)
	setActive(arg0.titleIcon, var3)

	local var4 = arg0.progressBar.sizeDelta

	var4.x = var3 and var2 or var1
	arg0.progressBar.sizeDelta = var4

	setText(arg0:findTF("title_index", arg0.txTitle), var1.chapter_name .. "  ")
	setText(arg0:findTF("title", arg0.txTitle), var2[1])
	setText(arg0:findTF("title_en", arg0.txTitle), var2[2] or "")
	setActive(arg0.txTitleHead, var2[3] and #var2[3] > 0)

	local var5 = var2[3] and #var2[3] > 0 and arg0.txTitleOriginPosY or arg0.txTitleOriginPosY + 8

	setAnchoredPosition(arg0.txTitle, {
		y = var5
	})
	setText(arg0.txTitleHead, var2[3] or "")
	setText(arg0.winCondDesc, i18n("text_win_condition") .. "：" .. i18n(arg1:getConfig("win_condition_display")))
	setText(arg0.loseCondDesc, i18n("text_lose_condition") .. "：" .. i18n(arg1:getConfig("lose_condition_display")))
	setActive(arg0.winCondAwardBtn, arg1:getPlayType() == ChapterConst.TypeDefence)

	if not arg1:existAchieve() then
		setActive(arg0.passState, false)
		setActive(arg0.progress, false)
		setActive(arg0.trAchieves, false)
	else
		setActive(arg0.passState, true)
		setActive(arg0.progress, true)
		setActive(arg0.trAchieves, true)

		arg0.passState.localPosition = Vector3(-arg0.passState.rect.width, 0, 0)

		local var6 = arg1:hasMitigation()

		setActive(arg0.passState, var6)

		if var6 then
			local var7 = arg1:getRiskLevel()

			setImageSprite(arg0.passState, GetSpriteFromAtlas("passstate", var7), true)
		end

		setWidgetText(arg0.progress, i18n("levelScene_threat_to_rule_out", ": "))
		table.insert(arg0.delayTween, LeanTween.value(go(arg0.progress), 0, arg0.chapter.progress, 0.5):setDelay(0.15):setOnUpdate(System.Action_float(function(arg0)
			setSlider(arg0.progress, 0, 100, arg0)
			setText(arg0.txProgress, math.floor(arg0) .. "%")
		end)).uniqueId)
		arg0.achieveList:align(#arg0.chapter.achieves)
		arg0.achieveList:each(function(arg0, arg1)
			local var0 = arg0.chapter.achieves[arg0 + 1]
			local var1 = ChapterConst.IsAchieved(var0)

			table.insert(arg0.delayTween, LeanTween.delayedCall(0.15 + (arg0 + 1) * 0.15, System.Action(function()
				if not IsNil(arg1) then
					local var0 = findTF(arg1, "desc")

					setTextColor(var0, var1 and Color.yellow or Color.white)
					setActive(findTF(arg1, "star"), var1)
					setActive(findTF(arg1, "star_empty"), not var1)
				end
			end)).uniqueId)
		end)
	end

	setText(arg0.txIntro, var1.profiles)
	setText(arg0.txCost, var1.oil)

	if var1.icon and var1.icon[1] then
		setActive(arg0.head.parent, true)
		setImageSprite(arg0.head, LoadSprite("qicon/" .. var1.icon[1]))
	else
		setActive(arg0.head.parent, false)
	end

	arg0.awards = arg0:getChapterAwards()

	arg0.dropList:align(#arg0.awards)

	local var8 = arg1:existLoop()

	setActive(arg0.bottomExtra, var8)

	if var8 then
		local var9 = arg1:canActivateLoop()
		local var10 = "chapter_loop_flag_" .. arg1.id
		local var11 = PlayerPrefs.GetInt(var10, -1)
		local var12 = (var11 == 1 or var11 == -1) and var9
		local var13 = #arg1:getConfig("use_oil_limit") > 0

		setActive(arg0.loopOn, var12)
		setActive(arg0.loopOff, not var12)
		setActive(arg0.costLimitTip, var13)
		onNextTick(function()
			Canvas.ForceUpdateCanvases()

			arg0.layoutView.preferredWidth = var12 and arg0.rtViewContainer.rect.width or 0
		end)
		onButton(arg0, arg0.loopToggle, function()
			if not var9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_activate_loop_mode_failed"))

				return
			end

			local var0 = not arg0.loopOn.gameObject.activeSelf

			PlayerPrefs.SetInt(var10, var0 and 1 or 0)
			PlayerPrefs.Save()
			setActive(arg0.loopOn, var0)
			setActive(arg0.loopOff, not var0)

			local var1 = 0
			local var2 = 0

			if var0 then
				var2 = arg0.rtViewContainer.rect.width
			else
				var1 = arg0.rtViewContainer.rect.width
			end

			if arg0.LTid then
				LeanTween.cancel(arg0.LTid)

				arg0.LTid = nil
			end

			arg0.LTid = LeanTween.value(var1, var2, 0.3):setOnUpdate(System.Action_float(function(arg0)
				arg0.layoutView.preferredWidth = arg0
			end)):setOnComplete(System.Action(function()
				arg0.LTid = nil
			end)).uniqueId
		end, SFX_PANEL)
		onButton(arg0, arg0.loopHelp, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("levelScene_loop_help_tip")
			})
		end)

		local var14 = AutoBotCommand.autoBotSatisfied()
		local var15 = "chapter_autofight_flag_" .. arg1.id
		local var16 = var14 and PlayerPrefs.GetInt(var15, 1) == 1

		onToggle(arg0, arg0.autoFightToggle, function(arg0)
			if arg0 ~= var16 then
				var16 = arg0

				PlayerPrefs.SetInt(var15, var16 and 1 or 0)
				PlayerPrefs.Save()
			end
		end, SFX_UI_TAG)
		triggerToggle(arg0.autoFightToggle, var16)
		setActive(arg0.autoFightToggle, var14)
	end

	onButton(arg0, arg0.btnConfirm, function()
		if arg0.onConfirm then
			local var0 = var8 and arg0.loopOn.gameObject.activeSelf and 1 or 0

			arg0.onConfirm(var0)
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0, arg0.btnCancel, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)

	if not arg1:getConfig("risk_levels") then
		local var17 = {}
	end

	onButton(arg0, arg0.passState, function()
		if not arg1:hasMitigation() then
			return
		end

		local var0 = i18n("level_risk_level_desc", arg1:getChapterState()) .. i18n("level_risk_level_mitigation_rate", arg1:getRemainPassCount(), arg1:getMitigationRate())

		if var0:getMapType() == Map.ELITE then
			var0 = var0 .. "\n" .. i18n("level_diffcult_chapter_state_safety")
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.head, function()
		triggerButton(arg0.passState)
	end, SFX_PANEL)
	onButton(arg0, arg0.winCondAwardBtn, function()
		arg0:ShowChapterRewardPanel()
	end)
	setText(arg0.descQuickPlay, i18n("desc_quick_play"))

	local var18 = arg1:CanQuickPlay()

	setActive(arg0.quickPlayGroup, var18)

	if var18 then
		local var19 = "chapter_quickPlay_flag_" .. arg1.id
		local var20 = PlayerPrefs.GetInt(var19, 1)

		onToggle(arg0, arg0.toggleQuickPlay, function(arg0)
			PlayerPrefs.SetInt(var19, arg0 and 1 or 0)
			PlayerPrefs.Save()
		end, SFX_PANEL)
		triggerToggle(arg0.toggleQuickPlay, var20 == 1)
	end

	local var21 = arg0:findTF("panel")

	var21.transform.localPosition = arg0.posStart

	table.insert(arg0.delayTween, LeanTween.move(var21, Vector3.zero, 0.2).uniqueId)

	var21.localScale = Vector3.zero

	table.insert(arg0.delayTween, LeanTween.scale(var21, Vector3(1, 1, 1), 0.2).uniqueId)
	table.insert(arg0.delayTween, LeanTween.moveX(arg0.passState, 0, 0.35):setEase(LeanTweenType.easeInOutSine):setDelay(0.3).uniqueId)
end

function var0.cancelTween(arg0)
	_.each(arg0.delayTween, function(arg0)
		LeanTween.cancel(arg0)
	end)

	arg0.delayTween = {}
end

function var0.updateAchieve(arg0, arg1, arg2, arg3)
	if arg1 == UIItemList.EventUpdate then
		local var0 = arg0.chapter.achieves[arg2 + 1]
		local var1 = findTF(arg3, "desc")

		setText(var1, ChapterConst.GetAchieveDesc(var0.type, arg0.chapter))
		setTextColor(var1, Color.white)
		setActive(findTF(arg3, "star"), false)
		setActive(findTF(arg3, "star_empty"), true)
	end
end

function var0.updateDrop(arg0, arg1, arg2, arg3)
	if arg1 == UIItemList.EventUpdate then
		local var0 = arg0.awards[arg2 + 1]
		local var1 = Drop.Create(var0)

		updateDrop(arg3, var1)
		onButton(arg0, arg3, function()
			if ({
				[99] = true
			})[var1:getConfig("type")] then
				local function var0(arg0)
					local var0 = var1:getConfig("display_icon")
					local var1 = {}

					for iter0, iter1 in ipairs(var0) do
						local var2 = iter1[1]
						local var3 = iter1[2]
						local var4 = var2 == DROP_TYPE_SHIP and not table.contains(arg0, var3)

						var1[#var1 + 1] = {
							type = var2,
							id = var3,
							anonymous = var4
						}
					end

					arg0:emit(BaseUI.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1,
						content = var1:getConfig("display")
					})
					arg0:initTestShowDrop(var1, Clone(var1))
				end

				arg0:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0.chapter.id, var0)
			else
				arg0:emit(BaseUI.ON_DROP, var1)
			end
		end, SFX_PANEL)
	end
end

function var0.getChapterAwards(arg0)
	local var0 = arg0.chapter
	local var1 = Clone(var0:getConfig("awards"))
	local var2 = var0:getStageExtraAwards()

	if var2 then
		for iter0 = #var2, 1, -1 do
			table.insert(var1, 1, var2[iter0])
		end
	end

	local var3 = {
		var0:getConfig("boss_expedition_id"),
		var0:getConfig("ai_expedition_list")
	}

	if var0:getPlayType() == ChapterConst.TypeMultiStageBoss then
		table.insert(var3, pg.chapter_model_multistageboss[var0.id].boss_expedition_id)
	end

	local var4 = _.flatten(var3)
	local var5 = {}
	local var6 = {}

	local function var7(arg0)
		for iter0, iter1 in ipairs(var5) do
			if iter1 == arg0 then
				return false
			end
		end

		return true
	end

	for iter1, iter2 in ipairs(var4) do
		local var8 = checkExist(pg.expedition_activity_template[iter2], {
			"pt_drop_display"
		})

		if var8 and type(var8) == "table" then
			for iter3, iter4 in ipairs(var8) do
				if var7(iter4[2]) then
					table.insert(var5, iter4[2])

					var6[iter4[2]] = {}
				end

				var6[iter4[2]][iter4[1]] = true
			end
		end
	end

	local var9 = getProxy(ActivityProxy)

	for iter5 = #var5, 1, -1 do
		for iter6, iter7 in pairs(var6[var5[iter5]]) do
			local var10 = var9:getActivityById(iter6)

			if var10 and not var10:isEnd() then
				table.insert(var1, 1, {
					2,
					id2ItemId(var5[iter5])
				})

				break
			end
		end
	end

	return var1
end

function var0.initTestShowDrop(arg0, arg1, arg2)
	if IsUnityEditor then
		local var0 = pg.MsgboxMgr.GetInstance()._go
		local var1 = var0.transform:Find("button_test_show_drop")

		if IsNil(var1) then
			var1 = GameObject.New("button_test_show_drop")

			var1:AddComponent(typeof(Button))
			var1:AddComponent(typeof(RectTransform))
			var1:AddComponent(typeof(Image))
		end

		local var2 = var1:GetComponent(typeof(RectTransform))

		var2:SetParent(var0.transform, false)

		var2.anchoredPosition = Vector3(-239, 173, 0)
		var2.sizeDelta = Vector2(40, 40)

		onButton(arg0, var2, function()
			_.each(arg2, function(arg0)
				arg0.anonymous = false
			end)
			arg0:emit(BaseUI.ON_DROP_LIST, {
				item2Row = true,
				itemList = arg2,
				content = arg1:getConfig("display")
			})
		end)
	end
end

function var0.clearTestShowDrop(arg0)
	if IsUnityEditor then
		local var0 = pg.MsgboxMgr.GetInstance()._go.transform:Find("button_test_show_drop")

		if not IsNil(var0) then
			Destroy(var0)
		end
	end
end

function var0.ShowChapterRewardPanel(arg0)
	if arg0.rewardPanel == nil then
		arg0.rewardPanel = ChapterRewardPanel.New(arg0._tf.parent, arg0.event, arg0.contextData)

		arg0.rewardPanel:Load()
	end

	arg0.rewardPanel:ActionInvoke("Enter", arg0.chapter)
end

function var0.ClearChapterRewardPanel(arg0)
	if arg0.rewardPanel ~= nil then
		arg0.rewardPanel:Destroy()

		arg0.rewardPanel = nil
	end
end

function var0.clear(arg0)
	arg0:cancelTween()
	arg0.dropList:each(function(arg0, arg1)
		clearDrop(arg1)
	end)
	arg0:clearTestShowDrop()
	arg0:ClearChapterRewardPanel()
end

return var0
