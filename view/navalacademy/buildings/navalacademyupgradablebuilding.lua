local var0_0 = class("NavalAcademyUpgradableBuilding", import(".NavalAcademyBuilding"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.nameTF = findTF(arg0_1._tf, "name")
	arg0_1.levelTxt = findTF(arg0_1._tf, "name/level"):GetComponent(typeof(Text))
	arg0_1.timeTF = findTF(arg0_1._tf, "time")
	arg0_1.timeTxt = findTF(arg0_1._tf, "time/Text"):GetComponent(typeof(Text))
	arg0_1.floatTF = findTF(arg0_1._tf, "float")
	arg0_1.floatTxt = arg0_1.floatTF:Find("Text"):GetComponent(typeof(Text))
	arg0_1.bubble = findTF(arg0_1._tf, "popup")
	arg0_1.heigh = arg0_1.bubble.localPosition.y

	setActive(arg0_1.floatTF, false)
	setText(findTF(arg0_1._tf, "time/label"), i18n("class_label_upgrading"))
end

function var0_0.OnInit(arg0_2)
	arg0_2:UpdateResField()
	arg0_2:UpdateBubble()
end

function var0_0.FloatAni(arg0_3)
	LeanTween.moveLocalY(go(arg0_3.bubble), arg0_3.heigh + 20, 2):setFrom(arg0_3.heigh):setLoopPingPong()
end

function var0_0.UpdateBubble(arg0_4)
	local var0_4 = arg0_4:GetResField():HasRes()

	if var0_4 then
		arg0_4:FloatAni()
	end

	setActive(arg0_4.bubble, var0_4)
	onButton(arg0_4, arg0_4.bubble, function()
		local var0_5 = arg0_4:GetResField()

		arg0_4:emit(NavalAcademyMediator.ON_GET_RES, var0_5:GetResourceType())
	end, SFX_PANEL)
end

function var0_0.PlayGetResAnim(arg0_6, arg1_6)
	arg0_6:UpdateBubble()

	arg0_6.floatTxt.text = "+" .. arg1_6

	setActive(arg0_6.floatTF, true)
	LeanTween.moveY(rtf(arg0_6.floatTF), 30, 1):setFrom(0):setOnComplete(System.Action(function()
		setActive(arg0_6.floatTF, false)
	end))
end

function var0_0.UpdateResField(arg0_8)
	arg0_8:RemoveTimer()

	local var0_8 = arg0_8:GetResField()

	arg0_8.levelTxt.text = "Lv." .. var0_8:GetLevel()

	local var1_8 = var0_8:IsStarting()

	setActive(arg0_8.timeTF, var1_8)
	setActive(arg0_8.nameTF, not var1_8)

	if var1_8 then
		arg0_8:AddTimer()
	end

	arg0_8:RefreshTip()
end

function var0_0.AddTimer(arg0_9)
	local var0_9 = arg0_9:GetResField()

	arg0_9.timer = Timer.New(function()
		local var0_10 = var0_9:GetDuration()

		if var0_10 and var0_10 > 0 then
			arg0_9.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0_10)
		else
			arg0_9:UpdateResField()
		end
	end, 1, -1)

	arg0_9.timer:Start()
	arg0_9.timer.func()
end

function var0_0.RemoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.IsTip(arg0_12)
	return arg0_12:GetResField():CanUpgrade()
end

function var0_0.Dispose(arg0_13)
	var0_0.super.Dispose(arg0_13)
	arg0_13:RemoveTimer()

	if LeanTween.isTweening(go(arg0_13.floatTF)) then
		LeanTween.cancel(go(arg0_13.floatTF))
	end

	LeanTween.cancel(go(arg0_13.bubble))
end

function var0_0.GetResField(arg0_14)
	assert(false)
end

return var0_0
