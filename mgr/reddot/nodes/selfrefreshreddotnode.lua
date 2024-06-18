local var0_0 = class("SelfRefreshRedDotNode", import(".RedDotNode"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)
	arg0_1:AddTimer()
end

function var0_0.AddTimer(arg0_2)
	arg0_2:RemoveTimer()

	arg0_2.timer = Timer.New(function()
		arg0_2:Check()
	end, 10, -1)

	arg0_2.timer:Start()
end

function var0_0.Check(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.types) do
		pg.RedDotMgr.GetInstance():NotifyAll(iter1_4)
	end
end

function var0_0.RemoveTimer(arg0_5)
	if arg0_5.timer then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.Remove(arg0_6)
	arg0_6:RemoveTimer()
end

function var0_0.Resume(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Resume()
	end
end

function var0_0.Puase(arg0_8)
	if arg0_8.timer then
		arg0_8.timer:Pause()
	end
end

return var0_0
