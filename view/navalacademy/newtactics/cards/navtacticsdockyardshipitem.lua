local var0_0 = class("NavTacticsDockyardShipItem", import("view.ship.DockyardShipItem"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.empty = findTF(arg0_1.tr, "empty")
	arg0_1.recentTr = findTF(arg0_1.tr, "recent")

	setText(arg0_1.recentTr:Find("Text"), i18n("tactics_recent_ship_label"))
end

function var0_0.flush(arg0_2)
	var0_0.super.flush(arg0_2)

	local var0_2 = arg0_2.shipVO
	local var1_2 = tobool(var0_2)

	setActive(arg0_2.empty, not var1_2)
	setActive(arg0_2.quit, false)
	setActive(arg0_2.recentTr, false)
	setActive(arg0_2.iconStatus, false)
end

function var0_0.clear(arg0_3)
	var0_0.super.clear(arg0_3)
	setActive(arg0_3.recentTr, false)
end

return var0_0
