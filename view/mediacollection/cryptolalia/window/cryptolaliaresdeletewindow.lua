local var0_0 = class("CryptolaliaResDeleteWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CryptolaliaResDeleteWindowui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.contentTxt = arg0_2:findTF("window/content/Text"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2:findTF("window/content/cover/icon"):GetComponent(typeof(Image))
	arg0_2.signature = arg0_2:findTF("window/content/cover/signature"):GetComponent(typeof(Image))
	arg0_2.name = arg0_2:findTF("window/content/cover/name"):GetComponent(typeof(Text))
	arg0_2.shipname = arg0_2:findTF("window/content/cover/shipname"):GetComponent(typeof(Text))
	arg0_2.cancelBtn = arg0_2:findTF("window/button_container/cancel")
	arg0_2.confirmBtn = arg0_2:findTF("window/button_container/confirm")

	setText(arg0_2:findTF("window/top/title"), i18n("cryptolalia_delete_res_title"))
	setText(arg0_2.cancelBtn:Find("Text"), i18n("text_cancel"))
	setText(arg0_2.confirmBtn:Find("Text"), i18n("text_confirm"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7, arg2_7)
	var0_0.super.Show(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0_7.contentTxt.text = i18n("cryptolalia_delete_res_tip", arg1_7:GetResSize(arg2_7))
	arg0_7.name.text = arg1_7:GetName()
	arg0_7.shipname.text = arg1_7:GetShipName()

	local var0_7 = arg1_7:GetShipGroupId()

	LoadSpriteAtlasAsync("CryptolaliaShip/" .. var0_7, "cd", function(arg0_8)
		if arg0_7.exited then
			return
		end

		arg0_7.icon.sprite = arg0_8

		arg0_7.icon:SetNativeSize()
	end)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		if IsUnityEditor then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

			return
		end

		arg0_7:Delete(arg1_7, arg2_7)
		arg0_7:Hide()
	end, SFX_PANEL)
end

function var0_0.Delete(arg0_10, arg1_10, arg2_10)
	if arg1_10 and arg1_10:IsPlayableState(arg2_10) then
		local var0_10 = arg1_10:GetCpkName(arg2_10)
		local var1_10 = Cryptolalia.BuildCpkPath(var0_10)
		local var2_10 = Cryptolalia.BuildSubtitlePath(var0_10)

		pg.CipherGroupMgr.GetInstance():DelFile({
			var1_10,
			var2_10
		})
		arg0_10:emit(CryptolaliaScene.ON_DELETE)
	end
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.OnDestroy(arg0_12)
	arg0_12.exited = true
end

return var0_0
