local var0_0 = class("TownScene", import("view.base.BaseUI"))

var0_0.RANDOM_POS = {
	Vector2.New(111.3, 150),
	Vector2.New(-235.9, 113.2),
	Vector2.New(570, 424.5),
	Vector2.New(-790.3, 569.9),
	Vector2.New(-440.7, -26.8),
	Vector2.New(-1206.2, 2),
	Vector2.New(-705.8, -379),
	Vector2.New(-1021.7, -153.9),
	Vector2.New(-385.6, -479.7),
	Vector2.New(367.1, -749),
	Vector2.New(107.6, -684.9),
	Vector2.New(338.7, 150)
}
var0_0.STATIC_POS = Vector2.New(-440.7, -26.8)
var0_0.SDScale = 0.5

function var0_0.getUIName(arg0_1)
	return "TownUI"
end

function var0_0.SetActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
	arg0_2.shipIds = arg0_2.activity:GetShipIds()
end

function var0_0.init(arg0_3)
	arg0_3.mapTF = arg0_3:findTF("map")
	arg0_3.bgTFs = arg0_3:findTF("map/bg")
	arg0_3.slotTFs = arg0_3:findTF("map/content")
	arg0_3.slotTpl = arg0_3:findTF("map/content/tpl")

	setActive(arg0_3.slotTpl, false)

	local var0_3 = arg0_3:findTF("ui")

	arg0_3.topUI = arg0_3:findTF("top", var0_3)
	arg0_3.goldText = arg0_3:findTF("gold/Text", arg0_3.topUI):GetComponent(typeof(Text))
	arg0_3.infoPage = TownInfoPage.New(var0_3, arg0_3)

	arg0_3.infoPage:ExecuteAction("Flush")
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("back", arg0_4.topUI), function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4:findTF("help", arg0_4.topUI), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.town_help.tip
		})
	end, SFX_PANEL)
	onScroll(arg0_4, arg0_4.mapTF, function(arg0_7)
		return
	end)

	arg0_4.timeCfg = arg0_4.activity:getConfig("config_client").endingtime
	arg0_4.spineRoles = {}

	arg0_4:UpdateShips()

	arg0_4.timer = Timer.New(function()
		arg0_4:OnUpdateTime()
	end, 1, -1)

	arg0_4.timer:Start()
	arg0_4:OnUpdateTime()
	seriesAsync({
		function(arg0_9)
			local var0_9 = pg.activity_town_level[arg0_4.activity:GetTownLevel()].unlock_story

			if var0_9 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_9) then
				pg.NewStoryMgr.GetInstance():Play(var0_9, arg0_9)
			else
				arg0_9()
			end
		end,
		function(arg0_10)
			local var0_10 = arg0_4.activity:getConfig("config_client").story[1][1]

			if (function()
				return underscore.all(arg0_4.activity:getConfig("config_client").beforestory, function(arg0_12)
					return pg.NewStoryMgr.GetInstance():IsPlayed(arg0_12[1])
				end)
			end)() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_10) then
				pg.NewStoryMgr.GetInstance():Play(var0_10, arg0_10)
			else
				arg0_10()
			end
		end,
		function(arg0_13)
			if not pg.NewStoryMgr.GetInstance():IsPlayed("NG0046") then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0046")
			end
		end
	}, function()
		return
	end)
	arg0_4.activity:SetBubbleTipTag(true)
end

function var0_0.GetRandomPos(arg0_15)
	local var0_15 = {}

	for iter0_15 = 1, #var0_0.RANDOM_POS do
		table.insert(var0_15, iter0_15)
	end

	shuffle(var0_15)

	local var1_15 = {}

	for iter1_15 = 1, 8 do
		table.insert(var1_15, var0_0.RANDOM_POS[var0_15[iter1_15]])
	end

	return var1_15
end

function var0_0.OnUpdateTime(arg0_16)
	arg0_16:UpdateBg()
	arg0_16:UpdateGold()
	arg0_16:UpdateBubbles()
	arg0_16.infoPage:ExecuteAction("OnUpdateTime")
end

function var0_0.GetBgName(arg0_17, arg1_17)
	local var0_17 = pg.TimeMgr.GetInstance():GetServerHour()

	for iter0_17, iter1_17 in ipairs(arg0_17.timeCfg) do
		local var1_17 = iter1_17[1]

		if var0_17 >= var1_17[1] and var0_17 < var1_17[2] then
			return iter1_17[2]
		end
	end

	return "day"
end

function var0_0.UpdateBg(arg0_18)
	local var0_18 = arg0_18:GetBgName()

	eachChild(arg0_18.bgTFs, function(arg0_19)
		setActive(arg0_19, arg0_19.name == var0_18)
	end)
end

function var0_0.UpdateGold(arg0_20)
	arg0_20.gold = arg0_20.activity:GetTotalGold()
	arg0_20.goldText.text = TownActivity.GoldToShow(arg0_20.gold)
end

