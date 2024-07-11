local var0_0 = class("ChildishnessSchoolPtPage", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChildishnessSchoolPtPage"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.scrollPanel = arg0_2:findTF("window/panel")
	arg0_2.UIlist = UIItemList.New(arg0_2:findTF("window/panel/list"), arg0_2:findTF("window/panel/list/item"))
	arg0_2.ptTF = arg0_2:findTF("window/top/pt")
	arg0_2.totalTxt = arg0_2:findTF("window/top/pt/Text"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.getBtn = arg0_2:findTF("window/btn_get")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3.anim:Play("anim_kinder_schoolPT_out")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3.anim:Play("anim_kinder_schoolPT_out")
	end, SFX_PANEL)
	arg0_3:Show()

	arg0_3.anim = arg0_3._tf:GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3.anim:GetComponent(typeof(DftAniEvent))

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3:closeView()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Show(arg0_7)
	arg0_7:UpdatePtData()

	local var0_7 = arg0_7.ptData.dropList
	local var1_7 = arg0_7.ptData.targets
	local var2_7 = arg0_7.ptData.level
	local var3_7 = arg0_7.ptData.count

	arg0_7:updateResIcon(arg0_7.ptData.resId, arg0_7.ptData.resIcon, arg0_7.ptData.type)
	arg0_7:UpdateList(var0_7, var1_7, var2_7)

	arg0_7.totalTxt.text = var3_7

	Canvas.ForceUpdateCanvases()
end

function var0_0.UpdateList(arg0_8, arg1_8, arg2_8, arg3_8)
	assert(#arg1_8 == #arg2_8)
	arg0_8.UIlist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8[arg1_9 + 1]
			local var1_9 = arg2_8[arg1_9 + 1]

			setText(arg2_9:Find("title/Text"), "PHASE " .. arg1_9 + 1)
			setText(arg2_9:Find("target/Text"), var1_9)

			if arg2_9:Find("target/icon") then
				if arg0_8.resIcon == "" then
					arg0_8.resIcon = nil
				end

				if arg0_8.resIcon then
					LoadImageSpriteAsync(arg0_8.resIcon, arg2_9:Find("target/icon"), false)
				end

				setActive(arg2_9:Find("target/icon"), arg0_8.resIcon)
			end

			local var2_9 = Drop.Create(var0_9)

			updateDrop(arg2_9:Find("award/mask"), var2_9, {
				hideName = true
			})

			if var2_9.type == DROP_TYPE_ITEM and var2_9:getSubClass():getConfig("type") == 9 then
				setActive(arg2_9:Find("award/specialFrame"), true)
			else
				setActive(arg2_9:Find("award/specialFrame"), false)
			end

			onButton(arg0_8, arg2_9:Find("award"), function()
				arg0_8:emit(BaseUI.ON_DROP, var2_9)
			end, SFX_PANEL)

			local var3_9 = arg0_8.ptData:GetDroptItemState(arg1_9 + 1)

			if var3_9 == ActivityPtData.STATE_LOCK then
				setActive(arg2_9:Find("mask_get"), false)
				setActive(arg2_9:Find("mask_got"), false)
			elseif var3_9 == ActivityPtData.STATE_CAN_GET then
				setActive(arg2_9:Find("mask_get"), true)
				setActive(arg2_9:Find("mask_got"), false)
			else
				setActive(arg2_9:Find("mask_get"), false)
				setActive(arg2_9:Find("mask_got"), true)
			end
		end
	end)
	arg0_8.UIlist:align(#arg1_8)

	local var0_8 = arg0_8.scrollPanel:GetComponent("ScrollRect")

	scrollTo(arg0_8.scrollPanel, 0, 1 - arg3_8 * 145 / (#arg2_8 * 145 - 7 - 591))

	if arg0_8.ptData:CanGetAward() then
		setActive(arg0_8.getBtn, true)
		onButton(arg0_8, arg0_8.getBtn, function()
			local var0_11 = {}
			local var1_11 = {}
			local var2_11 = arg0_8.ptData:GetLevel()
			local var3_11 = arg0_8.ptData:GetCurrLevel()

			for iter0_11 = var2_11 + 1, var3_11 do
				local var4_11 = arg1_8[iter0_11]
				local var5_11 = false

				for iter1_11, iter2_11 in pairs(var1_11) do
					if iter2_11[1] == var4_11[1] and iter2_11[2] == var4_11[2] then
						var5_11 = true
						iter2_11[3] = iter2_11[3] + var4_11[3]

						break
					end
				end

				if not var5_11 then
					table.insert(var1_11, var4_11)
				end
			end

			local var6_11 = getProxy(PlayerProxy):getRawData()
			local var7_11 = pg.gameset.urpt_chapter_max.description[1]
			local var8_11 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var7_11)
			local var9_11, var10_11 = Task.StaticJudgeOverflow(var6_11.gold, var6_11.oil, var8_11, true, true, var1_11)

			if var9_11 then
				table.insert(var0_11, function(arg0_12)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var10_11,
						onYes = arg0_12
					})
				end)
			end

			seriesAsync(var0_11, function()
				local var0_13 = arg0_8.ptData:GetCurrTarget()

				arg0_8:emit(ChildishnessSchoolPtMediator.EVENT_PT_OPERATION, {
					cmd = 4,
					activity_id = arg0_8.ptData:GetId(),
					arg1 = var0_13
				})
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_8.getBtn, false)
		removeOnButton(arg0_8.getBtn)
	end
end

function var0_0.updateResIcon(arg0_14, arg1_14, arg2_14, arg3_14)
	if arg3_14 == 2 or arg3_14 ~= 3 and arg3_14 ~= 4 and arg3_14 ~= 5 and arg3_14 ~= 6 then
		if arg1_14 then
			arg0_14.resIcon = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg1_14
			}):getIcon()
		elseif arg2_14 then
			arg0_14.resIcon = arg2_14
		end
	end
end

function var0_0.UpdatePtData(arg0_15)
	local var0_15 = getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_PT_ACT_ID)

	arg0_15.ptData = ActivityPtData.New(var0_15)
end

function var0_0.willExit(arg0_16)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf)
end

return var0_0
