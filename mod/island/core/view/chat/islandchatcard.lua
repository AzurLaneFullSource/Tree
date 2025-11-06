local var0_0 = class("IslandChatCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.selfBubble = IslandChatBubble.New(arg0_1._tf:Find("self"))
	arg0_1.otherBubble = IslandChatBubble.New(arg0_1._tf:Find("other"))
end

function var0_0.Update(arg0_2, arg1_2)
	local var0_2 = arg1_2.player

	if not var0_2 then
		return
	end

	if arg0_2.data and var0_2.id == arg0_2.data.player.id and arg0_2.data.timestamp == arg1_2.timestamp then
		return
	end

	arg0_2.sender = var0_2
	arg0_2.data = arg1_2

	local var1_2 = getProxy(PlayerProxy):getRawData()
	local var2_2 = var0_2.id == var1_2.id

	arg1_2.isSelf = var2_2

	if var2_2 then
		arg1_2.player = setmetatable(Clone(var1_2), {
			__index = arg1_2.player
		})
	end

	setActive(arg0_2.selfBubble.tf, var2_2)
	setActive(arg0_2.otherBubble.tf, not var2_2)

	if var2_2 then
		arg0_2.selfBubble:dispose()
		arg0_2.selfBubble:update(arg1_2)
	else
		arg0_2.otherBubble:dispose()
		arg0_2.otherBubble:update(arg1_2)
	end
end

function var0_0.Dispose(arg0_3)
	arg0_3.selfBubble:dispose()
	arg0_3.otherBubble:dispose()

	arg0_3.selfBubble = nil
	arg0_3.otherBubble = nil
end

return var0_0
