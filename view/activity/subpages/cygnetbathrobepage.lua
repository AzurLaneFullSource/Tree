local var0 = class("CygnetBathrobePage", import("...base.BaseActivityPage"))

var0.MAX_COUNT = 7

function var0.OnInit(arg0)
	arg0.drawBtn = arg0:findTF("DrawBtn")
	arg0.resultTF = arg0:findTF("ResultImg")
	arg0.resultImgLittle = arg0:findTF("Little", arg0.resultTF)
	arg0.resultImgMiddle = arg0:findTF("Middle", arg0.resultTF)
	arg0.resultImgBig = arg0:findTF("Big", arg0.resultTF)
	arg0.progressTF = arg0:findTF("Progress")
	arg0.progressText = arg0:findTF("Progress/ProgressText")
	arg0.gotImg = arg0:findTF("GotImg")
	arg0.awardPanel = arg0:findTF("AwardPanel")
	arg0.itemTpl = arg0:findTF("itemTpl", arg0.awardPanel)
	arg0.resultTextTF = arg0:findTF("ResultImg", arg0.awardPanel)
	arg0.resultTextLittle = arg0:findTF("ResultImg/Little", arg0.awardPanel)
	arg0.resultTextMiddle = arg0:findTF("ResultImg/Middle", arg0.awardPanel)
	arg0.resultTextBig = arg0:findTF("ResultImg/Big", arg0.awardPanel)
	arg0.itemTplContainer = arg0:findTF("AwardList", arg0.awardPanel)
	arg0.animTF = arg0:findTF("Anim")
end

function var0.OnDataSetting(arg0)
	arg0.progressNum = arg0.activity.data1
	arg0.resultNum = arg0.activity.data2
	arg0.awardDayList = arg0.activity.data1_list
	arg0.isFinished = arg0.progressNum > var0.MAX_COUNT
	arg0.isAvailable = not (arg0.resultNum > 0)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.drawBtn, function()
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	setActive(arg0.drawBtn, arg0.isAvailable)
	setActive(arg0.resultTF, not arg0.isAvailable)

	if not arg0.isAvailable then
		for iter0 = 1, arg0.resultTF.childCount do
			setActive(arg0.resultTF:GetChild(iter0 - 1), iter0 == arg0.resultNum)
		end
	end

	setActive(arg0.progressTF, not arg0.isFinished)
	setActive(arg0.gotImg, arg0.isFinished)

	if not arg0.isFinished then
		setText(arg0.progressText, arg0.progressNum .. "/" .. var0.MAX_COUNT)
	end

	local var0 = arg0.activity:getConfig("config_data")[2]

	if var0 then
		local var1 = _.filter(var0, function(arg0)
			for iter0, iter1 in ipairs(arg0.activity.data1_list) do
				if iter1 == arg0[1] then
					return false
				end
			end

			return true
		end)

		for iter1, iter2 in ipairs(var1) do
			if arg0.progressNum == iter2[1] then
				arg0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 2,
					activity_id = arg0.activity.id,
					arg1 = iter2[1]
				})

				return
			end
		end
	end
end

function var0.OnDestroy(arg0)
	return
end

function var0.showLotteryAwardResult(arg0, arg1, arg2, arg3)
	GetComponent(arg0.animTF, typeof(DftAniEvent)):SetEndEvent(function(arg0)
		setActive(arg0.animTF, false)
		setActive(arg0.awardPanel, true)

		for iter0 = 1, arg0.resultTextTF.childCount do
			setActive(arg0.resultTextTF:GetChild(iter0 - 1), iter0 == arg2)
		end

		removeAllChildren(arg0.itemTplContainer)

		for iter1, iter2 in ipairs(arg1) do
			local var0 = cloneTplTo(arg0.itemTpl, arg0.itemTplContainer)
			local var1 = {
				type = iter2.type,
				id = iter2.id,
				count = iter2.count
			}

			updateDrop(var0, var1)
			onButton(arg0, var0, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end

		arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
		arg3()
		onButton(arg0, arg0.awardPanel, function()
			setActive(arg0.awardPanel, false)
		end)
	end)
	setActive(arg0.animTF, true)
	arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.CYGNET_BATHROBE_PAGE_ID)

	if var0 and not var0:isEnd() then
		return var0.data2 <= 0
	end
end

return var0
