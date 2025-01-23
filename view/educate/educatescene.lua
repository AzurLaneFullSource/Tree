local var0_0 = class("EducateScene", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateUI"
end

function var0_0.preload(arg0_2, arg1_2)
	pg.PerformMgr.GetInstance():CheckLoad(function()
		arg1_2()
	end)
end

function var0_0.init(arg0_4)
	arg0_4:initData()
	arg0_4:findUI()
	arg0_4:addListener()
end

function var0_0.PlayBGM(arg0_5)
	local var0_5 = getProxy(EducateProxy):GetCharData():GetBgm()

	if var0_5 then
		pg.BgmMgr.GetInstance():Push(arg0_5.__cname, var0_5)
	end
end

function var0_0.initData(arg0_6)
	return
end

function var0_0.findUI(arg0_7)
	arg0_7.mainAnim = arg0_7:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_7.bgTF = arg0_7:findTF("anim_root/bg")
	arg0_7.blurPanel = arg0_7:findTF("anim_root/blur_panel")
	arg0_7.blurPanelAnim = arg0_7.blurPanel:GetComponent(typeof(Animation))
	arg0_7.topTF = arg0_7:findTF("top", arg0_7.blurPanel)
	arg0_7.favorBtn = arg0_7:findTF("favor", arg0_7.topTF)
	arg0_7.favorLvTF = arg0_7:findTF("anim_root/Text", arg0_7.favorBtn)
	arg0_7.favorMaxTF = arg0_7:findTF("anim_root/max", arg0_7.favorBtn)
	arg0_7.favorBtnAnim = arg0_7:findTF("anim_root", arg0_7.favorBtn):GetComponent(typeof(Animation))
	arg0_7.favorBtnAnimEvent = arg0_7:findTF("anim_root", arg0_7.favorBtn):GetComponent(typeof(DftAniEvent))

	arg0_7.favorBtnAnimEvent:SetTriggerEvent(function()
		arg0_7:updateFavorBtn()
	end)

	arg0_7.mainTF = arg0_7:findTF("anim_root/main")
	arg0_7.paintTF = arg0_7:findTF("painting", arg0_7.mainTF)
	arg0_7.dialogueTF = arg0_7:findTF("dialogue", arg0_7.blurPanel)
	arg0_7.dialogueContent = arg0_7:findTF("content", arg0_7.dialogueTF)

	setActive(arg0_7.dialogueTF, false)

	arg0_7.bubbleTF = arg0_7:findTF("anim_root/blur_panel/bubble")

	setActive(arg0_7.bubbleTF, false)

	arg0_7.bubbleBtn = arg0_7:findTF("bubble", arg0_7.bubbleTF)
	arg0_7.optionsTF = arg0_7:findTF("options", arg0_7.mainTF)
	arg0_7.chatBtn = arg0_7:findTF("options/chat", arg0_7.optionsTF)
	arg0_7.giftBtn = arg0_7:findTF("options/gift", arg0_7.optionsTF)

	setActive(arg0_7.optionsTF, false)

	arg0_7.bottomTF = arg0_7:findTF("bottom", arg0_7.blurPanel)
	arg0_7.bookBtn = arg0_7:findTF("left/btns/book", arg0_7.bottomTF)

	setText(arg0_7:findTF("unlock/Text", arg0_7.bookBtn), i18n("child_btn_collect"))

	arg0_7.mindBtn = arg0_7:findTF("left/btns/mind", arg0_7.bottomTF)

	setText(arg0_7:findTF("unlock/Text", arg0_7.mindBtn), i18n("child_btn_mind"))

	arg0_7.bagBtn = arg0_7:findTF("left/btns/bag", arg0_7.bottomTF)

	setText(arg0_7:findTF("unlock/Text", arg0_7.bagBtn), i18n("child_btn_bag"))

	arg0_7.datePanel = EducateDatePanel.New(arg0_7:findTF("date", arg0_7.topTF), arg0_7.event)
	arg0_7.favorPanel = EducateFavorPanel.New(arg0_7:findTF("favor_panel", arg0_7.topTF), arg0_7.event)
	arg0_7.resPanel = EducateResPanel.New(arg0_7:findTF("res", arg0_7.topTF), arg0_7.event)
	arg0_7.topPanel = EducateTopPanel.New(arg0_7:findTF("top_right", arg0_7.topTF), arg0_7.event)
	arg0_7.targetPanel = EducateTargetPanel.New(arg0_7:findTF("target", arg0_7.topTF), arg0_7.event)
	arg0_7.bottomPanel = EducateBottomPanel.New(arg0_7:findTF("right", arg0_7.bottomTF), arg0_7.event, {
		isMainEnter = arg0_7.contextData.isMainEnter
	})
	arg0_7.archivePanel = EducateArchivePanel.New(arg0_7:findTF("archive_panel", arg0_7.mainTF), arg0_7.event, {
		isShow = true,
		isMainEnter = arg0_7.contextData.isMainEnter
	})
end

function var0_0._loadSubViews(arg0_9)
	arg0_9.datePanel:Load()
	arg0_9.favorPanel:Load()
	arg0_9.resPanel:Load()
	arg0_9.topPanel:Load()
	arg0_9.targetPanel:Load()
	arg0_9.bottomPanel:Load()
	arg0_9.archivePanel:Load()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_9.blurPanel, {
		pbList = {
			arg0_9:findTF("bottom/left", arg0_9.blurPanel)
		},
		groupName = arg0_9:getGroupNameFromData()
	})

	local var0_9 = arg0_9.contextData.isMainEnter and "anim_educate_educateUI_bg_in" or "anim_educate_educateUI_bg_show"

	arg0_9.mainAnim:Play(var0_9)

	local var1_9 = arg0_9.contextData.isMainEnter and "anim_educate_educateUI_in" or "anim_educate_educateUI_show"

	arg0_9.blurPanelAnim:Play(var1_9)
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10.chatBtn, function()
		pg.TipsMgr.GetInstance():ShowTips("触发对话[待开发]...")
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.giftBtn, function()
		pg.TipsMgr.GetInstance():ShowTips("送礼(?)...")
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.favorBtn, function()
		arg0_10.favorPanel:Show()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.bookBtn, function()
		arg0_10:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectEntranceMediator,
			viewComponent = EducateCollectEntranceLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.mindBtn, function()
		if isActive(arg0_10:findTF("lock", arg0_10.mindBtn)) then
			return
		end

		arg0_10:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateMindMediator,
			viewComponent = EducateMindLayer,
			data = {
				onExit = function()
					arg0_10:checkBubbleShow()
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.bagBtn, function()
		if isActive(arg0_10:findTF("lock", arg0_10.bagBtn)) then
			return
		end

		arg0_10:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateBagMediator,
			viewComponent = EducateBagLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10:findTF("fitter", arg0_10.paintTF), function()
		arg0_10:ShowDialogue()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_19)
	if arg0_19.contextData.onEnter then
		arg0_19.contextData.onEnter()

		arg0_19.contextData.onEnter = nil
	end

	arg0_19:updatePaintingUI()
	arg0_19:updateUnlockBtns()
	arg0_19:updateNewTips()
	arg0_19:updateMindTip()
	arg0_19:updateFavorBtn()
	arg0_19:SeriesCheck()
