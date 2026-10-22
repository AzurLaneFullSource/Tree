local var0_0 = class("QiShengLitUI", import(".MainPaintingLitUI"))
local var1_0 = {
	["Particle System_1"] = {
		max_particle = 20,
		translate = true
	},
	["Particle System_2"] = {
		max_particle = 20,
		translate = false
	}
}

function var0_0.initLitUI(arg0_1, arg1_1)
	var0_0.super.initLitUI(arg0_1, arg1_1)

	arg0_1._particleTable = {}

	for iter0_1, iter1_1 in pairs(var1_0) do
		local var0_1 = findTF(arg0_1._tf, "ad/effect/" .. iter0_1)

		arg0_1._particleTable[iter0_1] = GetComponent(var0_1, "ParticleSystem")
	end
end

function var0_0.UpdateLit(arg0_2)
	var0_0.super.UpdateLit(arg0_2)
	arg0_2:updateEffect()
end

function var0_0.updateEffect(arg0_3)
	local var0_3 = SpinePaintingConst.painting_lit_value

	for iter0_3, iter1_3 in pairs(var1_0) do
		local var1_3 = arg0_3._particleTable[iter0_3]
		local var2_3 = iter1_3.translate
		local var3_3

		if var2_3 then
			var3_3 = iter1_3.max_particle * (1 - var0_3)
		else
			var3_3 = iter1_3.max_particle * var0_3
		end

		if var3_3 then
			var1_3.main.maxParticles = var3_3
		end
	end
end

return var0_0
