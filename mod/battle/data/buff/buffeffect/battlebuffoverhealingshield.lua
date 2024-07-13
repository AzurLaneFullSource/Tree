ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffOverHealingShield = class("BattleBuffOverHealingShield", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffOverHealingShield.__name = "BattleBuffOverHealingShield"

local var1_0 = var0_0.Battle.BattleBuffOverHealingShield

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._shieldDuration = arg0_2._tempData.arg_list.shield_duration
	arg0_2._shieldRate = arg0_2._tempData.arg_list.shield_rate
	arg0_2._shieldLabel = arg0_2._tempData.arg_list.shield_tag_list or {}
	arg0_2._shieldList = {}
end

function var1_0.onOverHealing(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3.overHealing
	local var1_3 = math.ceil(var0_3 * arg0_3._shieldRate)

	if var1_3 > 0 then
		local var2_3 = pg.TimeMgr.GetInstance():GetCombatTime()

		table.insert(arg0_3._shieldList, {
			timeStamp = var2_3,
			value = var1_3
		})
	end

	arg0_3:updateLabelTag(arg1_3)
end

function var1_0.onUpdate(arg0_4, arg1_4, arg2_4)
	local var0_4 = #arg0_4._shieldList
	local var1_4 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_4._shieldDuration

	while var0_4 > 0 do
		if var1_4 >= arg0_4._shieldList[var0_4].timeStamp then
			table.remove(arg0_4._shieldList, var0_4)
		end

		var0_4 = var0_4 - 1
	end

	arg0_4:updateLabelTag(arg1_4)
end

function var1_0.onTakeDamage(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = #arg0_5._shieldList

	if arg0_5:damageCheck(arg3_5) and var0_5 > 0 then
		local var1_5 = arg3_5.damage
		local var2_5 = 0

		while var1_5 > 0 and var2_5 < var0_5 do
			var2_5 = var2_5 + 1

			local var3_5 = arg0_5._shieldList[var2_5].value

			if var1_5 <= var3_5 then
				arg0_5._shieldList[var2_5].value = var3_5 - var1_5
				var1_5 = 0
			else
				var1_5 = var1_5 - var3_5
				arg0_5._shieldList[var2_5].value = 0
			end
		end

		arg3_5.damage = var1_5

		while var0_5 > 0 do
			if arg0_5._shieldList[var0_5].value <= 0 then
				table.remove(arg0_5._shieldList, var0_5)
			end

			var0_5 = var0_5 - 1
		end

		arg0_5:updateLabelTag(arg1_5)
	end
end

function var1_0.updateLabelTag(arg0_6, arg1_6)
	if #arg0_6._shieldList <= 0 then
		for iter0_6, iter1_6 in ipairs(arg0_6._shieldLabel) do
			arg1_6:RemoveLabelTag(iter1_6)
		end
	elseif not arg1_6:ContainsLabelTag(arg0_6._shieldLabel) then
		for iter2_6, iter3_6 in ipairs(arg0_6._shieldLabel) do
			arg1_6:AddLabelTag(iter3_6)
		end
	end
end
