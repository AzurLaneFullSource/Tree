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
		arg0_9.targetRotation = Quaternion.LookRotation(arg0_9.targetDir)
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

		return true, var2_14
	end

	return false
end

function var3_0.CalcNotFalling(arg0_15)
	local var0_15, var1_15 = Physics.SphereCast(arg0_15._tf.position + arg0_15.characterController.center, arg0_15.characterController.radius, Vector3.down, nil, 0.3 + 2 * arg0_15.characterController.skinWidth + (0.5 * arg0_15.characterController.height - arg0_15.characterController.radius), var9_0)

	if var0_15 then
		local var2_15 = arg0_15._tf.position.y + arg0_15.characterController.skinWidth - var1_15.point.y

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

function var3_0.JumpHandle(arg0_19)
	if arg0_19.cantMove then
		return
	end

	if arg0_19:CheckCanJump() then
		arg0_19.animator:SetTrigger(IslandConst.JUMP_FLAG)
	end
end

function var3_0.WorkHandle(arg0_20, arg1_20, arg2_20)
	if arg0_20.cantMove then
		return
	end

	if arg2_20 then
		arg0_20.unitData = arg2_20

		local var0_20 = arg2_20.position - arg0_20:GetCurrentPosition()
		local var1_20 = var0_0(var0_20.x, 0, var0_20.z).normalized

		arg0_20.targetRotation = Quaternion.LookRotation(var1_20)
	end

	arg0_20.animator:SetTrigger(arg1_20)
end

function var3_0.DeviceStateHandle(arg0_21, arg1_21)
	if not arg0_21.animator then
		return
	end

	if arg1_21 then
		arg0_21.animator:SetTrigger(IslandConst.DEVICE_SHOW_FLAG)
	else
		arg0_21.animator:SetTrigger(IslandConst.UN_DEVICE_SHOW_FLAG)
	end
end

function var3_0.OnPlayerPlayerSprint(arg0_22)
	if arg0_22.targetSpeed ~= 0 then
		arg0_22.isSprint = true
		arg0_22.lastTargetSpeed = arg0_22.targetSpeed
		arg0_22.targetSpeed = arg0_22.sprintSpeed
		arg0_22.speed = arg0_22.targetSpeed
	end
end

function var3_0.OnStopPlayerSprint(arg0_23)
	if arg0_23.isSprint and arg0_23.targetSpeed ~= 0 then
		arg0_23.targetSpeed = arg0_23.lastTargetSpeed
		arg0_23.speed = arg0_23.lastTargetSpeed
		arg0_23.isSprint = false
	end
end

function var3_0.LoadInteractiveTool(arg0_24, arg1_24)
	if arg1_24 == 0 then
		arg0_24.toolId = arg0_24.unitData:GetToolId()
	else
		arg0_24.toolId = arg1_24
	end

	local var0_24 = arg0_24.objTfList[arg0_24.toolId]

	if var0_24 then
		setActive(var0_24, true)
		setParent(var0_24, arg0_24._tf)
		pg.ViewUtils.SetLayer(var0_24, Layer.UIHidden)

		return
	end

	local var1_24 = pg.island_animation_attachments[arg0_24.toolId]
	local var2_24 = LoadAny(var1_24.model, nil)
	local var3_24 = Object.Instantiate(var2_24)

	arg0_24.objTfList[arg0_24.toolId] = var3_24.transform

	local var4_24 = LoadAny(var1_24.animator, nil, typeof(RuntimeAnimatorController))

	GetOrAddComponent(arg0_24.objTfList[arg0_24.toolId], typeof(Animator)).runtimeAnimatorController = var4_24

	setParent(arg0_24.objTfList[arg0_24.toolId], arg0_24._tf)
	pg.ViewUtils.SetLayer(arg0_24.objTfList[arg0_24.toolId], Layer.UIHidden)
end

