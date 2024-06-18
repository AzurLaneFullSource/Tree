local var0_0 = class("SnowballGameView", import("..BaseMiniGameView"))
local var1_0 = {
	-1920,
	-1080,
	1920,
	1080
}
local var2_0 = "snowball_type_player"
local var3_0 = "snowball_type_enemy"
local var4_0 = "win"
local var5_0 = "fail"
local var6_0 = 3
local var7_0 = 6
local var8_0 = "charactor_type_other"
local var9_0 = "charactor_type_enemy"
local var10_0 = {
	charactor_type_other = {
		type = var8_0,
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
		type = var9_0,
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
local var11_0 = 3
local var12_0 = 1
local var13_0 = 18
local var14_0 = 30
local var15_0 = 3
local var16_0 = 100
local var17_0 = {
	12,
	14,
	15,
	16,
	17
}
local var18_0 = {
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
local var19_0 = {
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
local var20_0 = {
	0,
	30,
	60,
	90,
	120
}
local var21_0 = 1.5
local var22_0 = {
	{
		weight = 70,
		type = var9_0,
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
		type = var8_0,
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
local var23_0 = "event:/ui/ddldaoshu2"
local var24_0 = "event:/ui/sou"
local var25_0 = "event:/ui/xueqiu"

local function var26_0(arg0_1)
	print(arg0_1)
end

local function var27_0(arg0_2)
	local var0_2 = {}
	local var1_2 = 1

	function var0_2.Ctor(arg0_3)
		arg0_3._tf = arg0_2
		arg0_3.reloadProgress = findTF(arg0_3._tf, "reloadProgress")
		arg0_3.playerAnimator = GetComponent(findTF(arg0_3._tf, "player"), typeof(Animator))
		arg0_3.playerDft = GetComponent(findTF(arg0_3._tf, "player"), typeof(DftAniEvent))

		arg0_3.playerDft:SetStartEvent(function()
			arg0_3.playerAnimator:ResetTrigger("throw")
			arg0_3.playerAnimator:SetBool("snowball", true)
		end)
		arg0_3.playerDft:SetTriggerEvent(function()
			arg0_3:throwSnowball()
		end)
		arg0_3.playerDft:SetEndEvent(function()
			return
		end)

		arg0_3.heartPos = findTF(arg0_3._tf, "heartPos")
		arg0_3.tplHeart = findTF(arg0_3._tf, "heartPos/tplHeart")
		arg0_3.collider = findTF(arg0_3._tf, "collider")
		arg0_3.throwCallback = nil
		arg0_3.damageCallback = nil
		arg0_3.gameOverCallback = nil
	end

	function var0_2.prepare(arg0_7)
		arg0_7._life = var11_0
		arg0_7._reloadTime = nil
		arg0_7._skillTime = nil
		arg0_7.stepTime = 0

		arg0_7.playerAnimator:ResetTrigger("skill")
		arg0_7.playerAnimator:ResetTrigger("throw")
		arg0_7.playerAnimator:ResetTrigger("damage")
		arg0_7.playerAnimator:ResetTrigger("reload")
		arg0_7.playerAnimator:ResetTrigger("fail")
		arg0_7.playerAnimator:ResetTrigger("win")
		arg0_7.playerAnimator:ResetTrigger("fail")
		arg0_7.playerAnimator:SetTrigger("restart")
		arg0_7.playerAnimator:ResetTrigger("restart")
		arg0_7:Clear()
	end

	function var0_2.step(arg0_8)
		arg0_8.stepTime = arg0_8.stepTime + Time.deltaTime

		if not arg0_8._reloadTime then
			arg0_8._reloadTime = arg0_8.stepTime
		end

		if not arg0_8.playerAnimator:GetBool("snowball") and arg0_8.stepTime - arg0_8._reloadTime > var12_0 then
			arg0_8:reload()
		end

		if not arg0_8.playerAnimator:GetBool("snowball") and not isActive(arg0_8.reloadProgress) then
			setActive(arg0_8.reloadProgress, true)
		elseif arg0_8.playerAnimator:GetBool("snowball") and isActive(arg0_8.reloadProgress) then
			setActive(arg0_8.reloadProgress, false)
		end

		local var0_8 = (arg0_8.stepTime - arg0_8._reloadTime) / var12_0

		if var0_8 > 1 then
			var0_8 = 1
		end

		setSlider(arg0_8.reloadProgress, 0, 1, var0_8)
	end

	function var0_2.reload(arg0_9)
		arg0_9.playerAnimator:SetTrigger("reload")
	end

	function var0_2.skill(arg0_10)
		if arg0_10._skillTime and arg0_10.stepTime - arg0_10._skillTime < var14_0 then
			return
		end

		arg0_10._skillTime = arg0_10.stepTime
		arg0_10._reloadTime = arg0_10.stepTime

		arg0_10.playerAnimator:SetTrigger("skill")
	end

	function var0_2.throw(arg0_11)
		if arg0_11.playerAnimator:GetBool("snowball") then
			arg0_11.playerAnimator:SetTrigger("throw")

			return true
		end

		return false
	end

	function var0_2.damage(arg0_12)
		if arg0_12._life == 0 then
			return
		end

		arg0_12._life = arg0_12._life - 1

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25_0)

		if arg0_12.damageCallback then
			arg0_12.damageCallback()
		end

		if arg0_12._life > 0 then
			arg0_12.playerAnimator:SetTrigger("damage")
			arg0_12:createHeart()
		else
			arg0_12.playerAnimator:SetTrigger("fail")

			if arg0_12.gameOverCallback then
				arg0_12.gameOverCallback()
			end
		end
	end

	function var0_2.createHeart(arg0_13)
		local var0_13 = tf(instantiate(arg0_13.tplHeart))

		GetComponent(var0_13, typeof(DftAniEvent)):SetEndEvent(function()
			Destroy(var0_13)
		end)
		setParent(var0_13, arg0_13.heartPos)
		setActive(var0_13, true)
	end

	function var0_2.setSpeed(arg0_15, arg1_15)
		arg0_15.playerAnimator.speed = arg1_15
	end

	function var0_2.throwSnowball(arg0_16)
		if arg0_16.throwCallback then
			local var0_16 = findTF(arg0_16._tf, "throwPos").position

			arg0_16.throwCallback(var0_16)
		end

		arg0_16.playerAnimator:SetBool("snowball", false)

		arg0_16._reloadTime = arg0_16.stepTime
	end

	function var0_2.move(arg0_17, arg1_17)
		arg0_17._tf.anchoredPosition = arg1_17
	end

	function var0_2.settlement(arg0_18, arg1_18)
		if arg1_18 == var5_0 then
			arg0_18.playerAnimator:SetTrigger("fail")
		elseif arg1_18 == var4_0 then
			arg0_18.playerAnimator:SetTrigger("win")
		end
	end

	function var0_2.stop(arg0_19)
		arg0_19.playerAnimator.speed = 0
	end

	function var0_2.resume(arg0_20)
		arg0_20.playerAnimator.speed = 1
	end

	function var0_2.getTargetPosition(arg0_21)
		return findTF(arg0_21._tf, "targetPos").position
	end

	function var0_2.getColliderBound(arg0_22)
		return arg0_22.collider.position, arg0_22.collider.sizeDelta
	end

	function var0_2.getLife(arg0_23)
		return arg0_23._life
	end

	function var0_2.Clear(arg0_24)
		arg0_24._life = var11_0
	end

	var0_2:Ctor()

	return var0_2
end

local function var28_0(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	local var0_25 = {
		_tf = arg0_25,
		_moveDirect = arg1_25,
		_targetPosition = arg2_25,
		_type = arg3_25,
		_targetIndex = arg4_25
	}

	var0_25._id = nil

	function var0_25.Ctor(arg0_26)
		arg0_26._animator = GetComponent(findTF(arg0_26._tf, "snowball"), typeof(Animator))
		arg0_26.snowballDft = GetComponent(findTF(arg0_26._tf, "snowball"), typeof(DftAniEvent))

		arg0_26.snowballDft:SetEndEvent(function()
			arg0_26._removeFlag = true

			arg0_26:dispose()
		end)
	end

	function var0_25.setId(arg0_28, arg1_28)
		arg0_28._id = arg1_28
	end

	function var0_25.getId(arg0_29, arg1_29)
		return arg0_29._id
	end

	function var0_25.setPosition(arg0_30, arg1_30)
		arg0_30._tf.anchoredPosition = arg1_30
		arg0_30._tf.localEulerAngles = Vector3(0, 0, math.atan(arg1_25.y / arg1_25.x) * math.rad2Deg)
	end

	function var0_25.hit(arg0_31)
		arg0_31._hitFlag = true

		arg0_31._animator:SetTrigger("hit")
	end

	function var0_25.move(arg0_32)
		local var0_32 = Time.deltaTime / 0.015

		if var0_32 > 2 then
			var0_32 = 1
		end

		local var1_32 = arg0_32._tf.anchoredPosition

		if arg0_32._hitFlag then
			var0_32 = var0_32 / 8
		end

		var1_32.x = var1_32.x + arg0_32._moveDirect.x * var0_32
		var1_32.y = var1_32.y + arg0_32._moveDirect.y * var0_32
		arg0_32._tf.anchoredPosition = var1_32
	end

	function var0_25.getRemoveFlag(arg0_33)
		return arg0_33._removeFlag
	end

	function var0_25.checkOutScene(arg0_34)
		local var0_34 = arg0_34._tf.anchoredPosition

		if var0_34.x < var1_0[1] or var0_34.x > var1_0[3] or var0_34.y < var1_0[2] or var0_34.y > var1_0[4] then
			arg0_34:dispose()

			return true
		end

		return false
	end

	function var0_25.getAnchoredPos(arg0_35)
		return arg0_35._tf.anchoredPosition
	end

	function var0_25.getTargetPos(arg0_36)
		return arg0_36.tar
	end

	function var0_25.getType(arg0_37)
		return arg0_37._type
	end

	function var0_25.getIndex(arg0_38)
		return arg0_38._targetIndex
	end

	function var0_25.checkArrived(arg0_39, arg1_39, arg2_39)
		if arg0_39._hitFlag then
			return
		end

		local var0_39 = arg0_39:getAnchoredPos()

		if var0_39.x > arg1_39.x and var0_39.x < arg1_39.x + arg2_39.x and var0_39.y > arg1_39.y and var0_39.y < arg1_39.y + arg2_39.y then
			return true
		end

		return false
	end

	function var0_25.getArrived(arg0_40)
		if arg0_40._hitFlag then
			return
		end

		local var0_40 = arg0_40:getAnchoredPos()

		if math.abs(arg0_40._targetPosition.x - var0_40.x) <= math.abs(arg0_40._moveDirect.x * 2) and math.abs(arg0_40._targetPosition.y - var0_40.y) <= math.abs(arg0_40._moveDirect.y * 2) then
			return true
		end

		return false
	end

	function var0_25.dispose(arg0_41)
		if arg0_41._tf then
			Destroy(arg0_41._tf)

			arg0_41._tf = nil
		end
	end

	var0_25:Ctor()

	return var0_25
end

local function var29_0(arg0_42, arg1_42)
	local var0_42 = {
		_snowballContainer = arg0_42,
		_tplSnowball = arg1_42,
		snowballs = {}
	}

	var0_42._snowBallId = 0

	function var0_42.createSnowball(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43, arg5_43)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var24_0)

		local var0_43 = tf(Instantiate(arg0_43._tplSnowball))

		SetParent(var0_43, arg0_43._snowballContainer)
		setActive(var0_43, true)

		local var1_43 = arg3_43 * (arg2_43.x > arg1_43.x and 1 or -1)
		local var2_43 = (arg2_43.y - arg1_43.y) / (arg2_43.x - arg1_43.x) * var1_43

		if arg2_43.x < arg1_43.x then
			var0_43.localScale = Vector3(-1, 1, 1)
		end

		local var3_43 = Vector3(var1_43, var2_43, 0)
		local var4_43 = var28_0(var0_43, var3_43, arg2_43, arg4_43, arg5_43)

		var4_43:setId(arg0_43:getSnowBallId())
		var4_43:setPosition(arg1_43)
		table.insert(arg0_43.snowballs, var4_43)
	end

	function var0_42.prepare(arg0_44)
		for iter0_44 = #arg0_44.snowballs, 1, -1 do
			local var0_44 = arg0_44.snowballs[iter0_44]

			table.remove(arg0_44.snowballs, iter0_44)
			var0_44:dispose()
		end
	end

	function var0_42.step(arg0_45)
		for iter0_45 = #arg0_45.snowballs, 1, -1 do
			local var0_45 = arg0_45.snowballs[iter0_45]

			if var0_45:getRemoveFlag() or var0_45:checkOutScene() then
				table.remove(arg0_45.snowballs, iter0_45)
			else
				var0_45:move()
			end
		end
	end

	function var0_42.clearEnemySnowball(arg0_46)
		for iter0_46 = #arg0_46.snowballs, 1, -1 do
			if arg0_46.snowballs[iter0_46]:getType() == var3_0 then
				arg0_46.snowballs[iter0_46]:hit()
			end
		end
	end

	function var0_42.snowballHit(arg0_47, arg1_47)
		if not arg1_47 then
			return
		end

		for iter0_47 = #arg0_47.snowballs, 1, -1 do
			if arg0_47.snowballs[iter0_47]:getId() == arg1_47 then
				arg0_47.snowballs[iter0_47]:hit()
			end
		end
	end

	function var0_42.getSnowBallId(arg0_48)
		arg0_48._snowBallId = arg0_48._snowBallId + 1

		return arg0_48._snowBallId
	end

	function var0_42.getSnowballs(arg0_49)
		return Clone(arg0_49.snowballs)
	end

	return var0_42
end

local function var30_0(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50)
	local var0_50 = {
		_tf = arg1_50,
		_index = arg2_50,
		_data = arg0_50,
		_name = arg3_50,
		_score = arg4_50,
		Ctor = function(arg0_51)
			arg0_51.leaveCallback = nil
			arg0_51.collider = findTF(arg0_51._tf, "collider")
			arg0_51.otherAnimator = GetComponent(findTF(arg0_51._tf, "char"), typeof(Animator))
			arg0_51.otherDft = GetComponent(findTF(arg0_51._tf, "char"), typeof(DftAniEvent))

			arg0_51.otherDft:SetEndEvent(function()
				if arg0_51.leaveCallback then
					arg0_51.leaveCallback()
				end

				arg0_51:dispose()
			end)

			arg0_51._leaveTime = math.random(arg0_51._data.time[1], arg0_51._data.time[2])
		end,
		step = function(arg0_53)
			if arg0_53.removeFlag then
				return
			end

			arg0_53._leaveTime = arg0_53._leaveTime - Time.deltaTime
		end,
		getColliderBound = function(arg0_54)
			return arg0_54.collider.position, arg0_54.collider.sizeDelta
		end,
		apear = function(arg0_55)
			arg0_55.otherAnimator:SetTrigger("apear")
		end,
		damage = function(arg0_56)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25_0)
			arg0_56.otherAnimator:SetTrigger("damage")
		end,
		leave = function(arg0_57)
			arg0_57.otherAnimator:SetTrigger("leave")
		end,
		getLeaveTime = function(arg0_58)
			return arg0_58._leaveTime
		end,
		getScore = function(arg0_59)
			return arg0_59._score
		end,
		getType = function(arg0_60)
			return arg0_60._data.type
		end,
		getName = function(arg0_61)
			return arg0_61._name
		end,
		setSpeed = function(arg0_62, arg1_62)
			arg0_62.otherAnimator.speed = arg1_62
		end,
		getPosition = function(arg0_63)
			return arg0_63._tf.position
		end,
		dispose = function(arg0_64)
			arg0_64.leaveCallback = nil

			if arg0_64._tf then
				Destroy(arg0_64._tf)

				arg0_64._tf = nil
			end

			arg0_64.removeFlag = true
		end
	}

	var0_50:Ctor()

	return var0_50
end

local function var31_0(arg0_65, arg1_65, arg2_65, arg3_65, arg4_65)
	local var0_65 = {
		_tf = arg1_65,
		_index = arg2_65,
		_data = arg0_65,
		_name = arg3_65,
		_score = arg4_65,
		Ctor = function(arg0_66)
			arg0_66.leaveCallback = nil
			arg0_66.enemyAnimator = GetComponent(findTF(arg0_66._tf, "char"), typeof(Animator))
			arg0_66.enemyDft = GetComponent(findTF(arg0_66._tf, "char"), typeof(DftAniEvent))
			arg0_66.collider = findTF(arg0_66._tf, "collider")
			arg0_66.throwPos = findTF(arg0_66._tf, "throwPos")

			arg0_66.enemyDft:SetEndEvent(function()
				if arg0_66.leaveCallback then
					arg0_66.leaveCallback()
				end

				arg0_66:dispose()
			end)
			arg0_66.enemyDft:SetTriggerEvent(function()
				if arg0_66._throwCallback then
					arg0_66._throwCallback(arg0_66.throwPos.position, arg0_66._index)
				end
			end)

			arg0_66._leaveTime = math.random(arg0_66._data.time[1], arg0_66._data.time[2])
			arg0_66._activeTime = 0
		end
	}

	function var0_65.setThrowCallback(arg0_69, arg1_69)
		var0_65._throwCallback = arg1_69
	end

	function var0_65.getColliderBound(arg0_70)
		return arg0_70.collider.position, arg0_70.collider.sizeDelta
	end

	function var0_65.step(arg0_71)
		if arg0_71.removeFlag then
			return
		end

		arg0_71._leaveTime = arg0_71._leaveTime - Time.deltaTime
		arg0_71._activeTime = arg0_71._activeTime + Time.deltaTime

		if arg0_71._activeTime > var21_0 then
			arg0_71._activeTime = 0

			if arg0_71:getSnowball() then
				arg0_71:throw()
				arg0_71.enemyAnimator:SetBool("snowball", false)
			else
				arg0_71.enemyAnimator:SetBool("snowball", true)
				arg0_71:reload()
			end
		end
	end

	function var0_65.apear(arg0_72)
		arg0_72.enemyAnimator:SetTrigger("apear")
	end

	function var0_65.damage(arg0_73)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var25_0)
		arg0_73.enemyAnimator:SetTrigger("damage")
	end

	function var0_65.leave(arg0_74)
		arg0_74.enemyAnimator:SetTrigger("leave")
	end

	function var0_65.reload(arg0_75)
		arg0_75.enemyAnimator:SetTrigger("reload")
	end

	function var0_65.throw(arg0_76)
		arg0_76.enemyAnimator:SetTrigger("throw")
	end

	function var0_65.hit(arg0_77)
		arg0_77.enemyAnimator:SetTrigger("hit")
	end

	function var0_65.getSnowball(arg0_78)
		return arg0_78.enemyAnimator:GetBool("snowball")
	end

	function var0_65.getLeaveTime(arg0_79)
		return arg0_79._leaveTime
	end

	function var0_65.getType(arg0_80)
		return arg0_80._data.type
	end

	function var0_65.getScore(arg0_81)
		return arg0_81._score
	end

	function var0_65.setSpeed(arg0_82, arg1_82)
		arg0_82.enemyAnimator.speed = arg1_82
	end

	function var0_65.getName(arg0_83)
		return arg0_83._name
	end

	function var0_65.getPosition(arg0_84)
		return arg0_84._tf.position
	end

	function var0_65.dispose(arg0_85)
		arg0_85.leaveCallback = nil

		if arg0_85._tf then
			Destroy(arg0_85._tf)

			arg0_85._tf = nil
		end

		arg0_85.removeFlag = true
	end

	var0_65:Ctor()

	return var0_65
end

local function var32_0(arg0_86, arg1_86)
	local var0_86 = {
		_tplCharactorDic = arg1_86,
		_charactorContainer = arg0_86,
		charators = {}
	}

	var0_86.apearStepTime = nil
	var0_86.gameStepTime = 0

	function var0_86.Ctor(arg0_87)
		for iter0_87 = 1, var7_0 do
			arg0_87.charators[iter0_87] = 0
		end

		arg0_87.throwCallback = nil
		arg0_87.charactorDamageCallback = nil
	end

	function var0_86.prepare(arg0_88)
		for iter0_88, iter1_88 in pairs(arg0_88.charators) do
			if iter1_88 ~= 0 then
				iter1_88:dispose()

				arg0_88.charators[iter0_88] = 0
			end
		end

		arg0_88.gameStepTime = 0
		arg0_88.apearStepTime = nil
	end

	function var0_86.step(arg0_89)
		arg0_89.gameStepTime = arg0_89.gameStepTime + Time.deltaTime

		if arg0_89.gameStepTime > arg0_89:getNextApearTime() then
			local var0_89 = arg0_89:getApearAmount()

			for iter0_89 = 1, var0_89 do
				arg0_89:apearCharactor()
			end

			arg0_89:setNextApearTime()
		end

		for iter1_89 = 1, #arg0_89.charators do
			if arg0_89.charators[iter1_89] ~= 0 then
				local var1_89 = arg0_89.charators[iter1_89]:getLeaveTime()

				if arg0_89.charators[iter1_89]:getLeaveTime() < 0 then
					arg0_89:leaveCharactor(iter1_89)
				else
					arg0_89.charators[iter1_89]:step()
				end
			end
		end
	end

	function var0_86.leaveCharactor(arg0_90, arg1_90)
		if arg0_90.charators[arg1_90] ~= 0 then
			arg0_90.charators[arg1_90]:leave()

			arg0_90.charators[arg1_90] = 0
		end
	end

	function var0_86.removeCharactor(arg0_91, arg1_91)
		if arg0_91.charators[arg1_91] ~= 0 then
			arg0_91.charators[arg1_91] = 0
		end
	end

	function var0_86.damageEnemy(arg0_92)
		for iter0_92 = 1, #arg0_92.charators do
			if arg0_92.charators[iter0_92] and arg0_92.charators[iter0_92] ~= 0 and arg0_92.charators[iter0_92]:getScore() > 0 then
				if arg0_92.charactorDamageCallback then
					arg0_92.charactorDamageCallback(arg0_92.charators[iter0_92]:getPosition(), arg0_92.charators[iter0_92]:getScore())
				end

				arg0_92.charators[iter0_92]:damage()
				arg0_92:removeCharactor(iter0_92)
			end
		end
	end

	function var0_86.getCharactorByIndex(arg0_93, arg1_93)
		return arg0_93.charators[arg1_93]
	end

	function var0_86.apearCharactor(arg0_94)
		local var0_94 = arg0_94:getAbleRandomDatas()

		if not var0_94 then
			return
		end

		local var1_94 = arg0_94:getDataByWeight(var0_94)

		if not var1_94 then
			return
		end

		local var2_94, var3_94 = arg0_94:getCharactorName(var10_0[var1_94.type])
		local var4_94 = arg0_94:getCharactorRandomIndex(var1_94)
		local var5_94 = arg0_94:createCharactor(var1_94, var4_94, var2_94, var3_94)

		if var5_94 then
			arg0_94:addCharactor(var5_94, var4_94)
		end
	end

	function var0_86.setSpeed(arg0_95, arg1_95)
		arg0_95.speedValue = arg1_95

		for iter0_95 = 1, #arg0_95.charators do
			if arg0_95.charators[iter0_95] and arg0_95.charators[iter0_95] ~= 0 then
				arg0_95.charators[iter0_95]:setSpeed(arg1_95)
			end
		end
	end

	function var0_86.createCharactor(arg0_96, arg1_96, arg2_96, arg3_96, arg4_96)
		local var0_96 = tf(Instantiate(arg0_96._tplCharactorDic[arg3_96]))
		local var1_96 = findTF(arg0_96._charactorContainer, arg2_96)

		SetParent(var0_96, var1_96)
		setActive(var0_96, true)

		local var2_96

		if arg1_96.type == var8_0 then
			var2_96 = var30_0(arg1_96, var0_96, arg2_96, arg3_96, arg4_96)
		elseif arg1_96.type == var9_0 then
			var2_96 = var31_0(arg1_96, var0_96, arg2_96, arg3_96, arg4_96)

			var2_96:setThrowCallback(arg0_96.throwCallback)
		end

		return var2_96
	end

	function var0_86.addCharactor(arg0_97, arg1_97, arg2_97)
		arg0_97.charators[arg2_97] = arg1_97

		arg1_97:apear()
	end

	function var0_86.getCharactorRandomIndex(arg0_98, arg1_98)
		local var0_98 = arg0_98:getEmptyIndex()
		local var1_98 = {}

		for iter0_98 = 1, #var0_98 do
			if table.contains(arg1_98.indexs, var0_98[iter0_98]) then
				table.insert(var1_98, var0_98[iter0_98])
			end
		end

		if #var1_98 then
			return var1_98[math.random(1, #var1_98)]
		end

		return nil
	end

	function var0_86.getCharactorName(arg0_99, arg1_99)
		local var0_99 = arg1_99.skin_names
		local var1_99 = math.random(1, #arg1_99.skin_names)

		return arg1_99.skin_names[var1_99], arg1_99.score[var1_99]
	end

	function var0_86.getDataByWeight(arg0_100, arg1_100)
		if #arg1_100 == 1 then
			return arg1_100[1]
		else
			if not arg0_100.charactorWeight then
				arg0_100.charactorWeight = {}
				arg0_100.charactorSubWeight = 0

				for iter0_100 = 1, #arg1_100 do
					arg0_100.charactorSubWeight = arg0_100.charactorSubWeight + arg1_100[iter0_100].weight

					table.insert(arg0_100.charactorWeight, arg0_100.charactorSubWeight)
				end
			end

			local var0_100 = math.random(0, arg0_100.charactorSubWeight)

			for iter1_100 = #arg0_100.charactorWeight - 1, 1, -1 do
				if var0_100 > arg0_100.charactorWeight[iter1_100] then
					return arg1_100[iter1_100 + 1]
				end
			end

			return arg1_100[1]
		end

		return nil
	end

	function var0_86.getAbleRandomDatas(arg0_101)
		local var0_101 = {}
		local var1_101 = arg0_101:getEmptyIndex()

		if #var1_101 == 0 then
			return var0_101
		end

		for iter0_101 = 1, #var22_0 do
			local var2_101 = var22_0[iter0_101].indexs
			local var3_101

			for iter1_101, iter2_101 in ipairs(var2_101) do
				if table.contains(var1_101, iter2_101) and not var3_101 then
					table.insert(var0_101, var22_0[iter0_101])

					var3_101 = true
				end
			end
		end

		return var0_101
	end

	function var0_86.getEmptyIndex(arg0_102)
		local var0_102 = {}

		for iter0_102, iter1_102 in pairs(arg0_102.charators) do
			if iter1_102 == 0 then
				table.insert(var0_102, iter0_102)
			end
		end

		return var0_102
	end

	function var0_86.getNextApearTime(arg0_103)
		if not arg0_103.apearStepTime then
			arg0_103:setNextApearTime()
		end

		return arg0_103.apearStepTime
	end

	function var0_86.setNextApearTime(arg0_104)
		if not arg0_104.apearStepTime then
			arg0_104.apearStepTime = 0
		end

		arg0_104.apearStepTime = arg0_104.apearStepTime + arg0_104:getApearTime()
	end

	function var0_86.getApearTime(arg0_105)
		local var0_105 = 1

		for iter0_105 = #var20_0, 1, -1 do
			if arg0_105.gameStepTime > var20_0[iter0_105] then
				var0_105 = iter0_105

				break
			end
		end

		local var1_105 = var18_0[var0_105][2] - var18_0[var0_105][1]
		local var2_105 = var18_0[var0_105][1]

		return math.random() * var1_105 + var2_105
	end

	function var0_86.getApearAmount(arg0_106)
		local var0_106 = 1

		for iter0_106 = #var20_0, 1, -1 do
			if arg0_106.gameStepTime > var20_0[iter0_106] then
				var0_106 = iter0_106

				break
			end
		end

		local var1_106 = var19_0[var0_106]
		local var2_106 = 0
		local var3_106 = {}

		for iter1_106 = 1, #var1_106 do
			var2_106 = var2_106 + var1_106[iter1_106]

			table.insert(var3_106, var2_106)
		end

		local var4_106 = math.random(0, var2_106)

		for iter2_106 = #var3_106 - 1, 1, -1 do
			if var4_106 > var3_106[iter2_106] then
				return iter2_106 + 1
			end
		end

		return 1
	end

	var0_86:Ctor()

	return var0_86
end

local function var33_0(arg0_107, arg1_107, arg2_107, arg3_107)
	local var0_107 = {
		_player = arg1_107,
		_charactorCtrl = arg3_107,
		_snowballCtrl = arg2_107,
		_sceneTf = arg0_107
	}

	var0_107.hitEnemyCallback = nil

	function var0_107.Ctor(arg0_108)
		return
	end

	function var0_107.prepare(arg0_109)
		return
	end

	function var0_107.step(arg0_110)
		local var0_110 = arg0_110._snowballCtrl:getSnowballs()

		for iter0_110 = 1, #var0_110 do
			local var1_110 = var0_110[iter0_110]:getType()
			local var2_110 = var0_110[iter0_110]:getIndex()
			local var3_110 = arg3_107:getCharactorByIndex(var2_110)

			if var1_110 == var2_0 then
				if var3_110 and var3_110 ~= 0 then
					local var4_110, var5_110 = var3_110:getColliderBound()
					local var6_110 = arg0_110._sceneTf:InverseTransformPoint(var4_110)

					if var0_110[iter0_110]:checkArrived(var6_110, var5_110) then
						var3_110:damage()
						arg0_110._snowballCtrl:snowballHit(var0_110[iter0_110]:getId())
						arg3_107:removeCharactor(var2_110)

						if arg0_110.hitEnemyCallback then
							arg0_110.hitEnemyCallback(var3_110:getType(), var3_110:getName(), var3_110:getScore(), var3_110:getPosition())
						end
					end
				end
			elseif var1_110 == var3_0 then
				local var7_110, var8_110 = arg0_110._player:getColliderBound()
				local var9_110 = arg0_110._sceneTf:InverseTransformPoint(var7_110)

				if var0_110[iter0_110]:checkArrived(var9_110, var8_110) then
					if var3_110 and var3_110 ~= 0 and var3_110:getType() == var9_0 then
						var3_110:hit()
					end

					arg0_110._player:damage()
					arg0_110._snowballCtrl:snowballHit(var0_110[iter0_110]:getId())
				end
			end
		end
	end

	var0_107:Ctor()

	return var0_107
end

function var0_0.getUIName(arg0_111)
	return "SnowballGameUI"
end

function var0_0.getBGM(arg0_112)
	return "backyard"
end

function var0_0.didEnter(arg0_113)
	arg0_113:initData()
	arg0_113:initUI()
end

function var0_0.initData(arg0_114)
	arg0_114.timer = Timer.New(function()
		arg0_114:onTimer()
	end, 0.0166666666666667, -1)
end

function var0_0.initUI(arg0_116)
	arg0_116.sceneTf = findTF(arg0_116._tf, "scene")
	arg0_116.clickMask = findTF(arg0_116._tf, "clickMask")
	arg0_116.player = var27_0(findTF(arg0_116._tf, "scene/luao"))

	function arg0_116.player.throwCallback(arg0_117)
		arg0_116:onPlayerThrowSnowball(arg0_117)
	end

	function arg0_116.player.damageCallback()
		arg0_116:onPlayerDamage()
	end

	function arg0_116.player.gameOverCallback()
		arg0_116:onGameOver()
	end

	arg0_116.snowballContainer = findTF(arg0_116._tf, "scene_front/snowballContainer")
	arg0_116.tplSnowball = findTF(arg0_116._tf, "tplSnowball")
	arg0_116.snowballController = var29_0(arg0_116.snowballContainer, arg0_116.tplSnowball)
	arg0_116.tplScore = findTF(arg0_116._tf, "tplScore")
	arg0_116.specialTf = findTF(arg0_116._tf, "scene_front/special")
	arg0_116.specialAniamtor = GetComponent(arg0_116.specialTf, typeof(Animator))

	GetComponent(arg0_116.specialTf, typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0_116:specialComplete()
	end)

	arg0_116.charactorContainer = findTF(arg0_116._tf, "scene/charactorContainer")

	local var0_116 = {}

	for iter0_116, iter1_116 in pairs(var10_0) do
		local var1_116 = iter1_116.skin_names

		for iter2_116, iter3_116 in ipairs(var1_116) do
			var0_116[iter3_116] = findTF(arg0_116._tf, "charactor/" .. iter3_116)
		end
	end

	arg0_116.charactorController = var32_0(arg0_116.charactorContainer, var0_116)

	function arg0_116.charactorController.throwCallback(arg0_121, arg1_121)
		function arg0_116.charactorController.charactorDamageCallback(arg0_122, arg1_122)
			arg0_116:onHitEnemy(arg1_122, arg0_122)
		end

		local var0_121 = var17_0[arg0_116:getCurrentDiff()]

		arg0_116:onEnemyThrowSnowball(arg0_121, arg1_121, var0_121)
	end

	arg0_116.colliderController = var33_0(arg0_116.sceneTf, arg0_116.player, arg0_116.snowballController, arg0_116.charactorController)

	function arg0_116.colliderController.hitEnemyCallback(arg0_123, arg1_123, arg2_123, arg3_123)
		arg0_116:onHitEnemy(arg2_123, arg3_123)
	end

	local var2_116 = findTF(arg0_116._tf, "scene/moveCollider")

	arg0_116.playerMoveVecs = {}

	for iter4_116 = 1, var6_0 do
		local var3_116 = findTF(var2_116, iter4_116)

		table.insert(arg0_116.playerMoveVecs, var3_116.anchoredPosition)
	end

	arg0_116.lockTf = findTF(arg0_116._tf, "scene_front/lock")

	local var4_116 = findTF(arg0_116._tf, "scene/throwCollider")

	for iter5_116 = 1, var7_0 do
		local var5_116 = findTF(var4_116, iter5_116)
		local var6_116 = iter5_116

		onButton(arg0_116, var5_116, function()
			local var0_124 = arg0_116.charactorController:getCharactorByIndex(var6_116)

			if var0_124 and var0_124 ~= 0 then
				local var1_124 = findTF(var5_116, "target").position
				local var2_124 = arg0_116.sceneTf:InverseTransformPoint(var1_124.x, var1_124.y, 0)

				arg0_116:throwSnowballTo(var2_124, var6_116, var0_124)
			end
		end)
	end

	arg0_116.countUI = findTF(arg0_116._tf, "pop/CountUI")
	arg0_116.countAnimator = GetComponent(findTF(arg0_116.countUI, "count"), typeof(Animator))
	arg0_116.countDft = GetComponent(findTF(arg0_116.countUI, "count"), typeof(DftAniEvent))

	arg0_116.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_116.countDft:SetEndEvent(function()
		setActive(arg0_116.countUI, false)
		arg0_116:gameStart()
	end)

	arg0_116.leaveUI = findTF(arg0_116._tf, "pop/LeaveUI")

	onButton(arg0_116, findTF(arg0_116.leaveUI, "ad/btnOk"), function()
		arg0_116:resumeGame()
		arg0_116.player:settlement(var4_0)
		arg0_116:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_116, findTF(arg0_116.leaveUI, "ad/btnCancel"), function()
		arg0_116:resumeGame()
	end, SFX_CANCEL)

	arg0_116.pauseUI = findTF(arg0_116._tf, "pop/pauseUI")

	onButton(arg0_116, findTF(arg0_116.pauseUI, "ad/btnOk"), function()
		setActive(arg0_116.pauseUI, false)
		arg0_116:resumeGame()
	end, SFX_CANCEL)

	arg0_116.settlementUI = findTF(arg0_116._tf, "pop/SettleMentUI")

	onButton(arg0_116, findTF(arg0_116.settlementUI, "ad/btnOver"), function()
		setActive(arg0_116.settlementUI, false)
		arg0_116:openMenuUI()
	end, SFX_CANCEL)

	arg0_116.menuUI = findTF(arg0_116._tf, "pop/menuUI")
	arg0_116.battleScrollRect = GetComponent(findTF(arg0_116.menuUI, "battList"), typeof(ScrollRect))
	arg0_116.totalTimes = arg0_116:getGameTotalTime()

	local var7_116 = arg0_116:getGameUsedTimes() - 4 < 0 and 0 or arg0_116:getGameUsedTimes() - 4

	scrollTo(arg0_116.battleScrollRect, 0, 1 - var7_116 / (arg0_116.totalTimes - 4))
	onButton(arg0_116, findTF(arg0_116.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_131 = arg0_116.battleScrollRect.normalizedPosition.y + 1 / (arg0_116.totalTimes - 4)

		if var0_131 > 1 then
			var0_131 = 1
		end

		scrollTo(arg0_116.battleScrollRect, 0, var0_131)
	end, SFX_CANCEL)
	onButton(arg0_116, findTF(arg0_116.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_132 = arg0_116.battleScrollRect.normalizedPosition.y - 1 / (arg0_116.totalTimes - 4)

		if var0_132 < 0 then
			var0_132 = 0
		end

		scrollTo(arg0_116.battleScrollRect, 0, var0_132)
	end, SFX_CANCEL)
	onButton(arg0_116, findTF(arg0_116.menuUI, "btnBack"), function()
		arg0_116:closeView()
	end, SFX_CANCEL)
	onButton(arg0_116, findTF(arg0_116.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.snowball_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_116, findTF(arg0_116.menuUI, "btnStart"), function()
		setActive(arg0_116.menuUI, false)
		arg0_116:readyStart()
	end, SFX_CANCEL)

	local var8_116 = findTF(arg0_116.menuUI, "tplBattleItem")

	arg0_116.battleItems = {}

	for iter6_116 = 1, arg0_116.totalTimes do
		local var9_116 = tf(instantiate(var8_116))

		var9_116.name = "battleItem_" .. iter6_116

		setParent(var9_116, findTF(arg0_116.menuUI, "battList/Viewport/Content"))

		local var10_116 = iter6_116

		GetSpriteFromAtlasAsync("ui/minigameui/snowballgameui_atlas", "tx_" .. var10_116, function(arg0_136)
			setImageSprite(findTF(var9_116, "state_open/icon"), arg0_136, true)
			setImageSprite(findTF(var9_116, "state_clear/icon"), arg0_136, true)
			setImageSprite(findTF(var9_116, "state_current/icon"), arg0_136, true)
		end)
		GetSpriteFromAtlasAsync("ui/minigameui/snowballgameui_atlas", "battleDesc" .. var10_116, function(arg0_137)
			setImageSprite(findTF(var9_116, "state_open/buttomDesc"), arg0_137, true)
			setImageSprite(findTF(var9_116, "state_clear/buttomDesc"), arg0_137, true)
			setImageSprite(findTF(var9_116, "state_current/buttomDesc"), arg0_137, true)
			setImageSprite(findTF(var9_116, "state_closed/buttomDesc"), arg0_137, true)
		end)
		setActive(var9_116, true)
		table.insert(arg0_116.battleItems, var9_116)
	end

	arg0_116.gameUI = findTF(arg0_116._tf, "ui/gameUI")
	arg0_116.lifeProgress = findTF(arg0_116.gameUI, "lifeProgress")
	arg0_116.textLife = findTF(arg0_116.gameUI, "life")
	arg0_116.textScore = findTF(arg0_116.gameUI, "score")

	onButton(arg0_116, findTF(arg0_116.gameUI, "btnStop"), function()
		arg0_116:stopGame()
		setActive(arg0_116.pauseUI, true)
	end)
	onButton(arg0_116, findTF(arg0_116.gameUI, "btnLeave"), function()
		arg0_116:stopGame()
		setActive(arg0_116.leaveUI, true)
	end)
	onButton(arg0_116, findTF(arg0_116.gameUI, "btnMoveUp"), function()
		if arg0_116.playerPosIndex > 1 then
			arg0_116.playerPosIndex = arg0_116.playerPosIndex - 1

			arg0_116:movePlayerTo(arg0_116.playerPosIndex)
		end
	end)
	onButton(arg0_116, findTF(arg0_116.gameUI, "btnMoveDown"), function()
		if arg0_116.playerPosIndex < #arg0_116.playerMoveVecs then
			arg0_116.playerPosIndex = arg0_116.playerPosIndex + 1

			arg0_116:movePlayerTo(arg0_116.playerPosIndex)
		end
	end)

	arg0_116.btnSkill = findTF(arg0_116.gameUI, "btnSkill")

	onButton(arg0_116, arg0_116.btnSkill, function()
		if arg0_116.skilTime == var14_0 then
			arg0_116.skilTime = 0

			arg0_116:usePlayerSkill()
		end
	end)
	arg0_116:updateMenuUI()
	arg0_116:openMenuUI()

	if not arg0_116.handle then
		arg0_116.handle = UpdateBeat:CreateListener(arg0_116.Update, arg0_116)
	end

	UpdateBeat:AddListener(arg0_116.handle)
end

function var0_0.Update(arg0_143)
	arg0_143:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_144)
	if arg0_144.gameStop or arg0_144.settlementFlag then
		return
	end

	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.W) and arg0_144.playerPosIndex and arg0_144.playerPosIndex > 1 then
			arg0_144.playerPosIndex = arg0_144.playerPosIndex - 1

			arg0_144:movePlayerTo(arg0_144.playerPosIndex)
		end

		if Input.GetKeyDown(KeyCode.S) and arg0_144.playerPosIndex and arg0_144.playerPosIndex < #arg0_144.playerMoveVecs then
			arg0_144.playerPosIndex = arg0_144.playerPosIndex + 1

			arg0_144:movePlayerTo(arg0_144.playerPosIndex)
		end
	end
end

function var0_0.getCurrentDiff(arg0_145)
	for iter0_145 = #var20_0, 1, -1 do
		if arg0_145.gameStepTime > var20_0[iter0_145] then
			return iter0_145
		end
	end
end

function var0_0.updateMenuUI(arg0_146)
	local var0_146 = arg0_146:getGameUsedTimes()
	local var1_146 = arg0_146:getGameTimes()

	for iter0_146 = 1, #arg0_146.battleItems do
		setActive(findTF(arg0_146.battleItems[iter0_146], "state_open"), false)
		setActive(findTF(arg0_146.battleItems[iter0_146], "state_closed"), false)
		setActive(findTF(arg0_146.battleItems[iter0_146], "state_clear"), false)
		setActive(findTF(arg0_146.battleItems[iter0_146], "state_current"), false)

		if iter0_146 <= var0_146 then
			setActive(findTF(arg0_146.battleItems[iter0_146], "state_clear"), true)
		elseif iter0_146 == var0_146 + 1 and var1_146 >= 1 then
			setActive(findTF(arg0_146.battleItems[iter0_146], "state_current"), true)
		elseif var0_146 < iter0_146 and iter0_146 <= var0_146 + var1_146 then
			setActive(findTF(arg0_146.battleItems[iter0_146], "state_open"), true)
		else
			setActive(findTF(arg0_146.battleItems[iter0_146], "state_closed"), true)
		end
	end

	arg0_146.totalTimes = arg0_146:getGameTotalTime()

	local var2_146 = 1 - (arg0_146:getGameUsedTimes() - 3 < 0 and 0 or arg0_146:getGameUsedTimes() - 3) / (arg0_146.totalTimes - 4)

	if var2_146 > 1 then
		var2_146 = 1
	end

	scrollTo(arg0_146.battleScrollRect, 0, var2_146)
	setActive(findTF(arg0_146.menuUI, "btnStart/tip"), var1_146 > 0)
	arg0_146:CheckGet()
end

function var0_0.CheckGet(arg0_147)
	setActive(findTF(arg0_147.menuUI, "got"), false)

	if arg0_147:getUltimate() and arg0_147:getUltimate() ~= 0 then
		setActive(findTF(arg0_147.menuUI, "got"), true)
	end

	if arg0_147:getUltimate() == 0 then
		if arg0_147:getGameTotalTime() > arg0_147:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_147:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_147.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_148)
	setActive(findTF(arg0_148._tf, "scene_front"), false)
	setActive(findTF(arg0_148._tf, "scene_background"), false)
	setActive(findTF(arg0_148._tf, "scene"), false)
	setActive(arg0_148.gameUI, false)
	setActive(arg0_148.menuUI, true)
	arg0_148:updateMenuUI()
end

function var0_0.clearUI(arg0_149)
	setActive(arg0_149.sceneTf, false)
	setActive(arg0_149.settlementUI, false)
	setActive(arg0_149.countUI, false)
	setActive(arg0_149.menuUI, false)
	setActive(arg0_149.gameUI, false)
end

function var0_0.OnSendMiniGameOPDone(arg0_150, arg1_150)
	if arg0_150.sendSuccessFlag then
		local var0_150 = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.NewYearShrineGameID):GetRuntimeData("count") or 0) + 2

		pg.m02:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
			id = MiniGameDataCreator.NewYearShrineGameID,
			map = {
				count = var0_150
			}
		})

		arg0_150.sendSuccessFlag = false
	end
end

function var0_0.readyStart(arg0_151)
	setActive(arg0_151.countUI, true)
	arg0_151.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var23_0)
end

function var0_0.gameStart(arg0_152)
	setActive(findTF(arg0_152._tf, "scene_front"), true)
	setActive(findTF(arg0_152._tf, "scene_background"), true)
	setActive(findTF(arg0_152._tf, "scene"), true)
	setActive(arg0_152.gameUI, true)
	setActive(arg0_152.lockTf, false)

	arg0_152.gameStartFlag = true
	arg0_152.scoreNum = 0
	arg0_152.skilTime = 0
	arg0_152.playerPosIndex = 2

	arg0_152:movePlayerTo(arg0_152.playerPosIndex)

	arg0_152.specialTime = 0
	arg0_152.gameStepTime = 0

	arg0_152.player:prepare()
	arg0_152.snowballController:prepare()
	arg0_152.charactorController:prepare()
	arg0_152.colliderController:prepare()
	arg0_152:updateGameUI()
	arg0_152:timerStart()
end

function var0_0.onPlayerDamage(arg0_153)
	arg0_153:updateGameUI()
end

function var0_0.getGameTimes(arg0_154)
	return arg0_154:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_155)
	return arg0_155:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_156)
	return arg0_156:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_157)
	return (arg0_157:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_158, arg1_158)
	arg0_158.player:setSpeed(arg1_158)

	arg0_158.specialAniamtor.speed = arg1_158

	arg0_158.charactorController:setSpeed(arg1_158)
