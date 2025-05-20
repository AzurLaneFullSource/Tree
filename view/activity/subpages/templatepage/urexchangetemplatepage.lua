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
	arg0_1:InitDic()
end

function var0_0.InitDic(arg0_2)
	arg0_2.taskTypeDic = {
		[var0_0.SP_FIRST] = function(arg0_3, arg1_3)
			local var0_3 = var0_0.CheckSingleTask(arg1_3[1]) == 2 and 1 or 0
			local var1_3 = var0_3 .. "/1"

			local function var2_3()
				arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = TaskScene.PAGE_TYPE_ACT,
					targetId = arg1_3[1]
				})
			end

			return var1_3, var0_3 ~= 1 and var2_3 or nil
		end,
		[var0_0.SP_DAILY] = function(arg0_5, arg1_5)
			local var0_5 = getProxy(ChapterProxy):getChapterById(arg1_5[1])

			local function var1_5()
				if var0_5:isUnlock() then
					arg0_5:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL, {
						mapIdx = pg.chapter_template[arg1_5[1]].map
					})
				else
					arg0_5:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
				end
			end

			local var2_5 = var0_5:isUnlock() and var0_5:isPlayerLVUnlock() and not var0_5:enoughTimes2Start()

			return var2_5 and "1/1" or "0/1", not var2_5 and var1_5 or nil
		end,
		[var0_0.RANDOM_DAILY] = function(arg0_7, arg1_7)
			local var0_7

			local function var1_7()
				arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = TaskScene.PAGE_TYPE_ACT,
					targetId = var0_7
				})
			end

			local var2_7 = 0
			local var3_7 = 0

			for iter0_7, iter1_7 in pairs(arg1_7) do
				local var4_7 = var0_0.CheckSingleTask(iter1_7)

				if var4_7 == 2 then
					var3_7 = var3_7 + 1
				elseif var4_7 == 1 or var4_7 == 0 then
					var2_7 = var2_7 + 1
					var0_7 = iter1_7
				end
			end

			local var5_7 = var2_7 + var3_7

			return var3_7 .. "/" .. var5_7, var2_7 ~= 0 and var1_7 or nil
		end,
		[var0_0.CHALLANGE] = function(arg0_9, arg1_9)
			local var0_9 = 0
			local var1_9

			for iter0_9, iter1_9 in pairs(arg1_9) do
				local var2_9 = var0_0.CheckSingleTask(iter1_9) == 2 and 1 or 0

				var0_9 = var0_9 + var2_9

				if var2_9 == 0 then
					var1_9 = var1_9 or iter1_9
				end
			end

			local var3_9 = var0_9 .. "/" .. #arg1_9

			local function var4_9()
				arg0_9:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = TaskScene.PAGE_TYPE_ACT,
					targetId = var1_9
				})
			end

			return var3_9, var0_9 ~= #arg1_9 and var4_9 or nil
		end,
		[var0_0.MINI_GAME] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11[1]
			local var1_11 = getProxy(MiniGameProxy):GetHubByGameId(var0_11).count == 0

			local function var2_11()
				arg0_11:emit(ActivityMediator.GO_MINI_GAME, var0_11)
			end

			return var1_11 and "1/1" or "0/1", not var1_11 and var2_11 or nil
		end,
		[var0_0.SHOP_BUY] = function(arg0_13, arg1_13)
			local function var0_13()
				arg0_13:emit(ActivityMediator.GO_SHOPS_LAYER, {
					warp = NewShopsScene.TYPE_ACTIVITY,
					actId = arg0_13.shopId
				})
			end

			local var1_13 = arg0_13:GetGoodsResCnt(arg1_13[1])
			local var2_13 = pg.activity_shop_template[arg1_13[1]].num_limit
			local var3_13 = var1_13 == 0

			return var2_13 - var1_13 .. "/" .. var2_13, not var3_13 and var0_13 or nil
		end
	}
end

