local var0_0 = class("CoreURExchangeTemplatePage", import("view.activity.CorePage.CoreActivityPage"))

var0_0.SP_FIRST = 1
var0_0.SP_DAILY = 2
var0_0.RANDOM_DAILY = 3
var0_0.CHALLANGE = 4
var0_0.MINI_GAME = 5
var0_0.SHOP_BUY = 6
var0_0.GO_TASK = 7

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
	arg0_1.uilist = UIItemList.New(arg0_1._tasksTF, arg0_1._taskTpl)

	setActive(arg0_1._taskTpl, false)

	arg0_1._msgBox = arg0_1:findTF("msg_box")
	arg0_1._msgBoxBtnCancel = arg0_1:findTF("msg_box/btn_cancel")
	arg0_1._msgBoxBtnConfirm = arg0_1:findTF("msg_box/btn_confirm")
	arg0_1._msgBoxLabel = arg0_1:findTF("msg_box/label/text_cn")
	arg0_1._msgBoxItem = arg0_1:findTF("msg_box/item/IconTpl")
	arg0_1._msgBoxItemName = arg0_1:findTF("msg_box/item/name")
	arg0_1._msgBoxItemDesc = arg0_1:findTF("msg_box/item/desc")
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
	onButton(arg0_3, arg0_3._msgBoxBtnCancel, function()
		arg0_3:closeMsgBox()
	end)
	onButton(arg0_3, arg0_3._msgBox, function()
		arg0_3:closeMsgBox()
	end)
	onButton(arg0_3, arg0_3._msgBoxBtnConfirm, function()
		arg0_3:closeMsgBox()
		arg0_3:emit(ActivityMediator.ON_ACT_SHOPPING, arg0_3.shopId, 1, arg0_3.curGoods.id, 1)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrRedeem(arg0_3.curGoods.commodity_id, 2))
	end)
	onButton(arg0_3, arg0_3._btnExchange, function()
		if arg0_3.canExchange then
			local var0_11 = Drop.Create({
				arg0_3.curGoods.commodity_type,
				arg0_3.curGoods.commodity_id,
				1
			})

			updateDrop(arg0_3._msgBoxItem, var0_11)
			setText(arg0_3._msgBoxItemName, var0_11:getName())
			setText(arg0_3._msgBoxItemDesc, var0_11.desc)
			pg.UIMgr.GetInstance():BlurPanel(arg0_3._msgBox)
			setActive(arg0_3._msgBox, true)

			arg0_3.isMsgBoxShow = true
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
	end,
	[var0_0.GO_TASK] = function(arg0_27, arg1_27, arg2_27)
		local function var0_27()
			arg0_27:emit(ActivityMediator.EVENT_GO_SCENE, arg2_27)
		end

		local var1_27 = #arg1_27
		local var2_27 = getProxy(TaskProxy)

		while var1_27 > 0 do
			local var3_27 = arg1_27[var1_27]
			local var4_27 = var2_27:getTaskById(var3_27) or var2_27:getFinishTaskById(var3_27)

			if var4_27 then
				if var4_27:getTaskStatus() ~= 2 then
					var1_27 = var1_27 - 1
				end

				break
			end

			var1_27 = var1_27 - 1
		end

		return var1_27 .. "/" .. #arg1_27, var0_27
	end
}

function var0_0.UpdateTask(arg0_29, arg1_29, arg2_29)
	if not arg0_29.isLinkActOpen then
		return
	end

	local var0_29 = arg1_29 + 1
	local var1_29 = arg0_29.taskConfig[var0_29][1]
	local var2_29 = arg0_29.taskConfig[var0_29][2]
	local var3_29 = arg0_29.taskConfig[var0_29][3]
	local var4_29 = arg0_29.taskConfig[var0_29][4]
	local var5_29, var6_29 = var0_0.taskTypeDic[var1_29](arg0_29, var3_29, var4_29)

	setText(arg0_29:findTF("name", arg2_29), var2_29)
	setText(arg0_29:findTF("count", arg2_29), var5_29)
	setActive(arg0_29:findTF("complete", arg2_29), var6_29 == nil)
	setActive(arg0_29:findTF("btn_go", arg2_29), var6_29 ~= nil)

	if var6_29 then
		onButton(arg0_29, arg0_29:findTF("btn_go", arg2_29), function()
			var6_29()
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrJump(var1_29))
		end)
	end
end

function var0_0.OnUpdateFlush(arg0_31)
	arg0_31:UpdateExchangeStatus()
	arg0_31.uilist:align(#arg0_31.taskConfig)
	arg0_31:UpdatePtCount()
	setActive(arg0_31:findTF("red", arg0_31._btnExchange), arg0_31.canExchange)
	setGray(arg0_31._btnExchange, arg0_31.exchangeState == 3, false)

	arg0_31._btnExchange:GetComponent("Image").raycastTarget = arg0_31.exchangeState ~= 3
end

function var0_0.GetGoodsResCnt(arg0_32, arg1_32)
	return arg0_32.actShop:GetCommodityById(arg1_32):GetPurchasableCnt()
end

function var0_0.UpdateExchangeStatus(arg0_33)
	arg0_33.player = arg0_33.playerProxy:getData()
	arg0_33.ptCount = arg0_33.player:getResource(arg0_33.uPtId)
	arg0_33.restExchange = _.reduce(arg0_33.goodsId, 0, function(arg0_34, arg1_34)
		return arg0_34 + arg0_33.actShop:GetCommodityById(arg1_34):GetPurchasableCnt()
	end)
	arg0_33.exchangeState = arg0_33.length - arg0_33.restExchange
	arg0_33.curGoods = arg0_33.exchangeState < arg0_33.length and pg.activity_shop_template[arg0_33.goodsId[arg0_33.exchangeState]] or nil
	arg0_33.canExchange = arg0_33.exchangeState < arg0_33.length and arg0_33.ptCount >= arg0_33.curGoods.resource_num
end

function var0_0.UpdatePtCount(arg0_35)
	local var0_35 = ((arg0_35.exchangeState < arg0_35.length and arg0_35.ptCount < arg0_35.curGoods.resource_num and "<color=red>" or "<color=#3689DE>") .. arg0_35.ptCount .. "</color>/" .. (arg0_35.exchangeState == 3 and "--" or arg0_35.curGoods.resource_num)) .. i18n("UrExchange_Pt_charges", arg0_35.restExchange)

	setText(arg0_35._ptText, var0_35)
end

function var0_0.OnDestroy(arg0_36)
	eachChild(arg0_36._tasksTF, function(arg0_37)
		Destroy(arg0_37)
	end)
end

function var0_0.IsShowingPopWindow(arg0_38)
	return arg0_38.isMsgBoxShow
end

function var0_0.ClosePopWindow(arg0_39)
	arg0_39:closeMsgBox()
end

function var0_0.closeMsgBox(arg0_40)
	arg0_40.isMsgBoxShow = false

	pg.UIMgr.GetInstance():UnblurPanel(arg0_40._msgBox)
	setActive(arg0_40._msgBox, false)
end

return var0_0
