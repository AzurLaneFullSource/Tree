local var0 = class("GuildBossReport", import(".GuildReport"))

function var0.bindConfigTable(arg0)
	return pg.guild_boss_event
end

function var0.IsBoss(arg0)
	return true
end

function var0.GetReportDesc(arg0)
	return arg0:getConfig("report")
end

function var0.GetDrop(arg0)
	return arg0:getConfig("award_report"), 0
end

function var0.GetType(arg0)
	return 3
end

return var0
