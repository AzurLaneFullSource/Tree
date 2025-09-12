local var0_0 = class("CityRebuildCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(CityRebuildProxy)

	if var0_1.operation == CityRebuildProxy.GET_DATA then
		pg.ConnectionMgr.GetInstance():Send(26060, {
			act_id = var0_1.activityId
		}, 26061, function(arg0_2)
			if arg0_2.result == 0 then
				var1_1:SetData(var0_1.activityId, arg0_2.info)
				arg0_1:sendNotification(GAME.CITY_REBUILD_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
			end
		end)
	elseif var0_1.operation == CityRebuildProxy.REBUILD_OR_START_RECRUIT then
		pg.ConnectionMgr.GetInstance():Send(26064, {
			act_id = var0_1.activityId,
			building_id = var0_1.buildingId
		}, 26065, function(arg0_3)
			if arg0_3.result == 0 then
				var1_1:RebuildOrStartRecruit(var0_1.activityId, var0_1.buildingId)
				var1_1:Adjust(var0_1.activityId, arg0_3.adjust)
				var1_1:ComsumePt(var0_1.activityId, var0_1.ptCost[3])
				getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CITY_REBUILD):subVitemNumber(var0_1.cost[2], var0_1.cost[3])
				arg0_1:sendNotification(GAME.CITY_REBUILD_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	elseif var0_1.operation == CityRebuildProxy.END_RECRUIT then
		pg.ConnectionMgr.GetInstance():Send(26062, {
			act_id = var0_1.activityId,
			roles = var0_1.roles
		}, 26063, function(arg0_4)
			if arg0_4.result == 0 then
				var1_1:RecruitDone(var0_1.activityId, var0_1.roles)
				var1_1:Adjust(var0_1.activityId, arg0_4.adjust)
				arg0_1:sendNotification(GAME.CITY_REBUILD_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
			end
		end)
	elseif var0_1.operation == CityRebuildProxy.UPGRADE_BUFF then
		pg.ConnectionMgr.GetInstance():Send(26066, {
			act_id = var0_1.activityId,
			group = var0_1.group,
			count = var0_1.count
		}, 26067, function(arg0_5)
			if arg0_5.result == 0 then
				var1_1:UpgradeBuff(var0_1.activityId, var0_1.group, var0_1.count)
				var1_1:Adjust(var0_1.activityId, arg0_5.adjust)
				var1_1:ComsumePt(var0_1.activityId, var0_1.ptCost)
				arg0_1:sendNotification(GAME.CITY_REBUILD_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.result)
			end
		end)
	elseif var0_1.operation == CityRebuildProxy.RESULT then
		pg.ConnectionMgr.GetInstance():Send(26068, {
			act_id = var0_1.activityId
		}, 26069, function(arg0_6)
			if arg0_6.result == 0 then
				var1_1:Result(var0_1.activityId, arg0_6.summary)

				local var0_6 = PlayerConst.addTranDrop(arg0_6.summary.award_list)

				arg0_1:sendNotification(GAME.CITY_REBUILD_DONE, {
					operation = var0_1.operation,
					awards = var0_6,
					pt = arg0_6.summary.summary_pt
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_6.result] .. arg0_6.result)
			end
		end)
	elseif var0_1.operation == CityRebuildProxy.CHOOSE_LEVEL then
		pg.ConnectionMgr.GetInstance():Send(26070, {
			act_id = var0_1.activityId,
			level = var0_1.level
		}, 26071, function(arg0_7)
			if arg0_7.result == 0 then
				var1_1:UpdateChooseLevel(var0_1.activityId, var0_1.level)
				var1_1:Adjust(var0_1.activityId, arg0_7.adjust)
				arg0_1:sendNotification(GAME.CITY_REBUILD_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_7.result] .. arg0_7.result)
			end
		end)
	elseif var0_1.operation == CityRebuildProxy.INIT_TIME then
		pg.ConnectionMgr.GetInstance():Send(26072, {
			act_id = var0_1.activityId
		}, 26073, function(arg0_8)
			if arg0_8.result == 0 then
				var1_1:Adjust(var0_1.activityId, arg0_8.adjust)
				arg0_1:sendNotification(GAME.CITY_REBUILD_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_8.result] .. arg0_8.result)
			end
		end)
	end
end

return var0_0
