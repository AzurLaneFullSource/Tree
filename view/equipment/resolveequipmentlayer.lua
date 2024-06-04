local var0 = class("ResolveEquipmentLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "ResolveEquipmentUI"
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setEquipments(arg0, arg1)
	arg0.equipmentVOs = arg1

	arg0:setEquipmentByIds(arg1)
end

function var0.setEquipmentByIds(arg0, arg1)
	arg0.equipmentVOByIds = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.equipmentVOByIds[iter1.id] = iter1
	end
end

function var0.init(arg0)
	arg0.mainPanel = arg0:findTF("main")

	setActive(arg0.mainPanel, true)

	arg0.viewRect = arg0:findTF("main/frame/view"):GetComponent("LScrollRect")
	arg0.backBtn = arg0:findTF("main/top/btnBack")
	arg0.cancelBtn = arg0:findTF("main/cancel_btn")
	arg0.okBtn = arg0:findTF("main/ok_btn")

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {})

	arg0.selectedIds = {}
	arg0.selecteAllTF = arg0:findTF("main/all_toggle")
	arg0.selecteAllToggle = arg0.selecteAllTF:GetComponent(typeof(Toggle))
	arg0.destroyConfirm = arg0:findTF("destroy_confirm")
	arg0.destroyBonusList = arg0.destroyConfirm:Find("got/scrollview/list")
	arg0.destroyBonusItem = arg0.destroyConfirm:Find("got/scrollview/item")

	setActive(arg0.destroyConfirm, false)
	setActive(arg0.destroyBonusItem, false)

	arg0.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	arg0:initEquipments()
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.okBtn, function()
		local var0 = {}

		if underscore.any(arg0.selectedIds, function(arg0)
			local var0 = arg0.equipmentVOByIds[arg0[1]]

			return var0:getConfig("rarity") >= 4 or var0:getConfig("level") > 1
		end) then
			table.insert(var0, function(arg0)
				arg0.equipDestroyConfirmWindow:Load()
				arg0.equipDestroyConfirmWindow:ActionInvoke("Show", underscore.map(arg0.selectedIds, function(arg0)
					return setmetatable({
						count = arg0[2]
					}, {
						__index = arg0.equipmentVOByIds[arg0[1]]
					})
				end), arg0)
			end)
		end

		seriesAsync(var0, function()
			if #arg0.selectedIds <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("err_resloveequip_nochoice"))

				return
			end

			setActive(arg0.mainPanel, false)
			setActive(arg0.destroyConfirm, true)
			arg0:displayDestroyBonus()
		end)
	end, SFX_CONFIRM)
	onButton(arg0, findTF(arg0.destroyConfirm, "actions/cancel_button"), function()
		setActive(arg0.destroyConfirm, false)
		setActive(arg0.mainPanel, true)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.destroyConfirm, arg0._tf)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.destroyConfirm, "actions/destroy_button"), function()
		local var0 = {}

		seriesAsync(var0, function()
			arg0:emit(ResolveEquipmentMediator.ON_RESOLVE, arg0.selectedIds)
		end)
	end, SFX_UI_EQUIPMENT_RESOLVE)
	onToggle(arg0, arg0.selecteAllTF, function(arg0)
		if arg0.isManual then
			return
		end

		if arg0 then
			arg0:selecteAllEquips()
		else
			arg0:unselecteAllEquips()
		end
	end, SFX_PANEL)
end

function var0.OnResolveEquipDone(arg0)
	setActive(arg0.destroyConfirm, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	setActive(arg0.mainPanel, false)
	arg0:unselecteAllEquips()
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0.destroyConfirm) then
		triggerButton(findTF(arg0.destroyConfirm, "actions/cancel_button"))
	elseif arg0.equipDestroyConfirmWindow:isShowing() then
		arg0.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0.cancelBtn)
	end
end

function var0.selectedLowRarityEquipment(arg0)
	arg0.selectedIds = {}

	for iter0, iter1 in ipairs(arg0.equipmentVOs) do
		if iter1:getConfig("level") <= 1 and iter1:getConfig("rarity") < 4 then
			arg0:selectEquip(iter1, iter1.count)
		end
	end

	arg0:updateSelected()
end

function var0.selecteAllEquips(arg0)
	arg0.selectedIds = {}

	for iter0, iter1 in ipairs(arg0.equipmentVOs) do
		arg0:selectEquip(iter1, iter1.count)
	end

	arg0:updateSelected()
end

function var0.unselecteAllEquips(arg0)
	arg0.selectedIds = {}

	arg0:updateSelected()
end

