local var0_0 = class("MainWordView", import("...base.MainBaseView"))

var0_0.START_ANIMATION = "MainWordView:ON_ANIMATION"
var0_0.STOP_ANIMATION = "MainWordView:STOP_ANIMATION"
var0_0.SET_CONTENT = "MainWordView:SET_CONTENT"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.chatTf = arg1_1
	arg0_1.chatPos = arg0_1.chatTf.anchoredPosition
	arg0_1.chatTxt = arg0_1.chatTf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.chatTextBg = arg0_1.chatTf:Find("chatbgtop")
	arg0_1.initChatBgH = arg0_1.chatTextBg.sizeDelta.y
	arg0_1.stopChatFlag = false

	arg0_1:Register()
end

function var0_0.Register(arg0_2)
	arg0_2:bind(var0_0.START_ANIMATION, function(arg0_3, arg1_3, arg2_3)
		arg0_2:StartAnimation(arg1_3, arg2_3)
	end)
	arg0_2:bind(var0_0.STOP_ANIMATION, function(arg0_4, arg1_4, arg2_4)
		arg0_2:StopAnimation(arg1_4, arg2_4)
	end)
	arg0_2:bind(var0_0.SET_CONTENT, function(arg0_5, arg1_5, arg2_5)
		arg0_2:AdjustChatPosition(arg1_5, arg2_5)
	end)
	arg0_2:bind(GAME.LOAD_LAYERS, function(arg0_6, arg1_6)
		local var0_6 = arg1_6.context

		if var0_6.mediator == CommissionInfoMediator or var0_6.mediator == NotificationMediator then
			arg0_2:StopAnimation()

			arg0_2.stopChatFlag = true
		end
	end)
	arg0_2:bind(GAME.WILL_LOGOUT, function()
		arg0_2.stopChatFlag = false
	end)
	arg0_2:bind(GAME.REMOVE_LAYERS, function(arg0_8, arg1_8)
		local var0_8 = arg1_8.context

		if var0_8.mediator == CommissionInfoMediator or var0_8.mediator == NotificationMediator then
			arg0_2.stopChatFlag = false
		end
	end)
	arg0_2:bind(NewMainScene.ENTER_SILENT_VIEW, function()
		arg0_2:StopAnimation()

		arg0_2.stopChatFlag = true
	end)
	arg0_2:bind(NewMainScene.EXIT_SILENT_VIEW, function()
		arg0_2.stopChatFlag = false
	end)
end

function var0_0.Fold(arg0_11, arg1_11, arg2_11)
	LeanTween.cancel(go(arg0_11.chatTf))

	if not arg1_11 then
		arg0_11.chatTf.anchoredPosition = arg0_11.chatPos
	elseif arg2_11 > 0 then
		local var0_11 = arg0_11.chatTf.anchoredPosition.x

		LeanTween.value(go(arg0_11.chatTf), var0_11, 0, arg2_11):setOnUpdate(System.Action_float(function(arg0_12)
			setAnchoredPosition(arg0_11.chatTf, {
				x = arg0_12
			})
		end)):setEase(LeanTweenType.easeInOutExpo)
	end

	arg0_11.isFoldState = arg1_11
end

function var0_0.Refresh(arg0_13)
	arg0_13.stopChatFlag = false

	setActive(arg0_13.chatTxt.gameObject, false)
	setActive(arg0_13.chatTxt.gameObject, true)
end

function var0_0.Disable(arg0_14)
	arg0_14.stopChatFlag = false

	arg0_14:StopAnimation()
end

function var0_0.StartAnimation(arg0_15, arg1_15, arg2_15)
	if arg0_15.stopChatFlag == true then
		return
	end

	if LeanTween.isTweening(arg0_15.chatTf.gameObject) then
		LeanTween.cancel(arg0_15.chatTf.gameObject)
	end

	local var0_15 = getProxy(SettingsProxy):ShouldShipMainSceneWord() and 1 or 0

	LeanTween.scale(rtf(arg0_15.chatTf.gameObject), Vector3.New(var0_15, var0_15, 1), arg1_15):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_15.chatTf.gameObject), Vector3.New(0, 0, 1), arg1_15):setEase(LeanTweenType.easeInBack):setDelay(arg1_15 + arg2_15)
	end))
end

function var0_0.StopAnimation(arg0_17)
	if LeanTween.isTweening(arg0_17.chatTf.gameObject) then
		LeanTween.cancel(arg0_17.chatTf.gameObject)
	end

	arg0_17.chatTf.localScale = Vector3.zero
end

function var0_0.AdjustChatPosition(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.chatTxt

	if #var0_18.text > CHAT_POP_STR_LEN then
		var0_18.alignment = TextAnchor.MiddleLeft
	else
		var0_18.alignment = TextAnchor.MiddleCenter
	end

	local var1_18 = var0_18.preferredHeight + 26

	if var1_18 > arg0_18.initChatBgH then
		arg0_18.chatTextBg.sizeDelta = Vector2.New(arg0_18.chatTextBg.sizeDelta.x, var1_18)
	else
		arg0_18.chatTextBg.sizeDelta = Vector2.New(arg0_18.chatTextBg.sizeDelta.x, arg0_18.initChatBgH)
	end

	if PLATFORM_CODE == PLATFORM_US then
		setTextEN(arg0_18.chatTxt, arg2_18)
	else
		setText(arg0_18.chatTxt, SwitchSpecialChar(arg2_18))
	end

	arg0_18:RegisterBtn(arg1_18)
end

function var0_0.RegisterBtn(arg0_19, arg1_19)
	removeOnButton(arg0_19.chatTf)
	onButton(arg0_19, arg0_19.chatTf, function()
		if arg1_19 == "mission_complete" or arg1_19 == "mission" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK)
		elseif arg1_19 == "collection" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif arg1_19 == "event_complete" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		end
	end)
end

function var0_0.Dispose(arg0_21)
	var0_0.super.Dispose(arg0_21)
	LeanTween.cancel(arg0_21.chatTf.gameObject)
end

return var0_0
