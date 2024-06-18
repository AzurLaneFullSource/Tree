local var0_0 = class("EducateMapSiteCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	local var2_1 = var0_1.optionVO
	local var3_1 = var2_1.id
	local var4_1 = var2_1:GetCost()
	local var5_1 = getProxy(EducateProxy):GetCharData()
	local var6_1 = {}

	if #var4_1 > 0 then
		for iter0_1, iter1_1 in ipairs(var4_1) do
			assert(iter1_1[1] == EducateConst.DROP_TYPE_RES, "child_site_option的cost只支持资源类型，请检查id:" .. var3_1)

			if var5_1[EducateChar.RES_ID_2_NAME[iter1_1[2]]] < iter1_1[3] then
				pg.TipsMgr.GetInstance():ShowTips(i18n("child_no_resource"))

				return
			end

			table.insert(var6_1, {
				id = iter1_1[2],
				num = iter1_1[3]
			})
		end
	end

	pg.ConnectionMgr.GetInstance():Send(27004, {
		siteid = var0_1.siteId,
		optionid = var3_1
	}, 27005, function(arg0_2)
		if arg0_2.result == 0 then
			EducateHelper.UpdateDropsData(arg0_2.drops)
			EducateHelper.UpdateDropsData(arg0_2.event_drops)
			getProxy(EducateProxy):ReduceResForCosts(var6_1)
			var2_1:ReduceCnt()
			getProxy(EducateProxy):UpdateOptionData(var2_1)
			arg0_1:sendNotification(GAME.EDUCATE_MAP_SITE_DONE, {
				optionId = var3_1,
				drops = arg0_2.drops,
				eventDrops = arg0_2.event_drops,
				events = arg0_2.events,
				branchId = arg0_2.branch_id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate map site error: ", arg0_2.result))
		end
	end)
end

return var0_0
