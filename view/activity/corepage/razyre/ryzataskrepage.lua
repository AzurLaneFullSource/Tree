local var0_0 = class("RyzaTaskRePage", import("view.activity.CorePage.CoreActivityPage"))
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
local var21_0 = 4
local var22_0 = 5
local var23_0 = 4

function var0_0.OnInit(arg0_1)
	arg0_1.activityId = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_RYZA).id
	arg0_1.enterTaskId = arg0_1.contextData.task_id or nil
	arg0_1.taskGroups = pg.activity_template[arg0_1.activityId].config_data
	arg0_1.leanTweens = {}
	arg0_1.exitFlag = false

	local var0_1 = pg.activity_template[arg0_1.activityId].config_client

	arg0_1.ptName = pg.player_resource[var0_1.pt_id].name
	arg0_1.ptBuffs = var0_1.pt_buff
	arg0_1.maxNum = arg0_1.ptBuffs[#arg0_1.ptBuffs].pt[1]

	local var1_1 = findTF(arg0_1._tf, "AD")

	arg0_1.btnBack = findTF(var1_1, "btnBack")
	arg0_1.btnMain = findTF(var1_1, "btnMain")
	arg0_1.btnHelp = findTF(var1_1, "btnHelp")
	arg0_1.btnGetAll = findTF(var1_1, "btnGetAll")
	arg0_1.btnPoint = findTF(var1_1, "btnPoint")
	arg0_1.imgPoint = findTF(var1_1, "btnPoint/imgPoint")
	arg0_1.taskTagPanel = findTF(var1_1, "taskTagPanel")
	arg0_1.taskListPanel = findTF(var1_1, "taskListPanel")
	arg0_1.scrollRect = findTF(var1_1, "taskListPanel/Content"):GetComponent("LScrollRect")
	arg0_1.taskDetailPanel = findTF(var1_1, "taskDetailPanel")
	arg0_1.detailTag = findTF(arg0_1.taskDetailPanel, "tag")
	arg0_1.detailTitleText = findTF(arg0_1.taskDetailPanel, "title/text")
	arg0_1.detailIcon = findTF(arg0_1.taskDetailPanel, "icon/image")
	arg0_1.detailDescText = findTF(arg0_1.taskDetailPanel, "desc/text")
	arg0_1.detaiProgressText = findTF(arg0_1.taskDetailPanel, "progress/text")
	arg0_1.detailAwardContent = findTF(arg0_1.taskDetailPanel, "awardDisplay/viewport/content")
	arg0_1.detailBtnGo = findTF(arg0_1.taskDetailPanel, "btnGo")
	arg0_1.detailBtnGet = findTF(arg0_1.taskDetailPanel, "btnGet")
	arg0_1.detailBtnSubmit = findTF(arg0_1.taskDetailPanel, "btnSubmit")
	arg0_1.detailBtnDetail = findTF(arg0_1.taskDetailPanel, "btnDetail")
	arg0_1.detailActive = findTF(arg0_1.taskDetailPanel, "active")
	arg0_1.taskItemTpl = findTF(var1_1, "tpl/taskItemTpl")
	arg0_1.IconTpl = findTF(var1_1, "tpl/IconTpl")

	local var2_1 = findTF(arg0_1._tf, "AD/pop")

	arg0_1.pointPanel = findTF(var2_1, "pointPanel")

	setActive(arg0_1.pointPanel, false)

	arg0_1.pointProgressText = findTF(arg0_1.pointPanel, "progressContent/progress")
	arg0_1.pointProgressSlider = findTF(arg0_1.pointPanel, "slider")
	arg0_1.pointLevelStar = findTF(arg0_1.pointPanel, "levelStar")
	arg0_1.pointStarTpl = findTF(arg0_1.pointPanel, "levelStar/starTpl")
	arg0_1.pointAdd = findTF(arg0_1.pointPanel, "add")
	arg0_1.pointClose = findTF(arg0_1.pointPanel, "btnClose")
	arg0_1.pointMask = findTF(arg0_1.pointPanel, "mask")
	arg0_1.submitPanel = findTF(var2_1, "submitPanel")
	arg0_1.submitDisplayContent = findTF(arg0_1.submitPanel, "itemDisplay/viewport/content")
	arg0_1.submitConfirm = findTF(arg0_1.submitPanel, "btnComfirm")
	arg0_1.submitCancel = findTF(arg0_1.submitPanel, "btnCancel")
	arg0_1.subimtItem = findTF(arg0_1.submitPanel, "itemDisplay/viewport/content/item")
	arg0_1.submitItemDesc = findTF(arg0_1.submitPanel, "itemDesc")
	arg0_1.btnCancel = findTF(arg0_1.submitPanel, "btnCancel")

	setText(findTF(arg0_1.btnPoint, "text"), i18n(var1_0))

	for iter0_1 = 1, var21_0 do
		local var3_1 = findTF(arg0_1.taskTagPanel, "btn" .. iter0_1)

		setText(findTF(var3_1, "off/text"), i18n(var6_0[iter0_1]))
		setText(findTF(var3_1, "on/text"), i18n(var6_0[iter0_1]))
	end

	setText(findTF(arg0_1.taskDetailPanel, "desc/title"), i18n(var7_0))
	setText(findTF(arg0_1.taskDetailPanel, "awardText"), i18n(var8_0))
	setText(findTF(arg0_1.taskDetailPanel, "btnGet/text"), i18n(var10_0))
	setText(findTF(arg0_1.taskDetailPanel, "btnGo/text"), i18n(var9_0))
	setText(findTF(arg0_1.taskDetailPanel, "btnSubmit/text"), i18n(var12_0))
	setText(findTF(arg0_1.taskDetailPanel, "btnDetail/text"), i18n(var11_0))
	setText(findTF(arg0_1.btnGetAll, "text"), i18n(var13_0))
	setText(findTF(arg0_1.submitPanel, "btnComfirm/text"), i18n(var14_0))
	setText(findTF(arg0_1.submitPanel, "btnCancel/text"), i18n(var15_0))
	setText(findTF(arg0_1.submitPanel, "bg/text"), i18n(var19_0))
	setText(findTF(arg0_1.pointPanel, "title"), i18n(var1_0))
	setText(findTF(arg0_1.pointPanel, "levelNum/text"), i18n(var16_0))
	setText(findTF(arg0_1.pointPanel, "levelBuff/text"), i18n(var17_0))

	arg0_1.pointStarTfs = {}

	local var4_1 = arg0_1.pointLevelStar.sizeDelta.x

	for iter1_1 = 1, #arg0_1.ptBuffs do
		local var5_1 = tf(Instantiate(arg0_1.pointStarTpl))

		SetParent(var5_1, arg0_1.pointLevelStar)
		setActive(var5_1, true)
		setText(findTF(var5_1, "bg/text"), iter1_1)
		setText(findTF(var5_1, "img/text"), iter1_1)

		local var6_1 = arg0_1.ptBuffs[iter1_1].pt[1]

		var5_1.anchoredPosition = Vector3(var6_1 / arg0_1.maxNum * var4_1, -18, 0)

		table.insert(arg0_1.pointStarTfs, var5_1)

		if iter1_1 == 1 then
			setActive(var5_1, false)
		end
	end

	arg0_1:updateTask()
end

function var0_0.updateTask(arg0_2, arg1_2)
	arg0_2.displayTask = {}
	arg0_2.allDisplayTask = {}

	local var0_2 = getProxy(ActivityTaskProxy):getTaskById(arg0_2.activityId)

	arg0_2.getAllTasks = {}

	for iter0_2 = 1, #var0_2 do
		local var1_2 = var0_2[iter0_2]
		local var2_2 = var1_2.id
		local var3_2 = var1_2:getProgress()
		local var4_2 = var1_2:getTarget()
		local var5_2 = var1_2:getConfig("ryza_type")
		local var6_2 = var1_2:getConfig("type")
		local var7_2 = var1_2:getConfig("sub_type")

		if var5_2 > 0 then
			if not arg0_2.displayTask[var5_2] then
				arg0_2.displayTask[var5_2] = {}
			end

			table.insert(arg0_2.displayTask[var5_2], var1_2)
			table.insert(arg0_2.allDisplayTask, var1_2)

			if not var1_2:isFinish() or var1_2:isOver() or var7_2 == 1006 then
				-- block empty
			else
				table.insert(arg0_2.getAllTasks, var2_2)
			end
		end
	end

	local var8_2 = getProxy(ActivityProxy):getActivityById(arg0_2.activityId)
	local var9_2 = {}

	if var8_2 then
		var9_2 = var8_2.data1_list
	end

	if var9_2 and #var9_2 > 0 then
		for iter1_2 = 1, #var9_2 do
			local var10_2 = var9_2[iter1_2]
			local var11_2 = ActivityTask.New(arg0_2.activityId, {
				progress = 0,
				id = var10_2
			})

			var11_2:setOver()

			local var12_2 = var11_2:getConfig("ryza_type")

			if var12_2 > 0 then
				if not arg0_2.displayTask[var12_2] then
					arg0_2.displayTask[var12_2] = {}
				end

				table.insert(arg0_2.displayTask[var12_2], var11_2)
				table.insert(arg0_2.allDisplayTask, var11_2)
			end
		end
	end

	local function var13_2(arg0_3, arg1_3)
		if arg0_3:isOver() and not arg1_3:isOver() then
			return false
		elseif not arg0_3:isOver() and arg1_3:isOver() then
			return true
		end

		if arg0_3:isFinish() and not arg1_3:isFinish() then
			return true
		elseif not arg0_3:isFinish() and arg1_3:isFinish() then
			return false
		end

		if arg0_3:isNew() and not arg1_3:isNew() then
			return true
		elseif not arg0_3:isNew() and arg1_3:isNew() then
			return false
		end

		if arg0_3.id > arg1_3.id then
			return false
		elseif arg0_3.id < arg1_3.id then
			return true
		end
	end

	for iter2_2, iter3_2 in pairs(arg0_2.displayTask) do
		table.sort(iter3_2, var13_2)
	end

	table.sort(arg0_2.allDisplayTask, var13_2)

	if arg1_2 then
		arg0_2:onClickTag()
	end

	if #arg0_2.getAllTasks > 0 then
		setActive(arg0_2.btnGetAll, true)
	else
		setActive(arg0_2.btnGetAll, false)
	end

	local var14_2 = getProxy(PlayerProxy):getData()[arg0_2.ptName] or 0
	local var15_2 = 1

	if var14_2 > arg0_2.maxNum then
		var14_2 = arg0_2.maxNum
	end

	for iter4_2 = #arg0_2.ptBuffs, 1, -1 do
		var15_2 = var14_2 >= arg0_2.ptBuffs[iter4_2].pt[1] and var15_2 < iter4_2 and iter4_2 or var15_2
	end

	for iter5_2 = 1, #arg0_2.pointStarTfs do
		local var16_2 = arg0_2.pointStarTfs[iter5_2]

		if iter5_2 <= var15_2 then
			setActive(findTF(var16_2, "img"), true)
		else
			setActive(findTF(var16_2, "img"), false)
		end
	end

	local var17_2 = arg0_2.ptBuffs[var15_2].benefit

	for iter6_2 = 1, #var17_2 do
		local var18_2 = var17_2[iter6_2]
		local var19_2 = pg.benefit_buff_template[var18_2].desc
		local var20_2 = findTF(arg0_2.pointPanel, "add/" .. iter6_2)

		if PLATFORM_CODE == PLATFORM_JP then
			findTF(var20_2, "img").sizeDelta = Vector2(450, 70)

			setText(findTF(var20_2, "text_jp"), var19_2)
		else
			setText(findTF(var20_2, "text"), var19_2)
		end
	end

	setSlider(arg0_2.pointProgressSlider, 0, arg0_2.maxNum, var14_2)
	setText(arg0_2.pointProgressText, var14_2 .. "/" .. arg0_2.maxNum)
	setText(findTF(arg0_2.btnPoint, "text"), i18n(var1_0) .. "Lv." .. var15_2)
	setText(findTF(arg0_2.pointPanel, "levelNum/num"), "Lv." .. var15_2)
	setText(findTF(arg0_2.pointPanel, "levelBuff/num"), "Lv." .. var15_2)
end

function var0_0.OnFirstFlush(arg0_4)
	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.btnGetAll, function()
		local var0_6 = arg0_4.getAllTasks

		pg.m02:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg0_4.activityId,
			task_ids = var0_6
		})
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.btnPoint, function()
		if isActive(arg0_4.pointPanel) then
			setActive(arg0_4.pointPanel, false)
		else
			setActive(arg0_4.pointPanel, true)
		end
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.btnMain, function()
		arg0_4:emit(BaseUI.ON_HOME)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_task_help_tip")
		})
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.detailBtnGo, function()
		local var0_10 = Task.New(arg0_4.selectTask)

		pg.m02:sendNotification(GAME.TASK_GO, {
			taskVO = var0_10
		})
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.pointMask, function()
		setActive(arg0_4.pointPanel, false)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.pointClose, function()
		setActive(arg0_4.pointPanel, false)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.detailBtnSubmit, function()
		local var0_13 = arg0_4.selectTask:getConfig("type")

		if arg0_4.selectTask:getConfig("sub_type") == 1006 then
			arg0_4:openSubmitPanel(arg0_4.selectTask)
		else
			pg.m02:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = arg0_4.activityId,
				task_ids = {
					arg0_4.selectTask.id
				}
			})
		end
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.detailBtnGet, function()
		local var0_14 = arg0_4.selectTask:getConfig("type")

		if arg0_4.selectTask:getConfig("sub_type") == 1006 then
			arg0_4:openSubmitPanel(arg0_4.selectTask)
		else
			pg.m02:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				act_id = arg0_4.activityId,
				task_ids = {
					arg0_4.selectTask.id
				}
			})
		end
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.detailBtnDetail, function()
		if arg0_4.selectTask then
			local var0_15 = tonumber(arg0_4.selectTask:getConfig("target_id_2"))

			if var0_15 and var0_15 > 0 then
				local var1_15 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)
				local var2_15 = AtelierMaterial.New({
					configId = var0_15,
					count = arg0_4.selectTask:getConfig("target_num")
				})

				arg0_4:emit(ActivityMediator.OPEN_LAYER, Context.New({
					mediator = AtelierMaterialDetailMediator,
					viewComponent = AtelierMaterialDetailLayer,
					data = {
						material = var2_15
					}
				}))
			end
		end
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.submitConfirm, function()
		pg.m02:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg0_4.activityId,
			task_ids = {
				arg0_4.selectTask.id
			}
		})
		setActive(arg0_4.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.submitCancel, function()
		setActive(arg0_4.submitPanel, false)
	end, SOUND_BACK)

	arg0_4.btnTags = {}

	for iter0_4 = 1, var21_0 do
		local var0_4 = iter0_4
		local var1_4 = findTF(arg0_4.taskTagPanel, "btn" .. var0_4)

		onButton(arg0_4, var1_4, function()
			if arg0_4.showTagIndex then
				setActive(findTF(arg0_4.btnTags[arg0_4.showTagIndex], "on"), false)

				if arg0_4.showTagIndex == var0_4 then
					arg0_4.showTagIndex = nil
				else
					arg0_4.showTagIndex = var0_4

					setActive(findTF(arg0_4.btnTags[arg0_4.showTagIndex], "on"), true)
				end
			else
				arg0_4.showTagIndex = var0_4

				setActive(findTF(arg0_4.btnTags[arg0_4.showTagIndex], "on"), true)
			end

			arg0_4:onClickTag()
		end)
		table.insert(arg0_4.btnTags, var1_4)
	end

	function arg0_4.scrollRect.onUpdateItem(arg0_19, arg1_19)
		arg0_4:onUpdateTaskItem(arg0_19, arg1_19)
	end

	arg0_4.iconTfs = {}
	arg0_4.awards = {}

	arg0_4:onClickTag()

	local var2_4 = false

	if PlayerPrefs.GetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id) ~= 1 then
		var2_4 = true
	end

	if var2_4 then
		PlayerPrefs.SetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id, 1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("ryza_task_help_tip")
		})
	end
