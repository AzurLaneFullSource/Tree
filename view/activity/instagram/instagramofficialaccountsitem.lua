local var0_0 = class("InstagramOfficialAccountsItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.uiTip = arg0_2._tf:Find("tip")
	arg0_2.uiNameText = arg0_2._tf:Find("name")
end

function var0_0.SetData(arg0_3, arg1_3)
	arg0_3.id = arg1_3

	arg0_3:RefreshUI()
end

function var0_0.RefreshUI(arg0_4)
	local var0_4 = arg0_4.id
	local var1_4 = getProxy(InstagramProxy):GetOfficialAccounts()[var0_4]

	setText(arg0_4.uiNameText, shortenString(var1_4:getConfig("title"), 26))
	arg0_4:RefreshTip()
end

function var0_0.RefreshTip(arg0_5)
	local var0_5 = arg0_5.id
	local var1_5 = getProxy(InstagramProxy):GetOfficialAccounts()[var0_5]

	if var1_5 then
		setActive(arg0_5.uiTip, var1_5:ShouldShowTip())
	end
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
end

return var0_0
