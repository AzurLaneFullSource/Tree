local var0_0 = class("NavTacticsDockyardScene", import("view.ship.DockyardScene"))
local var1_0 = 7

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)

	arg0_1.toggleTr = arg0_1:findTF("toggle_nav")
	arg0_1.toggleOnTr = arg0_1.toggleTr:Find("on")
	arg0_1.toggleOffTr = arg0_1.toggleTr:Find("off")

	setActive(arg0_1.toggleTr, true)
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)

	local function var0_2()
		local var0_3 = arg0_2.isShowRecent

		setActive(arg0_2.toggleOnTr, var0_3)
		setActive(arg0_2.toggleOffTr, not var0_3)
	end

	arg0_2.isShowRecent = false

	onButton(arg0_2, arg0_2.toggleTr, function()
		local var0_4 = arg0_2:CollectionRecentShips()

		if #var0_4 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_recent_ships"))

			return
		end

		arg0_2.isShowRecent = not arg0_2.isShowRecent
		var0_0.ToggleOn = arg0_2.isShowRecent

		var0_2()
		arg0_2:OnRecentShips(var0_4)
	end, SFX_PANEL)

	local var1_2 = var0_0.ToggleOn

	if var1_2 and #arg0_2:CollectionRecentShips() == 0 then
		var1_2 = false
	end

	if var1_2 then
		triggerButton(arg0_2.toggleTr)
	else
		local var2_2 = arg0_2:CollectionRecentShips()

		var0_2()
		arg0_2:OnRecentShips(var2_2)
	end
end

function var0_0.GetCard(arg0_5, arg1_5)
	return NavTacticsDockyardShipItem.New(arg1_5, arg0_5.contextData.hideTagFlags, arg0_5.contextData.blockTagFlags)
end

function var0_0.OnClickCard(arg0_6, arg1_6)
	if arg1_6.shipVO then
		var0_0.super.OnClickCard(arg0_6, arg1_6)
	end
end

function var0_0.onUpdateItem(arg0_7, arg1_7, arg2_7)
	var0_0.super.onUpdateItem(arg0_7, arg1_7, arg2_7)

	if arg0_7.isShowRecent and arg1_7 + 1 <= var1_0 then
		local var0_7 = arg0_7.scrollItems[arg2_7]

		setActive(var0_7.recentTr, arg0_7.shipVOs[arg1_7 + 1])
	end
end

function var0_0.OnRecentShips(arg0_8, arg1_8)
	arg0_8.recentShips = arg1_8

	if #arg0_8.recentShips > 0 then
		arg0_8:filter()
	end
end

function var0_0.updateShipCount(arg0_9, arg1_9)
	if arg0_9.isShowRecent and #arg0_9.recentShips > 0 then
		for iter0_9 = #arg0_9.recentShips + 1, var1_0 do
			table.insert(arg0_9.shipVOs, 1, false)
		end

		for iter1_9 = #arg0_9.recentShips, 1, -1 do
			local var0_9 = arg0_9.recentShips[iter1_9]

			table.insert(arg0_9.shipVOs, 1, var0_9)
		end

		var0_0.super.updateShipCount(arg0_9, arg1_9)
	else
		var0_0.super.updateShipCount(arg0_9, arg1_9)
	end
end

function var0_0.CollectionRecentShips(arg0_10)
	local var0_10 = {}
	local var1_10 = getProxy(NavalAcademyProxy):GetRecentShips()

	for iter0_10 = #var1_10, 1, -1 do
		if #var0_10 == var1_0 then
			break
		end

		local var2_10 = tonumber(var1_10[iter0_10])

		if var2_10 > 0 and arg0_10.shipVOsById[var2_10] then
			table.insert(var0_10, arg0_10.shipVOsById[var2_10])
		end
	end

	return var0_10
end

function var0_0.willExit(arg0_11)
	var0_0.super.willExit(arg0_11)
	setActive(arg0_11.toggleTr, false)
end

return var0_0