end

function var0_0.onClickTag(arg0_20)
	print("点击了Tag")

	local var0_20 = arg0_20.showTagIndex

	if var0_20 and var0_20 > 0 then
		if arg0_20.displayTask[var0_20] and #arg0_20.displayTask[var0_20] > 0 then
			arg0_20.showTasks = arg0_20.displayTask[var0_20]
		else
			triggerButton(arg0_20.btnTags[arg0_20.showTagIndex])

			return
		end
	else
		arg0_20.showTasks = arg0_20.allDisplayTask
	end

	if arg0_20.enterTaskId and arg0_20.enterTaskId > 0 then
		for iter0_20 = 1, #arg0_20.showTasks do
			if arg0_20.showTasks[iter0_20].id == arg0_20.enterTaskId then
				arg0_20.scrollIndex = iter0_20
			end
		end
	end

	if isActive(arg0_20._tf) then
		arg0_20.scrollRect:SetTotalCount(#arg0_20.showTasks, 0)

		if arg0_20.scrollIndex ~= nil then
			local var1_20 = arg0_20.scrollRect:HeadIndexToValue(arg0_20.scrollIndex - 1)

			arg0_20.scrollRect:ScrollTo(var1_20)
		end
	end
end

function var0_0.onUpdateTaskItem(arg0_21, arg1_21, arg2_21)
	if arg0_21.exitFlag then
		return
	end

	arg0_21.leanTweens[arg2_21] = arg2_21

	table.insert(arg0_21.leanTweens, arg2_21)

	local var0_21 = GetComponent(arg2_21, typeof(CanvasGroup))

	var0_21.alpha = 0

	LeanTween.value(arg2_21, 0, 1, 0.3):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_22)
		var0_21.alpha = arg0_22
	end)):setOnComplete(System.Action(function()
		arg0_21.leanTweens[arg2_21] = nil
	end))

	arg1_21 = arg1_21 + 1

	local var1_21 = arg0_21.showTasks[arg1_21]
	local var2_21 = var1_21.id
	local var3_21 = var1_21:getProgress()
	local var4_21 = var1_21:getConfig("name")
	local var5_21 = var1_21:getConfig("ryza_icon")
	local var6_21 = var1_21:isOver()
	local var7_21 = var1_21:isFinish()
	local var8_21 = var1_21:isCircle()

	setActive(findTF(arg2_21, "selected"), arg0_21.selectIndex == arg1_21)
	setActive(findTF(arg2_21, "typeNew"), var1_21:isNew())
	setActive(findTF(arg2_21, "typeCircle"), var1_21:isCircle())
	setActive(findTF(arg2_21, "finish"), var6_21)
	setActive(findTF(arg2_21, "mask"), var6_21)
	setActive(findTF(arg2_21, "complete"), not var6_21 and var7_21 and not var8_21)
	setText(findTF(arg2_21, "desc/text"), shortenString(var4_21, 10))

	if not var5_21 or var5_21 == 0 then
		var5_21 = "attack"
	end

	setImageSprite(findTF(arg2_21, "icon/image"), LoadSprite(var20_0, var5_21))
	onButton(arg0_21, tf(arg2_21), function()
		if arg0_21.selectItem then
			setActive(findTF(arg0_21.selectItem, "selected"), false)
		end

		setActive(findTF(arg2_21, "selected"), true)

		arg0_21.selectIndex = arg1_21
		arg0_21.selectItem = arg2_21
		arg0_21.selectTask = var1_21

		arg0_21:updateDetail()
	end)

	if arg0_21.enterTaskId ~= nil and arg0_21.enterTaskId > 0 then
		if var2_21 == arg0_21.enterTaskId then
			triggerButton(arg2_21)

			arg0_21.enterTaskId = nil
			arg0_21.scrollIndex = nil
		end
	elseif arg1_21 == 1 then
		triggerButton(arg2_21)

		arg0_21.scrollIndex = nil
	end
