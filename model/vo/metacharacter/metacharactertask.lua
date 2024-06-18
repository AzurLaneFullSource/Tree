local var0_0 = class("MetaCharacterTask")

var0_0.STATE_EMPTY = 1
var0_0.STATE_START = 2
var0_0.STATE_FINISHED = 3
var0_0.STATE_SUBMITED = 4

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.taskId = arg1_1.taskId
	arg0_1.star = arg1_1.star
	arg0_1.level = arg1_1.level
	arg0_1.skillId = arg1_1.skillId
	arg0_1.isLearned = false
	arg0_1.prevTask = arg1_1.prev
	arg0_1.indexOfTaskList = arg1_1.indexofList
end

function var0_0.setIsLearned(arg0_2)
	arg0_2.isLearned = true
end

function var0_0.isLearnedTask(arg0_3)
	return arg0_3.isLearned
end

function var0_0.CanFetch(arg0_4, arg1_4)
	local var0_4 = arg1_4:getConfig("star")
	local var1_4 = arg1_4.level

	return var0_4 >= arg0_4.star and var1_4 >= arg0_4.level
end

function var0_0.GetTask(arg0_5)
	if arg0_5:isLearnedTask() then
		return Task.New({
			submitTime = 1,
			id = arg0_5.taskId
		})
	else
		return getProxy(TaskProxy):getTaskById(arg0_5.taskId) or Task.New({
			id = arg0_5.taskId
		})
	end
end

function var0_0.GetDesc(arg0_6)
	local var0_6 = pg.skill_data_template[arg0_6.skillId]

	if arg0_6.isLearned then
		return i18n("meta_learn_skill", var0_6.name)
	else
		return i18n1(var0_6.name .. "Lv+1")
	end
end

function var0_0.GetState(arg0_7)
	local var0_7 = getProxy(TaskProxy):getTaskVO(arg0_7.taskId)

	if not var0_7 then
		if arg0_7:isLearnedTask() then
			return MetaCharacterTask.STATE_SUBMITED
		else
			return MetaCharacterTask.STATE_EMPTY
		end
	else
		local var1_7 = var0_7:isFinish()
		local var2_7 = var0_7:isReceive()

		if var1_7 and var2_7 then
			return MetaCharacterTask.STATE_SUBMITED
		elseif var1_7 and not var2_7 then
			return MetaCharacterTask.STATE_FINISHED
		else
			return MetaCharacterTask.STATE_START
		end
	end
end

return var0_0
