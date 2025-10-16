local var0_0 = class("IslandShipAttrUpgradePage", import("...base.IslandBasePage"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "IslandShipAttrUpgradeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.upgradeBtn = arg0_2._tf:Find("frame/btn_confirm")
	arg0_2.closeBtn = arg0_2._tf:Find("frame/frame_1/close")
	arg0_2.contentTxt = arg0_2._tf:Find("frame/frame_1/Text"):GetComponent(typeof(Text))
	arg0_2.delBtn = arg0_2._tf:Find("frame/frame_2/del")
	arg0_2.maxBtn = arg0_2._tf:Find("frame/frame_2/max")
	arg0_2.toggles = {
		[var1_0] = arg0_2._tf:Find("frame/toggles/upgrade"),
		[var2_0] = arg0_2._tf:Find("frame/toggles/limit")
	}
	arg0_2.uiAttrList = UIItemList.New(arg0_2._tf:Find("frame/attr"), arg0_2._tf:Find("frame/attr/tpl"))
	arg0_2.uiUpgradeList = UIItemList.New(arg0_2._tf:Find("frame/frame_2/items"), arg0_2._tf:Find("frame/frame_2/items/tpl"))
	arg0_2.emptyTr = arg0_2._tf:Find("frame/frame_2/empty")
	arg0_2.uiLimitConsumrList = UIItemList.New(arg0_2._tf:Find("frame/frame_3/items"), arg0_2._tf:Find("frame/frame_3/items/tpl"))

	setText(arg0_2._tf:Find("frame/frame_1/title"), i18n("island_ship_title1"))
	setText(arg0_2._tf:Find("frame/toggles/upgrade/Text"), i18n("island_ship_title2"))
	setText(arg0_2._tf:Find("frame/toggles/limit/Text"), i18n("island_ship_title3"))
	setText(arg0_2._tf:Find("frame/toggles/upgrade/Text_1"), i18n("island_ship_title2"))
	setText(arg0_2._tf:Find("frame/toggles/limit/Text_1"), i18n("island_ship_title3"))
	setText(arg0_2._tf:Find("frame/frame_2/sub_title/Text"), i18n("island_ship_title4"))
	setText(arg0_2._tf:Find("frame/frame_3/sub_title/Text"), i18n("island_ship_title4"))
	setText(arg0_2.upgradeBtn:Find("Text"), i18n("island_confirm"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.delBtn, function()
		arg0_3.selected = {}

		arg0_3:FlushAttrs(arg0_3.slectedAttrName)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.maxBtn, function()
		arg0_3:FillSelected()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		arg0_3:Confirm()
	end, SFX_PANEL)

	for iter0_3, iter1_3 in ipairs(arg0_3.toggles) do
		onToggle(arg0_3, iter1_3, function(arg0_9)
			if arg0_9 then
				arg0_3:SwitchPage(iter0_3)
			end
		end, SFX_PANEL)
	end
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_10.OnAttrUpgrade)
	arg0_10:AddListener(GAME.ISLNAD_SHIP_ATTR_LIMIT_UNLOCK_DONE, arg0_10.OnLimitUnlock)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_11.OnAttrUpgrade)
	arg0_11:RemoveListener(GAME.ISLNAD_SHIP_ATTR_LIMIT_UNLOCK_DONE, arg0_11.OnLimitUnlock)
end

function var0_0.OnAttrUpgrade(arg0_12)
	arg0_12.selected = {}

	arg0_12:SwitchAttr(arg0_12.slectedAttrName)
end

function var0_0.OnLimitUnlock(arg0_13)
	arg0_13:SwitchPage(arg0_13.page)
end

function var0_0.OnShow(arg0_14, arg1_14)
	arg0_14.ship = arg1_14
	arg0_14.selected = {}

	arg0_14:BlurPanel()
	triggerToggle(arg0_14.toggles[var1_0], true)
end

function var0_0.SwitchPage(arg0_15, arg1_15)
	arg0_15.page = arg1_15

	arg0_15:UpdateAttrPanel()
	arg0_15:UpdateContent()

	if arg0_15.page == var2_0 then
		arg0_15:UpdateLimitUpgradeConsume()
	end
end

function var0_0.UpdateAttrPanel(arg0_16)
	local var0_16 = arg0_16.ship

	arg0_16.attrTrs = {}

	arg0_16.uiAttrList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = IslandShipAttr.ATTRS[arg1_17 + 1]

			arg0_16.attrTrs[var0_17] = arg2_17

			local var1_17 = var0_16:GetAttrGrade(var0_17)
			local var2_17 = IslandShipAttr.Grade2Img(var1_17)

			arg2_17:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var2_17[2])

			setText(arg2_17:Find("name"), IslandShipAttr.ToChinese(var0_17))
			arg0_16:UpdateAtrrValue(var0_16, var0_17)
		end
	end)
	arg0_16.uiAttrList:align(#IslandShipAttr.ATTRS)
end

function var0_0.UpdateAtrrValue(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.ship
	local var1_18 = arg0_18.attrTrs[arg2_18]

	if arg0_18.page == var1_0 then
		setText(var1_18:Find("value/value_1"), var0_18:GetAttr(arg2_18))
		setText(var1_18:Find("value/value_2"), "")
		setActive(var1_18:Find("value/arr"), false)
		onToggle(arg0_18, var1_18, function(arg0_19)
			if arg0_19 then
				arg0_18:SwitchAttr(arg2_18)
			end
		end, SFX_PANEL)
		setToggleEnabled(var1_18, true)

		if arg0_18.slectedAttrName and arg2_18 == arg0_18.slectedAttrName then
			triggerToggle(var1_18, true)
		elseif not arg0_18.slectedAttrName and arg2_18 == IslandShipAttr.ATTRS[1] then
			triggerToggle(var1_18, true)
		end
	elseif arg0_18.page == var2_0 then
		local var2_18 = Clone(var0_18)

		var2_18:SetUnlockExtraAttLimit()
		setActive(var1_18:Find("value/arr"), true)
		setText(var1_18:Find("value/value_1"), var0_18:GetExtraAttrLimit(arg2_18))
		setText(var1_18:Find("value/value_2"), var2_18:GetExtraAttrLimit(arg2_18))
		setToggleEnabled(var1_18, false)
		removeOnToggle(var1_18)

		for iter0_18, iter1_18 in pairs(arg0_18.attrTrs) do
			setActive(iter1_18:Find("Image"), false)
		end
	end
end

function var0_0.UpdateLimitUpgradeConsume(arg0_20)
	local var0_20 = arg0_20.ship
	local var1_20 = var0_20:IsUnlockExtraAttLimit()
	local var2_20 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_20 = false

	if var0_20:IsUnlockExtraAttLimit() then
		arg0_20.uiLimitConsumrList:align(0)
	else
		local var4_20 = var0_20:GetExtraAttrLimitUnlockConsume()

		arg0_20.uiLimitConsumrList:make(function(arg0_21, arg1_21, arg2_21)
			if arg0_21 == UIItemList.EventUpdate then
				local var0_21 = var4_20[arg1_21 + 1]

				updateCustomDrop(arg2_21, var0_21)

				local var1_21 = var2_20:GetOwnCount(var0_21.id)
				local var2_21 = setColorStr(var1_21, var1_21 >= var0_21.count and COLOR_GREEN or COLOR_RED)

				setText(arg2_21:Find("icon_bg/count_bg/count"), var2_21 .. "/" .. var0_21.count)
			end
		end)

		var3_20 = _.all(var4_20, function(arg0_22)
			return var2_20:GetOwnCount(arg0_22.id) >= arg0_22.count
		end)

		arg0_20.uiLimitConsumrList:align(#var4_20)
	end

	setGray(arg0_20.upgradeBtn, var1_20 or not var3_20)
end

function var0_0.SwitchAttr(arg0_23, arg1_23)
	arg0_23.selected = {}

	local var0_23 = arg0_23.ship

	arg0_23:ClearUpdateAttrValue(arg0_23.slectedAttrName)

	arg0_23.slectedAttrName = arg1_23

	local var1_23 = arg0_23:CanAddItemForAttrValue(arg1_23)

	if var1_23 then
		arg0_23:FlushAttrs(arg1_23)
	else
		arg0_23.uiUpgradeList:align(0)
	end

	arg0_23:UpdateAttrValue()
	setActive(arg0_23.emptyTr, not var1_23)
	setActive(arg0_23.delBtn, var1_23)
	setActive(arg0_23.maxBtn, var1_23)
end

function var0_0.FlushAttrs(arg0_24, arg1_24)
	local var0_24 = arg0_24.ship:GetUpgradeExtraAttrConsume(arg1_24)

	arg0_24.uiUpgradeList:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = var0_24[arg1_25 + 1]

			updateCustomDrop(arg2_25, var0_25)

			local var1_25 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(var0_25.id)

			setText(arg2_25:Find("icon_bg/count_bg/count"), "X" .. var1_25)
			onButton(arg0_24, arg2_25, function()
				if not arg0_24:CanAddItemForAttrValue(arg1_24, arg0_24.selected) then
					return
				end

				arg0_24:OpenAtrrCalcPanel(arg2_25, var0_25)
			end, SFX_PANEL)
			onButton(arg0_24, arg2_25:Find("calc/bg"), function()
				arg0_24.selected[var0_25.id] = (arg0_24.selected[var0_25.id] or 0) - 1

				arg0_24:UpdateAttrCalcPanel(arg2_25, var0_25)
			end, SFX_PANEL)
			arg0_24:UpdateAttrCalcPanel(arg2_25, var0_25)
		end
	end)
	arg0_24.uiUpgradeList:align(#var0_24)
end

function var0_0.ClearUpdateAttrValue(arg0_28, arg1_28)
	if not arg1_28 or arg1_28 == "" then
		return
	end

	local var0_28 = arg0_28.ship
	local var1_28 = arg0_28.attrTrs[arg1_28]

	setText(var1_28:Find("value/value_1"), var0_28:GetAttr(arg1_28))
end

function var0_0.OpenAtrrCalcPanel(arg0_29, arg1_29, arg2_29)
	if getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(arg2_29.id) <= (arg0_29.selected[arg2_29.id] or 0) then
		return
	end

	arg0_29.selected[arg2_29.id] = (arg0_29.selected[arg2_29.id] or 0) + 1

	arg0_29:UpdateAttrCalcPanel(arg1_29, arg2_29)
end

function var0_0.UpdateAttrCalcPanel(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.selected[arg2_30.id] or 0

	setText(arg1_30:Find("calc/Text"), var0_30)
	setActive(arg1_30:Find("calc"), var0_30 > 0)
	arg0_30:UpdateAttrValue()
end

function var0_0.UpdateAttrValue(arg0_31)
	local var0_31 = arg0_31.slectedAttrName
	local var1_31 = arg0_31.attrTrs[var0_31]
	local var2_31 = arg0_31.ship
	local var3_31, var4_31, var5_31 = arg0_31:CanAddItemForAttrValue(var0_31, arg0_31.selected)
	local var6_31 = var5_31 <= var4_31 and "(MAX)" or string.format("(<color=#36a5fb>+%s</color>/%s)", var4_31, var5_31)

	setText(var1_31:Find("value/value_1"), var2_31:GetAttr(var0_31) .. var6_31)

	local var7_31 = arg0_31:NothingSelected() and not var3_31

	setGray(arg0_31.upgradeBtn, var7_31 or arg0_31:NothingSelected())
end

function var0_0.CanAddItemForAttrValue(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.ship
	local var1_32 = var0_32:GetExtraAttrValue(arg1_32)

	for iter0_32, iter1_32 in pairs(arg2_32 or {}) do
		local var2_32 = IslandItem.New({
			id = iter0_32
		})

		var1_32 = var1_32 + tonumber(var2_32:GetUseArg()) * iter1_32
	end

	local var3_32 = var0_32:GetExtraAttrLimit(arg1_32)

	return var1_32 < var3_32, var1_32, var3_32
end

function var0_0.FillSelected(arg0_33)
	arg0_33.selected = {}

	local var0_33 = arg0_33.ship:GetUpgradeExtraAttrConsume(arg0_33.slectedAttrName)
	local var1_33 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var2_33 = _.map(var0_33, function(arg0_34)
		return var1_33:GetItemById(arg0_34.id) or IslandItem.New({
			number = 0,
			id = arg0_34.id
		})
	end)

	table.sort(var2_33, function(arg0_35, arg1_35)
		return arg0_35:GetRarity() > arg1_35:GetRarity()
	end)

	local var3_33 = {}

	for iter0_33, iter1_33 in ipairs(var2_33) do
		for iter2_33 = 1, iter1_33.count do
			if arg0_33:CanAddItemForAttrValue(arg0_33.slectedAttrName, var3_33) then
				var3_33[iter1_33.id] = (var3_33[iter1_33.id] or 0) + 1
			else
				break
			end
		end
	end

	arg0_33.selected = var3_33

	arg0_33:FlushAttrs(arg0_33.slectedAttrName)
end

function var0_0.UpdateContent(arg0_36)
	if arg0_36.page == var1_0 then
		arg0_36.contentTxt.text = i18n("island_ship_lock_attr_tip")
	elseif arg0_36.page == var2_0 then
		arg0_36.contentTxt.text = i18n("island_ship_unlock_limit_tip")
	end
end

function var0_0.Confirm(arg0_37)
	if arg0_37.page == var1_0 then
		if not arg0_37.slectedAttrName or not arg0_37.ship then
			return
		end

		if arg0_37:NothingSelected() then
			return
		end

		if not arg0_37:CanAddItemForAttrValue(arg0_37.slectedAttrName) then
			return
		end

		local var0_37 = table.indexof(IslandShipAttr.ATTRS, arg0_37.slectedAttrName)

		if var0_37 <= 0 then
			return
		end

		arg0_37:emit(IslandMediator.SHIP_ATTR_UPGRADE, arg0_37.ship.id, var0_37, arg0_37.selected)
	elseif arg0_37.page == var2_0 then
		if arg0_37.ship:IsUnlockExtraAttLimit() then
			return
		end

		arg0_37:emit(IslandMediator.SHIP_ATTR_LIMIT_UNLOCK, arg0_37.ship.id)
	end
end

function var0_0.NothingSelected(arg0_38)
	for iter0_38, iter1_38 in pairs(arg0_38.selected) do
		if iter1_38 > 0 then
			return false
		end
	end

	return true
end

function var0_0.OnHide(arg0_39)
	arg0_39:UnBlurPanel()
end

return var0_0
