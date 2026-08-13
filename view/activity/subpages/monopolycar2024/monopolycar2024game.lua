local var0_0 = class("MonopolyCar2024Game")
local var1_0 = 88
local var2_0 = 43
local var3_0 = "redcar"
local var4_0 = MonopolyCar2024Const.map_dic
local var5_0 = 0.6
local var6_0 = {
	"sitelasibao_2",
	"u96_4",
	"xiafei_4"
}
local var7_0 = {
	Vector3(56, 121, 0),
	Vector3(-557, -447, 0),
	Vector3(590, -344, 0)
}
local var8_0 = "B-stand"
local var9_0 = "F-stand"
local var10_0 = "B-walk"
local var11_0 = "F-walk"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg2_1
	arg0_1._event = arg3_1

	pg.DelegateInfo.New(arg0_1)

	arg0_1.cg = GetOrAddComponent(arg0_1._tf, typeof(CanvasGroup))
	arg0_1.maskTr = findTF(arg0_1._tf.parent, "mask")
	arg0_1.pickPage = arg0_1:NewPickPage(arg2_1, arg3_1)
	arg0_1.bubblePage = arg0_1:NewBubblePage(arg2_1, arg3_1)
	arg0_1.awardWindow = AwardWindow.New(arg2_1, arg3_1)
	arg0_1.resultPage = MonopolyCar2024TotalRewardPanel.New(arg2_1, arg3_1)
	arg0_1.awardCollector = MonopolyCar2024GameAwardCollector.New()

	arg0_1:UpdateActData(arg1_1)
end

function var0_0.UpdateStory(arg0_2)
	return
end

function var0_0.NewBubblePage(arg0_3, arg1_3, arg2_3)
	return MonopolyCar2024BubblePage.New(arg1_3:Find("bubble"), arg2_3)
end

function var0_0.NewPickPage(arg0_4, arg1_4, arg2_4)
	return MonopolyCar2024PickPage.New(arg1_4, arg2_4)
end

function var0_0.emit(arg0_5, ...)
	arg0_5._event:emit(...)
end

function var0_0.UpdateActData(arg0_6, arg1_6)
	arg0_6.actId = arg1_6.id

	local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_6 = arg1_6.data1

	arg0_6.totalCnt = math.ceil((var0_6 - var1_6) / 86400) * arg1_6:getDataConfig("daily_time") + (arg1_6.data1_list[1] or 0)
	arg0_6.useCount = arg1_6.data1_list[2] or 0
	arg0_6.leftCount = arg0_6.totalCnt - arg0_6.useCount
	arg0_6.dialogRecorder = arg1_6.data4_list
	arg0_6.pickCharList = arg1_6.data3_list
	arg0_6.pos = math.max(arg1_6.data2, 1)
	arg0_6.step = arg1_6.data3 or 0
	arg0_6.effectId = arg1_6.data4 or 0
	arg0_6.turnCnt = arg1_6.data1_list[3] or 0
	arg0_6.selectedShipId = arg1_6.data1_list[4] or 0
	arg0_6.storys = arg1_6:getDataConfig("story") or {}
	arg0_6.lapReward = arg1_6:getDataConfig("sum_lap_reward_show") or {}
	arg0_6.titles = {
		i18n("MonopolyCar2024Game_title1"),
		i18n("MonopolyCar2024Game_title2")
	}
	arg0_6.pickableShipId = _.map(arg1_6:getDataConfig("ship_reward"), function(arg0_7)
		return arg0_7[1]
	end)
	arg0_6.spEvents = {}

	for iter0_6, iter1_6 in ipairs(arg1_6:getDataConfig("ship_dialog") or {}) do
		arg0_6.spEvents[iter1_6[1]] = iter1_6[2]
	end

	arg0_6.cacheTurnCnt = arg0_6.turnCnt
end

