local var0_0 = class("SailBoatEnemyControllua")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._bgContent = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._content = findTF(arg0_1._bgContent, "scene/content")
	arg0_1._enemys = {}
	arg0_1._enemyPool = {}
	arg0_1._rules = {}
end

function var0_0.start(arg0_2)
	for iter0_2 = #arg0_2._enemys, 1, -1 do
		arg0_2:returnEnemy(table.remove(arg0_2._enemys, iter0_2))
	end

	arg0_2._rules = {}

	var1_0.SetGameEnemys(arg0_2._enemys)

	local var0_2 = var1_0.GetRoundData()

	if var0_2 then
		for iter1_2 = 1, #var0_2.enemy_rule do
			local var1_2 = SailBoatGameConst.enemy_rule[var0_2.enemy_rule[iter1_2]]

			if not var1_2 then
				print("不存在 rule id " .. var0_2.enemy_rule[iter1_2])
			end

			local var2_2 = 0

			table.insert(arg0_2._rules, {
				data = var1_2,
				time = var2_2
			})
		end
	end

	arg0_2._fireIndex = var1_0.fire_step
end

function var0_0.step(arg0_3, arg1_3)
	arg0_3._fireIndex = arg0_3._fireIndex - 1

	if arg0_3._fireIndex <= 0 then
		arg0_3._fireIndex = var1_0.fire_step

		local var0_3 = var1_0.GetGameChar()
		local var1_3 = var0_3:getPosition()
		local var2_3 = var1_0.GetGameEnemys()

		for iter0_3 = 1, #var2_3 do
			local var3_3 = var2_3[iter0_3]

			if var3_3:canFire() then
				arg0_3:checkEnemyFire(var0_3, var3_3)
			end
		end
	end

	local var4_3 = var1_0.GetGameItems()

	for iter1_3 = #arg0_3._enemys, 1, -1 do
		local var5_3 = arg0_3._enemys[iter1_3]

		var5_3:step(arg1_3)

		if var5_3:getRemoveFlag() then
			table.remove(arg0_3._enemys, iter1_3)
			arg0_3:returnEnemy(var5_3)
		elseif not var5_3:getStop() then
			for iter2_3, iter3_3 in ipairs(var4_3) do
				if arg0_3:checkEnemyCollider(var5_3, iter3_3) then
					var5_3:stopTarget(Vector2(0, 0))

					if var5_3:getConfig("boom") and var5_3:damage({
						num = 99999
					}) then
						arg0_3._eventCall(SailBoatGameEvent.DESTROY_ENEMY, var5_3:getDestroyData())
					end
				end
			end
		end
	end

	local var6_3 = var1_0.gameTime

	for iter4_3 = 1, #arg0_3._rules do
		local var7_3 = arg0_3._rules[iter4_3]
		local var8_3 = var7_3.data.create_time

		if var6_3 > var8_3[1] and var6_3 < var8_3[2] and var7_3.time and var7_3.time >= 0 then
			var7_3.time = var7_3.time - arg1_3

			if var7_3.time <= 0 then
				var7_3.time = math.random(1, var7_3.data.time[2] - var7_3.data.time[1]) + var7_3.data.time[1]

				arg0_3:applyRule(var7_3)
			end
		end
	end
end

