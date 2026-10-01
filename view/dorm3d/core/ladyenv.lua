local var0_0 = class("LadyEnv", import("view.dorm3d.Core.BaseLadyEnv"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.super.Ctor(arg0_1, arg1_1.event, arg1_1)
end

function var0_0.InitCharacter(arg0_2, arg1_2)
	arg0_2:InitCharacterRoot()
	arg0_2:InitCharacterAimIK()
	arg0_2:InitCharacterAnimator()
	arg0_2:InitCharacterHierarchy()
	arg0_2:InitCharacterCollider()
	arg0_2:InitCharacterCloth()
	arg0_2:InitCharacterIKRoot()
	arg0_2:InitCharacterTouchEvent(arg1_2)
	arg0_2:InitCharacterAnimationEvent()
	arg0_2:InitCharacterEffects()
	arg0_2:InitCharacterBlackboard(arg1_2)
	arg0_2:InitCharacterLayer()
	arg0_2:InitCharacterController()
	arg0_2:InitCharacterTransparency()
	arg0_2:InitCharacterAnimationDispatcher()
end

function var0_0.InitCharacterRoot(arg0_3)
	arg0_3.lady = arg0_3.ladyGameObject.transform

	arg0_3.lady:SetParent(arg0_3:Get("mainCameraTF"))
	arg0_3.lady:SetParent(nil)
end

function var0_0.InitCharacterAimIK(arg0_4)
	arg0_4.ladyHeadIKComp = arg0_4.lady:GetComponent(typeof(HeadAimIK))
	arg0_4.ladyHeadIKComp.AimTarget = arg0_4:Get("mainCameraTF"):Find("AimTarget")
	arg0_4.ladyHeadIKData = {
		DampTime = arg0_4.ladyHeadIKComp.DampTime,
		blinkSpeed = arg0_4.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg0_4.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg0_4.ladyHeadIKComp.HeadWeight
	}
end

function var0_0.InitCharacterAnimator(arg0_5)
	arg0_5.ladyAnimator = arg0_5.lady:GetComponent(typeof(Animator))
	arg0_5.ladyAnimBaseLayerIndex = arg0_5.ladyAnimator:GetLayerIndex("Base Layer")
	arg0_5.ladyAnimFaceLayerIndex = arg0_5.ladyAnimator:GetLayerIndex("Face")
end

function var0_0.InitCharacterHierarchy(arg0_6)
	local var0_6 = {}

	table.Foreach(DormConst.boneMap, function(arg0_7, arg1_7)
		var0_6[arg1_7] = arg0_7
	end)

	arg0_6.ladyBoneMaps = {}

	local var1_6 = arg0_6.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_6, function(arg0_8, arg1_8)
		if arg1_8.name == "BodyCollider" then
			arg0_6.ladyCollider = arg1_8

			setActive(arg1_8, true)
		elseif arg1_8.name == "SafeCollider" then
			arg0_6.ladySafeCollider = arg1_8

			setActive(arg1_8, false)
		elseif arg1_8.name == "Interest" then
			arg0_6.ladyInterestRoot = arg1_8
		elseif arg1_8.name == "Head Center" then
			arg0_6.ladyHeadCenter = arg1_8
		end

		if var0_6[arg1_8.name] then
			arg0_6.ladyBoneMaps[var0_6[arg1_8.name]] = arg1_8
		end
	end)
end

function var0_0.InitCharacterCollider(arg0_9)
	arg0_9.ladyColliders = {}
	arg0_9.ladyTouchColliders = {}

	table.IpairsCArray(arg0_9.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_10, arg1_10)
		if arg1_10:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var0_10 = tf(arg1_10)
		local var1_10 = var0_10.name
		local var2_10 = var1_10 and string.find(var1_10, "Collider") or -1
		local var3_10 = string.sub(var1_10, 1, var2_10 - 1)

		if DormConst.BONE_TO_TOUCH[var3_10] == nil then
			return
		end

		arg0_9.ladyColliders[var3_10] = var0_10

		table.insert(arg0_9.ladyTouchColliders, var0_10)
		setActive(var0_10, false)
	end)
