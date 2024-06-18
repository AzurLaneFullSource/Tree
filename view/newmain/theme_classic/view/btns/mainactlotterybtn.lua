local var0_0 = class("MainActLotteryBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_LanternFestival"
end

function var0_0.GetActivityID(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	return var0_2 and var0_2.id
end

function var0_0.OnInit(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)
	local var1_3 = var0_3:getAwardInfos()
	local var2_3 = var0_3:getConfig("config_data")
	local var3_3 = _.any(var2_3, function(arg0_4)
		local var0_4 = ActivityItemPool.New({
			id = arg0_4,
			awards = var1_3[arg0_4]
		})
		local var1_4 = var0_4:getComsume()

		return getProxy(PlayerProxy):getRawData()[id2res(var1_4.id)] >= var1_4.count and var0_4:getleftItemCount() > 0
	end)

	setActive(arg0_3._tf:Find("Tip"), var3_3)
end

function var0_0.CustomOnClick(arg0_5)
	local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var0_5 then
		arg0_5:emit(NewMainMediator.SKIP_LOTTERY, var0_5.id)
	end
end

return var0_0
