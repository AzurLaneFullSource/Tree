local var0 = class("SailBoatEnemyControllua")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._bgContent = arg1
	arg0._eventCall = arg2
	arg0._content = findTF(arg0._bgContent, "scene/content")
	arg0._enemys = {}
	arg0._enemyPool = {}
	arg0._rules = {}
end

function var0.start(arg0)
	for iter0 = #arg0._enemys, 1, -1 do
		arg0:returnEnemy(table.remove(arg0._enemys, iter0))
	end

	arg0._rules = {}

	var1.SetGameEnemys(arg0._enemys)

	local var0 = var1.GetRoundData()

	if var0 then
		for iter1 = 1, #var0.enemy_rule do
			local var1 = SailBoatGameConst.enemy_rule[var0.enemy_rule[iter1]]

			if not var1 then
				print("不存在 rule id " .. var0.enemy_rule[iter1])
			end

			local var2 = 0

			table.insert(arg0._rules, {
				data = var1,
				time = var2
			})
		end
	end

	arg0._fireIndex = var1.fire_step
end

function var0.step(arg0, arg1)
	arg0._fireIndex = arg0._fireIndex - 1

	if arg0._fireIndex <= 0 then
		arg0._fireIndex = var1.fire_step

		local var0 = var1.GetGameChar()
		local var1 = var0:getPosition()
		local var2 = var1.GetGameEnemys()

		for iter0 = 1, #var2 do
			local var3 = var2[iter0]

			if var3:canFire() then
				arg0:checkEnemyFire(var0, var3)
			end
		end
	end

	local var4 = var1.GetGameItems()

	for iter1 = #arg0._enemys, 1, -1 do
		local var5 = arg0._enemys[iter1]

		var5:step(arg1)

		if var5:getRemoveFlag() then
			table.remove(arg0._enemys, iter1)
			arg0:returnEnemy(var5)
		elseif not var5:getStop() then
			for iter2, iter3 in ipairs(var4) do
				if arg0:checkEnemyCollider(var5, iter3) then
					var5:stopTarget(Vector2(0, 0))

					if var5:getConfig("boom") and var5:damage({
						num = 99999
					}) then
						arg0._eventCall(SailBoatGameEvent.DESTROY_ENEMY, var5:getDestroyData())
					end
				end
			end
		end
	end

	local var6 = var1.gameTime

	for iter4 = 1, #arg0._rules do
		local var7 = arg0._rules[iter4]
		local var8 = var7.data.create_time

		if var6 > var8[1] and var6 < var8[2] and var7.time and var7.time >= 0 then
			var7.time = var7.time - arg1

			if var7.time <= 0 then
				var7.time = math.random(1, var7.data.time[2] - var7.data.time[1]) + var7.data.time[1]

				arg0:applyRule(var7)
			end
		end
	end
end

function var0.checkEnemyFire(arg0, arg1, arg2)
	local var0 = arg1:getPosition()

	if arg1:getLife() and arg2:getLife() and not arg2:inFireCd() then
		local var1 = arg2:getPosition()
		local var2, var3 = arg2:getWeapons()
		local var4, var5 = arg2:getFirePos()
		local var6, var7 = arg2:getFireContent()
		local var8 = var0.x > var1.x and var3 or var2
		local var9 = var0.x > var1.x and var5 or var4

		var9.y = var9.y + math.random(-15, 15)

		local var10 = var0.x > var1.x and var7 or var6

		if math.sqrt(math.pow(var0.x - var1.x, 2) + math.pow(var0.y - var1.y, 2)) < arg2:getWeaponMaxDistance() then
			local var11 = math.atan2(var0.y - var1.y + math.random(-50, 50), var0.x - var1.x + math.random(-50, 50))
			local var12 = var11 * math.rad2Deg

			for iter0 = 1, #var8 do
				local var13 = var8[iter0]

				if var13:getFireAble() then
					local var14 = var13:getAngel()

					if var14 > math.abs(var12) or var14 > math.abs(180 - math.abs(var12)) then
						local var15 = var13:fire()

						if var15 then
							arg2:fire()

							local var16 = {
								pos = var9,
								move = Vector2(math.cos(var11), math.sin(var11)),
								hit = arg2:getHitGroup(),
								effect_pos = Vector2(0, 0),
								effect_content = var10
							}

							arg0._eventCall(SailBoatGameEvent.BOAT_EVENT_FIRE, {
								bullet_id = var15.bullet_id,
								weapon_data = var15,
								fire_data = var16
							})

							return
						end
					end
				end
			end
		end
	end
end

function var0.returnEnemy(arg0, arg1)
	arg1:clear()
	table.insert(arg0._enemyPool, arg1)
end

function var0.checkEnemyCollider(arg0, arg1, arg2)
	if arg2:getConfig("type") == SailBoatGameConst.item_static then
		local var0 = arg2:getPosition()
		local var1 = arg1:getPosition()

		if math.abs(var0.x - var1.x) < 500 and math.abs(var0.y - var1.y) < 500 then
			local var2, var3 = arg2:getWorldColliderData()
			local var4, var5 = arg1:getWorldColliderData()

			if var1.CheckRectCollider(var4, var2, var5, var3) then
				return true
			end
		end
	end

	return false
end

function var0.applyRule(arg0, arg1)
	local var0 = arg1.data
	local var1 = var0.enemys
	local var2 = var0.screen_pos_x
	local var3 = var0.screen_pos_y

	if not var2 or not var3 then
		print("rule id = " .. var0 .. " 异常，没有范围参数")
	end

	local var4 = var1[math.random(1, #var1)]
	local var5 = var1.GetRangePos(var2, var3)

	if not var5 then
		return
	end

	local var6 = arg0:getOrCreateEnemy(var4)

	var6:setPosition(var5)
	table.insert(arg0._enemys, var6)

	local var7 = arg1.data.target_x
	local var8 = arg1.data.target_y
	local var9 = arg1.data.target_speed

	var6:setTarget(var7, var8, var9)
	var6:start()
end

function var0.getOrCreateEnemy(arg0, arg1, arg2)
	local var0

	if #arg0._enemyPool > 0 then
		for iter0 = #arg0._enemyPool, 1, -1 do
			if not var0 and arg0._enemyPool[iter0]:getId() == arg1 then
				var0 = table.remove(arg0._enemyPool, iter0)

				break
			end
		end
	end

	if not var0 then
		if not SailBoatGameConst.game_enemy[arg1] then
			print("id = " .. arg1 .. " 的敌人不存在")
		end

		local var1 = Clone(SailBoatGameConst.game_enemy[arg1])
		local var2 = var1.GetGameEnemyTf(var1.tpl)

		var0 = SailBoatEnemy.New(var2, arg0._event)

		var0:setData(var1)
		arg0:initWeapon(var0, var1.weapons)
		var0:setContent(arg0._content)
	end

	return var0
end

function var0.initWeapon(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}

	for iter0 = 1, #arg2[1] do
		local var2 = arg2[1][iter0]
		local var3 = SailBoatGameConst.game_weapon[var2]
		local var4 = SailBoatWeapon.New(var3)

		table.insert(var0, var4)
	end

	for iter1 = 1, #arg2[2] do
		local var5 = arg2[2][iter1]
		local var6 = SailBoatGameConst.game_weapon[var5]
		local var7 = SailBoatWeapon.New(var6)

		table.insert(var1, var7)
	end

	arg1:setWeapon(var0, var1)
end

function var0.clear(arg0)
	return
end

function var0.stop(arg0)
	return
end

function var0.dispose(arg0)
	return
end

return var0
