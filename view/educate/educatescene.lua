local var0_0 = class("EducateScene", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateUI"
end

function var0_0.preload(arg0_2, arg1_2)
	pg.PerformMgr.GetInstance():CheckLoad(function()
		arg1_2()
	end)
end

function var0_0.getResource(arg0_4)
	local var0_4 = var0_0.super.getResource(arg0_4)
	local var1_4 = {
		"ui/EducateDatePanel",
		"ui/EducateFavorPanel",
		"ui/EducateResPanel",
		"ui/EducateTopPanel",
		"ui/EducateTargetPanel",
		"ui/EducateBottomPanel",
		"ui/EducateArchivePanel",
		"ui/educatecommonui_atlas"
	}

	local function var2_4(arg0_5)
		if noEmptyStr(arg0_5) and not table.contains(var1_4, arg0_5) then
			table.insert(var1_4, arg0_5)
		end
	end

	local var3_4 = getProxy(EducateProxy)
	local var4_4 = var3_4 and var3_4:GetCharData()

	if var4_4 then
		for iter0_4, iter1_4 in ipairs(var4_4:getConfig("background_prefab") or {}) do
			var2_4("bg/" .. iter1_4)
		end

		local var5_4 = {}

		for iter2_4, iter3_4 in ipairs(var4_4:getConfig("char_prefab") or {}) do
			local var6_4 = iter3_4[3]

			if noEmptyStr(var6_4) and not var5_4[var6_4] then
				var5_4[var6_4] = true

				PaintingGroupConst.AddPaintingNameWithFilteMap(var1_4, var6_4)
				var2_4("paintingface/" .. var6_4)
				var2_4("educateavatar/" .. var6_4)
				var2_4("squareicon/" .. var6_4)
			end
		end

		local var7_4 = var4_4:getConfig("bgm") or {}

		for iter4_4, iter5_4 in ipairs(var7_4) do
			if type(iter5_4) == "string" then
				var2_4("cue/bgm-" .. iter5_4 .. ".b")
			elseif type(iter5_4) == "table" then
				for iter6_4, iter7_4 in ipairs(iter5_4) do
					if type(iter7_4) == "table" then
						var2_4("cue/bgm-" .. iter7_4[2] .. ".b")
					end
				end
			end
		end
	end

	if var3_4 then
		for iter8_4, iter9_4 in ipairs(var3_4:GetBuffList() or {}) do
			var2_4("educateprops/" .. iter9_4:getConfig("icon"))
		end
	end

	for iter10_4, iter11_4 in ipairs(var1_4) do
		if not table.contains(var0_4, iter11_4) then
			table.insert(var0_4, iter11_4)
		end
	end

	return var0_4
end

function var0_0.init(arg0_6)
	arg0_6:initData()
	arg0_6:findUI()
	arg0_6:addListener()
end

function var0_0.PlayBGM(arg0_7)
	local var0_7 = getProxy(EducateProxy):GetCharData():GetBgm()

	if var0_7 then
		pg.BgmMgr.GetInstance():Push(arg0_7.__cname, var0_7)
	end
end

function var0_0.initData(arg0_8)
	return
end

function var0_0.findUI(arg0_9)
	arg0_9.mainAnim = arg0_9._tf:Find("anim_root"):GetComponent(typeof(Animation))
	arg0_9.bgTF = arg0_9._tf:Find("anim_root/bg")
	arg0_9.blurPanel = arg0_9._tf:Find("anim_root/blur_panel")
	arg0_9.blurPanelAnim = arg0_9.blurPanel:GetComponent(typeof(Animation))
	arg0_9.topTF = arg0_9.blurPanel:Find("top")
	arg0_9.favorBtn = arg0_9.topTF:Find("favor")
	arg0_9.favorLvTF = arg0_9.favorBtn:Find("anim_root/Text")
	arg0_9.favorMaxTF = arg0_9.favorBtn:Find("anim_root/max")
	arg0_9.favorBtnAnim = arg0_9.favorBtn:Find("anim_root"):GetComponent(typeof(Animation))
	arg0_9.favorBtnAnimEvent = arg0_9.favorBtn:Find("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_9.favorBtnAnimEvent:SetTriggerEvent(function()
		arg0_9:updateFavorBtn()
	end)

	arg0_9.mainTF = arg0_9._tf:Find("anim_root/main")
	arg0_9.paintTF = arg0_9.mainTF:Find("painting")
	arg0_9.dialogueTF = arg0_9.blurPanel:Find("dialogue")
	arg0_9.dialogueContent = arg0_9.dialogueTF:Find("content")

	setActive(arg0_9.dialogueTF, false)

	arg0_9.bubbleTF = arg0_9._tf:Find("anim_root/blur_panel/bubble")

	setActive(arg0_9.bubbleTF, false)

	arg0_9.bubbleBtn = arg0_9.bubbleTF:Find("bubble")
	arg0_9.optionsTF = arg0_9.mainTF:Find("options")
	arg0_9.chatBtn = arg0_9.optionsTF:Find("options/chat")
	arg0_9.giftBtn = arg0_9.optionsTF:Find("options/gift")

	setActive(arg0_9.optionsTF, false)

	arg0_9.bottomTF = arg0_9.blurPanel:Find("bottom")
	arg0_9.bookBtn = arg0_9.bottomTF:Find("left/btns/book")

	setText(arg0_9.bookBtn:Find("unlock/Text"), i18n("child_btn_collect"))

	arg0_9.mindBtn = arg0_9.bottomTF:Find("left/btns/mind")

	setText(arg0_9.mindBtn:Find("unlock/Text"), i18n("child_btn_mind"))

	arg0_9.bagBtn = arg0_9.bottomTF:Find("left/btns/bag")

	setText(arg0_9.bagBtn:Find("unlock/Text"), i18n("child_btn_bag"))

	arg0_9.datePanel = EducateDatePanel.New(arg0_9.topTF:Find("date"), arg0_9.event, {
		isMain = true
	})

	arg0_9.datePanel:RegisterView(arg0_9)

	arg0_9.favorPanel = EducateFavorPanel.New(arg0_9.topTF:Find("favor_panel"), arg0_9.event)

	arg0_9.favorPanel:RegisterView(arg0_9)

	arg0_9.resPanel = EducateResPanel.New(arg0_9.topTF:Find("res"), arg0_9.event)

	arg0_9.resPanel:RegisterView(arg0_9)

	arg0_9.topPanel = EducateTopPanel.New(arg0_9.topTF:Find("top_right"), arg0_9.event)

	arg0_9.topPanel:RegisterView(arg0_9)

	arg0_9.targetPanel = EducateTargetPanel.New(arg0_9.topTF:Find("target"), arg0_9.event)

	arg0_9.targetPanel:RegisterView(arg0_9)

	arg0_9.bottomPanel = EducateBottomPanel.New(arg0_9.bottomTF:Find("right"), arg0_9.event, {
		isMainEnter = arg0_9.contextData.isMainEnter
	})

	arg0_9.bottomPanel:RegisterView(arg0_9)

	arg0_9.archivePanel = EducateArchivePanel.New(arg0_9.mainTF:Find("archive_panel"), arg0_9.event, {
		isShow = true,
		isMainEnter = arg0_9.contextData.isMainEnter
	})

	arg0_9.archivePanel:RegisterView(arg0_9)
end

function var0_0._loadSubViews(arg0_11)
	arg0_11.datePanel:Load()
	arg0_11.favorPanel:Load()
	arg0_11.resPanel:Load()
	arg0_11.topPanel:Load()
	arg0_11.targetPanel:Load()
	arg0_11.bottomPanel:Load()
	arg0_11.archivePanel:Load()
	arg0_11:OverlayPanel(arg0_11.blurPanel, {
		pbList = {
			arg0_11.blurPanel:Find("bottom/left")
		}
	})

	local var0_11 = arg0_11.contextData.isMainEnter and "anim_educate_educateUI_bg_in" or "anim_educate_educateUI_bg_show"

	arg0_11.mainAnim:Play(var0_11)

	local var1_11 = arg0_11.contextData.isMainEnter and "anim_educate_educateUI_in" or "anim_educate_educateUI_show"

	arg0_11.blurPanelAnim:Play(var1_11)
end

function var0_0.addListener(arg0_12)
	onButton(arg0_12, arg0_12.chatBtn, function()
		pg.TipsMgr.GetInstance():ShowTips("触发对话[待开发]...")
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.giftBtn, function()
		pg.TipsMgr.GetInstance():ShowTips("送礼(?)...")
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.favorBtn, function()
		arg0_12.favorPanel:Show()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.bookBtn, function()
		arg0_12:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectEntranceMediator,
			viewComponent = EducateCollectEntranceLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.mindBtn, function()
		if isActive(arg0_12.mindBtn:Find("lock")) then
			return
		end

		arg0_12:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateMindMediator,
			viewComponent = EducateMindLayer,
			data = {
				onExit = function()
					arg0_12:checkBubbleShow()
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.bagBtn, function()
		if isActive(arg0_12.bagBtn:Find("lock")) then
			return
		end

		arg0_12:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateBagMediator,
			viewComponent = EducateBagLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.paintTF:Find("fitter"), function()
		arg0_12:ShowDialogue()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_21)
	if arg0_21.contextData.onEnter then
		arg0_21.contextData.onEnter()

		arg0_21.contextData.onEnter = nil
	end

	arg0_21:updatePaintingUI()
	arg0_21:updateUnlockBtns()
	arg0_21:updateNewTips()
	arg0_21:updateMindTip()
	arg0_21:updateFavorBtn()
	arg0_21:SeriesCheck()
end

function var0_0.SeriesCheck(arg0_22)
	local var0_22 = {}

	table.insert(var0_22, function(arg0_23)
		arg0_22:CheckNewChar(arg0_23)
	end)
	table.insert(var0_22, function(arg0_24)
		if getProxy(EducateProxy):GetPlanProxy():CheckExcute() then
			arg0_22:emit(EducateMediator.ON_EXECTUE_PLANS)
		else
			arg0_24()
		end
	end)
	table.insert(var0_22, function(arg0_25)
		arg0_22:CheckTips(arg0_25)
	end)
	table.insert(var0_22, function(arg0_26)
		if getProxy(EducateProxy):GetEventProxy():NeedGetHomeEventData() then
			arg0_22:emit(EducateMediator.ON_GET_EVENT, arg0_26)
		else
			arg0_26()
		end
	end)
	arg0_22:checkBubbleShow()
	table.insert(var0_22, function(arg0_27)
		if not arg0_22.contextData.ingoreGuideCheck then
			EducateGuideSequence.CheckGuide(arg0_22.__cname, arg0_27)
		else
			arg0_22.contextData.ingoreGuideCheck = nil

			arg0_27()
		end
	end)
	seriesAsync(var0_22, function()
		return
	end)
end

function var0_0.OnCheckGuide(arg0_29, arg1_29)
	EducateGuideSequence.CheckGuide(arg0_29.__cname, function()
		existCall(arg1_29)
	end)
end

function var0_0.CheckTips(arg0_31, arg1_31)
	local var0_31 = {}

	for iter0_31, iter1_31 in ipairs(EducateTipHelper.GetSystemUnlockTips()) do
		table.insert(var0_31, function(arg0_32)
			arg0_31:emit(var0_0.EDUCATE_ON_UNLOCK_TIP, {
				type = EducateUnlockTipLayer.UNLOCK_TYPE_SYSTEM,
				single = iter1_31,
				onExit = arg0_32
			})
		end)
	end

	seriesAsync(var0_31, function()
		arg1_31()
	end)
end

function var0_0.CheckNewChar(arg0_34, arg1_34)
	if getProxy(EducateProxy):GetCharData():GetCallName() == "" then
		setActive(arg0_34._tf, false)

		local var0_34 = {}

		table.insert(var0_34, function(arg0_35)
			pg.PerformMgr.GetInstance():PlayGroup(EducateConst.FIRST_ENTER_PERFORM_IDS, arg0_35)
		end)
		table.insert(var0_34, function(arg0_36)
			arg0_34:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
				mediator = EducateNewCharMediator,
				viewComponent = EducateNewCharLayer,
				data = {
					callback = arg0_36
				}
			}))
		end)
		table.insert(var0_34, function(arg0_37)
			pg.PerformMgr.GetInstance():PlayOne(EducateConst.AFTER_SET_CALLNAME_PERFORM_ID, arg0_37)
		end)
		seriesAsync(var0_34, function()
			setActive(arg0_34._tf, true)
			arg0_34:_loadSubViews()
			arg1_34()
		end)
	else
		arg0_34:_loadSubViews()
		arg1_34()
	end
