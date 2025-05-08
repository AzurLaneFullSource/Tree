local var0_0 = class("WatermelonBallCtrl")

var0_0.ball_data = {
	{
		id = 1,
		size = 35,
		next_id = 2
	},
	{
		id = 2,
		size = 50,
		next_id = 3
	},
	{
		id = 3,
		size = 65,
		next_id = 4
	},
	{
		id = 4,
		size = 80,
		next_id = 5
	},
	{
		id = 5,
		size = 95,
		next_id = 6
	},
	{
		id = 6,
		size = 110,
		next_id = 7
	},
	{
		id = 7,
		size = 125,
		next_id = 8
	},
	{
		id = 8,
		size = 140,
		next_id = 9
	},
	{
		id = 9,
		size = 155,
		next_id = 10
	},
	{
		id = 10,
		size = 170
	}
}
var0_0.drop_ball_ids = {
	{
		id = 1,
		weight = 30
	},
	{
		id = 2,
		weight = 40
	},
	{
		id = 3,
		weight = 20
	},
	{
		id = 4,
		weight = 10
	}
}
var0_0.tpl_ball = "ball"
var0_0.ball_count_id = 0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._content = arg1_1
	arg0_1._contextData = arg2_1
	arg0_1._event = arg3_1
	arg0_1._startPos = findTF(arg0_1._content, "start_pos")
	arg0_1._rayTf = findTF(arg0_1._startPos, "ray")
	arg0_1._left = findTF(arg0_1._content, "left")
	arg0_1._right = findTF(arg0_1._content, "right")
	arg0_1._container = findTF(arg0_1._content, "container")
	arg0_1._tempRect = findTF(arg0_1._container, "temp_rect")
	arg0_1.leftPos = arg0_1._left.anchoredPosition.x
	arg0_1.rightPos = arg0_1._right.anchoredPosition.x
	arg0_1._balls = {}
	arg0_1._layerMask = LayerMask.GetMask("UI")
end

function var0_0.setGameVo(arg0_2, arg1_2)
	arg0_2._gameVo = arg1_2
end

function var0_0.start(arg0_3)
	arg0_3:clear()

	arg0_3.createBallCd = 0
end

function var0_0.step(arg0_4, arg1_4)
	local var0_4 = arg0_4._gameVo:getJoyStickData()

	if var0_4 and var0_4.active and var0_4.directX and var0_4.directX ~= 0 then
		arg0_4:move(var0_4.directX)
	end

	if not arg0_4.readyBall then
		if not arg0_4.createBallCd then
			arg0_4:setCreateCd()
		end

		if arg0_4.createBallCd and arg0_4.createBallCd >= 0 then
			arg0_4.createBallCd = arg0_4.createBallCd - arg0_4._gameVo.deltaTime

			if arg0_4.createBallCd <= 0 then
				arg0_4.createBallCd = nil

				arg0_4:createReadyBall()
			end
		end
	else
		arg0_4.readyBall.tf.anchoredPosition = arg0_4._startPos.anchoredPosition

		local var1_4 = Physics2D.Raycast(arg0_4._startPos.position, Vector2(0, -1))

		if var1_4 and var1_4.transform then
			local var2_4 = arg0_4._startPos:InverseTransformPoint(Vector2(var1_4.point.x, var1_4.point.y, 0))

			arg0_4._rayTf.sizeDelta = Vector2(arg0_4._rayTf.sizeDelta.x, math.abs(var2_4.y))
		end
	end

	local var3_4 = arg0_4.readyBall and true or false

	if isActive(arg0_4._rayTf) ~= var3_4 then
		setActive(arg0_4._rayTf, var3_4)
	end
end

function var0_0.clear(arg0_5)
	arg0_5.countId = WatermelonBallCtrl.ball_count_id

	arg0_5:clearBallContainer()
end

function var0_0.stop(arg0_6)
	return
end

function var0_0.resume(arg0_7)
	return
end

function var0_0.dispose(arg0_8)
	return
end

function var0_0.move(arg0_9, arg1_9)
	if not arg0_9.readyBall then
		return
	end

	local var0_9 = arg0_9._startPos.anchoredPosition

	if arg1_9 > 0 then
		var0_9.x = var0_9.x + arg0_9._gameVo.deltaTime * 200
		arg0_9._startPos.anchoredPosition = var0_9
	elseif arg1_9 < 0 then
		var0_9.x = var0_9.x - arg0_9._gameVo.deltaTime * 200
		arg0_9._startPos.anchoredPosition = var0_9
	end
end

function var0_0.dropBall(arg0_10)
	if arg0_10.readyBall then
		arg0_10:setBallPhysics(arg0_10.readyBall, true)
		arg0_10:setBallEvent(arg0_10.readyBall)
		table.insert(arg0_10._balls, arg0_10.readyBall)

		arg0_10.readyBall = nil
	end
end

function var0_0.createReadyBall(arg0_11)
	local var0_11 = arg0_11._gameVo:getTplItemFromPool("ball", arg0_11._container)

	var0_11.anchoredPosition = arg0_11._startPos.anchoredPosition
	arg0_11.readyBall = arg0_11:initBallData(var0_11)

	arg0_11:setBallPhysics(arg0_11.readyBall, false)
