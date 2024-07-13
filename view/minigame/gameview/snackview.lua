local var0_0 = class("SnackView", import("..BaseMiniGameView"))

var0_0.States_Before = 0
var0_0.States_Memory = 1
var0_0.States_Select = 2
var0_0.States_Finished = 3
var0_0.Ani_Close_2_Open = true
var0_0.Ani_Open_2_Close = false
var0_0.Bubble_Fade_Time = 0.5
var0_0.Order_Num = 3
var0_0.Snack_Num = 9

function var0_0.getUIName(arg0_1)
	return "Snack"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:initList()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:initTime()
	arg0_3:updateSDModel()
	arg0_3:setState(var0_0.States_Before)
end

function var0_0.OnGetAwardDone(arg0_4, arg1_4)
	if arg1_4.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0_4 = arg0_4:GetMGHubData()

		if var0_4.ultimate == 0 and var0_4.usedtime >= var0_4:getConfig("reward_need") then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0_4.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif arg1_4.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		-- block empty
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_5)
	arg0_5:updateCount()

	local var0_5 = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.ShrineGameID):GetRuntimeData("count") or 0) + 1

	pg.m02:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
		id = MiniGameDataCreator.ShrineGameID,
		map = {
			count = var0_5
		}
	})
end

function var0_0.onBackPressed(arg0_6)
	if arg0_6.state == var0_0.States_Before then
		arg0_6:emit(var0_0.ON_BACK_PRESSED)

		return
	end

	if arg0_6.timer then
		arg0_6.timer:Stop()
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("tips_summergame_exit"),
		onYes = function()
			arg0_6.countTime = 0

			arg0_6.timer:Start()
		end,
		onNo = function()
			arg0_6.timer:Start()
		end
	})
end

function var0_0.willExit(arg0_9)
	if arg0_9.timer then
		arg0_9.timer:Stop()
	end

	if arg0_9.prefab and arg0_9.model then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_9.prefab, arg0_9.model)

		arg0_9.prefab = nil
		arg0_9.model = nil
	end
end

function var0_0.findUI(arg0_10)
	local var0_10 = arg0_10:findTF("ForNotch")

	arg0_10.backBtn = arg0_10:findTF("BackBtn", var0_10)
	arg0_10.helpBtn = arg0_10:findTF("HelpBtn", var0_10)
	arg0_10.countText = arg0_10:findTF("Count/CountText", var0_10)

	local var1_10 = arg0_10:findTF("GameContent")

	arg0_10.startBtn = arg0_10:findTF("StartBtn", var1_10)

	local var2_10 = arg0_10:findTF("Tip", var1_10)

	arg0_10.considerTipTF = arg0_10:findTF("ConsiderTip", var2_10)
	arg0_10.considerTimeText = arg0_10:findTF("TimeText", arg0_10.considerTipTF)
	arg0_10.selectTipTF = arg0_10:findTF("SelectTip", var2_10)
	arg0_10.selectTimeText = arg0_10:findTF("TimeText", arg0_10.selectTipTF)
	arg0_10.selectedContainer = arg0_10:findTF("SelectedContainer", var1_10)
	arg0_10.selectedTpl = arg0_10:findTF("SelectedTpl", var1_10)
	arg0_10.selectedContainerCG = GetComponent(arg0_10.selectedContainer, "CanvasGroup")
	arg0_10.snackContainer = arg0_10:findTF("SnackContainer", var1_10)
	arg0_10.animtor = GetComponent(arg0_10.snackContainer, "Animator")
	arg0_10.dftAniEvent = GetComponent(arg0_10.snackContainer, "DftAniEvent")

	arg0_10.dftAniEvent:SetEndEvent(function(arg0_11)
		arg0_10:setState(var0_0.States_Select)
	end)

	arg0_10.spineCharContainer = arg0_10:findTF("SpineChar", var1_10)
end

function var0_0.initData(arg0_12)
	arg0_12.state = nil
	arg0_12.orderIDList = {}
	arg0_12.selectedIDList = {}
	arg0_12.snackIDList = {}
	arg0_12.score = 0
	arg0_12.packageData = {}
	arg0_12.selectedTFList = {}
	arg0_12.snackTFList = {}
	arg0_12.selectedSnackTFList = {}
end

function var0_0.initTime(arg0_13)
	arg0_13.orginMemoryTime = arg0_13:GetMGData():getConfig("simple_config_data").memory_time
	arg0_13.orginSelectTime = arg0_13:GetMGData():getConfig("simple_config_data").select_time
	arg0_13.countTime = nil
	arg0_13.leftTime = arg0_13.orginSelectTime
end

function var0_0.initTimer(arg0_14, arg1_14)
	if arg0_14.state == var0_0.States_Memory then
		arg0_14.countTime = arg0_14.orginMemoryTime
	elseif arg0_14.state == var0_0.States_Select then
		arg0_14.countTime = arg0_14.leftTime
	end

	arg0_14.timer = Timer.New(arg1_14, 1, -1)

	arg0_14.timer:Start()
end