end

function var0_0.showBubble(arg0_39, arg1_39)
	setActive(arg0_39.bubbleTF, true)
	onButton(arg0_39, arg0_39.bubbleBtn, function()
		arg1_39()
		setActive(arg0_39.bubbleTF, false)
	end, SFX_PANEL)
end

function var0_0.PlayPerformWithDrops(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41 = EducateHelper.GetDialogueShowDrops(arg2_41)
	local var1_41 = EducateHelper.GetCommonShowDrops(arg2_41)

	local function var2_41()
		if #var1_41 > 0 then
			arg0_41:emit(var0_0.EDUCATE_ON_AWARD, {
				items = var1_41,
				removeFunc = function()
					if arg3_41 then
						arg3_41()
					end
				end
			})
		elseif arg3_41 then
			arg3_41()
		end
	end

	if #arg1_41 > 0 then
		pg.PerformMgr.GetInstance():PlayGroup(arg1_41, var2_41, var0_41)
	elseif var2_41 then
		var2_41()
	end
end

function var0_0.ShowFavorUpgrade(arg0_44, arg1_44, arg2_44, arg3_44)
	arg0_44:PlayPerformWithDrops(arg2_44, arg1_44, function()
		if #arg1_44 > 0 then
			arg0_44:emit(var0_0.EDUCATE_ON_AWARD, {
				items = arg1_44,
				removeFunc = function()
					arg0_44.favorBtnAnim:Play("anim_educate_favor_levelup")

					if arg3_44 then
						arg3_44()
					end
				end
			})
		else
			arg0_44.favorBtnAnim:Play("anim_educate_favor_levelup")

			if arg3_44 then
				arg3_44()
			end
		end
	end)
end

function var0_0.ShowSpecialEvent(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47 = pg.child_event_special[arg1_47].performance

	arg0_47:PlayPerformWithDrops(var0_47, arg2_47, function()
		if #arg2_47 > 0 then
			arg0_47:emit(var0_0.EDUCATE_ON_AWARD, {
				items = arg2_47,
				removeFunc = function()
					if arg3_47 then
						arg3_47()
					end
				end
			})
		elseif arg3_47 then
			arg3_47()
		end
	end)
end

function var0_0.checkBubbleShow(arg0_50)
	local var0_50 = getProxy(EducateProxy):GetEventProxy():GetHomeSpecEvents()
	local var1_50 = getProxy(EducateProxy):GetCharData()

	if #var0_50 > 0 then
		setActive(arg0_50.bubbleBtn:Find("Text"), true)
		setActive(arg0_50.bubbleBtn:Find("Image"), false)
		arg0_50:showBubble(function()
			arg0_50:emit(EducateMediator.ON_SPECIAL_EVENT_TRIGGER, {
				id = var0_50[1].id,
				callback = function()
					arg0_50:checkBubbleShow()
					EducateGuideSequence.CheckGuide(arg0_50.__cname, function()
						return
					end)
				end
			})
		end)
	elseif var1_50:CheckFavor() then
		setActive(arg0_50.bubbleBtn:Find("Text"), false)
		setActive(arg0_50.bubbleBtn:Find("Image"), true)
		arg0_50:showBubble(function()
			arg0_50:emit(EducateMediator.ON_UPGRADE_FAVOR, function()
				arg0_50:checkBubbleShow()
				EducateGuideSequence.CheckGuide(arg0_50.__cname, function()
					return
				end)
			end)
		end)
	else
		setActive(arg0_50.bubbleTF, false)
		removeOnButton(arg0_50.bubbleTF)
	end
end

function var0_0.updateResPanel(arg0_57)
	arg0_57.resPanel:Flush()
end

function var0_0.updateArchivePanel(arg0_58)
	arg0_58.archivePanel:Flush()
end

function var0_0.showArchivePanel(arg0_59)
	arg0_59.archivePanel:showPanel()
end

function var0_0.updateDatePanel(arg0_60)
	arg0_60.datePanel:Flush()
	arg0_60:updateUnlockBtns()
end

function var0_0.updateUnlockBtns(arg0_61)
	local var0_61 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_MEMORY)

	setActive(arg0_61.bookBtn:Find("lock"), not var0_61)
	setActive(arg0_61.bookBtn:Find("unlock"), var0_61)

	local var1_61 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_BAG)

	setActive(arg0_61.bagBtn:Find("lock"), not var1_61)
	setActive(arg0_61.bagBtn:Find("unlock"), var1_61)

	local var2_61 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_FAVOR_AND_MIND)

	setActive(arg0_61.mindBtn:Find("lock"), not var2_61)
	setActive(arg0_61.mindBtn:Find("unlock"), var2_61)
	setActive(arg0_61.favorBtn, var2_61)