function var3_0.UnLoadInteractiveTool(arg0_25)
	if arg0_25.objTfList[arg0_25.toolId] then
		setActive(arg0_25.objTfList[arg0_25.toolId], false)
	end
end

function var3_0.NoMoveHandle(arg0_26, arg1_26)
	arg0_26.cantMove = true

	if arg0_26.delayMoveTimer then
		arg0_26.delayMoveTimer:Stop()

		arg0_26.delayMoveTimer = nil
	end

	arg0_26.delayMoveTimer = Timer.New(function()
		arg0_26.cantMove = false
	end, arg1_26, 1)

	arg0_26.delayMoveTimer:Start()
end

function var3_0.AttackHandle(arg0_28, arg1_28)
	if arg0_28.delayAttackTimer then
		arg0_28.delayAttackTimer:Stop()

		arg0_28.delayAttackTimer = nil
	end

	arg0_28.delayAttackTimer = Timer.New(function()
		if arg0_28.unitData then
			arg0_28:NotifiyCore(ISLAND_EVT.Take_Plant_Attact, {
				type = arg0_28.unitData.unitType,
				id = arg0_28.unitData.id
			})
		end
	end, arg1_28, 1)

	arg0_28.delayAttackTimer:Start()
end

function var3_0.StateEnterHandle(arg0_30, arg1_30, arg2_30)
	if arg1_30 == var10_0.JumpHandle then
		arg0_30:OnEnterJumpState()
	elseif arg1_30 == var10_0.LoadToolHandle then
		arg0_30:LoadInteractiveTool(arg2_30)
	elseif arg1_30 == var10_0.NoMoveAndWork then
		arg0_30:NoMoveHandle(arg2_30)
	elseif arg1_30 == var10_0.AttackHandle then
		arg0_30:AttackHandle(arg2_30)
	end
end

function var3_0.StateEnterFixHandle(arg0_31, arg1_31, arg2_31)
	pg.ViewUtils.SetLayer(arg0_31.objTfList[arg0_31.toolId], Layer.Default)
end

function var3_0.StateExitFixHandle(arg0_32, arg1_32, arg2_32)
	pg.ViewUtils.SetLayer(arg0_32.objTfList[arg0_32.toolId], Layer.UIHidden)
end

function var3_0.StateExitHandle(arg0_33, arg1_33, arg2_33)
	if arg1_33 == var10_0.LoadToolHandle then
		arg0_33:UnLoadInteractiveTool(arg2_33)
	end
end

function var3_0.OnEnterJumpState(arg0_34)
	arg0_34._positionTweenCom = {
		elapse = 0,
		oldPosition = 0,
		duration = arg0_34.jumpCruveAllTime
	}
end

local var11_0 = var1_0(0, 0)

function var3_0.InitFarmCheckWorldObject(arg0_35)
	if not arg0_35:IsSpecialMap() then
		return
	end

	arg0_35.detectionList = {}

	for iter0_35, iter1_35 in ipairs(pg.island_production_place.get_id_list_by_map_id[arg0_35.mapId] or {}) do
		for iter2_35, iter3_35 in ipairs(pg.island_production_farm.get_id_list_by_place_id[iter1_35] or {}) do
			local var0_35 = pg.island_production_farm[iter3_35]
			local var1_35 = pg.island_world_objects[var0_35.objId]

			table.insert(arg0_35.detectionList, {
				id = var1_35.id,
				position = var1_35.param.position
			})
		end
	end
end

function var3_0.IsSpecialMap(arg0_36)
	return arg0_36.mapId == 1001 or arg0_36.mapId == 1005
end

function var3_0.IsSelf(arg0_37)
	return
end

