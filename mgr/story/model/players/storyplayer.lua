local var0 = class("StoryPlayer", import("..animation.StoryAnimtion"))
local var1 = 0
local var2 = 1
local var3 = 2
local var4 = 3
local var5 = 4
local var6 = 5
local var7 = 6
local var8 = 7
local var9 = 0
local var10 = 1
local var11 = 2

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0)
	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.animationPlayer = arg0._tf:GetComponent(typeof(Animation))
	arg0.front = arg0:findTF("front")
	arg0.actorTr = arg0._tf:Find("actor")
	arg0.frontTr = arg0._tf:Find("front")
	arg0.backPanel = arg0:findTF("back")
	arg0.goCG = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0.asidePanel = arg0:findTF("front/aside_panel")
	arg0.bgGlitch = arg0:findTF("back/bg_glitch")
	arg0.oldPhoto = arg0:findTF("front/oldphoto"):GetComponent(typeof(Image))
	arg0.bgPanel = arg0:findTF("back/bg")
	arg0.bgPanelCg = arg0.bgPanel:GetComponent(typeof(CanvasGroup))
	arg0.bgImage = arg0:findTF("image", arg0.bgPanel):GetComponent(typeof(Image))
	arg0.mainImg = arg0._tf:GetComponent(typeof(Image))
	arg0.castPanel = arg0:findTF("front/cast_panel")
	arg0.centerPanel = arg0._tf:Find("center")
	arg0.actorPanel = arg0:findTF("actor")
	arg0.dialoguePanel = arg0:findTF("front/dialogue")
	arg0.effectPanel = arg0:findTF("front/effect")
	arg0.movePanel = arg0:findTF("front/move_layer")
	arg0.curtain = arg0:findTF("back/curtain")
	arg0.curtainCg = arg0.curtain:GetComponent(typeof(CanvasGroup))
	arg0.flash = arg0:findTF("front/flash")
	arg0.flashImg = arg0.flash:GetComponent(typeof(Image))
	arg0.flashCg = arg0.flash:GetComponent(typeof(CanvasGroup))
	arg0.curtainF = arg0:findTF("back/curtain_front")
	arg0.curtainFCg = arg0.curtainF:GetComponent(typeof(CanvasGroup))
	arg0.locationTr = arg0:findTF("front/location")
	arg0.locationTxt = arg0:findTF("front/location/Text"):GetComponent(typeof(Text))
	arg0.locationTrPos = arg0.locationTr.localPosition
	arg0.locationAnim = arg0.locationTr:GetComponent(typeof(Animation))
	arg0.locationAniEvent = arg0.locationTr:GetComponent(typeof(DftAniEvent))
	arg0.iconImage = arg0:findTF("front/icon"):GetComponent(typeof(Image))
	arg0.dialogueWin = nil
	arg0.bgs = {}
	arg0.branchCodeList = {}
	arg0.stop = false
	arg0.pause = false
end

function var0.StoryStart(arg0, arg1)
	arg0.branchCodeList = {}

	eachChild(arg0.dialoguePanel, function(arg0)
		setActive(arg0, false)
	end)

	arg0.dialogueWin = arg0.dialoguePanel:Find(arg1:GetDialogueStyleName())

	setActive(arg0.dialogueWin, true)

	arg0.optionLUIlist = UIItemList.New(arg0.dialogueWin:Find("options_panel/options_l"), arg0.dialogueWin:Find("options_panel/options_l/option_tpl"))
	arg0.optionCUIlist = UIItemList.New(arg0.dialogueWin:Find("options_panel/options_c"), arg0.dialogueWin:Find("options_panel/options_c/option_tpl"))
	arg0.optionsCg = arg0.dialogueWin:Find("options_panel"):GetComponent(typeof(CanvasGroup))

	arg0:OnStart(arg1)
end

function var0.GetOptionContainer(arg0, arg1)
	local var0 = arg1:GetOptionCnt()

	if arg0.script:IsDialogueStyle2() then
		setActive(arg0.optionLUIlist.container, true)
		setActive(arg0.optionCUIlist.container, false)

		return arg0.optionLUIlist, true
	end

	if var0 <= 3 then
		setActive(arg0.optionLUIlist.container, false)
		setActive(arg0.optionCUIlist.container, true)

		return arg0.optionCUIlist, false
	else
		setActive(arg0.optionLUIlist.container, true)
		setActive(arg0.optionCUIlist.container, false)

		return arg0.optionLUIlist, true
	end
end

function var0.Pause(arg0)
	arg0.pause = true

	arg0:PauseAllAnimation()
	pg.ViewUtils.SetLayer(arg0.effectPanel, Layer.UIHidden)
end

function var0.Resume(arg0)
	arg0.pause = false

	arg0:ResumeAllAnimation()
	pg.ViewUtils.SetLayer(arg0.effectPanel, Layer.UI)
end

function var0.Stop(arg0)
	arg0.stop = true

	arg0:NextOneImmediately()
end

