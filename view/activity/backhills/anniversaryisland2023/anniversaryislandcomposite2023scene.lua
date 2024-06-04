local var0 = class("AnniversaryIslandComposite2023Scene", import("view.base.BaseUI"))

var0.FilterAll = bit.bor(1, 2)

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)

	arg0.loader = AutoLoader.New()
end

function var0.getUIName(arg0)
	return "AnniversaryIslandComposite2023UI"
end

local var1 = "ui/AnniversaryIslandComposite2023UI_atlas"
local var2 = "ui/AtelierCommonUI_atlas"

function var0.preload(arg0, arg1)
	table.ParallelIpairsAsync({
		var1,
		var2
	}, function(arg0, arg1, arg2)
		arg0.loader:LoadBundle(arg1, arg2)
	end, arg1)
end

function var0.init(arg0)
	arg0.layerFormulaList = arg0._tf:Find("Panel/FormulaList")
	arg0.layerFormulaDetail = arg0._tf:Find("Panel/FormulaDetail")
	arg0.top = arg0._tf:Find("Top")
	arg0.formulaRect = arg0.layerFormulaList:Find("ScrollView"):GetComponent("LScrollRect")

	local var0 = arg0.layerFormulaList:Find("Item")

	setActive(var0, false)

	function arg0.formulaRect.onUpdateItem(arg0, arg1)
		arg0:UpdateFormulaListItem(arg0 + 1, arg1)
	end

	arg0.formulaFilterButtons = _.map({
		1,
		2
	}, function(arg0)
		return arg0.layerFormulaList:Find("Tabs"):GetChild(arg0 - 1)
	end)
	arg0.lastEnv = nil
	arg0.env = {}
	arg0.listeners = {}

	setText(arg0.layerFormulaList:Find("Empty"), i18n("workbench_tips5"))
	setText(arg0.layerFormulaList:Find("Tabs/Furniture/UnSelected/Text"), i18n("word_furniture"))
	setText(arg0.layerFormulaList:Find("Tabs/Furniture/Selected/Text"), i18n("word_furniture"))
	setText(arg0.layerFormulaList:Find("Tabs/Item/UnSelected/Text"), i18n("workbench_tips7"))
	setText(arg0.layerFormulaList:Find("Tabs/Item/Selected/Text"), i18n("workbench_tips7"))
	setText(arg0.layerFormulaList:Find("Filter/Text"), i18n("workbench_tips10"))
	setText(arg0.layerFormulaDetail:Find("Counters/Text"), i18n("workbench_tips8"))
	setText(arg0.layerFormulaDetail:Find("MaterialsBG/MaterialsTitle"), i18n("workbench_tips9"))
end

function var0.didEnter(arg0)
	arg0.contextData.filterType = arg0.contextData.filterType or var0.FilterAll

	table.Foreach(arg0.formulaFilterButtons, function(arg0, arg1)
		onButton(arg0, arg1, function()
			local var0 = bit.lshift(1, arg0 - 1)

			if arg0.contextData.filterType == var0.FilterAll then
				arg0.contextData.filterType = var0
			elseif arg0.contextData.filterType == var0 then
				arg0.contextData.filterType = var0.FilterAll
			else
				arg0.contextData.filterType = var0
			end

			arg0:UpdateFilterButtons()
			arg0:FilterFormulas()
			arg0:UpdateView()
		end, SFX_PANEL)
	end)

	arg0.showOnlyComposite = PlayerPrefs.GetInt("workbench_show_composite_avaliable", 0) == 1

	triggerToggle(arg0.layerFormulaList:Find("Filter/Toggle"), arg0.showOnlyComposite)
	onToggle(arg0, arg0.layerFormulaList:Find("Filter/Toggle"), function(arg0)
		arg0.showOnlyComposite = arg0

		PlayerPrefs.SetInt("workbench_show_composite_avaliable", arg0 and 1 or 0)
		PlayerPrefs.Save()
		arg0:FilterFormulas()
		arg0:UpdateView()
	end)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:onBackPressed()
	end)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Top/Home"), function()
		arg0:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("workbench_help")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Top/Upgrade"), function()
		arg0:emit(AnniversaryIslandComposite2023Mediator.OPEN_UPGRADE_PANEL)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Top/StoreHouse"), function()
		arg0:emit(AnniversaryIslandComposite2023Mediator.OPEN_STOREHOUSE)
	end, SFX_PANEL)
	arg0:BindEnv({
		"filterFormulas",
		"formulas",
		"bagAct",
		"formulaId"
	}, function()
		arg0:UpdateFormulaList()
	end)
	arg0:BindEnv({
		"formulaId",
		"formulas",
		"bagAct"
	}, function(arg0, arg1)
		local var0 = arg0[1]

		arg0:UpdateFormulaDetail(var0)
	end)
	arg0:BindEnv({
		"BuildingLv"
	}, function(arg0)
		local var0 = arg0[1]

		arg0.loader:GetSpriteQuiet("ui/AnniversaryIslandComposite2023UI_atlas", "title_" .. var0, arg0.top:Find("Title/Number"))
	end)
	arg0:BindEnv({
		"tip"
	}, function(arg0)
		setActive(arg0._tf:Find("Top/Upgrade/Tip"), arg0[1])
	end)

	arg0.env.formulaId = arg0.contextData.formulaId

	arg0:UpdateFilterButtons()
	arg0:BuildActivityEnv()
	arg0:UpdateView()
