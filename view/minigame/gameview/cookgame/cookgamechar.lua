local var0_0 = class("CookGameChar")
local var1_0 = 20
local var2_0 = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._gameData = arg2_1
	arg0_1._event = arg3_1
	arg0_1._animTf = findTF(arg0_1._tf, "mask/anim")
	arg0_1._animator = GetComponent(findTF(arg0_1._tf, "mask/anim"), typeof(Animator))
	arg0_1._animImage = GetComponent(findTF(arg0_1._tf, "mask/anim"), typeof(Image))
	arg0_1._dftEvent = GetComponent(findTF(arg0_1._tf, "mask/anim"), typeof(DftAniEvent))

	arg0_1._dftEvent:SetStartEvent(function(arg0_2)
		if arg0_1._serveFunc then
			arg0_1._serveFunc()

			arg0_1._serveFunc = nil

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_serve)
		end
	end)
	arg0_1._dftEvent:SetEndEvent(function(arg0_3)
		arg0_1:endEventHandle()
	end)
end

function var0_0.endEventHandle(arg0_4)
	if arg0_4.activing then
		arg0_4.activing = false
		arg0_4.activingTime = nil
	end

	if arg0_4.timeToEventHandle and arg0_4.timeToEventHandle > 0 then
		arg0_4.timeToEventHandle = nil
	end

	if arg0_4._serveSpeed then
		if arg0_4.directX == -1 then
			setActive(findTF(arg0_4._tf, "effectW"), false)
			setActive(findTF(arg0_4._tf, "effectW"), true)
		else
			setActive(findTF(arg0_4._tf, "effectE"), false)
			setActive(findTF(arg0_4._tf, "effectE"), true)
		end

		arg0_4._serveSpeed = false
	end

	if arg0_4._serveFresh then
		arg0_4._serveFresh = false
		arg0_4.cakeNum = arg0_4.cakeNum - 1

		if arg0_4.cakeNum < 0 then
			arg0_4.cakeNum = 0
		end

		arg0_4:clearJudge()
		arg0_4:updateCharAniamtor()
		arg0_4:updateAnimatorParame()
	elseif arg0_4.sendExtend then
		arg0_4.sendExtend = false

		arg0_4._event:emit(CookGameView.EXTEND_EVENT)
	end

	arg0_4:setTrigger("clear", true)

	arg0_4.clearing = true
end

function var0_0.changeSpeed(arg0_5, arg1_5)
	arg0_5._animator.speed = arg1_5
end

function var0_0.setData(arg0_6, arg1_6)
	if not arg1_6 then
		arg0_6:setCharActive(false)

		return
	end

	arg0_6:setCharActive(true)

	arg0_6._charData = arg1_6
	arg0_6._doubleAble = arg1_6.battleData.double_able
	arg0_6._speedAble = arg1_6.battleData.speed_able
	arg0_6._speedMax = arg1_6.battleData.speed_max
	arg0_6._acAble = arg1_6.battleData.ac_able
	arg0_6._skills = arg1_6.battleData.skills
	arg0_6._baseSpeed = arg1_6.battleData.base_speed
	arg0_6._scoreAdded = arg1_6.battleData.score_added
	arg0_6._name = arg1_6.battleData.name
	arg0_6._animDatas = arg1_6.animDatas
	arg0_6._randomScore = arg1_6.battleData.random_score
	arg0_6._doubleIndex = 1
	arg0_6._offset = arg1_6.battleData.offset or Vector2(0, 0)
	arg0_6.extendFlag = false

	if arg0_6._charData.battleData.extend and (arg0_6._isPlayer or arg0_6._isPartner) then
		arg0_6.extendFlag = true
	end
end

function var0_0.readyStart(arg0_7)
	arg0_7:clear()

	if arg0_7._isActive then
		arg0_7:updateCharAniamtor()
	end
end

function var0_0.start(arg0_8)
	return
end