function var0.Play(arg0, arg1, arg2, arg3)
	if not arg1 then
		arg3()

		return
	end

	if arg1:GetNextScriptName() or arg0.stop then
		arg3()

		return
	end

	local var0 = arg1:GetStepByIndex(arg2)

	if not var0 then
		arg3()

		return
	end

	pg.NewStoryMgr.GetInstance():AddRecord(var0)

	if var0:ShouldJumpToNextScript() then
		arg1:SetNextScriptName(var0:GetNextScriptName())
		arg3()

		return
	end

	local var1 = arg1:ShouldSkipAll()

	if var1 then
		arg0:ClearEffects()
	end

	local var2 = false

	if var1 and var0:IsImport() and not pg.NewStoryMgr.GetInstance():IsReView() then
		var2 = true
	elseif var1 then
		arg3()

		return
	end

	arg0.script = arg1
	arg0.callback = arg3
	arg0.step = var0
	arg0.autoNext = arg1:GetAutoPlayFlag()
	arg0.stage = var1

	local var3 = arg1:GetTriggerDelayTime()

	if arg0.autoNext and var0:IsImport() and not var0.optionSelCode then
		arg0.autoNext = nil
	end

	arg0:SetTimeScale(1 - arg1:GetPlaySpeed() * 0.1)

	local var4 = arg1:GetPrevStep(arg2)

	seriesAsync({
		function(arg0)
			if not arg0:NextStage(var2) then
				return
			end

			parallelAsync({
				function(arg0)
					arg0:Reset(var0, var4, arg0)
					arg0:UpdateBg(var0)
					arg0:PlayBgm(var0)
				end,
				function(arg0)
					arg0:LoadEffects(var0, arg0)
				end,
				function(arg0)
					arg0:ApplyEffects(var0, arg0)
				end,
				function(arg0)
					arg0:flashin(var0, arg0)
				end
			}, arg0)
		end,
		function(arg0)
			if var2 then
				arg1:StopSkip()
			end

			var2 = false

			arg0()
		end,
		function(arg0)
			if not arg0:NextStage(var3) then
				return
			end

			parallelAsync({
				function(arg0)
					arg0:OnInit(var0, var4, arg0)
				end,
				function(arg0)
					arg0:PlaySoundEffect(var0)
					arg0:StartUIAnimations(var0, arg0)
				end,
				function(arg0)
					arg0:OnEnter(var0, var4, arg0)
				end,
				function(arg0)
					arg0:StartMoveNode(var0, arg0)
				end,
				function(arg0)
					arg0:UpdateIcon(var0, arg0)
				end,
				function(arg0)
					arg0:SetLocation(var0, arg0)
				end,
				function(arg0)
					arg0:DispatcherEvent(var0, arg0)
				end
			}, arg0)
		end,
		function(arg0)
			arg0:ClearCheckDispatcher()

			if not arg0:NextStage(var4) then
				return
			end

			if not var0:ShouldDelayEvent() then
				arg0()

				return
			end

			arg0:DelayCall(var0:GetEventDelayTime(), arg0)
		end,
		function(arg0)
			if not arg0:NextStage(var5) then
				return
			end

			if arg0.skipOption then
				arg0()

				return
			end

			if var0:SkipEventForOption() then
				arg0()

				return
			end

			if arg0:ShouldAutoTrigger() then
				arg0:UnscaleDelayCall(var3, arg0)

				return
			end

			arg0:RegisetEvent(arg0)
			arg0:TriggerEventIfAuto(var3)
		end,
		function(arg0)
			if not arg0:NextStage(var6) then
				return
			end

			if not var0:ExistOption() then
				arg0()

				return
			end

			if arg0.skipOption then
				arg0.skipOption = false

				arg0()

				return
			end

			arg0:InitBranches(arg1, var0, function(arg0)
				arg0()
			end, function()
				arg0:TriggerOptionIfAuto(var3, var0)
			end)
		end,
		function(arg0)
			if not arg0:NextStage(var7) then
				return
			end

			arg0.autoNext = nil

			local var0 = arg1:GetNextStep(arg2)

			seriesAsync({
				function(arg0)
					arg0:ClearAnimation()
					arg0:ClearApplyEffect()
					arg0:OnWillExit(var0, var0, arg0)
				end,
				function(arg0)
					parallelAsync({
						function(arg0)
							if not var0 then
								arg0()

								return
							end

							arg0:Flashout(var0, arg0)
						end,
						function(arg0)
							if var0 then
								arg0()

								return
							end

							arg0:FadeOutStory(arg0.script, arg0)
						end
					}, arg0)
				end
			}, arg0)
		end,
		function(arg0)
			if not arg0:NextStage(var8) then
				return
			end

			arg0:OnWillClear(var0)
			arg0:Clear(arg0)
		end
	}, arg3)
end

function var0.NextStage(arg0, arg1)
	if arg0.stage == arg1 - 1 then
		arg0.stage = arg1

		return true
	end

	return false
end

function var0.ApplyEffects(arg0, arg1, arg2)
	if arg1:ShouldShake() then
		arg0:ApplyShakeEffect(arg1)
	end

	arg2()
end

