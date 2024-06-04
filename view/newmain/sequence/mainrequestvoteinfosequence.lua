local var0 = class("MainRequestVoteInfoSequence")

function var0.Execute(arg0, arg1)
	if not arg0:ExistVoteAct() then
		arg1()

		return
	end

	seriesAsync({
		function(arg0)
			arg0:RequestMainStage(arg0)
		end,
		function(arg0)
			arg0:RequestFunStage(arg0)
		end
	}, arg1)
end

function var0.ExistVoteAct(arg0)
	return MainVoteEntranceBtn.New():InShowTime()
end

function var0.RequestMainStage(arg0, arg1)
	local var0 = _.detect(pg.activity_vote.all, function(arg0)
		local var0 = pg.activity_vote[arg0]
		local var1 = var0.time_vote

		return pg.TimeMgr.GetInstance():inTime(var1) and var0.is_in_game == 1 and var0.type ~= VoteConst.RACE_TYPE_FUN
	end)

	if not var0 or not arg0:ShouldRequestMainStage(var0) then
		arg1()

		return
	end

	pg.m02:sendNotification(GAME.FETCH_VOTE_INFO, {
		voteId = var0,
		callback = function()
			var0.lastRequestTime = pg.TimeMgr.GetInstance():GetServerTime()

			arg1()
		end
	})
end

function var0.ShouldRequestMainStage(arg0, arg1)
	local var0 = getProxy(VoteProxy):RawGetVoteGroupByConfigId(arg1)
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	return not var0 or var1 - (var0.lastRequestTime or 0) > VoteConst.RankExpiredTime or var0 and var0.configId ~= arg1
end

function var0.RequestFunStage(arg0, arg1)
	local var0 = _.detect(pg.activity_vote.all, function(arg0)
		local var0 = pg.activity_vote[arg0]
		local var1 = var0.time_vote

		return pg.TimeMgr.GetInstance():inTime(var1) and var0.is_in_game == 1 and var0.type == VoteConst.RACE_TYPE_FUN
	end)

	if not var0 or not arg0:ShouldRequestFunStage(var0) then
		arg1()

		return
	end

	pg.m02:sendNotification(GAME.FETCH_VOTE_INFO, {
		voteId = var0,
		callback = function()
			var0.lastRequestTimeForFun = pg.TimeMgr.GetInstance():GetServerTime()

			arg1()
		end
	})
end

function var0.ShouldRequestFunStage(arg0, arg1)
	local var0 = getProxy(VoteProxy):RawGetVoteGroupByConfigId(arg1)
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	return not var0 or var1 - (var0.lastRequestTimeForFun or 0) > VoteConst.RankExpiredTime or var0 and var0.configId ~= arg1
end

return var0
