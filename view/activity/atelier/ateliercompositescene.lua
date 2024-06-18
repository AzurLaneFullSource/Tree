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

function var0_0.didEnter(arg0_11)
	arg0_11.contextData.filterType = var0_0.FilterAll

	table.Foreach(arg0_11.formulaFilterButtons, function(arg0_12, arg1_12)
		onButton(arg0_11, arg1_12, function()
			if arg0_11.contextData.filterType == var0_0.FilterAll then
				arg0_11.contextData.filterType = bit.lshift(1, arg0_12 - 1)
			else
				arg0_11.contextData.filterType = bit.bxor(arg0_11.contextData.filterType, bit.lshift(1, arg0_12 - 1))

				if arg0_11.contextData.filterType == 0 then
					arg0_11.contextData.filterType = var0_0.FilterAll
				end
			end

			arg0_11:UpdateFilterButtons()
			arg0_11:FilterFormulas()
			arg0_11:UpdateFormulaList()
		end, SFX_PANEL)
	end)
	onToggle(arg0_11, arg0_11.layerFormula:Find("Frame/Filter/Toggle"), function(arg0_14)
		arg0_11.showOnlyComposite = arg0_14

		arg0_11:FilterFormulas()
		arg0_11:UpdateFormulaList()
	end)
	onButton(arg0_11, arg0_11.layerFormulaOverlay:Find("Description/List"), function()
		arg0_11:HideFormulaDetail()

		arg0_11.contextData.formulaId = nil

		arg0_11:ShowFormulaList()
	end)
	onButton(arg0_11, arg0_11._tf:Find("Top/Back"), function()
		arg0_11:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11._tf:Find("Top/Home"), function()
		arg0_11:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_composite_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.layerMaterialSelect:Find("BG"), function()
		arg0_11:CloseCandicatePanel()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.layerCompositeConfirm:Find("BG"), function()
		arg0_11:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.layerCompositeConfirm:Find("Window/Cancel"), function()
		arg0_11:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.layerCompositeResult:Find("BG"), function()
		arg0_11:HideCompositeResult()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11._tf:Find("Top/StoreHouse"), function()
		arg0_11.contextData.showStoreHouse = true

		arg0_11:ShowStoreHouseWindow()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.layerStoreHouse:Find("Window/Close"), function()
		arg0_11:CloseStoreHouseWindow()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.layerStoreHouse:Find("BG"), function()
		arg0_11:CloseStoreHouseWindow()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.layerMaterialsPreview:Find("BG"), function()
		arg0_11:HideMaterialsPreview()
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_11.top)

	if not arg0_11.unlockSystem then
		setActive(arg0_11.layerEmpty, true)
		setActive(arg0_11.painting, false)
	else
		if arg0_11.contextData.formulaId then
			local var0_11 = arg0_11.activity:GetFormulas()[arg0_11.contextData.formulaId]

			arg0_11:ShowFormulaDetail(var0_11)
		else
			arg0_11:DispalyChat({
				"ryza_atellier1"
			})
			arg0_11:ShowFormulaList()
		end

		if arg0_11.contextData.showStoreHouse then
			arg0_11:ShowStoreHouseWindow()
		end
	end

	if arg0_11.unlockSystem and PlayerPrefs.GetInt("first_enter_ryza_atelier_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0 then
		triggerButton(arg0_11._tf:Find("Top/Help"))
		PlayerPrefs.SetInt("first_enter_ryza_atelier_" .. getProxy(PlayerProxy):getRawData().id, 1)
	end
end

function var0_0.onBackPressed(arg0_27)
	if arg0_27.animating then
		return true
	end

	if arg0_27:CloseStoreHouseWindow() then
		return true
	end

	if arg0_27:HideMaterialsPreview() then
		return true
	end

	if arg0_27:HideCompositeResult() then
		return true
	end

	if arg0_27:HideCompositeConfirmWindow() then
		return true
	end

	if arg0_27:HideCandicatePanel() then
		return true
	end

	if arg0_27:HideFormulaDetail() then
		arg0_27.contextData.formulaId = nil

		arg0_27:ShowFormulaList()

		return true
	end

	arg0_27:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.UpdateFilterButtons(arg0_28)
	table.Foreach(arg0_28.formulaFilterButtons, function(arg0_29, arg1_29)
		local var0_29 = arg0_28.contextData.filterType ~= var0_0.FilterAll

		var0_29 = var0_29 and bit.band(arg0_28.contextData.filterType, bit.lshift(1, arg0_29 - 1)) > 0

		setActive(arg1_29:Find("Selected"), var0_29)
	end)
end

function var0_0.AddIdleTimer(arg0_30)
	arg0_30:RemoveIdleTimer()

	arg0_30.idleTimer = Timer.New(function()
		arg0_30:DispalyChat({
			"ryza_atellier1"
		})
		arg0_30:AddIdleTimer()
	end, 8 + math.random() * 4)

	arg0_30.idleTimer:Start()
end

function var0_0.RemoveIdleTimer(arg0_32)
	if not arg0_32.idleTimer then
		return
	end

	arg0_32.idleTimer:Stop()

	arg0_32.idleTimer = nil
end

function var0_0.ShowFormulaList(arg0_33)
	arg0_33:AddIdleTimer()
	setActive(arg0_33.layerFormula, true)
	setParent(arg0_33.layerFormula, arg0_33.top)
	arg0_33.layerFormula:SetSiblingIndex(0)
	arg0_33:UpdateFilterButtons()
	arg0_33:FilterFormulas()
	arg0_33:UpdateFormulaList()
end

function var0_0.HideFormulaList(arg0_34)
	if not arg0_34.layerFormula then
		return
	end

	arg0_34:RemoveIdleTimer()
	setParent(arg0_34.layerFormula, arg0_34._tf)
	setActive(arg0_34.layerFormula, false)

	return true
end

function var0_0.FilterFormulas(arg0_35)
	arg0_35.filterFormulas = {}

	local var0_35 = arg0_35.contextData.filterType

	local function var1_35(arg0_36)
		if var0_35 == var0_0.FilterAll then
			return true
		end

		return switch(arg0_36:GetType(), {
			[var1_0.TYPE.EQUIP] = function()
				return bit.band(var0_35, 1) > 0
			end,
			[var1_0.TYPE.ITEM] = function()
				return bit.band(var0_35, 2) > 0
			end,
			[var1_0.TYPE.TOOL] = function()
				return bit.band(var0_35, 4) > 0
			end,
			[var1_0.TYPE.OTHER] = function()
				return bit.band(var0_35, 4) > 0
			end
		})
	end

	for iter0_35, iter1_35 in ipairs(_.values(arg0_35.activity:GetFormulas())) do
		if var1_35(iter1_35) and (not arg0_35.showOnlyComposite or iter1_35:IsAvaliable() and var1_0.IsFormualCanComposite(iter1_35, arg0_35.activity)) then
			table.insert(arg0_35.filterFormulas, iter1_35)
		end
	end

	local function var2_35(arg0_41, arg1_41)
		local var0_41 = {
			function(arg0_42)
				return arg0_42:IsAvaliable() and 0 or 1
			end,
			function(arg0_43)
				if arg0_43:GetType() ~= var1_0.TYPE.TOOL and not arg0_35.activity:IsCompleteAllTools() then
					return 1
				else
					return 0
				end
			end,
			function(arg0_44)
				return arg0_44:GetConfigID()
			end
		}

		for iter0_41, iter1_41 in ipairs(var0_41) do
			local var1_41 = iter1_41(arg0_41)
			local var2_41 = iter1_41(arg1_41)

			if var1_41 ~= var2_41 then
				return var1_41 < var2_41
			end
		end

		return false
	end

	table.sort(arg0_35.filterFormulas, var2_35)
end

function var0_0.UpdateFormulaList(arg0_45)
	local var0_45 = #arg0_45.filterFormulas == 0

	setActive(arg0_45.layerFormula:Find("Frame/Empty"), var0_45)
	setActive(arg0_45.layerFormula:Find("Frame/ScrollView"), not var0_45)
	arg0_45.formulaRect:SetTotalCount(#arg0_45.filterFormulas)
end

local var6_0 = {
	[var1_0.TYPE.EQUIP] = "ryza_word_equip",
	[var1_0.TYPE.ITEM] = "word_item",
	[var1_0.TYPE.TOOL] = "word_tool",
	[var1_0.TYPE.OTHER] = "word_other"
}

function var0_0.UpdateFormulaItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = tf(arg2_46)
	local var1_46 = arg0_46.filterFormulas[arg1_46]
	local var2_46 = var1_46:GetProduction()

	arg0_46:UpdateRyzaDrop(var0_46:Find("BG/Icon"), {
		type = var2_46[1],
		id = var2_46[2]
	}, true)

	local var3_46 = var6_0[var1_46:GetType()]
	local var4_46 = var1_46:GetType() ~= var1_0.TYPE.TOOL and not arg0_46.activity:IsCompleteAllTools()

	setActive(var0_46:Find("Lock"), var4_46)
	setActive(var0_46:Find("BG"), not var4_46)
	setText(var0_46:Find("BG/Type"), i18n(var3_46))
	setScrollText(var0_46:Find("BG/Name/Text"), var1_46:GetName())

	local var5_46

	if var1_46:GetMaxLimit() > 0 then
		var5_46 = var1_46:GetMaxLimit() - var1_46:GetUsedCount() .. "/" .. var1_46:GetMaxLimit()
	else
		var5_46 = "∞"
	end

	local var6_46 = var1_46:IsAvaliable()

	setActive(var0_46:Find("BG/Count"), var6_46)
	setActive(var0_46:Find("Completed"), not var6_46)

	if var6_46 then
		local var7_46 = var1_0.IsFormualCanComposite(var1_46, arg0_46.activity)
		local var8_46 = SummerFeastScene.TransformColor(var7_46 and "4fb3a3" or "d55a54")

		setTextColor(var0_46:Find("BG/Count"), var8_46)
	end

	setText(var0_46:Find("BG/Count"), var5_46)
	onButton(arg0_46, var0_46, function()
		if not var6_46 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

			return
		end

		if var4_46 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_unlock_all_tools"))

			return
		end

		arg0_46:HideFormulaList()
		arg0_46:ShowFormulaDetail(var1_46)
		arg0_46:DispalyChat({
			"ryza_atellier2",
			"ryza_atellier3",
			"ryza_atellier4"
		})
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_1")
	end, SFX_PANEL)
end

function var0_0.UpdateRyzaDrop(arg0_48, arg1_48, arg2_48, arg3_48)
	updateDrop(arg1_48, arg2_48)
	SetCompomentEnabled(arg1_48:Find("icon_bg"), typeof(Image), false)
	setActive(arg1_48:Find("bg"), false)
	setActive(arg1_48:Find("icon_bg/frame"), false)
	setActive(arg1_48:Find("icon_bg/stars"), false)

	local var0_48 = arg2_48:getConfig("rarity")

	if arg2_48.type == DROP_TYPE_EQUIP or arg2_48.type == DROP_TYPE_EQUIPMENT_SKIN then
		var0_48 = var0_48 - 1
	end

	local var1_48 = "icon_frame_" .. var0_48

	if arg3_48 then
		var1_48 = var1_48 .. "_small"
	end

	arg0_48.loader:GetSpriteQuiet(var5_0, var1_48, arg1_48)

	if arg2_48.type == DROP_TYPE_EQUIP or arg2_48.type == DROP_TYPE_SPWEAPON then
		onButton(arg0_48, arg1_48, function()
			arg0_48:emit(var0_0.ON_DROP, arg2_48)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_48)
	end
end

local var7_0 = {
	[var2_0.TYPE.BASE] = "circle",
	[var2_0.TYPE.NORMAL] = "hexagon",
	[var2_0.TYPE.SAIREN] = "doubleHexagon",
	[var2_0.TYPE.ANY] = "anyHexagon"
}

function var0_0.ShowFormulaDetail(arg0_50, arg1_50)
	setActive(arg0_50.layerFormulaDetail, true)
	setParent(arg0_50.layerFormulaOverlay, arg0_50.top)
	arg0_50.layerFormulaOverlay:SetSiblingIndex(0)
	setParent(arg0_50.painting, arg0_50.layerFormulaOverlay)
	arg0_50.painting:SetSiblingIndex(0)

	if not arg0_50.nodePools then
		arg0_50.nodePools = {
			circle = var3_0.New(arg0_50.layerFormulaDetail:Find("CircleNode").gameObject, 100),
			hexagon = var3_0.New(arg0_50.layerFormulaDetail:Find("HexagonNode").gameObject, 100),
			anyHexagon = var3_0.New(arg0_50.layerFormulaDetail:Find("AnyHexagonNode").gameObject, 100),
			doubleHexagon = var3_0.New(arg0_50.layerFormulaDetail:Find("DoubleHexagonNode").gameObject, 100)
		}

		table.Foreach(arg0_50.nodePools, function(arg0_51, arg1_51)
			setActive(arg1_51.prefab, false)
		end)
	end

	arg0_50.pluralRoot = arg0_50.pluralRoot or pg.PoolMgr.GetInstance().root
	arg0_50.nodeList = arg0_50.nodeList or {}

	_.each(arg0_50.nodeList, function(arg0_52)
		local var0_52 = arg0_50.nodePools[var7_0[arg0_52.Data:GetType()]]
		local var1_52 = tf(arg0_52.GO)

		SetCompomentEnabled(var1_52:Find("Item"), typeof(Image), false)
		arg0_50.loader:ClearRequest(var1_52:Find("Ring"))
		table.Foreach(arg0_52.links, function(arg0_53)
			local var0_53 = var1_52:Find("Links/" .. arg0_53)

			arg0_50.loader:ClearRequest(var0_53)
		end)
		arg0_50.loader:ClearRequest(var1_52)

		if not var0_52:Enqueue(go(arg0_52.GO)) then
			setParent(go(arg0_52.GO), arg0_50.pluralRoot)
			setActive(go(arg0_52.GO), false)
		end
	end)
	table.clean(arg0_50.nodeList)
	arg0_50:InitFormula(arg1_50)
end

function var0_0.HideFormulaDetail(arg0_54)
	if not isActive(arg0_54.layerFormulaDetail) then
		return
	end

	arg0_54:HideCandicatePanel()
	setParent(arg0_54.painting, arg0_54._tf)
	arg0_54.painting:SetSiblingIndex(1)
	setParent(arg0_54.layerFormulaOverlay, arg0_54.layerFormulaDetail)
	setActive(arg0_54.layerFormulaDetail, false)

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

function var0_0.InitFormula(arg0_55, arg1_55)
	arg0_55.contextData.formulaId = arg1_55:GetConfigID()

	local var0_55 = arg0_55.layerFormulaOverlay:Find("Description")

	arg0_55.loader:GetSpriteQuiet(var4_0, var9_0[arg1_55:GetType()], var0_55:Find("Type"))

	local var1_55 = {
		type = arg1_55:GetProduction()[1],
		id = arg1_55:GetProduction()[2]
	}

	arg0_55:UpdateRyzaDrop(var0_55:Find("Icon"), var1_55)
	setText(var0_55:Find("Name"), arg1_55:GetName())
	setText(var0_55:Find("Description/Text"), arg1_55:GetDesc())

	local var2_55 = tostring(arg1_55:GetMaxLimit() - arg1_55:GetUsedCount())

	if arg1_55:GetMaxLimit() < 0 then
		var2_55 = "∞"
	end

	setText(var0_55:Find("RestCount/Text"), i18n("ryza_rest_produce_count", var2_55))
	setActive(arg0_55.layerMaterialSelect, false)

	local var3_55 = arg0_55.layerFormulaDetail:Find("ScrollView/Content")

	setAnchoredPosition(var3_55, Vector2.zero)
	_.each(arg1_55:GetCircleList(), function(arg0_56)
		local var0_56 = var2_0.New({
			configId = arg0_56
		})
		local var1_56 = arg0_55.nodePools[var7_0[var0_56:GetType()]]:Dequeue()

		var1_56.name = arg0_56

		setActive(var1_56, true)
		setParent(tf(var1_56), var3_55)

		local var2_56 = {
			Change = true,
			Data = var0_56,
			GO = var1_56
		}

		table.insert(arg0_55.nodeList, var2_56)
	end)

	local var4_55 = 280
	local var5_55 = math.deg2Rad * 30
	local var6_55 = var4_55 * Vector2.New(math.cos(var5_55), math.sin(var5_55))
	local var7_55 = var4_55 * Vector2(0, 1)
	local var8_55 = Vector2.zero

	local function var9_55(arg0_57, arg1_57)
		setAnchoredPosition(arg0_57.GO, arg1_57)

		local var0_57 = arg0_57.Data:GetNeighbors()

		arg0_57.links = {}

		_.each(var0_57, function(arg0_58)
			local var0_58 = arg0_58[1]
			local var1_58 = arg0_58[2]
			local var2_58 = var8_0[var0_58]
			local var3_58 = var2_58[1] * var6_55 + var2_58[2] * var7_55
			local var4_58 = _.detect(arg0_55.nodeList, function(arg0_59)
				return arg0_59.Data:GetConfigID() == var1_58
			end)

			var4_58.prevLink = {
				(var0_58 + 2) % 5 + 1,
				arg0_57
			}
			arg0_57.links[var0_58] = var4_58

			local var5_58 = arg1_57 + var3_58

			var9_55(var4_58, var5_58)

			var8_55 = Vector2.Max(var8_55, -var5_58)
			var8_55 = Vector2.Max(var8_55, var5_58)
		end)
	end

	var9_55(arg0_55.nodeList[1], Vector2.zero)
	setSizeDelta(var3_55, (var8_55 + Vector2.New(var4_55, var4_55)) * 2)
	onButton(arg0_55, arg0_55.layerFormulaDetail:Find("Composite"), function()
		if not _.all(arg0_55.nodeList, function(arg0_61)
			return arg0_61.Instance
		end) then
			arg0_55:ShowMaterialsPreview()

			return
		end

		if not arg0_55.activity:GetFormulas()[arg0_55.contextData.formulaId]:IsAvaliable() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

			return
		end

		arg0_55:ShowCompositeConfirmWindow()
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55.layerFormulaDetail:Find("AutoFill"), function()
		local var0_62 = {}
		local var1_62 = arg0_55.activity:GetItems()

		local function var2_62(arg0_63)
			local var0_63 = var0_62[arg0_63:GetConfigID()] or Clone(var1_62[arg0_63:GetConfigID()])

			assert(var0_63, "Using Unexist material")

			var0_63.count = var0_63.count - 1
			var0_62[arg0_63:GetConfigID()] = var0_63
		end

		local var3_62 = {}

		_.each(arg0_55.nodeList, function(arg0_64)
			if arg0_64.Instance then
				var2_62(arg0_64.Instance)
			else
				table.insert(var3_62, arg0_64)
			end
		end)

		if #var3_62 <= 0 then
			return
		end

		local var4_62 = true

		local function var5_62()
			if not var4_62 then
				return
			end

			arg0_55:DispalyChat({
				"ryza_atellier5",
				"ryza_atellier6",
				"ryza_atellier7"
			})

			var4_62 = false
		end

		local var6_62 = false
		local var7_62

		local function var8_62()
			if var7_62 and coroutine.status(var7_62) == "suspended" then
				local var0_66, var1_66 = coroutine.resume(var7_62)

				assert(var0_66, debug.traceback(var7_62, var1_66))
			end
		end

		var7_62 = coroutine.create(function()
			_.each(var3_62, function(arg0_68)
				local var0_68 = arg0_68.Data

				if var0_68:GetType() == var2_0.TYPE.BASE or var0_68:GetType() == var2_0.TYPE.SAIREN then
					local var1_68 = var0_68:GetLimitItemID()
					local var2_68 = var0_62[var1_68] or var1_62[var1_68]

					if var2_68 and var2_68.count > 0 then
						var2_62(var2_68)
						var5_62()
						arg0_55:FillNodeAndPlayAnim(arg0_68, AtelierMaterial.New({
							count = 1,
							configId = var1_68
						}), var8_62, true)
						coroutine.yield()
					else
						var6_62 = true
					end
				end
			end)

			if not var6_62 then
				local var0_67 = false
				local var1_67 = false

				arg0_55:DisPlayUnlockEffect(function()
					var0_67 = true

					if var1_67 then
						var8_62()
					end
				end)

				if not var0_67 then
					var1_67 = true

					coroutine.yield()
				end

				local var2_67 = true

				local function var3_67()
					if not var2_67 then
						return
					end

					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_5")

					var2_67 = false
				end

				local var4_67 = AtelierMaterial.bindConfigTable()

				local function var5_67(arg0_71)
					local var0_71 = arg0_71.Data

					for iter0_71, iter1_71 in ipairs(var4_67.all) do
						local var1_71 = var0_62[iter1_71] or var1_62[iter1_71]

						if var1_71 and var1_71.count > 0 and var1_71:IsNormal() and var0_71:CanUseMaterial(var1_71, arg1_55) then
							var2_62(var1_71)
							var5_62()
							var3_67()
							arg0_55:FillNodeAndPlayAnim(arg0_71, AtelierMaterial.New({
								count = 1,
								configId = var1_71:GetConfigID()
							}), true)

							return
						end
					end

					var6_62 = true
				end

				_.each(var3_62, function(arg0_72)
					if arg0_72.Data:GetType() == var2_0.TYPE.NORMAL then
						var5_67(arg0_72)
					end
				end)
				_.each(var3_62, function(arg0_73)
					if arg0_73.Data:GetType() == var2_0.TYPE.ANY then
						var5_67(arg0_73)
					end
				end)
			end

			if var6_62 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_material_not_enough"))
			end

			arg0_55:UpdateFormulaDetail()
		end)

		var8_62()
	end, SFX_PANEL)
	arg0_55:UpdateFormulaDetail()
end

function var0_0.CleanNodeInstance(arg0_74)
	local var0_74 = arg0_74.activity:GetFormulas()[arg0_74.contextData.formulaId]

	if not var0_74:IsAvaliable() then
		arg0_74:HideFormulaDetail()

		arg0_74.contextData.formulaId = nil

		arg0_74:ShowFormulaList()

		return
	end

	_.each(arg0_74.nodeList, function(arg0_75)
		arg0_75.Instance = nil
		arg0_75.Change = true
	end)
	arg0_74:ShowFormulaDetail(var0_74)
end

function var0_0.UpdateFormulaDetail(arg0_76)
	local var0_76 = 0
	local var1_76 = 0
	local var2_76 = tobool(arg0_76.unlockAllBase)

	arg0_76.unlockAllBase = true

	_.each(arg0_76.nodeList, function(arg0_77)
		var0_76 = var0_76 + 1
		var1_76 = var1_76 + (arg0_77.Instance and 1 or 0)
		arg0_76.unlockAllBase = arg0_76.unlockAllBase and (arg0_77.Data:GetType() ~= var2_0.TYPE.BASE and arg0_77.Data:GetType() ~= var2_0.TYPE.SAIREN or arg0_77.Instance)
	end)
	_.each(arg0_76.nodeList, function(arg0_78)
		local var0_78 = not arg0_76.unlockAllBase and arg0_78.Data:GetType() ~= var2_0.TYPE.BASE and arg0_78.Data:GetType() ~= var2_0.TYPE.SAIREN

		arg0_78.ChangeLock = arg0_78.ChangeLock or tobool(arg0_78.Lock) and not var0_78
		arg0_78.Lock = var0_78
	end)

	local var3_76 = arg0_76.unlockAllBase ~= var2_76

	_.each(arg0_76.nodeList, function(arg0_79)
		if var3_76 then
			arg0_79.Change = true
		end

		arg0_76:UpdateNodeView(arg0_79)
	end)
	setText(arg0_76.layerFormulaDetail:Find("Bar/Text"), i18n("ryza_tip_put_materials", var1_76, var0_76))
	setGray(arg0_76.layerFormulaDetail:Find("AutoFill"), not arg0_76.activity:GetFormulas()[arg0_76.contextData.formulaId]:IsAvaliable())
	setActive(arg0_76.layerFormulaDetail:Find("Composite/Disabled"), var1_76 < var0_76)
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

function var0_0.UpdateNodeView(arg0_80, arg1_80)
	local var0_80 = tf(arg1_80.GO)

	for iter0_80 = 1, 6 do
		setActive(var0_80:Find("Links"):GetChild(iter0_80 - 1), false)
	end

	local var1_80 = arg1_80.Data

	_.each(var1_80:GetNeighbors(), function(arg0_81)
		setActive(var0_80:Find("Links"):GetChild(arg0_81[1] - 1), true)
	end)

	local var2_80 = var1_80:GetElementName()
	local var3_80 = arg1_80.Lock

	setActive(var0_80:Find("Lock"), var3_80)

	if var3_80 then
		if var1_80:GetType() ~= var2_0.TYPE.ANY then
			arg0_80.loader:GetSpriteQuiet(var5_0, "element_" .. var2_80, var0_80:Find("Lock/Require/Icon"))
		end

		setText(var0_80:Find("Lock/Require/Text"), "X" .. var1_80:GetLevel())
	end

	for iter1_80 = 3, var1_80:GetLevel() + 1, -1 do
		local var4_80 = var0_80:Find("Slots"):GetChild(iter1_80 - 1)

		arg0_80.loader:GetSpriteQuiet(var4_0, "slot_BLOCKED", var4_80:Find("Image"))
	end

	local var5_80 = arg1_80.Instance

	if not var5_80 then
		if var1_80:GetType() == var2_0.TYPE.ANY then
			setActive(var0_80:Find("All"), true)
		else
			setActive(var0_80:Find("Icon"), true)
			arg0_80.loader:GetSpriteQuiet(var4_0, "icon_" .. var2_80, var0_80:Find("Icon"), true)
		end

		setActive(var0_80:Find("Item"), false)

		if var1_80:GetType() == var2_0.TYPE.BASE or var1_80:GetType() == var2_0.TYPE.SAIREN then
			local var6_80 = AtelierMaterial.New({
				configId = var1_80:GetLimitItemID()
			})

			setActive(var0_80:Find("Name"), true)
			setScrollText(var0_80:Find("Name/Rect/Text"), var6_80:GetName())
		else
			setActive(var0_80:Find("Name"), false)
		end

		for iter2_80 = 1, var1_80:GetLevel() do
			local var7_80 = var0_80:Find("Slots"):GetChild(iter2_80 - 1)

			arg0_80.loader:GetSpriteQuiet(var4_0, "slot_NULL", var7_80:Find("Image"))
		end
	else
		local var8_80 = var1_80:GetRingElement(var5_80)
		local var9_80 = var2_0.ELEMENT_NAME[var8_80]

		if var1_80:GetType() == var2_0.TYPE.ANY then
			setActive(var0_80:Find("All"), false)
		else
			setActive(var0_80:Find("Icon"), false)
		end

		setActive(var0_80:Find("Item"), true)

		local var10_80

		if var1_80:GetType() == var2_0.TYPE.BASE or var1_80:GetType() == var2_0.TYPE.SAIREN then
			var10_80 = var5_80:GetBaseCircleTransform()
		else
			var10_80 = var5_80:GetNormalCircleTransform()
		end

		setLocalScale(var0_80:Find("Item"), Vector3.New(unpack(var10_80, 1, 3)))
		setAnchoredPosition(var0_80:Find("Item"), Vector2.New(unpack(var10_80, 4, 5)))
		arg0_80.loader:GetSpriteQuiet(var5_80:GetIconPath(), "", var0_80:Find("Item"), true)
		setActive(var0_80:Find("Name"), true)
		setScrollText(var0_80:Find("Name/Rect/Text"), var5_80:GetName())

		for iter3_80 = 1, var1_80:GetLevel() do
			local var11_80 = var0_80:Find("Slots"):GetChild(iter3_80 - 1)

			arg0_80.loader:GetSpriteQuiet(var4_0, "slot_" .. var9_80, var11_80:Find("Image"))
		end
	end

	local var12_80 = var0_80:Find("Ring")

	setImageColor(var12_80, var1_80:GetElementRingColor(var5_80))

	if arg1_80.Change then
		local var13_80 = arg1_80.Data:GetRingElement(var5_80)

		if var3_80 then
			var13_80 = nil
		end

		if var10_0[var13_80] then
			local var14_80 = arg1_80.Data:GetType() == var2_0.TYPE.BASE and "_o" or "_6"

			arg0_80.loader:GetPrefab("ui/" .. var10_0[var13_80] .. var14_80, "", function(arg0_82)
				setParent(arg0_82, var12_80)
				setAnchoredPosition(arg0_82, Vector2.zero)
			end, var12_80)
		else
			arg0_80.loader:ClearRequest(var12_80)
		end

		table.Foreach(arg1_80.links, function(arg0_83, arg1_83)
			local var0_83 = var0_80:Find("Links/" .. arg0_83)
			local var1_83 = var13_0[3]

			if arg1_83.Lock and var3_80 then
				var1_83 = var13_0[1]
			elseif not arg1_83.Lock and not var3_80 then
				var1_83 = var13_0[2]
			end

			arg0_80.loader:GetPrefab("ui/" .. var1_83, "", function(arg0_84)
				setParent(arg0_84, var0_83:Find("Link"))
				setAnchoredPosition(arg0_84, Vector2.New(0, -15))
			end, var0_83)
		end)

		arg1_80.Change = nil
	end

	if arg1_80.ChangeInstance then
		local var15_80 = var0_80:Find("Item")

		if var5_80 then
			arg0_80.loader:GetPrefab("ui/" .. var11_0, "", function(arg0_85)
				setParent(arg0_85, var15_80)
				setAnchoredPosition(arg0_85, Vector2.zero)
			end, var0_80)
		else
			arg0_80.loader:ClearRequest(var0_80)
		end

		arg1_80.ChangeInstance = nil
	end

	onButton(arg0_80, var0_80, function()
		if var3_80 then
			return
		end

		local var0_86 = arg0_80.layerMaterialSelect:Find("TargetBG")

		var0_86.localRotation = Quaternion.identity

		local var1_86 = var1_80:GetType() == var2_0.TYPE.BASE and 300 or 245

		setSizeDelta(var0_86, {
			x = var1_86,
			y = var1_86
		})

		local var2_86 = arg0_80.layerMaterialSelect:Find("Target")

		arg0_80:ShowCandicatePanel()

		local var3_86 = tf(Instantiate(var0_80))

		SetCompomentEnabled(var3_86, typeof(Button), false)
		setParent(var3_86, var2_86)
		setAnchoredPosition(var3_86, Vector2.zero)

		for iter0_86 = 1, 6 do
			setActive(var3_86:Find("Links"):GetChild(iter0_86 - 1), false)
		end

		local var4_86 = var2_86.anchoredPosition
		local var5_86 = arg0_80.layerFormulaDetail:Find("ScrollView/Content")
		local var6_86 = var0_80.anchoredPosition + arg0_80.layerFormulaDetail:Find("ScrollView").anchoredPosition

		setAnchoredPosition(var5_86, var4_86 - var6_86)

		arg0_80.candicateTarget = arg1_80

		GetComponent(var0_86, typeof(Animator)):SetBool("Selecting", true)
		arg0_80:UpdateCandicatePanel()
	end, SFX_PANEL)
end

function var0_0.FillNodeAndPlayAnim(arg0_87, arg1_87, arg2_87, arg3_87, arg4_87)
	arg0_87:LoadingOn()

	arg1_87.ChangeInstance = arg1_87.ChangeInstance or tobool(arg1_87.Instance) ~= tobool(arg2_87)
	arg1_87.Instance = arg2_87
	arg1_87.Change = true

	local var0_87 = {}
	local var1_87 = {}

	seriesAsync({
		function(arg0_88)
			table.ParallelIpairsAsync({
				"ui/laisha_ui_wupinzhiru",
				"ui/laisha_ui_baoshi"
			}, function(arg0_89, arg1_89, arg2_89)
				var0_87[arg0_89] = arg0_87.loader:GetPrefab(arg1_89, "", function(arg0_90)
					setParent(arg0_90, tf(arg1_87.GO))
					setAnchoredPosition(arg0_90, Vector2.zero)

					var1_87[arg0_89] = arg0_90

					setActive(arg0_90, false)
					arg2_89()
				end)
			end, arg0_88)
		end,
		function(arg0_91)
			setActive(var1_87[1], true)
			arg0_87:managedTween(LeanTween.delayedCall, function()
				if not arg4_87 then
					arg0_87:UpdateFormulaDetail()
				else
					arg0_87:UpdateNodeView(arg1_87)
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_4")
				arg0_91()
			end, 0.2, nil)
		end,
		function(arg0_93)
			setActive(var1_87[2], true)
			arg0_87:managedTween(LeanTween.delayedCall, function()
				arg0_93()
			end, 0.5, nil)
		end,
		function(arg0_95)
			arg0_87.loader:ClearRequest(var0_87[1])
			arg0_87.loader:ClearRequest(var0_87[2])
			arg0_87:LoadingOff()
			existCall(arg3_87)
		end
	})
end

function var0_0.DisPlayUnlockEffect(arg0_96, arg1_96)
	arg0_96.unlockAllBase = true

	_.each(arg0_96.nodeList, function(arg0_97)
		arg0_96.unlockAllBase = arg0_96.unlockAllBase and (arg0_97.Data:GetType() ~= var2_0.TYPE.BASE and arg0_97.Data:GetType() ~= var2_0.TYPE.SAIREN or arg0_97.Instance)
	end)
	_.each(arg0_96.nodeList, function(arg0_98)
		local var0_98 = not arg0_96.unlockAllBase and arg0_98.Data:GetType() ~= var2_0.TYPE.BASE and arg0_98.Data:GetType() ~= var2_0.TYPE.SAIREN

		arg0_98.ChangeLock = arg0_98.ChangeLock or tobool(arg0_98.Lock) and not var0_98
		arg0_98.Lock = var0_98
	end)

	if not _.any(arg0_96.nodeList, function(arg0_99)
		return arg0_99.ChangeLock
	end) then
		existCall(arg1_96)

		return
	end

	arg0_96:LoadingOn()

	local var0_96 = {}

	_.each(arg0_96.nodeList, function(arg0_100)
		local var0_100 = tf(arg0_100.GO)

		if arg0_100.ChangeLock then
			if arg0_100.prevLink then
				arg0_100.prevLink[2].Change = true
			end

			local var1_100 = arg0_96.loader:GetPrefab("ui/" .. var12_0, "", function(arg0_101)
				setParent(arg0_101, var0_100)
				setAnchoredPosition(arg0_101, Vector2.zero)
			end)

			table.insert(var0_96, var1_100)

			arg0_100.ChangeLock = nil
		end
	end)
	arg0_96:managedTween(LeanTween.delayedCall, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_3")
	end, 0.7, nil)
	arg0_96:managedTween(LeanTween.delayedCall, function()
		_.each(var0_96, function(arg0_104)
			arg0_96.loader:ClearRequest(arg0_104)
		end)
		arg0_96:LoadingOff()
		existCall(arg1_96)
	end, 1.7, nil)
end

function var0_0.ShowCandicatePanel(arg0_105)
	arg0_105:DispalyChat({
		"ryza_atellier2",
		"ryza_atellier3",
		"ryza_atellier4"
	})
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_1")
	pg.UIMgr.GetInstance():BlurPanel(arg0_105.top)
	setActive(arg0_105.layerMaterialSelect, true)
	SetCompomentEnabled(arg0_105.layerFormulaDetail:Find("ScrollView"), typeof(ScrollRect), false)
	removeAllChildren(arg0_105.layerMaterialSelect:Find("Target"))
end

function var0_0.CloseCandicatePanel(arg0_106)
	arg0_106:LoadingOn()

	local var0_106 = GetComponent(arg0_106.layerMaterialSelect:Find("TargetBG"), typeof(DftAniEvent))

	var0_106:SetEndEvent(function()
		arg0_106:LoadingOff()
		arg0_106:HideCandicatePanel()
		var0_106:SetEndEvent(nil)
	end)
	GetComponent(arg0_106.layerMaterialSelect:Find("TargetBG"), typeof(Animator)):SetBool("Selecting", false)
end

function var0_0.HideCandicatePanel(arg0_108)
	if not isActive(arg0_108.layerMaterialSelect) then
		return
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0_108.top)
	arg0_108.painting:SetSiblingIndex(1)
	setActive(arg0_108.layerMaterialSelect, false)
	removeAllChildren(arg0_108.layerMaterialSelect:Find("Target"))
	SetCompomentEnabled(arg0_108.layerFormulaDetail:Find("ScrollView"), typeof(ScrollRect), true)

	arg0_108.candicateTarget = nil

	return true
end

function var0_0.UpdateCandicatePanel(arg0_109)
	arg0_109.candicates = {}

	local var0_109 = arg0_109.activity:GetItems()
	local var1_109 = arg0_109.activity:GetFormulas()[arg0_109.contextData.formulaId]
	local var2_109 = AtelierMaterial.bindConfigTable()
	local var3_109 = _.map(var2_109.all, function(arg0_110)
		local var0_110 = var0_109[arg0_110] or AtelierMaterial.New({
			configId = arg0_110
		})

		if arg0_109.candicateTarget.Data:CanUseMaterial(var0_110, var1_109) then
			if var0_109[arg0_110] then
				var0_110 = AtelierMaterial.New({
					configId = arg0_110,
					count = var0_109[arg0_110].count
				})
				var0_110.count = _.reduce(arg0_109.nodeList, var0_110.count, function(arg0_111, arg1_111)
					if arg1_111.Instance and arg1_111.Instance:GetConfigID() == arg0_110 then
						arg0_111 = arg0_111 - 1
					end

					return arg0_111
				end)
			end

			return var0_110
		end
	end)

	table.sort(var3_109, function(arg0_112, arg1_112)
		if arg0_112.count * arg1_112.count == 0 and arg0_112.count - arg1_112.count ~= 0 then
			return arg0_112.count < arg1_112.count
		else
			return arg0_112:GetConfigID() < arg1_112:GetConfigID()
		end
	end)
	_.each(var3_109, function(arg0_113)
		for iter0_113 = 1, math.max(arg0_113.count, 1) do
			table.insert(arg0_109.candicates, arg0_113)
		end
	end)
	arg0_109.candicatesRect:SetTotalCount(#arg0_109.candicates, 0)
end

function var0_0.UpdateCandicateItem(arg0_114, arg1_114, arg2_114)
	local var0_114 = tf(arg2_114)
	local var1_114 = arg0_114.candicates[arg1_114]

	arg0_114:UpdateRyzaItem(var0_114:Find("IconBG"), var1_114, true)

	local var2_114 = var1_114.count <= 0

	setActive(var0_114:Find("IconBG/Lack"), var2_114)
	onButton(arg0_114, var0_114, function()
		if var2_114 then
			var1_114 = CreateShell(var1_114)
			var1_114.count = false

			arg0_114:ShowItemDetail(var1_114)
		else
			arg0_114:DispalyChat({
				"ryza_atellier5",
				"ryza_atellier6",
				"ryza_atellier7"
			})
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_2")

			local var0_115 = arg0_114.candicateTarget

			arg0_114:HideCandicatePanel()
			seriesAsync({
				function(arg0_116)
					arg0_114:FillNodeAndPlayAnim(var0_115, AtelierMaterial.New({
						count = 1,
						configId = var1_114:GetConfigID()
					}), arg0_116, true)
				end,
				function(arg0_117)
					arg0_114:DisPlayUnlockEffect(arg0_117)
				end,
				function(arg0_118)
					arg0_114:UpdateFormulaDetail()
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRyzaItem(arg0_119, arg1_119, arg2_119, arg3_119)
	local var0_119 = "icon_frame_" .. arg2_119:GetRarity()

	if arg3_119 then
		var0_119 = var0_119 .. "_small"
	end

	arg0_119.loader:GetSpriteQuiet(var5_0, var0_119, arg1_119)
	arg0_119.loader:GetSpriteQuiet(arg2_119:GetIconPath(), "", arg1_119:Find("Icon"))

	if not IsNil(arg1_119:Find("Lv")) then
		setText(arg1_119:Find("Lv/Text"), arg2_119:GetLevel())
	end

	local var1_119 = arg2_119:GetProps()
	local var2_119 = CustomIndexLayer.Clone2Full(arg1_119:Find("List"), #var1_119)

	for iter0_119, iter1_119 in ipairs(var2_119) do
		arg0_119.loader:GetSpriteQuiet(var5_0, "element_" .. var2_0.ELEMENT_NAME[var1_119[iter0_119]], iter1_119)
	end

	if not IsNil(arg1_119:Find("Text")) then
		setText(arg1_119:Find("Text"), arg2_119.count)
	end
end

function var0_0.ShowItemDetail(arg0_120, arg1_120)
	arg0_120:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, arg1_120)
end

local var14_0 = 41
local var15_0 = 5

function var0_0.ShowCompositeConfirmWindow(arg0_121)
	setActive(arg0_121.layerCompositeConfirm, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_121.layerCompositeConfirm)

	local var0_121 = 1
	local var1_121 = {}
	local var2_121 = {}

	_.each(arg0_121.nodeList, function(arg0_122)
		local var0_122 = arg0_122.Instance:GetConfigID()

		table.insert(var1_121, {
			key = arg0_122.Data:GetConfigID(),
			value = var0_122
		})

		var2_121[var0_122] = (var2_121[var0_122] or 0) + 1
	end)
	onButton(arg0_121, arg0_121.layerCompositeConfirm:Find("Window/Confirm"), function()
		arg0_121:emit(GAME.COMPOSITE_ATELIER_RECIPE, var1_121, var0_121)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_6")
	end, SFX_PANEL)

	local var3_121 = arg0_121.activity:GetFormulas()[arg0_121.contextData.formulaId]
	local var4_121 = var3_121:GetMaxLimit() ~= 1
	local var5_121 = var3_121:GetMaxLimit() > 0 and var3_121:GetMaxLimit() - var3_121:GetUsedCount() or 10000
	local var6_121 = arg0_121.activity:GetItems()

	for iter0_121, iter1_121 in pairs(var2_121) do
		local var7_121 = var6_121[iter0_121] and var6_121[iter0_121].count or 0

		var5_121 = math.min(var5_121, math.floor(var7_121 / iter1_121))
	end

	local var8_121 = var5_121
	local var9_121 = {
		1,
		var4_121 and var8_121 or 1
	}
	local var10_121 = Drop.New({
		type = var3_121:GetProduction()[1],
		id = var3_121:GetProduction()[2]
	})

	arg0_121:UpdateRyzaDrop(arg0_121.layerCompositeConfirm:Find("Window/Icon"), var10_121)

	local var11_121 = arg0_121.layerCompositeConfirm:Find("Window/Counters")
	local var12_121 = var10_121:getConfig("name")

	setActive(var11_121, var4_121)

	if var4_121 then
		setAnchoredPosition(arg0_121.layerCompositeConfirm:Find("Window/Icon"), {
			y = var14_0
		})

		local function var13_121()
			setText(var11_121:Find("Number"), var0_121)
			setText(arg0_121.layerCompositeConfirm:Find("Window/Text"), i18n("ryza_composite_confirm", var12_121, var0_121))
		end

		var13_121()
		onButton(arg0_121, var11_121:Find("Plus"), function()
			local var0_125 = var0_121

			var0_121 = var0_121 + 1
			var0_121 = math.clamp(var0_121, var9_121[1], var9_121[2])

			if var0_125 == var0_121 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13_121()
		end)
		onButton(arg0_121, var11_121:Find("Minus"), function()
			var0_121 = var0_121 - 1
			var0_121 = math.clamp(var0_121, var9_121[1], var9_121[2])

			var13_121()
		end)
		onButton(arg0_121, var11_121:Find("Plus10"), function()
			local var0_127 = var0_121

			var0_121 = var0_121 + 10
			var0_121 = math.clamp(var0_121, var9_121[1], var9_121[2])

			if var0_127 == var0_121 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13_121()
		end)
		onButton(arg0_121, var11_121:Find("Minus10"), function()
			var0_121 = var0_121 - 10
			var0_121 = math.clamp(var0_121, var9_121[1], var9_121[2])

			var13_121()
		end)
	else
		setAnchoredPosition(arg0_121.layerCompositeConfirm:Find("Window/Icon"), {
			y = var15_0
		})
		setText(arg0_121.layerCompositeConfirm:Find("Window/Text"), i18n("ryza_composite_confirm_single", var12_121, var0_121))
	end
end

function var0_0.HideCompositeConfirmWindow(arg0_129)
	if not isActive(arg0_129.layerCompositeConfirm) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_129.layerCompositeConfirm, arg0_129._tf)
	setActive(arg0_129.layerCompositeConfirm, false)

	return true
end

local var16_0 = "laisha_lianjin"

function var0_0.OnCompositeResult(arg0_130, arg1_130)
	arg0_130:LoadingOn()
	arg0_130:DispalyChat({
		"ryza_atellier8",
		"ryza_atellier9"
	})

	local var0_130 = 1.5
	local var1_130 = 0.5

	arg0_130.loader:GetPrefab("ui/" .. var16_0, "", function(arg0_131)
		pg.UIMgr.GetInstance():OverlayPanel(tf(arg0_131), {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setAnchoredPosition(arg0_131, Vector2.zero)
		arg0_130:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_130._tf, typeof(CanvasGroup)), 0, var0_130):setFrom(1)
		arg0_130:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_130.top, typeof(CanvasGroup)), 0, var0_130):setFrom(1)
		arg0_130:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_130.layerCompositeConfirm, typeof(CanvasGroup)), 0, var0_130):setFrom(1)
		arg0_130:managedTween(LeanTween.delayedCall, function()
			arg0_130:HideCompositeConfirmWindow()
			setCanvasGroupAlpha(arg0_130.layerCompositeConfirm, 1)
			arg0_130:CleanNodeInstance()
			arg0_130:ShowCompositeResult(arg1_130)
			arg0_130:DispalyChat({
				"ryza_atellier10",
				"ryza_atellier11"
			})
			arg0_130:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_130._tf, typeof(CanvasGroup)), 1, var1_130):setFrom(0)
			arg0_130:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0_130.top, typeof(CanvasGroup)), 1, var1_130):setFrom(0)
			arg0_130:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0_130.layerCompositeResult, typeof(CanvasGroup)), 1, var1_130):setFrom(0)
			arg0_130:managedTween(LeanTween.delayedCall, function()
				arg0_130:LoadingOff()
				pg.UIMgr.GetInstance():UnOverlayPanel(tf(arg0_131), arg0_130._tf)
				arg0_130.loader:ClearRequest("CompositeResult")
			end, go(arg0_130.layerCompositeResult), var1_130, nil)
		end, go(arg0_130.layerCompositeResult), var0_130, nil)
	end, "CompositeResult")
