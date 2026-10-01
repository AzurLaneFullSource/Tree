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

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/MonthSignReSignUI",
		"weaponframes",
		"shiptype",
		"ui/iconcolorful"
	}

	table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))

	return var0_1
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.items = arg0_2._tf:Find("items")
	arg0_2.item = arg0_2.items:Find("item")
	arg0_2.spDay = arg0_2._tf:Find("sp_day")
	arg0_2.spDayEffects = {}
	arg0_2.monthSignReSignUI = MonthSignReSignUI.New(arg0_2._tf, arg0_2.event, nil)

	arg0_2:bind(var0_0.SHOW_RE_MONTH_SIGN, function(arg0_3, arg1_3, arg2_3)
		if not arg0_2.monthSignReSignUI:GetLoaded() then
			arg0_2.monthSignReSignUI:Load()
		end

		arg0_2.monthSignReSignUI:ActionInvoke("setAwardShow", arg1_3, arg2_3)
	end)

	for iter0_2, iter1_2 in ipairs(MonthSignPage.MONTH_SIGN_SP_DAYS) do
		local var0_2 = arg0_2.spDay:Find(iter1_2 .. "days")

		arg0_2.spDayEffects[iter1_2] = var0_2

		setActive(var0_2, false)
	end

	setActive(arg0_2.spDay, false)
	setText(arg0_2._tf:Find("login/Text"), i18n("yearly_sign_in"))
	setText(arg0_2._tf:Find("login/count/Text"), i18n("word_date"))
end

function var0_0.OnDataSetting(arg0_4)
	arg0_4.config = pg.activity_month_sign[arg0_4.activity.data2]

	if not arg0_4.config then
		return true
	end

	arg0_4.monthDays = pg.TimeMgr.GetInstance():CalcMonthDays(arg0_4.activity.data1, arg0_4.activity.data2)

	local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()

	if tonumber(pg.TimeMgr.GetInstance():STimeDescS(var0_4, "%m")) == pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[1] then
		arg0_4.specialTag = true
		arg0_4.specialDay = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[2]
		arg0_4.isShowFrame = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[3]
	end
end

