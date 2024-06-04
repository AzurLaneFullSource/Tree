local var0 = class("PokeMoleView", import("..BaseMiniGameView"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = {
	1000,
	230
}
local var5 = {
	300,
	100
}
local var6 = "backyard"
local var7 = "event:/ui/jida"
local var8 = "event:/ui/quanji"
local var9 = "event:/ui/baozhaxiaoshi"
local var10 = ""
local var11 = ""
local var12 = "event:/ui/ddldaoshu2"
local var13 = 0.5
local var14 = 90
local var15 = {
	{
		speed = 60,
		type = 1,
		enable_time = 1,
		life = 1,
		score = 100,
		damage_time = 1
	},
	{
		speed = 65,
		type = 2,
		enable_time = 1,
		life = 1,
		score = 150,
		damage_time = 1
	},
	{
		speed = 50,
		type = 3,
		enable_time = 2,
		life = 2,
		score = 200,
		damage_time = 1
	},
	{
		speed = 55,
		type = 4,
		enable_time = 1,
		life = 1,
		score = 150,
		damage_time = 1
	}
}
local var16 = {
	level_up_time = {
		0,
		20,
		40,
		60,
		80
	},
	enemy_apear_time = {
		2.5,
		2,
		1.5,
		1.5,
		1
	},
	enemy_max = {
		5,
		6,
		7,
		8,
		8
	},
	enemy_amounts = {
		{
			70,
			30
		},
		{
			70,
			30
		},
		{
			70,
			40
		},
		{
			70,
			40,
			20
		},
		{
			70,
			50,
			20
		}
	}
}
local var17 = 3
local var18 = {
	1,
	2,
	3
}
local var19 = 10
local var20 = 10

local function var21(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._tf = arg0
			arg0._callback = arg1
			arg0._animator = GetComponent(arg0._tf, typeof(Animator))
			arg0._attakeCount = 0
			arg0._attakeCd = 0
			arg0._specialTime = 0
			arg0._specialCount = 0
			arg0.atkCollider = GetComponent(findTF(arg0._tf, "atkCollider"), typeof(BoxCollider2D))
			arg0.specialCollider = GetComponent(findTF(arg0._tf, "specialCollider"), typeof(BoxCollider2D))

			local var0 = GetComponent(arg0._tf, typeof(DftAniEvent))

			var0:SetStartEvent(function()
				return
			end)
			var0:SetTriggerEvent(function()
				if arg0._callback then
					local var0 = arg0:getColliderData()

					arg0._callback(var0)

					if arg0:getSpecialState() then
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(var8)
					end
				end
			end)
			var0:SetEndEvent(function()
				return
			end)
		end,
		getColliderData = function(arg0)
			local var0

			if arg0:getSpecialState() then
				var0 = arg0.specialCollider
			else
				var0 = arg0.atkCollider
			end

			local var1 = var0.bounds.max.x - var0.bounds.min.x
			local var2 = var0.bounds.max.y - var0.bounds.min.y

			return {
				pos = var0.bounds.min,
				boundsLength = {
					width = var1,
					height = var2
				},
				damage = arg0:getDamage()
			}
		end,
		atk = function(arg0)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var7)
			arg0._animator:SetTrigger("atk")

			arg0._attakeCd = var13
		end,
		specialAtk = function(arg0)
			arg0._animator:SetTrigger("special")

			arg0._attakeCd = var13
		end,
		getDamage = function(arg0)
			if arg0._specialTime > 0 then
				return 3
			end

			return 1
		end,
		reset = function(arg0)
			arg0._animator:SetTrigger("reset")
		end,
		setActive = function(arg0, arg1)
			SetActive(arg0._tf, arg1)
		end,
		setParent = function(arg0, arg1, arg2)
			SetParent(arg0._tf, arg1)
			arg0:setActive(arg2)
		end,
		attakeAble = function(arg0)
			return arg0._attakeCd == 0
		end,
		moveTo = function(arg0, arg1)
			arg1.y = arg1.y + 100
			arg0._tf.anchoredPosition = arg1
		end,
		attakeCount = function(arg0, arg1)
			arg0._attakeCount = arg0._attakeCount + arg1 * 4

			if arg0._attakeCount > 8 then
				arg0._attakeCount = 8
			end

			if arg0._attakeCount > 0 then
				arg0._animator.speed = 0
			end
		end,
		addSpecialCount = function(arg0, arg1)
			if arg0._specialTime == 0 then
				arg0._specialCount = arg0._specialCount + arg1

				if arg0._specialCount >= var20 then
					arg0._specialCount = var20
				end
			end
		end,
		useSpecial = function(arg0)
			if arg0._specialTime and arg0._specialCount >= var20 then
				arg0._specialCount = 0
				arg0._specialTime = var19

				return true
			end

			return false
		end,
		SetSiblingIndex = function(arg0, arg1)
			arg0._tf:SetSiblingIndex(arg1)
		end,
		getSpecialState = function(arg0)
			return arg0._specialTime > 0
		end,
		step = function(arg0)
			if arg0._attakeCount > 0 then
				arg0._attakeCount = arg0._attakeCount - 1

				if arg0._attakeCount == 0 then
					arg0._animator.speed = 1
				end
			end

			if arg0._attakeCd > 0 then
				arg0._attakeCd = arg0._attakeCd - Time.deltaTime
				arg0._attakeCd = arg0._attakeCd < 0 and 0 or arg0._attakeCd
			end

			if arg0._specialTime > 0 then
				arg0._specialTime = arg0._specialTime - Time.deltaTime
				arg0._specialTime = arg0._specialTime < 0 and 0 or arg0._specialTime
			end
		end,
		inSpecial = function(arg0)
			return arg0._specialTime > 0
		end,
		getSpecialData = function(arg0)
			return arg0._specialTime, arg0._specialCount
		end,
		clear = function(arg0)
			arg0._specialTime = 0
			arg0._specialCount = 0

			arg0:reset()
		end,
		useAtk = function(arg0)
			if arg0:inSpecial() then
				arg0:specialAtk()
			else
				arg0:atk()
			end
		end
	}

	var0:ctor()

	return var0
end

local function var22(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0.playerTpl = arg0
			arg0.sceneTf = arg1
			arg0._playerPos = findTF(arg0.sceneTf, "playerPos")
			arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
			arg0.dragDelegate = GetOrAddComponent(findTF(arg0.sceneTf, "clickBounds"), "EventTriggerListener")
			arg0.dragDelegate.enabled = true

			arg0.dragDelegate:AddPointDownFunc(function(arg0, arg1)
				if arg0.player and arg0.player:attakeAble() then
					local var0 = arg0.uiCam:ScreenToWorldPoint(arg1.pressPosition)
					local var1 = arg0._playerPos:InverseTransformPoint(var0)

					arg0.player:moveTo(var1)
					arg0.player:reset()
					arg0.player:useAtk()
				end
			end)
		end,
		createPlayer = function(arg0)
			if arg0.player == nil then
				arg0.player = var21(tf(Instantiate(arg0.playerTpl)), function(arg0)
					arg0:playerActHand(arg0)
				end)

				arg0.player:setParent(arg0._playerPos, true)
			end
		end,
		playerActHand = function(arg0, arg1)
			if arg0.playerHandle then
				arg0.playerHandle(arg1)
			end
		end,
		setPlayerHandle = function(arg0, arg1)
			arg0.playerHandle = arg1
		end,
		step = function(arg0)
			if arg0.player then
				arg0.player:step()
			end
		end,
		getSpecialData = function(arg0)
			if arg0.player then
				return arg0.player:getSpecialData()
			end

			return nil, nil
		end,
		useSpecial = function(arg0)
			if arg0.player then
				return arg0.player:useSpecial()
			end
		end,
		attakeCount = function(arg0, arg1)
			if arg0.player then
				arg0.player:attakeCount(arg1)
			end
		end,
		addSpecialCount = function(arg0, arg1)
			if arg0.player then
				arg0.player:addSpecialCount(arg1)
			end
		end,
		clear = function(arg0)
			if arg0.player then
				arg0.player:clear()
			end
		end
	}

	var0:ctor()

	return var0
end

local function var23(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._tf = arg0
			arg0._data = arg1
			arg0._life = 0
			arg0._enable = false
			arg0._attakeAble = false
			arg0._animator = GetComponent(arg0._tf, typeof(Animator))
			arg0._boxCollider = GetComponent(arg0._tf, "BoxCollider2D")

			local var0 = GetComponent(arg0._tf, typeof(DftAniEvent))

			var0:SetStartEvent(function()
				if arg0._callback then
					arg0._callback(var3)
				end
			end)
			var0:SetTriggerEvent(function()
				if arg0._callback then
					arg0._callback(var2)
				end
			end)
			var0:SetEndEvent(function()
				arg0._enable = false

				if arg0._callback then
					arg0._callback(var1)
				end
			end)
		end,
		setHandle = function(arg0, arg1)
			arg0._callback = arg1
		end,
		getSpeed = function(arg0)
			return arg0._data.speed
		end,
		step = function(arg0)
			if arg0._enableTime > 0 then
				arg0._enableTime = arg0._enableTime - Time.deltaTime

				if arg0._enableTime < 0 then
					arg0._enable = true
					arg0._enableTime = 0
				end
			end
		end,
		apear = function(arg0)
			arg0._animator:SetTrigger("pop")

			arg0._enableTime = math.random() * arg0._data.enable_time + 0.5
			arg0._life = arg0._data.life
			arg0._attakeAble = true
		end,
		stop = function(arg0)
			arg0._animator:SetBool("stop", true)
		end,
		damage = function(arg0, arg1)
			arg0._life = arg0._life - arg1

			if arg0._life <= 0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var9)
				arg0:dead()
			else
				arg0._animator:SetTrigger("damage")

				arg0._enable = false
				arg0._enableTime = arg0._data.damage_time
			end
		end,
		dead = function(arg0)
			arg0._animator:SetTrigger("dead")

			arg0._enable = false
			arg0._enableTime = 0
			arg0._attakeAble = false
		end,
		steal = function(arg0)
			arg0._animator:SetTrigger("steal")

			arg0._enable = false
			arg0._attakeAble = false
		end,
		move = function(arg0, arg1, arg2)
			local var0 = arg0._tf.anchoredPosition

			var0.x = var0.x + arg1
			var0.y = var0.y + arg2
			arg0._tf.anchoredPosition = var0

			local var1 = arg0._tf.localScale

			var1.x = Mathf.Abs(arg0._tf.localScale.x) * -1 * Mathf.Sign(arg1)
			arg0._tf.localScale = var1
		end,
		moveTo = function(arg0, arg1)
			arg0._tf.anchoredPosition = arg1

			local var0 = arg0._tf.localScale

			var0.x = Mathf.Abs(arg0._tf.localScale.x) * Mathf.Sign(arg0._tf.localPosition.x)
			arg0._tf.localScale = var0
		end,
		setParent = function(arg0, arg1, arg2)
			SetParent(arg0._tf, arg1)
			arg0:setActive(arg2)
		end,
		setActive = function(arg0, arg1)
			SetActive(arg0._tf, arg1)
		end,
		SetSiblingIndex = function(arg0, arg1)
			arg0._tf:SetSiblingIndex(arg1)
		end,
		getPosition = function(arg0)
			return arg0._tf.anchoredPosition
		end,
		getType = function(arg0)
			return arg0._data.type
		end,
		getMoveAble = function(arg0)
			return isActive(arg0._tf) and arg0._enable
		end,
		getAttakeAble = function(arg0)
			return isActive(arg0._tf) and arg0._attakeAble
		end,
		getBounds = function(arg0)
			return arg0._boxCollider.bounds
		end,
		getLife = function(arg0)
			return arg0._life
		end,
		getScore = function(arg0)
			return arg0._data.score
		end,
		getBoundLength = function(arg0)
			if arg0.boundsData == nil then
				local var0 = arg0._boxCollider.bounds.max.x - arg0._boxCollider.bounds.min.x
				local var1 = arg0._boxCollider.bounds.max.y - arg0._boxCollider.bounds.min.y

				arg0.boundsData = {
					width = var0,
					height = var1
				}
			end

			return arg0.boundsData
		end
	}

	var0:ctor()

	return var0
