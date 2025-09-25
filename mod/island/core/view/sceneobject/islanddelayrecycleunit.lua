local var0_0 = class("IslandDelayRecycleUnit", import(".IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.OnAttach(arg0_2, arg1_2)
	var0_0.super.OnAttach(arg0_2, arg1_2)

	arg0_2.delayRemoveTimer = Timer.New(function()
		arg0_2:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, IslandConst.UNIT_LIST_DELAY, arg0_2.data.id)
	end, arg0_2.data.delayRecycleTime, 1)

	arg0_2.delayRemoveTimer:Start()
end

function var0_0.OnDetach(arg0_4)
	if arg0_4.delayRemoveTimer then
		arg0_4.delayRemoveTimer:Stop()

		arg0_4.delayRemoveTimer = nil
	end
end

return var0_0
