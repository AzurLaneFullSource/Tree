local var0_0 = class("AssignedItemView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "StoreHouseItemAssignedView"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = arg0_2._tf:Find("operate")

	arg0_2.ulist = UIItemList.New(var0_2:Find("got/bottom/list"), var0_2:Find("got/bottom/list/tpl"))
	arg0_2.confirmBtn = var0_2:Find("actions/confirm")

	setText(arg0_2.confirmBtn:Find("Image"), i18n("text_confirm"))

	arg0_2.cancelBtn = var0_2:Find("actions/cancel")

	setText(arg0_2.cancelBtn:Find("Image"), i18n("text_cancel"))

	arg0_2.rightArr = var0_2:Find("calc/value_bg/add")
	arg0_2.leftArr = var0_2:Find("calc/value_bg/mius")
	arg0_2.maxBtn = var0_2:Find("calc/max")
	arg0_2.valueText = var0_2:Find("calc/value_bg/Text")
	arg0_2.itemTF = var0_2:Find("item")
	arg0_2.nameTF = arg0_2.itemTF:Find("display_panel/name_container/name/Text")
	arg0_2.descTF = arg0_2.itemTF:Find("display_panel/desc/Text")

	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.cancelBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	pressPersistTrigger(arg0_2.rightArr, 0.5, function(arg0_5)
		if not arg0_2.itemVO then
			arg0_5()

			return
		end

		arg0_2.count = math.min(arg0_2.count + 1, arg0_2.itemVO.count)

		arg0_2:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_2.leftArr, 0.5, function(arg0_6)
		if not arg0_2.itemVO then
			arg0_6()

			return
		end

		arg0_2.count = math.max(arg0_2.count - 1, 1)

		arg0_2:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_2, arg0_2.maxBtn, function()
		if not arg0_2.itemVO then
			return
		end

		arg0_2.count = arg0_2.itemVO.count

		arg0_2:updateValue()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.confirmBtn, function()
		if not arg0_2.selectedIndex or not arg0_2.itemVO or arg0_2.count <= 0 then
			return
		end

		local var0_8 = {}

		if arg0_2.itemVO:IsDoaSelectCharItem() then
			table.insert(var0_8, function(arg0_9)
				local var0_9 = arg0_2.displayDrops[arg0_2.selectedIndex].id
				local var1_9 = HXSet.hxLan(pg.ship_data_statistics[var0_9].name)

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("doa_character_select_confirm", var1_9),
					onYes = arg0_9
				})
			end)
		end

		local var1_8 = arg0_2.displayDrops[arg0_2.selectedIndex].type == DROP_TYPE_ITEM and arg0_2.displayDrops[arg0_2.selectedIndex]:getSubClass()

		if var1_8 and var1_8:getConfig("type") == Item.SKIN_ASSIGNED_TYPE and var1_8:IsAllSkinOwner() then
			table.insert(var0_8, function(arg0_10)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("blackfriday_pack_select_skinall"),
					onYes = arg0_10
				})
			end)
		end

		seriesAsync(var0_8, function()
			arg0_2:emit(EquipmentMediator.ON_USE_ITEM, arg0_2.itemVO.id, arg0_2.count, arg0_2.itemVO:getConfig("usage_arg")[arg0_2.selectedIndex])
			arg0_2:Hide()
		end)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_12)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
	setActive(arg0_12._tf, true)
end

function var0_0.Hide(arg0_13)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf, arg0_13._parentTf)
	setActive(arg0_13._tf, false)
end

function var0_0.updateValue(arg0_14)
	setText(arg0_14.valueText, arg0_14.count)
	arg0_14.ulist:each(function(arg0_15, arg1_15)
		if not isActive(arg1_15) then
			return
		end

		setText(arg1_15:Find("item/icon_bg/count"), arg0_14.count * arg0_14.displayDrops[arg0_15 + 1].count)
	end)
end

local function var1_0(arg0_16)
	local var0_16 = pg.ship_data_template[arg0_16].group_type

	return getProxy(CollectionProxy):getShipGroup(var0_16) ~= nil
end

function var0_0.update(arg0_17, arg1_17)
	arg0_17.count = 1
	arg0_17.selectedIndex = nil
	arg0_17.selectedItem = nil
	arg0_17.itemVO = arg1_17
	arg0_17.displayDrops = underscore.map(arg1_17:getConfig("display_icon"), function(arg0_18)
		return Drop.Create(arg0_18)
	end)

	local var0_17 = arg1_17:getConfig("time_limit") == 1

	arg0_17.ulist:make(function(arg0_19, arg1_19, arg2_19)
		arg1_19 = arg1_19 + 1

		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = arg0_17.displayDrops[arg1_19]

			updateDrop(arg2_19:Find("item"), var0_19)
			onToggle(arg0_17, arg2_19, function(arg0_20)
				if arg0_20 then
					arg0_17.selectedIndex = arg1_19
					arg0_17.selectedItem = arg2_19
				end
			end, SFX_PANEL)
			triggerToggle(arg2_19, false)
			setScrollText(arg2_19:Find("name_bg/Text"), arg0_17.displayDrops[arg1_19]:getConfig("name"))

			arg0_17.selectedItem = arg0_17.selectedItem or arg2_19

			local var1_19 = var0_17 and var0_19.type == DROP_TYPE_SHIP and var1_0(var0_19.id)

			if var1_19 then
				setText(arg2_19:Find("item/tip/Text"), i18n("tech_character_get"))
			end

			setActive(arg2_19:Find("item/tip"), var1_19)
		end
	end)
	arg0_17.ulist:align(#arg0_17.displayDrops)
	triggerToggle(arg0_17.selectedItem, true)
	arg0_17:updateValue()

	local var1_17 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1_17.id,
		count = arg1_17.count
	})

	updateDrop(arg0_17.itemTF:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = var1_17
	}))
	UpdateOwnDisplay(arg0_17.itemTF:Find("left/own"), var1_17)

	if underscore.any(arg0_17.displayDrops, function(arg0_21)
		return arg0_21.type == DROP_TYPE_ITEM and arg0_21:getConfig("type") == Item.SKIN_ASSIGNED_TYPE
	end) or var1_17.type == DROP_TYPE_ITEM and var1_17:getConfig("type") == Item.ASSIGNED_TYPE then
		RegisterDetailButton(arg0_17, arg0_17.itemTF:Find("left/detail"), var1_17)
	else
		removeOnButton(arg0_17.itemTF:Find("left/detail"))
	end

	setText(arg0_17.nameTF, arg1_17:getConfig("name"))
	setText(arg0_17.descTF, arg1_17:getConfig("display"))
end

function var0_0.OnDestroy(arg0_22)
	if arg0_22:isShowing() then
		arg0_22:Hide()
	end
end

return var0_0
