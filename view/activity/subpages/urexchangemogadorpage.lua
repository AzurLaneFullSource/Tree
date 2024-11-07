local var0_0 = class("UrExchangeMogadorPage", import("...base.BaseActivityPage"))

var0_0.SP_FIRST = 1
var0_0.SP_DAILY = 2
var0_0.RANDOM_DAILY = 3
var0_0.CHALLANGE = 4
var0_0.MINI_GAME = 5
var0_0.SHOP_BUY = 6

local function var1_0(...)
	if false then
		warning(...)
	end
end

function var0_0.OnInit(arg0_2)
	arg0_2.shopProxy = getProxy(ShopsProxy)
	arg0_2.playerProxy = getProxy(PlayerProxy)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.shopProxy = getProxy(ShopsProxy)
	arg0_2._tasksTF = arg0_2:findTF("AD/tasks")
	arg0_2._taskTpl = arg0_2:findTF("AD/task_tpl")
	arg0_2._ptTip = arg0_2:findTF("pt_tip")
	arg0_2._tipText = arg0_2:findTF("bg/Text", arg0_2._ptTip)
	arg0_2._btnSimulate = arg0_2:findTF("AD/btn_simulate")
	arg0_2._btnExchange = arg0_2:findTF("AD/btn_exchange")
	arg0_2._btnHelp = arg0_2:findTF("AD/btn_help")
	arg0_2._ptText = arg0_2:findTF("AD/icon/pt")
	arg0_2.uilist = UIItemList.New(arg0_2._tasksTF, arg0_2._taskTpl)

	setActive(arg0_2._taskTpl, false)
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.config = arg0_3.activity:getConfig("config_client")
	arg0_3.taskConfig = arg0_3.config.taskConfig
	arg0_3.ptId = arg0_3.config.ptId
	arg0_3.uPtId = arg0_3.config.uPtId
	arg0_3.goodsId = arg0_3.config.goodsId
	arg0_3.shopId = arg0_3.config.shopId
	arg0_3.length = #arg0_3.goodsId + 1
	arg0_3.actShop = arg0_3.shopProxy:getActivityShopById(arg0_3.shopId)
end

function var0_0.OnFirstFlush(arg0_4)
	setText(arg0_4._tipText, i18n("UrExchange_Pt_NotEnough"))

	local var0_4 = getProxy(ActivityProxy):getActivityById(arg0_4.config.activitytime)

	arg0_4.isLinkActOpen = var0_4 and not var0_4:isEnd()

	setActive(arg0_4._tasksTF, arg0_4.isLinkActOpen)
	arg0_4.uilist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateTask(arg1_5, arg2_5)
		end
	end)
	onButton(arg0_4, arg0_4._btnSimulate, function()
		if arg0_4.config.expedition == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0_6 = i18n("blueprint_simulation_confirm")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0_6,
				onYes = function()
					arg0_4:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
						warnMsg = "tech_simulate_quit",
						stageId = arg0_4.config.expedition
					}, function()
						return
					end, SFX_PANEL)
				end
			})
		end
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4._btnExchange, function()
		if arg0_4.canExchange then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_exchange",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = Drop.Create({
					arg0_4.curGoods.commodity_type,
					arg0_4.curGoods.commodity_id,
					1
				}),
				onYes = function()
					arg0_4:emit(ActivityMediator.ON_ACT_SHOPPING, arg0_4.shopId, 1, arg0_4.curGoods.id, 1)
					pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrRedeem(arg0_4.curGoods.commodity_id, 2))
				end
			})
		else
			setActive(arg0_4._ptTip, true)

			arg0_4.leantween = LeanTween.delayedCall(1, System.Action(function()
				setActive(arg0_4._ptTip, false)
			end)).uniqueId
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("UrExchange_Pt_help")
		})
	end, SFX_PANEL)
end

function var0_0.CheckSingleTask(arg0_13)
	local var0_13 = getProxy(TaskProxy)
	local var1_13 = var0_13:getTaskById(arg0_13) or var0_13:getFinishTaskById(arg0_13)

	var1_0(arg0_13, var1_13 == nil)

	if var1_13 then
		return var1_13:getTaskStatus()
	else
		return -1
	end
end

