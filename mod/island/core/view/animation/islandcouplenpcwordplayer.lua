local var0_0 = class("IslandCoupleNpcWordPlayer", import("..IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.delayTime = pg.island_set.couple_word_cd.key_value_int
	arg0_1.schedule = {}
end

function var0_0.Play(arg0_2, arg1_2)
	if table.contains(arg0_2.schedule, arg1_2) then
		return
	end

	table.insert(arg0_2.schedule, arg1_2)

	if #arg0_2.schedule == 1 then
		arg0_2:Start()
	end
end

function var0_0.Start(arg0_3)
	if not arg0_3.schedule or #arg0_3.schedule <= 0 then
		return
	end

	local var0_3 = arg0_3.schedule[1]
	local var1_3 = IslandCoupleNpcWordTask.New(var0_3, arg0_3:GetView())

	var1_3:Execute(var0_3, function()
		arg0_3.player = nil

		table.remove(arg0_3.schedule, 1)
		arg0_3:DelayStart()
	end)

	arg0_3.player = var1_3
end

function var0_0.DelayStart(arg0_5)
	arg0_5:RemoveTimer()

	if #arg0_5.schedule <= 0 then
		return
	end

	arg0_5.timer = Timer.New(function()
		arg0_5:Start()
	end, arg0_5.delayTime, 1)

	arg0_5.timer:Start()
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.Stop(arg0_8, arg1_8)
	if table.contains(arg0_8.schedule, arg1_8) then
		table.removebyvalue(arg0_8.schedule, arg1_8)
	end

	if arg0_8.player and arg0_8.player:IsCurrentTask(arg1_8) then
		arg0_8.player:Stop()

		arg0_8.player = nil

		arg0_8:DelayStart()
	end
end

function var0_0.OnDispose(arg0_9)
	if arg0_9.player then
		arg0_9.player:Stop()
		arg0_9.player:Dispose()

		arg0_9.player = nil
	end

	arg0_9.schedule = nil

	arg0_9:RemoveTimer()
end

return var0_0
