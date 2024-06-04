local var0 = class("EducateSiteDetailPanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateSiteDetailUI"
end

function var0.OnInit(arg0)
	setActive(arg0._tf, false)

	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		setActive(arg0._tf, false)

		if arg0.contextData.onExit then
			arg0.contextData.onExit()
		end
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.closeBtn = arg0:findTF("close_btn", arg0.windowTF)
	arg0.nameTF = arg0:findTF("name_bg/name", arg0.windowTF)
	arg0.picTF = arg0:findTF("pic", arg0.windowTF)
	arg0.descTF = arg0:findTF("desc", arg0.windowTF)
	arg0.optionsTF = arg0:findTF("options/content", arg0.windowTF)
	arg0.optionTpl = arg0:findTF("option_tpl", arg0.windowTF)

	setText(arg0:findTF("limit/Text", arg0.optionTpl), i18n("child_option_limit"))
	setText(arg0:findTF("type_2/awards/polaroid/Text", arg0.optionTpl), i18n("child_random_polaroid_drop"))
	setActive(arg0.optionTpl, false)

	arg0.optionUIList = UIItemList.New(arg0.optionsTF, arg0.optionTpl)
	arg0.performTF = arg0:findTF("anim_root/perform")
	arg0.performName = arg0:findTF("name", arg0.performTF)

	arg0:addListener()
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER - 2
	})
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("anim_root/bg"), function()
		arg0:onClose()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:onClose()
	end, SFX_PANEL)
	arg0.optionUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateOptionItem(arg1, arg2)
		end
	end)

	arg0.optionIds = {}
end

function var0.checkSpecEvent(arg0, arg1, arg2)
	local var0 = getProxy(EducateProxy):GetEventProxy():GetSiteSpecEvents(arg1)

	if #var0 > 0 then
		arg0:emit(EducateMapMediator.ON_SPECIAL_EVENT_TRIGGER, {
			siteId = arg1,
			id = var0[1].id,
			callback = arg2
		})
	else
		arg2()
	end
end

function var0.showSpecEvent(arg0, arg1, arg2, arg3, arg4)
	local var0 = pg.child_event_special[arg2].performance
	local var1 = EducateHelper.GetDialogueShowDrops(arg3)
	local var2 = EducateHelper.GetCommonShowDrops(arg3)

	local function var3()
		if #var2 > 0 then
			arg0:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
				items = var2,
				removeFunc = function()
					arg0:checkSpecEvent(arg1, arg4)
				end
			})
		else
			arg0:checkSpecEvent(arg1, arg4)
		end

		setActive(arg0.performTF, false)
	end

	if #var0 > 0 then
		setActive(arg0.performTF, true)
		pg.PerformMgr.GetInstance():PlayGroup(var0, var3, var1)
	elseif var3 then
		var3()
	end
end

function var0.showSiteDetailById(arg0, arg1)
	if arg0.siteId == arg1 then
		return
	end

	arg0.siteId = arg1
	arg0.config = pg.child_site[arg0.siteId]

	arg0:checkSpecEvent(arg0.siteId, function()
		arg0:showDetailPanel()
	end)
end

function var0.addTaskProgress(arg0)
	local var0 = getProxy(EducateProxy):GetTaskProxy():GetSiteEnterAddTasks(arg0.siteId)
	local var1 = {}
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsMind() then
			table.insert(var1, {
				progress = 1,
				task_id = iter1.id
			})
		end

		if iter1:IsTarget() then
			table.insert(var2, {
				progress = 1,
				task_id = iter1.id
			})
		end

		if iter1:IsMain() then
			table.insert(var3, {
				progress = 1,
				task_id = iter1.id
			})
		end
	end

	if #var1 > 0 then
		arg0:emit(EducateMapMediator.ON_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_MIND,
			progresses = var1
		})
	end

	if #var2 > 0 then
		arg0:emit(EducateMapMediator.ON_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_TARGET,
			progresses = var2
		})
	end

	if #var3 > 0 then
		arg0:emit(EducateMapMediator.ON_ADD_TASK_PROGRESS, {
			system = EducateTask.STSTEM_TYPE_MAIN,
			progresses = var3
		})
	end
end

local function var1(arg0, arg1, arg2)
	if arg1[2] == -1 then
		LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", "res_-1", findTF(arg0, "Image"), true)
		setText(findTF(arg0, "Text"), i18n("child_random_ops_drop"))
	else
		local var0 = ""
		local var1 = ""

		if arg1[1] == EducateConst.DROP_TYPE_ATTR then
			var0 = "attr_"
			var1 = pg.child_attr[arg1[2]].name
		elseif arg1[1] == EducateConst.DROP_TYPE_RES then
			var0 = "res_"
			var1 = pg.child_resource[arg1[2]].name
		end

		LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", var0 .. arg1[2], findTF(arg0, "Image"), true)
		setText(findTF(arg0, "Text"), var1 .. "+" .. arg1[3])
	end
end

local function var2(arg0, arg1)
	local var0 = ""

	if arg1[1] == EducateConst.DROP_TYPE_ATTR then
		var0 = "attr_"
	elseif arg1[1] == EducateConst.DROP_TYPE_RES then
		var0 = "res_"
	end

	LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", var0 .. arg1[2], findTF(arg0, "Image"), true)
	setText(findTF(arg0, "Text"), "-" .. arg1[3])
end

