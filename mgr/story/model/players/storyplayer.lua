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
	arg0_1.front = arg0_1:findTF("front")
	arg0_1.actorTr = arg0_1._tf:Find("actor")
	arg0_1.frontTr = arg0_1._tf:Find("front")
	arg0_1.backPanel = arg0_1:findTF("back")
	arg0_1.goCG = GetOrAddComponent(arg0_1._tf, typeof(CanvasGroup))
	arg0_1.asidePanel = arg0_1:findTF("front/aside_panel")
	arg0_1.bgGlitch = arg0_1:findTF("back/bg_glitch")
	arg0_1.oldPhoto = arg0_1:findTF("front/oldphoto"):GetComponent(typeof(Image))
	arg0_1.bgPanel = arg0_1:findTF("back/bg")
	arg0_1.bgPanelCg = arg0_1.bgPanel:GetComponent(typeof(CanvasGroup))
	arg0_1.bgImage = arg0_1:findTF("image", arg0_1.bgPanel):GetComponent(typeof(Image))
	arg0_1.mainImg = arg0_1._tf:GetComponent(typeof(Image))
	arg0_1.castPanel = arg0_1:findTF("front/cast_panel")
	arg0_1.spAnimPanel = arg0_1:findTF("front/sp_anim_panel")
	arg0_1.centerPanel = arg0_1._tf:Find("center")
	arg0_1.actorPanel = arg0_1:findTF("actor")
	arg0_1.dialoguePanel = arg0_1:findTF("front/dialogue")
	arg0_1.effectPanel = arg0_1:findTF("front/effect")
	arg0_1.movePanel = arg0_1:findTF("front/move_layer")
	arg0_1.curtain = arg0_1:findTF("back/curtain")
	arg0_1.curtainCg = arg0_1.curtain:GetComponent(typeof(CanvasGroup))
	arg0_1.flash = arg0_1:findTF("front/flash")
	arg0_1.flashImg = arg0_1.flash:GetComponent(typeof(Image))
	arg0_1.flashCg = arg0_1.flash:GetComponent(typeof(CanvasGroup))
	arg0_1.curtainF = arg0_1:findTF("back/curtain_front")
	arg0_1.curtainFCg = arg0_1.curtainF:GetComponent(typeof(CanvasGroup))
	arg0_1.locationTr = arg0_1:findTF("front/location")
	arg0_1.locationTxt = arg0_1:findTF("front/location/Text"):GetComponent(typeof(Text))
	arg0_1.locationTrPos = arg0_1.locationTr.localPosition
	arg0_1.locationAnim = arg0_1.locationTr:GetComponent(typeof(Animation))
	arg0_1.locationAniEvent = arg0_1.locationTr:GetComponent(typeof(DftAniEvent))
	arg0_1.iconImage = arg0_1:findTF("front/icon"):GetComponent(typeof(Image))
	arg0_1.topEffectTr = arg0_1:findTF("top/effect")
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

	if var1_61:Find("type1") then
		setActive(var1_61:Find("type1"), arg4_61 and arg4_61 == 1)
	end

	if var1_61:Find("type2") then
		setActive(var1_61:Find("type2"), arg4_61 and arg4_61 == 2)
	end
end

