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

function var0_0.StoryStart(arg0_2, arg1_2)
	arg0_2.branchCodeList = {}

	eachChild(arg0_2.dialoguePanel, function(arg0_3)
		setActive(arg0_3, false)
	end)

	arg0_2.dialogueWin = arg0_2.dialoguePanel:Find(arg1_2:GetDialogueStyleName())

	setActive(arg0_2.dialogueWin, true)

	arg0_2.optionLUIlist = UIItemList.New(arg0_2.dialogueWin:Find("options_panel/options_l"), arg0_2.dialogueWin:Find("options_panel/options_l/option_tpl"))
	arg0_2.optionCUIlist = UIItemList.New(arg0_2.dialogueWin:Find("options_panel/options_c"), arg0_2.dialogueWin:Find("options_panel/options_c/option_tpl"))
	arg0_2.optionsCg = arg0_2.dialogueWin:Find("options_panel"):GetComponent(typeof(CanvasGroup))

	arg0_2:OnStart(arg1_2)
end

function var0_0.GetOptionContainer(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetOptionCnt()

	if arg0_4.script:IsDialogueStyle2() then
		setActive(arg0_4.optionLUIlist.container, true)
		setActive(arg0_4.optionCUIlist.container, false)

		return arg0_4.optionLUIlist, true
	end

	if var0_4 <= 3 then
		setActive(arg0_4.optionLUIlist.container, false)
		setActive(arg0_4.optionCUIlist.container, true)

		return arg0_4.optionCUIlist, false
	else
		setActive(arg0_4.optionLUIlist.container, true)
		setActive(arg0_4.optionCUIlist.container, false)

		return arg0_4.optionLUIlist, true
	end
end

function var0_0.Pause(arg0_5)
	arg0_5.pause = true

	arg0_5:PauseAllAnimation()
	pg.ViewUtils.SetLayer(arg0_5.effectPanel, Layer.UIHidden)
end

function var0_0.Resume(arg0_6)
	arg0_6.pause = false

	arg0_6:ResumeAllAnimation()
	pg.ViewUtils.SetLayer(arg0_6.effectPanel, Layer.UI)
end

function var0_0.Stop(arg0_7)
	arg0_7.stop = true

	arg0_7:NextOneImmediately()
end

function var0_0.Play(arg0_8, arg1_8, arg2_8, arg3_8)
	if not arg1_8 then
		arg3_8()

		return
	end

	if arg1_8:GetNextScriptName() or arg0_8.stop then
		arg3_8()

		return
	end

	local var0_8 = arg1_8:GetStepByIndex(arg2_8)

	if not var0_8 then
		arg3_8()

		return
	end

	pg.NewStoryMgr.GetInstance():AddRecord(var0_8)

	if var0_8:ShouldJumpToNextScript() then
		arg1_8:SetNextScriptName(var0_8:GetNextScriptName())
		arg3_8()

		return
	end

	local var1_8 = arg1_8:ShouldSkipAll()

	if var1_8 then
		arg0_8:ClearEffects()
	end

	local var2_8 = false

	if var1_8 and var0_8:IsImport() and not pg.NewStoryMgr.GetInstance():IsReView() then
		var2_8 = true
	elseif var1_8 then
		arg3_8()

		return
	end

	arg0_8.script = arg1_8
	arg0_8.callback = arg3_8
	arg0_8.step = var0_8
	arg0_8.autoNext = arg1_8:GetAutoPlayFlag()
	arg0_8.stage = var1_0

	local var3_8 = arg1_8:GetTriggerDelayTime()

	if arg0_8.autoNext and var0_8:IsImport() and not var0_8.optionSelCode then
		arg0_8.autoNext = nil
	end

	arg0_8:SetTimeScale(1 - arg1_8:GetPlaySpeed() * 0.1)

	local var4_8 = arg1_8:GetPrevStep(arg2_8)

	seriesAsync({
		function(arg0_9)
			if not arg0_8:NextStage(var2_0) then
				return
			end

			parallelAsync({
				function(arg0_10)
					arg0_8:Reset(var0_8, var4_8, arg0_10)
					arg0_8:UpdateBg(var0_8)
					arg0_8:PlayBgm(var0_8)
				end,
				function(arg0_11)
					arg0_8:LoadEffects(var0_8, arg0_11)
				end,
				function(arg0_12)
					arg0_8:ApplyEffects(var0_8, arg0_12)
				end,
				function(arg0_13)
					arg0_8:flashin(var0_8, arg0_13)
				end
			}, arg0_9)
		end,
		function(arg0_14)
			if var2_8 then
				arg1_8:StopSkip()
			end

			var2_8 = false

			arg0_14()
		end,
		function(arg0_15)
			if not arg0_8:NextStage(var3_0) then
				return
			end

			parallelAsync({
				function(arg0_16)
					arg0_8:OnInit(var0_8, var4_8, arg0_16)
				end,
				function(arg0_17)
					arg0_8:PlaySoundEffect(var0_8)
					arg0_8:StartUIAnimations(var0_8, arg0_17)
				end,
				function(arg0_18)
					arg0_8:OnEnter(var0_8, var4_8, arg0_18)
				end,
				function(arg0_19)
					arg0_8:StartMoveNode(var0_8, arg0_19)
				end,
				function(arg0_20)
					arg0_8:UpdateIcon(var0_8, arg0_20)
				end,
				function(arg0_21)
					arg0_8:SetLocation(var0_8, arg0_21)
				end,
				function(arg0_22)
					if arg0_8:DispatcherEvent(var0_8, arg0_22) then
						arg0_8.autoNext = true
						var3_8 = 0
					end
				end
			}, arg0_15)
		end,
		function(arg0_23)
			arg0_8:ClearCheckDispatcher()

			if not arg0_8:NextStage(var4_0) then
				return
			end

			if not var0_8:ShouldDelayEvent() then
				arg0_23()

				return
			end

			arg0_8:DelayCall(var0_8:GetEventDelayTime(), arg0_23)
		end,
		function(arg0_24)
			if not arg0_8:NextStage(var5_0) then
				return
			end

			if arg0_8.skipOption then
				arg0_24()

				return
			end

			if var0_8:SkipEventForOption() then
				arg0_24()

				return
			end

			if arg0_8:ShouldAutoTrigger() then
				arg0_8:UnscaleDelayCall(var3_8, arg0_24)

				return
			end

			arg0_8:RegisetEvent(var0_8, arg0_24)
			arg0_8:TriggerEventIfAuto(var3_8)
		end,
		function(arg0_25)
			if not arg0_8:NextStage(var6_0) then
				return
			end

			if not var0_8:ExistOption() then
				arg0_25()

				return
			end

			if arg0_8.skipOption then
				arg0_8.skipOption = false

				arg0_25()

				return
			end

			arg0_8:InitBranches(arg1_8, var0_8, function(arg0_26)
				arg0_25()
			end, function()
				arg0_8:TriggerOptionIfAuto(var3_8, var0_8)
			end)
		end,
		function(arg0_28)
			if not arg0_8:NextStage(var7_0) then
				return
			end

			arg0_8.autoNext = nil

			local var0_28 = arg1_8:GetNextStep(arg2_8)

			seriesAsync({
				function(arg0_29)
					arg0_8:ClearAnimation()
					arg0_8:ClearApplyEffect()
					arg0_8:OnWillExit(var0_8, var0_28, arg0_29)
				end,
				function(arg0_30)
					parallelAsync({
						function(arg0_31)
							if not var0_28 then
								arg0_31()

								return
							end

							arg0_8:Flashout(var0_28, arg0_31)
						end,
						function(arg0_32)
							if var0_28 then
								arg0_32()

								return
							end

							arg0_8:FadeOutStory(arg0_8.script, arg0_32)
						end
					}, arg0_30)
				end
			}, arg0_28)
		end,
		function(arg0_33)
			if not arg0_8:NextStage(var8_0) then
				return
			end

			arg0_8:OnWillClear(var0_8)
			arg0_8:Clear(arg0_33)
		end
	}, arg3_8)
end

function var0_0.NextStage(arg0_34, arg1_34)
	if arg0_34.stage == arg1_34 - 1 then
		arg0_34.stage = arg1_34

		return true
	end

	return false
end

function var0_0.ApplyEffects(arg0_35, arg1_35, arg2_35)
	if arg1_35:ShouldShake() then
		arg0_35:ApplyShakeEffect(arg1_35)
	end

	arg2_35()
end

function var0_0.ApplyShakeEffect(arg0_36, arg1_36)
	if not arg1_36:ShouldShake() then
		return
	end

	arg0_36.animationPlayer:Play("anim_storyrecordUI_shake_loop")

	local var0_36 = arg1_36:GetShakeTime()

	arg0_36.playingShakeAnim = true

	arg0_36:DelayCall(var0_36, function()
		arg0_36:ClearShakeEffect()
	end)
end

function var0_0.ClearShakeEffect(arg0_38)
	if arg0_38.playingShakeAnim then
		arg0_38.animationPlayer:Play("anim_storyrecordUI_shake_reset")

		arg0_38.playingShakeAnim = nil
	end
end

function var0_0.ClearApplyEffect(arg0_39)
	arg0_39:ClearShakeEffect()
end

function var0_0.DispatcherEvent(arg0_40, arg1_40, arg2_40)
	if not arg1_40:ExistDispatcher() then
		arg2_40()

		return
	end

	local var0_40 = arg1_40:GetDispatcher()

	pg.NewStoryMgr.GetInstance():ClearStoryEvent()
	pg.m02:sendNotification(var0_40.name, {
		data = var0_40.data,
		callbackData = var0_40.callbackData,
		flags = arg0_40.branchCodeList[arg1_40:GetId()] or {}
	})

	if arg1_40:ShouldHideUI() then
		setActive(arg0_40._tf, false)
	end

	if arg1_40:IsRecallDispatcher() then
		arg0_40:CheckDispatcher(arg1_40, arg2_40)
	else
		arg2_40()
	end

	return var0_40.nextOne
end

function var0_0.WaitForEvent(arg0_41)
	return arg0_41.checkTimer ~= nil
end

function var0_0.CheckDispatcher(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg1_42:GetDispatcherRecallName()

	arg0_42:ClearCheckDispatcher()

	arg0_42.checkTimer = Timer.New(function()
		if pg.NewStoryMgr.GetInstance():CheckStoryEvent(var0_42) then
			local var0_43 = pg.NewStoryMgr.GetInstance():GetStoryEventArg(var0_42)

			if var0_43 then
				existCall(var0_43.notifiCallback)
			end

			if var0_43 and var0_43.optionIndex then
				arg0_42:SetBranchCode(arg0_42.script, arg1_42, var0_43.optionIndex)

				arg0_42.skipOption = true
			end

			if arg1_42:ShouldHideUI() then
				setActive(arg0_42._tf, true)
			end

			arg0_42:ClearCheckDispatcher()
			arg2_42()
		end
	end, 1, -1)

	arg0_42.checkTimer:Start()
	arg0_42.checkTimer.func()
end

function var0_0.ClearCheckDispatcher(arg0_44)
	if arg0_44.checkTimer then
		arg0_44.checkTimer:Stop()

		arg0_44.checkTimer = nil
	end
end

function var0_0.TriggerEventIfAuto(arg0_45, arg1_45)
	if not arg0_45:ShouldAutoTrigger() then
		return
	end

	arg0_45:UnscaleDelayCall(arg1_45, function()
		if not arg0_45.autoNext then
			setButtonEnabled(arg0_45._go, true)

			return
		end

		triggerButton(arg0_45._go)
	end)
end

function var0_0.TriggerOptionIfAuto(arg0_47, arg1_47, arg2_47)
	if not arg0_47:ShouldAutoTrigger() then
		return
	end

	if not arg2_47 or not arg2_47:ExistOption() then
		return
	end

	arg0_47:UnscaleDelayCall(arg1_47, function()
		if not arg0_47.autoNext then
			return
		end

		local var0_48 = arg2_47:GetOptionIndexByAutoSel()

		if var0_48 ~= nil then
			local var1_48 = arg0_47:GetOptionContainer(arg2_47).container:GetChild(var0_48 - 1)

			triggerButton(var1_48)
		end
	end)
end

function var0_0.ShouldAutoTrigger(arg0_49)
	if arg0_49.pause or arg0_49.stop then
		return false
	end

	return arg0_49.autoNext
end

function var0_0.CanSkip(arg0_50)
	return arg0_50.step and not arg0_50.step:IsImport()
end

function var0_0.CancelAuto(arg0_51)
	arg0_51.autoNext = false
end

function var0_0.NextOne(arg0_52)
	arg0_52.timeScale = 0.0001

	if arg0_52.stage == var1_0 then
		arg0_52.autoNext = true
	elseif arg0_52.stage == var5_0 then
		arg0_52.autoNext = true

		arg0_52:TriggerEventIfAuto(0)
	elseif arg0_52.stage == var6_0 then
		arg0_52:TriggerOptionIfAuto(0, arg0_52.step)
	end
end

function var0_0.NextOneImmediately(arg0_53)
	local var0_53 = arg0_53.callback

	if var0_53 then
		arg0_53:ClearAnimation()
		arg0_53:Clear()
		var0_53()
	end
end

function var0_0.SetLocation(arg0_54, arg1_54, arg2_54)
	if not arg1_54:ExistLocation() then
		arg0_54.locationAniEvent:SetEndEvent(nil)
		arg2_54()

		return
	end

	setActive(arg0_54.locationTr, true)

	local var0_54 = arg1_54:GetLocation()

	arg0_54.locationTxt.text = var0_54.text

	local function var1_54()
		arg0_54:DelayCall(var0_54.time, function()
			arg0_54.locationAnim:Play("anim_newstoryUI_iocation_out")

			arg0_54.locationStatus = var11_0
		end)
	end

	arg0_54.locationAniEvent:SetEndEvent(function()
		if arg0_54.locationStatus == var10_0 then
			var1_54()
			arg2_54()
		elseif arg0_54.locationStatus == var11_0 then
			setActive(arg0_54.locationTr, false)

			arg0_54.locationStatus = var9_0
		end
	end)
	arg0_54.locationAnim:Play("anim_newstoryUI_iocation_in")

	arg0_54.locationStatus = var10_0
end

function var0_0.UpdateIcon(arg0_58, arg1_58, arg2_58)
	if not arg1_58:ExistIcon() then
		setActive(arg0_58.iconImage.gameObject, false)
		arg2_58()

		return
	end

	local var0_58 = arg1_58:GetIconData()

	arg0_58.iconImage.sprite = LoadSprite(var0_58.image)

	arg0_58.iconImage:SetNativeSize()

	local var1_58 = arg0_58.iconImage.gameObject.transform

	if var0_58.pos then
		var1_58.localPosition = Vector3(var0_58.pos[1], var0_58.pos[2], 0)
	else
		var1_58.localPosition = Vector3.one
	end

	var1_58.localScale = Vector3(var0_58.scale or 1, var0_58.scale or 1, 1)

	setActive(arg0_58.iconImage.gameObject, true)
	arg2_58()
end

function var0_0.UpdateOptionTxt(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59)
	local var0_59 = arg2_59:GetComponent(typeof(LayoutElement))
	local var1_59 = arg2_59:Find("content")

	if arg1_59 then
		local var2_59 = GetPerceptualSize(arg3_59)
		local var3_59 = arg2_59:Find("content_max")
		local var4_59 = var2_59 >= 17
		local var5_59 = var4_59 and var3_59 or var1_59

		setActive(var1_59, not var4_59)
		setActive(var3_59, var4_59)
		setText(var5_59:Find("Text"), arg3_59)

		var0_59.preferredHeight = var5_59.rect.height
	else
		setText(var1_59:Find("Text"), arg3_59)

		var0_59.preferredHeight = var1_59.rect.height
	end

	if var1_59:Find("type1") then
		setActive(var1_59:Find("type1"), arg4_59 and arg4_59 == 1)
	end

	if var1_59:Find("type2") then
		setActive(var1_59:Find("type2"), arg4_59 and arg4_59 == 2)
	end
end

function var0_0.InitBranches(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60)
	local var0_60 = false
	local var1_60 = arg2_60:GetOptions()
	local var2_60, var3_60 = arg0_60:GetOptionContainer(arg2_60)
	local var4_60 = arg2_60:GetId()
	local var5_60 = arg0_60.branchCodeList[var4_60] or {}
	local var6_60 = GetOrAddComponent(var2_60.container, typeof(CanvasGroup))

	var6_60.blocksRaycasts = true
	arg0_60.selectedBranchID = nil

	var2_60:make(function(arg0_61, arg1_61, arg2_61)
		if arg0_61 == UIItemList.EventUpdate then
			local var0_61 = arg2_61
			local var1_61 = var1_60[arg1_61 + 1][1]
			local var2_61 = var1_60[arg1_61 + 1][2]
			local var3_61 = var1_60[arg1_61 + 1][3]
			local var4_61 = table.contains(var5_60, var2_61)

			onButton(arg0_60, var0_61, function()
				if arg0_60.pause or arg0_60.stop then
					return
				end

				if not var0_60 then
					return
				end

				arg0_60.selectedBranchID = arg1_61

				arg0_60:SetBranchCode(arg1_60, arg2_60, var2_61)
				pg.NewStoryMgr.GetInstance():TrackingOption(arg2_60:GetOptionIndex(), var2_61)

				local var0_62 = arg2_61:GetComponent(typeof(Animation))

				if var0_62 then
					var6_60.blocksRaycasts = false

					var0_62:Play(arg0_60.script:GetAnimPrefix() .. "confirm")
					arg2_61:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						setActive(arg0_60.optionsCg.gameObject, false)

						var6_60.blocksRaycasts = true

						arg3_60(var1_61)
					end)
				else
					setActive(arg0_60.optionsCg.gameObject, false)
					arg3_60(var1_61)
				end

				arg0_60:HideBranchesWithoutSelected(arg2_60)
			end, SFX_PANEL)
			setButtonEnabled(var0_61, not var4_61)

			GetOrAddComponent(arg2_61, typeof(CanvasGroup)).alpha = var4_61 and 0.5 or 1

			arg0_60:UpdateOptionTxt(var3_60, var0_61, var1_61, var3_61)

			if arg0_60.script:IsDialogueStyle2() then
				setActive(var0_61, arg1_61 == 0)

				if arg1_61 > 0 then
					LeanTween.delayedCall(0.066 * arg1_61, System.Action(function()
						setActive(var0_61, true)
					end))
				end
			end
		end
	end)
	var2_60:align(#var1_60)
	arg0_60:ShowBranches(arg2_60, function()
		var0_60 = true

		if arg4_60 then
			arg4_60()
		end
	end)
end

function var0_0.SetBranchCode(arg0_66, arg1_66, arg2_66, arg3_66)
	arg2_66:SetBranchCode(arg3_66)
	arg1_66:SetBranchCode(arg3_66)

	local var0_66 = arg2_66:GetId()

	if not arg0_66.branchCodeList[var0_66] then
		arg0_66.branchCodeList[var0_66] = {}
	end

	table.insert(arg0_66.branchCodeList[var0_66], arg3_66)
end

function var0_0.ShowBranches(arg0_67, arg1_67, arg2_67)
	setActive(arg0_67.optionsCg.gameObject, true)

	local var0_67 = arg0_67:GetOptionContainer(arg1_67)

	for iter0_67 = 0, var0_67.container.childCount - 1 do
		local var1_67 = var0_67.container:GetChild(iter0_67):GetComponent(typeof(Animation))

		if var1_67 then
			var1_67:Play(arg0_67.script:GetAnimPrefix() .. "in")
		end
	end

	arg2_67()
end

function var0_0.HideBranchesWithoutSelected(arg0_68, arg1_68)
	local var0_68 = arg0_68:GetOptionContainer(arg1_68)

	for iter0_68 = 0, var0_68.container.childCount - 1 do
		if iter0_68 ~= arg0_68.selectedBranchID then
			local var1_68 = var0_68.container:GetChild(iter0_68):GetComponent(typeof(Animation))

			if var1_68 then
				var1_68:Play(arg0_68.script:GetAnimPrefix() .. "unselected")
			end
		end
	end
end

function var0_0.StartMoveNode(arg0_69, arg1_69, arg2_69)
	if not arg1_69:ExistMovableNode() then
		arg2_69()

		return
	end

	local var0_69 = arg1_69:GetMovableNode()
	local var1_69 = {}
	local var2_69 = {}

	for iter0_69, iter1_69 in pairs(var0_69) do
		table.insert(var1_69, function(arg0_70)
			arg0_69:LoadMovableNode(iter1_69, function(arg0_71)
				var2_69[iter0_69] = arg0_71

				arg0_70()
			end)
		end)
	end

	parallelAsync(var1_69, function()
		arg0_69:MoveAllNode(arg1_69, var2_69, var0_69)
		arg2_69()
	end)
end

function var0_0.MoveAllNode(arg0_73, arg1_73, arg2_73, arg3_73)
	local var0_73 = {}

	for iter0_73, iter1_73 in pairs(arg2_73) do
		table.insert(var0_73, function(arg0_74)
			local var0_74 = arg3_73[iter0_73]
			local var1_74 = var0_74.path
			local var2_74 = var0_74.time
			local var3_74 = var0_74.easeType
			local var4_74 = var0_74.delay

			arg0_73:moveLocalPath(iter1_73, var1_74, var2_74, var4_74, var3_74, arg0_74)
		end)
	end

	arg0_73.moveTargets = arg2_73

	parallelAsync(var0_73, function()
		arg0_73:ClearMoveNodes(arg1_73)
	end)
end

local function var12_0(arg0_76, arg1_76, arg2_76, arg3_76, arg4_76)
	PoolMgr.GetInstance():GetSpineChar(arg1_76, true, function(arg0_77)
		arg0_77.transform:SetParent(arg0_76.movePanel)

		local var0_77 = arg2_76.scale

		arg0_77.transform.localScale = Vector3(var0_77, var0_77, 0)
		arg0_77.transform.localPosition = arg3_76

		arg0_77:GetComponent(typeof(SpineAnimUI)):SetAction(arg2_76.action, 0)

		arg0_77.name = arg1_76

		if arg4_76 then
			arg4_76(arg0_77)
		end
	end)
end

local function var13_0(arg0_78, arg1_78, arg2_78, arg3_78)
	local var0_78 = GameObject.New("movable")

	var0_78.transform:SetParent(arg0_78.movePanel)

	var0_78.transform.localScale = Vector3.zero

	local var1_78 = GetOrAddComponent(var0_78, typeof(RectTransform))
	local var2_78 = GetOrAddComponent(var0_78, typeof(Image))

	LoadSpriteAsync(arg1_78, function(arg0_79)
		var2_78.sprite = arg0_79

		var2_78:SetNativeSize()

		var1_78.localScale = Vector3.one
		var1_78.localPosition = arg2_78

		arg3_78(var1_78.gameObject)
	end)
end

function var0_0.LoadMovableNode(arg0_80, arg1_80, arg2_80)
	local var0_80 = arg1_80.path[1] or Vector3.zero

	if arg1_80.isSpine then
		var12_0(arg0_80, arg1_80.name, arg1_80.spineData, var0_80, arg2_80)
	else
		var13_0(arg0_80, arg1_80.name, var0_80, arg2_80)
	end
end

function var0_0.ClearMoveNodes(arg0_81, arg1_81)
	if not arg1_81:ExistMovableNode() then
		return
	end

	if arg0_81.movePanel.childCount <= 0 then
		return
	end

	for iter0_81, iter1_81 in ipairs(arg0_81.moveTargets or {}) do
		if iter1_81:GetComponent(typeof(SpineAnimUI)) ~= nil then
			PoolMgr.GetInstance():ReturnSpineChar(iter1_81.name, iter1_81.gameObject)
		else
			Destroy(arg0_81.movePanel:GetChild(iter0_81 - 1))
		end
	end

	arg0_81.moveTargets = {}
end

function var0_0.FadeOutStory(arg0_82, arg1_82, arg2_82)
	if not arg1_82:ShouldFadeout() then
		arg2_82()

		return
	end

	local var0_82 = arg1_82:GetFadeoutTime()

	if not arg1_82:ShouldWaitFadeout() then
		arg0_82:fadeTransform(arg0_82._go, 1, 0.3, var0_82, true)
		arg2_82()
	else
		arg0_82:fadeTransform(arg0_82._go, 1, 0.3, var0_82, true, arg2_82)
	end
end

function var0_0.GetFadeColor(arg0_83, arg1_83)
	local var0_83 = {}
	local var1_83 = {}
	local var2_83 = arg1_83:GetComponentsInChildren(typeof(Image))

	for iter0_83 = 0, var2_83.Length - 1 do
		local var3_83 = var2_83[iter0_83]
		local var4_83 = {
			name = "_Color",
			color = Color.white
		}

		if var3_83.material.shader.name == "UI/GrayScale" then
			var4_83 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif var3_83.material.shader.name == "UI/Line_Add_Blue" then
			var4_83 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_83, var4_83)

		if var3_83.material == var3_83.defaultGraphicMaterial then
			var3_83.material = Material.Instantiate(var3_83.defaultGraphicMaterial)
		end

		table.insert(var0_83, var3_83.material)
	end

	return var0_83, var1_83
end

function var0_0._SetFadeColor(arg0_84, arg1_84, arg2_84, arg3_84)
	for iter0_84, iter1_84 in ipairs(arg1_84) do
		if not IsNil(iter1_84) then
			iter1_84:SetColor(arg2_84[iter0_84].name, arg2_84[iter0_84].color * Color.New(arg3_84, arg3_84, arg3_84))
		end
	end
end

function var0_0.SetFadeColor(arg0_85, arg1_85, arg2_85)
	local var0_85, var1_85 = arg0_85:GetFadeColor(arg1_85)

	arg0_85:_SetFadeColor(var0_85, var1_85, arg2_85)
end

function var0_0._RevertFadeColor(arg0_86, arg1_86, arg2_86)
	arg0_86:_SetFadeColor(arg1_86, arg2_86, 1)
end

function var0_0.RevertFadeColor(arg0_87, arg1_87)
	local var0_87, var1_87 = arg0_87:GetFadeColor(arg1_87)

	arg0_87:_RevertFadeColor(var0_87, var1_87)
end

function var0_0.fadeTransform(arg0_88, arg1_88, arg2_88, arg3_88, arg4_88, arg5_88, arg6_88)
	if arg4_88 <= 0 then
		if arg6_88 then
			arg6_88()
		end

		return
	end

	local var0_88, var1_88 = arg0_88:GetFadeColor(arg1_88)

	LeanTween.value(go(arg1_88), arg2_88, arg3_88, arg4_88):setOnUpdate(System.Action_float(function(arg0_89)
		arg0_88:_SetFadeColor(var0_88, var1_88, arg0_89)
	end)):setOnComplete(System.Action(function()
		if arg5_88 then
			arg0_88:_RevertFadeColor(var0_88, var1_88)
		end

		if arg6_88 then
			arg6_88()
		end
	end))
end

function var0_0.setPaintingAlpha(arg0_91, arg1_91, arg2_91)
	local var0_91 = {}
	local var1_91 = {}
	local var2_91 = arg1_91:GetComponentsInChildren(typeof(Image))

	for iter0_91 = 0, var2_91.Length - 1 do
		local var3_91 = var2_91[iter0_91]
		local var4_91 = {
			name = "_Color",
			color = Color.white
		}

		if var3_91.material.shader.name == "UI/GrayScale" then
			var4_91 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif var3_91.material.shader.name == "UI/Line_Add_Blue" then
			var4_91 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_91, var4_91)

		if var3_91.material == var3_91.defaultGraphicMaterial then
			var3_91.material = Material.Instantiate(var3_91.defaultGraphicMaterial)
		end

		table.insert(var0_91, var3_91.material)
	end

	for iter1_91, iter2_91 in ipairs(var0_91) do
		if not IsNil(iter2_91) then
			iter2_91:SetColor(var1_91[iter1_91].name, var1_91[iter1_91].color * Color.New(arg2_91, arg2_91, arg2_91))
		end
	end
