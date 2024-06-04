local var0 = class("CastleGameChar")
local var1 = Vector3(0, 0)
local var2 = "qiye_6_SkeletonData"
local var3 = 3
local var4 = "activity_run"
local var5 = "walk"
local var6 = "activity_wait"
local var7 = "tuozhuai2"
local var8 = "tuozhuai2"
local var9 = "dead"
local var10 = Vector3(0, 0, -1)

function var0.Ctor(arg0, arg1, arg2)
	arg0._charTpl = arg1
	arg0._event = arg2

	arg0:initChar()
end

function var0.initChar(arg0)
	if arg0.char then
		return
	end

	arg0.charTf = tf(instantiate(arg0._charTpl))
	arg0.speed = Vector3(0, 0, 0)
	arg0.colliderTf = findTF(arg0.charTf, "zPos/collider")
	arg0.collider = GetComponent(arg0.colliderTf, typeof(BoxCollider2D))
	arg0.zPos = findTF(arg0.charTf, "zPos")
	arg0.raycastPoints = {}

	for iter0 = 1, var3 do
		table.insert(arg0.raycastPoints, Vector3(0, 0, 0))
	end

	CastleGameVo.LoadSkeletonData(var2, function(arg0)
		arg0.transform.localScale = Vector3(1, 1, 1)
		arg0.transform.localPosition = Vector3(0, 0, 0)

		arg0:SetActive(true)
		SetParent(tf(arg0), findTF(arg0.charTf, "zPos/char"))

		arg0.graphic = arg0:GetComponent("SkeletonGraphic")
		arg0.anim = arg0:GetComponent(typeof(SpineAnimUI))
		arg0.charTf.anchoredPosition = var1
		arg0.zPos.anchoredPosition = Vector2(0, var1.z)
	end)

	arg0.char = {
		tf = arg0.charTf,
		bound = {}
	}
end

function var0.setInGround(arg0, arg1)
	arg0.inGround = arg1

	if not arg0.inGround then
		arg0.speed = Vector3(0, 0, 0)
	end

	if arg0.char.floor then
		local var0 = arg0.char.floor.tf

		arg0:setContent(findTF(var0, "zPos/top"))
	end
end

function var0.setOutLandPoint(arg0, arg1)
	arg0.outlandPoint = arg1

	local var0 = arg0.outlandPoint.lb
	local var1 = arg0.outlandPoint.lt
	local var2 = arg0.outlandPoint.rt
	local var3 = arg0.outlandPoint.rb
	local var4 = 2
	local var5 = Vector2(var0.x + var4, var0.y)
	local var6 = Vector2(var1.x, var1.y - var4)
	local var7 = Vector2(var2.x - var4, var2.y)
	local var8 = Vector2(var3.x, var3.y + var4)

	arg0.outlandPoint.exlb = var5
	arg0.outlandPoint.exlt = var6
	arg0.outlandPoint.exrt = var7
	arg0.outlandPoint.exrb = var8
end

function var0.step(arg0)
	if arg0.timeToOver and arg0.timeToOver > 0 then
		arg0.timeToOver = arg0.timeToOver - CastleGameVo.deltaTime

		if arg0.timeToOver <= 0 then
			arg0.timeToOver = nil

			arg0._event:emit(CastleGameView.GAME_OVER)
		end
	end

	arg0:updateSpeed()
	arg0:updatePosition()
	arg0:updateAnim()
	arg0:checkPlayerOutScreen()
end

function var0.getPoint(arg0)
	if arg0.charTf then
		return nil
	end

	return arg0.charTf.anchoredPosition
end

function var0.updatePosition(arg0)
	local var0 = arg0.charTf.anchoredPosition
	local var1 = arg0.zPos.anchoredPosition

	var0.x = var0.x + arg0.speed.x * CastleGameVo.deltaTime
	var0.y = var0.y + arg0.speed.y * CastleGameVo.deltaTime

	local var2, var3 = arg0:checkOutland(var0)

	if var2 and var3 then
		arg0.charTf.anchoredPosition = var3

		arg0:updateDirect(var3)
	end

	var1.y = var1.y + arg0.speed.z * CastleGameVo.deltaTime
	arg0.zPos.anchoredPosition = var1
end

function var0.updateDirect(arg0, arg1)
	if arg1.x ~= 0 then
		local var0 = arg0.speed.x > 0 and 1 or -1

		if arg0.charTf.localScale.x ~= var0 then
			arg0.charTf.localScale = Vector3(var0, 1, 1)
			arg0.charDirect = var0
		end
	end
end

function var0.checkOutland(arg0, arg1, arg2)
	if arg0.outlandPoint then
		local var0 = arg0.outlandPoint.lb
		local var1 = arg0.outlandPoint.lt
		local var2 = arg0.outlandPoint.rt
		local var3 = arg0.outlandPoint.rb
		local var4 = arg0.outlandPoint.exlb
		local var5 = arg0.outlandPoint.exlt
		local var6 = arg0.outlandPoint.exrt
		local var7 = arg0.outlandPoint.exrb

		if CastleGameVo.PointLeftLine(arg1, var0, var1) then
			local var8, var9 = CastleGameVo.PointFootLine(arg1, var4, var5)

			if var9 then
				return arg0:checkOutland(var8, var9)
			else
				return false
			end
		end

		if CastleGameVo.PointLeftLine(arg1, var3, var0) then
			local var10, var11 = CastleGameVo.PointFootLine(arg1, var7, var4)

			if var11 then
				return arg0:checkOutland(var10)
			else
				return false
			end
		end

		if CastleGameVo.PointLeftLine(arg1, var1, var2) then
			local var12, var13 = CastleGameVo.PointFootLine(arg1, var5, var6)

			if var13 then
				return arg0:checkOutland(var12)
			else
				return false
			end
		end

		if CastleGameVo.PointLeftLine(arg1, var2, var3) then
			local var14, var15 = CastleGameVo.PointFootLine(arg1, var6, var7)

			if var15 then
				return arg0:checkOutland(var14)
			else
				return false
			end
		end
	end

	return true, arg1
