local var0 = class("IslandTowerClimbingGameView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "IslandTowerClimbingUI"
end

function var0.GetMGData(arg0)
	local var0 = arg0.contextData.miniGameId

	return getProxy(MiniGameProxy):GetMiniGameData(var0):clone()
end

function var0.GetMGHubData(arg0)
	local var0 = arg0.contextData.miniGameId

	return getProxy(MiniGameProxy):GetHubByGameId(var0)
end

function var0.didEnter(arg0)
	if not Physics2D.autoSimulation then
		Physics2D.autoSimulation = true
		arg0.isChangeAutoSimulation = true
	end

	arg0:Start()

	arg0.backBtn = findTF(arg0._tf, "overview/back")

	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0._tf, "overview/item"), function()
		local var0 = {
			mediator = IslandGameLimitMediator,
			viewComponent = IslandGameLimitLayer,
			data = {
				type = IslandGameLimitLayer.limit_type_jiujiu
			}
		}

		arg0:emit(BaseMiniGameMediator.OPEN_SUB_LAYER, var0)
	end, SFX_CANCEL)

	local var0 = ActivityConst.ISLAND_GAME_ID
	local var1 = pg.activity_template[var0].config_client.item_id

	arg0.itemConfig = Item.getConfigData(var1)

	LoadImageSpriteAsync(arg0.itemConfig.icon, findTF(arg0._tf, "overview/item/img"), true)

	arg0.hub_id = pg.activity_template[var0].config_id
	arg0.itemNums = getProxy(MiniGameProxy):GetHubByHubId(arg0.hub_id).count or 0

	setText(findTF(arg0._tf, "overview/item/num"), arg0.itemNums)
end

function var0.Start(arg0)
	arg0.controller = TowerClimbingController.New()

	arg0.controller.view:SetUI(arg0._go)

	local function var0(arg0, arg1, arg2, arg3)
		local var0 = arg0:GetMGData():GetRuntimeData("elements") or {}

		for iter0 = 1, arg3 do
			if iter0 > #var0 then
				table.insert(var0, 0)
			end
		end

		if arg0 >= var0[arg3] then
			var0[arg3] = arg0

			arg0:StoreDataToServer(var0)
			arg0:updateHighScore()
		end

		if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
			arg0.sendSuccessFlag = true

			arg0:SendSuccess(0)
		end
	end

	local function var1(arg0, arg1)
		return
	end

	arg0.controller:SetCallBack(var0, var1)

	local var2 = arg0:PackData()

	arg0.controller:SetUp(var2)
end

function var0.updateHighScore(arg0)
	local var0 = arg0:GetMGData():GetRuntimeData("elements") or {}

	if arg0.controller then
		-- block empty
	end

	arg0.controller:updateHighScore(var0)
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	arg0.itemNums = getProxy(MiniGameProxy):GetHubByHubId(arg0.hub_id).count or 0

	setText(findTF(arg0._tf, "overview/item/num"), arg0.itemNums)
	arg0:updateHighScore()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.GetTowerClimbingPageAndScore(arg0)
	local var0 = 0
	local var1 = 1
	local var2 = {
		0,
		0,
		0
	}

	return var0, var1, var2
end

function var0.GetAwardScores()
	local var0 = pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data

	return (_.map(var0, function(arg0)
		return arg0[1]
	end))
end

function var0.PackData(arg0)
	local var0 = arg0._tf.rect.width
	local var1 = arg0._tf.rect.height
	local var2 = arg0:GetMGData():GetRuntimeData("elements")
	local var3, var4, var5 = var0.GetTowerClimbingPageAndScore(var2)

	print(var3, "-", var4)

	local var6 = var0.GetAwardScores()

	return {
		shipId = 107031,
		npcName = "TowerClimbingManjuu",
		life = 3,
		screenWidth = var0,
		screenHeight = var1,
		higestscore = var3,
		pageIndex = var4,
		mapScores = var5,
		awards = var6
	}
end

function var0.onBackPressed(arg0)
	if arg0.controller and arg0.controller:onBackPressed() then
		return
	end

	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	if arg0.controller then
		arg0.controller:Dispose()
	end

	if arg0.isChangeAutoSimulation then
		Physics2D.autoSimulation = false
		arg0.isChangeAutoSimulation = nil
	end
end

return var0
