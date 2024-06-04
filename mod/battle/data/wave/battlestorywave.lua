ys = ys or {}

local var0 = ys

var0.Battle.BattleStoryWave = class("BattleStoryWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleStoryWave.__name = "BattleStoryWave"

local var1 = var0.Battle.BattleStoryWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._storyID = arg0._param.id
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)

	local var0 = true
	local var1 = false

	if var0.Battle.BattleDataProxy.GetInstance():GetInitData().battleType == SYSTEM_SCENARIO then
		local var2 = getProxy(ChapterProxy):getActiveChapter(true)

		var1 = var2 and var2:IsAutoFight() or var1

		if arg0._param.progress then
			if not var2 then
				var0 = false
			elseif math.min(var2.progress + var2:getConfig("progress_boss"), 100) < arg0._param.progress then
				var0 = false
			end
		end

		local var3 = var2 and getProxy(ChapterProxy):getMapById(var2:getConfig("map"))

		if var3 and var3:getRemaster() then
			var0 = false
		end
	end

	if var0 then
		pg.MsgboxMgr.GetInstance():hide()

		local function var4(arg0, arg1)
			if arg0 then
				arg0:doFail(arg1)
			else
				arg0:doPass(arg1)
			end
		end

		ChapterOpCommand.PlayChapterStory(arg0._storyID, var4, var1)
		gcAll()
	else
		arg0:doPass()
	end
end

function var1.doPass(arg0, arg1)
	var0.Battle.BattleDataProxy.GetInstance():AddWaveFlag(arg1)
	var1.super.doPass(arg0)
end

function var1.doFail(arg0, arg1)
	var0.Battle.BattleDataProxy.GetInstance():AddWaveFlag(arg1)
	var1.super.doFail(arg0)
end
