local var0_0 = class("ReversePacmanTechnologyPlayerSkillItem", import("view.activity.ReversePacman.technology.roleSkill.ReversePacmanTechnologyRoleSkillItem"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)
	setText(arg0_1.uiBuyText, i18n("reverse_pacman_level_upgrade"))
	setText(arg0_1.uiBuyText2, i18n("reverse_pacman_level_upgrade"))
	setText(arg0_1.uiSoldOutText, i18n("reverse_pacman_sold_out"))
end

return var0_0
