local var0_0 = class("RefluxAnimationPlayer", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "RefluxAnimationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.s1SpineAnim = arg0_2._tf:Find("s1/spine"):GetComponent(typeof(SpineAnimUI))
	arg0_2.s2SpineAnim = arg0_2._tf:Find("s2/spine"):GetComponent(typeof(SpineAnimUI))
	arg0_2.s3SpineAnim = arg0_2._tf:Find("a4/Bg/spine/s3/spine"):GetComponent(typeof(SpineAnimUI))
	arg0_2.a1Animation = arg0_2._tf:Find("s1"):GetComponent(typeof(Animation))
	arg0_2.a1AnimationDft = arg0_2._tf:Find("s1"):GetComponent(typeof(DftAniEvent))
	arg0_2.a1AnimationEffect = arg0_2._tf:Find("s1/a1/VX_glow")
	arg0_2.a2Animation = arg0_2._tf:Find("a2"):GetComponent(typeof(Animation))
	arg0_2.a2AnimationDft = arg0_2._tf:Find("a2"):GetComponent(typeof(DftAniEvent))
	arg0_2.a3Animation = arg0_2._tf:Find("a3"):GetComponent(typeof(Animation))
	arg0_2.a3AnimationDft = arg0_2._tf:Find("a3"):GetComponent(typeof(DftAniEvent))
	arg0_2.a4Animation = arg0_2._tf:Find("a4"):GetComponent(typeof(Animation))
	arg0_2.a4AnimationDft = arg0_2._tf:Find("a4"):GetComponent(typeof(DftAniEvent))
	arg0_2.a5Animation = arg0_2._tf:Find("a5"):GetComponent(typeof(Animator))
	arg0_2.a5AnimationDft = arg0_2._tf:Find("a5"):GetComponent(typeof(DftAniEvent))
	arg0_2.cGContainer = arg0_2._tf:Find("a5/Bg/CG")
	arg0_2.cgTpl = arg0_2._tf:Find("a5/Bg/tpl")
	arg0_2.s1ClickBtn = arg0_2._tf:Find("s1/a1/click")
	arg0_2.a3ReviewBtn = arg0_2._tf:Find("a3/Bg/btn")
	arg0_2.backBtn = arg0_2._tf:Find("a3/Bg/bg")
	arg0_2.a5bgAlpha = arg0_2._tf:Find("a5/Bg"):GetComponent(typeof(CanvasGroup))
	arg0_2.yearText = arg0_2._tf:Find("a3/Bg/xinfen/bg_3/billboard/year")
	arg0_2.monthText = arg0_2._tf:Find("a3/Bg/xinfen/bg_3/billboard/month")
	arg0_2.dateText = arg0_2._tf:Find("a3/Bg/xinfen/bg_3/billboard/date")
	arg0_2.daysText = arg0_2._tf:Find("a3/Bg/xinfen/bg_3/billboard/days")
	arg0_2.countText = arg0_2._tf:Find("a3/Bg/xinfen/bg_3/billboard/count")

	arg0_2:updateUI()
end

function var0_0.updateUI(arg0_3)
	local var0_3 = getProxy(RefluxProxy)
	local var1_3 = pg.TimeMgr.GetInstance()
	local var2_3 = var0_3.returnLastTimestamp
	local var3_3 = var0_3.returnTimestamp
	local var4_3 = var1_3:STimeDescS(var2_3, "*t")

	setText(arg0_3.yearText, var4_3.year % 100)
	setText(arg0_3.monthText, var4_3.month)
	setText(arg0_3.dateText, var4_3.day)
	setText(arg0_3.daysText, var1_3:DiffDay(var2_3, var3_3))
	setText(arg0_3.countText, var0_3.returnShipNum)
end

function var0_0.Play(arg0_4, arg1_4, arg2_4)
	arg0_4.bgs = arg1_4

	seriesAsync({
		function(arg0_5)
			arg0_4:OnStart()
			arg0_4:EnterAnimation(arg0_5)
		end,
		function(arg0_6)
			arg0_4:EnterClickAnimation(arg0_6)
		end,
		function(arg0_7)
			arg0_4:RegiserOpenClick(arg0_7)
		end,
		function(arg0_8)
			arg0_4:OpenAnimation(arg0_8)
		end,
		function(arg0_9)
			arg0_4:OpenDisplayAnimation(arg0_9)
		end,
		function(arg0_10)
			arg0_4:ReigerReviewClick(arg0_10)
			arg0_4:ReigerBackClick(arg0_10)
		end
	}, arg2_4)
end

function var0_0.Play4Review(arg0_11, arg1_11, arg2_11)
	arg0_11:Show()

	arg0_11.bgs = arg1_11

	seriesAsync({
		function(arg0_12)
			arg0_11:OnStart()
			arg0_11:OpenDisplayAnimation(arg0_12)
		end,
		function(arg0_13)
			arg0_11:ReigerReviewClick(arg0_13)
			arg0_11:ReigerBackClick(arg0_13)
		end
	}, arg2_11)
end

function var0_0.PlayNextStage(arg0_14, arg1_14)
	arg0_14.a5bgAlpha.alpha = 1

	removeAllChildren(arg0_14.cGContainer)
	seriesAsync({
		function(arg0_15)
			arg0_14:EnterCGAnimation(arg0_15)
		end,
		function(arg0_16)
			arg0_14:StartCGAnimation(arg0_16)
		end,
		function(arg0_17)
			arg0_14:PlayCGLoop(arg0_14.bgs, arg0_17)
		end,
		function(arg0_18)
			arg0_14:EndCGAnimation(arg0_18)
		end,
		function(arg0_19)
			arg0_14:ExitCGAnimation(arg0_19)
		end,
		function(arg0_20)
			arg0_14:OpenDisplayAnimation(arg0_20)
		end,
		function(arg0_21)
			arg0_14:ReigerBackClick(arg1_14)
			arg0_14:ReigerReviewClick(arg1_14)
		end
	})
end

function var0_0.OnStart(arg0_22)
	removeAllOnButton(arg0_22.a3ReviewBtn)
	removeAllOnButton(arg0_22.s1ClickBtn)
	eachChild(arg0_22._tf, function(arg0_23)
		setActive(arg0_23, false)
	end)
	setActive(arg0_22.a3ReviewBtn, #arg0_22.bgs > 0)
end

function var0_0.EnterAnimation(arg0_24, arg1_24)
	arg0_24.s1SpineAnim:SetActionCallBack(nil)
	setActive(arg0_24.s1SpineAnim.gameObject.transform.parent, true)
	arg0_24.s1SpineAnim:SetActionCallBack(function(arg0_25)
		if arg0_25 == "finish" then
			arg0_24.s1SpineAnim:SetActionCallBack(nil)
			arg0_24.s1SpineAnim:SetAction("normal", 0)
			arg1_24()
		end
	end)
	arg0_24.s1SpineAnim:SetAction("action", 0)
end

function var0_0.EnterClickAnimation(arg0_26, arg1_26)
	setActive(arg0_26.a1AnimationEffect, false)
	setActive(go(arg0_26.a1Animation).transform.parent, true)
	arg0_26.a1AnimationDft:SetEndEvent(nil)
	arg0_26.a1AnimationDft:SetEndEvent(function()
		arg0_26.a1AnimationDft:SetEndEvent(nil)
		setActive(arg0_26.a1AnimationEffect, true)
		arg1_26()
	end)
	arg0_26.a1Animation:Play("ShadowCityFramePage_in")
end

function var0_0.RegiserOpenClick(arg0_28, arg1_28)
	onButton(arg0_28, arg0_28.s1ClickBtn, function()
		removeAllOnButton(arg0_28.s1ClickBtn)
		arg1_28()
	end, SFX_PANEL)
end

function var0_0.ReigerBackClick(arg0_30, arg1_30)
	onButton(arg0_30, arg0_30.backBtn, function()
		removeAllOnButton(arg0_30.a3ReviewBtn)
		removeAllOnButton(arg0_30.backBtn)
		arg1_30()
	end, SFX_PANEL)
end

function var0_0.ReigerReviewClick(arg0_32, arg1_32)
	onButton(arg0_32, arg0_32.a3ReviewBtn, function()
		removeAllOnButton(arg0_32.a3ReviewBtn)
		removeAllOnButton(arg0_32.backBtn)
		arg0_32:PlayNextStage(arg1_32)
	end, SFX_PANEL)
end

function var0_0.OpenAnimation(arg0_34, arg1_34)
	setActive(arg0_34.s1SpineAnim.gameObject.transform.parent, false)
	setActive(tf(arg0_34.a1Animation), false)
	parallelAsync({
		function(arg0_35)
			arg0_34:PlayOpenAnimation(arg0_35)
		end,
		function(arg0_36)
			arg0_34:PlayOpenSpineAnimation(arg0_36)
		end
	}, arg1_34)
end

function var0_0.PlayOpenAnimation(arg0_37, arg1_37)
	setActive(arg0_37.a2Animation.gameObject, true)
	arg0_37.a2AnimationDft:SetEndEvent(nil)
	arg0_37.a2AnimationDft:SetEndEvent(function()
		arg0_37.a2AnimationDft:SetEndEvent(nil)
		arg1_37()
	end)
	arg0_37.a2Animation:Play("ShadowCityFramePage_2_in")
end

function var0_0.PlayOpenSpineAnimation(arg0_39, arg1_39)
	arg0_39.s2SpineAnim:SetActionCallBack(nil)
	setActive(arg0_39.s2SpineAnim.gameObject.transform.parent, true)
	arg0_39.s2SpineAnim:SetActionCallBack(function(arg0_40)
		if arg0_40 == "finish" then
			arg0_39.s2SpineAnim:SetActionCallBack(nil)
			arg0_39.s2SpineAnim:SetAction("action2", 0)
			arg1_39()
		end
	end)
	arg0_39.s2SpineAnim:SetAction("action", 0)
end

function var0_0.OpenDisplayAnimation(arg0_41, arg1_41)
	setActive(arg0_41.s2SpineAnim.gameObject.transform.parent, false)
	setActive(arg0_41.a3Animation.gameObject, true)
	setActive(arg0_41.a4Animation.gameObject, false)
	arg0_41.a3AnimationDft:SetEndEvent(nil)
	arg0_41.a3AnimationDft:SetEndEvent(function()
		arg0_41.a3AnimationDft:SetEndEvent(nil)
		arg1_41()
	end)
	arg0_41.a3AnimationDft:SetTriggerEvent(nil)
	arg0_41.a3AnimationDft:SetTriggerEvent(function()
		setActive(arg0_41.a2Animation.gameObject, false)
	end)
	arg0_41.a3Animation:Play("ShadowCityFramePage_3_in")
end

function var0_0.EnterCGAnimation(arg0_44, arg1_44)
	setActive(arg0_44.a3Animation.gameObject, false)
	seriesAsync({
		function(arg0_45)
			arg0_44:PlayEnterCGAnimation(arg0_45)
		end,
		function(arg0_46)
			arg0_44:PlayEnterCGSpineAnimation(arg0_46)
		end
	}, arg1_44)
end

function var0_0.PlayEnterCGAnimation(arg0_47, arg1_47)
	setActive(arg0_47.a4Animation.gameObject, true)
	arg0_47.a4AnimationDft:SetEndEvent(nil)
	arg0_47.a4AnimationDft:SetEndEvent(function()
		arg0_47.a4AnimationDft:SetEndEvent(nil)
		arg1_47()
	end)
	arg0_47.a4Animation:Play("ShadowCityFramePage_4_in")
	arg0_47.s3SpineAnim:SetActionCallBack(nil)
	arg0_47.s3SpineAnim:SetAction("normal1", 0)
end

function var0_0.PlayEnterCGSpineAnimation(arg0_49, arg1_49)
	arg0_49.s3SpineAnim:SetActionCallBack(nil)
	setActive(arg0_49.s3SpineAnim.gameObject.transform.parent, true)
	arg0_49.s3SpineAnim:SetActionCallBack(function(arg0_50)
		if arg0_50 == "finish" then
			arg0_49.s3SpineAnim:SetActionCallBack(nil)
			arg0_49.s3SpineAnim:SetAction("normal2", 0)
			arg1_49()
		end
	end)
	arg0_49.s3SpineAnim:SetAction("action1", 0)
end

function var0_0.ExitCGAnimation(arg0_51, arg1_51)
	setActive(arg0_51.a3Animation.gameObject, false)
	seriesAsync({
		function(arg0_52)
			arg0_51:PlayExitCGAnimation(arg0_52)
		end,
		function(arg0_53)
			arg0_51:PlayExitCGSpineAnimation(arg0_53)
		end
	}, arg1_51)
end

function var0_0.PlayExitCGAnimation(arg0_54, arg1_54)
	setActive(arg0_54.a4Animation.gameObject, true)
	arg0_54.a4AnimationDft:SetEndEvent(nil)
	arg0_54.a4AnimationDft:SetEndEvent(function()
		arg0_54.a4AnimationDft:SetEndEvent(nil)
		arg1_54()
	end)
	arg0_54.a4Animation:Play("ShadowCityFramePage_4_out")
	arg0_54.s3SpineAnim:SetActionCallBack(nil)
	arg0_54.s3SpineAnim:SetAction("normal2", 0)
end

function var0_0.PlayExitCGSpineAnimation(arg0_56, arg1_56)
	arg0_56.s3SpineAnim:SetActionCallBack(nil)
	setActive(arg0_56.s3SpineAnim.gameObject.transform.parent, true)
	arg0_56.s3SpineAnim:SetActionCallBack(function(arg0_57)
		if arg0_57 == "finish" then
			arg0_56.s3SpineAnim:SetActionCallBack(nil)
			arg0_56.s3SpineAnim:SetAction("normal1", 0)
			arg1_56()
		end
	end)
	arg0_56.s3SpineAnim:SetAction("action2", 0)
end

function var0_0.StartCGAnimation(arg0_58, arg1_58)
	setActive(arg0_58.a5Animation.gameObject, true)
	arg0_58.a5AnimationDft:SetEndEvent(nil)
	arg0_58.a5AnimationDft:SetEndEvent(function()
		arg0_58.a5AnimationDft:SetEndEvent(nil)
		arg1_58()
	end)
	arg0_58.a5AnimationDft:SetTriggerEvent(nil)
	arg0_58.a5AnimationDft:SetTriggerEvent(function()
		arg0_58.a5AnimationDft:SetTriggerEvent(nil)
		setActive(arg0_58.a4Animation.gameObject, false)
	end)
	arg0_58.a5Animation:SetTrigger("in")
end

local function var1_0(arg0_61, arg1_61, arg2_61, arg3_61)
	local var0_61 = LoadSprite("bg/" .. arg2_61)
	local var1_61 = arg0_61:Find("root/cg")

	setImageSprite(var1_61, var0_61, false)
	setLocalPosition(var1_61, Vector3(-10000, -10000, 0))

	var1_61.sizeDelta = Vector3(1920, 1080)

	setActive(arg0_61, true)

	local var2_61 = "ShadowCityFramePage_photo_" .. arg1_61
	local var3_61 = arg0_61:Find("root"):GetComponent(typeof(Animation))
	local var4_61 = arg0_61:Find("root"):GetComponent(typeof(DftAniEvent))

	var4_61:SetEndEvent(nil)
	var4_61:SetEndEvent(function()
		var4_61:SetEndEvent(nil)
		arg3_61()
	end)
	var3_61:Play(var2_61)
end

local function var2_0(arg0_63, arg1_63, arg2_63)
	local var0_63 = LoadSprite("bg/" .. arg1_63)
	local var1_63 = arg0_63:Find("root/cg")

	setImageSprite(var1_63, var0_63, false)

	var1_63.sizeDelta = Vector3(1920, 1080)

	setLocalPosition(var1_63, Vector3(-10000, -10000, 0))

	var1_63.sizeDelta = Vector3(1920, 1080)

	setActive(arg0_63, true)

	local var2_63 = "ShadowCityFramePage_photo"
	local var3_63 = arg0_63:Find("root"):GetComponent(typeof(Animation))
	local var4_63 = arg0_63:Find("root"):GetComponent(typeof(DftAniEvent))

	var4_63:SetEndEvent(nil)
	var4_63:SetEndEvent(function()
		var4_63:SetEndEvent(nil)
		arg2_63()
	end)
	var3_63:Play(var2_63)
end

function var0_0.PlayCGLoop(arg0_65, arg1_65, arg2_65)
	local var0_65 = {}

	removeAllChildren(arg0_65.cGContainer)

	local var1_65 = cloneTplTo(arg0_65.cgTpl, arg0_65.cGContainer)

	for iter0_65 = 2, #arg1_65 do
		local var2_65 = cloneTplTo(arg0_65.cgTpl, arg0_65.cGContainer)

		setActive(var2_65, false)
		table.insert(var0_65, var2_65)
	end

	local var3_65 = {}

	table.insert(var3_65, function(arg0_66)
		var2_0(var1_65, arg1_65[1], arg0_66)
	end)

	for iter1_65, iter2_65 in ipairs(var0_65) do
		local var4_65 = iter1_65 % 4

		if var4_65 == 0 then
			var4_65 = 4
		end

		local var5_65 = arg1_65[iter1_65 + 1]

		table.insert(var3_65, function(arg0_67)
			var1_0(iter2_65, var4_65, var5_65, arg0_67)
		end)
	end

	seriesAsync(var3_65, arg2_65)
end

function var0_0.EndCGAnimation(arg0_68, arg1_68)
	setActive(arg0_68.a4Animation.gameObject, true)
	arg0_68.a5AnimationDft:SetEndEvent(nil)
	arg0_68.a5AnimationDft:SetEndEvent(function()
		arg0_68.a5AnimationDft:SetEndEvent(nil)
		setActive(arg0_68.a5Animation.gameObject, false)
		arg1_68()
	end)
	arg0_68.a5Animation:SetTrigger("out")
end

function var0_0.OnDestroy(arg0_70)
	arg0_70.a1AnimationDft:SetEndEvent(nil)
	arg0_70.a2AnimationDft:SetEndEvent(nil)
	arg0_70.a3AnimationDft:SetEndEvent(nil)
	arg0_70.a4AnimationDft:SetEndEvent(nil)
	arg0_70.a5AnimationDft:SetEndEvent(nil)
	arg0_70.a5AnimationDft:SetTriggerEvent(nil)
end

return var0_0
