local var0_0 = class("MedalTaskPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._parent = arg2_1
	arg0_1.UIMgr = pg.UIMgr.GetInstance()

	pg.DelegateInfo.New(arg0_1)

	arg0_1._mask = findTF(arg0_1._tf, "mask")
	arg0_1._backBtn = findTF(arg0_1._tf, "btnBack")
	arg0_1.UIlist = UIItemList.New(findTF(arg0_1._tf, "panel/list"), findTF(arg0_1._tf, "panel/list/Tasktpl"))

	onButton(arg0_1, arg0_1._mask, function()
		if arg0_1._parent.TASK_CLOSE_ANIM and arg0_1._parent.TASK_CLOSE_ANIM_Time then
			quickPlayAnimation(arg0_1._go, arg0_1._parent.TASK_CLOSE_ANIM)
			onDelayTick(function()
				arg0_1:SetActive(false)
			end, arg0_1._parent.TASK_CLOSE_ANIM_Time)
		else
			arg0_1:SetActive(false)
		end
	end, SFX_CANCEL)
	onButton(arg0_1, arg0_1._backBtn, function()
		if arg0_1._parent.TASK_CLOSE_ANIM and arg0_1._parent.TASK_CLOSE_ANIM_Time then
			quickPlayAnimation(arg0_1._go, arg0_1._parent.TASK_CLOSE_ANIM)
			onDelayTick(function()
				arg0_1:SetActive(false)
			end, arg0_1._parent.TASK_CLOSE_ANIM_Time)
		else
			arg0_1:SetActive(false)
		end
	end, SFX_CANCEL)
end

function var0_0.SetMedalGroup(arg0_6, arg1_6)
	arg0_6._medalGroup = arg1_6
	arg0_6._taskList = {}

	local var0_6 = arg0_6._medalGroup:GetMedalGroupActivityConfig()[3]

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var1_6 = getProxy(TaskProxy):getTaskById(iter1_6) or getProxy(TaskProxy):getFinishTaskById(iter1_6)

		table.insert(arg0_6._taskList, var1_6)
	end
end

function var0_0.ShowMedalTask(arg0_7)
	Canvas.ForceUpdateCanvases()
	arg0_7:sort(arg0_7._taskList)
	arg0_7:UpdateList(arg0_7._taskList)
end

function var0_0.getTaskProgress(arg0_8, arg1_8)
	return arg1_8:getProgress(), tostring(arg1_8:getProgress())
end

function var0_0.getTaskTarget(arg0_9, arg1_9)
	return arg1_9:getConfig("target_num"), tostring(arg1_9:getConfig("target_num"))
end

function var0_0.UpdateList(arg0_10, arg1_10)
	arg0_10.UIlist:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg1_10[arg1_11 + 1]
			local var1_11 = arg2_11:Find("frame/slider"):GetComponent(typeof(Slider))
			local var2_11 = arg2_11:Find("frame/progress")
			local var3_11 = arg2_11:Find("frame/progress_1")
			local var4_11 = arg2_11:Find("frame/awards")
			local var5_11 = arg2_11:Find("frame/desc")
			local var6_11 = arg2_11:Find("frame/get_btn")
			local var7_11 = arg2_11:Find("frame/got_btn")
			local var8_11 = arg2_11:Find("frame/go_btn")

			setText(var5_11, var0_11:getConfig("desc"))

			local var9_11, var10_11 = arg0_10:getTaskProgress(var0_11)
			local var11_11, var12_11 = arg0_10:getTaskTarget(var0_11)

			var1_11.value = var9_11 / var11_11

			setText(var2_11, var10_11)
			setText(var3_11, "/" .. var12_11)

			local var13_11 = var4_11:GetChild(0)

			arg0_10:updateAwards(var0_11:getConfig("award_display"), var4_11, var13_11)
			setActive(var7_11, var0_11:getTaskStatus() == 2)
			setActive(var6_11, var0_11:getTaskStatus() == 1)
			setActive(var8_11, var0_11:getTaskStatus() == 0)
			onButton(arg0_10, var8_11, function()
				arg0_10._parent:emit(MedalAlbumTemplateMediator.ON_TASK_GO, var0_11)
			end, SFX_PANEL)
			onButton(arg0_10, var6_11, function()
				arg0_10._parent:emit(MedalAlbumTemplateMediator.ON_TASK_SUBMIT, var0_11)
			end, SFX_PANEL)
		end
	end)
	arg0_10.UIlist:align(#arg1_10)

	if arg0_10._parent.TASK_ANIM and arg0_10._parent.TASK_ENTER_ANIM_Time and arg0_10._parent.TASK_Time then
		local var0_10 = findTF(arg0_10._tf, "panel/list").transform.childCount

		onDelayTick(function()
			for iter0_14 = 0, var0_10 - 1 do
				local var0_14 = findTF(arg0_10._tf, "panel/list"):GetChild(iter0_14)

				onDelayTick(function()
					if arg0_10._parent.exited then
						return
					end

					quickPlayAnimation(var0_14, arg0_10._parent.TASK_ANIM)
				end, arg0_10._parent.TASK_Time * (iter0_14 + 1))
			end
		end, arg0_10._parent.TASK_ENTER_ANIM_Time)
	end
end

function var0_0.updateAwards(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = _.slice(arg1_16, 1, 3)

	for iter0_16 = arg2_16.childCount, #var0_16 - 1 do
		cloneTplTo(arg3_16, arg2_16)
	end

	local var1_16 = arg2_16.childCount

	for iter1_16 = 1, var1_16 do
		local var2_16 = arg2_16:GetChild(iter1_16 - 1)
		local var3_16 = iter1_16 <= #var0_16

		setActive(var2_16, var3_16)

		if var3_16 then
			local var4_16 = var0_16[iter1_16]
			local var5_16 = {
				type = var4_16[1],
				id = var4_16[2],
				count = var4_16[3]
			}

			updateDrop(findTF(var2_16, "mask"), var5_16)

			if var5_16.type == DROP_TYPE_EQUIPMENT_SKIN then
				setActive(findTF(var2_16, "specialFrame"), true)
			else
				setActive(findTF(var2_16, "specialFrame"), false)
			end

			onButton(arg0_16, var2_16, function()
				arg0_16._parent:emit(BaseUI.ON_DROP, var5_16)
			end, SFX_PANEL)
		end
	end
end

function var0_0.sort(arg0_18, arg1_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg1_18) do
		if iter1_18:getTaskStatus() == 1 then
			table.insert(var0_18, iter1_18)
		end
	end

	for iter2_18, iter3_18 in pairs(arg1_18) do
		if iter3_18:getTaskStatus() == 0 then
			table.insert(var0_18, iter3_18)
		end
	end

	for iter4_18, iter5_18 in pairs(arg1_18) do
		if iter5_18:getTaskStatus() == 2 then
			table.insert(var0_18, iter5_18)
		end
	end

	arg0_18._taskList = var0_18
end

function var0_0.SetActive(arg0_19, arg1_19)
	SetActive(arg0_19._go, arg1_19)

	arg0_19._active = arg1_19

	if arg1_19 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_19._go, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_19._go, arg0_19._parent._tf)

		if arg0_19._parent.TASK_ANIM and arg0_19._parent.TASK_ENTER_ANIM_Time and arg0_19._parent.TASK_Time then
			local var0_19 = findTF(arg0_19._tf, "panel/list").transform.childCount

			for iter0_19 = 0, var0_19 - 1 do
				local var1_19 = findTF(arg0_19._tf, "panel/list"):GetChild(iter0_19)

				setCanvasGroupAlpha(var1_19, 0)
			end
		end
	end
end

function var0_0.IsActive(arg0_20)
	return arg0_20._active
end

function var0_0.Dispose(arg0_21)
	pg.DelegateInfo.Dispose(arg0_21)
end

return var0_0
