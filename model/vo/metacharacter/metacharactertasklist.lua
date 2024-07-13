local var0_0 = class("MetaCharacterTaskList", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.skillId = arg0_1:getConfig("skill_ID")
	arg0_1.taskList = {}

	local var0_1 = arg0_1:getConfig("skill_levelup_task")
	local var1_1

	for iter0_1, iter1_1 in ipairs(var0_1) do
		local var2_1 = MetaCharacterTask.New({
			taskId = iter1_1[1],
			star = iter1_1[2],
			level = iter1_1[3],
			skillId = arg0_1.skillId,
			prev = var1_1,
			indexofList = iter0_1
		})

		table.insert(arg0_1.taskList, var2_1)

		var1_1 = var2_1
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.ship_meta_skilltask
end

function var0_0.getTaskList(arg0_3)
	return arg0_3.taskList
end

function var0_0.getSkillId(arg0_4)
	return arg0_4.skillId
end

function var0_0.getTaskByTaskId(arg0_5, arg1_5)
	return _.detect(arg0_5.taskList, function(arg0_6)
		return arg1_5 == arg0_6.id
	end)
end

return var0_0
