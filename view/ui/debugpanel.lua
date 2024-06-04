local var0 = class("DebugPanel", import("..base.BaseUI"))

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)
	arg0:onUILoaded(DebugMgr.Inst.DebugPanel)
	setActive(arg0._tf, false)

	arg0.ctrls = arg0:findTF("ctrls")
	arg0._customBtnTpl = arg0:getTpl("ctrls/custom_button")
end

function var0.addCustomBtn(arg0, arg1, arg2)
	local var0 = cloneTplTo(arg0._customBtnTpl, arg0.ctrls)

	arg1 = string.gsub(arg1, "(.)", "%1\n")

	setButtonText(var0, arg1)
	onButton(arg0, var0, arg2)
end

function var0.hidePanel(arg0)
	triggerButton(arg0.ctrls:Find("hide_button"))
end

return var0