var0_0.taskTypeDic = {
	[var0_0.SP_FIRST] = function(arg0_14, arg1_14)
		local var0_14 = var0_0.CheckSingleTask(arg1_14[1]) == 2 and 1 or 0
		local var1_14 = var0_14 .. "/1"

		local function var2_14()
			arg0_14:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = arg1_14[1]
			})
		end

		return var1_14, var0_14 ~= 1 and var2_14 or nil
	end,
	[var0_0.SP_DAILY] = function(arg0_16, arg1_16)
		local function var0_16()
			arg0_16:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL, {
				mapIdx = pg.chapter_template[arg1_16[1]].map
			})
		end

		local var1_16 = getProxy(ChapterProxy):getChapterById(arg1_16[1])
		local var2_16 = var1_16:isUnlock() and var1_16:isPlayerLVUnlock() and not var1_16:enoughTimes2Start()

		return var2_16 and "1/1" or "0/1", not var2_16 and var0_16 or nil
	end,
	[var0_0.RANDOM_DAILY] = function(arg0_18, arg1_18)
		local var0_18

		local function var1_18()
			arg0_18:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var0_18
			})
		end

		local var2_18 = 0
		local var3_18 = 0

		for iter0_18, iter1_18 in pairs(arg1_18) do
			local var4_18 = var0_0.CheckSingleTask(iter1_18)

			if var4_18 == 2 then
				var3_18 = var3_18 + 1
			elseif var4_18 == 1 or var4_18 == 0 then
				var2_18 = var2_18 + 1
				var0_18 = iter1_18
			end
		end

		local var5_18 = var2_18 + var3_18

		var1_0(var2_18, var3_18, var5_18)

		return var3_18 .. "/" .. var5_18, var2_18 ~= 0 and var1_18 or nil
	end,
	[var0_0.CHALLANGE] = function(arg0_20, arg1_20)
		local var0_20 = 0
		local var1_20

		for iter0_20, iter1_20 in pairs(arg1_20) do
			local var2_20 = var0_0.CheckSingleTask(iter1_20) == 2 and 1 or 0

			var0_20 = var0_20 + var2_20

			if var2_20 == 0 then
				var1_20 = var1_20 or iter1_20
			end
		end

		local var3_20 = var0_20 .. "/" .. #arg1_20

		local function var4_20()
			arg0_20:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var1_20
			})
		end

		return var3_20, var0_20 ~= #arg1_20 and var4_20 or nil
	end,
	[var0_0.MINI_GAME] = function(arg0_22, arg1_22)
		local var0_22 = arg1_22[1]
		local var1_22 = getProxy(MiniGameProxy):GetHubByGameId(var0_22).count == 0

		local function var2_22()
			arg0_22:emit(ActivityMediator.GO_MINI_GAME, var0_22)
		end

		return var1_22 and "1/1" or "0/1", not var1_22 and var2_22 or nil
	end,
	[var0_0.SHOP_BUY] = function(arg0_24, arg1_24)
		local function var0_24()
			arg0_24:emit(ActivityMediator.GO_SHOPS_LAYER, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = arg0_24.shopId
			})
		end

		local var1_24 = arg0_24:GetGoodsResCnt(arg1_24[1])
		local var2_24 = pg.activity_shop_template[arg1_24[1]].num_limit
		local var3_24 = var1_24 == 0

		return var2_24 - var1_24 .. "/" .. var2_24, not var3_24 and var0_24 or nil
	end
}

function var0_0.UpdateTask(arg0_26, arg1_26, arg2_26)
	if not arg0_26.isLinkActOpen then
		return
	end

	local var0_26 = arg1_26 + 1
	local var1_26 = arg0_26.taskConfig[var0_26][1]
	local var2_26 = arg0_26.taskConfig[var0_26][2]
	local var3_26 = arg0_26.taskConfig[var0_26][3]
	local var4_26, var5_26 = var0_0.taskTypeDic[var1_26](arg0_26, var3_26)

	setText(arg0_26:findTF("name", arg2_26), var2_26)
	setText(arg0_26:findTF("count", arg2_26), var4_26)
	setActive(arg0_26:findTF("complete", arg2_26), var5_26 == nil)
	setActive(arg0_26:findTF("btn_go", arg2_26), var5_26 ~= nil)

	if var5_26 then
		onButton(arg0_26, arg0_26:findTF("btn_go", arg2_26), function()
			var5_26()
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrJump(var1_26))
		end)
	end
end

function var0_0.OnUpdateFlush(arg0_28)
	var1_0("updateFlush")
	arg0_28:UpdateExchangeStatus()
	arg0_28.uilist:align(#arg0_28.taskConfig)
	arg0_28:UpdatePtCount()
	setActive(arg0_28:findTF("red", arg0_28._btnExchange), arg0_28.canExchange)
	setGray(arg0_28._btnExchange, arg0_28.exchangeState == 3, false)

	arg0_28._btnExchange:GetComponent("Image").raycastTarget = arg0_28.exchangeState ~= 3
end

function var0_0.GetGoodsResCnt(arg0_29, arg1_29)
	return arg0_29.actShop:GetCommodityById(arg1_29):GetPurchasableCnt()
end

function var0_0.UpdateExchangeStatus(arg0_30)
	arg0_30.player = arg0_30.playerProxy:getData()
	arg0_30.ptCount = arg0_30.player:getResource(arg0_30.uPtId)
	arg0_30.restExchange = _.reduce(arg0_30.goodsId, 0, function(arg0_31, arg1_31)
		return arg0_31 + arg0_30.actShop:GetCommodityById(arg1_31):GetPurchasableCnt()
	end)
	arg0_30.exchangeState = arg0_30.length - arg0_30.restExchange
	arg0_30.curGoods = arg0_30.exchangeState < arg0_30.length and pg.activity_shop_template[arg0_30.goodsId[arg0_30.exchangeState]] or nil
	arg0_30.canExchange = arg0_30.exchangeState < arg0_30.length and arg0_30.ptCount >= arg0_30.curGoods.resource_num

	var1_0(arg0_30.exchangeState, arg0_30.curGoods, arg0_30.canExchange)
end

function var0_0.UpdatePtCount(arg0_32)
	local var0_32 = ((arg0_32.exchangeState < arg0_32.length and arg0_32.ptCount < arg0_32.curGoods.resource_num and "<color=red>" or "<color=#3689DE>") .. arg0_32.ptCount .. "</color>/" .. (arg0_32.exchangeState == 3 and "--" or arg0_32.curGoods.resource_num)) .. i18n("UrExchange_Pt_charges", arg0_32.restExchange)

	setText(arg0_32._ptText, var0_32)
end

function var0_0.OnDestroy(arg0_33)
	eachChild(arg0_33._tasksTF, function(arg0_34)
		Destroy(arg0_34)
	end)
end

return var0_0