function var3_0.Detectionobject(arg0_38)
	if not arg0_38:IsSpecialMap() or not arg0_38.isSelfIsland then
		return
	end

	local var0_38 = {}

	local function var1_38(arg0_39)
		local var0_39 = arg0_39.position[1]
		local var1_39 = arg0_39.position[3]
		local var2_39 = var6_0.x / 2
		local var3_39 = arg0_38._tf.position.x
		local var4_39 = arg0_38._tf.position.z
		local var5_39 = var4_0
		local var6_39 = math.max(var0_39 - var2_39, math.min(var3_39, var0_39 + var2_39))
		local var7_39 = math.max(var1_39 - var2_39, math.min(var4_39, var1_39 + var2_39))
		local var8_39 = var6_39 - var3_39
		local var9_39 = var7_39 - var4_39

		return var8_39 * var8_39 + var9_39 * var9_39 <= var5_39 * var5_39
	end

	for iter0_38, iter1_38 in ipairs(arg0_38.detectionList) do
		if arg0_38.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_38.id):CanCheckByPlayer() and var1_38(iter1_38) then
			table.insert(var0_38, iter1_38)
		end
	end

	local function var2_38(arg0_40, arg1_40, arg2_40)
		return (arg2_40.x - arg0_40.x) * (arg1_40.y - arg0_40.y) - (arg2_40.y - arg0_40.y) * (arg1_40.x - arg0_40.x)
	end

	local function var3_38(arg0_41, arg1_41, arg2_41)
		return Mathf.Min(arg0_41.x, arg1_41.x) <= arg2_41.x and arg2_41.x <= Mathf.Max(arg0_41.x, arg1_41.x) and Mathf.Min(arg0_41.y, arg1_41.y) <= arg2_41.y and arg2_41.y <= Mathf.Max(arg0_41.y, arg1_41.y)
	end

	local function var4_38(arg0_42, arg1_42)
		local var0_42 = #arg1_42

		for iter0_42 = 0, var0_42 do
			local var1_42 = arg1_42[iter0_42]
			local var2_42 = arg1_42[(iter0_42 + 1) % var0_42] - var1_42
			local var3_42 = arg0_42 - var1_42

			if var1_0.Dot(var2_42.normalized, var3_42) > 0 then
				return false
			end
		end

		return true
	end

	local function var5_38(arg0_43, arg1_43, arg2_43, arg3_43)
		local var0_43 = var2_38(arg2_43, arg3_43, arg0_43)
		local var1_43 = var2_38(arg2_43, arg3_43, arg1_43)
		local var2_43 = var2_38(arg0_43, arg1_43, arg2_43)
		local var3_43 = var2_38(arg0_43, arg1_43, arg3_43)

		if (var0_43 > 0 and var1_43 < 0 or var0_43 < 0 and var1_43 > 0) and (var2_43 > 0 and var3_43 < 0 or var2_43 < 0 and var3_43 > 0) then
			return true
		end

		if var0_43 == 0 and var3_38(arg2_43, arg3_43, arg0_43) then
			return true
		end

		if var1_43 == 0 and var3_38(arg2_43, arg3_43, arg1_43) then
			return true
		end

		if var2_43 == 0 and var3_38(arg0_43, arg1_43, arg2_43) then
			return true
		end

		if var3_43 == 0 and var3_38(arg0_43, arg1_43, arg3_43) then
			return true
		end

		return false
	end

	local function var6_38(arg0_44, arg1_44)
		local var0_44 = {}
		local var1_44 = arg1_44 * Mathf.Deg2Rad
		local var2_44 = Mathf.Cos(var1_44)
		local var3_44 = Mathf.Sin(var1_44)
		local var4_44 = var6_0 * 0.5

		var0_44[0] = arg0_44 + var1_0(-var4_44.x * var2_44 - var4_44.y * var3_44, -var4_44.x * var3_44 + var4_44.y * var2_44)
		var0_44[1] = arg0_44 + var1_0(var4_44.x * var2_44 - var4_44.y * var3_44, var4_44.x * var3_44 + var4_44.y * var2_44)
		var0_44[2] = arg0_44 + var1_0(var4_44.x * var2_44 + var4_44.y * var3_44, var4_44.x * var3_44 - var4_44.y * var2_44)
		var0_44[3] = arg0_44 + var1_0(-var4_44.x * var2_44 + var4_44.y * var3_44, -var4_44.x * var3_44 - var4_44.y * var2_44)

		return var0_44
	end

	local function var7_38(arg0_45, arg1_45, arg2_45, arg3_45)
		local var0_45 = var6_38(arg0_45, arg1_45)

		for iter0_45 = 0, 3 do
			local var1_45 = var0_45[iter0_45]
			local var2_45 = var0_45[(iter0_45 + 1) % 4]

			if var5_38(arg2_45, arg3_45, var1_45, var2_45) then
				return true
			end
		end

		if var4_38(arg2_45, var0_45) or var4_38(arg3_45, var0_45) then
			return true
		end

		return false
	end

	local function var8_38(arg0_46, arg1_46, arg2_46)
		local var0_46 = arg0_46 - arg2_46
		local var1_46 = var1_0.Dot(var0_46, arg1_46)
		local var2_46 = var1_0.Dot(var0_46, var1_0(-arg1_46.y, arg1_46.x))
		local var3_46 = var1_0(var1_46, var2_46)
		local var4_46 = var6_0 * 0.5
		local var5_46 = var1_0.Max(var3_46 - var1_0.zero, var1_0.zero - var3_46)
		local var6_46 = var1_0.Max(var5_46 - var4_46, var1_0.zero)
		local var7_46 = var1_0.Angle(var6_46, var1_0.right)
		local var8_46 = (180 - var5_0) / 2
		local var9_46 = var7_38(var5_46, 0, var1_0.zero, var1_0(var4_0 * Mathf.Cos(15 * Mathf.Deg2Rad), var4_0 * Mathf.Sin(15 * Mathf.Deg2Rad)))

		return var8_46 <= var7_46 or var9_46
	end

	local function var9_38(arg0_47)
		if var0_0.Dot(var0_0(arg0_47.position[1], arg0_47.position[2], arg0_47.position[3]) - arg0_38._tf.position, arg0_38._tf.forward) < 0 then
			return
		end

		local var0_47 = var1_0(arg0_47.position[1], arg0_47.position[3])
		local var1_47 = arg0_38:Vector3ToVector2(arg0_38._tf.position) + var11_0

		return var8_38(var0_47, arg0_38:Vector3ToVector2(arg0_38._tf.right), var1_47)
	end

	local var10_38 = {}

	for iter2_38, iter3_38 in ipairs(var0_38) do
		if var9_38(iter3_38) then
			table.insert(var10_38, iter3_38)
		end
	end

	local var11_38 = #var10_38
	local var12_38 = false

	if var11_38 ~= 0 then
		local var13_38
		local var14_38 = arg0_38:Vector3ToVector2(arg0_38._tf.position) + var11_0 + arg0_38:Vector3ToVector2(arg0_38._tf.forward) * 2
		local var15_38 = 10
		local var16_38 = {}

		for iter4_38, iter5_38 in ipairs(var10_38) do
			local var17_38 = (var1_0(iter5_38.position[1], iter5_38.position[3]) - var14_38):Magnitude()

			if var17_38 < var15_38 then
				var15_38 = var17_38
				var13_38 = iter5_38
			end
		end

		if var13_38 then
			itemId = var13_38.id

			if itemId ~= arg0_38.nearId then
				arg0_38.nearId = itemId
				arg0_38.nearItem = var13_38
				var12_38 = true
			end
		end
	end

	if var11_38 ~= arg0_38.lastCrossCount or var12_38 then
		arg0_38.lastCrossCount = var11_38

		if var11_38 == 0 then
			arg0_38:NotifiyCore(ISLAND_EVT.HIDE_UNIT_HUD_OP, {
				isHighLightControl = true,
				id = tonumber(arg0_38.nearId),
				type = IslandConst.UNIT_LIST_OBJ
			})

			arg0_38.nearId = 0
		else
			arg0_38:NotifiyCore(ISLAND_EVT.SHOW_UNIT_HUD_OP, {
				isHighLightControl = true,
				id = tonumber(arg0_38.nearId),
				operationType = IslandOpView.OperationType.Plant,
				type = IslandConst.UNIT_LIST_OBJ
			})
		end
	end