end

function var0_0.InitCharacterCloth(arg0_11)
	arg0_11.clothComps = {}
	arg0_11.ladyClothCompSettings = {}

	table.IpairsCArray(arg0_11.lady:GetComponentsInChildren(typeof("MagicaCloth2.MagicaCloth"), true), function(arg0_12, arg1_12)
		table.insert(arg0_11.clothComps, arg1_12)

		arg0_11.ladyClothCompSettings[arg1_12] = {
			enabled = arg1_12.enabled
		}
	end)

	arg0_11.clothColliderDict = {}
	arg0_11.ladyClothColliderSettings = {}

	local var0_11 = typeof("MagicaCloth2.MagicaCapsuleCollider")

	table.IpairsCArray(arg0_11.lady:GetComponentsInChildren(var0_11, true), function(arg0_13, arg1_13)
		local var0_13 = arg1_13:GetSize()

		arg0_11.clothColliderDict[arg1_13.name] = arg1_13
		arg0_11.ladyClothColliderSettings[arg1_13] = {
			enabled = arg1_13.enabled,
			StartRadius = var0_13.x,
			EndRadius = var0_13.y
		}
	end)
	arg0_11:EnableCloth(false)
end

function var0_0.InitCharacterIKRoot(arg0_14)
	arg0_14.ladyIKRoot = arg0_14.lady:Find("IKLayers")

	eachChild(arg0_14.ladyIKRoot, function(arg0_15)
		setActive(arg0_15, false)
	end)
end

function var0_0.InitCharacterTouchEvent(arg0_16, arg1_16)
	GetComponent(arg0_16.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_17, arg1_17)
		if arg1_17.rawPointerPress.transform == arg0_16.ladyCollider then
			arg0_16:Emit(Dorm3dRoomTemplateScene.CLICK_CHARACTER, arg1_16)
		end
	end)
end

function var0_0.InitCharacterAnimationEvent(arg0_18)
	arg0_18.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_19)
		if arg0_18.nowState and arg0_19.animatorStateInfo:IsName(arg0_18.nowState) then
			existCall(arg0_18.stateCallback)

			return
		end

		local var0_19 = arg0_19.animatorStateInfo

		for iter0_19, iter1_19 in pairs(arg0_18.animCallbacks) do
			if var0_19:IsName(iter0_19) then
				warning("Active", iter0_19)

				local var1_19 = table.removebykey(arg0_18.animCallbacks, iter0_19)

				existCall(var1_19)

				return
			end
		end

		if arg0_19.stringParameter ~= "" then
			arg0_18:Func("OnAnimationEvent", arg0_19)
		end
	end)

	arg0_18.animEventCallbacks = {}
	arg0_18.animCallbacks = {}
end

function var0_0.InitCharacterEffects(arg0_20)
	local function var0_20(arg0_21, arg1_21, arg2_21)
		arg0_20:Get("loader"):GetPrefab(arg0_21, arg1_21, function(arg0_22)
			arg0_22.name = arg2_21
			arg0_20[arg2_21] = tf(arg0_22)

			setActive(arg0_22, false)
			onNextTick(function()
				setParent(arg0_20[arg2_21], arg0_20.ladyHeadCenter)
			end)
		end)
	end

	arg0_20.effectHeart = arg0_20.ladyHeadCenter:Find("effectHeart")

	if not arg0_20.effectHeart then
		var0_20("dorm3d/effect/prefab/function/vfx_function_aixin02", "vfx_function_aixin02", "effectHeart")
	end

	arg0_20.ladyWatchFloat = arg0_20.ladyHeadCenter:Find("ladyWatchFloat")

	if not arg0_20.ladyWatchFloat then
		var0_20("dorm3d/effect/prefab/function/vfx_talk_mark", "vfx_talk_mark", "ladyWatchFloat")
	end

	if arg0_20.tfPendintItem then
		onNextTick(function()
			setParent(arg0_20.tfPendintItem, arg0_20.lady)
		end)
	end
