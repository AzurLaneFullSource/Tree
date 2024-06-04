local var0 = class("NavTacticsDockyardScene", import("view.ship.DockyardScene"))
local var1 = 7

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.toggleTr = arg0:findTF("toggle_nav")
	arg0.toggleOnTr = arg0.toggleTr:Find("on")
	arg0.toggleOffTr = arg0.toggleTr:Find("off")

	setActive(arg0.toggleTr, true)
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)

	local function var0()
		local var0 = arg0.isShowRecent

		setActive(arg0.toggleOnTr, var0)
		setActive(arg0.toggleOffTr, not var0)
	end

	arg0.isShowRecent = false

	onButton(arg0, arg0.toggleTr, function()
		local var0 = arg0:CollectionRecentShips()

		if #var0 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_recent_ships"))

			return
		end

		arg0.isShowRecent = not arg0.isShowRecent
		var0.ToggleOn = arg0.isShowRecent

		var0()
		arg0:OnRecentShips(var0)
	end, SFX_PANEL)

	local var1 = var0.ToggleOn

	if var1 and #arg0:CollectionRecentShips() == 0 then
		var1 = false
	end

	if var1 then
		triggerButton(arg0.toggleTr)
	else
		local var2 = arg0:CollectionRecentShips()

		var0()
		arg0:OnRecentShips(var2)
	end
end

function var0.GetCard(arg0, arg1)
	return NavTacticsDockyardShipItem.New(arg1, arg0.contextData.hideTagFlags, arg0.contextData.blockTagFlags)
end

function var0.OnClickCard(arg0, arg1)
	if arg1.shipVO then
		var0.super.OnClickCard(arg0, arg1)
	end
end

function var0.onUpdateItem(arg0, arg1, arg2)
	var0.super.onUpdateItem(arg0, arg1, arg2)

	if arg0.isShowRecent and arg1 + 1 <= var1 then
		local var0 = arg0.scrollItems[arg2]

		setActive(var0.recentTr, arg0.shipVOs[arg1 + 1])
	end
end

function var0.OnRecentShips(arg0, arg1)
	arg0.recentShips = arg1

	if #arg0.recentShips > 0 then
		arg0:filter()
	end
end

function var0.updateShipCount(arg0, arg1)
	if arg0.isShowRecent and #arg0.recentShips > 0 then
		for iter0 = #arg0.recentShips + 1, var1 do
			table.insert(arg0.shipVOs, 1, false)
		end

		for iter1 = #arg0.recentShips, 1, -1 do
			local var0 = arg0.recentShips[iter1]

			table.insert(arg0.shipVOs, 1, var0)
		end

		var0.super.updateShipCount(arg0, arg1)
	else
		var0.super.updateShipCount(arg0, arg1)
	end
end

function var0.CollectionRecentShips(arg0)
	local var0 = {}
	local var1 = getProxy(NavalAcademyProxy):GetRecentShips()

	for iter0 = #var1, 1, -1 do
		if #var0 == var1 then
			break
		end

		local var2 = tonumber(var1[iter0])

		if var2 > 0 and arg0.shipVOsById[var2] then
			table.insert(var0, arg0.shipVOsById[var2])
		end
	end

	return var0
end

function var0.willExit(arg0)
	var0.super.willExit(arg0)
	setActive(arg0.toggleTr, false)
end

return var0