end

function var3_0.Vector3ToVector2(arg0_48, arg1_48)
	return var1_0(arg1_48.x, arg1_48.z)
end

function var3_0.GetNearItemId(arg0_49)
	return arg0_49.nearId
end

function var3_0.GetCurrentPosition(arg0_50)
	return arg0_50._tf.position
end

function var3_0.LastGroundedPosition(arg0_51)
	local var0_51 = arg0_51._tf.eulerAngles

	if not arg0_51.onGroud then
		local var1_51, var2_51 = Physics.Raycast(arg0_51._tf.position, Vector3.down, nil, math.huge, var9_0)

		if var1_51 then
			return var2_51.point, var0_51
		end
	end

	return arg0_51._tf.position, var0_51
end

function var3_0.CheckCanJump(arg0_52)
	if arg0_52.onGroud then
		return true
	end

	if arg0_52.jumpVector.y > 0 then
		return false
	end

	local var0_52, var1_52 = Physics.Raycast(arg0_52._tf.position + arg0_52.characterController.center, Vector3.down, nil, 2, var9_0)

	if var0_52 then
		return true
	end

	return false
end

function var3_0.OnDetach(arg0_53)
	if arg0_53.delayMoveTimer then
		arg0_53.delayMoveTimer:Stop()

		arg0_53.delayMoveTimer = nil
	end

	if arg0_53.delayAttackTimer then
		arg0_53.delayAttackTimer:Stop()

		arg0_53.delayAttackTimer = nil
	end

	arg0_53:ClearAnimationTools()
	arg0_53.shipDressHelper:Destroy()
	arg0_53.characterHandleController:AddStateEnterFunc(nil)
	arg0_53.characterHandleController:AddStateExitFunc(nil)
