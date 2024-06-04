local var0 = class("StoreHouseSceneTransformVer", import("view.base.BaseUI"))
local var1 = require("view.equipment.EquipmentSortCfg")
local var2 = 0

function var0.getUIName(arg0)
	return "StoreHouseUI"
end

function var0.init(arg0)
	local var0 = arg0.contextData

	arg0.topItems = arg0:findTF("topItems")
	arg0.equipmentView = arg0:findTF("equipment_scrollview")
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.topPanel = arg0:findTF("adapt/top", arg0.blurPanel)

	setActive(arg0:findTF("buttons", arg0.topPanel), true)

	arg0.indexBtn = arg0:findTF("buttons/index_button", arg0.topPanel)
	arg0.sortBtn = arg0:findTF("buttons/sort_button", arg0.topPanel)
	arg0.sortPanel = arg0:findTF("sort", arg0.topItems)
	arg0.sortContain = arg0:findTF("adapt/mask/panel", arg0.sortPanel)
	arg0.sortTpl = arg0:findTF("tpl", arg0.sortContain)

	setActive(arg0.sortTpl, false)

	arg0.equipSkinFilteBtn = arg0:findTF("buttons/EquipSkinFilteBtn", arg0.topPanel)

	local var1
	local var2 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not var2:CheckLargeScreen() then
		var1 = arg0.equipmentView.rect.width > 2000
	else
		var1 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = var1 and 8 or 7
	arg0.decBtn = findTF(arg0.topPanel, "buttons/dec_btn")
	arg0.sortImgAsc = findTF(arg0.decBtn, "asc")
	arg0.sortImgDec = findTF(arg0.decBtn, "desc")
	arg0.equipmentBtn = arg0:findTF("blur_panel/adapt/left_length/frame/toggle_root/equipment")
	arg0.equipmentSkinBtn = arg0:findTF("blur_panel/adapt/left_length/frame/toggle_root/skin")

	setActive(arg0.equipmentBtn.parent, false)

	arg0.filterBusyToggle = arg0:findTF("blur_panel/adapt/left_length/frame/toggle_equip")

	setActive(arg0.filterBusyToggle, false)

	arg0.bottomBack = arg0:findTF("adapt/bottom_back", arg0.topItems)
	arg0.bottomPanel = arg0:findTF("types", arg0.bottomBack)
	arg0.materialToggle = arg0.bottomPanel:Find("material")
	arg0.weaponToggle = arg0.bottomPanel:Find("weapon")
	arg0.designToggle = arg0.bottomPanel:Find("design")
	arg0.capacityTF = arg0:findTF("bottom_left/tip/capcity/Text", arg0.bottomBack)

	setActive(arg0.capacityTF.parent, false)

	arg0.tipTF = arg0:findTF("bottom_left/tip", arg0.bottomBack)
	arg0.tip = arg0.tipTF:Find("label")

	setActive(arg0.tip, false)

	arg0.helpBtn = arg0:findTF("adapt/help_btn", arg0.topItems)

	setActive(arg0.helpBtn, true)

	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.selectedMin = defaultValue(var0.selectedMin, 1)
	arg0.selectedMax = defaultValue(var0.selectedMax, pg.gameset.equip_select_limit.key_value or 0)
	arg0.selectedIds = Clone(var0.selectedIds or {})
	arg0.checkEquipment = var0.onEquipment or function(arg0)
		return true
	end
	arg0.onSelected = var0.onSelected or function()
		warning("not implemented.")
	end

	setActive(arg0:findTF("dispos", arg0.bottomBack), false)
	setActive(arg0:findTF("adapt/select_panel", arg0.topItems), false)

	arg0.selectTransformPanel = arg0:findTF("adapt/select_transform_panel", arg0.topItems)
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setActive(arg0.bottomBack, false)
	setActive(arg0.selectTransformPanel, true)
	setActive(arg0.indexBtn, false)
	setActive(arg0.sortBtn, false)
	setActive(arg0.equipSkinFilteBtn, false)
	setActive(arg0.equipmentSkinBtn, false)
	setText(arg0.selectTransformPanel:Find("cancel_button/Image"), i18n("msgbox_text_cancel"))
	setText(arg0.selectTransformPanel:Find("confirm_button/Image"), i18n("msgbox_text_confirm"))
end

function var0.setSources(arg0, arg1)
	arg0.sourceVOs = arg1
end

function var0.OnMediatorRegister(arg0)
	arg0.warp = arg0.contextData.warp or StoreHouseConst.WARP_TO_WEAPON
	arg0.mode = arg0.contextData.mode or StoreHouseConst.OVERVIEW
	arg0.page = var2
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)

	arg0.equipmetItems = {}

	arg0:initEquipments()

	arg0.asc = arg0.contextData.asc or false

	if not arg0.contextData.sortData then
		arg0.contextData.sortData = var1.sort[1]
	end

	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}

	arg0:initSort()
	setActive(arg0.equipmentView, true)
	arg0:filterEquipment()

	arg0.equipmentRect.isStart = true

	arg0.equipmentRect:EndLayout()
	pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0.topItems, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
	setActive(arg0.sortImgAsc, arg0.asc)
	setActive(arg0.sortImgDec, not arg0.asc)

	if arg0.contextData.equipScrollPos then
		arg0:ScrollEquipPos(arg0.contextData.equipScrollPos.y)
	end

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_equipment.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.selectTransformPanel:Find("cancel_button"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.selectTransformPanel:Find("confirm_button"), function()
		local var0 = _.map(arg0.selectedIds, function(arg0)
			return arg0[1]
		end)

		if arg0.contextData.onConfirm(var0) then
			arg0:closeView()
		end
	end, SFX_PANEL)
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0.sortPanel) then
		triggerButton(arg0.sortPanel)

		return
	end

	triggerButton(arg0.backBtn)
