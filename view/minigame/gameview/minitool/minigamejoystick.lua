local var0_0 = class("MiniGameJoyStick")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.smoothX = 0.01
	arg0_1.smoothY = 0.01
	arg0_1.maxDistance = 120
	arg0_1.minDeadNum = 0.05
	arg0_1.maxDeadNum = 1
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
		arg0_1.dragActive = true
		arg0_1.active = true

		local var0_2 = arg0_1.uiCam:ScreenToWorldPoint(arg1_2.position)

		arg0_1.dragPos = arg0_1._controlTf:InverseTransformPoint(var0_2)

		arg0_1:setTargetPos(arg0_1:getOffset(arg0_1.dragPos, arg0_1.startPos))

		if arg0_1.activeCallback then
			arg0_1.activeCallback(true)
		end
	end)
	arg0_1._eventTriggerListener:AddDragFunc(function(arg0_3, arg1_3)
		local var0_3 = arg0_1.uiCam:ScreenToWorldPoint(arg1_3.position)

		arg0_1.dragPos = arg0_1._controlTf:InverseTransformPoint(var0_3)

		arg0_1:setTargetPos(arg0_1:getOffset(arg0_1.dragPos, arg0_1.startPos))
	end)
	arg0_1._eventTriggerListener:AddPointUpFunc(function(arg0_4, arg1_4)
		arg0_1:setTargetPos(Vector2(0, 0))

		arg0_1.dragActive = false
		arg0_1.active = false

		if arg0_1.activeCallback then
			arg0_1.activeCallback(false)
		end
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

function var0_0.setting(arg0_7, arg1_7)
	arg0_7.smoothX = arg1_7.smoothX
	arg0_7.smoothY = arg1_7.smoothY
	arg0_7.maxDistance = arg1_7.maxDistance
	arg0_7.minDeadNum = arg1_7.minDeadNum
	arg0_7.maxDeadNum = arg1_7.maxDeadNum
end

function var0_0.show(arg0_8, arg1_8)
	setActive(arg0_8._tf, arg1_8)
end

function var0_0.step(arg0_9)
	arg0_9.currentPos = arg0_9._joyTf.anchoredPosition
	arg0_9.currentX, arg0_9.currentXSmooth = Mathf.SmoothDamp(arg0_9.currentPos.x, arg0_9.targetPos.x, arg0_9.currentXSmooth, arg0_9.smoothX)
	arg0_9.currentY, arg0_9.currentYSmooth = Mathf.SmoothDamp(arg0_9.currentPos.y, arg0_9.targetPos.y, arg0_9.currentYSmooth, arg0_9.smoothY)
	arg0_9.currentPos.x = arg0_9.currentX
	arg0_9.currentPos.y = arg0_9.currentY
	arg0_9._joyTf.anchoredPosition = arg0_9.currentPos
	arg0_9.distanceRate = math.sqrt(math.pow(arg0_9.currentX - arg0_9.startPos.x, 2) + math.pow(arg0_9.currentY - arg0_9.startPos.y, 2)) / arg0_9.maxDistance

	if math.abs(arg0_9.currentY - arg0_9.startPos.y) <= 1 and math.abs(arg0_9.currentX - arg0_9.startPos.x) <= 1 then
		arg0_9.angle = nil
		arg0_9.rad = nil
	else
		arg0_9.rad = math.atan2(arg0_9.currentY - arg0_9.startPos.y, arg0_9.currentX - arg0_9.startPos.x)
		arg0_9.angle = arg0_9.rad * math.rad2Deg
	end

	arg0_9.offsetX = arg0_9.currentPos.x / arg0_9.maxDistance
	arg0_9.offsetY = arg0_9.currentPos.y / arg0_9.maxDistance

	if math.abs(arg0_9.offsetX) > arg0_9.minDeadNum then
		if arg0_9.offsetX > 0 then
			arg0_9.directX = 1
		elseif arg0_9.offsetX < 0 then
			arg0_9.directX = -1
		end
	else
		arg0_9.directX = 0
		arg0_9.offsetX = 0
	end

	if math.abs(arg0_9.offsetY) > arg0_9.minDeadNum then
		if arg0_9.offsetY > 0 then
			arg0_9.directY = 1
		elseif arg0_9.offsetY < 0 then
			arg0_9.directY = -1
		end
	else
		arg0_9.directY = 0
		arg0_9.offsetY = 0
	end

	if arg0_9.valueCallback then
		arg0_9.valueCallback(arg0_9:getValue())
	end
end

function var0_0.setDirectTarget(arg0_10, arg1_10)
	if arg0_10.dragActive then
		return
	end

	if arg1_10.x ~= 0 or arg1_10.y ~= 0 then
		if not arg0_10.active then
			arg0_10.active = true

			if arg0_10.activeCallback then
				arg0_10.activeCallback(true)
			end
		end

		arg0_10:setTargetPos(Vector2(arg1_10.x * 1000, arg1_10.y * 1000))
	elseif arg0_10.active then
		arg0_10.active = false

		arg0_10:setTargetPos(Vector2(0, 0))
	end
end

function var0_0.setValueCallback(arg0_11, arg1_11)
	arg0_11.valueCallback = arg1_11
end

function var0_0.setActiveCallback(arg0_12, arg1_12)
	arg0_12.activeCallback = arg1_12
end

function var0_0.getValue(arg0_13)
	local var0_13 = 0
	local var1_13 = 0

	return {
		angle = arg0_13.angle,
		rad = arg0_13.rad,
		rate = arg0_13.distanceRate,
		x = arg0_13.offsetX,
		y = arg0_13.offsetY,
		active = arg0_13.active,
		directX = arg0_13.directX,
		directY = arg0_13.directY
	}
end

return var0_0
