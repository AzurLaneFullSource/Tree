local var0_0 = require("Framework.toLua.UnityEngine.Vector3")
local var1_0 = require("Framework.toLua.UnityEngine.Vector2")
local var2_0 = var0_0.zero
local var3_0 = class("IslandPlayerUnit", import(".IslandNavigableUnit"))
local var4_0 = 5
local var5_0 = 150
local var6_0 = var1_0(1.8, 1.8)
local var7_0 = var1_0(0, 2)

function var3_0.OnInit(arg0_1)
	arg0_1.jumpCurve = LoadAny("island/jumpcurve/jumpcurve", "", typeof(JumpCurve)).curve
	arg0_1.jumpCruveAllTime = arg0_1.jumpCurve.keys[arg0_1.jumpCurve.length - 1].time
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
	arg0_1.characterHandleController:AddStateEnterFunc(function(arg0_2)
		arg0_1:StateEnterHandle(arg0_2)
	end)
	arg0_1.characterHandleController:AddStateExitFunc(function(arg0_3)
		arg0_1:StateExitHandle(arg0_3)
	end)

	arg0_1.targetSpeed = 0
	arg0_1.speed = 0
	arg0_1.targetRotation = Quaternion.identity
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
	arg0_1.orginTargetDir = var2_0
	arg0_1.pageDressDic = {}

	arg0_1:InitMapCheckWorldObject()
end

function var3_0.OnLateUpdate(arg0_4)
	if arg0_4.jumpTrigger then
		arg0_4.animator:ResetTrigger(IslandConst.JUMP_FLAG)
	end

	if arg0_4.runTrigger then
		arg0_4.animator:ResetTrigger(IslandConst.RUN_FLAG)
	end
end

function var3_0.OnUpdate(arg0_5)
	arg0_5:RefreshTemp()

	local var0_5 = Time.deltaTime

	arg0_5:PositionTween(var0_5)
	arg0_5:Rotation(var0_5)
	arg0_5:Move(var0_5)
	arg0_5:Detectionobject()
	arg0_5:Handle()
end

function var3_0.RefreshTemp(arg0_6)
	arg0_6.ignoreStepdown = false
	arg0_6.gravityAcc = IslandConst.GRAVITYACC

	if arg0_6.orginTargetDir.x ~= 0 or arg0_6.orginTargetDir.z ~= 0 then
		local var0_6 = IslandCameraMgr.instance._mainCamera.transform:TransformVector(arg0_6.orginTargetDir)

		arg0_6.targetDir = var0_0(var0_6.x, 0, var0_6.z).normalized
		arg0_6.targetRotation = Quaternion.LookRotation(arg0_6.targetDir)
	end
end

function var3_0.Rotation(arg0_7, arg1_7)
	local var0_7 = Quaternion.RotateTowards(arg0_7._tf.rotation, arg0_7.targetRotation, arg0_7.degreeSpeed * arg1_7)

	arg0_7._tf.rotation = var0_7
end

function var3_0.Move(arg0_8, arg1_8)
	if Mathf.Approximately(arg0_8.speed, arg0_8.targetSpeed) then
		arg0_8.speed = arg0_8.targetSpeed
	elseif arg0_8.targetSpeed > arg0_8.speed then
		arg0_8.speed = Mathf.Lerp(arg0_8.speed, arg0_8.targetSpeed, arg0_8.upSpeedDamping * arg1_8)
	else
		arg0_8.speed = Mathf.Lerp(arg0_8.speed, arg0_8.targetSpeed, arg0_8.downSpeedDamping * arg1_8)
	end

	arg0_8.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_8.speed)

	arg0_8.velocity = arg0_8.targetDir * arg0_8.speed

	local var0_8 = arg0_8.gravityAcc * arg1_8

	arg0_8.gravitySpeed = arg0_8.gravitySpeed + var0_8
	arg0_8.onGroud = true

	local var1_8 = 0

	if arg0_8.gravitySpeed >= 0 then
		local var2_8, var3_8 = arg0_8:CalcGrounded()

		if var2_8 then
			arg0_8.gravitySpeed = 0
			var1_8 = var3_8
		else
			local var4_8, var5_8 = arg0_8:CalcNotFalling()

			if var4_8 then
				arg0_8.gravitySpeed = 0
				var1_8 = var5_8
			else
				arg0_8.onGroud = false
			end
		end
	else
		arg0_8.onGroud = false
	end

	arg0_8.animator:SetBool(IslandConst.GROUD_FLAG, arg0_8.onGroud)

	local var6_8 = Vector3(0, IslandConst.GRAVITYDIR.y * var1_8, 0)

	if arg0_8.ignoreStepdown then
		var6_8 = var2_0
	end

	local var7_8 = arg0_8.jumpVector + var6_8
	local var8_8 = Vector3(0, IslandConst.GRAVITYDIR.y * arg0_8.gravitySpeed, 0)

	arg0_8.characterController:Move((arg0_8.velocity + var8_8) * Time.deltaTime + var7_8 + arg0_8.extraVelocity * Time.deltaTime)
