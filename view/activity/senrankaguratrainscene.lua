local var0 = class("SenrankaguraTrainScene", import("..base.BaseUI"))

var0.optionsPath = {
	"top/btn_home"
}
var0.ACT_ID = ActivityConst.SENRANKAGURA_TRAIN_ACT_ID
var0.SCROLL_OFFSET = 4.13
var0.DIALOG_TIME = 0.5
var0.DEFAULT_DIALOG_TIME = 4

function var0.getUIName(arg0)
	return "SenrankaguraTrainUI"
end

function var0.init(arg0)
	arg0:InitData()
	arg0:InitTF()
end

function var0.InitTF(arg0)
	arg0.top = arg0:findTF("top")
	arg0.buttonAward = arg0:findTF("btn_award", arg0.top)
	arg0.buttonBack = arg0:findTF("btn_back", arg0.top)
	arg0.buttonHelp = arg0:findTF("btn_help", arg0.top)
	arg0.ptText = arg0:findTF("pt/Text", arg0.top)
	arg0.main = arg0:findTF("main")
	arg0.tachie = arg0:findTF("group_left/group/tachie", arg0.main)
	arg0.dialog = arg0:findTF("group_left/group/dialog", arg0.main)
	arg0.attrGroup = arg0:findTF("attr", arg0.main)
	arg0.scroll = arg0:findTF("scroll", arg0.main)
	arg0.window = arg0:findTF("window")
	arg0.levelWindow = arg0:findTF("level_window", arg0.window)
	arg0.levelPtText = arg0:findTF("pt/Text", arg0.levelWindow)
	arg0.levelBg = arg0:findTF("bg", arg0.levelWindow)
	arg0.levelWindowConfirmButton = arg0:findTF("btn_confirm", arg0.levelBg)
	arg0.levelWindowCancelButton = arg0:findTF("btn_cancel", arg0.levelBg)
	arg0.levelTip = arg0:findTF("tip", arg0.levelBg)
	arg0.levelAttrGroup = arg0:findTF("attr", arg0.levelBg)
	arg0.awardWindow = arg0:findTF("award_window", arg0.window)
	arg0.awardContent = arg0:findTF("bg/mask/content", arg0.awardWindow)
	arg0.awardItem = arg0:findTF("bg/mask/item", arg0.awardWindow)
	arg0.showWindow = arg0:findTF("show_window", arg0.window)
	arg0.showSkipButton = arg0:findTF("bg/btn_skip", arg0.showWindow)
	arg0.spine = arg0:findTF("bg/spine", arg0.showWindow)
	arg0.testLevel = arg0:findTF("testlevel", arg0.top)
	arg0.testAward = arg0:findTF("testaward", arg0.top)
end

function var0.InitData(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)
	arg0.ptCount = arg0.activity.data1
	arg0.attrLevel = arg0.activity.data1_list
	arg0.awardGotList = arg0.activity.data2_list
	arg0.ptDemand = pg.activity_event_pt_consume[1].target
	arg0.rewardList = pg.activity_event_pt_consume[1].reward_display
	arg0.showList = arg0.activity:getConfig("config_client").show_list
	arg0.wordsKey = arg0.activity:getConfig("config_client").words_key
	arg0.standAnim = arg0.activity:getConfig("config_client").stand_anim
end

