local var0_0 = class("InstagramNpcComment", import(".InstagramComment"))
local var1_0 = pg.activity_ins_ship_group_template

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)

	arg0_1.configId = arg0_1.id

	local var0_1 = arg0_1.level + 1

	for iter0_1, iter1_1 in ipairs(arg1_1.npc_reply) do
		assert(arg0_1.allReply[iter1_1], iter1_1)
		table.insert(arg0_1.replyList, InstagramNpcComment.New(arg0_1.allReply[iter1_1], arg2_1, var0_1, arg0_1))
	end

	arg0_1.config = var1_0[arg0_1:getConfig("ship_group")]
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_ins_npc_template
end

function var0_0.GetName(arg0_3)
	return arg0_3.config.name
end

function var0_0.GetPainting(arg0_4)
	return arg0_4.config.sculpture
end

function var0_0.GetType(arg0_5)
	return Instagram.TYPE_NPC_COMMENT
end

return var0_0
