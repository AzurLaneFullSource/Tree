ys = ys or {}

local var0_0 = ys.Battle.BattleVariable
local var1_0 = class("MoveComponent")

ys.Battle.MoveComponent = var1_0

local var2_0 = ys.Battle.BattleConst
local var3_0 = ys.Battle.BattleFormulas

var1_0._pos = Vector3.zero
var1_0._isForceMove = false
var1_0._staticState = false
var1_0._speed = Vector3.zero
var1_0._additiveSpeedList = {}
var1_0._additiveSpeed = Vector3.zero
var1_0._corpsLimitSpeed = 0
var1_0._leftCorpsBound = 0
var1_0._rightCorpsBound = 0
var1_0._immuneAreaLimit = false
var1_0._immuneMaxAreaLimit = false
var1_0._leftBorder = 0
var1_0._rightBorder = 0
var1_0._upBorder = 0
var1_0._downBorder = 0
var1_0._IFF = 0

function var1_0.Ctor(arg0_1)
	return
end

function var1_0.GetPos(arg0_2)
	return arg0_2._pos
end

function var1_0.SetPos(arg0_3, arg1_3)
	arg0_3._pos = arg1_3
end

function var1_0.Update(arg0_4)
	arg0_4._speed = arg0_4:GetFinalSpeed()
end

function var1_0.FixSpeed(arg0_5, arg1_5)
	assert(arg1_5.FixSpeed ~= nil and type(arg1_5.FixSpeed) == "function", " MoveComponent.FixSpeed 速度修正出错")
	arg1_5:FixSpeed(arg0_5._speed)
end

function var1_0.Move(arg0_6, arg1_6)
	arg1_6 = arg1_6 or 1
	arg0_6._pos.x = arg0_6._pos.x + arg0_6._speed.x * arg1_6
	arg0_6._pos.y = arg0_6._pos.y + arg0_6._speed.y * arg1_6
	arg0_6._pos.z = arg0_6._pos.z + arg0_6._speed.z * arg1_6
end

function var1_0.GetSpeed(arg0_7)
	return arg0_7._speed
end

function var1_0.SetCorpsArea(arg0_8, arg1_8, arg2_8)
	arg0_8._leftCorpsBound = arg1_8
	arg0_8._rightCorpsBound = arg2_8
end

