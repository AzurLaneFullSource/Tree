local var0_0 = class("IslandDelayCreationSystem")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1
	arg0_1.timerDic = {}
end

function var0_0.InitUnit(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.controller.sceneData.delayInitUnits) do
		if iter1_2.delayTime then
			arg0_2:DelayInitUnit(iter1_2)
		end
	end
end

function var0_0.DelayInitUnit(arg0_3, arg1_3)
	local var0_3 = Timer.New(function()
		arg0_3.controller:NotifiyCore(ISLAND_EVT.GEN_UNIT, arg1_3)

		arg0_3.timerDic[arg1_3.id] = nil
	end, arg1_3.delayTime, 1)

	var0_3:Start()

	arg0_3.timerDic[arg1_3.id] = var0_3
end

function var0_0.Dispose(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.timerDic) do
		iter1_5:Stop()
	end

	arg0_5.controller = nil
	arg0_5.timerDic = nil
end

return var0_0
