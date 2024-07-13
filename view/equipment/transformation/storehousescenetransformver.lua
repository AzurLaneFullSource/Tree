local var0_0 = class("StoreHouseSceneTransformVer", import("view.base.BaseUI"))
local var1_0 = require("view.equipment.EquipmentSortCfg")
local var2_0 = 0

function var0_0.getUIName(arg0_1)
	return "StoreHouseUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2.contextData

	arg0_2.topItems = arg0_2:findTF("topItems")
	arg0_2.equipmentView = arg0_2:findTF("equipment_scrollview")
	arg0_2.blurPanel = arg0_2:findTF("blur_panel")
	arg0_2.topPanel = arg0_2:findTF("adapt/top", arg0_2.blurPanel)

	setActive(arg0_2:findTF("buttons", arg0_2.topPanel), true)

	arg0_2.indexBtn = arg0_2:findTF("buttons/index_button", arg0_2.topPanel)
	arg0_2.sortBtn = arg0_2:findTF("buttons/sort_button", arg0_2.topPanel)
	arg0_2.sortPanel = arg0_2:findTF("sort", arg0_2.topItems)
	arg0_2.sortContain = arg0_2:findTF("adapt/mask/panel", arg0_2.sortPanel)
	arg0_2.sortTpl = arg0_2:findTF("tpl", arg0_2.sortContain)

	setActive(arg0_2.sortTpl, false)

	arg0_2.equipSkinFilteBtn = arg0_2:findTF("buttons/EquipSkinFilteBtn", arg0_2.topPanel)

	local var1_2
	local var2_2 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var2_2:CheckLargeScreen() then
		var1_2 = arg0_2.equipmentView.rect.width > 2000
	else
		var1_2 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_2.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1_2 and 8 or 7
	arg0_2.decBtn = findTF(arg0_2.topPanel, "buttons/dec_btn")
	arg0_2.sortImgAsc = findTF(arg0_2.decBtn, "asc")
	arg0_2.sortImgDec = findTF(arg0_2.decBtn, "desc")
	arg0_2.equipmentBtn = arg0_2:findTF("blur_panel/adapt/left_length/frame/toggle_root/equipment")
	arg0_2.equipmentSkinBtn = arg0_2:findTF("blur_panel/adapt/left_length/frame/toggle_root/skin")

	setActive(arg0_2.equipmentBtn.parent, false)

	arg0_2.filterBusyToggle = arg0_2:findTF("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0_2.filterBusyToggle, false)

	arg0_2.bottomBack = arg0_2:findTF("adapt/bottom_back", arg0_2.topItems)
	arg0_2.bottomPanel = arg0_2:findTF("types", arg0_2.bottomBack)
	arg0_2.materialToggle = arg0_2.bottomPanel:Find("material")
	arg0_2.weaponToggle = arg0_2.bottomPanel:Find("weapon")
	arg0_2.designToggle = arg0_2.bottomPanel:Find("design")
	arg0_2.capacityTF = arg0_2:findTF("bottom_left/tip/capcity/Text", arg0_2.bottomBack)

	setActive(arg0_2.capacityTF.parent, false)

	arg0_2.tipTF = arg0_2:findTF("bottom_left/tip", arg0_2.bottomBack)
	arg0_2.tip = arg0_2.tipTF:Find("label")

	setActive(arg0_2.tip, false)

	arg0_2.helpBtn = arg0_2:findTF("adapt/help_btn", arg0_2.topItems)

	setActive(arg0_2.helpBtn, true)

	arg0_2.backBtn = arg0_2:findTF("blur_panel/adapt/top/back_btn")
	arg0_2.selectedMin = defaultValue(var0_2.selectedMin, 1)
	arg0_2.selectedMax = defaultValue(var0_2.selectedMax, pg.gameset.equip_select_limit.key_value or 0)
	arg0_2.selectedIds = Clone(var0_2.selectedIds or {})
	arg0_2.checkEquipment = var0_2.onEquipment or function(arg0_3)
		return true
	end
	arg0_2.onSelected = var0_2.onSelected or function()
		warning("not implemented.")
	end

	setActive(arg0_2:findTF("dispos", arg0_2.bottomBack), false)
	setActive(arg0_2:findTF("adapt/select_panel", arg0_2.topItems), false)

	arg0_2.selectTransformPanel = arg0_2:findTF("adapt/select_transform_panel", arg0_2.topItems)
	arg0_2.listEmptyTF = arg0_2:findTF("empty")

	setActive(arg0_2.listEmptyTF, false)

	arg0_2.listEmptyTxt = arg0_2:findTF("Text", arg0_2.listEmptyTF)

	setActive(arg0_2.bottomBack, false)
	setActive(arg0_2.selectTransformPanel, true)
	setActive(arg0_2.indexBtn, false)
	setActive(arg0_2.sortBtn, false)
	setActive(arg0_2.equipSkinFilteBtn, false)
	setActive(arg0_2.equipmentSkinBtn, false)
	setText(arg0_2.selectTransformPanel:Find("cancel_button/Image"), i18n("msgbox_text_cancel"))
	setText(arg0_2.selectTransformPanel:Find("confirm_button/Image"), i18n("msgbox_text_confirm"))
end

function var0_0.setSources(arg0_5, arg1_5)
	arg0_5.sourceVOs = arg1_5
end

function var0_0.OnMediatorRegister(arg0_6)
	arg0_6.warp = arg0_6.contextData.warp or StoreHouseConst.WARP_TO_WEAPON
	arg0_6.mode = arg0_6.contextData.mode or StoreHouseConst.OVERVIEW
	arg0_6.page = var2_0
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.backBtn, function()
		GetOrAddComponent(arg0_7._tf, typeof(CanvasGroup)).interactable = false

		arg0_7:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	arg0_7.equipmetItems = {}

	arg0_7:initEquipments()

	arg0_7.asc = arg0_7.contextData.asc or false

	if not arg0_7.contextData.sortData then
		arg0_7.contextData.sortData = var1_0.sort[1]
	end

	arg0_7.contextData.indexDatas = arg0_7.contextData.indexDatas or {}

	arg0_7:initSort()
	setActive(arg0_7.equipmentView, true)
	arg0_7:filterEquipment()

	arg0_7.equipmentRect.isStart = true

	arg0_7.equipmentRect:EndLayout()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7.blurPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7.topItems, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	setActive(arg0_7.sortImgAsc, arg0_7.asc)
	setActive(arg0_7.sortImgDec, not arg0_7.asc)

	if arg0_7.contextData.equipScrollPos then
		arg0_7:ScrollEquipPos(arg0_7.contextData.equipScrollPos.y)
	end

	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_equipment.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.selectTransformPanel:Find("cancel_button"), function()
		arg0_7:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.selectTransformPanel:Find("confirm_button"), function()
		local var0_11 = _.map(arg0_7.selectedIds, function(arg0_12)
			return arg0_12[1]
		end)

		if arg0_7.contextData.onConfirm(var0_11) then
			arg0_7:closeView()
		end
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_13)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_13.sortPanel) then
		triggerButton(arg0_13.sortPanel)

		return
	end

	triggerButton(arg0_13.backBtn)
