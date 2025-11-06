local var0_0 = class("IslandTaskTrackCard")

var0_0.TYPES = {
	OTHER = 2,
	MAIN = 1
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.event = arg2_1
	arg0_1.type = arg3_1
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.iconTF = arg0_1._tf:Find("title/icon")
	arg0_1.nameTF = arg0_1._tf:Find("title/name")
	arg0_1.finishedTF = arg0_1._tf:Find("target/finished")
	arg0_1.unFinishTF = arg0_1._tf:Find("target/unfinish")
	arg0_1.targetUIList = UIItemList.New(arg0_1.unFinishTF, arg0_1.unFinishTF:Find("tpl"))

	arg0_1.targetUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateTargetItem(arg1_2, arg2_2)
		end
	end)

	arg0_1.targetBtnUIList = UIItemList.New(arg0_1._tf:Find("btns"), arg0_1._tf:Find("btns/tpl"))

	arg0_1.targetBtnUIList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_1:UpdateTargetBtnItem(arg1_3, arg2_3)
		end
	end)
end

function var0_0.UpdateTargetItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.task:GetTargetList()[arg1_4 + 1]
	local var1_4 = var0_4:IsFinish()

	setActive(arg2_4:Find("status/unfinish"), not var1_4)
	setActive(arg2_4:Find("status/finished"), var1_4)

	if var1_4 then
		arg2_4:GetComponent(typeof(Animation)):Play("Island3dTaskTrackPanel_tpl_finish_in")
	else
		arg2_4:GetComponent(typeof(Animation)):Play("Island3dTaskTrackPanel_tpl_unfinished_in")
	end

	GetOrAddComponent(arg2_4:Find("content"), "CanvasGroup").alpha = var1_4 and 0.5 or 1

	local var2_4 = arg0_4:GetMapTip(tonumber(var0_4:GetTrackParma()))

	if var2_4 and not var1_4 then
		setText(arg2_4:Find("content/Text"), var2_4)
		setText(arg2_4:Find("content/num"), "")
	else
		setText(arg2_4:Find("content/Text"), HXSet.hxLan(var0_4:getConfig("name")))

		local var3_4 = var0_4:GetProgress()
		local var4_4 = var0_4:GetTargetNum()

		setText(arg2_4:Find("content/num"), "(" .. (var3_4 < var4_4 and setColorStr(var3_4, "#dd374e") or var3_4) .. "/" .. var4_4 .. ")")
	end
end

function var0_0.Update(arg0_5, arg1_5, arg2_5)
	arg0_5.unlock = arg2_5
	arg0_5.task = arg1_5

	setActive(arg0_5._tf, arg0_5.task)

	if not arg0_5.task then
		return
	end

	arg0_5.curMapId = getProxy(IslandProxy):GetIsland():GetMapId()

	local var0_5 = arg0_5.task:GetShowType()

	GetImageSpriteFromAtlasAsync("island/islandtasktype", "track_" .. IslandTaskType.ShowTypeFields[var0_5], arg0_5.iconTF)
	setImageColor(arg0_5._tf:Find("title/bg"), Color.NewHex(IslandTaskType.ShowTypeTrackColors[var0_5]))
	setText(arg0_5.nameTF, HXSet.hxLan(arg0_5.task:GetName()))
	arg0_5:UpdateTarget()
	arg0_5:TrackUI()
end

function var0_0.UpdateProgress(arg0_6, arg1_6)
	arg0_6.task = arg1_6

	if not arg0_6.task then
		return
	end

	arg0_6:UpdateTarget()
	arg0_6:TrackUI()
end

function var0_0.UpdateTarget(arg0_7)
	local var0_7 = not arg0_7.task:IsSubmitImmediately() and arg0_7.task:IsFinish()
	local var1_7 = #arg0_7.task:GetTargetList()

	arg0_7.targetUIList:align(var1_7)
	arg0_7.targetBtnUIList:align(var1_7 + (var0_7 and 1 or 0))
	setActive(arg0_7.finishedTF, var0_7)

	if var0_7 then
		local var2_7 = arg0_7:GetMapTip(tonumber(arg0_7.task:GetTraceParam()))

		if var2_7 then
			setText(arg0_7.finishedTF:Find("Text"), var2_7)
		else
			setText(arg0_7.finishedTF:Find("Text"), HXSet.hxLan(arg0_7.task:GetFinishedDesc()))
		end
	end
