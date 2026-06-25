local var0_0 = class("CarWashLadySystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.UPDATE_PHASE2_TIPS = "CarWashLadySystem.UPDATE_PHASE2_TIPS"
var0_0.UPDATE_EXPRESSION_HUD_POSITION = "CarWashLadySystem.UPDATE_EXPRESSION_HUD_POSITION"
var0_0.PLAY_PHASE2_REACTION = "CarWashLadySystem.PLAY_PHASE2_REACTION"

function var0_0.OnInit(arg0_1)
	arg0_1:InitSceneRefs()
	arg0_1:InitLady()

	arg0_1.hitForce = 0
	arg0_1.gunType = nil
	arg0_1.hiddenReactionHitTime = 0
	arg0_1.hiddenReactionConfigId = nil
	arg0_1.hiddenReactionTriggered = false
	arg0_1.reactionAnim = nil
	arg0_1.reactionCallback = nil
	arg0_1.waitingReactionReturnIdle = false
	arg0_1.reactionLeftIdle = false
	arg0_1.gameState = nil
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_LADY_POS, function(arg0_3, arg1_3)
		arg0_2:OnLadyPosChanged(arg1_3.newValue)
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_CURRENT_GUN_TYPE, function(arg0_4, arg1_4)
		arg0_2.gunType = arg1_4.newValue
		arg0_2.hitForce = CarWashConst.GetGunConfig(arg1_4.newValue).force

		arg0_2:ResetHiddenReactionState()
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_IS_SHOOTING, function(arg0_5, arg1_5)
		if not arg1_5.newValue then
			arg0_2:ResetHiddenReactionState()
		end
	end)
	arg0_2:Bind(CarWashRaycastSystem.UPDATE_COMMON_RAYCAST, function(arg0_6, arg1_6)
		arg0_2:OnCommonRaycast(arg1_6)
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_7, arg1_7)
		arg0_2.gameState = arg1_7.newValue
	end)
	arg0_2:Bind(var0_0.PLAY_PHASE2_REACTION, function(arg0_8, arg1_8)
		arg0_2:OnPlayPhase2Reaction(arg1_8)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN, function()
		pg.ViewUtils.SetLayer(arg0_2.ladyTransform, Layer.UIHidden)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function()
		pg.ViewUtils.SetLayer(arg0_2.ladyTransform, Layer.Character3D)
		pg.ViewUtils.SetLayer(arg0_2.physicsCollider, Layer.CameraRT)
	end)
end

function var0_0.OnDispose(arg0_11)
	arg0_11.hiddenReactionHitTime = nil
	arg0_11.hiddenReactionConfigId = nil
	arg0_11.hiddenReactionTriggered = nil
	arg0_11.reactionAnim = nil
	arg0_11.reactionCallback = nil
	arg0_11.waitingReactionReturnIdle = nil
	arg0_11.reactionLeftIdle = nil
	arg0_11.gameState = nil
	arg0_11.colliderMap = nil
end

function var0_0.OnUpdate(arg0_12, arg1_12)
	arg0_12:UpdateReactionState()
	arg0_12:UpdateExpressionHUDPosition()
	arg0_12:UpdatePhase2Tips()
end

function var0_0.InitSceneRefs(arg0_13)
	arg0_13.ladyPositionRoot = GameObject.Find("[LADYPOSITION]").transform
	arg0_13.ladyGO = arg0_13:GetLadyGO()
	arg0_13.mainCamera = arg0_13:GetMainCamera()
	arg0_13.mainCameraTF = arg0_13:GetMainCameraTF()
end

function var0_0.InitLady(arg0_14)
	arg0_14.ladyTransform = arg0_14.ladyGO.transform
	arg0_14.ladyAnimator = arg0_14.ladyGO:GetComponent(typeof(Animator))
	arg0_14.ladyAnimBaseLayerIndex = arg0_14.ladyAnimator:GetLayerIndex("Base Layer")
	arg0_14.ladyAnimFaceLayerIndex = arg0_14.ladyAnimator:GetLayerIndex("Face")
	arg0_14.physicsCollider = arg0_14.ladyTransform:Find("physicsCollider")

	pg.ViewUtils.SetLayer(arg0_14.ladyTransform, Layer.Character3D)
	pg.ViewUtils.SetLayer(arg0_14.physicsCollider, Layer.CameraRT)

	arg0_14.ladyOwner = GetComponent(arg0_14.ladyTransform, "GraphOwner")
	arg0_14.ladyOwner.enabled = false
	arg0_14.hitReactionLayers = arg0_14.ladyTransform:Find("CarWashHitReactionLayers")
	arg0_14.commonIK = arg0_14.hitReactionLayers:Find("CommonIK")

	setActive(arg0_14.commonIK, true)
	eachChild(arg0_14.commonIK, function(arg0_15)
		setActive(arg0_15, false)
	end)

	arg0_14.boneBip001 = arg0_14.ladyTransform:Find("all/Bip001")
	arg0_14.boneHUD = arg0_14.ladyTransform:Find("all/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Spine2/Bip001 Spine3/Bip001 Neck/Bip001 Head/ExpressionHUD")

	assert(arg0_14.boneHUD, "CarWash ExpressionHUD bone not found")
	arg0_14:InitColliderMap()
