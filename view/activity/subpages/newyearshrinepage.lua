local var0 = class("NewYearShrinePage", import("...base.BaseActivityPage"))

var0.MAX_COUNT = 7
var0.GO_MINI_GAME_ID = 34
var0.GO_BACKHILL_SCENE = SCENE.NEWYEAR_BACKHILL_2022

function var0.OnInit(arg0)
	arg0.progressTpl = arg0:findTF("ProgressTpl")
	arg0.progressTplContainer = arg0:findTF("ProgressList")
	arg0.progressUIItemList = UIItemList.New(arg0.progressTplContainer, arg0.progressTpl)
	arg0.countText = arg0:findTF("CountText")

	local var0 = arg0:findTF("Award")

	arg0.lockTF = arg0:findTF("Unlock", var0)
	arg0.getBtn = arg0:findTF("Achieve", var0)
	arg0.gotTag = arg0:findTF("Got", var0)
	arg0.goBtn = arg0:findTF("GoBtn")
end

function var0.OnDataSetting(arg0)
	arg0.isAchieved = arg0.activity.data1
	arg0.playCount = arg0.activity.data2
	arg0.startTimestamp = arg0.activity.data3
	arg0.dayFromStart = pg.TimeMgr.GetInstance():DiffDay(arg0.startTimestamp, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0.curDay = math.clamp(arg0.dayFromStart, 1, var0.MAX_COUNT)
	arg0.storyIDTable = {}

	local var0 = arg0.activity:getConfig("config_client").story

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			local var1 = iter1[1]

			if var1 then
				arg0.storyIDTable[iter0] = var1
			end
		end
	end
end

function var0.OnFirstFlush(arg0)
	local var0 = math.clamp(arg0.playCount, 0, var0.MAX_COUNT)

	setText(arg0.countText, var0)
	arg0.progressUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0:findTF("Achieve", arg2)
			local var1 = arg0:findTF("Unlock", arg2)
			local var2 = arg0:findTF("Lock", arg2)

			setActive(var2, not (arg1 <= arg0.curDay))

			if arg1 <= arg0.curDay then
				setActive(var0, arg1 <= var0)
				setActive(var1, arg1 > var0)
			else
				setActive(var0, false)
				setActive(var1, true)
			end
		end
	end)
	arg0.progressUIItemList:align(var0.MAX_COUNT)
	onButton(arg0, arg0.getBtn, function()
		if arg0.curDay >= var0.MAX_COUNT and arg0.playCount >= var0.MAX_COUNT and not (arg0.isAchieved > 0) then
			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0.activity.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0.GO_MINI_GAME_ID, {
			callback = function()
				local var0 = Context.New()

				SCENE.SetSceneInfo(var0, var0.GO_BACKHILL_SCENE)
				getProxy(ContextProxy):PushContext2Prev(var0)
			end
		})
	end, SFX_PANEL)

	local var1 = {}
	local var2 = pg.NewStoryMgr.GetInstance()
	local var3 = math.clamp(arg0.playCount, 0, var0.MAX_COUNT)

	for iter0 = 1, var0.MAX_COUNT do
		local var4 = arg0.storyIDTable[iter0]

		if var4 and iter0 <= arg0.curDay and iter0 <= var3 then
			table.insert(var1, function(arg0)
				var2:Play(var4, arg0)
			end)
		end
	end

	seriesAsync(var1, function()
		print("play story done,count:", #var1)
	end)
end

function var0.OnUpdateFlush(arg0)
	setActive(arg0.gotTag, arg0.isAchieved > 0)

	if arg0.curDay >= var0.MAX_COUNT and arg0.playCount >= var0.MAX_COUNT and not (arg0.isAchieved > 0) then
		setActive(arg0.lockTF, false)
		setActive(arg0.getBtn, true)
		triggerButton(arg0.getBtn)
	elseif arg0.isAchieved > 0 then
		setActive(arg0.lockTF, false)
		setActive(arg0.getBtn, true)
	else
		setActive(arg0.lockTF, true)
		setActive(arg0.getBtn, false)
	end
end

function var0.OnDestroy(arg0)
	return
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEWYEAR_SHRINE_PAGE_ID.act_id)

	if var0 and not var0:isEnd() then
		local var1 = pg.TimeMgr.GetInstance():DiffDay(var0.data3, pg.TimeMgr.GetInstance():GetServerTime()) + 1

		return math.clamp(var1, 1, var0.MAX_COUNT) > math.clamp(var0.data2, 0, var0.MAX_COUNT)
	end
end

return var0
