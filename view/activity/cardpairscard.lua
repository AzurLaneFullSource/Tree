local var0_0 = class("CardPairsCard")

var0_0.CARD_STATE_BACK = 0
var0_0.CARD_STATE_FRONT = 1
var0_0.CARD_STATE_HIDE = 2
var0_0.ANI_TIME = 0.5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.cardTf = arg1_1
	arg0_1.pics = arg2_1
	arg0_1.img = findTF(arg0_1.cardTf, "img")
	arg0_1.back = findTF(arg0_1.cardTf, "back")
	arg0_1.front = findTF(arg0_1.cardTf, "front")
	arg0_1.clearSign = findTF(arg0_1.cardTf, "gray")
	arg0_1.outline = GetComponent(arg0_1.front, typeof(Outline))

	arg0_1:setOutline(false)

	arg0_1.cardState = arg0_1.CARD_STATE_BACK
	arg0_1.canClick = true
	arg0_1.enable = true
	arg0_1.aniCallBack = arg6_1
	arg0_1.aniStartCallBak = arg5_1

	arg0_1:initCard(arg3_1)
	onButton(arg0_1, arg0_1.cardTf, function()
		arg4_1(arg0_1)
	end)
end

function var0_0.getCardIndex(arg0_3)
	return arg0_3.cardIndex
end

function var0_0.setEnable(arg0_4, arg1_4)
	arg0_4.enable = arg1_4
end

function var0_0.setClear(arg0_5)
	setActive(arg0_5.clearSign, true)
	arg0_5:setOutline(false)

	arg0_5.canClick = false
end

function var0_0.setOutline(arg0_6, arg1_6)
	arg0_6.outline.enabled = arg1_6
end

function var0_0.initCard(arg0_7, arg1_7)
	arg0_7.cardIndex = arg1_7

	arg0_7:setSpriteTo(findTF(arg0_7.pics, "pic" .. arg1_7), arg0_7.img, false)
	setActive(arg0_7.clearSign, false)
	arg0_7:showBack()

	arg0_7.canClick = true
end

function var0_0.showBack(arg0_8)
	setActive(arg0_8.back, true)
	setActive(arg0_8.front, false)
	setActive(arg0_8.img, false)

	arg0_8.cardState = arg0_8.CARD_STATE_BACK

	arg0_8:setOutline(false)
end

function var0_0.showFront(arg0_9)
	setActive(arg0_9.back, false)
	setActive(arg0_9.front, true)
	setActive(arg0_9.img, true)

	arg0_9.cardState = arg0_9.CARD_STATE_FRONT
end

function var0_0.aniShowBack(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10.canClick = false

	if arg1_10 then
		arg0_10:showBack()
	else
		arg0_10:showFront()
	end

	if not arg2_10 then
		arg0_10.aniStartCallBak(arg0_10, arg1_10)
	end

	arg0_10.cardTf.localScale = Vector3(1, 1, 1)

	LeanTween.scale(go(arg0_10.cardTf), Vector3(0, 1, 1), arg0_10.ANI_TIME):setDelay(defaultValue(arg3_10, 0)):setOnComplete(System.Action(function()
		if arg1_10 then
			arg0_10:showFront()
		else
			arg0_10:showBack()
		end

		LeanTween.scale(go(arg0_10.cardTf), Vector3(1, 1, 1), arg0_10.ANI_TIME):setOnComplete(System.Action(function()
			arg0_10.canClick = true

			if not arg2_10 then
				arg0_10.aniCallBack(arg0_10, arg1_10)
			end
		end))
	end))
end

function var0_0.setSpriteTo(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg2_13:GetComponent(typeof(Image))

	var0_13.sprite = arg1_13:GetComponent(typeof(Image)).sprite

	if arg3_13 then
		var0_13:SetNativeSize()
	end
end

function var0_0.clear(arg0_14)
	LeanTween.cancel(go(arg0_14.cardTf))
end

function var0_0.destroy(arg0_15)
	pg.DelegateInfo.Dispose(arg0_15)
	LeanTween.cancel(go(arg0_15.cardTf))
end

return var0_0
