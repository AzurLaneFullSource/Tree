local var0_0 = class("UpdateGuideIndexCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.index
	local var2_1 = var0_1.callback

	print("update index.....", var1_1)
	pg.ConnectionMgr.GetInstance():Send(11016, {
		guide_index = var1_1
	})

	local var3_1 = getProxy(PlayerProxy):getData()

	var3_1.guideIndex = var1_1

	getProxy(PlayerProxy):updatePlayer(var3_1)
	pg.SeriesGuideMgr.GetInstance():setPlayer(var3_1)

	if pg.SeriesGuideMgr.GetInstance():isEnd() then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_1)
	end

	if var2_1 then
		var2_1()
	end
end

return var0_0
