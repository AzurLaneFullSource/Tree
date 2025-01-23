local var0_0 = class("FireworkAndSpringScene", import("view.activity.BackHills.TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "FireworkAndSpringUI"
end

var0_0.edge2area = {
	default = "_SDPlace"
}
var0_0.EffectPoolCnt = 3
var0_0.Id2EffectName = {
	[65522] = "yanhua_02",
	[65521] = "yanhua_01",
	[65529] = "yanhua_xinxin",
	[65530] = "yanhua_xiaojiajia",
	[65528] = "yanhua_jiezhi",
	[70175] = "yanhua_2024",
	[65527] = "yanhua_huangji",
	[65524] = "yanhua_denglong",
	[65526] = "yanhua_chuanmao",
	[65523] = "yanhua_maomao",
	[65525] = "yanhua_2025",
	[65532] = "yanhua_she",
	[65531] = "yanhua_hongbao",
	[70178] = "yanhua_denglong"
}
var0_0.FireworkRange = Vector2(300, 300)
var0_0.EffectPosLimit = {
	limitX = {
		-700,
		700
	},
	limitY = {
		250,
		500
	}
}
var0_0.EffectInterval = 1
var0_0.DelayPop = 2.5
var0_0.SFX_LIST = {
	"event:/ui/firework1",
	"event:/ui/firework2",
	"event:/ui/firework3",
	"event:/ui/firework4"
}

function var0_0.init(arg0_2)
	arg0_2:InitData()
	var0_0.super.init(arg0_2)

	arg0_2._map = arg0_2:findTF("map")
	arg0_2._shipTpl = arg0_2:findTF("ship")
	arg0_2.fireworksTF = arg0_2:findTF("fireworks")
	arg0_2._SDPlace = arg0_2:findTF("SDPlace")
	arg0_2.containers = {
		arg0_2._SDPlace
	}
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.FireworkAndSpringGraph"))
	arg0_2.backBtn = arg0_2:findTF("panel/btn_back")
	arg0_2.tipBtn = arg0_2:findTF("panel/btn_tip")
	arg0_2.ptBtn = arg0_2:findTF("panel/btn_pt")
	arg0_2.stage = arg0_2:findTF("panel/btn_pt/stage")
	arg0_2.pt = arg0_2:findTF("panel/btn_pt/pt")
	arg0_2.taskBtn = arg0_2:findTF("panel/btn_task")
	arg0_2.fireworkBtn = arg0_2:findTF("panel/btn_firework")
	arg0_2.springBtn = arg0_2:findTF("panel/btn_spring")
	arg0_2.subPanel = arg0_2:findTF("subPanel")
	arg0_2.subPanelPanel = arg0_2:findTF("panel", arg0_2.subPanel)
	arg0_2.subLeft = arg0_2:findTF("left", arg0_2.subPanelPanel)
	arg0_2.subRight = arg0_2:findTF("right", arg0_2.subPanelPanel)
	arg0_2.subPtBtn = arg0_2:findTF("ptBtn", arg0_2.subLeft)
	arg0_2.subTaskBtn = arg0_2:findTF("taskBtn", arg0_2.subLeft)
	arg0_2.subFireworkBtn = arg0_2:findTF("fireworkBtn", arg0_2.subLeft)
	arg0_2.subSpringBtn = arg0_2:findTF("springBtn", arg0_2.subLeft)
	arg0_2.ptPanel = arg0_2:findTF("ptPanel", arg0_2.subRight)
	arg0_2.taskPanel = arg0_2:findTF("taskPanel", arg0_2.subRight)
	arg0_2.fireworkPanel = arg0_2:findTF("fireworkPanel", arg0_2.subRight)
	arg0_2.springPanel = arg0_2:findTF("springPanel", arg0_2.subRight)
end

function var0_0.didEnter(arg0_3)
	arg0_3:UpdateMainPt()

	arg0_3.firePools = {}

	arg0_3:PlayFireworks()
	arg0_3:InitStudents()
	arg0_3:SetTips()
	arg0_3:CloseSubPanel()

	arg0_3.hasClonedFireworkArrows = false

	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end)
	onButton(arg0_3, arg0_3.tipBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.firework_2025_tip.tip
		})
	end)
	onButton(arg0_3, arg0_3.ptBtn, function()
		arg0_3:OpenSubPanel(arg0_3.ptPanel)
		arg0_3:SetPtPanel()
	end)
	onButton(arg0_3, arg0_3.taskBtn, function()
		arg0_3:OpenSubPanel(arg0_3.taskPanel)
		arg0_3:SetTaskPanel()
	end)
	onButton(arg0_3, arg0_3.fireworkBtn, function()
		arg0_3:OpenSubPanel(arg0_3.fireworkPanel)
		arg0_3:SetFireWorkPanel()
	end)
	onButton(arg0_3, arg0_3.springBtn, function()
		arg0_3:OpenSubPanel(arg0_3.springPanel)
		arg0_3:SetSpringPanel()
	end)
	onButton(arg0_3, arg0_3.subPanel, function()
		arg0_3:CloseSubPanel()
		arg0_3:PlayFireworks()
	end)
	onButton(arg0_3, arg0_3:findTF("btnClose", arg0_3.ptPanel), function()
		arg0_3:CloseSubPanel()
		arg0_3:PlayFireworks()
	end)
	onButton(arg0_3, arg0_3:findTF("btnClose", arg0_3.taskPanel), function()
		arg0_3:CloseSubPanel()
		arg0_3:PlayFireworks()
	end)
	onButton(arg0_3, arg0_3:findTF("btnClose", arg0_3.fireworkPanel), function()
		arg0_3:CloseSubPanel()
		arg0_3:PlayFireworks()
	end)
	onButton(arg0_3, arg0_3:findTF("btnClose", arg0_3.springPanel), function()
		arg0_3:CloseSubPanel()
		arg0_3:PlayFireworks()
	end)
	onButton(arg0_3, arg0_3.subPtBtn, function()
		arg0_3:SetSubPanel(arg0_3.ptPanel)
		arg0_3:SetPtPanel()
	end)
	onButton(arg0_3, arg0_3.subTaskBtn, function()
		arg0_3:SetSubPanel(arg0_3.taskPanel)
		arg0_3:SetTaskPanel()
	end)
	onButton(arg0_3, arg0_3.subFireworkBtn, function()
		arg0_3:SetSubPanel(arg0_3.fireworkPanel)
		arg0_3:SetFireWorkPanel()
	end)
	onButton(arg0_3, arg0_3.subSpringBtn, function()
		arg0_3:SetSubPanel(arg0_3.springPanel)
		arg0_3:SetSpringPanel()
	end)
