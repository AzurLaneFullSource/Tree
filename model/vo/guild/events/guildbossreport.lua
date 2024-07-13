local var0_0 = class("GuildBossReport", import(".GuildReport"))

function var0_0.bindConfigTable(arg0_1)
	return pg.guild_boss_event
end

function var0_0.IsBoss(arg0_2)
	return true
end

function var0_0.GetReportDesc(arg0_3)
	return arg0_3:getConfig("report")
end

function var0_0.GetDrop(arg0_4)
	return arg0_4:getConfig("award_report"), 0
end

function var0_0.GetType(arg0_5)
	return 3
end

return var0_0