function var0_0.initList(arg0_15)
	for iter0_15 = 1, var0_0.Order_Num do
		local var0_15 = arg0_15.selectedContainer:GetChild(iter0_15 - 1)

		arg0_15.selectedTFList[iter0_15] = var0_15
	end

	for iter1_15 = 1, var0_0.Snack_Num do
		local var1_15 = arg0_15.snackContainer:GetChild(iter1_15 - 1)

		arg0_15.snackTFList[iter1_15] = var1_15
	end
end

function var0_0.addListener(arg0_16)
	onButton(arg0_16, arg0_16.backBtn, function()
		arg0_16:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_summer_food.tip
		})
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.startBtn, function()
		arg0_16:setState(var0_0.States_Memory)
	end, SFX_PANEL)

	for iter0_16 = 1, var0_0.Snack_Num do
		local var0_16 = arg0_16.snackContainer:GetChild(iter0_16 - 1)

		onButton(arg0_16, var0_16, function()
			local var0_20 = arg0_16.snackIDList[iter0_16]
			local var1_20 = arg0_16:findTF("SelectedTag", var0_16)

			if isActive(var1_20) == true then
				table.removebyvalue(arg0_16.selectedIDList, var0_20)
				arg0_16:updateSelectedList(arg0_16.selectedIDList)

				arg0_16.selectedSnackTFList[var0_20] = nil

				setActive(var1_20, false)
				arg0_16:updateSelectedOrderTag()
			else
				table.insert(arg0_16.selectedIDList, var0_20)
				arg0_16:updateSelectedList(arg0_16.selectedIDList)

				arg0_16.selectedSnackTFList[var0_20] = var0_16

				setActive(var1_20, true)
				arg0_16:updateSelectedOrderTag()

				if #arg0_16.selectedIDList == var0_0.Order_Num then
					arg0_16.timer:Stop()
					arg0_16:setState(var0_0.States_Finished)
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateSDModel(arg0_21)
	local var0_21 = getProxy(PlayerProxy):getData()
	local var1_21 = getProxy(BayProxy):getShipById(var0_21.character):getPrefab()

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var1_21, true, function(arg0_22)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_21.prefab = var1_21
		arg0_21.model = arg0_22
		tf(arg0_22).localScale = Vector3(1, 1, 1)

		arg0_22:GetComponent("SpineAnimUI"):SetAction("stand", 0)
		setParent(arg0_22, arg0_21.spineCharContainer)
	end)
end

function var0_0.updateSelectedList(arg0_23, arg1_23)
	arg1_23 = arg1_23 or {}

	for iter0_23 = 1, var0_0.Order_Num do
		local var0_23 = arg0_23.selectedContainer:GetChild(iter0_23 - 1)
		local var1_23 = arg0_23:findTF("Empty", var0_23)
		local var2_23 = arg0_23:findTF("Full", var0_23)
		local var3_23 = arg0_23:findTF("SnackImg", var2_23)

		arg0_23.selectedTFList[iter0_23] = var0_23

		local var4_23 = arg1_23[iter0_23]

		setActive(var2_23, var4_23)
		setActive(var1_23, not var4_23)

		if var4_23 then
			setImageSprite(var3_23, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var4_23))
		end
	end
end

function var0_0.updateSnackList(arg0_24, arg1_24)
	for iter0_24 = 1, var0_0.Snack_Num do
		local var0_24 = arg0_24.snackContainer:GetChild(iter0_24 - 1)
		local var1_24 = arg0_24:findTF("SnackImg", var0_24)
		local var2_24 = arg1_24[iter0_24]

		setImageSprite(var1_24, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var2_24))

		local var3_24 = arg0_24:findTF("SelectedTag", var0_24)

		setActive(var3_24, false)

		arg0_24.snackTFList[iter0_24] = var0_24
		iter0_24 = iter0_24 + 1
	end
end

function var0_0.updateCount(arg0_25)
	setText(arg0_25.countText, arg0_25:GetMGHubData().count)
end

function var0_0.updateSelectedOrderTag(arg0_26, arg1_26)
	for iter0_26, iter1_26 in pairs(arg0_26.selectedSnackTFList) do
		local var0_26 = arg0_26:findTF("SelectedTag", iter1_26)

		if arg1_26 then
			setActive(var0_26, false)
		else
			local var1_26 = table.indexof(arg0_26.selectedIDList, iter0_26, 1)

			setImageSprite(var0_26, GetSpriteFromAtlas("ui/snackui_atlas", "order_" .. var1_26))
		end
	end
end

function var0_0.updateSnackInteractable(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.snackTFList) do
		setButtonEnabled(iter1_27, arg1_27)
	end
end

