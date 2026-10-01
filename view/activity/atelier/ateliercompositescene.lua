local var0_0 = class("AtelierCompositeScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AtelierCompositeUI"
end

local var1_0 = import("model.vo.AtelierFormula")
local var2_0 = import("model.vo.AtelierFormulaCircle")
local var3_0 = import("Mgr.Pool.PoolPlural")

var0_0.FilterAll = bit.bor(1, 2, 4)

function var0_0.Ctor(arg0_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.init(arg0_3)
	arg0_3.layerEmpty = arg0_3._tf:Find("Empty")
	arg0_3.layerFormula = arg0_3._tf:Find("FormulaList")
	arg0_3.painting = arg0_3._tf:Find("Painting")
	arg0_3.chat = arg0_3.painting:Find("Chat")
	arg0_3.layerFormulaDetail = arg0_3._tf:Find("FormulaDetail")
	arg0_3.layerFormulaOverlay = arg0_3.layerFormulaDetail:Find("Overlay")
	arg0_3.layerMaterialSelect = arg0_3.layerFormulaOverlay:Find("AvaliableMaterials")
	arg0_3.layerCompositeConfirm = arg0_3._tf:Find("CompositeConfirmWindow")
	arg0_3.layerCompositeResult = arg0_3._tf:Find("CompositeResultWindow")
	arg0_3.layerStoreHouse = arg0_3._tf:Find("StoreHouseWindow")
	arg0_3.layerMaterialsPreview = arg0_3._tf:Find("FormulaMaterialsPreview")
	arg0_3.top = arg0_3._tf:Find("Top")
	arg0_3.formulaRect = arg0_3.layerFormula:Find("Frame/ScrollView"):GetComponent("LScrollRect")

	local var0_3 = arg0_3.layerFormula:Find("Frame/Item")

	setActive(var0_3, false)

	function arg0_3.formulaRect.onUpdateItem(arg0_4, arg1_4)
		arg0_3:UpdateFormulaItem(arg0_4 + 1, arg1_4)
	end

	arg0_3.formulaFilterButtons = _.map({
		1,
		2,
		3
	}, function(arg0_5)
		return arg0_3.layerFormula:Find("Frame/Tabs"):GetChild(arg0_5 - 1)
	end)
	arg0_3.candicatesRect = arg0_3.layerMaterialSelect:Find("Frame/List"):GetComponent("LScrollRect")

	local var1_3 = arg0_3.layerMaterialSelect:Find("Frame/Item")

	setActive(var1_3, false)

	function arg0_3.candicatesRect.onUpdateItem(arg0_6, arg1_6)
		arg0_3:UpdateCandicateItem(arg0_6 + 1, arg1_6)
	end

	arg0_3.storehouseRect = arg0_3.layerStoreHouse:Find("Window/ScrollView"):GetComponent("LScrollRect")

	local var2_3 = arg0_3.layerStoreHouse:Find("Window/ScrollView/Item")

	setActive(var2_3, false)
	setActive(arg0_3.layerFormula, false)
	setActive(arg0_3.layerFormulaDetail, false)
	setActive(arg0_3.layerMaterialSelect, false)
	setActive(arg0_3.layerEmpty, false)
	setActive(arg0_3.layerStoreHouse, false)
	setActive(arg0_3.chat, false)
	pg.ViewUtils.SetSortingOrder(arg0_3._tf:Find("Mask/BG"):GetChild(0), -1)
	setText(arg0_3._tf:Find("Empty/Bar/Text"), i18n("ryza_tip_composite_unlock"))
	setText(arg0_3.layerFormula:Find("Frame/Filter/Text"), i18n("ryza_toggle_only_composite"))
	setText(arg0_3.layerFormula:Find("Frame/Empty"), i18n("ryza_tip_no_recipe"))
	setText(arg0_3.layerFormula:Find("Frame/Item/Lock/Text"), i18n("ryza_tip_unlock_all_tools"))
	setText(arg0_3.layerFormula:Find("Bar/Text"), i18n("ryza_tip_select_recipe"))
	setText(arg0_3.layerStoreHouse:Find("Window/Empty"), i18n("ryza_tip_no_item"))
	setText(arg0_3.layerCompositeResult:Find("Window/CountBG/Tip"), i18n("ryza_composite_count"))
	setText(arg0_3.layerMaterialsPreview:Find("Frame/Text"), i18n("ryza_tip_item_access"))
	setText(var1_3:Find("IconBG/Lack/Text"), i18n("ryza_ui_show_acess"))
end

function var0_0.SetEnabled(arg0_7, arg1_7)
	arg0_7.unlockSystem = arg1_7
end

function var0_0.SetActivity(arg0_8, arg1_8)
	arg0_8.activity = arg1_8
end

local var4_0 = "ui/AtelierCompositeUI_atlas"
local var5_0 = "ui/AtelierCommonUI_atlas"

function var0_0.preload(arg0_9, arg1_9)
	table.ParallelIpairsAsync({
		var4_0,
		var5_0
	}, function(arg0_10, arg1_10, arg2_10)
		arg0_9.loader:LoadBundle(arg1_10, arg2_10)
	end, arg1_9)
end

function var0_0.getResource(arg0_11)
	local var0_11 = var0_0.super.getResource(arg0_11)
	local var1_11 = {
		var4_0,
		var5_0,
		"ui/laisha_ui_huo_o",
		"ui/laisha_ui_huo_6",
		"ui/laisha_ui_bing_o",
		"ui/laisha_ui_bing_6",
		"ui/laisha_ui_lei_o",
		"ui/laisha_ui_lei_6",
		"ui/laisha_ui_feng_o",
		"ui/laisha_ui_feng_6",
		"ui/laisha_ui_sairen_o",
		"ui/laisha_ui_sairen_6",
		"ui/laisha_ui_wupinshanguang",
		"ui/laisha_ui_jiesuo",
		"ui/laisha_ui_lianjie01",
		"ui/laisha_ui_lianjie02",
		"ui/laisha_ui_lianjie_qiehuan",
		"ui/laisha_ui_wupinzhiru",
		"ui/laisha_ui_baoshi"
	}

	for iter0_11, iter1_11 in ipairs(var1_11) do
		if noEmptyStr(iter1_11) and not table.contains(var0_11, iter1_11) then
			table.insert(var0_11, iter1_11)
		end
	end

	return var0_11
end

function var0_0.didEnter(arg0_12)
	arg0_12.contextData.filterType = var0_0.FilterAll

	table.Foreach(arg0_12.formulaFilterButtons, function(arg0_13, arg1_13)
		onButton(arg0_12, arg1_13, function()
			if arg0_12.contextData.filterType == var0_0.FilterAll then
				arg0_12.contextData.filterType = bit.lshift(1, arg0_13 - 1)
			else
				arg0_12.contextData.filterType = bit.bxor(arg0_12.contextData.filterType, bit.lshift(1, arg0_13 - 1))

				if arg0_12.contextData.filterType == 0 then
					arg0_12.contextData.filterType = var0_0.FilterAll
				end
			end

			arg0_12:UpdateFilterButtons()
			arg0_12:FilterFormulas()
			arg0_12:UpdateFormulaList()
		end, SFX_PANEL)
	end)
	onToggle(arg0_12, arg0_12.layerFormula:Find("Frame/Filter/Toggle"), function(arg0_15)
		arg0_12.showOnlyComposite = arg0_15

		arg0_12:FilterFormulas()
		arg0_12:UpdateFormulaList()
	end)
	onButton(arg0_12, arg0_12.layerFormulaOverlay:Find("Description/List"), function()
		arg0_12:HideFormulaDetail()

		arg0_12.contextData.formulaId = nil

		arg0_12:ShowFormulaList()
	end)
	onButton(arg0_12, arg0_12._tf:Find("Top/Back"), function()
		arg0_12:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12._tf:Find("Top/Home"), function()
		arg0_12:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_composite_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.layerMaterialSelect:Find("BG"), function()
		arg0_12:CloseCandicatePanel()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.layerCompositeConfirm:Find("BG"), function()
		arg0_12:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.layerCompositeConfirm:Find("Window/Cancel"), function()
		arg0_12:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.layerCompositeResult:Find("BG"), function()
		arg0_12:HideCompositeResult()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12._tf:Find("Top/StoreHouse"), function()
		arg0_12.contextData.showStoreHouse = true

		arg0_12:ShowStoreHouseWindow()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.layerStoreHouse:Find("Window/Close"), function()
		arg0_12:CloseStoreHouseWindow()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.layerStoreHouse:Find("BG"), function()
		arg0_12:CloseStoreHouseWindow()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.layerMaterialsPreview:Find("BG"), function()
		arg0_12:HideMaterialsPreview()
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_12.top)

	if not arg0_12.unlockSystem then
		setActive(arg0_12.layerEmpty, true)
		setActive(arg0_12.painting, false)
	else
		if arg0_12.contextData.formulaId then
			local var0_12 = arg0_12.activity:GetFormulas()[arg0_12.contextData.formulaId]

			arg0_12:ShowFormulaDetail(var0_12)
		else
			arg0_12:DispalyChat({
				"ryza_atellier1"
			})
			arg0_12:ShowFormulaList()
		end

		if arg0_12.contextData.showStoreHouse then
			arg0_12:ShowStoreHouseWindow()
		end
	end

	if arg0_12.unlockSystem and PlayerPrefs.GetInt("first_enter_ryza_atelier_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0 then
		triggerButton(arg0_12._tf:Find("Top/Help"))
		PlayerPrefs.SetInt("first_enter_ryza_atelier_" .. getProxy(PlayerProxy):getRawData().id, 1)
	end
end

function var0_0.onBackPressed(arg0_28)
	if arg0_28.animating then
		return true
	end

	if arg0_28:CloseStoreHouseWindow() then
		return true
	end

	if arg0_28:HideMaterialsPreview() then
		return true
	end

	if arg0_28:HideCompositeResult() then
		return true
	end

	if arg0_28:HideCompositeConfirmWindow() then
		return true
	end

	if arg0_28:HideCandicatePanel() then
		return true
	end

	if arg0_28:HideFormulaDetail() then
		arg0_28.contextData.formulaId = nil

		arg0_28:ShowFormulaList()

		return true
	end

	arg0_28:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.UpdateFilterButtons(arg0_29)
	table.Foreach(arg0_29.formulaFilterButtons, function(arg0_30, arg1_30)
		local var0_30 = arg0_29.contextData.filterType ~= var0_0.FilterAll

		var0_30 = var0_30 and bit.band(arg0_29.contextData.filterType, bit.lshift(1, arg0_30 - 1)) > 0

		setActive(arg1_30:Find("Selected"), var0_30)
	end)
end

function var0_0.AddIdleTimer(arg0_31)
	arg0_31:RemoveIdleTimer()

	arg0_31.idleTimer = Timer.New(function()
		arg0_31:DispalyChat({
			"ryza_atellier1"
		})
		arg0_31:AddIdleTimer()
	end, 8 + math.random() * 4)

	arg0_31.idleTimer:Start()
end

function var0_0.RemoveIdleTimer(arg0_33)
	if not arg0_33.idleTimer then
		return
	end

	arg0_33.idleTimer:Stop()

	arg0_33.idleTimer = nil
end

function var0_0.ShowFormulaList(arg0_34)
	arg0_34:AddIdleTimer()
	setActive(arg0_34.layerFormula, true)
	setParent(arg0_34.layerFormula, arg0_34.top)
	arg0_34.layerFormula:SetSiblingIndex(0)
	arg0_34:UpdateFilterButtons()
	arg0_34:FilterFormulas()
	arg0_34:UpdateFormulaList()
end

function var0_0.HideFormulaList(arg0_35)
	if not arg0_35.layerFormula then
		return
	end

	arg0_35:RemoveIdleTimer()
	setParent(arg0_35.layerFormula, arg0_35._tf)
	setActive(arg0_35.layerFormula, false)

	return true
end

function var0_0.FilterFormulas(arg0_36)
	arg0_36.filterFormulas = {}

	local var0_36 = arg0_36.contextData.filterType

	local function var1_36(arg0_37)
		if var0_36 == var0_0.FilterAll then
			return true
		end

		return switch(arg0_37:GetType(), {
			[var1_0.TYPE.EQUIP] = function()
				return bit.band(var0_36, 1) > 0
			end,
			[var1_0.TYPE.ITEM] = function()
				return bit.band(var0_36, 2) > 0
			end,
			[var1_0.TYPE.TOOL] = function()
				return bit.band(var0_36, 4) > 0
			end,
			[var1_0.TYPE.OTHER] = function()
				return bit.band(var0_36, 4) > 0
			end
		})
	end

	for iter0_36, iter1_36 in ipairs(_.values(arg0_36.activity:GetFormulas())) do
		if var1_36(iter1_36) and (not arg0_36.showOnlyComposite or iter1_36:IsAvaliable() and var1_0.IsFormualCanComposite(iter1_36, arg0_36.activity)) then
			table.insert(arg0_36.filterFormulas, iter1_36)
		end
	end

	local function var2_36(arg0_42, arg1_42)
		local var0_42 = {
			function(arg0_43)
				return arg0_43:IsAvaliable() and 0 or 1
			end,
			function(arg0_44)
				if arg0_44:GetType() ~= var1_0.TYPE.TOOL and not arg0_36.activity:IsCompleteAllTools() then
					return 1
				else
					return 0
				end
			end,
			function(arg0_45)
				return arg0_45:GetConfigID()
			end
		}

		for iter0_42, iter1_42 in ipairs(var0_42) do
			local var1_42 = iter1_42(arg0_42)
			local var2_42 = iter1_42(arg1_42)

			if var1_42 ~= var2_42 then
				return var1_42 < var2_42
			end
		end

		return false
	end

	table.sort(arg0_36.filterFormulas, var2_36)
end

function var0_0.UpdateFormulaList(arg0_46)
	local var0_46 = #arg0_46.filterFormulas == 0

	setActive(arg0_46.layerFormula:Find("Frame/Empty"), var0_46)
	setActive(arg0_46.layerFormula:Find("Frame/ScrollView"), not var0_46)
	arg0_46.formulaRect:SetTotalCount(#arg0_46.filterFormulas)
end

local var6_0 = {
	[var1_0.TYPE.EQUIP] = "ryza_word_equip",
	[var1_0.TYPE.ITEM] = "word_item",
	[var1_0.TYPE.TOOL] = "word_tool",
	[var1_0.TYPE.OTHER] = "word_other"
}

function var0_0.UpdateFormulaItem(arg0_47, arg1_47, arg2_47)
	local var0_47 = tf(arg2_47)
	local var1_47 = arg0_47.filterFormulas[arg1_47]
	local var2_47 = var1_47:GetProduction()

	arg0_47:UpdateRyzaDrop(var0_47:Find("BG/Icon"), {
		type = var2_47[1],
		id = var2_47[2]
	}, true)

	local var3_47 = var6_0[var1_47:GetType()]
	local var4_47 = var1_47:GetType() ~= var1_0.TYPE.TOOL and not arg0_47.activity:IsCompleteAllTools()

	setActive(var0_47:Find("Lock"), var4_47)
	setActive(var0_47:Find("BG"), not var4_47)
	setText(var0_47:Find("BG/Type"), i18n(var3_47))
	setScrollText(var0_47:Find("BG/Name/Text"), var1_47:GetName())

	local var5_47

	if var1_47:GetMaxLimit() > 0 then
		var5_47 = var1_47:GetMaxLimit() - var1_47:GetUsedCount() .. "/" .. var1_47:GetMaxLimit()
	else
		var5_47 = "∞"
	end

	local var6_47 = var1_47:IsAvaliable()

	setActive(var0_47:Find("BG/Count"), var6_47)
	setActive(var0_47:Find("Completed"), not var6_47)

	if var6_47 then
		local var7_47 = var1_0.IsFormualCanComposite(var1_47, arg0_47.activity)
		local var8_47 = SummerFeastScene.TransformColor(var7_47 and "4fb3a3" or "d55a54")

		setTextColor(var0_47:Find("BG/Count"), var8_47)
	end

	setText(var0_47:Find("BG/Count"), var5_47)
	onButton(arg0_47, var0_47, function()
		if not var6_47 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

			return
		end

		if var4_47 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_unlock_all_tools"))

			return
		end

		arg0_47:HideFormulaList()
		arg0_47:ShowFormulaDetail(var1_47)
		arg0_47:DispalyChat({
			"ryza_atellier2",
			"ryza_atellier3",
			"ryza_atellier4"
		})
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_1")
	end, SFX_PANEL)
end

function var0_0.UpdateRyzaDrop(arg0_49, arg1_49, arg2_49, arg3_49)
	updateDrop(arg1_49, arg2_49)
	SetCompomentEnabled(arg1_49:Find("icon_bg"), typeof(Image), false)
	setActive(arg1_49:Find("bg"), false)
	setActive(arg1_49:Find("icon_bg/frame"), false)
	setActive(arg1_49:Find("icon_bg/stars"), false)

	local var0_49 = arg2_49:getConfig("rarity")

	if arg2_49.type == DROP_TYPE_EQUIP or arg2_49.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_49 = var0_49 - 1
	end

	local var1_49 = "icon_frame_" .. var0_49

	if arg3_49 then
		var1_49 = var1_49 .. "_small"
	end

	arg0_49.loader:GetSpriteQuiet(var5_0, var1_49, arg1_49)

	if arg2_49.type == DROP_TYPE_EQUIP or arg2_49.type == DROP_TYPE_SPWEAPON then
		onButton(arg0_49, arg1_49, function()
			arg0_49:emit(var0_0.ON_DROP, arg2_49)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_49)
	end
end

local var7_0 = {
	[var2_0.TYPE.BASE] = "circle",
	[var2_0.TYPE.NORMAL] = "hexagon",
	[var2_0.TYPE.SAIREN] = "doubleHexagon",
	[var2_0.TYPE.ANY] = "anyHexagon"
}

function var0_0.ShowFormulaDetail(arg0_51, arg1_51)
	setActive(arg0_51.layerFormulaDetail, true)
	setParent(arg0_51.layerFormulaOverlay, arg0_51.top)
	arg0_51.layerFormulaOverlay:SetSiblingIndex(0)
	setParent(arg0_51.painting, arg0_51.layerFormulaOverlay)
	arg0_51.painting:SetSiblingIndex(0)

	if not arg0_51.nodePools then
		arg0_51.nodePools = {
			circle = var3_0.New(arg0_51.layerFormulaDetail:Find("CircleNode").gameObject, 100),
			hexagon = var3_0.New(arg0_51.layerFormulaDetail:Find("HexagonNode").gameObject, 100),
			anyHexagon = var3_0.New(arg0_51.layerFormulaDetail:Find("AnyHexagonNode").gameObject, 100),
			doubleHexagon = var3_0.New(arg0_51.layerFormulaDetail:Find("DoubleHexagonNode").gameObject, 100)
		}

		table.Foreach(arg0_51.nodePools, function(arg0_52, arg1_52)
			setActive(arg1_52.prefab, false)
		end)
	end

	arg0_51.pluralRoot = arg0_51.pluralRoot or pg.PoolMgr.GetInstance().root
	arg0_51.nodeList = arg0_51.nodeList or {}

	_.each(arg0_51.nodeList, function(arg0_53)
		local var0_53 = arg0_51.nodePools[var7_0[arg0_53.Data:GetType()]]
		local var1_53 = tf(arg0_53.GO)

		SetCompomentEnabled(var1_53:Find("Item"), typeof(Image), false)
		arg0_51.loader:ClearRequest(var1_53:Find("Ring"))
		table.Foreach(arg0_53.links, function(arg0_54)
			local var0_54 = var1_53:Find("Links/" .. arg0_54)

			arg0_51.loader:ClearRequest(var0_54)
		end)
		arg0_51.loader:ClearRequest(var1_53)

		if not var0_53:Enqueue(go(arg0_53.GO)) then
			setParent(go(arg0_53.GO), arg0_51.pluralRoot)
			setActive(go(arg0_53.GO), false)
		end
	end)
	table.clean(arg0_51.nodeList)
	arg0_51:InitFormula(arg1_51)
end

function var0_0.HideFormulaDetail(arg0_55)
	if not isActive(arg0_55.layerFormulaDetail) then
		return
	end

	arg0_55:HideCandicatePanel()
	setParent(arg0_55.painting, arg0_55._tf)
	arg0_55.painting:SetSiblingIndex(1)
	setParent(arg0_55.layerFormulaOverlay, arg0_55.layerFormulaDetail)
	setActive(arg0_55.layerFormulaDetail, false)

	return true
end

local var8_0 = {
	{
		0,
		1
	},
	{
		-1,
		1
	},
	{
		-1,
		0
	},
	{
		0,
		-1
	},
	{
		1,
		-1
	},
	{
		1,
		0
	}
}
local var9_0 = {
	[var1_0.TYPE.EQUIP] = "text_equip",
	[var1_0.TYPE.ITEM] = "text_item",
	[var1_0.TYPE.TOOL] = "text_other",
	[var1_0.TYPE.OTHER] = "text_other"
}

function var0_0.InitFormula(arg0_56, arg1_56)
	arg0_56.contextData.formulaId = arg1_56:GetConfigID()

	local var0_56 = arg0_56.layerFormulaOverlay:Find("Description")

	arg0_56.loader:GetSpriteQuiet(var4_0, var9_0[arg1_56:GetType()], var0_56:Find("Type"))

	local var1_56 = {
		type = arg1_56:GetProduction()[1],
		id = arg1_56:GetProduction()[2]
	}

	arg0_56:UpdateRyzaDrop(var0_56:Find("Icon"), var1_56)
	setText(var0_56:Find("Name"), arg1_56:GetName())
	setText(var0_56:Find("Description/Text"), arg1_56:GetDesc())

	local var2_56 = tostring(arg1_56:GetMaxLimit() - arg1_56:GetUsedCount())

	if arg1_56:GetMaxLimit() < 0 then
		var2_56 = "∞"
	end

	setText(var0_56:Find("RestCount/Text"), i18n("ryza_rest_produce_count", var2_56))
	setActive(arg0_56.layerMaterialSelect, false)

	local var3_56 = arg0_56.layerFormulaDetail:Find("ScrollView/Content")

	setAnchoredPosition(var3_56, Vector2.zero)
	_.each(arg1_56:GetCircleList(), function(arg0_57)
		local var0_57 = var2_0.New({
			configId = arg0_57
		})
		local var1_57 = arg0_56.nodePools[var7_0[var0_57:GetType()]]:Dequeue()

		var1_57.name = arg0_57

		setActive(var1_57, true)
		setParent(tf(var1_57), var3_56)

		local var2_57 = {
			Change = true,
			Data = var0_57,
			GO = var1_57
		}

		table.insert(arg0_56.nodeList, var2_57)
	end)

	local var4_56 = 280
	local var5_56 = math.deg2Rad * 30
	local var6_56 = var4_56 * Vector2.New(math.cos(var5_56), math.sin(var5_56))
	local var7_56 = var4_56 * Vector2(0, 1)
	local var8_56 = Vector2.zero

	local function var9_56(arg0_58, arg1_58)
		setAnchoredPosition(arg0_58.GO, arg1_58)

		local var0_58 = arg0_58.Data:GetNeighbors()

		arg0_58.links = {}

		_.each(var0_58, function(arg0_59)
			local var0_59 = arg0_59[1]
			local var1_59 = arg0_59[2]
			local var2_59 = var8_0[var0_59]
			local var3_59 = var2_59[1] * var6_56 + var2_59[2] * var7_56
			local var4_59 = _.detect(arg0_56.nodeList, function(arg0_60)
				return arg0_60.Data:GetConfigID() == var1_59
			end)

			var4_59.prevLink = {
				(var0_59 + 2) % 5 + 1,
				arg0_58
			}
			arg0_58.links[var0_59] = var4_59

			local var5_59 = arg1_58 + var3_59

			var9_56(var4_59, var5_59)

			var8_56 = Vector2.Max(var8_56, -var5_59)
			var8_56 = Vector2.Max(var8_56, var5_59)
		end)
	end

	var9_56(arg0_56.nodeList[1], Vector2.zero)
	setSizeDelta(var3_56, (var8_56 + Vector2.New(var4_56, var4_56)) * 2)
	onButton(arg0_56, arg0_56.layerFormulaDetail:Find("Composite"), function()
		if not _.all(arg0_56.nodeList, function(arg0_62)
			return arg0_62.Instance
		end) then
			arg0_56:ShowMaterialsPreview()

			return
		end

		if not arg0_56.activity:GetFormulas()[arg0_56.contextData.formulaId]:IsAvaliable() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

			return
		end

		arg0_56:ShowCompositeConfirmWindow()
	end, SFX_PANEL)
	onButton(arg0_56, arg0_56.layerFormulaDetail:Find("AutoFill"), function()
		local var0_63 = {}
		local var1_63 = arg0_56.activity:GetItems()

		local function var2_63(arg0_64)
			local var0_64 = var0_63[arg0_64:GetConfigID()] or Clone(var1_63[arg0_64:GetConfigID()])

			assert(var0_64, "Using Unexist material")

			var0_64.count = var0_64.count - 1
			var0_63[arg0_64:GetConfigID()] = var0_64
		end

		local var3_63 = {}

		_.each(arg0_56.nodeList, function(arg0_65)
			if arg0_65.Instance then
				var2_63(arg0_65.Instance)
			else
				table.insert(var3_63, arg0_65)
			end
		end)

		if #var3_63 <= 0 then
			return
		end

		local var4_63 = true

		local function var5_63()
			if not var4_63 then
				return
			end

			arg0_56:DispalyChat({
				"ryza_atellier5",
				"ryza_atellier6",
				"ryza_atellier7"
			})

			var4_63 = false
		end

		local var6_63 = false
		local var7_63

		local function var8_63()
			if var7_63 and coroutine.status(var7_63) == "suspended" then
				local var0_67, var1_67 = coroutine.resume(var7_63)

				assert(var0_67, debug.traceback(var7_63, var1_67))
			end
		end

		var7_63 = coroutine.create(function()
			_.each(var3_63, function(arg0_69)
				local var0_69 = arg0_69.Data

				if var0_69:GetType() == var2_0.TYPE.BASE or var0_69:GetType() == var2_0.TYPE.SAIREN then
					local var1_69 = var0_69:GetLimitItemID()
					local var2_69 = var0_63[var1_69] or var1_63[var1_69]

					if var2_69 and var2_69.count > 0 then
						var2_63(var2_69)
						var5_63()
						arg0_56:FillNodeAndPlayAnim(arg0_69, AtelierMaterial.New({
							count = 1,
							configId = var1_69
						}), var8_63, true)
						coroutine.yield()
					else
						var6_63 = true
					end
				end
			end)

			if not var6_63 then
				local var0_68 = false
				local var1_68 = false

				arg0_56:DisPlayUnlockEffect(function()
					var0_68 = true

					if var1_68 then
						var8_63()
					end
				end)

				if not var0_68 then
					var1_68 = true

					coroutine.yield()
				end

				local var2_68 = true

				local function var3_68()
					if not var2_68 then
						return
					end

					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_5")

					var2_68 = false
				end

				local var4_68 = AtelierMaterial.bindConfigTable()

				local function var5_68(arg0_72)
					local var0_72 = arg0_72.Data

					for iter0_72, iter1_72 in ipairs(var4_68.all) do
						local var1_72 = var0_63[iter1_72] or var1_63[iter1_72]

						if var1_72 and var1_72.count > 0 and var1_72:IsNormal() and var0_72:CanUseMaterial(var1_72, arg1_56) then
							var2_63(var1_72)
							var5_63()
							var3_68()
							arg0_56:FillNodeAndPlayAnim(arg0_72, AtelierMaterial.New({
								count = 1,
								configId = var1_72:GetConfigID()
							}), true)

							return
						end
					end

					var6_63 = true
				end

				_.each(var3_63, function(arg0_73)
					if arg0_73.Data:GetType() == var2_0.TYPE.NORMAL then
						var5_68(arg0_73)
					end
				end)
				_.each(var3_63, function(arg0_74)
					if arg0_74.Data:GetType() == var2_0.TYPE.ANY then
						var5_68(arg0_74)
					end
				end)
			end

			if var6_63 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_material_not_enough"))
			end

			arg0_56:UpdateFormulaDetail()
		end)

		var8_63()
	end, SFX_PANEL)
	arg0_56:UpdateFormulaDetail()
end

function var0_0.CleanNodeInstance(arg0_75)
	local var0_75 = arg0_75.activity:GetFormulas()[arg0_75.contextData.formulaId]

	if not var0_75:IsAvaliable() then
		arg0_75:HideFormulaDetail()

		arg0_75.contextData.formulaId = nil

		arg0_75:ShowFormulaList()

		return
	end

	_.each(arg0_75.nodeList, function(arg0_76)
		arg0_76.Instance = nil
		arg0_76.Change = true
	end)
	arg0_75:ShowFormulaDetail(var0_75)
end

function var0_0.UpdateFormulaDetail(arg0_77)
	local var0_77 = 0
	local var1_77 = 0
	local var2_77 = tobool(arg0_77.unlockAllBase)

	arg0_77.unlockAllBase = true

	_.each(arg0_77.nodeList, function(arg0_78)
		var0_77 = var0_77 + 1
		var1_77 = var1_77 + (arg0_78.Instance and 1 or 0)
		arg0_77.unlockAllBase = arg0_77.unlockAllBase and (arg0_78.Data:GetType() ~= var2_0.TYPE.BASE and arg0_78.Data:GetType() ~= var2_0.TYPE.SAIREN or arg0_78.Instance)
	end)
	_.each(arg0_77.nodeList, function(arg0_79)
		local var0_79 = not arg0_77.unlockAllBase and arg0_79.Data:GetType() ~= var2_0.TYPE.BASE and arg0_79.Data:GetType() ~= var2_0.TYPE.SAIREN

		arg0_79.ChangeLock = arg0_79.ChangeLock or tobool(arg0_79.Lock) and not var0_79
		arg0_79.Lock = var0_79
	end)

	local var3_77 = arg0_77.unlockAllBase ~= var2_77

	_.each(arg0_77.nodeList, function(arg0_80)
		if var3_77 then
			arg0_80.Change = true
		end

		arg0_77:UpdateNodeView(arg0_80)
	end)
	setText(arg0_77.layerFormulaDetail:Find("Bar/Text"), i18n("ryza_tip_put_materials", var1_77, var0_77))
	setGray(arg0_77.layerFormulaDetail:Find("AutoFill"), not arg0_77.activity:GetFormulas()[arg0_77.contextData.formulaId]:IsAvaliable())
	setActive(arg0_77.layerFormulaDetail:Find("Composite/Disabled"), var1_77 < var0_77)
end

local var10_0 = {
	[var2_0.ELEMENT_TYPE.PYRO] = "laisha_ui_huo",
	[var2_0.ELEMENT_TYPE.CRYO] = "laisha_ui_bing",
	[var2_0.ELEMENT_TYPE.ELECTRO] = "laisha_ui_lei",
	[var2_0.ELEMENT_TYPE.ANEMO] = "laisha_ui_feng",
	[var2_0.ELEMENT_TYPE.SAIREN] = "laisha_ui_sairen"
}
local var11_0 = "laisha_ui_wupinshanguang"
local var12_0 = "laisha_ui_jiesuo"
local var13_0 = {
	"laisha_ui_lianjie01",
	"laisha_ui_lianjie02",
	"laisha_ui_lianjie_qiehuan"
}

function var0_0.UpdateNodeView(arg0_81, arg1_81)
	local var0_81 = tf(arg1_81.GO)

	for iter0_81 = 1, 6 do
		setActive(var0_81:Find("Links"):GetChild(iter0_81 - 1), false)
	end

	local var1_81 = arg1_81.Data

	_.each(var1_81:GetNeighbors(), function(arg0_82)
		setActive(var0_81:Find("Links"):GetChild(arg0_82[1] - 1), true)
	end)

	local var2_81 = var1_81:GetElementName()
	local var3_81 = arg1_81.Lock

	setActive(var0_81:Find("Lock"), var3_81)

	if var3_81 then
		if var1_81:GetType() ~= var2_0.TYPE.ANY then
			arg0_81.loader:GetSpriteQuiet(var5_0, "element_" .. var2_81, var0_81:Find("Lock/Require/Icon"))
		end

		setText(var0_81:Find("Lock/Require/Text"), "X" .. var1_81:GetLevel())
	end

	for iter1_81 = 3, var1_81:GetLevel() + 1, -1 do
		local var4_81 = var0_81:Find("Slots"):GetChild(iter1_81 - 1)

		arg0_81.loader:GetSpriteQuiet(var4_0, "slot_BLOCKED", var4_81:Find("Image"))
	end

	local var5_81 = arg1_81.Instance

	if not var5_81 then
		if var1_81:GetType() == var2_0.TYPE.ANY then
			setActive(var0_81:Find("All"), true)
		else
			setActive(var0_81:Find("Icon"), true)
			arg0_81.loader:GetSpriteQuiet(var4_0, "icon_" .. var2_81, var0_81:Find("Icon"), true)
		end

		setActive(var0_81:Find("Item"), false)

		if var1_81:GetType() == var2_0.TYPE.BASE or var1_81:GetType() == var2_0.TYPE.SAIREN then
			local var6_81 = AtelierMaterial.New({
				configId = var1_81:GetLimitItemID()
			})

			setActive(var0_81:Find("Name"), true)
			setScrollText(var0_81:Find("Name/Rect/Text"), var6_81:GetName())
		else
			setActive(var0_81:Find("Name"), false)
		end

		for iter2_81 = 1, var1_81:GetLevel() do
			local var7_81 = var0_81:Find("Slots"):GetChild(iter2_81 - 1)

			arg0_81.loader:GetSpriteQuiet(var4_0, "slot_NULL", var7_81:Find("Image"))
		end
	else
		local var8_81 = var1_81:GetRingElement(var5_81)
		local var9_81 = var2_0.ELEMENT_NAME[var8_81]

		if var1_81:GetType() == var2_0.TYPE.ANY then
			setActive(var0_81:Find("All"), false)
		else
			setActive(var0_81:Find("Icon"), false)
		end

		setActive(var0_81:Find("Item"), true)

		local var10_81

		if var1_81:GetType() == var2_0.TYPE.BASE or var1_81:GetType() == var2_0.TYPE.SAIREN then
			var10_81 = var5_81:GetBaseCircleTransform()
		else
			var10_81 = var5_81:GetNormalCircleTransform()
		end

		setLocalScale(var0_81:Find("Item"), Vector3.New(unpack(var10_81, 1, 3)))
		setAnchoredPosition(var0_81:Find("Item"), Vector2.New(unpack(var10_81, 4, 5)))
		arg0_81.loader:GetSpriteQuiet(var5_81:GetIconPath(), "", var0_81:Find("Item"), true)
		setActive(var0_81:Find("Name"), true)
		setScrollText(var0_81:Find("Name/Rect/Text"), var5_81:GetName())

		for iter3_81 = 1, var1_81:GetLevel() do
			local var11_81 = var0_81:Find("Slots"):GetChild(iter3_81 - 1)

			arg0_81.loader:GetSpriteQuiet(var4_0, "slot_" .. var9_81, var11_81:Find("Image"))
		end
	end

	local var12_81 = var0_81:Find("Ring")

	setImageColor(var12_81, var1_81:GetElementRingColor(var5_81))

	if arg1_81.Change then
		local var13_81 = arg1_81.Data:GetRingElement(var5_81)

		if var3_81 then
			var13_81 = nil
		end

		if var10_0[var13_81] then
			local var14_81 = arg1_81.Data:GetType() == var2_0.TYPE.BASE and "_o" or "_6"

			arg0_81.loader:GetPrefab("ui/" .. var10_0[var13_81] .. var14_81, "", function(arg0_83)
				setParent(arg0_83, var12_81)
				setAnchoredPosition(arg0_83, Vector2.zero)
			end, var12_81)
		else
			arg0_81.loader:ClearRequest(var12_81)
		end

		table.Foreach(arg1_81.links, function(arg0_84, arg1_84)
			local var0_84 = var0_81:Find("Links/" .. arg0_84)
			local var1_84 = var13_0[3]

			if arg1_84.Lock and var3_81 then
				var1_84 = var13_0[1]
			elseif not arg1_84.Lock and not var3_81 then
				var1_84 = var13_0[2]
			end

			arg0_81.loader:GetPrefab("ui/" .. var1_84, "", function(arg0_85)
				setParent(arg0_85, var0_84:Find("Link"))
				setAnchoredPosition(arg0_85, Vector2.New(0, -15))
			end, var0_84)
		end)

		arg1_81.Change = nil
	end

	if arg1_81.ChangeInstance then
		local var15_81 = var0_81:Find("Item")

		if var5_81 then
			arg0_81.loader:GetPrefab("ui/" .. var11_0, "", function(arg0_86)
				setParent(arg0_86, var15_81)
				setAnchoredPosition(arg0_86, Vector2.zero)
			end, var0_81)
		else
			arg0_81.loader:ClearRequest(var0_81)
		end

		arg1_81.ChangeInstance = nil
	end

	onButton(arg0_81, var0_81, function()
		if var3_81 then
			return
		end

		local var0_87 = arg0_81.layerMaterialSelect:Find("TargetBG")

		var0_87.localRotation = Quaternion.identity

		local var1_87 = var1_81:GetType() == var2_0.TYPE.BASE and 300 or 245

		setSizeDelta(var0_87, {
			x = var1_87,
			y = var1_87
		})

		local var2_87 = arg0_81.layerMaterialSelect:Find("Target")

		arg0_81:ShowCandicatePanel()

		local var3_87 = tf(Instantiate(var0_81))

		SetCompomentEnabled(var3_87, typeof(Button), false)
		setParent(var3_87, var2_87)
		setAnchoredPosition(var3_87, Vector2.zero)

		for iter0_87 = 1, 6 do
			setActive(var3_87:Find("Links"):GetChild(iter0_87 - 1), false)
		end

		local var4_87 = var2_87.anchoredPosition
		local var5_87 = arg0_81.layerFormulaDetail:Find("ScrollView/Content")
		local var6_87 = var0_81.anchoredPosition + arg0_81.layerFormulaDetail:Find("ScrollView").anchoredPosition

		setAnchoredPosition(var5_87, var4_87 - var6_87)

		arg0_81.candicateTarget = arg1_81

		GetComponent(var0_87, typeof(Animator)):SetBool("Selecting", true)
		arg0_81:UpdateCandicatePanel()
	end, SFX_PANEL)
end

function var0_0.FillNodeAndPlayAnim(arg0_88, arg1_88, arg2_88, arg3_88, arg4_88)
	arg0_88:LoadingOn()

	arg1_88.ChangeInstance = arg1_88.ChangeInstance or tobool(arg1_88.Instance) ~= tobool(arg2_88)
	arg1_88.Instance = arg2_88
	arg1_88.Change = true

	local var0_88 = {}
	local var1_88 = {}

	seriesAsync({
		function(arg0_89)
			table.ParallelIpairsAsync({
				"ui/laisha_ui_wupinzhiru",
				"ui/laisha_ui_baoshi"
			}, function(arg0_90, arg1_90, arg2_90)
				var0_88[arg0_90] = arg0_88.loader:GetPrefab(arg1_90, "", function(arg0_91)
					setParent(arg0_91, tf(arg1_88.GO))
					setAnchoredPosition(arg0_91, Vector2.zero)

					var1_88[arg0_90] = arg0_91

					setActive(arg0_91, false)
					arg2_90()
				end)
			end, arg0_89)
		end,
		function(arg0_92)
			setActive(var1_88[1], true)
			arg0_88:managedTween(LeanTween.delayedCall, function()
				if not arg4_88 then
					arg0_88:UpdateFormulaDetail()
				else
					arg0_88:UpdateNodeView(arg1_88)
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_4")
				arg0_92()
			end, 0.2, nil)
		end,
		function(arg0_94)
			setActive(var1_88[2], true)
			arg0_88:managedTween(LeanTween.delayedCall, function()
				arg0_94()
			end, 0.5, nil)
		end,
		function(arg0_96)
			arg0_88.loader:ClearRequest(var0_88[1])
			arg0_88.loader:ClearRequest(var0_88[2])
			arg0_88:LoadingOff()
			existCall(arg3_88)
		end
	})
end

function var0_0.DisPlayUnlockEffect(arg0_97, arg1_97)
	arg0_97.unlockAllBase = true

	_.each(arg0_97.nodeList, function(arg0_98)
		arg0_97.unlockAllBase = arg0_97.unlockAllBase and (arg0_98.Data:GetType() ~= var2_0.TYPE.BASE and arg0_98.Data:GetType() ~= var2_0.TYPE.SAIREN or arg0_98.Instance)
	end)
	_.each(arg0_97.nodeList, function(arg0_99)
		local var0_99 = not arg0_97.unlockAllBase and arg0_99.Data:GetType() ~= var2_0.TYPE.BASE and arg0_99.Data:GetType() ~= var2_0.TYPE.SAIREN

		arg0_99.ChangeLock = arg0_99.ChangeLock or tobool(arg0_99.Lock) and not var0_99
		arg0_99.Lock = var0_99
	end)

	if not _.any(arg0_97.nodeList, function(arg0_100)
		return arg0_100.ChangeLock
	end) then
		existCall(arg1_97)

		return
	end

	arg0_97:LoadingOn()

	local var0_97 = {}

	_.each(arg0_97.nodeList, function(arg0_101)
		local var0_101 = tf(arg0_101.GO)

		if arg0_101.ChangeLock then
			if arg0_101.prevLink then
				arg0_101.prevLink[2].Change = true
			end

			local var1_101 = arg0_97.loader:GetPrefab("ui/" .. var12_0, "", function(arg0_102)
				setParent(arg0_102, var0_101)
				setAnchoredPosition(arg0_102, Vector2.zero)
			end)

			table.insert(var0_97, var1_101)

			arg0_101.ChangeLock = nil
		end
	end)
	arg0_97:managedTween(LeanTween.delayedCall, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_3")
	end, 0.7, nil)
	arg0_97:managedTween(LeanTween.delayedCall, function()
		_.each(var0_97, function(arg0_105)
			arg0_97.loader:ClearRequest(arg0_105)
		end)
		arg0_97:LoadingOff()
		existCall(arg1_97)
	end, 1.7, nil)
end

function var0_0.ShowCandicatePanel(arg0_106)
	arg0_106:DispalyChat({
		"ryza_atellier2",
		"ryza_atellier3",
		"ryza_atellier4"
	})
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_1")
	pg.UIMgr.GetInstance():BlurPanel(arg0_106.top)
	setActive(arg0_106.layerMaterialSelect, true)
	SetCompomentEnabled(arg0_106.layerFormulaDetail:Find("ScrollView"), typeof(ScrollRect), false)
	removeAllChildren(arg0_106.layerMaterialSelect:Find("Target"))
end

function var0_0.CloseCandicatePanel(arg0_107)
	arg0_107:LoadingOn()

	local var0_107 = GetComponent(arg0_107.layerMaterialSelect:Find("TargetBG"), typeof(DftAniEvent))

	var0_107:SetEndEvent(function()
		arg0_107:LoadingOff()
		arg0_107:HideCandicatePanel()
		var0_107:SetEndEvent(nil)
	end)
	GetComponent(arg0_107.layerMaterialSelect:Find("TargetBG"), typeof(Animator)):SetBool("Selecting", false)
end

function var0_0.HideCandicatePanel(arg0_109)
	if not isActive(arg0_109.layerMaterialSelect) then
		return
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0_109.top)
	arg0_109.painting:SetSiblingIndex(1)
	setActive(arg0_109.layerMaterialSelect, false)
	removeAllChildren(arg0_109.layerMaterialSelect:Find("Target"))
	SetCompomentEnabled(arg0_109.layerFormulaDetail:Find("ScrollView"), typeof(ScrollRect), true)

	arg0_109.candicateTarget = nil

	return true
end

function var0_0.UpdateCandicatePanel(arg0_110)
	arg0_110.candicates = {}

	local var0_110 = arg0_110.activity:GetItems()
	local var1_110 = arg0_110.activity:GetFormulas()[arg0_110.contextData.formulaId]
	local var2_110 = AtelierMaterial.bindConfigTable()
	local var3_110 = _.map(var2_110.all, function(arg0_111)
		local var0_111 = var0_110[arg0_111] or AtelierMaterial.New({
			configId = arg0_111
		})

		if arg0_110.candicateTarget.Data:CanUseMaterial(var0_111, var1_110) then
			if var0_110[arg0_111] then
				var0_111 = AtelierMaterial.New({
					configId = arg0_111,
					count = var0_110[arg0_111].count
				})
				var0_111.count = _.reduce(arg0_110.nodeList, var0_111.count, function(arg0_112, arg1_112)
					if arg1_112.Instance and arg1_112.Instance:GetConfigID() == arg0_111 then
						arg0_112 = arg0_112 - 1
					end

					return arg0_112
				end)
			end

			return var0_111
		end
	end)

	table.sort(var3_110, function(arg0_113, arg1_113)
		if arg0_113.count * arg1_113.count == 0 and arg0_113.count - arg1_113.count ~= 0 then
			return arg0_113.count < arg1_113.count
		else
			return arg0_113:GetConfigID() < arg1_113:GetConfigID()
		end
	end)
	_.each(var3_110, function(arg0_114)
		for iter0_114 = 1, math.max(arg0_114.count, 1) do
			table.insert(arg0_110.candicates, arg0_114)
		end
	end)
	arg0_110.candicatesRect:SetTotalCount(#arg0_110.candicates, 0)
end

function var0_0.UpdateCandicateItem(arg0_115, arg1_115, arg2_115)
	local var0_115 = tf(arg2_115)
	local var1_115 = arg0_115.candicates[arg1_115]

	arg0_115:UpdateRyzaItem(var0_115:Find("IconBG"), var1_115, true)

	local var2_115 = var1_115.count <= 0

	setActive(var0_115:Find("IconBG/Lack"), var2_115)
	onButton(arg0_115, var0_115, function()
		if var2_115 then
			var1_115 = CreateShell(var1_115)
			var1_115.count = false

			arg0_115:ShowItemDetail(var1_115)
		else
			arg0_115:DispalyChat({
				"ryza_atellier5",
				"ryza_atellier6",
				"ryza_atellier7"
			})
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_2")

			local var0_116 = arg0_115.candicateTarget

			arg0_115:HideCandicatePanel()
			seriesAsync({
				function(arg0_117)
					arg0_115:FillNodeAndPlayAnim(var0_116, AtelierMaterial.New({
						count = 1,
						configId = var1_115:GetConfigID()
					}), arg0_117, true)
				end,
				function(arg0_118)
					arg0_115:DisPlayUnlockEffect(arg0_118)
				end,
				function(arg0_119)
					arg0_115:UpdateFormulaDetail()
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRyzaItem(arg0_120, arg1_120, arg2_120, arg3_120)
	local var0_120 = "icon_frame_" .. arg2_120:GetRarity()

	if arg3_120 then
		var0_120 = var0_120 .. "_small"
	end

	arg0_120.loader:GetSpriteQuiet(var5_0, var0_120, arg1_120)
	arg0_120.loader:GetSpriteQuiet(arg2_120:GetIconPath(), "", arg1_120:Find("Icon"))

	if not IsNil(arg1_120:Find("Lv")) then
		setText(arg1_120:Find("Lv/Text"), arg2_120:GetLevel())
	end

	local var1_120 = arg2_120:GetProps()
	local var2_120 = CustomIndexLayer.Clone2Full(arg1_120:Find("List"), #var1_120)

	for iter0_120, iter1_120 in ipairs(var2_120) do
		arg0_120.loader:GetSpriteQuiet(var5_0, "element_" .. var2_0.ELEMENT_NAME[var1_120[iter0_120]], iter1_120)
	end

	if not IsNil(arg1_120:Find("Text")) then
		setText(arg1_120:Find("Text"), arg2_120.count)
	end
end

function var0_0.ShowItemDetail(arg0_121, arg1_121)
	arg0_121:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, arg1_121)
end

local var14_0 = 41
local var15_0 = 5

function var0_0.ShowCompositeConfirmWindow(arg0_122)
	setActive(arg0_122.layerCompositeConfirm, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_122.layerCompositeConfirm)

	local var0_122 = 1
	local var1_122 = {}
	local var2_122 = {}

	_.each(arg0_122.nodeList, function(arg0_123)
		local var0_123 = arg0_123.Instance:GetConfigID()

		table.insert(var1_122, {
			key = arg0_123.Data:GetConfigID(),
			value = var0_123
		})

		var2_122[var0_123] = (var2_122[var0_123] or 0) + 1
	end)
	onButton(arg0_122, arg0_122.layerCompositeConfirm:Find("Window/Confirm"), function()
		arg0_122:emit(GAME.COMPOSITE_ATELIER_RECIPE, var1_122, var0_122)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_6")
	end, SFX_PANEL)

	local var3_122 = arg0_122.activity:GetFormulas()[arg0_122.contextData.formulaId]
	local var4_122 = var3_122:GetMaxLimit() ~= 1
	local var5_122 = var3_122:GetMaxLimit() > 0 and var3_122:GetMaxLimit() - var3_122:GetUsedCount() or 10000
	local var6_122 = arg0_122.activity:GetItems()

	for iter0_122, iter1_122 in pairs(var2_122) do
		local var7_122 = var6_122[iter0_122] and var6_122[iter0_122].count or 0

		var5_122 = math.min(var5_122, math.floor(var7_122 / iter1_122))
	end

	local var8_122 = var5_122
	local var9_122 = {
		1,
		var4_122 and var8_122 or 1
	}
	local var10_122 = Drop.New({
		type = var3_122:GetProduction()[1],
		id = var3_122:GetProduction()[2]
	})

	arg0_122:UpdateRyzaDrop(arg0_122.layerCompositeConfirm:Find("Window/Icon"), var10_122)

	local var11_122 = arg0_122.layerCompositeConfirm:Find("Window/Counters")
	local var12_122 = var10_122:getConfig("name")

	setActive(var11_122, var4_122)

	if var4_122 then
		setAnchoredPosition(arg0_122.layerCompositeConfirm:Find("Window/Icon"), {
			y = var14_0
		})

		local function var13_122()
			setText(var11_122:Find("Number"), var0_122)
			setText(arg0_122.layerCompositeConfirm:Find("Window/Text"), i18n("ryza_composite_confirm", var12_122, var0_122))
		end

		var13_122()
		onButton(arg0_122, var11_122:Find("Plus"), function()
			local var0_126 = var0_122

			var0_122 = var0_122 + 1
			var0_122 = math.clamp(var0_122, var9_122[1], var9_122[2])

			if var0_126 == var0_122 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13_122()
		end)
		onButton(arg0_122, var11_122:Find("Minus"), function()
			var0_122 = var0_122 - 1
			var0_122 = math.clamp(var0_122, var9_122[1], var9_122[2])

			var13_122()
		end)
		onButton(arg0_122, var11_122:Find("Plus10"), function()
			local var0_128 = var0_122

			var0_122 = var0_122 + 10
			var0_122 = math.clamp(var0_122, var9_122[1], var9_122[2])

			if var0_128 == var0_122 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13_122()
		end)
		onButton(arg0_122, var11_122:Find("Minus10"), function()
			var0_122 = var0_122 - 10
			var0_122 = math.clamp(var0_122, var9_122[1], var9_122[2])

			var13_122()
		end)
	else
		setAnchoredPosition(arg0_122.layerCompositeConfirm:Find("Window/Icon"), {
			y = var15_0
		})
		setText(arg0_122.layerCompositeConfirm:Find("Window/Text"), i18n("ryza_composite_confirm_single", var12_122, var0_122))
	end
end

function var0_0.HideCompositeConfirmWindow(arg0_130)
	if not isActive(arg0_130.layerCompositeConfirm) then
		return
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_130.layerCompositeConfirm, arg0_130._tf)
	setActive(arg0_130.layerCompositeConfirm, false)

	return true
end

local var16_0 = "laisha_lianjin"

function var0_0.OnCompositeResult(arg0_131, arg1_131)
	arg0_131:LoadingOn()
	arg0_131:DispalyChat({
		"ryza_atellier8",
		"ryza_atellier9"
	})

	local var0_131 = 1.5
	local var1_131 = 0.5

	arg0_131.loader:GetPrefab("ui/" .. var16_0, "", function(arg0_132)
		pg.UIMgr.GetInstance():OverlayPanel(tf(arg0_132))
		setAnchoredPosition(arg0_132, Vector2.zero)
		arg0_131:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_131._tf, typeof(CanvasGroup)), 0, var0_131):setFrom(1)
		arg0_131:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_131.top, typeof(CanvasGroup)), 0, var0_131):setFrom(1)
		arg0_131:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_131.layerCompositeConfirm, typeof(CanvasGroup)), 0, var0_131):setFrom(1)
		arg0_131:managedTween(LeanTween.delayedCall, function()
			arg0_131:HideCompositeConfirmWindow()
			setCanvasGroupAlpha(arg0_131.layerCompositeConfirm, 1)
			arg0_131:CleanNodeInstance()
			arg0_131:ShowCompositeResult(arg1_131)
			arg0_131:DispalyChat({
				"ryza_atellier10",
				"ryza_atellier11"
			})
			arg0_131:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_131._tf, typeof(CanvasGroup)), 1, var1_131):setFrom(0)
			arg0_131:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_131.top, typeof(CanvasGroup)), 1, var1_131):setFrom(0)
			arg0_131:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0_131.layerCompositeResult, typeof(CanvasGroup)), 1, var1_131):setFrom(0)
			arg0_131:managedTween(LeanTween.delayedCall, function()
				arg0_131:LoadingOff()
				pg.UIMgr.GetInstance():UnOverlayPanel(tf(arg0_132), arg0_131._tf)
				arg0_131.loader:ClearRequest("CompositeResult")
			end, go(arg0_131.layerCompositeResult), var1_131, nil)
		end, go(arg0_131.layerCompositeResult), var0_131, nil)
	end, "CompositeResult")
