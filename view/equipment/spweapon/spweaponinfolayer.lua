local var0_0 = class("SpWeaponInfoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SpWeaponInfoUI"
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

function var0_0.init(arg0_2)
	local var0_2 = {
		"default",
		"replace",
		"display"
	}

	arg0_2.toggles = {}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		arg0_2[iter1_2 .. "Panel"] = arg0_2:findTF(iter1_2)
		arg0_2.toggles[iter1_2 .. "Panel"] = arg0_2:findTF("toggle_controll/" .. iter1_2)
	end

	Canvas.ForceUpdateCanvases()

	arg0_2.sample = arg0_2:findTF("sample")

	setActive(arg0_2.sample, false)

	arg0_2.txtQuickEnable = findTF(arg0_2._tf, "txtQuickEnable")

	setText(arg0_2.txtQuickEnable, i18n("ship_equip_check"))
	setText(arg0_2._tf:Find("sample/empty/Text"), i18n("spweapon_ui_empty"))
end

function var0_0.setEquipment(arg0_3, arg1_3, arg2_3)
	arg0_3.equipmentVO = arg1_3
	arg0_3.oldEquipmentVO = arg2_3
end

function var0_0.setShip(arg0_4, arg1_4, arg2_4)
	arg0_4.shipVO = arg1_4
	arg0_4.oldShipVO = arg2_4
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5
end

function var0_0.checkOverGold(arg0_6, arg1_6)
	local var0_6 = _.detect(arg1_6, function(arg0_7)
		return arg0_7.type == DROP_TYPE_RESOURCE and arg0_7.id == 1
	end).count or 0

	if arg0_6.player:GoldMax(var0_6) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0_0.didEnter(arg0_8)
	setActive(arg0_8.txtQuickEnable, arg0_8.contextData.quickFlag or false)

	local var0_8 = defaultValue(arg0_8.contextData.type, var0_0.TYPE_DEFAULT)

	arg0_8.isShowUnique = table.contains(var0_0.SHOW_UNIQUE, var0_8)

	onButton(arg0_8, arg0_8._tf:Find("bg"), function()
		arg0_8:closeView()
	end, SOUND_BACK)
	arg0_8:initAndSetBtn(var0_8)

	if var0_8 == var0_0.TYPE_DEFAULT then
		arg0_8:updateOperation1()
	elseif var0_8 == var0_0.TYPE_SHIP then
		arg0_8:updateOperation2()
	elseif var0_8 == var0_0.TYPE_REPLACE then
		arg0_8:updateOperation3()
	elseif var0_8 == var0_0.TYPE_DISPLAY then
		arg0_8:updateOperation4()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf, false, {
		weight = arg0_8:getWeightFromData()
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

function var0_0.initAndSetBtn(arg0_10, arg1_10)
	if arg1_10 == var0_0.TYPE_DEFAULT or arg1_10 == var0_0.TYPE_SHIP then
		arg0_10.defaultEquipTF = arg0_10:findTF("equipment", arg0_10.defaultPanel) or arg0_10:cloneSampleTo(arg0_10.defaultPanel, var0_0.Middle, "equipment")

		table.Foreach(var1_0, function(arg0_11, arg1_11)
			local var0_11 = arg0_10:findTF("actions/action_button_" .. arg0_11, arg0_10.defaultPanel)

			arg0_10["default" .. arg1_11[1] .. "Btn"] = var0_11

			setText(var0_11:GetChild(0), i18n(arg1_11[2]))
		end)
		onButton(arg0_10, arg0_10.defaultReplaceBtn, function()
			arg0_10:emit(SpWeaponInfoMediator.ON_CHANGE)
		end, SFX_PANEL)
		onButton(arg0_10, arg0_10.defaultEnhanceBtn, function()
			arg0_10:emit(SpWeaponInfoMediator.ON_INTENSIFY)
		end, SFX_PANEL)
		onButton(arg0_10, arg0_10.defaultUnloadBtn, function()
			arg0_10:emit(SpWeaponInfoMediator.ON_UNEQUIP)
		end, SFX_UI_DOCKYARD_EQUIPOFF)
		onButton(arg0_10, arg0_10.defaultModifyBtn, function()
			arg0_10:emit(SpWeaponInfoMediator.ON_MODIFY)
		end, SFX_PANEL)
	elseif arg1_10 == var0_0.TYPE_REPLACE then
		arg0_10.replaceSrcEquipTF = arg0_10:findTF("equipment", arg0_10.replacePanel) or arg0_10:cloneSampleTo(arg0_10.replacePanel, var0_0.Left, "equipment")
		arg0_10.replaceDstEquipTF = arg0_10:findTF("equipment_on_ship", arg0_10.replacePanel) or arg0_10:cloneSampleTo(arg0_10.replacePanel, var0_0.Right, "equipment_on_ship")
		arg0_10.replaceCancelBtn = arg0_10:findTF("actions/cancel_button", arg0_10.replacePanel)
		arg0_10.replaceConfirmBtn = arg0_10:findTF("actions/action_button_2", arg0_10.replacePanel)

		setText(arg0_10.replaceConfirmBtn:Find("label"), i18n("msgbox_text_confirm"))
		setText(arg0_10.replaceCancelBtn:Find("label"), i18n("msgbox_text_cancel"))
		onButton(arg0_10, arg0_10.replaceCancelBtn, function()
			arg0_10:closeView()
		end, SFX_CANCEL)
		onButton(arg0_10, arg0_10.replaceConfirmBtn, function()
			if arg0_10.contextData.quickCallback then
				arg0_10.contextData.quickCallback()
				arg0_10:closeView()
			else
				arg0_10:emit(SpWeaponInfoMediator.ON_EQUIP)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	elseif arg1_10 == var0_0.TYPE_DISPLAY then
		arg0_10.displayEquipTF = arg0_10:findTF("equipment", arg0_10.displayPanel) or arg0_10:cloneSampleTo(arg0_10.displayPanel, var0_0.Middle, "equipment")
		arg0_10.displayMoveBtn = arg0_10:findTF("actions/move_button", arg0_10.displayPanel)

		setText(arg0_10.displayMoveBtn:Find("label"), i18n("msgbox_text_equipdetail"))
		onButton(arg0_10, arg0_10.displayMoveBtn, function()
			arg0_10:emit(SpWeaponInfoMediator.ON_MOVE, arg0_10.shipVO.id)
		end)
	end
end

function var0_0.updateOperation1(arg0_19)
	triggerToggle(arg0_19.toggles.defaultPanel, true)
	arg0_19:updateEquipmentPanel(arg0_19.defaultEquipTF, arg0_19.equipmentVO, SpWeaponHelper.TransformNormalInfo(arg0_19.equipmentVO))
	setActive(arg0_19.defaultEnhanceBtn, true)
	setActive(arg0_19.defaultReplaceBtn, false)
	setActive(arg0_19.defaultUnloadBtn, false)
	setActive(arg0_19.defaultModifyBtn, true)
end

function var0_0.updateOperation2(arg0_20)
	triggerToggle(arg0_20.toggles.defaultPanel, true)

	local var0_20 = arg0_20.shipVO:GetSpWeapon()

	arg0_20:updateEquipmentPanel(arg0_20.defaultEquipTF, var0_20, SpWeaponHelper.TransformNormalInfo(var0_20))
	setActive(arg0_20.defaultEnhanceBtn, true)
	setActive(arg0_20.defaultReplaceBtn, true)
	setActive(arg0_20.defaultUnloadBtn, true)
	setActive(arg0_20.defaultModifyBtn, true)

	local var1_20 = arg0_20:findTF("head", arg0_20.defaultEquipTF)

	setActive(var1_20, arg0_20.shipVO)

	if arg0_20.shipVO then
		setImageSprite(findTF(var1_20, "Image"), LoadSprite("qicon/" .. arg0_20.shipVO:getPainting()))
	end
end

function var0_0.updateOperation3(arg0_21)
	triggerToggle(arg0_21.toggles.replacePanel, true)

	local var0_21 = arg0_21.equipmentVO

	if var0_21 then
		local var1_21, var2_21 = SpWeaponHelper.CompareNormalInfo(var0_21, arg0_21.oldEquipmentVO)

		arg0_21:updateEquipmentPanel(arg0_21.replaceSrcEquipTF, var0_21, var1_21)
		arg0_21:updateEquipmentPanel(arg0_21.replaceDstEquipTF, arg0_21.oldEquipmentVO, var2_21)
	else
		arg0_21:updateEquipmentPanel(arg0_21.replaceSrcEquipTF, nil)
		arg0_21:updateEquipmentPanel(arg0_21.replaceDstEquipTF, arg0_21.oldEquipmentVO, SpWeaponHelper.TransformNormalInfo(arg0_21.oldEquipmentVO))
	end

	local var3_21 = arg0_21:findTF("head", arg0_21.replaceDstEquipTF)

	setActive(var3_21, arg0_21.oldShipVO)

	if arg0_21.oldShipVO then
		setImageSprite(findTF(var3_21, "Image"), LoadSprite("qicon/" .. arg0_21.oldShipVO:getPainting()))
	end
end

function var0_0.updateOperation4(arg0_22)
	triggerToggle(arg0_22.toggles.displayPanel, true)
	arg0_22:updateEquipmentPanel(arg0_22.displayEquipTF, arg0_22.equipmentVO, SpWeaponHelper.TransformNormalInfo(arg0_22.equipmentVO))
	setActive(arg0_22.displayMoveBtn, arg0_22.shipVO)

	local var0_22 = arg0_22:findTF("head", arg0_22.displayEquipTF)

	setActive(var0_22, arg0_22.shipVO)

	if arg0_22.shipVO then
		setImageSprite(findTF(var0_22, "Image"), LoadSprite("qicon/" .. arg0_22.shipVO:getPainting()))
	end
end

function var0_0.updateOperationAward(arg0_23, arg1_23, arg2_23, arg3_23)
	arg0_23.awards = arg3_23

	if arg1_23.childCount == 0 then
		for iter0_23 = 1, #arg3_23 do
			cloneTplTo(arg2_23, arg1_23)
		end
	end

	for iter1_23 = 1, #arg3_23 do
		local var0_23 = arg1_23:GetChild(iter1_23 - 1)
		local var1_23 = arg3_23[iter1_23]

		updateDrop(var0_23, var1_23)
		onButton(arg0_23, var0_23, function()
			arg0_23:emit(var0_0.ON_DROP, var1_23)
		end, SFX_PANEL)
		setText(findTF(var0_23, "name_panel/name"), getText(findTF(var0_23, "name")))
		setText(findTF(var0_23, "name_panel/number"), " x " .. getText(findTF(var0_23, "icon_bg/count")))
		setActive(findTF(var0_23, "icon_bg/count"), false)
	end
end

function var0_0.updateEquipmentPanel(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = arg0_25:findTF("info", arg1_25)
	local var1_25 = arg0_25:findTF("empty", arg1_25)

	setActive(var0_25, arg2_25)
	setActive(var1_25, not arg2_25)

	if not arg2_25 then
		return
	end

	local var2_25 = findTF(var0_25, "name")

	setScrollText(findTF(var2_25, "mask/Text"), arg2_25:GetName())

	local var3_25 = findTF(var0_25, "equip")

	setImageSprite(findTF(var3_25, "bg"), GetSpriteFromAtlas("ui/equipmentinfoui_atlas", "equip_bg_" .. ItemRarity.Rarity2Print(arg2_25:GetRarity())))
	updateSpWeapon(var3_25, arg2_25, {
		noIconColorful = true
	})
	setActive(findTF(var3_25, "slv"), arg2_25:GetLevel() > 1)
	setText(findTF(var3_25, "slv/Text"), arg2_25:GetLevel() - 1)
	setActive(findTF(var3_25, "slv/next"), false)
	setText(findTF(var3_25, "slv/next/Text"), arg2_25:GetLevel() - 1)

	local var4_25 = arg0_25:findTF("tier", var3_25)

	setActive(var4_25, arg2_25)

	local var5_25 = arg2_25:GetTechTier()

	eachChild(var4_25, function(arg0_26)
		setActive(arg0_26, tostring(var5_25) == arg0_26.gameObject.name)
	end)
	updateSpWeaponInfo(var0_25:Find("attributes/view/content"), arg3_25, arg2_25:GetSkillGroup())
end

function var0_0.cloneSampleTo(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
	local var0_27 = cloneTplTo(arg0_27.sample, arg1_27, arg3_27)

	var0_27.localPosition = Vector3.New(var0_0.pos[arg2_27][1], var0_0.pos[arg2_27][2], var0_0.pos[arg2_27][3])

	if arg4_27 then
		var0_27:SetSiblingIndex(arg4_27)
	end

	return var0_27
end

function var0_0.willExit(arg0_28)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_28._tf)
end

function var0_0.onBackPressed(arg0_29)
	arg0_29:closeView()
end

return var0_0
