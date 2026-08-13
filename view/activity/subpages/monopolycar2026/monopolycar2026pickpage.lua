local var0_0 = class("MonopolyCar2026PickPage", import("..MonopolyCar2024.MonopolyCar2024PickPage"))

function var0_0.getUIName(arg0_1)
	return "MonopolyCar2026PickUI"
end

function var0_0.UpdateList(arg0_2)
	var0_0.super.UpdateList(arg0_2)

	local var0_2 = #arg0_2.banList == 0 and arg0_2.turnCnt <= 1

	for iter0_2 = 2, #arg0_2.items do
		local var1_2 = arg0_2.items[iter0_2]

		setActive(var1_2, not var0_2)
	end
end

return var0_0
