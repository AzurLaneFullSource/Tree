local var0_0 = class("FinishQueueTechnologyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(TechnologyProxy)

	if #var1_1.queue == 0 or not var1_1.queue[1]:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63015, {
		id = 0
	}, 63016, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy)
			local var1_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.drops) do
				local var2_2 = {
					items = PlayerConst.addTranDrop(iter1_2.common_list),
					commons = PlayerConst.addTranDrop(iter1_2.drop_list),
					catchupItems = PlayerConst.addTranDrop(iter1_2.catchup_list),
					catchupActItems = PlayerConst.addTranDrop(iter1_2.catchupact_list)
				}

				underscore.each(var2_2.catchupItems, function(arg0_3)
					var1_1:addCatupPrintsNum(arg0_3.count)
				end)

				local var3_2 = var0_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

				if var3_2 and not var3_2:isEnd() then
					underscore.each(var2_2.catchupActItems, function(arg0_4)
						var3_2.data1 = var3_2.data1 + arg0_4.count
					end)
				end

				table.insert(var1_2, PlayerConst.MergeTechnologyAward(var2_2))
				var1_1:removeFirstQueueTechnology()
			end

			arg0_1:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY_DONE, {
				dropInfos = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_stop_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
