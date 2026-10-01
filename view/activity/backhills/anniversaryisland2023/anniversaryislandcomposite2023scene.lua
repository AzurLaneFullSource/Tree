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

function var0_0.getResource(arg0_3)
	local var0_3 = var0_0.super.getResource(arg0_3)

	table.insert(var0_3, var1_0)
	table.insert(var0_3, var2_0)

	return var0_3
end

function var0_0.preload(arg0_4, arg1_4)
	table.ParallelIpairsAsync({
		var1_0,
		var2_0
	}, function(arg0_5, arg1_5, arg2_5)
		arg0_4.loader:LoadBundle(arg1_5, arg2_5)
	end, arg1_4)
end

function var0_0.init(arg0_6)
	arg0_6.layerFormulaList = arg0_6._tf:Find("Panel/FormulaList")
	arg0_6.layerFormulaDetail = arg0_6._tf:Find("Panel/FormulaDetail")
	arg0_6.top = arg0_6._tf:Find("Top")
	arg0_6.formulaRect = arg0_6.layerFormulaList:Find("ScrollView"):GetComponent("LScrollRect")

	local var0_6 = arg0_6.layerFormulaList:Find("Item")

	setActive(var0_6, false)

	function arg0_6.formulaRect.onUpdateItem(arg0_7, arg1_7)
		arg0_6:UpdateFormulaListItem(arg0_7 + 1, arg1_7)
	end

	arg0_6.formulaFilterButtons = _.map({
		1,
		2
	}, function(arg0_8)
		return arg0_6.layerFormulaList:Find("Tabs"):GetChild(arg0_8 - 1)
	end)
	arg0_6.lastEnv = nil
	arg0_6.env = {}
	arg0_6.listeners = {}

	setText(arg0_6.layerFormulaList:Find("Empty"), i18n("workbench_tips5"))
	setText(arg0_6.layerFormulaList:Find("Tabs/Furniture/UnSelected/Text"), i18n("word_furniture"))
	setText(arg0_6.layerFormulaList:Find("Tabs/Furniture/Selected/Text"), i18n("word_furniture"))
	setText(arg0_6.layerFormulaList:Find("Tabs/Item/UnSelected/Text"), i18n("workbench_tips7"))
	setText(arg0_6.layerFormulaList:Find("Tabs/Item/Selected/Text"), i18n("workbench_tips7"))
	setText(arg0_6.layerFormulaList:Find("Filter/Text"), i18n("workbench_tips10"))
	setText(arg0_6.layerFormulaDetail:Find("Counters/Text"), i18n("workbench_tips8"))
	setText(arg0_6.layerFormulaDetail:Find("MaterialsBG/MaterialsTitle"), i18n("workbench_tips9"))
end

