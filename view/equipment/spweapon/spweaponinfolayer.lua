local var0 = class("SpWeaponInfoLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "SpWeaponInfoUI"
end

var0.Left = 1
var0.Middle = 2
var0.Right = 3
var0.pos = {
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
var0.TYPE_DEFAULT = 1
var0.TYPE_SHIP = 2
var0.TYPE_REPLACE = 3
var0.TYPE_DISPLAY = 4
var0.SHOW_UNIQUE = {
	1,
	2,
	3,
	4
}

function var0.init(arg0)
	local var0 = {
		"default",
		"replace",
		"display"
	}

	arg0.toggles = {}

	for iter0, iter1 in ipairs(var0) do
		arg0[iter1 .. "Panel"] = arg0:findTF(iter1)
		arg0.toggles[iter1 .. "Panel"] = arg0:findTF("toggle_controll/" .. iter1)
	end

	Canvas.ForceUpdateCanvases()

	arg0.sample = arg0:findTF("sample")

	setActive(arg0.sample, false)

	arg0.txtQuickEnable = findTF(arg0._tf, "txtQuickEnable")

	setText(arg0.txtQuickEnable, i18n("ship_equip_check"))
	setText(arg0._tf:Find("sample/empty/Text"), i18n("spweapon_ui_empty"))
end

function var0.setEquipment(arg0, arg1, arg2)
	arg0.equipmentVO = arg1
	arg0.oldEquipmentVO = arg2
end

function var0.setShip(arg0, arg1, arg2)
	arg0.shipVO = arg1
	arg0.oldShipVO = arg2
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.checkOverGold(arg0, arg1)
	local var0 = _.detect(arg1, function(arg0)
		return arg0.type == DROP_TYPE_RESOURCE and arg0.id == 1
	end).count or 0

	if arg0.player:GoldMax(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_destroy"))

		return false
	end

	return true
end

function var0.didEnter(arg0)
	setActive(arg0.txtQuickEnable, arg0.contextData.quickFlag or false)

	local var0 = defaultValue(arg0.contextData.type, var0.TYPE_DEFAULT)

	arg0.isShowUnique = table.contains(var0.SHOW_UNIQUE, var0)

	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SOUND_BACK)
	arg0:initAndSetBtn(var0)

	if var0 == var0.TYPE_DEFAULT then
		arg0:updateOperation1()
	elseif var0 == var0.TYPE_SHIP then
		arg0:updateOperation2()
	elseif var0 == var0.TYPE_REPLACE then
		arg0:updateOperation3()
	elseif var0 == var0.TYPE_DISPLAY then
		arg0:updateOperation4()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = arg0:getWeightFromData()
	})
end