end

function var0_0.ShowCompositeResult(arg0_135, arg1_135)
	setActive(arg0_135.layerCompositeResult, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_135.layerCompositeResult)

	local var0_135 = arg1_135[1]

	if var0_135 == nil then
		return
	end

	arg0_135:UpdateRyzaDrop(arg0_135.layerCompositeResult:Find("Window/Icon"), var0_135)
	setScrollText(arg0_135.layerCompositeResult:Find("Window/NameBG/Rect/Name"), var0_135:getName())
	setText(arg0_135.layerCompositeResult:Find("Window/CountBG/Text"), var0_135.count)
end

function var0_0.HideCompositeResult(arg0_136)
	if not isActive(arg0_136.layerCompositeResult) then
		return
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_136.layerCompositeResult, arg0_136._tf)
	setActive(arg0_136.layerCompositeResult, false)

	if pg.NewStoryMgr.GetInstance():IsPlayed("NG0032") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0033", {
			2
		})
	end

	return true
end

function var0_0.ShowStoreHouseWindow(arg0_137)
	setActive(arg0_137.layerStoreHouse, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_137.layerStoreHouse)

	local var0_137 = _.filter(_.values(arg0_137.activity:GetItems()), function(arg0_138)
		return arg0_138.count > 0
	end)

	table.sort(var0_137, function(arg0_139, arg1_139)
		return arg0_139:GetConfigID() < arg1_139:GetConfigID()
	end)
	setActive(arg0_137.layerStoreHouse:Find("Window/Empty"), #var0_137 == 0)
	setActive(arg0_137.layerStoreHouse:Find("Window/ScrollView"), #var0_137 > 0)

	if #var0_137 == 0 then
		return
	end

	function arg0_137.storehouseRect.onUpdateItem(arg0_140, arg1_140)
		arg0_140 = arg0_140 + 1

		local var0_140 = tf(arg1_140)
		local var1_140 = var0_137[arg0_140]

		arg0_137:UpdateRyzaItem(var0_140:Find("IconBG"), var1_140)
		setScrollText(var0_140:Find("NameBG/Rect/Name"), var1_140:GetName())
		onButton(arg0_137, var0_140, function()
			arg0_137:ShowItemDetail(var1_140)
		end, SFX_PANEL)
	end

	arg0_137.storehouseRect:SetTotalCount(#var0_137)
end

function var0_0.CloseStoreHouseWindow(arg0_142)
	arg0_142.contextData.showStoreHouse = nil

	return arg0_142:HideStoreHouseWindow()
end

function var0_0.HideStoreHouseWindow(arg0_143)
	if not isActive(arg0_143.layerStoreHouse) then
		return
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_143.layerStoreHouse, arg0_143._tf)
	setActive(arg0_143.layerStoreHouse, false)

	return true
end

function var0_0.ShowMaterialsPreview(arg0_144)
	setActive(arg0_144.layerMaterialsPreview, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_144.layerMaterialsPreview)

	local var0_144 = arg0_144.activity:GetItems()
	local var1_144 = arg0_144.activity:GetFormulas()[arg0_144.contextData.formulaId]
	local var2_144 = AtelierMaterial.bindConfigTable()
	local var3_144 = {}
	local var4_144 = {}
	local var5_144 = {}

	local function var6_144(arg0_145)
		local var0_145 = var5_144[arg0_145:GetConfigID()] or Clone(var0_144[arg0_145:GetConfigID()])

		assert(var0_145, "Using Unexist material")

		var0_145.count = var0_145.count - 1
		var5_144[arg0_145:GetConfigID()] = var0_145
	end

	_.each(arg0_144.nodeList, function(arg0_146)
		local var0_146 = arg0_146.Data

		if var0_146:GetType() == var2_0.TYPE.BASE or var0_146:GetType() == var2_0.TYPE.SAIREN then
			local var1_146 = var0_146:GetLimitItemID()
			local var2_146 = var5_144[var1_146] or var0_144[var1_146]

			if var2_146 and var2_146.count > 0 then
				local var3_146 = AtelierMaterial.New({
					configId = var1_146
				})

				var3_146.count = false

				table.insert(var3_144, var3_146)
				var6_144(var2_146)
			else
				local var4_146 = AtelierMaterial.New({
					configId = var1_146
				})

				var4_146.count = false

				table.insert(var4_144, var4_146)
			end
		end
	end)

	local function var7_144(arg0_147)
		if arg0_147.Instance then
			local var0_147 = AtelierMaterial.New({
				configId = arg0_147.Instance:GetConfigID()
			})

			var0_147.count = false

			table.insert(var3_144, var0_147)
			var6_144(arg0_147.Instance)

			return
		end

		local var1_147 = arg0_147.Data
		local var2_147

		for iter0_147, iter1_147 in ipairs(var2_144.all) do
			local var3_147 = var5_144[iter1_147] or var0_144[iter1_147] or AtelierMaterial.New({
				configId = iter1_147
			})

			if var3_147:IsNormal() and var1_147:CanUseMaterial(var3_147, var1_144) then
				var2_147 = var2_147 or iter1_147

				if var3_147.count > 0 then
					local var4_147 = AtelierMaterial.New({
						configId = iter1_147
					})

					var4_147.count = false

					table.insert(var3_144, var4_147)
					var6_144(var3_147)

					return
				end
			end
		end

		local var5_147 = AtelierMaterial.New({
			configId = var2_147
		})

		var5_147.count = false

		table.insert(var4_144, var5_147)
	end

	_.each(arg0_144.nodeList, function(arg0_148)
		if arg0_148.Data:GetType() == var2_0.TYPE.NORMAL then
			var7_144(arg0_148)
		end
	end)
	_.each(arg0_144.nodeList, function(arg0_149)
		if arg0_149.Data:GetType() == var2_0.TYPE.ANY then
			var7_144(arg0_149)
		end
	end)

	local function var8_144(arg0_150, arg1_150)
		return arg0_150:GetConfigID() < arg1_150:GetConfigID()
	end

	table.sort(var3_144, var8_144)
	table.sort(var4_144, var8_144)

	local function var9_144()
		local var0_151 = arg0_144.layerMaterialsPreview:Find("Frame/Scroll/Content/Owned/List")

		setActive(var0_151.parent, #var3_144 > 0)

		if #var3_144 == 0 then
			return
		end

		local var1_151 = CustomIndexLayer.Clone2Full(var0_151, #var3_144)

		table.Foreach(var1_151, function(arg0_152, arg1_152)
			local var0_152 = var3_144[arg0_152]

			arg0_144:UpdateRyzaItem(arg1_152:Find("IconBG"), var0_152, true)
			onButton(arg0_144, arg1_152, function()
				arg0_144:ShowItemDetail(var0_152)
			end, SFX_PANEL)
		end)
	end

	local function var10_144()
		local var0_154 = arg0_144.layerMaterialsPreview:Find("Frame/Scroll/Content/Lack/List")

		setActive(var0_154.parent, #var4_144 > 0)

		if #var4_144 == 0 then
			return
		end

		local var1_154 = CustomIndexLayer.Clone2Full(var0_154, #var4_144)

		table.Foreach(var1_154, function(arg0_155, arg1_155)
			local var0_155 = var4_144[arg0_155]

			arg0_144:UpdateRyzaItem(arg1_155:Find("IconBG"), var0_155, true)
			onButton(arg0_144, arg1_155, function()
				arg0_144:ShowItemDetail(var0_155)
			end, SFX_PANEL)
		end)
	end

	var9_144()
	var10_144()
end

function var0_0.HideMaterialsPreview(arg0_157)
	if not isActive(arg0_157.layerMaterialsPreview) then
		return
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_157.layerMaterialsPreview, arg0_157._tf)
	setActive(arg0_157.layerMaterialsPreview, false)

	return true
end

function var0_0.OnReceiveFormualRequest(arg0_158, arg1_158)
	arg0_158:HideCandicatePanel()
	arg0_158:HideCompositeConfirmWindow()
	arg0_158:HideCompositeResult()
	arg0_158:HideMaterialsPreview()
	arg0_158:CloseStoreHouseWindow()
	arg0_158:HideFormulaList()

	local var0_158 = arg0_158.activity:GetFormulas()[arg1_158]

	arg0_158:ShowFormulaDetail(var0_158)
end

function var0_0.DispalyChat(arg0_159, arg1_159)
	arg0_159:HideChat()
	setActive(arg0_159.chat, true)

	arg0_159.chatTween = LeanTween.delayedCall(go(arg0_159.chat), 4, System.Action(function()
		arg0_159:HideChat()
	end)).uniqueId

	local var0_159 = arg1_159[math.random(#arg1_159)]
	local var1_159 = pg.gametip.ryza_composite_words.tip
	local var2_159 = _.detect(var1_159, function(arg0_161)
		return arg0_161[1] == var0_159
	end)
	local var3_159 = var2_159 and var2_159[2]

	setText(arg0_159.chat:Find("Text"), var3_159)

	local var4_159 = 1090001
	local var5_159 = "event:/cv/" .. var4_159 .. "/" .. var0_159

	arg0_159:PlaySound(var5_159)
end

function var0_0.HideChat(arg0_162)
	if arg0_162.chatTween then
		LeanTween.cancel(arg0_162.chatTween)

		arg0_162.chatTween = nil
	end

	setActive(arg0_162.chat, false)
end

function var0_0.PlaySound(arg0_163, arg1_163, arg2_163)
	if not arg0_163.playbackInfo or arg1_163 ~= arg0_163.prevCvPath or arg0_163.playbackInfo.channelPlayer == nil then
		arg0_163:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_163, function(arg0_164)
			if arg0_164 then
				arg0_163.playbackInfo = arg0_164

				arg0_163.playbackInfo:SetIgnoreAutoUnload(true)

				if arg2_163 then
					arg2_163(arg0_163.playbackInfo.cueInfo)
				end
			elseif arg2_163 then
				arg2_163()
			end
		end)

		arg0_163.prevCvPath = arg1_163

		if arg0_163.playbackInfo == nil then
			return nil
		end

		return arg0_163.playbackInfo.cueInfo
	elseif arg0_163.playbackInfo then
		arg0_163.playbackInfo:PlaybackStop()
		arg0_163.playbackInfo:SetStartTimeAndPlay()

		if arg2_163 then
			arg2_163(arg0_163.playbackInfo.cueInfo)
		end

		return arg0_163.playbackInfo.cueInfo
	elseif arg2_163 then
		arg2_163()
	end

	return nil
end

function var0_0.StopSound(arg0_165)
	if arg0_165.playbackInfo then
		pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0_165.playbackInfo)
		arg0_165.playbackInfo:SetIgnoreAutoUnload(false)
	end
end

function var0_0.ClearSound(arg0_166)
	arg0_166:StopSound()

	if arg0_166.playbackInfo then
		arg0_166.playbackInfo:Dispose()

		arg0_166.playbackInfo = nil
	end
end

function var0_0.LoadingOn(arg0_167)
	if arg0_167.animating then
		return
	end

	arg0_167.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.LoadingOff(arg0_168)
	if not arg0_168.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0_168.animating = false
end

function var0_0.willExit(arg0_169)
	arg0_169.loader:Clear()
	arg0_169:LoadingOff()
	arg0_169:HideChat()
	arg0_169:ClearSound()
	arg0_169:HideStoreHouseWindow()
	arg0_169:HideMaterialsPreview()
	arg0_169:HideCompositeResult()
	arg0_169:HideCompositeConfirmWindow()
	arg0_169:HideCandicatePanel()
	arg0_169:HideFormulaDetail()
	arg0_169:HideFormulaList()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_169.top, arg0_169._tf)

	if arg0_169.nodePools then
		for iter0_169, iter1_169 in pairs(arg0_169.nodePools) do
			iter1_169:ClearItems()
		end
	end
end

return var0_0
