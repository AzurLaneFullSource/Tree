local var0 = class("SpWeaponModifyLayer", BaseUI)

function var0.getUIName(arg0)
	return "SpWeaponModifyUI"
end

function var0.init(arg0)
	arg0.equipmentPanel = arg0:findTF("Main/panel/equipment_panel")
	arg0.materialPanel = arg0:findTF("Main/panel/material_panel")
	arg0.equipmentIcon = arg0:findTF("Icon", arg0.equipmentPanel)
	arg0.equipmentName = arg0:findTF("Name", arg0.equipmentPanel)
	arg0.attributeList = arg0:findTF("Attribute/Rect/Attrs", arg0.equipmentPanel)
	arg0.attributeButtons = arg0:findTF("Attribute/Rect/Buttons", arg0.equipmentPanel)
	arg0.attributeExchangeButton = arg0:findTF("Exchange", arg0.attributeButtons)
	arg0.attributeDiscardButton = arg0:findTF("Discard", arg0.attributeButtons)

	setText(arg0:findTF("Attribute/Text", arg0.equipmentPanel), i18n("spweapon_ui_transform_attr_text"))
	setText(arg0.attributeExchangeButton:Find("Text"), i18n("spweapon_ui_change_attr"))
	setText(arg0.attributeDiscardButton:Find("Text"), i18n("spweapon_ui_keep_attr"))

	arg0.materialItems = CustomIndexLayer.Clone2Full(arg0:findTF("materials/materials", arg0.materialPanel), 3)
	arg0.materialLimit = arg0:findTF("materials/limit", arg0.materialPanel)
	arg0.materialCostText = arg0:findTF("cost/consume", arg0.materialPanel)
	arg0.materialStartButton = arg0:findTF("start_btn", arg0.materialPanel)

	setText(arg0:findTF("materials/panel_title", arg0.materialPanel), i18n("spweapon_ui_need_resource"))
	setText(arg0.materialStartButton:Find("Image"), i18n("spweapon_ui_transform"))
end

function var0.SetSpweaponVO(arg0, arg1)
	arg0.spWeaponVO = arg1
end

function var0.SetItems(arg0, arg1)
	arg0.itemVOs = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("BG"), function()
		arg0:closeView()
	end)
	arg0:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.ResetMaterialMask(arg0)
	arg0.confirmUpgrade = nil
end

function var0.UpdateView(arg0)
	setText(arg0.equipmentName, arg0.spWeaponVO:GetName())

	local var0 = arg0.spWeaponVO:GetUpgradeConfig()

	table.Foreach(arg0.materialItems, function(arg0, arg1)
		local var0 = var0.reset_use_item[arg0]

		setActive(arg1:Find("Off"), not var0)
		setActive(arg1:Find("Icon"), var0)

		if var0 then
			local var1 = {
				id = var0[1],
				count = var0[2],
				type = DROP_TYPE_ITEM
			}

			updateDrop(arg1:Find("Icon"), var1)

			local var2 = defaultValue(arg0.itemVOs[var0[1]], {
				count = 0
			})
			local var3 = var2.count .. "/" .. var0[2]

			if var2.count < var0[2] then
				var3 = setColorStr(var2.count, COLOR_RED) .. "/" .. var0[2]
			end

			local var4 = arg1:Find("Icon/icon_bg/count")

			setText(var4, var3)
			onButton(arg0, arg1:Find("Icon"), function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end)

			local var5 = arg1:Find("Icon/Click")

			setActive(var5, not arg0.confirmUpgrade)
			onButton(arg0, var5, function()
				arg0.confirmUpgrade = true

				setActive(var5, not arg0.confirmUpgrade)
			end)
		end
	end)
	updateSpWeapon(arg0.equipmentIcon, arg0.spWeaponVO)

	local var1 = arg0.spWeaponVO:GetAttributeOptions()
	local var2 = arg0.spWeaponVO:GetBaseAttributes()
	local var3 = arg0.spWeaponVO:GetAttributesRange()
	local var4 = {
		arg0.spWeaponVO:getConfig("attribute_1"),
		arg0.spWeaponVO:getConfig("attribute_2")
	}
	local var5 = _.any(var1, function(arg0)
		return arg0 > 0
	end)
	local var6 = table.equal(var2, var3)

	setActive(arg0.attributeButtons, var5)
	UIItemList.StaticAlign(arg0.attributeList, arg0.attributeList:GetChild(0), #var2, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var2[arg1]
		local var1 = var3[arg1]
		local var2 = var1[arg1]
		local var3 = AttributeType.Type2Name(var4[arg1])

		setText(arg2:Find("Name"), var3)
		setText(arg2:Find("Values/Min/Value"), math.min(1, var1))
		setText(arg2:Find("Values/Max/Value"), var1)
		setText(arg2:Find("Values/Current/Value1"), var0)
		setText(arg2:Find("Values/Current/Value2"), var2)
		setActive(arg2:Find("Values/Current/Symbol"), var5)
		setActive(arg2:Find("Values/Current/Value2"), var5)
	end)
	onButton(arg0, arg0.materialStartButton, function()
		if not arg0.confirmUpgrade then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_transform_materal_check"))

			return
		end

		arg0:emit(SpWeaponModifyMediator.ON_REFORGE)
	end, SFX_PANEL)
	onButton(arg0, arg0.attributeExchangeButton, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON,
			op = SpWeapon.CONFIRM_OP_EXCHANGE,
			attrs = _.map({
				1,
				2
			}, function(arg0)
				local var0 = var2[arg0]
				local var1 = var1[arg0]
				local var2 = AttributeType.Type2Name(var4[arg0])

				return {
					var2,
					var0,
					var1
				}
			end),
			onYes = function()
				arg0:emit(SpWeaponModifyMediator.ON_CONFIRM_REFORGE, SpWeapon.CONFIRM_OP_EXCHANGE)
			end
		})
	end, SFX_CANCEL)
	onButton(arg0, arg0.attributeDiscardButton, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON,
			op = SpWeapon.CONFIRM_OP_DISCARD,
			attrs = _.map({
				1,
				2
			}, function(arg0)
				local var0 = var2[arg0]
				local var1 = var1[arg0]
				local var2 = AttributeType.Type2Name(var4[arg0])

				return {
					var2,
					var0,
					var1
				}
			end),
			onYes = function()
				arg0:emit(SpWeaponModifyMediator.ON_CONFIRM_REFORGE, SpWeapon.CONFIRM_OP_DISCARD)
			end
		})
	end, SFX_CANCEL)
	setGray(arg0.materialStartButton, var5 or var6)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
