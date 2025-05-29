local var0_0 = class("PlayerVitaeDockyardScene", import("view.ship.DockyardScene"))

function var0_0.SortShips(arg0_1, arg1_1)
	local var0_1 = getProxy(PlayerProxy):getRawData().characters
	local var1_1 = {}
	local var2_1 = #var0_1 + 1

	for iter0_1, iter1_1 in ipairs(var0_1) do
		var1_1[iter1_1] = var2_1 - iter0_1
	end

	table.insert(arg1_1, function(arg0_2)
		return -(var1_1[arg0_2.id] or 0)
	end)
	table.sort(arg0_1.shipVOs, CompareFuncs(arg1_1))
end

function var0_0.init(arg0_3)
	var0_0.super.init(arg0_3)

	arg0_3.selectedMarks = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.contextData.selectedMarks) do
		local var0_3, var1_3 = ShipPhantom.UnpackMark(iter1_3)

		if var1_3 == 0 then
			table.insert(arg0_3.selectedIds, var0_3)
		else
			table.insert(arg0_3.selectedMarks, iter1_3)
		end
	end

	arg0_3.contextData.selectedMarks = nil

	setActive(arg0_3.togglePhantom, true)
end

function var0_0.OnClickPhantom(arg0_4, arg1_4)
	if arg1_4.phantomId == 0 then
		arg0_4:selectShip(arg1_4)
	else
		arg0_4:selectPhantom(arg1_4)
	end
end

function var0_0.selectPhantom(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetShipPhantomMark()
	local var1_5 = false
	local var2_5

	for iter0_5, iter1_5 in ipairs(arg0_5.selectedMarks) do
		if iter1_5 == var0_5 then
			var1_5 = true
			var2_5 = iter0_5

			break
		end
	end

	if var1_5 or arg0_5.selectedMax == 1 and arg0_5:GetSelectCount() > 0 then
		local var3_5 = defaultValue(var2_5, 1)
		local var4_5 = getProxy(BayProxy):GetShipPhantom(arg0_5.selectedMarks[var3_5])
		local var5_5, var6_5 = arg0_5.onCancelShip(var4_5, function()
			if not arg0_5.exited then
				return
			end

			arg0_5:selectPhantom(arg1_5)
		end, arg0_5.selectedMarks)

		if not var5_5 then
			if var6_5 then
				pg.TipsMgr.GetInstance():ShowTips(var6_5)
			end

			return
		end

		table.remove(arg0_5.selectedMarks, var3_5)
	end

	if not var1_5 then
		local var7_5, var8_5 = arg0_5.checkShip(arg1_5, function()
			if arg0_5.exited then
				return
			end

			arg0_5:selectPhantom(arg1_5)
		end, arg0_5.selectedMarks)

		if not var7_5 then
			if var8_5 then
				pg.TipsMgr.GetInstance():ShowTips(var8_5)
			end

			return
		end

		if arg0_5.selectedMax == 0 or arg0_5:GetSelectCount() < arg0_5.selectedMax then
			table.insert(arg0_5.selectedMarks, var0_5)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleLess", arg0_5.selectedMax))

			return
		end
	end

	arg0_5:updateSelected()

	if arg0_5.contextData.mode == var0_0.MODE_DESTROY then
		arg0_5:updateDestroyRes()
	elseif arg0_5.contextData.mode == var0_0.MODE_MOD then
		arg0_5:updateModAttr()
	end

	arg0_5:UpdateGuildViewEquipmentsBtn()
end

function var0_0.GetSelectCount(arg0_8)
	return #arg0_8.selectedIds + #arg0_8.selectedMarks
end

function var0_0.GetConfirmSelect(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.selectedIds) do
		table.insert(var0_9, ShipPhantom.PackMark(iter1_9, 0))
	end

	table.insertto(var0_9, arg0_9.selectedMarks)

	return var0_9
end

return var0_0
