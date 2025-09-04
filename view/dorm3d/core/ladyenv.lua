local var0_0 = class("LadyEnv", import("view.dorm3d.Extra.BaseExtraSystem"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.super.Ctor(arg0_1, arg1_1.event, arg1_1)
end

function var0_0.InitCharacter(arg0_2, arg1_2)
	arg0_2.lady = arg0_2.ladyGameObject.transform

	arg0_2.lady:SetParent(arg0_2:Get("mainCameraTF"))
	arg0_2.lady:SetParent(nil)

	arg0_2.ladyHeadIKComp = arg0_2.lady:GetComponent(typeof(HeadAimIK))
	arg0_2.ladyHeadIKComp.AimTarget = arg0_2:Get("mainCameraTF"):Find("AimTarget")
	arg0_2.ladyHeadIKData = {
		DampTime = arg0_2.ladyHeadIKComp.DampTime,
		blinkSpeed = arg0_2.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg0_2.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg0_2.ladyHeadIKComp.HeadWeight
	}

	local var0_2 = {}

	table.Foreach(DormConst.boneMap, function(arg0_3, arg1_3)
		var0_2[arg1_3] = arg0_3
	end)

	arg0_2.ladyAnimator = arg0_2.lady:GetComponent(typeof(Animator))
	arg0_2.ladyAnimBaseLayerIndex = arg0_2.ladyAnimator:GetLayerIndex("Base Layer")
	arg0_2.ladyAnimFaceLayerIndex = arg0_2.ladyAnimator:GetLayerIndex("Face")
	arg0_2.ladyBoneMaps = {}

	local var1_2 = arg0_2.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_2, function(arg0_4, arg1_4)
		if arg1_4.name == "BodyCollider" then
			arg0_2.ladyCollider = arg1_4

			setActive(arg1_4, true)
		elseif arg1_4.name == "SafeCollider" then
			arg0_2.ladySafeCollider = arg1_4

			setActive(arg1_4, false)
		elseif arg1_4.name == "Interest" then
			arg0_2.ladyInterestRoot = arg1_4
		elseif arg1_4.name == "Head Center" then
			arg0_2.ladyHeadCenter = arg1_4
		end

		if var0_2[arg1_4.name] then
			arg0_2.ladyBoneMaps[var0_2[arg1_4.name]] = arg1_4
		end
	end)

	arg0_2.ladyColliders = {}
	arg0_2.ladyTouchColliders = {}

	table.IpairsCArray(arg0_2.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_5, arg1_5)
		if arg1_5:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var0_5 = tf(arg1_5)
		local var1_5 = var0_5.name
		local var2_5 = var1_5 and string.find(var1_5, "Collider") or -1
		local var3_5 = string.sub(var1_5, 1, var2_5 - 1)

		if DormConst.BONE_TO_TOUCH[var3_5] == nil then
			return
		end

		arg0_2.ladyColliders[var3_5] = var0_5

		table.insert(arg0_2.ladyTouchColliders, var0_5)
		setActive(var0_5, false)
	end)
	arg0_2:Func("HXCharacter", arg0_2.lady)

	arg0_2.clothComps = {}
	arg0_2.ladyClothCompSettings = {}

	table.IpairsCArray(arg0_2.lady:GetComponentsInChildren(typeof("MagicaCloth2.MagicaCloth"), true), function(arg0_6, arg1_6)
		table.insert(arg0_2.clothComps, arg1_6)

		arg0_2.ladyClothCompSettings[arg1_6] = {
			enabled = arg1_6.enabled
		}
	end)

	arg0_2.clothColliderDict = {}
	arg0_2.ladyClothColliderSettings = {}

	local var2_2 = typeof("MagicaCloth2.MagicaCapsuleCollider")

	table.IpairsCArray(arg0_2.lady:GetComponentsInChildren(var2_2, true), function(arg0_7, arg1_7)
		local var0_7 = arg1_7:GetSize()

		arg0_2.clothColliderDict[arg1_7.name] = arg1_7
		arg0_2.ladyClothColliderSettings[arg1_7] = {
			enabled = arg1_7.enabled,
			StartRadius = var0_7.x,
			EndRadius = var0_7.y
		}
	end)
	arg0_2:EnableCloth(false)

	arg0_2.ladyIKRoot = arg0_2.lady:Find("IKLayers")

	eachChild(arg0_2.ladyIKRoot, function(arg0_8)
		setActive(arg0_8, false)
	end)
	GetComponent(arg0_2.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_9, arg1_9)
		if arg1_9.rawPointerPress.transform == arg0_2.ladyCollider then
			arg0_2:Emit(Dorm3dRoomTemplateScene.CLICK_CHARACTER, arg1_2)
		else
			local var0_9 = table.keyof(arg0_2.IKSettings.Colliders, arg1_9.rawPointerPress.transform)

			arg0_2:Emit(Dorm3dRoomTemplateScene.ON_TOUCH_CHARACTER, var0_9 or arg1_9.rawPointerPress.name)
		end
	end)
	arg0_2.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_10)
		if arg0_2.nowState and arg0_10.animatorStateInfo:IsName(arg0_2.nowState) then
			existCall(arg0_2.stateCallback)

			return
		end

		local var0_10 = arg0_10.animatorStateInfo

		for iter0_10, iter1_10 in pairs(arg0_2.animCallbacks) do
			if var0_10:IsName(iter0_10) then
				warning("Active", iter0_10)

				local var1_10 = table.removebykey(arg0_2.animCallbacks, iter0_10)

				existCall(var1_10)

				return
			end
		end

		if arg0_10.stringParameter ~= "" then
			switch(arg0_10.stringParameter, arg0_2.animExtraEvent, function()
				arg0_2:Func("OnAnimationEvent", arg0_10)
			end)
		end
	end)

	arg0_2.animEventCallbacks = {}
	arg0_2.animCallbacks = {}
	arg0_2.animExtraEvent = {}

	local function var3_2(arg0_12, arg1_12, arg2_12)
		arg0_2:Get("loader"):GetPrefab(arg0_12, arg1_12, function(arg0_13)
			arg0_13.name = arg2_12
			arg0_2[arg2_12] = tf(arg0_13)

			setActive(arg0_13, false)
			onNextTick(function()
				setParent(arg0_2[arg2_12], arg0_2.ladyHeadCenter)
			end)
		end)
	end

	arg0_2.effectHeart = arg0_2.ladyHeadCenter:Find("effectHeart")

	if not arg0_2.effectHeart then
		var3_2("dorm3d/effect/prefab/function/vfx_function_aixin02", "vfx_function_aixin02", "effectHeart")
	end

	arg0_2.ladyWatchFloat = arg0_2.ladyHeadCenter:Find("ladyWatchFloat")

	if not arg0_2.ladyWatchFloat then
		var3_2("dorm3d/effect/prefab/scene/vfx_talk_mark", "vfx_talk_mark", "ladyWatchFloat")
	end

	if arg0_2.tfPendintItem then
		onNextTick(function()
			setParent(arg0_2.tfPendintItem, arg0_2.lady)
		end)
	end

	arg0_2.ladyOwner = GetComponent(arg0_2.lady, "GraphOwner")
	arg0_2.ladyBlackboard = GetComponent(arg0_2.lady, "Blackboard")

	arg0_2:SetBlackboardValue("groupId", arg1_2)
	onNextTick(function()
		arg0_2.ladyOwner.enabled = true
	end)
	pg.ViewUtils.SetLayer(arg0_2.lady, Layer.Character3D)

	arg0_2.characterController = GetOrAddComponent(arg0_2.ladyGameObject, typeof(CharacterController))
	arg0_2.characterController.enabled = false
	arg0_2.characterController.center = DormConst.CHARACTER_CONTROLLER.center
	arg0_2.characterController.radius = DormConst.CHARACTER_CONTROLLER.radius
	arg0_2.characterController.height = DormConst.CHARACTER_CONTROLLER.height
	arg0_2.characterController.stepOffset = DormConst.CHARACTER_CONTROLLER.stepOffset
	arg0_2.transparencyComp = GetOrAddComponent(arg0_2.lady, typeof(CharacterTransparency))
	arg0_2.transparencyComp.player = arg0_2:Get("player")
	arg0_2.transparencyComp.minDistance = DormConst.TRANSPARENCY_MIN_DISTANCE
	arg0_2.transparencyComp.maxDistance = DormConst.TRANSPARENCY_MAX_DISTANCE
