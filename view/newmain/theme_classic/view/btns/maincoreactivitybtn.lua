local var0_0 = class("MainCoreActivityBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_core"
end

function var0_0.OnInit(arg0_2)
	arg0_2:PickPriortyActAsyn(function(arg0_3, arg1_3)
		arg0_2.priority = arg0_3

		if arg1_3 > 0 then
			arg0_2.tipTxt.text = arg1_3
		end

		setActive(arg0_2.tipTr.gameObject, arg1_3 > 0)
	end)
end

function var0_0.PickPriortyActAsyn(arg0_4, arg1_4)
	local var0_4 = {}
	local var1_4 = 0
	local var2_4

	table.insert(var0_4, function(arg0_5)
		local var0_5, var1_5 = arg0_4:CollectActivity()

		var2_4 = var1_5
		var1_4 = var1_4 + var0_5

		onNextTick(arg0_5)
	end)
	seriesAsync(var0_4, function()
		arg1_4(var2_4, var1_4)
	end)
end

function var0_0.CollectActivity(arg0_7)
	local var0_7 = arg0_7:GetLinkConfig().time[2]
	local var1_7 = pg.activity_template[var0_7].page_core
	local var2_7 = 0
	local var3_7
	local var4_7 = getProxy(ActivityProxy):getCorePanelActivities(var1_7)

	for iter0_7, iter1_7 in pairs(var4_7) do
		if iter1_7:readyToAchieve() then
			var2_7 = var2_7 + 1

			if not var3_7 or var3_7 and var3_7.id > iter1_7.id then
				var3_7 = iter1_7
			end
		end
	end

	return var2_7, var3_7
end

function var0_0.GetTipImage(arg0_8)
	return "tip_1920"
end

return var0_0
