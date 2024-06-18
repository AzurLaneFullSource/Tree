local var0_0 = class("GuildReport", import("...BaseVO"))

var0_0.SCORE_TYPE_S = 1
var0_0.SCORE_TYPE_A = 2
var0_0.SCORE_TYPE_B = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.eventId = arg1_1.event_id
	arg0_1.configId = arg0_1.eventId
	arg0_1.score = arg1_1.score
	arg0_1.state = GuildConst.REPORT_STATE_LOCK
	arg0_1.nodeAwards = {}

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.nodes) do
		local var1_1
		local var2_1 = Clone(pg.guild_event_node[iter1_1.id])

		if iter1_1.status == 1 then
			var1_1 = var2_1.success_award
		else
			var1_1 = var2_1.fail_award
		end

		for iter2_1, iter3_1 in ipairs(var1_1) do
			if not var0_1[iter3_1[2]] then
				var0_1[iter3_1[2]] = iter3_1
			else
				var0_1[iter3_1[2]][3] = var0_1[iter3_1[2]][3] + iter3_1[3]
			end
		end
	end

	for iter4_1, iter5_1 in pairs(var0_1) do
		table.insert(arg0_1.nodeAwards, iter5_1)
	end

	arg0_1:SetStatus(arg1_1.status)
end

function var0_0.SetStatus(arg0_2, arg1_2)
	arg0_2.state = arg1_2
end

function var0_0.IsBoss(arg0_3)
	return false
end

function var0_0.IsLock(arg0_4)
	return arg0_4.state == GuildConst.REPORT_STATE_LOCK
end

function var0_0.IsUnlock(arg0_5)
	return arg0_5.state > GuildConst.REPORT_STATE_LOCK
end

function var0_0.CanSubmit(arg0_6)
	return arg0_6.state == GuildConst.REPORT_STATE_UNlOCK
end

function var0_0.IsSubmited(arg0_7)
	return arg0_7.state == GuildConst.REPORT_STATE_SUBMITED
end

function var0_0.Submit(arg0_8)
	if arg0_8:CanSubmit() then
		arg0_8.state = GuildConst.REPORT_STATE_SUBMITED
	end
end

function var0_0.bindConfigTable(arg0_9)
	return pg.guild_base_event
end

function var0_0.GetReportDesc(arg0_10)
	return arg0_10:getConfig("report")[arg0_10.score]
end

function var0_0.IsPerfectFinish(arg0_11)
	return arg0_11.score == var0_0.SCORE_TYPE_S
end

function var0_0.GetSelfDrop(arg0_12)
	if arg0_12.score == var0_0.SCORE_TYPE_S then
		return arg0_12:getConfig("award_list_report")
	else
		return {}
	end
end

function var0_0.GetNodeDrop(arg0_13)
	return arg0_13.nodeAwards
end

function var0_0.GetDrop(arg0_14)
	local var0_14 = {}
	local var1_14 = arg0_14:GetSelfDrop()
	local var2_14 = arg0_14:GetNodeDrop()

	for iter0_14, iter1_14 in ipairs(var1_14) do
		table.insert(var0_14, iter1_14)
	end

	for iter2_14, iter3_14 in ipairs(var2_14) do
		table.insert(var0_14, iter3_14)
	end

	return var0_14, #var1_14
end

function var0_0.GetType(arg0_15)
	return arg0_15:getConfig("type")
end

return var0_0
