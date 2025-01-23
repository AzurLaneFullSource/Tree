local var0_0 = class("NewEducateRefreshTalentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.talentId
	local var3_1 = var0_1.idx

	pg.ConnectionMgr.GetInstance():Send(29021, {
		id = var1_1,
		talent = var2_1
	}, 29022, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):GetCurChar():GetFSM():GetState(NewEducateFSM.STYSTEM.TALENT):OnRefreshTalent(var2_1, arg0_2.talent)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_TALENT_DONE, {
				idx = var3_1,
				newId = arg0_2.talent
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_RefreshTalent", arg0_2.result))
		end
	end)
end

return var0_0
