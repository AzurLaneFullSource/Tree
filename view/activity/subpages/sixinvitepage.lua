local var0_0 = class("SixInvitePage", import(".FifthInvitePage"))

function var0_0.OnDataSetting(arg0_1)
	arg0_1.ultimate = LaunchBallActivityMgr.GotInvitationFlag(arg0_1.activity.id) and 1 or 0
	arg0_1.usedtime = LaunchBallActivityMgr.GetRoundCount(arg0_1.activity.id)
	arg0_1.maxtime = LaunchBallActivityMgr.GetRoundCountMax(arg0_1.activity.id)
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.goBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP_DARK)
	end, SFX_PANEL)
	setActive(arg0_2.helpBtn, false)
end

function var0_0.CheckGet(arg0_4)
	if arg0_4.ultimate == 0 then
		if arg0_4.maxtime > arg0_4.usedtime then
			return
		end

		LaunchBallActivityMgr.GetInvitation(arg0_4.activity.id)
	end
end

return var0_0