function var0.ApplyShakeEffect(arg0, arg1)
	if not arg1:ShouldShake() then
		return
	end

	arg0.animationPlayer:Play("anim_storyrecordUI_shake_loop")

	local var0 = arg1:GetShakeTime()

	arg0.playingShakeAnim = true

	arg0:DelayCall(var0, function()
		arg0:ClearShakeEffect()
	end)
end

function var0.ClearShakeEffect(arg0)
	if arg0.playingShakeAnim then
		arg0.animationPlayer:Play("anim_storyrecordUI_shake_reset")

		arg0.playingShakeAnim = nil
	end
end

function var0.ClearApplyEffect(arg0)
	arg0:ClearShakeEffect()
end

function var0.DispatcherEvent(arg0, arg1, arg2)
	if not arg1:ExistDispatcher() then
		arg2()

		return
	end

	local var0 = arg1:GetDispatcher()

	pg.NewStoryMgr.GetInstance():ClearStoryEvent()
	pg.m02:sendNotification(var0.name, {
		data = var0.data,
		callbackData = var0.callbackData,
		flags = arg0.branchCodeList[arg1:GetId()] or {}
	})

	if arg1:ShouldHideUI() then
		setActive(arg0._tf, false)
	end

	if arg1:IsRecallDispatcher() then
		arg0:CheckDispatcher(arg1, arg2)
	else
		arg2()
	end
end

function var0.CheckDispatcher(arg0, arg1, arg2)
	local var0 = arg1:GetDispatcherRecallName()

	arg0.checkTimer = Timer.New(function()
		if pg.NewStoryMgr.GetInstance():CheckStoryEvent(var0) then
			local var0 = pg.NewStoryMgr.GetInstance():GetStoryEventArg(var0)

			if var0 and var0.optionIndex then
				arg0:SetBranchCode(arg0.script, arg1, var0.optionIndex)

				arg0.skipOption = true
			end

			if arg1:ShouldHideUI() then
				setActive(arg0._tf, true)
			end

			arg0:ClearCheckDispatcher()
			arg2()
		end
	end, 1, -1)

	arg0.checkTimer:Start()
	arg0.checkTimer.func()
end

function var0.ClearCheckDispatcher(arg0)
	if arg0.checkTimer then
		arg0.checkTimer:Stop()

		arg0.checkTimer = nil
	end
end

function var0.TriggerEventIfAuto(arg0, arg1)
	if not arg0:ShouldAutoTrigger() then
		return
	end

	arg0:UnscaleDelayCall(arg1, function()
		if not arg0.autoNext then
			setButtonEnabled(arg0._go, true)

			return
		end

		triggerButton(arg0._go)
	end)
end

function var0.TriggerOptionIfAuto(arg0, arg1, arg2)
	if not arg0:ShouldAutoTrigger() then
		return
	end

	if not arg2 or not arg2:ExistOption() then
		return
	end

	arg0:UnscaleDelayCall(arg1, function()
		if not arg0.autoNext then
			return
		end

		local var0 = arg2:GetOptionIndexByAutoSel()

		if var0 ~= nil then
			local var1 = arg0:GetOptionContainer(arg2).container:GetChild(var0 - 1)

			triggerButton(var1)
		end
	end)
end

function var0.ShouldAutoTrigger(arg0)
	if arg0.pause or arg0.stop then
		return false
	end

	return arg0.autoNext
end

function var0.CanSkip(arg0)
	return arg0.step and not arg0.step:IsImport()
end

function var0.CancelAuto(arg0)
	arg0.autoNext = false
end

function var0.NextOne(arg0)
	arg0.timeScale = 0.0001

	if arg0.stage == var1 then
		arg0.autoNext = true
	elseif arg0.stage == var5 then
		arg0.autoNext = true

		arg0:TriggerEventIfAuto(0)
	elseif arg0.stage == var6 then
		arg0:TriggerOptionIfAuto(0, arg0.step)
	end
end

function var0.NextOneImmediately(arg0)
	local var0 = arg0.callback

	if var0 then
		arg0:ClearAnimation()
		arg0:Clear()
		var0()
	end
end

function var0.SetLocation(arg0, arg1, arg2)
	if not arg1:ExistLocation() then
		arg0.locationAniEvent:SetEndEvent(nil)
		arg2()

		return
	end

	setActive(arg0.locationTr, true)

	local var0 = arg1:GetLocation()

	arg0.locationTxt.text = var0.text

	local function var1()
		arg0:DelayCall(var0.time, function()
			arg0.locationAnim:Play("anim_newstoryUI_iocation_out")

			arg0.locationStatus = var11
		end)
	end

	arg0.locationAniEvent:SetEndEvent(function()
		if arg0.locationStatus == var10 then
			var1()
			arg2()
		elseif arg0.locationStatus == var11 then
			setActive(arg0.locationTr, false)

			arg0.locationStatus = var9
		end
	end)
	arg0.locationAnim:Play("anim_newstoryUI_iocation_in")

	arg0.locationStatus = var10
end

