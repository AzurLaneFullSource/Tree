local var0_0 = class("BossRushSardiniaFleetSelectView", import("view.activity.BossRush.BossRushFleetSelectView"))

function var0_0.GetTextColor(arg0_1)
	return Color.NewHex("FFFFFF"), Color.NewHex("939494")
end

function var0_0.getUIName(arg0_2)
	return "BossRushSardiniaFleetSelectUI"
end

function var0_0.tempCache(arg0_3)
	return true
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)
	removeOnButton(arg0_4._tf:Find("BG"))
	setText(arg0_4.btnGo:Find("Text"), i18n("zengke_series_confirm"))
	onButton(arg0_4, arg0_4._tf:Find("BG/close"), function()
		arg0_4:onCancelHard()
	end, SFX_CANCEL)
end

return var0_0
