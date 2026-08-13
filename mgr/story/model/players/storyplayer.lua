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

	if var0_6 <= 3 or arg1_6:IsOptionForceCenter() then
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

	if var0_10:GetMode() == Story.MODE_SUBPAGE and not var0_10:ShouldShowSubPage() then
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

	if arg1_62:Find("type3") then
		if arg2_62 and arg2_62 == 3 then
			arg1_62:Find("Text").localPosition = Vector2(20, 0)

			setActive(arg1_62:Find("type3"), true)
		else
			arg1_62:Find("Text").localPosition = Vector2.zero

			setActive(arg1_62:Find("type3"), false)
		end
	end

	if arg2_62 and arg2_62 == 3 and arg1_62:Find("icon") then
		setActive(arg1_62:Find("icon"), false)

		local var7_62 = GetSpriteFromAtlas("ui/story_atlas", "option_bg_left_global")

		setImageSprite(arg1_62, var7_62)
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
			local var4_64 = var1_63[arg1_64 + 1][4]
			local var5_64 = table.contains(var5_63, var2_64)

			onButton(arg0_63, var0_64, function()
				if arg0_63.pause or arg0_63.stop then
					return
				end

				if not var0_63 then
					return
				end

				arg0_63.selectedBranchID = arg1_64

				arg0_63:SetBranchCode(arg1_63, arg2_63, var2_64)

				if var4_64 then
					arg0_63:SetGlobalOptionFlag(var4_64)
				end

				pg.NewStoryMgr.GetInstance():TrackingOption(arg2_63:GetOptionIndex(), var2_64)

				local var0_65 = arg2_64:GetComponent(typeof(Animation))

				if var0_65 then
					var6_63.blocksRaycasts = false

					var0_65:Play(arg0_63.script:GetAnimPrefix() .. "confirm")
					arg2_64:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						setActive(arg0_63.optionsCg.gameObject, false)

						var6_63.blocksRaycasts = true

						arg0_63:HideBranchesWithoutSelected(arg2_63)
						arg3_63(var1_64)
					end)
				else
					setActive(arg0_63.optionsCg.gameObject, false)
					arg0_63:HideBranchesWithoutSelected(arg2_63)
					arg3_63(var1_64)
				end
			end, SFX_PANEL)
			setButtonEnabled(var0_64, not var5_64)

			GetOrAddComponent(arg2_64, typeof(CanvasGroup)).alpha = var5_64 and 0.5 or 1

			if var4_64 then
				var3_64 = 3
			end

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

function var0_0.SetGlobalOptionFlag(arg0_70, arg1_70)
	local var0_70 = StoryStep.GetGlobalFlagKey(arg1_70.flagID) .. arg1_70.flagIndex

	PlayerPrefs.SetInt(var0_70, arg1_70.flagValue)
end

function var0_0.ShowBranches(arg0_71, arg1_71, arg2_71)
	setActive(arg0_71.optionsCg.gameObject, true)

	local var0_71 = arg0_71:GetOptionContainer(arg1_71)

	for iter0_71 = 0, var0_71.container.childCount - 1 do
		local var1_71 = var0_71.container:GetChild(iter0_71):GetComponent(typeof(Animation))

		if var1_71 then
			var1_71:Play(arg0_71.script:GetAnimPrefix() .. "in")
		end
	end

	arg2_71()
end

function var0_0.HideBranchesWithoutSelected(arg0_72, arg1_72)
	local var0_72 = arg0_72:GetOptionContainer(arg1_72)

	for iter0_72 = 0, var0_72.container.childCount - 1 do
		if iter0_72 ~= arg0_72.selectedBranchID then
			local var1_72 = var0_72.container:GetChild(iter0_72):GetComponent(typeof(Animation))

			if var1_72 then
				var1_72:Play(arg0_72.script:GetAnimPrefix() .. "unselected")
			end
		end
	end
end

function var0_0.StartMoveNode(arg0_73, arg1_73, arg2_73)
	if not arg1_73:ExistMovableNode() then
		arg2_73()

		return
	end

	local var0_73 = arg1_73:GetMovableNode()
	local var1_73 = {}
	local var2_73 = {}

	for iter0_73, iter1_73 in pairs(var0_73) do
		table.insert(var1_73, function(arg0_74)
			arg0_73:LoadMovableNode(iter1_73, function(arg0_75)
				var2_73[iter0_73] = arg0_75

				arg0_74()
			end)
		end)
	end

	parallelAsync(var1_73, function()
		arg0_73:MoveAllNode(arg1_73, var2_73, var0_73)
		arg2_73()
	end)
