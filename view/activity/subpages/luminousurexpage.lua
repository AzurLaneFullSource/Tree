local var0_0 = class("LuminousUrExPage", import("...base.BaseActivityPage"))

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
	arg0_2._tasksTF = arg0_2._tf:Find("AD/tasks")
	arg0_2._taskTpl = arg0_2._tf:Find("AD/task_tpl")
	arg0_2._ptTip = arg0_2._tf:Find("pt_tip")
	arg0_2._tipText = arg0_2._ptTip:Find("bg/Text")
	arg0_2._btnSimulate = arg0_2._tf:Find("AD/btn_simulate")
	arg0_2._btnExchange = arg0_2._tf:Find("AD/btn_exchange")
	arg0_2._btnHelp = arg0_2._tf:Find("AD/btn_help")
	arg0_2._ptText = arg0_2._tf:Find("AD/icon/pt")
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
					local var0_10 = arg0_4.curGoods

					arg0_4:emit(ActivityMediator.ON_ACT_SHOPPING, arg0_4.shopId, 1, arg0_4.curGoods.id, 1, function()
						if arg0_4._tf and not IsNil(arg0_4._tf) then
							arg0_4:OnUpdateFlush()
						end
					end)
					pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrRedeem(var0_10.commodity_id, 2))
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

function var0_0.CheckSingleTask(arg0_14)
	local var0_14 = getProxy(TaskProxy)
	local var1_14 = var0_14:getTaskById(arg0_14) or var0_14:getFinishTaskById(arg0_14)

	if var1_14 then
		return var1_14:getTaskStatus()
	else
		return -1
	end
end

var0_0.taskTypeDic = {
	[var0_0.SP_FIRST] = function(arg0_15, arg1_15)
		local var0_15 = var0_0.CheckSingleTask(arg1_15[1]) == 2 and 1 or 0
		local var1_15 = var0_15 .. "/1"

		local function var2_15()
			arg0_15:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = arg1_15[1]
			})
		end

		return var1_15, var0_15 ~= 1 and var2_15 or nil
	end,
	[var0_0.SP_DAILY] = function(arg0_17, arg1_17)
		local function var0_17()
			arg0_17:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL, {
				mapIdx = pg.chapter_template[arg1_17[1]].map
			})
		end

		local var1_17 = getProxy(ChapterProxy):getChapterById(arg1_17[1])
		local var2_17 = var1_17:isUnlock() and var1_17:isPlayerLVUnlock() and not var1_17:enoughTimes2Start()

		return var2_17 and "1/1" or "0/1", not var2_17 and var0_17 or nil
	end,
	[var0_0.RANDOM_DAILY] = function(arg0_19, arg1_19)
		local var0_19

		local function var1_19()
			arg0_19:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var0_19
			})
		end

		local var2_19 = 0
		local var3_19 = 0

		for iter0_19, iter1_19 in pairs(arg1_19) do
			local var4_19 = var0_0.CheckSingleTask(iter1_19)

			if var4_19 == 2 then
				var3_19 = var3_19 + 1
			elseif var4_19 == 1 or var4_19 == 0 then
				var2_19 = var2_19 + 1
				var0_19 = iter1_19
			end
		end

		local var5_19 = var2_19 + var3_19

		return var3_19 .. "/" .. var5_19, var2_19 ~= 0 and var1_19 or nil
	end,
	[var0_0.CHALLANGE] = function(arg0_21, arg1_21)
		local var0_21 = 0
		local var1_21

		for iter0_21, iter1_21 in pairs(arg1_21) do
			local var2_21 = var0_0.CheckSingleTask(iter1_21) == 2 and 1 or 0

			var0_21 = var0_21 + var2_21

			if var2_21 == 0 then
				var1_21 = var1_21 or iter1_21
			end
		end

		local var3_21 = var0_21 .. "/" .. #arg1_21

		local function var4_21()
			arg0_21:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = TaskScene.PAGE_TYPE_ACT,
				targetId = var1_21
			})
		end

		return var3_21, var0_21 ~= #arg1_21 and var4_21 or nil
	end,
	[var0_0.MINI_GAME] = function(arg0_23, arg1_23)
		local var0_23 = arg1_23[1]
		local var1_23 = getProxy(MiniGameProxy):GetHubByGameId(var0_23).count == 0

		local function var2_23()
			arg0_23:emit(ActivityMediator.GO_MINI_GAME, var0_23)
		end

		return var1_23 and "1/1" or "0/1", not var1_23 and var2_23 or nil
	end,
	[var0_0.SHOP_BUY] = function(arg0_25, arg1_25)
		local function var0_25()
			arg0_25:emit(ActivityMediator.GO_SHOPS_LAYER, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = arg0_25.shopId
			})
		end

		local var1_25 = arg0_25:GetGoodsResCnt(arg1_25[1])
		local var2_25 = pg.activity_shop_template[arg1_25[1]].num_limit
		local var3_25 = var1_25 == 0

		return var2_25 - var1_25 .. "/" .. var2_25, not var3_25 and var0_25 or nil
	end
}

