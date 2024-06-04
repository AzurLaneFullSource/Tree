local var0 = class("NavalTacticsSkillInfoLayer", import(".SkillInfoLayer"))

function var0.showBase(arg0)
	var0.super.showBase(arg0)
	setActive(arg0.metaBtn, false)
	setActive(arg0.upgradeBtn, false)
end

function var0.showInfo(arg0, arg1)
	arg0.isWorld = arg1

	local var0 = arg0.contextData.skillId
	local var1 = arg0.contextData.skillOnShip
	local var2 = var1 and var1.level or 1

	setText(arg0.skillInfoLv, "Lv." .. var2)
	setText(arg0.skillInfoIntro, Student.getSkillDesc(var0, var2, arg1))
end

return var0
