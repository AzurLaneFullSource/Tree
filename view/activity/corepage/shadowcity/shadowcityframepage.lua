local var0_0 = class("ShadowCityFramePage", import("view.activity.CorePage.CoreNewFrameTemplatePage"))

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
	arg0_1.gotTag = arg0_1.pas2Img:Find("got")
	arg0_1.animClip1 = "anim_ShadowCityFramePage_switcher"
	arg0_1.animClip2 = "anim_ShadowCityFramePage_switcher2"
end

function var0_0.OnFirstFlush(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.phases) do
		setActive(iter1_2, true)

		GetOrAddComponent(iter1_2, typeof(CanvasGroup)).alpha = 0
	end

	var0_0.super.OnFirstFlush(arg0_2)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3 = arg0_3.activity.data1
	local var1_3 = arg0_3.avatarConfig.target

	var0_3 = var1_3 < var0_3 and var1_3 or var0_3

	setActive(arg0_3.cur, false)
	setText(arg0_3.target, var0_3 .. "/" .. var1_3)
end

function var0_0.Switch(arg0_4, arg1_4)
	arg0_4.isSwitching = true

	setToggleEnabled(arg0_4.switchBtn, false)

	local var0_4
	local var1_4

	if arg1_4 then
		var0_4, var1_4 = arg0_4.phases[1], arg0_4.phases[2]

		quickPlayAnimation(arg0_4.switcher, arg0_4.animClip1)
	else
		var0_4, var1_4 = arg0_4.phases[2], arg0_4.phases[1]

		quickPlayAnimation(arg0_4.switcher, arg0_4.animClip2)
	end

	local var2_4 = var0_4.localPosition
	local var3_4 = var1_4.localPosition

	var1_4:SetAsLastSibling()
	setCanvasGroupAlpha(GetOrAddComponent(var0_4, typeof(CanvasGroup)), 0)
	setCanvasGroupAlpha(GetOrAddComponent(var1_4, typeof(CanvasGroup)), 1)

	arg0_4.isSwitching = nil

	setToggleEnabled(arg0_4.switchBtn, true)
end

return var0_0
