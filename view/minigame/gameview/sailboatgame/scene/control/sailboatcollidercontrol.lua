local var0 = class("SailBoatColliderControl")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._eventCall = arg2
end

function var0.start(arg0)
	arg0._itemMoveSpeed = var1.item_move_speed
end

function var0.step(arg0, arg1)
	local var0 = var1.GetGameChar()
	local var1 = var1.GetGameItems()
	local var2 = var1.GetGameEnemys()
	local var3, var4 = var0:getWorldColliderData()
	local var5 = var0:getPosition()
	local var6 = false

	for iter0 = 1, #var1 do
		local var7 = var1[iter0]
		local var8, var9 = var7:getWorldColliderData()

		if var1.CheckRectCollider(var3, var8, var4, var9) then
			if var7:getConfig("type") == SailBoatGameConst.item_static then
				local var10 = var7:getSpeed()

				var0:move(var10.x, var10.y)
			elseif var7:getConfig("type") == SailBoatGameConst.item_used then
				arg0._eventCall(SailBoatGameEvent.USE_ITEM, var7:getUseData())
				var7:setRemoveFlag(true)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1.SFX_SOUND_ITEM)
			end
		end
	end

	for iter1 = 1, #var2 do
		local var11 = var2[iter1]

		if var11:getLife() then
			local var12, var13 = var11:getWorldColliderData()

			if var1.CheckRectCollider(var3, var12, var4, var13) then
				if var11:getConfig("boom") and var11:getConfig("boom") > 0 then
					if var11:damage({
						num = 999
					}) then
						arg0._eventCall(SailBoatGameEvent.DESTROY_ENEMY, var11:getDestroyData())
					end
				elseif var0:checkColliderDamage() then
					var0:flash()
					var0:damage({
						num = var1.colliderDamage
					})
				end
			end
		end
	end
end

function var0.dispose(arg0)
	return
end

function var0.clear(arg0)
	return
end

return var0
