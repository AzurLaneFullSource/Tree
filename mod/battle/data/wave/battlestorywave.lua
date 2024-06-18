ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleStoryWave = class("BattleStoryWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleStoryWave.__name = "BattleStoryWave"

local var1_0 = var0_0.Battle.BattleStoryWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._storyID = arg0_2._param.id
end

function var1_0.DoWave(arg0_3)
	var1_0.super.DoWave(arg0_3)

	local var0_3 = true
	local var1_3 = false

	if var0_0.Battle.BattleDataProxy.GetInstance():GetInitData().battleType == SYSTEM_SCENARIO then
		local var2_3 = getProxy(ChapterProxy):getActiveChapter(true)

		var1_3 = var2_3 and var2_3:IsAutoFight() or var1_3

		if arg0_3._param.progress then
			if not var2_3 then
				var0_3 = false
			elseif math.min(var2_3.progress + var2_3:getConfig("progress_boss"), 100) < arg0_3._param.progress then
				var0_3 = false
			end
		end

		local var3_3 = var2_3 and getProxy(ChapterProxy):getMapById(var2_3:getConfig("map"))

		if var3_3 and var3_3:getRemaster() then
			var0_3 = false
		end
	end

	if var0_3 then
		pg.MsgboxMgr.GetInstance():hide()

		local function var4_3(arg0_4, arg1_4)
			if arg0_4 then
				arg0_3:doFail(arg1_4)
			else
				arg0_3:doPass(arg1_4)
			end
		end

		ChapterOpCommand.PlayChapterStory(arg0_3._storyID, var4_3, var1_3)
		gcAll()
	else
		arg0_3:doPass()
	end
end

function var1_0.doPass(arg0_5, arg1_5)
	var0_0.Battle.BattleDataProxy.GetInstance():AddWaveFlag(arg1_5)
	var1_0.super.doPass(arg0_5)
end

function var1_0.doFail(arg0_6, arg1_6)
	var0_0.Battle.BattleDataProxy.GetInstance():AddWaveFlag(arg1_6)
	var1_0.super.doFail(arg0_6)
end
