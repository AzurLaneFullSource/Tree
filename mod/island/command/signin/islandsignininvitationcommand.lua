local var0_0 = class("IslandSignInInvitationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().list or {}
	local var1_1 = getProxy(IslandProxy):GetIsland():GetSignInAgency()
	local var2_1 = _.select(var0_1, function(arg0_2)
		return not var1_1:IsInvited(arg0_2)
	end)

	if #var2_1 == 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21312, {
		friend_list = var2_1
	}, 21313, function(arg0_3)
		if arg0_3.result == 0 then
			for iter0_3, iter1_3 in ipairs(var2_1) do
				var1_1:AddInviter(iter1_3)
			end

			arg0_1:sendNotification(GAME.ISLAND_SIGN_IN_INVITATION_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_invitation_gift_success"))
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandInvitation(var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0
