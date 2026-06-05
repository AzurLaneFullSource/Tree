local var0_0 = require("Framework.toLua.UnityEngine.Vector3")
local var1_0 = require("Framework.toLua.UnityEngine.Vector2")
local var2_0 = var0_0.zero
local var3_0 = class("IslandPlayerUnit", import(".IslandNavigableUnit"))
local var4_0 = 5
local var5_0 = 150
local var6_0 = var1_0(1.8, 1.8)
local var7_0 = var1_0(0, 2)
local var8_0 = LayerMask.NameToLayer("IgnoreIslandCharacter")
local var9_0 = bit.bnot(bit.lshift(1, var8_0))
local var10_0 = {
	LoadToolHandle = 2,
	JumpHandle = 1,
	NoMoveAndWork = 3,
	AttackHandle = 4
}

function var3_0.OnAttach(arg0_1, arg1_1)
	var3_0.super.OnAttach(arg0_1, arg1_1)

	arg0_1.mapId = getProxy(IslandProxy):GetIsland():GetMapId()
	arg0_1._tf = arg0_1._go.transform
	arg0_1.animator = arg0_1._tf:GetChild(0):GetComponent(typeof(Animator))
	arg0_1.characterController = arg0_1._go:GetComponent(typeof(CharacterController))
	arg0_1.characterHandleController = arg0_1._go:GetComponent(typeof(CharacterHandleController))

	local var0_1 = pg.island_set.detection_parameters.key_value_varchar

	var4_0 = var0_1[2]
	var5_0 = var0_1[1]
	var7_0 = var1_0(0, var0_1[3])

	arg0_1.characterHandleController:SetDrawParameter(var4_0, var5_0, var0_1[3])
	arg0_1.characterHandleController:AddStateEnterFunc(function(arg0_2, arg1_2)
		arg0_1:StateEnterHandle(arg0_2, arg1_2)
	end)
	arg0_1.characterHandleController:AddStateExitFunc(function(arg0_3, arg1_3)
		arg0_1:StateExitHandle(arg0_3, arg1_3)
	end)
	arg0_1.characterHandleController:AddStateEnterFixCompleteFunc(function(arg0_4, arg1_4)
		arg0_1:StateEnterFixHandle(arg0_4, arg1_4)
	end)
	arg0_1.characterHandleController:AddStateExitFixCompleteFunc(function(arg0_5, arg1_5)
		arg0_1:StateExitFixHandle(arg0_5, arg1_5)
	end)

	arg0_1.targetSpeed = 0
	arg0_1.speed = 0
	arg0_1.gravitySpeed = 0
	arg0_1.jumpVector = Vector3.zero

	local var1_1 = pg.island_set.player_movement_parameters.key_value_varchar

	arg0_1.degreeSpeed = 720
	arg0_1.maxSpeed = var1_1[1]
	arg0_1.sprintSpeed = var1_1[2]
	arg0_1.upSpeedDamping = 3
	arg0_1.downSpeedDamping = 6
	arg0_1.jumpHeight = var1_1[3]
	arg0_1.targetDir = Vector3.zero
	arg0_1.velocity = Vector3.zero
	arg0_1.extraVelocity = Vector3.zero
	arg0_1.isSitting = false
	arg0_1.prevStandPosition = nil
	arg0_1.checkInSet = {}
	arg0_1.lastCrossCount = 0
	arg0_1.orginTargetDir = var2_0

	arg0_1:InitDress()
	arg0_1:InitFarmCheckWorldObject()

	arg0_1.objTfList = {}
	arg0_1.toolIdMap = {}
	arg0_1.islandid = arg0_1:GetView():GetIsland().id
	arg0_1.isSelfIsland = getProxy(PlayerProxy):getRawData().id == arg0_1.islandid
end

function var3_0.InitJump(arg0_6, arg1_6)
	arg0_6.jumpCurve = arg1_6
	arg0_6.jumpCruveAllTime = arg0_6.jumpCurve.keys[arg0_6.jumpCurve.length - 1].time
end

function var3_0.OnLateUpdate(arg0_7)
	return
end

