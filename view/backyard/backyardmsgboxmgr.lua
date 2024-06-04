local var0 = class("BackyardMsgBoxMgr")

function var0.Init(arg0, arg1, arg2)
	arg0.view = arg1
	arg0.loaded = false

	PoolMgr.GetInstance():GetUI("BackYardMsgBox", true, function(arg0)
		if arg0.exited then
			return
		end

		setParent(arg0, pg.UIMgr.GetInstance().UIMain)

		arg0._go = arg0
		arg0._tf = arg0.transform
		arg0.frame = findTF(arg0._tf, "msg")
		arg0.closeBtn = findTF(arg0._tf, "frame/close")
		arg0.context = findTF(arg0._tf, "msg/Text"):GetComponent(typeof(Text))
		arg0.cancelBtn = findTF(arg0._tf, "msg/btns/btn2")
		arg0.confirmBtn = findTF(arg0._tf, "msg/btns/btn1")
		arg0.helpPanel = findTF(arg0._tf, "help_panel")
		arg0._helpList = arg0.helpPanel:Find("list")

		setText(arg0._tf:Find("frame/title"), i18n("words_information"))
		setText(arg0.cancelBtn:Find("Text"), i18n("word_cancel"))
		setText(arg0.confirmBtn:Find("Text"), i18n("battle_result_confirm"))

		arg0.loaded = true

		setActive(arg0._tf, false)
		arg2()
	end)
	pg.DelegateInfo.New(arg0.view)
end

function var0.Show(arg0, arg1)
	setActive(arg0.frame, true)
	setActive(arg0.helpPanel, false)

	if not arg0.loaded then
		return
	end

	arg0.isShowMsg = true
	arg0.context.text = arg1.content
	arg0.onYes = arg1.onYes
	arg0.onNo = arg1.onNo

	arg0:Common(arg1)
end

function var0.Common(arg0, arg1)
	onButton(arg0.view, arg0.confirmBtn, function()
		if arg0.onYes then
			arg0.onYes()
		end

		arg0:Hide()
	end, arg1.yesSound or SFX_PANEL)
	onButton(arg0.view, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0.view, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0.view, arg0.cancelBtn, function()
		if arg0.onNo then
			arg0.onNo()
		end

		arg0:Hide()
	end, SFX_PANEL)
	setActive(arg0.cancelBtn, not arg1.hideNo)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.ShowHelp(arg0, arg1)
	setActive(arg0.frame, false)
	setActive(arg0.helpPanel, true)

	local var0 = arg1.helps

	for iter0 = #var0, arg0._helpList.childCount - 1 do
		Destroy(arg0._helpList:GetChild(iter0))
	end

	for iter1 = arg0._helpList.childCount, #var0 - 1 do
		cloneTplTo(arg0._helpTpl, arg0._helpList)
	end

	for iter2, iter3 in ipairs(var0) do
		local var1 = arg0._helpList:GetChild(iter2 - 1)

		setActive(var1, true)

		local var2 = var1:Find("icon")

		setActive(var2, iter3.icon)
		setActive(findTF(var1, "line"), iter3.line)

		local var3 = var1:Find("richText"):GetComponent("RichText")

		setText(var1, HXSet.hxLan(iter3.info and SwitchSpecialChar(iter3.info, true) or ""))
	end

	arg0:Common(arg1)
end

function var0.Hide(arg0)
	arg0.onYes = nil
	arg0.onNo = nil
	arg0.isShowMsg = false

	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
end

function var0.Destroy(arg0)
	arg0.exited = true

	if arg0.isShowMsg then
		arg0:Hide()
	end

	PoolMgr.GetInstance():ReturnUI("BackYardMsgBox", arg0._go)
end

return var0
