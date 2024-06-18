ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleAttr

var0_0.Battle.BattleBuffCastSkillRandom = class("BattleBuffCastSkillRandom", var0_0.Battle.BattleBuffCastSkill)
var0_0.Battle.BattleBuffCastSkillRandom.__name = "BattleBuffCastSkillRandom"

local var2_0 = var0_0.Battle.BattleBuffCastSkillRandom

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._skillList = {}
end

function var2_0.spell(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	if var0_2.skill_id_list then
		local var1_2 = {}
		local var2_2 = var0_2.range

		for iter0_2, iter1_2 in ipairs(var0_2.skill_id_list) do
			var1_2[iter1_2] = var2_2[iter0_2]
		end

		local var3_2 = math.random()

		for iter2_2, iter3_2 in pairs(var1_2) do
			local var4_2 = iter3_2[1]
			local var5_2 = iter3_2[2]

			if var4_2 <= var3_2 and var3_2 < var5_2 then
				arg0_2._skillList[iter2_2] = arg0_2._skillList[iter2_2] or var0_0.Battle.BattleSkillUnit.GenerateSpell(iter2_2, arg0_2._level, arg1_2, attData)

				local var6_2 = arg0_2._skillList[iter2_2]

				if arg2_2 and arg2_2.target then
					var6_2:SetTarget({
						arg2_2.target
					})
				end

				var6_2:Cast(arg1_2, arg0_2._commander)
			end
		end
	elseif var0_2.random_skill_tag then
		local var7_2 = var0_2.random_skill_tag
		local var8_2 = arg1_2:GetLabelTag()
		local var9_2 = {}

		for iter4_2, iter5_2 in ipairs(var8_2) do
			local var10_2, var11_2 = string.find(iter5_2, var7_2)

			if var10_2 then
				local var12_2 = tonumber(string.sub(iter5_2, var11_2 + 1, #iter5_2))

				if not table.contains(var9_2, var12_2) then
					table.insert(var9_2, var12_2)
				end
			end
		end

		if #var9_2 > 0 then
			local var13_2 = var9_2[math.random(#var9_2)]

			arg0_2._skillList[var13_2] = arg0_2._skillList[var13_2] or var0_0.Battle.BattleSkillUnit.GenerateSpell(var13_2, arg0_2._level, arg1_2, attData)

			local var14_2 = arg0_2._skillList[var13_2]

			if arg2_2 and arg2_2.target then
				var14_2:SetTarget({
					arg2_2.target
				})
			end

			var14_2:Cast(arg1_2, arg0_2._commander)
		end
	end
end

function var2_0.Clear(arg0_3)
	var2_0.super.Clear(arg0_3)

	for iter0_3, iter1_3 in pairs(arg0_3._skillList) do
		iter1_3:Clear()
	end
end