function var3_0.OnUpdate(arg0_8)
	arg0_8:RefreshTemp()

	local var0_8 = Time.deltaTime

	arg0_8:PositionTween(var0_8)
	arg0_8:Rotation(var0_8)
	arg0_8:Move(var0_8)
	arg0_8:Detectionobject()
end

function var3_0.RefreshTemp(arg0_9)
	arg0_9.ignoreStepdown = false
	arg0_9.gravityAcc = IslandConst.GRAVITYACC

	if arg0_9.orginTargetDir.x ~= 0 or arg0_9.orginTargetDir.z ~= 0 then
		local var0_9 = IslandCameraMgr.instance._mainCamera.transform:TransformVector(arg0_9.orginTargetDir)

		arg0_9.targetDir = var0_0(var0_9.x, 0, var0_9.z).normalized

		if arg0_9.targetDir ~= Vector3.zero then
			arg0_9.targetRotation = Quaternion.LookRotation(arg0_9.targetDir)
		end
	end
end

function var3_0.Rotation(arg0_10, arg1_10)
	if arg0_10.targetRotation then
		local var0_10 = Quaternion.RotateTowards(arg0_10._tf.rotation, arg0_10.targetRotation, arg0_10.degreeSpeed * arg1_10)

		arg0_10._tf.rotation = var0_10
	end
end

function var3_0.SetTargetRotation(arg0_11, arg1_11)
	arg0_11.targetRotation = arg1_11
end

function var3_0.Move(arg0_12, arg1_12)
	if Mathf.Approximately(arg0_12.speed, arg0_12.targetSpeed) then
		arg0_12.speed = arg0_12.targetSpeed
	elseif arg0_12.targetSpeed > arg0_12.speed then
		arg0_12.speed = Mathf.Lerp(arg0_12.speed, arg0_12.targetSpeed, arg0_12.upSpeedDamping * arg1_12)
	else
		arg0_12.speed = Mathf.Lerp(arg0_12.speed, arg0_12.targetSpeed, arg0_12.downSpeedDamping * arg1_12)
	end

	arg0_12.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_12.speed)

	arg0_12.velocity = arg0_12.targetDir * arg0_12.speed

	local var0_12 = arg0_12.gravityAcc * arg1_12

	arg0_12.gravitySpeed = arg0_12.gravitySpeed + var0_12
	arg0_12.onGroud = true

	local var1_12 = 0

	if arg0_12.gravitySpeed >= 0 then
		local var2_12, var3_12 = arg0_12:CalcGrounded()

		if var2_12 then
			arg0_12.gravitySpeed = 0
			var1_12 = var3_12
		else
			local var4_12, var5_12 = arg0_12:CalcNotFalling()

			if var4_12 then
				arg0_12.gravitySpeed = 0
				var1_12 = var5_12
			else
				arg0_12.onGroud = false
			end
		end
	else
		arg0_12.onGroud = false
	end

	arg0_12.animator:SetBool(IslandConst.GROUD_FLAG, arg0_12.onGroud)

	local var6_12 = Vector3(0, IslandConst.GRAVITYDIR.y * var1_12, 0)

	if arg0_12.ignoreStepdown then
		var6_12 = var2_0
	end

	local var7_12 = arg0_12.jumpVector + var6_12
	local var8_12 = Vector3(0, IslandConst.GRAVITYDIR.y * arg0_12.gravitySpeed, 0)

	arg0_12.characterController:Move((arg0_12.velocity + var8_12) * Time.deltaTime + var7_12 + arg0_12.extraVelocity * Time.deltaTime)
end

