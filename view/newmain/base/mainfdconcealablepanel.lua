local var0 = class("MainFdConcealablePanel", import(".MainConcealablePanel"))

function var0.FillEmptySlot(arg0, arg1)
	for iter0 = 1, #arg1 do
		arg1[iter0].localPosition = arg0.initPosition[iter0]
	end
end

return var0
