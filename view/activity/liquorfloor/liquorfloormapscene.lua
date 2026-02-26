local var0_0 = class("LiquorFloorMapScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LiquorFloorUI"
end

var0_0.RANDOM_POS = {
	Vector2.New(121.6, 121.6),
	Vector2.New(-258.5, 22.8),
	Vector2.New(-166.1, 283),
	Vector2.New(-647.1, -14),
	Vector2.New(-440.7, -26.8),
	Vector2.New(-534.5, -285.1),
	Vector2.New(279.7, -299.1),
	Vector2.New(599.7, -299.1),
	Vector2.New(897.5, -15.2),
	Vector2.New(468.8, -15.2),
	Vector2.New(952.9, 166.2),
	Vector2.New(10.9, -91.6)
}
var0_0.TOP_POS = {
	Vector2.New(213, 152),
	Vector2.New(15, -137),
	Vector2.New(348, -50),
	Vector2.New(-32, -6),
	Vector2.New(-296, -267),
	Vector2.New(399, -113)
}
var0_0.architecturePos = {
	Vector2.New(-224.8, 183),
	Vector2.New(-435, -81.5),
	Vector2.New(452.5, 320.5),
	Vector2.New(201, 53),
	Vector2.New(26, -236.5),
	Vector2.New(641.5, -63)
}

function var0_0.SetActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
end

function var0_0.init(arg0_3)
	arg0_3.ui = arg0_3._tf:Find("ui")
	arg0_3.fightBtn = arg0_3.ui:Find("fightBtn")
	arg0_3.taskBtn = arg0_3.ui:Find("decorate/decorate1_1/decorate1_2/taskBtn")
	arg0_3.storyBtn = arg0_3.ui:Find("decorate/decorate1_1/storyBtn")
	arg0_3.architectureData = {
		arg0_3.ui:Find("architecture/muchang_bg"),
		arg0_3.ui:Find("architecture/nongchang_bg"),
		arg0_3.ui:Find("architecture/kuangchang_bg"),
		arg0_3.ui:Find("architecture/sheyingpeng_bg"),
		arg0_3.ui:Find("architecture/huochezhan_bg"),
		arg0_3.ui:Find("architecture/jiudian_bg")
	}
	arg0_3.architectureMapData = {
		arg0_3._tf:Find("bgs/muchang_xiao"),
		arg0_3._tf:Find("bgs/nongchang_xiao"),
		arg0_3._tf:Find("bgs/kuangchang_xiao"),
		arg0_3._tf:Find("bgs/sheyingpeng_xiao"),
		arg0_3._tf:Find("bgs/huochezhan_xiao"),
		arg0_3._tf:Find("bgs/jiudian_xiao")
	}
	arg0_3.lv = arg0_3.ui:Find("LV")
	arg0_3.top = arg0_3.ui:Find("top")
	arg0_3.backBtn = arg0_3.top:Find("back_button")
	arg0_3.homeBtn = arg0_3.top:Find("home_button")
	arg0_3.slotTFs = arg0_3._tf:Find("bgs/content")
	arg0_3.slotTpl = arg0_3._tf:Find("bgs/content/tpl")

	setActive(arg0_3.slotTpl, false)

	arg0_3.box = arg0_3.ui:Find("box")

	SetActive(arg0_3.box, false)

	arg0_3.Text_new = arg0_3.ui:Find("LV/Lv_bg/Text_new")

	SetActive(arg0_3.Text_new, false)

	arg0_3.taskTip = arg0_3.ui:Find("decorate/decorate1_1/decorate1_2/taskBtn/tip")

	setText(arg0_3.top:Find("title/Text1"), i18n("LiquorFloor_title"))
	setText(arg0_3.top:Find("title/Text2"), i18n("LiquorFloor_title_en"))
	setText(arg0_3.ui:Find("decorate/decorate1_1/storyBtn/Text"), i18n("LiquorFloor_story_title"))
	setText(arg0_3.ui:Find("decorate/decorate1_1/decorate1_2/taskBtn/Text"), i18n("LiquorFloorTaskUI_title"))
end

function var0_0.OnStoryList(arg0_4)
	arg0_4.gather1 = {}
	arg0_4.gather2 = {}
	arg0_4.gather3 = {}
	arg0_4.client = arg0_4.activity:getConfig("config_client").BookData

	for iter0_4, iter1_4 in ipairs(arg0_4.client[1].data1) do
		table.insert(arg0_4.gather1, iter1_4)
	end

	for iter2_4, iter3_4 in ipairs(arg0_4.client[2].data2) do
		table.insert(arg0_4.gather2, iter3_4)
	end

	for iter4_4, iter5_4 in ipairs(arg0_4.client[3].data3) do
		table.insert(arg0_4.gather3, iter5_4)
	end

	arg0_4.storyList = {}

	arg0_4:OnStory()
end

function var0_0.didEnter(arg0_5)
	arg0_5:OnStoryList()
	arg0_5:InitData()
	onButton(arg0_5, arg0_5.fightBtn, function()
		arg0_5:emit(LiquorFloorMapMediator.GO_FIGHT)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.taskBtn, function()
		arg0_5:emit(LiquorFloorMapMediator.OPEN_LAYER, Context.New({
			mediator = LiquorFloorTaskMediator,
			viewComponent = LiquorFloorTaskScene,
			data = {
				activityID = arg0_5.activity.id
			}
		}))
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.storyBtn, function()
		arg0_5:emit(LiquorFloorMapMediator.OPEN_CLUE_BOOK)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.homeBtn, function()
		arg0_5:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.box, function()
		SetActive(arg0_5.box, false)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.top:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.LiquorFloor_tip.tip
		})
	end, SFX_CANCEL)
	setText(arg0_5.ui:Find("Allgold/Text"), i18n("LiquorFloor_gold_get"))
	onButton(arg0_5, arg0_5.ui:Find("Allgold"), function()
		SetActive(arg0_5.box, false)

		if arg0_5.activity:HasMaxGold() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("LiquorFloor_gold_max_tip")
			})
		else
			arg0_5:emit(LiquorFloorMapMediator.ALL_WORKPLACE)
		end
	end, SFX_CANCEL)

	arg0_5.timeCfg = arg0_5.activity:getConfig("config_client").endingtime
	arg0_5.Placeitems = arg0_5.ui:Find("architecture")
	arg0_5.Placeitem = arg0_5.Placeitems:Find("muchang_bg")
	arg0_5.uilistPlace = UIItemList.New(arg0_5.Placeitems, arg0_5.Placeitem)

	arg0_5:OnPlaceDes()
	arg0_5:UpdateBubbles()

	arg0_5.timer = Timer.New(function()
		arg0_5:OnUpdateTime()
		arg0_5:OnPlaceDes()
	end, 1, -1)

	arg0_5.timer:Start()
	arg0_5:OnUpdateTime()

	arg0_5.timeCfg = arg0_5.activity:getConfig("config_client").endingtime
	arg0_5.spineRoles = {}

	arg0_5.activity:SetBubbleTipTag(true)
	arg0_5:RefreshRedPoint()

	if arg0_5.contextData.openStory == 1 then
		triggerButton(arg0_5.storyBtn)
	end
