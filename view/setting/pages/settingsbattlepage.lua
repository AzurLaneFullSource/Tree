local var0 = class("SettingsBattlePage", import("...base.BaseSubView"))
local var1 = "joystick_anchorX"
local var2 = "joystick_anchorY"
local var3 = "skill_1_anchorX"
local var4 = "skill_1_anchorY"
local var5 = "skill_2_anchorX"
local var6 = "skill_2_anchorY"
local var7 = "skill_3_anchorX"
local var8 = "skill_3_anchorY"
local var9 = "skill_4_anchorX"
local var10 = "skill_4_anchorY"

var0.CLD_RED = Color.New(0.6, 0.05, 0.05, 0.5)
var0.DEFAULT_GREY = Color.New(0.5, 0.5, 0.5, 0.5)

function var0.getUIName(arg0)
	return "SettingsBattlePage"
end

function var0.OnLoaded(arg0)
	arg0.editPanel = arg0._tf:Find("editor")

	local var0 = findTF(arg0._tf, "editor/buttons")

	arg0.normalBtns = findTF(var0, "normal")
	arg0.editBtns = findTF(var0, "editing")
	arg0.saveBtn = findTF(arg0.editBtns, "save")
	arg0.cancelBtn = findTF(arg0.editBtns, "cancel")
	arg0.editBtn = findTF(arg0.normalBtns, "edit")
	arg0.revertBtn = findTF(arg0.normalBtns, "reset")
	arg0.interface = findTF(arg0._tf, "editor/editing_region")
	arg0.stick = findTF(arg0.interface, "Stick")
	arg0.skillBtn1 = findTF(arg0.interface, "Skill_1")
	arg0.skillBtn2 = findTF(arg0.interface, "Skill_2")
	arg0.skillBtn3 = findTF(arg0.interface, "Skill_3")
	arg0.skillBtn4 = findTF(arg0.interface, "Skill_4")
	arg0.eventStick = arg0.stick:GetComponent("EventTriggerListener")
	arg0.eventSkillBtn1 = arg0.skillBtn1:GetComponent("EventTriggerListener")
	arg0.eventSkillBtn2 = arg0.skillBtn2:GetComponent("EventTriggerListener")
	arg0.eventSkillBtn3 = arg0.skillBtn3:GetComponent("EventTriggerListener")
	arg0.eventSkillBtn4 = arg0.skillBtn4:GetComponent("EventTriggerListener")
	arg0.mask = findTF(arg0.interface, "mask")
	arg0.topArea = findTF(arg0.interface, "top")
	arg0.cg = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.topLayerCg = arg0._parentTf.parent:Find("blur_panel"):GetComponent(typeof(CanvasGroup))

	setActive(arg0._tf, true)
	setText(arg0._tf:Find("editor/editing_region/mask/middle/Text"), i18n("settings_battle_tip"))
	setText(arg0._tf:Find("editor/buttons/normal/edit/Image"), i18n("settings_battle_Btn_edit"))
	setText(arg0._tf:Find("editor/buttons/normal/reset/Image"), i18n("settings_battle_Btn_reset"))
	setText(arg0._tf:Find("editor/title"), i18n("settings_battle_title"))
	setText(arg0._tf:Find("editor/buttons/editing/save/Image"), i18n("settings_battle_Btn_save"))
	setText(arg0._tf:Find("editor/buttons/editing/cancel/Image"), i18n("settings_battle_Btn_cancel"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.editBtn, function()
		arg0:EditModeEnabled(true)
	end, SFX_PANEL)
	onButton(arg0, arg0.revertBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("setting_interface_revert_check"),
			onYes = function()
				arg0:RevertInterfaceSetting(true)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		if arg0._currentDrag then
			LuaHelper.triggerEndDrag(arg0._currentDrag)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("setting_interface_cancel_check"),
			onYes = function()
				arg0:EditModeEnabled(false)
				arg0:RevertInterfaceSetting(false)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.saveBtn, function()
		if arg0._currentDrag then
			LuaHelper.triggerEndDrag(arg0._currentDrag)
		end

		arg0:EditModeEnabled(false)
		arg0:SaveInterfaceSetting()
		pg.TipsMgr.GetInstance():ShowTips(i18n("setting_interface_save_success"))
	end, SFX_PANEL)
	arg0:InitInterfaceComponents()
end

function var0.InitInterfaceComponents(arg0)
	local var0 = ys.Battle.BattleConfig.JOY_STICK_DEFAULT_PREFERENCE

	arg0:InitInterfaceComponent(arg0.stick, arg0.eventStick, var1, var2, var0)

	local var1 = ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE

	arg0:InitInterfaceComponent(arg0.skillBtn1, arg0.eventSkillBtn1, var3, var4, var1[1])
	arg0:InitInterfaceComponent(arg0.skillBtn2, arg0.eventSkillBtn2, var5, var6, var1[2])
	arg0:InitInterfaceComponent(arg0.skillBtn3, arg0.eventSkillBtn3, var7, var8, var1[3])
	arg0:InitInterfaceComponent(arg0.skillBtn4, arg0.eventSkillBtn4, var9, var10, var1[4])

	local var2 = arg0:GetScale()

	arg0.components = {
		arg0.topArea,
		arg0.stick,
		arg0.skillBtn1,
		arg0.skillBtn2,
		arg0.skillBtn3,
		arg0.skillBtn4
	}

	for iter0 = 2, #arg0.components do
		setLocalScale(arg0.components[iter0], var2)
	end

	arg0:EditModeEnabled(false)
end

function var0.GetScale(arg0)
	local var0 = rtf(arg0.interface).rect.width
	local var1 = rtf(arg0.interface).rect.height
	local var2 = rtf(arg0._parentTf).rect.width
	local var3 = rtf(arg0._parentTf).rect.height
	local var4

	if var0 / var1 > var2 / var3 then
		var4 = var1 / var3
	else
		var4 = var0 / var2
	end

	return Vector3.New(var4, var4, 1)
end

function var0.InitInterfaceComponent(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = rtf(arg0._parentTf).rect.width
	local var1 = rtf(arg0._parentTf).rect.height
	local var2 = var0 * 0.5 + arg0.interface.localPosition.x + arg0.interface.parent.localPosition.x + arg0.interface.parent.parent.localPosition.x
	local var3 = var1 * 0.5 + arg0.interface.localPosition.y + arg0.interface.parent.localPosition.y + arg0.interface.parent.parent.localPosition.y
	local var4
	local var5
	local var6
	local var7

	arg2:AddBeginDragFunc(function(arg0, arg1)
		arg0._currentDrag = arg2
		var6 = var0 / UnityEngine.Screen.width
		var7 = var1 / UnityEngine.Screen.height
		var4 = arg1.localPosition.x
		var5 = arg1.localPosition.y
	end)
	arg2:AddDragFunc(function(arg0, arg1)
		arg1.localPosition = Vector3(arg1.position.x * var6 - var2, arg1.position.y * var7 - var3, 0)

		arg0:CheckInterfaceIntersect()
	end)
	arg2:AddDragEndFunc(function(arg0, arg1)
		arg0._currentDrag = nil

		if arg0:CheckInterfaceIntersect() then
			arg1.localPosition = Vector3(var4, var5, 0)
		end

		arg0:CheckInterfaceIntersect()
	end)
	arg0:SetInterfaceAnchor(arg1, arg3, arg4, arg5)
end

function var0.EditModeEnabled(arg0, arg1)
	setActive(arg0.normalBtns, not arg1)
	setActive(arg0.mask, not arg1)
	setActive(arg0.editBtns, arg1)

	for iter0, iter1 in ipairs(arg0.components) do
		setActive(findTF(iter1, "rect"), arg1)

		if iter0 > 1 then
			GetOrAddComponent(iter1, "EventTriggerListener").enabled = arg1
		end
	end

	Input.multiTouchEnabled = not arg1
	arg0.topLayerCg.blocksRaycasts = not arg1
end

function var0.SetInterfaceAnchor(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0
	local var1

	if arg5 then
		var0 = arg4.x
		var1 = arg4.y
	else
		var0 = PlayerPrefs.GetFloat(arg2, arg4.x)
		var1 = PlayerPrefs.GetFloat(arg3, arg4.y)
	end

	local var2 = rtf(arg0.interface).rect.width
	local var3 = rtf(arg0.interface).rect.height
	local var4 = (var0 - 0.5) * var2
	local var5 = (var1 - 0.5) * var3

	arg1.localPosition = Vector3(var4, var5, 0)
end

local function var11(arg0)
	local var0 = rtf(arg0)
	local var1 = var0.rect
	local var2 = var1.width * var0.lossyScale.x
	local var3 = var1.height * var0.lossyScale.y
	local var4 = var0.position

	return UnityEngine.Rect.New(var4.x - var2 / 2, var4.y - var3 / 2, var2, var3)
end

function var0.CheckInterfaceIntersect(arg0)
	local var0 = {}
	local var1 = false
	local var2 = {}
	local var3 = var11(arg0.interface)

	for iter0, iter1 in ipairs(arg0.components) do
		var2[iter1] = var11(iter1:Find("rect"))
	end

	for iter2, iter3 in ipairs(arg0.components) do
		for iter4, iter5 in ipairs(arg0.components) do
			if iter3 ~= iter5 and var2[iter3]:Overlaps(var2[iter5]) then
				var0[iter5] = true
			end
		end

		if iter2 > 1 then
			local var4 = Vector2.New(var2[iter3].xMin, var2[iter3].yMin)
			local var5 = Vector2.New(var2[iter3].xMax, var2[iter3].yMax)

			if not var3:Contains(var4) or not var3:Contains(var5) then
				var0[iter3] = true
			end
		end
	end

	for iter6, iter7 in ipairs(arg0.components) do
		local var6 = findTF(iter7, "rect"):GetComponent(typeof(Image))

		if var0[iter7] then
			var6.color = var0.CLD_RED
			var1 = true
		else
			var6.color = var0.DEFAULT_GREY
		end
	end

	return var1
end

function var0.RevertInterfaceSetting(arg0, arg1)
	local var0 = ys.Battle.BattleConfig.JOY_STICK_DEFAULT_PREFERENCE
	local var1 = ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE

	arg0:SetInterfaceAnchor(arg0.stick, var1, var2, var0, arg1)
	arg0:SetInterfaceAnchor(arg0.skillBtn1, var3, var4, var1[1], arg1)
	arg0:SetInterfaceAnchor(arg0.skillBtn2, var5, var6, var1[2], arg1)
	arg0:SetInterfaceAnchor(arg0.skillBtn3, var7, var8, var1[3], arg1)
	arg0:SetInterfaceAnchor(arg0.skillBtn4, var9, var10, var1[4], arg1)
	arg0:SaveInterfaceSetting()
end

function var0.SaveInterfaceSetting(arg0)
	arg0:OverrideInterfaceSetting(arg0.stick, var1, var2)
	arg0:OverrideInterfaceSetting(arg0.skillBtn1, var3, var4)
	arg0:OverrideInterfaceSetting(arg0.skillBtn2, var5, var6)
	arg0:OverrideInterfaceSetting(arg0.skillBtn3, var7, var8)
	arg0:OverrideInterfaceSetting(arg0.skillBtn4, var9, var10)
end

function var0.OverrideInterfaceSetting(arg0, arg1, arg2, arg3)
	local var0 = rtf(arg0.interface).rect.width
	local var1 = rtf(arg0.interface).rect.height
	local var2 = (arg1.localPosition.x + var0 * 0.5) / var0
	local var3 = (arg1.localPosition.y + var1 * 0.5) / var1

	PlayerPrefs.SetFloat(arg2, var2)
	PlayerPrefs.SetFloat(arg3, var3)
end

function var0.OnDestroy(arg0)
	ClearEventTrigger(arg0.eventStick)
	ClearEventTrigger(arg0.eventSkillBtn1)
	ClearEventTrigger(arg0.eventSkillBtn2)
	ClearEventTrigger(arg0.eventSkillBtn3)
	ClearEventTrigger(arg0.eventSkillBtn4)

	Input.multiTouchEnabled = true
end

function var0.Show(arg0)
	arg0.cg.blocksRaycasts = true
	arg0.cg.alpha = 1
end

function var0.Hide(arg0)
	arg0.cg.blocksRaycasts = false
	arg0.cg.alpha = 0
end

return var0
