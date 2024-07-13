local var0_0 = class("SSSSMainPage", import(".TemplatePage.PreviewTemplatePage"))
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
	arg0_2.skinshopBtn = arg0_2:findTF("skinshop", arg0_2.btnList)

	onButton(arg0_2, arg0_2.skinshopBtn, function()
		arg0_2:PlayClickEffect(arg0_2.skinshopBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
		end)
	end, SFX_PANEL)

	arg0_2.mountainBtn = arg0_2:findTF("mountain", arg0_2.btnList)

	onButton(arg0_2, arg0_2.mountainBtn, function()
		arg0_2:PlayClickEffect(arg0_2.mountainBtn, function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SSSS_ACADEMY)
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

	arg0_2.shopBtn = arg0_2:findTF("shop", arg0_2.btnList)

	onButton(arg0_2, arg0_2.shopBtn, function()
		arg0_2:PlayClickEffect(arg0_2.shopBtn, function()
			local var0_10 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_11)
				return arg0_11:getConfig("config_client").pt_id == pg.gameset.activity_res_id.key_value
			end)

			arg0_2:emit(ActivityMediator.GO_SHOPS_LAYER, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = var0_10 and var0_10.id
			})
		end)
	end, SFX_PANEL)

	arg0_2.fightBtn = arg0_2:findTF("fight", arg0_2.btnList)

	onButton(arg0_2, arg0_2.fightBtn, function()
		arg0_2:PlayClickEffect(arg0_2.fightBtn, function()
			arg0_2:emit(ActivityMediator.BATTLE_OPERA)
		end)
	end, SFX_PANEL)
	arg0_2:PlayOpenEffect()
end

function var0_0.PlayOpenEffect(arg0_14)
	setActive(arg0_14.effectBlankScreen, true)
	setActive(arg0_14.effectOpen, false)
	arg0_14:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_14.effectOpen, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
	end, var2_0, nil)
	arg0_14:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_14.effectBlankScreen, false)
	end, var1_0, nil)
	arg0_14:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_14.effectOpen, false)
		setActive(arg0_14.effectBlink, true)
	end, var2_0 + var3_0, nil)
end

function var0_0.PlayClickEffect(arg0_18, arg1_18, arg2_18)
	local var0_18 = pg.UIMgr.GetInstance().OverlayEffect:GetChild(0)
	local var1_18 = Vector3(192, 60, 0)
	local var2_18 = var0_18 and var0_18.localPosition:Sub(var1_18) or arg1_18.localPosition

	setLocalPosition(arg0_18.effectClick, var2_18)
	setActive(arg0_18.effectClick, true)
	arg0_18:managedTween(LeanTween.delayedCall, function()
		setActive(arg0_18.effectClick, false)

		if arg2_18 then
			arg2_18()
		end
	end, 0.3, nil)
end

function var0_0.OnDestroy(arg0_20)
	arg0_20:cleanManagedTween()
end

return var0_0