function var3_0.PositionTween(arg0_13, arg1_13)
	if arg0_13._positionTweenCom ~= nil then
		arg0_13._positionTweenCom.elapse = arg0_13._positionTweenCom.elapse + arg1_13

		local var0_13 = arg0_13.jumpCurve:Evaluate(arg0_13._positionTweenCom.elapse)
		local var1_13 = var0_13 - arg0_13._positionTweenCom.oldPosition

		arg0_13._positionTweenCom.oldPosition = var0_13

		local var2_13 = UnityEngine.Matrix4x4.TRS(arg0_13._tf.position, arg0_13._tf.rotation, Vector3.one):MultiplyVector(var0_0.New(0, var1_13, 0))

		arg0_13.gravityAcc = 0
		arg0_13.ignoreStepdown = true

		if arg0_13._positionTweenCom.elapse >= arg0_13._positionTweenCom.duration - 0.001 then
			arg0_13._positionTweenCom = nil
			arg0_13.gravitySpeed = Vector3.Dot(Vector3(0, -1, 0), var2_13) / arg1_13
			arg0_13.jumpVector = var2_0
		else
			arg0_13.jumpVector = var2_13
			arg0_13.gravitySpeed = 0
		end
	end
end

function var3_0.CalcGrounded(arg0_14)
	local var0_14, var1_14 = Physics.SphereCast(arg0_14._tf.position + arg0_14.characterController.center, arg0_14.characterController.radius, Vector3.down, nil, 2 * arg0_14.characterController.skinWidth + (0.5 * arg0_14.characterController.height - arg0_14.characterController.radius), var9_0)

	if var0_14 then
		local var2_14 = arg0_14._tf.position.y + arg0_14.characterController.skinWidth - var1_14.point.y

		if var1_14.collider.isTrigger then
			return true, 0
		end

		return true, var2_14
	end

	return false
end

function var3_0.CalcNotFalling(arg0_15)
	local var0_15, var1_15 = Physics.SphereCast(arg0_15._tf.position + arg0_15.characterController.center, arg0_15.characterController.radius, Vector3.down, nil, 0.3 + 2 * arg0_15.characterController.skinWidth + (0.5 * arg0_15.characterController.height - arg0_15.characterController.radius), var9_0)

	if var0_15 then
		local var2_15 = arg0_15._tf.position.y + arg0_15.characterController.skinWidth - var1_15.point.y

		if var1_15.collider.isTrigger then
			return false
		end

		return true, var2_15
	end

	return false
end

function var3_0.StandOnWorldObject(arg0_16)
	local var0_16, var1_16 = Physics.SphereCast(arg0_16._tf.position + arg0_16.characterController.center, arg0_16.characterController.radius * 1.2, Vector3.down, nil, 0.3 + 2 * arg0_16.characterController.skinWidth + (0.5 * arg0_16.characterController.height - arg0_16.characterController.radius), var9_0)

	if var0_16 then
		if var1_16.collider.isTrigger then
			return false
		end

		if var1_16.collider.gameObject:GetComponent(typeof(WorldObjectItem)) then
			return true
		end
	end

	return false
end

function var3_0.Sit(arg0_17, arg1_17, arg2_17)
	arg0_17.characterController.enabled = false
	arg0_17.prevStandPosition = arg0_17._tf.position
	arg0_17._tf.position = arg1_17

	local var0_17 = arg0_17._tf:Find("all/foot_l_d_mount")
	local var1_17 = Quaternion.LookRotation(arg2_17, Vector3.New(0, 1, 0))

	arg0_17._tf.rotation = var1_17

	arg0_17.animator:SetBool(IslandConst.SIT_HASH, true)

	arg0_17.isSitting = true
end

function var3_0.MoveHandle(arg0_18, arg1_18, arg2_18)
	if arg0_18.cantMove then
		return
	end

	if arg0_18.isSitting and arg0_18.prevStandPosition then
		arg0_18.characterController.enabled = true
		arg0_18._tf.position = arg0_18.prevStandPosition

		arg0_18.animator:SetBool(IslandConst.SIT_HASH, false)

		arg0_18.isSitting = false

		return
	end

	if arg0_18.animator then
		arg0_18.animator:SetFloat(IslandConst.INPUT_MAGNITUDE, arg2_18)
	end

	arg0_18.orginTargetDir = arg1_18
	arg0_18.lastTargetSpeed = arg2_18 * arg0_18.maxSpeed
	arg0_18.targetSpeed = arg0_18.isSprint and arg0_18.sprintSpeed or arg0_18.lastTargetSpeed
end

