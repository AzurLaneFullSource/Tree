local var0 = class("FireworkFactoryView", import("..BaseMiniGameView"))
local var1 = Mathf

function var0.getUIName(arg0)
	return "FireworkFactoryUI"
end

local var2 = 50
local var3 = {
	{
		color = "FFD26FFF",
		name = "na"
	},
	{
		color = "DE89ECFF",
		name = "k"
	},
	{
		color = "8F77DFFF",
		name = "rb"
	},
	{
		color = "70ad9f",
		name = "zn"
	},
	{
		color = "FF7069FF",
		name = "ca"
	},
	{
		color = "7faf6e",
		name = "cu"
	}
}
local var4 = {
	"s",
	"a",
	"b",
	"c"
}

function var0.TransformColor(arg0)
	local var0 = tonumber(string.sub(arg0, 1, 2), 16)
	local var1 = tonumber(string.sub(arg0, 3, 4), 16)
	local var2 = tonumber(string.sub(arg0, 5, 6), 16)

	return Color.New(var0 / 255, var1 / 255, var2 / 255)
end

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0.plate = arg0:findTF("plate")
	arg0.storage = arg0:findTF("storage")
	arg0.dispenseView = arg0:findTF("top/dispenseView")

	setActive(arg0.dispenseView, false)

	arg0.resultWindow = arg0:findTF("top/resultwindow")

	setActive(arg0.resultWindow, false)

	arg0.btn_back = arg0.top:Find("noAdaptPanel/back")
	arg0.btn_help = arg0.top:Find("noAdaptPanel/title/help")
	arg0.timesText = arg0.top:Find("times/text")
	arg0.ballPlate = arg0.plate:Find("ball_plate")
	arg0.plateRings = {}

	for iter0 = 1, 3 do
		table.insert(arg0.plateRings, arg0.ballPlate:GetChild(iter0))
	end

	arg0.btn_load = arg0.plate:Find("btn_load")
	arg0.ballSelectPanel = arg0.plate:Find("panel/layout")
	arg0.ballSelects = CustomIndexLayer.Clone2Full(arg0.ballSelectPanel, 3)
	arg0.ballSelectStatus = {
		0,
		0,
		0
	}
	arg0.lastSelectedBall = nil
	arg0.ballStoragePanel = arg0.storage:Find("house/layout")
	arg0.ballStorages = CustomIndexLayer.Clone2Full(arg0.ballStoragePanel, 6)
	arg0.screen_mask = arg0:findTF("mask")
	arg0.btn_next = arg0:findTF("Button")
	arg0.btn_next_text = arg0.btn_next:Find("Image")
	arg0.desc_dispense = arg0.dispenseView:Find("intro/Scroll View/Viewport/text")

	setText(arg0.desc_dispense, i18n("help_firework_produce"))

	arg0.btn_dispenseBG = arg0.dispenseView:Find("bg")
	arg0.btn_hammer = arg0.dispenseView:Find("container/Button")
	arg0.btn_hammer_text = arg0.btn_hammer:Find("text")
	arg0.slider_powder = arg0.dispenseView:Find("container/Slider/Fill Area"):GetComponent("Slider")
	arg0.slider_progress = arg0.dispenseView:Find("progress/Slider"):GetComponent("Slider")
	arg0.slider_progress_bg = arg0.dispenseView:Find("progress/Slider/Background/progressdi")
	arg0.slider_bubble = arg0.dispenseView:Find("container/Slider/Fill Area/Fill/handler/bubble")
	arg0.slider_bubble_text = arg0.slider_bubble:Find("text")
	arg0.progress_width = arg0.dispenseView:Find("progress/Slider/Handle Slide Area").rect.width
	arg0.progress_sub_mark_1 = arg0.dispenseView:Find("progress/Slider/Handle Slide Area/submark1")
	arg0.progress_sub_mark_2 = arg0.dispenseView:Find("progress/Slider/Handle Slide Area/submark2")
	arg0.progress_dis = {}

	for iter1 = 0, arg0.slider_progress_bg.childCount - 1 do
		table.insert(arg0.progress_dis, arg0.slider_progress_bg:GetChild(iter1))
	end

	arg0.result_digits = {}

	pg.PoolMgr.GetInstance():GetPrefab("ui/light01", "", true, function(arg0)
		tf(arg0):SetParent(arg0.dispenseView, false)
		arg0:SetActive(false)

		arg0.effect_light = arg0
	end)

	arg0.result_bg = arg0.resultWindow:Find("bg")
	arg0.result_desc = arg0.resultWindow:Find("window/Text")

	setText(arg0.result_desc, i18n("result_firework_produce"))

	arg0.btn_result_confirm = arg0.resultWindow:Find("window/button")
	arg0.result_pingjia = arg0.resultWindow:Find("window/pingjia"):GetComponent("Image")
	arg0.flagStart = false
	arg0.flagDispense = false
	arg0.progressDispense = 0
