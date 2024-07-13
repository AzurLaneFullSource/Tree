local var0_0 = class("ApartmentCollectionItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.itemId
	local var3_1 = getProxy(ApartmentProxy)
	local var4_1 = var3_1:getApartment(var1_1)

	if var4_1.collectItemDic[var2_1] then
		return
	end

	warning(var1_1, var2_1)
	pg.ConnectionMgr.GetInstance():Send(28011, {
		ship_group = var1_1,
		collection_id = var2_1
	}, 28012, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1.collectItemDic[var2_1] = true

			var3_1:updateApartment(var4_1)

			local var0_2 = pg.dorm3d_collection_template[var2_1].award

			var4_1 = var3_1:getApartment(var1_1)

			local var1_2 = var4_1:addFavor(var0_2)

			var3_1:updateApartment(var4_1)
			arg0_1:sendNotification(GAME.APARTMENT_COLLECTION_ITEM_DONE, {
				itemId = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
