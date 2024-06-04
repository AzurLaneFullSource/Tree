local var0 = class("CookGameChar")
local var1 = 20
local var2 = 3

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0._gameData = arg2
	arg0._event = arg3
	arg0._animTf = findTF(arg0._tf, "mask/anim")
	arg0._animator = GetComponent(findTF(arg0._tf, "mask/anim"), typeof(Animator))
	arg0._animImage = GetComponent(findTF(arg0._tf, "mask/anim"), typeof(Image))
	arg0._dftEvent = GetComponent(findTF(arg0._tf, "mask/anim"), typeof(DftAniEvent))

	arg0._dftEvent:SetStartEvent(function(arg0)
		if arg0._serveFunc then
			arg0._serveFunc()

			arg0._serveFunc = nil

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_serve)
		end
	end)
	arg0._dftEvent:SetEndEvent(function(arg0)
		arg0:endEventHandle()
	end)
end

function var0.endEventHandle(arg0)
	if arg0.activing then
		arg0.activing = false
		arg0.activingTime = nil
	end

	if arg0.timeToEventHandle and arg0.timeToEventHandle > 0 then
		arg0.timeToEventHandle = nil
	end

	if arg0._serveSpeed then
		if arg0.directX == -1 then
			setActive(findTF(arg0._tf, "effectW"), false)
			setActive(findTF(arg0._tf, "effectW"), true)
		else
			setActive(findTF(arg0._tf, "effectE"), false)
			setActive(findTF(arg0._tf, "effectE"), true)
		end

		arg0._serveSpeed = false
	end

	if arg0._serveFresh then
		arg0._serveFresh = false
		arg0.cakeNum = arg0.cakeNum - 1

		if arg0.cakeNum < 0 then
			arg0.cakeNum = 0
		end

		arg0:clearJudge()
		arg0:updateCharAniamtor()
		arg0:updateAnimatorParame()
	elseif arg0.sendExtend then
		arg0.sendExtend = false

		arg0._event:emit(CookGameView.EXTEND_EVENT)
	end

	arg0:setTrigger("clear", true)

	arg0.clearing = true
end

function var0.changeSpeed(arg0, arg1)
	arg0._animator.speed = arg1
end

function var0.setData(arg0, arg1)
	if not arg1 then
		arg0:setCharActive(false)

		return
	end

	arg0:setCharActive(true)

	arg0._charData = arg1
	arg0._doubleAble = arg1.battleData.double_able
	arg0._speedAble = arg1.battleData.speed_able
	arg0._speedMax = arg1.battleData.speed_max
	arg0._acAble = arg1.battleData.ac_able
	arg0._skills = arg1.battleData.skills
	arg0._baseSpeed = arg1.battleData.base_speed
	arg0._scoreAdded = arg1.battleData.score_added
	arg0._name = arg1.battleData.name
	arg0._animDatas = arg1.animDatas
	arg0._randomScore = arg1.battleData.random_score
	arg0._doubleIndex = 1
	arg0._offset = arg1.battleData.offset or Vector2(0, 0)
	arg0.extendFlag = false

	if arg0._charData.battleData.extend and (arg0._isPlayer or arg0._isPartner) then
		arg0.extendFlag = true
	end
end

function var0.readyStart(arg0)
	arg0:clear()

	if arg0._isActive then
		arg0:updateCharAniamtor()
	end
end

function var0.start(arg0)
	return
end

function var0.step(arg0, arg1)
	arg0.deltaTime = arg1

	if arg0._velocity then
		arg0:move()
	end

	if arg0.timeToEventHandle then
		arg0.timeToEventHandle = arg0.timeToEventHandle - arg1

		if arg0.timeToEventHandle <= 0 then
			arg0.timeToEventHandle = nil

			arg0:endEventHandle()
		end
	end

	if arg0.activingTime and arg0.activingTime > 0 then
		arg0.activingTime = arg0.activingTime - arg0.deltaTime

		if arg0.activingTime <= 0 then
			arg0.activingTime = 0

			if arg0.activing then
				arg0.activing = false

				if arg0._serveFresh then
					arg0._serveFresh = false
					arg0.cakeNum = arg0.cakeNum - 1

					if arg0.cakeNum < 0 then
						arg0.cakeNum = 0
					end

					arg0:clearJudge()
					arg0:updateCharAniamtor()
					arg0:updateAnimatorParame()
				end

				arg0:setTrigger("clear", true)
			end
		end
	end

	if arg0._gameData.gameTime < arg0._gameData.time_up and arg0.extendFlag then
		arg0:extend()
	end

	arg0.clearing = false
