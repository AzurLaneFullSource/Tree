local var0 = class("SelectEliteCommanderCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.chapterId
	local var2 = var0.index
	local var3 = var0.pos
	local var4 = var0.commanderId
	local var5 = var0.callback
	local var6 = getProxy(ChapterProxy)
	local var7 = var6:getChapterById(var1)

	if var4 then
		local var8, var9 = Commander.canEquipToEliteChapter(var1, var2, var3, var4)

		if not var8 then
			pg.TipsMgr.GetInstance():ShowTips(var9)

			return
		end
	end

	var7:updateCommander(var2, var3, var4)
	var6:updateChapter(var7)
	var6:duplicateEliteFleet(var7)

	if var5 then
		var5()
	end
end

return var0
