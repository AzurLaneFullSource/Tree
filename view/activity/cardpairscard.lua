local var0 = class("CardPairsCard")

var0.CARD_STATE_BACK = 0
var0.CARD_STATE_FRONT = 1
var0.CARD_STATE_HIDE = 2
var0.ANI_TIME = 0.5

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	pg.DelegateInfo.New(arg0)

	arg0.cardTf = arg1
	arg0.pics = arg2
	arg0.img = findTF(arg0.cardTf, "img")
	arg0.back = findTF(arg0.cardTf, "back")
	arg0.front = findTF(arg0.cardTf, "front")
	arg0.clearSign = findTF(arg0.cardTf, "gray")
	arg0.outline = GetComponent(arg0.front, typeof(Outline))

	arg0:setOutline(false)

	arg0.cardState = arg0.CARD_STATE_BACK
	arg0.canClick = true
	arg0.enable = true
	arg0.aniCallBack = arg6
	arg0.aniStartCallBak = arg5

	arg0:initCard(arg3)
	onButton(arg0, arg0.cardTf, function()
		arg4(arg0)
	end)
end

function var0.getCardIndex(arg0)
	return arg0.cardIndex
end

function var0.setEnable(arg0, arg1)
	arg0.enable = arg1
end

function var0.setClear(arg0)
	setActive(arg0.clearSign, true)
	arg0:setOutline(false)

	arg0.canClick = false
end

function var0.setOutline(arg0, arg1)
	arg0.outline.enabled = arg1
end

function var0.initCard(arg0, arg1)
	arg0.cardIndex = arg1

	arg0:setSpriteTo(findTF(arg0.pics, "pic" .. arg1), arg0.img, false)
	setActive(arg0.clearSign, false)
	arg0:showBack()

	arg0.canClick = true
end

function var0.showBack(arg0)
	setActive(arg0.back, true)
	setActive(arg0.front, false)
	setActive(arg0.img, false)

	arg0.cardState = arg0.CARD_STATE_BACK

	arg0:setOutline(false)
end

function var0.showFront(arg0)
	setActive(arg0.back, false)
	setActive(arg0.front, true)
	setActive(arg0.img, true)

	arg0.cardState = arg0.CARD_STATE_FRONT
end

function var0.aniShowBack(arg0, arg1, arg2, arg3)
	arg0.canClick = false

	if arg1 then
		arg0:showBack()
	else
		arg0:showFront()
	end

	if not arg2 then
		arg0.aniStartCallBak(arg0, arg1)
	end

	arg0.cardTf.localScale = Vector3(1, 1, 1)

	LeanTween.scale(go(arg0.cardTf), Vector3(0, 1, 1), arg0.ANI_TIME):setDelay(defaultValue(arg3, 0)):setOnComplete(System.Action(function()
		if arg1 then
			arg0:showFront()
		else
			arg0:showBack()
		end

		LeanTween.scale(go(arg0.cardTf), Vector3(1, 1, 1), arg0.ANI_TIME):setOnComplete(System.Action(function()
			arg0.canClick = true

			if not arg2 then
				arg0.aniCallBack(arg0, arg1)
			end
		end))
	end))
end

function var0.setSpriteTo(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(Image))

	var0.sprite = arg1:GetComponent(typeof(Image)).sprite

	if arg3 then
		var0:SetNativeSize()
	end
end

function var0.clear(arg0)
	LeanTween.cancel(go(arg0.cardTf))
end

function var0.destroy(arg0)
	pg.DelegateInfo.Dispose(arg0)
	LeanTween.cancel(go(arg0.cardTf))
end

return var0
