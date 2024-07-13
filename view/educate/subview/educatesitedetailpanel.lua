local var0_0 = class("EducateSiteDetailPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateSiteDetailUI"
end

function var0_0.OnInit(arg0_2)
	setActive(arg0_2._tf, false)

	arg0_2.anim = arg0_2:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		setActive(arg0_2._tf, false)

		if arg0_2.contextData.onExit then
			arg0_2.contextData.onExit()
		end
	end)

	arg0_2.windowTF = arg0_2:findTF("anim_root/window")
	arg0_2.closeBtn = arg0_2:findTF("close_btn", arg0_2.windowTF)
	arg0_2.nameTF = arg0_2:findTF("name_bg/name", arg0_2.windowTF)
	arg0_2.picTF = arg0_2:findTF("pic", arg0_2.windowTF)
	arg0_2.descTF = arg0_2:findTF("desc", arg0_2.windowTF)
	arg0_2.optionsTF = arg0_2:findTF("options/content", arg0_2.windowTF)
	arg0_2.optionTpl = arg0_2:findTF("option_tpl", arg0_2.windowTF)

	setText(arg0_2:findTF("limit/Text", arg0_2.optionTpl), i18n("child_option_limit"))
	setText(arg0_2:findTF("type_2/awards/polaroid/Text", arg0_2.optionTpl), i18n("child_random_polaroid_drop"))
	setActive(arg0_2.optionTpl, false)

	arg0_2.optionUIList = UIItemList.New(arg0_2.optionsTF, arg0_2.optionTpl)
	arg0_2.performTF = arg0_2:findTF("anim_root/perform")
	arg0_2.performName = arg0_2:findTF("name", arg0_2.performTF)

	arg0_2:addListener()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER - 2
	})
end

function var0_0.addListener(arg0_4)
	onButton(arg0_4, arg0_4:findTF("anim_root/bg"), function()
		arg0_4:onClose()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.closeBtn, function()
		arg0_4:onClose()
	end, SFX_PANEL)
	arg0_4.optionUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_4:updateOptionItem(arg1_7, arg2_7)
		end
	end)

	arg0_4.optionIds = {}
end

function var0_0.checkSpecEvent(arg0_8, arg1_8, arg2_8)
	local var0_8 = getProxy(EducateProxy):GetEventProxy():GetSiteSpecEvents(arg1_8)

	if #var0_8 > 0 then
		arg0_8:emit(EducateMapMediator.ON_SPECIAL_EVENT_TRIGGER, {
			siteId = arg1_8,
			id = var0_8[1].id,
			callback = arg2_8
		})
	else
		arg2_8()
	end
end

function var0_0.showSpecEvent(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = pg.child_event_special[arg2_9].performance
	local var1_9 = EducateHelper.GetDialogueShowDrops(arg3_9)
	local var2_9 = EducateHelper.GetCommonShowDrops(arg3_9)

	local function var3_9()
		if #var2_9 > 0 then
			arg0_9:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
				items = var2_9,
				removeFunc = function()
					arg0_9:checkSpecEvent(arg1_9, arg4_9)
				end
			})
		else
			arg0_9:checkSpecEvent(arg1_9, arg4_9)
		end

		setActive(arg0_9.performTF, false)
	end

	if #var0_9 > 0 then
		setActive(arg0_9.performTF, true)
		pg.PerformMgr.GetInstance():PlayGroup(var0_9, var3_9, var1_9)
	elseif var3_9 then
		var3_9()
	end
end

function var0_0.showSiteDetailById(arg0_12, arg1_12)
	if arg0_12.siteId == arg1_12 then
		return
	end

	arg0_12.siteId = arg1_12
	arg0_12.config = pg.child_site[arg0_12.siteId]

	arg0_12:checkSpecEvent(arg0_12.siteId, function()
		arg0_12:showDetailPanel()
	end)
end

