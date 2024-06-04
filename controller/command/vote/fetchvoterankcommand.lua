local var0 = class("FetchVoteRankCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.voteId
	local var2 = var0.callback
	local var3 = getProxy(VoteProxy):RawGetTempVoteGroup(var1)

	if var3 and var3.id == var1 then
		var2()

		return
	end

	pg.ConnectionMgr.GetInstance():Send(17203, {
		type = var1
	}, 17204, function(arg0)
		getProxy(VoteProxy):AddTempVoteGroup(arg0, var1)
		var2()
	end)
end

return var0