end

function var0_0.MoveAllNode(arg0_77, arg1_77, arg2_77, arg3_77)
	local var0_77 = {}

	for iter0_77, iter1_77 in pairs(arg2_77) do
		table.insert(var0_77, function(arg0_78)
			local var0_78 = arg3_77[iter0_77]
			local var1_78 = var0_78.path
			local var2_78 = var0_78.time
			local var3_78 = var0_78.easeType
			local var4_78 = var0_78.delay

			arg0_77:moveLocalPath(iter1_77, var1_78, var2_78, var4_78, var3_78, arg0_78)
		end)
	end

	arg0_77.moveTargets = arg2_77

	parallelAsync(var0_77, function()
		arg0_77:ClearMoveNodes(arg1_77)
	end)
end

local function var12_0(arg0_80, arg1_80, arg2_80, arg3_80, arg4_80)
	arg0_80.spineChar = SpineAnimChar.New()

	arg0_80.spineChar:SetPaint(arg1_80)
	arg0_80.spineChar:Load(true, function(arg0_81)
		arg0_81:SetParent(arg0_80.movePanel)
		arg0_81:SetLocalScale(Vector3(arg2_80.scale, arg2_80.scale, 0))
		arg0_81:SetLocalPosition(arg3_80)
		arg0_81:SetAction(arg2_80.action, 0)
		arg0_81:SetName(arg1_80)

		if arg4_80 then
			arg4_80(arg0_80.spineChar:GetModel())
		end
	end)
end

local function var13_0(arg0_82, arg1_82, arg2_82, arg3_82)
	local var0_82 = GameObject.New("movable")

	var0_82.transform:SetParent(arg0_82.movePanel)

	var0_82.transform.localScale = Vector3.zero

	local var1_82 = GetOrAddComponent(var0_82, typeof(RectTransform))
	local var2_82 = GetOrAddComponent(var0_82, typeof(Image))

	LoadSpriteAsync(arg1_82, function(arg0_83)
		var2_82.sprite = arg0_83

		var2_82:SetNativeSize()

		var1_82.localScale = Vector3.one
		var1_82.localPosition = arg2_82

		arg3_82(var1_82.gameObject)
	end)
end

function var0_0.LoadMovableNode(arg0_84, arg1_84, arg2_84)
	local var0_84 = arg1_84.path[1] or Vector3.zero

	if arg1_84.isSpine then
		var12_0(arg0_84, arg1_84.name, arg1_84.spineData, var0_84, arg2_84)
	else
		var13_0(arg0_84, arg1_84.name, var0_84, arg2_84)
	end
end

function var0_0.ClearMoveNodes(arg0_85, arg1_85)
	if not arg1_85:ExistMovableNode() then
		return
	end

	if arg0_85.movePanel.childCount <= 0 then
		return
	end

	for iter0_85, iter1_85 in ipairs(arg0_85.moveTargets or {}) do
		if iter1_85:GetComponent(typeof(SpineAnimUI)) ~= nil then
			PoolMgr.GetInstance():ReturnSpineChar(iter1_85.name, iter1_85.gameObject)
		else
			Destroy(arg0_85.movePanel:GetChild(iter0_85 - 1))
		end
	end

	arg0_85.moveTargets = {}
end

function var0_0.FadeOutStory(arg0_86, arg1_86, arg2_86)
	if not arg1_86:ShouldFadeout() then
		arg2_86()

		return
	end

	local var0_86 = arg1_86:GetFadeoutTime()

	if not arg1_86:ShouldWaitFadeout() then
		arg0_86:fadeTransform(arg0_86._go, 1, 0.3, var0_86, true)
		arg2_86()
	else
		arg0_86:fadeTransform(arg0_86._go, 1, 0.3, var0_86, true, arg2_86)
	end
end

