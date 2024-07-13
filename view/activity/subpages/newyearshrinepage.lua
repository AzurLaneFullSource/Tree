local var0_0 = class("NewYearShrinePage", import("...base.BaseActivityPage"))

var0_0.MAX_COUNT = 7
var0_0.GO_MINI_GAME_ID = 34
var0_0.GO_BACKHILL_SCENE = SCENE.NEWYEAR_BACKHILL_2022

function var0_0.OnInit(arg0_1)
	arg0_1.progressTpl = arg0_1:findTF("ProgressTpl")
	arg0_1.progressTplContainer = arg0_1:findTF("ProgressList")
	arg0_1.progressUIItemList = UIItemList.New(arg0_1.progressTplContainer, arg0_1.progressTpl)
	arg0_1.countText = arg0_1:findTF("CountText")

	local var0_1 = arg0_1:findTF("Award")

	arg0_1.lockTF = arg0_1:findTF("Unlock", var0_1)
	arg0_1.getBtn = arg0_1:findTF("Achieve", var0_1)
	arg0_1.gotTag = arg0_1:findTF("Got", var0_1)
	arg0_1.goBtn = arg0_1:findTF("GoBtn")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.isAchieved = arg0_2.activity.data1
	arg0_2.playCount = arg0_2.activity.data2
	arg0_2.startTimestamp = arg0_2.activity.data3
	arg0_2.dayFromStart = pg.TimeMgr.GetInstance():DiffDay(arg0_2.startTimestamp, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0_2.curDay = math.clamp(arg0_2.dayFromStart, 1, var0_0.MAX_COUNT)
	arg0_2.storyIDTable = {}

	local var0_2 = arg0_2.activity:getConfig("config_client").story

	if var0_2 then
		for iter0_2, iter1_2 in ipairs(var0_2) do
			local var1_2 = iter1_2[1]

			if var1_2 then
				arg0_2.storyIDTable[iter0_2] = var1_2
			end
		end
	end
end

function var0_0.OnFirstFlush(arg0_3)
	local var0_3 = math.clamp(arg0_3.playCount, 0, var0_0.MAX_COUNT)

	setText(arg0_3.countText, var0_3)
	arg0_3.progressUIItemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg1_4 = arg1_4 + 1

			local var0_4 = arg0_3:findTF("Achieve", arg2_4)
			local var1_4 = arg0_3:findTF("Unlock", arg2_4)
			local var2_4 = arg0_3:findTF("Lock", arg2_4)

			setActive(var2_4, not (arg1_4 <= arg0_3.curDay))

			if arg1_4 <= arg0_3.curDay then
				setActive(var0_4, arg1_4 <= var0_3)
				setActive(var1_4, arg1_4 > var0_3)
			else
				setActive(var0_4, false)
				setActive(var1_4, true)
			end
		end
	end)
	arg0_3.progressUIItemList:align(var0_0.MAX_COUNT)
	onButton(arg0_3, arg0_3.getBtn, function()
		if arg0_3.curDay >= var0_0.MAX_COUNT and arg0_3.playCount >= var0_0.MAX_COUNT and not (arg0_3.isAchieved > 0) then
			arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0_3.activity.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_0.GO_MINI_GAME_ID, {
			callback = function()
				local var0_7 = Context.New()

				SCENE.SetSceneInfo(var0_7, var0_0.GO_BACKHILL_SCENE)
				getProxy(ContextProxy):PushContext2Prev(var0_7)
			end
		})
	end, SFX_PANEL)

	local var1_3 = {}
	local var2_3 = pg.NewStoryMgr.GetInstance()
	local var3_3 = math.clamp(arg0_3.playCount, 0, var0_0.MAX_COUNT)

	for iter0_3 = 1, var0_0.MAX_COUNT do
		local var4_3 = arg0_3.storyIDTable[iter0_3]

		if var4_3 and iter0_3 <= arg0_3.curDay and iter0_3 <= var3_3 then
			table.insert(var1_3, function(arg0_8)
				var2_3:Play(var4_3, arg0_8)
			end)
		end
	end

	seriesAsync(var1_3, function()
		print("play story done,count:", #var1_3)
	end)
end

function var0_0.OnUpdateFlush(arg0_10)
	setActive(arg0_10.gotTag, arg0_10.isAchieved > 0)

	if arg0_10.curDay >= var0_0.MAX_COUNT and arg0_10.playCount >= var0_0.MAX_COUNT and not (arg0_10.isAchieved > 0) then
		setActive(arg0_10.lockTF, false)
		setActive(arg0_10.getBtn, true)
		triggerButton(arg0_10.getBtn)
	elseif arg0_10.isAchieved > 0 then
		setActive(arg0_10.lockTF, false)
		setActive(arg0_10.getBtn, true)
	else
		setActive(arg0_10.lockTF, true)
		setActive(arg0_10.getBtn, false)
	end
end

function var0_0.OnDestroy(arg0_11)
	return
end

function var0_0.IsTip()
	local var0_12 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEWYEAR_SHRINE_PAGE_ID.act_id)

	if var0_12 and not var0_12:isEnd() then
		local var1_12 = pg.TimeMgr.GetInstance():DiffDay(var0_12.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1

		return math.clamp(var1_12, 1, var0_0.MAX_COUNT) > math.clamp(var0_12.data2, 0, var0_0.MAX_COUNT)
	end
end

return var0_0