function var0_0.step(arg0_9, arg1_9)
	arg0_9.deltaTime = arg1_9

	if arg0_9._velocity then
		arg0_9:move()
	end

	if arg0_9.timeToEventHandle then
		arg0_9.timeToEventHandle = arg0_9.timeToEventHandle - arg1_9

		if arg0_9.timeToEventHandle <= 0 then
			arg0_9.timeToEventHandle = nil

			arg0_9:endEventHandle()
		end
	end

	if arg0_9.activingTime and arg0_9.activingTime > 0 then
		arg0_9.activingTime = arg0_9.activingTime - arg0_9.deltaTime

		if arg0_9.activingTime <= 0 then
			arg0_9.activingTime = 0

			if arg0_9.activing then
				arg0_9.activing = false

				if arg0_9._serveFresh then
					arg0_9._serveFresh = false
					arg0_9.cakeNum = arg0_9.cakeNum - 1

					if arg0_9.cakeNum < 0 then
						arg0_9.cakeNum = 0
					end

					arg0_9:clearJudge()
					arg0_9:updateCharAniamtor()
					arg0_9:updateAnimatorParame()
				end

				arg0_9:setTrigger("clear", true)
			end
		end
	end

	if arg0_9._gameData.gameTime < arg0_9._gameData.time_up and arg0_9.extendFlag then
		arg0_9:extend()
	end

	arg0_9.clearing = false
end

function var0_0.updateCharAniamtor(arg0_10)
	local var0_10 = arg0_10:getAnimatorName(arg0_10._name, arg0_10.leftCakeId, arg0_10.rightCakeId, arg0_10.speedNum, arg0_10._doubleAble, arg0_10._speedAble)

	if arg0_10._activeAniamtorName ~= var0_10 then
		arg0_10.chacheSprite = arg0_10._animImage.sprite

		local var1_10

		for iter0_10 = 1, #arg0_10._animDatas do
			local var2_10 = arg0_10._animDatas[iter0_10]

			if var2_10.name == var0_10 then
				var1_10 = var2_10.runtimeAnimator
			end
		end

		if var1_10 then
			arg0_10._activeAniamtorName = var0_10
			arg0_10._animator.runtimeAnimatorController = var1_10

			setActive(arg0_10._animTf, false)

			if arg0_10.chacheSprite then
				arg0_10._animImage.sprite = arg0_10.chacheSprite
			end

			setActive(arg0_10._animTf, true)
		else
			print("警告 找不到aniamtor ：" .. var0_10)
		end
	end
end

function var0_0.getAnimatorName(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11)
	local var0_11

	if arg5_11 then
		var0_11 = arg1_11 .. "_L" .. arg2_11 .. "_R" .. arg3_11
	elseif arg6_11 then
		var0_11 = arg1_11 .. "_" .. "L" .. arg2_11 .. "_" .. arg4_11
	else
		var0_11 = arg1_11 .. "_" .. "L" .. arg2_11
	end

	return var0_11
end

function var0_0.setCake(arg0_12, arg1_12)
	arg0_12._cakeData = arg1_12

	arg0_12:clearJudge()
	arg0_12:clearTargetPos()
end

function var0_0.getCake(arg0_13)
	return arg0_13._cakeData
end

function var0_0.clearCake(arg0_14)
	if arg0_14._cakeData then
		setActive(findTF(arg0_14._cakeData.tf, "select"), false)

		arg0_14._cakeData = nil
	end
end

function var0_0.setJudge(arg0_15, arg1_15)
	arg0_15._judgeData = arg1_15

	arg0_15:clearCake()
	arg0_15:clearTargetPos()
end

function var0_0.clearJudge(arg0_16)
	if arg0_16._judgeData then
		setActive(findTF(arg0_16._judgeData.tf, "select"), false)

		arg0_16._judgeData = nil
	end
end

function var0_0.getJudgeData(arg0_17)
	return arg0_17._judgeData
end

function var0_0.setTargetPos(arg0_18, arg1_18)
	arg0_18._targetPos = arg1_18

	arg0_18:clearVelocity()
end

function var0_0.stopMove(arg0_19)
	arg0_19:clearTargetPos()
	arg0_19:clearVelocity()
	arg0_19:updateAnimatorParame()

	if not arg0_19.activing then
		if arg0_19._cakeData then
			arg0_19:pickupCake()
		elseif arg0_19._judgeData then
			arg0_19:readyServeCake()
		end
	else
		arg0_19:clearCake()
		arg0_19:clearJudge()
	end
end