end

function var0_0.createMegerBall(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12._gameVo:getTplItemFromPool("ball", arg0_12._container)

	var0_12.position = Vector3(arg2_12.x, arg2_12.y, 0)

	local var1_12 = arg0_12:initBallData(var0_12, arg1_12)

	table.insert(arg0_12._balls, var1_12)
	arg0_12:setBallEvent(var1_12)
end

function var0_0.setBallEvent(arg0_13, arg1_13)
	arg0_13.physicsCollision = GetComponent(arg1_13.tf, "Physics2dCollisionListener")

	arg0_13.physicsCollision:Clear()
	arg0_13.physicsCollision:SetEnterCall(System.Action_UnityEngine_Collision2D(function(arg0_14)
		local var0_14 = arg0_13:getBallByName(arg0_14.collider.transform.name)
		local var1_14 = arg0_13:getBallByName(arg0_14.otherCollider.transform.name)

		if arg0_13:checkColliderBall(var0_14, var1_14) and var0_14.next and var1_14.next then
			arg0_13:removeBall(var0_14)
			arg0_13:removeBall(var1_14)

			local var2_14 = var0_14.next
			local var3_14 = arg0_14:GetContact(0)

			arg0_13:createMegerBall(var2_14, var3_14.point)
		end
	end))
end

function var0_0.setBallPhysics(arg0_15, arg1_15, arg2_15)
	GetComponent(arg1_15.tf, "Rigidbody2D").simulated = arg2_15
end

function var0_0.removeBall(arg0_16, arg1_16)
	for iter0_16 = #arg0_16._balls, 1, -1 do
		if arg0_16._balls[iter0_16] == arg1_16 then
			local var0_16 = table.remove(arg0_16._balls, iter0_16)

			arg0_16._gameVo:returnTplItem("ball", var0_16.tf)

			return true
		end
	end

	print("移除ball失败 name = " .. arg1_16.name)

	return false
end

function var0_0.checkColliderBall(arg0_17, arg1_17, arg2_17)
	if arg1_17 and arg2_17 and arg1_17.id == arg2_17.id and arg1_17.next and arg2_17.next then
		return true
	end

	return false
end

function var0_0.getBallByName(arg0_18, arg1_18)
	for iter0_18 = 1, #arg0_18._balls do
		local var0_18 = arg0_18._balls[iter0_18]

		if var0_18.name == arg1_18 then
			return var0_18
		end
	end

	return nil
end

function var0_0.clearBallContainer(arg0_19)
	for iter0_19 = 1, #arg0_19._balls do
		arg0_19._gameVo:returnTplItem("ball", arg0_19._balls[iter0_19].tf)
	end

	arg0_19._balls = {}
end

function var0_0.setCreateCd(arg0_20)
	arg0_20.createBallCd = arg0_20._gameVo.createBallCd
end

function var0_0.initBallData(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg2_21 and arg2_21 or arg0_21:getRandomIdByWeight()
	local var1_21 = WatermelonBallCtrl.ball_data[var0_21]

	GetComponent(arg1_21, typeof(UnityEngine.CircleCollider2D)).radius = var1_21.size

	arg0_21:setChildVisible(findTF(arg1_21, "size_image"), false)
	setActive(findTF(arg1_21, "size_image/" .. var0_21), true)

	arg0_21.countId = arg0_21.countId + 1
	arg1_21.name = "ball_" .. arg0_21.countId

	setActive(arg1_21, true)

	return {
		id = var1_21.id,
		tf = arg1_21,
		count = arg0_21.countId,
		name = arg1_21.name,
		next = var1_21.next_id
	}
end

function var0_0.getRandomIdByWeight(arg0_22)
	if not arg0_22.weightTotal then
		arg0_22.weightTotal = 0
		arg0_22.weightList = {}
		arg0_22.weightIdList = {}

		for iter0_22 = 1, #WatermelonBallCtrl.drop_ball_ids do
			arg0_22.weightTotal = arg0_22.weightTotal + WatermelonBallCtrl.drop_ball_ids[iter0_22].weight

			table.insert(arg0_22.weightList, arg0_22.weightTotal)
			table.insert(arg0_22.weightIdList, WatermelonBallCtrl.drop_ball_ids[iter0_22].id)
		end
	end

	local var0_22 = math.random(1, arg0_22.weightTotal)

	for iter1_22 = 1, #arg0_22.weightList do
		if var0_22 <= arg0_22.weightList[iter1_22] or iter1_22 == #arg0_22.weightList then
			return arg0_22.weightIdList[iter1_22]
		end
	end

	return nil
end

function var0_0.setChildVisible(arg0_23, arg1_23, arg2_23)
	for iter0_23 = 1, arg1_23.childCount do
		local var0_23 = arg1_23:GetChild(iter0_23 - 1)

		setActive(var0_23, arg2_23)
	end
end

return var0_0
