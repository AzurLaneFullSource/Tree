local var0_0 = class("BossRushDALFleetSelectView", import("..BossRushFleetSelectView"))

function var0_0.getUIName(arg0_1)
	return "BossRushFleetSelectUIDALCollab"
end

function var0_0.InitUI(arg0_2)
	var0_0.super.InitUI(arg0_2)
	setText(arg0_2._tf:Find("Panel/Info/Start/text"), i18n("dal_chapter_goto"))
end

return var0_0
