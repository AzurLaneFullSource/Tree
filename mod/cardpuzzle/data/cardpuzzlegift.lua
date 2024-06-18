local var0_0 = class("CardPuzzleGift", BaseVO)

var0_0.TYPE = {
	GLOBAL = 1,
	USABLE = 3,
	BATTLE = 2
}
var0_0.EFFECT_TYPE = {
	COIN_BONUS = 5,
	GLOBAL_ATTRIBUTE_BONUS = 1,
	ROGUE_DROP_BONUS = 3,
	CARD_CLIPPING = 4,
	BATTLE_BUFF = 2
}

function var0_0.CreateByNetData(arg0_1)
	local var0_1 = {}

	for iter0_1 = 1, arg0_1.num do
		table.insert(var0_1, var0_0.New({
			configId = arg0_1.id
		}))
	end

	return var0_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.puzzle_relics_template
end

function var0_0.GetIconPath(arg0_3)
	return "roguegifts/" .. arg0_3:getConfig("icon")
end

function var0_0.GetConfigId(arg0_4)
	return arg0_4.configId
end

function var0_0.GetName(arg0_5)
	return arg0_5:getConfig("name")
end

function var0_0.GetType(arg0_6)
	return arg0_6:getConfig("type")
end

function var0_0.GetDesc(arg0_7)
	return arg0_7:getConfig("desc")
end

function var0_0.GetRarity(arg0_8)
	return arg0_8:getConfig("rarity")
end

function var0_0.GetEffects(arg0_9)
	local var0_9 = arg0_9:getConfig("arg_list")

	return _.map(var0_9, function(arg0_10)
		local var0_10 = pg.puzzle_relics_effect[arg0_10]

		assert(var0_10)

		return var0_10
	end)
end

function var0_0.GetAttributeBonus(arg0_11, arg1_11)
	local var0_11 = {}

	if arg0_11:GetType() ~= var0_0.TYPE.GLOBAL then
		return var0_11
	end

	for iter0_11, iter1_11 in ipairs(arg0_11:GetEffects()) do
		if iter1_11.type == var0_0.EFFECT_TYPE.GLOBAL_ATTRIBUTE_BONUS then
			for iter2_11, iter3_11 in ipairs(iter1_11.arg_list) do
				local var1_11 = iter3_11[1]
				local var2_11 = iter3_11[2]
				local var3_11 = iter3_11[3]

				if table.contains(var1_11, arg1_11:getShipType()) then
					table.insert(var0_11, {
						type = CardPuzzleShip.PROPERTIES[var2_11],
						value = var3_11
					})
				end
			end
		end
	end

	return var0_11
end

return var0_0
