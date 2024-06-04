local var0 = class("NavalAcademyShipsView")

function var0.Ctor(arg0, arg1)
	arg0.parent = arg1
	arg0.academyStudents = {}
	arg0._map = arg1:findTF("academyMap/map")
	arg0._shipTpl = arg0._map:Find("ship")
	arg0._fountain = arg0._map:Find("fountain")
	arg0.academyGraphPath = GraphPath.New(AcademyGraph)
end

function var0.BindBuildings(arg0, arg1)
	arg0.buildings = _.map(arg1, function(arg0)
		return arg0._tf
	end)
end

function var0.Refresh(arg0)
	local var0, var1 = arg0:getStudents()

	_.each(_.keys(arg0.academyStudents), function(arg0)
		local var0 = var0[arg0]
		local var1 = var1[arg0]
		local var2 = arg0.academyStudents[arg0]

		if var0 then
			var2:updateStudent(var0, var1)
		else
			var2:detach()
		end
	end)

	for iter0, iter1 in pairs(var0) do
		if not arg0.academyStudents[iter0] then
			local var2 = var1[iter0]
			local var3 = cloneTplTo(arg0._shipTpl, arg0._map)
			local var4 = NavalAcademyStudent.New(var3.gameObject)

			var4:attach()
			var4:setPathFinder(arg0.academyGraphPath)
			var4:setCallBack(function(arg0)
				arg0:onStateChange(iter1, arg0)
			end, function(arg0, arg1)
				arg0:onTask(iter1, var2)
			end)
			var4:updateStudent(iter1, var2)

			arg0.academyStudents[iter0] = var4
		end
	end

	arg0:sortStudents()
end

function var0.Init(arg0)
	arg0:Refresh()
end

function var0.onStateChange(arg0, arg1, arg2)
	if arg0.sortTimer then
		arg0.sortTimer:Stop()

		arg0.sortTimer = nil
	end

	if arg2 == NavalAcademyStudent.ShipState.Walk then
		arg0.sortTimer = Timer.New(function()
			arg0:sortStudents()
		end, 0.2, -1)

		arg0.sortTimer:Start()
	end
end

function var0.sortStudents(arg0)
	local var0 = {}

	table.insertto(var0, arg0.buildings)

	for iter0, iter1 in pairs(arg0.academyStudents) do
		table.insert(var0, iter1._tf)
	end

	table.sort(var0, function(arg0, arg1)
		return arg0.anchoredPosition.y > arg1.anchoredPosition.y
	end)

	local var1 = 0

	for iter2, iter3 in ipairs(var0) do
		iter3:SetSiblingIndex(var1)

		var1 = var1 + 1
	end
end

function var0.onTask(arg0, arg1, arg2)
	local var0 = getProxy(TaskProxy)
	local var1 = getProxy(ActivityProxy)
	local var2 = var1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var3 = _.detect(var2, function(arg0)
		local var0 = arg0:getTaskShip()

		return var0 and var0.groupId == arg1.groupId
	end)

	if var3 and not var3:isEnd() then
		if var3.id == ActivityConst.JYHZ_ACTIVITY_ID and arg2.acceptTaskId then
			local var4 = var0:getAcademyTask(arg1.groupId)
			local var5 = var1:getActivityByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

			if var5 then
				local var6 = var5:getConfig("config_data")
				local var7 = _.detect(var6, function(arg0)
					local var0 = pg.chapter_template[arg0]

					return _.any(var0.npc_data, function(arg0)
						return pg.npc_squad_template[arg0].task_id == var4
					end)
				end)

				if var7 and getProxy(ChapterProxy):getChapterById(var7).active then
					pg.TipsMgr.GetInstance():ShowTips(i18n("task_target_chapter_in_progress"))

					return
				end
			end
		end

		if arg2.type then
			if arg2.type == 1 then
				Application.OpenURL(arg2.param)
			elseif arg2.type == 2 then
				arg0:emit(NavalAcademyMediator.GO_SCENE, arg2.param)
			elseif arg2.type == 3 then
				arg0:emit(NavalAcademyMediator.OPEN_ACTIVITY_PANEL, tonumber(arg2.param))
			elseif arg2.type == 4 then
				arg0:emit(NavalAcademyMediator.OPEN_ACTIVITY_SHOP)
			elseif arg2.type == 5 then
				arg0:emit(NavalAcademyMediator.OPEN_SCROLL, tonumber(arg2.param))
			end
		elseif not arg2.currentTask and arg2.acceptTaskId then
			local var8 = getProxy(PlayerProxy):getRawData()
			local var9 = pg.task_data_template[arg2.acceptTaskId]

			if var8.level < var9.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("task_level_notenough", var9.level))

				return
			end

			arg0:emit(NavalAcademyMediator.ACTIVITY_OP, {
				cmd = 1,
				activity_id = var3.id,
				arg1 = arg2.acceptTaskId
			})
		elseif arg2.currentTask then
			if not arg2.currentTask:isFinish() and arg2.currentTask:getConfig("sub_type") == 29 then
				arg0:emit(NavalAcademyMediator.TASK_GO, {
					taskVO = arg2.currentTask
				})
			elseif not arg2.currentTask:isReceive() then
				arg0:emit(NavalAcademyMediator.GO_TASK_SCENE, {
					page = "activity"
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_work_done"))
		end
	end
end

function var0.emit(arg0, ...)
	arg0.parent:emit(...)
end

function var0.clearStudents(arg0)
	if arg0.sortTimer then
		arg0.sortTimer:Stop()

		arg0.sortTimer = nil
	end

	for iter0, iter1 in pairs(arg0.academyStudents) do
		iter1:detach()
		Destroy(iter1._go)
	end

	arg0.academyStudents = {}
end

function var0.Dispose(arg0)
	arg0:clearStudents()
end

function var0.getStudents(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = getProxy(TaskProxy)
	local var3 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)

	local function var4(arg0)
		local var0 = arg0:getConfig("config_client")
		local var1 = arg0:getConfig("config_data")
		local var2 = _.flatten(var1)
		local var3
		local var4

		if type(var0) == "table" then
			for iter0, iter1 in ipairs(var0) do
				var0[iter1.id] = Ship.New(iter1)

				if iter0 == 1 then
					var0[iter1.id].withShipFace = true

					local var5 = {}

					if iter1.type then
						var5.type = iter1.type
						var5.param = iter1.param
					end

					local var6, var7 = getActivityTask(arg0, true)

					var5.showTips = var6 and not var7 or var7 and var7:isFinish() and not var7:isReceive()
					var5.acceptTaskId = var6
					var5.currentTask = var7
					var1[iter1.id] = var5
					var3 = var5.acceptTaskId
					var4 = var5.currentTask
				end

				local var8 = iter1.tasks

				if var8 then
					var0[iter1.id].hide = true

					local var9 = var4 and table.indexof(var2, var4.id) or table.indexof(var2, var3)

					for iter2, iter3 in ipairs(var8) do
						if iter3 == var9 then
							var0[iter1.id].hide = false

							break
						end
					end
				end
			end
		end
	end

	_.each(var3, function(arg0)
		if not arg0:isEnd() then
			var4(arg0)
		end
	end)

	var0 = getProxy(NavalAcademyProxy):fillStudens(var0)

	return var0, var1
end

return var0
