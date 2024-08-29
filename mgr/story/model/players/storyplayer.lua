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
					arg0_8:DispatcherEvent(var0_8, arg0_22)
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
end

function var0_0.CheckDispatcher(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg1_41:GetDispatcherRecallName()

	arg0_41.checkTimer = Timer.New(function()
		if pg.NewStoryMgr.GetInstance():CheckStoryEvent(var0_41) then
			local var0_42 = pg.NewStoryMgr.GetInstance():GetStoryEventArg(var0_41)

			if var0_42 and var0_42.optionIndex then
				arg0_41:SetBranchCode(arg0_41.script, arg1_41, var0_42.optionIndex)

				arg0_41.skipOption = true
			end

			if arg1_41:ShouldHideUI() then
				setActive(arg0_41._tf, true)
			end

			arg0_41:ClearCheckDispatcher()
			arg2_41()
		end
	end, 1, -1)

	arg0_41.checkTimer:Start()
	arg0_41.checkTimer.func()
end

function var0_0.ClearCheckDispatcher(arg0_43)
	if arg0_43.checkTimer then
		arg0_43.checkTimer:Stop()

		arg0_43.checkTimer = nil
	end
end

function var0_0.TriggerEventIfAuto(arg0_44, arg1_44)
	if not arg0_44:ShouldAutoTrigger() then
		return
	end

	arg0_44:UnscaleDelayCall(arg1_44, function()
		if not arg0_44.autoNext then
			setButtonEnabled(arg0_44._go, true)

			return
		end

		triggerButton(arg0_44._go)
	end)
end

function var0_0.TriggerOptionIfAuto(arg0_46, arg1_46, arg2_46)
	if not arg0_46:ShouldAutoTrigger() then
		return
	end

	if not arg2_46 or not arg2_46:ExistOption() then
		return
	end

	arg0_46:UnscaleDelayCall(arg1_46, function()
		if not arg0_46.autoNext then
			return
		end

		local var0_47 = arg2_46:GetOptionIndexByAutoSel()

		if var0_47 ~= nil then
			local var1_47 = arg0_46:GetOptionContainer(arg2_46).container:GetChild(var0_47 - 1)

			triggerButton(var1_47)
		end
	end)
end

function var0_0.ShouldAutoTrigger(arg0_48)
	if arg0_48.pause or arg0_48.stop then
		return false
	end

	return arg0_48.autoNext
end

function var0_0.CanSkip(arg0_49)
	return arg0_49.step and not arg0_49.step:IsImport()
end

function var0_0.CancelAuto(arg0_50)
	arg0_50.autoNext = false
end

function var0_0.NextOne(arg0_51)
	arg0_51.timeScale = 0.0001

	if arg0_51.stage == var1_0 then
		arg0_51.autoNext = true
	elseif arg0_51.stage == var5_0 then
		arg0_51.autoNext = true

		arg0_51:TriggerEventIfAuto(0)
	elseif arg0_51.stage == var6_0 then
		arg0_51:TriggerOptionIfAuto(0, arg0_51.step)
	end
end

function var0_0.NextOneImmediately(arg0_52)
	local var0_52 = arg0_52.callback

	if var0_52 then
		arg0_52:ClearAnimation()
		arg0_52:Clear()
		var0_52()
	end
end

function var0_0.SetLocation(arg0_53, arg1_53, arg2_53)
	if not arg1_53:ExistLocation() then
		arg0_53.locationAniEvent:SetEndEvent(nil)
		arg2_53()

		return
	end

	setActive(arg0_53.locationTr, true)

	local var0_53 = arg1_53:GetLocation()

	arg0_53.locationTxt.text = var0_53.text

	local function var1_53()
		arg0_53:DelayCall(var0_53.time, function()
			arg0_53.locationAnim:Play("anim_newstoryUI_iocation_out")

			arg0_53.locationStatus = var11_0
		end)
	end

	arg0_53.locationAniEvent:SetEndEvent(function()
		if arg0_53.locationStatus == var10_0 then
			var1_53()
			arg2_53()
		elseif arg0_53.locationStatus == var11_0 then
			setActive(arg0_53.locationTr, false)

			arg0_53.locationStatus = var9_0
		end
	end)
	arg0_53.locationAnim:Play("anim_newstoryUI_iocation_in")

	arg0_53.locationStatus = var10_0
end

function var0_0.UpdateIcon(arg0_57, arg1_57, arg2_57)
	if not arg1_57:ExistIcon() then
		setActive(arg0_57.iconImage.gameObject, false)
		arg2_57()

		return
	end

	local var0_57 = arg1_57:GetIconData()

	arg0_57.iconImage.sprite = LoadSprite(var0_57.image)

	arg0_57.iconImage:SetNativeSize()

	local var1_57 = arg0_57.iconImage.gameObject.transform

	if var0_57.pos then
		var1_57.localPosition = Vector3(var0_57.pos[1], var0_57.pos[2], 0)
	else
		var1_57.localPosition = Vector3.one
	end

	var1_57.localScale = Vector3(var0_57.scale or 1, var0_57.scale or 1, 1)

	setActive(arg0_57.iconImage.gameObject, true)
	arg2_57()
end

function var0_0.UpdateOptionTxt(arg0_58, arg1_58, arg2_58, arg3_58)
	local var0_58 = arg2_58:GetComponent(typeof(LayoutElement))
	local var1_58 = arg2_58:Find("content")

	if arg1_58 then
		local var2_58 = GetPerceptualSize(arg3_58)
		local var3_58 = arg2_58:Find("content_max")
		local var4_58 = var2_58 >= 17
		local var5_58 = var4_58 and var3_58 or var1_58

		setActive(var1_58, not var4_58)
		setActive(var3_58, var4_58)
		setText(var5_58:Find("Text"), arg3_58)

		var0_58.preferredHeight = var5_58.rect.height
	else
		setText(var1_58:Find("Text"), arg3_58)

		var0_58.preferredHeight = var1_58.rect.height
	end
end

function var0_0.InitBranches(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59)
	local var0_59 = false
	local var1_59 = arg2_59:GetOptions()
	local var2_59, var3_59 = arg0_59:GetOptionContainer(arg2_59)
	local var4_59 = arg2_59:GetId()
	local var5_59 = arg0_59.branchCodeList[var4_59] or {}
	local var6_59 = GetOrAddComponent(var2_59.container, typeof(CanvasGroup))

	var6_59.blocksRaycasts = true
	arg0_59.selectedBranchID = nil

	var2_59:make(function(arg0_60, arg1_60, arg2_60)
		if arg0_60 == UIItemList.EventUpdate then
			local var0_60 = arg2_60
			local var1_60 = var1_59[arg1_60 + 1][1]
			local var2_60 = var1_59[arg1_60 + 1][2]
			local var3_60 = table.contains(var5_59, var2_60)

			onButton(arg0_59, var0_60, function()
				if arg0_59.pause or arg0_59.stop then
					return
				end

				if not var0_59 then
					return
				end

				arg0_59.selectedBranchID = arg1_60

				arg0_59:SetBranchCode(arg1_59, arg2_59, var2_60)
				pg.NewStoryMgr.GetInstance():TrackingOption(arg2_59:GetOptionIndex(), var2_60)

				local var0_61 = arg2_60:GetComponent(typeof(Animation))

				if var0_61 then
					var6_59.blocksRaycasts = false

					var0_61:Play("anim_storydialogue_optiontpl_confirm")
					arg2_60:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						setActive(arg0_59.optionsCg.gameObject, false)

						var6_59.blocksRaycasts = true

						arg3_59(var1_60)
					end)
				else
					setActive(arg0_59.optionsCg.gameObject, false)
					arg3_59(var1_60)
				end

				arg0_59:HideBranchesWithoutSelected(arg2_59)
			end, SFX_PANEL)
			setButtonEnabled(var0_60, not var3_60)

			GetOrAddComponent(arg2_60, typeof(CanvasGroup)).alpha = var3_60 and 0.5 or 1

			arg0_59:UpdateOptionTxt(var3_59, var0_60, var1_60)
		end
	end)
	var2_59:align(#var1_59)
	arg0_59:ShowBranches(arg2_59, function()
		var0_59 = true

		if arg4_59 then
			arg4_59()
		end
	end)
end

function var0_0.SetBranchCode(arg0_64, arg1_64, arg2_64, arg3_64)
	arg2_64:SetBranchCode(arg3_64)
	arg1_64:SetBranchCode(arg3_64)

	local var0_64 = arg2_64:GetId()

	if not arg0_64.branchCodeList[var0_64] then
		arg0_64.branchCodeList[var0_64] = {}
	end

	table.insert(arg0_64.branchCodeList[var0_64], arg3_64)
end

function var0_0.ShowBranches(arg0_65, arg1_65, arg2_65)
	setActive(arg0_65.optionsCg.gameObject, true)

	local var0_65 = arg0_65:GetOptionContainer(arg1_65)

	for iter0_65 = 0, var0_65.container.childCount - 1 do
		local var1_65 = var0_65.container:GetChild(iter0_65):GetComponent(typeof(Animation))

		if var1_65 then
			var1_65:Play("anim_storydialogue_optiontpl_in")
		end
	end

	arg2_65()
end

function var0_0.HideBranchesWithoutSelected(arg0_66, arg1_66)
	local var0_66 = arg0_66:GetOptionContainer(arg1_66)

	for iter0_66 = 0, var0_66.container.childCount - 1 do
		if iter0_66 ~= arg0_66.selectedBranchID then
			local var1_66 = var0_66.container:GetChild(iter0_66):GetComponent(typeof(Animation))

			if var1_66 then
				var1_66:Play("anim_storydialogue_optiontpl_unselected")
			end
		end
	end
end

function var0_0.StartMoveNode(arg0_67, arg1_67, arg2_67)
	if not arg1_67:ExistMovableNode() then
		arg2_67()

		return
	end

	local var0_67 = arg1_67:GetMovableNode()
	local var1_67 = {}
	local var2_67 = {}

	for iter0_67, iter1_67 in pairs(var0_67) do
		table.insert(var1_67, function(arg0_68)
			arg0_67:LoadMovableNode(iter1_67, function(arg0_69)
				var2_67[iter0_67] = arg0_69

				arg0_68()
			end)
		end)
	end

	parallelAsync(var1_67, function()
		arg0_67:MoveAllNode(arg1_67, var2_67, var0_67)
		arg2_67()
	end)
end

function var0_0.MoveAllNode(arg0_71, arg1_71, arg2_71, arg3_71)
	local var0_71 = {}

	for iter0_71, iter1_71 in pairs(arg2_71) do
		table.insert(var0_71, function(arg0_72)
			local var0_72 = arg3_71[iter0_71]
			local var1_72 = var0_72.path
			local var2_72 = var0_72.time
			local var3_72 = var0_72.easeType
			local var4_72 = var0_72.delay

			arg0_71:moveLocalPath(iter1_71, var1_72, var2_72, var4_72, var3_72, arg0_72)
		end)
	end

	arg0_71.moveTargets = arg2_71

	parallelAsync(var0_71, function()
		arg0_71:ClearMoveNodes(arg1_71)
	end)
end

local function var12_0(arg0_74, arg1_74, arg2_74, arg3_74, arg4_74)
	PoolMgr.GetInstance():GetSpineChar(arg1_74, true, function(arg0_75)
		arg0_75.transform:SetParent(arg0_74.movePanel)

		local var0_75 = arg2_74.scale

		arg0_75.transform.localScale = Vector3(var0_75, var0_75, 0)
		arg0_75.transform.localPosition = arg3_74

		arg0_75:GetComponent(typeof(SpineAnimUI)):SetAction(arg2_74.action, 0)

		arg0_75.name = arg1_74

		if arg4_74 then
			arg4_74(arg0_75)
		end
	end)
end

local function var13_0(arg0_76, arg1_76, arg2_76, arg3_76)
	local var0_76 = GameObject.New("movable")

	var0_76.transform:SetParent(arg0_76.movePanel)

	var0_76.transform.localScale = Vector3.zero

	local var1_76 = GetOrAddComponent(var0_76, typeof(RectTransform))
	local var2_76 = GetOrAddComponent(var0_76, typeof(Image))

	LoadSpriteAsync(arg1_76, function(arg0_77)
		var2_76.sprite = arg0_77

		var2_76:SetNativeSize()

		var1_76.localScale = Vector3.one
		var1_76.localPosition = arg2_76

		arg3_76(var1_76.gameObject)
	end)
end

function var0_0.LoadMovableNode(arg0_78, arg1_78, arg2_78)
	local var0_78 = arg1_78.path[1] or Vector3.zero

	if arg1_78.isSpine then
		var12_0(arg0_78, arg1_78.name, arg1_78.spineData, var0_78, arg2_78)
	else
		var13_0(arg0_78, arg1_78.name, var0_78, arg2_78)
	end
end

function var0_0.ClearMoveNodes(arg0_79, arg1_79)
	if not arg1_79:ExistMovableNode() then
		return
	end

	if arg0_79.movePanel.childCount <= 0 then
		return
	end

	for iter0_79, iter1_79 in ipairs(arg0_79.moveTargets or {}) do
		if iter1_79:GetComponent(typeof(SpineAnimUI)) ~= nil then
			PoolMgr.GetInstance():ReturnSpineChar(iter1_79.name, iter1_79.gameObject)
		else
			Destroy(arg0_79.movePanel:GetChild(iter0_79 - 1))
		end
	end

	arg0_79.moveTargets = {}
end

function var0_0.FadeOutStory(arg0_80, arg1_80, arg2_80)
	if not arg1_80:ShouldFadeout() then
		arg2_80()

		return
	end

	local var0_80 = arg1_80:GetFadeoutTime()

	if not arg1_80:ShouldWaitFadeout() then
		arg0_80:fadeTransform(arg0_80._go, 1, 0.3, var0_80, true)
		arg2_80()
	else
		arg0_80:fadeTransform(arg0_80._go, 1, 0.3, var0_80, true, arg2_80)
	end
end

function var0_0.GetFadeColor(arg0_81, arg1_81)
	local var0_81 = {}
	local var1_81 = {}
	local var2_81 = arg1_81:GetComponentsInChildren(typeof(Image))

	for iter0_81 = 0, var2_81.Length - 1 do
		local var3_81 = var2_81[iter0_81]
		local var4_81 = {
			name = "_Color",
			color = Color.white
		}

		if var3_81.material.shader.name == "UI/GrayScale" then
			var4_81 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif var3_81.material.shader.name == "UI/Line_Add_Blue" then
			var4_81 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_81, var4_81)

		if var3_81.material == var3_81.defaultGraphicMaterial then
			var3_81.material = Material.Instantiate(var3_81.defaultGraphicMaterial)
		end

		table.insert(var0_81, var3_81.material)
	end

	return var0_81, var1_81
