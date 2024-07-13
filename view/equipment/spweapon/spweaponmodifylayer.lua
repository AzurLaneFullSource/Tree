local var0_0 = class("SpWeaponModifyLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "SpWeaponModifyUI"
end

function var0_0.init(arg0_2)
	arg0_2.equipmentPanel = arg0_2:findTF("Main/panel/equipment_panel")
	arg0_2.materialPanel = arg0_2:findTF("Main/panel/material_panel")
	arg0_2.equipmentIcon = arg0_2:findTF("Icon", arg0_2.equipmentPanel)
	arg0_2.equipmentName = arg0_2:findTF("Name", arg0_2.equipmentPanel)
	arg0_2.attributeList = arg0_2:findTF("Attribute/Rect/Attrs", arg0_2.equipmentPanel)
	arg0_2.attributeButtons = arg0_2:findTF("Attribute/Rect/Buttons", arg0_2.equipmentPanel)
	arg0_2.attributeExchangeButton = arg0_2:findTF("Exchange", arg0_2.attributeButtons)
	arg0_2.attributeDiscardButton = arg0_2:findTF("Discard", arg0_2.attributeButtons)

	setText(arg0_2:findTF("Attribute/Text", arg0_2.equipmentPanel), i18n("spweapon_ui_transform_attr_text"))
	setText(arg0_2.attributeExchangeButton:Find("Text"), i18n("spweapon_ui_change_attr"))
	setText(arg0_2.attributeDiscardButton:Find("Text"), i18n("spweapon_ui_keep_attr"))

	arg0_2.materialItems = CustomIndexLayer.Clone2Full(arg0_2:findTF("materials/materials", arg0_2.materialPanel), 3)
	arg0_2.materialLimit = arg0_2:findTF("materials/limit", arg0_2.materialPanel)
	arg0_2.materialCostText = arg0_2:findTF("cost/consume", arg0_2.materialPanel)
	arg0_2.materialStartButton = arg0_2:findTF("start_btn", arg0_2.materialPanel)

	setText(arg0_2:findTF("materials/panel_title", arg0_2.materialPanel), i18n("spweapon_ui_need_resource"))
	setText(arg0_2.materialStartButton:Find("Image"), i18n("spweapon_ui_transform"))
end

function var0_0.SetSpweaponVO(arg0_3, arg1_3)
	arg0_3.spWeaponVO = arg1_3
end

function var0_0.SetItems(arg0_4, arg1_4)
	arg0_4.itemVOs = arg1_4
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5:findTF("BG"), function()
		arg0_5:closeView()
	end)
	arg0_5:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
end

function var0_0.ResetMaterialMask(arg0_7)
	arg0_7.confirmUpgrade = nil
end