function var0_0.OnDataSetting(arg0_15)
	arg0_15.config = arg0_15.activity:getConfig("config_client")
	arg0_15.taskConfig = arg0_15.config.taskConfig
	arg0_15.ptId = arg0_15.config.ptId
	arg0_15.uPtId = arg0_15.config.uPtId
	arg0_15.goodsId = arg0_15.config.goodsId
	arg0_15.shopId = arg0_15.config.shopId
	arg0_15.length = #arg0_15.goodsId + 1
	arg0_15.actShop = arg0_15.shopProxy:getActivityShopById(arg0_15.shopId)
end

function var0_0.OnFirstFlush(arg0_16)
	setText(arg0_16._tipText, i18n("UrExchange_Pt_NotEnough"))

	local var0_16 = getProxy(ActivityProxy):getActivityById(arg0_16.config.activitytime)

	arg0_16.isLinkActOpen = var0_16 and not var0_16:isEnd()

	setActive(arg0_16._tasksTF, arg0_16.isLinkActOpen)
	arg0_16.uilist:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			arg0_16:UpdateTask(arg1_17, arg2_17)
		end
	end)
	onButton(arg0_16, arg0_16._btnSimulate, function()
		if arg0_16.config.expedition == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			local var0_18 = i18n("blueprint_simulation_confirm")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0_18,
				onYes = function()
					arg0_16:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
						warnMsg = "tech_simulate_quit",
						stageId = arg0_16.config.expedition
					}, function()
						return
					end, SFX_PANEL)
				end
			})
		end
	end, SFX_CONFIRM)
	onButton(arg0_16, arg0_16._btnExchange, function()
		if arg0_16.canExchange then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_exchange",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = Drop.Create({
					arg0_16.curGoods.commodity_type,
					arg0_16.curGoods.commodity_id,
					1
				}),
				onYes = function()
					arg0_16:emit(ActivityMediator.ON_ACT_SHOPPING, arg0_16.shopId, 1, arg0_16.curGoods.id, 1)
				end
			})
		else
			setActive(arg0_16._ptTip, true)

			arg0_16.leantween = LeanTween.delayedCall(1, System.Action(function()
				setActive(arg0_16._ptTip, false)
			end)).uniqueId
		end
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16._btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("UrExchange_Pt_help")
		})
	end, SFX_PANEL)
end

function var0_0.CheckSingleTask(arg0_25)
	local var0_25 = getProxy(TaskProxy)
	local var1_25 = var0_25:getTaskById(arg0_25) or var0_25:getFinishTaskById(arg0_25)

	return var1_25 and var1_25:getTaskStatus() or -1
end

function var0_0.UpdateTask(arg0_26, arg1_26, arg2_26)
	if not arg0_26.isLinkActOpen then
		return
	end

	local var0_26 = arg1_26 + 1
	local var1_26, var2_26, var3_26 = unpack(arg0_26.taskConfig[var0_26])
	local var4_26, var5_26 = arg0_26.taskTypeDic[var1_26](arg0_26, var3_26)

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
	arg0_28:UpdateExchangeStatus()
	arg0_28.uilist:align(#arg0_28.taskConfig)
	arg0_28:UpdatePtCount()
	setActive(arg0_28:findTF("red", arg0_28._btnExchange), arg0_28.canExchange)
	setGray(arg0_28._btnExchange, arg0_28.exchangeState == arg0_28.length, false)

	arg0_28._btnExchange:GetComponent("Image").raycastTarget = arg0_28.exchangeState ~= arg0_28.length
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
end

function var0_0.UpdatePtCount(arg0_32)
	setText(arg0_32._ptText, arg0_32.exchangeState < arg0_32.length and arg0_32.ptCount < arg0_32.curGoods.resource_num and setColorStr(arg0_32.ptCount, COLOR_RED) or arg0_32.ptCount)
	setText(arg0_32._resText, "/" .. (arg0_32.exchangeState == 3 and "--" or arg0_32.curGoods.resource_num) .. i18n("UrExchange_Pt_charges", arg0_32.restExchange))
end

function var0_0.OnDestroy(arg0_33)
	eachChild(arg0_33._tasksTF, function(arg0_34)
		Destroy(arg0_34)
	end)
end

return var0_0
