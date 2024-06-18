local var0_0 = class("SystemTimeUtil")

function var0_0.Ctor(arg0_1)
	return
end

function var0_0.SetUp(arg0_2, arg1_2)
	arg0_2.callback = arg1_2

	arg0_2:Flush()
end

function var0_0.Flush(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerHour()
	local var1_3 = var0_3 < 12 and "AM" or "PM"
	local var2_3 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%M", true)

	if arg0_3.callback then
		arg0_3.callback(var0_3, var2_3, var1_3)
	end

	local var3_3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4_3 = arg0_3:GetSecondsToNextMinute(var3_3)

	arg0_3:AddTimer(var4_3)
end

function var0_0.GetSecondsToNextMinute(arg0_4, arg1_4)
	local var0_4 = math.ceil(arg1_4 / 60) * 60 - arg1_4

	if var0_4 <= 0 then
		return 60
	end

	return var0_4
end

function var0_0.AddTimer(arg0_5, arg1_5)
	arg0_5:RemoveTimer()

	arg0_5.timer = Timer.New(function()
		arg0_5:Flush()
	end, arg1_5, 1)

	arg0_5.timer:Start()
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8:RemoveTimer()
end

return var0_0
