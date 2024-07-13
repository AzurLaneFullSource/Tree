local var0_0 = class("PublicGuild", import("..base.BaseGuild"))
local var1_0 = pg.guild_technology_template

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.technologyGroups = {}
	arg0_1.technologys = {}

	for iter0_1, iter1_1 in pairs(var1_0.get_id_list_by_group) do
		local var0_1 = GuildTechnologyGroup.New({
			id = iter0_1
		})

		arg0_1.technologyGroups[iter0_1] = var0_1

		local var1_1 = PublicGuildTechnology.New(var0_1)

		arg0_1.technologys[iter0_1] = var1_1
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.technologys or {}) do
		local var2_1 = var1_0[iter3_1.id]

		arg0_1.technologyGroups[var2_1.group]:update(iter3_1)
	end

	arg0_1.maxDonateCntPreDay = pg.guildset.contribution_task_num.key_value
end

function var0_0.InitUser(arg0_2, arg1_2)
	arg0_2.donateCount = arg1_2.donate_count
	arg0_2.donateTasks = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.donate_tasks or {}) do
		local var0_2 = GuildDonateTask.New({
			id = iter1_2
		})

		table.insert(arg0_2.donateTasks, var0_2)
	end

	for iter2_2, iter3_2 in ipairs(arg1_2.tech_id or {}) do
		local var1_2 = var1_0[iter3_2].group
		local var2_2 = arg0_2.technologys[var1_2]
		local var3_2 = arg0_2.technologyGroups[var1_2]

		var2_2:Update(iter3_2, var3_2)
	end
end

function var0_0.GetTechnologyGroups(arg0_3)
	return arg0_3.technologyGroups
end

function var0_0.GetDonateTasks(arg0_4)
	return arg0_4.donateTasks
end

function var0_0.GetTechnologys(arg0_5)
	return arg0_5.technologys
end

function var0_0.GetTechnologyById(arg0_6, arg1_6)
	return arg0_6.technologys[arg1_6]
end

function var0_0.GetDonateCount(arg0_7)
	return arg0_7.donateCount
end

function var0_0.GetDonateTaskById(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.donateTasks) do
		if iter1_8.id == arg1_8 then
			return iter1_8
		end
	end
end

function var0_0.HasDonateCnt(arg0_9)
	return arg0_9:GetRemainDonateCnt() > 0
end

function var0_0.UpdateDonateTasks(arg0_10, arg1_10)
	arg0_10.donateTasks = arg1_10
end

function var0_0.IncDonateCount(arg0_11)
	arg0_11.donateCount = arg0_11.donateCount + 1
end

function var0_0.GetRemainDonateCnt(arg0_12)
	return arg0_12.maxDonateCntPreDay - arg0_12.donateCount
end

function var0_0.ResetDonateCnt(arg0_13)
	arg0_13.donateCount = 0
end

return var0_0
