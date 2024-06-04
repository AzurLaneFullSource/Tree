local var0 = class("MainChapterTimeUpSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(ChapterProxy)

	var0:checkRemasterInfomation()

	local var1 = var0:getActiveChapter()
	local var2 = var1 and var0:getMapById(var1:getConfig("map"))

	if var1 and (not var1:inWartime() or not var2:isRemaster() and not var1:inActTime()) then
		ChapterOpCommand.PrepareChapterRetreat(function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_timeout"))

			if arg1 then
				arg1()
			end
		end)
	elseif arg1 then
		arg1()
	end
end

return var0
