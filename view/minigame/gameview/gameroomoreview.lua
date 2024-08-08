local var0_0 = class("GameRoomOreView", import("view.miniGame.MiniGameTemplateView"))

function var0_0.getUIName(arg0_1)
	return "GameRoomOreUI"
end

function var0_0.getGameController(arg0_2)
	return OreMiniGameController
end

function var0_0.getShowSide(arg0_3)
	return false
end

function var0_0.initPageUI(arg0_4)
	var0_0.super.initPageUI(arg0_4)
	onButton(arg0_4, arg0_4.rtTitlePage:Find("main/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ore_minigame_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.rtTitlePage:Find("result/window/btn_finish"), function()
		arg0_4:openUI("main")
		arg0_4.gameController:ResetGame()
	end, SFX_CONFIRM)
end

function var0_0.initOpenUISwich(arg0_7)
	arg0_7.openSwitchDic = {
		main = function()
			arg0_7:updateMainUI()
		end,
		pause = function()
			arg0_7.gameController:PauseGame()
		end,
		exit = function()
			arg0_7.gameController:PauseGame()
		end,
		result = function()
			local var0_11 = arg0_7:GetMGData():GetRuntimeData("elements") or {}
			local var1_11 = arg0_7.gameController.point
			local var2_11 = var0_11[1] or 0
			local var3_11 = arg0_7.rtTitlePage:Find("result")

			setActive(var3_11:Find("window/now/new"), var2_11 < var1_11)

			if var2_11 <= var1_11 then
				var2_11 = var1_11
				var0_11[1] = var1_11
			end

			arg0_7:SaveDataChange(var0_11)
			setText(var3_11:Find("window/high/Text"), var2_11)
			setText(var3_11:Find("window/now/Text"), var1_11)

			local var4_11 = arg0_7:GetMGHubData()

			if (not arg0_7:getShowSide() or arg0_7.stageIndex == var4_11.usedtime + 1) and var4_11.count > 0 then
				arg0_7:SendSuccess(var1_11)
			end
		end
	}
end

function var0_0.openUI(arg0_12, arg1_12)
	if not arg0_12.openSwitchDic then
		arg0_12:initOpenUISwich()
	end

	if arg0_12.status then
		setActive(arg0_12.rtTitlePage:Find(arg0_12.status), false)
	end

	if arg1_12 == "main" then
		arg0_12:openCoinLayer(true)
	else
		arg0_12:openCoinLayer(false)
	end

	if arg1_12 then
		setActive(arg0_12.rtTitlePage:Find(arg1_12), true)
	end

	arg0_12.status = arg1_12

	switch(arg1_12, arg0_12.openSwitchDic)
end

function var0_0.updateMainUI(arg0_13)
	var0_0.super.updateMainUI(arg0_13)
end

function var0_0.willExit(arg0_14)
	arg0_14.gameController:willExit()
end

return var0_0
