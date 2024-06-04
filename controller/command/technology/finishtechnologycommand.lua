local var0 = class("FinishTechnologyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.pool_id
	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getTechnologyById(var1)

	if not var4 then
		return
	end

	if not var4:isCompleted() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63003, {
		tech_id = var1,
		refresh_id = var2
	}, 63004, function(arg0)
		if arg0.result == 0 then
			var4:reset()
			var3:updateTechnology(var4)

			local var0 = {
				items = PlayerConst.addTranDrop(arg0.common_list),
				commons = PlayerConst.addTranDrop(arg0.drop_list),
				catchupItems = PlayerConst.addTranDrop(arg0.catchup_list),
				catchupActItems = PlayerConst.addTranDrop(arg0.catchupact_list)
			}

			underscore.each(var0.catchupItems, function(arg0)
				var3:addCatupPrintsNum(arg0.count)
			end)

			local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

			if var1 and not var1:isEnd() then
				underscore.each(var0.catchupActItems, function(arg0)
					var1.data1 = var1.data1 + arg0.count
				end)
			end

			var3:updateTechnologys(arg0.refresh_list)
			arg0:sendNotification(GAME.FINISH_TECHNOLOGY_DONE, {
				items = PlayerConst.MergeTechnologyAward(var0)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_finish_erro") .. arg0.result)
		end
	end)
end

return var0
