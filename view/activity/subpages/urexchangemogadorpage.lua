local var0 = class("UrExchangeMogadorPage", import("...base.BaseActivityPage"))

var0.SP_FIRST = 1
var0.SP_DAILY = 2
var0.RANDOM_DAILY = 3
var0.CHALLANGE = 4
var0.MINI_GAME = 5
var0.SHOP_BUY = 6

local function var1(...)
	if false then
		warning(...)
	end
end

function var0.OnInit(arg0)
	arg0.shopProxy = getProxy(ShopsProxy)
	arg0.playerProxy = getProxy(PlayerProxy)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.shopProxy = getProxy(ShopsProxy)
	arg0._tasksTF = arg0:findTF("AD/tasks")
	arg0._taskTpl = arg0:findTF("AD/task_tpl")
	arg0._ptTip = arg0:findTF("pt_tip")
	arg0._tipText = arg0:findTF("bg/Text", arg0._ptTip)
	arg0._btnSimulate = arg0:findTF("AD/btn_simulate")
	arg0._btnExchange = arg0:findTF("AD/btn_exchange")
	arg0._btnHelp = arg0:findTF("AD/btn_help")
	arg0._ptText = arg0:findTF("AD/icon/pt")
	arg0.uilist = UIItemList.New(arg0._tasksTF, arg0._taskTpl)

	setActive(arg0._taskTpl, false)
end

function var0.OnDataSetting(arg0)
	arg0.config = arg0.activity:getConfig("config_client")
	arg0.taskConfig = arg0.config.taskConfig
	arg0.ptId = arg0.config.ptId
	arg0.uPtId = arg0.config.uPtId
	arg0.goodsId = arg0.config.goodsId
	arg0.shopId = arg0.config.shopId
	arg0.length = #arg0.goodsId + 1
	arg0.actShop = arg0.shopProxy:getActivityShopById(arg0.shopId)
end

function var0.OnFirstFlush(arg0)
	setText(arg0._tipText, i18n("UrExchange_Pt_NotEnough"))

	local var0 = getProxy(ActivityProxy):getActivityById(arg0.config.activitytime)

	arg0.isLinkActOpen = var0 and not var0:isEnd()

	setActive(arg0._tasksTF, arg0.isLinkActOpen)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTask(arg1, arg2)
		end
	end)
	onButton(arg0, arg0._btnSimulate, function()
		if arg0.config.expedition == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0 = i18n("blueprint_simulation_confirm")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0,
				onYes = function()
					arg0:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
						warnMsg = "tech_simulate_quit",
						stageId = arg0.config.expedition
					}, function()
						return
					end, SFX_PANEL)
				end
			})
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0._btnExchange, function()
		if arg0.canExchange then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_exchange",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = Drop.Create({
					arg0.curGoods.commodity_type,
					arg0.curGoods.commodity_id,
					1
				}),
				onYes = function()
					arg0:emit(ActivityMediator.ON_ACT_SHOPPING, arg0.shopId, 1, arg0.curGoods.id, 1)
					TrackConst.TrackingUrExchangeFetch(arg0.curGoods.commodity_id, 2)
				end
			})
		else
			setActive(arg0._ptTip, true)

			arg0.leantween = LeanTween.delayedCall(1, System.Action(function()
				setActive(arg0._ptTip, false)
			end)).uniqueId
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("UrExchange_Pt_help")
		})
	end, SFX_PANEL)
end

