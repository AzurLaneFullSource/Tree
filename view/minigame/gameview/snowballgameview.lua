local var0 = class("SnowballGameView", import("..BaseMiniGameView"))
local var1 = {
	-1920,
	-1080,
	1920,
	1080
}
local var2 = "snowball_type_player"
local var3 = "snowball_type_enemy"
local var4 = "win"
local var5 = "fail"
local var6 = 3
local var7 = 6
local var8 = "charactor_type_other"
local var9 = "charactor_type_enemy"
local var10 = {
	charactor_type_other = {
		type = var8,
		skin_names = {
			"bailu",
			"huangjia",
			"jiujiu"
		},
		score = {
			-50,
			200,
			-50
		}
	},
	charactor_type_enemy = {
		type = var9,
		skin_names = {
			"enemy1",
			"enemy2",
			"enemy3",
			"enemy4",
			"enemy5",
			"enemy6"
		},
		score = {
			100,
			100,
			100,
			100,
			100,
			100
		}
	}
}
local var11 = 3
local var12 = 1
local var13 = 18
local var14 = 30
local var15 = 3
local var16 = 100
local var17 = {
	12,
	14,
	15,
	16,
	17
}
local var18 = {
	{
		3,
		5
	},
	{
		3,
		4
	},
	{
		2,
		4
	},
	{
		2,
		3
	},
	{
		2,
		2
	}
}
local var19 = {
	{
		90,
		10,
		0
	},
	{
		70,
		20,
		10
	},
	{
		60,
		20,
		20
	},
	{
		50,
		30,
		20
	},
	{
		40,
		40,
		20
	}
}
local var20 = {
	0,
	30,
	60,
	90,
	120
}
local var21 = 1.5
local var22 = {
	{
		weight = 70,
		type = var9,
		indexs = {
			1,
			2,
			3,
			4,
			5,
			6
		},
		time = {
			8,
			10
		},
		attack_time = {
			4,
			6
		}
	},
	{
		weight = 30,
		type = var8,
		indexs = {
			4,
			5,
			6
		},
		time = {
			5,
			7
		}
	}
}
local var23 = "event:/ui/ddldaoshu2"
local var24 = "event:/ui/sou"
local var25 = "event:/ui/xueqiu"

local function var26(arg0)
	print(arg0)
end

local function var27(arg0)
	local var0 = {}
	local var1 = 1

	function var0.Ctor(arg0)
		arg0._tf = arg0
		arg0.reloadProgress = findTF(arg0._tf, "reloadProgress")
		arg0.playerAnimator = GetComponent(findTF(arg0._tf, "player"), typeof(Animator))
		arg0.playerDft = GetComponent(findTF(arg0._tf, "player"), typeof(DftAniEvent))

		arg0.playerDft:SetStartEvent(function()
			arg0.playerAnimator:ResetTrigger("throw")
			arg0.playerAnimator:SetBool("snowball", true)
		end)
		arg0.playerDft:SetTriggerEvent(function()
			arg0:throwSnowball()
		end)
		arg0.playerDft:SetEndEvent(function()
			return
		end)

		arg0.heartPos = findTF(arg0._tf, "heartPos")
		arg0.tplHeart = findTF(arg0._tf, "heartPos/tplHeart")
		arg0.collider = findTF(arg0._tf, "collider")
		arg0.throwCallback = nil
		arg0.damageCallback = nil
		arg0.gameOverCallback = nil
	end

	function var0.prepare(arg0)
		arg0._life = var11
		arg0._reloadTime = nil
		arg0._skillTime = nil
		arg0.stepTime = 0

		arg0.playerAnimator:ResetTrigger("skill")
		arg0.playerAnimator:ResetTrigger("throw")
		arg0.playerAnimator:ResetTrigger("damage")
		arg0.playerAnimator:ResetTrigger("reload")
		arg0.playerAnimator:ResetTrigger("fail")
		arg0.playerAnimator:ResetTrigger("win")
		arg0.playerAnimator:ResetTrigger("fail")
		arg0.playerAnimator:SetTrigger("restart")
		arg0.playerAnimator:ResetTrigger("restart")
		arg0:Clear()
	end

	function var0.step(arg0)
		arg0.stepTime = arg0.stepTime + Time.deltaTime

		if not arg0._reloadTime then
			arg0._reloadTime = arg0.stepTime
		end

		if not arg0.playerAnimator:GetBool("snowball") and arg0.stepTime - arg0._reloadTime > var12 then
			arg0:reload()
		end

		if not arg0.playerAnimator:GetBool("snowball") and not isActive(arg0.reloadProgress) then
			setActive(arg0.reloadProgress, true)
		elseif arg0.playerAnimator:GetBool("snowball") and isActive(arg0.reloadProgress) then
			setActive(arg0.reloadProgress, false)
		end

		local var0 = (arg0.stepTime - arg0._reloadTime) / var12

		if var0 > 1 then
			var0 = 1
		end

		setSlider(arg0.reloadProgress, 0, 1, var0)
	end

	function var0.reload(arg0)
		arg0.playerAnimator:SetTrigger("reload")
	end

	function var0.skill(arg0)
		if arg0._skillTime and arg0.stepTime - arg0._skillTime < var14 then
			return
		end

		arg0._skillTime = arg0.stepTime
		arg0._reloadTime = arg0.stepTime

		arg0.playerAnimator:SetTrigger("skill")
	end

	function var0.throw(arg0)
		if arg0.playerAnimator:GetBool("snowball") then
			arg0.playerAnimator:SetTrigger("throw")

			return true
		end

		return false
	end

	function var0.damage(arg0)
		if arg0._life == 0 then
			return
		end

		arg0._life = arg0._life - 1

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25)

		if arg0.damageCallback then
			arg0.damageCallback()
		end

		if arg0._life > 0 then
			arg0.playerAnimator:SetTrigger("damage")
			arg0:createHeart()
		else
			arg0.playerAnimator:SetTrigger("fail")

			if arg0.gameOverCallback then
				arg0.gameOverCallback()
			end
		end
	end

	function var0.createHeart(arg0)
		local var0 = tf(instantiate(arg0.tplHeart))

		GetComponent(var0, typeof(DftAniEvent)):SetEndEvent(function()
			Destroy(var0)
		end)
		setParent(var0, arg0.heartPos)
		setActive(var0, true)
	end

	function var0.setSpeed(arg0, arg1)
		arg0.playerAnimator.speed = arg1
	end

	function var0.throwSnowball(arg0)
		if arg0.throwCallback then
			local var0 = findTF(arg0._tf, "throwPos").position

			arg0.throwCallback(var0)
		end

		arg0.playerAnimator:SetBool("snowball", false)

		arg0._reloadTime = arg0.stepTime
	end

	function var0.move(arg0, arg1)
		arg0._tf.anchoredPosition = arg1
	end

	function var0.settlement(arg0, arg1)
		if arg1 == var5 then
			arg0.playerAnimator:SetTrigger("fail")
		elseif arg1 == var4 then
			arg0.playerAnimator:SetTrigger("win")
		end
	end

	function var0.stop(arg0)
		arg0.playerAnimator.speed = 0
	end

	function var0.resume(arg0)
		arg0.playerAnimator.speed = 1
	end

	function var0.getTargetPosition(arg0)
		return findTF(arg0._tf, "targetPos").position
	end

	function var0.getColliderBound(arg0)
		return arg0.collider.position, arg0.collider.sizeDelta
	end

	function var0.getLife(arg0)
		return arg0._life
	end

	function var0.Clear(arg0)
		arg0._life = var11
	end

	var0:Ctor()

	return var0
