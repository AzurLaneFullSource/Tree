local var0_0 = class("RyzaTaskScene", import("..base.BaseUI"))
local var1_0 = "ryza_task_level_desc"
local var2_0 = "ryza_task_tag_explore"
local var3_0 = "ryza_task_tag_battle"
local var4_0 = "ryza_task_tag_dalegate"
local var5_0 = "ryza_task_tag_develop"
local var6_0 = {
	var2_0,
	var3_0,
	var4_0,
	var5_0
}
local var7_0 = "ryza_task_detail_content"
local var8_0 = "ryza_task_detail_award"
local var9_0 = "ryza_task_go"
local var10_0 = "ryza_task_get"
local var11_0 = "ryza_task_detail"
local var12_0 = "ryza_task_submit"
local var13_0 = "ryza_task_get_all"
local var14_0 = "ryza_task_confirm"
local var15_0 = "ryza_task_cancel"
local var16_0 = "ryza_task_level_num"
local var17_0 = "ryza_task_level_add"
local var18_0 = "ryza_task_empty_tag"
local var19_0 = "sub_item_warning"
local var20_0 = "ui/ryzaicon_atlas"

function var0_0.getUIName(arg0_1)
	return "RyzaTaskUI"
end

local var21_0 = 4
local var22_0 = 5
local var23_0 = 4