end

function var0_0.SeriesCheck(arg0_20)
	local var0_20 = {}

	table.insert(var0_20, function(arg0_21)
		arg0_20:CheckNewChar(arg0_21)
	end)
	table.insert(var0_20, function(arg0_22)
		if getProxy(EducateProxy):GetPlanProxy():CheckExcute() then
			arg0_20:emit(EducateMediator.ON_EXECTUE_PLANS)
		else
			arg0_22()
		end
	end)
	table.insert(var0_20, function(arg0_23)
		arg0_20:CheckTips(arg0_23)
	end)
	table.insert(var0_20, function(arg0_24)
		if getProxy(EducateProxy):GetEventProxy():NeedGetHomeEventData() then
			arg0_20:emit(EducateMediator.ON_GET_EVENT, arg0_24)
		else
			arg0_24()
		end
	end)
	arg0_20:checkBubbleShow()
	table.insert(var0_20, function(arg0_25)
		if not arg0_20.contextData.ingoreGuideCheck then
			EducateGuideSequence.CheckGuide(arg0_20.__cname, arg0_25)
		else
			arg0_20.contextData.ingoreGuideCheck = nil

			arg0_25()
		end
	end)
	seriesAsync(var0_20, function()
		return
	end)
end

function var0_0.OnCheckGuide(arg0_27)
	EducateGuideSequence.CheckGuide(arg0_27.__cname, function()
		return
	end)
