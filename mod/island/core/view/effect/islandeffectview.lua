local var0_0 = import(".IslandRecEnergyEffect")
local var1_0 = class("IslandEffectView", import("..IslandBaseHudView"))
local var2_0 = {
	var0_0
}

function var1_0.GetUIName(arg0_1)
	return "IslandEffectUI"
end

function var1_0.OnInit(arg0_2, arg1_2)
	var1_0.super.OnInit(arg0_2, arg1_2)

	arg0_2.effects = {}

	for iter0_2, iter1_2 in ipairs(var2_0) do
		local var0_2 = iter1_2.New(arg0_2._tf)

		arg0_2.effects[var0_2:GetType()] = var0_2
	end
end

function var1_0.Play(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg0_3.effects[arg3_3]

	if var0_3 then
		var0_3:Play(arg1_3, arg2_3)
	end
end

function var1_0.OnLateUpdate(arg0_4)
	var1_0.super.OnLateUpdate(arg0_4)

	for iter0_4, iter1_4 in pairs(arg0_4.effects) do
		iter1_4:Update()
	end
end

function var1_0.OnDispose(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.effects or {}) do
		iter1_5:Dispose()
	end

	arg0_5.effects = nil

	var1_0.super.OnDispose(arg0_5)
end

return var1_0
