local var0_0 = class("EquipmentTraceBackLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipmentTraceBackUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2._tf:Find("Adapt/Left/Operation")

	arg0_2.sortOrderBtn = var0_2:Find("Bar1")
	arg0_2.orderText = var0_2:Find("OrderText")
	arg0_2.sortBarBtn = var0_2:Find("Bar2")
	arg0_2.sortImg = var0_2:Find("SortImg")
	arg0_2.sortBar = arg0_2._tf:Find("Adapt/Left/SortBar")

	setActive(arg0_2.sortBar, false)

	arg0_2.equipLayout = arg0_2._tf:Find("Adapt/Left/Scroll View")
	arg0_2.equipLayoutScroll = arg0_2.equipLayout:GetComponent("LScrollRect")
	arg0_2.equipLayoutContent = arg0_2.equipLayout:Find("Viewport/Content")
	arg0_2.equipLayoutContent:GetComponent(typeof(GridLayoutGroup)).constraintCount = 6

	local var1_2 = arg0_2._tf:Find("Adapt/Right")

	arg0_2.sourceEquip = var1_2:Find("Source")
	arg0_2.sourceEquipStatus = var1_2:Find("Status")
	arg0_2.formulaWire = var1_2:Find("Wire")
	arg0_2.targetEquip = var1_2:Find("Target")
	arg0_2.confirmBtn = var1_2:Find("ConfirmBtn")
	arg0_2.cancelBtn = var1_2:Find("CancelBtn")
	arg0_2.materialLayout = var1_2:Find("Scroll View")
	arg0_2.materialLayoutContent = arg0_2.materialLayout:Find("Viewport/Content")
	arg0_2.goldText = var1_2:Find("GoldText")

	setText(var0_2:Find("Field/Text"), i18n("equipment_upgrade_quick_interface_source_chosen"))
	setText(var1_2:Find("Text"), i18n("equipment_upgrade_quick_interface_materials_consume"))

	arg0_2.loader = AutoLoader.New()
end

var0_0.SortType = {
	Rarity = "rarity",
	Strengthen = "level",
	Type = "type"
}

local var1_0 = {
	var0_0.SortType.Rarity,
	var0_0.SortType.Type,
	var0_0.SortType.Strengthen
}
local var2_0 = {
	[var0_0.SortType.Rarity] = "rarity",
	[var0_0.SortType.Type] = "type",
	[var0_0.SortType.Strengthen] = "strengthen"
}

var0_0.SortOrder = {
	Descend = 0,
	Ascend = 1
}

local var3_0 = {
	[var0_0.SortOrder.Descend] = "word_desc",
	[var0_0.SortOrder.Ascend] = "word_asc"
}

function var0_0.SetEnv(arg0_3, arg1_3)
	arg0_3.env = arg1_3
end

function var0_0.GetAllPaths(arg0_4, arg1_4)
	local var0_4 = {}
	local var1_4 = {
		{
			arg1_4
		}
	}

	while #var1_4 > 0 do
		local var2_4 = table.remove(var1_4, 1)
		local var3_4 = EquipmentProxy.GetTransformSources(var2_4[1])

		for iter0_4, iter1_4 in ipairs(var3_4) do
			local var4_4 = pg.equip_upgrade_data[iter1_4].upgrade_from
			local var5_4 = var2_4[2] and Clone(var2_4[2]) or {}

			table.insert(var5_4, 1, iter1_4)
			table.insert(var1_4, {
				var4_4,
				var5_4
			})

			local var6_4 = arg0_4.env.tracebackHelper:GetEquipmentTransformCandicates(var4_4)

			if #var6_4 > 0 then
				table.insertto(var0_4, _.map(var6_4, function(arg0_5)
					return {
						source = arg0_5,
						formulas = var5_4
					}
				end))
			end
		end
	end

	return var0_4
end

function var0_0.UpdateSourceEquipmentPaths(arg0_6)
	arg0_6.totalPaths = arg0_6:GetAllPaths(arg0_6.contextData.TargetEquipmentId)

	if arg0_6.contextData.sourceEquipmentInstance then
		local var0_6 = _.detect(arg0_6.totalPaths, function(arg0_7)
			return EquipmentTransformUtil.SameDrop(arg0_7.source, arg0_6.contextData.sourceEquipmentInstance)
		end)

		arg0_6.contextData.sourceEquipmentInstance = var0_6 and var0_6.source or nil
	end
end

function var0_0.UpdateSort(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.totalPaths) do
		iter1_8.isSourceEnough = iter1_8.source.type ~= DROP_TYPE_ITEM or iter1_8.source.template.count >= iter1_8.source.composeCfg.material_num
		iter1_8.isMaterialEnough = iter1_8.isSourceEnough and EquipmentTransformUtil.CheckTransformFormulasSucceed(iter1_8.formulas, iter1_8.source)
	end

	table.sort(arg0_8.totalPaths, function(arg0_9, arg1_9)
		if arg0_9.isSourceEnough ~= arg1_9.isSourceEnough then
			return arg0_9.isSourceEnough
		end

		if arg0_9.isMaterialEnough ~= arg1_9.isMaterialEnough then
			return arg0_9.isMaterialEnough
		end

		if arg0_9.source.type ~= arg1_9.source.type then
			return arg0_9.source.type < arg1_9.source.type
		end

		local var0_9 = arg0_8.contextData.sortType
		local var1_9 = arg0_8.contextData.sortOrder == var0_0.SortOrder.Descend and 1 or -1

		if arg0_9.source.type == DROP_TYPE_ITEM then
			return (arg0_9.source.template.id - arg1_9.source.template.id) * var1_9 > 0
		end

		local var2_9 = arg0_9.source.template.shipId or -1
		local var3_9 = arg1_9.source.template.shipId or -1

		if var2_9 ~= var3_9 then
			return var2_9 < var3_9
		end

		local var4_9 = arg0_9.source.template:getConfigTable()[var0_9] - arg1_9.source.template:getConfigTable()[var0_9]

		var4_9 = var4_9 ~= 0 and var4_9 or arg0_9.source.template.id - arg1_9.source.template.id

		return var4_9 * var1_9 > 0
	end)
	setText(arg0_8.orderText, i18n(var3_0[arg0_8.contextData.sortOrder]))
	arg0_8.loader:GetSprite("ui/equipmenttracebackui_atlas", var2_0[arg0_8.contextData.sortType], arg0_8.sortImg)
end

function var0_0.didEnter(arg0_10)
	function arg0_10.equipLayoutScroll.onUpdateItem(arg0_11, arg1_11)
		arg0_10:UpdateSourceListItem(arg0_11, tf(arg1_11))
		TweenItemAlphaAndWhite(arg1_11)
	end

	function arg0_10.equipLayoutScroll.onReturnItem(arg0_12, arg1_12)
		ClearTweenItemAlphaAndWhite(arg1_12)
	end

	onButton(arg0_10, arg0_10.sortBarBtn, function()
		local var0_13 = isActive(arg0_10.sortBar)

		setActive(arg0_10.sortBar, not var0_13)
	end, SFX_PANEL)

	for iter0_10 = 1, arg0_10.sortBar.childCount do
		local var0_10 = arg0_10.sortBar:GetChild(iter0_10 - 1)

		onButton(arg0_10, var0_10, function()
			arg0_10.contextData.sortType = var1_0[iter0_10]

			arg0_10:UpdateSort()
			arg0_10:UpdateSourceList()
			setActive(arg0_10.sortBar, false)
		end, SFX_PANEL)
	end

	onButton(arg0_10, arg0_10.sortOrderBtn, function()
		arg0_10.contextData.sortOrder = var0_0.SortOrder.Ascend - arg0_10.contextData.sortOrder

		arg0_10:UpdateSort()
		arg0_10:UpdateSourceList()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.cancelBtn, function()
		arg0_10:closeView()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.confirmBtn, function()
		local var0_17 = arg0_10.contextData.sourceEquipmentInstance

		if not var0_17 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_quick_interface_feedback_source_chosen"))

			return
		end

		if not EquipmentTransformUtil.CheckTransformFormulasSucceed(arg0_10.contextData.sourceEquipmentFormulaList, var0_17) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_materials"))

			return
		end

		arg0_10:emit(EquipmentTraceBackMediator.TRANSFORM_EQUIP, var0_17, arg0_10.contextData.sourceEquipmentFormulaList)
	end, SFX_PANEL)

	arg0_10.contextData.sortOrder = arg0_10.contextData.sortOrder or var0_0.SortOrder.Descend
	arg0_10.contextData.sortType = arg0_10.contextData.sortType or var0_0.SortType.Rarity

	arg0_10:UpdateSourceEquipmentPaths()
	arg0_10:UpdateSort()
	arg0_10:UpdateSourceList()
	arg0_10:UpdateFormula()
	updateDrop(arg0_10.targetEquip, {
		type = DROP_TYPE_EQUIP,
		id = arg0_10.contextData.TargetEquipmentId
	})
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf, true)
end