end

function var0.InitCounter(arg0, arg1, arg2, arg3, arg4)
	arg2[2] = math.max(arg2[1], arg2[2])

	local var0 = arg1
	local var1 = arg0.layerFormulaDetail:Find("Counters")

	assert(var1)

	local function var2()
		local var0 = var0

		if var0 == 0 then
			var0 = setColorStr(var0, "#f9c461")
		end

		setText(var1:Find("Number"), var0)
		arg3(var0)
	end

	var2()
	pressPersistTrigger(var1:Find("Plus"), 0.5, function(arg0)
		local var0 = var0

		var0 = var0 + 1
		var0 = math.clamp(var0, arg2[1], arg2[2])

		if var0 == var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips3"))
			arg0()

			return
		end

		var2()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(var1:Find("Minus"), 0.5, function(arg0)
		local var0 = var0

		var0 = var0 - 1
		var0 = math.clamp(var0, arg2[1], arg2[2])

		if var0 == var0 then
			arg0()

			return
		end

		var2()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, var1:Find("Plus10"), function()
		local var0 = var0

		var0 = var0 + 10
		var0 = math.clamp(var0, arg2[1], arg2[2])

		if var0 == var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips3"))

			return
		end

		var2()
	end)
	onButton(arg0, var1:Find("Minus10"), function()
		var0 = var0 - 10
		var0 = math.clamp(var0, arg2[1], arg2[2])

		var2()
	end)
	onButton(arg0, arg0.layerFormulaDetail:Find("Composite"), function()
		existCall(arg4, var0)
	end, SFX_PANEL)
end

local var3 = {
	[DROP_TYPE_FURNITURE] = "word_furniture",
	[DROP_TYPE_WORKBENCH_DROP] = "workbench_tips7"
}

function var0.UpdateFormulaListItem(arg0, arg1, arg2)
	local var0 = tf(arg2)
	local var1 = arg0.env.filterFormulas[arg1]
	local var2 = var1:GetProduction()
	local var3 = var0:Find("BG/Icon")

	assert(var3)
	arg0:UpdateActivityDrop(var3, {
		type = var2[1],
		id = var2[2]
	}, true)

	local var4 = var3[var2[1]]
	local var5 = not var1:IsUnlock()

	setActive(var0:Find("Lock"), var5)
	setActive(var0:Find("BG"), not var5)

	if var5 then
		setText(var0:Find("Lock/Text"), var1:GetLockDesc())
	end

	setText(var0:Find("BG/Type"), i18n(var4))
	setScrollText(var0:Find("BG/Name/Text"), var1:GetName())
	setActive(var0:Find("Selected"), var1:GetConfigID() == arg0.env.formulaId)

	local var6 = var1:IsAvaliable()

	setActive(var0:Find("Completed"), not var6)

	local var7

	if var1:GetMaxLimit() > 0 then
		local var8 = var1:GetMaxLimit() - var1:GetUsedCount()

		var7 = (var8 <= 0 and setColorStr(var8, "#bb6754") or var8) .. "/" .. var1:GetMaxLimit()
	else
		var7 = "∞"
	end

	setText(var0:Find("BG/Count"), var7)
	onButton(arg0, var0, function()
		if not var6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips1"))

			return
		end

		if var5 then
			local var0 = var1:GetLockLimit()

			pg.TipsMgr.GetInstance():ShowTips(i18n("workbench_tips4", var0 and var0[3]))

			return
		end

		arg0.env.formulaId = var1:GetConfigID()

		arg0:UpdateView()
	end, SFX_PANEL)
end

function var0.UpdateFilterButtons(arg0)
	table.Foreach(arg0.formulaFilterButtons, function(arg0, arg1)
		local var0 = arg0.contextData.filterType ~= var0.FilterAll

		var0 = var0 and bit.band(arg0.contextData.filterType, bit.lshift(1, arg0 - 1)) > 0

		setActive(arg1:Find("Selected"), var0)
		setActive(arg1:Find("UnSelected"), not var0)
	end)
end

function var0.BuildActivityEnv(arg0)
	arg0.env.formulas = _.map(pg.activity_workbench_recipe.all, function(arg0)
		local var0 = WorkBenchFormula.New({
			configId = arg0
		})

		var0:BuildFromActivity()

		return var0
	end)

	if arg0.env.formulaId then
		local var0 = _.detect(arg0.env.formulas, function(arg0)
			return arg0:GetConfigID() == arg0.env.formulaId
		end)

		if not var0 or not var0:IsAvaliable() then
			arg0.env.formulaId = nil
		end
	end

	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	arg0.env.bagAct = var1

	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)

	arg0.env.BuildingLv = var2:GetBuildingLevel(table.keyof(AnniversaryIsland2023Scene.Buildings, "craft"))
	arg0.env.tip = AnniversaryIsland2023Scene.UpdateBuildingTip(nil, var2, table.keyof(AnniversaryIsland2023Scene.Buildings, "craft"))

	arg0:FilterFormulas()
