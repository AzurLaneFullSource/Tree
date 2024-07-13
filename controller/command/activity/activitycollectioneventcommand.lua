local var0_0 = class("ActivityCollectionEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.arg1
	local var2_1 = var0_1.onConfirm
	local var3_1 = var0_1.callBack
	local var4_1 = getProxy(EventProxy)
	local var5_1 = getProxy(ActivityProxy)
	local var6_1 = var5_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if not var6_1 or var6_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var6_1.id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = var0_1.arg_list
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1.cmd == ActivityConst.COLLETION_EVENT_OP_JOIN then
				EventStartCommand.OnStart(var1_1)

				if var3_1 then
					var3_1()
				end

				if var2_1 then
					var2_1()
				end
			elseif var0_1.cmd == ActivityConst.COLLETION_EVENT_OP_SUBMIT then
				table.insert(var6_1.data1_list, var1_1)
				var5_1:updateActivity(var6_1)

				local var0_2 = {}
				local var1_2 = var6_1:getConfig("config_data")
				local var2_2 = table.indexof(var1_2, var1_1)

				assert(var2_2)

				local var3_2 = var6_1:getDayIndex()

				if var2_2 < var3_2 and var3_2 <= #var1_2 then
					local var4_2 = var1_2[var3_2]

					table.insert(var0_2, {
						finish_time = 0,
						over_time = 0,
						id = var4_2,
						ship_id_list = {},
						activity_id = var6_1.id
					})
				end

				EventFinishCommand.OnFinish(var1_1, {
					exp = arg0_2.number[1],
					drop_list = arg0_2.award_list,
					new_collection = var0_2,
					is_cri = arg0_2.number[2]
				}, var2_1)

				if var3_1 then
					var3_1()
				end
			elseif var0_1.cmd == ActivityConst.COLLETION_EVENT_OP_GIVE_UP then
				EventGiveUpCommand.OnCancel(var1_1)

				local var5_2 = {}
				local var6_2 = var6_1:getConfig("config_data")
				local var7_2 = table.indexof(var6_2, var1_1)

				assert(var7_2)

				local var8_2 = var6_1:getDayIndex()

				if var7_2 < var8_2 and var8_2 <= #var6_2 then
					local var9_2 = var6_2[var8_2]

					table.insert(var5_2, {
						finish_time = 0,
						over_time = 0,
						id = var9_2,
						ship_id_list = {},
						activity_id = var6_1.id
					})
				end

				if #var5_2 > 0 then
					local var10_2, var11_2 = var4_1:findInfoById(var1_1)

					table.remove(var4_1.eventList, var11_2)

					for iter0_2, iter1_2 in ipairs(var5_2) do
						table.insert(var4_1.eventList, EventInfo.New(iter1_2))
					end
				end

				if var3_1 then
					var3_1()
				end

				if var2_1 then
					var2_1()
				end

				pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
