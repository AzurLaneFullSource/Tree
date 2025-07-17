local var0_0 = class("LadyEnv")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.scene = arg1_1
end

function var0_0.InitCharacter(arg0_2, arg1_2)
	local var0_2 = arg0_2

	var0_2.lady = var0_2.ladyGameObject.transform

	var0_2.lady:SetParent(arg0_2.scene.mainCameraTF)
	var0_2.lady:SetParent(nil)

	var0_2.ladyHeadIKComp = var0_2.lady:GetComponent(typeof(HeadAimIK))
	var0_2.ladyHeadIKComp.AimTarget = arg0_2.scene.mainCameraTF:Find("AimTarget")
	var0_2.ladyHeadIKData = {
		DampTime = var0_2.ladyHeadIKComp.DampTime,
		blinkSpeed = var0_2.ladyHeadIKComp.blinkSpeed,
		BodyWeight = var0_2.ladyHeadIKComp.BodyWeight,
		HeadWeight = var0_2.ladyHeadIKComp.HeadWeight
	}

	local var1_2 = {}

	table.Foreach(DormConst.boneMap, function(arg0_3, arg1_3)
		var1_2[arg1_3] = arg0_3
	end)

	var0_2.ladyAnimator = var0_2.lady:GetComponent(typeof(Animator))
	var0_2.ladyAnimBaseLayerIndex = var0_2.ladyAnimator:GetLayerIndex("Base Layer")
	var0_2.ladyAnimFaceLayerIndex = var0_2.ladyAnimator:GetLayerIndex("Face")
	var0_2.ladyBoneMaps = {}

	local var2_2 = var0_2.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var2_2, function(arg0_4, arg1_4)
		if arg1_4.name == "BodyCollider" then
			var0_2.ladyCollider = arg1_4

			setActive(arg1_4, true)
		elseif arg1_4.name == "SafeCollider" then
			var0_2.ladySafeCollider = arg1_4

			setActive(arg1_4, false)
		elseif arg1_4.name == "Interest" then
			var0_2.ladyInterestRoot = arg1_4
		elseif arg1_4.name == "Head Center" then
			var0_2.ladyHeadCenter = arg1_4
		end

		if var1_2[arg1_4.name] then
			var0_2.ladyBoneMaps[var1_2[arg1_4.name]] = arg1_4
		end
	end)

	var0_2.ladyColliders = {}
	var0_2.ladyTouchColliders = {}

	table.IpairsCArray(var0_2.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_5, arg1_5)
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

		var0_2.ladyColliders[var3_5] = var0_5

		table.insert(var0_2.ladyTouchColliders, var0_5)
		setActive(var0_5, false)
	end)
	arg0_2.scene:HXCharacter(var0_2.lady)

	var0_2.clothComps = {}
	var0_2.ladyClothCompSettings = {}

	table.IpairsCArray(var0_2.lady:GetComponentsInChildren(typeof("MagicaCloth2.MagicaCloth"), true), function(arg0_6, arg1_6)
		table.insert(var0_2.clothComps, arg1_6)

		var0_2.ladyClothCompSettings[arg1_6] = {
			enabled = arg1_6.enabled
		}
	end)

	var0_2.clothColliderDict = {}
	var0_2.ladyClothColliderSettings = {}

	local var3_2 = typeof("MagicaCloth2.MagicaCapsuleCollider")

	table.IpairsCArray(var0_2.lady:GetComponentsInChildren(var3_2, true), function(arg0_7, arg1_7)
		local var0_7 = arg1_7:GetSize()

		var0_2.clothColliderDict[arg1_7.name] = arg1_7
		var0_2.ladyClothColliderSettings[arg1_7] = {
			enabled = arg1_7.enabled,
			StartRadius = var0_7.x,
			EndRadius = var0_7.y
		}
	end)
	var0_2:EnableCloth(false)

	var0_2.ladyIKRoot = var0_2.lady:Find("IKLayers")

	eachChild(var0_2.ladyIKRoot, function(arg0_8)
		setActive(arg0_8, false)
	end)
	GetComponent(var0_2.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_9, arg1_9)
		if arg1_9.rawPointerPress.transform == var0_2.ladyCollider then
			arg0_2.scene:emit(Dorm3dRoomTemplateScene.CLICK_CHARACTER, arg1_2)
		else
			local var0_9 = table.keyof(var0_2.IKSettings.Colliders, arg1_9.rawPointerPress.transform)

			arg0_2.scene:emit(Dorm3dRoomTemplateScene.ON_TOUCH_CHARACTER, var0_9 or arg1_9.rawPointerPress.name)
		end
	end)
	var0_2.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_10)
		if var0_2.nowState and arg0_10.animatorStateInfo:IsName(var0_2.nowState) then
			existCall(var0_2.stateCallback)

			return
		end

		local var0_10 = arg0_10.animatorStateInfo

		for iter0_10, iter1_10 in pairs(var0_2.animCallbacks) do
			if var0_10:IsName(iter0_10) then
				warning("Active", iter0_10)

				local var1_10 = table.removebykey(var0_2.animCallbacks, iter0_10)

				existCall(var1_10)

				return
			end
		end

		if arg0_10.stringParameter ~= "" then
			switch(arg0_10.stringParameter, var0_2.animExtraEvent, function()
				arg0_2.scene:OnAnimationEvent(arg0_10)
			end)
		end
	end)

	var0_2.animEventCallbacks = {}
	var0_2.animCallbacks = {}
	var0_2.animExtraEvent = {}

	local function var4_2(arg0_12, arg1_12, arg2_12)
		arg0_2.scene.loader:GetPrefab(arg0_12, arg1_12, function(arg0_13)
			arg0_13.name = arg2_12
			var0_2[arg2_12] = tf(arg0_13)

			setActive(arg0_13, false)
			onNextTick(function()
				setParent(var0_2[arg2_12], var0_2.ladyHeadCenter)
			end)
		end)
	end

	var0_2.effectHeart = var0_2.ladyHeadCenter:Find("effectHeart")

	if not var0_2.effectHeart then
		var4_2("dorm3d/effect/prefab/function/vfx_function_aixin02", "vfx_function_aixin02", "effectHeart")
	end

	var0_2.ladyWatchFloat = var0_2.ladyHeadCenter:Find("ladyWatchFloat")

	if not var0_2.ladyWatchFloat then
		var4_2("dorm3d/effect/prefab/scene/vfx_talk_mark", "vfx_talk_mark", "ladyWatchFloat")
	end

	if var0_2.tfPendintItem then
		onNextTick(function()
			setParent(var0_2.tfPendintItem, var0_2.lady)
		end)
	end

	var0_2.ladyOwner = GetComponent(var0_2.lady, "GraphOwner")
	var0_2.ladyBlackboard = GetComponent(var0_2.lady, "Blackboard")

	var0_2:SetBlackboardValue("groupId", arg1_2)
	onNextTick(function()
		var0_2.ladyOwner.enabled = true
	end)

	arg0_2.characterController = GetOrAddComponent(arg0_2.ladyGameObject, typeof(CharacterController))
	arg0_2.characterController.enabled = false
	arg0_2.characterController.center = Vector3(0, 0.78, 0)
	arg0_2.characterController.radius = 0.08
	arg0_2.characterController.height = 1.49
