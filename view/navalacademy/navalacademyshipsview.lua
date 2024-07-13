local var0_0 = class("NavalAcademyShipsView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.parent = arg1_1
	arg0_1.academyStudents = {}
	arg0_1._map = arg1_1:findTF("academyMap/map")
	arg0_1._shipTpl = arg0_1._map:Find("ship")
	arg0_1._fountain = arg0_1._map:Find("fountain")
	arg0_1.academyGraphPath = GraphPath.New(AcademyGraph)
end

function var0_0.BindBuildings(arg0_2, arg1_2)
	arg0_2.buildings = _.map(arg1_2, function(arg0_3)
		return arg0_3._tf
	end)
end

function var0_0.Refresh(arg0_4)
	local var0_4, var1_4 = arg0_4:getStudents()

	_.each(_.keys(arg0_4.academyStudents), function(arg0_5)
		local var0_5 = var0_4[arg0_5]
		local var1_5 = var1_4[arg0_5]
		local var2_5 = arg0_4.academyStudents[arg0_5]

		if var0_5 then
			var2_5:updateStudent(var0_5, var1_5)
		else
			var2_5:detach()
		end
	end)

	for iter0_4, iter1_4 in pairs(var0_4) do
		if not arg0_4.academyStudents[iter0_4] then
			local var2_4 = var1_4[iter0_4]
			local var3_4 = cloneTplTo(arg0_4._shipTpl, arg0_4._map)
			local var4_4 = NavalAcademyStudent.New(var3_4.gameObject)

			var4_4:attach()
			var4_4:setPathFinder(arg0_4.academyGraphPath)
			var4_4:setCallBack(function(arg0_6)
				arg0_4:onStateChange(iter1_4, arg0_6)
			end, function(arg0_7, arg1_7)
				arg0_4:onTask(iter1_4, var2_4)
			end)
			var4_4:updateStudent(iter1_4, var2_4)

			arg0_4.academyStudents[iter0_4] = var4_4
		end
	end

	arg0_4:sortStudents()
end

function var0_0.Init(arg0_8)
	arg0_8:Refresh()
end

function var0_0.onStateChange(arg0_9, arg1_9, arg2_9)
	if arg0_9.sortTimer then
		arg0_9.sortTimer:Stop()

		arg0_9.sortTimer = nil
	end

	if arg2_9 == NavalAcademyStudent.ShipState.Walk then
		arg0_9.sortTimer = Timer.New(function()
			arg0_9:sortStudents()
		end, 0.2, -1)

		arg0_9.sortTimer:Start()
	end
end

function var0_0.sortStudents(arg0_11)
	local var0_11 = {}

	table.insertto(var0_11, arg0_11.buildings)

	for iter0_11, iter1_11 in pairs(arg0_11.academyStudents) do
		table.insert(var0_11, iter1_11._tf)
	end

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg0_12.anchoredPosition.y > arg1_12.anchoredPosition.y
	end)

	local var1_11 = 0

	for iter2_11, iter3_11 in ipairs(var0_11) do
		iter3_11:SetSiblingIndex(var1_11)

		var1_11 = var1_11 + 1
	end
end

