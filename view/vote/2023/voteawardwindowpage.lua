local var0 = class("VoteAwardWindowPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "VoteAwardWindowUI"
end

function var0.OnLoaded(arg0)
	arg0.currToggle = arg0:findTF("frame/toggle/curr")
	arg0.accToggle = arg0:findTF("frame/toggle/acc")
	arg0.ptWindow = VoteAwardPtWindow.New(arg0._tf, arg0)
	arg0.closeBtn = arg0._tf:Find("frame/close")

	setText(arg0:findTF("frame/title/Text"), i18n("vote_lable_window_title"))
	setText(arg0:findTF("frame/panel/list/tpl/award1/mask/Text"), i18n("vote_lable_rearch"))
	setText(arg0:findTF("frame/panel/list/tpl/award/mask/Text"), i18n("vote_lable_rearch"))
end

function var0.OnInit(arg0)
	onToggle(arg0, arg0.currToggle, function(arg0)
		local var0 = arg0.currPtData

		if arg0 and var0 then
			arg0.ptWindow:Show({
				type = VoteAwardPtWindow.TYPE_CURR,
				dropList = var0.dropList,
				targets = var0.targets,
				level = var0.level,
				count = var0.count
			})
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.accToggle, function(arg0)
		local var0 = arg0.accPtData

		if arg0 and var0 then
			arg0.ptWindow:Show({
				type = VoteAwardPtWindow.TYPE_ACC,
				dropList = var0.dropList,
				targets = var0.targets,
				level = var0.level,
				count = var0.count
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0)
	var0.super.Show(arg0)

	arg0.currPtData = arg0:GenCurrPtData()
	arg0.accPtData = arg0:GenAccPtData()

	local var0 = arg0.currPtData ~= nil and #arg0.currPtData.targets > 0

	setActive(arg0.currToggle, var0)

	if var0 then
		triggerToggle(arg0.currToggle, true)
	else
		triggerToggle(arg0.accToggle, true)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.GenCurrPtData(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_id")
		local var2 = pg.activity_vote[var1]
		local var3 = {}
		local var4 = {}

		for iter0, iter1 in ipairs(var2.period_reward) do
			table.insert(var4, iter1[1])
		end

		for iter2, iter3 in ipairs(var2.period_reward_display) do
			table.insert(var3, iter3)
		end

		local var5 = var0.data2
		local var6 = 0

		for iter4, iter5 in pairs(var4) do
			if iter5 <= var5 then
				var6 = iter4
			end
		end

		return {
			type = VoteAwardPtWindow.TYPE_CURR,
			dropList = var3,
			targets = var4,
			level = var6,
			count = var5
		}
	end
end

function var0.GenAccPtData(arg0)
	local var0
	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if var1 and not var1:isEnd() then
		local var2 = var1:getConfig("config_client")[1]
		local var3 = getProxy(ActivityProxy):getActivityById(var2)

		var0 = ActivityPtData.New(var3)
	end

	return var0
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	if arg0.ptWindow then
		arg0.ptWindow = nil
	end
end

return var0