end

function var0_0.RemoveTask(arg0_8)
	arg0_8:UnTrackUI()
	setActive(arg0_8._tf, false)
end

function var0_0.TrackUI(arg0_9)
	if not arg0_9.unlock then
		return
	end

	local var0_9 = arg0_9.task:GetTraceParam()
	local var1_9 = tonumber(var0_9)

	if var1_9 then
		if _IslandCore then
			_IslandCore:GetController():NotifiyCore(ISLAND_EVT.TRACKING, {
				id = var1_9,
				typ = arg0_9.task:GetType(),
				trackType = arg0_9.type
			})
		end
	else
		arg0_9:UnTrackUI()
	end
end

function var0_0.UnTrackUI(arg0_10)
	if not arg0_10.unlock then
		return
	end

	if _IslandCore then
		_IslandCore:GetController():NotifiyCore(ISLAND_EVT.UNTRACKING, arg0_10.type)
	end
end

function var0_0.GetMapTip(arg0_11, arg1_11)
	if not arg1_11 then
		return nil
	end

	local var0_11 = pg.island_world_objects[arg1_11]

	if not var0_11 then
		return nil
	end

	if arg0_11.curMapId == var0_11.mapId then
		return nil
	end

	return i18n("island_word_go") .. pg.island_map[var0_11.mapId].name
end

function var0_0._SkipBtn(arg0_12, arg1_12)
	local var0_12 = pg.island_main_btns[arg1_12]

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_12.ability_id) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_taskjump_systemnoopen_tips"))

		return
	end

	if var0_12.open_page ~= "" then
		arg0_12:emit(IslandMediator.OPEN_PAGE, var0_12.open_page, var0_12.page_param)
	end
end

function var0_0._SkipObj(arg0_13, arg1_13)
	local var0_13 = pg.island_world_objects[arg1_13].mapId

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockMap(var0_13) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_taskjump_placenoopen_tips"))

		return
	end

	arg0_13:emit(IslandBaseMediator.SWITCH_MAP, var0_13, pg.island_map[var0_13].born_object)
end

function var0_0.UpdateTargetBtnItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.task:GetTargetList()[arg1_14 + 1]
	local var1_14 = arg2_14:Find("btn")

	removeOnButton(var1_14)
	setActive(var1_14, false)

	if var0_14 then
		local var2_14 = pg.island_task_target[var0_14.id]
		local var3_14 = tonumber(var2_14.tips)
		local var4_14 = tonumber(var2_14.jump_ui)

		if not var0_14:IsFinish() then
			if var4_14 then
				setActive(var1_14, true)
				onButton(arg0_14, var1_14, function()
					arg0_14:_SkipBtn(var4_14)
				end, SFX_PANEL)
			elseif var3_14 then
				local var5_14 = pg.island_world_objects[var3_14].mapId

				if IslandMainBtnTipHelper.IsUnlock("map") and arg0_14.curMapId ~= var5_14 then
					setActive(var1_14, true)
					onButton(arg0_14, var1_14, function()
						arg0_14:_SkipObj(var3_14)
					end, SFX_PANEL)
				end
			end
		end
	else
		setActive(var1_14, false)

		local var6_14 = tonumber(arg0_14.task:getConfig("complete_data"))

		if var6_14 and var6_14 ~= 0 then
			local var7_14 = pg.island_world_objects[var6_14].mapId

			if IslandMainBtnTipHelper.IsUnlock("map") and arg0_14.curMapId ~= var7_14 then
				setActive(var1_14, true)
				onButton(arg0_14, var1_14, function()
					arg0_14:_SkipObj(var6_14)
				end, SFX_PANEL)
			end
		end
	end
end

function var0_0.emit(arg0_18, ...)
	arg0_18.event:emit(...)
end

function var0_0.Dispose(arg0_19)
	pg.DelegateInfo.Dispose(arg0_19)
end

return var0_0
