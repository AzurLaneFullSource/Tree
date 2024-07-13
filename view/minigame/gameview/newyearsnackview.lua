local var0_0 = class("NewYearSnackView", import(".SnackView"))

function var0_0.getUIName(arg0_1)
	return "NewYearSnack"
end

function var0_0.OnSendMiniGameOPDone(arg0_2)
	arg0_2:updateCount()
end

function var0_0.addListener(arg0_3)
	var0_0.super.addListener(arg0_3)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2021__meishi.tip
		})
	end, SFX_PANEL)
end

function var0_0.updateSDModel(arg0_5)
	local var0_5 = getProxy(PlayerProxy):getData()
	local var1_5 = getProxy(BayProxy)
	local var2_5 = "Z28"

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var2_5, true, function(arg0_6)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_5.prefab = var2_5
		arg0_5.model = arg0_6
		tf(arg0_6).localScale = Vector3(1, 1, 1)

		arg0_6:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0_6, arg0_5.spineCharContainer)
	end)
end

function var0_0.updateSelectedList(arg0_7, arg1_7)
	arg1_7 = arg1_7 or {}

	for iter0_7 = 1, var0_0.Order_Num do
		local var0_7 = arg0_7.selectedContainer:GetChild(iter0_7 - 1)
		local var1_7 = arg0_7:findTF("Empty", var0_7)
		local var2_7 = arg0_7:findTF("Full", var0_7)
		local var3_7 = arg0_7:findTF("SnackImg", var2_7)

		arg0_7.selectedTFList[iter0_7] = var0_7

		local var4_7 = arg1_7[iter0_7]

		setActive(var2_7, var4_7)
		setActive(var1_7, not var4_7)

		if var4_7 then
			setImageSprite(var3_7, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var4_7))
		end
	end
end

function var0_0.updateSnackList(arg0_8, arg1_8)
	for iter0_8 = 1, var0_0.Snack_Num do
		local var0_8 = arg0_8.snackContainer:GetChild(iter0_8 - 1)
		local var1_8 = arg0_8:findTF("SnackImg", var0_8)
		local var2_8 = arg1_8[iter0_8]

		setImageSprite(var1_8, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var2_8))

		local var3_8 = arg0_8:findTF("SelectedTag", var0_8)

		setActive(var3_8, false)

		arg0_8.snackTFList[iter0_8] = var0_8
		iter0_8 = iter0_8 + 1
	end
end

function var0_0.updateSelectedOrderTag(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.selectedSnackTFList) do
		local var0_9 = arg0_9:findTF("SelectedTag", iter1_9)

		if arg1_9 then
			setActive(var0_9, false)
		else
			local var1_9 = table.indexof(arg0_9.selectedIDList, iter0_9, 1)

			setImageSprite(var0_9, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "order_" .. var1_9))
		end
	end
end

function var0_0.openResultView(arg0_10)
	arg0_10.packageData = {
		orderIDList = arg0_10.orderIDList,
		selectedIDList = arg0_10.selectedIDList,
		countTime = arg0_10.countTime,
		score = arg0_10.score,
		correctNumToEXValue = arg0_10:GetMGData():getConfig("simple_config_data").correct_value,
		scoreLevel = arg0_10:GetMGData():getConfig("simple_config_data").score_level,
		onSubmit = function(arg0_11)
			if arg0_10:GetMGHubData().count > 0 then
				arg0_10:SendSuccess(arg0_11)
			end

			arg0_10.score = 0
			arg0_10.countTime = nil
			arg0_10.leftTime = arg0_10.orginSelectTime
			arg0_10.orderIDList = {}
			arg0_10.selectedIDList = {}
			arg0_10.snackIDList = {}

			arg0_10:updateSelectedOrderTag(true)

			arg0_10.selectedSnackTFList = {}

			arg0_10.animtor:SetBool("AniSwitch", var0_0.Ani_Open_2_Close)
			arg0_10:setState(var0_0.States_Before)
		end,
		onContinue = function()
			arg0_10.score = arg0_10.packageData.score
			arg0_10.leftTime = arg0_10.packageData.countTime
			arg0_10.orderIDList = {}
			arg0_10.selectedIDList = {}
			arg0_10.snackIDList = {}
			arg0_10.selectedSnackTFList = {}

			arg0_10.animtor:SetBool("AniSwitch", var0_0.Ani_Open_2_Close)
			arg0_10:setState(var0_0.States_Memory)
		end
	}
	arg0_10.snackResultView = NewYearSnackResultView.New(arg0_10._tf, arg0_10.event, arg0_10.packageData)

	arg0_10.snackResultView:Reset()
	arg0_10.snackResultView:Load()
end

return var0_0
