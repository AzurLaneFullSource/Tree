local var0 = class("VoteCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.voteId
	local var2 = var0.gid
	local var3 = var0.count
	local var4 = getProxy(VoteProxy)
	local var5 = var4:GetVoteActivityByConfigId(var1)

	if not var5 or var5:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var6 = var5.id
	local var7 = var4:RawGetVoteGroupByConfigId(var1)

	if not var7 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not var7:IsOpening() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if var3 > var4:GetVotesByConfigId(var1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("vote_not_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var6,
		arg1 = var1,
		arg2 = var2,
		arg3 = var3,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)
			local var1 = getProxy(ActivityProxy)
			local var2 = var1:getActivityById(var6)

			var2.data1 = var2.data1 - var3
			var2.data2 = var2.data2 + var3

			var1:updateActivity(var2)
			var7:UpdateVoteCnt(var2, var3)
			arg0:sendNotification(GAME.ON_NEW_VOTE_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result])
		end
	end)
end

return var0