end

local function var24(arg0, arg1, arg2, arg3)
	local var0 = {
		ctor = function(arg0)
			arg0.enemysTpl = arg0
			arg0.sceneTf = arg1
			arg0.enemyPos = findTF(arg0.sceneTf, "enemyPos")
			arg0.createPos = findTF(arg0.sceneTf, "createPos")
			arg0.countsWeight = {}

			for iter0 = 1, #var16.enemy_amounts do
				local var0 = {}
				local var1 = 0
				local var2 = var16.enemy_amounts[iter0]

				for iter1 = 1, #var2 do
					var1 = var1 + var2[iter1]

					table.insert(var0, var1)
				end

				table.insert(arg0.countsWeight, var0)
			end

			arg0.callback = arg2
			arg0.callback2 = arg3
			arg0.enemys = {}
			arg0.enemysPool = {}
			arg0.apearTime = 0
			arg0.stepTime = 0
			arg0.level = 1
			arg0.cakeLife = var17
			arg0.cakeTf = findTF(arg0.sceneTf, "enemyPos/cake")
			arg0.cakeAniamtor = GetComponent(findTF(arg0.cakeTf, "image"), typeof(Animator))

			arg0.cakeAniamtor:SetInteger("life", arg0:getCakeLifeIndex())

			arg0.cakeBox = GetComponent(arg0.cakeTf, "BoxCollider2D")
			arg0.cakeBoundsLength = {
				width = arg0.cakeBox.bounds.max.x - arg0.cakeBox.bounds.min.x,
				height = arg0.cakeBox.bounds.max.y - arg0.cakeBox.bounds.min.y
			}
			arg0.gameScore = 0
			arg0.createBounds = {}

			for iter2 = 0, arg0.createPos.childCount - 1 do
				table.insert(arg0.createBounds, arg0.createPos:GetChild(iter2))
			end
		end,
		step = function(arg0)
			for iter0 = #var16.level_up_time, 1, -1 do
				if iter0 > arg0.level and arg0.stepTime > var16.level_up_time[iter0] and arg0.level ~= iter0 then
					arg0.level = iter0

					print("level up :" .. arg0.level)

					break
				end
			end

			if arg0.apearTime == 0 then
				local var0 = arg0:getCreateCounts()

				for iter1 = 1, var0 do
					if #arg0.enemys < var16.enemy_max[arg0.level] then
						local var1 = var15[math.random(1, #var15)]
						local var2 = arg0:getEnemyFromPool(var1.type) or arg0:createEnemy(var1)

						table.insert(arg0.enemys, var2)
						var2:setActive(true)
						var2:moveTo(arg0:getRandApearPosition())
						var2:apear()
					end
				end

				arg0.apearTime = var16.enemy_apear_time[arg0.level]
			end

			table.sort(arg0.enemys, function(arg0, arg1)
				return arg0:getPosition().y > arg1:getPosition().y
			end)

			local var3 = 0

			for iter2 = #arg0.enemys, 1, -1 do
				local var4 = arg0.enemys[iter2]

				if arg0.cakeTf.localPosition.y <= var4:getPosition().y then
					var3 = var3 + 1
				end

				var4:SetSiblingIndex(iter2)
				var4:step()

				if var4:getMoveAble() then
					local var5 = var4:getPosition()

					if arg0:checkEnemySteal(var4) then
						var4:steal()
					else
						local var6 = Mathf.Atan2(Mathf.Abs(var5.y), Mathf.Abs(var5.x))
						local var7 = var4:getSpeed() * Mathf.Cos(var6) * -Mathf.Sign(var5.x)
						local var8 = var4:getSpeed() * Mathf.Sin(var6) * -Mathf.Sign(var5.y)

						var4:move(var7 * Time.deltaTime, var8 * Time.deltaTime)
					end
				end
			end

			arg0.cakeTf:SetSiblingIndex(var3)

			arg0.apearTime = arg0.apearTime - Time.deltaTime

			if arg0.apearTime < 0 then
				arg0.apearTime = 0
			end

			arg0.stepTime = arg0.stepTime + Time.deltaTime

			arg0.cakeAniamtor:SetInteger("life", arg0:getCakeLifeIndex())
		end,
		getCreateCounts = function(arg0)
			local var0 = arg0.countsWeight[arg0.level]
			local var1 = math.random(1, var0[#var0])

			for iter0 = 1, #var0 do
				if var1 <= var0[iter0] then
					return iter0
				end
			end

			return 1
		end,
		checkEnemySteal = function(arg0, arg1)
			local var0 = arg1:getBounds().min
			local var1 = arg1:getBoundLength()
			local var2 = arg0.cakeBox.bounds.min
			local var3 = arg0.cakeBoundsLength

			return arg0:checkRectCollider(var0, var2, var1, var3)
		end,
		checkRectCollider = function(arg0, arg1, arg2, arg3, arg4)
			local var0 = arg1.x
			local var1 = arg1.y
			local var2 = arg3.width
			local var3 = arg3.height
			local var4 = arg2.x
			local var5 = arg2.y
			local var6 = arg4.width
			local var7 = arg4.height

			if var4 <= var0 and var0 >= var4 + var6 then
				return false
			elseif var0 <= var4 and var4 >= var0 + var2 then
				return false
			elseif var5 <= var1 and var1 >= var5 + var7 then
				return false
			elseif var1 <= var5 and var5 >= var1 + var3 then
				return false
			else
				return true
			end
		end,
		createEnemy = function(arg0, arg1)
			local var0 = tf(Instantiate(arg0.enemysTpl[arg1.type]))
			local var1 = var23(var0, arg1)

			var1:setHandle(function(arg0)
				arg0:enemyEventHandle(arg0, var1)
			end)
			var1:setParent(arg0.enemyPos, true)

			return var1
		end,
		getEnemyFromPool = function(arg0, arg1)
			for iter0 = 1, #arg0.enemysPool do
				local var0 = arg0.enemysPool[iter0]

				if var0:getType() == arg1 then
					table.remove(arg0.enemysPool, iter0)

					return var0
				end
			end

			return nil
		end,
		removeEnemy = function(arg0, arg1)
			for iter0 = #arg0.enemys, 1, -1 do
				if arg0.enemys[iter0] == arg1 then
					table.remove(arg0.enemys, iter0)
				end
			end

			arg1:setActive(false)
			table.insert(arg0.enemysPool, arg1)
		end,
		getRandApearPosition = function(arg0)
			local var0 = math.random(1, #arg0.createBounds)
			local var1 = arg0.createBounds[var0]
			local var2 = math.random() * (var1.sizeDelta.x / 2) * (math.random() < 0.5 and 1 or -1)
			local var3 = math.random() * (var1.sizeDelta.y / 2) * (math.random() < 0.5 and 1 or -1)
			local var4 = var1:TransformPoint(var2, var3, 0)

			return (arg0.enemyPos:InverseTransformPoint(var4.x, var4.y, var4.z))
		end,
		enemyEventHandle = function(arg0, arg1, arg2)
			if arg1 == var2 then
				arg0.cakeLife = arg0.cakeLife - 1

				if arg0.callback2 then
					arg0.callback2()
				end

				if arg0.cakeLife <= 0 and arg0.callback then
					arg0.callback()
				end

				arg0.cakeAniamtor:SetInteger("life", arg0:getCakeLifeIndex())
			elseif arg1 == var1 then
				arg0.gameScore = arg0.gameScore + arg2:getScore()

				arg0:removeEnemy(arg2)
			else
				arg0:removeEnemy(arg2)
			end
		end,
		playerActAttake = function(arg0, arg1)
			local var0 = arg1.pos
			local var1 = arg1.boundsLength
			local var2 = arg1.damage
			local var3 = 0
			local var4 = 0

			for iter0 = 1, #arg0.enemys do
				local var5 = arg0.enemys[iter0]

				if var5:getAttakeAble() then
					local var6 = var5:getBounds().min
					local var7 = var5:getBoundLength()

					if arg0:checkRectCollider(var6, var0, var7, var1) then
						var5:damage(var2)

						var3 = var3 + 1

						if var5:getLife() == 0 then
							var4 = var4 + 1
						end
					end
				end
			end

			return var3, var4
		end,
		clear = function(arg0)
			arg0.stepTime = 0

			for iter0 = #arg0.enemys, 1, -1 do
				local var0 = table.remove(arg0.enemys, iter0)

				var0:setActive(false)
				table.insert(arg0.enemysPool, var0)
			end

			arg0.cakeLife = var17
			arg0.gameScore = 0
			arg0.level = 1
		end,
		getCakeLife = function(arg0)
			return arg0.cakeLife
		end,
		getCakeLifeIndex = function(arg0)
			for iter0 = #var18, 1, -1 do
				if arg0.cakeLife >= var18[iter0] then
					return iter0
				end
			end

			return 0
		end,
		getScore = function(arg0)
			return arg0.gameScore
		end
	}

	var0:ctor()

	return var0
end

local function var25(arg0, arg1, arg2)
	local var0 = {
		ctor = function(arg0)
			arg0.playerController = arg0
			arg0.enemyController = arg1
			arg0.callback = arg2

			arg0.playerController:setPlayerHandle(function(arg0)
				local var0, var1 = arg0.enemyController:playerActAttake(arg0)

				if var0 > 0 then
					arg0.playerController:attakeCount(var0)
				end

				if var1 > 0 then
					arg0.playerController:addSpecialCount(var1)

					if arg0.callback then
						arg0.callback()
					end
				end
			end)
		end
	}

	var0:ctor()

	return var0
end

local var26 = "role type loop"
local var27 = "role type normal"

local function var28(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0.playerController = arg1
			arg0.roleTfs = arg0
			arg0.roleDatas = {}

			for iter0 = 1, #arg0.roleTfs do
				local var0 = {
					animator = GetComponent(arg0.roleTfs[iter0], typeof(Animator))
				}

				if iter0 == 2 or iter0 == 3 then
					var0.type = var26
					var0.loop_time = {
						3,
						3
					}
					var0.time = 0
				else
					var0.type = var27
				end

				table.insert(arg0.roleDatas, var0)
			end
		end,
		step = function(arg0)
			local var0 = arg0.playerController:getSpecialData()

			for iter0 = 1, #arg0.roleDatas do
				local var1 = arg0.roleDatas[iter0]

				if var1.type == var26 then
					if var1.time == 0 then
						var1.animator:SetTrigger("loop")

						var1.time = math.random() * var1.loop_time[1] + var1.loop_time[2]
					else
						var1.time = var1.time - Time.deltaTime

						if var1.time < 0 then
							var1.time = 0
						end
					end
				end

				if var1.special and var0 == 0 then
					var1.animator:SetTrigger("reset")

					var1.special = false
				end
			end
		end,
		special = function(arg0)
			for iter0 = 1, #arg0.roleDatas do
				local var0 = arg0.roleDatas[iter0]

				var0.animator:SetTrigger("special")

				var0.special = true
			end
		end,
		fail = function(arg0)
			for iter0 = 1, #arg0.roleDatas do
				arg0.roleDatas[iter0].animator:SetTrigger("fail")
			end
		end,
		reset = function(arg0)
			for iter0 = 1, #arg0.roleDatas do
				arg0.roleDatas[iter0].animator:SetTrigger("reset")
			end
		end
	}

	var0:ctor()

	return var0
end

function var0.getUIName(arg0)
	return "PokeMoleGameUI"
end

function var0.getBGM(arg0)
	return var6
end

function var0.didEnter(arg0)
	arg0:initData()
	arg0:initUI()
end

function var0.initData(arg0)
	arg0.settlementFlag = false
	arg0.gameStartFlag = false

	local var0 = Application.targetFrameRate or 60

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1, true)
end

function var0.initUI(arg0)
	arg0.clickMask = findTF(arg0._tf, "clickMask")
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

	onButton(arg0, findTF(arg0.menuUI, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.securitycake_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CANCEL)

	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")
	arg0.textTime = findTF(arg0.gameUI, "time")
	arg0.textScore = findTF(arg0.gameUI, "score")
	arg0.hearts = {}

	local var0 = 3

	for iter0 = 1, var0 do
		local var1 = findTF(arg0.gameUI, "heart" .. iter0 .. "/img")

		table.insert(arg0.hearts, var1)
	end

	onButton(arg0, findTF(arg0.gameUI, "btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.specialSlider = GetComponent(findTF(arg0.gameUI, "btnSpecial/Slider"), typeof(Slider))
	arg0.touchSlider = findTF(arg0.specialSlider, "touch")
	arg0.specialEffect = findTF(arg0.gameUI, "btnSpecial/baoweidangao_extiao")
	arg0.arrowTf = findTF(arg0.gameUI, "btnSpecial/arrow")

	onButton(arg0, findTF(arg0.gameUI, "btnSpecial"), function()
		if arg0.playerController and arg0.playerController:useSpecial() then
			arg0.bgRoleController:special()
		end
	end)

	arg0.sceneTf = findTF(arg0._tf, "scene")
	arg0.playerTpl = findTF(arg0._tf, "playerTpl")
	arg0.playerController = var22(arg0.playerTpl, arg0.sceneTf)
	arg0.enemyTpls = {}

	for iter1 = 1, 4 do
		table.insert(arg0.enemyTpls, findTF(arg0._tf, "enemy" .. iter1 .. "Tpl"))
	end

	arg0.enemyController = var24(arg0.enemyTpls, arg0.sceneTf, function()
		arg0.bgRoleController:fail()
		arg0:onGameOver()
	end, function()
		arg0:gameUIUpdate()
	end)
	arg0.attakeController = var25(arg0.playerController, arg0.enemyController, function()
		arg0:gameUIUpdate()
	end)

	local var2 = {}
	local var3 = 4

	for iter2 = 1, var3 do
		table.insert(var2, findTF(arg0._tf, "bg_background/role/role" .. iter2))
	end

	arg0.bgRoleController = var28(var2, arg0.playerController)

	arg0:updateMenuUI()
	arg0:openMenuUI()

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet()
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "scene_front"), false)
	setActive(findTF(arg0._tf, "scene_background"), false)
	setActive(findTF(arg0._tf, "scene"), false)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	arg0:updateMenuUI()
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.enemyController:getScore()
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
		arg0:SendSuccess(0)
	end
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.Space) and arg0.playerController then
		local var0 = arg0.playerController:useSpecial()
	end
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

function var0.clearUI(arg0)
	return
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var12)
	arg0.bgRoleController:reset()
end

function var0.gameStart(arg0)
	arg0.gameStartFlag = true
	arg0.gameStepTime = 0
	arg0.gameLastTime = var14

	setActive(findTF(arg0._tf, "scene_front"), true)
	setActive(findTF(arg0._tf, "scene_background"), true)
	setActive(findTF(arg0._tf, "scene"), true)
	setActive(arg0.gameUI, true)
	arg0.playerController:createPlayer()
	arg0:timerStart()
	arg0:gameUIUpdate()
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0.playerController:step()
	arg0.enemyController:step()
	arg0.bgRoleController:step()

	arg0.gameLastTime = arg0.gameLastTime - Time.deltaTime

	setText(arg0.textScore, arg0.enemyController:getScore())

	if arg0.gameLastTime <= 0 then
		arg0.gameLastTime = 0

		arg0:onGameOver()
	end

	setText(arg0.textTime, math.ceil(arg0.gameLastTime) .. "")

	local var0, var1 = arg0.playerController:getSpecialData()

	var1 = var1 or 0

	if var0 > 0 then
		setSlider(arg0.specialSlider, 0, 1, var0 / var19)
	else
		setSlider(arg0.specialSlider, 0, 1, var1 / var20)
	end

	if var1 == var20 or var0 > 0 then
		SetActive(arg0.touchSlider, false)
		SetActive(arg0.specialEffect, true)
	else
		SetActive(arg0.touchSlider, true)
		SetActive(arg0.specialEffect, false)
	end

	if arg0.settlementFlag then
		SetActive(arg0.specialEffect, false)
	end

	SetActive(arg0.arrowTf, var1 == var20 and var0 == 0)
end

function var0.gameUIUpdate(arg0)
	for iter0 = 1, #arg0.hearts do
		if iter0 <= arg0.enemyController:getCakeLifeIndex() then
			SetActive(arg0.hearts[iter0], true)
		else
			SetActive(arg0.hearts[iter0], false)
		end
	end

	setText(arg0.textScore, arg0.enemyController:getScore())
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	SetActive(arg0.specialEffect, false)
	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 1, System.Action(function()
		arg0:showSettlement()
		arg0.enemyController:clear()
		arg0.playerController:clear()
		arg0.bgRoleController:reset()

		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
	end))
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
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

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	arg0.timer = nil
end

return var0