end

function var0.FilterFormulas(arg0)
	local var0 = {}
	local var1 = arg0.contextData.filterType

	local function var2(arg0)
		if var1 == var0.FilterAll then
			return true
		end

		return switch(arg0:GetProduction()[1], {
			[DROP_TYPE_WORKBENCH_DROP] = function()
				return bit.band(var1, 1) > 0
			end
		}, function()
			return bit.band(var1, 2) > 0
		end)
	end

	for iter0, iter1 in ipairs(_.values(arg0.env.formulas)) do
		if var2(iter1) and (not arg0.showOnlyComposite or iter1:IsUnlock() and iter1:IsAvaliable() and _.all(iter1:GetMaterials(), function(arg0)
			local var0 = arg0[1]
			local var1 = arg0[2]

			return arg0[3] <= arg0.env.bagAct:getVitemNumber(var1)
		end)) then
			table.insert(var0, iter1)
		end
	end

	local var3 = CompareFuncs({
		function(arg0)
			return arg0:IsAvaliable() and 0 or 1
		end,
		function(arg0)
			return arg0:IsUnlock() and 0 or 1
		end,
		function(arg0)
			return arg0:GetConfigID()
		end
	})

	table.sort(var0, var3)

	arg0.env.filterFormulas = var0
end

function var0.UpdateFormulaList(arg0)
	local var0 = #arg0.env.filterFormulas == 0

	setActive(arg0.layerFormulaList:Find("Empty"), var0)
	setActive(arg0.layerFormulaList:Find("ScrollView"), not var0)
	arg0.formulaRect:SetTotalCount(#arg0.env.filterFormulas)
end

function var0.UpdateFormulaDetail(arg0, arg1)
	arg0.contextData.formulaId = arg1

	setActive(arg0.layerFormulaDetail, arg1)

	if not arg1 then
		return
	end

	local var0 = _.detect(arg0.env.formulas, function(arg0)
		return arg0:GetConfigID() == arg1
	end)

	assert(var0)

	local var1 = var0:GetProduction()
	local var2 = var0:GetMaterials()
	local var3 = 100

	;(function()
		local var0 = {
			type = var1[1],
			id = var1[2],
			count = var1[3]
		}
		local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORKBENCH)
		local var2 = var0:GetMaxLimit()

		if var2 > 0 then
			var3 = var2 - var1:GetFormulaUseCount(arg1)
		end

		local var3 = arg0.layerFormulaDetail:Find("Icon")

		assert(var3)
		arg0:UpdateActivityDrop(var3, var0)
		onButton(arg0, var3, function()
			if var0.type == DROP_TYPE_WORKBENCH_DROP then
				arg0:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var0.id,
					count = var0.count
				}))
			else
				arg0:emit(BaseUI.ON_DROP, var0)
			end
		end)
		setText(arg0.layerFormulaDetail:Find("Name"), var0:getConfig("name"))
	end)()

	local var4 = var3
	local var5 = arg0.env.bagAct

	UIItemList.StaticAlign(arg0.layerFormulaDetail:Find("Materials"), arg0.layerFormulaDetail:Find("Materials/Item"), #var2, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var2[arg1 + 1]
		local var1 = {
			type = var0[1],
			id = var0[2],
			count = var0[3]
		}

		arg0:UpdateActivityDrop(arg2:Find("Icon"), var1)
		onButton(arg0, arg2:Find("Icon"), function()
			if var1.type == DROP_TYPE_WORKBENCH_DROP then
				arg0:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var1.id,
					count = var1.count
				}))
			else
				arg0:emit(BaseUI.ON_DROP, var1)
			end
		end)

		local var2 = var0[2]
		local var3 = var0[3]
		local var4 = var5:getVitemNumber(var2)

		if var3 > 0 then
			var4 = math.min(var4, math.floor(var4 / var3))
		end
	end)

	local function var6(arg0)
		UIItemList.StaticAlign(arg0.layerFormulaDetail:Find("Materials"), arg0.layerFormulaDetail:Find("Materials/Item"), #var2, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var2[arg1 + 1]
			local var1 = var0[2]
			local var2 = var0[3]
			local var3 = var5:getVitemNumber(var1)

			arg0 = math.max(arg0, 1)

			local var4 = var2 * arg0
			local var5 = setColorStr(var3, var3 < var4 and "#bb6754" or "#6b5a48")

			setText(arg2:Find("Text"), var5 .. "/" .. var4)
		end)
	end

	local var7 = math.min(1, var4)

	arg0:InitCounter(var7, {
		0,
		var4
	}, var6, function(arg0)
		arg0:emit(GAME.WORKBENCH_COMPOSITE, arg1, arg0)
	end)
	var6(var7)
