local var0 = class("ApartmentReplaceFurnitureCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body
	local var1 = var0.shipGroupId
	local var2 = var0.furnitures
	local var3 = _.map(var2, function(arg0)
		return {
			slot_id = arg0.slotId,
			furniture_id = arg0.furnitureId
		}
	end)

	pg.ConnectionMgr.GetInstance():Send(28007, {
		ship_group = var1,
		furnitures = var3
	}, 28008, function(arg0)
		if arg0.result ~= 0 then
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
			arg0:sendNotification(GAME.APARTMENT_REPLACE_FURNITURE_ERROR)

			return
		end

		local var0 = getProxy(ApartmentProxy):getApartment(var1)

		var0:ReplaceFurnitures(var2)
		getProxy(ApartmentProxy):updateApartment(var0)
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_replace_furniture_sucess"))
		arg0:sendNotification(GAME.APARTMENT_REPLACE_FURNITURE_DONE)
	end)
end

return var0
