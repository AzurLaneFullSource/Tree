local var0 = class("LinerSignPage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.lockNamed = PLATFORM_CODE == PLATFORM_CH and LOCK_NAMED
	arg0.bg = arg0:findTF("AD")
	arg0.signTF = arg0:findTF("sign", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.signTF)
	arg0.uilist = UIItemList.New(arg0.items, arg0:findTF("tpl", arg0.items))
	arg0.signBtn = arg0:findTF("get", arg0.signTF)
	arg0.signGreyBtn = arg0:findTF("get_grey", arg0.signTF)
	arg0.countText = arg0:findTF("count_bg/count", arg0.signTF)
	arg0.namedTF = arg0:findTF("named", arg0.bg)
	arg0.nameInput = arg0:findTF("input/nickname", arg0.namedTF)
	arg0.sureBtn = arg0:findTF("sure", arg0.namedTF)
	arg0.linerTF = arg0:findTF("liner", arg0.bg)
	arg0.linerInput = arg0:findTF("name/input", arg0.linerTF)
	arg0.linerBtn = arg0:findTF("go", arg0.linerTF)

	setText(arg0:findTF("lock/Text", arg0.linerBtn), i18n("liner_sign_unlock_tip"))

	arg0.nameInput:GetComponent(typeof(InputField)).interactable = not arg0.lockNamed

	setActive(arg0:findTF("input/pan", arg0.namedTF), not arg0.lockNamed)

	arg0.linerInput:GetComponent(typeof(InputField)).interactable = not arg0.lockNamed

	setActive(arg0:findTF("name/edit", arg0.linerTF), not arg0.lockNamed)
end

function var0.OnDataSetting(arg0)
	arg0.nday = 0
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskGroup = underscore.flatten(arg0.activity:getConfig("config_data"))
	arg0.taskConfig = pg.task_data_template
	arg0.preStory = arg0.activity:getConfig("config_client").preStory

	return updateActivityTaskStatus(arg0.activity)
end

function var0.OnFirstFlush(arg0)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1
			local var1 = arg0.taskGroup[var0]
			local var2 = arg0:findTF("item_mask/item", arg2)
			local var3 = Drop.Create(arg0.taskConfig[var1].award_display[1])

			updateDrop(var2, var3)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var3)
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("ui/activityuipage/linersignpage_atlas", "D" .. var0, arg0:findTF("day", arg2), true)
		elseif arg0 == UIItemList.EventUpdate then
			local var4 = arg1 + 1
			local var5 = arg0.taskGroup[var4]
			local var6 = arg0.taskProxy:getTaskById(var5) or arg0.taskProxy:getFinishTaskById(var5)

			setActive(arg0:findTF("cur", arg2), var4 == arg0.nday)
			setActive(arg0:findTF("got", arg2), var4 < arg0.nday or var6 and var6:getTaskStatus() == 2)
		end
	end)
	onButton(arg0, arg0.signBtn, function()
		if not arg0.remainCnt or arg0.remainCnt <= 0 then
			return
		end

		seriesAsync({
			function(arg0)
				local var0 = arg0.activity:getConfig("config_client").story

				if checkExist(var0, {
					arg0.nday
				}, {
					1
				}) then
					pg.NewStoryMgr.GetInstance():Play(var0[arg0.nday][1], arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				if arg0.curTaskVO:getTaskStatus() == 1 then
					arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg0.curTaskVO, arg0)
				else
					arg0()
				end
			end
		})
	end, SFX_PANEL)

	arg0.defaultName = getProxy(PlayerProxy):getRawData():GetName()

	setInputText(arg0.nameInput, arg0.defaultName)
	onButton(arg0, arg0.sureBtn, function()
		local var0 = getInputText(arg0.nameInput)

		if var0 == "" then
			return
		end

		if var0 ~= arg0.defaultName and not nameValidityCheck(var0, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			return
		end

		arg0:emit(ActivityMediator.STORE_DATE, {
			actId = ActivityConst.LINER_NAMED_ID,
			strValue = var0,
			callback = function()
				arg0:OnUpdateFlush()
			end
		})
	end, SFX_PANEL)
	onInputEndEdit(arg0, arg0.linerInput, function(arg0)
		if not arg0:IsNamed() then
			return
		end

		if arg0 ~= arg0.defaultName and not nameValidityCheck(arg0, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			setInputText(arg0.linerInput, arg0.lastName)

			return
		else
			arg0:emit(ActivityMediator.STORE_DATE, {
				actId = ActivityConst.LINER_NAMED_ID,
				strValue = arg0,
				callback = function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_name_modify"))
					arg0:OnUpdateFlush()
				end
			})
		end
	end)
	onButton(arg0, arg0.linerBtn, function()
		if arg0:IsLockLiner() then
			return
		end

		seriesAsync({
			function(arg0)
				if arg0.preStory and arg0.preStory ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(arg0.preStory) then
					pg.NewStoryMgr.GetInstance():Play(arg0.preStory, arg0)
				else
					arg0()
				end
			end
		}, function()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LINER)
		end)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	local var0 = arg0:IsFinishSign()

	setActive(arg0.signTF, not var0)
	setActive(arg0.namedTF, var0 and not arg0:IsNamed())
	setActive(arg0.linerTF, var0 and arg0:IsNamed())
	setActive(arg0:findTF("lock", arg0.linerBtn), arg0:IsLockLiner())

	if not var0 then
		local var1 = arg0.taskGroup[arg0.nday]

		arg0.curTaskVO = arg0.taskProxy:getTaskById(var1) or arg0.taskProxy:getFinishTaskById(var1)
		arg0.remainCnt = math.min(arg0.activity:getDayIndex(), #arg0.taskGroup) - arg0.nday

		if arg0.curTaskVO:getTaskStatus() == 1 then
			arg0.remainCnt = arg0.remainCnt + 1
		end

		setActive(arg0.signBtn, arg0.remainCnt > 0)
		setActive(arg0.signGreyBtn, arg0.remainCnt <= 0)
		setText(arg0.countText, i18n("liner_sign_cnt_tip") .. arg0.remainCnt)
		arg0.uilist:align(#arg0.taskGroup)
	else
		arg0.lastName = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_NAMED_ID):getStrData1()

		setInputText(arg0.linerInput, arg0.lastName)
	end
end

function var0.IsFinishSign(arg0)
	local var0 = arg0.taskGroup[#arg0.taskGroup]
	local var1 = arg0.taskProxy:getTaskById(var0) or arg0.taskProxy:getFinishTaskById(var0)

	return var1 and var1:getTaskStatus() == 2
end

function var0.IsNamed(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_NAMED_ID)

	return var0 and not var0:isEnd() and var0:getStrData1() ~= ""
end

function var0.IsLockLiner(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_ID)

	return not var0 or var0:isEnd()
end

return var0
