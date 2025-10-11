local var0_0 = class("IslandSetMealHandbookPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandSetMealHandbookUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("top/back")
	arg0_2.setMealList = UIItemList.New(arg0_2._tf:Find("setMealList/Viewport/Content"), arg0_2._tf:Find("setMealList/Viewport/Content/setMealTpl"))
	arg0_2.detail = arg0_2._tf:Find("detail")
	arg0_2.detailName = arg0_2.detail:Find("name/text")
	arg0_2.formulaList1 = arg0_2.detail:Find("formulaList1")
	arg0_2.formulaList2 = arg0_2.detail:Find("formulaList2")
	arg0_2.detailDesc = arg0_2.detail:Find("desc")
	arg0_2.conditionList = UIItemList.New(arg0_2.detail:Find("conditionList"), arg0_2.detail:Find("conditionList/condition"))

	setActive(arg0_2.detail, false)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_setmeal_title"))
	setText(arg0_2._tf:Find("top/title/Text/en"), i18n1("HANDBOOK"))
	setText(arg0_2._tf:Find("detail/condition"), i18n("island_tech_detail_unlocktitle"))
	setText(arg0_2._tf:Find("detail/decoration2/text"), i18n("island_setmeal_benifit_title"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_combo.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3:InitData()
end

function var0_0.InitData(arg0_6)
	arg0_6.formulaNums = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetFormulaNums()
	arg0_6.formulas = {}

	for iter0_6, iter1_6 in ipairs(pg.island_combo.all) do
		local var0_6 = Clone(pg.island_formula[iter1_6])

		var0_6.unlock_condition = pg.island_combo[iter1_6].unlock_condition
		var0_6.is_hide = pg.island_combo[iter1_6].is_hide

		table.insert(arg0_6.formulas, var0_6)
	end

	table.sort(arg0_6.formulas, CompareFuncs({
		function(arg0_7)
			local var0_7 = arg0_7
			local var1_7 = var0_7.is_hide == 1
			local var2_7 = true
			local var3_7 = true

			for iter0_7, iter1_7 in ipairs(var0_7.unlock_condition) do
				local var4_7 = iter1_7[1]
				local var5_7 = iter1_7[2]

				if not arg0_6.formulaNums[var4_7] or arg0_6.formulaNums[var4_7] < 1 then
					var2_7 = false
				end

				if not arg0_6.formulaNums[var4_7] or var5_7 > arg0_6.formulaNums[var4_7] then
					var3_7 = false
				end
			end

			return (not var1_7 and var2_7 or var1_7 and var3_7) and 0 or 1
		end,
		function(arg0_8)
			return arg0_8.id
		end
	}))
end

function var0_0.SetFormulaList(arg0_9)
	arg0_9.setMealList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.formulas[arg1_10 + 1]
			local var1_10 = var0_10.is_hide == 1
			local var2_10 = true
			local var3_10 = true

			for iter0_10, iter1_10 in ipairs(var0_10.unlock_condition) do
				local var4_10 = iter1_10[1]
				local var5_10 = iter1_10[2]

				if not arg0_9.formulaNums[var4_10] or arg0_9.formulaNums[var4_10] < 1 then
					var2_10 = false
				end

				if not arg0_9.formulaNums[var4_10] or var5_10 > arg0_9.formulaNums[var4_10] then
					var3_10 = false
				end
			end

			local var6_10 = not var1_10 and var2_10 or var1_10 and var3_10

			setActive(arg2_10:Find("special"), var1_10 and var3_10)
			setActive(arg2_10:Find("name"), var6_10)
			setActive(arg2_10:Find("IslandItemTpl"), var6_10)
			setActive(arg2_10:Find("lock"), not var6_10)

			if var6_10 then
				setScrollText(arg2_10:Find("name/text"), var0_10.name)

				local var7_10 = {
					count = 0,
					type = DROP_TYPE_ISLAND_ITEM,
					id = var0_10.item_id
				}

				updateCustomDrop(arg2_10:Find("IslandItemTpl"), var7_10)
			end

			if var6_10 then
				onToggle(arg0_9, arg2_10, function(arg0_11)
					setActive(arg2_10:Find("select"), arg0_11)

					if arg0_11 then
						arg0_9:SetDetail(var0_10)
					end
				end, SFX_PANEL)
			else
				removeOnToggle(arg2_10)
			end
		end
	end)
	arg0_9.setMealList:align(#arg0_9.formulas)
end

function var0_0.SetDetail(arg0_12, arg1_12)
	setActive(arg0_12.detail, true)
	setScrollText(arg0_12.detailName, arg1_12.name)
	setActive(arg0_12.formulaList1, #arg1_12.unlock_condition == 2)
	setActive(arg0_12.formulaList2, #arg1_12.unlock_condition == 3)

	if #arg1_12.unlock_condition == 2 then
		for iter0_12 = 1, 2 do
			local var0_12 = pg.island_formula[arg1_12.unlock_condition[iter0_12][1]]
			local var1_12 = pg.island_item_data_template[var0_12.item_id]

			GetImageSpriteFromAtlasAsync("island/" .. var1_12.icon, "", arg0_12.formulaList1:Find("formula" .. iter0_12 .. "/icon"))
		end
	elseif #arg1_12.unlock_condition == 3 then
		for iter1_12 = 1, 3 do
			local var2_12 = pg.island_formula[arg1_12.unlock_condition[iter1_12][1]]
			local var3_12 = pg.island_item_data_template[var2_12.item_id]

			GetImageSpriteFromAtlasAsync("island/" .. var3_12.icon, "", arg0_12.formulaList2:Find("formula" .. iter1_12 .. "/icon"))
		end
	end

	local var4_12 = true

	arg0_12.conditionList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg1_12.unlock_condition[arg1_13 + 1][1]
			local var1_13 = arg1_12.unlock_condition[arg1_13 + 1][2]
			local var2_13 = pg.island_formula[var0_13]

			setScrollText(arg2_13:Find("name/text"), i18n("island_combo_produced") .. var2_13.name)

			local var3_13 = arg0_12.formulaNums[var0_13] or 0

			setActive(arg2_13:Find("notComplete"), var3_13 < var1_13)
			setActive(arg2_13:Find("complete"), var1_13 <= var3_13)

			if var1_13 < var3_13 then
				formulaNum = var1_13
			end

			setText(arg2_13:Find("count"), i18n("island_combo_produced_times", "" .. var3_13 .. "/" .. var1_13))

			if var3_13 < var1_13 then
				var4_12 = false
			end
		end
	end)
	arg0_12.conditionList:align(#arg1_12.unlock_condition)

	if var4_12 == true then
		setText(arg0_12.detailDesc, i18n("island_combo_unlock"))
	else
		setText(arg0_12.detailDesc, arg1_12.desc or "")
	end
end

function var0_0.OnShow(arg0_14)
	arg0_14:InitData()
	arg0_14:SetFormulaList()
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
end

function var0_0.OnHide(arg0_15)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf)
end

return var0_0
