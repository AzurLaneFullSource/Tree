local var0 = class("AttireExpireDisplayPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "AttireOverDueUI"
end

function var0.OnLoaded(arg0)
	arg0.uilist = UIItemList.New(arg0:findTF("window/sliders/scrollrect/content"), arg0:findTF("window/sliders/scrollrect/content/tpl"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0:findTF("window/confirm_btn"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("window/top/btnBack"), function()
		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	arg0:Display(arg1)
end

function var0.Display(arg0, arg1)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]

			updateDrop(arg2, {
				count = 1,
				id = var0:getConfig("id"),
				type = var0:getDropType()
			})
		end
	end)
	arg0.uilist:align(#arg1)
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance()._normalUIMain)
end

return var0
