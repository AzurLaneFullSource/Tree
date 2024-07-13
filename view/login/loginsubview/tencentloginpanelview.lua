local var0_0 = class("TencentLoginPanelView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "TencentLoginPanelView"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.OnInit(arg0_4)
	arg0_4.tencentPanel = arg0_4._tf
	arg0_4.wxLoginBtn = arg0_4:findTF("wx_login", arg0_4.tencentPanel)
	arg0_4.qqLoginBtn = arg0_4:findTF("qq_login", arg0_4.tencentPanel)

	arg0_4:InitEvent()
end

function var0_0.InitEvent(arg0_5)
	onButton(arg0_5, arg0_5.qqLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginSdk(1)
	end)
	onButton(arg0_5, arg0_5.wxLoginBtn, function()
		pg.SdkMgr.GetInstance():LoginSdk(2)
	end)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