end

function var0.initSort(arg0)
	onButton(arg0, arg0.decBtn, function()
		arg0.asc = not arg0.asc
		arg0.contextData.asc = arg0.asc

		arg0:filterEquipment()
	end)
end

function var0.initEquipments(arg0)
	arg0.isInitWeapons = true
	arg0.equipmentRect = arg0.equipmentView:GetComponent("LScrollRect")

	function arg0.equipmentRect.onInitItem(arg0)
		arg0:initEquipment(arg0)
	end

	arg0.equipmentRect.decelerationRate = 0.07

	function arg0.equipmentRect.onUpdateItem(arg0, arg1)
		arg0:updateEquipment(arg0, arg1)
	end

	function arg0.equipmentRect.onStart()
		arg0:updateSelected()
	end

	arg0.equipmentRect:ScrollTo(0)
end

function var0.updateEquipmentCount(arg0, arg1)
	arg0.equipmentRect:SetTotalCount(arg1 or #arg0.loadEquipmentVOs, -1)
	setActive(arg0.listEmptyTF, (arg1 or #arg0.loadEquipmentVOs) <= 0)
	setText(arg0.listEmptyTxt, i18n("list_empty_tip_storehouseui_equip"))
	Canvas.ForceUpdateCanvases()
end

function var0.ScrollEquipPos(arg0, arg1)
	local var0 = arg0.equipmentView:Find("equipment_grid"):GetComponent(typeof(GridLayoutGroup))
	local var1 = (var0.cellSize.y + var0.spacing.y) * math.ceil(#arg0.loadEquipmentVOs / var0.constraintCount) - var0.spacing.y + arg0.equipmentRect.paddingFront + arg0.equipmentRect.paddingEnd
	local var2 = var1 - arg0.equipmentView.rect.height

	var2 = var2 > 0 and var2 or var1

	local var3 = (arg1 - arg0.equipmentView.rect.height * 0.5) / var2

	arg0.equipmentRect:ScrollTo(var3)
end

function var0.onUIAnimEnd(arg0, arg1)
	arg0.onAnimDoneCallback = arg1
end

function var0.ExecuteAnimDoneCallback(arg0)
	if arg0.onAnimDoneCallback then
		arg0.onAnimDoneCallback()

		arg0.onAnimDoneCallback = nil
	end
end

function var0.selectCount(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.selectedIds) do
		var0 = var0 + iter1[2]
	end

	return var0
end

function var0.SelectTransformEquip(arg0, arg1, arg2)
	local var0 = false

	if arg0.selectedIds[1] and EquipmentTransformUtil.SameDrop(arg0.selectedIds[1][1], arg1) then
		var0 = true
	end

	if not var0 then
		if arg0.contextData.onSelect and not arg0.contextData.onSelect(arg1) then
			return
		end

		table.clean(arg0.selectedIds)
		table.insert(arg0.selectedIds, {
			arg1,
			1
		})
	else
		table.clean(arg0.selectedIds)
	end

	arg0:updateSelected()
end

function var0.initEquipment(arg0, arg1)
	local var0 = EquipmentItemTransformVer.New(arg1)

	onButton(arg0, var0.go, function()
		if var0.sourceVO == nil then
			return
		end

		arg0:SelectTransformEquip(var0.sourceVO, var0.sourceVO.count)
	end, SFX_PANEL)

	arg0.equipmetItems[arg1] = var0
end

function var0.updateEquipment(arg0, arg1, arg2)
	local var0 = arg0.equipmetItems[arg2]

	if not var0 then
		arg0:initEquipment(arg2)

		var0 = arg0.equipmetItems[arg2]
	end

	local var1 = arg0.loadEquipmentVOs[arg1 + 1]

	var0:update(var1)

	local var2 = false
	local var3 = 0

	if var1 then
		for iter0, iter1 in ipairs(arg0.selectedIds) do
			if EquipmentTransformUtil.SameDrop(var1, iter1[1]) then
				var2 = true
				var3 = iter1[2]

				break
			end
		end
	end

	var0:updateSelected(var2, var3)
end

function var0.updateSelected(arg0)
	for iter0, iter1 in pairs(arg0.equipmetItems) do
		if iter1.sourceVO then
			local var0 = false
			local var1 = 0

			for iter2, iter3 in pairs(arg0.selectedIds) do
				if EquipmentTransformUtil.SameDrop(iter1.sourceVO, iter3[1]) then
					var0 = true
					var1 = iter3[2]

					break
				end
			end

			iter1:updateSelected(var0, var1)
		end
	end
end

function var0.filterEquipment(arg0)
	local var0 = arg0.contextData.sortData
	local var1 = arg0.sourceVOs

	arg0.loadEquipmentVOs = {}

	for iter0, iter1 in pairs(var1) do
		if iter1.type ~= DROP_TYPE_EQUIP or iter1.template.count > 0 then
			table.insert(arg0.loadEquipmentVOs, iter1)
		end
	end

	if var0 then
		local var2 = arg0.asc
		local var3 = {
			function(arg0)
				return arg0.type
			end,
			function(arg0)
				return arg0.template.shipId or -1
			end
		}
		local var4 = table.mergeArray(var3, underscore.map(var1.sortFunc(var0, var2), function(arg0)
			return function(arg0)
				return arg0(arg0.template)
			end
		end))

		table.sort(arg0.loadEquipmentVOs, CompareFuncs(var4))
	end

	arg0:updateSelected()
	arg0:updateEquipmentCount()
	setActive(arg0.sortImgAsc, arg0.asc)
	setActive(arg0.sortImgDec, not arg0.asc)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.topItems, arg0._tf)
end

return var0
