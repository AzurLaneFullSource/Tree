local var0_0 = class("LinerSignPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.lockNamed = PLATFORM_CODE == PLATFORM_CH and LOCK_NAMED
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.signTF = arg0_1:findTF("sign", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.signTF)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1:findTF("tpl", arg0_1.items))
	arg0_1.signBtn = arg0_1:findTF("get", arg0_1.signTF)
	arg0_1.signGreyBtn = arg0_1:findTF("get_grey", arg0_1.signTF)
	arg0_1.countText = arg0_1:findTF("count_bg/count", arg0_1.signTF)
	arg0_1.namedTF = arg0_1:findTF("named", arg0_1.bg)
	arg0_1.nameInput = arg0_1:findTF("input/nickname", arg0_1.namedTF)
	arg0_1.sureBtn = arg0_1:findTF("sure", arg0_1.namedTF)
	arg0_1.linerTF = arg0_1:findTF("liner", arg0_1.bg)
	arg0_1.linerInput = arg0_1:findTF("name/input", arg0_1.linerTF)
	arg0_1.linerBtn = arg0_1:findTF("go", arg0_1.linerTF)

	setText(arg0_1:findTF("lock/Text", arg0_1.linerBtn), i18n("liner_sign_unlock_tip"))

	arg0_1.nameInput:GetComponent(typeof(InputField)).interactable = not arg0_1.lockNamed

	setActive(arg0_1:findTF("input/pan", arg0_1.namedTF), not arg0_1.lockNamed)

	arg0_1.linerInput:GetComponent(typeof(InputField)).interactable = not arg0_1.lockNamed

	setActive(arg0_1:findTF("name/edit", arg0_1.linerTF), not arg0_1.lockNamed)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = underscore.flatten(arg0_2.activity:getConfig("config_data"))
	arg0_2.taskConfig = pg.task_data_template
	arg0_2.preStory = arg0_2.activity:getConfig("config_client").preStory

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			local var0_4 = arg1_4 + 1
			local var1_4 = arg0_3.taskGroup[var0_4]
			local var2_4 = arg0_3:findTF("item_mask/item", arg2_4)
			local var3_4 = Drop.Create(arg0_3.taskConfig[var1_4].award_display[1])

			updateDrop(var2_4, var3_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var3_4)
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("ui/activityuipage/linersignpage_atlas", "D" .. var0_4, arg0_3:findTF("day", arg2_4), true)
		elseif arg0_4 == UIItemList.EventUpdate then
			local var4_4 = arg1_4 + 1
			local var5_4 = arg0_3.taskGroup[var4_4]
			local var6_4 = arg0_3.taskProxy:getTaskById(var5_4) or arg0_3.taskProxy:getFinishTaskById(var5_4)

			setActive(arg0_3:findTF("cur", arg2_4), var4_4 == arg0_3.nday)
			setActive(arg0_3:findTF("got", arg2_4), var4_4 < arg0_3.nday or var6_4 and var6_4:getTaskStatus() == 2)
		end
	end)
	onButton(arg0_3, arg0_3.signBtn, function()
		if not arg0_3.remainCnt or arg0_3.remainCnt <= 0 then
			return
		end

		seriesAsync({
			function(arg0_7)
				local var0_7 = arg0_3.activity:getConfig("config_client").story

				if checkExist(var0_7, {
					arg0_3.nday
				}, {
					1
				}) then
					pg.NewStoryMgr.GetInstance():Play(var0_7[arg0_3.nday][1], arg0_7)
				else
					arg0_7()
				end
			end,
			function(arg0_8)
				if arg0_3.curTaskVO:getTaskStatus() == 1 then
					arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.curTaskVO, arg0_8)
				else
					arg0_8()
				end
			end
		})
	end, SFX_PANEL)

	arg0_3.defaultName = getProxy(PlayerProxy):getRawData():GetName()

	setInputText(arg0_3.nameInput, arg0_3.defaultName)
	onButton(arg0_3, arg0_3.sureBtn, function()
		local var0_9 = getInputText(arg0_3.nameInput)

		if var0_9 == "" then
			return
		end

		if var0_9 ~= arg0_3.defaultName and not nameValidityCheck(var0_9, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			return
		end

		arg0_3:emit(ActivityMediator.STORE_DATE, {
			actId = ActivityConst.LINER_NAMED_ID,
			strValue = var0_9,
			callback = function()
				arg0_3:OnUpdateFlush()
			end
		})
	end, SFX_PANEL)
	onInputEndEdit(arg0_3, arg0_3.linerInput, function(arg0_11)
		if not arg0_3:IsNamed() then
			return
		end

		if arg0_11 ~= arg0_3.defaultName and not nameValidityCheck(arg0_11, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			setInputText(arg0_3.linerInput, arg0_3.lastName)

			return
		else
			arg0_3:emit(ActivityMediator.STORE_DATE, {
				actId = ActivityConst.LINER_NAMED_ID,
				strValue = arg0_11,
				callback = function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_name_modify"))
					arg0_3:OnUpdateFlush()
				end
			})
		end
	end)
	onButton(arg0_3, arg0_3.linerBtn, function()
		if arg0_3:IsLockLiner() then
			return
		end

		seriesAsync({
			function(arg0_14)
				if arg0_3.preStory and arg0_3.preStory ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_3.preStory) then
					pg.NewStoryMgr.GetInstance():Play(arg0_3.preStory, arg0_14)
				else
					arg0_14()
				end
			end
		}, function()
			arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LINER)
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_16)
	arg0_16.nday = arg0_16.activity.data3

	local var0_16 = arg0_16:IsFinishSign()

	setActive(arg0_16.signTF, not var0_16)
	setActive(arg0_16.namedTF, var0_16 and not arg0_16:IsNamed())
	setActive(arg0_16.linerTF, var0_16 and arg0_16:IsNamed())
	setActive(arg0_16:findTF("lock", arg0_16.linerBtn), arg0_16:IsLockLiner())

	if not var0_16 then
		local var1_16 = arg0_16.taskGroup[arg0_16.nday]

		arg0_16.curTaskVO = arg0_16.taskProxy:getTaskById(var1_16) or arg0_16.taskProxy:getFinishTaskById(var1_16)
		arg0_16.remainCnt = math.min(arg0_16.activity:getDayIndex(), #arg0_16.taskGroup) - arg0_16.nday

		if arg0_16.curTaskVO:getTaskStatus() == 1 then
			arg0_16.remainCnt = arg0_16.remainCnt + 1
		end

		setActive(arg0_16.signBtn, arg0_16.remainCnt > 0)
		setActive(arg0_16.signGreyBtn, arg0_16.remainCnt <= 0)
		setText(arg0_16.countText, i18n("liner_sign_cnt_tip") .. arg0_16.remainCnt)
		arg0_16.uilist:align(#arg0_16.taskGroup)
	else
		arg0_16.lastName = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_NAMED_ID):getStrData1()

		setInputText(arg0_16.linerInput, arg0_16.lastName)
	end
end

function var0_0.IsFinishSign(arg0_17)
	local var0_17 = arg0_17.taskGroup[#arg0_17.taskGroup]
	local var1_17 = arg0_17.taskProxy:getTaskById(var0_17) or arg0_17.taskProxy:getFinishTaskById(var0_17)

	return var1_17 and var1_17:getTaskStatus() == 2
end

function var0_0.IsNamed(arg0_18)
	local var0_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_NAMED_ID)

	return var0_18 and not var0_18:isEnd() and var0_18:getStrData1() ~= ""
end

function var0_0.IsLockLiner(arg0_19)
	local var0_19 = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_ID)

	return not var0_19 or var0_19:isEnd()
end

return var0_0