function var0_0.UpdateBubbles(arg0_21)
	arg0_21.bubblesPosList = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.shipIds) do
		if iter1_21 > 0 and getProxy(BayProxy):RawGetShipById(iter1_21) then
			local var0_21 = arg0_21.activity:GetBubbleCntByPos(iter0_21)
			local var1_21 = arg0_21:findTF(iter0_21 .. "/bubble", arg0_21.slotTFs)

			setActive(var1_21, var0_21 > 0)

			if var0_21 > 0 then
				table.insert(arg0_21.bubblesPosList, iter0_21)
				eachChild(var1_21, function(arg0_22)
					setActive(arg0_22, tonumber(arg0_22.name) == var0_21)
				end)
			end
		end
	end
end

function var0_0.UpdateShips(arg0_23)
	arg0_23:CleanSpines()

	arg0_23.randomPos = Clone(var0_0.RANDOM_POS)

	for iter0_23, iter1_23 in ipairs(arg0_23.shipIds) do
		arg0_23:UpdateShip(iter0_23, iter1_23)
	end

	arg0_23:UpdateBubbles()
end

function var0_0.UpdateShip(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24:findTF(arg1_24, arg0_24.slotTFs)

	if var0_24 then
		setActive(var0_24, false)
	end

	local var1_24 = arg2_24 > 0 and getProxy(BayProxy):RawGetShipById(arg2_24)

	if not var1_24 then
		return
	end

	var0_24 = var0_24 or cloneTplTo(arg0_24.slotTpl, arg0_24.slotTFs, arg1_24)

	if arg0_24.activity:GetBubbleCntByPos(arg1_24) > 0 and table.contains(arg0_24.randomPos, var0_0.STATIC_POS) then
		setAnchoredPosition(var0_24, var0_0.STATIC_POS)
		table.removebyvalue(arg0_24.randomPos, var0_0.STATIC_POS)
	else
		local var2_24 = arg0_24.randomPos[#arg0_24.randomPos]

		setAnchoredPosition(var0_24, var2_24)
		table.removebyvalue(arg0_24.randomPos, var2_24)
	end

	onButton(arg0_24, arg0_24:findTF("bubble", var0_24), function()
		if not arg0_24.bubblesPosList or #arg0_24.bubblesPosList <= 0 then
			return
		end

		if arg0_24.activity:HasMaxGold() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("town_gold_tip"),
				onYes = function()
					arg0_24:emit(TownMediator.CLICK_BUBBLE, arg0_24.bubblesPosList)
				end
			})
		else
			arg0_24:emit(TownMediator.CLICK_BUBBLE, arg0_24.bubblesPosList)
		end
	end, SFX_PANEL)

	local var3_24 = SpineRole.New()

	var3_24:SetData(var1_24:getPrefab())
	var3_24:Load(function()
		local var0_27 = var3_24.modelRoot

		var0_27.name = "model"
		var0_27.transform.localScale = Vector2.New(var0_0.SDScale, var0_0.SDScale)
		rtf(var0_27).sizeDelta = Vector2.New(200, 500)

		SetParent(var0_27, var0_24)
		var3_24:SetAction("stand")
		var0_27.transform:SetAsFirstSibling()
		setActive(var0_24, true)
	end, true)

	arg0_24.spineRoles[arg1_24] = var3_24
end

function var0_0.CleanSpines(arg0_28)
	table.Foreach(arg0_28.spineRoles, function(arg0_29, arg1_29)
		arg1_29:Dispose()
	end)

	arg0_28.spineRoles = {}
end

function var0_0.UpdateInfoPage(arg0_30)
	arg0_30.infoPage:ExecuteAction("SetActivity", arg0_30.activity)
	arg0_30.infoPage:ExecuteAction("Flush")
end

function var0_0.OnExpUpdate(arg0_31)
	arg0_31.infoPage:ExecuteAction("SetActivity", arg0_31.activity)
	arg0_31.infoPage:ExecuteAction("OnExpUpdate")
end

function var0_0.OnTownUpgrade(arg0_32, arg1_32)
	arg0_32.infoPage:ExecuteAction("OnTownUpgrade", arg1_32)
end

function var0_0.OnPlaceUpgrade(arg0_33, arg1_33)
	arg0_33.infoPage:ExecuteAction("OnPlaceUpgrade", arg1_33)
end

function var0_0.willExit(arg0_34)
	arg0_34.infoPage:Destroy()

	arg0_34.infoPage = nil

	if arg0_34.timer then
		arg0_34.timer:Stop()

		arg0_34.timer = nil
	end

	arg0_34:CleanSpines()
end

function var0_0.ShowEntranceTip(arg0_35)
	local var0_35 = arg0_35 or getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN)

	if not var0_35 or var0_35:isEnd() then
		return false
	end

	return var0_0.ShowMainTip(var0_35) or var0_35:ShowBubbleTip()
end

function var0_0.ShowMainTip(arg0_36)
	local var0_36 = arg0_36 or getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN)

	if not var0_36 or var0_36:isEnd() then
		return false
	end

	return var0_36:CanCostGold() or var0_36:HasEmptySlot()
end

return var0_0
