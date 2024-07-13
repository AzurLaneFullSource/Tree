local var0_0 = class("AnniversaryIslandComposite2023Scene", import("view.base.BaseUI"))

var0_0.FilterAll = bit.bor(1, 2)

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.loader = AutoLoader.New()
end

function var0_0.getUIName(arg0_2)
	return "AnniversaryIslandComposite2023UI"
end

local var1_0 = "ui/AnniversaryIslandComposite2023UI_atlas"
local var2_0 = "ui/AtelierCommonUI_atlas"

function var0_0.preload(arg0_3, arg1_3)
	table.ParallelIpairsAsync({
		var1_0,
		var2_0
	}, function(arg0_4, arg1_4, arg2_4)
		arg0_3.loader:LoadBundle(arg1_4, arg2_4)
	end, arg1_3)
end

function var0_0.init(arg0_5)
	arg0_5.layerFormulaList = arg0_5._tf:Find("Panel/FormulaList")
	arg0_5.layerFormulaDetail = arg0_5._tf:Find("Panel/FormulaDetail")
	arg0_5.top = arg0_5._tf:Find("Top")
	arg0_5.formulaRect = arg0_5.layerFormulaList:Find("ScrollView"):GetComponent("LScrollRect")

	local var0_5 = arg0_5.layerFormulaList:Find("Item")

	setActive(var0_5, false)

	function arg0_5.formulaRect.onUpdateItem(arg0_6, arg1_6)
		arg0_5:UpdateFormulaListItem(arg0_6 + 1, arg1_6)
	end

	arg0_5.formulaFilterButtons = _.map({
		1,
		2
	}, function(arg0_7)
		return arg0_5.layerFormulaList:Find("Tabs"):GetChild(arg0_7 - 1)
	end)
	arg0_5.lastEnv = nil
	arg0_5.env = {}
	arg0_5.listeners = {}

	setText(arg0_5.layerFormulaList:Find("Empty"), i18n("workbench_tips5"))
	setText(arg0_5.layerFormulaList:Find("Tabs/Furniture/UnSelected/Text"), i18n("word_furniture"))
	setText(arg0_5.layerFormulaList:Find("Tabs/Furniture/Selected/Text"), i18n("word_furniture"))
	setText(arg0_5.layerFormulaList:Find("Tabs/Item/UnSelected/Text"), i18n("workbench_tips7"))
	setText(arg0_5.layerFormulaList:Find("Tabs/Item/Selected/Text"), i18n("workbench_tips7"))
	setText(arg0_5.layerFormulaList:Find("Filter/Text"), i18n("workbench_tips10"))
	setText(arg0_5.layerFormulaDetail:Find("Counters/Text"), i18n("workbench_tips8"))
	setText(arg0_5.layerFormulaDetail:Find("MaterialsBG/MaterialsTitle"), i18n("workbench_tips9"))
end