end

function var0.updateCharAniamtor(arg0)
	local var0 = arg0:getAnimatorName(arg0._name, arg0.leftCakeId, arg0.rightCakeId, arg0.speedNum, arg0._doubleAble, arg0._speedAble)

	if arg0._activeAniamtorName ~= var0 then
		arg0.chacheSprite = arg0._animImage.sprite

		local var1

		for iter0 = 1, #arg0._animDatas do
			local var2 = arg0._animDatas[iter0]

			if var2.name == var0 then
				var1 = var2.runtimeAnimator
			end
		end

		if var1 then
			arg0._activeAniamtorName = var0
			arg0._animator.runtimeAnimatorController = var1

			setActive(arg0._animTf, false)

			if arg0.chacheSprite then
				arg0._animImage.sprite = arg0.chacheSprite
			end

			setActive(arg0._animTf, true)
		else
			print("警告 找不到aniamtor ：" .. var0)
		end
	end
end

function var0.getAnimatorName(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0

	if arg5 then
		var0 = arg1 .. "_L" .. arg2 .. "_R" .. arg3
	elseif arg6 then
		var0 = arg1 .. "_" .. "L" .. arg2 .. "_" .. arg4
	else
		var0 = arg1 .. "_" .. "L" .. arg2
	end

	return var0
end

function var0.setCake(arg0, arg1)
	arg0._cakeData = arg1

	arg0:clearJudge()
	arg0:clearTargetPos()
end

function var0.getCake(arg0)
	return arg0._cakeData
end

function var0.clearCake(arg0)
	if arg0._cakeData then
		setActive(findTF(arg0._cakeData.tf, "select"), false)

		arg0._cakeData = nil
	end
end

function var0.setJudge(arg0, arg1)
	arg0._judgeData = arg1

	arg0:clearCake()
	arg0:clearTargetPos()
end

function var0.clearJudge(arg0)
	if arg0._judgeData then
		setActive(findTF(arg0._judgeData.tf, "select"), false)

		arg0._judgeData = nil
	end
end

function var0.getJudgeData(arg0)
	return arg0._judgeData
end

function var0.setTargetPos(arg0, arg1)
	arg0._targetPos = arg1

	arg0:clearVelocity()
end

function var0.stopMove(arg0)
	arg0:clearTargetPos()
	arg0:clearVelocity()
	arg0:updateAnimatorParame()

	if not arg0.activing then
		if arg0._cakeData then
			arg0:pickupCake()
		elseif arg0._judgeData then
			arg0:readyServeCake()
		end
	else
		arg0:clearCake()
		arg0:clearJudge()
	end
end

function var0.getJudge(arg0)
	if arg0._judgeData then
		return arg0._judgeData.judge
	end

	return nil
end

function var0.pickupCake(arg0)
	if arg0._cakeData then
		local var0 = arg0._cakeData.id
		local var1 = arg0._cakeData.tf

		if arg0._tf.parent:InverseTransformPoint(var1.position).x < arg0._tf.anchoredPosition.x then
			arg0.directX = -1
			arg0.directY = -1
		else
			arg0.directX = 1
			arg0.directY = -1
		end

		if arg0._doubleAble then
			if arg0.cakeNum == 0 then
				arg0.leftCakeId = var0
				arg0.rightCakeId = 0
				arg0.cakeNum = 1
				arg0.useL = true
				arg0.useR = false
			elseif arg0.cakeNum == 1 then
				arg0.cakeNum = 2
				arg0.rightCakeId = var0
				arg0.useL = false
				arg0.useR = true
			elseif arg0.cakeNum == 2 then
				if arg0._doubleIndex % 2 == 0 then
					arg0.leftCakeId = var0
					arg0.useL = true
					arg0.useR = false
				else
					arg0.rightCakeId = var0
					arg0.useL = false
					arg0.useR = true
				end

				arg0._doubleIndex = arg0._doubleIndex + 1
			end
		else
			arg0.leftCakeId = var0
			arg0.cakeNum = 1
		end

		if arg0._pickupFull and arg0:isFullCakes() then
			arg0:setPickupFull(false)
		end

		arg0:updateCharAniamtor()
		arg0:updateAnimatorParame()
		arg0:clearCake()
		arg0:pickup()
	end
end

function var0.readyServeCake(arg0)
	local var0 = arg0._judgeData.judge

	if var0:isInServe() or var0:isInTrigger() or arg0.cakeNum == 0 then
		arg0:clearJudge()

		return
	end

	local var1 = arg0._judgeData.tf

	if arg0._tf.parent:InverseTransformPoint(var1.position).x < arg0._tf.anchoredPosition.x then
		arg0.directX = -1
		arg0.directY = -1
	else
		arg0.directX = 1
		arg0.directY = -1
	end

	local var2 = var0:getWantedCake()
	local var3 = arg0.leftCakeId

	arg0.serveRight = false

	if arg0._doubleAble then
		if arg0.leftCakeId == var2 then
			arg0.useL = true
			arg0.useR = false
			var3 = arg0.leftCakeId
			arg0.leftCakeId = arg0.rightCakeId
			arg0.rightCakeId = 0
			arg0.serveRight = true
		elseif arg0.rightCakeId == var2 then
			arg0.useL = false
			arg0.useR = true
			var3 = arg0.rightCakeId
			arg0.rightCakeId = 0
			arg0.serveRight = true
		else
			arg0.useL = true
			arg0.useR = false
			var3 = arg0.leftCakeId
			arg0.leftCakeId = arg0.rightCakeId
			arg0.rightCakeId = 0
		end

		if var3 == var2 then
			arg0.rightCakeIndex = arg0.rightCakeIndex + 1
		end
	elseif arg0._speedAble then
		if var2 == arg0.leftCakeId then
			if arg0.speedNum < arg0._speedMax then
				arg0.speedNum = arg0.speedNum + 1
			end

			arg0.serveRight = true
			arg0.serveWrong = false
		else
			arg0.serveRight = false
			arg0.serveWrong = true
			arg0.speedNum = 0
		end

		arg0.directX = -1 * arg0.directX
		arg0.leftCakeId = 0
	elseif arg0._scoreAdded or arg0._randomScore then
		if var2 == arg0.leftCakeId then
			arg0.serveRight = true
			arg0.serveWrong = false
		else
			arg0.serveRight = false
			arg0.serveWrong = true
		end

		arg0.leftCakeId = 0
	else
		if var2 == arg0.leftCakeId then
			arg0.serveRight = true
		end

		arg0.leftCakeId = 0
	end

	if not arg0.serveRight and arg0._charData.battleData.cake_allow then
		arg0.serveRight = true
	end

	if not arg0._charData.battleData.weight then
		local var4 = 0
	end

	local var5 = var0:getPuzzleCamp()

	arg0.puzzleDouble = false
	arg0.puzzleReject = false

	if var5 then
		if arg0._camp == var5 then
			arg0.serveRight = true
			arg0.puzzleDouble = true
			arg0.serveWrong = false
		else
			arg0.serveRight = false
			arg0.serveWrong = true
			arg0.puzzleReject = true
		end
	end

	if arg0._speedAble and arg0.serveRight then
		arg0._serveSpeed = true

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_speed_up)
	end

	if arg0.serveRight then
		arg0.rightCakeIndex = arg0.rightCakeIndex + 1
		arg0.seriesRightIndex = arg0.seriesRightIndex + 1

		if arg0.seriesRightIndex > CookGameConst.added_max then
			arg0.seriesRightIndex = CookGameConst.added_max
		end
	else
		arg0.seriesRightIndex = 0
	end

	arg0.triggerPuzzle = false

	if arg0._charData.battleData.puzzle and arg0.serveRight then
		arg0.triggerPuzzle = math.random(1, 100) <= CookGameConst.puzzle_rate
	end

	arg0:checkEffectInServe()

	arg0.serveCakeId = var3
	arg0._serveFresh = true

	local var6 = {
		parameter = arg0:getParameter(),
		battleData = arg0._charData.battleData,
		judgeData = arg0._judgeData
	}

	var0:readyServe(var6)

	if arg0._acAble then
		local var7 = arg0:getAcCakeData(var0)

		function arg0._serveFunc()
			arg0._event:emit(CookGameView.AC_CAKE_EVENT, var7)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_ac)
	else
		function arg0._serveFunc()
			var0:serve()
		end
	end

	arg0:updateAnimatorParame()
	arg0:startServeCake()
