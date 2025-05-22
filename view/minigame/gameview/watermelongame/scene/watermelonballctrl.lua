local var0_0 = class("WatermelonBallCtrl")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._content = arg1_1
	arg0_1._contextData = arg2_1
	arg0_1._event = arg3_1
	arg0_1._startPos = findTF(arg0_1._content, "start_pos")
	arg0_1._rayTf = findTF(arg0_1._startPos, "ray")
	arg0_1._left = findTF(arg0_1._content, "left")
	arg0_1._right = findTF(arg0_1._content, "right")
	arg0_1._container = findTF(arg0_1._content, "container")
	arg0_1._megerEffect = findTF(arg0_1._content, "meger_effect")

	if arg0_1._megerEffect then
		setActive(arg0_1._megerEffect, false)
	end

	arg0_1._tempRect = findTF(arg0_1._container, "temp_rect")
	arg0_1.leftPos = arg0_1._left.anchoredPosition.x
	arg0_1.rightPos = arg0_1._right.anchoredPosition.x
	arg0_1._balls = {}
	arg0_1._layerMask = LayerMask.GetMask("UI")

	print("log ball ctrl init complete")
end

function var0_0.setGameVo(arg0_2, arg1_2)
	arg0_2._gameVo = arg1_2
end

function var0_0.start(arg0_3)
	arg0_3:clear()

	arg0_3.createBallCd = 0
	arg0_3.nextBallId = nil
end

function var0_0.step(arg0_4, arg1_4)
	if not arg0_4.nextBallId then
		arg0_4.nextBallId = arg0_4:getRandomIdByWeight()

		arg0_4._event:emit(WatermelonGameEvent.UPDATE_NEXT_BALL, arg0_4.nextBallId)
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

		local var0_4 = Physics2D.Raycast(arg0_4._startPos.position, Vector2(0, -1))

		if var0_4 and var0_4.transform then
			local var1_4 = arg0_4._startPos:InverseTransformPoint(Vector2(var0_4.point.x, var0_4.point.y, 0))

			arg0_4._rayTf.sizeDelta = Vector2(arg0_4._rayTf.sizeDelta.x, math.abs(var1_4.y))
		end
	end

	local var2_4 = arg0_4.readyBall and true or false

	if isActive(arg0_4._rayTf) ~= var2_4 then
		setActive(arg0_4._rayTf, var2_4)
	end

	if arg0_4.tickToOver then
		arg0_4.tickToOver = arg0_4.tickToOver - arg1_4

		if arg0_4.tickToOver and arg0_4.tickToOver <= 0 then
			arg0_4._event:emit(WatermelonGameEvent.GAME_OVER, true)

			arg0_4.tickToOver = nil
		end
	end
end

function var0_0.clear(arg0_5)
	arg0_5.countId = WatermelonGameConst.ball_count_id
	arg0_5.tickToOver = nil

	setActive(arg0_5._megerEffect, false)
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

function var0_0.moveWorld(arg0_9, arg1_9)
	if arg0_9.readyBall then
		local var0_9 = arg0_9._content:InverseTransformPoint(arg1_9.pos)

		if var0_9.x < arg0_9.leftPos + arg0_9.readyBall.size then
			var0_9.x = arg0_9.leftPos + arg0_9.readyBall.size
		elseif var0_9.x > arg0_9.rightPos - arg0_9.readyBall.size then
			var0_9.x = arg0_9.rightPos - arg0_9.readyBall.size
		end

		arg0_9._startPos.anchoredPosition = Vector2(var0_9.x, arg0_9._startPos.anchoredPosition.y)

		if arg1_9.callback then
			arg1_9.callback(true)
		end
	elseif arg1_9.callback then
		arg1_9.callback(false)
	end
end