function var0_0.didEnter(arg0_8)
	arg0_8.contextData.filterType = arg0_8.contextData.filterType or var0_0.FilterAll

	table.Foreach(arg0_8.formulaFilterButtons, function(arg0_9, arg1_9)
		onButton(arg0_8, arg1_9, function()
			local var0_10 = bit.lshift(1, arg0_9 - 1)

			if arg0_8.contextData.filterType == var0_0.FilterAll then
				arg0_8.contextData.filterType = var0_10
			elseif arg0_8.contextData.filterType == var0_10 then
				arg0_8.contextData.filterType = var0_0.FilterAll
			else
				arg0_8.contextData.filterType = var0_10
			end

			arg0_8:UpdateFilterButtons()
			arg0_8:FilterFormulas()
			arg0_8:UpdateView()
		end, SFX_PANEL)
	end)

	arg0_8.showOnlyComposite = PlayerPrefs.GetInt("workbench_show_composite_avaliable", 0) == 1

	triggerToggle(arg0_8.layerFormulaList:Find("Filter/Toggle"), arg0_8.showOnlyComposite)
	onToggle(arg0_8, arg0_8.layerFormulaList:Find("Filter/Toggle"), function(arg0_11)
		arg0_8.showOnlyComposite = arg0_11

		PlayerPrefs.SetInt("workbench_show_composite_avaliable", arg0_11 and 1 or 0)
		PlayerPrefs.Save()
		arg0_8:FilterFormulas()
		arg0_8:UpdateView()
	end)
	onButton(arg0_8, arg0_8._tf:Find("BG"), function()
		arg0_8:onBackPressed()
	end)
	onButton(arg0_8, arg0_8._tf:Find("Top/Back"), function()
		arg0_8:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8._tf:Find("Top/Home"), function()
		arg0_8:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("workbench_help")
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("Top/Upgrade"), function()
		arg0_8:emit(AnniversaryIslandComposite2023Mediator.OPEN_UPGRADE_PANEL)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("Top/StoreHouse"), function()
		arg0_8:emit(AnniversaryIslandComposite2023Mediator.OPEN_STOREHOUSE)
	end, SFX_PANEL)
	arg0_8:BindEnv({
		"filterFormulas",
		"formulas",
		"bagAct",
		"formulaId"
	}, function()
		arg0_8:UpdateFormulaList()
	end)
	arg0_8:BindEnv({
		"formulaId",
		"formulas",
		"bagAct"
	}, function(arg0_19, arg1_19)
		local var0_19 = arg0_19[1]

		arg0_8:UpdateFormulaDetail(var0_19)
	end)
	arg0_8:BindEnv({
		"BuildingLv"
	}, function(arg0_20)
		local var0_20 = arg0_20[1]

		arg0_8.loader:GetSpriteQuiet("ui/AnniversaryIslandComposite2023UI_atlas", "title_" .. var0_20, arg0_8.top:Find("Title/Number"))
	end)
	arg0_8:BindEnv({
		"tip"
	}, function(arg0_21)
		setActive(arg0_8._tf:Find("Top/Upgrade/Tip"), arg0_21[1])
	end)

	arg0_8.env.formulaId = arg0_8.contextData.formulaId

	arg0_8:UpdateFilterButtons()
	arg0_8:BuildActivityEnv()
	arg0_8:UpdateView()
end

