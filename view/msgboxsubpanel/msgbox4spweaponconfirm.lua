local var0 = class("Msgbox4SpweaponConfirm", import(".MsgboxSubPanel"))

function var0.getUIName(arg0)
	return "Msgbox4SpweaponConfirm"
end

function var0.OnRefresh(arg0, arg1)
	local var0 = arg1.op

	if var0 == SpWeapon.CONFIRM_OP_DISCARD then
		setText(arg0._tf:Find("Desc"), i18n("spweapon_ui_change_attr_text1"))
		setText(arg0._tf:Find("Tip"), i18n("spweapon_ui_change_attr_text2"))

		local var1 = arg1.attrs[1]

		setText(arg0._tf:Find("Desc (1)/Attr"), var1[1])
		setText(arg0._tf:Find("Desc (1)/Value1"), setColorStr(var1[2], "#ffde38"))
		setText(arg0._tf:Find("Desc (1)/Value2"), setColorStr(var1[3], COLOR_GREY))
		setText(arg0._tf:Find("Desc (1)/Symbol"), "")

		local var2 = arg1.attrs[2]

		setText(arg0._tf:Find("Desc (2)/Attr"), var2[1])
		setText(arg0._tf:Find("Desc (2)/Value1"), setColorStr(var2[2], "#ffde38"))
		setText(arg0._tf:Find("Desc (2)/Value2"), setColorStr(var2[3], COLOR_GREY))
		setText(arg0._tf:Find("Desc (2)/Symbol"), "")
	elseif var0 == SpWeapon.CONFIRM_OP_EXCHANGE then
		setText(arg0._tf:Find("Desc"), i18n("spweapon_ui_keep_attr_text1"))
		setText(arg0._tf:Find("Tip"), i18n("spweapon_ui_keep_attr_text2"))

		local var3 = arg1.attrs[1]

		setText(arg0._tf:Find("Desc (1)/Attr"), var3[1])
		setText(arg0._tf:Find("Desc (1)/Value1"), var3[2])
		setText(arg0._tf:Find("Desc (1)/Value2"), setColorStr(var3[3], "#92fc63"))
		setText(arg0._tf:Find("Desc (1)/Symbol"), ">")

		local var4 = arg1.attrs[2]

		setText(arg0._tf:Find("Desc (2)/Attr"), var4[1])
		setText(arg0._tf:Find("Desc (2)/Value1"), var4[2])
		setText(arg0._tf:Find("Desc (2)/Value2"), setColorStr(var4[3], "#92fc63"))
		setText(arg0._tf:Find("Desc (2)/Symbol"), ">")
	end
end

return var0
