local var0 = class("WorldAchievement", import("...BaseEntity"))

var0.Fields = {
	triggers = "table",
	id = "number",
	config = "table"
}

function var0.Setup(arg0, arg1)
	arg0.id = arg1
	arg0.config = pg.world_target_data[arg0.id]

	assert(arg0.config, "world_target_data not exist: " .. arg0.id)

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.config.condition) do
		local var1 = WorldTrigger.New()

		var1:Setup(iter1[1])

		var1.progress = 0
		var1.maxProgress = iter1[2]
		var1.desc = arg0.config.condition_text[iter0]

		table.insert(var0, var1)
	end

	arg0.triggers = var0
end

function var0.NetUpdate(arg0, arg1)
	local var0
	local var1 = {}

	_.each(arg1, function(arg0)
		local var0 = arg0:GetTrigger(arg0.trigger_id)

		assert(var0, "can not find trigger: " .. arg0.trigger_id)

		if var0 then
			local var1 = var0:IsAchieved()

			var0.progress = arg0.count

			if not var1 and var0:IsAchieved() then
				if #arg0.triggers > 1 then
					table.insert(var1, var0:GetDesc())
				end

				if arg0:IsAchieved() then
					var0 = arg0
				end
			end
		end
	end)

	return var1, var0
end

function var0.GetTrigger(arg0, arg1)
	return _.detect(arg0.triggers, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.GetTriggers(arg0)
	return arg0.triggers
end

function var0.IsAchieved(arg0)
	return _.all(arg0.triggers, function(arg0)
		return arg0:IsAchieved()
	end)
end

function var0.GetProgress(arg0)
	if #arg0.triggers > 1 then
		return _.reduce(arg0.triggers, 0, function(arg0, arg1)
			return arg0 + (arg1:IsAchieved() and 1 or 0)
		end)
	else
		return arg0.triggers[1]:GetProgress()
	end
end

function var0.GetMaxProgress(arg0)
	if #arg0.triggers > 1 then
		return #arg0.triggers
	else
		return arg0.triggers[1]:GetMaxProgress()
	end
end

return var0
