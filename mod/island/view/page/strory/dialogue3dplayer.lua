local var0_0 = class("Dialogue3DPlayer", import("Mgr.Story.model.animation.StoryAnimtion"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.view = arg1_1
	arg0_1._tf = arg1_1._tf
	arg0_1.dialogueContainer = arg0_1._tf:Find("front/dialogue")
	arg0_1.asideContainer = arg0_1._tf:Find("front/aside")
	arg0_1.dialoguePanel = arg0_1._tf:Find("front/dialogue/1")
	arg0_1.nameContainer = arg0_1.dialoguePanel:Find("content/name/tags")
	arg0_1.nameTxt = arg0_1.dialoguePanel:Find("content/name/tags/3/Text"):GetComponent(typeof(Text))
	arg0_1.iconImg = arg0_1.dialoguePanel:Find("content/name/tags/3/icon")
	arg0_1.contentTxt = arg0_1.dialoguePanel:Find("content"):GetComponent(typeof(Text))
	arg0_1.typewriter = arg0_1.contentTxt:GetComponent(typeof(Typewriter))
	arg0_1.blackBg = arg0_1._tf:Find("black"):GetComponent(typeof(CanvasGroup))
	arg0_1.optionPanel = arg0_1.dialoguePanel:Find("options_panel")
	arg0_1.uiOptionList = UIItemList.New(arg0_1.dialoguePanel:Find("options_panel/options_l"), arg0_1.dialoguePanel:Find("options_panel/options_l/option_tpl"))
	arg0_1.asidePlayer = IslandAsidePlayer.New(arg0_1.asideContainer)
	arg0_1.canvasGroup = arg1_1.canvasGroup
end

function var0_0.NextOne(arg0_2)
	if arg0_2.script and arg0_2.script:IsSkipAll() then
		-- block empty
	end

	if arg0_2.nextOneFlag then
		return
	end

	if arg0_2.step and not arg0_2.step:CanSkip() then
		return
	end

	arg0_2.autoNext = true

	if arg0_2.isRegisterEvent then
		triggerButton(arg0_2._tf)
	else
		arg0_2.nextOneFlag = true

		arg0_2:Clear()

		local var0_2 = arg0_2.callback

		arg0_2.callback = nil

		var0_2()
	end
end

function var0_0.CancelAuto(arg0_3)
	arg0_3.autoNext = false

	arg0_3:ClearTimer(arg0_3.callback)
end

function var0_0.OnStart(arg0_4, arg1_4)
	return
end

function var0_0.OnStartAction(arg0_5, arg1_5, arg2_5)
	arg0_5:ActiveDefaultCamera(arg1_5)
	arg0_5:StartFadeIn(arg1_5)
	arg2_5()
end

function var0_0.OnEndAction(arg0_6, arg1_6, arg2_6)
	arg0_6:StartFadeOut(arg1_6, arg2_6)
end

function var0_0.Reset(arg0_7, arg1_7)
	setActive(arg0_7.dialogueContainer, arg1_7 == Dialogue3DStep.STYLE_DIALOGUE)
	setActive(arg0_7.asideContainer, arg1_7 == Dialogue3DStep.STYLE_ASIDE)
	removeOnButton(arg0_7._tf)
	arg0_7.uiOptionList:align(0)

	arg0_7.isRegisterEvent = false
	arg0_7.nextOneFlag = false
	arg0_7.blackBg.alpha = 0
end

function var0_0.Play(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local var0_8 = arg3_8:GetStepByIndex(arg2_8)

	if not var0_8 then
		arg4_8()

		return
	end

	arg0_8.isUnmarkedSkipAll = false

	if var0_8:ExistOption() and arg3_8:IsSkipAll() then
		arg3_8:UnMarkSkipAll()

		arg0_8.isUnmarkedSkipAll = true
	end

	if arg3_8:IsSkipAll() then
		arg4_8()

		return
	end

	arg0_8.canvasGroup.blocksRaycasts = true
	arg0_8.playerUnit = arg3_8:GetPlayerRole()

	if not var0_8 then
		arg4_8()

		return
	end

	arg1_8:Add(var0_8)

	arg0_8.script = arg3_8
	arg0_8.callback = arg4_8
	arg0_8.autoNext = arg3_8:GetAutoPlayFlag()
	arg0_8.step = var0_8

	arg0_8:SetTimeScale(1 - arg3_8:GetPlaySpeed() * 0.1)

	arg0_8.isRegisterEvent = false

	local var1_8 = var0_8:GetStyle()

	arg0_8:Reset(var1_8)

	if var1_8 == Dialogue3DStep.STYLE_DIALOGUE then
		arg0_8:PlayDialogue(var0_8, arg4_8)
	elseif var1_8 == Dialogue3DStep.STYLE_ASIDE then
		arg0_8.asidePlayer:Play(var0_8:GetAsideSequences(), arg4_8)
	elseif var1_8 == Dialogue3DStep.STYLE_EXIT_GROUP then
		arg0_8:PlayNavObject(var0_8, function()
			local var0_9 = var0_8:GetNavObject()

			if var0_9 then
				IslandCameraMgr.instance:RemoveFromGroup(var0_9.transform)
			end
		end, arg4_8)
	elseif var1_8 == Dialogue3DStep.STYLE_JOIN_GROUP then
		arg0_8:PlayNavObject(var0_8, nil, function()
			local var0_10 = var0_8:GetNavObject()

			if var0_10 then
				IslandCameraMgr.instance:AddIntoGroup(var0_10.transform, 1, 0)
			end

			arg4_8()
		end)
	end
end

function var0_0.PlayNavObject(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg1_11:GetNavData()

	arg0_11:DelayCall(var0_11.delay, function()
		if arg2_11 then
			arg2_11()
		end

		local var0_12 = {
			unitId = var0_11.object,
			position = var0_11.position,
			speed = var0_11.speed,
			hide = var0_11.hide,
			waitUntilDone = var0_11.waitUntilDone,
			index = var0_11.navData
		}

		arg0_11.view:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.START_PATHFINDER, {
			navData = var0_12,
			callback = arg3_11
		})
	end)
end

function var0_0.PlayDialogue(arg0_13, arg1_13, arg2_13)
	seriesAsync({
		function(arg0_14)
			arg0_13:SetCustomCameraBlend(arg1_13, arg0_14)
		end,
		function(arg0_15)
			parallelAsync({
				function(arg0_16)
					arg0_13:ActiveCamera(arg1_13, arg0_16)
				end,
				function(arg0_17)
					arg0_13:ShakeCamera(arg1_13, arg0_17)
				end,
				function(arg0_18)
					arg0_13:StartAction(arg1_13, arg0_18)
				end
			}, arg0_15)
		end,
		function(arg0_19)
			arg0_13:Clear()
			arg0_19()
		end
	}, arg2_13)
end

function var0_0.StartFadeIn(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20:GetFadeInTime()

	if var0_20 <= 0 then
		if arg2_20 then
			arg2_20()
		end

		return
	end

	local var1_20 = {}

	arg0_20:CollectFadeInFunc(var1_20, var0_20)
	seriesAsync(var1_20, arg2_20)
end

function var0_0.StartFadeOut(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg1_21:GetFadeOutTime()

	if var0_21 <= 0 then
		if arg2_21 then
			arg2_21()
		end

		return
	end

	local var1_21 = {}

	arg0_21:CollectFadeOutFunc(var1_21, var0_21)
	seriesAsync(var1_21, arg2_21)
end

function var0_0.ActiveDefaultCamera(arg0_22, arg1_22)
	local var0_22, var1_22, var2_22 = arg1_22:GetLookGroup()
	local var3_22 = System.Array.CreateInstance(typeof(Transform), #var0_22)
	local var4_22 = System.Array.CreateInstance(typeof(UnityEngine.Vector2), #var0_22)

	for iter0_22 = 0, #var0_22 - 1 do
		var3_22[iter0_22] = var0_22[iter0_22 + 1].transform
		var4_22[iter0_22] = UnityEngine.Vector2.New(var1_22[iter0_22 + 1] or 1, var2_22[iter0_22 + 1] or 0)
	end

	if var3_22.Length > 1 then
		if arg1_22:ShouldSetCamOffset() then
			local var5_22 = arg1_22:GetFollowOffset()

			IslandCameraMgr.instance:SetVirtualCameraBodyOffset(IslandConst.INTERACTION_CAMERA_NAME, var5_22)
		end

		IslandCameraMgr.instance:LookAtGroup(var3_22, var4_22)
	elseif var3_22.Length == 1 then
		IslandCameraMgr.instance:SetVirtualCameraBodyOffset(IslandConst.SOLO_INTERACTION_CAMERA_NAME, arg1_22:IsFacingWhenSolo())
		IslandCameraMgr.instance:LookAt(IslandConst.SOLO_INTERACTION_CAMERA_NAME, var3_22[0])
	else
		assert(false, "should have at least one target")
	end
end

function var0_0.DisactiveDefaultCamera(arg0_23)
	IslandCameraMgr.instance:LookAt(arg0_23.playerUnit.transform)
end

function var0_0.ShowOptions(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24:GetOptionList()

	arg0_24.uiOptionList:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = var0_24[arg1_25 + 1]

			setText(arg2_25.transform:Find("main/content/Text"), HXSet.hxLan(var0_25.content))

			local var1_25

			var1_25.sprite, var1_25 = GetSpriteFromAtlas("ui/story_atlas", var0_25.icon), arg2_25.transform:Find("main/icon"):GetComponent(typeof(Image))

			var1_25:SetNativeSize()
			onButton(arg0_24, arg2_25, function()
				arg0_24:ResponseOption(var0_25, arg2_24)
			end, SFX_PANEL)
		end
	end)
	arg0_24.uiOptionList:align(#var0_24)
end

function var0_0.ResponseOption(arg0_27, arg1_27, arg2_27)
	if arg1_27.type == Dialogue3DStep.OPTION_TYPE_TEXT then
		arg0_27.script:SetBranchCode(arg1_27.param)
	elseif arg1_27.type == Dialogue3DStep.OPTION_TYPE_PAGE then
		arg0_27.script:MarkSkipAll()
		arg0_27.view:emit(ISLAND_EX_EVT.OPEN_PAGE, _G[arg1_27.param])
	elseif arg1_27.type == Dialogue3DStep.OPTION_TYPE_TASK then
		arg0_27.script:MarkSkipAll()
		arg0_27.view:emit(ISLAND_EX_EVT.TRIGGER_TASK, arg1_27.param)
	elseif arg1_27.type == Dialogue3DStep.OPTION_TYPE_EXIT then
		arg0_27.script:MarkSkipAll()
	end

	arg0_27:PlayOptionExitAnimation(arg2_27)
end

function var0_0.PlayOptionExitAnimation(arg0_28, arg1_28)
	local var0_28 = {}

	arg0_28.uiOptionList:eachActive(function(arg0_29, arg1_29)
		table.insert(var0_28, function(arg0_30)
			arg1_29:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				arg0_30()
			end)
			arg1_29:GetComponent(typeof(Animation)):Play("anim_IslandStoryUI_Tpl_Out")
		end)
	end)
	parallelAsync(var0_28, function()
		arg0_28.uiOptionList:each(function(arg0_33, arg1_33)
			arg1_33:GetComponent(typeof(DftAniEvent)):SetEndEvent(nil)
		end)
		arg1_28()
	end)
end

function var0_0.SetCustomCameraBlend(arg0_34, arg1_34, arg2_34)
	arg2_34()
end

function var0_0.ClearCustomCameraBlend(arg0_35)
	return
end

function var0_0.StartAction(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg1_36:GetPlayMode()

	if var0_36 == Dialogue3DStep.PLAY_MODE_SCENE_TIMELINE then
		setActive(arg0_36._tf, false)
		arg0_36.view:emit(ISLAND_EX_EVT.PLAY_TIMELINE, arg1_36:GetSceneTimelinePath(), {}, function()
			setActive(arg0_36._tf, true)
			arg2_36()
		end)
	elseif var0_36 == Dialogue3DStep.PLAY_MODE_TIMELINE then
		arg2_36()
	elseif var0_36 == Dialogue3DStep.PLAY_MODE_DIALOGUE then
		arg0_36:UpdateDialogue(arg1_36, arg2_36)
	else
		assert(false, "not support play mode")
		arg2_36()
	end
end

function var0_0.CollectFadeInFunc(arg0_38, arg1_38, arg2_38)
	arg0_38.blackBg.alpha = 1

	table.insert(arg1_38, function(arg0_39)
		arg0_38:TweenValueForcanvasGroup(arg0_38.blackBg, 1, 0, arg2_38 or 0.5, 0, arg0_39)
	end)
	table.insert(arg1_38, function(arg0_40)
		arg0_38:UnscaleDelayCall(1, arg0_40)
	end)
end

function var0_0.CollectFadeOutFunc(arg0_41, arg1_41, arg2_41)
	arg0_41.blackBg.alpha = 0

	table.insert(arg1_41, function(arg0_42)
		arg0_41:TweenValueForcanvasGroup(arg0_41.blackBg, 0, 1, arg2_41 or 0.5, 0, arg0_42)
	end)
end

function var0_0.ActiveCamera(arg0_43, arg1_43, arg2_43)
	if not arg1_43:ShouldActiveCamera() then
		arg2_43()

		return
	end

	local var0_43 = arg1_43:ShouldFadeCamera()
	local var1_43 = {}

	if var0_43 then
		arg0_43:CollectFadeOutFunc(var1_43)
	end

	table.insert(var1_43, function(arg0_44)
		local var0_44 = arg1_43:GetActiveCamera()

		IslandCameraMgr.instance:ActiveVirtualCamera(var0_44)
		arg0_44()
	end)

	if var0_43 then
		arg0_43:CollectFadeInFunc(var1_43)
	end

	seriesAsync(var1_43, arg2_43)
end

function var0_0.ShakeCamera(arg0_45, arg1_45, arg2_45)
	if not arg1_45:ShouldCameraShake() then
		arg2_45()

		return
	end

	seriesAsync({
		function(arg0_46)
			arg0_45:LoadShakeSrc(arg1_45, arg0_46)
		end,
		function(arg0_47)
			if arg0_45.shakeCameraSrc then
				arg0_45.shakeCameraSrc:GetComponent("Cinemachine.CinemachineImpulseSource"):GenerateImpulse()
			end

			arg0_47()
		end
	}, arg2_45)
end

function var0_0.LoadShakeSrc(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg1_48:GetCameraShakeSrc()

	PoolMgr.GetInstance():GetUI(var0_48, true, function(arg0_49)
		arg0_48.shakeCameraSrc = arg0_49

		arg2_48()
	end)
end

function var0_0.UpdateDialogue(arg0_50, arg1_50, arg2_50)
	parallelAsync({
		function(arg0_51)
			arg0_50:LoadContentAndIcon(arg1_50, arg0_51)
		end,
		function(arg0_52)
			arg0_50:PlayCharatorAnimation(arg1_50, arg0_52)
		end,
		function(arg0_53)
			arg0_50:UpdateTypeWriter(arg1_50, arg0_53)
		end,
		function(arg0_54)
			arg0_50:StartUIAnimations(arg1_50, arg0_54)
		end,
		function(arg0_55)
			arg0_50:TryFace2Face(arg1_50, arg0_55)
		end,
		function(arg0_56)
			arg0_50:TryTurn2Unit(arg1_50, arg0_56)
		end
	}, function()
		arg0_50:RegisterEvent(arg1_50, arg2_50)
	end)
end

function var0_0.TryTurn2Unit(arg0_58, arg1_58, arg2_58)
	local var0_58 = {}

	for iter0_58, iter1_58 in ipairs(arg1_58:GetTurntoList()) do
		table.insert(var0_58, function(arg0_59)
			local var0_59 = arg0_58.script:GetRole(iter1_58[1])
			local var1_59 = arg0_58.script:GetRole(iter1_58[2])

			if var1_59 == nil or var0_59 == nil then
				arg0_59()

				return
			end

			local var2_59 = var0_59.transform
			local var3_59 = var1_59.transform

			arg0_58:Turn2Unit(var2_59, var3_59, arg0_59)
		end)
	end

	seriesAsync(var0_58, arg2_58)
end

function var0_0.Turn2Unit(arg0_60, arg1_60, arg2_60, arg3_60)
	local var0_60 = arg2_60.position - arg1_60.position
	local var1_60 = Quaternion.LookRotation(var0_60)

	arg1_60.rotation = Quaternion.Euler(0, var1_60.eulerAngles.y, 0)

	arg3_60()
end

function var0_0.TryFace2Face(arg0_61, arg1_61, arg2_61)
	local var0_61 = {}

	for iter0_61, iter1_61 in ipairs(arg1_61:GetFace2FaceList()) do
		table.insert(var0_61, function(arg0_62)
			local var0_62 = arg0_61.script:GetRole(iter1_61[1])
			local var1_62 = arg0_61.script:GetRole(iter1_61[2])

			if var1_62 == nil or var0_62 == nil then
				arg0_62()

				return
			end

			local var2_62 = var0_62.transform
			local var3_62 = var1_62.transform

			arg0_61:Face2Face(var2_62, var3_62, arg0_62)
		end)
	end

	seriesAsync(var0_61, arg2_61)
end

function var0_0.Face2Face(arg0_63, arg1_63, arg2_63, arg3_63)
	local var0_63 = arg2_63.position - arg1_63.position
	local var1_63 = arg1_63.position - arg2_63.position

	if var0_63.sqrMagnitude > 0.0001 then
		local var2_63 = Quaternion.LookRotation(var0_63)

		arg1_63.rotation = Quaternion.Euler(0, var2_63.eulerAngles.y, 0)
	end

	if var1_63.sqrMagnitude > 0.0001 then
		local var3_63 = Quaternion.LookRotation(var1_63)

		arg2_63.rotation = Quaternion.Euler(0, var3_63.eulerAngles.y, 0)
	end

	if arg3_63 then
		arg3_63()
	end
end

function var0_0.StartUIAnimations(arg0_64, arg1_64, arg2_64)
	if not arg1_64:ShouldShakeDailogue() then
		arg2_64()

		return
	end

	local var0_64 = arg1_64:GetShakeDailogueData()
	local var1_64 = var0_64.x
	local var2_64 = var0_64.number
	local var3_64 = var0_64.delay
	local var4_64 = var0_64.speed
	local var5_64 = arg0_64.dialoguePanel.localPosition.x

	arg0_64:TweenMovex(arg0_64.dialoguePanel, var1_64, var5_64, var4_64, var3_64, var2_64, arg2_64)
end

function var0_0.RegisterEvent(arg0_65, arg1_65, arg2_65)
	if not arg0_65.callback then
		return
	end

	setActive(arg0_65.optionPanel, arg1_65:ExistOption())

	if arg1_65:ExistOption() then
		arg0_65:ShowOptions(arg1_65, arg2_65)
	elseif arg0_65.autoNext then
		local var0_65 = arg0_65.script:GetTriggerDelayTime()

		arg0_65:UnscaleDelayCall(var0_65, arg2_65)
	else
		onButton(arg0_65, arg0_65._tf, arg2_65, SFX_PANEL)
	end

	arg0_65.isRegisterEvent = true
end

function var0_0.UpdateTypeWriter(arg0_66, arg1_66, arg2_66)
	local var0_66 = arg1_66:GetSay()
	local var1_66 = 999

	if var0_66 and var0_66 ~= "" then
		var1_66 = System.String.New(var0_66).Length
	end

	if not var0_66 or var0_66 == "" or var0_66 == "…" or not (#var0_66 > 1) or not (var1_66 > 1) then
		arg2_66()

		return
	end

	local var2_66 = arg1_66:GetTypewriter()

	if not var2_66 or arg0_66.isUnmarkedSkipAll then
		arg2_66()

		return
	end

	function arg0_66.typewriter.endFunc()
		arg0_66.typewriterSpeed = 0
		arg0_66.typewriter.endFunc = nil

		removeOnButton(arg0_66._tf)
		arg2_66()
	end

	arg0_66.typewriterSpeed = math.max((var2_66.speed or 0.1) * arg0_66.timeScale, 0.001)

	local var3_66 = var2_66.speedUp or arg0_66.typewriterSpeed

	arg0_66.typewriter:setSpeed(arg0_66.typewriterSpeed)
	arg0_66.typewriter:Play()
	onButton(arg0_66, arg0_66._tf, function()
		if arg0_66.puase or arg0_66.stop then
			return
		end

		arg0_66.typewriterSpeed = math.min(arg0_66.typewriterSpeed, var3_66)

		arg0_66.typewriter:setSpeed(arg0_66.typewriterSpeed)
	end, SFX_PANEL)
end

function var0_0.LoadContentAndIcon(arg0_69, arg1_69, arg2_69)
	setActive(arg0_69.nameContainer, not arg1_69:IsHideName())

	local var0_69 = "<size=24>" .. arg1_69:GetSubName() .. "</size>"

	arg0_69.nameTxt.text = arg1_69:GetName() .. var0_69
	arg0_69.contentTxt.text = arg1_69:GetSay()

	local var1_69 = arg1_69:GetActorIcon()

	if var1_69 then
		GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var1_69, "", arg0_69.iconImg)
	end

	setActive(arg0_69.iconImg, not arg1_69:IsHideIcon())
	arg2_69()
end

function var0_0.PlayCharatorAnimation(arg0_70, arg1_70, arg2_70)
	if not arg1_70:ExistAnimation() then
		arg2_70()

		return
	end

	local var0_70 = arg0_70.script:GetRole(arg1_70:GetUnitData())

	if not var0_70 then
		arg2_70()

		return
	end

	local var1_70 = arg1_70:GetAnimation()
	local var2_70 = var0_70:GetComponent(typeof(Animator)) or var0_70.transform:GetChild(0):GetComponent(typeof(Animator))

	if not var2_70:GetCurrentAnimatorStateInfo(0):IsName(var1_70) then
		local var3_70 = Animator.StringToHash(var1_70)

		for iter0_70 = 1, var2_70.layerCount do
			var2_70:CrossFadeInFixedTime(var3_70, 0.2, iter0_70 - 1)
		end
	end

	arg2_70()
end

function var0_0.Clear(arg0_71)
	arg0_71.asidePlayer:Clear()

	arg0_71.canvasGroup.blocksRaycasts = true

	arg0_71.uiOptionList:align(0)
	removeOnButton(arg0_71._tf)
	arg0_71:ClearAnimation()

	arg0_71.blackBg.alpha = 0

	if arg0_71.shakeCameraSrc then
		Object.Destroy(arg0_71.shakeCameraSrc)

		arg0_71.shakeCameraSrc = nil
	end
end

function var0_0.OnEnd(arg0_72)
	arg0_72:DisactiveDefaultCamera()
	arg0_72:ClearCustomCameraBlend()
end

function var0_0.Dispose(arg0_73)
	arg0_73.asidePlayer:Dispose()

	arg0_73.asidePlayer = nil

	pg.DelegateInfo.Dispose(arg0_73)
end

return var0_0