function var0.displayDestroyBonus(arg0)
	local var0 = {}
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.selectedIds) do
		if Equipment.CanInBag(iter1[1]) then
			local var2 = Equipment.getConfigData(iter1[1])
			local var3 = var2.destory_item or {}

			var1 = var1 + (var2.destory_gold or 0) * iter1[2]

			for iter2, iter3 in ipairs(var3) do
				local var4 = false

				for iter4, iter5 in ipairs(var0) do
					if iter3[1] == var0[iter4].id then
						var0[iter4].count = var0[iter4].count + iter3[2] * iter1[2]
						var4 = true

						break
					end
				end

				if not var4 then
					table.insert(var0, {
						type = DROP_TYPE_ITEM,
						id = iter3[1],
						count = iter3[2] * iter1[2]
					})
				end
			end
		end
	end

	if var1 > 0 then
		table.insert(var0, {
			id = 1,
			type = DROP_TYPE_RESOURCE,
			count = var1
		})
	end

	for iter6 = #var0, arg0.destroyBonusList.childCount - 1 do
		Destroy(arg0.destroyBonusList:GetChild(iter6))
	end

	for iter7 = arg0.destroyBonusList.childCount, #var0 - 1 do
		cloneTplTo(arg0.destroyBonusItem, arg0.destroyBonusList)
	end

	for iter8 = 1, #var0 do
		local var5 = arg0.destroyBonusList:GetChild(iter8 - 1)
		local var6 = var0[iter8]

		if var6.type == DROP_TYPE_SHIP then
			arg0.hasShip = true
		end

		local var7 = var5:Find("icon_bg/icon/icon")

		GetComponent(var5:Find("icon_bg/icon"), typeof(Image)).enabled = true

		if not IsNil(var7) then
			setActive(var7, false)
		end

		updateDrop(var5, var6)

		local var8, var9 = contentWrap(var6:getConfig("name"), 10, 2)

		if var8 then
			var9 = var9 .. "..."
		end

		setText(var5:Find("name"), var9)
		onButton(arg0, var5, function()
			if var6.type == DROP_TYPE_RESOURCE or var6.type == DROP_TYPE_ITEM then
				arg0:emit(var0.ON_ITEM, var6:getConfig("id"))
			elseif var6.type == DROP_TYPE_EQUIP then
				arg0:emit(var0.ON_EQUIPMENT, {
					equipmentId = var6:getConfig("id"),
					type = EquipmentInfoMediator.TYPE_DISPLAY
				})
			end
		end, SFX_PANEL)
	end
end

function var0.initEquipments(arg0)
	function arg0.viewRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.viewRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	function arg0.viewRect.onStart()
		arg0:selectedLowRarityEquipment()
	end

	arg0.cards = {}

	arg0:filterEquipments()
end

function var0.filterEquipments(arg0)
	table.sort(arg0.equipmentVOs, CompareFuncs({
		function(arg0)
			return -arg0:getConfig("rarity")
		end,
		function(arg0)
			return arg0.id
		end
	}))
	arg0.viewRect:SetTotalCount(#arg0.equipmentVOs, -1)
end

function var0.onInitItem(arg0, arg1)
	local var0 = EquipmentItem.New(arg1)

	onButton(arg0, var0.go, function()
		arg0:selectEquip(var0.equipmentVO, var0.equipmentVO.count)
	end, SFX_PANEL)
	onButton(arg0, var0.reduceBtn, function()
		arg0:selectEquip(var0.equipmentVO, 1)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.equipmentVOs[arg1 + 1]

	var0:update(var1, true)
end

function var0.isSelectedAll(arg0)
	for iter0, iter1 in pairs(arg0.equipmentVOByIds) do
		local var0 = false

		for iter2, iter3 in pairs(arg0.selectedIds) do
			if iter3[1] == iter1.id and iter1.count == iter3[2] then
				var0 = true
			end
		end

		if var0 == false then
			return false
		end
	end

	return true
end

function var0.selectEquip(arg0, arg1, arg2)
	if not arg0:checkDestroyGold(arg1, arg2) then
		return
	end

	if arg1:isImportance() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("retire_importantequipment_tips"))

		return
	end

	local var0 = false
	local var1
	local var2 = 0

	for iter0, iter1 in pairs(arg0.selectedIds) do
		if iter1[1] == arg1.id then
			var0 = true
			var1 = iter0
			var2 = iter1[2]

			break
		end
	end

	if not var0 then
		table.insert(arg0.selectedIds, {
			arg1.id,
			arg2
		})
	elseif var2 - arg2 > 0 then
		arg0.selectedIds[var1][2] = var2 - arg2
	else
		table.remove(arg0.selectedIds, var1)
	end

	arg0:updateSelected()

	local var3 = arg0:isSelectedAll()

	arg0.isManual = true

	triggerToggle(arg0.selecteAllTF, var3)

	arg0.isManual = nil
end

function var0.updateSelected(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.equipmentVO then
			local var0 = false
			local var1 = 0

			for iter2, iter3 in pairs(arg0.selectedIds) do
				if iter1.equipmentVO.id == iter3[1] then
					var0 = true
					var1 = iter3[2]

					break
				end
			end

			iter1:updateSelected(var0, var1)
		end
	end
end

function var0.checkDestroyGold(arg0, arg1, arg2)
	local var0 = 0
	local var1 = false

	for iter0, iter1 in pairs(arg0.selectedIds) do
		local var2 = iter1[2]

		if Equipment.CanInBag(iter1[1]) then
			var0 = var0 + (Equipment.getConfigData(iter1[1]).destory_gold or 0) * var2
		end

		if arg1 and iter1[1] == arg1.configId then
			var1 = true
		end
	end

	if not var1 and arg1 and arg2 > 0 then
		var0 = var0 + (arg1:getConfig("destory_gold") or 0) * arg2
	end

	if arg0.player:GoldMax(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0.willExit(arg0)
	arg0.equipDestroyConfirmWindow:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
end

return var0
