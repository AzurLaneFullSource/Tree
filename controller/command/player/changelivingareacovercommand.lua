local var0_0 = class("ChangeLivingAreaCoverCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.coverId
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(LivingAreaCoverProxy)

	pg.ConnectionMgr.GetInstance():Send(11030, {
		livingarea_cover_id = var1_1
	}, 11031, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:UpdateCoverId(var1_1)
			arg0_1:sendNotification(GAME.CHANGE_LIVINGAREA_COVER_DONE)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(var1_1, 2))

			if var2_1 then
				var2_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
