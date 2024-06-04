local var0 = class("AprilFoolDiscoveryRePage", import(".AprilFoolDiscoveryPage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.bulin = arg0.bg:Find("bulin")
	arg0.bulinAnim = arg0.bulin:Find("bulin"):GetComponent("SpineAnimUI")

	setText(arg0.bulin:Find("Text"), i18n("super_bulin_tip"))
	setActive(arg0.bulin, false)

	arg0._funcsLink = {}
end

function var0.AddFunc(arg0, arg1)
	table.insert(arg0._funcsLink, arg1)

	if #arg0._funcsLink > 1 then
		return
	end

	arg0:PlayFuncsLink()
end

function var0.PlayFuncsLink(arg0)
	local var0 = false
	local var1

	local function var2(...)
		if var0 then
			table.remove(arg0._funcsLink, 1)
		end

		var0 = true

		local var0 = arg0._funcsLink[1]

		if var0 then
			var0(var2, ...)
		end
	end

	var2()
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
	assert(#arg0.keyList == #arg0.items, string.format("keyList has {0}, but items has 9", #arg0.keyList))
	table.sort(arg0.keyList)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.bulin_help.tip
		})
	end, SFX_PANEL)

	local var1 = arg0.activity.id

	onButton(arg0, arg0.btnBattle, function()
		if #arg0.activity.data2_list < #arg0.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))

			return
		end

		arg0:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = arg0.puzzleConfig.chapter
		}, function()
			local var0 = getProxy(ActivityProxy)
			local var1 = var0:getActivityById(var1)

			if var1.data1 == 1 then
				return
			end

			var1.data3 = 1

			var0:updateActivity(var1)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.bulin, function()
		if arg0.activity.data1 >= 1 then
			seriesAsync({
				function(arg0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("super_bulin"),
						onYes = arg0
					})
				end,
				function(arg0)
					arg0:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
						warnMsg = "bulin_tip_other3",
						stageId = arg0:GetLinkStage()
					}, function()
						local var0 = getProxy(ActivityProxy)
						local var1 = var0:getActivityById(var1)

						if var1.data1 == 2 then
							return
						end

						var1.data3 = 1

						var0:updateActivity(var1)
					end)
				end
			})
		end
	end)

	local var2 = arg0.activity:getConfig("config_client").guideName

	arg0:AddFunc(function(arg0)
		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var2, nil, arg0)
	end)
end

local var1 = {
	"lock",
	"hint",
	"unlock"
}

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1 >= 1
	local var1 = #arg0.activity.data2_list == #arg0.keyList
	local var2 = var0 and "activity_bg_aprilfool_final" or "activity_bg_aprilfool_discovery"

	if var2 ~= arg0.bgName then
		setImageSprite(arg0.bg, LoadSprite("ui/activityuipage/AprilFoolDiscoveryRePage_atlas", var2))

		arg0.bg:GetComponent(typeof(Image)).enabled = true
		arg0.bgName = var2
	end

	local var3 = arg0.activity.data2_list
	local var4 = arg0.activity.data3_list

	for iter0, iter1 in ipairs(arg0.items) do
		local var5 = arg0.keyList[iter0]
		local var6 = table.contains(var3, var5) and 3 or table.contains(var4, var5) and 2 or 1

		onButton(arg0, iter1, function()
			if var6 >= 3 then
				return
			end

			if var6 == 2 then
				arg0.selectIndex = iter0

				arg0:UpdateSelection()

				return
			elseif var6 == 1 then
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
							id = var5
						})

						arg0.selectIndex = iter0
					end
				})
			end
		end)
		arg0.loader:GetSprite("UI/ActivityUIPage/AprilFoolDiscoveryRePage_atlas", var1[var6], iter1:Find("state"))
		setActive(iter1:Find("character"), var6 == 3)
	end

	setActive(arg0.btnBattle, var1)
	setActive(arg0.btnIncomplete, not var1)
	arg0:UpdateSelection()
	setActive(arg0.bulin, var0)

	if arg0.activity.data1 == 1 then
		local var7 = arg0.activity:getConfig("config_client").popStory

		arg0:AddFunc(function(arg0)
			pg.NewStoryMgr.GetInstance():Play(var7, arg0)
		end)
		arg0:AddFunc(function(arg0)
			local var0 = getProxy(PlayerProxy):getRawData()

			if PlayerPrefs.GetInt("SuperBurinPopUp_" .. var0.id, 0) == 0 then
				LoadContextCommand.LoadLayerOnTopContext(Context.New({
					mediator = SuperBulinPopMediator,
					viewComponent = SuperBulinPopView,
					data = {
						stageId = arg0:GetLinkStage(),
						actId = arg0.activity.id,
						onRemoved = arg0
					}
				}))
				PlayerPrefs.SetInt("SuperBurinPopUp_" .. var0.id, 1)
			end
		end)
	end
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)
end

function var0.GetLinkStage(arg0)
	return arg0.activity:getConfig("config_client").lastChapter
end

return var0
