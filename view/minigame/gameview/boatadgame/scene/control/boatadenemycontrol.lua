local var0_0 = class("BoatAdEnemyControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	arg0_1._bgContent = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._content = findTF(arg0_1._bgContent, "scene/content")
	arg0_1._enemys = {}
	arg0_1._enemyPool = {}
end

function var0_0.start(arg0_2)
	for iter0_2 = #arg0_2._enemys, 1, -1 do
		arg0_2:returnEnemy(table.remove(arg0_2._enemys, iter0_2))
	end

	var1_0.SetGameEnemys(arg0_2._enemys)

	arg0_2._speedDownTime = 0
	arg0_2._moveSpeed = 1
end

function var0_0.step(arg0_3, arg1_3)
	local var0_3 = var1_0.GetGameItems()

	for iter0_3 = #arg0_3._enemys, 1, -1 do
		local var1_3 = arg0_3._enemys[iter0_3]

		var1_3:step(arg1_3)

		if var1_3:getRemoveFlag() then
			if var1_3:getHp() <= 0 then
				arg0_3._eventCall(BoatAdGameEvent.ADD_SCORE, var1_3:getConfig("score"))

				if var1_3:getBoss() and not var1_0.isEndLessRound then
					arg0_3._eventCall(BoatAdGameEvent.PLAYER_DEAD, true)
				end
			end

			table.remove(arg0_3._enemys, iter0_3)
			arg0_3:returnEnemy(var1_3)
		end

		if not var1_3:getRemoveFlag() and var1_3:getConfig("boss") and not var1_3:getBattle() then
			local var2_3 = var1_0.char:getPosition()
			local var3_3, var4_3 = var1_3:getRelaPositionX()

			if var4_3 - var2_3.y < 600 and math.abs(var3_3 - var2_3.x) > 10 then
				local var5_3 = var1_3:getScale()
				local var6_3 = (var3_3 > var2_3.x and -1 or 1) * 700 * arg1_3 * var5_3

				var1_3:bossFocus(var6_3)
			end
		end
	end

	if arg0_3._moveSpeed ~= 0 and arg0_3._speedDownTime > 0 then
		arg0_3._speedDownTime = arg0_3._speedDownTime - arg1_3

		if arg0_3._speedDownTime <= 0 then
			arg0_3._speedDownTime = 0

			for iter1_3 = 1, #arg0_3._enemys do
				arg0_3._enemys[iter1_3]:speedDown(false)
			end
		end
	end
end

function var0_0.setMoveSpeed(arg0_4, arg1_4)
	arg0_4._moveSpeed = arg1_4

	for iter0_4 = 1, #arg0_4._enemys do
		arg0_4._enemys[iter0_4]:setSpeed(arg1_4)
	end
end

function var0_0.getMoveSpeed(arg0_5)
	return arg0_5._moveSpeed
end

function var0_0.returnEnemy(arg0_6, arg1_6)
	arg1_6:clear()
	table.insert(arg0_6._enemyPool, arg1_6)
end

function var0_0.createEnemy(arg0_7, arg1_7)
	local var0_7 = arg1_7.id
	local var1_7 = arg1_7.move_count
	local var2_7 = arg1_7.round
	local var3_7 = arg0_7:getOrCreateEnemy(var0_7)
	local var4_7 = arg1_7.line

	var3_7:start()
	var3_7:setMoveCount(var1_7, var4_7)

	if arg0_7._speedDownTime > 0 then
		var3_7:speedDown(true)
	end

	table.insert(arg0_7._enemys, var3_7)
end

function var0_0.getOrCreateEnemy(arg0_8, arg1_8, arg2_8)
	local var0_8

	if #arg0_8._enemyPool > 0 then
		for iter0_8 = #arg0_8._enemyPool, 1, -1 do
			if not var0_8 and arg0_8._enemyPool[iter0_8]:getId() == arg1_8 then
				var0_8 = table.remove(arg0_8._enemyPool, iter0_8)

				break
			end
		end
	end

	if not var0_8 then
		if not BoatAdGameConst.game_enemy[arg1_8] then
			print("id = " .. arg1_8 .. " 的敌人不存在")
		end

		local var1_8 = Clone(BoatAdGameConst.game_enemy[arg1_8])
		local var2_8 = var1_0.GetGameTplTf(var1_8.tpl)

		var0_8 = BoatAdEnemy.New(var2_8, arg0_8._event)

		var0_8:setData(var1_8)
		var0_8:setContent(arg0_8._content)
	end

	return var0_8
end

function var0_0.speedDown(arg0_9, arg1_9)
	if arg1_9 and arg1_9 > 0 then
		arg0_9._speedDownTime = arg1_9

		for iter0_9 = 1, #arg0_9._enemys do
			arg0_9._enemys[iter0_9]:speedDown(true)
		end
	end
end

function var0_0.clear(arg0_10)
	return
end

function var0_0.stop(arg0_11)
	arg0_11.lastMoveSpeed = arg0_11._moveSpeed or 1

	arg0_11:setMoveSpeed(0)
end

function var0_0.resume(arg0_12)
	arg0_12:setMoveSpeed(arg0_12.lastMoveSpeed)
end

function var0_0.dispose(arg0_13)
	return
end

return var0_0