function var0_0.onTask(arg0_13, arg1_13, arg2_13)
	local var0_13 = getProxy(TaskProxy)
	local var1_13 = getProxy(ActivityProxy)
	local var2_13 = var1_13:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var3_13 = _.detect(var2_13, function(arg0_14)
		local var0_14 = arg0_14:getTaskShip()

		return var0_14 and var0_14.groupId == arg1_13.groupId
	end)

	if var3_13 and not var3_13:isEnd() then
		if var3_13.id == ActivityConst.JYHZ_ACTIVITY_ID and arg2_13.acceptTaskId then
			local var4_13 = var0_13:getAcademyTask(arg1_13.groupId)
			local var5_13 = var1_13:getActivityByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

			if var5_13 then
				local var6_13 = var5_13:getConfig("config_data")
				local var7_13 = _.detect(var6_13, function(arg0_15)
					local var0_15 = pg.chapter_template[arg0_15]

					return _.any(var0_15.npc_data, function(arg0_16)
						return pg.npc_squad_template[arg0_16].task_id == var4_13
					end)
				end)

				if var7_13 and getProxy(ChapterProxy):getChapterById(var7_13).active then
					pg.TipsMgr.GetInstance():ShowTips(i18n("task_target_chapter_in_progress"))

					return
				end
			end
		end

		if arg2_13.type then
			if arg2_13.type == 1 then
				Application.OpenURL(arg2_13.param)
			elseif arg2_13.type == 2 then
				arg0_13:emit(NavalAcademyMediator.GO_SCENE, arg2_13.param)
			elseif arg2_13.type == 3 then
				arg0_13:emit(NavalAcademyMediator.OPEN_ACTIVITY_PANEL, tonumber(arg2_13.param))
			elseif arg2_13.type == 4 then
				arg0_13:emit(NavalAcademyMediator.OPEN_ACTIVITY_SHOP)
			elseif arg2_13.type == 5 then
				arg0_13:emit(NavalAcademyMediator.OPEN_SCROLL, tonumber(arg2_13.param))
			end
		elseif not arg2_13.currentTask and arg2_13.acceptTaskId then
			local var8_13 = getProxy(PlayerProxy):getRawData()
			local var9_13 = pg.task_data_template[arg2_13.acceptTaskId]

			if var8_13.level < var9_13.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("task_level_notenough", var9_13.level))

				return
			end

			arg0_13:emit(NavalAcademyMediator.ACTIVITY_OP, {
				cmd = 1,
				activity_id = var3_13.id,
				arg1 = arg2_13.acceptTaskId
			})
		elseif arg2_13.currentTask then
			if not arg2_13.currentTask:isFinish() and arg2_13.currentTask:getConfig("sub_type") == 29 then
				arg0_13:emit(NavalAcademyMediator.TASK_GO, {
					taskVO = arg2_13.currentTask
				})
			elseif not arg2_13.currentTask:isReceive() then
				arg0_13:emit(NavalAcademyMediator.GO_TASK_SCENE, {
					page = "activity"
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_work_done"))
		end
	end
end

function var0_0.emit(arg0_17, ...)
	arg0_17.parent:emit(...)
end

function var0_0.clearStudents(arg0_18)
	if arg0_18.sortTimer then
		arg0_18.sortTimer:Stop()

		arg0_18.sortTimer = nil
	end

	for iter0_18, iter1_18 in pairs(arg0_18.academyStudents) do
		iter1_18:detach()
		Destroy(iter1_18._go)
	end

	arg0_18.academyStudents = {}
end

function var0_0.Dispose(arg0_19)
	arg0_19:clearStudents()
end

function var0_0.getStudents(arg0_20)
	local var0_20 = {}
	local var1_20 = {}
	local var2_20 = getProxy(TaskProxy)
	local var3_20 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)

	local function var4_20(arg0_21)
		local var0_21 = arg0_21:getConfig("config_client")
		local var1_21 = arg0_21:getConfig("config_data")
		local var2_21 = _.flatten(var1_21)
		local var3_21
		local var4_21

		if type(var0_21) == "table" then
			for iter0_21, iter1_21 in ipairs(var0_21) do
				var0_20[iter1_21.id] = Ship.New(iter1_21)

				if iter0_21 == 1 then
					var0_20[iter1_21.id].withShipFace = true

					local var5_21 = {}

					if iter1_21.type then
						var5_21.type = iter1_21.type
						var5_21.param = iter1_21.param
					end

					local var6_21, var7_21 = getActivityTask(arg0_21, true)

					var5_21.showTips = var6_21 and not var7_21 or var7_21 and var7_21:isFinish() and not var7_21:isReceive()
					var5_21.acceptTaskId = var6_21
					var5_21.currentTask = var7_21
					var1_20[iter1_21.id] = var5_21
					var3_21 = var5_21.acceptTaskId
					var4_21 = var5_21.currentTask
				end

				local var8_21 = iter1_21.tasks

				if var8_21 then
					var0_20[iter1_21.id].hide = true

					local var9_21 = var4_21 and table.indexof(var2_21, var4_21.id) or table.indexof(var2_21, var3_21)

					for iter2_21, iter3_21 in ipairs(var8_21) do
						if iter3_21 == var9_21 then
							var0_20[iter1_21.id].hide = false

							break
						end
					end
				end
			end
		end
	end

	_.each(var3_20, function(arg0_22)
		if not arg0_22:isEnd() then
			var4_20(arg0_22)
		end
	end)

	var0_20 = getProxy(NavalAcademyProxy):fillStudens(var0_20)

	return var0_20, var1_20
end

return var0_0
