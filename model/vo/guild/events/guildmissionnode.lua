local var0_0 = class("GuildMissionNode", import("...BaseVO"))

var0_0.STATE_DOING = 0
var0_0.STATE_SUCCESS = 1
var0_0.STATE_FAILED = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.node_id
	arg0_1.configId = arg0_1.id
	arg0_1.position = arg1_1.position
	arg0_1.status = arg1_1.status
end

function var0_0.bindConfigTable(arg0_2)
	return pg.guild_event_node
end

function var0_0.GetPosition(arg0_3)
	return arg0_3.position
end

function var0_0.IsFinish(arg0_4)
	return arg0_4.status > 0
end

function var0_0.IsSuccess(arg0_5)
	return arg0_5.status > var0_0.STATE_SUCCESS
end

function var0_0.GetIcon(arg0_6)
	return arg0_6:getConfig("icon")
end

function var0_0.GetAwards(arg0_7)
	if arg0_7.status == var0_0.STATE_SUCCESS then
		return arg0_7:getConfig("success_award")
	elseif arg0_7.status == var0_0.STATE_FAILED then
		return arg0_7:getConfig("fail_award")
	end
end

function var0_0.GetLog(arg0_8)
	if arg0_8.status == var0_0.STATE_SUCCESS or arg0_8.status == var0_0.STATE_FAILED then
		local var0_8 = arg0_8:GetAwards()
		local var1_8 = getDropInfo(var0_8)
		local var2_8 = arg0_8:getConfig("fail_describe")

		if arg0_8.status == var0_0.STATE_SUCCESS then
			var2_8 = arg0_8:getConfig("success_describe")
		end

		return string.gsub(var2_8, "$1", var1_8)
	end
end

function var0_0.IsItemType(arg0_9)
	return arg0_9:getConfig("item") == "box"
end

function var0_0.IsBattleType(arg0_10)
	return arg0_10:getConfig("item") == "sairendanchuan"
end

return var0_0