function var0_0.InitBranches(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62)
	local var0_62 = false
	local var1_62 = arg2_62:GetOptions()
	local var2_62, var3_62 = arg0_62:GetOptionContainer(arg2_62)
	local var4_62 = arg2_62:GetId()
	local var5_62 = arg0_62.branchCodeList[var4_62] or {}
	local var6_62 = GetOrAddComponent(var2_62.container, typeof(CanvasGroup))

	var6_62.blocksRaycasts = true
	arg0_62.selectedBranchID = nil

	var2_62:make(function(arg0_63, arg1_63, arg2_63)
		if arg0_63 == UIItemList.EventUpdate then
			local var0_63 = arg2_63
			local var1_63 = var1_62[arg1_63 + 1][1]
			local var2_63 = var1_62[arg1_63 + 1][2]
			local var3_63 = var1_62[arg1_63 + 1][3]
			local var4_63 = table.contains(var5_62, var2_63)

			onButton(arg0_62, var0_63, function()
				if arg0_62.pause or arg0_62.stop then
					return
				end

				if not var0_62 then
					return
				end

				arg0_62.selectedBranchID = arg1_63

				arg0_62:SetBranchCode(arg1_62, arg2_62, var2_63)
				pg.NewStoryMgr.GetInstance():TrackingOption(arg2_62:GetOptionIndex(), var2_63)

				local var0_64 = arg2_63:GetComponent(typeof(Animation))

				if var0_64 then
					var6_62.blocksRaycasts = false

					var0_64:Play(arg0_62.script:GetAnimPrefix() .. "confirm")
					arg2_63:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						setActive(arg0_62.optionsCg.gameObject, false)

						var6_62.blocksRaycasts = true

						arg3_62(var1_63)
					end)
				else
					setActive(arg0_62.optionsCg.gameObject, false)
					arg3_62(var1_63)
				end

				arg0_62:HideBranchesWithoutSelected(arg2_62)
			end, SFX_PANEL)
			setButtonEnabled(var0_63, not var4_63)

			GetOrAddComponent(arg2_63, typeof(CanvasGroup)).alpha = var4_63 and 0.5 or 1

			arg0_62:UpdateOptionTxt(var3_62, var0_63, var1_63, var3_63)

			if arg0_62.script:IsDialogueStyle2() then
				setActive(var0_63, arg1_63 == 0)

				if arg1_63 > 0 then
					LeanTween.delayedCall(0.066 * arg1_63, System.Action(function()
						setActive(var0_63, true)
					end))
				end
			end
		end
	end)
	var2_62:align(#var1_62)
	arg0_62:ShowBranches(arg2_62, function()
		var0_62 = true

		if arg4_62 then
			arg4_62()
		end
	end)
end

function var0_0.SetBranchCode(arg0_68, arg1_68, arg2_68, arg3_68)
	arg2_68:SetBranchCode(arg3_68)
	arg1_68:SetBranchCode(arg3_68)

	local var0_68 = arg2_68:GetId()

	if not arg0_68.branchCodeList[var0_68] then
		arg0_68.branchCodeList[var0_68] = {}
	end

	table.insert(arg0_68.branchCodeList[var0_68], arg3_68)
end

function var0_0.ShowBranches(arg0_69, arg1_69, arg2_69)
	setActive(arg0_69.optionsCg.gameObject, true)

	local var0_69 = arg0_69:GetOptionContainer(arg1_69)

	for iter0_69 = 0, var0_69.container.childCount - 1 do
		local var1_69 = var0_69.container:GetChild(iter0_69):GetComponent(typeof(Animation))

		if var1_69 then
			var1_69:Play(arg0_69.script:GetAnimPrefix() .. "in")
		end
	end

	arg2_69()
end

function var0_0.HideBranchesWithoutSelected(arg0_70, arg1_70)
	local var0_70 = arg0_70:GetOptionContainer(arg1_70)

	for iter0_70 = 0, var0_70.container.childCount - 1 do
		if iter0_70 ~= arg0_70.selectedBranchID then
			local var1_70 = var0_70.container:GetChild(iter0_70):GetComponent(typeof(Animation))

			if var1_70 then
				var1_70:Play(arg0_70.script:GetAnimPrefix() .. "unselected")
			end
		end
	end
end

function var0_0.StartMoveNode(arg0_71, arg1_71, arg2_71)
	if not arg1_71:ExistMovableNode() then
		arg2_71()

		return
	end

	local var0_71 = arg1_71:GetMovableNode()
	local var1_71 = {}
	local var2_71 = {}

	for iter0_71, iter1_71 in pairs(var0_71) do
		table.insert(var1_71, function(arg0_72)
			arg0_71:LoadMovableNode(iter1_71, function(arg0_73)
				var2_71[iter0_71] = arg0_73

				arg0_72()
			end)
		end)
	end

	parallelAsync(var1_71, function()
		arg0_71:MoveAllNode(arg1_71, var2_71, var0_71)
		arg2_71()
	end)
end

function var0_0.MoveAllNode(arg0_75, arg1_75, arg2_75, arg3_75)
	local var0_75 = {}

	for iter0_75, iter1_75 in pairs(arg2_75) do
		table.insert(var0_75, function(arg0_76)
			local var0_76 = arg3_75[iter0_75]
			local var1_76 = var0_76.path
			local var2_76 = var0_76.time
			local var3_76 = var0_76.easeType
			local var4_76 = var0_76.delay

			arg0_75:moveLocalPath(iter1_75, var1_76, var2_76, var4_76, var3_76, arg0_76)
		end)
	end

	arg0_75.moveTargets = arg2_75

	parallelAsync(var0_75, function()
		arg0_75:ClearMoveNodes(arg1_75)
	end)
end

local function var12_0(arg0_78, arg1_78, arg2_78, arg3_78, arg4_78)
	PoolMgr.GetInstance():GetSpineChar(arg1_78, true, function(arg0_79)
		arg0_79.transform:SetParent(arg0_78.movePanel)

		local var0_79 = arg2_78.scale

		arg0_79.transform.localScale = Vector3(var0_79, var0_79, 0)
		arg0_79.transform.localPosition = arg3_78

		arg0_79:GetComponent(typeof(SpineAnimUI)):SetAction(arg2_78.action, 0)

		arg0_79.name = arg1_78

		if arg4_78 then
			arg4_78(arg0_79)
		end
	end)
end

local function var13_0(arg0_80, arg1_80, arg2_80, arg3_80)
	local var0_80 = GameObject.New("movable")

	var0_80.transform:SetParent(arg0_80.movePanel)

	var0_80.transform.localScale = Vector3.zero

	local var1_80 = GetOrAddComponent(var0_80, typeof(RectTransform))
	local var2_80 = GetOrAddComponent(var0_80, typeof(Image))

	LoadSpriteAsync(arg1_80, function(arg0_81)
		var2_80.sprite = arg0_81

		var2_80:SetNativeSize()

		var1_80.localScale = Vector3.one
		var1_80.localPosition = arg2_80

		arg3_80(var1_80.gameObject)
	end)
end

function var0_0.LoadMovableNode(arg0_82, arg1_82, arg2_82)
	local var0_82 = arg1_82.path[1] or Vector3.zero

	if arg1_82.isSpine then
		var12_0(arg0_82, arg1_82.name, arg1_82.spineData, var0_82, arg2_82)
	else
		var13_0(arg0_82, arg1_82.name, var0_82, arg2_82)
	end
end

function var0_0.ClearMoveNodes(arg0_83, arg1_83)
	if not arg1_83:ExistMovableNode() then
		return
	end

	if arg0_83.movePanel.childCount <= 0 then
		return
	end

	for iter0_83, iter1_83 in ipairs(arg0_83.moveTargets or {}) do
		if iter1_83:GetComponent(typeof(SpineAnimUI)) ~= nil then
			PoolMgr.GetInstance():ReturnSpineChar(iter1_83.name, iter1_83.gameObject)
		else
			Destroy(arg0_83.movePanel:GetChild(iter0_83 - 1))
		end
	end

	arg0_83.moveTargets = {}
end

function var0_0.FadeOutStory(arg0_84, arg1_84, arg2_84)
	if not arg1_84:ShouldFadeout() then
		arg2_84()

		return
	end

	local var0_84 = arg1_84:GetFadeoutTime()

	if not arg1_84:ShouldWaitFadeout() then
		arg0_84:fadeTransform(arg0_84._go, 1, 0.3, var0_84, true)
		arg2_84()
	else
		arg0_84:fadeTransform(arg0_84._go, 1, 0.3, var0_84, true, arg2_84)
	end
end

function var0_0.GetFadeColor(arg0_85, arg1_85)
	local var0_85 = {}
	local var1_85 = {}
	local var2_85 = arg1_85:GetComponentsInChildren(typeof(Image)):ToTable()

	for iter0_85, iter1_85 in ipairs(var2_85) do
		local var3_85 = {
			name = "_Color",
			color = Color.white
		}

		if iter1_85.material.shader.name == "UI/GrayScale" then
			var3_85 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif iter1_85.material.shader.name == "UI/Line_Add_Blue" then
			var3_85 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_85, var3_85)

		if iter1_85.material == iter1_85.defaultGraphicMaterial then
			iter1_85.material = Material.Instantiate(iter1_85.defaultGraphicMaterial)
		end

		table.insert(var0_85, iter1_85.material)
	end

	return var0_85, var1_85
