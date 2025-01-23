local var0_0 = class("NewEducateGetExtraDropCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.scheduleDrops

	pg.ConnectionMgr.GetInstance():Send(29048, {
		id = var1_1
	}, 29049, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var0_2)
			getProxy(NewEducateProxy):UpdateResources(arg0_2.res.resource)
			getProxy(NewEducateProxy):UpdateAttrs(arg0_2.res.attrs)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_EXTRA_DROP_DONE, {
				drops = NewEducateHelper.FilterBenefit(var0_2),
				scheduleDrops = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_GetExtraDrop: ", arg0_2.result))
		end
	end)
end

return var0_0
