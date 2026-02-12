local var0_0 = class("LadyEnv", import("view.dorm3d.Core.BaseLadyEnv"))

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
			arg0_2:Func("OnAnimationEvent", arg0_10)
		end
	end)

	arg0_2.animEventCallbacks = {}
	arg0_2.animCallbacks = {}

	local function var3_2(arg0_11, arg1_11, arg2_11)
		arg0_2:Get("loader"):GetPrefab(arg0_11, arg1_11, function(arg0_12)
			arg0_12.name = arg2_11
			arg0_2[arg2_11] = tf(arg0_12)

			setActive(arg0_12, false)
			onNextTick(function()
				setParent(arg0_2[arg2_11], arg0_2.ladyHeadCenter)
			end)
		end)
	end

	arg0_2.effectHeart = arg0_2.ladyHeadCenter:Find("effectHeart")

	if not arg0_2.effectHeart then
		var3_2("dorm3d/effect/prefab/function/vfx_function_aixin02", "vfx_function_aixin02", "effectHeart")
	end

	arg0_2.ladyWatchFloat = arg0_2.ladyHeadCenter:Find("ladyWatchFloat")

	if not arg0_2.ladyWatchFloat then
		var3_2("dorm3d/effect/prefab/function/vfx_talk_mark", "vfx_talk_mark", "ladyWatchFloat")
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
	arg0_2.animationEventDispatcher = GetOrAddComponent(arg0_2.lady, typeof(DormAnimationEventDispatcher))
	arg0_2.animationEventDispatcher.listenLayer = arg0_2.ladyAnimBaseLayerIndex
end

function var0_0.SetZone(arg0_16, arg1_16, arg2_16)
	arg0_16.ladyBaseZone = arg1_16
	arg0_16.ladyActiveZone = arg2_16 or arg1_16
end

function var0_0.SwitchCharacterSkin(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17.skinIdList

	assert(table.contains(var0_17, arg2_17))

	local var1_17 = arg0_17:GetCurrentAnim()
	local var2_17 = arg0_17.skinId
	local var3_17 = arg0_17:Get("skinDict")[var2_17].ladyGameObject
	local var4_17 = var3_17.transform.position
	local var5_17 = var3_17.transform.rotation
	local var6_17 = arg0_17.ladyBlackboard

	setActive(var3_17, false)

	arg0_17.skinId = arg2_17

	setActive(arg0_17:Get("skinDict")[arg2_17].ladyGameObject, true)

	arg0_17.ladyGameObject = arg0_17:Get("skinDict")[arg2_17].ladyGameObject
	arg0_17.ladyCollider = nil

	arg0_17:InitCharacter(arg1_17)
	pg.NodeCanvasMgr.GetInstance():CopyAllBlackBoardValue(var6_17, arg0_17.ladyBlackboard)
	arg0_17.ladyAnimator:Play(var1_17, arg0_17.ladyAnimBaseLayerIndex)
	arg0_17.ladyAnimator:Update(0)
	arg0_17.lady:SetPositionAndRotation(var4_17, var5_17)
	arg0_17:Func("InitHolyLight")
	existCall(arg3_17)
end

function var0_0.SetBlackboardValue(arg0_18, arg1_18, arg2_18)
	arg0_18.blackboard = arg0_18.blackboard or {}
	arg0_18.blackboard[arg1_18] = arg2_18

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_18, arg2_18, arg0_18.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_19, arg1_19)
	arg0_19.blackboard = arg0_19.blackboard or {}

	return arg0_19.blackboard[arg1_19]
end

function var0_0.GetCurrentAnim(arg0_20)
	return arg0_20.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_20.ladyAnimBaseLayerIndex).shortNameHash
end

