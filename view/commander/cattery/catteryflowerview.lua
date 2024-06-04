local var0 = class("CatteryFlowerView")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.default = arg0._tf:Find("1")
	arg0.levels = {
		arg0._tf:Find("2"),
		arg0._tf:Find("3"),
		arg0._tf:Find("4"),
		arg0._tf:Find("5")
	}
end

function var0.Update(arg0, arg1)
	local var0 = arg1:GetCleanLevel()
	local var1 = true

	for iter0, iter1 in pairs(arg0.levels) do
		local var2 = var0 == iter0

		setActive(iter1, var2)

		if var1 and var2 then
			var1 = false
		end
	end

	setActive(arg0.default, var1)
end

function var0.Dispose(arg0)
	arg0.levels = nil
end

return var0
