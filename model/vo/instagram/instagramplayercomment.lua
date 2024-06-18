local var0_0 = class("InstagramPlayerComment", import(".InstagramComment"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)

	if arg1_1.npc_reply ~= 0 then
		local var0_1 = arg0_1.level + 1
		local var1_1 = InstagramNpcComment.New(arg0_1.allReply[arg1_1.npc_reply], arg2_1, var0_1, arg0_1)

		table.insert(arg0_1.replyList, var1_1)
	end
end

function var0_0.GetName(arg0_2)
	return getProxy(PlayerProxy):getData().name
end

function var0_0.GetPainting(arg0_3)
	return "ui/InstagramUI_atlas", "txdi_3"
end

function var0_0.GetType(arg0_4)
	return Instagram.TYPE_PLAYER_COMMENT
end

return var0_0
