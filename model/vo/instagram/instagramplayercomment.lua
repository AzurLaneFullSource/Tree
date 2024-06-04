local var0 = class("InstagramPlayerComment", import(".InstagramComment"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1, arg2, arg3, arg4)

	if arg1.npc_reply ~= 0 then
		local var0 = arg0.level + 1
		local var1 = InstagramNpcComment.New(arg0.allReply[arg1.npc_reply], arg2, var0, arg0)

		table.insert(arg0.replyList, var1)
	end
end

function var0.GetName(arg0)
	return getProxy(PlayerProxy):getData().name
end

function var0.GetPainting(arg0)
	return "ui/InstagramUI_atlas", "txdi_3"
end

function var0.GetType(arg0)
	return Instagram.TYPE_PLAYER_COMMENT
end

return var0