end

local function var28(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		_tf = arg0,
		_moveDirect = arg1,
		_targetPosition = arg2,
		_type = arg3,
		_targetIndex = arg4
	}

	var0._id = nil

	function var0.Ctor(arg0)
		arg0._animator = GetComponent(findTF(arg0._tf, "snowball"), typeof(Animator))
		arg0.snowballDft = GetComponent(findTF(arg0._tf, "snowball"), typeof(DftAniEvent))

		arg0.snowballDft:SetEndEvent(function()
			arg0._removeFlag = true

			arg0:dispose()
		end)
	end

	function var0.setId(arg0, arg1)
		arg0._id = arg1
	end

	function var0.getId(arg0, arg1)
		return arg0._id
	end

	function var0.setPosition(arg0, arg1)
		arg0._tf.anchoredPosition = arg1
		arg0._tf.localEulerAngles = Vector3(0, 0, math.atan(arg1.y / arg1.x) * math.rad2Deg)
	end

	function var0.hit(arg0)
		arg0._hitFlag = true

		arg0._animator:SetTrigger("hit")
	end

	function var0.move(arg0)
		local var0 = Time.deltaTime / 0.015

		if var0 > 2 then
			var0 = 1
		end

		local var1 = arg0._tf.anchoredPosition

		if arg0._hitFlag then
			var0 = var0 / 8
		end

		var1.x = var1.x + arg0._moveDirect.x * var0
		var1.y = var1.y + arg0._moveDirect.y * var0
		arg0._tf.anchoredPosition = var1
	end

	function var0.getRemoveFlag(arg0)
		return arg0._removeFlag
	end

	function var0.checkOutScene(arg0)
		local var0 = arg0._tf.anchoredPosition

		if var0.x < var1[1] or var0.x > var1[3] or var0.y < var1[2] or var0.y > var1[4] then
			arg0:dispose()

			return true
		end

		return false
	end

	function var0.getAnchoredPos(arg0)
		return arg0._tf.anchoredPosition
	end

	function var0.getTargetPos(arg0)
		return arg0.tar
	end

	function var0.getType(arg0)
		return arg0._type
	end

	function var0.getIndex(arg0)
		return arg0._targetIndex
	end

	function var0.checkArrived(arg0, arg1, arg2)
		if arg0._hitFlag then
			return
		end

		local var0 = arg0:getAnchoredPos()

		if var0.x > arg1.x and var0.x < arg1.x + arg2.x and var0.y > arg1.y and var0.y < arg1.y + arg2.y then
			return true
		end

		return false
	end

	function var0.getArrived(arg0)
		if arg0._hitFlag then
			return
		end

		local var0 = arg0:getAnchoredPos()

		if math.abs(arg0._targetPosition.x - var0.x) <= math.abs(arg0._moveDirect.x * 2) and math.abs(arg0._targetPosition.y - var0.y) <= math.abs(arg0._moveDirect.y * 2) then
			return true
		end

		return false
	end

	function var0.dispose(arg0)
		if arg0._tf then
			Destroy(arg0._tf)

			arg0._tf = nil
		end
	end

	var0:Ctor()

	return var0