end

function var0_0.updateDetail(arg0_25)
	local var0_25 = arg0_25.showTasks[arg0_25.selectIndex]
	local var1_25 = var0_25.id
	local var2_25 = var0_25:getProgress()
	local var3_25 = var0_25.target
	local var4_25 = pg.task_data_template[var1_25]
	local var5_25 = var0_25:isFinish()
	local var6_25 = var0_25:isOver()
	local var7_25 = var0_25:isCircle()
	local var8_25 = var0_25:isSubmit()

	arg0_25.awards = var4_25.award_display

	local var9_25 = var4_25.desc
	local var10_25 = var4_25.ryza_icon
	local var11_25 = var0_25:getConfig("sub_type")

	if not var10_25 or var10_25 == 0 then
		var10_25 = "attack"
	end

	if not var8_25 and var3_25 < var2_25 then
		var2_25 = var3_25
	end

	setText(arg0_25.detailDescText, var9_25)

	if not var6_25 then
		setText(arg0_25.detaiProgressText, var2_25 .. "/" .. var3_25)
	else
		setText(arg0_25.detaiProgressText, "--/--")
	end

	setText(arg0_25.detailTitleText, var4_25.name)
	setActive(arg0_25.detailBtnDetail, var11_25 == 1006 and not var5_25 and not var6_25)
	setActive(arg0_25.detailBtnGo, not var6_25 and not var5_25 and var11_25 ~= 1006)
	setActive(arg0_25.detailBtnGet, not var6_25 and var5_25 and not var8_25)
	setActive(arg0_25.detailBtnSubmit, not var6_25 and var5_25 and var8_25)
	setActive(arg0_25.detailActive, not var6_25 and not var5_25 and not var7_25)
	setImageSprite(arg0_25.detailIcon, LoadSprite(var20_0, var10_25))

	if #arg0_25.iconTfs < #arg0_25.awards then
		local var12_25 = #arg0_25.awards - #arg0_25.iconTfs

		for iter0_25 = 1, var12_25 do
			local var13_25 = tf(Instantiate(arg0_25.IconTpl))

			setParent(var13_25, arg0_25.detailAwardContent)
			setActive(var13_25, true)
			table.insert(arg0_25.iconTfs, var13_25)
		end
	end

	for iter1_25 = 1, #arg0_25.iconTfs do
		if iter1_25 <= #arg0_25.awards then
			local var14_25 = arg0_25.awards[iter1_25]
			local var15_25 = {
				type = var14_25[1],
				id = var14_25[2],
				count = var14_25[3]
			}

			updateDrop(arg0_25.iconTfs[iter1_25], var15_25)
			onButton(arg0_25, arg0_25.iconTfs[iter1_25], function()
				arg0_25:emit(BaseUI.ON_DROP, var15_25)
			end, SFX_PANEL)
			setActive(arg0_25.iconTfs[iter1_25], true)
		else
			setActive(arg0_25.iconTfs[iter1_25], false)
		end
	end
