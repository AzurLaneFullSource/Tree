local var0_0 = class("MainCoreActivityBtn", import(".MainBaseActivityBtn"))

function var0_0.Register(arg0_1)
	var0_0.super.Register(arg0_1)
	arg0_1.event:connect(MainBaseActivityBtn.UPDATED_TIP, handler(arg0_1, arg0_1.OnRefreshBtn))
end

function var0_0.GetEventName(arg0_2)
	return "event_core"
end

function var0_0.OnInit(arg0_3)
	arg0_3:PickPriortyActAsyn(function(arg0_4, arg1_4)
		arg0_3.priority = arg0_4

		if arg1_4 > 0 then
			arg0_3.tipTxt.text = arg1_4
		end

		setActive(arg0_3.tipTr.gameObject, arg1_4 > 0)
	end)
end

function var0_0.PickPriortyActAsyn(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = 0
	local var2_5

	table.insert(var0_5, function(arg0_6)
		local var0_6, var1_6 = arg0_5:CollectActivity()

		var2_5 = var1_6
		var1_5 = var1_5 + var0_6

		onNextTick(arg0_6)
	end)
	seriesAsync(var0_5, function()
		arg1_5(var2_5, var1_5)
	end)
end

function var0_0.CollectActivity(arg0_8)
	local var0_8 = arg0_8:GetLinkConfig().time[2]
	local var1_8 = pg.activity_template[var0_8].page_core
	local var2_8 = 0
	local var3_8
	local var4_8 = getProxy(ActivityProxy):getCorePanelActivities(var1_8)

	for iter0_8, iter1_8 in pairs(var4_8) do
		if iter1_8:readyToAchieve() then
			var2_8 = var2_8 + 1

			if not var3_8 or var3_8 and var3_8.id > iter1_8.id then
				var3_8 = iter1_8
			end
		end
	end

	return var2_8, var3_8
end

function var0_0.GetTipImage(arg0_9)
	return "tip_1920"
end

function var0_0.OnRefreshBtn(arg0_10)
	arg0_10:OnInit()
end

function var0_0.Dispose(arg0_11)
	arg0_11.event:disconnect(MainBaseActivityBtn.UPDATED_TIP, handler(arg0_11, arg0_11.OnRefreshBtn))
	var0_0.super.Dispose(arg0_11)
end

return var0_0
