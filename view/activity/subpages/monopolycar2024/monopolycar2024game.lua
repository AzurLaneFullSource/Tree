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
	arg0_1.pickPage = MonopolyCar2024PickPage.New(arg2_1, arg3_1)
	arg0_1.bubblePage = MonopolyCar2024BubblePage.New(arg2_1:Find("bubble"), arg3_1)
	arg0_1.awardWindow = AwardWindow.New(arg2_1, arg3_1)
	arg0_1.resultPage = MonopolyCar2024TotalRewardPanel.New(arg2_1, arg3_1)
	arg0_1.awardCollector = MonopolyCar2024GameAwardCollector.New()

	arg0_1:UpdateActData(arg1_1)
	arg0_1:Setup()
end

function var0_0.emit(arg0_2, ...)
	arg0_2._event:emit(...)
end

function var0_0.UpdateActData(arg0_3, arg1_3)
	arg0_3.actId = arg1_3.id

	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_3 = arg1_3.data1

	arg0_3.totalCnt = math.ceil((var0_3 - var1_3) / 86400) * arg1_3:getDataConfig("daily_time") + (arg1_3.data1_list[1] or 0)
	arg0_3.useCount = arg1_3.data1_list[2] or 0
	arg0_3.leftCount = arg0_3.totalCnt - arg0_3.useCount
	arg0_3.dialogRecorder = arg1_3.data4_list
	arg0_3.pickCharList = arg1_3.data3_list
	arg0_3.pos = math.max(arg1_3.data2, 1)
	arg0_3.step = arg1_3.data3 or 0
	arg0_3.effectId = arg1_3.data4 or 0
	arg0_3.turnCnt = arg1_3.data1_list[3] or 0
	arg0_3.selectedShipId = arg1_3.data1_list[4] or 0
	arg0_3.storys = arg1_3:getDataConfig("story") or {}
	arg0_3.lapReward = arg1_3:getDataConfig("sum_lap_reward_show") or {}
	arg0_3.titles = {
		i18n("MonopolyCar2024Game_title1"),
		i18n("MonopolyCar2024Game_title2")
	}
	arg0_3.pickableShipId = _.map(arg1_3:getDataConfig("ship_reward"), function(arg0_4)
		return arg0_4[1]
	end)
	arg0_3.spEvents = {}

	for iter0_3, iter1_3 in ipairs(arg1_3:getDataConfig("ship_dialog") or {}) do
		arg0_3.spEvents[iter1_3[1]] = iter1_3[2]
	end

	arg0_3.cacheTurnCnt = arg0_3.turnCnt
end

function var0_0.Setup(arg0_5)
	arg0_5.cg.blocksRaycasts = false

	seriesAsync({
		function(arg0_6)
			arg0_5:InitUI()
			arg0_5:InitMap()
			arg0_5:InitCar(arg0_6)
		end,
		function(arg0_7)
			arg0_5:InitCheerLeaders(arg0_7)
		end,
		function(arg0_8)
			arg0_5:RegisterUI()
			arg0_5:UpdateUI()
			arg0_5:SetUpMainLoop()
			arg0_5:CheckEventAndMove(arg0_8)
		end,
		function(arg0_9)
			arg0_5:CheckSpEvent({
				finished = true,
				shipId = arg0_5.selectedShipId
			}, arg0_9)
		end,
		function(arg0_10)
			arg0_5:CheckPickCharacter(arg0_10)
		end
	}, function()
		arg0_5.cg.blocksRaycasts = true
	end)
end

