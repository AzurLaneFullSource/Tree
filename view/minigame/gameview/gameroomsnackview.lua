local var0 = class("GameRoomSnackView", import(".GameRoomBaseSnackView"))

function var0.getUIName(arg0)
	return "GameRoomSnackUI"
end

function var0.OnSendMiniGameOPDone(arg0)
	arg0:updateCount()
end

function var0.OnGetAwardDone(arg0)
	if arg0.coinLayerVisible then
		arg0:openCoinLayer(true)
	end
end

function var0.addListener(arg0)
	var0.super.addListener(arg0)

	if arg0:getGameRoomData() then
		arg0.gameHelpTip = arg0:getGameRoomData().game_help
	end

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0.gameHelpTip
		})
	end, SFX_PANEL)
end

function var0.updateSDModel(arg0)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = getProxy(BayProxy)
	local var2 = "Z28"

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var2, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.prefab = var2
		arg0.model = arg0
		tf(arg0).localScale = Vector3(1, 1, 1)

		arg0:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
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
			setImageSprite(var3, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var4))
		end
	end
end

function var0.updateSnackList(arg0, arg1)
	for iter0 = 1, var0.Snack_Num do
		local var0 = arg0.snackContainer:GetChild(iter0 - 1)
		local var1 = arg0:findTF("SnackImg", var0)
		local var2 = arg1[iter0]

		setImageSprite(var1, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var2))

		local var3 = arg0:findTF("SelectedTag", var0)

		setActive(var3, false)

		arg0.snackTFList[iter0] = var0
		iter0 = iter0 + 1
	end
end

function var0.updateSelectedOrderTag(arg0, arg1)
	for iter0, iter1 in pairs(arg0.selectedSnackTFList) do
		local var0 = arg0:findTF("SelectedTag", iter1)

		if arg1 then
			setActive(var0, false)
		else
			local var1 = table.indexof(arg0.selectedIDList, iter0, 1)

			setImageSprite(var0, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "order_" .. var1))
		end
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

			arg0:openCoinLayer(true)
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
	arg0.snackResultView = NewYearSnackResultView.New(arg0._tf, arg0.event, arg0.packageData)

	arg0.snackResultView:Reset()
	arg0.snackResultView:Load()
end

return var0
