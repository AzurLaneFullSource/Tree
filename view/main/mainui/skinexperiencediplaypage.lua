local var0 = class("SkinExperienceDiplayPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ExSkinListUI"
end

function var0.OnLoaded(arg0)
	arg0.uilist = UIItemList.New(arg0:findTF("window/list/content"), arg0:findTF("window/list/content/tpl"))
	arg0.skinTimers = {}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0:findTF("window/top/btnBack"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("window/button_container/confirm_btn"), function()
		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:Display(arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance()._normalUIMain)
end

function var0.Display(arg0, arg1)
	arg0:Clear()
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]

			setText(arg2:Find("name/Text"), var0:getConfig("name"))

			if arg0.skinTimers[var0.id] then
				arg0.skinTimers[var0.id]:Stop()
			end

			arg0.skinTimers[var0.id] = Timer.New(function()
				local var0 = skinTimeStamp(var0:getRemainTime())

				setText(arg2:Find("time/Text"), var0)
			end, 1, -1)

			arg0.skinTimers[var0.id]:Start()
			arg0.skinTimers[var0.id].func()

			local var1 = arg2:Find("icon_bg/icon")

			LoadSpriteAsync("qicon/" .. var0:getIcon(), function(arg0)
				if not IsNil(arg0._tf) then
					var1:GetComponent(typeof(Image)).sprite = arg0
				end
			end)
		end
	end)
	arg0.uilist:align(#arg1)
end

function var0.Clear(arg0)
	for iter0, iter1 in pairs(arg0.skinTimers) do
		iter1:Stop()
	end

	arg0.skinTimers = {}
end

function var0.OnDestroy(arg0)
	arg0:Clear()

	arg0.skinTimers = nil
end

return var0