end

function var0_0.SwitchCharacterSkin(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17
	local var1_17 = var0_17.skinIdList

	assert(table.contains(var1_17, arg2_17))

	local var2_17 = arg0_17:GetCurrentAnim()
	local var3_17 = var0_17.skinId
	local var4_17 = arg0_17.scene.skinDict[var3_17].ladyGameObject
	local var5_17 = var4_17.transform.position
	local var6_17 = var4_17.transform.rotation
	local var7_17 = var0_17.ladyBlackboard

	setActive(var4_17, false)

	var0_17.skinId = arg2_17

	setActive(arg0_17.scene.skinDict[arg2_17].ladyGameObject, true)

	var0_17.ladyGameObject = arg0_17.scene.skinDict[arg2_17].ladyGameObject
	var0_17.ladyCollider = nil

	arg0_17:InitCharacter(arg1_17)
	pg.NodeCanvasMgr.GetInstance():CopyAllBlackBoardValue(var7_17, var0_17.ladyBlackboard)
	var0_17.ladyAnimator:Play(var2_17, var0_17.ladyAnimBaseLayerIndex)
	var0_17.ladyAnimator:Update(0)
	var0_17.lady:SetPositionAndRotation(var5_17, var6_17)
	existCall(arg3_17)
end

function var0_0.SetBlackboardValue(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18

	var0_18.blackboard = var0_18.blackboard or {}
	var0_18.blackboard[arg1_18] = arg2_18

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_18, arg2_18, var0_18.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_19, arg1_19)
	local var0_19 = arg0_19

	var0_19.blackboard = var0_19.blackboard or {}

	return var0_19.blackboard[arg1_19]
end

function var0_0.HideCharacterPart(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20
	local var1_20, var2_20 = Dorm3dSkin.New({
		configId = arg1_20
	}):GetActiveAndHiddenPartNames(arg2_20)

	if var0_20.lady == nil then
		var0_20.lady = var0_20.ladyGameObject.transform
	end

	_.each(var1_20, function(arg0_21)
		setActive(var0_20.lady:Find(arg0_21), true)
	end)
	_.each(var2_20, function(arg0_22)
		setActive(var0_20.lady:Find(arg0_22), false)
	end)
end

function var0_0.GetCurrentAnim(arg0_23)
	return arg0_23.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_23.ladyAnimBaseLayerIndex).shortNameHash
end

function var0_0.EnableCloth(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24

	arg1_24 = arg1_24 or {}

	table.Foreach(var0_24.clothComps, function(arg0_25, arg1_25)
		if arg1_25 == nil then
			return
		end

		setActive(arg1_25, arg1_24[arg0_25] == 1)
	end)
	table.Foreach(var0_24.clothColliderDict, function(arg0_26, arg1_26)
		if arg1_26 == nil then
			return
		end

		setActive(arg1_26, false)
	end)

	if arg2_24 then
		table.Foreach(arg2_24, function(arg0_27, arg1_27)
			local var0_27 = var0_24.clothColliderDict[arg1_27[1]]

			if var0_27 == nil then
				return
			end

			setActive(var0_27, arg1_27[2] == 1)

			if arg1_27[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_27, arg1_27[3], arg1_27[4])
		end)
	end
end

function var0_0.PlaySingleAction(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28

	warning("Play", arg1_28)

	local var1_28 = string.find(arg1_28, "^Face_")
	local var2_28 = tobool(var1_28)

	if not var2_28 then
		local var3_28 = string.find(arg1_28, "^face_")

		var2_28 = tobool(var3_28)
	end

	if var2_28 then
		arg0_28:PlayFaceAnim(arg1_28, arg2_28)

		return
	end

	if var0_28.ladyAnimator:GetCurrentAnimatorStateInfo(var0_28.ladyAnimBaseLayerIndex):IsName(arg1_28) then
		return
	end

	existCall(var0_28.animExtraItemCallback)

	var0_28.animExtraItemCallback = nil

	local var4_28 = arg0_28:GetBlackboardValue("groupId")
	local var5_28 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var4_28] or {}, function(arg0_29)
		return pg.dorm3d_anim_extraitem[arg0_29].anim == arg1_28
	end)
	local var6_28 = var5_28 and pg.dorm3d_anim_extraitem[var5_28]
	local var7_28

	seriesAsync({
		function(arg0_30)
			if not var6_28 or var6_28.item_prefab == "" then
				arg0_30()

				return
			end

			local var0_30 = string.lower("dorm3d/furniture/item/" .. var6_28.item_prefab)

			arg0_28.scene.loader:GetPrefab(var0_30, "", function(arg0_31)
				setParent(arg0_31, var0_28.lady)

				if var6_28.item_shield ~= "" then
					var7_28 = {}

					for iter0_31, iter1_31 in ipairs(var6_28.item_shield) do
						local var0_31 = arg0_28.scene.modelRoot:Find(iter1_31)

						if not var0_31 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var6_28.id, iter1_31))
						else
							var7_28[iter1_31] = isActive(var0_31)

							setActive(var0_31, false)
						end
					end
				end

				function var0_28.animExtraItemCallback()
					arg0_28.scene.loader:ClearRequest("AnimExtraItem")

					if var7_28 then
						for iter0_32, iter1_32 in pairs(var7_28) do
							setActive(arg0_28.scene.modelRoot:Find(iter0_32), iter1_32)
						end
					end
				end

				arg0_30()
			end, "AnimExtraItem")
		end,
		function(arg0_33)
			var0_28.nowState = arg1_28
			var0_28.stateCallback = arg0_33

			var0_28.ladyAnimator:CrossFadeInFixedTime(arg1_28, 0.25, var0_28.ladyAnimBaseLayerIndex)
		end,
		function(arg0_34)
			var0_28.nowState = nil
			var0_28.stateCallback = nil

			existCall(var0_28.animExtraItemCallback)

			var0_28.animExtraItemCallback = nil

			arg0_34()
		end,
		arg2_28
	})