end

function var0_0.OnStory(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.gather1) do
		local var0_15 = arg0_15:getCollectDataBySiteId(iter1_15)

		if var0_15.unlock[2] <= arg0_15.activity:GetTownLevel() and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_15.luaID) then
			pg.NewStoryMgr.GetInstance():Play(var0_15.luaID, function()
				if iter0_15 == 1 then
					pg.NewGuideMgr.GetInstance():Play("LiquorFloor_help")
				end
			end)
		end
	end

	local var1_15 = arg0_15.activity:GetPlaceList()

	for iter2_15, iter3_15 in ipairs(arg0_15.gather2) do
		local var2_15 = arg0_15:getCollectDataBySiteId(iter3_15)

		if var2_15.unlock[2] <= var1_15[var2_15.unlock[1]]:GetLevel() and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_15.luaID) then
			pg.NewStoryMgr.GetInstance():Play(var2_15.luaID, function()
				return
			end)
		end
	end

	for iter4_15, iter5_15 in ipairs(arg0_15.gather3) do
		local var3_15 = arg0_15:getCollectDataBySiteId(iter5_15)

		if var3_15.unlock[2] <= var1_15[var3_15.unlock[1]]:GetLevel() and not pg.NewStoryMgr.GetInstance():IsPlayed(var3_15.luaID) then
			pg.NewStoryMgr.GetInstance():Play(var3_15.luaID, function()
				return
			end)
		end
	end
