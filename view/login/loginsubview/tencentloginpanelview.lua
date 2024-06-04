local var0 = class("TencentLoginPanelView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "TencentLoginPanelView"
end

function var0.OnLoaded(arg0)
	return
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.OnInit(arg0)
	arg0.tencentPanel = arg0._tf
	arg0.wxLoginBtn = arg0:findTF("wx_login", arg0.tencentPanel)
	arg0.qqLoginBtn = arg0:findTF("qq_login", arg0.tencentPanel)

	arg0:InitEvent()
end

function var0.InitEvent(arg0)
	onButton(arg0, arg0.qqLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginSdk(1)
	end)
	onButton(arg0, arg0.wxLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginSdk(2)
	end)
end

function var0.OnDestroy(arg0)
	return
end

return var0