function var0.UpdateIcon(arg0, arg1, arg2)
	if not arg1:ExistIcon() then
		setActive(arg0.iconImage.gameObject, false)
		arg2()

		return
	end

	local var0 = arg1:GetIconData()

	arg0.iconImage.sprite = LoadSprite(var0.image)

	arg0.iconImage:SetNativeSize()

	local var1 = arg0.iconImage.gameObject.transform

	if var0.pos then
		var1.localPosition = Vector3(var0.pos[1], var0.pos[2], 0)
	else
		var1.localPosition = Vector3.one
	end

	var1.localScale = Vector3(var0.scale or 1, var0.scale or 1, 1)

	setActive(arg0.iconImage.gameObject, true)
	arg2()
end

function var0.UpdateOptionTxt(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(LayoutElement))
	local var1 = arg2:Find("content")

	if arg1 then
		local var2 = GetPerceptualSize(arg3)
		local var3 = arg2:Find("content_max")
		local var4 = var2 >= 17
		local var5 = var4 and var3 or var1

		setActive(var1, not var4)
		setActive(var3, var4)
		setText(var5:Find("Text"), arg3)

		var0.preferredHeight = var5.rect.height
	else
		setText(var1:Find("Text"), arg3)

		var0.preferredHeight = var1.rect.height
	end
end

function var0.InitBranches(arg0, arg1, arg2, arg3, arg4)
	local var0 = false
	local var1 = arg2:GetOptions()
	local var2, var3 = arg0:GetOptionContainer(arg2)
	local var4 = arg2:GetId()
	local var5 = arg0.branchCodeList[var4] or {}
	local var6 = GetOrAddComponent(var2.container, typeof(CanvasGroup))

	var6.blocksRaycasts = true
	arg0.selectedBranchID = nil

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2
			local var1 = var1[arg1 + 1][1]
			local var2 = var1[arg1 + 1][2]
			local var3 = table.contains(var5, var2)

			onButton(arg0, var0, function()
				if arg0.pause or arg0.stop then
					return
				end

				if not var0 then
					return
				end

				arg0.selectedBranchID = arg1

				arg0:SetBranchCode(arg1, arg2, var2)

				local var0 = arg2:GetComponent(typeof(Animation))

				if var0 then
					var6.blocksRaycasts = false

					var0:Play("anim_storydialogue_optiontpl_confirm")
					arg2:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
						setActive(arg0.optionsCg.gameObject, false)

						var6.blocksRaycasts = true

						arg3(var1)
					end)
				else
					setActive(arg0.optionsCg.gameObject, false)
					arg3(var1)
				end

				arg0:HideBranchesWithoutSelected(arg2)
			end, SFX_PANEL)
			setButtonEnabled(var0, not var3)

			GetOrAddComponent(arg2, typeof(CanvasGroup)).alpha = var3 and 0.5 or 1

			arg0:UpdateOptionTxt(var3, var0, var1)
		end
	end)
	var2:align(#var1)
	arg0:ShowBranches(arg2, function()
		var0 = true

		if arg4 then
			arg4()
		end
	end)
end

function var0.SetBranchCode(arg0, arg1, arg2, arg3)
	arg2:SetBranchCode(arg3)
	arg1:SetBranchCode(arg3)

	local var0 = arg2:GetId()

	if not arg0.branchCodeList[var0] then
		arg0.branchCodeList[var0] = {}
	end

	table.insert(arg0.branchCodeList[var0], arg3)
end

function var0.ShowBranches(arg0, arg1, arg2)
	setActive(arg0.optionsCg.gameObject, true)

	local var0 = arg0:GetOptionContainer(arg1)

	for iter0 = 0, var0.container.childCount - 1 do
		local var1 = var0.container:GetChild(iter0):GetComponent(typeof(Animation))

		if var1 then
			var1:Play("anim_storydialogue_optiontpl_in")
		end
	end

	arg2()
end

function var0.HideBranchesWithoutSelected(arg0, arg1)
	local var0 = arg0:GetOptionContainer(arg1)

	for iter0 = 0, var0.container.childCount - 1 do
		if iter0 ~= arg0.selectedBranchID then
			local var1 = var0.container:GetChild(iter0):GetComponent(typeof(Animation))

			if var1 then
				var1:Play("anim_storydialogue_optiontpl_unselected")
			end
		end
	end
end

function var0.StartMoveNode(arg0, arg1, arg2)
	if not arg1:ExistMovableNode() then
		arg2()

		return
	end

	local var0 = arg1:GetMovableNode()
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var1, function(arg0)
			arg0:LoadMovableNode(iter1, function(arg0)
				var2[iter0] = arg0

				arg0()
			end)
		end)
	end

	parallelAsync(var1, function()
		arg0:MoveAllNode(arg1, var2, var0)
		arg2()
	end)
end