end

function var0_0.OnstoryPlay(arg0_19)
	if not arg0_19.storyList or #arg0_19.storyList == 0 then
		return
	end

	pg.NewStoryMgr.GetInstance():Play(arg0_19.storyList, function()
		return
	end, false)
end

function var0_0.OnUpdateTime(arg0_21)
	return
end

function var0_0.GetRandomPos(arg0_22)
	local var0_22 = {}

	for iter0_22 = 1, #var0_0.RANDOM_POS do
		table.insert(var0_22, iter0_22)
	end

	shuffle(var0_22)

	local var1_22 = {}

	for iter1_22 = 1, 8 do
		table.insert(var1_22, var0_0.RANDOM_POS[var0_22[iter1_22]])
	end

	return var1_22
end

function var0_0.UpdateBubbles(arg0_23)
	arg0_23.bubblesPosList = {}

	if arg0_23.slotTpl then
		setActive(arg0_23.slotTpl, false)
	end

	arg0_23.randomPos = Clone(var0_0.RANDOM_POS)

	for iter0_23, iter1_23 in ipairs(arg0_23.shipIds) do
		local var0_23 = arg0_23.slotTFs:Find(iter0_23) or cloneTplTo(arg0_23.slotTpl, arg0_23.slotTFs, iter0_23)
		local var1_23 = iter1_23 > 0 and getProxy(BayProxy):RawGetShipById(iter1_23) and arg0_23.activity:GetBubbleCntByPos(iter0_23) > 0

		setActive(var0_23, var1_23)

		if var1_23 then
			table.insert(arg0_23.bubblesPosList, iter0_23)
			arg0_23:UpdateShip(var0_23, iter0_23, iter1_23)
		end
	end
end

function var0_0.UpdateShip(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg3_24 > 0 and getProxy(BayProxy):RawGetShipById(arg3_24)

	if not var0_24 then
		return
	end

	local var1_24 = arg0_24.activity:GetBubbleCntByPos(arg2_24)
	local var2_24 = arg0_24.randomPos[#arg0_24.randomPos]

	setAnchoredPosition(arg1_24, var2_24)
	table.removebyvalue(arg0_24.randomPos, var2_24)

	local var3_24 = LoadSprite("qicon/" .. var0_24:getPainting())

	setImageSprite(arg1_24:Find("icon"), var3_24)
	onButton(arg0_24, arg1_24:Find("icon"), function()
		if not arg0_24.bubblesPosList or #arg0_24.bubblesPosList <= 0 then
			return
		end

		if arg0_24.activity:HasMaxGold() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("LiquorFloor_gold_max_tip"),
				onYes = function()
					arg0_24:emit(LiquorFloorMapMediator.CLICK_BUBBLE, arg0_24.bubblesPosList)
				end
			})
		else
			arg0_24:emit(LiquorFloorMapMediator.CLICK_BUBBLE, arg0_24.bubblesPosList)
		end
	end, SFX_PANEL)
end

function var0_0.Onstory(arg0_27)
	if not #arg0_27.storyList or #arg0_27.storyList == 0 then
		return
	end

	pg.NewStoryMgr.GetInstance():SeriesPlay(arg0_27.storyList)
end

function var0_0.CleanSpines(arg0_28)
	if arg0_28.spineRoles then
		table.Foreach(arg0_28.spineRoles, function(arg0_29, arg1_29)
			arg1_29:Dispose()
		end)
	end

	arg0_28.spineRoles = {}
end

function var0_0.InitData(arg0_30)
	local var0_30 = arg0_30.activity:GetPlaceList()

	arg0_30.shipIds = arg0_30.activity:GetShipIds()

	arg0_30:AchitectureMessage(var0_30)
	arg0_30:OnLV()
	arg0_30:UpdateGold()

	local var1_30 = arg0_30.activity:getConfig("config_client")

	SetActive(arg0_30.ui:Find("Allgold/tip"), LiquorFloorMapScene.GetLiquorFloorMapTip())
end