end

function var0_0.onTimer(arg0_159)
	arg0_159.player:step()
	arg0_159.snowballController:step()
	arg0_159.charactorController:step()
	arg0_159.colliderController:step()
	arg0_159:gameStep()
end

function var0_0.gameStep(arg0_160)
	arg0_160.gameStepTime = arg0_160.gameStepTime + Time.deltaTime
	arg0_160.skilTime = arg0_160.skilTime + Time.deltaTime

	if arg0_160.skilTime > var14_0 then
		arg0_160.skilTime = var14_0
	end

	if not arg0_160.skillProgress then
		arg0_160.skillProgress = GetComponent(findTF(arg0_160.btnSkill, "progress"), typeof(Image))
	end

	arg0_160.skillProgress.fillAmount = arg0_160.skilTime / var14_0

	if arg0_160.skilTime == var14_0 then
		if not isActive(findTF(arg0_160.gameUI, "xuehezhan_zhiyuantiao")) then
			setActive(findTF(arg0_160.gameUI, "xuehezhan_zhiyuantiao"), true)
		end
	elseif isActive(findTF(arg0_160.gameUI, "xuehezhan_zhiyuantiao")) then
		setActive(findTF(arg0_160.gameUI, "xuehezhan_zhiyuantiao"), false)
	end

	if arg0_160.gameStepTime < arg0_160.specialTime then
		if not arg0_160.specialIndex then
			arg0_160.specialIndex = 0
		end

		if arg0_160.specialIndex > 20 then
			arg0_160.specialIndex = 0

			arg0_160.charactorController:damageEnemy()
		end

		arg0_160.specialIndex = arg0_160.specialIndex + 1
	end