end

function var0_0._SetFadeColor(arg0_82, arg1_82, arg2_82, arg3_82)
	for iter0_82, iter1_82 in ipairs(arg1_82) do
		if not IsNil(iter1_82) then
			iter1_82:SetColor(arg2_82[iter0_82].name, arg2_82[iter0_82].color * Color.New(arg3_82, arg3_82, arg3_82))
		end
	end
end

function var0_0.SetFadeColor(arg0_83, arg1_83, arg2_83)
	local var0_83, var1_83 = arg0_83:GetFadeColor(arg1_83)

	arg0_83:_SetFadeColor(var0_83, var1_83, arg2_83)
end

function var0_0._RevertFadeColor(arg0_84, arg1_84, arg2_84)
	arg0_84:_SetFadeColor(arg1_84, arg2_84, 1)
end

function var0_0.RevertFadeColor(arg0_85, arg1_85)
	local var0_85, var1_85 = arg0_85:GetFadeColor(arg1_85)

	arg0_85:_RevertFadeColor(var0_85, var1_85)
end

function var0_0.fadeTransform(arg0_86, arg1_86, arg2_86, arg3_86, arg4_86, arg5_86, arg6_86)
	if arg4_86 <= 0 then
		if arg6_86 then
			arg6_86()
		end

		return
	end

	local var0_86, var1_86 = arg0_86:GetFadeColor(arg1_86)

	LeanTween.value(go(arg1_86), arg2_86, arg3_86, arg4_86):setOnUpdate(System.Action_float(function(arg0_87)
		arg0_86:_SetFadeColor(var0_86, var1_86, arg0_87)
	end)):setOnComplete(System.Action(function()
		if arg5_86 then
			arg0_86:_RevertFadeColor(var0_86, var1_86)
		end

		if arg6_86 then
			arg6_86()
		end
	end))