function var0_0.OnPlaceDes(arg0_31)
	local var0_31
	local var1_31 = arg0_31.activity:GetPlaceList()

	arg0_31.uilistPlace:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			arg0_31:UpdatePlace(arg1_32, arg2_32, var1_31)
		end
	end)
	arg0_31.uilistPlace:align(#var1_31)
end

function var0_0.UpdatePlace(arg0_33, arg1_33, arg2_33, arg3_33)
	i = arg1_33 + 1
	arg0_33._subTime = pg.TimeMgr.GetInstance():GetServerTime()

	if arg3_33[i]:GetType() == 1 then
		SetActive(arg0_33.architectureData[i]:Find("tip"), false)

		if arg3_33[i]:OnStartTime() < arg3_33[i]:GetTypeParam() * 7200 or arg3_33[i]:GetTypeParam() == 0 then
			setImageSprite(arg0_33.architectureData[i]:Find("numbg/icon1"), LoadSprite("ui/LiquorFloorUI_atlas", "settleGold_1"), true)
		elseif arg3_33[i]:OnStartTime() > arg3_33[i]:GetTypeParam() * 7200 and arg3_33[i]:OnStartTime() < arg3_33[i]:GetTypeParam() * 14400 then
			setImageSprite(arg0_33.architectureData[i]:Find("numbg/icon1"), LoadSprite("ui/LiquorFloorUI_atlas", "settleGold_2"), true)
		elseif arg3_33[i]:OnStartTime() > arg3_33[i]:GetTypeParam() * 14400 then
			SetActive(arg0_33.architectureData[i]:Find("tip"), true)
			setImageSprite(arg0_33.architectureData[i]:Find("numbg/icon1"), LoadSprite("ui/LiquorFloorUI_atlas", "settleGold_3"), true)
		end
	end

	if arg3_33[i]:OnStartTime() <= 0 then
		setText(arg2_33:Find("numbg/Text"), "0")
	else
		setText(arg2_33:Find("numbg/Text"), TownActivity2.GoldToShow(arg3_33[i]:OnStartTime()))
	end
end

function var0_0.AchitectureMessage(arg0_34, arg1_34)
	for iter0_34 = 1, #arg1_34 do
		setText(arg0_34.architectureData[iter0_34]:Find("lv"), arg1_34[iter0_34]:GetLevel())
		setText(arg0_34.architectureData[iter0_34]:Find("name"), arg1_34[iter0_34]:GetName())

		if arg1_34[iter0_34]:GetType() == 1 and arg1_34[iter0_34]:GetLevel() > 0 then
			SetActive(arg0_34.architectureData[iter0_34]:Find("numbg"), true)
			onButton(arg0_34, arg0_34.architectureData[iter0_34]:Find("numbg"), function()
				if arg1_34[iter0_34]:OnStartTime() <= 0 then
					return
				end

				if arg0_34.activity:HasMaxGold() then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("LiquorFloor_gold_max_tip")
					})
				else
					arg0_34:emit(LiquorFloorMapMediator.ADD_WORKPLACE, arg1_34[iter0_34]:GetId())
				end
			end, SFX_CANCEL)
		else
			SetActive(arg0_34.architectureData[iter0_34]:Find("numbg"), false)
		end

		onButton(arg0_34, arg0_34.architectureData[iter0_34], function()
			SetActive(arg0_34.box, true)
			setAnchoredPosition(arg0_34.box, var0_0.TOP_POS[iter0_34])
			arg0_34:OnBox(arg1_34[iter0_34], iter0_34, arg0_34.activity)
		end, SFX_CANCEL)
	end

	arg0_34:OnMap()
end

function var0_0.OnMap(arg0_37)
	local var0_37 = arg0_37.activity:GetPlaceList()

	for iter0_37 = 1, #var0_37 do
		local var1_37 = var0_37[iter0_37]:GetIcon()

		setImageSprite(arg0_37.architectureMapData[iter0_37], LoadSprite("ui/LiquorFloorUI_atlas", var1_37))
	end

	local var2_37 = arg0_37.activity:TownLevel()

	if var2_37 >= 0 and var2_37 <= 3 then
		setImageSprite(arg0_37._tf:Find("bgs"), LoadSprite("ui/LiquorFloorUI_atlas", "bg1"), true)
	elseif var2_37 > 3 and var2_37 <= 7 then
		setImageSprite(arg0_37._tf:Find("bgs"), LoadSprite("ui/LiquorFloorUI_atlas", "bg2"), true)
	elseif var2_37 > 7 and var2_37 <= 10 then
		setImageSprite(arg0_37._tf:Find("bgs"), LoadSprite("ui/LiquorFloorUI_atlas", "bg3"), true)
	end
