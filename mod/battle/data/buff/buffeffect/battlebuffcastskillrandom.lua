ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleAttr

var0.Battle.BattleBuffCastSkillRandom = class("BattleBuffCastSkillRandom", var0.Battle.BattleBuffCastSkill)
var0.Battle.BattleBuffCastSkillRandom.__name = "BattleBuffCastSkillRandom"

local var2 = var0.Battle.BattleBuffCastSkillRandom

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)

	arg0._skillList = {}
end

function var2.spell(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	if var0.skill_id_list then
		local var1 = {}
		local var2 = var0.range

		for iter0, iter1 in ipairs(var0.skill_id_list) do
			var1[iter1] = var2[iter0]
		end

		local var3 = math.random()

		for iter2, iter3 in pairs(var1) do
			local var4 = iter3[1]
			local var5 = iter3[2]

			if var4 <= var3 and var3 < var5 then
				arg0._skillList[iter2] = arg0._skillList[iter2] or var0.Battle.BattleSkillUnit.GenerateSpell(iter2, arg0._level, arg1, attData)

				local var6 = arg0._skillList[iter2]

				if arg2 and arg2.target then
					var6:SetTarget({
						arg2.target
					})
				end

				var6:Cast(arg1, arg0._commander)
			end
		end
	elseif var0.random_skill_tag then
		local var7 = var0.random_skill_tag
		local var8 = arg1:GetLabelTag()
		local var9 = {}

		for iter4, iter5 in ipairs(var8) do
			local var10, var11 = string.find(iter5, var7)

			if var10 then
				local var12 = tonumber(string.sub(iter5, var11 + 1, #iter5))

				if not table.contains(var9, var12) then
					table.insert(var9, var12)
				end
			end
		end

		if #var9 > 0 then
			local var13 = var9[math.random(#var9)]

			arg0._skillList[var13] = arg0._skillList[var13] or var0.Battle.BattleSkillUnit.GenerateSpell(var13, arg0._level, arg1, attData)

			local var14 = arg0._skillList[var13]

			if arg2 and arg2.target then
				var14:SetTarget({
					arg2.target
				})
			end

			var14:Cast(arg1, arg0._commander)
		end
	end
end

function var2.Clear(arg0)
	var2.super.Clear(arg0)

	for iter0, iter1 in pairs(arg0._skillList) do
		iter1:Clear()
	end
end
