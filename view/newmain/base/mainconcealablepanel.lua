local var0_0 = class("MainConcealablePanel", import(".MainBasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.initPosition = {}

	for iter0_1, iter1_1 in ipairs(arg0_1.btns) do
		if not iter1_1:IsFixed() then
			table.insert(arg0_1.initPosition, iter1_1._tf.localPosition)
		end
	end

	arg0_1.isChanged = false
end

function var0_0.Init(arg0_2)
	var0_0.super.Init(arg0_2)
	arg0_2:CalcLayout()
end

function var0_0.Refresh(arg0_3)
	var0_0.super.Refresh(arg0_3)
	arg0_3:CalcLayout()
end

function var0_0.CalcLayout(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.btns) do
		if not iter1_4:IsFixed() and isActive(iter1_4._tf) then
			table.insert(var0_4, iter1_4._tf)
		end
	end

	local var1_4 = #var0_4 >= #arg0_4.initPosition

	if var1_4 and not arg0_4.isChanged then
		return
	end

	arg0_4:FillEmptySlot(var0_4)

	arg0_4.isChanged = not var1_4
end

function var0_0.FillEmptySlot(arg0_5, arg1_5)
	local var0_5 = #arg0_5.initPosition

	for iter0_5 = #arg1_5, 1, -1 do
		arg1_5[iter0_5].localPosition = arg0_5.initPosition[var0_5]
		var0_5 = var0_5 - 1
	end
end

return var0_0
