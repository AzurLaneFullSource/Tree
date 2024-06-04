local var0 = class("UIItemList")

var0.EventInit = 1
var0.EventUpdate = 2
var0.EventExcess = 3

function var0.Ctor(arg0, arg1, arg2)
	assert(not IsNil(arg1))
	assert(not IsNil(arg2))

	arg0.container = arg1
	arg0.item = arg2
	arg0.currentCount = 0
end

function var0.make(arg0, arg1)
	assert(arg1 == nil or type(arg1) == "function")

	arg0.callback = arg1
end

function var0.align(arg0, arg1)
	assert(arg1 >= 0)

	local var0 = arg0.container
	local var1 = var0.childCount

	for iter0 = arg1, var1 - 1 do
		local var2 = var0:GetChild(iter0)

		setActive(var2, false)
	end

	for iter1 = var1, arg1 - 1 do
		local var3 = cloneTplTo(arg0.item, var0)
	end

	if arg0.callback then
		for iter2 = arg0.currentCount, arg1 - 1 do
			local var4 = var0:GetChild(iter2)

			arg0.callback(var0.EventInit, iter2, var4)
		end

		for iter3 = arg1, arg0.currentCount - 1 do
			local var5 = var0:GetChild(iter3)

			arg0.callback(var0.EventExcess, iter3, var5)
		end

		arg0.currentCount = arg1
	end

	for iter4 = 0, arg1 - 1 do
		local var6 = var0:GetChild(iter4)

		setActive(var6, true)

		if arg0.callback then
			arg0.callback(var0.EventUpdate, iter4, var6)
		end
	end
end

function var0.each(arg0, arg1)
	for iter0 = arg0.container.childCount - 1, 0, -1 do
		local var0 = arg0.container:GetChild(iter0)

		arg1(iter0, var0)
	end
end

function var0.eachActive(arg0, arg1)
	for iter0 = 0, arg0.container.childCount - 1 do
		local var0 = arg0.container:GetChild(iter0)

		if isActive(var0) then
			arg1(iter0, var0)
		end
	end
end

function var0.StaticAlign(arg0, arg1, arg2, arg3)
	local var0 = UIItemList.New(arg0, arg1)

	var0:make(arg3)
	var0:align(arg2)
end

return var0
