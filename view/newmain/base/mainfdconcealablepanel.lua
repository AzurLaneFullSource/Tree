local var0_0 = class("MainFdConcealablePanel", import(".MainConcealablePanel"))

function var0_0.FillEmptySlot(arg0_1, arg1_1)
	for iter0_1 = 1, #arg1_1 do
		arg1_1[iter0_1].localPosition = arg0_1.initPosition[iter0_1]
	end
end

return var0_0