function var0_0.InitCheerLeaders(arg0_12, arg1_12)
	local var0_12 = {}

	arg0_12.cheerLeaders = {}

	for iter0_12, iter1_12 in ipairs(var6_0) do
		table.insert(var0_12, function(arg0_13)
			PoolMgr.GetInstance():GetSpineChar(iter1_12, true, function(arg0_14)
				local var0_14 = arg0_14

				var0_14.transform.localScale = Vector3(0.6, 0.6, 1)
				var0_14.transform.localPosition = var7_0[iter0_12]

				var0_14.transform:SetParent(arg0_12._tf, false)
				var0_14:GetComponent(typeof(SpineAnimUI)):SetAction("stand", 0)

				arg0_12.cheerLeaders[iter1_12] = arg0_14

				arg0_13()
			end)
		end)
	end

	seriesAsync(var0_12, arg1_12)
end

function var0_0.SetUpMainLoop(arg0_15)
	if not arg0_15.handle then
		arg0_15.handle = UpdateBeat:CreateListener(arg0_15.Update, arg0_15)
	end

	UpdateBeat:AddListener(arg0_15.handle)
end

function var0_0.Update(arg0_16)
	arg0_16:MoveCar()
end

function var0_0.InitUI(arg0_17)
	arg0_17.tplMapCell = findTF(arg0_17._tf, "mapContainer/tplMapCell")
	arg0_17.mapContainer = findTF(arg0_17._tf, "mapContainer")
	arg0_17.car = findTF(arg0_17._tf, "mapContainer/char")
	arg0_17.btnStart = findTF(arg0_17._tf, "btnStart")
	arg0_17.btnHelp = findTF(arg0_17._tf, "btnHelp")
	arg0_17.topTr = arg0_17._tf.parent:Find("top")
	arg0_17.btnAuto = findTF(arg0_17.topTr, "btnAuto")
	arg0_17.btnAutoImg = findTF(arg0_17.topTr, "btnAuto"):GetComponent(typeof(Image))
	arg0_17.btnAutoSel = findTF(arg0_17.topTr, "btnAuto/Text")
	arg0_17.btnAutoAct = findTF(arg0_17.topTr, "btnAuto/actvie")
	arg0_17.btnBack = findTF(arg0_17._tf, "btnBack")
	arg0_17.labelLeftCount = findTF(arg0_17.btnStart, "Text")
	arg0_17.register = findTF(arg0_17._tf, "register")
	arg0_17.registerTxt = findTF(arg0_17._tf, "register/Text")
	arg0_17.rollStep = findTF(arg0_17._tf, "step")
	arg0_17.hideList = {
		arg0_17.btnStart,
		arg0_17.btnHelp,
		arg0_17.btnBack,
		arg0_17.btnAuto,
		arg0_17.register
	}

	setActive(arg0_17.rollStep, false)
end

function var0_0.RegisterUI(arg0_18)
	onButton(arg0_18, arg0_18.btnStart, function()
		if arg0_18.leftCount and arg0_18.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0_18:Roll()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_car2024.tip
		})
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.btnAuto, function()
		if arg0_18.autoFlag then
			arg0_18:DisableAuto()
		else
			arg0_18:EnableAuto()
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.btnBack, function()
		arg0_18:emit(BaseUI.ON_CLOSE)
	end, SFX_BACK)
	onButton(arg0_18, arg0_18.register, function()
		local var0_23 = arg0_18.turnCnt - 1

		arg0_18.awardWindow:ExecuteAction("Flush", arg0_18.lapReward, var0_23, arg0_18.titles)
	end, SFX_PANEL)
	arg0_18:UpdateAutoBtn()
end

function var0_0.DisableAuto(arg0_24)
	arg0_24.autoFlag = false

	arg0_24:DisplayResult()
	arg0_24:UpdateAutoBtn()
end

function var0_0.EnableAuto(arg0_25)
	if arg0_25.rolling then
		return
	end

	if arg0_25.leftCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

		return
	end

	if arg0_25.useCount < 10 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("MonopolyCar2024Game_lock_auto_tip", arg0_25.useCount))

		return
	end

	arg0_25.awardCollector:SetUp()

	arg0_25.autoFlag = true

	arg0_25:RollAuto()
	arg0_25:UpdateAutoBtn()
	pg.TipsMgr.GetInstance():ShowTips(i18n("MonopolyCar2024Game_open_auto_tip"))
