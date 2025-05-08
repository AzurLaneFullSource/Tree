local var0_0 = class("IslandChatBubbleView", import("..IslandBaseSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandChatBubbleUI"
end

function var0_0.Flush(arg0_2)
	arg0_2.pool = {}
	arg0_2.runningPlayers = {}
end

function var0_0.Enqueue(arg0_3, arg1_3)
	if #arg0_3.pool >= 5 then
		return
	end

	table.insert(arg0_3.pool, arg1_3)
end

function var0_0.Delqueue(arg0_4)
	if #arg0_4.pool == 0 then
		return IslandChatBubblePlayer.New(arg0_4._go.transform)
	else
		return table.remove(arg0_4.pool, 1)
	end
end

function var0_0.Play(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5:Delqueue()
	local var1_5 = pg.NewStoryMgr.GetInstance():GetScript(arg1_5)
	local var2_5 = IslandStory.New(var1_5, arg2_5, IslandStory.MODE_BUBBLE)

	var0_5:Play(var2_5, function()
		table.removebyvalue(arg0_5.runningPlayers, var0_5)
		arg0_5:Enqueue(var0_5)

		if arg3_5 then
			arg3_5()
		end
	end)
	table.insert(arg0_5.runningPlayers, var0_5)
end

function var0_0.Stop(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.runningPlayers) do
		iter1_7:Stop()
	end

	arg0_7.runningPlayers = {}
end

function var0_0.OnDestroy(arg0_8)
	arg0_8:Stop()

	for iter0_8, iter1_8 in ipairs(arg0_8.pool) do
		iter1_8:Stop()
	end

	arg0_8.pool = {}
end

return var0_0