end

function var0_0.timerStart(arg0_161)
	if not arg0_161.timer.running then
		arg0_161.timer:Start()
	end
end

function var0_0.timerStop(arg0_162)
	if arg0_162.timer.running then
		arg0_162.timer:Stop()
	end
end

function var0_0.movePlayerTo(arg0_163, arg1_163)
	arg0_163.player:move(arg0_163.playerMoveVecs[arg1_163])
end

function var0_0.updateGameUI(arg0_164)
	setSlider(arg0_164.lifeProgress, 0, 1, arg0_164.player:getLife() / var11_0)
	setText(arg0_164.textLife, arg0_164.player:getLife() .. "/" .. var11_0)
	setText(arg0_164.textScore, arg0_164.scoreNum)
end

function var0_0.throwSnowballTo(arg0_165, arg1_165, arg2_165, arg3_165)
	arg0_165.throwTarget = arg1_165
	arg0_165.targetIndex = arg2_165

	if arg0_165.player:throw() and arg0_165.targetCharactor ~= arg3_165 then
		setActive(arg0_165.lockTf, false)

		arg0_165.lockTf.anchoredPosition = arg1_165

		setActive(arg0_165.lockTf, true)

		arg0_165.targetCharactor = arg3_165
	end
end

function var0_0.onPlayerThrowSnowball(arg0_166, arg1_166)
	if arg0_166.throwTarget then
		local var0_166 = arg0_166.sceneTf:InverseTransformPoint(arg1_166.x, arg1_166.y, 0)
		local var1_166 = arg0_166.throwTarget

		arg0_166.snowballController:createSnowball(var0_166, var1_166, var13_0, var2_0, arg0_166.targetIndex)

		arg0_166.throwTarget = nil
		arg0_166.targetIndex = nil
	end