function var0_0.UpdateSourceList(arg0_18)
	arg0_18.lastSourceItem = nil

	arg0_18.equipLayoutScroll:SetTotalCount(#arg0_18.totalPaths)
end

function var0_0.UpdateSourceListItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.totalPaths[arg1_19 + 1].source
	local var1_19 = var0_19.template

	updateDrop(arg2_19:Find("Item"), var0_19)
	setText(arg2_19:Find("Item/icon_bg/count"), var1_19.count)
	setActive(arg2_19:Find("EquipShip"), var1_19.shipId)
	setActive(arg2_19:Find("Selected"), false)

	if var0_19 == arg0_19.contextData.sourceEquipmentInstance then
		arg0_19.lastSourceItem = arg2_19

		setActive(arg2_19:Find("Selected"), true)
	end

	setActive(arg2_19:Find("Item/mask"), false)

	if var0_19.type == DROP_TYPE_ITEM then
		local var2_19 = arg2_19:Find("Item/icon_bg/count")
		local var3_19 = var1_19.count
		local var4_19 = var0_19.composeCfg.material_num
		local var5_19 = var4_19 <= var3_19
		local var6_19 = setColorStr(var3_19 .. "/" .. var4_19, var5_19 and COLOR_WHITE or COLOR_RED)

		setText(var2_19, var6_19)
		setActive(arg2_19:Find("Item/mask"), not var5_19)
	end

	if var1_19.shipId then
		local var7_19 = getProxy(BayProxy):getShipById(var1_19.shipId)

		arg0_19.loader:GetSprite("qicon/" .. var7_19:getPainting(), "", arg2_19:Find("EquipShip/Image"))
	end

	arg2_19:Find("Mask/NameText"):GetComponent(typeof(ScrollText)):SetText(var1_19:getConfig("name"))
	onButton(arg0_19, arg2_19:Find("Item"), function()
		if var0_19.type == DROP_TYPE_ITEM and not (var0_19.template.count >= var0_19.composeCfg.material_num) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_fragment", var0_19.template:getConfig("name")))

			return
		end

		if arg0_19.lastSourceItem then
			setActive(arg0_19.lastSourceItem:Find("Selected"), false)
		end

		arg0_19.lastSourceItem = arg2_19

		setActive(arg2_19:Find("Selected"), true)

		arg0_19.contextData.sourceEquipmentInstance = var0_19
		arg0_19.contextData.sourceEquipmentFormulaList = arg0_19.totalPaths[arg1_19 + 1].formulas

		arg0_19:UpdateFormula()
	end, SFX_PANEL)
end

function var0_0.UpdatePlayer(arg0_21, arg1_21)
	arg0_21.player = arg1_21

	arg0_21:UpdateConsumeComparer()
end

function var0_0.UpdateConsumeComparer(arg0_22)
	local var0_22 = 0
	local var1_22 = 0
	local var2_22 = true

	if arg0_22.contextData.sourceEquipmentInstance then
		var2_22, var0_22, var1_22 = EquipmentTransformUtil.CheckTransformEnoughGold(arg0_22.contextData.sourceEquipmentFormulaList, arg0_22.contextData.sourceEquipmentInstance)
	end

	local var3_22 = setColorStr(var0_22, var2_22 and COLOR_WHITE or COLOR_RED)

	if var1_22 > 0 then
		var3_22 = var3_22 .. setColorStr(" + " .. var1_22, var2_22 and COLOR_GREEN or COLOR_RED)
	end

	arg0_22.goldText:GetComponent(typeof(Text)).text = var3_22
end

function var0_0.UpdateFormula(arg0_23)
	local var0_23 = arg0_23.contextData.sourceEquipmentInstance

	setActive(arg0_23.sourceEquipStatus, not var0_23)
	setActive(arg0_23.sourceEquip, var0_23)
	setActive(arg0_23.materialLayout, var0_23)

	if var0_23 then
		updateDrop(arg0_23.sourceEquip, var0_23)

		local var1_23 = arg0_23.sourceEquip:Find("icon_bg/count")
		local var2_23 = ""

		if var0_23 and var0_23.type == DROP_TYPE_ITEM then
			var2_23 = var0_23.composeCfg.material_num
		end

		setText(var1_23, var2_23)

		local var3_23 = arg0_23.contextData.sourceEquipmentFormulaList
		local var4_23 = not var3_23 or #var3_23 <= 1

		arg0_23.loader:GetSprite("ui/equipmenttracebackui_atlas", var4_23 and "wire" or "wire2", arg0_23.formulaWire)
		arg0_23:UpdateFormulaMaterials()
	else
		arg0_23:UpdateConsumeComparer()
	end
end

function var0_0.UpdateFormulaMaterials(arg0_24)
	if not arg0_24.contextData.sourceEquipmentFormulaList then
		return
	end

	local var0_24 = {}
	local var1_24 = 0

	for iter0_24, iter1_24 in ipairs(arg0_24.contextData.sourceEquipmentFormulaList) do
		local var2_24 = pg.equip_upgrade_data[iter1_24]

		for iter2_24, iter3_24 in ipairs(var2_24.material_consume) do
			var0_24[iter3_24[1]] = (var0_24[iter3_24[1]] or 0) + iter3_24[2]
		end

		var1_24 = var1_24 + var2_24.coin_consume
	end

	local var3_24 = {}

	for iter4_24, iter5_24 in pairs(var0_24) do
		table.insert(var3_24, {
			id = iter4_24,
			count = iter5_24
		})
	end

	table.sort(var3_24, function(arg0_25, arg1_25)
		return arg0_25.id > arg1_25.id
	end)

	arg0_24.consumeMaterials = var3_24

	UIItemList.StaticAlign(arg0_24.materialLayoutContent, arg0_24.materialLayoutContent:GetChild(0), #arg0_24.consumeMaterials, function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			arg0_24:UpdateFormulaMaterialItem(arg1_26, arg2_26)
		end
	end)
	Canvas.ForceUpdateCanvases()

	local var4_24 = arg0_24.materialLayoutContent.rect.height < arg0_24.materialLayout.rect.height

	arg0_24.materialLayout:GetComponent(typeof(ScrollRect)).enabled = not var4_24

	setActive(arg0_24.materialLayout:Find("Scrollbar"), not var4_24)

	if var4_24 then
		arg0_24.materialLayoutContent.anchoredPosition = Vector2.zero
	end

	arg0_24:UpdateConsumeComparer()
end

function var0_0.UpdateFormulaMaterialItem(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.consumeMaterials[arg1_27 + 1]
	local var1_27 = {
		type = DROP_TYPE_ITEM,
		id = var0_27.id
	}

	updateDrop(arg2_27:Find("Item"), var1_27)

	local var2_27 = getProxy(BagProxy):getItemCountById(var0_27.id)

	setText(arg2_27:Find("Count"), setColorStr(var0_27.count, var2_27 >= var0_27.count and COLOR_GREEN or COLOR_RED) .. "/" .. var2_27)
	onButton(arg0_27, arg2_27:Find("Item"), function()
		arg0_27:emit(var0_0.ON_DROP, var1_27)
	end)
end

function var0_0.willExit(arg0_29)
	arg0_29.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_29._tf)
end

return var0_0