end

function var0_0.SetZone(arg0_17, arg1_17, arg2_17)
	arg0_17.ladyBaseZone = arg1_17
	arg0_17.ladyActiveZone = arg2_17 or arg1_17
end

function var0_0.SwitchCharacterSkin(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18.skinIdList

	assert(table.contains(var0_18, arg2_18))

	local var1_18 = arg0_18:GetCurrentAnim()
	local var2_18 = arg0_18.skinId
	local var3_18 = arg0_18:Get("skinDict")[var2_18].ladyGameObject
	local var4_18 = var3_18.transform.position
	local var5_18 = var3_18.transform.rotation
	local var6_18 = arg0_18.ladyBlackboard

	setActive(var3_18, false)

	arg0_18.skinId = arg2_18

	setActive(arg0_18:Get("skinDict")[arg2_18].ladyGameObject, true)

	arg0_18.ladyGameObject = arg0_18:Get("skinDict")[arg2_18].ladyGameObject
	arg0_18.ladyCollider = nil

	arg0_18:InitCharacter(arg1_18)
	pg.NodeCanvasMgr.GetInstance():CopyAllBlackBoardValue(var6_18, arg0_18.ladyBlackboard)
	arg0_18.ladyAnimator:Play(var1_18, arg0_18.ladyAnimBaseLayerIndex)
	arg0_18.ladyAnimator:Update(0)
	arg0_18.lady:SetPositionAndRotation(var4_18, var5_18)
	existCall(arg3_18)
end

function var0_0.SetBlackboardValue(arg0_19, arg1_19, arg2_19)
	arg0_19.blackboard = arg0_19.blackboard or {}
	arg0_19.blackboard[arg1_19] = arg2_19

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_19, arg2_19, arg0_19.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_20, arg1_20)
	arg0_20.blackboard = arg0_20.blackboard or {}

	return arg0_20.blackboard[arg1_20]
