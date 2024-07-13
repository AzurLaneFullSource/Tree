local var0_0 = class("GuildEventStartCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(GuildProxy)

	if var0_1:getData() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_boss_appear"))

		var0_1.eventTip = true

		arg0_1:sendNotification(GAME.BOSS_EVENT_START_DONE)
	end
end

return var0_0
