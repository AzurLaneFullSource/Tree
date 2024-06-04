local var0 = class("SSSSCollectPage", import(".TemplatePage.LinkCollectTemplatePage"))
local var1 = 0.45
local var2 = 0.2
local var3 = 1.2
local var4 = "event:/ui/kaiji"

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.effectBlankScreen = arg0:findTF("blank_screen_effect", arg0.bg)
	arg0.effectOpen = arg0:findTF("open_effect", arg0.bg)
	arg0.effectBlink = arg0:findTF("blink_effect", arg0.bg)
	arg0.effectClick = arg0:findTF("click_effect", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	local var0 = arg0.activity:getConfig("config_client")

	if arg0.furnitureThemeBtn and var0.furniture_theme_link then
		removeOnButton(arg0.furnitureThemeBtn)
		onButton(arg0, arg0.furnitureThemeBtn, function()
			arg0:PlayClickEffect(arg0.furnitureThemeBtn, function()
				arg0:DoSkip(var0.furniture_theme_link[1], var0.furniture_theme_link[2])
			end)
		end, SFX_PANEL)
	end

	if arg0.medalBtn and var0.medal_link then
		removeOnButton(arg0.medalBtn)
		onButton(arg0, arg0.medalBtn, function()
			arg0:PlayClickEffect(arg0.furnitureThemeBtn, function()
				arg0:DoSkip(var0.medal_link[1], var0.medal_link[2])
			end)
		end, SFX_PANEL)
	end

	arg0:PlayOpenEffect()
end

function var0.PlayOpenEffect(arg0)
	setActive(arg0.effectBlankScreen, true)
	setActive(arg0.effectOpen, false)
	arg0:managedTween(LeanTween.delayedCall, function()
		setActive(arg0.effectOpen, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4)
	end, var2, nil)
	arg0:managedTween(LeanTween.delayedCall, function()
		setActive(arg0.effectBlankScreen, false)
	end, var1, nil)
	arg0:managedTween(LeanTween.delayedCall, function()
		setActive(arg0.effectOpen, false)
		setActive(arg0.effectBlink, true)
	end, var2 + var3, nil)
end

function var0.PlayClickEffect(arg0, arg1, arg2)
	local var0 = pg.UIMgr.GetInstance().OverlayEffect:GetChild(0)
	local var1 = Vector3(192, 60, 0)
	local var2 = var0 and var0.localPosition:Sub(var1) or arg1.localPosition

	setLocalPosition(arg0.effectClick, var2)
	setActive(arg0.effectClick, true)
	arg0:managedTween(LeanTween.delayedCall, function()
		setActive(arg0.effectClick, false)

		if arg2 then
			arg2()
		end
	end, 0.3, nil)
end

function var0.OnDestroy(arg0)
	arg0:cleanManagedTween()
end

return var0