end

function var0_0.UpdateAutoBtn(arg0_26)
	local var0_26 = arg0_26.useCount >= 10

	setActive(arg0_26.btnAutoSel, var0_26)

	arg0_26.btnAutoImg.enabled = not var0_26

	setActive(arg0_26.btnAutoAct, arg0_26.autoFlag)
end

function var0_0.DisplayResult(arg0_27)
	local var0_27 = arg0_27.awardCollector:Fetch()

	if #var0_27 <= 0 then
		return
	end

	arg0_27.resultPage:ExecuteAction("Show", var0_27)
end

function var0_0.RollAuto(arg0_28)
	if not arg0_28.autoFlag then
		return
	end

	if arg0_28.leftCount <= 0 then
		arg0_28.autoFlag = false

		arg0_28:DisplayResult()

		return
	end

	arg0_28:Roll(function()
		arg0_28:RollAuto()
	end)
end

function var0_0.Roll(arg0_30, arg1_30)
	local var0_30 = 0

	arg0_30.cg.blocksRaycasts = false
	arg0_30.rolling = true

	seriesAsync({
		function(arg0_31)
			arg0_30:emit(MonopolyCar2024Mediator.ON_START, arg0_30.actId, function(arg0_32)
				if arg0_32 and arg0_32 > 0 then
					var0_30 = arg0_32

					arg0_31()
				end
			end)
		end,
		function(arg0_33)
			arg0_30:PlayRollAnimation(var0_30, arg0_33)
		end,
		function(arg0_34)
			arg0_30:CheckSpEvent({
				result = var0_30,
				shipId = arg0_30.selectedShipId
			}, arg0_34)
		end,
		function(arg0_35)
			arg0_30:CheckEventAndMove(arg0_35)
		end,
		function(arg0_36)
			arg0_30:CheckSpStory(arg0_30.selectedShipId, arg0_36)
		end,
		function(arg0_37)
			arg0_30:CheckSpEvent({
				finished = true,
				shipId = arg0_30.selectedShipId
			}, arg0_37)
		end
	}, function()
		arg0_30:UpdateAutoBtn()

		arg0_30.cg.blocksRaycasts = true
		arg0_30.rolling = false

		if arg1_30 then
			arg1_30()
		end
	end)
end

