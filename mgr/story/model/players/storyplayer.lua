local var0_0 = class("StoryPlayer", import("..animation.StoryAnimtion"))
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4
local var6_0 = 5
local var7_0 = 6
local var8_0 = 7
local var9_0 = 0
local var10_0 = 1
local var11_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.animationPlayer = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1.front = arg0_1._tf:Find("front")
	arg0_1.actorTr = arg0_1._tf:Find("actor")
	arg0_1.frontTr = arg0_1._tf:Find("front")
	arg0_1.backPanel = arg0_1._tf:Find("back")
	arg0_1.goCG = GetOrAddComponent(arg0_1._tf, typeof(CanvasGroup))
	arg0_1.asidePanel = arg0_1._tf:Find("front/aside_panel")
	arg0_1.bgGlitch = arg0_1._tf:Find("back/bg_glitch")
	arg0_1.oldPhoto = arg0_1._tf:Find("front/oldphoto"):GetComponent(typeof(Image))
	arg0_1.bgPanel = arg0_1._tf:Find("back/bg")
	arg0_1.bgPanelCg = arg0_1.bgPanel:GetComponent(typeof(CanvasGroup))

	setActive(arg0_1._tf:Find("back/bg/sub"), false)

	arg0_1.bgImage = arg0_1.bgPanel:Find("image"):GetComponent(typeof(Image))
	arg0_1.mainImg = arg0_1._tf:GetComponent(typeof(Image))
	arg0_1.castPanel = arg0_1._tf:Find("front/cast_panel")
	arg0_1.spAnimPanel = arg0_1._tf:Find("front/sp_anim_panel")
	arg0_1.centerPanel = arg0_1._tf:Find("center")
	arg0_1.actorPanel = arg0_1._tf:Find("actor")
	arg0_1.dialoguePanel = arg0_1._tf:Find("front/dialogue")
	arg0_1.effectPanel = arg0_1._tf:Find("front/effect")
	arg0_1.movePanel = arg0_1._tf:Find("front/move_layer")
	arg0_1.curtain = arg0_1._tf:Find("back/curtain")
	arg0_1.curtainCg = arg0_1.curtain:GetComponent(typeof(CanvasGroup))
	arg0_1.flash = arg0_1._tf:Find("front/flash")
	arg0_1.flashImg = arg0_1.flash:GetComponent(typeof(Image))
	arg0_1.flashCg = arg0_1.flash:GetComponent(typeof(CanvasGroup))
	arg0_1.curtainF = arg0_1._tf:Find("back/curtain_front")
	arg0_1.curtainFCg = arg0_1.curtainF:GetComponent(typeof(CanvasGroup))
	arg0_1.locationTr = arg0_1._tf:Find("front/location")
	arg0_1.locationTxt = arg0_1._tf:Find("front/location/Text"):GetComponent(typeof(Text))
	arg0_1.locationTrPos = arg0_1.locationTr.localPosition
	arg0_1.locationAnim = arg0_1.locationTr:GetComponent(typeof(Animation))
	arg0_1.locationAniEvent = arg0_1.locationTr:GetComponent(typeof(DftAniEvent))
	arg0_1.iconImage = arg0_1._tf:Find("front/icon"):GetComponent(typeof(Image))
	arg0_1.topEffectTr = arg0_1._tf:Find("top/effect")
	arg0_1.dialogueWin = nil
	arg0_1.bgs = {}
	arg0_1.branchCodeList = {}
	arg0_1.stop = false
	arg0_1.pause = false
end

function var0_0.Disable(arg0_2)
	setActive(arg0_2._tf, false)
end

function var0_0.Enable(arg0_3)
	setActive(arg0_3._tf, true)
end

function var0_0.StoryStart(arg0_4, arg1_4)
	arg0_4.branchCodeList = {}

	eachChild(arg0_4.dialoguePanel, function(arg0_5)
		setActive(arg0_5, false)
	end)

	arg0_4.dialogueWin = arg0_4.dialoguePanel:Find(arg1_4:GetDialogueStyleName())

	setActive(arg0_4.dialogueWin, true)

	arg0_4.optionLUIlist = UIItemList.New(arg0_4.dialogueWin:Find("options_panel/options_l"), arg0_4.dialogueWin:Find("options_panel/options_l/option_tpl"))
	arg0_4.optionCUIlist = UIItemList.New(arg0_4.dialogueWin:Find("options_panel/options_c"), arg0_4.dialogueWin:Find("options_panel/options_c/option_tpl"))
	arg0_4.optionsCg = arg0_4.dialogueWin:Find("options_panel"):GetComponent(typeof(CanvasGroup))

	arg0_4:OnStart(arg1_4)
end