function var0_0.EnableCloth(arg0_21, arg1_21, arg2_21)
	arg1_21 = arg1_21 or {}

	table.Foreach(arg0_21.clothComps, function(arg0_22, arg1_22)
		if arg1_22 == nil then
			return
		end

		setActive(arg1_22, arg1_21[arg0_22] == 1)
	end)
	table.Foreach(arg0_21.clothColliderDict, function(arg0_23, arg1_23)
		if arg1_23 == nil then
			return
		end

		setActive(arg1_23, false)
	end)

	if arg2_21 then
		table.Foreach(arg2_21, function(arg0_24, arg1_24)
			local var0_24 = arg0_21.clothColliderDict[arg1_24[1]]

			if var0_24 == nil then
				return
			end

			setActive(var0_24, arg1_24[2] == 1)

			if arg1_24[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_24, arg1_24[3], arg1_24[4])
		end)
	end
end

function var0_0.PlaySingleAction(arg0_25, arg1_25, arg2_25, arg3_25)
	warning("Play", arg1_25)

	local var0_25 = string.find(arg1_25, "^Face_")
	local var1_25 = tobool(var0_25)

	if not var1_25 then
		local var2_25 = string.find(arg1_25, "^face_")

		var1_25 = tobool(var2_25)
	end

	if var1_25 then
		arg0_25:PlayFaceAnim(arg1_25, arg2_25)

		return
	end

	if arg0_25.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_25.ladyAnimBaseLayerIndex):IsName(arg1_25) then
		return
	end

	existCall(arg0_25.animExtraItemCallback)

	arg0_25.animExtraItemCallback = nil

	local var3_25 = arg0_25:GetBlackboardValue("groupId")
	local var4_25 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var3_25] or {}, function(arg0_26)
		return pg.dorm3d_anim_extraitem[arg0_26].anim == arg1_25
	end)
	local var5_25 = var4_25 and pg.dorm3d_anim_extraitem[var4_25]
	local var6_25

	arg3_25 = arg3_25 or DormConst.DEFAULT_ANIM_FADE_IN_TIME

	seriesAsync({
		function(arg0_27)
			if not var5_25 or var5_25.item_prefab == "" then
				arg0_27()

				return
			end

			local var0_27 = string.lower("dorm3d/furniture/item/" .. var5_25.item_prefab)

			arg0_25:Get("loader"):GetPrefab(var0_27, "", function(arg0_28)
				setParent(arg0_28, arg0_25.lady)

				if var5_25.item_shield ~= "" then
					var6_25 = {}

					for iter0_28, iter1_28 in ipairs(var5_25.item_shield) do
						local var0_28 = arg0_25:Get("modelRoot"):Find(iter1_28)

						if not var0_28 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var5_25.id, iter1_28))
						else
							var6_25[iter1_28] = isActive(var0_28)

							setActive(var0_28, false)
						end
					end
				end

				function arg0_25.animExtraItemCallback()
					arg0_25:Get("loader"):ClearRequest("AnimExtraItem")

					if var6_25 then
						for iter0_29, iter1_29 in pairs(var6_25) do
							setActive(arg0_25:Get("modelRoot"):Find(iter0_29), iter1_29)
						end
					end
				end

				arg0_27()
			end, "AnimExtraItem")
		end,
		function(arg0_30)
			arg0_25.nowState = arg1_25
			arg0_25.stateCallback = arg0_30

			if IsUnityEditor and not arg0_25.ladyAnimator:HasState(arg0_25.ladyAnimBaseLayerIndex, Animator.StringToHash(arg1_25)) then
				errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_25)
			end

			arg0_25.ladyAnimator:CrossFadeInFixedTime(arg1_25, arg3_25, arg0_25.ladyAnimBaseLayerIndex)
		end,
		function(arg0_31)
			arg0_25.nowState = nil
			arg0_25.stateCallback = nil

			existCall(arg0_25.animExtraItemCallback)

			arg0_25.animExtraItemCallback = nil

			arg0_31()
		end,
		arg2_25
	})
end

function var0_0.PlayFaceAnim(arg0_32, arg1_32, arg2_32)
	if IsUnityEditor and not arg0_32.ladyAnimator:HasState(arg0_32.ladyAnimFaceLayerIndex, Animator.StringToHash(arg1_32)) then
		errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_32)
	end

	arg0_32.ladyAnimator:CrossFadeInFixedTime(arg1_32, 0, arg0_32.ladyAnimFaceLayerIndex)
	existCall(arg2_32)