end

function var0_0.RegisetEvent(arg0_92, arg1_92, arg2_92)
	setButtonEnabled(arg0_92._go, not arg0_92.autoNext)
	onButton(arg0_92, arg0_92._go, function()
		if arg0_92.pause or arg0_92.stop then
			return
		end

		removeOnButton(arg0_92._go)
		arg2_92()
	end, SFX_PANEL)
end

function var0_0.flashEffect(arg0_94, arg1_94, arg2_94, arg3_94, arg4_94, arg5_94, arg6_94)
	arg0_94.flashImg.color = arg4_94 and Color(0, 0, 0) or Color(1, 1, 1)
	arg0_94.flashCg.alpha = arg1_94

	setActive(arg0_94.flash, true)
	arg0_94:TweenValueForcanvasGroup(arg0_94.flashCg, arg1_94, arg2_94, arg3_94, arg5_94, arg6_94)
end

function var0_0.Flashout(arg0_95, arg1_95, arg2_95)
	local var0_95, var1_95, var2_95, var3_95 = arg1_95:GetFlashoutData()

	if not var0_95 then
		arg2_95()

		return
	end

	arg0_95:flashEffect(var0_95, var1_95, var2_95, var3_95, 0, arg2_95)
end

function var0_0.flashin(arg0_96, arg1_96, arg2_96)
	local var0_96, var1_96, var2_96, var3_96, var4_96 = arg1_96:GetFlashinData()

	if not var0_96 then
		arg2_96()

		return
	end

	arg0_96:flashEffect(var0_96, var1_96, var2_96, var3_96, var4_96, arg2_96)
