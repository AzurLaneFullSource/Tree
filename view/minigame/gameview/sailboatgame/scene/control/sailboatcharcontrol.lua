local var0_0 = class("SailBoatCharControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._bgContent = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._charContent = findTF(arg0_1._bgContent, "scene/content")

	local var0_1 = SailBoatGameConst.game_char[var1_0.char_id]
	local var1_1 = var1_0.GetGameCharTf(var0_1.tpl)

	arg0_1._char = SailBoatChar.New(var1_1, arg0_1._eventCall)

	arg0_1._char:setData(var0_1)
	arg0_1._char:setContent(arg0_1._charContent, var1_0.char_start_pos)
end

function var0_0.start(arg0_2)
	var1_0.SetGameChar(arg0_2._char)

	arg0_2._fireIndex = var1_0.fire_step

	local var0_2 = {}
	local var1_2 = {}

	arg0_2._char:clearEquipData()

	for iter0_2 = 1, #var1_0.equips do
		if var1_0.equips[iter0_2] and var1_0.equips[iter0_2] > 0 then
			local var2_2 = SailBoatGameConst.equip_data[var1_0.equips[iter0_2]]

			arg0_2._char:setEquipData(var2_2)

			if var2_2.weapon_id and var2_2.weapon_id ~= 0 then
				local var3_2 = SailBoatGameConst.game_weapon[var2_2.weapon_id]
				local var4_2 = SailBoatWeapon.New(var3_2)
				local var5_2 = SailBoatWeapon.New(var3_2)

				table.insert(var0_2, var4_2)
				table.insert(var1_2, var5_2)
			end
		end
	end

	local var6_2 = var1_0.char_weapons

	for iter1_2 = 1, #var6_2[1] do
		local var7_2 = var6_2[1][iter1_2]
		local var8_2 = SailBoatGameConst.game_weapon[var7_2]
		local var9_2 = SailBoatWeapon.New(Clone(var8_2))

		table.insert(var0_2, var9_2)
	end

	for iter2_2 = 1, #var6_2[2] do
		local var10_2 = var6_2[2][iter2_2]
		local var11_2 = SailBoatGameConst.game_weapon[var10_2]
		local var12_2 = SailBoatWeapon.New(Clone(var11_2))

		table.insert(var1_2, var12_2)
	end

	arg0_2._char:setWeapon(var0_2, var1_2)
	arg0_2._char:start()

	arg0_2._ableFire = true
end

function var0_0.step(arg0_3, arg1_3)
	local var0_3 = var1_0.joyStickData
	local var1_3 = 0
	local var2_3 = 0
	local var3_3 = 0
	local var4_3 = 0

	if var0_3 and var0_3.active then
		var1_3, var2_3 = var0_3.x, var0_3.y
		var3_3, var4_3 = var0_3.directX, var0_3.directY

		if math.abs(var3_3) < 0.1 then
			var3_3 = 0
		end

		if math.abs(var4_3) < 0.1 then
			var4_3 = 0
		end
	end

	if arg0_3:getCharNextTouchFlag(var1_3, var2_3, var3_3, var4_3) then
		var1_3, var2_3 = 0, 0
	end

	arg0_3._char:changeDirect(var1_3, var2_3)
	arg0_3._char:step(arg1_3)

	arg0_3._fireIndex = arg0_3._fireIndex - 1

	if arg0_3._fireIndex <= 0 then
		arg0_3._fireIndex = var1_0.fire_step
	end

	if arg0_3._ableFire then
		local var5_3 = arg0_3._char:getPosition()
		local var6_3 = var1_0.GetGameEnemys()

		for iter0_3 = 1, #var6_3 do
			local var7_3 = var6_3[iter0_3]

			arg0_3:checkCharEnemyFire(arg0_3._char, var7_3)
		end
	end
end

function var0_0.checkCharEnemyFire(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:getPosition()
	local var1_4 = arg1_4:getWeaponMaxDistance()
	local var2_4 = arg2_4:getPosition()
	local var3_4 = var2_4.x > var0_4.x and 1 or -1

	if arg1_4:getLife() and arg2_4:getLife() and not arg1_4:inFireCd(var3_4) then
		local var4_4, var5_4 = arg0_4._char:getWeapons()
		local var6_4, var7_4 = arg0_4._char:getFirePos()
		local var8_4, var9_4 = arg0_4._char:getFireContent()
		local var10_4 = var2_4.x > var0_4.x and var5_4 or var4_4
		local var11_4 = var2_4.x > var0_4.x and var7_4 or var6_4

		var11_4.y = var11_4.y + math.random(-10, 10)

		local var12_4 = var2_4.x > var0_4.x and var9_4 or var8_4

		if math.sqrt(math.pow(var2_4.x - var0_4.x, 2) + math.pow(var2_4.y - var0_4.y, 2)) < arg0_4._char:getWeaponMaxDistance() then
			local var13_4 = math.atan2(var2_4.y - var0_4.y + math.random(-20, 20), var2_4.x - var0_4.x + math.random(-20, 20))
			local var14_4 = var13_4 * math.rad2Deg

			for iter0_4 = 1, #var10_4 do
				local var15_4 = var10_4[iter0_4]

				if var15_4:getFireAble() then
					local var16_4 = var15_4:getAngel()
					local var17_4 = false

					if var16_4 > math.abs(var14_4) and var3_4 == 1 then
						var17_4 = true
					elseif var16_4 > math.abs(180 - math.abs(var14_4)) and var3_4 == -1 then
						var17_4 = true
					end

					if var17_4 then
						local var18_4 = var15_4:fire()

						if var18_4 then
							arg1_4:fire(var3_4)
							pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_FIRE)

							local var19_4 = {
								pos = var11_4,
								move = Vector2(math.cos(var13_4), math.sin(var13_4)),
								hit = arg0_4._char:getHitGroup(),
								effect_pos = Vector2(0, 0),
								effect_content = var12_4
							}

							arg0_4._eventCall(SailBoatGameEvent.BOAT_EVENT_FIRE, {
								bullet_id = var18_4.bullet_id,
								weapon_data = var18_4,
								fire_data = var19_4
							})

							return
						end
					end
				end
			end
		end
	elseif not arg1_4:inFireCd(var3_4) then
		-- block empty
	end
end

function var0_0.getCharNextTouchFlag(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = arg0_5._char:getNextPosition(arg1_5, arg2_5)
	local var1_5 = arg0_5._char:getBoundData()
	local var2_5 = arg0_5._char:getColliderMinPosition()
	local var3_5 = Vector2(0, 0)

	var3_5.x = var0_5.x + var2_5.x
	var3_5.y = var0_5.y + var2_5.y

	local var4_5 = var1_0.GetGameItems()

	for iter0_5 = 1, #var4_5 do
		local var5_5 = var4_5[iter0_5]

		if var5_5:getConfig("type") == SailBoatGameConst.item_static then
			local var6_5 = var5_5:getPosition()

			if math.abs(var6_5.x - var0_5.x) < 500 and math.abs(var6_5.y - var0_5.y) < 500 then
				local var7_5, var8_5 = var5_5:getColliderData()

				if not arg0_5:checkLeave(arg3_5, arg4_5, var0_5, var6_5) and var1_0.CheckRectCollider(var3_5, var7_5, var1_5, var8_5) then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.checkLeave(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6
	local var1_6
	local var2_6 = false
	local var3_6
	local var4_6

	if arg1_6 ~= 0 then
		var3_6 = arg3_6.x > arg4_6.x and arg1_6 == 1 and true or arg3_6.x <= arg4_6.x and arg1_6 == -1 and true or false
	end

	if arg2_6 ~= 0 then
		var4_6 = arg3_6.y > arg4_6.y and arg2_6 == 1 and true or arg3_6.y <= arg4_6.y and arg2_6 == -1 and true or false
	end

	if arg1_6 ~= 0 and arg2_6 ~= 0 then
		-- block empty
	elseif arg1_6 ~= 0 and arg2_6 == 0 then
		var2_6 = var3_6
	elseif arg1_6 == 0 and arg2_6 ~= 0 then
		var2_6 = var4_6
	end

	return var2_6
end

function var0_0.ableFire(arg0_7)
	return
end

function var0_0.clear(arg0_8)
	return
end

function var0_0.stop(arg0_9)
	return
end

function var0_0.dispose(arg0_10)
	return
end

function var0_0.useSkill(arg0_11)
	arg0_11._char:useSkill()
end

function var0_0.onEventCall(arg0_12, arg1_12, arg2_12)
	if arg1_12 == SailBoatGameEvent.PLAYER_EVENT_DAMAGE then
		arg0_12._char:damage(arg2_12)
	elseif arg1_12 == SailBoatGameEvent.USE_ITEM then
		local var0_12 = arg2_12.hp

		arg0_12._char:addHp(var0_12)
	end
end

return var0_0
