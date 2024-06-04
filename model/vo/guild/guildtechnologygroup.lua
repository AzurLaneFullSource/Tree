local var0 = class("GuildTechnologyGroup", import("..BaseVO"))

var0.STATE_STOP = 0
var0.STATE_START = 1

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id

	local var0 = arg0:bindConfigTable().get_id_list_by_group[arg0.id][1]

	arg0:update({
		state = 0,
		progress = 0,
		id = var0,
		fake_id = var0
	})
end

function var0.update(arg0, arg1)
	arg0.pid = arg1.id
	arg0.configId = arg0.pid
	arg0.state = arg1.state or 0
	arg0.progress = arg1.progress or 0
	arg0.fakeId = arg1.fake_id or arg0.fakeId or arg1.id
end

function var0.AddProgress(arg0, arg1)
	arg0.progress = arg0.progress + arg1

	if arg0:GetTargetProgress() <= arg0.progress then
		arg0:LevelUp()
	end
end

function var0.LevelUp(arg0)
	local var0 = arg0:GetNextId()

	arg0:update({
		progress = 0,
		id = var0,
		state = arg0.state,
		fake_id = arg0.fakeId
	})
end

function var0.GetNextId(arg0)
	local var0 = arg0:getConfig("next_tech")

	if var0 == 0 then
		return arg0.pid
	else
		return var0
	end
end

function var0.GetState(arg0)
	return arg0.state
end

function var0.GetTargetProgress(arg0)
	return arg0:getConfig("exp")
end

function var0.GetProgress(arg0)
	return arg0.progress
end

function var0.GetFakeLevel(arg0)
	return arg0:bindConfigTable()[arg0.fakeId].level
end

function var0.GetLevel(arg0)
	return arg0:getConfig("level")
end

function var0.GetMaxLevel(arg0)
	return arg0:getConfig("level_max")
end

function var0.isMaxLevel(arg0)
	return arg0:GetLevel() >= arg0:GetMaxLevel()
end

function var0.bindConfigTable(arg0)
	return pg.guild_technology_template
end

function var0.GuildMemberCntType(arg0)
	return arg0:getConfig("effect_args")[1] == GuildConst.TYPE_GUILD_MEMBER_CNT
end

function var0.isStarting(arg0)
	return arg0.state == var0.STATE_START
end

function var0.GetDesc(arg0)
	local var0 = arg0:bindConfigTable()
	local var1 = var0[arg0.pid].next_tech

	assert(var1, arg0.pid)

	local var2 = var0[arg0.pid].effect_args

	if var1 == 0 then
		local var3 = var0[arg0.pid].num
		local var4 = var0[arg0.pid].num

		return GuildConst.GET_TECHNOLOGY_GROUP_DESC(var2, var3, var4)
	else
		local var5 = var0[arg0.pid].num
		local var6 = var0[var1].num

		return GuildConst.GET_TECHNOLOGY_GROUP_DESC(var2, var5, var6)
	end
end

function var0.Stop(arg0)
	arg0.state = var0.STATE_STOP
end

function var0.Start(arg0)
	arg0.state = var0.STATE_START
end

return var0
