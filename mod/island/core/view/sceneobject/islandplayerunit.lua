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
			return false
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

function var3_0.Sit(arg0_16, arg1_16, arg2_16)
	arg0_16.characterController.enabled = false
	arg0_16.prevStandPosition = arg0_16._tf.position
	arg0_16._tf.position = arg1_16

	local var0_16 = arg0_16._tf:Find("all/foot_l_d_mount")
	local var1_16 = Quaternion.LookRotation(arg2_16, Vector3.New(0, 1, 0))

	arg0_16._tf.rotation = var1_16

	arg0_16.animator:SetBool(IslandConst.SIT_HASH, true)

	arg0_16.isSitting = true
end

function var3_0.MoveHandle(arg0_17, arg1_17, arg2_17)
	if arg0_17.cantMove then
		return
	end

	if arg0_17.isSitting and arg0_17.prevStandPosition then
		arg0_17.characterController.enabled = true
		arg0_17._tf.position = arg0_17.prevStandPosition

		arg0_17.animator:SetBool(IslandConst.SIT_HASH, false)

		arg0_17.isSitting = false

		return
	end

	if arg0_17.animator then
		arg0_17.animator:SetFloat(IslandConst.INPUT_MAGNITUDE, arg2_17)
	end

	arg0_17.orginTargetDir = arg1_17
	arg0_17.lastTargetSpeed = arg2_17 * arg0_17.maxSpeed
	arg0_17.targetSpeed = arg0_17.isSprint and arg0_17.sprintSpeed or arg0_17.lastTargetSpeed
end

function var3_0.StopMoveHandle(arg0_18)
	arg0_18.targetSpeed = 0
	arg0_18.speed = 0

	arg0_18.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
	arg0_18.animator:SetFloat(IslandConst.INPUT_MAGNITUDE, 0)

	arg0_18.orginTargetDir = var2_0
	arg0_18.isSprint = false
end

function var3_0.StopMoveHandleByInput(arg0_19)
	arg0_19.targetSpeed = 0

	arg0_19.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
	arg0_19.animator:SetFloat(IslandConst.INPUT_MAGNITUDE, 0)

	arg0_19.orginTargetDir = var2_0
	arg0_19.isSprint = false
end

function var3_0.JumpHandle(arg0_20)
	if arg0_20.cantMove then
		return
	end

	if arg0_20:CheckCanJump() then
		arg0_20.animator:SetTrigger(IslandConst.JUMP_FLAG)
	end
end

function var3_0.WorkHandle(arg0_21, arg1_21, arg2_21)
	if arg0_21.cantMove then
		return
	end

	if arg2_21 then
		arg0_21.unitData = arg2_21

		local var0_21 = arg2_21.position - arg0_21:GetCurrentPosition()
		local var1_21 = var0_0(var0_21.x, 0, var0_21.z).normalized

		arg0_21.targetRotation = Quaternion.LookRotation(var1_21)
	end

	arg0_21.animator:SetTrigger(arg1_21)
end

function var3_0.DeviceStateHandle(arg0_22, arg1_22)
	if not arg0_22.animator then
		return
	end

	if arg0_22.view:GetController():IsPlayerInTimeline() then
		return
	end

	if arg1_22 then
		arg0_22.animator:SetTrigger(IslandConst.DEVICE_SHOW_FLAG)
		arg0_22.animator:ResetTrigger(IslandConst.UN_DEVICE_SHOW_FLAG)
	else
		arg0_22.animator:SetTrigger(IslandConst.UN_DEVICE_SHOW_FLAG)
	end
end

function var3_0.OnPlayerPlayerSprint(arg0_23)
	if arg0_23.targetSpeed ~= 0 then
		arg0_23.isSprint = true
		arg0_23.lastTargetSpeed = arg0_23.targetSpeed
		arg0_23.targetSpeed = arg0_23.sprintSpeed
		arg0_23.speed = arg0_23.targetSpeed
	end
end

function var3_0.OnStopPlayerSprint(arg0_24)
	if arg0_24.isSprint and arg0_24.targetSpeed ~= 0 then
		arg0_24.targetSpeed = arg0_24.lastTargetSpeed
		arg0_24.speed = arg0_24.lastTargetSpeed
		arg0_24.isSprint = false
	end
