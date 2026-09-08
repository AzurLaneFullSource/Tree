local var0_0 = class("ReversePacmanInterviewRoleTypeToggle", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1
	arg0_1.roleType = arg3_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	if arg0_2.roleType == ReversePacmanHomeConst.ROLE_TYPE.ALL then
		setText(arg0_2.uiNameText, i18n("reverse_pacman_ship_type_0"))
	elseif arg0_2.roleType == ReversePacmanHomeConst.ROLE_TYPE.CHASER then
		setText(arg0_2.uiNameText, i18n("reverse_pacman_ship_type_1"))
	elseif arg0_2.roleType == ReversePacmanHomeConst.ROLE_TYPE.AMBUSHER then
		setText(arg0_2.uiNameText, i18n("reverse_pacman_ship_type_2"))
	elseif arg0_2.roleType == ReversePacmanHomeConst.ROLE_TYPE.PLANNER then
		setText(arg0_2.uiNameText, i18n("reverse_pacman_ship_type_3"))
	end

	onToggle(arg0_2, arg0_2.uiToggle, function(arg0_3)
		if arg0_3 then
			arg0_2:emit(ReversePacmanInterviewRoleList.ON_CLICK_TOGGLE, arg0_2.roleType)
		end
	end)
end

function var0_0.didEnter(arg0_4)
	return
end

function var0_0.OnTriggerToggle(arg0_5)
	triggerToggle(arg0_5.uiToggle, true)
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
end

return var0_0
