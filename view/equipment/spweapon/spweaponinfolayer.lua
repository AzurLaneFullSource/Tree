local var0_0 = class("SpWeaponInfoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SpWeaponInfoUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/equipmentinfoui_atlas",
		"equiptype",
		"weaponframes",
		"shiptype"
	}

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

var0_0.Left = 1
var0_0.Middle = 2
var0_0.Right = 3
var0_0.pos = {
	{
		-353,
		30,
		0
	},
	{
		0,
		30,
		0
	},
	{
		353,
		30,
		0
	}
}
var0_0.TYPE_DEFAULT = 1
var0_0.TYPE_SHIP = 2
var0_0.TYPE_REPLACE = 3
var0_0.TYPE_DISPLAY = 4
var0_0.SHOW_UNIQUE = {
	1,
	2,
	3,
	4
}

function var0_0.init(arg0_3)
	local var0_3 = {
		"default",
		"replace",
		"display"
	}

	arg0_3.toggles = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		arg0_3[iter1_3 .. "Panel"] = arg0_3._tf:Find(iter1_3)
		arg0_3.toggles[iter1_3 .. "Panel"] = arg0_3._tf:Find("toggle_controll/" .. iter1_3)
	end

	Canvas.ForceUpdateCanvases()

	arg0_3.sample = arg0_3._tf:Find("sample")

	setActive(arg0_3.sample, false)

	arg0_3.txtQuickEnable = findTF(arg0_3._tf, "txtQuickEnable")

	setText(arg0_3.txtQuickEnable, i18n("ship_equip_check"))
	setText(arg0_3._tf:Find("sample/empty/Text"), i18n("spweapon_ui_empty"))
end

function var0_0.setEquipment(arg0_4, arg1_4, arg2_4)
	arg0_4.equipmentVO = arg1_4
	arg0_4.oldEquipmentVO = arg2_4
end

function var0_0.setShip(arg0_5, arg1_5, arg2_5)
	arg0_5.shipVO = arg1_5
	arg0_5.oldShipVO = arg2_5
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6
end

function var0_0.checkOverGold(arg0_7, arg1_7)
	local var0_7 = _.detect(arg1_7, function(arg0_8)
		return arg0_8.type == DROP_TYPE_RESOURCE and arg0_8.id == 1
	end).count or 0

	if arg0_7.player:GoldMax(var0_7) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.didEnter(arg0_9)
	setActive(arg0_9.txtQuickEnable, arg0_9.contextData.quickFlag or false)

	local var0_9 = defaultValue(arg0_9.contextData.type, var0_0.TYPE_DEFAULT)

	arg0_9.isShowUnique = table.contains(var0_0.SHOW_UNIQUE, var0_9)

	onButton(arg0_9, arg0_9._tf:Find("bg"), function()
		arg0_9:closeView()
	end, SOUND_BACK)
	arg0_9:initAndSetBtn(var0_9)

	if var0_9 == var0_0.TYPE_DEFAULT then
		arg0_9:updateOperation1()
	elseif var0_9 == var0_0.TYPE_SHIP then
		arg0_9:updateOperation2()
	elseif var0_9 == var0_0.TYPE_REPLACE then
		arg0_9:updateOperation3()
	elseif var0_9 == var0_0.TYPE_DISPLAY then
		arg0_9:updateOperation4()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf, {
		staticBlur = true
	})
end

local var1_0 = {
	{
		"Enhance",
		"msgbox_text_noPos_intensify"
	},
	{
		"Replace",
		"msgbox_text_replace"
	},
	{
		"Unload",
		"msgbox_text_unload"
	},
	{
		"Modify",
		"msgbox_text_modify"
	}
}