end

function var0_0.UpdateGold(arg0_38)
	local var0_38 = TownActivity2.GoldToShow(arg0_38.activity:GetGold())

	arg0_38.top:Find("res/gold1/Text"):GetComponent(typeof(Text)).text = var0_38 .. "/" .. TownActivity2.GoldToShow(arg0_38.activity:GetLimitGold())

	setText(arg0_38.top:Find("res/gold2/Text"), " " .. TownActivity2.GoldToShow(arg0_38.activity:GetGold2()))
end

function var0_0.OnLV(arg0_39)
	local var0_39 = arg0_39.activity:TownLevel()

	if var0_39 >= #arg0_39.activity.listLVList2 + 1 then
		setFillAmount(arg0_39.lv:Find("Slider"), 1)
		SetActive(arg0_39.lv:Find("num_bg"), false)
	else
		setFillAmount(arg0_39.lv:Find("Slider"), var0_39 / arg0_39.activity.listLVList[var0_39])

		local var1_39

		if arg0_39.activity.listLVList2[var0_39 - 1] then
			var1_39 = arg0_39.activity:GetPtAllGold() - arg0_39.activity.listLVList2[var0_39 - 1]
		else
			var1_39 = arg0_39.activity:GetPtAllGold()
		end

		setText(arg0_39.lv:Find("num_bg/num"), TownActivity2.GoldToShow(var1_39) .. "/" .. TownActivity2.GoldToShow(arg0_39.activity.listLVList[var0_39]))
	end

	setText(arg0_39.lv:Find("Lv_bg/Text"), var0_39)
	setText(arg0_39.ui:Find("LV/lvbtn/Text"), i18n("LiquorFloor_level"))
end

function var0_0.OnUpgradeMoveLV(arg0_40)
	local var0_40 = arg0_40.activity:GetTownLevel()

	setText(arg0_40.Text_new, var0_40)
	SetActive(arg0_40.Text_new, true)
	LeanTween.move(arg0_40.Text_new, Vector3(0, 0, 0), 1):setOnComplete(System.Action(function()
		arg0_40:OnLV()
	end))
end

