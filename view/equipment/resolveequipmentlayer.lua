local var0_0 = class("ResolveEquipmentLayer", import("..base.BaseUI"))
local var1_0 = "resolve_equipment_option_all"
local var2_0 = {
	SR = "SR",
	ALL = "ALL",
	R = "R",
	SSR = "SSR",
	N = "N"
}
local var3_0 = {
	N = "N",
	SR = "SR",
	R = "R",
	SSR = "SSR"
}
local var4_0 = {
	[var2_0.N] = {
		1,
		2
	},
	[var2_0.R] = {
		3
	},
	[var2_0.SR] = {
		4
	},
	[var2_0.SSR] = {
		5
	},
	[var2_0.ALL] = {
		1,
		2,
		3,
		4,
		5
	}
}
local var5_0 = {
	ALL = 3,
	PART = 2,
	GREY = 0,
	NONE = 1
}

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
	setText(arg0_5.mainPanel:Find("top/title_list/infomation/title"), i18n("title_info"))
	setText(arg0_5.mainPanel:Find("title/Text"), i18n("resolve_equip_tip"))

	arg0_5.viewRect = arg0_5:findTF("main/frame/view"):GetComponent("LScrollRect")
	arg0_5.backBtn = arg0_5:findTF("main/top/btnBack")
	arg0_5.cancelBtn = arg0_5:findTF("main/cancel_btn")

	setText(arg0_5.cancelBtn:Find("Image"), i18n("text_cancel"))

	arg0_5.okBtn = arg0_5:findTF("main/ok_btn")

	setText(arg0_5.okBtn:Find("Image"), i18n("text_confirm"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false, {})

	arg0_5.selectedIds = {}
	arg0_5.selectOptions = arg0_5:findTF("main/options")

	setText(arg0_5.selectOptions:Find("ALL/Label"), i18n("word_equipment_all"))

	arg0_5.optionStatus = {}
	arg0_5.destroyConfirm = arg0_5:findTF("destroy_confirm")
	arg0_5.destroyBonusList = arg0_5.destroyConfirm:Find("got/scrollview/list")
	arg0_5.destroyBonusItem = arg0_5.destroyConfirm:Find("got/scrollview/item")

	setActive(arg0_5.destroyConfirm, false)
	setActive(arg0_5.destroyBonusItem, false)
	setText(arg0_5.destroyConfirm:Find("got/title"), i18n("resolve_equip_title"))
	setText(arg0_5.destroyConfirm:Find("actions/cancel_button/Image"), i18n("text_cancel"))
	setText(arg0_5.destroyConfirm:Find("actions/destroy_button/Image"), i18n("text_confirm"))

	arg0_5.equipDestroyConfirmWindow = EquipDestoryConfirmWindow.New(arg0_5._tf, arg0_5.event)
end

function var0_0.didEnter(arg0_6)
	arg0_6:initEquipments()
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:SureExit()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.cancelBtn, function()
		arg0_6:SureExit()
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
	eachChild(arg0_6.selectOptions, function(arg0_17)
		onButton(arg0_6, arg0_17, function()
			local var0_18 = arg0_17.name
			local var1_18 = arg0_6.optionStatus[var0_18]
			local var2_18 = var4_0[var0_18]

			switch(var1_18, {
				[var5_0.GREY] = function()
					return
				end,
				[var5_0.NONE] = function()
					arg0_6:selAllEquipsByRaritys(var2_18)
				end,
				[var5_0.PART] = function()
					arg0_6:unselAllEquipsByRaritys(var2_18)
				end,
				[var5_0.ALL] = function()
					arg0_6:unselAllEquipsByRaritys(var2_18)
				end
			})
		end, SFX_CANCEL)
	end)
end

function var0_0.HideDestroyCondirm(arg0_23)
	setActive(arg0_23.destroyConfirm, false)
end

function var0_0.OnResolveEquipDone(arg0_24)
	for iter0_24, iter1_24 in pairs(var3_0) do
		local var0_24 = arg0_24.optionStatus[iter1_24]

		if var0_24 == var5_0.ALL then
			arg0_24:SetLocalDataByOption(iter1_24, 1)
		elseif var0_24 == var5_0.NONE then
			arg0_24:SetLocalDataByOption(iter1_24, 0)
		end
	end

	if arg0_24.optionStatus[var2_0.ALL] == var5_0.ALL then
		arg0_24:emit(var0_0.ON_CLOSE)
	else
		setActive(arg0_24.mainPanel, true)

		local function var1_24(arg0_25)
			for iter0_25, iter1_25 in ipairs(arg0_24.selectedIds) do
				if iter1_25[1] == arg0_25 then
					return iter1_25[2]
				end
			end

			return 0
		end

		local var2_24 = {}

		for iter2_24, iter3_24 in ipairs(arg0_24.equipmentVOs) do
			local var3_24 = Clone(iter3_24)

			if iter3_24.count - var1_24(iter3_24.id) > 0 then
				table.insert(var2_24, var3_24)
			end
		end

		arg0_24:setEquipments(var2_24)
		arg0_24.viewRect:SetTotalCount(#arg0_24.equipmentVOs, -1)
		arg0_24:selectedLocalRecordEquipment()
	end
end

function var0_0.onBackPressed(arg0_26)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_26.destroyConfirm) then
		triggerButton(findTF(arg0_26.destroyConfirm, "actions/cancel_button"))
	elseif arg0_26.equipDestroyConfirmWindow:isShowing() then
		arg0_26.equipDestroyConfirmWindow:Hide()
	else
		triggerButton(arg0_26.cancelBtn)
	end
end

function var0_0.selectedLocalRecordEquipment(arg0_27)
	arg0_27.selectedIds = {}

	for iter0_27, iter1_27 in pairs(var3_0) do
		if arg0_27:GetLocalDataByOption(iter1_27) == 1 then
			local var0_27 = var4_0[iter1_27]

			arg0_27:selAllEquipsByRaritys(var0_27)
		end
	end

	arg0_27:updateSelected()
end

function var0_0.GetLocalDataByOption(arg0_28, arg1_28)
	local var0_28 = arg0_28.player.id .. var1_0 .. arg1_28

	if (arg1_28 == var2_0.N or arg1_28 == var2_0.R) and not PlayerPrefs.HasKey(var0_28) then
		arg0_28:SetLocalDataByOption(arg1_28, 1)
	end

	return PlayerPrefs.GetInt(arg0_28.player.id .. var1_0 .. arg1_28, 0)
end

function var0_0.SetLocalDataByOption(arg0_29, arg1_29, arg2_29)
	PlayerPrefs.SetInt(arg0_29.player.id .. var1_0 .. arg1_29, arg2_29)
	PlayerPrefs.Save()
end

function var0_0.selAllEquipsByRaritys(arg0_30, arg1_30)
	for iter0_30, iter1_30 in ipairs(arg0_30.equipmentVOs) do
		local var0_30 = iter1_30:getConfig("rarity")

		if table.contains(arg1_30, var0_30) then
			arg0_30:selectEquip(iter1_30, iter1_30.count)
		end
	end

	arg0_30:updateSelected()
end

function var0_0.unselAllEquipsByRaritys(arg0_31, arg1_31)
	arg0_31.selectedIds = underscore.select(arg0_31.selectedIds, function(arg0_32)
		local var0_32 = arg0_31.equipmentVOByIds[arg0_32[1]]:getConfig("rarity")

		return not table.contains(arg1_31, var0_32)
	end)

	arg0_31:updateSelected()
end

function var0_0.displayDestroyBonus(arg0_33)
	local var0_33 = {}
	local var1_33 = 0

	for iter0_33, iter1_33 in ipairs(arg0_33.selectedIds) do
		if Equipment.CanInBag(iter1_33[1]) then
			local var2_33 = Equipment.getConfigData(iter1_33[1])
			local var3_33 = var2_33.destory_item or {}

			var1_33 = var1_33 + (var2_33.destory_gold or 0) * iter1_33[2]

			for iter2_33, iter3_33 in ipairs(var3_33) do
				local var4_33 = false

				for iter4_33, iter5_33 in ipairs(var0_33) do
					if iter3_33[1] == var0_33[iter4_33].id then
						var0_33[iter4_33].count = var0_33[iter4_33].count + iter3_33[2] * iter1_33[2]
						var4_33 = true

						break
					end
				end

				if not var4_33 then
					table.insert(var0_33, {
						type = DROP_TYPE_ITEM,
						id = iter3_33[1],
						count = iter3_33[2] * iter1_33[2]
					})
				end
			end
		end
	end

	if var1_33 > 0 then
		table.insert(var0_33, {
			id = 1,
			type = DROP_TYPE_RESOURCE,
			count = var1_33
		})
	end

	for iter6_33 = #var0_33, arg0_33.destroyBonusList.childCount - 1 do
		Destroy(arg0_33.destroyBonusList:GetChild(iter6_33))
	end

	for iter7_33 = arg0_33.destroyBonusList.childCount, #var0_33 - 1 do
		cloneTplTo(arg0_33.destroyBonusItem, arg0_33.destroyBonusList)
	end

	for iter8_33 = 1, #var0_33 do
		local var5_33 = arg0_33.destroyBonusList:GetChild(iter8_33 - 1)
		local var6_33 = var0_33[iter8_33]

		if var6_33.type == DROP_TYPE_SHIP then
			arg0_33.hasShip = true
		end

		local var7_33 = var5_33:Find("icon_bg/icon/icon")

		GetComponent(var5_33:Find("icon_bg/icon"), typeof(Image)).enabled = true

		if not IsNil(var7_33) then
			setActive(var7_33, false)
		end

		updateDrop(var5_33, var6_33)

		local var8_33, var9_33 = contentWrap(var6_33:getConfig("name"), 10, 2)

		if var8_33 then
			var9_33 = var9_33 .. "..."
		end

		setText(var5_33:Find("name"), var9_33)
		onButton(arg0_33, var5_33, function()
			if var6_33.type == DROP_TYPE_RESOURCE or var6_33.type == DROP_TYPE_ITEM then
				arg0_33:emit(var0_0.ON_ITEM, var6_33:getConfig("id"))
			elseif var6_33.type == DROP_TYPE_EQUIP then
				arg0_33:emit(var0_0.ON_EQUIPMENT, {
					equipmentId = var6_33:getConfig("id"),
					type = EquipmentInfoMediator.TYPE_DISPLAY
				})
			end
		end, SFX_PANEL)
	end
end

function var0_0.initEquipments(arg0_35)
	function arg0_35.viewRect.onInitItem(arg0_36)
		arg0_35:onInitItem(arg0_36)
	end

	function arg0_35.viewRect.onUpdateItem(arg0_37, arg1_37)
		arg0_35:onUpdateItem(arg0_37, arg1_37)
	end

	function arg0_35.viewRect.onStart()
		arg0_35:selectedLocalRecordEquipment()
	end

	arg0_35.cards = {}

	arg0_35:filterEquipments()
end

function var0_0.filterEquipments(arg0_39)
	local var0_39 = underscore.select(arg0_39.equipmentVOs, function(arg0_40)
		return not arg0_40:isImportance()
	end)

	arg0_39:setEquipments(var0_39)
	table.sort(arg0_39.equipmentVOs, CompareFuncs({
		function(arg0_41)
			return -arg0_41:getConfig("rarity")
		end,
		function(arg0_42)
			return arg0_42.id
		end
	}))
	arg0_39.viewRect:SetTotalCount(#arg0_39.equipmentVOs, -1)
end

function var0_0.onInitItem(arg0_43, arg1_43)
	local var0_43 = EquipmentItem.New(arg1_43)

	onButton(arg0_43, var0_43.go, function()
		arg0_43:selectEquip(var0_43.equipmentVO, var0_43.equipmentVO.count)
	end, SFX_PANEL)
	onButton(arg0_43, var0_43.reduceBtn, function()
		arg0_43:selectEquip(var0_43.equipmentVO, 1)
	end, SFX_PANEL)

	arg0_43.cards[arg1_43] = var0_43
end

function var0_0.onUpdateItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46.cards[arg2_46]

	if not var0_46 then
		arg0_46:onInitItem(arg2_46)

		var0_46 = arg0_46.cards[arg2_46]
	end

	local var1_46 = arg0_46.equipmentVOs[arg1_46 + 1]

	var0_46:update(var1_46, true)

	local var2_46 = false
	local var3_46 = 0

	for iter0_46, iter1_46 in pairs(arg0_46.selectedIds) do
		if var0_46.equipmentVO.id == iter1_46[1] then
			var2_46 = true
			var3_46 = iter1_46[2]

			break
		end
	end

	var0_46:updateSelected(var2_46, var3_46)
end

function var0_0.isSelectedAll(arg0_47)
	for iter0_47, iter1_47 in pairs(arg0_47.equipmentVOByIds) do
		local var0_47 = false

		for iter2_47, iter3_47 in pairs(arg0_47.selectedIds) do
			if iter3_47[1] == iter1_47.id and iter1_47.count == iter3_47[2] then
				var0_47 = true
			end
		end

		if var0_47 == false then
			return false
		end
	end

	return true
end

function var0_0.selectEquip(arg0_48, arg1_48, arg2_48)
	if not arg0_48:checkDestroyGold(arg1_48, arg2_48) then
		return
	end

	if arg1_48:isImportance() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("retire_importantequipment_tips"))

		return
	end

	local var0_48 = false
	local var1_48
	local var2_48 = 0

	for iter0_48, iter1_48 in pairs(arg0_48.selectedIds) do
		if iter1_48[1] == arg1_48.id then
			var0_48 = true
			var1_48 = iter0_48
			var2_48 = iter1_48[2]

			break
		end
	end

	if not var0_48 then
		table.insert(arg0_48.selectedIds, {
			arg1_48.id,
			arg2_48
		})
	elseif var2_48 - arg2_48 > 0 then
		arg0_48.selectedIds[var1_48][2] = var2_48 - arg2_48
	else
		table.remove(arg0_48.selectedIds, var1_48)
	end

	arg0_48:updateSelected()
end

function var0_0.updateSelected(arg0_49)
	for iter0_49, iter1_49 in pairs(arg0_49.cards) do
		if iter1_49.equipmentVO then
			local var0_49 = false
			local var1_49 = 0

			for iter2_49, iter3_49 in pairs(arg0_49.selectedIds) do
				if iter1_49.equipmentVO.id == iter3_49[1] then
					var0_49 = true
					var1_49 = iter3_49[2]

					break
				end
			end

			iter1_49:updateSelected(var0_49, var1_49)
		end
	end

	arg0_49:updateOptionsStatus()
end

function var0_0.updateOptionsStatus(arg0_50)
	arg0_50.optionStatus = {}

	for iter0_50, iter1_50 in pairs(var2_0) do
		local var0_50 = arg0_50.selectOptions:Find(iter1_50)
		local var1_50 = arg0_50:GetOptionStatus(iter1_50)

		arg0_50.optionStatus[iter1_50] = var1_50

		setGray(var0_50, var1_50 == var5_0.GREY, true)

		GetOrAddComponent(var0_50, "CanvasGroup").alpha = var1_50 == var5_0.GREY and 0.4 or 1

		setActive(var0_50:Find("Background/Checkmark"), var1_50 == var5_0.ALL)
		setActive(var0_50:Find("Background/Part"), var1_50 == var5_0.PART)
	end
end

function var0_0.GetOptionStatus(arg0_51, arg1_51)
	if arg1_51 == var2_0.ALL then
		if #arg0_51.selectedIds == 0 then
			return var5_0.NONE
		elseif arg0_51:isSelectedAll() then
			return var5_0.ALL
		else
			return var5_0.PART
		end
	else
		local var0_51 = var4_0[arg1_51]

		if not underscore.any(arg0_51.equipmentVOs, function(arg0_52)
			local var0_52 = arg0_52:getConfig("rarity")

			return table.contains(var0_51, var0_52)
		end) then
			return var5_0.GREY
		end

		local var1_51 = underscore.any(arg0_51.selectedIds, function(arg0_53)
			local var0_53 = arg0_51.equipmentVOByIds[arg0_53[1]]:getConfig("rarity")

			return table.contains(var0_51, var0_53)
		end)

		return arg0_51:isSelectedAllRaritys(var0_51) and var5_0.ALL or var1_51 and var5_0.PART or var5_0.NONE
	end
end

function var0_0.isSelectedAllRaritys(arg0_54, arg1_54)
	for iter0_54, iter1_54 in pairs(arg0_54.equipmentVOByIds) do
		local var0_54 = iter1_54:getConfig("rarity")

		if table.contains(arg1_54, var0_54) then
			local var1_54 = false

			for iter2_54, iter3_54 in pairs(arg0_54.selectedIds) do
				if iter3_54[1] == iter1_54.id and iter1_54.count == iter3_54[2] then
					var1_54 = true
				end
			end

			if var1_54 == false then
				return false
			end
		end
	end

	return true
end

function var0_0.checkDestroyGold(arg0_55, arg1_55, arg2_55)
	local var0_55 = 0
	local var1_55 = false

	for iter0_55, iter1_55 in pairs(arg0_55.selectedIds) do
		local var2_55 = iter1_55[2]

		if Equipment.CanInBag(iter1_55[1]) then
			var0_55 = var0_55 + (Equipment.getConfigData(iter1_55[1]).destory_gold or 0) * var2_55
		end

		if arg1_55 and iter1_55[1] == arg1_55.configId then
			var1_55 = true
		end
	end

	if not var1_55 and arg1_55 and arg2_55 > 0 then
		var0_55 = var0_55 + (arg1_55:getConfig("destory_gold") or 0) * arg2_55
	end

	if arg0_55.player:GoldMax(var0_55) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.SureExit(arg0_56)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("sure_exit_resolve_equip"),
		onYes = function()
			arg0_56:emit(var0_0.ON_CLOSE)
		end
	})
end

function var0_0.willExit(arg0_58)
	arg0_58.equipDestroyConfirmWindow:Destroy()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_58._tf, pg.UIMgr.GetInstance().UIMain)
end

return var0_0
