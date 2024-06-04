local var0 = class("SailBoatCharControl")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._bgContent = arg1
	arg0._eventCall = arg2
	arg0._charContent = findTF(arg0._bgContent, "scene/content")

	local var0 = SailBoatGameConst.game_char[var1.char_id]
	local var1 = var1.GetGameCharTf(var0.tpl)

	arg0._char = SailBoatChar.New(var1, arg0._eventCall)

	arg0._char:setData(var0)
	arg0._char:setContent(arg0._charContent, var1.char_start_pos)
end

function var0.start(arg0)
	var1.SetGameChar(arg0._char)

	arg0._fireIndex = var1.fire_step

	local var0 = {}
	local var1 = {}

	arg0._char:clearEquipData()

	for iter0 = 1, #var1.equips do
		if var1.equips[iter0] and var1.equips[iter0] > 0 then
			local var2 = SailBoatGameConst.equip_data[var1.equips[iter0]]

			arg0._char:setEquipData(var2)

			if var2.weapon_id and var2.weapon_id ~= 0 then
				local var3 = SailBoatGameConst.game_weapon[var2.weapon_id]
				local var4 = SailBoatWeapon.New(var3)
				local var5 = SailBoatWeapon.New(var3)

				table.insert(var0, var4)
				table.insert(var1, var5)
			end
		end
	end

	local var6 = var1.char_weapons

	for iter1 = 1, #var6[1] do
		local var7 = var6[1][iter1]
		local var8 = SailBoatGameConst.game_weapon[var7]
		local var9 = SailBoatWeapon.New(Clone(var8))

		table.insert(var0, var9)
	end

	for iter2 = 1, #var6[2] do
		local var10 = var6[2][iter2]
		local var11 = SailBoatGameConst.game_weapon[var10]
		local var12 = SailBoatWeapon.New(Clone(var11))

		table.insert(var1, var12)
	end

	arg0._char:setWeapon(var0, var1)
	arg0._char:start()

	arg0._ableFire = true
end

function var0.step(arg0, arg1)
	local var0 = var1.joyStickData
	local var1 = 0
	local var2 = 0
	local var3 = 0
	local var4 = 0

	if var0 and var0.active then
		var1, var2 = var0.x, var0.y
		var3, var4 = var0.directX, var0.directY

		if math.abs(var3) < 0.1 then
			var3 = 0
		end

		if math.abs(var4) < 0.1 then
			var4 = 0
		end
	end

	if arg0:getCharNextTouchFlag(var1, var2, var3, var4) then
		var1, var2 = 0, 0
	end

	arg0._char:changeDirect(var1, var2)
	arg0._char:step(arg1)

	arg0._fireIndex = arg0._fireIndex - 1

	if arg0._fireIndex <= 0 then
		arg0._fireIndex = var1.fire_step
	end

	if arg0._ableFire then
		local var5 = arg0._char:getPosition()
		local var6 = var1.GetGameEnemys()

		for iter0 = 1, #var6 do
			local var7 = var6[iter0]

			arg0:checkCharEnemyFire(arg0._char, var7)
		end
	end
end

function var0.checkCharEnemyFire(arg0, arg1, arg2)
	local var0 = arg1:getPosition()
	local var1 = arg1:getWeaponMaxDistance()
	local var2 = arg2:getPosition()
	local var3 = var2.x > var0.x and 1 or -1

	if arg1:getLife() and arg2:getLife() and not arg1:inFireCd(var3) then
		local var4, var5 = arg0._char:getWeapons()
		local var6, var7 = arg0._char:getFirePos()
		local var8, var9 = arg0._char:getFireContent()
		local var10 = var2.x > var0.x and var5 or var4
		local var11 = var2.x > var0.x and var7 or var6

		var11.y = var11.y + math.random(-10, 10)

		local var12 = var2.x > var0.x and var9 or var8

		if math.sqrt(math.pow(var2.x - var0.x, 2) + math.pow(var2.y - var0.y, 2)) < arg0._char:getWeaponMaxDistance() then
			local var13 = math.atan2(var2.y - var0.y + math.random(-20, 20), var2.x - var0.x + math.random(-20, 20))
			local var14 = var13 * math.rad2Deg

			for iter0 = 1, #var10 do
				local var15 = var10[iter0]

				if var15:getFireAble() then
					local var16 = var15:getAngel()
					local var17 = false

					if var16 > math.abs(var14) and var3 == 1 then
						var17 = true
					elseif var16 > math.abs(180 - math.abs(var14)) and var3 == -1 then
						var17 = true
					end

					if var17 then
						local var18 = var15:fire()

						if var18 then
							arg1:fire(var3)
							pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1.SFX_SOUND_FIRE)

							local var19 = {
								pos = var11,
								move = Vector2(math.cos(var13), math.sin(var13)),
								hit = arg0._char:getHitGroup(),
								effect_pos = Vector2(0, 0),
								effect_content = var12
							}

							arg0._eventCall(SailBoatGameEvent.BOAT_EVENT_FIRE, {
								bullet_id = var18.bullet_id,
								weapon_data = var18,
								fire_data = var19
							})

							return
						end
					end
				end
			end
		end
	elseif not arg1:inFireCd(var3) then
		-- block empty
	end
end

function var0.getCharNextTouchFlag(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0._char:getNextPosition(arg1, arg2)
	local var1 = arg0._char:getBoundData()
	local var2 = arg0._char:getColliderMinPosition()
	local var3 = Vector2(0, 0)

	var3.x = var0.x + var2.x
	var3.y = var0.y + var2.y

	local var4 = var1.GetGameItems()

	for iter0 = 1, #var4 do
		local var5 = var4[iter0]

		if var5:getConfig("type") == SailBoatGameConst.item_static then
			local var6 = var5:getPosition()

			if math.abs(var6.x - var0.x) < 500 and math.abs(var6.y - var0.y) < 500 then
				local var7, var8 = var5:getColliderData()

				if not arg0:checkLeave(arg3, arg4, var0, var6) and var1.CheckRectCollider(var3, var7, var1, var8) then
					return true
				end
			end
		end
	end

	return false
end

function var0.checkLeave(arg0, arg1, arg2, arg3, arg4)
	local var0
	local var1
	local var2 = false
	local var3
	local var4

	if arg1 ~= 0 then
		var3 = arg3.x > arg4.x and arg1 == 1 and true or arg3.x <= arg4.x and arg1 == -1 and true or false
	end

	if arg2 ~= 0 then
		var4 = arg3.y > arg4.y and arg2 == 1 and true or arg3.y <= arg4.y and arg2 == -1 and true or false
	end

	if arg1 ~= 0 and arg2 ~= 0 then
		-- block empty
	elseif arg1 ~= 0 and arg2 == 0 then
		var2 = var3
	elseif arg1 == 0 and arg2 ~= 0 then
		var2 = var4
	end

	return var2
end

function var0.ableFire(arg0)
	return
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

function var0.useSkill(arg0)
	arg0._char:useSkill()
end

function var0.onEventCall(arg0, arg1, arg2)
	if arg1 == SailBoatGameEvent.PLAYER_EVENT_DAMAGE then
		arg0._char:damage(arg2)
	elseif arg1 == SailBoatGameEvent.USE_ITEM then
		local var0 = arg2.hp

		arg0._char:addHp(var0)
	end
end

return var0
