local var0_0 = class("FetchVoteRankCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.voteId
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(VoteProxy):RawGetTempVoteGroup(var1_1)

	if var3_1 and var3_1.id == var1_1 then
		var2_1()

		return
	end

	pg.ConnectionMgr.GetInstance():Send(17203, {
		type = var1_1
	}, 17204, function(arg0_2)
		getProxy(VoteProxy):AddTempVoteGroup(arg0_2, var1_1)
		var2_1()
	end)
end

return var0_0