end

function var0_0.InitCharacterBlackboard(arg0_25, arg1_25)
	arg0_25.ladyOwner = GetComponent(arg0_25.lady, "GraphOwner")
	arg0_25.ladyBlackboard = GetComponent(arg0_25.lady, "Blackboard")

	arg0_25:SetBlackboardValue("groupId", arg1_25)
	onNextTick(function()
		arg0_25.ladyOwner.enabled = true
	end)
end

function var0_0.InitCharacterLayer(arg0_27)
	pg.ViewUtils.SetLayer(arg0_27.lady, Layer.Character3D)
end

function var0_0.InitCharacterController(arg0_28)
	arg0_28.characterController = GetOrAddComponent(arg0_28.ladyGameObject, typeof(CharacterController))
	arg0_28.characterController.enabled = false
	arg0_28.characterController.center = DormConst.CHARACTER_CONTROLLER.center
	arg0_28.characterController.radius = DormConst.CHARACTER_CONTROLLER.radius
	arg0_28.characterController.height = DormConst.CHARACTER_CONTROLLER.height
	arg0_28.characterController.stepOffset = DormConst.CHARACTER_CONTROLLER.stepOffset
end

function var0_0.InitCharacterTransparency(arg0_29)
	arg0_29.transparencyComp = GetOrAddComponent(arg0_29.lady, typeof(CharacterTransparency))
	arg0_29.transparencyComp.player = arg0_29:Get("player")
	arg0_29.transparencyComp.minDistance = DormConst.TRANSPARENCY_MIN_DISTANCE
	arg0_29.transparencyComp.maxDistance = DormConst.TRANSPARENCY_MAX_DISTANCE
end

function var0_0.InitCharacterAnimationDispatcher(arg0_30)
	arg0_30.animationEventDispatcher = GetOrAddComponent(arg0_30.lady, typeof(DormAnimationEventDispatcher))
	arg0_30.animationEventDispatcher.listenLayer = arg0_30.ladyAnimBaseLayerIndex
end

function var0_0.SwitchCharacterSkin(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = arg0_31.skinIdList

	assert(table.contains(var0_31, arg2_31))

	local var1_31 = arg0_31:GetCurrentAnim()
	local var2_31 = arg0_31.skinId
	local var3_31 = arg0_31:Get("skinDict")[var2_31].ladyGameObject
	local var4_31 = var3_31.transform.position
	local var5_31 = var3_31.transform.rotation
	local var6_31 = arg0_31.ladyBlackboard

	setActive(var3_31, false)

	arg0_31.skinId = arg2_31

	setActive(arg0_31:Get("skinDict")[arg2_31].ladyGameObject, true)

	arg0_31.ladyGameObject = arg0_31:Get("skinDict")[arg2_31].ladyGameObject
	arg0_31.ladyCollider = nil

	arg0_31:InitCharacter(arg1_31)
	arg0_31:Func("HXCharacter", arg0_31.lady, arg0_31.skinId)
	pg.NodeCanvasMgr.GetInstance():CopyAllBlackBoardValue(var6_31, arg0_31.ladyBlackboard)
	arg0_31.ladyAnimator:Play(var1_31, arg0_31.ladyAnimBaseLayerIndex)
	arg0_31.ladyAnimator:Update(0)
	arg0_31.lady:SetPositionAndRotation(var4_31, var5_31)
	arg0_31:Func("InitHolyLight")
	existCall(arg3_31)
end

function var0_0.SetBlackboardValue(arg0_32, arg1_32, arg2_32)
	arg0_32.blackboard = arg0_32.blackboard or {}
	arg0_32.blackboard[arg1_32] = arg2_32

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_32, arg2_32, arg0_32.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_33, arg1_33)
	arg0_33.blackboard = arg0_33.blackboard or {}

	return arg0_33.blackboard[arg1_33]
end

function var0_0.GetCurrentAnim(arg0_34)
	return arg0_34.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_34.ladyAnimBaseLayerIndex).shortNameHash
end