function var0_0.GetFadeColor(arg0_87, arg1_87)
	local var0_87 = {}
	local var1_87 = {}
	local var2_87 = arg1_87:GetComponentsInChildren(typeof(Image)):ToTable()

	for iter0_87, iter1_87 in ipairs(var2_87) do
		local var3_87 = {
			name = "_Color",
			color = Color.white
		}

		if iter1_87.material.shader.name == "UI/GrayScale" then
			var3_87 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif iter1_87.material.shader.name == "UI/Line_Add_Blue" then
			var3_87 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_87, var3_87)

		if iter1_87.material == iter1_87.defaultGraphicMaterial then
			iter1_87.material = Material.Instantiate(iter1_87.defaultGraphicMaterial)
		end

		table.insert(var0_87, iter1_87.material)
	end

	return var0_87, var1_87
end

function var0_0._SetFadeColor(arg0_88, arg1_88, arg2_88, arg3_88)
	for iter0_88, iter1_88 in ipairs(arg1_88) do
		if not IsNil(iter1_88) then
			iter1_88:SetColor(arg2_88[iter0_88].name, arg2_88[iter0_88].color * Color.New(arg3_88, arg3_88, arg3_88))
		end
	end
end

function var0_0.SetFadeColor(arg0_89, arg1_89, arg2_89)
	local var0_89, var1_89 = arg0_89:GetFadeColor(arg1_89)

	arg0_89:_SetFadeColor(var0_89, var1_89, arg2_89)
end

function var0_0._RevertFadeColor(arg0_90, arg1_90, arg2_90)
	arg0_90:_SetFadeColor(arg1_90, arg2_90, 1)
end

function var0_0.RevertFadeColor(arg0_91, arg1_91)
	local var0_91, var1_91 = arg0_91:GetFadeColor(arg1_91)

	arg0_91:_RevertFadeColor(var0_91, var1_91)
end

function var0_0.fadeTransform(arg0_92, arg1_92, arg2_92, arg3_92, arg4_92, arg5_92, arg6_92)
	if arg4_92 <= 0 then
		if arg6_92 then
			arg6_92()
		end

		return
	end

	local var0_92, var1_92 = arg0_92:GetFadeColor(arg1_92)

	LeanTween.value(go(arg1_92), arg2_92, arg3_92, arg4_92):setOnUpdate(System.Action_float(function(arg0_93)
		arg0_92:_SetFadeColor(var0_92, var1_92, arg0_93)
	end)):setOnComplete(System.Action(function()
		if arg5_92 then
			arg0_92:_RevertFadeColor(var0_92, var1_92)
		end

		if arg6_92 then
			arg6_92()
		end
	end))
end

function var0_0.setPaintingAlpha(arg0_95, arg1_95, arg2_95)
	local var0_95 = {}
	local var1_95 = {}
	local var2_95 = arg1_95:GetComponentsInChildren(typeof(Image)):ToTable()

	for iter0_95, iter1_95 in ipairs(var2_95) do
		local var3_95 = {
			name = "_Color",
			color = Color.white
		}

		if iter1_95.material.shader.name == "UI/GrayScale" then
			var3_95 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif iter1_95.material.shader.name == "UI/Line_Add_Blue" then
			var3_95 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_95, var3_95)

		if iter1_95.material == iter1_95.defaultGraphicMaterial then
			iter1_95.material = Material.Instantiate(iter1_95.defaultGraphicMaterial)
		end

		table.insert(var0_95, iter1_95.material)
	end

	for iter2_95, iter3_95 in ipairs(var0_95) do
		if not IsNil(iter3_95) then
			iter3_95:SetColor(var1_95[iter2_95].name, var1_95[iter2_95].color * Color.New(arg2_95, arg2_95, arg2_95))
		end
	end
end

function var0_0.RegisetEvent(arg0_96, arg1_96, arg2_96)
	setButtonEnabled(arg0_96._go, not arg0_96.autoNext)
	onButton(arg0_96, arg0_96._go, function()
		if arg0_96.pause or arg0_96.stop then
			return
		end

		removeOnButton(arg0_96._go)
		arg2_96()
	end, SFX_PANEL)
end