function var0_0.Setup(arg0_8)
	arg0_8:BlocksRaycasts(false)
	seriesAsync({
		function(arg0_9)
			arg0_8:InitUI()
			arg0_8:InitMap()
			arg0_8:InitCar(arg0_9)
		end,
		function(arg0_10)
			arg0_8:InitCheerLeaders(arg0_10)
		end,
		function(arg0_11)
			arg0_8:OnEnterDone(arg0_11)
		end,
		function(arg0_12)
			arg0_8:RegisterUI()
			arg0_8:UpdateUI()
			arg0_8:SetUpMainLoop()
			arg0_8:CheckEventAndMove(arg0_12)
		end,
		function(arg0_13)
			arg0_8:CheckSpEvent({
				finished = true,
				shipId = arg0_8.selectedShipId
			}, arg0_13)
		end,
		function(arg0_14)
			arg0_8:CheckPickCharacter(arg0_14)
		end,
		function(arg0_15)
			arg0_8:InitDone(arg0_15)
		end,
		function(arg0_16)
			arg0_8:CheckMainStorys(arg0_16)
		end
	}, function()
		arg0_8:BlocksRaycasts(true)
	end)
end

function var0_0.CheckMainStorys(arg0_18, arg1_18)
	arg1_18()
end

function var0_0.OnEnterDone(arg0_19, arg1_19)
	arg1_19()
end

function var0_0.InitDone(arg0_20, arg1_20)
	arg1_20()
end

function var0_0.InitCheerLeaders(arg0_21, arg1_21)
	local var0_21 = {}

	arg0_21.cheerLeaders = {}

	for iter0_21, iter1_21 in ipairs(var6_0) do
		table.insert(var0_21, function(arg0_22)
			PoolMgr.GetInstance():GetSpineChar(iter1_21, true, function(arg0_23)
				local var0_23 = arg0_23

				var0_23.transform.localScale = Vector3(0.6, 0.6, 1)
				var0_23.transform.localPosition = var7_0[iter0_21]

				var0_23.transform:SetParent(arg0_21._tf, false)
				var0_23:GetComponent(typeof(SpineAnimUI)):SetAction("stand", 0)

				arg0_21.cheerLeaders[iter1_21] = arg0_23

				arg0_22()
			end)
		end)
	end

	seriesAsync(var0_21, arg1_21)
end

function var0_0.SetUpMainLoop(arg0_24)
	if not arg0_24.handle then
		arg0_24.handle = UpdateBeat:CreateListener(arg0_24.Update, arg0_24)
	end

	UpdateBeat:AddListener(arg0_24.handle)
end

function var0_0.Update(arg0_25)
	arg0_25:MoveCar()
end

function var0_0.InitUI(arg0_26)
	arg0_26.tplMapCell = findTF(arg0_26._tf, "mapContainer/tplMapCell")
	arg0_26.mapContainer = findTF(arg0_26._tf, "mapContainer")
	arg0_26.car = findTF(arg0_26._tf, "mapContainer/char")
	arg0_26.btnStart = findTF(arg0_26._tf, "btnStart")
	arg0_26.btnHelp = findTF(arg0_26._tf, "btnHelp")
	arg0_26.topTr = arg0_26._tf.parent:Find("top")
	arg0_26.btnAuto = findTF(arg0_26.topTr, "btnAuto")
	arg0_26.btnAutoImg = findTF(arg0_26.topTr, "btnAuto"):GetComponent(typeof(Image))
	arg0_26.btnAutoSel = findTF(arg0_26.topTr, "btnAuto/Text")
	arg0_26.btnAutoAct = findTF(arg0_26.topTr, "btnAuto/actvie")
	arg0_26.btnBack = findTF(arg0_26._tf.parent, "adapt_1/btnBack")
	arg0_26.labelLeftCount = findTF(arg0_26.btnStart, "Text")
	arg0_26.register = findTF(arg0_26._tf, "register")
	arg0_26.registerTxt = findTF(arg0_26._tf, "register/Text")
	arg0_26.rollStep = findTF(arg0_26._tf, "step")
	arg0_26.hideList = {
		arg0_26.btnStart,
		arg0_26.btnHelp,
		arg0_26.btnBack,
		arg0_26.btnAuto,
		arg0_26.register
	}

	arg0_26:SetRollStepAct(false)
end

