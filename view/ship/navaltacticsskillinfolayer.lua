local var0_0 = class("NavalTacticsSkillInfoLayer", import(".SkillInfoLayer"))

function var0_0.showBase(arg0_1)
	var0_0.super.showBase(arg0_1)
	setActive(arg0_1.metaBtn, false)
	setActive(arg0_1.upgradeBtn, false)
end

function var0_0.showInfo(arg0_2, arg1_2)
	arg0_2.isWorld = arg1_2

	local var0_2 = arg0_2.contextData.skillId
	local var1_2 = arg0_2.contextData.skillOnShip
	local var2_2 = var1_2 and var1_2.level or 1

	setText(arg0_2.skillInfoLv, "Lv." .. var2_2)
	setText(arg0_2.skillInfoIntro, Student.getSkillDesc(var0_2, var2_2, arg1_2))
end

return var0_0
