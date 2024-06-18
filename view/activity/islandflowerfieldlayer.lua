local var0_0 = class("IslandFlowerFieldLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "IslandFlowerFieldUI"
end

function var0_0.setActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)

	local var0_3 = arg0_3._tf:Find("Text")

	setText(var0_3, i18n("islandnode_tips6"))
	var0_3:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(var0_3, false)
	end)

	arg0_3.rtChars = arg0_3._tf:Find("chars")
	arg0_3.rtShip = arg0_3.rtChars:GetChild(math.random(arg0_3.rtChars.childCount) - 1)
	arg0_3.contextData.shipConfigId = tonumber(arg0_3.rtShip.name)

	eachChild(arg0_3.rtChars, function(arg0_5)
		setActive(arg0_5, arg0_5 == arg0_3.rtShip)
	end)

	arg0_3.fieldList = {}
	arg0_3.posList = {}

	eachChild(arg0_3._tf:Find("field"), function(arg0_6)
		eachChild(arg0_6, function(arg0_7)
			table.insert(arg0_3.fieldList, arg0_7)
			table.insert(arg0_3.posList, arg0_3.rtChars:InverseTransformPoint(arg0_7.position))
		end)
	end)

	arg0_3.rtField = arg0_3._tf:Find("field")
	arg0_3.rtBtnGet = arg0_3._tf:Find("btn_get")

	onButton(arg0_3, arg0_3._tf:Find("btn_back"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)

	for iter0_3, iter1_3 in ipairs({
		"click",
		"click_lock"
	}) do
		onButton(arg0_3, arg0_3.rtBtnGet:Find(iter1_3), function()
			if arg0_3.timer then
				setActive(var0_3, true)

				return
			end

			arg0_3:emit(IslandFlowerFieldMediator.GET_FLOWER_AWARD, false)
		end, SFX_CONFIRM)
	end
end

function var0_0.refreshDisplay(arg0_10)
	local var0_10 = pg.TimeMgr.GetInstance()
	local var1_10 = var0_10:GetServerTime() >= var0_10:GetTimeToNextTime(math.max(arg0_10.activity.data1, arg0_10.activity.data2))

	setActive(arg0_10.rtBtnGet:Find("click"), var1_10)
	setActive(arg0_10.rtBtnGet:Find("click_lock"), not var1_10)

	for iter0_10, iter1_10 in ipairs(arg0_10.fieldList) do
		triggerToggle(iter1_10, var1_10)
	end

	if var1_10 then
		setText(arg0_10.rtBtnGet:Find("time/Text"), var0_10:DescCDTime(0))
	else
		local var2_10 = var0_10:GetTimeToNextTime() - var0_10:GetServerTime()
		local var3_10 = 0

		arg0_10.timer = Timer.New(function()
			if var3_10 < var2_10 then
				var3_10 = var3_10 + 1

				setText(arg0_10.rtBtnGet:Find("time/Text"), var0_10:DescCDTime(var2_10 - var3_10))
			else
				arg0_10.timer:Stop()

				arg0_10.timer = nil

				arg0_10:refreshDisplay()
			end
		end, 1, var2_10)

		arg0_10.timer.func()
		arg0_10.timer:Start()
	end
end

function var0_0.didEnter(arg0_12)
	local var0_12 = pg.TimeMgr.GetInstance()

	if var0_12:GetServerTime() - var0_12:GetTimeToNextTime(math.max(arg0_12.activity.data1, arg0_12.activity.data2)) < 86400 then
		arg0_12:refreshDisplay()
	else
		arg0_12:emit(IslandFlowerFieldMediator.GET_FLOWER_AWARD, true)
	end

	arg0_12:DoCharAction()
end

local var1_0 = 50

function var0_0.DoCharAction(arg0_13)
	local var0_13 = arg0_13.posList[math.random(#arg0_13.posList)]
	local var1_13 = var0_13 - arg0_13.rtShip.anchoredPosition3D

	if var1_13:SqrMagnitude() <= 0 then
		return arg0_13:DoCharAction()
	end

	var1_13.x = var1_13.x - (var1_13.x < 0 and -1 or 1) * 100

	local var2_13 = {}

	table.insert(var2_13, function(arg0_14)
		SetAction(arg0_13.rtShip, "jiaoshui_walk")
		setLocalScale(arg0_13.rtShip, {
			x = (var1_13.x < 0 and -1 or 1) * math.abs(arg0_13.rtShip.localScale.x)
		})

		arg0_13.charLT = LeanTween.move(arg0_13.rtShip, arg0_13.rtShip.anchoredPosition3D + var1_13, var1_13:Magnitude() / var1_0):setOnComplete(System.Action(arg0_14)).uniqueId
	end)
	table.insert(var2_13, function(arg0_15)
		var1_13 = var0_13 - arg0_13.rtShip.anchoredPosition3D

		SetAction(arg0_13.rtShip, "jiaoshui", false)
		setLocalScale(arg0_13.rtShip, {
			x = (var1_13.x < 0 and -1 or 1) * math.abs(arg0_13.rtShip.localScale.x)
		})

		arg0_13.charLT = LeanTween.delayedCall(3, System.Action(arg0_15)).uniqueId
	end)
	table.insert(var2_13, function(arg0_16)
		SetAction(arg0_13.rtShip, "jiaoshui_stand")

		arg0_13.charLT = LeanTween.delayedCall(4.66666666666667, System.Action(arg0_16)).uniqueId
	end)
	seriesAsync(var2_13, function()
		arg0_13.charLT = nil

		arg0_13:DoCharAction()
	end)
end

function var0_0.willExit(arg0_18)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_18._tf)

	if arg0_18.timer then
		arg0_18.timer:Stop()

		arg0_18.timer = nil
	end

	if arg0_18.charLT then
		LeanTween.cancel(arg0_18.charLT)

		arg0_18.charLT = nil
	end
end

return var0_0