function var0_0.addTaskProgress(arg0_14)
	local var0_14 = getProxy(EducateProxy):GetTaskProxy():GetSiteEnterAddTasks(arg0_14.siteId)
	local var1_14 = {}
	local var2_14 = {}
	local var3_14 = {}

	for iter0_14, iter1_14 in ipairs(var0_14) do
		if iter1_14:IsMind() then
			table.insert(var1_14, {
				progress = 1,
				task_id = iter1_14.id
			})
		end

		if iter1_14:IsTarget() then
			table.insert(var2_14, {
				progress = 1,
				task_id = iter1_14.id
			})
		end

		if iter1_14:IsMain() then
			table.insert(var3_14, {
				progress = 1,
				task_id = iter1_14.id
			})
		end
	end

	if #var1_14 > 0 then
		arg0_14:emit(EducateMapMediator.ON_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_MIND,
			progresses = var1_14
		})
	end

	if #var2_14 > 0 then
		arg0_14:emit(EducateMapMediator.ON_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_TARGET,
			progresses = var2_14
		})
	end

	if #var3_14 > 0 then
		arg0_14:emit(EducateMapMediator.ON_ADD_TASK_PROGRESS, {
			system = EducateTask.STSTEM_TYPE_MAIN,
			progresses = var3_14
		})
	end
end

local function var1_0(arg0_15, arg1_15, arg2_15)
	if arg1_15[2] == -1 then
		LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", "res_-1", findTF(arg0_15, "Image"), true)
		setText(findTF(arg0_15, "Text"), i18n("child_random_ops_drop"))
	else
		local var0_15 = ""
		local var1_15 = ""

		if arg1_15[1] == EducateConst.DROP_TYPE_ATTR then
			var0_15 = "attr_"
			var1_15 = pg.child_attr[arg1_15[2]].name
		elseif arg1_15[1] == EducateConst.DROP_TYPE_RES then
			var0_15 = "res_"
			var1_15 = pg.child_resource[arg1_15[2]].name
		end

		LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", var0_15 .. arg1_15[2], findTF(arg0_15, "Image"), true)
		setText(findTF(arg0_15, "Text"), var1_15 .. "+" .. arg1_15[3])
	end
end

local function var2_0(arg0_16, arg1_16)
	local var0_16 = ""

	if arg1_16[1] == EducateConst.DROP_TYPE_ATTR then
		var0_16 = "attr_"
	elseif arg1_16[1] == EducateConst.DROP_TYPE_RES then
		var0_16 = "res_"
	end

	LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", var0_16 .. arg1_16[2], findTF(arg0_16, "Image"), true)
	setText(findTF(arg0_16, "Text"), "-" .. arg1_16[3])
end