function var0_0.flashEffect(arg0_98, arg1_98, arg2_98, arg3_98, arg4_98, arg5_98, arg6_98)
	arg0_98.flashImg.color = arg4_98 and Color(0, 0, 0) or Color(1, 1, 1)
	arg0_98.flashCg.alpha = arg1_98

	setActive(arg0_98.flash, true)
	arg0_98:TweenValueForcanvasGroup(arg0_98.flashCg, arg1_98, arg2_98, arg3_98, arg5_98, arg6_98)
end

function var0_0.Flashout(arg0_99, arg1_99, arg2_99)
	local var0_99, var1_99, var2_99, var3_99 = arg1_99:GetFlashoutData()

	if not var0_99 then
		arg2_99()

		return
	end

	arg0_99:flashEffect(var0_99, var1_99, var2_99, var3_99, 0, arg2_99)
end

function var0_0.flashin(arg0_100, arg1_100, arg2_100)
	local var0_100, var1_100, var2_100, var3_100, var4_100 = arg1_100:GetFlashinData()

	if not var0_100 then
		arg2_100()

		return
	end

	arg0_100:flashEffect(var0_100, var1_100, var2_100, var3_100, var4_100, arg2_100)
end

function var0_0.UpdateBg(arg0_101, arg1_101)
	if arg1_101:ShouldBgGlitchArt() then
		arg0_101:SetBgGlitchArt(arg1_101)
	else
		local var0_101 = arg1_101:GetBgName()

		if var0_101 then
			setActive(arg0_101.bgPanel, true)

			arg0_101.bgPanelCg.alpha = 1

			local var1_101 = arg0_101.bgImage

			var1_101.color = Color.New(1, 1, 1)
			var1_101.sprite = arg0_101:GetBg(var0_101)
		end

		local var2_101 = arg1_101:GetBgShadow()

		if var2_101 then
			local var3_101 = arg0_101.bgImage

			arg0_101:TweenValue(var3_101, var2_101[1], var2_101[2], var2_101[3], 0, function(arg0_102)
				var3_101.color = Color.New(arg0_102, arg0_102, arg0_102)
			end, nil)
		end

		if arg1_101:IsBlackBg() then
			setActive(arg0_101.curtain, true)

			arg0_101.curtainCg.alpha = 1
		end

		local var4_101, var5_101 = arg1_101:IsBlackFrontGround()

		if var4_101 then
			arg0_101.curtainFCg.alpha = var5_101
		end

		setActive(arg0_101.curtainF, var4_101)
	end

	arg0_101:ApplyOldPhotoEffect(arg1_101)
	arg0_101:OnBgUpdate(arg1_101)

	local var6_101 = arg1_101:GetBgColor()

	arg0_101.curtain:GetComponent(typeof(Image)).color = var6_101
end

function var0_0.ApplyOldPhotoEffect(arg0_103, arg1_103)
	local var0_103 = arg1_103:OldPhotoEffect()
	local var1_103 = var0_103 ~= nil

	setActive(arg0_103.oldPhoto.gameObject, var1_103)

	if var1_103 then
		if type(var0_103) == "table" then
			arg0_103.oldPhoto.color = Color.New(var0_103[1], var0_103[2], var0_103[3], var0_103[4])
		else
			arg0_103.oldPhoto.color = Color.New(0.62, 0.58, 0.14, 0.36)
		end
	end
end

function var0_0.SetBgGlitchArt(arg0_104, arg1_104)
	setActive(arg0_104.bgPanel, false)
	setActive(arg0_104.bgGlitch, true)
end

function var0_0.GetBg(arg0_105, arg1_105)
	if not arg0_105.bgs[arg1_105] then
		arg0_105.bgs[arg1_105] = LoadSprite("bg/" .. arg1_105)
	end

	return arg0_105.bgs[arg1_105]
end

