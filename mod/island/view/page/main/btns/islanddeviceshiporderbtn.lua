local var0_0 = class("IslandDeviceShipOrderBtn", import(".IslandDeviceBaseBtn"))

var0_0.STATES = {
	RUNNING = 2,
	FINISHED = 1,
	WAITING = 3
}

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)

	arg0_1.statesTF = arg0_1.unlockTF:Find("states")

	setText(arg0_1.statesTF:Find("finished/Text"), i18n("island_freight_btn_receive"))
	setText(arg0_1.statesTF:Find("waiting"), i18n("island_freight_btn_idle"))

	arg0_1.timeTxt = arg0_1.statesTF:Find("running/Text"):GetComponent(typeof(Text))
end

function var0_0.FlushDataUI(arg0_2)
	local var0_2, var1_2 = arg0_2:GetState()

	setActive(arg0_2.statesTF:Find("finished"), var0_2 == var0_0.STATES.FINISHED)
	setActive(arg0_2.statesTF:Find("running"), var0_2 == var0_0.STATES.RUNNING)
	setActive(arg0_2.statesTF:Find("waiting"), var0_2 == var0_0.STATES.WAITING)

	local var2_2 = arg0_2.statesTF:GetComponent(typeof(Animation))

	if var0_2 == var0_0.STATES.FINISHED then
		var2_2:Play("IslandDeviceUI_shipoderfinished_")
	elseif var0_2 == var0_0.STATES.RUNNING then
		var2_2:Play("IslandDeviceUI_shipoderrunning_")
	elseif var0_2 == var0_0.STATES.WAITING then
		var2_2:Play("IslandDeviceUI_shipoderwaiting_")
	else
		var2_2:Stop()
	end

	arg0_2:RemoveTimer()

	if var0_2 == var0_0.STATES.RUNNING then
		arg0_2:AddTimer(var1_2)
	end
end

function var0_0.AddTimer(arg0_3, arg1_3)
	local var0_3 = arg1_3:GetEndTime()

	arg0_3.timer = Timer.New(function(arg0_4, arg1_4, arg2_4)
		local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_4 = var0_3 - var0_4

		arg0_3.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_4)

		if var1_4 <= 0 then
			arg0_3:RemoveTimer()
			arg0_3:FlushDataUI()
		end
	end, 1, -1)

	arg0_3.timer.func()
	arg0_3.timer:Start()
end

function var0_0.RemoveTimer(arg0_5)
	if arg0_5.timer then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.GetState(arg0_6)
	local var0_6 = getProxy(IslandProxy):GetIsland():GetOrderAgency()
	local var1_6 = underscore.values(var0_6:GetShipSlotList())
	local var2_6 = underscore.detect(var1_6, function(arg0_7)
		return arg0_7:IsFinished()
	end)

	if var2_6 then
		return var0_0.STATES.FINISHED, var2_6
	end

	local var3_6 = underscore.select(var1_6, function(arg0_8)
		return arg0_8:IsSubmited() and not arg0_8:IsFinished()
	end)

	table.sort(var3_6, CompareFuncs({
		function(arg0_9)
			return arg0_9:GetEndTime()
		end,
		function(arg0_10)
			return arg0_10.id
		end
	}))

	if #var3_6 > 0 then
		return var0_0.STATES.RUNNING, var3_6[1]
	end

	return var0_0.STATES.WAITING, nil
end

function var0_0.Dispose(arg0_11)
	var0_0.super.Dispose(arg0_11)
	arg0_11:RemoveTimer()
end

return var0_0