function var0_0.OnBox(arg0_42, arg1_42, arg2_42, arg3_42)
	if arg1_42:GetType() == 1 then
		SetActive(arg0_42.box:Find("role_bg"), false)
	elseif arg1_42:GetType() == 3 then
		SetActive(arg0_42.box:Find("role_bg"), true)
		arg0_42:OnRole_bg(arg1_42)
	else
		SetActive(arg0_42.box:Find("role_bg"), false)
	end

	setText(arg0_42.box:Find("box_bg/lv"), arg1_42:GetLevel())
	setText(arg0_42.box:Find("box_bg/name"), arg1_42:GetName())
	setText(arg0_42.box:Find("box_bg/describe"), arg1_42:GetDesc())

	if arg1_42:GetType() == 1 then
		setText(arg0_42.box:Find("box_bg/Text"), i18n("LiquorFloor_gold"))
	elseif arg1_42:GetType() == 2 then
		setText(arg0_42.box:Find("box_bg/Text"), i18n("LiquorFloor_gold_num"))
	elseif arg1_42:GetType() == 3 then
		setText(arg0_42.box:Find("box_bg/Text"), i18n("LiquorFloor_character_num"))
	end

	local var0_42 = arg3_42:GetGoldOutput()

	setText(arg0_42.box:Find("box_bg/num"), TownActivity2.GoldToShow(arg1_42:GetTypeParam(var0_42)))

	local var1_42 = arg0_42:OnNextArchitecture(arg1_42:GetId())

	if var1_42 == 0 then
		SetActive(arg0_42.box:Find("box_bg/num_1"), false)
		SetActive(arg0_42.box:Find("box_bg/decorate2"), false)
	else
		setText(arg0_42.box:Find("box_bg/num_1"), TownActivity2.GoldToShow(var1_42))
	end

	local var2_42 = arg1_42:GetNeedTownLv()

	if var2_42 <= arg3_42:TownLevel() and #arg1_42:GetUpgrade() ~= 0 then
		SetActive(arg0_42.box:Find("box_bg/num"), true)
		SetActive(arg0_42.box:Find("box_bg/decorate2"), true)
		SetActive(arg0_42.box:Find("box_bg/num_1"), true)
		SetActive(arg0_42.box:Find("box_bg/btn_lock"), false)
		SetActive(arg0_42.box:Find("box_bg/upgrade"), true)

		local var3_42 = arg1_42:GetUpgrade()

		setText(arg0_42.box:Find("box_bg/upgrade/name"), i18n("LiquorFloor_update"))

		local var4_42 = arg3_42:GetUpgradeGold(arg1_42:GetId())

		setText(arg0_42.box:Find("box_bg/upgrade/num1"), TownActivity2.GoldToShow(var4_42[1][3]))
		SetActive(arg0_42.box:Find("box_bg/num_man"), false)

		if #var4_42 == 1 then
			SetActive(arg0_42.box:Find("box_bg/upgrade/icon2"), false)
			SetActive(arg0_42.box:Find("box_bg/upgrade/num2"), false)
		else
			SetActive(arg0_42.box:Find("box_bg/upgrade/icon2"), true)
			SetActive(arg0_42.box:Find("box_bg/upgrade/num2"), true)
			setText(arg0_42.box:Find("box_bg/upgrade/num2"), TownActivity2.GoldToShow(var4_42[2][3]))
		end

		if arg3_42:UpgradeGold(arg1_42:GetId()) then
			arg0_42.box:Find("box_bg/upgrade"):GetComponent(typeof(Button)).interactable = true

			onButton(arg0_42, arg0_42.box:Find("box_bg/upgrade"), function()
				arg0_42:emit(LiquorFloorMapMediator.UPGRADE_WORKPLACE, arg1_42:GetId(), arg1_42, arg2_42)
			end, SFX_CANCEL)
		else
			arg0_42.box:Find("box_bg/upgrade"):GetComponent(typeof(Button)).interactable = false
		end
	elseif #arg1_42:GetUpgrade() == 0 and var2_42 == 0 then
		SetActive(arg0_42.box:Find("box_bg/num"), false)
		SetActive(arg0_42.box:Find("box_bg/decorate2"), false)
		SetActive(arg0_42.box:Find("box_bg/num_1"), false)
		SetActive(arg0_42.box:Find("box_bg/upgrade"), false)
		SetActive(arg0_42.box:Find("box_bg/btn_lock/icon"), false)
		SetActive(arg0_42.box:Find("box_bg/btn_lock"), true)
		SetActive(arg0_42.box:Find("box_bg/btn_lock/name"), true)
		SetActive(arg0_42.box:Find("box_bg/num_man"), true)

		local var5_42 = arg3_42:GetGoldOutput()

		setText(arg0_42.box:Find("box_bg/num_man"), TownActivity2.GoldToShow(arg1_42:GetTypeParam(var5_42)))
		setText(arg0_42.box:Find("box_bg/btn_lock/name"), i18n("LiquorFloor_update_max"))
	else
		SetActive(arg0_42.box:Find("box_bg/num_man"), false)
		SetActive(arg0_42.box:Find("box_bg/btn_lock"), true)
		SetActive(arg0_42.box:Find("box_bg/upgrade"), false)
		setText(arg0_42.box:Find("box_bg/btn_lock/name"), i18n("LiquorFloor_update_unlock", var2_42))
	end
end

function var0_0.OnRole_bg(arg0_44, arg1_44)
	arg0_44.items = arg0_44.box:Find("role_bg/list")
	arg0_44.item = arg0_44.items:Find("bg")
	arg0_44.uilist = UIItemList.New(arg0_44.items, arg0_44.item)

	setActive(arg0_44.item, false)
	arg0_44.uilist:make(function(arg0_45, arg1_45, arg2_45)
		if arg0_45 == UIItemList.EventUpdate then
			arg0_44:UpdateTask(arg1_45, arg2_45, arg1_44:GetTypeParam(), arg0_44:OnNextArchitecture(arg1_44:GetId()), arg1_44)
		end
	end)
	arg0_44.uilist:align(9)
	setText(arg0_44.box:Find("role_bg/rule1"), i18n("LiquorFloor_character_tip"))
end

