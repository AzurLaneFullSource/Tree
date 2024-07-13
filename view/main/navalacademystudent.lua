local var0_0 = class("NavalAcademyStudent")

var0_0.ShipState = {
	Walk = "Walk",
	Idle = "Idle",
	Touch = "Touch"
}
var0_0.normalSpeed = 15

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform

	arg0_1:init()
end

function var0_0.init(arg0_2)
	arg0_2.chat = arg0_2._tf:Find("chat")
	arg0_2.chatFace = arg0_2.chat:Find("face")
	arg0_2.chatTask = arg0_2.chat:Find("task")
	arg0_2.chatFight = arg0_2.chat:Find("fight")
	arg0_2.clickArea = arg0_2._tf:Find("click")

	setActive(arg0_2.chat, true)
	setActive(arg0_2.clickArea, true)
end

function var0_0.attach(arg0_3)
	arg0_3.exited = false

	setActive(arg0_3._go, true)
	pg.DelegateInfo.New(arg0_3)
end

function var0_0.setPathFinder(arg0_4, arg1_4)
	arg0_4.pathFinder = arg1_4
end

function var0_0.setCallBack(arg0_5, arg1_5, arg2_5)
	arg0_5.onStateChange = arg1_5
	arg0_5.onTask = arg2_5
end

