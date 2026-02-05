local var0_0 = class("IslandActivityNpcAgency", import(".IslandBaseAgency"))

var0_0.ACTIVITY_NPC_ADD = "IslandActivityNpcAgency:ACTIVITY_NPC_ADD"
var0_0.ACTIVITY_NPC_UPDATE = "IslandActivityNpcAgency:ACTIVITY_NPC_UPDATE"
var0_0.ACTIVITY_NPC_DEL = "IslandActivityNpcAgency:ACTIVITY_NPC_DEL"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.activityNpcs = {}
end

function var0_0.ExistTradeNpc(arg0_2)
	for iter0_2, iter1_2 in pairs(arg0_2.activityNpcs) do
		local var0_2 = pg.island_world_objects[iter1_2]

		if var0_2 and var0_2.type == 1 and var0_2.unitId == 101500 then
			return true, iter1_2
		end
	end

	return false
end

function var0_0.InitNpcList(arg0_3, arg1_3)
	arg0_3.activityNpcs = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		arg0_3.activityNpcs[iter1_3.id] = iter1_3.object_id
	end
end

function var0_0.GetNpcList(arg0_4)
	return arg0_4.activityNpcs
end

function var0_0.GetNpcObjects(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.activityNpcs) do
		table.insert(var0_5, iter1_5)
	end

	return var0_5
end

function var0_0.AddNpc(arg0_6, arg1_6)
	if not arg0_6:IncludeNpc(arg1_6) then
		arg0_6.activityNpcs[arg1_6.id] = arg1_6.object_id

		arg0_6:DispatchEvent(var0_0.ACTIVITY_NPC_ADD, arg1_6.object_id)
	end
end

function var0_0.UpdateNpc(arg0_7, arg1_7)
	if arg0_7:IncludeNpc(arg1_7) then
		local var0_7 = arg0_7.activityNpcs[arg1_7.id]

		arg0_7.activityNpcs[arg1_7.id] = arg1_7.object_id

		arg0_7:DispatchEvent(var0_0.ACTIVITY_NPC_UPDATE, var0_7, arg1_7.object_id)
	end
end

function var0_0.RemoveNpc(arg0_8, arg1_8)
	if arg0_8:IncludeNpc(arg1_8) then
		local var0_8 = arg0_8.activityNpcs[arg1_8.id]

		arg0_8.activityNpcs[arg1_8.id] = nil

		arg0_8:DispatchEvent(var0_0.ACTIVITY_NPC_DEL, var0_8)
	end
end

function var0_0.IncludeNpc(arg0_9, arg1_9)
	return arg0_9.activityNpcs[npcId] ~= nil
end

return var0_0