end

function var0_0.setPaintingAlpha(arg0_89, arg1_89, arg2_89)
	local var0_89 = {}
	local var1_89 = {}
	local var2_89 = arg1_89:GetComponentsInChildren(typeof(Image))

	for iter0_89 = 0, var2_89.Length - 1 do
		local var3_89 = var2_89[iter0_89]
		local var4_89 = {
			name = "_Color",
			color = Color.white
		}

		if var3_89.material.shader.name == "UI/GrayScale" then
			var4_89 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif var3_89.material.shader.name == "UI/Line_Add_Blue" then
			var4_89 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1_89, var4_89)

		if var3_89.material == var3_89.defaultGraphicMaterial then
			var3_89.material = Material.Instantiate(var3_89.defaultGraphicMaterial)
		end

		table.insert(var0_89, var3_89.material)
	end

	for iter1_89, iter2_89 in ipairs(var0_89) do
		if not IsNil(iter2_89) then
			iter2_89:SetColor(var1_89[iter1_89].name, var1_89[iter1_89].color * Color.New(arg2_89, arg2_89, arg2_89))
		end
	end
end

function var0_0.RegisetEvent(arg0_90, arg1_90, arg2_90)
	setButtonEnabled(arg0_90._go, not arg0_90.autoNext)
	onButton(arg0_90, arg0_90._go, function()
		if arg0_90.pause or arg0_90.stop then
			return
		end

		removeOnButton(arg0_90._go)
		arg2_90()
	end, SFX_PANEL)
