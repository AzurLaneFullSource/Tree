local var0_0 = class("Dialogue3DPlayer", import("Mgr.Story.model.animation.StoryAnimtion"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.view = arg1_1
	arg0_1._tf = arg1_1._tf
	arg0_1.dialoguePanel = arg0_1._tf:Find("front/dialogue/1")
	arg0_1.nameTxt = arg0_1.dialoguePanel:Find("content/name/Text"):GetComponent(typeof(Text))
	arg0_1.subNameTxt = arg0_1.dialoguePanel:Find("content/name/Text/subText"):GetComponent(typeof(Text))
	arg0_1.iconImg = arg0_1.dialoguePanel:Find("content/name/tags/3/icon")
	arg0_1.contentTxt = arg0_1.dialoguePanel:Find("content"):GetComponent(typeof(Text))
	arg0_1.typewriter = arg0_1.contentTxt:GetComponent(typeof(Typewriter))
	arg0_1.blackBg = arg0_1._tf:Find("black"):GetComponent(typeof(CanvasGroup))
	arg0_1.optionPanel = arg0_1.dialoguePanel:Find("options_panel")
	arg0_1.uiOptionList = UIItemList.New(arg0_1.dialoguePanel:Find("options_panel/options_l"), arg0_1.dialoguePanel:Find("options_panel/options_l/option_tpl"))
end

function var0_0.NextOne(arg0_2)
	arg0_2.autoNext = true

	if arg0_2.isRegisterEvent then
		triggerButton(arg0_2._tf)
	end
end

function var0_0.CancelAuto(arg0_3)
	arg0_3.autoNext = false

	arg0_3:ClearTimer(arg0_3.callback)
end

function var0_0.OnStart(arg0_4, arg1_4)
	arg0_4:ActiveDefaultCamera(arg1_4)
	pg.DelegateInfo.New(arg0_4)
end

function var0_0.ActiveDefaultCamera(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetLookGroup()
	local var1_5 = System.Array.CreateInstance(typeof(Transform), #var0_5)

	for iter0_5 = 0, #var0_5 - 1 do
		var1_5[iter0_5] = var0_5[iter0_5 + 1].transform
	end

	IslandCameraMgr.instance:LookAtGroup(var1_5)
end

function var0_0.Play(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	if arg3_6:IsSkipAll() then
		arg4_6()

		return
	end

	arg0_6.playerUnit = arg3_6:GetPlayerRole()

	local var0_6 = arg3_6:GetStepByIndex(arg2_6)

	if not var0_6 then
		arg4_6()

		return
	end

	arg1_6:Add(var0_6)

	arg0_6.script = arg3_6
	arg0_6.callback = arg4_6
	arg0_6.autoNext = arg3_6:GetAutoPlayFlag()

	arg0_6:SetTimeScale(1 - arg3_6:GetPlaySpeed() * 0.1)

	arg0_6.isRegisterEvent = false

	arg0_6:Reset()
	seriesAsync({
		function(arg0_7)
			arg0_6:SetCustomCameraBlend(var0_6, arg0_7)
		end,
		function(arg0_8)
			parallelAsync({
				function(arg0_9)
					arg0_6:ActiveCamera(var0_6, arg0_9)
				end,
				function(arg0_10)
					arg0_6:ShakeCamera(var0_6, arg0_10)
				end,
				function(arg0_11)
					arg0_6:StartAction(var0_6, arg0_11)
				end
			}, arg0_8)
		end,
		function(arg0_12)
			arg0_6:Clear()
			arg0_12()
		end
	}, arg4_6)
end

function var0_0.Reset(arg0_13)
	removeOnButton(arg0_13._tf)
	arg0_13.uiOptionList:align(0)

	arg0_13.isRegisterEvent = false
	arg0_13.blackBg.alpha = 0
end

function var0_0.ShowOptions(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg1_14:GetOptionList()

	arg0_14.uiOptionList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = var0_14[arg1_15 + 1]

			setText(arg2_15.transform:Find("content/Text"), var0_15.content)

			local var1_15

			var1_15.sprite, var1_15 = GetSpriteFromAtlas("ui/story_atlas", var0_15.icon), arg2_15.transform:Find("icon"):GetComponent(typeof(Image))

			var1_15:SetNativeSize()
			onButton(arg0_14, arg2_15, function()
				arg0_14:ResponseOption(var0_15, arg2_14)
			end, SFX_PANEL)
		end
	end)
	arg0_14.uiOptionList:align(#var0_14)
end

function var0_0.ResponseOption(arg0_17, arg1_17, arg2_17)
	if arg1_17.type == Dialogue3DStep.OPTION_TYPE_TEXT then
		arg0_17.script:SetBranchCode(arg1_17.param)
	elseif arg1_17.type == Dialogue3DStep.OPTION_TYPE_PAGE then
		arg0_17.script:MarkSkipAll()
		arg0_17.view:Op("NotifiyIsland", ISLAND_EX_EVT.OPEN_PAGE, _G[arg1_17.param])
	elseif arg1_17.type == Dialogue3DStep.OPTION_TYPE_TASK then
		arg0_17.script:MarkSkipAll()
		arg0_17.view:Op("NotifiyIsland", ISLAND_EX_EVT.TRIGGER_TASK, arg1_17.param)
	elseif arg1_17.type == Dialogue3DStep.OPTION_TYPE_EXIT then
		arg0_17.script:MarkSkipAll()
	end

	arg2_17()
end

function var0_0.DisactiveDefaultCamera(arg0_18)
	IslandCameraMgr.instance:LookAt(arg0_18.playerUnit.transform)
end

function var0_0.SetCustomCameraBlend(arg0_19, arg1_19, arg2_19)
	if not arg1_19:SholdBlendCamera() then
		arg2_19()

		return
	end

	local var0_19 = arg1_19:GetCameraBlendName()

	IslandCameraMgr.instance:SetCustomCameraBlend(var0_19, arg2_19)
end

function var0_0.ClearCustomCameraBlend(arg0_20)
	IslandCameraMgr.instance:ClearCustomCameraBlend()
end

function var0_0.StartAction(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg1_21:GetPlayMode()

	if var0_21 == Dialogue3DStep.PLAY_MODE_SCENE_TIMELINE then
		arg0_21:PlaySceneTimeline(arg1_21, arg2_21)
	elseif var0_21 == Dialogue3DStep.PLAY_MODE_TIMELINE then
		arg0_21:PlayTimeline(arg1_21:GetTimelinePath(), arg2_21)
	elseif var0_21 == Dialogue3DStep.PLAY_MODE_DIALOGUE then
		arg0_21:UpdateDialogue(arg1_21, arg2_21)
	else
		assert(false, "not support play mode")
		arg2_21()
	end
end

function var0_0.PlaySceneTimeline(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg1_22:GetSceneTimelineSceneName()
	local var1_22 = IslandSceneSwitcher.New()

	seriesAsync({
		function(arg0_23)
			arg0_22:Mask()
			var1_22:Load(var0_22, function(arg0_24)
				arg0_24()
				arg0_23()
			end, 2)
		end,
		function(arg0_25)
			onNextTick(arg0_25)
		end,
		function(arg0_26)
			arg0_22:UnMask()
			arg0_22:PlayTimeline(arg1_22:GetSceneTimelinePath(), arg0_26)
		end,
		function(arg0_27)
			var1_22:UnLoad()
			SceneOpMgr.Inst:SetActiveSceneByIndex(1)
			arg0_27()
		end
	}, arg2_22)
end

function var0_0.Mask(arg0_28)
	arg0_28.blackBg.alpha = 1
end

function var0_0.UnMask(arg0_29)
	arg0_29.blackBg.alpha = 0
end

function var0_0.ActiveCamera(arg0_30, arg1_30, arg2_30)
	if not arg1_30:ShouldActiveCamera() then
		return
	end

	local var0_30 = arg1_30:ShouldFadeCamera()
	local var1_30 = {}

	if var0_30 then
		table.insert(var1_30, function(arg0_31)
			arg0_30:TweenValueForcanvasGroup(arg0_30.blackBg, 0, 1, 0.5, 0, arg0_31)
		end)
		table.insert(var1_30, function(arg0_32)
			arg0_30:UnscaleDelayCall(1, arg0_32)
		end)
	end

	table.insert(var1_30, function(arg0_33)
		local var0_33 = arg1_30:GetActiveCamera()

		IslandCameraMgr.instance:ActiveVirtualCamera(var0_33)
		arg0_33()
	end)

	if var0_30 then
		table.insert(var1_30, function(arg0_34)
			arg0_30:TweenValueForcanvasGroup(arg0_30.blackBg, 1, 0, 0.5, 0, arg0_34)
		end)
	end

	seriesAsync(var1_30, arg2_30)
end

function var0_0.ShakeCamera(arg0_35, arg1_35, arg2_35)
	if not arg1_35:ShouldCameraShake() then
		arg2_35()

		return
	end

	seriesAsync({
		function(arg0_36)
			arg0_35:LoadShakeSrc(arg1_35, arg0_36)
		end,
		function(arg0_37)
			if arg0_35.shakeCameraSrc then
				arg0_35.shakeCameraSrc:GetComponent("Cinemachine.CinemachineImpulseSource"):GenerateImpulse()
			end

			arg0_37()
		end
	}, arg2_35)
end

function var0_0.LoadShakeSrc(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg1_38:GetCameraShakeSrc()

	PoolMgr.GetInstance():GetUI(var0_38, true, function(arg0_39)
		arg0_38.shakeCameraSrc = arg0_39

		arg2_38()
	end)
end

function var0_0.PlayTimeline(arg0_40, arg1_40, arg2_40)
	setActive(arg0_40._tf, false)

	local var0_40 = GameObject.Find(arg1_40)

	assert(var0_40, arg1_40)

	if not var0_40 then
		return
	end

	local var1_40 = var0_40:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))
	local var2_40 = GetOrAddComponent(var0_40, "DftCommonSignalReceiver")

	var2_40:SetCommonEvent(function(arg0_41)
		if arg0_41.stringParameter == "TimelineEnd" then
			var1_40:Stop()
			var2_40:SetCommonEvent(nil)
			setActive(arg0_40._tf, true)
			arg2_40()
		end
	end)
	var1_40:Play()
end

function var0_0.UpdateDialogue(arg0_42, arg1_42, arg2_42)
	parallelAsync({
		function(arg0_43)
			arg0_42:LoadContentAndIcon(arg1_42, arg0_43)
		end,
		function(arg0_44)
			arg0_42:PlayCharatorAnimation(arg1_42, arg0_44)
		end,
		function(arg0_45)
			arg0_42:UpdateTypeWriter(arg1_42, arg0_45)
		end,
		function(arg0_46)
			arg0_42:StartUIAnimations(arg1_42, arg0_46)
		end
	}, function()
		arg0_42:RegisterEvent(arg1_42, arg2_42)
	end)
end

function var0_0.StartUIAnimations(arg0_48, arg1_48, arg2_48)
	if not arg1_48:ShouldShakeDailogue() then
		arg2_48()

		return
	end

	local var0_48 = arg1_48:GetShakeDailogueData()
	local var1_48 = var0_48.x
	local var2_48 = var0_48.number
	local var3_48 = var0_48.delay
	local var4_48 = var0_48.speed
	local var5_48 = arg0_48.dialoguePanel.localPosition.x

	arg0_48:TweenMovex(arg0_48.dialoguePanel, var1_48, var5_48, var4_48, var3_48, var2_48, arg2_48)
end

function var0_0.RegisterEvent(arg0_49, arg1_49, arg2_49)
	if not arg0_49.callback then
		return
	end

	setActive(arg0_49.optionPanel, arg1_49:ExistOption())

	if arg1_49:ExistOption() then
		arg0_49:ShowOptions(arg1_49, arg2_49)
	elseif arg0_49.autoNext then
		local var0_49 = arg0_49.script:GetTriggerDelayTime()

		arg0_49:UnscaleDelayCall(var0_49, arg2_49)
	else
		onButton(arg0_49, arg0_49._tf, arg2_49, SFX_PANEL)
	end

	arg0_49.isRegisterEvent = true
end

function var0_0.UpdateTypeWriter(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg1_50:GetSay()
	local var1_50 = 999

	if var0_50 and var0_50 ~= "" then
		var1_50 = System.String.New(var0_50).Length
	end

	if not var0_50 or var0_50 == "" or var0_50 == "…" or not (#var0_50 > 1) or not (var1_50 > 1) then
		arg2_50()

		return
	end

	local var2_50 = arg1_50:GetTypewriter()

	if not var2_50 then
		arg2_50()

		return
	end

	function arg0_50.typewriter.endFunc()
		arg0_50.typewriterSpeed = 0
		arg0_50.typewriter.endFunc = nil

		removeOnButton(arg0_50._tf)
		arg2_50()
	end

	arg0_50.typewriterSpeed = math.max((var2_50.speed or 0.1) * arg0_50.timeScale, 0.001)

	local var3_50 = var2_50.speedUp or arg0_50.typewriterSpeed

	arg0_50.typewriter:setSpeed(arg0_50.typewriterSpeed)
	arg0_50.typewriter:Play()
	onButton(arg0_50, arg0_50._tf, function()
		if arg0_50.puase or arg0_50.stop then
			return
		end

		arg0_50.typewriterSpeed = math.min(arg0_50.typewriterSpeed, var3_50)

		arg0_50.typewriter:setSpeed(arg0_50.typewriterSpeed)
	end, SFX_PANEL)
end

function var0_0.LoadContentAndIcon(arg0_53, arg1_53, arg2_53)
	arg0_53.nameTxt.text = arg1_53:GetName()
	arg0_53.subNameTxt.text = arg1_53:GetSubName()
	arg0_53.contentTxt.text = arg1_53:GetSay()

	local var0_53 = arg1_53:GetActorIcon()

	LoadSpriteAsync("QIcon/" .. var0_53, function(arg0_54)
		setImageSprite(arg0_53.iconImg, arg0_54, false)
		arg2_53()
	end)
end

function var0_0.PlayCharatorAnimation(arg0_55, arg1_55, arg2_55)
	if not arg1_55:ExistAnimation() then
		arg2_55()

		return
	end

	local var0_55 = arg0_55.script:GetRole(arg1_55:GetUnitId())

	if not var0_55 then
		arg2_55()
		arg2_55()

		return
	end

	local var1_55 = arg1_55:GetAnimation()
	local var2_55 = var0_55:GetComponent(typeof(Animator))

	if not var2_55:GetCurrentAnimatorStateInfo(0):IsName(var1_55) then
		local var3_55 = Animator.StringToHash(var1_55)

		var2_55:CrossFadeInFixedTime(var3_55, 0.2)
	end

	arg2_55()
end

function var0_0.Clear(arg0_56)
	arg0_56.uiOptionList:align(0)
	removeOnButton(arg0_56._tf)
	arg0_56:ClearAnimation()

	arg0_56.blackBg.alpha = 0

	if arg0_56.shakeCameraSrc then
		Object.Destroy(arg0_56.shakeCameraSrc)

		arg0_56.shakeCameraSrc = nil
	end
end

function var0_0.OnEnd(arg0_57)
	arg0_57:DisactiveDefaultCamera()
	arg0_57:ClearCustomCameraBlend()
	pg.DelegateInfo.Dispose(arg0_57)
end

return var0_0
