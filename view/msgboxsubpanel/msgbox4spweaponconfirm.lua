local var0_0 = class("Msgbox4SpweaponConfirm", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "Msgbox4SpweaponConfirm"
end

function var0_0.OnRefresh(arg0_2, arg1_2)
	local var0_2 = arg1_2.op

	if var0_2 == SpWeapon.CONFIRM_OP_DISCARD then
		setText(arg0_2._tf:Find("Desc"), i18n("spweapon_ui_change_attr_text1"))
		setText(arg0_2._tf:Find("Tip"), i18n("spweapon_ui_change_attr_text2"))

		local var1_2 = arg1_2.attrs[1]

		setText(arg0_2._tf:Find("Desc (1)/Attr"), var1_2[1])
		setText(arg0_2._tf:Find("Desc (1)/Value1"), setColorStr(var1_2[2], "#ffde38"))
		setText(arg0_2._tf:Find("Desc (1)/Value2"), setColorStr(var1_2[3], COLOR_GREY))
		setText(arg0_2._tf:Find("Desc (1)/Symbol"), "")

		local var2_2 = arg1_2.attrs[2]

		setText(arg0_2._tf:Find("Desc (2)/Attr"), var2_2[1])
		setText(arg0_2._tf:Find("Desc (2)/Value1"), setColorStr(var2_2[2], "#ffde38"))
		setText(arg0_2._tf:Find("Desc (2)/Value2"), setColorStr(var2_2[3], COLOR_GREY))
		setText(arg0_2._tf:Find("Desc (2)/Symbol"), "")
	elseif var0_2 == SpWeapon.CONFIRM_OP_EXCHANGE then
		setText(arg0_2._tf:Find("Desc"), i18n("spweapon_ui_keep_attr_text1"))
		setText(arg0_2._tf:Find("Tip"), i18n("spweapon_ui_keep_attr_text2"))

		local var3_2 = arg1_2.attrs[1]

		setText(arg0_2._tf:Find("Desc (1)/Attr"), var3_2[1])
		setText(arg0_2._tf:Find("Desc (1)/Value1"), var3_2[2])
		setText(arg0_2._tf:Find("Desc (1)/Value2"), setColorStr(var3_2[3], "#92fc63"))
		setText(arg0_2._tf:Find("Desc (1)/Symbol"), ">")

		local var4_2 = arg1_2.attrs[2]

		setText(arg0_2._tf:Find("Desc (2)/Attr"), var4_2[1])
		setText(arg0_2._tf:Find("Desc (2)/Value1"), var4_2[2])
		setText(arg0_2._tf:Find("Desc (2)/Value2"), setColorStr(var4_2[3], "#92fc63"))
		setText(arg0_2._tf:Find("Desc (2)/Symbol"), ">")
	end
end

return var0_0