end

function var3_0.PositionTween(arg0_9, arg1_9)
	if arg0_9._positionTweenCom ~= nil then
		arg0_9._positionTweenCom.elapse = arg0_9._positionTweenCom.elapse + arg1_9

		local var0_9 = arg0_9.jumpCurve:Evaluate(arg0_9._positionTweenCom.elapse)
		local var1_9 = var0_9 - arg0_9._positionTweenCom.oldPosition

		arg0_9._positionTweenCom.oldPosition = var0_9

		local var2_9 = UnityEngine.Matrix4x4.TRS(arg0_9._tf.position, arg0_9._tf.rotation, Vector3.one):MultiplyVector(var0_0.New(0, var1_9, 0))

		arg0_9.gravityAcc = 0
		arg0_9.ignoreStepdown = true

		if arg0_9._positionTweenCom.elapse >= arg0_9._positionTweenCom.duration - 0.001 then
			arg0_9._positionTweenCom = nil
			arg0_9.gravitySpeed = Vector3.Dot(Vector3(0, -1, 0), var2_9) / arg1_9
			arg0_9.jumpVector = var2_0
		else
			arg0_9.jumpVector = var2_9
			arg0_9.gravitySpeed = 0
		end
	end
end

function var3_0.CalcGrounded(arg0_10)
	local var0_10, var1_10 = Physics.SphereCast(arg0_10._tf.position + arg0_10.characterController.center, arg0_10.characterController.radius, Vector3.down, nil, 2 * arg0_10.characterController.skinWidth + (0.5 * arg0_10.characterController.height - arg0_10.characterController.radius))

	if var0_10 then
		local var2_10 = arg0_10._tf.position.y + arg0_10.characterController.skinWidth - var1_10.point.y

		return true, var2_10
	end

	return false
end

function var3_0.CalcNotFalling(arg0_11)
	local var0_11, var1_11 = Physics.SphereCast(arg0_11._tf.position + arg0_11.characterController.center, arg0_11.characterController.radius, Vector3.down, nil, 0.3 + 2 * arg0_11.characterController.skinWidth + (0.5 * arg0_11.characterController.height - arg0_11.characterController.radius))

	if var0_11 then
		local var2_11 = arg0_11._tf.position.y + arg0_11.characterController.skinWidth - var1_11.point.y

		return true, var2_11
	end

	return false
end

function var3_0.Sit(arg0_12, arg1_12, arg2_12)
	arg0_12.characterController.enabled = false
	arg0_12.prevStandPosition = arg0_12._tf.position
	arg0_12._tf.position = arg1_12

	local var0_12 = arg0_12._tf:Find("all/foot_l_d_mount")
	local var1_12 = Quaternion.LookRotation(arg2_12, Vector3.New(0, 1, 0))

	arg0_12._tf.rotation = var1_12

	arg0_12.animator:SetBool(IslandConst.SIT_HASH, true)

	arg0_12.isSitting = true
end

function var3_0.MoveHandle(arg0_13, arg1_13, arg2_13)
	if arg0_13.isSitting and arg0_13.prevStandPosition then
		arg0_13.characterController.enabled = true
		arg0_13._tf.position = arg0_13.prevStandPosition

		arg0_13.animator:SetBool(IslandConst.SIT_HASH, false)

		arg0_13.isSitting = false

		return
	end

	arg0_13.orginTargetDir = arg1_13
	arg0_13.lastTargetSpeed = arg2_13 * arg0_13.maxSpeed
	arg0_13.targetSpeed = arg0_13.isSprint and arg0_13.sprintSpeed or arg0_13.lastTargetSpeed
end

function var3_0.StopMoveHandle(arg0_14)
	arg0_14.targetSpeed = 0
	arg0_14.orginTargetDir = var2_0
	arg0_14.isSprint = false
end

function var3_0.JumpHandle(arg0_15)
	arg0_15.jumpTrigger = true

	arg0_15.animator:SetTrigger(IslandConst.JUMP_FLAG)