end

function var3_0.LoadInteractiveTool(arg0_25, arg1_25)
	if arg1_25 == 0 then
		arg0_25.toolId = arg0_25.unitData:GetToolId()
	else
		arg0_25.toolId = arg1_25
	end

	local var0_25 = arg0_25.objTfList[arg0_25.toolId]

	if var0_25 then
		setActive(var0_25, true)
		setParent(var0_25, arg0_25._tf)
		pg.ViewUtils.SetLayer(var0_25, Layer.UIHidden)

		return
	end

	local var1_25 = pg.island_animation_attachments[arg0_25.toolId]
	local var2_25 = LoadAny(var1_25.model, nil)
	local var3_25 = Object.Instantiate(var2_25)

	arg0_25.objTfList[arg0_25.toolId] = var3_25.transform

	local var4_25 = LoadAny(var1_25.animator, nil, typeof(RuntimeAnimatorController))

	GetOrAddComponent(arg0_25.objTfList[arg0_25.toolId], typeof(Animator)).runtimeAnimatorController = var4_25

	setParent(arg0_25.objTfList[arg0_25.toolId], arg0_25._tf)
	pg.ViewUtils.SetLayer(arg0_25.objTfList[arg0_25.toolId], Layer.UIHidden)
end

function var3_0.UnLoadInteractiveTool(arg0_26)
	if arg0_26.objTfList[arg0_26.toolId] then
		setActive(arg0_26.objTfList[arg0_26.toolId], false)
	end
end

function var3_0.NoMoveHandle(arg0_27, arg1_27)
	arg0_27.cantMove = true

	if arg0_27.delayMoveTimer then
		arg0_27.delayMoveTimer:Stop()

		arg0_27.delayMoveTimer = nil
	end

	arg0_27.delayMoveTimer = Timer.New(function()
		arg0_27.cantMove = false
	end, arg1_27, 1)

	arg0_27.delayMoveTimer:Start()
end

function var3_0.AttackHandle(arg0_29, arg1_29)
	if arg0_29.delayAttackTimer then
		arg0_29.delayAttackTimer:Stop()

		arg0_29.delayAttackTimer = nil
	end

	arg0_29.delayAttackTimer = Timer.New(function()
		if arg0_29.unitData then
			arg0_29:NotifiyCore(ISLAND_EVT.Take_Plant_Attact, {
				type = arg0_29.unitData.unitType,
				id = arg0_29.unitData.id
			})
		end
	end, arg1_29, 1)

	arg0_29.delayAttackTimer:Start()
end

function var3_0.StateEnterHandle(arg0_31, arg1_31, arg2_31)
	if arg1_31 == var10_0.JumpHandle then
		arg0_31:OnEnterJumpState()
	elseif arg1_31 == var10_0.LoadToolHandle then
		arg0_31:LoadInteractiveTool(arg2_31)
	elseif arg1_31 == var10_0.NoMoveAndWork then
		arg0_31:NoMoveHandle(arg2_31)
	elseif arg1_31 == var10_0.AttackHandle then
		arg0_31:AttackHandle(arg2_31)
	end
end

function var3_0.StateEnterFixHandle(arg0_32, arg1_32, arg2_32)
	pg.ViewUtils.SetLayer(arg0_32.objTfList[arg0_32.toolId], Layer.Default)
end

function var3_0.StateExitFixHandle(arg0_33, arg1_33, arg2_33)
	pg.ViewUtils.SetLayer(arg0_33.objTfList[arg0_33.toolId], Layer.UIHidden)
end

function var3_0.StateExitHandle(arg0_34, arg1_34, arg2_34)
	if arg1_34 == var10_0.LoadToolHandle then
		arg0_34:UnLoadInteractiveTool(arg2_34)
	end
end

function var3_0.OnEnterJumpState(arg0_35)
	arg0_35._positionTweenCom = {
		elapse = 0,
		oldPosition = 0,
		duration = arg0_35.jumpCruveAllTime
	}
end

local var11_0 = var1_0(0, 0)

