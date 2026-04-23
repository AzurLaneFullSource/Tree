local var0_0 = class("MainBuffDesMsgbox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MainBuffDescMsgboxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.singleBuffMask = arg0_2._tf:Find("bg")
	arg0_2.singleSureBtn = arg0_2._tf:Find("window/top/btnBack")
	arg0_2.singleCloseBtn = arg0_2._tf:Find("window/sure_btn")
	arg0_2.singleDescContent = arg0_2._tf:Find("window/panel/intro_view/Viewport/Content")
	arg0_2.singleDescTpl = arg0_2._tf:Find("window/panel/intro_view/buff_desc_tpl")
	arg0_2.f2aPanel = arg0_2._tf:Find("window/panel/icon/f_to_a")
	arg0_2.sPanel = arg0_2._tf:Find("window/panel/icon/s_ss")
	arg0_2.sssPanel = arg0_2._tf:Find("window/panel/icon/sss")
	arg0_2.lvBarImages = arg0_2._tf:Find("bg/lv_bars")
	arg0_2.lvTagImages = arg0_2._tf:Find("bg/lv_tags")

	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0_2._tf:Find("window/sure_btn/pic"), i18n("text_confirm"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.singleBuffMask, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.singleCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.singleSureBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7._tf)

	local var0_7 = getProxy(ActivityProxy):RawGetActivityById(arg1_7)

	assert(var0_7, "activity should exist" .. arg1_7)

	arg0_7.ptData = ActivityPtData.New(var0_7)

	arg0_7:UpdateLevelPanel()
	arg0_7:UpdateContent()
end

function var0_0.UpdateContent(arg0_8)
	local var0_8 = arg0_8.ptData:GetCurBuffInfos()

	for iter0_8, iter1_8 in ipairs(var0_8 or {}) do
		local var1_8

		if iter0_8 <= arg0_8.singleDescContent.childCount then
			var1_8 = arg0_8.singleDescContent:GetChild(iter0_8 - 1)
		else
			var1_8 = cloneTplTo(arg0_8.singleDescTpl, arg0_8.singleDescContent)
		end

		setText(var1_8, pg.benefit_buff_template[iter1_8.id].name .. pg.benefit_buff_template[iter1_8.id].desc)
	end
end

function var0_0.UpdateLevelPanel(arg0_9)
	local var0_9, var1_9 = arg0_9.ptData:GetBuffLevelProgress()

	arg0_9.curPanel = nil

	if var0_9 == 9 then
		arg0_9.curPanel = arg0_9.sssPanel
	elseif var0_9 > 6 then
		arg0_9.curPanel = arg0_9.sPanel
	else
		arg0_9.curPanel = arg0_9.f2aPanel
	end

	setActive(arg0_9.f2aPanel, arg0_9.curPanel == arg0_9.f2aPanel)
	setActive(arg0_9.sPanel, arg0_9.curPanel == arg0_9.sPanel)
	setActive(arg0_9.sssPanel, arg0_9.curPanel == arg0_9.sssPanel)
	setImageSprite(arg0_9.curPanel:Find("bar"), arg0_9.lvBarImages:Find(var0_9):GetComponent(typeof(Image)).sprite)
	setImageSprite(arg0_9.curPanel:Find("lv_tag"), arg0_9.lvTagImages:Find(var0_9):GetComponent(typeof(Image)).sprite, true)
	setSlider(arg0_9.curPanel, 0, 1, var1_9)
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf, arg0_10._parentTf)
end

return var0_0
