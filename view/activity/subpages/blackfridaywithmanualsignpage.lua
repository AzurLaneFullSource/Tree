local var0_0 = class("BlackFridayWithManualSignPage", import(".BlackFridayPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.signList = UIItemList.New(arg0_1:findTF("AD/singlist"), arg0_1:findTF("AD/singlist/Award"))
	arg0_1.signBtn = arg0_1:findTF("AD/signBtn")

	setText(arg0_1.signBtn:Find("Text"), i18n("SkinMagazinePage2_tip"))
end

function var0_0.GetPageLink(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client")[2]

	return {
		var0_2
	}
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)

	arg0_3.signInActId = arg0_3.activity:getConfig("config_client")[2]
end

function var0_0.FlushSignBtn(arg0_4)
	local var0_4 = getProxy(ActivityProxy):getActivityById(arg0_4.signInActId)
	local var1_4 = not var0_4 or var0_4:isEnd()

	onButton(arg0_4, arg0_4.signBtn, function()
		arg0_4:Sign(var0_4)
	end, SFX_PANEL)
	setActive(arg0_4.signBtn, not var1_4 and var0_4:AnyAwardCanGet())
end

function var0_0.FlushSignActivity(arg0_6)
	local var0_6 = getProxy(ActivityProxy):getActivityById(arg0_6.signInActId)

	if not var0_6 or var0_6:isEnd() then
		arg0_6:FlushEmptyList()
	else
		arg0_6:FlushSignList(var0_6)
	end
end

function var0_0.FlushEmptyList(arg0_7)
	arg0_7.signList:align(0)
end

function var0_0.FlushSignList(arg0_8, arg1_8)
	local var0_8 = arg1_8:GetDropList()
	local var1_8 = arg1_8:GetCanGetAwardIndexList()
	local var2_8 = {}
	local var3_8 = arg1_8:getConfig("config_client")
	local var4_8 = type(var3_8) == "table" and var3_8 or {}

	arg0_8.signList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8:GetAwardState(arg1_9 + 1)

			arg0_8:UpdateSignAward(arg1_8, var0_9, var0_8[arg1_9 + 1], arg2_9)

			if var0_9 == ManualSignActivity.STATE_GOT then
				table.insert(var2_8, var4_8[arg1_9 + 1])
			end
		end
	end)
	arg0_8.signList:align(#var0_8)
	arg0_8:TryPlayStory(var2_8)
end

function var0_0.TryPlayStory(arg0_10, arg1_10)
	if #arg1_10 <= 0 then
		return
	end

	local var0_10 = _.select(arg1_10, function(arg0_11)
		return not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_11)
	end)

	if #var0_10 > 0 then
		pg.NewStoryMgr.GetInstance():SeriesPlay(var0_10)
	end
end

function var0_0.UpdateSignAward(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	updateDrop(arg4_12, arg3_12)
	setActive(arg4_12:Find("got"), arg2_12 == ManualSignActivity.STATE_GOT)
	setActive(arg4_12:Find("get"), arg2_12 == ManualSignActivity.STATE_CAN_GET)
	onButton(arg0_12, arg4_12, function()
		if arg2_12 == ManualSignActivity.STATE_CAN_GET then
			arg0_12:Sign(arg1_12)
		end
	end, SFX_PANEL)
end

function var0_0.Sign(arg0_14, arg1_14)
	pg.m02:sendNotification(GAME.ACT_MANUAL_SIGN, {
		activity_id = arg1_14.id,
		cmd = ManualSignActivity.OP_GET_AWARD
	})
end

function var0_0.OnUpdateFlush(arg0_15)
	var0_0.super.OnUpdateFlush(arg0_15)
	arg0_15:FlushSignActivity()
	arg0_15:FlushSignBtn()
end

return var0_0
