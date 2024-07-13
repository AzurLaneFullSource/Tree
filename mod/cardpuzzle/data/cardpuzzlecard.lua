local var0_0 = class("CardPuzzleCard", BaseVO)

var0_0.CARD_TYPE = {
	ATTACK = 1,
	ABILITY = 3,
	TACTIC = 2
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
	return pg.card_template
end

function var0_0.GetIconPath(arg0_3)
	return var0_0.GetCardIconPath(arg0_3:getConfig("icon"))
end

function var0_0.GetConfigId(arg0_4)
	return arg0_4.configId
end

function var0_0.GetName(arg0_5)
	return arg0_5:getConfig("name")
end

function var0_0.GetCost(arg0_6)
	return arg0_6:getConfig("cost")
end

function var0_0.GetType(arg0_7)
	return arg0_7:getConfig("card_type")
end

function var0_0.GetDesc(arg0_8)
	return arg0_8:getConfig("discript")
end

function var0_0.GetRarity(arg0_9)
	return arg0_9:getConfig("rarity")
end

function var0_0.GetEffects(arg0_10)
	return {
		{
			keywords = {}
		}
	}
end

function var0_0.GetKeywords(arg0_11)
	return var0_0.GetCardKeyWord(arg0_11:getConfig("label"))
end

function var0_0.GetCardKeyWord(arg0_12)
	return _.map(arg0_12, function(arg0_13)
		return pg.puzzle_card_affix[arg0_13]
	end)
end

function var0_0.GetCardIconPath(arg0_14)
	return "RogueCards/" .. arg0_14
end

return var0_0
