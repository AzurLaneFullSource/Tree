local var0 = class("StoryAwardPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.itemTpl = arg0:findTF("Item")
	arg0.taskItemTpl = arg0:findTF("TaskItem")
	arg0.scrollTF = arg0:findTF("Mask/ScrollView")
	arg0.container = arg0:findTF("Mask/ScrollView/Content")
	arg0.arrow = arg0:findTF("Mask/Arrow")
end

function var0.OnDataSetting(arg0)
	arg0.config = pg.activity_event_chapter_award[arg0.activity:getConfig("config_id")]
	arg0.chapterIDList = arg0.config.chapter
end

function var0.OnFirstFlush(arg0)
	for iter0 = 1, #arg0.chapterIDList do
		local var0 = arg0.chapterIDList[iter0]
		local var1 = pg.chapter_template[var0].chapter_name
		local var2 = cloneTplTo(arg0.taskItemTpl, arg0.container, "TaskItem" .. tostring(iter0))
		local var3 = arg0:findTF("TaskTitle/LevelBum", var2)
		local var4 = arg0:findTF("ItemListContainer", var2)
		local var5 = arg0:findTF("GotTag", var2)
		local var6 = arg0:findTF("GetBtn", var2)

		setText(var3, var1)

		for iter1 = 1, #arg0.config.award_display[iter0] do
			local var7 = cloneTplTo(arg0.itemTpl, var4)
			local var8 = arg0.config.award_display[iter0][iter1]
			local var9 = {
				type = var8[1],
				id = var8[2],
				count = var8[3]
			}

			updateDrop(var7, var9)
			onButton(arg0, var7, function()
				arg0:emit(BaseUI.ON_DROP, var9)
			end, SFX_PANEL)
		end

		onButton(arg0, var6, function()
			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0.activity.id,
				arg1 = var0
			})
		end, SFX_PANEL)
	end

	onScroll(arg0, arg0.scrollTF, function(arg0)
		setActive(arg0.arrow, arg0.y >= 0.01)
	end)
end

function var0.OnUpdateFlush(arg0)
	for iter0 = 1, #arg0.chapterIDList do
		local var0 = arg0.chapterIDList[iter0]
		local var1 = arg0:findTF("TaskItem" .. tostring(iter0), arg0.container)
		local var2 = arg0:findTF("GotTag", var1)
		local var3 = arg0:findTF("GetBtn", var1)
		local var4 = _.include(arg0.activity.data1_list, var0)

		if var4 then
			var1.transform:SetAsLastSibling()
		end

		local var5 = arg0:findTF("TaskTitle", var1)
		local var6 = arg0:findTF("ItemListContainer", var1)

		setGray(var5, var4)
		setGray(var6, var4)
		setActive(var2, var4)
		setActive(var3, getProxy(ChapterProxy):isClear(var0) and not var4)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