function var0.MoveAllNode(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0, iter1 in pairs(arg2) do
		table.insert(var0, function(arg0)
			local var0 = arg3[iter0]
			local var1 = var0.path
			local var2 = var0.time
			local var3 = var0.easeType
			local var4 = var0.delay

			arg0:moveLocalPath(iter1, var1, var2, var4, var3, arg0)
		end)
	end

	arg0.moveTargets = arg2

	parallelAsync(var0, function()
		arg0:ClearMoveNodes(arg1)
	end)
end

local function var12(arg0, arg1, arg2, arg3, arg4)
	PoolMgr.GetInstance():GetSpineChar(arg1, true, function(arg0)
		arg0.transform:SetParent(arg0.movePanel)

		local var0 = arg2.scale

		arg0.transform.localScale = Vector3(var0, var0, 0)
		arg0.transform.localPosition = arg3

		arg0:GetComponent(typeof(SpineAnimUI)):SetAction(arg2.action, 0)

		arg0.name = arg1

		if arg4 then
			arg4(arg0)
		end
	end)
end

local function var13(arg0, arg1, arg2, arg3)
	local var0 = GameObject.New("movable")

	var0.transform:SetParent(arg0.movePanel)

	var0.transform.localScale = Vector3.zero

	local var1 = GetOrAddComponent(var0, typeof(RectTransform))
	local var2 = GetOrAddComponent(var0, typeof(Image))

	LoadSpriteAsync(arg1, function(arg0)
		var2.sprite = arg0

		var2:SetNativeSize()

		var1.localScale = Vector3.one
		var1.localPosition = arg2

		arg3(var1.gameObject)
	end)
end

function var0.LoadMovableNode(arg0, arg1, arg2)
	local var0 = arg1.path[1] or Vector3.zero

	if arg1.isSpine then
		var12(arg0, arg1.name, arg1.spineData, var0, arg2)
	else
		var13(arg0, arg1.name, var0, arg2)
	end
end

function var0.ClearMoveNodes(arg0, arg1)
	if not arg1:ExistMovableNode() then
		return
	end

	if arg0.movePanel.childCount <= 0 then
		return
	end

	for iter0, iter1 in ipairs(arg0.moveTargets or {}) do
		if iter1:GetComponent(typeof(SpineAnimUI)) ~= nil then
			PoolMgr.GetInstance():ReturnSpineChar(iter1.name, iter1.gameObject)
		else
			Object.Destroy(iter1.gameObject)
		end
	end

	arg0.moveTargets = {}
end

function var0.FadeOutStory(arg0, arg1, arg2)
	if not arg1:ShouldFadeout() then
		arg2()

		return
	end

	local var0 = arg1:GetFadeoutTime()

	if not arg1:ShouldWaitFadeout() then
		arg0:fadeTransform(arg0._go, 1, 0.3, var0, true)
		arg2()
	else
		arg0:fadeTransform(arg0._go, 1, 0.3, var0, true, arg2)
	end
end

function var0.GetFadeColor(arg0, arg1)
	local var0 = {}
	local var1 = {}
	local var2 = arg1:GetComponentsInChildren(typeof(Image))

	for iter0 = 0, var2.Length - 1 do
		local var3 = var2[iter0]
		local var4 = {
			name = "_Color",
			color = Color.white
		}

		if var3.material.shader.name == "UI/GrayScale" then
			var4 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif var3.material.shader.name == "UI/Line_Add_Blue" then
			var4 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1, var4)

		if var3.material == var3.defaultGraphicMaterial then
			var3.material = Material.Instantiate(var3.defaultGraphicMaterial)
		end

		table.insert(var0, var3.material)
	end

	return var0, var1
end

function var0._SetFadeColor(arg0, arg1, arg2, arg3)
	for iter0, iter1 in ipairs(arg1) do
		if not IsNil(iter1) then
			iter1:SetColor(arg2[iter0].name, arg2[iter0].color * Color.New(arg3, arg3, arg3))
		end
	end
end

function var0.SetFadeColor(arg0, arg1, arg2)
	local var0, var1 = arg0:GetFadeColor(arg1)

	arg0:_SetFadeColor(var0, var1, arg2)
end

function var0._RevertFadeColor(arg0, arg1, arg2)
	arg0:_SetFadeColor(arg1, arg2, 1)
end

function var0.RevertFadeColor(arg0, arg1)
	local var0, var1 = arg0:GetFadeColor(arg1)

	arg0:_RevertFadeColor(var0, var1)
end

function var0.fadeTransform(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	if arg4 <= 0 then
		if arg6 then
			arg6()
		end

		return
	end

	local var0, var1 = arg0:GetFadeColor(arg1)

	LeanTween.value(go(arg1), arg2, arg3, arg4):setOnUpdate(System.Action_float(function(arg0)
		arg0:_SetFadeColor(var0, var1, arg0)
	end)):setOnComplete(System.Action(function()
		if arg5 then
			arg0:_RevertFadeColor(var0, var1)
		end

		if arg6 then
			arg6()
		end
	end))
end

function var0.setPaintingAlpha(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}
	local var2 = arg1:GetComponentsInChildren(typeof(Image))

	for iter0 = 0, var2.Length - 1 do
		local var3 = var2[iter0]
		local var4 = {
			name = "_Color",
			color = Color.white
		}

		if var3.material.shader.name == "UI/GrayScale" then
			var4 = {
				name = "_GrayScale",
				color = Color.New(0.211764705882353, 0.713725490196078, 0.0705882352941176)
			}
		elseif var3.material.shader.name == "UI/Line_Add_Blue" then
			var4 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.588235294117647)
			}
		end

		table.insert(var1, var4)

		if var3.material == var3.defaultGraphicMaterial then
			var3.material = Material.Instantiate(var3.defaultGraphicMaterial)
		end

		table.insert(var0, var3.material)
	end

	for iter1, iter2 in ipairs(var0) do
		if not IsNil(iter2) then
			iter2:SetColor(var1[iter1].name, var1[iter1].color * Color.New(arg2, arg2, arg2))
		end
	end
