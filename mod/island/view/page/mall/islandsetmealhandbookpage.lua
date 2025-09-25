local var0_0 = class("IslandSetMealHandbookPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandSetMealHandbookUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("top/back")
	arg0_2.setMealList = UIItemList.New(arg0_2._tf:Find("setMealList/Viewport/Content"), arg0_2._tf:Find("setMealList/Viewport/Content/setMealTpl"))
	arg0_2.detail = arg0_2._tf:Find("detail")
	arg0_2.detailName = arg0_2.detail:Find("name")
	arg0_2.formulaList1 = arg0_2.detail:Find("formulaList1")
	arg0_2.formulaList2 = arg0_2.detail:Find("formulaList2")
	arg0_2.detailDesc = arg0_2.detail:Find("desc")
	arg0_2.conditionList = UIItemList.New(arg0_2.detail:Find("conditionList"), arg0_2.detail:Find("conditionList/condition"))

	setActive(arg0_2.detail, false)
	setText(arg0_2._tf:Find("top/title/Text"), i18n1("套餐图鉴"))
	setText(arg0_2._tf:Find("top/title/Text/en"), i18n1("HANDBOOK"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3:InitData()
end

function var0_0.InitData(arg0_5)
	arg0_5.formulaNums = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()
	arg0_5.formulas = {}

	for iter0_5, iter1_5 in ipairs(pg.island_combo.all) do
		local var0_5 = Clone(pg.island_formula[iter1_5])

		var0_5.unlock_condition = pg.island_combo[iter1_5].unlock_condition
		var0_5.is_hide = pg.island_combo[iter1_5].is_hide

		table.insert(arg0_5.formulas, var0_5)
	end

	table.sort(arg0_5.formulas, CompareFuncs({
		function(arg0_6)
			local var0_6 = arg0_6
			local var1_6 = var0_6.is_hide == 1
			local var2_6 = true
			local var3_6 = true

			for iter0_6, iter1_6 in ipairs(var0_6.unlock_condition) do
				local var4_6 = iter1_6[1]
				local var5_6 = iter1_6[2]

				if not arg0_5.formulaNums[var4_6] or arg0_5.formulaNums[var4_6] < 1 then
					var2_6 = false
				end

				if not arg0_5.formulaNums[var4_6] or var5_6 > arg0_5.formulaNums[var4_6] then
					var3_6 = false
				end
			end

			return (not var1_6 and var2_6 or var1_6 and var3_6) and 0 or 1
		end,
		function(arg0_7)
			return arg0_7.id
		end
	}))
end

function var0_0.SetFormulaList(arg0_8)
	arg0_8.setMealList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_8.formulas[arg1_9 + 1]
			local var1_9 = var0_9.is_hide == 1
			local var2_9 = true
			local var3_9 = true

			for iter0_9, iter1_9 in ipairs(var0_9.unlock_condition) do
				local var4_9 = iter1_9[1]
				local var5_9 = iter1_9[2]

				if not arg0_8.formulaNums[var4_9] or arg0_8.formulaNums[var4_9] < 1 then
					var2_9 = false
				end

				if not arg0_8.formulaNums[var4_9] or var5_9 > arg0_8.formulaNums[var4_9] then
					var3_9 = false
				end
			end

			local var6_9 = not var1_9 and var2_9 or var1_9 and var3_9

			setActive(arg2_9:Find("special"), var1_9 and var3_9)
			setActive(arg2_9:Find("name"), var6_9)
			setActive(arg2_9:Find("IslandItemTpl"), var6_9)
			setActive(arg2_9:Find("lock"), not var6_9)

			if var6_9 then
				setText(arg2_9:Find("name"), var0_9.name)

				local var7_9 = {
					count = 0,
					type = DROP_TYPE_ISLAND_ITEM,
					id = var0_9.item_id
				}

				updateCustomDrop(arg2_9:Find("IslandItemTpl"), var7_9)
			end

			if var6_9 then
				onToggle(arg0_8, arg2_9, function(arg0_10)
					setActive(arg2_9:Find("select"), arg0_10)

					if arg0_10 then
						arg0_8:SetDetail(var0_9)
					end
				end, SFX_PANEL)
			else
				removeOnToggle(arg2_9)
			end
		end
	end)
	arg0_8.setMealList:align(#arg0_8.formulas)
end

function var0_0.SetDetail(arg0_11, arg1_11)
	setActive(arg0_11.detail, true)
	setText(arg0_11.detailName, arg1_11.name)
	setActive(arg0_11.formulaList1, #arg1_11.unlock_condition == 2)
	setActive(arg0_11.formulaList2, #arg1_11.unlock_condition == 3)

	if #arg1_11.unlock_condition == 2 then
		for iter0_11 = 1, 2 do
			local var0_11 = pg.island_formula[arg1_11.unlock_condition[iter0_11][1]]
			local var1_11 = pg.island_item_data_template[var0_11.item_id]

			GetImageSpriteFromAtlasAsync("island/" .. var1_11.icon, "", arg0_11.formulaList1:Find("formula" .. iter0_11 .. "/icon"))
		end
	elseif #arg1_11.unlock_condition == 3 then
		for iter1_11 = 1, 3 do
			local var2_11 = pg.island_formula[arg1_11.unlock_condition[iter1_11][1]]
			local var3_11 = pg.island_item_data_template[var2_11.item_id]

			GetImageSpriteFromAtlasAsync("island/" .. var3_11.icon, "", arg0_11.formulaList2:Find("formula" .. iter1_11 .. "/icon"))
		end
	end

	local var4_11 = true

	arg0_11.conditionList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg1_11.unlock_condition[arg1_12 + 1][1]
			local var1_12 = arg1_11.unlock_condition[arg1_12 + 1][2]
			local var2_12 = pg.island_formula[var0_12]

			setText(arg2_12:Find("name"), "制作" .. var2_12.name)

			local var3_12 = arg0_11.formulaNums[var0_12] or 0

			if var1_12 < var3_12 then
				formulaNum = var1_12
			end

			setText(arg2_12:Find("count"), "" .. var3_12 .. "/" .. var1_12 .. "次")

			if var3_12 < var1_12 then
				var4_11 = false
			end
		end
	end)
	arg0_11.conditionList:align(#arg1_11.unlock_condition)

	if var4_11 == true then
		setText(arg0_11.detailDesc, i18n1("已解锁套餐制作"))
	else
		setText(arg0_11.detailDesc, arg1_11.desc or "")
	end
end

function var0_0.OnShow(arg0_13)
	arg0_13:InitData()
	arg0_13:SetFormulaList()
	pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
end

function var0_0.OnHide(arg0_14)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf)
end

return var0_0
