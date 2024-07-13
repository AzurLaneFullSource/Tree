local var0_0 = class("MainActSummaryBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_all"
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
	table.insert(var0_6, function(arg0_8)
		local var0_8 = arg0_6:CollectActEntrance()

		var1_6 = var1_6 + var0_8

		onNextTick(arg0_8)
	end)
	seriesAsync(var0_6, function()
		arg1_6(var2_6, var1_6)
	end)
end

function var0_0.CollectActivity(arg0_10)
	local var0_10 = 0
	local var1_10
	local var2_10 = getProxy(ActivityProxy):getRawData()

	for iter0_10, iter1_10 in pairs(var2_10) do
		if not iter1_10:isEnd() and iter1_10:isShow() and iter1_10:readyToAchieve() then
			var0_10 = var0_10 + 1

			if not var1_10 or var1_10 and var1_10.id > iter1_10.id then
				var1_10 = iter1_10
			end
		end
	end

	return var0_10, var1_10
end

function var0_0.CollectActEntrance(arg0_11)
	local var0_11 = 0
	local var1_11 = ActivityMainScene.GetOnShowEntranceData()

	return #_.filter(var1_11, function(arg0_12)
		return arg0_12.isTip and arg0_12.isTip()
	end)
end

function var0_0.CustomOnClick(arg0_13)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CARD_TOWER_MODE_SELECT)
end

return var0_0