end

function var0_0.updateMindTip(arg0_62)
	setActive(arg0_62.mindBtn:Find("unlock/tip"), getProxy(EducateProxy):GetTaskProxy():IsShowMindTasksTip())
end

function var0_0.updateWeekDay(arg0_63, arg1_63)
	arg0_63.datePanel:UpdateWeekDay(arg1_63)
end

function var0_0.updateFavorBtn(arg0_64)
	local var0_64 = getProxy(EducateProxy):GetCharData()
	local var1_64 = var0_64:GetFavor()

	setText(arg0_64.favorLvTF, var1_64.lv)

	local var2_64 = var0_64:GetFavorMaxLv()

	setActive(arg0_64.favorMaxTF, var1_64.lv == var2_64)
end

function var0_0.updateTargetPanel(arg0_65)
	arg0_65.targetPanel:Flush()
end

function var0_0.updateBottomPanel(arg0_66)
	arg0_66.bottomPanel:Flush()
end

function var0_0.updatePaintingUI(arg0_67)
	local var0_67 = getProxy(EducateProxy):GetCharData()

	arg0_67.bgName = var0_67:GetBGName()
	arg0_67.paintingName = var0_67:GetPaintingName()
	arg0_67.wordList, arg0_67.faceList = var0_67:GetMainDialogueInfo()

	local var1_67 = LoadSprite("bg/" .. arg0_67.bgName)

	setImageSprite(arg0_67.bgTF, var1_67, false)
	setPaintingPrefab(arg0_67.paintTF, arg0_67.paintingName, "yangcheng")
