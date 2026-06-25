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

function var0_0.SetZone(arg0_31, arg1_31, arg2_31)
	arg0_31.ladyBaseZone = arg1_31
	arg0_31.ladyActiveZone = arg2_31 or arg1_31
end

function var0_0.SwitchCharacterSkin(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = arg0_32.skinIdList

	assert(table.contains(var0_32, arg2_32))

	local var1_32 = arg0_32:GetCurrentAnim()
	local var2_32 = arg0_32.skinId
	local var3_32 = arg0_32:Get("skinDict")[var2_32].ladyGameObject
	local var4_32 = var3_32.transform.position
	local var5_32 = var3_32.transform.rotation
	local var6_32 = arg0_32.ladyBlackboard

	setActive(var3_32, false)

	arg0_32.skinId = arg2_32

	setActive(arg0_32:Get("skinDict")[arg2_32].ladyGameObject, true)

	arg0_32.ladyGameObject = arg0_32:Get("skinDict")[arg2_32].ladyGameObject
	arg0_32.ladyCollider = nil

	arg0_32:InitCharacter(arg1_32)
	pg.NodeCanvasMgr.GetInstance():CopyAllBlackBoardValue(var6_32, arg0_32.ladyBlackboard)
	arg0_32.ladyAnimator:Play(var1_32, arg0_32.ladyAnimBaseLayerIndex)
	arg0_32.ladyAnimator:Update(0)
	arg0_32.lady:SetPositionAndRotation(var4_32, var5_32)
	arg0_32:Func("InitHolyLight")
	existCall(arg3_32)
end

function var0_0.SetBlackboardValue(arg0_33, arg1_33, arg2_33)
	arg0_33.blackboard = arg0_33.blackboard or {}
	arg0_33.blackboard[arg1_33] = arg2_33

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_33, arg2_33, arg0_33.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_34, arg1_34)
	arg0_34.blackboard = arg0_34.blackboard or {}

	return arg0_34.blackboard[arg1_34]
end

function var0_0.GetCurrentAnim(arg0_35)
	return arg0_35.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_35.ladyAnimBaseLayerIndex).shortNameHash
end

function var0_0.EnableCloth(arg0_36, arg1_36, arg2_36)
	arg1_36 = arg1_36 or {}

	table.Foreach(arg0_36.clothComps, function(arg0_37, arg1_37)
		if arg1_37 == nil then
			return
		end

		setActive(arg1_37, arg1_36[arg0_37] == 1)
	end)
	table.Foreach(arg0_36.clothColliderDict, function(arg0_38, arg1_38)
		if arg1_38 == nil then
			return
		end

		setActive(arg1_38, false)
	end)

	if arg2_36 then
		table.Foreach(arg2_36, function(arg0_39, arg1_39)
			local var0_39 = arg0_36.clothColliderDict[arg1_39[1]]

			if var0_39 == nil then
				return
			end

			setActive(var0_39, arg1_39[2] == 1)

			if arg1_39[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_39, arg1_39[3], arg1_39[4])
		end)
	end
end

function var0_0.PlaySingleAction(arg0_40, arg1_40, arg2_40, arg3_40)
	warning("Play", arg1_40)

	local var0_40 = string.find(arg1_40, "^Face_")
	local var1_40 = tobool(var0_40)

	if not var1_40 then
		local var2_40 = string.find(arg1_40, "^face_")

		var1_40 = tobool(var2_40)
	end

	if var1_40 then
		arg0_40:PlayFaceAnim(arg1_40, arg2_40)

		return
	end

	if arg0_40.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_40.ladyAnimBaseLayerIndex):IsName(arg1_40) then
		return
	end

	existCall(arg0_40.animExtraItemCallback)

	arg0_40.animExtraItemCallback = nil

	local var3_40 = arg0_40:GetBlackboardValue("groupId")
	local var4_40 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var3_40] or {}, function(arg0_41)
		return pg.dorm3d_anim_extraitem[arg0_41].anim == arg1_40
	end)
	local var5_40 = var4_40 and pg.dorm3d_anim_extraitem[var4_40]
	local var6_40

	arg3_40 = arg3_40 or DormConst.DEFAULT_ANIM_FADE_IN_TIME

	seriesAsync({
		function(arg0_42)
			if not var5_40 or var5_40.item_prefab == "" then
				arg0_42()

				return
			end

			local var0_42 = string.lower("dorm3d/furniture/item/" .. var5_40.item_prefab)

			arg0_40:Get("loader"):GetPrefab(var0_42, "", function(arg0_43)
				setParent(arg0_43, arg0_40.lady)

				if var5_40.item_shield ~= "" then
					var6_40 = {}

					for iter0_43, iter1_43 in ipairs(var5_40.item_shield) do
						local var0_43 = arg0_40:Get("modelRoot"):Find(iter1_43)

						if not var0_43 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var5_40.id, iter1_43))
						else
							var6_40[iter1_43] = isActive(var0_43)

							setActive(var0_43, false)
						end
					end
				end

				function arg0_40.animExtraItemCallback()
					arg0_40:Get("loader"):ClearRequest("AnimExtraItem")

					if var6_40 then
						for iter0_44, iter1_44 in pairs(var6_40) do
							setActive(arg0_40:Get("modelRoot"):Find(iter0_44), iter1_44)
						end
					end
				end

				arg0_42()
			end, "AnimExtraItem")
		end,
		function(arg0_45)
			arg0_40.nowState = arg1_40
			arg0_40.stateCallback = arg0_45

			if IsUnityEditor and not arg0_40.ladyAnimator:HasState(arg0_40.ladyAnimBaseLayerIndex, Animator.StringToHash(arg1_40)) then
				errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_40)
			end

			arg0_40.ladyAnimator:CrossFadeInFixedTime(arg1_40, arg3_40, arg0_40.ladyAnimBaseLayerIndex)
		end,
		function(arg0_46)
			arg0_40.nowState = nil
			arg0_40.stateCallback = nil

			existCall(arg0_40.animExtraItemCallback)

			arg0_40.animExtraItemCallback = nil

			arg0_46()
		end,
		arg2_40
	})