function var0_0.LoadEffects(arg0_106, arg1_106, arg2_106)
	local var0_106 = arg1_106:GetEffects()

	if #var0_106 <= 0 then
		arg2_106()

		return
	end

	local var1_106 = {}

	for iter0_106, iter1_106 in ipairs(var0_106) do
		local var2_106 = iter1_106.name
		local var3_106 = iter1_106.active
		local var4_106 = iter1_106.interlayer
		local var5_106 = iter1_106.center
		local var6_106 = iter1_106.adapt
		local var7_106 = arg0_106.effectPanel:Find(var2_106) or arg0_106.centerPanel:Find(var2_106)

		if var7_106 then
			setActive(var7_106, var3_106)
			setParent(var7_106, var5_106 and arg0_106.centerPanel or arg0_106.effectPanel.transform)

			if var4_106 then
				arg0_106:UpdateEffectInterLayer(var2_106, var7_106)
			end

			if not var3_106 then
				arg0_106:ClearEffectInterlayer(var2_106)
			elseif isActive(var7_106) then
				setActive(var7_106, false)
				setActive(var7_106, true)
			end

			if var6_106 then
				arg0_106:AdaptEffect(var7_106)
			end
		else
			local var8_106 = ""

			if checkABExist("ui/" .. var2_106) then
				var8_106 = "ui"
			elseif checkABExist("effect/" .. var2_106) then
				var8_106 = "effect"
			end

			if var8_106 and var8_106 ~= "" then
				table.insert(var1_106, function(arg0_107)
					LoadAndInstantiateAsync(var8_106, var2_106, function(arg0_108)
						setParent(arg0_108, var5_106 and arg0_106.centerPanel or arg0_106.effectPanel.transform)

						arg0_108.transform.localScale = Vector3.one

						setActive(arg0_108, var3_106)

						arg0_108.name = var2_106

						if var4_106 then
							arg0_106:UpdateEffectInterLayer(var2_106, arg0_108)
						end

						if var3_106 == false then
							arg0_106:ClearEffectInterlayer(var2_106)
						end

						if var6_106 then
							arg0_106:AdaptEffect(arg0_108)
						end

						arg0_107()
					end)
				end)
			else
				originalPrint("not found effect", var2_106)
			end
		end
	end

	parallelAsync(var1_106, arg2_106)
end

function var0_0.AdaptEffect(arg0_109, arg1_109)
	local var0_109 = 1.77777777777778
	local var1_109 = pg.UIMgr.GetInstance().OverlayMain.parent.sizeDelta
	local var2_109 = var1_109.x / var1_109.y
	local var3_109 = 1

	if var0_109 < var2_109 then
		var3_109 = var2_109 / var0_109
	else
		var3_109 = var0_109 / var2_109
	end

	tf(arg1_109).localScale = Vector3(var3_109, var3_109, var3_109)
end

function var0_0.UpdateEffectInterLayer(arg0_110, arg1_110, arg2_110)
	local var0_110 = arg0_110._go:GetComponent(typeof(Canvas)).sortingOrder
	local var1_110 = arg2_110:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer")):ToTable()

	for iter0_110, iter1_110 in ipairs(var1_110) do
		local var2_110 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", iter1_110)

		if var0_110 < var2_110 then
			var0_110 = var2_110
		end
	end

	local var3_110 = var0_110 + 1
	local var4_110 = GetOrAddComponent(arg0_110.actorTr, typeof(Canvas))

	var4_110.overrideSorting = true
	var4_110.sortingOrder = var3_110

	local var5_110 = GetOrAddComponent(arg0_110.frontTr, typeof(Canvas))

	var5_110.overrideSorting = true
	var5_110.sortingOrder = var3_110 + 1
	arg0_110.activeInterLayer = arg1_110

	GetOrAddComponent(arg0_110.frontTr, typeof(GraphicRaycaster))
end

function var0_0.ClearEffectInterlayer(arg0_111, arg1_111)
	if arg0_111.activeInterLayer == arg1_111 then
		RemoveComponent(arg0_111.frontTr, "GraphicRaycaster")
		RemoveComponent(arg0_111.actorTr, "Canvas")
		RemoveComponent(arg0_111.frontTr, "Canvas")

		arg0_111.activeInterLayer = nil
	end
end

function var0_0.ClearEffects(arg0_112)
	removeAllChildren(arg0_112.effectPanel)
	removeAllChildren(arg0_112.centerPanel)

	if arg0_112.activeInterLayer ~= nil then
		arg0_112:ClearEffectInterlayer(arg0_112.activeInterLayer)
	end
end

function var0_0.PlaySoundEffect(arg0_113, arg1_113)
	if arg1_113:ShouldPlaySoundEffect() then
		local var0_113, var1_113 = arg1_113:GetSoundeffect()

		arg0_113:DelayCall(var1_113, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_113)
		end)
	end

	if arg1_113:ShouldPlayVoice() then
		arg0_113:PlayVoice(arg1_113)
	elseif arg1_113:ShouldStopVoice() then
		arg0_113:StopVoice()
	end