function var3_0.StopMoveHandle(arg0_19)
	arg0_19.targetSpeed = 0
	arg0_19.speed = 0

	arg0_19.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
	arg0_19.animator:SetFloat(IslandConst.INPUT_MAGNITUDE, 0)

	arg0_19.orginTargetDir = var2_0
	arg0_19.isSprint = false
end

function var3_0.StopMoveHandleByInput(arg0_20)
	arg0_20.targetSpeed = 0

	arg0_20.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
	arg0_20.animator:SetFloat(IslandConst.INPUT_MAGNITUDE, 0)

	arg0_20.orginTargetDir = var2_0
	arg0_20.isSprint = false
end

function var3_0.JumpHandle(arg0_21)
	if arg0_21.cantMove then
		return
	end

	if arg0_21:CheckCanJump() then
		arg0_21.animator:SetTrigger(IslandConst.JUMP_FLAG)
	end
end

function var3_0.WorkHandle(arg0_22, arg1_22, arg2_22)
	if arg0_22.cantMove then
		return
	end

	if arg2_22 then
		arg0_22.unitData = arg2_22

		local var0_22 = arg2_22.position - arg0_22:GetCurrentPosition()
		local var1_22 = var0_0(var0_22.x, 0, var0_22.z).normalized

		arg0_22.targetRotation = Quaternion.LookRotation(var1_22)
	end

	arg0_22.animator:SetTrigger(arg1_22)
end

function var3_0.DeviceStateHandle(arg0_23, arg1_23)
	if not arg0_23.animator then
		return
	end

	if arg0_23.view:GetController():IsPlayerInTimeline() then
		return
	end

	if arg1_23 then
		arg0_23.animator:SetTrigger(IslandConst.DEVICE_SHOW_FLAG)
		arg0_23.animator:ResetTrigger(IslandConst.UN_DEVICE_SHOW_FLAG)
	else
		arg0_23.animator:SetTrigger(IslandConst.UN_DEVICE_SHOW_FLAG)
	end
end

function var3_0.OnPlayerPlayerSprint(arg0_24)
	if arg0_24.targetSpeed ~= 0 then
		arg0_24.isSprint = true
		arg0_24.lastTargetSpeed = arg0_24.targetSpeed
		arg0_24.targetSpeed = arg0_24.sprintSpeed
		arg0_24.speed = arg0_24.targetSpeed
	end
end

function var3_0.OnStopPlayerSprint(arg0_25)
	if arg0_25.isSprint and arg0_25.targetSpeed ~= 0 then
		arg0_25.targetSpeed = arg0_25.lastTargetSpeed
		arg0_25.speed = arg0_25.lastTargetSpeed
		arg0_25.isSprint = false
	end
end

function var3_0.LoadInteractiveTool(arg0_26, arg1_26)
	if arg1_26 == 0 then
		arg0_26.toolId = arg0_26.unitData:GetToolId()
	else
		arg0_26.toolId = arg1_26
	end

	arg0_26.currentToolId = IslandAnimationAttachmentHelper.ResolveId(arg0_26.animator, arg0_26.toolId)
	arg0_26.toolIdMap[arg1_26] = arg0_26.currentToolId
	arg0_26.toolIdMap[arg0_26.toolId] = arg0_26.currentToolId

	local var0_26 = arg0_26.objTfList[arg0_26.currentToolId]

	if var0_26 then
		setActive(var0_26, true)
		setParent(var0_26, arg0_26._tf)
		pg.ViewUtils.SetLayer(var0_26, Layer.UIHidden)

		return
	end

	local var1_26 = pg.island_animation_attachments[arg0_26.currentToolId]
	local var2_26 = LoadAny(var1_26.model, nil)
	local var3_26 = Object.Instantiate(var2_26)

	arg0_26.objTfList[arg0_26.currentToolId] = var3_26.transform

	local var4_26 = LoadAny(var1_26.animator, nil, typeof(RuntimeAnimatorController))

	GetOrAddComponent(arg0_26.objTfList[arg0_26.currentToolId], typeof(Animator)).runtimeAnimatorController = var4_26

	setParent(arg0_26.objTfList[arg0_26.currentToolId], arg0_26._tf)
	pg.ViewUtils.SetLayer(arg0_26.objTfList[arg0_26.currentToolId], Layer.UIHidden)