function var0.InitButton(arg0)
	for iter0 = 1, arg0.attrGroup.childCount do
		onButton(arg0, arg0.attrGroup:GetChild(iter0 - 1), function()
			if arg0.attrLevel[iter0] > 1 then
				return
			end

			arg0.currentAttr = iter0

			setActive(arg0.levelWindow, true)
			eachChild(arg0.levelAttrGroup, function(arg0)
				setActive(arg0, false)
			end)
			setActive(arg0.levelAttrGroup:GetChild(iter0 - 1), true)

			local var0 = arg0.attrLevel[iter0] + 1
			local var1 = arg0.ptDemand[iter0][var0]

			setText(arg0.levelTip, i18n("senran_pt_consume_tip", var1, var0))
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.levelWindowConfirmButton, function()
		local var0 = arg0.currentAttr
		local var1 = arg0.attrLevel[var0]
		local var2 = arg0.ptDemand[var0][var1 + 1]

		if var2 > arg0.ptCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("senran_pt_not_enough"))
		else
			arg0:emit(SenrankaguraTrainMediator.LEVEL_UP, {
				cmd = 2,
				id = var0.ACT_ID,
				arg1 = var0,
				cost = var2,
				arg_list = {
					arg0.lvTotal + 1
				}
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.levelWindowCancelButton, function()
		setActive(arg0.levelWindow, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.buttonBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.buttonHelp, function()
		local var0 = i18n("senran_pt_help")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonAward, function()
		local var0 = 0

		for iter0 = 1, #arg0.rewardList do
			if not table.contains(arg0.awardGotList, iter0) then
				var0 = iter0 - 1

				break
			end
		end

		if var0 ~= 0 then
			scrollTo(arg0.awardContent, nil, 1 - var0 / (#arg0.rewardList - var0.SCROLL_OFFSET))
		end

		setActive(arg0.awardWindow, true)
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.awardWindow, "black"), function()
		setActive(arg0.awardWindow, false)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.levelWindow, "black"), function()
		setActive(arg0.levelWindow, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.showSkipButton, function()
		setActive(arg0.showWindow, false)
		arg0:GetAward(arg0.awardList)
	end, SFX_CANCEL)

	for iter1 = 1, arg0.tachie.childCount do
		local var0 = arg0.tachie:GetChild(iter1 - 1)

		onButton(arg0, var0, function()
			if not arg0.tachieClickable then
				return
			end

			local var0 = math.random(2, 4)

			arg0:ShowDialog(var0, function()
				arg0.tachieClickable = false
			end)
		end, SFX_PANEL)
		setActive(var0, false)

		if PLATFORM_CODE ~= PLATFORM_CH then
			local var1 = findTF(var0, "Image")

			if var1 then
				setActive(var1, false)
			end
		end
	end
end

function var0.didEnter(arg0)
	arg0:InitButton()

	arg0.taskList = UIItemList.New(arg0.awardContent, arg0.awardItem)

	arg0.taskList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTask(arg1, arg2)
		end
	end)

	local var0 = math.random(arg0.tachie.childCount)

	setActive(arg0.tachie:GetChild(var0 - 1), true)

	arg0.wordsGroup = pg.gametip[arg0.wordsKey[var0]].tip

	local var1 = {}

	for iter0 = 1, #arg0.standAnim do
		table.insert(var1, iter0)
	end

	shuffle(var1)

	for iter1 = 1, arg0.scroll.childCount do
		PoolMgr.GetInstance():GetSpineChar(arg0.standAnim[var1[iter1]], false, function(arg0)
			arg0.transform.localScale = Vector3.one

			arg0.transform:SetParent(arg0.scroll:GetChild(iter1 - 1), false)
			arg0:GetComponent(typeof(SpineAnimUI)):SetAction("stand2", 0)
		end)
	end

	arg0:ShowDialog(1, function()
		arg0.tachieClickable = false
	end)
	arg0:UpdateFlush()
end

function var0.UpdateTask(arg0, arg1, arg2)
	arg1 = arg1 + 1

	local var0 = arg0:findTF("IconTpl", arg2)

	setText(findTF(arg2, "title"), "PHASE" .. arg1)

	local var1 = arg0.rewardList[arg1]
	local var2 = {
		type = var1[1],
		id = var1[2],
		count = var1[3]
	}

	updateDrop(var0, var2)
	onButton(arg0, var0, function()
		arg0:emit(BaseUI.ON_DROP, var2)
	end, SFX_PANEL)
	setText(arg0:findTF("progress", arg2), i18n("senran_pt_rank", arg1))

	local var3 = table.contains(arg0.awardGotList, arg1)

	setActive(arg0:findTF("mask", arg2), var3)
end

function var0.ShowDialog(arg0, arg1, arg2)
	arg0.LTList = {}

	if arg2 then
		arg2()
	end

	local var0 = "event:/cv/" .. arg0.wordsGroup[arg1][1]
	local var1 = arg0.wordsGroup[arg1][2]

	setText(findTF(arg0.dialog, "Text"), var1)
	setLocalScale(arg0.dialog, {
		z = 0,
		x = 0,
		y = 0
	})
	table.insert(arg0.LTList, LeanTween.scale(arg0.dialog, Vector3.New(1, 1, 1), var0.DIALOG_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0, function(arg0)
		arg0.playSoundInfo = arg0

		local var0 = var0.DEFAULT_DIALOG_TIME

		if arg0 then
			var0 = arg0:GetLength() * 0.001 - var0.DIALOG_TIME
		end

		table.insert(arg0.LTList, LeanTween.delayedCall(go(arg0.dialog), var0, System.Action(function()
			arg0:HideDialog()
		end)).uniqueId)
	end)
end

function var0.HideDialog(arg0)
	table.insert(arg0.LTList, LeanTween.scale(arg0.dialog, Vector3.New(0, 0, 0), var0.DIALOG_TIME):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
		arg0.tachieClickable = true
	end)).uniqueId)
end

function var0.LevelUp(arg0, arg1)
	arg0.awardList = arg1

	setActive(arg0.levelWindow, false)
	setActive(arg0.showWindow, true)
	arg0:UpdateFlush()

	local var0 = arg0.showList[arg0.currentAttr][arg0.attrLevel[arg0.currentAttr]]

	arg0:SetAnim(arg0.spine, var0, function()
		setActive(arg0.showWindow, false)
		arg0:GetAward(arg1)
	end)
end

function var0.GetAward(arg0, arg1)
	arg0:emit(BaseUI.ON_ACHIEVE, arg1, function()
		arg0.awardList = nil

		arg0:ShowDialog(5, function()
			arg0.tachieClickable = false

			if arg0.playSoundInfo and arg0.playSoundInfo.channelPlayer ~= nil then
				pg.CriMgr.GetInstance():StopPlaybackInfoForce(arg0.playSoundInfo)
			end

			for iter0, iter1 in pairs(arg0.LTList) do
				LeanTween.cancel(iter1)
			end
		end)
	end)
	arg0:UpdateFlush()
end

function var0.UpdateFlush(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)
	arg0.ptCount = arg0.activity.data1
	arg0.attrLevel = arg0.activity.data1_list
	arg0.awardGotList = arg0.activity.data2_list
	arg0.lvTotal = 0

	for iter0, iter1 in pairs(arg0.attrLevel) do
		arg0.lvTotal = arg0.lvTotal + iter1
	end

	setText(arg0.ptText, arg0.ptCount)
	setText(arg0.levelPtText, arg0.ptCount)

	local function var0(arg0, arg1)
		for iter0 = 1, arg0.childCount do
			local var0 = arg0:GetChild(iter0 - 1)

			eachChild(var0, function(arg0)
				setActive(arg0, false)
			end)

			local var1 = arg0.attrLevel[iter0]

			setActive(var0:GetChild(var1), true)

			if arg1 and var1 < 2 and arg0.ptDemand[iter0][var1 + 1] <= arg0.ptCount then
				setActive(findTF(var0, "red"), true)
			end
		end
	end

	var0(arg0.attrGroup, true)
	var0(arg0.levelAttrGroup, false)
	arg0.taskList:align(#arg0.rewardList)
end

function var0.SetAnim(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetComponent(typeof(SpineAnimUI))

	var0:SetActionCallBack(nil)
	var0:SetAction(arg2, 0)
	var0:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			var0:SetActionCallBack(nil)

			if arg3 then
				arg3()
			end
		end
	end)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.LTList) do
		LeanTween.cancel(iter1)
	end
end

function var0.IsShowRed()
	local var0 = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)
	local var1 = var0.data1_list
	local var2 = pg.activity_event_pt_consume[1].target
	local var3 = var0.data1

	for iter0, iter1 in pairs(var1) do
		if iter1 < 2 and var3 >= var2[iter0][iter1 + 1] then
			return true
		end
	end

	return false
end

return var0
