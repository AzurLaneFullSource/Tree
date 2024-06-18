local var0_0 = class("SenrankaguraTrainScene", import("..base.BaseUI"))

var0_0.optionsPath = {
	"top/btn_home"
}
var0_0.ACT_ID = ActivityConst.SENRANKAGURA_TRAIN_ACT_ID
var0_0.SCROLL_OFFSET = 4.13
var0_0.DIALOG_TIME = 0.5
var0_0.DEFAULT_DIALOG_TIME = 4

function var0_0.getUIName(arg0_1)
	return "SenrankaguraTrainUI"
end

function var0_0.init(arg0_2)
	arg0_2:InitData()
	arg0_2:InitTF()
end

function var0_0.InitTF(arg0_3)
	arg0_3.top = arg0_3:findTF("top")
	arg0_3.buttonAward = arg0_3:findTF("btn_award", arg0_3.top)
	arg0_3.buttonBack = arg0_3:findTF("btn_back", arg0_3.top)
	arg0_3.buttonHelp = arg0_3:findTF("btn_help", arg0_3.top)
	arg0_3.ptText = arg0_3:findTF("pt/Text", arg0_3.top)
	arg0_3.main = arg0_3:findTF("main")
	arg0_3.tachie = arg0_3:findTF("group_left/group/tachie", arg0_3.main)
	arg0_3.dialog = arg0_3:findTF("group_left/group/dialog", arg0_3.main)
	arg0_3.attrGroup = arg0_3:findTF("attr", arg0_3.main)
	arg0_3.scroll = arg0_3:findTF("scroll", arg0_3.main)
	arg0_3.window = arg0_3:findTF("window")
	arg0_3.levelWindow = arg0_3:findTF("level_window", arg0_3.window)
	arg0_3.levelPtText = arg0_3:findTF("pt/Text", arg0_3.levelWindow)
	arg0_3.levelBg = arg0_3:findTF("bg", arg0_3.levelWindow)
	arg0_3.levelWindowConfirmButton = arg0_3:findTF("btn_confirm", arg0_3.levelBg)
	arg0_3.levelWindowCancelButton = arg0_3:findTF("btn_cancel", arg0_3.levelBg)
	arg0_3.levelTip = arg0_3:findTF("tip", arg0_3.levelBg)
	arg0_3.levelAttrGroup = arg0_3:findTF("attr", arg0_3.levelBg)
	arg0_3.awardWindow = arg0_3:findTF("award_window", arg0_3.window)
	arg0_3.awardContent = arg0_3:findTF("bg/mask/content", arg0_3.awardWindow)
	arg0_3.awardItem = arg0_3:findTF("bg/mask/item", arg0_3.awardWindow)
	arg0_3.showWindow = arg0_3:findTF("show_window", arg0_3.window)
	arg0_3.showSkipButton = arg0_3:findTF("bg/btn_skip", arg0_3.showWindow)
	arg0_3.spine = arg0_3:findTF("bg/spine", arg0_3.showWindow)
	arg0_3.testLevel = arg0_3:findTF("testlevel", arg0_3.top)
	arg0_3.testAward = arg0_3:findTF("testaward", arg0_3.top)
end

function var0_0.InitData(arg0_4)
	arg0_4.activity = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)
	arg0_4.ptCount = arg0_4.activity.data1
	arg0_4.attrLevel = arg0_4.activity.data1_list
	arg0_4.awardGotList = arg0_4.activity.data2_list
	arg0_4.ptDemand = pg.activity_event_pt_consume[1].target
	arg0_4.rewardList = pg.activity_event_pt_consume[1].reward_display
	arg0_4.showList = arg0_4.activity:getConfig("config_client").show_list
	arg0_4.wordsKey = arg0_4.activity:getConfig("config_client").words_key
	arg0_4.standAnim = arg0_4.activity:getConfig("config_client").stand_anim
end