end

function var0.RegisetEvent(arg0, arg1)
	setButtonEnabled(arg0._go, not arg0.autoNext)
	onButton(arg0, arg0._go, function()
		if arg0.pause or arg0.stop then
			return
		end

		removeOnButton(arg0._go)
		arg1()
	end, SFX_PANEL)
end

function var0.flashEffect(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0.flashImg.color = arg4 and Color(0, 0, 0) or Color(1, 1, 1)
	arg0.flashCg.alpha = arg1

	setActive(arg0.flash, true)
	arg0:TweenValueForcanvasGroup(arg0.flashCg, arg1, arg2, arg3, arg5, arg6)
end

function var0.Flashout(arg0, arg1, arg2)
	local var0, var1, var2, var3 = arg1:GetFlashoutData()

	if not var0 then
		arg2()

		return
	end

	arg0:flashEffect(var0, var1, var2, var3, 0, arg2)
end

function var0.flashin(arg0, arg1, arg2)
	local var0, var1, var2, var3, var4 = arg1:GetFlashinData()

	if not var0 then
		arg2()

		return
	end

	arg0:flashEffect(var0, var1, var2, var3, var4, arg2)
end

function var0.UpdateBg(arg0, arg1)
	if arg1:ShouldBgGlitchArt() then
		arg0:SetBgGlitchArt(arg1)
	else
		local var0 = arg1:GetBgName()

		if var0 then
			setActive(arg0.bgPanel, true)

			arg0.bgPanelCg.alpha = 1

			local var1 = arg0.bgImage

			var1.color = Color.New(1, 1, 1)
			var1.sprite = arg0:GetBg(var0)
		end

		local var2 = arg1:GetBgShadow()

		if var2 then
			local var3 = arg0.bgImage

			arg0:TweenValue(var3, var2[1], var2[2], var2[3], 0, function(arg0)
				var3.color = Color.New(arg0, arg0, arg0)
			end, nil)
		end

		if arg1:IsBlackBg() then
			setActive(arg0.curtain, true)

			arg0.curtainCg.alpha = 1
		end

		local var4, var5 = arg1:IsBlackFrontGround()

		if var4 then
			arg0.curtainFCg.alpha = var5
		end

		setActive(arg0.curtainF, var4)
	end

	arg0:ApplyOldPhotoEffect(arg1)
	arg0:OnBgUpdate(arg1)

	local var6 = arg1:GetBgColor()

	arg0.curtain:GetComponent(typeof(Image)).color = var6
end

function var0.ApplyOldPhotoEffect(arg0, arg1)
	local var0 = arg1:OldPhotoEffect()
	local var1 = var0 ~= nil

	setActive(arg0.oldPhoto.gameObject, var1)

	if var1 then
		if type(var0) == "table" then
			arg0.oldPhoto.color = Color.New(var0[1], var0[2], var0[3], var0[4])
		else
			arg0.oldPhoto.color = Color.New(0.62, 0.58, 0.14, 0.36)
		end
	end
end

function var0.SetBgGlitchArt(arg0, arg1)
	setActive(arg0.bgPanel, false)
	setActive(arg0.bgGlitch, true)
end

function var0.GetBg(arg0, arg1)
	if not arg0.bgs[arg1] then
		arg0.bgs[arg1] = LoadSprite("bg/" .. arg1)
	end

	return arg0.bgs[arg1]
end

function var0.LoadEffects(arg0, arg1, arg2)
	local var0 = arg1:GetEffects()

	if #var0 <= 0 then
		arg2()

		return
	end

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1.name
		local var3 = iter1.active
		local var4 = iter1.interlayer
		local var5 = iter1.center
		local var6 = iter1.adapt
		local var7 = arg0.effectPanel:Find(var2) or arg0.centerPanel:Find(var2)

		if var7 then
			setActive(var7, var3)
			setParent(var7, var5 and arg0.centerPanel or arg0.effectPanel.transform)

			if var4 then
				arg0:UpdateEffectInterLayer(var2, var7)
			end

			if var3 == false then
				arg0:ClearEffectInterlayer(var2)
			end

			if var6 then
				arg0:AdaptEffect(var7)
			end
		else
			local var8 = ""

			if checkABExist("ui/" .. var2) then
				var8 = "ui"
			elseif checkABExist("effect/" .. var2) then
				var8 = "effect"
			end

			if var8 and var8 ~= "" then
				table.insert(var1, function(arg0)
					LoadAndInstantiateAsync(var8, var2, function(arg0)
						setParent(arg0, var5 and arg0.centerPanel or arg0.effectPanel.transform)

						arg0.transform.localScale = Vector3.one

						setActive(arg0, var3)

						arg0.name = var2

						if var4 then
							arg0:UpdateEffectInterLayer(var2, arg0)
						end

						if var3 == false then
							arg0:ClearEffectInterlayer(var2)
						end

						if var6 then
							arg0:AdaptEffect(arg0)
						end

						arg0()
					end)
				end)
			else
				originalPrint("not found effect", var2)
			end
		end
	end

	parallelAsync(var1, arg2)
end

function var0.AdaptEffect(arg0, arg1)
	local var0 = 1.77777777777778
	local var1 = pg.UIMgr.GetInstance().OverlayMain.parent.sizeDelta
	local var2 = var1.x / var1.y
	local var3 = 1

	if var0 < var2 then
		var3 = var2 / var0
	else
		var3 = var0 / var2
	end

	tf(arg1).localScale = Vector3(var3, var3, var3)
end

function var0.UpdateEffectInterLayer(arg0, arg1, arg2)
	local var0 = arg0._go:GetComponent(typeof(Canvas)).sortingOrder
	local var1 = arg2:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

	for iter0 = 1, var1.Length - 1 do
		local var2 = var1[iter0 - 1]
		local var3 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var2)

		if var0 < var3 then
			var0 = var3
		end
	end

	local var4 = var0 + 1
	local var5 = GetOrAddComponent(arg0.actorTr, typeof(Canvas))

	var5.overrideSorting = true
	var5.sortingOrder = var4

	local var6 = GetOrAddComponent(arg0.frontTr, typeof(Canvas))

	var6.overrideSorting = true
	var6.sortingOrder = var4 + 1
	arg0.activeInterLayer = arg1

	GetOrAddComponent(arg0.frontTr, typeof(GraphicRaycaster))