end

function var3_0.OnPlayerPlayerSprint(arg0_16)
	if arg0_16.targetSpeed ~= 0 then
		arg0_16.isSprint = true
		arg0_16.lastTargetSpeed = arg0_16.targetSpeed
		arg0_16.targetSpeed = arg0_16.sprintSpeed
		arg0_16.speed = arg0_16.targetSpeed
	end
end

function var3_0.OnStopPlayerSprint(arg0_17)
	if arg0_17.isSprint and arg0_17.targetSpeed ~= 0 then
		arg0_17.targetSpeed = arg0_17.lastTargetSpeed
		arg0_17.speed = arg0_17.lastTargetSpeed
		arg0_17.isSprint = false
	end
end

function var3_0.StateEnterHandle(arg0_18, arg1_18)
	if arg1_18.shortNameHash == IslandConst.jumpState then
		arg0_18:OnEnterJumpState()
	end
end

function var3_0.StateExitHandle(arg0_19, arg1_19)
	return
end

function var3_0.OnEnterJumpState(arg0_20)
	arg0_20._positionTweenCom = {
		elapse = 0,
		oldPosition = 0,
		duration = arg0_20.jumpCruveAllTime
	}
end

local var8_0 = var1_0(0, 0)
local var9_0 = LayerMask.GetMask("IslandDetection")

