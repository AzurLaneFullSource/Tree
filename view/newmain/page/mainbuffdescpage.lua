local var0_0 = class("MainBuffDescPage", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1:bind(NewMainScene.ON_BUFF_DESC, function(arg0_2, arg1_2, arg2_2)
		arg0_1:ExecuteAction("Show", arg1_2, arg2_2)
	end)
end

function var0_0.getUIName(arg0_3)
	return "MainUIBuffDescWindow"
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.descTxt = arg0_4:findTF("Text"):GetComponent(typeof(Text))
end

function var0_0.Show(arg0_5, arg1_5, arg2_5)
	var0_0.super.Show(arg0_5)
	arg0_5:RemoveDescTimer()
	arg0_5:AddCloseTimer()
	arg0_5:UpdateDesc(arg1_5)

	arg0_5._tf.localPosition = arg2_5
	arg0_5._parentTf = arg0_5._tf.parent

	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf, {
		overlayType = LayerWeightConst.OVERLAY_UI_TOP
	})
end

function var0_0.UpdateDesc(arg0_6, arg1_6)
	if arg1_6:getConfig("max_time") <= 0 then
		arg0_6.descTxt.text = arg1_6:getConfig("desc")

		return
	end

	arg0_6.descTimer = Timer.New(function()
		arg0_6:UpdateDescPreSce(arg1_6)
	end, 1, -1)

	arg0_6.descTimer:Start()
	arg0_6.descTimer.func()
end

function var0_0.UpdateDescPreSce(arg0_8, arg1_8)
	local var0_8 = arg1_8:getConfig("desc")
	local var1_8 = pg.TimeMgr:GetInstance():GetServerTime()
	local var2_8 = arg1_8.timestamp - var1_8

	if var2_8 > 0 then
		local var3_8 = pg.TimeMgr.GetInstance():DescCDTime(var2_8)

		arg0_8.descTxt.text = string.gsub(var0_8, "$1", var3_8)
	else
		arg0_8:Hide()
	end
end

function var0_0.RemoveDescTimer(arg0_9)
	if arg0_9.descTimer then
		arg0_9.descTimer:Stop()

		arg0_9.descTimer = nil
	end
end

function var0_0.AddCloseTimer(arg0_10)
	arg0_10:RemoveCloseTimer()

	arg0_10.timer = Timer.New(function()
		arg0_10:Hide()
	end, 7, 1)

	arg0_10.timer:Start()
end

function var0_0.RemoveCloseTimer(arg0_12)
	if arg0_12.timer then
		arg0_12.timer:Stop()

		arg0_12.timer = nil
	end
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
	arg0_13:RemoveCloseTimer()
	arg0_13:RemoveDescTimer()
end

function var0_0.Disable(arg0_14)
	if arg0_14:GetLoaded() and arg0_14:isShowing() then
		arg0_14:Hide()
	end
end

function var0_0.OnDestroy(arg0_15)
	arg0_15:RemoveCloseTimer()
	arg0_15:RemoveDescTimer()
end

return var0_0
