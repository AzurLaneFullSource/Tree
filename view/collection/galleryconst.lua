local var0_0 = class("GalleryConst")

var0_0.Version = 3
var0_0.AutoScrollIndex = 41
var0_0.NewCount = 15
var0_0.OPEN_FULL_SCREEN_PIC_VIEW = "GelleryConst:OPEN_FULL_SCREEN_PIC_VIEW"
var0_0.CardStates = {
	DirectShow = 0,
	Unlocked = 1,
	Unlockable = 2,
	DisUnlockable = 3
}
var0_0.DateIndex = {
	0
}
var0_0.DateIndexName = {
	(i18n("res_pic_time_all"))
}
var0_0.Data_All_Value = 0
var0_0.Sort_Order_Up = 0
var0_0.Sort_Order_Down = 1
var0_0.Filte_Normal_Value = 0
var0_0.Filte_Like_Value = 1
var0_0.Loading_BG_NO_Filte = 0
var0_0.Loading_BG_Filte = 1
var0_0.CARD_PATH_PREFIX = "gallerypic/"
var0_0.PIC_PATH_PREFIX = "gallerypic/"
var0_0.Still_Show_On_Lock = 0
var0_0.Set_BG_Func_Save_Tag = "set_bg_func_save"

function var0_0.SetBGFuncTag(arg0_1)
	if getProxy(PlayerProxy) then
		local var0_1 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt(var0_0.Set_BG_Func_Save_Tag .. var0_1, arg0_1 and 1 or 0)
	end
end

function var0_0.GetBGFuncTag()
	if getProxy(PlayerProxy) then
		local var0_2 = getProxy(PlayerProxy):getRawData().id

		return PlayerPrefs.GetInt(var0_0.Set_BG_Func_Save_Tag .. var0_2) == 1 and true or false
	end
end

return var0_0