end

function var0_0.ShowDialogue(arg0_68)
	if LeanTween.isTweening(arg0_68.dialogueTF) then
		return
	end

	local var0_68 = math.random(#arg0_68.wordList)
	local var1_68 = pg.child_word[arg0_68.wordList[var0_68]].word

	if not arg0_68.callName then
		arg0_68.callName = getProxy(EducateProxy):GetCharData():GetCallName()
	end

	local var2_68 = string.gsub(var1_68, "$1", arg0_68.callName)

	setText(arg0_68.dialogueContent, var2_68)

	local var3_68 = GetSpriteFromAtlas("paintingface/" .. arg0_68.paintingName, arg0_68.faceList[var0_68])
	local var4_68 = arg0_68.paintTF:Find("fitter"):GetChild(0):Find("face")

	if var4_68 and var3_68 then
		setImageSprite(var4_68, var3_68)
		setActive(var4_68, true)
	end

	arg0_68.dialogueTF.localScale = Vector3.zero

	setActive(arg0_68.dialogueTF, true)
	LeanTween.scale(arg0_68.dialogueTF, Vector3.one, 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(arg0_68.dialogueTF, Vector3.zero, 0.3):setEase(LeanTweenType.easeInBack):setDelay(3):setOnComplete(System.Action(function()
			setActive(arg0_68.dialogueTF, false)

			if var4_68 then
				setActive(var4_68, false)
			end
		end))
	end))