end

function var0_0.UpdateBg(arg0_97, arg1_97)
	if arg1_97:ShouldBgGlitchArt() then
		arg0_97:SetBgGlitchArt(arg1_97)
	else
		local var0_97 = arg1_97:GetBgName()

		if var0_97 then
			setActive(arg0_97.bgPanel, true)

			arg0_97.bgPanelCg.alpha = 1

			local var1_97 = arg0_97.bgImage

			var1_97.color = Color.New(1, 1, 1)
			var1_97.sprite = arg0_97:GetBg(var0_97)
		end

		local var2_97 = arg1_97:GetBgShadow()

		if var2_97 then
			local var3_97 = arg0_97.bgImage

			arg0_97:TweenValue(var3_97, var2_97[1], var2_97[2], var2_97[3], 0, function(arg0_98)
				var3_97.color = Color.New(arg0_98, arg0_98, arg0_98)
			end, nil)
		end

		if arg1_97:IsBlackBg() then
			setActive(arg0_97.curtain, true)

			arg0_97.curtainCg.alpha = 1
		end

		local var4_97, var5_97 = arg1_97:IsBlackFrontGround()

		if var4_97 then
			arg0_97.curtainFCg.alpha = var5_97
		end

		setActive(arg0_97.curtainF, var4_97)
	end

	arg0_97:ApplyOldPhotoEffect(arg1_97)
	arg0_97:OnBgUpdate(arg1_97)

	local var6_97 = arg1_97:GetBgColor()

	arg0_97.curtain:GetComponent(typeof(Image)).color = var6_97
