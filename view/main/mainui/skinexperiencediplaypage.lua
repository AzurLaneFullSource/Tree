local var0_0 = class("SkinExperienceDiplayPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ExSkinListUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("window/list/content"), arg0_2:findTF("window/list/content/tpl"))
	arg0_2.skinTimers = {}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3:findTF("window/top/btnBack"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("window/button_container/confirm_btn"), function()
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

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, pg.UIMgr.GetInstance()._normalUIMain)
end

function var0_0.Display(arg0_9, arg1_9)
	arg0_9:Clear()
	arg0_9.uilist:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg1_9[arg1_10 + 1]

			setText(arg2_10:Find("name/Text"), var0_10:getConfig("name"))

			if arg0_9.skinTimers[var0_10.id] then
				arg0_9.skinTimers[var0_10.id]:Stop()
			end

			arg0_9.skinTimers[var0_10.id] = Timer.New(function()
				local var0_11 = skinTimeStamp(var0_10:getRemainTime())

				setText(arg2_10:Find("time/Text"), var0_11)
			end, 1, -1)

			arg0_9.skinTimers[var0_10.id]:Start()
			arg0_9.skinTimers[var0_10.id].func()

			local var1_10 = arg2_10:Find("icon_bg/icon")

			LoadSpriteAsync("qicon/" .. var0_10:getIcon(), function(arg0_12)
				if not IsNil(arg0_9._tf) then
					var1_10:GetComponent(typeof(Image)).sprite = arg0_12
				end
			end)
		end
	end)
	arg0_9.uilist:align(#arg1_9)
end

function var0_0.Clear(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.skinTimers) do
		iter1_13:Stop()
	end

	arg0_13.skinTimers = {}
end

function var0_0.OnDestroy(arg0_14)
	arg0_14:Clear()

	arg0_14.skinTimers = nil
end

return var0_0