end

function var0_0.flashEffect(arg0_92, arg1_92, arg2_92, arg3_92, arg4_92, arg5_92, arg6_92)
	arg0_92.flashImg.color = arg4_92 and Color(0, 0, 0) or Color(1, 1, 1)
	arg0_92.flashCg.alpha = arg1_92

	setActive(arg0_92.flash, true)
	arg0_92:TweenValueForcanvasGroup(arg0_92.flashCg, arg1_92, arg2_92, arg3_92, arg5_92, arg6_92)
end

function var0_0.Flashout(arg0_93, arg1_93, arg2_93)
	local var0_93, var1_93, var2_93, var3_93 = arg1_93:GetFlashoutData()

	if not var0_93 then
		arg2_93()

		return
	end

	arg0_93:flashEffect(var0_93, var1_93, var2_93, var3_93, 0, arg2_93)
end

function var0_0.flashin(arg0_94, arg1_94, arg2_94)
	local var0_94, var1_94, var2_94, var3_94, var4_94 = arg1_94:GetFlashinData()

	if not var0_94 then
		arg2_94()

		return
	end

	arg0_94:flashEffect(var0_94, var1_94, var2_94, var3_94, var4_94, arg2_94)
end

function var0_0.UpdateBg(arg0_95, arg1_95)
	if arg1_95:ShouldBgGlitchArt() then
		arg0_95:SetBgGlitchArt(arg1_95)
	else
		local var0_95 = arg1_95:GetBgName()

		if var0_95 then
			setActive(arg0_95.bgPanel, true)

			arg0_95.bgPanelCg.alpha = 1

			local var1_95 = arg0_95.bgImage

			var1_95.color = Color.New(1, 1, 1)
			var1_95.sprite = arg0_95:GetBg(var0_95)
		end

		local var2_95 = arg1_95:GetBgShadow()

		if var2_95 then
			local var3_95 = arg0_95.bgImage

			arg0_95:TweenValue(var3_95, var2_95[1], var2_95[2], var2_95[3], 0, function(arg0_96)
				var3_95.color = Color.New(arg0_96, arg0_96, arg0_96)
			end, nil)
		end

		if arg1_95:IsBlackBg() then
			setActive(arg0_95.curtain, true)

			arg0_95.curtainCg.alpha = 1
		end

		local var4_95, var5_95 = arg1_95:IsBlackFrontGround()

		if var4_95 then
			arg0_95.curtainFCg.alpha = var5_95
		end

		setActive(arg0_95.curtainF, var4_95)
	end

	arg0_95:ApplyOldPhotoEffect(arg1_95)
	arg0_95:OnBgUpdate(arg1_95)

	local var6_95 = arg1_95:GetBgColor()

	arg0_95.curtain:GetComponent(typeof(Image)).color = var6_95