function var0_0.InitButton(arg0_5)
	for iter0_5 = 1, arg0_5.attrGroup.childCount do
		onButton(arg0_5, arg0_5.attrGroup:GetChild(iter0_5 - 1), function()
			if arg0_5.attrLevel[iter0_5] > 1 then
				return
			end

			arg0_5.currentAttr = iter0_5

			setActive(arg0_5.levelWindow, true)
			eachChild(arg0_5.levelAttrGroup, function(arg0_7)
				setActive(arg0_7, false)
			end)
			setActive(arg0_5.levelAttrGroup:GetChild(iter0_5 - 1), true)

			local var0_6 = arg0_5.attrLevel[iter0_5] + 1
			local var1_6 = arg0_5.ptDemand[iter0_5][var0_6]

			setText(arg0_5.levelTip, i18n("senran_pt_consume_tip", var1_6, var0_6))
		end, SFX_PANEL)
	end

	onButton(arg0_5, arg0_5.levelWindowConfirmButton, function()
		local var0_8 = arg0_5.currentAttr
		local var1_8 = arg0_5.attrLevel[var0_8]
		local var2_8 = arg0_5.ptDemand[var0_8][var1_8 + 1]

		if var2_8 > arg0_5.ptCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("senran_pt_not_enough"))
		else
			arg0_5:emit(SenrankaguraTrainMediator.LEVEL_UP, {
				cmd = 2,
				id = var0_0.ACT_ID,
				arg1 = var0_8,
				cost = var2_8,
				arg_list = {
					arg0_5.lvTotal + 1
				}
			})
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.levelWindowCancelButton, function()
		setActive(arg0_5.levelWindow, false)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.buttonBack, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.buttonHelp, function()
		local var0_11 = i18n("senran_pt_help")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_11
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.buttonAward, function()
		local var0_12 = 0

		for iter0_12 = 1, #arg0_5.rewardList do
			if not table.contains(arg0_5.awardGotList, iter0_12) then
				var0_12 = iter0_12 - 1

				break
			end
		end

		if var0_12 ~= 0 then
			scrollTo(arg0_5.awardContent, nil, 1 - var0_12 / (#arg0_5.rewardList - var0_0.SCROLL_OFFSET))
		end

		setActive(arg0_5.awardWindow, true)
	end, SFX_PANEL)
	onButton(arg0_5, findTF(arg0_5.awardWindow, "black"), function()
		setActive(arg0_5.awardWindow, false)
	end, SFX_CANCEL)
	onButton(arg0_5, findTF(arg0_5.levelWindow, "black"), function()
		setActive(arg0_5.levelWindow, false)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.showSkipButton, function()
		setActive(arg0_5.showWindow, false)
		arg0_5:GetAward(arg0_5.awardList)
	end, SFX_CANCEL)

	for iter1_5 = 1, arg0_5.tachie.childCount do
		local var0_5 = arg0_5.tachie:GetChild(iter1_5 - 1)

		onButton(arg0_5, var0_5, function()
			if not arg0_5.tachieClickable then
				return
			end

			local var0_16 = math.random(2, 4)

			arg0_5:ShowDialog(var0_16, function()
				arg0_5.tachieClickable = false
			end)
		end, SFX_PANEL)
		setActive(var0_5, false)

		if PLATFORM_CODE ~= PLATFORM_CH then
			local var1_5 = findTF(var0_5, "Image")

			if var1_5 then
				setActive(var1_5, false)
			end
		end
	end
end

function var0_0.didEnter(arg0_18)
	arg0_18:InitButton()

	arg0_18.taskList = UIItemList.New(arg0_18.awardContent, arg0_18.awardItem)

	arg0_18.taskList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			arg0_18:UpdateTask(arg1_19, arg2_19)
		end
	end)

	local var0_18 = math.random(arg0_18.tachie.childCount)

	setActive(arg0_18.tachie:GetChild(var0_18 - 1), true)

	arg0_18.wordsGroup = pg.gametip[arg0_18.wordsKey[var0_18]].tip

	local var1_18 = {}

	for iter0_18 = 1, #arg0_18.standAnim do
		table.insert(var1_18, iter0_18)
	end

	shuffle(var1_18)

	for iter1_18 = 1, arg0_18.scroll.childCount do
		PoolMgr.GetInstance():GetSpineChar(arg0_18.standAnim[var1_18[iter1_18]], false, function(arg0_20)
			arg0_20.transform.localScale = Vector3.one

			arg0_20.transform:SetParent(arg0_18.scroll:GetChild(iter1_18 - 1), false)
			arg0_20:GetComponent(typeof(SpineAnimUI)):SetAction("stand2", 0)
		end)
	end

	arg0_18:ShowDialog(1, function()
		arg0_18.tachieClickable = false
	end)
	arg0_18:UpdateFlush()
end

function var0_0.UpdateTask(arg0_22, arg1_22, arg2_22)
	arg1_22 = arg1_22 + 1

	local var0_22 = arg0_22:findTF("IconTpl", arg2_22)

	setText(findTF(arg2_22, "title"), "PHASE" .. arg1_22)

	local var1_22 = arg0_22.rewardList[arg1_22]
	local var2_22 = {
		type = var1_22[1],
		id = var1_22[2],
		count = var1_22[3]
	}

	updateDrop(var0_22, var2_22)
	onButton(arg0_22, var0_22, function()
		arg0_22:emit(BaseUI.ON_DROP, var2_22)
	end, SFX_PANEL)
	setText(arg0_22:findTF("progress", arg2_22), i18n("senran_pt_rank", arg1_22))

	local var3_22 = table.contains(arg0_22.awardGotList, arg1_22)

	setActive(arg0_22:findTF("mask", arg2_22), var3_22)
end