end

function var0_0.InitData(arg0_19)
	arg0_19.ptActId = ActivityConst.FireworkAndSpring_PT_ID
	arg0_19.taskActId = ActivityConst.FireworkAndSpring_TASK_ID
	arg0_19.fireworkActId = ActivityConst.FireworkAndSpring_ACT_ID
	arg0_19.springActId = ActivityConst.FireworkAndSpring_EMO_ID

	arg0_19:UpdatePtData()
	arg0_19:UpdateTaskData()
	arg0_19:UpdateFireworkData()
	arg0_19:UpdateSpringData()
end

function var0_0.UpdatePtData(arg0_20)
	arg0_20.ptActivity = getProxy(ActivityProxy):getActivityById(arg0_20.ptActId)
	arg0_20.ptData = ActivityPtData.New(arg0_20.ptActivity)
end

function var0_0.UpdateTaskData(arg0_21)
	arg0_21.taskActivity = getProxy(ActivityProxy):getActivityById(arg0_21.taskActId)
	arg0_21.taskVOs = {}

	local var0_21 = arg0_21.taskActivity:getConfig("config_data")

	for iter0_21, iter1_21 in pairs(var0_21) do
		table.insert(arg0_21.taskVOs, getProxy(TaskProxy):getTaskVO(iter1_21))
	end

	arg0_21.canGetTaskVOs = {}
	arg0_21.canGetTaskIds = {}

	arg0_21:sort(arg0_21.taskVOs)
end

function var0_0.sort(arg0_22, arg1_22)
	local var0_22 = {}

	arg0_22.canGetTaskAward = false

	for iter0_22, iter1_22 in pairs(arg1_22) do
		if iter1_22:getTaskStatus() == 1 then
			table.insert(var0_22, iter1_22)
			table.insert(arg0_22.canGetTaskVOs, iter1_22)
			table.insert(arg0_22.canGetTaskIds, iter1_22.id)

			arg0_22.canGetTaskAward = true
		end
	end

	for iter2_22, iter3_22 in pairs(arg1_22) do
		if iter3_22:getTaskStatus() == 0 then
			table.insert(var0_22, iter3_22)
		end
	end

	for iter4_22, iter5_22 in pairs(arg1_22) do
		if iter5_22:getTaskStatus() == 2 then
			table.insert(var0_22, iter5_22)
		end
	end

	arg0_22.taskVOs = var0_22
end

function var0_0.UpdateFireworkData(arg0_23)
	arg0_23.fireworkActivity = getProxy(ActivityProxy):getActivityById(arg0_23.fireworkActId)
	arg0_23.fireworkUnlockIds = arg0_23.fireworkActivity.data1_list
	arg0_23.fireworkGotIds = arg0_23.fireworkActivity.data2_list
	arg0_23.fireworkAllIds = arg0_23.fireworkActivity:GetPicturePuzzleIds()
	arg0_23.playerId = getProxy(PlayerProxy):getData().id
	arg0_23.fireworkOrderIds = arg0_23:GetFireWorkLocalData()
end

function var0_0.GetFireWorkLocalData(arg0_24)
	local var0_24 = {}

	for iter0_24 = 1, #arg0_24.fireworkAllIds do
		local var1_24 = PlayerPrefs.GetInt("fireworks_" .. arg0_24.fireworkActId .. "_" .. arg0_24.playerId .. "_pos_" .. iter0_24)

		if var1_24 ~= 0 then
			table.insert(var0_24, var1_24)
		end
	end

	return var0_24
end

function var0_0.SetFireWorkLocalData(arg0_25)
	for iter0_25 = 1, #arg0_25.fireworkAllIds do
		local var0_25 = arg0_25.fireworkOrderIds[iter0_25] or 0

		PlayerPrefs.SetInt("fireworks_" .. arg0_25.fireworkActId .. "_" .. arg0_25.playerId .. "_pos_" .. iter0_25, var0_25)
	end
end

function var0_0.UpdateSpringData(arg0_26)
	arg0_26.springActivity = getProxy(ActivityProxy):getActivityById(arg0_26.springActId)
	arg0_26.springShipIds = _.map(arg0_26.springActivity:GetShipIds(), function(arg0_27)
		if getProxy(BayProxy):RawGetShipById(arg0_27) then
			return arg0_27
		else
			return 0
		end
	end)
	arg0_26.springMaxCnt = arg0_26.springActivity:GetSlotCount()
	arg0_26.springSlotLockList = {}
	arg0_26.springUnlockSlotCount = arg0_26.springActivity:getConfig("config_client").initialCount

	for iter0_26, iter1_26 in ipairs(arg0_26.springActivity:getConfig("config_client").unlockPt) do
		if iter1_26 <= arg0_26.ptData.count then
			arg0_26.springUnlockSlotCount = arg0_26.springUnlockSlotCount + 1
		end
	end

	for iter2_26 = 1, arg0_26.springMaxCnt do
		local var0_26 = iter2_26 > arg0_26.springUnlockSlotCount

		arg0_26.springSlotLockList[iter2_26] = var0_26
	end

	arg0_26.energyRecoverAddition = arg0_26.springActivity:GetEnergyRecoverAddition() * 10