end

function var0_0._SetFadeColor(arg0_86, arg1_86, arg2_86, arg3_86)
	for iter0_86, iter1_86 in ipairs(arg1_86) do
		if not IsNil(iter1_86) then
			iter1_86:SetColor(arg2_86[iter0_86].name, arg2_86[iter0_86].color * Color.New(arg3_86, arg3_86, arg3_86))
		end
	end
end

function var0_0.SetFadeColor(arg0_87, arg1_87, arg2_87)
	local var0_87, var1_87 = arg0_87:GetFadeColor(arg1_87)

	arg0_87:_SetFadeColor(var0_87, var1_87, arg2_87)
end

function var0_0._RevertFadeColor(arg0_88, arg1_88, arg2_88)
	arg0_88:_SetFadeColor(arg1_88, arg2_88, 1)
end

function var0_0.RevertFadeColor(arg0_89, arg1_89)
	local var0_89, var1_89 = arg0_89:GetFadeColor(arg1_89)

	arg0_89:_RevertFadeColor(var0_89, var1_89)
end

function var0_0.fadeTransform(arg0_90, arg1_90, arg2_90, arg3_90, arg4_90, arg5_90, arg6_90)
	if arg4_90 <= 0 then
		if arg6_90 then
			arg6_90()
		end

		return
	end

	local var0_90, var1_90 = arg0_90:GetFadeColor(arg1_90)

	LeanTween.value(go(arg1_90), arg2_90, arg3_90, arg4_90):setOnUpdate(System.Action_float(function(arg0_91)
		arg0_90:_SetFadeColor(var0_90, var1_90, arg0_91)
	end)):setOnComplete(System.Action(function()
		if arg5_90 then
			arg0_90:_RevertFadeColor(var0_90, var1_90)
		end

		if arg6_90 then
			arg6_90()
		end
	end))
