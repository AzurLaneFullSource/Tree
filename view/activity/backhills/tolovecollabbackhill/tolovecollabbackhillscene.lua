local var0_0 = class("ToLoveCollabBackHillScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "ToLoveCollabBackHillUI"
end

function var0_0.init(arg0_2)
	arg0_2.top = arg0_2:findTF("top")
	arg0_2._map = arg0_2:findTF("map")
	arg0_2._upper = arg0_2:findTF("upper")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("upper/task"), function()
		arg0_3:emit(ToLoveCollabBackHillMediator.TASK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("upper/jinianzhang"), function()
		arg0_3:emit(ToLoveCollabBackHillMediator.TROPHY)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("upper/help"), function()
		arg0_3:emit(ToLoveCollabBackHillMediator.PUZZLE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/return_btn"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/return_main_btn"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tolove_main_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("upper/xiaoyouxi"), function()
		arg0_3:emit(ToLoveCollabBackHillMediator.MINI_GAME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("upper/tebiezuozhan"), function()
		local var0_11 = getProxy(ChapterProxy)
		local var1_11, var2_11 = var0_11:getLastMapForActivity()

		if not var1_11 or not var0_11:getMapById(var1_11):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_3:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_11,
				mapIdx = var1_11
			})
		end
	end, SFX_PANEL)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_12)
	local var0_12 = getProxy(ActivityProxy)

	setActive(arg0_12:findTF("upper/task/tips"), ToLoveCollabTaskMediator.GetTaskRedTip())

	local var1_12 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
	local var2_12 = false

	for iter0_12, iter1_12 in ipairs(var1_12.data1_list) do
		if not table.contains(var1_12.data2_list, iter1_12) then
			var2_12 = true

			break
		end
	end

	if #var1_12:GetPicturePuzzleIds() == #var1_12.data2_list and var1_12.data1 ~= 1 then
		var2_12 = true
	end

	setActive(arg0_12:findTF("upper/jinianzhang/tips"), var2_12)
	setActive(arg0_12:findTF("upper/help/tips"), PuzzleConnectMediator.GetRedTip())
	setActive(arg0_12:findTF("upper/xiaoyouxi/tips"), ToLoveGameVo.ShouldShowTip())
end

function var0_0.willExit(arg0_13)
	return
end

function var0_0.IsShowMainTip()
	local var0_14 = getProxy(ActivityProxy)

	local function var1_14()
		return ToLoveCollabTaskMediator.GetTaskRedTip()
	end

	local function var2_14()
		local var0_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
		local var1_16 = false

		for iter0_16, iter1_16 in ipairs(var0_16.data1_list) do
			if not table.contains(var0_16.data2_list, iter1_16) then
				var1_16 = true

				break
			end
		end

		if #var0_16:GetPicturePuzzleIds() == #var0_16.data2_list and var0_16.data1 ~= 1 then
			var1_16 = true
		end

		return var1_16
	end

	local function var3_14()
		return PuzzleConnectMediator.GetRedTip()
	end

	local function var4_14()
		return ToLoveGameVo.ShouldShowTip()
	end

	return var1_14() or var2_14() or var3_14() or var4_14()
end

return var0_0