end

local function var29(arg0, arg1)
	local var0 = {
		_snowballContainer = arg0,
		_tplSnowball = arg1,
		snowballs = {}
	}

	var0._snowBallId = 0

	function var0.createSnowball(arg0, arg1, arg2, arg3, arg4, arg5)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var24)

		local var0 = tf(Instantiate(arg0._tplSnowball))

		SetParent(var0, arg0._snowballContainer)
		setActive(var0, true)

		local var1 = arg3 * (arg2.x > arg1.x and 1 or -1)
		local var2 = (arg2.y - arg1.y) / (arg2.x - arg1.x) * var1

		if arg2.x < arg1.x then
			var0.localScale = Vector3(-1, 1, 1)
		end

		local var3 = Vector3(var1, var2, 0)
		local var4 = var28(var0, var3, arg2, arg4, arg5)

		var4:setId(arg0:getSnowBallId())
		var4:setPosition(arg1)
		table.insert(arg0.snowballs, var4)
	end

	function var0.prepare(arg0)
		for iter0 = #arg0.snowballs, 1, -1 do
			local var0 = arg0.snowballs[iter0]

			table.remove(arg0.snowballs, iter0)
			var0:dispose()
		end
	end

	function var0.step(arg0)
		for iter0 = #arg0.snowballs, 1, -1 do
			local var0 = arg0.snowballs[iter0]

			if var0:getRemoveFlag() or var0:checkOutScene() then
				table.remove(arg0.snowballs, iter0)
			else
				var0:move()
			end
		end
	end

	function var0.clearEnemySnowball(arg0)
		for iter0 = #arg0.snowballs, 1, -1 do
			if arg0.snowballs[iter0]:getType() == var3 then
				arg0.snowballs[iter0]:hit()
			end
		end
	end

	function var0.snowballHit(arg0, arg1)
		if not arg1 then
			return
		end

		for iter0 = #arg0.snowballs, 1, -1 do
			if arg0.snowballs[iter0]:getId() == arg1 then
				arg0.snowballs[iter0]:hit()
			end
		end
	end

	function var0.getSnowBallId(arg0)
		arg0._snowBallId = arg0._snowBallId + 1

		return arg0._snowBallId
	end

	function var0.getSnowballs(arg0)
		return Clone(arg0.snowballs)
	end

	return var0
end

local function var30(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		_tf = arg1,
		_index = arg2,
		_data = arg0,
		_name = arg3,
		_score = arg4,
		Ctor = function(arg0)
			arg0.leaveCallback = nil
			arg0.collider = findTF(arg0._tf, "collider")
			arg0.otherAnimator = GetComponent(findTF(arg0._tf, "char"), typeof(Animator))
			arg0.otherDft = GetComponent(findTF(arg0._tf, "char"), typeof(DftAniEvent))

			arg0.otherDft:SetEndEvent(function()
				if arg0.leaveCallback then
					arg0.leaveCallback()
				end

				arg0:dispose()
			end)

			arg0._leaveTime = math.random(arg0._data.time[1], arg0._data.time[2])
		end,
		step = function(arg0)
			if arg0.removeFlag then
				return
			end

			arg0._leaveTime = arg0._leaveTime - Time.deltaTime
		end,
		getColliderBound = function(arg0)
			return arg0.collider.position, arg0.collider.sizeDelta
		end,
		apear = function(arg0)
			arg0.otherAnimator:SetTrigger("apear")
		end,
		damage = function(arg0)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25)
			arg0.otherAnimator:SetTrigger("damage")
		end,
		leave = function(arg0)
			arg0.otherAnimator:SetTrigger("leave")
		end,
		getLeaveTime = function(arg0)
			return arg0._leaveTime
		end,
		getScore = function(arg0)
			return arg0._score
		end,
		getType = function(arg0)
			return arg0._data.type
		end,
		getName = function(arg0)
			return arg0._name
		end,
		setSpeed = function(arg0, arg1)
			arg0.otherAnimator.speed = arg1
		end,
		getPosition = function(arg0)
			return arg0._tf.position
		end,
		dispose = function(arg0)
			arg0.leaveCallback = nil

			if arg0._tf then
				Destroy(arg0._tf)

				arg0._tf = nil
			end

			arg0.removeFlag = true
		end
	}

	var0:Ctor()

	return var0
end

