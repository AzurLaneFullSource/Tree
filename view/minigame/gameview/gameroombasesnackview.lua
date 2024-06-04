local var0 = class("GameRoomBaseSnackView", import("..BaseMiniGameView"))

var0.States_Before = 0
var0.States_Memory = 1
var0.States_Select = 2
var0.States_Finished = 3
var0.Ani_Close_2_Open = true
var0.Ani_Open_2_Close = false
var0.Bubble_Fade_Time = 0.5
var0.Order_Num = 3
var0.Snack_Num = 9

function var0.getUIName(arg0)
	return "GameRoomSnackUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:initList()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:initTime()
	arg0:updateSDModel()
	arg0:setState(var0.States_Before)

	if arg0:getGameRoomData() then
		arg0.gameHelpTip = arg0:getGameRoomData().game_help
	end
end

function var0.OnGetAwardDone(arg0, arg1)
	if arg1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0 = arg0:GetMGHubData()

		if var0.ultimate == 0 and var0.usedtime >= var0:getConfig("reward_need") then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif arg1.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		-- block empty
	end
end

function var0.OnSendMiniGameOPDone(arg0)
	arg0:updateCount()

	local var0 = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.ShrineGameID):GetRuntimeData("count") or 0) + 1

	pg.m02:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
		id = MiniGameDataCreator.ShrineGameID,
		map = {
			count = var0
		}
	})
end

function var0.onBackPressed(arg0)
	if arg0.state == var0.States_Before then
		arg0:emit(var0.ON_BACK_PRESSED)

		return
	end

	if arg0.timer then
		arg0.timer:Stop()
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("tips_summergame_exit"),
		onYes = function()
			arg0.countTime = 0

			arg0:setState(var0.States_Finished)
		end,
		onNo = function()
			arg0.timer:Start()
		end
	})
end

function var0.willExit(arg0)
	if arg0.timer then
		arg0.timer:Stop()
	end

	if arg0.prefab and arg0.model then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab, arg0.model)

		arg0.prefab = nil
		arg0.model = nil
	end
end

function var0.findUI(arg0)
	local var0 = arg0:findTF("ForNotch")

	arg0.backBtn = arg0:findTF("BackBtn", var0)
	arg0.helpBtn = arg0:findTF("HelpBtn", var0)
	arg0.countText = arg0:findTF("Count/CountText", var0)

	local var1 = arg0:findTF("GameContent")

	arg0.startBtn = arg0:findTF("StartBtn", var1)
	arg0.ruleBtn = arg0:findTF("RuleBtn", var1)

	local var2 = arg0:findTF("Tip", var1)

	arg0.considerTipTF = arg0:findTF("ConsiderTip", var2)
	arg0.considerTimeText = arg0:findTF("TimeText", arg0.considerTipTF)
	arg0.selectTipTF = arg0:findTF("SelectTip", var2)
	arg0.selectTimeText = arg0:findTF("TimeText", arg0.selectTipTF)
	arg0.selectedContainer = arg0:findTF("SelectedContainer", var1)
	arg0.selectedTpl = arg0:findTF("SelectedTpl", var1)
	arg0.selectedContainerCG = GetComponent(arg0.selectedContainer, "CanvasGroup")
	arg0.snackContainer = arg0:findTF("SnackContainer", var1)
	arg0.animtor = GetComponent(arg0.snackContainer, "Animator")
	arg0.dftAniEvent = GetComponent(arg0.snackContainer, "DftAniEvent")

	arg0.dftAniEvent:SetEndEvent(function(arg0)
		arg0:setState(var0.States_Select)
	end)

	arg0.spineCharContainer = arg0:findTF("SpineChar", var1)
end

function var0.initData(arg0)
	arg0.state = nil
	arg0.orderIDList = {}
	arg0.selectedIDList = {}
	arg0.snackIDList = {}
	arg0.score = 0
	arg0.packageData = {}
	arg0.selectedTFList = {}
	arg0.snackTFList = {}
	arg0.selectedSnackTFList = {}
end

function var0.initTime(arg0)
	arg0.orginMemoryTime = arg0:GetMGData():getConfig("simple_config_data").memory_time
	arg0.orginSelectTime = arg0:GetMGData():getConfig("simple_config_data").select_time
	arg0.countTime = nil
	arg0.leftTime = arg0.orginSelectTime
end

