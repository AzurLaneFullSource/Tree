local var0 = class("GalleryConst")

var0.Version = 3
var0.AutoScrollIndex = 41
var0.NewCount = 15
var0.OPEN_FULL_SCREEN_PIC_VIEW = "GelleryConst:OPEN_FULL_SCREEN_PIC_VIEW"
var0.CardStates = {
	DirectShow = 0,
	Unlocked = 1,
	Unlockable = 2,
	DisUnlockable = 3
}
var0.DateIndex = {
	0
}
var0.DateIndexName = {
	(i18n("res_pic_time_all"))
}
var0.Data_All_Value = 0
var0.Sort_Order_Up = 0
var0.Sort_Order_Down = 1
var0.Filte_Normal_Value = 0
var0.Filte_Like_Value = 1
var0.Loading_BG_NO_Filte = 0
var0.Loading_BG_Filte = 1
var0.CARD_PATH_PREFIX = "gallerypic/"
var0.PIC_PATH_PREFIX = "gallerypic/"
var0.Still_Show_On_Lock = 0
var0.Set_BG_Func_Save_Tag = "set_bg_func_save"

function var0.SetBGFuncTag(arg0)
	if getProxy(PlayerProxy) then
		local var0 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt(var0.Set_BG_Func_Save_Tag .. var0, arg0 and 1 or 0)
	end
end

function var0.GetBGFuncTag()
	if getProxy(PlayerProxy) then
		local var0 = getProxy(PlayerProxy):getRawData().id

		return PlayerPrefs.GetInt(var0.Set_BG_Func_Save_Tag .. var0) == 1 and true or false
	end
end

return var0
