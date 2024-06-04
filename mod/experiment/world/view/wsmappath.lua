local var0 = class("WSMapPath", import("...BaseEntity"))

var0.Fields = {
	wsObject = "table",
	startPos = "table",
	upOffset = "number",
	theme = "table",
	moveAction = "string",
	path = "table",
	twId = "number",
	paused = "boolean",
	dirType = "number",
	step = "number"
}
var0.EventStartTrip = "WSMapPath.EventStartTrip"
var0.EventArrivedStep = "WSMapPath.EventArrivedStep"
var0.EventArrived = "WSMapPath.EventArrived"

function var0.Setup(arg0, arg1)
	arg0.theme = arg1
end

function var0.Dispose(arg0)
	if arg0.twId then
		LeanTween.cancel(arg0.twId)
	end

	arg0:Clear()
end

function var0.UpdateObject(arg0, arg1)
	assert(arg1.GetModelAngles and arg1.UpdateModelAngles and arg1.UpdateModelAction)

	arg0.wsObject = arg1
end

function var0.UpdateAction(arg0, arg1)
	arg0.moveAction = arg1
end

function var0.UpdateDirType(arg0, arg1)
	arg0.dirType = arg1
end

function var0.StartMove(arg0, arg1, arg2, arg3)
	arg0.startPos = arg1
	arg0.path = arg2
	arg0.upOffset = arg3 or 0
	arg0.step = 0
	arg0.wsObject.isMoving = true

	arg0.wsObject:UpdateModelAction(arg0.moveAction)
	arg0:DispatchEvent(var0.EventStartTrip)
	arg0:MoveStep()
end

function var0.MoveStep(arg0)
	local var0 = arg0.wsObject
	local var1 = arg0.path
	local var2 = arg0.step > 0 and var1[arg0.step] or arg0.startPos
	local var3 = var1[arg0.step + 1]
	local var4 = var1[#var1]
	local var5 = var0:GetModelAngles()

	if arg0.dirType == WorldConst.DirType4 then
		if var3.column < var2.column then
			var5.z = 180
		elseif var3.column > var2.column then
			var5.z = 0
		elseif var3.row < var2.row then
			var5.z = 90
		elseif var3.row > var2.row then
			var5.z = 270
		end

		var0:UpdateModelAngles(var5)
	elseif arg0.dirType == WorldConst.DirType2 then
		if var3.column < var2.column or var3.column == var2.column and var4.column < var2.column then
			var5.y = 180
		elseif var3.column ~= var2.column or var4.column ~= var2.column then
			var5.y = 0
		end

		var0:UpdateModelAngles(var5)
	end

	local var6 = arg0.theme:GetLinePosition(var2.row, var2.column)
	local var7 = arg0.theme:GetLinePosition(var3.row, var3.column)

	assert(var3.duration, "without move duration")

	arg0.twId = LeanTween.value(var0.transform.gameObject, 0, 1, var3.duration):setOnUpdate(System.Action_float(function(arg0)
		local var0 = Vector3.Lerp(var6, var7, arg0)
		local var1, var2 = arg0:CalcUpOffset(arg0.step, arg0)

		var0.transform.localPosition = var0 + var1

		if var0.rtShadow then
			var0.rtShadow.localPosition = Vector3(0, -var2, 0)
		end
	end)):setOnComplete(System.Action(function()
		arg0.step = arg0.step + 1

		if arg0.step >= #var1 then
			arg0.twId = nil

			var0:UpdateModelAction(WorldConst.ActionIdle)

			var0.isMoving = false

			arg0:DispatchEvent(var0.EventArrived)
		else
			arg0:DispatchEvent(var0.EventArrivedStep, var3)
			onDelayTick(function()
				arg0:MoveStep()
			end, 0.015)
		end
	end)).uniqueId

	arg0:FlushPaused()
end

function var0.UpdatePaused(arg0, arg1)
	if arg0.paused ~= arg1 then
		arg0.paused = arg1

		arg0:FlushPaused()
	end
end

function var0.FlushPaused(arg0)
	if arg0.paused then
		LeanTween.pause(arg0.twId)
		arg0.wsObject:UpdateModelAction(WorldConst.ActionIdle)
	else
		LeanTween.resume(arg0.twId)
		arg0.wsObject:UpdateModelAction(arg0.moveAction)
	end
end

function var0.CalcUpOffset(arg0, arg1, arg2)
	local var0 = math.sin((arg1 + arg2) / #arg0.path * math.pi)
	local var1 = math.clamp(var0, 0, 1) * arg0.upOffset

	return Vector3(0, arg0.theme.cosAngle * var1, -arg0.theme.sinAngle * var1), var1
end

function var0.IsMoving(arg0)
	return arg0.twId ~= nil
end

return var0