function var0_0.getJudge(arg0_20)
	if arg0_20._judgeData then
		return arg0_20._judgeData.judge
	end

	return nil
end

function var0_0.pickupCake(arg0_21)
	if arg0_21._cakeData then
		local var0_21 = arg0_21._cakeData.id
		local var1_21 = arg0_21._cakeData.tf

		if arg0_21._tf.parent:InverseTransformPoint(var1_21.position).x < arg0_21._tf.anchoredPosition.x then
			arg0_21.directX = -1
			arg0_21.directY = -1
		else
			arg0_21.directX = 1
			arg0_21.directY = -1
		end

		if arg0_21._doubleAble then
			if arg0_21.cakeNum == 0 then
				arg0_21.leftCakeId = var0_21
				arg0_21.rightCakeId = 0
				arg0_21.cakeNum = 1
				arg0_21.useL = true
				arg0_21.useR = false
			elseif arg0_21.cakeNum == 1 then
				arg0_21.cakeNum = 2
				arg0_21.rightCakeId = var0_21
				arg0_21.useL = false
				arg0_21.useR = true
			elseif arg0_21.cakeNum == 2 then
				if arg0_21._doubleIndex % 2 == 0 then
					arg0_21.leftCakeId = var0_21
					arg0_21.useL = true
					arg0_21.useR = false
				else
					arg0_21.rightCakeId = var0_21
					arg0_21.useL = false
					arg0_21.useR = true
				end

				arg0_21._doubleIndex = arg0_21._doubleIndex + 1
			end
		else
			arg0_21.leftCakeId = var0_21
			arg0_21.cakeNum = 1
		end

		if arg0_21._pickupFull and arg0_21:isFullCakes() then
			arg0_21:setPickupFull(false)
		end

		arg0_21:updateCharAniamtor()
		arg0_21:updateAnimatorParame()
		arg0_21:clearCake()
		arg0_21:pickup()
	end
end

