local var0_0 = class("MonthSignPage", import("...base.BaseActivityPage"))

var0_0.SHOW_RE_MONTH_SIGN = "show re month sign award"
var0_0.MILESTONE_SPECIAL_DATA = "month_sign_milestone_day"
var0_0.MONTH_SIGN_SHOW = {}
var0_0.MONTH_SIGN_SP_DAYS = {
	30,
	60,
	120,
	240,
	300
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.items = arg0_1._tf:Find("items")
	arg0_1.item = arg0_1.items:Find("item")
	arg0_1.spDay = arg0_1._tf:Find("sp_day")
	arg0_1.spDayEffects = {}
	arg0_1.monthSignReSignUI = MonthSignReSignUI.New(arg0_1._tf, arg0_1.event, nil)

	arg0_1:bind(var0_0.SHOW_RE_MONTH_SIGN, function(arg0_2, arg1_2, arg2_2)
		if not arg0_1.monthSignReSignUI:GetLoaded() then
			arg0_1.monthSignReSignUI:Load()
		end

		arg0_1.monthSignReSignUI:ActionInvoke("setAwardShow", arg1_2, arg2_2)
	end)

	for iter0_1, iter1_1 in ipairs(MonthSignPage.MONTH_SIGN_SP_DAYS) do
		local var0_1 = arg0_1.spDay:Find(iter1_1 .. "days")

		arg0_1.spDayEffects[iter1_1] = var0_1

		setActive(var0_1, false)
	end

	setActive(arg0_1.spDay, false)
	setText(arg0_1._tf:Find("login/Text"), i18n("yearly_sign_in"))
	setText(arg0_1._tf:Find("login/count/Text"), i18n("word_date"))
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.config = pg.activity_month_sign[arg0_3.activity.data2]

	if not arg0_3.config then
		return true
	end

	arg0_3.monthDays = pg.TimeMgr.GetInstance():CalcMonthDays(arg0_3.activity.data1, arg0_3.activity.data2)

	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()

	if tonumber(pg.TimeMgr.GetInstance():STimeDescS(var0_3, "%m")) == pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[1] then
		arg0_3.specialTag = true
		arg0_3.specialDay = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[2]
		arg0_3.isShowFrame = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[3]
	end
end

function var0_0.OnFirstFlush(arg0_4)
	arg0_4.list = UIItemList.New(arg0_4.items, arg0_4.item)

	arg0_4.list:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg1_5 + 1
			local var1_5 = _.map(arg0_4.config["day" .. var0_5], function(arg0_6)
				return Drop.Create(arg0_6)
			end)

			updateDrop(arg2_5, var1_5[1])
			onButton(arg0_4, arg2_5, function()
				if #var1_5 == 1 then
					arg0_4:emit(BaseUI.ON_DROP, var1_5[1])
				else
					arg0_4:emit(BaseUI.ON_DROP_LIST, {
						content = "",
						item2Row = true,
						itemList = var1_5
					})
				end
			end, SFX_PANEL)
			setText(arg2_5:Find("day/Text"), "Day " .. var0_5)
			setActive(arg2_5:Find("got"), var0_5 <= #arg0_4.activity.data1_list)
			setActive(arg2_5:Find("today"), var0_5 == #arg0_4.activity.data1_list)

			if arg0_4.specialTag and var0_5 == arg0_4.specialDay then
				local var2_5 = arg2_5:Find("icon_bg/SpecialFrame")

				if arg0_4.isShowFrame == 1 then
					setActive(var2_5, false)
				else
					setActive(var2_5, true)
				end
			end
		end
	end)
	arg0_4:UpdateLoginInfo()
end

function var0_0.OnUpdateFlush(arg0_8)
	if arg0_8:isDirtyRes() then
		return
	end

	arg0_8:UpdateLoginInfo()
	arg0_8.list:align(arg0_8.monthDays)

	if arg0_8.specialTag then
		local var0_8 = arg0_8._tf:Find("DayNumText")
		local var1_8 = arg0_8.specialDay - #arg0_8.activity.data1_list

		if var1_8 < 0 then
			var1_8 = 0
		end

		setText(var0_8, var1_8)

		local var2_8 = arg0_8._tf:Find("ProgressBar")

		GetComponent(var2_8, "Slider").value = #arg0_8.activity.data1_list
	end

	local var3_8 = arg0_8.activity:getSpecialData("month_sign_awards")

	if var3_8 and #var3_8 > 0 then
		local var4_8 = getProxy(PlayerProxy):getPlayerId()

		if not table.contains(MonthSignPage.MONTH_SIGN_SHOW, arg0_8.activity.id .. ":" .. var4_8) then
			table.insert(MonthSignPage.MONTH_SIGN_SHOW, arg0_8.activity.id .. ":" .. var4_8)

			if not arg0_8.monthSignReSignUI:GetLoaded() then
				arg0_8.monthSignReSignUI:Load()
			end

			arg0_8.monthSignReSignUI:ActionInvoke("setAwardShow", var3_8)
		elseif arg0_8.monthSignReSignUI then
			arg0_8.monthSignReSignUI:ActionInvoke("setAwardShow", var3_8)
		end
	end
end

function var0_0.showReMonthSign(arg0_9)
	return
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10.spEffectLT then
		LeanTween.cancel(arg0_10.spEffectLT)

		arg0_10.spEffectLT = nil
	end

	removeAllChildren(arg0_10.items)

	arg0_10.monthSignPageTool = nil

	arg0_10.monthSignReSignUI:Destroy()

	arg0_10.monthSignReSignUI = nil
end

function var0_0.UseSecondPage(arg0_11, arg1_11)
	return tonumber(pg.TimeMgr.GetInstance():CurrentSTimeDesc("%m", true)) == pg.activity_template[arg1_11.id].config_client[1]
end

function var0_0.isDirtyRes(arg0_12)
	if arg0_12.specialTag and arg0_12:getUIName() ~= arg0_12.activity:getConfig("page_info").ui_name2 then
		return true
	end
end

function var0_0.UpdateLoginInfo(arg0_13)
	local var0_13 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOGIN_RECORD)
	local var1_13 = arg0_13._tf:Find("login")

	setActive(var1_13, var0_13 and not var0_13:isEnd())

	if var0_13 and not var0_13:isEnd() then
		local var2_13, var3_13, var4_13 = unpack(var0_13:getConfig("time"))

		setText(var1_13:Find("month"), string.format("%02d/%02d/%02d-%02d/%02d/%02d", var3_13[1][1] % 100, var3_13[1][2], var3_13[1][3], var4_13[1][1] % 100, var4_13[1][2], var4_13[1][3]))
		setText(var1_13:Find("count/day"), var0_13:getData1())
	end
end

function var0_0.TryShowSpEffect(arg0_14, arg1_14)
	local var0_14 = arg0_14.activity:getSpecialData(var0_0.MILESTONE_SPECIAL_DATA)
	local var1_14 = arg0_14.spDayEffects[var0_14]
	local var2_14 = var1_14:Find("heidi"):GetComponent(typeof("UnityEngine.ParticleSystem"))
	local var3_14 = arg0_14:GetEffectLeftTime(var2_14)

	arg0_14.activity:setSpecialData(var0_0.MILESTONE_SPECIAL_DATA, nil)
	setActive(arg0_14.spDay, true)

	if arg0_14.spEffectLT then
		LeanTween.cancel(arg0_14.spEffectLT)

		arg0_14.spEffectLT = nil
	end

	setActive(var1_14, true)

	arg0_14.spEffectLT = LeanTween.value(go(var1_14), 0, 1, var3_14):setOnComplete(System.Action(function()
		arg0_14.spEffectLT = nil

		arg0_14:HideSPEffect(arg1_14)
	end)).uniqueId
end

function var0_0.GetEffectLeftTime(arg0_16, arg1_16)
	local var0_16 = arg1_16.main
	local var1_16 = var0_16.duration
	local var2_16 = var0_16.startLifetime.constantMax

	return var0_16.startDelay.constantMax + var1_16 + var2_16
end

function var0_0.HideSPEffect(arg0_17, arg1_17)
	for iter0_17, iter1_17 in pairs(arg0_17.spDayEffects) do
		if iter1_17 then
			setActive(iter1_17, false)
		end
	end

	setActive(arg0_17.spDay, false)
	existCall(arg1_17)
end

function var0_0.ShouldPlaySpEffect(arg0_18)
	if not arg0_18 then
		return false
	end

	if arg0_18:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
		return false
	end

	local var0_18 = arg0_18:getSpecialData(var0_0.MILESTONE_SPECIAL_DATA)

	return var0_18 and table.contains(var0_0.MONTH_SIGN_SP_DAYS, var0_18)
end

return var0_0
