local var0 = class("MetaCharacterTask")

var0.STATE_EMPTY = 1
var0.STATE_START = 2
var0.STATE_FINISHED = 3
var0.STATE_SUBMITED = 4

function var0.Ctor(arg0, arg1)
	arg0.taskId = arg1.taskId
	arg0.star = arg1.star
	arg0.level = arg1.level
	arg0.skillId = arg1.skillId
	arg0.isLearned = false
	arg0.prevTask = arg1.prev
	arg0.indexOfTaskList = arg1.indexofList
end

function var0.setIsLearned(arg0)
	arg0.isLearned = true
end

function var0.isLearnedTask(arg0)
	return arg0.isLearned
end

function var0.CanFetch(arg0, arg1)
	local var0 = arg1:getConfig("star")
	local var1 = arg1.level

	return var0 >= arg0.star and var1 >= arg0.level
end

function var0.GetTask(arg0)
	if arg0:isLearnedTask() then
		return Task.New({
			submitTime = 1,
			id = arg0.taskId
		})
	else
		return getProxy(TaskProxy):getTaskById(arg0.taskId) or Task.New({
			id = arg0.taskId
		})
	end
end

function var0.GetDesc(arg0)
	local var0 = pg.skill_data_template[arg0.skillId]

	if arg0.isLearned then
		return i18n("meta_learn_skill", var0.name)
	else
		return i18n1(var0.name .. "Lv+1")
	end
end

function var0.GetState(arg0)
	local var0 = getProxy(TaskProxy):getTaskVO(arg0.taskId)

	if not var0 then
		if arg0:isLearnedTask() then
			return MetaCharacterTask.STATE_SUBMITED
		else
			return MetaCharacterTask.STATE_EMPTY
		end
	else
		local var1 = var0:isFinish()
		local var2 = var0:isReceive()

		if var1 and var2 then
			return MetaCharacterTask.STATE_SUBMITED
		elseif var1 and not var2 then
			return MetaCharacterTask.STATE_FINISHED
		else
			return MetaCharacterTask.STATE_START
		end
	end
end

return var0