end

function var0_0.OpenSubPanel(arg0_28, arg1_28)
	setActive(arg0_28.subPanel, true)
	arg0_28:SetSubPanel(arg1_28)
	pg.UIMgr.GetInstance():BlurPanel(arg0_28.subPanelPanel)
end

function var0_0.CloseSubPanel(arg0_29)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_29.subPanelPanel, arg0_29.subPanel)
	setActive(arg0_29.subPanel, false)
end

function var0_0.SetSubPanel(arg0_30, arg1_30)
	setActive(arg0_30.ptPanel, false)
	setActive(arg0_30.taskPanel, false)
	setActive(arg0_30.fireworkPanel, false)
	setActive(arg0_30.springPanel, false)
	setActive(arg1_30, true)
	setActive(arg0_30:findTF("selected", arg0_30.subPtBtn), arg1_30 == arg0_30.ptPanel)
	setActive(arg0_30:findTF("selected", arg0_30.subTaskBtn), arg1_30 == arg0_30.taskPanel)
	setActive(arg0_30:findTF("selected", arg0_30.subFireworkBtn), arg1_30 == arg0_30.fireworkPanel)
	setActive(arg0_30:findTF("selected", arg0_30.subSpringBtn), arg1_30 == arg0_30.springPanel)
end

function var0_0.UpdateMainPt(arg0_31)
	setText(arg0_31.stage, "Lv." .. arg0_31.ptData:GetCurrLevel())

	if not arg0_31.ptData:IsMaxLevel() then
		setText(arg0_31.pt, arg0_31.ptData.count .. "/" .. arg0_31.ptData:GetNextLevelTarget())
	else
		setText(arg0_31.pt, "MAX")
	end
end

