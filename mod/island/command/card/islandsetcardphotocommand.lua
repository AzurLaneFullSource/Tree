local var0_0 = class("IslandSetCardPhotoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.photo

	pg.ConnectionMgr.GetInstance():Send(21328, {
		type = var1_1,
		picture = var2_1
	}, 21329, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.ISLAND_SET_CARD_PHOTO_DONE, {
				photo = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
