local var0 = class("SummerFeastNavigationAgent", require("view.main.NavalAcademyStudent"))

function var0.Ctor(arg0, arg1)
	arg0.onTransEdge = nil

	var0.super.Ctor(arg0, arg1)
end

function var0.init(arg0)
	return
end

var0.normalSpeed = 150
var0.normalScale = 0.5

function var0.SetOnTransEdge(arg0, arg1)
	arg0.onTransEdge = arg1
end

function var0.setCurrentIndex(arg0, arg1)
	if not arg1 then
		return
	end

	arg0.currentPoint = arg0.pathFinder:getPoint(arg1)
end

function var0.SetPositionTable(arg0, arg1)
	arg0.posTable = arg1
end

function var0.updateStudent(arg0, arg1)
	if arg1 == nil or arg1 == "" then
		setActive(arg0._go, false)

		return
	end

	setActive(arg0._go, true)

	if arg0.prefabName ~= arg1 then
		if not IsNil(arg0.model) then
			PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab, arg0.model)
		end

		arg0.prefab = arg1
		arg0.currentPoint = arg0.currentPoint or arg0.pathFinder:getRandomPoint()
		arg0.targetPoint = arg0.currentPoint

		local var0 = arg0.currentPoint.id

		arg0._tf.anchoredPosition = arg0.currentPoint

		if arg0.onTransEdge then
			arg0.onTransEdge(arg0, var0, var0)
		end

		local var1 = arg0.prefab

		PoolMgr.GetInstance():GetSpineChar(var1, true, function(arg0)
			if var1 ~= arg0.prefab then
				PoolMgr.GetInstance():ReturnSpineChar(var1, arg0)

				return
			end

			arg0.model = arg0
			arg0.model.transform.localScale = Vector3.one
			arg0.model.transform.localPosition = Vector3.zero

			arg0.model.transform:SetParent(arg0._tf, false)

			arg0.anim = arg0.model:GetComponent(typeof(SpineAnimUI))

			arg0:updateState(var0.ShipState.Walk)
		end)
	end

	arg0.prefabName = arg1
end

function var0.updateLogic(arg0)
	arg0:clearLogic()

	if arg0.state == var0.ShipState.Walk then
		local var0 = arg0.currentPoint
		local var1 = arg0.targetPoint
		local var2 = 15
		local var3 = Vector2.Distance(var0, var1) / var2

		if arg0.posTable[arg0.currentPoint.id] == arg0 then
			arg0.posTable[arg0.currentPoint.id] = nil
		end

		arg0._tf.localScale = (var0.scale or var0.normalScale) * Vector2.one

		local var4 = arg0.pathFinder:getEdge(var0, var1)

		LeanTween.value(arg0._go, 0, 1, var3):setOnUpdate(System.Action_float(function(arg0)
			local var0

			if var4 and var4.bezier_control_point then
				local var1 = arg0.pathFinder:getPoint(var4.bezier_control_point)

				var0 = var0.GetBeziersPoints(var0, var1, var1, arg0)
			else
				var0 = Vector2.Lerp(var0, var1, arg0)
			end

			arg0._tf.anchoredPosition = var0

			local var2 = math.lerp(var0.scale or var0.normalScale, var1.scale or var0.normalScale, arg0) * Vector2.one
			local var3 = var1.x > var0.x and 1 or -1

			if var0.id == var1.id then
				var3 = math.random(0, 1) == 1 and 1 or -1
			end

			if var0.fixedDirection then
				var3 = math.sign(var0.fixedDirection)
			end

			var2.x = math.abs(var2.x) * var3
			arg0._tf.localScale = var2
		end)):setOnComplete(System.Action(function()
			arg0.currentPoint = arg0.targetPoint

			local var0 = arg0.currentPoint.id
			local var1 = arg0.currentPoint.nexts
			local var2 = var1[math.random(1, #var1)]

			if arg0.onTransEdge and var2 then
				arg0.targetPoint = arg0.pathFinder:getPoint(var2)

				arg0.onTransEdge(arg0, var0, var2)
			end

			arg0:updateState(var0.ShipState.Idle)
		end))
	elseif arg0.state == var0.ShipState.Idle then
		if arg0.posTable[arg0.currentPoint.id] == nil then
			arg0.posTable[arg0.currentPoint.id] = arg0
		else
			arg0:updateState(var0.ShipState.Walk)

			return
		end

		if arg0.currentPoint.isBan then
			arg0:updateState(var0.ShipState.Walk)

			return
		end

		local var5 = math.random(10, 20)

		arg0.idleTimer = Timer.New(function()
			arg0:updateState(var0.ShipState.Walk)
		end, var5, 1)

		arg0.idleTimer:Start()
	elseif arg0.state == var0.ShipState.Touch then
		arg0:onClickShip()
	end
end

function var0.GetBeziersPoints(arg0, arg1, arg2, arg3)
	local var0 = arg0:Clone():Mul((1 - arg3) * (1 - arg3))
	local var1 = arg2:Clone():Mul(2 * arg3 * (1 - arg3))
	local var2 = arg1:Clone():Mul(arg3 * arg3)

	return var0:Add(var1):Add(var2)
end

return var0
