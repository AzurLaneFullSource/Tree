local var0 = class("SailBoatGameScene")
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5

var0.random_scene_imgs = {
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

function var0.Ctor(arg0, arg1, arg2)
	var5 = SailBoatGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0.sceneMask = findTF(arg0._tf, "sceneMask")
	arg0.sceneContent = findTF(arg0._tf, "sceneMask/sceneContainer")

	local function var0(arg0, arg1)
		if arg0 == SailBoatGameEvent.DESTROY_ENEMY then
			arg0:destroyEnemy(arg1)
		elseif arg0 == SailBoatGameEvent.USE_ITEM then
			arg0._event:emit(SailBoatGameView.ADD_SCORE, {
				num = arg1.score
			})

			if arg1.skill then
				var5.AddSkill()
			end
		elseif arg0 == SailBoatGameEvent.PLAYER_DEAD then
			arg0._event:emit(SailBoatGameView.GAME_OVER)
		end

		arg0:onSceneEventCall(arg0, arg1)
	end

	arg0.charControl = SailBoatCharControl.New(arg0.sceneContent, var0)
	arg0.bgControl = SailBoatBgControl.New(arg0.sceneContent, var0)
	arg0.itemControl = SailBoatItemControl.New(arg0.sceneContent, var0)
	arg0.colliderControl = SailBoatColliderControl.New(arg0.sceneContent, var0)
	arg0.enemyControl = SailBoatEnemyControl.New(arg0.sceneContent, var0)
	arg0.bulletControl = SailBoatBulletsControl.New(arg0.sceneContent, var0)
	arg0.effectControl = SailBoatEffectControl.New(arg0.sceneContent, var0)
	arg0.bgRules = {}
	arg0.bgTfs = {}
	arg0.bgTfPool = {}

	for iter0 = 1, #var0.random_scene_imgs do
		local var1 = var0.random_scene_imgs[iter0]

		table.insert(arg0.bgRules, {
			time = 0,
			ruleData = var1
		})
	end
end

function var0.start(arg0)
	arg0:showContainer(true)
	arg0.charControl:start()
	arg0.bgControl:start()
	arg0.itemControl:start()
	arg0.colliderControl:start()
	arg0.enemyControl:start()
	arg0.bulletControl:start()
	arg0.effectControl:start()

	arg0.sortIndex = 10
	arg0.bgImgTpl = var5.GetGameBgTf("bgs/bg_other")

	for iter0 = #arg0.bgTfs, 1, -1 do
		local var0 = table.remove(arg0.bgTfs, iter0)

		setActive(var0, false)
		table.insert(arg0.bgTfPool, var0)
	end

	for iter1 = 1, #arg0.bgRules do
		arg0.bgRules[iter1].time = 0
	end
end

function var0.step(arg0, arg1)
	local var0
	local var1
	local var2
	local var3
	local var4
	local var5
	local var6
	local var7 = os.clock()

	arg0.charControl:step(arg1)

	local var8 = (os.clock() - var7) * 1000
	local var9 = os.clock()

	arg0.bgControl:step(arg1)

	local var10 = (os.clock() - var9) * 1000
	local var11 = os.clock()

	arg0.itemControl:step(arg1)

	local var12 = (os.clock() - var11) * 1000
	local var13 = os.clock()

	arg0.colliderControl:step(arg1)

	local var14 = (os.clock() - var13) * 1000
	local var15 = os.clock()

	arg0.enemyControl:step(arg1)

	local var16 = (os.clock() - var15) * 1000
	local var17 = os.clock()

	arg0.bulletControl:step(arg1)

	local var18 = tostring((os.clock() - var17) * 1000, 2)
	local var19 = os.clock()

	arg0.effectControl:step(arg1)

	local var20 = (os.clock() - var19) * 1000
	local var21 = os.clock()
	local var22 = var5.GetGameEnemys()
	local var23 = var5.GetGameChar()
	local var24 = var5.GetGameItems()

	if not arg0.sortTfs or #arg0.sortTfs ~= #var22 + 1 + #var24 then
		arg0.sortTfs = {}

		for iter0 = 1, #var22 do
			table.insert(arg0.sortTfs, var22[iter0]:getTf())
		end

		for iter1 = 1, #var24 do
			table.insert(arg0.sortTfs, var24[iter1]:getTf())
		end

		table.insert(arg0.sortTfs, var23:getTf())
	end

	if arg0.sortIndex and arg0.sortIndex == 0 then
		arg0:sortItems(arg0.sortTfs)

		arg0.sortIndex = 10
	else
		arg0.sortIndex = arg0.sortIndex - 1
	end

	for iter2 = 1, #arg0.bgRules do
		if arg0.bgRules[iter2].time <= 0 then
			arg0.bgRules[iter2].time = math.random(30, 45)

			local var25 = arg0.bgRules[iter2].ruleData.icon
			local var26 = var25[math.random(1, #var25)]
			local var27

			if #arg0.bgTfPool > 0 then
				var27 = table.remove(arg0.bgTfPool, 1)
			else
				var27 = tf(instantiate(arg0.bgImgTpl))

				SetParent(var27, findTF(arg0.sceneContent, arg0.bgRules[iter2].ruleData.content))
			end

			setImageSprite(findTF(var27, "img"), var5.GetBgIcon(var26), true)
			setActive(var27, true)
			table.insert(arg0.bgTfs, var27)

			var27.anchoredPosition = Vector2(math.random(-300, 300), 2000)
			var27.localEulerAngles = Vector3(0, 0, math.random(1, 360))
		end

		arg0.bgRules[iter2].time = arg0.bgRules[iter2].time - arg1
	end

	local var28 = var5.GetSceneSpeed()

	for iter3 = #arg0.bgTfs, 1, -1 do
		local var29 = arg0.bgTfs[iter3]

		if var29.anchoredPosition.y < -2000 then
			setActive(var29, false)
			table.insert(arg0.bgTfPool, var29)
			table.remove(arg0.bgTfs, iter3)
		else
			local var30 = var29.anchoredPosition

			var30.y = var30.y + var28.y
			var29.anchoredPosition = var30
		end
	end
end

function var0.destroyEnemy(arg0, arg1)
	arg0._event:emit(SailBoatGameView.ADD_SCORE, {
		num = arg1.score
	})

	if arg1.boom then
		arg0:checkBoomDamage(arg1)
	end
end

function var0.checkBoomDamage(arg0, arg1)
	local var0 = arg1.boom
	local var1 = arg1.position
	local var2 = arg1.range
	local var3 = var5.GetGameChar()
	local var4 = var5.GetGameEnemys()
	local var5 = var3:getPosition()
	local var6 = var3:getConfig("range")

	if math.abs(var1.x - var5.x) < var2.x + var6.x / 2 and math.abs(var1.y - var5.y) < var2.y + var6.y / 2 then
		var3:damage({
			num = var0,
			position = var1
		})
	end

	for iter0 = 1, #var4 do
		local var7 = var4[iter0]
		local var8 = var7:getPosition()
		local var9 = var7:getConfig("range")

		if math.abs(var1.x - var8.x) < var2.x + var8.x / 2 and math.abs(var1.y - var8.y) < var2.y + var8.y / 2 and var7:damage({
			num = var0,
			position = var1
		}) then
			arg0:destroyEnemy(var7:getDestroyData())
		end
	end
end

function var0.sortItems(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		local var0 = arg0.anchoredPosition
		local var1 = arg1.anchoredPosition

		if var0.y > var1.y then
			return false
		elseif var0.y < var1.y then
			return true
		end

		if var0.x > var1.x then
			return false
		elseif var0.x < var1.x then
			return true
		end

		return false
	end)

	for iter0 = 1, #arg1 do
		arg1[iter0]:SetSiblingIndex(0)
	end
end

function var0.useSkill(arg0)
	arg0.charControl:useSkill()
end

function var0.clear(arg0)
	return
end

function var0.stop(arg0)
	return
end

function var0.resume(arg0)
	return
end

function var0.onSceneEventCall(arg0, arg1, arg2)
	arg0.charControl:onEventCall(arg1, arg2)
	arg0.bulletControl:onEventCall(arg1, arg2)
	arg0.effectControl:onEventCall(arg1, arg2)
end

function var0.dispose(arg0)
	arg0.charControl:dispose()
	arg0.bgControl:dispose()
	arg0.itemControl:dispose()
	arg0.enemyControl:dispose()
end

function var0.showContainer(arg0, arg1)
	setActive(arg0.sceneMask, arg1)
end

function var0.press(arg0, arg1, arg2)
	if arg1 == KeyCode.J and arg2 then
		arg0.charControl:ableFire()
	end
end

function var0.joystickActive(arg0, arg1)
	return
end

return var0