end

function var0.getAcCakeData(arg0, arg1)
	local var0 = arg1:getAcTargetTf()
	local var1 = arg0._tf.parent:InverseTransformPoint(var0.position)

	if arg0.serveRight then
		var1.y = var1.y
	else
		var1.y = var1.y + 50
	end

	local var2

	if arg0.directX == 1 then
		var2 = arg0._tf.parent:InverseTransformPoint(findTF(arg0._tf, "acR").position)
	else
		var2 = arg0._tf.parent:InverseTransformPoint(findTF(arg0._tf, "acL").position)
	end

	local function var3()
		arg1:serve()
	end

	return {
		cakeId = arg0.serveCakeId,
		startPos = var2,
		targetPos = var1,
		callback = var3
	}
end

function var0.getParameter(arg0)
	local var0 = arg0._charData.battleData.weight or 0

	return {
		cakeId = arg0.serveCakeId,
		right_index = arg0.rightCakeIndex,
		series_right_index = arg0.seriesRightIndex,
		camp = arg0._camp,
		puzzle_double = arg0.puzzleDouble,
		puzzleReject = arg0.puzzleReject,
		puzzle = arg0.triggerPuzzle,
		weight = var0,
		right_flag = arg0.serveRight
	}
end

function var0.checkEffectInServe(arg0)
	local var0 = arg0._charData.battleData.effect
	local var1
	local var2 = Vector3(1, 1, 1)

	if arg0._scoreAdded and arg0.serveRight then
		local var3

		if arg0.seriesRightIndex == 0 then
			var3 = 1
		elseif arg0.seriesRightIndex > #var0 then
			var3 = #var0
		else
			var3 = arg0.seriesRightIndex
		end

		var1 = var0[var3]
	elseif arg0.triggerPuzzle then
		var1 = var0[1]

		if arg0._isPartner or arg0._isPlayer then
			var2 = Vector3(1, 1, 1)
		else
			var2 = Vector3(-1, 1, 1)
		end
	end

	if not arg0._effectContent then
		arg0._effectContent = findTF(arg0._tf, "effect")
	end

	if var1 then
		local var4 = findTF(arg0._effectContent, var1)
		local var5 = findTF(var4, "anim")
		local var6 = GetComponent(var5, typeof(DftAniEvent))

		var4.localScale = var2

		var6:SetEndEvent(function(arg0)
			setActive(var4, false)
		end)
		setActive(var4, true)
	end
