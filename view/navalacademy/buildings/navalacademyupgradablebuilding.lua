local var0 = class("NavalAcademyUpgradableBuilding", import(".NavalAcademyBuilding"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.nameTF = findTF(arg0._tf, "name")
	arg0.levelTxt = findTF(arg0._tf, "name/level"):GetComponent(typeof(Text))
	arg0.timeTF = findTF(arg0._tf, "time")
	arg0.timeTxt = findTF(arg0._tf, "time/Text"):GetComponent(typeof(Text))
	arg0.floatTF = findTF(arg0._tf, "float")
	arg0.floatTxt = arg0.floatTF:Find("Text"):GetComponent(typeof(Text))
	arg0.bubble = findTF(arg0._tf, "popup")
	arg0.heigh = arg0.bubble.localPosition.y

	setActive(arg0.floatTF, false)
	setText(findTF(arg0._tf, "time/label"), i18n("class_label_upgrading"))
end

function var0.OnInit(arg0)
	arg0:UpdateResField()
	arg0:UpdateBubble()
end

function var0.FloatAni(arg0)
	LeanTween.moveLocalY(go(arg0.bubble), arg0.heigh + 20, 2):setFrom(arg0.heigh):setLoopPingPong()
end

function var0.UpdateBubble(arg0)
	local var0 = arg0:GetResField():HasRes()

	if var0 then
		arg0:FloatAni()
	end

	setActive(arg0.bubble, var0)
	onButton(arg0, arg0.bubble, function()
		local var0 = arg0:GetResField()

		arg0:emit(NavalAcademyMediator.ON_GET_RES, var0:GetResourceType())
	end, SFX_PANEL)
end

function var0.PlayGetResAnim(arg0, arg1)
	arg0:UpdateBubble()

	arg0.floatTxt.text = "+" .. arg1

	setActive(arg0.floatTF, true)
	LeanTween.moveY(rtf(arg0.floatTF), 30, 1):setFrom(0):setOnComplete(System.Action(function()
		setActive(arg0.floatTF, false)
	end))
end

function var0.UpdateResField(arg0)
	arg0:RemoveTimer()

	local var0 = arg0:GetResField()

	arg0.levelTxt.text = "Lv." .. var0:GetLevel()

	local var1 = var0:IsStarting()

	setActive(arg0.timeTF, var1)
	setActive(arg0.nameTF, not var1)

	if var1 then
		arg0:AddTimer()
	end

	arg0:RefreshTip()
end

function var0.AddTimer(arg0)
	local var0 = arg0:GetResField()

	arg0.timer = Timer.New(function()
		local var0 = var0:GetDuration()

		if var0 and var0 > 0 then
			arg0.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		else
			arg0:UpdateResField()
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.IsTip(arg0)
	return arg0:GetResField():CanUpgrade()
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:RemoveTimer()

	if LeanTween.isTweening(go(arg0.floatTF)) then
		LeanTween.cancel(go(arg0.floatTF))
	end

	LeanTween.cancel(go(arg0.bubble))
end

function var0.GetResField(arg0)
	assert(false)
end

return var0
