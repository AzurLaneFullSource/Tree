local var0 = class("FinishQueueTechnologyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(TechnologyProxy)

	if #var1.queue == 0 or not var1.queue[1]:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63015, {
		id = 0
	}, 63016, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ActivityProxy)
			local var1 = {}

			for iter0, iter1 in ipairs(arg0.drops) do
				local var2 = {
					items = PlayerConst.addTranDrop(iter1.common_list),
					commons = PlayerConst.addTranDrop(iter1.drop_list),
					catchupItems = PlayerConst.addTranDrop(iter1.catchup_list),
					catchupActItems = PlayerConst.addTranDrop(iter1.catchupact_list)
				}

				underscore.each(var2.catchupItems, function(arg0)
					var1:addCatupPrintsNum(arg0.count)
				end)

				local var3 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

				if var3 and not var3:isEnd() then
					underscore.each(var2.catchupActItems, function(arg0)
						var3.data1 = var3.data1 + arg0.count
					end)
				end

				table.insert(var1, PlayerConst.MergeTechnologyAward(var2))
				var1:removeFirstQueueTechnology()
			end

			arg0:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY_DONE, {
				dropInfos = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_stop_erro") .. arg0.result)
		end
	end)
end

return var0
