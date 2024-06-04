local var0 = class("EducateScene", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateUI"
end

function var0.preload(arg0, arg1)
	pg.PerformMgr.GetInstance():CheckLoad(function()
		arg1()
	end)
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.PlayBGM(arg0)
	local var0 = getProxy(EducateProxy):GetCharData():GetBgm()

	if var0 then
		pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
	end
end

function var0.initData(arg0)
	return
end

function var0.findUI(arg0)
	arg0.mainAnim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.bgTF = arg0:findTF("anim_root/bg")
	arg0.blurPanel = arg0:findTF("anim_root/blur_panel")
	arg0.blurPanelAnim = arg0.blurPanel:GetComponent(typeof(Animation))
	arg0.topTF = arg0:findTF("top", arg0.blurPanel)
	arg0.favorBtn = arg0:findTF("favor", arg0.topTF)
	arg0.favorLvTF = arg0:findTF("anim_root/Text", arg0.favorBtn)
	arg0.favorMaxTF = arg0:findTF("anim_root/max", arg0.favorBtn)
	arg0.favorBtnAnim = arg0:findTF("anim_root", arg0.favorBtn):GetComponent(typeof(Animation))
	arg0.favorBtnAnimEvent = arg0:findTF("anim_root", arg0.favorBtn):GetComponent(typeof(DftAniEvent))

	arg0.favorBtnAnimEvent:SetTriggerEvent(function()
		arg0:updateFavorBtn()
	end)

	arg0.mainTF = arg0:findTF("anim_root/main")
	arg0.paintTF = arg0:findTF("painting", arg0.mainTF)
	arg0.dialogueTF = arg0:findTF("dialogue", arg0.blurPanel)
	arg0.dialogueContent = arg0:findTF("content", arg0.dialogueTF)

	setActive(arg0.dialogueTF, false)

	arg0.bubbleTF = arg0:findTF("anim_root/blur_panel/bubble")

	setActive(arg0.bubbleTF, false)

	arg0.bubbleBtn = arg0:findTF("bubble", arg0.bubbleTF)
	arg0.optionsTF = arg0:findTF("options", arg0.mainTF)
	arg0.chatBtn = arg0:findTF("options/chat", arg0.optionsTF)
	arg0.giftBtn = arg0:findTF("options/gift", arg0.optionsTF)

	setActive(arg0.optionsTF, false)

	arg0.bottomTF = arg0:findTF("bottom", arg0.blurPanel)
	arg0.bookBtn = arg0:findTF("left/btns/book", arg0.bottomTF)

	setText(arg0:findTF("unlock/Text", arg0.bookBtn), i18n("child_btn_collect"))

	arg0.mindBtn = arg0:findTF("left/btns/mind", arg0.bottomTF)

	setText(arg0:findTF("unlock/Text", arg0.mindBtn), i18n("child_btn_mind"))

	arg0.bagBtn = arg0:findTF("left/btns/bag", arg0.bottomTF)

	setText(arg0:findTF("unlock/Text", arg0.bagBtn), i18n("child_btn_bag"))

	arg0.datePanel = EducateDatePanel.New(arg0:findTF("date", arg0.topTF), arg0.event)
	arg0.favorPanel = EducateFavorPanel.New(arg0:findTF("favor_panel", arg0.topTF), arg0.event)
	arg0.resPanel = EducateResPanel.New(arg0:findTF("res", arg0.topTF), arg0.event)
	arg0.topPanel = EducateTopPanel.New(arg0:findTF("top_right", arg0.topTF), arg0.event)
	arg0.targetPanel = EducateTargetPanel.New(arg0:findTF("target", arg0.topTF), arg0.event)
	arg0.bottomPanel = EducateBottomPanel.New(arg0:findTF("right", arg0.bottomTF), arg0.event, {
		isMainEnter = arg0.contextData.isMainEnter
	})
	arg0.archivePanel = EducateArchivePanel.New(arg0:findTF("archive_panel", arg0.mainTF), arg0.event, {
		isShow = true,
		isMainEnter = arg0.contextData.isMainEnter
	})
end

function var0._loadSubViews(arg0)
	arg0.datePanel:Load()
	arg0.favorPanel:Load()
	arg0.resPanel:Load()
	arg0.topPanel:Load()
	arg0.targetPanel:Load()
	arg0.bottomPanel:Load()
	arg0.archivePanel:Load()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.blurPanel, {
		pbList = {
			arg0:findTF("bottom/left", arg0.blurPanel)
		},
		groupName = arg0:getGroupNameFromData()
	})

	local var0 = arg0.contextData.isMainEnter and "anim_educate_educateUI_bg_in" or "anim_educate_educateUI_bg_show"

	arg0.mainAnim:Play(var0)

	local var1 = arg0.contextData.isMainEnter and "anim_educate_educateUI_in" or "anim_educate_educateUI_show"

	arg0.blurPanelAnim:Play(var1)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.chatBtn, function()
		pg.TipsMgr.GetInstance():ShowTips("触发对话[待开发]...")
	end, SFX_PANEL)
	onButton(arg0, arg0.giftBtn, function()
		pg.TipsMgr.GetInstance():ShowTips("送礼(?)...")
	end, SFX_PANEL)
	onButton(arg0, arg0.favorBtn, function()
		arg0.favorPanel:Show()
	end, SFX_PANEL)
	onButton(arg0, arg0.bookBtn, function()
		arg0:emit(var0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateCollectEntranceMediator,
			viewComponent = EducateCollectEntranceLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0.mindBtn, function()
		if isActive(arg0:findTF("lock", arg0.mindBtn)) then
			return
		end

		arg0:emit(var0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateMindMediator,
			viewComponent = EducateMindLayer,
			data = {
				onExit = function()
					arg0:checkBubbleShow()
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0.bagBtn, function()
		if isActive(arg0:findTF("lock", arg0.bagBtn)) then
			return
		end

		arg0:emit(var0.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateBagMediator,
			viewComponent = EducateBagLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("fitter", arg0.paintTF), function()
		arg0:ShowDialogue()
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	if arg0.contextData.onEnter then
		arg0.contextData.onEnter()

		arg0.contextData.onEnter = nil
	end

	arg0:updatePaintingUI()
	arg0:updateUnlockBtns()
	arg0:updateNewTips()
	arg0:updateMindTip()
	arg0:updateFavorBtn()
	arg0:SeriesCheck()
end

function var0.SeriesCheck(arg0)
	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:CheckNewChar(arg0)
	end)
	table.insert(var0, function(arg0)
		if getProxy(EducateProxy):GetPlanProxy():CheckExcute() then
			arg0:emit(EducateMediator.ON_EXECTUE_PLANS)
		else
			arg0()
		end
	end)
	table.insert(var0, function(arg0)
		arg0:CheckTips(arg0)
	end)
	table.insert(var0, function(arg0)
		if getProxy(EducateProxy):GetEventProxy():NeedGetHomeEventData() then
			arg0:emit(EducateMediator.ON_GET_EVENT, arg0)
		else
			arg0()
		end
	end)
	arg0:checkBubbleShow()
	table.insert(var0, function(arg0)
		if not arg0.contextData.ingoreGuideCheck then
			EducateGuideSequence.CheckGuide(arg0.__cname, arg0)
		else
			arg0.contextData.ingoreGuideCheck = nil

			arg0()
		end
	end)
	seriesAsync(var0, function()
		return
	end)
end

function var0.OnCheckGuide(arg0)
	EducateGuideSequence.CheckGuide(arg0.__cname, function()
		return
	end)
end

function var0.CheckTips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(EducateTipHelper.GetSystemUnlockTips()) do
		table.insert(var0, function(arg0)
			arg0:emit(var0.EDUCATE_ON_UNLOCK_TIP, {
				type = EducateUnlockTipLayer.UNLOCK_TYPE_SYSTEM,
				single = iter1,
				onExit = arg0
			})
		end)
	end

	seriesAsync(var0, function()
		arg1()
	end)
end

function var0.CheckNewChar(arg0, arg1)
	if getProxy(EducateProxy):GetCharData():GetCallName() == "" then
		setActive(arg0._tf, false)

		local var0 = {}

		table.insert(var0, function(arg0)
			pg.PerformMgr.GetInstance():PlayGroup(EducateConst.FIRST_ENTER_PERFORM_IDS, arg0)
		end)
		table.insert(var0, function(arg0)
			arg0:emit(var0.EDUCATE_GO_SUBLAYER, Context.New({
				mediator = EducateNewCharMediator,
				viewComponent = EducateNewCharLayer,
				data = {
					callback = arg0
				}
			}))
		end)
		table.insert(var0, function(arg0)
			pg.PerformMgr.GetInstance():PlayOne(EducateConst.AFTER_SET_CALLNAME_PERFORM_ID, arg0)
		end)
		seriesAsync(var0, function()
			setActive(arg0._tf, true)
			arg0:_loadSubViews()
			arg1()
		end)
	else
		arg0:_loadSubViews()
		arg1()
	end
end

function var0.showBubble(arg0, arg1)
	setActive(arg0.bubbleTF, true)
	onButton(arg0, arg0.bubbleBtn, function()
		arg1()
		setActive(arg0.bubbleTF, false)
	end, SFX_PANEL)
end

function var0.PlayPerformWithDrops(arg0, arg1, arg2, arg3)
	local var0 = EducateHelper.GetDialogueShowDrops(arg2)
	local var1 = EducateHelper.GetCommonShowDrops(arg2)

	local function var2()
		if #var1 > 0 then
			arg0:emit(var0.EDUCATE_ON_AWARD, {
				items = var1,
				removeFunc = function()
					if arg3 then
						arg3()
					end
				end
			})
		elseif arg3 then
			arg3()
		end
	end

	if #arg1 > 0 then
		pg.PerformMgr.GetInstance():PlayGroup(arg1, var2, var0)
	elseif var2 then
		var2()
	end
end

function var0.ShowFavorUpgrade(arg0, arg1, arg2, arg3)
	arg0:PlayPerformWithDrops(arg2, arg1, function()
		if #arg1 > 0 then
			arg0:emit(var0.EDUCATE_ON_AWARD, {
				items = arg1,
				removeFunc = function()
					arg0.favorBtnAnim:Play("anim_educate_favor_levelup")

					if arg3 then
						arg3()
					end
				end
			})
		else
			arg0.favorBtnAnim:Play("anim_educate_favor_levelup")

			if arg3 then
				arg3()
			end
		end
	end)
end

function var0.ShowSpecialEvent(arg0, arg1, arg2, arg3)
	local var0 = pg.child_event_special[arg1].performance

	arg0:PlayPerformWithDrops(var0, arg2, function()
		if #arg2 > 0 then
			arg0:emit(var0.EDUCATE_ON_AWARD, {
				items = arg2,
				removeFunc = function()
					if arg3 then
						arg3()
					end
				end
			})
		elseif arg3 then
			arg3()
		end
	end)
end

function var0.checkBubbleShow(arg0)
	local var0 = getProxy(EducateProxy):GetEventProxy():GetHomeSpecEvents()
	local var1 = getProxy(EducateProxy):GetCharData()

	if #var0 > 0 then
		setActive(arg0:findTF("Text", arg0.bubbleBtn), true)
		setActive(arg0:findTF("Image", arg0.bubbleBtn), false)
		arg0:showBubble(function()
			arg0:emit(EducateMediator.ON_SPECIAL_EVENT_TRIGGER, {
				id = var0[1].id,
				callback = function()
					arg0:checkBubbleShow()
					EducateGuideSequence.CheckGuide(arg0.__cname, function()
						return
					end)
				end
			})
		end)
	elseif var1:CheckFavor() then
		setActive(arg0:findTF("Text", arg0.bubbleBtn), false)
		setActive(arg0:findTF("Image", arg0.bubbleBtn), true)
		arg0:showBubble(function()
			arg0:emit(EducateMediator.ON_UPGRADE_FAVOR, function()
				arg0:checkBubbleShow()
				EducateGuideSequence.CheckGuide(arg0.__cname, function()
					return
				end)
			end)
		end)
	else
		setActive(arg0.bubbleTF, false)
		removeOnButton(arg0.bubbleTF)
	end
end

function var0.updateResPanel(arg0)
	arg0.resPanel:Flush()
end

function var0.updateArchivePanel(arg0)
	arg0.archivePanel:Flush()
end

function var0.showArchivePanel(arg0)
	arg0.archivePanel:showPanel()
end

function var0.updateDatePanel(arg0)
	arg0.datePanel:Flush()
	arg0:updateUnlockBtns()
end

function var0.updateUnlockBtns(arg0)
	local var0 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_MEMORY)

	setActive(arg0:findTF("lock", arg0.bookBtn), not var0)
	setActive(arg0:findTF("unlock", arg0.bookBtn), var0)

	local var1 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_BAG)

	setActive(arg0:findTF("lock", arg0.bagBtn), not var1)
	setActive(arg0:findTF("unlock", arg0.bagBtn), var1)

	local var2 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_FAVOR_AND_MIND)

	setActive(arg0:findTF("lock", arg0.mindBtn), not var2)
	setActive(arg0:findTF("unlock", arg0.mindBtn), var2)
	setActive(arg0.favorBtn, var2)
end

function var0.updateMindTip(arg0)
	setActive(arg0:findTF("unlock/tip", arg0.mindBtn), getProxy(EducateProxy):GetTaskProxy():IsShowMindTasksTip())
end

function var0.updateWeekDay(arg0, arg1)
	arg0.datePanel:UpdateWeekDay(arg1)
end

function var0.updateFavorBtn(arg0)
	local var0 = getProxy(EducateProxy):GetCharData()
	local var1 = var0:GetFavor()

	setText(arg0.favorLvTF, var1.lv)

	local var2 = var0:GetFavorMaxLv()

	setActive(arg0.favorMaxTF, var1.lv == var2)
end

function var0.updateTargetPanel(arg0)
	arg0.targetPanel:Flush()
end

function var0.updateBottomPanel(arg0)
	arg0.bottomPanel:Flush()
end

function var0.updatePaintingUI(arg0)
	local var0 = getProxy(EducateProxy):GetCharData()

	arg0.bgName = var0:GetBGName()
	arg0.paintingName = var0:GetPaintingName()
	arg0.wordList, arg0.faceList = var0:GetMainDialogueInfo()

	local var1 = LoadSprite("bg/" .. arg0.bgName)

	setImageSprite(arg0.bgTF, var1, false)
	setPaintingPrefab(arg0.paintTF, arg0.paintingName, "yangcheng")
end

function var0.ShowDialogue(arg0)
	if LeanTween.isTweening(arg0.dialogueTF) then
		return
	end

	local var0 = math.random(#arg0.wordList)
	local var1 = pg.child_word[arg0.wordList[var0]].word

	if not arg0.callName then
		arg0.callName = getProxy(EducateProxy):GetCharData():GetCallName()
	end

	local var2 = string.gsub(var1, "$1", arg0.callName)

	setText(arg0.dialogueContent, var2)

	local var3 = GetSpriteFromAtlas("paintingface/" .. arg0.paintingName, arg0.faceList[var0])
	local var4 = arg0:findTF("fitter", arg0.paintTF):GetChild(0):Find("face")

	if var4 and var3 then
		setImageSprite(var4, var3)
		setActive(var4, true)
	end

	arg0.dialogueTF.localScale = Vector3.zero

	setActive(arg0.dialogueTF, true)
	LeanTween.scale(arg0.dialogueTF, Vector3.one, 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(arg0.dialogueTF, Vector3.zero, 0.3):setEase(LeanTweenType.easeInBack):setDelay(3):setOnComplete(System.Action(function()
			setActive(arg0.dialogueTF, false)

			if var4 then
				setActive(var4, false)
			end
		end))
	end))
end

function var0.updateNewTips(arg0)
	arg0:updateBookNewTip()
	arg0:updateMindNewTip()
end

function var0.updateBookNewTip(arg0)
	local var0 = underscore.any(pg.child_memory.all, function(arg0)
		return EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MEMORY, arg0)
	end)
	local var1 = EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_POLAROID)

	setActive(arg0:findTF("unlock/new", arg0.bookBtn), var0 or var1)