end

function var0_0.OnUpdateFlush(arg0_27)
	arg0_27:updateTask(true)
end

function var0_0.OnShowFlush(arg0_28)
	arg0_28:updateTask(true)
end

function var0_0.openSubmitPanel(arg0_29, arg1_29)
	setActive(arg0_29.submitPanel, true)

	local var0_29 = tonumber(arg1_29:getConfig("target_id_2"))
	local var1_29 = pg.activity_ryza_item[var0_29].name

	updateDrop(arg0_29.subimtItem, {
		type = DROP_TYPE_RYZA_DROP,
		id = tonumber(var0_29),
		count = arg1_29:getConfig("target_num")
	})
	setText(arg0_29.submitItemDesc, var1_29)
end

function var0_0.willExit(arg0_30)
	arg0_30.exitFlag = true

	if arg0_30.leanTweens and #arg0_30.leanTweens > 0 then
		for iter0_30, iter1_30 in pairs(arg0_30.leanTweens) do
			if LeanTween.isTweening(iter1_30) then
				LeanTween.cancel(iter1_30)
			end
		end

		arg0_30.leanTweens = {}
	end

	for iter2_30 = 1, #arg0_30.allDisplayTask do
		local var0_30 = arg0_30.allDisplayTask[iter2_30]

		if var0_30:isNew() then
			var0_30:changeNew()
		end
	end
end

return var0_0
