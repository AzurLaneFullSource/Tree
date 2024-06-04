local var0 = class("MainActLotteryBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_LanternFestival"
end

function var0.GetActivityID(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	return var0 and var0.id
end

function var0.OnInit(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)
	local var1 = var0:getAwardInfos()
	local var2 = var0:getConfig("config_data")
	local var3 = _.any(var2, function(arg0)
		local var0 = ActivityItemPool.New({
			id = arg0,
			awards = var1[arg0]
		})
		local var1 = var0:getComsume()

		return getProxy(PlayerProxy):getRawData()[id2res(var1.id)] >= var1.count and var0:getleftItemCount() > 0
	end)

	setActive(arg0._tf:Find("Tip"), var3)
end

function var0.CustomOnClick(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

	if var0 then
		arg0:emit(NewMainMediator.SKIP_LOTTERY, var0.id)
	end
end

return var0