end

function var0_0.ShowCompositeResult(arg0_134, arg1_134)
	setActive(arg0_134.layerCompositeResult, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_134.layerCompositeResult)

	local var0_134 = arg1_134[1]

	arg0_134:UpdateRyzaDrop(arg0_134.layerCompositeResult:Find("Window/Icon"), var0_134)
	setScrollText(arg0_134.layerCompositeResult:Find("Window/NameBG/Rect/Name"), var0_134:getName())
	setText(arg0_134.layerCompositeResult:Find("Window/CountBG/Text"), var0_134.count)
end

function var0_0.HideCompositeResult(arg0_135)
	if not isActive(arg0_135.layerCompositeResult) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_135.layerCompositeResult, arg0_135._tf)
	setActive(arg0_135.layerCompositeResult, false)

	if pg.NewStoryMgr.GetInstance():IsPlayed("NG0032") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0033", {
			2
		})
	end

	return true
end

function var0_0.ShowStoreHouseWindow(arg0_136)
	setActive(arg0_136.layerStoreHouse, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_136.layerStoreHouse)

	local var0_136 = _.filter(_.values(arg0_136.activity:GetItems()), function(arg0_137)
		return arg0_137.count > 0
	end)

	table.sort(var0_136, function(arg0_138, arg1_138)
		return arg0_138:GetConfigID() < arg1_138:GetConfigID()
	end)
	setActive(arg0_136.layerStoreHouse:Find("Window/Empty"), #var0_136 == 0)
	setActive(arg0_136.layerStoreHouse:Find("Window/ScrollView"), #var0_136 > 0)

	if #var0_136 == 0 then
		return
	end

	function arg0_136.storehouseRect.onUpdateItem(arg0_139, arg1_139)
		arg0_139 = arg0_139 + 1

		local var0_139 = tf(arg1_139)
		local var1_139 = var0_136[arg0_139]

		arg0_136:UpdateRyzaItem(var0_139:Find("IconBG"), var1_139)
		setScrollText(var0_139:Find("NameBG/Rect/Name"), var1_139:GetName())
		onButton(arg0_136, var0_139, function()
			arg0_136:ShowItemDetail(var1_139)
		end, SFX_PANEL)
	end

	arg0_136.storehouseRect:SetTotalCount(#var0_136)
end

function var0_0.CloseStoreHouseWindow(arg0_141)
	arg0_141.contextData.showStoreHouse = nil

	return arg0_141:HideStoreHouseWindow()
end

function var0_0.HideStoreHouseWindow(arg0_142)
	if not isActive(arg0_142.layerStoreHouse) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_142.layerStoreHouse, arg0_142._tf)
	setActive(arg0_142.layerStoreHouse, false)

	return true
end

function var0_0.ShowMaterialsPreview(arg0_143)
	setActive(arg0_143.layerMaterialsPreview, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_143.layerMaterialsPreview)

	local var0_143 = arg0_143.activity:GetItems()
	local var1_143 = arg0_143.activity:GetFormulas()[arg0_143.contextData.formulaId]
	local var2_143 = AtelierMaterial.bindConfigTable()
	local var3_143 = {}
	local var4_143 = {}
	local var5_143 = {}

	local function var6_143(arg0_144)
		local var0_144 = var5_143[arg0_144:GetConfigID()] or Clone(var0_143[arg0_144:GetConfigID()])

		assert(var0_144, "Using Unexist material")

		var0_144.count = var0_144.count - 1
		var5_143[arg0_144:GetConfigID()] = var0_144
	end

	_.each(arg0_143.nodeList, function(arg0_145)
		local var0_145 = arg0_145.Data

		if var0_145:GetType() == var2_0.TYPE.BASE or var0_145:GetType() == var2_0.TYPE.SAIREN then
			local var1_145 = var0_145:GetLimitItemID()
			local var2_145 = var5_143[var1_145] or var0_143[var1_145]

			if var2_145 and var2_145.count > 0 then
				local var3_145 = AtelierMaterial.New({
					configId = var1_145
				})

				var3_145.count = false

				table.insert(var3_143, var3_145)
				var6_143(var2_145)
			else
				local var4_145 = AtelierMaterial.New({
					configId = var1_145
				})

				var4_145.count = false

				table.insert(var4_143, var4_145)
			end
		end
	end)

	local function var7_143(arg0_146)
		if arg0_146.Instance then
			local var0_146 = AtelierMaterial.New({
				configId = arg0_146.Instance:GetConfigID()
			})

			var0_146.count = false

			table.insert(var3_143, var0_146)
			var6_143(arg0_146.Instance)

			return
		end

		local var1_146 = arg0_146.Data
		local var2_146

		for iter0_146, iter1_146 in ipairs(var2_143.all) do
			local var3_146 = var5_143[iter1_146] or var0_143[iter1_146] or AtelierMaterial.New({
				configId = iter1_146
			})

			if var3_146:IsNormal() and var1_146:CanUseMaterial(var3_146, var1_143) then
				var2_146 = var2_146 or iter1_146

				if var3_146.count > 0 then
					local var4_146 = AtelierMaterial.New({
						configId = iter1_146
					})

					var4_146.count = false

					table.insert(var3_143, var4_146)
					var6_143(var3_146)

					return
				end
			end
		end

		local var5_146 = AtelierMaterial.New({
			configId = var2_146
		})

		var5_146.count = false

		table.insert(var4_143, var5_146)
	end

	_.each(arg0_143.nodeList, function(arg0_147)
		if arg0_147.Data:GetType() == var2_0.TYPE.NORMAL then
			var7_143(arg0_147)
		end
	end)
	_.each(arg0_143.nodeList, function(arg0_148)
		if arg0_148.Data:GetType() == var2_0.TYPE.ANY then
			var7_143(arg0_148)
		end
	end)

	local function var8_143(arg0_149, arg1_149)
		return arg0_149:GetConfigID() < arg1_149:GetConfigID()
	end

	table.sort(var3_143, var8_143)
	table.sort(var4_143, var8_143)

	local function var9_143()
		local var0_150 = arg0_143.layerMaterialsPreview:Find("Frame/Scroll/Content/Owned/List")

		setActive(var0_150.parent, #var3_143 > 0)

		if #var3_143 == 0 then
			return
		end

		local var1_150 = CustomIndexLayer.Clone2Full(var0_150, #var3_143)

		table.Foreach(var1_150, function(arg0_151, arg1_151)
			local var0_151 = var3_143[arg0_151]

			arg0_143:UpdateRyzaItem(arg1_151:Find("IconBG"), var0_151, true)
			onButton(arg0_143, arg1_151, function()
				arg0_143:ShowItemDetail(var0_151)
			end, SFX_PANEL)
		end)
	end

	local function var10_143()
		local var0_153 = arg0_143.layerMaterialsPreview:Find("Frame/Scroll/Content/Lack/List")

		setActive(var0_153.parent, #var4_143 > 0)

		if #var4_143 == 0 then
			return
		end

		local var1_153 = CustomIndexLayer.Clone2Full(var0_153, #var4_143)

		table.Foreach(var1_153, function(arg0_154, arg1_154)
			local var0_154 = var4_143[arg0_154]

			arg0_143:UpdateRyzaItem(arg1_154:Find("IconBG"), var0_154, true)
			onButton(arg0_143, arg1_154, function()
				arg0_143:ShowItemDetail(var0_154)
			end, SFX_PANEL)
		end)
	end

	var9_143()
	var10_143()
end

function var0_0.HideMaterialsPreview(arg0_156)
	if not isActive(arg0_156.layerMaterialsPreview) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_156.layerMaterialsPreview, arg0_156._tf)
	setActive(arg0_156.layerMaterialsPreview, false)

	return true
end

function var0_0.OnReceiveFormualRequest(arg0_157, arg1_157)
	arg0_157:HideCandicatePanel()
	arg0_157:HideCompositeConfirmWindow()
	arg0_157:HideCompositeResult()
	arg0_157:HideMaterialsPreview()
	arg0_157:CloseStoreHouseWindow()
	arg0_157:HideFormulaList()

	local var0_157 = arg0_157.activity:GetFormulas()[arg1_157]

	arg0_157:ShowFormulaDetail(var0_157)
end

function var0_0.DispalyChat(arg0_158, arg1_158)
	arg0_158:HideChat()
	setActive(arg0_158.chat, true)

	arg0_158.chatTween = LeanTween.delayedCall(go(arg0_158.chat), 4, System.Action(function()
		arg0_158:HideChat()
	end)).uniqueId

	local var0_158 = arg1_158[math.random(#arg1_158)]
	local var1_158 = pg.gametip.ryza_composite_words.tip
	local var2_158 = _.detect(var1_158, function(arg0_160)
		return arg0_160[1] == var0_158
	end)
	local var3_158 = var2_158 and var2_158[2]

	setText(arg0_158.chat:Find("Text"), var3_158)

	local var4_158 = 1090001
	local var5_158 = "event:/cv/" .. var4_158 .. "/" .. var0_158

	arg0_158:PlaySound(var5_158)
end

function var0_0.HideChat(arg0_161)
	if arg0_161.chatTween then
		LeanTween.cancel(arg0_161.chatTween)

		arg0_161.chatTween = nil
	end

	setActive(arg0_161.chat, false)
end

function var0_0.PlaySound(arg0_162, arg1_162, arg2_162)
	if not arg0_162.playbackInfo or arg1_162 ~= arg0_162.prevCvPath or arg0_162.playbackInfo.channelPlayer == nil then
		arg0_162:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_162, function(arg0_163)
			if arg0_163 then
				arg0_162.playbackInfo = arg0_163

				arg0_162.playbackInfo:SetIgnoreAutoUnload(true)

				if arg2_162 then
					arg2_162(arg0_162.playbackInfo.cueInfo)
				end
			elseif arg2_162 then
				arg2_162()
			end
		end)

		arg0_162.prevCvPath = arg1_162

		if arg0_162.playbackInfo == nil then
			return nil
		end

		return arg0_162.playbackInfo.cueInfo
	elseif arg0_162.playbackInfo then
		arg0_162.playbackInfo:PlaybackStop()
		arg0_162.playbackInfo:SetStartTimeAndPlay()

		if arg2_162 then
			arg2_162(arg0_162.playbackInfo.cueInfo)
		end

		return arg0_162.playbackInfo.cueInfo
	elseif arg2_162 then
		arg2_162()
	end

	return nil
end

function var0_0.StopSound(arg0_164)
	if arg0_164.playbackInfo then
		pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0_164.playbackInfo)
		arg0_164.playbackInfo:SetIgnoreAutoUnload(false)
	end
end

function var0_0.ClearSound(arg0_165)
	arg0_165:StopSound()

	if arg0_165.playbackInfo then
		arg0_165.playbackInfo:Dispose()

		arg0_165.playbackInfo = nil
	end
end

function var0_0.LoadingOn(arg0_166)
	if arg0_166.animating then
		return
	end

	arg0_166.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.LoadingOff(arg0_167)
	if not arg0_167.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0_167.animating = false
end

function var0_0.willExit(arg0_168)
	arg0_168.loader:Clear()
	arg0_168:LoadingOff()
	arg0_168:HideChat()
	arg0_168:ClearSound()
	arg0_168:HideStoreHouseWindow()
	arg0_168:HideMaterialsPreview()
	arg0_168:HideCompositeResult()
	arg0_168:HideCompositeConfirmWindow()
	arg0_168:HideCandicatePanel()
	arg0_168:HideFormulaDetail()
	arg0_168:HideFormulaList()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_168.top, arg0_168._tf)

	if arg0_168.nodePools then
		for iter0_168, iter1_168 in pairs(arg0_168.nodePools) do
			iter1_168:ClearItems()
		end
	end
end

return var0_0
