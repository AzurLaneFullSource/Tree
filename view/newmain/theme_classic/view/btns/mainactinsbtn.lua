local var0 = class("MainActInsBtn", import(".MainBaseSpcailActBtn"))

function var0.GetContainer(arg0)
	return arg0.root
end

function var0.InShowTime(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

	return var0 and not var0:isEnd()
end

function var0.GetUIName(arg0)
	return "MainUIInsBtn"
end

function var0.OnClick(arg0)
	arg0.event:emit(NewMainMediator.SKIP_INS)
end

function var0.OnInit(arg0)
	arg0.animator = arg0._tf:Find("icon"):GetComponent(typeof(Animator))

	local var0 = getProxy(InstagramProxy):ShouldShowTip()

	arg0.animator.enabled = var0

	setActive(arg0._tf:Find("Tip"), var0)

	arg0._tf.localScale = arg0.isScale and Vector3(0.85, 0.85, 1) or Vector3(1, 1, 1)

	setAnchoredPosition(arg0._tf, {
		y = arg0.isScale and -950 or -752.5
	})
end

return var0
