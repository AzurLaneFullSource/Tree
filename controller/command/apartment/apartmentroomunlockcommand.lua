local var0_0 = class("ApartmentRoomUnlockCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().roomId
	local var1_1 = pg.dorm3d_rooms[var0_1]
	local var2_1 = underscore.map(var1_1.unlock_item, function(arg0_2)
		return Drop.Create(arg0_2)
	end)

	if #var2_1 > 0 and underscore.any(var2_1, function(arg0_3)
		return arg0_3:getOwnedCount() < arg0_3.count
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("temple_consume_not_enough"))

		return
	end

	local var3_1 = getProxy(ApartmentProxy)

	if var3_1:getRoom(var0_1) then
		pg.TipsMgr.GetInstance():ShowTips("this room already unlock")

		return
	end

	pg.ConnectionMgr.GetInstance():Send(28001, {
		room_id = var0_1
	}, 28002, function(arg0_4)
		if arg0_4.result == 0 then
			for iter0_4, iter1_4 in ipairs(var2_1) do
				reducePlayerOwn(iter1_4)
			end

			local var0_4 = ApartmentRoom.New(arg0_4.room)

			var3_1:updateRoom(var0_4)

			if var0_4:isPersonalRoom() then
				var3_1:updateApartment(Apartment.New({
					cur_skin = 0,
					daily_favor = 0,
					favor_lv = 1,
					favor_exp = 0,
					ship_group = var0_4:getPersonalGroupId()
				}))
			end

			;(function()
				local var0_5 = var1_1.type == 1
				local var1_5 = var0_5 and 4 or 2
				local var2_5 = ""

				if not var0_5 then
					var2_5 = table.concat(var1_1.character, ",")
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataRoom(var0_1, var1_5, var2_5))
			end)()
			arg0_1:sendNotification(GAME.APARTMENT_ROOM_UNLOCK_DONE, {
				roomId = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
		end
	end)
end

return var0_0