function var0_0.GetOptionContainer(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetOptionCnt()

	if arg0_6.script:IsDialogueStyle2() then
		setActive(arg0_6.optionLUIlist.container, true)
		setActive(arg0_6.optionCUIlist.container, false)

		return arg0_6.optionLUIlist, true
	end

	if var0_6 <= 3 then
		setActive(arg0_6.optionLUIlist.container, false)
		setActive(arg0_6.optionCUIlist.container, true)

		return arg0_6.optionCUIlist, false
	else
		setActive(arg0_6.optionLUIlist.container, true)
		setActive(arg0_6.optionCUIlist.container, false)

		return arg0_6.optionLUIlist, true
	end
end

function var0_0.Pause(arg0_7)
	arg0_7.pause = true

	arg0_7:PauseAllAnimation()
	pg.ViewUtils.SetLayer(arg0_7.effectPanel, Layer.UIHidden)
end

function var0_0.Resume(arg0_8)
	arg0_8.pause = false

	arg0_8:ResumeAllAnimation()
	pg.ViewUtils.SetLayer(arg0_8.effectPanel, Layer.UI)
end

function var0_0.Stop(arg0_9)
	arg0_9.stop = true

	arg0_9:NextOneImmediately()
end

function var0_0.Play(arg0_10, arg1_10, arg2_10, arg3_10)
	if not arg1_10 then
		arg3_10()

		return
	end

	if arg1_10:GetNextScriptName() or arg0_10.stop then
		arg3_10()

		return
	end

	local var0_10 = arg1_10:GetStepByIndex(arg2_10)

	if not var0_10 then
		arg3_10()

		return
	end

	pg.NewStoryMgr.GetInstance():AddRecord(var0_10)

	if var0_10:ShouldJumpToNextScript() then
		arg1_10:SetNextScriptName(var0_10:GetNextScriptName())
		arg3_10()

		return
	end

	local var1_10 = arg1_10:ShouldSkipAll()

	if var1_10 then
		arg0_10:ClearEffects()
	end

	local var2_10 = false

	if var1_10 and var0_10:IsImport() and not pg.NewStoryMgr.GetInstance():IsReView() then
		var2_10 = true
	elseif var1_10 then
		arg3_10()

		return
	end

	arg0_10.script = arg1_10
	arg0_10.callback = arg3_10
	arg0_10.step = var0_10
	arg0_10.autoNext = arg1_10:GetAutoPlayFlag()
	arg0_10.stage = var1_0

	local var3_10 = arg1_10:GetTriggerDelayTime()

	if arg0_10.autoNext and var0_10:IsImport() and not var0_10.optionSelCode then
		arg0_10.autoNext = nil
	end

	arg0_10:SetTimeScale(1 - arg1_10:GetPlaySpeed() * 0.1)

	local var4_10 = arg1_10:GetPrevStep(arg2_10)

	seriesAsync({
		function(arg0_11)
			if not arg0_10:NextStage(var2_0) then
				return
			end

			parallelAsync({
				function(arg0_12)
					arg0_10:Reset(var0_10, var4_10, arg0_12)
					arg0_10:UpdateBg(var0_10)
					arg0_10:PlayBgm(var0_10)
				end,
				function(arg0_13)
					arg0_10:LoadEffects(var0_10, arg0_13)
				end,
				function(arg0_14)
					arg0_10:ApplyEffects(var0_10, arg0_14)
				end,
				function(arg0_15)
					arg0_10:flashin(var0_10, arg0_15)
				end
			}, arg0_11)
		end,
		function(arg0_16)
			if var2_10 then
				arg1_10:StopSkip()
			end

			var2_10 = false

			arg0_16()
		end,
		function(arg0_17)
			if not arg0_10:NextStage(var3_0) then
				return
			end

			parallelAsync({
				function(arg0_18)
					arg0_10:OnInit(var0_10, var4_10, arg0_18)
				end,
				function(arg0_19)
					arg0_10:PlaySoundEffect(var0_10)
					arg0_10:StartUIAnimations(var0_10, arg0_19)
				end,
				function(arg0_20)
					arg0_10:OnEnter(var0_10, var4_10, arg0_20)
				end,
				function(arg0_21)
					arg0_10:StartMoveNode(var0_10, arg0_21)
				end,
				function(arg0_22)
					arg0_10:UpdateIcon(var0_10, arg0_22)
				end,
				function(arg0_23)
					arg0_10:SetLocation(var0_10, arg0_23)
				end,
				function(arg0_24)
					if arg0_10:DispatcherEvent(var0_10, arg0_24) then
						arg0_10.autoNext = true
						var3_10 = 0
					end
				end
			}, arg0_17)
		end,
		function(arg0_25)
			arg0_10:ClearCheckDispatcher()

			if not arg0_10:NextStage(var4_0) then
				return
			end

			if not var0_10:ShouldDelayEvent() then
				arg0_25()

				return
			end

			arg0_10:DelayCall(var0_10:GetEventDelayTime(), arg0_25)
		end,
		function(arg0_26)
			if not arg0_10:NextStage(var5_0) then
				return
			end

			if arg0_10.skipOption then
				arg0_26()

				return
			end

			if var0_10:SkipEventForOption() then
				arg0_26()

				return
			end

			if arg0_10:ShouldAutoTrigger() then
				arg0_10:UnscaleDelayCall(var3_10, arg0_26)

				return
			end

			arg0_10:RegisetEvent(var0_10, arg0_26)
			arg0_10:TriggerEventIfAuto(var3_10)
		end,
		function(arg0_27)
			if not arg0_10:NextStage(var6_0) then
				return
			end

			if not var0_10:ExistOption() then
				arg0_27()

				return
			end

			if arg0_10.skipOption then
				arg0_10.skipOption = false

				arg0_27()

				return
			end

			arg0_10:InitBranches(arg1_10, var0_10, function(arg0_28)
				arg0_27()
			end, function()
				arg0_10:TriggerOptionIfAuto(var3_10, var0_10)
			end)
		end,
		function(arg0_30)
			if not arg0_10:NextStage(var7_0) then
				return
			end

			arg0_10.autoNext = nil

			local var0_30 = arg1_10:GetNextStep(arg2_10)

			seriesAsync({
				function(arg0_31)
					arg0_10:ClearAnimation()
					arg0_10:ClearApplyEffect()
					arg0_10:OnWillExit(var0_10, var0_30, arg0_31)
				end,
				function(arg0_32)
					parallelAsync({
						function(arg0_33)
							if not var0_30 then
								arg0_33()

								return
							end

							arg0_10:Flashout(var0_30, arg0_33)
						end,
						function(arg0_34)
							if var0_30 then
								arg0_34()

								return
							end

							arg0_10:FadeOutStory(arg0_10.script, arg0_34)
						end
					}, arg0_32)
				end
			}, arg0_30)
		end,
		function(arg0_35)
			if not arg0_10:NextStage(var8_0) then
				return
			end

			arg0_10:OnWillClear(var0_10)
			arg0_10:Clear(arg0_35)
		end
	}, arg3_10)
end

function var0_0.NextStage(arg0_36, arg1_36)
	if arg0_36.stage == arg1_36 - 1 then
		arg0_36.stage = arg1_36

		return true
	end

	return false
end

function var0_0.ApplyEffects(arg0_37, arg1_37, arg2_37)
	if arg1_37:ShouldShake() then
		arg0_37:ApplyShakeEffect(arg1_37)
	end

	arg2_37()
end

function var0_0.ApplyShakeEffect(arg0_38, arg1_38)
	if not arg1_38:ShouldShake() then
		return
	end

	arg0_38.animationPlayer:Play("anim_storyrecordUI_shake_loop")

	local var0_38 = arg1_38:GetShakeTime()

	arg0_38.playingShakeAnim = true

	arg0_38:DelayCall(var0_38, function()
		arg0_38:ClearShakeEffect()
	end)
end

function var0_0.ClearShakeEffect(arg0_40)
	if arg0_40.playingShakeAnim then
		arg0_40.animationPlayer:Play("anim_storyrecordUI_shake_reset")

		arg0_40.playingShakeAnim = nil
	end
end

function var0_0.ClearApplyEffect(arg0_41)
	arg0_41:ClearShakeEffect()
end

function var0_0.DispatcherEvent(arg0_42, arg1_42, arg2_42)
	if not arg1_42:ExistDispatcher() then
		arg2_42()

		return
	end

	local var0_42 = arg1_42:GetDispatcher()

	pg.NewStoryMgr.GetInstance():ClearStoryEvent()
	pg.m02:sendNotification(var0_42.name, {
		data = var0_42.data,
		callbackData = var0_42.callbackData,
		flags = arg0_42.branchCodeList[arg1_42:GetId()] or {}
	})

	if arg1_42:ShouldHideUI() then
		setActive(arg0_42._tf, false)
	end

	if arg1_42:IsRecallDispatcher() then
		arg0_42:CheckDispatcher(arg1_42, arg2_42)
	else
		arg2_42()
	end

	return var0_42.nextOne
end

function var0_0.WaitForEvent(arg0_43)
	return arg0_43.checkTimer ~= nil
end

function var0_0.CheckDispatcher(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg1_44:GetDispatcherRecallName()

	arg0_44:ClearCheckDispatcher()

	arg0_44.checkTimer = Timer.New(function()
		if pg.NewStoryMgr.GetInstance():CheckStoryEvent(var0_44) then
			local var0_45 = pg.NewStoryMgr.GetInstance():GetStoryEventArg(var0_44)

			if var0_45 then
				existCall(var0_45.notifiCallback)
			end

			if var0_45 and var0_45.optionIndex then
				arg0_44:SetBranchCode(arg0_44.script, arg1_44, var0_45.optionIndex)

				arg0_44.skipOption = true
			end

			if arg1_44:ShouldHideUI() then
				setActive(arg0_44._tf, true)
			end

			arg0_44:ClearCheckDispatcher()
			arg2_44()
		end
	end, 1, -1)

	arg0_44.checkTimer:Start()
	arg0_44.checkTimer.func()
end

function var0_0.ClearCheckDispatcher(arg0_46)
	if arg0_46.checkTimer then
		arg0_46.checkTimer:Stop()

		arg0_46.checkTimer = nil
	end
end

function var0_0.TriggerEventIfAuto(arg0_47, arg1_47)
	if not arg0_47:ShouldAutoTrigger() then
		return
	end

	arg0_47:UnscaleDelayCall(arg1_47, function()
		if not arg0_47.autoNext then
			setButtonEnabled(arg0_47._go, true)

			return
		end

		triggerButton(arg0_47._go)
	end)
end

function var0_0.TriggerOptionIfAuto(arg0_49, arg1_49, arg2_49)
	if not arg0_49:ShouldAutoTrigger() then
		return
	end

	if not arg2_49 or not arg2_49:ExistOption() then
		return
	end

	arg0_49:UnscaleDelayCall(arg1_49, function()
		if not arg0_49.autoNext then
			return
		end

		local var0_50 = arg2_49:GetOptionIndexByAutoSel()

		if var0_50 ~= nil then
			local var1_50 = arg0_49:GetOptionContainer(arg2_49).container:GetChild(var0_50 - 1)

			triggerButton(var1_50)
		end
	end)
end

function var0_0.ShouldAutoTrigger(arg0_51)
	if arg0_51.pause or arg0_51.stop then
		return false
	end

	return arg0_51.autoNext
end

function var0_0.CanSkip(arg0_52)
	return arg0_52.step and not arg0_52.step:IsImport()
end

function var0_0.CancelAuto(arg0_53)
	arg0_53.autoNext = false
end

function var0_0.NextOne(arg0_54)
	arg0_54.timeScale = 0.0001

	if arg0_54.stage == var1_0 then
		arg0_54.autoNext = true
	elseif arg0_54.stage == var5_0 then
		arg0_54.autoNext = true

		arg0_54:TriggerEventIfAuto(0)
	elseif arg0_54.stage == var6_0 then
		arg0_54:TriggerOptionIfAuto(0, arg0_54.step)
	end
end

function var0_0.NextOneImmediately(arg0_55)
	local var0_55 = arg0_55.callback

	if var0_55 then
		arg0_55:ClearAnimation()
		arg0_55:Clear()
		var0_55()
	end
end

function var0_0.SetLocation(arg0_56, arg1_56, arg2_56)
	if not arg1_56:ExistLocation() then
		arg0_56.locationAniEvent:SetEndEvent(nil)
		arg2_56()

		return
	end

	setActive(arg0_56.locationTr, true)

	local var0_56 = arg1_56:GetLocation()

	arg0_56.locationTxt.text = var0_56.text

	local function var1_56()
		arg0_56:DelayCall(var0_56.time, function()
			arg0_56.locationAnim:Play("anim_newstoryUI_iocation_out")

			arg0_56.locationStatus = var11_0
		end)
	end

	arg0_56.locationAniEvent:SetEndEvent(function()
		if arg0_56.locationStatus == var10_0 then
			var1_56()
			arg2_56()
		elseif arg0_56.locationStatus == var11_0 then
			setActive(arg0_56.locationTr, false)

			arg0_56.locationStatus = var9_0
		end
	end)
	arg0_56.locationAnim:Play("anim_newstoryUI_iocation_in")

	arg0_56.locationStatus = var10_0
end

function var0_0.UpdateIcon(arg0_60, arg1_60, arg2_60)
	if not arg1_60:ExistIcon() then
		setActive(arg0_60.iconImage.gameObject, false)
		arg2_60()

		return
	end

	local var0_60 = arg1_60:GetIconData()

	arg0_60.iconImage.sprite = LoadSprite(var0_60.image)

	arg0_60.iconImage:SetNativeSize()

	local var1_60 = arg0_60.iconImage.gameObject.transform

	if var0_60.pos then
		var1_60.localPosition = Vector3(var0_60.pos[1], var0_60.pos[2], 0)
	else
		var1_60.localPosition = Vector3.one
	end

	var1_60.localScale = Vector3(var0_60.scale or 1, var0_60.scale or 1, 1)

	setActive(arg0_60.iconImage.gameObject, true)
	arg2_60()
end

function var0_0.UpdateOptionTxt(arg0_61, arg1_61, arg2_61, arg3_61, arg4_61)
	local var0_61 = arg2_61:GetComponent(typeof(LayoutElement))
	local var1_61 = arg2_61:Find("content")

	if arg1_61 then
		local var2_61 = GetPerceptualSize(arg3_61)
		local var3_61 = arg2_61:Find("content_max")
		local var4_61 = var2_61 >= 17
		local var5_61 = var4_61 and var3_61 or var1_61

		setActive(var1_61, not var4_61)
		setActive(var3_61, var4_61)
		setText(var5_61:Find("Text"), arg3_61)

		var0_61.preferredHeight = var5_61.rect.height
	else
		setText(var1_61:Find("Text"), arg3_61)

		var0_61.preferredHeight = var1_61.rect.height
	end

	arg0_61:UpdateOptionBGWithTB(var1_61, arg4_61)
end

function var0_0.UpdateOptionBGWithTB(arg0_62, arg1_62, arg2_62)
	local var0_62 = getProxy(NewEducateProxy):GetCurChar()
	local var1_62 = arg1_62:Find("type1")
	local var2_62 = arg1_62:Find("type2")

	if var1_62 then
		setActive(var1_62, false)
	end

	if var2_62 then
		setActive(var2_62, false)
	end

	if var0_62 and var1_62 then
		local var3_62 = arg2_62 and arg2_62 == 1

		if var3_62 then
			local var4_62 = var0_62:GetPersonalityTagOptionBg(arg2_62)

			LoadImageSpriteAsync("neweducateicon/" .. var4_62, var1_62)
		end

		setActive(var1_62, var3_62)
	end

	if var0_62 and var2_62 then
		local var5_62 = arg2_62 and arg2_62 == 2

		if var5_62 then
			local var6_62 = var0_62:GetPersonalityTagOptionBg(arg2_62)

			LoadImageSpriteAsync("neweducateicon/" .. var6_62, var2_62)
		end

		setActive(var2_62, var5_62)
	end
end

function var0_0.InitBranches(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63)
	local var0_63 = false
	local var1_63 = arg2_63:GetOptions()
	local var2_63, var3_63 = arg0_63:GetOptionContainer(arg2_63)
	local var4_63 = arg2_63:GetId()
	local var5_63 = arg0_63.branchCodeList[var4_63] or {}
	local var6_63 = GetOrAddComponent(var2_63.container, typeof(CanvasGroup))

	var6_63.blocksRaycasts = true
	arg0_63.selectedBranchID = nil

	var2_63:make(function(arg0_64, arg1_64, arg2_64)
		if arg0_64 == UIItemList.EventUpdate then
			local var0_64 = arg2_64
			local var1_64 = var1_63[arg1_64 + 1][1]
			local var2_64 = var1_63[arg1_64 + 1][2]
			local var3_64 = var1_63[arg1_64 + 1][3]
			local var4_64 = table.contains(var5_63, var2_64)

			onButton(arg0_63, var0_64, function()
				if arg0_63.pause or arg0_63.stop then
					return
				end

				if not var0_63 then
					return
				end

				arg0_63.selectedBranchID = arg1_64

				arg0_63:SetBranchCode(arg1_63, arg2_63, var2_64)
				pg.NewStoryMgr.GetInstance():TrackingOption(arg2_63:GetOptionIndex(), var2_64)

				local var0_65 = arg2_64:GetComponent(typeof(Animation))

				if var0_65 then
					var6_63.blocksRaycasts = false

					var0_65:Play(arg0_63.script:GetAnimPrefix() .. "confirm")
					arg2_64:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						setActive(arg0_63.optionsCg.gameObject, false)

						var6_63.blocksRaycasts = true

						arg3_63(var1_64)
					end)
				else
					setActive(arg0_63.optionsCg.gameObject, false)
					arg3_63(var1_64)
				end

				arg0_63:HideBranchesWithoutSelected(arg2_63)
			end, SFX_PANEL)
			setButtonEnabled(var0_64, not var4_64)

			GetOrAddComponent(arg2_64, typeof(CanvasGroup)).alpha = var4_64 and 0.5 or 1

			arg0_63:UpdateOptionTxt(var3_63, var0_64, var1_64, var3_64)

			if arg0_63.script:IsDialogueStyle2() then
				setActive(var0_64, arg1_64 == 0)

				if arg1_64 > 0 then
					LeanTween.delayedCall(0.066 * arg1_64, System.Action(function()
						setActive(var0_64, true)
					end))
				end
			end
		end
	end)
	var2_63:align(#var1_63)
	arg0_63:ShowBranches(arg2_63, function()
		var0_63 = true

		if arg4_63 then
			arg4_63()
		end
	end)
end

function var0_0.SetBranchCode(arg0_69, arg1_69, arg2_69, arg3_69)
	arg2_69:SetBranchCode(arg3_69)
	arg1_69:SetBranchCode(arg3_69)

	local var0_69 = arg2_69:GetId()

	if not arg0_69.branchCodeList[var0_69] then
		arg0_69.branchCodeList[var0_69] = {}
	end

	table.insert(arg0_69.branchCodeList[var0_69], arg3_69)
end

function var0_0.ShowBranches(arg0_70, arg1_70, arg2_70)
	setActive(arg0_70.optionsCg.gameObject, true)

	local var0_70 = arg0_70:GetOptionContainer(arg1_70)

	for iter0_70 = 0, var0_70.container.childCount - 1 do
		local var1_70 = var0_70.container:GetChild(iter0_70):GetComponent(typeof(Animation))

		if var1_70 then
			var1_70:Play(arg0_70.script:GetAnimPrefix() .. "in")
		end
	end

	arg2_70()
end

function var0_0.HideBranchesWithoutSelected(arg0_71, arg1_71)
	local var0_71 = arg0_71:GetOptionContainer(arg1_71)

	for iter0_71 = 0, var0_71.container.childCount - 1 do
		if iter0_71 ~= arg0_71.selectedBranchID then
			local var1_71 = var0_71.container:GetChild(iter0_71):GetComponent(typeof(Animation))

			if var1_71 then
				var1_71:Play(arg0_71.script:GetAnimPrefix() .. "unselected")
			end
		end
	end
end

function var0_0.StartMoveNode(arg0_72, arg1_72, arg2_72)
	if not arg1_72:ExistMovableNode() then
		arg2_72()

		return
	end

	local var0_72 = arg1_72:GetMovableNode()
	local var1_72 = {}
	local var2_72 = {}

	for iter0_72, iter1_72 in pairs(var0_72) do
		table.insert(var1_72, function(arg0_73)
			arg0_72:LoadMovableNode(iter1_72, function(arg0_74)
				var2_72[iter0_72] = arg0_74

				arg0_73()
			end)
		end)
	end

	parallelAsync(var1_72, function()
		arg0_72:MoveAllNode(arg1_72, var2_72, var0_72)
		arg2_72()
	end)
end

function var0_0.MoveAllNode(arg0_76, arg1_76, arg2_76, arg3_76)
	local var0_76 = {}

	for iter0_76, iter1_76 in pairs(arg2_76) do
		table.insert(var0_76, function(arg0_77)
			local var0_77 = arg3_76[iter0_76]
			local var1_77 = var0_77.path
			local var2_77 = var0_77.time
			local var3_77 = var0_77.easeType
			local var4_77 = var0_77.delay

			arg0_76:moveLocalPath(iter1_76, var1_77, var2_77, var4_77, var3_77, arg0_77)
		end)
	end

	arg0_76.moveTargets = arg2_76

	parallelAsync(var0_76, function()
		arg0_76:ClearMoveNodes(arg1_76)
	end)
end

local function var12_0(arg0_79, arg1_79, arg2_79, arg3_79, arg4_79)
	arg0_79.spineChar = SpineAnimChar.New()

	arg0_79.spineChar:SetPaint(arg1_79)
	arg0_79.spineChar:Load(true, function(arg0_80)
		arg0_80:SetParent(arg0_79.movePanel)
		arg0_80:SetLocalScale(Vector3(arg2_79.scale, arg2_79.scale, 0))
		arg0_80:SetLocalPosition(arg3_79)
		arg0_80:SetAction(arg2_79.action, 0)
		arg0_80:SetName(arg1_79)

		if arg4_79 then
			arg4_79(arg0_79.spineChar:GetModel())
		end
	end)
end

local function var13_0(arg0_81, arg1_81, arg2_81, arg3_81)
	local var0_81 = GameObject.New("movable")

	var0_81.transform:SetParent(arg0_81.movePanel)

	var0_81.transform.localScale = Vector3.zero

	local var1_81 = GetOrAddComponent(var0_81, typeof(RectTransform))
	local var2_81 = GetOrAddComponent(var0_81, typeof(Image))

	LoadSpriteAsync(arg1_81, function(arg0_82)
		var2_81.sprite = arg0_82

		var2_81:SetNativeSize()

		var1_81.localScale = Vector3.one
		var1_81.localPosition = arg2_81

		arg3_81(var1_81.gameObject)
	end)
end

function var0_0.LoadMovableNode(arg0_83, arg1_83, arg2_83)
	local var0_83 = arg1_83.path[1] or Vector3.zero

	if arg1_83.isSpine then
		var12_0(arg0_83, arg1_83.name, arg1_83.spineData, var0_83, arg2_83)
	else
		var13_0(arg0_83, arg1_83.name, var0_83, arg2_83)
	end
end

function var0_0.ClearMoveNodes(arg0_84, arg1_84)
	if not arg1_84:ExistMovableNode() then
		return
	end

	if arg0_84.movePanel.childCount <= 0 then
		return
	end

	for iter0_84, iter1_84 in ipairs(arg0_84.moveTargets or {}) do
		if iter1_84:GetComponent(typeof(SpineAnimUI)) ~= nil then
			PoolMgr.GetInstance():ReturnSpineChar(iter1_84.name, iter1_84.gameObject)
		else
			Destroy(arg0_84.movePanel:GetChild(iter0_84 - 1))
		end
	end

	arg0_84.moveTargets = {}
end

function var0_0.FadeOutStory(arg0_85, arg1_85, arg2_85)
	if not arg1_85:ShouldFadeout() then
		arg2_85()

		return
	end

	local var0_85 = arg1_85:GetFadeoutTime()

	if not arg1_85:ShouldWaitFadeout() then
		arg0_85:fadeTransform(arg0_85._go, 1, 0.3, var0_85, true)
		arg2_85()
	else
		arg0_85:fadeTransform(arg0_85._go, 1, 0.3, var0_85, true, arg2_85)
	end
end

function var0_0.GetFadeColor(arg0_86, arg1_86)
	local var0_86 = {}
	local var1_86 = {}
	local var2_86 = arg1_86:GetComponentsInChildren(typeof(Image)):ToTable()

	for iter0_86, iter1_86 in ipairs(var2_86) do
		local var3_86 = {
			name = "_Color",
			color = Color.white
		}

		if iter1_86.material.shader.name == "UI/GrayScale" then
			var3_86 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif iter1_86.material.shader.name == "UI/Line_Add_Blue" then
			var3_86 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_86, var3_86)

		if iter1_86.material == iter1_86.defaultGraphicMaterial then
			iter1_86.material = Material.Instantiate(iter1_86.defaultGraphicMaterial)
		end

		table.insert(var0_86, iter1_86.material)
	end

	return var0_86, var1_86
end

function var0_0._SetFadeColor(arg0_87, arg1_87, arg2_87, arg3_87)
	for iter0_87, iter1_87 in ipairs(arg1_87) do
		if not IsNil(iter1_87) then
			iter1_87:SetColor(arg2_87[iter0_87].name, arg2_87[iter0_87].color * Color.New(arg3_87, arg3_87, arg3_87))
		end
	end
end

function var0_0.SetFadeColor(arg0_88, arg1_88, arg2_88)
	local var0_88, var1_88 = arg0_88:GetFadeColor(arg1_88)

	arg0_88:_SetFadeColor(var0_88, var1_88, arg2_88)
end

function var0_0._RevertFadeColor(arg0_89, arg1_89, arg2_89)
	arg0_89:_SetFadeColor(arg1_89, arg2_89, 1)
end

function var0_0.RevertFadeColor(arg0_90, arg1_90)
	local var0_90, var1_90 = arg0_90:GetFadeColor(arg1_90)

	arg0_90:_RevertFadeColor(var0_90, var1_90)
end

function var0_0.fadeTransform(arg0_91, arg1_91, arg2_91, arg3_91, arg4_91, arg5_91, arg6_91)
	if arg4_91 <= 0 then
		if arg6_91 then
			arg6_91()
		end

		return
	end

	local var0_91, var1_91 = arg0_91:GetFadeColor(arg1_91)

	LeanTween.value(go(arg1_91), arg2_91, arg3_91, arg4_91):setOnUpdate(System.Action_float(function(arg0_92)
		arg0_91:_SetFadeColor(var0_91, var1_91, arg0_92)
	end)):setOnComplete(System.Action(function()
		if arg5_91 then
			arg0_91:_RevertFadeColor(var0_91, var1_91)
		end

		if arg6_91 then
			arg6_91()
		end
	end))
end

function var0_0.setPaintingAlpha(arg0_94, arg1_94, arg2_94)
	local var0_94 = {}
	local var1_94 = {}
	local var2_94 = arg1_94:GetComponentsInChildren(typeof(Image)):ToTable()

	for iter0_94, iter1_94 in ipairs(var2_94) do
		local var3_94 = {
			name = "_Color",
			color = Color.white
		}

		if iter1_94.material.shader.name == "UI/GrayScale" then
			var3_94 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif iter1_94.material.shader.name == "UI/Line_Add_Blue" then
			var3_94 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_94, var3_94)

		if iter1_94.material == iter1_94.defaultGraphicMaterial then
			iter1_94.material = Material.Instantiate(iter1_94.defaultGraphicMaterial)
		end

		table.insert(var0_94, iter1_94.material)
	end

	for iter2_94, iter3_94 in ipairs(var0_94) do
		if not IsNil(iter3_94) then
			iter3_94:SetColor(var1_94[iter2_94].name, var1_94[iter2_94].color * Color.New(arg2_94, arg2_94, arg2_94))
		end
	end
