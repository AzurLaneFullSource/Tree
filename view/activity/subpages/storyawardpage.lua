local var0_0 = class("StoryAwardPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg")
	arg0_1.itemTpl = arg0_1:findTF("Item")
	arg0_1.taskItemTpl = arg0_1:findTF("TaskItem")
	arg0_1.scrollTF = arg0_1:findTF("Mask/ScrollView")
	arg0_1.container = arg0_1:findTF("Mask/ScrollView/Content")
	arg0_1.arrow = arg0_1:findTF("Mask/Arrow")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = pg.activity_event_chapter_award[arg0_2.activity:getConfig("config_id")]
	arg0_2.chapterIDList = arg0_2.config.chapter
end

function var0_0.OnFirstFlush(arg0_3)
	for iter0_3 = 1, #arg0_3.chapterIDList do
		local var0_3 = arg0_3.chapterIDList[iter0_3]
		local var1_3 = pg.chapter_template[var0_3].chapter_name
		local var2_3 = cloneTplTo(arg0_3.taskItemTpl, arg0_3.container, "TaskItem" .. tostring(iter0_3))
		local var3_3 = arg0_3:findTF("TaskTitle/LevelBum", var2_3)
		local var4_3 = arg0_3:findTF("ItemListContainer", var2_3)
		local var5_3 = arg0_3:findTF("GotTag", var2_3)
		local var6_3 = arg0_3:findTF("GetBtn", var2_3)

		setText(var3_3, var1_3)

		for iter1_3 = 1, #arg0_3.config.award_display[iter0_3] do
			local var7_3 = cloneTplTo(arg0_3.itemTpl, var4_3)
			local var8_3 = arg0_3.config.award_display[iter0_3][iter1_3]
			local var9_3 = {
				type = var8_3[1],
				id = var8_3[2],
				count = var8_3[3]
			}

			updateDrop(var7_3, var9_3)
			onButton(arg0_3, var7_3, function()
				arg0_3:emit(BaseUI.ON_DROP, var9_3)
			end, SFX_PANEL)
		end

		onButton(arg0_3, var6_3, function()
			arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0_3.activity.id,
				arg1 = var0_3
			})
		end, SFX_PANEL)
	end

	onScroll(arg0_3, arg0_3.scrollTF, function(arg0_6)
		setActive(arg0_3.arrow, arg0_6.y >= 0.01)
	end)
end

function var0_0.OnUpdateFlush(arg0_7)
	for iter0_7 = 1, #arg0_7.chapterIDList do
		local var0_7 = arg0_7.chapterIDList[iter0_7]
		local var1_7 = arg0_7:findTF("TaskItem" .. tostring(iter0_7), arg0_7.container)
		local var2_7 = arg0_7:findTF("GotTag", var1_7)
		local var3_7 = arg0_7:findTF("GetBtn", var1_7)
		local var4_7 = _.include(arg0_7.activity.data1_list, var0_7)

		if var4_7 then
			var1_7.transform:SetAsLastSibling()
		end

		local var5_7 = arg0_7:findTF("TaskTitle", var1_7)
		local var6_7 = arg0_7:findTF("ItemListContainer", var1_7)

		setGray(var5_7, var4_7)
		setGray(var6_7, var4_7)
		setActive(var2_7, var4_7)
		setActive(var3_7, getProxy(ChapterProxy):isClear(var0_7) and not var4_7)
	end
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