end

function var0_0.setPaintingAlpha(arg0_93, arg1_93, arg2_93)
	local var0_93 = {}
	local var1_93 = {}
	local var2_93 = arg1_93:GetComponentsInChildren(typeof(Image)):ToTable()

	for iter0_93, iter1_93 in ipairs(var2_93) do
		local var3_93 = {
			name = "_Color",
			color = Color.white
		}

		if iter1_93.material.shader.name == "UI/GrayScale" then
			var3_93 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif iter1_93.material.shader.name == "UI/Line_Add_Blue" then
			var3_93 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_93, var3_93)

		if iter1_93.material == iter1_93.defaultGraphicMaterial then
			iter1_93.material = Material.Instantiate(iter1_93.defaultGraphicMaterial)
		end

		table.insert(var0_93, iter1_93.material)
	end

	for iter2_93, iter3_93 in ipairs(var0_93) do
		if not IsNil(iter3_93) then
			iter3_93:SetColor(var1_93[iter2_93].name, var1_93[iter2_93].color * Color.New(arg2_93, arg2_93, arg2_93))
		end
	end
end

function var0_0.RegisetEvent(arg0_94, arg1_94, arg2_94)
	setButtonEnabled(arg0_94._go, not arg0_94.autoNext)
	onButton(arg0_94, arg0_94._go, function()
		if arg0_94.pause or arg0_94.stop then
			return
		end

		removeOnButton(arg0_94._go)
		arg2_94()
	end, SFX_PANEL)
end

