local var0 = class("InstagramNpcComment", import(".InstagramComment"))
local var1 = pg.activity_ins_ship_group_template

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1, arg2, arg3, arg4)

	arg0.configId = arg0.id

	local var0 = arg0.level + 1

	for iter0, iter1 in ipairs(arg1.npc_reply) do
		assert(arg0.allReply[iter1], iter1)
		table.insert(arg0.replyList, InstagramNpcComment.New(arg0.allReply[iter1], arg2, var0, arg0))
	end

	arg0.config = var1[arg0:getConfig("ship_group")]
end

function var0.bindConfigTable(arg0)
	return pg.activity_ins_npc_template
end

function var0.GetName(arg0)
	return arg0.config.name
end

function var0.GetPainting(arg0)
	return arg0.config.sculpture
end

function var0.GetType(arg0)
	return Instagram.TYPE_NPC_COMMENT
end

return var0