function var0_0.RegisterUI(arg0_27)
	onButton(arg0_27, arg0_27.btnStart, function()
		if arg0_27.leftCount and arg0_27.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0_27:Roll()
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_car2024.tip
		})
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.btnAuto, function()
		if arg0_27.autoFlag then
			arg0_27:DisableAuto()
		else
			arg0_27:EnableAuto()
		end
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.btnBack, function()
		arg0_27:emit(BaseUI.ON_CLOSE)
	end, SFX_BACK)
	onButton(arg0_27, arg0_27.register, function()
		local var0_32 = arg0_27.turnCnt - 1

		arg0_27.awardWindow:ExecuteAction("Flush", arg0_27.lapReward, var0_32, arg0_27.titles)
	end, SFX_PANEL)
	arg0_27:UpdateAutoBtn()
end

function var0_0.DisableAuto(arg0_33)
	arg0_33.autoFlag = false

	arg0_33:DisplayResult()
	arg0_33:UpdateAutoBtn()
end

function var0_0.EnableAuto(arg0_34)
	if arg0_34.rolling then
		return
	end

	if arg0_34.leftCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

		return
	end

	if arg0_34.useCount < 10 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("MonopolyCar2024Game_lock_auto_tip", arg0_34.useCount))

		return
	end

	arg0_34.awardCollector:SetUp()

	arg0_34.autoFlag = true

	arg0_34:RollAuto()
	arg0_34:UpdateAutoBtn()
	pg.TipsMgr.GetInstance():ShowTips(i18n("MonopolyCar2024Game_open_auto_tip"))
end

function var0_0.UpdateAutoBtn(arg0_35)
	local var0_35 = arg0_35.useCount >= 10

	setActive(arg0_35.btnAutoSel, var0_35)

	arg0_35.btnAutoImg.enabled = not var0_35

	setActive(arg0_35.btnAutoAct, arg0_35.autoFlag)
end

function var0_0.DisplayResult(arg0_36)
	local var0_36 = arg0_36.awardCollector:Fetch()

	if #var0_36 <= 0 then
		return
	end

	arg0_36.resultPage:ExecuteAction("Show", var0_36)
end

function var0_0.RollAuto(arg0_37)
	if not arg0_37.autoFlag then
		return
	end

	if arg0_37.leftCount <= 0 then
		arg0_37.autoFlag = false

		arg0_37:DisplayResult()
		arg0_37:UpdateAutoBtn()

		return
	end

	arg0_37:Roll(function()
		arg0_37:RollAuto()
	end)
end

function var0_0.BlocksRaycasts(arg0_39, arg1_39)
	arg0_39.cg.blocksRaycasts = arg1_39

	setActive(arg0_39.maskTr, not arg1_39)

	arg0_39.isBlocksRaycasts = not arg1_39
end

function var0_0.Roll(arg0_40, arg1_40)
	local var0_40 = 0

	arg0_40:BlocksRaycasts(false)

	arg0_40.rolling = true

	seriesAsync({
		function(arg0_41)
			arg0_40:emit(MonopolyCar2024Mediator.ON_START, arg0_40.actId, function(arg0_42)
				if arg0_42 and arg0_42 > 0 then
					var0_40 = arg0_42

					arg0_41()
				end
			end)
		end,
		function(arg0_43)
			arg0_40:PlayRollAnimation(var0_40, arg0_43)
		end,
		function(arg0_44)
			arg0_40:CheckSpEvent({
				result = var0_40,
				shipId = arg0_40.selectedShipId
			}, arg0_44)
		end,
		function(arg0_45)
			arg0_40:CheckEventAndMove(arg0_45)
		end,
		function(arg0_46)
			arg0_40:CheckSpStory(arg0_40.selectedShipId, arg0_46)
		end,
		function(arg0_47)
			arg0_40:CheckSpEvent({
				finished = true,
				shipId = arg0_40.selectedShipId
			}, arg0_47)
		end,
		function(arg0_48)
			arg0_40:CheckMainStorys(arg0_48)
		end
	}, function()
		arg0_40:UpdateAutoBtn()
		arg0_40:BlocksRaycasts(true)

		arg0_40.rolling = false

		if arg1_40 then
			arg1_40()
		end
	end)
end

