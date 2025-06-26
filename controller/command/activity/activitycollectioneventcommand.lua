local var0_0 = class("ActivityCollectionEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.event
	local var2_1 = var0_1.arg1
	local var3_1 = var0_1.onConfirm
	local var4_1 = var0_1.callBack
	local var5_1 = getProxy(EventProxy)
	local var6_1 = getProxy(ActivityProxy)
	local var7_1 = var6_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if not var7_1 or var7_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var7_1.id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = var0_1.arg_list
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1.cmd == ActivityConst.COLLETION_EVENT_OP_JOIN then
				EventStartCommand.OnStart(var1_1)

				if var4_1 then
					var4_1()
				end

				if var3_1 then
					var3_1()
				end
			elseif var0_1.cmd == ActivityConst.COLLETION_EVENT_OP_SUBMIT then
				table.insert(var7_1.data1_list, var2_1)
				var6_1:updateActivity(var7_1)
				EventFinishCommand.OnFinish(var2_1, {
					exp = arg0_2.number[1],
					drop_list = arg0_2.award_list,
					new_collection = {},
					is_cri = arg0_2.number[2]
				}, var3_1)
				getProxy(EventProxy):CheckAddActivityEvent()

				if var4_1 then
					var4_1()
				end
			elseif var0_1.cmd == ActivityConst.COLLETION_EVENT_OP_GIVE_UP then
				EventGiveUpCommand.OnCancel(var2_1)
				getProxy(EventProxy):CheckAddActivityEvent()

				if var4_1 then
					var4_1()
				end

				if var3_1 then
					var3_1()
				end
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
