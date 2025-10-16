local var0_0 = class("IslandMsgBoxSingleDropWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxWithSingleItem"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.itemTr = arg0_2._tf:Find("IslandItemTpl")
	arg0_2.nameTxt = arg0_2._tf:Find("name"):GetComponent(typeof(Text))
	arg0_2.ownTxt = arg0_2._tf:Find("own"):GetComponent(typeof(Text))
	arg0_2.uiItemList = UIItemList.New(arg0_2._tf:Find("way/Viewport/list"), arg0_2._tf:Find("way/Viewport/list/tpl"))
	arg0_2.contentTF = arg0_2._tf:Find("way/Viewport/list")

	setText(arg0_2._tf:Find("label/Text"), i18n("island_get_way"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	local var0_3 = arg0_3.settings.dropData
	local var1_3 = IslandDropDescribeInfo.New(var0_3)

	arg0_3:FlushMain(var1_3)
	arg0_3:FlushAcquiringWay(var1_3)
end

function var0_0.FlushMain(arg0_4, arg1_4)
	arg0_4.nameTxt.text = arg1_4:GetName()
	arg0_4.contentTxt.text = arg1_4:GetDes()

	local var0_4 = arg1_4:GetOwnCount()

	arg0_4.ownTxt.text = i18n("island_own_cnt") .. setColorStr(var0_4, "#39beff")

	updateCustomDrop(arg0_4.itemTr, arg1_4:GetDrop(), {
		style = "island"
	})
end

function var0_0.FlushAcquiringWay(arg0_5, arg1_5)
	local var0_5

	if arg1_5:IsTecUnlocked() then
		var0_5 = arg1_5:GetAcquiringWay()
	else
		var0_5 = {}

		local var1_5 = {}

		table.insert(var1_5, arg1_5:GetTecDes())
		table.insert(var0_5, var1_5)
	end

	local var2_5 = #var0_5 > 0

	setActive(arg0_5._tf:Find("line"), var2_5)
	setActive(arg0_5._tf:Find("label"), var2_5)
	setActive(arg0_5._tf:Find("way"), var2_5)
	arg0_5.uiItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5[arg1_6 + 1]

			setText(arg2_6:Find("Text"), var0_6[1])
			setText(arg2_6:Find("go/Text"), i18n("island_word_go"))
			onButton(arg0_5, arg2_6:Find("go"), function()
				arg0_5:GetMsgBoxMgr():emit(IslandMediator.OPEN_PAGE, var0_6[2][1], var0_6[2][2])
				arg0_5:Hide()
			end, SFX_PANEL)
			setActive(arg2_6:Find("go"), var0_6[2] and #var0_6[2] > 0)
		end
	end)
	arg0_5.uiItemList:align(#var0_5)
	setAnchoredPosition(arg0_5.contentTF, {
		x = 0,
		y = 0
	})
end

function var0_0.FlushBtn(arg0_8, arg1_8)
	setActive(arg0_8.cancelBtn, false)
end

return var0_0
