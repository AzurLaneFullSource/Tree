local var0_0 = class("NewEducateNodePanel", import("view.base.BaseSubView"))

var0_0.NODE_TYPE = {
	MAIN_OPTION = 104,
	EVENT_TEXT = 100,
	DROP = 102,
	STORY_BRANCH = 2,
	EVENT_OPTION = 101,
	MAIN_TEXT = 103,
	PERFORMANCE = 1
}
var0_0.NEXT_TYPE = {
	OPTION = 2,
	NOMARL = 1,
	STORY_FLAG = 4,
	PROBABILITY = 3
}
var0_0.DROP_TYPE = {
	WORD_PERFORMANCE = 1,
	POLAROID = 4,
	EVENT = 3,
	MAIN_TIP = 2,
	DROP_LAYER = 5
}

function var0_0.getUIName(arg0_1)
	return "NewEducateNodeUI"
end

function var0_0.OnLoaded(arg0_2)
	eachChild(arg0_2._tf, function(arg0_3)
		setActive(arg0_3, false)
	end)

	arg0_2.loopCpkTF = arg0_2._tf:Find("cpk_bg")
	arg0_2.loopCpkTF:GetComponent(typeof(Image)).enabled = false
	arg0_2.loopCpkPlayer = arg0_2.loopCpkTF:Find("cpk/usm"):GetComponent(typeof(CriManaCpkUI))

	arg0_2.loopCpkPlayer:SetMaxFrameDrop(CriManaMovieMaterial.MaxFrameDrop.Infinite)

	arg0_2.cpkHandler = NewEducateCpkHandler.New(arg0_2._tf:Find("cpk"))
	arg0_2.pictureHandler = NewEducatePictureHandler.New(arg0_2._tf:Find("picture"))
	arg0_2.wordHandler = NewEducateWordHandler.New(arg0_2._tf:Find("dialogue"))
	arg0_2.dropHandler = NewEducateDropHandler.New(arg0_2._tf:Find("drop"))
	arg0_2.siteHandler = NewEducateSiteHandler.New(arg0_2._tf:Find("site"))
	arg0_2.optionsHandler = NewEducateOptionsHandler.New(arg0_2._tf:Find("options"))
	arg0_2.scheduleTF = arg0_2._tf:Find("scheduleBg")

	setText(arg0_2.scheduleTF:Find("root/window/left/title/Text"), i18n("child_plan_perform_title"))

	local var0_2 = arg0_2.scheduleTF:Find("root/window/left/content")

	arg0_2.planUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))
end

function var0_0.OnInit(arg0_4)
	arg0_4.siteHandler:BindEndBtn(function()
		arg0_4:Hide()
	end, arg0_4.contextData.onSiteEnd, arg0_4.contextData.onNormal)
	arg0_4.planUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			local var0_6 = arg0_4.plans[arg1_6 + 1]

			setActive(arg2_6:Find("icon"), var0_6)

			if var0_6 then
				local var1_6 = "plan_type" .. pg.child2_plan[var0_6].replace_type_show

				LoadImageSpriteAtlasAsync("ui/neweducatecommonui_atlas", var1_6, arg2_6:Find("icon"))
			end
		elseif arg0_6 == UIItemList.EventUpdate then
			arg1_6 = arg1_6 + 1

			local var2_6 = arg0_4.plans[arg1_6]

			if var2_6 then
				setText(arg2_6:Find("Text"), shortenString(pg.child2_plan[var2_6].name_2, 4))

				local var3_6 = arg1_6 > arg0_4.curPlanIdx and "808182" or "ffffff"

				if arg1_6 == arg0_4.curPlanIdx then
					var3_6 = "29bfff"
				end

				setTextColor(arg2_6:Find("Text"), Color.NewHex(var3_6))
				setActive(arg2_6:Find("selected"), arg1_6 == arg0_4.curPlanIdx)
			else
				setText(arg2_6:Find("Text"), i18n("child2_empty_plan"))
				setActive(arg2_6:Find("selected"), false)
			end
		end
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 2
	})
end

function var0_0.PlayLoopCpk(arg0_7, arg1_7)
	arg0_7.loopCpkPlayer.cpkPath = string.lower("OriginSource/cpk/" .. arg1_7 .. ".cpk")
	arg0_7.loopCpkPlayer.movieName = string.lower(arg1_7 .. ".bytes")

	arg0_7.loopCpkPlayer:StopCpk()
	arg0_7.loopCpkPlayer:SetCpkTotalTimeCallback(function(arg0_8)
		arg0_7.loopCpkTF:GetComponent(typeof(Image)).enabled = true
	end)
	setActive(arg0_7.loopCpkTF, true)
	arg0_7.loopCpkPlayer.player:Stop()
	arg0_7.loopCpkPlayer:PlayCpk()