end

function var0_0.ApplyOldPhotoEffect(arg0_97, arg1_97)
	local var0_97 = arg1_97:OldPhotoEffect()
	local var1_97 = var0_97 ~= nil

	setActive(arg0_97.oldPhoto.gameObject, var1_97)

	if var1_97 then
		if type(var0_97) == "table" then
			arg0_97.oldPhoto.color = Color.New(var0_97[1], var0_97[2], var0_97[3], var0_97[4])
		else
			arg0_97.oldPhoto.color = Color.New(0.62, 0.58, 0.14, 0.36)
		end
	end
end

function var0_0.SetBgGlitchArt(arg0_98, arg1_98)
	setActive(arg0_98.bgPanel, false)
	setActive(arg0_98.bgGlitch, true)
end

function var0_0.GetBg(arg0_99, arg1_99)
	if not arg0_99.bgs[arg1_99] then
		arg0_99.bgs[arg1_99] = LoadSprite("bg/" .. arg1_99)
	end

	return arg0_99.bgs[arg1_99]
end

function var0_0.LoadEffects(arg0_100, arg1_100, arg2_100)
	local var0_100 = arg1_100:GetEffects()

	if #var0_100 <= 0 then
		arg2_100()

		return
	end

	local var1_100 = {}

	for iter0_100, iter1_100 in ipairs(var0_100) do
		local var2_100 = iter1_100.name
		local var3_100 = iter1_100.active
		local var4_100 = iter1_100.interlayer
		local var5_100 = iter1_100.center
		local var6_100 = iter1_100.adapt
		local var7_100 = arg0_100.effectPanel:Find(var2_100) or arg0_100.centerPanel:Find(var2_100)

		if var7_100 then
			setActive(var7_100, var3_100)
			setParent(var7_100, var5_100 and arg0_100.centerPanel or arg0_100.effectPanel.transform)

			if var4_100 then
				arg0_100:UpdateEffectInterLayer(var2_100, var7_100)
			end

			if not var3_100 then
				arg0_100:ClearEffectInterlayer(var2_100)
			elseif isActive(var7_100) then
				setActive(var7_100, false)
				setActive(var7_100, true)
			end

			if var6_100 then
				arg0_100:AdaptEffect(var7_100)
			end
		else
			local var8_100 = ""

			if checkABExist("ui/" .. var2_100) then
				var8_100 = "ui"
			elseif checkABExist("effect/" .. var2_100) then
				var8_100 = "effect"
			end

			if var8_100 and var8_100 ~= "" then
				table.insert(var1_100, function(arg0_101)
					LoadAndInstantiateAsync(var8_100, var2_100, function(arg0_102)
						setParent(arg0_102, var5_100 and arg0_100.centerPanel or arg0_100.effectPanel.transform)

						arg0_102.transform.localScale = Vector3.one

						setActive(arg0_102, var3_100)

						arg0_102.name = var2_100

						if var4_100 then
							arg0_100:UpdateEffectInterLayer(var2_100, arg0_102)
						end

						if var3_100 == false then
							arg0_100:ClearEffectInterlayer(var2_100)
						end

						if var6_100 then
							arg0_100:AdaptEffect(arg0_102)
						end

						arg0_101()
					end)
				end)
			else
				originalPrint("not found effect", var2_100)
			end
		end
	end

	parallelAsync(var1_100, arg2_100)
