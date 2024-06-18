local var0_0 = class("CygnetBathrobePage", import("...base.BaseActivityPage"))

var0_0.MAX_COUNT = 7

function var0_0.OnInit(arg0_1)
	arg0_1.drawBtn = arg0_1:findTF("DrawBtn")
	arg0_1.resultTF = arg0_1:findTF("ResultImg")
	arg0_1.resultImgLittle = arg0_1:findTF("Little", arg0_1.resultTF)
	arg0_1.resultImgMiddle = arg0_1:findTF("Middle", arg0_1.resultTF)
	arg0_1.resultImgBig = arg0_1:findTF("Big", arg0_1.resultTF)
	arg0_1.progressTF = arg0_1:findTF("Progress")
	arg0_1.progressText = arg0_1:findTF("Progress/ProgressText")
	arg0_1.gotImg = arg0_1:findTF("GotImg")
	arg0_1.awardPanel = arg0_1:findTF("AwardPanel")
	arg0_1.itemTpl = arg0_1:findTF("itemTpl", arg0_1.awardPanel)
	arg0_1.resultTextTF = arg0_1:findTF("ResultImg", arg0_1.awardPanel)
	arg0_1.resultTextLittle = arg0_1:findTF("ResultImg/Little", arg0_1.awardPanel)
	arg0_1.resultTextMiddle = arg0_1:findTF("ResultImg/Middle", arg0_1.awardPanel)
	arg0_1.resultTextBig = arg0_1:findTF("ResultImg/Big", arg0_1.awardPanel)
	arg0_1.itemTplContainer = arg0_1:findTF("AwardList", arg0_1.awardPanel)
	arg0_1.animTF = arg0_1:findTF("Anim")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.progressNum = arg0_2.activity.data1
	arg0_2.resultNum = arg0_2.activity.data2
	arg0_2.awardDayList = arg0_2.activity.data1_list
	arg0_2.isFinished = arg0_2.progressNum > var0_0.MAX_COUNT
	arg0_2.isAvailable = not (arg0_2.resultNum > 0)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.drawBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_3.activity.id
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	setActive(arg0_5.drawBtn, arg0_5.isAvailable)
	setActive(arg0_5.resultTF, not arg0_5.isAvailable)

	if not arg0_5.isAvailable then
		for iter0_5 = 1, arg0_5.resultTF.childCount do
			setActive(arg0_5.resultTF:GetChild(iter0_5 - 1), iter0_5 == arg0_5.resultNum)
		end
	end

	setActive(arg0_5.progressTF, not arg0_5.isFinished)
	setActive(arg0_5.gotImg, arg0_5.isFinished)

	if not arg0_5.isFinished then
		setText(arg0_5.progressText, arg0_5.progressNum .. "/" .. var0_0.MAX_COUNT)
	end

	local var0_5 = arg0_5.activity:getConfig("config_data")[2]

	if var0_5 then
		local var1_5 = _.filter(var0_5, function(arg0_6)
			for iter0_6, iter1_6 in ipairs(arg0_5.activity.data1_list) do
				if iter1_6 == arg0_6[1] then
					return false
				end
			end

			return true
		end)

		for iter1_5, iter2_5 in ipairs(var1_5) do
			if arg0_5.progressNum == iter2_5[1] then
				arg0_5:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 2,
					activity_id = arg0_5.activity.id,
					arg1 = iter2_5[1]
				})

				return
			end
		end
	end
end

function var0_0.OnDestroy(arg0_7)
	return
end

function var0_0.showLotteryAwardResult(arg0_8, arg1_8, arg2_8, arg3_8)
	GetComponent(arg0_8.animTF, typeof(DftAniEvent)):SetEndEvent(function(arg0_9)
		setActive(arg0_8.animTF, false)
		setActive(arg0_8.awardPanel, true)

		for iter0_9 = 1, arg0_8.resultTextTF.childCount do
			setActive(arg0_8.resultTextTF:GetChild(iter0_9 - 1), iter0_9 == arg2_8)
		end

		removeAllChildren(arg0_8.itemTplContainer)

		for iter1_9, iter2_9 in ipairs(arg1_8) do
			local var0_9 = cloneTplTo(arg0_8.itemTpl, arg0_8.itemTplContainer)
			local var1_9 = {
				type = iter2_9.type,
				id = iter2_9.id,
				count = iter2_9.count
			}

			updateDrop(var0_9, var1_9)
			onButton(arg0_8, var0_9, function()
				arg0_8:emit(BaseUI.ON_DROP, var1_9)
			end, SFX_PANEL)
		end

		arg0_8:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
		arg3_8()
		onButton(arg0_8, arg0_8.awardPanel, function()
			setActive(arg0_8.awardPanel, false)
		end)
	end)
	setActive(arg0_8.animTF, true)
	arg0_8:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
end

function var0_0.IsTip()
	local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.CYGNET_BATHROBE_PAGE_ID)

	if var0_12 and not var0_12:isEnd() then
		return var0_12.data2 <= 0
	end
end

return var0_0
