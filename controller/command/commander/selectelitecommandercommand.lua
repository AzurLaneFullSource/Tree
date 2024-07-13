local var0_0 = class("SelectEliteCommanderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.chapterId
	local var2_1 = var0_1.index
	local var3_1 = var0_1.pos
	local var4_1 = var0_1.commanderId
	local var5_1 = var0_1.callback
	local var6_1 = getProxy(ChapterProxy)
	local var7_1 = var6_1:getChapterById(var1_1)

	if var4_1 then
		local var8_1, var9_1 = Commander.canEquipToEliteChapter(var1_1, var2_1, var3_1, var4_1)

		if not var8_1 then
			pg.TipsMgr.GetInstance():ShowTips(var9_1)

			return
		end
	end

	var7_1:updateCommander(var2_1, var3_1, var4_1)
	var6_1:updateChapter(var7_1)
	var6_1:duplicateEliteFleet(var7_1)

	if var5_1 then
		var5_1()
	end
end

return var0_0