end

function var0_0.RegisetEvent(arg0_95, arg1_95, arg2_95)
	setButtonEnabled(arg0_95._go, not arg0_95.autoNext)
	onButton(arg0_95, arg0_95._go, function()
		if arg0_95.pause or arg0_95.stop then
			return
		end

		removeOnButton(arg0_95._go)
		arg2_95()
	end, SFX_PANEL)
end

function var0_0.flashEffect(arg0_97, arg1_97, arg2_97, arg3_97, arg4_97, arg5_97, arg6_97)
	arg0_97.flashImg.color = arg4_97 and Color(0, 0, 0) or Color(1, 1, 1)
	arg0_97.flashCg.alpha = arg1_97

	setActive(arg0_97.flash, true)
	arg0_97:TweenValueForcanvasGroup(arg0_97.flashCg, arg1_97, arg2_97, arg3_97, arg5_97, arg6_97)
end

function var0_0.Flashout(arg0_98, arg1_98, arg2_98)
	local var0_98, var1_98, var2_98, var3_98 = arg1_98:GetFlashoutData()

	if not var0_98 then
		arg2_98()

		return
	end

	arg0_98:flashEffect(var0_98, var1_98, var2_98, var3_98, 0, arg2_98)
end

function var0_0.flashin(arg0_99, arg1_99, arg2_99)
	local var0_99, var1_99, var2_99, var3_99, var4_99 = arg1_99:GetFlashinData()

	if not var0_99 then
		arg2_99()

		return
	end

	arg0_99:flashEffect(var0_99, var1_99, var2_99, var3_99, var4_99, arg2_99)
