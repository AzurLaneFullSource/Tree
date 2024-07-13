local var0_0 = class("GameRoomSnackView", import(".GameRoomBaseSnackView"))

function var0_0.getUIName(arg0_1)
	return "GameRoomSnackUI"
end

function var0_0.OnSendMiniGameOPDone(arg0_2)
	arg0_2:updateCount()
end

function var0_0.OnGetAwardDone(arg0_3)
	if arg0_3.coinLayerVisible then
		arg0_3:openCoinLayer(true)
	end
end

function var0_0.addListener(arg0_4)
	var0_0.super.addListener(arg0_4)

	if arg0_4:getGameRoomData() then
		arg0_4.gameHelpTip = arg0_4:getGameRoomData().game_help
	end

	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_4.gameHelpTip
		})
	end, SFX_PANEL)
end

function var0_0.updateSDModel(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getData()
	local var1_6 = getProxy(BayProxy)
	local var2_6 = "Z28"

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var2_6, true, function(arg0_7)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_6.prefab = var2_6
		arg0_6.model = arg0_7
		tf(arg0_7).localScale = Vector3(1, 1, 1)

		arg0_7:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0_7, arg0_6.spineCharContainer)
	end)
end

function var0_0.updateSelectedList(arg0_8, arg1_8)
	arg1_8 = arg1_8 or {}

	for iter0_8 = 1, var0_0.Order_Num do
		local var0_8 = arg0_8.selectedContainer:GetChild(iter0_8 - 1)
		local var1_8 = arg0_8:findTF("Empty", var0_8)
		local var2_8 = arg0_8:findTF("Full", var0_8)
		local var3_8 = arg0_8:findTF("SnackImg", var2_8)

		arg0_8.selectedTFList[iter0_8] = var0_8

		local var4_8 = arg1_8[iter0_8]

		setActive(var2_8, var4_8)
		setActive(var1_8, not var4_8)

		if var4_8 then
			setImageSprite(var3_8, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var4_8))
		end
	end
end

function var0_0.updateSnackList(arg0_9, arg1_9)
	for iter0_9 = 1, var0_0.Snack_Num do
		local var0_9 = arg0_9.snackContainer:GetChild(iter0_9 - 1)
		local var1_9 = arg0_9:findTF("SnackImg", var0_9)
		local var2_9 = arg1_9[iter0_9]

		setImageSprite(var1_9, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var2_9))

		local var3_9 = arg0_9:findTF("SelectedTag", var0_9)

		setActive(var3_9, false)

		arg0_9.snackTFList[iter0_9] = var0_9
		iter0_9 = iter0_9 + 1
	end
end

function var0_0.updateSelectedOrderTag(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.selectedSnackTFList) do
		local var0_10 = arg0_10:findTF("SelectedTag", iter1_10)

		if arg1_10 then
			setActive(var0_10, false)
		else
			local var1_10 = table.indexof(arg0_10.selectedIDList, iter0_10, 1)

			setImageSprite(var0_10, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "order_" .. var1_10))
		end
	end
end

function var0_0.openResultView(arg0_11)
	arg0_11.packageData = {
		orderIDList = arg0_11.orderIDList,
		selectedIDList = arg0_11.selectedIDList,
		countTime = arg0_11.countTime,
		score = arg0_11.score,
		correctNumToEXValue = arg0_11:GetMGData():getConfig("simple_config_data").correct_value,
		scoreLevel = arg0_11:GetMGData():getConfig("simple_config_data").score_level,
		onSubmit = function(arg0_12)
			arg0_11:SendSuccess(arg0_11.score)

			arg0_11.score = 0
			arg0_11.countTime = nil
			arg0_11.leftTime = arg0_11.orginSelectTime
			arg0_11.orderIDList = {}
			arg0_11.selectedIDList = {}
			arg0_11.snackIDList = {}

			arg0_11:updateSelectedOrderTag(true)

			arg0_11.selectedSnackTFList = {}

			arg0_11:openCoinLayer(true)
			arg0_11.animtor:SetBool("AniSwitch", var0_0.Ani_Open_2_Close)
			arg0_11:setState(var0_0.States_Before)
		end,
		onContinue = function()
			arg0_11.score = arg0_11.packageData.score
			arg0_11.leftTime = arg0_11.packageData.countTime
			arg0_11.orderIDList = {}
			arg0_11.selectedIDList = {}
			arg0_11.snackIDList = {}
			arg0_11.selectedSnackTFList = {}

			arg0_11.animtor:SetBool("AniSwitch", var0_0.Ani_Open_2_Close)
			arg0_11:setState(var0_0.States_Memory)
		end
	}
	arg0_11.snackResultView = NewYearSnackResultView.New(arg0_11._tf, arg0_11.event, arg0_11.packageData)

	arg0_11.snackResultView:Reset()
	arg0_11.snackResultView:Load()
end

return var0_0
