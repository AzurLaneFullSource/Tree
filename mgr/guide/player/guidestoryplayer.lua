local var0_0 = class("GuideStoryPlayer", import(".GuidePlayer"))

function var0_0.OnExecution(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1:GetStories()
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(var1_1, function(arg0_2)
			pg.NewStoryMgr.GetInstance():Play(iter1_1, arg0_2, true)
		end)
	end

	table.insert(var1_1, function(arg0_3)
		pg.m02:sendNotification(GAME.START_GUIDE)
		arg0_3()
	end)
	seriesAsync(var1_1, arg2_1)
end

return var0_0