local var1 = {
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

function var0.initAndSetBtn(arg0, arg1)
	if arg1 == var0.TYPE_DEFAULT or arg1 == var0.TYPE_SHIP then
		arg0.defaultEquipTF = arg0:findTF("equipment", arg0.defaultPanel) or arg0:cloneSampleTo(arg0.defaultPanel, var0.Middle, "equipment")

		table.Foreach(var1, function(arg0, arg1)
			local var0 = arg0:findTF("actions/action_button_" .. arg0, arg0.defaultPanel)

			arg0["default" .. arg1[1] .. "Btn"] = var0

			setText(var0:GetChild(0), i18n(arg1[2]))
		end)
		onButton(arg0, arg0.defaultReplaceBtn, function()
			arg0:emit(SpWeaponInfoMediator.ON_CHANGE)
		end, SFX_PANEL)
		onButton(arg0, arg0.defaultEnhanceBtn, function()
			arg0:emit(SpWeaponInfoMediator.ON_INTENSIFY)
		end, SFX_PANEL)
		onButton(arg0, arg0.defaultUnloadBtn, function()
			arg0:emit(SpWeaponInfoMediator.ON_UNEQUIP)
		end, SFX_UI_DOCKYARD_EQUIPOFF)
		onButton(arg0, arg0.defaultModifyBtn, function()
			arg0:emit(SpWeaponInfoMediator.ON_MODIFY)
		end, SFX_PANEL)
	elseif arg1 == var0.TYPE_REPLACE then
		arg0.replaceSrcEquipTF = arg0:findTF("equipment", arg0.replacePanel) or arg0:cloneSampleTo(arg0.replacePanel, var0.Left, "equipment")
		arg0.replaceDstEquipTF = arg0:findTF("equipment_on_ship", arg0.replacePanel) or arg0:cloneSampleTo(arg0.replacePanel, var0.Right, "equipment_on_ship")
		arg0.replaceCancelBtn = arg0:findTF("actions/cancel_button", arg0.replacePanel)
		arg0.replaceConfirmBtn = arg0:findTF("actions/action_button_2", arg0.replacePanel)

		setText(arg0.replaceConfirmBtn:Find("label"), i18n("msgbox_text_confirm"))
		setText(arg0.replaceCancelBtn:Find("label"), i18n("msgbox_text_cancel"))
		onButton(arg0, arg0.replaceCancelBtn, function()
			arg0:closeView()
		end, SFX_CANCEL)
		onButton(arg0, arg0.replaceConfirmBtn, function()
			if arg0.contextData.quickCallback then
				arg0.contextData.quickCallback()
				arg0:closeView()
			else
				arg0:emit(SpWeaponInfoMediator.ON_EQUIP)
			end
		end, SFX_UI_DOCKYARD_EQUIPADD)
	elseif arg1 == var0.TYPE_DISPLAY then
		arg0.displayEquipTF = arg0:findTF("equipment", arg0.displayPanel) or arg0:cloneSampleTo(arg0.displayPanel, var0.Middle, "equipment")
		arg0.displayMoveBtn = arg0:findTF("actions/move_button", arg0.displayPanel)

		setText(arg0.displayMoveBtn:Find("label"), i18n("msgbox_text_equipdetail"))
		onButton(arg0, arg0.displayMoveBtn, function()
			arg0:emit(SpWeaponInfoMediator.ON_MOVE, arg0.shipVO.id)
		end)
	end
end

function var0.updateOperation1(arg0)
	triggerToggle(arg0.toggles.defaultPanel, true)
	arg0:updateEquipmentPanel(arg0.defaultEquipTF, arg0.equipmentVO, SpWeaponHelper.TransformNormalInfo(arg0.equipmentVO))
	setActive(arg0.defaultEnhanceBtn, true)
	setActive(arg0.defaultReplaceBtn, false)
	setActive(arg0.defaultUnloadBtn, false)
	setActive(arg0.defaultModifyBtn, true)
end

function var0.updateOperation2(arg0)
	triggerToggle(arg0.toggles.defaultPanel, true)

	local var0 = arg0.shipVO:GetSpWeapon()

	arg0:updateEquipmentPanel(arg0.defaultEquipTF, var0, SpWeaponHelper.TransformNormalInfo(var0))
	setActive(arg0.defaultEnhanceBtn, true)
	setActive(arg0.defaultReplaceBtn, true)
	setActive(arg0.defaultUnloadBtn, true)
	setActive(arg0.defaultModifyBtn, true)

	local var1 = arg0:findTF("head", arg0.defaultEquipTF)

	setActive(var1, arg0.shipVO)

	if arg0.shipVO then
		setImageSprite(findTF(var1, "Image"), LoadSprite("qicon/" .. arg0.shipVO:getPainting()))
	end
end

function var0.updateOperation3(arg0)
	triggerToggle(arg0.toggles.replacePanel, true)

	local var0 = arg0.equipmentVO

	if var0 then
		local var1, var2 = SpWeaponHelper.CompareNormalInfo(var0, arg0.oldEquipmentVO)

		arg0:updateEquipmentPanel(arg0.replaceSrcEquipTF, var0, var1)
		arg0:updateEquipmentPanel(arg0.replaceDstEquipTF, arg0.oldEquipmentVO, var2)
	else
		arg0:updateEquipmentPanel(arg0.replaceSrcEquipTF, nil)
		arg0:updateEquipmentPanel(arg0.replaceDstEquipTF, arg0.oldEquipmentVO, SpWeaponHelper.TransformNormalInfo(arg0.oldEquipmentVO))
	end

	local var3 = arg0:findTF("head", arg0.replaceDstEquipTF)

	setActive(var3, arg0.oldShipVO)

	if arg0.oldShipVO then
		setImageSprite(findTF(var3, "Image"), LoadSprite("qicon/" .. arg0.oldShipVO:getPainting()))
	end
end

function var0.updateOperation4(arg0)
	triggerToggle(arg0.toggles.displayPanel, true)
	arg0:updateEquipmentPanel(arg0.displayEquipTF, arg0.equipmentVO, SpWeaponHelper.TransformNormalInfo(arg0.equipmentVO))
	setActive(arg0.displayMoveBtn, arg0.shipVO)

	local var0 = arg0:findTF("head", arg0.displayEquipTF)

	setActive(var0, arg0.shipVO)

	if arg0.shipVO then
		setImageSprite(findTF(var0, "Image"), LoadSprite("qicon/" .. arg0.shipVO:getPainting()))
	end
end

function var0.updateOperationAward(arg0, arg1, arg2, arg3)
	arg0.awards = arg3

	if arg1.childCount == 0 then
		for iter0 = 1, #arg3 do
			cloneTplTo(arg2, arg1)
		end
	end

	for iter1 = 1, #arg3 do
		local var0 = arg1:GetChild(iter1 - 1)
		local var1 = arg3[iter1]

		updateDrop(var0, var1)
		onButton(arg0, var0, function()
			arg0:emit(var0.ON_DROP, var1)
		end, SFX_PANEL)
		setText(findTF(var0, "name_panel/name"), getText(findTF(var0, "name")))
		setText(findTF(var0, "name_panel/number"), " x " .. getText(findTF(var0, "icon_bg/count")))
		setActive(findTF(var0, "icon_bg/count"), false)
	end
end

function var0.updateEquipmentPanel(arg0, arg1, arg2, arg3)
	local var0 = arg0:findTF("info", arg1)
	local var1 = arg0:findTF("empty", arg1)

	setActive(var0, arg2)
	setActive(var1, not arg2)

	if not arg2 then
		return
	end

	local var2 = findTF(var0, "name")

	setScrollText(findTF(var2, "mask/Text"), arg2:GetName())

	local var3 = findTF(var0, "equip")

	setImageSprite(findTF(var3, "bg"), GetSpriteFromAtlas("ui/equipmentinfoui_atlas", "equip_bg_" .. ItemRarity.Rarity2Print(arg2:GetRarity())))
	updateSpWeapon(var3, arg2, {
		noIconColorful = true
	})
	setActive(findTF(var3, "slv"), arg2:GetLevel() > 1)
	setText(findTF(var3, "slv/Text"), arg2:GetLevel() - 1)
	setActive(findTF(var3, "slv/next"), false)
	setText(findTF(var3, "slv/next/Text"), arg2:GetLevel() - 1)

	local var4 = arg0:findTF("tier", var3)

	setActive(var4, arg2)

	local var5 = arg2:GetTechTier()

	eachChild(var4, function(arg0)
		setActive(arg0, tostring(var5) == arg0.gameObject.name)
	end)
	updateSpWeaponInfo(var0:Find("attributes/view/content"), arg3, arg2:GetSkillGroup())
end

function var0.cloneSampleTo(arg0, arg1, arg2, arg3, arg4)
	local var0 = cloneTplTo(arg0.sample, arg1, arg3)

	var0.localPosition = Vector3.New(var0.pos[arg2][1], var0.pos[arg2][2], var0.pos[arg2][3])

	if arg4 then
		var0:SetSiblingIndex(arg4)
	end

	return var0
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

return var0