function var0_0.didEnter(arg0_9)
	arg0_9.contextData.filterType = arg0_9.contextData.filterType or var0_0.FilterAll

	table.Foreach(arg0_9.formulaFilterButtons, function(arg0_10, arg1_10)
		onButton(arg0_9, arg1_10, function()
			local var0_11 = bit.lshift(1, arg0_10 - 1)

			if arg0_9.contextData.filterType == var0_0.FilterAll then
				arg0_9.contextData.filterType = var0_11
			elseif arg0_9.contextData.filterType == var0_11 then
				arg0_9.contextData.filterType = var0_0.FilterAll
			else
				arg0_9.contextData.filterType = var0_11
			end

			arg0_9:UpdateFilterButtons()
			arg0_9:FilterFormulas()
			arg0_9:UpdateView()
		end, SFX_PANEL)
	end)

	arg0_9.showOnlyComposite = PlayerPrefs.GetInt("workbench_show_composite_avaliable", 0) == 1

	triggerToggle(arg0_9.layerFormulaList:Find("Filter/Toggle"), arg0_9.showOnlyComposite)
	onToggle(arg0_9, arg0_9.layerFormulaList:Find("Filter/Toggle"), function(arg0_12)
		arg0_9.showOnlyComposite = arg0_12

		PlayerPrefs.SetInt("workbench_show_composite_avaliable", arg0_12 and 1 or 0)
		PlayerPrefs.Save()
		arg0_9:FilterFormulas()
		arg0_9:UpdateView()
	end)
	onButton(arg0_9, arg0_9._tf:Find("BG"), function()
		arg0_9:onBackPressed()
	end)
	onButton(arg0_9, arg0_9._tf:Find("Top/Back"), function()
		arg0_9:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9._tf:Find("Top/Home"), function()
		arg0_9:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("workbench_help")
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._tf:Find("Top/Upgrade"), function()
		arg0_9:emit(AnniversaryIslandComposite2023Mediator.OPEN_UPGRADE_PANEL)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._tf:Find("Top/StoreHouse"), function()
		arg0_9:emit(AnniversaryIslandComposite2023Mediator.OPEN_STOREHOUSE)
	end, SFX_PANEL)
	arg0_9:BindEnv({
		"filterFormulas",
		"formulas",
		"bagAct",
		"formulaId"
	}, function()
		arg0_9:UpdateFormulaList()
	end)
	arg0_9:BindEnv({
		"formulaId",
		"formulas",
		"bagAct"
	}, function(arg0_20, arg1_20)
		local var0_20 = arg0_20[1]

		arg0_9:UpdateFormulaDetail(var0_20)
	end)
	arg0_9:BindEnv({
		"BuildingLv"
	}, function(arg0_21)
		local var0_21 = arg0_21[1]

		arg0_9.loader:GetSpriteQuiet("ui/AnniversaryIslandComposite2023UI_atlas", "title_" .. var0_21, arg0_9.top:Find("Title/Number"))
	end)
	arg0_9:BindEnv({
		"tip"
	}, function(arg0_22)
		setActive(arg0_9._tf:Find("Top/Upgrade/Tip"), arg0_22[1])
	end)

	arg0_9.env.formulaId = arg0_9.contextData.formulaId

	arg0_9:UpdateFilterButtons()
	arg0_9:BuildActivityEnv()
	arg0_9:UpdateView()
end

