local var0_0 = class("ActivityManualSignCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.activity_id
	local var2_1 = getProxy(ActivityProxy):getActivityById(var1_1)

	if not var2_1 or var2_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if var0_1.cmd == ManualSignActivity.OP_GET_AWARD and not var2_1:AnyAwardCanGet() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error") .. "1")

		return
	end

	local var3_1 = {}

	if var0_1.cmd == ManualSignActivity.OP_GET_AWARD then
		var3_1 = var2_1:GetCanGetAwardIndexList()
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1_1,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = var3_1,
		kvargs1 = var0_1.kvargs1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.GetTranAwards(var0_1, arg0_2)

			if var0_1.cmd == ManualSignActivity.OP_SIGN then
				arg0_1:HandleSign(var1_1)
			elseif var0_1.cmd == ManualSignActivity.OP_GET_AWARD then
				arg0_1:HandleGetAward(var1_1)
			end

			arg0_1:sendNotification(GAME.ACT_MANUAL_SIGN_DONE, {
				awards = var0_2,
				id = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.HandleSign(arg0_3, arg1_3)
	local var0_3 = getProxy(ActivityProxy)
	local var1_3 = var0_3:getActivityById(arg1_3)

	var1_3:Signed()
	var0_3:updateActivity(var1_3)
end

function var0_0.HandleGetAward(arg0_4, arg1_4)
	local var0_4 = getProxy(ActivityProxy)
	local var1_4 = var0_4:getActivityById(arg1_4)

	var1_4:GetAllAwards()
	var0_4:updateActivity(var1_4)
end

return var0_0
