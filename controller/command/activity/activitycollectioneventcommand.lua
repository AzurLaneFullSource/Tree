local var0 = class("ActivityCollectionEventCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.arg1
	local var2 = var0.onConfirm
	local var3 = var0.callBack
	local var4 = getProxy(EventProxy)
	local var5 = getProxy(ActivityProxy)
	local var6 = var5:getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

	if not var6 or var6:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var6.id,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = var0.arg_list
	}, 11203, function(arg0)
		if arg0.result == 0 then
			if var0.cmd == ActivityConst.COLLETION_EVENT_OP_JOIN then
				EventStartCommand.OnStart(var1)

				if var3 then
					var3()
				end

				if var2 then
					var2()
				end
			elseif var0.cmd == ActivityConst.COLLETION_EVENT_OP_SUBMIT then
				table.insert(var6.data1_list, var1)
				var5:updateActivity(var6)

				local var0 = {}
				local var1 = var6:getConfig("config_data")
				local var2 = table.indexof(var1, var1)

				assert(var2)

				local var3 = var6:getDayIndex()

				if var2 < var3 and var3 <= #var1 then
					local var4 = var1[var3]

					table.insert(var0, {
						finish_time = 0,
						over_time = 0,
						id = var4,
						ship_id_list = {},
						activity_id = var6.id
					})
				end

				EventFinishCommand.OnFinish(var1, {
					exp = arg0.number[1],
					drop_list = arg0.award_list,
					new_collection = var0,
					is_cri = arg0.number[2]
				}, var2)

				if var3 then
					var3()
				end
			elseif var0.cmd == ActivityConst.COLLETION_EVENT_OP_GIVE_UP then
				EventGiveUpCommand.OnCancel(var1)

				local var5 = {}
				local var6 = var6:getConfig("config_data")
				local var7 = table.indexof(var6, var1)

				assert(var7)

				local var8 = var6:getDayIndex()

				if var7 < var8 and var8 <= #var6 then
					local var9 = var6[var8]

					table.insert(var5, {
						finish_time = 0,
						over_time = 0,
						id = var9,
						ship_id_list = {},
						activity_id = var6.id
					})
				end

				if #var5 > 0 then
					local var10, var11 = var4:findInfoById(var1)

					table.remove(var4.eventList, var11)

					for iter0, iter1 in ipairs(var5) do
						table.insert(var4.eventList, EventInfo.New(iter1))
					end
				end

				if var3 then
					var3()
				end

				if var2 then
					var2()
				end

				pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
