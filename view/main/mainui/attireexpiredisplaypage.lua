local var0_0 = class("AttireExpireDisplayPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "AttireOverDueUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("window/sliders/scrollrect/content"), arg0_2:findTF("window/sliders/scrollrect/content/tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3:findTF("window/confirm_btn"), function()
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
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	arg0_7:Display(arg1_7)
end

function var0_0.Display(arg0_8, arg1_8)
	arg0_8.uilist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8[arg1_9 + 1]

			updateDrop(arg2_9, {
				count = 1,
				id = var0_9:getConfig("id"),
				type = var0_9:getDropType()
			})
		end
	end)
	arg0_8.uilist:align(#arg1_8)
end

function var0_0.OnDestroy(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, pg.UIMgr.GetInstance()._normalUIMain)
end

return var0_0
