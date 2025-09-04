pg = pg or {}

local var0_0 = singletonClass("IslandVisitorNotificationMgr")

pg.IslandVisitorNotificationMgr = var0_0

local var1_0 = 5

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.schedule = {}

	LoadAndInstantiateAsync("ui", "IslandVisitorNotificationUI", function(arg0_2)
		arg0_1.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_2.transform:SetParent(arg0_1.UIOverlay.transform, false)

		arg0_1._tf = arg0_2.transform
		arg0_1.contentTxt = arg0_2.transform:Find("Text"):GetComponent(typeof(Text))

		setActive(arg0_2, false)
		arg1_1()
	end, true, true)
end

function var0_0.Enqueue(arg0_3, arg1_3)
	if PlayerPrefs.GetInt(ISLAND_NOTIFYCATION, 0) <= 0 then
		return
	end

	table.insert(arg0_3.schedule, arg1_3)

	if #arg0_3.schedule == 1 then
		arg0_3:StartTask()
	end
end

function var0_0.StartTask(arg0_4)
	local var0_4 = arg0_4.schedule[1]

	arg0_4:ShowContent(var0_4, function()
		table.remove(arg0_4.schedule, 1)

		if #arg0_4.schedule > 0 then
			arg0_4:StartTask()
		end
	end)
end

function var0_0.ShowContent(arg0_6, arg1_6, arg2_6)
	setActive(arg0_6._tf, true)

	arg0_6.contentTxt.text = arg1_6:BuildWhitoutTime()

	arg0_6:RemoveTimer()

	local var0_6 = Timer.New(function()
		arg0_6:RemoveTimer()
		arg0_6:HideContent()
		arg2_6()
	end, var1_0, 1)

	var0_6:Start()

	arg0_6.timer = var0_6
end

function var0_0.HideContent(arg0_8)
	arg0_8.contentTxt.text = ""

	setActive(arg0_8._tf, false)
end

function var0_0.RemoveTimer(arg0_9)
	if arg0_9.timer then
		arg0_9.timer:Stop()

		arg0_9.timer = nil
	end
end

function var0_0.Quit(arg0_10)
	arg0_10:RemoveTimer()
	arg0_10:HideContent()

	arg0_10.schedule = {}
end
