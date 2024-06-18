local var0_0 = class("FetchVoteInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.voteId
	local var2_1 = var0_1.callback

	if not var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(17203, {
		type = var1_1
	}, 17204, function(arg0_2)
		getProxy(VoteProxy):AddVoteGroup(arg0_2, var1_1)
		arg0_1:sendNotification(GAME.FETCH_VOTE_INFO_DONE)
		var2_1()
	end)
end

return var0_0
