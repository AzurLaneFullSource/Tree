local var0_0 = class("IslandStrollUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1 = pg.island_strollnpc[arg2_1]

	arg0_1.shipId = arg1_1

	var0_0.super.Ctor(arg0_1, {
		name = "StrollNpc",
		id = arg2_1,
		type = IslandConst.UNIT_TYPE_STROLL,
		modelId = arg3_1 or var0_1.unit_id,
		behaviourTree = arg0_1:GetDefaultBt(var0_1),
		position = {
			0,
			0,
			0
		},
		rotation = {
			0,
			0,
			0
		},
		scale = {
			0,
			0,
			0
		}
	})

	arg0_1.config = var0_1
	arg0_1.actionFeedback = nil
end

function var0_0.IsSameShip(arg0_2, arg1_2)
	return arg0_2.shipId == arg1_2
end

function var0_0.SetActionFeedback(arg0_3, arg1_3)
	arg0_3.actionFeedback = arg1_3
end

function var0_0.GetActionFeedback(arg0_4)
	return arg0_4.actionFeedback
end

function var0_0.ExistActionFeedback(arg0_5)
	return arg0_5.actionFeedback
end

function var0_0.ClearActionFeedback(arg0_6)
	arg0_6.actionFeedback = nil
end

local function var1_0(arg0_7, arg1_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		if pg.island_action_feedback[iter1_7].feedback_type == arg0_7 then
			table.insert(var0_7, iter1_7)
		end
	end

	if #var0_7 <= 0 then
		return nil
	end

	return var0_7[math.random(1, #var0_7)]
end

function var0_0.GetResponeAction(arg0_8, arg1_8)
	local var0_8 = arg0_8.actionFeedback and arg0_8.actionFeedback == arg1_8
	local var1_8 = pg.island_action[arg1_8].feedback_type

	if var0_8 then
		local var2_8 = pg.island_action_feedback.get_id_list_by_condition[1]

		return var1_0(var1_8, var2_8), true
	else
		local var3_8 = pg.island_action_feedback.get_id_list_by_condition[2]

		return var1_0(var1_8, var3_8), false
	end
end

function var0_0.GetDefaultBt(arg0_9, arg1_9)
	if not arg1_9.behaviourTree or arg1_9.behaviourTree == "" then
		return "Island/NodeCanvas/Npc/StrollNpc"
	end

	return arg1_9.behaviourTree
end

function var0_0.GetDefaultPathId(arg0_10, arg1_10)
	local var0_10 = _.detect(arg0_10.config.mapId, function(arg0_11)
		return arg0_11[1] == arg1_10
	end)

	return var0_10 and var0_10[2]
end

function var0_0.SetPath(arg0_12, arg1_12, arg2_12)
	arg0_12.position = BuildVector3(arg2_12)
	arg0_12.pathId = arg1_12
end

function var0_0.GetPath(arg0_13)
	return arg0_13.pathId
end

return var0_0