function var0.CheckSingleTask(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = var0:getTaskById(arg0) or var0:getFinishTaskById(arg0)

	var1(arg0, var1 == nil)

	if var1 then
		return var1:getTaskStatus()
	else
		return -1
	end
end

var0.taskTypeDic = {
	[var0.SP_FIRST] = function(arg0, arg1)
		local var0 = var0.CheckSingleTask(arg1[1]) == 2 and 1 or 0
		local var1 = var0 .. "/1"

		local function var2()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = arg1[1]
			})
		end

		return var1, var0 ~= 1 and var2 or nil
	end,
	[var0.SP_DAILY] = function(arg0, arg1)
		local function var0()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL, {
				mapIdx = pg.chapter_template[arg1[1]].map
			})
		end

		local var1 = getProxy(ChapterProxy):getChapterById(arg1[1])
		local var2 = var1:isUnlock() and var1:isPlayerLVUnlock() and not var1:enoughTimes2Start()

		return var2 and "1/1" or "0/1", not var2 and var0 or nil
	end,
	[var0.RANDOM_DAILY] = function(arg0, arg1)
		local var0

		local function var1()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var0
			})
		end

		local var2 = 0
		local var3 = 0

		for iter0, iter1 in pairs(arg1) do
			local var4 = var0.CheckSingleTask(iter1)

			if var4 == 2 then
				var3 = var3 + 1
			elseif var4 == 1 or var4 == 0 then
				var2 = var2 + 1
				var0 = iter1
			end
		end

		local var5 = var2 + var3

		var1(var2, var3, var5)

		return var3 .. "/" .. var5, var2 ~= 0 and var1 or nil
	end,
	[var0.CHALLANGE] = function(arg0, arg1)
		local var0 = 0
		local var1

		for iter0, iter1 in pairs(arg1) do
			local var2 = var0.CheckSingleTask(iter1) == 2 and 1 or 0

			var0 = var0 + var2

			if var2 == 0 then
				var1 = var1 or iter1
			end
		end

		local var3 = var0 .. "/" .. #arg1

		local function var4()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var1
			})
		end

		return var3, var0 ~= #arg1 and var4 or nil
	end,
	[var0.MINI_GAME] = function(arg0, arg1)
		local var0 = arg1[1]
		local var1 = getProxy(MiniGameProxy):GetHubByGameId(var0).count == 0

		local function var2()
			arg0:emit(ActivityMediator.GO_MINI_GAME, var0)
		end

		return var1 and "1/1" or "0/1", not var1 and var2 or nil
	end,
	[var0.SHOP_BUY] = function(arg0, arg1)
		local function var0()
			arg0:emit(ActivityMediator.GO_SHOPS_LAYER, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = arg0.shopId
			})
		end

		local var1 = arg0:GetGoodsResCnt(arg1[1])
		local var2 = pg.activity_shop_template[arg1[1]].num_limit
		local var3 = var1 == 0

		return var2 - var1 .. "/" .. var2, not var3 and var0 or nil
	end
}

function var0.UpdateTask(arg0, arg1, arg2)
	if not arg0.isLinkActOpen then
		return
	end

	local var0 = arg1 + 1
	local var1 = arg0.taskConfig[var0][1]
	local var2 = arg0.taskConfig[var0][2]
	local var3 = arg0.taskConfig[var0][3]
	local var4, var5 = var0.taskTypeDic[var1](arg0, var3)

	setText(arg0:findTF("name", arg2), var2)
	setText(arg0:findTF("count", arg2), var4)
	setActive(arg0:findTF("complete", arg2), var5 == nil)
	setActive(arg0:findTF("btn_go", arg2), var5 ~= nil)

	if var5 then
		onButton(arg0, arg0:findTF("btn_go", arg2), function()
			var5()
			TrackConst.TrackingUrExchangeJump(var1)
		end)
	end
end

function var0.OnUpdateFlush(arg0)
	var1("updateFlush")
	arg0:UpdateExchangeStatus()
	arg0.uilist:align(#arg0.taskConfig)
	arg0:UpdatePtCount()
	setActive(arg0:findTF("red", arg0._btnExchange), arg0.canExchange)
	setGray(arg0._btnExchange, arg0.exchangeState == 3, false)

	arg0._btnExchange:GetComponent("Image").raycastTarget = arg0.exchangeState ~= 3
end

function var0.GetGoodsResCnt(arg0, arg1)
	return arg0.actShop:GetCommodityById(arg1):GetPurchasableCnt()
end

function var0.UpdateExchangeStatus(arg0)
	arg0.player = arg0.playerProxy:getData()
	arg0.ptCount = arg0.player:getResource(arg0.uPtId)
	arg0.restExchange = _.reduce(arg0.goodsId, 0, function(arg0, arg1)
		return arg0 + arg0.actShop:GetCommodityById(arg1):GetPurchasableCnt()
	end)
	arg0.exchangeState = arg0.length - arg0.restExchange
	arg0.curGoods = arg0.exchangeState < arg0.length and pg.activity_shop_template[arg0.goodsId[arg0.exchangeState]] or nil
	arg0.canExchange = arg0.exchangeState < arg0.length and arg0.ptCount >= arg0.curGoods.resource_num

	var1(arg0.exchangeState, arg0.curGoods, arg0.canExchange)
end

function var0.UpdatePtCount(arg0)
	local var0 = ((arg0.exchangeState < arg0.length and arg0.ptCount < arg0.curGoods.resource_num and "<color=red>" or "<color=#3689DE>") .. arg0.ptCount .. "</color>/" .. (arg0.exchangeState == 3 and "--" or arg0.curGoods.resource_num)) .. i18n("UrExchange_Pt_charges", arg0.restExchange)

	setText(arg0._ptText, var0)
end

function var0.OnDestroy(arg0)
	eachChild(arg0._tasksTF, function(arg0)
		Destroy(arg0)
	end)
end

return var0
