local var0_0 = class("WSMapPath", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.EventStartTrip = "WSMapPath.EventStartTrip"
var0_0.EventArrivedStep = "WSMapPath.EventArrivedStep"
var0_0.EventArrived = "WSMapPath.EventArrived"

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.theme = arg1_1
end

function var0_0.Dispose(arg0_2)
	if arg0_2.twId then
		LeanTween.cancel(arg0_2.twId)
	end

	arg0_2:Clear()
end

function var0_0.UpdateObject(arg0_3, arg1_3)
	assert(arg1_3.GetModelAngles and arg1_3.UpdateModelAngles and arg1_3.UpdateModelAction)

	arg0_3.wsObject = arg1_3
end

function var0_0.UpdateAction(arg0_4, arg1_4)
	arg0_4.moveAction = arg1_4
end

function var0_0.UpdateDirType(arg0_5, arg1_5)
	arg0_5.dirType = arg1_5
end

function var0_0.StartMove(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.startPos = arg1_6
	arg0_6.path = arg2_6
	arg0_6.upOffset = arg3_6 or 0
	arg0_6.step = 0
	arg0_6.wsObject.isMoving = true

	arg0_6.wsObject:UpdateModelAction(arg0_6.moveAction)
	arg0_6:DispatchEvent(var0_0.EventStartTrip)
	arg0_6:MoveStep()
end

function var0_0.MoveStep(arg0_7)
	local var0_7 = arg0_7.wsObject
	local var1_7 = arg0_7.path
	local var2_7 = arg0_7.step > 0 and var1_7[arg0_7.step] or arg0_7.startPos
	local var3_7 = var1_7[arg0_7.step + 1]
	local var4_7 = var1_7[#var1_7]
	local var5_7 = var0_7:GetModelAngles()

	if arg0_7.dirType == WorldConst.DirType4 then
		if var3_7.column < var2_7.column then
			var5_7.z = 180
		elseif var3_7.column > var2_7.column then
			var5_7.z = 0
		elseif var3_7.row < var2_7.row then
			var5_7.z = 90
		elseif var3_7.row > var2_7.row then
			var5_7.z = 270
		end

		var0_7:UpdateModelAngles(var5_7)
	elseif arg0_7.dirType == WorldConst.DirType2 then
		if var3_7.column < var2_7.column or var3_7.column == var2_7.column and var4_7.column < var2_7.column then
			var5_7.y = 180
		elseif var3_7.column ~= var2_7.column or var4_7.column ~= var2_7.column then
			var5_7.y = 0
		end

		var0_7:UpdateModelAngles(var5_7)
	end

	local var6_7 = arg0_7.theme:GetLinePosition(var2_7.row, var2_7.column)
	local var7_7 = arg0_7.theme:GetLinePosition(var3_7.row, var3_7.column)

	assert(var3_7.duration, "without move duration")

	arg0_7.twId = LeanTween.value(var0_7.transform.gameObject, 0, 1, var3_7.duration):setOnUpdate(System.Action_float(function(arg0_8)
		local var0_8 = Vector3.Lerp(var6_7, var7_7, arg0_8)
		local var1_8, var2_8 = arg0_7:CalcUpOffset(arg0_7.step, arg0_8)

		var0_7.transform.localPosition = var0_8 + var1_8

		if var0_7.rtShadow then
			var0_7.rtShadow.localPosition = Vector3(0, -var2_8, 0)
		end
	end)):setOnComplete(System.Action(function()
		arg0_7.step = arg0_7.step + 1

		if arg0_7.step >= #var1_7 then
			arg0_7.twId = nil

			var0_7:UpdateModelAction(WorldConst.ActionIdle)

			var0_7.isMoving = false

			arg0_7:DispatchEvent(var0_0.EventArrived)
		else
			arg0_7:DispatchEvent(var0_0.EventArrivedStep, var3_7)
			onDelayTick(function()
				arg0_7:MoveStep()
			end, 0.015)
		end
	end)).uniqueId

	arg0_7:FlushPaused()
end

function var0_0.UpdatePaused(arg0_11, arg1_11)
	if arg0_11.paused ~= arg1_11 then
		arg0_11.paused = arg1_11

		arg0_11:FlushPaused()
	end
end

function var0_0.FlushPaused(arg0_12)
	if arg0_12.paused then
		LeanTween.pause(arg0_12.twId)
		arg0_12.wsObject:UpdateModelAction(WorldConst.ActionIdle)
	else
		LeanTween.resume(arg0_12.twId)
		arg0_12.wsObject:UpdateModelAction(arg0_12.moveAction)
	end
end

function var0_0.CalcUpOffset(arg0_13, arg1_13, arg2_13)
	local var0_13 = math.sin((arg1_13 + arg2_13) / #arg0_13.path * math.pi)
	local var1_13 = math.clamp(var0_13, 0, 1) * arg0_13.upOffset

	return Vector3(0, arg0_13.theme.cosAngle * var1_13, -arg0_13.theme.sinAngle * var1_13), var1_13
end

function var0_0.IsMoving(arg0_14)
	return arg0_14.twId ~= nil
end

return var0_0