end

function var0_0.PlayFaceAnim(arg0_47, arg1_47, arg2_47)
	if IsUnityEditor and not arg0_47.ladyAnimator:HasState(arg0_47.ladyAnimFaceLayerIndex, Animator.StringToHash(arg1_47)) then
		errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_47)
	end

	arg0_47.ladyAnimator:CrossFadeInFixedTime(arg1_47, 0, arg0_47.ladyAnimFaceLayerIndex)
	existCall(arg2_47)
end

function var0_0.SwitchAnim(arg0_48, arg1_48, arg2_48)
	local var0_48 = string.find(arg1_48, "^Face_")

	if tobool(var0_48) then
		arg0_48:PlayFaceAnim(arg1_48, arg2_48)

		return
	end

	existCall(arg0_48.animExtraItemCallback)

	arg0_48.animExtraItemCallback = nil

	local var1_48 = {}

	table.insert(var1_48, function(arg0_49)
		arg0_48.nowState = arg1_48
		arg0_48.stateCallback = arg0_49

		arg0_48.ladyAnimator:PlayInFixedTime(arg1_48, arg0_48.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_48, function(arg0_50)
		arg0_48.nowState = nil
		arg0_48.stateCallback = nil

		arg0_50()
	end)
	seriesAsync(var1_48, arg2_48)
end

function var0_0.RevertClothComps(arg0_51)
	table.Foreach(arg0_51.ladyClothCompSettings, function(arg0_52, arg1_52)
		arg0_52.enabled = arg1_52.enabled
	end)
	table.Foreach(arg0_51.ladyClothColliderSettings, function(arg0_53, arg1_53)
		arg0_53.enabled = arg1_53.enabled

		var0_0.SetMagicaCollider(arg0_53, arg1_53.StartRadius, arg1_53.EndRadius)
	end)
end

function var0_0.SetMagicaCollider(arg0_54, arg1_54, arg2_54)
	local var0_54 = typeof("MagicaCloth2.MagicaCapsuleCollider")
	local var1_54 = arg0_54:GetSize()

	var1_54.x = arg1_54
	var1_54.y = arg2_54

	arg0_54:SetSize(var1_54)
end

function var0_0.MoveToTarget(arg0_55, arg1_55, arg2_55, arg3_55)
	arg2_55 = arg2_55 or DormConst.LADY_MOVE_SPEED
	arg3_55 = arg3_55 or DormConst.LADY_ROTATE_SPEED

	local var0_55 = arg1_55 - arg0_55.lady.position

	var0_55.y = 0

	if var0_55 ~= Vector3.zero then
		local var1_55 = Quaternion.LookRotation(var0_55)

		arg0_55.lady.rotation = Quaternion.Slerp(arg0_55.lady.rotation, var1_55, Time.deltaTime * arg3_55)
	end

	local var2_55 = var0_55.normalized * arg2_55

	arg0_55.characterController:Move(var2_55 * Time.deltaTime)
end

function var0_0.SetCurrentIkTimelineStatus(arg0_56, arg1_56)
	arg0_56.currentIkTimelineStatus = arg1_56
end

function var0_0.CheckIkTimelineStatus(arg0_57, arg1_57)
	if not arg0_57.currentIkTimelineStatus then
		return true
	end

	return arg0_57.currentIkTimelineStatus ~= arg1_57
end

function var0_0.SetCollisible(arg0_58, arg1_58)
	local var0_58 = arg0_58.ladyCollider:GetComponent(typeof(UnityEngine.CapsuleCollider))

	if arg1_58 then
		var0_58.excludeLayers = LayerMask.GetMask("Nothing")
		arg0_58.characterController.excludeLayers = LayerMask.GetMask("Nothing")
	else
		var0_58.excludeLayers = LayerMask.GetMask("Player")
		arg0_58.characterController.excludeLayers = LayerMask.GetMask("Player")
	end
end

function var0_0.EnableCharacterTransparency(arg0_59, arg1_59)
	arg0_59.transparencyComp.Enable = arg1_59
end

function var0_0.BlockCanWatch(arg0_60, arg1_60)
	arg0_60.blockCanWatch = arg1_60
end

function var0_0.SetPosition(arg0_61, arg1_61)
	arg0_61.lady.position = arg1_61
end

function var0_0.SetRotation(arg0_62, arg1_62)
	arg0_62.lady.rotation = arg1_62
end

return var0_0