end

function var3_0.ClearAnimationTools(arg0_54)
	for iter0_54, iter1_54 in pairs(arg0_54.objTfList) do
		Object.Destroy(iter1_54.gameObject)
	end

	arg0_54.objTfList = {}
end

function var3_0.SetActiveByLayer(arg0_55, arg1_55)
	if arg1_55 then
		pg.ViewUtils.SetLayer(arg0_55._tf, Layer.Default)
	else
		pg.ViewUtils.SetLayer(arg0_55._tf, Layer.UIHidden)
	end
end

function var3_0.SetShipDressHelper(arg0_56, arg1_56)
	arg0_56.shipDressHelper = arg1_56
end

function var3_0.OnChangeDress(arg0_57, arg1_57, arg2_57)
	local var0_57 = {}
	local var1_57 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

	local function var2_57(arg0_58)
		for iter0_58, iter1_58 in ipairs(arg2_57) do
			if arg0_58 == iter1_58.id then
				return iter1_58.color, true
			end
		end

		return var1_57:GetCurrentColorByDressId(arg0_58), false
	end

	for iter0_57, iter1_57 in ipairs(arg1_57) do
		local var3_57, var4_57 = var2_57(iter1_57.id)

		if var4_57 then
			var0_57[iter1_57.id] = true
		end

		arg0_57.shipDressHelper:ChangeDressByType(iter1_57.type, {
			id = iter1_57.id,
			colorId = var3_57
		})
	end

	for iter2_57, iter3_57 in ipairs(arg2_57) do
		local var5_57 = iter3_57.id

		if not var0_57[var5_57] then
			local var6_57 = pg.island_dress_template[var5_57].type

			arg0_57.shipDressHelper:ChangeCommanderPartColor(var6_57, iter3_57.color)
		end
	end
end

function var3_0.InitDress(arg0_59)
	return
end

return var3_0