function var0_0.init(arg0_2)
	arg0_2.activityId = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_RYZA).id
	arg0_2.enterTaskId = arg0_2.contextData.task_id or nil
	arg0_2.taskGroups = pg.activity_template[arg0_2.activityId].config_data
	arg0_2.leanTweens = {}
	arg0_2.exitFlag = false

	local var0_2 = pg.activity_template[arg0_2.activityId].config_client

	arg0_2.ptName = pg.player_resource[var0_2.pt_id].name
	arg0_2.ptBuffs = var0_2.pt_buff
	arg0_2.maxNum = arg0_2.ptBuffs[#arg0_2.ptBuffs].pt[1]

	local var1_2 = findTF(arg0_2._tf, "ad")

	arg0_2.btnBack = findTF(var1_2, "btnBack")
	arg0_2.btnMain = findTF(var1_2, "btnMain")
	arg0_2.btnHelp = findTF(var1_2, "btnHelp")
	arg0_2.btnGetAll = findTF(var1_2, "btnGetAll")
	arg0_2.btnPoint = findTF(var1_2, "btnPoint")
	arg0_2.imgPoint = findTF(var1_2, "btnPoint/imgPoint")
	arg0_2.taskTagPanel = findTF(var1_2, "taskTagPanel")
	arg0_2.taskListPanel = findTF(var1_2, "taskListPanel")
	arg0_2.scrollRect = findTF(var1_2, "taskListPanel/Content"):GetComponent("LScrollRect")
	arg0_2.taskDetailPanel = findTF(var1_2, "taskDetailPanel")
	arg0_2.detailTag = findTF(arg0_2.taskDetailPanel, "tag")
	arg0_2.detailTitleText = findTF(arg0_2.taskDetailPanel, "title/text")
	arg0_2.detailIcon = findTF(arg0_2.taskDetailPanel, "icon/image")
	arg0_2.detailDescText = findTF(arg0_2.taskDetailPanel, "desc/text")
	arg0_2.detaiProgressText = findTF(arg0_2.taskDetailPanel, "progress/text")
	arg0_2.detailAwardContent = findTF(arg0_2.taskDetailPanel, "awardDisplay/viewport/content")
	arg0_2.detailBtnGo = findTF(arg0_2.taskDetailPanel, "btnGo")
	arg0_2.detailBtnGet = findTF(arg0_2.taskDetailPanel, "btnGet")
	arg0_2.detailBtnSubmit = findTF(arg0_2.taskDetailPanel, "btnSubmit")
	arg0_2.detailBtnDetail = findTF(arg0_2.taskDetailPanel, "btnDetail")
	arg0_2.detailActive = findTF(arg0_2.taskDetailPanel, "active")
	arg0_2.taskItemTpl = findTF(var1_2, "tpl/taskItemTpl")
	arg0_2.IconTpl = findTF(var1_2, "tpl/IconTpl")

	local var2_2 = findTF(arg0_2._tf, "pop")

	arg0_2.pointPanel = findTF(var2_2, "pointPanel")

	setActive(arg0_2.pointPanel, false)

	arg0_2.pointProgressText = findTF(arg0_2.pointPanel, "progressContent/progress")
	arg0_2.pointProgressSlider = findTF(arg0_2.pointPanel, "slider")
	arg0_2.pointLevelStar = findTF(arg0_2.pointPanel, "levelStar")
	arg0_2.pointStarTpl = findTF(arg0_2.pointPanel, "levelStar/starTpl")
	arg0_2.pointAdd = findTF(arg0_2.pointPanel, "add")
	arg0_2.pointClose = findTF(arg0_2.pointPanel, "btnClose")
	arg0_2.pointMask = findTF(arg0_2.pointPanel, "mask")
	arg0_2.submitPanel = findTF(var2_2, "submitPanel")
	arg0_2.submitDisplayContent = findTF(arg0_2.submitPanel, "itemDisplay/viewport/content")
	arg0_2.submitConfirm = findTF(arg0_2.submitPanel, "btnComfirm")
	arg0_2.submitCancel = findTF(arg0_2.submitPanel, "btnCancel")
	arg0_2.subimtItem = findTF(arg0_2.submitPanel, "itemDisplay/viewport/content/item")
	arg0_2.submitItemDesc = findTF(arg0_2.submitPanel, "itemDesc")
	arg0_2.btnCancel = findTF(arg0_2.submitPanel, "btnCancel")

	setText(findTF(arg0_2.btnPoint, "text"), i18n(var1_0))

	for iter0_2 = 1, var21_0 do
		local var3_2 = findTF(arg0_2.taskTagPanel, "btn" .. iter0_2)

		setText(findTF(var3_2, "off/text"), i18n(var6_0[iter0_2]))
		setText(findTF(var3_2, "on/text"), i18n(var6_0[iter0_2]))
	end

	setText(findTF(arg0_2.taskDetailPanel, "desc/title"), i18n(var7_0))
	setText(findTF(arg0_2.taskDetailPanel, "awardText"), i18n(var8_0))
	setText(findTF(arg0_2.taskDetailPanel, "btnGet/text"), i18n(var10_0))
	setText(findTF(arg0_2.taskDetailPanel, "btnGo/text"), i18n(var9_0))
	setText(findTF(arg0_2.taskDetailPanel, "btnSubmit/text"), i18n(var12_0))
	setText(findTF(arg0_2.taskDetailPanel, "btnDetail/text"), i18n(var11_0))
	setText(findTF(arg0_2.btnGetAll, "text"), i18n(var13_0))
	setText(findTF(arg0_2.submitPanel, "btnComfirm/text"), i18n(var14_0))
	setText(findTF(arg0_2.submitPanel, "btnCancel/text"), i18n(var15_0))
	setText(findTF(arg0_2.submitPanel, "bg/text"), i18n(var19_0))
	setText(findTF(arg0_2.pointPanel, "title"), i18n(var1_0))
	setText(findTF(arg0_2.pointPanel, "levelNum/text"), i18n(var16_0))
	setText(findTF(arg0_2.pointPanel, "levelBuff/text"), i18n(var17_0))

	arg0_2.pointStarTfs = {}

	local var4_2 = arg0_2.pointLevelStar.sizeDelta.x

	for iter1_2 = 1, #arg0_2.ptBuffs do
		local var5_2 = tf(Instantiate(arg0_2.pointStarTpl))

		SetParent(var5_2, arg0_2.pointLevelStar)
		setActive(var5_2, true)
		setText(findTF(var5_2, "bg/text"), iter1_2)
		setText(findTF(var5_2, "img/text"), iter1_2)

		local var6_2 = arg0_2.ptBuffs[iter1_2].pt[1]

		var5_2.anchoredPosition = Vector3(var6_2 / arg0_2.maxNum * var4_2, -18, 0)

		table.insert(arg0_2.pointStarTfs, var5_2)

		if iter1_2 == 1 then
			setActive(var5_2, false)
		end
	end

	arg0_2:updateTask()
end

function var0_0.updateTask(arg0_3, arg1_3)
	arg0_3.displayTask = {}
	arg0_3.allDisplayTask = {}

	local var0_3 = getProxy(ActivityTaskProxy):getTaskById(arg0_3.activityId)

	arg0_3.getAllTasks = {}

	for iter0_3 = 1, #var0_3 do
		local var1_3 = var0_3[iter0_3]
		local var2_3 = var1_3.id
		local var3_3 = var1_3:getProgress()
		local var4_3 = var1_3:getTarget()
		local var5_3 = var1_3:getConfig("ryza_type")
		local var6_3 = var1_3:getConfig("type")
		local var7_3 = var1_3:getConfig("sub_type")

		if var5_3 > 0 then
			if not arg0_3.displayTask[var5_3] then
				arg0_3.displayTask[var5_3] = {}
			end

			table.insert(arg0_3.displayTask[var5_3], var1_3)
			table.insert(arg0_3.allDisplayTask, var1_3)

			if not var1_3:isFinish() or var1_3:isOver() or var7_3 == 1006 then
				-- block empty
			else
				table.insert(arg0_3.getAllTasks, var2_3)
			end
		end
	end

	local var8_3 = getProxy(ActivityProxy):getActivityById(arg0_3.activityId)
	local var9_3 = {}

	if var8_3 then
		var9_3 = var8_3.data1_list
	end

	if var9_3 and #var9_3 > 0 then
		for iter1_3 = 1, #var9_3 do
			local var10_3 = var9_3[iter1_3]
			local var11_3 = ActivityTask.New(arg0_3.activityId, {
				progress = 0,
				id = var10_3
			})

			var11_3:setOver()

			local var12_3 = var11_3:getConfig("ryza_type")

			if var12_3 > 0 then
				if not arg0_3.displayTask[var12_3] then
					arg0_3.displayTask[var12_3] = {}
				end

				table.insert(arg0_3.displayTask[var12_3], var11_3)
				table.insert(arg0_3.allDisplayTask, var11_3)
			end
		end
	end

	local function var13_3(arg0_4, arg1_4)
		if arg0_4:isOver() and not arg1_4:isOver() then
			return false
		elseif not arg0_4:isOver() and arg1_4:isOver() then
			return true
		end

		if arg0_4:isFinish() and not arg1_4:isFinish() then
			return true
		elseif not arg0_4:isFinish() and arg1_4:isFinish() then
			return false
		end

		if arg0_4:isNew() and not arg1_4:isNew() then
			return true
		elseif not arg0_4:isNew() and arg1_4:isNew() then
			return false
		end

		if arg0_4.id > arg1_4.id then
			return false
		elseif arg0_4.id < arg1_4.id then
			return true
		end
	end

	for iter2_3, iter3_3 in pairs(arg0_3.displayTask) do
		table.sort(iter3_3, var13_3)
	end

	table.sort(arg0_3.allDisplayTask, var13_3)

	if arg1_3 then
		arg0_3:onClickTag()
	end

	if #arg0_3.getAllTasks > 0 then
		setActive(arg0_3.btnGetAll, true)
	else
		setActive(arg0_3.btnGetAll, false)
	end

	local var14_3 = getProxy(PlayerProxy):getData()[arg0_3.ptName] or 0
	local var15_3 = 1

	if var14_3 > arg0_3.maxNum then
		var14_3 = arg0_3.maxNum
	end

	for iter4_3 = #arg0_3.ptBuffs, 1, -1 do
		var15_3 = var14_3 >= arg0_3.ptBuffs[iter4_3].pt[1] and var15_3 < iter4_3 and iter4_3 or var15_3
	end

	for iter5_3 = 1, #arg0_3.pointStarTfs do
		local var16_3 = arg0_3.pointStarTfs[iter5_3]

		if iter5_3 <= var15_3 then
			setActive(findTF(var16_3, "img"), true)
		else
			setActive(findTF(var16_3, "img"), false)
		end
	end

	local var17_3 = arg0_3.ptBuffs[var15_3].benefit

	for iter6_3 = 1, #var17_3 do
		local var18_3 = var17_3[iter6_3]
		local var19_3 = pg.benefit_buff_template[var18_3].desc
		local var20_3 = findTF(arg0_3.pointPanel, "add/" .. iter6_3)

		if PLATFORM_CODE == PLATFORM_JP then
			findTF(var20_3, "img").sizeDelta = Vector2(450, 70)

			setText(findTF(var20_3, "text_jp"), var19_3)
		else
			setText(findTF(var20_3, "text"), var19_3)
		end
	end

	setSlider(arg0_3.pointProgressSlider, 0, arg0_3.maxNum, var14_3)
	setText(arg0_3.pointProgressText, var14_3 .. "/" .. arg0_3.maxNum)
	setText(findTF(arg0_3.btnPoint, "text"), i18n(var1_0) .. "Lv." .. var15_3)
	setText(findTF(arg0_3.pointPanel, "levelNum/num"), "Lv." .. var15_3)
	setText(findTF(arg0_3.pointPanel, "levelBuff/num"), "Lv." .. var15_3)
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.btnBack, function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.btnGetAll, function()
		local var0_7 = arg0_5.getAllTasks

		arg0_5:emit(RyzaTaskMediator.SUBMIT_TASK_ALL, {
			activityId = arg0_5.activityId,
			ids = var0_7
		})
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.btnPoint, function()
		if isActive(arg0_5.pointPanel) then
			setActive(arg0_5.pointPanel, false)
		else
			setActive(arg0_5.pointPanel, true)
		end
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.btnMain, function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_task_help_tip")
		})
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.detailBtnGo, function()
		local var0_11 = Task.New(arg0_5.selectTask)

		arg0_5:emit(RyzaTaskMediator.TASK_GO, {
			taskVO = var0_11
		})
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.pointMask, function()
		setActive(arg0_5.pointPanel, false)
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.pointClose, function()
		setActive(arg0_5.pointPanel, false)
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.detailBtnSubmit, function()
		local var0_14 = arg0_5.selectTask:getConfig("type")

		if arg0_5.selectTask:getConfig("sub_type") == 1006 then
			arg0_5:openSubmitPanel(arg0_5.selectTask)
		else
			arg0_5:emit(RyzaTaskMediator.SUBMIT_TASK, {
				activityId = arg0_5.activityId,
				id = arg0_5.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.detailBtnGet, function()
		local var0_15 = arg0_5.selectTask:getConfig("type")

		if arg0_5.selectTask:getConfig("sub_type") == 1006 then
			arg0_5:openSubmitPanel(arg0_5.selectTask)
		else
			arg0_5:emit(RyzaTaskMediator.SUBMIT_TASK, {
				activityId = arg0_5.activityId,
				id = arg0_5.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.detailBtnDetail, function()
		if arg0_5.selectTask then
			local var0_16 = tonumber(arg0_5.selectTask:getConfig("target_id_2"))

			if var0_16 and var0_16 > 0 then
				local var1_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)
				local var2_16 = AtelierMaterial.New({
					configId = var0_16,
					count = arg0_5.selectTask:getConfig("target_num")
				})

				arg0_5:emit(RyzaTaskMediator.SHOW_DETAIL, var2_16)
			end
		end
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.submitConfirm, function()
		arg0_5:emit(RyzaTaskMediator.SUBMIT_TASK, {
			activityId = arg0_5.activityId,
			id = arg0_5.selectTask.id
		})
		setActive(arg0_5.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5.submitCancel, function()
		setActive(arg0_5.submitPanel, false)
	end, SOUND_BACK)

	arg0_5.btnTags = {}

	for iter0_5 = 1, var21_0 do
		local var0_5 = iter0_5
		local var1_5 = findTF(arg0_5.taskTagPanel, "btn" .. var0_5)

		onButton(arg0_5, var1_5, function()
			if arg0_5.showTagIndex then
				setActive(findTF(arg0_5.btnTags[arg0_5.showTagIndex], "on"), false)

				if arg0_5.showTagIndex == var0_5 then
					arg0_5.showTagIndex = nil
				else
					arg0_5.showTagIndex = var0_5

					setActive(findTF(arg0_5.btnTags[arg0_5.showTagIndex], "on"), true)
				end
			else
				arg0_5.showTagIndex = var0_5

				setActive(findTF(arg0_5.btnTags[arg0_5.showTagIndex], "on"), true)
			end

			arg0_5:onClickTag()
		end)
		table.insert(arg0_5.btnTags, var1_5)
	end

	function arg0_5.scrollRect.onUpdateItem(arg0_20, arg1_20)
		arg0_5:onUpdateTaskItem(arg0_20, arg1_20)
	end

	arg0_5.iconTfs = {}
	arg0_5.awards = {}

	arg0_5:onClickTag()

	local var2_5 = false

	if PlayerPrefs.GetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id) ~= 1 then
		var2_5 = true
	end

	if var2_5 then
		PlayerPrefs.SetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id, 1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_task_help_tip")
		})
	end