function var0_0.InitCounter(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	arg2_22[2] = math.max(arg2_22[1], arg2_22[2])

	local var0_22 = arg1_22
	local var1_22 = arg0_22.layerFormulaDetail:Find("Counters")

	assert(var1_22)

	local function var2_22()
		local var0_23 = var0_22

		if var0_22 == 0 then
			var0_23 = setColorStr(var0_23, "#f9c461")
		end

		setText(var1_22:Find("Number"), var0_23)
		arg3_22(var0_22)
	end

	var2_22()
	pressPersistTrigger(var1_22:Find("Plus"), 0.5, function(arg0_24)
		local var0_24 = var0_22

		var0_22 = var0_22 + 1
		var0_22 = math.clamp(var0_22, arg2_22[1], arg2_22[2])

		if var0_24 == var0_22 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips3"))
			arg0_24()

			return
		end

		var2_22()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(var1_22:Find("Minus"), 0.5, function(arg0_25)
		local var0_25 = var0_22

		var0_22 = var0_22 - 1
		var0_22 = math.clamp(var0_22, arg2_22[1], arg2_22[2])

		if var0_25 == var0_22 then
			arg0_25()

			return
		end

		var2_22()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_22, var1_22:Find("Plus10"), function()
		local var0_26 = var0_22

		var0_22 = var0_22 + 10
		var0_22 = math.clamp(var0_22, arg2_22[1], arg2_22[2])

		if var0_26 == var0_22 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips3"))

			return
		end

		var2_22()
	end)
	onButton(arg0_22, var1_22:Find("Minus10"), function()
		var0_22 = var0_22 - 10
		var0_22 = math.clamp(var0_22, arg2_22[1], arg2_22[2])

		var2_22()
	end)
	onButton(arg0_22, arg0_22.layerFormulaDetail:Find("Composite"), function()
		existCall(arg4_22, var0_22)
	end, SFX_PANEL)
end

local var3_0 = {
	[DROP_TYPE_FURNITURE] = "word_furniture",
	[DROP_TYPE_WORKBENCH_DROP] = "workbench_tips7"
}

function var0_0.UpdateFormulaListItem(arg0_29, arg1_29, arg2_29)
	local var0_29 = tf(arg2_29)
	local var1_29 = arg0_29.env.filterFormulas[arg1_29]
	local var2_29 = var1_29:GetProduction()
	local var3_29 = var0_29:Find("BG/Icon")

	assert(var3_29)
	arg0_29:UpdateActivityDrop(var3_29, {
		type = var2_29[1],
		id = var2_29[2]
	}, true)

	local var4_29 = var3_0[var2_29[1]]
	local var5_29 = not var1_29:IsUnlock()

	setActive(var0_29:Find("Lock"), var5_29)
	setActive(var0_29:Find("BG"), not var5_29)

	if var5_29 then
		setText(var0_29:Find("Lock/Text"), var1_29:GetLockDesc())
	end

	setText(var0_29:Find("BG/Type"), i18n(var4_29))
	setScrollText(var0_29:Find("BG/Name/Text"), var1_29:GetName())
	setActive(var0_29:Find("Selected"), var1_29:GetConfigID() == arg0_29.env.formulaId)

	local var6_29 = var1_29:IsAvaliable()

	setActive(var0_29:Find("Completed"), not var6_29)

	local var7_29

	if var1_29:GetMaxLimit() > 0 then
		local var8_29 = var1_29:GetMaxLimit() - var1_29:GetUsedCount()

		var7_29 = (var8_29 <= 0 and setColorStr(var8_29, "#bb6754") or var8_29) .. "/" .. var1_29:GetMaxLimit()
	else
		var7_29 = "∞"
	end

	setText(var0_29:Find("BG/Count"), var7_29)
	onButton(arg0_29, var0_29, function()
		if not var6_29 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips1"))

			return
		end

		if var5_29 then
			local var0_30 = var1_29:GetLockLimit()

			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips4", var0_30 and var0_30[3]))

			return
		end

		arg0_29.env.formulaId = var1_29:GetConfigID()

		arg0_29:UpdateView()
	end, SFX_PANEL)
end

function var0_0.UpdateFilterButtons(arg0_31)
	table.Foreach(arg0_31.formulaFilterButtons, function(arg0_32, arg1_32)
		local var0_32 = arg0_31.contextData.filterType ~= var0_0.FilterAll

		var0_32 = var0_32 and bit.band(arg0_31.contextData.filterType, bit.lshift(1, arg0_32 - 1)) > 0

		setActive(arg1_32:Find("Selected"), var0_32)
		setActive(arg1_32:Find("UnSelected"), not var0_32)
	end)
end

function var0_0.BuildActivityEnv(arg0_33)
	arg0_33.env.formulas = _.map(pg.activity_workbench_recipe.all, function(arg0_34)
		local var0_34 = WorkBenchFormula.New({
			configId = arg0_34
		})

		var0_34:BuildFromActivity()

		return var0_34
	end)

	if arg0_33.env.formulaId then
		local var0_33 = _.detect(arg0_33.env.formulas, function(arg0_35)
			return arg0_35:GetConfigID() == arg0_33.env.formulaId
		end)

		if not var0_33 or not var0_33:IsAvaliable() then
			arg0_33.env.formulaId = nil
		end
	end

	local var1_33 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	arg0_33.env.bagAct = var1_33

	local var2_33 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0_33.env.BuildingLv = var2_33:GetBuildingLevel(table.keyof(AnniversaryIsland2023Scene.Buildings, "craft"))
	arg0_33.env.tip = AnniversaryIsland2023Scene.UpdateBuildingTip(nil, var2_33, table.keyof(AnniversaryIsland2023Scene.Buildings, "craft"))

	arg0_33:FilterFormulas()
end

function var0_0.FilterFormulas(arg0_36)
	local var0_36 = {}
	local var1_36 = arg0_36.contextData.filterType

	local function var2_36(arg0_37)
		if var1_36 == var0_0.FilterAll then
			return true
		end

		return switch(arg0_37:GetProduction()[1], {
			[DROP_TYPE_WORKBENCH_DROP] = function()
				return bit.band(var1_36, 1) > 0
			end
		}, function()
			return bit.band(var1_36, 2) > 0
		end)
	end

	for iter0_36, iter1_36 in ipairs(_.values(arg0_36.env.formulas)) do
		if var2_36(iter1_36) and (not arg0_36.showOnlyComposite or iter1_36:IsUnlock() and iter1_36:IsAvaliable() and _.all(iter1_36:GetMaterials(), function(arg0_40)
			local var0_40 = arg0_40[1]
			local var1_40 = arg0_40[2]

			return arg0_40[3] <= arg0_36.env.bagAct:getVitemNumber(var1_40)
		end)) then
			table.insert(var0_36, iter1_36)
		end
	end

	local var3_36 = CompareFuncs({
		function(arg0_41)
			return arg0_41:IsAvaliable() and 0 or 1
		end,
		function(arg0_42)
			return arg0_42:IsUnlock() and 0 or 1
		end,
		function(arg0_43)
			return arg0_43:GetConfigID()
		end
	})

	table.sort(var0_36, var3_36)

	arg0_36.env.filterFormulas = var0_36
end

function var0_0.UpdateFormulaList(arg0_44)
	local var0_44 = #arg0_44.env.filterFormulas == 0

	setActive(arg0_44.layerFormulaList:Find("Empty"), var0_44)
	setActive(arg0_44.layerFormulaList:Find("ScrollView"), not var0_44)
	arg0_44.formulaRect:SetTotalCount(#arg0_44.env.filterFormulas)
end

function var0_0.UpdateFormulaDetail(arg0_45, arg1_45)
	arg0_45.contextData.formulaId = arg1_45

	setActive(arg0_45.layerFormulaDetail, arg1_45)

	if not arg1_45 then
		return
	end

	local var0_45 = _.detect(arg0_45.env.formulas, function(arg0_46)
		return arg0_46:GetConfigID() == arg1_45
	end)

	assert(var0_45)

	local var1_45 = var0_45:GetProduction()
	local var2_45 = var0_45:GetMaterials()
	local var3_45 = 100

	;(function()
		local var0_47 = {
			type = var1_45[1],
			id = var1_45[2],
			count = var1_45[3]
		}
		local var1_47 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)
		local var2_47 = var0_45:GetMaxLimit()

		if var2_47 > 0 then
			var3_45 = var2_47 - var1_47:GetFormulaUseCount(arg1_45)
		end

		local var3_47 = arg0_45.layerFormulaDetail:Find("Icon")

		assert(var3_47)
		arg0_45:UpdateActivityDrop(var3_47, var0_47)
		onButton(arg0_45, var3_47, function()
			if var0_47.type == DROP_TYPE_WORKBENCH_DROP then
				arg0_45:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var0_47.id,
					count = var0_47.count
				}))
			else
				arg0_45:emit(BaseUI.ON_DROP, var0_47)
			end
		end)
		setText(arg0_45.layerFormulaDetail:Find("Name"), var0_47:getConfig("name"))
	end)()

	local var4_45 = var3_45
	local var5_45 = arg0_45.env.bagAct

	UIItemList.StaticAlign(arg0_45.layerFormulaDetail:Find("Materials"), arg0_45.layerFormulaDetail:Find("Materials/Item"), #var2_45, function(arg0_49, arg1_49, arg2_49)
		if arg0_49 ~= UIItemList.EventUpdate then
			return
		end

		local var0_49 = var2_45[arg1_49 + 1]
		local var1_49 = {
			type = var0_49[1],
			id = var0_49[2],
			count = var0_49[3]
		}

		arg0_45:UpdateActivityDrop(arg2_49:Find("Icon"), var1_49)
		onButton(arg0_45, arg2_49:Find("Icon"), function()
			if var1_49.type == DROP_TYPE_WORKBENCH_DROP then
				arg0_45:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var1_49.id,
					count = var1_49.count
				}))
			else
				arg0_45:emit(BaseUI.ON_DROP, var1_49)
			end
		end)

		local var2_49 = var0_49[2]
		local var3_49 = var0_49[3]
		local var4_49 = var5_45:getVitemNumber(var2_49)

		if var3_49 > 0 then
			var4_45 = math.min(var4_45, math.floor(var4_49 / var3_49))
		end
	end)

	local function var6_45(arg0_51)
		UIItemList.StaticAlign(arg0_45.layerFormulaDetail:Find("Materials"), arg0_45.layerFormulaDetail:Find("Materials/Item"), #var2_45, function(arg0_52, arg1_52, arg2_52)
			if arg0_52 ~= UIItemList.EventUpdate then
				return
			end

			local var0_52 = var2_45[arg1_52 + 1]
			local var1_52 = var0_52[2]
			local var2_52 = var0_52[3]
			local var3_52 = var5_45:getVitemNumber(var1_52)

			arg0_51 = math.max(arg0_51, 1)

			local var4_52 = var2_52 * arg0_51
			local var5_52 = setColorStr(var3_52, var3_52 < var4_52 and "#bb6754" or "#6b5a48")

			setText(arg2_52:Find("Text"), var5_52 .. "/" .. var4_52)
		end)
	end

	local var7_45 = math.min(1, var4_45)

	arg0_45:InitCounter(var7_45, {
		0,
		var4_45
	}, var6_45, function(arg0_53)
		arg0_45:emit(GAME.WORKBENCH_COMPOSITE, arg1_45, arg0_53)
	end)
	var6_45(var7_45)
