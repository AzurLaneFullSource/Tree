local var0_0 = class("MallSettleBox", import("view.base.BaseSubView"))

var0_0.SILDER_TIME = 2
var0_0.DIALOGUE_PROGRESS = 0.5
var0_0.DIALOGUE_INTERVAL_TIME = 0.5
var0_0.STAFF_CHANGE_INTERVAL = 0.2
var0_0.STAFF_BODY_CNT = 4
var0_0.STAFF_CLOTHES_CNT = 6
var0_0.STAFF_FACE_CNT = 5

function var0_0.getUIName(arg0_1)
	return "MallSettleBox"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2.uiSummaryText, i18n("mall_summary_btn"))
	setText(arg0_2._tf:Find("window/tip"), i18n("word_click_to_close"))
	setActive(arg0_2.uiDialogueTpl, false)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiSummaryBtn, function()
		arg0_3:emit(MallMediator.OPEN_SUMMARY_BOX)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	var0_0.super.Show(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)

	arg0_6.onHide = arg2_6
	arg0_6.level = arg1_6

	arg0_6:ShowAnim()
	setSlider(arg0_6.uiSliderTF, 0, 1, 0)

	arg0_6.isShowEvaluate = false

	arg0_6:managedTween(LeanTween.value, nil, go(arg0_6.uiSliderTF), 0, 1, var0_0.SILDER_TIME):setOnUpdate(System.Action_float(function(arg0_7)
		if not arg0_6.isShowEvaluate and arg0_7 > var0_0.DIALOGUE_PROGRESS then
			arg0_6.isShowEvaluate = true

			arg0_6:ChangeToEvaluate()
		end

		setSlider(arg0_6.uiSliderTF, 0, 1, arg0_7)
	end))
end

function var0_0.ShowAnim(arg0_8)
	setText(arg0_8.uiTitleText, i18n("mall_open_title"))
	setActive(arg0_8.uiAnimTF, true)
	setActive(arg0_8.uiDialogueTF, false)
	setActive(arg0_8.uiSummaryBtn, false)
	arg0_8:StartTimer()
end

function var0_0.ShowRandomShowStaff(arg0_9)
	local var0_9 = math.random(1, var0_0.STAFF_BODY_CNT)
	local var1_9 = math.random(1, var0_0.STAFF_CLOTHES_CNT)
	local var2_9 = math.random(1, var0_0.STAFF_FACE_CNT)

	GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", "body" .. var0_9, arg0_9.uiStaffTF:Find("body"))
	GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", "clothes" .. var1_9, arg0_9.uiStaffTF:Find("clothes"))
	GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", "face" .. var2_9, arg0_9.uiStaffTF:Find("face"))
end

function var0_0.StartTimer(arg0_10)
	arg0_10:StopTimer()

	arg0_10.timer = Timer.New(function()
		arg0_10:ShowRandomShowStaff()
	end, var0_0.STAFF_CHANGE_INTERVAL, -1)

	arg0_10.timer:Start()
	arg0_10.timer.func()
end

function var0_0.StopTimer(arg0_12)
	if arg0_12.timer then
		arg0_12.timer:Stop()

		arg0_12.timer = nil
	end
end

function var0_0.ChangeToEvaluate(arg0_13)
	if arg0_13.isInDialogue then
		return
	end

	arg0_13:StopTimer()
	setText(arg0_13.uiTitleText, i18n("mall_evaluate_title"))
	setActive(arg0_13.uiAnimTF, false)
	removeAllChildren(arg0_13.uiDialogueContentTF)
	setActive(arg0_13.uiDialogueTF, true)

	local var0_13 = {}
	local var1_13 = MallLevel.GetShowInfos(arg0_13.level)
	local var2_13 = pg.ship_skin_template[var1_13.skinId]
	local var3_13 = var2_13.name
	local var4_13 = "squareicon/" .. var2_13.prefab

	for iter0_13, iter1_13 in ipairs(var1_13.wordList) do
		table.insert(var0_13, function(arg0_14)
			local var0_14 = cloneTplTo(arg0_13.uiDialogueTpl, arg0_13.uiDialogueContentTF)

			setText(var0_14:Find("name/Text"), var3_13)
			setText(var0_14:Find("word/Text"), iter1_13)
			GetImageSpriteFromAtlasAsync(var4_13, "", var0_14:Find("icon"), true)
			scrollToBottom(arg0_13.uiDialogueTF)
			arg0_13:managedTween(LeanTween.delayedCall, function()
				arg0_14()
			end, var0_0.DIALOGUE_INTERVAL_TIME, nil)
		end)
	end

	arg0_13.isInDialogue = true

	seriesAsync(var0_13, function()
		arg0_13.isInDialogue = false

		setActive(arg0_13.uiSummaryBtn, true)
	end)
end

function var0_0.Hide(arg0_17)
	if arg0_17.timer then
		arg0_17:ChangeToEvaluate()

		return
	end

	if arg0_17.isInDialogue then
		return
	end

	var0_0.super.Hide(arg0_17)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_17._tf)
	arg0_17:StopTimer()
	arg0_17:cleanManagedTween()
	existCall(arg0_17.onHide)

	arg0_17.onHide = nil
end

function var0_0.OnDestroy(arg0_18)
	return
end

return var0_0
