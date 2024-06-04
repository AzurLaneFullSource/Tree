local var0 = class("NavalAcademyStudent")

var0.ShipState = {
	Walk = "Walk",
	Idle = "Idle",
	Touch = "Touch"
}
var0.normalSpeed = 15

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform

	arg0:init()
end

function var0.init(arg0)
	arg0.chat = arg0._tf:Find("chat")
	arg0.chatFace = arg0.chat:Find("face")
	arg0.chatTask = arg0.chat:Find("task")
	arg0.chatFight = arg0.chat:Find("fight")
	arg0.clickArea = arg0._tf:Find("click")

	setActive(arg0.chat, true)
	setActive(arg0.clickArea, true)
end

function var0.attach(arg0)
	arg0.exited = false

	setActive(arg0._go, true)
	pg.DelegateInfo.New(arg0)
end

function var0.setPathFinder(arg0, arg1)
	arg0.pathFinder = arg1
end

function var0.setCallBack(arg0, arg1, arg2)
	arg0.onStateChange = arg1
	arg0.onTask = arg2
end

function var0.updateStudent(arg0, arg1, arg2)
	if arg1.hide then
		setActive(arg0._go, false)

		return
	end

	setActive(arg0._go, true)

	if arg0.shipVO == nil or arg0.shipVO.configId ~= arg1.configId then
		if not IsNil(arg0.model) then
			PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab, arg0.model)
		end

		arg0.prefab = arg1:getPrefab()
		arg0.currentPoint = arg0.pathFinder:getRandomPoint()

		local var0 = arg0.currentPoint.nexts
		local var1 = var0[math.random(1, #var0)]

		arg0.targetPoint = arg0.pathFinder:getPoint(var1)
		arg0._tf.anchoredPosition = Vector2.New(arg0.currentPoint.x, arg0.currentPoint.y)

		local var2 = arg0.prefab

		PoolMgr.GetInstance():GetSpineChar(var2, true, function(arg0)
			if var2 ~= arg0.prefab then
				PoolMgr.GetInstance():ReturnSpineChar(var2, arg0)

				return
			end

			arg0.model = arg0
			arg0.model.transform.localScale = Vector3(0.5, 0.5, 1)
			arg0.model.transform.localPosition = Vector3.zero

			arg0.model.transform:SetParent(arg0._tf, false)
			arg0.model.transform:SetSiblingIndex(1)

			arg0.anim = arg0.model:GetComponent(typeof(SpineAnimUI))

			arg0:updateState(var0.ShipState.Idle)
			onButton(arg0, arg0.chat, function()
				arg0:onClickShip()
			end)
		end)
	end

	onButton(arg0, arg0.clickArea, function()
		if not IsNil(arg0.model) then
			arg0:updateState(var0.ShipState.Touch)
		end
	end)

	arg0.shipVO = arg1
	arg0.args = arg2

	setActive(arg0.chatFace, false)
	setActive(arg0.chatTask, false)
	setActive(arg0.chatFight, false)

	if arg0.shipVO.withShipFace then
		if arg2.showTips then
			setActive(arg0.chatTask, true)
		elseif arg2.currentTask and not arg2.currentTask:isFinish() and arg2.currentTask:getConfig("sub_type") == 29 then
			setActive(arg0.chatFight, true)
		else
			setActive(arg0.chatFace, true)
		end
	end
end

function var0.updateState(arg0, arg1)
	if arg0.state ~= arg1 then
		arg0.state = arg1

		arg0:updateAction()
		arg0:updateLogic()

		if arg0.onStateChange then
			arg0.onStateChange(arg0.state)
		end
	end
end

function var0.updateAction(arg0)
	if not IsNil(arg0.anim) then
		if arg0.state == var0.ShipState.Walk then
			arg0.anim:SetAction("walk", 0)
		elseif arg0.state == var0.ShipState.Idle then
			arg0.anim:SetAction("stand2", 0)
		elseif arg0.state == var0.ShipState.Touch then
			arg0.anim:SetAction("touch", 0)
			arg0.anim:SetActionCallBack(function(arg0)
				arg0:updateState(var0.ShipState.Idle)
			end)
		end
	end
end

function var0.updateLogic(arg0)
	arg0:clearLogic()

	if arg0.state == var0.ShipState.Walk then
		local var0 = Vector3(arg0._tf.anchoredPosition.x, arg0._tf.anchoredPosition.y, 0)
		local var1 = Vector3(arg0.targetPoint.x, arg0.targetPoint.y, 0)
		local var2 = arg0.normalSpeed
		local var3 = Vector3.Distance(var0, var1) / var2

		LeanTween.value(arg0._go, 0, 1, var3):setOnUpdate(System.Action_float(function(arg0)
			arg0._tf.anchoredPosition3D = Vector3.Lerp(var0, var1, arg0)

			local var0 = arg0._tf.localScale
			local var1 = arg0.targetPoint.x > arg0.currentPoint.x and 1 or -1

			var0.x = var1
			arg0._tf.localScale = var0

			local var2 = arg0.chat.localScale

			var2.x = var1
			arg0.chat.localScale = var2

			local var3 = arg0.chat.anchoredPosition

			var3.x = var1 * math.abs(var3.x)
			arg0.chat.anchoredPosition = var3
		end)):setOnComplete(System.Action(function()
			arg0.currentPoint = arg0.targetPoint

			local var0 = arg0.currentPoint.nexts
			local var1 = var0[math.random(1, #var0)]

			arg0.targetPoint = arg0.pathFinder:getPoint(var1)

			arg0:updateState(var0.ShipState.Idle)
		end))
	elseif arg0.state == var0.ShipState.Idle then
		arg0.idleTimer = Timer.New(function()
			arg0:updateState(var0.ShipState.Walk)
		end, math.random(10, 20), 1)

		arg0.idleTimer:Start()
	elseif arg0.state == var0.ShipState.Touch then
		arg0:onClickShip()
	end
end

function var0.onClickShip(arg0)
	if arg0.onTask then
		arg0.onTask(arg0.acceptTaskId, arg0.currentTask)
	end
end

function var0.clearLogic(arg0)
	LeanTween.cancel(arg0._go)

	if arg0.idleTimer then
		arg0.idleTimer:Stop()

		arg0.idleTimer = nil
	end
end

function var0.clear(arg0)
	arg0:clearLogic()

	if not IsNil(arg0.model) then
		arg0.anim:SetActionCallBack(nil)

		arg0.model.transform.localScale = Vector3.one

		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab, arg0.model)
	end

	arg0.shipVO = nil
	arg0.prefab = nil
	arg0.model = nil
	arg0.anim = nil
	arg0.position = nil
	arg0.currentPoint = nil
	arg0.targetPoint = nil
	arg0.state = nil
end

function var0.detach(arg0)
	if not arg0.exited then
		setActive(arg0._go, false)
		pg.DelegateInfo.Dispose(arg0)
		arg0:clear()

		arg0.exited = true
	end
end

return var0
