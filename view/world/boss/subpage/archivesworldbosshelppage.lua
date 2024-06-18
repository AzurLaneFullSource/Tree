local var0_0 = class("ArchivesWorldBossHelpPage", import(".WorldBossHelpPage"))

function var0_0.OnLoaded(arg0_1)
	var0_0.super.OnLoaded(arg0_1)
	setActive(arg0_1.worldBtn, false)
end

return var0_0