end

function var0.ClearEffectInterlayer(arg0, arg1)
	if arg0.activeInterLayer == arg1 then
		local var0 = arg0.actorTr:GetComponent(typeof(Canvas))
		local var1 = arg0.frontTr:GetComponent(typeof(Canvas))
		local var2 = arg0.frontTr:GetComponent(typeof(GraphicRaycaster))

		if var0 then
			Object.Destroy(var0)
		end

		if var2 then
			Object.Destroy(var2)
		end

		if var1 then
			Object.Destroy(var1)
		end

		arg0.activeInterLayer = nil
	end
end

function var0.ClearEffects(arg0)
	removeAllChildren(arg0.effectPanel)
	removeAllChildren(arg0.centerPanel)

	if arg0.activeInterLayer ~= nil then
		arg0:ClearEffectInterlayer(arg0.activeInterLayer)
	end
end

function var0.PlaySoundEffect(arg0, arg1)
	if arg1:ShouldPlaySoundEffect() then
		local var0, var1 = arg1:GetSoundeffect()

		arg0:DelayCall(var1, function()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0)
		end)
	end

	if arg1:ShouldPlayVoice() then
		arg0:PlayVoice(arg1)
	elseif arg1:ShouldStopVoice() then
		arg0:StopVoice()
	end
end

function var0.StopVoice(arg0)
	if arg0.currentVoice then
		arg0.currentVoice:Stop(true)

		arg0.currentVoice = nil
	end
end

function var0.PlayVoice(arg0, arg1)
	if arg0.voiceDelayTimer then
		arg0.voiceDelayTimer:Stop()

		arg0.voiceDelayTimer = nil
	end

	arg0:StopVoice()

	local var0, var1 = arg1:GetVoice()
	local var2

	var2 = arg0:CreateDelayTimer(var1, function()
		if var2 then
			var2:Stop()
		end

		if arg0.voiceDelayTimer then
			arg0.voiceDelayTimer = nil
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0, function(arg0)
			if arg0 then
				arg0.currentVoice = arg0.playback
			end
		end)
	end)
	arg0.voiceDelayTimer = var2
end

function var0.Reset(arg0, arg1, arg2, arg3)
	setActive(arg0.castPanel, false)
	setActive(arg0.bgPanel, false)
	setActive(arg0.dialoguePanel, false)
	setActive(arg0.asidePanel, false)
	setActive(arg0.curtain, false)
	setActive(arg0.flash, false)
	setActive(arg0.optionsCg.gameObject, false)
	setActive(arg0.bgGlitch, false)
	setActive(arg0.locationTr, false)

	arg0.locationTr.localPosition = arg0.locationTrPos
	arg0.locationStatus = var9
	arg0.flashCg.alpha = 1
	arg0.goCG.alpha = 1

	arg0.animationPlayer:Stop()
	arg0:OnReset(arg1, arg2, arg3)
end