function var0.updateOptionItem(arg0, arg1, arg2)
	GetOrAddComponent(arg2, "CanvasGroup").alpha = 1
	arg2.name = tostring(arg1 + 1)

	local var0 = arg0.optionVOs[arg1 + 1]

	setActive(arg0:findTF("limit", arg2), var0:IsShowLimit())

	local var1 = var0:GetType()

	for iter0 = 1, 3 do
		setActive(arg0:findTF("type_" .. iter0, arg2), iter0 == var1)
	end

	local var2 = arg0:findTF("type_" .. var1, arg2)
	local var3 = not var0:IsCountLimit() and true or var0:CanTrigger()

	setGray(arg2, not var3)
	switch(var1, {
		[EducateSiteOption.TYPE_SHOP] = function()
			setText(arg0:findTF("name/Text", var2), var0:getConfig("name"))
			onButton(arg0, arg2, function()
				arg0:emit(EducateMapMediator.ON_OPEN_SHOP, var0:GetLinkId())
			end, SFX_PANEL)
		end,
		[EducateSiteOption.TYPE_EVENT] = function()
			setText(arg0:findTF("name", var2), shortenString(var0:getConfig("name") .. var0:GetCntText(), 12))

			local var0 = var0:IsShowPolaroid()

			setActive(arg0:findTF("awards/polaroid", var2), var0)

			local var1 = var0 and 2 or 3
			local var2 = var0:GetResults()
			local var3 = UIItemList.New(arg0:findTF("awards/normal", var2), arg0:findTF("awards/normal/tpl", var2))

			var3:make(function(arg0, arg1, arg2)
				if arg0 == UIItemList.EventUpdate then
					var1(arg2, var2[arg1 + 1])
				end
			end)

			local var4 = var1 < #var2 and var1 or #var2

			var3:align(var4)

			local var5 = var0:GetCost()
			local var6 = UIItemList.New(arg0:findTF("costs", var2), arg0:findTF("costs/tpl", var2))

			var6:make(function(arg0, arg1, arg2)
				if arg0 == UIItemList.EventUpdate then
					var2(arg2, var5[arg1 + 1], "-")
				end
			end)
			var6:align(#var5)
			onButton(arg0, arg2, function()
				if not var3 then
					return
				end

				arg0:emit(EducateMapMediator.ON_MAP_SITE_OPERATE, {
					siteId = arg0.siteId,
					optionVO = var0
				})
			end, SFX_PANEL)
		end,
		[EducateSiteOption.TYPE_SITE] = function()
			setText(arg0:findTF("name/Text", var2), var0:getConfig("name"))
			onButton(arg0, arg2, function()
				local var0 = var0:GetLinkId()

				assert(pg.child_site[var0], "child_site不存在id:" .. var0)
				table.insert(arg0.siteQueue, var0)
				arg0:showSiteDetailById(var0)
			end, SFX_PANEL)
		end
	})
end

function var0.showDetailPanel(arg0)
	arg0:addTaskProgress()
	setActive(arg0.windowTF, true)
	setText(arg0.nameTF, arg0.config.name)
	setText(arg0.descTF, arg0.config.desc)
	LoadImageSpriteAsync("educatesite/" .. arg0.config.pic, arg0.picTF, true)

	arg0.optionVOs = getProxy(EducateProxy):GetOptionsBySiteId(arg0.siteId)

	arg0.optionUIList:align(#arg0.optionVOs)
end

function var0.showSitePerform(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = EducateHelper.GetDialogueShowDrops(arg4)
	local var1 = EducateHelper.GetDialogueShowDrops(arg5)
	local var2 = table.mergeArray(EducateHelper.GetCommonShowDrops(arg4), EducateHelper.GetCommonShowDrops(arg5))
	local var3 = {}
	local var4 = pg.child_site_option_branch[arg2].performance
	local var5 = pg.child_site_option[arg1].name

	table.insert(var3, function(arg0)
		pg.PerformMgr.GetInstance():PlayGroupNoHide(var4, arg0, var0, var5)
	end)

	if arg3 and #arg3 > 0 then
		for iter0, iter1 in ipairs(arg3) do
			local var6 = pg.child_event[iter1].performance

			table.insert(var3, function(arg0)
				pg.PerformMgr.GetInstance():PlayGroupNoHide(var6, arg0, var1)
			end)
		end
	end

	setText(arg0.performName, var5)
	setActive(arg0.performTF, true)
	pg.PerformMgr.GetInstance():Show()
	seriesAsync(var3, function()
		setActive(arg0.performTF, false)

		if #var2 > 0 then
			arg0:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
				items = var2
			})
		end

		pg.PerformMgr.GetInstance():Hide()
		arg0:showDetailPanel()
	end)
end

function var0.Hide(arg0)
	arg0.anim:Play("anim_educate_sitedatail_out")
end

function var0.Show(arg0, arg1)
	if not arg0:GetLoaded() then
		return
	end

	arg0.siteId = arg1
	arg0.config = pg.child_site[arg0.siteId]

	assert(arg0.config, "child_site不存在id:" .. arg0.siteId)
	setActive(arg0._tf, true)
	setActive(arg0.windowTF, false)

	arg0.siteQueue = {
		arg0.siteId
	}

	arg0:checkSpecEvent(arg0.siteId, function()
		arg0:showDetailPanel()

		if arg0.contextData.onEnter then
			arg0.contextData.onEnter()
		end
	end)
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_SITE, arg0.siteId)
end

function var0.onClose(arg0)
	if #arg0.siteQueue > 1 then
		table.remove(arg0.siteQueue, #arg0.siteQueue)
		arg0:showSiteDetailById(arg0.siteQueue[#arg0.siteQueue])
	else
		arg0:Hide()
	end
end

function var0.OnDestroy(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
