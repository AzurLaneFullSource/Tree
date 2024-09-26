local var0_0 = class("ApartmentLevelUpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.triggerId
	local var3_1 = getProxy(ApartmentProxy)
	local var4_1 = var3_1:getApartment(var1_1)

	if not var4_1:canLevelUp() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28005, {
		ship_group = var1_1
	}, 28006, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1 = var3_1:getApartment(var1_1)

			var4_1:addLevel()
			var3_1:updateApartment(var4_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			arg0_1:sendNotification(GAME.APARTMENT_LEVEL_UP_DONE, {
				apartment = var4_1,
				award = var0_2
			})

			local var1_2 = var4_1:getLevel()

			_.each(pg.dorm3d_collection_template.all, function(arg0_3)
				local var0_3 = pg.dorm3d_collection_template[arg0_3].unlock

				if var0_3[1] ~= 1 then
					return
				end

				if var0_3[2] ~= var1_2 then
					return
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCollectionItem(arg0_3, 1))
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
