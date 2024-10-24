local var0_0 = class("BoatAdGameScene")
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
	var5_0 = BoatAdGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")

	setActive(arg0_1.sceneMask, false)
	setActive(findTF(arg0_1._tf, "tpl"), false)

	arg0_1.sceneContent = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	local var0_1 = findTF(arg0_1.sceneContent, "scene_background/content/leftTop").anchoredPosition
	local var1_1 = findTF(arg0_1.sceneContent, "scene_background/content/leftBottom").anchoredPosition
	local var2_1 = findTF(arg0_1.sceneContent, "scene_background/content/rightTop").anchoredPosition
	local var3_1 = findTF(arg0_1.sceneContent, "scene_background/content/rightBottom").anchoredPosition

	arg0_1.testPt = findTF(arg0_1.sceneContent, "scene_background/content/testPt")

	var5_0.SetMovePoint(var0_1, var1_1, var2_1, var3_1)

	local function var4_1(arg0_2, arg1_2)
		if arg0_2 == BoatAdGameEvent.CREATE_ITEM then
			arg0_1.itemControl:createItem(arg1_2)
		elseif arg0_2 == BoatAdGameEvent.CREATE_ENEMY then
			arg0_1.enemyControl:createEnemy(arg1_2)
		elseif arg0_2 == BoatAdGameEvent.PLAYER_DEAD then
			arg0_1._event:emit(SimpleMGEvent.GAME_OVER, arg1_2)
			arg0_1:clear()
		elseif arg0_2 == BoatAdGameEvent.PLAY_AD then
			arg0_1._event:emit(BoatAdGameEvent.OPEN_AD_WINDOW)
		elseif arg0_2 == BoatAdGameEvent.ADD_SCORE then
			arg0_1._event:emit(SimpleMGEvent.ADD_SCORE, arg1_2)
		elseif arg0_2 == BoatAdGameEvent.ADD_GUARD then
			-- block empty
		elseif arg0_2 == BoatAdGameEvent.SPEED_DOWN then
			arg0_1.enemyControl:speedDown(arg1_2)
		end

		arg0_1:onSceneEventCall(arg0_2, arg1_2)
	end

	arg0_1.charControl = BoatAdCharControl.New(arg0_1.sceneContent, var4_1)
	arg0_1.createControl = BoatAdCreateControl.New(arg0_1.sceneContent, var4_1)
	arg0_1.itemControl = BoatAdItemControl.New(arg0_1.sceneContent, var4_1)
	arg0_1.bgControl = BoatAdBgControl.New(arg0_1.sceneContent, var4_1)
	arg0_1.colliderControl = BoatAdColliderControl.New(arg0_1.sceneContent, var4_1)
	arg0_1.enemyControl = BoatAdEnemyControl.New(arg0_1.sceneContent, var4_1)
end

function var0_0.start(arg0_3)
	arg0_3:showContainer(true)
	arg0_3.charControl:start()
	arg0_3.bgControl:start()
	arg0_3.itemControl:start()
	arg0_3.colliderControl:start()
	arg0_3.enemyControl:start()
	arg0_3.createControl:start()

	arg0_3.sortIndex = 10
end

function var0_0.step(arg0_4, arg1_4)
	arg0_4:checkCharBattle()
	arg0_4.charControl:step(arg1_4)
	arg0_4.bgControl:step(arg1_4)
	arg0_4.itemControl:step(arg1_4)
	arg0_4.colliderControl:step(arg1_4)
	arg0_4.enemyControl:step(arg1_4)
	arg0_4.createControl:step(arg1_4)
	arg0_4:sortSceneObject()
end

function var0_0.checkCharBattle(arg0_5)
	if var5_0.char:getBattle() then
		if arg0_5.enemyControl:getMoveSpeed() > 0 then
			arg0_5.enemyControl:setMoveSpeed(0)
		end

		if arg0_5.itemControl:getMoveSpeed() > 0 then
			arg0_5.itemControl:setMoveSpeed(0)
		end

		if arg0_5.bgControl:getMoveSpeed() > 0 then
			arg0_5.bgControl:setMoveSpeed(0)
		end
	else
		if arg0_5.enemyControl:getMoveSpeed() == 0 then
			arg0_5.enemyControl:setMoveSpeed(1)
		end

		if arg0_5.itemControl:getMoveSpeed() == 0 then
			arg0_5.itemControl:setMoveSpeed(1)
		end

		if arg0_5.bgControl:getMoveSpeed() == 0 then
			arg0_5.bgControl:setMoveSpeed(1)
		end
	end