end

function var0_0.updateNewTips(arg0_71)
	arg0_71:updateBookNewTip()
	arg0_71:updateMindNewTip()
end

function var0_0.updateBookNewTip(arg0_72)
	local var0_72 = underscore.any(pg.child_memory.all, function(arg0_73)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0_73)
	end)
	local var1_72 = EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID)

	setActive(arg0_72.bookBtn:Find("unlock/new"), var0_72 or var1_72)
end

function var0_0.updateMindNewTip(arg0_74)
	setActive(arg0_74.mindBtn:Find("unlock/new"), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MIND_TASK))
end

function var0_0.FlushView(arg0_75)
	arg0_75.datePanel:Flush()
	arg0_75.favorPanel:Flush()
	arg0_75.resPanel:Flush()
	arg0_75.targetPanel:Flush()
	arg0_75.bottomPanel:Flush()
	arg0_75.archivePanel:Flush()
	arg0_75:updatePaintingUI()
	arg0_75:updateUnlockBtns()
	arg0_75:updateNewTips()
	arg0_75:updateMindTip()
	arg0_75:updateFavorBtn()
	arg0_75:SeriesCheck()
end

function var0_0.onBackPressed(arg0_76)
	arg0_76:emit(var0_0.EDUCATE_GO_SCENE, SCENE.NEW_EDUCATE_SELECT, {
		isTb1 = true
	})
end

function var0_0.willExit(arg0_77)
	arg0_77.contextData.isMainEnter = nil

	arg0_77.datePanel:Destroy()

	arg0_77.datePanel = nil

	arg0_77.favorPanel:Destroy()

	arg0_77.favorPanel = nil

	arg0_77.resPanel:Destroy()

	arg0_77.resPanel = nil

	arg0_77.topPanel:Destroy()

	arg0_77.topPanel = nil

	arg0_77.targetPanel:Destroy()

	arg0_77.targetPanel = nil

	arg0_77.bottomPanel:Destroy()

	arg0_77.bottomPanel = nil

	arg0_77.archivePanel:Destroy()

	arg0_77.archivePanel = nil

	if LeanTween.isTweening(arg0_77.dialogueTF) then
		LeanTween.cancel(arg0_77.dialogueTF)
	end

	arg0_77:UnOverlayPanel(arg0_77.blurPanel, arg0_77._tf)
end

return var0_0
