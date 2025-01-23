local var0_0 = class("NewEducateGetTalentsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(29019, {
		id = var2_1
	}, 29020, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:SetStystemNo(NewEducateFSM.STYSTEM.TALENT)

			local var1_2 = NewEducateTalentState.New({
				finished = 0,
				talents = arg0_2.talents,
				retalents = {}
			})

			var0_2:SetState(NewEducateFSM.STYSTEM.TALENT, var1_2)

			if #arg0_2.talents == 0 then
				var1_2:MarkFinish()
			else
				local var2_2 = getProxy(NewEducateProxy):GetCurChar()

				pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataTalent(var2_2.id, var2_2:GetGameCnt(), var2_2:GetRoundData().round, 1, 0, table.concat(arg0_2.talents, ",")))
			end

			existCall(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_GetTalents", arg0_2.result))
		end
	end)
end

return var0_0
