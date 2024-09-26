local var0_0 = class("ApartmentRoomInviteUnlockCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.roomId
	local var2_1 = var0_1.groupId
	local var3_1 = getProxy(ApartmentProxy)
	local var4_1 = var3_1:getRoom(var1_1)

	assert(underscore.any(var4_1:getConfig("character_pay"), function(arg0_2)
		return arg0_2 == var2_1
	end))

	local var5_1 = Apartment.getGroupConfig(var2_1, var4_1:getConfig("invite_cost"))
	local var6_1 = CommonCommodity.New({
		id = var5_1
	}, Goods.TYPE_SHOPSTREET)
	local var7_1, var8_1, var9_1 = var6_1:GetPrice()
	local var10_1 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var6_1:GetResType(),
		count = var7_1
	})
	local var11_1 = {
		var10_1
	}

	if #var11_1 > 0 and underscore.any(var11_1, function(arg0_3)
		return arg0_3:getOwnedCount() < arg0_3.count
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("temple_consume_not_enough"))

		return
	end

	if not var4_1 or var4_1.unlockCharacter[var2_1] then
		pg.TipsMgr.GetInstance():ShowTips("unlock error:%d, %d", var4_1 and var1_1 or 0, var4_1 and var4_1.unlockCharacter[var2_1] or 0)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(28019, {
		room_id = var1_1,
		ship_group = var2_1
	}, 28020, function(arg0_4)
		if arg0_4.result == 0 then
			for iter0_4, iter1_4 in ipairs(var11_1) do
				reducePlayerOwn(iter1_4)
			end

			local var0_4 = var3_1:getRoom(var1_1)

			var0_4.unlockCharacter[var2_1] = true

			var3_1:updateRoom(var0_4)
			arg0_1:sendNotification(GAME.APARTMENT_ROOM_INVITE_UNLOCK_DONE, {
				roomId = var1_1,
				groupId = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
		end
	end)
end

return var0_0