end

function var0_0.onEnemyThrowSnowball(arg0_167, arg1_167, arg2_167, arg3_167)
	local var0_167 = arg0_167.sceneTf:InverseTransformPoint(arg1_167.x, arg1_167.y, 0)
	local var1_167 = arg0_167.player:getTargetPosition()
	local var2_167 = arg0_167.sceneTf:InverseTransformPoint(var1_167.x, var1_167.y, 0)

	arg0_167.snowballController:createSnowball(var0_167, var2_167, arg3_167, var3_0, arg2_167)
end

function var0_0.usePlayerSkill(arg0_168)
	Time.timeScale = 0.05

	LeanTween.delayedCall(go(arg0_168.specialTf), 3, System.Action(function()
		if Time.timeScale ~= 1 then
			Time.timeScale = 1
		end
	end))
	arg0_168.player:skill()
	arg0_168.snowballController:clearEnemySnowball()
	setActive(arg0_168.specialTf, true)

	if not arg0_168.specialEffect then
		arg0_168.specialEffect = findTF(arg0_168._tf, "xuehezhan_xueqiuhongzha")
	end

	setActive(arg0_168.specialEffect, false)
	setActive(arg0_168.specialEffect, true)
end

function var0_0.specialComplete(arg0_170)
	Time.timeScale = 1

	setActive(arg0_170.specialTf, false)

	arg0_170.specialTime = arg0_170.gameStepTime + var15_0
	arg0_170.specialIndex = 0
