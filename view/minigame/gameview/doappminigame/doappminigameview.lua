local var0_0 = class("DOAPPMiniGameView", import("view.miniGame.MiniGameTemplateView"))

var0_0.canSelectStage = false

function var0_0.getUIName(arg0_1)
	return "DOAPPMiniGameUI"
end

function var0_0.getGameController(arg0_2)
	return DOAPPMiniGameController
end

function var0_0.initPageUI(arg0_3)
	var0_0.super.initPageUI(arg0_3)
	onButton(arg0_3, arg0_3.rtTitlePage:Find("main/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.doa_minigame_help.tip
		})
	end, SFX_PANEL)

	local var0_3 = arg0_3:GetMGData():GetSimpleValue("story")

	onButton(arg0_3, arg0_3.rtTitlePage:Find("main/btn_start"), function()
		local var0_5 = {}
		local var1_5 = checkExist(var0_3, {
			arg0_3.stageIndex
		}, {
			1
		})

		if var1_5 then
			table.insert(var0_5, function(arg0_6)
				pg.NewStoryMgr.GetInstance():Play(var1_5, arg0_6)
			end)
		end

		seriesAsync(var0_5, function()
			arg0_3:openUI("select")
		end)
	end, SFX_PANEL)

	local var1_3 = arg0_3.rtTitlePage:Find("select")

	onButton(arg0_3, var1_3:Find("btn_back"), function()
		arg0_3:openUI("main")
	end, SFX_CANCEL)
	onButton(arg0_3, var1_3:Find("btn/confirm"), function()
		if not arg0_3.character then
			pg.TipsMgr.GetInstance():ShowTips("without selected character")

			return
		end

		arg0_3.gameController:ResetGame()
		arg0_3.gameController:ReadyGame({
			name = arg0_3.character
		})
		arg0_3:openUI("countdown")
	end, SFX_CONFIRM)
	eachChild(var1_3:Find("content"), function(arg0_10)
		setText(arg0_10:Find("name/Text"), i18n("doa_minigame_" .. arg0_10.name))
		onToggle(arg0_3, arg0_10, function(arg0_11)
			if arg0_11 then
				arg0_3.character = arg0_10.name

				setAnchoredPosition(arg0_10:Find(arg0_10.name), {
					x = 70
				})
				quickPlayAnimator(arg0_10:Find(arg0_10.name .. "/Image"), "Win")
			else
				if arg0_3.character == arg0_10.name then
					arg0_3.character = nil
				end

				setAnchoredPosition(arg0_10:Find(arg0_10.name), {
					x = 110
				})
				quickPlayAnimator(arg0_10:Find(arg0_10.name .. "/Image"), "Idle")
			end
		end, SFX_PANEL)
	end)
end

local function var1_0(arg0_12, arg1_12, arg2_12, arg3_12)
	eachChild(arg0_12:Find("mask"), function(arg0_13)
		setActive(arg0_13, arg0_13.name == arg1_12)
	end)
	setText(arg0_12:Find("name/Text"), i18n("doa_minigame_" .. arg1_12))
	eachChild(arg0_12:Find("name/Text"), function(arg0_14)
		setActive(arg0_14, arg0_14.name == arg1_12)
	end)
	setActive(arg0_12:Find("result/lose"), arg3_12 < 0)
	setActive(arg0_12:Find("result/win"), arg3_12 > 0)
	eachChild(arg0_12:Find("point"), function(arg0_15)
		setActive(arg0_15, tonumber(arg0_15.name) <= arg2_12)
	end)
end

function var0_0.initOpenUISwich(arg0_16)
	var0_0.super.initOpenUISwich(arg0_16)

	function arg0_16.openSwitchDic.result()
		var1_0(arg0_16.rtTitlePage:Find("result/window/self"), arg0_16.gameController:GetResultInfo(false))
		var1_0(arg0_16.rtTitlePage:Find("result/window/other"), arg0_16.gameController:GetResultInfo(true))

		local var0_17 = arg0_16:GetMGHubData()

		if arg0_16.stageIndex == var0_17.usedtime + 1 and var0_17.count > 0 then
			arg0_16:SendSuccess(0)
		end
	end

	function arg0_16.openSwitchDic.select()
		triggerToggle(arg0_16.rtTitlePage:Find("select/content/Marie"), true)
	end
end

function var0_0.initBackPressSwitch(arg0_19)
	var0_0.super.initBackPressSwitch(arg0_19)

	function arg0_19.backPressSwitchDic.select()
		arg0_19:openUI("main")
	end
end

function var0_0.willExit(arg0_21)
	arg0_21.gameController:willExit()
end

return var0_0
