local var0_0 = class("WeekPtTask", import(".Task"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.isWeekTask = true
end

function var0_0.bindConfigTable(arg0_2)
	return pg.weekly_task_template
end

function var0_0.getConfig(arg0_3, arg1_3)
	local var0_3 = arg0_3:bindConfigTable()[arg0_3.configId]

	assert(var0_3, arg0_3.configId)

	if var0_3[arg1_3] then
		if arg1_3 == "award_display" then
			return {
				var0_3[arg1_3]
			}
		else
			return var0_3[arg1_3]
		end
	elseif arg1_3 == "name" or arg1_3 == "story_id" or arg1_3 == "story_icon" or arg1_3 == "scene" then
		return ""
	elseif arg1_3 == "type" then
		return 4
	elseif arg1_3 == "level" or arg1_3 == "visibility" then
		return 1
	elseif arg1_3 == "priority_type" then
		return 0
	elseif arg1_3 == "award_choice" then
		return nil
	else
		assert(false, "表 weekly_task_template 没有字段:" .. arg1_3)
	end
end

function var0_0.GetAward(arg0_4)
	return arg0_4:getConfig("award_display")[1]
end

function var0_0.IsFinished(arg0_5)
	return arg0_5:isFinish()
end

return var0_0
