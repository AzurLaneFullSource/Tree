local var0 = class("CourtYardThemeOwner", import("model.vo.Player"))

function var0.GetName(arg0)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return i18n("nodisplay_player_home_share")
	else
		return var0.super.GetName(arg0)
	end
end

return var0