end

function var0_0.StopLoopCpk(arg0_9)
	setActive(arg0_9.loopCpkTF, false)

	arg0_9.loopCpkTF:GetComponent(typeof(Image)).enabled = false
end

function var0_0.StartNode(arg0_10, arg1_10)
	arg0_10:Show()

	arg0_10.stystemNo = arg0_10.contextData.char:GetFSM():GetStystemNo()

	setActive(arg0_10.scheduleTF, arg0_10.stystemNo == NewEducateFSM.STYSTEM.PLAN)

	if arg0_10.stystemNo == NewEducateFSM.STYSTEM.MAP then
		local var0_10 = arg0_10.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.MAP):GetCurSiteId()

		arg0_10.siteHandler:SetSite(var0_10)

		local var1_10 = pg.child2_site_display[var0_10].type
		local var2_10 = 0

		if var1_10 == NewEducateConst.SITE_TYPE.WORK then
			var2_10 = arg0_10.contextData.char:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.WORK)
		elseif var1_10 == NewEducateConst.SITE_TYPE.TRAVEL then
			var2_10 = arg0_10.contextData.char:GetNormalIdByType(NewEducateConst.SITE_NORMAL_TYPE.TRAVEL)
		end

		if var2_10 ~= 0 then
			local var3_10 = arg0_10.contextData.char:GetRoundData():getConfig("stage")

			arg0_10:PlayLoopCpk(pg.child2_site_normal[var2_10].cpk[var3_10])
		end
	end

	arg0_10:ProceedNode(arg1_10)
end

function var0_0.OnNodeChainEnd(arg0_11)
	setActive(arg0_11.loopCpkTF, false)

	if arg0_11.stystemNo == NewEducateFSM.STYSTEM.MAP then
		arg0_11.cpkHandler:Reset()
		arg0_11.pictureHandler:Reset()
		arg0_11.wordHandler:Reset()
		arg0_11.dropHandler:Reset()
		arg0_11.siteHandler:OnEventEnd()
	elseif arg0_11.stystemNo == NewEducateFSM.STYSTEM.PLAN then
		if arg0_11.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.PLAN):IsFinish() then
			arg0_11:Hide()
		end
	else
		arg0_11:Hide()
	end
end

function var0_0.InitCallback(arg0_12, arg1_12)
	arg0_12.callback = nil

	switch(arg1_12, {
		[var0_0.NEXT_TYPE.NOMARL] = function()
			function arg0_12.callback()
				pg.m02:sendNotification(GAME.NEW_EDUCATE_TRIGGER_NODE, {
					id = arg0_12.contextData.char.id
				})
			end
		end,
		[var0_0.NEXT_TYPE.PROBABILITY] = function()
			function arg0_12.callback()
				pg.m02:sendNotification(GAME.NEW_EDUCATE_TRIGGER_NODE, {
					id = arg0_12.contextData.char.id
				})
			end
		end,
		[var0_0.NEXT_TYPE.OPTION] = function()
			function arg0_12.callback(arg0_18, arg1_18)
				pg.m02:sendNotification(GAME.NEW_EDUCATE_TRIGGER_NODE, {
					id = arg0_12.contextData.char.id,
					branch = arg0_18,
					costs = arg1_18
				})
			end
		end,
		[var0_0.NEXT_TYPE.STORY_FLAG] = function()
			function arg0_12.callback(arg0_20)
				pg.m02:sendNotification(GAME.NEW_EDUCATE_TRIGGER_NODE, {
					id = arg0_12.contextData.char.id,
					branch = arg0_20
				})
			end
		end
	}, function()
		assert(false, "node表非法next_type: " .. arg1_12)
	end)
end

function var0_0.CheckSchedule(arg0_22)
	if arg0_22.stystemNo == NewEducateFSM.STYSTEM.PLAN then
		local var0_22 = arg0_22.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.PLAN)

		arg0_22.unlockPlanNum = arg0_22.contextData.char:GetRoundData():getConfig("plan_num")
		arg0_22.plans = var0_22:GetPlans()
		arg0_22.curPlanIdx = var0_22:GetCurIdx()

		arg0_22.planUIList:align(arg0_22.unlockPlanNum)
	end
end

