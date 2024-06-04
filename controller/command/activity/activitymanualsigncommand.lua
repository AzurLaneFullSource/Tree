local var0 = class("ActivityManualSignCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.activity_id
	local var2 = getProxy(ActivityProxy):getActivityById(var1)

	if not var2 or var2:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if var0.cmd == ManualSignActivity.OP_GET_AWARD and not var2:AnyAwardCanGet() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error") .. "1")

		return
	end

	local var3 = {}

	if var0.cmd == ManualSignActivity.OP_GET_AWARD then
		var3 = var2:GetCanGetAwardIndexList()
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = var3,
		kvargs1 = var0.kvargs1
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.GetTranAwards(var0, arg0)

			if var0.cmd == ManualSignActivity.OP_SIGN then
				arg0:HandleSign(var1)
			elseif var0.cmd == ManualSignActivity.OP_GET_AWARD then
				arg0:HandleGetAward(var1)
			end

			arg0:sendNotification(GAME.ACT_MANUAL_SIGN_DONE, {
				awards = var0,
				id = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

function var0.HandleSign(arg0, arg1)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityById(arg1)

	var1:Signed()
	var0:updateActivity(var1)
end

function var0.HandleGetAward(arg0, arg1)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityById(arg1)

	var1:GetAllAwards()
	var0:updateActivity(var1)
end

return var0
