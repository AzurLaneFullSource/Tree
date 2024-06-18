local var0_0 = class("ApartmentReplaceFurnitureCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body
	local var1_1 = var0_1.shipGroupId
	local var2_1 = var0_1.furnitures
	local var3_1 = _.map(var2_1, function(arg0_2)
		return {
			slot_id = arg0_2.slotId,
			furniture_id = arg0_2.furnitureId
		}
	end)

	pg.ConnectionMgr.GetInstance():Send(28007, {
		ship_group = var1_1,
		furnitures = var3_1
	}, 28008, function(arg0_3)
		if arg0_3.result ~= 0 then
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_3.result))
			arg0_1:sendNotification(GAME.APARTMENT_REPLACE_FURNITURE_ERROR)

			return
		end

		local var0_3 = getProxy(ApartmentProxy):getApartment(var1_1)

		var0_3:ReplaceFurnitures(var2_1)
		getProxy(ApartmentProxy):updateApartment(var0_3)
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_replace_furniture_sucess"))
		arg0_1:sendNotification(GAME.APARTMENT_REPLACE_FURNITURE_DONE)
	end)
end

return var0_0
