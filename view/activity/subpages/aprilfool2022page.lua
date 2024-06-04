local var0 = class("AprilFool2022Page", import("view.base.BaseActivityPage"))

var0.Order = {
	1,
	3,
	2
}

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.selectIndex = 0
	arg0.stars = {}

	for iter0 = 1, 3 do
		arg0.stars[iter0] = arg0.bg:Find("Star" .. iter0)
	end

	arg0.clickIndex = 0
	arg0.btnBattle = arg0.bg:Find("Battle_btn")
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_client")

	if type(var0) == "table" and var0[2] and type(var0[2]) == "string" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0[2]) then
		pg.NewStoryMgr.GetInstance():Play(var0[2], nil, true, true)
	end

	if arg0.activity.data2 == 0 and arg0.activity.data3 == 1 then
		arg0.activity.data3 = 0

		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = arg0.activity.id
		})

		return true
	end

	if arg0.activity.data1 == 0 then
		local var1 = arg0.activity:getStartTime()
		local var2 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg0.activity:getConfig("config_client").autounlock <= var2 - var1 then
			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				arg1 = 1,
				cmd = 1,
				activity_id = arg0.activity.id
			})

			return true
		end
	end
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.btnBattle, function()
		local var0 = arg0.activity:getConfig("config_client").stageid

		arg0:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = var0
		}, function()
			if not pg.NewStoryMgr.GetInstance():IsPlayed(tostring(var0), true) then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = tostring(var0)
				})
			end

			local var0 = getProxy(ActivityProxy)
			local var1 = var0:getActivityById(arg0.activity.id)

			if var1.data2 > 0 then
				return
			end

			var1.data3 = 1

			var0:updateActivity(var1)
		end)
	end, SFX_PANEL)

	local function var0(arg0, arg1, arg2)
		local var0 = GetOrAddComponent(arg1, "ButtonEventExtend").onPointerDown

		pg.DelegateInfo.Add(arg0, var0)
		var0:RemoveAllListeners()
		var0:AddListener(function()
			if arg0.activity.data1 ~= 0 then
				return
			end

			local var0
			local var1 = arg2 ~= arg0.Order[arg0.clickIndex + 1] and "event:/ui/shibai" or "event:/ui/deng" .. arg0.clickIndex + 1

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1)
		end)
	end

	table.Foreach(arg0.stars, function(arg0, arg1)
		onButton(arg0, arg1, function()
			if arg0.activity.data1 ~= 0 then
				return
			end

			if arg0 ~= arg0.Order[arg0.clickIndex + 1] then
				arg0.clickIndex = 0

				arg0:OnUpdateFlush()

				return
			end

			arg0.clickIndex = arg0.clickIndex + 1

			arg0:OnUpdateFlush()

			if arg0.clickIndex < #arg0.Order then
				return
			end

			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				arg1 = 1,
				cmd = 1,
				activity_id = arg0.activity.id
			})
		end)
		var0(arg0, arg1, arg0)
	end)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setActive(arg0.btnBattle, arg0.activity.data1 ~= 0)
	SetCompomentEnabled(arg0.btnBattle, "Animator", arg0.activity.data2 == 0)
	table.Foreach(arg0.Order, function(arg0, arg1)
		setActive(arg0.stars[arg1]:Find("Effect"), arg0 <= arg0.clickIndex or arg0.activity.data1 ~= 0)
	end)
end

return var0