end

function var0_0.BindEnv(arg0_54, arg1_54, arg2_54)
	table.insert(arg0_54.listeners, {
		keys = arg1_54,
		func = arg2_54
	})
end

function var0_0.RefreshData(arg0_55)
	arg0_55.lastEnv = arg0_55.lastEnv or {}

	local var0_55 = {}
	local var1_55

	local function var2_55(arg0_56, arg1_56)
		if var0_55[arg0_56] then
			return
		end

		var0_55[arg0_56] = arg1_56
		var1_55 = var1_55 or {}

		local var0_56 = _.select(arg0_55.listeners, function(arg0_57)
			return table.contains(arg0_57.keys, arg0_56)
		end)

		_.each(var0_56, function(arg0_58)
			var1_55[arg0_58] = true
		end)
	end

	for iter0_55, iter1_55 in pairs(arg0_55.env) do
		if iter1_55 ~= arg0_55.lastEnv[iter0_55] then
			var2_55(iter0_55, iter1_55)
		end
	end

	for iter2_55, iter3_55 in pairs(arg0_55.lastEnv) do
		local var3_55 = arg0_55.env[iter2_55]

		if iter3_55 ~= var3_55 then
			var2_55(iter2_55, var3_55)
		end
	end

	if var1_55 then
		table.Foreach(var1_55, function(arg0_59)
			local var0_59 = table.map(arg0_59.keys, function(arg0_60)
				return arg0_55.env[arg0_60]
			end)
			local var1_59 = table.map(arg0_59.keys, function(arg0_61)
				return arg0_55.lastEnv[arg0_61]
			end)

			arg0_59.func(var0_59, var1_59)
		end)
	end

	arg0_55.lastEnv = table.shallowCopy(arg0_55.env)
end

function var0_0.UpdateView(arg0_62)
	arg0_62:RefreshData()
	AnniversaryIsland2023Scene.PlayStory()
end

function var0_0.OnReceiveFormualRequest(arg0_63, arg1_63)
	arg0_63.env.formulaId = arg1_63

	arg0_63:UpdateView()
end

function var0_0.UpdateActivityDrop(arg0_64, arg1_64, arg2_64, arg3_64)
	updateDrop(arg1_64, arg2_64)
	SetCompomentEnabled(arg1_64:Find("icon_bg"), typeof(Image), false)
	setActive(arg1_64:Find("bg"), false)
	setActive(arg1_64:Find("icon_bg/frame"), false)
	setActive(arg1_64:Find("icon_bg/stars"), false)

	local var0_64 = arg2_64:getConfig("rarity")

	if arg2_64.type == DROP_TYPE_EQUIP or arg2_64.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_64 = var0_64 - 1
	end

	local var1_64 = "icon_frame_" .. var0_64

	if arg3_64 then
		var1_64 = var1_64 .. "_small"
	end

	arg0_64.loader:GetSpriteQuiet(var2_0, var1_64, arg1_64)
end

function var0_0.willExit(arg0_65)
	arg0_65.loader:Clear()
end

return var0_0
