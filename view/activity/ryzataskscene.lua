local var0 = class("RyzaTaskScene", import("..base.BaseUI"))
local var1 = "ryza_task_level_desc"
local var2 = "ryza_task_tag_explore"
local var3 = "ryza_task_tag_battle"
local var4 = "ryza_task_tag_dalegate"
local var5 = "ryza_task_tag_develop"
local var6 = {
	var2,
	var3,
	var4,
	var5
}
local var7 = "ryza_task_detail_content"
local var8 = "ryza_task_detail_award"
local var9 = "ryza_task_go"
local var10 = "ryza_task_get"
local var11 = "ryza_task_detail"
local var12 = "ryza_task_submit"
local var13 = "ryza_task_get_all"
local var14 = "ryza_task_confirm"
local var15 = "ryza_task_cancel"
local var16 = "ryza_task_level_num"
local var17 = "ryza_task_level_add"
local var18 = "ryza_task_empty_tag"
local var19 = "sub_item_warning"
local var20 = "ui/ryzaicon_atlas"

function var0.getUIName(arg0)
	return "RyzaTaskUI"
end

local var21 = 4
local var22 = 5
local var23 = 4

function var0.init(arg0)
	arg0.activityId = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_RYZA).id
	arg0.enterTaskId = arg0.contextData.task_id or nil
	arg0.taskGroups = pg.activity_template[arg0.activityId].config_data
	arg0.leanTweens = {}
	arg0.exitFlag = false

	local var0 = pg.activity_template[arg0.activityId].config_client

	arg0.ptName = pg.player_resource[var0.pt_id].name
	arg0.ptBuffs = var0.pt_buff
	arg0.maxNum = arg0.ptBuffs[#arg0.ptBuffs].pt[1]

	local var1 = findTF(arg0._tf, "ad")

	arg0.btnBack = findTF(var1, "btnBack")
	arg0.btnMain = findTF(var1, "btnMain")
	arg0.btnHelp = findTF(var1, "btnHelp")
	arg0.btnGetAll = findTF(var1, "btnGetAll")
	arg0.btnPoint = findTF(var1, "btnPoint")
	arg0.imgPoint = findTF(var1, "btnPoint/imgPoint")
	arg0.taskTagPanel = findTF(var1, "taskTagPanel")
	arg0.taskListPanel = findTF(var1, "taskListPanel")
	arg0.scrollRect = findTF(var1, "taskListPanel/Content"):GetComponent("LScrollRect")
	arg0.taskDetailPanel = findTF(var1, "taskDetailPanel")
	arg0.detailTag = findTF(arg0.taskDetailPanel, "tag")
	arg0.detailTitleText = findTF(arg0.taskDetailPanel, "title/text")
	arg0.detailIcon = findTF(arg0.taskDetailPanel, "icon/image")
	arg0.detailDescText = findTF(arg0.taskDetailPanel, "desc/text")
	arg0.detaiProgressText = findTF(arg0.taskDetailPanel, "progress/text")
	arg0.detailAwardContent = findTF(arg0.taskDetailPanel, "awardDisplay/viewport/content")
	arg0.detailBtnGo = findTF(arg0.taskDetailPanel, "btnGo")
	arg0.detailBtnGet = findTF(arg0.taskDetailPanel, "btnGet")
	arg0.detailBtnSubmit = findTF(arg0.taskDetailPanel, "btnSubmit")
	arg0.detailBtnDetail = findTF(arg0.taskDetailPanel, "btnDetail")
	arg0.detailActive = findTF(arg0.taskDetailPanel, "active")
	arg0.taskItemTpl = findTF(var1, "tpl/taskItemTpl")
	arg0.IconTpl = findTF(var1, "tpl/IconTpl")

	local var2 = findTF(arg0._tf, "pop")

	arg0.pointPanel = findTF(var2, "pointPanel")

	setActive(arg0.pointPanel, false)

	arg0.pointProgressText = findTF(arg0.pointPanel, "progressContent/progress")
	arg0.pointProgressSlider = findTF(arg0.pointPanel, "slider")
	arg0.pointLevelStar = findTF(arg0.pointPanel, "levelStar")
	arg0.pointStarTpl = findTF(arg0.pointPanel, "levelStar/starTpl")
	arg0.pointAdd = findTF(arg0.pointPanel, "add")
	arg0.pointClose = findTF(arg0.pointPanel, "btnClose")
	arg0.pointMask = findTF(arg0.pointPanel, "mask")
	arg0.submitPanel = findTF(var2, "submitPanel")
	arg0.submitDisplayContent = findTF(arg0.submitPanel, "itemDisplay/viewport/content")
	arg0.submitConfirm = findTF(arg0.submitPanel, "btnComfirm")
	arg0.submitCancel = findTF(arg0.submitPanel, "btnCancel")
	arg0.subimtItem = findTF(arg0.submitPanel, "itemDisplay/viewport/content/item")
	arg0.submitItemDesc = findTF(arg0.submitPanel, "itemDesc")
	arg0.btnCancel = findTF(arg0.submitPanel, "btnCancel")

	setText(findTF(arg0.btnPoint, "text"), i18n(var1))

	for iter0 = 1, var21 do
		local var3 = findTF(arg0.taskTagPanel, "btn" .. iter0)

		setText(findTF(var3, "off/text"), i18n(var6[iter0]))
		setText(findTF(var3, "on/text"), i18n(var6[iter0]))
	end

	setText(findTF(arg0.taskDetailPanel, "desc/title"), i18n(var7))
	setText(findTF(arg0.taskDetailPanel, "awardText"), i18n(var8))
	setText(findTF(arg0.taskDetailPanel, "btnGet/text"), i18n(var10))
	setText(findTF(arg0.taskDetailPanel, "btnGo/text"), i18n(var9))
	setText(findTF(arg0.taskDetailPanel, "btnSubmit/text"), i18n(var12))
	setText(findTF(arg0.taskDetailPanel, "btnDetail/text"), i18n(var11))
	setText(findTF(arg0.btnGetAll, "text"), i18n(var13))
	setText(findTF(arg0.submitPanel, "btnComfirm/text"), i18n(var14))
	setText(findTF(arg0.submitPanel, "btnCancel/text"), i18n(var15))
	setText(findTF(arg0.submitPanel, "bg/text"), i18n(var19))
	setText(findTF(arg0.pointPanel, "title"), i18n(var1))
	setText(findTF(arg0.pointPanel, "levelNum/text"), i18n(var16))
	setText(findTF(arg0.pointPanel, "levelBuff/text"), i18n(var17))

	arg0.pointStarTfs = {}

	local var4 = arg0.pointLevelStar.sizeDelta.x

	for iter1 = 1, #arg0.ptBuffs do
		local var5 = tf(Instantiate(arg0.pointStarTpl))

		SetParent(var5, arg0.pointLevelStar)
		setActive(var5, true)
		setText(findTF(var5, "bg/text"), iter1)
		setText(findTF(var5, "img/text"), iter1)

		local var6 = arg0.ptBuffs[iter1].pt[1]

		var5.anchoredPosition = Vector3(var6 / arg0.maxNum * var4, -18, 0)

		table.insert(arg0.pointStarTfs, var5)

		if iter1 == 1 then
			setActive(var5, false)
		end
	end

	arg0:updateTask()
end

function var0.updateTask(arg0, arg1)
	arg0.displayTask = {}
	arg0.allDisplayTask = {}

	local var0 = getProxy(ActivityTaskProxy):getTaskById(arg0.activityId)

	arg0.getAllTasks = {}

	for iter0 = 1, #var0 do
		local var1 = var0[iter0]
		local var2 = var1.id
		local var3 = var1:getProgress()
		local var4 = var1:getTarget()
		local var5 = var1:getConfig("ryza_type")
		local var6 = var1:getConfig("type")
		local var7 = var1:getConfig("sub_type")

		if var5 > 0 then
			if not arg0.displayTask[var5] then
				arg0.displayTask[var5] = {}
			end

			table.insert(arg0.displayTask[var5], var1)
			table.insert(arg0.allDisplayTask, var1)

			if not var1:isFinish() or var1:isOver() or var7 == 1006 then
				-- block empty
			else
				table.insert(arg0.getAllTasks, var2)
			end
		end
	end

	local var8 = getProxy(ActivityProxy):getActivityById(arg0.activityId)
	local var9 = {}

	if var8 then
		var9 = var8.data1_list
	end

	if var9 and #var9 > 0 then
		for iter1 = 1, #var9 do
			local var10 = var9[iter1]
			local var11 = ActivityTask.New(arg0.activityId, {
				progress = 0,
				id = var10
			})

			var11:setOver()

			local var12 = var11:getConfig("ryza_type")

			if var12 > 0 then
				if not arg0.displayTask[var12] then
					arg0.displayTask[var12] = {}
				end

				table.insert(arg0.displayTask[var12], var11)
				table.insert(arg0.allDisplayTask, var11)
			end
		end
	end

	local function var13(arg0, arg1)
		if arg0:isOver() and not arg1:isOver() then
			return false
		elseif not arg0:isOver() and arg1:isOver() then
			return true
		end

		if arg0:isFinish() and not arg1:isFinish() then
			return true
		elseif not arg0:isFinish() and arg1:isFinish() then
			return false
		end

		if arg0:isNew() and not arg1:isNew() then
			return true
		elseif not arg0:isNew() and arg1:isNew() then
			return false
		end

		if arg0.id > arg1.id then
			return false
		elseif arg0.id < arg1.id then
			return true
		end
	end

	for iter2, iter3 in pairs(arg0.displayTask) do
		table.sort(iter3, var13)
	end

	table.sort(arg0.allDisplayTask, var13)

	if arg1 then
		arg0:onClickTag()
	end

	if #arg0.getAllTasks > 0 then
		setActive(arg0.btnGetAll, true)
	else
		setActive(arg0.btnGetAll, false)
	end

	local var14 = getProxy(PlayerProxy):getData()[arg0.ptName] or 0
	local var15 = 1

	if var14 > arg0.maxNum then
		var14 = arg0.maxNum
	end

	for iter4 = #arg0.ptBuffs, 1, -1 do
		var15 = var14 >= arg0.ptBuffs[iter4].pt[1] and var15 < iter4 and iter4 or var15
	end

	for iter5 = 1, #arg0.pointStarTfs do
		local var16 = arg0.pointStarTfs[iter5]

		if iter5 <= var15 then
			setActive(findTF(var16, "img"), true)
		else
			setActive(findTF(var16, "img"), false)
		end
	end

	local var17 = arg0.ptBuffs[var15].benefit

	for iter6 = 1, #var17 do
		local var18 = var17[iter6]
		local var19 = pg.benefit_buff_template[var18].desc
		local var20 = findTF(arg0.pointPanel, "add/" .. iter6)

		if PLATFORM_CODE == PLATFORM_JP then
			findTF(var20, "img").sizeDelta = Vector2(450, 70)

			setText(findTF(var20, "text_jp"), var19)
		else
			setText(findTF(var20, "text"), var19)
		end
	end

	setSlider(arg0.pointProgressSlider, 0, arg0.maxNum, var14)
	setText(arg0.pointProgressText, var14 .. "/" .. arg0.maxNum)
	setText(findTF(arg0.btnPoint, "text"), i18n(var1) .. "Lv." .. var15)
	setText(findTF(arg0.pointPanel, "levelNum/num"), "Lv." .. var15)
	setText(findTF(arg0.pointPanel, "levelBuff/num"), "Lv." .. var15)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0, arg0.btnGetAll, function()
		local var0 = arg0.getAllTasks

		arg0:emit(RyzaTaskMediator.SUBMIT_TASK_ALL, {
			activityId = arg0.activityId,
			ids = var0
		})
	end, SOUND_BACK)
	onButton(arg0, arg0.btnPoint, function()
		if isActive(arg0.pointPanel) then
			setActive(arg0.pointPanel, false)
		else
			setActive(arg0.pointPanel, true)
		end
	end, SOUND_BACK)
	onButton(arg0, arg0.btnMain, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SOUND_BACK)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_task_help_tip")
		})
	end, SOUND_BACK)
	onButton(arg0, arg0.detailBtnGo, function()
		local var0 = Task.New(arg0.selectTask)

		arg0:emit(RyzaTaskMediator.TASK_GO, {
			taskVO = var0
		})
	end, SOUND_BACK)
	onButton(arg0, arg0.pointMask, function()
		setActive(arg0.pointPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.pointClose, function()
		setActive(arg0.pointPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.detailBtnSubmit, function()
		local var0 = arg0.selectTask:getConfig("type")

		if arg0.selectTask:getConfig("sub_type") == 1006 then
			arg0:openSubmitPanel(arg0.selectTask)
		else
			arg0:emit(RyzaTaskMediator.SUBMIT_TASK, {
				activityId = arg0.activityId,
				id = arg0.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0, arg0.detailBtnGet, function()
		local var0 = arg0.selectTask:getConfig("type")

		if arg0.selectTask:getConfig("sub_type") == 1006 then
			arg0:openSubmitPanel(arg0.selectTask)
		else
			arg0:emit(RyzaTaskMediator.SUBMIT_TASK, {
				activityId = arg0.activityId,
				id = arg0.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0, arg0.detailBtnDetail, function()
		if arg0.selectTask then
			local var0 = tonumber(arg0.selectTask:getConfig("target_id_2"))

			if var0 and var0 > 0 then
				local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)
				local var2 = AtelierMaterial.New({
					configId = var0,
					count = arg0.selectTask:getConfig("target_num")
				})

				arg0:emit(RyzaTaskMediator.SHOW_DETAIL, var2)
			end
		end
	end, SOUND_BACK)
	onButton(arg0, arg0.submitConfirm, function()
		arg0:emit(RyzaTaskMediator.SUBMIT_TASK, {
			activityId = arg0.activityId,
			id = arg0.selectTask.id
		})
		setActive(arg0.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.submitCancel, function()
		setActive(arg0.submitPanel, false)
	end, SOUND_BACK)

	arg0.btnTags = {}

	for iter0 = 1, var21 do
		local var0 = iter0
		local var1 = findTF(arg0.taskTagPanel, "btn" .. var0)

		onButton(arg0, var1, function()
			if arg0.showTagIndex then
				setActive(findTF(arg0.btnTags[arg0.showTagIndex], "on"), false)

				if arg0.showTagIndex == var0 then
					arg0.showTagIndex = nil
				else
					arg0.showTagIndex = var0

					setActive(findTF(arg0.btnTags[arg0.showTagIndex], "on"), true)
				end
			else
				arg0.showTagIndex = var0

				setActive(findTF(arg0.btnTags[arg0.showTagIndex], "on"), true)
			end

			arg0:onClickTag()
		end)
		table.insert(arg0.btnTags, var1)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateTaskItem(arg0, arg1)
	end

	arg0.iconTfs = {}
	arg0.awards = {}

	arg0:onClickTag()

	local var2 = false

	if PlayerPrefs.GetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id) ~= 1 then
		var2 = true
	end

	if var2 then
		PlayerPrefs.SetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id, 1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_task_help_tip")
		})
	end
end

function var0.onClickTag(arg0)
	print("点击了Tag")

	local var0 = arg0.showTagIndex

	if var0 and var0 > 0 then
		if arg0.displayTask[var0] and #arg0.displayTask[var0] > 0 then
			arg0.showTasks = arg0.displayTask[var0]
		else
			triggerButton(arg0.btnTags[arg0.showTagIndex])

			return
		end
	else
		arg0.showTasks = arg0.allDisplayTask
	end

	if arg0.enterTaskId and arg0.enterTaskId > 0 then
		for iter0 = 1, #arg0.showTasks do
			if arg0.showTasks[iter0].id == arg0.enterTaskId then
				arg0.scrollIndex = iter0
			end
		end
	end

	arg0.scrollRect:SetTotalCount(#arg0.showTasks, 0)

	if arg0.scrollIndex ~= nil then
		local var1 = arg0.scrollRect:HeadIndexToValue(arg0.scrollIndex - 1)

		arg0.scrollRect:ScrollTo(var1)
	end
end

function var0.onUpdateTaskItem(arg0, arg1, arg2)
	if arg0.exitFlag then
		return
	end

	arg0.leanTweens[arg2] = arg2

	table.insert(arg0.leanTweens, arg2)

	local var0 = GetComponent(arg2, typeof(CanvasGroup))

	var0.alpha = 0

	LeanTween.value(arg2, 0, 1, 0.3):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.leanTweens[arg2] = nil
	end))

	arg1 = arg1 + 1

	local var1 = arg0.showTasks[arg1]
	local var2 = var1.id
	local var3 = var1:getProgress()
	local var4 = var1:getConfig("name")
	local var5 = var1:getConfig("ryza_icon")
	local var6 = var1:isOver()
	local var7 = var1:isFinish()
	local var8 = var1:isCircle()

	setActive(findTF(arg2, "selected"), arg0.selectIndex == arg1)
	setActive(findTF(arg2, "typeNew"), var1:isNew())
	setActive(findTF(arg2, "typeCircle"), var1:isCircle())
	setActive(findTF(arg2, "finish"), var6)
	setActive(findTF(arg2, "mask"), var6)
	setActive(findTF(arg2, "complete"), not var6 and var7 and not var8)
	setText(findTF(arg2, "desc/text"), shortenString(var4, 10))

	if not var5 or var5 == 0 then
		var5 = "attack"
	end

	setImageSprite(findTF(arg2, "icon/image"), LoadSprite(var20, var5))
	onButton(arg0, tf(arg2), function()
		if arg0.selectItem then
			setActive(findTF(arg0.selectItem, "selected"), false)
		end

		setActive(findTF(arg2, "selected"), true)

		arg0.selectIndex = arg1
		arg0.selectItem = arg2
		arg0.selectTask = var1

		arg0:updateDetail()
	end)

	if arg0.enterTaskId ~= nil and arg0.enterTaskId > 0 then
		if var2 == arg0.enterTaskId then
			triggerButton(arg2)

			arg0.enterTaskId = nil
			arg0.scrollIndex = nil
		end
	elseif arg1 == 1 then
		triggerButton(arg2)

		arg0.scrollIndex = nil
	end
end

function var0.updateDetail(arg0)
	local var0 = arg0.showTasks[arg0.selectIndex]
	local var1 = var0.id
	local var2 = var0:getProgress()
	local var3 = var0.target
	local var4 = pg.task_data_template[var1]
	local var5 = var0:isFinish()
	local var6 = var0:isOver()
	local var7 = var0:isCircle()
	local var8 = var0:isSubmit()

	arg0.awards = var4.award_display

	local var9 = var4.desc
	local var10 = var4.ryza_icon
	local var11 = var0:getConfig("sub_type")

	if not var10 or var10 == 0 then
		var10 = "attack"
	end

	if not var8 and var3 < var2 then
		var2 = var3
	end

	setText(arg0.detailDescText, var9)

	if not var6 then
		setText(arg0.detaiProgressText, var2 .. "/" .. var3)
	else
		setText(arg0.detaiProgressText, "--/--")
	end

	setText(arg0.detailTitleText, var4.name)
	setActive(arg0.detailBtnDetail, var11 == 1006 and not var5 and not var6)
	setActive(arg0.detailBtnGo, not var6 and not var5 and var11 ~= 1006)
	setActive(arg0.detailBtnGet, not var6 and var5 and not var8)
	setActive(arg0.detailBtnSubmit, not var6 and var5 and var8)
	setActive(arg0.detailActive, not var6 and not var5 and not var7)
	setImageSprite(arg0.detailIcon, LoadSprite(var20, var10))

	if #arg0.iconTfs < #arg0.awards then
		local var12 = #arg0.awards - #arg0.iconTfs

		for iter0 = 1, var12 do
			local var13 = tf(Instantiate(arg0.IconTpl))

			setParent(var13, arg0.detailAwardContent)
			setActive(var13, true)
			table.insert(arg0.iconTfs, var13)
		end
	end

	for iter1 = 1, #arg0.iconTfs do
		if iter1 <= #arg0.awards then
			local var14 = arg0.awards[iter1]
			local var15 = {
				type = var14[1],
				id = var14[2],
				count = var14[3]
			}

			updateDrop(arg0.iconTfs[iter1], var15)
			onButton(arg0, arg0.iconTfs[iter1], function()
				arg0:emit(BaseUI.ON_DROP, var15)
			end, SFX_PANEL)
			setActive(arg0.iconTfs[iter1], true)
		else
			setActive(arg0.iconTfs[iter1], false)
		end
	end
end

function var0.openSubmitPanel(arg0, arg1)
	setActive(arg0.submitPanel, true)

	local var0 = tonumber(arg1:getConfig("target_id_2"))
	local var1 = pg.activity_ryza_item[var0].name

	updateDrop(arg0.subimtItem, {
		type = DROP_TYPE_RYZA_DROP,
		id = tonumber(var0),
		count = arg1:getConfig("target_num")
	})
	setText(arg0.submitItemDesc, var1)
end

function var0.willExit(arg0)
	arg0.exitFlag = true

	if arg0.leanTweens and #arg0.leanTweens > 0 then
		for iter0, iter1 in pairs(arg0.leanTweens) do
			if LeanTween.isTweening(iter1) then
				LeanTween.cancel(iter1)
			end
		end

		arg0.leanTweens = {}
	end

	for iter2 = 1, #arg0.allDisplayTask do
		local var0 = arg0.allDisplayTask[iter2]

		if var0:isNew() then
			var0:changeNew()
		end
	end
end

return var0
