local var0_0 = class("FinishTechnologyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.pool_id
	local var3_1 = getProxy(TechnologyProxy)
	local var4_1 = var3_1:getTechnologyById(var1_1)

	if not var4_1 then
		return
	end

	if not var4_1:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63003, {
		tech_id = var1_1,
		refresh_id = var2_1
	}, 63004, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:reset()
			var3_1:updateTechnology(var4_1)

			local var0_2 = {
				items = PlayerConst.addTranDrop(arg0_2.common_list),
				commons = PlayerConst.addTranDrop(arg0_2.drop_list),
				catchupItems = PlayerConst.addTranDrop(arg0_2.catchup_list),
				catchupActItems = PlayerConst.addTranDrop(arg0_2.catchupact_list)
			}

			underscore.each(var0_2.catchupItems, function(arg0_3)
				var3_1:addCatupPrintsNum(arg0_3.count)
			end)

			local var1_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

			if var1_2 and not var1_2:isEnd() then
				underscore.each(var0_2.catchupActItems, function(arg0_4)
					var1_2.data1 = var1_2.data1 + arg0_4.count
				end)
			end

			var3_1:updateTechnologys(arg0_2.refresh_list)
			arg0_1:sendNotification(GAME.FINISH_TECHNOLOGY_DONE, {
				items = PlayerConst.MergeTechnologyAward(var0_2)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_finish_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
