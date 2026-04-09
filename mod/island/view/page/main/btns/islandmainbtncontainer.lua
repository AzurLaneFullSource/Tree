local var0_0 = class("IslandMainBtnContainer")

var0_0.SPECIAL_BTN = {
	season = "IslandMainSeasonBtn",
	technology = "IslandMainTechnologyBtn"
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1.event = arg2_1
	arg0_1.tpl = arg0_1._tf:Find("tpl")

	setActive(arg0_1.tpl, false)
	arg0_1:InitBtns()
end

function var0_0.InitBtns(arg0_2)
	arg0_2.btns = {}
	arg0_2.unlockIds = {}

	local var0_2 = pg.island_main_btns.get_id_list_by_main_type[1]

	table.sort(var0_2, CompareFuncs({
		function(arg0_3)
			return pg.island_main_btns[arg0_3].order
		end,
		function(arg0_4)
			return arg0_4
		end
	}))

	for iter0_2, iter1_2 in ipairs(var0_2) do
		local var1_2 = pg.island_main_btns[iter1_2]

		table.insert(arg0_2.unlockIds, var1_2.ability_id)

		local var2_2 = var1_2.btn_name

		if var0_0.SPECIAL_BTN[var2_2] then
			local var3_2 = var0_0.SPECIAL_BTN[var2_2]

			arg0_2.btns[var2_2] = _G[var3_2].New(arg0_2._tf:Find(var2_2), arg0_2.event, iter1_2)
		else
			arg0_2.btns[var2_2] = IslandMainBaseBtn.New(cloneTplTo(arg0_2.tpl, arg0_2._tf), arg0_2.event, iter1_2)
		end

		arg0_2.btns[var2_2]:SetAsLastSibling()
	end

	arg0_2:Flush()
end

function var0_0.OnUnlockSystem(arg0_5, arg1_5)
	if table.contains(arg0_5.unlockIds, arg1_5) then
		for iter0_5, iter1_5 in pairs(arg0_5.btns) do
			iter1_5:UnlockCheck()
		end
	end
end

function var0_0.OnTrackTaskChange(arg0_6)
	local var0_6 = arg0_6.btns.map

	if var0_6 and var0_6:IsUnlock() then
		var0_6:TipCheck()
	end
end

function var0_0.OnFinishDelegation(arg0_7)
	local var0_7 = arg0_7.btns.technology

	if var0_7 and var0_7:IsUnlock() then
		var0_7:TipCheck()
		var0_7:StatusCheck()
	end
end

function var0_0.OnUnlockTechnology(arg0_8)
	local var0_8 = arg0_8.btns.technology

	if var0_8 and var0_8:IsUnlock() then
		var0_8:StatusCheck()
	end
end

function var0_0.Flush(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.btns) do
		iter1_9:Flush()
	end
end

function var0_0.ActiveOrDisactive(arg0_10, arg1_10)
	setActive(arg0_10._tf, arg1_10)
end

function var0_0.Dispose(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.btns) do
		iter1_11:Dispose()
	end

	arg0_11.btns = nil
end

return var0_0
