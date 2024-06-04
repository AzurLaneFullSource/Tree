local var0 = class("ArchivesWorldBossHelpPage", import(".WorldBossHelpPage"))

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)
	setActive(arg0.worldBtn, false)
end

return var0
