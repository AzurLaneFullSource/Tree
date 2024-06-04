local var0 = class("ApartmentCollectionItemCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.itemId
	local var3 = getProxy(ApartmentProxy)
	local var4 = var3:getApartment(var1)

	if var4.collectItemDic[var2] then
		return
	end

	warning(var1, var2)
	pg.ConnectionMgr.GetInstance():Send(28011, {
		ship_group = var1,
		collection_id = var2
	}, 28012, function(arg0)
		if arg0.result == 0 then
			var4.collectItemDic[var2] = true

			var3:updateApartment(var4)

			local var0 = pg.dorm3d_collection_template[var2].award

			var4 = var3:getApartment(var1)

			local var1 = var4:addFavor(var0)

			var3:updateApartment(var4)
			arg0:sendNotification(GAME.APARTMENT_COLLECTION_ITEM_DONE, {
				itemId = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
