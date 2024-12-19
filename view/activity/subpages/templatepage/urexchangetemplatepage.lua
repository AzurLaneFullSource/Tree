local var0_0 = class("UrExchangeTemplatePage", import("view.base.BaseActivityPage"))

var0_0.SP_FIRST = 1
var0_0.SP_DAILY = 2
var0_0.RANDOM_DAILY = 3
var0_0.CHALLANGE = 4
var0_0.MINI_GAME = 5
var0_0.SHOP_BUY = 6

function var0_0.OnInit(arg0_1)
	arg0_1.shopProxy = getProxy(ShopsProxy)
	arg0_1.playerProxy = getProxy(PlayerProxy)
	arg0_1.taskProxy = getProxy(TaskProxy)
	arg0_1.shopProxy = getProxy(ShopsProxy)
	arg0_1._tasksTF = arg0_1:findTF("AD/tasks")
	arg0_1._taskTpl = arg0_1:findTF("AD/task_tpl")
	arg0_1._ptTip = arg0_1:findTF("pt_tip")
	arg0_1._tipText = arg0_1:findTF("bg/Text", arg0_1._ptTip)
	arg0_1._btnSimulate = arg0_1:findTF("AD/btn_simulate")
	arg0_1._btnExchange = arg0_1:findTF("AD/btn_exchange")
	arg0_1._btnHelp = arg0_1:findTF("AD/btn_help")
	arg0_1._ptText = arg0_1:findTF("AD/icon/pt")
	arg0_1._resText = arg0_1:findTF("AD/icon/text")
	arg0_1.uilist = UIItemList.New(arg0_1._tasksTF, arg0_1._taskTpl)

	setActive(arg0_1._taskTpl, false)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = arg0_2.activity:getConfig("config_client")
	arg0_2.taskConfig = arg0_2.config.taskConfig
	arg0_2.ptId = arg0_2.config.ptId
	arg0_2.uPtId = arg0_2.config.uPtId
	arg0_2.goodsId = arg0_2.config.goodsId
	arg0_2.shopId = arg0_2.config.shopId
	arg0_2.length = #arg0_2.goodsId + 1
	arg0_2.actShop = arg0_2.shopProxy:getActivityShopById(arg0_2.shopId)
end

function var0_0.OnFirstFlush(arg0_3)
	setText(arg0_3._tipText, i18n("UrExchange_Pt_NotEnough"))

	local var0_3 = getProxy(ActivityProxy):getActivityById(arg0_3.config.activitytime)

	arg0_3.isLinkActOpen = var0_3 and not var0_3:isEnd()

	setActive(arg0_3._tasksTF, arg0_3.isLinkActOpen)
	arg0_3.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateTask(arg1_4, arg2_4)
		end
	end)
	onButton(arg0_3, arg0_3._btnSimulate, function()
		if arg0_3.config.expedition == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0_5 = i18n("blueprint_simulation_confirm")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0_5,
				onYes = function()
					arg0_3:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
						warnMsg = "tech_simulate_quit",
						stageId = arg0_3.config.expedition
					}, function()
						return
					end, SFX_PANEL)
				end
			})
		end
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3._btnExchange, function()
		if arg0_3.canExchange then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_exchange",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = Drop.Create({
					arg0_3.curGoods.commodity_type,
					arg0_3.curGoods.commodity_id,
					1
				}),
				onYes = function()
					arg0_3:emit(ActivityMediator.ON_ACT_SHOPPING, arg0_3.shopId, 1, arg0_3.curGoods.id, 1)
				end
			})
		else
			setActive(arg0_3._ptTip, true)

			arg0_3.leantween = LeanTween.delayedCall(1, System.Action(function()
				setActive(arg0_3._ptTip, false)
			end)).uniqueId
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("UrExchange_Pt_help")
		})
	end, SFX_PANEL)
end

function var0_0.CheckSingleTask(arg0_12)
	local var0_12 = getProxy(TaskProxy)
	local var1_12 = var0_12:getTaskById(arg0_12) or var0_12:getFinishTaskById(arg0_12)

	return var1_12 and var1_12:getTaskStatus() or -1
end

