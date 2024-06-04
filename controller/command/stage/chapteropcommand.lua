local var0 = class("ChapterOpCommand", import(".ChapterOpRoutine"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if (function()
		if var0.type == ChapterConst.OpRetreat then
			return
		end

		local var0 = getProxy(ChapterProxy)
		local var1 = var0:getActiveChapter()

		if not var1 then
			return true
		end

		if var0.type == ChapterConst.OpSwitch then
			for iter0, iter1 in ipairs(var1.fleets) do
				if iter1.id == var0.id then
					var1.findex = iter0

					break
				end
			end

			var0:updateChapter(var1, bit.bor(ChapterConst.DirtyStrategy, ChapterConst.DirtyFleet))
			arg0:sendNotification(GAME.CHAPTER_OP_DONE, {
				type = var0.type
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_success", var1.fleet.name))

			return true
		end
	end)() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(13103, {
		act = var0.type,
		group_id = defaultValue(var0.id, 0),
		act_arg_1 = var0.arg1,
		act_arg_2 = var0.arg2,
		act_arg_3 = var0.arg3,
		act_arg_4 = var0.arg4,
		act_arg_5 = var0.arg5
	}, 13104, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ChapterProxy)
			local var1 = var0:getActiveChapter()

			if not var1 then
				return
			end

			local var2
			local var3

			arg0:initData(var0, arg0, var1)
			arg0:doDropUpdate()

			if arg0.chapter then
				local var4 = arg0.items

				if var0.type == ChapterConst.OpMove then
					arg0:doCollectCommonAction()
					arg0:doCollectAI()
					arg0:doMove()
					arg0:doTeleportByPortal()
					getProxy(ChapterProxy):SetExtendChapterData(var1.id, "FleetMoveDistance", #arg0.move_path)
				elseif var0.type == ChapterConst.OpBox then
					arg0:AddBoxAction()
					arg0:doCollectAI()
				else
					arg0:doMapUpdate()
					arg0:doAIUpdate()
					arg0:doShipUpdate()
					arg0:doBuffUpdate()
					arg0:doCellFlagUpdate()
					arg0:doExtraFlagUpdate()

					if var0.type == ChapterConst.OpRetreat then
						if not var0.id then
							var0.win = arg0.chapter:CheckChapterWillWin()

							if var0.win then
								arg0.chapter:UpdateProgressOnRetreat()
								var0:addRemasterPassCount(arg0.chapter.id)
							end

							local var5 = pg.TimeMgr.GetInstance()
							local var6 = var0:getMapById(var1:getConfig("map"))

							if var0.win and var6:getMapType() == Map.ELITE and var5:IsSameDay(var1:getStartTime(), var5:GetServerTime()) then
								getProxy(DailyLevelProxy):EliteCountPlus()
							end

							if var4 and #var4 > 0 then
								getProxy(ChapterProxy):AddExtendChapterDataArray(arg0.chapter.id, "ResultDrops", var4)

								var4 = nil
							end

							var2 = var0:FinishAutoFight(var1.id)

							local var7 = arg0.chapter:GetRegularFleetIds()

							getProxy(ChapterProxy):SetLastFleetIndex(var7, true)
						end

						arg0:doRetreat()

						if not var0.id then
							var3 = Clone(arg0.chapter)

							arg0.chapter:CleanLevelData()
						end
					elseif var0.type == ChapterConst.OpStory then
						arg0:doCollectAI()
						arg0:doPlayStory()
					elseif var0.type == ChapterConst.OpAmbush then
						arg0:doAmbush()
					elseif var0.type == ChapterConst.OpStrategy then
						arg0:doCollectAI()
						arg0:doStrategy()
					elseif var0.type == ChapterConst.OpRepair then
						arg0:doRepair()
					elseif var0.type == ChapterConst.OpSupply then
						arg0:doSupply()
					elseif var0.type == ChapterConst.OpEnemyRound then
						arg0:doCollectAI()
						arg0:doEnemyRound()
					elseif var0.type == ChapterConst.OpSubState then
						arg0:doSubState()
					elseif var0.type == ChapterConst.OpBarrier then
						arg0:doBarrier()
					elseif var0.type == ChapterConst.OpRequest then
						arg0:doRequest()
					elseif var0.type == ChapterConst.OpSkipBattle then
						arg0.chapter:UpdateProgressAfterSkipBattle()
						arg0:doSkipBattle()
					elseif var0.type == ChapterConst.OpPreClear then
						arg0.chapter:CleanCurrentEnemy()
						arg0:doSkipBattle()
					elseif var0.type == ChapterConst.OpSubTeleport then
						arg0:doTeleportSub()
						arg0:doTeleportByPortal()
					end
				end

				if var0.type == ChapterConst.OpEnemyRound or var0.type == ChapterConst.OpMove then
					var0:updateChapter(arg0.chapter, arg0.flag)
				else
					arg0.flag = bit.bor(arg0.flag, arg0.extraFlag)

					var0:updateChapter(arg0.chapter, arg0.flag)
				end

				if var0.type == ChapterConst.OpSkipBattle then
					arg0:sendNotification(GAME.CHAPTER_BATTLE_RESULT_REQUEST, {
						isSkipBattle = true
					})

					return
				end

				arg0:sendNotification(GAME.CHAPTER_OP_DONE, {
					type = var0.type,
					id = var0.id,
					arg1 = var0.arg1,
					arg2 = var0.arg2,
					path = arg0.move_path,
					fullpath = arg0.fullpath,
					items = var4,
					exittype = var0.exittype or 0,
					aiActs = arg0.aiActs,
					extraFlag = arg0.extraFlag,
					oldLine = var0.ordLine,
					win = var0.win,
					teleportPaths = arg0.teleportPaths,
					extendData = var2,
					finalChapterLevelData = var3
				})
			end
		else
			errorMsg(string.format("SLG操作%d 请求失效，重新拉取信息", var0.type))
			pg.TipsMgr.GetInstance():ShowTips(errorTip("levelScene_operation", arg0.result))

			if var0.type ~= ChapterConst.OpRequest and var0.type ~= ChapterConst.OpRetreat and var0.type ~= ChapterConst.OpSubTeleport then
				arg0:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest,
					id = var0.id
				})
			end
		end
	end)
end

function var0.PrepareChapterRetreat(arg0)
	seriesAsync({
		function(arg0)
			local var0 = getProxy(ChapterProxy):getActiveChapter()

			if var0 and var0:CheckChapterWillWin() and not var0:IsRemaster() then
				var0:UpdateProgressOnRetreat()

				local var1 = var0:getConfig("defeat_story_count")
				local var2 = var0:getConfig("defeat_story")
				local var3 = false

				table.SerialIpairsAsync(var1, function(arg0, arg1, arg2)
					if arg1 > var0.defeatCount then
						arg2()

						return
					end

					local var0 = var2[arg0]

					if not var0 or pg.NewStoryMgr.GetInstance():IsPlayed(tostring(var0)) then
						arg2()

						return
					end

					if type(var0) == "number" then
						pg.m02:sendNotification(GAME.BEGIN_STAGE, {
							system = SYSTEM_PERFORM,
							stageId = var0
						})
					elseif type(var0) == "string" then
						if ChapterOpCommand.PlayChapterStory(var0, arg2, not var3 and var0:IsAutoFight()) then
							var3 = true
						end
					else
						arg2()
					end
				end, arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			pg.m02:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
			arg0()
		end
	}, arg0)
end

function var0.PlayChapterStory(arg0, arg1, arg2)
	local var0 = pg.NewStoryMgr.GetInstance()

	var0:Play(arg0, arg1)

	if not getProxy(SettingsProxy):GetStoryAutoPlayFlag() and arg2 and var0:IsRunning() then
		var0:Puase()

		local function var1()
			var0:Resume()
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideYes = true,
			parent = rtf(var0._tf),
			type = MSGBOX_TYPE_STORY_CANCEL_TIP,
			onYes = function()
				var1()
				var0:TriggerAutoBtn()
			end,
			onNo = var1,
			weight = LayerWeightConst.TOP_LAYER
		})

		return true
	end
end

return var0
