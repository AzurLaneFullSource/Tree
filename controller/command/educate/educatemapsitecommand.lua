local var0 = class("EducateMapSiteCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	local var2 = var0.optionVO
	local var3 = var2.id
	local var4 = var2:GetCost()
	local var5 = getProxy(EducateProxy):GetCharData()
	local var6 = {}

	if #var4 > 0 then
		for iter0, iter1 in ipairs(var4) do
			assert(iter1[1] == EducateConst.DROP_TYPE_RES, "child_site_option的cost只支持资源类型，请检查id:" .. var3)

			if var5[EducateChar.RES_ID_2_NAME[iter1[2]]] < iter1[3] then
				pg.TipsMgr.GetInstance():ShowTips(i18n("child_no_resource"))

				return
			end

			table.insert(var6, {
				id = iter1[2],
				num = iter1[3]
			})
		end
	end

	pg.ConnectionMgr.GetInstance():Send(27004, {
		siteid = var0.siteId,
		optionid = var3
	}, 27005, function(arg0)
		if arg0.result == 0 then
			EducateHelper.UpdateDropsData(arg0.drops)
			EducateHelper.UpdateDropsData(arg0.event_drops)
			getProxy(EducateProxy):ReduceResForCosts(var6)
			var2:ReduceCnt()
			getProxy(EducateProxy):UpdateOptionData(var2)
			arg0:sendNotification(GAME.EDUCATE_MAP_SITE_DONE, {
				optionId = var3,
				drops = arg0.drops,
				eventDrops = arg0.event_drops,
				events = arg0.events,
				branchId = arg0.branch_id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate map site error: ", arg0.result))
		end
	end)
end

return var0
