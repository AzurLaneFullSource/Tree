local var0_0 = class("MainActInsBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root
end

function var0_0.InShowTime(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

	return var0_2 and not var0_2:isEnd()
end

function var0_0.GetUIName(arg0_3)
	return "MainUIInsBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.SKIP_INS)
end

function var0_0.OnInit(arg0_5)
	arg0_5.animator = arg0_5._tf:Find("icon"):GetComponent(typeof(Animator))

	local var0_5 = getProxy(InstagramProxy):ShouldShowTip()

	arg0_5.animator.enabled = var0_5

	setActive(arg0_5._tf:Find("Tip"), var0_5)

	arg0_5._tf.localScale = arg0_5.isScale and Vector3(0.85, 0.85, 1) or Vector3(1, 1, 1)

	setAnchoredPosition(arg0_5._tf, {
		y = arg0_5.isScale and -950 or -752.5
	})
end

return var0_0
