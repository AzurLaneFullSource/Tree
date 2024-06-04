local var0 = class("SelfRefreshRedDotNode", import(".RedDotNode"))

function var0.Init(arg0)
	var0.super.Init(arg0)
	arg0:AddTimer()
end

function var0.AddTimer(arg0)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		arg0:Check()
	end, 10, -1)

	arg0.timer:Start()
end

function var0.Check(arg0)
	for iter0, iter1 in ipairs(arg0.types) do
		pg.RedDotMgr.GetInstance():NotifyAll(iter1)
	end
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Remove(arg0)
	arg0:RemoveTimer()
end

function var0.Resume(arg0)
	if arg0.timer then
		arg0.timer:Resume()
	end
end

function var0.Puase(arg0)
	if arg0.timer then
		arg0.timer:Pause()
	end
end

return var0