end

function var0_0.onClickTag(arg0_21)
	print("点击了Tag")

	local var0_21 = arg0_21.showTagIndex

	if var0_21 and var0_21 > 0 then
		if arg0_21.displayTask[var0_21] and #arg0_21.displayTask[var0_21] > 0 then
			arg0_21.showTasks = arg0_21.displayTask[var0_21]
		else
			triggerButton(arg0_21.btnTags[arg0_21.showTagIndex])

			return
		end
	else
		arg0_21.showTasks = arg0_21.allDisplayTask
	end

	if arg0_21.enterTaskId and arg0_21.enterTaskId > 0 then
		for iter0_21 = 1, #arg0_21.showTasks do
			if arg0_21.showTasks[iter0_21].id == arg0_21.enterTaskId then
				arg0_21.scrollIndex = iter0_21
			end
		end
	end

	arg0_21.scrollRect:SetTotalCount(#arg0_21.showTasks, 0)

	if arg0_21.scrollIndex ~= nil then
		local var1_21 = arg0_21.scrollRect:HeadIndexToValue(arg0_21.scrollIndex - 1)

		arg0_21.scrollRect:ScrollTo(var1_21)
	end
end

function var0_0.onUpdateTaskItem(arg0_22, arg1_22, arg2_22)
	if arg0_22.exitFlag then
		return
	end

	arg0_22.leanTweens[arg2_22] = arg2_22

	table.insert(arg0_22.leanTweens, arg2_22)

	local var0_22 = GetComponent(arg2_22, typeof(CanvasGroup))

	var0_22.alpha = 0

	LeanTween.value(arg2_22, 0, 1, 0.3):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_23)
		var0_22.alpha = arg0_23
	end)):setOnComplete(System.Action(function()
		arg0_22.leanTweens[arg2_22] = nil
	end))

	arg1_22 = arg1_22 + 1

	local var1_22 = arg0_22.showTasks[arg1_22]
	local var2_22 = var1_22.id
	local var3_22 = var1_22:getProgress()
	local var4_22 = var1_22:getConfig("name")
	local var5_22 = var1_22:getConfig("ryza_icon")
	local var6_22 = var1_22:isOver()
	local var7_22 = var1_22:isFinish()
	local var8_22 = var1_22:isCircle()

	setActive(findTF(arg2_22, "selected"), arg0_22.selectIndex == arg1_22)
	setActive(findTF(arg2_22, "typeNew"), var1_22:isNew())
	setActive(findTF(arg2_22, "typeCircle"), var1_22:isCircle())
	setActive(findTF(arg2_22, "finish"), var6_22)
	setActive(findTF(arg2_22, "mask"), var6_22)
	setActive(findTF(arg2_22, "complete"), not var6_22 and var7_22 and not var8_22)
	setText(findTF(arg2_22, "desc/text"), shortenString(var4_22, 10))

	if not var5_22 or var5_22 == 0 then
		var5_22 = "attack"
	end

	setImageSprite(findTF(arg2_22, "icon/image"), LoadSprite(var20_0, var5_22))
	onButton(arg0_22, tf(arg2_22), function()
		if arg0_22.selectItem then
			setActive(findTF(arg0_22.selectItem, "selected"), false)
		end

		setActive(findTF(arg2_22, "selected"), true)

		arg0_22.selectIndex = arg1_22
		arg0_22.selectItem = arg2_22
		arg0_22.selectTask = var1_22

		arg0_22:updateDetail()
	end)

	if arg0_22.enterTaskId ~= nil and arg0_22.enterTaskId > 0 then
		if var2_22 == arg0_22.enterTaskId then
			triggerButton(arg2_22)

			arg0_22.enterTaskId = nil
			arg0_22.scrollIndex = nil
		end
	elseif arg1_22 == 1 then
		triggerButton(arg2_22)

		arg0_22.scrollIndex = nil
	end
