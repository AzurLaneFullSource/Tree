local var0 = class("AssignedItemView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "StoreHouseItemAssignedView"
end

function var0.OnInit(arg0)
	local var0 = arg0._tf:Find("operate")

	arg0.ulist = UIItemList.New(var0:Find("got/bottom/list"), var0:Find("got/bottom/list/tpl"))
	arg0.confirmBtn = var0:Find("actions/confirm")

	setText(arg0.confirmBtn:Find("Image"), i18n("text_confirm"))

	arg0.cancelBtn = var0:Find("actions/cancel")

	setText(arg0.cancelBtn:Find("Image"), i18n("text_cancel"))

	arg0.rightArr = var0:Find("calc/value_bg/add")
	arg0.leftArr = var0:Find("calc/value_bg/mius")
	arg0.maxBtn = var0:Find("calc/max")
	arg0.valueText = var0:Find("calc/value_bg/Text")
	arg0.itemTF = var0:Find("item")
	arg0.nameTF = arg0.itemTF:Find("display_panel/name_container/name/Text")
	arg0.descTF = arg0.itemTF:Find("display_panel/desc/Text")

	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	pressPersistTrigger(arg0.rightArr, 0.5, function(arg0)
		if not arg0.itemVO then
			arg0()

			return
		end

		arg0.count = math.min(arg0.count + 1, arg0.itemVO.count)

		arg0:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0.leftArr, 0.5, function(arg0)
		if not arg0.itemVO then
			arg0()

			return
		end

		arg0.count = math.max(arg0.count - 1, 1)

		arg0:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		if not arg0.itemVO then
			return
		end

		arg0.count = arg0.itemVO.count

		arg0:updateValue()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if not arg0.selectedIndex or not arg0.itemVO or arg0.count <= 0 then
			return
		end

		local var0 = {}

		if arg0.itemVO:IsDoaSelectCharItem() then
			table.insert(var0, function(arg0)
				local var0 = arg0.displayDrops[arg0.selectedIndex].id
				local var1 = HXSet.hxLan(pg.ship_data_statistics[var0].name)

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("doa_character_select_confirm", var1),
					onYes = arg0
				})
			end)
		end

		local var1 = arg0.displayDrops[arg0.selectedIndex].type == DROP_TYPE_ITEM and arg0.displayDrops[arg0.selectedIndex]:getSubClass()

		if var1 and var1:getConfig("type") == Item.SKIN_ASSIGNED_TYPE and var1:IsAllSkinOwner() then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("blackfriday_pack_select_skinall"),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			arg0:emit(EquipmentMediator.ON_USE_ITEM, arg0.itemVO.id, arg0.count, arg0.itemVO:getConfig("usage_arg")[arg0.selectedIndex])
			arg0:Hide()
		end)
	end, SFX_PANEL)
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.updateValue(arg0)
	setText(arg0.valueText, arg0.count)
	arg0.ulist:each(function(arg0, arg1)
		if not isActive(arg1) then
			return
		end

		setText(arg1:Find("item/icon_bg/count"), arg0.count * arg0.displayDrops[arg0 + 1].count)
	end)
end

local function var1(arg0)
	local var0 = pg.ship_data_template[arg0].group_type

	return getProxy(CollectionProxy):getShipGroup(var0) ~= nil
end

function var0.update(arg0, arg1)
	arg0.count = 1
	arg0.selectedIndex = nil
	arg0.selectedItem = nil
	arg0.itemVO = arg1
	arg0.displayDrops = underscore.map(arg1:getConfig("display_icon"), function(arg0)
		return Drop.Create(arg0)
	end)

	local var0 = arg1:getConfig("time_limit") == 1

	arg0.ulist:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.displayDrops[arg1]

			updateDrop(arg2:Find("item"), var0)
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.selectedIndex = arg1
					arg0.selectedItem = arg2
				end
			end, SFX_PANEL)
			triggerToggle(arg2, false)
			setScrollText(arg2:Find("name_bg/Text"), arg0.displayDrops[arg1]:getConfig("name"))

			arg0.selectedItem = arg0.selectedItem or arg2

			local var1 = var0 and var0.type == DROP_TYPE_SHIP and var1(var0.id)

			if var1 then
				setText(arg2:Find("item/tip/Text"), i18n("tech_character_get"))
			end

			setActive(arg2:Find("item/tip"), var1)
		end
	end)
	arg0.ulist:align(#arg0.displayDrops)
	triggerToggle(arg0.selectedItem, true)
	arg0:updateValue()

	local var1 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1.id,
		count = arg1.count
	})

	updateDrop(arg0.itemTF:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = var1
	}))
	UpdateOwnDisplay(arg0.itemTF:Find("left/own"), var1)

	if underscore.any(arg0.displayDrops, function(arg0)
		return arg0.type == DROP_TYPE_ITEM and arg0:getConfig("type") == Item.SKIN_ASSIGNED_TYPE
	end) or var1.type == DROP_TYPE_ITEM and var1:getConfig("type") == Item.ASSIGNED_TYPE then
		RegisterDetailButton(arg0, arg0.itemTF:Find("left/detail"), var1)
	else
		removeOnButton(arg0.itemTF:Find("left/detail"))
	end

	setText(arg0.nameTF, arg1:getConfig("name"))
	setText(arg0.descTF, arg1:getConfig("display"))
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
