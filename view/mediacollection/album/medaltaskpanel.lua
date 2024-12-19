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
		arg0_1:SetActive(false)
	end, SFX_CANCEL)
	onButton(arg0_1, arg0_1._backBtn, function()
		arg0_1:SetActive(false)
	end, SFX_CANCEL)
end

function var0_0.SetMedalGroup(arg0_4, arg1_4)
	arg0_4._medalGroup = arg1_4
	arg0_4._taskList = {}

	local var0_4 = arg0_4._medalGroup:GetMedalGroupActivityConfig()[3]

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var1_4 = getProxy(TaskProxy):getTaskById(iter1_4) or getProxy(TaskProxy):getFinishTaskById(iter1_4)

		table.insert(arg0_4._taskList, var1_4)
	end
end

function var0_0.ShowMedalTask(arg0_5)
	Canvas.ForceUpdateCanvases()
	arg0_5:sort(arg0_5._taskList)
	arg0_5:UpdateList(arg0_5._taskList)
end

function var0_0.getTaskProgress(arg0_6, arg1_6)
	return arg1_6:getProgress(), tostring(arg1_6:getProgress())
end

function var0_0.getTaskTarget(arg0_7, arg1_7)
	return arg1_7:getConfig("target_num"), tostring(arg1_7:getConfig("target_num"))
end

function var0_0.UpdateList(arg0_8, arg1_8)
	arg0_8.UIlist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8[arg1_9 + 1]
			local var1_9 = arg2_9:Find("frame/slider"):GetComponent(typeof(Slider))
			local var2_9 = arg2_9:Find("frame/progress")
			local var3_9 = arg2_9:Find("frame/awards")
			local var4_9 = arg2_9:Find("frame/desc")
			local var5_9 = arg2_9:Find("frame/get_btn")
			local var6_9 = arg2_9:Find("frame/got_btn")
			local var7_9 = arg2_9:Find("frame/go_btn")

			setText(var4_9, var0_9:getConfig("desc"))

			local var8_9, var9_9 = arg0_8:getTaskProgress(var0_9)
			local var10_9, var11_9 = arg0_8:getTaskTarget(var0_9)

			var1_9.value = var8_9 / var10_9

			setText(var2_9, var9_9 .. "/" .. var11_9)

			local var12_9 = var3_9:GetChild(0)

			arg0_8:updateAwards(var0_9:getConfig("award_display"), var3_9, var12_9)
			setActive(var6_9, var0_9:getTaskStatus() == 2)
			setActive(var5_9, var0_9:getTaskStatus() == 1)
			setActive(var7_9, var0_9:getTaskStatus() == 0)
			onButton(arg0_8, var7_9, function()
				arg0_8._parent:emit(MedalAlbumTemplateMediator.ON_TASK_GO, var0_9)
			end, SFX_PANEL)
			onButton(arg0_8, var5_9, function()
				arg0_8._parent:emit(MedalAlbumTemplateMediator.ON_TASK_SUBMIT, var0_9)
			end, SFX_PANEL)
		end
	end)
	arg0_8.UIlist:align(#arg1_8)
end

function var0_0.updateAwards(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = _.slice(arg1_12, 1, 3)

	for iter0_12 = arg2_12.childCount, #var0_12 - 1 do
		cloneTplTo(arg3_12, arg2_12)
	end

	local var1_12 = arg2_12.childCount

	for iter1_12 = 1, var1_12 do
		local var2_12 = arg2_12:GetChild(iter1_12 - 1)
		local var3_12 = iter1_12 <= #var0_12

		setActive(var2_12, var3_12)

		if var3_12 then
			local var4_12 = var0_12[iter1_12]
			local var5_12 = {
				type = var4_12[1],
				id = var4_12[2],
				count = var4_12[3]
			}

			updateDrop(findTF(var2_12, "mask"), var5_12)

			if var5_12.type == DROP_TYPE_EQUIPMENT_SKIN then
				setActive(findTF(var2_12, "specialFrame"), true)
			else
				setActive(findTF(var2_12, "specialFrame"), false)
			end

			onButton(arg0_12, var2_12, function()
				arg0_12._parent:emit(BaseUI.ON_DROP, var5_12)
			end, SFX_PANEL)
		end
	end
end

function var0_0.sort(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg1_14) do
		if iter1_14:getTaskStatus() == 1 then
			table.insert(var0_14, iter1_14)
		end
	end

	for iter2_14, iter3_14 in pairs(arg1_14) do
		if iter3_14:getTaskStatus() == 0 then
			table.insert(var0_14, iter3_14)
		end
	end

	for iter4_14, iter5_14 in pairs(arg1_14) do
		if iter5_14:getTaskStatus() == 2 then
			table.insert(var0_14, iter5_14)
		end
	end

	arg0_14._taskList = var0_14
end

function var0_0.SetActive(arg0_15, arg1_15)
	SetActive(arg0_15._go, arg1_15)

	arg0_15._active = arg1_15

	if arg1_15 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_15._go, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_15._go, arg0_15._parent._tf)
	end
end

function var0_0.IsActive(arg0_16)
	return arg0_16._active
end

function var0_0.Dispose(arg0_17)
	pg.DelegateInfo.Dispose(arg0_17)
end

return var0_0
