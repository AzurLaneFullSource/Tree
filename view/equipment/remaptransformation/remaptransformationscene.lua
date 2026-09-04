local var0_0 = class("ReMapTransformationScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "StoreHouseItemAssignedView"
end

function var0_0.init(arg0_2)
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
		arg0_2:closeView()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.cancelBtn, function()
		arg0_2:closeView()
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
			arg0_2:emit(ReMapTransformationMediator.ON_USE_ITEM, arg0_2.itemVO.id, arg0_2.count, arg0_2.itemVO:getConfig("usage_arg")[arg0_2.selectedIndex])
		end)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_12)
	arg0_12:BlurPanel(arg0_12._tf)
	setActive(arg0_12._tf, true)

	arg0_12.selectedIndex = nil
	arg0_12.selectedItem = nil

	arg0_12:update(arg0_12.contextData.itemVO)
end

function var0_0.update(arg0_13, arg1_13)
	arg0_13.count = 1
	arg0_13.itemVO = arg1_13
	arg0_13.displayDrops = underscore.map(arg1_13:getConfig("display_icon"), function(arg0_14)
		return Drop.Create({
			DROP_TYPE_VITEM,
			arg0_14,
			1
		})
	end)

	local var0_13 = arg1_13:getConfig("time_limit") == 1

	arg0_13.ulist:make(function(arg0_15, arg1_15, arg2_15)
		arg1_15 = arg1_15 + 1

		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_13.displayDrops[arg1_15]

			updateDrop(arg2_15:Find("item"), var0_15)
			onToggle(arg0_13, arg2_15, function(arg0_16)
				if arg0_16 then
					arg0_13.selectedIndex = arg1_15
					arg0_13.selectedItem = arg2_15
				elseif arg0_13.selectedIndex == arg1_15 then
					arg0_13.selectedIndex = nil
					arg0_13.selectedItem = nil
				end
			end, SFX_PANEL)
			triggerToggle(arg2_15, false)
			setScrollText(arg2_15:Find("name_bg/Text"), var0_15:getConfig("name"))

			local var1_15 = var0_13 and var0_15.type == DROP_TYPE_SHIP and CheckShipExist(var0_15.id)

			if var1_15 then
				setText(arg2_15:Find("item/tip/Text"), i18n("tech_character_get"))
			end

			setActive(arg2_15:Find("item/tip"), var1_15)
			onButton(arg0_13, arg2_15:Find("block_mask"), function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("item_assigned_type_limit_error"))
			end, SFX_CANCEL)

			if not arg0_13.selectedItem and not arg0_13:isOverLimit(arg1_15, arg0_13.count) then
				arg0_13.selectedItem = arg2_15
			end
		end
	end)
	arg0_13.ulist:align(#arg0_13.displayDrops)

	if arg0_13.selectedItem then
		triggerToggle(arg0_13.selectedItem, true)
	end

	arg0_13:updateValue()

	local var1_13 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1_13.id,
		count = arg1_13.count
	})

	updateDrop(arg0_13.itemTF:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = var1_13
	}))
	UpdateOwnDisplay(arg0_13.itemTF:Find("left/own"), var1_13)

	if underscore.any(arg0_13.displayDrops, function(arg0_18)
		return arg0_18.type == DROP_TYPE_ITEM and arg0_18:getConfig("type") == Item.SKIN_ASSIGNED_TYPE
	end) or var1_13.type == DROP_TYPE_ITEM and var1_13:getConfig("type") == Item.ASSIGNED_TYPE then
		RegisterDetailButton(arg0_13, arg0_13.itemTF:Find("left/detail"), var1_13)
	else
		removeOnButton(arg0_13.itemTF:Find("left/detail"))
	end

	setText(arg0_13.nameTF, arg1_13:getConfig("name"))
	setText(arg0_13.descTF, arg1_13:getConfig("display"))
end

function var0_0.updateValue(arg0_19)
	setText(arg0_19.valueText, arg0_19.count)
	arg0_19.ulist:each(function(arg0_20, arg1_20)
		if not isActive(arg1_20) then
			return
		end

		setText(arg1_20:Find("item/icon_bg/count"), arg0_19.count * arg0_19.displayDrops[arg0_20 + 1].count)

		local var0_20 = arg0_19:isOverLimit(arg0_20 + 1, arg0_19.count)

		setActive(arg1_20:Find("block_mask"), var0_20)

		if var0_20 and arg0_19.selectedIndex == arg0_20 + 1 then
			triggerToggle(arg1_20, false)
		end
	end)
end

function var0_0.isOverLimit(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.displayDrops[arg1_21]
	local var1_21 = underscore.detect(arg0_21.itemVO:getConfig("limit"), function(arg0_22)
		local var0_22, var1_22, var2_22 = unpack(arg0_22)

		return var0_22 == var0_21.type and var1_22 == var0_21.id
	end)
	local var2_21

	var2_21 = var1_21 and var1_21[3] or nil

	if not var2_21 then
		return false
	else
		return var2_21 < var0_21:getOwnedCount() + var0_21.count * arg0_21.count
	end
end

local function var1_0(arg0_23)
	local var0_23 = pg.ship_data_template[arg0_23].group_type

	return getProxy(CollectionProxy):getShipGroup(var0_23) ~= nil
end

function var0_0.willExit(arg0_24)
	arg0_24:UnOverlayPanel(arg0_24._tf)
end

return var0_0
