local var0_0 = class("IslandTransferPlayer", import(".IslandBasePerformancePlayer"))

function var0_0.Play(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1.objId

	arg0_1:emit(ISLAND_EX_EVT.SWITCH_MAP, var0_1)

	arg0_1.callback = arg2_1
end

function var0_0.EndAction(arg0_2)
	if arg0_2.callback then
		arg0_2.callback()
	end

	arg0_2.callback = nil
end

return var0_0