end

function var0_0.dropSpeedUp(arg0_171)
	return
end

function var0_0.onHitEnemy(arg0_172, arg1_172, arg2_172)
	arg0_172:addScore(arg1_172, arg2_172)
	arg0_172:updateGameUI()
end

function var0_0.addScore(arg0_173, arg1_173, arg2_173)
	arg0_173.scoreNum = arg0_173.scoreNum + arg1_173

	if arg0_173.scoreNum < 0 then
		arg0_173.scoreNum = 0
	end

	local var0_173 = tf(instantiate(arg0_173.tplScore))
	local var1_173 = findTF(var0_173, "ad")
	local var2_173 = GetComponent(var1_173, typeof(DftAniEvent))

	var0_173.anchoredPosition = arg0_173.snowballContainer:InverseTransformPoint(arg2_173)

	if arg1_173 > 0 then
		setActive(findTF(var1_173, "add"), true)
		setText(findTF(var1_173, "add"), "+" .. arg1_173)
	else
		setActive(findTF(var1_173, "sub"), true)
		setText(findTF(var1_173, "sub"), arg1_173)
	end

	setParent(var0_173, arg0_173.snowballContainer)
	var2_173:SetEndEvent(function()
		setActive(var0_173, false)
		Destroy(var0_173)
	end)
	setActive(var0_173, true)