function var3_0.InitFarmCheckWorldObject(arg0_36)
	if not arg0_36:IsSpecialMap() then
		return
	end

	arg0_36.detectionList = {}

	for iter0_36, iter1_36 in ipairs(pg.island_production_place.get_id_list_by_map_id[arg0_36.mapId] or {}) do
		for iter2_36, iter3_36 in ipairs(pg.island_production_farm.get_id_list_by_place_id[iter1_36] or {}) do
			local var0_36 = pg.island_production_farm[iter3_36]
			local var1_36 = pg.island_world_objects[var0_36.objId]

			table.insert(arg0_36.detectionList, {
				id = var1_36.id,
				position = var1_36.param.position
			})
		end
	end
end

function var3_0.IsSpecialMap(arg0_37)
	return arg0_37.mapId == 1001 or arg0_37.mapId == 1005
end

function var3_0.IsSelf(arg0_38)
	return
end

function var3_0.Detectionobject(arg0_39)
	if not arg0_39:IsSpecialMap() or not arg0_39.isSelfIsland then
		return
	end

	local var0_39 = {}

	local function var1_39(arg0_40)
		local var0_40 = arg0_40.position[1]
		local var1_40 = arg0_40.position[3]
		local var2_40 = var6_0.x / 2
		local var3_40 = arg0_39._tf.position.x
		local var4_40 = arg0_39._tf.position.z
		local var5_40 = var4_0
		local var6_40 = math.max(var0_40 - var2_40, math.min(var3_40, var0_40 + var2_40))
		local var7_40 = math.max(var1_40 - var2_40, math.min(var4_40, var1_40 + var2_40))
		local var8_40 = var6_40 - var3_40
		local var9_40 = var7_40 - var4_40

		return var8_40 * var8_40 + var9_40 * var9_40 <= var5_40 * var5_40
	end

	for iter0_39, iter1_39 in ipairs(arg0_39.detectionList) do
		if arg0_39.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_39.id):CanCheckByPlayer() and var1_39(iter1_39) then
			table.insert(var0_39, iter1_39)
		end
	end

	local function var2_39(arg0_41, arg1_41, arg2_41)
		return (arg2_41.x - arg0_41.x) * (arg1_41.y - arg0_41.y) - (arg2_41.y - arg0_41.y) * (arg1_41.x - arg0_41.x)
	end

	local function var3_39(arg0_42, arg1_42, arg2_42)
		return Mathf.Min(arg0_42.x, arg1_42.x) <= arg2_42.x and arg2_42.x <= Mathf.Max(arg0_42.x, arg1_42.x) and Mathf.Min(arg0_42.y, arg1_42.y) <= arg2_42.y and arg2_42.y <= Mathf.Max(arg0_42.y, arg1_42.y)
	end

	local function var4_39(arg0_43, arg1_43)
		local var0_43 = #arg1_43

		for iter0_43 = 0, var0_43 do
			local var1_43 = arg1_43[iter0_43]
			local var2_43 = arg1_43[(iter0_43 + 1) % var0_43] - var1_43
			local var3_43 = arg0_43 - var1_43

			if var1_0.Dot(var2_43.normalized, var3_43) > 0 then
				return false
			end
		end

		return true
	end

	local function var5_39(arg0_44, arg1_44, arg2_44, arg3_44)
		local var0_44 = var2_39(arg2_44, arg3_44, arg0_44)
		local var1_44 = var2_39(arg2_44, arg3_44, arg1_44)
		local var2_44 = var2_39(arg0_44, arg1_44, arg2_44)
		local var3_44 = var2_39(arg0_44, arg1_44, arg3_44)

		if (var0_44 > 0 and var1_44 < 0 or var0_44 < 0 and var1_44 > 0) and (var2_44 > 0 and var3_44 < 0 or var2_44 < 0 and var3_44 > 0) then
			return true
		end

		if var0_44 == 0 and var3_39(arg2_44, arg3_44, arg0_44) then
			return true
		end

		if var1_44 == 0 and var3_39(arg2_44, arg3_44, arg1_44) then
			return true
		end

		if var2_44 == 0 and var3_39(arg0_44, arg1_44, arg2_44) then
			return true
		end

		if var3_44 == 0 and var3_39(arg0_44, arg1_44, arg3_44) then
			return true
		end

		return false
	end

	local function var6_39(arg0_45, arg1_45)
		local var0_45 = {}
		local var1_45 = arg1_45 * Mathf.Deg2Rad
		local var2_45 = Mathf.Cos(var1_45)
		local var3_45 = Mathf.Sin(var1_45)
		local var4_45 = var6_0 * 0.5

		var0_45[0] = arg0_45 + var1_0(-var4_45.x * var2_45 - var4_45.y * var3_45, -var4_45.x * var3_45 + var4_45.y * var2_45)
		var0_45[1] = arg0_45 + var1_0(var4_45.x * var2_45 - var4_45.y * var3_45, var4_45.x * var3_45 + var4_45.y * var2_45)
		var0_45[2] = arg0_45 + var1_0(var4_45.x * var2_45 + var4_45.y * var3_45, var4_45.x * var3_45 - var4_45.y * var2_45)
		var0_45[3] = arg0_45 + var1_0(-var4_45.x * var2_45 + var4_45.y * var3_45, -var4_45.x * var3_45 - var4_45.y * var2_45)

		return var0_45
	end

	local function var7_39(arg0_46, arg1_46, arg2_46, arg3_46)
		local var0_46 = var6_39(arg0_46, arg1_46)

		for iter0_46 = 0, 3 do
			local var1_46 = var0_46[iter0_46]
			local var2_46 = var0_46[(iter0_46 + 1) % 4]

			if var5_39(arg2_46, arg3_46, var1_46, var2_46) then
				return true
			end
		end

		if var4_39(arg2_46, var0_46) or var4_39(arg3_46, var0_46) then
			return true
		end

		return false
	end

	local function var8_39(arg0_47, arg1_47, arg2_47)
		local var0_47 = arg0_47 - arg2_47
		local var1_47 = var1_0.Dot(var0_47, arg1_47)
		local var2_47 = var1_0.Dot(var0_47, var1_0(-arg1_47.y, arg1_47.x))
		local var3_47 = var1_0(var1_47, var2_47)
		local var4_47 = var6_0 * 0.5
		local var5_47 = var1_0.Max(var3_47 - var1_0.zero, var1_0.zero - var3_47)
		local var6_47 = var1_0.Max(var5_47 - var4_47, var1_0.zero)
		local var7_47 = var1_0.Angle(var6_47, var1_0.right)
		local var8_47 = (180 - var5_0) / 2
		local var9_47 = var7_39(var5_47, 0, var1_0.zero, var1_0(var4_0 * Mathf.Cos(15 * Mathf.Deg2Rad), var4_0 * Mathf.Sin(15 * Mathf.Deg2Rad)))

		return var8_47 <= var7_47 or var9_47
	end

	local function var9_39(arg0_48)
		if var0_0.Dot(var0_0(arg0_48.position[1], arg0_48.position[2], arg0_48.position[3]) - arg0_39._tf.position, arg0_39._tf.forward) < 0 then
			return
		end

		local var0_48 = var1_0(arg0_48.position[1], arg0_48.position[3])
		local var1_48 = arg0_39:Vector3ToVector2(arg0_39._tf.position) + var11_0

		return var8_39(var0_48, arg0_39:Vector3ToVector2(arg0_39._tf.right), var1_48)
	end

	local var10_39 = {}

	for iter2_39, iter3_39 in ipairs(var0_39) do
		if var9_39(iter3_39) then
			table.insert(var10_39, iter3_39)
		end
	end

	local var11_39 = #var10_39
	local var12_39 = false

	if var11_39 ~= 0 then
		local var13_39
		local var14_39 = arg0_39:Vector3ToVector2(arg0_39._tf.position) + var11_0 + arg0_39:Vector3ToVector2(arg0_39._tf.forward) * 2
		local var15_39 = 10
		local var16_39 = {}

		for iter4_39, iter5_39 in ipairs(var10_39) do
			local var17_39 = (var1_0(iter5_39.position[1], iter5_39.position[3]) - var14_39):Magnitude()

			if var17_39 < var15_39 then
				var15_39 = var17_39
				var13_39 = iter5_39
			end
		end

		if var13_39 then
			itemId = var13_39.id

			if itemId ~= arg0_39.nearId then
				arg0_39.nearId = itemId
				arg0_39.nearItem = var13_39
				var12_39 = true
			end
		end
	end

	if var11_39 ~= arg0_39.lastCrossCount or var12_39 then
		arg0_39.lastCrossCount = var11_39

		if var11_39 == 0 then
			arg0_39:NotifiyCore(ISLAND_EVT.HIDE_UNIT_HUD_OP, {
				isHighLightControl = true,
				id = tonumber(arg0_39.nearId),
				type = IslandConst.UNIT_LIST_OBJ
			})

			arg0_39.nearId = 0
		else
			arg0_39:NotifiyCore(ISLAND_EVT.SHOW_UNIT_HUD_OP, {
				isHighLightControl = true,
				id = tonumber(arg0_39.nearId),
				operationType = IslandOpView.OperationType.Plant,
				type = IslandConst.UNIT_LIST_OBJ
			})
		end
	end
