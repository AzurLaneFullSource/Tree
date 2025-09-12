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

function var0_0.align(arg0_3, arg1_3, arg2_3)
	assert(arg1_3 >= 0)

	local var0_3 = arg0_3.container
	local var1_3 = var0_3.childCount

	for iter0_3 = var1_3, arg1_3 - 1 do
		local var2_3 = cloneTplTo(arg0_3.item, var0_3)
	end

	if arg0_3.callback then
		for iter1_3 = arg0_3.currentCount, arg1_3 - 1 do
			local var3_3 = var0_3:GetChild(iter1_3)

			arg0_3.callback(var0_0.EventInit, iter1_3, var3_3)
		end

		for iter2_3 = arg1_3, arg0_3.currentCount - 1 do
			local var4_3 = var0_3:GetChild(iter2_3)

			arg0_3.callback(var0_0.EventExcess, iter2_3, var4_3)
		end

		arg0_3.currentCount = arg1_3
	end

	arg2_3 = arg2_3 or 0

	for iter3_3 = arg1_3, var1_3 - 1 do
		local var5_3 = var0_3:GetChild(iter3_3)

		setActive(var5_3, false)
	end

	if arg2_3 > 0 then
		for iter4_3 = 0, arg1_3 - 1 do
			local var6_3 = var0_3:GetChild(iter4_3)

			setActive(var6_3, false)
		end

		local var7_3 = 0

		arg0_3.timer = Timer.New(function()
			local var0_4 = var0_3:GetChild(var7_3)

			setActive(var0_4, true)

			if arg0_3.callback then
				arg0_3.callback(var0_0.EventUpdate, var7_3, var0_4)
			end

			var7_3 = var7_3 + 1

			if var7_3 >= arg1_3 then
				arg0_3:StopTimer()
			end
		end, arg2_3, arg1_3)

		arg0_3.timer.func()
		arg0_3.timer:Start()
	else
		for iter5_3 = 0, arg1_3 - 1 do
			local var8_3 = var0_3:GetChild(iter5_3)

			setActive(var8_3, true)

			if arg0_3.callback then
				arg0_3.callback(var0_0.EventUpdate, iter5_3, var8_3)
			end
		end
	end
end

function var0_0.each(arg0_5, arg1_5)
	for iter0_5 = arg0_5.container.childCount - 1, 0, -1 do
		local var0_5 = arg0_5.container:GetChild(iter0_5)

		arg1_5(iter0_5, var0_5)
	end
end

function var0_0.eachActive(arg0_6, arg1_6)
	for iter0_6 = 0, arg0_6.container.childCount - 1 do
		local var0_6 = arg0_6.container:GetChild(iter0_6)

		if isActive(var0_6) then
			arg1_6(iter0_6, var0_6)
		end
	end
end

function var0_0.StaticAlign(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = UIItemList.New(arg0_7, arg1_7)

	var0_7:make(arg3_7)
	var0_7:align(arg2_7)
end

function var0_0.StopTimer(arg0_8)
	if arg0_8.timer then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end
end

function var0_0.Dispose(arg0_9)
	arg0_9:StopTimer()
end

return var0_0