function var0_0.readyServeCake(arg0_22)
	local var0_22 = arg0_22._judgeData.judge

	if var0_22:isInServe() or var0_22:isInTrigger() or arg0_22.cakeNum == 0 then
		arg0_22:clearJudge()

		return
	end

	local var1_22 = arg0_22._judgeData.tf

	if arg0_22._tf.parent:InverseTransformPoint(var1_22.position).x < arg0_22._tf.anchoredPosition.x then
		arg0_22.directX = -1
		arg0_22.directY = -1
	else
		arg0_22.directX = 1
		arg0_22.directY = -1
	end

	local var2_22 = var0_22:getWantedCake()
	local var3_22 = arg0_22.leftCakeId

	arg0_22.serveRight = false

	if arg0_22._doubleAble then
		if arg0_22.leftCakeId == var2_22 then
			arg0_22.useL = true
			arg0_22.useR = false
			var3_22 = arg0_22.leftCakeId
			arg0_22.leftCakeId = arg0_22.rightCakeId
			arg0_22.rightCakeId = 0
			arg0_22.serveRight = true
		elseif arg0_22.rightCakeId == var2_22 then
			arg0_22.useL = false
			arg0_22.useR = true
			var3_22 = arg0_22.rightCakeId
			arg0_22.rightCakeId = 0
			arg0_22.serveRight = true
		else
			arg0_22.useL = true
			arg0_22.useR = false
			var3_22 = arg0_22.leftCakeId
			arg0_22.leftCakeId = arg0_22.rightCakeId
			arg0_22.rightCakeId = 0
		end

		if var3_22 == var2_22 then
			arg0_22.rightCakeIndex = arg0_22.rightCakeIndex + 1
		end
	elseif arg0_22._speedAble then
		if var2_22 == arg0_22.leftCakeId then
			if arg0_22.speedNum < arg0_22._speedMax then
				arg0_22.speedNum = arg0_22.speedNum + 1
			end

			arg0_22.serveRight = true
			arg0_22.serveWrong = false
		else
			arg0_22.serveRight = false
			arg0_22.serveWrong = true
			arg0_22.speedNum = 0
		end

		arg0_22.directX = -1 * arg0_22.directX
		arg0_22.leftCakeId = 0
	elseif arg0_22._scoreAdded or arg0_22._randomScore then
		if var2_22 == arg0_22.leftCakeId then
			arg0_22.serveRight = true
			arg0_22.serveWrong = false
		else
			arg0_22.serveRight = false
			arg0_22.serveWrong = true
		end

		arg0_22.leftCakeId = 0
	else
		if var2_22 == arg0_22.leftCakeId then
			arg0_22.serveRight = true
		end

		arg0_22.leftCakeId = 0
	end

	if not arg0_22.serveRight and arg0_22._charData.battleData.cake_allow then
		arg0_22.serveRight = true
	end

	if not arg0_22._charData.battleData.weight then
		local var4_22 = 0
	end

	local var5_22 = var0_22:getPuzzleCamp()

	arg0_22.puzzleDouble = false
	arg0_22.puzzleReject = false

	if var5_22 then
		if arg0_22._camp == var5_22 then
			arg0_22.serveRight = true
			arg0_22.puzzleDouble = true
			arg0_22.serveWrong = false
		else
			arg0_22.serveRight = false
			arg0_22.serveWrong = true
			arg0_22.puzzleReject = true
		end
	end

	if arg0_22._speedAble and arg0_22.serveRight then
		arg0_22._serveSpeed = true

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_speed_up)
	end

	if arg0_22.serveRight then
		arg0_22.rightCakeIndex = arg0_22.rightCakeIndex + 1
		arg0_22.seriesRightIndex = arg0_22.seriesRightIndex + 1

		if arg0_22.seriesRightIndex > CookGameConst.added_max then
			arg0_22.seriesRightIndex = CookGameConst.added_max
		end
	else
		arg0_22.seriesRightIndex = 0
	end

	arg0_22.triggerPuzzle = false

	if arg0_22._charData.battleData.puzzle and arg0_22.serveRight then
		arg0_22.triggerPuzzle = math.random(1, 100) <= CookGameConst.puzzle_rate
	end

	arg0_22:checkEffectInServe()

	arg0_22.serveCakeId = var3_22
	arg0_22._serveFresh = true

	local var6_22 = {
		parameter = arg0_22:getParameter(),
		battleData = arg0_22._charData.battleData,
		judgeData = arg0_22._judgeData
	}

	var0_22:readyServe(var6_22)

	if arg0_22._acAble then
		local var7_22 = arg0_22:getAcCakeData(var0_22)

		function arg0_22._serveFunc()
			arg0_22._event:emit(CookGameView.AC_CAKE_EVENT, var7_22)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_ac)
	else
		function arg0_22._serveFunc()
			var0_22:serve()
		end
	end

	arg0_22:updateAnimatorParame()
	arg0_22:startServeCake()
end

function var0_0.getAcCakeData(arg0_25, arg1_25)
	local var0_25 = arg1_25:getAcTargetTf()
	local var1_25 = arg0_25._tf.parent:InverseTransformPoint(var0_25.position)

	if arg0_25.serveRight then
		var1_25.y = var1_25.y
	else
		var1_25.y = var1_25.y + 50
	end

	local var2_25

	if arg0_25.directX == 1 then
		var2_25 = arg0_25._tf.parent:InverseTransformPoint(findTF(arg0_25._tf, "acR").position)
	else
		var2_25 = arg0_25._tf.parent:InverseTransformPoint(findTF(arg0_25._tf, "acL").position)
	end

	local function var3_25()
		arg1_25:serve()
	end

	return {
		cakeId = arg0_25.serveCakeId,
		startPos = var2_25,
		targetPos = var1_25,
		callback = var3_25
	}
end

function var0_0.getParameter(arg0_27)
	local var0_27 = arg0_27._charData.battleData.weight or 0

	return {
		cakeId = arg0_27.serveCakeId,
		right_index = arg0_27.rightCakeIndex,
		series_right_index = arg0_27.seriesRightIndex,
		camp = arg0_27._camp,
		puzzle_double = arg0_27.puzzleDouble,
		puzzleReject = arg0_27.puzzleReject,
		puzzle = arg0_27.triggerPuzzle,
		weight = var0_27,
		right_flag = arg0_27.serveRight
	}
end