local function var31(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		_tf = arg1,
		_index = arg2,
		_data = arg0,
		_name = arg3,
		_score = arg4,
		Ctor = function(arg0)
			arg0.leaveCallback = nil
			arg0.enemyAnimator = GetComponent(findTF(arg0._tf, "char"), typeof(Animator))
			arg0.enemyDft = GetComponent(findTF(arg0._tf, "char"), typeof(DftAniEvent))
			arg0.collider = findTF(arg0._tf, "collider")
			arg0.throwPos = findTF(arg0._tf, "throwPos")

			arg0.enemyDft:SetEndEvent(function()
				if arg0.leaveCallback then
					arg0.leaveCallback()
				end

				arg0:dispose()
			end)
			arg0.enemyDft:SetTriggerEvent(function()
				if arg0._throwCallback then
					arg0._throwCallback(arg0.throwPos.position, arg0._index)
				end
			end)

			arg0._leaveTime = math.random(arg0._data.time[1], arg0._data.time[2])
			arg0._activeTime = 0
		end
	}

	function var0.setThrowCallback(arg0, arg1)
		var0._throwCallback = arg1
	end

	function var0.getColliderBound(arg0)
		return arg0.collider.position, arg0.collider.sizeDelta
	end

	function var0.step(arg0)
		if arg0.removeFlag then
			return
		end

		arg0._leaveTime = arg0._leaveTime - Time.deltaTime
		arg0._activeTime = arg0._activeTime + Time.deltaTime

		if arg0._activeTime > var21 then
			arg0._activeTime = 0

			if arg0:getSnowball() then
				arg0:throw()
				arg0.enemyAnimator:SetBool("snowball", false)
			else
				arg0.enemyAnimator:SetBool("snowball", true)
				arg0:reload()
			end
		end
	end

	function var0.apear(arg0)
		arg0.enemyAnimator:SetTrigger("apear")
	end

	function var0.damage(arg0)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25)
		arg0.enemyAnimator:SetTrigger("damage")
	end

	function var0.leave(arg0)
		arg0.enemyAnimator:SetTrigger("leave")
	end

	function var0.reload(arg0)
		arg0.enemyAnimator:SetTrigger("reload")
	end

	function var0.throw(arg0)
		arg0.enemyAnimator:SetTrigger("throw")
	end

	function var0.hit(arg0)
		arg0.enemyAnimator:SetTrigger("hit")
	end

	function var0.getSnowball(arg0)
		return arg0.enemyAnimator:GetBool("snowball")
	end

	function var0.getLeaveTime(arg0)
		return arg0._leaveTime
	end

	function var0.getType(arg0)
		return arg0._data.type
	end

	function var0.getScore(arg0)
		return arg0._score
	end

	function var0.setSpeed(arg0, arg1)
		arg0.enemyAnimator.speed = arg1
	end

	function var0.getName(arg0)
		return arg0._name
	end

	function var0.getPosition(arg0)
		return arg0._tf.position
	end

	function var0.dispose(arg0)
		arg0.leaveCallback = nil

		if arg0._tf then
			Destroy(arg0._tf)

			arg0._tf = nil
		end

		arg0.removeFlag = true
	end

	var0:Ctor()

	return var0
end

