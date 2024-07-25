local var0_0 = class("MonopolyCar2024GameAwardCollector")

function var0_0.Ctor(arg0_1)
	arg0_1.list = {}
	arg0_1.isSetUp = false
end

function var0_0.Add(arg0_2, arg1_2)
	if not arg0_2.isSetUp then
		return
	end

	for iter0_2, iter1_2 in ipairs(arg1_2 or {}) do
		table.insert(arg0_2.list, iter1_2)
	end
end

function var0_0.SetUp(arg0_3)
	arg0_3.isSetUp = true

	arg0_3:Clear()
end

function var0_0.Disable(arg0_4)
	arg0_4.isSetUp = false

	arg0_4:Clear()
end

function var0_0.Fetch(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.list or {}) do
		table.insert(var0_5, iter1_5)
	end

	arg0_5:Clear()

	return var0_5
end

function var0_0.Clear(arg0_6)
	arg0_6.list = {}
end

function var0_0.Dispose(arg0_7)
	arg0_7:Clear()
end

return var0_0
