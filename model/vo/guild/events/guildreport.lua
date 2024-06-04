local var0 = class("GuildReport", import("...BaseVO"))

var0.SCORE_TYPE_S = 1
var0.SCORE_TYPE_A = 2
var0.SCORE_TYPE_B = 3

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.eventId = arg1.event_id
	arg0.configId = arg0.eventId
	arg0.score = arg1.score
	arg0.state = GuildConst.REPORT_STATE_LOCK
	arg0.nodeAwards = {}

	local var0 = {}

	for iter0, iter1 in ipairs(arg1.nodes) do
		local var1
		local var2 = Clone(pg.guild_event_node[iter1.id])

		if iter1.status == 1 then
			var1 = var2.success_award
		else
			var1 = var2.fail_award
		end

		for iter2, iter3 in ipairs(var1) do
			if not var0[iter3[2]] then
				var0[iter3[2]] = iter3
			else
				var0[iter3[2]][3] = var0[iter3[2]][3] + iter3[3]
			end
		end
	end

	for iter4, iter5 in pairs(var0) do
		table.insert(arg0.nodeAwards, iter5)
	end

	arg0:SetStatus(arg1.status)
end

function var0.SetStatus(arg0, arg1)
	arg0.state = arg1
end

function var0.IsBoss(arg0)
	return false
end

function var0.IsLock(arg0)
	return arg0.state == GuildConst.REPORT_STATE_LOCK
end

function var0.IsUnlock(arg0)
	return arg0.state > GuildConst.REPORT_STATE_LOCK
end

function var0.CanSubmit(arg0)
	return arg0.state == GuildConst.REPORT_STATE_UNlOCK
end

function var0.IsSubmited(arg0)
	return arg0.state == GuildConst.REPORT_STATE_SUBMITED
end

function var0.Submit(arg0)
	if arg0:CanSubmit() then
		arg0.state = GuildConst.REPORT_STATE_SUBMITED
	end
end

function var0.bindConfigTable(arg0)
	return pg.guild_base_event
end

function var0.GetReportDesc(arg0)
	return arg0:getConfig("report")[arg0.score]
end

function var0.IsPerfectFinish(arg0)
	return arg0.score == var0.SCORE_TYPE_S
end

function var0.GetSelfDrop(arg0)
	if arg0.score == var0.SCORE_TYPE_S then
		return arg0:getConfig("award_list_report")
	else
		return {}
	end
end

function var0.GetNodeDrop(arg0)
	return arg0.nodeAwards
end

function var0.GetDrop(arg0)
	local var0 = {}
	local var1 = arg0:GetSelfDrop()
	local var2 = arg0:GetNodeDrop()

	for iter0, iter1 in ipairs(var1) do
		table.insert(var0, iter1)
	end

	for iter2, iter3 in ipairs(var2) do
		table.insert(var0, iter3)
	end

	return var0, #var1
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

return var0
