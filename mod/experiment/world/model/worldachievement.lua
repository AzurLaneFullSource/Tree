local var0_0 = class("WorldAchievement", import("...BaseEntity"))

var0_0.Fields = {
	triggers = "table",
	id = "number",
	config = "table"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.config = pg.world_target_data[arg0_1.id]

	assert(arg0_1.config, "world_target_data not exist: " .. arg0_1.id)

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg0_1.config.condition) do
		local var1_1 = WorldTrigger.New()

		var1_1:Setup(iter1_1[1])

		var1_1.progress = 0
		var1_1.maxProgress = iter1_1[2]
		var1_1.desc = arg0_1.config.condition_text[iter0_1]

		table.insert(var0_1, var1_1)
	end

	arg0_1.triggers = var0_1
end

function var0_0.NetUpdate(arg0_2, arg1_2)
	local var0_2
	local var1_2 = {}

	_.each(arg1_2, function(arg0_3)
		local var0_3 = arg0_2:GetTrigger(arg0_3.trigger_id)

		assert(var0_3, "can not find trigger: " .. arg0_3.trigger_id)

		if var0_3 then
			local var1_3 = var0_3:IsAchieved()

			var0_3.progress = arg0_3.count

			if not var1_3 and var0_3:IsAchieved() then
				if #arg0_2.triggers > 1 then
					table.insert(var1_2, var0_3:GetDesc())
				end

				if arg0_2:IsAchieved() then
					var0_2 = arg0_2
				end
			end
		end
	end)

	return var1_2, var0_2
end

function var0_0.GetTrigger(arg0_4, arg1_4)
	return _.detect(arg0_4.triggers, function(arg0_5)
		return arg0_5.id == arg1_4
	end)
end

function var0_0.GetTriggers(arg0_6)
	return arg0_6.triggers
end

function var0_0.IsAchieved(arg0_7)
	return _.all(arg0_7.triggers, function(arg0_8)
		return arg0_8:IsAchieved()
	end)
end

function var0_0.GetProgress(arg0_9)
	if #arg0_9.triggers > 1 then
		return _.reduce(arg0_9.triggers, 0, function(arg0_10, arg1_10)
			return arg0_10 + (arg1_10:IsAchieved() and 1 or 0)
		end)
	else
		return arg0_9.triggers[1]:GetProgress()
	end
end

function var0_0.GetMaxProgress(arg0_11)
	if #arg0_11.triggers > 1 then
		return #arg0_11.triggers
	else
		return arg0_11.triggers[1]:GetMaxProgress()
	end
end

return var0_0