function var3_0.Detectionobject(arg0_21)
	if arg0_21.mapId ~= 1001 then
		return
	end

	local var0_21 = Physics.OverlapSphere(arg0_21._tf.position, var4_0, var9_0)
	local var1_21 = {}

	table.IpairsCArray(var0_21, function(arg0_22, arg1_22)
		table.insert(var1_21, arg1_22)
	end)

	local function var2_21(arg0_23, arg1_23, arg2_23)
		return (arg2_23.x - arg0_23.x) * (arg1_23.y - arg0_23.y) - (arg2_23.y - arg0_23.y) * (arg1_23.x - arg0_23.x)
	end

	local function var3_21(arg0_24, arg1_24, arg2_24)
		return Mathf.Min(arg0_24.x, arg1_24.x) <= arg2_24.x and arg2_24.x <= Mathf.Max(arg0_24.x, arg1_24.x) and Mathf.Min(arg0_24.y, arg1_24.y) <= arg2_24.y and arg2_24.y <= Mathf.Max(arg0_24.y, arg1_24.y)
	end

	local function var4_21(arg0_25, arg1_25)
		local var0_25 = #arg1_25

		for iter0_25 = 0, var0_25 do
			local var1_25 = arg1_25[iter0_25]
			local var2_25 = arg1_25[(iter0_25 + 1) % var0_25] - var1_25
			local var3_25 = arg0_25 - var1_25

			if var1_0.Dot(var2_25.normalized, var3_25) > 0 then
				return false
			end
		end

		return true
	end

	local function var5_21(arg0_26, arg1_26, arg2_26, arg3_26)
		local var0_26 = var2_21(arg2_26, arg3_26, arg0_26)
		local var1_26 = var2_21(arg2_26, arg3_26, arg1_26)
		local var2_26 = var2_21(arg0_26, arg1_26, arg2_26)
		local var3_26 = var2_21(arg0_26, arg1_26, arg3_26)

		if (var0_26 > 0 and var1_26 < 0 or var0_26 < 0 and var1_26 > 0) and (var2_26 > 0 and var3_26 < 0 or var2_26 < 0 and var3_26 > 0) then
			return true
		end

		if var0_26 == 0 and var3_21(arg2_26, arg3_26, arg0_26) then
			return true
		end

		if var1_26 == 0 and var3_21(arg2_26, arg3_26, arg1_26) then
			return true
		end

		if var2_26 == 0 and var3_21(arg0_26, arg1_26, arg2_26) then
			return true
		end

		if var3_26 == 0 and var3_21(arg0_26, arg1_26, arg3_26) then
			return true
		end

		return false
	end

	local function var6_21(arg0_27, arg1_27)
		local var0_27 = {}
		local var1_27 = arg1_27 * Mathf.Deg2Rad
		local var2_27 = Mathf.Cos(var1_27)
		local var3_27 = Mathf.Sin(var1_27)
		local var4_27 = var6_0 * 0.5

		var0_27[0] = arg0_27 + var1_0(-var4_27.x * var2_27 - var4_27.y * var3_27, -var4_27.x * var3_27 + var4_27.y * var2_27)
		var0_27[1] = arg0_27 + var1_0(var4_27.x * var2_27 - var4_27.y * var3_27, var4_27.x * var3_27 + var4_27.y * var2_27)
		var0_27[2] = arg0_27 + var1_0(var4_27.x * var2_27 + var4_27.y * var3_27, var4_27.x * var3_27 - var4_27.y * var2_27)
		var0_27[3] = arg0_27 + var1_0(-var4_27.x * var2_27 + var4_27.y * var3_27, -var4_27.x * var3_27 - var4_27.y * var2_27)

		return var0_27
	end

	local function var7_21(arg0_28, arg1_28, arg2_28, arg3_28)
		local var0_28 = var6_21(arg0_28, arg1_28)

		for iter0_28 = 0, 3 do
			local var1_28 = var0_28[iter0_28]
			local var2_28 = var0_28[(iter0_28 + 1) % 4]

			if var5_21(arg2_28, arg3_28, var1_28, var2_28) then
				return true
			end
		end

		if var4_21(arg2_28, var0_28) or var4_21(arg3_28, var0_28) then
			return true
		end

		return false
	end

	local function var8_21(arg0_29, arg1_29, arg2_29)
		local var0_29 = arg0_29 - arg2_29
		local var1_29 = var1_0.Dot(var0_29, arg1_29)
		local var2_29 = var1_0.Dot(var0_29, var1_0(-arg1_29.y, arg1_29.x))
		local var3_29 = var1_0(var1_29, var2_29)
		local var4_29 = var6_0 * 0.5
		local var5_29 = var1_0.Max(var3_29 - var1_0.zero, var1_0.zero - var3_29)
		local var6_29 = var1_0.Max(var5_29 - var4_29, var1_0.zero)
		local var7_29 = var1_0.Angle(var6_29, var1_0.right)
		local var8_29 = (180 - var5_0) / 2
		local var9_29 = var7_21(var5_29, 0, var1_0.zero, var1_0(var4_0 * Mathf.Cos(15 * Mathf.Deg2Rad), var4_0 * Mathf.Sin(15 * Mathf.Deg2Rad)))

		return var8_29 <= var7_29 or var9_29
	end

	local function var9_21(arg0_30)
		if var0_0.Dot(arg0_30.transform.position - arg0_21._tf.position, arg0_21._tf.forward) < 0 then
			return
		end

		local var0_30 = arg0_21:Vector3ToVector2(arg0_30.transform.position)
		local var1_30 = arg0_21:Vector3ToVector2(arg0_21._tf.position) + var8_0

		return var8_21(var0_30, arg0_21:Vector3ToVector2(arg0_21._tf.right), var1_30)
	end

	local var10_21 = {}

	for iter0_21, iter1_21 in ipairs(var1_21) do
		if var9_21(iter1_21) then
			table.insert(var10_21, iter1_21)
		end
	end

	local var11_21 = #var10_21
	local var12_21 = false

	if var11_21 ~= 0 then
		local var13_21
		local var14_21 = arg0_21:Vector3ToVector2(arg0_21._tf.position) + var8_0 + arg0_21:Vector3ToVector2(arg0_21._tf.forward) * 2
		local var15_21 = 10
		local var16_21 = {}

		for iter2_21, iter3_21 in ipairs(var10_21) do
			local var17_21 = (arg0_21:Vector3ToVector2(iter3_21.transform.position) - var14_21):Magnitude()

			if var17_21 < var15_21 then
				var15_21 = var17_21
				var13_21 = iter3_21
			end
		end

		local var18_21 = var13_21.transform.parent

		if var18_21 then
			local var19_21 = var18_21:GetComponent(typeof(WorldObjectItem)):GetItemId()

			if var19_21 ~= arg0_21.nearId then
				arg0_21.nearId = var19_21
				arg0_21.nearItem = var18_21
				var12_21 = true
			end
		end
	end

	if var11_21 ~= arg0_21.lastCount or var12_21 then
		arg0_21.lastCount = var11_21

		if var11_21 == 0 then
			arg0_21.nearId = 0

			arg0_21:Emit(ISLAND_EVT.APPROACH_UNIT, {
				displayTpye = "normal",
				type = -1,
				id = arg0_21.id
			})
		else
			arg0_21:Emit(ISLAND_EVT.APPROACH_UNIT, {
				displayTpye = "plant",
				type = -1,
				id = arg0_21.id,
				targetNearId = arg0_21.nearId
			})
		end
	end