function var0_0.checkEffectInServe(arg0_28)
	local var0_28 = arg0_28._charData.battleData.effect
	local var1_28
	local var2_28 = Vector3(1, 1, 1)

	if arg0_28._scoreAdded and arg0_28.serveRight then
		local var3_28

		if arg0_28.seriesRightIndex == 0 then
			var3_28 = 1
		elseif arg0_28.seriesRightIndex > #var0_28 then
			var3_28 = #var0_28
		else
			var3_28 = arg0_28.seriesRightIndex
		end

		var1_28 = var0_28[var3_28]
	elseif arg0_28.triggerPuzzle then
		var1_28 = var0_28[1]

		if arg0_28._isPartner or arg0_28._isPlayer then
			var2_28 = Vector3(1, 1, 1)
		else
			var2_28 = Vector3(-1, 1, 1)
		end
	end

	if not arg0_28._effectContent then
		arg0_28._effectContent = findTF(arg0_28._tf, "effect")
	end

	if var1_28 then
		local var4_28 = findTF(arg0_28._effectContent, var1_28)
		local var5_28 = findTF(var4_28, "anim")
		local var6_28 = GetComponent(var5_28, typeof(DftAniEvent))

		var4_28.localScale = var2_28

		var6_28:SetEndEvent(function(arg0_29)
			setActive(var4_28, false)
		end)
		setActive(var4_28, true)
	end
end

function var0_0.getId(arg0_30)
	return arg0_30._charData.battleData.id
end

function var0_0.getDoubleAble(arg0_31)
	return arg0_31._doubleAble
end

function var0_0.setPetFlag(arg0_32, arg1_32)
	arg0_32._isPet = arg1_32
end

function var0_0.getpetFlag(arg0_33)
	return arg0_33._isPet
end

function var0_0.setCharActive(arg0_34, arg1_34)
	arg0_34._isActive = arg1_34

	setActive(arg0_34._tf, arg0_34._isActive)
end

function var0_0.getCharActive(arg0_35)
	return arg0_35._isActive
end

function var0_0.isFullCakes(arg0_36)
	if arg0_36._doubleAble and arg0_36.cakeNum == 2 then
		return true
	elseif not arg0_36._doubleAble and arg0_36.cakeNum == 1 then
		return true
	end

	return false
end

function var0_0.getPickupFull(arg0_37)
	return arg0_37._pickupFull
end

function var0_0.setPickupFull(arg0_38, arg1_38)
	arg0_38._pickupFull = arg1_38
end

function var0_0.getTargetPos(arg0_39)
	return arg0_39._targetPos
end

function var0_0.clearTargetPos(arg0_40)
	arg0_40._targetPos = nil
end

function var0_0.setVelocity(arg0_41, arg1_41, arg2_41, arg3_41)
	arg0_41._velocity = Vector2(arg1_41 * arg0_41._baseSpeed * (1 + arg0_41.speedNum / 3), arg2_41 * arg0_41._baseSpeed * (1 + arg0_41.speedNum / 3))

	if not arg0_41._isPlayer and not arg0_41._isPartner then
		arg0_41._velocity = Vector2(arg0_41._velocity.x * 0.9, arg0_41._velocity.y * 0.9)
	end

	local var0_41 = math.rad2Deg * arg3_41
	local var1_41 = arg1_41 > 0 and 1 or -1
	local var2_41 = arg2_41 > 0 and 1 or -1

	if math.abs(var0_41) <= var1_0 then
		var2_41 = 0
	elseif var0_41 > var1_0 and 90 - math.abs(var0_41) <= var1_0 then
		var1_41 = 0
	end

	arg0_41.directX = var1_41
	arg0_41.directY = var2_41
	arg0_41.run = true
	arg0_41.idle = false

	arg0_41:updateAnimatorParame()
end

