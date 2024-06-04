local var0 = class("AprilFoolDiscovery2024Page", import(".AprilFoolDiscoveryRePage"))
local var1 = "goldenawake"

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")

	local var0 = arg0:findTF("AD/List")

	arg0.items = CustomIndexLayer.Clone2Full(var0, 11)
	arg0.selectIndex = 0
	arg0.btnHelp = arg0.bg:Find("help_btn")
	arg0.btnBattle = arg0.bg:Find("battle_btn")
	arg0.tip = arg0.bg:Find("tip")
	arg0.slider = arg0.bg:Find("slider")
	arg0.leftTime = arg0.slider:Find("time")
	arg0.loader = AutoLoader.New()

	for iter0 = 1, #var1 do
		arg0.loader:GetSprite("ui/activityuipage/AprilFoolDiscovery2024Page_atlas", string.sub(var1, iter0, iter0), arg0.items[iter0]:Find("Character"))
	end

	arg0._funcsLink = {}
end

function var0.OnDataSetting(arg0)
	local var0 = var0.super.OnDataSetting(arg0)

	local function var1()
		if arg0.activity.data1 == 1 and arg0.activity.data3 == 1 then
			arg0.activity.data3 = 0

			pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
				cmd = 4,
				actId = arg0.activity.id
			})

			return true
		end
	end

	var0 = var0 or var1()

	return var0
end

function var0.OnFirstFlush(arg0)
	local var0 = pg.activity_event_picturepuzzle[arg0.activity.id]

	assert(var0, "Can't Find activity_event_picturepuzzle 's ID : " .. arg0.activity.id)

	arg0.puzzleConfig = var0
	arg0.keyList = Clone(var0.pickup_picturepuzzle)

	table.insertto(arg0.keyList, var0.drop_picturepuzzle)
	assert(#arg0.keyList == #arg0.items, string.format("keyList has {0}, but items has {1}", #arg0.keyList, #arg0.items))
	table.sort(arg0.keyList)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.caibulin_help.tip
		})
	end, SFX_PANEL)

	local var1 = arg0.activity.id

	onButton(arg0, arg0.btnBattle, function()
		if #arg0.activity.data2_list < #arg0.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("caibulin_lock_tip"))

			return
		end

		local var0 = arg0.puzzleConfig.chapter

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
			local var1 = var0:getActivityById(var1)

			if var1.data1 == 1 then
				return
			end

			var1.data3 = 1

			var0:updateActivity(var1)
		end)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0

	var0 = arg0.activity.data1 >= 1

	local var1 = #arg0.activity.data2_list == #arg0.keyList
	local var2 = arg0.activity.data2_list
	local var3 = arg0.activity.data3_list

	for iter0, iter1 in ipairs(arg0.items) do
		local var4 = arg0.keyList[iter0]
		local var5 = table.contains(var2, var4) and 3 or table.contains(var3, var4) and 2 or 1

		onButton(arg0, iter1, function()
			if var5 >= 3 then
				return
			end

			if var5 == 2 then
				arg0.selectIndex = iter0

				arg0:UpdateSelection()

				return
			elseif var5 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < arg0.activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = arg0.activity.id,
							id = var4
						})

						arg0.selectIndex = iter0
					end
				})
			end
		end)
		setActive(iter1:Find("Character"), var5 == 3)
		setActive(iter1:Find("Unlock"), var5 == 2)
		setActive(iter1:Find("Locked"), var5 == 1)
	end

	setActive(arg0.btnBattle:Find("Lock"), not var1)
	arg0:UpdateSelection()

	local var6 = pg.activity_event_picturepuzzle[arg0.activity.id]

	if #table.mergeArray(arg0.activity.data1_list, arg0.activity.data2_list, true) >= #var6.pickup_picturepuzzle + #var6.drop_picturepuzzle then
		local var7 = arg0.activity:getConfig("config_client").comStory

		arg0:AddFunc(function(arg0)
			pg.NewStoryMgr.GetInstance():Play(var7, arg0)
		end)
	end
end

function var0.UpdateSelection(arg0)
	local var0 = arg0.keyList[arg0.selectIndex]
	local var1 = table.contains(arg0.activity.data3_list, var0)

	setText(arg0.tip, var1 and i18n("caibulin_tip" .. arg0.selectIndex) or "")
	arg0:CreateCDTimer()
end

return var0