end

function var0_0.CheckTips(arg0_29, arg1_29)
	local var0_29 = {}

	for iter0_29, iter1_29 in ipairs(EducateTipHelper.GetSystemUnlockTips()) do
		table.insert(var0_29, function(arg0_30)
			arg0_29:emit(var0_0.EDUCATE_ON_UNLOCK_TIP, {
				type = EducateUnlockTipLayer.UNLOCK_TYPE_SYSTEM,
				single = iter1_29,
				onExit = arg0_30
			})
		end)
	end

	seriesAsync(var0_29, function()
		arg1_29()
	end)
end

function var0_0.CheckNewChar(arg0_32, arg1_32)
	if getProxy(EducateProxy):GetCharData():GetCallName() == "" then
		setActive(arg0_32._tf, false)

		local var0_32 = {}

		table.insert(var0_32, function(arg0_33)
			pg.PerformMgr.GetInstance():PlayGroup(EducateConst.FIRST_ENTER_PERFORM_IDS, arg0_33)
		end)
		table.insert(var0_32, function(arg0_34)
			arg0_32:emit(var0_0.EDUCATE_GO_SUBLAYER, Context.New({
				mediator = EducateNewCharMediator,
				viewComponent = EducateNewCharLayer,
				data = {
					callback = arg0_34
				}
			}))
		end)
		table.insert(var0_32, function(arg0_35)
			pg.PerformMgr.GetInstance():PlayOne(EducateConst.AFTER_SET_CALLNAME_PERFORM_ID, arg0_35)
		end)
		seriesAsync(var0_32, function()
			setActive(arg0_32._tf, true)
			arg0_32:_loadSubViews()
			arg1_32()
		end)
	else
		arg0_32:_loadSubViews()
		arg1_32()
	end
end

function var0_0.showBubble(arg0_37, arg1_37)
	setActive(arg0_37.bubbleTF, true)
	onButton(arg0_37, arg0_37.bubbleBtn, function()
		arg1_37()
		setActive(arg0_37.bubbleTF, false)
	end, SFX_PANEL)
end