end

function var0_0.AdaptEffect(arg0_103, arg1_103)
	local var0_103 = 1.77777777777778
	local var1_103 = pg.UIMgr.GetInstance().OverlayMain.parent.sizeDelta
	local var2_103 = var1_103.x / var1_103.y
	local var3_103 = 1

	if var0_103 < var2_103 then
		var3_103 = var2_103 / var0_103
	else
		var3_103 = var0_103 / var2_103
	end

	tf(arg1_103).localScale = Vector3(var3_103, var3_103, var3_103)
end

function var0_0.UpdateEffectInterLayer(arg0_104, arg1_104, arg2_104)
	local var0_104 = arg0_104._go:GetComponent(typeof(Canvas)).sortingOrder
	local var1_104 = arg2_104:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

	for iter0_104 = 1, var1_104.Length - 1 do
		local var2_104 = var1_104[iter0_104 - 1]
		local var3_104 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var2_104)

		if var0_104 < var3_104 then
			var0_104 = var3_104
		end
	end

	local var4_104 = var0_104 + 1
	local var5_104 = GetOrAddComponent(arg0_104.actorTr, typeof(Canvas))

	var5_104.overrideSorting = true
	var5_104.sortingOrder = var4_104

	local var6_104 = GetOrAddComponent(arg0_104.frontTr, typeof(Canvas))

	var6_104.overrideSorting = true
	var6_104.sortingOrder = var4_104 + 1
	arg0_104.activeInterLayer = arg1_104

	GetOrAddComponent(arg0_104.frontTr, typeof(GraphicRaycaster))
end

function var0_0.ClearEffectInterlayer(arg0_105, arg1_105)
	if arg0_105.activeInterLayer == arg1_105 then
		RemoveComponent(arg0_105.actorTr, "Canvas")
		RemoveComponent(arg0_105.frontTr, "Canvas")
		RemoveComponent(arg0_105.frontTr, "GraphicRaycaster")

		arg0_105.activeInterLayer = nil
	end
end