function var0_0.SetPtPanel(arg0_32)
	setText(arg0_32:findTF("lvText", arg0_32.ptPanel), arg0_32.ptData:GetCurrLevel())

	if not arg0_32.ptData:IsMaxLevel() then
		setText(arg0_32:findTF("pt", arg0_32.ptPanel), arg0_32.ptData.count .. "/" .. arg0_32.ptData:GetNextLevelTarget())
		setSlider(arg0_32:findTF("slider", arg0_32.ptPanel), 0, arg0_32.ptData:GetNextLevelTarget(), arg0_32.ptData.count)
	else
		setText(arg0_32:findTF("pt", arg0_32.ptPanel), "MAX")
		setSlider(arg0_32:findTF("slider", arg0_32.ptPanel), 0, 1, 1)
	end

	setText(arg0_32:findTF("ptScroll/Viewport/Content/tpl/get/Text", arg0_32.ptPanel), i18n("firework_2025_get"))
	setText(arg0_32:findTF("ptScroll/Viewport/Content/tpl/got/Text", arg0_32.ptPanel), i18n("firework_2025_got"))

	local var0_32 = UIItemList.New(arg0_32:findTF("ptScroll/Viewport/Content", arg0_32.ptPanel), arg0_32:findTF("ptScroll/Viewport/Content/tpl", arg0_32.ptPanel))

	var0_32:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = arg0_32.ptData.dropList[arg1_33 + 1]
			local var1_33 = arg0_32.ptData.targets[arg1_33 + 1]

			setText(arg2_33:Find("level"), i18n("firework_2025_level", arg1_33 + 1))

			local var2_33 = Drop.Create(var0_33)

			updateDrop(arg2_33:Find("award"), var2_33)
			onButton(arg0_32, arg2_33:Find("award"), function()
				arg0_32:emit(BaseUI.ON_DROP, var2_33)
			end, SFX_PANEL)

			local var3_33 = arg0_32.ptData:GetDroptItemState(arg1_33 + 1)

			if var3_33 == ActivityPtData.STATE_LOCK then
				setActive(arg2_33:Find("lock"), true)
				setActive(arg2_33:Find("get"), false)
				setActive(arg2_33:Find("got"), false)
			elseif var3_33 == ActivityPtData.STATE_CAN_GET then
				setActive(arg2_33:Find("lock"), false)
				setActive(arg2_33:Find("get"), true)
				setActive(arg2_33:Find("got"), false)
			else
				setActive(arg2_33:Find("lock"), false)
				setActive(arg2_33:Find("get"), false)
				setActive(arg2_33:Find("got"), true)
			end
		end
	end)
	var0_32:align(#arg0_32.ptData.dropList)

	local var1_32 = rtf(arg0_32:findTF("ptScroll/Viewport/Content/tpl", arg0_32.ptPanel)).rect.width
	local var2_32 = arg0_32:findTF("ptScroll/Viewport/Content", arg0_32.ptPanel):GetComponent(typeof(HorizontalLayoutGroup)).spacing
	local var3_32 = rtf(arg0_32:findTF("ptScroll/Viewport", arg0_32.ptPanel)).rect.width

	scrollTo(arg0_32:findTF("ptScroll", arg0_32.ptPanel), arg0_32.ptData.level * (var1_32 + var2_32) / (#arg0_32.ptData.targets * (var1_32 + var2_32) - var2_32 - var3_32), 0)

	local var4_32 = 6

	arg0_32.importants = arg0_32.ptActivity:getConfig("config_client").highValueItemSort
	arg0_32.importantsPos = {}

	for iter0_32, iter1_32 in ipairs(arg0_32.importants) do
		table.insert(arg0_32.importantsPos, (iter1_32 - var4_32 - 1) * (var1_32 + var2_32) / (#arg0_32.ptData.targets * (var1_32 + var2_32) - var2_32 - var3_32))
	end

	arg0_32:PtScrollToDo(arg0_32.ptData.level * (var1_32 + var2_32) / (#arg0_32.ptData.targets * (var1_32 + var2_32) - var2_32 - var3_32))
	onScroll(arg0_32, arg0_32:findTF("ptScroll", arg0_32.ptPanel), function(arg0_35)
		arg0_32:PtScrollToDo(arg0_35.x)
	end)

	if arg0_32.ptData:CanGetAward() then
		setActive(arg0_32:findTF("btn_get", arg0_32.ptPanel), true)
		onButton(arg0_32, arg0_32:findTF("btn_get", arg0_32.ptPanel), function()
			local var0_36 = {}
			local var1_36 = arg0_32.ptData:GetAllAvailableAwards()
			local var2_36 = getProxy(PlayerProxy):getRawData()
			local var3_36 = pg.gameset.urpt_chapter_max.description[1]
			local var4_36 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_36)
			local var5_36, var6_36 = Task.StaticJudgeOverflow(var2_36.gold, var2_36.oil, var4_36, true, true, var1_36)

			if var5_36 then
				table.insert(var0_36, function(arg0_37)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var6_36,
						onYes = arg0_37
					})
				end)
			end

			seriesAsync(var0_36, function()
				local var0_38 = arg0_32.ptData:GetCurrTarget()

				arg0_32:emit(FireworkAndSpringMediator.EVENT_PT_OPERATION, {
					cmd = 4,
					activity_id = arg0_32.ptData:GetId(),
					arg1 = var0_38
				})
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_32:findTF("btn_get", arg0_32.ptPanel), false)
		removeOnButton(arg0_32:findTF("btn_get", arg0_32.ptPanel))
	end

	setText(arg0_32:findTF("ptName", arg0_32.ptPanel), i18n("firework_2025_pt"))
end

function var0_0.PtScrollToDo(arg0_39, arg1_39)
	local var0_39 = 0

	for iter0_39, iter1_39 in ipairs(arg0_39.importantsPos) do
		if arg1_39 < iter1_39 or iter0_39 == #arg0_39.importants then
			var0_39 = arg0_39.importants[iter0_39]

			break
		end
	end

	local var1_39 = Drop.Create(arg0_39.ptData.dropList[var0_39])

	updateDrop(arg0_39:findTF("award", arg0_39.ptPanel), var1_39)
	onButton(arg0_39, arg0_39:findTF("award", arg0_39.ptPanel), function()
		arg0_39:emit(BaseUI.ON_DROP, var1_39)
	end, SFX_PANEL)
	setText(arg0_39:findTF("awardInfo/Text", arg0_39.ptPanel), i18n("firework_2025_level", var0_39))
	setActive(arg0_39:findTF("award/got", arg0_39.ptPanel), var0_39 <= arg0_39.ptData.level)
end

function var0_0.SetTaskPanel(arg0_41)
	setText(arg0_41:findTF("lvText", arg0_41.taskPanel), arg0_41.ptData:GetCurrLevel())

	if not arg0_41.ptData:IsMaxLevel() then
		setText(arg0_41:findTF("pt", arg0_41.taskPanel), arg0_41.ptData.count .. "/" .. arg0_41.ptData:GetNextLevelTarget())
		setSlider(arg0_41:findTF("slider", arg0_41.taskPanel), 0, arg0_41.ptData:GetNextLevelTarget(), arg0_41.ptData.count)
	else
		setText(arg0_41:findTF("pt", arg0_41.taskPanel), "MAX")
		setSlider(arg0_41:findTF("slider", arg0_41.taskPanel), 0, 1, 1)
	end

	local var0_41 = UIItemList.New(arg0_41:findTF("taskScroll/Viewport/Content", arg0_41.taskPanel), arg0_41:findTF("taskScroll/Viewport/Content/Tasktpl", arg0_41.taskPanel))

	var0_41:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventUpdate then
			local var0_42 = arg0_41.taskVOs[arg1_42 + 1]

			setText(arg2_42:Find("frame/name"), var0_42:getConfig("name"))
			setText(arg2_42:Find("frame/desc"), var0_42:getConfig("desc"))

			local var1_42 = var0_42:getProgress()
			local var2_42 = var0_42:getConfig("target_num")
			local var3_42 = math.min(var1_42, var2_42)

			setText(arg2_42:Find("frame/progress"), var3_42 .. "/" .. var2_42)

			arg2_42:Find("frame/slider"):GetComponent(typeof(Slider)).value = var3_42 / var2_42

			local var4_42 = arg2_42:Find("frame/awards")
			local var5_42 = var4_42:GetChild(0)

			arg0_41:updateTaskAwards(var0_42:getConfig("award_display"), var4_42, var5_42)

			local var6_42 = arg2_42:Find("frame/go_btn")
			local var7_42 = arg2_42:Find("frame/get_btn")
			local var8_42 = arg2_42:Find("frame/got_btn")

			if var0_42:getTaskStatus() == 0 then
				setActive(var6_42, true)
				setActive(var7_42, false)
				setActive(var8_42, false)
			elseif var0_42:getTaskStatus() == 1 then
				setActive(var6_42, false)
				setActive(var7_42, true)
				setActive(var8_42, false)
			elseif var0_42:getTaskStatus() == 2 then
				setActive(var6_42, false)
				setActive(var7_42, false)
				setActive(var8_42, true)
			end

			onButton(arg0_41, var6_42, function()
				arg0_41:emit(FireworkAndSpringMediator.ON_TASK_GO, var0_42)
			end, SFX_PANEL)
			onButton(arg0_41, var7_42, function()
				arg0_41:emit(FireworkAndSpringMediator.ON_TASK_SUBMIT, var0_42)
			end, SFX_PANEL)
		end
	end)
	var0_41:align(#arg0_41.taskVOs)

	if arg0_41.canGetTaskAward then
		setActive(arg0_41:findTF("btn_get", arg0_41.taskPanel), true)
		onButton(arg0_41, arg0_41:findTF("btn_get", arg0_41.taskPanel), function()
			local var0_45 = {}
			local var1_45 = {}

			for iter0_45, iter1_45 in pairs(arg0_41.canGetTaskVOs) do
				local var2_45 = iter1_45:getConfig("award_display")

				for iter2_45, iter3_45 in ipairs(var2_45) do
					local var3_45 = iter3_45
					local var4_45 = false

					for iter4_45, iter5_45 in pairs(var1_45) do
						if iter5_45[1] == var3_45[1] and iter5_45[2] == var3_45[2] then
							var4_45 = true
							iter5_45[3] = iter5_45[3] + var3_45[3]

							break
						end
					end

					if not var4_45 then
						table.insert(var1_45, var3_45)
					end
				end
			end

			local var5_45 = getProxy(PlayerProxy):getRawData()
			local var6_45 = pg.gameset.urpt_chapter_max.description[1]
			local var7_45 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var6_45)
			local var8_45, var9_45 = Task.StaticJudgeOverflow(var5_45.gold, var5_45.oil, var7_45, true, true, var1_45)

			if var8_45 then
				table.insert(var0_45, function(arg0_46)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var9_45,
						onYes = arg0_46
					})
				end)
			end

			seriesAsync(var0_45, function()
				arg0_41:emit(FireworkAndSpringMediator.ON_TASK_SUBMIT_ONESTEP, arg0_41.taskActId, arg0_41.canGetTaskIds)
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_41:findTF("btn_get", arg0_41.taskPanel), false)
		removeOnButton(arg0_41:findTF("btn_get", arg0_41.taskPanel))
	end

	setText(arg0_41:findTF("ptName", arg0_41.taskPanel), i18n("firework_2025_pt"))
end

function var0_0.updateTaskAwards(arg0_48, arg1_48, arg2_48, arg3_48)
	local var0_48 = _.slice(arg1_48, 1, 3)

	for iter0_48 = arg2_48.childCount, #var0_48 - 1 do
		cloneTplTo(arg3_48, arg2_48)
	end

	local var1_48 = arg2_48.childCount

	for iter1_48 = 1, var1_48 do
		local var2_48 = arg2_48:GetChild(iter1_48 - 1)
		local var3_48 = iter1_48 <= #var0_48

		setActive(var2_48, var3_48)

		if var3_48 then
			local var4_48 = var0_48[iter1_48]
			local var5_48 = {
				type = var4_48[1],
				id = var4_48[2],
				count = var4_48[3]
			}

			updateDrop(var2_48, var5_48)
			onButton(arg0_48, var2_48, function()
				arg0_48:emit(BaseUI.ON_DROP, var5_48)
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetFireWorkPanel(arg0_50)
	local var0_50 = arg0_50:findTF("left_panel", arg0_50.fireworkPanel)
	local var1_50 = arg0_50:findTF("right_panel", arg0_50.fireworkPanel)
	local var2_50 = arg0_50:findTF("fire_btn", var1_50)
	local var3_50 = arg0_50:findTF("scrollrect/content/item_tpl", var0_50)
	local var4_50 = arg0_50:findTF("scrollrect/content", var0_50)

	arg0_50.leftUIList = UIItemList.New(var4_50, var3_50)

	local var5_50 = arg0_50:findTF("content/item_tpl", var1_50)
	local var6_50 = arg0_50:findTF("content", var1_50)

	arg0_50.rightUIList = UIItemList.New(var6_50, var5_50)

	local var7_50 = arg0_50:findTF("arrows", var1_50)

	onButton(arg0_50, var2_50, function()
		arg0_50:CloseSubPanel()
		arg0_50:PlayFireworks()
	end)
	setText(arg0_50:findTF("tip", var1_50), i18n("activity_yanhua_tip7"))
	setText(arg0_50:findTF("tip", var0_50), i18n("firework_2025_tip1"))
	arg0_50.leftUIList:make(function(arg0_52, arg1_52, arg2_52)
		if arg0_52 == UIItemList.EventUpdate then
			local var0_52 = arg0_50.fireworkAllIds[arg1_52 + 1]
			local var1_52 = arg0_50:findTF("firework/icon", arg2_52)

			GetImageSpriteFromAtlasAsync(Item.getConfigData(var0_52).icon, "", var1_52)

			local var2_52 = arg0_50:findTF("firework/selected", arg2_52)
			local var3_52 = table.contains(arg0_50.fireworkOrderIds, var0_52)

			setActive(var2_52, var3_52)

			if not table.contains(arg0_50.fireworkUnlockIds, var0_52) then
				setActive(arg0_50:findTF("firework/lock", arg2_52), true)
				setActive(arg0_50:findTF("firework/get", arg2_52), false)
			elseif not table.contains(arg0_50.fireworkGotIds, var0_52) then
				setActive(arg0_50:findTF("firework/lock", arg2_52), false)
				setActive(arg0_50:findTF("firework/get", arg2_52), true)
				onButton(arg0_50, arg2_52, function()
					arg0_50:emit(FireworkAndSpringMediator.ACTIVITY_OPERATION, arg0_50.fireworkActId, var0_52)
				end, SFX_PANEL)
			else
				setActive(arg0_50:findTF("firework/lock", arg2_52), false)
				setActive(arg0_50:findTF("firework/get", arg2_52), false)
				onButton(arg0_50, arg2_52, function()
					arg0_50:FireworkLeftClick(var0_52, var3_52)
				end, SFX_PANEL)
			end
		end
	end)
	arg0_50.leftUIList:align(#arg0_50.fireworkAllIds)

	if not arg0_50.hasClonedFireworkArrows then
		arg0_50.hasClonedFireworkArrows = true

		for iter0_50 = 1, #arg0_50.fireworkAllIds - 2 do
			cloneTplTo(arg0_50:findTF("tpl", var7_50), var7_50)
		end
	end

	arg0_50.rightUIList:make(function(arg0_55, arg1_55, arg2_55)
		if arg0_55 == UIItemList.EventUpdate then
			local var0_55 = arg1_55 + 1
			local var1_55 = arg0_50:findTF("icon", arg2_55)

			setActive(arg0_50:findTF("add", arg2_55), var0_55 > #arg0_50.fireworkOrderIds)

			if var0_55 > #arg0_50.fireworkOrderIds then
				setActive(var1_55, false)
			else
				local var2_55 = arg0_50.fireworkOrderIds[var0_55]

				setActive(var1_55, true)
				GetImageSpriteFromAtlasAsync(Item.getConfigData(var2_55).icon, "", var1_55)
				onButton(arg0_50, var1_55, function()
					arg0_50:FireworkRightClick(var2_55)
				end, SFX_PANEL)
			end
		end
	end)
	arg0_50.rightUIList:align(#arg0_50.fireworkAllIds)
end

function var0_0.FireworkLeftClick(arg0_57, arg1_57, arg2_57)
	if arg2_57 then
		table.removebyvalue(arg0_57.fireworkOrderIds, arg1_57)
	else
		table.insert(arg0_57.fireworkOrderIds, arg1_57)
	end

	arg0_57:SetFireWorkLocalData()
	arg0_57.leftUIList:align(#arg0_57.fireworkAllIds)
	arg0_57.rightUIList:align(#arg0_57.fireworkAllIds)
end

function var0_0.FireworkRightClick(arg0_58, arg1_58)
	table.removebyvalue(arg0_58.fireworkOrderIds, arg1_58)
	arg0_58:SetFireWorkLocalData()
	arg0_58.leftUIList:align(#arg0_58.fireworkAllIds)
	arg0_58.rightUIList:align(#arg0_58.fireworkAllIds)
end

function var0_0.SetSpringPanel(arg0_59)
	arg0_59:CreateSpringUI()
	arg0_59:UpdateSpringUI()
end

function var0_0.CreateSpringUI(arg0_60)
	setText(arg0_60:findTF("list/iconTpl/lock/Text", arg0_60.springPanel), i18n("firework_2025_unlock_tip1"))

	arg0_60.springList = UIItemList.New(arg0_60:findTF("list", arg0_60.springPanel), arg0_60:findTF("list/iconTpl", arg0_60.springPanel))

	arg0_60.springList:make(function(arg0_61, arg1_61, arg2_61)
		if arg0_61 == UIItemList.EventUpdate then
			local var0_61 = arg0_60.springShipIds[arg1_61 + 1]
			local var1_61 = arg0_60.springSlotLockList[arg1_61 + 1]
			local var2_61 = var0_61 and var0_61 > 0

			setActive(arg2_61:Find("lock"), var1_61)
			setActive(arg2_61:Find("add"), not var1_61 and not var2_61)
			setActive(arg2_61:Find("ship"), not var1_61 and var2_61)

			if var1_61 then
				setText(arg2_61:Find("lock/taskText"), i18n("firework_2025_unlock_tip2", arg0_60.springActivity:getConfig("config_client").unlockPt[arg1_61 + 1 - arg0_60.springActivity:getConfig("config_client").initialCount]))
			end

			onButton(arg0_60, arg2_61, function()
				if var1_61 then
					return
				end

				local var0_62

				if var2_61 then
					var0_62 = getProxy(BayProxy):getShipById(var0_61)
				end

				local var1_62 = arg0_60.springUnlockSlotCount

				arg0_60:StopPlayFireworks()
				arg0_60:emit(FireworkAndSpringMediator.OPEN_CHUANWU, arg0_60.springActId, arg1_61 + 1, var0_62, arg0_60.springUnlockSlotCount)
			end, SFX_PANEL)

			if not var2_61 then
				return
			end

			local var3_61 = getProxy(BayProxy):RawGetShipById(var0_61)
			local var4_61 = LoadSprite("shipyardicon/" .. var3_61:getPainting())

			setImageSprite(arg2_61:Find("ship/mask/icon"), var4_61)
			setText(arg2_61:Find("ship/name/Text"), var3_61:getName())
		end
	end)
	setText(arg0_60:findTF("tipText1", arg0_60.springPanel), i18n("firework_2025_tip2"))
	setText(arg0_60:findTF("tipText2", arg0_60.springPanel), "+" .. arg0_60.energyRecoverAddition .. "/h")
end

function var0_0.UpdateSpringUI(arg0_63)
	arg0_63.springList:align(arg0_63.springMaxCnt)
end

function var0_0.UpdateSpringActivityAndUI(arg0_64)
	arg0_64:UpdateSpringData()
	arg0_64:UpdateSpringUI()
	arg0_64:clearStudents()
	arg0_64:InitStudents()
end

function var0_0.PlayFireworks(arg0_65)
	arg0_65.fireworks = Clone(arg0_65.fireworkOrderIds)

	if #arg0_65.fireworks == 0 then
		return
	end

	eachChild(arg0_65.fireworksTF, function(arg0_66)
		setActive(arg0_66, false)
	end)
	setActive(arg0_65.fireworksTF, true)
	arg0_65:StopFireworksTimer()

	arg0_65.fireworkIndex = 1
	arg0_65.fireworksTimer = Timer.New(function()
		arg0_65:PlayerOneFirework()
	end, var0_0.EffectInterval, #arg0_65.fireworks)

	arg0_65.fireworksTimer:Start()
end

function var0_0.PlayerOneFirework(arg0_68)
	if arg0_68.fireworkIndex == #arg0_68.fireworks then
		arg0_68:managedTween(LeanTween.delayedCall, function()
			if arg0_68.fireworks then
				arg0_68:StopPlayFireworks()
				arg0_68:PlayFireworks()
			end
		end, var0_0.DelayPop, nil)
	end

	local var0_68 = arg0_68.fireworks[arg0_68.fireworkIndex]
	local var1_68 = math.random(#var0_0.SFX_LIST)

	if arg0_68.firePools[var0_68] and #arg0_68.firePools[var0_68] >= var0_0.EffectPoolCnt then
		local var2_68 = arg0_68.firePools[var0_68][1]

		setLocalPosition(var2_68, arg0_68:GetFireworkPos())
		setActive(var2_68, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var1_68])
		table.removebyvalue(arg0_68.firePools[var0_68], var2_68)
		table.insert(arg0_68.firePools[var0_68], var2_68)
	else
		arg0_68.loader:GetPrefab("ui/" .. var0_0.Id2EffectName[var0_68], "", function(arg0_70)
			pg.ViewUtils.SetSortingOrder(arg0_70, 1)
			setParent(arg0_70, arg0_68.fireworksTF)
			setLocalPosition(arg0_70, arg0_68:GetFireworkPos())
			setActive(arg0_70, true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.SFX_LIST[var1_68])

			if not arg0_68.firePools[var0_68] then
				arg0_68.firePools[var0_68] = {}
			end

			table.insert(arg0_68.firePools[var0_68], arg0_70)
		end)
	end

	arg0_68.fireworkIndex = arg0_68.fireworkIndex + 1
end

function var0_0.GetFireworkPos(arg0_71)
	local var0_71 = Vector2(0, 0)

	if arg0_71.lastPos then
		local var1_71 = Vector2(arg0_71.lastPos.x, arg0_71.lastPos.y)
		local var2_71 = math.abs(var1_71.x - arg0_71.lastPos.x)
		local var3_71 = math.abs(var1_71.y - arg0_71.lastPos.y)

		while var2_71 < var0_0.FireworkRange.x / 2 and var3_71 < var0_0.FireworkRange.y or var3_71 < var0_0.FireworkRange.y / 2 and var2_71 < var0_0.FireworkRange.x do
			var1_71.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
			var1_71.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
			var2_71 = math.abs(var1_71.x - arg0_71.lastPos.x)
			var3_71 = math.abs(var1_71.y - arg0_71.lastPos.y)
		end

		var0_71 = var1_71
	else
		var0_71.x = math.random(var0_0.EffectPosLimit.limitX[1], var0_0.EffectPosLimit.limitX[2])
		var0_71.y = math.random(var0_0.EffectPosLimit.limitY[1], var0_0.EffectPosLimit.limitY[2])
	end

	arg0_71.lastPos = var0_71

	return var0_71
end

function var0_0.StopFireworksTimer(arg0_72)
	if arg0_72.fireworksTimer then
		arg0_72.fireworksTimer:Stop()

		arg0_72.fireworksTimer = nil
	end
end

function var0_0.StopPlayFireworks(arg0_73)
	arg0_73:StopFireworksTimer()

	arg0_73.fireworks = nil
	arg0_73.fireworkIndex = nil

	setActive(arg0_73.fireworksTF, false)
end

function var0_0.getStudents(arg0_74, arg1_74, arg2_74)
	local var0_74 = {}
	local var1_74 = {}

	if not arg0_74.springActivity then
		return var0_74
	end

	local var2_74 = arg0_74.springActivity:GetShipIds()

	for iter0_74 = 1, arg0_74.springMaxCnt do
		if var2_74[iter0_74] and var2_74[iter0_74] ~= 0 then
			local var3_74 = getProxy(BayProxy):RawGetShipById(var2_74[iter0_74])

			if var3_74 then
				table.insert(var1_74, var3_74)
			end
		end
	end

	if not arg1_74 or not arg2_74 then
		arg1_74 = #var1_74
		arg2_74 = #var1_74
	end

	local var4_74 = math.random(arg1_74, arg2_74)
	local var5_74 = #var1_74

	while var4_74 > 0 and var5_74 > 0 do
		local var6_74 = math.random(1, var5_74)

		table.insert(var0_74, var1_74[var6_74]:getPrefab())

		var1_74[var6_74] = var1_74[var5_74]
		var5_74 = var5_74 - 1
		var4_74 = var4_74 - 1
	end

	return var0_74
end

function var0_0.InitStudents(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75:getStudents(arg1_75, arg2_75)
	local var1_75 = {}

	for iter0_75, iter1_75 in pairs(arg0_75.graphPath.points) do
		if not iter1_75.outRandom then
			table.insert(var1_75, iter1_75)
		end
	end

	local var2_75 = #var1_75

	arg0_75.academyStudents = {}

	local var3_75 = {}

	for iter2_75, iter3_75 in pairs(var0_75) do
		if not arg0_75.academyStudents[iter2_75] then
			local var4_75 = cloneTplTo(arg0_75._shipTpl, arg0_75._map)

			var4_75.gameObject.name = iter2_75

			local var5_75 = arg0_75:ChooseRandomPos(var1_75, var2_75)

			var2_75 = (var2_75 - 2) % #var1_75 + 1

			local var6_75 = SummerFeastNavigationAgent.New(var4_75.gameObject)

			var6_75.normalSpeed = 100

			var6_75:attach()
			var6_75:setPathFinder(arg0_75.graphPath)
			var6_75:SetPositionTable(var3_75)
			var6_75:setCurrentIndex(var5_75 and var5_75.id)
			var6_75:SetOnTransEdge(function(arg0_76, arg1_76, arg2_76)
				arg1_76, arg2_76 = math.min(arg1_76, arg2_76), math.max(arg1_76, arg2_76)

				local var0_76 = arg0_75[arg0_75.edge2area[arg1_76 .. "_" .. arg2_76] or arg0_75.edge2area.default]

				arg0_76._tf:SetParent(var0_76)
			end)
			var6_75:updateStudent(iter3_75)

			arg0_75.academyStudents[iter2_75] = var6_75
		end
	end

	if #var0_75 > 0 then
		arg0_75.sortTimer = Timer.New(function()
			arg0_75:sortStudents()
		end, 0.2, -1)

		arg0_75.sortTimer:Start()
		arg0_75.sortTimer.func()
	end
end

function var0_0.ChooseRandomPos(arg0_78, arg1_78, arg2_78)
	local var0_78 = math.random(1, arg2_78)

	if not var0_78 then
		return nil
	end

	pg.Tool.Swap(arg1_78, var0_78, arg2_78)

	return arg1_78[arg2_78]
end

function var0_0.SetTips(arg0_79)
	arg0_79:SetPtTip()
	arg0_79:SetTaskTip()
	arg0_79:SetFireworkTip()
	arg0_79:SetSpringTip()
end

function var0_0.SetPtTip(arg0_80)
	local var0_80 = arg0_80.ptData:CanGetAward()

	setActive(arg0_80:findTF("tip", arg0_80.ptBtn), var0_80)
	setActive(arg0_80:findTF("tip", arg0_80.subPtBtn), var0_80)
end

function var0_0.SetTaskTip(arg0_81)
	local var0_81 = arg0_81.canGetTaskAward

	setActive(arg0_81:findTF("tip", arg0_81.taskBtn), var0_81)
	setActive(arg0_81:findTF("tip", arg0_81.subTaskBtn), var0_81)
end

function var0_0.SetFireworkTip(arg0_82)
	local var0_82 = #arg0_82.fireworkUnlockIds ~= #arg0_82.fireworkGotIds

	setActive(arg0_82:findTF("tip", arg0_82.fireworkBtn), var0_82)
	setActive(arg0_82:findTF("tip", arg0_82.subFireworkBtn), var0_82)
end

function var0_0.SetSpringTip(arg0_83)
	local var0_83 = false

	for iter0_83 = 1, arg0_83.springUnlockSlotCount do
		if arg0_83.springShipIds[iter0_83] == 0 then
			var0_83 = true

			break
		end
	end

	setActive(arg0_83:findTF("tip", arg0_83.springBtn), var0_83)
	setActive(arg0_83:findTF("tip", arg0_83.subSpringBtn), var0_83)
end

function var0_0.willExit(arg0_84)
	arg0_84:CloseSubPanel()
	arg0_84:StopPlayFireworks()
	arg0_84:clearStudents()
	var0_0.super.willExit(arg0_84)
end

function var0_0.IsShowMainTip(arg0_85)
	local var0_85 = ActivityConst.FireworkAndSpring_PT_ID
	local var1_85 = ActivityConst.FireworkAndSpring_TASK_ID
	local var2_85 = ActivityConst.FireworkAndSpring_ACT_ID
	local var3_85 = ActivityConst.FireworkAndSpring_EMO_ID
	local var4_85 = getProxy(ActivityProxy)
	local var5_85 = var4_85:getActivityById(var0_85)
	local var6_85 = ActivityPtData.New(var5_85)
	local var7_85 = var6_85:CanGetAward()
	local var8_85 = var4_85:getActivityById(var1_85)
	local var9_85 = {}
	local var10_85 = var8_85:getConfig("config_data")

	for iter0_85, iter1_85 in pairs(var10_85) do
		table.insert(var9_85, getProxy(TaskProxy):getTaskVO(iter1_85))
	end

	local var11_85 = false

	for iter2_85, iter3_85 in pairs(var9_85) do
		if iter3_85:getTaskStatus() == 1 then
			var11_85 = true

			break
		end
	end

	local var12_85 = var4_85:getActivityById(var2_85)
	local var13_85 = var12_85.data1_list
	local var14_85 = var12_85.data2_list
	local var15_85 = #var13_85 ~= #var14_85
	local var16_85 = var4_85:getActivityById(var3_85)
	local var17_85 = _.map(var16_85:GetShipIds(), function(arg0_86)
		if getProxy(BayProxy):RawGetShipById(arg0_86) then
			return arg0_86
		else
			return 0
		end
	end)
	local var18_85 = var16_85:GetSlotCount()
	local var19_85 = {}
	local var20_85 = var16_85:getConfig("config_client").initialCount

	for iter4_85, iter5_85 in ipairs(var16_85:getConfig("config_client").unlockPt) do
		if iter5_85 <= var6_85.count then
			var20_85 = var20_85 + 1
		end
	end

	for iter6_85 = 1, var18_85 do
		var19_85[iter6_85] = var20_85 < iter6_85
	end

	local var21_85 = false

	for iter7_85 = 1, var20_85 do
		if var17_85[iter7_85] == 0 then
			var21_85 = true

			break
		end
	end

	return var7_85 or var11_85 or var15_85 or var21_85
end

return var0_0
