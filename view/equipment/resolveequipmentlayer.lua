local var0_0 = class("ResolveEquipmentLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ResolveEquipmentUI"
end

function var0_0.setPlayer(arg0_2, arg1_2)
	arg0_2.player = arg1_2
end

function var0_0.setEquipments(arg0_3, arg1_3)
	arg0_3.equipmentVOs = arg1_3

	arg0_3:setEquipmentByIds(arg1_3)
end

function var0_0.setEquipmentByIds(arg0_4, arg1_4)
	arg0_4.equipmentVOByIds = {}

	for iter0_4, iter1_4 in ipairs(arg1_4) do
		arg0_4.equipmentVOByIds[iter1_4.id] = iter1_4
	end
end

function var0_0.init(arg0_5)
	arg0_5.mainPanel = arg0_5:findTF("main")

	setActive(arg0_5.mainPanel, true)

	arg0_5.viewRect = arg0_5:findTF("main/frame/view"):GetComponent("LScrollRect")
	arg0_5.backBtn = arg0_5:findTF("main/top/btnBack")
	arg0_5.cancelBtn = arg0_5:findTF("main/cancel_btn")
	arg0_5.okBtn = arg0_5:findTF("main/ok_btn")

	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false, {})

	arg0_5.selectedIds = {}
	arg0_5.selecteAllTF = arg0_5:findTF("main/all_toggle")
	arg0_5.selecteAllToggle = arg0_5.selecteAllTF:GetComponent(typeof(Toggle))
	arg0_5.destroyConfirm = arg0_5:findTF("destroy_confirm")
	arg0_5.destroyBonusList = arg0_5.destroyConfirm:Find("got/scrollview/list")
	arg0_5.destroyBonusItem = arg0_5.destroyConfirm:Find("got/scrollview/item")

	setActive(arg0_5.destroyConfirm, false)
	setActive(arg0_5.destroyBonusItem, false)

	arg0_5.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0_5._tf, arg0_5.event)
end

function var0_0.didEnter(arg0_6)
	arg0_6:initEquipments()
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.cancelBtn, function()
		arg0_6:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.okBtn, function()
		local var0_9 = {}

		if underscore.any(arg0_6.selectedIds, function(arg0_10)
			local var0_10 = arg0_6.equipmentVOByIds[arg0_10[1]]

			return var0_10:getConfig("rarity") >= 4 or var0_10:getConfig("level") > 1
		end) then
			table.insert(var0_9, function(arg0_11)
				arg0_6.equipDestroyConfirmWindow:Load()
				arg0_6.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0_6.selectedIds, function(arg0_12)
					return setmetatable({
						count = arg0_12[2]
					}, {
						__index = arg0_6.equipmentVOByIds[arg0_12[1]]
					})
				end), arg0_11)
			end)
		end

		seriesAsync(var0_9, function()
			if #arg0_6.selectedIds <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("err_resloveequip_nochoice"))

				return
			end

			setActive(arg0_6.mainPanel, false)
			setActive(arg0_6.destroyConfirm, true)
			arg0_6:displayDestroyBonus()
		end)
	end, SFX_CONFIRM)
	onButton(arg0_6, findTF(arg0_6.destroyConfirm, "actions/cancel_button"), function()
		setActive(arg0_6.destroyConfirm, false)
		setActive(arg0_6.mainPanel, true)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_6.destroyConfirm, arg0_6._tf)
	end, SFX_CANCEL)
	onButton(arg0_6, findTF(arg0_6.destroyConfirm, "actions/destroy_button"), function()
		local var0_15 = {}

		seriesAsync(var0_15, function()
			arg0_6:emit(ResolveEquipmentMediator.ON_RESOLVE, arg0_6.selectedIds)
		end)
	end, SFX_UI_EQUIPMENT_RESOLVE)
	onToggle(arg0_6, arg0_6.selecteAllTF, function(arg0_17)
		if arg0_6.isManual then
			return
		end

		if arg0_17 then
			arg0_6:selecteAllEquips()
		else
			arg0_6:unselecteAllEquips()
		end
	end, SFX_PANEL)
end

function var0_0.OnResolveEquipDone(arg0_18)
	setActive(arg0_18.destroyConfirm, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_18._tf)
	setActive(arg0_18.mainPanel, false)
	arg0_18:unselecteAllEquips()
end

