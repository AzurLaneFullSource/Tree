local var0_0 = class("BackyardMsgBoxMgr")

function var0_0.Init(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg1_1
	arg0_1.loaded = false

	PoolMgr.GetInstance():GetUI("BackYardMsgBox", true, function(arg0_2)
		if arg0_1.exited then
			return
		end

		setParent(arg0_2, pg.UIMgr.GetInstance().UIMain)

		arg0_1._go = arg0_2
		arg0_1._tf = arg0_2.transform
		arg0_1.frame = findTF(arg0_1._tf, "msg")
		arg0_1.closeBtn = findTF(arg0_1._tf, "frame/close")
		arg0_1.context = findTF(arg0_1._tf, "msg/Text"):GetComponent(typeof(Text))
		arg0_1.cancelBtn = findTF(arg0_1._tf, "msg/btns/btn2")
		arg0_1.confirmBtn = findTF(arg0_1._tf, "msg/btns/btn1")
		arg0_1.helpPanel = findTF(arg0_1._tf, "help_panel")
		arg0_1._helpList = arg0_1.helpPanel:Find("list")

		setText(arg0_1._tf:Find("frame/title"), i18n("words_information"))
		setText(arg0_1.cancelBtn:Find("Text"), i18n("word_cancel"))
		setText(arg0_1.confirmBtn:Find("Text"), i18n("battle_result_confirm"))

		arg0_1.loaded = true

		setActive(arg0_1._tf, false)
		arg2_1()
	end)
	pg.DelegateInfo.New(arg0_1.view)
end

function var0_0.Show(arg0_3, arg1_3)
	setActive(arg0_3.frame, true)
	setActive(arg0_3.helpPanel, false)

	if not arg0_3.loaded then
		return
	end

	arg0_3.isShowMsg = true
	arg0_3.context.text = arg1_3.content
	arg0_3.onYes = arg1_3.onYes
	arg0_3.onNo = arg1_3.onNo

	arg0_3:Common(arg1_3)
end

function var0_0.Common(arg0_4, arg1_4)
	onButton(arg0_4.view, arg0_4.confirmBtn, function()
		if arg0_4.onYes then
			arg0_4.onYes()
		end

		arg0_4:Hide()
	end, arg1_4.yesSound or SFX_PANEL)
	onButton(arg0_4.view, arg0_4._tf, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4.view, arg0_4.closeBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4.view, arg0_4.cancelBtn, function()
		if arg0_4.onNo then
			arg0_4.onNo()
		end

		arg0_4:Hide()
	end, SFX_PANEL)
	setActive(arg0_4.cancelBtn, not arg1_4.hideNo)
	setActive(arg0_4._tf, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.ShowHelp(arg0_9, arg1_9)
	setActive(arg0_9.frame, false)
	setActive(arg0_9.helpPanel, true)

	local var0_9 = arg1_9.helps

	for iter0_9 = #var0_9, arg0_9._helpList.childCount - 1 do
		Destroy(arg0_9._helpList:GetChild(iter0_9))
	end

	for iter1_9 = arg0_9._helpList.childCount, #var0_9 - 1 do
		cloneTplTo(arg0_9._helpTpl, arg0_9._helpList)
	end

	for iter2_9, iter3_9 in ipairs(var0_9) do
		local var1_9 = arg0_9._helpList:GetChild(iter2_9 - 1)

		setActive(var1_9, true)

		local var2_9 = var1_9:Find("icon")

		setActive(var2_9, iter3_9.icon)
		setActive(findTF(var1_9, "line"), iter3_9.line)

		local var3_9 = var1_9:Find("richText"):GetComponent("RichText")

		setText(var1_9, HXSet.hxLan(iter3_9.info and SwitchSpecialChar(iter3_9.info, true) or ""))
	end

	arg0_9:Common(arg1_9)
end

function var0_0.Hide(arg0_10)
	arg0_10.onYes = nil
	arg0_10.onNo = nil
	arg0_10.isShowMsg = false

	setActive(arg0_10._tf, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf, pg.UIMgr.GetInstance().UIMain)
end

function var0_0.Destroy(arg0_11)
	arg0_11.exited = true

	if arg0_11.isShowMsg then
		arg0_11:Hide()
	end

	PoolMgr.GetInstance():ReturnUI("BackYardMsgBox", arg0_11._go)
end

return var0_0