function var0_0.flashEffect(arg0_96, arg1_96, arg2_96, arg3_96, arg4_96, arg5_96, arg6_96)
	arg0_96.flashImg.color = arg4_96 and Color(0, 0, 0) or Color(1, 1, 1)
	arg0_96.flashCg.alpha = arg1_96

	setActive(arg0_96.flash, true)
	arg0_96:TweenValueForcanvasGroup(arg0_96.flashCg, arg1_96, arg2_96, arg3_96, arg5_96, arg6_96)
end

function var0_0.Flashout(arg0_97, arg1_97, arg2_97)
	local var0_97, var1_97, var2_97, var3_97 = arg1_97:GetFlashoutData()

	if not var0_97 then
		arg2_97()

		return
	end

	arg0_97:flashEffect(var0_97, var1_97, var2_97, var3_97, 0, arg2_97)
end

function var0_0.flashin(arg0_98, arg1_98, arg2_98)
	local var0_98, var1_98, var2_98, var3_98, var4_98 = arg1_98:GetFlashinData()

	if not var0_98 then
		arg2_98()

		return
	end

	arg0_98:flashEffect(var0_98, var1_98, var2_98, var3_98, var4_98, arg2_98)
end

function var0_0.UpdateBg(arg0_99, arg1_99)
	if arg1_99:ShouldBgGlitchArt() then
		arg0_99:SetBgGlitchArt(arg1_99)
	else
		local var0_99 = arg1_99:GetBgName()

		if var0_99 then
			setActive(arg0_99.bgPanel, true)

			arg0_99.bgPanelCg.alpha = 1

			local var1_99 = arg0_99.bgImage

			var1_99.color = Color.New(1, 1, 1)
			var1_99.sprite = arg0_99:GetBg(var0_99)
		end

		local var2_99 = arg1_99:GetBgShadow()

		if var2_99 then
			local var3_99 = arg0_99.bgImage

			arg0_99:TweenValue(var3_99, var2_99[1], var2_99[2], var2_99[3], 0, function(arg0_100)
				var3_99.color = Color.New(arg0_100, arg0_100, arg0_100)
			end, nil)
		end

		if arg1_99:IsBlackBg() then
			setActive(arg0_99.curtain, true)

			arg0_99.curtainCg.alpha = 1
		end

		local var4_99, var5_99 = arg1_99:IsBlackFrontGround()

		if var4_99 then
			arg0_99.curtainFCg.alpha = var5_99
		end

		setActive(arg0_99.curtainF, var4_99)
	end

	arg0_99:ApplyOldPhotoEffect(arg1_99)
	arg0_99:OnBgUpdate(arg1_99)

	local var6_99 = arg1_99:GetBgColor()

	arg0_99.curtain:GetComponent(typeof(Image)).color = var6_99
end

function var0_0.ApplyOldPhotoEffect(arg0_101, arg1_101)
	local var0_101 = arg1_101:OldPhotoEffect()
	local var1_101 = var0_101 ~= nil

	setActive(arg0_101.oldPhoto.gameObject, var1_101)

	if var1_101 then
		if type(var0_101) == "table" then
			arg0_101.oldPhoto.color = Color.New(var0_101[1], var0_101[2], var0_101[3], var0_101[4])
		else
			arg0_101.oldPhoto.color = Color.New(0.62, 0.58, 0.14, 0.36)
		end
	end
end

function var0_0.SetBgGlitchArt(arg0_102, arg1_102)
	setActive(arg0_102.bgPanel, false)
	setActive(arg0_102.bgGlitch, true)
end

function var0_0.GetBg(arg0_103, arg1_103)
	if not arg0_103.bgs[arg1_103] then
		arg0_103.bgs[arg1_103] = LoadSprite("bg/" .. arg1_103)
	end

	return arg0_103.bgs[arg1_103]
end