function var0_0.updateStudent(arg0_6, arg1_6, arg2_6)
	if arg1_6.hide then
		setActive(arg0_6._go, false)

		return
	end

	setActive(arg0_6._go, true)

	if arg0_6.shipVO == nil or arg0_6.shipVO.configId ~= arg1_6.configId then
		if not IsNil(arg0_6.model) then
			PoolMgr.GetInstance():ReturnSpineChar(arg0_6.prefab, arg0_6.model)
		end

		arg0_6.prefab = arg1_6:getPrefab()
		arg0_6.currentPoint = arg0_6.pathFinder:getRandomPoint()

		local var0_6 = arg0_6.currentPoint.nexts
		local var1_6 = var0_6[math.random(1, #var0_6)]

		arg0_6.targetPoint = arg0_6.pathFinder:getPoint(var1_6)
		arg0_6._tf.anchoredPosition = Vector2.New(arg0_6.currentPoint.x, arg0_6.currentPoint.y)

		local var2_6 = arg0_6.prefab

		PoolMgr.GetInstance():GetSpineChar(var2_6, true, function(arg0_7)
			if var2_6 ~= arg0_6.prefab then
				PoolMgr.GetInstance():ReturnSpineChar(var2_6, arg0_7)

				return
			end

			arg0_6.model = arg0_7
			arg0_6.model.transform.localScale = Vector3(0.5, 0.5, 1)
			arg0_6.model.transform.localPosition = Vector3.zero

			arg0_6.model.transform:SetParent(arg0_6._tf, false)
			arg0_6.model.transform:SetSiblingIndex(1)

			arg0_6.anim = arg0_6.model:GetComponent(typeof(SpineAnimUI))

			arg0_6:updateState(var0_0.ShipState.Idle)
			onButton(arg0_6, arg0_6.chat, function()
				arg0_6:onClickShip()
			end)
		end)
	end

	onButton(arg0_6, arg0_6.clickArea, function()
		if not IsNil(arg0_6.model) then
			arg0_6:updateState(var0_0.ShipState.Touch)
		end
	end)

	arg0_6.shipVO = arg1_6
	arg0_6.args = arg2_6

	setActive(arg0_6.chatFace, false)
	setActive(arg0_6.chatTask, false)
	setActive(arg0_6.chatFight, false)

	if arg0_6.shipVO.withShipFace then
		if arg2_6.showTips then
			setActive(arg0_6.chatTask, true)
		elseif arg2_6.currentTask and not arg2_6.currentTask:isFinish() and arg2_6.currentTask:getConfig("sub_type") == 29 then
			setActive(arg0_6.chatFight, true)
		else
			setActive(arg0_6.chatFace, true)
		end
	end
end

function var0_0.updateState(arg0_10, arg1_10)
	if arg0_10.state ~= arg1_10 then
		arg0_10.state = arg1_10

		arg0_10:updateAction()
		arg0_10:updateLogic()

		if arg0_10.onStateChange then
			arg0_10.onStateChange(arg0_10.state)
		end
	end
end

function var0_0.updateAction(arg0_11)
	if not IsNil(arg0_11.anim) then
		if arg0_11.state == var0_0.ShipState.Walk then
			arg0_11.anim:SetAction("walk", 0)
		elseif arg0_11.state == var0_0.ShipState.Idle then
			arg0_11.anim:SetAction("stand2", 0)
		elseif arg0_11.state == var0_0.ShipState.Touch then
			arg0_11.anim:SetAction("touch", 0)
			arg0_11.anim:SetActionCallBack(function(arg0_12)
				arg0_11:updateState(var0_0.ShipState.Idle)
			end)
		end
	end
end

function var0_0.updateLogic(arg0_13)
	arg0_13:clearLogic()

	if arg0_13.state == var0_0.ShipState.Walk then
		local var0_13 = Vector3(arg0_13._tf.anchoredPosition.x, arg0_13._tf.anchoredPosition.y, 0)
		local var1_13 = Vector3(arg0_13.targetPoint.x, arg0_13.targetPoint.y, 0)
		local var2_13 = arg0_13.normalSpeed
		local var3_13 = Vector3.Distance(var0_13, var1_13) / var2_13

		LeanTween.value(arg0_13._go, 0, 1, var3_13):setOnUpdate(System.Action_float(function(arg0_14)
			arg0_13._tf.anchoredPosition3D = Vector3.Lerp(var0_13, var1_13, arg0_14)

			local var0_14 = arg0_13._tf.localScale
			local var1_14 = arg0_13.targetPoint.x > arg0_13.currentPoint.x and 1 or -1

			var0_14.x = var1_14
			arg0_13._tf.localScale = var0_14

			local var2_14 = arg0_13.chat.localScale

			var2_14.x = var1_14
			arg0_13.chat.localScale = var2_14

			local var3_14 = arg0_13.chat.anchoredPosition

			var3_14.x = var1_14 * math.abs(var3_14.x)
			arg0_13.chat.anchoredPosition = var3_14
		end)):setOnComplete(System.Action(function()
			arg0_13.currentPoint = arg0_13.targetPoint

			local var0_15 = arg0_13.currentPoint.nexts
			local var1_15 = var0_15[math.random(1, #var0_15)]

			arg0_13.targetPoint = arg0_13.pathFinder:getPoint(var1_15)

			arg0_13:updateState(var0_0.ShipState.Idle)
		end))
	elseif arg0_13.state == var0_0.ShipState.Idle then
		arg0_13.idleTimer = Timer.New(function()
			arg0_13:updateState(var0_0.ShipState.Walk)
		end, math.random(10, 20), 1)

		arg0_13.idleTimer:Start()
	elseif arg0_13.state == var0_0.ShipState.Touch then
		arg0_13:onClickShip()
	end
end

function var0_0.onClickShip(arg0_17)
	if arg0_17.onTask then
		arg0_17.onTask(arg0_17.acceptTaskId, arg0_17.currentTask)
	end
end

function var0_0.clearLogic(arg0_18)
	LeanTween.cancel(arg0_18._go)

	if arg0_18.idleTimer then
		arg0_18.idleTimer:Stop()

		arg0_18.idleTimer = nil
	end
end

function var0_0.clear(arg0_19)
	arg0_19:clearLogic()

	if not IsNil(arg0_19.model) then
		arg0_19.anim:SetActionCallBack(nil)

		arg0_19.model.transform.localScale = Vector3.one

		PoolMgr.GetInstance():ReturnSpineChar(arg0_19.prefab, arg0_19.model)
	end

	arg0_19.shipVO = nil
	arg0_19.prefab = nil
	arg0_19.model = nil
	arg0_19.anim = nil
	arg0_19.position = nil
	arg0_19.currentPoint = nil
	arg0_19.targetPoint = nil
	arg0_19.state = nil
end

function var0_0.detach(arg0_20)
	if not arg0_20.exited then
		setActive(arg0_20._go, false)
		pg.DelegateInfo.Dispose(arg0_20)
		arg0_20:clear()

		arg0_20.exited = true
	end
end

return var0_0
