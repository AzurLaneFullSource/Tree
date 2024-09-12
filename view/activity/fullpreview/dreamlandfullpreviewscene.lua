local var0_0 = class("DreamlandFullPreviewScene", import(".FullPreviewSceneTemplate"))

var0_0.MINIGAME_ID = 66

function var0_0.getUIName(arg0_1)
	return "DreamlandFullPreviewUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2:findTF("btns")

	arg0_2.dreamlandBtn = arg0_2:findTF("dreamland", var0_2)
	arg0_2.skinBtn = arg0_2:findTF("skin", var0_2)
	arg0_2.buildBtn = arg0_2:findTF("build", var0_2)
	arg0_2.battleBtn = arg0_2:findTF("battle", var0_2)
	arg0_2.minigameBtn = arg0_2:findTF("minigame", var0_2)

	setText(arg0_2:findTF("top/info/Text"), i18n("dreamland_main_desc"))

	arg0_2.preActId = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_DREAMLAND):getConfig("config_client").preActID

	local var1_2 = underscore.flatten(pg.activity_template[arg0_2.preActId].config_data)

	arg0_2.taskId = var1_2[#var1_2]
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/back"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/home"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.dreamland_main_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.dreamlandBtn, function()
		if arg0_3.isFinishPre then
			arg0_3:emit(FullPreviewMediatorTemplate.GO_SCENE, SCENE.DREAMLAND)
		else
			arg0_3:emit(FullPreviewMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = arg0_3.preActId
			})
		end
	end, SFX_PANEL)
	arg0_3:BindSkinShop(arg0_3.skinBtn)
	arg0_3:BindBuildShip(arg0_3.buildBtn)
	arg0_3:BindBattle(arg0_3.battleBtn)
	arg0_3:BindMiniGame(arg0_3.minigameBtn, var0_0.MINIGAME_ID)
	arg0_3:UpdateView()
end

function var0_0.IsFinishPreAct(arg0_8)
	local var0_8 = getProxy(TaskProxy)
	local var1_8 = var0_8:getTaskById(arg0_8.taskId) or var0_8:getFinishTaskById(arg0_8.taskId)

	return var1_8 and var1_8:getTaskStatus() == 2
end

function var0_0.UpdateView(arg0_9)
	setActive(arg0_9:findTF("tip", arg0_9.minigameBtn), var0_0.MiniGameTip())
	setActive(arg0_9:findTF("dreamland/tip", arg0_9.dreamlandBtn), var0_0.DreamlandTip())

	arg0_9.isFinishPre = arg0_9:IsFinishPreAct()

	setActive(arg0_9:findTF("dreamland", arg0_9.dreamlandBtn), arg0_9.isFinishPre)
	setActive(arg0_9:findTF("pre_act", arg0_9.dreamlandBtn), not arg0_9.isFinishPre)
end

function var0_0.MiniGameTip()
	return var0_0.IsMiniGameTip(var0_0.MINIGAME_ID)
end

function var0_0.DreamlandTip()
	local var0_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_DREAMLAND)
	local var1_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

	return DreamlandData.New(var0_11, var1_11):ExistAnyMapOrExploreAward()
end

function var0_0.IsShowMainTip(arg0_12)
	return var0_0.MiniGameTip() or var0_0.DreamlandTip()
end

return var0_0