function var0_0.onBackPressed(arg0_19)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_19.destroyConfirm) then
		triggerButton(findTF(arg0_19.destroyConfirm, "actions/cancel_button"))
	elseif arg0_19.equipDestroyConfirmWindow:isShowing() then
		arg0_19.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0_19.cancelBtn)
	end
end

function var0_0.selectedLowRarityEquipment(arg0_20)
	arg0_20.selectedIds = {}

	for iter0_20, iter1_20 in ipairs(arg0_20.equipmentVOs) do
		if iter1_20:getConfig("level") <= 1 and iter1_20:getConfig("rarity") < 4 then
			arg0_20:selectEquip(iter1_20, iter1_20.count)
		end
	end

	arg0_20:updateSelected()
end

function var0_0.selecteAllEquips(arg0_21)
	arg0_21.selectedIds = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.equipmentVOs) do
		arg0_21:selectEquip(iter1_21, iter1_21.count)
	end

	arg0_21:updateSelected()
end

function var0_0.unselecteAllEquips(arg0_22)
	arg0_22.selectedIds = {}

	arg0_22:updateSelected()
end

function var0_0.displayDestroyBonus(arg0_23)
	local var0_23 = {}
	local var1_23 = 0

	for iter0_23, iter1_23 in ipairs(arg0_23.selectedIds) do
		if Equipment.CanInBag(iter1_23[1]) then
			local var2_23 = Equipment.getConfigData(iter1_23[1])
			local var3_23 = var2_23.destory_item or {}

			var1_23 = var1_23 + (var2_23.destory_gold or 0) * iter1_23[2]

			for iter2_23, iter3_23 in ipairs(var3_23) do
				local var4_23 = false

				for iter4_23, iter5_23 in ipairs(var0_23) do
					if iter3_23[1] == var0_23[iter4_23].id then
						var0_23[iter4_23].count = var0_23[iter4_23].count + iter3_23[2] * iter1_23[2]
						var4_23 = true

						break
					end
				end

				if not var4_23 then
					table.insert(var0_23, {
						type = DROP_TYPE_ITEM,
						id = iter3_23[1],
						count = iter3_23[2] * iter1_23[2]
					})
				end
			end
		end
	end

	if var1_23 > 0 then
		table.insert(var0_23, {
			id = 1,
			type = DROP_TYPE_RESOURCE,
			count = var1_23
		})
	end

	for iter6_23 = #var0_23, arg0_23.destroyBonusList.childCount - 1 do
		Destroy(arg0_23.destroyBonusList:GetChild(iter6_23))
	end

	for iter7_23 = arg0_23.destroyBonusList.childCount, #var0_23 - 1 do
		cloneTplTo(arg0_23.destroyBonusItem, arg0_23.destroyBonusList)
	end

	for iter8_23 = 1, #var0_23 do
		local var5_23 = arg0_23.destroyBonusList:GetChild(iter8_23 - 1)
		local var6_23 = var0_23[iter8_23]

		if var6_23.type == DROP_TYPE_SHIP then
			arg0_23.hasShip = true
		end

		local var7_23 = var5_23:Find("icon_bg/icon/icon")

		GetComponent(var5_23:Find("icon_bg/icon"), typeof(Image)).enabled = true

		if not IsNil(var7_23) then
			setActive(var7_23, false)
		end

		updateDrop(var5_23, var6_23)

		local var8_23, var9_23 = contentWrap(var6_23:getConfig("name"), 10, 2)

		if var8_23 then
			var9_23 = var9_23 .. "..."
		end

		setText(var5_23:Find("name"), var9_23)
		onButton(arg0_23, var5_23, function()
			if var6_23.type == DROP_TYPE_RESOURCE or var6_23.type == DROP_TYPE_ITEM then
				arg0_23:emit(var0_0.ON_ITEM, var6_23:getConfig("id"))
			elseif var6_23.type == DROP_TYPE_EQUIP then
				arg0_23:emit(var0_0.ON_EQUIPMENT, {
					equipmentId = var6_23:getConfig("id"),
					type = EquipmentInfoMediator.TYPE_DISPLAY
				})
			end
		end, SFX_PANEL)
	end
end

function var0_0.initEquipments(arg0_25)
	function arg0_25.viewRect.onInitItem(arg0_26)
		arg0_25:onInitItem(arg0_26)
	end

	function arg0_25.viewRect.onUpdateItem(arg0_27, arg1_27)
		arg0_25:onUpdateItem(arg0_27, arg1_27)
	end

	function arg0_25.viewRect.onStart()
		arg0_25:selectedLowRarityEquipment()
	end

	arg0_25.cards = {}

	arg0_25:filterEquipments()
