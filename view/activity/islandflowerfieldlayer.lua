local var0 = class("IslandFlowerFieldLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "IslandFlowerFieldUI"
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	local var0 = arg0._tf:Find("Text")

	setText(var0, i18n("islandnode_tips6"))
	var0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(var0, false)
	end)

	arg0.rtChars = arg0._tf:Find("chars")
	arg0.rtShip = arg0.rtChars:GetChild(math.random(arg0.rtChars.childCount) - 1)
	arg0.contextData.shipConfigId = tonumber(arg0.rtShip.name)

	eachChild(arg0.rtChars, function(arg0)
		setActive(arg0, arg0 == arg0.rtShip)
	end)

	arg0.fieldList = {}
	arg0.posList = {}

	eachChild(arg0._tf:Find("field"), function(arg0)
		eachChild(arg0, function(arg0)
			table.insert(arg0.fieldList, arg0)
			table.insert(arg0.posList, arg0.rtChars:InverseTransformPoint(arg0.position))
		end)
	end)

	arg0.rtField = arg0._tf:Find("field")
	arg0.rtBtnGet = arg0._tf:Find("btn_get")

	onButton(arg0, arg0._tf:Find("btn_back"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	for iter0, iter1 in ipairs({
		"click",
		"click_lock"
	}) do
		onButton(arg0, arg0.rtBtnGet:Find(iter1), function()
			if arg0.timer then
				setActive(var0, true)

				return
			end

			arg0:emit(IslandFlowerFieldMediator.GET_FLOWER_AWARD, false)
		end, SFX_CONFIRM)
	end
end

function var0.refreshDisplay(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:GetServerTime() >= var0:GetTimeToNextTime(math.max(arg0.activity.data1, arg0.activity.data2))

	setActive(arg0.rtBtnGet:Find("click"), var1)
	setActive(arg0.rtBtnGet:Find("click_lock"), not var1)

	for iter0, iter1 in ipairs(arg0.fieldList) do
		triggerToggle(iter1, var1)
	end

	if var1 then
		setText(arg0.rtBtnGet:Find("time/Text"), var0:DescCDTime(0))
	else
		local var2 = var0:GetTimeToNextTime() - var0:GetServerTime()
		local var3 = 0

		arg0.timer = Timer.New(function()
			if var3 < var2 then
				var3 = var3 + 1

				setText(arg0.rtBtnGet:Find("time/Text"), var0:DescCDTime(var2 - var3))
			else
				arg0.timer:Stop()

				arg0.timer = nil

				arg0:refreshDisplay()
			end
		end, 1, var2)

		arg0.timer.func()
		arg0.timer:Start()
	end
end

function var0.didEnter(arg0)
	local var0 = pg.TimeMgr.GetInstance()

	if var0:GetServerTime() - var0:GetTimeToNextTime(math.max(arg0.activity.data1, arg0.activity.data2)) < 86400 then
		arg0:refreshDisplay()
	else
		arg0:emit(IslandFlowerFieldMediator.GET_FLOWER_AWARD, true)
	end

	arg0:DoCharAction()
end

local var1 = 50

function var0.DoCharAction(arg0)
	local var0 = arg0.posList[math.random(#arg0.posList)]
	local var1 = var0 - arg0.rtShip.anchoredPosition3D

	if var1:SqrMagnitude() <= 0 then
		return arg0:DoCharAction()
	end

	var1.x = var1.x - (var1.x < 0 and -1 or 1) * 100

	local var2 = {}

	table.insert(var2, function(arg0)
		SetAction(arg0.rtShip, "jiaoshui_walk")
		setLocalScale(arg0.rtShip, {
			x = (var1.x < 0 and -1 or 1) * math.abs(arg0.rtShip.localScale.x)
		})

		arg0.charLT = LeanTween.move(arg0.rtShip, arg0.rtShip.anchoredPosition3D + var1, var1:Magnitude() / var1):setOnComplete(System.Action(arg0)).uniqueId
	end)
	table.insert(var2, function(arg0)
		var1 = var0 - arg0.rtShip.anchoredPosition3D

		SetAction(arg0.rtShip, "jiaoshui", false)
		setLocalScale(arg0.rtShip, {
			x = (var1.x < 0 and -1 or 1) * math.abs(arg0.rtShip.localScale.x)
		})

		arg0.charLT = LeanTween.delayedCall(3, System.Action(arg0)).uniqueId
	end)
	table.insert(var2, function(arg0)
		SetAction(arg0.rtShip, "jiaoshui_stand")

		arg0.charLT = LeanTween.delayedCall(4.66666666666667, System.Action(arg0)).uniqueId
	end)
	seriesAsync(var2, function()
		arg0.charLT = nil

		arg0:DoCharAction()
	end)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	if arg0.charLT then
		LeanTween.cancel(arg0.charLT)

		arg0.charLT = nil
	end
end

return var0