end

function var3_0.Vector3ToVector2(arg0_49, arg1_49)
	return var1_0(arg1_49.x, arg1_49.z)
end

function var3_0.GetNearItemId(arg0_50)
	return arg0_50.nearId
end

function var3_0.GetCurrentPosition(arg0_51)
	return arg0_51._tf.position
end

function var3_0.LastGroundedPosition(arg0_52)
	local var0_52 = arg0_52._tf.eulerAngles

	if not arg0_52.onGroud then
		local var1_52, var2_52 = Physics.Raycast(arg0_52._tf.position, Vector3.down, nil, math.huge, var9_0)

		if var1_52 then
			return var2_52.point, var0_52
		end
	end

	return arg0_52._tf.position, var0_52
end

function var3_0.CheckCanJump(arg0_53)
	if arg0_53.onGroud then
		return true
	end

	if arg0_53.jumpVector.y > 0 then
		return false
	end

	local var0_53, var1_53 = Physics.Raycast(arg0_53._tf.position + arg0_53.characterController.center, Vector3.down, nil, 2, var9_0)

	if var0_53 then
		return true
	end

	return false
end

function var3_0.OnDetach(arg0_54)
	if arg0_54.delayMoveTimer then
		arg0_54.delayMoveTimer:Stop()

		arg0_54.delayMoveTimer = nil
	end

	if arg0_54.delayAttackTimer then
		arg0_54.delayAttackTimer:Stop()

		arg0_54.delayAttackTimer = nil
	end

	arg0_54:ClearAnimationTools()
	arg0_54.shipDressHelper:Destroy()
	arg0_54.characterHandleController:AddStateEnterFunc(nil)
	arg0_54.characterHandleController:AddStateExitFunc(nil)
