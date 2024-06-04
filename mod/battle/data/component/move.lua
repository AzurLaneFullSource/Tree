ys = ys or {}

local var0 = ys.Battle.BattleVariable
local var1 = class("MoveComponent")

ys.Battle.MoveComponent = var1

local var2 = ys.Battle.BattleConst
local var3 = ys.Battle.BattleFormulas

var1._pos = Vector3.zero
var1._isForceMove = false
var1._staticState = false
var1._speed = Vector3.zero
var1._additiveSpeedList = {}
var1._additiveSpeed = Vector3.zero
var1._corpsLimitSpeed = 0
var1._leftCorpsBound = 0
var1._rightCorpsBound = 0
var1._immuneAreaLimit = false
var1._immuneMaxAreaLimit = false
var1._leftBorder = 0
var1._rightBorder = 0
var1._upBorder = 0
var1._downBorder = 0
var1._IFF = 0

function var1.Ctor(arg0)
	return
end

function var1.GetPos(arg0)
	return arg0._pos
end

function var1.SetPos(arg0, arg1)
	arg0._pos = arg1
end

function var1.Update(arg0)
	arg0._speed = arg0:GetFinalSpeed()
end

function var1.FixSpeed(arg0, arg1)
	assert(arg1.FixSpeed ~= nil and type(arg1.FixSpeed) == "function", " MoveComponent.FixSpeed 速度修正出错")
	arg1:FixSpeed(arg0._speed)
end

function var1.Move(arg0, arg1)
	arg1 = arg1 or 1
	arg0._pos.x = arg0._pos.x + arg0._speed.x * arg1
	arg0._pos.y = arg0._pos.y + arg0._speed.y * arg1
	arg0._pos.z = arg0._pos.z + arg0._speed.z * arg1
end

function var1.GetSpeed(arg0)
	return arg0._speed
end

function var1.SetCorpsArea(arg0, arg1, arg2)
	arg0._leftCorpsBound = arg1
	arg0._rightCorpsBound = arg2
end

function var1.SetBorder(arg0, arg1, arg2, arg3, arg4)
	arg0._leftBorder = arg1
	arg0._rightBorder = arg2
	arg0._upBorder = arg3
	arg0._downBorder = arg4
end

function var1.GetFinalSpeed(arg0)
	local var0 = arg0:getInitialSpeed()

	if not arg0._unstoppable then
		var0 = arg0:AdditiveForce(var0)
	end

	return (arg0:BorderLimit(var0))
end

function var1.CorpsAreaLimit(arg0, arg1)
	if arg0._immuneAreaLimit then
		return arg1
	end

	local var0 = arg0._pos.x
	local var1 = arg0._corpsLimitSpeed

	if var0 < arg0._leftCorpsBound then
		var1 = math.max(var1, 0.1)

		if arg1.x < 0 then
			var1 = math.min(10, var1 * 1.04)
		end
	elseif var0 > arg0._rightCorpsBound then
		var1 = math.min(var1, -0.1)

		if arg1.x > 0 then
			var1 = math.max(-10, var1 * 1.04)
		end
	else
		var1 = var1 < 0.1 and var1 > -0.1 and 0 or var1 * 0.8
	end

	arg0._corpsLimitSpeed = var1
	arg1.x = arg1.x + arg0._corpsLimitSpeed

	return arg1
end

function var1.BorderLimit(arg0, arg1)
	if arg0._immuneMaxAreaLimit then
		return arg1
	end

	local var0 = arg0._pos

	if arg1.x < 0 and var0.x <= arg0._leftBorder or arg1.x > 0 and var0.x >= arg0._rightBorder then
		arg1.x = 0
	end

	if arg1.z < 0 and var0.z <= arg0._downBorder or arg1.z > 0 and var0.z >= arg0._upBorder then
		arg1.z = 0
	end

	return arg1
end

function var1.ImmuneAreaLimit(arg0, arg1)
	arg0._immuneAreaLimit = arg1
end

function var1.ImmuneMaxAreaLimit(arg0, arg1)
	arg0._immuneMaxAreaLimit = arg1
end

function var1.getInitialSpeed(arg0)
	if arg0._isForceMove and not arg0._unstoppable then
		local var0 = arg0._forceSpeed

		arg0:UpdateForceMove()

		return var0
	end

	if arg0._moveProcess then
		return arg0._moveProcess()
	end

	if arg0._staticState then
		return Vector3.zero
	end

	if arg0._manuallyMove then
		return arg0:CorpsAreaLimit(arg0._manuallyMove())
	end

	assert(arg0._autoMoveAi ~= nil, "角色缺少默认移动的ai")

	return arg0._autoMoveAi()
end

function var1.SetForceMove(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._isForceMove = true
	arg1 = arg1.normalized
	arg0._forceSpeed = arg1 * arg2
	arg0._forceReduce = arg1 * arg3
	arg0._forceLastTime = arg4
	arg0._decayValve = arg5 or 0
end

function var1.UpdateForceMove(arg0)
	local var0 = arg0._forceLastTime

	if var0 <= 0 then
		arg0:ClearForceMove()

		return
	end

	arg0._forceLastTime = var0 - 1

	if var0 < arg0._decayValve then
		arg0._forceSpeed:Sub(arg0._forceReduce)
	end
end

function var1.ClearForceMove(arg0)
	arg0._isForceMove = false
	arg0._forceSpeed = nil
	arg0._forceReduce = nil
	arg0._forceLastTime = nil
end

function var1.SetMoveProcess(arg0, arg1)
	arg0._moveProcess = arg1
end

function var1.SetStaticState(arg0, arg1)
	arg0._staticState = arg1
end

function var1.SetAutoMoveAI(arg0, arg1, arg2)
	function arg0._autoMoveAi()
		return arg1:GetDirection():Mul(arg2:GetAttrByName("velocity"))
	end
end

function var1.SetFormationCtrlInfo(arg0, arg1)
	function arg0._manuallyMove()
		return arg0:UpdateFleetInfo(arg1)
	end
end

function var1.CancelFormationCtrl(arg0)
	arg0._manuallyMove = nil
end

function var1.SetMotionVO(arg0, arg1)
	arg0._fleetMotionVO = arg1
end

function var1.UpdateFleetInfo(arg0, arg1)
	local var0 = arg0._fleetMotionVO
	local var1 = var0:GetSpeed()

	if arg1:EqualZero() then
		return var1
	end

	local var2 = var0:GetPos()

	return (var0:GetDirAngle() * arg1):Add(var2):Sub(arg0._pos):Div(25):Add(var1)
end

function var1.AdditiveForce(arg0, arg1)
	arg1.x = arg1.x + arg0._additiveSpeed.x
	arg1.z = arg1.z + arg0._additiveSpeed.z

	return arg1
end

function var1.UpdateAdditiveSpeed(arg0, arg1)
	arg0._additiveSpeed = arg1
end

function var1.RemoveAdditiveSpeed(arg0)
	arg0._additiveSpeed = Vector3.zero
end

function var1.ActiveUnstoppable(arg0, arg1)
	arg0._unstoppable = arg1
end