end

function var0_0.InitColliderMap(arg0_16)
	arg0_16.colliderMap = {}

	local var0_16 = arg0_16.ladyGO:GetComponentsInChildren(typeof(UnityEngine.Collider), true):ToTable()

	for iter0_16, iter1_16 in ipairs(var0_16) do
		arg0_16.colliderMap[iter1_16.gameObject.name] = iter1_16
	end
end

function var0_0.UpdateExpressionHUDPosition(arg0_17)
	local var0_17 = arg0_17.mainCamera:WorldToScreenPoint(arg0_17.boneHUD.position)

	arg0_17:Emit(var0_0.UPDATE_EXPRESSION_HUD_POSITION, {
		screenPosition = var0_17,
		visible = var0_17.z > 0
	})
end

function var0_0.OnLadyPosChanged(arg0_18, arg1_18)
	arg0_18:ResetHiddenReactionState()
	arg0_18:ResetReactionState()

	arg0_18.posConfig = arg1_18

	local var0_18 = arg0_18.ladyPositionRoot:Find(arg0_18.posConfig.pos)

	assert(var0_18, "CarWash lady position node not found: " .. arg0_18.posConfig.pos)
	setParent(arg0_18.ladyTransform, var0_18)
	arg0_18:PlayAnim(arg0_18.posConfig.idle_anim, 0)

	if arg0_18.hitReactionTF and arg0_18.hitReactionComp then
		setActive(arg0_18.hitReactionTF, false)

		arg0_18.hitReactionComp = nil
	end

	if arg0_18.posConfig.hit_reaction_layer and arg0_18.posConfig.hit_reaction_layer ~= "" then
		arg0_18.hitReactionTF = arg0_18.commonIK:Find(arg0_18.posConfig.hit_reaction_layer)
		arg0_18.hitReactionComp = arg0_18.hitReactionTF:GetComponent(typeof(BLHXHitReaction))

		setActive(arg0_18.hitReactionTF, true)
	end

	arg0_18.animConfig = _.map(arg0_18.posConfig.fury_anim, function(arg0_19)
		return pg.dorm3d_carwash_animation[arg0_19]
	end)
end

function var0_0.OnCommonRaycast(arg0_20, arg1_20)
	if not arg1_20.hit then
		arg0_20:ResetHiddenReactionState()

		return
	end

	local var0_20 = arg1_20.hitInfo

	if var0_20.collider.gameObject.layer ~= CarWashConst.LADY_LAYER then
		arg0_20:ResetHiddenReactionState()

		return
	end

	local var1_20 = arg0_20:GetCharacterHitConfig(var0_20.collider.gameObject.name)

	if arg0_20:TryHandleHiddenReaction(var1_20, arg1_20.deltaTime or Time.deltaTime) then
		return
	end

	arg0_20:OnCharacterHit(var0_20, arg1_20.muzzleRay or arg1_20.ray, var1_20)
end

function var0_0.GetCharacterHitConfig(arg0_21, arg1_21)
	if not arg0_21.animConfig then
		return nil
	end

	return _.detect(arg0_21.animConfig, function(arg0_22)
		return _.any(arg0_22.collider, function(arg0_23)
			return arg0_23 == arg1_21
		end) and _.any(arg0_22.gun_type, function(arg0_24)
			return arg0_24 == arg0_21.gunType
		end)
	end)
end

