local var0_0 = class("MainActBlackFridaySalesBtn", import(".MainBaseActivityBtn"))

function var0_0.InShowTime(arg0_1)
	local var0_1 = var0_0.super.InShowTime(arg0_1)
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLACK_FRIDAY_SHOP)

	return var0_1 and var1_1 and not var1_1:isEnd()
end

function var0_0.GetEventName(arg0_2)
	return "event_blackFriday"
end

function var0_0.OnInit(arg0_3)
	local var0_3 = false
	local var1_3
	local var2_3 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASKS)

	for iter0_3, iter1_3 in ipairs(var2_3) do
		if iter1_3:getConfig("config_client").blackFriday then
			var1_3 = iter1_3

			break
		end
	end

	if var1_3 and not var1_3:isEnd() then
		local var3_3 = getProxy(TaskProxy)
		local var4_3 = var1_3:getConfig("config_client").taskGroup

		for iter2_3, iter3_3 in ipairs(var4_3) do
			for iter4_3, iter5_3 in ipairs(iter3_3) do
				assert(var3_3:getTaskVO(iter5_3), "without this task:" .. iter5_3)

				if var3_3:getTaskVO(iter5_3):getTaskStatus() == 1 then
					var0_3 = true

					break
				end
			end
		end
	end

	setActive(arg0_3.tipTr.gameObject, var0_3)
end

return var0_0
