local var0_0 = class("SailBoatGameScene")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0

var0_0.random_scene_imgs = {
	{
		content = "scene_background/content/bg_6",
		icon = {
			"06_Deep_Multiply_1",
			"06_Deep_Multiply_2",
			"06_Deep_Multiply_3",
			"06_Deep_Multiply_4",
			"06_Deep_Multiply_5",
			"06_Deep_Multiply_6",
			"06_Deep_Multiply_7"
		}
	}
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var5_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1.sceneContent = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	local function var0_1(arg0_2, arg1_2)
		if arg0_2 == SailBoatGameEvent.DESTROY_ENEMY then
			arg0_1:destroyEnemy(arg1_2)
		elseif arg0_2 == SailBoatGameEvent.USE_ITEM then
			arg0_1._event:emit(SailBoatGameView.ADD_SCORE, {
				num = arg1_2.score
			})

			if arg1_2.skill then
				var5_0.AddSkill()
			end
		elseif arg0_2 == SailBoatGameEvent.PLAYER_DEAD then
			arg0_1._event:emit(SailBoatGameView.GAME_OVER)
		end

		arg0_1:onSceneEventCall(arg0_2, arg1_2)
	end

	arg0_1.charControl = SailBoatCharControl.New(arg0_1.sceneContent, var0_1)
	arg0_1.bgControl = SailBoatBgControl.New(arg0_1.sceneContent, var0_1)
	arg0_1.itemControl = SailBoatItemControl.New(arg0_1.sceneContent, var0_1)
	arg0_1.colliderControl = SailBoatColliderControl.New(arg0_1.sceneContent, var0_1)
	arg0_1.enemyControl = SailBoatEnemyControl.New(arg0_1.sceneContent, var0_1)
	arg0_1.bulletControl = SailBoatBulletsControl.New(arg0_1.sceneContent, var0_1)
	arg0_1.effectControl = SailBoatEffectControl.New(arg0_1.sceneContent, var0_1)
	arg0_1.bgRules = {}
	arg0_1.bgTfs = {}
	arg0_1.bgTfPool = {}

	for iter0_1 = 1, #var0_0.random_scene_imgs do
		local var1_1 = var0_0.random_scene_imgs[iter0_1]

		table.insert(arg0_1.bgRules, {
			time = 0,
			ruleData = var1_1
		})
	end
end

function var0_0.start(arg0_3)
	arg0_3:showContainer(true)
	arg0_3.charControl:start()
	arg0_3.bgControl:start()
	arg0_3.itemControl:start()
	arg0_3.colliderControl:start()
	arg0_3.enemyControl:start()
	arg0_3.bulletControl:start()
	arg0_3.effectControl:start()

	arg0_3.sortIndex = 10
	arg0_3.bgImgTpl = var5_0.GetGameBgTf("bgs/bg_other")

	for iter0_3 = #arg0_3.bgTfs, 1, -1 do
		local var0_3 = table.remove(arg0_3.bgTfs, iter0_3)

		setActive(var0_3, false)
		table.insert(arg0_3.bgTfPool, var0_3)
	end

	for iter1_3 = 1, #arg0_3.bgRules do
		arg0_3.bgRules[iter1_3].time = 0
	end
end

function var0_0.step(arg0_4, arg1_4)
	local var0_4
	local var1_4
	local var2_4
	local var3_4
	local var4_4
	local var5_4
	local var6_4
	local var7_4 = os.clock()

	arg0_4.charControl:step(arg1_4)

	local var8_4 = (os.clock() - var7_4) * 1000
	local var9_4 = os.clock()

	arg0_4.bgControl:step(arg1_4)

	local var10_4 = (os.clock() - var9_4) * 1000
	local var11_4 = os.clock()

	arg0_4.itemControl:step(arg1_4)

	local var12_4 = (os.clock() - var11_4) * 1000
	local var13_4 = os.clock()

	arg0_4.colliderControl:step(arg1_4)

	local var14_4 = (os.clock() - var13_4) * 1000
	local var15_4 = os.clock()

	arg0_4.enemyControl:step(arg1_4)

	local var16_4 = (os.clock() - var15_4) * 1000
	local var17_4 = os.clock()

	arg0_4.bulletControl:step(arg1_4)

	local var18_4 = tostring((os.clock() - var17_4) * 1000, 2)
	local var19_4 = os.clock()

	arg0_4.effectControl:step(arg1_4)

	local var20_4 = (os.clock() - var19_4) * 1000
	local var21_4 = os.clock()
	local var22_4 = var5_0.GetGameEnemys()
	local var23_4 = var5_0.GetGameChar()
	local var24_4 = var5_0.GetGameItems()

	if not arg0_4.sortTfs or #arg0_4.sortTfs ~= #var22_4 + 1 + #var24_4 then
		arg0_4.sortTfs = {}

		for iter0_4 = 1, #var22_4 do
			table.insert(arg0_4.sortTfs, var22_4[iter0_4]:getTf())
		end

		for iter1_4 = 1, #var24_4 do
			table.insert(arg0_4.sortTfs, var24_4[iter1_4]:getTf())
		end

		table.insert(arg0_4.sortTfs, var23_4:getTf())
	end

	if arg0_4.sortIndex and arg0_4.sortIndex == 0 then
		arg0_4:sortItems(arg0_4.sortTfs)

		arg0_4.sortIndex = 10
	else
		arg0_4.sortIndex = arg0_4.sortIndex - 1
	end

	for iter2_4 = 1, #arg0_4.bgRules do
		if arg0_4.bgRules[iter2_4].time <= 0 then
			arg0_4.bgRules[iter2_4].time = math.random(30, 45)

			local var25_4 = arg0_4.bgRules[iter2_4].ruleData.icon
			local var26_4 = var25_4[math.random(1, #var25_4)]
			local var27_4

			if #arg0_4.bgTfPool > 0 then
				var27_4 = table.remove(arg0_4.bgTfPool, 1)
			else
				var27_4 = tf(instantiate(arg0_4.bgImgTpl))

				SetParent(var27_4, findTF(arg0_4.sceneContent, arg0_4.bgRules[iter2_4].ruleData.content))
			end

			setImageSprite(findTF(var27_4, "img"), var5_0.GetBgIcon(var26_4), true)
			setActive(var27_4, true)
			table.insert(arg0_4.bgTfs, var27_4)

			var27_4.anchoredPosition = Vector2(math.random(-300, 300), 2000)
			var27_4.localEulerAngles = Vector3(0, 0, math.random(1, 360))
		end

		arg0_4.bgRules[iter2_4].time = arg0_4.bgRules[iter2_4].time - arg1_4
	end

	local var28_4 = var5_0.GetSceneSpeed()

	for iter3_4 = #arg0_4.bgTfs, 1, -1 do
		local var29_4 = arg0_4.bgTfs[iter3_4]

		if var29_4.anchoredPosition.y < -2000 then
			setActive(var29_4, false)
			table.insert(arg0_4.bgTfPool, var29_4)
			table.remove(arg0_4.bgTfs, iter3_4)
		else
			local var30_4 = var29_4.anchoredPosition

			var30_4.y = var30_4.y + var28_4.y
			var29_4.anchoredPosition = var30_4
		end
	end
end

function var0_0.destroyEnemy(arg0_5, arg1_5)
	arg0_5._event:emit(SailBoatGameView.ADD_SCORE, {
		num = arg1_5.score
	})

	if arg1_5.boom then
		arg0_5:checkBoomDamage(arg1_5)
	end
end

function var0_0.checkBoomDamage(arg0_6, arg1_6)
	local var0_6 = arg1_6.boom
	local var1_6 = arg1_6.position
	local var2_6 = arg1_6.range
	local var3_6 = var5_0.GetGameChar()
	local var4_6 = var5_0.GetGameEnemys()
	local var5_6 = var3_6:getPosition()
	local var6_6 = var3_6:getConfig("range")

	if math.abs(var1_6.x - var5_6.x) < var2_6.x + var6_6.x / 2 and math.abs(var1_6.y - var5_6.y) < var2_6.y + var6_6.y / 2 then
		var3_6:damage({
			num = var0_6,
			position = var1_6
		})
	end

	for iter0_6 = 1, #var4_6 do
		local var7_6 = var4_6[iter0_6]
		local var8_6 = var7_6:getPosition()
		local var9_6 = var7_6:getConfig("range")

		if math.abs(var1_6.x - var8_6.x) < var2_6.x + var8_6.x / 2 and math.abs(var1_6.y - var8_6.y) < var2_6.y + var8_6.y / 2 and var7_6:damage({
			num = var0_6,
			position = var1_6
		}) then
			arg0_6:destroyEnemy(var7_6:getDestroyData())
		end
	end
end

function var0_0.sortItems(arg0_7, arg1_7)
	table.sort(arg1_7, function(arg0_8, arg1_8)
		local var0_8 = arg0_8.anchoredPosition
		local var1_8 = arg1_8.anchoredPosition

		if var0_8.y > var1_8.y then
			return false
		elseif var0_8.y < var1_8.y then
			return true
		end

		if var0_8.x > var1_8.x then
			return false
		elseif var0_8.x < var1_8.x then
			return true
		end

		return false
	end)

	for iter0_7 = 1, #arg1_7 do
		arg1_7[iter0_7]:SetSiblingIndex(0)
	end
end

function var0_0.useSkill(arg0_9)
	arg0_9.charControl:useSkill()
end

function var0_0.clear(arg0_10)
	return
end

function var0_0.stop(arg0_11)
	return
end

function var0_0.resume(arg0_12)
	return
end

function var0_0.onSceneEventCall(arg0_13, arg1_13, arg2_13)
	arg0_13.charControl:onEventCall(arg1_13, arg2_13)
	arg0_13.bulletControl:onEventCall(arg1_13, arg2_13)
	arg0_13.effectControl:onEventCall(arg1_13, arg2_13)
end

function var0_0.dispose(arg0_14)
	arg0_14.charControl:dispose()
	arg0_14.bgControl:dispose()
	arg0_14.itemControl:dispose()
	arg0_14.enemyControl:dispose()
end

function var0_0.showContainer(arg0_15, arg1_15)
	setActive(arg0_15.sceneMask, arg1_15)
end

function var0_0.press(arg0_16, arg1_16, arg2_16)
	if arg1_16 == KeyCode.J and arg2_16 then
		arg0_16.charControl:ableFire()
	end
end

function var0_0.joystickActive(arg0_17, arg1_17)
	return
end

return var0_0
