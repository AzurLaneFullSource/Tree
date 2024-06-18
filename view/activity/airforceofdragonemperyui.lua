local var0_0 = class("AirForceOfDragonEmperyUI", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AirForceOfDragonEmperyUI"
end

local var1_0 = {
	"J-10",
	"J-15",
	"FC-1",
	"FC-31"
}
local var2_0 = {
	"fighterplane_J10_tip",
	"fighterplane_J15_tip",
	"fighterplane_FC1_tip",
	"fighterplane_FC31_tip"
}

function var0_0.init(arg0_2)
	arg0_2.itemList = {}

	for iter0_2 = 0, arg0_2._tf:Find("List").childCount - 1 do
		local var0_2 = arg0_2._tf:Find("List"):GetChild(iter0_2)

		setImageAlpha(var0_2:Find("Button"), 0.5)
		table.insert(arg0_2.itemList, var0_2)
	end

	arg0_2.currentNameImage = arg0_2._tf:Find("FighterName")
	arg0_2.currentFighterImage = arg0_2._tf:Find("FighterImage")
	arg0_2.currentFighterDesc = arg0_2._tf:Find("FighterProgress")

	setImageAlpha(arg0_2.currentNameImage, 0)
	setImageAlpha(arg0_2.currentFighterImage, 0)

	arg0_2.BattleTimes = arg0_2._tf:Find("BattleTimes")

	local var1_2 = arg0_2._tf:GetComponent(typeof(ItemList)).prefabItem
	local var2_2 = tf(Instantiate(var1_2[0]))

	setParent(var2_2, arg0_2._tf)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.SetActivityData(arg0_3, arg1_3)
	arg0_3.activity = arg1_3
end

function var0_0.GetFighterData(arg0_4, arg1_4)
	local var0_4 = arg0_4.activity:getKVPList(1, arg1_4) or 0
	local var1_4 = arg0_4.activity:getKVPList(2, arg1_4) == 1

	return var0_4, var1_4
end

function var0_0.GetActivityProgress(arg0_5)
	local var0_5 = 0
	local var1_5 = arg0_5.activity:getConfig("config_client")[1]

	for iter0_5 = 1, var1_5 do
		var0_5 = var0_5 + arg0_5:GetFighterData(iter0_5)
	end

	local var2_5 = pg.TimeMgr.GetInstance()
	local var3_5 = var2_5:DiffDay(arg0_5.activity.data1, var2_5:GetServerTime()) + 1
	local var4_5 = math.min(var3_5 * 2, var1_5 * 3)

	return var0_5, var4_5
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("Back"), function()
		arg0_6:closeView()
	end, SOUND_BACK)
	onButton(arg0_6, arg0_6._tf:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fighterplane_help.tip,
			weight = LayerWeightConst.SECOND_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("Battle"), function()
		local var0_9 = arg0_6.contextData.index
		local var1_9 = arg0_6:GetFighterData(arg0_6.contextData.index)

		local function var2_9()
			local var0_10 = arg0_6.activity:getConfig("config_client")[1]
			local var1_10 = arg0_6.activity:getConfig("config_client")[2]
			local var2_10 = math.floor(#var1_10 / var0_10)
			local var3_10 = var2_10 * (arg0_6.contextData.index - 1) + 1
			local var4_10 = math.min(var3_10 + var2_10 - 1, #var1_10)
			local var5_10 = var1_10[math.random(var3_10, var4_10)]

			arg0_6:emit(AirForceOfDragonEmperyMediator.ON_BATTLE, var5_10)
		end

		if var1_9 >= 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fighterplane_complete_tip"),
				onYes = var2_9,
				weight = LayerWeightConst.SECOND_LAYER
			})
		else
			var2_9()
		end
	end, SFX_FIGHTER_BATTLE)

	for iter0_6, iter1_6 in ipairs(arg0_6.itemList) do
		onButton(arg0_6, iter1_6, function()
			arg0_6:SwitchIndex(iter0_6)
		end, SFX_FIGHTER_SWITCH)
	end

	local var0_6 = getProxy(PlayerProxy):getRawData()
	local var1_6 = arg0_6.contextData.index or PlayerPrefs.GetInt("AirFightIndex_" .. var0_6.id, 1)

	arg0_6.contextData.index = nil

	arg0_6:SwitchIndex(var1_6)
	arg0_6:UpdateView()
end

function var0_0.willExit(arg0_12)
	local var0_12 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetInt("AirFightIndex_" .. var0_12.id, arg0_12.contextData.index)
	PlayerPrefs.Save()
	LeanTween.cancel(go(arg0_12.currentNameImage))
	LeanTween.cancel(go(arg0_12.currentFighterImage))
	LeanTween.cancel(go(arg0_12.currentFighterDesc:Find("Desc/Text")))
	LeanTween.cancel(go(arg0_12.currentFighterDesc:Find("Progress")))
	arg0_12.loader:Clear()
end

function var0_0.UpdateView(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.itemList) do
		local var0_13, var1_13 = arg0_13:GetFighterData(iter0_13)
		local var2_13 = arg0_13.itemList[iter0_13]

		UIItemList.StaticAlign(var2_13:Find("Progress"), var2_13:Find("Progress"):GetChild(0), var0_13)
	end

	arg0_13:UpdateFighter(arg0_13.contextData.index)

	local var3_13, var4_13 = arg0_13:GetActivityProgress()

	setText(arg0_13.BattleTimes, var4_13 - var3_13)
	arg0_13:CheckActivityUpdate()
end

