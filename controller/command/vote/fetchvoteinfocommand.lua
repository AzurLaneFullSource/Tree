local var0 = class("FetchVoteInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.voteId
	local var2 = var0.callback

	if not var1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(17203, {
		type = var1
	}, 17204, function(arg0)
		getProxy(VoteProxy):AddVoteGroup(arg0, var1)
		arg0:sendNotification(GAME.FETCH_VOTE_INFO_DONE)
		var2()
	end)
end

return var0