function var0_0.ShowDialog(arg0_24, arg1_24, arg2_24)
	arg0_24.LTList = {}

	if arg2_24 then
		arg2_24()
	end

	local var0_24 = "event:/cv/" .. arg0_24.wordsGroup[arg1_24][1]
	local var1_24 = arg0_24.wordsGroup[arg1_24][2]

	setText(findTF(arg0_24.dialog, "Text"), var1_24)
	setLocalScale(arg0_24.dialog, {
		z = 0,
		x = 0,
		y = 0
	})
	table.insert(arg0_24.LTList, LeanTween.scale(arg0_24.dialog, Vector3.New(1, 1, 1), var0_0.DIALOG_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_24, function(arg0_25)
		arg0_24.playSoundInfo = arg0_25

		local var0_25 = var0_0.DEFAULT_DIALOG_TIME

		if arg0_25 then
			var0_25 = arg0_25:GetLength() * 0.001 - var0_0.DIALOG_TIME
		end

		table.insert(arg0_24.LTList, LeanTween.delayedCall(go(arg0_24.dialog), var0_25, System.Action(function()
			arg0_24:HideDialog()
		end)).uniqueId)
	end)
end

function var0_0.HideDialog(arg0_27)
	table.insert(arg0_27.LTList, LeanTween.scale(arg0_27.dialog, Vector3.New(0, 0, 0), var0_0.DIALOG_TIME):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
		arg0_27.tachieClickable = true
	end)).uniqueId)
end

function var0_0.LevelUp(arg0_29, arg1_29)
	arg0_29.awardList = arg1_29

	setActive(arg0_29.levelWindow, false)
	setActive(arg0_29.showWindow, true)
	arg0_29:UpdateFlush()

	local var0_29 = arg0_29.showList[arg0_29.currentAttr][arg0_29.attrLevel[arg0_29.currentAttr]]

	arg0_29:SetAnim(arg0_29.spine, var0_29, function()
		setActive(arg0_29.showWindow, false)
		arg0_29:GetAward(arg1_29)
	end)
end

function var0_0.GetAward(arg0_31, arg1_31)
	arg0_31:emit(BaseUI.ON_ACHIEVE, arg1_31, function()
		arg0_31.awardList = nil

		arg0_31:ShowDialog(5, function()
			arg0_31.tachieClickable = false

			if arg0_31.playSoundInfo and arg0_31.playSoundInfo.channelPlayer ~= nil then
				pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0_31.playSoundInfo)
			end

			for iter0_33, iter1_33 in pairs(arg0_31.LTList) do
				LeanTween.cancel(iter1_33)
			end
		end)
	end)
	arg0_31:UpdateFlush()
end

function var0_0.UpdateFlush(arg0_34)
	arg0_34.activity = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)
	arg0_34.ptCount = arg0_34.activity.data1
	arg0_34.attrLevel = arg0_34.activity.data1_list
	arg0_34.awardGotList = arg0_34.activity.data2_list
	arg0_34.lvTotal = 0

	for iter0_34, iter1_34 in pairs(arg0_34.attrLevel) do
		arg0_34.lvTotal = arg0_34.lvTotal + iter1_34
	end

	setText(arg0_34.ptText, arg0_34.ptCount)
	setText(arg0_34.levelPtText, arg0_34.ptCount)

	local function var0_34(arg0_35, arg1_35)
		for iter0_35 = 1, arg0_35.childCount do
			local var0_35 = arg0_35:GetChild(iter0_35 - 1)

			eachChild(var0_35, function(arg0_36)
				setActive(arg0_36, false)
			end)

			local var1_35 = arg0_34.attrLevel[iter0_35]

			setActive(var0_35:GetChild(var1_35), true)

			if arg1_35 and var1_35 < 2 and arg0_34.ptDemand[iter0_35][var1_35 + 1] <= arg0_34.ptCount then
				setActive(findTF(var0_35, "red"), true)
			end
		end
	end

	var0_34(arg0_34.attrGroup, true)
	var0_34(arg0_34.levelAttrGroup, false)
	arg0_34.taskList:align(#arg0_34.rewardList)
end

function var0_0.SetAnim(arg0_37, arg1_37, arg2_37, arg3_37)
	local var0_37 = arg1_37:GetComponent(typeof(SpineAnimUI))

	var0_37:SetActionCallBack(nil)
	var0_37:SetAction(arg2_37, 0)
	var0_37:SetActionCallBack(function(arg0_38)
		if arg0_38 == "finish" then
			var0_37:SetActionCallBack(nil)

			if arg3_37 then
				arg3_37()
			end
		end
	end)
end

function var0_0.willExit(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.LTList) do
		LeanTween.cancel(iter1_39)
	end
end

function var0_0.IsShowRed()
	local var0_40 = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)
	local var1_40 = var0_40.data1_list
	local var2_40 = pg.activity_event_pt_consume[1].target
	local var3_40 = var0_40.data1

	for iter0_40, iter1_40 in pairs(var1_40) do
		if iter1_40 < 2 and var3_40 >= var2_40[iter0_40][iter1_40 + 1] then
			return true
		end
	end

	return false
end

return var0_0