local function var32(arg0, arg1)
	local var0 = {
		_tplCharactorDic = arg1,
		_charactorContainer = arg0,
		charators = {}
	}

	var0.apearStepTime = nil
	var0.gameStepTime = 0

	function var0.Ctor(arg0)
		for iter0 = 1, var7 do
			arg0.charators[iter0] = 0
		end

		arg0.throwCallback = nil
		arg0.charactorDamageCallback = nil
	end

	function var0.prepare(arg0)
		for iter0, iter1 in pairs(arg0.charators) do
			if iter1 ~= 0 then
				iter1:dispose()

				arg0.charators[iter0] = 0
			end
		end

		arg0.gameStepTime = 0
		arg0.apearStepTime = nil
	end

	function var0.step(arg0)
		arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime

		if arg0.gameStepTime > arg0:getNextApearTime() then
			local var0 = arg0:getApearAmount()

			for iter0 = 1, var0 do
				arg0:apearCharactor()
			end

			arg0:setNextApearTime()
		end

		for iter1 = 1, #arg0.charators do
			if arg0.charators[iter1] ~= 0 then
				local var1 = arg0.charators[iter1]:getLeaveTime()

				if arg0.charators[iter1]:getLeaveTime() < 0 then
					arg0:leaveCharactor(iter1)
				else
					arg0.charators[iter1]:step()
				end
			end
		end
	end

	function var0.leaveCharactor(arg0, arg1)
		if arg0.charators[arg1] ~= 0 then
			arg0.charators[arg1]:leave()

			arg0.charators[arg1] = 0
		end
	end

	function var0.removeCharactor(arg0, arg1)
		if arg0.charators[arg1] ~= 0 then
			arg0.charators[arg1] = 0
		end
	end

	function var0.damageEnemy(arg0)
		for iter0 = 1, #arg0.charators do
			if arg0.charators[iter0] and arg0.charators[iter0] ~= 0 and arg0.charators[iter0]:getScore() > 0 then
				if arg0.charactorDamageCallback then
					arg0.charactorDamageCallback(arg0.charators[iter0]:getPosition(), arg0.charators[iter0]:getScore())
				end

				arg0.charators[iter0]:damage()
				arg0:removeCharactor(iter0)
			end
		end
	end

	function var0.getCharactorByIndex(arg0, arg1)
		return arg0.charators[arg1]
	end

	function var0.apearCharactor(arg0)
		local var0 = arg0:getAbleRandomDatas()

		if not var0 then
			return
		end

		local var1 = arg0:getDataByWeight(var0)

		if not var1 then
			return
		end

		local var2, var3 = arg0:getCharactorName(var10[var1.type])
		local var4 = arg0:getCharactorRandomIndex(var1)
		local var5 = arg0:createCharactor(var1, var4, var2, var3)

		if var5 then
			arg0:addCharactor(var5, var4)
		end
	end

	function var0.setSpeed(arg0, arg1)
		arg0.speedValue = arg1

		for iter0 = 1, #arg0.charators do
			if arg0.charators[iter0] and arg0.charators[iter0] ~= 0 then
				arg0.charators[iter0]:setSpeed(arg1)
			end
		end
	end

	function var0.createCharactor(arg0, arg1, arg2, arg3, arg4)
		local var0 = tf(Instantiate(arg0._tplCharactorDic[arg3]))
		local var1 = findTF(arg0._charactorContainer, arg2)

		SetParent(var0, var1)
		setActive(var0, true)

		local var2

		if arg1.type == var8 then
			var2 = var30(arg1, var0, arg2, arg3, arg4)
		elseif arg1.type == var9 then
			var2 = var31(arg1, var0, arg2, arg3, arg4)

			var2:setThrowCallback(arg0.throwCallback)
		end

		return var2
	end

	function var0.addCharactor(arg0, arg1, arg2)
		arg0.charators[arg2] = arg1

		arg1:apear()
	end

	function var0.getCharactorRandomIndex(arg0, arg1)
		local var0 = arg0:getEmptyIndex()
		local var1 = {}

		for iter0 = 1, #var0 do
			if table.contains(arg1.indexs, var0[iter0]) then
				table.insert(var1, var0[iter0])
			end
		end

		if #var1 then
			return var1[math.random(1, #var1)]
		end

		return nil
	end

	function var0.getCharactorName(arg0, arg1)
		local var0 = arg1.skin_names
		local var1 = math.random(1, #arg1.skin_names)

		return arg1.skin_names[var1], arg1.score[var1]
	end

	function var0.getDataByWeight(arg0, arg1)
		if #arg1 == 1 then
			return arg1[1]
		else
			if not arg0.charactorWeight then
				arg0.charactorWeight = {}
				arg0.charactorSubWeight = 0

				for iter0 = 1, #arg1 do
					arg0.charactorSubWeight = arg0.charactorSubWeight + arg1[iter0].weight

					table.insert(arg0.charactorWeight, arg0.charactorSubWeight)
				end
			end

			local var0 = math.random(0, arg0.charactorSubWeight)

			for iter1 = #arg0.charactorWeight - 1, 1, -1 do
				if var0 > arg0.charactorWeight[iter1] then
					return arg1[iter1 + 1]
				end
			end

			return arg1[1]
		end

		return nil
	end

	function var0.getAbleRandomDatas(arg0)
		local var0 = {}
		local var1 = arg0:getEmptyIndex()

		if #var1 == 0 then
			return var0
		end

		for iter0 = 1, #var22 do
			local var2 = var22[iter0].indexs
			local var3

			for iter1, iter2 in ipairs(var2) do
				if table.contains(var1, iter2) and not var3 then
					table.insert(var0, var22[iter0])

					var3 = true
				end
			end
		end

		return var0
	end

	function var0.getEmptyIndex(arg0)
		local var0 = {}

		for iter0, iter1 in pairs(arg0.charators) do
			if iter1 == 0 then
				table.insert(var0, iter0)
			end
		end

		return var0
	end

	function var0.getNextApearTime(arg0)
		if not arg0.apearStepTime then
			arg0:setNextApearTime()
		end

		return arg0.apearStepTime
	end

	function var0.setNextApearTime(arg0)
		if not arg0.apearStepTime then
			arg0.apearStepTime = 0
		end

		arg0.apearStepTime = arg0.apearStepTime + arg0:getApearTime()
	end

	function var0.getApearTime(arg0)
		local var0 = 1

		for iter0 = #var20, 1, -1 do
			if arg0.gameStepTime > var20[iter0] then
				var0 = iter0

				break
			end
		end

		local var1 = var18[var0][2] - var18[var0][1]
		local var2 = var18[var0][1]

		return math.random() * var1 + var2
	end

	function var0.getApearAmount(arg0)
		local var0 = 1

		for iter0 = #var20, 1, -1 do
			if arg0.gameStepTime > var20[iter0] then
				var0 = iter0

				break
			end
		end

		local var1 = var19[var0]
		local var2 = 0
		local var3 = {}

		for iter1 = 1, #var1 do
			var2 = var2 + var1[iter1]

			table.insert(var3, var2)
		end

		local var4 = math.random(0, var2)

		for iter2 = #var3 - 1, 1, -1 do
			if var4 > var3[iter2] then
				return iter2 + 1
			end
		end

		return 1
	end

	var0:Ctor()

	return var0
end

local function var33(arg0, arg1, arg2, arg3)
	local var0 = {
		_player = arg1,
		_charactorCtrl = arg3,
		_snowballCtrl = arg2,
		_sceneTf = arg0
	}

	var0.hitEnemyCallback = nil

	function var0.Ctor(arg0)
		return
	end

	function var0.prepare(arg0)
		return
	end

	function var0.step(arg0)
		local var0 = arg0._snowballCtrl:getSnowballs()

		for iter0 = 1, #var0 do
			local var1 = var0[iter0]:getType()
			local var2 = var0[iter0]:getIndex()
			local var3 = arg3:getCharactorByIndex(var2)

			if var1 == var2 then
				if var3 and var3 ~= 0 then
					local var4, var5 = var3:getColliderBound()
					local var6 = arg0._sceneTf:InverseTransformPoint(var4)

					if var0[iter0]:checkArrived(var6, var5) then
						var3:damage()
						arg0._snowballCtrl:snowballHit(var0[iter0]:getId())
						arg3:removeCharactor(var2)

						if arg0.hitEnemyCallback then
							arg0.hitEnemyCallback(var3:getType(), var3:getName(), var3:getScore(), var3:getPosition())
						end
					end
				end
			elseif var1 == var3 then
				local var7, var8 = arg0._player:getColliderBound()
				local var9 = arg0._sceneTf:InverseTransformPoint(var7)

				if var0[iter0]:checkArrived(var9, var8) then
					if var3 and var3 ~= 0 and var3:getType() == var9 then
						var3:hit()
					end

					arg0._player:damage()
					arg0._snowballCtrl:snowballHit(var0[iter0]:getId())
				end
			end
		end
	end

	var0:Ctor()

	return var0
end

function var0.getUIName(arg0)
	return "SnowballGameUI"
end

function var0.getBGM(arg0)
	return "backyard"
end

function var0.didEnter(arg0)
	arg0:initData()
	arg0:initUI()
end

function var0.initData(arg0)
	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 0.0166666666666667, -1)
end

function var0.initUI(arg0)
	arg0.sceneTf = findTF(arg0._tf, "scene")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.player = var27(findTF(arg0._tf, "scene/luao"))

	function arg0.player.throwCallback(arg0)
		arg0:onPlayerThrowSnowball(arg0)
	end

	function arg0.player.damageCallback()
		arg0:onPlayerDamage()
	end

	function arg0.player.gameOverCallback()
		arg0:onGameOver()
	end

	arg0.snowballContainer = findTF(arg0._tf, "scene_front/snowballContainer")
	arg0.tplSnowball = findTF(arg0._tf, "tplSnowball")
	arg0.snowballController = var29(arg0.snowballContainer, arg0.tplSnowball)
	arg0.tplScore = findTF(arg0._tf, "tplScore")
	arg0.specialTf = findTF(arg0._tf, "scene_front/special")
	arg0.specialAniamtor = GetComponent(arg0.specialTf, typeof(Animator))

	GetComponent(arg0.specialTf, typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0:specialComplete()
	end)

	arg0.charactorContainer = findTF(arg0._tf, "scene/charactorContainer")

	local var0 = {}

	for iter0, iter1 in pairs(var10) do
		local var1 = iter1.skin_names

		for iter2, iter3 in ipairs(var1) do
			var0[iter3] = findTF(arg0._tf, "charactor/" .. iter3)
		end
	end

	arg0.charactorController = var32(arg0.charactorContainer, var0)

	function arg0.charactorController.throwCallback(arg0, arg1)
		function arg0.charactorController.charactorDamageCallback(arg0, arg1)
			arg0:onHitEnemy(arg1, arg0)
		end

		local var0 = var17[arg0:getCurrentDiff()]

		arg0:onEnemyThrowSnowball(arg0, arg1, var0)
	end

	arg0.colliderController = var33(arg0.sceneTf, arg0.player, arg0.snowballController, arg0.charactorController)

	function arg0.colliderController.hitEnemyCallback(arg0, arg1, arg2, arg3)
		arg0:onHitEnemy(arg2, arg3)
	end

	local var2 = findTF(arg0._tf, "scene/moveCollider")

	arg0.playerMoveVecs = {}

	for iter4 = 1, var6 do
		local var3 = findTF(var2, iter4)

		table.insert(arg0.playerMoveVecs, var3.anchoredPosition)
	end

	arg0.lockTf = findTF(arg0._tf, "scene_front/lock")

	local var4 = findTF(arg0._tf, "scene/throwCollider")

	for iter5 = 1, var7 do
		local var5 = findTF(var4, iter5)
		local var6 = iter5

		onButton(arg0, var5, function()
			local var0 = arg0.charactorController:getCharactorByIndex(var6)

			if var0 and var0 ~= 0 then
				local var1 = findTF(var5, "target").position
				local var2 = arg0.sceneTf:InverseTransformPoint(var1.x, var1.y, 0)

				arg0:throwSnowballTo(var2, var6, var0)
			end
		end)
	end

	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0.player:settlement(var4)
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = arg0:getGameTotalTime()

	local var7 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.battleScrollRect, 0, 1 - var7 / (arg0.totalTimes - 4))
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.snowball_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CANCEL)

	local var8 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}

	for iter6 = 1, arg0.totalTimes do
		local var9 = tf(instantiate(var8))

		var9.name = "battleItem_" .. iter6

		setParent(var9, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var10 = iter6

		GetSpriteFromAtlasAsync("ui/minigameui/snowballgameui_atlas", "tx_" .. var10, function(arg0)
			setImageSprite(findTF(var9, "state_open/icon"), arg0, true)
			setImageSprite(findTF(var9, "state_clear/icon"), arg0, true)
			setImageSprite(findTF(var9, "state_current/icon"), arg0, true)
		end)
		GetSpriteFromAtlasAsync("ui/minigameui/snowballgameui_atlas", "battleDesc" .. var10, function(arg0)
			setImageSprite(findTF(var9, "state_open/buttomDesc"), arg0, true)
			setImageSprite(findTF(var9, "state_clear/buttomDesc"), arg0, true)
			setImageSprite(findTF(var9, "state_current/buttomDesc"), arg0, true)
			setImageSprite(findTF(var9, "state_closed/buttomDesc"), arg0, true)
		end)
		setActive(var9, true)
		table.insert(arg0.battleItems, var9)
	end

	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")
	arg0.lifeProgress = findTF(arg0.gameUI, "lifeProgress")
	arg0.textLife = findTF(arg0.gameUI, "life")
	arg0.textScore = findTF(arg0.gameUI, "score")

	onButton(arg0, findTF(arg0.gameUI, "btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnMoveUp"), function()
		if arg0.playerPosIndex > 1 then
			arg0.playerPosIndex = arg0.playerPosIndex - 1

			arg0:movePlayerTo(arg0.playerPosIndex)
		end
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnMoveDown"), function()
		if arg0.playerPosIndex < #arg0.playerMoveVecs then
			arg0.playerPosIndex = arg0.playerPosIndex + 1

			arg0:movePlayerTo(arg0.playerPosIndex)
		end
	end)

	arg0.btnSkill = findTF(arg0.gameUI, "btnSkill")

	onButton(arg0, arg0.btnSkill, function()
		if arg0.skilTime == var14 then
			arg0.skilTime = 0

			arg0:usePlayerSkill()
		end
	end)
	arg0:updateMenuUI()
	arg0:openMenuUI()

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.W) and arg0.playerPosIndex and arg0.playerPosIndex > 1 then
			arg0.playerPosIndex = arg0.playerPosIndex - 1

			arg0:movePlayerTo(arg0.playerPosIndex)
		end

		if Input.GetKeyDown(KeyCode.S) and arg0.playerPosIndex and arg0.playerPosIndex < #arg0.playerMoveVecs then
			arg0.playerPosIndex = arg0.playerPosIndex + 1

			arg0:movePlayerTo(arg0.playerPosIndex)
		end
	end
