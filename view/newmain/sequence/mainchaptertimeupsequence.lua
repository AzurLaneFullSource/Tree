local var0_0 = class("MainChapterTimeUpSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(ChapterProxy)

	var0_1:checkRemasterInfomation()

	local var1_1 = var0_1:getActiveChapter()
	local var2_1 = var1_1 and var0_1:getMapById(var1_1:getConfig("map"))

	if var1_1 and (not var1_1:inWartime() or not var2_1:isRemaster() and not var1_1:inActTime()) then
		ChapterOpCommand.PrepareChapterRetreat(function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_timeout"))

			if arg1_1 then
				arg1_1()
			end
		end)
	elseif arg1_1 then
		arg1_1()
	end
end

return var0_0
