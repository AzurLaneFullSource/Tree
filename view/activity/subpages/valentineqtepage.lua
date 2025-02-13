local var0_0 = class("ValentineQtePage", import("view.base.BaseActivityPage"))

var0_0.MINIGAME_HUB_ID = 42
var0_0.MINIGAME_ID = 50

function var0_0.OnInit(arg0_1)
	arg0_1.awardPreviewBtn = arg0_1:findTF("AD/award_preview_btn")
	arg0_1.goBtn = arg0_1:findTF("AD/go")
	arg0_1.indexTxt = arg0_1:findTF("AD/index"):GetComponent(typeof(Text))
	arg0_1.iconBtn = arg0_1:findTF("AD/icon")
	arg0_1.markContainer = arg0_1:findTF("AD/marks")
	arg0_1.markTpl = arg0_1:findTF("AD/marks/1")

	setActive(arg0_1.markTpl, false)

	arg0_1.markTrs = {}

	for iter0_1 = 1, 7 do
		local var0_1 = cloneTplTo(arg0_1.markTpl, arg0_1.markContainer, iter0_1)

		table.insert(arg0_1.markTrs, var0_1)
	end
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_0.MINIGAME_ID)
	end, SFX_PANEL)

	local var0_3 = getProxy(MiniGameProxy)

	onButton(arg0_3, arg0_3.iconBtn, function()
		arg0_3:ShowAwards()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.indexTxt, function()
		arg0_3:ShowAwards()
	end, SFX_PANEL)

	local var1_3 = var0_3:GetHubByHubId(var0_0.MINIGAME_HUB_ID)

	arg0_3:FlushMarks(var1_3)
	Canvas.ForceUpdateCanvases()
	arg0_3:FlushIndex(var1_3)
end

function var0_0.ShowAwards(arg0_7)
	local var0_7 = getProxy(MiniGameProxy)
	local var1_7 = arg0_7:GetDropList()
	local var2_7 = var0_7:GetHubByHubId(var0_0.MINIGAME_HUB_ID).usedtime
	local var3_7 = {
		i18n("Valentine_minigame_label3"),
		i18n("Valentine_minigame_label2")
	}

	arg0_7:emit(ActivityMediator.ON_AWARD_WINDOW, var1_7, var2_7, var3_7)
end

function var0_0.GetDropList(arg0_8)
	return pg.mini_game[var0_0.MINIGAME_ID].simple_config_data.drop_ids
end

function var0_0.FlushMarks(arg0_9, arg1_9)
	local var0_9 = arg1_9.usedtime
	local var1_9 = var0_9 + arg1_9.count

	for iter0_9, iter1_9 in ipairs(arg0_9.markTrs) do
		setActive(iter1_9, iter0_9 <= var1_9)
		setActive(iter1_9:Find("finish"), iter0_9 <= var0_9)
		setActive(iter1_9:Find("finish/line"), var0_9 >= iter0_9 + 1)
	end
end

function var0_0.FlushIndex(arg0_10, arg1_10)
	local var0_10 = arg1_10.usedtime

	arg0_10.indexTxt.text = "<color=#753330>" .. var0_10 .. "</color><color=#605176>/7</color>"
end

function var0_0.OnUpdateFlush(arg0_11)
	return
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