function var0_0.LoadEffects(arg0_104, arg1_104, arg2_104)
	local var0_104 = arg1_104:GetEffects()

	if #var0_104 <= 0 then
		arg2_104()

		return
	end

	local var1_104 = {}

	for iter0_104, iter1_104 in ipairs(var0_104) do
		local var2_104 = iter1_104.name
		local var3_104 = iter1_104.active
		local var4_104 = iter1_104.interlayer
		local var5_104 = iter1_104.center
		local var6_104 = iter1_104.adapt
		local var7_104 = arg0_104.effectPanel:Find(var2_104) or arg0_104.centerPanel:Find(var2_104)

		if var7_104 then
			setActive(var7_104, var3_104)
			setParent(var7_104, var5_104 and arg0_104.centerPanel or arg0_104.effectPanel.transform)

			if var4_104 then
				arg0_104:UpdateEffectInterLayer(var2_104, var7_104)
			end

			if not var3_104 then
				arg0_104:ClearEffectInterlayer(var2_104)
			elseif isActive(var7_104) then
				setActive(var7_104, false)
				setActive(var7_104, true)
			end

			if var6_104 then
				arg0_104:AdaptEffect(var7_104)
			end
		else
			local var8_104 = ""

			if checkABExist("ui/" .. var2_104) then
				var8_104 = "ui"
			elseif checkABExist("effect/" .. var2_104) then
				var8_104 = "effect"
			end

			if var8_104 and var8_104 ~= "" then
				table.insert(var1_104, function(arg0_105)
					LoadAndInstantiateAsync(var8_104, var2_104, function(arg0_106)
						setParent(arg0_106, var5_104 and arg0_104.centerPanel or arg0_104.effectPanel.transform)

						arg0_106.transform.localScale = Vector3.one

						setActive(arg0_106, var3_104)

						arg0_106.name = var2_104

						if var4_104 then
							arg0_104:UpdateEffectInterLayer(var2_104, arg0_106)
						end

						if var3_104 == false then
							arg0_104:ClearEffectInterlayer(var2_104)
						end

						if var6_104 then
							arg0_104:AdaptEffect(arg0_106)
						end

						arg0_105()
					end)
				end)
			else
				originalPrint("not found effect", var2_104)
			end
		end
	end

	parallelAsync(var1_104, arg2_104)
end

function var0_0.AdaptEffect(arg0_107, arg1_107)
	local var0_107 = 1.77777777777778
	local var1_107 = pg.UIMgr.GetInstance().OverlayMain.parent.sizeDelta
	local var2_107 = var1_107.x / var1_107.y
	local var3_107 = 1

	if var0_107 < var2_107 then
		var3_107 = var2_107 / var0_107
	else
		var3_107 = var0_107 / var2_107
	end

	tf(arg1_107).localScale = Vector3(var3_107, var3_107, var3_107)
end

function var0_0.UpdateEffectInterLayer(arg0_108, arg1_108, arg2_108)
	local var0_108 = arg0_108._go:GetComponent(typeof(Canvas)).sortingOrder
	local var1_108 = arg2_108:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer")):ToTable()

	for iter0_108, iter1_108 in ipairs(var1_108) do
		local var2_108 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", iter1_108)

		if var0_108 < var2_108 then
			var0_108 = var2_108
		end
	end

	local var3_108 = var0_108 + 1
	local var4_108 = GetOrAddComponent(arg0_108.actorTr, typeof(Canvas))

	var4_108.overrideSorting = true
	var4_108.sortingOrder = var3_108

	local var5_108 = GetOrAddComponent(arg0_108.frontTr, typeof(Canvas))

	var5_108.overrideSorting = true
	var5_108.sortingOrder = var3_108 + 1
	arg0_108.activeInterLayer = arg1_108

	GetOrAddComponent(arg0_108.frontTr, typeof(GraphicRaycaster))
end

function var0_0.ClearEffectInterlayer(arg0_109, arg1_109)
	if arg0_109.activeInterLayer == arg1_109 then
		RemoveComponent(arg0_109.frontTr, "GraphicRaycaster")
		RemoveComponent(arg0_109.actorTr, "Canvas")
		RemoveComponent(arg0_109.frontTr, "Canvas")

		arg0_109.activeInterLayer = nil
	end
end

