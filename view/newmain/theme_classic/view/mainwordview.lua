local var0 = class("MainWordView", import("...base.MainBaseView"))

var0.START_ANIMATION = "MainWordView:ON_ANIMATION"
var0.STOP_ANIMATION = "MainWordView:STOP_ANIMATION"
var0.SET_CONTENT = "MainWordView:SET_CONTENT"

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.chatTf = arg1
	arg0.chatPos = arg0.chatTf.anchoredPosition
	arg0.chatTxt = arg0.chatTf:Find("Text"):GetComponent(typeof(Text))
	arg0.chatTextBg = arg0.chatTf:Find("chatbgtop")
	arg0.initChatBgH = arg0.chatTextBg.sizeDelta.y
	arg0.stopChatFlag = false

	arg0:Register()
end

function var0.Register(arg0)
	arg0:bind(var0.START_ANIMATION, function(arg0, arg1, arg2)
		arg0:StartAnimation(arg1, arg2)
	end)
	arg0:bind(var0.STOP_ANIMATION, function(arg0, arg1, arg2)
		arg0:StopAnimation(arg1, arg2)
	end)
	arg0:bind(var0.SET_CONTENT, function(arg0, arg1, arg2)
		arg0:AdjustChatPosition(arg1, arg2)
	end)
	arg0:bind(GAME.LOAD_LAYERS, function(arg0, arg1)
		local var0 = arg1.context

		if var0.mediator == CommissionInfoMediator or var0.mediator == NotificationMediator then
			arg0:StopAnimation()

			arg0.stopChatFlag = true
		end
	end)
	arg0:bind(GAME.WILL_LOGOUT, function()
		arg0.stopChatFlag = false
	end)
	arg0:bind(GAME.REMOVE_LAYERS, function(arg0, arg1)
		local var0 = arg1.context

		if var0.mediator == CommissionInfoMediator or var0.mediator == NotificationMediator then
			arg0.stopChatFlag = false
		end
	end)
end

function var0.Fold(arg0, arg1, arg2)
	LeanTween.cancel(go(arg0.chatTf))

	if not arg1 then
		arg0.chatTf.anchoredPosition = arg0.chatPos
	elseif arg2 > 0 then
		local var0 = arg0.chatTf.anchoredPosition.x

		LeanTween.value(go(arg0.chatTf), var0, 0, arg2):setOnUpdate(System.Action_float(function(arg0)
			setAnchoredPosition(arg0.chatTf, {
				x = arg0
			})
		end)):setEase(LeanTweenType.easeInOutExpo)
	end

	arg0.isFoldState = arg1
end

function var0.Refresh(arg0)
	arg0.stopChatFlag = false

	setActive(arg0.chatTxt.gameObject, false)
	setActive(arg0.chatTxt.gameObject, true)
end

function var0.Disable(arg0)
	arg0.stopChatFlag = false

	arg0:StopAnimation()
end

function var0.StartAnimation(arg0, arg1, arg2)
	if arg0.stopChatFlag == true then
		return
	end

	if LeanTween.isTweening(arg0.chatTf.gameObject) then
		LeanTween.cancel(arg0.chatTf.gameObject)
	end

	local var0 = getProxy(SettingsProxy):ShouldShipMainSceneWord() and 1 or 0

	LeanTween.scale(rtf(arg0.chatTf.gameObject), Vector3.New(var0, var0, 1), arg1):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0.chatTf.gameObject), Vector3.New(0, 0, 1), arg1):setEase(LeanTweenType.easeInBack):setDelay(arg1 + arg2)
	end))
end

function var0.StopAnimation(arg0)
	if LeanTween.isTweening(arg0.chatTf.gameObject) then
		LeanTween.cancel(arg0.chatTf.gameObject)
	end

	arg0.chatTf.localScale = Vector3.zero
end

function var0.AdjustChatPosition(arg0, arg1, arg2)
	local var0 = arg0.chatTxt

	if #var0.text > CHAT_POP_STR_LEN then
		var0.alignment = TextAnchor.MiddleLeft
	else
		var0.alignment = TextAnchor.MiddleCenter
	end

	local var1 = var0.preferredHeight + 26

	if var1 > arg0.initChatBgH then
		arg0.chatTextBg.sizeDelta = Vector2.New(arg0.chatTextBg.sizeDelta.x, var1)
	else
		arg0.chatTextBg.sizeDelta = Vector2.New(arg0.chatTextBg.sizeDelta.x, arg0.initChatBgH)
	end

	if PLATFORM_CODE == PLATFORM_US then
		setTextEN(arg0.chatTxt, arg2)
	else
		setText(arg0.chatTxt, SwitchSpecialChar(arg2))
	end

	arg0:RegisterBtn(arg1)
end

function var0.RegisterBtn(arg0, arg1)
	removeOnButton(arg0.chatTf)
	onButton(arg0, arg0.chatTf, function()
		if arg1 == "mission_complete" or arg1 == "mission" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK)
		elseif arg1 == "collection" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		elseif arg1 == "event_complete" then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
		end
	end)
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	LeanTween.cancel(arg0.chatTf.gameObject)
end

return var0
