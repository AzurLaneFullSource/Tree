local var0 = class("MainConcealablePanel", import(".MainBasePanel"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.initPosition = {}

	for iter0, iter1 in ipairs(arg0.btns) do
		if not iter1:IsFixed() then
			table.insert(arg0.initPosition, iter1._tf.localPosition)
		end
	end

	arg0.isChanged = false
end

function var0.Init(arg0)
	var0.super.Init(arg0)
	arg0:CalcLayout()
end

function var0.Refresh(arg0)
	var0.super.Refresh(arg0)
	arg0:CalcLayout()
end

function var0.CalcLayout(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.btns) do
		if not iter1:IsFixed() and isActive(iter1._tf) then
			table.insert(var0, iter1._tf)
		end
	end

	local var1 = #var0 >= #arg0.initPosition

	if var1 and not arg0.isChanged then
		return
	end

	arg0:FillEmptySlot(var0)

	arg0.isChanged = not var1
end

function var0.FillEmptySlot(arg0, arg1)
	local var0 = #arg0.initPosition

	for iter0 = #arg1, 1, -1 do
		arg1[iter0].localPosition = arg0.initPosition[var0]
		var0 = var0 - 1
	end
end

return var0