function var0_0.move(arg0_10, arg1_10)
	if not arg0_10.readyBall then
		return
	end

	local var0_10 = arg0_10._startPos.anchoredPosition

	if arg1_10 > 0 then
		var0_10.x = var0_10.x + arg0_10._gameVo.deltaTime * 300
	elseif arg1_10 < 0 then
		var0_10.x = var0_10.x - arg0_10._gameVo.deltaTime * 300
	end

	if var0_10.x < arg0_10.leftPos + arg0_10.readyBall.size then
		var0_10.x = arg0_10.leftPos + arg0_10.readyBall.size
	elseif var0_10.x > arg0_10.rightPos - arg0_10.readyBall.size then
		var0_10.x = arg0_10.rightPos - arg0_10.readyBall.size
	end

	arg0_10._startPos.anchoredPosition = var0_10
end

function var0_0.dropBall(arg0_11)
	if arg0_11.readyBall then
		arg0_11:setBallPhysics(arg0_11.readyBall, true)
		table.insert(arg0_11._balls, arg0_11.readyBall)

		arg0_11.readyBall = nil

		arg0_11:setCreateCd()
	end
end

function var0_0.createReadyBall(arg0_12)
	local var0_12, var1_12 = arg0_12._gameVo:getTplItemFromPool("ball", arg0_12._container)

	arg0_12._startPos.anchoredPosition = Vector2(0, arg0_12._startPos.anchoredPosition.y)
	var0_12.anchoredPosition = arg0_12._startPos.anchoredPosition

	local var2_12 = arg0_12:initBallData(var0_12, arg0_12.nextBallId)

	arg0_12.nextBallId = nil
	arg0_12.readyBall = var2_12

	if var1_12 then
		arg0_12:setBallEvent(var2_12)
	end

	arg0_12:setBallPhysics(arg0_12.readyBall, false)
end

function var0_0.createMegerBall(arg0_13, arg1_13, arg2_13)
	local var0_13, var1_13 = arg0_13._gameVo:getTplItemFromPool("ball", arg0_13._container)

	var0_13.position = Vector3(arg2_13.x, arg2_13.y, 0)

	if arg0_13._megerEffect then
		arg0_13._megerEffect.position = var0_13.position

		setActive(arg0_13._megerEffect, false)
		setActive(arg0_13._megerEffect, true)
	end

	local var2_13 = arg0_13:initBallData(var0_13, arg1_13)

	if var1_13 then
		arg0_13:setBallEvent(var2_13)
	end

	table.insert(arg0_13._balls, var2_13)
end

function var0_0.setBallEvent(arg0_14, arg1_14)
	arg0_14.physics2DItem = GetComponent(arg1_14.tf, "Physics2DItem")

	arg0_14.physics2DItem.CollisionEnter:AddListener(function(arg0_15)
		arg0_14:checkCollisionBall(arg0_15)
	end)
	arg0_14.physics2DItem.TriggerEnter:AddListener(function(arg0_16)
		arg0_14:checkCollisionTop(arg0_16, true)
	end)
	arg0_14.physics2DItem.TriggerExit:AddListener(function(arg0_17)
		arg0_14:checkCollisionTop(arg0_17, false)
	end)
end

function var0_0.checkCollisionBall(arg0_18, arg1_18)
	local var0_18 = arg0_18:getBallByName(arg1_18.collider.transform.name)
	local var1_18 = arg0_18:getBallByName(arg1_18.otherCollider.transform.name)

	if arg0_18:checkColliderBall(var0_18, var1_18) and var0_18.next and var1_18.next then
		arg0_18:removeBall(var0_18)
		arg0_18:removeBall(var1_18)

		local var2_18 = var0_18.next
		local var3_18 = arg1_18:GetContact(0)

		arg0_18:createMegerBall(var2_18, var3_18.point)
		arg0_18._event:emit(WatermelonGameEvent.ADD_SCORE, {
			num = WatermelonGameConst.ball_data[var2_18].score
		})
	end
end

function var0_0.checkCollisionTop(arg0_19, arg1_19, arg2_19)
	print(arg1_19.transform.name)

	if arg1_19.transform.name == "top" then
		if arg2_19 then
			if not arg0_19.tickToOver then
				arg0_19.tickToOver = WatermelonGameConst.enter_top_over_time
			end
		else
			arg0_19.tickToOver = nil
		end
	end
