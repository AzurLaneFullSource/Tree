local var0 = class("CardPuzzleGift", BaseVO)

var0.TYPE = {
	GLOBAL = 1,
	USABLE = 3,
	BATTLE = 2
}
var0.EFFECT_TYPE = {
	COIN_BONUS = 5,
	GLOBAL_ATTRIBUTE_BONUS = 1,
	ROGUE_DROP_BONUS = 3,
	CARD_CLIPPING = 4,
	BATTLE_BUFF = 2
}

function var0.CreateByNetData(arg0)
	local var0 = {}

	for iter0 = 1, arg0.num do
		table.insert(var0, var0.New({
			configId = arg0.id
		}))
	end

	return var0
end

function var0.bindConfigTable(arg0)
	return pg.puzzle_relics_template
end

function var0.GetIconPath(arg0)
	return "roguegifts/" .. arg0:getConfig("icon")
end

function var0.GetConfigId(arg0)
	return arg0.configId
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("desc")
end

function var0.GetRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.GetEffects(arg0)
	local var0 = arg0:getConfig("arg_list")

	return _.map(var0, function(arg0)
		local var0 = pg.puzzle_relics_effect[arg0]

		assert(var0)

		return var0
	end)
end

function var0.GetAttributeBonus(arg0, arg1)
	local var0 = {}

	if arg0:GetType() ~= var0.TYPE.GLOBAL then
		return var0
	end

	for iter0, iter1 in ipairs(arg0:GetEffects()) do
		if iter1.type == var0.EFFECT_TYPE.GLOBAL_ATTRIBUTE_BONUS then
			for iter2, iter3 in ipairs(iter1.arg_list) do
				local var1 = iter3[1]
				local var2 = iter3[2]
				local var3 = iter3[3]

				if table.contains(var1, arg1:getShipType()) then
					table.insert(var0, {
						type = CardPuzzleShip.PROPERTIES[var2],
						value = var3
					})
				end
			end
		end
	end

	return var0
end

return var0
