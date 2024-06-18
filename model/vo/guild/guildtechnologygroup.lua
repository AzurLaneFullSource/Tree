local var0_0 = class("GuildTechnologyGroup", import("..BaseVO"))

var0_0.STATE_STOP = 0
var0_0.STATE_START = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id

	local var0_1 = arg0_1:bindConfigTable().get_id_list_by_group[arg0_1.id][1]

	arg0_1:update({
		state = 0,
		progress = 0,
		id = var0_1,
		fake_id = var0_1
	})
end

function var0_0.update(arg0_2, arg1_2)
	arg0_2.pid = arg1_2.id
	arg0_2.configId = arg0_2.pid
	arg0_2.state = arg1_2.state or 0
	arg0_2.progress = arg1_2.progress or 0
	arg0_2.fakeId = arg1_2.fake_id or arg0_2.fakeId or arg1_2.id
end

function var0_0.AddProgress(arg0_3, arg1_3)
	arg0_3.progress = arg0_3.progress + arg1_3

	if arg0_3:GetTargetProgress() <= arg0_3.progress then
		arg0_3:LevelUp()
	end
end

function var0_0.LevelUp(arg0_4)
	local var0_4 = arg0_4:GetNextId()

	arg0_4:update({
		progress = 0,
		id = var0_4,
		state = arg0_4.state,
		fake_id = arg0_4.fakeId
	})
end

function var0_0.GetNextId(arg0_5)
	local var0_5 = arg0_5:getConfig("next_tech")

	if var0_5 == 0 then
		return arg0_5.pid
	else
		return var0_5
	end
end

function var0_0.GetState(arg0_6)
	return arg0_6.state
end

function var0_0.GetTargetProgress(arg0_7)
	return arg0_7:getConfig("exp")
end

function var0_0.GetProgress(arg0_8)
	return arg0_8.progress
end

function var0_0.GetFakeLevel(arg0_9)
	return arg0_9:bindConfigTable()[arg0_9.fakeId].level
end

function var0_0.GetLevel(arg0_10)
	return arg0_10:getConfig("level")
end

function var0_0.GetMaxLevel(arg0_11)
	return arg0_11:getConfig("level_max")
end

function var0_0.isMaxLevel(arg0_12)
	return arg0_12:GetLevel() >= arg0_12:GetMaxLevel()
end

function var0_0.bindConfigTable(arg0_13)
	return pg.guild_technology_template
end

function var0_0.GuildMemberCntType(arg0_14)
	return arg0_14:getConfig("effect_args")[1] == GuildConst.TYPE_GUILD_MEMBER_CNT
end

function var0_0.isStarting(arg0_15)
	return arg0_15.state == var0_0.STATE_START
end

function var0_0.GetDesc(arg0_16)
	local var0_16 = arg0_16:bindConfigTable()
	local var1_16 = var0_16[arg0_16.pid].next_tech

	assert(var1_16, arg0_16.pid)

	local var2_16 = var0_16[arg0_16.pid].effect_args

	if var1_16 == 0 then
		local var3_16 = var0_16[arg0_16.pid].num
		local var4_16 = var0_16[arg0_16.pid].num

		return GuildConst.GET_TECHNOLOGY_GROUP_DESC(var2_16, var3_16, var4_16)
	else
		local var5_16 = var0_16[arg0_16.pid].num
		local var6_16 = var0_16[var1_16].num

		return GuildConst.GET_TECHNOLOGY_GROUP_DESC(var2_16, var5_16, var6_16)
	end
end

function var0_0.Stop(arg0_17)
	arg0_17.state = var0_0.STATE_STOP
end

function var0_0.Start(arg0_18)
	arg0_18.state = var0_0.STATE_START
end

return var0_0