end

function var0_0.sortSceneObject(arg0_6)
	local var0_6 = var5_0.GetGameEnemys()
	local var1_6 = var5_0.GetGameChar()
	local var2_6 = var5_0.GetGameItems()

	if not arg0_6.sortTfs or #arg0_6.sortTfs ~= #var0_6 + 1 + #var2_6 then
		arg0_6.sortTfs = {}

		for iter0_6 = 1, #var0_6 do
			table.insert(arg0_6.sortTfs, var0_6[iter0_6])
		end

		for iter1_6 = 1, #var2_6 do
			table.insert(arg0_6.sortTfs, var2_6[iter1_6])
		end

		table.insert(arg0_6.sortTfs, var1_6)
	end

	if arg0_6.sortIndex and arg0_6.sortIndex == 0 then
		arg0_6:sortItems(arg0_6.sortTfs)

		arg0_6.sortIndex = 10
	else
		arg0_6.sortIndex = arg0_6.sortIndex - 1
	end
end

function var0_0.destroyEnemy(arg0_7, arg1_7)
	arg0_7._event:emit(SimpleMGEvent.ADD_SCORE, {
		num = arg1_7.score
	})
end

function var0_0.sortItems(arg0_8, arg1_8)
	table.sort(arg1_8, function(arg0_9, arg1_9)
		local var0_9 = arg0_9:getTf().anchoredPosition
		local var1_9 = arg1_9:getTf().anchoredPosition
		local var2_9 = arg0_9:getMoveCount()
		local var3_9 = arg1_9:getMoveCount()
		local var4_9 = math.abs(var1_9.x - var0_9.x)

		if math.abs(var1_9.y - var0_9.y) > 1 then
			if var0_9.y > var1_9.y then
				return false
			elseif var0_9.y < var1_9.y then
				return true
			end
		end

		if var3_9 == 3 and var2_9 ~= 3 then
			return false
		elseif var2_9 == 3 and var3_9 ~= 3 then
			return true
		end

		if var4_9 > 1 then
			if var0_9.x < var1_9.x then
				return false
			elseif var0_9.x > var1_9.x then
				return true
			end
		end

		return false
	end)

	for iter0_8 = 1, #arg1_8 do
		arg1_8[iter0_8]:getTf():SetSiblingIndex(0)
	end
end

function var0_0.useSkill(arg0_10)
	arg0_10.charControl:useSkill()
end

function var0_0.clear(arg0_11)
	arg0_11.charControl:clear()
end

function var0_0.stop(arg0_12)
	arg0_12.charControl:stop()
	arg0_12.enemyControl:stop()
	arg0_12.createControl:stop()
	arg0_12.itemControl:stop()
	arg0_12.bgControl:stop()
end

function var0_0.resume(arg0_13)
	arg0_13.charControl:resume()
	arg0_13.enemyControl:resume()
	arg0_13.createControl:resume()
	arg0_13.itemControl:resume()
	arg0_13.bgControl:resume()
end

function var0_0.onSceneEventCall(arg0_14, arg1_14, arg2_14)
	arg0_14.charControl:onEventCall(arg1_14, arg2_14)
end

function var0_0.dispose(arg0_15)
	arg0_15.charControl:dispose()
	arg0_15.bgControl:dispose()
	arg0_15.itemControl:dispose()
	arg0_15.enemyControl:dispose()
end

function var0_0.showContainer(arg0_16, arg1_16)
	setActive(arg0_16.sceneMask, arg1_16)
end

function var0_0.press(arg0_17, arg1_17, arg2_17)
	if arg1_17 == KeyCode.J and arg2_17 then
		-- block empty
	end
end

function var0_0.joystickActive(arg0_18, arg1_18)
	return
end

return var0_0
