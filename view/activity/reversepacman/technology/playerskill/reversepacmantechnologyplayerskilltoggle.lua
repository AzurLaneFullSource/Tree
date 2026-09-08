local var0_0 = class("ReversePacmanTechnologyPlayerSkillToggle", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiNameText, i18n("reverse_pacman_deploy"))
end

function var0_0.didEnter(arg0_3)
	return
end

function var0_0.OnSelected(arg0_4, arg1_4)
	setActive(arg0_4.uiSelectedGo, arg1_4)
	setActive(arg0_4.uiUnselectedGo, not arg1_4)

	local var0_4 = arg1_4 and Color.NewHex("#61bac7") or Color.NewHex("#313131")

	setTextColor(arg0_4.uiNameText, var0_4)
	setImageColor(arg0_4.uiIconImage, var0_4)
end

function var0_0.RefreshTip(arg0_5)
	local var0_5 = ReversePacmanTools.GetActivity()

	setActive(arg0_5.uiTipGo, var0_5:GetPlayerSkillTip())
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
end

return var0_0