function var0_0.updateOptionItem(arg0_17, arg1_17, arg2_17)
	GetOrAddComponent(arg2_17, "CanvasGroup").alpha = 1
	arg2_17.name = tostring(arg1_17 + 1)

	local var0_17 = arg0_17.optionVOs[arg1_17 + 1]

	setActive(arg0_17:findTF("limit", arg2_17), var0_17:IsShowLimit())

	local var1_17 = var0_17:GetType()

	for iter0_17 = 1, 3 do
		setActive(arg0_17:findTF("type_" .. iter0_17, arg2_17), iter0_17 == var1_17)
	end

	local var2_17 = arg0_17:findTF("type_" .. var1_17, arg2_17)
	local var3_17 = not var0_17:IsCountLimit() and true or var0_17:CanTrigger()

	setGray(arg2_17, not var3_17)
	switch(var1_17, {
		[EducateSiteOption.TYPE_SHOP] = function()
			setText(arg0_17:findTF("name/Text", var2_17), var0_17:getConfig("name"))
			onButton(arg0_17, arg2_17, function()
				arg0_17:emit(EducateMapMediator.ON_OPEN_SHOP, var0_17:GetLinkId())
			end, SFX_PANEL)
		end,
		[EducateSiteOption.TYPE_EVENT] = function()
			setText(arg0_17:findTF("name", var2_17), shortenString(var0_17:getConfig("name") .. var0_17:GetCntText(), 12))

			local var0_20 = var0_17:IsShowPolaroid()

			setActive(arg0_17:findTF("awards/polaroid", var2_17), var0_20)

			local var1_20 = var0_20 and 2 or 3
			local var2_20 = var0_17:GetResults()
			local var3_20 = UIItemList.New(arg0_17:findTF("awards/normal", var2_17), arg0_17:findTF("awards/normal/tpl", var2_17))

			var3_20:make(function(arg0_21, arg1_21, arg2_21)
				if arg0_21 == UIItemList.EventUpdate then
					var1_0(arg2_21, var2_20[arg1_21 + 1])
				end
			end)

			local var4_20 = var1_20 < #var2_20 and var1_20 or #var2_20

			var3_20:align(var4_20)

			local var5_20 = var0_17:GetCost()
			local var6_20 = UIItemList.New(arg0_17:findTF("costs", var2_17), arg0_17:findTF("costs/tpl", var2_17))

			var6_20:make(function(arg0_22, arg1_22, arg2_22)
				if arg0_22 == UIItemList.EventUpdate then
					var2_0(arg2_22, var5_20[arg1_22 + 1], "-")
				end
			end)
			var6_20:align(#var5_20)
			onButton(arg0_17, arg2_17, function()
				if not var3_17 then
					return
				end

				arg0_17:emit(EducateMapMediator.ON_MAP_SITE_OPERATE, {
					siteId = arg0_17.siteId,
					optionVO = var0_17
				})
			end, SFX_PANEL)
		end,
		[EducateSiteOption.TYPE_SITE] = function()
			setText(arg0_17:findTF("name/Text", var2_17), var0_17:getConfig("name"))
			onButton(arg0_17, arg2_17, function()
				local var0_25 = var0_17:GetLinkId()

				assert(pg.child_site[var0_25], "child_site不存在id:" .. var0_25)
				table.insert(arg0_17.siteQueue, var0_25)
				arg0_17:showSiteDetailById(var0_25)
			end, SFX_PANEL)
		end
	})
end

function var0_0.showDetailPanel(arg0_26)
	arg0_26:addTaskProgress()
	setActive(arg0_26.windowTF, true)
	setText(arg0_26.nameTF, arg0_26.config.name)
	setText(arg0_26.descTF, arg0_26.config.desc)
	LoadImageSpriteAsync("educatesite/" .. arg0_26.config.pic, arg0_26.picTF, true)

	arg0_26.optionVOs = getProxy(EducateProxy):GetOptionsBySiteId(arg0_26.siteId)

	arg0_26.optionUIList:align(#arg0_26.optionVOs)
end

function var0_0.showSitePerform(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27)
	local var0_27 = EducateHelper.GetDialogueShowDrops(arg4_27)
	local var1_27 = EducateHelper.GetDialogueShowDrops(arg5_27)
	local var2_27 = table.mergeArray(EducateHelper.GetCommonShowDrops(arg4_27), EducateHelper.GetCommonShowDrops(arg5_27))
	local var3_27 = {}
	local var4_27 = pg.child_site_option_branch[arg2_27].performance
	local var5_27 = pg.child_site_option[arg1_27].name

	table.insert(var3_27, function(arg0_28)
		pg.PerformMgr.GetInstance():PlayGroupNoHide(var4_27, arg0_28, var0_27, var5_27)
	end)

	if arg3_27 and #arg3_27 > 0 then
		for iter0_27, iter1_27 in ipairs(arg3_27) do
			local var6_27 = pg.child_event[iter1_27].performance

			table.insert(var3_27, function(arg0_29)
				pg.PerformMgr.GetInstance():PlayGroupNoHide(var6_27, arg0_29, var1_27)
			end)
		end
	end

	setText(arg0_27.performName, var5_27)
	setActive(arg0_27.performTF, true)
	pg.PerformMgr.GetInstance():Show()
	seriesAsync(var3_27, function()
		setActive(arg0_27.performTF, false)

		if #var2_27 > 0 then
			arg0_27:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
				items = var2_27
			})
		end

		pg.PerformMgr.GetInstance():Hide()
		arg0_27:showDetailPanel()
	end)
end

function var0_0.Hide(arg0_31)
	arg0_31.anim:Play("anim_educate_sitedatail_out")
end

function var0_0.Show(arg0_32, arg1_32)
	if not arg0_32:GetLoaded() then
		return
	end

	arg0_32.siteId = arg1_32
	arg0_32.config = pg.child_site[arg0_32.siteId]

	assert(arg0_32.config, "child_site不存在id:" .. arg0_32.siteId)
	setActive(arg0_32._tf, true)
	setActive(arg0_32.windowTF, false)

	arg0_32.siteQueue = {
		arg0_32.siteId
	}

	arg0_32:checkSpecEvent(arg0_32.siteId, function()
		arg0_32:showDetailPanel()

		if arg0_32.contextData.onEnter then
			arg0_32.contextData.onEnter()
		end
	end)
	EducateTipHelper.ClearNewTip(EducateTipHelper.NEW_SITE, arg0_32.siteId)
end

function var0_0.onClose(arg0_34)
	if #arg0_34.siteQueue > 1 then
		table.remove(arg0_34.siteQueue, #arg0_34.siteQueue)
		arg0_34:showSiteDetailById(arg0_34.siteQueue[#arg0_34.siteQueue])
	else
		arg0_34:Hide()
	end
end

function var0_0.OnDestroy(arg0_35)
	arg0_35.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_35._tf)
end

return var0_0
