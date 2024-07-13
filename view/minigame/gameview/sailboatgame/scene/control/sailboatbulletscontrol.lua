local var0_0 = class("SailBoatBulletsControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._bullets = {}
	arg0_1._bulletPool = {}
	arg0_1._content = findTF(arg0_1._tf, "scene_front/content")
end

function var0_0.start(arg0_2)
	for iter0_2 = #arg0_2._bullets, 1, -1 do
		local var0_2 = table.remove(arg0_2._bullets, iter0_2)

		var0_2:clear()
		table.insert(arg0_2._bulletPool, var0_2)
	end

	arg0_2._bulletStep = var1_0.bullet_step
end

function var0_0.step(arg0_3, arg1_3)
	for iter0_3 = #arg0_3._bullets, 1, -1 do
		arg0_3._bullets[iter0_3]:step(arg1_3)
	end

	arg0_3._bulletStep = arg0_3._bulletStep - 1

	if arg0_3._bulletStep > 0 then
		return
	end

	arg0_3._bulletStep = var1_0.bullet_step

	local var0_3 = var1_0.GetGameEnemys()
	local var1_3 = var1_0.GetGameChar()
	local var2_3 = var1_3:getGroup()
	local var3_3 = 0

	for iter1_3 = #arg0_3._bullets, 1, -1 do
		local var4_3 = arg0_3._bullets[iter1_3]
		local var5_3 = var4_3:getHitGroup()
		local var6_3 = var4_3:getWorld()

		if not var4_3:getRemoveFlag() then
			for iter2_3, iter3_3 in ipairs(var0_3) do
				if iter3_3:getLife() then
					local var7_3 = iter3_3:getGroup()

					if iter3_3:getLife() then
						local var8_3, var9_3 = iter3_3:getMinMaxPosition()

						if var1_0.PointInRect2(var6_3, var8_3, var9_3) and table.contains(var5_3, var7_3) then
							var4_3:hit()

							local var10_3 = var4_3:getDamage()

							if iter3_3:damage(var10_3) then
								arg0_3._event(SailBoatGameEvent.DESTROY_ENEMY, iter3_3:getDestroyData())
							end

							return
						end
					end
				end
			end
		end

		if not var4_3:getRemoveFlag() and var1_3:getLife() and table.contains(var5_3, var2_3) then
			local var11_3, var12_3 = var1_3:getMinMaxPosition()

			if var1_0.PointInRect2(var6_3, var11_3, var12_3) then
				var4_3:hit()

				local var13_3 = var4_3:getDamage()

				var1_3:damage(var13_3)

				return
			end
		end

		if var4_3:getRemoveFlag() then
			local var14_3 = table.remove(arg0_3._bullets, iter1_3)

			var14_3:clear()
			arg0_3:returnBullet(var14_3)
		end
	end
end

function var0_0.returnBullet(arg0_4, arg1_4)
	table.insert(arg0_4._bulletPool, arg1_4)
end

function var0_0.createBullet(arg0_5, arg1_5)
	local var0_5

	if #arg0_5._bulletPool > 0 then
		var0_5 = table.remove(arg0_5._bulletPool, 1)
	end

	if not var0_5 then
		local var1_5 = var1_0.GetGameBullet()

		var0_5 = SailBoatBullet.New(var1_5, arg0_5._event)

		var0_5:setContent(arg0_5._content)
	end

	local var2_5 = SailBoatGameConst.game_bullet[arg1_5]

	var0_5:setData(var2_5)
	table.insert(arg0_5._bullets, var0_5)

	return var0_5
end

function var0_0.onEventCall(arg0_6, arg1_6, arg2_6)
	if arg1_6 == SailBoatGameEvent.BOAT_EVENT_FIRE then
		local var0_6 = arg0_6:createBullet(arg2_6.bullet_id)

		var0_6:setFireData(arg2_6.fire_data)
		var0_6:setWeapon(arg2_6.weapon_data)
		var0_6:start()
	end
end

function var0_0.dispose(arg0_7)
	return
end

function var0_0.clear(arg0_8)
	return
end

return var0_0
