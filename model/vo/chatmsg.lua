local var0 = class("ChatMsg", import(".BaseVO"))

function var0.Ctor(arg0, arg1, arg2)
	assert(arg1, "type should be clarified.")

	arg0.type = arg1
	arg0.timestamp = arg2.timestamp
	arg0.content = arg2.content
	arg0.emojiId = arg2.emojiId
	arg0.player = arg2.player

	if arg0.player then
		arg0.playerId = arg0.player.id
	end

	arg0.unread = arg2.unread or 0
	arg0.id = arg2.id
	arg0.args = arg2.args
	arg0.uniqueId = arg2.uniqueId
	arg0.needBanRichText = true

	if arg2.richText then
		arg0.needBanRichText = false
	end
end

function var0.IsPublic(arg0)
	return arg0.id ~= nil
end

function var0.IsWorldBossNotify(arg0)
	return arg0.id == 4
end

function var0.IsSame(arg0, arg1)
	return arg0.uniqueId == arg1
end

return var0