end

function var0_0.StopVoice(arg0_115)
	if arg0_115.currentVoice then
		arg0_115.currentVoice:Stop(true)

		arg0_115.currentVoice = nil
	end
end

function var0_0.PlayVoice(arg0_116, arg1_116)
	if arg0_116.voiceDelayTimer then
		arg0_116.voiceDelayTimer:Stop()

		arg0_116.voiceDelayTimer = nil
	end

	arg0_116:StopVoice()

	local var0_116, var1_116 = arg1_116:GetVoice()
	local var2_116

	var2_116 = arg0_116:CreateDelayTimer(var1_116, function()
		if var2_116 then
			var2_116:Stop()
		end

		if arg0_116.voiceDelayTimer then
			arg0_116.voiceDelayTimer = nil
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_116, function(arg0_118)
			if arg0_118 then
				arg0_116.currentVoice = arg0_118.playback
			end
		end)
	end)
	arg0_116.voiceDelayTimer = var2_116
end

function var0_0.Reset(arg0_119, arg1_119, arg2_119, arg3_119)
	setActive(arg0_119.spAnimPanel, false)
	setActive(arg0_119.castPanel, false)
	setActive(arg0_119.bgPanel, false)

	if arg1_119 and arg1_119:IsDialogueMode() and arg2_119 and arg2_119:IsDialogueMode() then
		-- block empty
	else
		setActive(arg0_119.dialoguePanel, false)
	end

	setActive(arg0_119.asidePanel, false)
	setActive(arg0_119.curtain, false)
	setActive(arg0_119.flash, false)
	setActive(arg0_119.optionsCg.gameObject, false)
	setActive(arg0_119.bgGlitch, false)
	setActive(arg0_119.locationTr, false)

	arg0_119.locationTr.localPosition = arg0_119.locationTrPos
	arg0_119.locationStatus = var9_0
	arg0_119.flashCg.alpha = 1
	arg0_119.goCG.alpha = 1

	arg0_119.animationPlayer:Stop()
	arg0_119:OnReset(arg1_119, arg2_119, arg3_119)
end

function var0_0.Clear(arg0_120, arg1_120)
	if arg0_120.step then
		arg0_120:ClearMoveNodes(arg0_120.step)
	end

	arg0_120.bgs = {}
	arg0_120.skipOption = nil
	arg0_120.step = nil
	arg0_120.goCG.alpha = 1
	arg0_120.callback = nil
	arg0_120.autoNext = nil
	arg0_120.script = nil
	arg0_120.bgImage.sprite = nil

	arg0_120:OnClear()

	if arg1_120 then
		arg1_120()
	end

	pg.DelegateInfo.New(arg0_120)
end

function var0_0.StoryEnd(arg0_121, arg1_121)
	setActive(arg0_121.iconImage.gameObject, false)

	arg0_121.iconImage.sprite = nil
	arg0_121.branchCodeList = {}
	arg0_121.stop = false
	arg0_121.pause = false

	if arg0_121.voiceDelayTimer then
		arg0_121.voiceDelayTimer:Stop()

		arg0_121.voiceDelayTimer = nil
	end

	if arg0_121.currentVoice then
		arg0_121.currentVoice:Stop(true)

		arg0_121.currentVoice = nil
	end

	arg0_121:ClearCheckDispatcher()
	arg0_121:ClearEffects()
	arg0_121:Clear()
	arg0_121:OnEnd(arg1_121)
end

function var0_0.PlayBgm(arg0_122, arg1_122)
	if arg1_122:ShouldStopBgm() then
		arg0_122:StopBgm()
	end

	if arg1_122:ShoulePlayBgm() then
		local var0_122, var1_122, var2_122 = arg1_122:GetBgmData()

		arg0_122:DelayCall(var1_122, function()
			arg0_122:RevertBgmVolume()
			pg.BgmMgr.GetInstance():TempPlay(var0_122)
		end)

		if var2_122 and var2_122 > 0 then
			arg0_122.defaultBgmVolume = pg.CriMgr.GetInstance():getBGMVolume()

			pg.CriMgr.GetInstance():setBGMVolume(var2_122)
		end
	end
