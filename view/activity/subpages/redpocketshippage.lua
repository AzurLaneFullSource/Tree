local var0_0 = class("RedPocketShipPage", import("...base.BaseActivityPage"))
local var1_0 = 7
local var2_0 = {
	[0] = 705.6,
	807.608,
	897.5893,
	987.5705,
	1077.552,
	1167.533,
	1257.514,
	1387.6
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg")
	arg0_1.tip = arg0_1:findTF("tip")
	arg0_1.btn = arg0_1:findTF("btn")
	arg0_1.mainAward = arg0_1:findTF("main_award")
	arg0_1.subAward = arg0_1:findTF("sub_award")
	arg0_1.itemIcon = arg0_1:findTF("icon")
	arg0_1.slider = arg0_1:findTF("slider")
	arg0_1.uilist = UIItemList.New(arg0_1.subAward, arg0_1:findTF("1", arg0_1.subAward))
end

function var0_0.OnFirstFlush(arg0_2)
	local var0_2 = arg0_2.activity

	onButton(arg0_2, arg0_2.tip, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.metalgearsub_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btn, function()
		arg0_2:emit(ActivityMediator.GO_SUBMARINE_RUN, var0_2:getConfig("config_client").stage_ids[math.min(arg0_2.progess + 1, arg0_2.maxday)])
	end, SFX_PANEL)

	local var1_2 = Drop.Create(var0_2:getConfig("config_client")[2])

	onButton(arg0_2, arg0_2.mainAward, function()
		arg0_2:emit(BaseUI.ON_DROP, var1_2)
	end, SFX_PANEL)

	local var2_2 = var0_2:getConfig("config_client")[1]
	local var3_2 = {
		type = var2_2[1],
		id = var2_2[2],
		count = var2_2[3]
	}

	onButton(arg0_2, arg0_2.itemIcon, function()
		arg0_2:emit(BaseUI.ON_DROP, var3_2)
	end, SFX_PANEL)
	arg0_2.uilist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			if LeanTween.isTweening(arg2_7) then
				LeanTween.cancel(arg2_7)
			end

			if arg1_7 < arg0_2.progess then
				setImageAlpha(arg2_7, 1)
			else
				LeanTween.alpha(arg2_7, 1, 1):setFrom(0.4):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
			end
		elseif arg0_7 == UIItemList.EventExcess and LeanTween.isTweening(arg2_7) then
			LeanTween.cancel(arg2_7)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_8)
	local var0_8 = arg0_8.activity
	local var1_8 = pg.TimeMgr.GetInstance()

	arg0_8.progess = math.min(var0_8.data2, var1_0)
	arg0_8.maxday = math.min(var1_8:DiffDay(var0_8.data1, var1_8:GetServerTime()) + 1, var1_0)

	arg0_8.uilist:align(math.min(arg0_8.maxday, var1_0 - 1))
	setSlider(arg0_8.slider, var2_0[0], var2_0[var1_0], var2_0[arg0_8.progess])
	setActive(findTF(arg0_8.mainAward, "dis"), not var0_8.data4 or var0_8.data4 == 0)
	setActive(findTF(arg0_8.mainAward, "dis/lock"), arg0_8.maxday < var1_0)
	setActive(findTF(arg0_8.mainAward, "get"), var0_8.data4 > 0)

	if var0_8.data4 == 0 and arg0_8.progess >= var1_0 then
		arg0_8:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 3,
			activity_id = var0_8.id
		})
	elseif defaultValue(var0_8.data2_list[1], 0) > 0 or defaultValue(var0_8.data2_list[2], 0) > 0 then
		arg0_8:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = var0_8.id
		})
	end
end

function var0_0.OnDestroy(arg0_9)
	clearImageSprite(arg0_9.bg)
end

return var0_0
