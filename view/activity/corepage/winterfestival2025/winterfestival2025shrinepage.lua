local var0_0 = class("WinterFestival2025ShrinePage", import("view.activity.CorePage.CoreActivityPage"))

var0_0.GO_MINI_GAME_ID = 80

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025ShrinePage"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = arg0_2._tf:Find("AD")

	arg0_2.progressTpl = var0_2:Find("progress_tpl")
	arg0_2.progressTplContainer = var0_2:Find("progress")
	arg0_2.progressUIItemList = UIItemList.New(arg0_2.progressTplContainer, arg0_2.progressTpl)

	local var1_2 = var0_2:Find("Award")

	arg0_2.lockTF = var1_2:Find("Unlock")
	arg0_2.getTag = var1_2:Find("Achieve")
	arg0_2.gotTag = var1_2:Find("Got")
	arg0_2.goBtn = var0_2:Find("btn_go")
	arg0_2.goBtnRedDot = arg0_2.goBtn:Find("red")
	arg0_2.gotBtn = var0_2:Find("btn_got")
	arg0_2.getBtn = var0_2:Find("btn_get")

	setActive(arg0_2.gotBtn, false)
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.isAchieved = arg0_3.activity.data1
	arg0_3.playCount = arg0_3.activity.data2
	arg0_3.startTimestamp = arg0_3.activity.data3
	arg0_3.maxDay = arg0_3.activity:getConfig("config_id")
	arg0_3.dayFromStart = pg.TimeMgr.GetInstance():DiffDay(arg0_3.startTimestamp, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0_3.curDay = math.clamp(arg0_3.dayFromStart, 1, arg0_3.maxDay)
	arg0_3.storyIDTable = {}

	local var0_3 = arg0_3.activity:getConfig("config_client")

	if var0_3 and type(var0_3) == "table" then
		local var1_3 = var0_3.story

		if var1_3 then
			for iter0_3, iter1_3 in ipairs(var1_3) do
				local var2_3 = iter1_3[1]

				if var2_3 then
					arg0_3.storyIDTable[iter0_3] = var2_3
				end
			end
		end
	end

	print(tostring(arg0_3.isAchieved), tostring(arg0_3.playCount), tostring(arg0_3.curDay))
end

function var0_0.OnFirstFlush(arg0_4)
	local var0_4 = math.clamp(arg0_4.playCount, 0, arg0_4.maxDay)

	arg0_4.progressUIItemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg1_5 = arg1_5 + 1

			if arg1_5 <= arg0_4.curDay then
				setActive(arg2_5, arg1_5 <= var0_4)
			else
				setActive(arg2_5, false)
			end
		end
	end)
	arg0_4.progressUIItemList:align(arg0_4.maxDay)
	onButton(arg0_4, arg0_4.getBtn, function()
		if arg0_4.curDay >= arg0_4.maxDay and arg0_4.playCount >= arg0_4.maxDay and not (arg0_4.isAchieved > 0) then
			arg0_4:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0_4.activity.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_0.GO_MINI_GAME_ID, {})
	end, SFX_PANEL)

	local var1_4 = {}
	local var2_4 = pg.NewStoryMgr.GetInstance()
	local var3_4 = math.clamp(arg0_4.playCount, 0, arg0_4.maxDay)

	for iter0_4 = 1, arg0_4.maxDay do
		local var4_4 = arg0_4.storyIDTable[iter0_4]

		if var4_4 and iter0_4 <= arg0_4.curDay and iter0_4 <= var3_4 then
			table.insert(var1_4, function(arg0_8)
				var2_4:Play(var4_4, arg0_8)
			end)
		end
	end

	seriesAsync(var1_4, function()
		print("play story done,count:", #var1_4)
	end)
end

function var0_0.OnUpdateFlush(arg0_10)
	setActive(arg0_10.gotTag, arg0_10.isAchieved > 0)
	setActive(arg0_10.goBtnRedDot, Shrine2022View.IsNeedShowTipForShipCount())

	if arg0_10.curDay >= arg0_10.maxDay and arg0_10.playCount >= arg0_10.maxDay and not (arg0_10.isAchieved > 0) then
		setActive(arg0_10.lockTF, false)
		setActive(arg0_10.getTag, true)
		setActive(arg0_10.getBtn, true)
		setActive(arg0_10.goBtn, false)
	elseif arg0_10.isAchieved > 0 then
		setActive(arg0_10.lockTF, false)
		setActive(arg0_10.getTag, true)
		setActive(arg0_10.getBtn, false)
		setActive(arg0_10.goBtn, true)
	else
		setActive(arg0_10.lockTF, true)
		setActive(arg0_10.getTag, false)
		setActive(arg0_10.getBtn, false)
		setActive(arg0_10.goBtn, true)
	end
end

return var0_0
