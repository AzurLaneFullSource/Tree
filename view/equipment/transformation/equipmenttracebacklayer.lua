local var0 = class("EquipmentTraceBackLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "EquipmentTraceBackUI"
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("Adapt/Left/Operation")

	arg0.sortOrderBtn = var0:Find("Bar1")
	arg0.orderText = var0:Find("OrderText")
	arg0.sortBarBtn = var0:Find("Bar2")
	arg0.sortImg = var0:Find("SortImg")
	arg0.sortBar = arg0._tf:Find("Adapt/Left/SortBar")

	setActive(arg0.sortBar, false)

	arg0.equipLayout = arg0._tf:Find("Adapt/Left/Scroll View")
	arg0.equipLayoutScroll = arg0.equipLayout:GetComponent("LScrollRect")
	arg0.equipLayoutContent = arg0.equipLayout:Find("Viewport/Content")
	arg0.equipLayoutContent:GetComponent(typeof(GridLayoutGroup)).constraintCount = 6

	local var1 = arg0._tf:Find("Adapt/Right")

	arg0.sourceEquip = var1:Find("Source")
	arg0.sourceEquipStatus = var1:Find("Status")
	arg0.formulaWire = var1:Find("Wire")
	arg0.targetEquip = var1:Find("Target")
	arg0.confirmBtn = var1:Find("ConfirmBtn")
	arg0.cancelBtn = var1:Find("CancelBtn")
	arg0.materialLayout = var1:Find("Scroll View")
	arg0.materialLayoutContent = arg0.materialLayout:Find("Viewport/Content")
	arg0.goldText = var1:Find("GoldText")

	setText(var0:Find("Field/Text"), i18n("equipment_upgrade_quick_interface_source_chosen"))
	setText(var1:Find("Text"), i18n("equipment_upgrade_quick_interface_materials_consume"))

	arg0.loader = AutoLoader.New()
end

var0.SortType = {
	Rarity = "rarity",
	Strengthen = "level",
	Type = "type"
}

local var1 = {
	var0.SortType.Rarity,
	var0.SortType.Type,
	var0.SortType.Strengthen
}
local var2 = {
	[var0.SortType.Rarity] = "rarity",
	[var0.SortType.Type] = "type",
	[var0.SortType.Strengthen] = "strengthen"
}

var0.SortOrder = {
	Descend = 0,
	Ascend = 1
}

local var3 = {
	[var0.SortOrder.Descend] = "word_desc",
	[var0.SortOrder.Ascend] = "word_asc"
}

function var0.SetEnv(arg0, arg1)
	arg0.env = arg1
end

function var0.GetAllPaths(arg0, arg1)
	local var0 = {}
	local var1 = {
		{
			arg1
		}
	}

	while #var1 > 0 do
		local var2 = table.remove(var1, 1)
		local var3 = EquipmentProxy.GetTransformSources(var2[1])

		for iter0, iter1 in ipairs(var3) do
			local var4 = pg.equip_upgrade_data[iter1].upgrade_from
			local var5 = var2[2] and Clone(var2[2]) or {}

			table.insert(var5, 1, iter1)
			table.insert(var1, {
				var4,
				var5
			})

			local var6 = arg0.env.tracebackHelper:GetEquipmentTransformCandicates(var4)

			if #var6 > 0 then
				table.insertto(var0, _.map(var6, function(arg0)
					return {
						source = arg0,
						formulas = var5
					}
				end))
			end
		end
	end

	return var0
end

function var0.UpdateSourceEquipmentPaths(arg0)
	arg0.totalPaths = arg0:GetAllPaths(arg0.contextData.TargetEquipmentId)

	if arg0.contextData.sourceEquipmentInstance then
		local var0 = _.detect(arg0.totalPaths, function(arg0)
			return EquipmentTransformUtil.SameDrop(arg0.source, arg0.contextData.sourceEquipmentInstance)
		end)

		arg0.contextData.sourceEquipmentInstance = var0 and var0.source or nil
	end
end

function var0.UpdateSort(arg0)
	for iter0, iter1 in ipairs(arg0.totalPaths) do
		iter1.isSourceEnough = iter1.source.type ~= DROP_TYPE_ITEM or iter1.source.template.count >= iter1.source.composeCfg.material_num
		iter1.isMaterialEnough = iter1.isSourceEnough and EquipmentTransformUtil.CheckTransformFormulasSucceed(iter1.formulas, iter1.source)
	end

	table.sort(arg0.totalPaths, function(arg0, arg1)
		if arg0.isSourceEnough ~= arg1.isSourceEnough then
			return arg0.isSourceEnough
		end

		if arg0.isMaterialEnough ~= arg1.isMaterialEnough then
			return arg0.isMaterialEnough
		end

		if arg0.source.type ~= arg1.source.type then
			return arg0.source.type < arg1.source.type
		end

		local var0 = arg0.contextData.sortType
		local var1 = arg0.contextData.sortOrder == var0.SortOrder.Descend and 1 or -1

		if arg0.source.type == DROP_TYPE_ITEM then
			return (arg0.source.template.id - arg1.source.template.id) * var1 > 0
		end

		local var2 = arg0.source.template.shipId or -1
		local var3 = arg1.source.template.shipId or -1

		if var2 ~= var3 then
			return var2 < var3
		end

		local var4 = arg0.source.template:getConfigTable()[var0] - arg1.source.template:getConfigTable()[var0]

		var4 = var4 ~= 0 and var4 or arg0.source.template.id - arg1.source.template.id

		return var4 * var1 > 0
	end)
	setText(arg0.orderText, i18n(var3[arg0.contextData.sortOrder]))
	arg0.loader:GetSprite("ui/equipmenttracebackui_atlas", var2[arg0.contextData.sortType], arg0.sortImg)
end

function var0.didEnter(arg0)
	function arg0.equipLayoutScroll.onUpdateItem(arg0, arg1)
		arg0:UpdateSourceListItem(arg0, tf(arg1))
		TweenItemAlphaAndWhite(arg1)
	end

	function arg0.equipLayoutScroll.onReturnItem(arg0, arg1)
		ClearTweenItemAlphaAndWhite(arg1)
	end

	onButton(arg0, arg0.sortBarBtn, function()
		local var0 = isActive(arg0.sortBar)

		setActive(arg0.sortBar, not var0)
	end, SFX_PANEL)

	for iter0 = 1, arg0.sortBar.childCount do
		local var0 = arg0.sortBar:GetChild(iter0 - 1)

		onButton(arg0, var0, function()
			arg0.contextData.sortType = var1[iter0]

			arg0:UpdateSort()
			arg0:UpdateSourceList()
			setActive(arg0.sortBar, false)
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.sortOrderBtn, function()
		arg0.contextData.sortOrder = var0.SortOrder.Ascend - arg0.contextData.sortOrder

		arg0:UpdateSort()
		arg0:UpdateSourceList()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = arg0.contextData.sourceEquipmentInstance

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_quick_interface_feedback_source_chosen"))

			return
		end

		if not EquipmentTransformUtil.CheckTransformFormulasSucceed(arg0.contextData.sourceEquipmentFormulaList, var0) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_materials"))

			return
		end

		arg0:emit(EquipmentTraceBackMediator.TRANSFORM_EQUIP, var0, arg0.contextData.sourceEquipmentFormulaList)
	end, SFX_PANEL)

	arg0.contextData.sortOrder = arg0.contextData.sortOrder or var0.SortOrder.Descend
	arg0.contextData.sortType = arg0.contextData.sortType or var0.SortType.Rarity

	arg0:UpdateSourceEquipmentPaths()
	arg0:UpdateSort()
	arg0:UpdateSourceList()
	arg0:UpdateFormula()
	updateDrop(arg0.targetEquip, {
		type = DROP_TYPE_EQUIP,
		id = arg0.contextData.TargetEquipmentId
	})
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, true)
end