end

function var0_0.initSort(arg0_14)
	onButton(arg0_14, arg0_14.decBtn, function()
		arg0_14.asc = not arg0_14.asc
		arg0_14.contextData.asc = arg0_14.asc

		arg0_14:filterEquipment()
	end)
end

function var0_0.initEquipments(arg0_16)
	arg0_16.isInitWeapons = true
	arg0_16.equipmentRect = arg0_16.equipmentView:GetComponent("LScrollRect")

	function arg0_16.equipmentRect.onInitItem(arg0_17)
		arg0_16:initEquipment(arg0_17)
	end

	arg0_16.equipmentRect.decelerationRate = 0.07

	function arg0_16.equipmentRect.onUpdateItem(arg0_18, arg1_18)
		arg0_16:updateEquipment(arg0_18, arg1_18)
	end

	function arg0_16.equipmentRect.onStart()
		arg0_16:updateSelected()
	end

	arg0_16.equipmentRect:ScrollTo(0)
end

function var0_0.updateEquipmentCount(arg0_20, arg1_20)
	arg0_20.equipmentRect:SetTotalCount(arg1_20 or #arg0_20.loadEquipmentVOs, -1)
	setActive(arg0_20.listEmptyTF, (arg1_20 or #arg0_20.loadEquipmentVOs) <= 0)
	setText(arg0_20.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0_0.ScrollEquipPos(arg0_21, arg1_21)
	local var0_21 = arg0_21.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1_21 = (var0_21.cellSize.y + var0_21.spacing.y) * math.ceil(#arg0_21.loadEquipmentVOs / var0_21.constraintCount) - var0_21.spacing.y + arg0_21.equipmentRect.paddingFront + arg0_21.equipmentRect.paddingEnd
	local var2_21 = var1_21 - arg0_21.equipmentView.rect.height

	var2_21 = var2_21 > 0 and var2_21 or var1_21

	local var3_21 = (arg1_21 - arg0_21.equipmentView.rect.height * 0.5) / var2_21

	arg0_21.equipmentRect:ScrollTo(var3_21)
end

function var0_0.onUIAnimEnd(arg0_22, arg1_22)
	arg0_22.onAnimDoneCallback = arg1_22
end

function var0_0.ExecuteAnimDoneCallback(arg0_23)
	if arg0_23.onAnimDoneCallback then
		arg0_23.onAnimDoneCallback()

		arg0_23.onAnimDoneCallback = nil
	end
end

function var0_0.selectCount(arg0_24)
	local var0_24 = 0

	for iter0_24, iter1_24 in ipairs(arg0_24.selectedIds) do
		var0_24 = var0_24 + iter1_24[2]
	end

	return var0_24
end

function var0_0.SelectTransformEquip(arg0_25, arg1_25, arg2_25)
	local var0_25 = false

	if arg0_25.selectedIds[1] and EquipmentTransformUtil.SameDrop(arg0_25.selectedIds[1][1], arg1_25) then
		var0_25 = true
	end

	if not var0_25 then
		if arg0_25.contextData.onSelect and not arg0_25.contextData.onSelect(arg1_25) then
			return
		end

		table.clean(arg0_25.selectedIds)
		table.insert(arg0_25.selectedIds, {
			arg1_25,
			1
		})
	else
		table.clean(arg0_25.selectedIds)
	end

	arg0_25:updateSelected()
end

function var0_0.initEquipment(arg0_26, arg1_26)
	local var0_26 = EquipmentItemTransformVer.New(arg1_26)

	onButton(arg0_26, var0_26.go, function()
		if var0_26.sourceVO == nil then
			return
		end

		arg0_26:SelectTransformEquip(var0_26.sourceVO, var0_26.sourceVO.count)
	end, SFX_PANEL)

	arg0_26.equipmetItems[arg1_26] = var0_26
end

function var0_0.updateEquipment(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.equipmetItems[arg2_28]

	if not var0_28 then
		arg0_28:initEquipment(arg2_28)

		var0_28 = arg0_28.equipmetItems[arg2_28]
	end

	local var1_28 = arg0_28.loadEquipmentVOs[arg1_28 + 1]

	var0_28:update(var1_28)

	local var2_28 = false
	local var3_28 = 0

	if var1_28 then
		for iter0_28, iter1_28 in ipairs(arg0_28.selectedIds) do
			if EquipmentTransformUtil.SameDrop(var1_28, iter1_28[1]) then
				var2_28 = true
				var3_28 = iter1_28[2]

				break
			end
		end
	end

	var0_28:updateSelected(var2_28, var3_28)
end

function var0_0.updateSelected(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29.equipmetItems) do
		if iter1_29.sourceVO then
			local var0_29 = false
			local var1_29 = 0

			for iter2_29, iter3_29 in pairs(arg0_29.selectedIds) do
				if EquipmentTransformUtil.SameDrop(iter1_29.sourceVO, iter3_29[1]) then
					var0_29 = true
					var1_29 = iter3_29[2]

					break
				end
			end

			iter1_29:updateSelected(var0_29, var1_29)
		end
	end
end

function var0_0.filterEquipment(arg0_30)
	local var0_30 = arg0_30.contextData.sortData
	local var1_30 = arg0_30.sourceVOs

	arg0_30.loadEquipmentVOs = {}

	for iter0_30, iter1_30 in pairs(var1_30) do
		if iter1_30.type ~= DROP_TYPE_EQUIP or iter1_30.template.count > 0 then
			table.insert(arg0_30.loadEquipmentVOs, iter1_30)
		end
	end

	if var0_30 then
		local var2_30 = arg0_30.asc
		local var3_30 = {
			function(arg0_31)
				return arg0_31.type
			end,
			function(arg0_32)
				return arg0_32.template.shipId or -1
			end
		}
		local var4_30 = table.mergeArray(var3_30, underscore.map(var1_0.sortFunc(var0_30, var2_30), function(arg0_33)
			return function(arg0_34)
				return arg0_33(arg0_34.template)
			end
		end))

		table.sort(arg0_30.loadEquipmentVOs, CompareFuncs(var4_30))
	end

	arg0_30:updateSelected()
	arg0_30:updateEquipmentCount()
	setActive(arg0_30.sortImgAsc, arg0_30.asc)
	setActive(arg0_30.sortImgDec, not arg0_30.asc)
end

function var0_0.willExit(arg0_35)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_35.blurPanel, arg0_35._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_35.topItems, arg0_35._tf)
end

return var0_0
