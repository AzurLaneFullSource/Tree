local var0_0 = class("OtherWorldMainPage", import(".TemplatePage.PreviewTemplatePage"))
local var1_0 = 0.45
local var2_0 = 0.2
local var3_0 = 1.2

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.effectBlankScreen = arg0_1:findTF("blank_screen_effect", arg0_1.bg)
	arg0_1.effectOpen = arg0_1:findTF("open_effect", arg0_1.bg)
	arg0_1.effectBlink = arg0_1:findTF("blink_effect", arg0_1.bg)
	arg0_1.effectClick = arg0_1:findTF("click_effect", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.skinshopBtn = arg0_2:findTF("skinshop", arg0_2.btnList)

	onButton(arg0_2, arg0_2.skinshopBtn, function()
		arg0_2:PlayClickEffect(arg0_2.skinshopBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
		end)
	end, SFX_PANEL)

	arg0_2.mountainBtn = arg0_2:findTF("mountain", arg0_2.btnList)

	onButton(arg0_2, arg0_2.mountainBtn, function()
		arg0_2:PlayClickEffect(arg0_2.mountainBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_BACKHILL)
		end)
	end, SFX_PANEL)

	arg0_2.buildBtn = arg0_2:findTF("build", arg0_2.btnList)

	onButton(arg0_2, arg0_2.buildBtn, function()
		arg0_2:PlayClickEffect(arg0_2.buildBtn, function()
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		end)
	end, SFX_PANEL)

	arg0_2.fightBtn = arg0_2:findTF("fight", arg0_2.btnList)

	onButton(arg0_2, arg0_2.fightBtn, function()
		arg0_2:PlayClickEffect(arg0_2.fightBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)
		end)
	end, SFX_PANEL)
	arg0_2:PlayOpenEffect()
end

function var0_0.PlayOpenEffect(arg0_11)
	setActive(arg0_11.effectBlankScreen, true)
	setActive(arg0_11.effectOpen, false)
	arg0_11:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_11.effectOpen, true)
	end, var2_0, nil)
	arg0_11:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_11.effectBlankScreen, false)
	end, var1_0, nil)
	arg0_11:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_11.effectOpen, false)
		setActive(arg0_11.effectBlink, true)
	end, var2_0 + var3_0, nil)
end

function var0_0.PlayClickEffect(arg0_15, arg1_15, arg2_15)
	local var0_15 = pg.UIMgr.GetInstance().OverlayEffect:GetChild(0)
	local var1_15 = Vector3(192, 60, 0)
	local var2_15 = var0_15 and var0_15.localPosition:Sub(var1_15) or arg1_15.localPosition

	setLocalPosition(arg0_15.effectClick, var2_15)
	setActive(arg0_15.effectClick, true)
	arg0_15:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_15.effectClick, false)

		if arg2_15 then
			arg2_15()
		end
	end, 0.3, nil)
end

function var0_0.OnDestroy(arg0_17)
	arg0_17:cleanManagedTween()
end

return var0_0
