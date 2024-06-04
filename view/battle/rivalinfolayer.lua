local var0 = class("RivalInfoLayer", import("..base.BaseUI"))

var0.TYPE_DISPLAY = 1
var0.TYPE_BATTLE = 2

function var0.getUIName(arg0)
	return "RivalInfoUI"
end

function var0.setRival(arg0, arg1)
	arg0.rivalVO = arg1
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():LoadingOn()
	onButton(arg0, findTF(arg0._tf, "bg"), function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.shipCardTpl = arg0._tf:GetComponent("ItemList").prefabItem[0]
	arg0.startBtn = findTF(arg0._tf, "ships_container/start_btn")

	setActive(arg0.startBtn, false)
	setActive(findTF(arg0._tf, "info/title_miex"), arg0.contextData.type == arg0.TYPE_BATTLE)
	onButton(arg0, arg0.startBtn, function()
		arg0:emit(RivalInfoMediator.START_BATTLE)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	arg0:initRivalInfo()

	arg0.isRealName = false
	arg0.realNameToggle = arg0:findTF("info/real_name")

	onToggle(arg0, arg0.realNameToggle, function(arg0)
		arg0.isRealName = arg0

		arg0:UpdateNames()
	end, SFX_PANEL)
	setActive(arg0.realNameToggle, pg.PushNotificationMgr.GetInstance():isEnableShipName())
end

function var0.UpdateNames(arg0)
	for iter0, iter1 in pairs(arg0.names) do
		local var0 = iter1[1]
		local var1 = iter1[2]
		local var2 = arg0.isRealName and var1:GetDefaultName() or var1:getName()

		setText(findTF(var0, "content/info/name_mask/name"), var2)
	end
end

function var0.initRivalInfo(arg0)
	setText(findTF(arg0._tf, "info/name/container/name"), arg0.rivalVO.name)
	setText(findTF(arg0._tf, "info/name/container/lv"), "Lv." .. arg0.rivalVO.level)
	setActive(findTF(arg0._tf, "info/rank"), arg0.rivalVO.rank ~= nil)
	setActive(findTF(arg0._tf, "info/medal"), arg0.rivalVO.rank ~= nil)
	setActive(findTF(arg0._tf, "info/medal/Text"), arg0.rivalVO.rank ~= nil)

	if arg0.rivalVO.rank then
		setText(findTF(arg0._tf, "info/rank/container/value"), arg0.rivalVO.rank)

		local var0 = SeasonInfo.getMilitaryRank(arg0.rivalVO.score, arg0.rivalVO.rank)
		local var1 = findTF(arg0._tf, "info/medal"):GetComponent(typeof(Image))
		local var2 = findTF(arg0._tf, "info/medal/Text"):GetComponent(typeof(Image))
		local var3 = SeasonInfo.getEmblem(arg0.rivalVO.score, arg0.rivalVO.rank)

		LoadSpriteAsync("emblem/" .. var3, function(arg0)
			var1.sprite = arg0

			var2:SetNativeSize()
		end)
		LoadSpriteAsync("emblem/n_" .. var3, function(arg0)
			var2.sprite = arg0

			var2:SetNativeSize()
		end)
	end

	arg0.names = {}

	local function var4(arg0, arg1)
		flushShipCard(arg0, arg1)

		local var0 = getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() and arg1:GetDefaultName() or arg1:getName()

		setScrollText(findTF(arg0, "content/info/name_mask/name"), arg1:GetColorName(var0))
	end

	local function var5(arg0, arg1, arg2, arg3)
		local var0 = cloneTplTo(arg0.shipCardTpl, arg2)

		var0.localScale = Vector3(1.1, 1.1, 1)

		setActive(arg0:findTF("content", var0), arg3 ~= nil)
		setActive(arg0:findTF("empty", var0), arg3 == nil)

		if arg3 then
			var4(var0, arg3)
			table.insert(arg0.names, {
				var0,
				arg3
			})
		end
	end

	local var6 = arg0:findTF("ships_container/ships/main", arg0._tf)
	local var7 = #arg0.rivalVO.mainShips

	for iter0 = 1, 3 do
		var5(var7, iter0, var6, arg0.rivalVO.mainShips[iter0])
	end

	local var8 = arg0:findTF("ships_container/ships/vanguard", arg0._tf)
	local var9 = #arg0.rivalVO.vanguardShips

	for iter1 = 1, 3 do
		var5(var9, iter1, var8, arg0.rivalVO.vanguardShips[iter1])
	end

	local var10 = arg0:findTF("ships_container/main_comprehensive", arg0._tf)
	local var11 = arg0:findTF("ships_container/vanguard_comprehensive", arg0._tf)
	local var12 = arg0:findTF("ships_container/main_comprehensive/Text", arg0._tf)
	local var13 = arg0:findTF("ships_container/vanguard_comprehensive/Text", arg0._tf)
	local var14 = arg0.rivalVO:GetGearScoreSum(TeamType.Main)
	local var15 = arg0.rivalVO:GetGearScoreSum(TeamType.Vanguard)

	LeanTween.value(go(var12), 0, var14, 0.5):setOnUpdate(System.Action_float(function(arg0)
		setText(var12, math.floor(arg0))
	end))
	LeanTween.value(go(var13), 0, var15, 0.5):setOnUpdate(System.Action_float(function(arg0)
		setText(var13, math.floor(arg0))
	end)):setOnComplete(System.Action(function()
		setActive(arg0.startBtn, arg0.contextData.type == arg0.TYPE_BATTLE)
		pg.UIMgr.GetInstance():LoadingOff()
	end))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
end

return var0