end

function var0_0.filterEquipments(arg0_29)
	table.sort(arg0_29.equipmentVOs, CompareFuncs({
		function(arg0_30)
			return -arg0_30:getConfig("rarity")
		end,
		function(arg0_31)
			return arg0_31.id
		end
	}))
	arg0_29.viewRect:SetTotalCount(#arg0_29.equipmentVOs, -1)
end

function var0_0.onInitItem(arg0_32, arg1_32)
	local var0_32 = EquipmentItem.New(arg1_32)

	onButton(arg0_32, var0_32.go, function()
		arg0_32:selectEquip(var0_32.equipmentVO, var0_32.equipmentVO.count)
	end, SFX_PANEL)
	onButton(arg0_32, var0_32.reduceBtn, function()
		arg0_32:selectEquip(var0_32.equipmentVO, 1)
	end, SFX_PANEL)

	arg0_32.cards[arg1_32] = var0_32
end

function var0_0.onUpdateItem(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35.cards[arg2_35]

	if not var0_35 then
		arg0_35:onInitItem(arg2_35)

		var0_35 = arg0_35.cards[arg2_35]
	end

	local var1_35 = arg0_35.equipmentVOs[arg1_35 + 1]

	var0_35:update(var1_35, true)
end

function var0_0.isSelectedAll(arg0_36)
	for iter0_36, iter1_36 in pairs(arg0_36.equipmentVOByIds) do
		local var0_36 = false

		for iter2_36, iter3_36 in pairs(arg0_36.selectedIds) do
			if iter3_36[1] == iter1_36.id and iter1_36.count == iter3_36[2] then
				var0_36 = true
			end
		end

		if var0_36 == false then
			return false
		end
	end

	return true
end

function var0_0.selectEquip(arg0_37, arg1_37, arg2_37)
	if not arg0_37:checkDestroyGold(arg1_37, arg2_37) then
		return
	end

	if arg1_37:isImportance() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("retire_importantequipment_tips"))

		return
	end

	local var0_37 = false
	local var1_37
	local var2_37 = 0

	for iter0_37, iter1_37 in pairs(arg0_37.selectedIds) do
		if iter1_37[1] == arg1_37.id then
			var0_37 = true
			var1_37 = iter0_37
			var2_37 = iter1_37[2]

			break
		end
	end

	if not var0_37 then
		table.insert(arg0_37.selectedIds, {
			arg1_37.id,
			arg2_37
		})
	elseif var2_37 - arg2_37 > 0 then
		arg0_37.selectedIds[var1_37][2] = var2_37 - arg2_37
	else
		table.remove(arg0_37.selectedIds, var1_37)
	end

	arg0_37:updateSelected()

	local var3_37 = arg0_37:isSelectedAll()

	arg0_37.isManual = true

	triggerToggle(arg0_37.selecteAllTF, var3_37)

	arg0_37.isManual = nil
end

function var0_0.updateSelected(arg0_38)
	for iter0_38, iter1_38 in pairs(arg0_38.cards) do
		if iter1_38.equipmentVO then
			local var0_38 = false
			local var1_38 = 0

			for iter2_38, iter3_38 in pairs(arg0_38.selectedIds) do
				if iter1_38.equipmentVO.id == iter3_38[1] then
					var0_38 = true
					var1_38 = iter3_38[2]

					break
				end
			end

			iter1_38:updateSelected(var0_38, var1_38)
		end
	end
end

function var0_0.checkDestroyGold(arg0_39, arg1_39, arg2_39)
	local var0_39 = 0
	local var1_39 = false

	for iter0_39, iter1_39 in pairs(arg0_39.selectedIds) do
		local var2_39 = iter1_39[2]

		if Equipment.CanInBag(iter1_39[1]) then
			var0_39 = var0_39 + (Equipment.getConfigData(iter1_39[1]).destory_gold or 0) * var2_39
		end

		if arg1_39 and iter1_39[1] == arg1_39.configId then
			var1_39 = true
		end
	end

	if not var1_39 and arg1_39 and arg2_39 > 0 then
		var0_39 = var0_39 + (arg1_39:getConfig("destory_gold") or 0) * arg2_39
	end

	if arg0_39.player:GoldMax(var0_39) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.willExit(arg0_40)
	arg0_40.equipDestroyConfirmWindow:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_40._tf, pg.UIMgr.GetInstance().UIMain)
end

return var0_0
