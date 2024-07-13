local var0_0 = class("FireworkFactoryView", import("..BaseMiniGameView"))
local var1_0 = Mathf

function var0_0.getUIName(arg0_1)
	return "FireworkFactoryUI"
end

local var2_0 = 50
local var3_0 = {
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
local var4_0 = {
	"s",
	"a",
	"b",
	"c"
}

function var0_0.TransformColor(arg0_2)
	local var0_2 = tonumber(string.sub(arg0_2, 1, 2), 16)
	local var1_2 = tonumber(string.sub(arg0_2, 3, 4), 16)
	local var2_2 = tonumber(string.sub(arg0_2, 5, 6), 16)

	return Color.New(var0_2 / 255, var1_2 / 255, var2_2 / 255)
end

function var0_0.init(arg0_3)
	arg0_3.top = arg0_3:findTF("top")
	arg0_3.plate = arg0_3:findTF("plate")
	arg0_3.storage = arg0_3:findTF("storage")
	arg0_3.dispenseView = arg0_3:findTF("top/dispenseView")

	setActive(arg0_3.dispenseView, false)

	arg0_3.resultWindow = arg0_3:findTF("top/resultwindow")

	setActive(arg0_3.resultWindow, false)

	arg0_3.btn_back = arg0_3.top:Find("noAdaptPanel/back")
	arg0_3.btn_help = arg0_3.top:Find("noAdaptPanel/title/help")
	arg0_3.timesText = arg0_3.top:Find("times/text")
	arg0_3.ballPlate = arg0_3.plate:Find("ball_plate")
	arg0_3.plateRings = {}

	for iter0_3 = 1, 3 do
		table.insert(arg0_3.plateRings, arg0_3.ballPlate:GetChild(iter0_3))
	end

	arg0_3.btn_load = arg0_3.plate:Find("btn_load")
	arg0_3.ballSelectPanel = arg0_3.plate:Find("panel/layout")
	arg0_3.ballSelects = CustomIndexLayer.Clone2Full(arg0_3.ballSelectPanel, 3)
	arg0_3.ballSelectStatus = {
		0,
		0,
		0
	}
	arg0_3.lastSelectedBall = nil
	arg0_3.ballStoragePanel = arg0_3.storage:Find("house/layout")
	arg0_3.ballStorages = CustomIndexLayer.Clone2Full(arg0_3.ballStoragePanel, 6)
	arg0_3.screen_mask = arg0_3:findTF("mask")
	arg0_3.btn_next = arg0_3:findTF("Button")
	arg0_3.btn_next_text = arg0_3.btn_next:Find("Image")
	arg0_3.desc_dispense = arg0_3.dispenseView:Find("intro/Scroll View/Viewport/text")

	setText(arg0_3.desc_dispense, i18n("help_firework_produce"))

	arg0_3.btn_dispenseBG = arg0_3.dispenseView:Find("bg")
	arg0_3.btn_hammer = arg0_3.dispenseView:Find("container/Button")
	arg0_3.btn_hammer_text = arg0_3.btn_hammer:Find("text")
	arg0_3.slider_powder = arg0_3.dispenseView:Find("container/Slider/Fill Area"):GetComponent("Slider")
	arg0_3.slider_progress = arg0_3.dispenseView:Find("progress/Slider"):GetComponent("Slider")
	arg0_3.slider_progress_bg = arg0_3.dispenseView:Find("progress/Slider/Background/progressdi")
	arg0_3.slider_bubble = arg0_3.dispenseView:Find("container/Slider/Fill Area/Fill/handler/bubble")
	arg0_3.slider_bubble_text = arg0_3.slider_bubble:Find("text")
	arg0_3.progress_width = arg0_3.dispenseView:Find("progress/Slider/Handle Slide Area").rect.width
	arg0_3.progress_sub_mark_1 = arg0_3.dispenseView:Find("progress/Slider/Handle Slide Area/submark1")
	arg0_3.progress_sub_mark_2 = arg0_3.dispenseView:Find("progress/Slider/Handle Slide Area/submark2")
	arg0_3.progress_dis = {}

	for iter1_3 = 0, arg0_3.slider_progress_bg.childCount - 1 do
		table.insert(arg0_3.progress_dis, arg0_3.slider_progress_bg:GetChild(iter1_3))
	end

	arg0_3.result_digits = {}

	pg.PoolMgr.GetInstance():GetPrefab("ui/light01", "", true, function(arg0_4)
		tf(arg0_4):SetParent(arg0_3.dispenseView, false)
		arg0_4:SetActive(false)

		arg0_3.effect_light = arg0_4
	end)

	arg0_3.result_bg = arg0_3.resultWindow:Find("bg")
	arg0_3.result_desc = arg0_3.resultWindow:Find("window/Text")

	setText(arg0_3.result_desc, i18n("result_firework_produce"))

	arg0_3.btn_result_confirm = arg0_3.resultWindow:Find("window/button")
	arg0_3.result_pingjia = arg0_3.resultWindow:Find("window/pingjia"):GetComponent("Image")
	arg0_3.flagStart = false
	arg0_3.flagDispense = false
	arg0_3.progressDispense = 0
end

function var0_0.SetSprite(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetComponent("Image")

	arg0_5:SetImageSprite(var0_5, arg2_5)
end

function var0_0.SetImageSprite(arg0_6, arg1_6, arg2_6)
	pg.PoolMgr.GetInstance():GetSprite("ui/fireworkfactoryui_atlas", arg2_6, false, function(arg0_7)
		arg1_6.sprite = arg0_7
	end)
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.btn_back, function()
		if arg0_8.flagDispense then
			arg0_8:ExitDispenseView()
		elseif arg0_8:CheckpowderDispensed() and arg0_8.flagStart then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tips_firework_exit"),
				onYes = function()
					arg0_8:emit(var0_0.ON_BACK_PRESSED)
				end
			})
		else
			arg0_8:emit(var0_0.ON_BACK)
		end
	end)
	onButton(arg0_8, arg0_8.btn_dispenseBG, function()
		arg0_8:ExitDispenseView()
	end)
	onButton(arg0_8, arg0_8.btn_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2022_firework.tip
		})
	end)
	onButton(arg0_8, arg0_8.btn_next, function()
		if not arg0_8.flagStart then
			arg0_8.flagStart = true

			arg0_8:UpdateNextBtn()
		elseif arg0_8:CheckballLoaded() then
			arg0_8:EnterDispenseView()
		end
	end)
	onButton(arg0_8, arg0_8.btn_hammer, function()
		local var0_14 = arg0_8.progressDispense

		if var0_14 == 0 then
			arg0_8:ResetHammerAnim()
			arg0_8:FindNextPowderProgress()
			arg0_8:UpdateContainer()
		elseif var0_14 == 1 then
			arg0_8.result_digits[1] = arg0_8.slider_powder.value * 100

			arg0_8:FindandStopProgress()
			arg0_8:UpdateContainer()
		elseif var0_14 == 2 then
			arg0_8.result_digits[2] = arg0_8.slider_powder.value * 100

			arg0_8:FindandStopProgress()
			arg0_8:UpdateContainer()
		elseif var0_14 == 3 then
			arg0_8.result_digits[3] = arg0_8.slider_powder.value * 100

			arg0_8:FindandStopProgress()
			arg0_8:UpdateContainer()
		end
	end)
	onButton(arg0_8, arg0_8.btn_result_confirm, function()
		arg0_8:ShowResult()
	end)
	onButton(arg0_8, arg0_8.result_bg, function()
		arg0_8:ShowResult()
	end)

	for iter0_8 = 1, #arg0_8.ballStorages do
		local var0_8 = arg0_8.ballStorages[iter0_8]

		arg0_8:UpdateBall(var0_8, iter0_8)
		onButton(arg0_8, var0_8:Find("mask"), function()
			if not arg0_8.lastSelectedBall or arg0_8.lastSelectedBall <= 0 then
				return
			end

			arg0_8.ballSelectStatus[arg0_8.lastSelectedBall] = iter0_8

			arg0_8:UpdateRing(arg0_8.lastSelectedBall, iter0_8)
			arg0_8:UpdateBall(arg0_8.ballSelects[arg0_8.lastSelectedBall]:Find("ball"), iter0_8)
			arg0_8:UdpateSelectedBall(arg0_8.lastSelectedBall + 1)
			arg0_8:UpdateNextBtn()
		end)
	end

	for iter1_8 = 1, #arg0_8.ballSelects do
		local var1_8 = arg0_8.ballSelects[iter1_8]

		arg0_8:UpdateBall(var1_8:Find("ball"), 0)
		arg0_8:UpdateRing(iter1_8, 0)
		onButton(arg0_8, var1_8:Find("mask"), function()
			arg0_8.ballSelectStatus[iter1_8] = 0

			arg0_8:UpdateBall(arg0_8.ballSelects[iter1_8]:Find("ball"), 0)
			arg0_8:UpdateRing(iter1_8, 0)
			arg0_8:UdpateSelectedBall(iter1_8)
			arg0_8:UpdateNextBtn()
		end)
	end

	arg0_8:ResetView()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8.top, {
		groupName = LayerWeightConst.GROUP_FIREWORK_PRODUCE
	})

	local var2_8 = arg0_8:GetMGData():GetSimpleValue("score_reference")
	local var3_8 = {}

	var3_8[1] = 0

	for iter2_8, iter3_8 in ipairs(var2_8) do
		var3_8[#var2_8 - iter2_8 + 2] = iter3_8[1]
		var3_8[#var2_8 + iter2_8 + 1] = iter3_8[2]
	end

	var3_8[#var3_8] = 300

	for iter4_8 = 1, #var3_8 - 1 do
		local var4_8 = var3_8[iter4_8] / 300
		local var5_8 = var3_8[iter4_8 + 1] / 300

		arg0_8.progress_dis[iter4_8].anchorMin = Vector2(var4_8, 0)
		arg0_8.progress_dis[iter4_8].anchorMax = Vector2(var5_8, 1)
		arg0_8.progress_dis[iter4_8].sizeDelta = Vector2.zero
	end
end

function var0_0.UpdateNextBtn(arg0_19)
	if not arg0_19.flagStart then
		local var0_19 = "dispense_ready"
		local var1_19 = arg0_19:GetMGData():GetRuntimeData("elements")

		if var1_19 and #var1_19 > 3 and var1_19[4] == SummerFeastScene.GetCurrentDay() then
			var0_19 = "dispense_retry"
		end

		arg0_19:SetSprite(arg0_19.btn_next_text, var0_19)
	else
		arg0_19:SetSprite(arg0_19.btn_next_text, "dispense_confirm")
	end

	setActive(arg0_19.screen_mask, not arg0_19.flagStart)

	local var2_19 = not arg0_19.flagStart or arg0_19:CheckballLoaded()

	setButtonEnabled(arg0_19.btn_next, var2_19)
end

function var0_0.UpdateDispenseBtn(arg0_20)
	local var0_20 = arg0_20:CheckpowderDispensed()

	arg0_20:SetImageSprite(arg0_20.btn_load_img, var0_20 and "btn_loadcompleted" or "btn_load")
	arg0_20:SetSprite(arg0_20.btn_load_text, var0_20 and "load_completed" or "load_ready")
	setButtonEnabled(arg0_20.btn_load, not var0_20)
end

local var5_0 = {
	"start",
	"first_time",
	"second_time",
	"third_time",
	"finish_time"
}

function var0_0.FindandStopProgress(arg0_21)
	arg0_21:StopHammerAnim()
	setButtonEnabled(arg0_21.btn_hammer, false)
	setButtonEnabled(arg0_21.btn_dispenseBG, false)
	setText(arg0_21.slider_bubble_text, math.ceil(arg0_21.result_digits[#arg0_21.result_digits]) .. "%")
	setActive(arg0_21.slider_bubble, true)
	setActive(arg0_21.effect_light, true)

	arg0_21.progressDispense = #arg0_21.result_digits >= 3 and 4 or 0

	local var0_21 = 0

	for iter0_21 = 1, 3 do
		local var1_21 = arg0_21.result_digits[iter0_21]

		if var1_21 then
			var0_21 = var0_21 + var1_21
		end
	end

	local var2_21 = 0

	for iter1_21 = 1, #arg0_21.result_digits - 1 do
		local var3_21 = arg0_21.result_digits[iter1_21]

		if var3_21 then
			var2_21 = var2_21 + var3_21

			if iter1_21 == 1 then
				setActive(arg0_21.progress_sub_mark_1, true)

				local var4_21 = Vector2(arg0_21.progress_width * var2_21 / 300, 27)

				arg0_21.progress_sub_mark_1.anchoredPosition = var4_21
			elseif iter1_21 == 2 then
				setActive(arg0_21.progress_sub_mark_2, true)

				local var5_21 = Vector2(arg0_21.progress_width * var2_21 / 300, 27)

				arg0_21.progress_sub_mark_2.anchoredPosition = var5_21
			end
		end
	end

	local var6_21 = arg0_21.slider_bubble.transform.position
	local var7_21 = arg0_21.slider_progress.transform.position
	local var8_21 = arg0_21.slider_progress.value

	arg0_21.progressAnim = LeanTween.value(arg0_21.slider_progress.gameObject, 0, 1, 1.5):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_22)
		arg0_21.slider_progress.value = var1_0.Lerp(var8_21, var0_21 / 300, arg0_22)

		if arg0_21.effect_light then
			arg0_21.effect_light.transform.position = Vector3.Lerp(var6_21, var7_21, arg0_22 * 3) - Vector3(0, 0, 2)

			if arg0_22 * 3 > 1 then
				setActive(arg0_21.effect_light, false)
			end
		end
	end)):setOnComplete(System.Action(function()
		setButtonEnabled(arg0_21.btn_hammer, true)
		setButtonEnabled(arg0_21.btn_dispenseBG, true)

		if arg0_21.progressDispense > 3 then
			arg0_21:FindNextPowderProgress()
		end
	end))
end

function var0_0.FindNextPowderProgress(arg0_24)
	arg0_24.progressDispense = #arg0_24.result_digits + 1

	if arg0_24.progressDispense > 3 then
		arg0_24:StopHammerAnim()
		setButtonEnabled(arg0_24.btn_hammer, false)
		arg0_24:ShowResultWindow()
	end
end

function var0_0.ShowResultWindow(arg0_25)
	if #arg0_25.result_digits < 3 then
		return
	end

	setActive(arg0_25.resultWindow, true)

	local var0_25 = arg0_25:GetMGData():GetSimpleValue("score_reference")
	local var1_25 = 0

	for iter0_25 = 1, 3 do
		var1_25 = var1_25 + arg0_25.result_digits[iter0_25]
	end

	local var2_25 = 4

	for iter1_25, iter2_25 in ipairs(var0_25) do
		if var1_25 >= iter2_25[1] and var1_25 <= iter2_25[2] then
			var2_25 = iter1_25

			break
		end
	end

	if var2_25 <= 0 then
		return
	end

	arg0_25:SetImageSprite(arg0_25.result_pingjia, var4_0[var2_25])
end

function var0_0.ShowResult(arg0_26)
	if arg0_26:GetMGHubData().count <= 0 then
		arg0_26:AfterResult()
	else
		arg0_26:GetReward()
	end

	setActive(arg0_26.resultWindow, false)
end

function var0_0.OnGetAwardDone(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetMGHubData()
	local var1_27 = var0_27.ultimate == 0 and var0_27.usedtime >= var0_27:getConfig("reward_need")

	if arg1_27.cmd == MiniGameOPCommand.CMD_COMPLETE and var1_27 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_27.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	elseif arg1_27.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		arg0_27:AfterResult()
	else
		arg0_27:AfterResult()
	end
end

function var0_0.AfterResult(arg0_28)
	local var0_28 = SummerFeastScene.GetCurrentDay()
	local var1_28 = Clone(arg0_28.ballSelectStatus)

	table.insert(var1_28, var0_28)
	arg0_28:StoreDataToServer(var1_28)
	onNextTick(function()
		arg0_28:emit(var0_0.ON_BACK)
	end)
end

function var0_0.reset(arg0_30)
	arg0_30:ExitDispenseView()

	arg0_30.flagStart = false
	arg0_30.flagDispense = false
	arg0_30.progressDispense = 0
	arg0_30.result_digits = {}

	arg0_30:ResetView()
	arg0_30:UpdateNextBtn()
end

function var0_0.GetReward(arg0_31)
	if #arg0_31.result_digits < 3 then
		return
	end

	local var0_31 = arg0_31:GetMGData():GetSimpleValue("score_reference")
	local var1_31 = 0

	for iter0_31 = 1, 3 do
		var1_31 = var1_31 + arg0_31.result_digits[iter0_31]
	end

	local var2_31 = 4

	for iter1_31, iter2_31 in ipairs(var0_31) do
		if var1_31 >= iter2_31[1] and var1_31 <= iter2_31[2] then
			var2_31 = iter1_31

			break
		end
	end

	if var2_31 <= 0 then
		return
	end

	arg0_31:SendSuccess(var2_31)
end

function var0_0.ResetHammerAnim(arg0_32)
	if arg0_32.hammerAnim then
		arg0_32:StopHammerAnim()
	end

	setActive(arg0_32.slider_bubble, false)

	local var0_32 = (arg0_32:GetMGData():GetSimpleValue("roundTime") or var2_0) / 100

	arg0_32.hammerAnim = LeanTween.value(arg0_32.slider_powder.gameObject, 0, 1, var0_32 * 2):setEase(LeanTweenType.linear):setLoopPingPong():setOnUpdate(System.Action_float(function(arg0_33)
		arg0_32.slider_powder.value = arg0_33
	end))
end

function var0_0.StopHammerAnim(arg0_34)
	if not arg0_34.hammerAnim then
		return
	end

	LeanTween.cancel(arg0_34.hammerAnim.uniqueId)

	arg0_34.hammerAnim = nil
end

function var0_0.UpdateContainer(arg0_35)
	arg0_35:SetSprite(arg0_35.btn_hammer_text, var5_0[arg0_35.progressDispense + 1])

	local var0_35 = 0
	local var1_35 = true

	for iter0_35 = 1, 3 do
		local var2_35 = arg0_35.result_digits[iter0_35]

		var1_35 = var1_35 and var2_35 ~= nil

		if var2_35 then
			var0_35 = var0_35 + var2_35
		end
	end

	arg0_35.slider_progress.value = var0_35 / 300
end

function var0_0.StopProgressAnim(arg0_36)
	if not arg0_36.progressAnim then
		return
	end

	LeanTween.cancel(arg0_36.progressAnim.uniqueId)

	arg0_36.progressAnim = nil
end

function var0_0.CheckballLoaded(arg0_37)
	return _.all(arg0_37.ballSelectStatus, function(arg0_38)
		return arg0_38 > 0
	end)
end

function var0_0.CheckpowderDispensed(arg0_39)
	return #arg0_39.result_digits >= 3
end

function var0_0.UpdateBall(arg0_40, arg1_40, arg2_40)
	setActive(arg1_40, arg2_40 > 0)

	if arg2_40 <= 0 then
		return
	end

	arg1_40:GetComponent("Image").color = arg0_40.TransformColor(var3_0[arg2_40].color)

	arg0_40:SetSprite(arg1_40:Find("symbol"), var3_0[arg2_40].name)
end

function var0_0.UpdateRing(arg0_41, arg1_41, arg2_41)
	if arg1_41 <= 0 or arg1_41 > 3 then
		return
	end

	local var0_41 = arg0_41.plateRings[arg1_41]

	setActive(var0_41, arg2_41 > 0)

	if arg2_41 <= 0 then
		return
	end

	var0_41:GetComponent("Image").color = arg0_41.TransformColor(var3_0[arg2_41].color)
end

function var0_0.ResetView(arg0_42)
	_.each(arg0_42.plateRings, function(arg0_43)
		setActive(arg0_43, false)
	end)
	_.each(arg0_42.ballSelects, function(arg0_44)
		setActive(arg0_44:Find("ball"), false)
		setActive(arg0_44:Find("selected"), false)
	end)

	local var0_42 = arg0_42:GetMGHubData()

	setText(arg0_42.timesText, var0_42.count)

	local var1_42 = arg0_42:GetMGData():GetRuntimeData("elements")

	if var1_42 and #var1_42 > 3 and var1_42[4] == SummerFeastScene.GetCurrentDay() then
		for iter0_42 = 1, 3 do
			local var2_42 = var1_42[iter0_42]

			arg0_42.ballSelectStatus[iter0_42] = var2_42

			if var2_42 > 0 then
				arg0_42:UpdateRing(iter0_42, var2_42)

				local var3_42 = arg0_42.ballSelects[iter0_42]:Find("ball")

				arg0_42:UpdateBall(var3_42, var2_42)
			end
		end
	end

	arg0_42:UdpateSelectedBall(1)
	arg0_42:UpdateNextBtn()
	setActive(arg0_42.slider_bubble, false)
	setActive(arg0_42.progress_sub_mark_1, false)
	setActive(arg0_42.progress_sub_mark_2, false)
end

function var0_0.UdpateSelectedBall(arg0_45, arg1_45)
	if arg1_45 <= 0 or arg1_45 > 3 then
		return
	end

	if arg0_45.lastSelectedBall then
		if arg0_45.lastSelectedBall == arg1_45 then
			return
		end

		setActive(arg0_45.ballSelects[arg0_45.lastSelectedBall]:Find("selected"), false)
	end

	setActive(arg0_45.ballSelects[arg1_45]:Find("selected"), true)

	arg0_45.lastSelectedBall = arg1_45
end

function var0_0.EnterDispenseView(arg0_46)
	setActive(arg0_46.dispenseView, true)

	arg0_46.flagDispense = true
	arg0_46.progressDispense = #arg0_46.result_digits >= 3 and 4 or 0

	arg0_46:UpdateContainer()

	arg0_46.slider_powder.value = 0
end

function var0_0.ExitDispenseView(arg0_47)
	if not arg0_47.flagDispense then
		return
	end

	arg0_47:UpdateNextBtn()
	arg0_47:StopHammerAnim()
	arg0_47:StopProgressAnim()

	arg0_47.progressDispense = 0

	setActive(arg0_47.dispenseView, false)
	setButtonEnabled(arg0_47.btn_hammer, true)

	local var0_47 = arg0_47:GetMGHubData()

	setText(arg0_47.timesText, var0_47.count)
	setActive(arg0_47.slider_bubble, false)

	if arg0_47.effect_light then
		setActive(arg0_47.effect_light, false)
	end

	arg0_47.flagDispense = false
end

function var0_0.willExit(arg0_48)
	arg0_48:ExitDispenseView()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_48.top, arg0_48._tf)

	if arg0_48.effect_light then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/light01", "", arg0_48.effect_light)
	end

	pg.PoolMgr.GetInstance():DestroyPrefab("ui/light01", "")
	pg.PoolMgr.GetInstance():DestroySprite("ui/fireworkfactoryui_atlas")

	if arg0_48.OPTimer then
		arg0_48.OPTimer:Stop()

		arg0_48.OPTimer = nil
	end
end

return var0_0
