local var0_0 = class("UpdateGuideIndexCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.index
	local var2_1 = var0_1.callback
	local var3_1 = var0_1.isNewVersion

	print("update index.....", var3_1 and "newVer" or "oldVer", var1_1)
	pg.ConnectionMgr.GetInstance():Send(11016, {
		guide_index = var1_1,
		type = var3_1 and 1 or 0
	})

	local var4_1 = getProxy(PlayerProxy):getData()

	var4_1:UpdateGuideIndex(var3_1, var1_1)
	getProxy(PlayerProxy):updatePlayer(var4_1)
	pg.SeriesGuideMgr.GetInstance():setPlayer(var4_1)

	if pg.SeriesGuideMgr.GetInstance():isEnd() then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_1)
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_GUIDE_COMPLETE)
	end

	if var2_1 then
		var2_1()
	end

	if pg.SeriesGuideMgr.GetInstance():isEnd() then
		pg.m02:sendNotification(GAME.SERIES_GUIDE_END)
	end
end

return var0_0
