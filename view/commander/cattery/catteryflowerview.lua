local var0_0 = class("CatteryFlowerView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.default = arg0_1._tf:Find("1")
	arg0_1.levels = {
		arg0_1._tf:Find("2"),
		arg0_1._tf:Find("3"),
		arg0_1._tf:Find("4"),
		arg0_1._tf:Find("5")
	}
end

function var0_0.Update(arg0_2, arg1_2)
	local var0_2 = arg1_2:GetCleanLevel()
	local var1_2 = true

	for iter0_2, iter1_2 in pairs(arg0_2.levels) do
		local var2_2 = var0_2 == iter0_2

		setActive(iter1_2, var2_2)

		if var1_2 and var2_2 then
			var1_2 = false
		end
	end

	setActive(arg0_2.default, var1_2)
end

function var0_0.Dispose(arg0_3)
	arg0_3.levels = nil
end

return var0_0