end

function var3_0.Vector3ToVector2(arg0_31, arg1_31)
	return var1_0(arg1_31.x, arg1_31.z)
end

function var3_0.GetNearItemId(arg0_32)
	return arg0_32.nearId
end

function var3_0.CheckIsInDress(arg0_33, arg1_33)
	for iter0_33, iter1_33 in pairs(arg0_33.pageDressDic) do
		if iter1_33.currentItemId == arg1_33 then
			return true
		end
	end

	return false
end

function var3_0.ChangeDressOnType(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.pageDressDic[arg1_34]
	local var1_34 = var0_34 and var0_34.currentItemId or nil

	if var1_34 == arg2_34 then
		return
	end

	if var1_34 ~= nil then
		if var0_34.currentItemObj then
			Object.Destroy(var0_34.currentItemObj)

			var0_34.currentItemObj = nil
		end

		var0_34.currentItemId = nil
	end

	if arg2_34 == nil then
		return
	end

	local var2_34 = pg.island_dress_template[arg2_34]
	local var3_34 = var2_34.model

	ResourceMgr.Inst:getAssetAsync(var3_34, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_35)
		if not arg0_34:CheckIsInDress(arg2_34) then
			return
		end

		local var0_35 = Object.Instantiate(arg0_35)
		local var1_35 = arg0_34._tf

		if var2_34.attachmentPoint ~= "" then
			local var2_35 = var2_34.attachmentPoint

			local function var3_35(arg0_36)
				for iter0_36 = 0, arg0_36.childCount - 1 do
					local var0_36 = arg0_36:GetChild(iter0_36)

					if var0_36.name == var2_35 then
						return var0_36
					end

					local var1_36 = var3_35(var0_36, var2_35)

					if var1_36 then
						return var1_36
					end
				end

				return nil
			end

			var1_35 = var3_35(var1_35)
		end

		if var2_34.offset ~= "" then
			local var4_35 = Vector3(var2_34.offset[1], var2_34.offset[2], var2_34.offset[3])

			var0_35.transform.position = var4_35
		end

		setParent(var0_35, var1_35)

		local var5_35 = arg0_34.pageDressDic[arg1_34] or {}

		var5_35.currentItemObj = var0_35
		arg0_34.pageDressDic[arg1_34] = var5_35
	end), true, true)

	local var4_34 = arg0_34.pageDressDic[arg1_34] or {}

	var4_34.currentItemId = arg2_34
	arg0_34.pageDressDic[arg1_34] = var4_34
end

function var3_0.OnChangeDress(arg0_37, arg1_37)
	for iter0_37, iter1_37 in pairs(arg1_37) do
		arg0_37:ChangeDressOnType(iter0_37, iter1_37.currentItemId)
	end
end

function var3_0.InitMapCheckWorldObject(arg0_38)
	arg0_38.checkList = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetCurrentMapCheckWorldObjectList()
end

function var3_0.Handle(arg0_39)
	local var0_39 = 1000
	local var1_39

	for iter0_39, iter1_39 in ipairs(arg0_39.checkList) do
		if iter1_39:IsInitUnit() then
			local var2_39 = iter1_39:GetUnityWorldPos()
			local var3_39 = Vector3.New(arg0_39._tf.position.x - var2_39[1], arg0_39._tf.position.y - var2_39[2], arg0_39._tf.position.z - var2_39[3]):Magnitude()

			if var3_39 <= var0_39 then
				var1_39 = iter1_39
				var0_39 = var3_39
			end
		else
			print(1)
		end
	end

	local var4_39

	if var0_39 <= 3 then
		var4_39 = var1_39
	end

	local var5_39 = var4_39 and var4_39.configId or nil

	if arg0_39.nearTestId ~= var5_39 then
		arg0_39.nearTestId = var5_39

		if arg0_39.nearTestId then
			arg0_39:Emit(ISLAND_EVT.APPROACH_UNIT, {
				displayTpye = "collect",
				type = -1,
				nearItem = var1_39
			})
		else
			arg0_39:Emit(ISLAND_EVT.APPROACH_UNIT, {
				displayTpye = "normal",
				type = -1
			})
		end
	end
end

function var3_0.GetCurrentPosition(arg0_40)
	return arg0_40._tf.position
end

function var3_0.OnDispose(arg0_41)
	arg0_41.characterHandleController:AddStateEnterFunc(nil)
	arg0_41.characterHandleController:AddStateExitFunc(nil)
end

return var3_0
