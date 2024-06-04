local var0 = class("LaunchBallGameJoyStick")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.smoothX = 0.01
	arg0.smoothY = 0.01
	arg0.maxDistance = 120
	arg0.minDeadNum = 0.1
	arg0.maxDeadNum = 0.9
	arg0.currentPos = Vector2(0, 0)
	arg0.targetPos = Vector2(0, 0)
	arg0.currentX = 0
	arg0.currentY = 0
	arg0.currentXSmooth = 0
	arg0.currentYSmooth = 0
	arg0.active = false
	arg0.startPos = Vector2(0, 0)
	arg0.dragPos = Vector2(0, 0)
	arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	arg0._controlTf = findTF(arg0._tf, "control")
	arg0._joyTf = findTF(arg0._tf, "control/joy")
	arg0._eventTriggerListener = GetComponent(arg0._controlTf, typeof(EventTriggerListener))

	arg0._eventTriggerListener:AddPointDownFunc(function(arg0, arg1)
		arg0.active = true

		local var0 = arg0.uiCam:ScreenToWorldPoint(arg1.position)

		arg0.dragPos = arg0._controlTf:InverseTransformPoint(var0)

		arg0:setTargetPos(arg0:getOffset(arg0.dragPos, arg0.startPos))

		if arg0.activeCallback then
			arg0.activeCallback(true)
		end
	end)
	arg0._eventTriggerListener:AddDragFunc(function(arg0, arg1)
		local var0 = arg0.uiCam:ScreenToWorldPoint(arg1.position)

		arg0.dragPos = arg0._controlTf:InverseTransformPoint(var0)

		arg0:setTargetPos(arg0:getOffset(arg0.dragPos, arg0.startPos))
	end)
	arg0._eventTriggerListener:AddPointUpFunc(function(arg0, arg1)
		arg0.active = false

		if arg0.activeCallback then
			arg0.activeCallback(false)
		end
	end)
	arg0:setTargetPos(Vector2(0, 0))
end

function var0.setTargetPos(arg0, arg1)
	local var0 = arg0.startPos

	if math.sqrt(math.pow(arg1.x - var0.x, 2) + math.pow(arg1.y - var0.y, 2)) > arg0.maxDistance then
		local var1 = math.atan(math.abs(arg1.y - var0.y) / math.abs(arg1.x - var0.x))
		local var2 = arg1.x > var0.x and 1 or -1
		local var3 = arg1.y > var0.y and 1 or -1
		local var4 = math.cos(var1) * var2 * arg0.maxDistance
		local var5 = math.sin(var1) * var3 * arg0.maxDistance

		arg0.targetPos.x = var4
		arg0.targetPos.y = var5
	else
		arg0.targetPos = arg1
	end
end

function var0.getOffset(arg0, arg1, arg2)
	return Vector2(arg1.x - arg2.x, arg1.y - arg2.y)
end

function var0.show(arg0, arg1)
	setActive(arg0._tf, arg1)
end

function var0.step(arg0)
	arg0.currentPos = arg0._joyTf.anchoredPosition
	arg0.currentX, arg0.currentXSmooth = Mathf.SmoothDamp(arg0.currentPos.x, arg0.targetPos.x, arg0.currentXSmooth, arg0.smoothX)
	arg0.currentY, arg0.currentYSmooth = Mathf.SmoothDamp(arg0.currentPos.y, arg0.targetPos.y, arg0.currentYSmooth, arg0.smoothY)
	arg0.currentPos.x = arg0.currentX
	arg0.currentPos.y = arg0.currentY
	arg0._joyTf.anchoredPosition = arg0.currentPos
	arg0.distanceRate = math.sqrt(math.pow(arg0.currentX - arg0.startPos.x, 2) + math.pow(arg0.currentY - arg0.startPos.y, 2)) / arg0.maxDistance

	if math.abs(arg0.currentY - arg0.startPos.y) <= 1 and math.abs(arg0.currentX - arg0.startPos.x) <= 1 then
		arg0.angle = nil
		arg0.rad = nil
	else
		arg0.rad = math.atan2(arg0.currentY - arg0.startPos.y, arg0.currentX - arg0.startPos.x)
		arg0.angle = arg0.rad * math.rad2Deg
	end

	arg0.offsetX = arg0.currentPos.x / arg0.maxDistance
	arg0.offsetY = arg0.currentPos.y / arg0.maxDistance

	if arg0.valueCallback then
		arg0.valueCallback(arg0:getValue())
	end
end

function var0.setDirectTarget(arg0, arg1)
	if not arg0.active then
		arg0:setTargetPos(Vector2(arg1.x * 1000, arg1.y * 1000))
	end
end

function var0.setValueCallback(arg0, arg1)
	arg0.valueCallback = arg1
end

function var0.setActiveCallback(arg0, arg1)
	arg0.activeCallback = arg1
end

function var0.getValue(arg0)
	return {
		angle = arg0.angle,
		rad = arg0.rad,
		rate = arg0.distanceRate,
		x = arg0.offsetX,
		y = arg0.offsetY,
		active = arg0.active
	}
end

return var0
