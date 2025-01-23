local var0_0 = class("NewEducateSelTalentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.talentId
	local var3_1 = var0_1.idx

	pg.ConnectionMgr.GetInstance():Send(29023, {
		id = var1_1,
		talent = var2_1
	}, 29024, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy)

			var0_2:AddBuff(var2_1, 1)

			local var1_2 = var0_2:GetCurChar():GetFSM():GetState(NewEducateFSM.STYSTEM.TALENT)

			var1_2:MarkFinish()
			arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_TALENT_DONE, {
				idx = var3_1
			})

			local var2_2 = getProxy(NewEducateProxy):GetCurChar()

			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataTalent(var2_2.id, var2_2:GetGameCnt(), var2_2:GetRoundData().round, 2, var2_1, table.concat(var1_2:GetTalents(), ",")))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_SelTalent", arg0_2.result))
		end
	end)
end

return var0_0