end

function var0_0.updateDetail(arg0_26)
	local var0_26 = arg0_26.showTasks[arg0_26.selectIndex]
	local var1_26 = var0_26.id
	local var2_26 = var0_26:getProgress()
	local var3_26 = var0_26.target
	local var4_26 = pg.task_data_template[var1_26]
	local var5_26 = var0_26:isFinish()
	local var6_26 = var0_26:isOver()
	local var7_26 = var0_26:isCircle()
	local var8_26 = var0_26:isSubmit()

	arg0_26.awards = var4_26.award_display

	local var9_26 = var4_26.desc
	local var10_26 = var4_26.ryza_icon
	local var11_26 = var0_26:getConfig("sub_type")

	if not var10_26 or var10_26 == 0 then
		var10_26 = "attack"
	end

	if not var8_26 and var3_26 < var2_26 then
		var2_26 = var3_26
	end

	setText(arg0_26.detailDescText, var9_26)

	if not var6_26 then
		setText(arg0_26.detaiProgressText, var2_26 .. "/" .. var3_26)
	else
		setText(arg0_26.detaiProgressText, "--/--")
	end

	setText(arg0_26.detailTitleText, var4_26.name)
	setActive(arg0_26.detailBtnDetail, var11_26 == 1006 and not var5_26 and not var6_26)
	setActive(arg0_26.detailBtnGo, not var6_26 and not var5_26 and var11_26 ~= 1006)
	setActive(arg0_26.detailBtnGet, not var6_26 and var5_26 and not var8_26)
	setActive(arg0_26.detailBtnSubmit, not var6_26 and var5_26 and var8_26)
	setActive(arg0_26.detailActive, not var6_26 and not var5_26 and not var7_26)
	setImageSprite(arg0_26.detailIcon, LoadSprite(var20_0, var10_26))

	if #arg0_26.iconTfs < #arg0_26.awards then
		local var12_26 = #arg0_26.awards - #arg0_26.iconTfs

		for iter0_26 = 1, var12_26 do
			local var13_26 = tf(Instantiate(arg0_26.IconTpl))

			setParent(var13_26, arg0_26.detailAwardContent)
			setActive(var13_26, true)
			table.insert(arg0_26.iconTfs, var13_26)
		end
	end

	for iter1_26 = 1, #arg0_26.iconTfs do
		if iter1_26 <= #arg0_26.awards then
			local var14_26 = arg0_26.awards[iter1_26]
			local var15_26 = {
				type = var14_26[1],
				id = var14_26[2],
				count = var14_26[3]
			}

			updateDrop(arg0_26.iconTfs[iter1_26], var15_26)
			onButton(arg0_26, arg0_26.iconTfs[iter1_26], function()
				arg0_26:emit(BaseUI.ON_DROP, var15_26)
			end, SFX_PANEL)
			setActive(arg0_26.iconTfs[iter1_26], true)
		else
			setActive(arg0_26.iconTfs[iter1_26], false)
		end
	end
end

function var0_0.openSubmitPanel(arg0_28, arg1_28)
	setActive(arg0_28.submitPanel, true)

	local var0_28 = tonumber(arg1_28:getConfig("target_id_2"))
	local var1_28 = pg.activity_ryza_item[var0_28].name

	updateDrop(arg0_28.subimtItem, {
		type = DROP_TYPE_RYZA_DROP,
		id = tonumber(var0_28),
		count = arg1_28:getConfig("target_num")
	})
	setText(arg0_28.submitItemDesc, var1_28)
end

function var0_0.willExit(arg0_29)
	arg0_29.exitFlag = true

	if arg0_29.leanTweens and #arg0_29.leanTweens > 0 then
		for iter0_29, iter1_29 in pairs(arg0_29.leanTweens) do
			if LeanTween.isTweening(iter1_29) then
				LeanTween.cancel(iter1_29)
			end
		end

		arg0_29.leanTweens = {}
	end

	for iter2_29 = 1, #arg0_29.allDisplayTask do
		local var0_29 = arg0_29.allDisplayTask[iter2_29]

		if var0_29:isNew() then
			var0_29:changeNew()
		end
	end
end

return var0_0