function var0_0.InitCounter(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	arg2_23[2] = math.max(arg2_23[1], arg2_23[2])

	local var0_23 = arg1_23
	local var1_23 = arg0_23.layerFormulaDetail:Find("Counters")

	assert(var1_23)

	local function var2_23()
		local var0_24 = var0_23

		if var0_23 == 0 then
			var0_24 = setColorStr(var0_24, "#f9c461")
		end

		setText(var1_23:Find("Number"), var0_24)
		arg3_23(var0_23)
	end

	var2_23()
	pressPersistTrigger(var1_23:Find("Plus"), 0.5, function(arg0_25)
		local var0_25 = var0_23

		var0_23 = var0_23 + 1
		var0_23 = math.clamp(var0_23, arg2_23[1], arg2_23[2])

		if var0_25 == var0_23 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips3"))
			arg0_25()

			return
		end

		var2_23()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(var1_23:Find("Minus"), 0.5, function(arg0_26)
		local var0_26 = var0_23

		var0_23 = var0_23 - 1
		var0_23 = math.clamp(var0_23, arg2_23[1], arg2_23[2])

		if var0_26 == var0_23 then
			arg0_26()

			return
		end

		var2_23()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_23, var1_23:Find("Plus10"), function()
		local var0_27 = var0_23

		var0_23 = var0_23 + 10
		var0_23 = math.clamp(var0_23, arg2_23[1], arg2_23[2])

		if var0_27 == var0_23 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips3"))

			return
		end

		var2_23()
	end)
	onButton(arg0_23, var1_23:Find("Minus10"), function()
		var0_23 = var0_23 - 10
		var0_23 = math.clamp(var0_23, arg2_23[1], arg2_23[2])

		var2_23()
	end)
	onButton(arg0_23, arg0_23.layerFormulaDetail:Find("Composite"), function()
		existCall(arg4_23, var0_23)
	end, SFX_PANEL)
end

local var3_0 = {
	[DROP_TYPE_FURNITURE] = "word_furniture",
	[DROP_TYPE_WORKBENCH_DROP] = "workbench_tips7"
}

function var0_0.UpdateFormulaListItem(arg0_30, arg1_30, arg2_30)
	local var0_30 = tf(arg2_30)
	local var1_30 = arg0_30.env.filterFormulas[arg1_30]
	local var2_30 = var1_30:GetProduction()
	local var3_30 = var0_30:Find("BG/Icon")

	assert(var3_30)
	arg0_30:UpdateActivityDrop(var3_30, {
		type = var2_30[1],
		id = var2_30[2]
	}, true)

	local var4_30 = var3_0[var2_30[1]]
	local var5_30 = not var1_30:IsUnlock()

	setActive(var0_30:Find("Lock"), var5_30)
	setActive(var0_30:Find("BG"), not var5_30)

	if var5_30 then
		setText(var0_30:Find("Lock/Text"), var1_30:GetLockDesc())
	end

	setText(var0_30:Find("BG/Type"), i18n(var4_30))
	setScrollText(var0_30:Find("BG/Name/Text"), var1_30:GetName())
	setActive(var0_30:Find("Selected"), var1_30:GetConfigID() == arg0_30.env.formulaId)

	local var6_30 = var1_30:IsAvaliable()

	setActive(var0_30:Find("Completed"), not var6_30)

	local var7_30

	if var1_30:GetMaxLimit() > 0 then
		local var8_30 = var1_30:GetMaxLimit() - var1_30:GetUsedCount()

		var7_30 = (var8_30 <= 0 and setColorStr(var8_30, "#bb6754") or var8_30) .. "/" .. var1_30:GetMaxLimit()
	else
		var7_30 = "∞"
	end

	setText(var0_30:Find("BG/Count"), var7_30)
	onButton(arg0_30, var0_30, function()
		if not var6_30 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips1"))

			return
		end

		if var5_30 then
			local var0_31 = var1_30:GetLockLimit()

			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips4", var0_31 and var0_31[3]))

			return
		end

		arg0_30.env.formulaId = var1_30:GetConfigID()

		arg0_30:UpdateView()
	end, SFX_PANEL)
end

function var0_0.UpdateFilterButtons(arg0_32)
	table.Foreach(arg0_32.formulaFilterButtons, function(arg0_33, arg1_33)
		local var0_33 = arg0_32.contextData.filterType ~= var0_0.FilterAll

		var0_33 = var0_33 and bit.band(arg0_32.contextData.filterType, bit.lshift(1, arg0_33 - 1)) > 0

		setActive(arg1_33:Find("Selected"), var0_33)
		setActive(arg1_33:Find("UnSelected"), not var0_33)
	end)
end

function var0_0.BuildActivityEnv(arg0_34)
	arg0_34.env.formulas = _.map(pg.activity_workbench_recipe.all, function(arg0_35)
		local var0_35 = WorkBenchFormula.New({
			configId = arg0_35
		})

		var0_35:BuildFromActivity()

		return var0_35
	end)

	if arg0_34.env.formulaId then
		local var0_34 = _.detect(arg0_34.env.formulas, function(arg0_36)
			return arg0_36:GetConfigID() == arg0_34.env.formulaId
		end)

		if not var0_34 or not var0_34:IsAvaliable() then
			arg0_34.env.formulaId = nil
		end
	end

	local var1_34 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	arg0_34.env.bagAct = var1_34

	local var2_34 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0_34.env.BuildingLv = var2_34:GetBuildingLevel(table.keyof(AnniversaryIsland2023Scene.Buildings, "craft"))
	arg0_34.env.tip = AnniversaryIsland2023Scene.UpdateBuildingTip(nil, var2_34, table.keyof(AnniversaryIsland2023Scene.Buildings, "craft"))

	arg0_34:FilterFormulas()
end

function var0_0.FilterFormulas(arg0_37)
	local var0_37 = {}
	local var1_37 = arg0_37.contextData.filterType

	local function var2_37(arg0_38)
		if var1_37 == var0_0.FilterAll then
			return true
		end

		return switch(arg0_38:GetProduction()[1], {
			[DROP_TYPE_WORKBENCH_DROP] = function()
				return bit.band(var1_37, 1) > 0
			end
		}, function()
			return bit.band(var1_37, 2) > 0
		end)
	end

	for iter0_37, iter1_37 in ipairs(_.values(arg0_37.env.formulas)) do
		if var2_37(iter1_37) and (not arg0_37.showOnlyComposite or iter1_37:IsUnlock() and iter1_37:IsAvaliable() and _.all(iter1_37:GetMaterials(), function(arg0_41)
			local var0_41 = arg0_41[1]
			local var1_41 = arg0_41[2]

			return arg0_41[3] <= arg0_37.env.bagAct:getVitemNumber(var1_41)
		end)) then
			table.insert(var0_37, iter1_37)
		end
	end

	local var3_37 = CompareFuncs({
		function(arg0_42)
			return arg0_42:IsAvaliable() and 0 or 1
		end,
		function(arg0_43)
			return arg0_43:IsUnlock() and 0 or 1
		end,
		function(arg0_44)
			return arg0_44:GetConfigID()
		end
	})

	table.sort(var0_37, var3_37)

	arg0_37.env.filterFormulas = var0_37
end

function var0_0.UpdateFormulaList(arg0_45)
	local var0_45 = #arg0_45.env.filterFormulas == 0

	setActive(arg0_45.layerFormulaList:Find("Empty"), var0_45)
	setActive(arg0_45.layerFormulaList:Find("ScrollView"), not var0_45)
	arg0_45.formulaRect:SetTotalCount(#arg0_45.env.filterFormulas)
end

function var0_0.UpdateFormulaDetail(arg0_46, arg1_46)
	arg0_46.contextData.formulaId = arg1_46

	setActive(arg0_46.layerFormulaDetail, arg1_46)

	if not arg1_46 then
		return
	end

	local var0_46 = _.detect(arg0_46.env.formulas, function(arg0_47)
		return arg0_47:GetConfigID() == arg1_46
	end)

	assert(var0_46)

	local var1_46 = var0_46:GetProduction()
	local var2_46 = var0_46:GetMaterials()
	local var3_46 = 100

	;(function()
		local var0_48 = {
			type = var1_46[1],
			id = var1_46[2],
			count = var1_46[3]
		}
		local var1_48 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)
		local var2_48 = var0_46:GetMaxLimit()

		if var2_48 > 0 then
			var3_46 = var2_48 - var1_48:GetFormulaUseCount(arg1_46)
		end

		local var3_48 = arg0_46.layerFormulaDetail:Find("Icon")

		assert(var3_48)
		arg0_46:UpdateActivityDrop(var3_48, var0_48)
		onButton(arg0_46, var3_48, function()
			if var0_48.type == DROP_TYPE_WORKBENCH_DROP then
				arg0_46:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var0_48.id,
					count = var0_48.count
				}))
			else
				arg0_46:emit(BaseUI.ON_DROP, var0_48)
			end
		end)
		setText(arg0_46.layerFormulaDetail:Find("Name"), var0_48:getConfig("name"))
	end)()

	local var4_46 = var3_46
	local var5_46 = arg0_46.env.bagAct

	UIItemList.StaticAlign(arg0_46.layerFormulaDetail:Find("Materials"), arg0_46.layerFormulaDetail:Find("Materials/Item"), #var2_46, function(arg0_50, arg1_50, arg2_50)
		if arg0_50 ~= UIItemList.EventUpdate then
			return
		end

		local var0_50 = var2_46[arg1_50 + 1]
		local var1_50 = {
			type = var0_50[1],
			id = var0_50[2],
			count = var0_50[3]
		}

		arg0_46:UpdateActivityDrop(arg2_50:Find("Icon"), var1_50)
		onButton(arg0_46, arg2_50:Find("Icon"), function()
			if var1_50.type == DROP_TYPE_WORKBENCH_DROP then
				arg0_46:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var1_50.id,
					count = var1_50.count
				}))
			else
				arg0_46:emit(BaseUI.ON_DROP, var1_50)
			end
		end)

		local var2_50 = var0_50[2]
		local var3_50 = var0_50[3]
		local var4_50 = var5_46:getVitemNumber(var2_50)

		if var3_50 > 0 then
			var4_46 = math.min(var4_46, math.floor(var4_50 / var3_50))
		end
	end)

	local function var6_46(arg0_52)
		UIItemList.StaticAlign(arg0_46.layerFormulaDetail:Find("Materials"), arg0_46.layerFormulaDetail:Find("Materials/Item"), #var2_46, function(arg0_53, arg1_53, arg2_53)
			if arg0_53 ~= UIItemList.EventUpdate then
				return
			end

			local var0_53 = var2_46[arg1_53 + 1]
			local var1_53 = var0_53[2]
			local var2_53 = var0_53[3]
			local var3_53 = var5_46:getVitemNumber(var1_53)

			arg0_52 = math.max(arg0_52, 1)

			local var4_53 = var2_53 * arg0_52
			local var5_53 = setColorStr(var3_53, var3_53 < var4_53 and "#bb6754" or "#6b5a48")

			setText(arg2_53:Find("Text"), var5_53 .. "/" .. var4_53)
		end)
	end

	local var7_46 = math.min(1, var4_46)

	arg0_46:InitCounter(var7_46, {
		0,
		var4_46
	}, var6_46, function(arg0_54)
		arg0_46:emit(GAME.WORKBENCH_COMPOSITE, arg1_46, arg0_54)
	end)
	var6_46(var7_46)
