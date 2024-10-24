local var0_0 = class("ChapterOpCommand", import(".ChapterOpRoutine"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if (function()
		if var0_1.type == ChapterConst.OpRetreat then
			return
		end

		local var0_2 = getProxy(ChapterProxy)
		local var1_2 = var0_2:getActiveChapter()

		if not var1_2 then
			return true
		end

		if var0_1.type == ChapterConst.OpSwitch then
			for iter0_2, iter1_2 in ipairs(var1_2.fleets) do
				if iter1_2.id == var0_1.id then
					var1_2.findex = iter0_2

					break
				end
			end

			var0_2:updateChapter(var1_2, bit.bor(ChapterConst.DirtyStrategy, ChapterConst.DirtyFleet))
			arg0_1:sendNotification(GAME.CHAPTER_OP_DONE, {
				type = var0_1.type
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_success", var1_2.fleet.name))

			return true
		end
	end)() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(13103, {
		act = var0_1.type,
		group_id = defaultValue(var0_1.id, 0),
		act_arg_1 = var0_1.arg1,
		act_arg_2 = var0_1.arg2,
		act_arg_3 = var0_1.arg3,
		act_arg_4 = var0_1.arg4,
		act_arg_5 = var0_1.arg5
	}, 13104, function(arg0_3)
		if arg0_3.result == 0 then
			local var0_3 = getProxy(ChapterProxy)
			local var1_3 = var0_3:getActiveChapter()

			if not var1_3 then
				return
			end

			local var2_3
			local var3_3

			arg0_1:initData(var0_1, arg0_3, var1_3)
			arg0_1:doDropUpdate()

			if arg0_1.chapter then
				local var4_3 = arg0_1.items

				if var0_1.type == ChapterConst.OpMove then
					arg0_1:doCollectCommonAction()
					arg0_1:doCollectAI()
					arg0_1:doMove()
					arg0_1:doTeleportByPortal()
					getProxy(ChapterProxy):SetExtendChapterData(var1_3.id, "FleetMoveDistance", #arg0_3.move_path)
				elseif var0_1.type == ChapterConst.OpBox then
					arg0_1:AddBoxAction()
					arg0_1:doCollectAI()
				else
					arg0_1:doMapUpdate()
					arg0_1:doAIUpdate()
					arg0_1:doShipUpdate()
					arg0_1:doBuffUpdate()
					arg0_1:doCellFlagUpdate()
					arg0_1:doExtraFlagUpdate()

					if var0_1.type == ChapterConst.OpRetreat then
						if not var0_1.id then
							local var5_3 = var0_3:getMapById(var1_3:getConfig("map")):getMapType()

							var0_1.win = arg0_1.chapter:CheckChapterWillWin()

							if var0_1.win then
								arg0_1.chapter:UpdateProgressOnRetreat()
								var0_3:addRemasterPassCount(arg0_1.chapter.id)
							end

							local var6_3 = pg.TimeMgr.GetInstance()

							if var0_1.win and var5_3 == Map.ELITE and var6_3:IsSameDay(var1_3:getStartTime(), var6_3:GetServerTime()) then
								getProxy(DailyLevelProxy):EliteCountPlus()
							end

							if var4_3 and #var4_3 > 0 then
								getProxy(ChapterProxy):AddExtendChapterDataArray(arg0_1.chapter.id, "ResultDrops", var4_3)

								var4_3 = nil
							end

							var2_3 = var0_3:FinishAutoFight(var1_3.id)

							local var7_3 = arg0_1.chapter:GetRegularFleetIds()

							getProxy(ChapterProxy):SetLastFleetIndex(var7_3, true)
						end

						arg0_1:doRetreat()

						if not var0_1.id then
							var3_3 = Clone(arg0_1.chapter)

							arg0_1.chapter:CleanLevelData()
						end
					elseif var0_1.type == ChapterConst.OpStory then
						arg0_1:doCollectAI()
						arg0_1:doPlayStory()
					elseif var0_1.type == ChapterConst.OpAmbush then
						arg0_1:doAmbush()
					elseif var0_1.type == ChapterConst.OpStrategy then
						arg0_1:doCollectAI()
						arg0_1:doStrategy()
					elseif var0_1.type == ChapterConst.OpRepair then
						arg0_1:doRepair()
					elseif var0_1.type == ChapterConst.OpSupply then
						arg0_1:doSupply()
					elseif var0_1.type == ChapterConst.OpEnemyRound then
						arg0_1:doCollectAI()
						arg0_1:doEnemyRound()
					elseif var0_1.type == ChapterConst.OpSubState then
						arg0_1:doSubState()
					elseif var0_1.type == ChapterConst.OpBarrier then
						arg0_1:doBarrier()
					elseif var0_1.type == ChapterConst.OpRequest then
						arg0_1:doRequest()
					elseif var0_1.type == ChapterConst.OpSkipBattle then
						arg0_1.chapter:UpdateProgressAfterSkipBattle()
						arg0_1:doSkipBattle()
					elseif var0_1.type == ChapterConst.OpPreClear then
						arg0_1.chapter:CleanCurrentEnemy()
						arg0_1:doSkipBattle()
					elseif var0_1.type == ChapterConst.OpSubTeleport then
						arg0_1:doTeleportSub()
						arg0_1:doTeleportByPortal()
					end
				end

				if var0_1.type == ChapterConst.OpEnemyRound or var0_1.type == ChapterConst.OpMove then
					var0_3:updateChapter(arg0_1.chapter, arg0_1.flag)
				else
					arg0_1.flag = bit.bor(arg0_1.flag, arg0_1.extraFlag)

					var0_3:updateChapter(arg0_1.chapter, arg0_1.flag)
				end

				if var0_1.type == ChapterConst.OpSkipBattle then
					arg0_1:sendNotification(GAME.CHAPTER_BATTLE_RESULT_REQUEST, {
						isSkipBattle = true
					})

					return
				end

				arg0_1:sendNotification(GAME.CHAPTER_OP_DONE, {
					type = var0_1.type,
					id = var0_1.id,
					arg1 = var0_1.arg1,
					arg2 = var0_1.arg2,
					path = arg0_3.move_path,
					fullpath = arg0_1.fullpath,
					items = var4_3,
					exittype = var0_1.exittype or 0,
					aiActs = arg0_1.aiActs,
					extraFlag = arg0_1.extraFlag,
					oldLine = var0_1.ordLine,
					win = var0_1.win,
					teleportPaths = arg0_1.teleportPaths,
					extendData = var2_3,
					finalChapterLevelData = var3_3
				})
			end
		else
			errorMsg(string.format("SLG操作%d 请求失效，重新拉取信息", var0_1.type))
			pg.TipsMgr.GetInstance():ShowTips(errorTip("levelScene_operation", arg0_3.result))

			if var0_1.type ~= ChapterConst.OpRequest and var0_1.type ~= ChapterConst.OpRetreat and var0_1.type ~= ChapterConst.OpSubTeleport then
				arg0_1:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest,
					id = var0_1.id
				})
			end
		end
	end)
end

function var0_0.PrepareChapterRetreat(arg0_4)
	seriesAsync({
		function(arg0_5)
			local var0_5 = getProxy(ChapterProxy):getActiveChapter()

			if var0_5 and var0_5:CheckChapterWillWin() and not var0_5:IsRemaster() then
				var0_5:UpdateProgressOnRetreat()

				local var1_5 = var0_5:getConfig("defeat_story_count")
				local var2_5 = var0_5:getConfig("defeat_story")
				local var3_5 = false

				table.SerialIpairsAsync(var1_5, function(arg0_6, arg1_6, arg2_6)
					if arg1_6 > var0_5.defeatCount then
						arg2_6()

						return
					end

					local var0_6 = var2_5[arg0_6]

					if not var0_6 or pg.NewStoryMgr.GetInstance():IsPlayed(tostring(var0_6)) then
						arg2_6()

						return
					end

					if type(var0_6) == "number" then
						pg.m02:sendNotification(GAME.BEGIN_STAGE, {
							system = SYSTEM_PERFORM,
							stageId = var0_6
						})
					elseif type(var0_6) == "string" then
						if ChapterOpCommand.PlayChapterStory(var0_6, arg2_6, not var3_5 and var0_5:IsAutoFight()) then
							var3_5 = true
						end
					else
						arg2_6()
					end
				end, arg0_5)
			else
				arg0_5()
			end
		end,
		function(arg0_7)
			pg.m02:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
			arg0_7()
		end
	}, arg0_4)
end

function var0_0.PlayChapterStory(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = pg.NewStoryMgr.GetInstance()

	var0_8:Play(arg0_8, arg1_8, arg3_8)

	if not getProxy(SettingsProxy):GetStoryAutoPlayFlag() and arg2_8 and var0_8:IsRunning() then
		var0_8:Puase()

		local function var1_8()
			var0_8:Resume()
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideYes = true,
			parent = rtf(var0_8._tf),
			type = MSGBOX_TYPE_STORY_CANCEL_TIP,
			onYes = function()
				var1_8()
				var0_8:TriggerAutoBtn()
			end,
			onNo = var1_8,
			weight = LayerWeightConst.TOP_LAYER
		})

		return true
	end
end

return var0_0
