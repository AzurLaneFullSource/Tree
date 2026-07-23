local var0_0 = class("MainActInsBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root
end

function var0_0.InShowTime(arg0_2)
	return true
end

function var0_0.GetUIName(arg0_3)
	return "MainUIInsBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.SKIP_INS)
end

function var0_0.OnRegister(arg0_5)
	arg0_5.initX = getAnchoredPosition(arg0_5._tf).x
end

function var0_0.OnInit(arg0_6)
	arg0_6.animator = arg0_6._tf:Find("icon"):GetComponent(typeof(Animator))

	local var0_6 = getProxy(InstagramProxy):ShouldShowTip() or getProxy(InstagramChatProxy):ShouldShowTip() or getProxy(InstagramProxy):ShouldShowTip()

	arg0_6.animator.enabled = var0_6

	setActive(arg0_6._tf:Find("Tip"), var0_6)

	arg0_6._tf.localScale = arg0_6.isScale and Vector3(0.85, 0.85, 1) or Vector3(1, 1, 1)

	local var1_6 = arg0_6.isOverflow and arg0_6.initX - 200 or arg0_6.initX

	setAnchoredPosition(arg0_6._tf, {
		x = var1_6,
		y = arg0_6.isScale and -950 or -752.5
	})
end

return var0_0
