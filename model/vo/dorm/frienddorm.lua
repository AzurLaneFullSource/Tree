local var0_0 = class("FriendDorm", import(".Dorm"))

function var0_0.GetName(arg0_1)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return i18n("nodisplay_player_home_name")
	else
		return var0_0.super.GetName(arg0_1)
	end
end

return var0_0
