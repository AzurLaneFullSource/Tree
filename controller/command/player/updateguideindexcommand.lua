local var0 = class("UpdateGuideIndexCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.index
	local var2 = var0.callback

	print("update index.....", var1)
	pg.ConnectionMgr.GetInstance():Send(11016, {
		guide_index = var1
	})

	local var3 = getProxy(PlayerProxy):getData()

	var3.guideIndex = var1

	getProxy(PlayerProxy):updatePlayer(var3)
	pg.SeriesGuideMgr.GetInstance():setPlayer(var3)

	if pg.SeriesGuideMgr.GetInstance():isEnd() then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_1)
	end

	if var2 then
		var2()
	end
end

return var0
