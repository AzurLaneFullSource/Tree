local var0 = class("WeekPtTask", import(".Task"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.isWeekTask = true
end

function var0.bindConfigTable(arg0)
	return pg.weekly_task_template
end

function var0.getConfig(arg0, arg1)
	local var0 = arg0:bindConfigTable()[arg0.configId]

	assert(var0, arg0.configId)

	if var0[arg1] then
		if arg1 == "award_display" then
			return {
				var0[arg1]
			}
		else
			return var0[arg1]
		end
	elseif arg1 == "name" or arg1 == "story_id" or arg1 == "story_icon" or arg1 == "scene" then
		return ""
	elseif arg1 == "type" then
		return 4
	elseif arg1 == "level" or arg1 == "visibility" then
		return 1
	elseif arg1 == "priority_type" then
		return 0
	elseif arg1 == "award_choice" then
		return nil
	else
		assert(false, "表 weekly_task_template 没有字段:" .. arg1)
	end
end

function var0.GetAward(arg0)
	return arg0:getConfig("award_display")[1]
end

function var0.IsFinished(arg0)
	return arg0:isFinish()
end

return var0
