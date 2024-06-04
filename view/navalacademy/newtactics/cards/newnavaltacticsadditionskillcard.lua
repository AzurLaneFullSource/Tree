local var0 = class("NewNavalTacticsAdditionSkillCard", import(".NewNavalTacticsSkillCard"))

function var0.Update(arg0, arg1, arg2)
	local var0 = arg1.level
	local var1 = arg1:GetNextLevelExp()
	local var2 = arg1:GetExp()
	local var3 = arg1:IsMaxLevel()

	arg1:AddExp(arg2)

	local var4 = false

	if not var3 and arg1:IsMaxLevel() then
		var4 = true
	end

	local var5 = arg1:GetNextLevelExp()
	local var6 = arg1:GetExp()
	local var7 = arg1.level - var0
	local var8 = var7 > 0

	arg1.level = var0

	var0.super.Update(arg0, arg1, var7)

	if var4 then
		local var9 = var1 - var2

		arg0.nextTxt.text = var2 .. "+<color=#A9F548FF>" .. var9 .. "</color>/" .. var1
	elseif var8 then
		arg0.nextTxt.text = "0+<color=#A9F548FF>" .. var6 .. "</color>/" .. var5
	else
		arg0.nextTxt.text = var2 .. "+<color=#A9F548FF>" .. arg2 .. "</color>/" .. var1
	end
end

return var0
