local var0_0 = class("BuildShipHelpWindow", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BuildShipHelpWindowUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.shipListTF = arg0_2:findTF("window/list/scrollview/list", arg0_2._tf)
	arg0_2.shipListTpl = arg0_2:findTF("window/list/scrollview/item", arg0_2._tf)

	setActive(arg0_2.shipListTpl, false)

	arg0_2.tipListTF = arg0_2:findTF("window/rateList/scrollview/list", arg0_2._tf)
	arg0_2.tipListTpl = arg0_2:findTF("window/rateList/scrollview/item", arg0_2._tf)

	setText(arg0_2:findTF("window/confirm_btn/Image/Image (1)"), i18n("text_confirm"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3:findTF("window/close_btn", arg0_3._tf), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("window/confirm_btn", arg0_3._tf), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7, arg2_7, arg3_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0_7.isSupport = arg2_7 == "support"

	if arg0_7.isSupport then
		setText(arg0_7:findTF("window/rateList/title/Text"), i18n("support_rate_title"))
	else
		setText(arg0_7:findTF("window/rateList/title/Text"), i18n("build_rate_title"))
	end

	arg0_7:OnShow(arg1_7, arg3_7)
	setActiveViaLayer(arg0_7._tf, true)
end

function var0_0.OnShow(arg0_8, arg1_8, arg2_8)
	arg0_8.showing = true

	local var0_8 = arg1_8
	local var1_8 = arg0_8.shipListTF.childCount

	for iter0_8 = 1, var1_8 do
		local var2_8 = arg0_8.shipListTF:GetChild(iter0_8 - 1)

		if var2_8 then
			setActive(var2_8, false)
		end
	end

	local var3_8 = arg0_8.tipListTF.childCount

	for iter1_8 = 1, var3_8 do
		local var4_8 = arg0_8.tipListTF:GetChild(iter1_8 - 1)

		if var4_8 then
			setActive(var4_8, false)
		end
	end

	local var5_8 = getProxy(ActivityProxy)
	local var6_8

	if not arg0_8.isSupport then
		if arg2_8 then
			var6_8 = var5_8:getBuildActivityCfgByID(var0_8.id)
		else
			var6_8 = var5_8:getNoneActBuildActivityCfgByID(var0_8.id)
		end
	end

	local var7_8 = var6_8 and var6_8.rate_tip or var0_8.rate_tip

	for iter2_8 = 1, #var7_8 do
		local var8_8

		if iter2_8 <= var3_8 then
			var8_8 = arg0_8.tipListTF:GetChild(iter2_8 - 1)
		else
			var8_8 = cloneTplTo(arg0_8.tipListTpl, arg0_8.tipListTF)
		end

		if var8_8 then
			setActive(var8_8, true)
			setText(var8_8, HXSet.hxLan(var7_8[iter2_8]))
		end
	end
end

function var0_0.Hide(arg0_9)
	arg0_9.showing = false

	setActiveViaLayer(arg0_9._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._tf)
end

function var0_0.isShowing(arg0_10)
	return arg0_10.showing
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