end

function var0_0.StopBgm(arg0_124, arg1_124)
	arg0_124:RevertBgmVolume()
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.RevertBgmVolume(arg0_125)
	if arg0_125.defaultBgmVolume then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_125.defaultBgmVolume)

		arg0_125.defaultBgmVolume = nil
	end
end

function var0_0.StartUIAnimations(arg0_126, arg1_126, arg2_126)
	parallelAsync({
		function(arg0_127)
			arg0_126:StartBlinkAnimation(arg1_126, arg0_127)
		end,
		function(arg0_128)
			arg0_126:StartBlinkWithColorAnimation(arg1_126, arg0_128)
		end,
		function(arg0_129)
			arg0_126:OnStartUIAnimations(arg1_126, arg0_129)
		end
	}, arg2_126)
end

function var0_0.StartBlinkAnimation(arg0_130, arg1_130, arg2_130)
	if arg1_130:ShouldBlink() then
		local var0_130 = arg1_130:GetBlinkData()
		local var1_130 = var0_130.black
		local var2_130 = var0_130.number
		local var3_130 = var0_130.dur
		local var4_130 = var0_130.delay
		local var5_130 = var0_130.alpha[1]
		local var6_130 = var0_130.alpha[2]
		local var7_130 = var0_130.wait

		arg0_130.flashImg.color = var1_130 and Color(0, 0, 0) or Color(1, 1, 1)

		setActive(arg0_130.flash, true)

		local var8_130 = {}

		for iter0_130 = 1, var2_130 do
			table.insert(var8_130, function(arg0_131)
				arg0_130:TweenAlpha(arg0_130.flash, var5_130, var6_130, var3_130 / 2, 0, function()
					arg0_130:TweenAlpha(arg0_130.flash, var6_130, var5_130, var3_130 / 2, var7_130, arg0_131)
				end)
			end)
		end

		seriesAsync(var8_130, function()
			setActive(arg0_130.flash, false)
		end)
	end

	arg2_130()
end

function var0_0.StartBlinkWithColorAnimation(arg0_134, arg1_134, arg2_134)
	if arg1_134:ShouldBlinkWithColor() then
		local var0_134 = arg1_134:GetBlinkWithColorData()
		local var1_134 = var0_134.color
		local var2_134 = var0_134.alpha

		arg0_134.flashImg.color = Color(var1_134[1], var1_134[2], var1_134[3], var1_134[4])

		setActive(arg0_134.flash, true)

		local var3_134 = {}

		for iter0_134, iter1_134 in ipairs(var2_134) do
			local var4_134 = iter1_134[1]
			local var5_134 = iter1_134[2]
			local var6_134 = iter1_134[3]
			local var7_134 = iter1_134[4]

			table.insert(var3_134, function(arg0_135)
				arg0_134:TweenValue(arg0_134.flash, var4_134, var5_134, var6_134, var7_134, function(arg0_136)
					arg0_134.flashCg.alpha = arg0_136
				end, arg0_135)
			end)
		end

		parallelAsync(var3_134, function()
			setActive(arg0_134.flash, false)
		end)
	end

	arg2_134()
end

function var0_0.OnStart(arg0_138, arg1_138)
	return
end

function var0_0.OnReset(arg0_139, arg1_139, arg2_139, arg3_139)
	arg3_139()
end

function var0_0.OnBgUpdate(arg0_140, arg1_140)
	return
end

function var0_0.OnInit(arg0_141, arg1_141, arg2_141, arg3_141)
	if arg3_141 then
		arg3_141()
	end
end

function var0_0.OnStartUIAnimations(arg0_142, arg1_142, arg2_142)
	if arg2_142 then
		arg2_142()
	end
end

function var0_0.OnEnter(arg0_143, arg1_143, arg2_143, arg3_143)
	if arg3_143 then
		arg3_143()
	end
end

function var0_0.OnWillExit(arg0_144, arg1_144, arg2_144, arg3_144)
	arg3_144()
end

function var0_0.OnWillClear(arg0_145, arg1_145)
	return
end

function var0_0.OnClear(arg0_146)
	return
end

function var0_0.OnEnd(arg0_147, arg1_147)
	return
end

return var0_0