function var0_0.EnableCloth(arg0_35, arg1_35, arg2_35)
	arg1_35 = arg1_35 or {}

	table.Foreach(arg0_35.clothComps, function(arg0_36, arg1_36)
		if arg1_36 == nil then
			return
		end

		setActive(arg1_36, arg1_35[arg0_36] == 1)
	end)
	table.Foreach(arg0_35.clothColliderDict, function(arg0_37, arg1_37)
		if arg1_37 == nil then
			return
		end

		setActive(arg1_37, false)
	end)

	if arg2_35 then
		table.Foreach(arg2_35, function(arg0_38, arg1_38)
			local var0_38 = arg0_35.clothColliderDict[arg1_38[1]]

			if var0_38 == nil then
				return
			end

			setActive(var0_38, arg1_38[2] == 1)

			if arg1_38[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_38, arg1_38[3], arg1_38[4])
		end)
	end
end

function var0_0.PlaySingleAction(arg0_39, arg1_39, arg2_39, arg3_39)
	warning("Play", arg1_39)

	local var0_39 = string.find(arg1_39, "^Face_")
	local var1_39 = tobool(var0_39)

	if not var1_39 then
		local var2_39 = string.find(arg1_39, "^face_")

		var1_39 = tobool(var2_39)
	end

	if var1_39 then
		arg0_39:PlayFaceAnim(arg1_39, arg2_39)

		return
	end

	if arg0_39.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_39.ladyAnimBaseLayerIndex):IsName(arg1_39) then
		return
	end

	existCall(arg0_39.animExtraItemCallback)

	arg0_39.animExtraItemCallback = nil

	local var3_39 = arg0_39:GetBlackboardValue("groupId")
	local var4_39 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var3_39] or {}, function(arg0_40)
		return pg.dorm3d_anim_extraitem[arg0_40].anim == arg1_39
	end)
	local var5_39 = var4_39 and pg.dorm3d_anim_extraitem[var4_39]
	local var6_39

	arg3_39 = arg3_39 or DormConst.DEFAULT_ANIM_FADE_IN_TIME

	seriesAsync({
		function(arg0_41)
			if not var5_39 or var5_39.item_prefab == "" then
				arg0_41()

				return
			end

			local var0_41 = string.lower("dorm3d/furniture/item/" .. var5_39.item_prefab)

			arg0_39:Get("loader"):GetPrefab(var0_41, "", function(arg0_42)
				setParent(arg0_42, arg0_39.lady)

				if var5_39.item_shield ~= "" then
					var6_39 = {}

					for iter0_42, iter1_42 in ipairs(var5_39.item_shield) do
						local var0_42 = arg0_39:Get("modelRoot"):Find(iter1_42)

						if not var0_42 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var5_39.id, iter1_42))
						else
							var6_39[iter1_42] = isActive(var0_42)

							setActive(var0_42, false)
						end
					end
				end

				function arg0_39.animExtraItemCallback()
					arg0_39:Get("loader"):ClearRequest("AnimExtraItem")

					if var6_39 then
						for iter0_43, iter1_43 in pairs(var6_39) do
							setActive(arg0_39:Get("modelRoot"):Find(iter0_43), iter1_43)
						end
					end
				end

				arg0_41()
			end, "AnimExtraItem")
		end,
		function(arg0_44)
			arg0_39.nowState = arg1_39
			arg0_39.stateCallback = arg0_44

			if IsUnityEditor and not arg0_39.ladyAnimator:HasState(arg0_39.ladyAnimBaseLayerIndex, Animator.StringToHash(arg1_39)) then
				errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_39)
			end

			arg0_39.ladyAnimator:CrossFadeInFixedTime(arg1_39, arg3_39, arg0_39.ladyAnimBaseLayerIndex)
		end,
		function(arg0_45)
			arg0_39.nowState = nil
			arg0_39.stateCallback = nil

			existCall(arg0_39.animExtraItemCallback)

			arg0_39.animExtraItemCallback = nil

			arg0_45()
		end,
		arg2_39
	})
end

