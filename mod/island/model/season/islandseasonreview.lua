local var0_0 = class("IslandSeasonReview", import("model.vo.BaseVO"))

var0_0.KEYS = {
	PT = 4,
	MINIGAME = 9,
	FORMULA = 7,
	TECHNOLOGY = 3,
	FISHING = 8,
	ORDER = 6,
	LEVEL = 1,
	SHIP = 2,
	PT_RANK = 5
}
var0_0.KEY2NAME = {
	[var0_0.KEYS.LEVEL] = i18n("island_season_charts_level"),
	[var0_0.KEYS.SHIP] = i18n("island_season_review_charnum"),
	[var0_0.KEYS.TECHNOLOGY] = i18n("island_season_review_projuctnum"),
	[var0_0.KEYS.PT] = i18n("island_season_review_ptnum"),
	[var0_0.KEYS.PT_RANK] = i18n("island_season_review_ptrank"),
	[var0_0.KEYS.ORDER] = i18n("island_season_review_ordernum"),
	[var0_0.KEYS.FORMULA] = i18n("island_season_review_formulanum"),
	[var0_0.KEYS.FISHING] = i18n("island_season_review_fishnum"),
	[var0_0.KEYS.MINIGAME] = i18n("island_season_review_gamenum")
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.data = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.count_list or {}) do
		arg0_1.data[iter1_1.key] = iter1_1.value
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_season
end

function var0_0.GetRecordData(arg0_3, arg1_3)
	return arg0_3.data[arg1_3] or 0
end

return var0_0