function var0_0.initAndSetBtn(arg0_11, arg1_11)
	if arg1_11 == var0_0.TYPE_DEFAULT or arg1_11 == var0_0.TYPE_SHIP then
		arg0_11.defaultEquipTF = arg0_11.defaultPanel:Find("equipment") or arg0_11:cloneSampleTo(arg0_11.defaultPanel, var0_0.Middle, "equipment")

		table.Foreach(var1_0, function(arg0_12, arg1_12)
			local var0_12 = arg0_11.defaultPanel:Find("actions/action_button_" .. arg0_12)

			arg0_11["default" .. arg1_12[1] .. "Btn"] = var0_12

			setText(var0_12:GetChild(0), i18n(arg1_12[2]))
		end)
		onButton(arg0_11, arg0_11.defaultReplaceBtn, function()
			arg0_11:emit(SpWeaponInfoMediator.ON_CHANGE)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.defaultEnhanceBtn, function()
			arg0_11:emit(SpWeaponInfoMediator.ON_INTENSIFY)
		end, SFX_PANEL)
		onButton(arg0_11, arg0_11.defaultUnloadBtn, function()
			arg0_11:emit(SpWeaponInfoMediator.ON_UNEQUIP)
		end, SFX_UI_DOCKYARD_EQUIPOFF)
		onButton(arg0_11, arg0_11.defaultModifyBtn, function()
			arg0_11:emit(SpWeaponInfoMediator.ON_MODIFY)
		end, SFX_PANEL)
	elseif arg1_11 == var0_0.TYPE_REPLACE then
		arg0_11.replaceSrcEquipTF = arg0_11.replacePanel:Find("equipment") or arg0_11:cloneSampleTo(arg0_11.replacePanel, var0_0.Left, "equipment")
		arg0_11.replaceDstEquipTF = arg0_11.replacePanel:Find("equipment_on_ship") or arg0_11:cloneSampleTo(arg0_11.replacePanel, var0_0.Right, "equipment_on_ship")
		arg0_11.replaceCancelBtn = arg0_11.replacePanel:Find("actions/cancel_button")
		arg0_11.replaceConfirmBtn = arg0_11.replacePanel:Find("actions/action_button_2")

		setText(arg0_11.replaceConfirmBtn:Find("label"), i18n("msgbox_text_confirm"))
		setText(arg0_11.replaceCancelBtn:Find("label"), i18n("msgbox_text_cancel"))
		onButton(arg0_11, arg0_11.replaceCancelBtn, function()
			arg0_11:closeView()
		end, SFX_CANCEL)
		onButton(arg0_11, arg0_11.replaceConfirmBtn, function()
			if arg0_11.contextData.quickCallback then
				arg0_11.contextData.quickCallback()
				arg0_11:closeView()
			else
				arg0_11:emit(SpWeaponInfoMediator.ON_EQUIP)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	elseif arg1_11 == var0_0.TYPE_DISPLAY then
		arg0_11.displayEquipTF = arg0_11.displayPanel:Find("equipment") or arg0_11:cloneSampleTo(arg0_11.displayPanel, var0_0.Middle, "equipment")
		arg0_11.displayMoveBtn = arg0_11.displayPanel:Find("actions/move_button")

		setText(arg0_11.displayMoveBtn:Find("label"), i18n("msgbox_text_equipdetail"))
		onButton(arg0_11, arg0_11.displayMoveBtn, function()
			arg0_11:emit(SpWeaponInfoMediator.ON_MOVE, arg0_11.shipVO.id)
		end)
	end
end

function var0_0.updateOperation1(arg0_20)
	triggerToggle(arg0_20.toggles.defaultPanel, true)

	if not arg0_20.equipmentVO then
		local var0_20 = arg0_20.contextData.spWeaponUid

		if var0_20 then
			arg0_20.equipmentVO = getProxy(EquipmentProxy):GetSpWeaponByUid(var0_20)

			if not arg0_20.equipmentVO then
				local var1_20 = getProxy(BayProxy)

				for iter0_20, iter1_20 in pairs(var1_20:getRawData()) do
					local var2_20 = iter1_20:GetSpWeapon()

					if var2_20 and var2_20:GetUID() == var0_20 then
						arg0_20.shipVO = var1_20:getShipById(iter0_20)
						arg0_20.equipmentVO = arg0_20.shipVO:GetSpWeapon()
						arg0_20.contextData.shipId = iter0_20
						arg0_20.contextData.type = var0_0.TYPE_SHIP
					end
				end
			end
		end
	end

	arg0_20:updateEquipmentPanel(arg0_20.defaultEquipTF, arg0_20.equipmentVO, SpWeaponHelper.TransformNormalInfo(arg0_20.equipmentVO))
	setActive(arg0_20.defaultEnhanceBtn, true)
	setActive(arg0_20.defaultReplaceBtn, false)
	setActive(arg0_20.defaultUnloadBtn, false)
	setActive(arg0_20.defaultModifyBtn, true)
end

function var0_0.updateOperation2(arg0_21)
	triggerToggle(arg0_21.toggles.defaultPanel, true)

	local var0_21 = arg0_21.shipVO:GetSpWeapon()

	arg0_21:updateEquipmentPanel(arg0_21.defaultEquipTF, var0_21, SpWeaponHelper.TransformNormalInfo(var0_21))
	setActive(arg0_21.defaultEnhanceBtn, true)
	setActive(arg0_21.defaultReplaceBtn, true)
	setActive(arg0_21.defaultUnloadBtn, true)
	setActive(arg0_21.defaultModifyBtn, true)

	local var1_21 = arg0_21.defaultEquipTF:Find("head")

	setActive(var1_21, arg0_21.shipVO)

	if arg0_21.shipVO then
		setImageSprite(findTF(var1_21, "Image"), LoadSprite("qicon/" .. arg0_21.shipVO:getPainting()))
	end
end

function var0_0.updateOperation3(arg0_22)
	triggerToggle(arg0_22.toggles.replacePanel, true)

	local var0_22 = arg0_22.equipmentVO

	if var0_22 then
		local var1_22, var2_22 = SpWeaponHelper.CompareNormalInfo(var0_22, arg0_22.oldEquipmentVO)

		arg0_22:updateEquipmentPanel(arg0_22.replaceSrcEquipTF, var0_22, var1_22)
		arg0_22:updateEquipmentPanel(arg0_22.replaceDstEquipTF, arg0_22.oldEquipmentVO, var2_22)
	else
		arg0_22:updateEquipmentPanel(arg0_22.replaceSrcEquipTF, nil)
		arg0_22:updateEquipmentPanel(arg0_22.replaceDstEquipTF, arg0_22.oldEquipmentVO, SpWeaponHelper.TransformNormalInfo(arg0_22.oldEquipmentVO))
	end

	local var3_22 = arg0_22.replaceDstEquipTF:Find("head")

	setActive(var3_22, arg0_22.oldShipVO)

	if arg0_22.oldShipVO then
		setImageSprite(findTF(var3_22, "Image"), LoadSprite("qicon/" .. arg0_22.oldShipVO:getPainting()))
	end
end

function var0_0.updateOperation4(arg0_23)
	triggerToggle(arg0_23.toggles.displayPanel, true)
	arg0_23:updateEquipmentPanel(arg0_23.displayEquipTF, arg0_23.equipmentVO, SpWeaponHelper.TransformNormalInfo(arg0_23.equipmentVO))
	setActive(arg0_23.displayMoveBtn, arg0_23.shipVO)

	local var0_23 = arg0_23.displayEquipTF:Find("head")

	setActive(var0_23, arg0_23.shipVO)

	if arg0_23.shipVO then
		setImageSprite(findTF(var0_23, "Image"), LoadSprite("qicon/" .. arg0_23.shipVO:getPainting()))
	end
end

function var0_0.updateOperationAward(arg0_24, arg1_24, arg2_24, arg3_24)
	arg0_24.awards = arg3_24

	if arg1_24.childCount == 0 then
		for iter0_24 = 1, #arg3_24 do
			cloneTplTo(arg2_24, arg1_24)
		end
	end

	for iter1_24 = 1, #arg3_24 do
		local var0_24 = arg1_24:GetChild(iter1_24 - 1)
		local var1_24 = arg3_24[iter1_24]

		updateDrop(var0_24, var1_24)
		onButton(arg0_24, var0_24, function()
			arg0_24:emit(var0_0.ON_DROP, var1_24)
		end, SFX_PANEL)
		setText(findTF(var0_24, "name_panel/name"), getText(findTF(var0_24, "name")))
		setText(findTF(var0_24, "name_panel/number"), " x " .. getText(findTF(var0_24, "icon_bg/count")))
		setActive(findTF(var0_24, "icon_bg/count"), false)
	end
end

function var0_0.updateEquipmentPanel(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg1_26:Find("info")
	local var1_26 = arg1_26:Find("empty")

	setActive(var0_26, arg2_26)
	setActive(var1_26, not arg2_26)

	if not arg2_26 then
		return
	end

	local var2_26 = findTF(var0_26, "name")

	setScrollText(findTF(var2_26, "mask/Text"), arg2_26:GetName())

	local var3_26 = findTF(var0_26, "equip")

	setImageSprite(findTF(var3_26, "bg"), GetSpriteFromAtlas("ui/equipmentinfoui_atlas", "equip_bg_" .. ItemRarity.Rarity2Print(arg2_26:GetRarity())))
	updateSpWeapon(var3_26, arg2_26, {
		noIconColorful = true
	})
	setActive(findTF(var3_26, "slv"), arg2_26:GetLevel() > 1)
	setText(findTF(var3_26, "slv/Text"), arg2_26:GetLevel() - 1)
	setActive(findTF(var3_26, "slv/next"), false)
	setText(findTF(var3_26, "slv/next/Text"), arg2_26:GetLevel() - 1)

	local var4_26 = var3_26:Find("tier")

	setActive(var4_26, arg2_26)

	local var5_26 = arg2_26:GetTechTier()

	eachChild(var4_26, function(arg0_27)
		setActive(arg0_27, tostring(var5_26) == arg0_27.gameObject.name)
	end)
	updateSpWeaponInfo(var0_26:Find("attributes/view/content"), arg3_26, arg2_26:GetSkillGroup())

	local var6_26 = arg1_26:Find("info/unique")

	setActive(var6_26, arg2_26:IsUnique())

	if arg2_26:IsUnique() then
		arg0_26:updateUnique(var6_26, arg2_26)
	end
end

function var0_0.updateUnique(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg1_28:Find("btn_skip")
	local var1_28 = arg2_28:GetUniqueShips()
	local var2_28 = ShipGroup.getDefaultShipConfig(arg2_28:GetUniqueGroup())
	local var3_28 = Ship.New({
		configId = var2_28.id
	})

	setImageSprite(arg1_28:Find("head/icon"), LoadSprite("SquareIcon/" .. var3_28:getPainting()))
	setText(arg1_28:Find("title"), i18n("spweapon_unique_title"))
	setText(arg1_28:Find("btn_skip/text"), i18n("spweapon_tip_jump"))
	onButton(arg0_28, var0_28, function()
		arg0_28:emit(SpWeaponInfoMediator.ON_SKIP_UNIQUE_SHIPS, {
			shipId = var3_28.id,
			shipVOs = var1_28
		})
	end)
end

function var0_0.cloneSampleTo(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	local var0_30 = cloneTplTo(arg0_30.sample, arg1_30, arg3_30)

	var0_30.localPosition = Vector3.New(var0_0.pos[arg2_30][1], var0_0.pos[arg2_30][2], var0_0.pos[arg2_30][3])

	if arg4_30 then
		var0_30:SetSiblingIndex(arg4_30)
	end

	return var0_30
end

function var0_0.willExit(arg0_31)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_31._tf)
end

function var0_0.onBackPressed(arg0_32)
	arg0_32:closeView()
end

return var0_0
