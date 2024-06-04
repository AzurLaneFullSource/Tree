local var0 = class("SystemTimeUtil")

function var0.Ctor(arg0)
	return
end

function var0.SetUp(arg0, arg1)
	arg0.callback = arg1

	arg0:Flush()
end

function var0.Flush(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerHour()
	local var1 = var0 < 12 and "AM" or "PM"
	local var2 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%M", true)

	if arg0.callback then
		arg0.callback(var0, var2, var1)
	end

	local var3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4 = arg0:GetSecondsToNextMinute(var3)

	arg0:AddTimer(var4)
end

function var0.GetSecondsToNextMinute(arg0, arg1)
	local var0 = math.ceil(arg1 / 60) * 60 - arg1

	if var0 <= 0 then
		return 60
	end

	return var0
end

function var0.AddTimer(arg0, arg1)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		arg0:Flush()
	end, arg1, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:RemoveTimer()
end

return var0