end

function var0_0.ApplyOldPhotoEffect(arg0_99, arg1_99)
	local var0_99 = arg1_99:OldPhotoEffect()
	local var1_99 = var0_99 ~= nil

	setActive(arg0_99.oldPhoto.gameObject, var1_99)

	if var1_99 then
		if type(var0_99) == "table" then
			arg0_99.oldPhoto.color = Color.New(var0_99[1], var0_99[2], var0_99[3], var0_99[4])
		else
			arg0_99.oldPhoto.color = Color.New(0.62, 0.58, 0.14, 0.36)
		end
	end
end

function var0_0.SetBgGlitchArt(arg0_100, arg1_100)
	setActive(arg0_100.bgPanel, false)
	setActive(arg0_100.bgGlitch, true)
end

function var0_0.GetBg(arg0_101, arg1_101)
	if not arg0_101.bgs[arg1_101] then
		arg0_101.bgs[arg1_101] = LoadSprite("bg/" .. arg1_101)
	end

	return arg0_101.bgs[arg1_101]
end

function var0_0.LoadEffects(arg0_102, arg1_102, arg2_102)
	local var0_102 = arg1_102:GetEffects()

	if #var0_102 <= 0 then
		arg2_102()

		return
	end

	local var1_102 = {}

	for iter0_102, iter1_102 in ipairs(var0_102) do
		local var2_102 = iter1_102.name
		local var3_102 = iter1_102.active
		local var4_102 = iter1_102.interlayer
		local var5_102 = iter1_102.center
		local var6_102 = iter1_102.adapt
		local var7_102 = arg0_102.effectPanel:Find(var2_102) or arg0_102.centerPanel:Find(var2_102)

		if var7_102 then
			setActive(var7_102, var3_102)
			setParent(var7_102, var5_102 and arg0_102.centerPanel or arg0_102.effectPanel.transform)

			if var4_102 then
				arg0_102:UpdateEffectInterLayer(var2_102, var7_102)
			end

			if not var3_102 then
				arg0_102:ClearEffectInterlayer(var2_102)
			elseif isActive(var7_102) then
				setActive(var7_102, false)
				setActive(var7_102, true)
			end

			if var6_102 then
				arg0_102:AdaptEffect(var7_102)
			end
		else
			local var8_102 = ""

			if checkABExist("ui/" .. var2_102) then
				var8_102 = "ui"
			elseif checkABExist("effect/" .. var2_102) then
				var8_102 = "effect"
			end

			if var8_102 and var8_102 ~= "" then
				table.insert(var1_102, function(arg0_103)
					LoadAndInstantiateAsync(var8_102, var2_102, function(arg0_104)
						setParent(arg0_104, var5_102 and arg0_102.centerPanel or arg0_102.effectPanel.transform)

						arg0_104.transform.localScale = Vector3.one

						setActive(arg0_104, var3_102)

						arg0_104.name = var2_102

						if var4_102 then
							arg0_102:UpdateEffectInterLayer(var2_102, arg0_104)
						end

						if var3_102 == false then
							arg0_102:ClearEffectInterlayer(var2_102)
						end

						if var6_102 then
							arg0_102:AdaptEffect(arg0_104)
						end

						arg0_103()
					end)
				end)
			else
				originalPrint("not found effect", var2_102)
			end
		end
	end

	parallelAsync(var1_102, arg2_102)
