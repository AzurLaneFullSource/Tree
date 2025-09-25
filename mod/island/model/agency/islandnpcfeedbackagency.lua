local var0_0 = class("IslandNpcFeedbackAgency", import(".IslandBaseAgency"))

var0_0.NPC_ACTION_CHANGE = "IslandNpcFeedbackAgency:NPC_ACTION_CHANGE"
var0_0.RESET_NPC_ACTIONS = "IslandNpcFeedbackAgency:RESET_NPC_ACTIONS"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.npcList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.action_feedback_npc_list) do
		table.insert(arg0_1.npcList, iter1_1)
	end
end

function var0_0.GetNpcList(arg0_2)
	return arg0_2.npcList
end

function var0_0.AddNpc(arg0_3, arg1_3)
	table.insert(arg0_3.npcList, arg1_3)
	arg0_3:DispatchEvent(var0_0.NPC_ACTION_CHANGE, arg1_3)
end

function var0_0.UpdatePerDay(arg0_4)
	arg0_4.npcList = {}

	arg0_4:DispatchEvent(var0_0.RESET_NPC_ACTIONS)
end

return var0_0