end

function var0.SetSprite(arg0, arg1, arg2)
	local var0 = arg1:GetComponent("Image")

	arg0:SetImageSprite(var0, arg2)
end

function var0.SetImageSprite(arg0, arg1, arg2)
	pg.PoolMgr.GetInstance():GetSprite("ui/fireworkfactoryui_atlas", arg2, false, function(arg0)
		arg1.sprite = arg0
	end)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btn_back, function()
		if arg0.flagDispense then
			arg0:ExitDispenseView()
		elseif arg0:CheckpowderDispensed() and arg0.flagStart then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tips_firework_exit"),
				onYes = function()
					arg0:emit(var0.ON_BACK_PRESSED)
				end
			})
		else
			arg0:emit(var0.ON_BACK)
		end
	end)
	onButton(arg0, arg0.btn_dispenseBG, function()
		arg0:ExitDispenseView()
	end)
	onButton(arg0, arg0.btn_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2022_firework.tip
		})
	end)
	onButton(arg0, arg0.btn_next, function()
		if not arg0.flagStart then
			arg0.flagStart = true

			arg0:UpdateNextBtn()
		elseif arg0:CheckballLoaded() then
			arg0:EnterDispenseView()
		end
	end)
	onButton(arg0, arg0.btn_hammer, function()
		local var0 = arg0.progressDispense

		if var0 == 0 then
			arg0:ResetHammerAnim()
			arg0:FindNextPowderProgress()
			arg0:UpdateContainer()
		elseif var0 == 1 then
			arg0.result_digits[1] = arg0.slider_powder.value * 100

			arg0:FindandStopProgress()
			arg0:UpdateContainer()
		elseif var0 == 2 then
			arg0.result_digits[2] = arg0.slider_powder.value * 100

			arg0:FindandStopProgress()
			arg0:UpdateContainer()
		elseif var0 == 3 then
			arg0.result_digits[3] = arg0.slider_powder.value * 100

			arg0:FindandStopProgress()
			arg0:UpdateContainer()
		end
	end)
	onButton(arg0, arg0.btn_result_confirm, function()
		arg0:ShowResult()
	end)
	onButton(arg0, arg0.result_bg, function()
		arg0:ShowResult()
	end)

	for iter0 = 1, #arg0.ballStorages do
		local var0 = arg0.ballStorages[iter0]

		arg0:UpdateBall(var0, iter0)
		onButton(arg0, var0:Find("mask"), function()
			if not arg0.lastSelectedBall or arg0.lastSelectedBall <= 0 then
				return
			end

			arg0.ballSelectStatus[arg0.lastSelectedBall] = iter0

			arg0:UpdateRing(arg0.lastSelectedBall, iter0)
			arg0:UpdateBall(arg0.ballSelects[arg0.lastSelectedBall]:Find("ball"), iter0)
			arg0:UdpateSelectedBall(arg0.lastSelectedBall + 1)
			arg0:UpdateNextBtn()
		end)
	end

	for iter1 = 1, #arg0.ballSelects do
		local var1 = arg0.ballSelects[iter1]

		arg0:UpdateBall(var1:Find("ball"), 0)
		arg0:UpdateRing(iter1, 0)
		onButton(arg0, var1:Find("mask"), function()
			arg0.ballSelectStatus[iter1] = 0

			arg0:UpdateBall(arg0.ballSelects[iter1]:Find("ball"), 0)
			arg0:UpdateRing(iter1, 0)
			arg0:UdpateSelectedBall(iter1)
			arg0:UpdateNextBtn()
		end)
	end

	arg0:ResetView()
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top, {
		groupName = LayerWeightConst.GROUP_FIREWORK_PRODUCE
	})

	local var2 = arg0:GetMGData():GetSimpleValue("score_reference")
	local var3 = {}

	var3[1] = 0

	for iter2, iter3 in ipairs(var2) do
		var3[#var2 - iter2 + 2] = iter3[1]
		var3[#var2 + iter2 + 1] = iter3[2]
	end

	var3[#var3] = 300

	for iter4 = 1, #var3 - 1 do
		local var4 = var3[iter4] / 300
		local var5 = var3[iter4 + 1] / 300

		arg0.progress_dis[iter4].anchorMin = Vector2(var4, 0)
		arg0.progress_dis[iter4].anchorMax = Vector2(var5, 1)
		arg0.progress_dis[iter4].sizeDelta = Vector2.zero
	end
end

function var0.UpdateNextBtn(arg0)
	if not arg0.flagStart then
		local var0 = "dispense_ready"
		local var1 = arg0:GetMGData():GetRuntimeData("elements")

		if var1 and #var1 > 3 and var1[4] == SummerFeastScene.GetCurrentDay() then
			var0 = "dispense_retry"
		end

		arg0:SetSprite(arg0.btn_next_text, var0)
	else
		arg0:SetSprite(arg0.btn_next_text, "dispense_confirm")
	end

	setActive(arg0.screen_mask, not arg0.flagStart)

	local var2 = not arg0.flagStart or arg0:CheckballLoaded()

	setButtonEnabled(arg0.btn_next, var2)
end

function var0.UpdateDispenseBtn(arg0)
	local var0 = arg0:CheckpowderDispensed()

	arg0:SetImageSprite(arg0.btn_load_img, var0 and "btn_loadcompleted" or "btn_load")
	arg0:SetSprite(arg0.btn_load_text, var0 and "load_completed" or "load_ready")
	setButtonEnabled(arg0.btn_load, not var0)
end

local var5 = {
	"start",
	"first_time",
	"second_time",
	"third_time",
	"finish_time"
}

function var0.FindandStopProgress(arg0)
	arg0:StopHammerAnim()
	setButtonEnabled(arg0.btn_hammer, false)
	setButtonEnabled(arg0.btn_dispenseBG, false)
	setText(arg0.slider_bubble_text, math.ceil(arg0.result_digits[#arg0.result_digits]) .. "%")
	setActive(arg0.slider_bubble, true)
	setActive(arg0.effect_light, true)

	arg0.progressDispense = #arg0.result_digits >= 3 and 4 or 0

	local var0 = 0

	for iter0 = 1, 3 do
		local var1 = arg0.result_digits[iter0]

		if var1 then
			var0 = var0 + var1
		end
	end

	local var2 = 0

	for iter1 = 1, #arg0.result_digits - 1 do
		local var3 = arg0.result_digits[iter1]

		if var3 then
			var2 = var2 + var3

			if iter1 == 1 then
				setActive(arg0.progress_sub_mark_1, true)

				local var4 = Vector2(arg0.progress_width * var2 / 300, 27)

				arg0.progress_sub_mark_1.anchoredPosition = var4
			elseif iter1 == 2 then
				setActive(arg0.progress_sub_mark_2, true)

				local var5 = Vector2(arg0.progress_width * var2 / 300, 27)

				arg0.progress_sub_mark_2.anchoredPosition = var5
			end
		end
	end

	local var6 = arg0.slider_bubble.transform.position
	local var7 = arg0.slider_progress.transform.position
	local var8 = arg0.slider_progress.value

	arg0.progressAnim = LeanTween.value(arg0.slider_progress.gameObject, 0, 1, 1.5):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0)
		arg0.slider_progress.value = var1.Lerp(var8, var0 / 300, arg0)

		if arg0.effect_light then
			arg0.effect_light.transform.position = Vector3.Lerp(var6, var7, arg0 * 3) - Vector3(0, 0, 2)

			if arg0 * 3 > 1 then
				setActive(arg0.effect_light, false)
			end
		end
	end)):setOnComplete(System.Action(function()
		setButtonEnabled(arg0.btn_hammer, true)
		setButtonEnabled(arg0.btn_dispenseBG, true)

		if arg0.progressDispense > 3 then
			arg0:FindNextPowderProgress()
		end
	end))
end

function var0.FindNextPowderProgress(arg0)
	arg0.progressDispense = #arg0.result_digits + 1

	if arg0.progressDispense > 3 then
		arg0:StopHammerAnim()
		setButtonEnabled(arg0.btn_hammer, false)
		arg0:ShowResultWindow()
	end
end

function var0.ShowResultWindow(arg0)
	if #arg0.result_digits < 3 then
		return
	end

	setActive(arg0.resultWindow, true)

	local var0 = arg0:GetMGData():GetSimpleValue("score_reference")
	local var1 = 0

	for iter0 = 1, 3 do
		var1 = var1 + arg0.result_digits[iter0]
	end

	local var2 = 4

	for iter1, iter2 in ipairs(var0) do
		if var1 >= iter2[1] and var1 <= iter2[2] then
			var2 = iter1

			break
		end
	end

	if var2 <= 0 then
		return
	end

	arg0:SetImageSprite(arg0.result_pingjia, var4[var2])
end

function var0.ShowResult(arg0)
	if arg0:GetMGHubData().count <= 0 then
		arg0:AfterResult()
	else
		arg0:GetReward()
	end

	setActive(arg0.resultWindow, false)
end

function var0.OnGetAwardDone(arg0, arg1)
	local var0 = arg0:GetMGHubData()
	local var1 = var0.ultimate == 0 and var0.usedtime >= var0:getConfig("reward_need")

	if arg1.cmd == MiniGameOPCommand.CMD_COMPLETE and var1 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	elseif arg1.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		arg0:AfterResult()
	else
		arg0:AfterResult()
	end
end

function var0.AfterResult(arg0)
	local var0 = SummerFeastScene.GetCurrentDay()
	local var1 = Clone(arg0.ballSelectStatus)

	table.insert(var1, var0)
	arg0:StoreDataToServer(var1)
	onNextTick(function()
		arg0:emit(var0.ON_BACK)
	end)
end

function var0.reset(arg0)
	arg0:ExitDispenseView()

	arg0.flagStart = false
	arg0.flagDispense = false
	arg0.progressDispense = 0
	arg0.result_digits = {}

	arg0:ResetView()
	arg0:UpdateNextBtn()
end

function var0.GetReward(arg0)
	if #arg0.result_digits < 3 then
		return
	end

	local var0 = arg0:GetMGData():GetSimpleValue("score_reference")
	local var1 = 0

	for iter0 = 1, 3 do
		var1 = var1 + arg0.result_digits[iter0]
	end

	local var2 = 4

	for iter1, iter2 in ipairs(var0) do
		if var1 >= iter2[1] and var1 <= iter2[2] then
			var2 = iter1

			break
		end
	end

	if var2 <= 0 then
		return
	end

	arg0:SendSuccess(var2)
end

function var0.ResetHammerAnim(arg0)
	if arg0.hammerAnim then
		arg0:StopHammerAnim()
	end

	setActive(arg0.slider_bubble, false)

	local var0 = (arg0:GetMGData():GetSimpleValue("roundTime") or var2) / 100

	arg0.hammerAnim = LeanTween.value(arg0.slider_powder.gameObject, 0, 1, var0 * 2):setEase(LeanTweenType.linear):setLoopPingPong():setOnUpdate(System.Action_float(function(arg0)
		arg0.slider_powder.value = arg0
	end))
end

function var0.StopHammerAnim(arg0)
	if not arg0.hammerAnim then
		return
	end

	LeanTween.cancel(arg0.hammerAnim.uniqueId)

	arg0.hammerAnim = nil
end

function var0.UpdateContainer(arg0)
	arg0:SetSprite(arg0.btn_hammer_text, var5[arg0.progressDispense + 1])

	local var0 = 0
	local var1 = true

	for iter0 = 1, 3 do
		local var2 = arg0.result_digits[iter0]

		var1 = var1 and var2 ~= nil

		if var2 then
			var0 = var0 + var2
		end
	end

	arg0.slider_progress.value = var0 / 300
end

function var0.StopProgressAnim(arg0)
	if not arg0.progressAnim then
		return
	end

	LeanTween.cancel(arg0.progressAnim.uniqueId)

	arg0.progressAnim = nil
end

function var0.CheckballLoaded(arg0)
	return _.all(arg0.ballSelectStatus, function(arg0)
		return arg0 > 0
	end)
end

function var0.CheckpowderDispensed(arg0)
	return #arg0.result_digits >= 3
end

function var0.UpdateBall(arg0, arg1, arg2)
	setActive(arg1, arg2 > 0)

	if arg2 <= 0 then
		return
	end

	arg1:GetComponent("Image").color = arg0.TransformColor(var3[arg2].color)

	arg0:SetSprite(arg1:Find("symbol"), var3[arg2].name)
end

function var0.UpdateRing(arg0, arg1, arg2)
	if arg1 <= 0 or arg1 > 3 then
		return
	end

	local var0 = arg0.plateRings[arg1]

	setActive(var0, arg2 > 0)

	if arg2 <= 0 then
		return
	end

	var0:GetComponent("Image").color = arg0.TransformColor(var3[arg2].color)
end

function var0.ResetView(arg0)
	_.each(arg0.plateRings, function(arg0)
		setActive(arg0, false)
	end)
	_.each(arg0.ballSelects, function(arg0)
		setActive(arg0:Find("ball"), false)
		setActive(arg0:Find("selected"), false)
	end)

	local var0 = arg0:GetMGHubData()

	setText(arg0.timesText, var0.count)

	local var1 = arg0:GetMGData():GetRuntimeData("elements")

	if var1 and #var1 > 3 and var1[4] == SummerFeastScene.GetCurrentDay() then
		for iter0 = 1, 3 do
			local var2 = var1[iter0]

			arg0.ballSelectStatus[iter0] = var2

			if var2 > 0 then
				arg0:UpdateRing(iter0, var2)

				local var3 = arg0.ballSelects[iter0]:Find("ball")

				arg0:UpdateBall(var3, var2)
			end
		end
	end

	arg0:UdpateSelectedBall(1)
	arg0:UpdateNextBtn()
	setActive(arg0.slider_bubble, false)
	setActive(arg0.progress_sub_mark_1, false)
	setActive(arg0.progress_sub_mark_2, false)
end

function var0.UdpateSelectedBall(arg0, arg1)
	if arg1 <= 0 or arg1 > 3 then
		return
	end

	if arg0.lastSelectedBall then
		if arg0.lastSelectedBall == arg1 then
			return
		end

		setActive(arg0.ballSelects[arg0.lastSelectedBall]:Find("selected"), false)
	end

	setActive(arg0.ballSelects[arg1]:Find("selected"), true)

	arg0.lastSelectedBall = arg1
end

function var0.EnterDispenseView(arg0)
	setActive(arg0.dispenseView, true)

	arg0.flagDispense = true
	arg0.progressDispense = #arg0.result_digits >= 3 and 4 or 0

	arg0:UpdateContainer()

	arg0.slider_powder.value = 0
end

function var0.ExitDispenseView(arg0)
	if not arg0.flagDispense then
		return
	end

	arg0:UpdateNextBtn()
	arg0:StopHammerAnim()
	arg0:StopProgressAnim()

	arg0.progressDispense = 0

	setActive(arg0.dispenseView, false)
	setButtonEnabled(arg0.btn_hammer, true)

	local var0 = arg0:GetMGHubData()

	setText(arg0.timesText, var0.count)
	setActive(arg0.slider_bubble, false)

	if arg0.effect_light then
		setActive(arg0.effect_light, false)
	end

	arg0.flagDispense = false
end

function var0.willExit(arg0)
	arg0:ExitDispenseView()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)

	if arg0.effect_light then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/light01", "", arg0.effect_light)
	end

	pg.PoolMgr.GetInstance():DestroyPrefab("ui/light01", "")
	pg.PoolMgr.GetInstance():DestroySprite("ui/fireworkfactoryui_atlas")

	if arg0.OPTimer then
		arg0.OPTimer:Stop()

		arg0.OPTimer = nil
	end
end

return var0