function var0_0.checkEnemyFire(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:getPosition()

	if arg1_4:getLife() and arg2_4:getLife() and not arg2_4:inFireCd() then
		local var1_4 = arg2_4:getPosition()
		local var2_4, var3_4 = arg2_4:getWeapons()
		local var4_4, var5_4 = arg2_4:getFirePos()
		local var6_4, var7_4 = arg2_4:getFireContent()
		local var8_4 = var0_4.x > var1_4.x and var3_4 or var2_4
		local var9_4 = var0_4.x > var1_4.x and var5_4 or var4_4

		var9_4.y = var9_4.y + math.random(-15, 15)

		local var10_4 = var0_4.x > var1_4.x and var7_4 or var6_4

		if math.sqrt(math.pow(var0_4.x - var1_4.x, 2) + math.pow(var0_4.y - var1_4.y, 2)) < arg2_4:getWeaponMaxDistance() then
			local var11_4 = math.atan2(var0_4.y - var1_4.y + math.random(-50, 50), var0_4.x - var1_4.x + math.random(-50, 50))
			local var12_4 = var11_4 * math.rad2Deg

			for iter0_4 = 1, #var8_4 do
				local var13_4 = var8_4[iter0_4]

				if var13_4:getFireAble() then
					local var14_4 = var13_4:getAngel()

					if var14_4 > math.abs(var12_4) or var14_4 > math.abs(180 - math.abs(var12_4)) then
						local var15_4 = var13_4:fire()

						if var15_4 then
							arg2_4:fire()

							local var16_4 = {
								pos = var9_4,
								move = Vector2(math.cos(var11_4), math.sin(var11_4)),
								hit = arg2_4:getHitGroup(),
								effect_pos = Vector2(0, 0),
								effect_content = var10_4
							}

							arg0_4._eventCall(SailBoatGameEvent.BOAT_EVENT_FIRE, {
								bullet_id = var15_4.bullet_id,
								weapon_data = var15_4,
								fire_data = var16_4
							})

							return
						end
					end
				end
			end
		end
	end
end

function var0_0.returnEnemy(arg0_5, arg1_5)
	arg1_5:clear()
	table.insert(arg0_5._enemyPool, arg1_5)
end

function var0_0.checkEnemyCollider(arg0_6, arg1_6, arg2_6)
	if arg2_6:getConfig("type") == SailBoatGameConst.item_static then
		local var0_6 = arg2_6:getPosition()
		local var1_6 = arg1_6:getPosition()

		if math.abs(var0_6.x - var1_6.x) < 500 and math.abs(var0_6.y - var1_6.y) < 500 then
			local var2_6, var3_6 = arg2_6:getWorldColliderData()
			local var4_6, var5_6 = arg1_6:getWorldColliderData()

			if var1_0.CheckRectCollider(var4_6, var2_6, var5_6, var3_6) then
				return true
			end
		end
	end

	return false
end

function var0_0.applyRule(arg0_7, arg1_7)
	local var0_7 = arg1_7.data
	local var1_7 = var0_7.enemys
	local var2_7 = var0_7.screen_pos_x
	local var3_7 = var0_7.screen_pos_y

	if not var2_7 or not var3_7 then
		print("rule id = " .. var0_7 .. " 异常，没有范围参数")
	end

	local var4_7 = var1_7[math.random(1, #var1_7)]
	local var5_7 = var1_0.GetRangePos(var2_7, var3_7)

	if not var5_7 then
		return
	end

	local var6_7 = arg0_7:getOrCreateEnemy(var4_7)

	var6_7:setPosition(var5_7)
	table.insert(arg0_7._enemys, var6_7)

	local var7_7 = arg1_7.data.target_x
	local var8_7 = arg1_7.data.target_y
	local var9_7 = arg1_7.data.target_speed

	var6_7:setTarget(var7_7, var8_7, var9_7)
	var6_7:start()
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
		if not SailBoatGameConst.game_enemy[arg1_8] then
			print("id = " .. arg1_8 .. " 的敌人不存在")
		end

		local var1_8 = Clone(SailBoatGameConst.game_enemy[arg1_8])
		local var2_8 = var1_0.GetGameEnemyTf(var1_8.tpl)

		var0_8 = SailBoatEnemy.New(var2_8, arg0_8._event)

		var0_8:setData(var1_8)
		arg0_8:initWeapon(var0_8, var1_8.weapons)
		var0_8:setContent(arg0_8._content)
	end

	return var0_8
end

function var0_0.initWeapon(arg0_9, arg1_9, arg2_9)
	local var0_9 = {}
	local var1_9 = {}

	for iter0_9 = 1, #arg2_9[1] do
		local var2_9 = arg2_9[1][iter0_9]
		local var3_9 = SailBoatGameConst.game_weapon[var2_9]
		local var4_9 = SailBoatWeapon.New(var3_9)

		table.insert(var0_9, var4_9)
	end

	for iter1_9 = 1, #arg2_9[2] do
		local var5_9 = arg2_9[2][iter1_9]
		local var6_9 = SailBoatGameConst.game_weapon[var5_9]
		local var7_9 = SailBoatWeapon.New(var6_9)

		table.insert(var1_9, var7_9)
	end

	arg1_9:setWeapon(var0_9, var1_9)
end

function var0_0.clear(arg0_10)
	return
end

function var0_0.stop(arg0_11)
	return
end

function var0_0.dispose(arg0_12)
	return
end

return var0_0