end

function var0.getId(arg0)
	return arg0._charData.battleData.id
end

function var0.getDoubleAble(arg0)
	return arg0._doubleAble
end

function var0.setPetFlag(arg0, arg1)
	arg0._isPet = arg1
end

function var0.getpetFlag(arg0)
	return arg0._isPet
end

function var0.setCharActive(arg0, arg1)
	arg0._isActive = arg1

	setActive(arg0._tf, arg0._isActive)
end

function var0.getCharActive(arg0)
	return arg0._isActive
end

function var0.isFullCakes(arg0)
	if arg0._doubleAble and arg0.cakeNum == 2 then
		return true
	elseif not arg0._doubleAble and arg0.cakeNum == 1 then
		return true
	end

	return false
end

function var0.getPickupFull(arg0)
	return arg0._pickupFull
end

function var0.setPickupFull(arg0, arg1)
	arg0._pickupFull = arg1
end

function var0.getTargetPos(arg0)
	return arg0._targetPos
end

function var0.clearTargetPos(arg0)
	arg0._targetPos = nil
end

function var0.setVelocity(arg0, arg1, arg2, arg3)
	arg0._velocity = Vector2(arg1 * arg0._baseSpeed * (1 + arg0.speedNum / 3), arg2 * arg0._baseSpeed * (1 + arg0.speedNum / 3))

	if not arg0._isPlayer and not arg0._isPartner then
		arg0._velocity = Vector2(arg0._velocity.x * 0.9, arg0._velocity.y * 0.9)
	end

	local var0 = math.rad2Deg * arg3
	local var1 = arg1 > 0 and 1 or -1
	local var2 = arg2 > 0 and 1 or -1

	if math.abs(var0) <= var1 then
		var2 = 0
	elseif var0 > var1 and 90 - math.abs(var0) <= var1 then
		var1 = 0
	end

	arg0.directX = var1
	arg0.directY = var2
	arg0.run = true
	arg0.idle = false

	arg0:updateAnimatorParame()
