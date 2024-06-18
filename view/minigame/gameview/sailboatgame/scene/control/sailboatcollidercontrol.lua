local var0_0 = class("SailBoatColliderControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
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
	local var6_3 = false

	for iter0_3 = 1, #var1_3 do
		local var7_3 = var1_3[iter0_3]
		local var8_3, var9_3 = var7_3:getWorldColliderData()

		if var1_0.CheckRectCollider(var3_3, var8_3, var4_3, var9_3) then
			if var7_3:getConfig("type") == SailBoatGameConst.item_static then
				local var10_3 = var7_3:getSpeed()

				var0_3:move(var10_3.x, var10_3.y)
			elseif var7_3:getConfig("type") == SailBoatGameConst.item_used then
				arg0_3._eventCall(SailBoatGameEvent.USE_ITEM, var7_3:getUseData())
				var7_3:setRemoveFlag(true)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_ITEM)
			end
		end
	end

	for iter1_3 = 1, #var2_3 do
		local var11_3 = var2_3[iter1_3]

		if var11_3:getLife() then
			local var12_3, var13_3 = var11_3:getWorldColliderData()

			if var1_0.CheckRectCollider(var3_3, var12_3, var4_3, var13_3) then
				if var11_3:getConfig("boom") and var11_3:getConfig("boom") > 0 then
					if var11_3:damage({
						num = 999
					}) then
						arg0_3._eventCall(SailBoatGameEvent.DESTROY_ENEMY, var11_3:getDestroyData())
					end
				elseif var0_3:checkColliderDamage() then
					var0_3:flash()
					var0_3:damage({
						num = var1_0.colliderDamage
					})
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