function var0.initTimer(arg0, arg1)
	if arg0.state == var0.States_Memory then
		arg0.countTime = arg0.orginMemoryTime
	elseif arg0.state == var0.States_Select then
		arg0.countTime = arg0.leftTime
	end

	arg0.timer = Timer.New(arg1, 1, -1)

	arg0.timer:Start()
end

function var0.initList(arg0)
	for iter0 = 1, var0.Order_Num do
		local var0 = arg0.selectedContainer:GetChild(iter0 - 1)

		arg0.selectedTFList[iter0] = var0
	end

	for iter1 = 1, var0.Snack_Num do
		local var1 = arg0.snackContainer:GetChild(iter1 - 1)

		arg0.snackTFList[iter1] = var1
	end
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0.startBtn, function()
		arg0:openCoinLayer(false)
		arg0:setState(var0.States_Memory)
	end, SFX_PANEL)
	onButton(arg0, arg0.ruleBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0.gameHelpTip
		})
	end, SFX_PANEL)

	for iter0 = 1, var0.Snack_Num do
		local var0 = arg0.snackContainer:GetChild(iter0 - 1)

		onButton(arg0, var0, function()
			local var0 = arg0.snackIDList[iter0]
			local var1 = arg0:findTF("SelectedTag", var0)

			if isActive(var1) == true then
				table.removebyvalue(arg0.selectedIDList, var0)
				arg0:updateSelectedList(arg0.selectedIDList)

				arg0.selectedSnackTFList[var0] = nil

				setActive(var1, false)
				arg0:updateSelectedOrderTag()
			else
				table.insert(arg0.selectedIDList, var0)
				arg0:updateSelectedList(arg0.selectedIDList)

				arg0.selectedSnackTFList[var0] = var0

				setActive(var1, true)
				arg0:updateSelectedOrderTag()

				if #arg0.selectedIDList == var0.Order_Num then
					arg0.timer:Stop()
					arg0:setState(var0.States_Finished)
				end
			end
		end, SFX_PANEL)
	end
end

function var0.updateSDModel(arg0)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = getProxy(BayProxy):getShipById(var0.character):getPrefab()

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var1, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.prefab = var1
		arg0.model = arg0
		tf(arg0).localScale = Vector3(1, 1, 1)

		arg0:GetComponent("SpineAnimUI"):SetAction("stand", 0)
		setParent(arg0, arg0.spineCharContainer)
	end)
end

function var0.updateSelectedList(arg0, arg1)
	arg1 = arg1 or {}

	for iter0 = 1, var0.Order_Num do
		local var0 = arg0.selectedContainer:GetChild(iter0 - 1)
		local var1 = arg0:findTF("Empty", var0)
		local var2 = arg0:findTF("Full", var0)
		local var3 = arg0:findTF("SnackImg", var2)

		arg0.selectedTFList[iter0] = var0

		local var4 = arg1[iter0]

		setActive(var2, var4)
		setActive(var1, not var4)

		if var4 then
			setImageSprite(var3, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var4))
		end
	end
end

function var0.updateSnackList(arg0, arg1)
	for iter0 = 1, var0.Snack_Num do
		local var0 = arg0.snackContainer:GetChild(iter0 - 1)
		local var1 = arg0:findTF("SnackImg", var0)
		local var2 = arg1[iter0]

		setImageSprite(var1, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var2))

		local var3 = arg0:findTF("SelectedTag", var0)

		setActive(var3, false)

		arg0.snackTFList[iter0] = var0
		iter0 = iter0 + 1
	end
end

function var0.updateCount(arg0)
	setText(arg0.countText, arg0:GetMGHubData().count)
end

function var0.updateSelectedOrderTag(arg0, arg1)
	for iter0, iter1 in pairs(arg0.selectedSnackTFList) do
		local var0 = arg0:findTF("SelectedTag", iter1)

		if arg1 then
			setActive(var0, false)
		else
			local var1 = table.indexof(arg0.selectedIDList, iter0, 1)

			setImageSprite(var0, GetSpriteFromAtlas("ui/snackui_atlas", "order_" .. var1))
		end
	end
end

function var0.updateSnackInteractable(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.snackTFList) do
		setButtonEnabled(iter1, arg1)
	end
end