end

function var0_0.UpdateBg(arg0_100, arg1_100)
	if arg1_100:ShouldBgGlitchArt() then
		arg0_100:SetBgGlitchArt(arg1_100)
	else
		local var0_100 = arg1_100:GetBgName()

		if var0_100 then
			setActive(arg0_100.bgPanel, true)

			arg0_100.bgPanelCg.alpha = 1

			local var1_100 = arg0_100.bgImage

			var1_100.color = Color.New(1, 1, 1)
			var1_100.sprite = arg0_100:GetBg(var0_100)
		end

		local var2_100 = arg1_100:GetBgShadow()

		if var2_100 then
			local var3_100 = arg0_100.bgImage

			arg0_100:TweenValue(var3_100, var2_100[1], var2_100[2], var2_100[3], 0, function(arg0_101)
				var3_100.color = Color.New(arg0_101, arg0_101, arg0_101)
			end, nil)
		end

		if arg1_100:IsBlackBg() then
			setActive(arg0_100.curtain, true)

			arg0_100.curtainCg.alpha = 1
		end

		local var4_100, var5_100 = arg1_100:IsBlackFrontGround()

		if var4_100 then
			arg0_100.curtainFCg.alpha = var5_100
		end

		setActive(arg0_100.curtainF, var4_100)
	end

	arg0_100:ApplyOldPhotoEffect(arg1_100)
	arg0_100:OnBgUpdate(arg1_100)

	local var6_100 = arg1_100:GetBgColor()

	arg0_100.curtain:GetComponent(typeof(Image)).color = var6_100