function var0_0.SwitchIndex(arg0_14, arg1_14)
	if arg1_14 == nil or arg1_14 == arg0_14.contextData.index then
		return
	end

	if arg0_14.contextData.index then
		local var0_14 = arg0_14.itemList[arg0_14.contextData.index]

		setActive(var0_14:Find("Selected"), false)
		setImageAlpha(var0_14:Find("Button"), 0.5)
	end

	arg0_14.contextData.index = arg1_14

	local var1_14 = arg0_14.itemList[arg0_14.contextData.index]

	setActive(var1_14:Find("Selected"), true)
	setImageAlpha(var1_14:Find("Button"), 1)
	arg0_14:UpdateFighter(arg1_14)
	;(function()
		local var0_15
		local var1_15 = arg0_14.currentFighterImage:GetComponent(typeof(Image))
		local var2_15 = tf(arg0_14.currentFighterImage)

		LeanTween.cancel(go(arg0_14.currentFighterImage))

		local var3_15
		local var4_15 = arg0_14.currentNameImage:GetComponent(typeof(Image))
		local var5_15 = tf(arg0_14.currentNameImage)

		LeanTween.cancel(go(arg0_14.currentNameImage))
		parallelAsync({
			function(arg0_16)
				local var0_16 = var1_15.color.a

				if var0_16 < 0.05 then
					arg0_16()

					return
				end

				LeanTween.alpha(var2_15, 0, var0_16 * 0.2):setOnComplete(System.Action(arg0_16))
			end,
			function(arg0_17)
				local var0_17 = var4_15.color.a

				if var0_17 < 0.05 then
					arg0_17()

					return
				end

				LeanTween.alpha(var5_15, 0, var0_17 * 0.2):setOnComplete(System.Action(arg0_17))
			end,
			function(arg0_18)
				arg0_14.loader:GetSpriteDirect("ui/AirForceOfDragonEmperyUI_atlas", var1_0[arg1_14], function(arg0_19)
					var0_15 = arg0_19

					arg0_18()
				end, arg0_14.currentFighterImage)
			end,
			function(arg0_20)
				arg0_14.loader:GetSpriteDirect("ui/AirForceOfDragonEmperyUI_atlas", var1_0[arg1_14] .. "_BG", function(arg0_21)
					var3_15 = arg0_21

					arg0_20()
				end, arg0_14.currentNameImage)
			end
		}, function()
			var1_15.enabled = true
			var1_15.sprite = var0_15

			LeanTween.alpha(var2_15, 1, 0.2)

			var4_15.enabled = true
			var4_15.sprite = var3_15

			LeanTween.alpha(var5_15, 1, 0.2)
		end)
	end)()
	;(function()
		local var0_23 = arg0_14.currentFighterDesc:Find("Desc/Text")

		LeanTween.cancel(var0_23)
		var0_23:GetComponent("ScrollText"):SetText(i18n(var2_0[arg1_14]))
		LeanTween.textAlpha(var0_23, 1, 0.5):setFrom(0)
	end)()

	local var2_14, var3_14 = arg0_14:GetFighterData(arg1_14)
	local var4_14 = arg0_14.currentFighterDesc:Find("Progress")

	UIItemList.StaticAlign(var4_14, var4_14:GetChild(0), 3, function(arg0_24, arg1_24, arg2_24)
		if not arg0_24 == UIItemList.EventUpdate then
			return
		end

		setActive(arg2_24:GetChild(0), arg1_24 + 1 <= var2_14)

		arg2_24:GetChild(0).localScale = Vector3(0, 1, 1)
	end)
	LeanTween.cancel(go(var4_14))
	LeanTween.value(go(var4_14), 0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0_25)
		for iter0_25 = 0, 2 do
			local var0_25 = var4_14:GetChild(iter0_25)
			local var1_25 = math.clamp(3 * arg0_25 - iter0_25, 0, 1)

			var0_25:GetChild(0).localScale = Vector3(var1_25, 1, 1)
		end
	end))
	arg0_14.loader:GetSprite("ui/AirForceOfDragonEmperyUI_atlas", var1_0[arg1_14] .. "_Text", arg0_14.currentFighterDesc:Find("Name"), true)
end

function var0_0.UpdateFighter(arg0_26, arg1_26)
	local var0_26, var1_26 = arg0_26:GetFighterData(arg1_26)
	local var2_26 = arg0_26.itemList[arg1_26]

	UIItemList.StaticAlign(var2_26:Find("Progress"), var2_26:Find("Progress"):GetChild(0), var0_26)

	local var3_26 = arg0_26.currentFighterDesc
	local var4_26 = arg0_26.activity:getConfig("config_client")[3][arg1_26]
	local var5_26 = {
		type = var4_26[1],
		id = var4_26[2],
		count = var4_26[3]
	}

	updateDrop(var3_26:Find("Item"), var5_26)
	setActive(var3_26:Find("ItemMask"), var1_26)
	onButton(arg0_26, var3_26:Find("Item"), function()
		arg0_26:emit(BaseUI.ON_DROP, var5_26)
	end, SFX_PANEL)
end

function var0_0.CheckActivityUpdate(arg0_28)
	local var0_28 = arg0_28.activity:getConfig("config_client")[1]

	for iter0_28 = 1, var0_28 do
		local var1_28, var2_28 = arg0_28:GetFighterData(iter0_28)

		if var1_28 >= 3 and not var2_28 then
			arg0_28:emit(AirForceOfDragonEmperyMediator.ON_ACTIVITY_OPREATION, {
				cmd = 2,
				activity_id = arg0_28.activity.id,
				arg1 = iter0_28
			})

			return
		end
	end
end

return var0_0