function var0_0.PlayPerformWithDrops(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = EducateHelper.GetDialogueShowDrops(arg2_39)
	local var1_39 = EducateHelper.GetCommonShowDrops(arg2_39)

	local function var2_39()
		if #var1_39 > 0 then
			arg0_39:emit(var0_0.EDUCATE_ON_AWARD, {
				items = var1_39,
				removeFunc = function()
					if arg3_39 then
						arg3_39()
					end
				end
			})
		elseif arg3_39 then
			arg3_39()
		end
	end

	if #arg1_39 > 0 then
		pg.PerformMgr.GetInstance():PlayGroup(arg1_39, var2_39, var0_39)
	elseif var2_39 then
		var2_39()
	end
end

function var0_0.ShowFavorUpgrade(arg0_42, arg1_42, arg2_42, arg3_42)
	arg0_42:PlayPerformWithDrops(arg2_42, arg1_42, function()
		if #arg1_42 > 0 then
			arg0_42:emit(var0_0.EDUCATE_ON_AWARD, {
				items = arg1_42,
				removeFunc = function()
					arg0_42.favorBtnAnim:Play("anim_educate_favor_levelup")

					if arg3_42 then
						arg3_42()
					end
				end
			})
		else
			arg0_42.favorBtnAnim:Play("anim_educate_favor_levelup")

			if arg3_42 then
				arg3_42()
			end
		end
	end)
end

function var0_0.ShowSpecialEvent(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45 = pg.child_event_special[arg1_45].performance

	arg0_45:PlayPerformWithDrops(var0_45, arg2_45, function()
		if #arg2_45 > 0 then
			arg0_45:emit(var0_0.EDUCATE_ON_AWARD, {
				items = arg2_45,
				removeFunc = function()
					if arg3_45 then
						arg3_45()
					end
				end
			})
		elseif arg3_45 then
			arg3_45()
		end
	end)
end

function var0_0.checkBubbleShow(arg0_48)
	local var0_48 = getProxy(EducateProxy):GetEventProxy():GetHomeSpecEvents()
	local var1_48 = getProxy(EducateProxy):GetCharData()

	if #var0_48 > 0 then
		setActive(arg0_48:findTF("Text", arg0_48.bubbleBtn), true)
		setActive(arg0_48:findTF("Image", arg0_48.bubbleBtn), false)
		arg0_48:showBubble(function()
			arg0_48:emit(EducateMediator.ON_SPECIAL_EVENT_TRIGGER, {
				id = var0_48[1].id,
				callback = function()
					arg0_48:checkBubbleShow()
					EducateGuideSequence.CheckGuide(arg0_48.__cname, function()
						return
					end)
				end
			})
		end)
	elseif var1_48:CheckFavor() then
		setActive(arg0_48:findTF("Text", arg0_48.bubbleBtn), false)
		setActive(arg0_48:findTF("Image", arg0_48.bubbleBtn), true)
		arg0_48:showBubble(function()
			arg0_48:emit(EducateMediator.ON_UPGRADE_FAVOR, function()
				arg0_48:checkBubbleShow()
				EducateGuideSequence.CheckGuide(arg0_48.__cname, function()
					return
				end)
			end)
		end)
	else
		setActive(arg0_48.bubbleTF, false)
		removeOnButton(arg0_48.bubbleTF)
	end
end

function var0_0.updateResPanel(arg0_55)
	arg0_55.resPanel:Flush()
end

function var0_0.updateArchivePanel(arg0_56)
	arg0_56.archivePanel:Flush()
end

function var0_0.showArchivePanel(arg0_57)
	arg0_57.archivePanel:showPanel()
end

function var0_0.updateDatePanel(arg0_58)
	arg0_58.datePanel:Flush()
	arg0_58:updateUnlockBtns()
end

function var0_0.updateUnlockBtns(arg0_59)
	local var0_59 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_MEMORY)

	setActive(arg0_59:findTF("lock", arg0_59.bookBtn), not var0_59)
	setActive(arg0_59:findTF("unlock", arg0_59.bookBtn), var0_59)

	local var1_59 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_BAG)

	setActive(arg0_59:findTF("lock", arg0_59.bagBtn), not var1_59)
	setActive(arg0_59:findTF("unlock", arg0_59.bagBtn), var1_59)

	local var2_59 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_FAVOR_AND_MIND)

	setActive(arg0_59:findTF("lock", arg0_59.mindBtn), not var2_59)
	setActive(arg0_59:findTF("unlock", arg0_59.mindBtn), var2_59)
	setActive(arg0_59.favorBtn, var2_59)
end

function var0_0.updateMindTip(arg0_60)
	setActive(arg0_60:findTF("unlock/tip", arg0_60.mindBtn), getProxy(EducateProxy):GetTaskProxy():IsShowMindTasksTip())
end

function var0_0.updateWeekDay(arg0_61, arg1_61)
	arg0_61.datePanel:UpdateWeekDay(arg1_61)
end

function var0_0.updateFavorBtn(arg0_62)
	local var0_62 = getProxy(EducateProxy):GetCharData()
	local var1_62 = var0_62:GetFavor()

	setText(arg0_62.favorLvTF, var1_62.lv)

	local var2_62 = var0_62:GetFavorMaxLv()

	setActive(arg0_62.favorMaxTF, var1_62.lv == var2_62)
end

function var0_0.updateTargetPanel(arg0_63)
	arg0_63.targetPanel:Flush()
end

function var0_0.updateBottomPanel(arg0_64)
	arg0_64.bottomPanel:Flush()
end