end

function var0_0.ApplyOldPhotoEffect(arg0_102, arg1_102)
	local var0_102 = arg1_102:OldPhotoEffect()
	local var1_102 = var0_102 ~= nil

	setActive(arg0_102.oldPhoto.gameObject, var1_102)

	if var1_102 then
		if type(var0_102) == "table" then
			arg0_102.oldPhoto.color = Color.New(var0_102[1], var0_102[2], var0_102[3], var0_102[4])
		else
			arg0_102.oldPhoto.color = Color.New(0.62, 0.58, 0.14, 0.36)
		end
	end
end

function var0_0.SetBgGlitchArt(arg0_103, arg1_103)
	setActive(arg0_103.bgPanel, false)
	setActive(arg0_103.bgGlitch, true)
end

function var0_0.GetBg(arg0_104, arg1_104)
	if not arg0_104.bgs[arg1_104] then
		arg0_104.bgs[arg1_104] = LoadSprite("bg/" .. arg1_104)
	end

	return arg0_104.bgs[arg1_104]
end

function var0_0.LoadEffects(arg0_105, arg1_105, arg2_105)
	local var0_105 = arg1_105:GetEffects()

	if #var0_105 <= 0 then
		arg2_105()

		return
	end

	local var1_105 = {}

	for iter0_105, iter1_105 in ipairs(var0_105) do
		local var2_105 = iter1_105.name
		local var3_105 = iter1_105.active
		local var4_105 = iter1_105.interlayer
		local var5_105 = iter1_105.center
		local var6_105 = iter1_105.adapt
		local var7_105 = arg0_105.effectPanel:Find(var2_105) or arg0_105.centerPanel:Find(var2_105)

		if var7_105 then
			setActive(var7_105, var3_105)
			setParent(var7_105, var5_105 and arg0_105.centerPanel or arg0_105.effectPanel.transform)

			if var4_105 then
				arg0_105:UpdateEffectInterLayer(var2_105, var7_105)
			end

			if not var3_105 then
				arg0_105:ClearEffectInterlayer(var2_105)
			elseif isActive(var7_105) then
				setActive(var7_105, false)
				setActive(var7_105, true)
			end

			if var6_105 then
				arg0_105:AdaptEffect(var7_105)
			end
		else
			local var8_105 = ""

			if checkABExist("ui/" .. var2_105) then
				var8_105 = "ui"
			elseif checkABExist("effect/" .. var2_105) then
				var8_105 = "effect"
			end

			if var8_105 and var8_105 ~= "" then
				table.insert(var1_105, function(arg0_106)
					LoadAndInstantiateAsync(var8_105, var2_105, function(arg0_107)
						setParent(arg0_107, var5_105 and arg0_105.centerPanel or arg0_105.effectPanel.transform)

						arg0_107.transform.localScale = Vector3.one

						setActive(arg0_107, var3_105)

						arg0_107.name = var2_105

						if var4_105 then
							arg0_105:UpdateEffectInterLayer(var2_105, arg0_107)
						end

						if var3_105 == false then
							arg0_105:ClearEffectInterlayer(var2_105)
						end

						if var6_105 then
							arg0_105:AdaptEffect(arg0_107)
						end

						arg0_106()
					end)
				end)
			else
				originalPrint("not found effect", var2_105)
			end
		end
	end

	parallelAsync(var1_105, arg2_105)
