local var0 = class("GuildEventStartCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = getProxy(GuildProxy)

	if var0:getData() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_boss_appear"))

		var0.eventTip = true

		arg0:sendNotification(GAME.BOSS_EVENT_START_DONE)
	end
end

return var0
