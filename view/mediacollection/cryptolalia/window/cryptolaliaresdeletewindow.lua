local var0 = class("CryptolaliaResDeleteWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CryptolaliaResDeleteWindowui"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.contentTxt = arg0:findTF("window/content/Text"):GetComponent(typeof(Text))
	arg0.icon = arg0:findTF("window/content/cover/icon"):GetComponent(typeof(Image))
	arg0.signature = arg0:findTF("window/content/cover/signature"):GetComponent(typeof(Image))
	arg0.name = arg0:findTF("window/content/cover/name"):GetComponent(typeof(Text))
	arg0.shipname = arg0:findTF("window/content/cover/shipname"):GetComponent(typeof(Text))
	arg0.cancelBtn = arg0:findTF("window/button_container/cancel")
	arg0.confirmBtn = arg0:findTF("window/button_container/confirm")

	setText(arg0:findTF("window/top/title"), i18n("cryptolalia_delete_res_title"))
	setText(arg0.cancelBtn:Find("Text"), i18n("text_cancel"))
	setText(arg0.confirmBtn:Find("Text"), i18n("text_confirm"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0.contentTxt.text = i18n("cryptolalia_delete_res_tip", arg1:GetResSize(arg2))
	arg0.name.text = arg1:GetName()
	arg0.shipname.text = arg1:GetShipName()

	local var0 = arg1:GetShipGroupId()

	LoadSpriteAtlasAsync("CryptolaliaShip/" .. var0, "cd", function(arg0)
		if arg0.exited then
			return
		end

		arg0.icon.sprite = arg0

		arg0.icon:SetNativeSize()
	end)
	onButton(arg0, arg0.confirmBtn, function()
		if IsUnityEditor then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

			return
		end

		arg0:Delete(arg1, arg2)
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Delete(arg0, arg1, arg2)
	if arg1 and arg1:IsPlayableState(arg2) then
		local var0 = arg1:GetCpkName(arg2)
		local var1 = Cryptolalia.BuildCpkPath(var0)
		local var2 = Cryptolalia.BuildSubtitlePath(var0)

		pg.CipherGroupMgr.GetInstance():DelFile({
			var1,
			var2
		})
		arg0:emit(CryptolaliaScene.ON_DELETE)
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0.exited = true
end

return var0
