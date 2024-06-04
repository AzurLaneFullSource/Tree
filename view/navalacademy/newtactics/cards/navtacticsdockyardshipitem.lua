local var0 = class("NavTacticsDockyardShipItem", import("view.ship.DockyardShipItem"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.empty = findTF(arg0.tr, "empty")
	arg0.recentTr = findTF(arg0.tr, "recent")

	setText(arg0.recentTr:Find("Text"), i18n("tactics_recent_ship_label"))
end

function var0.flush(arg0)
	var0.super.flush(arg0)

	local var0 = arg0.shipVO
	local var1 = tobool(var0)

	setActive(arg0.empty, not var1)
	setActive(arg0.quit, false)
	setActive(arg0.recentTr, false)
	setActive(arg0.iconStatus, false)
end

function var0.clear(arg0)
	var0.super.clear(arg0)
	setActive(arg0.recentTr, false)
end

return var0