end

function var0.getCurrentDiff(arg0)
	for iter0 = #var20, 1, -1 do
		if arg0.gameStepTime > var20[iter0] then
			return iter0
		end
	end
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet()
end

function var0.CheckGet(arg0)
	setActive(findTF(arg0.menuUI, "got"), false)

	if arg0:getUltimate() and arg0:getUltimate() ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "scene_front"), false)
	setActive(findTF(arg0._tf, "scene_background"), false)
	setActive(findTF(arg0._tf, "scene"), false)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	arg0:updateMenuUI()
end

function var0.clearUI(arg0)
	setActive(arg0.sceneTf, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	if arg0.sendSuccessFlag then
		local var0 = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.NewYearShrineGameID):GetRuntimeData("count") or 0) + 2

		pg.m02:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
			id = MiniGameDataCreator.NewYearShrineGameID,
			map = {
				count = var0
			}
		})

		arg0.sendSuccessFlag = false
	end
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var23)
end

function var0.gameStart(arg0)
	setActive(findTF(arg0._tf, "scene_front"), true)
	setActive(findTF(arg0._tf, "scene_background"), true)
	setActive(findTF(arg0._tf, "scene"), true)
	setActive(arg0.gameUI, true)
	setActive(arg0.lockTf, false)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.skilTime = 0
	arg0.playerPosIndex = 2

	arg0:movePlayerTo(arg0.playerPosIndex)

	arg0.specialTime = 0
	arg0.gameStepTime = 0

	arg0.player:prepare()
	arg0.snowballController:prepare()
	arg0.charactorController:prepare()
	arg0.colliderController:prepare()
	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.onPlayerDamage(arg0)
	arg0:updateGameUI()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.changeSpeed(arg0, arg1)
	arg0.player:setSpeed(arg1)

	arg0.specialAniamtor.speed = arg1

	arg0.charactorController:setSpeed(arg1)