function var0_0.UpdateTask(arg0_27, arg1_27, arg2_27)
	if not arg0_27.isLinkActOpen then
		return
	end

	local var0_27 = arg1_27 + 1
	local var1_27 = arg0_27.taskConfig[var0_27][1]
	local var2_27 = arg0_27.taskConfig[var0_27][2]
	local var3_27 = arg0_27.taskConfig[var0_27][3]
	local var4_27, var5_27 = var0_0.taskTypeDic[var1_27](arg0_27, var3_27)

	setText(arg2_27:Find("name"), var2_27)
	setText(arg2_27:Find("count"), var4_27)
	setActive(arg2_27:Find("complete"), var5_27 == nil)
	setActive(arg2_27:Find("btn_go"), var5_27 ~= nil)

	if var5_27 then
		onButton(arg0_27, arg2_27:Find("btn_go"), function()
			var5_27()
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrJump(var1_27))
		end)
	end
end

function var0_0.OnUpdateFlush(arg0_29)
	arg0_29:UpdateExchangeStatus()
	arg0_29.uilist:align(#arg0_29.taskConfig)
	arg0_29:UpdatePtCount()
	setActive(arg0_29._btnExchange:Find("red"), arg0_29.canExchange)
	setGray(arg0_29._btnExchange, arg0_29.exchangeState == 3, false)

	arg0_29._btnExchange:GetComponent("Image").raycastTarget = arg0_29.exchangeState ~= 3
end

function var0_0.GetGoodsResCnt(arg0_30, arg1_30)
	return arg0_30.actShop:GetCommodityById(arg1_30):GetPurchasableCnt()
end

function var0_0.updateTaskLayers(arg0_31)
	arg0_31:OnUpdateFlush()
end

function var0_0.UpdateExchangeStatus(arg0_32)
	arg0_32.player = arg0_32.playerProxy:getData()
	arg0_32.ptCount = arg0_32.player:getResource(arg0_32.uPtId)
	arg0_32.restExchange = _.reduce(arg0_32.goodsId, 0, function(arg0_33, arg1_33)
		return arg0_33 + arg0_32.actShop:GetCommodityById(arg1_33):GetPurchasableCnt()
	end)
	arg0_32.exchangeState = arg0_32.length - arg0_32.restExchange
	arg0_32.curGoods = arg0_32.exchangeState < arg0_32.length and pg.activity_shop_template[arg0_32.goodsId[arg0_32.exchangeState]] or nil
	arg0_32.canExchange = arg0_32.exchangeState < arg0_32.length and arg0_32.ptCount >= arg0_32.curGoods.resource_num
end

function var0_0.UpdatePtCount(arg0_34)
	local var0_34 = ((arg0_34.exchangeState < arg0_34.length and arg0_34.ptCount < arg0_34.curGoods.resource_num and "<color=red>" or "<color=#3689DE>") .. arg0_34.ptCount .. "</color>/" .. (arg0_34.exchangeState == 3 and "--" or arg0_34.curGoods.resource_num)) .. i18n("UrExchange_Pt_charges", arg0_34.restExchange)

	setText(arg0_34._ptText, var0_34)
end

function var0_0.OnDestroy(arg0_35)
	eachChild(arg0_35._tasksTF, function(arg0_36)
		Destroy(arg0_36)
	end)
end

return var0_0
