local var0 = class("AtelierCompositeScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AtelierCompositeUI"
end

local var1 = import("model.vo.AtelierFormula")
local var2 = import("model.vo.AtelierFormulaCircle")
local var3 = import("Mgr.Pool.PoolPlural")

var0.FilterAll = bit.bor(1, 2, 4)

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.loader = AutoLoader.New()
end

function var0.init(arg0)
	arg0.layerEmpty = arg0._tf:Find("Empty")
	arg0.layerFormula = arg0._tf:Find("FormulaList")
	arg0.painting = arg0._tf:Find("Painting")
	arg0.chat = arg0.painting:Find("Chat")
	arg0.layerFormulaDetail = arg0._tf:Find("FormulaDetail")
	arg0.layerFormulaOverlay = arg0.layerFormulaDetail:Find("Overlay")
	arg0.layerMaterialSelect = arg0.layerFormulaOverlay:Find("AvaliableMaterials")
	arg0.layerCompositeConfirm = arg0._tf:Find("CompositeConfirmWindow")
	arg0.layerCompositeResult = arg0._tf:Find("CompositeResultWindow")
	arg0.layerStoreHouse = arg0._tf:Find("StoreHouseWindow")
	arg0.layerMaterialsPreview = arg0._tf:Find("FormulaMaterialsPreview")
	arg0.top = arg0._tf:Find("Top")
	arg0.formulaRect = arg0.layerFormula:Find("Frame/ScrollView"):GetComponent("LScrollRect")

	local var0 = arg0.layerFormula:Find("Frame/Item")

	setActive(var0, false)

	function arg0.formulaRect.onUpdateItem(arg0, arg1)
		arg0:UpdateFormulaItem(arg0 + 1, arg1)
	end

	arg0.formulaFilterButtons = _.map({
		1,
		2,
		3
	}, function(arg0)
		return arg0.layerFormula:Find("Frame/Tabs"):GetChild(arg0 - 1)
	end)
	arg0.candicatesRect = arg0.layerMaterialSelect:Find("Frame/List"):GetComponent("LScrollRect")

	local var1 = arg0.layerMaterialSelect:Find("Frame/Item")

	setActive(var1, false)

	function arg0.candicatesRect.onUpdateItem(arg0, arg1)
		arg0:UpdateCandicateItem(arg0 + 1, arg1)
	end

	arg0.storehouseRect = arg0.layerStoreHouse:Find("Window/ScrollView"):GetComponent("LScrollRect")

	local var2 = arg0.layerStoreHouse:Find("Window/ScrollView/Item")

	setActive(var2, false)
	setActive(arg0.layerFormula, false)
	setActive(arg0.layerFormulaDetail, false)
	setActive(arg0.layerMaterialSelect, false)
	setActive(arg0.layerEmpty, false)
	setActive(arg0.layerStoreHouse, false)
	setActive(arg0.chat, false)
	pg.ViewUtils.SetSortingOrder(arg0._tf:Find("Mask/BG"):GetChild(0), -1)
	setText(arg0._tf:Find("Empty/Bar/Text"), i18n("ryza_tip_composite_unlock"))
	setText(arg0.layerFormula:Find("Frame/Filter/Text"), i18n("ryza_toggle_only_composite"))
	setText(arg0.layerFormula:Find("Frame/Empty"), i18n("ryza_tip_no_recipe"))
	setText(arg0.layerFormula:Find("Frame/Item/Lock/Text"), i18n("ryza_tip_unlock_all_tools"))
	setText(arg0.layerFormula:Find("Bar/Text"), i18n("ryza_tip_select_recipe"))
	setText(arg0.layerStoreHouse:Find("Window/Empty"), i18n("ryza_tip_no_item"))
	setText(arg0.layerCompositeResult:Find("Window/CountBG/Tip"), i18n("ryza_composite_count"))
	setText(arg0.layerMaterialsPreview:Find("Frame/Text"), i18n("ryza_tip_item_access"))
	setText(var1:Find("IconBG/Lack/Text"), i18n("ryza_ui_show_acess"))
end

function var0.SetEnabled(arg0, arg1)
	arg0.unlockSystem = arg1
end

function var0.SetActivity(arg0, arg1)
	arg0.activity = arg1
end

local var4 = "ui/AtelierCompositeUI_atlas"
local var5 = "ui/AtelierCommonUI_atlas"

function var0.preload(arg0, arg1)
	table.ParallelIpairsAsync({
		var4,
		var5
	}, function(arg0, arg1, arg2)
		arg0.loader:LoadBundle(arg1, arg2)
	end, arg1)
end

function var0.didEnter(arg0)
	arg0.contextData.filterType = var0.FilterAll

	table.Foreach(arg0.formulaFilterButtons, function(arg0, arg1)
		onButton(arg0, arg1, function()
			if arg0.contextData.filterType == var0.FilterAll then
				arg0.contextData.filterType = bit.lshift(1, arg0 - 1)
			else
				arg0.contextData.filterType = bit.bxor(arg0.contextData.filterType, bit.lshift(1, arg0 - 1))

				if arg0.contextData.filterType == 0 then
					arg0.contextData.filterType = var0.FilterAll
				end
			end

			arg0:UpdateFilterButtons()
			arg0:FilterFormulas()
			arg0:UpdateFormulaList()
		end, SFX_PANEL)
	end)
	onToggle(arg0, arg0.layerFormula:Find("Frame/Filter/Toggle"), function(arg0)
		arg0.showOnlyComposite = arg0

		arg0:FilterFormulas()
		arg0:UpdateFormulaList()
	end)
	onButton(arg0, arg0.layerFormulaOverlay:Find("Description/List"), function()
		arg0:HideFormulaDetail()

		arg0.contextData.formulaId = nil

		arg0:ShowFormulaList()
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
			helps = i18n("ryza_composite_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.layerMaterialSelect:Find("BG"), function()
		arg0:CloseCandicatePanel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.layerCompositeConfirm:Find("BG"), function()
		arg0:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.layerCompositeConfirm:Find("Window/Cancel"), function()
		arg0:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.layerCompositeResult:Find("BG"), function()
		arg0:HideCompositeResult()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Top/StoreHouse"), function()
		arg0.contextData.showStoreHouse = true

		arg0:ShowStoreHouseWindow()
	end, SFX_PANEL)
	onButton(arg0, arg0.layerStoreHouse:Find("Window/Close"), function()
		arg0:CloseStoreHouseWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.layerStoreHouse:Find("BG"), function()
		arg0:CloseStoreHouseWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.layerMaterialsPreview:Find("BG"), function()
		arg0:HideMaterialsPreview()
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top)

	if not arg0.unlockSystem then
		setActive(arg0.layerEmpty, true)
		setActive(arg0.painting, false)
	else
		if arg0.contextData.formulaId then
			local var0 = arg0.activity:GetFormulas()[arg0.contextData.formulaId]

			arg0:ShowFormulaDetail(var0)
		else
			arg0:DispalyChat({
				"ryza_atellier1"
			})
			arg0:ShowFormulaList()
		end

		if arg0.contextData.showStoreHouse then
			arg0:ShowStoreHouseWindow()
		end
	end

	if arg0.unlockSystem and PlayerPrefs.GetInt("first_enter_ryza_atelier_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0 then
		triggerButton(arg0._tf:Find("Top/Help"))
		PlayerPrefs.SetInt("first_enter_ryza_atelier_" .. getProxy(PlayerProxy):getRawData().id, 1)
	end
end

function var0.onBackPressed(arg0)
	if arg0.animating then
		return true
	end

	if arg0:CloseStoreHouseWindow() then
		return true
	end

	if arg0:HideMaterialsPreview() then
		return true
	end

	if arg0:HideCompositeResult() then
		return true
	end

	if arg0:HideCompositeConfirmWindow() then
		return true
	end

	if arg0:HideCandicatePanel() then
		return true
	end

	if arg0:HideFormulaDetail() then
		arg0.contextData.formulaId = nil

		arg0:ShowFormulaList()

		return true
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.UpdateFilterButtons(arg0)
	table.Foreach(arg0.formulaFilterButtons, function(arg0, arg1)
		local var0 = arg0.contextData.filterType ~= var0.FilterAll

		var0 = var0 and bit.band(arg0.contextData.filterType, bit.lshift(1, arg0 - 1)) > 0

		setActive(arg1:Find("Selected"), var0)
	end)
end

function var0.AddIdleTimer(arg0)
	arg0:RemoveIdleTimer()

	arg0.idleTimer = Timer.New(function()
		arg0:DispalyChat({
			"ryza_atellier1"
		})
		arg0:AddIdleTimer()
	end, 8 + math.random() * 4)

	arg0.idleTimer:Start()
end

function var0.RemoveIdleTimer(arg0)
	if not arg0.idleTimer then
		return
	end

	arg0.idleTimer:Stop()

	arg0.idleTimer = nil
end

function var0.ShowFormulaList(arg0)
	arg0:AddIdleTimer()
	setActive(arg0.layerFormula, true)
	setParent(arg0.layerFormula, arg0.top)
	arg0.layerFormula:SetSiblingIndex(0)
	arg0:UpdateFilterButtons()
	arg0:FilterFormulas()
	arg0:UpdateFormulaList()
end

function var0.HideFormulaList(arg0)
	if not arg0.layerFormula then
		return
	end

	arg0:RemoveIdleTimer()
	setParent(arg0.layerFormula, arg0._tf)
	setActive(arg0.layerFormula, false)

	return true
end

function var0.FilterFormulas(arg0)
	arg0.filterFormulas = {}

	local var0 = arg0.contextData.filterType
	local var1 = function(arg0)
		if var0 == var0.FilterAll then
			return true
		end

		return switch(arg0:GetType(), {
			[var1.TYPE.EQUIP] = function()
				return bit.band(var0, 1) > 0
			end,
			[var1.TYPE.ITEM] = function()
				return bit.band(var0, 2) > 0
			end,
			[var1.TYPE.TOOL] = function()
				return bit.band(var0, 4) > 0
			end,
			[var1.TYPE.OTHER] = function()
				return bit.band(var0, 4) > 0
			end
		})
	end

	for iter0, iter1 in ipairs(_.values(arg0.activity:GetFormulas())) do
		if var1(iter1) and (not arg0.showOnlyComposite or iter1:IsAvaliable() and var1.IsFormualCanComposite(iter1, arg0.activity)) then
			table.insert(arg0.filterFormulas, iter1)
		end
	end

	local function var2(arg0, arg1)
		local var0 = {
			function(arg0)
				return arg0:IsAvaliable() and 0 or 1
			end,
			function(arg0)
				if arg0:GetType() ~= var1.TYPE.TOOL and not arg0.activity:IsCompleteAllTools() then
					return 1
				else
					return 0
				end
			end,
			function(arg0)
				return arg0:GetConfigID()
			end
		}

		for iter0, iter1 in ipairs(var0) do
			local var1 = iter1(arg0)
			local var2 = iter1(arg1)

			if var1 ~= var2 then
				return var1 < var2
			end
		end

		return false
	end

	table.sort(arg0.filterFormulas, var2)
end

function var0.UpdateFormulaList(arg0)
	local var0 = #arg0.filterFormulas == 0

	setActive(arg0.layerFormula:Find("Frame/Empty"), var0)
	setActive(arg0.layerFormula:Find("Frame/ScrollView"), not var0)
	arg0.formulaRect:SetTotalCount(#arg0.filterFormulas)
end

local var6 = {
	[var1.TYPE.EQUIP] = "ryza_word_equip",
	[var1.TYPE.ITEM] = "word_item",
	[var1.TYPE.TOOL] = "word_tool",
	[var1.TYPE.OTHER] = "word_other"
}

function var0.UpdateFormulaItem(arg0, arg1, arg2)
	local var0 = tf(arg2)
	local var1 = arg0.filterFormulas[arg1]
	local var2 = var1:GetProduction()

	arg0:UpdateRyzaDrop(var0:Find("BG/Icon"), {
		type = var2[1],
		id = var2[2]
	}, true)

	local var3 = var6[var1:GetType()]
	local var4 = var1:GetType() ~= var1.TYPE.TOOL and not arg0.activity:IsCompleteAllTools()

	setActive(var0:Find("Lock"), var4)
	setActive(var0:Find("BG"), not var4)
	setText(var0:Find("BG/Type"), i18n(var3))
	setScrollText(var0:Find("BG/Name/Text"), var1:GetName())

	local var5

	if var1:GetMaxLimit() > 0 then
		var5 = var1:GetMaxLimit() - var1:GetUsedCount() .. "/" .. var1:GetMaxLimit()
	else
		var5 = "∞"
	end

	local var6 = var1:IsAvaliable()

	setActive(var0:Find("BG/Count"), var6)
	setActive(var0:Find("Completed"), not var6)

	if var6 then
		local var7 = var1.IsFormualCanComposite(var1, arg0.activity)
		local var8 = SummerFeastScene.TransformColor(var7 and "4fb3a3" or "d55a54")

		setTextColor(var0:Find("BG/Count"), var8)
	end

	setText(var0:Find("BG/Count"), var5)
	onButton(arg0, var0, function()
		if not var6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

			return
		end

		if var4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_unlock_all_tools"))

			return
		end

		arg0:HideFormulaList()
		arg0:ShowFormulaDetail(var1)
		arg0:DispalyChat({
			"ryza_atellier2",
			"ryza_atellier3",
			"ryza_atellier4"
		})
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_1")
	end, SFX_PANEL)
end

function var0.UpdateRyzaDrop(arg0, arg1, arg2, arg3)
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

	arg0.loader:GetSpriteQuiet(var5, var1, arg1)

	if arg2.type == DROP_TYPE_EQUIP or arg2.type == DROP_TYPE_SPWEAPON then
		onButton(arg0, arg1, function()
			arg0:emit(var0.ON_DROP, arg2)
		end, SFX_PANEL)
	else
		removeOnButton(arg1)
	end
end

local var7 = {
	[var2.TYPE.BASE] = "circle",
	[var2.TYPE.NORMAL] = "hexagon",
	[var2.TYPE.SAIREN] = "doubleHexagon",
	[var2.TYPE.ANY] = "anyHexagon"
}

function var0.ShowFormulaDetail(arg0, arg1)
	setActive(arg0.layerFormulaDetail, true)
	setParent(arg0.layerFormulaOverlay, arg0.top)
	arg0.layerFormulaOverlay:SetSiblingIndex(0)
	setParent(arg0.painting, arg0.layerFormulaOverlay)
	arg0.painting:SetSiblingIndex(0)

	if not arg0.nodePools then
		arg0.nodePools = {
			circle = var3.New(arg0.layerFormulaDetail:Find("CircleNode").gameObject, 100),
			hexagon = var3.New(arg0.layerFormulaDetail:Find("HexagonNode").gameObject, 100),
			anyHexagon = var3.New(arg0.layerFormulaDetail:Find("AnyHexagonNode").gameObject, 100),
			doubleHexagon = var3.New(arg0.layerFormulaDetail:Find("DoubleHexagonNode").gameObject, 100)
		}

		table.Foreach(arg0.nodePools, function(arg0, arg1)
			setActive(arg1.prefab, false)
		end)
	end

	arg0.pluralRoot = arg0.pluralRoot or pg.PoolMgr.GetInstance().root
	arg0.nodeList = arg0.nodeList or {}

	_.each(arg0.nodeList, function(arg0)
		local var0 = arg0.nodePools[var7[arg0.Data:GetType()]]
		local var1 = tf(arg0.GO)

		SetCompomentEnabled(var1:Find("Item"), typeof(Image), false)
		arg0.loader:ClearRequest(var1:Find("Ring"))
		table.Foreach(arg0.links, function(arg0)
			local var0 = var1:Find("Links/" .. arg0)

			arg0.loader:ClearRequest(var0)
		end)
		arg0.loader:ClearRequest(var1)

		if not var0:Enqueue(go(arg0.GO)) then
			setParent(go(arg0.GO), arg0.pluralRoot)
			setActive(go(arg0.GO), false)
		end
	end)
	table.clean(arg0.nodeList)
	arg0:InitFormula(arg1)
end

function var0.HideFormulaDetail(arg0)
	if not isActive(arg0.layerFormulaDetail) then
		return
	end

	arg0:HideCandicatePanel()
	setParent(arg0.painting, arg0._tf)
	arg0.painting:SetSiblingIndex(1)
	setParent(arg0.layerFormulaOverlay, arg0.layerFormulaDetail)
	setActive(arg0.layerFormulaDetail, false)

	return true
end

local var8 = {
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
local var9 = {
	[var1.TYPE.EQUIP] = "text_equip",
	[var1.TYPE.ITEM] = "text_item",
	[var1.TYPE.TOOL] = "text_other",
	[var1.TYPE.OTHER] = "text_other"
}

function var0.InitFormula(arg0, arg1)
	arg0.contextData.formulaId = arg1:GetConfigID()

	local var0 = arg0.layerFormulaOverlay:Find("Description")

	arg0.loader:GetSpriteQuiet(var4, var9[arg1:GetType()], var0:Find("Type"))

	local var1 = {
		type = arg1:GetProduction()[1],
		id = arg1:GetProduction()[2]
	}

	arg0:UpdateRyzaDrop(var0:Find("Icon"), var1)
	setText(var0:Find("Name"), arg1:GetName())
	setText(var0:Find("Description/Text"), arg1:GetDesc())

	local var2 = tostring(arg1:GetMaxLimit() - arg1:GetUsedCount())

	if arg1:GetMaxLimit() < 0 then
		var2 = "∞"
	end

	setText(var0:Find("RestCount/Text"), i18n("ryza_rest_produce_count", var2))
	setActive(arg0.layerMaterialSelect, false)

	local var3 = arg0.layerFormulaDetail:Find("ScrollView/Content")

	setAnchoredPosition(var3, Vector2.zero)
	_.each(arg1:GetCircleList(), function(arg0)
		local var0 = var2.New({
			configId = arg0
		})
		local var1 = arg0.nodePools[var7[var0:GetType()]]:Dequeue()

		var1.name = arg0

		setActive(var1, true)
		setParent(tf(var1), var3)

		local var2 = {
			Change = true,
			Data = var0,
			GO = var1
		}

		table.insert(arg0.nodeList, var2)
	end)

	local var4 = 280
	local var5 = math.deg2Rad * 30
	local var6 = var4 * Vector2.New(math.cos(var5), math.sin(var5))
	local var7 = var4 * Vector2(0, 1)
	local var8 = Vector2.zero

	local function var9(arg0, arg1)
		setAnchoredPosition(arg0.GO, arg1)

		local var0 = arg0.Data:GetNeighbors()

		arg0.links = {}

		_.each(var0, function(arg0)
			local var0 = arg0[1]
			local var1 = arg0[2]
			local var2 = var8[var0]
			local var3 = var2[1] * var6 + var2[2] * var7
			local var4 = _.detect(arg0.nodeList, function(arg0)
				return arg0.Data:GetConfigID() == var1
			end)

			var4.prevLink = {
				(var0 + 2) % 5 + 1,
				arg0
			}
			arg0.links[var0] = var4

			local var5 = arg1 + var3

			var9(var4, var5)

			var8 = Vector2.Max(var8, -var5)
			var8 = Vector2.Max(var8, var5)
		end)
	end

	var9(arg0.nodeList[1], Vector2.zero)
	setSizeDelta(var3, (var8 + Vector2.New(var4, var4)) * 2)
	onButton(arg0, arg0.layerFormulaDetail:Find("Composite"), function()
		if not _.all(arg0.nodeList, function(arg0)
			return arg0.Instance
		end) then
			arg0:ShowMaterialsPreview()

			return
		end

		if not arg0.activity:GetFormulas()[arg0.contextData.formulaId]:IsAvaliable() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

			return
		end

		arg0:ShowCompositeConfirmWindow()
	end, SFX_PANEL)
	onButton(arg0, arg0.layerFormulaDetail:Find("AutoFill"), function()
		local var0 = {}
		local var1 = arg0.activity:GetItems()

		local function var2(arg0)
			local var0 = var0[arg0:GetConfigID()] or Clone(var1[arg0:GetConfigID()])

			assert(var0, "Using Unexist material")

			var0.count = var0.count - 1
			var0[arg0:GetConfigID()] = var0
		end

		local var3 = {}

		_.each(arg0.nodeList, function(arg0)
			if arg0.Instance then
				var2(arg0.Instance)
			else
				table.insert(var3, arg0)
			end
		end)

		if #var3 <= 0 then
			return
		end

		local var4 = true

		local function var5()
			if not var4 then
				return
			end

			arg0:DispalyChat({
				"ryza_atellier5",
				"ryza_atellier6",
				"ryza_atellier7"
			})

			var4 = false
		end

		local var6 = false
		local var7

		local function var8()
			if var7 and coroutine.status(var7) == "suspended" then
				local var0, var1 = coroutine.resume(var7)

				assert(var0, debug.traceback(var7, var1))
			end
		end

		var7 = coroutine.create(function()
			_.each(var3, function(arg0)
				local var0 = arg0.Data

				if var0:GetType() == var2.TYPE.BASE or var0:GetType() == var2.TYPE.SAIREN then
					local var1 = var0:GetLimitItemID()
					local var2 = var0[var1] or var1[var1]

					if var2 and var2.count > 0 then
						var2(var2)
						var5()
						arg0:FillNodeAndPlayAnim(arg0, AtelierMaterial.New({
							count = 1,
							configId = var1
						}), var8, true)
						coroutine.yield()
					else
						var6 = true
					end
				end
			end)

			if not var6 then
				local var0 = false
				local var1 = false

				arg0:DisPlayUnlockEffect(function()
					var0 = true

					if var1 then
						var8()
					end
				end)

				if not var0 then
					var1 = true

					coroutine.yield()
				end

				local var2 = true

				local function var3()
					if not var2 then
						return
					end

					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_5")

					var2 = false
				end

				local var4 = AtelierMaterial.bindConfigTable()
				local var5 = function(arg0)
					local var0 = arg0.Data

					for iter0, iter1 in ipairs(var4.all) do
						local var1 = var0[iter1] or var1[iter1]

						if var1 and var1.count > 0 and var1:IsNormal() and var0:CanUseMaterial(var1, arg1) then
							var2(var1)
							var5()
							var3()
							arg0:FillNodeAndPlayAnim(arg0, AtelierMaterial.New({
								count = 1,
								configId = var1:GetConfigID()
							}), true)

							return
						end
					end

					var6 = true
				end

				_.each(var3, function(arg0)
					if arg0.Data:GetType() == var2.TYPE.NORMAL then
						var5(arg0)
					end
				end)
				_.each(var3, function(arg0)
					if arg0.Data:GetType() == var2.TYPE.ANY then
						var5(arg0)
					end
				end)
			end

			if var6 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_material_not_enough"))
			end

			arg0:UpdateFormulaDetail()
		end)

		var8()
	end, SFX_PANEL)
	arg0:UpdateFormulaDetail()
end

function var0.CleanNodeInstance(arg0)
	local var0 = arg0.activity:GetFormulas()[arg0.contextData.formulaId]

	if not var0:IsAvaliable() then
		arg0:HideFormulaDetail()

		arg0.contextData.formulaId = nil

		arg0:ShowFormulaList()

		return
	end

	_.each(arg0.nodeList, function(arg0)
		arg0.Instance = nil
		arg0.Change = true
	end)
	arg0:ShowFormulaDetail(var0)
end

function var0.UpdateFormulaDetail(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = tobool(arg0.unlockAllBase)

	arg0.unlockAllBase = true

	_.each(arg0.nodeList, function(arg0)
		var0 = var0 + 1
		var1 = var1 + (arg0.Instance and 1 or 0)
		arg0.unlockAllBase = arg0.unlockAllBase and (arg0.Data:GetType() ~= var2.TYPE.BASE and arg0.Data:GetType() ~= var2.TYPE.SAIREN or arg0.Instance)
	end)
	_.each(arg0.nodeList, function(arg0)
		local var0 = not arg0.unlockAllBase and arg0.Data:GetType() ~= var2.TYPE.BASE and arg0.Data:GetType() ~= var2.TYPE.SAIREN

		arg0.ChangeLock = arg0.ChangeLock or tobool(arg0.Lock) and not var0
		arg0.Lock = var0
	end)

	local var3 = arg0.unlockAllBase ~= var2

	_.each(arg0.nodeList, function(arg0)
		if var3 then
			arg0.Change = true
		end

		arg0:UpdateNodeView(arg0)
	end)
	setText(arg0.layerFormulaDetail:Find("Bar/Text"), i18n("ryza_tip_put_materials", var1, var0))
	setGray(arg0.layerFormulaDetail:Find("AutoFill"), not arg0.activity:GetFormulas()[arg0.contextData.formulaId]:IsAvaliable())
	setActive(arg0.layerFormulaDetail:Find("Composite/Disabled"), var1 < var0)
end

local var10 = {
	[var2.ELEMENT_TYPE.PYRO] = "laisha_ui_huo",
	[var2.ELEMENT_TYPE.CRYO] = "laisha_ui_bing",
	[var2.ELEMENT_TYPE.ELECTRO] = "laisha_ui_lei",
	[var2.ELEMENT_TYPE.ANEMO] = "laisha_ui_feng",
	[var2.ELEMENT_TYPE.SAIREN] = "laisha_ui_sairen"
}
local var11 = "laisha_ui_wupinshanguang"
local var12 = "laisha_ui_jiesuo"
local var13 = {
	"laisha_ui_lianjie01",
	"laisha_ui_lianjie02",
	"laisha_ui_lianjie_qiehuan"
}

function var0.UpdateNodeView(arg0, arg1)
	local var0 = tf(arg1.GO)

	for iter0 = 1, 6 do
		setActive(var0:Find("Links"):GetChild(iter0 - 1), false)
	end

	local var1 = arg1.Data

	_.each(var1:GetNeighbors(), function(arg0)
		setActive(var0:Find("Links"):GetChild(arg0[1] - 1), true)
	end)

	local var2 = var1:GetElementName()
	local var3 = arg1.Lock

	setActive(var0:Find("Lock"), var3)

	if var3 then
		if var1:GetType() ~= var2.TYPE.ANY then
			arg0.loader:GetSpriteQuiet(var5, "element_" .. var2, var0:Find("Lock/Require/Icon"))
		end

		setText(var0:Find("Lock/Require/Text"), "X" .. var1:GetLevel())
	end

	for iter1 = 3, var1:GetLevel() + 1, -1 do
		local var4 = var0:Find("Slots"):GetChild(iter1 - 1)

		arg0.loader:GetSpriteQuiet(var4, "slot_BLOCKED", var4:Find("Image"))
	end

	local var5 = arg1.Instance

	if not var5 then
		if var1:GetType() == var2.TYPE.ANY then
			setActive(var0:Find("All"), true)
		else
			setActive(var0:Find("Icon"), true)
			arg0.loader:GetSpriteQuiet(var4, "icon_" .. var2, var0:Find("Icon"), true)
		end

		setActive(var0:Find("Item"), false)

		if var1:GetType() == var2.TYPE.BASE or var1:GetType() == var2.TYPE.SAIREN then
			local var6 = AtelierMaterial.New({
				configId = var1:GetLimitItemID()
			})

			setActive(var0:Find("Name"), true)
			setScrollText(var0:Find("Name/Rect/Text"), var6:GetName())
		else
			setActive(var0:Find("Name"), false)
		end

		for iter2 = 1, var1:GetLevel() do
			local var7 = var0:Find("Slots"):GetChild(iter2 - 1)

			arg0.loader:GetSpriteQuiet(var4, "slot_NULL", var7:Find("Image"))
		end
	else
		local var8 = var1:GetRingElement(var5)
		local var9 = var2.ELEMENT_NAME[var8]

		if var1:GetType() == var2.TYPE.ANY then
			setActive(var0:Find("All"), false)
		else
			setActive(var0:Find("Icon"), false)
		end

		setActive(var0:Find("Item"), true)

		local var10

		if var1:GetType() == var2.TYPE.BASE or var1:GetType() == var2.TYPE.SAIREN then
			var10 = var5:GetBaseCircleTransform()
		else
			var10 = var5:GetNormalCircleTransform()
		end

		setLocalScale(var0:Find("Item"), Vector3.New(unpack(var10, 1, 3)))
		setAnchoredPosition(var0:Find("Item"), Vector2.New(unpack(var10, 4, 5)))
		arg0.loader:GetSpriteQuiet(var5:GetIconPath(), "", var0:Find("Item"), true)
		setActive(var0:Find("Name"), true)
		setScrollText(var0:Find("Name/Rect/Text"), var5:GetName())

		for iter3 = 1, var1:GetLevel() do
			local var11 = var0:Find("Slots"):GetChild(iter3 - 1)

			arg0.loader:GetSpriteQuiet(var4, "slot_" .. var9, var11:Find("Image"))
		end
	end

	local var12 = var0:Find("Ring")

	setImageColor(var12, var1:GetElementRingColor(var5))

	if arg1.Change then
		local var13 = arg1.Data:GetRingElement(var5)

		if var3 then
			var13 = nil
		end

		if var10[var13] then
			local var14 = arg1.Data:GetType() == var2.TYPE.BASE and "_o" or "_6"

			arg0.loader:GetPrefab("ui/" .. var10[var13] .. var14, "", function(arg0)
				setParent(arg0, var12)
				setAnchoredPosition(arg0, Vector2.zero)
			end, var12)
		else
			arg0.loader:ClearRequest(var12)
		end

		table.Foreach(arg1.links, function(arg0, arg1)
			local var0 = var0:Find("Links/" .. arg0)
			local var1 = var13[3]

			if arg1.Lock and var3 then
				var1 = var13[1]
			elseif not arg1.Lock and not var3 then
				var1 = var13[2]
			end

			arg0.loader:GetPrefab("ui/" .. var1, "", function(arg0)
				setParent(arg0, var0:Find("Link"))
				setAnchoredPosition(arg0, Vector2.New(0, -15))
			end, var0)
		end)

		arg1.Change = nil
	end

	if arg1.ChangeInstance then
		local var15 = var0:Find("Item")

		if var5 then
			arg0.loader:GetPrefab("ui/" .. var11, "", function(arg0)
				setParent(arg0, var15)
				setAnchoredPosition(arg0, Vector2.zero)
			end, var0)
		else
			arg0.loader:ClearRequest(var0)
		end

		arg1.ChangeInstance = nil
	end

	onButton(arg0, var0, function()
		if var3 then
			return
		end

		local var0 = arg0.layerMaterialSelect:Find("TargetBG")

		var0.localRotation = Quaternion.identity

		local var1 = var1:GetType() == var2.TYPE.BASE and 300 or 245

		setSizeDelta(var0, {
			x = var1,
			y = var1
		})

		local var2 = arg0.layerMaterialSelect:Find("Target")

		arg0:ShowCandicatePanel()

		local var3 = tf(Instantiate(var0))

		SetCompomentEnabled(var3, typeof(Button), false)
		setParent(var3, var2)
		setAnchoredPosition(var3, Vector2.zero)

		for iter0 = 1, 6 do
			setActive(var3:Find("Links"):GetChild(iter0 - 1), false)
		end

		local var4 = var2.anchoredPosition
		local var5 = arg0.layerFormulaDetail:Find("ScrollView/Content")
		local var6 = var0.anchoredPosition + arg0.layerFormulaDetail:Find("ScrollView").anchoredPosition

		setAnchoredPosition(var5, var4 - var6)

		arg0.candicateTarget = arg1

		GetComponent(var0, typeof(Animator)):SetBool("Selecting", true)
		arg0:UpdateCandicatePanel()
	end, SFX_PANEL)
end

function var0.FillNodeAndPlayAnim(arg0, arg1, arg2, arg3, arg4)
	arg0:LoadingOn()

	arg1.ChangeInstance = arg1.ChangeInstance or tobool(arg1.Instance) ~= tobool(arg2)
	arg1.Instance = arg2
	arg1.Change = true

	local var0 = {}
	local var1 = {}

	seriesAsync({
		function(arg0)
			table.ParallelIpairsAsync({
				"ui/laisha_ui_wupinzhiru",
				"ui/laisha_ui_baoshi"
			}, function(arg0, arg1, arg2)
				var0[arg0] = arg0.loader:GetPrefab(arg1, "", function(arg0)
					setParent(arg0, tf(arg1.GO))
					setAnchoredPosition(arg0, Vector2.zero)

					var1[arg0] = arg0

					setActive(arg0, false)
					arg2()
				end)
			end, arg0)
		end,
		function(arg0)
			setActive(var1[1], true)
			arg0:managedTween(LeanTween.delayedCall, function()
				if not arg4 then
					arg0:UpdateFormulaDetail()
				else
					arg0:UpdateNodeView(arg1)
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_4")
				arg0()
			end, 0.2, nil)
		end,
		function(arg0)
			setActive(var1[2], true)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0()
			end, 0.5, nil)
		end,
		function(arg0)
			arg0.loader:ClearRequest(var0[1])
			arg0.loader:ClearRequest(var0[2])
			arg0:LoadingOff()
			existCall(arg3)
		end
	})
end

function var0.DisPlayUnlockEffect(arg0, arg1)
	arg0.unlockAllBase = true

	_.each(arg0.nodeList, function(arg0)
		arg0.unlockAllBase = arg0.unlockAllBase and (arg0.Data:GetType() ~= var2.TYPE.BASE and arg0.Data:GetType() ~= var2.TYPE.SAIREN or arg0.Instance)
	end)
	_.each(arg0.nodeList, function(arg0)
		local var0 = not arg0.unlockAllBase and arg0.Data:GetType() ~= var2.TYPE.BASE and arg0.Data:GetType() ~= var2.TYPE.SAIREN

		arg0.ChangeLock = arg0.ChangeLock or tobool(arg0.Lock) and not var0
		arg0.Lock = var0
	end)

	if not _.any(arg0.nodeList, function(arg0)
		return arg0.ChangeLock
	end) then
		existCall(arg1)

		return
	end

	arg0:LoadingOn()

	local var0 = {}

	_.each(arg0.nodeList, function(arg0)
		local var0 = tf(arg0.GO)

		if arg0.ChangeLock then
			if arg0.prevLink then
				arg0.prevLink[2].Change = true
			end

			local var1 = arg0.loader:GetPrefab("ui/" .. var12, "", function(arg0)
				setParent(arg0, var0)
				setAnchoredPosition(arg0, Vector2.zero)
			end)

			table.insert(var0, var1)

			arg0.ChangeLock = nil
		end
	end)
	arg0:managedTween(LeanTween.delayedCall, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_3")
	end, 0.7, nil)
	arg0:managedTween(LeanTween.delayedCall, function()
		_.each(var0, function(arg0)
			arg0.loader:ClearRequest(arg0)
		end)
		arg0:LoadingOff()
		existCall(arg1)
	end, 1.7, nil)
end

function var0.ShowCandicatePanel(arg0)
	arg0:DispalyChat({
		"ryza_atellier2",
		"ryza_atellier3",
		"ryza_atellier4"
	})
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_1")
	pg.UIMgr.GetInstance():BlurPanel(arg0.top)
	setActive(arg0.layerMaterialSelect, true)
	SetCompomentEnabled(arg0.layerFormulaDetail:Find("ScrollView"), typeof(ScrollRect), false)
	removeAllChildren(arg0.layerMaterialSelect:Find("Target"))
end

function var0.CloseCandicatePanel(arg0)
	arg0:LoadingOn()

	local var0 = GetComponent(arg0.layerMaterialSelect:Find("TargetBG"), typeof(DftAniEvent))

	var0:SetEndEvent(function()
		arg0:LoadingOff()
		arg0:HideCandicatePanel()
		var0:SetEndEvent(nil)
	end)
	GetComponent(arg0.layerMaterialSelect:Find("TargetBG"), typeof(Animator)):SetBool("Selecting", false)
end

function var0.HideCandicatePanel(arg0)
	if not isActive(arg0.layerMaterialSelect) then
		return
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0.top)
	arg0.painting:SetSiblingIndex(1)
	setActive(arg0.layerMaterialSelect, false)
	removeAllChildren(arg0.layerMaterialSelect:Find("Target"))
	SetCompomentEnabled(arg0.layerFormulaDetail:Find("ScrollView"), typeof(ScrollRect), true)

	arg0.candicateTarget = nil

	return true
end

function var0.UpdateCandicatePanel(arg0)
	arg0.candicates = {}

	local var0 = arg0.activity:GetItems()
	local var1 = arg0.activity:GetFormulas()[arg0.contextData.formulaId]
	local var2 = AtelierMaterial.bindConfigTable()
	local var3 = _.map(var2.all, function(arg0)
		local var0 = var0[arg0] or AtelierMaterial.New({
			configId = arg0
		})

		if arg0.candicateTarget.Data:CanUseMaterial(var0, var1) then
			if var0[arg0] then
				var0 = AtelierMaterial.New({
					configId = arg0,
					count = var0[arg0].count
				})
				var0.count = _.reduce(arg0.nodeList, var0.count, function(arg0, arg1)
					if arg1.Instance and arg1.Instance:GetConfigID() == arg0 then
						arg0 = arg0 - 1
					end

					return arg0
				end)
			end

			return var0
		end
	end)

	table.sort(var3, function(arg0, arg1)
		if arg0.count * arg1.count == 0 and arg0.count - arg1.count ~= 0 then
			return arg0.count < arg1.count
		else
			return arg0:GetConfigID() < arg1:GetConfigID()
		end
	end)
	_.each(var3, function(arg0)
		for iter0 = 1, math.max(arg0.count, 1) do
			table.insert(arg0.candicates, arg0)
		end
	end)
	arg0.candicatesRect:SetTotalCount(#arg0.candicates, 0)
end

function var0.UpdateCandicateItem(arg0, arg1, arg2)
	local var0 = tf(arg2)
	local var1 = arg0.candicates[arg1]

	arg0:UpdateRyzaItem(var0:Find("IconBG"), var1, true)

	local var2 = var1.count <= 0

	setActive(var0:Find("IconBG/Lack"), var2)
	onButton(arg0, var0, function()
		if var2 then
			var1 = CreateShell(var1)
			var1.count = false

			arg0:ShowItemDetail(var1)
		else
			arg0:DispalyChat({
				"ryza_atellier5",
				"ryza_atellier6",
				"ryza_atellier7"
			})
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_2")

			local var0 = arg0.candicateTarget

			arg0:HideCandicatePanel()
			seriesAsync({
				function(arg0)
					arg0:FillNodeAndPlayAnim(var0, AtelierMaterial.New({
						count = 1,
						configId = var1:GetConfigID()
					}), arg0, true)
				end,
				function(arg0)
					arg0:DisPlayUnlockEffect(arg0)
				end,
				function(arg0)
					arg0:UpdateFormulaDetail()
				end
			})
		end
	end, SFX_PANEL)
end

function var0.UpdateRyzaItem(arg0, arg1, arg2, arg3)
	local var0 = "icon_frame_" .. arg2:GetRarity()

	if arg3 then
		var0 = var0 .. "_small"
	end

	arg0.loader:GetSpriteQuiet(var5, var0, arg1)
	arg0.loader:GetSpriteQuiet(arg2:GetIconPath(), "", arg1:Find("Icon"))

	if not IsNil(arg1:Find("Lv")) then
		setText(arg1:Find("Lv/Text"), arg2:GetLevel())
	end

	local var1 = arg2:GetProps()
	local var2 = CustomIndexLayer.Clone2Full(arg1:Find("List"), #var1)

	for iter0, iter1 in ipairs(var2) do
		arg0.loader:GetSpriteQuiet(var5, "element_" .. var2.ELEMENT_NAME[var1[iter0]], iter1)
	end

	if not IsNil(arg1:Find("Text")) then
		setText(arg1:Find("Text"), arg2.count)
	end
end

function var0.ShowItemDetail(arg0, arg1)
	arg0:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, arg1)
end

local var14 = 41
local var15 = 5

function var0.ShowCompositeConfirmWindow(arg0)
	setActive(arg0.layerCompositeConfirm, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.layerCompositeConfirm)

	local var0 = 1
	local var1 = {}
	local var2 = {}

	_.each(arg0.nodeList, function(arg0)
		local var0 = arg0.Instance:GetConfigID()

		table.insert(var1, {
			key = arg0.Data:GetConfigID(),
			value = var0
		})

		var2[var0] = (var2[var0] or 0) + 1
	end)
	onButton(arg0, arg0.layerCompositeConfirm:Find("Window/Confirm"), function()
		arg0:emit(GAME.COMPOSITE_ATELIER_RECIPE, var1, var0)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/ryza_atellier_ui_6")
	end, SFX_PANEL)

	local var3 = arg0.activity:GetFormulas()[arg0.contextData.formulaId]
	local var4 = var3:GetMaxLimit() ~= 1
	local var5 = var3:GetMaxLimit() > 0 and var3:GetMaxLimit() - var3:GetUsedCount() or 10000
	local var6 = arg0.activity:GetItems()

	for iter0, iter1 in pairs(var2) do
		local var7 = var6[iter0] and var6[iter0].count or 0

		var5 = math.min(var5, math.floor(var7 / iter1))
	end

	local var8 = var5
	local var9 = {
		1,
		var4 and var8 or 1
	}
	local var10 = Drop.New({
		type = var3:GetProduction()[1],
		id = var3:GetProduction()[2]
	})

	arg0:UpdateRyzaDrop(arg0.layerCompositeConfirm:Find("Window/Icon"), var10)

	local var11 = arg0.layerCompositeConfirm:Find("Window/Counters")
	local var12 = var10:getConfig("name")

	setActive(var11, var4)

	if var4 then
		setAnchoredPosition(arg0.layerCompositeConfirm:Find("Window/Icon"), {
			y = var14
		})

		local function var13()
			setText(var11:Find("Number"), var0)
			setText(arg0.layerCompositeConfirm:Find("Window/Text"), i18n("ryza_composite_confirm", var12, var0))
		end

		var13()
		onButton(arg0, var11:Find("Plus"), function()
			local var0 = var0

			var0 = var0 + 1
			var0 = math.clamp(var0, var9[1], var9[2])

			if var0 == var0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13()
		end)
		onButton(arg0, var11:Find("Minus"), function()
			var0 = var0 - 1
			var0 = math.clamp(var0, var9[1], var9[2])

			var13()
		end)
		onButton(arg0, var11:Find("Plus10"), function()
			local var0 = var0

			var0 = var0 + 10
			var0 = math.clamp(var0, var9[1], var9[2])

			if var0 == var0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_max_composite_count"))

				return
			end

			var13()
		end)
		onButton(arg0, var11:Find("Minus10"), function()
			var0 = var0 - 10
			var0 = math.clamp(var0, var9[1], var9[2])

			var13()
		end)
	else
		setAnchoredPosition(arg0.layerCompositeConfirm:Find("Window/Icon"), {
			y = var15
		})
		setText(arg0.layerCompositeConfirm:Find("Window/Text"), i18n("ryza_composite_confirm_single", var12, var0))
	end
end

function var0.HideCompositeConfirmWindow(arg0)
	if not isActive(arg0.layerCompositeConfirm) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0.layerCompositeConfirm, arg0._tf)
	setActive(arg0.layerCompositeConfirm, false)

	return true
end

local var16 = "laisha_lianjin"

function var0.OnCompositeResult(arg0, arg1)
	arg0:LoadingOn()
	arg0:DispalyChat({
		"ryza_atellier8",
		"ryza_atellier9"
	})

	local var0 = 1.5
	local var1 = 0.5

	arg0.loader:GetPrefab("ui/" .. var16, "", function(arg0)
		pg.UIMgr.GetInstance():OverlayPanel(tf(arg0), {
			weight = LayerWeightConst.SECOND_LAYER
		})
		setAnchoredPosition(arg0, Vector2.zero)
		arg0:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0._tf, typeof(CanvasGroup)), 0, var0):setFrom(1)
		arg0:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0.top, typeof(CanvasGroup)), 0, var0):setFrom(1)
		arg0:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0.layerCompositeConfirm, typeof(CanvasGroup)), 0, var0):setFrom(1)
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:HideCompositeConfirmWindow()
			setCanvasGroupAlpha(arg0.layerCompositeConfirm, 1)
			arg0:CleanNodeInstance()
			arg0:ShowCompositeResult(arg1)
			arg0:DispalyChat({
				"ryza_atellier10",
				"ryza_atellier11"
			})
			arg0:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0._tf, typeof(CanvasGroup)), 1, var1):setFrom(0)
			arg0:managedTween(LeanTween.alphaCanvas, nil, GetComponent(arg0.top, typeof(CanvasGroup)), 1, var1):setFrom(0)
			arg0:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0.layerCompositeResult, typeof(CanvasGroup)), 1, var1):setFrom(0)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0:LoadingOff()
				pg.UIMgr.GetInstance():UnOverlayPanel(tf(arg0), arg0._tf)
				arg0.loader:ClearRequest("CompositeResult")
			end, go(arg0.layerCompositeResult), var1, nil)
		end, go(arg0.layerCompositeResult), var0, nil)
	end, "CompositeResult")
