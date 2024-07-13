local var0_0 = class("SSSSCollectPage", import(".TemplatePage.LinkCollectTemplatePage"))
local var1_0 = 0.45
local var2_0 = 0.2
local var3_0 = 1.2
local var4_0 = "event:/ui/kaiji"

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.effectBlankScreen = arg0_1:findTF("blank_screen_effect", arg0_1.bg)
	arg0_1.effectOpen = arg0_1:findTF("open_effect", arg0_1.bg)
	arg0_1.effectBlink = arg0_1:findTF("blink_effect", arg0_1.bg)
	arg0_1.effectClick = arg0_1:findTF("click_effect", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	local var0_2 = arg0_2.activity:getConfig("config_client")

	if arg0_2.furnitureThemeBtn and var0_2.furniture_theme_link then
		removeOnButton(arg0_2.furnitureThemeBtn)
		onButton(arg0_2, arg0_2.furnitureThemeBtn, function()
			arg0_2:PlayClickEffect(arg0_2.furnitureThemeBtn, function()
				arg0_2:DoSkip(var0_2.furniture_theme_link[1], var0_2.furniture_theme_link[2])
			end)
		end, SFX_PANEL)
	end

	if arg0_2.medalBtn and var0_2.medal_link then
		removeOnButton(arg0_2.medalBtn)
		onButton(arg0_2, arg0_2.medalBtn, function()
			arg0_2:PlayClickEffect(arg0_2.furnitureThemeBtn, function()
				arg0_2:DoSkip(var0_2.medal_link[1], var0_2.medal_link[2])
			end)
		end, SFX_PANEL)
	end

	arg0_2:PlayOpenEffect()
end

function var0_0.PlayOpenEffect(arg0_7)
	setActive(arg0_7.effectBlankScreen, true)
	setActive(arg0_7.effectOpen, false)
	arg0_7:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_7.effectOpen, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
	end, var2_0, nil)
	arg0_7:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_7.effectBlankScreen, false)
	end, var1_0, nil)
	arg0_7:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_7.effectOpen, false)
		setActive(arg0_7.effectBlink, true)
	end, var2_0 + var3_0, nil)
end

function var0_0.PlayClickEffect(arg0_11, arg1_11, arg2_11)
	local var0_11 = pg.UIMgr.GetInstance().OverlayEffect:GetChild(0)
	local var1_11 = Vector3(192, 60, 0)
	local var2_11 = var0_11 and var0_11.localPosition:Sub(var1_11) or arg1_11.localPosition

	setLocalPosition(arg0_11.effectClick, var2_11)
	setActive(arg0_11.effectClick, true)
	arg0_11:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_11.effectClick, false)

		if arg2_11 then
			arg2_11()
		end
	end, 0.3, nil)
end

function var0_0.OnDestroy(arg0_13)
	arg0_13:cleanManagedTween()
end

return var0_0
