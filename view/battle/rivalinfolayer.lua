local var0_0 = class("RivalInfoLayer", import("..base.BaseUI"))

var0_0.TYPE_DISPLAY = 1
var0_0.TYPE_BATTLE = 2

function var0_0.getUIName(arg0_1)
	return "RivalInfoUI"
end

function var0_0.setRival(arg0_2, arg1_2)
	arg0_2.rivalVO = arg1_2
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():LoadingOn()
	onButton(arg0_3, findTF(arg0_3._tf, "bg"), function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end)

	arg0_3.shipCardTpl = arg0_3._tf:GetComponent("ItemList").prefabItem[0]
	arg0_3.startBtn = findTF(arg0_3._tf, "ships_container/start_btn")

	setActive(arg0_3.startBtn, false)
	setActive(findTF(arg0_3._tf, "info/title_miex"), arg0_3.contextData.type == arg0_3.TYPE_BATTLE)
	onButton(arg0_3, arg0_3.startBtn, function()
		arg0_3:emit(RivalInfoMediator.START_BATTLE)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	arg0_3:initRivalInfo()

	arg0_3.isRealName = false
	arg0_3.realNameToggle = arg0_3:findTF("info/real_name")

	onToggle(arg0_3, arg0_3.realNameToggle, function(arg0_6)
		arg0_3.isRealName = arg0_6

		arg0_3:UpdateNames()
	end, SFX_PANEL)
	setActive(arg0_3.realNameToggle, pg.PushNotificationMgr.GetInstance():isEnableShipName())
end

function var0_0.UpdateNames(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.names) do
		local var0_7 = iter1_7[1]
		local var1_7 = iter1_7[2]
		local var2_7 = arg0_7.isRealName and var1_7:GetDefaultName() or var1_7:getName()

		setText(findTF(var0_7, "content/info/name_mask/name"), var2_7)
	end
end

function var0_0.initRivalInfo(arg0_8)
	setText(findTF(arg0_8._tf, "info/name/container/name"), arg0_8.rivalVO.name)
	setText(findTF(arg0_8._tf, "info/name/container/lv"), "Lv." .. arg0_8.rivalVO.level)
	setActive(findTF(arg0_8._tf, "info/rank"), arg0_8.rivalVO.rank ~= nil)
	setActive(findTF(arg0_8._tf, "info/medal"), arg0_8.rivalVO.rank ~= nil)
	setActive(findTF(arg0_8._tf, "info/medal/Text"), arg0_8.rivalVO.rank ~= nil)

	if arg0_8.rivalVO.rank then
		setText(findTF(arg0_8._tf, "info/rank/container/value"), arg0_8.rivalVO.rank)

		local var0_8 = SeasonInfo.getMilitaryRank(arg0_8.rivalVO.score, arg0_8.rivalVO.rank)
		local var1_8 = findTF(arg0_8._tf, "info/medal"):GetComponent(typeof(Image))
		local var2_8 = findTF(arg0_8._tf, "info/medal/Text"):GetComponent(typeof(Image))
		local var3_8 = SeasonInfo.getEmblem(arg0_8.rivalVO.score, arg0_8.rivalVO.rank)

		LoadSpriteAsync("emblem/" .. var3_8, function(arg0_9)
			var1_8.sprite = arg0_9

			var2_8:SetNativeSize()
		end)
		LoadSpriteAsync("emblem/n_" .. var3_8, function(arg0_10)
			var2_8.sprite = arg0_10

			var2_8:SetNativeSize()
		end)
	end

	arg0_8.names = {}

	local function var4_8(arg0_11, arg1_11)
		flushShipCard(arg0_11, arg1_11)

		local var0_11 = getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() and arg1_11:GetDefaultName() or arg1_11:getName()

		setScrollText(findTF(arg0_11, "content/info/name_mask/name"), arg1_11:GetColorName(var0_11))
	end

	local function var5_8(arg0_12, arg1_12, arg2_12, arg3_12)
		local var0_12 = cloneTplTo(arg0_8.shipCardTpl, arg2_12)

		var0_12.localScale = Vector3(1.1, 1.1, 1)

		setActive(arg0_8:findTF("content", var0_12), arg3_12 ~= nil)
		setActive(arg0_8:findTF("empty", var0_12), arg3_12 == nil)

		if arg3_12 then
			var4_8(var0_12, arg3_12)
			table.insert(arg0_8.names, {
				var0_12,
				arg3_12
			})
		end
	end

	local var6_8 = arg0_8:findTF("ships_container/ships/main", arg0_8._tf)
	local var7_8 = #arg0_8.rivalVO.mainShips

	for iter0_8 = 1, 3 do
		var5_8(var7_8, iter0_8, var6_8, arg0_8.rivalVO.mainShips[iter0_8])
	end

	local var8_8 = arg0_8:findTF("ships_container/ships/vanguard", arg0_8._tf)
	local var9_8 = #arg0_8.rivalVO.vanguardShips

	for iter1_8 = 1, 3 do
		var5_8(var9_8, iter1_8, var8_8, arg0_8.rivalVO.vanguardShips[iter1_8])
	end

	local var10_8 = arg0_8:findTF("ships_container/main_comprehensive", arg0_8._tf)
	local var11_8 = arg0_8:findTF("ships_container/vanguard_comprehensive", arg0_8._tf)
	local var12_8 = arg0_8:findTF("ships_container/main_comprehensive/Text", arg0_8._tf)
	local var13_8 = arg0_8:findTF("ships_container/vanguard_comprehensive/Text", arg0_8._tf)
	local var14_8 = arg0_8.rivalVO:GetGearScoreSum(TeamType.Main)
	local var15_8 = arg0_8.rivalVO:GetGearScoreSum(TeamType.Vanguard)

	LeanTween.value(go(var12_8), 0, var14_8, 0.5):setOnUpdate(System.Action_float(function(arg0_13)
		setText(var12_8, math.floor(arg0_13))
	end))
	LeanTween.value(go(var13_8), 0, var15_8, 0.5):setOnUpdate(System.Action_float(function(arg0_14)
		setText(var13_8, math.floor(arg0_14))
	end)):setOnComplete(System.Action(function()
		setActive(arg0_8.startBtn, arg0_8.contextData.type == arg0_8.TYPE_BATTLE)
		pg.UIMgr.GetInstance():LoadingOff()
	end))
end

function var0_0.willExit(arg0_16)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf, pg.UIMgr.GetInstance().UIMain)
end

return var0_0
