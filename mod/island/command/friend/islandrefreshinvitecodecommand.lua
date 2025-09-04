local var0_0 = class("IslandRefreshInviteCodeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().auto
	local var1_1 = getProxy(IslandProxy):GetIsland():GetAccessAgency()

	if var1_1:isFreshInviteCode() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_inviteCode_refresh"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21008, {
		type = 0
	}, 21009, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:SetInviteCode(arg0_2.invite_code)

			if not var0_1 then
				var1_1:MarkFreshInviteCodeFlag()
			end

			arg0_1:sendNotification(GAME.ISLAND_REFRESH_INVITECODE_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_flash_success"))
		end
	end)
end

return var0_0