function var0_0.PlayFaceAnim(arg0_46, arg1_46, arg2_46)
	if IsUnityEditor and not arg0_46.ladyAnimator:HasState(arg0_46.ladyAnimFaceLayerIndex, Animator.StringToHash(arg1_46)) then
		errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_46)
	end

	arg0_46.ladyAnimator:CrossFadeInFixedTime(arg1_46, 0, arg0_46.ladyAnimFaceLayerIndex)
	existCall(arg2_46)
end

function var0_0.SwitchAnim(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47 = string.find(arg1_47, "^Face_")

	if tobool(var0_47) then
		arg0_47:PlayFaceAnim(arg1_47, arg2_47)

		return
	end

	existCall(arg0_47.animExtraItemCallback)

	arg0_47.animExtraItemCallback = nil

	local var1_47 = {}

	table.insert(var1_47, function(arg0_48)
		arg0_47.nowState = arg1_47
		arg0_47.stateCallback = arg0_48

		arg0_47.ladyAnimator:PlayInFixedTime(arg1_47, arg0_47.ladyAnimBaseLayerIndex, arg3_47 and 0 or -math.huge)
	end)
	table.insert(var1_47, function(arg0_49)
		arg0_47.nowState = nil
		arg0_47.stateCallback = nil

		arg0_49()
	end)
	seriesAsync(var1_47, arg2_47)
end

function var0_0.RevertClothComps(arg0_50)
	table.Foreach(arg0_50.ladyClothCompSettings, function(arg0_51, arg1_51)
		arg0_51.enabled = arg1_51.enabled
	end)
	table.Foreach(arg0_50.ladyClothColliderSettings, function(arg0_52, arg1_52)
		arg0_52.enabled = arg1_52.enabled

		var0_0.SetMagicaCollider(arg0_52, arg1_52.StartRadius, arg1_52.EndRadius)
	end)
end

function var0_0.SetMagicaCollider(arg0_53, arg1_53, arg2_53)
	local var0_53 = typeof("MagicaCloth2.MagicaCapsuleCollider")
	local var1_53 = arg0_53:GetSize()

	var1_53.x = arg1_53
	var1_53.y = arg2_53

	arg0_53:SetSize(var1_53)
end

function var0_0.MoveToTarget(arg0_54, arg1_54, arg2_54, arg3_54)
	arg2_54 = arg2_54 or DormConst.LADY_MOVE_SPEED
	arg3_54 = arg3_54 or DormConst.LADY_ROTATE_SPEED

	local var0_54 = arg1_54 - arg0_54.lady.position

	var0_54.y = 0

	if var0_54 ~= Vector3.zero then
		local var1_54 = Quaternion.LookRotation(var0_54)

		arg0_54.lady.rotation = Quaternion.Slerp(arg0_54.lady.rotation, var1_54, Time.deltaTime * arg3_54)
	end

	local var2_54 = var0_54.normalized * arg2_54

	arg0_54.characterController:Move(var2_54 * Time.deltaTime)
end

function var0_0.SetCollisible(arg0_55, arg1_55)
	local var0_55 = arg0_55.ladyCollider:GetComponent(typeof(UnityEngine.CapsuleCollider))

	if arg1_55 then
		var0_55.excludeLayers = LayerMask.GetMask("Nothing")
		arg0_55.characterController.excludeLayers = LayerMask.GetMask("Nothing")
	else
		var0_55.excludeLayers = LayerMask.GetMask("Player")
		arg0_55.characterController.excludeLayers = LayerMask.GetMask("Player")
	end
end

function var0_0.EnableCharacterTransparency(arg0_56, arg1_56)
	arg0_56.transparencyComp.Enable = arg1_56
end

function var0_0.BlockCanWatch(arg0_57, arg1_57)
	arg0_57.blockCanWatch = arg1_57
end

function var0_0.SetPosition(arg0_58, arg1_58)
	arg0_58.lady.position = arg1_58
end

function var0_0.SetRotation(arg0_59, arg1_59)
	arg0_59.lady.rotation = arg1_59
end

return var0_0
