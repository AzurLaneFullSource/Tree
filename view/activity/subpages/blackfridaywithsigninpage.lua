local var0_0 = class("BlackFridayWithSignInPage", import(".BlackFridayPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.signInUIlist = UIItemList.New(arg0_1:findTF("AD/signIn"), arg0_1:findTF("AD/signIn/award"))
	arg0_1.toggles = {
		arg0_1:findTF("AD/toggles/skin"),
		arg0_1:findTF("AD/toggles/sign")
	}
	arg0_1.lockSignBtn = arg0_1:findTF("AD/toggles/sign/lock")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.lockSignBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end, SFX_PANEL)

	arg0_2.signInActId = arg0_2.activity:getConfig("config_client")[2]

	arg0_2:FlushSignInInfo()

	if arg0_2.contextData.showByNextAct then
		arg0_2.contextData.showByNextAct = nil

		triggerToggle(arg0_2.toggles[2], true)
	end
end

function var0_0.GetSignInAct(arg0_4)
	return (getProxy(ActivityProxy):getActivityById(arg0_4.signInActId))
end

function var0_0.ClientSignInActIsEnd(arg0_5)
	local var0_5 = pg.activity_template[arg0_5.signInActId]
	local var1_5 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_5.time[3])
	local var2_5 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_5.time[2])
	local var3_5 = pg.TimeMgr.GetInstance():GetServerTime()

	return var1_5 < var3_5 or var3_5 < var2_5
end

function var0_0.FlushSignInInfo(arg0_6)
	local var0_6 = arg0_6:GetSignInAct()
	local var1_6 = var0_6 and not var0_6:isEnd()
	local var2_6 = pg.activity_template[arg0_6.signInActId]
	local var3_6 = arg0_6:ClientSignInActIsEnd()
	local var4_6 = not var1_6 and var3_6

	if var4_6 then
		triggerToggle(arg0_6.toggles[1], true)
		setToggleEnabled(arg0_6.toggles[2], false)
	end

	setActive(arg0_6.lockSignBtn, var4_6)

	local var5_6 = var2_6.config_id
	local var6_6 = pg.activity_7_day_sign[var5_6].front_drops

	arg0_6.signInUIlist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var6_6[arg1_7 + 1]
			local var1_7 = {
				type = var0_7[1],
				id = var0_7[2],
				count = var0_7[3]
			}

			updateDrop(arg2_7, var1_7)
			onButton(arg0_6, arg2_7, function()
				arg0_6:emit(BaseUI.ON_DROP, var1_7)
			end, SFX_PANEL)
		end
	end)
	arg0_6.signInUIlist:align(#var6_6)
end

function var0_0.FlushSignAwardsState(arg0_9)
	local var0_9 = arg0_9:GetSignInAct()
	local var1_9 = var0_9 and not var0_9:isEnd()
	local var2_9 = var1_9 and var0_9.data1 or 0
	local var3_9 = arg0_9:ClientSignInActIsEnd()

	arg0_9.signInUIlist:each(function(arg0_10, arg1_10)
		if not var3_9 and not var1_9 then
			setActive(arg1_10:Find("got"), true)
		else
			setActive(arg1_10:Find("got"), arg0_10 + 1 <= var2_9)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_11)
	var0_0.super.OnUpdateFlush(arg0_11)
	arg0_11:FlushSignAwardsState()
end

return var0_0
