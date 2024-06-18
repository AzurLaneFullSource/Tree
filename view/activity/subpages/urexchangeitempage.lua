local var0_0 = class("UrExchangeItemPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.exchangeBtn = arg0_1:findTF("AD/exchange")
	arg0_1.exchangeTip = arg0_1:findTF("AD/exchange/tip")
	arg0_1.battleBtn = arg0_1:findTF("AD/battle")
	arg0_1.taskBtn = arg0_1:findTF("AD/task")
	arg0_1.progress = arg0_1:findTF("AD/progress/Image")
	arg0_1.progressTxt = arg0_1:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0_1.itemTF = arg0_1:findTF("AD/item")
	arg0_1.helpBtn = arg0_1:findTF("AD/help")
	arg0_1.moreBtn = arg0_1:findTF("AD/more")

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ur_exchange_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.moreBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ur_exchange_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.exchangeBtn, function()
		local var0_4 = getProxy(PlayerProxy):getRawData()
		local var1_4, var2_4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_4.level, "FragmentShop")

		if not var1_4 then
			pg.TipsMgr:GetInstance():ShowTips(var2_4)

			return
		end

		arg0_1:emit(ActivityMediator.GO_SHOPS_LAYER_STEEET, {
			warp = NewShopsScene.TYPE_FRAGMENT
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.taskBtn, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
end

function var0_0.OnFirstFlush(arg0_7)
	local var0_7 = pg.gameset.urpt_chapter_max.description
	local var1_7 = var0_7[1]
	local var2_7 = var0_7[2]
	local var3_7 = getProxy(BagProxy):GetLimitCntById(var1_7)

	arg0_7.progressTxt.text = var3_7 .. "/" .. var2_7

	setFillAmount(arg0_7.progress, var3_7 / var2_7)
	updateDrop(arg0_7.itemTF, Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = var1_7
	}))
	setActive(arg0_7.exchangeTip, NotifyTipHelper.ShouldShowUrTip())
end

function var0_0.OnUpdateFlush(arg0_8)
	return
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
