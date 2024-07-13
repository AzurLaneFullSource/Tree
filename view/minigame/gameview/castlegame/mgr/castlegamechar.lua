local var0_0 = class("CastleGameChar")
local var1_0 = Vector3(0, 0)
local var2_0 = "qiye_6_SkeletonData"
local var3_0 = 3
local var4_0 = "activity_run"
local var5_0 = "walk"
local var6_0 = "activity_wait"
local var7_0 = "tuozhuai2"
local var8_0 = "tuozhuai2"
local var9_0 = "dead"
local var10_0 = Vector3(0, 0, -1)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._charTpl = arg1_1
	arg0_1._event = arg2_1

	arg0_1:initChar()
end

function var0_0.initChar(arg0_2)
	if arg0_2.char then
		return
	end

	arg0_2.charTf = tf(instantiate(arg0_2._charTpl))
	arg0_2.speed = Vector3(0, 0, 0)
	arg0_2.colliderTf = findTF(arg0_2.charTf, "zPos/collider")
	arg0_2.collider = GetComponent(arg0_2.colliderTf, typeof(BoxCollider2D))
	arg0_2.zPos = findTF(arg0_2.charTf, "zPos")
	arg0_2.raycastPoints = {}

	for iter0_2 = 1, var3_0 do
		table.insert(arg0_2.raycastPoints, Vector3(0, 0, 0))
	end

	CastleGameVo.LoadSkeletonData(var2_0, function(arg0_3)
		arg0_3.transform.localScale = Vector3(1, 1, 1)
		arg0_3.transform.localPosition = Vector3(0, 0, 0)

		arg0_3:SetActive(true)
		SetParent(tf(arg0_3), findTF(arg0_2.charTf, "zPos/char"))

		arg0_2.graphic = arg0_3:GetComponent("SkeletonGraphic")
		arg0_2.anim = arg0_3:GetComponent(typeof(SpineAnimUI))
		arg0_2.charTf.anchoredPosition = var1_0
		arg0_2.zPos.anchoredPosition = Vector2(0, var1_0.z)
	end)

	arg0_2.char = {
		tf = arg0_2.charTf,
		bound = {}
	}
end

function var0_0.setInGround(arg0_4, arg1_4)
	arg0_4.inGround = arg1_4

	if not arg0_4.inGround then
		arg0_4.speed = Vector3(0, 0, 0)
	end

	if arg0_4.char.floor then
		local var0_4 = arg0_4.char.floor.tf

		arg0_4:setContent(findTF(var0_4, "zPos/top"))
	end
end

function var0_0.setOutLandPoint(arg0_5, arg1_5)
	arg0_5.outlandPoint = arg1_5

	local var0_5 = arg0_5.outlandPoint.lb
	local var1_5 = arg0_5.outlandPoint.lt
	local var2_5 = arg0_5.outlandPoint.rt
	local var3_5 = arg0_5.outlandPoint.rb
	local var4_5 = 2
	local var5_5 = Vector2(var0_5.x + var4_5, var0_5.y)
	local var6_5 = Vector2(var1_5.x, var1_5.y - var4_5)
	local var7_5 = Vector2(var2_5.x - var4_5, var2_5.y)
	local var8_5 = Vector2(var3_5.x, var3_5.y + var4_5)

	arg0_5.outlandPoint.exlb = var5_5
	arg0_5.outlandPoint.exlt = var6_5
	arg0_5.outlandPoint.exrt = var7_5
	arg0_5.outlandPoint.exrb = var8_5
end

function var0_0.step(arg0_6)
	if arg0_6.timeToOver and arg0_6.timeToOver > 0 then
		arg0_6.timeToOver = arg0_6.timeToOver - CastleGameVo.deltaTime

		if arg0_6.timeToOver <= 0 then
			arg0_6.timeToOver = nil

			arg0_6._event:emit(CastleGameView.GAME_OVER)
		end
	end

	arg0_6:updateSpeed()
	arg0_6:updatePosition()
	arg0_6:updateAnim()
	arg0_6:checkPlayerOutScreen()
end

function var0_0.getPoint(arg0_7)
	if arg0_7.charTf then
		return nil
	end

	return arg0_7.charTf.anchoredPosition
end

