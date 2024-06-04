local var0 = class("PublicGuild", import("..base.BaseGuild"))
local var1 = pg.guild_technology_template

function var0.Ctor(arg0, arg1)
	arg0.technologyGroups = {}
	arg0.technologys = {}

	for iter0, iter1 in pairs(var1.get_id_list_by_group) do
		local var0 = GuildTechnologyGroup.New({
			id = iter0
		})

		arg0.technologyGroups[iter0] = var0

		local var1 = PublicGuildTechnology.New(var0)

		arg0.technologys[iter0] = var1
	end

	for iter2, iter3 in ipairs(arg1.technologys or {}) do
		local var2 = var1[iter3.id]

		arg0.technologyGroups[var2.group]:update(iter3)
	end

	arg0.maxDonateCntPreDay = pg.guildset.contribution_task_num.key_value
end

function var0.InitUser(arg0, arg1)
	arg0.donateCount = arg1.donate_count
	arg0.donateTasks = {}

	for iter0, iter1 in ipairs(arg1.donate_tasks or {}) do
		local var0 = GuildDonateTask.New({
			id = iter1
		})

		table.insert(arg0.donateTasks, var0)
	end

	for iter2, iter3 in ipairs(arg1.tech_id or {}) do
		local var1 = var1[iter3].group
		local var2 = arg0.technologys[var1]
		local var3 = arg0.technologyGroups[var1]

		var2:Update(iter3, var3)
	end
end

function var0.GetTechnologyGroups(arg0)
	return arg0.technologyGroups
end

function var0.GetDonateTasks(arg0)
	return arg0.donateTasks
end

function var0.GetTechnologys(arg0)
	return arg0.technologys
end

function var0.GetTechnologyById(arg0, arg1)
	return arg0.technologys[arg1]
end

function var0.GetDonateCount(arg0)
	return arg0.donateCount
end

function var0.GetDonateTaskById(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.donateTasks) do
		if iter1.id == arg1 then
			return iter1
		end
	end
end

function var0.HasDonateCnt(arg0)
	return arg0:GetRemainDonateCnt() > 0
end

function var0.UpdateDonateTasks(arg0, arg1)
	arg0.donateTasks = arg1
end

function var0.IncDonateCount(arg0)
	arg0.donateCount = arg0.donateCount + 1
end

function var0.GetRemainDonateCnt(arg0)
	return arg0.maxDonateCntPreDay - arg0.donateCount
end

function var0.ResetDonateCnt(arg0)
	arg0.donateCount = 0
end

return var0
