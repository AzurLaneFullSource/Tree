local var0_0 = class("SummerFeastNavigationAgent", require("view.main.NavalAcademyStudent"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.onTransEdge = nil

	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.init(arg0_2)
	return
end

var0_0.normalSpeed = 15
var0_0.normalScale = 0.5

function var0_0.SetOnTransEdge(arg0_3, arg1_3)
	arg0_3.onTransEdge = arg1_3
end

function var0_0.setCurrentIndex(arg0_4, arg1_4)
	if not arg1_4 then
		return
	end

	arg0_4.currentPoint = arg0_4.pathFinder:getPoint(arg1_4)
end

function var0_0.SetPositionTable(arg0_5, arg1_5)
	arg0_5.posTable = arg1_5
end

function var0_0.updateStudent(arg0_6, arg1_6)
	if arg1_6 == nil or arg1_6 == "" then
		setActive(arg0_6._go, false)

		return
	end

	setActive(arg0_6._go, true)

	if arg0_6.prefabName ~= arg1_6 then
		if arg0_6.model then
			arg0_6.model:Dispose()
		end

		arg0_6.prefab = arg1_6
		arg0_6.currentPoint = arg0_6.currentPoint or arg0_6.pathFinder:getRandomPoint()
		arg0_6.targetPoint = arg0_6.currentPoint

		local var0_6 = arg0_6.currentPoint.id

		arg0_6._tf.anchoredPosition = arg0_6.currentPoint

		if arg0_6.onTransEdge then
			arg0_6.onTransEdge(arg0_6, var0_6, var0_6)
		end

		local var1_6 = arg0_6.prefab

		arg0_6.model = SpineAnimChar.New()

		arg0_6.model:SetPaint(var1_6)
		arg0_6.model:Load(true, function(arg0_7)
			if var1_6 ~= arg0_6.prefab then
				arg0_7:Dispose()

				return
			end

			arg0_6.model:SetLocalScale(Vector3(0.5, 0.5, 1))
			arg0_6.model:SetLocalPosition(Vector3.zero)
			arg0_6.model:SetParent(arg0_6._tf)
			arg0_6:updateState(var0_0.ShipState.Idle)
		end)
	end

	arg0_6.prefabName = arg1_6
end

function var0_0.updateLogic(arg0_8)
	arg0_8:clearLogic()

	if arg0_8.state == var0_0.ShipState.Walk then
		local var0_8 = arg0_8.currentPoint
		local var1_8 = arg0_8.targetPoint
		local var2_8 = arg0_8.normalSpeed
		local var3_8 = Vector2.Distance(var0_8, var1_8) / var2_8

		if arg0_8.posTable[arg0_8.currentPoint.id] == arg0_8 then
			arg0_8.posTable[arg0_8.currentPoint.id] = nil
		end

		arg0_8._tf.localScale = (var0_8.scale or var0_0.normalScale) * Vector2.one

		local var4_8 = arg0_8.pathFinder:getEdge(var0_8, var1_8)

		LeanTween.value(arg0_8._go, 0, 1, var3_8):setOnUpdate(System.Action_float(function(arg0_9)
			local var0_9

			if var4_8 and var4_8.bezier_control_point then
				local var1_9 = arg0_8.pathFinder:getPoint(var4_8.bezier_control_point)

				var0_9 = var0_0.GetBeziersPoints(var0_8, var1_8, var1_9, arg0_9)
			else
				var0_9 = Vector2.Lerp(var0_8, var1_8, arg0_9)
			end

			arg0_8._tf.anchoredPosition = var0_9

			local var2_9 = math.lerp(var0_8.scale or var0_0.normalScale, var1_8.scale or var0_0.normalScale, arg0_9) * Vector2.one
			local var3_9 = var1_8.x > var0_8.x and 1 or -1

			if var0_8.id == var1_8.id then
				var3_9 = math.random(0, 1) == 1 and 1 or -1
			end

			if var0_8.fixedDirection then
				var3_9 = math.sign(var0_8.fixedDirection)
			end

			var2_9.x = math.abs(var2_9.x) * var3_9
			arg0_8._tf.localScale = var2_9
		end)):setOnComplete(System.Action(function()
			arg0_8.currentPoint = arg0_8.targetPoint

			local var0_10 = arg0_8.currentPoint.id
			local var1_10 = arg0_8.currentPoint.nexts
			local var2_10 = var1_10[math.random(1, #var1_10)]

			if arg0_8.onTransEdge and var2_10 then
				arg0_8.targetPoint = arg0_8.pathFinder:getPoint(var2_10)

				arg0_8.onTransEdge(arg0_8, var0_10, var2_10)
			end

			arg0_8:updateState(var0_0.ShipState.Idle)
		end))
	elseif arg0_8.state == var0_0.ShipState.Idle then
		if arg0_8.posTable[arg0_8.currentPoint.id] == nil then
			arg0_8.posTable[arg0_8.currentPoint.id] = arg0_8
		else
			arg0_8:updateState(var0_0.ShipState.Walk)

			return
		end

		if arg0_8.currentPoint.isBan then
			arg0_8:updateState(var0_0.ShipState.Walk)

			return
		end

		local var5_8 = math.random(10, 20)

		arg0_8.idleTimer = Timer.New(function()
			arg0_8:updateState(var0_0.ShipState.Walk)
		end, var5_8, 1)

		arg0_8.idleTimer:Start()
	elseif arg0_8.state == var0_0.ShipState.Touch then
		arg0_8:onClickShip()
	end
end

function var0_0.GetBeziersPoints(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg0_12:Clone():Mul((1 - arg3_12) * (1 - arg3_12))
	local var1_12 = arg2_12:Clone():Mul(2 * arg3_12 * (1 - arg3_12))
	local var2_12 = arg1_12:Clone():Mul(arg3_12 * arg3_12)

	return var0_12:Add(var1_12):Add(var2_12)
end

return var0_0
