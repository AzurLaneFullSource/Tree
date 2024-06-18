local var0_0 = class("DebugPanel", import("..base.BaseUI"))

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)
	arg0_1:onUILoaded(DebugMgr.Inst.DebugPanel)
	setActive(arg0_1._tf, false)

	arg0_1.ctrls = arg0_1:findTF("ctrls")
	arg0_1._customBtnTpl = arg0_1:getTpl("ctrls/custom_button")
end

function var0_0.addCustomBtn(arg0_2, arg1_2, arg2_2)
	local var0_2 = cloneTplTo(arg0_2._customBtnTpl, arg0_2.ctrls)

	arg1_2 = string.gsub(arg1_2, "(.)", "%1\n")

	setButtonText(var0_2, arg1_2)
	onButton(arg0_2, var0_2, arg2_2)
end

function var0_0.hidePanel(arg0_3)
	triggerButton(arg0_3.ctrls:Find("hide_button"))
end

return var0_0
