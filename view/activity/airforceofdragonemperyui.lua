local var0 = class("AirForceOfDragonEmperyUI", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AirForceOfDragonEmperyUI"
end

local var1 = {
	"J-10",
	"J-15",
	"FC-1",
	"FC-31"
}
local var2 = {
	"fighterplane_J10_tip",
	"fighterplane_J15_tip",
	"fighterplane_FC1_tip",
	"fighterplane_FC31_tip"
}

function var0.init(arg0)
	arg0.itemList = {}

	for iter0 = 0, arg0._tf:Find("List").childCount - 1 do
		local var0 = arg0._tf:Find("List"):GetChild(iter0)

		setImageAlpha(var0:Find("Button"), 0.5)
		table.insert(arg0.itemList, var0)
	end

	arg0.currentNameImage = arg0._tf:Find("FighterName")
	arg0.currentFighterImage = arg0._tf:Find("FighterImage")
	arg0.currentFighterDesc = arg0._tf:Find("FighterProgress")

	setImageAlpha(arg0.currentNameImage, 0)
	setImageAlpha(arg0.currentFighterImage, 0)

	arg0.BattleTimes = arg0._tf:Find("BattleTimes")

	local var1 = arg0._tf:GetComponent(typeof(ItemList)).prefabItem
	local var2 = tf(Instantiate(var1[0]))

	setParent(var2, arg0._tf)

	arg0.loader = AutoLoader.New()
end

function var0.SetActivityData(arg0, arg1)
	arg0.activity = arg1
end

function var0.GetFighterData(arg0, arg1)
	local var0 = arg0.activity:getKVPList(1, arg1) or 0
	local var1 = arg0.activity:getKVPList(2, arg1) == 1

	return var0, var1
end

function var0.GetActivityProgress(arg0)
	local var0 = 0
	local var1 = arg0.activity:getConfig("config_client")[1]

	for iter0 = 1, var1 do
		var0 = var0 + arg0:GetFighterData(iter0)
	end

	local var2 = pg.TimeMgr.GetInstance()
	local var3 = var2:DiffDay(arg0.activity.data1, var2:GetServerTime()) + 1
	local var4 = math.min(var3 * 2, var1 * 3)

	return var0, var4
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Back"), function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, arg0._tf:Find("Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fighterplane_help.tip,
			weight = LayerWeightConst.SECOND_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Battle"), function()
		local var0 = arg0.contextData.index
		local var1 = arg0:GetFighterData(arg0.contextData.index)

		local function var2()
			local var0 = arg0.activity:getConfig("config_client")[1]
			local var1 = arg0.activity:getConfig("config_client")[2]
			local var2 = math.floor(#var1 / var0)
			local var3 = var2 * (arg0.contextData.index - 1) + 1
			local var4 = math.min(var3 + var2 - 1, #var1)
			local var5 = var1[math.random(var3, var4)]

			arg0:emit(AirForceOfDragonEmperyMediator.ON_BATTLE, var5)
		end

		if var1 >= 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fighterplane_complete_tip"),
				onYes = var2,
				weight = LayerWeightConst.SECOND_LAYER
			})
		else
			var2()
		end
	end, SFX_FIGHTER_BATTLE)

	for iter0, iter1 in ipairs(arg0.itemList) do
		onButton(arg0, iter1, function()
			arg0:SwitchIndex(iter0)
		end, SFX_FIGHTER_SWITCH)
	end

	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = arg0.contextData.index or PlayerPrefs.GetInt("AirFightIndex_" .. var0.id, 1)

	arg0.contextData.index = nil

	arg0:SwitchIndex(var1)
	arg0:UpdateView()
end

