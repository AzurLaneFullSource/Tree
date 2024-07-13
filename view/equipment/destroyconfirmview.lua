local var0_0 = class("DestroyConfirmView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "StoreHouseDestroyConfirmView"
end

function var0_0.OnInit(arg0_2)
	arg0_2.destroyBonusList = arg0_2._tf:Find("frame/bg/scrollview/list")
	arg0_2.destroyBonusItem = arg0_2.destroyBonusList:Find("equipment_tpl")
	arg0_2.destroyNoGotTip = arg0_2._tf:Find("frame/bg/tip")

	setText(arg0_2:findTF("frame/title_text/Text"), i18n("equipment_select_device_destroy_bonus_tip"))
	setText(arg0_2.destroyNoGotTip, i18n("equipment_select_device_destroy_nobonus_tip"))
	onButton(arg0_2, arg0_2:findTF("frame/actions/cancel_btn"), function()
		arg0_2:Hide()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:Hide()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2:findTF("frame/top/btnBack"), function()
		arg0_2:Hide()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2:findTF("frame/actions/confirm_btn"), function()
		arg0_2:emit(EquipmentMediator.ON_DESTROY, arg0_2.selectedIds)
		arg0_2.confirmBtnCB()
		arg0_2:Hide()
	end, SFX_UI_EQUIPMENT_RESOLVE)
end

function var0_0.Show(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	setActive(arg0_7._tf, true)
end

function var0_0.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, arg0_8._parentTf)
	setActive(arg0_8._tf, false)
end

function var0_0.SetConfirmBtnCB(arg0_9, arg1_9)
	arg0_9.confirmBtnCB = arg1_9
end

function var0_0.DisplayDestroyBonus(arg0_10, arg1_10)
	arg0_10.selectedIds = arg1_10

	local var0_10 = {}
	local var1_10 = 0

	for iter0_10, iter1_10 in ipairs(arg0_10.selectedIds) do
		if Equipment.CanInBag(iter1_10[1]) then
			local var2_10 = Equipment.getConfigData(iter1_10[1])
			local var3_10 = var2_10.destory_item or {}

			var1_10 = var1_10 + (var2_10.destory_gold or 0) * iter1_10[2]

			for iter2_10, iter3_10 in ipairs(var3_10) do
				local var4_10 = false

				for iter4_10, iter5_10 in ipairs(var0_10) do
					if iter3_10[1] == var0_10[iter4_10].id then
						var0_10[iter4_10].count = var0_10[iter4_10].count + iter3_10[2] * iter1_10[2]
						var4_10 = true

						break
					end
				end

				if not var4_10 then
					table.insert(var0_10, {
						type = DROP_TYPE_ITEM,
						id = iter3_10[1],
						count = iter3_10[2] * iter1_10[2]
					})
				end
			end
		end
	end

	if var1_10 > 0 then
		table.insert(var0_10, {
			id = 1,
			type = DROP_TYPE_RESOURCE,
			count = var1_10
		})
	end

	setActive(arg0_10.destroyNoGotTip, #var0_10 <= 0)

	if not arg0_10.destroyList then
		arg0_10.destroyList = UIItemList.New(arg0_10.destroyBonusList, arg0_10.destroyBonusItem)
	end

	arg0_10.destroyList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var0_10[arg1_11 + 1]

			if var0_11.type == DROP_TYPE_SHIP then
				arg0_10.hasShip = true
			end

			updateDrop(arg2_11, var0_11)

			local var1_11, var2_11 = contentWrap(var0_11:getConfig("name"), 10, 2)

			if var1_11 then
				var2_11 = var2_11 .. "..."
			end

			setText(arg2_11:Find("name"), var2_11)
			onButton(arg0_10, arg2_11, function()
				if var0_11.type == DROP_TYPE_RESOURCE or var0_11.type == DROP_TYPE_ITEM then
					arg0_10:emit(BaseUI.ON_ITEM, var0_11:getConfig("id"))
				elseif var0_11.type == DROP_TYPE_EQUIP then
					arg0_10:emit(BaseUI.ON_EQUIPMENT, {
						equipmentId = var0_11:getConfig("id"),
						type = EquipmentInfoMediator.TYPE_DISPLAY
					})
				end
			end, SFX_PANEL)
		end
	end)
	arg0_10.destroyList:align(#var0_10)
end

return var0_0
