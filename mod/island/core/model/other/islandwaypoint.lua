local var0_0 = class("IslandWayPoint")

var0_0.ACTION_TYPE_CHATBUBBLE = 1
var0_0.ACTION_TYPE_ANIM = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.config = pg.island_waypoint[arg1_1]
	arg0_1.position = BuildVector3(arg0_1.config.position)
	arg0_1.processAction = nil
	arg0_1.arriveAction = nil
end

function var0_0.RandomProcessAction(arg0_2)
	arg0_2.processAction = arg0_2:BuildAction(arg0_2.config.process_action, arg0_2.config.process_dialogue, arg0_2.config.process_time)
end

function var0_0.GetActionWhenProcess(arg0_3)
	return arg0_3.processAction
end

function var0_0.RandomArriveAction(arg0_4)
	arg0_4.arriveAction = arg0_4:BuildAction(arg0_4.config.arrive_action, arg0_4.config.arrive_dialogue, 0)
end

function var0_0.GetActionWhenArrive(arg0_5)
	return arg0_5.arriveAction
end

function var0_0.GetRotationWhenArrive(arg0_6)
	if arg0_6.config.turn_to == 0 then
		return 0
	end

	return arg0_6.config.rotation or 0
end

function var0_0.DisappearWhenArrive(arg0_7)
	return arg0_7.config.disappear == 1
end

function var0_0.GetStartNextOneTime(arg0_8)
	return arg0_8.config.wait or 0
end

function var0_0.BuildAction(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = #arg1_9
	local var1_9 = arg2_9 ~= ""

	if var1_9 then
		var0_9 = var0_9 + 1
	end

	if var0_9 == 0 then
		return nil
	end

	local var2_9 = math.random(1, var0_9)

	if var1_9 and var2_9 == var0_9 then
		return {
			type = var0_0.ACTION_TYPE_CHATBUBBLE,
			action = arg2_9,
			time = arg3_9
		}
	else
		return {
			type = var0_0.ACTION_TYPE_ANIM,
			action = arg1_9[var2_9],
			time = arg3_9
		}
	end
end

return var0_0