end

function var3_0.ClearAnimationTools(arg0_55)
	for iter0_55, iter1_55 in pairs(arg0_55.objTfList) do
		Object.Destroy(iter1_55.gameObject)
	end

	arg0_55.objTfList = {}
end

function var3_0.SetActiveByLayer(arg0_56, arg1_56)
	if arg1_56 then
		pg.ViewUtils.SetLayer(arg0_56._tf, Layer.Default)
	else
		pg.ViewUtils.SetLayer(arg0_56._tf, Layer.UIHidden)
	end
end

function var3_0.SetShipDressHelper(arg0_57, arg1_57)
	arg0_57.shipDressHelper = arg1_57
end

function var3_0.OnChangeDress(arg0_58, arg1_58, arg2_58)
	local var0_58 = {}
	local var1_58 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

	local function var2_58(arg0_59)
		for iter0_59, iter1_59 in ipairs(arg2_58) do
			if arg0_59 == iter1_59.id then
				return iter1_59.color, true
			end
		end

		return var1_58:GetCurrentColorByDressId(arg0_59), false
	end

	for iter0_58, iter1_58 in ipairs(arg1_58) do
		local var3_58, var4_58 = var2_58(iter1_58.id)

		if var4_58 then
			var0_58[iter1_58.id] = true
		end

		arg0_58.shipDressHelper:ChangeDressByType(iter1_58.type, {
			id = iter1_58.id,
			colorId = var3_58
		})
	end

	for iter2_58, iter3_58 in ipairs(arg2_58) do
		local var5_58 = iter3_58.id

		if not var0_58[var5_58] then
			local var6_58 = pg.island_dress_template[var5_58].type

			arg0_58.shipDressHelper:ChangeCommanderPartColor(var6_58, iter3_58.color)
		end
	end
end

function var3_0.InitDress(arg0_60)
	return
end

return var3_0