end

function var0_0.AdaptEffect(arg0_105, arg1_105)
	local var0_105 = 1.77777777777778
	local var1_105 = pg.UIMgr.GetInstance().OverlayMain.parent.sizeDelta
	local var2_105 = var1_105.x / var1_105.y
	local var3_105 = 1

	if var0_105 < var2_105 then
		var3_105 = var2_105 / var0_105
	else
		var3_105 = var0_105 / var2_105
	end

	tf(arg1_105).localScale = Vector3(var3_105, var3_105, var3_105)
end

function var0_0.UpdateEffectInterLayer(arg0_106, arg1_106, arg2_106)
	local var0_106 = arg0_106._go:GetComponent(typeof(Canvas)).sortingOrder
	local var1_106 = arg2_106:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

	for iter0_106 = 1, var1_106.Length - 1 do
		local var2_106 = var1_106[iter0_106 - 1]
		local var3_106 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var2_106)

		if var0_106 < var3_106 then
			var0_106 = var3_106
		end
	end

	local var4_106 = var0_106 + 1
	local var5_106 = GetOrAddComponent(arg0_106.actorTr, typeof(Canvas))

	var5_106.overrideSorting = true
	var5_106.sortingOrder = var4_106

	local var6_106 = GetOrAddComponent(arg0_106.frontTr, typeof(Canvas))

	var6_106.overrideSorting = true
	var6_106.sortingOrder = var4_106 + 1
	arg0_106.activeInterLayer = arg1_106

	GetOrAddComponent(arg0_106.frontTr, typeof(GraphicRaycaster))