function var0_0.OnCharacterHit(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = arg1_25.collider.gameObject.name

	arg3_25 = arg3_25 or arg0_25:GetCharacterHitConfig(var0_25)

	if arg3_25 and arg0_25:CanTriggerReactionAnim() then
		local var1_25 = arg0_25:GetTriggerAnim(arg3_25)

		if var1_25 ~= "" then
			arg0_25:PlayReactionAnim(var1_25, function()
				arg0_25:Emit(CarWashGameFlowSystem.MODIFY_HEART_BEAT_VALUE, arg3_25.mood_value_plus)
				arg0_25:Emit(CarWashMainPage.SHOW_EXPRESSION_HUD, CarWashMainPage.EXPRESSION_TYPE.LIKE)
			end)

			return
		end
	end

	if arg0_25.hitReactionComp then
		arg0_25.hitReactionComp:Hit(arg1_25.collider, arg2_25.direction * arg0_25.hitForce, arg1_25.point)
	end
end

function var0_0.IsMainCameraOnLeftSide(arg0_27)
	local var0_27 = arg0_27.boneBip001.up
	local var1_27 = arg0_27.mainCameraTF.position - arg0_27.boneBip001.position

	warning(Vector3.Dot(var1_27, var0_27) > 0 and "Camera is on the left side" or "Camera is on the right side")

	return Vector3.Dot(var1_27, var0_27) > 0
end

function var0_0.UpdatePhase2Tips(arg0_28)
	if arg0_28.gameState ~= CarWashConst.GAME_STATE.PHASE_2 then
		return
	end

	if not arg0_28.posConfig then
		return
	end

	arg0_28:Emit(var0_0.UPDATE_PHASE2_TIPS, arg0_28:GetPhase2TipInfos())
end

function var0_0.GetPhase2TipInfos(arg0_29)
	assert(arg0_29.posConfig.fury_anim and #arg0_29.posConfig.fury_anim > 0, "CarWash phase2 fury_anim config is empty: " .. tostring(arg0_29.posConfig.id))

	local var0_29 = {}

	for iter0_29, iter1_29 in ipairs(arg0_29.posConfig.fury_anim) do
		local var1_29 = pg.dorm3d_carwash_animation[iter1_29]

		assert(var1_29, "CarWash phase2 animation config not found: " .. tostring(iter1_29))
		assert(var1_29.collider and var1_29.collider[1], "CarWash phase2 animation collider config is empty: " .. tostring(iter1_29))

		local var2_29 = var1_29.collider[1]
		local var3_29 = arg0_29.colliderMap[var2_29]

		assert(var3_29, "CarWash phase2 collider not found: " .. tostring(var2_29))

		local var4_29 = arg0_29.mainCamera:WorldToScreenPoint(var3_29.bounds.center)

		table.insert(var0_29, {
			index = iter0_29,
			animId = iter1_29,
			colliderName = var2_29,
			screenPosition = var4_29,
			visible = var4_29.z > 0 and arg0_29:CanTriggerReactionAnim()
		})
	end

	return var0_29
end

function var0_0.OnPlayPhase2Reaction(arg0_30, arg1_30)
	assert(arg1_30, "CarWash phase2 reaction data is nil")

	local var0_30 = arg1_30.animId
	local var1_30 = pg.dorm3d_carwash_animation[var0_30]

	assert(var1_30, "CarWash phase2 animation config not found: " .. tostring(var0_30))

	local var2_30 = arg0_30:GetTriggerAnim(var1_30)

	assert(var2_30 ~= "", "CarWash phase2 reaction animation not found: " .. tostring(var0_30))
	warning("Play phase2 reaction anim: " .. var2_30)
	arg0_30:PlayReactionAnim(var2_30, function()
		existCall(arg1_30.callback, true)
	end)
end

function var0_0.TryHandleHiddenReaction(arg0_32, arg1_32, arg2_32)
	if not arg0_32:IsHiddenReactionConditionMet(arg1_32) then
		arg0_32:ResetHiddenReactionState()

		return false
	end

	local var0_32 = arg1_32.id or arg1_32

	if arg0_32.hiddenReactionConfigId ~= var0_32 then
		arg0_32.hiddenReactionConfigId = var0_32
		arg0_32.hiddenReactionHitTime = 0
		arg0_32.hiddenReactionTriggered = false

		arg0_32:Emit(CarWashMainPage.SHOW_EXPRESSION_HUD, CarWashMainPage.EXPRESSION_TYPE.HATE)
	end

	if arg0_32.hiddenReactionTriggered then
		return true
	end

	arg0_32.hiddenReactionHitTime = arg0_32.hiddenReactionHitTime + arg2_32

	if arg0_32.hiddenReactionHitTime >= CarWashConst.HIDDEN_REACTION_TRIGGER_TIME then
		arg0_32.hiddenReactionTriggered = true

		arg0_32:TriggerHiddenReaction(arg1_32)
	end

	return true
end

function var0_0.IsHiddenReactionConditionMet(arg0_33, arg1_33)
	return arg1_33 and arg1_33.hidden_reaction ~= "" and arg0_33:IsInState(arg0_33.posConfig.idle_anim)
end

function var0_0.TriggerHiddenReaction(arg0_34, arg1_34)
	arg0_34:Emit(CarWashGameFlowSystem.TRIGGER_HIDDEN_REACTION, arg1_34)
end

function var0_0.ResetHiddenReactionState(arg0_35)
	arg0_35.hiddenReactionHitTime = 0
	arg0_35.hiddenReactionConfigId = nil
	arg0_35.hiddenReactionTriggered = false
end

function var0_0.CanTriggerReactionAnim(arg0_36)
	return not arg0_36.waitingReactionReturnIdle and arg0_36:IsAnimatorStableInIdle()
end

function var0_0.GetTriggerAnim(arg0_37, arg1_37)
	if arg1_37.anim ~= "" then
		return arg1_37.anim
	end

	if arg1_37.anim_l ~= "" and arg1_37.anim_r ~= "" then
		if arg0_37:IsMainCameraOnLeftSide() then
			return arg1_37.anim_l
		else
			return arg1_37.anim_r
		end
	end

	return ""
end

function var0_0.PlayReactionAnim(arg0_38, arg1_38, arg2_38)
	arg0_38.reactionAnim = arg1_38
	arg0_38.reactionCallback = arg2_38
	arg0_38.waitingReactionReturnIdle = true
	arg0_38.reactionLeftIdle = false

	arg0_38:PlayAnim(arg1_38)
end

function var0_0.UpdateReactionState(arg0_39)
	if not arg0_39.waitingReactionReturnIdle then
		return
	end

	if not arg0_39.reactionLeftIdle then
		arg0_39.reactionLeftIdle = not arg0_39:IsAnimatorStableInIdle()

		return
	end

	if not arg0_39:IsAnimatorStableInIdle() then
		return
	end

	local var0_39 = arg0_39.reactionCallback

	arg0_39:ResetReactionState()
	existCall(var0_39)
end

function var0_0.IsAnimatorStableInIdle(arg0_40)
	if not arg0_40.posConfig then
		return false
	end

	if arg0_40.ladyAnimator:IsInTransition(arg0_40.ladyAnimBaseLayerIndex) then
		return false
	end

	return arg0_40:IsInState(arg0_40.posConfig.idle_anim)
end

function var0_0.ResetReactionState(arg0_41)
	arg0_41.reactionAnim = nil
	arg0_41.reactionCallback = nil
	arg0_41.waitingReactionReturnIdle = false
	arg0_41.reactionLeftIdle = false
end

function var0_0.IsInState(arg0_42, arg1_42)
	return arg0_42.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_42.ladyAnimBaseLayerIndex):IsName(arg1_42)
end

function var0_0.PlayAnim(arg0_43, arg1_43, arg2_43)
	arg2_43 = arg2_43 or 0.5

	local var0_43 = string.find(arg1_43, "^Face_")
	local var1_43 = tobool(var0_43)

	if not var1_43 then
		local var2_43 = string.find(arg1_43, "^face_")

		var1_43 = tobool(var2_43)
	end

	if var1_43 then
		arg0_43:PlayFaceAnim(arg1_43)

		return
	end

	if arg0_43:IsInState(arg1_43) then
		return
	end

	if IsUnityEditor and not arg0_43.ladyAnimator:HasState(arg0_43.ladyAnimBaseLayerIndex, Animator.StringToHash(arg1_43)) then
		errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_43)
	end

	arg0_43.ladyAnimator:CrossFadeInFixedTime(arg1_43, arg2_43, arg0_43.ladyAnimBaseLayerIndex)
end

function var0_0.PlayFaceAnim(arg0_44, arg1_44)
	if IsUnityEditor and not arg0_44.ladyAnimator:HasState(arg0_44.ladyAnimFaceLayerIndex, Animator.StringToHash(arg1_44)) then
		errorMsg("！！！！！！！！动画不存在>>>>>>>>>>>>>", arg1_44)
	end

	arg0_44.ladyAnimator:CrossFadeInFixedTime(arg1_44, 0, arg0_44.ladyAnimFaceLayerIndex)
end

return var0_0