function var0_0.CheckSpStory(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50.mapCells[arg0_50.pos]

	if not var0_50 then
		arg2_50()

		return
	end

	local var1_50 = var0_50.mapId
	local var2_50 = pg.activity_event_monopoly_map[var1_50].ship_event
	local var3_50 = _.detect(var2_50, function(arg0_51)
		return arg0_51[1] == arg1_50
	end)

	if not var3_50 then
		arg2_50()

		return
	end

	local var4_50 = var3_50[2] or {}

	if #var4_50 <= 0 then
		arg2_50()

		return
	end

	local var5_50 = var4_50[math.random(1, #var4_50)]

	arg0_50:HideOrShowUI(false)

	local function var6_50()
		arg0_50:HideOrShowUI(true)
		arg2_50()
	end

	if arg0_50.autoFlag then
		pg.NewStoryMgr.GetInstance():ForceAutoPlay(var5_50, var6_50, true, true)
	else
		pg.NewStoryMgr.GetInstance():Play(var5_50, var6_50, true)
	end
end

function var0_0.PlayRollAnimation(arg0_53, arg1_53, arg2_53)
	setText(findTF(arg0_53.rollStep, "animroot/Image/Text"), "00")

	local var0_53 = arg0_53.btnStart:GetComponent(typeof(Animation))
	local var1_53 = var0_53:GetComponent(typeof(DftAniEvent))
	local var2_53 = findTF(arg0_53.rollStep, "animroot"):GetComponent(typeof(Animation))
	local var3_53 = var2_53:GetComponent(typeof(DftAniEvent))

	var3_53:SetTriggerEvent(function()
		setText(findTF(arg0_53.rollStep, "animroot/Image/Text"), "0" .. arg1_53)
	end)
	seriesAsync({
		function(arg0_55)
			var1_53:SetEndEvent(function()
				setActive(arg0_53.btnStart, false)
				arg0_55()
			end)
			var0_53:Play("anim_monopolycar_mainui_btn_hide")
		end,
		function(arg0_57)
			arg0_53:SetRollStepAct(true)
			arg0_57()
		end,
		function(arg0_58)
			var3_53:SetEndEvent(function()
				arg0_58()
			end)
			var2_53:Play("anim_monopolycar_mainui_step_0" .. arg1_53)
		end,
		function(arg0_60)
			var3_53:SetEndEvent(function()
				arg0_53:SetRollStepAct(false)
				arg0_60()
			end)
			var2_53:Play("anim_monopolycar_mainui_step_hide")
		end
	}, function()
		setActive(arg0_53.btnStart, true)
		var0_53:Play("anim_monopolycar_mainui_btn_show")
		arg2_53()
	end)
end

function var0_0.SetRollStepAct(arg0_63, arg1_63)
	setActive(arg0_63.rollStep, arg1_63)
end

function var0_0.CheckEventAndMove(arg0_64, arg1_64)
	local function var0_64()
		arg0_64:CheckEventAndMove(arg1_64)
	end

	if arg0_64.selectedShipId == 0 then
		arg0_64:CheckPickCharacter(var0_64)
	elseif arg0_64.effectId and arg0_64.effectId > 0 then
		arg0_64:CheckEvent(var0_64)
	elseif arg0_64.step and arg0_64.step > 0 then
		arg0_64:CheckMove(var0_64)
	else
		arg1_64()
	end
end

function var0_0.CheckEvent(arg0_66, arg1_66)
	if not arg0_66.effectId or arg0_66.effectId <= 0 then
		if arg1_66 then
			arg1_66()
		end

		return
	end

	local var0_66 = arg0_66.mapCells[arg0_66.pos]
	local var1_66 = {}

	seriesAsync({
		function(arg0_67)
			local var0_67 = pg.activity_event_monopoly_event[arg0_66.effectId].story

			if not var0_67 or tonumber(var0_67) == 0 then
				arg0_67()

				return
			end

			arg0_66:HideOrShowUI(false)

			if arg0_66.autoFlag then
				pg.NewStoryMgr.GetInstance():ForceAutoPlay(var0_67, arg0_67, true, true)
			else
				pg.NewStoryMgr.GetInstance():Play(var0_67, arg0_67, true, true)
			end
		end,
		function(arg0_68)
			arg0_66:HideOrShowUI(true)
			arg0_66:TriggerEvent(function(arg0_69)
				var1_66 = arg0_69

				arg0_68()
			end)
		end,
		function(arg0_70)
			arg0_66:ReadyMoveCar(var1_66, arg0_70)
		end,
		function(arg0_71)
			arg0_66:CheckCountStory(arg0_71)
		end
	}, arg1_66)
end

function var0_0.HideOrShowUI(arg0_72, arg1_72)
	for iter0_72, iter1_72 in ipairs(arg0_72.hideList) do
		setActive(iter1_72, arg1_72)
	end
end

function var0_0.TriggerEvent(arg0_73, arg1_73)
	arg0_73:emit(MonopolyCar2024Mediator.ON_TRIGGER, arg0_73.actId, function(arg0_74, arg1_74)
		if arg0_74 and #arg0_74 >= 0 then
			arg1_73(arg0_74)
		end
	end)
end

function var0_0.CheckCountStory(arg0_75, arg1_75)
	local var0_75 = arg0_75.useCount
	local var1_75 = arg0_75.storys
	local var2_75 = _.detect(var1_75, function(arg0_76)
		return arg0_76[1] == var0_75
	end)

	if var2_75 then
		pg.NewStoryMgr.GetInstance():Play(var2_75[2], arg1_75)
	else
		arg1_75()
	end
end

function var0_0.CheckSpEvent(arg0_77, arg1_77, arg2_77)
	if arg1_77.result and arg1_77.result > 0 then
		arg0_77:CheckRollResultForSpEvent(arg1_77.result, arg1_77.shipId)

		if arg2_77 then
			arg2_77()
		end
	elseif arg1_77.repeatChat then
		arg0_77:CheckRepeatCharForSpEvent(arg1_77.shipId)

		if arg2_77 then
			arg2_77()
		end
	elseif arg1_77.finished then
		arg0_77:CheckFinishedForSpEvent(arg1_77.shipId)

		if arg2_77 then
			arg2_77()
		end
	elseif arg2_77 then
		arg2_77()
	end
end

function var0_0.CheckFinishedForSpEvent(arg0_78, arg1_78)
	if arg0_78.turnCnt <= arg0_78.cacheTurnCnt then
		return
	end

	arg0_78.cacheTurnCnt = arg0_78.turnCnt

	local var0_78 = _.select(arg0_78.spEvents[arg1_78], function(arg0_79)
		return arg0_79[1] == 4
	end)

	if #var0_78 <= 0 then
		return
	end

	local var1_78 = var0_78[1][2] or {}
	local var2_78 = arg0_78:GetUnReadDialogue(var1_78)

	arg0_78.bubblePage:Show(arg0_78.actId, arg1_78, var2_78)
end

function var0_0.CheckRepeatCharForSpEvent(arg0_80, arg1_80)
	if not table.contains(arg0_80.pickCharList, arg1_80) then
		return
	end

	local var0_80 = _.select(arg0_80.spEvents[arg1_80] or {}, function(arg0_81)
		return arg0_81[1] == 5
	end)

	if #var0_80 <= 0 then
		return
	end

	local var1_80 = var0_80[1][2] or {}
	local var2_80 = arg0_80:GetUnReadDialogue(var1_80)

	arg0_80.bubblePage:Show(arg0_80.actId, arg1_80, var2_80)
end

function var0_0.GetUnReadDialogue(arg0_82, arg1_82)
	local var0_82 = {}

	for iter0_82, iter1_82 in ipairs(arg1_82) do
		if not table.contains(arg0_82.dialogRecorder, iter1_82) then
			table.insert(var0_82, iter1_82)
		end
	end

	if #var0_82 <= 0 then
		return arg1_82[math.random(1, #arg1_82)]
	end

	return var0_82[math.random(1, #var0_82)]
end

function var0_0.CheckRollResultForSpEvent(arg0_83, arg1_83, arg2_83)
	local var0_83 = {
		{
			1,
			2
		},
		{
			3,
			4
		},
		{
			5,
			6
		}
	}

	assert(arg0_83.spEvents[arg2_83], arg2_83)

	local var1_83 = _.select(arg0_83.spEvents[arg2_83] or {}, function(arg0_84)
		local var0_84 = var0_83[arg0_84[1]] or {
			99,
			99
		}

		return arg1_83 == var0_84[1] or arg1_83 == var0_84[2]
	end)

	if #var1_83 <= 0 then
		return
	end

	local var2_83 = var1_83[1][2] or {}
	local var3_83 = arg0_83:GetUnReadDialogue(var2_83)

	arg0_83.bubblePage:Show(arg0_83.actId, arg2_83, var3_83)
end

function var0_0.CheckMove(arg0_85, arg1_85)
	local var0_85 = {}

	seriesAsync({
		function(arg0_86)
			arg0_85:emit(MonopolyCar2024Mediator.ON_MOVE, arg0_85.actId, function(arg0_87, arg1_87, arg2_87)
				if not arg0_87 or not arg1_87 or not arg2_87 then
					warning(arg0_87, arg1_87, arg2_87)

					return
				end

				var0_85 = arg1_87

				arg0_86()
			end)
		end,
		function(arg0_88)
			arg0_85:ReadyMoveCar(var0_85, arg0_88)
		end
	}, arg1_85)
end

function var0_0.ReadyMoveCar(arg0_89, arg1_89, arg2_89)
	if not arg1_89 or #arg1_89 <= 0 then
		if arg2_89 then
			arg2_89()
		end

		return
	end

	local var0_89 = {}
	local var1_89 = arg0_89.car.localPosition
	local var2_89 = {}
	local var3_89 = {}

	for iter0_89 = 1, #arg1_89 do
		if arg0_89:CheckPathTurn(arg1_89[iter0_89]) then
			table.insert(var2_89, arg0_89.mapCells[arg1_89[iter0_89]].position)
			table.insert(var3_89, arg1_89[iter0_89])
		elseif iter0_89 == #arg1_89 then
			table.insert(var2_89, arg0_89.mapCells[arg1_89[iter0_89]].position)
			table.insert(var3_89, arg1_89[iter0_89])
		end
	end

	arg0_89.speedX = 0
	arg0_89.speedY = 0
	arg0_89.baseSpeed = 6
	arg0_89.baseASpeed = 0.1

	for iter1_89 = 1, #var2_89 do
		table.insert(var0_89, function(arg0_90)
			arg0_89.moveComplete = arg0_90
			arg0_89.stopOnEnd = false
			arg0_89.targetPosition = var2_89[iter1_89]
			arg0_89.targetPosIndex = var3_89[iter1_89]
			arg0_89.moveX = arg0_89.targetPosition.x - arg0_89.car.localPosition.x
			arg0_89.moveY = arg0_89.targetPosition.y - arg0_89.car.localPosition.y
			arg0_89.baseSpeedX = arg0_89.baseSpeed * (arg0_89.moveX / math.abs(arg0_89.moveX))
			arg0_89.baseASpeedX = arg0_89.baseASpeed * (arg0_89.moveX / math.abs(arg0_89.moveX))
			arg0_89.baseSpeedY = math.abs(arg0_89.baseSpeedX) / (math.abs(arg0_89.moveX) / arg0_89.moveY)
			arg0_89.baseASpeedY = math.abs(arg0_89.baseASpeedX) / (math.abs(arg0_89.moveX) / arg0_89.moveY)

			if iter1_89 == 1 then
				arg0_89.speedX = 0
				arg0_89.speedY = 0
			else
				arg0_89.speedX = arg0_89.baseSpeedX
				arg0_89.speedY = arg0_89.baseSpeedY
			end
		end)
	end

	table.insert(var0_89, function(arg0_91)
		arg0_89.moveComplete = nil

		arg0_89:UpdateCarPos(arg1_89[#arg1_89], false)
		arg0_91()
	end)
	table.insert(var0_89, function(arg0_92)
		LeanTween.value(go(arg0_89._tf), 1, 0, 0.1):setOnComplete(System.Action(arg0_92))
	end)
	seriesAsync(var0_89, arg2_89)
end

function var0_0.MoveCar(arg0_93)
	if not arg0_93.targetPosition then
		return
	end

	local var0_93 = math.abs(arg0_93.targetPosition.x - arg0_93.car.localPosition.x)
	local var1_93 = math.abs(arg0_93.targetPosition.y - arg0_93.car.localPosition.y)

	if var0_93 <= 6.5 and var1_93 <= 6.5 then
		arg0_93.targetPosition = nil

		if arg0_93.moveComplete then
			arg0_93:UpdateCarPos(arg0_93.targetPosIndex, true)
			arg0_93.moveComplete()
		end
	end

	arg0_93.speedX = math.abs(arg0_93.speedX + arg0_93.baseASpeedX) > math.abs(arg0_93.baseSpeedX) and arg0_93.baseSpeedX or arg0_93.speedX + arg0_93.baseASpeedX
	arg0_93.speedY = math.abs(arg0_93.speedY + arg0_93.baseASpeedY) > math.abs(arg0_93.baseSpeedY) and arg0_93.baseSpeedY or arg0_93.speedY + arg0_93.baseASpeedY

	local var2_93 = arg0_93.car.localPosition

	arg0_93.car.localPosition = Vector3(var2_93.x + arg0_93.speedX, var2_93.y + arg0_93.speedY, 0)
end

function var0_0.CheckPathTurn(arg0_94, arg1_94)
	local var0_94 = arg1_94 + 1 > #arg0_94.mapCells and 1 or arg1_94 + 1
	local var1_94 = arg1_94 - 1 < 1 and #arg0_94.mapCells or arg1_94 - 1

	if arg0_94.mapCells[var0_94].col == arg0_94.mapCells[var1_94].col or arg0_94.mapCells[var0_94].row == arg0_94.mapCells[var1_94].row then
		return false
	end

	return true
end

function var0_0.CheckPickCharacter(arg0_95, arg1_95)
	if arg0_95.selectedShipId == 0 or #arg0_95.pickCharList == 0 then
		local function var0_95(arg0_96)
			local var0_96 = arg0_95.pickableShipId[arg0_96]

			arg0_95:CheckSpEvent({
				repeatChat = true,
				shipId = var0_96
			})
			arg0_95:emit(MonopolyCar2024Mediator.ON_PICK, arg0_95.actId, var0_96, function(arg0_97)
				arg0_95.pickPage:Hide()
				seriesAsync({
					function(arg0_98)
						arg0_95:ReadyMoveCar(arg0_97, arg0_98)
					end,
					function(arg0_99)
						arg0_95:CheckEventAndMove(arg0_99)
					end
				}, arg1_95)
			end)
		end

		local var1_95 = _.map(arg0_95.pickCharList, function(arg0_100)
			return table.indexof(arg0_95.pickableShipId, arg0_100)
		end)

		arg0_95.pickPage:ExecuteAction("Show", arg0_95.actId, var1_95, arg0_95.autoFlag, arg0_95.turnCnt, var0_95)
	else
		arg1_95()
	end
end

function var0_0.InitMap(arg0_101)
	arg0_101.mapCells = {}

	for iter0_101 = 1, #var4_0 do
		local var0_101 = iter0_101 - 1
		local var1_101 = {
			x = -var0_101 * var1_0,
			y = -var0_101 * var2_0
		}
		local var2_101 = var4_0[iter0_101]

		for iter1_101 = 1, #var2_101 do
			local var3_101 = iter1_101 - 1
			local var4_101 = var2_101[iter1_101]

			if var4_101 > 0 then
				local var5_101 = cloneTplTo(arg0_101.tplMapCell, arg0_101.mapContainer, tostring(var4_101))
				local var6_101 = Vector2(var1_0 * var3_101 + var1_101.x, -var2_0 * var3_101 + var1_101.y)

				var5_101.localPosition = var6_101

				local var7_101 = pg.activity_event_monopoly_map[var4_101].icon
				local var8_101 = GetSpriteFromAtlas("ui/MonopolyCar2024_atlas", var7_101)

				var5_101:GetComponent(typeof(Image)).sprite = var8_101

				var5_101:GetComponent(typeof(Image)):SetNativeSize()

				local var9_101 = {
					col = var3_101,
					row = var0_101,
					mapId = var4_101,
					tf = var5_101,
					icon = var7_101,
					position = var6_101
				}

				table.insert(arg0_101.mapCells, var9_101)
			end
		end
	end

	table.sort(arg0_101.mapCells, function(arg0_102, arg1_102)
		return arg0_102.mapId < arg1_102.mapId
	end)
end

function var0_0.InitCar(arg0_103, arg1_103)
	PoolMgr.GetInstance():GetSpineChar(var3_0, true, function(arg0_104)
		arg0_103.model = arg0_104
		arg0_103.model.transform.localScale = Vector3.one
		arg0_103.model.transform.localPosition = Vector3.zero

		arg0_103.model.transform:SetParent(arg0_103.car, false)

		arg0_103.anim = arg0_103.model:GetComponent(typeof(SpineAnimUI))

		if arg0_103.pos then
			arg0_103:UpdateCarPos(arg0_103.pos, false)
		end

		arg1_103()
	end)
end

function var0_0.UpdateCarPos(arg0_105, arg1_105, arg2_105)
	if arg0_105.model then
		assert(arg0_105.mapCells[arg1_105], arg1_105)

		local var0_105 = arg0_105.mapCells[arg1_105].position
		local var1_105 = arg1_105 + 1 > #arg0_105.mapCells and 1 or arg1_105 + 1
		local var2_105 = arg0_105.mapCells[var1_105]
		local var3_105, var4_105 = arg0_105:GetCarMoveType(arg0_105.mapCells[arg1_105].mapId, arg0_105.mapCells[var1_105].mapId, arg2_105)

		arg0_105.car.localScale = var4_105

		arg0_105.anim:SetActionCallBack(nil)
		arg0_105.anim:SetAction(var3_105, 0)

		arg0_105.car.localPosition = var0_105

		arg0_105.car:SetAsLastSibling()
	end
end

function var0_0.GetCarMoveType(arg0_106, arg1_106, arg2_106, arg3_106)
	local var0_106 = {}
	local var1_106 = {}

	for iter0_106 = 1, #var4_0 do
		local var2_106 = var4_0[iter0_106]

		for iter1_106 = 1, #var2_106 do
			local var3_106 = var2_106[iter1_106]

			if var3_106 == arg1_106 then
				var0_106 = {
					x = iter1_106,
					y = iter0_106
				}
			end

			if var3_106 == arg2_106 then
				var1_106 = {
					x = iter1_106,
					y = iter0_106
				}
			end
		end
	end

	local var4_106
	local var5_106

	if var1_106.y > var0_106.y then
		var4_106 = arg3_106 and var11_0 or var9_0
		var5_106 = Vector3(var5_0, var5_0, var5_0)
	elseif var1_106.y < var0_106.y then
		var4_106 = arg3_106 and var10_0 or var8_0
		var5_106 = Vector3(var5_0, var5_0, var5_0)
	elseif var1_106.x > var0_106.x then
		var4_106 = arg3_106 and var11_0 or var9_0
		var5_106 = Vector3(-var5_0, var5_0, var5_0)
	elseif var1_106.x < var0_106.x then
		var4_106 = arg3_106 and var10_0 or var8_0
		var5_106 = Vector3(-var5_0, var5_0, var5_0)
	end

	return var4_106, var5_106
end

function var0_0.UpdateUI(arg0_107)
	setText(arg0_107.labelLeftCount, arg0_107.leftCount)
	setText(arg0_107.registerTxt, arg0_107.turnCnt - 1)
end

function var0_0.UpdateActivity(arg0_108, arg1_108)
	arg0_108:UpdateActData(arg1_108)
	arg0_108:UpdateUI()
end

function var0_0.Dispose(arg0_109)
	for iter0_109, iter1_109 in pairs(arg0_109.cheerLeaders or {}) do
		PoolMgr.GetInstance():ReturnSpineChar(iter0_109, iter1_109)
	end

	if arg0_109.handle then
		UpdateBeat:RemoveListener(arg0_109.handle)

		arg0_109.handle = nil
	end

	if arg0_109.awardWindow then
		arg0_109.awardWindow:Destroy()

		arg0_109.awardWindow = nil
	end

	if arg0_109.pickPage then
		if arg0_109.pickPage:isShowing() then
			arg0_109.pickPage:Hide()
		end

		arg0_109.pickPage:Destroy()

		arg0_109.pickPage = nil
	end

	if arg0_109.resultPage then
		arg0_109.resultPage:Destroy()

		arg0_109.resultPage = nil
	end

	if arg0_109.awardCollector then
		arg0_109.awardCollector:Dispose()

		arg0_109.awardCollector = nil
	end

	arg0_109.bubblePage:Dispose()
	pg.DelegateInfo.Dispose(arg0_109)
	PoolMgr.GetInstance():ReturnSpineChar(var3_0, arg0_109.model)
end

return var0_0
