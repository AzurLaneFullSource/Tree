local var0_0 = class("CourtYardThemeOwner", import("model.vo.Player"))

function var0_0.GetName(arg0_1)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return i18n("nodisplay_player_home_share")
	else
		return var0_0.super.GetName(arg0_1)
	end
end

return var0_0