end

function var0_0.ClearEffectInterlayer(arg0_107, arg1_107)
	if arg0_107.activeInterLayer == arg1_107 then
		RemoveComponent(arg0_107.actorTr, "Canvas")
		RemoveComponent(arg0_107.frontTr, "Canvas")
		RemoveComponent(arg0_107.frontTr, "GraphicRaycaster")

		arg0_107.activeInterLayer = nil
	end
end

function var0_0.ClearEffects(arg0_108)
	removeAllChildren(arg0_108.effectPanel)
	removeAllChildren(arg0_108.centerPanel)

	if arg0_108.activeInterLayer ~= nil then
		arg0_108:ClearEffectInterlayer(arg0_108.activeInterLayer)
	end
end

function var0_0.PlaySoundEffect(arg0_109, arg1_109)
	if arg1_109:ShouldPlaySoundEffect() then
		local var0_109, var1_109 = arg1_109:GetSoundeffect()

		arg0_109:DelayCall(var1_109, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_109)
		end)
	end

	if arg1_109:ShouldPlayVoice() then
		arg0_109:PlayVoice(arg1_109)
	elseif arg1_109:ShouldStopVoice() then
		arg0_109:StopVoice()
	end
end

function var0_0.StopVoice(arg0_111)
	if arg0_111.currentVoice then
		arg0_111.currentVoice:Stop(true)

		arg0_111.currentVoice = nil
	end