function var0.Clear(arg0, arg1)
	if arg0.step then
		arg0:ClearMoveNodes(arg0.step)
	end

	arg0.bgs = {}
	arg0.skipOption = nil
	arg0.step = nil
	arg0.goCG.alpha = 1
	arg0.callback = nil
	arg0.autoNext = nil
	arg0.script = nil
	arg0.bgImage.sprite = nil

	arg0:OnClear()

	if arg1 then
		arg1()
	end

	pg.DelegateInfo.New(arg0)
end

function var0.StoryEnd(arg0)
	setActive(arg0.iconImage.gameObject, false)

	arg0.iconImage.sprite = nil
	arg0.branchCodeList = {}
	arg0.stop = false
	arg0.pause = false

	if arg0.voiceDelayTimer then
		arg0.voiceDelayTimer:Stop()

		arg0.voiceDelayTimer = nil
	end

	if arg0.currentVoice then
		arg0.currentVoice:Stop(true)

		arg0.currentVoice = nil
	end

	arg0:ClearEffects()
	arg0:Clear()
	arg0:OnEnd()
end

function var0.PlayBgm(arg0, arg1)
	if arg1:ShouldStopBgm() then
		arg0:StopBgm()
	end

	if arg1:ShoulePlayBgm() then
		local var0, var1, var2 = arg1:GetBgmData()

		arg0:DelayCall(var1, function()
			arg0:RevertBgmVolume()
			pg.BgmMgr.GetInstance():TempPlay(var0)
		end)

		if var2 and var2 > 0 then
			arg0.defaultBgmVolume = pg.CriMgr.GetInstance():getBGMVolume()

			pg.CriMgr.GetInstance():setBGMVolume(var2)
		end
	end
end

function var0.StopBgm(arg0, arg1)
	arg0:RevertBgmVolume()
	pg.BgmMgr.GetInstance():StopPlay()
end

function var0.RevertBgmVolume(arg0)
	if arg0.defaultBgmVolume then
		pg.CriMgr.GetInstance():setBGMVolume(arg0.defaultBgmVolume)

		arg0.defaultBgmVolume = nil
	end
end

function var0.StartUIAnimations(arg0, arg1, arg2)
	parallelAsync({
		function(arg0)
			arg0:StartBlinkAnimation(arg1, arg0)
		end,
		function(arg0)
			arg0:StartBlinkWithColorAnimation(arg1, arg0)
		end,
		function(arg0)
			arg0:OnStartUIAnimations(arg1, arg0)
		end
	}, arg2)
end

function var0.StartBlinkAnimation(arg0, arg1, arg2)
	if arg1:ShouldBlink() then
		local var0 = arg1:GetBlinkData()
		local var1 = var0.black
		local var2 = var0.number
		local var3 = var0.dur
		local var4 = var0.delay
		local var5 = var0.alpha[1]
		local var6 = var0.alpha[2]
		local var7 = var0.wait

		arg0.flashImg.color = var1 and Color(0, 0, 0) or Color(1, 1, 1)

		setActive(arg0.flash, true)

		local var8 = {}

		for iter0 = 1, var2 do
			table.insert(var8, function(arg0)
				arg0:TweenAlpha(arg0.flash, var5, var6, var3 / 2, 0, function()
					arg0:TweenAlpha(arg0.flash, var6, var5, var3 / 2, var7, arg0)
				end)
			end)
		end

		seriesAsync(var8, function()
			setActive(arg0.flash, false)
		end)
	end

	arg2()
end

function var0.StartBlinkWithColorAnimation(arg0, arg1, arg2)
	if arg1:ShouldBlinkWithColor() then
		local var0 = arg1:GetBlinkWithColorData()
		local var1 = var0.color
		local var2 = var0.alpha

		arg0.flashImg.color = Color(var1[1], var1[2], var1[3], var1[4])

		setActive(arg0.flash, true)

		local var3 = {}

		for iter0, iter1 in ipairs(var2) do
			local var4 = iter1[1]
			local var5 = iter1[2]
			local var6 = iter1[3]
			local var7 = iter1[4]

			table.insert(var3, function(arg0)
				arg0:TweenValue(arg0.flash, var4, var5, var6, var7, function(arg0)
					arg0.flashCg.alpha = arg0
				end, arg0)
			end)
		end

		parallelAsync(var3, function()
			setActive(arg0.flash, false)
		end)
	end

	arg2()
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

function var0.OnStart(arg0, arg1)
	return
end

function var0.OnReset(arg0, arg1, arg2, arg3)
	arg3()
end

function var0.OnBgUpdate(arg0, arg1)
	return
end

function var0.OnInit(arg0, arg1, arg2, arg3)
	if arg3 then
		arg3()
	end
end

function var0.OnStartUIAnimations(arg0, arg1, arg2)
	if arg2 then
		arg2()
	end
end

function var0.OnEnter(arg0, arg1, arg2, arg3)
	if arg3 then
		arg3()
	end
end

function var0.OnWillExit(arg0, arg1, arg2, arg3)
	arg3()
end

function var0.OnWillClear(arg0, arg1)
	return
end

function var0.OnClear(arg0)
	return
end

function var0.OnEnd(arg0)
	return
end

return var0