end

function var0.onTimer(arg0)
	arg0.player:step()
	arg0.snowballController:step()
	arg0.charactorController:step()
	arg0.colliderController:step()
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime
	arg0.skilTime = arg0.skilTime + Time.deltaTime

	if arg0.skilTime > var14 then
		arg0.skilTime = var14
	end

	if not arg0.skillProgress then
		arg0.skillProgress = GetComponent(findTF(arg0.btnSkill, "progress"), typeof(Image))
	end

	arg0.skillProgress.fillAmount = arg0.skilTime / var14

	if arg0.skilTime == var14 then
		if not isActive(findTF(arg0.gameUI, "xuehezhan_zhiyuantiao")) then
			setActive(findTF(arg0.gameUI, "xuehezhan_zhiyuantiao"), true)
		end
	elseif isActive(findTF(arg0.gameUI, "xuehezhan_zhiyuantiao")) then
		setActive(findTF(arg0.gameUI, "xuehezhan_zhiyuantiao"), false)
	end

	if arg0.gameStepTime < arg0.specialTime then
		if not arg0.specialIndex then
			arg0.specialIndex = 0
		end

		if arg0.specialIndex > 20 then
			arg0.specialIndex = 0

			arg0.charactorController:damageEnemy()
		end

		arg0.specialIndex = arg0.specialIndex + 1
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.movePlayerTo(arg0, arg1)
	arg0.player:move(arg0.playerMoveVecs[arg1])