function var0_0.ClearEffects(arg0_106)
	removeAllChildren(arg0_106.effectPanel)
	removeAllChildren(arg0_106.centerPanel)

	if arg0_106.activeInterLayer ~= nil then
		arg0_106:ClearEffectInterlayer(arg0_106.activeInterLayer)
	end
end

function var0_0.PlaySoundEffect(arg0_107, arg1_107)
	if arg1_107:ShouldPlaySoundEffect() then
		local var0_107, var1_107 = arg1_107:GetSoundeffect()

		arg0_107:DelayCall(var1_107, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_107)
		end)
	end

	if arg1_107:ShouldPlayVoice() then
		arg0_107:PlayVoice(arg1_107)
	elseif arg1_107:ShouldStopVoice() then
		arg0_107:StopVoice()
	end
end

function var0_0.StopVoice(arg0_109)
	if arg0_109.currentVoice then
		arg0_109.currentVoice:Stop(true)

		arg0_109.currentVoice = nil
	end
end

function var0_0.PlayVoice(arg0_110, arg1_110)
	if arg0_110.voiceDelayTimer then
		arg0_110.voiceDelayTimer:Stop()

		arg0_110.voiceDelayTimer = nil
	end

	arg0_110:StopVoice()

	local var0_110, var1_110 = arg1_110:GetVoice()
	local var2_110

	var2_110 = arg0_110:CreateDelayTimer(var1_110, function()
		if var2_110 then
			var2_110:Stop()
		end

		if arg0_110.voiceDelayTimer then
			arg0_110.voiceDelayTimer = nil
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_110, function(arg0_112)
			if arg0_112 then
				arg0_110.currentVoice = arg0_112.playback
			end
		end)
	end)
	arg0_110.voiceDelayTimer = var2_110
end

function var0_0.Reset(arg0_113, arg1_113, arg2_113, arg3_113)
	setActive(arg0_113.spAnimPanel, false)
	setActive(arg0_113.castPanel, false)
	setActive(arg0_113.bgPanel, false)
	setActive(arg0_113.dialoguePanel, false)
	setActive(arg0_113.asidePanel, false)
	setActive(arg0_113.curtain, false)
	setActive(arg0_113.flash, false)
	setActive(arg0_113.optionsCg.gameObject, false)
	setActive(arg0_113.bgGlitch, false)
	setActive(arg0_113.locationTr, false)

	arg0_113.locationTr.localPosition = arg0_113.locationTrPos
	arg0_113.locationStatus = var9_0
	arg0_113.flashCg.alpha = 1
	arg0_113.goCG.alpha = 1

	arg0_113.animationPlayer:Stop()
	arg0_113:OnReset(arg1_113, arg2_113, arg3_113)
end

function var0_0.Clear(arg0_114, arg1_114)
	if arg0_114.step then
		arg0_114:ClearMoveNodes(arg0_114.step)
	end

	arg0_114.bgs = {}
	arg0_114.skipOption = nil
	arg0_114.step = nil
	arg0_114.goCG.alpha = 1
	arg0_114.callback = nil
	arg0_114.autoNext = nil
	arg0_114.script = nil
	arg0_114.bgImage.sprite = nil

	arg0_114:OnClear()

	if arg1_114 then
		arg1_114()
	end

	pg.DelegateInfo.New(arg0_114)
end

function var0_0.StoryEnd(arg0_115)
	setActive(arg0_115.iconImage.gameObject, false)

	arg0_115.iconImage.sprite = nil
	arg0_115.branchCodeList = {}
	arg0_115.stop = false
	arg0_115.pause = false

	if arg0_115.voiceDelayTimer then
		arg0_115.voiceDelayTimer:Stop()

		arg0_115.voiceDelayTimer = nil
	end

	if arg0_115.currentVoice then
		arg0_115.currentVoice:Stop(true)

		arg0_115.currentVoice = nil
	end

	arg0_115:ClearEffects()
	arg0_115:Clear()
	arg0_115:OnEnd()
end

function var0_0.PlayBgm(arg0_116, arg1_116)
	if arg1_116:ShouldStopBgm() then
		arg0_116:StopBgm()
	end

	if arg1_116:ShoulePlayBgm() then
		local var0_116, var1_116, var2_116 = arg1_116:GetBgmData()

		arg0_116:DelayCall(var1_116, function()
			arg0_116:RevertBgmVolume()
			pg.BgmMgr.GetInstance():TempPlay(var0_116)
		end)

		if var2_116 and var2_116 > 0 then
			arg0_116.defaultBgmVolume = pg.CriMgr.GetInstance():getBGMVolume()

			pg.CriMgr.GetInstance():setBGMVolume(var2_116)
		end
	end