function var0_0.UpdateView(arg0_8)
	setText(arg0_8.equipmentName, arg0_8.spWeaponVO:GetName())

	local var0_8 = arg0_8.spWeaponVO:GetUpgradeConfig()

	table.Foreach(arg0_8.materialItems, function(arg0_9, arg1_9)
		local var0_9 = var0_8.reset_use_item[arg0_9]

		setActive(arg1_9:Find("Off"), not var0_9)
		setActive(arg1_9:Find("Icon"), var0_9)

		if var0_9 then
			local var1_9 = {
				id = var0_9[1],
				count = var0_9[2],
				type = DROP_TYPE_ITEM
			}

			updateDrop(arg1_9:Find("Icon"), var1_9)

			local var2_9 = defaultValue(arg0_8.itemVOs[var0_9[1]], {
				count = 0
			})
			local var3_9 = var2_9.count .. "/" .. var0_9[2]

			if var2_9.count < var0_9[2] then
				var3_9 = setColorStr(var2_9.count, COLOR_RED) .. "/" .. var0_9[2]
			end

			local var4_9 = arg1_9:Find("Icon/icon_bg/count")

			setText(var4_9, var3_9)
			onButton(arg0_8, arg1_9:Find("Icon"), function()
				arg0_8:emit(BaseUI.ON_DROP, var1_9)
			end)

			local var5_9 = arg1_9:Find("Icon/Click")

			setActive(var5_9, not arg0_8.confirmUpgrade)
			onButton(arg0_8, var5_9, function()
				arg0_8.confirmUpgrade = true

				setActive(var5_9, not arg0_8.confirmUpgrade)
			end)
		end
	end)
	updateSpWeapon(arg0_8.equipmentIcon, arg0_8.spWeaponVO)

	local var1_8 = arg0_8.spWeaponVO:GetAttributeOptions()
	local var2_8 = arg0_8.spWeaponVO:GetBaseAttributes()
	local var3_8 = arg0_8.spWeaponVO:GetAttributesRange()
	local var4_8 = {
		arg0_8.spWeaponVO:getConfig("attribute_1"),
		arg0_8.spWeaponVO:getConfig("attribute_2")
	}
	local var5_8 = _.any(var1_8, function(arg0_12)
		return arg0_12 > 0
	end)
	local var6_8 = table.equal(var2_8, var3_8)

	setActive(arg0_8.attributeButtons, var5_8)
	UIItemList.StaticAlign(arg0_8.attributeList, arg0_8.attributeList:GetChild(0), #var2_8, function(arg0_13, arg1_13, arg2_13)
		if arg0_13 ~= UIItemList.EventUpdate then
			return
		end

		arg1_13 = arg1_13 + 1

		local var0_13 = var2_8[arg1_13]
		local var1_13 = var3_8[arg1_13]
		local var2_13 = var1_8[arg1_13]
		local var3_13 = AttributeType.Type2Name(var4_8[arg1_13])

		setText(arg2_13:Find("Name"), var3_13)
		setText(arg2_13:Find("Values/Min/Value"), math.min(1, var1_13))
		setText(arg2_13:Find("Values/Max/Value"), var1_13)
		setText(arg2_13:Find("Values/Current/Value1"), var0_13)
		setText(arg2_13:Find("Values/Current/Value2"), var2_13)
		setActive(arg2_13:Find("Values/Current/Symbol"), var5_8)
		setActive(arg2_13:Find("Values/Current/Value2"), var5_8)
	end)
	onButton(arg0_8, arg0_8.materialStartButton, function()
		if not arg0_8.confirmUpgrade then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_transform_materal_check"))

			return
		end

		arg0_8:emit(SpWeaponModifyMediator.ON_REFORGE)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.attributeExchangeButton, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON,
			op = SpWeapon.CONFIRM_OP_EXCHANGE,
			attrs = _.map({
				1,
				2
			}, function(arg0_16)
				local var0_16 = var2_8[arg0_16]
				local var1_16 = var1_8[arg0_16]
				local var2_16 = AttributeType.Type2Name(var4_8[arg0_16])

				return {
					var2_16,
					var0_16,
					var1_16
				}
			end),
			onYes = function()
				arg0_8:emit(SpWeaponModifyMediator.ON_CONFIRM_REFORGE, SpWeapon.CONFIRM_OP_EXCHANGE)
			end
		})
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.attributeDiscardButton, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON,
			op = SpWeapon.CONFIRM_OP_DISCARD,
			attrs = _.map({
				1,
				2
			}, function(arg0_19)
				local var0_19 = var2_8[arg0_19]
				local var1_19 = var1_8[arg0_19]
				local var2_19 = AttributeType.Type2Name(var4_8[arg0_19])

				return {
					var2_19,
					var0_19,
					var1_19
				}
			end),
			onYes = function()
				arg0_8:emit(SpWeaponModifyMediator.ON_CONFIRM_REFORGE, SpWeapon.CONFIRM_OP_DISCARD)
			end
		})
	end, SFX_CANCEL)
	setGray(arg0_8.materialStartButton, var5_8 or var6_8)
end

function var0_0.willExit(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf)
end

return var0_0
