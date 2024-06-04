local var0 = class("SailBoatBulletsControl")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0._bullets = {}
	arg0._bulletPool = {}
	arg0._content = findTF(arg0._tf, "scene_front/content")
end

function var0.start(arg0)
	for iter0 = #arg0._bullets, 1, -1 do
		local var0 = table.remove(arg0._bullets, iter0)

		var0:clear()
		table.insert(arg0._bulletPool, var0)
	end

	arg0._bulletStep = var1.bullet_step
end

function var0.step(arg0, arg1)
	for iter0 = #arg0._bullets, 1, -1 do
		arg0._bullets[iter0]:step(arg1)
	end

	arg0._bulletStep = arg0._bulletStep - 1

	if arg0._bulletStep > 0 then
		return
	end

	arg0._bulletStep = var1.bullet_step

	local var0 = var1.GetGameEnemys()
	local var1 = var1.GetGameChar()
	local var2 = var1:getGroup()
	local var3 = 0

	for iter1 = #arg0._bullets, 1, -1 do
		local var4 = arg0._bullets[iter1]
		local var5 = var4:getHitGroup()
		local var6 = var4:getWorld()

		if not var4:getRemoveFlag() then
			for iter2, iter3 in ipairs(var0) do
				if iter3:getLife() then
					local var7 = iter3:getGroup()

					if iter3:getLife() then
						local var8, var9 = iter3:getMinMaxPosition()

						if var1.PointInRect2(var6, var8, var9) and table.contains(var5, var7) then
							var4:hit()

							local var10 = var4:getDamage()

							if iter3:damage(var10) then
								arg0._event(SailBoatGameEvent.DESTROY_ENEMY, iter3:getDestroyData())
							end

							return
						end
					end
				end
			end
		end

		if not var4:getRemoveFlag() and var1:getLife() and table.contains(var5, var2) then
			local var11, var12 = var1:getMinMaxPosition()

			if var1.PointInRect2(var6, var11, var12) then
				var4:hit()

				local var13 = var4:getDamage()

				var1:damage(var13)

				return
			end
		end

		if var4:getRemoveFlag() then
			local var14 = table.remove(arg0._bullets, iter1)

			var14:clear()
			arg0:returnBullet(var14)
		end
	end
end

function var0.returnBullet(arg0, arg1)
	table.insert(arg0._bulletPool, arg1)
end

function var0.createBullet(arg0, arg1)
	local var0

	if #arg0._bulletPool > 0 then
		var0 = table.remove(arg0._bulletPool, 1)
	end

	if not var0 then
		local var1 = var1.GetGameBullet()

		var0 = SailBoatBullet.New(var1, arg0._event)

		var0:setContent(arg0._content)
	end

	local var2 = SailBoatGameConst.game_bullet[arg1]

	var0:setData(var2)
	table.insert(arg0._bullets, var0)

	return var0
end

function var0.onEventCall(arg0, arg1, arg2)
	if arg1 == SailBoatGameEvent.BOAT_EVENT_FIRE then
		local var0 = arg0:createBullet(arg2.bullet_id)

		var0:setFireData(arg2.fire_data)
		var0:setWeapon(arg2.weapon_data)
		var0:start()
	end
end

function var0.dispose(arg0)
	return
end

function var0.clear(arg0)
	return
end

return var0
