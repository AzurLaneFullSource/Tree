local var0_0 = class("MonthSignPage", import("...base.BaseActivityPage"))

var0_0.SHOW_RE_MONTH_SIGN = "show re month sign award"
var0_0.MONTH_SIGN_SHOW = {}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg")
	arg0_1.items = arg0_1:findTF("items")
	arg0_1.item = arg0_1:findTF("item", arg0_1.items)
	arg0_1.monthSignReSignUI = MonthSignReSignUI.New(arg0_1._tf, arg0_1.event, nil)

	arg0_1:bind(var0_0.SHOW_RE_MONTH_SIGN, function(arg0_2, arg1_2, arg2_2)
		if not arg0_1.monthSignReSignUI:GetLoaded() then
			arg0_1.monthSignReSignUI:Load()
		end

		arg0_1.monthSignReSignUI:ActionInvoke("setAwardShow", arg1_2, arg2_2)
	end)
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
	local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()

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
				local var2_5 = arg0_4:findTF("icon_bg/SpecialFrame", arg2_5)

				if arg0_4.isShowFrame == 1 then
					setActive(var2_5, false)
				else
					setActive(var2_5, true)
				end
			end
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_8)
	if arg0_8:isDirtyRes() then
		return
	end

	arg0_8.list:align(arg0_8.monthDays)

	if arg0_8.specialTag then
		local var0_8 = arg0_8:findTF("DayNumText")
		local var1_8 = arg0_8.specialDay - #arg0_8.activity.data1_list

		if var1_8 < 0 then
			var1_8 = 0
		end

		setText(var0_8, var1_8)

		local var2_8 = arg0_8:findTF("ProgressBar")

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

return var0_0
