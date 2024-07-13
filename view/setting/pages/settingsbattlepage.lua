local var0_0 = class("SettingsBattlePage", import("...base.BaseSubView"))
local var1_0 = "joystick_anchorX"
local var2_0 = "joystick_anchorY"
local var3_0 = "skill_1_anchorX"
local var4_0 = "skill_1_anchorY"
local var5_0 = "skill_2_anchorX"
local var6_0 = "skill_2_anchorY"
local var7_0 = "skill_3_anchorX"
local var8_0 = "skill_3_anchorY"
local var9_0 = "skill_4_anchorX"
local var10_0 = "skill_4_anchorY"

var0_0.CLD_RED = Color.New(0.6, 0.05, 0.05, 0.5)
var0_0.DEFAULT_GREY = Color.New(0.5, 0.5, 0.5, 0.5)

function var0_0.getUIName(arg0_1)
	return "SettingsBattlePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.editPanel = arg0_2._tf:Find("editor")

	local var0_2 = findTF(arg0_2._tf, "editor/buttons")

	arg0_2.normalBtns = findTF(var0_2, "normal")
	arg0_2.editBtns = findTF(var0_2, "editing")
	arg0_2.saveBtn = findTF(arg0_2.editBtns, "save")
	arg0_2.cancelBtn = findTF(arg0_2.editBtns, "cancel")
	arg0_2.editBtn = findTF(arg0_2.normalBtns, "edit")
	arg0_2.revertBtn = findTF(arg0_2.normalBtns, "reset")
	arg0_2.interface = findTF(arg0_2._tf, "editor/editing_region")
	arg0_2.stick = findTF(arg0_2.interface, "Stick")
	arg0_2.skillBtn1 = findTF(arg0_2.interface, "Skill_1")
	arg0_2.skillBtn2 = findTF(arg0_2.interface, "Skill_2")
	arg0_2.skillBtn3 = findTF(arg0_2.interface, "Skill_3")
	arg0_2.skillBtn4 = findTF(arg0_2.interface, "Skill_4")
	arg0_2.eventStick = arg0_2.stick:GetComponent("EventTriggerListener")
	arg0_2.eventSkillBtn1 = arg0_2.skillBtn1:GetComponent("EventTriggerListener")
	arg0_2.eventSkillBtn2 = arg0_2.skillBtn2:GetComponent("EventTriggerListener")
	arg0_2.eventSkillBtn3 = arg0_2.skillBtn3:GetComponent("EventTriggerListener")
	arg0_2.eventSkillBtn4 = arg0_2.skillBtn4:GetComponent("EventTriggerListener")
	arg0_2.mask = findTF(arg0_2.interface, "mask")
	arg0_2.topArea = findTF(arg0_2.interface, "top")
	arg0_2.cg = arg0_2._tf:GetComponent(typeof(CanvasGroup))
	arg0_2.topLayerCg = arg0_2._parentTf.parent:Find("blur_panel"):GetComponent(typeof(CanvasGroup))

	setActive(arg0_2._tf, true)
	setText(arg0_2._tf:Find("editor/editing_region/mask/middle/Text"), i18n("settings_battle_tip"))
	setText(arg0_2._tf:Find("editor/buttons/normal/edit/Image"), i18n("settings_battle_Btn_edit"))
	setText(arg0_2._tf:Find("editor/buttons/normal/reset/Image"), i18n("settings_battle_Btn_reset"))
	setText(arg0_2._tf:Find("editor/title"), i18n("settings_battle_title"))
	setText(arg0_2._tf:Find("editor/buttons/editing/save/Image"), i18n("settings_battle_Btn_save"))
	setText(arg0_2._tf:Find("editor/buttons/editing/cancel/Image"), i18n("settings_battle_Btn_cancel"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.editBtn, function()
		arg0_3:EditModeEnabled(true)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.revertBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("setting_interface_revert_check"),
			onYes = function()
				arg0_3:RevertInterfaceSetting(true)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		if arg0_3._currentDrag then
			LuaHelper.triggerEndDrag(arg0_3._currentDrag)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("setting_interface_cancel_check"),
			onYes = function()
				arg0_3:EditModeEnabled(false)
				arg0_3:RevertInterfaceSetting(false)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.saveBtn, function()
		if arg0_3._currentDrag then
			LuaHelper.triggerEndDrag(arg0_3._currentDrag)
		end

		arg0_3:EditModeEnabled(false)
		arg0_3:SaveInterfaceSetting()
		pg.TipsMgr.GetInstance():ShowTips(i18n("setting_interface_save_success"))
	end, SFX_PANEL)
	arg0_3:InitInterfaceComponents()
end

function var0_0.InitInterfaceComponents(arg0_10)
	local var0_10 = ys.Battle.BattleConfig.JOY_STICK_DEFAULT_PREFERENCE

	arg0_10:InitInterfaceComponent(arg0_10.stick, arg0_10.eventStick, var1_0, var2_0, var0_10)

	local var1_10 = ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE

	arg0_10:InitInterfaceComponent(arg0_10.skillBtn1, arg0_10.eventSkillBtn1, var3_0, var4_0, var1_10[1])
	arg0_10:InitInterfaceComponent(arg0_10.skillBtn2, arg0_10.eventSkillBtn2, var5_0, var6_0, var1_10[2])
	arg0_10:InitInterfaceComponent(arg0_10.skillBtn3, arg0_10.eventSkillBtn3, var7_0, var8_0, var1_10[3])
	arg0_10:InitInterfaceComponent(arg0_10.skillBtn4, arg0_10.eventSkillBtn4, var9_0, var10_0, var1_10[4])

	local var2_10 = arg0_10:GetScale()

	arg0_10.components = {
		arg0_10.topArea,
		arg0_10.stick,
		arg0_10.skillBtn1,
		arg0_10.skillBtn2,
		arg0_10.skillBtn3,
		arg0_10.skillBtn4
	}

	for iter0_10 = 2, #arg0_10.components do
		setLocalScale(arg0_10.components[iter0_10], var2_10)
	end

	arg0_10:EditModeEnabled(false)
end

function var0_0.GetScale(arg0_11)
	local var0_11 = rtf(arg0_11.interface).rect.width
	local var1_11 = rtf(arg0_11.interface).rect.height
	local var2_11 = rtf(arg0_11._parentTf).rect.width
	local var3_11 = rtf(arg0_11._parentTf).rect.height
	local var4_11

	if var0_11 / var1_11 > var2_11 / var3_11 then
		var4_11 = var1_11 / var3_11
	else
		var4_11 = var0_11 / var2_11
	end

	return Vector3.New(var4_11, var4_11, 1)
end

function var0_0.InitInterfaceComponent(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12, arg5_12)
	local var0_12 = rtf(arg0_12._parentTf).rect.width
	local var1_12 = rtf(arg0_12._parentTf).rect.height
	local var2_12 = var0_12 * 0.5 + arg0_12.interface.localPosition.x + arg0_12.interface.parent.localPosition.x + arg0_12.interface.parent.parent.localPosition.x
	local var3_12 = var1_12 * 0.5 + arg0_12.interface.localPosition.y + arg0_12.interface.parent.localPosition.y + arg0_12.interface.parent.parent.localPosition.y
	local var4_12
	local var5_12
	local var6_12
	local var7_12

	arg2_12:AddBeginDragFunc(function(arg0_13, arg1_13)
		arg0_12._currentDrag = arg2_12
		var6_12 = var0_12 / UnityEngine.Screen.width
		var7_12 = var1_12 / UnityEngine.Screen.height
		var4_12 = arg1_12.localPosition.x
		var5_12 = arg1_12.localPosition.y
	end)
	arg2_12:AddDragFunc(function(arg0_14, arg1_14)
		arg1_12.localPosition = Vector3(arg1_14.position.x * var6_12 - var2_12, arg1_14.position.y * var7_12 - var3_12, 0)

		arg0_12:CheckInterfaceIntersect()
	end)
	arg2_12:AddDragEndFunc(function(arg0_15, arg1_15)
		arg0_12._currentDrag = nil

		if arg0_12:CheckInterfaceIntersect() then
			arg1_12.localPosition = Vector3(var4_12, var5_12, 0)
		end

		arg0_12:CheckInterfaceIntersect()
	end)
	arg0_12:SetInterfaceAnchor(arg1_12, arg3_12, arg4_12, arg5_12)
end

function var0_0.EditModeEnabled(arg0_16, arg1_16)
	setActive(arg0_16.normalBtns, not arg1_16)
	setActive(arg0_16.mask, not arg1_16)
	setActive(arg0_16.editBtns, arg1_16)

	for iter0_16, iter1_16 in ipairs(arg0_16.components) do
		setActive(findTF(iter1_16, "rect"), arg1_16)

		if iter0_16 > 1 then
			GetOrAddComponent(iter1_16, "EventTriggerListener").enabled = arg1_16
		end
	end

	Input.multiTouchEnabled = not arg1_16
	arg0_16.topLayerCg.blocksRaycasts = not arg1_16
end

function var0_0.SetInterfaceAnchor(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17, arg5_17)
	local var0_17
	local var1_17

	if arg5_17 then
		var0_17 = arg4_17.x
		var1_17 = arg4_17.y
	else
		var0_17 = PlayerPrefs.GetFloat(arg2_17, arg4_17.x)
		var1_17 = PlayerPrefs.GetFloat(arg3_17, arg4_17.y)
	end

	local var2_17 = rtf(arg0_17.interface).rect.width
	local var3_17 = rtf(arg0_17.interface).rect.height
	local var4_17 = (var0_17 - 0.5) * var2_17
	local var5_17 = (var1_17 - 0.5) * var3_17

	arg1_17.localPosition = Vector3(var4_17, var5_17, 0)
end

local function var11_0(arg0_18)
	local var0_18 = rtf(arg0_18)
	local var1_18 = var0_18.rect
	local var2_18 = var1_18.width * var0_18.lossyScale.x
	local var3_18 = var1_18.height * var0_18.lossyScale.y
	local var4_18 = var0_18.position

	return UnityEngine.Rect.New(var4_18.x - var2_18 / 2, var4_18.y - var3_18 / 2, var2_18, var3_18)
end

function var0_0.CheckInterfaceIntersect(arg0_19)
	local var0_19 = {}
	local var1_19 = false
	local var2_19 = {}
	local var3_19 = var11_0(arg0_19.interface)

	for iter0_19, iter1_19 in ipairs(arg0_19.components) do
		var2_19[iter1_19] = var11_0(iter1_19:Find("rect"))
	end

	for iter2_19, iter3_19 in ipairs(arg0_19.components) do
		for iter4_19, iter5_19 in ipairs(arg0_19.components) do
			if iter3_19 ~= iter5_19 and var2_19[iter3_19]:Overlaps(var2_19[iter5_19]) then
				var0_19[iter5_19] = true
			end
		end

		if iter2_19 > 1 then
			local var4_19 = Vector2.New(var2_19[iter3_19].xMin, var2_19[iter3_19].yMin)
			local var5_19 = Vector2.New(var2_19[iter3_19].xMax, var2_19[iter3_19].yMax)

			if not var3_19:Contains(var4_19) or not var3_19:Contains(var5_19) then
				var0_19[iter3_19] = true
			end
		end
	end

	for iter6_19, iter7_19 in ipairs(arg0_19.components) do
		local var6_19 = findTF(iter7_19, "rect"):GetComponent(typeof(Image))

		if var0_19[iter7_19] then
			var6_19.color = var0_0.CLD_RED
			var1_19 = true
		else
			var6_19.color = var0_0.DEFAULT_GREY
		end
	end

	return var1_19
end

function var0_0.RevertInterfaceSetting(arg0_20, arg1_20)
	local var0_20 = ys.Battle.BattleConfig.JOY_STICK_DEFAULT_PREFERENCE
	local var1_20 = ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE

	arg0_20:SetInterfaceAnchor(arg0_20.stick, var1_0, var2_0, var0_20, arg1_20)
	arg0_20:SetInterfaceAnchor(arg0_20.skillBtn1, var3_0, var4_0, var1_20[1], arg1_20)
	arg0_20:SetInterfaceAnchor(arg0_20.skillBtn2, var5_0, var6_0, var1_20[2], arg1_20)
	arg0_20:SetInterfaceAnchor(arg0_20.skillBtn3, var7_0, var8_0, var1_20[3], arg1_20)
	arg0_20:SetInterfaceAnchor(arg0_20.skillBtn4, var9_0, var10_0, var1_20[4], arg1_20)
	arg0_20:SaveInterfaceSetting()
end

function var0_0.SaveInterfaceSetting(arg0_21)
	arg0_21:OverrideInterfaceSetting(arg0_21.stick, var1_0, var2_0)
	arg0_21:OverrideInterfaceSetting(arg0_21.skillBtn1, var3_0, var4_0)
	arg0_21:OverrideInterfaceSetting(arg0_21.skillBtn2, var5_0, var6_0)
	arg0_21:OverrideInterfaceSetting(arg0_21.skillBtn3, var7_0, var8_0)
	arg0_21:OverrideInterfaceSetting(arg0_21.skillBtn4, var9_0, var10_0)
end

function var0_0.OverrideInterfaceSetting(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = rtf(arg0_22.interface).rect.width
	local var1_22 = rtf(arg0_22.interface).rect.height
	local var2_22 = (arg1_22.localPosition.x + var0_22 * 0.5) / var0_22
	local var3_22 = (arg1_22.localPosition.y + var1_22 * 0.5) / var1_22

	PlayerPrefs.SetFloat(arg2_22, var2_22)
	PlayerPrefs.SetFloat(arg3_22, var3_22)
end

function var0_0.OnDestroy(arg0_23)
	ClearEventTrigger(arg0_23.eventStick)
	ClearEventTrigger(arg0_23.eventSkillBtn1)
	ClearEventTrigger(arg0_23.eventSkillBtn2)
	ClearEventTrigger(arg0_23.eventSkillBtn3)
	ClearEventTrigger(arg0_23.eventSkillBtn4)

	Input.multiTouchEnabled = true
end

function var0_0.Show(arg0_24)
	arg0_24.cg.blocksRaycasts = true
	arg0_24.cg.alpha = 1
end

function var0_0.Hide(arg0_25)
	arg0_25.cg.blocksRaycasts = false
	arg0_25.cg.alpha = 0
end

return var0_0
