local var0 = class("ValentineQtePage", import("view.base.BaseActivityPage"))

var0.MINIGAME_HUB_ID = 42
var0.MINIGAME_ID = 50

function var0.OnInit(arg0)
	arg0.awardPreviewBtn = arg0:findTF("AD/award_preview_btn")
	arg0.goBtn = arg0:findTF("AD/go")
	arg0.indexTxt = arg0:findTF("AD/index"):GetComponent(typeof(Text))
	arg0.iconBtn = arg0:findTF("AD/icon")
	arg0.markContainer = arg0:findTF("AD/marks")
	arg0.markTpl = arg0:findTF("AD/marks/1")

	setActive(arg0.markTpl, false)

	arg0.markTrs = {}

	for iter0 = 1, 7 do
		local var0 = cloneTplTo(arg0.markTpl, arg0.markContainer, iter0)

		table.insert(arg0.markTrs, var0)
	end
end

function var0.OnDataSetting(arg0)
	return
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0.MINIGAME_ID)
	end, SFX_PANEL)

	local var0 = getProxy(MiniGameProxy)

	onButton(arg0, arg0.iconBtn, function()
		arg0:ShowAwards()
	end, SFX_PANEL)
	onButton(arg0, arg0.indexTxt, function()
		arg0:ShowAwards()
	end, SFX_PANEL)

	local var1 = var0:GetHubByHubId(var0.MINIGAME_HUB_ID)

	arg0:FlushMarks(var1)
	Canvas.ForceUpdateCanvases()
	arg0:FlushIndex(var1)
end

function var0.ShowAwards(arg0)
	local var0 = getProxy(MiniGameProxy)
	local var1 = arg0:GetDropList()
	local var2 = var0:GetHubByHubId(var0.MINIGAME_HUB_ID).usedtime
	local var3 = {
		i18n("2023Valentine_minigame_label3"),
		i18n("2023Valentine_minigame_label2")
	}

	arg0:emit(ActivityMediator.ON_AWARD_WINDOW, var1, var2, var3)
end

function var0.GetDropList(arg0)
	return pg.mini_game[var0.MINIGAME_ID].simple_config_data.drop_ids
end

function var0.FlushMarks(arg0, arg1)
	local var0 = arg1.usedtime
	local var1 = var0 + arg1.count

	for iter0, iter1 in ipairs(arg0.markTrs) do
		setActive(iter1, iter0 <= var1)
		setActive(iter1:Find("finish"), iter0 <= var0)
		setActive(iter1:Find("finish/line"), var0 >= iter0 + 1)
	end
end

function var0.FlushIndex(arg0, arg1)
	local var0 = arg1.usedtime

	arg0.indexTxt.text = "<color=#753330>" .. var0 .. "</color><color=#605176>/7</color>"
end

function var0.OnUpdateFlush(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

return var0