var0_0.taskTypeDic = {
	[var0_0.SP_FIRST] = function(arg0_13, arg1_13)
		local var0_13 = var0_0.CheckSingleTask(arg1_13[1]) == 2 and 1 or 0
		local var1_13 = var0_13 .. "/1"

		local function var2_13()
			arg0_13:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = arg1_13[1]
			})
		end

		return var1_13, var0_13 ~= 1 and var2_13 or nil
	end,
	[var0_0.SP_DAILY] = function(arg0_15, arg1_15)
		local var0_15 = getProxy(ChapterProxy):getChapterById(arg1_15[1])

		local function var1_15()
			if var0_15:isUnlock() then
				arg0_15:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL, {
					mapIdx = pg.chapter_template[arg1_15[1]].map
				})
			else
				arg0_15:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
			end
		end

		local var2_15 = var0_15:isUnlock() and var0_15:isPlayerLVUnlock() and not var0_15:enoughTimes2Start()

		return var2_15 and "1/1" or "0/1", not var2_15 and var1_15 or nil
	end,
	[var0_0.RANDOM_DAILY] = function(arg0_17, arg1_17)
		local var0_17

		local function var1_17()
			arg0_17:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var0_17
			})
		end

		local var2_17 = 0
		local var3_17 = 0

		for iter0_17, iter1_17 in pairs(arg1_17) do
			local var4_17 = var0_0.CheckSingleTask(iter1_17)

			if var4_17 == 2 then
				var3_17 = var3_17 + 1
			elseif var4_17 == 1 or var4_17 == 0 then
				var2_17 = var2_17 + 1
				var0_17 = iter1_17
			end
		end

		local var5_17 = var2_17 + var3_17

		return var3_17 .. "/" .. var5_17, var2_17 ~= 0 and var1_17 or nil
	end,
	[var0_0.CHALLANGE] = function(arg0_19, arg1_19)
		local var0_19 = 0
		local var1_19

		for iter0_19, iter1_19 in pairs(arg1_19) do
			local var2_19 = var0_0.CheckSingleTask(iter1_19) == 2 and 1 or 0

			var0_19 = var0_19 + var2_19

			if var2_19 == 0 then
				var1_19 = var1_19 or iter1_19
			end
		end

		local var3_19 = var0_19 .. "/" .. #arg1_19

		local function var4_19()
			arg0_19:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var1_19
			})
		end

		return var3_19, var0_19 ~= #arg1_19 and var4_19 or nil
	end,
	[var0_0.MINI_GAME] = function(arg0_21, arg1_21)
		local var0_21 = arg1_21[1]
		local var1_21 = getProxy(MiniGameProxy):GetHubByGameId(var0_21).count == 0

		local function var2_21()
			arg0_21:emit(ActivityMediator.GO_MINI_GAME, var0_21)
		end

		return var1_21 and "1/1" or "0/1", not var1_21 and var2_21 or nil
	end,
	[var0_0.SHOP_BUY] = function(arg0_23, arg1_23)
		local function var0_23()
			arg0_23:emit(ActivityMediator.GO_SHOPS_LAYER, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = arg0_23.shopId
			})
		end

		local var1_23 = arg0_23:GetGoodsResCnt(arg1_23[1])
		local var2_23 = pg.activity_shop_template[arg1_23[1]].num_limit
		local var3_23 = var1_23 == 0

		return var2_23 - var1_23 .. "/" .. var2_23, not var3_23 and var0_23 or nil
	end
}

function var0_0.UpdateTask(arg0_25, arg1_25, arg2_25)
	if not arg0_25.isLinkActOpen then
		return
	end

	local var0_25 = arg1_25 + 1
	local var1_25, var2_25, var3_25 = unpack(arg0_25.taskConfig[var0_25])
	local var4_25, var5_25 = var0_0.taskTypeDic[var1_25](arg0_25, var3_25)

	setText(arg0_25:findTF("name", arg2_25), var2_25)
	setText(arg0_25:findTF("count", arg2_25), var4_25)
	setActive(arg0_25:findTF("complete", arg2_25), var5_25 == nil)
	setActive(arg0_25:findTF("btn_go", arg2_25), var5_25 ~= nil)

	if var5_25 then
		onButton(arg0_25, arg0_25:findTF("btn_go", arg2_25), function()
			var5_25()
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrJump(var1_25))
		end)
	end
end

function var0_0.OnUpdateFlush(arg0_27)
	arg0_27:UpdateExchangeStatus()
	arg0_27.uilist:align(#arg0_27.taskConfig)
	arg0_27:UpdatePtCount()
	setActive(arg0_27:findTF("red", arg0_27._btnExchange), arg0_27.canExchange)
	setGray(arg0_27._btnExchange, arg0_27.exchangeState == arg0_27.length, false)

	arg0_27._btnExchange:GetComponent("Image").raycastTarget = arg0_27.exchangeState ~= arg0_27.length
end

function var0_0.GetGoodsResCnt(arg0_28, arg1_28)
	return arg0_28.actShop:GetCommodityById(arg1_28):GetPurchasableCnt()
end

function var0_0.UpdateExchangeStatus(arg0_29)
	arg0_29.player = arg0_29.playerProxy:getData()
	arg0_29.ptCount = arg0_29.player:getResource(arg0_29.uPtId)
	arg0_29.restExchange = _.reduce(arg0_29.goodsId, 0, function(arg0_30, arg1_30)
		return arg0_30 + arg0_29.actShop:GetCommodityById(arg1_30):GetPurchasableCnt()
	end)
	arg0_29.exchangeState = arg0_29.length - arg0_29.restExchange
	arg0_29.curGoods = arg0_29.exchangeState < arg0_29.length and pg.activity_shop_template[arg0_29.goodsId[arg0_29.exchangeState]] or nil
	arg0_29.canExchange = arg0_29.exchangeState < arg0_29.length and arg0_29.ptCount >= arg0_29.curGoods.resource_num
end

function var0_0.UpdatePtCount(arg0_31)
	setText(arg0_31._ptText, arg0_31.exchangeState < arg0_31.length and arg0_31.ptCount < arg0_31.curGoods.resource_num and setColorStr(arg0_31.ptCount, COLOR_RED) or arg0_31.ptCount)
	setText(arg0_31._resText, "/" .. (arg0_31.exchangeState == 3 and "--" or arg0_31.curGoods.resource_num) .. i18n("UrExchange_Pt_charges", arg0_31.restExchange))
end

function var0_0.OnDestroy(arg0_32)
	eachChild(arg0_32._tasksTF, function(arg0_33)
		Destroy(arg0_33)
	end)
end

return var0_0