end

function var0_0.PlayFaceAnim(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35

	var0_35.ladyAnimator:CrossFadeInFixedTime(arg1_35, 0, var0_35.ladyAnimFaceLayerIndex)
	existCall(arg2_35)
end

function var0_0.SwitchAnim(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36
	local var1_36 = string.find(arg1_36, "^Face_")

	if tobool(var1_36) then
		arg0_36:PlayFaceAnim(arg1_36, arg2_36)

		return
	end

	existCall(var0_36.animExtraItemCallback)

	var0_36.animExtraItemCallback = nil

	local var2_36 = {}

	table.insert(var2_36, function(arg0_37)
		var0_36.nowState = arg1_36
		var0_36.stateCallback = arg0_37

		var0_36.ladyAnimator:PlayInFixedTime(arg1_36, var0_36.ladyAnimBaseLayerIndex)
	end)
	table.insert(var2_36, function(arg0_38)
		var0_36.nowState = nil
		var0_36.stateCallback = nil

		arg0_38()
	end)
	seriesAsync(var2_36, arg2_36)
end

function var0_0.RegisterAnimExtraEvent(arg0_39, arg1_39, arg2_39)
	arg0_39.animExtraEvent[arg1_39] = arg2_39
end

function var0_0.RevertClothComps(arg0_40)
	local var0_40 = arg0_40

	table.Foreach(var0_40.ladyClothCompSettings, function(arg0_41, arg1_41)
		arg0_41.enabled = arg1_41.enabled
	end)
	table.Foreach(var0_40.ladyClothColliderSettings, function(arg0_42, arg1_42)
		arg0_42.enabled = arg1_42.enabled

		var0_0.SetMagicaCollider(arg0_42, arg1_42.StartRadius, arg1_42.EndRadius)
	end)
end

function var0_0.SetMagicaCollider(arg0_43, arg1_43, arg2_43)
	local var0_43 = typeof("MagicaCloth2.MagicaCapsuleCollider")
	local var1_43 = arg0_43:GetSize()

	var1_43.x = arg1_43
	var1_43.y = arg2_43

	arg0_43:SetSize(var1_43)
end

function var0_0.MoveToTarget(arg0_44, arg1_44)
	local var0_44 = arg1_44 - arg0_44.lady.position

	if var0_44 ~= Vector3.zero then
		local var1_44 = Quaternion.LookRotation(var0_44)

		arg0_44.lady.rotation = Quaternion.Slerp(arg0_44.lady.rotation, var1_44, Time.deltaTime * DormConst.LADY_ROTATE_SPEED)
	end

	local var2_44 = var0_44.normalized * DormConst.LADY_MOVE_SPEED

	arg0_44.characterController:Move(var2_44 * Time.deltaTime)
end

function var0_0.SetCurrentIkTimelineStatus(arg0_45, arg1_45)
	arg0_45.currentIkTimelineStatus = arg1_45
end

function var0_0.CheckIkTimelineStatus(arg0_46, arg1_46)
	if not arg0_46.currentIkTimelineStatus then
		return true
	end

	return arg0_46.currentIkTimelineStatus ~= arg1_46
end

return var0_0
