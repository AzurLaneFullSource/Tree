local var0_0 = class("MainRequestVoteInfoSequence")

function var0_0.Execute(arg0_1, arg1_1)
	if not arg0_1:ExistVoteAct() then
		arg1_1()

		return
	end

	seriesAsync({
		function(arg0_2)
			arg0_1:RequestMainStage(arg0_2)
		end,
		function(arg0_3)
			arg0_1:RequestFunStage(arg0_3)
		end
	}, arg1_1)
end

function var0_0.ExistVoteAct(arg0_4)
	return MainVoteEntranceBtn.New():InShowTime()
end

function var0_0.RequestMainStage(arg0_5, arg1_5)
	local var0_5 = _.detect(pg.activity_vote.all, function(arg0_6)
		local var0_6 = pg.activity_vote[arg0_6]
		local var1_6 = var0_6.time_vote

		return pg.TimeMgr.GetInstance():inTime(var1_6) and var0_6.is_in_game == 1 and var0_6.type ~= VoteConst.RACE_TYPE_FUN
	end)

	if not var0_5 or not arg0_5:ShouldRequestMainStage(var0_5) then
		arg1_5()

		return
	end

	pg.m02:sendNotification(GAME.FETCH_VOTE_INFO, {
		voteId = var0_5,
		callback = function()
			var0_0.lastRequestTime = pg.TimeMgr.GetInstance():GetServerTime()

			arg1_5()
		end
	})
end

function var0_0.ShouldRequestMainStage(arg0_8, arg1_8)
	local var0_8 = getProxy(VoteProxy):RawGetVoteGroupByConfigId(arg1_8)
	local var1_8 = pg.TimeMgr.GetInstance():GetServerTime()

	return not var0_8 or var1_8 - (var0_0.lastRequestTime or 0) > VoteConst.RankExpiredTime or var0_8 and var0_8.configId ~= arg1_8
end

function var0_0.RequestFunStage(arg0_9, arg1_9)
	local var0_9 = _.detect(pg.activity_vote.all, function(arg0_10)
		local var0_10 = pg.activity_vote[arg0_10]
		local var1_10 = var0_10.time_vote

		return pg.TimeMgr.GetInstance():inTime(var1_10) and var0_10.is_in_game == 1 and var0_10.type == VoteConst.RACE_TYPE_FUN
	end)

	if not var0_9 or not arg0_9:ShouldRequestFunStage(var0_9) then
		arg1_9()

		return
	end

	pg.m02:sendNotification(GAME.FETCH_VOTE_INFO, {
		voteId = var0_9,
		callback = function()
			var0_0.lastRequestTimeForFun = pg.TimeMgr.GetInstance():GetServerTime()

			arg1_9()
		end
	})
end

function var0_0.ShouldRequestFunStage(arg0_12, arg1_12)
	local var0_12 = getProxy(VoteProxy):RawGetVoteGroupByConfigId(arg1_12)
	local var1_12 = pg.TimeMgr.GetInstance():GetServerTime()

	return not var0_12 or var1_12 - (var0_0.lastRequestTimeForFun or 0) > VoteConst.RankExpiredTime or var0_12 and var0_12.configId ~= arg1_12
end

return var0_0
