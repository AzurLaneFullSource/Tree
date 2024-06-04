ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffOverHealingShield = class("BattleBuffOverHealingShield", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffOverHealingShield.__name = "BattleBuffOverHealingShield"

local var1 = var0.Battle.BattleBuffOverHealingShield

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._shieldDuration = arg0._tempData.arg_list.shield_duration
	arg0._shieldRate = arg0._tempData.arg_list.shield_rate
	arg0._shieldLabel = arg0._tempData.arg_list.shield_tag_list or {}
	arg0._shieldList = {}
end

function var1.onOverHealing(arg0, arg1, arg2, arg3)
	local var0 = arg3.overHealing
	local var1 = math.ceil(var0 * arg0._shieldRate)

	if var1 > 0 then
		local var2 = pg.TimeMgr.GetInstance():GetCombatTime()

		table.insert(arg0._shieldList, {
			timeStamp = var2,
			value = var1
		})
	end

	arg0:updateLabelTag(arg1)
end

function var1.onUpdate(arg0, arg1, arg2)
	local var0 = #arg0._shieldList
	local var1 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._shieldDuration

	while var0 > 0 do
		if var1 >= arg0._shieldList[var0].timeStamp then
			table.remove(arg0._shieldList, var0)
		end

		var0 = var0 - 1
	end

	arg0:updateLabelTag(arg1)
end

function var1.onTakeDamage(arg0, arg1, arg2, arg3)
	local var0 = #arg0._shieldList

	if arg0:damageCheck(arg3) and var0 > 0 then
		local var1 = arg3.damage
		local var2 = 0

		while var1 > 0 and var2 < var0 do
			var2 = var2 + 1

			local var3 = arg0._shieldList[var2].value

			if var1 <= var3 then
				arg0._shieldList[var2].value = var3 - var1
				var1 = 0
			else
				var1 = var1 - var3
				arg0._shieldList[var2].value = 0
			end
		end

		arg3.damage = var1

		while var0 > 0 do
			if arg0._shieldList[var0].value <= 0 then
				table.remove(arg0._shieldList, var0)
			end

			var0 = var0 - 1
		end

		arg0:updateLabelTag(arg1)
	end
end

function var1.updateLabelTag(arg0, arg1)
	if #arg0._shieldList <= 0 then
		for iter0, iter1 in ipairs(arg0._shieldLabel) do
			arg1:RemoveLabelTag(iter1)
		end
	elseif not arg1:ContainsLabelTag(arg0._shieldLabel) then
		for iter2, iter3 in ipairs(arg0._shieldLabel) do
			arg1:AddLabelTag(iter3)
		end
	end
end
