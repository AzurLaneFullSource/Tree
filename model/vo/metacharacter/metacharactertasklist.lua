local var0 = class("MetaCharacterTaskList", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.skillId = arg0:getConfig("skill_ID")
	arg0.taskList = {}

	local var0 = arg0:getConfig("skill_levelup_task")
	local var1

	for iter0, iter1 in ipairs(var0) do
		local var2 = MetaCharacterTask.New({
			taskId = iter1[1],
			star = iter1[2],
			level = iter1[3],
			skillId = arg0.skillId,
			prev = var1,
			indexofList = iter0
		})

		table.insert(arg0.taskList, var2)

		var1 = var2
	end
end

function var0.bindConfigTable(arg0)
	return pg.ship_meta_skilltask
end

function var0.getTaskList(arg0)
	return arg0.taskList
end

function var0.getSkillId(arg0)
	return arg0.skillId
end

function var0.getTaskByTaskId(arg0, arg1)
	return _.detect(arg0.taskList, function(arg0)
		return arg1 == arg0.id
	end)
end

return var0