end

function var0.ShowCompositeResult(arg0, arg1)
	setActive(arg0.layerCompositeResult, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.layerCompositeResult)

	local var0 = arg1[1]

	arg0:UpdateRyzaDrop(arg0.layerCompositeResult:Find("Window/Icon"), var0)
	setScrollText(arg0.layerCompositeResult:Find("Window/NameBG/Rect/Name"), var0:getName())
	setText(arg0.layerCompositeResult:Find("Window/CountBG/Text"), var0.count)
end

function var0.HideCompositeResult(arg0)
	if not isActive(arg0.layerCompositeResult) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0.layerCompositeResult, arg0._tf)
	setActive(arg0.layerCompositeResult, false)

	if pg.NewStoryMgr.GetInstance():IsPlayed("NG0032") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0033", {
			2
		})
	end

	return true
end

function var0.ShowStoreHouseWindow(arg0)
	setActive(arg0.layerStoreHouse, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.layerStoreHouse)

	local var0 = _.filter(_.values(arg0.activity:GetItems()), function(arg0)
		return arg0.count > 0
	end)

	table.sort(var0, function(arg0, arg1)
		return arg0:GetConfigID() < arg1:GetConfigID()
	end)
	setActive(arg0.layerStoreHouse:Find("Window/Empty"), #var0 == 0)
	setActive(arg0.layerStoreHouse:Find("Window/ScrollView"), #var0 > 0)

	if #var0 == 0 then
		return
	end

	function arg0.storehouseRect.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		local var0 = tf(arg1)
		local var1 = var0[arg0]

		arg0:UpdateRyzaItem(var0:Find("IconBG"), var1)
		setScrollText(var0:Find("NameBG/Rect/Name"), var1:GetName())
		onButton(arg0, var0, function()
			arg0:ShowItemDetail(var1)
		end, SFX_PANEL)
	end

	arg0.storehouseRect:SetTotalCount(#var0)
end

function var0.CloseStoreHouseWindow(arg0)
	arg0.contextData.showStoreHouse = nil

	return arg0:HideStoreHouseWindow()
end

function var0.HideStoreHouseWindow(arg0)
	if not isActive(arg0.layerStoreHouse) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0.layerStoreHouse, arg0._tf)
	setActive(arg0.layerStoreHouse, false)

	return true
end

function var0.ShowMaterialsPreview(arg0)
	setActive(arg0.layerMaterialsPreview, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.layerMaterialsPreview)

	local var0 = arg0.activity:GetItems()
	local var1 = arg0.activity:GetFormulas()[arg0.contextData.formulaId]
	local var2 = AtelierMaterial.bindConfigTable()
	local var3 = {}
	local var4 = {}
	local var5 = {}

	local function var6(arg0)
		local var0 = var5[arg0:GetConfigID()] or Clone(var0[arg0:GetConfigID()])

		assert(var0, "Using Unexist material")

		var0.count = var0.count - 1
		var5[arg0:GetConfigID()] = var0
	end

	_.each(arg0.nodeList, function(arg0)
		local var0 = arg0.Data

		if var0:GetType() == var2.TYPE.BASE or var0:GetType() == var2.TYPE.SAIREN then
			local var1 = var0:GetLimitItemID()
			local var2 = var5[var1] or var0[var1]

			if var2 and var2.count > 0 then
				local var3 = AtelierMaterial.New({
					configId = var1
				})

				var3.count = false

				table.insert(var3, var3)
				var6(var2)
			else
				local var4 = AtelierMaterial.New({
					configId = var1
				})

				var4.count = false

				table.insert(var4, var4)
			end
		end
	end)

	local function var7(arg0)
		if arg0.Instance then
			local var0 = AtelierMaterial.New({
				configId = arg0.Instance:GetConfigID()
			})

			var0.count = false

			table.insert(var3, var0)
			var6(arg0.Instance)

			return
		end

		local var1 = arg0.Data
		local var2

		for iter0, iter1 in ipairs(var2.all) do
			local var3 = var5[iter1] or var0[iter1] or AtelierMaterial.New({
				configId = iter1
			})

			if var3:IsNormal() and var1:CanUseMaterial(var3, var1) then
				var2 = var2 or iter1

				if var3.count > 0 then
					local var4 = AtelierMaterial.New({
						configId = iter1
					})

					var4.count = false

					table.insert(var3, var4)
					var6(var3)

					return
				end
			end
		end

		local var5 = AtelierMaterial.New({
			configId = var2
		})

		var5.count = false

		table.insert(var4, var5)
	end

	_.each(arg0.nodeList, function(arg0)
		if arg0.Data:GetType() == var2.TYPE.NORMAL then
			var7(arg0)
		end
	end)
	_.each(arg0.nodeList, function(arg0)
		if arg0.Data:GetType() == var2.TYPE.ANY then
			var7(arg0)
		end
	end)

	local function var8(arg0, arg1)
		return arg0:GetConfigID() < arg1:GetConfigID()
	end

	table.sort(var3, var8)
	table.sort(var4, var8)

	local function var9()
		local var0 = arg0.layerMaterialsPreview:Find("Frame/Scroll/Content/Owned/List")

		setActive(var0.parent, #var3 > 0)

		if #var3 == 0 then
			return
		end

		local var1 = CustomIndexLayer.Clone2Full(var0, #var3)

		table.Foreach(var1, function(arg0, arg1)
			local var0 = var3[arg0]

			arg0:UpdateRyzaItem(arg1:Find("IconBG"), var0, true)
			onButton(arg0, arg1, function()
				arg0:ShowItemDetail(var0)
			end, SFX_PANEL)
		end)
	end

	local function var10()
		local var0 = arg0.layerMaterialsPreview:Find("Frame/Scroll/Content/Lack/List")

		setActive(var0.parent, #var4 > 0)

		if #var4 == 0 then
			return
		end

		local var1 = CustomIndexLayer.Clone2Full(var0, #var4)

		table.Foreach(var1, function(arg0, arg1)
			local var0 = var4[arg0]

			arg0:UpdateRyzaItem(arg1:Find("IconBG"), var0, true)
			onButton(arg0, arg1, function()
				arg0:ShowItemDetail(var0)
			end, SFX_PANEL)
		end)
	end

	var9()
	var10()
end

function var0.HideMaterialsPreview(arg0)
	if not isActive(arg0.layerMaterialsPreview) then
		return
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0.layerMaterialsPreview, arg0._tf)
	setActive(arg0.layerMaterialsPreview, false)

	return true
end

function var0.OnReceiveFormualRequest(arg0, arg1)
	arg0:HideCandicatePanel()
	arg0:HideCompositeConfirmWindow()
	arg0:HideCompositeResult()
	arg0:HideMaterialsPreview()
	arg0:CloseStoreHouseWindow()
	arg0:HideFormulaList()

	local var0 = arg0.activity:GetFormulas()[arg1]

	arg0:ShowFormulaDetail(var0)
end

function var0.DispalyChat(arg0, arg1)
	arg0:HideChat()
	setActive(arg0.chat, true)

	arg0.chatTween = LeanTween.delayedCall(go(arg0.chat), 4, System.Action(function()
		arg0:HideChat()
	end)).uniqueId

	local var0 = arg1[math.random(#arg1)]
	local var1 = pg.gametip.ryza_composite_words.tip
	local var2 = _.detect(var1, function(arg0)
		return arg0[1] == var0
	end)
	local var3 = var2 and var2[2]

	setText(arg0.chat:Find("Text"), var3)

	local var4 = 1090001
	local var5 = "event:/cv/" .. var4 .. "/" .. var0

	arg0:PlaySound(var5)
end

function var0.HideChat(arg0)
	if arg0.chatTween then
		LeanTween.cancel(arg0.chatTween)

		arg0.chatTween = nil
	end

	setActive(arg0.chat, false)
end

function var0.PlaySound(arg0, arg1, arg2)
	if not arg0.playbackInfo or arg1 ~= arg0.prevCvPath or arg0.playbackInfo.channelPlayer == nil then
		arg0:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1, function(arg0)
			if arg0 then
				arg0.playbackInfo = arg0

				arg0.playbackInfo:SetIgnoreAutoUnload(true)

				if arg2 then
					arg2(arg0.playbackInfo.cueInfo)
				end
			elseif arg2 then
				arg2()
			end
		end)

		arg0.prevCvPath = arg1

		if arg0.playbackInfo == nil then
			return nil
		end

		return arg0.playbackInfo.cueInfo
	elseif arg0.playbackInfo then
		arg0.playbackInfo:PlaybackStop()
		arg0.playbackInfo:SetStartTimeAndPlay()

		if arg2 then
			arg2(arg0.playbackInfo.cueInfo)
		end

		return arg0.playbackInfo.cueInfo
	elseif arg2 then
		arg2()
	end

	return nil
end

function var0.StopSound(arg0)
	if arg0.playbackInfo then
		pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0.playbackInfo)
		arg0.playbackInfo:SetIgnoreAutoUnload(false)
	end
end

function var0.ClearSound(arg0)
	arg0:StopSound()

	if arg0.playbackInfo then
		arg0.playbackInfo:Dispose()

		arg0.playbackInfo = nil
	end
end

function var0.LoadingOn(arg0)
	if arg0.animating then
		return
	end

	arg0.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0.LoadingOff(arg0)
	if not arg0.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0.animating = false
end

function var0.willExit(arg0)
	arg0.loader:Clear()
	arg0:LoadingOff()
	arg0:HideChat()
	arg0:ClearSound()
	arg0:HideStoreHouseWindow()
	arg0:HideMaterialsPreview()
	arg0:HideCompositeResult()
	arg0:HideCompositeConfirmWindow()
	arg0:HideCandicatePanel()
	arg0:HideFormulaDetail()
	arg0:HideFormulaList()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)

	if arg0.nodePools then
		for iter0, iter1 in pairs(arg0.nodePools) do
			iter1:ClearItems()
		end
	end
end

return var0