function var0_0.updatePosition(arg0_8)
	local var0_8 = arg0_8.charTf.anchoredPosition
	local var1_8 = arg0_8.zPos.anchoredPosition

	var0_8.x = var0_8.x + arg0_8.speed.x * CastleGameVo.deltaTime
	var0_8.y = var0_8.y + arg0_8.speed.y * CastleGameVo.deltaTime

	local var2_8, var3_8 = arg0_8:checkOutland(var0_8)

	if var2_8 and var3_8 then
		arg0_8.charTf.anchoredPosition = var3_8

		arg0_8:updateDirect(var3_8)
	end

	var1_8.y = var1_8.y + arg0_8.speed.z * CastleGameVo.deltaTime
	arg0_8.zPos.anchoredPosition = var1_8
end

function var0_0.updateDirect(arg0_9, arg1_9)
	if arg1_9.x ~= 0 then
		local var0_9 = arg0_9.speed.x > 0 and 1 or -1

		if arg0_9.charTf.localScale.x ~= var0_9 then
			arg0_9.charTf.localScale = Vector3(var0_9, 1, 1)
			arg0_9.charDirect = var0_9
		end
	end
end

function var0_0.checkOutland(arg0_10, arg1_10, arg2_10)
	if arg0_10.outlandPoint then
		local var0_10 = arg0_10.outlandPoint.lb
		local var1_10 = arg0_10.outlandPoint.lt
		local var2_10 = arg0_10.outlandPoint.rt
		local var3_10 = arg0_10.outlandPoint.rb
		local var4_10 = arg0_10.outlandPoint.exlb
		local var5_10 = arg0_10.outlandPoint.exlt
		local var6_10 = arg0_10.outlandPoint.exrt
		local var7_10 = arg0_10.outlandPoint.exrb

		if CastleGameVo.PointLeftLine(arg1_10, var0_10, var1_10) then
			local var8_10, var9_10 = CastleGameVo.PointFootLine(arg1_10, var4_10, var5_10)

			if var9_10 then
				return arg0_10:checkOutland(var8_10, var9_10)
			else
				return false
			end
		end

		if CastleGameVo.PointLeftLine(arg1_10, var3_10, var0_10) then
			local var10_10, var11_10 = CastleGameVo.PointFootLine(arg1_10, var7_10, var4_10)

			if var11_10 then
				return arg0_10:checkOutland(var10_10)
			else
				return false
			end
		end

		if CastleGameVo.PointLeftLine(arg1_10, var1_10, var2_10) then
			local var12_10, var13_10 = CastleGameVo.PointFootLine(arg1_10, var5_10, var6_10)

			if var13_10 then
				return arg0_10:checkOutland(var12_10)
			else
				return false
			end
		end

		if CastleGameVo.PointLeftLine(arg1_10, var2_10, var3_10) then
			local var14_10, var15_10 = CastleGameVo.PointFootLine(arg1_10, var6_10, var7_10)

			if var15_10 then
				return arg0_10:checkOutland(var14_10)
			else
				return false
			end
		end
	end

	return true, arg1_10
end

function var0_0.updateSpeed(arg0_11)
	if arg0_11.addSpeedTime and arg0_11.addSpeedTime > 0 then
		arg0_11.addSpeedTime = arg0_11.addSpeedTime - CastleGameVo.deltaTime

		if arg0_11.addSpeedTime <= 0 then
			arg0_11.addSpeedTime = nil
			arg0_11.addSpeed = 0
		end
	end

	if not arg0_11.inGround then
		arg0_11.speed.z = arg0_11.speed.z > -1500 and arg0_11.speed.z - 20 or -1500
	elseif arg0_11.inBubble then
		arg0_11.speed.x = 0
		arg0_11.speed.y = 0
		arg0_11.speed.z = 0

		print("角色在气泡中，无法移动")
	elseif arg0_11.fail then
		arg0_11.speed.x = 0
		arg0_11.speed.y = 0
		arg0_11.speed.z = 0

		print("被车撞了，无法移动")
	elseif CastleGameVo.joyStickData then
		local var0_11 = CastleGameVo.joyStickData
		local var1_11 = var0_11.x
		local var2_11 = var0_11.y

		arg0_11.speed.x = var0_11.x * (CastleGameVo.char_speed + arg0_11.addSpeed)
		arg0_11.speed.y = var0_11.y * (CastleGameVo.char_speed + arg0_11.addSpeed)
		arg0_11.speed.x = math.abs(arg0_11.speed.x) < CastleGameVo.char_speed_min and 0 or arg0_11.speed.x
		arg0_11.speed.y = math.abs(arg0_11.speed.y) < CastleGameVo.char_speed_min and 0 or arg0_11.speed.y

		arg0_11:updateDirect(arg0_11.speed)
	else
		arg0_11.speed.x = 0
		arg0_11.speed.y = 0
	end