function var0_0.ClearEffects(arg0_110)
	removeAllChildren(arg0_110.effectPanel)
	removeAllChildren(arg0_110.centerPanel)

	if arg0_110.activeInterLayer ~= nil then
		arg0_110:ClearEffectInterlayer(arg0_110.activeInterLayer)
	end
end

function var0_0.PlaySoundEffect(arg0_111, arg1_111)
	if arg1_111:ShouldPlaySoundEffect() then
		local var0_111, var1_111 = arg1_111:GetSoundeffect()

		arg0_111:DelayCall(var1_111, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_111)
		end)
	end

	if arg1_111:ShouldPlayVoice() then
		arg0_111:PlayVoice(arg1_111)
	elseif arg1_111:ShouldStopVoice() then
		arg0_111:StopVoice()
	end
end

function var0_0.StopVoice(arg0_113)
	if arg0_113.currentVoice then
		arg0_113.currentVoice:Stop(true)

		arg0_113.currentVoice = nil
	end
end

function var0_0.PlayVoice(arg0_114, arg1_114)
	if arg0_114.voiceDelayTimer then
		arg0_114.voiceDelayTimer:Stop()

		arg0_114.voiceDelayTimer = nil
	end

	arg0_114:StopVoice()

	local var0_114, var1_114 = arg1_114:GetVoice()
	local var2_114

	var2_114 = arg0_114:CreateDelayTimer(var1_114, function()
		if var2_114 then
			var2_114:Stop()
		end

		if arg0_114.voiceDelayTimer then
			arg0_114.voiceDelayTimer = nil
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_114, function(arg0_116)
			if arg0_116 then
				arg0_114.currentVoice = arg0_116.playback
			end
		end)
	end)
	arg0_114.voiceDelayTimer = var2_114
end

function var0_0.Reset(arg0_117, arg1_117, arg2_117, arg3_117)
	setActive(arg0_117.spAnimPanel, false)
	setActive(arg0_117.castPanel, false)
	setActive(arg0_117.bgPanel, false)

	if arg1_117 and arg1_117:IsDialogueMode() and arg2_117 and arg2_117:IsDialogueMode() then
		-- block empty
	else
		setActive(arg0_117.dialoguePanel, false)
	end

	setActive(arg0_117.asidePanel, false)
	setActive(arg0_117.curtain, false)
	setActive(arg0_117.flash, false)
	setActive(arg0_117.optionsCg.gameObject, false)
	setActive(arg0_117.bgGlitch, false)
	setActive(arg0_117.locationTr, false)

	arg0_117.locationTr.localPosition = arg0_117.locationTrPos
	arg0_117.locationStatus = var9_0
	arg0_117.flashCg.alpha = 1
	arg0_117.goCG.alpha = 1

	arg0_117.animationPlayer:Stop()
	arg0_117:OnReset(arg1_117, arg2_117, arg3_117)
end

function var0_0.Clear(arg0_118, arg1_118)
	if arg0_118.step then
		arg0_118:ClearMoveNodes(arg0_118.step)
	end

	arg0_118.bgs = {}
	arg0_118.skipOption = nil
	arg0_118.step = nil
	arg0_118.goCG.alpha = 1
	arg0_118.callback = nil
	arg0_118.autoNext = nil
	arg0_118.script = nil
	arg0_118.bgImage.sprite = nil

	arg0_118:OnClear()

	if arg1_118 then
		arg1_118()
	end

	pg.DelegateInfo.New(arg0_118)
end

function var0_0.StoryEnd(arg0_119, arg1_119)
	setActive(arg0_119.iconImage.gameObject, false)

	arg0_119.iconImage.sprite = nil
	arg0_119.branchCodeList = {}
	arg0_119.stop = false
	arg0_119.pause = false

	if arg0_119.voiceDelayTimer then
		arg0_119.voiceDelayTimer:Stop()

		arg0_119.voiceDelayTimer = nil
	end

	if arg0_119.currentVoice then
		arg0_119.currentVoice:Stop(true)

		arg0_119.currentVoice = nil
	end

	arg0_119:ClearCheckDispatcher()
	arg0_119:ClearEffects()
	arg0_119:Clear()
	arg0_119:OnEnd(arg1_119)