function var0_0.updateAnimatorParame(arg0_42)
	arg0_42:setInteger("x", arg0_42.directX)
	arg0_42:setInteger("y", arg0_42.directY)
	arg0_42:setBool("run", arg0_42.run)
	arg0_42:setBool("idle", arg0_42.idle)
	arg0_42:setInteger("num", arg0_42.cakeNum)

	if arg0_42._doubleAble then
		arg0_42:setBool("L", arg0_42.useL)
		arg0_42:setBool("R", arg0_42.useR)
	end

	if arg0_42._speedAble then
		arg0_42:setInteger("speed_lv", arg0_42.speedNum)
		arg0_42:setTrigger("serve_right", arg0_42.serveRight)
		arg0_42:setTrigger("serve_wrong", arg0_42.serveWrong)
	end

	if arg0_42._randomScore then
		arg0_42:setTrigger("serve_right", arg0_42.serveRight)
		arg0_42:setTrigger("serve_wrong", arg0_42.serveWrong)
	end

	if arg0_42._scoreAdded then
		arg0_42:setTrigger("serve_right", arg0_42.serveRight == true)
		arg0_42:setTrigger("serve_wrong", arg0_42.serveWrong == true)
		arg0_42:setBool("server_a", arg0_42.seriesRightIndex <= 2)
		arg0_42:setBool("server_b", arg0_42.seriesRightIndex > 2)
	end
end

function var0_0.getVelocity(arg0_43)
	return arg0_43._velocity
end

function var0_0.clearVelocity(arg0_44)
	arg0_44._velocity = nil
	arg0_44.run = false
	arg0_44.idle = true
end

function var0_0.move(arg0_45)
	if arg0_45:isActiving() then
		return
	end

	if arg0_45._velocity then
		if arg0_45._targetPos then
			local var0_45 = arg0_45:getPos()
			local var1_45 = arg0_45._targetPos.x - var0_45.x >= 0 and 1 or -1
			local var2_45 = arg0_45._targetPos.y - var0_45.y >= 0 and 1 or -1
			local var3_45 = arg0_45:getPos()

			var3_45.x = var3_45.x + arg0_45._velocity.x * arg0_45.deltaTime
			var3_45.y = var3_45.y + arg0_45._velocity.y * arg0_45.deltaTime

			local var4_45 = arg0_45._targetPos.x - var3_45.x >= 0 and 1 or -1
			local var5_45 = arg0_45._targetPos.y - var3_45.y >= 0 and 1 or -1
			local var6_45 = arg0_45:getPos()

			if var1_45 == var4_45 then
				var6_45.x = var6_45.x + arg0_45._velocity.x * arg0_45.deltaTime
			else
				var6_45.x = arg0_45._targetPos.x
			end

			if var2_45 == var5_45 then
				var6_45.y = var6_45.y + arg0_45._velocity.y * arg0_45.deltaTime
			else
				var6_45.y = arg0_45._targetPos.y
			end

			if arg0_45._acAble and arg0_45._judgeData and math.sqrt(math.pow(arg0_45._targetPos.x - var6_45.x, 2) + math.pow(arg0_45._targetPos.y - var6_45.y, 2)) <= CookGameConst.ac_dictance then
				arg0_45:stopMove()
				arg0_45:clearJudge()

				return
			end

			arg0_45._tf.anchoredPosition = var6_45

			if var1_45 ~= var4_45 and var1_45 ~= var4_45 then
				arg0_45:stopMove()
			elseif math.abs(arg0_45._targetPos.x - var6_45.x) < 5 and math.abs(arg0_45._targetPos.y - var6_45.y) < 5 then
				arg0_45:stopMove()
			end
		else
			local var7_45 = arg0_45:getPos()
			local var8_45 = arg0_45._tf.anchoredPosition

			var8_45.x = var8_45.x + arg0_45._velocity.x * arg0_45.deltaTime
			var8_45.y = var8_45.y + arg0_45._velocity.y * arg0_45.deltaTime
			arg0_45._tf.anchoredPosition = var8_45
		end
	end
end

function var0_0.extend(arg0_46)
	if not arg0_46.activing and not arg0_46.clearing then
		arg0_46.extendFlag = false
		arg0_46.activing = true
		arg0_46.sendExtend = true

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_marcopolo_skill)
		arg0_46:setTrigger("Extend", true)

		arg0_46.timeToEventHandle = var2_0
	end
end

function var0_0.isActiving(arg0_47)
	return arg0_47.activing
end

function var0_0.getPos(arg0_48)
	return arg0_48._tf.anchoredPosition
end