end

function var0_0.AdaptEffect(arg0_108, arg1_108)
	local var0_108 = 1.77777777777778
	local var1_108 = pg.UIMgr.GetInstance().OverlayMain.parent.sizeDelta
	local var2_108 = var1_108.x / var1_108.y
	local var3_108 = 1

	if var0_108 < var2_108 then
		var3_108 = var2_108 / var0_108
	else
		var3_108 = var0_108 / var2_108
	end

	tf(arg1_108).localScale = Vector3(var3_108, var3_108, var3_108)
end

function var0_0.UpdateEffectInterLayer(arg0_109, arg1_109, arg2_109)
	local var0_109 = arg0_109._go:GetComponent(typeof(Canvas)).sortingOrder
	local var1_109 = arg2_109:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer")):ToTable()

	for iter0_109, iter1_109 in ipairs(var1_109) do
		local var2_109 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", iter1_109)

		if var0_109 < var2_109 then
			var0_109 = var2_109
		end
	end

	local var3_109 = var0_109 + 1
	local var4_109 = GetOrAddComponent(arg0_109.actorTr, typeof(Canvas))

	var4_109.overrideSorting = true
	var4_109.sortingOrder = var3_109

	local var5_109 = GetOrAddComponent(arg0_109.frontTr, typeof(Canvas))

	var5_109.overrideSorting = true
	var5_109.sortingOrder = var3_109 + 1
	arg0_109.activeInterLayer = arg1_109

	GetOrAddComponent(arg0_109.frontTr, typeof(GraphicRaycaster))
