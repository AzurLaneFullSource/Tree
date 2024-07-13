local var0_0 = class("AnimeMidtermLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.dayProgressImg = arg0_1:findTF("DayProgress")
	arg0_1.awardImg = arg0_1:findTF("Award")
	arg0_1.maskImg = arg0_1:findTF("Mask", arg0_1.awardImg)

	addSlip(SLIP_TYPE_HRZ, arg0_1.awardImg, function()
		if arg0_1.curShowDay > 1 then
			triggerButton(arg0_1.arrowLeft)
		end
	end, function()
		if arg0_1.curShowDay < arg0_1.allDaycount then
			triggerButton(arg0_1.arrowRight)
		end
	end)

	arg0_1.arrowLeft = arg0_1:findTF("ArrowLeft")
	arg0_1.arrowRight = arg0_1:findTF("ArrowRight")

	onButton(arg0_1, arg0_1.arrowLeft, function()
		arg0_1.curShowDay = arg0_1.curShowDay - 1

		arg0_1:updateAwardInfo(arg0_1.curShowDay)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.arrowRight, function()
		arg0_1.curShowDay = arg0_1.curShowDay + 1

		arg0_1:updateAwardInfo(arg0_1.curShowDay)
	end, SFX_PANEL)

	arg0_1.pointTpl = arg0_1:findTF("Point")
	arg0_1.pointContainer = arg0_1:findTF("PointList")
	arg0_1.pointUIItemList = UIItemList.New(arg0_1.pointContainer, arg0_1.pointTpl)

	arg0_1.pointUIItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg1_6 = arg1_6 + 1

			local var0_6 = arg0_1:findTF("Selected", arg2_6)

			if arg1_6 <= arg0_1.nday then
				setImageAlpha(arg2_6, 1)
			else
				setImageAlpha(arg2_6, 0.3)
			end

			setActive(var0_6, arg1_6 == arg0_1.curShowDay)
		end
	end)

	arg0_1.loader = AutoLoader.New()
end

function var0_0.OnDataSetting(arg0_7)
	arg0_7.config = pg.activity_7_day_sign[arg0_7.activity:getConfig("config_id")]
	arg0_7.allDaycount = #arg0_7.config.front_drops
	arg0_7.nday = arg0_7.activity.data1
	arg0_7.curShowDay = arg0_7.nday
end

function var0_0.OnFirstFlush(arg0_8)
	return
end

function var0_0.OnUpdateFlush(arg0_9)
	arg0_9.nday = arg0_9.activity.data1
	arg0_9.curShowDay = arg0_9.nday

	arg0_9:updateAwardInfo(arg0_9.curShowDay)
end

function var0_0.OnDestroy(arg0_10)
	arg0_10.loader:Clear()
end

function var0_0.updateAwardInfo(arg0_11, arg1_11)
	arg1_11 = math.max(arg1_11, 1)

	arg0_11.loader:GetOffSpriteRequest(arg0_11.dayProgressImg)
	arg0_11.loader:GetOffSpriteRequest(arg0_11.awardImg)
	arg0_11.loader:GetSprite("ui/activityuipage/animelogin_atlas", "tianshu_" .. arg1_11, arg0_11.dayProgressImg, true)
	arg0_11.loader:GetSprite("ui/activityuipage/animemidtermloginpage_atlas", "icon_" .. arg1_11, arg0_11.awardImg, true)
	setActive(arg0_11.maskImg, arg1_11 <= arg0_11.nday)
	setActive(arg0_11.arrowLeft, arg1_11 ~= 1)
	setActive(arg0_11.arrowRight, arg1_11 ~= arg0_11.allDaycount)
	arg0_11.pointUIItemList:align(arg0_11.allDaycount)
end

return var0_0
