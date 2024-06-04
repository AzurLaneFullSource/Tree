local var0 = class("RedPocketShipPage", import("...base.BaseActivityPage"))
local var1 = 7
local var2 = {
	[0] = 705.6,
	807.608,
	897.5893,
	987.5705,
	1077.552,
	1167.533,
	1257.514,
	1387.6
}

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.tip = arg0:findTF("tip")
	arg0.btn = arg0:findTF("btn")
	arg0.mainAward = arg0:findTF("main_award")
	arg0.subAward = arg0:findTF("sub_award")
	arg0.itemIcon = arg0:findTF("icon")
	arg0.slider = arg0:findTF("slider")
	arg0.uilist = UIItemList.New(arg0.subAward, arg0:findTF("1", arg0.subAward))
end

function var0.OnFirstFlush(arg0)
	local var0 = arg0.activity

	onButton(arg0, arg0.tip, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.metalgearsub_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.btn, function()
		arg0:emit(ActivityMediator.GO_SUBMARINE_RUN, var0:getConfig("config_client").stage_ids[math.min(arg0.progess + 1, arg0.maxday)])
	end, SFX_PANEL)

	local var1 = Drop.Create(var0:getConfig("config_client")[2])

	onButton(arg0, arg0.mainAward, function()
		arg0:emit(BaseUI.ON_DROP, var1)
	end, SFX_PANEL)

	local var2 = var0:getConfig("config_client")[1]
	local var3 = {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	}

	onButton(arg0, arg0.itemIcon, function()
		arg0:emit(BaseUI.ON_DROP, var3)
	end, SFX_PANEL)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			if LeanTween.isTweening(arg2) then
				LeanTween.cancel(arg2)
			end

			if arg1 < arg0.progess then
				setImageAlpha(arg2, 1)
			else
				LeanTween.alpha(arg2, 1, 1):setFrom(0.4):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
			end
		elseif arg0 == UIItemList.EventExcess and LeanTween.isTweening(arg2) then
			LeanTween.cancel(arg2)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity
	local var1 = pg.TimeMgr.GetInstance()

	arg0.progess = math.min(var0.data2, var1)
	arg0.maxday = math.min(var1:DiffDay(var0.data1, var1:GetServerTime()) + 1, var1)

	arg0.uilist:align(math.min(arg0.maxday, var1 - 1))
	setSlider(arg0.slider, var2[0], var2[var1], var2[arg0.progess])
	setActive(findTF(arg0.mainAward, "dis"), not var0.data4 or var0.data4 == 0)
	setActive(findTF(arg0.mainAward, "dis/lock"), arg0.maxday < var1)
	setActive(findTF(arg0.mainAward, "get"), var0.data4 > 0)

	if var0.data4 == 0 and arg0.progess >= var1 then
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 3,
			activity_id = var0.id
		})
	elseif defaultValue(var0.data2_list[1], 0) > 0 or defaultValue(var0.data2_list[2], 0) > 0 then
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = var0.id
		})
	end
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)
end

return var0