end

function var0_0.ClearEffectInterlayer(arg0_110, arg1_110)
	if arg0_110.activeInterLayer == arg1_110 then
		RemoveComponent(arg0_110.frontTr, "GraphicRaycaster")
		RemoveComponent(arg0_110.actorTr, "Canvas")
		RemoveComponent(arg0_110.frontTr, "Canvas")

		arg0_110.activeInterLayer = nil
	end
end

function var0_0.ClearEffects(arg0_111)
	removeAllChildren(arg0_111.effectPanel)
	removeAllChildren(arg0_111.centerPanel)

	if arg0_111.activeInterLayer ~= nil then
		arg0_111:ClearEffectInterlayer(arg0_111.activeInterLayer)
	end
end

function var0_0.PlaySoundEffect(arg0_112, arg1_112)
	if arg1_112:ShouldPlaySoundEffect() then
		local var0_112, var1_112 = arg1_112:GetSoundeffect()

		arg0_112:DelayCall(var1_112, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_112)
		end)
	end

	if arg1_112:ShouldPlayVoice() then
		arg0_112:PlayVoice(arg1_112)
	elseif arg1_112:ShouldStopVoice() then
		arg0_112:StopVoice()
	end
end

function var0_0.StopVoice(arg0_114)
	if arg0_114.currentVoice then
		arg0_114.currentVoice:Stop(true)

		arg0_114.currentVoice = nil
	end
end

function var0_0.PlayVoice(arg0_115, arg1_115)
	if arg0_115.voiceDelayTimer then
		arg0_115.voiceDelayTimer:Stop()

		arg0_115.voiceDelayTimer = nil
	end

	arg0_115:StopVoice()

	local var0_115, var1_115 = arg1_115:GetVoice()
	local var2_115

	var2_115 = arg0_115:CreateDelayTimer(var1_115, function()
		if var2_115 then
			var2_115:Stop()
		end

		if arg0_115.voiceDelayTimer then
			arg0_115.voiceDelayTimer = nil
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_115, function(arg0_117)
			if arg0_117 then
				arg0_115.currentVoice = arg0_117.playback
			end
		end)
	end)
	arg0_115.voiceDelayTimer = var2_115
end

function var0_0.Reset(arg0_118, arg1_118, arg2_118, arg3_118)
	setActive(arg0_118.spAnimPanel, false)
	setActive(arg0_118.castPanel, false)
	setActive(arg0_118.bgPanel, false)

	if arg1_118 and arg1_118:IsDialogueMode() and arg2_118 and arg2_118:IsDialogueMode() then
		-- block empty
	else
		setActive(arg0_118.dialoguePanel, false)
	end

	setActive(arg0_118.asidePanel, false)
	setActive(arg0_118.curtain, false)
	setActive(arg0_118.flash, false)
	setActive(arg0_118.optionsCg.gameObject, false)
	setActive(arg0_118.bgGlitch, false)
	setActive(arg0_118.locationTr, false)

	arg0_118.locationTr.localPosition = arg0_118.locationTrPos
	arg0_118.locationStatus = var9_0
	arg0_118.flashCg.alpha = 1
	arg0_118.goCG.alpha = 1

	arg0_118.animationPlayer:Stop()
	arg0_118:OnReset(arg1_118, arg2_118, arg3_118)