function var0_0.startServeCake(arg0_49)
	if arg0_49.activing then
		return
	end

	arg0_49.activing = true
	arg0_49.activingTime = 3

	arg0_49:setTrigger("server", true)
end

function var0_0.pickup(arg0_50)
	if arg0_50.activing then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_pickup)
	arg0_50:setTrigger("pickup", true)

	arg0_50.activing = true
end

function var0_0.setParent(arg0_51, arg1_51, arg2_51)
	local var0_51 = findTF(arg1_51, arg2_51.parent)

	arg0_51._tf.anchoredPosition = arg2_51.init_pos
	arg0_51._tf.name = arg2_51.tf_name

	setParent(arg0_51._tf, var0_51)
	setActive(arg0_51._tf, true)

	arg0_51.initPos = arg2_51.init_pos
	arg0_51._bound = findTF(arg1_51, "scene_background/" .. arg2_51.bound)
end

function var0_0.getTf(arg0_52)
	return arg0_52._tf
end

function var0_0.getOffset(arg0_53)
	return arg0_53._offset
end

function var0_0.getCakeIds(arg0_54)
	local var0_54 = {}

	if arg0_54.leftCakeId > 0 then
		table.insert(var0_54, arg0_54.leftCakeId)
	end

	if arg0_54.rightCakeId > 0 then
		table.insert(var0_54, arg0_54.rightCakeId)
	end

	return var0_54
end

function var0_0.isPlayer(arg0_55, arg1_55)
	setActive(findTF(arg0_55._tf, "player"), arg1_55)

	arg0_55._isPlayer = arg1_55

	if arg0_55._isPlayer then
		arg0_55._camp = CookGameConst.camp_player
	else
		arg0_55._camp = CookGameConst.camp_enemy
	end
end

function var0_0.isPartner(arg0_56, arg1_56)
	arg0_56._isPartner = arg1_56

	if arg0_56._isPartner then
		arg0_56._camp = CookGameConst.camp_player
	else
		arg0_56._camp = CookGameConst.camp_enemy
	end
end

function var0_0.getCamp(arg0_57)
	return arg0_57._camp
end

function var0_0.setBool(arg0_58, arg1_58, arg2_58)
	arg0_58._animator:SetBool(arg1_58, arg2_58)
end

function var0_0.setTrigger(arg0_59, arg1_59, arg2_59)
	if arg2_59 then
		arg0_59._animator:SetTrigger(arg1_59)
	else
		arg0_59._animator:ResetTrigger(arg1_59)
	end
end

function var0_0.setInteger(arg0_60, arg1_60, arg2_60)
	arg0_60._animator:SetInteger(arg1_60, arg2_60)
end

function var0_0.clear(arg0_61)
	arg0_61.leftCakeId = 0
	arg0_61.rightCakeId = 0
	arg0_61._serveSpeed = false
	arg0_61.cakeNum = 0
	arg0_61.speedNum = 1
	arg0_61._speedRate = 1
	arg0_61.directX = 0
	arg0_61.directY = -1
	arg0_61.activing = false
	arg0_61.scoreAdded = false
	arg0_61._tf.anchoredPosition = arg0_61.initPos
	arg0_61.useL = true
	arg0_61.useR = false
	arg0_61.rightCakeIndex = 0
	arg0_61.seriesRightIndex = 0

	arg0_61:clearCake()
	arg0_61:clearJudge()
	arg0_61:clearTargetPos()
	arg0_61:clearVelocity()
	setActive(findTF(arg0_61._tf, "effectW"), false)
	setActive(findTF(arg0_61._tf, "effectE"), false)

	if arg0_61._animator and arg0_61._animator.runtimeAnimatorController then
		arg0_61:setInteger("x", 0)
		arg0_61:setInteger("y", -1)
		arg0_61:setInteger("num", 0)
		arg0_61:setBool("idle", true)
		arg0_61:setBool("run", false)
		arg0_61:setBool("L", false)
		arg0_61:setBool("R", false)
		arg0_61:setTrigger("server", false)
		arg0_61:setTrigger("pickup", false)
		arg0_61:setTrigger("serve_right", false)
		arg0_61:setTrigger("serve_wrong", false)
		arg0_61:setInteger("speed_lv", 0)
	end

	arg0_61._pickupFull = false
end

return var0_0
