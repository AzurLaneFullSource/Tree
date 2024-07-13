local var0_0 = class("NewNavalTacticsAdditionSkillCard", import(".NewNavalTacticsSkillCard"))

function var0_0.Update(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1.level
	local var1_1 = arg1_1:GetNextLevelExp()
	local var2_1 = arg1_1:GetExp()
	local var3_1 = arg1_1:IsMaxLevel()

	arg1_1:AddExp(arg2_1)

	local var4_1 = false

	if not var3_1 and arg1_1:IsMaxLevel() then
		var4_1 = true
	end

	local var5_1 = arg1_1:GetNextLevelExp()
	local var6_1 = arg1_1:GetExp()
	local var7_1 = arg1_1.level - var0_1
	local var8_1 = var7_1 > 0

	arg1_1.level = var0_1

	var0_0.super.Update(arg0_1, arg1_1, var7_1)

	if var4_1 then
		local var9_1 = var1_1 - var2_1

		arg0_1.nextTxt.text = var2_1 .. "+<color=#A9F548FF>" .. var9_1 .. "</color>/" .. var1_1
	elseif var8_1 then
		arg0_1.nextTxt.text = "0+<color=#A9F548FF>" .. var6_1 .. "</color>/" .. var5_1
	else
		arg0_1.nextTxt.text = var2_1 .. "+<color=#A9F548FF>" .. arg2_1 .. "</color>/" .. var1_1
	end
end

return var0_0