function var0_0.CheckSpStory(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.mapCells[arg0_39.pos]

	if not var0_39 then
		arg2_39()

		return
	end

	local var1_39 = var0_39.mapId
	local var2_39 = pg.activity_event_monopoly_map[var1_39].ship_event
	local var3_39 = _.detect(var2_39, function(arg0_40)
		return arg0_40[1] == arg1_39
	end)

	if not var3_39 then
		arg2_39()

		return
	end

	local var4_39 = var3_39[2] or {}

	if #var4_39 <= 0 then
		arg2_39()

		return
	end

	local var5_39 = var4_39[math.random(1, #var4_39)]

	arg0_39:HideOrShowUI(false)

	local function var6_39()
		arg0_39:HideOrShowUI(true)
		arg2_39()
	end

	if arg0_39.autoFlag then
		pg.NewStoryMgr.GetInstance():ForceAutoPlay(var5_39, var6_39, true, true)
	else
		pg.NewStoryMgr.GetInstance():Play(var5_39, var6_39, true)
	end
end

function var0_0.PlayRollAnimation(arg0_42, arg1_42, arg2_42)
	setText(findTF(arg0_42.rollStep, "animroot/Image/Text"), "00")

	local var0_42 = arg0_42.btnStart:GetComponent(typeof(Animation))
	local var1_42 = var0_42:GetComponent(typeof(DftAniEvent))
	local var2_42 = findTF(arg0_42.rollStep, "animroot"):GetComponent(typeof(Animation))
	local var3_42 = var2_42:GetComponent(typeof(DftAniEvent))

	var3_42:SetTriggerEvent(function()
		setText(findTF(arg0_42.rollStep, "animroot/Image/Text"), "0" .. arg1_42)
	end)
	seriesAsync({
		function(arg0_44)
			var1_42:SetEndEvent(function()
				setActive(arg0_42.btnStart, false)
				arg0_44()
			end)
			var0_42:Play("anim_monopolycar_mainui_btn_hide")
		end,
		function(arg0_46)
			setActive(arg0_42.rollStep, true)
			arg0_46()
		end,
		function(arg0_47)
			var3_42:SetEndEvent(function()
				arg0_47()
			end)
			var2_42:Play("anim_monopolycar_mainui_step_0" .. arg1_42)
		end,
		function(arg0_49)
			var3_42:SetEndEvent(function()
				setActive(arg0_42.rollStep, false)
				arg0_49()
			end)
			var2_42:Play("anim_monopolycar_mainui_step_hide")
		end
	}, function()
		setActive(arg0_42.btnStart, true)
		var0_42:Play("anim_monopolycar_mainui_btn_show")
		arg2_42()
	end)
end

function var0_0.CheckEventAndMove(arg0_52, arg1_52)
	local function var0_52()
		arg0_52:CheckEventAndMove(arg1_52)
	end

	if arg0_52.selectedShipId == 0 then
		arg0_52:CheckPickCharacter(var0_52)
	elseif arg0_52.effectId and arg0_52.effectId > 0 then
		arg0_52:CheckEvent(var0_52)
	elseif arg0_52.step and arg0_52.step > 0 then
		arg0_52:CheckMove(var0_52)
	else
		arg1_52()
	end
end

function var0_0.CheckEvent(arg0_54, arg1_54)
	if not arg0_54.effectId or arg0_54.effectId <= 0 then
		if arg1_54 then
			arg1_54()
		end

		return
	end

	local var0_54 = arg0_54.mapCells[arg0_54.pos]
	local var1_54 = {}

	seriesAsync({
		function(arg0_55)
			local var0_55 = pg.activity_event_monopoly_event[arg0_54.effectId].story

			if not var0_55 or tonumber(var0_55) == 0 then
				arg0_55()

				return
			end

			arg0_54:HideOrShowUI(false)

			if arg0_54.autoFlag then
				pg.NewStoryMgr.GetInstance():ForceAutoPlay(var0_55, arg0_55, true, true)
			else
				pg.NewStoryMgr.GetInstance():Play(var0_55, arg0_55, true, true)
			end
		end,
		function(arg0_56)
			arg0_54:HideOrShowUI(true)
			arg0_54:TriggerEvent(function(arg0_57)
				var1_54 = arg0_57

				arg0_56()
			end)
		end,
		function(arg0_58)
			arg0_54:ReadyMoveCar(var1_54, arg0_58)
		end,
		function(arg0_59)
			arg0_54:CheckCountStory(arg0_59)
		end
	}, arg1_54)
end

function var0_0.HideOrShowUI(arg0_60, arg1_60)
	for iter0_60, iter1_60 in ipairs(arg0_60.hideList) do
		setActive(iter1_60, arg1_60)
	end
end

function var0_0.TriggerEvent(arg0_61, arg1_61)
	arg0_61:emit(MonopolyCar2024Mediator.ON_TRIGGER, arg0_61.actId, function(arg0_62, arg1_62)
		if arg0_62 and #arg0_62 >= 0 then
			arg1_61(arg0_62)
		end
	end)
end

function var0_0.CheckCountStory(arg0_63, arg1_63)
	local var0_63 = arg0_63.useCount
	local var1_63 = arg0_63.storys
	local var2_63 = _.detect(var1_63, function(arg0_64)
		return arg0_64[1] == var0_63
	end)

	if var2_63 then
		pg.NewStoryMgr.GetInstance():Play(var2_63[2], arg1_63)
	else
		arg1_63()
	end
end

function var0_0.CheckSpEvent(arg0_65, arg1_65, arg2_65)
	if arg1_65.result and arg1_65.result > 0 then
		arg0_65:CheckRollResultForSpEvent(arg1_65.result, arg1_65.shipId)

		if arg2_65 then
			arg2_65()
		end
	elseif arg1_65.repeatChat then
		arg0_65:CheckRepeatCharForSpEvent(arg1_65.shipId)

		if arg2_65 then
			arg2_65()
		end
	elseif arg1_65.finished then
		arg0_65:CheckFinishedForSpEvent(arg1_65.shipId)

		if arg2_65 then
			arg2_65()
		end
	elseif arg2_65 then
		arg2_65()
	end
end

function var0_0.CheckFinishedForSpEvent(arg0_66, arg1_66)
	if arg0_66.turnCnt <= arg0_66.cacheTurnCnt then
		return
	end

	arg0_66.cacheTurnCnt = arg0_66.turnCnt

	local var0_66 = _.select(arg0_66.spEvents[arg1_66], function(arg0_67)
		return arg0_67[1] == 4
	end)

	if #var0_66 <= 0 then
		return
	end

	local var1_66 = var0_66[1][2] or {}
	local var2_66 = arg0_66:GetUnReadDialogue(var1_66)

	arg0_66.bubblePage:Show(arg0_66.actId, arg1_66, var2_66)
end

function var0_0.CheckRepeatCharForSpEvent(arg0_68, arg1_68)
	if not table.contains(arg0_68.pickCharList, arg1_68) then
		return
	end

	local var0_68 = _.select(arg0_68.spEvents[arg1_68] or {}, function(arg0_69)
		return arg0_69[1] == 5
	end)

	if #var0_68 <= 0 then
		return
	end

	local var1_68 = var0_68[1][2] or {}
	local var2_68 = arg0_68:GetUnReadDialogue(var1_68)

	arg0_68.bubblePage:Show(arg0_68.actId, arg1_68, var2_68)
end

function var0_0.GetUnReadDialogue(arg0_70, arg1_70)
	local var0_70 = {}

	for iter0_70, iter1_70 in ipairs(arg1_70) do
		if not table.contains(arg0_70.dialogRecorder, iter1_70) then
			table.insert(var0_70, iter1_70)
		end
	end

	if #var0_70 <= 0 then
		return arg1_70[math.random(1, #arg1_70)]
	end

	return var0_70[math.random(1, #var0_70)]
end

function var0_0.CheckRollResultForSpEvent(arg0_71, arg1_71, arg2_71)
	local var0_71 = {
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

	assert(arg0_71.spEvents[arg2_71], arg2_71)

	local var1_71 = _.select(arg0_71.spEvents[arg2_71] or {}, function(arg0_72)
		local var0_72 = var0_71[arg0_72[1]] or {
			99,
			99
		}

		return arg1_71 == var0_72[1] or arg1_71 == var0_72[2]
	end)

	if #var1_71 <= 0 then
		return
	end

	local var2_71 = var1_71[1][2] or {}
	local var3_71 = arg0_71:GetUnReadDialogue(var2_71)

	arg0_71.bubblePage:Show(arg0_71.actId, arg2_71, var3_71)
end

function var0_0.CheckMove(arg0_73, arg1_73)
	local var0_73 = {}

	seriesAsync({
		function(arg0_74)
			arg0_73:emit(MonopolyCar2024Mediator.ON_MOVE, arg0_73.actId, function(arg0_75, arg1_75, arg2_75)
				var0_73 = arg1_75

				arg0_74()
			end)
		end,
		function(arg0_76)
			arg0_73:ReadyMoveCar(var0_73, arg0_76)
		end
	}, arg1_73)
end

function var0_0.ReadyMoveCar(arg0_77, arg1_77, arg2_77)
	if not arg1_77 or #arg1_77 <= 0 then
		if arg2_77 then
			arg2_77()
		end

		return
	end

	local var0_77 = {}
	local var1_77 = arg0_77.car.localPosition
	local var2_77 = {}
	local var3_77 = {}

	for iter0_77 = 1, #arg1_77 do
		if arg0_77:CheckPathTurn(arg1_77[iter0_77]) then
			table.insert(var2_77, arg0_77.mapCells[arg1_77[iter0_77]].position)
			table.insert(var3_77, arg1_77[iter0_77])
		elseif iter0_77 == #arg1_77 then
			table.insert(var2_77, arg0_77.mapCells[arg1_77[iter0_77]].position)
			table.insert(var3_77, arg1_77[iter0_77])
		end
	end

	arg0_77.speedX = 0
	arg0_77.speedY = 0
	arg0_77.baseSpeed = 6
	arg0_77.baseASpeed = 0.1

	for iter1_77 = 1, #var2_77 do
		table.insert(var0_77, function(arg0_78)
			arg0_77.moveComplete = arg0_78
			arg0_77.stopOnEnd = false
			arg0_77.targetPosition = var2_77[iter1_77]
			arg0_77.targetPosIndex = var3_77[iter1_77]
			arg0_77.moveX = arg0_77.targetPosition.x - arg0_77.car.localPosition.x
			arg0_77.moveY = arg0_77.targetPosition.y - arg0_77.car.localPosition.y
			arg0_77.baseSpeedX = arg0_77.baseSpeed * (arg0_77.moveX / math.abs(arg0_77.moveX))
			arg0_77.baseASpeedX = arg0_77.baseASpeed * (arg0_77.moveX / math.abs(arg0_77.moveX))
			arg0_77.baseSpeedY = math.abs(arg0_77.baseSpeedX) / (math.abs(arg0_77.moveX) / arg0_77.moveY)
			arg0_77.baseASpeedY = math.abs(arg0_77.baseASpeedX) / (math.abs(arg0_77.moveX) / arg0_77.moveY)

			if iter1_77 == 1 then
				arg0_77.speedX = 0
				arg0_77.speedY = 0
			else
				arg0_77.speedX = arg0_77.baseSpeedX
				arg0_77.speedY = arg0_77.baseSpeedY
			end
		end)
	end

	table.insert(var0_77, function(arg0_79)
		arg0_77.moveComplete = nil

		arg0_77:UpdateCarPos(arg1_77[#arg1_77], false)
		arg0_79()
	end)
	table.insert(var0_77, function(arg0_80)
		LeanTween.value(go(arg0_77._tf), 1, 0, 0.1):setOnComplete(System.Action(arg0_80))
	end)
	seriesAsync(var0_77, arg2_77)
end

function var0_0.MoveCar(arg0_81)
	if not arg0_81.targetPosition then
		return
	end

	local var0_81 = math.abs(arg0_81.targetPosition.x - arg0_81.car.localPosition.x)
	local var1_81 = math.abs(arg0_81.targetPosition.y - arg0_81.car.localPosition.y)

	if var0_81 <= 6.5 and var1_81 <= 6.5 then
		arg0_81.targetPosition = nil

		if arg0_81.moveComplete then
			arg0_81:UpdateCarPos(arg0_81.targetPosIndex, true)
			arg0_81.moveComplete()
		end
	end

	arg0_81.speedX = math.abs(arg0_81.speedX + arg0_81.baseASpeedX) > math.abs(arg0_81.baseSpeedX) and arg0_81.baseSpeedX or arg0_81.speedX + arg0_81.baseASpeedX
	arg0_81.speedY = math.abs(arg0_81.speedY + arg0_81.baseASpeedY) > math.abs(arg0_81.baseSpeedY) and arg0_81.baseSpeedY or arg0_81.speedY + arg0_81.baseASpeedY

	local var2_81 = arg0_81.car.localPosition

	arg0_81.car.localPosition = Vector3(var2_81.x + arg0_81.speedX, var2_81.y + arg0_81.speedY, 0)
end

function var0_0.CheckPathTurn(arg0_82, arg1_82)
	local var0_82 = arg1_82 + 1 > #arg0_82.mapCells and 1 or arg1_82 + 1
	local var1_82 = arg1_82 - 1 < 1 and #arg0_82.mapCells or arg1_82 - 1

	if arg0_82.mapCells[var0_82].col == arg0_82.mapCells[var1_82].col or arg0_82.mapCells[var0_82].row == arg0_82.mapCells[var1_82].row then
		return false
	end

	return true
end

function var0_0.CheckPickCharacter(arg0_83, arg1_83)
	if arg0_83.selectedShipId == 0 or #arg0_83.pickCharList == 0 then
		local function var0_83(arg0_84)
			local var0_84 = arg0_83.pickableShipId[arg0_84]

			arg0_83:CheckSpEvent({
				repeatChat = true,
				shipId = var0_84
			})
			arg0_83:emit(MonopolyCar2024Mediator.ON_PICK, arg0_83.actId, var0_84, function(arg0_85)
				arg0_83.pickPage:Hide()
				seriesAsync({
					function(arg0_86)
						arg0_83:ReadyMoveCar(arg0_85, arg0_86)
					end,
					function(arg0_87)
						arg0_83:CheckEventAndMove(arg0_87)
					end
				}, arg1_83)
			end)
		end

		local var1_83 = _.map(arg0_83.pickCharList, function(arg0_88)
			return table.indexof(arg0_83.pickableShipId, arg0_88)
		end)

		arg0_83.pickPage:ExecuteAction("Show", arg0_83.actId, var1_83, arg0_83.autoFlag, var0_83)
	else
		arg1_83()
	end
end

function var0_0.InitMap(arg0_89)
	arg0_89.mapCells = {}

	for iter0_89 = 1, #var4_0 do
		local var0_89 = iter0_89 - 1
		local var1_89 = {
			x = -var0_89 * var1_0,
			y = -var0_89 * var2_0
		}
		local var2_89 = var4_0[iter0_89]

		for iter1_89 = 1, #var2_89 do
			local var3_89 = iter1_89 - 1
			local var4_89 = var2_89[iter1_89]

			if var4_89 > 0 then
				local var5_89 = cloneTplTo(arg0_89.tplMapCell, arg0_89.mapContainer, tostring(var4_89))
				local var6_89 = Vector2(var1_0 * var3_89 + var1_89.x, -var2_0 * var3_89 + var1_89.y)

				var5_89.localPosition = var6_89

				local var7_89 = pg.activity_event_monopoly_map[var4_89].icon
				local var8_89 = GetSpriteFromAtlas("ui/MonopolyCar2024_atlas", var7_89)

				var5_89:GetComponent(typeof(Image)).sprite = var8_89

				var5_89:GetComponent(typeof(Image)):SetNativeSize()

				local var9_89 = {
					col = var3_89,
					row = var0_89,
					mapId = var4_89,
					tf = var5_89,
					icon = var7_89,
					position = var6_89
				}

				table.insert(arg0_89.mapCells, var9_89)
			end
		end
	end

	table.sort(arg0_89.mapCells, function(arg0_90, arg1_90)
		return arg0_90.mapId < arg1_90.mapId
	end)
end

function var0_0.InitCar(arg0_91, arg1_91)
	PoolMgr.GetInstance():GetSpineChar(var3_0, true, function(arg0_92)
		arg0_91.model = arg0_92
		arg0_91.model.transform.localScale = Vector3.one
		arg0_91.model.transform.localPosition = Vector3.zero

		arg0_91.model.transform:SetParent(arg0_91.car, false)

		arg0_91.anim = arg0_91.model:GetComponent(typeof(SpineAnimUI))

		if arg0_91.pos then
			arg0_91:UpdateCarPos(arg0_91.pos, false)
		end

		arg1_91()
	end)
end

function var0_0.UpdateCarPos(arg0_93, arg1_93, arg2_93)
	if arg0_93.model then
		assert(arg0_93.mapCells[arg1_93], arg1_93)

		local var0_93 = arg0_93.mapCells[arg1_93].position
		local var1_93 = arg1_93 + 1 > #arg0_93.mapCells and 1 or arg1_93 + 1
		local var2_93 = arg0_93.mapCells[var1_93]
		local var3_93, var4_93 = arg0_93:GetCarMoveType(arg0_93.mapCells[arg1_93].mapId, arg0_93.mapCells[var1_93].mapId, arg2_93)

		arg0_93.car.localScale = var4_93

		arg0_93.anim:SetActionCallBack(nil)
		arg0_93.anim:SetAction(var3_93, 0)

		arg0_93.car.localPosition = var0_93

		arg0_93.car:SetAsLastSibling()
	end
end

function var0_0.GetCarMoveType(arg0_94, arg1_94, arg2_94, arg3_94)
	local var0_94 = {}
	local var1_94 = {}

	for iter0_94 = 1, #var4_0 do
		local var2_94 = var4_0[iter0_94]

		for iter1_94 = 1, #var2_94 do
			local var3_94 = var2_94[iter1_94]

			if var3_94 == arg1_94 then
				var0_94 = {
					x = iter1_94,
					y = iter0_94
				}
			end

			if var3_94 == arg2_94 then
				var1_94 = {
					x = iter1_94,
					y = iter0_94
				}
			end
		end
	end

	local var4_94
	local var5_94

	if var1_94.y > var0_94.y then
		var4_94 = arg3_94 and var11_0 or var9_0
		var5_94 = Vector3(var5_0, var5_0, var5_0)
	elseif var1_94.y < var0_94.y then
		var4_94 = arg3_94 and var10_0 or var8_0
		var5_94 = Vector3(var5_0, var5_0, var5_0)
	elseif var1_94.x > var0_94.x then
		var4_94 = arg3_94 and var11_0 or var9_0
		var5_94 = Vector3(-var5_0, var5_0, var5_0)
	elseif var1_94.x < var0_94.x then
		var4_94 = arg3_94 and var10_0 or var8_0
		var5_94 = Vector3(-var5_0, var5_0, var5_0)
	end

	return var4_94, var5_94
end

function var0_0.UpdateUI(arg0_95)
	setText(arg0_95.labelLeftCount, arg0_95.leftCount)
	setText(arg0_95.registerTxt, arg0_95.turnCnt - 1)
end

function var0_0.UpdateActivity(arg0_96, arg1_96)
	arg0_96:UpdateActData(arg1_96)
	arg0_96:UpdateUI()
end

function var0_0.Dispose(arg0_97)
	for iter0_97, iter1_97 in pairs(arg0_97.cheerLeaders) do
		PoolMgr.GetInstance():ReturnSpineChar(iter0_97, iter1_97)
	end

	if arg0_97.handle then
		UpdateBeat:RemoveListener(arg0_97.handle)

		arg0_97.handle = nil
	end

	if arg0_97.awardWindow then
		arg0_97.awardWindow:Destroy()

		arg0_97.awardWindow = nil
	end

	if arg0_97.pickPage then
		if arg0_97.pickPage:isShowing() then
			arg0_97.pickPage:Hide()
		end

		arg0_97.pickPage:Destroy()

		arg0_97.pickPage = nil
	end

	if arg0_97.resultPage then
		arg0_97.resultPage:Destroy()

		arg0_97.resultPage = nil
	end

	if arg0_97.awardCollector then
		arg0_97.awardCollector:Dispose()

		arg0_97.awardCollector = nil
	end

	arg0_97.bubblePage:Dispose()
	pg.DelegateInfo.Dispose(arg0_97)
	PoolMgr.GetInstance():ReturnSpineChar(var3_0, arg0_97.model)
end

return var0_0
