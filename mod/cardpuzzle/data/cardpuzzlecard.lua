local var0 = class("CardPuzzleCard", BaseVO)

var0.CARD_TYPE = {
	ATTACK = 1,
	ABILITY = 3,
	TACTIC = 2
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
	return pg.card_template
end

function var0.GetIconPath(arg0)
	return var0.GetCardIconPath(arg0:getConfig("icon"))
end

function var0.GetConfigId(arg0)
	return arg0.configId
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetCost(arg0)
	return arg0:getConfig("cost")
end

function var0.GetType(arg0)
	return arg0:getConfig("card_type")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("discript")
end

function var0.GetRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.GetEffects(arg0)
	return {
		{
			keywords = {}
		}
	}
end

function var0.GetKeywords(arg0)
	return var0.GetCardKeyWord(arg0:getConfig("label"))
end

function var0.GetCardKeyWord(arg0)
	return _.map(arg0, function(arg0)
		return pg.puzzle_card_affix[arg0]
	end)
end

function var0.GetCardIconPath(arg0)
	return "RogueCards/" .. arg0
end

return var0
