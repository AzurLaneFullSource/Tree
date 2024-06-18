local var0_0 = class("PokeMoleView", import("..BaseMiniGameView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = {
	1000,
	230
}
local var5_0 = {
	300,
	100
}
local var6_0 = "backyard"
local var7_0 = "event:/ui/jida"
local var8_0 = "event:/ui/quanji"
local var9_0 = "event:/ui/baozhaxiaoshi"
local var10_0 = ""
local var11_0 = ""
local var12_0 = "event:/ui/ddldaoshu2"
local var13_0 = 0.5
local var14_0 = 90
local var15_0 = {
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
local var16_0 = {
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
local var17_0 = 3
local var18_0 = {
	1,
	2,
	3
}
local var19_0 = 10
local var20_0 = 10

local function var21_0(arg0_1, arg1_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._callback = arg1_1
			arg0_2._animator = GetComponent(arg0_2._tf, typeof(Animator))
			arg0_2._attakeCount = 0
			arg0_2._attakeCd = 0
			arg0_2._specialTime = 0
			arg0_2._specialCount = 0
			arg0_2.atkCollider = GetComponent(findTF(arg0_2._tf, "atkCollider"), typeof(BoxCollider2D))
			arg0_2.specialCollider = GetComponent(findTF(arg0_2._tf, "specialCollider"), typeof(BoxCollider2D))

			local var0_2 = GetComponent(arg0_2._tf, typeof(DftAniEvent))

			var0_2:SetStartEvent(function()
				return
			end)
			var0_2:SetTriggerEvent(function()
				if arg0_2._callback then
					local var0_4 = arg0_2:getColliderData()

					arg0_2._callback(var0_4)

					if arg0_2:getSpecialState() then
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(var8_0)
					end
				end
			end)
			var0_2:SetEndEvent(function()
				return
			end)
		end,
		getColliderData = function(arg0_6)
			local var0_6

			if arg0_6:getSpecialState() then
				var0_6 = arg0_6.specialCollider
			else
				var0_6 = arg0_6.atkCollider
			end

			local var1_6 = var0_6.bounds.max.x - var0_6.bounds.min.x
			local var2_6 = var0_6.bounds.max.y - var0_6.bounds.min.y

			return {
				pos = var0_6.bounds.min,
				boundsLength = {
					width = var1_6,
					height = var2_6
				},
				damage = arg0_6:getDamage()
			}
		end,
		atk = function(arg0_7)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var7_0)
			arg0_7._animator:SetTrigger("atk")

			arg0_7._attakeCd = var13_0
		end,
		specialAtk = function(arg0_8)
			arg0_8._animator:SetTrigger("special")

			arg0_8._attakeCd = var13_0
		end,
		getDamage = function(arg0_9)
			if arg0_9._specialTime > 0 then
				return 3
			end

			return 1
		end,
		reset = function(arg0_10)
			arg0_10._animator:SetTrigger("reset")
		end,
		setActive = function(arg0_11, arg1_11)
			SetActive(arg0_11._tf, arg1_11)
		end,
		setParent = function(arg0_12, arg1_12, arg2_12)
			SetParent(arg0_12._tf, arg1_12)
			arg0_12:setActive(arg2_12)
		end,
		attakeAble = function(arg0_13)
			return arg0_13._attakeCd == 0
		end,
		moveTo = function(arg0_14, arg1_14)
			arg1_14.y = arg1_14.y + 100
			arg0_14._tf.anchoredPosition = arg1_14
		end,
		attakeCount = function(arg0_15, arg1_15)
			arg0_15._attakeCount = arg0_15._attakeCount + arg1_15 * 4

			if arg0_15._attakeCount > 8 then
				arg0_15._attakeCount = 8
			end

			if arg0_15._attakeCount > 0 then
				arg0_15._animator.speed = 0
			end
		end,
		addSpecialCount = function(arg0_16, arg1_16)
			if arg0_16._specialTime == 0 then
				arg0_16._specialCount = arg0_16._specialCount + arg1_16

				if arg0_16._specialCount >= var20_0 then
					arg0_16._specialCount = var20_0
				end
			end
		end,
		useSpecial = function(arg0_17)
			if arg0_17._specialTime and arg0_17._specialCount >= var20_0 then
				arg0_17._specialCount = 0
				arg0_17._specialTime = var19_0

				return true
			end

			return false
		end,
		SetSiblingIndex = function(arg0_18, arg1_18)
			arg0_18._tf:SetSiblingIndex(arg1_18)
		end,
		getSpecialState = function(arg0_19)
			return arg0_19._specialTime > 0
		end,
		step = function(arg0_20)
			if arg0_20._attakeCount > 0 then
				arg0_20._attakeCount = arg0_20._attakeCount - 1

				if arg0_20._attakeCount == 0 then
					arg0_20._animator.speed = 1
				end
			end

			if arg0_20._attakeCd > 0 then
				arg0_20._attakeCd = arg0_20._attakeCd - Time.deltaTime
				arg0_20._attakeCd = arg0_20._attakeCd < 0 and 0 or arg0_20._attakeCd
			end

			if arg0_20._specialTime > 0 then
				arg0_20._specialTime = arg0_20._specialTime - Time.deltaTime
				arg0_20._specialTime = arg0_20._specialTime < 0 and 0 or arg0_20._specialTime
			end
		end,
		inSpecial = function(arg0_21)
			return arg0_21._specialTime > 0
		end,
		getSpecialData = function(arg0_22)
			return arg0_22._specialTime, arg0_22._specialCount
		end,
		clear = function(arg0_23)
			arg0_23._specialTime = 0
			arg0_23._specialCount = 0

			arg0_23:reset()
		end,
		useAtk = function(arg0_24)
			if arg0_24:inSpecial() then
				arg0_24:specialAtk()
			else
				arg0_24:atk()
			end
		end
	}

	var0_1:ctor()

	return var0_1
end

local function var22_0(arg0_25, arg1_25)
	local var0_25 = {
		ctor = function(arg0_26)
			arg0_26.playerTpl = arg0_25
			arg0_26.sceneTf = arg1_25
			arg0_26._playerPos = findTF(arg0_26.sceneTf, "playerPos")
			arg0_26.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
			arg0_26.dragDelegate = GetOrAddComponent(findTF(arg0_26.sceneTf, "clickBounds"), "EventTriggerListener")
			arg0_26.dragDelegate.enabled = true

			arg0_26.dragDelegate:AddPointDownFunc(function(arg0_27, arg1_27)
				if arg0_26.player and arg0_26.player:attakeAble() then
					local var0_27 = arg0_26.uiCam:ScreenToWorldPoint(arg1_27.pressPosition)
					local var1_27 = arg0_26._playerPos:InverseTransformPoint(var0_27)

					arg0_26.player:moveTo(var1_27)
					arg0_26.player:reset()
					arg0_26.player:useAtk()
				end
			end)
		end,
		createPlayer = function(arg0_28)
			if arg0_28.player == nil then
				arg0_28.player = var21_0(tf(Instantiate(arg0_28.playerTpl)), function(arg0_29)
					arg0_28:playerActHand(arg0_29)
				end)

				arg0_28.player:setParent(arg0_28._playerPos, true)
			end
		end,
		playerActHand = function(arg0_30, arg1_30)
			if arg0_30.playerHandle then
				arg0_30.playerHandle(arg1_30)
			end
		end,
		setPlayerHandle = function(arg0_31, arg1_31)
			arg0_31.playerHandle = arg1_31
		end,
		step = function(arg0_32)
			if arg0_32.player then
				arg0_32.player:step()
			end
		end,
		getSpecialData = function(arg0_33)
			if arg0_33.player then
				return arg0_33.player:getSpecialData()
			end

			return nil, nil
		end,
		useSpecial = function(arg0_34)
			if arg0_34.player then
				return arg0_34.player:useSpecial()
			end
		end,
		attakeCount = function(arg0_35, arg1_35)
			if arg0_35.player then
				arg0_35.player:attakeCount(arg1_35)
			end
		end,
		addSpecialCount = function(arg0_36, arg1_36)
			if arg0_36.player then
				arg0_36.player:addSpecialCount(arg1_36)
			end
		end,
		clear = function(arg0_37)
			if arg0_37.player then
				arg0_37.player:clear()
			end
		end
	}

	var0_25:ctor()

	return var0_25
end

local function var23_0(arg0_38, arg1_38)
	local var0_38 = {
		ctor = function(arg0_39)
			arg0_39._tf = arg0_38
			arg0_39._data = arg1_38
			arg0_39._life = 0
			arg0_39._enable = false
			arg0_39._attakeAble = false
			arg0_39._animator = GetComponent(arg0_39._tf, typeof(Animator))
			arg0_39._boxCollider = GetComponent(arg0_39._tf, "BoxCollider2D")

			local var0_39 = GetComponent(arg0_39._tf, typeof(DftAniEvent))

			var0_39:SetStartEvent(function()
				if arg0_39._callback then
					arg0_39._callback(var3_0)
				end
			end)
			var0_39:SetTriggerEvent(function()
				if arg0_39._callback then
					arg0_39._callback(var2_0)
				end
			end)
			var0_39:SetEndEvent(function()
				arg0_39._enable = false

				if arg0_39._callback then
					arg0_39._callback(var1_0)
				end
			end)
		end,
		setHandle = function(arg0_43, arg1_43)
			arg0_43._callback = arg1_43
		end,
		getSpeed = function(arg0_44)
			return arg0_44._data.speed
		end,
		step = function(arg0_45)
			if arg0_45._enableTime > 0 then
				arg0_45._enableTime = arg0_45._enableTime - Time.deltaTime

				if arg0_45._enableTime < 0 then
					arg0_45._enable = true
					arg0_45._enableTime = 0
				end
			end
		end,
		apear = function(arg0_46)
			arg0_46._animator:SetTrigger("pop")

			arg0_46._enableTime = math.random() * arg0_46._data.enable_time + 0.5
			arg0_46._life = arg0_46._data.life
			arg0_46._attakeAble = true
		end,
		stop = function(arg0_47)
			arg0_47._animator:SetBool("stop", true)
		end,
		damage = function(arg0_48, arg1_48)
			arg0_48._life = arg0_48._life - arg1_48

			if arg0_48._life <= 0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var9_0)
				arg0_48:dead()
			else
				arg0_48._animator:SetTrigger("damage")

				arg0_48._enable = false
				arg0_48._enableTime = arg0_48._data.damage_time
			end
		end,
		dead = function(arg0_49)
			arg0_49._animator:SetTrigger("dead")

			arg0_49._enable = false
			arg0_49._enableTime = 0
			arg0_49._attakeAble = false
		end,
		steal = function(arg0_50)
			arg0_50._animator:SetTrigger("steal")

			arg0_50._enable = false
			arg0_50._attakeAble = false
		end,
		move = function(arg0_51, arg1_51, arg2_51)
			local var0_51 = arg0_51._tf.anchoredPosition

			var0_51.x = var0_51.x + arg1_51
			var0_51.y = var0_51.y + arg2_51
			arg0_51._tf.anchoredPosition = var0_51

			local var1_51 = arg0_51._tf.localScale

			var1_51.x = Mathf.Abs(arg0_51._tf.localScale.x) * -1 * Mathf.Sign(arg1_51)
			arg0_51._tf.localScale = var1_51
		end,
		moveTo = function(arg0_52, arg1_52)
			arg0_52._tf.anchoredPosition = arg1_52

			local var0_52 = arg0_52._tf.localScale

			var0_52.x = Mathf.Abs(arg0_52._tf.localScale.x) * Mathf.Sign(arg0_52._tf.localPosition.x)
			arg0_52._tf.localScale = var0_52
		end,
		setParent = function(arg0_53, arg1_53, arg2_53)
			SetParent(arg0_53._tf, arg1_53)
			arg0_53:setActive(arg2_53)
		end,
		setActive = function(arg0_54, arg1_54)
			SetActive(arg0_54._tf, arg1_54)
		end,
		SetSiblingIndex = function(arg0_55, arg1_55)
			arg0_55._tf:SetSiblingIndex(arg1_55)
		end,
		getPosition = function(arg0_56)
			return arg0_56._tf.anchoredPosition
		end,
		getType = function(arg0_57)
			return arg0_57._data.type
		end,
		getMoveAble = function(arg0_58)
			return isActive(arg0_58._tf) and arg0_58._enable
		end,
		getAttakeAble = function(arg0_59)
			return isActive(arg0_59._tf) and arg0_59._attakeAble
		end,
		getBounds = function(arg0_60)
			return arg0_60._boxCollider.bounds
		end,
		getLife = function(arg0_61)
			return arg0_61._life
		end,
		getScore = function(arg0_62)
			return arg0_62._data.score
		end,
		getBoundLength = function(arg0_63)
			if arg0_63.boundsData == nil then
				local var0_63 = arg0_63._boxCollider.bounds.max.x - arg0_63._boxCollider.bounds.min.x
				local var1_63 = arg0_63._boxCollider.bounds.max.y - arg0_63._boxCollider.bounds.min.y

				arg0_63.boundsData = {
					width = var0_63,
					height = var1_63
				}
			end

			return arg0_63.boundsData
		end
	}

	var0_38:ctor()

	return var0_38
end

local function var24_0(arg0_64, arg1_64, arg2_64, arg3_64)
	local var0_64 = {
		ctor = function(arg0_65)
			arg0_65.enemysTpl = arg0_64
			arg0_65.sceneTf = arg1_64
			arg0_65.enemyPos = findTF(arg0_65.sceneTf, "enemyPos")
			arg0_65.createPos = findTF(arg0_65.sceneTf, "createPos")
			arg0_65.countsWeight = {}

			for iter0_65 = 1, #var16_0.enemy_amounts do
				local var0_65 = {}
				local var1_65 = 0
				local var2_65 = var16_0.enemy_amounts[iter0_65]

				for iter1_65 = 1, #var2_65 do
					var1_65 = var1_65 + var2_65[iter1_65]

					table.insert(var0_65, var1_65)
				end

				table.insert(arg0_65.countsWeight, var0_65)
			end

			arg0_65.callback = arg2_64
			arg0_65.callback2 = arg3_64
			arg0_65.enemys = {}
			arg0_65.enemysPool = {}
			arg0_65.apearTime = 0
			arg0_65.stepTime = 0
			arg0_65.level = 1
			arg0_65.cakeLife = var17_0
			arg0_65.cakeTf = findTF(arg0_65.sceneTf, "enemyPos/cake")
			arg0_65.cakeAniamtor = GetComponent(findTF(arg0_65.cakeTf, "image"), typeof(Animator))

			arg0_65.cakeAniamtor:SetInteger("life", arg0_65:getCakeLifeIndex())

			arg0_65.cakeBox = GetComponent(arg0_65.cakeTf, "BoxCollider2D")
			arg0_65.cakeBoundsLength = {
				width = arg0_65.cakeBox.bounds.max.x - arg0_65.cakeBox.bounds.min.x,
				height = arg0_65.cakeBox.bounds.max.y - arg0_65.cakeBox.bounds.min.y
			}
			arg0_65.gameScore = 0
			arg0_65.createBounds = {}

			for iter2_65 = 0, arg0_65.createPos.childCount - 1 do
				table.insert(arg0_65.createBounds, arg0_65.createPos:GetChild(iter2_65))
			end
		end,
		step = function(arg0_66)
			for iter0_66 = #var16_0.level_up_time, 1, -1 do
				if iter0_66 > arg0_66.level and arg0_66.stepTime > var16_0.level_up_time[iter0_66] and arg0_66.level ~= iter0_66 then
					arg0_66.level = iter0_66

					print("level up :" .. arg0_66.level)

					break
				end
			end

			if arg0_66.apearTime == 0 then
				local var0_66 = arg0_66:getCreateCounts()

				for iter1_66 = 1, var0_66 do
					if #arg0_66.enemys < var16_0.enemy_max[arg0_66.level] then
						local var1_66 = var15_0[math.random(1, #var15_0)]
						local var2_66 = arg0_66:getEnemyFromPool(var1_66.type) or arg0_66:createEnemy(var1_66)

						table.insert(arg0_66.enemys, var2_66)
						var2_66:setActive(true)
						var2_66:moveTo(arg0_66:getRandApearPosition())
						var2_66:apear()
					end
				end

				arg0_66.apearTime = var16_0.enemy_apear_time[arg0_66.level]
			end

			table.sort(arg0_66.enemys, function(arg0_67, arg1_67)
				return arg0_67:getPosition().y > arg1_67:getPosition().y
			end)

			local var3_66 = 0

			for iter2_66 = #arg0_66.enemys, 1, -1 do
				local var4_66 = arg0_66.enemys[iter2_66]

				if arg0_66.cakeTf.localPosition.y <= var4_66:getPosition().y then
					var3_66 = var3_66 + 1
				end

				var4_66:SetSiblingIndex(iter2_66)
				var4_66:step()

				if var4_66:getMoveAble() then
					local var5_66 = var4_66:getPosition()

					if arg0_66:checkEnemySteal(var4_66) then
						var4_66:steal()
					else
						local var6_66 = Mathf.Atan2(Mathf.Abs(var5_66.y), Mathf.Abs(var5_66.x))
						local var7_66 = var4_66:getSpeed() * Mathf.Cos(var6_66) * -Mathf.Sign(var5_66.x)
						local var8_66 = var4_66:getSpeed() * Mathf.Sin(var6_66) * -Mathf.Sign(var5_66.y)

						var4_66:move(var7_66 * Time.deltaTime, var8_66 * Time.deltaTime)
					end
				end
			end

			arg0_66.cakeTf:SetSiblingIndex(var3_66)

			arg0_66.apearTime = arg0_66.apearTime - Time.deltaTime

			if arg0_66.apearTime < 0 then
				arg0_66.apearTime = 0
			end

			arg0_66.stepTime = arg0_66.stepTime + Time.deltaTime

			arg0_66.cakeAniamtor:SetInteger("life", arg0_66:getCakeLifeIndex())
		end,
		getCreateCounts = function(arg0_68)
			local var0_68 = arg0_68.countsWeight[arg0_68.level]
			local var1_68 = math.random(1, var0_68[#var0_68])

			for iter0_68 = 1, #var0_68 do
				if var1_68 <= var0_68[iter0_68] then
					return iter0_68
				end
			end

			return 1
		end,
		checkEnemySteal = function(arg0_69, arg1_69)
			local var0_69 = arg1_69:getBounds().min
			local var1_69 = arg1_69:getBoundLength()
			local var2_69 = arg0_69.cakeBox.bounds.min
			local var3_69 = arg0_69.cakeBoundsLength

			return arg0_69:checkRectCollider(var0_69, var2_69, var1_69, var3_69)
		end,
		checkRectCollider = function(arg0_70, arg1_70, arg2_70, arg3_70, arg4_70)
			local var0_70 = arg1_70.x
			local var1_70 = arg1_70.y
			local var2_70 = arg3_70.width
			local var3_70 = arg3_70.height
			local var4_70 = arg2_70.x
			local var5_70 = arg2_70.y
			local var6_70 = arg4_70.width
			local var7_70 = arg4_70.height

			if var4_70 <= var0_70 and var0_70 >= var4_70 + var6_70 then
				return false
			elseif var0_70 <= var4_70 and var4_70 >= var0_70 + var2_70 then
				return false
			elseif var5_70 <= var1_70 and var1_70 >= var5_70 + var7_70 then
				return false
			elseif var1_70 <= var5_70 and var5_70 >= var1_70 + var3_70 then
				return false
			else
				return true
			end
		end,
		createEnemy = function(arg0_71, arg1_71)
			local var0_71 = tf(Instantiate(arg0_71.enemysTpl[arg1_71.type]))
			local var1_71 = var23_0(var0_71, arg1_71)

			var1_71:setHandle(function(arg0_72)
				arg0_71:enemyEventHandle(arg0_72, var1_71)
			end)
			var1_71:setParent(arg0_71.enemyPos, true)

			return var1_71
		end,
		getEnemyFromPool = function(arg0_73, arg1_73)
			for iter0_73 = 1, #arg0_73.enemysPool do
				local var0_73 = arg0_73.enemysPool[iter0_73]

				if var0_73:getType() == arg1_73 then
					table.remove(arg0_73.enemysPool, iter0_73)

					return var0_73
				end
			end

			return nil
		end,
		removeEnemy = function(arg0_74, arg1_74)
			for iter0_74 = #arg0_74.enemys, 1, -1 do
				if arg0_74.enemys[iter0_74] == arg1_74 then
					table.remove(arg0_74.enemys, iter0_74)
				end
			end

			arg1_74:setActive(false)
			table.insert(arg0_74.enemysPool, arg1_74)
		end,
		getRandApearPosition = function(arg0_75)
			local var0_75 = math.random(1, #arg0_75.createBounds)
			local var1_75 = arg0_75.createBounds[var0_75]
			local var2_75 = math.random() * (var1_75.sizeDelta.x / 2) * (math.random() < 0.5 and 1 or -1)
			local var3_75 = math.random() * (var1_75.sizeDelta.y / 2) * (math.random() < 0.5 and 1 or -1)
			local var4_75 = var1_75:TransformPoint(var2_75, var3_75, 0)

			return (arg0_75.enemyPos:InverseTransformPoint(var4_75.x, var4_75.y, var4_75.z))
		end,
		enemyEventHandle = function(arg0_76, arg1_76, arg2_76)
			if arg1_76 == var2_0 then
				arg0_76.cakeLife = arg0_76.cakeLife - 1

				if arg0_76.callback2 then
					arg0_76.callback2()
				end

				if arg0_76.cakeLife <= 0 and arg0_76.callback then
					arg0_76.callback()
				end

				arg0_76.cakeAniamtor:SetInteger("life", arg0_76:getCakeLifeIndex())
			elseif arg1_76 == var1_0 then
				arg0_76.gameScore = arg0_76.gameScore + arg2_76:getScore()

				arg0_76:removeEnemy(arg2_76)
			else
				arg0_76:removeEnemy(arg2_76)
			end
		end,
		playerActAttake = function(arg0_77, arg1_77)
			local var0_77 = arg1_77.pos
			local var1_77 = arg1_77.boundsLength
			local var2_77 = arg1_77.damage
			local var3_77 = 0
			local var4_77 = 0

			for iter0_77 = 1, #arg0_77.enemys do
				local var5_77 = arg0_77.enemys[iter0_77]

				if var5_77:getAttakeAble() then
					local var6_77 = var5_77:getBounds().min
					local var7_77 = var5_77:getBoundLength()

					if arg0_77:checkRectCollider(var6_77, var0_77, var7_77, var1_77) then
						var5_77:damage(var2_77)

						var3_77 = var3_77 + 1

						if var5_77:getLife() == 0 then
							var4_77 = var4_77 + 1
						end
					end
				end
			end

			return var3_77, var4_77
		end,
		clear = function(arg0_78)
			arg0_78.stepTime = 0

			for iter0_78 = #arg0_78.enemys, 1, -1 do
				local var0_78 = table.remove(arg0_78.enemys, iter0_78)

				var0_78:setActive(false)
				table.insert(arg0_78.enemysPool, var0_78)
			end

			arg0_78.cakeLife = var17_0
			arg0_78.gameScore = 0
			arg0_78.level = 1
		end,
		getCakeLife = function(arg0_79)
			return arg0_79.cakeLife
		end,
		getCakeLifeIndex = function(arg0_80)
			for iter0_80 = #var18_0, 1, -1 do
				if arg0_80.cakeLife >= var18_0[iter0_80] then
					return iter0_80
				end
			end

			return 0
		end,
		getScore = function(arg0_81)
			return arg0_81.gameScore
		end
	}

	var0_64:ctor()

	return var0_64
end

local function var25_0(arg0_82, arg1_82, arg2_82)
	local var0_82 = {
		ctor = function(arg0_83)
			arg0_83.playerController = arg0_82
			arg0_83.enemyController = arg1_82
			arg0_83.callback = arg2_82

			arg0_83.playerController:setPlayerHandle(function(arg0_84)
				local var0_84, var1_84 = arg0_83.enemyController:playerActAttake(arg0_84)

				if var0_84 > 0 then
					arg0_83.playerController:attakeCount(var0_84)
				end

				if var1_84 > 0 then
					arg0_83.playerController:addSpecialCount(var1_84)

					if arg0_83.callback then
						arg0_83.callback()
					end
				end
			end)
		end
	}

	var0_82:ctor()

	return var0_82
end

local var26_0 = "role type loop"
local var27_0 = "role type normal"

local function var28_0(arg0_85, arg1_85)
	local var0_85 = {
		ctor = function(arg0_86)
			arg0_86.playerController = arg1_85
			arg0_86.roleTfs = arg0_85
			arg0_86.roleDatas = {}

			for iter0_86 = 1, #arg0_86.roleTfs do
				local var0_86 = {
					animator = GetComponent(arg0_86.roleTfs[iter0_86], typeof(Animator))
				}

				if iter0_86 == 2 or iter0_86 == 3 then
					var0_86.type = var26_0
					var0_86.loop_time = {
						3,
						3
					}
					var0_86.time = 0
				else
					var0_86.type = var27_0
				end

				table.insert(arg0_86.roleDatas, var0_86)
			end
		end,
		step = function(arg0_87)
			local var0_87 = arg0_87.playerController:getSpecialData()

			for iter0_87 = 1, #arg0_87.roleDatas do
				local var1_87 = arg0_87.roleDatas[iter0_87]

				if var1_87.type == var26_0 then
					if var1_87.time == 0 then
						var1_87.animator:SetTrigger("loop")

						var1_87.time = math.random() * var1_87.loop_time[1] + var1_87.loop_time[2]
					else
						var1_87.time = var1_87.time - Time.deltaTime

						if var1_87.time < 0 then
							var1_87.time = 0
						end
					end
				end

				if var1_87.special and var0_87 == 0 then
					var1_87.animator:SetTrigger("reset")

					var1_87.special = false
				end
			end
		end,
		special = function(arg0_88)
			for iter0_88 = 1, #arg0_88.roleDatas do
				local var0_88 = arg0_88.roleDatas[iter0_88]

				var0_88.animator:SetTrigger("special")

				var0_88.special = true
			end
		end,
		fail = function(arg0_89)
			for iter0_89 = 1, #arg0_89.roleDatas do
				arg0_89.roleDatas[iter0_89].animator:SetTrigger("fail")
			end
		end,
		reset = function(arg0_90)
			for iter0_90 = 1, #arg0_90.roleDatas do
				arg0_90.roleDatas[iter0_90].animator:SetTrigger("reset")
			end
		end
	}

	var0_85:ctor()

	return var0_85
end

function var0_0.getUIName(arg0_91)
	return "PokeMoleGameUI"
end

function var0_0.getBGM(arg0_92)
	return var6_0
end

function var0_0.didEnter(arg0_93)
	arg0_93:initData()
	arg0_93:initUI()
end

function var0_0.initData(arg0_94)
	arg0_94.settlementFlag = false
	arg0_94.gameStartFlag = false

	local var0_94 = Application.targetFrameRate or 60

	arg0_94.timer = Timer.New(function()
		arg0_94:onTimer()
	end, 1 / var0_94, -1, true)
end

function var0_0.initUI(arg0_96)
	arg0_96.clickMask = findTF(arg0_96._tf, "clickMask")
	arg0_96.countUI = findTF(arg0_96._tf, "pop/CountUI")
	arg0_96.countAnimator = GetComponent(findTF(arg0_96.countUI, "count"), typeof(Animator))
	arg0_96.countDft = GetComponent(findTF(arg0_96.countUI, "count"), typeof(DftAniEvent))

	arg0_96.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_96.countDft:SetEndEvent(function()
		setActive(arg0_96.countUI, false)
		arg0_96:gameStart()
	end)

	arg0_96.leaveUI = findTF(arg0_96._tf, "pop/LeaveUI")

	onButton(arg0_96, findTF(arg0_96.leaveUI, "ad/btnOk"), function()
		arg0_96:resumeGame()
		arg0_96:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_96, findTF(arg0_96.leaveUI, "ad/btnCancel"), function()
		arg0_96:resumeGame()
	end, SFX_CANCEL)

	arg0_96.pauseUI = findTF(arg0_96._tf, "pop/pauseUI")

	onButton(arg0_96, findTF(arg0_96.pauseUI, "ad/btnOk"), function()
		setActive(arg0_96.pauseUI, false)
		arg0_96:resumeGame()
	end, SFX_CANCEL)

	arg0_96.settlementUI = findTF(arg0_96._tf, "pop/SettleMentUI")

	onButton(arg0_96, findTF(arg0_96.settlementUI, "ad/btnOver"), function()
		setActive(arg0_96.settlementUI, false)
		arg0_96:openMenuUI()
	end, SFX_CANCEL)

	arg0_96.menuUI = findTF(arg0_96._tf, "pop/menuUI")

	onButton(arg0_96, findTF(arg0_96.menuUI, "btnBack"), function()
		arg0_96:closeView()
	end, SFX_CANCEL)
	onButton(arg0_96, findTF(arg0_96.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.securitycake_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_96, findTF(arg0_96.menuUI, "btnStart"), function()
		setActive(arg0_96.menuUI, false)
		arg0_96:readyStart()
	end, SFX_CANCEL)

	arg0_96.gameUI = findTF(arg0_96._tf, "ui/gameUI")
	arg0_96.textTime = findTF(arg0_96.gameUI, "time")
	arg0_96.textScore = findTF(arg0_96.gameUI, "score")
	arg0_96.hearts = {}

	local var0_96 = 3

	for iter0_96 = 1, var0_96 do
		local var1_96 = findTF(arg0_96.gameUI, "heart" .. iter0_96 .. "/img")

		table.insert(arg0_96.hearts, var1_96)
	end

	onButton(arg0_96, findTF(arg0_96.gameUI, "btnStop"), function()
		arg0_96:stopGame()
		setActive(arg0_96.pauseUI, true)
	end)
	onButton(arg0_96, findTF(arg0_96.gameUI, "btnLeave"), function()
		arg0_96:stopGame()
		setActive(arg0_96.leaveUI, true)
	end)

	arg0_96.specialSlider = GetComponent(findTF(arg0_96.gameUI, "btnSpecial/Slider"), typeof(Slider))
	arg0_96.touchSlider = findTF(arg0_96.specialSlider, "touch")
	arg0_96.specialEffect = findTF(arg0_96.gameUI, "btnSpecial/baoweidangao_extiao")
	arg0_96.arrowTf = findTF(arg0_96.gameUI, "btnSpecial/arrow")

	onButton(arg0_96, findTF(arg0_96.gameUI, "btnSpecial"), function()
		if arg0_96.playerController and arg0_96.playerController:useSpecial() then
			arg0_96.bgRoleController:special()
		end
	end)

	arg0_96.sceneTf = findTF(arg0_96._tf, "scene")
	arg0_96.playerTpl = findTF(arg0_96._tf, "playerTpl")
	arg0_96.playerController = var22_0(arg0_96.playerTpl, arg0_96.sceneTf)
	arg0_96.enemyTpls = {}

	for iter1_96 = 1, 4 do
		table.insert(arg0_96.enemyTpls, findTF(arg0_96._tf, "enemy" .. iter1_96 .. "Tpl"))
	end

	arg0_96.enemyController = var24_0(arg0_96.enemyTpls, arg0_96.sceneTf, function()
		arg0_96.bgRoleController:fail()
		arg0_96:onGameOver()
	end, function()
		arg0_96:gameUIUpdate()
	end)
	arg0_96.attakeController = var25_0(arg0_96.playerController, arg0_96.enemyController, function()
		arg0_96:gameUIUpdate()
	end)

	local var2_96 = {}
	local var3_96 = 4

	for iter2_96 = 1, var3_96 do
		table.insert(var2_96, findTF(arg0_96._tf, "bg_background/role/role" .. iter2_96))
	end

	arg0_96.bgRoleController = var28_0(var2_96, arg0_96.playerController)

	arg0_96:updateMenuUI()
	arg0_96:openMenuUI()

	if not arg0_96.handle then
		arg0_96.handle = UpdateBeat:CreateListener(arg0_96.Update, arg0_96)
	end

	UpdateBeat:AddListener(arg0_96.handle)
end

function var0_0.updateMenuUI(arg0_112)
	local var0_112 = arg0_112:getGameUsedTimes()
	local var1_112 = arg0_112:getGameTimes()

	setActive(findTF(arg0_112.menuUI, "btnStart/tip"), var1_112 > 0)
	arg0_112:CheckGet()
end

function var0_0.openMenuUI(arg0_113)
	setActive(findTF(arg0_113._tf, "scene_front"), false)
	setActive(findTF(arg0_113._tf, "scene_background"), false)
	setActive(findTF(arg0_113._tf, "scene"), false)
	setActive(arg0_113.gameUI, false)
	setActive(arg0_113.menuUI, true)
	arg0_113:updateMenuUI()
end

function var0_0.showSettlement(arg0_114)
	setActive(arg0_114.settlementUI, true)
	GetComponent(findTF(arg0_114.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_114 = arg0_114:GetMGData():GetRuntimeData("elements")
	local var1_114 = arg0_114.enemyController:getScore()
	local var2_114 = var0_114 and #var0_114 > 0 and var0_114[1] or 0

	if var2_114 <= var1_114 then
		var2_114 = var1_114

		arg0_114:StoreDataToServer({
			var2_114
		})
	end

	local var3_114 = findTF(arg0_114.settlementUI, "ad/highText")
	local var4_114 = findTF(arg0_114.settlementUI, "ad/currentText")

	setText(var3_114, var2_114)
	setText(var4_114, var1_114)

	if arg0_114:getGameTimes() and arg0_114:getGameTimes() > 0 then
		arg0_114:SendSuccess(0)
	end
end

function var0_0.Update(arg0_115)
	arg0_115:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_116)
	if arg0_116.gameStop or arg0_116.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.Space) and arg0_116.playerController then
		local var0_116 = arg0_116.playerController:useSpecial()
	end
end

function var0_0.CheckGet(arg0_117)
	setActive(findTF(arg0_117.menuUI, "got"), false)

	if arg0_117:getUltimate() and arg0_117:getUltimate() ~= 0 then
		setActive(findTF(arg0_117.menuUI, "got"), true)
	end

	if arg0_117:getUltimate() == 0 then
		if arg0_117:getGameTotalTime() > arg0_117:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_117:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_117.menuUI, "got"), true)
	end
end

function var0_0.clearUI(arg0_118)
	return
end

function var0_0.readyStart(arg0_119)
	setActive(arg0_119.countUI, true)
	arg0_119.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var12_0)
	arg0_119.bgRoleController:reset()
end

function var0_0.gameStart(arg0_120)
	arg0_120.gameStartFlag = true
	arg0_120.gameStepTime = 0
	arg0_120.gameLastTime = var14_0

	setActive(findTF(arg0_120._tf, "scene_front"), true)
	setActive(findTF(arg0_120._tf, "scene_background"), true)
	setActive(findTF(arg0_120._tf, "scene"), true)
	setActive(arg0_120.gameUI, true)
	arg0_120.playerController:createPlayer()
	arg0_120:timerStart()
	arg0_120:gameUIUpdate()
end

function var0_0.onTimer(arg0_121)
	arg0_121:gameStep()
end

function var0_0.gameStep(arg0_122)
	arg0_122.playerController:step()
	arg0_122.enemyController:step()
	arg0_122.bgRoleController:step()

	arg0_122.gameLastTime = arg0_122.gameLastTime - Time.deltaTime

	setText(arg0_122.textScore, arg0_122.enemyController:getScore())

	if arg0_122.gameLastTime <= 0 then
		arg0_122.gameLastTime = 0

		arg0_122:onGameOver()
	end

	setText(arg0_122.textTime, math.ceil(arg0_122.gameLastTime) .. "")

	local var0_122, var1_122 = arg0_122.playerController:getSpecialData()

	var1_122 = var1_122 or 0

	if var0_122 > 0 then
		setSlider(arg0_122.specialSlider, 0, 1, var0_122 / var19_0)
	else
		setSlider(arg0_122.specialSlider, 0, 1, var1_122 / var20_0)
	end

	if var1_122 == var20_0 or var0_122 > 0 then
		SetActive(arg0_122.touchSlider, false)
		SetActive(arg0_122.specialEffect, true)
	else
		SetActive(arg0_122.touchSlider, true)
		SetActive(arg0_122.specialEffect, false)
	end

	if arg0_122.settlementFlag then
		SetActive(arg0_122.specialEffect, false)
	end

	SetActive(arg0_122.arrowTf, var1_122 == var20_0 and var0_122 == 0)
end

function var0_0.gameUIUpdate(arg0_123)
	for iter0_123 = 1, #arg0_123.hearts do
		if iter0_123 <= arg0_123.enemyController:getCakeLifeIndex() then
			SetActive(arg0_123.hearts[iter0_123], true)
		else
			SetActive(arg0_123.hearts[iter0_123], false)
		end
	end

	setText(arg0_123.textScore, arg0_123.enemyController:getScore())
end

function var0_0.resumeGame(arg0_124)
	arg0_124.gameStop = false

	setActive(arg0_124.leaveUI, false)
	arg0_124:timerStart()
end

function var0_0.stopGame(arg0_125)
	arg0_125.gameStop = true

	arg0_125:timerStop()
end

function var0_0.onGameOver(arg0_126)
	if arg0_126.settlementFlag then
		return
	end

	arg0_126:timerStop()

	arg0_126.settlementFlag = true

	SetActive(arg0_126.specialEffect, false)
	setActive(arg0_126.clickMask, true)
	LeanTween.delayedCall(go(arg0_126._tf), 1, System.Action(function()
		arg0_126:showSettlement()
		arg0_126.enemyController:clear()
		arg0_126.playerController:clear()
		arg0_126.bgRoleController:reset()

		arg0_126.settlementFlag = false
		arg0_126.gameStartFlag = false

		setActive(arg0_126.clickMask, false)
	end))
end

function var0_0.timerStop(arg0_128)
	if arg0_128.timer.running then
		arg0_128.timer:Stop()
	end
end

function var0_0.timerStart(arg0_129)
	if not arg0_129.timer.running then
		arg0_129.timer:Start()
	end
end

function var0_0.getGameTimes(arg0_130)
	return arg0_130:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_131)
	return arg0_131:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_132)
	return arg0_132:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_133)
	return (arg0_133:GetMGHubData():getConfig("reward_need"))
end

function var0_0.onBackPressed(arg0_134)
	return
end

function var0_0.willExit(arg0_135)
	if arg0_135.handle then
		UpdateBeat:RemoveListener(arg0_135.handle)
	end

	if arg0_135.timer and arg0_135.timer.running then
		arg0_135.timer:Stop()
	end

	arg0_135.timer = nil
end

return var0_0
