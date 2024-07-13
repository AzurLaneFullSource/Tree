local var0_0 = class("VoteCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.voteId
	local var2_1 = var0_1.gid
	local var3_1 = var0_1.count
	local var4_1 = getProxy(VoteProxy)
	local var5_1 = var4_1:GetVoteActivityByConfigId(var1_1)

	if not var5_1 or var5_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var6_1 = var5_1.id
	local var7_1 = var4_1:RawGetVoteGroupByConfigId(var1_1)

	if not var7_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not var7_1:IsOpening() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if var3_1 > var4_1:GetVotesByConfigId(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("vote_not_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var6_1,
		arg1 = var1_1,
		arg2 = var2_1,
		arg3 = var3_1,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)
			local var1_2 = getProxy(ActivityProxy)
			local var2_2 = var1_2:getActivityById(var6_1)

			var2_2.data1 = var2_2.data1 - var3_1
			var2_2.data2 = var2_2.data2 + var3_1

			var1_2:updateActivity(var2_2)
			var7_1:UpdateVoteCnt(var2_1, var3_1)
			arg0_1:sendNotification(GAME.ON_NEW_VOTE_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result])
		end
	end)
end

return var0_0
