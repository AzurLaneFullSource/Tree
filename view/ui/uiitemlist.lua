local var0_0 = class("UIItemList")

var0_0.EventInit = 1
var0_0.EventUpdate = 2
var0_0.EventExcess = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	assert(not IsNil(arg1_1))
	assert(not IsNil(arg2_1))

	arg0_1.container = arg1_1
	arg0_1.item = arg2_1
	arg0_1.currentCount = 0
end

function var0_0.make(arg0_2, arg1_2)
	assert(arg1_2 == nil or type(arg1_2) == "function")

	arg0_2.callback = arg1_2
end

function var0_0.align(arg0_3, arg1_3)
	assert(arg1_3 >= 0)

	local var0_3 = arg0_3.container
	local var1_3 = var0_3.childCount

	for iter0_3 = arg1_3, var1_3 - 1 do
		local var2_3 = var0_3:GetChild(iter0_3)

		setActive(var2_3, false)
	end

	for iter1_3 = var1_3, arg1_3 - 1 do
		local var3_3 = cloneTplTo(arg0_3.item, var0_3)
	end

	if arg0_3.callback then
		for iter2_3 = arg0_3.currentCount, arg1_3 - 1 do
			local var4_3 = var0_3:GetChild(iter2_3)

			arg0_3.callback(var0_0.EventInit, iter2_3, var4_3)
		end

		for iter3_3 = arg1_3, arg0_3.currentCount - 1 do
			local var5_3 = var0_3:GetChild(iter3_3)

			arg0_3.callback(var0_0.EventExcess, iter3_3, var5_3)
		end

		arg0_3.currentCount = arg1_3
	end

	for iter4_3 = 0, arg1_3 - 1 do
		local var6_3 = var0_3:GetChild(iter4_3)

		setActive(var6_3, true)

		if arg0_3.callback then
			arg0_3.callback(var0_0.EventUpdate, iter4_3, var6_3)
		end
	end
end

function var0_0.each(arg0_4, arg1_4)
	for iter0_4 = arg0_4.container.childCount - 1, 0, -1 do
		local var0_4 = arg0_4.container:GetChild(iter0_4)

		arg1_4(iter0_4, var0_4)
	end
end

function var0_0.eachActive(arg0_5, arg1_5)
	for iter0_5 = 0, arg0_5.container.childCount - 1 do
		local var0_5 = arg0_5.container:GetChild(iter0_5)

		if isActive(var0_5) then
			arg1_5(iter0_5, var0_5)
		end
	end
end

function var0_0.StaticAlign(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = UIItemList.New(arg0_6, arg1_6)

	var0_6:make(arg3_6)
	var0_6:align(arg2_6)
end

return var0_0