end

function var0_0.HideCharacterPart(arg0_21, arg1_21, arg2_21)
	local var0_21, var1_21 = Dorm3dSkin.New({
		configId = arg1_21
	}):GetActiveAndHiddenPartNames(arg2_21)

	if arg0_21.lady == nil then
		arg0_21.lady = arg0_21.ladyGameObject.transform
	end

	_.each(var0_21, function(arg0_22)
		setActive(arg0_21.lady:Find(arg0_22), true)
	end)
	_.each(var1_21, function(arg0_23)
		setActive(arg0_21.lady:Find(arg0_23), false)
	end)
end

function var0_0.GetCurrentAnim(arg0_24)
	return arg0_24.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_24.ladyAnimBaseLayerIndex).shortNameHash
end

function var0_0.EnableCloth(arg0_25, arg1_25, arg2_25)
	arg1_25 = arg1_25 or {}

	table.Foreach(arg0_25.clothComps, function(arg0_26, arg1_26)
		if arg1_26 == nil then
			return
		end

		setActive(arg1_26, arg1_25[arg0_26] == 1)
	end)
	table.Foreach(arg0_25.clothColliderDict, function(arg0_27, arg1_27)
		if arg1_27 == nil then
			return
		end

		setActive(arg1_27, false)
	end)

	if arg2_25 then
		table.Foreach(arg2_25, function(arg0_28, arg1_28)
			local var0_28 = arg0_25.clothColliderDict[arg1_28[1]]

			if var0_28 == nil then
				return
			end

			setActive(var0_28, arg1_28[2] == 1)

			if arg1_28[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_28, arg1_28[3], arg1_28[4])
		end)
	end
end

function var0_0.PlaySingleAction(arg0_29, arg1_29, arg2_29, arg3_29)
	warning("Play", arg1_29)

	local var0_29 = string.find(arg1_29, "^Face_")
	local var1_29 = tobool(var0_29)

	if not var1_29 then
		local var2_29 = string.find(arg1_29, "^face_")

		var1_29 = tobool(var2_29)
	end

	if var1_29 then
		arg0_29:PlayFaceAnim(arg1_29, arg2_29)

		return
	end

	if arg0_29.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_29.ladyAnimBaseLayerIndex):IsName(arg1_29) then
		return
	end

	existCall(arg0_29.animExtraItemCallback)

	arg0_29.animExtraItemCallback = nil

	local var3_29 = arg0_29:GetBlackboardValue("groupId")
	local var4_29 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var3_29] or {}, function(arg0_30)
		return pg.dorm3d_anim_extraitem[arg0_30].anim == arg1_29
	end)
	local var5_29 = var4_29 and pg.dorm3d_anim_extraitem[var4_29]
	local var6_29

	arg3_29 = arg3_29 or DormConst.DEFAULT_ANIM_FADE_IN_TIME

	seriesAsync({
		function(arg0_31)
			if not var5_29 or var5_29.item_prefab == "" then
				arg0_31()

				return
			end

			local var0_31 = string.lower("dorm3d/furniture/item/" .. var5_29.item_prefab)

			arg0_29:Get("loader"):GetPrefab(var0_31, "", function(arg0_32)
				setParent(arg0_32, arg0_29.lady)

				if var5_29.item_shield ~= "" then
					var6_29 = {}

					for iter0_32, iter1_32 in ipairs(var5_29.item_shield) do
						local var0_32 = arg0_29:Get("modelRoot"):Find(iter1_32)

						if not var0_32 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var5_29.id, iter1_32))
						else
							var6_29[iter1_32] = isActive(var0_32)

							setActive(var0_32, false)
						end
					end
				end

				function arg0_29.animExtraItemCallback()
					arg0_29:Get("loader"):ClearRequest("AnimExtraItem")

					if var6_29 then
						for iter0_33, iter1_33 in pairs(var6_29) do
							setActive(arg0_29:Get("modelRoot"):Find(iter0_33), iter1_33)
						end
					end
				end

				arg0_31()
			end, "AnimExtraItem")
		end,
		function(arg0_34)
			arg0_29.nowState = arg1_29
			arg0_29.stateCallback = arg0_34

			arg0_29.ladyAnimator:CrossFadeInFixedTime(arg1_29, arg3_29, arg0_29.ladyAnimBaseLayerIndex)
		end,
		function(arg0_35)
			arg0_29.nowState = nil
			arg0_29.stateCallback = nil

			existCall(arg0_29.animExtraItemCallback)

			arg0_29.animExtraItemCallback = nil

			arg0_35()
		end,
		arg2_29
	})
