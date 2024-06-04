local var0 = class("MonthSignPage", import("...base.BaseActivityPage"))

var0.SHOW_RE_MONTH_SIGN = "show re month sign award"
var0.MONTH_SIGN_SHOW = {}

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.items = arg0:findTF("items")
	arg0.item = arg0:findTF("item", arg0.items)
	arg0.monthSignReSignUI = MonthSignReSignUI.New(arg0._tf, arg0.event, nil)

	arg0:bind(var0.SHOW_RE_MONTH_SIGN, function(arg0, arg1, arg2)
		if not arg0.monthSignReSignUI:GetLoaded() then
			arg0.monthSignReSignUI:Load()
		end

		arg0.monthSignReSignUI:ActionInvoke("setAwardShow", arg1, arg2)
	end)
end

function var0.OnDataSetting(arg0)
	arg0.config = pg.activity_month_sign[arg0.activity.data2]

	if not arg0.config then
		return true
	end

	arg0.monthDays = pg.TimeMgr.GetInstance():CalcMonthDays(arg0.activity.data1, arg0.activity.data2)

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	if tonumber(pg.TimeMgr.GetInstance():STimeDescS(var0, "%m")) == pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[1] then
		arg0.specialTag = true
		arg0.specialDay = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[2]
		arg0.isShowFrame = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[3]
	end
end

function var0.OnFirstFlush(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0.list = UIItemList.New(arg0.items, arg0.item)

	arg0.list:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = _.map(arg0.config["day" .. var0], function(arg0)
				return Drop.Create(arg0)
			end)

			updateDrop(arg2, var1[1])
			onButton(arg0, arg2, function()
				if #var1 == 1 then
					arg0:emit(BaseUI.ON_DROP, var1[1])
				else
					arg0:emit(BaseUI.ON_DROP_LIST, {
						content = "",
						item2Row = true,
						itemList = var1
					})
				end
			end, SFX_PANEL)
			setText(arg2:Find("day/Text"), "Day " .. var0)
			setActive(arg2:Find("got"), var0 <= #arg0.activity.data1_list)
			setActive(arg2:Find("today"), var0 == #arg0.activity.data1_list)

			if arg0.specialTag and var0 == arg0.specialDay then
				local var2 = arg0:findTF("icon_bg/SpecialFrame", arg2)

				if arg0.isShowFrame == 1 then
					setActive(var2, false)
				else
					setActive(var2, true)
				end
			end
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	if arg0:isDirtyRes() then
		return
	end

	arg0.list:align(arg0.monthDays)

	if arg0.specialTag then
		local var0 = arg0:findTF("DayNumText")
		local var1 = arg0.specialDay - #arg0.activity.data1_list

		if var1 < 0 then
			var1 = 0
		end

		setText(var0, var1)

		local var2 = arg0:findTF("ProgressBar")

		GetComponent(var2, "Slider").value = #arg0.activity.data1_list
	end

	local var3 = arg0.activity:getSpecialData("month_sign_awards")

	if var3 and #var3 > 0 then
		local var4 = getProxy(PlayerProxy):getPlayerId()

		if not table.contains(MonthSignPage.MONTH_SIGN_SHOW, arg0.activity.id .. ":" .. var4) then
			table.insert(MonthSignPage.MONTH_SIGN_SHOW, arg0.activity.id .. ":" .. var4)

			if not arg0.monthSignReSignUI:GetLoaded() then
				arg0.monthSignReSignUI:Load()
			end

			arg0.monthSignReSignUI:ActionInvoke("setAwardShow", var3)
		elseif arg0.monthSignReSignUI then
			arg0.monthSignReSignUI:ActionInvoke("setAwardShow", var3)
		end
	end
end

function var0.showReMonthSign(arg0)
	return
end

function var0.OnDestroy(arg0)
	removeAllChildren(arg0.items)

	arg0.monthSignPageTool = nil

	arg0.monthSignReSignUI:Destroy()

	arg0.monthSignReSignUI = nil
end

function var0.UseSecondPage(arg0, arg1)
	return tonumber(pg.TimeMgr.GetInstance():CurrentSTimeDesc("%m", true)) == pg.activity_template[arg1.id].config_client[1]
end

function var0.isDirtyRes(arg0)
	if arg0.specialTag and arg0:getUIName() ~= arg0.activity:getConfig("page_info").ui_name2 then
		return true
	end
end

return var0