end

function var0.BindEnv(arg0, arg1, arg2)
	table.insert(arg0.listeners, {
		keys = arg1,
		func = arg2
	})
end

function var0.RefreshData(arg0)
	arg0.lastEnv = arg0.lastEnv or {}

	local var0 = {}
	local var1

	local function var2(arg0, arg1)
		if var0[arg0] then
			return
		end

		var0[arg0] = arg1
		var1 = var1 or {}

		local var0 = _.select(arg0.listeners, function(arg0)
			return table.contains(arg0.keys, arg0)
		end)

		_.each(var0, function(arg0)
			var1[arg0] = true
		end)
	end

	for iter0, iter1 in pairs(arg0.env) do
		if iter1 ~= arg0.lastEnv[iter0] then
			var2(iter0, iter1)
		end
	end

	for iter2, iter3 in pairs(arg0.lastEnv) do
		local var3 = arg0.env[iter2]

		if iter3 ~= var3 then
			var2(iter2, var3)
		end
	end

	if var1 then
		table.Foreach(var1, function(arg0)
			local var0 = table.map(arg0.keys, function(arg0)
				return arg0.env[arg0]
			end)
			local var1 = table.map(arg0.keys, function(arg0)
				return arg0.lastEnv[arg0]
			end)

			arg0.func(var0, var1)
		end)
	end

	arg0.lastEnv = table.shallowCopy(arg0.env)
end

function var0.UpdateView(arg0)
	arg0:RefreshData()
	AnniversaryIsland2023Scene.PlayStory()
end

function var0.OnReceiveFormualRequest(arg0, arg1)
	arg0.env.formulaId = arg1

	arg0:UpdateView()
end

function var0.UpdateActivityDrop(arg0, arg1, arg2, arg3)
	updateDrop(arg1, arg2)
	SetCompomentEnabled(arg1:Find("icon_bg"), typeof(Image), false)
	setActive(arg1:Find("bg"), false)
	setActive(arg1:Find("icon_bg/frame"), false)
	setActive(arg1:Find("icon_bg/stars"), false)

	local var0 = arg2:getConfig("rarity")

	if arg2.type == DROP_TYPE_EQUIP or arg2.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0 = var0 - 1
	end

	local var1 = "icon_frame_" .. var0

	if arg3 then
		var1 = var1 .. "_small"
	end

	arg0.loader:GetSpriteQuiet(var2, var1, arg1)
end

function var0.willExit(arg0)
	arg0.loader:Clear()
end

return var0