end

function var0.updateAnimatorParame(arg0)
	arg0:setInteger("x", arg0.directX)
	arg0:setInteger("y", arg0.directY)
	arg0:setBool("run", arg0.run)
	arg0:setBool("idle", arg0.idle)
	arg0:setInteger("num", arg0.cakeNum)

	if arg0._doubleAble then
		arg0:setBool("L", arg0.useL)
		arg0:setBool("R", arg0.useR)
	end

	if arg0._speedAble then
		arg0:setInteger("speed_lv", arg0.speedNum)
		arg0:setTrigger("serve_right", arg0.serveRight)
		arg0:setTrigger("serve_wrong", arg0.serveWrong)
	end

	if arg0._randomScore then
		arg0:setTrigger("serve_right", arg0.serveRight)
		arg0:setTrigger("serve_wrong", arg0.serveWrong)
	end

	if arg0._scoreAdded then
		arg0:setTrigger("serve_right", arg0.serveRight == true)
		arg0:setTrigger("serve_wrong", arg0.serveWrong == true)
		arg0:setBool("server_a", arg0.seriesRightIndex <= 2)
		arg0:setBool("server_b", arg0.seriesRightIndex > 2)
	end
end

function var0.getVelocity(arg0)
	return arg0._velocity
end

function var0.clearVelocity(arg0)
	arg0._velocity = nil
	arg0.run = false
	arg0.idle = true
end

function var0.move(arg0)
	if arg0:isActiving() then
		return
	end

	if arg0._velocity then
		if arg0._targetPos then
			local var0 = arg0:getPos()
			local var1 = arg0._targetPos.x - var0.x >= 0 and 1 or -1
			local var2 = arg0._targetPos.y - var0.y >= 0 and 1 or -1
			local var3 = arg0:getPos()

			var3.x = var3.x + arg0._velocity.x * arg0.deltaTime
			var3.y = var3.y + arg0._velocity.y * arg0.deltaTime

			local var4 = arg0._targetPos.x - var3.x >= 0 and 1 or -1
			local var5 = arg0._targetPos.y - var3.y >= 0 and 1 or -1
			local var6 = arg0:getPos()

			if var1 == var4 then
				var6.x = var6.x + arg0._velocity.x * arg0.deltaTime
			else
				var6.x = arg0._targetPos.x
			end

			if var2 == var5 then
				var6.y = var6.y + arg0._velocity.y * arg0.deltaTime
			else
				var6.y = arg0._targetPos.y
			end

			if arg0._acAble and arg0._judgeData and math.sqrt(math.pow(arg0._targetPos.x - var6.x, 2) + math.pow(arg0._targetPos.y - var6.y, 2)) <= CookGameConst.ac_dictance then
				arg0:stopMove()
				arg0:clearJudge()

				return
			end

			arg0._tf.anchoredPosition = var6

			if var1 ~= var4 and var1 ~= var4 then
				arg0:stopMove()
			elseif math.abs(arg0._targetPos.x - var6.x) < 5 and math.abs(arg0._targetPos.y - var6.y) < 5 then
				arg0:stopMove()
			end
		else
			local var7 = arg0:getPos()
			local var8 = arg0._tf.anchoredPosition

			var8.x = var8.x + arg0._velocity.x * arg0.deltaTime
			var8.y = var8.y + arg0._velocity.y * arg0.deltaTime
			arg0._tf.anchoredPosition = var8
		end
	end