end

function var0_0.PlayVoice(arg0_112, arg1_112)
	if arg0_112.voiceDelayTimer then
		arg0_112.voiceDelayTimer:Stop()

		arg0_112.voiceDelayTimer = nil
	end

	arg0_112:StopVoice()

	local var0_112, var1_112 = arg1_112:GetVoice()
	local var2_112

	var2_112 = arg0_112:CreateDelayTimer(var1_112, function()
		if var2_112 then
			var2_112:Stop()
		end

		if arg0_112.voiceDelayTimer then
			arg0_112.voiceDelayTimer = nil
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_112, function(arg0_114)
			if arg0_114 then
				arg0_112.currentVoice = arg0_114.playback
			end
		end)
	end)
	arg0_112.voiceDelayTimer = var2_112
end

function var0_0.Reset(arg0_115, arg1_115, arg2_115, arg3_115)
	setActive(arg0_115.spAnimPanel, false)
	setActive(arg0_115.castPanel, false)
	setActive(arg0_115.bgPanel, false)

	if arg1_115 and arg1_115:IsDialogueMode() and arg2_115 and arg2_115:IsDialogueMode() then
		-- block empty
	else
		setActive(arg0_115.dialoguePanel, false)
	end

	setActive(arg0_115.asidePanel, false)
	setActive(arg0_115.curtain, false)
	setActive(arg0_115.flash, false)
	setActive(arg0_115.optionsCg.gameObject, false)
	setActive(arg0_115.bgGlitch, false)
	setActive(arg0_115.locationTr, false)

	arg0_115.locationTr.localPosition = arg0_115.locationTrPos
	arg0_115.locationStatus = var9_0
	arg0_115.flashCg.alpha = 1
	arg0_115.goCG.alpha = 1

	arg0_115.animationPlayer:Stop()
	arg0_115:OnReset(arg1_115, arg2_115, arg3_115)
end

function var0_0.Clear(arg0_116, arg1_116)
	if arg0_116.step then
		arg0_116:ClearMoveNodes(arg0_116.step)
	end

	arg0_116.bgs = {}
	arg0_116.skipOption = nil
	arg0_116.step = nil
	arg0_116.goCG.alpha = 1
	arg0_116.callback = nil
	arg0_116.autoNext = nil
	arg0_116.script = nil
	arg0_116.bgImage.sprite = nil

	arg0_116:OnClear()

	if arg1_116 then
		arg1_116()
	end

	pg.DelegateInfo.New(arg0_116)
