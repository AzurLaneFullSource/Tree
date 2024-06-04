local var0 = class("BackHillTemplate", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return arg0.UIName
end

function var0.init(arg0)
	arg0.loader = AutoLoader.New()
end

function var0.willExit(arg0)
	arg0.loader:Clear()
end

function var0.InitFacility(arg0, arg1, arg2)
	onButton(arg0, arg1, arg2)
	onButton(arg0, arg1:Find("button"), arg2)
end

function var0.InitFacilityCross(arg0, arg1, arg2, arg3, arg4)
	onButton(arg0, arg1:Find(arg3), arg4, SFX_PANEL)
	onButton(arg0, arg2:Find(arg3), arg4, SFX_PANEL)
end

function var0.getStudents(arg0, arg1, arg2)
	local var0 = {}
	local var1 = getProxy(ActivityProxy):getActivityById(arg0)

	if not var1 then
		return var0
	end

	local var2 = var1:getConfig("config_client")

	var2 = var2 and var2.ships

	if var2 then
		local var3 = Clone(var2)
		local var4 = math.random(arg1, arg2)
		local var5 = #var3

		while var4 > 0 and var5 > 0 do
			local var6 = math.random(1, var5)

			table.insert(var0, var3[var6])

			var3[var6] = var3[var5]
			var5 = var5 - 1
			var4 = var4 - 1
		end
	end

	return var0
end

function var0.InitStudents(arg0, arg1, arg2, arg3)
	local var0 = var0.getStudents(arg1, arg2, arg3)
	local var1 = {}

	for iter0, iter1 in pairs(arg0.graphPath.points) do
		if not iter1.outRandom then
			table.insert(var1, iter1)
		end
	end

	local var2 = #var1

	arg0.academyStudents = {}

	local var3 = {}

	for iter2, iter3 in pairs(var0) do
		if not arg0.academyStudents[iter2] then
			local var4 = cloneTplTo(arg0._shipTpl, arg0._map)

			var4.gameObject.name = iter2

			local var5 = arg0.ChooseRandomPos(var1, var2)

			var2 = (var2 - 2) % #var1 + 1

			local var6 = SummerFeastNavigationAgent.New(var4.gameObject)

			var6:attach()
			var6:setPathFinder(arg0.graphPath)
			var6:SetPositionTable(var3)
			var6:setCurrentIndex(var5 and var5.id)
			var6:SetOnTransEdge(function(arg0, arg1, arg2)
				arg1, arg2 = math.min(arg1, arg2), math.max(arg1, arg2)

				local var0 = arg0[arg0.edge2area[arg1 .. "_" .. arg2] or arg0.edge2area.default]

				arg0._tf:SetParent(var0)
			end)
			var6:updateStudent(iter3)

			arg0.academyStudents[iter2] = var6
		end
	end

	if #var0 > 0 then
		arg0.sortTimer = Timer.New(function()
			arg0:sortStudents()
		end, 0.2, -1)

		arg0.sortTimer:Start()
		arg0.sortTimer.func()
	end
end

function var0.ChooseRandomPos(arg0, arg1)
	local var0 = math.random(1, arg1)

	if not var0 then
		return nil
	end

	pg.Tool.Swap(arg0, var0, arg1)

	return arg0[arg1]
end

function var0.sortStudents(arg0)
	local var0 = arg0.containers

	for iter0, iter1 in pairs(var0) do
		if iter1.childCount > 1 then
			local var1 = {}

			for iter2 = 1, iter1.childCount do
				local var2 = iter1:GetChild(iter2 - 1)

				table.insert(var1, {
					tf = var2,
					index = iter2
				})
			end

			table.sort(var1, function(arg0, arg1)
				local var0 = arg0.tf.anchoredPosition.y - arg1.tf.anchoredPosition.y

				if math.abs(var0) < 1 then
					return arg0.index < arg1.index
				else
					return var0 > 0
				end
			end)

			for iter3, iter4 in ipairs(var1) do
				iter4.tf:SetSiblingIndex(iter3 - 1)
			end
		end
	end
end

function var0.clearStudents(arg0)
	if arg0.sortTimer then
		arg0.sortTimer:Stop()

		arg0.sortTimer = nil
	end

	if arg0.academyStudents then
		for iter0, iter1 in pairs(arg0.academyStudents) do
			iter1:detach()
			Destroy(iter1._go)
		end

		table.clear(arg0.academyStudents)
	end
end

function var0.AutoFitScreen(arg0)
	local var0 = Screen.width / Screen.height
	local var1 = 1.77777777777778
	local var2 = arg0._map.rect.width
	local var3 = arg0._map.rect.height
	local var4

	if var1 <= var0 then
		local var5 = 1080 * var0

		var4 = math.clamp(var5 / var2, 1, 2)
	else
		local var6 = 1920 / var0

		var4 = math.clamp(var6 / var3, 1, 2)
	end

	setLocalScale(arg0._map, {
		x = var4,
		y = var4,
		z = var4
	})
	setLocalScale(arg0._upper, {
		x = var4,
		y = var4,
		z = var4
	})
end

function var0.IsMiniActNeedTip(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0)

	assert(var0)

	return Activity.IsActivityReady(var0)
end

function var0.UpdateActivity(arg0, arg1)
	return
end

function var0.BindItemActivityShop(arg0)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "bujishangdian", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
end

function var0.BindItemSkinShop(arg0)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "huanzhuangshangdian", function()
		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SKINSHOP)
	end)
end

function var0.BindItemBuildShip(arg0)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xianshijianzao", function()
		local var0
		local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1)
		local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

		if var1 and not var1:isEnd() then
			var0 = BuildShipScene.PROJECTS.ACTIVITY
		elseif var2 and not var2:isEnd() then
			var0 = ({
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY
			})[var2:getConfig("config_client").id]
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = var0
		})
	end)
end

function var0.BindItemBattle(arg0)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "tebiezuozhan", function()
		local var0 = getProxy(ChapterProxy)
		local var1, var2 = var0:getLastMapForActivity()

		if not var1 or not var0:getMapById(var1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2,
				mapIdx = var1
			})
		end
	end)
end

function var0.UpdateBuildingTip(arg0, arg1, arg2)
	if not arg1 then
		return false
	end

	local var0 = arg1:GetBuildingLevel(arg2)
	local var1 = pg.activity_event_building[arg2]

	if not var1 or var0 >= #var1.buff then
		return false
	end

	local var2 = var1.material[var0]

	return _.all(var2, function(arg0)
		local var0 = arg0[1]
		local var1 = arg0[2]
		local var2 = arg0[3]
		local var3 = 0

		if var0 == DROP_TYPE_VITEM then
			local var4 = AcessWithinNull(Item.getConfigData(var1), "link_id")

			assert(var4 == arg1.id)

			var3 = arg1:GetMaterialCount(var1)
		elseif var0 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var5 = AcessWithinNull(pg.activity_drop_type[var0], "activity_id")

			assert(var5)

			bagAct = getProxy(ActivityProxy):getActivityById(var5)
			var3 = bagAct:getVitemNumber(var1)
		end

		return var2 <= var3
	end)
end

function var0.UpdateView(arg0)
	return
end

return var0
