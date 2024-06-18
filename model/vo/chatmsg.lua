local var0_0 = class("ChatMsg", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	assert(arg1_1, "type should be clarified.")

	arg0_1.type = arg1_1
	arg0_1.timestamp = arg2_1.timestamp
	arg0_1.content = arg2_1.content
	arg0_1.emojiId = arg2_1.emojiId
	arg0_1.player = arg2_1.player

	if arg0_1.player then
		arg0_1.playerId = arg0_1.player.id
	end

	arg0_1.unread = arg2_1.unread or 0
	arg0_1.id = arg2_1.id
	arg0_1.args = arg2_1.args
	arg0_1.uniqueId = arg2_1.uniqueId
	arg0_1.needBanRichText = true

	if arg2_1.richText then
		arg0_1.needBanRichText = false
	end
end

function var0_0.IsPublic(arg0_2)
	return arg0_2.id ~= nil
end

function var0_0.IsWorldBossNotify(arg0_3)
	return arg0_3.id == 4
end

function var0_0.IsSame(arg0_4, arg1_4)
	return arg0_4.uniqueId == arg1_4
end

return var0_0