function var0.UpdateSourceList(arg0)
	arg0.lastSourceItem = nil

	arg0.equipLayoutScroll:SetTotalCount(#arg0.totalPaths)
end

function var0.UpdateSourceListItem(arg0, arg1, arg2)
	local var0 = arg0.totalPaths[arg1 + 1].source
	local var1 = var0.template

	updateDrop(arg2:Find("Item"), var0)
	setText(arg2:Find("Item/icon_bg/count"), var1.count)
	setActive(arg2:Find("EquipShip"), var1.shipId)
	setActive(arg2:Find("Selected"), false)

	if var0 == arg0.contextData.sourceEquipmentInstance then
		arg0.lastSourceItem = arg2

		setActive(arg2:Find("Selected"), true)
	end

	setActive(arg2:Find("Item/mask"), false)

	if var0.type == DROP_TYPE_ITEM then
		local var2 = arg2:Find("Item/icon_bg/count")
		local var3 = var1.count
		local var4 = var0.composeCfg.material_num
		local var5 = var4 <= var3
		local var6 = setColorStr(var3 .. "/" .. var4, var5 and COLOR_WHITE or COLOR_RED)

		setText(var2, var6)
		setActive(arg2:Find("Item/mask"), not var5)
	end

	if var1.shipId then
		local var7 = getProxy(BayProxy):getShipById(var1.shipId)

		arg0.loader:GetSprite("qicon/" .. var7:getPainting(), "", arg2:Find("EquipShip/Image"))
	end

	arg2:Find("Mask/NameText"):GetComponent(typeof(ScrollText)):SetText(var1:getConfig("name"))
	onButton(arg0, arg2:Find("Item"), function()
		if var0.type == DROP_TYPE_ITEM and not (var0.template.count >= var0.composeCfg.material_num) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_fragment", var0.template:getConfig("name")))

			return
		end

		if arg0.lastSourceItem then
			setActive(arg0.lastSourceItem:Find("Selected"), false)
		end

		arg0.lastSourceItem = arg2

		setActive(arg2:Find("Selected"), true)

		arg0.contextData.sourceEquipmentInstance = var0
		arg0.contextData.sourceEquipmentFormulaList = arg0.totalPaths[arg1 + 1].formulas

		arg0:UpdateFormula()
	end, SFX_PANEL)
end

function var0.UpdatePlayer(arg0, arg1)
	arg0.player = arg1

	arg0:UpdateConsumeComparer()
end

function var0.UpdateConsumeComparer(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = true

	if arg0.contextData.sourceEquipmentInstance then
		var2, var0, var1 = EquipmentTransformUtil.CheckTransformEnoughGold(arg0.contextData.sourceEquipmentFormulaList, arg0.contextData.sourceEquipmentInstance)
	end

	local var3 = setColorStr(var0, var2 and COLOR_WHITE or COLOR_RED)

	if var1 > 0 then
		var3 = var3 .. setColorStr(" + " .. var1, var2 and COLOR_GREEN or COLOR_RED)
	end

	arg0.goldText:GetComponent(typeof(Text)).text = var3
end

function var0.UpdateFormula(arg0)
	local var0 = arg0.contextData.sourceEquipmentInstance

	setActive(arg0.sourceEquipStatus, not var0)
	setActive(arg0.sourceEquip, var0)
	setActive(arg0.materialLayout, var0)

	if var0 then
		updateDrop(arg0.sourceEquip, var0)

		local var1 = arg0.sourceEquip:Find("icon_bg/count")
		local var2 = ""

		if var0 and var0.type == DROP_TYPE_ITEM then
			var2 = var0.composeCfg.material_num
		end

		setText(var1, var2)

		local var3 = arg0.contextData.sourceEquipmentFormulaList
		local var4 = not var3 or #var3 <= 1

		arg0.loader:GetSprite("ui/equipmenttracebackui_atlas", var4 and "wire" or "wire2", arg0.formulaWire)
		arg0:UpdateFormulaMaterials()
	else
		arg0:UpdateConsumeComparer()
	end
end

function var0.UpdateFormulaMaterials(arg0)
	if not arg0.contextData.sourceEquipmentFormulaList then
		return
	end

	local var0 = {}
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.contextData.sourceEquipmentFormulaList) do
		local var2 = pg.equip_upgrade_data[iter1]

		for iter2, iter3 in ipairs(var2.material_consume) do
			var0[iter3[1]] = (var0[iter3[1]] or 0) + iter3[2]
		end

		var1 = var1 + var2.coin_consume
	end

	local var3 = {}

	for iter4, iter5 in pairs(var0) do
		table.insert(var3, {
			id = iter4,
			count = iter5
		})
	end

	table.sort(var3, function(arg0, arg1)
		return arg0.id > arg1.id
	end)

	arg0.consumeMaterials = var3

	UIItemList.StaticAlign(arg0.materialLayoutContent, arg0.materialLayoutContent:GetChild(0), #arg0.consumeMaterials, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateFormulaMaterialItem(arg1, arg2)
		end
	end)
	Canvas.ForceUpdateCanvases()

	local var4 = arg0.materialLayoutContent.rect.height < arg0.materialLayout.rect.height

	arg0.materialLayout:GetComponent(typeof(ScrollRect)).enabled = not var4

	setActive(arg0.materialLayout:Find("Scrollbar"), not var4)

	if var4 then
		arg0.materialLayoutContent.anchoredPosition = Vector2.zero
	end

	arg0:UpdateConsumeComparer()
end

function var0.UpdateFormulaMaterialItem(arg0, arg1, arg2)
	local var0 = arg0.consumeMaterials[arg1 + 1]
	local var1 = {
		type = DROP_TYPE_ITEM,
		id = var0.id
	}

	updateDrop(arg2:Find("Item"), var1)

	local var2 = getProxy(BagProxy):getItemCountById(var0.id)

	setText(arg2:Find("Count"), setColorStr(var0.count, var2 >= var0.count and COLOR_GREEN or COLOR_RED) .. "/" .. var2)
	onButton(arg0, arg2:Find("Item"), function()
		arg0:emit(var0.ON_DROP, var1)
	end)
end

function var0.willExit(arg0)
	arg0.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