function var0.willExit(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetInt("AirFightIndex_" .. var0.id, arg0.contextData.index)
	PlayerPrefs.Save()
	LeanTween.cancel(go(arg0.currentNameImage))
	LeanTween.cancel(go(arg0.currentFighterImage))
	LeanTween.cancel(go(arg0.currentFighterDesc:Find("Desc/Text")))
	LeanTween.cancel(go(arg0.currentFighterDesc:Find("Progress")))
	arg0.loader:Clear()
end

function var0.UpdateView(arg0)
	for iter0, iter1 in ipairs(arg0.itemList) do
		local var0, var1 = arg0:GetFighterData(iter0)
		local var2 = arg0.itemList[iter0]

		UIItemList.StaticAlign(var2:Find("Progress"), var2:Find("Progress"):GetChild(0), var0)
	end

	arg0:UpdateFighter(arg0.contextData.index)

	local var3, var4 = arg0:GetActivityProgress()

	setText(arg0.BattleTimes, var4 - var3)
	arg0:CheckActivityUpdate()
end

function var0.SwitchIndex(arg0, arg1)
	if arg1 == nil or arg1 == arg0.contextData.index then
		return
	end

	if arg0.contextData.index then
		local var0 = arg0.itemList[arg0.contextData.index]

		setActive(var0:Find("Selected"), false)
		setImageAlpha(var0:Find("Button"), 0.5)
	end

	arg0.contextData.index = arg1

	local var1 = arg0.itemList[arg0.contextData.index]

	setActive(var1:Find("Selected"), true)
	setImageAlpha(var1:Find("Button"), 1)
	arg0:UpdateFighter(arg1)
	;(function()
		local var0
		local var1 = arg0.currentFighterImage:GetComponent(typeof(Image))
		local var2 = tf(arg0.currentFighterImage)

		LeanTween.cancel(go(arg0.currentFighterImage))

		local var3
		local var4 = arg0.currentNameImage:GetComponent(typeof(Image))
		local var5 = tf(arg0.currentNameImage)

		LeanTween.cancel(go(arg0.currentNameImage))
		parallelAsync({
			function(arg0)
				local var0 = var1.color.a

				if var0 < 0.05 then
					arg0()

					return
				end

				LeanTween.alpha(var2, 0, var0 * 0.2):setOnComplete(System.Action(arg0))
			end,
			function(arg0)
				local var0 = var4.color.a

				if var0 < 0.05 then
					arg0()

					return
				end

				LeanTween.alpha(var5, 0, var0 * 0.2):setOnComplete(System.Action(arg0))
			end,
			function(arg0)
				arg0.loader:GetSpriteDirect("ui/AirForceOfDragonEmperyUI_atlas", var1[arg1], function(arg0)
					var0 = arg0

					arg0()
				end, arg0.currentFighterImage)
			end,
			function(arg0)
				arg0.loader:GetSpriteDirect("ui/AirForceOfDragonEmperyUI_atlas", var1[arg1] .. "_BG", function(arg0)
					var3 = arg0

					arg0()
				end, arg0.currentNameImage)
			end
		}, function()
			var1.enabled = true
			var1.sprite = var0

			LeanTween.alpha(var2, 1, 0.2)

			var4.enabled = true
			var4.sprite = var3

			LeanTween.alpha(var5, 1, 0.2)
		end)
	end)()
	;(function()
		local var0 = arg0.currentFighterDesc:Find("Desc/Text")

		LeanTween.cancel(var0)
		var0:GetComponent("ScrollText"):SetText(i18n(var2[arg1]))
		LeanTween.textAlpha(var0, 1, 0.5):setFrom(0)
	end)()

	local var2, var3 = arg0:GetFighterData(arg1)
	local var4 = arg0.currentFighterDesc:Find("Progress")

	UIItemList.StaticAlign(var4, var4:GetChild(0), 3, function(arg0, arg1, arg2)
		if not arg0 == UIItemList.EventUpdate then
			return
		end

		setActive(arg2:GetChild(0), arg1 + 1 <= var2)

		arg2:GetChild(0).localScale = Vector3(0, 1, 1)
	end)
	LeanTween.cancel(go(var4))
	LeanTween.value(go(var4), 0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0)
		for iter0 = 0, 2 do
			local var0 = var4:GetChild(iter0)
			local var1 = math.clamp(3 * arg0 - iter0, 0, 1)

			var0:GetChild(0).localScale = Vector3(var1, 1, 1)
		end
	end))
	arg0.loader:GetSprite("ui/AirForceOfDragonEmperyUI_atlas", var1[arg1] .. "_Text", arg0.currentFighterDesc:Find("Name"), true)
end

function var0.UpdateFighter(arg0, arg1)
	local var0, var1 = arg0:GetFighterData(arg1)
	local var2 = arg0.itemList[arg1]

	UIItemList.StaticAlign(var2:Find("Progress"), var2:Find("Progress"):GetChild(0), var0)

	local var3 = arg0.currentFighterDesc
	local var4 = arg0.activity:getConfig("config_client")[3][arg1]
	local var5 = {
		type = var4[1],
		id = var4[2],
		count = var4[3]
	}

	updateDrop(var3:Find("Item"), var5)
	setActive(var3:Find("ItemMask"), var1)
	onButton(arg0, var3:Find("Item"), function()
		arg0:emit(BaseUI.ON_DROP, var5)
	end, SFX_PANEL)
end

function var0.CheckActivityUpdate(arg0)
	local var0 = arg0.activity:getConfig("config_client")[1]

	for iter0 = 1, var0 do
		local var1, var2 = arg0:GetFighterData(iter0)

		if var1 >= 3 and not var2 then
			arg0:emit(AirForceOfDragonEmperyMediator.ON_ACTIVITY_OPREATION, {
				cmd = 2,
				activity_id = arg0.activity.id,
				arg1 = iter0
			})

			return
		end
	end
end

return var0
