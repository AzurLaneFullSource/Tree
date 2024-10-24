local var0_0 = class("BoatAdColliderControl")
local var1_0
local var2_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	var2_0 = BoatAdGameConst
	arg0_1._tf = arg1_1
	arg0_1._eventCall = arg2_1
end

function var0_0.start(arg0_2)
	arg0_2._itemMoveSpeed = var1_0.item_move_speed
end

function var0_0.step(arg0_3, arg1_3)
	local var0_3 = var1_0.GetGameChar()
	local var1_3 = var1_0.GetGameItems()
	local var2_3 = var1_0.GetGameEnemys()
	local var3_3, var4_3 = var0_3:getWorldColliderData()
	local var5_3 = var0_3:getPosition()
	local var6_3 = var0_3:getMoveCount()
	local var7_3 = var0_3:getHp()
	local var8_3 = var0_3:getLine()

	for iter0_3 = 1, #var1_3 do
		local var9_3 = var1_3[iter0_3]
		local var10_3, var11_3 = var9_3:getWorldColliderData()
		local var12_3 = var9_3:getPosition()
		local var13_3 = var9_3:getMoveCount()
		local var14_3 = var9_3:getBuff()
		local var15_3 = var9_3:getLine()
		local var16_3 = var9_3:getConfig("ad")
		local var17_3 = var9_3:getConfig("guard")
		local var18_3 = var9_3:getConfig("speed_down")
		local var19_3 = false

		if not var9_3:getTouchFlag() and var12_3.y > var5_3.y and not var19_3 then
			if not var14_3 then
				if var1_0.CheckRectCollider(var3_3, var10_3, var4_3, var11_3) then
					var19_3 = true
				end
			elseif var14_3 and var15_3 ~= var8_3 then
				local var20_3 = var2_0.buff_touch_width[var13_3]

				if var5_3.x >= var20_3[1] and var5_3.x <= var20_3[2] and var1_0.CheckRectCollider(var3_3, var10_3, var4_3, var11_3) then
					var19_3 = true
				end
			end
		end

		if var19_3 then
			var9_3:setTouch(true)

			if var9_3:getScore() and var9_3:getScore() > 0 then
				arg0_3._eventCall(BoatAdGameEvent.ADD_SCORE, var9_3:getScore())
			end

			if var9_3:getHp() ~= 0 then
				if var9_3:getHp() < 0 or var9_3:getConfig("hp_type") == var2_0.hp_type_div then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_SHIBAI)
				elseif not var16_3 then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_GREAT)
				end

				var0_3:changeHp(var9_3:getHp(), var9_3:getConfig("hp_type"))
			end

			var0_3:setLine(var9_3:getLine())

			if var16_3 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_PERFECT)
				arg0_3._eventCall(BoatAdGameEvent.PLAY_AD)
			end

			if var17_3 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_GREAT)
				var0_3:addGuard(var17_3)
			end

			if var18_3 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_GREAT)
				arg0_3._eventCall(BoatAdGameEvent.SPEED_DOWN, var18_3)
			end

			return
		end
	end

	if not var0_3:getBattle() then
		for iter1_3 = 1, #var2_3 do
			local var21_3 = var2_3[iter1_3]
			local var22_3 = var21_3:getPosition()
			local var23_3 = var21_3:getLine()

			if var21_3:getLife() and var22_3.y > var5_3.y - 30 then
				local var24_3 = var21_3:getMoveCount()
				local var25_3 = var21_3:getBoss()
				local var26_3, var27_3 = var21_3:getWorldColliderData()

				if var1_0.CheckRectCollider(var3_3, var26_3, var4_3, var27_3) then
					local var28_3 = var21_3:getHp()

					var0_3:battle(var28_3, var25_3)
					var21_3:battle(var7_3)
					var0_3:setLine(var21_3:getLine())
					LuaHelper.Vibrate()

					return
				end
			end
		end
	end
end

function var0_0.dispose(arg0_4)
	return
end

function var0_0.clear(arg0_5)
	return
end

return var0_0
