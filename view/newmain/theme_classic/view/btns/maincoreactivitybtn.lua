local var0_0 = class("MainCoreActivityBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_core"
end

function var0_0.GetTipImage(arg0_2)
	return "tip_1920"
end

function var0_0.GetActivityID(arg0_3)
	return nil
end

function var0_0.OnInit(arg0_4)
	arg0_4:PickPriortyActAsyn(function(arg0_5, arg1_5)
		arg0_4.priority = arg0_5

		if arg1_5 > 0 then
			arg0_4.tipTxt.text = arg1_5
		end

		setActive(arg0_4.tipTr.gameObject, arg1_5 > 0)
	end)
end

function var0_0.PickPriortyActAsyn(arg0_6, arg1_6)
	local var0_6 = {}
	local var1_6 = 0
	local var2_6

	table.insert(var0_6, function(arg0_7)
		local var0_7, var1_7 = arg0_6:CollectActivity()

		var2_6 = var1_7
		var1_6 = var1_6 + var0_7

		onNextTick(arg0_7)
	end)
	seriesAsync(var0_6, function()
		arg1_6(var2_6, var1_6)
	end)
end

function var0_0.CollectActivity(arg0_9)
	local var0_9 = 0
	local var1_9
	local var2_9 = arg0_9:InShowTime() and getProxy(ActivityProxy):getCorePanelActivity(arg0_9.config.param) or {}

	for iter0_9, iter1_9 in pairs(var2_9) do
		if iter1_9:readyToAchieve() then
			var0_9 = var0_9 + 1

			if not var1_9 or var1_9 and var1_9.id > iter1_9.id then
				var1_9 = iter1_9
			end
		end
	end

	return var0_9, var1_9
end

function var0_0.CustomOnClick(arg0_10)
	return
end

return var0_0
