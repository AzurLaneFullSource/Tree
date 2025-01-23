local var0_0 = class("ApartmentGiveGiftCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.giftId
	local var3_1 = var0_1.count
	local var4_1 = getProxy(ApartmentProxy)

	if var3_1 > var4_1:getGiftCount(var2_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	local var5_1 = var4_1:getApartment(var1_1)

	pg.ConnectionMgr.GetInstance():Send(28009, {
		ship_group = var1_1,
		gifts = {
			{
				gift_id = var2_1,
				number = var3_1
			}
		}
	}, 28010, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:addGiftGiveCount(var2_1, var3_1)
			var4_1:changeGiftCount(var2_1, -var3_1)

			local var0_2 = pg.dorm3d_gift[var2_1].favor_trigger_id
			local var1_2, var2_2 = var4_1:triggerFavor(var1_1, var0_2, var3_1)

			arg0_1:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR_DONE, {
				isGift = true,
				triggerId = var0_2,
				cost = var2_2,
				delta = var1_2,
				apartment = var5_1
			})
			arg0_1:sendNotification(GAME.APARTMENT_GIVE_GIFT_DONE, {
				groupId = var1_1,
				giftId = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