end

function var0.updateSpeed(arg0)
	if arg0.addSpeedTime and arg0.addSpeedTime > 0 then
		arg0.addSpeedTime = arg0.addSpeedTime - CastleGameVo.deltaTime

		if arg0.addSpeedTime <= 0 then
			arg0.addSpeedTime = nil
			arg0.addSpeed = 0
		end
	end

	if not arg0.inGround then
		arg0.speed.z = arg0.speed.z > -1500 and arg0.speed.z - 20 or -1500
	elseif arg0.inBubble then
		arg0.speed.x = 0
		arg0.speed.y = 0
		arg0.speed.z = 0

		print("角色在气泡中，无法移动")
	elseif arg0.fail then
		arg0.speed.x = 0
		arg0.speed.y = 0
		arg0.speed.z = 0

		print("被车撞了，无法移动")
	elseif CastleGameVo.joyStickData then
		local var0 = CastleGameVo.joyStickData
		local var1 = var0.x
		local var2 = var0.y

		arg0.speed.x = var0.x * (CastleGameVo.char_speed + arg0.addSpeed)
		arg0.speed.y = var0.y * (CastleGameVo.char_speed + arg0.addSpeed)
		arg0.speed.x = math.abs(arg0.speed.x) < CastleGameVo.char_speed_min and 0 or arg0.speed.x
		arg0.speed.y = math.abs(arg0.speed.y) < CastleGameVo.char_speed_min and 0 or arg0.speed.y

		arg0:updateDirect(arg0.speed)
	else
		arg0.speed.x = 0
		arg0.speed.y = 0
	end
end

function var0.updateAnim(arg0)
	local var0

	if not arg0.inGround then
		var0 = var7
	elseif arg0.inBubble then
		var0 = var8
	elseif arg0.fail then
		var0 = var9
	else
		local var1 = math.max(math.abs(arg0.speed.x), math.abs(arg0.speed.y))

		if var1 > 120 then
			var0 = var4
		elseif var1 > 0 then
			var0 = var5
		else
			var0 = var6
		end
	end

	if arg0.action ~= var0 then
		arg0:changeAnimAction(arg0.anim, var0, 0)
	end
end

function var0.setScore(arg0, arg1)
	local var0 = arg1.data.speed
	local var1 = arg1.data.time

	if var0 >= arg0.addSpeed then
		arg0.addSpeed = var0
	end

	arg0.addSpeedTime = var1
end

function var0.setPlayerFail(arg0)
	arg0.fail = true
	arg0.timeToOver = 1

	arg0:playerDead()
end

function var0.setContent(arg0, arg1, arg2)
	arg0._content = arg1

	setParent(arg0.charTf, arg0._content, true)

	arg0.charTf.localScale = Vector3(1, 1, 1)

	if arg2 then
		arg0.charTf.anchoredPosition = arg2
	end
end

function var0.getPoint(arg0)
	return arg0.charTf.anchoredPosition
end

function var0.start(arg0)
	arg0.charTf.anchoredPosition = var1
	arg0.zPos.anchoredPosition = Vector2(0, var1.y)

	setActive(arg0.charTf, true)

	arg0.inGround = true
	arg0.inBubble = false
	arg0.fail = false
	arg0.timeToOver = nil
	arg0.speed = Vector3(0, 0, 0)
	arg0.addSpeed = 0
	arg0.addSpeedTime = 0

	arg0:changeAnimAction(arg0.anim, var6, 0)
end

function var0.clear(arg0)
	return
end

function var0.checkPlayerOutScreen(arg0)
	if math.abs(arg0.zPos.anchoredPosition.y) > 2000 then
		arg0._event:emit(CastleGameView.GAME_OVER)
	end
end

function var0.setInBubble(arg0, arg1)
	arg0.inBubble = arg1

	if arg1 then
		arg0.lastBubblePos = arg0.char.tf.anchoredPosition
	else
		arg0.char.tf.anchoredPosition = arg0.lastBubblePos
	end
end

function var0.getActionAble(arg0)
	if not arg0.inGround then
		return false
	end

	if arg0.inBubble then
		return false
	end

	if arg0.fail then
		return false
	end

	return true
end

function var0.press(arg0, arg1)
	return
end

function var0.playerDead(arg0)
	arg0.action = var9

	arg0.anim:GetAnimationState():SetAnimation(0, var9, false)
end

function var0.changeAnimAction(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.action = arg2

	arg1:SetActionCallBack(nil)
	arg1:SetAction(arg2, 0)
	arg1:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			if arg3 == 1 then
				arg1:SetActionCallBack(nil)
			end

			if arg5 then
				arg5()
			end
		end
	end)

	if arg3 ~= 1 and arg5 then
		arg5()
	end
end

function var0.getChar(arg0)
	return arg0.char
end

function var0.getTfs(arg0)
	return {
		arg0.charTf
	}
end

return var0
