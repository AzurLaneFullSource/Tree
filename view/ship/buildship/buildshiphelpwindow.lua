local var0 = class("BuildShipHelpWindow", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "BuildShipHelpWindowUI"
end

function var0.OnLoaded(arg0)
	arg0.shipListTF = arg0:findTF("window/list/scrollview/list", arg0._tf)
	arg0.shipListTpl = arg0:findTF("window/list/scrollview/item", arg0._tf)

	setActive(arg0.shipListTpl, false)

	arg0.tipListTF = arg0:findTF("window/rateList/scrollview/list", arg0._tf)
	arg0.tipListTpl = arg0:findTF("window/rateList/scrollview/item", arg0._tf)

	setText(arg0:findTF("window/confirm_btn/Image/Image (1)"), i18n("text_confirm"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0:findTF("window/close_btn", arg0._tf), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("window/confirm_btn", arg0._tf), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2, arg3)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0.isSupport = arg2 == "support"

	if arg0.isSupport then
		setText(arg0:findTF("window/rateList/title/Text"), i18n("support_rate_title"))
	else
		setText(arg0:findTF("window/rateList/title/Text"), i18n("build_rate_title"))
	end

	arg0:OnShow(arg1, arg3)
	setActiveViaLayer(arg0._tf, true)
end

function var0.OnShow(arg0, arg1, arg2)
	arg0.showing = true

	local var0 = arg1
	local var1 = arg0.shipListTF.childCount

	for iter0 = 1, var1 do
		local var2 = arg0.shipListTF:GetChild(iter0 - 1)

		if var2 then
			setActive(var2, false)
		end
	end

	local var3 = arg0.tipListTF.childCount

	for iter1 = 1, var3 do
		local var4 = arg0.tipListTF:GetChild(iter1 - 1)

		if var4 then
			setActive(var4, false)
		end
	end

	local var5 = getProxy(ActivityProxy)
	local var6

	if not arg0.isSupport then
		if arg2 then
			var6 = var5:getBuildActivityCfgByID(var0.id)
		else
			var6 = var5:getNoneActBuildActivityCfgByID(var0.id)
		end
	end

	local var7 = var6 and var6.rate_tip or var0.rate_tip

	for iter2 = 1, #var7 do
		local var8

		if iter2 <= var3 then
			var8 = arg0.tipListTF:GetChild(iter2 - 1)
		else
			var8 = cloneTplTo(arg0.tipListTpl, arg0.tipListTF)
		end

		if var8 then
			setActive(var8, true)
			setText(var8, HXSet.hxLan(var7[iter2]))
		end
	end
end

function var0.Hide(arg0)
	arg0.showing = false

	setActiveViaLayer(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._tf)
end

function var0.isShowing(arg0)
	return arg0.showing
end

function var0.OnDestroy(arg0)
	return
end

return var0