end

function var0.extend(arg0)
	if not arg0.activing and not arg0.clearing then
		arg0.extendFlag = false
		arg0.activing = true
		arg0.sendExtend = true

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_marcopolo_skill)
		arg0:setTrigger("Extend", true)

		arg0.timeToEventHandle = var2
	end
end

function var0.isActiving(arg0)
	return arg0.activing
end

function var0.getPos(arg0)
	return arg0._tf.anchoredPosition
end

function var0.startServeCake(arg0)
	if arg0.activing then
		return
	end

	arg0.activing = true
	arg0.activingTime = 3

	arg0:setTrigger("server", true)
end

function var0.pickup(arg0)
	if arg0.activing then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(CookGameConst.sound_pickup)
	arg0:setTrigger("pickup", true)

	arg0.activing = true
end

function var0.setParent(arg0, arg1, arg2)
	local var0 = findTF(arg1, arg2.parent)

	arg0._tf.anchoredPosition = arg2.init_pos
	arg0._tf.name = arg2.tf_name

	setParent(arg0._tf, var0)
	setActive(arg0._tf, true)

	arg0.initPos = arg2.init_pos
	arg0._bound = findTF(arg1, "scene_background/" .. arg2.bound)
end

function var0.getTf(arg0)
	return arg0._tf
end

function var0.getOffset(arg0)
	return arg0._offset
end

function var0.getCakeIds(arg0)
	local var0 = {}

	if arg0.leftCakeId > 0 then
		table.insert(var0, arg0.leftCakeId)
	end

	if arg0.rightCakeId > 0 then
		table.insert(var0, arg0.rightCakeId)
	end

	return var0
end

function var0.isPlayer(arg0, arg1)
	setActive(findTF(arg0._tf, "player"), arg1)

	arg0._isPlayer = arg1

	if arg0._isPlayer then
		arg0._camp = CookGameConst.camp_player
	else
		arg0._camp = CookGameConst.camp_enemy
	end
end

function var0.isPartner(arg0, arg1)
	arg0._isPartner = arg1

	if arg0._isPartner then
		arg0._camp = CookGameConst.camp_player
	else
		arg0._camp = CookGameConst.camp_enemy
	end
end

function var0.getCamp(arg0)
	return arg0._camp
end

function var0.setBool(arg0, arg1, arg2)
	arg0._animator:SetBool(arg1, arg2)
end

function var0.setTrigger(arg0, arg1, arg2)
	if arg2 then
		arg0._animator:SetTrigger(arg1)
	else
		arg0._animator:ResetTrigger(arg1)
	end
end

function var0.setInteger(arg0, arg1, arg2)
	arg0._animator:SetInteger(arg1, arg2)
end

function var0.clear(arg0)
	arg0.leftCakeId = 0
	arg0.rightCakeId = 0
	arg0._serveSpeed = false
	arg0.cakeNum = 0
	arg0.speedNum = 1
	arg0._speedRate = 1
	arg0.directX = 0
	arg0.directY = -1
	arg0.activing = false
	arg0.scoreAdded = false
	arg0._tf.anchoredPosition = arg0.initPos
	arg0.useL = true
	arg0.useR = false
	arg0.rightCakeIndex = 0
	arg0.seriesRightIndex = 0

	arg0:clearCake()
	arg0:clearJudge()
	arg0:clearTargetPos()
	arg0:clearVelocity()
	setActive(findTF(arg0._tf, "effectW"), false)
	setActive(findTF(arg0._tf, "effectE"), false)

	if arg0._animator and arg0._animator.runtimeAnimatorController then
		arg0:setInteger("x", 0)
		arg0:setInteger("y", -1)
		arg0:setInteger("num", 0)
		arg0:setBool("idle", true)
		arg0:setBool("run", false)
		arg0:setBool("L", false)
		arg0:setBool("R", false)
		arg0:setTrigger("server", false)
		arg0:setTrigger("pickup", false)
		arg0:setTrigger("serve_right", false)
		arg0:setTrigger("serve_wrong", false)
		arg0:setInteger("speed_lv", 0)
	end

	arg0._pickupFull = false
end

return var0