end

function var0_0.Clear(arg0_119, arg1_119)
	if arg0_119.step then
		arg0_119:ClearMoveNodes(arg0_119.step)
	end

	arg0_119.bgs = {}
	arg0_119.skipOption = nil
	arg0_119.step = nil
	arg0_119.goCG.alpha = 1
	arg0_119.callback = nil
	arg0_119.autoNext = nil
	arg0_119.script = nil
	arg0_119.bgImage.sprite = nil

	arg0_119:OnClear()

	if arg1_119 then
		arg1_119()
	end

	pg.DelegateInfo.New(arg0_119)
end

function var0_0.StoryEnd(arg0_120, arg1_120)
	setActive(arg0_120.iconImage.gameObject, false)

	arg0_120.iconImage.sprite = nil
	arg0_120.branchCodeList = {}
	arg0_120.stop = false
	arg0_120.pause = false

	if arg0_120.voiceDelayTimer then
		arg0_120.voiceDelayTimer:Stop()

		arg0_120.voiceDelayTimer = nil
	end

	if arg0_120.currentVoice then
		arg0_120.currentVoice:Stop(true)

		arg0_120.currentVoice = nil
	end

	arg0_120:ClearCheckDispatcher()
	arg0_120:ClearEffects()
	arg0_120:Clear()
	arg0_120:OnEnd(arg1_120)
end

function var0_0.PlayBgm(arg0_121, arg1_121)
	if arg1_121:ShouldStopBgm() then
		arg0_121:StopBgm()
	end

	if arg1_121:ShoulePlayBgm() then
		local var0_121, var1_121, var2_121 = arg1_121:GetBgmData()

		arg0_121:DelayCall(var1_121, function()
			arg0_121:RevertBgmVolume()
			pg.BgmMgr.GetInstance():TempPlay(var0_121)
		end)

		if var2_121 and var2_121 > 0 then
			arg0_121.defaultBgmVolume = pg.CriMgr.GetInstance():getBGMVolume()

			pg.CriMgr.GetInstance():setBGMVolume(var2_121)
		end
	end
end

function var0_0.StopBgm(arg0_123, arg1_123)
	arg0_123:RevertBgmVolume()
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.RevertBgmVolume(arg0_124)
	if arg0_124.defaultBgmVolume then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_124.defaultBgmVolume)

		arg0_124.defaultBgmVolume = nil
	end
end

function var0_0.StartUIAnimations(arg0_125, arg1_125, arg2_125)
	parallelAsync({
		function(arg0_126)
			arg0_125:StartBlinkAnimation(arg1_125, arg0_126)
		end,
		function(arg0_127)
			arg0_125:StartBlinkWithColorAnimation(arg1_125, arg0_127)
		end,
		function(arg0_128)
			arg0_125:OnStartUIAnimations(arg1_125, arg0_128)
		end
	}, arg2_125)
end

function var0_0.StartBlinkAnimation(arg0_129, arg1_129, arg2_129)
	if arg1_129:ShouldBlink() then
		local var0_129 = arg1_129:GetBlinkData()
		local var1_129 = var0_129.black
		local var2_129 = var0_129.number
		local var3_129 = var0_129.dur
		local var4_129 = var0_129.delay
		local var5_129 = var0_129.alpha[1]
		local var6_129 = var0_129.alpha[2]
		local var7_129 = var0_129.wait

		arg0_129.flashImg.color = var1_129 and Color(0, 0, 0) or Color(1, 1, 1)

		setActive(arg0_129.flash, true)

		local var8_129 = {}

		for iter0_129 = 1, var2_129 do
			table.insert(var8_129, function(arg0_130)
				arg0_129:TweenAlpha(arg0_129.flash, var5_129, var6_129, var3_129 / 2, 0, function()
					arg0_129:TweenAlpha(arg0_129.flash, var6_129, var5_129, var3_129 / 2, var7_129, arg0_130)
				end)
			end)
		end

		seriesAsync(var8_129, function()
			setActive(arg0_129.flash, false)
		end)
	end

	arg2_129()
end

function var0_0.StartBlinkWithColorAnimation(arg0_133, arg1_133, arg2_133)
	if arg1_133:ShouldBlinkWithColor() then
		local var0_133 = arg1_133:GetBlinkWithColorData()
		local var1_133 = var0_133.color
		local var2_133 = var0_133.alpha

		arg0_133.flashImg.color = Color(var1_133[1], var1_133[2], var1_133[3], var1_133[4])

		setActive(arg0_133.flash, true)

		local var3_133 = {}

		for iter0_133, iter1_133 in ipairs(var2_133) do
			local var4_133 = iter1_133[1]
			local var5_133 = iter1_133[2]
			local var6_133 = iter1_133[3]
			local var7_133 = iter1_133[4]

			table.insert(var3_133, function(arg0_134)
				arg0_133:TweenValue(arg0_133.flash, var4_133, var5_133, var6_133, var7_133, function(arg0_135)
					arg0_133.flashCg.alpha = arg0_135
				end, arg0_134)
			end)
		end

		parallelAsync(var3_133, function()
			setActive(arg0_133.flash, false)
		end)
	end

	arg2_133()
end

function var0_0.OnStart(arg0_137, arg1_137)
	return
end

function var0_0.OnReset(arg0_138, arg1_138, arg2_138, arg3_138)
	arg3_138()
end

function var0_0.OnBgUpdate(arg0_139, arg1_139)
	return
end

function var0_0.OnInit(arg0_140, arg1_140, arg2_140, arg3_140)
	if arg3_140 then
		arg3_140()
	end
end

function var0_0.OnStartUIAnimations(arg0_141, arg1_141, arg2_141)
	if arg2_141 then
		arg2_141()
	end
end

function var0_0.OnEnter(arg0_142, arg1_142, arg2_142, arg3_142)
	if arg3_142 then
		arg3_142()
	end
end

function var0_0.OnWillExit(arg0_143, arg1_143, arg2_143, arg3_143)
	arg3_143()
end

function var0_0.OnWillClear(arg0_144, arg1_144)
	return
end

function var0_0.OnClear(arg0_145)
	return
end

function var0_0.OnEnd(arg0_146, arg1_146)
	return
end

return var0_0