end

function var0_0.updateAnim(arg0_12)
	local var0_12

	if not arg0_12.inGround then
		var0_12 = var7_0
	elseif arg0_12.inBubble then
		var0_12 = var8_0
	elseif arg0_12.fail then
		var0_12 = var9_0
	else
		local var1_12 = math.max(math.abs(arg0_12.speed.x), math.abs(arg0_12.speed.y))

		if var1_12 > 120 then
			var0_12 = var4_0
		elseif var1_12 > 0 then
			var0_12 = var5_0
		else
			var0_12 = var6_0
		end
	end

	if arg0_12.action ~= var0_12 then
		arg0_12:changeAnimAction(arg0_12.anim, var0_12, 0)
	end
end

function var0_0.setScore(arg0_13, arg1_13)
	local var0_13 = arg1_13.data.speed
	local var1_13 = arg1_13.data.time

	if var0_13 >= arg0_13.addSpeed then
		arg0_13.addSpeed = var0_13
	end

	arg0_13.addSpeedTime = var1_13
end

function var0_0.setPlayerFail(arg0_14)
	arg0_14.fail = true
	arg0_14.timeToOver = 1

	arg0_14:playerDead()
end

function var0_0.setContent(arg0_15, arg1_15, arg2_15)
	arg0_15._content = arg1_15

	setParent(arg0_15.charTf, arg0_15._content, true)

	arg0_15.charTf.localScale = Vector3(1, 1, 1)

	if arg2_15 then
		arg0_15.charTf.anchoredPosition = arg2_15
	end
end

function var0_0.getPoint(arg0_16)
	return arg0_16.charTf.anchoredPosition
end

function var0_0.start(arg0_17)
	arg0_17.charTf.anchoredPosition = var1_0
	arg0_17.zPos.anchoredPosition = Vector2(0, var1_0.y)

	setActive(arg0_17.charTf, true)

	arg0_17.inGround = true
	arg0_17.inBubble = false
	arg0_17.fail = false
	arg0_17.timeToOver = nil
	arg0_17.speed = Vector3(0, 0, 0)
	arg0_17.addSpeed = 0
	arg0_17.addSpeedTime = 0

	arg0_17:changeAnimAction(arg0_17.anim, var6_0, 0)
end

function var0_0.clear(arg0_18)
	return
end

function var0_0.checkPlayerOutScreen(arg0_19)
	if math.abs(arg0_19.zPos.anchoredPosition.y) > 2000 then
		arg0_19._event:emit(CastleGameView.GAME_OVER)
	end
end

function var0_0.setInBubble(arg0_20, arg1_20)
	arg0_20.inBubble = arg1_20

	if arg1_20 then
		arg0_20.lastBubblePos = arg0_20.char.tf.anchoredPosition
	else
		arg0_20.char.tf.anchoredPosition = arg0_20.lastBubblePos
	end
end

function var0_0.getActionAble(arg0_21)
	if not arg0_21.inGround then
		return false
	end

	if arg0_21.inBubble then
		return false
	end

	if arg0_21.fail then
		return false
	end

	return true
end

function var0_0.press(arg0_22, arg1_22)
	return
end

function var0_0.playerDead(arg0_23)
	arg0_23.action = var9_0

	arg0_23.anim:GetAnimationState():SetAnimation(0, var9_0, false)
end

function var0_0.changeAnimAction(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24, arg5_24)
	arg0_24.action = arg2_24

	arg1_24:SetActionCallBack(nil)
	arg1_24:SetAction(arg2_24, 0)
	arg1_24:SetActionCallBack(function(arg0_25)
		if arg0_25 == "finish" then
			if arg3_24 == 1 then
				arg1_24:SetActionCallBack(nil)
			end

			if arg5_24 then
				arg5_24()
			end
		end
	end)

	if arg3_24 ~= 1 and arg5_24 then
		arg5_24()
	end
end

function var0_0.getChar(arg0_26)
	return arg0_26.char
end

function var0_0.getTfs(arg0_27)
	return {
		arg0_27.charTf
	}
end

return var0_0
