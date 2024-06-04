local var0 = class("BlackFridayWithSignInPage", import(".BlackFridayPage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.signInUIlist = UIItemList.New(arg0:findTF("AD/signIn"), arg0:findTF("AD/signIn/award"))
	arg0.toggles = {
		arg0:findTF("AD/toggles/skin"),
		arg0:findTF("AD/toggles/sign")
	}
	arg0.lockSignBtn = arg0:findTF("AD/toggles/sign/lock")
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.lockSignBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end, SFX_PANEL)

	arg0.signInActId = arg0.activity:getConfig("config_client")[2]

	arg0:FlushSignInInfo()

	if arg0.contextData.showByNextAct then
		arg0.contextData.showByNextAct = nil

		triggerToggle(arg0.toggles[2], true)
	end
end

function var0.GetSignInAct(arg0)
	return (getProxy(ActivityProxy):getActivityById(arg0.signInActId))
end

function var0.ClientSignInActIsEnd(arg0)
	local var0 = pg.activity_template[arg0.signInActId]
	local var1 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.time[3])
	local var2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.time[2])
	local var3 = pg.TimeMgr.GetInstance():GetServerTime()

	return var1 < var3 or var3 < var2
end

function var0.FlushSignInInfo(arg0)
	local var0 = arg0:GetSignInAct()
	local var1 = var0 and not var0:isEnd()
	local var2 = pg.activity_template[arg0.signInActId]
	local var3 = arg0:ClientSignInActIsEnd()
	local var4 = not var1 and var3

	if var4 then
		triggerToggle(arg0.toggles[1], true)
		setToggleEnabled(arg0.toggles[2], false)
	end

	setActive(arg0.lockSignBtn, var4)

	local var5 = var2.config_id
	local var6 = pg.activity_7_day_sign[var5].front_drops

	arg0.signInUIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var6[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.signInUIlist:align(#var6)
end

function var0.FlushSignAwardsState(arg0)
	local var0 = arg0:GetSignInAct()
	local var1 = var0 and not var0:isEnd()
	local var2 = var1 and var0.data1 or 0
	local var3 = arg0:ClientSignInActIsEnd()

	arg0.signInUIlist:each(function(arg0, arg1)
		if not var3 and not var1 then
			setActive(arg1:Find("got"), true)
		else
			setActive(arg1:Find("got"), arg0 + 1 <= var2)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	arg0:FlushSignAwardsState()
end

return var0
