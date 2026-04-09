local var0_0 = class("PlayRoomInviteRefuseCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	getProxy(PlayRoomProxy):RefuseInvite(var0_1)
end

return var0_0