end

function var0_0.BindEnv(arg0_55, arg1_55, arg2_55)
	table.insert(arg0_55.listeners, {
		keys = arg1_55,
		func = arg2_55
	})
end

function var0_0.RefreshData(arg0_56)
	arg0_56.lastEnv = arg0_56.lastEnv or {}

	local var0_56 = {}
	local var1_56

	local function var2_56(arg0_57, arg1_57)
		if var0_56[arg0_57] then
			return
		end

		var0_56[arg0_57] = arg1_57
		var1_56 = var1_56 or {}

		local var0_57 = _.select(arg0_56.listeners, function(arg0_58)
			return table.contains(arg0_58.keys, arg0_57)
		end)

		_.each(var0_57, function(arg0_59)
			var1_56[arg0_59] = true
		end)
	end

	for iter0_56, iter1_56 in pairs(arg0_56.env) do
		if iter1_56 ~= arg0_56.lastEnv[iter0_56] then
			var2_56(iter0_56, iter1_56)
		end
	end

	for iter2_56, iter3_56 in pairs(arg0_56.lastEnv) do
		local var3_56 = arg0_56.env[iter2_56]

		if iter3_56 ~= var3_56 then
			var2_56(iter2_56, var3_56)
		end
	end

	if var1_56 then
		table.Foreach(var1_56, function(arg0_60)
			local var0_60 = table.map(arg0_60.keys, function(arg0_61)
				return arg0_56.env[arg0_61]
			end)
			local var1_60 = table.map(arg0_60.keys, function(arg0_62)
				return arg0_56.lastEnv[arg0_62]
			end)

			arg0_60.func(var0_60, var1_60)
		end)
	end

	arg0_56.lastEnv = table.shallowCopy(arg0_56.env)
end

function var0_0.UpdateView(arg0_63)
	arg0_63:RefreshData()
	AnniversaryIsland2023Scene.PlayStory()
end

function var0_0.OnReceiveFormualRequest(arg0_64, arg1_64)
	arg0_64.env.formulaId = arg1_64

	arg0_64:UpdateView()
end

function var0_0.UpdateActivityDrop(arg0_65, arg1_65, arg2_65, arg3_65)
	updateDrop(arg1_65, arg2_65)
	SetCompomentEnabled(arg1_65:Find("icon_bg"), typeof(Image), false)
	setActive(arg1_65:Find("bg"), false)
	setActive(arg1_65:Find("icon_bg/frame"), false)
	setActive(arg1_65:Find("icon_bg/stars"), false)

	local var0_65 = arg2_65:getConfig("rarity")

	if arg2_65.type == DROP_TYPE_EQUIP or arg2_65.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_65 = var0_65 - 1
	end

	local var1_65 = "icon_frame_" .. var0_65

	if arg3_65 then
		var1_65 = var1_65 .. "_small"
	end

	arg0_65.loader:GetSpriteQuiet(var2_0, var1_65, arg1_65)
end

function var0_0.willExit(arg0_66)
	arg0_66.loader:Clear()
end

return var0_0
