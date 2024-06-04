local var0 = class("OtherWorldMainPage", import(".TemplatePage.PreviewTemplatePage"))
local var1 = 0.45
local var2 = 0.2
local var3 = 1.2

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.effectBlankScreen = arg0:findTF("blank_screen_effect", arg0.bg)
	arg0.effectOpen = arg0:findTF("open_effect", arg0.bg)
	arg0.effectBlink = arg0:findTF("blink_effect", arg0.bg)
	arg0.effectClick = arg0:findTF("click_effect", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	arg0.skinshopBtn = arg0:findTF("skinshop", arg0.btnList)

	onButton(arg0, arg0.skinshopBtn, function()
		arg0:PlayClickEffect(arg0.skinshopBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
		end)
	end, SFX_PANEL)

	arg0.mountainBtn = arg0:findTF("mountain", arg0.btnList)

	onButton(arg0, arg0.mountainBtn, function()
		arg0:PlayClickEffect(arg0.mountainBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_BACKHILL)
		end)
	end, SFX_PANEL)

	arg0.buildBtn = arg0:findTF("build", arg0.btnList)

	onButton(arg0, arg0.buildBtn, function()
		arg0:PlayClickEffect(arg0.buildBtn, function()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		end)
	end, SFX_PANEL)

	arg0.fightBtn = arg0:findTF("fight", arg0.btnList)

	onButton(arg0, arg0.fightBtn, function()
		arg0:PlayClickEffect(arg0.fightBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)
		end)
	end, SFX_PANEL)
	arg0:PlayOpenEffect()
end

function var0.PlayOpenEffect(arg0)
	setActive(arg0.effectBlankScreen, true)
	setActive(arg0.effectOpen, false)
	arg0:managedTween(LeanTween.delayedCall, function()
		setActive(arg0.effectOpen, true)
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