function var0_0.onStateChange(arg0_28)
	if arg0_28.state == var0_0.States_Before then
		setActive(arg0_28.selectedContainer, false)
		setActive(arg0_28.startBtn, true)
		setActive(arg0_28.considerTipTF, false)
		setActive(arg0_28.selectTipTF, false)
		arg0_28:updateCount()
		arg0_28:updateSnackInteractable(false)
	elseif arg0_28.state == var0_0.States_Memory then
		setActive(arg0_28.selectedContainer, true)
		setActive(arg0_28.startBtn, false)

		arg0_28.orderIDList = arg0_28:randFetch(3, 9)

		arg0_28:updateSelectedList(arg0_28.orderIDList)

		arg0_28.snackIDList = arg0_28:randFetch(9, 9)

		arg0_28:updateSnackList(arg0_28.snackIDList)
		arg0_28:updateSnackInteractable(false)

		local function var0_28()
			arg0_28.countTime = arg0_28.countTime - 1

			setText(arg0_28.considerTimeText, arg0_28.countTime)

			if arg0_28.countTime == 0 then
				arg0_28.timer:Stop()
				arg0_28.animtor:SetBool("AniSwitch", var0_0.Ani_Close_2_Open)
			end
		end

		LeanTween.value(go(arg0_28.selectedContainer), 0, 1, var0_0.Bubble_Fade_Time):setOnUpdate(System.Action_float(function(arg0_30)
			arg0_28.selectedContainerCG.alpha = arg0_30
		end)):setOnComplete(System.Action(function()
			setActive(arg0_28.considerTipTF, true)
			setActive(arg0_28.selectTipTF, false)
			arg0_28:initTimer(var0_28)
			setText(arg0_28.considerTimeText, arg0_28.countTime)
		end))
	elseif arg0_28.state == var0_0.States_Select then
		setActive(arg0_28.considerTipTF, false)
		setActive(arg0_28.selectTipTF, true)
		arg0_28:updateSelectedList()
		arg0_28:updateSnackInteractable(true)

		local function var1_28()
			arg0_28.countTime = arg0_28.countTime - 1

			setText(arg0_28.selectTimeText, arg0_28.countTime)

			if arg0_28.countTime == 0 then
				arg0_28.timer:Stop()
				arg0_28:setState(var0_0.States_Finished)
			end
		end

		arg0_28:initTimer(var1_28)
		setText(arg0_28.selectTimeText, arg0_28.countTime)
	elseif arg0_28.state == var0_0.States_Finished then
		arg0_28:updateSnackInteractable(false)
		LeanTween.value(go(arg0_28.selectedContainer), 1, 0, var0_0.Bubble_Fade_Time):setOnUpdate(System.Action_float(function(arg0_33)
			arg0_28.selectedContainerCG.alpha = arg0_33
		end)):setOnComplete(System.Action(function()
			arg0_28:openResultView()
		end))
	end
end

function var0_0.openResultView(arg0_35)
	arg0_35.packageData = {
		orderIDList = arg0_35.orderIDList,
		selectedIDList = arg0_35.selectedIDList,
		countTime = arg0_35.countTime,
		score = arg0_35.score,
		correctNumToEXValue = arg0_35:GetMGData():getConfig("simple_config_data").correct_value,
		scoreLevel = arg0_35:GetMGData():getConfig("simple_config_data").score_level,
		onSubmit = function(arg0_36)
			if arg0_35:GetMGHubData().count > 0 then
				arg0_35:SendSuccess(arg0_36)
			end

			arg0_35.score = 0
			arg0_35.countTime = nil
			arg0_35.leftTime = arg0_35.orginSelectTime
			arg0_35.orderIDList = {}
			arg0_35.selectedIDList = {}
			arg0_35.snackIDList = {}

			arg0_35:updateSelectedOrderTag(true)

			arg0_35.selectedSnackTFList = {}

			arg0_35.animtor:SetBool("AniSwitch", var0_0.Ani_Open_2_Close)
			arg0_35:setState(var0_0.States_Before)
		end,
		onContinue = function()
			arg0_35.score = arg0_35.packageData.score
			arg0_35.leftTime = arg0_35.packageData.countTime
			arg0_35.orderIDList = {}
			arg0_35.selectedIDList = {}
			arg0_35.snackIDList = {}
			arg0_35.selectedSnackTFList = {}

			arg0_35.animtor:SetBool("AniSwitch", var0_0.Ani_Open_2_Close)
			arg0_35:setState(var0_0.States_Memory)
		end
	}
	arg0_35.snackResultView = SnackResultView.New(arg0_35._tf, arg0_35.event, arg0_35.packageData)

	arg0_35.snackResultView:Reset()
	arg0_35.snackResultView:Load()
end

function var0_0.randFetch(arg0_38, arg1_38, arg2_38)
	local var0_38 = {}
	local var1_38 = {}

	for iter0_38 = 1, arg1_38 do
		local var2_38 = math.random(iter0_38, arg2_38)
		local var3_38 = var1_38[var2_38] or var2_38

		var1_38[var2_38] = var1_38[iter0_38] or iter0_38
		var1_38[iter0_38] = var3_38

		table.insert(var0_38, var3_38)
	end

	return var0_38
end

function var0_0.setState(arg0_39, arg1_39)
	if arg0_39.state == arg1_39 then
		return
	end

	arg0_39.state = arg1_39

	arg0_39:onStateChange()
end

return var0_0
