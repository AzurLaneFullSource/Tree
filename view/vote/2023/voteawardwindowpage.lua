local var0_0 = class("VoteAwardWindowPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "VoteAwardWindowUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.currToggle = arg0_2:findTF("frame/toggle/curr")
	arg0_2.accToggle = arg0_2:findTF("frame/toggle/acc")
	arg0_2.ptWindow = VoteAwardPtWindow.New(arg0_2._tf, arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("frame/close")

	setText(arg0_2:findTF("frame/title/Text"), i18n("vote_lable_window_title"))
	setText(arg0_2:findTF("frame/panel/list/tpl/award1/mask/Text"), i18n("vote_lable_rearch"))
	setText(arg0_2:findTF("frame/panel/list/tpl/award/mask/Text"), i18n("vote_lable_rearch"))
end

function var0_0.OnInit(arg0_3)
	onToggle(arg0_3, arg0_3.currToggle, function(arg0_4)
		local var0_4 = arg0_3.currPtData

		if arg0_4 and var0_4 then
			arg0_3.ptWindow:Show({
				type = VoteAwardPtWindow.TYPE_CURR,
				dropList = var0_4.dropList,
				targets = var0_4.targets,
				level = var0_4.level,
				count = var0_4.count
			})
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.accToggle, function(arg0_5)
		local var0_5 = arg0_3.accPtData

		if arg0_5 and var0_5 then
			arg0_3.ptWindow:Show({
				type = VoteAwardPtWindow.TYPE_ACC,
				dropList = var0_5.dropList,
				targets = var0_5.targets,
				level = var0_5.level,
				count = var0_5.count
			})
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)

	arg0_8.currPtData = arg0_8:GenCurrPtData()
	arg0_8.accPtData = arg0_8:GenAccPtData()

	local var0_8 = arg0_8.currPtData ~= nil and #arg0_8.currPtData.targets > 0

	setActive(arg0_8.currToggle, var0_8)

	if var0_8 then
		triggerToggle(arg0_8.currToggle, true)
	else
		triggerToggle(arg0_8.accToggle, true)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
end

function var0_0.Hide(arg0_9)
	var0_0.super.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
end

function var0_0.GenCurrPtData(arg0_10)
	local var0_10 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	if var0_10 and not var0_10:isEnd() then
		local var1_10 = var0_10:getConfig("config_id")
		local var2_10 = pg.activity_vote[var1_10]
		local var3_10 = {}
		local var4_10 = {}

		for iter0_10, iter1_10 in ipairs(var2_10.period_reward) do
			table.insert(var4_10, iter1_10[1])
		end

		for iter2_10, iter3_10 in ipairs(var2_10.period_reward_display) do
			table.insert(var3_10, iter3_10)
		end

		local var5_10 = var0_10.data2
		local var6_10 = 0

		for iter4_10, iter5_10 in pairs(var4_10) do
			if iter5_10 <= var5_10 then
				var6_10 = iter4_10
			end
		end

		return {
			type = VoteAwardPtWindow.TYPE_CURR,
			dropList = var3_10,
			targets = var4_10,
			level = var6_10,
			count = var5_10
		}
	end
end

function var0_0.GenAccPtData(arg0_11)
	local var0_11
	local var1_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if var1_11 and not var1_11:isEnd() then
		local var2_11 = var1_11:getConfig("config_client")[1]
		local var3_11 = getProxy(ActivityProxy):getActivityById(var2_11)

		var0_11 = ActivityPtData.New(var3_11)
	end

	return var0_11
end

function var0_0.OnDestroy(arg0_12)
	if arg0_12:isShowing() then
		arg0_12:Hide()
	end

	if arg0_12.ptWindow then
		arg0_12.ptWindow = nil
	end
end

return var0_0