end

function var0_0.StoryEnd(arg0_117)
	setActive(arg0_117.iconImage.gameObject, false)

	arg0_117.iconImage.sprite = nil
	arg0_117.branchCodeList = {}
	arg0_117.stop = false
	arg0_117.pause = false

	if arg0_117.voiceDelayTimer then
		arg0_117.voiceDelayTimer:Stop()

		arg0_117.voiceDelayTimer = nil
	end

	if arg0_117.currentVoice then
		arg0_117.currentVoice:Stop(true)

		arg0_117.currentVoice = nil
	end

	arg0_117:ClearCheckDispatcher()
	arg0_117:ClearEffects()
	arg0_117:Clear()
	arg0_117:OnEnd()
end

function var0_0.PlayBgm(arg0_118, arg1_118)
	if arg1_118:ShouldStopBgm() then
		arg0_118:StopBgm()
	end

	if arg1_118:ShoulePlayBgm() then
		local var0_118, var1_118, var2_118 = arg1_118:GetBgmData()

		arg0_118:DelayCall(var1_118, function()
			arg0_118:RevertBgmVolume()
			pg.BgmMgr.GetInstance():TempPlay(var0_118)
		end)

		if var2_118 and var2_118 > 0 then
			arg0_118.defaultBgmVolume = pg.CriMgr.GetInstance():getBGMVolume()

			pg.CriMgr.GetInstance():setBGMVolume(var2_118)
		end
	end
end

function var0_0.StopBgm(arg0_120, arg1_120)
	arg0_120:RevertBgmVolume()
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.RevertBgmVolume(arg0_121)
	if arg0_121.defaultBgmVolume then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_121.defaultBgmVolume)

		arg0_121.defaultBgmVolume = nil
	end
end

function var0_0.StartUIAnimations(arg0_122, arg1_122, arg2_122)
	parallelAsync({
		function(arg0_123)
			arg0_122:StartBlinkAnimation(arg1_122, arg0_123)
		end,
		function(arg0_124)
			arg0_122:StartBlinkWithColorAnimation(arg1_122, arg0_124)
		end,
		function(arg0_125)
			arg0_122:OnStartUIAnimations(arg1_122, arg0_125)
		end
	}, arg2_122)
end

function var0_0.StartBlinkAnimation(arg0_126, arg1_126, arg2_126)
	if arg1_126:ShouldBlink() then
		local var0_126 = arg1_126:GetBlinkData()
		local var1_126 = var0_126.black
		local var2_126 = var0_126.number
		local var3_126 = var0_126.dur
		local var4_126 = var0_126.delay
		local var5_126 = var0_126.alpha[1]
		local var6_126 = var0_126.alpha[2]
		local var7_126 = var0_126.wait

		arg0_126.flashImg.color = var1_126 and Color(0, 0, 0) or Color(1, 1, 1)

		setActive(arg0_126.flash, true)

		local var8_126 = {}

		for iter0_126 = 1, var2_126 do
			table.insert(var8_126, function(arg0_127)
				arg0_126:TweenAlpha(arg0_126.flash, var5_126, var6_126, var3_126 / 2, 0, function()
					arg0_126:TweenAlpha(arg0_126.flash, var6_126, var5_126, var3_126 / 2, var7_126, arg0_127)
				end)
			end)
		end

		seriesAsync(var8_126, function()
			setActive(arg0_126.flash, false)
		end)
	end

	arg2_126()
end

function var0_0.StartBlinkWithColorAnimation(arg0_130, arg1_130, arg2_130)
	if arg1_130:ShouldBlinkWithColor() then
		local var0_130 = arg1_130:GetBlinkWithColorData()
		local var1_130 = var0_130.color
		local var2_130 = var0_130.alpha

		arg0_130.flashImg.color = Color(var1_130[1], var1_130[2], var1_130[3], var1_130[4])

		setActive(arg0_130.flash, true)

		local var3_130 = {}

		for iter0_130, iter1_130 in ipairs(var2_130) do
			local var4_130 = iter1_130[1]
			local var5_130 = iter1_130[2]
			local var6_130 = iter1_130[3]
			local var7_130 = iter1_130[4]

			table.insert(var3_130, function(arg0_131)
				arg0_130:TweenValue(arg0_130.flash, var4_130, var5_130, var6_130, var7_130, function(arg0_132)
					arg0_130.flashCg.alpha = arg0_132
				end, arg0_131)
			end)
		end

		parallelAsync(var3_130, function()
			setActive(arg0_130.flash, false)
		end)
	end

	arg2_130()
end

function var0_0.findTF(arg0_134, arg1_134, arg2_134)
	assert(arg0_134._tf, "transform should exist")

	return findTF(arg2_134 or arg0_134._tf, arg1_134)
end

function var0_0.OnStart(arg0_135, arg1_135)
	return
end

function var0_0.OnReset(arg0_136, arg1_136, arg2_136, arg3_136)
	arg3_136()
end

function var0_0.OnBgUpdate(arg0_137, arg1_137)
	return
end

function var0_0.OnInit(arg0_138, arg1_138, arg2_138, arg3_138)
	if arg3_138 then
		arg3_138()
	end
end

function var0_0.OnStartUIAnimations(arg0_139, arg1_139, arg2_139)
	if arg2_139 then
		arg2_139()
	end
end

function var0_0.OnEnter(arg0_140, arg1_140, arg2_140, arg3_140)
	if arg3_140 then
		arg3_140()
	end
end

function var0_0.OnWillExit(arg0_141, arg1_141, arg2_141, arg3_141)
	arg3_141()
end

function var0_0.OnWillClear(arg0_142, arg1_142)
	return
end

function var0_0.OnClear(arg0_143)
	return
end

function var0_0.OnEnd(arg0_144)
	return
end

return var0_0
