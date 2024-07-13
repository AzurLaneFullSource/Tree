local var0_0 = class("CastleGameJoyStick")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.smoothX = 0.02
	arg0_1.smoothY = 0.02
	arg0_1.maxDistance = 120
	arg0_1.minDeadNum = 0.1
	arg0_1.maxDeadNum = 0.9
	arg0_1.currentPos = Vector2(0, 0)
	arg0_1.targetPos = Vector2(0, 0)
	arg0_1.currentX = 0
	arg0_1.currentY = 0
	arg0_1.currentXSmooth = 0
	arg0_1.currentYSmooth = 0
	arg0_1.active = false
	arg0_1.startPos = Vector2(0, 0)
	arg0_1.dragPos = Vector2(0, 0)
	arg0_1.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	arg0_1._controlTf = findTF(arg0_1._tf, "control")
	arg0_1._joyTf = findTF(arg0_1._tf, "control/joy")
	arg0_1._eventTriggerListener = GetComponent(arg0_1._controlTf, typeof(EventTriggerListener))

	arg0_1._eventTriggerListener:AddPointDownFunc(function(arg0_2, arg1_2)
		arg0_1.active = true
		arg0_1.startPos = Vector2(0, 0)
	end)
	arg0_1._eventTriggerListener:AddDragFunc(function(arg0_3, arg1_3)
		local var0_3 = arg0_1.uiCam:ScreenToWorldPoint(arg1_3.position)

		arg0_1.dragPos = arg0_1._controlTf:InverseTransformPoint(var0_3)

		arg0_1:setTargetPos(arg0_1:getOffset(arg0_1.dragPos, arg0_1.startPos))
	end)
	arg0_1._eventTriggerListener:AddPointUpFunc(function(arg0_4, arg1_4)
		arg0_1.active = false

		arg0_1:setTargetPos(Vector2(0, 0))
	end)
	arg0_1:setTargetPos(Vector2(0, 0))
end

function var0_0.setTargetPos(arg0_5, arg1_5)
	local var0_5 = arg0_5.startPos

	if math.sqrt(math.pow(arg1_5.x - var0_5.x, 2) + math.pow(arg1_5.y - var0_5.y, 2)) > arg0_5.maxDistance then
		local var1_5 = math.atan(math.abs(arg1_5.y - var0_5.y) / math.abs(arg1_5.x - var0_5.x))
		local var2_5 = arg1_5.x > var0_5.x and 1 or -1
		local var3_5 = arg1_5.y > var0_5.y and 1 or -1
		local var4_5 = math.cos(var1_5) * var2_5 * arg0_5.maxDistance
		local var5_5 = math.sin(var1_5) * var3_5 * arg0_5.maxDistance

		arg0_5.targetPos.x = var4_5
		arg0_5.targetPos.y = var5_5
	else
		arg0_5.targetPos = arg1_5
	end
end

function var0_0.getOffset(arg0_6, arg1_6, arg2_6)
	return Vector2(arg1_6.x - arg2_6.x, arg1_6.y - arg2_6.y)
end

function var0_0.show(arg0_7, arg1_7)
	setActive(arg0_7._tf, arg1_7)
end

function var0_0.step(arg0_8)
	arg0_8.currentPos = arg0_8._joyTf.anchoredPosition
	arg0_8.currentX, arg0_8.currentXSmooth = Mathf.SmoothDamp(arg0_8.currentPos.x, arg0_8.targetPos.x, arg0_8.currentXSmooth, arg0_8.smoothX)
	arg0_8.currentY, arg0_8.currentYSmooth = Mathf.SmoothDamp(arg0_8.currentPos.y, arg0_8.targetPos.y, arg0_8.currentYSmooth, arg0_8.smoothY)
	arg0_8.currentPos.x = arg0_8.currentX
	arg0_8.currentPos.y = arg0_8.currentY
	arg0_8._joyTf.anchoredPosition = arg0_8.currentPos
	arg0_8.distanceRate = math.sqrt(math.pow(arg0_8.currentX - arg0_8.startPos.x, 2) + math.pow(arg0_8.currentY - arg0_8.startPos.y, 2)) / arg0_8.maxDistance
	arg0_8.angle = math.atan(math.abs(arg0_8.currentY - arg0_8.startPos.y) / math.abs(arg0_8.currentX - arg0_8.startPos.x))
	arg0_8.offsetX = arg0_8.currentPos.x / arg0_8.maxDistance
	arg0_8.offsetY = arg0_8.currentPos.y / arg0_8.maxDistance

	if arg0_8.callback then
		arg0_8.callback(arg0_8:getValue())
	end
end

function var0_0.setDirectTarget(arg0_9, arg1_9)
	if not arg0_9.active then
		arg0_9:setTargetPos(Vector2(arg1_9.x * 1000, arg1_9.y * 1000))
	end
end

function var0_0.setValueCallback(arg0_10, arg1_10)
	arg0_10.callback = arg1_10
end

function var0_0.getValue(arg0_11)
	return {
		angle = arg0_11.angle,
		rate = arg0_11.distanceRate,
		x = arg0_11.offsetX,
		y = arg0_11.offsetY
	}
end

return var0_0
