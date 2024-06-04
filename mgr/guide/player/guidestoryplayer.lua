local var0 = class("GuideStoryPlayer", import(".GuidePlayer"))

function var0.OnExecution(arg0, arg1, arg2)
	local var0 = arg1:GetStories()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			pg.NewStoryMgr.GetInstance():Play(iter1, arg0, true)
		end)
	end

	table.insert(var1, function(arg0)
		pg.m02:sendNotification(GAME.START_GUIDE)
		arg0()
	end)
	seriesAsync(var1, arg2)
end

return var0
