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
	arg0_1.skillActionFeedback = nil
end

function var0_0.GetShipId(arg0_2)
	return arg0_2.shipId
end

function var0_0.IsSameShip(arg0_3, arg1_3)
	return arg0_3.shipId == arg1_3
end

function var0_0.SetSkillActionFeedback(arg0_4, arg1_4)
	arg0_4.skillActionFeedback = arg1_4
end

function var0_0.ClearSkillActionFeedback(arg0_5)
	arg0_5.skillActionFeedback = nil
end

function var0_0.ExistSkillActionFeedback(arg0_6)
	return arg0_6.skillActionFeedback ~= nil
end

function var0_0.SetActionFeedback(arg0_7, arg1_7)
	arg0_7.actionFeedback = arg1_7
end

function var0_0.ExistActionFeedback(arg0_8)
	return arg0_8.actionFeedback ~= nil
end

function var0_0.ClearActionFeedback(arg0_9)
	arg0_9.actionFeedback = nil
end

function var0_0.GetGreetingFeedback(arg0_10)
	return arg0_10.actionFeedback or arg0_10.skillActionFeedback
end

function var0_0.ExistGreetingActionFeedback(arg0_11)
	return arg0_11:GetGreetingFeedback() ~= nil
end

function var0_0.ClearGreetingActionFeedback(arg0_12)
	arg0_12.actionFeedback = nil
	arg0_12.skillActionFeedback = nil
end

function var0_0.OnlySkillActionFeedback(arg0_13)
	return not arg0_13:ExistActionFeedback() and arg0_13:ExistSkillActionFeedback()
end

local function var1_0(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		if pg.island_action_feedback[iter1_14].feedback_type == arg0_14 then
			table.insert(var0_14, iter1_14)
		end
	end

	if #var0_14 <= 0 then
		return nil
	end

	return var0_14[math.random(1, #var0_14)]
end

function var0_0.GetResponeAction(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetGreetingFeedback()
	local var1_15 = var0_15 and var0_15 == arg1_15
	local var2_15 = pg.island_action[arg1_15].feedback_type

	if var1_15 then
		local var3_15 = pg.island_action_feedback.get_id_list_by_condition[1]

		return var1_0(var2_15, var3_15), true
	else
		local var4_15 = pg.island_action_feedback.get_id_list_by_condition[2]

		return var1_0(var2_15, var4_15), false
	end
end

function var0_0.GetDefaultBt(arg0_16, arg1_16)
	if not arg1_16.behaviourTree or arg1_16.behaviourTree == "" then
		return "Island/NodeCanvas/Npc/StrollNpc"
	end

	return arg1_16.behaviourTree
end

function var0_0.GetDefaultPathId(arg0_17, arg1_17)
	local var0_17 = _.detect(arg0_17.config.mapId, function(arg0_18)
		return arg0_18[1] == arg1_17
	end)

	return var0_17 and var0_17[2]
end

function var0_0.SetPath(arg0_19, arg1_19, arg2_19)
	arg0_19.position = BuildVector3(arg2_19)
	arg0_19.pathId = arg1_19
end

function var0_0.GetPath(arg0_20)
	return arg0_20.pathId
end

return var0_0