function var0_0.OnFirstFlush(arg0_5)
	arg0_5.list = UIItemList.New(arg0_5.items, arg0_5.item)

	arg0_5.list:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg1_6 + 1
			local var1_6 = _.map(arg0_5.config["day" .. var0_6], function(arg0_7)
				return Drop.Create(arg0_7)
			end)

			updateDrop(arg2_6, var1_6[1])
			onButton(arg0_5, arg2_6, function()
				if #var1_6 == 1 then
					arg0_5:emit(BaseUI.ON_DROP, var1_6[1])
				else
					arg0_5:emit(BaseUI.ON_DROP_LIST, {
						content = "",
						item2Row = true,
						itemList = var1_6
					})
				end
			end, SFX_PANEL)
			setText(arg2_6:Find("day/Text"), "Day " .. var0_6)
			setActive(arg2_6:Find("got"), var0_6 <= #arg0_5.activity.data1_list)
			setActive(arg2_6:Find("today"), var0_6 == #arg0_5.activity.data1_list)

			if arg0_5.specialTag and var0_6 == arg0_5.specialDay then
				local var2_6 = arg2_6:Find("icon_bg/SpecialFrame")

				if arg0_5.isShowFrame == 1 then
					setActive(var2_6, false)
				else
					setActive(var2_6, true)
				end
			end
		end
	end)
	arg0_5:UpdateLoginInfo()
end

function var0_0.OnUpdateFlush(arg0_9)
	if arg0_9:isDirtyRes() then
		return
	end

	arg0_9:UpdateLoginInfo()
	arg0_9.list:align(arg0_9.monthDays)

	if arg0_9.specialTag then
		local var0_9 = arg0_9._tf:Find("DayNumText")
		local var1_9 = arg0_9.specialDay - #arg0_9.activity.data1_list

		if var1_9 < 0 then
			var1_9 = 0
		end

		setText(var0_9, var1_9)

		local var2_9 = arg0_9._tf:Find("ProgressBar")

		GetComponent(var2_9, "Slider").value = #arg0_9.activity.data1_list
	end

	local var3_9 = arg0_9.activity:getSpecialData("month_sign_awards")

	if var3_9 and #var3_9 > 0 then
		local var4_9 = getProxy(PlayerProxy):getPlayerId()

		if not table.contains(MonthSignPage.MONTH_SIGN_SHOW, arg0_9.activity.id .. ":" .. var4_9) then
			table.insert(MonthSignPage.MONTH_SIGN_SHOW, arg0_9.activity.id .. ":" .. var4_9)

			if not arg0_9.monthSignReSignUI:GetLoaded() then
				arg0_9.monthSignReSignUI:Load()
			end

			arg0_9.monthSignReSignUI:ActionInvoke("setAwardShow", var3_9)
		elseif arg0_9.monthSignReSignUI then
			arg0_9.monthSignReSignUI:ActionInvoke("setAwardShow", var3_9)
		end
	end
end

function var0_0.showReMonthSign(arg0_10)
	return
end

function var0_0.OnDestroy(arg0_11)
	if arg0_11.spEffectLT then
		LeanTween.cancel(arg0_11.spEffectLT)

		arg0_11.spEffectLT = nil
	end

	removeAllChildren(arg0_11.items)

	arg0_11.monthSignPageTool = nil

	arg0_11.monthSignReSignUI:Destroy()

	arg0_11.monthSignReSignUI = nil
end

function var0_0.UseSecondPage(arg0_12, arg1_12)
	return tonumber(pg.TimeMgr.GetInstance():CurrentSTimeDesc("%m", true)) == pg.activity_template[arg1_12.id].config_client[1]
end

function var0_0.isDirtyRes(arg0_13)
	if arg0_13.specialTag and arg0_13:getUIName() ~= arg0_13.activity:getConfig("page_info").ui_name2 then
		return true
	end
end

function var0_0.UpdateLoginInfo(arg0_14)
	local var0_14 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOGIN_RECORD)
	local var1_14 = arg0_14._tf:Find("login")

	setActive(var1_14, var0_14 and not var0_14:isEnd())

	if var0_14 and not var0_14:isEnd() then
		local var2_14, var3_14, var4_14 = unpack(var0_14:getConfig("time"))

		setText(var1_14:Find("month"), string.format("%02d/%02d/%02d-%02d/%02d/%02d", var3_14[1][1] % 100, var3_14[1][2], var3_14[1][3], var4_14[1][1] % 100, var4_14[1][2], var4_14[1][3]))
		setText(var1_14:Find("count/day"), var0_14:getData1())
	end
end

function var0_0.TryShowSpEffect(arg0_15, arg1_15)
	local var0_15 = arg0_15.activity:getSpecialData(var0_0.MILESTONE_SPECIAL_DATA)
	local var1_15 = arg0_15.spDayEffects[var0_15]
	local var2_15 = var1_15:Find("heidi"):GetComponent(typeof("UnityEngine.ParticleSystem"))
	local var3_15 = arg0_15:GetEffectLeftTime(var2_15)

	arg0_15.activity:setSpecialData(var0_0.MILESTONE_SPECIAL_DATA, nil)
	setActive(arg0_15.spDay, true)

	if arg0_15.spEffectLT then
		LeanTween.cancel(arg0_15.spEffectLT)

		arg0_15.spEffectLT = nil
	end

	setActive(var1_15, true)

	arg0_15.spEffectLT = LeanTween.value(go(var1_15), 0, 1, var3_15):setOnComplete(System.Action(function()
		arg0_15.spEffectLT = nil

		arg0_15:HideSPEffect(arg1_15)
	end)).uniqueId
end

function var0_0.GetEffectLeftTime(arg0_17, arg1_17)
	local var0_17 = arg1_17.main
	local var1_17 = var0_17.duration
	local var2_17 = var0_17.startLifetime.constantMax

	return var0_17.startDelay.constantMax + var1_17 + var2_17
end

function var0_0.HideSPEffect(arg0_18, arg1_18)
	for iter0_18, iter1_18 in pairs(arg0_18.spDayEffects) do
		if iter1_18 then
			setActive(iter1_18, false)
		end
	end

	setActive(arg0_18.spDay, false)
	existCall(arg1_18)
end

function var0_0.ShouldPlaySpEffect(arg0_19)
	if not arg0_19 then
		return false
	end

	if arg0_19:getConfig("type") ~= ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
		return false
	end

	local var0_19 = arg0_19:getSpecialData(var0_0.MILESTONE_SPECIAL_DATA)

	return var0_19 and table.contains(var0_0.MONTH_SIGN_SP_DAYS, var0_19)
end

return var0_0