function var1_0.SetBorder(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	arg0_9._leftBorder = arg1_9
	arg0_9._rightBorder = arg2_9
	arg0_9._upBorder = arg3_9
	arg0_9._downBorder = arg4_9
end

function var1_0.GetFinalSpeed(arg0_10)
	local var0_10 = arg0_10:getInitialSpeed()

	if not arg0_10._unstoppable then
		var0_10 = arg0_10:AdditiveForce(var0_10)
	end

	return (arg0_10:BorderLimit(var0_10))
end

function var1_0.CorpsAreaLimit(arg0_11, arg1_11)
	if arg0_11._immuneAreaLimit then
		return arg1_11
	end

	local var0_11 = arg0_11._pos.x
	local var1_11 = arg0_11._corpsLimitSpeed

	if var0_11 < arg0_11._leftCorpsBound then
		var1_11 = math.max(var1_11, 0.1)

		if arg1_11.x < 0 then
			var1_11 = math.min(10, var1_11 * 1.04)
		end
	elseif var0_11 > arg0_11._rightCorpsBound then
		var1_11 = math.min(var1_11, -0.1)

		if arg1_11.x > 0 then
			var1_11 = math.max(-10, var1_11 * 1.04)
		end
	else
		var1_11 = var1_11 < 0.1 and var1_11 > -0.1 and 0 or var1_11 * 0.8
	end

	arg0_11._corpsLimitSpeed = var1_11
	arg1_11.x = arg1_11.x + arg0_11._corpsLimitSpeed

	return arg1_11
end

function var1_0.BorderLimit(arg0_12, arg1_12)
	if arg0_12._immuneMaxAreaLimit then
		return arg1_12
	end

	local var0_12 = arg0_12._pos

	if arg1_12.x < 0 and var0_12.x <= arg0_12._leftBorder or arg1_12.x > 0 and var0_12.x >= arg0_12._rightBorder then
		arg1_12.x = 0
	end

	if arg1_12.z < 0 and var0_12.z <= arg0_12._downBorder or arg1_12.z > 0 and var0_12.z >= arg0_12._upBorder then
		arg1_12.z = 0
	end

	return arg1_12
end

function var1_0.ImmuneAreaLimit(arg0_13, arg1_13)
	arg0_13._immuneAreaLimit = arg1_13
end

function var1_0.ImmuneMaxAreaLimit(arg0_14, arg1_14)
	arg0_14._immuneMaxAreaLimit = arg1_14
end

function var1_0.getInitialSpeed(arg0_15)
	if arg0_15._isForceMove and not arg0_15._unstoppable then
		local var0_15 = arg0_15._forceSpeed

		arg0_15:UpdateForceMove()

		return var0_15
	end

	if arg0_15._moveProcess then
		return arg0_15._moveProcess()
	end

	if arg0_15._staticState then
		return Vector3.zero
	end

	if arg0_15._manuallyMove then
		return arg0_15:CorpsAreaLimit(arg0_15._manuallyMove())
	end

	assert(arg0_15._autoMoveAi ~= nil, "角色缺少默认移动的ai")

	return arg0_15._autoMoveAi()
end

function var1_0.SetForceMove(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16, arg5_16)
	arg0_16._isForceMove = true
	arg1_16 = arg1_16.normalized
	arg0_16._forceSpeed = arg1_16 * arg2_16
	arg0_16._forceReduce = arg1_16 * arg3_16
	arg0_16._forceLastTime = arg4_16
	arg0_16._decayValve = arg5_16 or 0
end

function var1_0.UpdateForceMove(arg0_17)
	local var0_17 = arg0_17._forceLastTime

	if var0_17 <= 0 then
		arg0_17:ClearForceMove()

		return
	end

	arg0_17._forceLastTime = var0_17 - 1

	if var0_17 < arg0_17._decayValve then
		arg0_17._forceSpeed:Sub(arg0_17._forceReduce)
	end
end

function var1_0.ClearForceMove(arg0_18)
	arg0_18._isForceMove = false
	arg0_18._forceSpeed = nil
	arg0_18._forceReduce = nil
	arg0_18._forceLastTime = nil
end

function var1_0.SetMoveProcess(arg0_19, arg1_19)
	arg0_19._moveProcess = arg1_19
end

function var1_0.SetStaticState(arg0_20, arg1_20)
	arg0_20._staticState = arg1_20
end

function var1_0.SetAutoMoveAI(arg0_21, arg1_21, arg2_21)
	function arg0_21._autoMoveAi()
		return arg1_21:GetDirection():Mul(arg2_21:GetAttrByName("velocity"))
	end
end

function var1_0.SetFormationCtrlInfo(arg0_23, arg1_23)
	function arg0_23._manuallyMove()
		return arg0_23:UpdateFleetInfo(arg1_23)
	end
end

function var1_0.CancelFormationCtrl(arg0_25)
	arg0_25._manuallyMove = nil
end

function var1_0.SetMotionVO(arg0_26, arg1_26)
	arg0_26._fleetMotionVO = arg1_26
end

function var1_0.UpdateFleetInfo(arg0_27, arg1_27)
	local var0_27 = arg0_27._fleetMotionVO
	local var1_27 = var0_27:GetSpeed()

	if arg1_27:EqualZero() then
		return var1_27
	end

	local var2_27 = var0_27:GetPos()

	return (var0_27:GetDirAngle() * arg1_27):Add(var2_27):Sub(arg0_27._pos):Div(25):Add(var1_27)
end

function var1_0.AdditiveForce(arg0_28, arg1_28)
	arg1_28.x = arg1_28.x + arg0_28._additiveSpeed.x
	arg1_28.z = arg1_28.z + arg0_28._additiveSpeed.z

	return arg1_28
end

function var1_0.UpdateAdditiveSpeed(arg0_29, arg1_29)
	arg0_29._additiveSpeed = arg1_29
end

function var1_0.RemoveAdditiveSpeed(arg0_30)
	arg0_30._additiveSpeed = Vector3.zero
end

function var1_0.ActiveUnstoppable(arg0_31, arg1_31)
	arg0_31._unstoppable = arg1_31
end
