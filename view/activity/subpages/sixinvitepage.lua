local var0 = class("SixInvitePage", import(".FifthInvitePage"))

function var0.OnDataSetting(arg0)
	arg0.ultimate = LaunchBallActivityMgr.GotInvitationFlag(arg0.activity.id) and 1 or 0
	arg0.usedtime = LaunchBallActivityMgr.GetRoundCount(arg0.activity.id)
	arg0.maxtime = LaunchBallActivityMgr.GetRoundCountMax(arg0.activity.id)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP_DARK)
	end, SFX_PANEL)
	setActive(arg0.helpBtn, false)
end

function var0.CheckGet(arg0)
	if arg0.ultimate == 0 then
		if arg0.maxtime > arg0.usedtime then
			return
		end

		LaunchBallActivityMgr.GetInvitation(arg0.activity.id)
	end
end

return var0
