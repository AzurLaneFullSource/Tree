local var0 = class("DestroyConfirmView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "StoreHouseDestroyConfirmView"
end

function var0.OnInit(arg0)
	arg0.destroyBonusList = arg0._tf:Find("frame/bg/scrollview/list")
	arg0.destroyBonusItem = arg0.destroyBonusList:Find("equipment_tpl")
	arg0.destroyNoGotTip = arg0._tf:Find("frame/bg/tip")

	setText(arg0:findTF("frame/title_text/Text"), i18n("equipment_select_device_destroy_bonus_tip"))
	setText(arg0.destroyNoGotTip, i18n("equipment_select_device_destroy_nobonus_tip"))
	onButton(arg0, arg0:findTF("frame/actions/cancel_btn"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("frame/top/btnBack"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("frame/actions/confirm_btn"), function()
		arg0:emit(EquipmentMediator.ON_DESTROY, arg0.selectedIds)
		arg0.confirmBtnCB()
		arg0:Hide()
	end, SFX_UI_EQUIPMENT_RESOLVE)
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.SetConfirmBtnCB(arg0, arg1)
	arg0.confirmBtnCB = arg1
end

function var0.DisplayDestroyBonus(arg0, arg1)
	arg0.selectedIds = arg1

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

	setActive(arg0.destroyNoGotTip, #var0 <= 0)

	if not arg0.destroyList then
		arg0.destroyList = UIItemList.New(arg0.destroyBonusList, arg0.destroyBonusItem)
	end

	arg0.destroyList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			if var0.type == DROP_TYPE_SHIP then
				arg0.hasShip = true
			end

			updateDrop(arg2, var0)

			local var1, var2 = contentWrap(var0:getConfig("name"), 10, 2)

			if var1 then
				var2 = var2 .. "..."
			end

			setText(arg2:Find("name"), var2)
			onButton(arg0, arg2, function()
				if var0.type == DROP_TYPE_RESOURCE or var0.type == DROP_TYPE_ITEM then
					arg0:emit(BaseUI.ON_ITEM, var0:getConfig("id"))
				elseif var0.type == DROP_TYPE_EQUIP then
					arg0:emit(BaseUI.ON_EQUIPMENT, {
						equipmentId = var0:getConfig("id"),
						type = EquipmentInfoMediator.TYPE_DISPLAY
					})
				end
			end, SFX_PANEL)
		end
	end)
	arg0.destroyList:align(#var0)
end

return var0