end

function var0_0.StopBgm(arg0_118, arg1_118)
	arg0_118:RevertBgmVolume()
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0_0.RevertBgmVolume(arg0_119)
	if arg0_119.defaultBgmVolume then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_119.defaultBgmVolume)

		arg0_119.defaultBgmVolume = nil
	end
end

function var0_0.StartUIAnimations(arg0_120, arg1_120, arg2_120)
	parallelAsync({
		function(arg0_121)
			arg0_120:StartBlinkAnimation(arg1_120, arg0_121)
		end,
		function(arg0_122)
			arg0_120:StartBlinkWithColorAnimation(arg1_120, arg0_122)
		end,
		function(arg0_123)
			arg0_120:OnStartUIAnimations(arg1_120, arg0_123)
		end
	}, arg2_120)
end

function var0_0.StartBlinkAnimation(arg0_124, arg1_124, arg2_124)
	if arg1_124:ShouldBlink() then
		local var0_124 = arg1_124:GetBlinkData()
		local var1_124 = var0_124.black
		local var2_124 = var0_124.number
		local var3_124 = var0_124.dur
		local var4_124 = var0_124.delay
		local var5_124 = var0_124.alpha[1]
		local var6_124 = var0_124.alpha[2]
		local var7_124 = var0_124.wait

		arg0_124.flashImg.color = var1_124 and Color(0, 0, 0) or Color(1, 1, 1)

		setActive(arg0_124.flash, true)

		local var8_124 = {}

		for iter0_124 = 1, var2_124 do
			table.insert(var8_124, function(arg0_125)
				arg0_124:TweenAlpha(arg0_124.flash, var5_124, var6_124, var3_124 / 2, 0, function()
					arg0_124:TweenAlpha(arg0_124.flash, var6_124, var5_124, var3_124 / 2, var7_124, arg0_125)
				end)
			end)
		end

		seriesAsync(var8_124, function()
			setActive(arg0_124.flash, false)
		end)
	end

	arg2_124()
end

function var0_0.StartBlinkWithColorAnimation(arg0_128, arg1_128, arg2_128)
	if arg1_128:ShouldBlinkWithColor() then
		local var0_128 = arg1_128:GetBlinkWithColorData()
		local var1_128 = var0_128.color
		local var2_128 = var0_128.alpha

		arg0_128.flashImg.color = Color(var1_128[1], var1_128[2], var1_128[3], var1_128[4])

		setActive(arg0_128.flash, true)

		local var3_128 = {}

		for iter0_128, iter1_128 in ipairs(var2_128) do
			local var4_128 = iter1_128[1]
			local var5_128 = iter1_128[2]
			local var6_128 = iter1_128[3]
			local var7_128 = iter1_128[4]

			table.insert(var3_128, function(arg0_129)
				arg0_128:TweenValue(arg0_128.flash, var4_128, var5_128, var6_128, var7_128, function(arg0_130)
					arg0_128.flashCg.alpha = arg0_130
				end, arg0_129)
			end)
		end

		parallelAsync(var3_128, function()
			setActive(arg0_128.flash, false)
		end)
	end

	arg2_128()
end

function var0_0.findTF(arg0_132, arg1_132, arg2_132)
	assert(arg0_132._tf, "transform should exist")

	return findTF(arg2_132 or arg0_132._tf, arg1_132)
end

function var0_0.OnStart(arg0_133, arg1_133)
	return
end

function var0_0.OnReset(arg0_134, arg1_134, arg2_134, arg3_134)
	arg3_134()
end

function var0_0.OnBgUpdate(arg0_135, arg1_135)
	return
end

function var0_0.OnInit(arg0_136, arg1_136, arg2_136, arg3_136)
	if arg3_136 then
		arg3_136()
	end
end

function var0_0.OnStartUIAnimations(arg0_137, arg1_137, arg2_137)
	if arg2_137 then
		arg2_137()
	end
end

function var0_0.OnEnter(arg0_138, arg1_138, arg2_138, arg3_138)
	if arg3_138 then
		arg3_138()
	end
end

function var0_0.OnWillExit(arg0_139, arg1_139, arg2_139, arg3_139)
	arg3_139()
end

function var0_0.OnWillClear(arg0_140, arg1_140)
	return
end

function var0_0.OnClear(arg0_141)
	return
end

function var0_0.OnEnd(arg0_142)
	return
end

return var0_0