end

function var0_0.setBallPhysics(arg0_20, arg1_20, arg2_20)
	GetComponent(arg1_20.tf, "Rigidbody2D").simulated = arg2_20
end

function var0_0.removeBall(arg0_21, arg1_21)
	for iter0_21 = #arg0_21._balls, 1, -1 do
		if arg0_21._balls[iter0_21] == arg1_21 then
			local var0_21 = table.remove(arg0_21._balls, iter0_21)

			arg0_21._gameVo:returnTplItem("ball", var0_21.tf)

			return true
		end
	end

	print("移除ball失败 name = " .. arg1_21.name)

	return false
end

function var0_0.checkColliderBall(arg0_22, arg1_22, arg2_22)
	if arg1_22 and arg2_22 and arg1_22.id == arg2_22.id and arg1_22.next and arg2_22.next then
		return true
	end

	return false
end

function var0_0.getBallByName(arg0_23, arg1_23)
	for iter0_23 = 1, #arg0_23._balls do
		local var0_23 = arg0_23._balls[iter0_23]

		if var0_23.name == arg1_23 then
			return var0_23
		end
	end

	return nil
end

function var0_0.clearBallContainer(arg0_24)
	for iter0_24 = 1, #arg0_24._balls do
		arg0_24._gameVo:returnTplItem("ball", arg0_24._balls[iter0_24].tf)
	end

	arg0_24._balls = {}
end

function var0_0.setCreateCd(arg0_25)
	arg0_25.createBallCd = arg0_25._gameVo.createBallCd
end

function var0_0.initBallData(arg0_26, arg1_26, arg2_26)
	setActive(arg1_26, true)

	local var0_26 = arg2_26 and arg2_26 or arg0_26:getRandomIdByWeight()
	local var1_26 = WatermelonGameConst.ball_data[var0_26]
	local var2_26 = GetComponent(arg1_26, typeof(UnityEngine.CircleCollider2D))
	local var3_26 = GetComponent(arg1_26, "Rigidbody2D")

	var2_26.radius = var1_26.size

	arg0_26:setChildVisible(findTF(arg1_26, "size_image"), false)
	setActive(findTF(arg1_26, "size_image/" .. var0_26), true)

	arg0_26.countId = arg0_26.countId + 1
	arg1_26.name = "ball_" .. arg0_26.countId

	return {
		id = var1_26.id,
		tf = arg1_26,
		rigidbody = var3_26,
		count = arg0_26.countId,
		name = arg1_26.name,
		next = var1_26.next_id,
		size = var1_26.size
	}
end

function var0_0.getRandomIdByWeight(arg0_27)
	if not arg0_27.weightTotal then
		arg0_27.weightTotal = 0
		arg0_27.weightList = {}
		arg0_27.weightIdList = {}

		for iter0_27 = 1, #WatermelonGameConst.drop_ball_ids do
			arg0_27.weightTotal = arg0_27.weightTotal + WatermelonGameConst.drop_ball_ids[iter0_27].weight

			table.insert(arg0_27.weightList, arg0_27.weightTotal)
			table.insert(arg0_27.weightIdList, WatermelonGameConst.drop_ball_ids[iter0_27].id)
		end
	end

	local var0_27 = math.random(1, arg0_27.weightTotal)

	for iter1_27 = 1, #arg0_27.weightList do
		if var0_27 <= arg0_27.weightList[iter1_27] or iter1_27 == #arg0_27.weightList then
			return arg0_27.weightIdList[iter1_27]
		end
	end

	return nil
end

function var0_0.setChildVisible(arg0_28, arg1_28, arg2_28)
	for iter0_28 = 1, arg1_28.childCount do
		local var0_28 = arg1_28:GetChild(iter0_28 - 1)

		setActive(var0_28, arg2_28)
	end
end

function var0_0.dispose(arg0_29)
	return
end

return var0_0
