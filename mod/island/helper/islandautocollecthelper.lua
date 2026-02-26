local var0_0 = class("IslandAutoCollectHelper")

var0_0.SelectType = {
	Gather = 3,
	HandCollection = 2,
	Both = 4,
	None = 1
}
var0_0.CostTipList = {
	i18n("island_chara_gather_power"),
	i18n("island_chara_gather_money")
}

function var0_0.GetAttributeReducePercent(arg0_1)
	local var0_1 = IslandProductTimeHelper.GetAttributeGradeId(arg0_1, IslandShipAttr.COLLECT_KEY)

	return pg.island_chara_att[var0_1].gather_effect
end

return var0_0
