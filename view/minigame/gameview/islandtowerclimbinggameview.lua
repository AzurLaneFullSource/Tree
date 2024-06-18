local var0_0 = class("IslandTowerClimbingGameView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "IslandTowerClimbingUI"
end

function var0_0.GetMGData(arg0_2)
	local var0_2 = arg0_2.contextData.miniGameId

	return getProxy(MiniGameProxy):GetMiniGameData(var0_2):clone()
end

function var0_0.GetMGHubData(arg0_3)
	local var0_3 = arg0_3.contextData.miniGameId

	return getProxy(MiniGameProxy):GetHubByGameId(var0_3)
end

function var0_0.didEnter(arg0_4)
	if not Physics2D.autoSimulation then
		Physics2D.autoSimulation = true
		arg0_4.isChangeAutoSimulation = true
	end

	arg0_4:Start()

	arg0_4.backBtn = findTF(arg0_4._tf, "overview/back")

	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_4, findTF(arg0_4._tf, "overview/item"), function()
		local var0_6 = {
			mediator = IslandGameLimitMediator,
			viewComponent = IslandGameLimitLayer,
			data = {
				type = IslandGameLimitLayer.limit_type_jiujiu
			}
		}

		arg0_4:emit(BaseMiniGameMediator.OPEN_SUB_LAYER, var0_6)
	end, SFX_CANCEL)

	local var0_4 = ActivityConst.ISLAND_GAME_ID
	local var1_4 = pg.activity_template[var0_4].config_client.item_id

	arg0_4.itemConfig = Item.getConfigData(var1_4)

	LoadImageSpriteAsync(arg0_4.itemConfig.icon, findTF(arg0_4._tf, "overview/item/img"), true)

	arg0_4.hub_id = pg.activity_template[var0_4].config_id
	arg0_4.itemNums = getProxy(MiniGameProxy):GetHubByHubId(arg0_4.hub_id).count or 0

	setText(findTF(arg0_4._tf, "overview/item/num"), arg0_4.itemNums)
end

function var0_0.Start(arg0_7)
	arg0_7.controller = TowerClimbingController.New()

	arg0_7.controller.view:SetUI(arg0_7._go)

	local function var0_7(arg0_8, arg1_8, arg2_8, arg3_8)
		local var0_8 = arg0_7:GetMGData():GetRuntimeData("elements") or {}

		for iter0_8 = 1, arg3_8 do
			if iter0_8 > #var0_8 then
				table.insert(var0_8, 0)
			end
		end

		if arg0_8 >= var0_8[arg3_8] then
			var0_8[arg3_8] = arg0_8

			arg0_7:StoreDataToServer(var0_8)
			arg0_7:updateHighScore()
		end

		if arg0_7:getGameTimes() and arg0_7:getGameTimes() > 0 then
			arg0_7.sendSuccessFlag = true

			arg0_7:SendSuccess(0)
		end
	end

	local function var1_7(arg0_9, arg1_9)
		return
	end

	arg0_7.controller:SetCallBack(var0_7, var1_7)

	local var2_7 = arg0_7:PackData()

	arg0_7.controller:SetUp(var2_7)
end

function var0_0.updateHighScore(arg0_10)
	local var0_10 = arg0_10:GetMGData():GetRuntimeData("elements") or {}

	if arg0_10.controller then
		-- block empty
	end

	arg0_10.controller:updateHighScore(var0_10)
end

function var0_0.OnSendMiniGameOPDone(arg0_11, arg1_11)
	arg0_11.itemNums = getProxy(MiniGameProxy):GetHubByHubId(arg0_11.hub_id).count or 0

	setText(findTF(arg0_11._tf, "overview/item/num"), arg0_11.itemNums)
	arg0_11:updateHighScore()
end

function var0_0.getGameTimes(arg0_12)
	return arg0_12:GetMGHubData().count
end

function var0_0.GetTowerClimbingPageAndScore(arg0_13)
	local var0_13 = 0
	local var1_13 = 1
	local var2_13 = {
		0,
		0,
		0
	}

	return var0_13, var1_13, var2_13
end

function var0_0.GetAwardScores()
	local var0_14 = pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data

	return (_.map(var0_14, function(arg0_15)
		return arg0_15[1]
	end))
end

function var0_0.PackData(arg0_16)
	local var0_16 = arg0_16._tf.rect.width
	local var1_16 = arg0_16._tf.rect.height
	local var2_16 = arg0_16:GetMGData():GetRuntimeData("elements")
	local var3_16, var4_16, var5_16 = var0_0.GetTowerClimbingPageAndScore(var2_16)

	print(var3_16, "-", var4_16)

	local var6_16 = var0_0.GetAwardScores()

	return {
		shipId = 107031,
		npcName = "TowerClimbingManjuu",
		life = 3,
		screenWidth = var0_16,
		screenHeight = var1_16,
		higestscore = var3_16,
		pageIndex = var4_16,
		mapScores = var5_16,
		awards = var6_16
	}
end

function var0_0.onBackPressed(arg0_17)
	if arg0_17.controller and arg0_17.controller:onBackPressed() then
		return
	end

	arg0_17:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_18)
	if arg0_18.controller then
		arg0_18.controller:Dispose()
	end

	if arg0_18.isChangeAutoSimulation then
		Physics2D.autoSimulation = false
		arg0_18.isChangeAutoSimulation = nil
	end
end

return var0_0