end

function var0.updateGameUI(arg0)
	setSlider(arg0.lifeProgress, 0, 1, arg0.player:getLife() / var11)
	setText(arg0.textLife, arg0.player:getLife() .. "/" .. var11)
	setText(arg0.textScore, arg0.scoreNum)
end

function var0.throwSnowballTo(arg0, arg1, arg2, arg3)
	arg0.throwTarget = arg1
	arg0.targetIndex = arg2

	if arg0.player:throw() and arg0.targetCharactor ~= arg3 then
		setActive(arg0.lockTf, false)

		arg0.lockTf.anchoredPosition = arg1

		setActive(arg0.lockTf, true)

		arg0.targetCharactor = arg3
	end
end

function var0.onPlayerThrowSnowball(arg0, arg1)
	if arg0.throwTarget then
		local var0 = arg0.sceneTf:InverseTransformPoint(arg1.x, arg1.y, 0)
		local var1 = arg0.throwTarget

		arg0.snowballController:createSnowball(var0, var1, var13, var2, arg0.targetIndex)

		arg0.throwTarget = nil
		arg0.targetIndex = nil
	end
end

function var0.onEnemyThrowSnowball(arg0, arg1, arg2, arg3)
	local var0 = arg0.sceneTf:InverseTransformPoint(arg1.x, arg1.y, 0)
	local var1 = arg0.player:getTargetPosition()
	local var2 = arg0.sceneTf:InverseTransformPoint(var1.x, var1.y, 0)

	arg0.snowballController:createSnowball(var0, var2, arg3, var3, arg2)
end

function var0.usePlayerSkill(arg0)
	Time.timeScale = 0.05

	LeanTween.delayedCall(go(arg0.specialTf), 3, System.Action(function()
		if Time.timeScale ~= 1 then
			Time.timeScale = 1
		end
	end))
	arg0.player:skill()
	arg0.snowballController:clearEnemySnowball()
	setActive(arg0.specialTf, true)

	if not arg0.specialEffect then
		arg0.specialEffect = findTF(arg0._tf, "xuehezhan_xueqiuhongzha")
	end

	setActive(arg0.specialEffect, false)
	setActive(arg0.specialEffect, true)
end

function var0.specialComplete(arg0)
	Time.timeScale = 1

	setActive(arg0.specialTf, false)

	arg0.specialTime = arg0.gameStepTime + var15
	arg0.specialIndex = 0
end

function var0.dropSpeedUp(arg0)
	return
end

function var0.onHitEnemy(arg0, arg1, arg2)
	arg0:addScore(arg1, arg2)
	arg0:updateGameUI()
end

function var0.addScore(arg0, arg1, arg2)
	arg0.scoreNum = arg0.scoreNum + arg1

	if arg0.scoreNum < 0 then
		arg0.scoreNum = 0
	end

	local var0 = tf(instantiate(arg0.tplScore))
	local var1 = findTF(var0, "ad")
	local var2 = GetComponent(var1, typeof(DftAniEvent))

	var0.anchoredPosition = arg0.snowballContainer:InverseTransformPoint(arg2)

	if arg1 > 0 then
		setActive(findTF(var1, "add"), true)
		setText(findTF(var1, "add"), "+" .. arg1)
	else
		setActive(findTF(var1, "sub"), true)
		setText(findTF(var1, "sub"), arg1)
	end

	setParent(var0, arg0.snowballContainer)
	var2:SetEndEvent(function()
		setActive(var0, false)
		Destroy(var0)
	end)
	setActive(var0, true)
end

function var0.onGameOver(arg0)
	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 2, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		setActive(findTF(arg0.gameUI, "xuehezhan_zhiyuantiao"), false)
		setActive(arg0.specialTf, false)
		arg0:showSettlement()
	end))
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)
	end
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:changeSpeed(1)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
	arg0:changeSpeed(0)
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if not arg0._tf then
		print()
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.specialTf and LeanTween.isTweening(go(arg0.specialTf)) then
		LeanTween.cancel(go(arg0.specialTf))
	end

	if arg0.specialEffect and LeanTween.isTweening(go(arg0.specialEffect)) then
		LeanTween.cancel(go(arg0.specialEffect))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
