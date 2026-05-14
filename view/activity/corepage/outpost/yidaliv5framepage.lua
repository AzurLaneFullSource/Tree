local var0_0 = class("YidaliV5FramePage", import("view.activity.CorePage.CoreNewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.btnGroup = arg0_1.AD:Find("btnGroup")
	arg0_1.battleBtn = arg0_1.btnGroup:Find("battle_btn")
	arg0_1.getBtn = arg0_1.btnGroup:Find("get_btn")
	arg0_1.gotBtn = arg0_1.btnGroup:Find("got_btn")
	arg0_1.switcher = arg0_1.AD:Find("switcher")
	arg0_1.switchBtn = arg0_1.switcher:Find("switch_btn")
	arg0_1.phases = {
		arg0_1.switcher:Find("phase1"),
		arg0_1.switcher:Find("phase2")
	}
	arg0_1.pas2Img = arg0_1.phases[2]:Find("Image")
	arg0_1.barContent = arg0_1.pas2Img:Find("barContent")
	arg0_1.bar = arg0_1.barContent:Find("bar")
	arg0_1.cur = arg0_1.barContent:Find("step")
	arg0_1.target = arg0_1.barContent:Find("progress")
	arg0_1.gotTag = arg0_1.pas2Img:Find("award/got")
	arg0_1.phaseAnim = arg0_1.switcher:GetComponent(typeof(Animation))
	arg0_1.animClip1 = "anim_YidaliV5FramePage_switcher"
	arg0_1.animClip2 = "anim_YidaliV5FramePage_switcher2"
end

function var0_0.InitBtnLocalText(arg0_2)
	setText(arg0_2.getBtn:Find("Text"), i18n("YidaliV5FramePage_get"))
	setText(arg0_2.gotBtn:Find("Text"), i18n("YidaliV5FramePage_got"))
	setText(arg0_2.battleBtn:Find("Text"), i18n("YidaliV5FramePage_go"))
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.phaseAnim.playAutomatically = false

	arg0_3:InitBtnLocalText()

	for iter0_3, iter1_3 in ipairs(arg0_3.phases) do
		setActive(iter1_3, true)

		GetOrAddComponent(iter1_3, typeof(CanvasGroup)).alpha = 0
	end

	var0_0.super.OnFirstFlush(arg0_3)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)
end

function var0_0.Switch(arg0_5, arg1_5)
	arg0_5.isSwitching = true

	setToggleEnabled(arg0_5.switchBtn, false)

	local var0_5
	local var1_5

	if arg1_5 then
		var0_5, var1_5 = arg0_5.phases[1], arg0_5.phases[2]

		quickPlayAnimation(arg0_5.switcher, arg0_5.animClip1)
	else
		var0_5, var1_5 = arg0_5.phases[2], arg0_5.phases[1]

		quickPlayAnimation(arg0_5.switcher, arg0_5.animClip2)
	end

	local var2_5 = var0_5.localPosition
	local var3_5 = var1_5.localPosition

	var1_5:SetAsLastSibling()
	setCanvasGroupAlpha(GetOrAddComponent(var0_5, typeof(CanvasGroup)), 0)
	setCanvasGroupAlpha(GetOrAddComponent(var1_5, typeof(CanvasGroup)), 1)

	arg0_5.isSwitching = nil

	setToggleEnabled(arg0_5.switchBtn, true)
end

return var0_0
