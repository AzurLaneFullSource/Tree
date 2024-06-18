local var0_0 = class("AprilFool2022Page", import("view.base.BaseActivityPage"))

var0_0.Order = {
	1,
	3,
	2
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.selectIndex = 0
	arg0_1.stars = {}

	for iter0_1 = 1, 3 do
		arg0_1.stars[iter0_1] = arg0_1.bg:Find("Star" .. iter0_1)
	end

	arg0_1.clickIndex = 0
	arg0_1.btnBattle = arg0_1.bg:Find("Battle_btn")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client")

	if type(var0_2) == "table" and var0_2[2] and type(var0_2[2]) == "string" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_2[2]) then
		pg.NewStoryMgr.GetInstance():Play(var0_2[2], nil, true, true)
	end

	if arg0_2.activity.data2 == 0 and arg0_2.activity.data3 == 1 then
		arg0_2.activity.data3 = 0

		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = arg0_2.activity.id
		})

		return true
	end

	if arg0_2.activity.data1 == 0 then
		local var1_2 = arg0_2.activity:getStartTime()
		local var2_2 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg0_2.activity:getConfig("config_client").autounlock <= var2_2 - var1_2 then
			arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
				arg1 = 1,
				cmd = 1,
				activity_id = arg0_2.activity.id
			})

			return true
		end
	end
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.btnBattle, function()
		local var0_4 = arg0_3.activity:getConfig("config_client").stageid

		arg0_3:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = var0_4
		}, function()
			if not pg.NewStoryMgr.GetInstance():IsPlayed(tostring(var0_4), true) then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = tostring(var0_4)
				})
			end

			local var0_5 = getProxy(ActivityProxy)
			local var1_5 = var0_5:getActivityById(arg0_3.activity.id)

			if var1_5.data2 > 0 then
				return
			end

			var1_5.data3 = 1

			var0_5:updateActivity(var1_5)
		end)
	end, SFX_PANEL)

	local function var0_3(arg0_6, arg1_6, arg2_6)
		local var0_6 = GetOrAddComponent(arg1_6, "ButtonEventExtend").onPointerDown

		pg.DelegateInfo.Add(arg0_6, var0_6)
		var0_6:RemoveAllListeners()
		var0_6:AddListener(function()
			if arg0_3.activity.data1 ~= 0 then
				return
			end

			local var0_7
			local var1_7 = arg2_6 ~= arg0_3.Order[arg0_3.clickIndex + 1] and "event:/ui/shibai" or "event:/ui/deng" .. arg0_3.clickIndex + 1

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_7)
		end)
	end

	table.Foreach(arg0_3.stars, function(arg0_8, arg1_8)
		onButton(arg0_3, arg1_8, function()
			if arg0_3.activity.data1 ~= 0 then
				return
			end

			if arg0_8 ~= arg0_3.Order[arg0_3.clickIndex + 1] then
				arg0_3.clickIndex = 0

				arg0_3:OnUpdateFlush()

				return
			end

			arg0_3.clickIndex = arg0_3.clickIndex + 1

			arg0_3:OnUpdateFlush()

			if arg0_3.clickIndex < #arg0_3.Order then
				return
			end

			arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
				arg1 = 1,
				cmd = 1,
				activity_id = arg0_3.activity.id
			})
		end)
		var0_3(arg0_3, arg1_8, arg0_8)
	end)
end

function var0_0.OnUpdateFlush(arg0_10)
	var0_0.super.OnUpdateFlush(arg0_10)
	setActive(arg0_10.btnBattle, arg0_10.activity.data1 ~= 0)
	SetCompomentEnabled(arg0_10.btnBattle, "Animator", arg0_10.activity.data2 == 0)
	table.Foreach(arg0_10.Order, function(arg0_11, arg1_11)
		setActive(arg0_10.stars[arg1_11]:Find("Effect"), arg0_11 <= arg0_10.clickIndex or arg0_10.activity.data1 ~= 0)
	end)
end

return var0_0