function var0_0.updatePaintingUI(arg0_65)
	local var0_65 = getProxy(EducateProxy):GetCharData()

	arg0_65.bgName = var0_65:GetBGName()
	arg0_65.paintingName = var0_65:GetPaintingName()
	arg0_65.wordList, arg0_65.faceList = var0_65:GetMainDialogueInfo()

	local var1_65 = LoadSprite("bg/" .. arg0_65.bgName)

	setImageSprite(arg0_65.bgTF, var1_65, false)
	setPaintingPrefab(arg0_65.paintTF, arg0_65.paintingName, "yangcheng")
end

function var0_0.ShowDialogue(arg0_66)
	if LeanTween.isTweening(arg0_66.dialogueTF) then
		return
	end

	local var0_66 = math.random(#arg0_66.wordList)
	local var1_66 = pg.child_word[arg0_66.wordList[var0_66]].word

	if not arg0_66.callName then
		arg0_66.callName = getProxy(EducateProxy):GetCharData():GetCallName()
	end

	local var2_66 = string.gsub(var1_66, "$1", arg0_66.callName)

	setText(arg0_66.dialogueContent, var2_66)

	local var3_66 = GetSpriteFromAtlas("paintingface/" .. arg0_66.paintingName, arg0_66.faceList[var0_66])
	local var4_66 = arg0_66:findTF("fitter", arg0_66.paintTF):GetChild(0):Find("face")

	if var4_66 and var3_66 then
		setImageSprite(var4_66, var3_66)
		setActive(var4_66, true)
	end

	arg0_66.dialogueTF.localScale = Vector3.zero

	setActive(arg0_66.dialogueTF, true)
	LeanTween.scale(arg0_66.dialogueTF, Vector3.one, 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(arg0_66.dialogueTF, Vector3.zero, 0.3):setEase(LeanTweenType.easeInBack):setDelay(3):setOnComplete(System.Action(function()
			setActive(arg0_66.dialogueTF, false)

			if var4_66 then
				setActive(var4_66, false)
			end
		end))
	end))
end

function var0_0.updateNewTips(arg0_69)
	arg0_69:updateBookNewTip()
	arg0_69:updateMindNewTip()
end

function var0_0.updateBookNewTip(arg0_70)
	local var0_70 = underscore.any(pg.child_memory.all, function(arg0_71)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0_71)
	end)
	local var1_70 = EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID)

	setActive(arg0_70:findTF("unlock/new", arg0_70.bookBtn), var0_70 or var1_70)
end

function var0_0.updateMindNewTip(arg0_72)
	setActive(arg0_72:findTF("unlock/new", arg0_72.mindBtn), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MIND_TASK))
end

function var0_0.FlushView(arg0_73)
	arg0_73.datePanel:Flush()
	arg0_73.favorPanel:Flush()
	arg0_73.resPanel:Flush()
	arg0_73.targetPanel:Flush()
	arg0_73.bottomPanel:Flush()
	arg0_73.archivePanel:Flush()
	arg0_73:updatePaintingUI()
	arg0_73:updateUnlockBtns()
	arg0_73:updateNewTips()
	arg0_73:updateMindTip()
	arg0_73:updateFavorBtn()
	arg0_73:SeriesCheck()
end

function var0_0.onBackPressed(arg0_74)
	arg0_74:emit(var0_0.EDUCATE_GO_SCENE, SCENE.NEW_EDUCATE_SELECT)
end

function var0_0.willExit(arg0_75)
	arg0_75.contextData.isMainEnter = nil

	arg0_75.datePanel:Destroy()

	arg0_75.datePanel = nil

	arg0_75.favorPanel:Destroy()

	arg0_75.favorPanel = nil

	arg0_75.resPanel:Destroy()

	arg0_75.resPanel = nil

	arg0_75.topPanel:Destroy()

	arg0_75.topPanel = nil

	arg0_75.targetPanel:Destroy()

	arg0_75.targetPanel = nil

	arg0_75.bottomPanel:Destroy()

	arg0_75.bottomPanel = nil

	arg0_75.archivePanel:Destroy()

	arg0_75.archivePanel = nil

	if LeanTween.isTweening(arg0_75.dialogueTF) then
		LeanTween.cancel(arg0_75.dialogueTF)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_75.blurPanel, arg0_75._tf)
end

return var0_0