function var0_0.CheckLastDrops(arg0_23, arg1_23, arg2_23)
	if not arg0_23.curNodeId or not arg1_23 or #arg1_23 == 0 then
		arg2_23()
	else
		local var0_23 = pg.child2_node[arg0_23.curNodeId]
		local var1_23 = var0_23.drop_type_client

		switch(var1_23, {
			[var0_0.DROP_TYPE.WORD_PERFORMANCE] = function()
				if arg0_23.stystemNo == NewEducateFSM.STYSTEM.PLAN then
					arg0_23.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.PLAN):AddDrops(arg1_23)
				end

				arg0_23.wordHandler:Play(var0_23.performance_param[1], arg2_23, arg1_23, false)
			end,
			[var0_0.DROP_TYPE.MAIN_TIP] = function()
				arg0_23.dropHandler:Play(arg1_23, arg2_23)
				arg0_23.wordHandler:Reset()
			end,
			[var0_0.DROP_TYPE.EVENT] = function()
				seriesAsync({
					function(arg0_27)
						local var0_27 = underscore.select(arg1_23, function(arg0_28)
							return arg0_28.type == NewEducateConst.DROP_TYPE.BUFF
						end)

						if #var0_27 > 0 then
							arg0_23:emit(NewEducateBaseUI.ON_DROP, {
								items = var0_27,
								removeFunc = arg0_27
							})
						else
							arg0_27()
						end
					end
				}, function()
					arg0_23.siteHandler:Play(arg0_23.curNodeId, arg2_23, arg1_23)
				end)
			end,
			[var0_0.DROP_TYPE.POLAROID] = function()
				arg0_23:StopLoopCpk()
				arg0_23.cpkHandler:Reset()
				arg0_23.wordHandler:Reset()

				local var0_30 = {}

				for iter0_30, iter1_30 in ipairs(arg1_23) do
					assert(iter1_30.type == NewEducateConst.DROP_TYPE.POLAROID, "drop_type_client4的掉落必须为大头贴")
					table.insert(var0_30, function(arg0_31)
						arg0_23.dropHandler:PlayPolaroid(iter1_30, arg0_31)
					end)
					table.insert(var0_30, function(arg0_32)
						local var0_32 = pg.child2_polaroid[iter1_30.id].desc

						if #var0_32 > 0 then
							arg0_23.wordHandler:PlayWordIds(var0_32, arg0_32)
						else
							arg0_32()
						end
					end)
				end

				seriesAsync(var0_30, function()
					existCall(arg2_23)

					if #arg1_23 > 0 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("child_polaroid_get_tip"))
					end
				end)
			end,
			[var0_0.DROP_TYPE.DROP_LAYER] = function()
				arg0_23:emit(NewEducateBaseUI.ON_DROP, {
					items = arg1_23,
					removeFunc = arg2_23
				})
			end
		}, function()
			assert(false, "node表非法drop_type_client: " .. var1_23 .. ",node:" .. arg0_23.curNodeId)
		end)

		if arg0_23.stystemNo == NewEducateFSM.STYSTEM.MAP and var1_23 == var0_0.DROP_TYPE.WORD_PERFORMANCE then
			arg0_23.siteHandler:AddDropRecords(arg1_23)
		end
	end
end

function var0_0.ProceedNode(arg0_36, arg1_36, arg2_36, arg3_36)
	seriesAsync({
		function(arg0_37)
			arg0_36:CheckLastDrops(arg2_36, arg0_37)
		end
	}, function()
		arg0_36:_ProceedNode(arg1_36, arg2_36, arg3_36)
	end)
end

function var0_0._ProceedNode(arg0_39, arg1_39, arg2_39, arg3_39)
	arg0_39.curNodeId = arg1_39

	if arg0_39.curNodeId == 0 then
		existCall(arg3_39)
		arg0_39:OnNodeChainEnd()

		return
	end

	arg0_39:CheckSchedule()

	local var0_39 = pg.child2_node[arg1_39]

	arg0_39:InitCallback(var0_39.next_type)
	originalPrint("ProceedNode", arg1_39)
	switch(var0_39.type, {
		[var0_0.NODE_TYPE.PERFORMANCE] = function()
			arg0_39:PlayPerformances(var0_39.performance_type, var0_39.performance_param, arg0_39.callback)
		end,
		[var0_0.NODE_TYPE.DROP] = function()
			arg0_39.callback()
		end,
		[var0_0.NODE_TYPE.STORY_BRANCH] = function()
			arg0_39:PlayStoryBranch(var0_39.performance_param, function(arg0_43)
				arg0_39.callback(arg0_43)
			end)
		end,
		[var0_0.NODE_TYPE.EVENT_TEXT] = function()
			arg0_39.siteHandler:Play(arg1_39, arg0_39.callback)
		end,
		[var0_0.NODE_TYPE.EVENT_OPTION] = function()
			arg0_39.siteHandler:Play(arg1_39, arg0_39.callback)
		end,
		[var0_0.NODE_TYPE.MAIN_TEXT] = function()
			local var0_46 = arg0_39:_IsShowNextInMainText(var0_39)

			if var0_39.next_type == var0_0.NEXT_TYPE.OPTION then
				local function var1_46()
					arg0_39.optionsHandler:Play(var0_39.next, arg0_39.callback)
				end

				arg0_39.wordHandler:Play(tonumber(var0_39.text), var1_46, nil, var0_46, true)
			else
				arg0_39.wordHandler:Play(tonumber(var0_39.text), arg0_39.callback, nil, var0_46, true)
			end
		end,
		[var0_0.NODE_TYPE.MAIN_OPTION] = function()
			arg0_39.callback()
		end
	}, function()
		assert(false, "node表非法type: " .. var0_39.type)
	end)