end

function var0_0.onGameOver(arg0_175)
	arg0_175:timerStop()

	arg0_175.settlementFlag = true

	setActive(arg0_175.clickMask, true)
	LeanTween.delayedCall(go(arg0_175._tf), 2, System.Action(function()
		arg0_175.settlementFlag = false
		arg0_175.gameStartFlag = false

		setActive(arg0_175.clickMask, false)
		setActive(findTF(arg0_175.gameUI, "xuehezhan_zhiyuantiao"), false)
		setActive(arg0_175.specialTf, false)
		arg0_175:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_177)
	setActive(arg0_177.settlementUI, true)
	GetComponent(findTF(arg0_177.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_177 = arg0_177:GetMGData():GetRuntimeData("elements")
	local var1_177 = arg0_177.scoreNum
	local var2_177 = var0_177 and #var0_177 > 0 and var0_177[1] or 0

	if var2_177 <= var1_177 then
		var2_177 = var1_177

		arg0_177:StoreDataToServer({
			var2_177
		})
	end

	local var3_177 = findTF(arg0_177.settlementUI, "ad/highText")
	local var4_177 = findTF(arg0_177.settlementUI, "ad/currentText")

	setText(var3_177, var2_177)
	setText(var4_177, var1_177)

	if arg0_177:getGameTimes() and arg0_177:getGameTimes() > 0 then
		arg0_177.sendSuccessFlag = true

		arg0_177:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_178)
	arg0_178.gameStop = false

	setActive(arg0_178.leaveUI, false)
	arg0_178:changeSpeed(1)
	arg0_178:timerStart()
end

function var0_0.stopGame(arg0_179)
	arg0_179.gameStop = true

	arg0_179:timerStop()
	arg0_179:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_180)
	if not arg0_180.gameStartFlag then
		arg0_180:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_180.settlementFlag then
			return
		end

		if isActive(arg0_180.pauseUI) then
			setActive(arg0_180.pauseUI, false)
		end

		arg0_180:stopGame()
		setActive(arg0_180.leaveUI, true)
	end
end

function var0_0.willExit(arg0_181)
	if arg0_181.handle then
		UpdateBeat:RemoveListener(arg0_181.handle)
	end

	if not arg0_181._tf then
		print()
	end

	if arg0_181._tf and LeanTween.isTweening(go(arg0_181._tf)) then
		LeanTween.cancel(go(arg0_181._tf))
	end

	if arg0_181.specialTf and LeanTween.isTweening(go(arg0_181.specialTf)) then
		LeanTween.cancel(go(arg0_181.specialTf))
	end

	if arg0_181.specialEffect and LeanTween.isTweening(go(arg0_181.specialEffect)) then
		LeanTween.cancel(go(arg0_181.specialEffect))
	end

	if arg0_181.timer and arg0_181.timer.running then
		arg0_181.timer:Stop()
	end

	Time.timeScale = 1
	arg0_181.timer = nil
end

return var0_0
