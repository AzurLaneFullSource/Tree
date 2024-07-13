local var0_0 = class("SkinExpireDisplayPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SkinOverDueUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("window/list/scrollrect/content"), arg0_2:findTF("window/list/scrollrect/content/tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3:findTF("window/button_container/confirm_btn"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("window/top/btnBack"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	arg0_7:Display(arg1_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Display(arg0_8, arg1_8)
	arg0_8.uilist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8[arg1_9 + 1]

			setText(arg2_9:Find("name/Text"), var0_9:getConfig("name"))

			local var1_9 = arg2_9:Find("icon_bg/icon")

			LoadSpriteAsync("qicon/" .. var0_9:getIcon(), function(arg0_10)
				if not IsNil(arg0_8._tf) then
					var1_9:GetComponent(typeof(Image)).sprite = arg0_10
				end
			end)
		end
	end)
	arg0_8.uilist:align(#arg1_8)
end

function var0_0.OnDestroy(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, pg.UIMgr.GetInstance()._normalUIMain)
end

return var0_0
