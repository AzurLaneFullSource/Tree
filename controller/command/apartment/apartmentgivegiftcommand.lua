local var0 = class("ApartmentGiveGiftCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.giftId
	local var3 = var0.count
	local var4 = getProxy(ApartmentProxy)

	if var3 > var4:getGiftCount(var2) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	local var5 = var4:getApartment(var1)

	pg.ConnectionMgr.GetInstance():Send(28009, {
		ship_group = var1,
		gifts = {
			{
				gift_id = var2,
				number = var3
			}
		}
	}, 28010, function(arg0)
		if arg0.result == 0 then
			var4:addGiftGiveCount(var2, var3)
			var4:changeGiftCount(var2, -var3)

			local var0 = pg.dorm3d_gift[var2].favor_trigger_id

			var5 = var4:getApartment(var1)

			local var1 = var5:addFavor(var0)

			var4:updateApartment(var5)
			arg0:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR_DONE, {
				triggerId = var0,
				delta = var1,
				apartment = var5
			})
			arg0:sendNotification(GAME.APARTMENT_GIVE_GIFT_DONE, var2)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