end

function var3_0.UnLoadInteractiveTool(arg0_27, arg1_27)
	local var0_27 = arg0_27.toolIdMap[arg1_27] or arg0_27.currentToolId or IslandAnimationAttachmentHelper.ResolveId(arg0_27.animator, arg1_27)

	if arg0_27.objTfList[var0_27] then
		setActive(arg0_27.objTfList[var0_27], false)
	end
end

function var3_0.NoMoveHandle(arg0_28, arg1_28)
	arg0_28.cantMove = true

	if arg0_28.delayMoveTimer then
		arg0_28.delayMoveTimer:Stop()

		arg0_28.delayMoveTimer = nil
	end

	arg0_28.delayMoveTimer = Timer.New(function()
		arg0_28.cantMove = false
	end, arg1_28, 1)

	arg0_28.delayMoveTimer:Start()
end

function var3_0.AttackHandle(arg0_30, arg1_30)
	if arg0_30.delayAttackTimer then
		arg0_30.delayAttackTimer:Stop()

		arg0_30.delayAttackTimer = nil
	end

	arg0_30.delayAttackTimer = Timer.New(function()
		if arg0_30.unitData then
			arg0_30:NotifiyCore(ISLAND_EVT.Take_Plant_Attact, {
				type = arg0_30.unitData.unitType,
				id = arg0_30.unitData.id
			})
		end
	end, arg1_30, 1)

	arg0_30.delayAttackTimer:Start()
end

function var3_0.StateEnterHandle(arg0_32, arg1_32, arg2_32)
	if arg1_32 == var10_0.JumpHandle then
		arg0_32:OnEnterJumpState()
	elseif arg1_32 == var10_0.LoadToolHandle then
		arg0_32:LoadInteractiveTool(arg2_32)
	elseif arg1_32 == var10_0.NoMoveAndWork then
		arg0_32:NoMoveHandle(arg2_32)
	elseif arg1_32 == var10_0.AttackHandle then
		arg0_32:AttackHandle(arg2_32)
	end
end

