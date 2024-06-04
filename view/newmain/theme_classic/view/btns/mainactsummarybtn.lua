local var0 = class("MainActSummaryBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_all"
end

function var0.GetTipImage(arg0)
	return "tip_1920"
end

function var0.GetActivityID(arg0)
	return nil
end

function var0.OnInit(arg0)
	arg0:PickPriortyActAsyn(function(arg0, arg1)
		arg0.priority = arg0

		if arg1 > 0 then
			arg0.tipTxt.text = arg1
		end

		setActive(arg0.tipTr.gameObject, arg1 > 0)
	end)
end

function var0.PickPriortyActAsyn(arg0, arg1)
	local var0 = {}
	local var1 = 0
	local var2

	table.insert(var0, function(arg0)
		local var0, var1 = arg0:CollectActivity()

		var2 = var1
		var1 = var1 + var0

		onNextTick(arg0)
	end)
	table.insert(var0, function(arg0)
		local var0 = arg0:CollectActEntrance()

		var1 = var1 + var0

		onNextTick(arg0)
	end)
	seriesAsync(var0, function()
		arg1(var2, var1)
	end)
end

function var0.CollectActivity(arg0)
	local var0 = 0
	local var1
	local var2 = getProxy(ActivityProxy):getRawData()

	for iter0, iter1 in pairs(var2) do
		if not iter1:isEnd() and iter1:isShow() and iter1:readyToAchieve() then
			var0 = var0 + 1

			if not var1 or var1 and var1.id > iter1.id then
				var1 = iter1
			end
		end
	end

	return var0, var1
end

function var0.CollectActEntrance(arg0)
	local var0 = 0
	local var1 = ActivityMainScene.GetOnShowEntranceData()

	return #_.filter(var1, function(arg0)
		return arg0.isTip and arg0.isTip()
	end)
end

function var0.CustomOnClick(arg0)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CARD_TOWER_MODE_SELECT)
end

return var0