end

function var0_0.SwitchAnim(arg0_33, arg1_33, arg2_33)
	local var0_33 = string.find(arg1_33, "^Face_")

	if tobool(var0_33) then
		arg0_33:PlayFaceAnim(arg1_33, arg2_33)

		return
	end

	existCall(arg0_33.animExtraItemCallback)

	arg0_33.animExtraItemCallback = nil

	local var1_33 = {}

	table.insert(var1_33, function(arg0_34)
		arg0_33.nowState = arg1_33
		arg0_33.stateCallback = arg0_34

		arg0_33.ladyAnimator:PlayInFixedTime(arg1_33, arg0_33.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_33, function(arg0_35)
		arg0_33.nowState = nil
		arg0_33.stateCallback = nil

		arg0_35()
	end)
	seriesAsync(var1_33, arg2_33)
end

function var0_0.RevertClothComps(arg0_36)
	table.Foreach(arg0_36.ladyClothCompSettings, function(arg0_37, arg1_37)
		arg0_37.enabled = arg1_37.enabled
	end)
	table.Foreach(arg0_36.ladyClothColliderSettings, function(arg0_38, arg1_38)
		arg0_38.enabled = arg1_38.enabled

		var0_0.SetMagicaCollider(arg0_38, arg1_38.StartRadius, arg1_38.EndRadius)
	end)
end

function var0_0.SetMagicaCollider(arg0_39, arg1_39, arg2_39)
	local var0_39 = typeof("MagicaCloth2.MagicaCapsuleCollider")
	local var1_39 = arg0_39:GetSize()

	var1_39.x = arg1_39
	var1_39.y = arg2_39

	arg0_39:SetSize(var1_39)
end

function var0_0.MoveToTarget(arg0_40, arg1_40, arg2_40, arg3_40)
	arg2_40 = arg2_40 or DormConst.LADY_MOVE_SPEED
	arg3_40 = arg3_40 or DormConst.LADY_ROTATE_SPEED

	local var0_40 = arg1_40 - arg0_40.lady.position

	var0_40.y = 0

	if var0_40 ~= Vector3.zero then
		local var1_40 = Quaternion.LookRotation(var0_40)

		arg0_40.lady.rotation = Quaternion.Slerp(arg0_40.lady.rotation, var1_40, Time.deltaTime * arg3_40)
	end

	local var2_40 = var0_40.normalized * arg2_40

	arg0_40.characterController:Move(var2_40 * Time.deltaTime)
end

function var0_0.SetCurrentIkTimelineStatus(arg0_41, arg1_41)
	arg0_41.currentIkTimelineStatus = arg1_41
end

function var0_0.CheckIkTimelineStatus(arg0_42, arg1_42)
	if not arg0_42.currentIkTimelineStatus then
		return true
	end

	return arg0_42.currentIkTimelineStatus ~= arg1_42
end

function var0_0.SetCollisible(arg0_43, arg1_43)
	local var0_43 = arg0_43.ladyCollider:GetComponent(typeof(UnityEngine.CapsuleCollider))

	if arg1_43 then
		var0_43.excludeLayers = LayerMask.GetMask("Nothing")
		arg0_43.characterController.excludeLayers = LayerMask.GetMask("Nothing")
	else
		var0_43.excludeLayers = LayerMask.GetMask("Player")
		arg0_43.characterController.excludeLayers = LayerMask.GetMask("Player")
	end
end

function var0_0.EnableCharacterTransparency(arg0_44, arg1_44)
	arg0_44.transparencyComp.Enable = arg1_44
end

function var0_0.BlockCanWatch(arg0_45, arg1_45)
	arg0_45.blockCanWatch = arg1_45
end

function var0_0.SetPosition(arg0_46, arg1_46)
	arg0_46.lady.position = arg1_46
end

function var0_0.SetRotation(arg0_47, arg1_47)
	arg0_47.lady.rotation = arg1_47
end

return var0_0
