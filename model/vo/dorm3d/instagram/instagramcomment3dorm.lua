local var0_0 = class("InstagramComment3Dorm")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.shipGroupId = arg1_1
	arg0_1.text = arg2_1 or ""
	arg0_1.time = arg3_1 or 0
	arg0_1.npcReplayList = var0_0.BuildNpcReplayList(arg4_1, arg0_1.time)
end

function var0_0.GetIcon(arg0_2)
	local var0_2 = ShipGroup.getDefaultShipConfig(arg0_2.shipGroupId).skin_id

	return pg.ship_skin_template[var0_2].prefab
end

function var0_0.GetPushTime(arg0_3)
	return InstagramTimeStamp(arg0_3.time)
end

function var0_0.GetText(arg0_4)
	local var0_4 = pg.dorm3d_ins_language[arg0_4.text].value

	return (HXSet.hxLan(var0_4))
end

function var0_0.StaticBuild(arg0_5, arg1_5)
	local var0_5 = pg.dorm3d_ins_npc_template[arg0_5]
	local var1_5 = var0_5.message
	local var2_5 = arg1_5 + var0_5.time
	local var3_5 = {}

	if type(var0_5.npc_reply) == "table" then
		var3_5 = var0_5.npc_reply
	end

	return InstagramComment3Dorm.New(var0_5.ship_group, var1_5, var2_5, var3_5)
end

function var0_0.BuildNpcReplayList(arg0_6, arg1_6)
	local var0_6 = arg0_6

	if not arg0_6 or type(arg0_6) == "string" then
		var0_6 = {}
	end

	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(var0_6) do
		table.insert(var1_6, var0_0.StaticBuild(iter1_6, arg1_6))
	end

	return var1_6
end

function var0_0.ExistAnyReplay(arg0_7)
	return #arg0_7.npcReplayList > 0 and _.any(arg0_7.npcReplayList, function(arg0_8)
		return arg0_8:CanShow()
	end)
end

function var0_0.GetReplyedList(arg0_9)
	return arg0_9.npcReplayList
end

function var0_0.CanShow(arg0_10)
	return arg0_10.time > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_10.time
end

function var0_0.ShouldTip(arg0_11, arg1_11)
	return arg1_11 < arg0_11.time or arg0_11:ExistAnyReplay() and _.any(arg0_11.npcReplayList, function(arg0_12)
		return arg0_12:CanShow() and arg0_12:ShouldTip(arg1_11)
	end)
end

return var0_0
