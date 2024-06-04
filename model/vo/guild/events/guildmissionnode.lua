local var0 = class("GuildMissionNode", import("...BaseVO"))

var0.STATE_DOING = 0
var0.STATE_SUCCESS = 1
var0.STATE_FAILED = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.node_id
	arg0.configId = arg0.id
	arg0.position = arg1.position
	arg0.status = arg1.status
end

function var0.bindConfigTable(arg0)
	return pg.guild_event_node
end

function var0.GetPosition(arg0)
	return arg0.position
end

function var0.IsFinish(arg0)
	return arg0.status > 0
end

function var0.IsSuccess(arg0)
	return arg0.status > var0.STATE_SUCCESS
end

function var0.GetIcon(arg0)
	return arg0:getConfig("icon")
end

function var0.GetAwards(arg0)
	if arg0.status == var0.STATE_SUCCESS then
		return arg0:getConfig("success_award")
	elseif arg0.status == var0.STATE_FAILED then
		return arg0:getConfig("fail_award")
	end
end

function var0.GetLog(arg0)
	if arg0.status == var0.STATE_SUCCESS or arg0.status == var0.STATE_FAILED then
		local var0 = arg0:GetAwards()
		local var1 = getDropInfo(var0)
		local var2 = arg0:getConfig("fail_describe")

		if arg0.status == var0.STATE_SUCCESS then
			var2 = arg0:getConfig("success_describe")
		end

		return string.gsub(var2, "$1", var1)
	end
end

function var0.IsItemType(arg0)
	return arg0:getConfig("item") == "box"
end

function var0.IsBattleType(arg0)
	return arg0:getConfig("item") == "sairendanchuan"
end

return var0
