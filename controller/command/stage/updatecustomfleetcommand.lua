local var0_0 = class("UpdateCustomFleetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().chapterId
	local var1_1 = getProxy(BayProxy):getRawData()
	local var2_1 = getProxy(ChapterProxy):getChapterById(var0_1)
	local var3_1 = Chapter.PackEliteFleetInfo(var2_1.eliteFleetList)

	pg.ConnectionMgr.GetInstance():Send(13107, {
		id = var0_1,
		fleet = var3_1
	}, 13108, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("update_custom_fleet", arg0_2.result))
		end
	end)
end

return var0_0
