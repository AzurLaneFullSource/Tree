local var0_0 = class("IslandActivityNpcAgency", import(".IslandBaseAgency"))

var0_0.ACTIVITY_NPC_ADD = "IslandActivityNpcAgency:ACTIVITY_NPC_ADD"
var0_0.ACTIVITY_NPC_UPDATE = "IslandActivityNpcAgency:ACTIVITY_NPC_UPDATE"
var0_0.ACTIVITY_NPC_DEL = "IslandActivityNpcAgency:ACTIVITY_NPC_DEL"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.activityNpcs = {}
end

function var0_0.InitNpcList(arg0_2, arg1_2)
	arg0_2.activityNpcs = {}

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		arg0_2.activityNpcs[iter1_2.id] = iter1_2.object_id
	end
end

function var0_0.GetNpcList(arg0_3)
	return arg0_3.activityNpcs
end

function var0_0.GetNpcObjects(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.activityNpcs) do
		table.insert(var0_4, iter1_4)
	end

	return var0_4
end

function var0_0.AddNpc(arg0_5, arg1_5)
	if not arg0_5:IncludeNpc(arg1_5) then
		arg0_5.activityNpcs[arg1_5.id] = arg1_5.object_id

		arg0_5:DispatchEvent(var0_0.ACTIVITY_NPC_ADD, arg1_5.object_id)
	end
end

function var0_0.UpdateNpc(arg0_6, arg1_6)
	if arg0_6:IncludeNpc(arg1_6) then
		local var0_6 = arg0_6.activityNpcs[arg1_6.id]

		arg0_6.activityNpcs[arg1_6.id] = arg1_6.object_id

		arg0_6:DispatchEvent(var0_0.ACTIVITY_NPC_UPDATE, var0_6, arg1_6.object_id)
	end
end

function var0_0.RemoveNpc(arg0_7, arg1_7)
	if arg0_7:IncludeNpc(arg1_7) then
		local var0_7 = arg0_7.activityNpcs[arg1_7.id]

		arg0_7.activityNpcs[arg1_7.id] = nil

		arg0_7:DispatchEvent(var0_0.ACTIVITY_NPC_DEL, var0_7)
	end
end

function var0_0.IncludeNpc(arg0_8, arg1_8)
	return arg0_8.activityNpcs[npcId] ~= nil
end

return var0_0
