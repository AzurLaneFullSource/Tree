local var0 = class("AnimeMidtermLoginPage", import(".TemplatePage.LoginTemplatePage"))

function var0.OnInit(arg0)
	arg0.dayProgressImg = arg0:findTF("DayProgress")
	arg0.awardImg = arg0:findTF("Award")
	arg0.maskImg = arg0:findTF("Mask", arg0.awardImg)

	addSlip(SLIP_TYPE_HRZ, arg0.awardImg, function()
		if arg0.curShowDay > 1 then
			triggerButton(arg0.arrowLeft)
		end
	end, function()
		if arg0.curShowDay < arg0.allDaycount then
			triggerButton(arg0.arrowRight)
		end
	end)

	arg0.arrowLeft = arg0:findTF("ArrowLeft")
	arg0.arrowRight = arg0:findTF("ArrowRight")

	onButton(arg0, arg0.arrowLeft, function()
		arg0.curShowDay = arg0.curShowDay - 1

		arg0:updateAwardInfo(arg0.curShowDay)
	end, SFX_PANEL)
	onButton(arg0, arg0.arrowRight, function()
		arg0.curShowDay = arg0.curShowDay + 1

		arg0:updateAwardInfo(arg0.curShowDay)
	end, SFX_PANEL)

	arg0.pointTpl = arg0:findTF("Point")
	arg0.pointContainer = arg0:findTF("PointList")
	arg0.pointUIItemList = UIItemList.New(arg0.pointContainer, arg0.pointTpl)

	arg0.pointUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0:findTF("Selected", arg2)

			if arg1 <= arg0.nday then
				setImageAlpha(arg2, 1)
			else
				setImageAlpha(arg2, 0.3)
			end

			setActive(var0, arg1 == arg0.curShowDay)
		end
	end)

	arg0.loader = AutoLoader.New()
end

function var0.OnDataSetting(arg0)
	arg0.config = pg.activity_7_day_sign[arg0.activity:getConfig("config_id")]
	arg0.allDaycount = #arg0.config.front_drops
	arg0.nday = arg0.activity.data1
	arg0.curShowDay = arg0.nday
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data1
	arg0.curShowDay = arg0.nday

	arg0:updateAwardInfo(arg0.curShowDay)
end

function var0.OnDestroy(arg0)
	arg0.loader:Clear()
end

function var0.updateAwardInfo(arg0, arg1)
	arg1 = math.max(arg1, 1)

	arg0.loader:GetOffSpriteRequest(arg0.dayProgressImg)
	arg0.loader:GetOffSpriteRequest(arg0.awardImg)
	arg0.loader:GetSprite("ui/activityuipage/animelogin_atlas", "tianshu_" .. arg1, arg0.dayProgressImg, true)
	arg0.loader:GetSprite("ui/activityuipage/animemidtermloginpage_atlas", "icon_" .. arg1, arg0.awardImg, true)
	setActive(arg0.maskImg, arg1 <= arg0.nday)
	setActive(arg0.arrowLeft, arg1 ~= 1)
	setActive(arg0.arrowRight, arg1 ~= arg0.allDaycount)
	arg0.pointUIItemList:align(arg0.allDaycount)
end

return var0
