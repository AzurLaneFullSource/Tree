local var0_0 = class("ApartmentCollectionItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.roomId
	local var2_1 = var0_1.groupId
	local var3_1 = var0_1.itemId
	local var4_1 = pg.dorm3d_collection_template[var3_1]
	local var5_1 = var4_1.award

	if var2_1 == 0 and var5_1 ~= 0 then
		pg.TipsMgr.GetInstance():ShowTips("error collection favor trigger link:" .. var3_1)

		return
	end

	local var6_1 = getProxy(ApartmentProxy)
	local var7_1 = var6_1:getRoom(var1_1)

	if var7_1.collectItemDic[var3_1] then
		arg0_1:sendNotification(GAME.APARTMENT_COLLECTION_ITEM_DONE, {
			itemId = var3_1
		})

		return
	end

	local var8_1 = var6_1:getApartment(var2_1)

	pg.ConnectionMgr.GetInstance():Send(28011, {
		room_id = var1_1,
		collection_id = var3_1,
		ship_group = var2_1
	}, 28012, function(arg0_2)
		if arg0_2.result == 0 then
			var7_1 = var6_1:getRoom(var1_1)
			var7_1.collectItemDic[var3_1] = true

			var6_1:updateRoom(var7_1)

			local var0_2 = var4_1.award

			if var0_2 > 0 then
				local var1_2, var2_2 = var6_1:triggerFavor(var2_1, var0_2)

				arg0_1:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR_DONE, {
					triggerId = var0_2,
					cost = var2_2,
					delta = var1_2,
					apartment = var8_1
				})
			end

			PlayerPrefs.SetInt("apartment_collection_item", var3_1)
			arg0_1:sendNotification(GAME.APARTMENT_COLLECTION_ITEM_DONE, {
				isNew = true,
				itemId = var3_1
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCollectionItem(var3_1, 2))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