end

function var0_0.PlayFaceAnim(arg0_36, arg1_36, arg2_36)
	arg0_36.ladyAnimator:CrossFadeInFixedTime(arg1_36, 0, arg0_36.ladyAnimFaceLayerIndex)
	existCall(arg2_36)
end

function var0_0.SwitchAnim(arg0_37, arg1_37, arg2_37)
	local var0_37 = string.find(arg1_37, "^Face_")

	if tobool(var0_37) then
		arg0_37:PlayFaceAnim(arg1_37, arg2_37)

		return
	end

	existCall(arg0_37.animExtraItemCallback)

	arg0_37.animExtraItemCallback = nil

	local var1_37 = {}

	table.insert(var1_37, function(arg0_38)
		arg0_37.nowState = arg1_37
		arg0_37.stateCallback = arg0_38

		arg0_37.ladyAnimator:PlayInFixedTime(arg1_37, arg0_37.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_37, function(arg0_39)
		arg0_37.nowState = nil
		arg0_37.stateCallback = nil

		arg0_39()
	end)
	seriesAsync(var1_37, arg2_37)
end

function var0_0.RegisterAnimExtraEvent(arg0_40, arg1_40, arg2_40)
	arg0_40.animExtraEvent[arg1_40] = arg2_40
end

function var0_0.RevertClothComps(arg0_41)
	table.Foreach(arg0_41.ladyClothCompSettings, function(arg0_42, arg1_42)
		arg0_42.enabled = arg1_42.enabled
	end)
	table.Foreach(arg0_41.ladyClothColliderSettings, function(arg0_43, arg1_43)
		arg0_43.enabled = arg1_43.enabled

		var0_0.SetMagicaCollider(arg0_43, arg1_43.StartRadius, arg1_43.EndRadius)
	end)
end

function var0_0.SetMagicaCollider(arg0_44, arg1_44, arg2_44)
	local var0_44 = typeof("MagicaCloth2.MagicaCapsuleCollider")
	local var1_44 = arg0_44:GetSize()

	var1_44.x = arg1_44
	var1_44.y = arg2_44

	arg0_44:SetSize(var1_44)
end

function var0_0.MoveToTarget(arg0_45, arg1_45, arg2_45, arg3_45)
	arg2_45 = arg2_45 or DormConst.LADY_MOVE_SPEED
	arg3_45 = arg3_45 or DormConst.LADY_ROTATE_SPEED

	local var0_45 = arg1_45 - arg0_45.lady.position

	var0_45.y = 0

	if var0_45 ~= Vector3.zero then
		local var1_45 = Quaternion.LookRotation(var0_45)

		arg0_45.lady.rotation = Quaternion.Slerp(arg0_45.lady.rotation, var1_45, Time.deltaTime * arg3_45)
	end

	local var2_45 = var0_45.normalized * arg2_45

	arg0_45.characterController:Move(var2_45 * Time.deltaTime)
end

function var0_0.SetCurrentIkTimelineStatus(arg0_46, arg1_46)
	arg0_46.currentIkTimelineStatus = arg1_46
end

function var0_0.CheckIkTimelineStatus(arg0_47, arg1_47)
	if not arg0_47.currentIkTimelineStatus then
		return true
	end

	return arg0_47.currentIkTimelineStatus ~= arg1_47
end

function var0_0.SetCollisible(arg0_48, arg1_48)
	local var0_48 = arg0_48.ladyCollider:GetComponent(typeof(UnityEngine.CapsuleCollider))

	if arg1_48 then
		var0_48.excludeLayers = LayerMask.GetMask("Nothing")
		arg0_48.characterController.excludeLayers = LayerMask.GetMask("Nothing")
	else
		var0_48.excludeLayers = LayerMask.GetMask("Player")
		arg0_48.characterController.excludeLayers = LayerMask.GetMask("Player")
	end
end

function var0_0.EnableCharacterTransparency(arg0_49, arg1_49)
	arg0_49.transparencyComp.Enable = arg1_49
end

function var0_0.BlockCanWatch(arg0_50, arg1_50)
	arg0_50.blockCanWatch = arg1_50
end

return var0_0