function var0_0.UpdateTask(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46)
	local var0_46 = arg1_46 + 1

	if not arg5_46:GetUpgrade() or #arg5_46:GetUpgrade() == 0 then
		SetActive(arg2_46:Find("icon"), false)
		SetActive(arg2_46:Find("Text"), false)
		SetActive(arg2_46:Find("btn"), false)
	else
		SetActive(arg2_46:Find("icon"), false)
		SetActive(arg2_46:Find("Text"), var0_46 == arg4_46)
	end

	setButtonEnabled(arg2_46, var0_46 < arg4_46 or arg4_46 == -1)
	SetActive(arg2_46:Find("btn"), var0_46 < arg4_46 or arg4_46 == -1)

	if var0_46 < arg4_46 and arg4_46 == -1 then
		SetActive(arg2_46:Find("Text"), false)
	elseif var0_46 == arg4_46 then
		SetActive(arg2_46:Find("Text"), true)
		setText(arg2_46:Find("Text"), i18n("LiquorFloor_character_unlock", arg4_46))
	else
		SetActive(arg2_46:Find("Text"), false)
	end

	local var1_46 = LoadSprite("ui/LiquorFloorUI_atlas", "box_decorate1")

	setImageSprite(arg2_46:Find("btn"), var1_46, true)

	local var2_46 = arg0_46.shipIds[var0_46]
	local var3_46

	if arg0_46.shipIds[var0_46] then
		local var4_46 = getProxy(BayProxy):RawGetShipById(var2_46)

		if var4_46 then
			local var5_46 = LoadSprite("qicon/" .. var4_46:getPainting())

			setImageSprite(arg2_46:Find("btn"), var5_46, true)
		end
	end

	onButton(arg0_46, arg2_46, function()
		arg0_46:emit(LiquorFloorMapMediator.OPEN_CHUANWU, var0_46, var3_46, arg5_46:GetId())
	end, SFX_CANCEL)
end

function var0_0.OnNextArchitecture(arg0_48, arg1_48)
	if pg.activity_town_work_level_2[arg1_48 + 1] then
		return pg.activity_town_work_level_2[arg1_48 + 1].type_param
	end

	return -1
end

function var0_0.willExit(arg0_49)
	if arg0_49.timer then
		arg0_49.timer:Stop()

		arg0_49.timer = nil
	end
end

function var0_0.RefreshRedPoint(arg0_50)
	setActive(arg0_50.taskTip, var0_0.ShouldShowTaskTip())
	SetActive(arg0_50.storyBtn:Find("tip"), var0_0.GetCollectionBookTip())
end

function var0_0.ShouldShowTaskTip()
	local var0_51 = ActivityConst.ACTIVITY_TYPE_TOWN2
	local var1_51 = getProxy(TaskProxy)
	local var2_51 = getProxy(ActivityProxy):getActivityByType(var0_51):getConfig("config_client").taskActivityID
	local var3_51 = pg.activity_template[var2_51].config_data

	for iter0_51, iter1_51 in ipairs(var3_51) do
		local var4_51 = var1_51:getTaskVO(iter1_51)

		if var4_51 and var4_51:getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

function var0_0.getCollectDataBySiteId(arg0_52, arg1_52)
	for iter0_52, iter1_52 in ipairs(pg.activity_town_collection_2.all) do
		if pg.activity_town_collection_2[iter1_52].id == arg1_52 then
			return pg.activity_town_collection_2[iter1_52]
		end
	end

	return nil
end

function var0_0.GetCollectionBookTip()
	local var0_53 = ActivityConst.ACTIVITY_TYPE_TOWN2
	local var1_53 = getProxy(TaskProxy)
	local var2_53 = getProxy(ActivityProxy):getActivityByType(var0_53):getConfig("config_client").BookData

	for iter0_53 = 1, #var2_53 do
		local var3_53 = getProxy(TaskProxy):getTaskVO(var2_53[iter0_53].task)

		if var3_53 and var3_53:getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

function var0_0.GetLiquorFloorMapTip()
	local var0_54 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2):GetPlaceList()

	for iter0_54 = 1, #var0_54 do
		if var0_54[iter0_54]:GetType() == 1 and var0_54[iter0_54]:GetLevel() > 0 then
			local var1_54 = pg.activity_town_2[ActivityConst.LiquorFloor_ACT_ID].gold_time_limit

			if var0_54[iter0_54]:OnStartTime() >= var0_54[iter0_54]:GetTypeParam() * var1_54 then
				return true
			end
		end
	end

	return false
end

return var0_0
