local var0_0 = class("NewEducateSelEndingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.endingId
	local var3_1 = var0_1.isMain

	pg.ConnectionMgr.GetInstance():Send(29005, {
		id = var1_1,
		ending_id = var2_1
	}, 29006, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy)

			var0_2:AddFinishedEnding(var2_1)
			var0_2:GetCurChar():GetFSM():GetState(NewEducateFSM.STYSTEM.ENDING):SelEnding(var2_1)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_ENDING_DONE, {
				id = var2_1,
				isMain = var3_1
			})

			local var1_2 = var0_2:GetCurChar():GetGameCnt()

			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataEnding(var1_1, var1_2, var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_SelTalent", arg0_2.result))
		end
	end)
end

return var0_0