function var0.onStateChange(arg0)
	if arg0.state == var0.States_Before then
		setActive(arg0.selectedContainer, false)
		setActive(arg0.startBtn, true)
		setActive(arg0.ruleBtn, true)
		setActive(arg0.considerTipTF, false)
		setActive(arg0.selectTipTF, false)
		arg0:updateCount()
		arg0:updateSnackInteractable(false)
	elseif arg0.state == var0.States_Memory then
		setActive(arg0.selectedContainer, true)
		setActive(arg0.startBtn, false)
		setActive(arg0.ruleBtn, false)

		arg0.orderIDList = arg0:randFetch(3, 9)

		arg0:updateSelectedList(arg0.orderIDList)

		arg0.snackIDList = arg0:randFetch(9, 9)

		arg0:updateSnackList(arg0.snackIDList)
		arg0:updateSnackInteractable(false)

		local var0 = function()
			arg0.countTime = arg0.countTime - 1

			setText(arg0.considerTimeText, arg0.countTime)

			if arg0.countTime <= 0 then
				arg0.timer:Stop()
				arg0.animtor:SetBool("AniSwitch", var0.Ani_Close_2_Open)
			end
		end

		LeanTween.value(go(arg0.selectedContainer), 0, 1, var0.Bubble_Fade_Time):setOnUpdate(System.Action_float(function(arg0)
			arg0.selectedContainerCG.alpha = arg0
		end)):setOnComplete(System.Action(function()
			setActive(arg0.considerTipTF, true)
			setActive(arg0.selectTipTF, false)
			arg0:initTimer(var0)
			setText(arg0.considerTimeText, arg0.countTime)
		end))
	elseif arg0.state == var0.States_Select then
		setActive(arg0.considerTipTF, false)
		setActive(arg0.selectTipTF, true)
		arg0:updateSelectedList()
		arg0:updateSnackInteractable(true)

		local function var1()
			arg0.countTime = arg0.countTime - 1

			setText(arg0.selectTimeText, arg0.countTime)

			if arg0.countTime <= 0 then
				arg0.timer:Stop()
				arg0:setState(var0.States_Finished)
			end
		end

		arg0:initTimer(var1)
		setText(arg0.selectTimeText, arg0.countTime)
	elseif arg0.state == var0.States_Finished then
		arg0:updateSnackInteractable(false)
		LeanTween.value(go(arg0.selectedContainer), 1, 0, var0.Bubble_Fade_Time):setOnUpdate(System.Action_float(function(arg0)
			arg0.selectedContainerCG.alpha = arg0
		end)):setOnComplete(System.Action(function()
			arg0:openResultView()
		end))
	end
end

function var0.openResultView(arg0)
	arg0.packageData = {
		orderIDList = arg0.orderIDList,
		selectedIDList = arg0.selectedIDList,
		countTime = arg0.countTime,
		score = arg0.score,
		correctNumToEXValue = arg0:GetMGData():getConfig("simple_config_data").correct_value,
		scoreLevel = arg0:GetMGData():getConfig("simple_config_data").score_level,
		onSubmit = function(arg0)
			arg0:SendSuccess(arg0.score)

			arg0.score = 0
			arg0.countTime = nil
			arg0.leftTime = arg0.orginSelectTime
			arg0.orderIDList = {}
			arg0.selectedIDList = {}
			arg0.snackIDList = {}

			arg0:updateSelectedOrderTag(true)

			arg0.selectedSnackTFList = {}

			arg0.animtor:SetBool("AniSwitch", var0.Ani_Open_2_Close)
			arg0:setState(var0.States_Before)
		end,
		onContinue = function()
			arg0.score = arg0.packageData.score
			arg0.leftTime = arg0.packageData.countTime
			arg0.orderIDList = {}
			arg0.selectedIDList = {}
			arg0.snackIDList = {}
			arg0.selectedSnackTFList = {}

			arg0.animtor:SetBool("AniSwitch", var0.Ani_Open_2_Close)
			arg0:setState(var0.States_Memory)
		end
	}
	arg0.snackResultView = SnackResultView.New(arg0._tf, arg0.event, arg0.packageData)

	arg0.snackResultView:Reset()
	arg0.snackResultView:Load()
end

function var0.randFetch(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}

	for iter0 = 1, arg1 do
		local var2 = math.random(iter0, arg2)
		local var3 = var1[var2] or var2

		var1[var2] = var1[iter0] or iter0
		var1[iter0] = var3

		table.insert(var0, var3)
	end

	return var0
end

function var0.setState(arg0, arg1)
	if arg0.state == arg1 then
		return
	end

	arg0.state = arg1

	arg0:onStateChange()
end

return var0
