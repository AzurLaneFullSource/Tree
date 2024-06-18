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
end

function var0_0.Fold(arg0_9, arg1_9, arg2_9)
	LeanTween.cancel(go(arg0_9.chatTf))

	if not arg1_9 then
		arg0_9.chatTf.anchoredPosition = arg0_9.chatPos
	elseif arg2_9 > 0 then
		local var0_9 = arg0_9.chatTf.anchoredPosition.x

		LeanTween.value(go(arg0_9.chatTf), var0_9, 0, arg2_9):setOnUpdate(System.Action_float(function(arg0_10)
			setAnchoredPosition(arg0_9.chatTf, {
				x = arg0_10
			})
		end)):setEase(LeanTweenType.easeInOutExpo)
	end

	arg0_9.isFoldState = arg1_9
end

function var0_0.Refresh(arg0_11)
	arg0_11.stopChatFlag = false

	setActive(arg0_11.chatTxt.gameObject, false)
	setActive(arg0_11.chatTxt.gameObject, true)
end

function var0_0.Disable(arg0_12)
	arg0_12.stopChatFlag = false

	arg0_12:StopAnimation()
end

function var0_0.StartAnimation(arg0_13, arg1_13, arg2_13)
	if arg0_13.stopChatFlag == true then
		return
	end

	if LeanTween.isTweening(arg0_13.chatTf.gameObject) then
		LeanTween.cancel(arg0_13.chatTf.gameObject)
	end

	local var0_13 = getProxy(SettingsProxy):ShouldShipMainSceneWord() and 1 or 0

	LeanTween.scale(rtf(arg0_13.chatTf.gameObject), Vector3.New(var0_13, var0_13, 1), arg1_13):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_13.chatTf.gameObject), Vector3.New(0, 0, 1), arg1_13):setEase(LeanTweenType.easeInBack):setDelay(arg1_13 + arg2_13)
	end))
end

function var0_0.StopAnimation(arg0_15)
	if LeanTween.isTweening(arg0_15.chatTf.gameObject) then
		LeanTween.cancel(arg0_15.chatTf.gameObject)
	end

	arg0_15.chatTf.localScale = Vector3.zero
end

function var0_0.AdjustChatPosition(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.chatTxt

	if #var0_16.text > CHAT_POP_STR_LEN then
		var0_16.alignment = TextAnchor.MiddleLeft
	else
		var0_16.alignment = TextAnchor.MiddleCenter
	end

	local var1_16 = var0_16.preferredHeight + 26

	if var1_16 > arg0_16.initChatBgH then
		arg0_16.chatTextBg.sizeDelta = Vector2.New(arg0_16.chatTextBg.sizeDelta.x, var1_16)
	else
		arg0_16.chatTextBg.sizeDelta = Vector2.New(arg0_16.chatTextBg.sizeDelta.x, arg0_16.initChatBgH)
	end

	if PLATFORM_CODE == PLATFORM_US then
		setTextEN(arg0_16.chatTxt, arg2_16)
	else
		setText(arg0_16.chatTxt, SwitchSpecialChar(arg2_16))
	end

	arg0_16:RegisterBtn(arg1_16)
end

function var0_0.RegisterBtn(arg0_17, arg1_17)
	removeOnButton(arg0_17.chatTf)
	onButton(arg0_17, arg0_17.chatTf, function()
		if arg1_17 == "mission_complete" or arg1_17 == "mission" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK)
		elseif arg1_17 == "collection" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif arg1_17 == "event_complete" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		end
	end)
end

function var0_0.Dispose(arg0_19)
	var0_0.super.Dispose(arg0_19)
	LeanTween.cancel(arg0_19.chatTf.gameObject)
end

return var0_0
