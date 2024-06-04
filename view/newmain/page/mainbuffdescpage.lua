local var0 = class("MainBuffDescPage", import("view.base.BaseSubView"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2, arg3)
	arg0:bind(NewMainScene.ON_BUFF_DESC, function(arg0, arg1, arg2)
		arg0:ExecuteAction("Show", arg1, arg2)
	end)
end

function var0.getUIName(arg0)
	return "MainUIBuffDescWindow"
end

function var0.OnLoaded(arg0)
	arg0.descTxt = arg0:findTF("Text"):GetComponent(typeof(Text))
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)
	arg0:RemoveDescTimer()
	arg0:AddCloseTimer()
	arg0:UpdateDesc(arg1)

	arg0._tf.localPosition = arg2
	arg0._parentTf = arg0._tf.parent

	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		overlayType = LayerWeightConst.OVERLAY_UI_TOP
	})
end

function var0.UpdateDesc(arg0, arg1)
	if arg1:getConfig("max_time") <= 0 then
		arg0.descTxt.text = arg1:getConfig("desc")

		return
	end

	arg0.descTimer = Timer.New(function()
		arg0:UpdateDescPreSce(arg1)
	end, 1, -1)

	arg0.descTimer:Start()
	arg0.descTimer.func()
end

function var0.UpdateDescPreSce(arg0, arg1)
	local var0 = arg1:getConfig("desc")
	local var1 = pg.TimeMgr:GetInstance():GetServerTime()
	local var2 = arg1.timestamp - var1

	if var2 > 0 then
		local var3 = pg.TimeMgr.GetInstance():DescCDTime(var2)

		arg0.descTxt.text = string.gsub(var0, "$1", var3)
	else
		arg0:Hide()
	end
end

function var0.RemoveDescTimer(arg0)
	if arg0.descTimer then
		arg0.descTimer:Stop()

		arg0.descTimer = nil
	end
end

function var0.AddCloseTimer(arg0)
	arg0:RemoveCloseTimer()

	arg0.timer = Timer.New(function()
		arg0:Hide()
	end, 7, 1)

	arg0.timer:Start()
end

function var0.RemoveCloseTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)
	arg0:RemoveCloseTimer()
	arg0:RemoveDescTimer()
end

function var0.Disable(arg0)
	if arg0:GetLoaded() and arg0:isShowing() then
		arg0:Hide()
	end
end

function var0.OnDestroy(arg0)
	arg0:RemoveCloseTimer()
	arg0:RemoveDescTimer()
end

return var0
