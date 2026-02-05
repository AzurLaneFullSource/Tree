local var0_0 = class("IslandTradeActivityPage", import("Mod.Island.View.page.activity.IslandBaseActivityPage"))

function var0_0.OnInit(arg0_1)
	setText(arg0_1._tf:Find("bg/desc_1"), i18n("island_trade_activity_desc_1"))
	setText(arg0_1._tf:Find("bg/desc_2"), i18n("island_trade_activity_desc_2"))
	setText(arg0_1._tf:Find("bg/level/Text"), i18n("island_trade_activity_unlock"))
end

return var0_0