end

function var0_0.PlayBgm(arg0_120, arg1_120)
	if arg1_120:ShouldStopBgm() then
		arg0_120:StopBgm()
	end

	if arg1_120:ShoulePlayBgm() then
		local var0_120, var1_120, var2_120 = arg1_120:GetBgmData()

		arg0_120:DelayCall(var1_120, function()
			arg0_120:RevertBgmVolume()
			pg.BgmMgr.GetInstance():TempPlay(var0_120)
		end)

		if var2_120 and var2_120 > 0 then
			arg0_120.defaultBgmVolume = pg.CriMgr.GetInstance():getBGMVolume()

			pg.CriMgr.GetInstance():setBGMVolume(var2_120)
		end
	end
end

function var0_0.StopBgm(arg0_122, arg1_122)
	arg0_122:RevertBgmVolume()
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.RevertBgmVolume(arg0_123)
	if arg0_123.defaultBgmVolume then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_123.defaultBgmVolume)

		arg0_123.defaultBgmVolume = nil
	end
end

function var0_0.StartUIAnimations(arg0_124, arg1_124, arg2_124)
	parallelAsync({
		function(arg0_125)
			arg0_124:StartBlinkAnimation(arg1_124, arg0_125)
		end,
		function(arg0_126)
			arg0_124:StartBlinkWithColorAnimation(arg1_124, arg0_126)
		end,
		function(arg0_127)
			arg0_124:OnStartUIAnimations(arg1_124, arg0_127)
		end
	}, arg2_124)
end

function var0_0.StartBlinkAnimation(arg0_128, arg1_128, arg2_128)
	if arg1_128:ShouldBlink() then
		local var0_128 = arg1_128:GetBlinkData()
		local var1_128 = var0_128.black
		local var2_128 = var0_128.number
		local var3_128 = var0_128.dur
		local var4_128 = var0_128.delay
		local var5_128 = var0_128.alpha[1]
		local var6_128 = var0_128.alpha[2]
		local var7_128 = var0_128.wait

		arg0_128.flashImg.color = var1_128 and Color(0, 0, 0) or Color(1, 1, 1)

		setActive(arg0_128.flash, true)

		local var8_128 = {}

		for iter0_128 = 1, var2_128 do
			table.insert(var8_128, function(arg0_129)
				arg0_128:TweenAlpha(arg0_128.flash, var5_128, var6_128, var3_128 / 2, 0, function()
					arg0_128:TweenAlpha(arg0_128.flash, var6_128, var5_128, var3_128 / 2, var7_128, arg0_129)
				end)
			end)
		end

		seriesAsync(var8_128, function()
			setActive(arg0_128.flash, false)
		end)
	end

	arg2_128()
end

function var0_0.StartBlinkWithColorAnimation(arg0_132, arg1_132, arg2_132)
	if arg1_132:ShouldBlinkWithColor() then
		local var0_132 = arg1_132:GetBlinkWithColorData()
		local var1_132 = var0_132.color
		local var2_132 = var0_132.alpha

		arg0_132.flashImg.color = Color(var1_132[1], var1_132[2], var1_132[3], var1_132[4])

		setActive(arg0_132.flash, true)

		local var3_132 = {}

		for iter0_132, iter1_132 in ipairs(var2_132) do
			local var4_132 = iter1_132[1]
			local var5_132 = iter1_132[2]
			local var6_132 = iter1_132[3]
			local var7_132 = iter1_132[4]

			table.insert(var3_132, function(arg0_133)
				arg0_132:TweenValue(arg0_132.flash, var4_132, var5_132, var6_132, var7_132, function(arg0_134)
					arg0_132.flashCg.alpha = arg0_134
				end, arg0_133)
			end)
		end

		parallelAsync(var3_132, function()
			setActive(arg0_132.flash, false)
		end)
	end

	arg2_132()
end

function var0_0.findTF(arg0_136, arg1_136, arg2_136)
	assert(arg0_136._tf, "transform should exist")

	return findTF(arg2_136 or arg0_136._tf, arg1_136)
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