end

function var0_0._IsShowNextInMainText(arg0_50, arg1_50)
	if arg1_50.next == "" then
		return false
	end

	if arg1_50.next_type == var0_0.NEXT_TYPE.NOMARL then
		local var0_50 = tonumber(arg1_50.next)

		return pg.child2_node[var0_50].type ~= var0_0.NODE_TYPE.DROP
	end

	return true
end

function var0_0.PlayPerformances(arg0_51, arg1_51, arg2_51, arg3_51)
	switch(arg1_51, {
		[NewEducateConst.PERFORM_TYPE.CPK] = function()
			arg0_51.wordHandler:Reset()

			local var0_52 = arg0_51.contextData.char:GetRoundData():getConfig("stage")
			local var1_52 = ""

			if arg0_51.stystemNo == NewEducateFSM.STYSTEM.PLAN then
				local var2_52 = arg0_51.plans[arg0_51.curPlanIdx]

				var1_52 = pg.child2_plan[var2_52].name
			end

			arg0_51.cpkHandler:SetUIParam(arg0_51.stystemNo == NewEducateFSM.STYSTEM.PLAN)
			arg0_51.cpkHandler:Play(arg2_51[var0_52], arg3_51, var1_52)
		end,
		[NewEducateConst.PERFORM_TYPE.PICTURE] = function()
			arg0_51.wordHandler:Reset()
			arg0_51.pictureHandler:Play(arg2_51, arg3_51)
		end,
		[NewEducateConst.PERFORM_TYPE.WORD] = function()
			local var0_54 = pg.child2_node[arg0_51.curNodeId].next == ""

			arg0_51.wordHandler:Play(arg2_51[1], arg3_51, nil, not var0_54, true)
		end,
		[NewEducateConst.PERFORM_TYPE.STORY] = function()
			NewEducateHelper.PlaySpecialStory(arg2_51, function(arg0_56, arg1_56)
				arg3_51(arg1_56)
			end, true)
		end
	}, function()
		assert(false, "node表非法performance_type: " .. arg1_51)
	end)
end

function var0_0.PlayStoryBranch(arg0_58, arg1_58, arg2_58)
	NewEducateHelper.PlaySpecialStory(arg1_58, function(arg0_59, arg1_59)
		arg2_58(arg1_59)
	end, true)
end

function var0_0.PlayWordIds(arg0_60, arg1_60, arg2_60)
	arg0_60:Show()
	arg0_60.wordHandler:PlayWordIds(arg1_60, function()
		arg0_60.wordHandler:Reset()
		arg0_60.super.Hide(arg0_60)
		existCall(arg2_60)
	end)
end

function var0_0.UpdateCallName(arg0_62)
	arg0_62.wordHandler:UpdateCallName()
	arg0_62.siteHandler:UpdateCallName()
	arg0_62.optionsHandler:UpdateCallName()
end

function var0_0.Hide(arg0_63)
	existCall(arg0_63.contextData.onHide)
	arg0_63:StopLoopCpk()
	arg0_63.cpkHandler:Reset()
	arg0_63.pictureHandler:Reset()
	arg0_63.wordHandler:Reset()
	arg0_63.dropHandler:Reset()
	arg0_63.siteHandler:Reset()
	arg0_63.optionsHandler:Reset()
	arg0_63.super.Hide(arg0_63)
end

function var0_0.OnDestroy(arg0_64)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_64._tf, arg0_64._parentTf)

	if arg0_64.cpkHandler then
		arg0_64.cpkHandler:Destroy()
	else
		warning("not exist self.cpkHandler")
	end

	if arg0_64.pictureHandler then
		arg0_64.pictureHandler:Destroy()
	else
		warning("not exist self.pictureHandler")
	end

	if arg0_64.wordHandler then
		arg0_64.wordHandler:Destroy()
	else
		warning("not exist self.wordHandler")
	end

	if arg0_64.dropHandler then
		arg0_64.dropHandler:Destroy()
	else
		warning("not exist self.dropHandler")
	end

	if arg0_64.siteHandler then
		arg0_64.siteHandler:Destroy()
	else
		warning("not exist self.siteHandler")
	end

	if arg0_64.optionsHandler then
		arg0_64.optionsHandler:Destroy()
	else
		warning("not exist self.optionsHandler")
	end
end

return var0_0
