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
	onButton(arg0_3, arg0_3._tf:Find("frame/frame_1/title/help"), function()
		arg0_3:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_chara_attr_help")
		})
	end, SFX_PANEL)
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
		onToggle(arg0_3, iter1_3, function(arg0_10)
			if arg0_10 then
				arg0_3:SwitchPage(iter0_3)
			end
		end, SFX_PANEL)
	end
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_11.OnAttrUpgrade)
	arg0_11:AddListener(GAME.ISLNAD_SHIP_ATTR_LIMIT_UNLOCK_DONE, arg0_11.OnLimitUnlock)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_12.OnAttrUpgrade)
	arg0_12:RemoveListener(GAME.ISLNAD_SHIP_ATTR_LIMIT_UNLOCK_DONE, arg0_12.OnLimitUnlock)
end

function var0_0.OnAttrUpgrade(arg0_13)
	arg0_13.selected = {}

	arg0_13:SwitchAttr(arg0_13.slectedAttrName)
end

function var0_0.OnLimitUnlock(arg0_14)
	arg0_14:SwitchPage(arg0_14.page)
end

function var0_0.OnShow(arg0_15, arg1_15)
	arg0_15.ship = arg1_15
	arg0_15.selected = {}

	arg0_15:BlurPanel()
	triggerToggle(arg0_15.toggles[var1_0], true)
end

function var0_0.SwitchPage(arg0_16, arg1_16)
	arg0_16.page = arg1_16

	arg0_16:UpdateAttrPanel()
	arg0_16:UpdateContent()

	if arg0_16.page == var2_0 then
		arg0_16:UpdateLimitUpgradeConsume()
	end
end

