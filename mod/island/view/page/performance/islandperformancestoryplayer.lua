local var0_0 = class("IslandPerformanceStoryPlayer", import(".IslandBasePerformancePlayer"))

function var0_0.Play(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1.name

	require("nodecanvas.Task.NcPlayStory").New(nil, {}):DoAction(var0_1, arg2_1)
end

function var0_0.Update(arg0_2)
	return
end

function var0_0.Clear(arg0_3)
	return
end

return var0_0