end

function var0.updateMindNewTip(arg0)
	setActive(arg0:findTF("unlock/new", arg0.mindBtn), EducateTipHelper.IsShowNewTip(EducateTipHelper.NEW_MIND_TASK))
end

function var0.FlushView(arg0)
	arg0.datePanel:Flush()
	arg0.favorPanel:Flush()
	arg0.resPanel:Flush()
	arg0.targetPanel:Flush()
	arg0.bottomPanel:Flush()
	arg0.archivePanel:Flush()
	arg0:updatePaintingUI()
	arg0:updateUnlockBtns()
	arg0:updateNewTips()
	arg0:updateMindTip()
	arg0:updateFavorBtn()
	arg0:SeriesCheck()
end

function var0.onBackPressed(arg0)
	arg0:emit(EducateBaseUI.ON_HOME)
end

function var0.willExit(arg0)
	arg0.contextData.isMainEnter = nil

	arg0.datePanel:Destroy()

	arg0.datePanel = nil

	arg0.favorPanel:Destroy()

	arg0.favorPanel = nil

	arg0.resPanel:Destroy()

	arg0.resPanel = nil

	arg0.topPanel:Destroy()

	arg0.topPanel = nil

	arg0.targetPanel:Destroy()

	arg0.targetPanel = nil

	arg0.bottomPanel:Destroy()

	arg0.bottomPanel = nil

	arg0.archivePanel:Destroy()

	arg0.archivePanel = nil

	if LeanTween.isTweening(arg0.dialogueTF) then
		LeanTween.cancel(arg0.dialogueTF)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
end

return var0
