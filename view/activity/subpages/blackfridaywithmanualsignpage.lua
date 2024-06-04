local var0 = class("BlackFridayWithManualSignPage", import(".BlackFridayPage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.signList = UIItemList.New(arg0:findTF("AD/singlist"), arg0:findTF("AD/singlist/Award"))
	arg0.signBtn = arg0:findTF("AD/signBtn")

	setText(arg0.signBtn:Find("Text"), i18n("SkinMagazinePage2_tip"))
end

function var0.GetPageLink(arg0)
	local var0 = arg0.activity:getConfig("config_client")[2]

	return {
		var0
	}
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	arg0.signInActId = arg0.activity:getConfig("config_client")[2]
end

function var0.FlushSignBtn(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.signInActId)
	local var1 = not var0 or var0:isEnd()

	onButton(arg0, arg0.signBtn, function()
		arg0:Sign(var0)
	end, SFX_PANEL)
	setActive(arg0.signBtn, not var1 and var0:AnyAwardCanGet())
end

function var0.FlushSignActivity(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.signInActId)

	if not var0 or var0:isEnd() then
		arg0:FlushEmptyList()
	else
		arg0:FlushSignList(var0)
	end
end

function var0.FlushEmptyList(arg0)
	arg0.signList:align(0)
end

function var0.FlushSignList(arg0, arg1)
	local var0 = arg1:GetDropList()
	local var1 = arg1:GetCanGetAwardIndexList()
	local var2 = {}
	local var3 = arg1:getConfig("config_client")
	local var4 = type(var3) == "table" and var3 or {}

	arg0.signList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1:GetAwardState(arg1 + 1)

			arg0:UpdateSignAward(arg1, var0, var0[arg1 + 1], arg2)

			if var0 == ManualSignActivity.STATE_GOT then
				table.insert(var2, var4[arg1 + 1])
			end
		end
	end)
	arg0.signList:align(#var0)
	arg0:TryPlayStory(var2)
end

function var0.TryPlayStory(arg0, arg1)
	if #arg1 <= 0 then
		return
	end

	local var0 = _.select(arg1, function(arg0)
		return not pg.NewStoryMgr.GetInstance():IsPlayed(arg0)
	end)

	if #var0 > 0 then
		pg.NewStoryMgr.GetInstance():SeriesPlay(var0)
	end
end

function var0.UpdateSignAward(arg0, arg1, arg2, arg3, arg4)
	updateDrop(arg4, arg3)
	setActive(arg4:Find("got"), arg2 == ManualSignActivity.STATE_GOT)
	setActive(arg4:Find("get"), arg2 == ManualSignActivity.STATE_CAN_GET)
	onButton(arg0, arg4, function()
		if arg2 == ManualSignActivity.STATE_CAN_GET then
			arg0:Sign(arg1)
		end
	end, SFX_PANEL)
end

function var0.Sign(arg0, arg1)
	pg.m02:sendNotification(GAME.ACT_MANUAL_SIGN, {
		activity_id = arg1.id,
		cmd = ManualSignActivity.OP_GET_AWARD
	})
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	arg0:FlushSignActivity()
	arg0:FlushSignBtn()
end

return var0