function var0_0.UpdateAttrPanel(arg0_17)
	local var0_17 = arg0_17.ship

	arg0_17.attrTrs = {}

	arg0_17.uiAttrList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = IslandShipAttr.ATTRS[arg1_18 + 1]

			arg0_17.attrTrs[var0_18] = arg2_18

			local var1_18 = var0_17:GetAttrGrade(var0_18)
			local var2_18 = IslandShipAttr.Grade2Img(var1_18)

			arg2_18:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var2_18[2])

			setText(arg2_18:Find("name"), IslandShipAttr.ToChinese(var0_18))
			arg0_17:UpdateAtrrValue(var0_17, var0_18)
		end
	end)
	arg0_17.uiAttrList:align(#IslandShipAttr.ATTRS)
end

function var0_0.UpdateAtrrValue(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.ship
	local var1_19 = arg0_19.attrTrs[arg2_19]

	if arg0_19.page == var1_0 then
		setText(var1_19:Find("value/value_1"), var0_19:GetAttr(arg2_19))
		setText(var1_19:Find("value/value_2"), "")
		setActive(var1_19:Find("value/arr"), false)
		onToggle(arg0_19, var1_19, function(arg0_20)
			if arg0_20 then
				arg0_19:SwitchAttr(arg2_19)
			end
		end, SFX_PANEL)
		setToggleEnabled(var1_19, true)

		if arg0_19.slectedAttrName and arg2_19 == arg0_19.slectedAttrName then
			triggerToggle(var1_19, true)
		elseif not arg0_19.slectedAttrName and arg2_19 == IslandShipAttr.ATTRS[1] then
			triggerToggle(var1_19, true)
		end
	elseif arg0_19.page == var2_0 then
		local var2_19 = Clone(var0_19)

		var2_19:SetUnlockExtraAttLimit()
		setActive(var1_19:Find("value/arr"), true)
		setText(var1_19:Find("value/value_1"), var0_19:GetExtraAttrLimit(arg2_19))
		setText(var1_19:Find("value/value_2"), var2_19:GetExtraAttrLimit(arg2_19))
		setToggleEnabled(var1_19, false)
		removeOnToggle(var1_19)

		for iter0_19, iter1_19 in pairs(arg0_19.attrTrs) do
			setActive(iter1_19:Find("Image"), false)
		end
	end
end

function var0_0.UpdateLimitUpgradeConsume(arg0_21)
	local var0_21 = arg0_21.ship
	local var1_21 = var0_21:IsUnlockExtraAttLimit()
	local var2_21 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_21 = false

	if var0_21:IsUnlockExtraAttLimit() then
		arg0_21.uiLimitConsumrList:align(0)
	else
		local var4_21 = var0_21:GetExtraAttrLimitUnlockConsume()

		arg0_21.uiLimitConsumrList:make(function(arg0_22, arg1_22, arg2_22)
			if arg0_22 == UIItemList.EventUpdate then
				local var0_22 = var4_21[arg1_22 + 1]

				updateCustomDrop(arg2_22, var0_22)

				local var1_22 = var2_21:GetOwnCount(var0_22.id)
				local var2_22 = setColorStr(var1_22, var1_22 >= var0_22.count and COLOR_GREEN or COLOR_RED)

				setText(arg2_22:Find("icon_bg/count_bg/count"), var2_22 .. "/" .. var0_22.count)
			end
		end)

		var3_21 = _.all(var4_21, function(arg0_23)
			return var2_21:GetOwnCount(arg0_23.id) >= arg0_23.count
		end)

		arg0_21.uiLimitConsumrList:align(#var4_21)
	end

	setGray(arg0_21.upgradeBtn, var1_21 or not var3_21)
end

function var0_0.SwitchAttr(arg0_24, arg1_24)
	arg0_24.selected = {}

	local var0_24 = arg0_24.ship

	arg0_24:ClearUpdateAttrValue(arg0_24.slectedAttrName)

	arg0_24.slectedAttrName = arg1_24

	local var1_24 = arg0_24:CanAddItemForAttrValue(arg1_24)

	if var1_24 then
		arg0_24:FlushAttrs(arg1_24)
	else
		arg0_24.uiUpgradeList:align(0)
	end

	arg0_24:UpdateAttrValue()
	setActive(arg0_24.emptyTr, not var1_24)
	setActive(arg0_24.delBtn, var1_24)
	setActive(arg0_24.maxBtn, var1_24)
end

function var0_0.FlushAttrs(arg0_25, arg1_25)
	local var0_25 = arg0_25.ship:GetUpgradeExtraAttrConsume(arg1_25)

	arg0_25.uiUpgradeList:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var0_25[arg1_26 + 1]

			updateCustomDrop(arg2_26, var0_26)

			local var1_26 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(var0_26.id)

			setText(arg2_26:Find("icon_bg/count_bg/count"), "X" .. var1_26)
			onButton(arg0_25, arg2_26, function()
				if not arg0_25:CanAddItemForAttrValue(arg1_25, arg0_25.selected) then
					return
				end

				arg0_25:OpenAtrrCalcPanel(arg2_26, var0_26)
			end, SFX_PANEL)
			onButton(arg0_25, arg2_26:Find("calc/bg"), function()
				arg0_25.selected[var0_26.id] = (arg0_25.selected[var0_26.id] or 0) - 1

				arg0_25:UpdateAttrCalcPanel(arg2_26, var0_26)
			end, SFX_PANEL)
			arg0_25:UpdateAttrCalcPanel(arg2_26, var0_26)
		end
	end)
	arg0_25.uiUpgradeList:align(#var0_25)
end

function var0_0.ClearUpdateAttrValue(arg0_29, arg1_29)
	if not arg1_29 or arg1_29 == "" then
		return
	end

	local var0_29 = arg0_29.ship
	local var1_29 = arg0_29.attrTrs[arg1_29]

	setText(var1_29:Find("value/value_1"), var0_29:GetAttr(arg1_29))
end

function var0_0.OpenAtrrCalcPanel(arg0_30, arg1_30, arg2_30)
	if getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(arg2_30.id) <= (arg0_30.selected[arg2_30.id] or 0) then
		return
	end

	arg0_30.selected[arg2_30.id] = (arg0_30.selected[arg2_30.id] or 0) + 1

	arg0_30:UpdateAttrCalcPanel(arg1_30, arg2_30)
end

function var0_0.UpdateAttrCalcPanel(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.selected[arg2_31.id] or 0

	setText(arg1_31:Find("calc/Text"), var0_31)
	setActive(arg1_31:Find("calc"), var0_31 > 0)
	arg0_31:UpdateAttrValue()
end

function var0_0.UpdateAttrValue(arg0_32)
	local var0_32 = arg0_32.slectedAttrName
	local var1_32 = arg0_32.attrTrs[var0_32]
	local var2_32 = arg0_32.ship
	local var3_32, var4_32, var5_32 = arg0_32:CanAddItemForAttrValue(var0_32, arg0_32.selected)
	local var6_32 = var5_32 <= var4_32 and "(MAX)" or string.format("(<color=#36a5fb>+%s</color>/%s)", var4_32, var5_32)

	setText(var1_32:Find("value/value_1"), var2_32:GetAttr(var0_32) .. var6_32)

	local var7_32 = arg0_32:NothingSelected() and not var3_32

	setGray(arg0_32.upgradeBtn, var7_32 or arg0_32:NothingSelected())
end

function var0_0.CanAddItemForAttrValue(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.ship
	local var1_33 = var0_33:GetExtraAttrValue(arg1_33)

	for iter0_33, iter1_33 in pairs(arg2_33 or {}) do
		local var2_33 = IslandItem.New({
			id = iter0_33
		})

		var1_33 = var1_33 + tonumber(var2_33:GetUseArg()) * iter1_33
	end

	local var3_33 = var0_33:GetExtraAttrLimit(arg1_33)

	return var1_33 < var3_33, var1_33, var3_33
end

function var0_0.FillSelected(arg0_34)
	arg0_34.selected = {}

	local var0_34 = arg0_34.ship:GetUpgradeExtraAttrConsume(arg0_34.slectedAttrName)
	local var1_34 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var2_34 = _.map(var0_34, function(arg0_35)
		return var1_34:GetItemById(arg0_35.id) or IslandItem.New({
			number = 0,
			id = arg0_35.id
		})
	end)

	table.sort(var2_34, function(arg0_36, arg1_36)
		return arg0_36:GetRarity() > arg1_36:GetRarity()
	end)

	local var3_34 = {}

	for iter0_34, iter1_34 in ipairs(var2_34) do
		for iter2_34 = 1, iter1_34.count do
			if arg0_34:CanAddItemForAttrValue(arg0_34.slectedAttrName, var3_34) then
				var3_34[iter1_34.id] = (var3_34[iter1_34.id] or 0) + 1
			else
				break
			end
		end
	end

	arg0_34.selected = var3_34

	arg0_34:FlushAttrs(arg0_34.slectedAttrName)
end

function var0_0.UpdateContent(arg0_37)
	if arg0_37.page == var1_0 then
		arg0_37.contentTxt.text = i18n("island_ship_lock_attr_tip")
	elseif arg0_37.page == var2_0 then
		arg0_37.contentTxt.text = i18n("island_ship_unlock_limit_tip")
	end
end

function var0_0.Confirm(arg0_38)
	if arg0_38.page == var1_0 then
		if not arg0_38.slectedAttrName or not arg0_38.ship then
			return
		end

		if arg0_38:NothingSelected() then
			return
		end

		if not arg0_38:CanAddItemForAttrValue(arg0_38.slectedAttrName) then
			return
		end

		local var0_38 = table.indexof(IslandShipAttr.ATTRS, arg0_38.slectedAttrName)

		if var0_38 <= 0 then
			return
		end

		arg0_38:emit(IslandMediator.SHIP_ATTR_UPGRADE, arg0_38.ship.id, var0_38, arg0_38.selected)
	elseif arg0_38.page == var2_0 then
		if arg0_38.ship:IsUnlockExtraAttLimit() then
			return
		end

		arg0_38:emit(IslandMediator.SHIP_ATTR_LIMIT_UNLOCK, arg0_38.ship.id)
	end
end

function var0_0.NothingSelected(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.selected) do
		if iter1_39 > 0 then
			return false
		end
	end

	return true
end

function var0_0.OnHide(arg0_40)
	arg0_40:UnBlurPanel()
end

function var0_0.OnDestroy(arg0_41)
	arg0_41:OnHide()
end

return var0_0