function var3_0.StateEnterFixHandle(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.toolIdMap[arg2_33] or arg0_33.currentToolId

	if arg1_33 == var10_0.LoadToolHandle and var0_33 and arg0_33.objTfList[var0_33] then
		pg.ViewUtils.SetLayer(arg0_33.objTfList[var0_33], Layer.Default)
	end
end

function var3_0.StateExitFixHandle(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.toolIdMap[arg2_34] or arg0_34.currentToolId

	if arg1_34 == var10_0.LoadToolHandle and var0_34 and arg0_34.objTfList[var0_34] then
		pg.ViewUtils.SetLayer(arg0_34.objTfList[var0_34], Layer.UIHidden)
	end
end

function var3_0.StateExitHandle(arg0_35, arg1_35, arg2_35)
	if arg1_35 == var10_0.LoadToolHandle then
		arg0_35:UnLoadInteractiveTool(arg2_35)
	end
end

function var3_0.OnEnterJumpState(arg0_36)
	arg0_36._positionTweenCom = {
		elapse = 0,
		oldPosition = 0,
		duration = arg0_36.jumpCruveAllTime
	}
end

local var11_0 = var1_0(0, 0)

function var3_0.InitFarmCheckWorldObject(arg0_37)
	if not arg0_37:IsSpecialMap() then
		return
	end

	arg0_37.detectionList = {}

	for iter0_37, iter1_37 in ipairs(pg.island_production_place.get_id_list_by_map_id[arg0_37.mapId] or {}) do
		for iter2_37, iter3_37 in ipairs(pg.island_production_farm.get_id_list_by_place_id[iter1_37] or {}) do
			local var0_37 = pg.island_production_farm[iter3_37]
			local var1_37 = pg.island_world_objects[var0_37.objId]

			table.insert(arg0_37.detectionList, {
				id = var1_37.id,
				position = var1_37.param.position
			})
		end
	end
end

function var3_0.IsSpecialMap(arg0_38)
	return arg0_38.mapId == 1001 or arg0_38.mapId == 1005
end

function var3_0.IsSelf(arg0_39)
	return
end

function var3_0.Detectionobject(arg0_40)
	if not arg0_40:IsSpecialMap() or not arg0_40.isSelfIsland then
		return
	end

	local var0_40 = {}

	local function var1_40(arg0_41)
		local var0_41 = arg0_41.position[1]
		local var1_41 = arg0_41.position[3]
		local var2_41 = var6_0.x / 2
		local var3_41 = arg0_40._tf.position.x
		local var4_41 = arg0_40._tf.position.z
		local var5_41 = var4_0
		local var6_41 = math.max(var0_41 - var2_41, math.min(var3_41, var0_41 + var2_41))
		local var7_41 = math.max(var1_41 - var2_41, math.min(var4_41, var1_41 + var2_41))
		local var8_41 = var6_41 - var3_41
		local var9_41 = var7_41 - var4_41

		return var8_41 * var8_41 + var9_41 * var9_41 <= var5_41 * var5_41
	end

	for iter0_40, iter1_40 in ipairs(arg0_40.detectionList) do
		if arg0_40.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_40.id):CanCheckByPlayer() and var1_40(iter1_40) then
			table.insert(var0_40, iter1_40)
		end
	end

	local function var2_40(arg0_42, arg1_42, arg2_42)
		return (arg2_42.x - arg0_42.x) * (arg1_42.y - arg0_42.y) - (arg2_42.y - arg0_42.y) * (arg1_42.x - arg0_42.x)
	end

	local function var3_40(arg0_43, arg1_43, arg2_43)
		return Mathf.Min(arg0_43.x, arg1_43.x) <= arg2_43.x and arg2_43.x <= Mathf.Max(arg0_43.x, arg1_43.x) and Mathf.Min(arg0_43.y, arg1_43.y) <= arg2_43.y and arg2_43.y <= Mathf.Max(arg0_43.y, arg1_43.y)
	end

	local function var4_40(arg0_44, arg1_44)
		local var0_44 = #arg1_44

		for iter0_44 = 0, var0_44 do
			local var1_44 = arg1_44[iter0_44]
			local var2_44 = arg1_44[(iter0_44 + 1) % var0_44] - var1_44
			local var3_44 = arg0_44 - var1_44

			if var1_0.Dot(var2_44.normalized, var3_44) > 0 then
				return false
			end
		end

		return true
	end

	local function var5_40(arg0_45, arg1_45, arg2_45, arg3_45)
		local var0_45 = var2_40(arg2_45, arg3_45, arg0_45)
		local var1_45 = var2_40(arg2_45, arg3_45, arg1_45)
		local var2_45 = var2_40(arg0_45, arg1_45, arg2_45)
		local var3_45 = var2_40(arg0_45, arg1_45, arg3_45)

		if (var0_45 > 0 and var1_45 < 0 or var0_45 < 0 and var1_45 > 0) and (var2_45 > 0 and var3_45 < 0 or var2_45 < 0 and var3_45 > 0) then
			return true
		end

		if var0_45 == 0 and var3_40(arg2_45, arg3_45, arg0_45) then
			return true
		end

		if var1_45 == 0 and var3_40(arg2_45, arg3_45, arg1_45) then
			return true
		end

		if var2_45 == 0 and var3_40(arg0_45, arg1_45, arg2_45) then
			return true
		end

		if var3_45 == 0 and var3_40(arg0_45, arg1_45, arg3_45) then
			return true
		end

		return false
	end

	local function var6_40(arg0_46, arg1_46)
		local var0_46 = {}
		local var1_46 = arg1_46 * Mathf.Deg2Rad
		local var2_46 = Mathf.Cos(var1_46)
		local var3_46 = Mathf.Sin(var1_46)
		local var4_46 = var6_0 * 0.5

		var0_46[0] = arg0_46 + var1_0(-var4_46.x * var2_46 - var4_46.y * var3_46, -var4_46.x * var3_46 + var4_46.y * var2_46)
		var0_46[1] = arg0_46 + var1_0(var4_46.x * var2_46 - var4_46.y * var3_46, var4_46.x * var3_46 + var4_46.y * var2_46)
		var0_46[2] = arg0_46 + var1_0(var4_46.x * var2_46 + var4_46.y * var3_46, var4_46.x * var3_46 - var4_46.y * var2_46)
		var0_46[3] = arg0_46 + var1_0(-var4_46.x * var2_46 + var4_46.y * var3_46, -var4_46.x * var3_46 - var4_46.y * var2_46)

		return var0_46
	end

	local function var7_40(arg0_47, arg1_47, arg2_47, arg3_47)
		local var0_47 = var6_40(arg0_47, arg1_47)

		for iter0_47 = 0, 3 do
			local var1_47 = var0_47[iter0_47]
			local var2_47 = var0_47[(iter0_47 + 1) % 4]

			if var5_40(arg2_47, arg3_47, var1_47, var2_47) then
				return true
			end
		end

		if var4_40(arg2_47, var0_47) or var4_40(arg3_47, var0_47) then
			return true
		end

		return false
	end

	local function var8_40(arg0_48, arg1_48, arg2_48)
		local var0_48 = arg0_48 - arg2_48
		local var1_48 = var1_0.Dot(var0_48, arg1_48)
		local var2_48 = var1_0.Dot(var0_48, var1_0(-arg1_48.y, arg1_48.x))
		local var3_48 = var1_0(var1_48, var2_48)
		local var4_48 = var6_0 * 0.5
		local var5_48 = var1_0.Max(var3_48 - var1_0.zero, var1_0.zero - var3_48)
		local var6_48 = var1_0.Max(var5_48 - var4_48, var1_0.zero)
		local var7_48 = var1_0.Angle(var6_48, var1_0.right)
		local var8_48 = (180 - var5_0) / 2
		local var9_48 = var7_40(var5_48, 0, var1_0.zero, var1_0(var4_0 * Mathf.Cos(15 * Mathf.Deg2Rad), var4_0 * Mathf.Sin(15 * Mathf.Deg2Rad)))

		return var8_48 <= var7_48 or var9_48
	end

	local function var9_40(arg0_49)
		if var0_0.Dot(var0_0(arg0_49.position[1], arg0_49.position[2], arg0_49.position[3]) - arg0_40._tf.position, arg0_40._tf.forward) < 0 then
			return
		end

		local var0_49 = var1_0(arg0_49.position[1], arg0_49.position[3])
		local var1_49 = arg0_40:Vector3ToVector2(arg0_40._tf.position) + var11_0

		return var8_40(var0_49, arg0_40:Vector3ToVector2(arg0_40._tf.right), var1_49)
	end

	local var10_40 = {}

	for iter2_40, iter3_40 in ipairs(var0_40) do
		if var9_40(iter3_40) then
			table.insert(var10_40, iter3_40)
		end
	end

	local var11_40 = #var10_40
	local var12_40 = false

	if var11_40 ~= 0 then
		local var13_40
		local var14_40 = arg0_40:Vector3ToVector2(arg0_40._tf.position) + var11_0 + arg0_40:Vector3ToVector2(arg0_40._tf.forward) * 2
		local var15_40 = 10
		local var16_40 = {}

		for iter4_40, iter5_40 in ipairs(var10_40) do
			local var17_40 = (var1_0(iter5_40.position[1], iter5_40.position[3]) - var14_40):Magnitude()

			if var17_40 < var15_40 then
				var15_40 = var17_40
				var13_40 = iter5_40
			end
		end

		if var13_40 then
			itemId = var13_40.id

			if itemId ~= arg0_40.nearId then
				arg0_40.nearId = itemId
				arg0_40.nearItem = var13_40
				var12_40 = true
			end
		end
	end

	if var11_40 ~= arg0_40.lastCrossCount or var12_40 then
		arg0_40.lastCrossCount = var11_40

		if var11_40 == 0 then
			arg0_40:NotifiyCore(ISLAND_EVT.HIDE_UNIT_HUD_OP, {
				isHighLightControl = true,
				id = tonumber(arg0_40.nearId),
				type = IslandConst.UNIT_LIST_OBJ
			})

			arg0_40.nearId = 0
		else
			arg0_40:NotifiyCore(ISLAND_EVT.SHOW_UNIT_HUD_OP, {
				isHighLightControl = true,
				id = tonumber(arg0_40.nearId),
				operationType = IslandOpView.OperationType.Plant,
				type = IslandConst.UNIT_LIST_OBJ
			})
		end
	end
end

function var3_0.Vector3ToVector2(arg0_50, arg1_50)
	return var1_0(arg1_50.x, arg1_50.z)
end

function var3_0.GetNearItemId(arg0_51)
	return arg0_51.nearId
end

function var3_0.OnGrouded(arg0_52)
	return arg0_52.onGroud
end

function var3_0.GetCurrentPosition(arg0_53)
	return arg0_53._tf.position
end

function var3_0.LastGroundedPosition(arg0_54)
	local var0_54 = arg0_54._tf.eulerAngles

	if not arg0_54.onGroud then
		local var1_54, var2_54 = Physics.Raycast(arg0_54._tf.position, Vector3.down, nil, math.huge, var9_0)

		if var1_54 then
			return var2_54.point, var0_54
		end
	end

	return arg0_54._tf.position, var0_54
end

function var3_0.CheckCanJump(arg0_55)
	if arg0_55.onGroud then
		return true
	end

	if arg0_55.jumpVector.y > 0 then
		return false
	end

	local var0_55, var1_55 = Physics.Raycast(arg0_55._tf.position + arg0_55.characterController.center, Vector3.down, nil, 2, var9_0)

	if var0_55 then
		return true
	end

	return false
end

function var3_0.OnDetach(arg0_56)
	if arg0_56.delayMoveTimer then
		arg0_56.delayMoveTimer:Stop()

		arg0_56.delayMoveTimer = nil
	end

	if arg0_56.delayAttackTimer then
		arg0_56.delayAttackTimer:Stop()

		arg0_56.delayAttackTimer = nil
	end

	arg0_56:ClearAnimationTools()
	arg0_56.shipDressHelper:Destroy()
	arg0_56.characterHandleController:AddStateEnterFunc(nil)
	arg0_56.characterHandleController:AddStateExitFunc(nil)
end

function var3_0.ClearAnimationTools(arg0_57)
	for iter0_57, iter1_57 in pairs(arg0_57.objTfList) do
		Object.Destroy(iter1_57.gameObject)
	end

	arg0_57.objTfList = {}
end

function var3_0.SetActiveByLayer(arg0_58, arg1_58)
	if arg1_58 then
		pg.ViewUtils.SetLayer(arg0_58._tf, Layer.Default)
	else
		pg.ViewUtils.SetLayer(arg0_58._tf, Layer.UIHidden)
	end
end

function var3_0.SetShipDressHelper(arg0_59, arg1_59)
	arg0_59.shipDressHelper = arg1_59
end

function var3_0.OnChangeDress(arg0_60, arg1_60, arg2_60)
	local var0_60 = {}
	local var1_60 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

	local function var2_60(arg0_61)
		for iter0_61, iter1_61 in ipairs(arg2_60) do
			if arg0_61 == iter1_61.id then
				return iter1_61.color, true
			end
		end

		return var1_60:GetCurrentColorByDressId(arg0_61), false
	end

	for iter0_60, iter1_60 in ipairs(arg1_60) do
		local var3_60, var4_60 = var2_60(iter1_60.id)

		if var4_60 then
			var0_60[iter1_60.id] = true
		end

		arg0_60.shipDressHelper:ChangeDressByType(iter1_60.type, {
			id = iter1_60.id,
			colorId = var3_60
		})
	end

	for iter2_60, iter3_60 in ipairs(arg2_60) do
		local var5_60 = iter3_60.id

		if not var0_60[var5_60] then
			local var6_60 = pg.island_dress_template[var5_60].type

			arg0_60.shipDressHelper:ChangeCommanderPartColor(var6_60, iter3_60.color)
		end
	end
end

function var3_0.InitDress(arg0_62)
	return
end

return var3_0
